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
	./sqoop-import.sh $@

avro-table: avro-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) avro-table-create.sql

parquet-table: parquet-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) parquet-table-create.sql

output-table: output-table-create.sql #### Create Parquet Impala Table
	$(impala-cmd) output-table-create.sql

compute-stats: compute-stats.sh
	./compute-stats.sh

delete_avsc: delete_avsc.sh
  ./delete_avsc.sh

copy-avsc: copy-avsc.sh
	./copy-avsc.sh

alter-tables: alter-tables.sh
	./alter-tables.sh $@

invalidate-metadata: invalidate_metadata.sql
	$(impala-cmd) invalidate_metadata.sql

hdfs-clean: hdfs-clean.sh
	./hdfs-clean.sh $@

tables-drop: tables-drop.sql
	$(impala-cmd) tables-drop.sql

update: 
  $(MAKE) delete_avsc
	$(MAKE) sqoop-import
	$(MAKE) invalidate-metadata
	$(MAKE) alter-tables
	$(MAKE) compute-stats

clean:
	$(MAKE) hdfs-clean
	$(MAKE) tables-drop

first-run: 
  $(MAKE) delete_avsc
	$(MAKE) sqoop-import
	$(MAKE) copy-avsc
	$(MAKE) avro-table
	$(MAKE) parquet-table
	$(MAKE) output-table
	$(MAKE) invalidate-metadata
	$(MAKE) alter-tables ## Run entire workflow, building all tables and pulling source db data into Kudu
	$(MAKE) compute-stats

##clean: sqoop-clean kudu-table-clean parquet-table-clean hdfs-clean
## Remove all tables and data

targets: ## Print out a list of available targets
	@fgrep -h ": " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:.*//'

help:  ## Print help message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
