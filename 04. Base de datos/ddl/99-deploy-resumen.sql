-- Resumen post-deploy: inventario de tablas y filas.
-- Ejecutado al final de create-security / create-template / insert / clone.

ANALYZE;

\pset pager off
\pset border 2
\pset format aligned

\echo ''
\echo '--- Inventario por schema (tabla y filas) ---'
\echo ''

SELECT
    schemaname AS esquema,
    relname AS tabla,
    COALESCE(n_live_tup, 0)::bigint AS filas
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('pg_toast')
ORDER BY schemaname, relname;

\echo ''
\echo '--- Totales por schema ---'
\echo ''

SELECT
    schemaname AS esquema,
    COUNT(*)::int AS tablas,
    COALESCE(SUM(n_live_tup), 0)::bigint AS filas
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('pg_toast')
GROUP BY schemaname
ORDER BY schemaname;

\echo ''
\echo '--- Totales generales ---'
\echo ''

SELECT
    COUNT(DISTINCT schemaname)::int AS schemas,
    COUNT(*)::int AS tablas,
    COALESCE(SUM(n_live_tup), 0)::bigint AS filas
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('pg_toast');
