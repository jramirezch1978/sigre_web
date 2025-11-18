$PBExportHeader$w_ve310_cntas_cobrar.srw
forward
global type w_ve310_cntas_cobrar from w_abc
end type
type cb_vales_salida from commandbutton within w_ve310_cntas_cobrar
end type
type cb_2 from commandbutton within w_ve310_cntas_cobrar
end type
type cb_1 from commandbutton within w_ve310_cntas_cobrar
end type
type rb_operaciones from radiobutton within w_ve310_cntas_cobrar
end type
type rb_pptt from radiobutton within w_ve310_cntas_cobrar
end type
type rb_servicios from radiobutton within w_ve310_cntas_cobrar
end type
type cb_operaciones from commandbutton within w_ve310_cntas_cobrar
end type
type cb_guia from commandbutton within w_ve310_cntas_cobrar
end type
type gb_2 from groupbox within w_ve310_cntas_cobrar
end type
type cb_ov from commandbutton within w_ve310_cntas_cobrar
end type
type cb_guia_ov from commandbutton within w_ve310_cntas_cobrar
end type
type tab_1 from tab within w_ve310_cntas_cobrar
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detail_referencias from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detail_referencias dw_detail_referencias
end type
type tabpage_3 from userobject within tab_1
end type
type cb_5 from commandbutton within tabpage_3
end type
type dw_det_imp from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_5 cb_5
dw_det_imp dw_det_imp
end type
type tabpage_4 from userobject within tab_1
end type
type dw_totales from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_totales dw_totales
end type
type tabpage_5 from userobject within tab_1
end type
type dw_cnt_ctble_cab from u_dw_abc within tabpage_5
end type
type dw_cnt_ctble_det from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_cnt_ctble_cab dw_cnt_ctble_cab
dw_cnt_ctble_det dw_cnt_ctble_det
end type
type tabpage_7 from userobject within tab_1
end type
type dw_datos_exp from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_datos_exp dw_datos_exp
end type
type tabpage_6 from userobject within tab_1
end type
type dw_exportacion from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_exportacion dw_exportacion
end type
type tab_1 from tab within w_ve310_cntas_cobrar
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_7 tabpage_7
tabpage_6 tabpage_6
end type
type dw_master from u_dw_abc within w_ve310_cntas_cobrar
end type
type gb_1 from groupbox within w_ve310_cntas_cobrar
end type
end forward

global type w_ve310_cntas_cobrar from w_abc
integer width = 5243
integer height = 3124
string title = "[VE310] Registro de  Cuentas Cobrar (Ventas)"
string menuname = "m_mantenimiento_cl_anular_ext"
event ue_anular ( )
event ue_find_exact ( )
event ue_anul_trans ( )
event ue_preview ( )
event ue_print_detraccion ( )
event ue_print_detra ( )
event ue_print_voucher ( )
cb_vales_salida cb_vales_salida
cb_2 cb_2
cb_1 cb_1
rb_operaciones rb_operaciones
rb_pptt rb_pptt
rb_servicios rb_servicios
cb_operaciones cb_operaciones
cb_guia cb_guia
gb_2 gb_2
cb_ov cb_ov
cb_guia_ov cb_guia_ov
tab_1 tab_1
dw_master dw_master
gb_1 gb_1
end type
global w_ve310_cntas_cobrar w_ve310_cntas_cobrar

type variables
u_ds_base       ids_articulos_x_guia, ids_const_dep, ids_voucher, ids_comprobante
		 
DatawindowChild idw_forma_pago
Integer			 ii_lin_x_doc = 10000   //colocar en tabla de parametros
String          is_doc_parte_pesca = 'PPE', is_doc_fac, is_doc_bvc, &
					 is_doc_gr,  is_salir, is_doc_cxc, is_nro_detraccion = ''
					 
Boolean			 ib_estado_prea = TRUE, ib_modif_detraccion = false, &
					 ib_cierre = false
Long            il_fila

n_cst_asiento_contable 	invo_asiento_cntbl
n_cst_detraccion 			invo_detraccion
n_cst_utilitario			invo_util
n_cst_wait					invo_Wait

					 // False = Impuesto No ha Sido Editado
					 // True	 = Impuesto ha Sido Editado
					 													
u_dw_abc			idw_exportacion, idw_det_imp	, idw_detail, idw_referencias,  &
					idw_totales,	idw_asiento_cab, idw_asiento_det, idw_datos_exp
					
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function string of_cbenef_origen (string as_origen)
public function integer of_valida_datos ()
public subroutine of_hab_des_botones (integer al_opcion)
public function integer of_get_param ()
public function boolean of_facturacion_operacion (string as_oper_sec, long al_item, string as_tipo_doc, string as_nro_doc)
public subroutine of_calcular_detraccion ()
public function decimal of_total_doc ()
public subroutine of_total_ref ()
public function boolean of_generacion_asiento ()
public function boolean of_get_direccion (string as_cod_relacion, long al_row)
public function boolean of_nro_doc (string as_tipo_doc, string as_nro_serie, ref string as_mensaje)
public function boolean of_modify_precio ()
public function string of_verifica_user ()
public subroutine of_bol_cobrar (string as_tipo_doc, string as_nro_doc, str_parametros astr_param)
public subroutine of_ver_cant_x_ov (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_ov, string as_accion, decimal adc_cantidad, ref string as_flag_cant)
public function decimal of_totales ()
public function integer of_count_update ()
public subroutine of_fact_cobrar (string as_tipo_doc, string as_nro_doc, str_parametros astr_param)
public subroutine of_fact_cobrar_preview (string as_tipo_doc, string as_nro_doc)
public subroutine of_generacion_imp (string as_item)
public function string of_recupera_nro_ov ()
public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc)
public function boolean of_enviar_sunat_ose (string as_tipo_doc, string as_nro_doc)
end prototypes

event ue_anular;String  	ls_flag_estado,ls_origen, ls_tipo_doc,ls_nro_doc,ls_result, ls_mensaje, &
			ls_cod_trabajador, ls_nom_trabajador
Long    	ll_inicio,ll_count,ll_ano,ll_mes
Date		ld_Fec_emision
Integer 	li_opcion, li_dias_max_anulacion, li_dias

try 
	dw_master.Accepttext()
	idw_Detail.AcceptText()
	
	IF dw_master.RowCount() = 0 THEN 
		Messagebox('Aviso','El Documento no tiene CABECERA, no se puede anular, por favor verifique!', StopSign!)
		Return 
	end if
	
	IF idw_detail.RowCount() = 0 THEN 
		Messagebox('Aviso','El Documento no tiene DETALLE, no se puede anular, por favor verifique!', StopSign!)
		Return 
	end if
	
	IF is_action = 'new' THEN 
		Messagebox('Aviso','Debe grabar el documento antes de anularlo, por favor verifique!', StopSign!)
		Return 
	end if
	
	IF (dw_master.ii_update 		= 1 OR idw_detail.ii_update 		= 1 OR &
		 idw_referencias.ii_update = 1 OR idw_det_imp.ii_update 		= 1 OR &
		 idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1 ) THEN
		 
		 Messagebox('Aviso','Existen cambios pendientes de guardar en el comprobante de venta. Por favor guardelos previamente', StopSign!)
		 RETURN
		 
	END IF
	
	
	if ib_cierre then 
		Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad', StopSign!)
		return
	end if
	
	ls_flag_estado = dw_master.object.flag_estado 			[1]
	ll_ano			= dw_master.object.ano 			 			[1]
	ll_mes			= dw_master.object.mes 			 			[1]
	ls_origen   	= dw_master.object.origen   				[1]
	ls_tipo_doc 	= dw_master.object.tipo_doc 				[1]
	ls_nro_doc  	= dw_master.object.nro_doc  				[1]
	ld_fec_emision	= Date(dw_master.object.fecha_documento[1])
	
	
	/*verifica cierre*/
	invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
	
	IF ls_result = '0' THEN RETURN //el mes contable esta cerrado o no se encuentra habilitado
	
	if ls_flag_estado <> '1' then
		if ls_flag_estado = '2' or ls_flag_estado = '3' then
			Messagebox('Aviso','Documento ya ha pasado por tesorería - Cartera de Cobros, por favor verifique', StopSign!)
			return
		else
			Messagebox('Aviso','Documento no se encuentra activo, no se puede anular, por favor verifique', StopSign!)
			return
		end if
		
	end if
	
	/*Verifica Si ha tenido Transaciones*/
	SELECT Count(*)
	  INTO :ll_count
	  FROM doc_referencias
	 WHERE origen_ref = :ls_origen   
		AND tipo_ref   = :ls_tipo_doc 
		AND nro_ref	 	= :ls_nro_doc  ;
		
	/**/
	IF ll_count > 0 THEN
		SELECT tipo_doc, nro_doc
		  INTO :ls_tipo_doc, :ls_nro_doc
		  FROM doc_referencias
		 WHERE origen_ref = :ls_origen   
			AND tipo_ref   = :ls_tipo_doc 
			AND nro_ref	 	= :ls_nro_doc  ;
	
		Messagebox('Aviso','Este comprobante no se puede anular, porque ha sido colocado ' &
							  + 'como referencia al documento ' + ls_tipo_doc + '/' + ls_nro_doc &
							  + ', por favor Verifique!', StopSign!)
		Return
	END IF
	
	/*Verifica Si ha sido tomado como cuenta corriente*/
	SELECT Count(*)
	  INTO :ll_count
	  FROM cnta_crrte
	 WHERE tipo_doc   = :ls_tipo_doc 
		AND nro_doc 	= :ls_nro_doc  ;
		
	/**/
	IF ll_count > 0 THEN
		SELECT m.cod_trabajador, m.nom_trabajador
		  INTO :ls_cod_trabajador, :ls_nom_trabajador
		  FROM 	cnta_crrte cc,
					vw_pr_trabajador m
		 WHERE cc.cod_trabajador 	= m.cod_trabajador
			and cc.tipo_doc   		= :ls_tipo_doc 
			AND cc.nro_doc 			= :ls_nro_doc  ;
	
		Messagebox('Aviso','Este comprobante no se puede anular, porque ha sido colocado ' &
							  + 'como cuenta corriente al trabajador [' + ls_cod_trabajador + '] ' + ls_nom_trabajador &
							  + ', por favor Verifique!', StopSign!)
		Return
	END IF
	
	//Valido los días
	li_dias_max_anulacion = gnvo_app.of_get_parametro("VTA_MAX_DIAS_ANULACION", 7)
	
	if li_dias_max_anulacion > 0 then
		select trunc(sysdate - :ld_fec_emision) + 1
		  into :li_dias
		from dual;
		
		
		if li_dias > li_dias_max_anulacion then
			Messagebox('Aviso','No se puede eliminar este comprobante porque excede la cantidad de días maximo para anulación ' &
							  + '~r~nDías maximo para anulacion : ' + string(li_dias_max_anulacion) &
							  + '~r~nDías desde Fecha emisión: ' + string(li_dias), StopSign!)
		end if
	end if
	
	
	
	
	
	
	//Hago la pregunta
	li_opcion = MessageBox('Anulación',&
								  'Esta Seguro de Anular el Comprobante ' + ls_tipo_doc + '-' &
								  + ls_nro_doc + '?',Question!, Yesno!, 2)
	
	IF li_opcion = 2 THEN RETURN
	
	
	//facturacion de operacion
	update facturacion_operacion fo
		set 	fo.tipo_doc 			= null ,
				fo.nro_doc 				= null,
				fo.flag_replicacion 	= '1'
	 where fo.tipo_doc	= :ls_tipo_doc
		and fo.nro_doc		= :ls_nro_doc ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al actualizar tabla FACTURACION_OPERACION: ' + ls_mensaje, StopSign!)
		RETURN
	END IF
	
	
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		 idw_detail.object.cantidad		  [ll_inicio] = 0.00
		 idw_detail.object.cantidad_und2	  [ll_inicio] = 0.00
		 idw_detail.object.precio_unitario [ll_inicio] = 0.00
		 idw_detail.object.descuento		  [ll_inicio] = 0.00
		 idw_detail.object.redondeo_manual [ll_inicio] = 0.00
		 idw_detail.ii_update = 1
	NEXT
	
	
	DO WHILE idw_referencias.Rowcount() > 0
		idw_referencias.Deleterow(0)
		idw_referencias.ii_update = 1
	LOOP
	
	FOR ll_inicio = 1 TO idw_det_imp.Rowcount()
		 idw_det_imp.object.importe		   [ll_inicio] = 0.00
		 idw_det_imp.ii_update = 1
	NEXT
	
	//Anulo el detalle del asiento contable
	FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
		 idw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
		 idw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
		 idw_asiento_det.ii_update = 1
	NEXT
	
	//Anulo la cabecera del asiento contable
	idw_asiento_cab.object.tot_soldeb 	[1] = 0.00
	idw_asiento_cab.object.tot_solhab 	[1] = 0.00
	idw_asiento_cab.object.tot_doldeb 	[1] = 0.00
	idw_asiento_cab.object.tot_dolhab 	[1] = 0.00
	idw_asiento_cab.object.flag_estado 	[1] = '0'
	idw_asiento_cab.ii_update = 1
	
	//Anulo la cabecera del documento
	dw_master.object.flag_estado	[1] 				= '0' // Anulado
	dw_master.object.importe_doc	[1] 				= 0.00
	dw_master.object.saldo_sol		[1] 				= 0.00
	dw_master.object.saldo_dol		[1] 				= 0.00
	dw_master.ii_update = 1
	
	is_action = 'anular'
	
	ib_estado_prea = FALSE



catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Excepcion al anular el comprobante')
	
end try

end event

event ue_find_exact();// Asigna valores a structura 
String ls_tipo_doc,ls_nro_doc,ls_origen,ls_cod_relacion
Long   ll_row_master,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_ctas_x_cobrar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 1
OpenWithParm( w_help_datos, sl_param)
sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN		
	//TIPO_DOC
	ll_row_master = dw_master.getrow()
	ls_tipo_doc  	 = dw_master.object.tipo_doc		[ll_row_master]
	ls_nro_doc   	 = dw_master.object.nro_doc		[ll_row_master]
	ls_origen	 	 = dw_master.object.origen			[ll_row_master] 
	ll_ano		 	 = dw_master.object.ano          [ll_row_master]
	ll_mes		 	 = dw_master.object.mes          [ll_row_master]
	ll_nro_libro 	 = dw_master.object.nro_libro    [ll_row_master]
	ll_nro_asiento  = dw_master.object.nro_asiento  [ll_row_master]
	ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master] 

	of_retrieve(ls_tipo_doc   ,ls_nro_doc)
	
	ib_estado_prea = False   //asiento editado					
	TriggerEvent('ue_modify')
ELSE
	dw_master.Reset()
	idw_detail.Reset()
	idw_referencias.Reset()
	idw_det_imp.Reset()
	idw_totales.Reset()
	idw_asiento_cab.Reset()
	idw_asiento_det.Reset()
	
	rb_servicios.Checked = FALSE //Servicios Sin Referencias
	rb_pptt.Checked = FALSE //Productos Terminados
	rb_operaciones.Checked = FALSE //Productos Terminados
	
	ib_estado_prea = False   //asiento editado						
END IF
















end event

event ue_anul_trans();String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc,ls_result,&
		  ls_mensaje    ,ls_nro_detrac,ls_flag_detrac
Long    ll_row,ll_count,ll_inicio,ll_ano,ll_mes
Integer li_opcion

dw_master.Accepttext()
idw_detail.Accepttext()
idw_referencias.Accepttext()
idw_det_imp.Accepttext()
idw_asiento_cab.Accepttext()
idw_asiento_det.Accepttext()

ll_row 			 = dw_master.Getrow()

//NO EXISTE REGISTRO PARA ANULAR TRANSACION
IF ll_row = 0 OR is_action = 'new' THEN 
	Messagebox('Aviso','No procede esta acción, por favor ingrese algun documento previamente',Exclamation!)
	RETURN 
END IF

ls_flag_estado = dw_master.object.flag_estado	  	[ll_row]
ll_ano			= dw_master.object.ano 				  	[ll_row]
ll_mes			= dw_master.object.mes 				  	[ll_row]
ls_nro_detrac  = dw_master.object.nro_detraccion  	[ll_row]
ls_flag_detrac	= dw_master.object.flag_detraccion 	[ll_row]
ls_origen   	= dw_master.object.origen   			[ll_row]
ls_tipo_doc 	= dw_master.object.tipo_doc 			[ll_row]
ls_nro_doc  	= dw_master.object.nro_doc  			[ll_row]
				
/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario

IF Not(ls_flag_estado = '1' OR ls_flag_estado = '0') OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

IF (dw_master.ii_update 		= 1 OR idw_detail.ii_update 		= 1 OR &
	 idw_referencias.ii_update = 1 OR idw_det_imp.ii_update 		= 1 OR &
	 idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1 ) THEN
	 
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular Toda el Comprobante de Pago',Exclamation!)
	 RETURN
	 
END IF

/*Verifica Si ha tenido Transaciones*/
SELECT Count(*)
  INTO :ll_count
  FROM doc_referencias
 WHERE origen_ref = :ls_origen   
   AND tipo_ref   = :ls_tipo_doc 
	AND nro_ref	 	= :ls_nro_doc  ;
/**/
IF ll_count > 0 THEN
	
	SELECT tipo_doc, nro_doc
	  INTO :ls_tipo_doc, :ls_nro_doc
	  FROM doc_referencias
	 WHERE origen_ref = :ls_origen   
		AND tipo_ref   = :ls_tipo_doc 
		AND nro_ref	 	= :ls_nro_doc  ;
	
	Messagebox('Aviso','Comprobante de Venta ha sido usado como referencia para el documento ' &
				+ ls_tipo_doc + '/' + ls_nro_doc + ', por favor verifique!', StopSign!)
   Return
END IF


li_opcion = MessageBox('Anula Transación','Esta Seguro de Eliminar totalmente el comprobante de venta?',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN //no desea anular transacion

//facturacion de operacion
update facturacion_operacion fo
   set 	fo.tipo_doc 		= null ,
			fo.nro_doc 			= null,
			flag_replicacion 	= '1'
 where fo.tipo_doc	= :ls_tipo_doc
   and fo.nro_doc		= :ls_nro_doc ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al actualizar tabla facturacion_operacion. Mensaje: ' + SQLCA.SQLErrText, StopSign!)
	RETURN
END IF

/*Elimino Cabecera de Cntas x Cobrar*/
if dw_master.RowCount() > 0 then
	is_nro_detraccion = dw_master.object.nro_detraccion [1]
else
	is_nro_detraccion = ''
end if

DO WHILE dw_master.Rowcount() > 0
	dw_master.Deleterow(0)
	dw_master.ii_update = 1
LOOP

/*Elimino detalle de Cntas x cobrar*/
DO WHILE idw_detail.Rowcount() > 0
	idw_detail.Deleterow(0)
	idw_detail.ii_update = 1
LOOP

/*Elimino Impuesto de Cntas Cobrar*/
DO WHILE idw_det_imp.Rowcount() > 0
	idw_det_imp.Deleterow(0)
	idw_det_imp.ii_update = 1
LOOP

/*Elimino documentos de Referencias*/
DO WHILE idw_referencias.Rowcount() > 0
	idw_referencias.Deleterow(0)
	idw_referencias.ii_update = 1
LOOP

// Elimino Factura de exportacion
idw_exportacion.Deleterow(0)
idw_exportacion.ii_update  = 1

//Cabecera de Asiento
idw_asiento_cab.Object.flag_estado	[1] = '0'
idw_asiento_cab.Object.tot_solhab	[1] = 0.00
idw_asiento_cab.Object.tot_dolhab	[1] = 0.00
idw_asiento_cab.Object.tot_soldeb	[1] = 0.00
idw_asiento_cab.Object.tot_doldeb  	[1] = 0.00

//Detalle de Asiento
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
  	idw_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
  	idw_asiento_det.Object.imp_movdol [ll_inicio] = 0.00		
	idw_asiento_det.ii_update = 1
NEXT
//


is_action = 'delete'
dw_master.ii_update 			= 1
idw_detail.ii_update 		= 1
idw_referencias.ii_update 	= 1
idw_det_imp.ii_update 		= 1
idw_asiento_cab.ii_update 	= 1
idw_asiento_det.ii_update 	= 1
idw_exportacion.ii_update	= 1

ib_estado_prea = FALSE //no autogeneracion de asientos

idw_asiento_det.ii_protect = 0
idw_asiento_det.of_protect()
end event

event ue_print_detraccion();
String ls_nro_detrac

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_nro_detrac =dw_master.object.nro_detraccion[dw_master.getrow()]

IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
	Messagebox('Aviso','No existe Detraccion Verifique!')
END IF
ids_const_dep.Retrieve(gs_empresa,ls_nro_detrac)
ids_const_dep.Print(True)
end event

event ue_print_detra();//String ls_nro_detrac
//
//IF dw_master.getrow() = 0 THEN
//	Messagebox('Aviso','No existe Registro Verifique!')
//	Return
//END IF
//
//ls_nro_detrac = dw_master.object.nro_detraccion[dw_master.getrow()]
//
//IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
//	Messagebox('Aviso','No existe Detraccion Verifique!')
//END IF
//
//ids_formato_det.Retrieve(ls_nro_detrac)
//ids_formato_det.object.t_nombre.text = gs_empresa
//ids_formato_det.object.t_user.text = gs_user
//ids_formato_det.Print(True)

String 				ls_nro_detrac
str_parametros		lstr_param
u_ds_base			lds_detraccion

try 
	
	lds_detraccion = create u_ds_base
	
	IF dw_master.getrow() = 0 THEN
		Messagebox('Aviso','No existe Registro Verifique!')
		Return
	END IF
	
	ls_nro_detrac = dw_master.object.nro_detraccion[dw_master.getrow()]
	
	IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
		Messagebox('Aviso','No existe Detraccion Verifique!')
		return
	END IF
	
	Open(w_print_preview)
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.i_return < 0 then return
	
	if lstr_param.i_return = 1 then
		lds_detraccion.DataObject = 'd_rpt_formato_detraccion_cobrar_tbl'
		lds_detraccion.SetTransObject(SQLCA)
		lds_detraccion.Retrieve(ls_nro_detrac)
		
		if lds_detraccion.rowcount() = 0 then 
			gnvo_app.of_message_error('No hay registros que mostrar para esta detraccion')
			return
		end if
		
		lds_detraccion.object.t_nombre.text = gs_empresa
		lds_detraccion.object.t_user.text 	= gs_user
		lds_detraccion.Print(True)
		
	else
		lstr_param.dw1 		= 'd_rpt_formato_detraccion_cobrar_tbl'
		lstr_param.titulo 	= 'Previo de Detraccion'
		lstr_param.string1 	= ls_nro_detrac
		lstr_param.tipo		= '1S'
	
		OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
	end if



catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	
finally
	destroy lds_detraccion
end try


end event

event ue_print_voucher();String 				ls_origen
Long   				ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros		lstr_param

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

//Solicita si es impresión directa o previsualización
Open(w_print_preview)
lstr_param = Message.PowerObjectParm
if lstr_param.i_return < 0 then return

ls_origen 		= dw_master.object.origen 	    [dw_master.getrow()]
ll_ano			= dw_master.object.ano	  	    [dw_master.getrow()]
ll_mes			= dw_master.object.mes	  	    [dw_master.getrow()]
ll_nro_libro	= dw_master.object.nro_libro   [dw_master.getrow()]
ll_nro_asiento	= dw_master.object.nro_asiento [dw_master.getrow()]

if lstr_param.i_return = 1 then
	ids_voucher.retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,gs_empresa)
	
	//Valido que el voucher tenga algun registro
	if ids_voucher.rowcount() = 0 then 
		gnvo_app.of_mensaje_error('Voucher no tiene registro Verifique', 'FIN_304_02')
		return
	end if
	
	ids_voucher.Object.p_logo.filename = gs_logo
	
	if ids_voucher.of_ExistsText("t_titulo1") then
		ids_voucher.object.t_titulo1.text = "Provisión de Cuentas x Cobrar"
		ids_voucher.object.t_titulo1.visible = '1'
	end if	

	ids_voucher.Print(True)
else
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cc_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.integer1 	= ll_ano
	lstr_param.integer2 	= ll_mes
	lstr_param.integer3 	= ll_nro_libro
	lstr_param.integer4 	= ll_nro_asiento
	lstr_param.string2	= gs_empresa
	lstr_param.titulo		= "Provisión de Cuentas x Cobrar"
	lstr_param.tipo		= '1S1I2I3I4I2S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if



end event

public subroutine of_asigna_dws ();idw_det_imp	 	 	= tab_1.tabpage_3.dw_det_imp
idw_exportacion 	= tab_1.tabpage_6.dw_exportacion
idw_detail		   = tab_1.tabpage_1.dw_detail
idw_referencias   = tab_1.tabpage_2.dw_detail_referencias
idw_totales		   = tab_1.tabpage_4.dw_totales
idw_asiento_cab 	= tab_1.tabpage_5.dw_cnt_ctble_cab
idw_asiento_det 	= tab_1.tabpage_5.dw_cnt_ctble_det
idw_datos_exp		= tab_1.tabpage_7.dw_datos_exp


end subroutine

public function string of_cbenef_origen (string as_origen);String ls_cen_ben

select cen_bef_gen_vtas 
	into :ls_cen_ben
from origen 
where cod_origen = :as_origen ;
  

Return ls_cen_ben  
end function

public function integer of_valida_datos ();// Valida datos de cliente, moneda, tipo_cambio

String   ls_cod_cliente, ls_cod_moneda
Long     ll_row_master
Decimal 	ldc_tasa_cambio 

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN 0

ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN 0
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN 0
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio <= 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio', StopSign!)
	RETURN 0
END IF


IF rb_servicios.checked = TRUE OR rb_pptt.checked = TRUE OR rb_operaciones.checked = TRUE THEN
	Messagebox('Aviso','Verifique Opciones Sin Referencias Una de Ellas esta Activa')
	Return 0		 
END IF

//Almacena tipo de documento Parte de Pesca.. PPE
/*SELECT  DOC_PARTE_PESCA
  INTO :is_doc_parte_pesca
FROM 	  FL_PARAM
WHERE RECKEY = '1';
  
  
IF Sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido DOC_PARTE_PESCA en FL_PARAM")
	RETURN 0
END IF*/

RETURN 1
end function

public subroutine of_hab_des_botones (integer al_opcion);// Funcion para habilitar y deshabilitar los botones
// al_opcion :  1 = habilita, 0 = deshabilita

IF al_opcion = 0 THEN
	cb_guia_ov.Enabled = False
	cb_guia.enabled = False
	cb_ov.enabled = False
	cb_operaciones.enabled = False
	rb_servicios.enabled = False
	rb_pptt.enabled = False	
	rb_operaciones.enabled = False	
ELSE
	cb_guia_ov.Enabled = True
	cb_guia.enabled = True
	cb_ov.enabled = True
	cb_operaciones.enabled = True
	rb_servicios.enabled = True
	rb_pptt.enabled = True	
	rb_operaciones.enabled = True	
END IF

if gs_empresa = "BLUEWAVE" or gs_empresa ="PEZEX" then
	
	//Cualquier venta será con Orden de Venta
	cb_ov.enabled 		= false
	//cb_guia.enabled 	= false
	rb_pptt.enabled 	= false
	
end if
end subroutine

