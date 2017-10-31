{#  Copyright 2017 Cargill Incorporated

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
-- Create a Kudu table in Impala
USE {{ conf.staging_database.name }};
CREATE TABLE IF NOT EXISTS {{ table.destination.name }}_kudu
({% for column in table.columns %}
{{ column.name }} {{ map_datatypes(column).kudu }}
{%- if not loop.last -%},{% endif %}
{%- endfor %},
primary key ({{ table.primary_keys|join(', ') }}))
PARTITION BY HASH({{ table.kudu.hash_by|join(', ') }}) PARTITIONS {{ table.kudu.num_partitions }}
STORED AS KUDU
TBLPROPERTIES(
'SOURCE' = '{{ table.META_SOURCE }}',
'SECURITY_CLASSIFICATION' = '{{ table.META_SECURITY_CLASSIFICATION }}',
'LOAD_FREQUENCY' = '{{ table.META_LOAD_FREQUENCY }}',
'CONTACT_INFO' = '{{ table.META_CONTACT_INFO }}',
{% for column in table.columns -%}
  '{{ column.name|lower }}' = '{{ column.comment }}'{%- if not loop.last -%},{% endif %}
{%endfor%})
