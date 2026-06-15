-- SIGRE ERP — Inicialización multitenant (primera creación del volumen PG 17)

CREATE ROLE erp_app LOGIN PASSWORD 'CHANGE_ME_ERP_APP';
ALTER ROLE erp_app SET client_encoding TO 'UTF8';
ALTER ROLE erp_app SET timezone TO 'America/Lima';

CREATE DATABASE sigre_security
  WITH ENCODING 'UTF8'
  LC_COLLATE 'en_US.utf8'
  LC_CTYPE 'en_US.utf8'
  TEMPLATE template0
  OWNER postgres;

GRANT CONNECT ON DATABASE sigre_security TO erp_app;

CREATE DATABASE template_sigre
  WITH ENCODING 'UTF8'
  LC_COLLATE 'en_US.utf8'
  LC_CTYPE 'en_US.utf8'
  TEMPLATE template0
  OWNER erp_app;

GRANT CONNECT ON DATABASE template_sigre TO erp_app;

CREATE DATABASE sonarqube
  WITH ENCODING 'UTF8'
  LC_COLLATE 'en_US.utf8'
  LC_CTYPE 'en_US.utf8'
  TEMPLATE template0
  OWNER postgres;
