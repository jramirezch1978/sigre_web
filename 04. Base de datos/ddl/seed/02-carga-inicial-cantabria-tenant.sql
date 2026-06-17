-- ============================================================
-- SIGRE ERP - Patch tenant PESQUERA CANTABRIA (sigre_emp_cantabria)
-- Restaura las 4 sucursales operativas tras clonar desde sigre_template
-- (plantilla ajustada para Blue Coast: solo PI/LM Sullana-Lima).
-- Idempotente: UPSERT sucursales + usuario_sucursal.
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

BEGIN;

-- 1) Sucursal PI → Piura
UPDATE auth.sucursal s SET
    nombre      = 'PIURA',
    direccion   = 'Av. Grau 123',
    ciudad      = 'Piura',
    departamento_id = dep.id,
    provincia_id    = pro.id,
    distrito_id     = dis.id,
    ubigeo      = '200101',
    flag_estado = '1',
    fec_modificacion = NOW()
FROM core.departamento dep
JOIN core.provincia pro ON pro.departamento_id = dep.id AND pro.codigo = '2001'
JOIN core.distrito dis ON dis.provincia_id = pro.id AND dis.codigo = '200101'
WHERE s.codigo = 'PI'
  AND dep.codigo = '20';

-- 2) Sucursal LM → Lima (domicilio fiscal Cantabria)
UPDATE auth.sucursal s SET
    nombre      = 'LIMA',
    direccion   = 'CALLE AMADOR MERINO REYNA 339 INT 501',
    ciudad      = 'San Isidro',
    departamento_id = dep.id,
    provincia_id    = pro.id,
    distrito_id     = dis.id,
    ubigeo      = '150131',
    flag_estado = '1',
    fec_modificacion = NOW()
FROM core.departamento dep
JOIN core.provincia pro ON pro.departamento_id = dep.id AND pro.codigo = '1501'
JOIN core.distrito dis ON dis.provincia_id = pro.id AND dis.codigo = '150131'
WHERE s.codigo = 'LM'
  AND dep.codigo = '15';

-- 3) Sucursales Chiclayo y Chimbote (pueden no existir si la plantilla las eliminó)
INSERT INTO auth.sucursal (codigo, nombre, direccion, ciudad, moneda_defult_id, pais_id, departamento_id, provincia_id, distrito_id, ubigeo, flag_estado)
SELECT v.sufijo, v.nombre, v.direccion, v.ciudad, m_pen.id, pa.id, dep.id, pro.id, dis.id, v.ubigeo, '1'
FROM (
    VALUES
        ('CX', 'CHICLAYO', 'Av. Balta 456', 'Chiclayo', '14', '1401', '140101', '140101'),
        ('CH', 'CHIMBOTE', 'Av. Eduardo Peña Meza 789', 'Chimbote', '02', '0218', '021801', '021801')
) AS v(sufijo, nombre, direccion, ciudad, dep_cod, prov_cod, dist_cod, ubigeo)
JOIN LATERAL (
    SELECT m.id
    FROM core.moneda m
    WHERE m.codigo IN ('SOL', 'PEN')
    ORDER BY CASE m.codigo WHEN 'SOL' THEN 0 WHEN 'PEN' THEN 1 ELSE 2 END, m.id
    LIMIT 1
) m_pen ON TRUE
JOIN core.pais pa ON pa.codigo = 'PE'
JOIN core.departamento dep ON dep.codigo = v.dep_cod
JOIN core.provincia pro ON pro.codigo = v.prov_cod
JOIN core.distrito dis ON dis.codigo = v.dist_cod
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    direccion = EXCLUDED.direccion,
    ciudad = EXCLUDED.ciudad,
    moneda_defult_id = EXCLUDED.moneda_defult_id,
    pais_id = EXCLUDED.pais_id,
    departamento_id = EXCLUDED.departamento_id,
    provincia_id = EXCLUDED.provincia_id,
    distrito_id = EXCLUDED.distrito_id,
    ubigeo = EXCLUDED.ubigeo,
    flag_estado = '1',
    fec_modificacion = NOW();

-- 4) Usuarios Blue Coast (ids 4-8) no aplican en Cantabria
UPDATE auth.usuario SET flag_estado = '0', fec_modificacion = NOW()
WHERE id BETWEEN 4 AND 8;

DELETE FROM auth.usuario_sucursal
WHERE usuario_id BETWEEN 4 AND 8;

-- 5) Usuarios activos del tenant Cantabria → las 4 sucursales
INSERT INTO auth.usuario_sucursal (usuario_id, sucursal_id, flag_estado)
SELECT u.id, s.id, '1'
FROM auth.usuario u
CROSS JOIN auth.sucursal s
WHERE u.flag_estado = '1'
  AND s.flag_estado = '1'
  AND s.codigo IN ('PI', 'LM', 'CX', 'CH')
ON CONFLICT (usuario_id, sucursal_id) DO UPDATE SET
    flag_estado = '1';

SELECT setval(
    pg_get_serial_sequence('auth.usuario_sucursal', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM auth.usuario_sucursal),
    TRUE
);

COMMIT;
