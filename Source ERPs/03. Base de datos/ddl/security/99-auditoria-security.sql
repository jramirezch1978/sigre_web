-- ============================================================
-- Restaurant.pe ERP - Usuarios iniciales + defaults de auditoría
-- ============================================================
-- SOLO para la BD de seguridad (restaurant_pe_security).
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
--   id=9  watoche
--   id=10 eqintegra
--   id=11 hescobar
--   id=12 pcastillo
--   id=13 manuel.yaya
--   id=14 langulo@restaurant.pe
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
    'admin@restaurant.pe',
    '$2a$10$karJCVQAcp6sbMLl0jM3EusmCqW3FbODb9D73DBhaOETMgf3C6kTC',
    'ADMINISTRADOR', 'SISTEMA', 'ADMINISTRADOR SISTEMA',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-04-11T21:15:52.928Z'::timestamptz
),
(
    2,
    'work',
    'work@restaurant.pe',
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
    FALSE, FALSE, 0, NULL, '2026-06-15T17:07:07.971Z'::timestamptz, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-06-15T17:07:07.972Z'::timestamptz
),
(
    4,
    'cjimenez',
    'cjimenez@restaurant.pe',
    '$2b$10$litYD6w5YZHBEN.JszBog.O6VPF/qHMVDxDQLspY.SVd9jNv8MbWG',
    'CARLOS', 'JIMENEZ', 'CARLOS JIMENEZ',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-11T21:15:52.928Z'::timestamptz, '2026-04-11T21:15:52.928Z'::timestamptz
),
(
    5,
    'ecastro',
    'ecastro@restaurant.pe',
    '$2a$10$2TLja3iEqAmBxY4GWOam/uCIw5AJrG52NMJDiKgY7xlaH1OkGFE2a',
    'EDIIE', 'CASTRO', 'EDDIE CASTRO',
    FALSE, FALSE, 0, NULL, '2026-06-08T22:12:37.103Z'::timestamptz, '1', '2026-04-13T21:16:17.013Z'::timestamptz, '2026-06-08T22:12:37.104Z'::timestamptz
),
(
    6,
    'wgomez',
    'wgomez@restaurant.pe',
    '$2a$10$karJCVQAcp6sbMLl0jM3EusmCqW3FbODb9D73DBhaOETMgf3C6kTC',
    'EILMAR', 'GOMEZ', 'WILMAR GOMEZ',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-13T21:16:52.301Z'::timestamptz, '2026-04-13T21:16:52.301Z'::timestamptz
),
(
    7,
    'mines',
    'minez@restaurant.pe',
    '$2a$10$FB9MSVcNWmGo.r3OyCf4HePIMg4n1HDGyb9TK/Pz1M5LaoVTCrhCK',
    'MARIA', 'INEZ', 'MARIA INES',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-13T21:17:26.506Z'::timestamptz, '2026-04-13T21:17:26.506Z'::timestamptz
),
(
    8,
    'lpalomeque',
    'lpalomeque@restaurant.pe',
    '$2a$10$FB9MSVcNWmGo.r3OyCf4HePIMg4n1HDGyb9TK/Pz1M5LaoVTCrhCK',
    'LESLYE', 'PALOMEQUE', 'LESLYE PALOMEQUE',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-13T21:18:07.386Z'::timestamptz, '2026-04-13T21:18:07.386Z'::timestamptz
),
(
    9,
    'watoche',
    'watoche@restaurant.pe',
    '$2a$10$frA5AgTohTJOcTPNBQOMBO90w/Wx8HQxbmGYa3XCgpCxJryeUPJce',
    'WILFREDO', 'ATOCHE', 'WILFREDO ATOCHE',
    FALSE, FALSE, 0, NULL, '2026-06-13T17:50:00.617Z'::timestamptz, '1', '2026-04-27T21:37:10.278Z'::timestamptz, '2026-06-13T17:50:00.618Z'::timestamptz
),
(
    10,
    'eqintegra',
    'contabilidad.restpe@gmail.com',
    '$2a$10$lxT/8aSzCCA7Ux3r/VED8OTZjDUXOKP9ISF7PNDVm7SazuF3azB7y',
    'EQUIPO', 'DE INTEGRACION', 'EQUIPO DE INTEGRACION',
    FALSE, FALSE, 0, NULL, NULL, '1', '2026-04-27T21:38:01.733Z'::timestamptz, NULL
),
(
    11,
    'hescobar',
    'consultorexterno4@restaurant.pe',
    '$2a$10$2TLja3iEqAmBxY4GWOam/uCIw5AJrG52NMJDiKgY7xlaH1OkGFE2a',
    'HEIDY', 'ESCOBAR', 'HEYDI ESCOBAR',
    FALSE, FALSE, 0, NULL, '2026-06-08T22:12:37.103Z'::timestamptz, '1', '2026-04-13T21:16:17.013Z'::timestamptz, '2026-06-08T22:12:37.104Z'::timestamptz
),
(
    12,
    'pcastillo',
    'pcastillo@restaurant.pe',
    '$2a$10$2TLja3iEqAmBxY4GWOam/uCIw5AJrG52NMJDiKgY7xlaH1OkGFE2a',
    'CASTILLO', 'PAOLA', 'PAOLA CASTILLO',
    FALSE, FALSE, 0, NULL, '2026-06-08T22:12:37.103Z'::timestamptz, '1', '2026-04-13T21:16:17.013Z'::timestamptz, '2026-06-08T22:12:37.104Z'::timestamptz
),
(
    13,
    'manuel.yaya',
    'manuel.yayap@gmail.com',
    '$2a$10$8i6cwIiebjFMJmAg6Pa5l.KcK4OQRRn00Q.tfG0xmmcHpbONdUCEa',
    'Manuel', 'yaya', 'Manuel yaya',
    FALSE, FALSE, 0, NULL, '2026-06-15T14:52:38.640Z'::timestamptz, '1', '2026-06-13T17:46:47.932Z'::timestamptz, '2026-06-15T14:52:38.641Z'::timestamptz
),
(
    14,
    'langulo@restaurant.pe',
    'langulo@restaurant.pe',
    '$2a$10$HzdPewEA90Z8MCoT.jBxp.Wd7hluW52qteDV6uRTQzR.gFvplrWxO',
    'Luis', 'Angulo', 'Luis Angulo',
    FALSE, FALSE, 0, NULL, '2026-06-15T16:42:55.631Z'::timestamptz, '1', '2026-06-15T16:40:21.060Z'::timestamptz, '2026-06-15T16:42:55.632Z'::timestamptz
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
