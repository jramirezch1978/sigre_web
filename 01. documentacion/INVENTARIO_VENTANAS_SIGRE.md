# Inventario de Ventanas del ERP SIGRE

Inventario de ventanas PowerBuilder (.srw) de negocio organizadas por módulo.
Se excluyen ventanas genéricas del framework (w_abc_*, w_logon, w_main, popups, búsquedas, etc.).

- **S/C** = Sin Código explícito en el título de la ventana

---

## 1. Activo Fijo

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_af009_parametros_calculo | AF009 | Parámetros de operaciones de activos |
| w_af010_parametros | AF010 | Parámetros de control del módulo |
| w_af011_numerador_activo | AF011 | Numerador/secuenciador de activos |
| w_af012_registro_operaciones | AF012 | Registro de operaciones de activos |
| w_af013_tipo_incidencias | AF013 | Catálogo de tipos de incidencias |
| w_af014_indice_precio | AF014 | Índices de precios para revaluación |
| w_af015_tipo_seguros | AF015 | Tipos de seguros de activos |
| w_af016_aseguradoras | AF016 | Catálogo de aseguradoras |
| w_af017_numerador_traslados | AF017 | Numerador de traslados |
| w_af020_clase_sub_clase_activo | AF020 | Clases y subclases de activos |
| w_af023_software | AF023 | Mantenimiento de software |
| w_af024_matriz_contable | AF024 | Cuentas de cargo por centros de costo |
| w_af025_ubicacion | AF024 | Ubicación de activos |
| w_af300_maestro | AF300 | Maestro de activo fijo |
| w_af301_traslado_activos | AF301 | Traslado de activos |
| w_af302_aprobacion_traslados | AF302 | Aprobación de traslados |
| w_af303_poliza_seguro | AF303 | Pólizas de seguros de activos |
| w_af304_usuarios_responsables | AF304 | Usuarios responsables de activos |
| w_af305_venta_activos | AF305 | Venta de activos |
| w_af306_revaluaciones | AF306 | Revaluaciones de activos |
| w_af307_operaciones_activo | AF307 | Operaciones de activos (mejoras, etc.) |
| w_af700_resumen_activo_fijo | AF700 | Resumen de activos fijos |
| w_af701_depre_anual_x_activo | AF701 | Depreciación anual por activo |
| w_af702_resumen_activo_fijo_x_rango | AF702 | Resumen de activos fijos por rango |
| w_af710_fecha_adquisicion | AF710 | Activos según fecha de adquisición |
| w_af900_calculo_depreciacion | AF900 | Cálculo de depreciación de activos |
| w_af901_calculo_depreciacion_acumulada | AF901 | Cálculo de depreciación acumulada |
| w_af901_calculo_revaluacion | AF401 | Cálculo de revaluaciones |
| w_af902_asiento_depreciacion | AF402 | Asiento de depreciaciones |
| w_af903_asiento_revaluacion | AF403 | Asiento de revaluaciones |
| w_af904_asiento_indexacion | AF404 | Asiento de indexación |

---

## 2. Almacén

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_al001_almacenes | AL001 | Mantenimiento de almacenes |
| w_al002_articulo_mov_tipo | AL002 | Mantenimiento de tipo de movimientos |
| w_al003_almacen_movimientos | AL003 | Movimientos permitidos por almacén |
| w_al005_motivos_traslado | S/C | Motivos de traslado |
| w_al006_forma_embarque | S/C | Formas de embarque |
| w_al007_numeracion | S/C | Numeradores |
| w_al008_logparam | S/C | Parámetros de almacenes |
| w_al009_numeracion_origen | AL009 | Numeradores por origen |
| w_al010_templa_saldo | AL010 | Mantenimiento de saldo de templas |
| w_al012_motivo_traslado | AL012 | Motivo de traslado |
| w_al013_almacenes_tacitos | AL013 | Almacenes tácitos |
| w_al014_unidades_conversion | S/C | Unidades de conversión |
| w_al020_logparam | AL020 | Mantenimiento Logparam |
| w_al021_articulo_venta_precios | AL021 | Precios de venta de artículos |
| w_al022_ubicacion_articulos | AL022 | Ubicación de artículos |
| w_al023_almacen_transport | AL023 | Transportistas permitidos por almacén |
| w_al024_posiciones_almacen | AL024 | Posiciones por almacén |
| w_al025_modificar_almacen_ov | AL025 | Modificar datos en orden de venta |
| w_al301_solicitud_salida | AL301 | Solicitud de salida |
| w_al301_solicitud_salida_frm | S/C | Formato de solicitud de salida |
| w_al302_mov_almacen | AL302 | Movimiento de almacén |
| w_al303_ajustes | AL303 | Ajustes al movimiento |
| w_al304_consignaciones | AL304 | Consignaciones |
| w_al306_no_atender_movproy | AL306 | Movimientos proyectados a no atenderse |
| w_al308_generacion_guia | AL308 | Generación de guía |
| w_al308_tickets_balanza | AL308 | Balanza / Tickets de balanza |
| w_al309_guias_remision_frm | AL309 | Impresión masiva de guías de remisión |
| w_al310_asignar_factura | AL310 | Asignación de factura |
| w_al311_toma_inventario | AL311 | Tomas de inventario por conteo |
| w_al312_actualiza_costo_promedio | AL312 | Actualización del costo promedio del artículo |
| w_al313_consig_liq | AL313 | Liquidación de consignaciones |
| w_al314_prest_devol | AL314 | Devoluciones y préstamo |
| w_al315_orden_traslado | AL315 | Orden de traslado |
| w_al315_orden_traslado_frm | S/C | Formato orden de traslado |
| w_al316_orden_tras_aprobar | AL316 | Aprobación de orden de traslado |
| w_al317_ov_cerrar | AL317 | Cierre de OV |
| w_al318_templas | AL318 | Ingreso de lotes / Templas |
| w_al319_no_atender_movproy_gen | AL319 | Movimientos proyectados a no atenderse (general) |
| w_al320_no_atender_ord_traslado | AL320 | Órdenes de traslado a no atenderse |
| w_al321_matriz_articulo_mov | AL321 | Matriz contable en movimientos de almacén |
| w_al322_anular_oc_consig | AL322 | Anular liquidación de consignación |
| w_al323_aperturar_movproy | AL323 | Apertura de movimientos proyectados cerrados |
| w_al324_repr_mov_proy | AL324 | Reprogramación de movimientos atrasados |
| w_al325_mov_transito | AL325 | Movimientos en tránsito |
| w_al326_solicitud_pedido | AL326 | Solicitud de pedido |
| w_al327_monitor_inventario | AL327 | Monitor de inventario por conteo |
| w_al328_despacho_simplificado | AL328 | Despacho simplificado |
| w_al329_despacho_simplificado_popup | AL329 | Despacho simplificado (popup) |
| w_al330_parte_ingreso | AL330 | Parte de ingreso masivo |
| w_al331_parte_ingreso_masivo | AL331 | Parte de ingreso masivo |
| w_al332_parte_transferencia | AL332 | Parte de transferencia interna |
| w_al333_parte_transferencia_popup | AL333 | Parte de transferencia interna (popup) |
| w_al334_saldo_posicion | AL334 | Modificar posiciones en saldos por almacén |
| w_al335_listado_gre | AL335 | Envío de guías a SUNAT / PSE |
| w_al501_lista_precios | AL501 | Lista de precios |
| w_al502_movimiento_articulo | AL502 | Consulta de movimientos |
| w_al503_proyeccion_pto | AL503 | Proyección presupuestal |
| w_al503_sel_proyeccion_pto | S/C | Selección de proyección |
| w_al504_devoluciones_prestamos | AL504 | Artículos prestados |
| w_al506_consignacion | AL506 | Artículos en consignación |
| w_al507_despachos | AL507 | Despachos |
| w_al508_articulos_mov | AL508 | Consulta especializada de artículos |
| w_al509_guias_pend_ticket | AL509 | Guías faltantes de ticket de balanza |
| w_al510_pendientes_atencion | AL510 | Requerimiento de artículos pendiente |
| w_al511_ctacte_transportista | AL511 | Cuenta corriente de transportista |
| w_al511_rpt_transporte_cana_tarifa | AL511 | Cuenta por cobrar transportista de caña (tarifa) |
| w_al511_rpt_transporte_combustible | AL511 | Cuenta por cobrar transportista (combustible) |
| w_al512_saldos_descuadrados | AL512 | Saldos descuadrados |
| w_al513_precios_articulos_desc | AL513 | Saldos descuadrados (precios artículos) |
| w_al514_precios_oc_ni | AL514 | Descuadre entre precio OC y NI |
| w_al515_precios_acc_ni | AL515 | Descuadre entre Partes de Cosecha y NI |
| w_al515_vale_mov | AL515 | Consulta de vales de almacén |
| w_al701_movimiento_x_cencos | AL701 | Gastos por centros de costo |
| w_al701_movimiento_x_cencos_bk | AL701 | Movimiento por centro de costo (backup) |
| w_al702_movimiento_x_cnta_prsp | AL702 | Movimientos por cuenta presupuestal |
| w_al703_movimiento_tipo_oper | AL703 | Movimientos por tipo de operación |
| w_al704_movimiento_almacen | AL704 | Movimientos por tipo de operación |
| w_al705_kardex | AL705 | Kardex |
| w_al706_stocks_fisico | AL706 | Stocks físico valorizado por almacén |
| w_al707_mov_x_facturar | AL707 | Movimientos a facturar |
| w_al708_indices_rotacion | AL708 | Índices de rotación |
| w_al709_articulos_obsolecencia | AL709 | Artículos en obsolescencia |
| w_al710_curva_abc | AL710 | Curvas ABC |
| w_al711_listado_inventario | AL711 | Listado de inventario |
| w_al712_de_inventario_x_conteo | AL712 | Reporte de inventarios por conteo |
| w_al713_articulo | AL713 | Reporte de artículos |
| w_al714_tablas | AL714 | Tablas |
| w_al715_relacion_ov | AL715 | Reporte documentos emitidos |
| w_al716_articulos_programados | AL716 | Artículos programados |
| w_al717_ov_fact_gr | AL717 | OV facturadas con guía de remisión |
| w_al717_sel_clientes_ov_fac_gr | S/C | Selección de clientes OV factura guía |
| w_al718_templas_mov | AL718 | Detalle del movimiento de templas |
| w_al719_consumo_material_anual | AL719 | Consumo de material anual |
| w_al720_sldos_consig_detalle | AL720 | Artículos en consignación (detalle) |
| w_al721_rpt_prod_azucar_hora | AL721 | Producción de azúcar por hora |
| w_al722_despachos_pendientes_ov | AL722 | Despachos pendientes de órdenes de venta |
| w_al723_mov_atrazados | AL723 | Movimientos atrasados |
| w_al724_imp_xtipo_mov | AL724 | Importe por tipo de movimiento |
| w_al725_mov_ing_sin_valor | AL725 | Ingresos sin valorización |
| w_al726_templa_saldo_x_alm | AL726 | Saldos de templas - Rumas |
| w_al727_valorizacion_stock | AL727 | Valorización de stock |
| w_al728_ingresos_x_alm | AL728 | Ingresos por almacén |
| w_al729_mov_alm_sldo_neg | AL729 | Movimientos con saldo o valor negativo |
| w_al730_mov_alm_x_mov_proy | AL729 | Movimientos por mov proyectado |
| w_al731_mov_alm_x_tipo_doc | AL731 | Movimientos por tipo de documento |
| w_al732_desc_valor_mov_almacen | AL732 | Descuadres de valorización en movimientos |
| w_al733_stock_mensual_valorizado | AL733 | Stock mensual valorizado por almacén |
| w_al734_kardex_consig | AL734 | Kardex de consignación |
| w_al735_disponibilidad_articulos | AL735 | Disponibilidad de artículos |
| w_al736_saldos_reservados | AL736 | Saldos reservados |
| w_al737_saldos_libres | S/C | Saldos libres |
| w_al738_relacion_otr | AL738 | Relación de órdenes de traslado |
| w_al739_mov_articulo_anual | AL739 | Movimientos anuales |
| w_al740_res_x_tipo_x_alm | AL740 | Resumen por tipo de movimiento |
| w_al741_kardex_trans | AL741 | Kardex en tránsito |
| w_al742_pend_ingreso | AL742 | Salidas pendientes de ingreso |
| w_al743_stocks_tranporte | AL743 | Saldos almacén tránsito |
| w_al744_antiguedad_saldos | AL744 | Antigüedad de saldos por almacén |
| w_al745_sldo_valor_grp_cencos | AL745 | Saldo valorizado por grupo de centros de costo |
| w_al746_saldos_libres | AL746 | Saldos libres por almacenes |
| w_al747_diferenc_otr | AL747 | Traslados valorizados |
| w_al748_formatos_inv | AL748 | Formatos de inventario |
| w_al749_res_tipo_movimiento | AL749 | Resumen por tipo de movimiento |
| w_al750_resumen_valorizado | AL750 | Resumen valorizado |
| w_al751_req_ot_pendientes_retiro | AL751 | Requerimientos de OT pendientes de salida |
| w_al752_precios_oc_ni_fap | AL752 | Diferencia entre precio de OC y FAP |
| w_al753_listado_codigos_barra | AL753 | Listado de códigos de barra |
| w_al754_resumen_diario | AL754 | Resumen diario por comprobante |
| w_al755_stock_posicion | AL755 | Saldo resumen de artículos por posición |
| w_al756_fotosselect | AL756 | Stocks con listado de fotos |
| w_al756_stock_pallet_posicion | AL756 | Saldo por posición, artículo y pallet |
| w_al757_inventario_pallets | AL757 | Reporte de inventarios por pallets y posición |
| w_al758_disponibilidad_articulos_subcat | AL758 | Stock subcategoría - Marca |
| w_al759_copias_codigos_barra_cu | AL753 | Listado de códigos de barra (copias) |
| w_al760_kardex_tabular | AL760 | Kardex formato tabular |
| w_al761_res_movimiento_ov | AL761 | Despacho resumido por OV |
| w_al762_consulta_detalle | AL762 | Modificación de datos por almacén/artículo |
| w_al763_despacho_simpl | AL763 | Despacho resumido por guía - vehículo |
| w_al764_ajuste_mensual | AL764 | Ajuste mensual almacén |
| w_al765_cierre_mensual | AL765 | Cierre mensual almacén |
| w_al900_act_prec_prom_art_all | AL900 | Recálculo del precio promedio |
| w_al901_act_saldo_articulo | AL901 | Regenera saldo de artículos |
| w_al902_act_saldo_xllegar_solic | AL902 | Regenera saldo por llegar, solicitado y reservado |
| w_al903_act_ult_prec_comp | AL903 | Regenera último precio de compra |
| w_al904_act_saldo_consignacion | AL904 | Regenera saldo consignación de artículos |
| w_al905_act_prec_oc_ni | AL900 | Recálculo del precio promedio (OC/NI) |
| w_al906_mod_fec_mov_alm | AL906 | Modificación fecha mov almacén |
| w_al907_prec_mov_alm_in | AL907 | Actualizar precio de movimiento de almacén |
| w_al908_act_fec_ult_sal | AL908 | Actualiza la fecha de última salida |
| w_al909_cambiar_tipo_mov | AL909 | Cambiar tipo mov en vale mov |
| w_al910_generacion_guia_remision | AL910 | Generación de guías de remisión |
| w_al912_act_saldo_lotes | AL912 | Actualiza el saldo por lotes |
| w_al913_libera_reservaciones | AL913 | Liberar reservaciones |
| w_al914_inventario_conteo | S/C | Inventario por conteo |
| w_cm311_orden_compra_frm | CM311 | Formato de orden de compra |

---

