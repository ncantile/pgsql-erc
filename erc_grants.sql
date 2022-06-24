CREATE USER erc_mon WITH LOGIN ENCRYPTED PASSWORD 'insert_pw_here';
GRANT SELECT ON pg_catalog.pg_largeobject TO erc_mon
GRANT SELECT ON pg_catalog.pg_authid TO erc_mon