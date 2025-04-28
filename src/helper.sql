-- List active queries excluding those on pg_stat_activity, sorted by start time
-- ================================================================================
SELECT pid, state, age(clock_timestamp(), query_start), usename, query
FROM pg_stat_activity
WHERE query NOT ILIKE '%pg_stat_activity%'
ORDER BY query_start DESC;


-- Show locks held on user tables matching 'my_table%', with query details
-- ================================================================================
SELECT a.datname,
       l.relation::regclass,
       l.transactionid,
       l.mode,
       l.GRANTED,
       a.usename,
       a.query,
       a.query_start,
       age(now(), a.query_start) AS "age",
       a.pid
FROM pg_stat_activity a
         JOIN pg_locks l ON l.pid = a.pid
WHERE l.relation::regclass::text NOT ILIKE 'pg_%'
  AND l.relation::regclass::text like 'my_table%'
ORDER BY a.query_start;


-- List fully qualified table names in 'my_schema' starting with 'my_table%'
-- ================================================================================
SELECT '"' || table_schema || '.' || table_name || '",' AS tablename
FROM information_schema.tables
WHERE table_schema = 'my_schema' AND table_name LIKE 'my_table%'
ORDER BY length(table_schema || '.' || table_name), 1;


-- List table names with their total size in 'my_schema' for 'my_table%'
-- ================================================================================
WITH my_table AS (
    SELECT table_schema || '.' || table_name AS tablename
    FROM information_schema.tables
    WHERE table_schema = 'my_schema' AND table_name LIKE 'my_table%'
    ORDER BY length(table_schema || '.' || table_name), 1
)
SELECT tablename, pg_size_pretty(pg_total_relation_size(tablename)) from my_table;


-- Get the summed total size of all 'my_table%' tables in 'my_schema'
-- ================================================================================
WITH my_table AS (
    SELECT table_schema || '.' || table_name AS tablename
    FROM information_schema.tables
    WHERE table_schema = 'my_schema' AND table_name LIKE 'my_table%'
    ORDER BY length(table_schema || '.' || table_name), 1
)
SELECT pg_size_pretty(sum(pg_total_relation_size(tablename))) from my_table;
