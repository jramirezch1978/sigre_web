BD dedicada asistencia-service (db-sigre-web)
==============================================

Esta base NO forma parte del esquema multitenant SIGRE ERP.
El esquema lo gestiona asistencia-service con hibernate.ddl-auto=update.

Despliegue infra:
  deploy.bat stack --force          (contenedor db-sigre-web + rabbitmq)

Verificar conexion:
  database-deploy.bat create-asistencia

Despliegue servicio:
  deploy.bat asistencia-service --force

Variables en deploy/cronos/.env:
  ASISTENCIA_DB_PASSWORD
  ASISTENCIA_DB_HOST  (default crisaor.serveftp.com)
  ASISTENCIA_DB_PORT  (default 5433 — NAT al contenedor db-sigre-web)
