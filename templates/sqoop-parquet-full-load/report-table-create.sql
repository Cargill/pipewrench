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
CREATE EXTERNAL TABLE IF NOT EXISTS {{ table.destination.name }} (
{% for column in table.columns %}
{%- if column["datatype"].lower() == "decimal" %}
`{{ column.name.replace('/','_') }}` {{ map_datatypes(column).parquet }}({{column.precision}},{{column.scale}}) COMMENT '{{ column.comment }}'
{%- else %} `{{ column.name.replace('/','_') }}` {{ map_datatypes(column).parquet }} COMMENT '{{ column.comment }}'
{% endif %}
{%- if not loop.last -%}, {% endif %}
{%- endfor %})
COMMENT '{{ table.comment }}'
STORED AS PARQUET
LOCATION '{{ conf.staging_database.path }}/{{ table.destination.name }}/'
{%- if table.metadata %}  
TBLPROPERTIES(
  {%- for key, value in table.metadata.items() %}
  '{{ key }}' = '{{ value }}'{%- if not loop.last -%}, {% endif %}
  {%- endfor %}
)
{%- endif %}