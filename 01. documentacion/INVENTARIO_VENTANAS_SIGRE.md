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


---

## 4. Comercialización / Ventas

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_fi301_notas_ventas_x_cobrar_frm | FI343 | Liquidación Semanal |
| w_fl003_capit_puerto | FL003 | Capitanías de Puerto |
| w_fl013_puertos | FL013 | Mantenimiento de puertos |
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
---

## 6. Finanzas

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_fi001_puntos_venta | FI001 | Puntos de venta |
| w_fi002_tipo_impuesto | FI002 | Tipo de impuesto |
| w_fi003_credito_fiscal | FI003 | Crédito fiscal |
| w_fi004_grupo_financiero | FI004 | Grupo financiero |
| w_fi005_matriz_contable | FI005 | Matriz contable |
| w_fi006_concepto_financiero | FI006 | Concepto financiero |
| w_fi006_concepto_financiero_lista | FI006 | Maestro de conceptos financieros |
| w_fi008_flujo_caja_grupos | FI008 | Flujo de caja - Grupos |
| w_fi009_flujo_caja_concepto | FI009 | Flujo de caja - Concepto |
| w_fi010_bancos | FI010 | Bancos |
| w_fi011_cuentas_bancos | FI011 | Cuentas de banco |
| w_fi012_personas_autoriz | FI012 | Personas autorizadas a aprobar adelantos |
| w_fi013_param_autoriz | FI013 | Autorizados a generar adelantos |
| w_fi014_tasa_interes | FI014 | Tasa de interés |
| w_fi015_parametros_finanzas | FI015 | Parámetros de financiamiento |
| w_fi016_grupo_relacion | FI016 | Grupo de relación |
| w_fi017_grupo_articulo | FI016 | Grupo de artículo |
| w_fi018_grupo_libros | FI016 | Grupo de libro |
| w_fi021_abc_saldo_bancario | FI021 | Saldos mensuales de cuenta de banco |
| w_fi022_forma_pago | FI022 | Formas de pago |
| w_fi023_factura_rubro | FI023 | Rubros de documentos |
| w_fi024_detraciones_bienes_serv_tbl | FI024 | Bienes y servicios detracción |
| w_fi025_detraciones_operaciones_tbl | FI025 | Operaciones detracción |
| w_fi026_tipo_deuda_financiera | FI026 | Tipos de deuda financiera |
| w_fi027_concepto_deuda | FI027 | Conceptos de deuda financiera |
| w_fi028_monto_cta_cte | FI028 | Límites de cuenta corriente x cliente |
| w_fi029_motivo_nota | FI029 | Motivos de notas de crédito/débito |
| w_fi030_documentos_usuarios | FI030 | Documentos por usuario |
| w_fi031_documentos_grupo | FI031 | Grupos y relación con tipos de documentos |
| w_fi032_documentos_tipo | FI032 | Tipo de documentos |
| w_fi033_documentos_numeracion | FI033 | Numeración de documentos |
| w_fi034_flujo_proveedor | FI034 | Código de flujo de caja vs proveedor |
| w_fi035_sunat_tabla10 | FI035 | Documentos de SUNAT (Tabla 10) |
| w_fi036_medios_pago | FI036 | Medios de pago |
| w_fi037_bancos_ov | FI037 | Bancos para órdenes de venta |
| w_fi302_warrant | FI302 | Warrant |
| w_fi303_letras_x_cobrar_renovacion | FI303 | Renovación de letras x cobrar |
| w_fi304_cnts_x_pagar | FI304 | Registro de cuentas x pagar |
| w_fi305_letras_x_pagar_canje | FI305 | Canje de documentos x pagar |
| w_fi307_genera_solicitud_giro | FI307 | Solicitud de giro |
| w_fi308_aprobacion_sg | FI308 | Solicitud de adelanto |
| w_fi309_cartera_de_cobros | FI309 | Cartera de cobros |
| w_fi310_cartera_de_pagos | FI310 | Cartera de pagos |
| w_fi310_choice_prsp_caja | FI310 | Elegir presupuesto de caja |
| w_fi312_transferencias | FI312 | Transferencias |
| w_fi318_financiamiento | FI318 | Financiamiento |
| w_fi320_nota_debito_credito | FI320 | Nota de débito / crédito |
| w_fi323_pre_liq_og_rpt | S/C | Liquidación de orden de giro (reporte) |
| w_fi323_pre_liquidacion_og_ff | FI323 | Liquidación fondo fijo / orden de giro |
| w_fi324_cierra_liquidacion_og | FI324 | Cierre de liquidación de solicitud de adelanto |
| w_fi324_rpt_asiento_liq | FI324 | Reporte de asiento contable de liquidación |
| w_fi325_aproba_prov_simpl | FI325 | Aprobación de facturación simplificada |
| w_fi326_aplicacion_documentos | FI326 | Aplicación de documentos |
| w_fi329_pagar_directo | FI329 | Documentos pagar directo |
| w_fi331_eliminacion_cri | FI331 | Eliminar comprobante de retención de IGV |
| w_fi331_generacion_cheques_masivos | FI331 | Generación de cheques masivos |
| w_fi333_cierra_liquidacion_og_devolucion | FI333 | Devolución orden de giro |
| w_fi334_lista_detraccion | FI334 | Detracción |
| w_fi337_letras_x_cobrar_canje | FI337 | Canje / renovación de letras por cobrar |
| w_fi338_cntas_cobrar_directo | FI338 | Cuentas x cobrar directo |
| w_fi343_liquidacion_caja | FI343 | Liquidación de caja |
| w_fi343_liquidacion_caja_frm | FI343 | Liquidación semanal |
| w_fi347_conciliacion | FI347 | Conciliación bancaria |
| w_fi348_conciliacion_automatic | FI348 | Conciliación automática |
| w_fi349_conciliacion_no_registrado | FI349 | Conciliación de documentos no registrado |
| w_fi350_detraccion_ope_bien_serv | S/C | Datos de detracción |
| w_fi351_conciliacion_no_registrado | FI351 | Eliminación de conciliación no registrado |
| w_fi352_change_number | FI352 | Cambiar número de documento |
| w_fi353_provision_simplificada | FI353 | Provisión simplificada cuentas x pagar |
| w_fi355_cambia_fec | FI355 | Cambio de fecha de presentación |
| w_fi356_programacion_pagos | FI356 | Programación de pagos |
| w_fi357_cheques_x_venc | FI357 | Cheques diferidos |
| w_fi358_cntas_pagar_sin_control | FI358 | Proveedores sin control |
| w_fi359_cntas_pagar_conciliar_provision | FI359 | Conciliación facturación |
| w_fi361_cheque_emitidos | FI361 | Cheques emitidos |
| w_fi362_deuda_financiera | FI362 | Deuda financiera |
| w_fi363_aprob_deuda_financiera | FI308 | Aprobación deuda financiera |
| w_fi364_lista_letras_print | S/C | Impresión de letras |
| w_fi365_change_periodo | FI365 | Cambiar periodo en documentos provisionados |
| w_fi366_dpd_masivo | FI366 | Generación de DPDs masivos |
| w_fi504_cns_cntas_x_pagar_x_venc | FI504 | Cuentas x pagar pendientes por vencimiento |
| w_fi507_cns_cntas_x_cobrar_x_venc | FI507 | Cuentas x cobrar pendientes por vencimiento |
| w_fi508_consulta_oc_os | FI508 | Consulta de OC, OS x facturación |
| w_fi509_doc_consulta_crelacion | FI509 | Documentos x finanzas |
| w_fi510_cns_doc_x_plla_cobranza | FI510 | Documentos en planillas de cobranza |
| w_fi511_cns_inconsistencias_pdb | FI510 | Inconsistencias en planillas de cobranza |
| w_fi512_cns_carta_credito | FI512 | Consulta carta crédito |
| w_fi513_cns_cancelac_documentos | FI504 | Consulta de cancelación de documentos |
| w_fi700_rpt_libro_bancos | FI700 | Reporte de libro bancos |
| w_fi701_rpt_saldo_mov_bancario | FI701 | Reporte de saldo de movimiento bancario |
| w_fi702_cntas_pagar | FI702 | Listado de cuentas x pagar |
| w_fi703_cntas_pagar_tesoreria | FI703 | Análisis detallado mensual de medios de pago |
| w_fi704_resumen_bancario | S/C | Resumen bancario |
| w_fi705_rpt_solic_giro | FI705 | Reporte de documentos emitidos |
| w_fi706_comprob_egreso | FI306 | Reporte de comprobantes de egreso |
| w_fi707_rpt_doc_generados_masivos | FI707 | Reporte de documentos generados masivos |
| w_fi708_detalle_recibos_honorarios | FI708 | Detalle de recibo por honorarios |
| w_fi710_rpt_trans_caja_bancos | FI710 | Reporte de voucher emitidos |
| w_fi711_rpt_cb_detalle | FI711 | Reporte de movimiento detalle de caja bancos |
| w_fi713_flujo_caja_ejt | FI713 | Reporte de flujo de caja ejecutado |
| w_fi714_flujo_caja_proy | FI714 | Reporte de flujo mensual de caja proyectado |
| w_fi715_detalle_pendientes_pago | FI715 | Detalle de pendientes x pagar |
| w_fi716_rpt_cri | FI716 | Reporte de comprobante de retención |
| w_fi717_rpt_x_confin | S/C | Reporte x concepto financiero |
| w_fi718_rpt_letras_x_pagar | FI718 | Reporte de letras x pagar |
| w_fi719_saldo_proveedor | FI719 | Reporte de saldos de proveedores |
| w_fi722_rpt_pagar_directo | FI722 | Documentos pagar directo (reporte) |
| w_fi723_rpt_programacion_pagos_det | FI723 | Programación de pagos detalle |
| w_fi724_rpt_cobrar_directo | S/C | Impresión de cobrar directo |
| w_fi725_rpt_programacion_pagos_res | FI725 | Programación de pagos resumen |
| w_fi727_conciliacion_bancaria | FI727 | Conciliación bancaria (reporte) |
| w_fi728_pagos_serv_financ | FI728 | Reporte pagos servicio financiero |
| w_fi729_inf_sunat | FI729 | Registros de compras y pagos SUNAT |
| w_fi732_envio_informacion | FI732 | Envío de información a caja |
| w_fi733_doc_x_pagar_pend_tbl | FI733 | Documentos pendientes por pagar |
| w_fi734_doc_x_pagar_pend_resumen_tbl | FI734 | Resumen documentos pendientes por pagar |
| w_fi735_no_admitidos_coa | FI735 | No admitidos COA |
| w_fi737_anticipos_oc_os | FI737 | Anticipos OC, OS |
| w_fi738_compras_mensualizado | FI738 | Compras por proveedores mensualizado |
| w_fi739_vouchers_masivos | FI739 | Impresión masiva de vouchers |
| w_fi740_rpt_cartera_pagos | FI740 | Detalle de cartera de pagos |
| w_fi741_resumen_pendientes_pago | FI741 | Resumen pendientes de pago |
| w_fi742_rpt_cartera_cobros | FI742 | Detalle de cartera de cobros |
| w_fi743_compras_proveedores | FI743 | Compra a proveedores |
| w_fi745_rpt_detracciones | FI745 | Reporte de detracciones |
| w_fi746_consolidado_mov_bancarios | FI746 | Consolidados de movimientos bancarios |
| w_fi747_cntas_pagar_pend_x_prov | FI747 | Documentos pendientes por pagar x proveedor |
| w_fi748_rpt_detalle_compras_prov | FI748 | Detalle de cuentas x pagar por proveedor |
| w_fi749_registro_compras | FI749 | Reporte de registro de compras |
| w_fi750_rpt_doc_sin_ref | FI750 | Documentos cancelados sin referencia |
| w_fi751_rpt_doc_x_cobrar_sin_ref | FI751 | Cuentas x cobrar cancelados sin referencia |
| w_fi752_rpt_transferencias | FI752 | Detalle de transferencias entre cuentas |
| w_fi753_sldo_cta_cte | FI753 | Reporte analítico de cuenta corriente |
| w_fi754_compras_detraccion | FI754 | Compras vs detracciones vs pagos |
| w_fi755_matriz_grupo_financiero | FI755 | Matrices y grupos financieros |
| w_fi756_cheque_vs_facturas | FI756 | Detalle de facturas por cheque |
| w_fi900_saldo_banco_mensuales | FI900 | Actualización de saldo bancario |
| w_fi901_proceso_impresion_cri | FI901 | Impresión masiva de comprobante de retención |
| w_fi902_proceso_impresion_cheque_voucher | FI902 | Impresión masiva cheque-voucher |
| w_fi903_pago_mas_detraccion | FI903 | Pago masivo detracción |
| w_fi904_coa | FI904 | Generación de COA |
| w_fi905_generacion_fact_cobrar | FI905 | Generación de facturas de materiales |
| w_fi906_generacion_fact_cobrar_guias | FI905 | Reporte de guías a facturar |
| w_fi907_pdb | FI907 | Generación de PDB |
| w_fi908_ppagos_txt | FI908 | Generación de programa de pago |
| w_fi910_actualiza_cntas_crrte_cliprov | FI910 | Actualización cuenta corriente |
| w_fi911_imp_mas_voucher | FI911 | Impresión masiva voucher |
| w_fi912_gen_pdt_3550 | FI912 | PDT 3550 |
| w_fi913_change_nro_doc | FI913 | Cambiar proveedor, tipo o número de documento |
| w_fi914_cierre_documentos | FI914 | Cierre de documentos de cuentas x pagar |
| w_fi915_change_clase_bien_servicio | FI915 | Cambiar clase de bien o servicio (SUNAT) |
| w_fi916_import_excel_crono_terrenos | FI916 | Importación de cronogramas de terrenos |
| w_fi917_change_fec_vencimiento | FI917 | Cambiar fecha de vencimiento y forma de pago |
| w_fin501_letras_x_vencimiento | FI501 | Letras por fecha de vencimiento |
| w_fin503_programa_pagos | FI503 | Programa de pagos |
| w_ope315_envio_email | OPE315 | Envío correo electrónico |

