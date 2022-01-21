#!/bin/bash
set -eu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
./generate-scripts
docker exec kimpala bash -c 'chown -R hdfs:hdfs /mount'
docker exec kimpala bash -c 'chmod -R 777 /root'
docker exec kimpala /mount/sqoop-parquet-hdfs-kudu-impala/run-in-container.sh
