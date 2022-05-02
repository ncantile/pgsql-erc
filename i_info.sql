WITH
    /*this column shows the current active and idle connection to the database compared to
    the maximum amount of allowed connection, as specified in the configuration file*/
 a  AS (WITH aa AS (SELECT COUNT(*) AS curcon FROM pg_stat_activity),
             bb AS (SELECT setting FROM pg_settings WHERE name = 'max_connections')
                SELECT CONCAT(curcon, '/', setting) AS current_connections FROM aa,bb)

    /*this column is similar to the previous one but does not count the connections
    automatically initiated by the Database such as the checkpointer, autovacuum, etc.*/
,b  AS (SELECT COUNT(*) AS manual_connections FROM pg_stat_activity WHERE datname IS NOT NULL)

    /*this column shows the size of the instance as a sum of the size of all the databases
    as reported in the pg_database system table. a human-readable format is used*/
,q  AS (WITH totals AS (select datname, pg_database_size(datname) AS db_size FROM pg_database)
                SELECT pg_size_pretty(SUM(db_size)) AS instance_size FROM totals)

    --this column shows the instance's character set
,r  AS (SELECT character_set_name AS charset FROM information_schema.character_sets)

    /*this column shows whether the instance is in a functioning multi-node, streaming-replication cluster
    it should be false only if both the "ismaster" and the "isslave" columns return false*/
,s  AS (SELECT CASE
                WHEN (SELECT COUNT(*) FROM pg_stat_replication ) > 0
                  OR (SELECT COUNT(*) FROM pg_stat_wal_receiver) > 0
            THEN true
            ELSE false END AS isinreplica)

    --this column shows whether the instance is the master (primary) node in a streaming-replication cluster
,t  AS (SELECT CASE
                WHEN (SELECT COUNT(*) FROM pg_stat_replication) > 0
            THEN true
            ELSE false END AS ismaster)

    --this column shows whether the instance is the slave (secondary) node in a streaming-replication cluster
,u  AS (SELECT CASE
                WHEN (SELECT COUNT(*) FROM pg_stat_wal_receiver) = 1
            THEN true
            ELSE false END AS isslave)

    /*this column shows the number of nodes that fetch data from the instance in a streaming-replication setup
    it should have a value >= 1 if the column "ismaster" returns true*/
,v  AS (SELECT COUNT(*) AS slaves_num FROM pg_stat_replication)

    --this column shows the number of users in the instance. it also counts the default user[s]
,w  AS (SELECT COUNT(*) AS users_num FROM pg_user)

    --this column shows the number of databases in the instance. it does not count the default databases
,x  AS (SELECT COUNT(*) AS db_num FROM pg_database WHERE datname != 'postgres' AND datname NOT LIKE 'template%')

    /*this column shows the number of tablespaces in the instance.
    it does not count the default '$PGDATA' directory as a tablespace*/
,y  AS (SELECT COUNT(*) AS tblsp_num FROM pg_tablespace WHERE spcname NOT LIKE 'pg_%')

    /*this column shows the number of lines in the 'pg_hba.conf' file that are marked
    with the 'trust' authentication method. this value should be 0 for safety reasons*/
,z  AS (SELECT COUNT(*) AS trust_hba_entries FROM pg_hba_file_rules WHERE auth_method = 'trust')

SELECT * FROM a,b,q,r,s,t,u,v,w,x,y,z;
