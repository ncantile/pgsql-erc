WITH
    --work_mem setting in a human-readable format
 b  AS (SELECT pg_size_pretty((setting::int*1024)::bigint) AS work_mem FROM pg_settings WHERE name = 'work_mem')

    --archive_mode setting
,c  AS (SELECT setting AS archive_mode FROM pg_settings WHERE name = 'archive_mode')

    --archive_command setting
,d  AS (SELECT setting AS archive_command FROM pg_settings WHERE name = 'archive_command')

    --min_wal_size setting in a human-readable format
,e  AS (SELECT pg_size_pretty((setting::int*1024*1024)::bigint) AS min_wal_size FROM pg_settings WHERE name = 'min_wal_size')

    --max_wal_size setting in a human-readable format
,f  AS (SELECT pg_size_pretty((setting::int*1024*1024)::bigint) AS max_wal_size FROM pg_settings WHERE name = 'max_wal_size')

    --max_connections setting
,g  AS (SELECT setting AS max_connections FROM pg_settings WHERE name = 'max_connections')

    --checkpoint_completion_target setting in a human-readable format
,h  AS (SELECT (setting::numeric*100)::smallint||' %' AS checkpoint_completion_target FROM pg_settings WHERE name = 'checkpoint_completion_target')

    --default_statistics_target setting
,i  AS (SELECT setting AS default_statistics_target FROM pg_settings WHERE name = 'default_statistics_target')

    --random_page_cost setting
,j  AS (SELECT setting AS random_page_cost FROM pg_settings WHERE name = 'random_page_cost')

    --maintenance_work_mem setting in a human-readable format
,k  AS (SELECT pg_size_pretty((setting::int*1024)::bigint) AS maintenance_work_mem FROM pg_settings WHERE name = 'maintenance_work_mem')

    --shared_buffers setting in a human-readable format
,l  AS (SELECT pg_size_pretty((setting::int*1024)::bigint) AS shared_buffers FROM pg_settings WHERE name = 'shared_buffers')

    --effective_cache_size setting in a human-readable format
,m  AS (SELECT pg_size_pretty((setting::bigint*(SELECT current_setting('block_size')::bigint))::bigint) AS effective_cache_size FROM pg_settings WHERE name = 'effective_cache_size')

    --effective_io_concurrency setting
,n  AS (SELECT setting AS effective_io_concurrency FROM pg_settings WHERE name = 'effective_io_concurrency')

    --max_worker_processes setting
,o  AS (SELECT setting AS max_worker_processes FROM pg_settings WHERE name = 'max_worker_processes')

    --max_parallel_workers setting
,p  AS (SELECT setting AS max_parallel_workers FROM pg_settings WHERE name = 'max_parallel_workers')

SELECT * FROM b,c,d,e,f,g,h,i,j,k,l,m,n,o,p;
