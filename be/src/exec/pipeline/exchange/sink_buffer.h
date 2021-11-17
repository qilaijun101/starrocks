// This file is licensed under the Elastic License 2.0. Copyright 2021 StarRocks Limited.

#pragma once

#include <mutex>
#include <queue>

#include "column/chunk.h"
#include "gen_cpp/BackendService.h"
#include "runtime/current_thread.h"
#include "util/blocking_queue.hpp"
#include "util/brpc_stub_cache.h"
#include "util/callback_closure.h"
#include "util/defer_op.h"

namespace starrocks::pipeline {

using PTransmitChunkParamsPtr = std::shared_ptr<PTransmitChunkParams>;

struct TransmitChunkInfo {
    // For BUCKET_SHFFULE_HASH_PARTITIONED, multiple channels may be related to
    // a same exchange source fragment instance, so we should use fragment_instance_id
    // of the destination as the key of destination instead of channel_id.
    TUniqueId fragment_instance_id;
    doris::PBackendService_Stub* brpc_stub;
    PTransmitChunkParamsPtr params;
    butil::IOBuf attachment;
};

class SinkBuffer {
public:
    SinkBuffer(MemTracker* mem_tracker, const std::vector<TPlanFragmentDestination>& destinations, size_t num_sinkers)
            : _mem_tracker(mem_tracker) {
        for (const auto& dest : destinations) {
            const auto& dest_instance_id = dest.fragment_instance_id;

            auto it = _num_sinkers_per_dest_instance.find(dest_instance_id);
            if (it != _num_sinkers_per_dest_instance.end()) {
                it->second += num_sinkers;
            } else {
                _num_sinkers_per_dest_instance[dest_instance_id] = num_sinkers;

                // This dest_instance_id first occurs, so create closure and buffer for it.
                auto* closure = new CallBackClosure<PTransmitChunkResult>();
                closure->ref();
                closure->addFailedHandler([this]() noexcept {
                    _in_flight_rpc_num--;
                    _is_cancelled = true;
                    LOG(WARNING) << " transmit chunk rpc failed";
                });
                closure->addSuccessHandler([this](const PTransmitChunkResult& result) noexcept {
                    _in_flight_rpc_num--;
                    Status status(result.status());
                    if (!status.ok()) {
                        _is_cancelled = true;
                        LOG(WARNING) << " transmit chunk rpc failed, " << status.message();
                    }
                });
                _closures[dest_instance_id] = closure;

                _buffers[dest_instance_id] = std::queue<TransmitChunkInfo>();
            }
        }

        try {
            _thread = std::thread{&SinkBuffer::process, this};
        } catch (const std::exception& exp) {
            LOG(FATAL) << "[ExchangeSinkOperator] create thread: " << exp.what();
        } catch (...) {
            LOG(FATAL) << "[ExchangeSinkOperator] create thread: unknown";
        }
    }

    ~SinkBuffer() {
        _is_finished = true;
        _buffer_empty_cv.notify_one();
        _thread.join();

        // TODO(hcf) is_finish() unable to judge such situation that when process()
        // pickup request from buffer and before transmitting through brpc.
        // at this moment, _in_flight_rpc_num equals 0 and no closure is in flight
        // but it is going to send packet. To handle this properly, we need to wait
        // all the closure finish its io job
        for (auto& [_, closure] : _closures) {
            auto cntl = &closure->cntl;
            brpc::Join(cntl->call_id());
            if (closure->unref()) {
                delete closure;
            }
        }
        for (auto& [_, buffer] : _buffers) {
            while (!buffer.empty()) {
                auto& info = buffer.front();
                info.params->release_finst_id();
                buffer.pop();
            }
        }
    }

    void add_request(const TransmitChunkInfo& request) {
        if (_is_finished) {
            request.params->release_finst_id();
            return;
        }
        std::lock_guard<std::mutex> l(_mutex);
        _buffers[request.fragment_instance_id].push(request);
        _buffer_empty_cv.notify_one();
    }

