#!/bin/bash
{#    Copyright 2017 Cargill Incorporated

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. #}
set -e
# Check parquet table
AVRO=$({{ conf.impala_cmd }} avro-table-rowcount.sql -B 2> /dev/null)
PARQUET=$({{ conf.impala_cmd }} parquet-table-rowcount.sql -B 2> /dev/null)
SOURCE=$({{ conf.source_database.cmd }} source-table-rowcount.sql -s -r -N -B 2> /dev/null)
echo "avro count: $AVRO"
echo "parquet count: $PARQUET"
echo "source count: $SOURCE"

if [ "$AVRO" -ne "$SOURCE" ]; then
        echo STAGING AND SOURCE ROW COUNTS DO NOT MATCH
        exit 1
fi

if [ "$PARQUET" -ne "$SOURCE" ]; then
	echo FINAL TABLE ROW COUNTS DO NOT MATCH
	exit 1
fi
