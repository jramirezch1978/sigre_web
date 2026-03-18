# Inventario de Ventanas del ERP SIGRE

Inventario de ventanas PowerBuilder (.srw) de negocio organizadas por módulo.
Se excluyen ventanas genéricas del framework (w_abc_*, w_logon, w_main, popups, búsquedas, etc.).

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
| w_al009_numeracion_origen | AL009 | Numeradores por origen |
| w_al010_templa_saldo | AL010 | Mantenimiento de saldo de templas |
| w_al012_motivo_traslado | AL012 | Motivo de traslado |
| w_al013_almacenes_tacitos | AL013 | Almacenes tácitos |
| w_al020_logparam | AL020 | Mantenimiento Logparam |
| w_al021_articulo_venta_precios | AL021 | Precios de venta de artículos |
| w_al022_ubicacion_articulos | AL022 | Ubicación de artículos |
| w_al023_almacen_transport | AL023 | Transportistas permitidos por almacén |
| w_al024_posiciones_almacen | AL024 | Posiciones por almacén |
| w_al025_modificar_almacen_ov | AL025 | Modificar datos en orden de venta |
| w_al301_solicitud_salida | AL301 | Solicitud de salida |
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
| w_al504_devoluciones_prestamos | AL504 | Artículos prestados |
| w_al506_consignacion | AL506 | Artículos en consignación |
| w_al507_despachos | AL507 | Despachos |
| w_al508_articulos_mov | AL508 | Consulta especializada de artículos |
| w_al509_guias_pend_ticket | AL509 | Guías faltantes de ticket de balanza |
| w_al510_pendientes_atencion | AL510 | Requerimiento de artículos pendiente |
| w_al511_ctacte_transportista | AL511 | Cuenta corriente de transportista |
| w_al512_saldos_descuadrados | AL512 | Saldos descuadrados |
| w_al513_precios_articulos_desc | AL513 | Saldos descuadrados (precios artículos) |
| w_al514_precios_oc_ni | AL514 | Descuadre entre precio OC y NI |
| w_al515_precios_acc_ni | AL515 | Descuadre entre Partes de Cosecha y NI |
| w_al515_vale_mov | AL515 | Consulta de vales de almacén |
| w_al701_movimiento_x_cencos | AL701 | Gastos por centros de costo |
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
| w_al756_stock_pallet_posicion | AL756 | Saldo por posición, artículo y pallet |
| w_al757_inventario_pallets | AL757 | Reporte de inventarios por pallets y posición |
| w_al758_disponibilidad_articulos_subcat | AL758 | Stock subcategoría - Marca |
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

---

## 3. Compras

*(Ver archivo detallado: `01. documentacion/ventanas_compras_analisis.md`)*

---

## 4. Comercialización / Ventas

*(Ver archivo detallado: `ws_objects/Comercializacion/VENTANAS_COMERCIALIZACION.md`)*

---

## 5. Contabilidad

*(Ver archivo detallado: `ws_objects/Contabilidad/VENTANAS_CONTABILIDAD.md`)*

---

## 6. Finanzas

*(Ver archivo detallado pendiente de generar)*

---

## 7. RRHH

*(Ver archivo detallado: `ws_objects/Rrhh/VENTANAS_RRHH.md`)*

---

## 8. Presupuesto

*(Ver archivo detallado: `ws_objects/Presupuesto/VENTANAS_PRESUPUESTO.md`)*

---

## 9. Producción

*(Ver archivo detallado: `ws_objects/Produccion/VENTANAS_PRODUCCION.md`)*

---

## 10. Operaciones OT

*(Ver archivo detallado pendiente de generar)*

---

## 11. Mantenimiento

*(Ver archivo detallado pendiente de generar)*

---

## 12. Aprovisionamiento

*(Ver archivo detallado pendiente de generar)*

---

## 13. Asistencia

*(Ver archivo detallado pendiente de generar)*

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

*(Ver archivo detallado pendiente de generar)*

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

## 21. CRM Web

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_articulos | CRM | Artículos |
| w_cartera_clientes | CRM | Registro de Cartera de Clientes |
| w_categoria_articulo | CRM | Categorías |
| w_clientes | CRM | Nuevo Cliente |
| w_cotizacion | CRM | Cotización |
| w_crm001_seguimientos | CRM001 | Seguimiento |
| w_mantenimiento_clientes | CRM | Mantenimiento de clientes |
| w_rpt_clientes | CRM | Reporte de Clientes |
| w_rpt_cotizacion | CRM | Cotización Generada |
| w_sub_categoria_articulo | CRM | Sub Categorías |
| w_visitas | CRM | Visitas |

---

## 22. Flota

*(Ver archivo detallado pendiente de generar)*

---

## 23. Horeca

| Ventana | Código | Descripción |
|---------|--------|-------------|
| w_ho001_maestro_cuartos | HO001 | Maestro de Cuartos |
| w_ho301_alojamiento_huespedes | HO301 | Alojamiento de Huéspedes y Servicios |

---

## 24. Seguridad

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

| # | Módulo | Ventanas (aprox.) |
|---|--------|-------------------|
| 1 | Activo Fijo | 31 |
| 2 | Almacén | 125 |
| 3 | Compras | ~180 |
| 4 | Comercialización / Ventas | ~160 |
| 5 | Contabilidad | ~250 |
| 6 | Finanzas | ~160 |
| 7 | RRHH | ~280 |
| 8 | Presupuesto | ~145 |
| 9 | Producción | ~190 |
| 10 | Operaciones OT | ~145 |
| 11 | Mantenimiento | ~85 |
| 12 | Aprovisionamiento | ~85 |
| 13 | Asistencia | ~50 |
| 14 | Auditoría | 19 |
| 15 | BASC | 16 |
| 16 | Campo | ~85 |
| 17 | CashLoan | 7 |
| 18 | Comedor | 29 |
| 19 | Consola Web | 16 |
| 20 | Control de Documentos | 15 |
| 21 | CRM Web | 11 |
| 22 | Flota | ~130 |
| 23 | Horeca | 2 |
| 24 | Seguridad | 21 |
| | **TOTAL** | **~2,260** |

---

*Documento generado el 08/02/2026*
*Los módulos con "Ver archivo detallado" tienen sus tablas en archivos separados (ya limpiados).*
*Se excluyen ventanas genéricas del framework: w_abc_*, w_logon, w_main, w_about, w_fondo, w_search*, w_help_*, w_pop_*, w_rpt_preview*, w_seleccion*, w_filtros, w_get_*, w_datos_*, w_password_chg, etc.*
