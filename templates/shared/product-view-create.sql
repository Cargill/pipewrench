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
-- Create a view in Impala

USE {% if conf.user_defined is defined and conf.user_defined.product_database is defined %}{{ conf.user_defined.product_database }}
{% else %}{{ conf.staging_database.name }}{% endif %};
CREATE VIEW IF NOT EXISTS {{ table.destination.name }}{% if conf.user_defined is defined and conf.user_defined.view_suffix is defined %}{{ conf.user_defined.view_suffix }}{% endif %} 
({%- for column in table.columns %}`{{ cleanse_column(column.name) }}` COMMENT "{{ column.comment }}"
{%- if not loop.last -%}, {% endif %}{%- endfor %})
COMMENT '{{ table.comment }}'
AS
SELECT 
{%- set ordered_columns = order_columns(table.primary_keys,table.columns) -%}
{%- for column in ordered_columns %}
        {% if column.datatype == "DECIMAL" %}CAST(`{{ cleanse_column(column.name) }}` AS DECIMAL ({{ column.precision }},{{ column.scale }})) AS `{{ cleanse_column(column.name) }}`{% else %}`{{ cleanse_column(column.name) }}`{% endif %}
{%- if not loop.last -%},{% endif %}
{%- endfor %}
FROM {{ conf.staging_database.name }}.{{ table.destination.name }}{% if conf.user_defined is defined and conf.user_defined.view_suffix is defined %}{{ conf.user_defined.view_suffix }}{% endif %} 
{#- 
The FROM logic is subject to change, I was not certain whether if no Product datbase was provided if we should still source from the staging database
FROM {% if conf.user_defined.product_database is defined %}{{ conf.staging_database.name }}{% else %}{{ conf.raw_database.name }}{% endif %}.{{ table.destination.name }}{{ conf.user_defined.kudu_suffix }}    
-#}