## 3. Compras

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cm001_proveedor_tipo | CM101 | Tipo de proveedores - maestro de tipos |
| w_cm002_proveedor_ficha | CM002 | Ficha de proveedor |
| w_cm002_proveedor_ficha_visita | S/C | Formato de visitas de cliente/proveedor |
| w_cm002_proveedores | CM002 | Proveedores - maestro principal |
| w_cm003_proveedor_articulo | CM003 | Proveedores calificados por artículo |
| w_cm004_compradores | CM004 | Agentes de compra |
| w_cm005_forma_pago | CM005 | Formas de pago |
| w_cm006_criterios_evaluacion | S/C | Criterios de evaluación |
| w_cm007_articulo_clase | CM007 | Clases de artículos |
| w_cm008_unidades_conversion | CM008 | Unidades y conversión |
| w_cm009_categoria_subcategoria | CM009 | Categorías y subcategorías |
| w_cm010_articulos | CM010 | Maestro de artículos |
| w_cm011_grupos_articulos | CM011 | Grupos y super grupos |
| w_cm012_articulo_equivalencia | CM012 | Equivalencias de artículos |
| w_cm013_logparam | CM013 | Parámetros del sistema |
| w_cm013_logparam_v2 | S/C | Parámetros del sistema (versión 2 con tabs) |
| w_cm014_numeracion | CM014 | Numeradores |
| w_cm015_restriccion_solicitar | CM015 | Artículos restringidos para solicitar |
| w_cm016_numeracion_origen | S/C | Numeradores por origen |
| w_cm017_grupo_proveedor | CM017 | Grupo de proveedores |
| w_cm018_num_proveedor | S/C | Numeradores de proveedor |
| w_cm019_ult_compra | CM019 | Modificar última compra |
| w_cm020_servicios | CM020 | Maestro de servicios |
| w_cm021_aprobador_logistica | CM021 | Aprobadores de documentos de compras |
| w_cm022_fondos_compra | CM022 | Listado de fondos de compra |
| w_cm023_fondos_compra_otadm | CM022 | Listado de fondos de compra OT ADM |
| w_cm024_estados_atencion_req | CM024 | Estados de atención de requerimientos |
| w_cm025_articulos_cubso | CM025 | Artículos vs CUBSO del Estado |
| w_cm026_marcas | CM026 | Maestro de marcas de artículo |
| w_cm027_modelos | CM027 | Maestro de modelos de artículos |
| w_cm028_tipo_carroceria | CM028 | Maestro de tipos de carrocería |
| w_cm029_clase_categoria_vehiculo | CM029 | Clases y categorías de vehículos |
| w_cm030_linea_sublinea | CM030 | Líneas y sublíneas de calzados |
| w_cm031_colores | CM031 | Maestro de colores |
| w_cm032_tallas | CM032 | Maestro de tallas de artículos |
| w_cm033_unidades_sunat | CM033 | Maestro de unidades SUNAT (Tabla 06) |
| w_cm301_solicitud_compra | CM301 | Solicitud de compras |
| w_cm301_solicitud_compra_frm | CM301 | Formato/impresión de solicitud de compra |
| w_cm302_solicitud_compra_aprobacion | CM302 | Aprobación de solicitud de compra |
| w_cm303_solicitud_servicios | CM303 | Solicitud de servicios |
| w_cm303_solicitud_servicio_frm | CM303 | Formato de orden de compra (solicitud servicio) |
| w_cm304_solicitud_servicio_aprobacion | CM304 | Aprobación de solicitud de servicio |
| w_cm305_programa_compras | CM305 | Programa de compras |
| w_cm305_programa_compras_frm | CM311 | Formato de orden de compra (programa) |
| w_cm306_cotizacion_bienes_gen | CM306 | Cotización de bienes |
| w_cm306_cotizacion_frm | CM306 | Formato de cotización |
| w_cm307_cotizacion_bienes_act | CM307 | Actualización de cotizaciones de bienes |
| w_cm308_cotizacion_bienes_eva | CM308 | Evaluación de cotizaciones de bienes |
| w_cm309_cotizacion_servic_gen | CM309 | Cotización de servicios |
| w_cm310_cotizacion_servic_act | CM310 | Actualización de cotizaciones de servicios |
| w_cm311_orden_compra | CM311 | Orden de compras |
| w_cm311_orden_compra_frm | CM311 | Formato de orden de compra |
| w_cm312_orden_compra_automatica | CM312 | Orden de compra automática |
| w_cm313_aprob_oc_vobo1 | CM313 | Aprobación de OC y OS (Visto Bueno) |
| w_cm314_orden_servicios | CM314 | Orden de servicios |
| w_cm314_orden_servicio_frm | CM314 | Formato de orden de servicio |
| w_cm319_no_atender_movproy | CM319 | Movimientos proyectados a no atenderse |
| w_cm320_no_atender | CM320 | Ítems que no se atenderán |
| w_cm322_flag_modificacion | CM322 | Flag de modificación en movimientos proyectados |
| w_cm323_almacen_mov_proy | CM323 | Modificar almacén en AMPs |
| w_cm324_oc_importacion | CM324 | Datos en OC importación |
| w_cm325_comite_compras | CM325 | Comité de compras |
| w_cm326_modify_alm_oc | CM326 | Modificar almacén en orden de compras |
| w_cm330_os_conformidad | CM330 | Orden de servicio - conformidad |
| w_cm331_ampliacion | CM331 | Variaciones/ampliaciones |
| w_cm332_asignacion_os_oc | CM332 | Asignación de OS a OC |
| w_cm333_gen_ajuste_valor | CM933 | Generación de movimiento de ajuste |
| w_cm335_oc_pend_mod_fecha | S/C | OC pendientes de modificar fecha / reprogramación |
| w_cm336_art_serv_x_comprador | CM336 | Artículos/servicios por comprador |
| w_cm337_cotizacion_servic_eva | CM310 | Evaluación de cotizaciones de servicios |
| w_cm338_autorizacion_iqpf | CM338 | Autorización IQPF |
| w_cm339_solicitud_conformidad | CM339 | Conformidad de OS |
| w_cm339_solicitud_conformidad_frm | CM314 | Formato de orden de compra (conformidad) |
| w_cm340_aprueba_solicitud_confor_os | CM340 | Aprobación de actas de conformidad de OS |
| w_cm501_cuadro_comparativo | CM501 | Cuadro comparativo de cotizaciones |
| w_cm502_articulo_proveedor | CM502 | Resumen de compras artículo/proveedor |
| w_cm503_proveedor_articulo | CM503 | Resumen de compras proveedor/artículo |
| w_cm504_precio_promedio | CM504 | Precios de compra promediados por mes |
| w_cm505_cotizacion_vigente | CM505 | Artículos vigentes según cotización |
| w_cm506_articulos | CM506 | Consulta especializada de artículos |
| w_cm507_proveedores | CM507 | Consulta especializada por proveedor |
| w_cm507_proveedor_especif | CM507 | Reporte especializado por proveedor |
| w_cm508_proveedores_calificados | CM508 | Proveedores calificados |
| w_cm508_sc_oc_ni | CM508 | Atención de solicitud de compra |
| w_cm509_compras_sug_x_alm_x_art | CM509 | Consulta de compras sugeridas |
| w_cm510_cartera_prov | CM510 | Catálogo de compras |
| w_cm701_plan_anual_compras | CM701 | Plan anual de compras |
| w_cm702_plan_anual_compras_mes | CM702 | Plan anual de compras por mes |
| w_cm703_compras_sugeridas | CM703 | Compras sugeridas |
| w_cm704_compras_categoria | CM704 | Compras por categorías/subcategorías/artículos |
| w_cm705_atencion_oc | CM705 | Atención por orden de compra |
| w_cm706_servicios | CM706 | Servicios - maestro |
| w_cm707_tablas | CM707 | Visor general de reportes |
| w_cm708_proveedores_calificados | CM508 | Proveedores calificados (reporte) |
| w_cm709_os_referencias | CM709 | Órdenes de servicio y referencias |
| w_cm709_os_referencias_cnta_pagar | S/C | OS referencias cuenta por pagar |
| w_cm709_os_referencias_ord_serv | S/C | OS referencias orden de servicio |
| w_cm710_compras_sug_x_alm | CM703 | Compras sugeridas por almacén |
| w_cm711_ot_aprobaciones | CM711 | OT aprobaciones |
| w_cm712_oc_tipo_ref | CM712 | Orden de compra - referencia |
| w_cm713_atencion_x_ot | CM713 | Atención de materiales por OT |
| w_cm714_art_rep_stock | CM714 | Artículo de reposición de stock |
| w_cm715_precios_pactados | CM715 | Precios pactados |
| w_cm716_prec_pact_venc | AL716 | Vencimiento de precios pactados |
| w_cm717_cmp_sug_rep_stk | CM717 | Compras sugeridas - artículos rep. stock |
| w_cm718_cmpsug_repstk_alm | CM718 | Compras sugeridas rep. stock por almacén |
| w_cm719_cmp_criticas_art | CM719 | Compras sugeridas artículos críticos |
| w_cm720_asignac_alm_x_cc | CM720 | Asignación de saldos de almacén por centro de costo |
| w_cm721_os_pendientes_facturar | CM721 | Órdenes de servicio pendientes de facturar |
| w_cm722_prog_compras | CM722 | Programa de compras |
| w_cm723_cmpsug_criticas_alm | CM723 | Compras artículos críticos por almacén |
| w_cm724_doc_compra_sin_vobo | CM724 | Documentos de compra sin VoBo |
| w_cm725_gestion_cmp_usr | CM725 | Gestión de compras por usuario |
| w_cm726_compras_materiales | CM726 | Compra de materiales |
| w_cm727_codigos_barra | CM727 | Listado de códigos de barra |
| w_cm728_compras_anual | CM728 | Compras anual por proveedor y artículo |
| w_cm729_aprobadores_doc_compra | CM729 | Reporte de aprobadores de documentos de compra |
| w_cm730_aprobadores_ot | CM730 | Reporte de aprobadores de OT |
| w_cm731_resumen_anual_compras | CM731 | Resumen compras anual |
| w_cm740_oc_seguimiento | CM740 | OC seguimiento |
| w_cm750_requerimientos_art_pend | CM750 | Requerimientos de artículos pendientes |
| w_cm751_usr_adm_ot | CM751 | Usuarios por OT_ADM |
| w_cm753_atencion_requerimientos | CM753 | Atención de requerimientos de materiales |
| w_cm754_pendiente_compra | CM754 | Requerimientos pendientes de compra |
| w_cm755_requerimientos_serv_pend | CM755 | Requerimientos de servicios pendientes |
| w_cm757_amp_ot | CM757 | Requerimientos totales por OT |
| w_cm760_oc_pendiente | CM760 | OC pendientes de atención |
| w_cm761_oc_libres | CM761 | OC libres |
| w_cm763_req_mat_exceso | CM763 | Requerimiento de artículos en exceso |
| w_cm765_saldos_reservados | CM765 | Saldos reservados |
| w_cm766_gestion_compra | CM766 | Gestión de compras |
| w_cm767_res_compras_usr | CM767 | Resumen de compras por usuario |
| w_cm768_servicios_x_cencos | CM768 | Servicios por centro de costos |
| w_cm769_doc_compras | CM769 | Documentos de compras |
| w_cm770_articulo_x_ot | CM770 | Artículos por OT |
| w_cm771_stock_valor_us | S/C | Stock valor US |
| w_cm772_art_serv_x_comprador | S/C | Artículos/servicios por comprador |
| w_cm773_os_x_ot_rpt | COM733 | Reporte de órdenes de servicio por OT |
| w_cm773_rpt_dscto_materiales | CM773 | Reporte de descuentos materiales |
| w_cm774_rpt_dscto_materiales | CM774 | Reporte de descuentos materiales |
| w_cm775_rpt_dscto_orden_servicio | CM775 | Reporte descuentos de órdenes de servicio |
| w_cm779_rpt_ingreso_almacen | CM779 | Ingresos almacén |
| w_cm780_articulo | CM780 | ABC de artículos comprados |
| w_cm780_compras_total | CM780 | ABC de compras por origen |
| w_cm780_descuento | CM780 | ABC de descuentos por artículos |
| w_cm780_fpago | CM780 | ABC de formas de pago de compras |
| w_cm780_proveedor | CM780 | ABC de proveedores de órdenes de compra |
| w_cm780_resumen_compras | CM780 | ABC resumen de compras |
| w_cm781_rep_stock_default | CM717 | Compras sugeridas artículos rep. stock (default) |
| w_cm782_listado_servicios | CM717 | Listado de servicios |
| w_cm783_articulos_pendientes | CM783 | Atención de requerimientos por OT |
| w_cm784_abc_proveedores | CM784 | Resumen compras/servicios por proveedor |
| w_cm785_pend_cmp_xcomprador | CM785 | Req. pendientes de compra por comprador |
| w_cm786_plan_anual_de_compras | CM786 | Plan anual de compras |
| w_cm787_atencion_prog_compras | CM767 | Resumen de compras por usuario (atención) |
| w_cm788_relacion_de_art_iqpf | CM788 | Relación de artículos IQPF |
| w_cm789_listado_articulos | CM789 | Maestro de artículos |
| w_cm790_compra_sugerida | CM790 | Requerimientos pendientes de compra |
| w_cm791_costo_servicios | CM791 | Reporte de costos por OC |
| w_cm792_listado_proveedores | CM792 | Maestro de proveedores |
| w_cm793_basc_listado_proveedores | CM793 | Listado BASC de proveedores/clientes |
| w_cm794_basc_programa_visitas_clientes | CM794 | Programa de visitas a clientes |
| w_cm795_lista_prog_compras | CM795 | Listado de programas de compras |
| w_cm900_oc_camb_moneda | S/C | Cambio de moneda en OC |
| w_cm901_fec_venc_reserv | CM901 | Cierre de mov. proyectados reservados vencidos |
| w_cm902_monto_total_oc | CM902 | Regenera monto total de la OC |
| w_cm903_monto_total_os | CM903 | Regenera monto total de la OS |
| w_cm904_update_flac_oc_ov | S/C | Actualización de flags OC/OV |
| w_cm905_subcateg_prov | CM905 | Actualiza PROVEEDOR_ARTICULO |
| w_cm910_amp_oc | CM910 | Relación AMP con OC |
| w_cm911_reserv_automatica | CM911 | Reservación automática |
| w_cm912_importar_articulos | CM912 | Importar artículos |
| w_cm913_importar_fotos | CM913 | Importar fotos de artículos |
| w_cn009_tipo_cambio | CN009 | Tipo de cambio |
| w_cn789_errores_gen_apertura | CN789 | Errores a corregir antes de generar apertura |
| w_fi743_compras_proveedores | FI743 | Compra a proveedores |
| w_rpt_servicio_proveedor_det | S/C | Detalle de servicios por proveedor |

---