public function integer of_get_param ();try 
	
	SELECT doc_fact_cobrar, doc_bol_cobrar, doc_cxc
	  INTO :is_doc_fac,:is_doc_bvc, :is_doc_cxc
	  FROM finparam 
	 WHERE (reckey = '1') ;
	 
	IF Isnull(is_doc_fac) OR Trim(is_doc_fac) = '' THEN
		Messagebox('Aviso','Documentos de Factura x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
		Return 0
	END IF
	
	IF Isnull(is_doc_bvc) OR Trim(is_doc_bvc) = '' THEN
		Messagebox('Aviso','Documentos de Boleta x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
		Return 0
	END IF
	
	IF Isnull(is_doc_cxc) OR Trim(is_doc_cxc) = '' THEN
		Messagebox('Aviso','Grupo de Documentos Cntas x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
		Return 0
	END IF
	
	return 1
	
catch ( Exception ex )
	gnvo_app.of_mensaje_error( "Ha ocurrido una exception: " + ex.getMessage())
	
	return 0
end try


end function

public function boolean of_facturacion_operacion (string as_oper_sec, long al_item, string as_tipo_doc, string as_nro_doc);
UPDATE facturacion_operacion
   SET tipo_doc = :as_tipo_doc ,
		 nro_doc = :as_nro_doc
 WHERE oper_sec = :as_oper_sec 
 	AND item     = :al_item     ;
		  
		  
IF gnvo_app.of_ExistsError(SQLCA, 'Error en actualización facturacion_operacion') then
	Rollback;
   return false
END IF		  

Return true
end function

public subroutine of_calcular_detraccion ();//Actualizo el importe de la detraccion
decimal 	ldc_total, ldc_tasa_cambio, ldc_imp_soles, ldc_porc_detr
string	ls_moneda

if dw_master.getRow() = 0 then return

if ib_modif_detraccion = true then return

ldc_total = of_total_doc ()
if dw_master.object.flag_detraccion [1] = '1' then
	
	ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio [1])
	ls_moneda		 = dw_master.object.cod_moneda	[1]
	ldc_porc_detr	 = Dec(dw_master.object.porc_detraccion [1])
	
	if ls_moneda = gnvo_app.is_soles then
		ldc_imp_soles = round(ldc_total * ldc_porc_detr/ 100, invo_detraccion.of_nro_decimales())
	else
		ldc_total 	  = ldc_total * ldc_tasa_cambio
		ldc_imp_soles = round(ldc_total * ldc_porc_detr/ 100, invo_detraccion.of_nro_decimales())
	end if
	
	dw_master.object.imp_detraccion [1] = ldc_imp_soles
	dw_master.ii_update = 1
	
	
end if

end subroutine

public function decimal of_total_doc ();Long 	  	ll_inicio
String  	ls_signo
Decimal 	ldc_impuesto        = 0.00,  ldc_total_imp     = 0.00 ,ldc_bruto = 0.00 , &
		   ldc_total_bruto     = 0.00, ldc_total_general = 0.00 


FOR ll_inicio = 1 TO idw_detail.Rowcount()
	
	 ldc_bruto 		= Round(idw_detail.object.total [ll_inicio],4)
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
	 
NEXT


FOR ll_inicio = 1 TO idw_det_imp.Rowcount()
	
	 ldc_impuesto = idw_det_imp.Object.importe [ll_inicio]
	 ls_signo	  = idw_det_imp.Object.signo   [ll_inicio]	
	 
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
	 IF     ls_signo = '+' THEN
		 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT


ldc_total_general = ldc_total_bruto + ldc_total_imp


Return ldc_total_general

end function

public subroutine of_total_ref ();String      ls_moneda_fap, ls_moneda_ref, ls_flag_detraccion, ls_nro_ref, &
				ls_tipo_ref, ls_expresion, ls_nro_item
Long        ll_row_master , ll_i, ll_found
Decimal		ldc_tasa_cambio, ldc_importe, ldc_impuestos

IF idw_referencias.Rowcount() = 0 THEN return
ll_row_master = dw_master.Getrow()

if ll_row_master = 0 then return
ls_moneda_fap		= dw_master.object.cod_moneda			[ll_row_master]
ldc_tasa_cambio 	= Dec(dw_master.object.tasa_cambio	[ll_row_master])

if IsNull(ldc_tasa_cambio) or ldc_tasa_cambio =0 then 
	gnvo_app.of_message_error( "No ha indicado la tasa de cambio por favor verifique!")
	return
end if

//Inicializo los importes de la referencia
for ll_i = 1 to idw_referencias.RowCount()
	idw_referencias.object.importe [ll_i] = 0
next

for ll_i = 1 to idw_detail.RowCount() 
	ls_tipo_ref = idw_detail.object.tipo_doc_amp [ll_i]
	ls_nro_ref 	= idw_detail.object.tipo_doc_amp [ll_i]
	
	//Obtengo el importe
	ldc_importe = Dec(idw_detail.Object.total	 	[ll_i])
	
	//Obtengo el impuesto
	ldc_impuestos = 0
	ls_nro_item = String(idw_detail.Object.nro_item	[ll_i])
	ls_expresion = "item=" + ls_nro_item
	ll_found	= idw_det_imp.Find(ls_expresion, 1, idw_det_imp.RowCount())
	
	do while ll_found > 0 and ll_found <= idw_det_imp.RowCount( )
		ldc_impuestos += Dec(idw_det_imp.object.importe [ll_found])
		
		ll_found ++
		if ll_found <= idw_det_imp.RowCount() then
			ll_found	= idw_det_imp.Find(ls_expresion, ll_found, idw_det_imp.RowCount())
		end if
	loop
	
	//ADiciono el impuesto al importe
	ldc_importe += ldc_impuestos
	
	//Buscamos la referencia para actualizar el monto
	ls_expresion = "tipo_ref='" + ls_tipo_ref +"' and nro_ref='" + ls_nro_ref +"'"
	ll_found	= idw_referencias.Find(ls_expresion, 1, idw_referencias.RowCount())
	if ll_found > 0 then
		//Calculo el importe para la referencia
		ls_moneda_ref		= idw_referencias.object.cod_moneda_det	[ll_found]
		IF ls_moneda_fap = ls_moneda_ref THEN
			idw_referencias.object.importe [ll_found] = Dec(idw_referencias.object.importe [ll_found]) + ldc_importe
		ELSEIF ls_moneda_ref = gnvo_app.is_soles		THEN
			idw_referencias.object.importe [ll_found] = Dec(idw_referencias.object.importe [ll_found]) + ldc_importe / ldc_tasa_cambio
		ELSEIF ls_moneda_ref = gnvo_app.is_dolares	THEN
			idw_referencias.object.importe [ll_found] = Dec(idw_referencias.object.importe [ll_found]) + ldc_importe * ldc_tasa_cambio
		END IF
	end if
	
	
	idw_referencias.ii_update =1	                
next    


end subroutine

public function boolean of_generacion_asiento ();Long    ll_row,ll_count
String  ls_moneda,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,&
		  ls_cencos,ls_cebef
Decimal ldc_tasa_cambio
Boolean lb_retorno

of_asigna_dws()

ll_row   = dw_master.Getrow()

dw_master.Accepttext()
idw_detail.Accepttext()

IF ll_row   = 0 THEN RETURN FALSE


ls_moneda 		 = dw_master.object.cod_moneda  [1]
ldc_tasa_cambio = dw_master.object.tasa_cambio [1]

IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda', StopSign!)
	dw_master.SetFocus()
	dw_master.Setcolumn('cod_moneda')
	Return FALSE
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio', StopSign!)
	dw_master.SetFocus()
	dw_master.Setcolumn('tasa_cambio')
	Return FALSE
END IF


ls_tipo_doc 	  = dw_master.object.tipo_doc     [1]
ls_nro_doc  	  = dw_master.object.nro_doc	    [1]  
ls_cod_relacion  = dw_master.object.cod_relacion [1]

lb_retorno = invo_asiento_cntbl.of_generar_asiento_cxp_cxc( dw_master, &
																				idw_detail, &
																				idw_referencias, &
																				idw_det_imp, &
																				idw_asiento_cab, &
																				idw_asiento_det, &
																				tab_1, &
																				'C')
IF lb_retorno = TRUE THEN
	idw_asiento_det.ii_update = 1
END IF


Return lb_retorno
end function

public function boolean of_get_direccion (string as_cod_relacion, long al_row);String 	ls_direccion
Integer	li_item

IF Isnull(as_cod_relacion) OR Trim(as_cod_relacion)  = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!', StopSign!)
	Return false
END IF

// Solo Tomo la Direccion de facturacion
SELECT D.ITEM, pkg_logistica.of_get_direccion(d.codigo, d.item)
	into :li_item, :ls_direccion
FROM DIRECCIONES D 
WHERE D.CODIGO = :as_cod_relacion
  AND D.FLAG_USO in ('1', '3');
  
if SQLCA.SQLCode = 100 then
	dw_master.object.item_direccion	[al_row] = gnvo_app.il_null
	dw_master.object.direccion			[al_row] = gnvo_app.is_null
	return false
end if
										
dw_master.object.item_direccion	[al_row] = li_item
dw_master.object.direccion			[al_row] = ls_direccion
dw_master.ii_update = 1
ib_estado_prea = TRUE

return true
end function

public function boolean of_nro_doc (string as_tipo_doc, string as_nro_serie, ref string as_mensaje);Long    	ll_ult_nro
Integer 	li_dig_serie, li_dig_numero
String 	ls_numero, ls_numero_old, ls_mensaje, ls_serie
Boolean 	lb_retorno = TRUE

if dw_master.RowCount() = 0 then 
	rollback;
	as_mensaje = "No existe registros en la cabecera, por favor Verifique!"
	return false
end if

ls_numero_old = dw_master.object.numero [1]

SELECT ultimo_numero
  INTO :ll_ult_nro
  FROM num_doc_tipo
 WHERE tipo_doc  = :as_tipo_doc   
   AND nro_serie = :as_nro_serie for update;

if SQLCA.SQLCode = 100 then
	ll_ult_nro = 1
	
	insert into num_doc_tipo(
		tipo_doc, nro_Serie, ultimo_numero)
	values(
		:as_tipo_doc, :as_nro_serie, 1);
		
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		as_mensaje = 'Error al insertar numerador en tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje
		return false
	end if
end if

	
//****************************//
//Actualiza Tabla num_doc_tipo//
//****************************//

UPDATE num_doc_tipo
SET 	 ultimo_numero = :ll_ult_nro + 1
WHERE  tipo_doc  = :as_tipo_doc  
  AND  nro_serie = :as_nro_serie ;
	

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	as_mensaje = 'Error al actualizar numerador en tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje
	return false
end if

/**/
ls_serie = Trim(as_nro_serie)
ls_numero = invo_util.lpad(string(ll_ult_nro), 8, '0')

if not IsNull(ls_numero_old) and trim(ls_numero_old) <> '' then
	if ls_numero_old <> ls_numero then
		if MessageBox('Error', "El numero del documento obtenido es diferente al numero inicial." &
								+ "~r~nNumero Inicial: " + ls_numero_old &
								+ "~r~nNumero Final: " + ls_numero &
								+ "~r~nEsto se puede deber a que se ha saltado el numerador, requiere una verificación. " &
								+ "~r~nDesea continuar con la grabación?", Information!, YesNo!, 2) = 2 then 
								
			rollback;
			as_mensaje = 'El usuario ha cancelado la grabación del comprobante de pago.'
			return false
			
		end if
	end if
end if


dw_master.object.nro_doc [1] =  gnvo_app.utilitario.of_get_nro_doc( ls_serie, ls_numero )

Return true


end function

public function boolean of_modify_precio ();Decimal			ldc_valor_fob, ldc_valor_flete, ldc_valor_seguro, ldc_cantidad, ldc_precio_unit, &
					ldc_new_valor_fob, ldc_new_valor_flete, ldc_new_valor_seguro, ldc_new_precio_unit
Long				ll_i
String 			ls_flag_seguro_flete
Str_parametros	lstr_param

ldc_valor_fob 		= 0
ldc_valor_flete	= 0
ldc_valor_seguro	= 0

//Obtengo el total FOB, el seguro y el Flete
for ll_i = 1 to idw_detail.RowCount()
	ldc_cantidad 			= Dec(idw_detail.object.cantidad 			[ll_i])
	ldc_precio_unit		= Dec(idw_detail.object.precio_unitario 	[ll_i])
	ls_flag_seguro_flete	= idw_detail.object.flag_seguro_flete 		[ll_i]
	
	if ls_flag_seguro_flete = '0' then
		ldc_valor_fob += ldc_cantidad * ldc_precio_unit
	elseif ls_flag_seguro_flete = 'F' then
		ldc_valor_flete += ldc_cantidad * ldc_precio_unit
	elseif ls_flag_seguro_flete = 'S' then
		ldc_valor_seguro += ldc_cantidad * ldc_precio_unit
	end if
next

//Coloco el valor en la cabecera
dw_master.object.valor_fob	[1] = ldc_valor_fob
dw_master.object.flete		[1] = ldc_valor_flete
dw_master.object.seguro		[1] = ldc_valor_seguro
dw_master.ii_update = 1

//El usuario tiene que confirmar el total 
lstr_param.valor_fob 	= ldc_valor_fob
lstr_param.valor_flete 	= ldc_valor_flete
lstr_param.valor_seguro = ldc_valor_seguro

OpenWithParm(w_abc_totales_factura, lstr_param)

if IsNull(Message.PowerObjectParm) then return false

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return false

//Tomo los valores del usuario y hago el prorrateo

ldc_new_valor_fob 	= lstr_param.valor_fob
ldc_new_valor_flete 	= lstr_param.valor_flete
ldc_new_valor_seguro	= lstr_param.valor_seguro

for ll_i = 1 to idw_detail.RowCount()
	ldc_cantidad 			= Dec(idw_detail.object.cantidad 			[ll_i])
	ldc_precio_unit		= Dec(idw_detail.object.precio_unitario 	[ll_i])
	ls_flag_seguro_flete	= idw_detail.object.flag_seguro_flete 		[ll_i]
	
	if ls_flag_seguro_flete = '0' then
		
		if ldc_valor_fob > 0 then
			ldc_new_precio_unit	= ((ldc_cantidad * ldc_precio_unit) / ldc_valor_fob * ldc_new_valor_fob) / ldc_cantidad
			idw_detail.object.precio_unitario 	[ll_i] = ldc_new_precio_unit
		end if
		
	elseif ls_flag_seguro_flete = 'F' then
		
		if ldc_valor_flete > 0 then
			ldc_new_precio_unit	= ((ldc_cantidad * ldc_precio_unit) / ldc_valor_flete * ldc_new_valor_flete) / ldc_cantidad
			idw_detail.object.precio_unitario 	[ll_i] = ldc_new_precio_unit
		end if
		
	elseif ls_flag_seguro_flete = 'S' then
		
		if ldc_valor_seguro > 0 then
			ldc_new_precio_unit	= ((ldc_cantidad * ldc_precio_unit) / ldc_valor_seguro * ldc_new_valor_seguro) / ldc_cantidad
			idw_detail.object.precio_unitario 	[ll_i] = ldc_new_precio_unit
		end if
		
	end if
next

dw_master.object.valor_fob	[1] = ldc_new_valor_fob
dw_master.object.flete		[1] = ldc_new_valor_flete
dw_master.object.seguro		[1] = ldc_new_valor_seguro

return true
end function

public function string of_verifica_user ();String ls_doc_ventas,ls_mensaje = ''
Long   ll_count

/**/
SELECT doc_ventas
  INTO :ls_doc_ventas
  FROM finparam
 WHERE reckey = '1' ;

IF Isnull(ls_doc_ventas) OR Trim(ls_doc_ventas) = '' THEN
	ls_mensaje = 'Debe Ingresar Grupo de Documento de Venta en Archivo de Parametros'
	Return ls_mensaje	
END IF
	
/**/
SELECT Count(*)
  INTO :ll_count
  FROM doc_tipo_usuario
 WHERE (cod_usr = :gs_user) ;

 IF ll_count = 0 THEN
	 ls_mensaje = 'Usuario No Ha Sido definido en tipo de Documento a Visualizar'
	Return ls_mensaje	 	
 END IF
 
/**/
SELECT Count(*)
  INTO :ll_count
  FROM doc_grupo_relacion
 WHERE (doc_grupo_relacion.tipo_doc = (SELECT tipo_doc FROM doc_tipo_usuario  WHERE cod_usr = :gs_user )) ;


 IF ll_count = 0 THEN
	 ls_mensaje = 'Tipos de Documentos del Usuario No tiene Relacion en Archivo DOC_GRUPO_RELACION'
	 Return ls_mensaje	 	
 END IF
 
 
 Return ls_mensaje

  
         

end function

public subroutine of_bol_cobrar (string as_tipo_doc, string as_nro_doc, str_parametros astr_param);String 				ls_mensaje, ls_dataObject
str_parametros		lstr_param

DECLARE usp_fin_tt_bol_x_cobrar PROCEDURE FOR 
	usp_fin_tt_bol_x_cobrar(:as_tipo_doc,
									:as_nro_doc);
EXECUTE usp_fin_tt_bol_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Fallo Store Procedure',"Store Procedure usp_fin_tt_ctas_x_cobrar. Mensaje de Error: "  &
		+ ls_mensaje + ", por favor verifique!" )
	RETURN
END IF

IF gs_empresa = 'FISHOLG' then
	IF mid(as_nro_doc,0,3) = '001' THEN
		ls_dataObject = 'd_rpt_bol_cobrar_fisholg_001_ff'
	ELSEIF mid(as_nro_doc,0,3) = '002' THEN
		ls_dataObject = 'd_rpt_bol_cobrar_fisholg_002_ff'
	END IF

elseIF gs_empresa = 'BLUEWAVE' or gs_empresa = 'PEZEX' THEN
	
	ls_dataObject = 'd_rpt_fact_cobrar_bw_ff'

elseIF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
	
	ls_dataObject = 'd_rpt_fact_cobrar_canagrande_ff'
	
ELSE
	ls_dataObject = 'd_rpt_bol_cobrar_ff'
END IF

if astr_param.i_return = 1 then
	ids_comprobante.dataobject = ls_dataObject
	
	IF gs_empresa = 'FISHOLG' then
		IF mid(as_nro_doc,0,3) = '001' THEN
			ids_comprobante.Object.DataWindow.Print.Paper.Size = 256 
			ids_comprobante.Object.DataWindow.Print.CustomPage.Width = 204
			ids_comprobante.Object.DataWindow.Print.CustomPage.Length = 165
		ELSEIF mid(as_nro_doc,0,3) = '002' THEN
			ids_comprobante.Object.DataWindow.Print.Paper.Size = 256 
			ids_comprobante.Object.DataWindow.Print.CustomPage.Width = 107
			ids_comprobante.Object.DataWindow.Print.CustomPage.Length = 149
		END IF

	elseIF gs_empresa = 'BLUEWAVE' THEN
		
		ids_comprobante.Object.DataWindow.Print.Paper.Size = 1 

	elseIF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
		
		ids_comprobante.Object.DataWindow.Print.Paper.Size = 256 
		ids_comprobante.Object.DataWindow.Print.CustomPage.Width = 250
		ids_comprobante.Object.DataWindow.Print.CustomPage.Length = 150
		
	END IF
	
	ids_comprobante.Settransobject(sqlca)
	
	//*Imprime Factura*//
	f_imp_bol_fact()
	
	ids_comprobante.Retrieve()
	ids_comprobante.Print(True)
	
else
	lstr_param.dw1 		= ls_dataobject
	lstr_param.titulo 	= 'Previo de Boleta: [' + as_tipo_doc + '-' + as_nro_doc + "]"
	lstr_param.tipo		= ''

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
END IF

end subroutine

public subroutine of_ver_cant_x_ov (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_ov, string as_accion, decimal adc_cantidad, ref string as_flag_cant);DECLARE PB_USP_FIN_CANT_X_ART_X_OV PROCEDURE FOR USP_FIN_CANT_X_ART_X_OV 
(:as_tipo_doc,:as_nro_doc,:as_cod_art,:as_nro_ov,:as_accion,:adc_cantidad);
EXECUTE PB_USP_FIN_CANT_X_ART_X_OV ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_CANT_X_ART_X_OV INTO :as_flag_cant ;
CLOSE PB_USP_FIN_CANT_X_ART_X_OV ;
end subroutine

public function decimal of_totales ();Long 	  	ll_inicio
String  	ls_signo, ls_flag_detraccion, ls_moneda
Decimal 	ldc_impuesto        = 0.00, ldc_total_imp = 0     ,ldc_bruto           = 0 , &
		   ldc_total_bruto     = 0.00, ldc_descuento = 0     ,ldc_total_descuento = 0 , &
		   ldc_redondeo        = 0.00, ldc_total_redondeo = 0,ldc_total_general	 = 0, &
			ldc_monto_dtrc				  , ldc_tasa_cambio

idw_totales.Reset()
idw_totales.Insertrow(0)

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	
	 ldc_bruto 		= Round(idw_detail.object.cantidad	[ll_inicio] * idw_detail.object.precio_unitario [ll_inicio] , 8)
	 ldc_descuento = idw_detail.object.descuento		   [ll_inicio]
	 ldc_redondeo	= idw_detail.object.redondeo_manual [ll_inicio]
	 
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 IF isnull(ldc_descuento) THEN ldc_descuento = 0 		 
	 IF isnull(ldc_redondeo)  THEN ldc_redondeo  = 0 		 
	 
	 ldc_descuento   		= Round((ldc_bruto * ldc_descuento  ) / 100,4)
	 
	 ldc_total_redondeo	+= ldc_redondeo
	 ldc_total_descuento	+= ldc_descuento 
	 ldc_total_bruto 		+= ldc_bruto
NEXT


FOR ll_inicio = 1 TO idw_det_imp.Rowcount()
	 ldc_impuesto = idw_det_imp.Object.importe [ll_inicio]
	 ls_signo	  = idw_det_imp.Object.signo   [ll_inicio]	
	 
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
	 
	 IF ls_signo = '+' THEN
		 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT

//Obtengo la detraccion
ls_flag_detraccion = dw_master.object.flag_detraccion [1]

if ls_flag_detraccion = '1' then
	ldc_monto_dtrc  = Dec(dw_master.object.imp_detraccion [1])
	ls_moneda		 = dw_master.object.cod_moneda			[1]
	ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio 	[1])
	
	if IsNull(ldc_monto_dtrc) then ldc_monto_dtrc = 0
	
	if ls_moneda = gnvo_app.is_dolares then
		if IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0 then
			ldc_monto_dtrc = 0
		else
			ldc_monto_dtrc = ldc_monto_dtrc / ldc_tasa_cambio
		end if
	end if
else
	ldc_monto_dtrc = 0
end if


idw_totales.object.bruto    		[1] = ldc_total_bruto
idw_totales.object.impuesto 		[1] = ldc_total_imp
idw_totales.object.descuento		[1] = ldc_total_descuento
idw_totales.object.redondeo 		[1] = ldc_total_redondeo

ldc_total_general = DEc(ldc_total_bruto + ldc_total_imp - ldc_total_descuento + ldc_total_redondeo) - ldc_monto_dtrc

IF Isnull(ldc_total_general) THEN ldc_total_general = 0.00

Return ldc_total_general

end function

public function integer of_count_update ();Integer li_update,li_update_pre_asiento


IF dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR idw_referencias.ii_update = 1 OR idw_det_imp.ii_update = 1 THEN
	li_update = 4
END IF	



Return li_update
end function

public subroutine of_fact_cobrar (string as_tipo_doc, string as_nro_doc, str_parametros astr_param);String ls_mensaje, ls_dataobject
str_parametros lstr_param

DECLARE usp_fin_tt_ctas_x_cobrar PROCEDURE FOR 
	usp_fin_tt_ctas_x_cobrar(	:as_tipo_doc,
										:as_nro_doc);
EXECUTE usp_fin_tt_ctas_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Fallo Store Procedure', &
				  'Store Procedure usp_fin_tt_ctas_x_cobrar. Error: ' + ls_mensaje &
				  + ', Comunicar en Area de Sistemas' )
	RETURN
END IF

IF gs_empresa = 'FISHOLG' THEN
	ls_dataObject = 'd_rpt_fact_cobrar_fisholg_ff'
	
elseIF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
	
	ls_dataObject = 'd_rpt_fact_cobrar_canagrande_ff'
	
elseIF gs_empresa = 'BLUEWAVE' or gs_empresa = "PEZEX" THEN
	
	ls_dataObject = 'd_rpt_fact_cobrar_bw_ff'
	
else
	ls_dataObject = 'd_rpt_fact_cobrar_ff'
end if

if astr_param.i_return = 1 then
	ids_comprobante.dataobject = ls_dataObject
	ids_comprobante.Object.DataWindow.Print.Paper.Size = 1
	ids_comprobante.Object.DataWindow.Print.Orientation = 2
	
	ids_comprobante.Settransobject(sqlca)
	
	//*Imprime Factura*//
	f_imp_bol_fact()
	
	ids_comprobante.Retrieve()
	ids_comprobante.Print(True)
	
else
	lstr_param.dw1 		= ls_dataobject
	lstr_param.titulo 	= 'Previo de Factura: [' + as_tipo_doc + '-' + as_nro_doc + "]"
	lstr_param.tipo		= ''

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
END IF

	
end subroutine

public subroutine of_fact_cobrar_preview (string as_tipo_doc, string as_nro_doc);//d_rpt_fact_cobrar_ff

DECLARE pb_usp_fin_tt_ctas_x_cobrar PROCEDURE FOR usp_fin_tt_ctas_x_cobrar
(:as_tipo_doc,:as_nro_doc);
EXECUTE pb_usp_fin_tt_ctas_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure usp_fin_tt_ctas_x_cobrar , Comunicar en Area de Sistemas' )
	RETURN
END IF

//*Imprime Factura*//
//dw_factura.visible = TRUE
//dw_factura.Retrieve()
//dw_factura.Modify("DataWindow.Print.Preview=Yes")
//dw_factura.Modify("datawindow.print.preview.zoom = 100" )



end subroutine

public subroutine of_generacion_imp (string as_item);String      ls_item,ls_expresion, ls_tipo_doc ,ls_flag_mercado
Long 			ll_inicio,ll_found
Decimal  	ldc_total,ldc_tasa_impuesto,ldc_redondeo

if dw_master.RowCount() = 0 then return

ls_flag_mercado = dw_master.object.flag_mercado [1]

if ls_flag_mercado = 'E' then return

ls_expresion = 'item = '+as_item

idw_det_imp.Setfilter(ls_expresion)
idw_det_imp.filter()

Setnull(ls_expresion)
	
	
FOR ll_inicio = 1 TO idw_det_imp.Rowcount()

	 idw_det_imp.ii_update = 1
	 ls_item		  = Trim(String(idw_det_imp.object.item [ll_inicio]))
	 ls_expresion = 'nro_item = ' + ls_item
	 ll_found 	  = idw_detail.find(ls_expresion ,1,idw_detail.rowcount())
	 
	 
	 
	 IF ll_found > 0 THEN
		 ldc_tasa_impuesto = idw_det_imp.object.tasa_impuesto  [ll_inicio]
		 ldc_total			 = idw_detail.object.total		       [ll_found ]
		 ldc_redondeo		 = idw_detail.object.redondeo_manual [ll_found ]

		 
		 IF Isnull(ldc_total)    THEN ldc_total    = 0.00
		 IF Isnull(ldc_redondeo) THEN ldc_redondeo = 0.00
		 ldc_total = Round(ldc_total - ldc_redondeo,2)

		 
		 idw_det_imp.object.importe [ll_inicio] = Round((ldc_total * ldc_tasa_impuesto ) / 100 ,2)
		
	 END IF			 
NEXT
	
idw_det_imp.Setfilter('')
idw_det_imp.filter()


idw_det_imp.SetSort('item a')
idw_det_imp.Sort()


end subroutine

public function string of_recupera_nro_ov ();String ls_tipo_doc, ls_nro_doc

IF idw_detail.Rowcount() > 0 THEN
	ls_tipo_doc = idw_Detail.object.tipo_doc_amp		[1]
	ls_nro_doc	= idw_Detail.object.nro_doc_amp		[1]
	
	if ls_tipo_doc = gnvo_app.is_doc_ov then
		return ls_nro_doc
	else
		return gnvo_app.is_null
	end if
ELSE
	return gnvo_app.is_null
END IF

 

end function

public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc);String 	ls_periodo,ls_expresion, ls_cod_art,ls_flag_mercado, &
			ls_cod_relacion, ls_origen
Long 	 	ll_inicio, ll_row, ll_year, ll_mes, ll_nro_libro, ll_nro_Asiento


//Reinicio los datawindow
idw_detail.Reset()
idw_referencias.Reset()
idw_det_imp.Reset()
idw_asiento_cab.Reset()
idw_asiento_det.Reset()

dw_master.retrieve(as_tipo_doc,as_nro_doc)

if dw_master.RowCount() = 0 then return

dw_master.il_row = 1

ls_cod_relacion 	= dw_master.object.cod_relacion 		[1]
ls_origen 			= dw_master.object.origen				[1]
ll_year	 			= Long(dw_master.object.ano			[1])
ll_mes	 			= Long(dw_master.object.mes			[1])
ll_nro_libro		= Long(dw_master.object.nro_libro	[1])
ll_nro_asiento 	= Long(dw_master.object.nro_asiento	[1])

