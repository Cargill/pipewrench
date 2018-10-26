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

-- cannot get create table as select to work. --
--ERROR: AnalysisException: java.lang.RuntimeException: Unable to instantiate org.apache.hadoop.hive.metastore.HiveMetaStoreClient--
/* CREATE EXTERNAL TABLE {{ table.destination.name }}_report 
STORED AS PARQUET 
TBLPROPERTIES ('parquet.compression'='SNAPPY',
  'SOURCE' = '{{ table.META_SOURCE }}',
  'SECURITY_CLASSIFICATION' = '{{ table.META_SECURITY_CLASSIFICATION }}',
  'LOAD_FREQUENCY' = '{{ table.META_LOAD_FREQUENCY }}',
  'CONTACT_INFO' = '{{ table.META_CONTACT_INFO }}')
AS SELECT * FROM {{ conf.staging_database.name}}.{{ table.destination.name }}_merge_view;
*/

-- create table, then insert overwrite --
CREATE EXTERNAL TABLE IF NOT EXISTS {{ table.destination.name }}_report (
  {% for column in table.columns %}
  {{ column.name }} {{ map_datatypes_v2(column, 'parquet') }} COMMENT "{{ column.comment }}"
  {%- if not loop.last -%}, {% endif %}
  {%- endfor %})
STORED AS Parquet
LOCATION '{{ conf.staging_database.path }}/{{ table.destination.name }}/base'
{%- if table.metadata %}
TBLPROPERTIES(
  {%- for key, value in table.metadata.items() %}
  '{{ key }}' = '{{ value }}'{%- if not loop.last -%}, {% endif %}
  {%- endfor %}
)
{%- endif %};

insert overwrite {{ table.destination.name }}_report select * from {{ table.destination.name }}_merge_view;

COMPUTE STATS {{ table.destination.name }}_report
