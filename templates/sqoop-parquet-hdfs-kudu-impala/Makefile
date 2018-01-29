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

impala-cmd={{ conf.impala_cmd }}
source-db-cmd={{ conf.source_database.cmd }}

integration-test:
	$(MAKE) clean
	$(MAKE) first-run
#	$(MAKE) test-rowcount @TODO find goo primary key for integration tests (baseball table)

sqoop-create:  #### Create Sqoop job
	./run-with-logging.sh ./sqoop-create.sh $@

sqoop-clean: ## Delete Sqoop job
	./run-with-logging.sh ./sqoop-delete.sh $@

sqoop-exec: ## Execute sqoop job
	./run-with-logging.sh ./sqoop-exec.sh $@

parquet-table: parquet-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) parquet-table-create.sql

test-rowcount:  #### Run integration tests
	./run-with-logging.sh ./test-rowcount.sh $@

parquet-table-clean: parquet-table-drop.sql ## Drop Parquet impala table
	$(impala-cmd) parquet-table-drop.sql

parquet-archive: hdfs-archive.sh
	./run-with-logging.sh ./hdfs-archive.sh $@

parquet-unarchive: hdfs-unarchive.sh
	./run-with-logging.sh ./hdfs-unarchive.sh $@

parquet-refresh:
	$(impala-cmd) ./parquet-refresh.sql

hdfs-clean: hdfs-delete.sh ## Delete parquet files from HDFS
	./run-with-logging.sh ./hdfs-delete.sh $@

kudu-table: kudu-table-create.sql ## Create Impala Kudu Table
	$(impala-cmd) kudu-table-create.sql

kudu-insert: tables kudu-table-insert.sql ## Insert data into Kudu table from Parquet
	$(impala-cmd) kudu-table-insert.sql

compute-stats: compute-stats.sql
	$(impala-cmd) compute-stats.sql

kudu-table-clean: kudu-table-drop.sql ## Drop Kudu table
	$(impala-cmd) kudu-table-drop.sql

tables-clean: kudu-table-clean parquet-table-clean ## Drop all tables

tables: parquet-table kudu-table ## Create all tables

update: 
	$(MAKE) sqoop-exec
	$(MAKE) parquet-refresh
	$(MAKE) kudu-insert 
	$(MAKE) parquet-archive ## Insert data from source db into Kudu

first-run: 
	$(MAKE) sqoop-create 
	$(MAKE) tables 
	$(MAKE) update 
	$(MAKE) compute-stats ## Run entire workflow, building all tables and pulling source db data into Kudu

clean: sqoop-clean kudu-table-clean parquet-table-clean hdfs-clean ## Remove all tables and data

targets: ## Print out a list of available targets
	@fgrep -h ": " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*//'

help:  ## Print help message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