## 4. Comercialización / Ventas

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cns_flujo_caja_eje_det_tbl | S/C | Consulta Detalle de Flujo de Caja |
| w_fi301_notas_ventas_x_cobrar_frm | FI343 | Liquidación Semanal |
| w_fl003_capit_puerto | FL003 | Capitanías de Puerto |
| w_fl013_puertos | FL013 | Mantenimiento de puertos |
| w_rpt_factura_exportacion | S/C | Factura de Exportación |
| w_ve001_incoterm | VE001 | Términos Internacionales de Comercialización |
| w_ve002_factor_embarque | VE002 | Factor de Embarque |
| w_ve003_caracteristica_embarque | VE003 | Características de Embarque |
| w_ve004_articulo_caract_embarque | VE004 | Artículo - Características de Embarque |
| w_ve005_forma_empaque | VE005 | Forma de Empaque |
| w_ve006_precio_referencial_mercado | VE006 | Precio Referencia de Mercado |
| w_ve007_articulo_super_grupo | VE007 | Super Grupo y Grupo de Artículos |
| w_ve008_flete_instruccion | VE008 | Instrucciones de Flete |
| w_ve009_forma_embarque | VE009 | Forma de Embarque |
| w_ve010_articulo_venta | VE010 | Artículos de Venta |
| w_ve011_canal_distribucion | VE011 | Canal de Distribución |
| w_ve012_zona_comercial | VE012 | Zonas Comerciales |
| w_ve012_zona_comercial_direcciones | VE012 | Direcciones Disponibles |
| w_ve012_zona_comercial_popup | VE012 | Inserción |
| w_ve012_zona_comercial_total | VE012 | Zona Comercial |
| w_ve013_plantilla_ov | VE013 | Plantilla de Orden de Venta |
| w_ve014_vendedor | VE014 | Maestro de vendedores |
| w_ve015_cliente_distrito | VE015 | Distritos por Clientes |
| w_ve016_zona_vendedores | VE016 | Vendedores por Zonas |
| w_ve017_articulo_venta_precios | VE017 | Precios de Venta de Artículos |
| w_ve018_puntos_venta | VE018 | Puntos de Venta |
| w_ve019_vendedor_cuota | VE019 | Cuota de los Vendedores |
| w_ve020_comisiones | VE020 | Comisiones |
| w_ve020_comisiones_det | VE020 | Copiar Periodo Existente |
| w_ve021_ccosto_gasto_x_art | VE021 | Centros de Costo de Gasto por Artículo |
| w_ve022_prod_term_plant_art | VE022 | Amarre Plantilla / Artículos Prod Terminado |
| w_ve023_fs_param | VE023 | Parámetros de Facturación Simplificada |
| w_ve024_consignatarios | VE024 | Consignatarios |
| w_ve025_servicios_venta | VE025 | Servicios de Venta |
| w_ve026_lineas_credito | VE026 | Líneas de Crédito |
| w_ve027_zonas_venta | VE027 | Zonas de Venta |
| w_ve028_zonas_despacho | VE028 | Zonas de Despacho |
| w_ve300_orden_venta | VE300 | Orden de Venta |
| w_ve300_orden_venta_frm | VE300 | Formato de orden de Venta |
| w_ve301_generar_ot | VE301 | Generar Orden Trabajo |
| w_ve301_genera_estructura_costo | VE301 | Asignación de Estructura de Costos |
| w_ve302_embarque | VE302 | Embarque |
| w_ve303_lote_embarque | VE303 | Lote de Embarque |
| w_ve304_lote_emb_inspec | VE304 | Inspección de Embarque |
| w_ve305_instruccion_emb | VE305 | Instrucción de Embarque |
| w_ve307_factura_export | VE307 | Factura de Exportación |
| w_ve307_factura_export_frm | VE307 | Formato de orden de Venta |
| w_ve308_notas_credito_debito | VE308 | Notas de Crédito / Débito x Cobrar |
| w_ve310_cntas_cobrar | VE310 | Registro de Cuentas Cobrar (Ventas) |
| w_ve311_facturacion_simple | VE311 | Punto de Venta Rápido - POS |
| w_ve312_facturacion_simplificada_anul | VE312 | Anulación Facturación Simplificada |
| w_ve313_cambia_fec | VE313 | Cambio de fecha de presentación |
| w_ve314_planilla_cobranza | VE314 | Planilla de Cobranza |
| w_ve315_exportaciones | VE315 | Exportaciones |
| w_ve316_valor_porcentaje_venta | VE316 | Valor/Porcentaje Venta |
| w_ve317_aprobacion_ov | VE317 | Aprobación de Órdenes de Venta |
| w_ve318_forma_pago | VE318 | Elija la forma de pago adecuada |
| w_ve318_pos_with_pedidos | VE318 | POS - Emisión de Comprobantes desde proformas |
| w_ve319_imprimir_tickets | VE319 | POS - Emisión de comprobantes de Ventas |
| w_ve320_resumen_diario | VE320 | Resumen Diario de Comprobantes Electrónicos |
| w_ve321_resumen_baja | VE321 | Resumen Diario de Baja de Comprobantes |
| w_ve322_listado_ce_fs | VE322 | Envío de Comprobantes Electrónicos a SUNAT |
| w_ve323_registro_vales_descuento | VE323 | Registro de Vales de Descuento |
| w_ve324_impresion_masiva | VE324 | Impresión Masiva de vouchers |
| w_ve325_asigna_lote_comp | VE325 | Asignar Lotes y Letras a un comprobante |
| w_ve326_proformas | VE326 | POS - Generación de Proformas |
| w_ve327_aprobacion_linea | VE327 | Aprobación de líneas de crédito |
| w_ve328_operac_simplif | VE328 | Procesos Simplificados de la OV |
| w_ve501_cns_cntas_x_cobrar_x_venc | FI507 | Cuentas x Cobrar Pendientes |
| w_ve502_cns_orden_venta | VE502 | Consulta de orden de venta |
| w_ve504_cns_factura_cobrar | VE504 | Consulta de cuenta por cobrar |
| w_ve505_consulta_envio_sunat | VE505 | Consulta envío masivo a SUNAT |
| w_ve700_mov_alm_x_mov_proy | VE700 | Movimientos de Almacén x Mov Proy |
| w_ve701_cuadro_embarque | VE701 | Cuadro de Embarque |
| w_ve702_ventas_x_art | VE702 | Ventas x Artículo |
| w_ve703_vtas_grp_art | VE703 | Ventas x Grupo de Artículos |
| w_ve704_vtas_mensual | VE704 | Ventas Mensual x Grupo de Artículos |
| w_ve705_valor_agregado | VE705 | Valor Agregado x Negociación |
| w_ve706_destino_ventas | VE706 | Destino de Ventas |
| w_ve707_abc_clientes | VE707 | ABC Clientes |
| w_ve708_estructura_costo_ov | VE708 | Reporte de Estructura de Costos |
| w_ve709_ventas_x_vendedor | VE709 | Detalle de Ventas por Vendedor |
| w_ve709_ventas_x_vendedor_det | VE710 | Detalle de Ventas Generales |
| w_ve710_ventas_general | VE710 | Ventas Generales |
| w_ve710_ventas_general_det | VE710 | Detalle de Ventas Generales |
| w_ve711_ventas_sub_productos | VE710 | Ventas Generales de Sub - Productos |
| w_ve712_ventas_materiales | VE712 | Ventas Generales de Materiales |
| w_ve713_mov_x_facturar | VE713 | Movimientos a facturar |
| w_ve714_relacion_ov | VE714 | Relación de Documentos de Órdenes de Venta |
| w_ve715_despachos_pendientes_ov | VE715 | Despachos pendientes de órdenes de venta |
| w_ve716_ov_fact_gr | VE716 | Orden Venta - Factura - Guía Remisión |
| w_ve717_azucar_pend_ov | VE717 | Órdenes de Venta Pendientes por Código de Clase |
| w_ve718_tiempo_permanencia | VE718 | Tiempos de Permanencia |
| w_ve719_templas_x_clientes | VE719 | Templas Disponibles por Clientes |
| w_ve720_mov_alm_x_mov_proy | VE720 | Movimientos de Almacén x Mov Proy |
| w_ve721_rpt_reg_ventas | VE721 | Reporte de Registro de Ventas |
| w_ve722_reg_ventas_x_fec | VE722 | Reporte de Registro de Ventas |
| w_ve723_rpt_documentos_diarios | VE723 | Reporte de Documentos Diarios de Ventas |
| w_ve724_rpt_ranking | VE724 | Reporte de Ranking |
| w_ve725_rpt_cobrar_x_art | VE725 | Reporte de Ventas de Productos |
| w_ve726_rpt_cobrar_x_confin | VE726 | Reporte de Ventas x Concepto Financiero |
| w_ve727_rpt_ventas_x_productos | VE727 | Reporte de Ventas Generadas |
| w_ve728_rpt_ventas_x_prod_x_fec | VE728 | Reporte de Variación x Fechas |
| w_ve729_rpt_cobrar_x_art_cliente | VE729 | Reporte de Ventas de Productos |
| w_ve730_inf_sunat_ventas | VE730 | Registros de Ventas y Cobros |
| w_ve731_arti_pend_facturar | VE731 | Artículo Pendiente a Facturar |
| w_ve732_rpt_doc_pend_x_cobrar | VE732 | Reporte de Ventas de Productos |
| w_ve733_rpt_cobrar_directo | S/C | Impresión de Cobrar Directo |
| w_ve734_rpt_pln_cobranza | FI726 | Planilla de Cobranza |
| w_ve735_mov_atrazados | VE735 | Movimientos Atrasados |
| w_ve736_seguimiento_ov | VE736 | Seguimiento General a OV |
| w_ve737_ventas_anuales | VE737 | Ventas Anuales por Artículos |
| w_ve738_gastos_venta | VE738 | Gastos de Venta |
| w_ve739_gastos_venta_general | VE739 | Gastos de Venta General |
| w_ve740_doc_pend_ov | VE740 | Guías Pendientes de Facturar |
| w_ve741_precio_promedio_x_art | VE741 | Precio Promedio Artículo Facturado |
| w_ve742_ppromedio_x_art_x_dia | VE742 | Promedio de Ventas por Día |
| w_ve743_stocks_fisico | AL706 | Stocks Físico |
| w_ve744_margen_contribucion | VE744 | Margen de Contribución por Artículo |
| w_ve745_utilidad_categ_especies | VE745 | Margen de Contribución por Categoría / especies |
| w_ve746_detalle_pendientes_cobro | VE746 | Detalle de Pendientes x Cobrar |
| w_ve747_reportes_diversos | VE747 | Reportes de Facturación Simplificada |
| w_ve748_resumen_pendiente | VE748 | Resumen de pendientes por Cliente y por Mes |
| w_ve749_reporte_gerencial_vehiculos | VE749 | Reporte Gerencial de vehículos |
| w_ve750_detalle_consignatario | VE750 | Detalle por Consignatario (Facturación Simplificada) |
| w_ve751_cronograma_cobranza | VE751 | Cronograma de cobranza (Facturación simplificada) |
| w_ve752_cronograma_terrenos | VE752 | Cronograma de pagos de terrenos |
| w_ve753_reporte_vencimiento | VE753 | Letras vencidas a una fecha determinada |
| w_ve754_letras_bloqueadas | VE754 | Letras Bloqueadas por Cliente |
| w_ve755_letras_vencidas | VE755 | Cuotas Vencidas - Cartera Pesada |
| w_ve756_ventas_periodo | VE756 | Reporte de Ventas por periodo |
| w_ve757_resumen_anual | VE721 | Reporte de Registro de Ventas |
| w_ve758_resumen_recibos | VE758 | Resumen de recibos de pago |
| w_ve759_listado_pagos | VE759 | Listado de Pagos |
| w_ve760_seguimiento_comprobantes | VE760 | Seguimiento de comprobantes de venta |
| w_ve761_proyeccion_ingresos_anual | VE761 | Proyección de Ingresos Anual |
| w_ve762_proyeccion_ingresos_mensual | VE762 | Proyección de Ingresos Mensual |
| w_ve763_stock_pptt_almacen | VE763 | Stock de Producto Terminado por Almacén |
| w_ve764_ventas_mensuales | VE764 | Registro de ventas mensual detallado |
| w_ve765_facturas_x_ov | VE700 | Movimientos de Almacén x Mov Proy |
| w_ve766_ventas_clientes_anuales | VE766 | Ventas por Clientes Mensualizado |
| w_ve767_ventas_vs_despachos | VE767 | Reporte de ventas vs despachos |
| w_ve768_detalle_ov | VE768 | Orden de venta detallado |
| w_ve769_saldo_cliente | VE769 | Cronograma Cobros por Fecha Vencimiento |
| w_ve770_cntas_cobrar_vencidos | VE770 | Reporte de Saldos por Cobrar Vencidos |
| w_ve771_consolidado_vendedor | VE771 | Ventas consolidado por Vendedor |
| w_ve772_ov_vendedor | VE772 | Consolidado OV por Vendedor |
| w_ve773_pendientes_vendedor | VE773 | Pendientes x Cobrar por vendedor |
| w_ve774_cobranza_vendedor | VE774 | Cobranza por Vendedor y Documento |
| w_ve775_devolucion_vendedor | VE775 | Consolidado Devolución por Vendedor |
| w_ve776_pendientes_vs_clientes | VE776 | Pendientes de OV vs Clientes |
| w_ve777_stock_pallets_cliente | VE777 | Stock por Pallets y Cliente |
| w_ve901_generacion_fact_cobrar | VE901 | Generación de Facturas de Materiales |
| w_ve902_generacion_fact_cobrar_guias | VE902 | Reporte de Guías a Facturar |
| w_ve903_facturacion_masiva_materia_prima | S/C | Facturación masiva de materia prima |
| w_ve904_cambio_cliente | VE901 | Generación de Facturas de Materiales |
| w_ve905_procesar_fsimple | VE905 | Procesamiento de Factura Simplificada |

---

