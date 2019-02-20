INSERT OVERWRITE TABLE `{{ conf.raw_database.name }}`.`{{ table.destination.name }}_partitioned` PARTITION (ingest_partition=${var:val})
SELECT {% for column in table.columns %}
{%- if column["datatype"].lower() == "decimal" %} cast (`{{ cleanse_column(column.name) }}` as decimal({{column.precision}}, {{column.scale}}) )
{%- elif column["datatype"].lower() == "timestamp" %} cast (`{{ cleanse_column(column.name) }}`/1000 as timestamp ) AS `{{ cleanse_column(column.name) }}`
{%- else %} `{{ cleanse_column(column.name) }}`
{%- endif %}
{%- if not loop.last %}, {% endif %}
{%- endfor %}
 FROM `{{ conf.raw_database.name }}`.`{{ table.destination.name }}_avro`;
