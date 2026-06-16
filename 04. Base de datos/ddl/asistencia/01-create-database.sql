-- BD dedicada asistencia-service (contenedor db-sigre-web, puerto NAT 5433)
-- Esquema de tablas: asistencia-service (hibernate ddl-auto=update)

GRANT ALL ON SCHEMA public TO "sigre-web";
GRANT ALL ON SCHEMA public TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE "sigre-web" IN SCHEMA public
  GRANT ALL ON TABLES TO "sigre-web";
ALTER DEFAULT PRIVILEGES FOR ROLE "sigre-web" IN SCHEMA public
  GRANT ALL ON SEQUENCES TO "sigre-web";

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT ALL ON SEQUENCES TO postgres;
