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

impala-cmd={{ conf.impala_cmd }}

integration-test:
	$(MAKE) clean
	$(MAKE) first-run
	$(MAKE) update

sqoop-create: sqoop-create.sh #### Create Sqoop job
	./run-with-logging.sh ./sqoop-create.sh $@

sqoop-delete: ## Delete Sqoop job
	./run-with-logging.sh ./sqoop-delete.sh $@

sqoop-exec: ## Execute sqoop job
	./run-with-logging.sh ./sqoop-exec.sh $@

create-base-table: create-base-table.sql 
	$(impala-cmd) create-base-table.sql

create-incr-table: create-incr-table.sql 
	$(impala-cmd)  create-incr-table.sql

create-merge-view: create-merge-view.sql 
	$(impala-cmd)  create-merge-view.sql

create-report-table: create-report-table.sql 
	$(impala-cmd)  create-report-table.sql

overwrite-base-table: overwrite-base-table.sql 
	$(impala-cmd)  overwrite-base-table.sql

hdfs-clean: hdfs-delete.sh ## Delete parquet files from HDFS
	./run-with-logging.sh ./hdfs-delete.sh $@

move-1st-sqoop: move-1st-sqoop.sh
	./run-with-logging.sh ./move-1st-sqoop.sh $@

drop-raw-tables: drop-raw-tables.sql
	$(impala-cmd) drop-raw-tables.sql
	./run-with-logging.sh ./hdfs-delete.sh $@
	
hdfs-incr-clear: hdfs-incr-clear.sh
	./run-with-logging.sh ./hdfs-incr-clear.sh $@
	
drop-report-table: drop-report-table.sql
	$(impala-cmd) drop-report-table.sql
	./run-with-logging.sh ./hdfs-report-delete.sh $@

first-run: 
	$(MAKE) create-base-table #keep this on top so that the hdfs directories are created by impala the lower lever user. Otherwise there might be access issue later. 
	$(MAKE) sqoop-create 
	$(MAKE) sqoop-exec
	$(MAKE) move-1st-sqoop 
	$(MAKE) create-incr-table

update: 
	$(MAKE) sqoop-exec 
	$(MAKE) create-merge-view 
	$(MAKE) drop-report-table 
	$(MAKE) create-report-table 
	$(MAKE) overwrite-base-table 
	$(MAKE) hdfs-incr-clear

clean: 
	$(MAKE) drop-raw-tables
	$(MAKE) drop-report-table 
	$(MAKE) sqoop-delete 

targets: ## Print out a list of available targets
	@fgrep -h ": " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*//'

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
