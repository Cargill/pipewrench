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

{% macro column_or_cast(conf, column) -%}
    {% set mapped_type = map_datatypes(conf, column).impala %}
    {%- if mapped_type == 'timestamp' %}
        cast({{ column.name }} as timestamp) COMMENT '{{ column.comment }}'
    {%- else %}
        {{ column.name }} {{ mapped_type }} COMMENT '{{ column.comment }}'
    {%- endif -%}
{%- endmacro %}

-- Create a Parquet table in Impala
USE {{ conf.staging_database.name }};
CREATE VIEW IF NOT EXISTS {{ table.destination.name }}_kudu_casted AS SELECT
{%- for column in table.columns -%}
    {{ column_or_cast(conf, column) }}
{%- if not loop.last -%}, {% endif %}
{%- endfor %}
FROM {{ table.destination.name }}_kudu
