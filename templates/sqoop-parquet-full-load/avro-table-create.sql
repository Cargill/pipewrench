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

-- Create a Parquet table in Impala
set sync_ddl=1;
USE {{ conf.staging_database.name }};
CREATE EXTERNAL TABLE IF NOT EXISTS {{ table.destination.name }}_avro (
{% for column in table.columns %}
`{{ column.name.replace('/','_') }}` {{ map_datatypes(column).avro }} COMMENT '{{ column.comment }}'
{%- if not loop.last -%}, {% endif %}
{%- endfor %})
STORED AS AVRO
LOCATION '{{ conf.staging_database.path }}/{{ table.destination.name }}/'
TBLPROPERTIES(
  'avro.schema.url' = '{{ conf.staging_database.path }}/{{ table.destination.name }}/.meta/{{ table.destination.name }}.avsc',
  'SOURCE' = '{{ table.META_SOURCE }}',
  'SECURITY_CLASSIFICATION' = '{{ table.META_SECURITY_CLASSIFICATION }}',
  'LOAD_FREQUENCY' = '{{ table.META_LOAD_FREQUENCY }}',
  'CONTACT_INFO' = '{{ table.META_CONTACT_INFO }}'
)

