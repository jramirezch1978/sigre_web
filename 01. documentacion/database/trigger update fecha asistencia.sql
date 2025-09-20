-- ==========================================
-- FUNCIÓN TRIGGER PARA ACTUALIZAR FEC_UPDATE
-- ==========================================
CREATE OR REPLACE FUNCTION actualizar_fecha_update_asistencia()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si alguno de los campos importantes cambió
    IF (OLD.cod_origen IS DISTINCT FROM NEW.cod_origen OR
        OLD.codigo IS DISTINCT FROM NEW.codigo OR
        OLD.flag_in_out IS DISTINCT FROM NEW.flag_in_out OR
        OLD.fec_movimiento IS DISTINCT FROM NEW.fec_movimiento OR
        OLD.cod_usr IS DISTINCT FROM NEW.cod_usr OR
        OLD.direccion_ip IS DISTINCT FROM NEW.direccion_ip OR
        OLD.turno IS DISTINCT FROM NEW.turno OR
        OLD.lectura_pda IS DISTINCT FROM NEW.lectura_pda) THEN
        
        -- Actualizar fecha de update con timestamp actual
        NEW.fec_update = CURRENT_TIMESTAMP;
		NEW.estado_sync = null;
        
        -- Log de auditoría (opcional)
        RAISE NOTICE 'Trigger: Actualizando fec_update para RECKEY % - Cambio detectado', NEW.reckey;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- CREAR TRIGGER EN TABLA ASISTENCIA_HT580
-- ==========================================
DROP TRIGGER IF EXISTS trigger_update_fecha_asistencia ON asistencia_ht580;

CREATE TRIGGER trigger_update_fecha_asistencia
    BEFORE UPDATE ON asistencia_ht580
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_fecha_update_asistencia();

-- ==========================================
-- VERIFICAR TRIGGER CREADO
-- ==========================================
SELECT 
    trigger_name, 
    event_manipulation, 
    action_timing, 
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'asistencia_ht580'
  AND trigger_name = 'trigger_update_fecha_asistencia';