CREATE USER erc_mon WITH LOGIN PASSWORD 'insert_pwd_here';
SELECT format('GRANT CONNECT ON DATABASE %I TO erc_mon;', datname) FROM pg_database \gexec
--the following line must be run while connected to each database
ALTER DEFAULT PRIVILEGES FOR ROLE erc_mon IN SCHEMA pg_catalog, information_schema GRANT SELECT ON TABLES TO erc_mon;
GRANT pg_read_all_settings TO erc_mon;
GRANT pg_read_all_stats TO erc_mon;
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO erc_mon;
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO erc_mon;