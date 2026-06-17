-- ============================================================
-- SIGRE ERP - Seed tenant BLUE COAST S.A.C. (sigre_emp_bluecoast)
-- Ejecutar tras clonar desde sigre_template o sobre BD existente.
-- ============================================================
-- Sucursales activas: Sullana (Piura) y Lima (San Isidro).
-- Usuarios capacitación (ids 4-8) sincronizados con auth security.
-- Contraseña temporal capacitación: Capacitacion2026!
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

BEGIN;

-- 1) Sucursal PI → Sullana (Zona Industrial)
UPDATE auth.sucursal s SET
    nombre      = 'SULLANA',
    direccion   = 'Manzana B, Lotes 8-9, Zona Industrial N 2',
    ciudad      = 'Sullana',
    departamento_id = dep.id,
    provincia_id    = pro.id,
    distrito_id     = dis.id,
    ubigeo      = '200601',
    flag_estado = '1',
    fec_modificacion = NOW()
FROM core.departamento dep
JOIN core.provincia pro ON pro.departamento_id = dep.id AND pro.codigo = '2006'
JOIN core.distrito dis ON dis.provincia_id = pro.id AND dis.codigo = '200601'
WHERE s.codigo = 'PI'
  AND dep.codigo = '20';

-- 2) Sucursal LM → Lima (San Isidro) — datos fiscales RUC 20609837340
UPDATE auth.sucursal s SET
    nombre      = 'LIMA',
    direccion   = 'AV. RIVERA NAVARRETE 2801- DPTO. 1606',
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

-- 3) Desactivar sucursales que no aplican a Blue Coast
UPDATE auth.sucursal SET flag_estado = '0', fec_modificacion = NOW()
WHERE codigo IN ('CX', 'CH');

DELETE FROM auth.usuario_sucursal
WHERE sucursal_id IN (SELECT id FROM auth.sucursal WHERE codigo IN ('CX', 'CH'));

-- 4) Usuarios de capacitación (mismos ids y hash que security)
INSERT INTO auth.usuario (
    id, username, email, password, nombres, apellidos, nombre_completo,
    dos_factor_habilitado, bloqueado, ultimo_login_en,
    flag_estado, created_by, fec_creacion, updated_by, fec_modificacion
) VALUES
(
    4, 'anamaria.calderon', 'anamaria.calderon@bluecoastsac.com',
    '$2b$10$a3YqG3QrS7pzuWFkTJf0wOPBK//c6YLiBhDy1iyVV5bVCnaf.595y',
    'ANA MARIA', 'CALDERON CURAY', 'ANA MARIA CALDERON CURAY',
    FALSE, FALSE, NULL, '1', 1, NOW(), 1, NOW()
),
(
    5, 'angela.pena', 'angela.pena@bluecoastsac.com',
    '$2b$10$a3YqG3QrS7pzuWFkTJf0wOPBK//c6YLiBhDy1iyVV5bVCnaf.595y',
    'SANTOS ANGELA', 'PENA ESTRADA', 'SANTOS ANGELA PENA ESTRADA',
    FALSE, FALSE, NULL, '1', 1, NOW(), 1, NOW()
),
(
    6, 'produccion', 'produccion@bluecoastsac.com',
    '$2b$10$a3YqG3QrS7pzuWFkTJf0wOPBK//c6YLiBhDy1iyVV5bVCnaf.595y',
    'CEDRIS BERNABE', 'VASQUEZ ARICA', 'CEDRIS BERNABE VASQUEZ ARICA',
    FALSE, FALSE, NULL, '1', 1, NOW(), 1, NOW()
),
(
    7, 'rodolfo.camino', 'rodolfo.camino@bluecoastsac.com',
    '$2b$10$a3YqG3QrS7pzuWFkTJf0wOPBK//c6YLiBhDy1iyVV5bVCnaf.595y',
    'RODOLFO HORACIO', 'CAMINO CALLE', 'RODOLFO HORACIO CAMINO CALLE',
    FALSE, FALSE, NULL, '1', 1, NOW(), 1, NOW()
),
(
    8, 'javier.camino', 'javier.camino@bluecoastsac.com',
    '$2b$10$a3YqG3QrS7pzuWFkTJf0wOPBK//c6YLiBhDy1iyVV5bVCnaf.595y',
    'FRANCISCO JAVIER', 'CAMINO CALLE', 'FRANCISCO JAVIER CAMINO CALLE',
    FALSE, FALSE, NULL, '1', 1, NOW(), 1, NOW()
)
ON CONFLICT (id) DO UPDATE SET
    username = EXCLUDED.username,
    email = EXCLUDED.email,
    password = EXCLUDED.password,
    nombres = EXCLUDED.nombres,
    apellidos = EXCLUDED.apellidos,
    nombre_completo = EXCLUDED.nombre_completo,
    flag_estado = EXCLUDED.flag_estado,
    updated_by = EXCLUDED.updated_by,
    fec_modificacion = EXCLUDED.fec_modificacion;

SELECT setval(pg_get_serial_sequence('auth.usuario', 'id'), (SELECT COALESCE(MAX(id), 1) FROM auth.usuario), TRUE);

-- 5) Todos los usuarios activos → sucursales Sullana (PI) y Lima (LM)
INSERT INTO auth.usuario_sucursal (usuario_id, sucursal_id, flag_estado)
SELECT u.id, s.id, '1'
FROM auth.usuario u
CROSS JOIN auth.sucursal s
WHERE u.flag_estado = '1'
  AND s.flag_estado = '1'
  AND s.codigo IN ('PI', 'LM')
ON CONFLICT (usuario_id, sucursal_id) DO UPDATE SET
    flag_estado = '1';

SELECT setval(
    pg_get_serial_sequence('auth.usuario_sucursal', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM auth.usuario_sucursal),
    TRUE
);

COMMIT;
