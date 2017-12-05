#!/bin/bash
set -eu
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
./generate-scripts
docker-compose exec kimpala /mount/sqoop-parquet-hdfs-impala/run-in-container.sh
