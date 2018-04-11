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

set sync_ddl=1;
USE {{ conf.staging_database.name }};

--Create merged view --
DROP VIEW IF EXISTS {{ table.destination.name }}_view;
CREATE VIEW {{ table.destination.name }}_view AS
  SELECT t1.* 
  FROM (SELECT * FROM {{ table.destination.name }}_base
	UNION ALL 
	SELECT * FROM {{ table.destination.name }}_incr) t1
  JOIN (SELECT {{ table.split_by_column }}, max({{ table.check_column }}) max_modified 
  	FROM (SELECT * FROM {{ table.destination.name }}_base 
	   UNION ALL
	SELECT * FROM {{ table.destination.name }}_incr) t2
	GROUP BY {{ table.split_by_column }}) s
  ON t1.{{ table.split_by_column }} = s.{{ table.split_by_column }} AND t1.{{ table.check_column }} = s.max_modified;
