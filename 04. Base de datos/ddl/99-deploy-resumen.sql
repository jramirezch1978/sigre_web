-- Resumen post-deploy: inventario de tablas y filas (solo SQL, sin meta-comandos psql).
-- Ejecutado al final de create-security / create-template / insert / clone.

ANALYZE;

SELECT schemaname AS esquema,
       COUNT(*)::int AS tablas,
       COALESCE(SUM(n_live_tup), 0)::bigint AS filas
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('pg_toast')
GROUP BY schemaname
ORDER BY schemaname;

SELECT COUNT(DISTINCT schemaname)::int AS schemas,
       COUNT(*)::int AS tablas,
       COALESCE(SUM(n_live_tup), 0)::bigint AS filas
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('pg_toast');
