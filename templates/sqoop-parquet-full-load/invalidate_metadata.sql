INVALIDATE METADATA {{ conf.staging_database.name }}.{{ table.destination.name.replace('/','_').replace('.','_') }}_avro;