if invo_asiento_cntbl.of_mes_cerrado( ll_year, ll_mes, "R") then
	ib_cierre = true
	dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	dw_master.object.t_cierre.text = ''
	ib_cierre = false
end if


//Habilito los botones 
if gnvo_app.ventas.is_flag_efact = '1' then
	dw_master.object.b_envio_efact.visible = "Yes"
	dw_master.object.b_download.Visible = "Yes"
	
//	this.object.b_envio_efact.Enabled = "No"
//	this.object.b_download.Enabled = "No"
	

else

	dw_master.object.b_envio_efact.visible = "No"
	dw_master.object.b_download.Visible = "No"

end if

if dw_master.object.flag_estado [1] = '0' or (left(dw_master.object.nro_doc [1],1) <> 'F' and left(dw_master.object.nro_doc [1],1) <> 'B') then
	dw_master.object.b_envio_efact.Enabled = "No"
	dw_master.object.b_download.Enabled = "No"
else

	if dw_master.object.flag_enviar_efact [1] = '1' then
		
		dw_master.object.b_envio_efact.Enabled = "No"
		dw_master.object.b_download.Enabled = "Yes"
	else
		dw_master.object.b_envio_efact.Enabled = "Yes"
		dw_master.object.b_download.Enabled = "No"
	end if

	if dw_master.object.flag_data_xml [1] = '1' or &
		dw_master.object.flag_data_cdr [1] = '1' or &
		dw_master.object.flag_data_pdf [1] = '1' then
	
		dw_master.object.b_download.Enabled = "Yes"
		
	else
		dw_master.object.b_download.Enabled = "No"
	end if
	
	
end if


idw_detail.retrieve(as_tipo_doc,as_nro_doc)
idw_referencias.retrieve(as_tipo_doc, as_nro_doc, ls_cod_relacion)
idw_det_imp.retrieve(as_tipo_doc, as_nro_doc)
idw_asiento_cab.retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)	
idw_asiento_det.retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)	

of_totales()



ls_expresion = "tipo_ref = '" + is_doc_gr + "'"

idw_referencias.Setfilter(ls_expresion)
idw_referencias.Filter()

IF idw_referencias.rowcount() > 0 THEN
	For ll_inicio = 1 TO idw_detail.Rowcount()
		 idw_detail.object.flag [ll_inicio] = 'G'			//Guia de Remisión
	Next
	
END IF

idw_referencias.SetFilter('')
idw_referencias.Filter()

IF idw_detail.Rowcount() > 0 THEN
	IF idw_referencias.rowcount() = 0 THEN
		ls_cod_art = idw_detail.object.cod_art [1]
		IF Not(Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' ) THEN
			rb_servicios.Checked = FALSE //Servicios Sin Referencias
			rb_pptt.Checked = TRUE  //Productos Terminados
			
			For ll_inicio = 1  TO idw_detail.Rowcount()
				 idw_detail.object.flag_art [ll_inicio] = 'P' //Productos Terminados	
			Next
		ELSE
			rb_servicios.Checked = TRUE  //Servicios Sin Referencias
			rb_pptt.Checked = FALSE //Productos Terminados
		END IF
	ELSE
		rb_servicios.Checked = FALSE //Servicios Sin Referencias
		rb_pptt.Checked = FALSE //Productos Terminados
	END IF	
END IF

ls_flag_mercado = dw_master.object.flag_mercado [1]

if ls_flag_mercado = 'E' or gs_empresa = 'FISHOLG' then
	idw_exportacion.Retrieve(as_tipo_doc, as_nro_doc )
	idw_exportacion.ii_update = 0
	//if idw_exportacion.Rowcount( ) = 0 then idw_exportacion.event ue_insert( )
end if

//Anulo las actualizaciones
dw_master.ResetUpdate()
idw_detail.ResetUpdate()
idw_referencias.ResetUpdate()
idw_det_imp.ResetUpdate()
idw_asiento_cab.ResetUpdate()
idw_asiento_det.ResetUpdate()
idw_exportacion.ResetUpdate()
idw_datos_exp.ResetUpdate()

dw_master.ii_update 			= 0
idw_detail.ii_update 		= 0
idw_referencias.ii_update 	= 0
idw_det_imp.ii_update 		= 0
idw_asiento_cab.ii_update 	= 0
idw_asiento_det.ii_update 	= 0
idw_exportacion.ii_update	= 0
idw_datos_exp.ii_update		= 0

//Lo hago no editable
dw_master.ii_protect			= 0
idw_detail.ii_protect		= 0
idw_referencias.ii_protect	= 0
idw_det_imp.ii_protect		= 0
idw_asiento_cab.ii_protect	= 0
idw_asiento_det.ii_protect	= 0
idw_exportacion.ii_protect	= 0
idw_datos_exp.ii_protect	= 0

dw_master.of_protect()
idw_detail.of_protect()
idw_referencias.of_protect()
idw_det_imp.of_protect()
idw_asiento_cab.of_protect()
idw_asiento_det.of_protect()
idw_exportacion.of_protect()
idw_datos_exp.of_protect()

is_action = 'fileopen'
end subroutine

public function boolean of_enviar_sunat_ose (string as_tipo_doc, string as_nro_doc);Long	ll_rpta

try 
	//Actualiza el flag_envio
	if dw_master.object.flag_estado [1] = '0' then
		gnvo_app.of_mensaje_error( "El comprobante " + as_tipo_doc + "/" + as_nro_doc + " se encuentra anulado, no se puede enviar a EFACT")
		return false
	end if
	
	//ACtualizo el flag para enviar a EFACT
	update cntas_cobrar cc
		set cc.FLAG_ENVIAR_EFACT = '1'
	where cc.tipo_doc = :as_tipo_doc
	  and cc.nro_doc	= :as_nro_doc;
	  
	if gnvo_app.of_existserror( SQLCA, "update cntas_cobrar") then
		ROLLBACK;
		return false
	end if
	
	commit;
	
	// Genero el archivo XML para enviarlo al cliente
	gnvo_app.ventas.of_create_only_xml(gnvo_app.is_null, as_tipo_doc, as_nro_doc)
	
	//Envio por email
	if gnvo_app.of_get_parametro('ALWAYS_QUESTION_SEND_EMAIL', '1') = '1' then
		ll_rpta = MessageBox('Aviso', 'Desea Enviar por email el comprobante eletronico?', Information!, YesNo!, 2)
	else
		ll_rpta = 1
	end if
	
	if ll_rpta = 1 then
		yield()
		invo_wait.of_mensaje("Enviando el documento por email, espere por favor.....")
		yield()
		
		gnvo_app.ventas.of_send_email('', as_tipo_doc, as_nro_doc)
		
		invo_wait.of_close()
		yield()
	end if			
	
	
	dw_master.object.b_envio_efact.Enabled = "No"
	
	gnvo_app.of_message_error( "Factura ha sido activada para envío a EFACT. Por favor verifique su correo en unos minutos")
	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en funcion of_enviar_sunat_ose')
	return false
end try

end function

on w_ve310_cntas_cobrar.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_ext" then this.MenuID = create m_mantenimiento_cl_anular_ext
this.cb_vales_salida=create cb_vales_salida
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rb_operaciones=create rb_operaciones
this.rb_pptt=create rb_pptt
this.rb_servicios=create rb_servicios
this.cb_operaciones=create cb_operaciones
this.cb_guia=create cb_guia
this.gb_2=create gb_2
this.cb_ov=create cb_ov
this.cb_guia_ov=create cb_guia_ov
this.tab_1=create tab_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_vales_salida
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rb_operaciones
this.Control[iCurrent+5]=this.rb_pptt
this.Control[iCurrent+6]=this.rb_servicios
this.Control[iCurrent+7]=this.cb_operaciones
this.Control[iCurrent+8]=this.cb_guia
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.cb_ov
this.Control[iCurrent+11]=this.cb_guia_ov
this.Control[iCurrent+12]=this.tab_1
this.Control[iCurrent+13]=this.dw_master
this.Control[iCurrent+14]=this.gb_1
end on

on w_ve310_cntas_cobrar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_vales_salida)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rb_operaciones)
destroy(this.rb_pptt)
destroy(this.rb_servicios)
destroy(this.cb_operaciones)
destroy(this.cb_guia)
destroy(this.gb_2)
destroy(this.cb_ov)
destroy(this.cb_guia_ov)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;String 			ls_mensaje, ls_tipo_doc_ident, ls_tipo_doc, ls_cred_fiscal, &
					ls_desc_cred_fiscal, ls_Forma_pago, ls_direccion, ls_cliente, &
					ls_observacion, ls_nro_letra, ls_ruc_dni, ls_mnz, ls_lote
					
Long				ll_row, ll_row_ref, ll_nro_libro, ll_dias, ll_item_direccion
str_parametros	lstr_param
u_dw_rpt			ldw_report
date				ld_fecha

try 
	
	invo_wait = create n_cst_wait
	
	if of_get_param() = 0 then 
		is_salir = 'S'
		post event closequery()   
		return
	end if
	
	
	of_asigna_dws()
		
	idw_1 = dw_master              				// asignar dw corriente
	idw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
	
	dw_master.SetTransObject(sqlca)  				                // Relacionar el dw con la base de datos
	idw_detail.SetTransObject(sqlca)
	idw_referencias.SetTransObject(sqlca)
	idw_det_imp.settransobject( sqlca )
	idw_totales.SetTransObject(sqlca)
	idw_asiento_cab.SetTransObject(sqlca)
	idw_asiento_det.SetTransObject(sqlca)
	idw_exportacion.SetTransObject( SQLCA )
	
	//Compatir datos
	dw_master.ShareData (idw_datos_exp)
	
	invo_asiento_cntbl 	= create n_cst_asiento_contable
	invo_detraccion	 	= CREATE n_cst_detraccion
	ids_comprobante 		= create u_ds_base
	
	//** Datastore Articulos x Guia **//
	ids_articulos_x_guia = Create u_ds_base
	ids_articulos_x_guia.DataObject = 'd_art_guia_vale_tbl'
	ids_articulos_x_guia.SettransObject(sqlca)
	////** **//
	
	//** Datastore Detraccion **//
	ids_const_dep = Create u_ds_base
	ids_const_dep.DataObject = 'd_rpt_detraccion_tbl'
	ids_const_dep.SettransObject(sqlca)
	
	//** Datastore Voucher **//
	ids_voucher = Create u_ds_base
	ids_voucher.DataObject = 'd_rpt_voucher_imp_cc_tbl'
	ids_voucher.SettransObject(sqlca)
	
	
	ls_mensaje = of_verifica_user ()
	
	IF Not(Isnull(ls_mensaje) OR Trim(ls_mensaje) = '' ) THEN
		Messagebox('Aviso',ls_mensaje)
	END IF
	
	//** Insertamos GetChild de Forma de Pago **//
	dw_master.Getchild('forma_pago',idw_forma_pago)
	idw_forma_pago.settransobject(sqlca)
	idw_forma_pago.Retrieve()
	//** **//
	
	IF gs_empresa = 'CEPIBO' THEN
		//this.idw_detail.dataobject = 'd_abc_cntas_x_cobrar_det'
		idw_detail.dataobject = 'd_abc_cntas_cobrar_det_cepibo_tbl'
		idw_detail.settransobject(SQLCA)
	
	ELSEIF gs_empresa = 'SEAFROST' THEN
		
		idw_detail.dataobject = 'd_abc_cntas_cobrar_det_seafrost_tbl'
		idw_detail.settransobject(SQLCA)
		
		
	ELSEIF gs_empresa = 'FISHOLG' THEN
		
		idw_exportacion.dataobject = 'd_ve_factura_exportacion_fisholg_ff'
		idw_exportacion.settransobject(SQLCA)
		
		idw_detail.dataobject = 'd_abc_cntas_cobrar_det_fisholg_tbl'
		idw_detail.settransobject(SQLCA)
		
	elseif gs_empresa = "BLUEWAVE" or gs_empresa ="PEZEX" or gs_empresa ="ARCOPA" then
		
		//Cualquier venta será con Orden de Venta
		cb_ov.enabled 		= false
		//cb_guia.enabled 	= false
		rb_pptt.enabled 	= false
		
	END IF
	
	//Verifico si tiene un parametro de ingreso
	if not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
		if Message.PowerObjectParm.ClassName() = 'str_parametros' then 
			lstr_param = Message.PowerObjectParm
			
			ldw_report = lstr_param.dw_report
			ll_row_ref = lstr_param.long1
			
			//Obtengo el tipo de docuemnto por el cliente
			ls_tipo_doc_ident	= ldw_report.object.tipo_doc_ident 			[ll_row_ref]
			ls_ruc_dni			= ldw_report.object.ruc_dni		 			[ll_row_ref]
			ls_Cliente 			= ldw_report.object.cod_relacion 			[ll_row_ref]
			ls_mnz 				= ldw_report.object.mnz 						[ll_row_ref]
			ls_lote	 			= ldw_report.object.lote 						[ll_row_ref]
			ls_nro_letra		= ldw_report.object.nro_letra					[ll_row_ref]
			ld_fecha				= Date(ldw_report.object.fec_vencimiento 	[ll_row_ref])
			
			if ls_tipo_doc_ident = '6' then
				ls_tipo_doc = 'FAC'
			else
				ls_tipo_doc = 'BVC'
			end if
			
			
			//Obtengo el tipo de credito fiscal
			select t.tipo_cred_fiscal, cf.descripcion, t.nro_libro
				into :ls_cred_fiscal, :ls_desc_cred_fiscal, :ll_nro_libro
			from doc_tipo t,
				  credito_fiscal cf
			where t.tipo_cred_fiscal = cf.tipo_cred_fiscal     
			  and t.tipo_doc			 = :ls_tipo_doc;
			  
			//Forma de pago
			ls_forma_pago = gnvo_app.of_get_parametro('BOLETA_12_DIAS', 'B12')
			
			select dias_vencimiento
				into :ll_dias
			from forma_pago
			where forma_pago = :ls_forma_pago;
			
			ll_row = dw_master.event ue_insert()
			if ll_row > 0 then
				
			
				dw_master.Object.tipo_doc			[ll_row] = ls_tipo_doc
				dw_master.Object.cod_relacion		[ll_row] = ls_cliente
				dw_master.Object.nom_proveedor 	[ll_row]	= ldw_report.object.nom_cliente 	[ll_row_ref]
				dw_master.Object.ruc_dni_cliente [ll_row]	= ls_ruc_dni
				dw_master.Object.cod_moneda 		[ll_row]	= ldw_report.object.cod_moneda	[ll_row_ref]
				dw_master.Object.forma_pago 		[ll_row]	= ls_forma_pago
				dw_master.Object.nro_libro 		[ll_row]	= ll_nro_libro
				dw_master.Object.origen		 		[ll_row]	= gs_origen
				
				//ld_fec_emision = Date(dw_master.Object.fecha_documento 		[ll_row])
				
				// Obtengo la direccion
				select 	d.item,
       					PKG_LOGISTICA.of_get_direccion(d.codigo, d.item) as direccion
					into 	:ll_item_direccion,
							:ls_direccion
				from direcciones d
				where d.codigo = :ls_cliente
				order by d.item;
				
				dw_master.Object.item_direccion 		[ll_row]	= ll_item_direccion
				dw_master.Object.direccion		 		[ll_row]	= ls_direccion
				
				//Observacion
				if upper(gs_empresa) = 'INNOVA' then
					ls_observacion = gnvo_app.ventas.of_string_nro_cuota(ls_nro_letra, ld_fecha)
					ls_observacion += '~r~n' + gnvo_app.ventas.of_string_codigo_cliente(ls_ruc_dni, ls_mnz, ls_lote)
					ls_observacion += '~r~nNRO OPERACION: NO REGISTRA'
					ls_observacion += '~r~FECHA DE PAGO : NO REGISTRA'
					
					dw_master.Object.observacion 		[ll_row]	= ls_observacion
				end if
				
			end if
			
			ll_row = idw_detail.event ue_insert()
			if ll_row > 0 then
				idw_detail.Object.cod_art						[ll_row] = ldw_report.object.cod_art 			[ll_row_ref]
				idw_detail.Object.descripcion 				[ll_row]	= ldw_report.object.desc_art 			[ll_row_ref]
				idw_detail.Object.cantidad 					[ll_row]	= 1
				idw_detail.Object.precio_unitario			[ll_row]	= Dec(ldw_report.object.importe_doc	[ll_row_ref])
				idw_detail.Object.tipo_ref						[ll_row]	= ldw_report.object.tipo_doc 			[ll_row_ref]
				idw_detail.Object.nro_ref						[ll_row]	= ldw_report.object.nro_doc 			[ll_row_ref]
				idw_detail.Object.item_ref						[ll_row]	= ldw_report.object.nro_item 			[ll_row_ref]
				idw_detail.Object.tipo_cred_fiscal			[ll_row]	= ls_cred_fiscal
				idw_detail.Object.desc_tipo_cred_fiscal	[ll_row]	= ls_desc_cred_fiscal
			end if
			
			//ELimino el impuesto
			idw_det_imp.event ue_delete_all()
			
			this.of_total_doc()
		
		end if	
	end if

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, '')
end try


end event

event resize;call super::resize;of_asigna_dws( )

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width       	= tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height      	= tab_1.tabpage_1.height - idw_detail.y - 10

idw_referencias.height 	= tab_1.tabpage_2.height - idw_referencias.y - 10
idw_referencias.width  	= tab_1.tabpage_2.width - idw_referencias.x - 10

idw_det_imp.height     	= tab_1.tabpage_3.height - idw_det_imp.y - 10

idw_totales.height     	= tab_1.tabpage_4.height - idw_totales.y - 10

idw_asiento_det.width  	= tab_1.tabpage_5.width  - idw_asiento_det.x - 10
idw_asiento_det.height 	= tab_1.tabpage_5.height - idw_asiento_det.y - 10

idw_exportacion.width  	= tab_1.tabpage_6.width  - idw_exportacion.X - 10
idw_exportacion.height 	= tab_1.tabpage_6.height - idw_exportacion.y - 10

idw_datos_exp.width  	= tab_1.tabpage_7.width  - idw_datos_exp.X - 10
idw_datos_exp.height 	= tab_1.tabpage_7.height - idw_datos_exp.y - 10

end event

event ue_insert;String  	ls_flag_estado, ls_mensaje, ls_tipo_doc, &
			ls_flag_mercado, ls_result
Long    	ll_currow, ll_ano, ll_mes, ll_row
Boolean 	lb_result

if idw_1 <> dw_master then
	if dw_master.RowCount() = 0 then return
	
	//Valido si el documento tiene opcion para insertar si no se ha enviado a SUNAT
	if dw_master.object.flag_enviar_efact [1] = '1' then
		Messagebox('Aviso','Comprobante ya ha sido marcado para envio a SUNAT, es imposible la operacion, por favor Verifique')
		return
	end if
end if

CHOOSE CASE idw_1
	CASE dw_master
		TriggerEvent('ue_update_request')
		idw_1.Reset()
		idw_detail.Reset()
		idw_referencias.Reset()
		idw_det_imp.Reset()
		idw_totales.Reset()
		idw_asiento_cab.Reset()
		idw_asiento_det.Reset()
		idw_exportacion.Reset()
		
		rb_servicios.checked = FALSE
		rb_pptt.checked = FALSE
		rb_operaciones.checked = FALSE
		cb_operaciones.enabled = false
		
		is_action = 'new'
		ib_estado_prea = TRUE   //Pre Asiento No editado	
		
		//habilita botones
		of_hab_des_botones ( 1 )
				
	
	CASE idw_detail
			
		IF dw_master.Getrow( ) = 0 THEN RETURN
		
		if ib_cierre then 
			Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
			return
		end if

		
		ls_flag_estado = dw_master.object.flag_estado 	[1]
		ll_ano			= dw_master.object.ano 			 	[1]
		ll_mes			= dw_master.object.mes 			 	[1]
		
		
		/*verifica cierre*/
		if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return //movimiento bancario
		
		if ls_flag_estado <> '1' then
			MessageBox('Aviso', 'El Documento no se encuentra activo,por favor verifique')
			return
		end if
		
		IF ii_lin_x_doc > 0 and idw_detail.Rowcount () >= ii_lin_x_doc	THEN
			Messagebox('Aviso','No Puede Exceder de '+Trim(String(ii_lin_x_doc))+' Items x Documento')	
			Return
		END IF
		
		IF Not(rb_servicios.checked = TRUE OR rb_pptt.checked = TRUE) THEN
			Messagebox('Aviso','Debe Seleccionar o Servicios o Producto Terminado, por favor Verifique')
			RETURN
		END IF
		
		ib_estado_prea = TRUE   //Pre Asiento No editado	
		
	CASE idw_det_imp
		
		if ib_cierre then 
			Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
			return
		end if
	
		ll_currow 		= idw_detail.GetRow()
		lb_result 		= idw_detail.IsSelected(ll_currow)
		ls_flag_estado = dw_master.object.flag_estado [1]
		ll_ano			= dw_master.object.ano 			 [1]
		ll_mes			= dw_master.object.mes 			 [1]
		
		/*verifica cierre*/
		if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return //movimiento bancario
		
		if ls_flag_estado <> '1' then
			MessageBox('Aviso', 'El Documento no se encuentra activo,por favor verifique')
			return
		end if

		IF lb_result = FALSE then
			Messagebox('Aviso','Debe Seleccionar Un Item para generar su Respectivo Impuesto')
			Return
		END IF
		
		ib_estado_prea = TRUE    //Pre Asiento No editado	Autogeneración				
		/**/
	
	CASE idw_exportacion
	
		if ib_cierre then 
			Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
			return
		end if
		
		ls_tipo_doc = dw_master.object.tipo_doc [dw_master.Getrow()]
		
		IF idw_exportacion.Rowcount( ) = 1 then
			Messagebox('Aviso','No se pueden insertar mas de un registro en esta opción')
			RETURN
		END IF
		
		ls_flag_mercado = dw_master.object.flag_mercado [dw_master.Getrow()]
		
		IF ls_flag_mercado <> 'E' and ls_tipo_doc <> gnvo_app.is_doc_ex THEN
			Messagebox('Aviso', 'No se puede insertar una Factura para este tipo de documento ' &
									+ "~r~nTipo de Mercado: " + ls_flag_mercado &
									+ "~r~nTipo Doc: " + ls_tipo_doc)
			RETURN
		END IF
		
END CHOOSE


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

idw_1.setFocus()
end event

event ue_insert_pos;call super::ue_insert_pos;IF idw_1 = dw_master THEN
	
	idw_asiento_cab.event ue_insert()
	
ELSEIF idw_1 = idw_detail THEN
	
	IF rb_pptt.checked = TRUE THEN
		idw_detail.Object.flag_art [al_row] = 'P'
		idw_detail.Setcolumn('cod_art')
	ELSE
		idw_detail.Setcolumn('descripcion')
	END IF
END IF
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 						 			  OR idw_detail.ii_update  = 1 OR &
	 idw_referencias.ii_update = 1 OR idw_det_imp.ii_update	= 1 OR &
	 idw_asiento_cab.ii_update      = 1 OR idw_asiento_det.ii_update = 1 OR &
	 idw_exportacion.ii_update = 1 )THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update  				= 1 
	   idw_referencias.ii_update = 1 
	   idw_det_imp.ii_update				= 1 
		idw_asiento_cab.ii_update      = 1 
	   idw_asiento_det.ii_update      = 1 
		idw_exportacion.ii_update								= 1
	END IF
END IF

end event

event ue_update_pre;String   	ls_origen   		, ls_tipo_doc 		, ls_nro_doc   	, ls_cod_cliente		, ls_cnta_ctbl  	, &
		   	ls_mensaje  		, ls_result    	, ls_flag_detrac	, ls_nro_detraccion 	, ls_const_dep 	, &
				ls_flag_estado 	, ls_oper_sec 		, ls_cod_moneda	, ls_bien_serv			, ls_nro_serie		, &
				ls_oper_detr		, ls_cod_relacion , ls_descrip  		, ls_vendedor 			, ls_flag_mercado	, &
				ls_centro_benef	, ls_periodo   	, ls_serie			, ls_direccion			, ls_ruc_dni
				
Long 	   	ll_inicio	, ll_flag_ov		, ll_nro_libro		, ll_nro_asiento = 0	, ll_item_op		, &
		   	ll_item		, ll_count			, ll_ano				, ll_mes					, li_opcion
				
Date     	ld_last_day, ld_fecha_dep, ld_fecha_emision

Decimal 		ldc_totsoldeb = 0		, ldc_totdoldeb = 0	, ldc_totsolhab = 0	, ldc_totdolhab = 0	, ldc_importe_imp ,&
			   ldc_porc_detr	 		, ldc_monto_detrac 	, ldc_import_cob    	, ldc_saldo_sol    	, ldc_saldo_dol	 	,&
				ldc_precio_unit_exp	, ldc_tasa_cambio		, ldc_total				, ldc_tasa_cambio_new

str_parametros 			lstr_param	
dwItemStatus 				ldis_status
nvo_numeradores			lnvo_numeradores


