INSERT OVERWRITE TABLE {{ conf.raw_database.name }}.{{ table.destination.name }}_partitioned PARTITION (ingest_partition=${var:val})
SELECT {% for column in table.columns %}
{%- if column["datatype"].lower() == "decimal" %}
cast (`{{ column.name.replace('/','_') }}` as decimal({{column.precision}}, {{column.scale}}) )
{%- else %} `{{ column.name.replace('/','_') }}`
{% endif %}
{%- if not loop.last -%}, {% endif %}
{%- endfor %}
 FROM {{ conf.raw_database.name }}.{{ table.destination.name }}_avro;
