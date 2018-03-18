{#  Copyright 2017 Cargill Incorporated

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. -#}
-- Insert Parquet data into Kudu table
USE {{ conf.staging_database.name }};
REFRESH {{ table.destination.name }}_parquet;
UPSERT INTO {{ table.destination.name }}_kudu SELECT
{%- set ordered_columns = order_columns(table.primary_keys,table.columns) -%}
{%- for column in ordered_columns %}
        {{ column.name }}
{%- if not loop.last -%},{% endif %}
{%- endfor %}
        FROM {{ table.destination.name }}_parquet order by {{ table.check_column }}  asc