## 5. Contabilidad

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cn001_tipo_nota | CN001 | Tipos de notas contables |
| w_cn002_plan_cuentas | CN002 | Plan de cuentas contable |
| w_cn003_moneda | CN003 | Mantenimiento de monedas |
| w_cn004_tasa_cambio_mensual | CN004 | Tasa de cambio mensual |
| w_cn005_tipo_nota_contable | CN005 | Tipo de operación contable |
| w_cn006_tipo_documento | CN006 | Tipo de documento |
| w_cn007_indice_ajuste | CN007 | Índice de ajuste |
| w_cn008_nivel_centro_costo | CN008 | Centro de costos |
| w_cn009_tipo_cambio | CN009 | Tipo de cambio |
| w_cn010_bancos | CN010 | Bancos |
| w_cn011_libro_contable | CN011 | Libro contable |
| w_cn012_seguimiento | CN012 | Seguimientos |
| w_cn013_clase_contable | CN013 | Clase contable |
| w_cn014_matriz_contable | CN014 | Plantilla de operaciones contables |
| w_cn015_horas_seguridad | CN015 | Promedio de horas - Personal de seguridad |
| w_cn016_matriz_cntbl_oper | CN016 | Matriz contable de operaciones |
| w_cn017_reportes | CN017 | Reportes de contabilidad |
| w_cn018_def_centro_costo | CN018 | Maestro de centro de costos |
| w_cn019_matriz_taller | CN019 | Matriz contable de talleres |
| w_cn020_taller_matriz_costo | CN020 | Costo horario de talleres |
| w_cn021_sub_categ_cnta_ctbl | CN021 | Cuentas contables por sub categoría de artículos |
| w_cn022_transf_proceso_tbl | CN022 | Procesos para generar asientos de transferencias |
| w_cn023_transf_matriz_tbl | CN023 | Matriz de transferencias de asientos |
| w_cn024_confin_tipo_trabaj | CN024 | CONFIN por tipo de trabajador |
| w_cn025_cntblparam | CN025 | Parámetros de contabilidad |
| w_cn026_grupo_contable | CN026 | Grupo contable - Costos |
| w_cn027_tipo_mov_matriz | CN027 | Matrices contables por movimiento de almacén |
| w_cn028_maerel | CN028 | Maestro de relaciones |
| w_cn029_job | CN029 | Job |
| w_cn030_abc_cntbl_libro_mes | CN030 | Correlativo de asientos contables |
| w_cn031_doc_pendientes_cta_cte | CN031 | Documentos pendientes de cuenta corriente |
| w_cn032_abc_maq_categ | CN032 | Categoría de máquinas |
| w_cn033_costeo_categoria_maquina | CN033 | Costeo de maquinarias |
| w_cn034_cierre_contable | CN034 | Cierre contable |
| w_cn035_grupo_centro_costo | CN035 | Grupos de centros de costo |
| w_cn036_abc_gxcparam | CN036 | Parámetros de gastos por campos |
| w_cn037_abc_gxcfactores | CN037 | Factores de indexación |
| w_cn038_abc_gxcsemilla | CN038 | Movimiento de distribución de semilla |
| w_cn039_abc_gxcnumerador | CN039 | Numerador de gastos por campos |
| w_cn040_abc_gxcfusion | CN040 | Movimientos de campos a fusionar |
| w_cn041_cntbl_rpt_articulo_sub_categoria | CN041 | Reporte de artículos con sub-categorías |
| w_cn042_matriz_cierre_ejercicio | CN042 | Matriz para cierre del ejercicio |
| w_cn043_cosecha_semilla | CN043 | Hectáreas y toneladas de cosecha y semilla |
| w_cn044_tipo_mov_matriz_subcateg | CN044 | Matrices contables por sub categoría de artículos |
| w_cn045_grupos_secuencia | CN045 | Grupos de secuencia para gastos fijos |
| w_cn046_ventas_a_titulo_gratuito | CN046 | Ventas a título gratuito |
| w_cn047_origen | CN047 | Mantenimiento de orígenes |
| w_cn048_cnta_cntbl_grupo | CN048 | Grupo cuentas contables |
| w_cn049_plant_grp_cc_prod | CN049 | Plantilla de grupo de centros de costos de producción |
| w_cn050_anexo_concepto | CN050 | Anexos contables por cuenta |
| w_cn051_balance_historico | CN051 | Balance histórico (mantenimiento) |
| w_cn053_plant_grp_ctro_benef | CN053 | Plantilla de centros de beneficio |
| w_cn054_uit | CN054 | Unidad Impositiva Tributaria |
| w_cn055_matriz_transf_cencos | CN055 | Matriz transferencia por centros de costo |
| w_cn056_cntbl_cnta_sunat | CN056 | Plan de cuentas vs cuentas SUNAT |
| w_cn057_matriz_venta | CN057 | Configuración matrices de venta |
| w_cn058_matriz_vta_bien_serv | CN058 | Matrices de venta de bien y servicio |
| w_cn059_cencos_articulos | CN059 | Asignación de artículos por centro de costos |
| w_cn060_grupo_resumen | CN060 | Grupo resumen cuenta contable |
| w_cn061_cencos_servicios_os | CN061 | Centros de costo - Usuarios - Servicios |
| w_cn201_cntbl_asiento_mensual | CN201 | Modificación masiva de asientos contables |
| w_cn202_asiento_contable | CN202 | Mantenimiento de asientos contables |
| w_cn203_abc_cp_procesos | CN203 | Costos de producción de azúcar - Códigos de procesos |
| w_cn204_credito_fiscal | CN204 | Crédito fiscal |
| w_cn205_abc_cp_formatos | CN205 | Costos de producción de azúcar - Formatos de reportes |
| w_cn206_abc_cp_plantilla | CN206 | Costos de producción de azúcar - Formatos de plantillas |
| w_cn207_abc_cp_mov_mensual | CN207 | Costos de producción de azúcar - Movimiento mensual |
| w_cn210_abc_cv_formatos | CN210 | Páginas de costos de ventas de azúcar |
| w_cn211_abc_cv_plantilla | CN211 | Plantillas de costos de ventas |
| w_cn212_abc_cv_digitado | CN212 | Movimiento digitado de costos de ventas |
| w_cn215_cuentas_balance_general | CN215 | Cuentas del balance general |
| w_cn216_ganancias_perdidas_funcion | CN216 | Ganancias y pérdidas por función |
| w_cn217_ganancias_perdidas_naturaleza | CN217 | Ganancias y pérdidas por naturaleza |
| w_cn230_calendario | CN230 | ABC Calendario |
| w_cn231_anexos_conceptos | CN231 | Conceptos de cuentas contables |
| w_cn232_importar_cntas_conceptos | CN232 | Importar conceptos |
| w_cn233_anexos_conceptos_det | CN233 | Detalle asientos |
| w_cn500_cns_x_codrel | CN500 | Consulta por código de relación y rango |
| w_cn501_cntbl_cns_cliente | CN501 | Saldos de cuenta corriente por código de relación |
| w_cn502_cntbl_cns_cnta_crrte | CN502 | Saldos de cuenta corriente por cuenta contable |
| w_cn503_cntbl_cns_balance_comprob | CN503 | Consulta de balance de comprobación |
| w_cn504_cencos_trabajador | CN504 | Centros de costos de trabajadores |
| w_cn700_consistencia | CN700 | Consistencia |
| w_cn701_cntbl_rpt_plan_cuentas | CN701 | Plan de cuentas |
| w_cn702_cntbl_rpt_maestro_relacion | CN702 | Maestro de relaciones |
| w_cn703_cntbl_rpt_tipo_documento | CN703 | Tipos de documentos |
| w_cn704_cntbl_rpt_matriz_almacen | CN704 | Matrices contables por movimiento de almacén |
| w_cn705_cntbl_rpt_pre_asiento | CN705 | Emisión de reportes de los pre asientos |
| w_cn706_cntbl_rpt_asiento | CN706 | Emisión de reportes de los asientos |
| w_cn707_matriz_cntbl | CN707 | Matriz contable automática |
| w_cn708_reportes | CN708 | Matriz de reportes |
| w_cn709_cntbl_rpt_nro_asiento | CN709 | Emite reporte de asiento contable |
| w_cn710_voucher | CN710 | Voucher contable |
| w_cn711_cntbl_conciliacion | CN711 | Conciliación de gastos versus transferencias |
| w_cn712_cntbl_rpt_balance_comprob | CN712 | Contabilidad - Balance de comprobación |
| w_cn712_cntbl_rpt_balance_comprob_det | CN712 | Detalle - Balance de comprobación |
| w_cn712_eleccion_reporte | S/C | Elegir tipo de reporte |
| w_cn713_cntbl_rpt_balance_general | CN713 | Balance general |
| w_cn714_cntbl_rpt_balance_mensual | CN714 | Balance general de comprobación comparativo |
| w_cn715_cntbl_rpt_mayor_cencos | CN715 | Detalle del mayor general por centros de costos |
| w_cn716_transf_automaticas | S/C | Transferencias automáticas |
| w_cn717_maestro_relacion | CN717 | Maestro de relaciones (reporte) |
| w_cn718_diario_general_detalle | CN718 | Diario general |
| w_cn719_rpt_asientos_descuadrados | CN719 | Asientos descuadrados |
| w_cn720_rpt_error_asientos | CN720 | Error en consistencia de asientos |
| w_cn721_rpt_error_pre_asientos | CN721 | Error en consistencia de pre asientos |
| w_cn722_rpt_almacen | CN722 | Movimiento de almacenes a contabilizar |
| w_cn723_rpt_transf_matriz | CN723 | Movimiento de almacenes a contabilizar (transferencias) |
| w_cn724_rpt_diario_general_resumen | CN724 | Diario mensual resumen |
| w_cn725_libro_caja_bancos_mov | CN725 | Detalle de libro caja |
| w_cn726_rpt_mayor_resumen | S/C | Reporte del libro mayor |
| w_cn727_rpt_mayor_general_resumen | S/C | Reporte del libro mayor |
| w_cn728_rpt_libro_inventario_resumen | S/C | Reporte del libro mayor |
| w_cn729_cntbl_rpt_gastos_cencos | CN729 | Resumen de gastos por centro de costo |
| w_cn730_cntbl_rpt_libro_mayor | CN730 | Reporte del libro mayor |
| w_cn731_cntbl_rpt_caja_bancos | CN731 | Libro de caja bancos |
| w_cn732_cntbl_rpt_analitico_ctacte | CN732 | Mayor analítico de cuenta corriente |
| w_cn733_cntbl_rpt_analitico_cta_cte | CN733 | Reporte de analítico de cuenta corriente |
| w_cn734_cntbl_rpt_saldos_cuentas | CN734 | Resumen de cuenta corriente |
| w_cn735_cntbl_rpt_saldos_ctacte | CN735 | Reporte de saldos de cuenta corriente |
| w_cn735_rpt_saldos_ctacte_mm | CN735 | Reporte de saldos de cuenta corriente |
| w_cn736_rpt_saldos_ctacte | CN736 | Saldos de cuenta corriente por código de relación |
| w_cn737_rpt_libro_inventario | CN737 | Libro de inventario al detalle |
| w_cn738_rpt_libro_taller_det | CN738 | Detalle de operaciones de talleres por centro de costos |
| w_cn739_rpt_libro_taller_res | CN739 | Libro de talleres - Resumen |
| w_cn740_cp_rpt_formatos | CN740 | Plantillas de costos de producción de azúcar |
| w_cn741_cp_rpt_movimiento_mes | CN741 | Resumen mov. mensuales costos producción |
| w_cn742_gxc_rpt_mov_cosecha_semilla | CN742 | Mov. mensual de hectáreas cosechadas |
| w_cn743_rpt_eeff_clientes | CN743 | Texto de saldos por código de relación según cuenta |
| w_cn744_rpt_res_activo_fijo | CN744 | Resumen cta. contable de artículo mensual |
| w_cn744_rpt_res_activo_fijo_det | CN744 | Detalle de cuenta por artículos |
| w_cn745_rpt_libro_taller_res_1 | CN745 | Libro de talleres - Resumen por usuarios |
| w_cn746_rpt_matrices | CN746 | Matrices contables financieras |
| w_cn747_articulo_sub_categoria | CN041 | Reporte de artículos con sub-categorías |
| w_cn748_saldos_ctacte_x_grupo | CN748 | Saldos de cuenta corriente por grupo de códigos |
| w_cn748_saldos_ctacte_x_grupo_mm | CN748 | Saldos de cuenta corriente por grupo de códigos |
| w_cn749_rpt_tipo_cambio | CN749 | Tipo de cambio |
| w_cn750_cv_rpt_formatos | CN750 | Plantillas de costos de ventas de azúcar |
| w_cn751_rpt_matriz_cnta_cencos | CN751 | Matriz de costos por cuenta contable y centro de costos |
| w_cn752_cv_rpt_movimiento_mes | CN752 | Movimiento mensual de costos de ventas de azúcar |
| w_cn753_cntbl_rpt_datos_itf | CN753 | Reporte con movimiento para el I.T.F. |
| w_cn754_rpt_mayor_ctro_benef | CN754 | Detalle del mayor general por centros de beneficio |
| w_cn755_detalle_asientos_periodo | CN755 | Detalle de asiento por periodos |
| w_cn756_cencos_cntbl_cnta | CN756 | Resumen importe centros costo vs grupo contable |
| w_cn757_consumo_ot | CN757 | Consumos y producción por OT |
| w_cn760_rpt_saldos_ctacte | CN760 | Saldos de cuenta corriente por proveedores y cuentas contables |
| w_cn761_cntbl_rpt_balance_mensual_me | CN761 | Balance general mensual con meses extras |
| w_cn762_cntbl_rpt_x_documento | CN672 | Analítico de cuenta corriente por documento |
| w_cn763_plla_gtos_movilidad | CN763 | Planilla de gastos de movilidad |
| w_cn770_cntbl_rpt_balance_general | CN770 | Balance general - Contable |
| w_cn771_cntbl_rpt_gyp_funcion | CN771 | Ganancias y pérdidas por función |
| w_cn772_cntbl_rpt_gyp_naturaleza | CN772 | Ganancias y pérdidas por naturaleza |
| w_cn773_ebook | CN773 | Libros electrónicos (SUNAT) |
| w_cn774_detalle_libro_inventarios | CN774 | Libros detalle inventario y balance |
| w_cn779_cntbl_rpt_centro_costo | CN779 | Maestro de centros de costos |
| w_cn780_rpt_libro_inventario_res | CN780 | Libro de inventario resumen |
| w_cn782_rpt_sldo_ctacte | CN782 | Saldos de cta. cte. por grupo de cuentas contables |
| w_cn783_rpt_distrib_gtos_cc | CN780 | Libro de inventario resumen / Distribución gastos CC |
| w_cn784_grp_cc_costo_prod | CN784 | Costo de producción por grupo de centros de costos |
| w_cn785_costo_prod_x_plant_cc | CN785 | Costo según plantillas de centros de costos |
| w_cn786_rpt_anexo_ctacte | CN786 | Anexos de cuenta corriente |
| w_cn787_cuentas_conceptos | CN787 | Cuentas por conceptos |
| w_cn788_cxp_dif_tasa_cambio | CN788 | Saldos cuenta corriente / Dif. tasa cambio |
| w_cn789_errores_gen_apertura | CN789 | Errores a corregir antes de generar apertura |
| w_cn790_asientos_automaticos | CN790 | Asientos automáticos |
| w_cn790_rpt_resumen_gastos_analiticos | CN790 | Resumen de gastos analíticos |
| w_cn791_costo_plant_ctro_benef | CN791 | Costo según plantilla de centros de beneficio |
| w_cn792_devengados | CN792 | Reporte de devengados RRHH - Planilla |
| w_cn793_resumen_diario | CN793 | Resumen diario de comprobantes de retención |
| w_cn801_certificado_retencion | CN801 | Certificado de retención |
| w_cn802_saldo_certificado_retencion | CN802 | Saldo certificado de retención |
| w_cn803_rpt_libro_certificado_retencion | CN803 | Libro de certificados de retenciones |
| w_cn804_rpt_texto_certificado_retencion | CN804 | Texto para declaración PDT626 |
| w_cn805_abc_certificado_retencion | CN805 | Mantenimiento de documentos de certificados de retenciones |
| w_cn806_saldo_cntbl_mensual | CN806 | Movimiento mensual por nivel de cuenta |
| w_cn807_documentos_cancelados | CN806 | Documentos cancelados |
| w_cn810_texto_daot_costos | CN810 | DAOT - Declaración Anual Operaciones Terceros - Costos |
| w_cn811_texto_daot_ingresos | CN811 | DAOT - Declaración Anual Operaciones Terceros - Ingresos |
| w_cn812_inconsitecia_provedores | CN812 | Inconsistencia proveedores |
| w_cn814_rpt_txt_pdt0656_sunat | CN814 | Formulario 0656 para la SUNAT |
| w_cn815_rpt_guia_fact | CN815 | Seguimiento de guías vs facturación |
| w_cn816_f14_libro_retenciones | CN816 | Formato 14. Libro de retenciones |
| w_cn817_f51_libro_diario | CN817 | Formato 51. Libro de diario |
| w_cn818_f12_libro_caja | CN818 | Formato 1.2. Libro de caja: Detalle mov. cuenta cte. |
| w_cn819_f11_libro_caja_efectivo | CN819 | Formato 1.1. Libro de caja: Detalle mov. efectivo |
| w_cn820_f61_libro_mayor | CN820 | Formato 6.1. Libro mayor |
| w_cn821_f131_inventario_valorizado | CN821 | Formato 13.1. Registro de inventario permanente valorizado |
| w_cn822_txt_liquidaciones_compra | CN822 | Texto para importar liquidaciones de compra PDT617 |
| w_cn823_f52_diario_simplificado | CN823 | Formato 5.2 Libro diario simplificado |
| w_cn901_traslada_asientos | CN901 | Importación de pre asientos como asientos contables |
| w_cn902_saldos_x_cencos | CN902 | Saldos por centros de costos / Pre asientos talleres |
| w_cn903_ajuste_conversion | CN903 | Ajuste por conversión |
| w_cn906_valoriz_fap_ni | CN906 | Valorización de materiales |
| w_cn907_mayorizacion_cuentas | CN907 | Mayorización de cuentas |
| w_cn926_ajuste_inflacion | CN926 | Ajuste por inflación |
| w_cn926_ajuste_inflacion_new | CN926 | Ajuste por inflación (nueva versión) |
| w_cn928_nivelacion_tipo_cambio | CN928 | Nivelación tipo de cambio |
| w_cn932_valoriz_almac | CN932 | Revalorización de almacenes |
| w_cn940_pre_asnt_prod_exonerados | CN940 | Generación de pre asientos de productos exonerados |
| w_cn941_pre_asnt_muestras_comerc | CN941 | Generación de pre asientos de muestras comerciales |
| w_cn942_pre_asnt_donaciones | CN942 | Generación de pre asientos de donaciones |
| w_cn943_pre_asnt_vtas_difer | CN943 | Generación de pre asientos de ventas diferidas |
| w_cn944_pre_asnt_alm_ingr | CN944 | Generación de pre-asientos de almacenes (ingresos) |
| w_cn945_clonacion_asientos | CN945 | Clonación de asientos contables |
| w_cn949_pre_asnt_transfer_x | CN949 | Generación de pre asientos de transferencia de gastos |
| w_cn950_pre_asnt_costos_prod | CN950 | Generación de pre asientos de costos de producción |
| w_cn951_pre_asnt_costos_vta_az | CN951 | Generación de pre asientos de costos de venta de azúcar |
| w_cn952_pre_asnt_alm_salid | CN952 | Pre asientos de almacén sub prod. term. |
| w_cn953_cuadre_asiento | CN953 | Regeneración de asientos contables |
| w_cn954_act_pre_cuenta | CN954 | Actualización de pre cuentas |
| w_cn955_act_doc_pendientes | CN955 | Actualiza cuenta corriente financiera en función a contable |
| w_cn956_libro_inventario_mensual | CN956 | Saldos mensuales de almacén de materiales |
| w_cn958_genera_automaticas | CN958 | Genera asientos de cuentas contables automáticas |
| w_cn959_mayor_ctacte_x_origen | CN959 | Mayorización de cuenta corriente por origen |
| w_cn960_mayor_cuentas_x_origen | CN960 | Mayorización de cuentas contables por origen |
| w_cn961_mayor_cnta_crrte | CN961 | Mayorización de cuenta corriente |
| w_cn962_genera_saldo_cencos | CN962 | Mayorización de centros de costos |
| w_cn963_libro_inventario_mensual_saldo | CN963 | Saldo valorizado mensual de almacén de materiales |
| w_cn964_pre_asnt_os | CN964 | Pre asientos de órdenes de servicio |
| w_cn965_devengados_rrhh | CN965 | Pre asientos de devengados de planilla |
| w_cn966_asientos_lbs | CN966 | Generación de asientos de LBS |
| w_cn967_costos_contables | CN967 | Costos contables |
| w_cn968_asiento_costo_vinc | CN968 | Asientos de costos vinculados a compras |
| w_cn970_cierre_ejercicio | CN970 | Cierre anual del ejercicio |
| w_cn971_apertura_ejercicio | CN971 | Apertura del ejercicio |
| w_cn972_cierre_mensual | CN972 | Asiento de cierre mensual |
| w_cn973_prov_serv_terceros | CN973 | Asiento contable - Proveedores servicios terceros |
| w_cn974_elimina_asiento_diario | CN974 | Elimina diario totalmente |
| w_cn975_doc_no_cancelables | CN975 | Ventas a título gratuito / Documentos no cancelables |
| w_cn976_matriz_nula_almacen | CN976 | Actualización contable |
| w_cn980_generacion_calendario | CN980 | Generación de calendario |
| w_cn981_ajuste_dif_cambio | CN981 | Ajuste mensual de saldo de documentos |
| w_cn982_balance_historico | CN982 | Balance de comprobación histórico |
| w_cn983_exp_balance_comprobacion_pdt | CN983 | Balance de comprobación PDT |
| w_cn984_asiento_redondeo | CN984 | Asiento de ajustes por redondeo |
| w_cn985_ajuste_bancario | CN985 | Ajuste por diferencia bancaria - Saldos bancarios |
| w_cntbl_mayorizacion_cta_cte | S/C | Mayorización cuenta corriente |
| w_cntbl_mayorizacion_cuentas | S/C | Mayorización de cuentas |
| w_cntbl_mayor_cencos | S/C | Mayor por centros de costos |
| w_cntbl_mayor_cnta_crrte | S/C | Mayor cuenta corriente |
| w_cntbl_rpt_cuenta_corriente | S/C | Reporte de saldos de cuenta corriente |
| w_cntbl_rpt_detalle_gastos | S/C | Reporte del detalle de gastos |
| w_cntbl_rpt_detalle_gastos_c | S/C | Resumen general a nivel de cuenta por divisiones |
| w_cntbl_rpt_detalle_gastos_r | S/C | Resumen de gastos por centro de costo y cuenta contable |
| w_cntbl_rpt_matrices | S/C | Reporte de matrices contables |
| w_cntbl_saldos_banco | S/C | Saldos de banco |
| w_cntbl_transf_automaticas | S/C | Transferencias automáticas |
| w_cntbl_transf_factores | S/C | Genera factores de transferencias automáticas |
| w_cn_error_asiento | S/C | Errores de proceso de asientos |
| w_cp_pro_asiento | S/C | Contabilidad - Costos de producción |
| w_cp_pro_inicializa_mov | S/C | Contabilidad - Inicialización movimientos |
| w_cp_pro_produccion_azucar | S/C | Contabilidad - Producción azúcar |
| w_cp_pro_reversion_mov | S/C | Contabilidad - Costos de producción - Reversión mov. |
| w_cv_pro_asiento | S/C | Contabilidad - Costos de ventas |
| w_cv_pro_inicializa_mov | S/C | Contabilidad - Inicialización movimientos CV |
| w_cv_pro_reversion_mov | S/C | Contabilidad - Costos de ventas - Reversión mov. |
| w_cv_pro_ventas_azucar | S/C | Contabilidad - Ventas azúcar |
| w_gxc_act_libro_mes | S/C | Gastos por campos - Actualización libro mes |
| w_gxc_asi_cosecha_semilla | S/C | Gastos por campos - Asiento cosecha semilla |
| w_gxc_asi_dist_semilla | S/C | Gastos por campos - Asiento distribución semilla |
| w_gxc_asi_fusion_apertura | S/C | Gastos por campos - Asiento fusión apertura |
| w_gxc_asi_indexacion | S/C | Gastos por campos - Asiento indexación |
| w_gxc_fusion_apertura | S/C | Gastos por campos - Fusión apertura |
| w_gxc_fusion_apertura_act | S/C | Gastos por campos - Fusión apertura actualización |
| w_gxc_fusion_correlativos | S/C | Gastos por campos - Fusión correlativos |
| w_gxc_indexacion | S/C | Gastos por campos - Indexación |
| w_gxc_mov_cosecha_semilla | S/C | Gastos por campos - Movimiento cosecha semilla |
| w_gxc_reb_cosecha_semilla | S/C | Gastos por campos - Rebaja cosecha semilla |
| w_gxc_rpt_asi_cos_sem | S/C | Gastos por campos - Reporte asiento cosecha semilla |
| w_gxc_rpt_asi_dist_semilla | S/C | Gastos por campos - Reporte asiento distribución semilla |
| w_gxc_rpt_asi_fusion_apertura | S/C | Gastos por campos - Reporte asiento fusión apertura |
| w_gxc_rpt_asi_indexacion | S/C | Gastos por campos - Reporte asiento indexación |
| w_gxc_rpt_costos_agricolas | S/C | Gastos por campos - Costos agrícolas |
| w_gxc_rpt_costos_agricolas_adm | S/C | Resumen de costos agrícolas por administraciones |
| w_gxc_rpt_cuenta_presupuestal | S/C | Resumen por cuentas presupuestales - Gastos por campos |
| w_gxc_rpt_dist_semilla | S/C | Gastos por campos - Reporte distribución semilla |
| w_gxc_rpt_existencia_semilla | S/C | Gastos por campos - Reporte existencia semilla |
| w_gxc_rpt_fusion_apertura | S/C | Gastos por campos - Reporte fusión apertura |
| w_gxc_rpt_indexacion | S/C | Gastos por campos - Reporte indexación |
| w_gxc_rpt_libro_gastos_campos | S/C | Gastos por campos - Libro de gastos |
| w_gxc_rpt_libro_gastos_cosecha | S/C | Gastos por campos - Libro gastos cosecha |
| w_gxc_rpt_presup_cana | S/C | Gastos por campos - Presupuesto caña |
| w_gxc_rpt_rebaja_cos_sem | S/C | Gastos por campos - Reporte rebaja cosecha semilla |
| w_gxc_rpt_resumen_campo | S/C | Gastos por campos - Resumen campo |
| w_gxc_rpt_resumen_rebaja | S/C | Gastos por campos - Resumen rebaja |
| w_saldo_cnta_cte | CN712 | Balance de comprobación / Saldos cuenta corriente |

