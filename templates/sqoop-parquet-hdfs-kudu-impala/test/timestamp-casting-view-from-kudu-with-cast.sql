-- Create a Parquet table in Impala
USE test_db;
CREATE VIEW IF NOT EXISTS destination_kudu_casted AS SELECT
        col1  COMMENT 'column one comment',
        cast(col2 as timestamp) COMMENT 'column two comment'
FROM destination_kudu