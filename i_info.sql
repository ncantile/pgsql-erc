WITH
 a  AS (SELECT COUNT(*) AS current_connections FROM pg_stat_activity)
,b  AS (SELECT COUNT(*) AS manual_connections FROM pg_stat_activity WHERE datname IS NOT NULL)
,q  AS (WITH totals AS (select datname, pg_database_size(datname) AS db_size FROM pg_database) SELECT pg_size_pretty(SUM(db_size)) AS instance_size FROM totals)
,r  AS (SELECT character_set_name AS charset FROM information_schema.character_sets)
,s  AS (SELECT CASE WHEN (SELECT COUNT(*) FROM pg_stat_replication ) > 0 OR (SELECT COUNT(*) FROM pg_stat_wal_receiver) > 0 THEN true ELSE false END AS isinreplica)
,t  AS (SELECT CASE WHEN (SELECT COUNT(*) FROM pg_stat_replication) > 0 THEN true ELSE false END AS ismaster)
,u  AS (SELECT CASE WHEN (SELECT COUNT(*) FROM pg_stat_wal_receiver) = 1 THEN true ELSE false END AS isslave)
,v  AS (SELECT COUNT(*) AS slaves_num FROM pg_stat_replication)
,w  AS (SELECT COUNT(*) AS users_num FROM pg_user)
,x  AS (SELECT COUNT(*) AS db_num FROM pg_database WHERE datname != 'postgres' AND datname NOT LIKE 'template%')
,y  AS (SELECT COUNT(*) AS tblsp_num FROM pg_tablespace WHERE spcname NOT LIKE 'pg_%')
,z  AS (SELECT COUNT(*) AS unsafe_hba_entries FROM pg_hba_file_rules WHERE auth_method = 'trust')
SELECT * FROM a,b,q,r,s,t,u,v,w,x,y,z;