| w_sig735_cuentas_cobrar_pendiente | SIG735 | Cuentas por cobrar pendientes |

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

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_aviso_err | S/C | Aviso de error |
| w_cns_datos_ot | S/C | Consulta de movimientos de OT |
| w_ma302_orden_trabajo_rpt | MA302RPT | Reporte de orden de trabajo |
| w_ma302_orden_trabajo_rpt_prev | MA302RPT | Reporte de orden de trabajo (vista previa) |
| w_op031_parametro_operac | OP031 | Parámetros de módulo de operaciones OT |
| w_op310_repr_mov_proy | OP310 | Reprogramación de movimientos atrasados |
| w_ope001_fase_etapa | OPE001 | Mantenimiento procesos y actividades |
| w_ope002_ejecutor | OPE002 | Mantenimiento de ejecutor |
| w_ope003_labor_ejecutor | OPE003 | Maestro de labores |
| w_ope003_labor_ejecutor_rpt | OPE003RPT | Reporte de labores |
| w_ope004_plant_operacion | OPE004 | Maestro de plantillas de operaciones |
| w_ope005_repr_mov_proy | OP005 | Reprogramación de movimientos atrasados |
| w_ope006_ot_tipo | OPE006 | Tipo de OT |
| w_ope007_ot_usuario | OPE007 | Usuarios de OT ADM |
| w_ope008_ot_parametros | OPE008 | Parámetros de administradores de OT |
| w_ope009_grupo_relacion | OPE009 | Grupos de personal por OT ADM |
| w_ope010_turnos_trabaj | OPE010 | Mantenimiento de turnos |
| w_ope011_constructor_reportes | OPE011 | Constructor de reportes |
| w_ope012_labor_grupo | OPE012 | Labor grupo - OT ADM |
| w_ope013_numerador_reclamo | OPE013 | Numerador de reclamos |
| w_ope014_tipo_reclamo_calidad | OPE014 | Tipo de reclamo de calidad |
| w_ope015_plantilla_grupo | OPE015 | Grupo de plantillas |
| w_ope016_incidencias | OPE016 | Maestro de incidencias |
| w_ope017_incidencias_clase | OPE017 | Clase de incidencias |
| w_ope018_incidencias_ot_adm | OPE018 | Incidencias por OT ADM |
| w_ope019_labor_herramienta | OPE019 | Herramientas por labor |
| w_ope020_labores_x_tipo_maquina | OPE020 | Costo de labor por tipo de máquina |
| w_ope021_ot_adm_usuario_aprob | OP021 | Niveles de autorización de aprobaciones |
| w_ope022_ot_tipo_seccion | OPE022 | Tipo de secciones |
| w_ope023_ot_seccion | S/C | OT x tipo de secciones |
| w_ope024_articulos_autorizacion_aprobac | OPE024 | Nivel de autorización de artículos |
| w_ope025_aut_cencos | OPE025 | Autorizaciones de solicitud OT por centro costo |
| w_ope026_plant_ot | OPE026 | Mantenimiento de plantillas de OT |
| w_ope027_labor_trabajador | OPE027 | Trabajadores por labor ejecutor |
| w_ope028_prod_vs_labores | OPE028 | Productos vs labores |
| w_ope029_productos | OPE029 | Productos de pesaje |
| w_ope030_clasificacion_productos | OPE030 | Clasificación de productos |
| w_ope031_prodparam | OP031 | Parámetros de producción OT |
| w_ope301_solicit_ot | OPE301 | Solicitud de orden de trabajo |
| w_ope301_solicit_ot_acept | S/C | Confirmación de solicitud de OT |
| w_ope301_solicit_ot_recha | S/C | Rechazo de solicitud de OT |
| w_ope301_solicit_ot_rpt | OPE301RPT | Reporte de solicitud de OT |
| w_ope302_orden_trabajo | OPE302 | Órdenes de trabajo |
| w_ope302_orden_trabajo_rpt_pto | S/C | Reporte de presupuesto x artículos de OT |
| w_ope303_ins_reprog_operac | OPE303 | Ingreso de operaciones |
| w_ope303_reprogra_operacion | OPE303 | Reprogramación de operaciones |
| w_ope304_prog_operaciones_rpt | MA302RPT | Reporte de programación de operaciones |
| w_ope304_prog_operaciones_x_ot | OPE304 | Programación de orden de trabajo |
| w_ope305_lista_trabaj | S/C | Lista de trabajadores por labor |
| w_ope305_parte_ot | OPE305 | Parte diario de orden de trabajo |
| w_ope306_reclamo_calidad | OPE306 | Reclamos de calidad de PPTT |
| w_ope307_proceso_facturacion | OPE307 | Proceso de facturación de operaciones |
| w_ope308_proceso_correcion | OPE308 | Corrección de facturación de operaciones |
| w_ope309_estruct_ot | OPE309 | Estructura de órdenes de trabajo |
| w_ope310_desaprobac_amp | OPE310 | Desaprobación de requerimientos a comprar |
| w_ope311_aprobacion_material | OPE311 | Cambio de estado de materiales |
| w_ope313_orden_trabajo_simplif | OPE313 | Orden de trabajo simplificada |
| w_ope314_reversion_mov_act | S/C | Reversión de movimiento activo |
| w_ope315_envio_email | OPE315 | Envío correo electrónico |
| w_ope316_negociacion | OPE316 | Negociación |
| w_ope317_reservacion_material | OPE317 | Reservación de materiales |
| w_ope317_reservacion_material_rpt | MA317RPT | Reporte de reservación de materiales |
| w_ope318_liberacion_amp | OPE318 | Liberación de requerimientos de la OT |
| w_ope319_cierra_amp | OPE319 | Cierre de AMP |
| w_ope320_cierra_opersec | OPE320 | Cierre de OPERSEC |
| w_ope321_prod_x_ot | OPE321 | Producción destajo |
| w_ope322_pesaje_balanza_manual_tbl | OPE322 | Pesaje manual |
| w_ope323_modif_almacen | OPE323 | Modificación almacén |
| w_ope324_desaprobac_operac | OPE324 | Desaprobación de operaciones de OT |
| w_ope325_libera_reservaciones | AL326 | Liberación de reservaciones |
| w_ope500_opersec | OPE500 | Consultas por OperSec |
| w_ope501_orden_trabajo | OPE501 | Consulta por orden de trabajo |
| w_ope502_labor | OPE502 | Consulta por labor |
| w_ope503_cns_atencion_mat_ot | OPE503 | Atención de materiales por OT |
| w_ope504_cns_cal_reclamo_graf | S/C | Consulta de reclamos de calidad |
| w_ope506_cns_articulo_labor | OPE506 | Consulta de artículo por labor |
| w_ope507_labor_x_art | S/C | Consulta de artículos por labor |
| w_ope508_ot_adm | OPE508 | Consulta por administrador de OT |
| w_ope700_solicitud_ot | OPE700 | Solicitud de orden de trabajo (reporte) |
| w_ope701_orden_trabajo | OPE701 | Listado de órdenes de trabajo |
| w_ope702_costo_ot | OPE702 | Reporte de costo de OT |
| w_ope703_operaciones_proy | S/C | Operaciones proyectadas x OT |
| w_ope704_oper_prog_x_cc_rsp | OPE704 | Operaciones programadas talleres |
| w_ope705_material_program | OPE705 | Materiales programados |
| w_ope706_oper_plan_x_cc_rsp | OPE706 | Operaciones proyectadas talleres |
| w_ope707_material_planeado | OPE707 | Materiales planeado |
| w_ope708_material_program_det | OPE708 | Materiales programados detalle |
| w_ope709_material_proyec_det | OPE709 | Materiales planeados detalle |
| w_ope710_plantilla_operaciones | OPE710 | Plantilla de operaciones |
| w_ope711_costo_x_labor | OPE711 | Costo x máquina |
| w_ope712_operaciones_no_program | OP712 | Operaciones no programadas x OT |
| w_ope713_oper_program_a_facturar | OPE713 | Operaciones programadas a facturar |
| w_ope714_operaciones_x_facturar | OPE714 | Operaciones pendientes a facturar |
| w_ope714_operaciones_x_facturar_det | S/C | Detalle operaciones pendientes a facturar |
| w_ope715_operaciones_facturadas | OPE715 | Operaciones facturadas |
| w_ope716_reclamos | OPE716 | Reporte de reclamos |
| w_ope717_tareas_pd | OPE717 | Costo estimado de tareas |
| w_ope718_orden_trabajo_rpt | MA302RPT | Reporte de orden de trabajo |
| w_ope719_oper_x_estado | OPE719 | Operaciones según estado |
| w_ope720_partes_diarios | OPE720 | Partes diarios |
| w_ope721_tareas_pd_x_tercero | OPE721 | Tareas de terceros por campo |
| w_ope722_incidencias_maquina | OPE722 | Incidencias de equipos y/o maquinarias |
| w_ope723_requerim_material_ot | OPE723 | Requerimientos de materiales por OT |
| w_ope724_aprobaciones_materiales | OPE724 | Artículos y operaciones pendientes aprobación |
| w_ope725_mat_ot_x_oc | OPE725 | Atención de materiales de OT |
| w_ope726_mat_ot_x_cotizar | OPE726 | Materiales de OT a cotizar |
| w_ope727_costo_real_est_x_ot | OPE727 | Reporte de costo real / estimado |
| w_ope730_orden_trabajo | OPE730 | Orden de trabajo |
| w_ope731_costo_x_maquina | OPE731 | Costo x máquina |
| w_ope732_seleccion_maquina | S/C | Selección de máquina |
| w_ope733_requerim_x_cotizar | OPE733 | Requerimientos solicitados a cotizar |
| w_ope734_orden_trabajo_rpt | MA302RPT | Reporte de orden de trabajo |
| w_ope740_ot_general | OPE740 | OT general |
| w_ope741_rpt_error | OPE741 | Reporte de errores |
| w_ope742_rpt_desaprob_mat | OPE742 | Desaprobación de materiales |
| w_ope743_costo_ot_x_producion | OPE743 | Totales de costos de OT |
| w_ope744_admin_usuario_aprob_req | S/C | Administración usuario aprobación requerimientos |
| w_ope744_rend_labores_x_maq | OPE744 | Rendimiento de labores mecanizadas x campo |
| w_ope745_presp_art_aprobados | OPE745 | Presupuesto proyectado aprobados |
| w_ope746_presp_art_activos_pend | OPE746 | Partidas presupuestales x requerimiento |
| w_ope747_rpt_pend_fac | OPE747 | Operaciones pendientes por facturar |
| w_ope748_rpt_consumo_x_ot_adm | OPE748 | Consumos de materiales o servicios por OT ADM |
| w_ope749_saldos_reservados | OPE749 | Saldos reservados por requerimiento |
| w_ope750_saldos_libres | OPE750 | Saldos libres requerimiento |
| w_ope751_costos_x_estructura | OPE751 | Costos por estructura |
| w_ope752_costos_x_seccion | OPE752 | Costos por sección |
| w_ope753_saldo_comprometido | OPE753 | Saldo comprometido en OT |
| w_ope754_maestro_labor | OPE754 | Maestro de labores e insumos |
| w_ope755_maestro_ejecutor | OPE755 | Maestro de ejecutores |
| w_ope756_maestro_ot_adm | OPE756 | Maestro de administradores de OT |
| w_ope757_usuarios_x_ot_adm | OPE757 | Administraciones de OT y usuarios anexados |
| w_ope758_labor_cnta_prsp | OPE758 | Consultas de cuentas presupuestales por labor |
| w_ope759_orden_trabajo_fmt_tbl | OPE759 | Formato de orden trabajo |
| w_ope760_destajo_x_prod | OPE760 | Producción x producto x actividad |
| w_ope761_prodc_x_trabajador | OPE761 | Producción por trabajador (costo) |
| w_ope762_productividad_trabajador | OPE762 | Productividad x trabajador (costo) |
| w_ope762_top_ten_old | OPE762 | Ranking de producción |
| w_ope763_productividad_x_actividad | OPE763 | Productividad por actividad |
| w_ope764_costo_actividad | OPE764 | Costo por actividad |
| w_ope765_productividad_individual | OPE764 | Productividad individual |
| w_ope766_atencion_materiales | OPE766 | Atención de materiales |
| w_ope767_resumen_actividades | OPE767 | Resumen de actividades |
| w_ope768_maestro_ot | OPE768 | Listado de órdenes de trabajo |
| w_ope900_actualizar_ot_x_plantilla | OPE900 | Actualiza datos de OT según factor de plantilla |
| w_ope901_abrir_cerrar_operaciones | OPE901 | Abrir y cerrar operaciones |
| w_ope902_abrir_proyectar_articulos | OPE901 | Abrir y proyectar artículos |
| w_ope904_aprobacion_operac_material | OPE904 | Aprobación de operaciones y materiales |
| w_ope905_balanza_prod_x_dia | OPE905 | Transferencia de balanza por día |
| w_ope906_balanza_prod_x_timer | OPE905 | Transferencia de balanza por timer |
| w_ope907_aprob_material_prsp_det | S/C | Saldo comprometido detalle |
| w_ope908_rpt_artic_no_autorizados | MA302RPT | Reporte de artículos no autorizados |


