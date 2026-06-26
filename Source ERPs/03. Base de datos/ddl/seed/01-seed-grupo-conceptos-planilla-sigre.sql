-- Catálogo SIGRE GRUPO_CALC_CONCEPTO (GRUPO_CALC_CONCEPTO.json)
INSERT INTO rrhh.grupo_conceptos_planilla (codigo, nombre, concepto_codigo, flag_replicacion, flag_estado)
VALUES
('13', 'FLOTA PROPIA', NULL, '1', '1'),
('24', 'DESCUENTOS DE INASISTENCIAS', NULL, '1', '1'),
('23', 'DESCUENTOS VARIABLES', NULL, '1', '1'),
('14', 'GANANCIAS VARIABLES', NULL, '1', '1'),
('10', 'GANANCIAS FIJAS', NULL, '1', '1'),
('11', 'SOBRETIEMPOS', NULL, '1', '1'),
('12', 'DESTAJO', NULL, '1', '1'),
('20', 'DESCUENTOS DE LEY', NULL, '1', '1'),
('21', 'DESCUENTOS DE CUENTA CORRIENTE', NULL, '1', '1'),
('22', 'DESCUENTOS FIJOS', NULL, '1', '1'),
('30', 'APORTACIONES DE LA EMPRESA', NULL, '1', '1'),
('70', 'CONCEPTOS VARIOS', NULL, '1', '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    concepto_codigo = EXCLUDED.concepto_codigo,
    flag_replicacion = EXCLUDED.flag_replicacion,
    flag_estado = EXCLUDED.flag_estado;
