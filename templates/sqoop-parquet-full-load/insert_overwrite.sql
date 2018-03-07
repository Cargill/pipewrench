INSERT OVERWRITE TABLE {{ conf.result_database.name }}.{{ table.destination.clean_name }}_parquet PARTITION (mod_val=${var:val})
SELECT {% for column in table.columns %}
{%- if column["datatype"].lower() == "decimal" %}
cast (`{{ column.name.replace('/','_') }}` as decimal({{column.precision}}, {{column.scale}}) )
{%- else %} `{{ column.name.replace('/','_') }}`
{% endif %}
{%- if not loop.last -%}, {% endif %}
{%- endfor %}
 FROM {{ conf.staging_database.name }}.{{ table.destination.clean_name }}_avro;
