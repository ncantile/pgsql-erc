--all the data below refer to the db the client is connected to
WITH
--this query returns the size of the db
 a  AS (SELECT pg_size_pretty(pg_database_size(current_database())) AS db_size)

--this query is used by the 'p' query, it returns the number of active and idle connection to the db
,b  AS (SELECT COUNT(*) AS db_connections FROM pg_stat_activity WHERE datname = (SELECT current_database()))

--this query returns the number of all the non-system tables in the db
,d  AS (SELECT COUNT(*) AS table_count FROM pg_tables WHERE schemaname NOT IN ('pg_catalog', 'information_schema'))

--this query returns the number of all the non-system indexes in the db
,e  AS (SELECT COUNT(*) AS index_count FROM pg_indexes WHERE schemaname != 'pg_catalog')

--this query returns the size of all the non-system tables in the db
,f  AS (SELECT pg_size_pretty(SUM(pg_table_size(c.oid))) AS tables_size FROM pg_class AS c
            LEFT JOIN pg_namespace AS n ON (n.oid = c.relnamespace)
            WHERE nspname NOT IN ('pg_catalog', 'information_schema') AND
                  c.relkind IN ('r', 't','f','p') AND
                  nspname != 'pg_toast')

--this query returns the size of all the non-system indexes in the db
,q  AS (SELECT pg_size_pretty(SUM(pg_total_relation_size(c.oid))) AS indexes_size FROM pg_class AS c
            LEFT JOIN pg_namespace AS n ON (n.oid = c.relnamespace)
            WHERE nspname NOT IN ('pg_catalog', 'information_schema') AND
                  c.relkind IN ('r', 't','f','p') AND
                  nspname != 'pg_toast')

--this query returns the size of all the materialized views in the db
,s  AS (SELECT pg_size_pretty(SUM(pg_total_relation_size(c.oid))) AS mviews_size FROM pg_class AS c
            LEFT JOIN pg_namespace AS n ON (n.oid = c.relnamespace)
            WHERE nspname NOT IN ('pg_catalog', 'information_schema') AND
                  c.relkind = 'm' AND
                  nspname != 'pg_toast')

/* this query is used by the 'p' query, it returns the maximum allowed connection as specified
by the dba with the CREATE DATABASE [...] CONNECTION LIMIT x command. if no limit is specified
it returns the string 'unlimited', if the connection limit is 0 it returns the string 'closed',
in any other case the number of maximum allowed connection is shown as a varchar type*/
,g  AS (SELECT CASE
                WHEN datconnlimit < 0 THEN CAST('unlimited' AS CHAR(9))
                WHEN datconnlimit = 0 THEN CAST('closed' AS CHAR(6))
                ELSE
                CAST(datconnlimit AS VARCHAR) END AS max_connections
                FROM pg_database WHERE datname = (SELECT current_database()))

--this query returns the number of installed extensions
,h  AS (SELECT COUNT(*) AS extension_count FROM pg_extension)

--this query returns the number of non-system schemas in the db
,i  AS (SELECT COUNT(*) AS schema_count FROM pg_namespace WHERE nspname NOT LIKE 'pg_%' AND nspname != 'information_schema')

/*this query checks if the db has a publication or a subscription (meaning that it is in a logical-replication setup or it once was
and the replication is broken) it returns a boolean value*/
,j  AS (SELECT CASE
                WHEN (SELECT COUNT(*) FROM pg_publication) > 0 OR (SELECT COUNT(*) FROM pg_subscription) > 0 THEN true
                ELSE false END AS logic_repl_setup)

--this query returns the number of publication in the db
,k  AS (SELECT COUNT(*) AS publication_count FROM pg_publication)

--this query returns the number of subscriptions in the db
,l  AS (SELECT COUNT(*) AS subscription_count FROM pg_subscription)

--this query returns the number of locks on non-system tables in the db 
,m  AS (SELECT COUNT(*) AS lock_count FROM pg_locks l
            LEFT JOIN pg_class c ON l.relation = c.oid
            WHERE locktype != 'virtualxid' AND
                  c.relname NOT  LIKE 'pg_%')

--this query returns the number of materialized views in the db
,n  AS (SELECT COUNT(*) AS mview_count FROM pg_matviews)

--this query returns the number of non-system views in the db
,o  AS (SELECT COUNT(*) AS view_count FROM pg_views WHERE schemaname NOT IN ('pg_catalog', 'information_schema'))

/*this query returns the number of active connection compared to the number of maximum
allowed connection to the db. see the comments on queries 'b' and 'g' for more details*/
,p  AS (SELECT db_connections||'/'||max_connections AS db_connections FROM b,g)

SELECT * FROM a,p,d,e,f,q,s,t,h,i,j,k,l,m,n,o;
