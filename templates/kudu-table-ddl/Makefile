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

kudu-table: kudu-table-create.sql ## Create Impala Kudu Table
	$(impala-cmd) kudu-table-create.sql

compute-stats: compute-stats.sql
	$(impala-cmd) compute-stats.sql

kudu-table-clean: kudu-table-drop.sql ## Drop Kudu table
	$(impala-cmd) kudu-table-drop.sql

tables-clean: kudu-table-clean  ## Drop all tables

tables: kudu-table ## Create all tables

integration-test: # Run integration-tests
        $(MAKE) tables
        $(MAKE) tables-clean

help:  ## Print help message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
