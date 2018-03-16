#!/bin/bash
set -eu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
./generate-scripts
docker-compose exec kimpala bash -c 'chown -R hdfs:hdfs /mount'
docker-compose exec kimpala bash -c 'chmod -R 777 /root'
docker-compose exec kimpala /mount/sqoop-parquet-hdfs-kudu-impala/run-in-container.sh
