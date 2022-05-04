i_* files are used to retrieve instance-level information  
d_* files are used to retrieve information related to the current database

# Documentation

## i_info script:

The i_info.sql script returns some information at instance-level.  
Those information are the following:  
1. Current connections to the instance compared to the maximum allowed connections and, of those connections, how many of them are initiated by a client (not automatic processes defined by the DB engine)
2. Instance's size
3. Instance's character set
4. Whether the instance is in a replication cluster, if it is a master or slave server and how many slaves (secondaries) fetch data from the instance
5. Number of users
6. Number of Databases
7. Number of tablespaces
8. Number of pg_hba.conf entries with 'trust' as authentication method

The following is a sample output of the script:
~~~~ 
-[ RECORD 1 ]-------+-------
current_connections | 7/100
manual_connections  | 1
instance_size       | 500 MB
charset             | UTF8
isinreplica         | t
ismaster            | t
isslave             | f
slaves_num          | 1
users_num           | 2
db_num              | 3
tblsp_num           | 0
trust_hba_entries   | 2
~~~~

## i_settings script

The i_settings.sql script returns some information about the postgresql.conf file.  
The returned information are useful to the DBA for performance and tuning purposes.  
All the memory and size measurements are manipulated in order to return a human-readable
output to the user.  
The `effective_cache_size` parameter set in the configuration file is the number of blocks,
therefore, in order to return a human-readable output to the DBA, the parameter is multiplied
by the `block_size` setting and then converted in a human-radable format by the default
PostgreSQL function `pg_size_pretty()`. This function is also used in all the other columns
that provide a memory or disk size parameter.  
The `archive_command` should be visible only with `archive_mode` set to `on`.  
The `checkpoint_completion_target` parameter is specified in the configuration file
with a numeric entry between 0 and 1: this parameter is manipulated by this script and
multiplied by 100 in order to return a percentage, as the setting `1` effectively means 100%.  
A sample output is the following:  
~~~~
-[ RECORD 1 ]----------------+-----------
work_mem                     | 4096 kB
archive_mode                 | off
archive_command              | (disabled)
min_wal_size                 | 80 MB
max_wal_size                 | 1024 MB
max_connections              | 100
checkpoint_completion_target | 90 %
default_statistics_target    | 100
random_page_cost             | 4
maintenance_work_mem         | 64 MB
shared_buffers               | 16 MB
effective_cache_size         | 4096 MB
effective_io_concurrency     | 1
max_worker_processes         | 8
max_parallel_workers         | 8

~~~~
