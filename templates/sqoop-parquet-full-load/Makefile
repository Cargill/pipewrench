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

sqoop-import:  #### Create Sqoop job
	./run-with-logging.sh ./sqoop-import.sh $@

avro-table: avro-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) avro-table-create.sql

partitioned-table: partitioned-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) partitioned-table-create.sql

report-table: report-table-create.sql #### Create Reporting Impala table
	$(impala-cmd) report-table-create.sql

compute-stats: compute-stats.sh
	./compute-stats.sh

delete-avsc: delete-avsc.sh
	./run-with-logging.sh ./delete-avsc.sh $@

copy-avsc: copy-avsc.sh
	./run-with-logging.sh ./copy-avsc.sh $@

alter-tables: alter-tables.sh
	./run-with-logging.sh ./alter-tables.sh $@

invalidate-metadata: invalidate-metadata.sql
	$(impala-cmd) invalidate-metadata.sql

hdfs-clean: hdfs-clean.sh
	./run-with-logging.sh ./hdfs-clean.sh $@

drop-tables: tables-drop.sql
	$(impala-cmd) tables-drop.sql

test-rowcount: test-rowcount.sh
	./run-with-logging.sh ./test-rowcount.sh $@

update:
	$(MAKE) delete-avsc
	$(MAKE) sqoop-import
	$(MAKE) copy-avsc
	$(MAKE) partitioned-table
	$(MAKE) invalidate-metadata
	$(MAKE) report-table
	$(MAKE) alter-tables
	$(MAKE) compute-stats

clean:
	$(MAKE) hdfs-clean
	$(MAKE) drop-tables

first-run:
	$(MAKE) delete-avsc
	$(MAKE) sqoop-import
	$(MAKE) copy-avsc
	$(MAKE) avro-table
	$(MAKE) partitioned-table
	$(MAKE) invalidate-metadata
	$(MAKE) report-table
	$(MAKE) alter-tables
	$(MAKE) compute-stats

integration-test:
	$(MAKE) clean
	$(MAKE) first-run
	$(MAKE) update
	$(MAKE) test-rowcount

targets: ## Print out a list of available targets
	@fgrep -h ": " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*//'

help:  ## Print help message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
