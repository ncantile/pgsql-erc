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
8. Number of unsafe pg_hba.conf entries (with 'trust' as authentication method)

The following is a sample output of the script:  
> `-[ RECORD 1 ]-------+-------`  
> `current_connections | 7/100`  
> `manual_connections  | 1`  
> `instance_size       | 491 MB`  
> `charset             | UTF8`  
> `isinreplica         | t`  
> `ismaster            | t`  
> `isslave             | f`  
> `slaves_num          | 1`  
> `users_num           | 2`  
> `db_num              | 2`  
> `tblsp_num           | 0`  
> `trust_hba_entries   | 1`  

