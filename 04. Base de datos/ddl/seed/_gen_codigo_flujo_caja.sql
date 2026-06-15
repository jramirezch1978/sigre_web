-- TX 4d: finanzas.actividad_flujo_caja + grupo_codigo_flujo_caja + codigo_flujo_caja
-- Fuente: data/FIN_ACTIVIDAD_FLUJO.json + data/GRUPO_COD_FLUJO_CAJA.json + data/CODIGO_FLUJO_CAJA.json
-- Regenerar: python scripts/gen_seed_codigo_flujo_caja.py
-- ============================================================
BEGIN;

DELETE FROM finanzas.codigo_flujo_caja;
DELETE FROM finanzas.grupo_codigo_flujo_caja;

-- ACTIVIDAD FLUJO CAJA (3 registros)
INSERT INTO finanzas.actividad_flujo_caja
(id, codigo, nombre, orden, flag_tipo_flujo, flag_estado) VALUES
    (1, '01', 'OPERACIONES', 10, 'E', '1'),
    (2, '02', 'INVERSIONES', 20, 'E', '1'),
    (3, '03', 'FINANCIAMIENTO', 30, 'F', '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    orden = EXCLUDED.orden,
    flag_tipo_flujo = EXCLUDED.flag_tipo_flujo,
    flag_estado = EXCLUDED.flag_estado;

SELECT setval(
    pg_get_serial_sequence('finanzas.actividad_flujo_caja', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM finanzas.actividad_flujo_caja)
);

-- GRUPO CODIGO FLUJO CAJA (19 registros)
INSERT INTO finanzas.grupo_codigo_flujo_caja
(id, codigo, nombre, flag_reporte, factor, orden, actividad_flujo_caja_id, fec_registro, flag_estado) VALUES
    (1, 'EGR00001', 'MATERIA PRIMA', 'G', 'E', 1, 1, '2014-08-22'::date, '1'),
    (2, 'EGR00009', 'INVERSIONES', 'G', 'E', 1, 2, '2014-08-22'::date, '1'),
    (3, 'EGR00010', 'FINANCIAMIENTO', 'G', 'E', 1, 3, '2014-08-22'::date, '1'),
    (4, 'ING00001', 'INGRESOS POR VENTAS', 'G', 'I', 1, 1, '2014-08-22'::date, '1'),
    (5, 'ING00003', 'INGRESOS POR FINANCIAMIENTO', 'G', 'I', 1, 3, '2014-08-22'::date, '1'),
    (6, 'ING00004', 'AMORIZACION PRESTAMO A VINCULA', 'G', 'I', 1, 3, '2015-01-20'::date, '1'),
    (7, 'EGR00002', 'MANO DE OBRA', 'G', 'E', 2, 1, '2014-08-22'::date, '1'),
    (8, 'ING00002', 'INGRESOS TRIBUTARIOS', 'G', 'I', 2, 1, '2014-08-22'::date, '1'),
    (9, 'EGR00003', 'SUMINISTROS', 'G', 'E', 3, 1, '2014-08-22'::date, '1'),
    (10, 'ING00005', 'OTROS INGRESOS', 'G', 'I', 3, 1, '2015-02-03'::date, '1'),
    (11, 'EGR00004', 'SERVICIOS', 'G', 'E', 4, 1, '2014-08-22'::date, '1'),
    (12, 'EGR00005', 'SERVICIOS PROFESIONALES', 'G', 'E', 5, 1, '2014-08-22'::date, '1'),
    (13, 'EGR00006', 'TRIBUTOS', 'G', 'E', 6, 1, '2014-08-22'::date, '1'),
    (14, 'EGR00007', 'MANTENIMIENTO DE PLANTA', 'G', 'E', 7, 1, '2014-08-22'::date, '1'),
    (15, 'EGR00008', 'OTROS EGRESOS', 'G', 'E', 8, 1, '2014-08-22'::date, '1'),
    (16, 'EGR00011', 'MANTENIMIENTO DE FLOTA', 'G', 'E', 9, 1, '2015-01-15'::date, '1'),
    (17, 'EGR00012', 'MANTENIMIENTO ADMINISTRACION', 'G', 'E', 10, 1, '2015-01-28'::date, '1'),
    (18, 'EGR00013', 'SERVICIO DE VIGILANCIA', 'G', 'E', 11, 1, '2015-03-04'::date, '1'),
    (19, 'EGR00014', 'REPUESTOS, MATERIALES Y OTROS', 'G', 'E', 12, 1, '2015-03-31'::date, '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    flag_reporte = EXCLUDED.flag_reporte,
    factor = EXCLUDED.factor,
    orden = EXCLUDED.orden,
    actividad_flujo_caja_id = EXCLUDED.actividad_flujo_caja_id,
    fec_registro = EXCLUDED.fec_registro,
    flag_estado = EXCLUDED.flag_estado;

SELECT setval(
    pg_get_serial_sequence('finanzas.grupo_codigo_flujo_caja', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM finanzas.grupo_codigo_flujo_caja)
);

INSERT INTO finanzas.codigo_flujo_caja (
    codigo, grupo_codigo_flujo_caja_id, nombre, tipo, factor, factor_flujo_caja,
    orden, fec_registro, cod_usr, flag_estado
)
SELECT
    v.codigo,
    v.grupo_codigo_flujo_caja_id,
    v.nombre,
    v.tipo,
    v.factor::numeric,
    v.factor_flujo_caja,
    v.orden,
    v.fec_registro,
    v.cod_usr,
    v.flag_estado
FROM (VALUES
    ('EGR00046', 11, 'SERVICIO DE ALQUILER', 'EGRESO', NULL::numeric, 0, 12, '2015-02-11'::date, 'mroque', '1'),
    ('EGR00058', 19, 'AGREGADOS Y MINERALES', 'EGRESO', NULL::numeric, 0, 1, '2015-04-15'::date, 'mroque', '1'),
    ('EGR00063', 15, 'DESCUENTO JUDICIAL', 'EGRESO', NULL::numeric, 0, 2, '2015-05-19'::date, 'mroque', '1'),
    ('EGR00067', 19, 'ACTIVOS FIJO', 'EGRESO', NULL::numeric, 0, 6, '2015-05-28'::date, 'mroque', '1'),
    ('EGR00068', 15, 'SUBCIDIOS', 'EGRESO', NULL::numeric, 0, 7, '2015-07-08'::date, 'mroque', '1'),
    ('EGR00075', 19, 'INSUMOS PARA PRODUCCION', 'EGRESO', NULL::numeric, 0, 7, '2015-11-24'::date, 'mroque', '1'),
    ('EGR00041', 14, 'ALQUILER DE MAQUINARIAS A TERCEROS', 'EGRESO', NULL::numeric, 0, 1, '2015-01-17'::date, 'mroque', '1'),
    ('EGR00056', 11, 'TRANSPORTE DE MATERIA PRIMA Y PPTT', 'EGRESO', NULL::numeric, 0, 18, '2015-04-09'::date, 'mroque', '1'),
    ('EGR00059', 19, 'MENAJES', 'EGRESO', NULL::numeric, 0, 5, '2015-04-16'::date, 'mroque', '1'),
    ('EGR00060', 19, 'UTILES DE LIMPIEZA', 'EGRESO', NULL::numeric, 0, 6, '2015-04-16'::date, 'mroque', '1'),
    ('EGR00061', 11, 'SERVICIO DE TERCERIZACION E INTERMEDIACION LABORAL', 'EGRESO', NULL::numeric, 0, 20, '2015-04-17'::date, 'mroque', '1'),
    ('EGR00078', 19, 'LIBROS NAUTICOS', 'EGRESO', NULL::numeric, 0, 9, '2016-07-06'::date, 'mroque', '1'),
    ('INGR0001', 4, 'COBRANZAS EXPORTACIONES', 'INGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0002', 4, 'COBRANZAS NACIONALES', 'INGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0003', 4, 'COBRANZAS SERVICIOS', 'INGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0004', 8, 'DRAWBACK', 'INGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0005', 8, 'DEVOLUCIÓN IGV', 'INGRESO', NULL::numeric, 0, 5, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00076', 19, 'RECARGA DE G.L.P. PARA COCINA', 'EGRESO', NULL::numeric, 0, 8, '2015-11-25'::date, 'mroque', '1'),
    ('EGR00004', 1, 'COMPRA ANCHOVETA', 'EGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00005', 7, 'EMPLEADOS', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00006', 7, 'TRIPULANTES', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00007', 7, 'OBREROS', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00008', 7, 'SERVICE', 'EGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00009', 7, 'OTROS', 'EGRESO', NULL::numeric, 0, 5, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00010', 9, 'DIESEL EMBARCACIONES', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00011', 9, 'BUNKER PLANTA', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00012', 9, 'PETROLEO OTROS', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0007', 8, 'REINTEGROS O DESCUENTOS POR NOTAS DE VENTA', 'INGRESO', NULL::numeric, 0, 6, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00013', 9, 'OTROS SUMINISTROS', 'EGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00014', 11, 'AGUA', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00015', 11, 'LUZ', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00016', 11, 'TELEFONO', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00017', 11, 'ESTACION NAVAL', 'EGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00018', 11, 'CERTIFICACION SANITARIA', 'EGRESO', NULL::numeric, 0, 5, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00019', 11, 'TRANSPORTE DE PERSONAL', 'EGRESO', NULL::numeric, 0, 6, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00020', 11, 'FLETE MARITIMO', 'EGRESO', NULL::numeric, 0, 7, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00021', 11, 'OTROS SERVICIOS', 'EGRESO', NULL::numeric, 0, 8, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00022', 12, 'RECIBOS PLANTA HARINA', 'EGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00023', 12, 'RECIBOS DE ASESORAMIENTO FISCAL', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00024', 12, 'RECIBOS DE ASESORAMIENTO LABORAL', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00025', 12, 'OTROS RECIBOS PROFESIONALES', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00026', 13, 'IMPUESTOS', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00027', 13, 'TASAS', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00028', 13, 'CONTRIBUCIONES', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00029', 14, 'MTTO DE PLANTA', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00030', 15, 'OTROS EGRESOS', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00031', 2, 'PLANTA DE CONGELADO', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00032', 2, 'PLANTA DE HARINA', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00033', 2, 'EMBARCACIONES', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00034', 3, 'PRESTAMOS', 'EGRESO', NULL::numeric, 0, 1, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00035', 3, 'OTROS', 'EGRESO', NULL::numeric, 0, 6, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00036', 3, 'SERVICIO DEUDA', 'EGRESO', NULL::numeric, 0, 5, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00037', 3, 'PAGARE DE CAPITAL DE TRABAJO', 'EGRESO', NULL::numeric, 0, 4, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00038', 3, 'LEASING', 'EGRESO', NULL::numeric, 0, 3, '2014-08-22'::date, 'jarch', '1'),
    ('EGR00039', 3, 'VINCULADAS', 'EGRESO', NULL::numeric, 0, 2, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0006', 8, 'OTROS INGRESOS', 'INGRESO', NULL::numeric, 0, 6, '2014-08-22'::date, 'jarch', '1'),
    ('INGR0000', 5, 'INGRESO POR FINANCIAMIENTO', 'INGRESO', NULL::numeric, 0, 1, '2014-09-03'::date, 'jarch', '1'),
    ('EGR00040', 16, 'MTTO DE FLOTA', 'EGRESO', NULL::numeric, 0, 1, '2015-01-16'::date, 'mroque', '1'),
    ('ING00008', 6, 'INMOB CANTABRIA', 'INGRESO', NULL::numeric, 0, 1, '2015-01-20'::date, 'mtaraz', '1'),
    ('EGR00042', 17, 'MTTO DE ADMINISTRACION', 'EGRESO', NULL::numeric, 0, 1, '2015-01-28'::date, 'mroque', '1'),
    ('EGR00043', 11, 'TRANSPORTE DE SUMINISTROS, REPUESTOS Y MATERIALES', 'EGRESO', NULL::numeric, 0, 9, '2015-01-28'::date, 'mroque', '1'),
    ('EGR00044', 11, 'SUBIDA Y BAJADA DE BOLICHE', 'EGRESO', NULL::numeric, 0, 10, '2015-01-28'::date, 'mroque', '1'),
    ('EGR00045', 11, 'MOVIMIENTO DE CARGA', 'EGRESO', NULL::numeric, 0, 11, '2015-01-28'::date, 'mroque', '1'),
    ('INGR0008', 10, 'REEMBOLSOS DIVERSOS', 'INGRESO', NULL::numeric, 0, 1, '2015-02-03'::date, 'jarch', '1'),
    ('EGR00062', 11, 'VIVERES Y ALIMENTACION', 'EGRESO', NULL::numeric, 0, 6, '2015-05-07'::date, 'mroque', '1'),
    ('EGR00065', 16, 'MTTO DE UNIDADES MOVILES Y OTROS BIENES', 'EGRESO', NULL::numeric, 0, 3, '2015-05-27'::date, 'mroque', '1'),
    ('EGR00066', 14, 'MTTO DE UNIDADES MOVILES Y OTROS BIENES', 'EGRESO', NULL::numeric, 0, 3, '2015-05-27'::date, 'mroque', '1'),
    ('INGR0010', 5, 'INGRESO OPERACIONES OVERNIGHT', 'INGRESO', NULL::numeric, 0, 1, '2015-08-21'::date, 'jarch', '1'),
    ('EGR00070', 3, 'EGRESO OPERACIONES OVERNIGHT', 'EGRESO', NULL::numeric, 0, 1, '2015-08-21'::date, 'jarch', '1'),
    ('EGR00048', 11, 'SERVICIO DE VIGILANCIA', 'EGRESO', NULL::numeric, 0, 17, '2015-03-04'::date, 'mroque', '1'),
    ('EGR00049', 11, 'CERTIFICADOS DE EE/PP Y CHATA', 'EGRESO', NULL::numeric, 0, 13, '2015-03-11'::date, 'mroque', '1'),
    ('EGR00050', 11, 'IMPRENTA Y SERIGRAFIA', 'EGRESO', NULL::numeric, 0, 14, '2015-03-11'::date, 'mroque', '1'),
    ('EGR00055', 19, 'MATERIALES DE MTTO Y CONTRUCCION', 'EGRESO', NULL::numeric, 0, 2, '2015-04-09'::date, 'mroque', '1'),
    ('EGR00064', 15, 'FONDO FIJO', 'EGRESO', NULL::numeric, 0, 3, '2015-05-20'::date, 'mroque', '1'),
    ('EGR00074', 19, 'MEDICINA', 'EGRESO', NULL::numeric, 0, 7, '2015-11-09'::date, 'mroque', '1'),
    ('INGR0011', 10, 'DEVOLUCION POR PERDIDA DE EQUIPOS', 'INGRESO', NULL::numeric, 0, 2, '2016-06-08'::date, 'mroque', '1'),
    ('EGR00047', 16, 'ALQUILER DE MAQUINARIA A TERCEROS', 'EGRESO', NULL::numeric, 0, 1, '2015-02-24'::date, 'mroque', '1'),
    ('EGR00051', 12, 'RECIBOS DE ASESORIA LEGAL', 'EGRESO', NULL::numeric, 0, 5, '2015-03-18'::date, 'mroque', '1'),
    ('EGR00052', 11, 'SERVICIO DE LABORATORIO VARIOS', 'EGRESO', NULL::numeric, 0, 15, '2015-03-31'::date, 'mroque', '1'),
    ('EGR00053', 19, 'REPUESTOS MENORES DE MTT', 'EGRESO', NULL::numeric, 0, 15, '2015-03-31'::date, 'mroque', '1'),
    ('EGR00054', 11, 'SERVICIOS DE LIMPIEZA', 'EGRESO', NULL::numeric, 0, 16, '2015-04-04'::date, 'mroque', '1'),
    ('EGR00057', 11, 'SERVICIO DE CALIBRACION DE BALANZAS', 'EGRESO', NULL::numeric, 0, 19, '2015-04-09'::date, 'mroque', '1'),
    ('INGR0009', 6, 'ARCOPA', 'INGRESO', NULL::numeric, 0, 7, '2015-05-07'::date, 'mtaraz', '1'),
    ('EGR00071', 3, 'PAGO DE SWAP BCP 1', 'EGRESO', NULL::numeric, 0, 1, '2015-08-24'::date, 'jarch', '1'),
    ('EGR00072', 14, 'SUMINISTROS Y OTROS PARA MTTO PTA HARINA Y CONSERVAS', 'EGRESO', NULL::numeric, 0, 4, '2015-09-17'::date, 'mroque', '1'),
    ('EGR00073', 16, 'SUMINISTROS Y OTROS PARA MTTO EE/PP', 'EGRESO', NULL::numeric, 0, 4, '2015-09-17'::date, 'mroque', '1'),
    ('EGR00077', 15, 'RETENCION POR EMBARGO DE CTA', 'EGRESO', NULL::numeric, 0, 1, '2016-02-02'::date, 'mroque', '1')
) AS v(codigo, grupo_codigo_flujo_caja_id, nombre, tipo, factor, factor_flujo_caja, orden, fec_registro, cod_usr, flag_estado)
ON CONFLICT (codigo) DO UPDATE SET
    grupo_codigo_flujo_caja_id = EXCLUDED.grupo_codigo_flujo_caja_id,
    nombre = EXCLUDED.nombre,
    tipo = EXCLUDED.tipo,
    factor = EXCLUDED.factor,
    factor_flujo_caja = EXCLUDED.factor_flujo_caja,
    orden = EXCLUDED.orden,
    fec_registro = EXCLUDED.fec_registro,
    cod_usr = EXCLUDED.cod_usr,
    flag_estado = EXCLUDED.flag_estado;

SELECT setval(
    pg_get_serial_sequence('finanzas.codigo_flujo_caja', 'id'),
    (SELECT COALESCE(MAX(id), 1) FROM finanzas.codigo_flujo_caja)
);

COMMIT;

