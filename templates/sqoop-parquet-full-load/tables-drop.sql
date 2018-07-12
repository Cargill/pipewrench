DROP TABLE IF EXISTS {{ conf.raw_database.name }}.{{ table.destination.name }}_avro;
DROP TABLE IF EXISTS {{ conf.raw_database.name }}.{{ table.destination.name }}_partitioned;
DROP TABLE IF EXISTS {{ conf.staging_database.name }}.{{ table.destination.name }};
