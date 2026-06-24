-- Datos transaccionales del motor EMP (planilla normal)
-- gan_desct_fijo, grupo_conceptos_seccion (SENATI), fechas_proceso referencia CALCULO.json
BEGIN;

CREATE TABLE IF NOT EXISTS rrhh.calculo_referencia (
    LIKE rrhh.calculo INCLUDING DEFAULTS
);
CREATE TABLE IF NOT EXISTS rrhh.calculo_det_referencia (
    LIKE rrhh.calculo_det INCLUDING DEFAULTS
);

-- Sentinel ONP para cabecera calculo.admin_afp_id NOT NULL cuando trabajador no tiene AFP
INSERT INTO rrhh.admin_afp (nombre, comision_porcentaje, prima_seguro, aporte_obligatorio, flag_estado)
VALUES ('ONP', 0, 0, 13, '1')
ON CONFLICT (nombre) DO UPDATE SET
    aporte_obligatorio = EXCLUDED.aporte_obligatorio,
    flag_estado = EXCLUDED.flag_estado,
    fec_modificacion = NOW();

-- Remuneración básica (concepto 1001) = RMV vigente por tipo EMP
INSERT INTO rrhh.gan_desct_fijo (trabajador_id, concepto_id, imp_gan_desc, flag_estado)
SELECT t.id, cp.id, rmv.rmv, '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_trabajador tt ON tt.id = t.tipo_trabajador_id AND tt.codigo = 'EMP'
JOIN rrhh.concepto_planilla cp ON cp.codigo = '1001'
CROSS JOIN LATERAL (
    SELECT r.rmv
      FROM rrhh.remuneracion_minima_vital r
     WHERE r.tipo_trabajador_id = tt.id AND r.flag_estado = '1'
     ORDER BY r.fecha_desde DESC
     LIMIT 1
) rmv
WHERE t.flag_estado = '1'
  AND NOT EXISTS (
    SELECT 1 FROM rrhh.gan_desct_fijo g
     WHERE g.trabajador_id = t.id AND g.concepto_id = cp.id
  );

-- SENATI: grupo 049 afecto por sección (flag_seccion='1' en grupo_calculo)
INSERT INTO rrhh.grupo_conceptos_seccion (grupo_calculo_id, seccion_id, flag_estado)
SELECT gc.id, s.id, '1'
FROM rrhh.grupo_calculo gc
CROSS JOIN rrhh.seccion s
WHERE gc.codigo = '049'
  AND s.flag_estado = '1'
  AND NOT EXISTS (
    SELECT 1 FROM rrhh.grupo_conceptos_seccion gcs
     WHERE gcs.grupo_calculo_id = gc.id AND gcs.seccion_id = s.id
  );

-- Periodo referencia CALCULO.json (quincena 11-17 jun 2026, EMP CH/LM)
INSERT INTO rrhh.fechas_proceso (
    origen, fec_proceso, fec_inicio, fec_final, flag_replicacion, cod_relacion,
    tipo_trabajador_id, porc_aplica_ctacte, flag_calc_vacaciones, flag_calc_cts,
    flag_calc_gratificacion, flag_bonificacion_pesca, tipo_planilla_id, flag_estado
)
SELECT v.origen, v.fec_proceso::date, v.fec_inicio::date, v.fec_final::date, '1', '1',
       tt.id, NULL, '0', '0', '0', '0', tp.id, '1'
FROM (VALUES
    ('CH', '2026-06-17', '2026-06-11', '2026-06-17'),
    ('LM', '2026-06-17', '2026-06-11', '2026-06-17')
) AS v(origen, fec_proceso, fec_inicio, fec_final)
CROSS JOIN rrhh.tipo_trabajador tt
CROSS JOIN rrhh.tipo_planilla tp
WHERE tt.codigo = 'EMP' AND tp.codigo = 'N'
  AND NOT EXISTS (
    SELECT 1 FROM rrhh.fechas_proceso fp
     WHERE fp.origen = v.origen
       AND fp.fec_proceso = v.fec_proceso::date
       AND fp.fec_inicio = v.fec_inicio::date
       AND fp.fec_final = v.fec_final::date
       AND fp.cod_relacion = '1'
       AND fp.tipo_trabajador_id = tt.id
       AND fp.tipo_planilla_id = tp.id
  );

COMMIT;