---

## 6. Finanzas

*(Pendiente de análisis detallado)*

---

## 7. RRHH

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cn002_plan_cuentas | CN002 | Plan de Cuentas |
| w_cn009_tipo_cambio | CN009 | Tipo de cambio |
| w_cn705_cntbl_rpt_pre_asiento | CN705 | Emisión de Reportes de los Pre Asientos |
| w_fi010_bancos | FI010 | Bancos |
| w_fi011_cuentas_bancos | S/C | Cuentas de Banco |
| w_pt765_planilla | PT765 | Reporte de Planilla |
| w_pt765_planilla_det | PT764 | Reporte de Planilla (detalle) |
| w_rh001_calendar_feriado_plla | RH001 | Calendario de feriados |
| w_rh002_param_ctacte_new | RH002 | Parámetros de grupos de descuentos de cuenta corriente |
| w_rh003_tipo_trabajador_user | RH003 | Tipo Trabajador - Usuario |
| w_rh006_num_solicitud | RH006 | Último Número de la Solicitud |
| w_rh007_numerador_maestro | RH007 | Numerador de Código de Trabajador |
| w_rh008_asigna_origen | RH008 | Asignación de Orígenes por Usuarios |
| w_rh009_param_cconcep | RH009 | Grupos Para Cálculo de Planillas |
| w_rh010_abc_parametros | RH010 | Parámetros de Recursos Humanos |
| w_rh011_abc_conceptos_calculo | RH011 | Grupos de Conceptos de Cálculo |
| w_rh012_abc_tipo_trabajador | RH012 | Tipos de Trabajadores |
| w_rh013_abc_situac_trabajador | RH013 | Condición del Trabajador |
| w_rh014_abc_motivo_cese | RH014 | Motivos de Ceses |
| w_rh015_abc_grado_instruccion | RH015 | Grados de Instrucción |
| w_rh016_abc_categoria_salarial | RH016 | Categorías Salariales |
| w_rh017_abc_cargos | RH017 | Cargos u Ocupaciones |
| w_rh018_abc_profesion | RH018 | Profesiones |
| w_rh019_abc_profesion_especialidad | RH019 | Profesiones y/o Especialidades |
| w_rh020_abc_ubicacion_geografica | RH020 | Ubicación Geográfica |
| w_rh021_abc_cargos_categorias | RH021 | Cargos por Categorías |
| w_rh022_parametros_fechas | RH022 | Parámetros de Fechas de Procesos |
| w_rh023_parametros_quincena | RH023 | Parámetros de Cálculo de Quincena |
| w_rh024_confin_trabajador | RH024 | Concepto Financiero - Tipo Trabajador |
| w_rh029_modifica_estado_trab | RH029 | Modificar Estado Trabajador |
| w_rh030_abc_maestro_personal | RH030 | Mantenimiento de Personal |
| w_rh031_abc_concepto | RH031 | Maestro de Conceptos de Cálculos |
| w_rh032_abc_area_seccion | RH032 | Áreas y Secciones |
| w_rh033_abc_admin_afp | RH033 | Administradoras de A.F.P. |
| w_rh034_abc_grupos_conceptos | RH034 | Grupos de Conceptos |
| w_rh035_abc_conceptos_cuentas | RH035 | Cuentas Contables y Presupuestales por Conceptos |
| w_rh036_abc_impuesto_renta | RH036 | Impuestos de Renta de 5ta. Categoría |
| w_rh037_lbs_cnta_prsp | RH037 | Cuentas Presupuestal y Concepto PLAME por LBS |
| w_rh046_abc_calificacion_desempeno | RH046 | Calificaciones por Actitudes |
| w_rh062_tipo_renuncia_lbs | RH062 | Tipo Renuncia LBS |
| w_rh070_numerador_liquidacion | RH070 | Numerador de Liquidaciones |
| w_rh071_grupos_calculo | RH071 | Grupos de Cálculos |
| w_rh072_parametros_liquidacion | RH072 | Parámetros de Liquidación de Créditos Laborales |
| w_rh074_parametros_utilidades | RH074 | Parámetros de Participación por Utilidades |
| w_rh075_distribucion_utilidades | RH075 | Distribución de Utilidades |
| w_rh076_no_perciben_utilidades | RH076 | Personal que NO Percibe Utilidades |
| w_rh077_personal_adicional | RH077 | Personal externo adicional que recibe utilidades |
| w_rh078_grupo_calc_x_seccion | RH078 | Grupo de Cálculo por Secciones |
| w_rh079_maestro_tarjetas | RH079 | Maestro de Tarjetas |
| w_rh080_maestro_calificaciones | RH080 | Tipos de Calificaciones |
| w_rh081_tipo_establecimiento | RH081 | Tipo Establecimiento |
| w_rh082_condicion_establecimiento | RH082 | Condición de Establecimiento |
| w_rh083_via | RH083 | Vía |
| w_rh084_zona | RH084 | Zonas |
| w_rh085_doc_identidad | RH085 | Documentos de Identidad |
| w_rh086_tipo_pension | RH086 | Tipo de Pensión |
| w_rh087_estado_civil | RH087 | Estado Civil |
| w_rh088_tipo_trabajador | RH088 | Tipo de Trabajador |
| w_rh089_tipo_contrato | RH089 | Tipo de Contrato |
| w_rh090_periocidad_remuneracion | RH090 | Periocidad Remuneración |
| w_rh091_regimen_pensionario | RH091 | Régimen Pensionario |
| w_rh092_eps | RH092 | EPS |
| w_rh093_t_ext_contarto | RH093 | T. Extinción Contrato |
| w_rh094_vinculo_familiar | RH094 | Vínculo Familiar |
| w_rh095_baja_dhabiente | RH095 | T. Baja Derecho Habiente |
| w_rh096_tip_suspension_laboral | RH096 | T. Suspensión Laboral |
| w_rh097_parte_lesionada | RH096 | T. Suspensión Laboral (Parte Lesionada) |
| w_rh098_naturaleza_lesion | RH098 | Naturaleza Lesión |
| w_rh099_cargo_vs_rtps | RH099 | Cargo vs Ocupación RTPS |
| w_rh100_rmv_tipo_trabaj | RH100 | Remuneración Mínima x Tipo de Trabajador |
| w_rh101_ctacte_registro | RH101 | Cuenta corriente |
| w_rh101_ctacte_registro_popup | RH101 | Registro de Cuenta Corriente |
| w_rh110_abc_ganancia_dscto_fijo | RH110 | Ganancias y Descuentos Fijos |
| w_rh112_abc_quinta_categoria | RH112 | Movimiento de Quinta Categoría |
| w_rh115_abc_judiciales | RH115 | Descuentos Judiciales a Alimentistas |
| w_rh118_adelanto_quincena | RH118 | Modificar Adelanto Quincena |
| w_rh123_abc_mov_inasistencia | RH123 | Control de Inasistencia |
| w_rh125_abc_ganancia_dscto_variable | RH125 | Ganancias y Descuentos Variables |
| w_rh139_abc_nro_convenio | RH139 | Último Número de Convenio |
| w_rh141_abc_ingr_externo | RH141 | Ganancias Externas |
| w_rh173_eval_desempeno | RH173 | Evaluación de Desempeño del Trabajador |
| w_rh173_eval_desempeno_rsp | S/C | Evaluación de Actitudes del Trabajador |
| w_rh176_adelantos_utilidades | RH176 | Adelantos de Utilidades |
| w_rh177_externo_adelantos_util | RH177 | Movimiento de Adelantos a Cuenta |
| w_rh179_participacion_utilidades | RH179 | Distribución manual de utilidades |
| w_rh201_upload_gan_dscto_variable | RH201 | Ingreso Masivo de Ganancias Variables |
| w_rh202_periodo_vacacional | RH202 | Vacaciones, Permisos o Subvenciones por Trabajador |
| w_rh210_cns_ganancias_fijas | RH210 | Ganancias Fijas por Conceptos |
| w_rh211_cns_alcance_concepto | RH211 | Alcances por Conceptos de la Planilla Calculada |
| w_rh212_cns_categorias_salariales | RH212 | Categorías Salariales |
| w_rh213_cns_cuenta_corriente | RH213 | Saldos de Cuentas Corrientes |
| w_rh214_cns_registro_inasistencia | RH214 | Registros de Inasistencias |
| w_rh215_cns_saldos_devengados | RH215 | Saldos por Devengados |
| w_rh216_cns_proyeccion_quinquenio | RH216 | Proyección de Pagos de Quinquenios |
| w_rh217_cns_evaluaciones | RH217 | Compensación Variable - Evaluaciones |
| w_rh218_grado_instruccion_rtps | RH218 | Nivel Educativo |
| w_rh219_nacionalidad_rtps | RH219 | Nacionalidad |
| w_rh220_situacion_eps_rtps | RH220 | Situación EPS |
| w_rh221_doc_acredita_pater_rtps | RH221 | Documentos que Acreditan Paternidad |
| w_rh222_modalidad_pago_rtps | RH222 | Modalidad de Pago |
| w_rh224_tipo_servicio_clanae | RH224 | Tipos de Servicios - CLaNAE |
| w_rh225_establecimientos_rtps | RH225 | Establecimientos |
| w_rh228_conceptos_rtps | RH228 | Conceptos RTPS |
| w_rh230_turnos_establec_rtps | RH230 | Turnos por Establecimiento |
| w_rh231_tipos_de_sangre | RH231 | Tipos de Sangre |
| w_rh232_ocupaciones_rtps | RH232 | Ocupaciones |
| w_rh233_tipo_subsidio_rtps | RH233 | Tipos de Subsidio |
| w_rh234_permiso_vacaciones | RH234 | Boleta de permiso de vacaciones |
| w_rh235_aprob_permiso_vacac | RH235 | Aprobación de Solicitud de Crédito por RRHH |
| w_rh236_envio_plla | RH236 | Envío a Planilla de Cálculo |
| w_rh237_abc_basc_tipoactivofinanciero | RH237 | Tipos de Activos Financieros Personal |
| w_rh238_abc_basc_tipodocumentoescaneado | RH238 | Tipos de Documentos Escaneados |
| w_rh239_abc_basc_cursos_capacitacion | RH239 | Cursos para Capacitación |
| w_rh240_basc_programa_capacitacion | RH240 | Programación de cursos para Capacitación |
| w_rh241_abc_tipos_permiso_papeleta | RH241 | Tipos de Permiso para Papeletas de Salida |
| w_rh242_permiso_papeleta | RH242 | Papeletas de Salida |
| w_rh242_permiso_papeleta_impresion | RH242 | Papeleta de Permiso |
| w_rh300_reportes_alimentista | RH300 | Reportes de alimentistas |
| w_rh300_reportes_param | RH300 | Reportes parametrizados (título dinámico) |
| w_rh301_dias_falta | RH301 | Desactivación de Trabajador por días de falta |
| w_rh313_rpt_distribucion_contable | RH313 | Consistencia de Distribución de Horas por Centros de Costos |
| w_rh314_rpt_grupos_calculo | RH314 | Reporte de Grupos de Cálculo de Planilla |
| w_rh324_rpt_detalle_cuenta_corriente | RH324 | Detalle de Cuenta Corriente por Trabajador |
| w_rh332_rpt_conceptos_varios | RH332 | Reporte de Conceptos Varios |
| w_rh333_rpt_detalle_planilla | RH333 | Detalle de Planilla Calculada |
| w_rh334_rpt_boletas_pago | RH334 | Boletas de Pago |
| w_rh335_rpt_emision_planilla | RH335 | Emisión de Planillas |
| w_rh336_rpt_boletas_pago_trabajador | RH336 | Boletas de Pago por Trabajador |
| w_rh345_rpt_quincena_firma | RH345 | Reporte de quincena para firmar |
| w_rh350_rpt_deposito_cts_semestral | RH350 | Depósitos de C.T.S. Semestrales |
| w_rh353_rpt_remuneraciones_computables | RH353 | Remuneraciones Computables de C.T.S. |
| w_rh355_rpt_liquidacion_cts_du | RH355 | Carta de Liquidación CTS |
| w_rh356_rpt_provisiones | RH356 | Provisiones de C.T.S. y Gratificaciones |
| w_rh357_rpt_adelanto_gratificacion | RH357 | Adelanto de Gratificaciones |
| w_rh358_rpt_adelanto_gratificacion_st | RH358 | Adelanto de Gratificaciones del Personal sin Tarjeta de Ahorro |
| w_rh359_rpt_boletas_gratificacion | RH359 | Boletas de Adelantos de Gratificaciones |
| w_rh366_rpt_asiento_devengados | RH366 | Reporte de Asientos Contables de Devengados |
| w_rh367_rpt_detalle_convenios | RH367 | Adelantos a Cuenta de C.T.S. - Convenios |
| w_rh368_rpt_convenios | RH368 | Emisión de Convenios por Adelantos a Cuenta de C.T.S. |
| w_rh369_rpt_saldos_cts | RH369 | Reporte de Saldos de C.T.S. |
| w_rh370_rpt_retencion_quinta | RH370 | Acumulado de Retenciones Afectas a Quinta Categoría |
| w_rh371_rpt_certificados_quinta | RH371 | Certificados de Retenciones de Quinta Categoría |
| w_rh372_rpt_retencion_aportes | RH372 | Retención de Aportes al Sistema de Pensiones |
| w_rh373_rpt_retenciones_previsionales | RH373 | Liquidación Anual de Aportes y Retenciones Previsionales |
| w_rh374_rpt_cabecera_planilla | RH374 | Emisión de Cabecera Para Reporte de Planillas |
| w_rh376_rpt_ganancias_descuentos_fijos | RH376 | Ganancias y Descuentos Fijos - Todos los Trabajadores |
| w_rh377_rpt_edades_jubilacion | RH377 | Trabajadores en Edades de Jubilación |
| w_rh378_rpt_padron_trabajadores | RH378 | Padrón de Trabajadores por Ventas de Productos |
| w_rh379_rpt_adeudos_laborales | RH379 | Reporte de Adeudos Laborales de los Trabajadores |
| w_rh381_rpt_detalle_fondo_retiro | RH381 | Detalle del Fondo de Retiro al 31 de Diciembre de 1994 |
| w_rh382_fmt_retenc_aporte | RH382 | Formato de retención SNP o AFP |
| w_rh384_rpt_planilla_fmt_cab | RH384 | Cabecera de Formato de Planilla |
| w_rh385_rpt_planilla_fmt_det | RH385 | Detalle de Formato de Planilla |
| w_rh386_afp_fondo_pension | RH386 | Aportes y retenciones de AFP - Fondo de pensiones |
| w_rh387_afp_retenc_retribuc | RH387 | Aportes y retenciones de AFP - Retenciones y retribuciones |
| w_rh388_snp_retenciones | RH388 | Retenciones de SNP |
| w_rh389_remuneracion_retenciones | RH389 | Retenciones de AFP y SNP |
| w_rh397_rpt_av_calificacion_objetivos | RH397 | Formato de Calificación por Objetivos |
| w_rh398_rpt_av_calificacion_desempeno | RH398 | Formato de Calificación por Actitudes |
| w_rh399_rpt_av_trabajadores_evaluar | RH399 | Relación de Trabajadores a ser Evaluados |
| w_rh400_rpt_av_estado_evaluaciones | RH400 | Estado de las Evaluaciones |
| w_rh401_rpt_av_evaluaciones | RH401 | Constancia de Evaluaciones |
| w_rh402_rpt_av_compensacion_variable | RH402 | Relación de Pagos por Compensación Variable |
| w_rh403_rpt_av_distribucion_banda | RH403 | Determinación de las Bandas Salariales |
| w_rh404_rpt_av_seccion_objetivos | RH404 | Relación de Secciones |
| w_rh405_rpt_av_evaluaciones_desempeno | RH405 | Estado de las Evaluaciones por Desempeño |
| w_rh406_rpt_gen_contrato_cepibo | RH406 | Genera contrato |
| w_rh406_rpt_gen_trab | RH406 | Datos de Trabajadores |
| w_rh406_rpt_genera_contrato | RH406 | Genera contrato |
| w_rh407_rpt_av_objetivos_mes | RH407 | Evaluaciones Mensuales por Objetivos |
| w_rh408_rpt_onomasticos | RH408 | Lista de Onomásticos |
| w_rh409_rpt_gratificacion_det | RH409 | Detalle de Gratificación |
| w_rh410_p_adelanto_quincena | RH410 | Calcula Adelanto de Quincena |
| w_rh411_p_calcula_planilla | RH411 | Proceso de Cálculo de la Planilla |
| w_rh414_recalcula_boleta | RH414 | Recálculo de boleta |
| w_rh415_liquidacion_benef | RH415 | Liquidaciones de beneficio del Trabajador |
| w_rh416_rpt_derecho_habientes | RH416 | Maestro de Derecho Habientes |
| w_rh417_boleta_anual | RH417 | Boletas Anuales del Trabajador |
| w_rh420_p_calcula_cts_semestral | RH420 | Cálculo de Compensación Tiempo de Servicio Semestral |
| w_rh421_p_adiciona_cts_acumulado | RH421 | Adiciona C.T.S. Semestral al Acumulado de Cuenta Corriente |
| w_rh422_p_calcula_intereses_cts | RH422 | Calcula Intereses de Depósitos de C.T.S. |
| w_rh423_liquidacion_benef | RH423 | Planilla Horizontal de LBS |
| w_rh428_rpt_neto_bancos | RH428 | Netos por Bancos |
| w_rh429_rpt_detalle_planilla_hor | RH429 | Detalle de Planilla Calculada - Horizontal |
| w_rh433_rpt_det_hor_plla_rango | RH433 | Planilla Horizontal x Rangos |
| w_rh434_p_calcula_planilla_ind | RH434 | Proceso de Cálculo de la Planilla Individual |
| w_rh440_p_calcula_gratificacion | RH440 | Proceso de Cálculo de Gratificaciones |
| w_rh441_p_adiciona_gratificacion | RH441 | Adiciona Gratificaciones Para Cálculo de Planilla |
| w_rh450_p_calcula_provision_cts | RH450 | Calcula Provisiones por Compensación por Tiempo de Servicios |
| w_rh451_p_calcula_provision_gra | RH451 | Calcula Provisiones de Gratificaciones |
| w_rh452_p_calcula_provision_vac | RH452 | Calcula Provisiones por Vacaciones y Bonificación Vacacional |
| w_rh453_p_pago_sin_cnta_ahorro | RH453 | C.E. del Personal Sin Cuenta de Ahorro |
| w_rh454_p_pago_jud_alimentista | RH454 | C.E. del Personal con Descuento Judicial |
| w_rh455_p_pago_jub_pensionistas | RH455 | C.E. del Personal Jubilado Pensionista |
| w_rh456_p_actualiza_concepto_fijo | RH456 | Actualiza Conceptos Fijos por Trabajador |
| w_rh457_p_calcula_fondo_retiro | RH457 | Calcula Fondo de Retiro a Socios |
| w_rh458_p_calcula_deuda_laboral | RH458 | Cálculo de Adeudos Laborales |
| w_rh462_p_pago_remuneraciones | RH462 | Genera Pagos por Remuneraciones |
| w_rh468_p_pago_alimentistas | RH468 | Genera Pagos de Alimentistas - Judiciales |
| w_rh474_p_asiento_prov_gra | RH474 | Asientos de provisión de Gratificaciones |
| w_rh478_p_asiento_prov_vac | RH478 | Asientos de provisión de Vacaciones |
| w_rh483_p_backup_grupos_calculo | RH483 | Backup de Grupos de Cálculos |
| w_rh484_p_restore_grupos_calculo | RH484 | Restore de Grupos de Cálculos |
| w_rh492_perfiles_structura | S/C | Opciones Perfil |
| w_rh494_p_asiento_prov_cts | RH494 | Asientos de provisión de CTS |
| w_rh496_perfiles_consulta | RH496 | Estructura de perfiles |
| w_rh508_rpt_saldo_cuenta_corrte | RH508 | Saldo de Cuenta Corriente por concepto |
| w_rh510_adelanto_utilidades | RH510 | Genera adelantos de Utilidades |
| w_rh512_concepto_grupo | RH512 | Consulta conceptos vs grupos |
| w_rh513_adiciona_pagos | RH513 | Adiciona Adelantos a Cuenta de Utilidades a la Planilla |
| w_rh514_distribucion_x_trab | RH514 | Distribución x Trabajador |
| w_rh515_calculo_utilidades | RH515 | Cálculo de Utilidades |
| w_rh600_rpt_liquidacion_haberes | RH600 | Liquidación de Créditos Laborales |
| w_rh601_rpt_liquidacion_diferidos | RH601 | Liquidación Diferida por Trabajador |
| w_rh602_rpt_liquidacion_cnta_crrte | RH602 | Cuenta Corriente de Liquidaciones |
| w_rh603_rpt_cronograma_pagos | RH603 | Relación de Cronograma de Pagos |
| w_rh604_rpt_estado_liquidaciones | RH604 | Estado de las Liquidaciones de Créditos Laborales |
| w_rh605_rpt_asiento_liquidacion | RH605 | Asiento de Liquidación de Créditos Laborales |
| w_rh606_rpt_cuenta_corrte | RH606 | Saldo de Cuenta Corriente |
| w_rh607_rpt_asiento_remuneraciones | RRHH607 | Resumen de Asiento de Remuneraciones |
| w_rh608_rpt_f_calculo | RH608 | Fecha de Cálculo |
| w_rh610_rpt_adelanto_utildades | RH610 | Adelantos a Cuenta de Utilidades |
| w_rh612_rpt_boletas_utilidades | RH612 | Boletas de Utilidades |
| w_rh613_rpt_utilidades_distribucion | RH613 | Detalle de Utilidades |
| w_rh614_rpt_utilidades_errores | RH614 | Errores de Utilidades |
| w_rh623_rpt_validacion_contable | RH623 | Reporte de Validación de Pre Asientos |
| w_rh624_rpt_inasistencias_x_trabajador | RH624 | Inasistencia Por Trabajador |
| w_rh625_rpt_importes_x_concepto | RH625 | Importes de conceptos x Trabajador |
| w_rh628_rpt_quinta_categoria | RH628 | Cuadro de Retención de Quinta |
| w_rh629_rpt_remuneraciones_ano | RH629 | Cuadro de Remuneraciones No Afectas |
| w_rh630_detalle_planilla | RH630 | Detalle de Planilla - Total por Pagar |
| w_rh631_rpt_consol_afpnet | RH631 | Consolidado de Documentos para AFPNet |
| w_rh632_consulta_vacaciones | RH632 | Consulta masiva de vacaciones |
| w_rh701_doc_pagar_plla | RH701 | Documentos de Pago |
| w_rh702_rpt_detalle_cts_du | RH702 | Detalle de Liquidación de C.T.S. Mensual |
| w_rh703_descuento_sindical | RH703 | Reporte de Descuento Sindical |
| w_rh704_ficha_personal | RH704 | Maestro de Personal |
| w_rh705_establecimientos_rtps | RH705 | Datos de Establecimientos |
| w_rh706_turnos_establecimientos_rtps | RH706 | Turnos de Establecimientos |
| w_rh707_datos_trabajador_rtps | RH707 | Datos de Trabajador |
| w_rh708_datos_derechohabiente_rtps | RH708 | Datos de Derechohabientes |
| w_rh709_periodos_laborales_rtps | RH709 | Datos de Periodos Laborales |
| w_rh710_planilla_rangos_filtro | RH710 | Planilla Horizontal x Rangos con Filtros |
| w_rh711_dias_subsidiados_rtps | RH711 | Días Subsidiados del Trabajador |
| w_rh712_utilidades_externos | RH712 | Detalle de Utilidades Externos |
| w_rh713_establecimientos_trabajador_rtps | RH713 | Establecimientos donde labora el Trabajador |
| w_rh714_recibos_honorarios_rtps | RH714 | Recibos de 4ta Categoría |
| w_rh715_remuneracion_trabaj_rtps | RH715 | Datos de Remuneración del Trabajador |
| w_rh716_pago_diario_des_jor | RH716 | Pago Diario Destajo - Jornal |
| w_rh717_relacion_tarjetas_marcacion | RH717 | Relación de tarjetas de marcación |
| w_rh718_certificado_retencion | RH718 | Certificado Retención |
| w_rh719_ajuste_rta_quinta | RH715 | Ajustes Renta Quinta Categoría |
| w_rh720_conceptos_anuales | RH720 | Conceptos Anuales por trabajador |
| w_rh721_resumen_planilla | RH721 | Resumen de Planilla |
| w_rh722_jornada_laboral_rtps | RH722 | Datos de Jornada Laboral |
| w_rh723_consulta_masiva_afpnet | RH723 | Consulta Masiva AFP.NET |
| w_rh724_planillas_afpnet | RH724 | Planilla para AFP NET |
| w_rh725_liq_cuarta_quinta | RH725 | Liquidación de cuarta / quinta |
| w_rh726_consist_dias_no_lab | RH725 | Consistencia de Días no laborados |
| w_rh727_certificado_afp | RH727 | Liquidación Anual - Retenciones |
| w_rh728_formato_eleccion | RH727 | Liquidación Anual - Retenciones |
| w_rh729_gan_dsctos_variables | RH729 | Ganancias y Descuentos Variables por Concepto |
| w_rh730_dias_no_trabaj_no_subs_plame | RH730 | Días no Trabajados y no Subsidiados |
| w_rh731_rpt_basc | RH731 | Reportes BASC |
| w_rh732_rpt_basc_programa_capacitacion | RH732 | Programa de Capacitación y Actividades |
| w_rh733_dias_vacaciones | RH733 | Saldo días de vacaciones |
| w_rh734_planilla_horizontal_anual | RH734 | Planilla de ingresos horizontal por periodos |
| w_rh735_rpt_boleta_mensual | RH735 | Boletas de pago mensual |
| w_rh736_vacaciones_gozadas | RH733 | Saldo días de vacaciones |
| w_rh737_resumen_afp | RH737 | Resumen Cálculo AFP (PLANILLA Y L.B.S.) |
| w_rh738_resumen_planilla | RH738 | Resumen Planilla Calculada |
| w_rh739_tasas_sctr_ies | RH739 | Trabajador - Tasas SCTR-EsSalud y/o convenio IES |
| w_rh740_resumen_dias_lab | RH740 | Resumen de asistencia por tipo de trabajador |
| w_rh741_cts_trabajador | RH741 | Reporte de CTS por Trabajador |
| w_rh742_maestro_trabajadores | RH742 | Reporte de Trabajadores Activos |
| w_rh900_asiento_planilla | RH900 | Asientos por Pagos de Remuneraciones CONSOLIDADO |
| w_rh901_cierra_planilla | RH901 | Cierre de Planilla calculada |
| w_rh901_cierra_planilla_bk | RH901 | Adiciona Movimiento de Cálculos a los Históricos |
| w_rh902_revierte_planilla | RH902 | Revierte cálculo de la planilla |
| w_rh903_subir_fotos | S/C | Subir fotos de trabajadores |
| w_rh905_envio_boletas_email | RH905 | Envío de Boletas por Email |
| w_rh907_transferencia_gratificaciones | RH907 | Transferencia de Gratificaciones |
| w_rh908_transferencia_vacaciones | RH908 | Transferencia de Vacaciones |
| w_rh909_transferencia_txt_afp | RH908 | Transferencia de Vacaciones |
| w_rh910_quincena_sin_cnta_ahorro | RH910 | C.E. de la Quincena del Personal Sin Cuenta de Ahorro |
| w_rh911_quinta_categoria | RH911 | Cuadro de Retenciones |
| w_rh912_subir_fotos | CN912 | Subir Fotos de Trabajadores |
| w_rh913_genera_doc_sunat | RH493 | Genera Documento para Impuestos |

