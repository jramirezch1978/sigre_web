-- ============================================================
-- SEED MÍNIMO PARA PROBAR MOVIMIENTOS DE ALMACÉN
-- 1 inserción por tabla, orden de dependencias FK
-- Ejecutar en la BD tenant de la empresa
-- ============================================================

-- 1. core.moneda
INSERT INTO core.moneda (codigo, nombre, simbolo, decimales)
VALUES ('PEN', 'Sol Peruano', 'S/', 2)
ON CONFLICT (codigo) DO NOTHING;

-- 2. core.pais
INSERT INTO core.pais (codigo, nombre)
VALUES ('PE', 'Perú')
ON CONFLICT (codigo) DO NOTHING;

-- 3. core.departamento
INSERT INTO core.departamento (codigo, nombre, pais_id)
SELECT '15', 'Lima', p.id FROM core.pais p WHERE p.codigo = 'PE'
ON CONFLICT (codigo) DO NOTHING;

-- 4. core.provincia
INSERT INTO core.provincia (codigo, nombre, departamento_id)
SELECT '1501', 'Lima', d.id FROM core.departamento d WHERE d.codigo = '15'
ON CONFLICT (codigo) DO NOTHING;

-- 5. core.distrito
INSERT INTO core.distrito (codigo, nombre, provincia_id)
SELECT '150101', 'Lima', pr.id FROM core.provincia pr WHERE pr.codigo = '1501'
ON CONFLICT (codigo) DO NOTHING;

-- 6. auth.sucursal
INSERT INTO auth.sucursal (codigo, nombre, direccion, ciudad, moneda_defult_id, pais_id, departamento_id, provincia_id, distrito_id, ubigeo)
SELECT 'SUC-TEST', 'Sucursal Test', 'Av. Test 123', 'Lima',
       m.id, pa.id, dep.id, pro.id, dis.id, '150101'
FROM core.moneda m
JOIN core.pais pa ON pa.codigo = 'PE'
JOIN core.departamento dep ON dep.codigo = '15'
JOIN core.provincia pro ON pro.codigo = '1501'
JOIN core.distrito dis ON dis.codigo = '150101'
WHERE m.codigo = 'PEN'
ON CONFLICT (codigo) DO NOTHING;

-- 7. core.unidad_medida
INSERT INTO core.unidad_medida (codigo, nombre, abreviatura)
VALUES ('KG', 'Kilogramo', 'Kg')
ON CONFLICT (codigo) DO NOTHING;

-- 8. core.articulo_categ
INSERT INTO core.articulo_categ (cat_art, desc_categ)
VALUES ('MAT', 'Materiales')
ON CONFLICT ON CONSTRAINT articulo_categ_pkey DO NOTHING;

-- (asegurar unique index en cat_art)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.articulo_categ WHERE cat_art = 'MAT') THEN
    INSERT INTO core.articulo_categ (cat_art, desc_categ) VALUES ('MAT', 'Materiales');
  END IF;
END $$;

-- 9. core.articulo_sub_categ
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.articulo_sub_categ WHERE cod_sub_cat = 'MAT-GEN') THEN
    INSERT INTO core.articulo_sub_categ (cod_sub_cat, desc_subcateg, articulo_categ_id)
    SELECT 'MAT-GEN', 'Materiales Generales', ac.id
    FROM core.articulo_categ ac WHERE ac.cat_art = 'MAT';
  END IF;
END $$;

-- 10. core.articulo
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.articulo WHERE codigo = 'ART-TEST-001') THEN
    INSERT INTO core.articulo (codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, articulo_sub_categ_id)
    SELECT 'ART-TEST-001', 'Artículo de Prueba', 'MATERIAL',
           um.id, ac.id, asc2.id
    FROM core.unidad_medida um
    JOIN core.articulo_categ ac ON ac.cat_art = 'MAT'
    JOIN core.articulo_sub_categ asc2 ON asc2.cod_sub_cat = 'MAT-GEN'
    WHERE um.codigo = 'KG';
  END IF;
END $$;

-- 10b. core.articulo_impuesto (IGV18 por defecto)
INSERT INTO core.articulo_impuesto (articulo_id, tipos_impuesto_id, orden)
SELECT a.id, ti.id, 1
FROM core.articulo a
JOIN core.tipos_impuesto ti ON ti.tipo_impuesto = 'IGV18'
WHERE a.codigo = 'ART-TEST-001'
ON CONFLICT (articulo_id, tipos_impuesto_id) DO NOTHING;

-- 11. core.entidad_contribuyente (proveedor)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.entidad_contribuyente WHERE nro_documento = '20100000001') THEN
    INSERT INTO core.entidad_contribuyente (tipo_persona, tipo_documento, nro_documento, razon_social, es_proveedor)
    VALUES ('JURIDICA', 'RUC', '20100000001', 'Proveedor Test S.A.C.', TRUE);
  END IF;
END $$;

-- 12. almacen.almacen_tipo
INSERT INTO almacen.almacen_tipo (codigo, nombre)
VALUES ('PRINCIPAL', 'Almacén Principal')
ON CONFLICT (codigo) DO NOTHING;

