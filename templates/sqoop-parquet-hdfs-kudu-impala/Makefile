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

impala-cmd=/bin/impala-shell -k --ssl -i impala-daemon.company.com -f

sqoop-create: sqoop-create.sh #### Create Sqoop job
	./run-with-logging.sh ./sqoop-create.sh $@

sqoop-clean: ## Delete Sqoop job
	./run-with-logging.sh ./sqoop-delete.sh $@

sqoop-exec: ## Execute sqoop job
	./run-with-logging.sh ./sqoop-exec.sh $@

parquet-table: parquet-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) parquet-table-create.sql

parquet-table-clean: parquet-table-drop.sql ## Drop Parquet impala table
	$(impala-cmd) parquet-table-drop.sql
	rm -f parquet-table

parquet-archive: hdfs-archive.sh
	./run-with-logging.sh ./hdfs-archive.sh $@

parquet-unarchive: hdfs-unarchive.sh
	./run-with-logging.sh ./hdfs-unarchive.sh $@

hdfs-clean: hdfs-delete.sh ## Delete parquet files from HDFS
	./run-with-logging.sh ./hdfs-delete.sh $@

tables-clean: parquet-table-clean ## Drop all tables

tables: parquet-table ## Create all tables

update: sqoop-exec ## Insert data from source db into Kudu

first-run: sqoop-create tables update ## Run entire workflow, building all tables and pulling source db data into Kudu

clean: sqoop-clean parquet-table-clean hdfs-clean ## Remove all tables and data

targets: ## Print out a list of available targets
	@fgrep -h ": " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*//'

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
