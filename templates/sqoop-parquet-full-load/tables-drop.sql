DROP TABLE IF EXISTS {{ conf.staging_database.name }}.{{ table.destination.name.replace('/','_').replace('.','_') }}_avro;
DROP TABLE IF EXISTS {{ conf.result_database.name }}.{{ table.destination.name.replace('/','_').replace('.','_') }}_parquet;
DROP TABLE IF EXISTS {{ conf.final_database.name }}.{{ table.destination.name.replace('/','_').replace('.','_') }};