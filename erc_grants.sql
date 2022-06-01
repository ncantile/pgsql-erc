CREATE USER erc_mon WITH LOGIN PASSWORD 'insert_pwd_here';
SELECT format('GRANT CONNECT ON DATABASE %I TO erc_mon;', datname) FROM pg_database \gexec --this grants the connection privilege to all databases present in the instance at the moment this script is run
SELECT format('GRANT USAGE ON SCHEMA %I TO erc_mon', nspname) FROM pg_namespace \gexec
GRANT pg_read_all_settings TO erc_mon;
GRANT pg_read_all_stats TO erc_mon;
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO erc_mon;
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO erc_mon;
GRANT SELECT ON pg_hba_file_rules TO erc_mon;
GRANT EXECUTE ON FUNCTION pg_hba_file_rules TO erc_mon;