---

## 11. Mantenimiento

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_ca304_reprogra_operacion | CA304 | Reprogramación de operaciones |
| w_ca703_rpt_presup_x_ejec_valoriz | CA718 | Resumen de presupuesto valorizado por ejecutor |
| w_copia_plant_prod | S/C | Copia de plantillas de producción |
| w_estructura_pop_preg | S/C | Ingreso de cantidad para estructura |
| w_ma001_grupo_maquina | MA001 | Grupos de máquinas |
| w_ma002_tipo_maquina | MA002 | Tipos de máquinas |
| w_ma003_maquina | MA003 | Maestro de máquinas o equipos |
| w_ma004_marca | MA004 | Marcas de máquinas o equipos |
| w_ma005_incidencias_mant | MA005 | Tipos de incidencias de mantenimiento |
| w_ma006_mecanicos | MA006 | Mantenimiento de mecánicos |
| w_ma007_operadores_maq | MA007 | Mantenimiento de operadores |
| w_ma008_tipo_mantto | MA008 | Tipos de mantenimientos de maquinarias |
| w_ma009_doc_tecnica | MA009 | Tipo de documentación técnica |
| w_ma010_maq_labor_herramienta | MA010 | Equipos/máquinas por labor |
| w_ma011_art_doc_tecnica | MA011 | Documentación técnica |
| w_ma012_estructura | MA012 | Estructura de artículos |
| w_ma013_articulos | MA013 | Artículos |
| w_ma014_plant_operacion | MA014 | Plantillas de operaciones de producción |
| w_ma015_plant_ratios | MA015 | Plantillas de ratios de producción |
| w_ma016_caract_tec | MA016 | Características técnicas |
| w_ma017_grupo_cencos | MA017 | Grupo de centros de costos |
| w_ma018_causas_fallas | MA018 | Causas de fallas |
| w_ma019_agruphor | MA019 | Agruphores de máquinas |
| w_ma020_color | MA020 | Maestro de colores |
| w_ma021_estruct_maquinas | MA021 | Estructura de máquinas |
| w_ma022_med_acum_maq | MA022 | Actualizar horómetros de equipos |
| w_ma300_manten_prog_maq | MA300 | Programa de mantenimiento de máquinas |
| w_ma301_solicit_ot | MA301 | Solicitud de orden de trabajo |
| w_ma301_solicit_ot_acept | S/C | Confirmación de solicitud de OT |
| w_ma301_solicit_ot_recha | S/C | Rechazo de solicitud de OT |
| w_ma301_solicit_ot_rpt | MA301RPT | Reporte de solicitud de OT |
| w_ma303_parte_ot | MA303 | Parte diario de orden de trabajo |
| w_ma304_prog_operaciones_x_ot | MA304 | Programación de operaciones por OT |
| w_ma305_ciclo_frecuencia | MA305 | Frecuencia de mantenimiento |
| w_ma306_pd_agruphor | MA306 | Parte diario de agruphores |
| w_ma307_log_mantto | MA307 | Bitácora de mantenimiento |
| w_ma500_costos_mantenimiento | MA500 | Costos de mantenimiento |
| w_ma500_costos_mantenimiento_bkp | MA500 | Costos de mantenimiento (backup) |
| w_ma501_prog_mntt_prev | MA501 | Programación de mantenimiento preventivo |
| w_ma502_solic_ot | MA502 | Solicitud de órdenes de trabajo |
| w_ma503_ord_trabaj | MA503 | Órdenes de trabajo |
| w_ma505_recor_mant | MA505 | Récord de mantenimiento |
| w_ma506_hoja_mantenimiento | MA506 | Hoja de mantenimiento |
| w_ma507_gastos_mntto_maq | MA507 | Gastos de mantenimiento de máquina |
| w_ma508_costo_x_orden_trabajo | MA508 | Operaciones por orden de trabajo |
| w_ma509_articulo_estructura | MA509 | Estructura de artículos |
| w_ma510_costos_mantenimiento_x_grp | MA510 | Costos de mantenimiento por grupo |
| w_ma511_costos_mantenimiento_x_maq_anual | MA511 | Costos de mantenimiento anual por máquina |
| w_ma512_costos_mantenimiento_x_grpmaq_an | MA512 | Costos de mantenimiento anual por grupo de máquina |
| w_ma520_materiales_ot | S/C | Consulta de artículos faltantes por OT |
| w_ma521_maquina_historial | MA521 | Historial de equipos o maquinarias |
| w_ma521_programacion_operaciones | MA521 | Programación de operaciones |
| w_ma522_detalle_consulta | PT501 | Detalle de variaciones |
| w_ma700_estructura_articulo | MA700 | Reporte de estructuras |
| w_ma701_rpt_prog_trabajo | MA701 | Programación semanal de labores de mantenimiento |
| w_ma702_rpt_horas_x_seccion | MA702 | Horas trabajadas por sección |
| w_ma703_rpt_presup_x_ejec_valoriz | MA703 | Presupuesto valorizado de talleres por ejecutor |
| w_ma704_rpt_costo_materiales | MA704 | Costo de materiales por taller |
| w_ma705_rpt_historial_reparac | MA705 | Historial de reparación de talleres |
| w_ma706_rpt_efic_cc_solic | MA706 | Eficiencia por centro de costo solicitante |
| w_ma707_rpt_costos_x_ejec_anual | MA707 | Costo valorizado de OT por ejecutor |
| w_ma708_rpt_lab_pend_x_cc | MA708 | Labores pendientes por taller |
| w_ma708_rpt_lab_pend_x_cc_bk | MA708 | Labores pendientes por CC/taller (backup) |
| w_ma709_rpt_maquina_horometraje | MA709 | Consumo de combustible por máquina |
| w_ma710_rpt_orden_trabajo | MA702 | Reporte de orden de trabajo |
| w_ma711_rpt_mntto_preventivo | MA711 | Programa de mantenimiento preventivo |
| w_ma712_horas_talleres | MA712 | Detalle de horas trabajadas de talleres |
| w_ma713_rpt_efic_cc_det | MA713 | Detalle de reporte de eficiencia |
| w_ma714_labores_x_dia | MA714 | Reporte diario de labores |
| w_ma715_inoperat_maquinas | MA715 | Inoperatividad de máquinas |
| w_ma716_estruct_maq | MA716 | Lista de estructuras |
| w_ma717_rpt_agruphor | MA717 | Reporte de agruphor |
| w_ma717_rpt_agruphor_resumen | MA717 | Disponibilidad por estructura (resumen) |
| w_ma718_lista_equipos | MA717 | Lista de equipos y/o máquinas |
| w_ma719_ciclo_mantto | MA719 | Programa cíclico de mantenimiento |
| w_ma720_equipos_cencos | FL709 | Equipos por centro de costos |
| w_ma721_doc_tenica_eq | FL709 | Documentación técnica de equipo |
| w_ma722_costo_naturaleza | MA722 | Costo por naturaleza de OT |
| w_ma723_costo_x_maquina | MA723 | Costo por máquina |
| w_ma730_estructura_art | MA730 | Estructura de artículo |
| w_ma731_consumos_cenbef | MA731 | Consumos/servicios por centro de beneficio |
| w_ma735_estructura_maq | MA735 | Estructura de máquina |
| w_ma736_historial_equipo | MA736 | Historial de equipos |
| w_ma900_mant_prog_ot | MA900 | Generación de órdenes de trabajo |
| w_ma901_mntto_proyectado | MA901 | Mantenimiento proyectado |
| w_ma902_generar_ot | AP900 | Generar orden de trabajo |
| w_maq_estructura | S/C | Vista de estructura de máquina (TreeView) |
| w_maxxx_causa_fallas_tbl | MAXXX | Causas de fallas (tabla) |
| w_print_properties | S/C | Propiedades de impresión |
| w_reprogra_ope_campo_res | S/C | Campos sin cortes registrados |
| w_reprogra_ope_ciclo_res | S/C | Ciclos sin cortes registrados |
| w_reprogra_ope_detalle_pop | S/C | Detalle de reprogramación de operación |
| w_rpt_jramos | MA708 | Labores pendientes por taller |

