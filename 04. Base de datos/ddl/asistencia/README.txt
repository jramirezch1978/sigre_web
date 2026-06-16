BD dedicada asistencia-service (contenedor db-sigre-web)
==============================================

Instancia PostgreSQL SEPARADA de postgres17 (ERP). No aparece en :5432.

Despliegue infra:
  deploy.bat stack --force

Crear / recrear BD y rol postgres para DBeaver:
  database-deploy.bat create-asistencia [--force]

Despliegue servicio (sin cambiar JDBC):
  deploy.bat asistencia-service --force

Variables en deploy/cronos/.env:
  ASISTENCIA_DB_PASSWORD   (usuario sigre-web — app)
  POSTGRES_PASSWORD        (usuario postgres creado en db-sigre-web para DBeaver)
  ASISTENCIA_DB_HOST       (default crisaor.serveftp.com)
  ASISTENCIA_DB_PORT       (default 5433 — NAT al contenedor)

Conexion DBeaver (segunda conexion, distinta de postgres17 :5432):
  Host: crisaor.serveftp.com  (o 192.168.0.163 en LAN)
  Puerto: 5433
  Base: db-sigre-web
  Usuario: postgres  /  POSTGRES_PASSWORD
  Usuario app: sigre-web  /  ASISTENCIA_DB_PASSWORD

Esquema tablas: Hibernate ddl-auto=update en asistencia-service.
