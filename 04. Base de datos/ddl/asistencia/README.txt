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

Verificar conexion (docker exec en cronos, no requiere NAT 5433):
  database-deploy.bat create-asistencia

Opcional acceso externo psql (requiere NAT router -> 5433):
  ASISTENCIA_DB_HOST=crisaor.serveftp.com
  ASISTENCIA_DB_PORT=5433