---

## 12. Aprovisionamiento

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_ap001_zonas_descarga | AP001 | Zonas de descarga |
| w_ap002_trato_provee | AP002 | Trato de proveedores |
| w_ap004_precios_rep | AP004 | Precios de representación |
| w_ap006_num_ap_pd_descarga | AP006 | Numerador partes diario de descarga |
| w_ap007_num_guias_recep | AP007 | Numerador guías de recepción |
| w_ap008_atrib_calidad | AP008 | Atributos de calidad |
| w_ap009_especie | AP009 | Mantenimiento de especies |
| w_ap010_unidad_grupo | AP010 | Unidades y grupos de atributos |
| w_ap011_familia_especies | AP011 | Familia de especies |
| w_ap013_dest_ref_matprim | AP013 | Destino referencia de materia prima |
| w_ap015_factores_conversion | AP015 | Factores de conversión |
| w_ap016_parametros_generales | AP016 | Parámetros generales de aprovisionamiento |
| w_ap017_parametros_especificos | AP017 | Parámetros específicos de aprovisionamiento |
| w_ap018_proveedor_transporte | AP018 | Transportes de materia prima |
| w_ap019_precios_x_transp_mp | S/C | Tarifas por transportista de MP |
| w_ap020_rutas_transporte | AP020 | Rutas de transporte de materia prima |
| w_ap021_abc_prov_mp | AP021 | Proveedor MP - Especies y tarifas |
| w_ap022_ap_transportista_mp_placa | AP022 | Transportista MP - Unidades |
| w_ap023_ap_transportista_tarifa | AP021 | Proveedor MP - Especies y tarifas |
| w_ap024_empacadoras | AP024 | Empacadoras |
| w_ap025_sectores | AP025 | Sectores |
| w_ap026_bases | AP026 | Bases |
| w_ap027_cuadrillas | AP027 | Cuadrillas |
| w_ap028_tipo_cajas | AP028 | Tipos de cajas |
| w_ap029_tipo_fundas | AP029 | Tipos de fundas |
| w_ap030_prov_certificacion | AP030 | Certificaciones de proveedores |
| w_ap031_tipo_certificacion | AP031 | Tipo de certificación |
| w_ap032_empacadoras_ot | AP032 | OT por empacadoras |
| w_ap033_tipos_pesca | AP033 | Tipos de pesca |
| w_ap300_proy_aprov | AP300 | Proyección de aprovisionamiento |
| w_ap301_guia_recepcion | AP301 | Guía recepción de materia prima |
| w_ap301_guia_recepcion_frm | S/C | Reporte de guía de recepción de MP |
| w_ap302_aprob_grmp | AP302 | Aprobación de guía de recepción MP |
| w_ap304_pd_matprim_filtro | S/C | Filtro de parte diario de materia prima |
| w_ap307_pd_descarga | AP307 | Recepción, descarga y pesaje de MP |
| w_ap307_pd_descarga_frm | S/C | Reporte de costo diario de MP |
| w_ap308_calidad_matprim | AP308 | Calidad de materia prima |
| w_ap309_variac_proy | AP309 | Variación de proyección de aprovisionamiento |
| w_ap310_det_grf_calidad | S/C | Detalle de calidades por especie |
| w_ap311_plantilla_presupuestal | AP006 | Asignación de plantillas presupuestales |
| w_ap312_crea_plantilla | S/C | Creación de plantilla presupuestal |
| w_ap313_pd_chata_qstn | AP313 | Parte de piso - Filtro de autollenado |
| w_ap314_asig_plant_prsp | AP314 | Asignación de plantillas presupuestales |
| w_ap315_liquidacion_compra | AP315 | Liquidación de compra |
| w_ap315_liquidacion_compra_frm | AP315 | Reporte de liquidación de compra |
| w_ap316_recibo_cajas | AP316 | Recibo de entrega de cajas |
| w_ap317_parte_cosecha | AP317 | Parte de cosecha de campo |
| w_ap318_imp_liq_comp | AP318 | Impresión de liquidación de compras |
| w_ap319_precios_descarga | AP319 | Modificar precios del parte de recepción MP |
| w_ap320_datos_calidad | AP320 | Asignar datos de calidad - Liberación |
| w_ap321_datos_importacion | AP321 | Asignar datos de importación - Liberación |
| w_ap500_comparativo_pesca_mat | AP500 | Comparativo entre ingreso por pesca y materiales |
| w_ap501_ingreso_manual_almacen | AP501 | Ingresos manuales a almacén |
| w_ap700_contol_desembarque | AP700 | Control de desembarque |
| w_ap703_decl_jur_men_tolva | AP703 | Declaración jurada mensual de tolva |
| w_ap704_decl_jur_dia_tolva | AP704 | Declaración jurada diaria de tolva |
| w_ap706_ratios_control | AP706 | Ratios de control |
| w_ap707_total_pesca_nave | AP707 | Reporte mensual de pesca por embarcación |
| w_ap708_pd_descarga_planilla | AP708 | Planilla de descarga de materia prima |
| w_ap709_recepcion_mp | AP709 | Recepción de materia prima por tinas |
| w_ap711_compra_matprim | AP711 | Reporte de compra de materia prima |
| w_ap712_plan_com_mp | AP712 | Planilla de compra de MP con diferentes precios |
| w_ap713_diferencias_guias_mov_alm | AP713 | Diferencias guías/mov. almacén |
| w_ap714_peso_precio_pond | AP714 | Peso/precio ponderado |
| w_ap715_control_peso_rpm | AP715 | Control de pesos en recepción de MP |
| w_ap717_ingreso_materia_prima | AP717 | Ingreso de materia prima |
| w_ap718_record_pesca_embarcaciones | AP718 | Récord de pesca por embarcación |
| w_ap719_reporte_semanal_x_embarcacion | AP719 | Reporte semanal de pesca por embarcación |
| w_ap720_rpt_recep_mp_dt_x_fecha | S/C | Recepción de MP detallada por fecha |
| w_ap720_rpt_recepcion_mp_x_especie | AP720 | Recepción de materia prima por especie |
| w_ap721_recep_mp_x_proveedor | AP721 | Recepción de materia prima por proveedor |
| w_ap722_recep_mp_x_prov_especie | AP722 | Recepción de MP por proveedor y especie |
| w_ap723_recep_mp_x_transp_especie | AP723 | Recepción de MP por transportista y especie |
| w_ap724_recep_mp_x_transportista | AP724 | Recepción de materia prima por transportista |
| w_ap725_recep_mp_detalle | AP725 | Recepción de materia prima detallado |
| w_ap726_acopio_procesamiento | AP726 | Reporte de acopio y procesamiento |
| w_ap727_pago_recepcion | AP727 | Planilla de compras |
| w_ap728_volumen_x_base | AP728 | Reporte de volumen por base |
| w_ap729_datos_productores | AP729 | Reporte de validación de productores |
| w_ap730_consolidado_compras | AP730 | Consolidado de compras |
| w_ap731_volumen_x_productor | AP731 | Reporte de volumen por productor |
| w_ap732_productores_sin_lc | AP732 | Productores sin liquidación de OC |
| w_ap733_rpt_prod_mp | AP733 | Reporte de producción por proveedor de MP |
| w_ap734_rpt_produccion_det | AP734 | Reporte de acopio de producción detallada |
| w_ap901_generar_prsp | AP901 | Generar presupuesto |
| w_ap902_presup_variac | AP902 | Variaciones presupuestales |
| w_ap903_actualizar_costos_compra | AP903 | Actualizar costos de última compra |
| w_ap904_genera_oc | AP904 | Generar orden de compra |
| w_ap905_anula_oc | AP905 | Anular orden de compra |
| w_ap906_genera_grmp | AP906 | Generar guías de recepción de MP |
| w_ap907_anula_os | AP907 | Anulación de OS de transporte |
| w_ap908_genera_lc | AP908 | Generar liquidación de compras para productores |
| w_ap909_genera_os | AP909 | Generación de OS de transporte |
| w_ap910_genera_os_proc | AP910 | Generación de OS de procesamiento |

