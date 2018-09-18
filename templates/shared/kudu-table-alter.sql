{#-  Copyright 2017 Cargill Incorporated

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
ALTER TABLE  {{ table.destination.name }}{% if conf.user_defined is defined and conf.user_defined.kudu_suffix is defined %}{{ conf.user_defined.kudu_suffix }}{% endif %}
SET TBLPROPERTIES(
{%- if table.metadata %}
  {%- for key, value in table.metadata.items() %}
  '{{ key }}' = '{{ value }}',
  {%- endfor %}
{%- endif %}
{%- for column in table.columns -%}
  "{{ cleanse_column(column.name)|lower }}" = "{{ column.comment }}"{%- if not loop.last -%},{% endif %}
{%- endfor -%})
