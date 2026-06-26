SELECT modulo, tabla, conteo_factory, conteo_total
FROM (
SELECT 'activos' AS modulo, 'core.entidad_contribuyente' AS tabla,
       (SELECT COUNT(*) FROM core.entidad_contribuyente WHERE nro_documento = '20123456789') AS conteo_factory,
       (SELECT COUNT(*) FROM core.entidad_contribuyente) AS conteo_total
UNION ALL SELECT 'activos', 'auth.sucursal',
       (SELECT COUNT(*) FROM auth.sucursal WHERE codigo = 'FACTORY-AF-SUCURSAL' OR codigo = 'FACTORY-AL-SUC'),
       (SELECT COUNT(*) FROM auth.sucursal)
UNION ALL SELECT 'activos', 'contabilidad.centros_costo',
       (SELECT COUNT(*) FROM contabilidad.centros_costo WHERE cencos IN ('FACTORY-AF-CC1','FACTORY-AF-CC2')),
       (SELECT COUNT(*) FROM contabilidad.centros_costo)
UNION ALL SELECT 'activos', 'contabilidad.plan_contable',
       (SELECT COUNT(*) FROM contabilidad.plan_contable WHERE codigo = 'FACTORY-AF-PLAN'),
       (SELECT COUNT(*) FROM contabilidad.plan_contable)
UNION ALL SELECT 'activos', 'contabilidad.plan_contable_det',
       (SELECT COUNT(*) FROM contabilidad.plan_contable_det d
        JOIN contabilidad.plan_contable p ON p.id = d.plan_contable_id WHERE p.codigo = 'FACTORY-AF-PLAN'),
       (SELECT COUNT(*) FROM contabilidad.plan_contable_det)
UNION ALL SELECT 'activos', 'contabilidad.cntbl_libro',
       (SELECT COUNT(*) FROM contabilidad.cntbl_libro WHERE codigo = 'FACTORY-AF-LIB'),
       (SELECT COUNT(*) FROM contabilidad.cntbl_libro)
UNION ALL SELECT 'activos', 'activos.af_clase',
       (SELECT COUNT(*) FROM activos.af_clase WHERE codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_clase)
UNION ALL SELECT 'activos', 'activos.af_sub_clase',
       (SELECT COUNT(*) FROM activos.af_sub_clase WHERE codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_sub_clase)
UNION ALL SELECT 'activos', 'activos.af_ubicacion',
       (SELECT COUNT(*) FROM activos.af_ubicacion WHERE codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_ubicacion)
UNION ALL SELECT 'activos', 'activos.af_tipo_operacion',
       (SELECT COUNT(*) FROM activos.af_tipo_operacion WHERE codigo LIKE 'FACTORY-AF%' OR codigo LIKE 'FBT%'),
       (SELECT COUNT(*) FROM activos.af_tipo_operacion)
UNION ALL SELECT 'activos', 'activos.af_maestro',
       (SELECT COUNT(*) FROM activos.af_maestro WHERE codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_maestro)
UNION ALL SELECT 'activos', 'activos.af_poliza_seguro',
       (SELECT COUNT(*) FROM activos.af_poliza_seguro WHERE numero_poliza LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_poliza_seguro)
UNION ALL SELECT 'activos', 'activos.af_numeracion_config',
       (SELECT COUNT(*) FROM activos.af_numeracion_config WHERE tipo LIKE 'FACTORY-AF%' OR prefijo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_numeracion_config)
UNION ALL SELECT 'activos', 'activos.af_matriz_sub_clase',
       (SELECT COUNT(*) FROM activos.af_matriz_sub_clase m
        JOIN activos.af_sub_clase s ON s.id = m.af_sub_clase_id WHERE s.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_matriz_sub_clase)
UNION ALL SELECT 'activos', 'activos.af_maestro_cc_distrib',
       (SELECT COUNT(*) FROM activos.af_maestro_cc_distrib d
        JOIN activos.af_maestro m ON m.id = d.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_maestro_cc_distrib)
UNION ALL SELECT 'activos', 'activos.af_calculo_cntbl',
       (SELECT COUNT(*) FROM activos.af_calculo_cntbl c
        JOIN activos.af_maestro m ON m.id = c.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_calculo_cntbl)
UNION ALL SELECT 'activos', 'activos.af_adaptacion',
       (SELECT COUNT(*) FROM activos.af_adaptacion a
        JOIN activos.af_maestro m ON m.id = a.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_adaptacion)
UNION ALL SELECT 'activos', 'activos.af_adaptacion_det',
       (SELECT COUNT(*) FROM activos.af_adaptacion_det d
        JOIN activos.af_adaptacion a ON a.id = d.af_adaptacion_id
        JOIN activos.af_maestro m ON m.id = a.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_adaptacion_det)
UNION ALL SELECT 'activos', 'activos.af_adaptacion_dep',
       (SELECT COUNT(*) FROM activos.af_adaptacion_dep d
        JOIN activos.af_adaptacion a ON a.id = d.af_adaptacion_id
        JOIN activos.af_maestro m ON m.id = a.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_adaptacion_dep)
UNION ALL SELECT 'activos', 'activos.af_aseguradora',
       (SELECT COUNT(*) FROM activos.af_aseguradora WHERE nombre LIKE 'Aseguradora factory%' OR nombre LIKE '%factory IT%'),
       (SELECT COUNT(*) FROM activos.af_aseguradora)
UNION ALL SELECT 'activos', 'activos.af_poliza_activo',
       (SELECT COUNT(*) FROM activos.af_poliza_activo pa
        JOIN activos.af_maestro m ON m.id = pa.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_poliza_activo)
UNION ALL SELECT 'activos', 'activos.af_prima_devengo',
       (SELECT COUNT(*) FROM activos.af_prima_devengo p
        JOIN activos.af_poliza_seguro pol ON pol.id = p.af_poliza_seguro_id WHERE pol.numero_poliza LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_prima_devengo)
UNION ALL SELECT 'activos', 'activos.af_traslado',
       (SELECT COUNT(*) FROM activos.af_traslado t
        JOIN activos.af_maestro m ON m.id = t.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_traslado)
UNION ALL SELECT 'activos', 'activos.af_historial',
       (SELECT COUNT(*) FROM activos.af_historial h
        JOIN activos.af_maestro m ON m.id = h.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_historial)
UNION ALL SELECT 'activos', 'activos.af_valuacion',
       (SELECT COUNT(*) FROM activos.af_valuacion v
        JOIN activos.af_maestro m ON m.id = v.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_valuacion)
UNION ALL SELECT 'activos', 'activos.af_venta',
       (SELECT COUNT(*) FROM activos.af_venta v
        JOIN activos.af_maestro m ON m.id = v.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_venta)
UNION ALL SELECT 'activos', 'activos.af_documento',
       (SELECT COUNT(*) FROM activos.af_documento d
        JOIN activos.af_maestro m ON m.id = d.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_documento)
UNION ALL SELECT 'activos', 'activos.af_accesorios',
       (SELECT COUNT(*) FROM activos.af_accesorios a
        JOIN activos.af_maestro m ON m.id = a.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_accesorios)
UNION ALL SELECT 'activos', 'activos.af_software',
       (SELECT COUNT(*) FROM activos.af_software s
        JOIN activos.af_maestro m ON m.id = s.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_software)
UNION ALL SELECT 'activos', 'activos.af_revaluacion',
       (SELECT COUNT(*) FROM activos.af_revaluacion r
        JOIN activos.af_maestro m ON m.id = r.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_revaluacion)
UNION ALL SELECT 'activos', 'activos.af_operaciones',
       (SELECT COUNT(*) FROM activos.af_operaciones o
        JOIN activos.af_maestro m ON m.id = o.af_maestro_id WHERE m.codigo LIKE 'FACTORY-AF%'),
       (SELECT COUNT(*) FROM activos.af_operaciones)
UNION ALL SELECT 'almacen', 'core.unidad_medida',
       (SELECT COUNT(*) FROM core.unidad_medida WHERE codigo IN ('KG','UND','FACTORY-UM') OR codigo LIKE 'FACTORY%'),
       (SELECT COUNT(*) FROM core.unidad_medida)
UNION ALL SELECT 'almacen', 'core.articulo_categ',
       (SELECT COUNT(*) FROM core.articulo_categ WHERE cat_art IN ('MP','BIEN','FACTORY-CAT') OR cat_art LIKE 'FACTORY%'),
       (SELECT COUNT(*) FROM core.articulo_categ)
UNION ALL SELECT 'almacen', 'core.moneda',
       (SELECT COUNT(*) FROM core.moneda WHERE codigo IN ('PEN','USD') OR codigo LIKE 'FACTORY%'),
       (SELECT COUNT(*) FROM core.moneda)
UNION ALL SELECT 'almacen', 'core.articulo',
       (SELECT COUNT(*) FROM core.articulo WHERE codigo LIKE 'ART-%' OR codigo LIKE 'FAB-ART-%'),
       (SELECT COUNT(*) FROM core.articulo)
UNION ALL SELECT 'almacen', 'core.doc_tipo',
       (SELECT COUNT(*) FROM core.doc_tipo WHERE codigo LIKE 'FACTORY%' OR codigo IN ('GR','GT','OC')),
       (SELECT COUNT(*) FROM core.doc_tipo)
UNION ALL SELECT 'almacen', 'almacen.almacen_tipo',
       (SELECT COUNT(*) FROM almacen.almacen_tipo WHERE codigo = 'FACTORY-AL-TIP'),
       (SELECT COUNT(*) FROM almacen.almacen_tipo)
UNION ALL SELECT 'almacen', 'almacen.almacen',
       (SELECT COUNT(*) FROM almacen.almacen WHERE codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.almacen)
UNION ALL SELECT 'almacen', 'almacen.motivo_traslado',
       (SELECT COUNT(*) FROM almacen.motivo_traslado WHERE codigo LIKE 'FACTORY-MT%' OR codigo LIKE 'FAB-MT%'),
       (SELECT COUNT(*) FROM almacen.motivo_traslado)
UNION ALL SELECT 'almacen', 'almacen.articulo_mov_tipo',
       (SELECT COUNT(*) FROM almacen.articulo_mov_tipo WHERE tipo_mov = 'ING-FACT' OR tipo_mov LIKE 'FACTORY%' OR tipo_mov LIKE 'B%'),
       (SELECT COUNT(*) FROM almacen.articulo_mov_tipo)
UNION ALL SELECT 'almacen', 'almacen.ubicacion_almacen',
       (SELECT COUNT(*) FROM almacen.ubicacion_almacen WHERE codigo LIKE 'FACTORY%' OR codigo LIKE 'FAB-%'),
       (SELECT COUNT(*) FROM almacen.ubicacion_almacen)
UNION ALL SELECT 'almacen', 'almacen.lote_pallet',
       (SELECT COUNT(*) FROM almacen.lote_pallet WHERE nro_lote LIKE 'FACTORY-LOTE%' OR nro_lote LIKE 'FAB-LOT%'),
       (SELECT COUNT(*) FROM almacen.lote_pallet)
UNION ALL SELECT 'almacen', 'almacen.almacen_user',
       (SELECT COUNT(*) FROM almacen.almacen_user au
        JOIN almacen.almacen a ON a.id = au.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.almacen_user)
UNION ALL SELECT 'almacen', 'almacen.almacen_tipo_mov',
       (SELECT COUNT(*) FROM almacen.almacen_tipo_mov atm
        JOIN almacen.almacen a ON a.id = atm.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.almacen_tipo_mov)
UNION ALL SELECT 'almacen', 'almacen.vale_mov',
       (SELECT COUNT(*) FROM almacen.vale_mov WHERE nro_vale LIKE 'LM-TEST-%' OR (nro_vale LIKE 'BL%' AND LENGTH(nro_vale) = 12)),
       (SELECT COUNT(*) FROM almacen.vale_mov)
UNION ALL SELECT 'almacen', 'almacen.vale_mov_det',
       (SELECT COUNT(*) FROM almacen.vale_mov_det d
        JOIN almacen.vale_mov v ON v.id = d.vale_mov_id
        WHERE v.nro_vale LIKE 'LM-TEST-%' OR (v.nro_vale LIKE 'BL%' AND LENGTH(v.nro_vale) = 12)),
       (SELECT COUNT(*) FROM almacen.vale_mov_det)
UNION ALL SELECT 'almacen', 'almacen.orden_traslado',
       (SELECT COUNT(*) FROM almacen.orden_traslado WHERE nro_orden_traslado LIKE 'OT%'),
       (SELECT COUNT(*) FROM almacen.orden_traslado)
UNION ALL SELECT 'almacen', 'almacen.orden_traslado_det',
       (SELECT COUNT(*) FROM almacen.orden_traslado_det d
        JOIN almacen.orden_traslado o ON o.id = d.orden_traslado_id WHERE o.nro_orden_traslado LIKE 'OT%'),
       (SELECT COUNT(*) FROM almacen.orden_traslado_det)
UNION ALL SELECT 'almacen', 'almacen.guia',
       (SELECT COUNT(*) FROM almacen.guia WHERE serie IN ('F001','FBL') OR numero LIKE '00001%'),
       (SELECT COUNT(*) FROM almacen.guia)
UNION ALL SELECT 'almacen', 'almacen.guia_det',
       (SELECT COUNT(*) FROM almacen.guia_det d
        JOIN almacen.guia g ON g.id = d.guia_id WHERE g.serie IN ('F001','FBL')),
       (SELECT COUNT(*) FROM almacen.guia_det)
UNION ALL SELECT 'almacen', 'almacen.sol_salida',
       (SELECT COUNT(*) FROM almacen.sol_salida WHERE nro_sol_salida LIKE 'SS%'),
       (SELECT COUNT(*) FROM almacen.sol_salida)
UNION ALL SELECT 'almacen', 'almacen.sol_salida_det',
       (SELECT COUNT(*) FROM almacen.sol_salida_det d
        JOIN almacen.sol_salida s ON s.id = d.sol_salida_id WHERE s.nro_sol_salida LIKE 'SS%'),
       (SELECT COUNT(*) FROM almacen.sol_salida_det)
UNION ALL SELECT 'almacen', 'almacen.inventario_conteo',
       (SELECT COUNT(*) FROM almacen.inventario_conteo ic
        JOIN almacen.almacen a ON a.id = ic.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.inventario_conteo)
UNION ALL SELECT 'almacen', 'almacen.articulo_bonificacion',
       (SELECT COUNT(*) FROM almacen.articulo_bonificacion WHERE descripcion LIKE '%factory%' OR descripcion LIKE '%Factory%'),
       (SELECT COUNT(*) FROM almacen.articulo_bonificacion)
UNION ALL SELECT 'almacen', 'almacen.articulo_almacen',
       (SELECT COUNT(*) FROM almacen.articulo_almacen aa
        JOIN almacen.almacen a ON a.id = aa.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.articulo_almacen)
UNION ALL SELECT 'almacen', 'almacen.articulo_almacen_posicion',
       (SELECT COUNT(*) FROM almacen.articulo_almacen_posicion p
        JOIN almacen.almacen a ON a.id = p.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.articulo_almacen_posicion)
UNION ALL SELECT 'almacen', 'almacen.articulo_almacen_lote',
       (SELECT COUNT(*) FROM almacen.articulo_almacen_lote l
        JOIN almacen.almacen a ON a.id = l.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.articulo_almacen_lote)
UNION ALL SELECT 'almacen', 'almacen.articulo_saldo_mensual',
       (SELECT COUNT(*) FROM almacen.articulo_saldo_mensual s
        JOIN almacen.almacen a ON a.id = s.almacen_id WHERE a.codigo LIKE 'FACTORY-AL%'),
       (SELECT COUNT(*) FROM almacen.articulo_saldo_mensual)
UNION ALL SELECT 'ventas', 'ventas.vta_zona_venta',
       (SELECT COUNT(*) FROM ventas.vta_zona_venta WHERE zona_venta LIKE 'ZB%'),
       (SELECT COUNT(*) FROM ventas.vta_zona_venta)
UNION ALL SELECT 'ventas', 'ventas.vta_zona_despacho',
       (SELECT COUNT(*) FROM ventas.vta_zona_despacho WHERE zona_despacho LIKE 'ZD%'),
       (SELECT COUNT(*) FROM ventas.vta_zona_despacho)
UNION ALL SELECT 'ventas', 'ventas.vta_zona_reparto',
       (SELECT COUNT(*) FROM ventas.vta_zona_reparto WHERE zona_reparto LIKE 'ZR%'),
       (SELECT COUNT(*) FROM ventas.vta_zona_reparto)
UNION ALL SELECT 'ventas', 'ventas.canal_distribucion',
       (SELECT COUNT(*) FROM ventas.canal_distribucion WHERE codigo LIKE 'CANB%'),
       (SELECT COUNT(*) FROM ventas.canal_distribucion)
UNION ALL SELECT 'ventas', 'ventas.servicios_cxc',
       (SELECT COUNT(*) FROM ventas.servicios_cxc WHERE cod_servicio LIKE 'SVC-B%' OR cod_servicio LIKE 'FACTORY%'),
       (SELECT COUNT(*) FROM ventas.servicios_cxc)
UNION ALL SELECT 'ventas', 'ventas.vendedor',
       (SELECT COUNT(*) FROM ventas.vendedor WHERE nombre LIKE 'Vendedor bulk%' OR nombre LIKE '%factory%'),
       (SELECT COUNT(*) FROM ventas.vendedor)
UNION ALL SELECT 'ventas', 'ventas.punto_venta',
       (SELECT COUNT(*) FROM ventas.punto_venta WHERE codigo = 'PV-TEST' OR codigo LIKE 'PVB%'),
       (SELECT COUNT(*) FROM ventas.punto_venta)
UNION ALL SELECT 'ventas', 'ventas.zona',
       (SELECT COUNT(*) FROM ventas.zona WHERE nombre LIKE 'ZONA-BULK-%' OR nombre LIKE 'Zona factory%'),
       (SELECT COUNT(*) FROM ventas.zona)
UNION ALL SELECT 'ventas', 'ventas.mesa',
       (SELECT COUNT(*) FROM ventas.mesa WHERE CAST(numero AS text) = 'M-TEST-01' OR CAST(numero AS text) LIKE 'M-BULK-%'),
       (SELECT COUNT(*) FROM ventas.mesa)
UNION ALL SELECT 'ventas', 'ventas.pedido_mesa',
       (SELECT COUNT(*) FROM ventas.pedido_mesa WHERE CAST(numero AS text) LIKE 'PM-BULK-%'),
       (SELECT COUNT(*) FROM ventas.pedido_mesa)
UNION ALL SELECT 'ventas', 'ventas.pedido_mesa_det',
       (SELECT COUNT(*) FROM ventas.pedido_mesa_det d
        JOIN ventas.pedido_mesa p ON p.id = d.pedido_mesa_id WHERE CAST(p.numero AS text) LIKE 'PM-BULK-%'),
       (SELECT COUNT(*) FROM ventas.pedido_mesa_det)
UNION ALL SELECT 'ventas', 'ventas.comanda',
       (SELECT COUNT(*) FROM ventas.comanda WHERE mesa = 'M-TEST-01' OR mesa LIKE 'M-BULK-%' OR cliente_id = 2),
       (SELECT COUNT(*) FROM ventas.comanda)
UNION ALL SELECT 'ventas', 'ventas.comanda_det',
       (SELECT COUNT(*) FROM ventas.comanda_det d
        JOIN ventas.comanda c ON c.id = d.comanda_id
        WHERE c.mesa = 'M-TEST-01' OR c.mesa LIKE 'M-BULK-%'),
       (SELECT COUNT(*) FROM ventas.comanda_det)
UNION ALL SELECT 'ventas', 'ventas.fs_factura_simpl',
       (SELECT COUNT(*) FROM ventas.fs_factura_simpl WHERE serie IN ('F001','BBL') OR cliente_id = 2),
       (SELECT COUNT(*) FROM ventas.fs_factura_simpl)
UNION ALL SELECT 'ventas', 'ventas.fs_factura_simpl_det',
       (SELECT COUNT(*) FROM ventas.fs_factura_simpl_det d
        JOIN ventas.fs_factura_simpl f ON f.id = d.fs_factura_simpl_id WHERE f.serie IN ('F001','BBL')),
       (SELECT COUNT(*) FROM ventas.fs_factura_simpl_det)
UNION ALL SELECT 'ventas', 'ventas.fs_factura_simpl_pagos',
       (SELECT COUNT(*) FROM ventas.fs_factura_simpl_pagos p
        JOIN ventas.fs_factura_simpl f ON f.id = p.fs_factura_simpl_id WHERE f.serie IN ('F001','BBL')),
       (SELECT COUNT(*) FROM ventas.fs_factura_simpl_pagos)
UNION ALL SELECT 'ventas', 'ventas.entidad_creditos_cxc',
       (SELECT COUNT(*) FROM ventas.entidad_creditos_cxc WHERE entidad_contribuyente_id >= 2),
       (SELECT COUNT(*) FROM ventas.entidad_creditos_cxc)
UNION ALL SELECT 'ventas', 'ventas.cntas_cobrar',
       (SELECT COUNT(*) FROM ventas.cntas_cobrar WHERE serie = 'CXB' OR cliente_id = 2),
       (SELECT COUNT(*) FROM ventas.cntas_cobrar)
UNION ALL SELECT 'ventas', 'ventas.cntas_cobrar_det',
       (SELECT COUNT(*) FROM ventas.cntas_cobrar_det d
        JOIN ventas.cntas_cobrar c ON c.id = d.cntas_cobrar_id WHERE c.serie = 'CXB'),
       (SELECT COUNT(*) FROM ventas.cntas_cobrar_det)
UNION ALL SELECT 'ventas', 'ventas.orden_venta',
       (SELECT COUNT(*) FROM ventas.orden_venta WHERE nro_orden_venta = 'OV-TEST-0001' OR nro_orden_venta LIKE 'OV-BULK-%'),
       (SELECT COUNT(*) FROM ventas.orden_venta)
UNION ALL SELECT 'ventas', 'ventas.orden_venta_det',
       (SELECT COUNT(*) FROM ventas.orden_venta_det d
        JOIN ventas.orden_venta o ON o.id = d.orden_venta_id
        WHERE o.nro_orden_venta = 'OV-TEST-0001' OR o.nro_orden_venta LIKE 'OV-BULK-%'),
       (SELECT COUNT(*) FROM ventas.orden_venta_det)
UNION ALL SELECT 'ventas', 'ventas.proforma',
       (SELECT COUNT(*) FROM ventas.proforma WHERE numero LIKE 'PF-BULK-%' OR numero LIKE 'PF-TEST%'),
       (SELECT COUNT(*) FROM ventas.proforma)
UNION ALL SELECT 'ventas', 'ventas.proforma_det',
       (SELECT COUNT(*) FROM ventas.proforma_det d
        JOIN ventas.proforma p ON p.id = d.proforma_id WHERE p.numero LIKE 'PF-BULK-%'),
       (SELECT COUNT(*) FROM ventas.proforma_det)
UNION ALL SELECT 'ventas', 'ventas.cierre_caja',
       (SELECT COUNT(*) FROM ventas.cierre_caja WHERE observaciones LIKE 'CIERRE-BULK-%'),
       (SELECT COUNT(*) FROM ventas.cierre_caja)
UNION ALL SELECT 'ventas', 'ventas.descuento_promocion',
       (SELECT COUNT(*) FROM ventas.descuento_promocion WHERE nombre LIKE 'PROMO-BULK-%'),
       (SELECT COUNT(*) FROM ventas.descuento_promocion)
UNION ALL SELECT 'ventas', 'ventas.propina',
       (SELECT COUNT(*) FROM ventas.propina p
        JOIN ventas.fs_factura_simpl f ON f.id = p.fs_factura_simpl_id WHERE f.serie = 'BBL'),
       (SELECT COUNT(*) FROM ventas.propina)
UNION ALL SELECT 'ventas', 'ventas.reservacion',
       (SELECT COUNT(*) FROM ventas.reservacion r
        JOIN ventas.mesa m ON m.id = r.mesa_id
        WHERE CAST(m.numero AS text) LIKE 'M-BULK-%' OR CAST(m.numero AS text) = 'M-TEST-01'),
       (SELECT COUNT(*) FROM ventas.reservacion)
UNION ALL SELECT 'ventas', 'ventas.reservacion_det',
       (SELECT COUNT(*) FROM ventas.reservacion_det d
        JOIN ventas.reservacion r ON r.id = d.reservacion_id WHERE r.cliente_id = 2 AND r.fecha = CURRENT_DATE),
       (SELECT COUNT(*) FROM ventas.reservacion_det)
UNION ALL SELECT 'ventas', 'ventas.carta',
       (SELECT COUNT(*) FROM ventas.carta WHERE nombre LIKE 'CARTA-BULK-%'),
       (SELECT COUNT(*) FROM ventas.carta)
UNION ALL SELECT 'ventas', 'ventas.carta_det',
       (SELECT COUNT(*) FROM ventas.carta_det d
        JOIN ventas.carta c ON c.id = d.carta_id WHERE c.nombre LIKE 'CARTA-BULK-%'),
       (SELECT COUNT(*) FROM ventas.carta_det)
) AS conteo
ORDER BY modulo, tabla;
