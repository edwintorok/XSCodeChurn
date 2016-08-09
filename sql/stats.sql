-- count number of records in all tables
SELECT relname as table,n_live_tup as "# records" 
FROM pg_stat_user_tables 
ORDER BY n_live_tup DESC;