-- 13. almacen.almacen
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM almacen.almacen a
    JOIN auth.sucursal s ON s.id = a.sucursal_id
    WHERE a.codigo = 'ALM-TEST' AND s.codigo = 'SUC-TEST'
  ) THEN
    INSERT INTO almacen.almacen (sucursal_id, almacen_tipo_id, codigo, nombre)
    SELECT s.id, at2.id, 'ALM-TEST', 'Almacén de Prueba'
    FROM auth.sucursal s
    JOIN almacen.almacen_tipo at2 ON at2.codigo = 'PRINCIPAL'
    WHERE s.codigo = 'SUC-TEST';
  END IF;
END $$;

-- 14. almacen.ubicacion_almacen
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM almacen.ubicacion_almacen ua
    JOIN almacen.almacen a ON a.id = ua.almacen_id
    WHERE ua.codigo = 'UB-A1' AND a.codigo = 'ALM-TEST'
  ) THEN
    INSERT INTO almacen.ubicacion_almacen (almacen_id, codigo, nombre, pasillo, estante, nivel)
    SELECT a.id, 'UB-A1', 'Ubicación A1', 'P1', 'E1', 'N1'
    FROM almacen.almacen a WHERE a.codigo = 'ALM-TEST';
  END IF;
END $$;

-- 15. almacen.articulo_mov_tipo (Ingreso simple: I00 ya existe del seed, creamos uno propio)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM almacen.articulo_mov_tipo WHERE tipo_mov = 'ITS') THEN
    INSERT INTO almacen.articulo_mov_tipo (
      tipo_mov, desc_tipo_mov, flag_contabiliza, flag_solicita_prov,
      flag_solicita_doc_int, flag_solicita_doc_ext, flag_solicita_ref,
      factor_sldo_total, flag_solicita_precio, flag_solicita_lote
    ) VALUES (
      'ITS', 'INGRESO TEST SIMPLE', '0', '0',
      '0', '0', '0',
      1, '1', '0'
    );
  END IF;
END $$;

-- 16. almacen.almacen_tipo_mov (habilitar tipo ITS en ALM-TEST)
DO $$
DECLARE
  v_alm_id BIGINT;
  v_amt_id BIGINT;
BEGIN
  SELECT a.id INTO v_alm_id FROM almacen.almacen a WHERE a.codigo = 'ALM-TEST';
  SELECT amt.id INTO v_amt_id FROM almacen.articulo_mov_tipo amt WHERE amt.tipo_mov = 'ITS';
  IF v_alm_id IS NOT NULL AND v_amt_id IS NOT NULL THEN
    INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id)
    VALUES (v_alm_id, v_amt_id)
    ON CONFLICT (almacen_id, articulo_mov_tipo_id) DO NOTHING;
  END IF;
END $$;

-- 17. contabilidad.centros_costo
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM contabilidad.centros_costo WHERE cencos = 'CC-TEST') THEN
    INSERT INTO contabilidad.centros_costo (cencos, desc_cencos)
    VALUES ('CC-TEST', 'Centro de Costo Test');
  END IF;
END $$;

-- 18. contabilidad.matriz_contable
INSERT INTO contabilidad.matriz_contable (codigo, descripcion)
VALUES ('MT-TEST', 'Matriz Contable Test')
ON CONFLICT (codigo) DO NOTHING;

-- 19. contabilidad.tipo_mov_matriz_subcat
DO $$
DECLARE
  v_mcf_id BIGINT;
BEGIN
  SELECT mcf.id INTO v_mcf_id FROM contabilidad.matriz_contable mcf WHERE mcf.codigo = 'MT-TEST';
  IF v_mcf_id IS NOT NULL
     AND EXISTS (SELECT 1 FROM almacen.articulo_mov_tipo WHERE tipo_mov = 'ITS')
     AND EXISTS (SELECT 1 FROM core.articulo_sub_categ WHERE cod_sub_cat = 'MAT-GEN')
  THEN
    INSERT INTO contabilidad.tipo_mov_matriz_subcat (tipo_mov, grp_cntbl, cod_sub_cat, item, matriz_contable_id)
    VALUES ('ITS', '20', 'MAT-GEN', 1, v_mcf_id)
    ON CONFLICT (tipo_mov, grp_cntbl, cod_sub_cat, item) DO NOTHING;
  END IF;
END $$;

-- ============================================================
-- CONSULTA FINAL: muestra los IDs para usar en Postman
-- ============================================================
SELECT '>>> IDs para tu JSON de Postman <<<' AS info;

SELECT 'sucursalId' AS campo, s.id AS valor, s.codigo FROM auth.sucursal s WHERE s.codigo = 'SUC-TEST'
UNION ALL
SELECT 'almacenId', a.id, a.codigo FROM almacen.almacen a WHERE a.codigo = 'ALM-TEST'
UNION ALL
SELECT 'articuloMovTipoId', amt.id::BIGINT, amt.tipo_mov FROM almacen.articulo_mov_tipo amt WHERE amt.tipo_mov = 'ITS'
UNION ALL
SELECT 'articuloId', ar.id, ar.codigo FROM core.articulo ar WHERE ar.codigo = 'ART-TEST-001'
UNION ALL
SELECT 'proveedorId', ec.id, ec.nro_documento FROM core.entidad_contribuyente ec WHERE ec.nro_documento = '20100000001'
UNION ALL
SELECT 'centrosCostoId', cc.id, cc.cencos FROM contabilidad.centros_costo cc WHERE cc.cencos = 'CC-TEST'
UNION ALL
SELECT 'ubicacionAlmacenId', ua.id, ua.codigo FROM almacen.ubicacion_almacen ua WHERE ua.codigo = 'UB-A1';
