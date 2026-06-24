-- AFP SIGRE desde ADMIN_AFP.json (6 registros)
BEGIN;

CREATE UNIQUE INDEX IF NOT EXISTS IX_ADMIN_AFP_UK_NOMBRE ON rrhh.admin_afp (nombre);

INSERT INTO rrhh.admin_afp (
    nombre, comision_porcentaje, prima_seguro, aporte_obligatorio, flag_estado
)
VALUES
('INTEGRA', 1.55, 1.37, 10, '1'),
('HORIZONTE', 1.85, 1.36, 10, '1'),
('PROFUTURO', 1.69, 1.37, 10, '1'),
('REG. ESP. PENS.', 0, 0, 8, '1'),
('PRIMA AFP', 1.6, 1.37, 10, '1'),
('HABITAT', 1.47, 1.37, 10, '1')
ON CONFLICT (nombre) DO UPDATE SET
    comision_porcentaje = EXCLUDED.comision_porcentaje,
    prima_seguro = EXCLUDED.prima_seguro,
    aporte_obligatorio = EXCLUDED.aporte_obligatorio,
    flag_estado = EXCLUDED.flag_estado,
    fec_modificacion = NOW();

COMMIT;