---

## 13. Asistencia

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_asi001_maestro_turnos | ASI001 | Maestro de Turnos |
| w_asi002_maestro_tarjetas | ASI002 | Maestro de Tarjetas |
| w_asi003_maestro_mov_asist | ASI001 | Maestro de Movimientos de Asistencia |
| w_asi300_asignacion_turnos | ASI300 | Asignación de Turnos |
| w_asi300_asignacion_turnos_bak | ASI300 | Asignación de Turnos (backup) |
| w_asi301_incidencias | ASI301 | Incidencias |
| w_asi302_delete_turnos_asig | ASI302 | Elimina Asignación de Turnos |
| w_asi303_asigna_turno_semana | ASI303 | Asignación de Horarios por Plantilla Semanal |
| w_asi304_asistencia_ht580 | ASI304 | Modificación de Asistencia de Personal HT580 |
| w_asi304_asistencia_ht580_bk | ASI707 | Asistencia HT580 (backup) |
| w_asi700_asistencia_trabajadores | ASI700 | Reporte de Asistencias |
| w_asi701_registro_control_asist | ASI701 | Registro de Control de Ingresos y Salidas |
| w_asi702_asignacion_turnos | ASI702 | Asignación de Turnos |
| w_asi703_tardanzas | ASI703 | Reporte de Tardanzas |
| w_asi704_tarjetas_trabajadores | AS704 | Trabajadores / Tarjetas |
| w_asi705_carnet_identifica | ASI705 | Carnets de Trabajadores |
| w_asi707_asistencia_ht580 | ASI707 | Asistencia HT580 |
| w_asi900_transferencia_reloj | ASI900 | Transferencia de Archivo Texto |
| w_asi901_actualiza_asistencias | ASI902 | Transferencia de Asistencia |
| w_asi902_subir_asist_ht580 | ASI902 | Subir Asistencia del HT580 |
| w_asi903_upgrade_zktime | ASI903 | Actualizar datos de ZKTIME |
| w_gen_actualiza_marcaciones_as302 | AS302 | Actualiza Consolidado de Marcaciones Diarias |
| w_gen_elimina_registros_as304 | AS304 | Elimina Información de Tablas |
| w_gen_genera_turnos | S/C | Generación de Turnos para Personal Rotativo |
| w_gen_informacion_reloj_as301 | AS301 | Proceso Diario de Información de Reloj |
| w_gen_transferencia_as303 | AS303 | Transfiere Inasistencias y Pagos por Sobretiempos |
| w_rh079_maestro_tarjetas | RH079 | Maestro de Tarjetas |
| w_rh621_rpt_promedio_evaluacion | RH621 | Reporte de Promedio General de Evaluaciones |
| w_rpt_carnet_as405 | AS405 | Marcaciones con Carnet Inactivos |
| w_rpt_consolidado_as406 | AS406 | Resumen de Marcaciones |
| w_rpt_inasistencia_codigo_as410 | AS410 | Comparativo de Inasistencias por Código |
| w_rpt_inasistencia_general_as409 | AS409 | Comparativo de Inasistencias por Fechas |
| w_rpt_incidencias_codigo_as408 | AS408 | Movimiento Digitado por Usuario (por Código) |
| w_rpt_incidencias_general_as407 | AS407 | Movimiento Digitado por Usuario (General) |
| w_rpt_marc_det_irregular_as403 | AS403 | Detalle de Irregularidades en Marcaciones |
| w_rpt_marc_det_regular_as404 | AS404 | Detalle de Regularidades en Marcaciones |
| w_rpt_marcacion_irregular_as402 | AS402 | Personal con Marcaciones Irregulares |
| w_rpt_padron_as415 | AS415 | Padrón de Obreros y Empleados |


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

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cam001_elem_quimicos | CAM001 | Elementos Químicos |
| w_cam002_factor_ele_quim | CAM002 | Factor del Artículo con Elementos Químicos |
| w_cam003_sectores_campo | CAM003 | Sectores de Campo |
| w_cam004_tipos_riego | CAM004 | Tipos de Riego |
| w_cam005_etapas_fenologicas | CAM005 | Etapas Fenológicas |
| w_cam006_numeracion_origen | AL009 | Numeradores |
| w_cam007_estados_fenologicos | CAM007 | Estados Fenológicos |
| w_cam008_lotes_campo | CAM008 | Lotes Campos |
| w_cam009_campanas | CAM008 | Lotes Campos |
| w_cam010_campo_sembradores | CAM010 | Campos y Sembradores |
| w_cam011_ingenios | CAM011 | Ingenios Azucareros |
| w_cam012_formulas | CAM012 | Fórmulas |
| w_cam013_ubicacion_campo | CAM013 | Ubicación Campo |
| w_cam014_tipos_prestamos | CAM014 | Tipos de Préstamos |
| w_cam015_tipo_contrato | CAM015 | Tipos de Contratos |
| w_cam016_variedad_cana | CAM016 | Variedad de Caña |
| w_cam017_documentos_empresa | CAM030 | Instructivos de Trabajo |
| w_cam020_documentos | CAM020 | Documentos de Registros de Productor |
| w_cam021_doc_x_productor | CAM021 | Documentos por Productor |
| w_cam030_instructivos_trabajo | CAM030 | Instructivos de Trabajo |
| w_cam031_procedimiento_operativo | CAM031 | Procedimientos Operativos |
| w_cam032_listas_maestras | CAM032 | Listas Maestras |
| w_cam033_tipos_gg | CAM033 | Tipos de Módulos de Global GAP |
| w_cam034_preguntas_gg | CAM034 | Preguntas Global GAP |
| w_cam040_preguntas_cj | CAM040 | Preguntas de Comercio Justo |
| w_cam050_ley_fertilizacion | CAM050 | Ley de Fertilización |
| w_cam051_ley_fitosanitario | CAM051 | Ley de Fitosanitarios |
| w_cam060_areas_almacen | CAM060 | Áreas de Almacén |
| w_cam200_global_gap | CM200 | Inspección Global GAP |
| w_cam201_global_gap_general | CM201 | Inspección Global GAP General |
| w_cam301_proy_horas_jornal | CAM301 | Proyección de Horas Jornaleros |
| w_cam302_parte_riego | CAM301 | Parte de Riego |
| w_cam303_parte_molienda | CAM303 | Parte de Molienda |
| w_cam304_creditos | CM304 | Créditos |
| w_cam304_creditos_frm | S/C | Formulario de Créditos |
| w_cam305_contratos_sem | CM305 | Contratos Sembradores |
| w_cam306_parte_consumo | CM306 | Parte Consumo Campo |
| w_cam307_plantilla_consumo | CM306 | Parte Consumo Campo |
| w_cam308_transporte_cana | CAM308 | Transporte de Caña |
| w_cam309_liquidacion_cosecha | CAM309 | Liquidación de Cosecha |
| w_cam310_liquidacion_pago | CM306 | Parte Consumo Campo |
| w_cam311_ctacte_credito | CM311 | Cuenta Corriente Créditos |
| w_cam312_liquidacion_credito_frm | CM311 | Formato de Orden de Compra |
| w_cam312_liquidar_creditos | CM312 | Liquidación de Créditos |
| w_cam313_cuaderno_productor | CM313 | Cuaderno del Productor |
| w_cam320_comercio_justo | CM320 | Inspección Comercio Justo |
| w_cam330_inspeccion_organica | CM330 | Inspección Orgánica |
| w_cam340_inspeccion_no_anunciada | CM340 | Inspección No Anunciada |
| w_cam349_reg_capacitacion | CAM349 | RG-42 Capacitaciones |
| w_cam351_limpieza_almacen | CM351 | RG-35 Limpieza Almacén y Dosificación de Insumos |
| w_cam352_entrega_limpieza | CM352 | RG-36 Entrega Limpieza y Estado de Materiales |
| w_cam353_calibracion_mnt | CM353 | RG-37 Calibración y Mantenimiento de Equipos |
| w_cam354_monitoreo_roedores | CM354 | RG-38 Monitoreo de Roedores |
| w_cam361_pcm | CAM361 | RG-22 PCMs |
| w_cam362_control_contenedor | CAM362 | RG-23 Control de Calidad en Contenedor |
| w_cam363_limpieza_aplicacion | CAM363 | RG-20 Limpieza y Aplicación Insumos Empacadora |
| w_cam371_sancion_x_inc | CM371 | RG-39 Sanciones por Incumplimientos |
| w_cam372_entrega_documento | CAM372 | RG-40 Entrega de Documentos |
| w_cam373_incumplimiento | CAM373 | RG-41 Incumplimientos - Reclamaciones |
| w_cam374_rpt_reg43 | CAM374 | RG-43 Informe Compendio Productores |
| w_cam375_conteo_doc | CAM375 | RG-44 Conteo de Documentos Obsoletos |
| w_cam376_solicitud_ac | CAM376 | RG-45 Solicitud de Acciones Correctivas |
| w_cam380_packing_list | CAM380 | Packing List |
| w_cam380_packing_list_frm | S/C | Formulario Packing List |
| w_cam390_control_contenedor | CAM390 | Control de Contenedor |
| w_cam412_ch1 | CAM412 | CH1-010511 |
| w_cam413_ab4_aaa | CM413 | AB4 - AAA |
| w_cam422_ch4 | CAM422 | CH4-010511 |
| w_cam423_ch3 | CAM423 | CH3-010511 |
| w_cam424_ch2 | CAM424 | CH2 |
| w_cam432_ab4_bpe | CAM432 | AB4-BPE |
| w_cam433_ab4_bbb | CM433 | AB4 - BBB |
| w_cam434_ac1 | CAM434 | AC1-010511 |
| w_cam700_rendimiento_general | CAM700 | Rendimiento General |
| w_cam701_rend_gen_x_semana | CAM701 | Rendimiento por Semana |
| w_cam702_validar_lotes | CAM702 | Validar Labores por Lotes |
| w_cam703_rendimiento_detallado | CAM703 | Cuadro de Rendimiento Detallado |
| w_cam704_rend_labor_lote | CAM704 | Rendimiento Jornaleros por Labor y Lote |
| w_cam705_rend_jornal_labor | CAM704 | Rendimiento Jornaleros por Labor y Lote |
| w_cam706_rendimiento_jornal_lote | CAM706 | Rendimiento Jornaleros por Lote |
| w_cam707_cronograma_ejecucion | CAM706 | Cronograma de Ejecución |
| w_cam708_rend_molienda | CAM708 | Reporte de Molienda, Laboratorio y Producción |
| w_cam709_molienda_proyectada | CAM709 | Rol de Molienda Proyectada |
| w_cam710_rpt_gen_credito | CAM710 | Reporte General de Créditos |
| w_cam711_rpt_productor_base | CAM711 | Reporte de Productores y Bases |
| w_cam712_rpt_liquidacion_credito | CAM712 | Reporte de Liquidaciones de Préstamo |
| w_cam713_rpt_liquidacion_x_productor | CAM713 | Consolidado de Compras por Productor |
| w_cam714_rpt_recuperacion | CAM712 | Reporte de Recuperaciones de Crédito |
| w_cam715_rpt_formato_credito | CAM715 | Reporte de Crédito |
| w_cam752_declaracion | CAM752 | Declaración del Exportador |
| w_cam754_resumen_cont | CAM754 | Resumen de Contenedores |
| w_cam755_resumen_descarte | CAM755 | Resumen de Descarte |
| w_cam756_resumen_exportado | CAM756 | Resumen Exportado |
| w_cam757_fairtrade | CAM757 | Reporte de Cajas FairTrade |
| w_cam758_rpt_control_cont | CAM758 | Reporte Control de Contenedores |
| w_documento | S/C | Documento |

