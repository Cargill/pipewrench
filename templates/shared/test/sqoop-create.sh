#!/bin/bash

# Create a Sqoop job
set -euo pipefail
sqoop job -D 'sqoop.metastore.client.record.password=true' \
    --create sourcedb.source_table.unittest \
    -- import \
    --connect  \
    --username myuser \
    --password-file mypasswordfile \
    --target-dir /data//destination/incr \
    --incremental append \
    --temporary-rootdir /data//destination \
    --append \
    --split-by col1 \
    --check-column col1 \
    --as-parquetfile \
    --direct \
    --fetch-size 10000 \
    --compress  \
    --compression-codec snappy \
    -m 1 \
    --query 'SELECT TOP 1000 col1,
        col2
        FROM sourcedb.source_table WHERE $CONDITIONS'
