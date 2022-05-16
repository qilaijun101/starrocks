// This file is licensed under the Elastic License 2.0. Copyright 2021-present, StarRocks Limited.

lexer grammar StarRocksLex;
@parser::members {public static long sqlMode;}
tokens {
    CONCAT
}

ADD: 'ADD';
ADMIN: 'ADMIN';
ALL: 'ALL';
ALTER: 'ALTER';
ANALYZE: 'ANALYZE';
AND: 'AND';
ANTI: 'ANTI';
ARRAY: 'ARRAY';
AS: 'AS';
ASC: 'ASC';
ASYNC: 'ASYNC';
AVG: 'AVG';
BACKEND: 'BACKEND';
BETWEEN: 'BETWEEN';
BIGINT: 'BIGINT';
BITMAP: 'BITMAP';
BOOLEAN: 'BOOLEAN';
BUCKETS: 'BUCKETS';
BY: 'BY';
CASE: 'CASE';
CAST: 'CAST';
CATALOG: 'CATALOG';
CATALOGS: 'CATALOGS';
CHAR: 'CHAR';
CONFIG: 'CONFIG';
COLLATE: 'COLLATE';
CONNECTION_ID: 'CONNECTION_ID';
COLUMN: 'COLUMN';
COLUMNS: 'COLUMNS';
COMMENT: 'COMMENT';
COMMIT: 'COMMIT';
COSTS: 'COSTS';
COUNT: 'COUNT';
CREATE: 'CREATE';
CROSS: 'CROSS';
CUBE: 'CUBE';
CURRENT: 'CURRENT';
CURRENT_USER: 'CURRENT_USER';
DATA: 'DATA';
DATABASE: 'DATABASE';
DATABASES: 'DATABASES';
DATE: 'DATE';
DATETIME: 'DATETIME';
DAY: 'DAY';
DECIMAL: 'DECIMAL';
DECIMALV2: 'DECIMALV2';
DECIMAL32: 'DECIMAL32';
DECIMAL64: 'DECIMAL64';
DECIMAL128: 'DECIMAL128';
DEFAULT: 'DEFAULT';
DELETE: 'DELETE';
DENSE_RANK: 'DENSE_RANK';
DESC: 'DESC';
DESCRIBE: 'DESCRIBE';
DISTINCT: 'DISTINCT';
DISTRIBUTED: 'DISTRIBUTED';
DOUBLE: 'DOUBLE';
DROP: 'DROP';
DUAL: 'DUAL';
ELSE: 'ELSE';
END: 'END';
EXCEPT: 'EXCEPT';
EXISTS: 'EXISTS';
EXPLAIN: 'EXPLAIN';
EXTERNAL: 'EXTERNAL';
EXTRACT: 'EXTRACT';
EVERY: 'EVERY';
FALSE: 'FALSE';
FILTER: 'FILTER';
FIRST: 'FIRST';
FIRST_VALUE: 'FIRST_VALUE';
FLOAT: 'FLOAT';
FN: 'FN';
FOLLOWING: 'FOLLOWING';
FOLLOWER: 'FOLLOWER';
FOR: 'FOR';
FORMAT: 'FORMAT';
FREE: 'FREE';
FROM: 'FROM';
FRONTEND: 'FRONTEND';
FULL: 'FULL';
GLOBAL: 'GLOBAL';
GRANT: 'GRANT';
GROUP: 'GROUP';
GROUPING: 'GROUPING';
GROUPING_ID: 'GROUPING_ID';
HASH: 'HASH';
HAVING: 'HAVING';
HLL: 'HLL';
HOUR: 'HOUR';
IF: 'IF';
IN: 'IN';
INDEX: 'INDEX';
INNER: 'INNER';
INSERT: 'INSERT';
INT: 'INT';
INTEGER: 'INTEGER';
INTERSECT: 'INTERSECT';
INTERVAL: 'INTERVAL';
INTO: 'INTO';
IS: 'IS';
JOIN: 'JOIN';
JSON: 'JSON';
LABEL: 'LABEL';
LAG: 'LAG';
LARGEINT: 'LARGEINT';
LAST: 'LAST';
LAST_VALUE: 'LAST_VALUE';
LATERAL: 'LATERAL';
LEAD: 'LEAD';
LEFT: 'LEFT';
LESS: 'LESS';
LIKE: 'LIKE';
LIMIT: 'LIMIT';
LOCAL: 'LOCAL';
LOGICAL: 'LOGICAL';
MANUAL: 'MANUAL';
MATERIALIZED: 'MATERIALIZED';
MAX: 'MAX';
MAXVALUE: 'MAXVALUE';
MERGE: 'MERGE';
MIN: 'MIN';
MINUTE: 'MINUTE';
MINUS: 'MINUS';
MOD: 'MOD';
MONTH: 'MONTH';
NONE: 'NONE';
NOT: 'NOT';
NULL: 'NULL';
NULLS: 'NULLS';
OBSERVER: 'OBSERVER';
OFFSET: 'OFFSET';
ON: 'ON';
OR: 'OR';
ORDER: 'ORDER';
OUTER: 'OUTER';
OUTFILE: 'OUTFILE';
OVER: 'OVER';
PARTITION: 'PARTITION';
PARTITIONS: 'PARTITIONS';
PASSWORD: 'PASSWORD';
PRECEDING: 'PRECEDING';
PERCENTILE: 'PERCENTILE';
PRIMARY: 'PRIMARY';
PROPERTIES: 'PROPERTIES';
QUARTER: 'QUARTER';
RANGE: 'RANGE';
RANK: 'RANK';
REFRESH: 'REFRESH';
REGEXP: 'REGEXP';
RESOURCE_GROUP: 'RESOURCE_GROUP';
RESOURCE_GROUPS: 'RESOURCE_GROUPS';
REVOKE: 'REVOKE';
REPLACE: 'REPLACE';
REPLICA: 'REPLICA';
RENAME: 'RENAME';
RIGHT: 'RIGHT';
RLIKE: 'RLIKE';
ROLLBACK: 'ROLLBACK';
ROLLUP: 'ROLLUP';
ROW: 'ROW';
ROWS: 'ROWS';
ROW_NUMBER: 'ROW_NUMBER';
SUBMIT: 'SUBMIT';
SCHEMA: 'SCHEMA';
SECOND: 'SECOND';
SELECT: 'SELECT';
SEMI: 'SEMI';
SESSION: 'SESSION';
SET: 'SET';
SETS: 'SETS';
SET_VAR: 'SET_VAR';
SHOW: 'SHOW';
SMALLINT: 'SMALLINT';
START: 'START';
STATUS: 'STATUS';
STRING: 'STRING';
SUM: 'SUM';
SYNC: 'SYNC';
SYSTEM: 'SYSTEM';
TABLE: 'TABLE';
TABLES: 'TABLES';
TABLET: 'TABLET';
TASK: 'TASK';
TEMPORARY: 'TEMPORARY';
THAN: 'THAN';
THEN: 'THEN';
TIME: 'TIME';
TIMESTAMPADD: 'TIMESTAMPADD';
TIMESTAMPDIFF: 'TIMESTAMPDIFF';
TINYINT: 'TINYINT';
TO: 'TO';
TRUE: 'TRUE';
TYPE: 'TYPE';
UNBOUNDED: 'UNBOUNDED';
UNION: 'UNION';
UPDATE: 'UPDATE';
USE: 'USE';
USER: 'USER';
USING: 'USING';
VALUES: 'VALUES';
VARCHAR: 'VARCHAR';
VARIABLES: 'VARIABLES';
VERBOSE: 'VERBOSE';
VIEW: 'VIEW';
WEEK: 'WEEK';
WHEN: 'WHEN';
WHERE: 'WHERE';
WITH: 'WITH';
YEAR: 'YEAR';
FORCE: 'FORCE';


