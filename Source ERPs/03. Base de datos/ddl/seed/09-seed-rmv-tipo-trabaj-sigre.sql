-- RMV por tipo trabajador SIGRE (RMV_X_TIPO_TRABAJ.json)
-- Registros: 26
BEGIN;
INSERT INTO rrhh.remuneracion_minima_vital (tipo_trabajador_id, rmv, fecha_desde, flag_estado)
SELECT tt.id, v.rmv, v.fecha_desde::date, '1'
FROM (VALUES
('DES', 550, '2009-01-01'),
('DES', 580, '2010-12-27'),
('DES', 600, '2011-02-01'),
('DES', 675, '2011-09-01'),
('DES', 750, '2012-01-01'),
('EJO', 550, '2009-01-01'),
('EMP', 550, '2009-01-01'),
('EMP', 580, '2010-12-27'),
('EMP', 600, '2011-02-01'),
('EMP', 675, '2011-08-01'),
('EMP', 750, '2012-01-01'),
('EMP', 930, '2018-04-01'),
('EMP', 1025, '2022-04-03'),
('FUN', 550, '2009-01-01'),
('JOR', 550, '2009-01-01'),
('JOR', 643.8, '2010-01-01'),
('JOR', 930, '2018-04-01'),
('JOR', 1025, '2022-04-03'),
('SER', 600, '2011-02-01'),
('TRI', 550, '2009-01-01'),
('TRI', 580, '2010-12-27'),
('TRI', 600, '2011-02-01'),
('TRI', 675, '2011-08-01'),
('TRI', 750, '2012-01-01'),
('TRI', 930, '2018-04-01'),
('TRI', 1025, '2022-04-03')
) AS v(tipo_codigo, rmv, fecha_desde)
JOIN rrhh.tipo_trabajador tt ON tt.codigo = v.tipo_codigo
ON CONFLICT (tipo_trabajador_id, rmv, fecha_desde) DO UPDATE SET
    flag_estado = EXCLUDED.flag_estado,
    fec_modificacion = NOW();
COMMIT;
