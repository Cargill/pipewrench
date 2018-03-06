use  {{ conf.final_database.name }};
show table stats {{ table.destination.name.replace('/','_').replace('.','_') }};