---

## 8. Presupuesto

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_fl022_plant_nave_presup | FL022 | Asignación de plantillas presupuestales por nave |
| w_fl033_plant_presup | FL033 | Plantillas Presupuestales |
| w_fl521_variacion_grafica | FL521 | Variaciones del Presupuesto |
| w_fl907_grafica_ppto_var | FL907 | Variaciones Mensuales Flota |
| w_fl908_grafica_ppto_compos | FL908 | Variación por Partida Presupuestal (Flota) |
| w_fl909_generar_presupuesto | FL909 | Generación de Presupuesto de Flota |
| w_fl910_prspto_variacion | FL910 | Variaciones Presupuestales |
| w_fl911_generar_variaciones | FL911 | Generación de Variaciones |
| w_pt001_partida_titulos | S/C | Cuentas Presupuestales - Título |
| w_pt002_cnta_presupuestal | PT002 | Definición de Cuentas presupuestales |
| w_pt003_presupuesto_grupo | S/C | Grupos - Cuentas Presupuestales |
| w_pt004_presupuesto_plantilla | PT004 | Plantillas Presupuestales |
| w_pt005_numeracion | S/C | Numeradores |
| w_pt007_cnta_prsp_subcateg | PT007 | Cnta Prsp Vs Sub Categ |
| w_pt008_prsp_doc_tipo | PT008 | Modificar Flag Prsp en Doc Tipo |
| w_pt009_usuario_cencos | S/C | Usuarios Vs Centros Costo |
| w_pt010_presup_param | PT010 | Parámetros de Presupuesto |
| w_pt011_cencos_cnta_prsp | PT011 | Cencos - Cuenta Presupuestal |
| w_pt012_roles | PT012 | Roles para Presupuesto |
| w_pt013_usr_rol | S/C | Roles por Usuario |
| w_pt014_usr_cnta_prsp | S/C | Cencos - Cnta_prsp x Usuario |
| w_pt015_cnta_prsp_tipo_doc | PT015 | Cnta Prsp Vs Tipo Doc |
| w_pt016_fondo_var_aut | PT015 | Fondo Variaciones Automáticas |
| w_pt017_tipos_prtda_prsp | PT017 | Tipos de Partida Presupuestal |
| w_pt018_prsp_caja_seccion | PT018 | Secciones para Presupuesto de Caja |
| w_pt301_presupuesto_ingresos_und | PT301 | Presupuesto de ingresos - Plan de Venta |
| w_pt302_presupuesto_produccion_und | PT302 | Presupuesto producción |
| w_pt303_presupuesto_inicial | PT303 | Partidas presupuestales |
| w_pt304_presupuesto_variacion | PT304 | Variaciones Partida Presupuestal |
| w_pt305_proyectos | S/C | Proyectos |
| w_pt305_proyecto_frm | S/C | Formato de orden de compra |
| w_pt307_proyecto_pd | S/C | Parte Diario de proyectos |
| w_pt308_produccion_real | S/C | Producción Real |
| w_pt309_presup_ingresos_var | PT309 | Variaciones Presupuesto Ingresos |
| w_pt310_presup_produccion_var | PT310 | Variaciones Presupuesto Producción |
| w_pt311_solicitud_variacion | PT311 | Solicitud de Variaciones |
| w_pt312_aprob_sol_variacion | PT312 | Aprobación de Solicitudes de Variación |
| w_pt313_presupuesto_det | PT313 | Detalle del Presupuesto Inicial |
| w_pt313_pry_datos | PT313 | Proyecto - Datos |
| w_pt314_pry_fc | PT314 | Proyecto - Flujo Caja |
| w_pt315_pry_actividades | PT315 | Proyectos - Programación Actividades |
| w_pt316_factor_tipo_hora | PT316 | Tipos de Hora |
| w_pt317_proy_hrs_obrero | S/C | Proyectos Horas Obrero |
| w_pt318_proy_prec_art | PT318 | Precio Proyectado Artículo |
| w_pt319_add_edit_docs | PT319 | Ingresar los datos jalando de las facturas |
| w_pt319_add_edit_record | PT319 | Ingresar o Datos |
| w_pt319_copiar | PT319 | Ingresar o Datos |
| w_pt319_origen_datos | S/C | Origen de Datos |
| w_pt319_prsp_caja | PT319 | Presupuesto de Caja |
| w_pt501_saldos_resumen | PT501 | Resumen de saldos en dólares |
| w_pt501_variaciones_detalle | PT501 | Detalle de variaciones |
| w_pt502_prsp_produccion | PT502 | Presupuesto Producción |
| w_pt503_prsp_ingreso | PT503 | Presupuesto de Ingresos - Plan de Ventas |
| w_pt504_prsp_var_ots | PT721 | Control x Cuentas Presupuestales |
| w_pt505_errores_ots | PT505 | Reporte de Errores de Generación de Presupuesto |
| w_pt506_var_prsp_prod | PT506 | Variaciones Presupuesto Producción |
| w_pt507_var_prsp_ingr | PT507 | Variaciones Presupuesto Ingresos |
| w_pt508_prsp_prod_subcateg | PT508 | Presupuesto Producción x Subcategoría |
| w_pt509_prsp_ingr_subcateg | PT508 | Presupuesto Producción x Subcategoría |
| w_pt701_ppto_x_ccosto_anual | PT701 | Presupuesto por C.C. Anual |
| w_pt702_ppto_x_cnta_presup_anual | PT702 | Cuentas Presupuestales |
| w_pt703_control_presup_cc | PT703 | Cuentas Presupuestales |
| w_pt704_control_presup_cp | PT704 | Control x Cuentas Presupuestales |
| w_pt705_ejecucion | PT705 | Ejecución Presupuestal |
| w_pt706_ejecucion_anual | PT706 | Ejecución presupuestal - Anual |
| w_pt707_ejecucion_acum_cnta_prsp | PT707 | Ejecución Acumulada x cuenta presupuestal |
| w_pt708_variaciones | PT708 | Variaciones |
| w_pt709_gastos_x_ccosto | PT709 | Gastos x Centro de Costo |
| w_pt710_gastos_x_cnta_prsp | PT710 | Gastos x Cuenta Presupuestal |
| w_pt711_ppto_materiales | S/C | Presupuesto de materiales |
| w_pt712_rpt_presup_mat_x_ot_adm | PT712 | Presupuesto de materiales por administrador de OT |
| w_pt713_comparativo_cc_cp | S/C | Comparativos |
| w_pt714_comparativo_ccosto | PT714 | Comparativos |
| w_pt715_comparativo_cp | S/C | Comparativos |
| w_pt716_proyectos | PT716 | Maestro de Proyectos |
| w_pt717_centro_costo | PT717 | Centros de Costo |
| w_pt718_cuenta_presupuestal | PT718 | Cuentas Presupuestales |
| w_pt719_presupuesto_plantilla | PT719 | Plantillas Presupuestales |
| w_pt720_control_gastos_cp | PT720 | Control x Cuentas Presupuestales |
| w_pt721_control_gastos_x_grupo_cc | PT721 | Control x Cuentas Presupuestales |
| w_pt730_rpt_costos_cultivo | PT730 | Costos de Campos en Cultivo |
| w_pt731_rpt_costos_cosecha | PT731 | Costos de Campos en Cosecha |
| w_pt732_rpt_talleres_fabrica | PT732 | Costos de Talleres de Fábrica |
| w_pt733_rpt_talleres_maestranza | PT733 | Costos de Talleres de Maestranza |
| w_pt734_rpt_taller_electrico | PT734 | Costos del Taller Eléctrico |
| w_pt735_rpt_talleres_dma | PT735 | Costos de Talleres de D.M.A. |
| w_pt736_rpt_servicios_internos | PT736 | Costos de los Servicios Internos |
| w_pt737_rpt_tractor_rueda_240hp | PT737 | Costos por Horas del Tractor de Rueda 240HP |
| w_pt738_rpt_tractor_rueda_190hp | PT738 | Costos por Horas del Tractor de Rueda 190HP |
| w_pt739_rpt_tractor_rueda_140hp | PT739 | Costos por Horas del Tractor de Rueda 140HP |
| w_pt740_rpt_tractor_rueda_120hp | PT740 | Costos por Horas del Tractor de Rueda 120HP |
| w_pt741_rpt_tractor_rueda_100hp | PT741 | Costos por Horas del Tractor de Rueda 100HP |
| w_pt742_rpt_tractor_rueda_080hp | PT742 | Costos por Horas del Tractor de Rueda 080HP |
| w_pt743_rpt_tractor_rueda_d7 | PT743 | Costos por Horas del Tractor de Rueda D7 |
| w_pt744_rpt_tractor_rueda_d6 | PT744 | Costos por Horas del Tractor de Rueda D6 |
| w_pt745_rpt_tractor_rueda_d4 | PT745 | Costos por Horas del Tractor de Rueda D4 |
| w_pt746_rpt_cargador_966 | PT746 | Costos por Horas del Cargador Frontal 966 |
| w_pt747_rpt_cargador_920 | PT747 | Costos por Horas del Cargador Frontal 920 |
| w_pt748_rpt_calderos | PT748 | Costos por MBTU de los Calderos |
| w_pt749_rpt_electricidad | PT749 | Costos por KWH de Electricidad |
| w_pt750_rpt_automoviles | PT750 | Costos por Horas de los Automóviles |
| w_pt751_rpt_camionetas | PT751 | Costos por Horas de las Camionetas |
| w_pt752_rpt_volquetes | PT752 | Costos por Horas de los Volquetes |
| w_pt753_rpt_camiones | PT753 | Costos por Horas de los Camiones |
| w_pt754_rpt_alzadoras | PT754 | Costos por Horas de las Alzadoras |
| w_pt755_rpt_motoniveladora | PT755 | Costos por Horas de las Motoniveladoras |
| w_pt756_rpt_retroexcavadora | PT756 | Costos por Horas de las Retroexcavadoras |
| w_pt757_rpt_costos_cultivo_cencos | PT757 | Costos de Campos en Cultivo por Centro de Costo |
| w_pt758_rpt_presup_proy_x_ot_adm | PT758 | Presupuesto proyectado por administrador de OT |
| w_pt760_niveles_centro_costo | S/C | Cuentas Presupuestales |
| w_pt761_rpt_presup_mat_x_ot_adm | PTO701 | Presupuesto de materiales por administrador de OT |
| w_pt762_ejec_servicios | PT762 | Ejecución por Servicios |
| w_pt763_rpt_plant_presup | S/C | Plantillas presupuestales |
| w_pt764_control_prsp_cc_new | PT764 | Control Presupuestal |
| w_pt765_planilla | PT764 | Reporte de Planilla |
| w_pt765_planilla_det | PT764 | Reporte de Planilla |
| w_pt766_afectacion_x_usuario | PT766 | Afectación Presupuestal x Usuario |
| w_pt767_rpt_gantt | S/C | Diagrama de Gantt |
| w_pt768_rpt_cost_activ | S/C | Diagrama de Gantt |
| w_pt769_partida_presup_x_tipo | PT769 | Ejecución presupuestal - Anual |
| w_pt770_proy_prsp_produccion | PT770 | Reporte Proyectado Prsp Producción |
| w_pt771_partidas_presp_errores | PT771 | Errores en Partida Presupuestal |
| w_pt772_cxp_mal_presupuesto | PT772 | Cuentas x Pagar probablemente mal presupuestadas |
| w_pt773_prsp_ingr_var_frm | PT773 | Variaciones Plan de Ventas |
| w_pt774_compara_serv_art | PT766 | Afectación Presupuestal x Usuario |
| w_pt775_proy_material | PT775 | Proyecciones de Material de OTs |
| w_pt776_presup_operac_estim | PT775 | Proyecciones de Material de OTs |
| w_pt777_prsp_caja_vs_tesoreria | PT777 | Seguimiento de Presupuesto de Caja vs Tesorería |
| w_pt901_adiciona_mov_proy | PT901 | Adiciona mov. proyectados |
| w_pt902_valoriza_pto_detalle | PT902 | Valorización |
| w_pt903_articulos_no_valorizados | PT903 | Artículos no valorizados |
| w_pt904_genera_partidas_pto_mat | PT904 | Generación de partidas |
| w_pt905_adiciona_materiales | PT905 | Adiciona mov. proyectados |
| w_pt906_pto_produccion | PT906 | Generación de Presupuesto de Producción |
| w_pt907_proc_operaciones | PT907 | Presupuesto operaciones |
| w_pt908_aprueba_presupuesto | PT908 | Aprobación del Presupuesto |
| w_pt909_ajuste_pto_fabrica | S/C | Ajuste |
| w_pt910_regenera_pto_ejec | PT910 | Regenera presupuesto ejecutado |
| w_pt911_aprueba_partida_prsp | PT911 | Aprobación de partida presupuestal |
| w_pt912_genera_variacion_ot | PT912 | Genera Variación Presup OT |
| w_pt913_genera_prsp_ot | PT913 | Generación de Presupuesto (Orden Trabajo) |
| w_pt914_gen_var_prsp_prod | PT914 | Generación de Variación de Prsp Prod |
| w_pt915_gen_prsp_ingresos | PT915 | Generación de Presupuesto de Ingresos |
| w_pt916_gen_var_prsp_ingr | PT916 | Generación de Variación Presupuesto - Plan de Ventas |
| w_pt917_regen_presup_variacion | PT917 | Regenera Variación Presupuesto Partida |
| w_pt918_regen_prsp_prod_ejec | PT918 | Regenera Ejecutado Prsp Producción |
| w_pt919_regen_prsp_ingr_ejec | PT919 | Regenera Ejecutado Prsp Ingresos |
| w_pt920_act_ejec_os | PT920 | Regenera Ejecutado de Órdenes de Servicio |
| w_pt921_act_presupuesto_det | PT921 | Regenera Monto de Presupuesto Det |
| w_pt922_genera_prsp_obreros | PT922 | Generación de Presupuesto de Obreros |
| w_pt923_regenera_pto_part_x_det | PT923 | Regenera presupuesto partida en función de presupuesto detalle |
| w_rh459_p_presupuesto_anual | RH459 | Generación de Presupuesto Anual de Planilla |

