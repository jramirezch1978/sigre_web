-- ============================================================
-- SIGRE ERP - Convenciones DDL PostgreSQL (idempotente)
-- ============================================================
-- Objetivo:
--   - Definir convenciones base de ejecucion para scripts DDL.
--   - Este archivo no crea tablas funcionales; solo prepara contexto.
--
-- Regla de idempotencia:
--   - Todos los scripts deben poder ejecutarse multiples veces sin error.
--   - Usar CREATE ... IF NOT EXISTS / ALTER ... ADD COLUMN IF NOT EXISTS.
--   - Para constraints, validar existencia en pg_constraint.
--
-- Regla de PRIMARY KEY (OBLIGATORIA):
--   - TODA tabla debe tener como PK una columna "id" autogenerada:  id BIGSERIAL PRIMARY KEY
--   - Las claves de negocio (codigo, ubigeo, etc.) van como UNIQUE, NO como PK.
--   - Las FK referencian SIEMPRE el "id" de la tabla destino
--     (p.ej. almacen.ubigeo -> core.sunat_ubigeo(id)), nunca la clave de negocio.
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- Esquemas base esperados (security + tenant)
CREATE SCHEMA IF NOT EXISTS master;
CREATE SCHEMA IF NOT EXISTS config;
CREATE SCHEMA IF NOT EXISTS auth;

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS almacen;
CREATE SCHEMA IF NOT EXISTS compras;
CREATE SCHEMA IF NOT EXISTS ventas;
CREATE SCHEMA IF NOT EXISTS finanzas;
CREATE SCHEMA IF NOT EXISTS contabilidad;
CREATE SCHEMA IF NOT EXISTS rrhh;
CREATE SCHEMA IF NOT EXISTS activos;
CREATE SCHEMA IF NOT EXISTS produccion;
CREATE SCHEMA IF NOT EXISTS auditoria;

-- ============================================================
-- CATALOGO VIRTUAL: flag_estado  (campo tipo flag)
-- ============================================================
-- flag_estado es un campo VARCHAR(1) numerico presente en la
-- mayoria de tablas del ERP. Funciona como una tabla de estados
-- que NO existe fisicamente; los valores estan definidos aqui
-- como referencia unica y son inmutables.
--
-- Cada tabla usa SOLO el subconjunto que aplica a su dominio,
-- restringido mediante CHECK constraint. No todas las tablas
-- necesitan todos los valores.
--
-- VALORES GLOBALES (catalogo completo):
--   '0' = Anulado          (registro invalidado, no se elimina)
--   '1' = Activo           (registro vigente, default general)
--   '2' = Cerrado          (finalizado, no admite mas cambios)
--   '3' = Pendiente        (requiere aprobacion o accion)
--   '4' = Pagado parcial   (aplica a documentos financieros)
--   '5' = Pagado total     (aplica a documentos financieros)
--   '6' = En proceso       (en ejecucion, aun no finalizado)
--   '7' = Devuelto         (aplica a documentos/mercaderia)
--   '8' = Suspendido       (pausado temporalmente)
--   '9' = Observado        (con observaciones, requiere revision)
--
-- EJEMPLOS DE USO POR DOMINIO:
--   Tablas maestras       : '0'=Inactivo, '1'=Activo
--   control_calidad       : '0'=Anulado,'1'=Aprobado,'9'=Observado
--   documentos financieros: '0','1','3','4'=Pago parcial,'5'=Pago total
--   ordenes de compra     : '0','1','2'=Cerrada,'3'=Pendiente,'6'=En proceso
-- ============================================================
-- AUDITORÍA: fechas gestionadas por la base de datos
-- ============================================================
-- Columnas estándar: created_by, fec_creacion, updated_by, fec_modificacion
-- fec_creacion (NOT NULL): DEFAULT NOW() + trigger BEFORE INSERT si llega NULL
-- fec_modificacion (opcional): trigger BEFORE UPDATE en tablas con auditoría
-- Script: ddl/99-auditoria-triggers-fechas.sql (post 99-auditoria-global.sql)
-- La aplicación no debe ser la fuente de verdad para estas fechas.
-- ============================================================

DO $$
BEGIN
    RAISE NOTICE '[DDL] Convenciones base cargadas correctamente.';
END $$;

