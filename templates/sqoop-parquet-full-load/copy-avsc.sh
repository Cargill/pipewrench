hadoop fs -mkdir {{ conf.raw_database.path }}/{{ table.destination.name }}/.meta/
hadoop fs -put -f AutoGeneratedSchema.avsc {{ conf.raw_database.path }}/{{ table.destination.name }}/.meta/{{ table.destination.name }}.avsc