---

## 17. Comedor

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

## 18. Control de Documentos

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

## 19. Flota

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_cm311_orden_compra_frm | CM311 | Formato de orden de compra |
| w_cm314_orden_servicio_frm | CM314 | Formato de orden de servicio |
| w_fl001_motiv_mov | FL001 | Motivos de traslado de embarcación |
| w_fl002_cargo_tripulantes | FL002 | Cargo de tripulantes |
| w_fl003_capit_puerto | FL003 | Capitanías de puerto |
| w_fl004_tasas_peso | FL004 | Tasas aplicables al peso |
| w_fl005_tasas_precio | FL005 | Tasas aplicables al precio |
| w_fl006_bancos | FL006 | Bancos para detracción |
| w_fl007_precios_snp | FL007 | Precios de pesca |
| w_fl008_semanas_pesca | FL008 | Semanas de pesca |
| w_fl009_especie | FL009 | Mantenimiento de especies |
| w_fl010_especie_familia | FL010 | Familias de especies |
| w_fl011_ubigeo | FL011 | Zonas geográficas en tierra |
| w_fl012_zonas_pesca | FL012 | Zonas de pesca |
| w_fl013_puertos | FL013 | Mantenimiento de puertos |
| w_fl014_tripulantes | FL014 | Maestro de tripulantes |
| w_fl015_clientes | FL015 | Mantenimiento de clientes |
| w_fl016_politica_pago | FL016 | Políticas de pago tripulantes |
| w_fl016_tipo_politica | FL016 | Tipos de políticas de pago |
| w_fl017_clientes_referencia | FL017 | Datos de referencia laboral de clientes |
| w_fl018_naves | FL018 | Maestro de naves |
| w_fl019_representantes | FL019 | Representantes y administradores |
| w_fl020_empresa_provee | FL020 | Empresas y códigos de relación |
| w_fl021_plant_presup | FL021 | Plantilla de ratios presupuestales |
| w_fl022_plant_nave_presup | FL022 | Plantillas presupuestales por nave |
| w_fl023_polit_pago | FL023 | Políticas de pago |
| w_fl024_empresa_general | FL024 | Empresas pesqueras del litoral peruano |
| w_fl026_nave_repres | FL026 | Representantes por nave |
| w_fl027_num_bitacora | FL027 | Numerador de bitácora |
| w_fl028_num_parte_pesca | FL028 | Numerador de parte de pesca |
| w_fl029_num_posib_arribo | FL029 | Numerador de posibles arribos |
| w_fl030_clien_general | FL030 | Clientes general |
| w_fl031_bonificaciones | FL031 | Bonificaciones fijas de tripulantes |
| w_fl032_parametros | FL032 | Parámetros de flota |
| w_fl033_plant_presup | FL033 | Plantillas presupuestales |
| w_fl034_param_espec | FL034 | Parámetros específicos |
| w_fl035_clien_general_v2 | FL035 | Clientes general v2 |
| w_fl036_ratios_bonif_tripul | FL036 | Ratios bonificación por especialidad |
| w_fl037_sueldos_fijos | FL037 | Sueldos fijos de tripulantes |
| w_fl038_incentivos_pers_adm | FL038 | Incentivos personal administrativo |
| w_fl039_conceptos_flota | FL039 | Aportaciones y descuentos para tripulantes |
| w_fl040_estruct_nave | FL040 | Asignación de estructuras a nave |
| w_fl041_derecho_pesca | FL041 | Tasas de derecho de pesca |
| w_fl042_dias_motorista | FL042 | Días para bonificaciones (sueldo fijo) |
| w_fl300_pesca_proy | FL300 | Pesca proyectada |
| w_fl301_aprob_pesca_proy | FL301 | Aprobación de pesca proyectada |
| w_fl302_cuota_imarpe | FL302 | Cuota de IMARPE |
| w_fl303_captura_empresas | FL303 | Captura realizada por otras empresas |
| w_fl304_parte_pesca | FL304 | Partes de pesca |
| w_fl304_parte_pesca_bk | FL304 | Partes de pesca (backup) |
| w_fl305_trip_zarpe | FL305 | Tripulantes en el zarpe |
| w_fl306_venta_arribo | FL305 | Venta de materia prima |
| w_fl307_posib_arribo | FL307 | Registro de posibles arribos |
| w_fl308_anula_arribos | FL308 | Anulación de arribos en bloque |
| w_fl310_bitacora | FL310 | Registro de bitácoras |
| w_fl311_aprobar_parte | FL311 | Aprobación de partes de pesca |
| w_fl312_asisten_trip | FL312 | Asistencia de tripulantes |
| w_fl313_pes_proy_varia | FL313 | Variación de proyecciones de pesca |
| w_fl314_asist_anterior | FL314 | Asistencias anteriores |
| w_fl315_bus_trip_zarp | FL315 | Asistencia de zarpes anteriores |
| w_fl316_vista_asist_trip | FL316 | Vista completa de asistencia de tripulantes |
| w_fl317_asign_ot_nave | FL317 | Asignación de orden de trabajo y nave |
| w_fl318_zarpes_anteriores | S/C | Zarpes anteriores |
| w_fl319_gstos_drcts_bahia | FL319 | Gastos directos de bahía |
| w_fl320_asistencia_bonificacion | FL320 | Asistencia mensual (bonificaciones fijo) |
| w_fl500_buscar_zarpe | S/C | Búsqueda de zarpes |
| w_fl501_buscar_arribo | S/C | Búsqueda de arribos |
| w_fl502_buscar_parte | FL502 | Búsqueda por partes de pesca |
| w_fl503_eficiencia_pesca_nave | FL503 | Eficiencia de pesca de flota propia |
| w_fl504_emp_capt_ano | S/C | Captura de empresas por año |
| w_fl505_emp_capt_rango | S/C | Captura de empresas por rango |
| w_fl506_descarga_nave | FL506 | Descarga por mes |
| w_fl507_eficiencia_salida | FL507 | Eficiencia de salida |
| w_fl508_descarga_meses | FL508 | Descarga por meses |
| w_fl509_ratio_captura_arribo | FL509 | Ratio captura vs arribo |
| w_fl510_descarga_total | FL510 | Descarga por periodo |
| w_fl511_captura_especie | FL511 | Captura por especie (gráfico pie) |
| w_fl512_eficiencia_cala | FL512 | Eficiencia de calas |
| w_fl514_captura_zonas | FL514 | Captura por zonas de pesca |
| w_fl516_captura_naves | FL516 | Captura por especie y nave |
| w_fl517_captura_pesca | FL517 | Consulta de captura de pesca |
| w_fl518_tiempo_cala | S/C | Tiempo de cala |
| w_fl519_compara_pesca | S/C | Comparación de pesca |
| w_fl520_venta_mp | FL511 | Venta de materia prima por cliente |
| w_fl521_variacion_grafica | FL521 | Variaciones del presupuesto (gráfica) |
| w_fl700_bitacora | S/C | Reporte de bitácora |
| w_fl701_pend_arribos | FL701 | Embarcaciones pendientes de arribo |
| w_fl702_posibles_arribos | S/C | Posibles arribos |
| w_fl703_inidcador_material | S/C | Indicadores de materiales |
| w_fl704_costo_diario | FL704 | Costo diario de flota propia |
| w_fl705_costo_ot | FL705 | Costo por orden de trabajo |
| w_fl705_inid_trim_material | S/C | Indicadores trimestrales de materiales |
| w_fl706_declar_jurada_sem | FL706 | Declaración jurada semanal |
| w_fl707_resum_partic | FL707 | Resumen de participación de pesca |
| w_fl708_arribo_emb | FL701 | Embarcaciones pendientes de arribo |
| w_fl709_pesca_anual | FL709 | Pesca anual |
| w_fl710_pesca_periodo | FL710 | Resumen de pesca por periodo |
| w_fl711_bonif_especial | FL711 | Bonificación especial de tripulantes |
| w_fl712_compr_egre_admin | FL711 | Comprobantes de egreso administrativos |
| w_fl712_compr_egre_trip | FL712 | Comprobantes de egreso tripulantes |
| w_fl713_pago_sem_cbssp | FL713 | Pago semanal a la CBSSP |
| w_fl714_comp_egre_cbssp | FL714 | Comprobante de egreso CBSSP |
| w_fl715_pago_derecho_pesca | FL715 | Declaración de derecho de pesca |
| w_fl716_comp_derecho_pesca | FL716 | Comprobantes de derecho de pesca |
| w_fl717_bonif_administrativos | FL717 | Incentivos personal administrativo |
| w_fl718_compr_egre_admin | FL718 | Comprobantes egreso incentivos administrativos |
| w_fl719_descarga_plantas | FL719 | Descarga por planta pesquera |
| w_fl720_indica_general | FL720 | Indicadores de gestión US$/TM |
| w_fl721_ratios_detalle | FL721 | Ratio de petróleo diesel 2 (detalle) |
| w_fl722_consumo_d2 | FL722 | Consumo de petróleo D2 general |
| w_fl723_rpt_diario_arribos | FL723 | Reporte diario de arribos |
| w_fl724_pago_mensual_cbssp | FL724 | Beneficios mensuales a la CBSSP |
| w_fl725_asistencia_periodo | FL725 | Asistencia de tripulantes por periodo |
| w_fl726_consist_pago_trip | FL726 | Consistencia de pagos de tripulantes |
| w_fl727_detalle_pesca | FL727 | Detalle de pesca por periodo |
| w_fl728_parte_pesca | FL728 | Partes de pesca (reporte) |
| w_fl729_resumen_planilla | FL729 | Resumen cálculo de participación |
| w_fl900_semanas | FL900 | Generación de semanas de pesca |
| w_fl901_presupuesto_new | FL901 | Generación de presupuesto |
| w_fl902_consistencia_pesca | FL902 | Consistencia de pesca |
| w_fl903_calculo_planillas | FL903 | Cálculo de planillas de tripulantes |
| w_fl903_presupuesto_mod | S/C | Registro de variaciones en el presupuesto |
| w_fl904_transf_pla_ext | FL904 | Transferencia a planillas externas |
| w_fl905_asig_plan_oper | FL904 | Asignación de planilla operativa |
| w_fl906_presupuesto_varia | FL906 | Variaciones presupuestales |
| w_fl907_grafica_ppto_var | FL907 | Variaciones mensuales (gráfica) |
| w_fl908_grafica_ppto_compos | FL908 | Variación por partida presupuestal (gráfica) |
| w_fl909_generar_presupuesto | FL901 | Generación de presupuesto |
| w_fl910_prspto_variacion | FL910 | Variaciones presupuestales |
| w_fl911_generar_variaciones | FL911 | Generación de variaciones |
| w_fl912_compr_egreso | FL912 | Generar comprobante de egreso |
| w_fl913_gen_asiento_bonif | S/C | Generar asiento de bonificación |
| w_fl914_gen_asiento_trip | FL914 | Asientos de bonificación de tripulantes |
| w_fl915_anular_asiento_trip | FL915 | Anular asientos de bonificación de tripulantes |
| w_fl916_gen_asiento_adm | FL916 | Asientos de incentivos de administrativos |
| w_fl917_anular_asiento_adm | FL917 | Anular asientos de incentivo administrativo |
| w_fl918_sueldos_fijos | FL918 | Cálculo de sueldos fijos |
| w_fl919_generar_asientos_mp | FL919 | Generar ingresos/salidas en almacén |

---

## 20. Seguridad

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
| 3 | Compras | 163 |
| 4 | Comercialización / Ventas | 153 |
| 5 | Contabilidad | 236 |
| 6 | Finanzas | 157 |
| 7 | RRHH | 283 |
| 8 | Presupuesto | 156 |
| 9 | Producción | 194 |
| 10 | Operaciones OT | 153 |
| 11 | Mantenimiento | 93 |
| 12 | Aprovisionamiento | 94 |
| 13 | Asistencia | 38 |
| 14 | Auditoría | 19 |
| 15 | BASC | 16 |
| 16 | Campo | 96 |
| 17 | Comedor | 29 |
| 18 | Control de Documentos | 15 |
| 19 | Flota | 138 |
| 20 | Seguridad | 21 |
| | **TOTAL** | **2,247** |

---

*Documento actualizado el 08/02/2026*
*Se excluyen ventanas genéricas del framework: w_abc_*, w_logon, w_main, w_about, w_fondo, w_search*, w_help_*, w_pop_*, w_rpt_preview*, w_seleccion*, w_filtros, w_get_*, w_datos_*, w_password_chg, etc.*
*Todos los módulos han sido analizados.*
