-- Create a Kudu table in Impala
USE test_db;
CREATE TABLE IF NOT EXISTS destination_kudu
(
col1 string,
col2 decimal,
primary key ())
PARTITION BY HASH(col1) PARTITIONS 10
STORED AS KUDU
TBLPROPERTIES(
'SOURCE' = 'upstream.source.location',
'SECURITY_CLASSIFICATION' = 'OPEN',
'LOAD_FREQUENCY' = 'STREAMING',
'CONTACT_INFO' = 'team@company.com',
'col1' = 'column one comment',
'col2' = 'column two comment'
)