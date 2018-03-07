DROP TABLE IF EXISTS {{ conf.staging_database.name }}.{{ table.destination.clean_name }}_avro;
DROP TABLE IF EXISTS {{ conf.result_database.name }}.{{ table.destination.clean_name }}_parquet;
DROP TABLE IF EXISTS {{ conf.final_database.name }}.{{ table.destination.clean_name }};