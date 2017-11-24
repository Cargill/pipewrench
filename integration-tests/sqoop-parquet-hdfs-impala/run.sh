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
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function cleanup {
$SCRIPT_DIR/../mysql-docker-container-delete || true
}

trap cleanup EXIT
cd $SCRIPT_DIR
# Simple test that builds all example pipelines
# and does some Makefile validation
../mysql-docker-container-create

while :;do
    mysql -h 127.0.0.1 -P 3306 -u pipewrench -ppipewrench -e 'show databases;' &> /dev/null
    
    if [[ "$?" -eq "0" ]];then
        echo 'service ready'
        break;
    fi
    echo 'waiting for mysql container to be available'
    sleep 1
done
docker ps
set -euo pipefail

# verify we can generate scripts without error
./generate-scripts
pushd ./output/sqoop-parquet-hdfs-impala
for table in titanic baseball vocab;do
   pushd ${table}
   # Run the test-targets script to ensure all targets are available
   make clean 
   make source-create
   make first-run
   make test-recordcount
   make source-table-clean
   make clean
   popd
done

