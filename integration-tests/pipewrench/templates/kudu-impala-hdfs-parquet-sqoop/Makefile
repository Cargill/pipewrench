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

impala-cmd=impala-shell -f

sqoop-export: sqoop-export.sh #### Create Sqoop job
	./run-with-logging.sh ./sqoop-export.sh $@

sqoop-clean: ## Delete Sqoop job
	sh sqoop-delete.sh

sqoop-exec: ## Execute sqoop job
	sh sqoop-exec.sh

parquet-table: textfile-table-create.sql #### Create Parquet/Text Impala Table (TextFormat until this https://reviews.apache.org/r/61522/ issue resolve))
	$(impala-cmd) textfile-table-create.sql

parquet-table-clean: parquet-table-drop.sql ## Drop Parquet/Text impala table
	$(impala-cmd) parquet-table-drop.sql
	rm -f parquet-table

parquet-archive: hdfs-archive.sh
	sh hdfs-archive.sh

parquet-unarchive: hdfs-unarchive.sh
	sh hdfs-unarchive.sh

hdfs-clean: hdfs-delete.sh ## Delete parquet files from HDFS
	sh hdfs-delete.sh
	rm -f hdfs-clean

kudu-select: kudu-table-select.sql ## Insert data into Parquet/Text impala table table from Kudu
	$(impala-cmd) kudu-table-select.sql

sqldb-create: sqldb-create.sh ## create sqldb schema
	sh sqldb-create.sh

test: ## Run tests (directory diff)
	$(impala-cmd) kudu-table-count.sql -o test-kudu-rowcount --delimited
	sh test.sh

tables-clean: parquet-table-clean ## Drop all tables

update: parquet-table kudu-select sqldb-create sqoop-export sqoop-exec parquet-archive ## Insert data from kudu db into dest db

first-run: update ## Run entire workflow, building all tables and pulling source db data into Kudu

clean: sqoop-clean parquet-table-clean hdfs-clean ## Remove all tables and data

targets: ## Print out a list of available targets
	@fgrep -h ": " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*//'


help:  ## Print help message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