---

## 9. Producción

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_accion_enrolamiento | S/C | Opciones para enrolamiento |
| w_ap500_base | S/C | Captura de pesca |
| w_ap501_base_det | S/C | Base detalle |
| w_asi705_carnet_identifica | RH621 | Reporte de Promedio General de las Evaluaciones |
| w_cm314_orden_servicio_frm | CM314 | Formato de orden de Servicio |
| w_com709_documentos_cuenta | Com709 | Comprobantes de pago |
| w_com711_confin_cp_071 | Com711 | Documentos Provisionados |
| w_pr002_objeto | PR002 | Objetos para Control de Mediciones por Gráfico |
| w_pr003_grupo_atributo | PR003 | Grupos de Atributos de Medición |
| w_pr004_atrib_med | PR004 | Atributos de Medición |
| w_pr005_formatos_med | PR005 | Formatos de Medición |
| w_pr005_tg_formato_medir | PR005 | Formatos de Medición |
| w_pr006_tipo_asistencia | PR006 | Tipos de Asistencia |
| w_pr007_incidencias | PR007 | Maestro de incidencias |
| w_pr008_incidencias_clase | PR008 | Clase de incidencias |
| w_pr009_incidencias_ot_adm | PR009 | Incidencias por OT_ADM |
| w_pr010_estado_producto | PR010 | Estados del Producto |
| w_pr011_tg_plantas | PR011 | Plantas de Producción |
| w_pr012_tipo_formato | PR012 | Tipos de Formato de medición |
| w_pr013_aprob_parte_piso | PR013 | Aprobadores de Partes de Piso y Formatos de Medición |
| w_pr014_tipo_producto | PR014 | Productos |
| w_pr015_certificado_servicio | PR015 | Servicios del Certificado |
| w_pr016_prod_ener_param | PR016 | Parámetros Generales de Energía |
| w_pr017_prod_ener_recibo | PR017 | Ingreso de Recibos de Energía |
| w_pr018_prod_plant_costo_labor | PR018 | Costos Labor |
| w_pr019_prod_plant_ot_adm | PR019 | Plantilla de Costos OT_ADM |
| w_pr020_prod_grupo_beneficio | PR020 | Maestro de Centros de Beneficio |
| w_pr021_plantilla_costo | PR021 | Plantilla de Costo |
| w_pr021_prod_costos_titulos | PR021 | Costos Títulos |
| w_pr022_prod_grupos_cen_ben | PR022 | Grupos de Centro Beneficio |
| w_pr023_costos_diarios_prod | PR023 | Costos de Producción |
| w_pr024_fondo_transporte | PR024 | Fondo de Transporte |
| w_pr025_ususarios_por_centro_ben | PR025 | Usuarios por Centro de Beneficio |
| w_pr026_estruct_cebe | PR026 | Estructuras de Centro de Beneficio |
| w_pr027_tipo_prenda | PR027 | Tipo de Prenda |
| w_pr028_his_max_demanda | PR318 | Histórico de Máximas Demandas |
| w_pr029_estructura_centro_benef | PR029 | Estructura de Centros de Beneficio |
| w_pr030_param_produccion | PR030 | Parámetros Producción |
| w_pr031_param_asistencia | PR031 | Parámetros de Asistencia |
| w_pr032_procesos_produccion | PR032 | Procesos de Producción |
| w_pr033_tarifas_venta_pptt | PR033 | Tarifas de Venta de Producto Terminado |
| w_pr034_supervisor_campo | PR034 | Supervisor vs Cosechadores |
| w_pr035_selecc_superv_pesad | PR035 | Seleccionadora, Supervisora y Pesadora |
| w_pr036_ot_usuario_prod | PR036 | OT_ADM por usuario - Producción |
| w_pr037_presentaciones | PR037 | Presentaciones del producto |
| w_pr038_tareas | PR038 | Tareas de Producción |
| w_pr039_tarifario | PR039 | Tarifario de Cortes por Especie |
| w_pr040_turnos | PR040 | Turnos / Horarios |
| w_pr041_cuadrillas | PR041 | Cuadrillas de Trabajadores |
| w_pr042_procesos | PR042 | Procesos de Producción |
| w_pr043_especies | PR043 | Especies para producción |
| w_pr044_tratamientos_quimicos | PR044 | Tratamientos Químicos PPTT |
| w_pr045_tuneles_frio | PR045 | Túneles de Frío |
| w_pr046_lugar_empaque | PR046 | Lugares de empaque |
| w_pr047_enrolamiento | PR047 | Registro y enrolamiento de tarjetas |
| w_pr048_alm_apertura_diario | PR048 | Almacén apertura diaria |
| w_pr301_calidad_prodfin | PR301 | Calidad del Producto Terminado |
| w_pr302_parte_diario_destajo | PR302 | Control de destajos |
| w_pr303_parte_piso | PR303 | Parte de piso |
| w_pr304_parte_diario | PR304 | Parte Diario de Producción |
| w_pr305_control_calidad | PR305 | Control de Calidad de Productos Terminados |
| w_pr309_control_uso | PR309 | Parte de piso |
| w_pr310_asistencia_jornal | PR310 | Asistencia de Jornales |
| w_pr311_lecturas_grafico | PR311 | Lecturas de Partes de Piso - Modo Gráfico |
| w_pr312_parte_piso_quick_new | PR312 | Registro de Partes de Piso |
| w_pr312_parte_piso_quick | PR312 | Registro de Lecturas Por Parte de Piso |
| w_pr313_certificado_planta | PR313 | Certificados de Planta |
| w_pr314_firma_partes | PR314 | Firma de Partes de Piso |
| w_pr315_programa_produccion | PR315 | Programa de producción |
| w_pr316_produccion_final | PR316 | Producción Final |
| w_pr317_produccion_final | PR317 | Producción Final |
| w_pr318_his_max_demanda | PR318 | Histórico de Máximas Demandas |
| w_pr319_distribucion_ener | PR319 | Distribución de Energía |
| w_pr320_consumo_energia | PR320 | Consumo de Energía |
| w_pr321_costos_titulos | PR321 | Costos Títulos |
| w_pr322_plant_costos_art | PR322 | Plantilla de Costo de Artículo |
| w_pr323_transporte_personal | PR323 | Registro de Transporte |
| w_pr324_destajo_masivo | PR324 | Parte de Destajo Masivo |
| w_pr325_lavado_ropa | PR325 | Partes de Lavado de Ropa |
| w_pr326_parte_produccion_rpt | PR326 | Impresión Parte de Recepción de Materia Prima |
| w_pr326_parte_produccion | PR326 | Partes de Producción |
| w_pr327_parte_jornal_campo | PR327 | Parte Jornaleros de Campo |
| w_pr328_parte_detajo_masivo | PR328 | Parte de Destajo Masivo |
| w_pr329_parte_empaque | PR329 | Parte de Empaque - Producción |
| w_pr330_parte_recepcion | PR330 | Parte de Recepción - Producción |
| w_pr331_parte_transferencia | PR331 | Parte de Transferencia - Producción |
| w_pr332_parte_recepcion_popup | PR332 | Parte Recepción |
| w_pr333_parte_transferencia_popup | PR333 | Parte de Transferencia |
| w_pr334_proyecto_destajo | PR334 | Destajo usando balanza |
| w_pr335_parte_envasado | PR335 | Parte de Envasado - Producción |
| w_pr336_parte_conservas | PR336 | Parte de Empaque Conserva - Producción |
| w_pr337_parte_conservas_popup | PR337 | Parte de Empaque Conserva - Producción |
| w_pr338_empaque_destajo | PR338 | Generación Partes Empaque - Destajo |
| w_pr339_recepcion_fileteo | PR339 | Generación Partes Recepción - Fileteo |
| w_pr340_recepcion_recepcion | PR340 | Generación Partes Recepción - Recepción Destajo |
| w_pr341_envasado_lavado | PR341 | Generación Partes Envasado - Lavado |
| w_pr500_base | PR500 | Captura de pesca |
| w_pr500_prod_fin | PR500 | Producción Por Día |
| w_pr501_atrib_prod_final_new | PR501 | Reporte de Producción Por Rango de Fechas |
| w_pr501_atrib_prod_final | PR501 | Atributos del Producto |
| w_pr501_base_det | S/C | Base detalle |
| w_pr502_lectura_parte | PR502 | Lecturas por Parte de Piso |
| w_pr503_maquina_dia_uso | PR503 | Eficiencia por Equipo |
| w_pr504_destajo_consistencia | PR504 | Consistencia de Destajo |
| w_pr505_destajo_consistencia_trab_new | PR505 | Consistencia de Destajo por Trabajador |
| w_pr505_destajo_consistencia_trab | PR505 | Consistencia de Destajo por Trabajador |
| w_pr507_duracion_certificado | PR507 | Duración del Certificado de Calidad |
| w_pr508_consulta_destajo | PR508 | Consultas Parte de Destajo |
| w_pr509_ingresos_produccion | PR509 | Consulta Producción Anual |
| w_pr510_consumos_mp | PR510 | Consumo Materia Prima |
| w_pr511_adquisicion_mp | PR511 | Adquisiciones de la materia prima |
| w_pr700_parte_piso | PR700 | Parte de Piso |
| w_pr701_mediciones_grf | PR701 | Comportamiento de las mediciones por parte de piso |
| w_pr702_costo_ot_x_labor | PR702 | Costo Orden Trabajo X Labor - Ejecutor |
| w_pr703_costo_ot_estandar | PR703 | Costo Orden Trabajo X Estándar |
| w_pr704_asist_dest_pd_ot | PR704 | Personal Destajo x Parte Diario |
| w_pr705_trab_jornal_pd_ot | PR705 | Mano Obra Jornal |
| w_pr706_insumos_pd_ot | PR706 | Insumos por Parte Diario |
| w_pr707_full_pd_ot | PR707 | Parte Diario de Producción - OT |
| w_pr708_prod_fin | PR708 | Producción Por Fechas |
| w_pr709_asistencia_fechas | PR709 | Asistencia de Jornaleros por periodo |
| w_pr710_parte_piso | PR710 | Parte de Piso |
| w_pr711_asist_destajo_fechas | PR711 | Asistencia Personal de Destajo |
| w_pr711_parte_horas | PR711 | Control de tiempos |
| w_pr712_insumos_fechas_tbl | PR712 | Relación de Insumos |
| w_pr712_insumos_fechas | PR712 | Insumos Consumidos |
| w_pr713_comp_insumos_x_ot | PR713 | Costo Orden Trabajo X Labor - Ejecutor |
| w_pr714_costo_ot | PR714 | Costo Orden Trabajo X Operaciones |
| w_pr715_horas_x_trabaajdor | PR715 | Resumen de Horas x Trabajador |
| w_pr716_produccion_por_fechas | PR716 | Producción por fechas |
| w_pr717_certificados_de_calidad | PR717 | Certificados de Calidad |
| w_pr718_partes_de_piso | PR718 | Partes de Piso |
| w_pr719_formato_medicion | PR719 | Partes de Piso |
| w_pr720_costo_produccion | PR720 | Costo de Producción |
| w_pr721_dias_laborados | PR721 | Reporte de Días Laborados |
| w_pr722_comparacion_costos | PR722 | Comparación de Costos - Gráfico |
| w_pr723_costo_trans_cencos | PR723 | Reporte de Costo de Transporte |
| w_pr724_costo_trans_os | PR724 | Resumen de OS de Transporte |
| w_pr725_cuadro_integral | PR725 | Cuadro Gerencial |
| w_pr726_insumos_pptt | PR726 | Insumos por Línea de Producto (US$) |
| w_pr727_reporte_de_asistencia | PR727 | Reporte de Asistencias |
| w_pr728_reporte_detalle_lav_os | COM708 | Resumen de Raciones Por Comprobante |
| w_pr729_centros_benefico_tbl | PR729 | Centros de Beneficio |
| w_pr730_cencos_por_cenbenef_tbl | PR730 | Relación Cencos / CenBenef |
| w_pr731_cenbenef_sin_cencos | PR731 | Cencos Sin CentBenef / CenBenef sin Cencos |
| w_pr732_genera_contrato | PR406 | Genera contrato |
| w_pr733_control_de_procesos | PR733 | Control de Procesos |
| w_pr734_estructura_de_centro_benef | PR734 | Estructura de Centros de Beneficio |
| w_pr735_jornal_hrs_det | PR735 | Resumen de Horas Trabajadas |
| w_pr736_horas_jornal_campo | PR736 | Resumen de Horas Trabajadas |
| w_pr737_etiquetas | PR737 | Etiquetas para producción |
| w_pr738_etiquetas_campo | PR737 | Etiquetas para producción |
| w_pr739_etiquetas_jabas | PR739 | Etiquetas para Jabas de Campo |
| w_pr740_etiquetas_cajas | PR740 | Etiquetas para Cajas de Productos Terminados |
| w_pr741_etiquetas_packing | PR741 | Etiquetas para Seleccionadoras de Packing |
| w_pr742_imp_jornal_anual | PR742 | Importe Jornal Anual |
| w_pr743_importe_labor_lote | PR743 | Resumen por Labor y Lote |
| w_pr744_total_x_tareas | PR744 | Total x Tareas de Destajo |
| w_pr745_detalle_prod | PR745 | Detalle Producción Destajo y Jornal |
| w_pr746_total_horas | PR746 | Total x Horas (destajo) |
| w_pr747_reporte_personal_cuenta | PR740 | Etiquetas para Cajas de Productos Terminados |
| w_pr748_costos_empacadora | PR748 | Costos x Empacadora |
| w_pr749_costo_prod_ot | PR749 | Costo de Producción x OT |
| w_pr750_resumen_cuadrilla | PR750 | Resumen x Cuadrilla |
| w_pr751_destajo_tipo_trabaj | PR751 | Total Destajo por Tipo de Trabajador |
| w_pr752_prod_jornal_destajo | PR752 | Resumen Valorizado de productos por Tarea |
| w_pr753_total_jornal | PR753 | Resumen Valorizado Parte Jornal |
| w_pr754_resumen_diario | PR754 | Total Resumen Diario Jornal y Destajo |
| w_pr755_empaque_vs_recepcion | PR755 | Cantidad de Empaque vs Recepción |
| w_pr756_resumen_pptt | PR756 | Resumen de productos terminados |
| w_pr757_empaque_sala_turno | PR757 | Parte de Empaque por Sala y Turno |
| w_pr758_resumen_diario_destajo | PR758 | Reporte resumen de Fileteo Destajo |
| w_pr759_resumen_envasado | PR759 | Resumen de envasado |
| w_pr760_datos_produccion_hp | PR760 | Datos Producción HP - Dashboard |
| w_pr777_ratios_x_empacadora | PR777 | Ratios de Producción por Empacadora |
| w_pr900_genera_ot | PR900 | Generación de Orden de Trabajo |
| w_pr902_genera_os | PR902 | Genera OS de Transporte |
| w_pr903_guardar_costos | PR903 | Guardar Costos Diarios |
| w_pr904_act_unds_producidas | PR904 | Actualizar Unidades Producidas |
| w_pr905_anula_os_trans | PR905 | Anular Orden de Servicio |
| w_pr906_asiento_contable_transporte | PR906 | Generar Asiento Contable |
| w_pr907_precio_venta_x_art | PR907 | Guardar Precios de Venta x Artículo |
| w_pr908_costos_x_cebe | PR908 | Guarda Costos Diarios x CeBe |
| w_pr909_anular_os_lavado | COM904 | Anular Orden de Servicio |
| w_pr910_genera_os_lavado | COM903 | Generar Orden de Servicio |
| w_pr911_actualiza_cebe_vales | PR911 | Actualiza CeBe del Movimiento del Almacén |
| w_pr912_actualiza_cebe_os | PR912 | Actualiza Centro Beneficio Según OperSec |
| w_pr913_asiento_contable | COM902 | Generar Asiento Contable |
| w_pr914_imp_file_packing | PR914 | Importar Archivo de Producción Packing |
| w_pr915_valor_mensual | PR915 | Valorización PPTT Mensual |
| w_pr916_imp_asistencia | PR916 | Importar asistencia Jornal de Campo |
| w_pr917_valorizar_produccion | PR917 | Valorización de Ingreso por producción por Grupo Contable |
| w_pr918_importar_costos_ot | PR918 | Valorización por Orden de Trabajo |
| w_pr919_imp_destajo | PR919 | Importar Destajo Masivo por Excel |

