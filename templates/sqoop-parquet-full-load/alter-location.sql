ALTER TABLE `{{ conf.staging_database.name }}`.`{{ table.destination.name }}` SET LOCATION '{{ conf.raw_database.path }}/{{ table.destination.name }}_partitioned/ingest_partition=${var:val}/';
