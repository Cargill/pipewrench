#!/bin/bash
#    Copyright 2017 Cargill Incorporated
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
set -u
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function cleanup {
docker-compose -f $SCRIPT_DIR/docker-compose.yml down || true
}

trap cleanup EXIT
cd $SCRIPT_DIR
# Simple test that builds all example pipelines
# and does some Makefile validation
docker-compose -f $SCRIPT_DIR/docker-compose.yml up -d
sleep 3
while :;do
    docker-compose exec mysql mysql -h localhost -P 3306 -u root -ppipewrench -e 'show databases;' &> /dev/null
    
    if [[ "$?" -eq "0" ]];then
        echo 'service ready'
        break;
    fi
    echo 'waiting for mysql container to be available'
    sleep 1
done
set -e
docker-compose exec mysql /data/load-data.sh
docker-compose exec kimpala /run-all-services.sh

$SCRIPT_DIR/sqoop-parquet-hdfs-impala/run.sh
$SCRIPT_DIR/sqoop-parquet-full-load/run.sh
$SCRIPT_DIR/sqoop-parquet-hdfs-hive-merge/run.sh
$SCRIPT_DIR/kudu-table-ddl/run.sh
$SCRIPT_DIR/sqoop-parquet-hdfs-kudu-impala/run.sh