    void process() {
        try {
            MemTracker* prev_tracker = tls_thread_status.set_mem_tracker(_mem_tracker);
            DeferOp op([&] { tls_thread_status.set_mem_tracker(prev_tracker); });

            while (!_is_finished) {
                {
                    std::unique_lock<std::mutex> l(_mutex);
                    bool is_buffer_empty = true;
                    for (auto& [_, buffer] : _buffers) {
                        if (!buffer.empty()) {
                            is_buffer_empty = false;
                            break;
                        }
                    }
                    if (is_buffer_empty) {
                        _buffer_empty_cv.wait(l);
                    }
                }

                const size_t spin_threshould = 100;
                size_t spin_iter = 0;

                for (; spin_iter < spin_threshould; ++spin_iter) {
                    bool find_any = false;
                    for (auto& [_, buffer] : _buffers) {
                        if (buffer.empty()) {
                            continue;
                        }

                        // std::queue' read is concurrent safe without mutex
                        if (!_closures[buffer.front().fragment_instance_id]->has_in_flight_rpc()) {
                            TransmitChunkInfo info = buffer.front();
                            find_any = true;
                            _send_rpc(info);
                            {
                                std::lock_guard<std::mutex> l(_mutex);
                                buffer.pop();
                            }
                            info.params->release_finst_id();
                        }
                    }

                    if (find_any) {
                        spin_iter = 0;
                    }
                }

                // Find none ready closure after multiply spin, just wait for a while
#ifdef __x86_64__
                _mm_pause();
#else
                sched_yield();
#endif
            }
        } catch (const std::exception& exp) {
            LOG(FATAL) << "[ExchangeSinkOperator] sink_buffer::process: " << exp.what();
        } catch (...) {
            LOG(FATAL) << "[ExchangeSinkOperator] sink_buffer::process: UNKNOWN";
        }
    }

    bool is_full() const {
        // TODO(hcf) if one channel is congested, it may cause all other channel unwritable
        // std::queue' read is concurrent safe without mutex
        for (auto& [_, buffer] : _buffers) {
            if (buffer.size() > config::pipeline_io_buffer_size) {
                return true;
            }
        }
        return false;
    }

    bool is_finished() const {
        if (_is_cancelled) {
            return true;
        }

        if (_in_flight_rpc_num > 0) {
            return false;
        }

        for (auto& [_, closure] : _closures) {
            if (closure->has_in_flight_rpc()) {
                return false;
            }
        }

        for (auto& [_, buffer] : _buffers) {
            if (!buffer.empty()) {
                return false;
            }
        }

        return true;
    }

    bool is_cancelled() const { return _is_cancelled; }

private:
    void _send_rpc(TransmitChunkInfo& request) {
        if (request.params->eos()) {
            // Only the last eos is sent to ExchangeSourceOperator. it must be guaranteed that
            // eos is the last packet to send to finish the input stream of the corresponding of
            // ExchangeSourceOperator and eos is sent exactly-once.
            if (--_num_sinkers_per_dest_instance[request.fragment_instance_id] > 0) {
                if (request.params->chunks_size() == 0) {
                    return;
                } else {
                    request.params->set_eos(false);
                }
            }
        }

        request.params->set_sequence(_request_seq++);

        auto* closure = _closures[request.fragment_instance_id];
        DCHECK(!closure->has_in_flight_rpc());
        closure->ref();
        closure->cntl.Reset();
        closure->cntl.set_timeout_ms(500);
        closure->cntl.request_attachment().append(request.attachment);
        _in_flight_rpc_num++;
        request.brpc_stub->transmit_chunk(&closure->cntl, request.params.get(), &closure->result, closure);
    }

    // To avoid lock
    MemTracker* _mem_tracker = nullptr;
    std::unordered_map<TUniqueId, size_t> _num_sinkers_per_dest_instance;
    int64_t _request_seq = 0;
    std::atomic<int32_t> _in_flight_rpc_num = 0;
    std::atomic_bool _is_cancelled = false;

    std::unordered_map<TUniqueId, CallBackClosure<PTransmitChunkResult>*> _closures;
    std::unordered_map<TUniqueId, std::queue<TransmitChunkInfo>> _buffers;
    std::condition_variable _buffer_empty_cv;
    std::mutex _mutex;

    std::thread _thread;
    std::atomic_bool _is_finished = false;
};

} // namespace starrocks::pipeline
