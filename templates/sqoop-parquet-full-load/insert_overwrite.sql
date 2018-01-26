INSERT OVERWRITE TABLE {{ conf.result_database.name }}.{{ table.destination.name }}_parquet PARTITION (mod_val=${var:val})
SELECT {% for column in table.columns %}
{%- if column["datatype"].lower() == "decimal" %}
cast ({{ column.name }} as decimal({{column.precision}}, {{column.scale}}) )
{%- else %} {{ column.name }}
{% endif %}
{%- if not loop.last -%}, {% endif %}
{%- endfor %}
 FROM {{ conf.staging_database.name }}.{{ table.destination.name }}_avro;