---

## 10. Operaciones OT

*(Pendiente de análisis detallado)*

---

## 11. Mantenimiento

*(Pendiente de análisis detallado)*

---

## 12. Aprovisionamiento

*(Pendiente de análisis detallado)*

---

## 13. Asistencia

*(Pendiente de análisis detallado)*

---

## 14. Auditoría

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_aud301_cambio_fechas | AUD301 | Cambio de fecha |
| w_aud701_anticipos | AUD701 | Control de anticipos de compras o servicios |
| w_aud702_corr_ingresos_pptt | AUD702 | Correlativo de Productos Terminados |
| w_aud703_corr_salidas_pptt | AUD703 | Correlativo de Productos Terminados |
| w_aud704_detalle_saldos_cta_cte | AUD704 | Detalle de Saldos de Cuenta Corriente |
| w_aud705_doc_pendientes | AUD705 | Documentos Pendientes de Cobranza por Antigüedad |
| w_aud706_ingresos_pptt | AUD706 | Detalle de Productos Terminados |
| w_aud707_orden_compra | AUD707 | Control de Compras |
| w_aud708_resumen_pptt | AUD708 | Resumen de Productos Terminados |
| w_aud709_saldos_cta_cte | AUD709 | Reporte de Saldos de Cuenta Corriente |
| w_aud710_salidas_almacen | AUD710 | Control de Salidas del Almacén |
| w_aud711_salidas_pptt | AUD711 | Detalle de Productos Terminados |
| w_aud712_guias_sin_facturar | AUD712 | Guías de remisión sin facturar |
| w_aud713_mov_almacen_cebe | AUD713 | Movimientos de Almacén/CeBe |
| w_aud714_orden_servicio_cebe | AUD714 | Órdenes de Servicio/CeBe |
| w_aud715_facturas_prov_sin_ref_cebe | AUD715 | Facturas Provisionadas |
| w_aud716_doc_por_pagar_directo_cebe | AUD716 | Documentos Por Pagar Directos |
| w_aud717_doc_por_cobrar_cebe | AUD717 | Documentos Por Cobrar |
| w_aud718_trazabilidad_articulo | AUD718 | Trazabilidad de artículo |

---

## 15. BASC

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_ba100_articulos_basc | BA100 | Artículos controlados por BASC |
| w_ba101_tipo_remolque | BA101 | Tipo de Remolque |
| w_ba102_motivo_ingreso_salida | BA102 | Motivo Ingreso y Salida |
| w_ba103_maestro_personas | BA103 | Maestro de Personas |
| w_ba104_maestro_vehiculos | BA104 | Maestro de Vehículos |
| w_ba105_maestro_proveedor | BA105 | Maestro de Proveedores |
| w_ba106_puertas_ingreso_salida | BA106 | Puertas de Ingreso y Salida |
| w_ba300_ingreso_personal_externo | BA300 | Control de Ingreso de Visitantes |
| w_ba301_ingreso_vehicular | BA301 | Ingreso Vehicular |
| w_ba301_ingreso_vehicular_ficha | BA301 | Ficha de Control de Vehículos |
| w_ba700_articulos_controlados | BA700 | Movimientos de Artículos Controlados |
| w_ba701_listado_maestro_llaves | BA701 | Listado Maestro de Llaves |
| w_ba702_ingreso_salida_personal_externo | BA702 | Control de Ingreso y Salida de Visitantes |
| w_ba703_ingreso_salida_trabajadores | BA703 | Control de Ingreso y Salida del Personal |
| w_ba704_ingreso_salida_vehiculo_carga | BA704 | Control de Ingreso y Salida de Vehículos |
| w_ba705_control_vehiculo_carga_ficha | BA705 | Ficha de Control de Vehículos de Carga |

---

## 16. Campo

*(Pendiente de análisis detallado)*

---

## 17. CashLoan

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cas001_asesor_financiero | CAS001 | Asesores Financieros |
| w_cm001_proveedor_tipo | CM101 | Tipo de proveedores |
| w_cm002_proveedor_ficha | CM002 | Ficha de Proveedor |
| w_cm002_proveedor_ficha_visita | CM002 | Formato de Visitas |
| w_cm003_proveedor_articulo | CM003 | Proveedores Calificados |
| w_cm017_grupo_proveedor | CM017 | Grupo de proveedores |
| w_ve027_zonas_venta | VE027 | Zonas de Venta |

---

## 18. Comedor

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_com001_zona_proceso | Com001 | Zonas de Proceso |
| w_com002_tipo_com | COM002 | Tipo de Comedores |
| w_com003_num_parte_rac | COM003 | Numerador de Parte de Ración |
| w_com004_num_parte_costo | COM004 | Numerador de Parte de Costo |
| w_com005_parametros | COM005 | Parámetros Iniciales |
| w_com006_prsp_fonfo | COM006 | Fondo de Comedores |
| w_com007_ratio_base_proveedor | COM007 | Distribución de Ratios por proveedor |
| w_com300_parte_raciones | COM300 | Parte de Raciones Comedor |
| w_com301_parte_costo | COM301 | Parte de Costos |
| w_com700_costo_ot | Comedores | Costo Orden Trabajo - Detallado |
| w_com701_costo_ot_resumen | Comedores | Costo Orden Trabajo - Resumen |
| w_com702_raciones_fechas | COM702 | Raciones Brindadas |
| w_com703_costo_fechas | COM703 | Costo x Raciones |
| w_com704_raciones_zonas | COM704 | Facturas de Comedores |
| w_com705_resumen_partes | COM705 | Raciones por Partes de Raciones |
| w_com706_parte_raciones | COM706 | Parte de Raciones |
| w_com707_raciones_origen | COM707 | Parte Raciones |
| w_com708_resumen_ratio | COM708 | Resumen de Raciones Por Comprobante |
| w_com709_documentos_cuenta | COM709 | Comprobantes de pago |
| w_com710_doc_mala_cuenta | COM710 | Comprobantes con otra Cuenta |
| w_com711_confin_cp_071 | COM711 | Documentos Provisionados |
| w_com712_mal_asiento_rpt | COM712 | Diferencias Documento vs Asiento |
| w_com713_conciliacion_pvsf_rpt | COM713 | Facturas por Fechas |
| w_com714_costo_por_parte | COM714 | Costo de Parte de Ración |
| w_com900_prorratear_costo | COM900 | Prorrateo de Costos |
| w_com901_generar_ot_com | AP900 | Generar Orden Trabajo |
| w_com902_asiento_contable | COM902 | Generar Asiento Contable |
| w_com903_genera_os | COM903 | Generar Orden de Servicio |
| w_com904_anular_os | COM904 | Anular Orden de Servicio |

---

## 19. Consola Web

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cw001_empresas | CW001 | Registrar Empresa |
| w_cw002_usuario_housing | CW002 | Usuario Housing |
| w_cw003_equipos_empresa | CW003 | Equipo |
| w_cw004_cuotas | CW004 | Cuota |
| w_cw005_pago_cuota | CW005 | Pagar Cuota |
| w_cw006_contacto_empresa | CW006 | Contacto |
| w_cw007_usuarios | CW007 | Usuario |
| w_cw008_venc_renta | CW008 | Cronograma Renta |
| w_cw009_versiones | CW009 | Versión |
| w_cw010_modulos | CW010 | Módulo |
| w_cw300_modulo_empresa | CW300 | Asignar módulos a empresa |
| w_cw301_empresa_version | CW301 | Asignar versión a empresa |
| w_cw302_versiones_modulo | CW302 | Asignar módulos a versión |
| w_cw500_empresas_autorizadas | CW500 | Empresas autorizadas |
| w_cw501_contactos | CW501 | Contactos |
| w_cw502_modulos | CW502 | Módulos |

---

## 20. Control de Documentos

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cd001_usuario_seccion | CD001 | Usuarios Recepcionistas |
| w_cd301_registro_documentos | CD301 | Registro de Documentos |
| w_cd303_acepta_transf_doc | CD303 | Aceptación de documentos transferidos |
| w_cd304_remesa | CD304 | Emite Remesa |
| w_cd305_aceptar_remesa | CD305 | Aceptar remesa |
| w_cd501_consulta_documento | CD501 | Consulta por Documento |
| w_cd502_consulta_fecha | CD502 | Consulta de documentos por fecha |
| w_cd701_doc_transfer | CD701 | Formato de documentos transferidos |
| w_cd702_doc_sin_prov | CD702 | Documentos sin Provisionar |
| w_cd704_rpt_doc_transferidos | CD704 | Documentos Transferidos |
| w_cd705_rpt_doc_proveedor | CD705 | Documentos por Proveedor |
| w_cd706_dev_proveedor | CD706 | Devolución al proveedor |
| w_cd707_rpt_doc_sin_provision | CD707 | Documentos sin provisionar |
| w_cd708_doc_transf_sin_aceptar | CD708 | Documentos transferidos sin aceptar |
| w_cd801_cerrar_documentos | CD801 | Cerrar Documentos |

---

## 21. Flota

*(Pendiente de análisis detallado)*

---

## 22. Seguridad

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_sg001_configuracion | SG001 | Tabla de configuración |
| w_sg010_usuario | SG010 | Mantenimiento de Usuarios |
| w_sg020_grupo | SG020 | Mantenimiento de Roles |
| w_sg030_objetos | SG030 | Mantenimiento de Objetos |
| w_sg040_sistema_aplicativo | SG040 | Sistema Aplicativo |
| w_sg050_nivel_cord | SG050 | Mantenimiento de Nivel Coord |
| w_sg060_obj_usu | SG060 | Mantenimiento de Usuarios por Objetos |
| w_sg5010_grp_obj | SG5010 | Objetos Asignados x Rol |
| w_sg5020_usr_obj | SG5020 | Objetos Asignados x Usuario |
| w_sg520_tabla_modificaciones | SG520 | Modificaciones a Tablas |
| w_sg530_oper_procesos | SG530 | Procesos Realizados |
| w_sg540_objeto_accesos | SG540 | Acceso a Objetos |
| w_sg542_objeto_accesos_usr | SG542 | Acceso a Objetos por Usuario |
| w_sg700_usr_grp_obj | SG700 | Accesos x Usuario |
| w_sg710_grp_obj | SG710 | Accesos x Grupo |
| w_sg720_obj_us | SG720 | Accesos x Objeto |
| w_sg730_roles_superpuestos | SG730 | Roles super-puestos |
| w_sg745_usr_x_ventana | SG745 | Accesos x Ventana |
| w_sg900_log_diario_limpieza | SG900 | Log Diario - Limpieza |
| w_sg910_log_objeto_limpieza | SG910 | Log Objeto - Limpieza |
| w_sig790_acceso_usuarios | SIG790 | Accesos de Usuarios a los Sistemas |

---

## Resumen por Módulo

| # | Módulo | Ventanas |
|---|--------|----------|
| 1 | Activo Fijo | 31 |
| 2 | Almacén | 162 |
| 3 | Compras | 164 |
| 4 | Comercialización / Ventas | 156 |
| 5 | Contabilidad | 286 |
| 6 | Finanzas | pendiente |
| 7 | RRHH | 283 |
| 8 | Presupuesto | 156 |
| 9 | Producción | 195 |
| 10 | Operaciones OT | pendiente |
| 11 | Mantenimiento | pendiente |
| 12 | Aprovisionamiento | pendiente |
| 13 | Asistencia | pendiente |
| 14 | Auditoría | 19 |
| 15 | BASC | 16 |
| 16 | Campo | pendiente |
| 17 | CashLoan | 7 |
| 18 | Comedor | 29 |
| 19 | Consola Web | 16 |
| 20 | Control de Documentos | 15 |
| 21 | Flota | pendiente |
| 22 | Seguridad | 21 |
| | **TOTAL (parcial)** | **~1,556** |

---

*Documento generado el 08/02/2026*
*Se excluyen ventanas genéricas del framework: w_abc_*, w_logon, w_main, w_about, w_fondo, w_search*, w_help_*, w_pop_*, w_rpt_preview*, w_seleccion*, w_filtros, w_get_*, w_datos_*, w_password_chg, etc.*
*Los módulos marcados como "pendiente" aún no han sido analizados en detalle.*
