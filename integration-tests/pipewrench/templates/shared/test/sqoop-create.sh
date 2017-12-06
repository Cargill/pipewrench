#!/bin/bash


 # Create a Sqoop job
set -eu
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
    --map-column-java col3=String,col4=String \
    --split-by col1 \
    --check-column col1 \
    --as-parquetfile \
    --fetch-size 10000 \
    --compress  \
    --compression-codec snappy \
    -m 1 \
    --query 'SELECT col1,
	col2,
	col3,
	col4
        FROM sourcedb.source_table WHERE $CONDITIONS'