try
	ib_update_check = false
	
	lnvo_numeradores  = CREATE nvo_numeradores

	/**REPLICACION**/
	
	dw_master.of_set_flag_replicacion()
	idw_detail.of_set_flag_replicacion()
	idw_referencias.of_set_flag_replicacion()
	idw_det_imp.of_set_flag_replicacion()
	idw_asiento_cab.of_set_flag_replicacion()
	idw_asiento_det.of_set_flag_replicacion()
	idw_exportacion.of_set_flag_replicacion( )
	
	
	IF is_action = 'anular' THEN //ANULO TRANSACION
		
		//Actualizo la detraccion
		dw_master.object.imp_detraccion [1] = 0.00
		ls_nro_detraccion = dw_master.object.nro_detraccion [1]
		
		if not IsNull(ls_nro_Detraccion) and trim(ls_nro_detraccion) <> '' then
			invo_detraccion.of_Anular(ls_nro_detraccion)
		end if
		
		//No hay nada mas que hacer
		ib_update_check = TRUE
		Return
	END IF
	
	if is_action = 'delete' then
		//Anulo la detraccion del documento
		if not IsNull(is_nro_detraccion) and trim(is_nro_detraccion) <> '' then
			invo_detraccion.of_Anular(is_nro_detraccion)
		end if
		
		//No hay nada mas que hacer
		ib_update_check = TRUE
		Return
	end if
	
	/*DATOS DE CABECERA */
	IF dw_master.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Registro en la Cabecera', StopSign!)
		Return
	END IF
	
	//Verificación de Data en Cabecera de Documento
	IF gnvo_app.of_row_Processing( dw_master) <> true then return
	
	//Verificación de Data en Detalle de Documento
	IF gnvo_app.of_row_Processing( idw_detail) <> true then return
	
	//Verificación de Data en Detalle de Impuesto
	IF gnvo_app.of_row_Processing( idw_det_imp ) <> true then	return
	
	IF idw_detail.Rowcount() = 0 THEN return
	
	//Actualizo el importe de la detraccion
	of_calcular_detraccion()
	dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
		
	dw_master.ii_update = 1
		
	of_total_ref ()
	
	////Seleccionar Informacion de Cabecera
	ls_cod_moneda	  	= dw_master.Object.cod_moneda			[dw_master.getRow()]
	ls_origen    	  	= dw_master.Object.origen           [dw_master.getRow()]
	ls_tipo_doc      	= dw_master.object.tipo_doc         [dw_master.getRow()]
	ls_nro_doc  		= dw_master.object.nro_doc  		 	[dw_master.getRow()]
	ls_flag_estado	  	= dw_master.object.flag_estado 	  	[dw_master.getRow()] 	
	ldc_tasa_cambio  	= dw_master.object.tasa_cambio 	  	[dw_master.getRow()] 	
	ls_cod_relacion  	= dw_master.object.cod_relacion 	  	[dw_master.getRow()] 	
	ls_descrip		  	= dw_master.object.observacion 	  	[dw_master.getRow()] 	
	ls_cod_cliente 	= dw_master.object.cod_relacion   	[dw_master.getRow()] 
	ll_item				= dw_master.object.item_direccion 	[dw_master.getRow()] 
	ls_vendedor    	= dw_master.object.vendedor       	[dw_master.getRow()]
	ls_Serie				= dw_master.object.serie	       	[dw_master.getRow()]
	ls_direccion		= dw_master.object.direccion      	[dw_master.getRow()]
	ls_ruc_dni			= dw_master.object.ruc_dni_cliente 	[dw_master.getRow()]
	
	
	ldc_import_cob   	= dw_master.object.importe_doc    			[dw_master.getRow()]
	ld_fecha_emision  = Date(dw_master.object.fecha_documento  	[dw_master.getRow()])

	//DAtos de ASiento Contable
	ll_nro_libro     	= dw_master.object.nro_libro        [dw_master.getRow()] 
	ll_ano		     	= dw_master.object.ano		        	[dw_master.getRow()] 
	ll_mes		     	= dw_master.object.mes		        	[dw_master.getRow()] 
	ll_nro_asiento   	= dw_master.object.nro_asiento	 	[dw_master.getRow()] 
	
	
	//Datos de Detraccion
	ls_bien_serv	  	= dw_master.object.bien_serv		   		[dw_master.getRow()]
	ls_oper_detr	  	= dw_master.object.oper_detr					[dw_master.getRow()]
	ls_flag_detrac   	= dw_master.object.flag_detraccion  		[dw_master.getRow()]
	ls_nro_detraccion	= dw_master.object.nro_detraccion   		[dw_master.getRow()]
	ldc_porc_detr    	= Dec(dw_master.object.porc_detraccion  	[dw_master.getRow()])
	ldc_monto_detrac 	= Dec(dw_master.object.imp_detraccion		[dw_master.getRow()])

	
	/*verifica cierre*/
	invo_asiento_Cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
	
	IF ls_result = '0'  THEN
		Messagebox('Aviso',ls_mensaje, StopSign!)
		Return
	END IF
	
	//Valido si la tasa de cambio corresponde a la de la fecha de emision, sino no me deja guardarlo
	ldc_tasa_cambio_new = gnvo_app.of_tasa_cambio_vta(ld_fecha_emision)
	
	if ldc_tasa_Cambio <> ldc_tasa_cambio_new then
		MessageBox('Error', 'El tipo de cambio que tiene el documento no es el mismo que esta registrado ' &
								+ 'en la tabla de Tipo de Cambio, por favor verifique!' &
								+ '~r~nFecha Emision: ' + string(ld_fecha_emision, 'dd/mm/yyyy') &
								+ '~r~nTipo Cambio Documento: ' + string(ldc_tasa_cambio, '###,##0.0000') &
								+ '~r~nTipo Cambio Tabla: ' + string(ldc_tasa_cambio_new, '###,##0.0000'), StopSign!)
								
								 
		dw_master.SetFocus()
		dw_master.setColumn( "fecha_documento" )
		return
	end if		
	
	//Valido que el cliente tenga una direccion valida
	if IsNull(ls_direccion) or trim(ls_direccion) = '' then
		Messagebox('Aviso', 'El cliente no tiene una direccion especificada, por favor corrija!', StopSign!)
		return 
	end if

	//Valido que el Cliente tenga algun numero de documento de identidad
	if IsNull(ls_ruc_dni) or trim(ls_ruc_dni) = '' then
		Messagebox('Aviso', 'El cliente no tiene RUC o numero de documento de identidad, por favor corrija!', StopSign!)
		return 
	end if
	
	//Valido que si soy un emisor electronico, el tipo de documento debe ser acorde con la
	//serie
	if IsNull(ls_Serie) or trim(ls_Serie) = '' then
		Messagebox('Aviso', 'El comprobante no tiene serie asignada, por favor corrija!', StopSign!)
		return 
	end if
	
	if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' then
		Messagebox('Aviso', 'No ha especificado el tipo de comprobante de pago, por favor corrija!', StopSign!)
		dw_master.setColumn('tipo_doc')
		return 
	end if

	if gnvo_app.ventas.is_emisor_electronico = '0' and gnvo_app.ventas.is_flag_efact = '0' then
		//No eres emisor electronico y no tienes tampoco un tercero para emitir comprobante
		//electronico
		if left(ls_serie,1) = 'F' or left(ls_serie,1) = 'B' then
			Messagebox('Aviso', 'Su empresa no es emisor electronico y tampoco posee un tercero ' &
									+ 'que le emita facturas electronicas, por lo que no puede usar ' &
									+ 'series que comiencen con F o B. Por favor corrija!', StopSign!)
			return 
		end if
	end if
	
	if gnvo_app.ventas.is_emisor_electronico = '1' or gnvo_app.ventas.is_flag_efact = '1' then
		
		if left(ls_serie, 1) = 'F' and trim(ls_tipo_doc) <> 'FAC' then
			Messagebox('Aviso', 'La serie que comienza con F solo se pueden usar con ' &
									+ 'FACTURAS ELECTRONICAS. Por favor corrija!', StopSign!)
			return 
			
		end if
		
		if left(ls_serie, 1) = 'B' and trim(ls_tipo_doc) <> 'BVC' then
			Messagebox('Aviso', 'La serie que comienza con B solo se pueden usar con ' &
									+ 'BOLETAS ELECTRONICAS. Por favor corrija!', StopSign!)
			return 
			
		end if

	end if
	
	//actualiza saldos de documento generado
	IF ls_cod_moneda = gnvo_app.is_soles THEN 
		ldc_saldo_sol = ldc_import_cob
		ldc_saldo_dol = Round(ldc_import_cob / ldc_tasa_cambio ,2)
	ELSEIF ls_cod_moneda = gnvo_app.is_dolares THEN
		ldc_saldo_sol = Round(ldc_import_cob *  ldc_tasa_cambio ,2)
		ldc_saldo_dol = ldc_import_cob
	END IF
	
	//saldos
	dw_master.object.saldo_sol [1] = ldc_saldo_sol 
	dw_master.object.saldo_dol [1] = ldc_saldo_dol
	
	ls_flag_mercado = dw_master.object.tipo_doc [1]
		
	IF ls_tipo_doc = is_doc_fac or ls_flag_mercado = 'E' THEN
		///**Verifica Dirección**///
		SELECT Count(*)
		  INTO :ll_count
		  FROM direcciones
		 WHERE codigo = :ls_cod_cliente 
		   AND item   = :ll_item;
	
		IF ll_count = 0 THEN
			ib_update_check = False
			Messagebox('Aviso','No ha especificado la dirección del cliente, y no se puede guardar el documento sin dicha dirección, por favor Verifique!')
			dw_master.Setfocus()
			dw_master.SetColumn('item_direccion')
			Return
		END IF
	END IF
	
	//Verificación de datos de Detraccion
	if ls_flag_detrac = '1' then
		
		if IsNull(ls_bien_serv) or trim(ls_bien_serv) = '' then
			Messagebox('Error','No se ha especificado el codigo del bien o servicio para la detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('bien_serv')
			dw_master.setFocus( )
			RETURN	
		end if
		if IsNull(ls_oper_detr) or trim(ls_oper_detr) = '' then
			Messagebox('Error','No se ha especificado el codigo de la operacion de la detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('oper_detr')
			dw_master.setFocus( )
			RETURN	
		end if
		if IsNull(ldc_porc_detr) or ldc_porc_detr = 0.00 then
			Messagebox('Error','No se ha especificado el porcentaje de detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('porc_detraccion')
			dw_master.setFocus( )
			RETURN	
		end if
		if IsNull(ldc_monto_detrac) or ldc_monto_detrac = 0.00 then
			Messagebox('Error','No se ha especificado el Importe de detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('bien_serv')
			dw_master.setFocus( )
			RETURN	
		end if

	end if
	
	//GENERO EL NUMERO DE LA DETRACCION
	if ls_flag_detrac = '1' then
	
		//Recalcula la detraccion
		of_calcular_detraccion()

		//Si no hay detraccion entonces creo el numero de la detraccion y solicito si tiene o 
		//no la constancia de deposito
		if IsNull(ls_nro_detraccion) or ls_nro_detraccion = "" or is_action = 'new' then
			ls_nro_detraccion = invo_detraccion.of_next_nro(ls_origen)
			
			dw_master.object.nro_detraccion [1] = ls_nro_detraccion
			
		else
			
			select count(*)
			  into :ll_count
			from detraccion
			where nro_detraccion = :ls_nro_detraccion;
			
			// Obtengo la constancia de desposito y la fecha de deposito
			if ll_count > 0 then
				select nro_deposito, fecha_deposito
					into :ls_const_dep, :ld_fecha_dep
				from detraccion
				where nro_detraccion = :ls_nro_detraccion;
			end if			
		end if
		
		//Obtengo el numero de constancia
		if is_Action = 'new' or IsNull(ls_const_dep) or trim(ls_const_dep) = '' or IsNull(ld_fecha_dep) then
			li_opcion = MessageBox('Aviso',' Desea colocar Datos del Deposito?', Question!, YesNo!, 2)
		
			if li_opcion = 1 then
				lstr_param.string1 = ls_const_dep
				lstr_param.fecha1	 = ld_fecha_dep
				
				//ventana de ayuda
				OpenwithParm(w_help_constacia_dep, lstr_param)
	
				//*Datos Recuperados  *//
				IF isvalid(message.PowerObjectParm) THEN
					lstr_param = message.PowerObjectParm
					IF lstr_param.bret THEN
						ls_const_dep = lstr_param.string1 
						ld_fecha_dep = lstr_param.fecha1  
					else
						ROLLBACK;
						return
					END IF
				END IF
			end if				
		end if
	end if
	
	/*****************************************/
	// Genero el numero del documento
	/****************************************/
	if is_Action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
		//Asignación  de Nro de Serie
		ls_nro_serie  = dw_master.object.serie [dw_master.getRow()]
		
		//Obtengo el siguiente numero según el numerador
		IF of_nro_doc(ls_tipo_doc, ls_nro_serie, ls_mensaje) = FALSE THEN
			ib_update_check = False	
			ROLLBACK;
			Messagebox('Aviso',ls_mensaje)
			Return
		END IF
		
		//Obtengo el numero del documento si ya fue generado
		ls_nro_doc  		= dw_master.object.nro_doc  		 	[dw_master.getRow()]
		
	end if

	
	/*****************************************/
	///Genero el nro del asiento contable
	/****************************************/
	IF is_action = 'new' THEN
		//verificacion de año y mes	
		IF Isnull(ll_ano) OR ll_ano = 0 THEN
			ib_update_check = False	
			Messagebox('Aviso','Ingrese Año Contable , Verifique!')
			Return
		END IF
		
		IF Isnull(ll_mes) OR ll_mes = 0 THEN
			ib_update_check = False	
			Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
			Return
		END IF
	
		IF invo_asiento_cntbl.of_get_nro_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)  = FALSE THEN return

		dw_master.object.nro_asiento 	[1] = ll_nro_asiento 
		
		//*Datos de Cabecera de Asientos*//
		idw_asiento_cab.Object.origen [1] = ls_origen
		idw_asiento_cab.Object.ano 	[1] = ll_ano
		idw_asiento_cab.Object.mes 	[1] = ll_mes
		
	END IF
	
	/*****************************************/
	///Generacion del Asiento Contable
	/****************************************/
	IF ib_estado_prea = TRUE THEN 
		IF of_generacion_asiento() = FALSE THEN  //Generación de pre Asientos
			ib_update_check = False	
			Return
		END IF
	END IF
	

	//ACTUALIZO LOS DATOS DE LA DETRACCION
	IF ls_flag_detrac = '1' THEN
		
		ldc_monto_detrac   = Dec(dw_master.object.imp_detraccion 	[dw_master.getRow()])
		//update de la detraccion
		invo_detraccion.idw_master = dw_master
		
		IF invo_detraccion.of_update(	ls_nro_detraccion,&
												ls_const_dep,&
												ld_fecha_dep,&
												ldc_monto_detrac, &
												'3') = FALSE THEN
			ROLLBACK;
			Return								 
		END IF
		
	elseIF ls_flag_detrac = '0' THEN
		
		if is_action = 'fileopen'	 then
			/*Buscar Nro de Detracción*/
			select nro_detraccion 
				into :ls_nro_detraccion 
				from CNTAS_COBRAR cp
			 where cp.tipo_doc		= :ls_tipo_doc		
				and cp.nro_doc			= :ls_nro_doc;
			
			if SQLCA.SQLCOde = 100 then
				ROLLBACK;
				gnvo_app.of_message_error( "No se ha encontrado el documento en cntas_cobrar " + ls_tipo_doc + "-" + ls_nro_doc + ". Por favor verifique!")
				return 
			end if
	
			select count(*) 
			  into :ll_count 
			from detraccion 
			where nro_detraccion = :ls_nro_detraccion ;
			
			if ll_count > 0 then
				li_opcion = Messagebox('Aviso','Esta Segura de Eliminar Datos de la Detracción ' + ls_nro_detraccion + '?',Question!,YesNo!,2)
				
				if li_opcion = 2 then return
					
				if invo_detraccion.of_anular(ls_nro_detraccion) = false then 
					ROLLBACK;
					return
				end if
				
			end if		
		end if	
	END IF

	
	///detalle de Documento
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
	
		 ldc_precio_unit_exp = idw_detail.object.precio_unit_exp [ll_inicio]
		 ls_centro_benef		= idw_detail.object.centro_benef    [ll_inicio]
		 
		 idw_detail.object.tipo_doc [ll_inicio]  = ls_tipo_doc		 
		 idw_detail.object.nro_doc  [ll_inicio]  = ls_nro_doc		 
		 
		 
		 if gnvo_app.is_flag_valida_cbe = '1' then
			 IF Isnull(ls_centro_benef) OR Trim(ls_centro_benef) = '' THEN
				  Messagebox('Aviso','Debe Ingresar Centro de Beneficio , Verifique!')
				  idw_detail.SetFocus()
				  idw_detail.Scrolltorow(ll_inicio)
				  idw_detail.SetColumn('centro_benef')
				  ib_update_check = False	
				  Return	
			 END IF
		 end if	
		 
	NEXT
	
	///Referencias de Documentos
	FOR ll_inicio = 1 TO idw_referencias.Rowcount()
		 idw_referencias.object.tipo_doc     [ll_inicio] = ls_tipo_doc		 
		 idw_referencias.object.nro_doc      [ll_inicio] = ls_nro_doc		 
		 idw_referencias.object.cod_relacion [ll_inicio] = ls_cod_cliente	 
	NEXT
	
	///Impuestos
	FOR ll_inicio = 1 TO idw_det_imp.Rowcount()
		 idw_det_imp.object.tipo_doc [ll_inicio] = ls_tipo_doc		 
		 idw_det_imp.object.nro_doc  [ll_inicio] = ls_nro_doc		 
		 /*Verifica Monto de Impuesto sea Mayor a 0*/
		 
		 ldc_importe_imp = idw_det_imp.object.importe [ll_inicio]
		 IF is_action = 'new' OR is_action = 'fileopen' THEN
			 IF Isnull(ldc_importe_imp) OR ldc_importe_imp = 0 THEN
				 ib_update_check = False	
				 Messagebox('Aviso','Verifique Importe de Impuesto debe ser Mayor que 0')
				 EXIT			 
			 END IF
		END IF
	NEXT
	
	///Detalle de pre asiento
	FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
		 ls_cnta_ctbl = idw_asiento_det.object.cnta_ctbl [ll_inicio]
		 idw_asiento_det.object.origen   		[ll_inicio] = ls_origen
		 idw_asiento_det.object.nro_libro		[ll_inicio] = ll_nro_libro
		 idw_asiento_det.object.ano				[ll_inicio] = ll_ano
		 idw_asiento_det.object.mes				[ll_inicio] = ll_mes
		 idw_asiento_det.object.nro_asiento		[ll_inicio] = ll_nro_asiento
		 idw_asiento_det.object.fec_cntbl    	[ll_inicio] = ld_fecha_emision
		 
	NEXT
	
	ldc_totsoldeb  = idw_asiento_det.object.monto_soles_cargo   [1]
	ldc_totdoldeb  = idw_asiento_det.object.monto_dolares_cargo [1]
	ldc_totsolhab  = idw_asiento_det.object.monto_soles_abono	[1]
	ldc_totdolhab  = idw_asiento_det.object.monto_dolares_abono [1]
	
	///Cabecera de pre asiento
	IF is_action = 'new' THEN
		idw_asiento_cab.Object.origen      	[1] = dw_master.object.origen 	[1]
		idw_asiento_cab.Object.nro_libro 	[1] = dw_master.object.nro_libro 	[1]
		idw_asiento_cab.Object.ano 	 		[1] = dw_master.object.ano 			[1]
		idw_asiento_cab.Object.mes		 	 	[1] = dw_master.object.mes		 		[1]
		idw_asiento_cab.Object.nro_asiento 	[1] = dw_master.object.nro_asiento 	[1]
	END IF	
	
	idw_asiento_cab.Object.cod_moneda	[1] = dw_master.object.cod_moneda  	  	[1]
	idw_asiento_cab.Object.tasa_cambio	[1] = dw_master.object.tasa_cambio  	[1]
	idw_asiento_cab.Object.desc_glosa	[1] = dw_master.object.observacion     [1]
	idw_asiento_cab.Object.fec_registro	[1] = dw_master.object.fecha_registro  [1]
	idw_asiento_cab.Object.fecha_cntbl	[1] = ld_fecha_emision
	idw_asiento_cab.Object.cod_usr		[1] = dw_master.object.cod_usr 	 	  	[1]
	idw_asiento_cab.Object.flag_estado	[1] = dw_master.object.flag_estado     [1]
	idw_asiento_cab.Object.tot_solhab	[1] = ldc_totsolhab
	idw_asiento_cab.Object.tot_dolhab	[1] = ldc_totdolhab
	idw_asiento_cab.Object.tot_soldeb	[1] = ldc_totsoldeb
	idw_asiento_cab.Object.tot_doldeb	[1] = ldc_totdoldeb
	
	IF idw_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1
	IF dw_master.ii_update = 1 THEN 
		idw_asiento_cab.ii_update = 1
		idw_asiento_det.ii_update = 1
	END IF
	
	///Exportacion
	FOR ll_inicio = 1 TO idw_exportacion.Rowcount()
		 idw_exportacion.object.tipo_doc [ll_inicio] = ls_tipo_doc		 
		 idw_exportacion.object.nro_doc  [ll_inicio] = ls_nro_doc		 
	NEXT
	
	ii_lin_x_doc = gnvo_app.of_nro_lineas( ls_tipo_doc, ls_origen )
	
	if ii_lin_x_doc > 0 and idw_detail.rowcount() > ii_lin_x_doc then
		Messagebox('Aviso','Nro de Lineas no debe Exceder las ' + Trim(String(ii_lin_x_doc))  )
		Return		
	end if
	
	// valida asientos descuadrados
	if not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then
		ROLLBACK;
		Return
	END IF
	
	ib_update_check = true
	
catch(Exception ex)
	ROLLBACK;
	MessageBox('Exception', ex.getMessage())
	ib_update_check = false
	
finally
	destroy lnvo_numeradores
end try






end event

event ue_update;dwItemStatus 	ldis_status
String 			ls_tipo_doc,ls_nro_doc,ls_oper_sec, ls_serie, ls_cliente
Long   			ll_inicio,ll_item_op
Boolean 			lbo_ok = TRUE

try 
	dw_master.AcceptText()
	idw_detail.AcceptText()
	idw_referencias.AcceptText()
	idw_det_imp.AcceptText()
	idw_asiento_cab.AcceptText()
	idw_asiento_det.AcceptText()
	idw_exportacion.AcceptText( )
	
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN
		ROLLBACK USING SQLCA;	
		RETURN
	END IF
	
	IF ib_log THEN
		dw_master.of_create_log()
		idw_detail.of_create_log()
		idw_referencias.of_create_log()
		idw_det_imp.of_create_log()
		idw_asiento_cab.of_create_log()
		idw_asiento_det.of_create_log()
		idw_exportacion.of_create_log( )
	END IF
	
	IF idw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
		IF idw_asiento_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
			lbo_ok = FALSE
			messagebox("Error en Grabacion Cabecera de Asiento","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_asiento_det.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF idw_asiento_det.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle de Asiento","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF is_action <> 'anular' and is_action<> 'delete' THEN
		//*Transacion Normal*//
		IF	dw_master.ii_update = 1  AND lbo_ok = TRUE  THEN
			IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
				lbo_ok = FALSE
				messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	
		IF idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_referencias.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				messagebox("Error en Grabacion Referencias","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	
		IF idw_detail.ii_update = 1 AND lbo_ok = TRUE  THEN
			IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	
		IF idw_det_imp.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_det_imp.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Messagebox("Error en Grabacion Impuestos","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
		
		IF idw_exportacion.ii_update = 1 AND lbo_ok = TRUE  THEN
			IF idw_exportacion.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				messagebox("Error en Grabacion dw_exportacion","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
		
	ELSE
		
		//*Anulo Transacion*//
		// Anulo la Factura de Exportacion	
		IF idw_exportacion.ii_update = 1 AND lbo_ok = TRUE  THEN
			IF idw_exportacion.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				messagebox("Error en Grabacion dw_exportacion","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
		
		IF idw_det_imp.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_det_imp.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Messagebox("Error en Grabacion Impuestos","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	
		IF idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_referencias.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				messagebox("Error en Grabacion Referencias","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	
		IF idw_detail.ii_update = 1 AND lbo_ok = TRUE  THEN
			IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	
		IF	dw_master.ii_update = 1  AND lbo_ok = TRUE  THEN
			IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
				lbo_ok = FALSE
				messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
			END IF
		END IF
	END IF	
	
	
	iF ib_log and lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_referencias.of_save_log()
		lbo_ok = idw_det_imp.of_save_log()
		lbo_ok = idw_asiento_cab.of_save_log()
		lbo_ok = idw_asiento_det.of_save_log()
		lbo_ok = idw_exportacion.of_save_log( )
	END IF
	
	IF lbo_ok THEN
		COMMIT using SQLCA;
		dw_master.ii_update 			= 0
		idw_detail.ii_update 		= 0
		idw_referencias.ii_update 	= 0
		idw_det_imp.ii_update 		= 0
		idw_asiento_cab.ii_update 	= 0
		idw_asiento_det.ii_update 	= 0
		idw_exportacion.ii_update  = 0
	
		dw_master.ResetUpdate()
		idw_detail.ResetUpdate()
		idw_referencias.ResetUpdate()
		idw_det_imp.ResetUpdate()
		idw_asiento_cab.ResetUpdate()
		idw_asiento_det.ResetUpdate()
		idw_exportacion.ResetUpdate()
	
		ib_estado_prea = False   //pre-asiento editado	
		
		if dw_master.RowCount() > 0 then
			ls_tipo_doc = dw_master.object.tipo_doc 	[1]
			ls_nro_doc 	= dw_master.object.nro_doc 	[1]
			ls_Serie 	= dw_master.object.serie 		[1]
			
			of_retrieve( ls_tipo_doc, ls_nro_doc)
			
			//Creo el PDF en caso que sea emisor de comprobantes electronicos
			if gnvo_app.ventas.is_emisor_electronico = '1' and dw_master.RowCount() > 0 and is_action = 'new' then
				
				if gnvo_app.of_get_parametro('ENVIAR_COMPROBANTE_OSE_SUNAT_AUTOM', '1') = '1' then
					ls_cliente	= dw_master.object.cod_relacion 	[1]	
					
					if IsNull(ls_cliente) or trim(ls_cliente) = '' then
						gnvo_app.of_mensaje_error( "No ha elegido ningun cliente para este comprobante. Por favor verifique!")
						return 
					end if
					
					MessageBox('Aviso', 'Se va a proceder a enviar el Comprobante Electronico a SUNAT', Information!)
					
					of_enviar_sunat_ose(ls_tipo_doc, ls_nro_doc)
					
	
				end if
				
				
			end if
			
		end if
		
		//El comprobante se vuelve no editable
		dw_master.ii_protect = 0
		idw_detail.ii_protect = 0
		idw_referencias.ii_protect = 0
		idw_det_imp.ii_protect = 0
		idw_totales.ii_protect = 0
		idw_asiento_det.ii_protect = 0		
		idw_exportacion.ii_protect = 0
		idw_datos_exp.ii_protect = 0
		
		dw_master.of_protect()
		idw_detail.of_protect()
		idw_referencias.of_protect()
		idw_det_imp.of_protect()
		idw_totales.of_protect()
		idw_asiento_det.of_protect()
		idw_exportacion.of_protect( )
		idw_datos_exp.of_protect()
		
		is_action = 'fileopen'
		is_nro_detraccion = ''
		
		//TriggerEvent('ue_modify')
		f_mensaje("Grabación realizada satisfactoriamente", "")
	ELSE 
		ROLLBACK USING SQLCA;
	END IF
	
	

catch ( Exception ex )
	rollback;
	gnvo_app.of_catch_Exception(ex, 'Error en evento ue_update()')
	
end try


end event

event ue_delete;//override
Long   	ll_row,ll_inicio,ll_found,ll_ano,ll_mes
String 	ls_cod_art,ls_cod_origen,ls_nro_ref,ls_expresion_det,ls_expresion_imp,&
			ls_item, ls_flag_estado,ls_flag,ls_tipo_doc, ls_nro_doc
Decimal 	ld_cantidad_vale,ld_cantidad_doc

if idw_1 = dw_master then
	MessageBox('Error', 'Operacion no permitida en este panel cabecera de documento')
	return
end if

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then return

	//Valido si el documento tiene opcion para insertar si no se ha enviado a SUNAT
	if dw_master.object.flag_enviar_efact [1] = '1' then
		Messagebox('Aviso','Comprobante ya ha sido marcado para envio a SUNAT, es imposible la operacion, por favor Verifique')
		return
	end if

	
	ls_flag_estado = dw_master.object.flag_estado [1]
	ls_tipo_doc		= dw_master.object.tipo_doc	 [1]
	ls_nro_doc		= dw_master.object.nro_doc		 [1]
	ll_ano			= dw_master.object.ano 			 [1]
	ll_mes			= dw_master.object.mes 			 [1]
	
	/*verifica cierre*/
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return //movimiento bancario
	
	//Documento Ha sido Anulado o facturado
	IF ls_flag_estado <> '1' THEN 
		MessageBox('Error', "El Comprobante " + ls_tipo_Doc + "/" + ls_nro_doc + " no se encuentra activo, por favor verifique!")
		RETURN 
	end if
end if

CHOOSE CASE idw_1
	CASE idw_detail
		ll_row = idw_1.Getrow()
		IF ll_row = 0 THEN RETURN		

		ls_flag    = idw_1.Object.flag [ll_row]
		IF Not (Isnull(ls_flag) OR Trim(ls_flag) = '' ) THEN
			Return			
		END IF
		
		//Eliminar impuesto del item a eliminar
		ls_item			   = Trim(String(idw_detail.object.nro_item [ll_row]))
		ls_expresion_imp = 'item = '+ls_item
		
		idw_det_imp.SetFilter(ls_expresion_imp)
		idw_det_imp.Filter()
		
		DO WHILE idw_det_imp.Rowcount() > 0 
			idw_det_imp.deleterow(0)
			idw_det_imp.ii_update = 1
		LOOP
		 
		idw_det_imp.SetFilter('')
		idw_det_imp.Filter()
		
		if is_action <> 'new' then is_action = 'delete'
		
		ib_estado_prea = TRUE
	
		
	CASE idw_referencias
	
		//Si Se Elimina Una Referencia se tiene que descontar o eliminar la cantidad de 
		//los articulos tomandos en cuenta por el doc 
		ll_row = idw_1.Getrow()
		IF ll_row = 0 THEN RETURN
		
		/***********************************************************/
		/* Recuperación de Tipo de Documento Guia , Orden de Venta */
		/***********************************************************/
		
		ls_tipo_doc		= idw_referencias.Object.tipo_REF	[ll_row]
		ls_cod_origen  = idw_referencias.Object.origen_ref [ll_row]
		ls_nro_ref	   = idw_referencias.Object.nro_ref 	[ll_row]
		
	
		IF ls_tipo_doc = is_doc_gr THEN /*Guia de Remisión*/
		
			ids_articulos_x_guia.Retrieve(ls_cod_origen,ls_nro_ref)
			
			FOR ll_inicio = 1 TO ids_articulos_x_guia.Rowcount()
	
				 ls_cod_art   		= ids_articulos_x_guia.object.cod_art 		   [ll_inicio]	 	
				 ld_cantidad_vale = ids_articulos_x_guia.object.cant_procesada [ll_inicio]	 	
				 ls_expresion_det	= "cod_art ='"+ls_cod_art+"'"
				 ll_found     		= idw_detail.find(ls_expresion_det,1,idw_detail.rowcount())
	
	
				 IF ll_found > 0 THEN
					 ld_cantidad_doc = idw_detail.object.cantidad [ll_found] 
				 
					 IF ld_cantidad_doc > ld_cantidad_vale THEN
						 ///Resto Cantidad de Item Considerado
						 idw_detail.object.cantidad [ll_found] = idw_detail.object.cantidad [ll_found] - ld_cantidad_vale
						 idw_detail.ii_update = 1					 
					 ELSE
						 //Eliminar impuesto del item a eliminar
						 ls_item			   = Trim(String(idw_detail.object.nro_item [ll_found]))
						 ls_expresion_imp = 'item = '+ls_item
						 idw_det_imp.SetFilter(ls_expresion_imp)
						 idw_det_imp.Filter()
					 
						 DO WHILE idw_det_imp.Rowcount() > 0
							 idw_det_imp.deleterow(0)
							 idw_det_imp.ii_update = 1
						 LOOP
					 
						 idw_det_imp.SetFilter('')
						 idw_det_imp.Filter()
						
					 
						 idw_detail.deleterow(ll_found)
						 idw_detail.ii_update  = 1
					 
					 END IF
				END IF	  
			NEXT
	
		ELSEIF ls_tipo_doc = gnvo_app.is_doc_ov THEN    /*Orden de Venta*/
			
			 /*Elimina Impuestos*/	
			 DO WHILE idw_det_imp.Rowcount() > 0
				 idw_det_imp.deleterow(0)
				 idw_det_imp.ii_update = 1
			 LOOP
			 
			 /*Elimina Items de Detalle*/
			 DO WHILE idw_detail.Rowcount() > 0
				 idw_detail.deleterow(0)
				 idw_detail.ii_update = 1
			 LOOP
			 
		END IF
		
		ib_estado_prea = TRUE

	CASE idw_det_imp
		ib_estado_prea = TRUE

END CHOOSE

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event closequery;call super::closequery;


if is_salir = 'S' then
	close (this)
end if

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_cta_x_cobrar_tbl'
sl_param.titulo = 'Cuentas x Cobrar'
sl_param.field_ret_i[1] = 1  //TIPO_DOC
sl_param.field_ret_i[2] = 2  //NRO_DOC

OpenWithParm( w_lista, sl_param)

If IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
   of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
	ib_estado_prea = False   //asiento editado					
	is_Action = 'open'
END IF

end event

event ue_modify;Long    ll_row,ll_ano,ll_mes
String  ls_flag_estado,ls_mensaje, ls_result, ls_tipo_doc, ls_nro_doc, ls_nro_ref
Integer li_protect

ll_row = dw_master.Getrow()
IF ll_row = 0 THEN RETURN

if ib_cierre then 
	
	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_referencias.ii_protect = 0
	idw_det_imp.ii_protect = 0
	idw_totales.ii_protect = 0
	idw_asiento_det.ii_protect = 0		
	idw_exportacion.ii_protect = 0
	idw_datos_exp.ii_protect = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_det_imp.of_protect()
	idw_totales.of_protect()
	idw_asiento_det.of_protect()
	idw_exportacion.of_protect( )
	idw_datos_exp.of_protect()
	
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad', StopSign!)
	return
end if

//Valido si el documento tiene opcion para insertar si no se ha enviado a SUNAT
if dw_master.object.flag_enviar_efact [1] = '1' then
	
	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_referencias.ii_protect = 0
	idw_det_imp.ii_protect = 0
	idw_totales.ii_protect = 0
	idw_asiento_det.ii_protect = 0		
	idw_exportacion.ii_protect = 0
	idw_datos_exp.ii_protect = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_det_imp.of_protect()
	idw_totales.of_protect()
	idw_asiento_det.of_protect()
	idw_exportacion.of_protect( )
	idw_datos_exp.of_protect()
	
	Messagebox('Aviso','Comprobante ya ha sido marcado para envio a SUNAT, es imposible la operacion, por favor Verifique')
	return
end if


dw_master.accepttext()

ls_flag_estado = dw_master.object.flag_estado [1]
ll_ano			= dw_master.object.ano 			 [1]
ll_mes			= dw_master.object.mes 			 [1]
ls_tipo_doc		= dw_master.object.tipo_doc	 [1]
ls_nro_doc		= dw_master.object.nro_doc		 [1]
ls_nro_ref		= dw_master.object.nro_ref		 [1]

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return //movimiento bancario

if not IsNull(ls_nro_ref) and trim(ls_nro_ref) <> '' then
	
	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_referencias.ii_protect = 0
	idw_det_imp.ii_protect = 0
	idw_totales.ii_protect = 0
	idw_asiento_det.ii_protect = 0		
	idw_exportacion.ii_protect = 0
	idw_datos_exp.ii_protect = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_det_imp.of_protect()
	idw_totales.of_protect()
	idw_asiento_det.of_protect()
	idw_exportacion.of_protect( )
	idw_datos_exp.of_protect()
	
	Messagebox('Aviso','Este comprobante ha sido anulado con una NOTA DE CREDITO, es imposible modificarlo, coordinar con contabilidad', StopSign!)
	return
end if

//Verifico si se puede modificar el comprobante
if is_action <> 'new' then
	if not gnvo_app.ventas.of_allow_modify(ls_tipo_doc, ls_nro_doc) then 
		dw_master.ii_protect = 0
		idw_detail.ii_protect = 0
		idw_referencias.ii_protect = 0
		idw_det_imp.ii_protect = 0
		idw_totales.ii_protect = 0
		idw_asiento_det.ii_protect = 0		
		idw_exportacion.ii_protect = 0
		idw_datos_exp.ii_protect = 0
		
		dw_master.of_protect()
		idw_detail.of_protect()
		idw_referencias.of_protect()
		idw_det_imp.of_protect()
		idw_totales.of_protect()
		idw_asiento_det.of_protect()
		idw_exportacion.of_protect( )
		idw_datos_exp.of_protect()
	
		return
	end if
end if

IF ls_flag_estado <> '1'  THEN
	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_referencias.ii_protect = 0
	idw_det_imp.ii_protect = 0
	idw_totales.ii_protect = 0
	idw_asiento_det.ii_protect = 0		
	idw_exportacion.ii_protect = 0
	idw_datos_exp.ii_protect = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_det_imp.of_protect()
	idw_totales.of_protect()
	idw_asiento_det.of_protect()
	idw_exportacion.of_protect( )
	idw_datos_exp.of_protect()

ELSE
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_det_imp.of_protect()
	idw_totales.of_protect()
	idw_exportacion.of_protect( )
	idw_datos_exp.of_protect()

	IF is_action <> 'new' THEN
		IF not dw_master.is_protect("tipo_doc", 1)	THEN
			dw_master.object.tipo_doc.Protect 		= 1
			dw_master.object.nro_libro.Protect 	  	= 1
			dw_master.object.ano.Protect		 	  	= 1
			dw_master.object.mes.Protect		 	  	= 1
		END IF
	END IF	
	
	
	li_protect = dw_master.ii_protect
	
	IF li_protect = 0 THEN
		idw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")	
		idw_detail.Modify("cod_art.Protect='1~tIf(IsNull(flag_art),1,0)'")		
		
		//bloqueo flag detraccion
		//dw_master.Modify("flag_detraccion.Protect='1~tIf(IsNull(ind_detrac),1,0)'")			

	END IF 
	
	
END IF


end event

event ue_delete_pos;call super::ue_delete_pos;/*Genera Pre Asientos*/
ib_estado_prea = TRUE
/**/

//Asigno total
dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
dw_master.ii_update = 1

end event

event ue_print;Long   ll_row, ll_rpta
String ls_tipo_doc,ls_nro_doc,ls_flag_mercado, ls_serie

str_parametros 				lstr_param
w_ve307_factura_export_frm lw_1

IF dw_master.RowCount() = 0 or dw_master.GetRow() = 0 THEN
	f_mensaje('No existe Registro en la cabecera del documento, Verifique!', 'FIN_NOT_DOC')
	Return
END IF


IF (dw_master.ii_update         	= 1 OR &
	 idw_detail.ii_update  			= 1 OR &
	 idw_referencias.ii_update   	= 1 OR &
	 idw_det_imp.ii_update			= 1 OR &
	 idw_asiento_cab.ii_update 	= 1 OR &
	 idw_asiento_det.ii_update 	= 1 OR &
	 idw_exportacion.ii_update 	= 1 )THEN
	 
	 Messagebox('Aviso','Existen Actualizaciones Pendientes, por favor grabelos primero antes de Imprimir, por favor Verifique!')
	 Return
	 
END IF	 

//Solicita si es impresión directa o previsualización
ll_rpta = gnvo_app.utilitario.of_print_preview()
if ll_rpta < 0 then return

if ll_rpta = 2 then
	lstr_param.b_preview = true
else
	lstr_param.b_preview = false
end if

//Solo para seafrost se elije el modelo comercial, por ahora
if gs_empresa = 'SEAFROST' then
	
	ll_rpta = gnvo_app.utilitario.of_modelo_factura()
	if ll_rpta < 0 then return
	
	lstr_param.long1 = ll_rpta

else

	lstr_param.long1 = 1

end if


//Impresión de Documento 
ls_tipo_doc 		= dw_master.object.tipo_doc 		[1]
ls_nro_doc 			= dw_master.object.nro_doc  		[1]
ls_flag_mercado 	= dw_master.object.flag_mercado 	[1]

//Obtengo la serie del documento
ls_serie 			= dw_master.object.serie 			[1]

if gnvo_app.ventas.is_impresion_termica = "0" then
	
	if left(ls_serie, 1) = 'F' or left(ls_serie,1) = 'B' then
		//Comprobante electronico
		lstr_param.flag_mercado = ls_flag_mercado 
		gnvo_app.ventas.of_print_ce(ls_tipo_doc, ls_nro_doc, lstr_param)
		
	elseIF ls_tipo_doc = is_doc_fac THEN       //Caso Facturas
	
		of_fact_cobrar(ls_tipo_doc,ls_nro_doc, lstr_param)
		
	ELSEIF ls_tipo_doc = is_doc_bvc THEN	 //Caso Boletas
		
		of_bol_cobrar(ls_tipo_doc,ls_nro_doc, lstr_param)
		
	ELSEIF ls_flag_mercado = 'E' or ls_tipo_doc = gnvo_app.is_doc_ex THEN
		
		lstr_param.string1 = ls_tipo_doc
		lstr_param.string2 = ls_nro_doc
		OpenSheetWithParm(w_rpt_factura_exportacion, lstr_param, w_main, 0, Layered!)
		
	END IF
else
	gnvo_app.ventas.of_print_efact(ls_tipo_doc, ls_nro_doc, false)
end if


end event

event open;call super::open;of_asigna_dws( )
if gs_empresa = 'FISHOLG' then
	//cb_imp.visible = true
end if
end event

event close;call super::close;Destroy ids_articulos_x_guia
Destroy ids_voucher
destroy ids_comprobante

destroy invo_detraccion	
Destroy invo_asiento_cntbl
destroy invo_wait
end event

type cb_vales_salida from commandbutton within w_ve310_cntas_cobrar
integer x = 4174
integer y = 296
integer width = 562
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Vales de Salida"
end type

event clicked;String  ls_cod_cliente,ls_cod_moneda,ls_flag_estado,ls_expresion,ls_mensaje
Long    ll_row_master,ll_ano,ll_mes
Decimal ldc_tasa_cambio 
str_parametros sl_param

if dw_master.GetRow() = 0 then return
ll_row_master = dw_master.getrow()

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad', StopSign!)
	return
end if


ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 
ll_ano			 = dw_master.object.ano 			[ll_row_master]
ll_mes			 = dw_master.object.mes 			[ll_row_master]

if ISNull(dw_master.object.tipo_doc[ll_row_master]) or dw_master.object.tipo_doc[ll_row_master] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar', StopSign!)
	return
end if

/*verifica cierre*/
if not invo_Asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return

IF ls_flag_estado <> '1' THEN RETURN

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF

try
	
	ls_expresion = 'Isnull(cod_art)'
	idw_detail.Setfilter(ls_expresion)
	idw_detail.filter()
	IF idw_detail.Rowcount() > 0 THEN 
		Messagebox('Aviso','Si Ingresa Servicios No Puede tomar en cuenta Vales de Salida', StopSign!) 
		RETURN
	END IF
	
catch ( Exception ex )
	/*statementBlock*/
finally
	idw_detail.Setfilter('')
	idw_detail.filter()
end try

IF idw_referencias.rowcount() > 0 THEN
	Messagebox('Aviso','Este comprobante tiene documentos de referencia, no puede continuar. Por favor verifique!')
	RETURN
END IF



sl_param.titulo	= 'Vales de Salida'
sl_param.opcion   = 23
sl_param.dw1		= 'd_vales_salida_tbl'
sl_param.tipo 		= '1S2S'
sl_param.string1	= ls_cod_cliente
sl_param.string2	= gnvo_app.almacen.is_oper_vta_mercaderia
sl_param.dw_m		= dw_master
sl_param.dw_d		= idw_detail
sl_param.dw_c		= idw_referencias
sl_param.dw_imp	= idw_det_imp
sl_param.db1 		= 1600

OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_2 from commandbutton within w_ve310_cntas_cobrar
integer x = 4174
integer y = 456
integer width = 562
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Dscto x adelanto"
end type

event clicked;String  ls_cod_cliente,ls_cod_moneda,ls_flag_estado,ls_expresion,ls_mensaje
Long    ll_row_master,ll_ano,ll_mes
Decimal ldc_tasa_cambio 
str_parametros sl_param

if dw_master.GetRow() = 0 then return
ll_row_master = dw_master.getrow()

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 
ll_ano			 = dw_master.object.ano 			[ll_row_master]
ll_mes			 = dw_master.object.mes 			[ll_row_master]

if ISNull(dw_master.object.tipo_doc[ll_row_master]) or dw_master.object.tipo_doc[ll_row_master] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar')
	return
end if

/*verifica cierre*/
if not invo_Asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return

IF ls_flag_estado <> '1' THEN RETURN

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF



sl_param.titulo	= 'Descuentos x anticipos'
sl_param.opcion   = 22
sl_param.dw1		= 'd_lista_dctos_adelanto_tbl'
sl_param.string1	= ls_cod_cliente
sl_param.string2	= gnvo_app.finparam.is_cnta_anticipo_sol
sl_param.string3	= gnvo_app.finparam.is_cnta_anticipo_dol
sl_param.tipo 		= '1S2S3S'
sl_param.dw_m		= dw_master
sl_param.dw_d		= idw_detail
sl_param.dw_c		= idw_referencias
sl_param.dw_imp	= idw_det_imp
//sl_param.db1 		= 1600



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_1 from commandbutton within w_ve310_cntas_cobrar
integer x = 4174
integer y = 376
integer width = 562
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Partes de Pesca"
end type

event clicked;String  ls_cod_cliente,ls_cod_moneda,ls_flag_estado,ls_expresion
Long    ll_year, ll_mes , ll_row_master, ll_i
Decimal ldc_tasa_cambio, ldc_total

str_parametros sl_param

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if


ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 
ll_year			 = dw_master.object.ano 			[ll_row_master]
ll_mes			 = dw_master.object.mes 			[ll_row_master]

IF ISNull(dw_master.object.tipo_doc[ll_row_master]) or dw_master.object.tipo_doc[ll_row_master] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar')
	RETURN
END IF

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_year, ll_mes,'R') then return

IF ls_flag_estado <> '1' THEN RETURN

// Validar datos
IF of_valida_datos() = 0 THEN RETURN

ls_expresion = 'Isnull(cod_art) AND Isnull(parte_pesca)'
idw_detail.Setfilter(ls_expresion)
idw_detail.filter()

IF idw_detail.Rowcount() > 0 THEN 
	Messagebox('Aviso','Si Ingresa Servicios No Puede tomar en cuenta Partes de Pesca') 
	RETURN
END IF

idw_detail.Setfilter('')
idw_detail.filter()
//

IF idw_referencias.rowcount() > 0 THEN
	IF Not(Isnull(parent.of_recupera_nro_ov())) THEN
		Messagebox('Aviso','Ha Seleccionado Guia de Remision referenciados a Orden de Venta , Verifique!')
		RETURN
	END IF
END IF

// Llamar a ventana Response para factuar Cantidad/Aparejos
OpenWithParm( w_abc_opcion_pesca, sl_param)
IF isvalid(message.PowerObjectParm) THEN 
	sl_param = message.PowerObjectParm			
END IF
// Realiza accion de acuerdo a parametro recibido
IF sl_param.string4 = '0' THEN // Cancela la accion
	RETURN
ELSEIF sl_param.string4 = '1' THEN // CANTIDAD
	sl_param.titulo	= 'Facturacion de Cantidad de Pesca'
	sl_param.opcion   = 20
	sl_param.string1	= '1FP' 
	sl_param.tipo 		= '1FP'
	sl_param.dw1		= 'd_lista_parte_pesca_cant_tbl'
ELSE  // Aparejo
	sl_param.titulo	= 'Facturacion de Aparejos de Pesca'
	sl_param.opcion   =  21
	sl_param.string1	= '1FP' 
	sl_param.tipo 		= '1FP'
	sl_param.dw1		= 'd_lista_parte_pesca_apar_tbl'
END IF

sl_param.string2	= ls_cod_cliente
sl_param.string3	= ls_cod_moneda
sl_param.string5	= is_doc_parte_pesca
sl_param.db2		= ldc_tasa_cambio
sl_param.dw_m		= dw_master
sl_param.dw_d		= idw_detail
sl_param.dw_c		= idw_referencias
sl_param.db1 		= 1600

OpenWithParm( w_abc_seleccion_lista_search, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.titulo = 's' THEN
	// Genera impuesto
	FOR ll_i = 1 TO idw_detail.rowcount( ) 
		of_generacion_imp (String(ll_i))	
	NEXT 
	
	// Calcula el total del documento
	ldc_total = of_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	dw_master.ii_update = 1

	// Desabilita los botones los botones
	of_hab_des_botones ( 0 )
END IF
end event

type rb_operaciones from radiobutton within w_ve310_cntas_cobrar
integer x = 4146
integer y = 752
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Operaciones"
end type

event clicked;cb_operaciones.enabled = true
end event

type rb_pptt from radiobutton within w_ve310_cntas_cobrar
integer x = 4146
integer y = 684
integer width = 585
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Productos Terminados"
end type

event clicked;cb_operaciones.enabled = false
end event

type rb_servicios from radiobutton within w_ve310_cntas_cobrar
integer x = 4146
integer y = 616
integer width = 585
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Servicios"
end type

event clicked;cb_operaciones.enabled = false
end event

type cb_operaciones from commandbutton within w_ve310_cntas_cobrar
integer x = 4590
integer y = 752
integer width = 146
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;String ls_cod_cliente,ls_flag_estado,ls_result,ls_mensaje
Long   ll_row,ll_ano,ll_mes

 
IF rb_operaciones.checked = FALSE THEN
	Messagebox('AViso','Seleccione Opcion de Operaciones ')
	Return
END IF

dw_master.Accepttext()



ll_row = dw_master.Getrow()
IF ll_row = 0 THEN RETURN
				
ls_cod_cliente = dw_master.object.cod_relacion [ll_row]
ls_flag_estado = dw_master.object.flag_estado  [ll_row]
ll_ano			= dw_master.object.ano 			  [ll_row]
ll_mes			= dw_master.object.mes 			  [ll_row]

/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario

IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
									
IF idw_detail.Rowcount () = ii_lin_x_doc	THEN
	Messagebox('Aviso','No Puede Exceder de '+Trim(String(ii_lin_x_doc))+' Items x Documento')	
	Return
END IF

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Veririfique!')
	Return
END IF


end event

type cb_guia from commandbutton within w_ve310_cntas_cobrar
integer x = 4174
integer y = 216
integer width = 562
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Guia de Remisión"
end type

event clicked;String  ls_cod_cliente,ls_cod_moneda,ls_flag_estado,ls_expresion,ls_mensaje
Long    ll_row_master,ll_ano,ll_mes
Decimal ldc_tasa_cambio 
str_parametros sl_param

if dw_master.GetRow() = 0 then return
ll_row_master = dw_master.getrow()

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

//if gs_empresa = "BLUEWAVE" OR gs_empresa = "PEZEX" then
//	MessageBox('Aviso', "NO ESTA PERMITIDO FACTURAR CON ESTA MODALIDAD, SOLO SE PUEDE FACTURAR JALANDO GUIAS DE REMISION COMO REFERENCIA", Information!)
//	return
//end if


ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 
ll_ano			 = dw_master.object.ano 			[ll_row_master]
ll_mes			 = dw_master.object.mes 			[ll_row_master]

if ISNull(dw_master.object.tipo_doc[ll_row_master]) or dw_master.object.tipo_doc[ll_row_master] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar')
	return
end if

/*verifica cierre*/
if not invo_Asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return

IF ls_flag_estado <> '1' THEN RETURN

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF


IF rb_servicios.checked = TRUE OR rb_pptt.checked = TRUE OR rb_operaciones.checked = TRUE THEN
	Messagebox('Aviso','Verifique Opciones Sin Referencias Una de Ellas esta Activa')
	Return		
END IF

ls_expresion = 'Isnull(cod_art)'
idw_detail.Setfilter(ls_expresion)
idw_detail.filter()
IF idw_detail.Rowcount() > 0 THEN 
	Messagebox('Aviso','Si Ingresa Servicios No Puede tomar en cuenta Guias de Remision') 
	RETURN
END IF
idw_detail.Setfilter('')
idw_detail.filter()


IF idw_referencias.rowcount() > 0 THEN
	Messagebox('Aviso','Ha Seleccionado Guia de Remision referenciados a Orden de Venta , Verifique!')
	RETURN
END IF



sl_param.titulo	= 'Guias Pendientes'
sl_param.opcion   = 11
sl_param.dw1		= 'd_abc_guia_vales_tbl'
sl_param.string1	= '1GR'
sl_param.string2	= ls_cod_cliente
sl_param.string3	= ls_cod_moneda
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1GR'
sl_param.dw_m		= dw_master
sl_param.dw_d		= idw_detail
sl_param.dw_c		= idw_referencias
sl_param.dw_imp	= idw_det_imp
sl_param.db1 		= 1600



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type gb_2 from groupbox within w_ve310_cntas_cobrar
integer x = 4114
integer y = 568
integer width = 667
integer height = 280
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Sin Referencias"
end type

type cb_ov from commandbutton within w_ve310_cntas_cobrar
integer x = 4174
integer y = 136
integer width = 562
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Orden de Venta"
end type

event clicked;String      ls_cod_cliente,ls_cod_moneda,ls_expresion,ls_flag_estado,&
				ls_result,ls_mensaje
Decimal 		ldc_tasa_cambio
Long        ll_ano,ll_mes, ll_row
str_parametros sl_param

if dw_master.GetRow() = 0 then return
dw_master.Accepttext()

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

if gs_empresa = "BLUEWAVE" OR gs_empresa = "PEZEX" then
	MessageBox('Aviso', "NO ESTA PERMITIDO FACTURAR CON ESTA MODALIDAD, SOLO SE PUEDE FACTURAR JALANDO GUIAS DE REMISION COMO REFERENCIA", Information!)
	return
end if

ll_row = dw_master.GetRow()

ls_flag_estado	 = dw_master.Object.flag_estado  [ll_row]
ls_cod_cliente  = dw_master.Object.cod_relacion [ll_row]
ls_cod_moneda	 = dw_master.Object.cod_moneda   [ll_row]
ldc_tasa_cambio = dw_master.Object.tasa_cambio  [ll_row]
ll_ano			 = dw_master.object.ano 			[ll_row]
ll_mes			 = dw_master.object.mes 			[ll_row]

if ISNull(dw_master.object.tipo_doc[ll_row]) or dw_master.object.tipo_doc[ll_row] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar')
	return
end if

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return


IF ls_flag_estado <> '1' THEN RETURN

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF


IF rb_servicios.checked = TRUE OR rb_pptt.checked = TRUE OR rb_operaciones.checked = TRUE THEN
	Messagebox('Aviso','Verifique Opciones Sin Referencias Una de Ellas esta Activa')
	Return		
END IF


ls_expresion = "tipo_ref = '" + is_doc_gr + "'"
idw_referencias.Setfilter(ls_expresion)
idw_referencias.filter()
IF idw_referencias.Rowcount() > 0 THEN 
	Messagebox('Aviso','Ya ha ingresado Guias de Remisión como referencia, no Puede Ingresar Orden de Venta, por favor verifique') 
	RETURN
END IF
idw_referencias.Setfilter('')
idw_referencias.filter()

sl_param.tipo			= '1O'
sl_param.opcion		= 9          //Ordenes de Venta
sl_param.titulo 		= 'Selección de Ordenes de Venta'
sl_param.dw_master	= 'd_lista_orden_venta_pendientes_tbl'
sl_param.dw1			= 'd_abc_art_ov_pendientes_tbl'
sl_param.dw_m			= dw_master
sl_param.dw_d			= idw_detail
sl_param.dw_c			= idw_referencias
sl_param.dw_imp		= idw_det_imp
sl_param.string1		= ls_cod_cliente
sl_param.string2		= parent.of_recupera_nro_ov( )
sl_param.string3		= ls_cod_moneda
sl_param.db1			= ldc_tasa_cambio
sl_param.w1				= parent

dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, sl_param)

end event

type cb_guia_ov from commandbutton within w_ve310_cntas_cobrar
integer x = 4174
integer y = 56
integer width = 562
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Guias Rem x Ord de V."
end type

event clicked;String      ls_cod_cliente,ls_cod_moneda,ls_expresion,ls_flag_estado
Decimal		ldc_tasa_cambio
Long        ll_ano,ll_mes, ll_row
str_parametros sl_param

if dw_master.GetRow() = 0 then return
dw_master.Accepttext()

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ll_row = dw_master.GetRow()
ls_flag_estado	 = dw_master.Object.flag_estado  [ll_row]
ls_cod_cliente  = dw_master.Object.cod_relacion [ll_row]
ls_cod_moneda	 = dw_master.Object.cod_moneda   [ll_row]
ldc_tasa_cambio = dw_master.Object.tasa_cambio  [ll_row]
ll_ano			 = dw_master.object.ano 			[ll_row]
ll_mes			 = dw_master.object.mes 			[ll_row]

if ISNull(dw_master.object.tipo_doc[ll_row]) or dw_master.object.tipo_doc[ll_row] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar')
	return
end if

/*verifica cierre*/
if not invo_Asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return

IF ls_flag_estado <> '1' THEN RETURN

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF


IF rb_servicios.checked = TRUE OR rb_pptt.checked = TRUE OR rb_operaciones.checked = TRUE THEN
	Messagebox('Aviso','Verifique Opciones Sin Referencias Una de Ellas esta Activa')
	Return		
END IF

ls_expresion = 'Isnull(cod_art)'
idw_detail.Setfilter(ls_expresion)
idw_detail.filter()

IF idw_detail.Rowcount() > 0 THEN 
	Messagebox('Aviso','Si Ingresa Servicios No Puede tomar en cuenta Guias de Remision') 
	idw_detail.Setfilter('')
	idw_detail.filter()
	RETURN
END IF


/*IF IsNull(wf_recupera_nro_ov ()) THEN
	RETURN
END IF
*/


IF idw_referencias.rowcount() > 0 THEN
	Messagebox('Aviso','Ha Seleccionado Guia de Remision sin Orden de Venta , Verifique!')
	RETURN
END IF


sl_param.tipo			= '1O'
sl_param.opcion		= 1
sl_param.titulo 		= 'Selección de Ordenes de Venta'
sl_param.dw_master	= 'd_lista_ov_pendientes_guia_tbl'

if gs_empresa = 'SEAFROST' then
	sl_param.dw1			= 'd_lista_guias_generadas_seafrost_tbl'
else
	sl_param.dw1			= 'd_lista_guias_generadas_tbl'
end if

sl_param.dw_m			= dw_master
sl_param.dw_d			= idw_detail
sl_param.dw_c			= idw_referencias
sl_param.dw_imp		= idw_det_imp
sl_param.string1		= ls_cod_cliente
sl_param.string2		= of_recupera_nro_ov()
sl_param.string3		= ls_cod_moneda
sl_param.db1			= ldc_tasa_cambio
sl_param.lw_1			= Parent

dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, sl_param)

end event

type tab_1 from tab within w_ve310_cntas_cobrar
event ue_find_exact ( )
integer y = 1224
integer width = 3648
integer height = 1524
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
boolean pictureonright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_7 tabpage_7
tabpage_6 tabpage_6
end type

event ue_find_exact();Parent.TriggerEvent('ue_find_exact')
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_7=create tabpage_7
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_7,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_7)
destroy(this.tabpage_6)
end on

event selectionchanged;

CHOOSE CASE newindex
		 CASE	4	
				IF of_count_update() = 0 THEN RETURN			
				of_totales		   ()
		 CASE 5
			   IF ib_estado_prea = FALSE THEN RETURN //  Editado
				of_generacion_asiento ()
END CHOOSE

end event

event key;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF


end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Registro"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 3552
integer height = 668
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_cntas_cobrar_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		  // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

idw_mst  = dw_master // dw_master
idw_det  = idw_detail	// dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_matriz ,ls_tipo_doc    ,ls_nro_doc ,ls_cod_art ,ls_nro_ov ,ls_flag_cant,&
				ls_item	 ,ls_descripcion ,ls_confin  ,ls_matriz_cntbl,ls_tipo_ref,ls_flag_dl27400,&
				ls_tip_cred_fiscal,	ls_cod_clase,ls_rubro,ls_origen,ls_centro_benef, ls_desc, ls_und2, &
				ls_flag_seguro_flete, ls_und, ls_flag_und2
Decimal 		ldc_cantidad, ldc_conv, ldc_cantidad_und2, ldc_factor_conv_und
Long        ll_count

try 
	this.Accepttext()

	/*Datos del Registro Modificado*/
	ib_estado_prea = TRUE
	/**/
	
	CHOOSE CASE dwo.name
		CASE 'cod_art'
			//origen 
			ls_origen = dw_master.object.origen [1]
		
			
			SELECT Count(*)
			  INTO :ll_count
			  FROM articulo
			 WHERE (cod_art = :data) ;
			 
			IF ll_count > 0 THEN
				/*Recupero Descripción del Articulo*/
				SELECT a.desc_art, ast.factura_rubro, a.flag_und2, a.factor_conv_und
				  INTO :ls_descripcion,	:ls_rubro, :ls_flag_und2, :ldc_factor_conv_und
				  FROM articulo 				a,
						 articulo_sub_categ 	ast
				 WHERE a.sub_cat_art = ast.cod_sub_cat 
					and a.cod_art 	  = :data			 ;
				
		
				
				/*Recupero Confin,Matriz Contable de Articulo*/ 
				SELECT av.confin       ,   
						 cf.matriz_cntbl ,
						 av.flag_dl27400
				  INTO :ls_confin,:ls_matriz_cntbl,:ls_flag_dl27400
				  FROM articulo_venta 		av,   
						 concepto_financiero cf  
				 WHERE (cf.confin  = av.confin (+)) AND
						 (av.cod_art = :data	  ) ;
				 
				This.Object.descripcion	     	[row] = ls_descripcion
				This.Object.flag_und2	     	[row] = ls_flag_und2
				This.Object.factor_conv_und	[row] = ldc_factor_conv_und
				This.Object.confin		     	[row] = ls_confin
				This.Object.matriz_cntbl     	[row] = ls_matriz_cntbl
				This.Object.rubro			     	[row] = ls_rubro
				
				
				IF ls_flag_dl27400 = '1' THEN
					/*Seleccionar Datos de Comparam*/
					SELECT tipo_cred_fiscal_dl27400
					  INTO :ls_tip_cred_fiscal
					  FROM comparam
					 WHERE reckey = '1' ;
					/**/
					
					IF Isnull(ls_tip_cred_fiscal) OR Trim(ls_tip_cred_fiscal) = '' THEN
						Messagebox('Aviso','Campo tipo_cred_fiscal_dl27400 de Tabla Comparam Se Encuentra Vacio Verifique!')
					ELSE
						This.Object.tipo_cred_fiscal [row] = ls_tip_cred_fiscal
					END IF	
				END IF
				
				
				IF idw_referencias.Rowcount () = 0 THEN
					//valida si requiere cento de beneficio
					if gnvo_app.is_flag_valida_cbe = '1' then
						//busca centro de beneficio
						select cba.centro_benef into :ls_centro_benef
						  from centro_benef_articulo cba,centro_beneficio cb
						 where (cba.centro_benef = cb.centro_benef ) and
								 (cb.cod_origen    = :ls_origen		  ) and
								 (cba.cod_art      = :data     		  ) ;
					  
						if sqlca.sqlcode = 100 then
							//no encuentra centro de beneficio
							This.Object.centro_benef [row] = of_cbenef_origen (ls_origen)
						else
							This.Object.centro_benef [row] = ls_centro_benef
						end if	
					END IF
				END IF
				
				
			ELSE
				SetNull(ls_cod_art)
				SetNull(ls_descripcion)
				SetNull(ls_confin)
				SetNull(ls_matriz_cntbl)
				
				Messagebox('Aviso','Articulo No Existe , Verifique!', StopSign!)
				This.Object.cod_art 		 		[row] = gnvo_app.is_null
				This.Object.descripcion	 		[row] = gnvo_app.is_null
				This.Object.confin		 		[row] = gnvo_app.is_null
				This.Object.matriz_cntbl 		[row] = gnvo_app.is_null
				This.Object.rubro			 		[row] = gnvo_app.is_null
				This.Object.flag_und2			[row] = '0'
				This.Object.factor_conv_und 	[row] = 0.0000
				Return 1
			END IF
		
		CASE 'confin'
			SELECT matriz_cntbl
			  INTO :ls_matriz
			  FROM concepto_financiero
			 WHERE confin = :data ;
			 
			
			IF Isnull(ls_matriz) OR Trim(ls_matriz) = '' THEN
				Messagebox('Aviso','Concepto Financiero No existe Verifique')
				This.Object.confin 		 [row] = gnvo_app.is_null
				This.object.matriz_cntbl [row] = gnvo_app.is_null
				Return 1
			end if
			
			This.object.matriz_cntbl [row] = ls_matriz
	
			
		CASE 'tipo_cred_fiscal'
			SELECT descripcion
			  INTO :ls_desc
			  from credito_fiscal t
			where t.flag_estado = '1'
			  and t.flag_cxp_cxc = 'C'
			  and t.tipo_cred_fiscal = :data ;
			 
			
			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Aviso','Tipo de Credito Fiscal no existe, no esta activo o no corresponde a cuentas por cobrar, por favor verifique', Exclamation!)
				This.Object.tipo_cred_fiscal 		 [row] = gnvo_app.is_null
				This.object.desc_tipo_cred_fiscal [row] = gnvo_app.is_null
				Return 1
			end if
			
			This.object.desc_tipo_cred_fiscal [row] = ls_desc
			
	
		CASE 'cantidad'		
		
			ls_tipo_ref	 = This.Object.tipo_ref	[row]
			ls_tipo_doc	 = This.Object.tipo_doc	[row]
			ldc_cantidad = This.Object.cantidad [row]
			
			IF IsNull(ldc_cantidad) OR Dec(ldc_cantidad) <= 0 THEN
				gnvo_app.of_mensaje_error('Aviso', 'La Cantidad Und1 no puede ser cero o negativa, revise')
				This.object.cantidad_und2	[row] = 0
				This.object.cantidad			[row] = 0
				RETURN 1
			END IF
			
			IF Not(Isnull(ls_tipo_ref) OR Trim(ls_tipo_ref) = '' )THEN
				ls_cod_art	 = This.Object.cod_art	[row]
				ls_nro_doc   = This.Object.nro_doc	[row]
				ls_nro_ov	 = This.Object.nro_ref  [row]
				
				of_ver_cant_x_ov(ls_tipo_doc,ls_nro_doc,ls_cod_art,ls_nro_ov,is_action,ldc_cantidad,ls_flag_cant)
				if gs_empresa <> 'FISHOLG'	THEN
					IF Trim(ls_flag_cant) = '1' THEN
						Messagebox('Aviso','Se esta Excediendo en Cantidad Proyectada, Verifique!')
						This.object.cantidad [row] = 0.00
						Return 1
					END IF
				END IF
			END IF	
			
			//Calculo la segunda unidad
			if gnvo_app.of_get_parametro('VENTAS_CONV_UND1_TO_UND2', '1') = '1' THEN
				ldc_factor_conv_und 	= Dec(This.object.factor_conv_und	[row])
				ls_flag_und2			= This.object.flag_und2					[row]
				
				if ls_flag_und2 = '1' then
					ldc_cantidad_und2 = ldc_cantidad * ldc_factor_conv_und
				else
					ldc_cantidad_und2 = 0
				end if
				
				this.object.cantidad_und2 [row] = ldc_cantidad_und2
			end if
										
			ls_item = Trim(String(This.object.nro_item [row]))
			//Recalculo de Impuesto	
			of_generacion_imp (ls_item)		
			
			//Asigno total
			of_calcular_detraccion()
			dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
			
			dw_master.ii_update = 1
	
		CASE 'cantidad_und2'		
		
			ldc_cantidad_und2 = This.Object.cantidad_und2 [row]
			
			IF IsNull(ldc_cantidad_und2) OR Dec(ldc_cantidad_und2) <= 0 THEN
				gnvo_app.of_mensaje_error('Aviso', 'La Cantidad Und2 no puede ser cero o negativa, revise')
				This.object.cantidad_und2	[row] = 0
				This.object.cantidad			[row] = 0
				RETURN 1
			END IF
	
			
			//Calculo la segunda unidad
			if gnvo_app.of_get_parametro('ALMACEN_CONV_UND2_TO_UND1', '1') = '1' THEN
				ldc_factor_conv_und 	= Dec(This.object.factor_conv_und	[row])
				ls_flag_und2			= This.object.flag_und2					[row]
				
				if ls_flag_und2 = '1' then
					ldc_cantidad = ldc_cantidad_und2 / ldc_factor_conv_und
				else
					ldc_cantidad = 0
				end if
				
				this.object.cantidad [row] = ldc_cantidad

				ls_item = Trim(String(This.object.nro_item [row]))
				//Recalculo de Impuesto	
				of_generacion_imp (ls_item)		
				
				//Asigno total
				of_calcular_detraccion()
				dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
			
			end if
										
			dw_master.ii_update = 1		
			
		CASE 'precio_unitario'	
			ls_flag_seguro_flete = this.object.flag_seguro_flete [row]
			
			if ls_flag_seguro_flete <> '0' then
				of_modify_precio()
			end if
			
			
			ls_item = Trim(String(This.object.nro_item [row]))
			//Recalculo de Impuesto	
			of_generacion_imp (ls_item)		
			
			//Asigno total
			of_calcular_detraccion()
			dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
			
			dw_master.ii_update = 1
	
		CASE 'flag_seguro_flete'	
			ls_flag_seguro_flete = this.object.flag_seguro_flete [row]
			
			if ls_flag_seguro_flete <> '0' then
				of_modify_precio()
			end if
			
			ls_item = Trim(String(This.object.nro_item [row]))
			
			//Recalculo de Impuesto	
			of_generacion_imp (ls_item)		
			
			//Asigno total
			of_calcular_detraccion()
			dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
			
			dw_master.ii_update = 1
			
			
		CASE	'descuento'		
			ls_item = Trim(String(This.object.nro_item [row]))
			//Recalculo de Impuesto	
			of_generacion_imp (ls_item)	
			
			//Asigno total
			of_calcular_detraccion()
			dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
			
			dw_master.ii_update = 1
			  
		CASE	'redondeo_manual'		
			//ls_item = Trim(String(This.object.nro_item [row]))
			//Recalculo de Impuesto	
			//wf_generacion_imp (ls_item)						  
			
			//Asigno total
			of_calcular_detraccion()
			dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
			
			dw_master.ii_update = 1
					
		CASE	'rubro'
			ls_cod_art = this.object.cod_art [row]
			
			select cod_clase into :ls_cod_clase from articulo where (cod_art = :ls_cod_art) ;
			
			select Count(*) into :ll_count from factura_rubro
			 where (rubro 		= :data			)  ;
					 
			if ll_count = 0 then
				Messagebox('Aviso','Rubro No Existe para el codigo de articulo, Veirifque!')
				this.object.rubro [row] = gnvo_app.is_null
				Return 1
			end if
					
		CASE	'centro_benef'	
			select count (*) 
			  into :ll_count
			  from centro_beneficio cb
			where cb.centro_benef	= :data				 
			  and cb.flag_estado 	= '1';
			  
			if ll_count = 0 then
				Messagebox('Aviso','Centro Beneficio No Existe o no esta activo, por favor Verifique!')
				This.Object.centro_benef [row] = gnvo_app.is_null
				Return 1
			end if				
	
		CASE 'und'
			
			select count (*) 
			  into :ll_count
			  from UNIDAD u
			where u.UND	= :data				 
			  and u.flag_estado 	= '1';
			
					  
			if ll_count = 0 then
				Messagebox('Aviso','Unidad ' + data + ' No Existe o no esta activo, por favor Verifique!')
				This.Object.und [row] = gnvo_app.is_null
				Return 1
			end if
			
			this.ii_update = 1
			
			
			//Hago la conversión a la segunda unidad
			ls_und2 = This.Object.und2 [row]
			
			if not IsNull(ls_und2) and trim(ls_und2) <> '' then
				
				ldc_cantidad = Dec(this.object.cantidad [row])
				
				if IsNull(ldc_cantidad) then ldc_cantidad = 0
			
				SELECT U.FACTOR_CONV
				  INTO :ldc_conv
				  FROM UNIDAD_CONV U
				  WHERE U.UND_INGR 	= :data
				  AND 	U.UND_CONV 	= :ls_und2;
				
				if ldc_conv > 0 then
					This.Object.cantidad_und2 			[row] = ldc_cantidad * ldc_conv
				else
					This.Object.cantidad_und2 			[row] = 0
				end if
			end if
			
		CASE 'und2'
			
			select count (*) 
			  into :ll_count
			  from UNIDAD u
			where u.UND	= :data				 
			  and u.flag_estado 	= '1';
			
					  
			if ll_count = 0 then
				Messagebox('Aviso','Unidad ' + data + ' No Existe o no esta activo, por favor Verifique!')
				This.Object.und [row] = gnvo_app.is_null
				Return 1
			end if
			
			this.ii_update = 1
			
			
			//Hago la conversión a la segunda unidad
			ls_und = This.Object.und [row]
			
			if not IsNull(ls_und) and trim(ls_und) <> '' then
				
				ldc_cantidad = Dec(this.object.cantidad [row])
				
				if IsNull(ldc_cantidad) then ldc_cantidad = 0
			
				SELECT U.FACTOR_CONV
				  INTO :ldc_conv
				  FROM UNIDAD_CONV U
				  WHERE U.UND_INGR 	= :ls_und
				  AND 	U.UND_CONV 	= :data;
				
				if ldc_conv > 0 then
					This.Object.cantidad_und2 			[row] = ldc_cantidad * ldc_conv
				else
					This.Object.cantidad_und2 			[row] = 0
				end if
			end if
	
		CASE 'und_peso'
			
			select count (*) 
			  into :ll_count
			  from vw_alm_und_peso u
			where u.UND	= :data				 
			  and u.flag_estado 	= '1';
			
					  
			if ll_count = 0 then
				Messagebox('Aviso','Unidad ' + data + ' no es una unidad de peso, o no esta activa, por favor Verifique!')
				This.Object.und_peso [row] = gnvo_app.is_null
				Return 1
			end if
			
			this.ii_update = 1
	
	
	END CHOOSE


catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Error en Itemchanged')
end try

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;Long   		li_row
String 		ls_signo		, ls_cnta_cntbl, ls_flag_dh_cxp	, ls_desc_cnta		, &
				ls_item		, ls_tipo_doc	, ls_flag_mercado	, ls_centro_benef	, &
				ls_origen	, ls_cod_art	
Decimal 		ldc_tasa_impuesto



//origen de cabecera
ls_origen 	= dw_master.object.origen 	[1]
ls_tipo_doc	= dw_master.object.tipo_doc[1]

if this.of_ExisteCampo("nro_item")then
	This.Object.nro_item	[al_row] = this.of_nro_item()
end if 

if this.of_ExisteCampo("und_peso")then
	This.Object.und_peso	[al_row] = dw_master.object.und_peso [1]
end if 

if this.of_ExisteCampo("peso_bruto")then
	This.Object.peso_bruto	[al_row] = 0.00
end if 



This.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
This.Modify("cod_art.Protect='1~tIf(IsNull(flag_art),1,0)'")

if this.of_ExisteCampo('cantidad_und2') then
	this.object.cantidad_und2 		[al_row] = 0.0000
end if

if this.of_ExisteCampo('flag_seguro_flete') then
	this.object.flag_seguro_flete [al_row] = '0'
end if

this.object.cantidad				[al_row] = 0.0000
this.object.precio_unitario	[al_row] = 0.0000
this.object.cantidad_und2		[al_row] = 0.0000
this.object.flag_und2			[al_row] = '0'
this.object.factor_conv_und	[al_row] = 0.0000

//Se Autogenerara Pre Asientos//
ib_estado_prea = TRUE   //Pre Asiento No editado					

ls_flag_mercado = dw_master.object.flag_mercado [1]

IF ls_flag_mercado <> 'E' THEN
	//Si no es una factura de exportacion debe tener IGV
	li_row = idw_det_imp.InsertRow(0)
	idw_det_imp.object.item [li_row] = al_row
	
	/*Tasa Impuesto Pre Definido*/
	SELECT 	it.tasa_impuesto  , it.signo	, it.cnta_ctbl	 ,
				Decode(it.flag_dh_cxp,'D','H','D'),cc.desc_cnta
	  INTO 	:ldc_tasa_impuesto, :ls_signo, :ls_cnta_cntbl,
				:ls_flag_dh_cxp	, :ls_desc_cnta
	  FROM impuestos_tipo it,
			 cntbl_cnta		 cc
	 WHERE it.cnta_ctbl			= cc.cnta_ctbl 
		AND it.tipo_impuesto 	= :gnvo_app.finparam.is_igv	  ;
	 
	idw_det_imp.object.tipo_impuesto [li_row] = gnvo_app.finparam.is_igv
	idw_det_imp.object.tasa_impuesto [li_row] = ldc_tasa_impuesto 	
	idw_det_imp.object.cnta_ctbl	   [li_row] = ls_cnta_cntbl
	idw_det_imp.object.desc_cnta     [li_row] = ls_desc_cnta
	idw_det_imp.object.signo		   [li_row] = ls_signo
	idw_det_imp.object.flag_dh_cxp   [li_row] = ls_flag_dh_cxp
	
	idw_det_imp.ii_update = 1
	/**/
END IF

//valida si requiere cento de beneficio
if gnvo_app.is_flag_valida_cbe = '1' then
	ls_centro_benef = This.Object.centro_benef [al_row]
						
	IF Isnull(ls_centro_benef) OR TRIM(ls_centro_benef) = '' THEN
		//BUSCAR POR ORIGEN VENTAS VARIAS
		IF idw_referencias.Rowcount () = 0 THEN
			ls_centro_benef = of_cbenef_origen (ls_origen)
			This.Object.centro_benef [al_row] = ls_centro_benef
		END IF
	END IF
end if

This.Object.precio_unit_exp	[al_row] = 0.00
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event buttonclicked;call super::buttonclicked;String		ls_marcas, ls_desc, ls_cod_art
Long			ll_i

str_parametros sl_param

IF row  = 0 THEN RETURN

CHOOSE CASE lower(dwo.name)
	CASE "b_marcas"
		ls_marcas	= This.object.marcas 		[row]
		
		// Para las marcas
		sl_param.string1   = 'Marcas de Factura '
		sl_param.string2	 = ls_marcas
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
				This.object.marcas [row] = sl_param.string3
				ii_update = 1
		END IF
		
	CASE "b_desc"
		ls_desc 		= This.object.descripcion 	[row]
		
		// Para la descripcion de la Factura
		sl_param.string1   = 'Descripcion Nacional de Item de Factura '
		sl_param.string2	 = ls_desc
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
				This.object.descripcion [row] = sl_param.string3
				
				//Averiguo si hay mas registros con el mismo código de artículo
				if MessageBox('Aviso', 'Desea colocar esta descripción a todos los items de la factura?', Information!, YesNo!, 2) = 1 then
					for ll_i = 1 to this.RowCount()
						if ll_i <> row then
							This.object.descripcion [ll_i] = sl_param.string3
						end if
						
					next
				end if
				
				this.ii_update = 1
		END IF

	CASE "b_descripcion_ext"
		ls_desc 		= This.object.descripcion_ext 	[row]
		
		// Para la descripcion de la Factura
		sl_param.string1   = 'Descripcion Extranjera de item de Factura '
		sl_param.string2	 = ls_desc
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
				This.object.descripcion_ext [row] = sl_param.string3
				
				//Averiguo si hay mas registros con el mismo código de artículo
				if MessageBox('Aviso', 'Desea colocar esta descripción a todos los items de la factura?', Information!, YesNo!, 2) = 1 then
					for ll_i = 1 to this.RowCount()
						if ll_i <> row then
							This.object.descripcion_ext [ll_i] = sl_param.string3
						end if
						
					next
				end if
				
				this.ii_update = 1
		END IF
				

END CHOOSE		
end event

event ue_display;call super::ue_display;String 		  		ls_sql	, ls_codigo	, ls_data	, ls_confin			, ls_matriz_cntbl	, &
						ls_rubro	, ls_cod_art, ls_origen	, ls_centro_benef	, ls_und, ls_und2, &
						ls_data2
Decimal				ldc_conv, ldc_cantidad, ldc_cantidad_und2						
str_parametros    lstr_param

CHOOSE CASE lower(as_columna)
	case "especie"
			ls_sql = "Select t.especie as codigo_especie, " &
						 + "t.descr_especie as descripcion_especie " &
						 + "from tg_especies t "&
						 + "Where t.flag_estado = '1' "
					
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.especie 			[al_row] = ls_codigo
			this.object.descr_especie 	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		
	case "nave"
		ls_sql = "select t.nave as nave, " &
				 + "		  t.nomb_nave as nombre_nave, " &
				 + "		  t.matricula AS matricula " &
				 + "from tg_naves t " &
				 + "where t.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.nave 		 [al_row] = ls_codigo
			this.object.nomb_nave [al_row] = ls_data
			this.object.matricula [al_row] = ls_data2
			this.ii_update = 1
		end if
		
			
	CASE 'tipo_cred_fiscal'
		ls_sql = "select t.tipo_cred_fiscal as tipo_cred_fiscal, " &
				 + "t.descripcion as desc_tipo_Cred_fiscal " &
				 + "from credito_fiscal t " &
				 + "where t.flag_estado = '1' " &
				 + "  and t.flag_cxp_cxc = 'C' " &
				 + "order by 1  "
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.tipo_cred_fiscal			[al_row] = ls_codigo
			this.object.desc_tipo_cred_fiscal	[al_row] = ls_data

			this.ii_update = 1
			
		end if

	CASE 'centro_benef'
		ls_sql = "SELECT CB.CENTRO_BENEF AS CODIGO, " &
				 + "CB.DESC_CENTRO AS DESCRIPCION "&
				 + "FROM CENTRO_BENEFICIO CB " &
				 + "WHERE cb.flag_estado = '1'"
				  
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.centro_benef		[al_row] = ls_codigo

			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
		end if
				
				
	CASE 'rubro'
		ls_cod_art = this.object.cod_art [al_row]
		
		if ISNull(ls_cod_art) or trim(ls_cod_art) = '' then
			f_mensaje("Debe seleccionar un articulo para elegir el rubro", "")
			this.setColumn("cod_art")
			return
		end if
		
		ls_sql = "SELECT VW.RUBRO AS CODIGO_RUBRO,"&
				 + "VW.DESCRIPCION AS DESCRIPCION_RUBRO,"&
				 + "VW.COD_SUB_CAT AS CODIGO_SCATEG,"&
				 + "VW.DESC_SUB_CAT AS DESCRIPCION_SCATEG "&
				 + "FROM VW_FIN_RUBRO_SCATEG VW "&
				 + "WHERE VW.COD_ART = '" +ls_cod_art+"'"
		
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.rubro		[al_row] = ls_codigo

			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
		end if
		
	CASE 'cod_art'

		ls_origen = dw_master.object.origen [1]
		
		ls_sql = "SELECT A.COD_ART AS CODIGO_ARTICULO,"&
				 + "A.DESC_ART AS DESCRIPCION_ARTICULO,"&
				 + "A.UND AS UNIDAD ,"&
				 + "A.COD_CLASE AS CLASE_ART "&
				 + "FROM ARTICULO A " &
				 + "where a.flag_estado = '1'"
		
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, '1') then
			
			This.Object.cod_art     [al_row] = ls_codigo //Codigo de articulo
			This.Object.descripcion [al_row] = ls_Data 	//Descripción
			This.Object.und	 		[al_row] = ls_und		//Unidad
			
			/*Recuperar Concepto Financiero*/
			SELECT av.confin , cf.matriz_cntbl 
			  INTO :ls_confin, :ls_matriz_cntbl
			  FROM articulo_venta 		av,   
					 concepto_financiero cf  
			 WHERE cf.confin  = av.confin   (+)
			   AND av.cod_art = :ls_codigo ;
						
			This.Object.confin 		     [al_row] = ls_confin
			This.Object.matriz_cntbl     [al_row] = ls_matriz_cntbl
			
			/*BUSCO RUBRO*/
			SELECT ast.factura_rubro 
			  INTO :ls_rubro
			  FROM articulo 				ar,
			  		 articulo_sub_categ 	ast
			 WHERE ar.sub_cat_art 	= ast.cod_sub_cat             
			   and ar.cod_art 	  	= :ls_codigo ;
			
			/**/
			This.Object.rubro			     [al_row] = ls_rubro
			
			//busca centro de beneficio
			select cba.centro_benef 
			  into :ls_centro_benef
			  from 	centro_benef_articulo 	cba,
						centro_beneficio 			cb
			 where cba.centro_benef = cb.centro_benef 
				and cb.cod_origen    = :ls_origen		 
				and cba.cod_art      = :ls_cod_art;
		  
			if sqlca.sqlcode = 100 then
				//no encuentra centro de beneficio
				This.Object.centro_benef [al_row] = of_cbenef_origen (ls_origen)
			else
				This.Object.centro_benef [al_row] = ls_centro_benef
			end if	
			
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
		end if
				
	CASE 'confin'

		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 3
		lstr_param.str_array[1] = '1'
		lstr_param.str_array[2] = '4'
		lstr_param.titulo 		= 'Selección de Concepto Financiero'
		lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			This.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF

	CASE 'und_peso'
		
		ls_sql = "SELECT U.UND AS CODIGO_UNIDAD, " &
				 + "U.DESC_UNIDAD AS DESCRIPCION " &
				 + "FROM vw_alm_und_peso U " &
				 + "WHERE U.FLAG_ESTADO = '1'"
		
		
		if gnvo_app.of_lista(ls_sql, ls_und, ls_data, '1') then
			This.Object.und_peso 			[al_row] = ls_und
			this.ii_update = 1
			ib_estado_prea = TRUE
		end if
		
				
	CASE 'und'
		
		ls_sql = "SELECT U.UND AS CODIGO_UNIDAD, " &
				 + "U.DESC_UNIDAD AS DESCRIPCION " &
				 + "FROM UNIDAD U " &
				 + "WHERE U.FLAG_ESTADO = '1'"
		
		
		if gnvo_app.of_lista(ls_sql, ls_und, ls_data, '1') then
			This.Object.und 					[al_row] = ls_und
			this.ii_update = 1
			ib_estado_prea = TRUE
			
			//Obtengo la segunda unodad
			ls_und2 = This.Object.und2 [al_row]
			
			if not IsNull(ls_und2) and trim(ls_und2) <> '' then
				
				//Obtengo la cantidad
				ldc_cantidad = Dec(this.object.cantidad [al_row])
				
				If ISNull(ldc_cantidad) then ldc_cantidad = 0
				
				SELECT U.FACTOR_CONV
				  INTO :ldc_conv
				  FROM UNIDAD_CONV U
				  WHERE U.UND_INGR = :ls_und
				  AND 	U.UND_CONV = :ls_und2;
				
				if ldc_conv > 0 then
					This.Object.cantidad_und2 		[al_row] = ldc_cantidad * ldc_conv
				else
					This.Object.cantidad_und2 	[al_row] = 0.00
				end if
				
			end if			
			
		end if

	CASE 'und2'
		
		ls_sql = "SELECT U.UND AS CODIGO_UNIDAD, " &
				 + "U.DESC_UNIDAD AS DESCRIPCION " &
				 + "FROM UNIDAD U " &
				 + "WHERE U.FLAG_ESTADO = '1'"
				  
				 
		
		
		if gnvo_app.of_lista(ls_sql, ls_und2, ls_data, '1') then
			This.Object.und2 					[al_row] = ls_und2
			this.ii_update = 1
			ib_estado_prea = TRUE
			
			//Obtengo la segunda unodad
			ls_und = This.Object.und [al_row]
			
			if not IsNull(ls_und) and trim(ls_und) <> '' then
				
				//Obtengo la cantidad
				ldc_cantidad = Dec(this.object.cantidad [al_row])
				
				If ISNull(ldc_cantidad) then ldc_cantidad = 0
				
				SELECT U.FACTOR_CONV
				  INTO :ldc_conv
				  FROM UNIDAD_CONV U
				  WHERE U.UND_INGR = :ls_und
				  AND 	U.UND_CONV = :ls_und2;
				
				If IsNull(ldc_conv) then ldc_conv = 0
				
				if ldc_conv > 0 then
					This.Object.cantidad_und2 	[al_row] = ldc_cantidad * ldc_conv
				else
					This.Object.cantidad_und2 	[al_row] = 0.00
				end if
				
			end if			
			
		end if		
END CHOOSE



end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail_referencias dw_detail_referencias
end type

on tabpage_2.create
this.dw_detail_referencias=create dw_detail_referencias
this.Control[]={this.dw_detail_referencias}
end on

on tabpage_2.destroy
destroy(this.dw_detail_referencias)
end on

type dw_detail_referencias from u_dw_abc within tabpage_2
integer width = 3081
integer height = 1172
integer taborder = 20
string dataobject = "d_abc_doc_referencias_ctas_cob_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_rk[1] = 3				// columnas de lectrua de este dw
ii_rk[2] = 1				// columnas de lectrua de este dw
ii_rk[3] = 2				// columnas de lectrua de este dw


idw_mst = dw_master
idw_det = idw_referencias 

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;ib_estado_prea = TRUE   //Pre Asiento No editado	
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Impuestos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_5 cb_5
dw_det_imp dw_det_imp
end type

on tabpage_3.create
this.cb_5=create cb_5
this.dw_det_imp=create dw_det_imp
this.Control[]={this.cb_5,&
this.dw_det_imp}
end on

on tabpage_3.destroy
destroy(this.cb_5)
destroy(this.dw_det_imp)
end on

type cb_5 from commandbutton within tabpage_3
integer x = 2679
integer y = 16
integer width = 453
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Eliminar Impuesto"
end type

event clicked;long ll_row
ll_row = idw_det_imp.getrow()

if ll_row = 0 then
	messagebox('Aviso','Debe de seleccionar un Item de la Lista')
	return
end if

do while idw_det_imp.RowCount() > 0 
	idw_det_imp.event ue_delete()
loop


end event

type dw_det_imp from u_dw_abc within tabpage_3
integer width = 2592
integer height = 732
integer taborder = 20
string dataobject = "d_abc_cc_det_imp_tbl"
borderstyle borderstyle = styleraised!
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master
ii_rk[2] = 2				// columnas que recibimos del master

idw_mst = dw_master 						  // dw_master
idw_det = idw_det_imp  // dw_detail


end event

event itemchanged;call super::itemchanged;
String  ls_expresion,ls_item,ls_timpuesto,ls_signo,ls_cnta_cntbl,ls_desc_cnta,&
		  ls_flag_dh_cxp, ls_flag_igv, ls_desc_impuesto, ls_mensaje
Long    ll_found
Decimal ldc_tasa_impuesto, ldc_imp_total,ldc_total,ldc_redondeo

Accepttext()

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

CHOOSE CASE dwo.name
	CASE	'importe'
		//Asigno total
		dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
		dw_master.ii_update = 1
	
	CASE	'tipo_impuesto'
		ls_item = Trim(String(This.object.item [row]))
		
		ls_expresion = "item = " + ls_item + " and tipo_impuesto = '"+data+"'"
		ll_found 	 = This.find(ls_expresion ,1, This.rowcount())				
	
		IF Not(ll_found = row OR ll_found = 0 ) THEN
			Messagebox('Aviso','Nro de Item ya Tiene Considerado Tipo de Impuesto, Verifique!')
			This.Object.tipo_impuesto [row] = gnvo_app.is_null
			This.Object.desc_impuesto [row] = gnvo_app.is_null
			This.Object.signo			  [row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  [row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  [row] = gnvo_app.is_null
			This.Object.flag_igv		  [row] = gnvo_app.is_null
			This.Object.desc_cnta	  [row] = gnvo_app.is_null
			This.Object.importe		  [row] = 0.00
			Return 1
		END IF
		
		//Obtengo el importe de detalle del comprobante
		ls_expresion = 'nro_item = '+ ls_item
		ll_found		 = idw_detail.find(ls_expresion,1,idw_detail.Rowcount())
		
		IF ll_found > 0 THEN
			ldc_imp_total = idw_detail.object.total           [ll_found]							
			ldc_redondeo  = idw_detail.object.redondeo_manual [ll_found]							
			IF Isnull(ldc_imp_total) THEN ldc_imp_total = 0.00
			IF Isnull(ldc_redondeo)  THEN ldc_redondeo  = 0.00
			ldc_imp_total = Round(ldc_imp_total - ldc_redondeo,2)
		END IF
						
		select it.cnta_ctbl,
				 cc.desc_cnta,
				 it.desc_impuesto,
				 it.tasa_impuesto,
				 it.signo,
				 it.flag_dh_cxp,
				 it.flag_igv
		  into :ls_cnta_cntbl,
		  		 :ls_desc_cnta,
		  		 :ls_desc_impuesto,
				 :ldc_tasa_impuesto,
				 :ls_signo,
				 :ls_flag_dh_cxp,
				 :ls_flag_igv
		from 	impuestos_tipo it,
				cntbl_cnta     cc
		where it.cnta_ctbl 		= cc.cnta_ctbl
		  and it.tipo_impuesto 	= :data
		  and it.flag_estado 	= '1';
		
		IF SQLCA.SQlCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			Messagebox('Aviso','Error en consultar tabla impuestos_tipo, Impuesto ' + data + ', Mensaje: ' + ls_mensaje + ', por favor Verifique!')
			This.Object.tipo_impuesto [row] = gnvo_app.is_null
			This.Object.desc_impuesto [row] = gnvo_app.is_null
			This.Object.signo			  [row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  [row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  [row] = gnvo_app.is_null
			This.Object.flag_igv		  [row] = gnvo_app.is_null
			This.Object.desc_cnta	  [row] = gnvo_app.is_null
			This.Object.importe		  [row] = 0.00
			Return 1
		END IF
		
		IF SQLCA.SQlCode = 100 THEN
			Messagebox('Aviso','Tipo de Impuesto ' + data + ' No existe, no existe o no tiene asignado una cuenta contable, por favor Verifique!')
			This.Object.tipo_impuesto [row] = gnvo_app.is_null
			This.Object.desc_impuesto [row] = gnvo_app.is_null
			This.Object.signo			  [row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  [row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  [row] = gnvo_app.is_null
			This.Object.flag_igv		  [row] = gnvo_app.is_null
			This.Object.desc_cnta	  [row] = gnvo_app.is_null
			This.Object.importe		  [row] = 0.00
			Return 1
		END IF

		
		
		This.Object.tasa_impuesto [row] = ldc_tasa_impuesto
		This.Object.desc_impuesto [row] = ls_desc_impuesto
		This.Object.signo			  [row] = ls_signo
		This.Object.cnta_ctbl	  [row] = ls_cnta_cntbl
		This.Object.flag_dh_cxp	  [row] = ls_flag_dh_cxp
		This.Object.flag_igv		  [row] = ls_flag_igv
		This.Object.desc_cnta	  [row] = ls_desc_cnta
		This.Object.importe		  [row] = Round(ldc_imp_total * ldc_tasa_impuesto ,2)/ 100
		
		//Asigno total
		of_calcular_detraccion()
		dw_master.object.importe_doc [dw_master.getrow()] = of_totales ()
		
		dw_master.ii_update = 1


END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_currow,ll_item

ll_currow = idw_detail.GetRow()
ll_item 	 = idw_detail.Object.nro_item [ll_currow]

This.Object.item [al_row] = ll_item

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF

end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data1, ls_data2, ls_data3, ls_Data4, ls_Data5, ls_data6, ls_data7, ls_sql
choose case lower(as_columna)
	case "tipo_impuesto"
		ls_sql = "select it.tipo_impuesto as tipo_impuesto, " &
				 + "       it.desc_impuesto as desc_impuesto, " &
				 + "       it.cnta_ctbl as cnta_cntbl, " &
				 + "       cc.desc_cnta as desc_cnta_cntbl, " &
				 + "       it.tasa_impuesto as tasa_impuesto, " &
				 + "       it.signo as signo, " &
				 + "       it.flag_dh_cxp as flag_dh_cxp, " &
				 + "       it.flag_igv as flag_igv " &
				 + "  from impuestos_tipo it, " &
				 + "		  cntbl_cnta     cc " &
				 + " where it.cnta_ctbl 	= cc.cnta_ctbl " &
		  		 + "   and it.flag_estado 	= '1' " &
				 + "order by it.tipo_impuesto "

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data1, ls_data2, ls_data3, ls_data4, ls_data5, ls_Data6, ls_data7, '1') then
			this.object.tipo_impuesto	[al_row] = ls_codigo
			this.object.desc_impuesto	[al_row] = ls_data1
			this.object.cnta_ctbl		[al_row] = ls_data2
			this.object.desc_cnta		[al_row] = ls_data3
			this.object.tasa_impuesto	[al_row] = Dec(ls_data4)
			this.object.signo				[al_row] = ls_data5
			this.object.flag_dh_cxp		[al_row] = ls_data6
			this.object.flag_igv			[al_row] = ls_data7
			this.ii_update = 1
		end if
		

end choose
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Totales"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_totales dw_totales
end type

on tabpage_4.create
this.dw_totales=create dw_totales
this.Control[]={this.dw_totales}
end on

on tabpage_4.destroy
destroy(this.dw_totales)
end on

type dw_totales from u_dw_abc within tabpage_4
integer y = 12
integer width = 3575
integer height = 732
integer taborder = 20
string dataobject = "d_tot_ctas_x_cobrar_ext_ff"
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'   // tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = dw_master							// dw_master
idw_det  = idw_totales	// dw_detail
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Asiento"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cnt_ctble_cab dw_cnt_ctble_cab
dw_cnt_ctble_det dw_cnt_ctble_det
end type

on tabpage_5.create
this.dw_cnt_ctble_cab=create dw_cnt_ctble_cab
this.dw_cnt_ctble_det=create dw_cnt_ctble_det
this.Control[]={this.dw_cnt_ctble_cab,&
this.dw_cnt_ctble_det}
end on

on tabpage_5.destroy
destroy(this.dw_cnt_ctble_cab)
destroy(this.dw_cnt_ctble_det)
end on

type dw_cnt_ctble_cab from u_dw_abc within tabpage_5
boolean visible = false
integer y = 768
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
ii_dk[3] = 3 	      // columnas que se pasan al detalle
ii_dk[4] = 4 	      // columnas que se pasan al detalle
ii_dk[5] = 5 	      // columnas que se pasan al detalle

idw_mst = idw_asiento_cab // dw_master
idw_det = idw_asiento_det // dw_detail
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.flag_tabla [al_row] = '1'
end event

type dw_cnt_ctble_det from u_dw_abc within tabpage_5
integer width = 3593
integer height = 764
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw
ii_ck[6] = 6			// columnas de lectrua de este dw


ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master
ii_rk[4] = 4 	      // columnas que recibimos del master
ii_rk[5] = 5 	      // columnas que recibimos del master

idw_mst = idw_asiento_cab // dw_master
idw_det = idw_asiento_det	 // dw_detail

end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.item 				[al_row] = al_row
This.Object.flag_gen_aut 	[al_row] = '0'
end event

event itemchanged;call super::itemchanged;Accepttext()
ib_estado_prea = FALSE


end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Datos para Exportacion"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
string powertiptext = "Ingresa datos adicionales para exportadores"
dw_datos_exp dw_datos_exp
end type

on tabpage_7.create
this.dw_datos_exp=create dw_datos_exp
this.Control[]={this.dw_datos_exp}
end on

on tabpage_7.destroy
destroy(this.dw_datos_exp)
end on

type dw_datos_exp from u_dw_abc within tabpage_7
integer width = 3497
integer height = 1368
string dataobject = "d_abc_cntas_cobrar_exp_ff"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String ls_data, ls_flag_mercado, ls_ruc_dni

this.Accepttext()

ls_flag_mercado = this.object.flag_mercado [row]

if lower(dwo.name) <> 'flag_mercado' then
	if ls_flag_mercado = 'L' then
		MessageBox('Error', 'La Factura es local, no se permite ingresar datos de exportacion, por favor verifique')
		return 1
	end if
end if

CHOOSE CASE dwo.name
	CASE 'nave'
		
		// Verifica que codigo ingresado exista			
		select t.nomb_nave
			into :ls_data
		from tg_naves t
		where t.flag_estado 	= '1'
		  and t.nave 		= :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.nave			[row] = gnvo_app.is_null
			this.object.nomb_nave	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de NAVE ' + data + ' no existe o no esta activo, por favor verifique', StopSign!)
			return 1
		end if

		this.object.nomb_nave			[row] = ls_data
		
	CASE 'incoterm'
		
		// Verifica que codigo ingresado exista			
		select t.descripcion
			into :ls_data
		from incoterm t
		where t.flag_estado 	= '1'
		  and t.incoterm 		= :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.incoterm			[row] = gnvo_app.is_null
			this.object.desc_incoterm	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de INCOTERM no existe o no esta activo, por favor verifique', StopSign!)
			return 1
		end if

		this.object.desc_incoterm			[row] = ls_data

	CASE 'puerto_desembarque'
		
		// Verifica que codigo ingresado exista			
		select descr_puerto
			into :ls_Data
		from fl_puertos
		where flag_estado 	= '1'
		  and puerto			= :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.puerto_desembarque		[row] = gnvo_app.is_null
			this.object.desc_puerto_desembarque	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de PUERTO DE DESEMBARQUE no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_puerto_desembarque	[row] = ls_data

	CASE 'puerto_embarque'
		
		// Verifica que codigo ingresado exista			
		select descr_puerto
			into :ls_Data
		from fl_puertos
		where flag_estado 	= '1'
		  and puerto			= :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.puerto_embarque		[row] = gnvo_app.is_null
			this.object.desc_puerto_embarque	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de PUERTO DE EMBARQUE no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_puerto_embarque	[row] = ls_data

	CASE 'notify'
		
		// Verifica que codigo ingresado exista			
		select p.nom_proveedor, decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident)
			into :ls_data, :ls_ruc_dni
		from proveedor p
		where p.flag_estado 	= '1'
		  and p.proveedor		= :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.notify			[row] = gnvo_app.is_null
			this.object.nom_notify		[row] = gnvo_app.is_null
			this.object.ruc_dni_notify	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de NOTIFICADOR no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.nom_notify		[row] = ls_data
		this.object.ruc_dni_notify	[row] = ls_ruc_dni

	CASE 'consignee'
		
		// Verifica que codigo ingresado exista			
		select p.nom_proveedor, decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident)
			into :ls_data, :ls_ruc_dni
		from proveedor p
		where p.flag_estado 	= '1'
		  and p.proveedor		= :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.consignee			[row] = gnvo_app.is_null
			this.object.nom_consignee		[row] = gnvo_app.is_null
			this.object.ruc_dni_consignee	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de CONSIGNATARIO no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.nom_consignee		[row] = ls_data
		this.object.ruc_dni_consignee	[row] = ls_ruc_dni

END CHOOSE
end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr		[al_row] = gs_user

if dw_master.getRow() > 0 then
	this.object.tipo_doc		[al_row] = dw_master.object.tipo_doc 	[dw_master.getRow()]
	this.object.nro_doc		[al_row] = dw_master.object.nro_doc 	[dw_master.getRow()]
end if
end event

event ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc, ls_flag_mercado
str_nave	lstr_nave
ls_flag_mercado = this.object.flag_mercado [al_row]

if lower(as_columna) <> 'flag_mercado' then
	if ls_flag_mercado = 'L' then
		MessageBox('Error', 'La Factura es local, no se permite ingresar datos de exportacion, por favor verifique')
		return 
	end if
end if


CHOOSE CASE lower(as_columna)
	
	CASE "nave"
	
	lstr_nave = gnvo_app.invo_flota.of_get_nave( 'T')
	
	if lstr_nave.b_return then
		This.object.nave 		[al_row] = lstr_nave.nave
		This.object.nomb_nave[al_row] = lstr_nave.nombre
		This.ii_update = 1
	end if

		
	CASE "incoterm"
		
		ls_sql = "select i.incoterm as incoterm, " &
				 + "i.descripcion as desc_incoterm " &
				 + "from incoterm i " &
				 + "where i.flag_estado = '1''"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.incoterm 		[al_row] = ls_codigo
			This.object.desc_incoterm 	[al_row] = ls_data
			This.ii_update = 1
			
		END IF
		
	CASE "puerto_embarque"
		
		ls_sql = "select fp.puerto as codigo_puerto, " &
				 + "fp.descr_puerto as desc_puerto " &
				 + "from fl_puertos fp " &
				 + "where fp.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.puerto_embarque 		[al_row] = ls_codigo
			This.object.desc_puerto_embarque	[al_row] = ls_data
			This.ii_update = 1
			
		END IF
		
	CASE "puerto_desembarque"
		
		ls_sql = "select fp.puerto as codigo_puerto, " &
				 + "fp.descr_puerto as desc_puerto " &
				 + "from fl_puertos fp " &
				 + "where fp.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.puerto_desembarque 		[al_row] = ls_codigo
			This.object.desc_puerto_desembarque	[al_row] = ls_data
			This.ii_update = 1
			
		END IF
		
	CASE "notify"
		
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_CLIENTE,"&
				 + "P.NOM_PROVEEDOR    AS nombre_cliente,"&
				 + "DECODE(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO = '1'" 
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')

		if ls_codigo <> '' then
			this.object.notify			[al_row] = ls_codigo
			this.object.nom_notify		[al_row] = ls_data
			this.object.ruc_dni_notify	[al_row] = ls_ruc
			
			this.ii_update = 1

		end if
	
	CASE "consignee"
		
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_CLIENTE,"&
				 + "P.NOM_PROVEEDOR    AS nombre_cliente,"&
				 + "DECODE(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni "&
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO = '1'" 
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')

		if ls_codigo <> '' then
			this.object.consignee			[al_row] = ls_codigo
			this.object.nom_consignee		[al_row] = ls_data
			this.object.ruc_dni_consignee	[al_row] = ls_ruc
			
			this.ii_update = 1

		end if


END CHOOSE
end event

event buttonclicked;call super::buttonclicked;str_parametros	lstr_param

if row = 0 then return

if lower(dwo.name) = 'b_precinto' then
	If this.is_protect("seal_code", row) then RETURN
	
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Ingrese los Precintos de la factura'
	lstr_param.string2	 = this.object.seal_code [row]
	
	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.seal_code [row] = left(lstr_param.string3, 200)
			this.ii_update = 1
	END IF	
	
elseif lower(dwo.name) = 'b_contenedor' then
	
	If this.is_protect("nro_contenedor", row) then RETURN
	
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Ingrese los Numeros de contenedores de la factura'
	lstr_param.string2	 = this.object.nro_contenedor [row]
	
	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.nro_contenedor [row] = left(lstr_param.string3, 200)
			this.ii_update = 1
	END IF
end if
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1404
long backcolor = 79741120
string text = "Exportacion"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_exportacion dw_exportacion
end type

on tabpage_6.create
this.dw_exportacion=create dw_exportacion
this.Control[]={this.dw_exportacion}
end on

on tabpage_6.destroy
destroy(this.dw_exportacion)
end on

type dw_exportacion from u_dw_abc within tabpage_6
event ue_display ( string as_columna,  long al_row )
integer width = 2926
integer height = 1116
integer taborder = 20
string dataobject = "d_ve_factura_exportacion_ff"
borderstyle borderstyle = styleraised!
end type

event ue_display;boolean 	lb_ret
Long     ll_found
string 	ls_codigo, ls_data, ls_sql, ls_nro_ov

IF idw_detail.rowcount() = 0 THEN RETURN

CHOOSE CASE upper(as_columna)
		
	CASE "NRO_EMBARQUE"
		
		ls_nro_ov = of_recupera_nro_ov()
		
		if IsNull(ls_nro_ov) then
			MessageBox('Error', 'No ha especificado una Orden de Venta, por favor verifique!')
			return
		end if
		
		ls_sql = "SELECT NRO_EMBARQUE AS EMBARQUE, " &
			    + "NAVE AS NAVES, " 	 &
				 + "INCOTERM AS INCOTERM, " &
				 + "FEC_ZARPE_ORG AS FEC_ZARPE_ORG " &
				 + "FROM EMBARQUE " &
				 + "where flag_estado = '1' " &
				 + "AND nro_embarque not in (select nro_embarque from factura_exportacion where nro_embarque is not null) " &
				 + "AND NRO_OV = '" + ls_nro_ov + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_embarque [al_row] = ls_codigo
		END IF
		
		This.ii_update = 1
	

END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'm'		

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event itemchanged;call super::itemchanged;string 	ls_flag, ls_data, ls_codigo,  ls_nro_ov
Long		ll_count

THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "NRO_EMBARQUE"
		ls_nro_ov = of_recupera_nro_ov();
		
		if IsNull(ls_nro_ov) then
			Messagebox('Aviso', "No ha especificado una Orden de Venta, por favor verifique!", StopSign!)
			This.object.nro_embarque	[row] = gnvo_app.is_null
			RETURN 1
		end if
		
		SELECT  count(*)
		  INTO  :ll_count
		FROM EMBARQUE
		WHERE nro_embarque 	= :data
		  AND nro_ov 			= :ls_nro_ov
		  and flag_estado		= '1';
	
		IF ll_count = 0 THEN
			Messagebox('Aviso', "Embarque no existe, no esta activo o no corresponde a la orden de Venta " + ls_nro_ov, StopSign!)
			This.object.nro_embarque	[row] = gnvo_app.is_null
			RETURN 1
		END IF

END CHOOSE
end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr		[al_row] = gs_user

if dw_master.getRow() > 0 then
	this.object.tipo_doc		[al_row] = dw_master.object.tipo_doc 	[dw_master.getRow()]
	this.object.nro_doc		[al_row] = dw_master.object.nro_doc 	[dw_master.getRow()]
end if
end event

event buttonclicked;call super::buttonclicked;IF gs_empresa = 'FISHOLG' THEN

	String		ls_gdet
	str_parametros sl_param
	
	IF row  = 0 THEN RETURN
	
	ls_gdet = This.object.glosa_detalle 		[row]
	
	CHOOSE CASE lower(dwo.name)
		CASE "b_det"
			// Para las marcas
			sl_param.string1   = 'Glosa Detalle de Exportación'
			sl_param.string2	 = ls_gdet
		
			OpenWithParm( w_descripcion_fac, sl_param)
			
			IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
			IF sl_param.titulo = 's' THEN
					This.object.glosa_detalle [row] = sl_param.string3
					ii_update = 1
			END IF
	END CHOOSE
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_ve310_cntas_cobrar
integer width = 4091
integer height = 1212
string dataobject = "d_abc_cntas_x_cobrar_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;of_asigna_dws()
is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1	// columnas de lectura de este dw
ii_ck[2] = 2  	// columnas de lectura de este dw
ii_dk[1] = 1   // columnas que se pasan al detalle
ii_dk[2] = 2	// columnas que se pasan al detalle
idw_mst  = dw_master 					 // dw_master
idw_det  = idw_detail // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fecha


try 
	
	ib_cierre = false
	this.object.t_cierre.text = ''
	
	ldt_fecha = gnvo_app.of_fecha_actual()
	
	if gnvo_app.ventas.is_flag_efact = '1' then
		this.object.b_envio_efact.visible = "Yes"
		this.object.b_download.Visible = "Yes"
		
		this.object.b_envio_efact.Enabled = "No"
		this.object.b_download.Enabled = "No"
	
	else
	
		this.object.b_envio_efact.visible = "No"
		this.object.b_download.Visible = "No"
	
	end if
	
	This.Object.origen		      [al_row] = gs_origen
	This.Object.cod_usr		      [al_row] = gs_user
	This.Object.fecha_registro    [al_row] = ldt_fecha
	This.Object.fecha_documento   [al_row] = Date(ldt_fecha)
	This.Object.fecha_presentacion[al_row] = Date(ldt_fecha)
	This.Object.fecha_vencimiento	[al_row] = Date(ldt_fecha)
	This.Object.ano				   [al_row] = Long(String(ldt_fecha,'YYYY'))
	This.Object.mes			 	   [al_row] = Long(String(ldt_fecha,'MM'))
	This.Object.tasa_cambio		   [al_row] = gnvo_app.of_tasa_cambio_vta(Date(ldt_fecha))
	This.Object.flag_estado	      [al_row] = '1'
	This.Object.ind_detrac	      [al_row] = '1'
	This.Object.flag_detraccion   [al_row] = '0'
	This.Object.flag_provisionado [al_row] = 'R'
	This.Object.importe_doc 	  	[al_row] =  0.00
	This.Object.imp_detraccion   	[al_row] =  0.00
	this.object.flag_efact 			[al_row] = gnvo_app.ventas.is_flag_efact
	This.Object.peso_bruto	 	  	[al_row] =  0.00
	This.Object.peso_neto	 	  	[al_row] =  0.00
	This.Object.flag_mercado 	  	[al_row] =  'L'
	This.Object.valor_fob 	  		[al_row] =  0.00
	This.Object.flete 			  	[al_row] =  0.00
	This.Object.seguro	 	  		[al_row] =  0.00
	
	if this.of_ExisteCampo("und_peso")then
		This.Object.und_peso	 	  		[al_row] =  gnvo_app.logistica.is_und_kgr
	end if
	
	if this.of_ExisteCampo("und_peso_1")then
		This.Object.und_peso_1 	  		[al_row] =  gnvo_app.logistica.is_und_kgr
	end if
	
	
	this.object.flag_enviar_efact	[al_row] = '0'
	
	//Activo el falg de enviaro a efact
//	if gnvo_app.ventas.is_emisor_electronico = '1' then
//		if gnvo_app.ventas.is_flag_efact = '0' then
//			this.object.flag_enviar_efact	[al_row] = '1'
//		else
//			this.object.flag_enviar_efact	[al_row] = '0'
//		end if
//	else
//		this.object.flag_enviar_efact	[al_row] = '0'
//	end if
	
	
	//** **//
	ib_modif_detraccion = false
	
	is_action = 'new'

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al insertar registro en DataWindow Master')
	
finally
	this.setcolumn('tipo_doc')
end try

end event

event itemchanged;call super::itemchanged;String 	ls_nom_proveedor  	, ls_forma_pago 		, ls_cod_relacion		, &
		 	ls_dir_dep_estado 	, ls_dir_distrito 	, ls_dir_direccion	, &
		 	ls_ruc,ls_tipo_doc	, ls_flag_detraccion	, ls_nro_detraccion	, &
		 	ls_solicitud_credito	, ls_nro_solicitud	, ls_nom_vendedor		, &
			ls_origen				, ls_flag_imp			, ls_nro_serie			, &
			ls_desc					, ls_flag_nac_ext

Date   	ld_fecha_documento, ld_fecha_vencimiento, ld_fecha_documento_old, ld_hoy
Decimal	ldc_tasa_cambio, ldc_tasa, ldc_total
Integer  li_dias_venc,li_opcion, li_num_dir 
Long     ll_nro_libro,ll_count


try 
	ld_fecha_documento_old 	= Date(This.object.fecha_documento [row])
	ld_hoy						= Date(gnvo_app.of_fecha_actual())
	
	this.Accepttext()
	
	/*Datos del Registro Modificado*/
	ib_estado_prea = TRUE
	/**/
	
	CHOOSE CASE dwo.name
		CASE	'bien_serv'
			IF this.object.flag_detraccion[row] = '0' THEN
				this.object.bien_serv 	[row] = gnvo_app.is_null
				Messagebox('Aviso','Debe Seleccionar que Generara Detracción')
				this.setColumn("flag_detraccion")
				Return 2
			END IF
			
			select tasa_pdbe ,flag_ind_imp 
				into :ldc_tasa ,:ls_flag_imp 
			  from detr_bien_serv
			 where bien_serv   = :data 
				and flag_estado = '1';
					  
			
			if sqlca.sqlcode = 100 then
				Messagebox('Aviso','Codigo de Detraccion No Existe o Esta Inactivo,Verifique!')	
				this.object.bien_serv       [row] = gnvo_app.is_null
				this.object.flag_ind_imp    [row] =	gnvo_app.is_null
				this.object.porc_detraccion [row] =	0.00
				Return 1
			end if
			
			this.object.porc_detraccion [row] =	ldc_tasa
			this.object.flag_ind_imp    [row] =	ls_flag_imp
			
			
			of_calcular_detraccion()
			ldc_total = of_totales ()		
			dw_master.object.importe_doc [1] = ldc_total
			dw_master.ii_update = 1
			of_total_ref ()
					
			ib_modif_detraccion = false
	
			
		CASE 'porc_detraccion'	
			
			ls_flag_detraccion = This.object.flag_detraccion [row]	
			
			IF ls_flag_detraccion = '0' THEN
				this.object.porc_detraccion	[row] = 0.00
				Messagebox('Aviso','Documento no tiene indicador detracción Activo ,Verifique!')	  	
				RETURN 1
			END IF
			
			of_calcular_detraccion()
			
		CASE 'tasa_cambio'
			of_calcular_detraccion()		
	
		case 'porc_detraccion'	
			of_calcular_detraccion()
		
		case 'imp_detraccion'	
			ib_modif_detraccion = true
			
		CASE	'tipo_doc'
			ls_origen = this.object.origen [row]
			
			select dt.nro_libro, dtu.nro_serie
				into :ll_nro_libro, :ls_nro_serie
			from 	doc_tipo dt,
					doc_tipo_usuario dtu,
					doc_grupo_relacion g
			where dt.tipo_doc 		= dtu.tipo_doc
			  and dt.tipo_doc 		= g.tipo_doc
			  and dt.flag_estado 	= '1'    
			  and g.grupo				= :is_doc_cxc
			  and dt.tipo_doc 		= :data
			  and dtu.cod_usr  		= :gs_user;
			
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Tipo de Documento No Existe, no esta activo, no pertenece al grupo de Cntas x Cobrar o no tiene acceso a dicho documento, por favor verifique!')
				This.Object.tipo_doc 	 	[row] = gnvo_app.is_null
				This.Object.nro_libro	 	[row] = gnvo_app.il_null
				This.Object.serie	 			[row] = gnvo_app.is_null
				this.object.numero			[row] = gnvo_app.is_null
				Return 1
			end if
			
			This.Object.nro_libro 	[row] = ll_nro_libro
			This.object.serie 		[row] = ls_nro_serie
			this.object.numero		[row] = gnvo_app.is_null
			
			if left(ls_nro_serie, 1) <> 'F' and left(ls_nro_serie, 1) <> 'B' then
				ii_lin_x_doc = gnvo_app.of_nro_lineas( data, ls_origen)
				
				if data = gnvo_app.is_doc_ex and idw_exportacion.RowCount() = 0 then
					idw_exportacion.event ue_insert( )
				end if
			end if
			
			//Obtengo el numero actual de la factura
			this.object.numero [row] = gnvo_app.utilitario.of_nro_tipo_serie(data, ls_nro_serie)
	
					
					
		CASE 'cod_relacion'
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El codigo del Cliente')
				This.Object.cod_relacion [row] = This.Object.cod_relacion_det [row]
				Return 1
			END IF
		
			SELECT 	p.nom_proveedor,
						decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident),
						p.flag_nac_ext
			  INTO 	:ls_nom_proveedor,
						:ls_ruc,
						:ls_flag_nac_ext
			  FROM proveedor p
			 WHERE p.proveedor   =  :data 
				AND p.flag_estado = '1'
				and p.flag_clie_prov in ('0', '2');
			
			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Aviso','Código de Cliente ingresado ' + data + ' no Existe, no esta activo o no correspondiente a un Cliente, por favor verifique!', StopSign!)
				This.Object.cod_relacion 		[row] = gnvo_app.is_null
				This.Object.nom_proveedor 		[row] = gnvo_app.is_null
				This.Object.ruc_dni_cliente	[row] = gnvo_app.is_null
				this.object.item_direccion		[row] = gnvo_app.ii_null
				this.object.direccion			[row] = gnvo_app.is_null
				this.object.flag_nac_Ext		[row] = gnvo_app.is_null
				Return 1
			end if
			
			if IsNull(ls_ruc) or trim(ls_ruc) = '' then
				Messagebox('Aviso','El Cliente ' + ls_nom_proveedor + ' no tiene Numero de documento de identificacion (RUC, DNI, OTROS), por favor Verifique!', StopSign!)
				This.Object.cod_relacion 		[row] = gnvo_app.is_null
				This.Object.nom_proveedor 		[row] = gnvo_app.is_null
				This.Object.ruc_dni_cliente	[row] = gnvo_app.is_null
				this.object.item_direccion		[row] = gnvo_app.ii_null
				this.object.direccion			[row] = gnvo_app.is_null
				this.object.flag_nac_Ext		[row] = gnvo_app.is_null
				Return 1
			end if
			
			This.Object.nom_proveedor		[row] = ls_nom_proveedor
			This.Object.ruc_dni_cliente	[row] = ls_ruc
			this.object.item_direccion		[row] = gnvo_app.ii_null
			this.object.direccion			[row] = gnvo_app.is_null
			this.object.flag_nac_Ext		[row] = ls_flag_nac_ext
			
			if ls_flag_nac_ext = 'N' then
				this.object.flag_mercado	[row] = 'L'
			else
				this.object.flag_mercado	[row] = 'E'
			end if
	
			
					
		CASE 'item_direccion'			
		
			ls_cod_relacion = dw_master.object.cod_relacion [row]		
			
			IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
				Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
				Return 1
			END IF
		
			/**/
			li_num_dir = Integer(data)
			/**/
			
		
			SELECT PKG_LOGISTICA.of_get_direccion(codigo, item)
			  INTO :ls_dir_direccion
			  FROM direcciones
			 WHERE codigo = :ls_cod_relacion
				AND item   = :li_num_dir     
				AND flag_uso in ('1', '3');
					  
					  
			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Aviso','Direccion No Existe , Verifique!')				
				This.Object.item_direccion [row] = gnvo_app.ii_null
				This.Object.direccion      [row] = gnvo_app.is_null
				Return 1 
			end if
				
			This.Object.direccion [row] = ls_dir_direccion
			
			
		CASE 'cod_moneda'
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda')
				This.Object.cod_moneda [row] = This.Object.moneda_det [row]
				Return 1
			END IF
			
		CASE 'nro_sol_cred_rrhh'
		
			ls_solicitud_credito = dw_master.object.nro_sol_cred_rrhh [row]
			
			select nro_solicitud 
			  into :ls_nro_solicitud  
			 from rrhh_credito_solicitud
			 where nro_solicitud = :ls_solicitud_credito and
					 flag_estado = '2' ;
			  
			IF ls_nro_solicitud <> ls_solicitud_credito THEN
				Messagebox('Aviso',' El numero de solicitud no es valido')
				This.Object.nro_sol_cred_rrhh[row] =	This.Object.nro_sol_cred_rrhh[row] 
				Return 1
			END IF				
			
			
		CASE 'fecha_documento'
			
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede Cambiar la Fecha de Documento porque tiene  Documentos de Referencia , Verifique!')
				This.Object.fecha_documento 	[row] = ld_fecha_documento_old
				This.Object.tasa_cambio 		[row] = gnvo_app.of_tasa_cambio_vta(ld_fecha_documento_old)
				Return 1
			END IF
			
			ls_nro_serie = this.object.serie	[row]
			IF Isnull(ls_nro_serie) OR Trim(ls_nro_serie)  = '' THEN
				Messagebox('Aviso','Debe Ingresar una serie del documento , Verifique!', StopSign!)
				this.setColumn("tipo_doc")
				Return 1
			END IF
			
			ld_fecha_documento   = Date(This.Object.fecha_documento   [row])	
			
			//Si es una factura electronica, la fecha del documento no puede ser mayor a 7 días
			//Para ello debe ser emisor electronico
			if gnvo_app.ventas.is_emisor_electronico = '0' then
				if left(ls_nro_serie, 1) = 'F' or left(ls_nro_serie, 1) = 'B' then
					
					Messagebox('Aviso','La serie con F o B esta reservada unicamente para emisores electrónicos, ' &
										  + 'y usted no esta configurado como emisor electronico. Por favor verifique!', StopSign!)
	
					this.object.serie [row] = gnvo_app.is_null
					this.setColumn("tipo_doc")
					Return 1

				end if
			end if
			
			//Ahora verifico si valida o no la fecha
			if left(ls_nro_serie, 1) = 'F' or left(ls_nro_serie, 1) = 'B' then
				if gnvo_app.ventas.is_valida_fec_emision_fac = "1" then
					if DaysAfter(ld_fecha_documento, ld_hoy) > gnvo_app.ventas.il_nro_dias_max_fec_emision then
							
						This.Object.fecha_documento 	[row] = ld_fecha_documento_old
						This.Object.tasa_cambio 		[row] = gnvo_app.of_tasa_cambio_vta(ld_fecha_documento_old)
						
						Messagebox('Aviso','Fecha de Emisión del Documento No '&
											+'Puede Ser Mayor a ' &
											+ string(gnvo_app.ventas.il_nro_dias_max_fec_emision) &
											+  ' días de la fecha actual. Por favor verifique', StopSign!)
		
						return 1
					end if
				end if
			end if
		
			//Coloco el periodo
			This.object.ano [row] = Long(String(ld_fecha_documento,'yyyy'))
			This.object.mes [row] = Long(String(ld_fecha_documento,'mm'))
			
			//Obtengo la tasa de cambio
			This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio_vta(ld_fecha_documento)

			//Coloco la fecha de vencimento
			ls_forma_pago = This.Object.forma_pago [row]

			IF Not(Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
				li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
			
				IF li_dias_venc > 0 THEN
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					IF li_opcion = 1 THEN
						ld_fecha_vencimiento = Relativedate(DATE(This.object.fecha_documento[row]),li_dias_venc)
						This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
					END IF
				END IF
			END IF
			
		CASE 'fecha_presentacion'
		  ls_forma_pago = This.Object.forma_pago [row]
			
			
		  IF Not(Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
				li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
			
				IF li_dias_venc > 0 THEN
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					IF li_opcion = 1 THEN
						ld_fecha_vencimiento = Relativedate(DATE(This.object.fecha_presentacion[row]),li_dias_venc)
						This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
					END IF
				END IF
			END IF
		
		CASE 'fecha_vencimiento'	
			ld_fecha_documento   = Date(This.Object.fecha_documento   [row])			
			ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
			
			IF ld_fecha_vencimiento < ld_fecha_documento THEN
				This.Object.fecha_vencimiento [row] = ld_fecha_documento
				Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
										+'Puede Ser Menor a la Fecha de Emisión')
				Return 1
			END IF
			
		CASE 'forma_pago'
			
			li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
			IF li_dias_venc > 0 THEN
				
				li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
				IF li_opcion = 1 THEN
					ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_presentacion[row]),li_dias_venc)
					This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
				END IF
			ELSE
				This.Object.fecha_vencimiento [row] = This.object.fecha_presentacion[row]
			END IF
			
		CASE 'flag_detraccion'
		
		  if data = '0' then
			  Setnull(ls_nro_detraccion)
			  this.object.porc_detraccion [row] = 0.00
			  this.object.nro_detraccion  [row] = ls_nro_detraccion
		  end if
		  
		CASE 'porc_detraccion'	
		
		  ls_flag_detraccion = This.object.flag_detraccion [row]	
		  
		  IF ls_flag_detraccion = '0' THEN
			  this.object.porc_detraccion	[row] = 0.00
			  Messagebox('Aviso','Documento no tiene indicador detracción Activo ,Verifique!')	  	
			  RETURN 1
		  END IF
		  
		CASE 'vendedor'
		
			select v.nom_vendedor
			  into :ls_nom_vendedor
			  from vendedor v
			 where v.vendedor = :data
			   and v.flag_estado <> '0';
			
			if SQLCA.SQLCode = 100 then
				ROLLBACK;
				messagebox('Aviso','Codigo de Vendedor no existe o no se encuentra activo. Por favor verifique!', StopSign!)
				this.object.vendedor			[row] = gnvo_app.is_null
				this.object.nom_vendedor	[row] = gnvo_app.is_null
				return 1
			end if
			
			this.object.nom_vendedor[row] = ls_nom_vendedor

		CASE 'und_peso'
		
			select u.desc_unidad
				into :ls_desc
			from unidad u,
				  (select column_value as und
					 from table(split(pkg_config.USF_GET_PARAMETER('UNIDADES_PESO', 'KGR,LBS,TON'))))s
			 where u.und 			= s.und
				and u.flag_estado = '1'
				and u.und			= :data;
			
			if SQLCA.SQLCode = 100 then
				ROLLBACK;
				messagebox('Aviso','Unidad de Peso ' + data + ' no existe, no se encuentra ' &
									  + 'activo o no pertecene al grupo "UNIDADES_PESO". ' &
									  + 'Por favor verifique!', StopSign!)
				this.object.und_peso		[row] = gnvo_app.is_null
				this.object.und_peso_1	[row] = gnvo_app.is_null
				return 1
			end if
			
			this.object.und_peso		[row] = data
			this.object.und_peso_1	[row] = data
	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error o exception')
end try

end event

event ue_display;call super::ue_display;String     	ls_name ,ls_prot ,ls_cod_relacion ,ls_distrito ,ls_estado , ls_direccion, &
				ls_vendedor, ls_ruc, ls_codigo, ls_data, ls_sql, ls_nro_libro, ls_origen, &
				ls_flag_detrac, ls_tasa, ls_flag_importe, ls_serie, ls_flag_nac_ext
Date       	ld_fecha_documento,ld_fecha_vencimiento
Decimal 		ldc_tasa_cambio, ldc_total
Boolean		lb_ret
str_seleccionar lstr_seleccionar
str_parametros   sl_param



CHOOSE CASE lower(as_columna)
	CASE	'bien_serv'	
			
		ls_flag_detrac = This.object.flag_detraccion [al_row]
		
		if ls_flag_detrac <> '1' then
			Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
			Return 	
		end if
		
		ls_sql = "SELECT 	S.BIEN_SERV    AS CODIGO ,"&
				 + "			S.DESCRIPCION  AS DESCRIPCION ," &
				 + "		 	S.TASA_PDBE	  AS TASA_BIEN_SERV, "&
				 + "		 	S.FLAG_IND_IMP AS FLAG_IMPORTE	  "&	
				 + "  FROM DETR_BIEN_SERV S " & 
				 + " WHERE S.FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tasa, ls_flag_importe, "2")
		
		if ls_codigo <> "" then
		
			this.object.bien_serv       [al_row] = ls_codigo
			this.object.porc_detraccion [al_row] =	dec(ls_tasa)
			
			of_calcular_detraccion()
			ldc_total = of_totales ()		
			dw_master.object.importe_doc [1] = ldc_total
			dw_master.ii_update = 1
			of_total_ref ()
				
			ib_modif_detraccion = false
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		end if
		
	CASE	'oper_detr'	
			
		ls_flag_detrac = This.object.flag_detraccion [al_row]
		
		if ls_flag_detrac <> '1' then
			Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
			Return 	
		end if
		
		ls_sql = "select oper_detr as codigo_operacion, " &
				 + "descripcion as descripcion_operacion " &
				 + "from detr_operacion " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
		
			this.object.oper_detr       [al_row] = ls_codigo
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		end if

	CASE 'tipo_doc'
		ls_origen = this.object.origen [al_row]
		
		if gnvo_app.ventas.is_emisor_electronico = '1' then
			ls_sql = "select dtu.tipo_doc as tipo_doc, " &
					 + "dt.nro_libro as nro_libro, " &
					 + "dtu.nro_serie as nro_serie, " &
					 + "dtu.cod_usr as cod_usuario " &
					 + "from doc_tipo dt, " &
					 + "     doc_tipo_usuario dtu, " &
					 + "     doc_grupo_relacion g " &
					 + "where dt.tipo_doc = dtu.tipo_doc " &
					 + "  and dt.tipo_doc = g.tipo_doc " &
					 + "  and dt.flag_estado = '1'" &
					 + "  and dtu.cod_usr = '" + gs_user + "'" &
					 + "  and g.grupo ='" + is_doc_cxc + "'"
		else
			//En caso que no seas emisor electronico, no debería tomar las series que empiecen con 
			//F o B
			ls_sql = "select dtu.tipo_doc as tipo_doc, " &
					 + "dt.nro_libro as nro_libro, " &
					 + "dtu.nro_serie as nro_serie, " &
					 + "dtu.cod_usr as cod_usuario " &
					 + "from doc_tipo dt, " &
					 + "     doc_tipo_usuario dtu, " &
					 + "     doc_grupo_relacion g " &
					 + "where dt.tipo_doc = dtu.tipo_doc " &
					 + "  and dt.tipo_doc = g.tipo_doc " &
					 + "  and substr(dtu.nro_serie, 1,1) not in ('F', 'B') " &
					 + "  and dt.flag_estado = '1'" &
					 + "  and dtu.cod_usr = '" + gs_user + "'" &
					 + "  and g.grupo ='" + is_doc_cxc + "'"
		end if
				
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_nro_libro, ls_data,  '2')

		if ls_codigo <> '' then
			
			if gnvo_app.ventas.is_emisor_electronico = '0' then
				if left(ls_data, 1) = 'F' or left(ls_data, 1) = 'B' then
					Messagebox('Aviso','La serie con F o B esta reservada unicamente para emisores electrónicos, ' &
										  + 'y usted no esta configurado como emisor electronico. Por favor verifique!', StopSign!)

					return
				end if
			end if
			
			this.object.tipo_doc		[al_row] = ls_codigo
			this.object.nro_libro	[al_row] = Long(ls_nro_libro)
			this.object.serie			[al_row] = ls_data
			this.object.numero		[al_row] = gnvo_app.is_null
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
			
			//Si no es factura electronica, entonces debo validar la cantidad de lineas
			if left(ls_data, 1) <> 'F' and left(ls_data, 1) <> 'B' then
				ii_lin_x_doc = gnvo_app.of_nro_lineas( ls_codigo, ls_origen )
				
				if ls_codigo = gnvo_app.is_doc_ex then
					if idw_exportacion.RowCount() = 0 then
						idw_exportacion.event ue_insert( )
					end if
				end if
			end if
			
			//Obtengo el numero actual de la factura
			this.object.numero [al_row] = gnvo_app.utilitario.of_nro_tipo_serie(ls_codigo, ls_data)

		end if
		
	CASE 'item_direccion'
	
		ls_cod_relacion = dw_master.object.cod_relacion [al_row]		
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
			Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
			Return 
		END IF

		// Solo Tomo la Direccion de facturacion
		ls_sql = "SELECT D.ITEM AS ITEM," &    
				 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
				 + "FROM DIRECCIONES D "&
				 + "WHERE D.CODIGO = '" + ls_cod_relacion +"' " &
				 + "AND D.FLAG_USO in ('1', '3')"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.item_direccion	[al_row] = Long(ls_codigo)
			this.object.direccion		[al_row] = ls_data
			this.ii_update = 1
			ib_estado_prea = TRUE
		end if

				  
	CASE 'cod_relacion'
		
		IF idw_referencias.rowcount() > 0 THEN
			Messagebox('Aviso','No puede	Cambiar El codigo del Cliente', StopSign!)
			Return
		END IF
		
		ls_serie = this.object.serie [al_row]
		IF Isnull(ls_serie) OR Trim(ls_serie)  = '' THEN
			Messagebox('Aviso','Debe ingresar la serie correspondiente, por favor Verifique!', StopSign!)
			this.setColumn('tipo_doc')
			Return 
		END IF
		
		if left(ls_serie, 1 )= 'F' then
			//Si la serie es F entonces solo clientes que tengan RUC
			ls_sql = "SELECT P.PROVEEDOR AS CODIGO_CLIENTE,"&
					 + "P.NOM_PROVEEDOR    AS nombre_cliente,"&
					 + "DECODE(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, "&
					 + "p.flag_nac_ext as flag_nac_ext " &
					 + "FROM PROVEEDOR P "&
					 + "WHERE P.FLAG_ESTADO = '1' " &
					 + "  and p.tipo_doc_ident in ('6', '0')" &
					 + "  and p.flag_clie_prov in ('0', '2')"
					 
		elseif left(ls_serie, 1 )= 'B' then
			//Si la serie es B entonces solo clientes que no tengan RUC
			ls_sql = "SELECT P.PROVEEDOR AS CODIGO_CLIENTE,"&
					 + "P.NOM_PROVEEDOR    AS nombre_cliente,"&
					 + "DECODE(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, "&
					 + "p.flag_nac_ext as flag_nac_ext " &
					 + "FROM PROVEEDOR P "&
					 + "WHERE P.FLAG_ESTADO = '1' " &
					 + "  and p.tipo_doc_ident  <> '6'" &
					 + "  and p.flag_clie_prov in ('0', '2')"
					 
		else
			
			ls_sql = "SELECT P.PROVEEDOR AS CODIGO_CLIENTE,"&
					 + "P.NOM_PROVEEDOR    AS nombre_cliente,"&
					 + "DECODE(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, "&
					 + "p.flag_nac_ext as flag_nac_ext " &
					 + "FROM PROVEEDOR P "&
					 + "WHERE P.FLAG_ESTADO = '1' " &
					 + "  and p.flag_clie_prov in ('0', '2')"
					 
		end if

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_ruc, ls_flag_nac_ext, '2') then
			if IsNull(ls_ruc) or trim(ls_ruc) = '' then
				Messagebox('Aviso','El Cliente seleccionado no tiene Numero de documento de identificacion (RUC, DNI, OTROS), por favor Verifique!', StopSign!)
				this.setColumn('cod_relacion')
				Return 
			end if
			
			this.object.cod_relacion		[al_row] = ls_codigo
			this.object.nom_proveedor		[al_row] = ls_data
			this.object.ruc_dni_cliente	[al_row] = ls_ruc
			this.object.flag_nac_ext		[al_row] = ls_flag_nac_ext
			
			if ls_flag_nac_ext = 'N' then
				this.object.flag_mercado 	[al_row] = 'L'
			else
				this.object.flag_mercado 	[al_row] = 'E'
			end if
			
			of_get_direccion(ls_codigo, al_row)
			
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/

		end if
		
	CASE 'vendedor'
	
		ls_sql = "select v.vendedor as codigo_vendedor, " 	&
				 + "v.nom_vendedor as nombre_vendedor "  	&
				 + "from vendedor v " 						&
				 + "where v.flag_estado = '1' "			&
				 + "order by nombre_vendedor"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.vendedor			[al_row] = ls_codigo
			this.object.nom_vendedor	[al_row] = ls_data
			
			this.ii_update = 1
			
		end if
		
	CASE 'und_peso'
	
		ls_sql = "select u.und as unidad, " &
				 + "u.desc_unidad as descripcio_unidad " &
				 + "from unidad u, " &
				 + "     (select column_value as und " &
				 + "       from table(split(pkg_config.USF_GET_PARAMETER('UNIDADES_PESO', 'KGR,LBS,TON'))))s " &
				 + " where u.und = s.und " &
				 + "   and u.flag_estado = '1'"
 

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.und_peso		[al_row] = ls_codigo
			this.object.und_peso_1	[al_row] = ls_codigo
			
			this.ii_update = 1
			
		end if			

END CHOOSE



end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event buttonclicked;call super::buttonclicked;String 			ls_tipo_doc, ls_nro_doc, ls_Directorio, ls_cliente, ls_email
Blob				lbl_DATA_XML, lbl_DATA_CDR, lbl_DATA_PDF
boolean			lb_send_email
integer 			li_FileNum
Long				ll_rpta
str_parametros	lstr_param

if row = 0 then return

try 
	
	if lower(dwo.name) <> 'b_obs' then
		if dw_master.ii_update 			= 1 or idw_exportacion.ii_update = 1 or &
			idw_det_imp.ii_update		= 1 or idw_detail.ii_update 		= 1 or &
			idw_referencias.ii_update	= 1 or idw_asiento_cab.ii_update	= 1 or &
			idw_asiento_det.ii_update	= 1 then
			
			gnvo_app.of_mensaje_error( "Tiene grabaciones pendientes. Por favor verifique!")
			return 
			
		end if
	end if
	
	ls_tipo_doc = this.object.tipo_doc 		[row]
	ls_nro_doc	= this.object.nro_doc		[row]
	ls_cliente	= this.object.cod_relacion [row]	
	
	if IsNull(ls_cliente) or trim(ls_cliente) = '' then
		gnvo_app.of_mensaje_error( "No ha elegido ningun cliente para este comprobante. Por favor verifique!")
		return 
	end if
	
	if lower(dwo.name) = 'b_envio_efact' then
		
		of_enviar_sunat_ose(ls_tipo_doc, ls_nro_doc)
		
	elseif lower(dwo.name) = 'b_download' then
		
		if GetFolder("Seleccione el Directorio para guardar los documentos digitales",ls_Directorio) <> 1 then return
		
		SELECTBLOB 	DATA_XML
			into 		:lbl_DATA_XML
		FROM cntas_cobrar cc
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
		
		SELECTBLOB 	DATA_CDR
			into 		:lbl_DATA_CDR
		FROM cntas_cobrar cc
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
	
		SELECTBLOB 	DATA_PDF
			into 		:lbl_DATA_PDF
		FROM cntas_cobrar cc
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
		  
		//Creo el archivo PDF
		if not IsNull(lbl_DATA_PDF) then
			li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".PDF", &
				StreamMode!, Write!, Shared!, Replace!)
	
			FileWriteEx(li_FileNum, lbl_DATA_PDF)
			FileClose(li_FileNum)
		end if
	
		//Creo el archivo XML
		if not IsNull(lbl_DATA_XML) then
			li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".XML", &
				StreamMode!, Write!, Shared!, Replace!)
	
			FileWriteEx(li_FileNum, lbl_DATA_XML)
			FileClose(li_FileNum)
		end if
	
		//Creo el archivo CDR
		if not IsNull(lbl_DATA_CDR) then
			li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".CDR", &
				StreamMode!, Write!, Shared!, Replace!)
	
			FileWriteEx(li_FileNum, lbl_DATA_CDR)
			FileClose(li_FileNum)
		end if
		
		gnvo_app.of_mensaje_error( "Archivos generados satisfactoriamente")
	
	elseif lower(dwo.name) = 'b_obs' then
		
		If this.is_protect("observacion", row) then RETURN
		
		// Para la descripcion de la Factura
		lstr_param.string1   = 'Descripcion de Factura '
		lstr_param.string2	 = this.object.observacion [row]
	
		OpenWithParm( w_descripcion_fac, lstr_param)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
				This.object.observacion [row] = left(lstr_param.string3, 2000)
				this.ii_update = 1
		END IF	
	end if

catch ( exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al hacer click en boton en el DAtaWindow Maestro")

end try

end event

type gb_1 from groupbox within w_ve310_cntas_cobrar
integer x = 4114
integer width = 667
integer height = 552
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Referencias"
end type

