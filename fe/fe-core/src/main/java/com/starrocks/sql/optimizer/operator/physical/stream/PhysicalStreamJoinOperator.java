// This file is licensed under the Elastic License 2.0. Copyright 2021-present, StarRocks Inc.

package com.starrocks.sql.optimizer.operator.physical.stream;

import com.starrocks.analysis.JoinOperator;
import com.starrocks.sql.optimizer.OptExpression;
import com.starrocks.sql.optimizer.OptExpressionVisitor;
import com.starrocks.sql.optimizer.operator.OperatorType;
import com.starrocks.sql.optimizer.operator.OperatorVisitor;
import com.starrocks.sql.optimizer.operator.Projection;
import com.starrocks.sql.optimizer.operator.scalar.ScalarOperator;

import java.util.Objects;

public class PhysicalStreamJoinOperator extends PhysicalStreamOperator {

    private final JoinOperator joinType;
    private final ScalarOperator onPredicate;
    private final String joinHint;

    public PhysicalStreamJoinOperator(JoinOperator joinType, ScalarOperator onPredicate, String joinHint, long limit,
                                      ScalarOperator predicate, Projection projection) {
        super(OperatorType.PHYSICAL_STREAM_JOIN);
        this.joinType = joinType;
        this.onPredicate = onPredicate;
        this.joinHint = joinHint;
        this.limit = limit;
        this.predicate = predicate;
        this.projection = projection;
    }

    public JoinOperator getJoinType() {
        return joinType;
    }

    public ScalarOperator getOnPredicate() {
        return onPredicate;
    }

    public String getJoinHint() {
        return joinHint;
    }


    @Override
    public <R, C> R accept(OperatorVisitor<R, C> visitor, C context) {
        return visitor.visitPhysicalStreamJoin(this, context);
    }

    @Override
    public <R, C> R accept(OptExpressionVisitor<R, C> visitor, OptExpression optExpression, C context) {
        return visitor.visitPhysicalStreamJoin(optExpression, context);
    }

    @Override
    public String toString() {
        return "PhysicalStreamJoinOperator{"
                + "joinType=" + joinType + ", joinPredicate=" + onPredicate + ", limit=" + limit
                + ", predicate=" + predicate + '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        if (!super.equals(o)) {
            return false;
        }
        PhysicalStreamJoinOperator that = (PhysicalStreamJoinOperator) o;
        return joinType == that.joinType && Objects.equals(onPredicate, that.onPredicate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), joinType, onPredicate);
    }
}
