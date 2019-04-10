#!/bin/bash
{#  Copyright 2017 Cargill Incorporated

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. #}

set -u
# Provides default logging for a Makefile target
# Puts stdin/out to `logs` dir when used in target: sh run-with-logging.sh <command> $@
# example:
# sqoop-create: sqoop-create.sh #### Create Sqoop job
#        ./run-with-logging.sh sqoop-create.sh $@

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORAN='\033[0;33m'

timestamp=`date +"%D %T"`

TARGET_NAME=$2

mkdir -p logs
mkdir -p logs/"$(date +"%d-%m-%Y")"

TARGET_LOG=logs/"$(date +"%d-%m-%Y")"/${TARGET_NAME}.log
STATUS_LOG=logs/status.log

"$@" 2>&1 | tee -a $TARGET_LOG

check_b=`echo ${PIPESTATUS[0]}`
table_name=`basename "$PWD"`

if [ $check_b -ne 0 ]
        then
                echo -e "$timestamp|$table_name|${RED}FAIL${NC}: $@ " 2>&1 | tee -a  $STATUS_LOG
		exit $check_b;
        else
                echo -e "$timestamp|$table_name|${GREEN}PASS${NC}: $@" 2>&1 | tee -a   $STATUS_LOG
fi
