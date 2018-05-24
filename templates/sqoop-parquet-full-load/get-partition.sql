use  {{ conf.raw_database.name }};
show table stats {{ table.destination.name }}_partitioned;