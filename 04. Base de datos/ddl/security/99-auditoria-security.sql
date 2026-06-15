-- ============================================================
-- SIGRE ERP - Usuarios iniciales + defaults de auditoría
-- ============================================================
-- SOLO para la BD de seguridad (sigre_security).
-- Se ejecuta ANTES de 99-auditoria-global.sql para que existan
-- los usuarios cuando se creen las FK de auditoría.
--
-- Usuarios:
--   id=1  admin
--   id=2  work
--   id=3  jramirez
--   id=4  cjimenez
--   id=5  ecastro
--   id=6  wgomez
--   id=7  mines
--   id=8  lpalomeque
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- 1) Usuarios iniciales (sin columnas de auditoría, se agregan después en 99-auditoria-global)
INSERT INTO auth.usuario (
    id, username, email, password, nombres, apellidos, nombre_completo,
    dos_factor_habilitado, bloqueado, intentos_fallidos, bloqueado_hasta, ultimo_login_en, flag_estado,
    fec_creacion, fec_modificacion
) VALUES
(
    1,
    'admin',
    'admin@sigre.pe',
    '$2a$10$karJCVQAcp6sbMLl0jM3EusmCqW3FbODb9D73DBhaOETMgf3C6kTC',
    'ADMINISTRADOR', 'SISTEMA', 'ADMINISTRADOR SISTEMA',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-04-11T21:15:52.928Z'::timestamptz
),
(
    2,
    'work',
    'work@sigre.pe',
    '$2a$10$V3dIARuAlB5lOG8Ry72ohO63y7NYaEcYV3gKueXQMo80CUDy3e1Ni',
    'WORK', 'SYSTEM', 'WORK SYSTEM',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-04-11T21:15:52.928Z'::timestamptz
),
(
    3,
    'jramirez',
    'jramirez@npssac.com.pe',
    '$2a$10$lxT/8aSzCCA7Ux3r/VED8OTZjDUXOKP9ISF7PNDVm7SazuF3azB7y',
    'JHONNY ALEXANDER', 'RAMIREZ CHIROQUE', 'JHONN RAMIREZ CHIROQUE',
    FALSE, FALSE, 0, NULL, '2026-06-11T00:04:29.083Z'::timestamptz, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-06-11T00:04:29.086Z'::timestamptz
),
(
    4,
    'cjimenez',
    'cjimenez@sigre.pe',
    '$2b$10$litYD6w5YZHBEN.JszBog.O6VPF/qHMVDxDQLspY.SVd9jNv8MbWG',
    'CARLOS', 'JIMENEZ', 'CARLOS JIMENEZ',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-04-11T21:15:52.928Z'::timestamptz
),
(
    5,
    'ecastro',
    'ecastro@sigre.pe',
    '$2a$10$2TLja3iEqAmBxY4GWOam/uCIw5AJrG52NMJDiKgY7xlaH1OkGFE2a',
    'EDIIE', 'CASTRO', 'EDDIE CASTRO',
    FALSE, FALSE, 0, NULL, '2026-06-08T22:12:37.103Z'::timestamptz, '1', '2026-04-13T21:16:17.013Z'::timestamptz, '2026-06-08T22:12:37.104Z'::timestamptz
),
(
    6,
    'wgomez',
    'wgomez@sigre.pe',
    '$2a$10$karJCVQAcp6sbMLl0jM3EusmCqW3FbODb9D73DBhaOETMgf3C6kTC',
    'EILMAR', 'GOMEZ', 'WILMAR GOMEZ',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-13T21:16:52.301Z'::timestamptz, '2026-04-13T21:16:52.301Z'::timestamptz
),
(
    7,
    'mines',
    'minez@sigre.pe',
    '$2a$10$FB9MSVcNWmGo.r3OyCf4HePIMg4n1HDGyb9TK/Pz1M5LaoVTCrhCK',
    'MARIA', 'INEZ', 'MARIA INES',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-13T21:17:26.506Z'::timestamptz, '2026-04-13T21:17:26.506Z'::timestamptz
),
(
    8,
    'lpalomeque',
    'lpalomeque@sigre.pe',
    '$2a$10$FB9MSVcNWmGo.r3OyCf4HePIMg4n1HDGyb9TK/Pz1M5LaoVTCrhCK',
    'LESLYE', 'PALOMEQUE', 'LESLYE PALOMEQUE',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-13T21:18:07.386Z'::timestamptz, '2026-04-13T21:18:07.386Z'::timestamptz
),
(
    9,
    'watoche',
    'watoche@sigre.pe',
    '$2a$10$lxT/8aSzCCA7Ux3r/VED8OTZjDUXOKP9ISF7PNDVm7SazuF3azB7y',
    'WILFREDO', 'ATOCHE', 'WILFREDO ATOCHE',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-27T21:37:10.278Z'::timestamptz, NULL
),
(
    10,
    'eqintegra',
    'contabilidad.sigre@gmail.com',
    '$2a$10$lxT/8aSzCCA7Ux3r/VED8OTZjDUXOKP9ISF7PNDVm7SazuF3azB7y',
    'EQUIPO', 'DE INTEGRACION', 'EQUIPO DE INTEGRACION',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-27T21:38:01.733Z'::timestamptz, NULL
),
(
    11,
    'hescobar',
    'consultorexterno4@sigre.pe',
    '$2a$10$2TLja3iEqAmBxY4GWOam/uCIw5AJrG52NMJDiKgY7xlaH1OkGFE2a',
    'HEIDY', 'ESCOBAR', 'HEYDI ESCOBAR',
    FALSE, FALSE, 0, NULL, '2026-06-08T22:12:37.103Z'::timestamptz, '1', '2026-04-13T21:16:17.013Z'::timestamptz, '2026-06-08T22:12:37.104Z'::timestamptz
),
(
    12,
    'pcastillo',
    'pcastillo@sigre.pe',
    '$2a$10$2TLja3iEqAmBxY4GWOam/uCIw5AJrG52NMJDiKgY7xlaH1OkGFE2a',
    'CASTILLO', 'PAOLA', 'PAOLA CASTILLO',
    FALSE, FALSE, 0, NULL, '2026-06-08T22:12:37.103Z'::timestamptz, '1', '2026-04-13T21:16:17.013Z'::timestamptz, '2026-06-08T22:12:37.104Z'::timestamptz
)
ON CONFLICT (id) DO UPDATE SET
    username = EXCLUDED.username,
    email = EXCLUDED.email,
    password = EXCLUDED.password,
    nombres = EXCLUDED.nombres,
    apellidos = EXCLUDED.apellidos,
    nombre_completo = EXCLUDED.nombre_completo,
    dos_factor_habilitado = EXCLUDED.dos_factor_habilitado,
    bloqueado = EXCLUDED.bloqueado,
    intentos_fallidos = EXCLUDED.intentos_fallidos,
    bloqueado_hasta = EXCLUDED.bloqueado_hasta,
    ultimo_login_en = EXCLUDED.ultimo_login_en,
    flag_estado = EXCLUDED.flag_estado,
    fec_modificacion = EXCLUDED.fec_modificacion;

SELECT setval(pg_get_serial_sequence('auth.usuario', 'id'), (SELECT COALESCE(MAX(id), 1) FROM auth.usuario), TRUE);
