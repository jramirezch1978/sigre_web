-- Boletas referencia SIGRE (CALCULO.json) en tablas calculo_referencia / calculo_det_referencia
-- Registros: 660
BEGIN;
DELETE FROM rrhh.calculo_det_referencia;
DELETE FROM rrhh.calculo_referencia;

-- Boleta 20000003 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000003';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.08667, 18.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.32365, 3.05253, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 77.41032, 22.88892, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 533.45968, 157.73108, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000003'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000001 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000001';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.67855, 3.15747, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 123.6026, 36.54719, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2008'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 212.12439, 62.72159, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 419.74561, 124.10841, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000001'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000006 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000006';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.79393, 2.8959, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.63717, 25.91283, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 544.23283, 160.91717, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000006'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000005 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000005';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.10987, 2.98932, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 81.95311, 24.23215, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 549.91689, 162.59785, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000005'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000008 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000008';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 94.5, 27.94205, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 687.87, 203.39, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 89.42267, 26.44077, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 95.42267, 28.21487, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 567, 167.6523, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 592.44733, 175.17513, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.159, 1.52543, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.908, 18.30514, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 67.067, 19.83057, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000008'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000007 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000007';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.08667, 18.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.36887, 2.47453, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.76476, 1.40886, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 74.2203, 21.94568, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 536.6497, 158.67432, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000007'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000010 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000010';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.87267, 25.09541, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 227.1976, 67.17847, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2008'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 312.07027, 92.27388, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 340.79973, 100.76612, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000010'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000009 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000009';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 531, 157.0077, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 88.5, 26.16795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 645.87, 190.97, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 83.96267, 24.82634, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 89.96267, 26.60044, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 555.90733, 164.36956, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.844, 1.43229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.128, 17.18746, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 62.972, 18.61975, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000009'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000015 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000015';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.08667, 18.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.36887, 2.47453, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.46843, 2.79965, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.92397, 25.11057, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 525.94603, 155.50943, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000015'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000014 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000014';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 82.14267, 24.28819, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 88.14267, 26.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 543.72733, 160.76771, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000014'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000020 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000020';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.87267, 25.09541, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 90.87267, 26.86951, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 561.99733, 166.17049, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000020'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000016 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000016';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.08667, 18.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.36887, 2.47453, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.46843, 2.79965, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.92397, 25.11057, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 525.94603, 155.50943, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000016'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000018 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000018';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.87267, 25.09541, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 90.87267, 26.86951, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 561.99733, 166.17049, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000018'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000021 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000021';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.08667, 18.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.15389, 1.22823, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 71.24056, 21.06462, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 539.62944, 159.55538, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000021'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000025 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000025';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 65.28667, 19.30416, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.09236, 1.50572, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 76.37903, 22.58398, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 576.49097, 170.45602, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000025'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000024 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000024';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.67855, 3.15747, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 79.86522, 23.6148, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 552.00478, 163.2152, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000024'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000027 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000027';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.79393, 2.8959, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.63717, 25.91283, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 544.23283, 160.91717, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000027'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000026 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000026';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 65.28667, 19.30416, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.94427, 2.64467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 11.03345, 3.2624, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 85.26439, 25.21123, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 567.60561, 167.82877, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000026'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000030 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000030';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.92856, 1.45729, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 76.7718, 22.70012, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 555.0982, 164.12988, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000030'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000029 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000029';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 79.41267, 23.48098, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 85.41267, 25.25508, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 525.45733, 155.36492, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000029'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000040 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000040';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 543.34821, 160.6556, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.67855, 3.15747, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 88.52179, 26.1744, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000040'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000031 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000031';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 46, 46, 5.75, 480.125, 141.9648, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 46, 46, 6.75, 25.425, 7.51774, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 80.02083, 23.6608, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 15, 1252.5, 370.34299, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1463'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 246.15, 72.78238, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1108'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 2084.22, 616.27, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 270.94871, 80.11493, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 18, 5.32229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 288.94871, 85.43722, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 1795.27129, 530.83278, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 13.78553, 4.07615, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 187.57987, 55.46418, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 201.3654, 59.54033, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000031'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000032 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000032';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 65.28667, 19.30416, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.94427, 2.64467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.09236, 1.50572, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 85.3233, 25.22865, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 567.5467, 167.81135, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000032'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000035 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000035';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.92856, 1.45729, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 76.7718, 22.70012, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 555.0982, 164.12988, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000035'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000034 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000034';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 555, 164.10408, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 92.5, 27.35068, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 673.87, 199.25, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 67.38667, 19.92509, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.23197, 2.72974, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.44493, 3.08839, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.06357, 25.74322, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 586.80643, 173.50678, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.054, 1.49438, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 60.648, 17.93258, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 65.702, 19.42696, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000034'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000037 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000037';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 47, 47, 6.88, 25.91467, 7.66253, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 84.69792, 25.04374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 618.8, 182.97, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.88001, 18.29687, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.47756, 2.50667, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.45772, 3.09217, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 47, 47, 5.88, 508.1875, 150.26241, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 86.81529, 25.66981, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 531.98471, 157.30019, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.641, 1.37226, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 55.69201, 16.46718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 60.33301, 17.83944, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000037'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000036 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000036';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 531, 157.0077, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 88.5, 26.16795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 645.87, 190.97, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 64.58667, 19.09718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.84837, 2.61631, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.33387, 3.05555, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 89.76891, 26.54314, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 556.10109, 164.42686, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.844, 1.43229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.128, 17.18746, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 62.972, 18.61975, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000036'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000039 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000039';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.67855, 3.15747, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 88.52179, 26.1744, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 543.34821, 160.6556, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000039'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000038 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000038';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.67855, 3.15747, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 88.52179, 26.1744, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 543.34821, 160.6556, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000038'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000051 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000051';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 248.62, 73.51271, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1108'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 1632.62, 482.74, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 163.262, 48.2738, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 22.36689, 6.61351, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 25.30561, 7.48244, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 12, 3.5482, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 222.9345, 65.91795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 1409.6855, 416.82205, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.38, 3.06919, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 16, 1384, 409.22531, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1463'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 146.9358, 43.44642, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 157.3158, 46.51561, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000051'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000041 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000041';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 605.5, 179.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 60.55, 17.90361, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.29535, 2.45279, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.1174, 1.21745, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 78.96275, 23.34795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 526.53725, 155.69205, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.54125, 1.34277, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.495, 16.11325, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.03625, 17.45602, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000041'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000043 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000043';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 85.5, 25.2809, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 624.87, 184.76, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 62.48667, 18.47625, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.56067, 2.53124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.68543, 2.86382, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 513, 151.6854, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 80.73277, 23.87131, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 544.13723, 160.88869, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.6865, 1.38572, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.238, 16.62862, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 60.9245, 18.01434, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000043'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000042 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000042';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 537, 158.78178, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 89.5, 26.46363, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 652.87, 193.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 65.28667, 19.30416, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.94427, 2.64467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.09236, 1.50572, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 79.3233, 23.45455, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 573.5467, 169.58545, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.8965, 1.44781, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.758, 17.37374, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.6545, 18.82155, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000042'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000046 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000046';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 88.5, 26.16795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 645.87, 190.97, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 64.58667, 19.09718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.84837, 2.61631, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.33387, 3.05555, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 531, 157.0077, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 227.5, 67.26789, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2123'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 317.26891, 93.81103, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 328.60109, 97.15897, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.844, 1.43229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.128, 17.18746, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 62.972, 18.61975, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000046'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000044 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000044';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 82.14267, 24.28819, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 164.9172, 48.76322, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2008'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 253.05987, 74.82551, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 378.81013, 112.00449, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000044'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000048 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000048';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 32, 32, 4, 346, 102.30632, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 32, 32, 5, 18.83333, 5.5687, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 4, 57.66667, 17.05106, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 422.5, 124.93, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 42.25, 12.49261, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.78825, 1.71149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 2.873, 0.8495, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 50.91125, 15.0536, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 371.58875, 109.8764, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 3.16875, 0.93695, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 38.025, 11.24335, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 41.19375, 12.1803, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000048'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000054 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000054';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.79393, 2.8959, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.63717, 25.91283, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 544.23283, 160.91717, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000054'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000052 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000052';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.79393, 2.8959, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 110.0459, 32.5387, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2008'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 191.68307, 56.67743, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 440.18693, 130.15257, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000052'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000053 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000053';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 10.10987, 2.98932, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.95311, 26.00625, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 543.91689, 160.82375, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000053'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000056 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000056';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 605.5, 179.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 78.715, 23.27469, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.715, 25.04879, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 520.785, 153.99121, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.54125, 1.34277, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.495, 16.11325, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.03625, 17.45602, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000056'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000058 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000058';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.79393, 2.8959, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.63717, 25.91283, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 544.23283, 160.91717, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000058'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000061 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000061';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 584.5, 172.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 75.985, 22.46747, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 81.985, 24.24157, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 502.515, 148.58843, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.38375, 1.2962, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 52.605, 15.55441, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.98875, 16.85061, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000061'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000060 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000060';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.92856, 1.45729, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 82.7718, 24.47422, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 549.0982, 162.35578, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000060'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000064 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000064';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 24, 24, 4, 15.06667, 4.45496, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 3, 44.75, 13.23182, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 328.32, 97.08, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 32.83167, 9.70777, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.49794, 1.32996, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 5.08891, 1.5047, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 24, 24, 3, 268.5, 79.39089, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 48.41852, 14.31653, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 279.90148, 82.76347, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 2.46238, 0.72808, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 29.5485, 8.73699, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 32.01088, 9.46507, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000064'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000062 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000062';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 605.5, 179.04, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 78.715, 23.27469, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 84.715, 25.04879, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 520.785, 153.99121, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.54125, 1.34277, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.495, 16.11325, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.03625, 17.45602, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000062'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000069 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000069';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 7, 605.5, 179.03607, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1463'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 106.26, 31.41928, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1108'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 1317.26, 389.49, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 171.2438, 50.63388, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 171.2438, 50.63388, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 1146.0162, 338.85612, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.0825, 2.68554, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 118.5534, 35.05423, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 127.6359, 37.73977, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000069'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000065 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000065';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.92856, 1.45729, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 305.30218, 90.27267, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2008'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 388.07398, 114.74689, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 243.79602, 72.08311, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000065'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000336 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000336';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 83.5, 24.68953, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 610.87, 180.62, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 79.41267, 23.48098, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 501, 148.13718, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 85.41267, 25.25508, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 525.45733, 155.36492, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.5815, 1.35467, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.978, 16.25606, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 59.5595, 17.61073, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000336'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000279 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000279';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 82.14267, 24.28819, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 82.14267, 24.28819, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 549.72733, 162.54181, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000279'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000341 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000341';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 87.5, 25.87226, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 638.87, 188.9, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.88667, 18.8902, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.75247, 2.58796, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.98316, 1.47344, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 77.6223, 22.9516, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 561.2477, 165.9484, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.7915, 1.41677, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 57.498, 17.00118, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 62.2895, 18.41795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 525, 155.23356, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000341'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000413 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000413';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 63.18667, 18.68323, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.65657, 2.5596, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 9.79393, 2.8959, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 87.63717, 25.91283, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 544.23283, 160.91717, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000413'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000423 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000423';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 86.5, 25.57658, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 631.87, 186.83, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 82.14267, 24.28819, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 519, 153.45948, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 6, 1.7741, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2011'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 88.14267, 26.06229, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 543.72733, 160.76771, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.739, 1.40124, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 56.868, 16.8149, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 61.607, 18.21614, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000423'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000558 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000558';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 510, 150.79836, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 85, 25.13306, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 595, 175.93, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 77.35, 22.87108, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 77.35, 22.87108, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 517.65, 153.05892, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.4625, 1.31949, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 53.55, 15.83383, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 58.0125, 17.15332, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000558'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000561 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000561';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 78.5, 23.21112, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 549.5, 162.48, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 54.95, 16.24778, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 7.52815, 2.22595, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2004'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 8.07765, 2.38842, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2005'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 471, 139.26672, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 70.5558, 20.86215, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 478.9442, 141.61785, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.12125, 1.21858, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 49.455, 14.623, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 53.57625, 15.84158, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000561'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

-- Boleta 20000604 2026-06-17 CH
INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)
SELECT t.id, '2026-06-17'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('2026-06-17'::date,'YYYY-MM'), '1', '1'
FROM rrhh.trabajador t
JOIN rrhh.tipo_planilla tp ON tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.codigo='CH' AND s.flag_estado='1'
WHERE t.codigo_trabajador='20000604';

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 6, 525, 155.23356, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 48, 48, 7, 26.36667, 7.79618, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 6, 87.5, 25.87226, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1419'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 638.87, 188.9, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='1499'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='INGRESO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 83.05267, 24.55726, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 83.05267, 24.55726, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2398'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 555.81733, 164.34274, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='2399'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='DESCUENTO'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 4.7915, 1.41677, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3003'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 57.498, 17.00118, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3001'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)
SELECT c.id, cp.id, 1, 0, 0, 0, 62.2895, 18.41795, tcc.id, '1'
FROM rrhh.calculo_referencia c
JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='20000604'
JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='N'
LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='CH'
JOIN rrhh.concepto_planilla cp ON cp.codigo='3099'
JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='APORTE'
WHERE c.fec_proceso='2026-06-17'::date;

COMMIT;