EQ  : '=';
NEQ : '<>' | '!=';
LT  : '<';
LTE : '<=';
GT  : '>';
GTE : '>=';
EQ_FOR_NULL: '<=>';

PLUS_SYMBOL: '+';
MINUS_SYMBOL: '-';
ASTERISK_SYMBOL: '*';
SLASH_SYMBOL: '/';
PERCENT_SYMBOL: '%';

LOGICAL_OR: '||' {setType((StarRocksParser.sqlMode & com.starrocks.qe.SqlModeHelper.MODE_PIPES_AS_CONCAT) == 0 ? LOGICAL_OR : StarRocksParser.CONCAT);};
LOGICAL_AND: '&&';
LOGICAL_NOT: '!';

INT_DIV: 'DIV';
BITAND: '&';
BITOR: '|';
BITXOR: '^';
BITNOT: '~';

ARROW: '->';
AT: '@';

INTEGER_VALUE
    : DIGIT+
    ;

DECIMAL_VALUE
    : DIGIT+ '.' DIGIT*
    | '.' DIGIT+
    ;

DOUBLE_VALUE
    : DIGIT+ ('.' DIGIT*)? EXPONENT
    | '.' DIGIT+ EXPONENT
    ;

SINGLE_QUOTED_TEXT
    : '\'' ( ~'\'' | '\'\'' )* '\''
    ;

DOUBLE_QUOTED_TEXT
    : '"' ( '\\'. | '""' | ~('"'| '\\') )* '"'
    ;

IDENTIFIER
    : (LETTER | '_') (LETTER | DIGIT | '_')*
    ;

DIGIT_IDENTIFIER
    : DIGIT (LETTER | DIGIT | '_')+
    ;

QUOTED_IDENTIFIER
    : '"' ( ~'"' | '""' )* '"'
    ;

BACKQUOTED_IDENTIFIER
    : '`' ( ~'`' | '``' )* '`'
    ;

fragment EXPONENT
    : 'E' [+-]? DIGIT+
    ;

fragment DIGIT
    : [0-9]
    ;

fragment LETTER
    : [a-zA-Z_$\u0080-\uffff]
    ;

SIMPLE_COMMENT
    : '--' ~[\r\n]* '\r'? '\n'? -> channel(HIDDEN)
    ;

BRACKETED_COMMENT
    : '/*' ~'+' .*? '*/' -> channel(HIDDEN)
    ;

SEMICOLON: ';';

WS
    : [ \r\n\t]+ -> channel(HIDDEN)
    ;
