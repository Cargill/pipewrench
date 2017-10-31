-- Insert Parquet data into Kudu table
USE test_db;
REFRESH destination_parquet;
UPSERT INTO destination_kudu SELECT
    col1,
    col2
        FROM destination_parquet order by col1  asc
