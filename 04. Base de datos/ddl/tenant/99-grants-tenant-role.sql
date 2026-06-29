-- ============================================================
-- Privilegios del rol de aplicación sobre la BD tenant
-- (alineado a TenantProvisioningService.grantTenantSchemaPrivileges)
-- ============================================================
-- Uso (como superusuario / dueño de objetos):
--   psql -v ON_ERROR_STOP=1 -v tenant_role=nombre_rol -d sigre_emp_xxx -f 99-grants-tenant-role.sql
--
-- Antes, en la BD postgres (admin):
--   GRANT CONNECT ON DATABASE sigre_emp_xxx TO nombre_rol;
--   CREATE ROLE nombre_rol LOGIN PASSWORD '...';  -- si aún no existe
-- ============================================================

SELECT format($_$
DO $_inner$
DECLARE
  r text := %L;
  s name;
  schemas name[] := ARRAY[
    'public', 'config', 'auth', 'core', 'almacen', 'compras', 'ventas', 'finanzas',
    'contabilidad', 'rrhh', 'activos', 'produccion', 'auditoria'
  ];
BEGIN
  FOREACH s IN ARRAY schemas LOOP
    IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = s) THEN
      EXECUTE format('GRANT ALL ON SCHEMA %%I TO %%I', s, r);
      EXECUTE format('GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA %%I TO %%I', s, r);
      EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %%I TO %%I', s, r);
      EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %%I GRANT ALL ON TABLES TO %%I', s, r);
      EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %%I GRANT ALL ON SEQUENCES TO %%I', s, r);
    END IF;
  END LOOP;
END
$_inner$;
$_$, :'tenant_role')\gexec
