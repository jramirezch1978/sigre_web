-- ============================================================
-- SIGRE ERP - Security DB - Funciones, Procedimientos y Triggers
-- Ejecutar DESPUÉS de toda la estructura de tablas (00 a 04)
-- y ANTES de la carga inicial de datos (seed/).
-- ============================================================
--
-- CONTENIDO:
--   auth.fn_notificacion_origen_distinto_destino() + trigger
--     TR_NOTIFICACION_ORIGEN_DESTINO sobre auth.notificacion
--
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- ============================================================
-- auth.notificacion: el usuario origen (usuario_id) no puede ser
-- el mismo que el usuario destino (usuario_destino_id).
-- Se valida en INSERT y UPDATE.
-- ============================================================
CREATE OR REPLACE FUNCTION auth.fn_notificacion_origen_distinto_destino()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.usuario_destino_id IS NOT NULL AND NEW.usuario_id = NEW.usuario_destino_id THEN
        RAISE EXCEPTION 'El usuario origen y el usuario destino no pueden ser el mismo (usuario_id = %).', NEW.usuario_id
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS TR_NOTIFICACION_ORIGEN_DESTINO ON auth.notificacion;
CREATE TRIGGER TR_NOTIFICACION_ORIGEN_DESTINO
    BEFORE INSERT OR UPDATE ON auth.notificacion
    FOR EACH ROW
    EXECUTE FUNCTION auth.fn_notificacion_origen_distinto_destino();
