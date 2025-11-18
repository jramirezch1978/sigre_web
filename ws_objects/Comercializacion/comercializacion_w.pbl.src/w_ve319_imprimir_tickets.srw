$PBExportHeader$w_ve319_imprimir_tickets.srw
forward
global type w_ve319_imprimir_tickets from w_abc
end type
type sle_origen from n_cst_textbox within w_ve319_imprimir_tickets
end type
type rb_4 from radiobutton within w_ve319_imprimir_tickets
end type
type rb_3 from radiobutton within w_ve319_imprimir_tickets
end type
type rb_2 from radiobutton within w_ve319_imprimir_tickets
end type
type rb_1 from radiobutton within w_ve319_imprimir_tickets
end type
type pb_caja from picturebutton within w_ve319_imprimir_tickets
end type
type cb_1 from commandbutton within w_ve319_imprimir_tickets
end type
type uo_1 from u_ingreso_rango_fechas within w_ve319_imprimir_tickets
end type
type dw_master from u_dw_abc within w_ve319_imprimir_tickets
end type
type gb_1 from groupbox within w_ve319_imprimir_tickets
end type
end forward

global type w_ve319_imprimir_tickets from w_abc
integer width = 4581
integer height = 2552
string title = "[VE319] POS - Emisión de comprobantes de Ventas"
string menuname = "m_mantenimiento_sl"
event ue_imprimir ( long al_row )
event ue_anular_row ( long al_row )
event ue_despacho ( long al_row )
event ue_rpt_cierre_caja ( )
event ue_display_motivo_baja ( long al_row )
event ue_cronograma ( long al_row )
sle_origen sle_origen
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
pb_caja pb_caja
cb_1 cb_1
uo_1 uo_1
dw_master dw_master
gb_1 gb_1
end type
global w_ve319_imprimir_tickets w_ve319_imprimir_tickets

type variables
String			is_salir
n_cst_usuario 	invo_usuario
end variables

forward prototypes
public function integer of_get_param ()
end prototypes

event ue_imprimir(long al_row);String ls_nro_registro, ls_tipo_doc, ls_nro_doc

//Imprimo el comprobante
ls_nro_registro 	= dw_master.object.nro_registro 	[al_row]
ls_tipo_doc 		= dw_master.object.tipo_doc_cxc 	[al_row]
ls_nro_doc 			= dw_master.object.nro_doc 		[al_row]

if MessageBox('Aviso', '¿Desea imprimir el comprobante ' &
	+ trim(ls_tipo_doc) + '/' + trim(ls_nro_doc) &
	+ ' nuevamente?', Information!, Yesno!, 2) = 2 then
	
	return
	
end if

gnvo_app.ventas.of_print_efact( ls_nro_registro )
	


end event

event ue_anular_row(long al_row);String	ls_nro_proforma, ls_mensaje

if al_row <= 0 then return

ls_nro_proforma = dw_master.object.nro_proforma [al_Row]

if MessageBox('Aviso', "Desea anular la proforma " + ls_nro_proforma &
		+ ". Tenga cuidado, una vez anulado el registro ya no se puede recuperar.", Information!, YesNo!, 2) = 2 then return
		

update proforma
   set flag_estado = '0'
where nro_proforma = :ls_nro_proforma;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox("Error", "No se ha podido anular la proforma " + ls_nro_proforma &
			+ ". Mensaje de Error: " + ls_mensaje, StopSign!)
	return
end if

commit;
this.event ue_refresh( )
MessageBox('Aviso', "Proforma " + ls_nro_proforma + " anulada satisfactoriamente.", Information!)

end event

event ue_despacho(long al_row);String ls_nro_registro, ls_tipo_doc, ls_nro_doc

//Imprimo el comprobante
ls_nro_registro 	= dw_master.object.nro_registro 	[al_row]
ls_tipo_doc 		= dw_master.object.tipo_doc_cxc 	[al_row]
ls_nro_doc 			= dw_master.object.nro_doc 		[al_row]

if MessageBox('Aviso', '¿Desea imprimir el despacho correspondiente al comprobante ' &
	+ trim(ls_tipo_doc) + '/' + trim(ls_nro_doc) &
	+ ' nuevamente?', Information!, Yesno!, 2) = 2 then
	
	return
	
end if

gnvo_app.ventas.of_print_despacho( ls_nro_registro )
	
//ids_ticket.Retrieve(ls_nro_registro)
//
//if ids_ticket.Rowcount( ) > 0 then
//	
//else
//	messageBox('Aviso', 'El ticket seleccionado no tiene ningún registro para imprimir, por favor verifique!', StopSign!)
//	return	
//end if
//
//
//ids_ticket.object.p_logo.filename = gs_logo
//
////Genero el codigo QR
//messageBox('', getCurrentDirectory())
//FastQRCode("DATA TO CODIFICAR", "d:\mycodigo.bmp")
//
//
//ids_ticket.Print()

end event

event ue_rpt_cierre_caja();date ld_Fecha1, ld_fecha2

ld_fecha1 = uo_1.of_get_fecha1( )
ld_fecha2 = uo_1.of_get_fecha2( )

gnvo_app.ventas.of_rpt_cierre_caja(ld_fecha1, ld_fecha2)
end event

event ue_display_motivo_baja(long al_row);String ls_motivo_baja, ls_tipo_baja, ls_nro_doc, ls_tipo_doc
str_parametros lstr_param

//Imprimo el comprobante
ls_tipo_doc 		= dw_master.object.tipo_doc_cxc 	[al_row]
ls_nro_doc 			= dw_master.object.nro_doc 		[al_row]
ls_motivo_baja		= dw_master.object.motivo_baja	[al_row]

if MessageBox('Aviso', '¿Desea Mostrar el motivo de baja del comprobante ' &
	+ trim(ls_tipo_doc) + '/' + trim(ls_nro_doc) &
	+ ' nuevamente?', Information!, Yesno!, 2) = 2 then
	
	return
	
end if

lstr_param.texto = ls_motivo_baja
lstr_param.DisplayOnly = true

openWithParm(w_texto, lstr_param)

	


end event

event ue_cronograma(long al_row);String 			ls_nro_registro, ls_tipo_doc, ls_nro_doc
Long				ll_count
str_parametros	lstr_param

//Imprimo el comprobante
ls_nro_registro 	= dw_master.object.nro_registro 	[al_row]
ls_tipo_doc 		= dw_master.object.tipo_doc_cxc 	[al_row]
ls_nro_doc 			= dw_master.object.nro_doc 		[al_row]

select count(*)
	into :ll_count
from fs_Factura_simpl_pagos_ref
where nro_registro = :ls_nro_Registro;

if ll_count = 0 then
	MessageBox('Aviso', 'No existe cuotas definidas para este comprobante' &
						+ trim(ls_tipo_doc) + '/' + trim(ls_nro_doc) + '. Por favor verificar!', StopSign!)
	
	return
end if

if MessageBox('Aviso', '¿Desea imprimir el cronograma correspondiente al comprobante ' &
	+ trim(ls_tipo_doc) + '/' + trim(ls_nro_doc), Information!, Yesno!, 2) = 2 then
	
	return
	
end if


lstr_param.dw1 		= 'd_rpt_cronograma_pagos_tbl'
lstr_param.titulo 	= 'Previo de Cronograma de Pagos'
lstr_param.string1 	= ls_nro_registro
lstr_param.tipo		= '1S'

OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)


	

end event

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
//SELECT 	FS_PARAM.COD_MONEDA, moneda.DESCRIPCION, 
//			FS_PARAM.FORMA_PAGO, FORMA_PAGO.DESC_FORMA_PAGO,  
//			FS_PARAM.TIPO_IMPUESTO, IMPUESTOS_TIPO.DESC_IMPUESTO,   
//			FS_PARAM.MOTIVO_TRASLADO, MOTIVO_TRASLADO.DESCRIPCION,   
//			FS_PARAM.ALMACEN, ALMACEN.DESC_ALMACEN,   
//         FS_PARAM.PUNTO_VENTA, PUNTOS_VENTA.DESC_PTO_VTA,
//			FS_PARAM.FORMA_EMBARQUE, FORMA_EMBARQUE.DESCRIPCION
//   into 	:is_cod_moneda, :is_desc_moneda,
// 			:is_forma_pago, :is_desc_forma_pago,
//			:is_tipo_impuesto, :is_desc_impuesto,
//			:is_motivo_traslado, :is_desc_motivo,
//			:is_almacen, :is_desc_almacen,
//			:is_punto_venta, :is_desc_pto_vta,
//			:is_forma_embarque, :is_desc_forma_embarque         
//    FROM FS_PARAM,   
//         MONEDA,   
//         FORMA_PAGO,   
//         IMPUESTOS_TIPO,   
//         MOTIVO_TRASLADO,   
//         ALMACEN,   
//         PUNTOS_VENTA,   
//         FORMA_EMBARQUE  
//   WHERE moneda.cod_moneda (+) = fs_param.cod_moneda
//	  and forma_pago.forma_pago (+) = fs_param.forma_pago
//	  and impuestos_tipo.tipo_impuesto (+) = fs_param.tipo_impuesto
//	  and motivo_traslado.motivo_traslado (+) = fs_param.motivo_traslado
//	  and almacen.almacen (+) = fs_param.almacen
//	  and puntos_venta.punto_venta (+) = fs_param.punto_venta
//	  and forma_embarque.forma_embarque (+) = fs_param.forma_embarque
//	  and fs_param.cod_origen = :gs_origen;    
//
//
//if sqlca.sqlcode = 100 then
//	Messagebox( "Error", "no ha definido parametros en fs_param")
//	return 0
//end if
//
//if sqlca.sqlcode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	Messagebox( "Error", ls_mensaje)
//	return 0
//end if



return 1
end function

on w_ve319_imprimir_tickets.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.sle_origen=create sle_origen
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_caja=create pb_caja
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_origen
this.Control[iCurrent+2]=this.rb_4
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.pb_caja
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.gb_1
end on

on w_ve319_imprimir_tickets.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_origen)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_caja)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

invo_usuario = create n_cst_usuario

sle_origen.text = gs_origen

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
//dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

this.event ue_refresh( )

//Timer(20)
end event

event ue_insert;//Override
w_ve318_factura_popup	lw_1

Open(lw_1)

this.event ue_refresh( )

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_update_pre;call super::ue_update_pre;//String ls_expresion      , ls_item_doc_old  ,ls_order          ,ls_cod_origen    ,&
//		 ls_cod_relacion   , ls_cod_moneda	  ,ls_forma_pago     ,ls_cod_usr	      ,&
//		 ls_destinatario   , ls_punto_partida ,ls_obs		      ,ls_nom_vendedor  ,&
//		 ls_forma_embarque , ls_nombre_usr	  ,ls_doc_ov	      ,ls_nro_ov		   ,&
//		 ls_cod_almacen	 , ls_doc_gr		  ,ls_nro_guia       ,ls_mot_traslado  ,&
//		 ls_nom_chofer		 , ls_nro_brevete	  ,ls_nro_placa      ,ls_nro_placa_carr,&
//	    ls_prov_transp	 , ls_marca_veh	  ,ls_nro_vale_mov   ,ls_cod_art			,&
//		 ls_cencos			 , ls_cnta_prsp	  ,ls_msj_err	      ,ls_doc_fac			,&
//		 ls_doc_bvc			 , ls_tipo_doc		  ,ls_nro_doc        ,ls_confin			,&
//		 ls_nom_art			 , ls_tipo_impuesto ,ls_flag_detraccion,ls_nro_detrac		,&
//		 ls_soles          , ls_dolares       ,ls_cert_insc		,ls_cnta_ctbl		,&
//		 ls_flag_debhab	 , ls_desc_impuesto ,ls_rubro				,ls_result			,&
//		 ls_mensaje			 , ls_comp_final    , ls_vendedor		, ls_pto_vta
//		 
//String ls_item_doc [],ls_item_null []
//Long   ll_inicio    ,ll_inicio_arr = 1 ,ll_inicio_det  ,ll_nro_serie_guia ,ll_item_doc     ,&
//		 ll_nro_libro ,ll_ano            ,ll_mes		    ,ll_nro_asiento    ,ll_nro_serie_doc,&
//		 ll_item_direccion,ll_row_ins_det,ll_item_new_doc = 0
//Decimal {2} ldc_total_lin,ldc_total_fin,ldc_importe_igv,ldc_total_ov,ldc_porc_det,ldc_tasa_impuesto,ldc_total_fin_d
//Decimal {3} ldc_tasa_cambio
//Decimal {4} ldc_cant_proy
//Decimal {6} ldc_precio_unit,ldc_precio_unit_exp
//Datetime	   ldt_fecha_reg
//Date			ld_fec_venta
//Boolean		lb_imp = FALSE
//
////declaracion local de objeto
//n_cst_asiento_contable lnvo_asiento_cntbl
//
//ib_update_check = TRUE
//
//if is_accion = 'fileopen' then return
//
//if dw_detail.Rowcount() = 0 then 
//	Messagebox('Aviso','Debe Ingresar Datos en el detalle ,Verifique!')
//	ib_update_check = FALSE
//	RETURN											 
//end if	
//
////datos 
//dw_master.AcceptText()
//ll_nro_serie_guia	= dw_master.object.nro_serie_guia  [1]
//ll_nro_serie_doc	= dw_master.object.nro_serie_doc   [1]
//ls_cod_origen     = dw_master.object.cod_origen      [1]
//ls_cod_relacion   = dw_master.object.cod_relacion    [1]
//ls_comp_final		= dw_master.object.comp_final 	  [1]
//ldt_fecha_reg	   = dw_master.object.fecha_registro  [1]
//ld_fec_venta		= Date(dw_master.object.fec_venta  [1])
//ls_cod_moneda	   = dw_master.object.cod_moneda	     [1]
//ls_forma_pago	   = dw_master.object.forma_pago	     [1]
//ls_cod_usr		   = dw_master.object.cod_usr		     [1]
//ls_destinatario   = dw_master.object.destinatario	  [1]
//ls_punto_partida  = dw_master.object.punto_partida   [1]
//ls_obs			   = Mid(dw_master.object.observacion [1],1,60)
//ls_nom_vendedor   = dw_master.object.nom_vendedor    [1]
//ls_forma_embarque = dw_master.object.forma_embarque  [1]
//ls_cod_almacen		= dw_master.object.almacen			  [1]
//ls_mot_traslado	= dw_master.object.motivo_traslado [1]
//ls_tipo_impuesto  = dw_master.object.tipo_impuesto   [1]
//ldc_tasa_cambio	= dw_master.object.tasa_cambio	  [1]
//ll_ano				= Long(String(dw_master.object.fecha_registro  [1],'yyyy'))
//ll_mes				= Long(String(dw_master.object.fecha_registro  [1],'mm'))
//ll_item_direccion	= dw_master.object.item_direccion  [1]
//ls_vendedor			= dw_master.object.vendedor        [1]
//ls_pto_vta			= dw_master.object.punto_venta     [1]
//
////verificar que tipo de documento se generara
//select doc_fact_cobrar,doc_bol_cobrar  
//	into :ls_doc_fac,:ls_doc_bvc  
//from finparam 
//where (reckey = '1') ;
// 
// if rb_1.checked then //factura por cobrar
//	if Isnull(ls_doc_fac) or trim(ls_doc_fac) = '' then
//		Messagebox('Aviso','Debe Ingresar en Tabla Finparam Campo doc_fact_cobrar')
//		ib_update_check = FALSE
//		RETURN
//	else
//		ls_tipo_doc = ls_doc_fac
//	end if
//	
//elseif rb_2.checked then //boleta por cobrar
//	if Isnull(ls_doc_bvc) or trim(ls_doc_bvc) = '' then
//		Messagebox('Aviso','Debe Ingresar en Tabla Finparam Campo doc_bol_cobrar')	
//		ib_update_check = FALSE
//		RETURN		
//	else
//		ls_tipo_doc = ls_doc_bvc
//	end if
//end if
//
////VALIDAR CIERRE CONTABLE
////Crear Objeto
//lnvo_asiento_cntbl = create n_cst_asiento_contable
//
///*verifica cierre*/
//lnvo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
//
//IF ls_result = '0' THEN
//	Messagebox('Aviso',ls_mensaje)
//	ib_update_check = False	
//	Return
//END IF
//
////Validar Cabecera ...
//IF IsNull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Codigo de Relacion ,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('cod_relacion')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_pto_vta) OR Trim(ls_pto_vta) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Punto de Venta ,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('punto_venta')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_comp_final) OR Trim(ls_comp_final) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Codigo de Comprador Final ,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('comp_final')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Moneda ,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('cod_moneda')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
//	Messagebox('Aviso','Debe Ingresar Tasa de Cambio ,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('tasa_cambio')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ll_nro_serie_doc)  THEN
//	Messagebox('Aviso','Debe Ingresar Nro de Serie de Documento,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('nro_serie_doc')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_forma_pago) OR Trim(ls_forma_pago) = ''  THEN
//	Messagebox('Aviso','Debe Ingresar Forma de Pago,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('forma_pago')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_forma_embarque) OR Trim(ls_forma_embarque) = ''  THEN
//	Messagebox('Aviso','Debe Ingresar Forma de Embarque,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('forma_embarque')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_tipo_impuesto) OR Trim(ls_tipo_impuesto) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Tipo de Impuesto,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('tipo_impuesto')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_cod_almacen) OR Trim(ls_cod_almacen) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Almacen,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('almacen')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//IF IsNull(ls_vendedor) OR Trim(ls_vendedor) = '' THEN
//	Messagebox('Aviso','Debe Ingresar un Vendedor Valido,Verifique!')	
//	dw_master.SetFocus()
//	dw_master.SetColumn('vendedor')
//	ib_update_check = FALSE
//	RETURN		
//END IF
//
//if ls_tipo_doc = ls_doc_fac then //datos obligatorios para factura
//
//	IF IsNull(ll_item_direccion)  THEN
//		Messagebox('Aviso','Debe Ingresar Dirección ,Verifique!')	
//		dw_master.SetFocus()
//		dw_master.SetColumn('item_direccion')
//		ib_update_check = FALSE
//		RETURN		
//	END IF
//
//	IF IsNull(ls_mot_traslado) OR Trim(ls_mot_traslado) = '' THEN
//		Messagebox('Aviso','Debe Ingresar Motivo de Traslado,Verifique!')	
//		dw_master.SetFocus()
//		dw_master.SetColumn('motivo_traslado')
//		ib_update_check = FALSE
//		RETURN		
//	END IF
//	
//	IF IsNull(ls_punto_partida) OR Trim(ls_punto_partida) = '' THEN
//		Messagebox('Aviso','Debe Ingresar Punto de Partida,Verifique!')	
//		dw_master.SetFocus()
//		dw_master.SetColumn('punto_partida')
//		ib_update_check = FALSE
//		RETURN		
//	END IF
//	
//	IF IsNull(ls_destinatario) OR Trim(ls_destinatario) = '' THEN
//		Messagebox('Aviso','Debe Ingresar Destino ,Verifique!')	
//		dw_master.SetFocus()
//		dw_master.SetColumn('destinatario')
//		ib_update_check = FALSE
//		RETURN		
//	END IF
//
//	IF IsNull(ll_nro_serie_guia)  THEN
//		Messagebox('Aviso','Debe Ingresar Nro de Serie de Guia ,Verifique!')	
//		dw_master.SetFocus()
//		dw_master.SetColumn('nro_serie_guia')
//		ib_update_check = FALSE
//		RETURN		
//	END IF
//	
//end if
//
////no dejar pasar item_doc nulos
////Recuperar impuesto
//select cnta_ctbl,decode(flag_dh_cxp ,'D','H','D'),desc_impuesto,tasa_impuesto
//  into :ls_cnta_ctbl,:ls_flag_debhab,:ls_desc_impuesto,:ldc_tasa_impuesto
//  from impuestos_tipo 
// where ( tipo_impuesto = :ls_tipo_impuesto ) ;
// 
//if Isnull(ls_cnta_ctbl) or Trim(ls_cnta_ctbl) = '' then
//	Messagebox('Aviso',' Cuenta Contable de Impuesto No existe Verifique!')
//	ib_update_check = FALSE
//	RETURN				
//end if
//
//if Isnull(ls_flag_debhab) or Trim(ls_flag_debhab) = '' then
//	Messagebox('Aviso',' Flag Debhab de Impuesto No existe Verifique!')
//	ib_update_check = FALSE
//	RETURN				
//end if
//
////Recuperar Nombre de Usuario
//select nombre 
//	into :ls_nombre_usr 
//	from usuario 
//where (cod_usr = :ls_cod_usr);
//
////Parametros de Orden de Venta,guia
//select cod_soles,cod_dolares,doc_ov,doc_gr 
//	into :ls_soles,:ls_dolares,:ls_doc_ov ,:ls_doc_gr 
//from logparam  
//where (reckey = '1' );
//
////Nro de Libro x tipo de Documento
//select nro_libro 
//	into :ll_nro_libro 
//from doc_tipo 
//where (tipo_doc = :ls_tipo_doc) ;
//
//IF Isnull(ll_nro_libro) or ll_nro_libro = 0 THEN
//	Messagebox('Aviso','Nro de Libro No Existe para tipo de Documento '+ls_tipo_doc)
//	ib_update_check = FALSE
//	RETURN			
//END IF
//
////ordenar datawindow
//ls_order = 'Trim(String(item_doc)) , Trim(String(fila)) '
//dw_detail.SetSort(ls_order)
//dw_detail.Sort()
////
//dw_detail.Groupcalc()
//
//
//
//
//
//
////inicializacion de variables
//ls_item_doc = ls_item_null
//
//ls_item_doc_old = Trim(String(dw_detail.object.item_doc [1]))
//ls_item_doc [ll_inicio_arr] = ls_item_doc_old
//
//For ll_inicio = 1 to dw_detail.Rowcount()
//	
//	 ls_cod_art  		  = dw_detail.object.cod_art  			[ll_inicio]	
//	 ll_item_doc 		  = dw_detail.object.item_doc 			[ll_inicio]	 	
//	 ldc_cant_proy 	  = dw_detail.Object.cant_proyect	   [ll_inicio]
//	 ldc_precio_unit    = dw_detail.Object.precio_unit		   [ll_inicio]	
//	 ldc_precio_unit_exp= dw_detail.Object.precio_unit_exp   [ll_inicio]	
//	 ls_cencos			  = dw_detail.Object.cencos			   [ll_inicio]	
//	 ls_cnta_prsp		  = dw_detail.Object.cnta_prsp		   [ll_inicio] 	
//	 ls_nom_art  	  	  = dw_detail.object.nom_articulo      [ll_inicio]	 
//   	 ls_nom_chofer      = dw_detail.Object.nom_chofer        [ll_inicio]
//	 ls_nro_brevete     = dw_detail.Object.nro_brevete       [ll_inicio]
//	 ls_nro_placa	     = dw_detail.Object.nro_placa         [ll_inicio]
//	 ls_nro_placa_carr  = dw_detail.Object.nro_placa_carreta [ll_inicio]
//	 ls_confin			  = dw_detail.Object.confin				[ll_inicio] 	
//	 
//	IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' then
//		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
//		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('cod_art')
//		 Messagebox('Aviso','Debe Ingresar Codigo de Articulo , Verifique!')
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF
//
//	 IF Isnull(ll_item_doc)  then
//		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('item_doc')
//		 Messagebox('Aviso','Debe Ingresar Item Doc , Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF
//	 	 
//	 IF Isnull(ldc_cant_proy) OR ldc_cant_proy = 0  then
//		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('cant_proyect')
//		 Messagebox('Aviso','Debe Ingresar Alguna Cantidad , Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF	
//	 
// 	 IF Isnull(ldc_precio_unit) OR ldc_precio_unit = 0  then
// 		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('precio_unit')
//		 Messagebox('Aviso','Debe Ingresar Precio Unitario , Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF	 
//	 
//	 IF Isnull(ldc_precio_unit_exp) OR ldc_precio_unit_exp = 0  then
// 		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('precio_unit_exp')
//		 Messagebox('Aviso','Debe Ingresar Precio Unitario Ex - Planta, Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF	 
//	 
// 	 IF Isnull(ls_cencos) OR Trim(ls_cencos) = ''  then
// 		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('cencos')
//		 Messagebox('Aviso','Debe Ingresar Centro de Costo , Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF	 
//	 
//	 IF Isnull(ls_cnta_prsp) OR Trim(ls_cnta_prsp) = ''  then
// 		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('cnta_prsp')
//		 Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal , Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF
//
// 	 IF Isnull(ls_confin) OR Trim(ls_confin) = ''  then
// 		 dw_detail.SetFocus()
//		 dw_detail.SelectRow(0, False)
//		 dw_detail.SelectRow(ll_inicio, True)
// 		 dw_detail.Setrow(ll_inicio)
//		 dw_detail.Setcolumn('confin')
//		 Messagebox('Aviso','Debe Ingresar Concepto Financiero , Verifique!')		 
//		 ib_update_check = FALSE
//		 RETURN	
//	 END IF	 
//
//	 //cuando tipo de documento sea factura
//	 if ls_tipo_doc = ls_doc_fac then
//		/*	
//		IF Isnull(ls_nom_chofer) OR Trim(ls_nom_chofer) = ''  then
//			 dw_detail.SetFocus()
//			 dw_detail.SelectRow(0, False)
//			 dw_detail.SelectRow(ll_inicio, True)
//			 dw_detail.Setrow(ll_inicio)
//			 dw_detail.Setcolumn('nom_chofer')
//			 Messagebox('Aviso','Debe Ingresar Nombre de Chofer , Verifique!')		 
//			 ib_update_check = FALSE
//			 RETURN	
//		END IF	 	
//		
//		IF Isnull(ls_nro_brevete) OR Trim(ls_nro_brevete) = ''  then
//			 dw_detail.SetFocus()
//			 dw_detail.SelectRow(0, False)
//			 dw_detail.SelectRow(ll_inicio, True)
//			 dw_detail.Setrow(ll_inicio)
//			 dw_detail.Setcolumn('nro_brevete')
//			 Messagebox('Aviso','Debe Ingresar Nro de Brevete , Verifique!')		 
//			 ib_update_check = FALSE
//			 RETURN	
//		END IF 
//		
//		IF Isnull(ls_nro_placa) OR Trim(ls_nro_placa) = ''  then
//			 dw_detail.SetFocus()
//			 dw_detail.SelectRow(0, False)
//			 dw_detail.SelectRow(ll_inicio, True)
//			 dw_detail.Setrow(ll_inicio)
//			 dw_detail.Setcolumn('nro_placa')
//			 Messagebox('Aviso','Debe Ingresar Nro de Placa , Verifique!')		 
//			 ib_update_check = FALSE
//			 RETURN	
//		END IF 
//		 
//		 
//		 IF Isnull(ls_nro_placa_carr) OR Trim(ls_nro_placa_carr) = ''  then
//		    dw_detail.SetFocus()
//		 	 dw_detail.SelectRow(0, False)
//		 	 dw_detail.SelectRow(ll_inicio, True)
// 		 	 dw_detail.Setrow(ll_inicio)
//		 	 dw_detail.Setcolumn('nro_placa_carreta')
//		 	 Messagebox('Aviso','Debe Ingresar Nro de Placa de Carreta, Verifique!')		 
//		 	 ib_update_check = FALSE
//		 	 RETURN	
//	 	 END IF  
//		*/
//		
//	 end if
//
//	 IF ls_item_doc_old <> Trim(String(dw_detail.object.item_doc [ll_inicio])) THEN
//		 //asigno valor
//		 ls_item_doc_old = Trim(String(dw_detail.object.item_doc [ll_inicio]))		
//       //diferente
//	    ll_inicio_arr = ll_inicio_arr + 1
//		ls_item_doc [ll_inicio_arr] = ls_item_doc_old
//		 
//	 END IF
//	 
//	 //acumulador
//	 ldc_total_lin = dw_detail.object.tot_lin [ll_inicio]
//	 
//	 if Isnull(ldc_total_lin) then ldc_total_lin = 0.00
//	 
//	 //TOTAL DE ORDEN DE VENTA
//	 ldc_total_ov = ldc_total_ov + ldc_total_lin
//	 	
//Next	 
//
////LBRACO estubo DESACTIVADO lo active
//////=========================================
//////Generacion de Orden de Venta Unica
//////=========================================
//IF wf_insert_orden_venta(ls_cod_origen     ,ldt_fecha_reg   ,ls_forma_pago    ,&
//   	                   ls_cod_moneda     ,ls_nom_vendedor ,ls_cod_usr		   ,&
//       	                ls_cod_relacion   ,ls_destinatario ,ls_punto_partida ,&
//							 	 ls_forma_embarque ,ls_obs          ,ls_nro_ov        ,&
//							 	 ldc_total_ov, ls_comp_final, ls_vendedor ) = FALSE THEN
//	
//	ib_update_check = FALSE
//	RETURN			
//
//
//END IF
////		ESTO FUE EDITADO estubo DESACTIVADO lo active
//
//
//
///**ESTO NO ESTUBO HERE****/
//
//		  //  cabecera de movimiento de almacen
//		 	  IF wf_insert_mov_almacen (ls_cod_origen ,ls_nro_vale_mov ,ls_cod_almacen  ,&
//				                         ldt_fecha_reg , ld_fec_venta, ls_cod_usr      ,ls_cod_relacion ,&
//											    ls_nombre_usr ,ls_cod_origen   ,ls_doc_ov       ,&
//											    ls_nro_ov) = 	FALSE THEN
//				  
//				  ib_update_check = FALSE
//				  RETURN
//			  END IF
//												 
//			  IF ls_tipo_doc = ls_doc_fac THEN							 
//				  //  cabecera de guia
// 			     IF wf_insert_guia		  (ll_nro_serie_guia ,ls_doc_gr       ,ls_nro_guia      ,&
//											      ls_cod_origen     ,ls_cod_almacen  ,ldt_fecha_reg    ,&
//												   ls_mot_traslado   ,ls_cod_relacion ,ls_nom_chofer    ,&
//													ls_nro_brevete	   ,ls_nro_placa    ,ls_nro_placa_carr,&
//												   ls_destinatario   ,ls_cod_usr      ,ls_prov_transp	  ,&
//													ls_obs            ,ls_marca_veh    ,ls_cert_insc  ) = FALSE THEN
//					  ib_update_check = FALSE
//					  RETURN
//				  END IF
//			  END IF
//						
//			  // cabecera de asientos
//			  IF wf_insert_cab_asiento (ls_cod_origen  , ll_ano        , ll_mes          , ll_nro_libro     ,&
//			                            ll_nro_asiento , ls_cod_moneda , ldc_tasa_cambio , Mid(ls_obs,1,60) ,&
//											    ldt_fecha_reg  , ld_fec_venta  , ls_cod_usr	 ) = FALSE THEN
//				  ib_update_check = FALSE
//				  RETURN								 
//			  END IF
//		
//  			  //datastore de cntas cobrar
//			  wf_insert_cntas_cobrar_cab (ll_nro_serie_doc  ,ls_tipo_doc       ,ls_nro_doc      , &
//			  										ls_cod_relacion   ,ll_item_direccion ,ldt_fecha_reg   , ld_fec_venta, &
//													ls_forma_embarque ,ls_cod_moneda     ,ldc_tasa_cambio , &
//													ls_cod_usr        ,ls_cod_origen	    ,ll_ano				, &
//													ll_mes				,ll_nro_libro      ,ll_nro_asiento  , &
//													ls_forma_pago		,ls_obs				 , ls_vendedor		, &
//													ls_pto_vta)
//		
//			//  -------------------------------------------------------------detracc
//	/*************/
//	
//	//GRABA REFERENCIA
//			 IF ls_tipo_doc = ls_doc_fac THEN //FACTURA X GUIA
//				 wf_insert_ref_cc(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
//				 					   ls_cod_origen   ,ls_doc_gr  ,ls_nro_guia )
//										 
//										 
//			 ELSE //BOLETA X ORDEN DE VENTA
//				wf_insert_refer_cc_ov(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
//				 					       ls_cod_origen   ,ls_doc_ov  ,ls_nro_ov )
//				
//			 END IF	
//	
//	//* NO ESTUBO HERE LBRACO */////
//
////actualizo orden de venta en cabecera
//dw_master.object.nro_ov [1] = ls_nro_ov
//
////Filtrar detalle de documentos x arreglo
//
////AQUI EDIT LBRACO
//for ll_inicio = 1 to UpperBound(ls_item_doc)
//	 //inicializacion de variable
//	 ldc_total_fin   = 0.00
//	 ldc_total_lin   = 0.00
//	 
//	 //filtrar por item de documento	
//	 ls_expresion = 'item_doc = '+ls_item_doc [ll_inicio]	 
//	 dw_detail.SetFilter(ls_expresion)
//	 dw_detail.Filter()
//	 
//	 //ESTO ESTUBO ACTIVADO LBRACO
//	 //=========================================
//	 //Generacion de Orden de Venta Unica
//	 //=========================================
////	 IF wf_insert_orden_venta(ls_cod_origen     ,ldt_fecha_reg   ,ls_forma_pago    ,&
////   	                       ls_cod_moneda     ,ls_nom_vendedor ,ls_cod_usr		 ,&
////       	                    ls_cod_relacion   ,ls_destinatario ,ls_punto_partida ,&
////					     		 	  ls_forma_embarque ,ls_obs          ,ls_nro_ov        ,&
////							 	     ldc_total_ov      ,ls_comp_final  ,ls_vendedor ) = FALSE THEN
////	
////		 ib_update_check = FALSE
////		 RETURN			
////	 END IF
//	  //ESTO ESTUBO ACTIVADO LBRACO
//	  
//	 ldc_total_ov = 0.00
//
//	 for ll_inicio_det = 1 to dw_detail.rowcount()
//		  
//		  //datos
//		  ls_nom_chofer       = dw_detail.Object.nom_chofer        [ll_inicio_det]
//		  ls_nro_brevete      = dw_detail.Object.nro_brevete       [ll_inicio_det]
//		  ls_nro_placa	       = dw_detail.Object.nro_placa         [ll_inicio_det]
//		  ls_nro_placa_carr   = dw_detail.Object.nro_placa_carreta [ll_inicio_det]
//		  ls_prov_transp	    = dw_detail.Object.prov_transp		  [ll_inicio_det]
//		  ls_marca_veh		    = dw_detail.Object.marca_vehiculo    [ll_inicio_det]
//		  ls_cert_insc		    = dw_detail.Object.cert_inscp		  [ll_inicio_det]
//		  ls_cod_art		    = dw_detail.Object.cod_art			  [ll_inicio_det]
//		  ldc_cant_proy 	    = dw_detail.Object.cant_proyect	     [ll_inicio_det]
//		  ldc_precio_unit     = dw_detail.Object.precio_unit		  [ll_inicio_det]	
//		  ldc_precio_unit_exp = dw_detail.Object.precio_unit_exp   [ll_inicio_det]	
//		  ldc_importe_igv     = dw_detail.Object.importe_igv		  [ll_inicio_det]
//		  ls_cencos			    = dw_detail.Object.cencos			     [ll_inicio_det]	
//		  ls_cnta_prsp		    = dw_detail.Object.cnta_prsp		     [ll_inicio_det] 	
//		  ls_confin			    = dw_detail.Object.confin				  [ll_inicio_det] 	
//		  ls_nom_art  	  	    = dw_detail.object.nom_articulo      [ll_inicio_det]
//		  ll_item_doc		    = dw_detail.object.item_doc		     [ll_inicio_det]
//		  ls_rubro				 = dw_detail.object.rubro			     [ll_inicio_det]
//		 		  
//		  if Isnull(ldc_importe_igv) then ldc_importe_igv = 0.00
//		  
//		  ldc_total_lin = dw_detail.object.tot_lin	[ll_inicio_det]
//		  
//		  ldc_total_fin = ldc_total_fin + ldc_total_lin
//		  
//		  //==========================================
//		  //Generacion de Documento Mov Almacen ,Guia 
//		  //Una Sola Vez x Cada Item Documento
//		  //==========================================
//		  
//		 /*AQUI ESTUBO*/
////		  if ll_inicio_det = 1 then	
////			  //  cabecera de movimiento de almacen
////		 	  IF wf_insert_mov_almacen (ls_cod_origen ,ls_nro_vale_mov ,ls_cod_almacen  ,&
////				                         ldt_fecha_reg , ld_fec_venta, ls_cod_usr      ,ls_cod_relacion ,&
////											    ls_nombre_usr ,ls_cod_origen   ,ls_doc_ov       ,&
////											    ls_nro_ov) = 	FALSE THEN
////				  
////				  ib_update_check = FALSE
////				  RETURN
////			  END IF
////												 
////			  IF ls_tipo_doc = ls_doc_fac THEN							 
////				  //  cabecera de guia
//// 			     IF wf_insert_guia		  (ll_nro_serie_guia ,ls_doc_gr       ,ls_nro_guia      ,&
////											      ls_cod_origen     ,ls_cod_almacen  ,ldt_fecha_reg    ,&
////												   ls_mot_traslado   ,ls_cod_relacion ,ls_nom_chofer    ,&
////													ls_nro_brevete	   ,ls_nro_placa    ,ls_nro_placa_carr,&
////												   ls_destinatario   ,ls_cod_usr      ,ls_prov_transp	  ,&
////													ls_obs            ,ls_marca_veh    ,ls_cert_insc  ) = FALSE THEN
////					  ib_update_check = FALSE
////					  RETURN
////				  END IF
////			  END IF
////						
////			  // cabecera de asientos
////			  IF wf_insert_cab_asiento (ls_cod_origen  , ll_ano        , ll_mes          , ll_nro_libro     ,&
////			                            ll_nro_asiento , ls_cod_moneda , ldc_tasa_cambio , Mid(ls_obs,1,60) ,&
////											    ldt_fecha_reg  , ld_fec_venta  , ls_cod_usr	 ) = FALSE THEN
////				  ib_update_check = FALSE
////				  RETURN								 
////			  END IF
////		
////  			  //datastore de cntas cobrar
////			  wf_insert_cntas_cobrar_cab (ll_nro_serie_doc  ,ls_tipo_doc       ,ls_nro_doc      , &
////			  										ls_cod_relacion   ,ll_item_direccion ,ldt_fecha_reg   , ld_fec_venta, &
////													ls_forma_embarque ,ls_cod_moneda     ,ldc_tasa_cambio , &
////													ls_cod_usr        ,ls_cod_origen	    ,ll_ano				, &
////													ll_mes				,ll_nro_libro      ,ll_nro_asiento  , &
////													ls_forma_pago		,ls_obs				 , ls_vendedor		, &
////													ls_pto_vta)
////		 /*--------------*/											
//			  //ACTUALIZA MOVIMIENTO DE ALMACEN
//			  if ls_tipo_doc = ls_doc_bvc then
//				  IF wf_update_vale_mov(ls_cod_origen ,ls_nro_vale_mov,ls_tipo_doc,ls_nro_doc) = FALSE THEN
//					  ib_update_check = FALSE
//					  RETURN	
//				  END IF
//			  end if	
//			  
////		  end if
//		 /*--------------*/
//		  
//   	  //generacion de detalle de en Orden de Venta y Movimiento de Almacen	 
//		  // detalle de orden de venta
//		  IF wf_insert_det_ov (ls_cod_origen   ,ls_cod_art        ,ls_doc_ov     ,&
//		                       ls_nro_ov       ,ldt_fecha_reg     ,ld_fec_venta ,ldc_cant_proy ,&
//			 					     ldc_precio_unit ,ldc_tasa_impuesto ,ls_cod_moneda ,&
//									  ls_cod_almacen	,ls_cencos			 ,ls_cnta_prsp) = FALSE THEN
//			  ib_update_check = FALSE
//			  RETURN
//		  END IF		
//
//		  // detalle de movimiento de almacen
//		  IF wf_insert_det_vale_mov(ls_cod_origen ,ls_nro_vale_mov ,ls_cod_art    ,&
//		 	 							    ldc_cant_proy ,ldc_precio_unit ,ls_cod_moneda ,&
//										    ls_cencos     ,ls_cnta_prsp ) = FALSE THEN
//			  ib_update_check = FALSE
//			  RETURN											 
//		  END IF
//
//		  // Llenar Datastore detalle cntas cobrar                           ll_inicio_det  / change !!!! lbraco
//		  wf_insert_cntas_cobrar_det(ls_tipo_doc   ,ls_nro_doc      ,ll_item_doc 		,&
//		  									  ls_confin     ,ls_nom_art      ,ls_cod_art    	   ,&
//											  ldc_cant_proy ,ldc_precio_unit ,ldc_precio_unit_exp ,&
//											  ls_doc_ov	  	 ,ls_nro_ov       ,ll_row_ins_det 		,&
//											  ls_rubro)
//		
//		  if ldc_importe_igv > 0 then
//		  	  //genera impuesto                                                        ll_inicio_det  / change !!!! lbraco
//			  wf_insert_impuesto_det (ls_tipo_doc      ,ls_nro_doc      ,ll_item_doc,&
//			  								  ls_tipo_impuesto ,ldc_importe_igv	)	 
//		     
//			  lb_imp = TRUE
//		  else
//			  lb_imp = FALSE
//		  end if
//		  
//		  //Llenar Detalle de Asientos
//		  IF wf_insert_det_asiento (ls_cod_origen  ,ll_ano          ,ll_mes        ,ll_nro_libro ,&
//			                         ll_nro_asiento ,ll_row_ins_det  ,ldt_fecha_reg ,ls_cod_moneda,&
//					   					 ldc_tasa_cambio,ls_cod_relacion ,lb_imp        ,ls_cnta_ctbl ,&
//											 ls_flag_debhab ,ls_desc_impuesto,ldc_importe_igv) = FALSE THEN
//			  
//			  ib_update_check = FALSE
//			  RETURN											 
//		  END IF
//
//		  //==================================================
//		  //Generacion de Guia x Vale
//		  //Una Sola Vez x Cada Item Documento 
//		  //Generado Una vez Terminado los detalles de C/Item
//		  //==================================================
//		  //despues de ingresar detalle
//		  
//		  IF ll_inicio_det = dw_detail.rowcount() THEN
//			
//			  //contador de generacion de documentos
//           ll_item_new_doc = ll_item_new_doc + 1
//			  
//  			 IF ls_tipo_doc = ls_doc_fac THEN			
//					//esto fue editado lbraco
////			    IF wf_guia_vale (ls_nro_guia   ,ls_nro_vale_mov ,ls_cod_origen ) = FALSE THEN
////					 ib_update_check = FALSE
////					 RETURN											 
////				 END IF
////esto fue editado lbraco
//			 END IF	  
//			  
////			 IF ls_tipo_doc = ls_doc_fac then
//				 //PREGUNTAR SI GENERARIA DETRACCION
//				 // ESTO FUE DESACTIVADO LBRACO
////				 IF wf_genera_detraccion(ls_item_doc [ll_inicio],ls_flag_detraccion,ldt_fecha_reg,ldc_porc_det,ls_nro_detrac,&
////												 ls_cod_origen     ,ldc_total_fin ) = FALSE THEN 
////					 ib_update_check = FALSE
////					 RETURN													 
////				 END IF
//				 // ESTO FUE DESACTIVADO LBRACO
////			end if
//											 
//			 //=ACTUALIZA CABECERA DE CTAS COBRAR  DESACTIVADP LBRACO
////			 IF wf_update_cta_cobrar(ls_tipo_doc  ,ls_nro_doc   ,ls_flag_detraccion,&
////			 								 ldc_porc_det ,ls_nro_detrac,ldc_total_fin     ,&
////											 ls_soles    ,ls_dolares    ,ls_cod_moneda     ,&
////											 ldc_tasa_cambio ) = FALSE THEN
////				 ib_update_check = FALSE
////				 RETURN													 
////			 END IF
//			 
//			 IF wf_insert_ttemp(ls_cod_origen ,ls_nro_ov   ,ll_item_new_doc ,&
//								     '1'           ,ls_tipo_doc ,ls_nro_doc      ,&
//									  ls_nro_guia   ,ls_nro_vale_mov ) = FALSE THEN
//				 ib_update_check = FALSE
//				 RETURN											 					  
//			 END IF
//
////			 //GRABA REFERENCIA
////ESTO FUE DESACTIVADO LBRACO
////			 IF ls_tipo_doc = ls_doc_fac THEN //FACTURA X GUIA
////				 wf_insert_ref_cc(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
////				 					   ls_cod_origen   ,ls_doc_gr  ,ls_nro_guia )
////										 
////										 
////			 ELSE //BOLETA X ORDEN DE VENTA
////				wf_insert_refer_cc_ov(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
////				 					       ls_cod_origen   ,ls_doc_ov  ,ls_nro_ov )
////				
////			 END IF	
//// LBRACO
//		   END IF					
//
//			//actualizo detalle
//			dw_detail.object.nro_guia    [ll_inicio_det] = ls_nro_guia
//			dw_detail.object.nro_vale    [ll_inicio_det] = ls_nro_vale_mov
//			dw_detail.object.tipo_doc_cc [ll_inicio_det] = ls_tipo_doc
//			dw_detail.object.nro_doc_cc  [ll_inicio_det] = ls_nro_doc
//			dw_detail.object.nro_ov		  [ll_inicio_det] = ls_nro_ov
//			
//		   //acumulador
//			ldc_total_lin = dw_detail.object.tot_lin [ll_inicio_det]
// 	 
//			if Isnull(ldc_total_lin) then ldc_total_lin = 0.00
//	 
//			//TOTAL DE ORDEN DE VENTA
//	 		ldc_total_ov = ldc_total_ov + ldc_total_lin
//			 
//			//actualiza orden de venta
//			if wf_update_ov(ls_nro_ov,ldc_total_ov) = false then
//			 	ib_update_check = FALSE
//				RETURN											 					  
//			end if
//
//	 next
//	 		
//next
//
////Desfiltrar
//dw_detail.SetFilter('')
//dw_detail.Filter()
//
//if dw_detail.RowCount() > 0 then ldc_total_fin_d=dw_detail.object.total_doc[1]
//
////ldc_total_fin_d
//messagebox("",string(ldc_total_fin_d))
//IF wf_genera_detraccion(ls_item_doc [1],ls_flag_detraccion,ldt_fecha_reg,ldc_porc_det,ls_nro_detrac,&
// 	ls_cod_origen     ,ldc_total_fin_d ) = FALSE THEN 
//	ib_update_check = FALSE
//	RETURN													 
//END IF
//
// IF wf_update_cta_cobrar(ls_tipo_doc  ,ls_nro_doc   ,ls_flag_detraccion,&
//			 								 ldc_porc_det ,ls_nro_detrac,ldc_total_fin_d     ,&
//											 ls_soles    ,ls_dolares    ,ls_cod_moneda     ,&
//											 ldc_tasa_cambio ) = FALSE THEN
//				 ib_update_check = FALSE
//				 RETURN													 
//			 END IF
end event

event ue_update;call super::ue_update;//Boolean lbo_ok = TRUE
//String  ls_msj_err
//
//dw_master.AcceptText()
//dw_detail.AcceptText()
//ids_cntas_cobrar_cab.AcceptText()
//ids_cntas_cobrar_det.AcceptText()
//ids_impuesto_det.AcceptText()
//ids_data_ref.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN
//
//	Rollback ;
//		
//	//BORRA DATA DE DWS.
//	ids_cntas_cobrar_cab.Reset()
//	ids_cntas_cobrar_det.Reset()
//	ids_impuesto_det.Reset()	
//	ids_data_glosa.Reset()
//	ids_data_ref.Reset()
//	//====================
//	//Desfiltrar
//	dw_detail.SetFilter('')
//	dw_detail.Filter()
//	
//	RETURN
//END IF	
//
////actualizo dws...
//IF ids_cntas_cobrar_cab.update() = -1 THEN
//	lbo_ok = FALSE	
//	ls_msj_err = '	Error al Grabar Cabecera de Cuentas x Cobrar'
//
//END IF
//
//IF lbo_ok  THEN
//	IF ids_cntas_cobrar_det.update() = -1 THEN
//		lbo_ok = FALSE	
//		ls_msj_err = '	Error al Grabar Detalle de Cuentas x Cobrar'
//	END IF
//END IF
//
//IF lbo_ok THEN
//	IF ids_impuesto_det.update() = -1 THEN
//		lbo_ok = FALSE	
//		ls_msj_err = '	Error al Grabar Detalle de Impuesto'
//	END IF
//END IF	
//
//IF lbo_ok THEN
//	IF ids_data_ref.update() = -1 THEN
//		lbo_ok = FALSE	
//		ls_msj_err = '	Error al Grabar Referencia'
//	END IF
//END IF
//
//IF lbo_ok THEN
//	//insercion de tabla simplificada
//	if wf_insert_fact_simple() = false then 
//		lbo_ok = FALSE
//	end if	
//END IF
//
//IF lbo_ok THEN
//
//	COMMIT ;
//
//	is_accion = 'fileopen'
//	rb_1.enabled = false
//	rb_2.enabled = false
//	
//ELSE
//	Rollback ;
//	Messagebox('Aviso',ls_msj_err)
//END IF
end event

event ue_delete;//OVERRIDE
if is_action = 'fileopen' OR idw_1 = dw_master then return

Long  ll_row


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
	
end event

event ue_print;call super::ue_print;//String ls_tipo_doc,ls_nro_doc
//Long   ll_inicio
//
//IF is_accion = 'fileopen' then
//	IF rb_1.checked THEN //FACTURA
//		
//		IF gs_empresa = 'FISHOLG' THEN
//			dw_report_fact.dataobject = 'd_rpt_fact_cobrar_fisholg_ff'
//			dw_report_fact.Object.DataWindow.Print.Paper.Size = 256 
//			dw_report_fact.Object.DataWindow.Print.CustomPage.Width = 216
//			dw_report_fact.Object.DataWindow.Print.CustomPage.Length = 161
//			
//		elseIF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
//			
//			dw_report_fact.dataobject = 'd_rpt_fact_cobrar_canagrande_ff'
//			dw_report_fact.Object.DataWindow.Print.Paper.Size = 256 
//			dw_report_fact.Object.DataWindow.Print.CustomPage.Width = 250
//			dw_report_fact.Object.DataWindow.Print.CustomPage.Length = 150
//			
//		else
//			dw_report_fact.dataobject = 'd_rpt_fact_cobrar_ff'
//		end if
//
//		dw_report_fact.Settransobject(sqlca)
//		
//		OpenWithParm(w_print_opt, dw_report_fact)
//	
//		If Message.DoubleParm = -1 Then Return
//	
//	//EDITADO LBRACO
//		ll_inicio=1
////		For ll_inicio = 1 to dw_detail.Rowcount()
//			
//			 ls_tipo_doc = dw_detail.object.tipo_doc_cc [ll_inicio]
//			 ls_nro_doc  = dw_detail.object.nro_doc_cc  [ll_inicio]
//
//		 	DECLARE usp_fin_tt_ctas_x_cobrar PROCEDURE FOR 
//			 	usp_fin_tt_ctas_x_cobrar(:ls_tipo_doc,:ls_nro_doc);
//			 EXECUTE usp_fin_tt_ctas_x_cobrar ;
//			 
//			 dw_boleta.Settransobject(sqlca)
//
//			 dw_report_fact.retrieve(ls_tipo_doc,ls_nro_doc)
//			 //RECORRER DETALLE
//			 dw_report_fact.Print(True)	
//			 
//			 CLOSE usp_fin_tt_ctas_x_cobrar;
//			
////		Next
//		
//	ELSE //BOLETA
//		
//		IF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
//			
//			dw_boleta.dataobject = 'd_rpt_bol_cobrar_canagrande_ff'
//			dw_boleta.Object.DataWindow.Print.Paper.Size = 256 
//			dw_boleta.Object.DataWindow.Print.CustomPage.Width = 250
//			dw_boleta.Object.DataWindow.Print.CustomPage.Length = 150
//			
//		else
//			dw_boleta.dataobject = 'd_rpt_bol_cobrar_fsimple_ff'
//		end if
//	
//		
//		OpenWithParm(w_print_opt, dw_boleta)
//	
//		If Message.DoubleParm = -1 Then Return
//		
//		ll_inicio = 1
////		For ll_inicio = 1 to dw_detail.Rowcount()
//			 //RECORRER DETALLE			
//			 ls_tipo_doc = dw_detail.object.tipo_doc_cc [ll_inicio]
//			 ls_nro_doc  = dw_detail.object.nro_doc_cc  [ll_inicio]			
//			 
//			 DECLARE usp_fin_tt_bol_x_cobrar PROCEDURE FOR 
//			 	usp_fin_tt_ctas_x_cobrar(:ls_tipo_doc,:ls_nro_doc);
//			 EXECUTE usp_fin_tt_bol_x_cobrar ;
//			 
//			 dw_boleta.Settransobject(sqlca)
//
//			 dw_boleta.retrieve(ls_tipo_doc,ls_nro_doc)
//
//			 dw_boleta.Print(True)	
//			 
//			 CLOSE usp_fin_tt_bol_x_cobrar;
//			
////		Next	
//		
//		
//	END IF	
//	
//END IF
//
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_refresh;call super::ue_refresh;date 		ld_Fecha1, ld_fecha2
String	ls_origen

ld_fecha1 = uo_1.of_get_fecha1( )
ld_fecha2 = uo_1.of_get_fecha2( )

if rb_1.checked then
	dw_master.DataObject = 'd_lista_tickets_op1_tbl'
elseif rb_2.checked then
	dw_master.DataObject = 'd_lista_tickets_op2_tbl'
elseif rb_3.checked then
	dw_master.DataObject = 'd_lista_tickets_op3_tbl'
elseif rb_4.checked then
	dw_master.DataObject = 'd_lista_tickets_op4_tbl'
end if

dw_master.SetTransObject(SQLCA)


if rb_4.checked then
	dw_master.Retrieve(ld_fecha1, ld_fecha2)
	
elseif rb_3.checked then
	
	ls_origen = sle_origen.text
	
	if trim(ls_origen) = '' then
		MessageBox('Error', 'Debe elegir una sucursal para el listado de comprobantes', StopSign!)
		sle_origen.setFocus()
		return
	end if
	
	dw_master.Retrieve(ld_fecha1, ld_fecha2, ls_origen )
else
	dw_master.Retrieve(ld_fecha1, ld_fecha2, gs_user )
end if


end event

event timer;call super::timer;//this.event ue_refresh( )
end event

event ue_anular;//Override
string 	ls_tipo_doc, ls_nro_doc, ls_nro_registro, ls_mensaje, ls_clave, ls_usuario, ls_motivo_baja
Long		ll_row, ll_count
Date		ld_fec_movimiento, ld_hoy 

try 
	
	if dw_master.getRow() = 0 then return
	
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	ll_row = dw_master.getRow()
	ls_tipo_doc 		= dw_master.object.tipo_doc_cxc			[ll_row]
	ls_nro_doc 			= dw_master.object.nro_doc 				[ll_row]
	ls_nro_registro 	= dw_master.object.nro_registro			[ll_row]
	ls_usuario			= dw_master.object.cod_usr					[ll_row]
	ld_fec_movimiento	= Date(dw_master.object.fec_movimiento	[ll_row])
	
	
	
	//VAlido si solo se puede anular un solo día
	if gnvo_app.efact.is_anular_only_dia = '1' then
		if ld_fec_movimiento <> ld_hoy then
			MessageBox('Advertencia', 'Solo esta permitido anular comprobantes del Dia de HOY.', StopSign!)		
			return
		end if
	end if
	
	if DaysAfter(ld_fec_movimiento, ld_hoy) > gnvo_app.efact.ii_nro_dias_anulacion then
		MessageBox('Advertencia', 'Solo esta permitido anular comprobantes dentro de los ' &
									+ string(gnvo_app.efact.ii_nro_dias_anulacion) + ' dias.', StopSign!)		
		return
	end if
	
	if gnvo_app.of_get_parametro("ENVIAR_BAJA_SUNAT", '0') = "1" then
		//COnsulto si se puede anular el comprobante
		if MessageBox('Aviso', 'Desea anular el comprobante ' + ls_tipo_doc + '/' &
				+ ls_nro_doc + "?." &
				+ "~r~nTener presente que si lo anula se ira directamente a SUNAT", Information!, Yesno!, 2) = 2 then return
	else
		//COnsulto si se puede anular el comprobante
		if MessageBox('Aviso', 'Desea anular el comprobante ' + ls_tipo_doc + '/' &
				+ ls_nro_doc + '?', Information!, Yesno!, 2) = 2 then return
	end if
	
	
	//Valido si necesita o no clave para anular
	if gnvo_app.efact.is_request_clave_anular = '1' then
		//Valido la cantidad para anular comprobantes, si pasa la cantidad permitida, 
		//entonces pido clave
		if not gnvo_app.efact.of_validar_anulados(ls_usuario, ld_fec_movimiento) then
			//Validar clave para proceder a anular
			if not gnvo_app.efact.of_validar_clave() then return
		end if
	end if
	
	//Tiene que ingresar un motivo de baja
	ls_motivo_baja = gnvo_util.of_get_Texto("Ingrese el motivo de Baja", "")
	
	if ISNull(ls_motivo_baja) or trim(ls_motivo_baja) = '' then
		MessageBox('Error', 'Debe ingresar un motivo de baja, de lo contrario no podrá anular el comprobante...', StopSign!)
		return
	end if
		
	update fs_factura_simpl
		set 	flag_estado = '0',
				motivo_baja = :ls_motivo_baja,
				fecha_baja	= sysdate,
				usr_baja		= :gs_user
	 where nro_registro = :ls_nro_registro;
	 
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrtext
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error para anular el comprobante en la tabla fs_factura_smpl. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	commit;
	
	//Procedo a ejecutar el procedimiento para anular el comprobante
	// Genero los asientos y documentos correspondientes
	if gnvo_app.ventas.is_generar_cxc_fact_simpl = '1' then
		gnvo_app.ventas.of_cxc_factura_smpl_anula(ls_nro_registro)
	end if
	
	if gnvo_app.of_get_parametro("ENVIAR_BAJA_SUNAT", '0') = "1" then
		
		if left(ls_nro_doc, 1) = 'F' then
			if not gnvo_app.ventas.of_resumen_ra_fac( ld_fec_movimiento) then
				rollback;
				return 
			end if
		end if
		
		if left(ls_nro_doc, 1) = 'B' then
			if not gnvo_app.ventas.of_resumen_ra_bvc( ld_fec_movimiento) then
				rollback;
				return 
			end if
		end if
	end if
	
	this.event ue_refresh( )

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "Error al anular el documento")
finally
	/*statementBlock*/
end try

	
end event

event close;call super::close;destroy invo_usuario
end event

event ue_modify;//Override
w_ve318_factura_popup	lw_1
str_parametros				lstr_param
Date							ld_hoy, ld_fec_movimiento

try 
	if dw_master.GetRow() = 0 then 
		MessageBox('AViso', 'No hay ningun registro por modificar, por favor verifique!', StopSign!)
		return
	end if
	
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	if MessageBox('Aviso', 'Desea modificar el comprobante de venta?', Information!, YesNo!, 2) = 2 then return
	
	if gnvo_app.of_get_parametro('ONLY_MODIFY_COMPROBANTE_DEL_DIA', '1') = '1' then
		//VAlido que solo se pueda modificar el comprobante que sean del día
		ld_fec_movimiento = Date(dw_master.object.fec_movimiento [dw_master.getRow()])
		
		if ld_fec_movimiento <> ld_hoy then
			MessageBox('Aviso','Solo se pueden modificar los comprobantes de venta del día, solo podrá verlo en pantalla.', Information!)
			lstr_param.string3 = '0'
		else
			MessageBox('Aviso','Importante: Unicamente podrá modificar la forma de pago, Presione ENTER para continuar', StopSign!)
			lstr_param.string3 = '1'
		end if
	else
		MessageBox('Aviso','Importante: Unicamente podrá modificar la forma de pago, Presione ENTER para continuar', StopSign!)
		lstr_param.string3 = '1'
	end if

	lstr_param.string2 = dw_master.object.nro_registro [dw_master.getRow()]
	lstr_param.string1 = 'edit'

	
	OpenWithParm(lw_1, lstr_param)
	
	this.event ue_refresh( )
	
catch ( Exception ex)
	MessageBox('Error','Exception: ' + ex.getMessage(), StopSign!)
end try


end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

type sle_origen from n_cst_textbox within w_ve319_imprimir_tickets
integer x = 1797
integer y = 184
integer width = 160
integer height = 76
integer taborder = 40
integer textsize = -8
boolean enabled = false
end type

event ue_dobleclick;call super::ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select o.cod_origen as codigo_origen, " &
		 + "o.nombre as nombre_origen " &
		 + "from origen o " &
		 + "where o.flag_estado <> '0'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
end if

end event

event modified;call super::modified;String 	ls_desc, ls_codigo

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen', StopSign!)
	return
end if

SELECT nombre
	INTO :ls_desc
FROM origen
where cod_origen 	= :ls_codigo 
  and flag_estado <> '0';


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe o no esta activo', StopSign!)
	return
end if


end event

type rb_4 from radiobutton within w_ve319_imprimir_tickets
integer x = 1394
integer y = 256
integer width = 544
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Empresa"
end type

event clicked;if this.checked then
	sle_origen.enabled = false
end if
end event

type rb_3 from radiobutton within w_ve319_imprimir_tickets
integer x = 1394
integer y = 184
integer width = 544
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Sucursal"
end type

event clicked;if this.checked then
	sle_origen.enabled = true
else
	sle_origen.enabled = false
end if
end event

type rb_2 from radiobutton within w_ve319_imprimir_tickets
integer x = 1394
integer y = 112
integer width = 544
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Usuario"
end type

event clicked;if this.checked then
	sle_origen.enabled = false
end if
end event

type rb_1 from radiobutton within w_ve319_imprimir_tickets
integer x = 1394
integer y = 40
integer width = 544
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Serie"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
end if
end event

type pb_caja from picturebutton within w_ve319_imprimir_tickets
integer x = 1984
integer y = 44
integer width = 283
integer height = 232
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\Toolbar\Reporte1.png"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Resumen de caja"
long backcolor = 16777215
end type

event clicked;if MessageBox('Information', 'Desea imprimir el resumen de caja de la fecha seleccionada?', &
						Information!, Yesno!, 2 ) = 2 then return
						
parent.event dynamic ue_rpt_cierre_caja()

						
end event

type cb_1 from commandbutton within w_ve319_imprimir_tickets
integer x = 14
integer y = 168
integer width = 1285
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_refresh( )
end event

type uo_1 from u_ingreso_rango_fechas within w_ve319_imprimir_tickets
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 60
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type dw_master from u_dw_abc within w_ve319_imprimir_tickets
integer x = 5
integer y = 344
integer width = 4475
integer height = 1848
string dataobject = "d_lista_tickets_op1_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
is_dwform = 'tabular'	// tabular, form (default)
end event

event itemchanged;call super::itemchanged;//Long    ll_count,ll_nro_serie_doc,ll_null
//String  ls_desc_data     ,ls_null         ,ls_cod_relacion ,ls_dir_dep_estado , &
//        ls_dir_distrito	,ls_dir_direccion ,ls_tipo_doc	  , ls_nom_vendedor
//Integer li_num_dir
//
//Accepttext()
//
//SetNull(ls_null)
//SetNull(ll_null)
//
//choose case dwo.name
//		 case 'nro_serie_doc'
//				ll_nro_serie_doc = Long(data) 
//				
//				if rb_1.checked then
//					ls_tipo_doc = is_doc_fac
//				elseif rb_2.checked then
//					ls_tipo_doc = is_doc_bvc
//				end if	
//				
//				
//				select count(*) into :ll_count 
//				  from doc_tipo_usuario 
//				 where (cod_usr   = :gs_user          ) and
//					    (tipo_doc  = :ls_tipo_doc      ) and
//						 (nro_serie	= :ll_nro_serie_doc ) ;
//						 
//			  if ll_count = 0 then
//				  Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
//				  this.object.nro_serie_doc [row] = ll_null
//				  Return 1
//			  end if 
//				
//		 case 'nro_serie_guia'
//				ll_nro_serie_doc = Long(data) 
//				
//				select count(*) into :ll_count 
//				  from doc_tipo_usuario 
//				 where (cod_usr   = :gs_user          ) and
//					    (tipo_doc  = :is_doc_gr        ) and
//						 (nro_serie	= :ll_nro_serie_doc ) ;
//						 
//			   if ll_count = 0 then
//				   Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
//				   this.object.nro_serie_guia [row] = ll_null
//				   Return 1
//			   end if 
//			  
//		
//		 case 'cod_relacion'
//
//				select p.nom_proveedor into :ls_desc_data
//				  from proveedor p
//				 where (p.proveedor   = :data ) and
//				       (p.flag_estado = '1'   ) ;
//				
//				
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de Relacion no Existe')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					This.object.cod_relacion   [row] = ls_null
//					This.Object.desc_crelacion [row] = ls_null
//			      RETURN 1
//			  end if
//			
//
//  			  This.Object.desc_crelacion  [row] = ls_desc_data
//		     This.Object.comp_final 		[row] = data
//			  This.Object.desc_comp_final [row] = ls_desc_data
//		 
//		 case 'comp_final'
//
//				select p.nom_proveedor into :ls_desc_data
//				  from proveedor p
//				 where (p.proveedor   = :data ) and
//				       (p.flag_estado = '1'   ) ;
//				
//				
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de Relacion no Existe')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					This.object.comp_final      [row] = ls_null
//					This.Object.desc_comp_final [row] = ls_null
//			      RETURN 1
//			  end if
//			
//
//  			  This.Object.desc_comp_final [row] = ls_desc_data
//						  
//		 case 'item_direccion'
//			
//				ls_cod_relacion = dw_master.object.cod_relacion [row]		
//				
//				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
//					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
//					Return 1
//				END IF
//
//				/**/
//				li_num_dir = Integer(data)
//				/**/
//				
//
//				SELECT Nvl(dir_dep_estado,' ') ,Nvl(dir_distrito,' ')   ,
//					 	 Nvl(dir_direccion,' ')  
//				  INTO :ls_dir_dep_estado ,:ls_dir_distrito	  ,	
//						 :ls_dir_direccion 		
//				  FROM direcciones
//				 WHERE (codigo = :ls_cod_relacion) AND
//				 		 (item	= :li_num_dir     ) AND
//						 (flag_uso = '1'           ) ;
//						  
//
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
// 					  Messagebox('Aviso','Direccion No Existe , Verifique!')				
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					Setnull(li_num_dir)
//					This.Object.item_direccion [row] = li_num_dir
//					This.Object.desc_direccion [row] = ls_null
//			      RETURN 1
//			  end if
//
//			  This.Object.desc_direccion [row] = Trim(ls_dir_dep_estado)+' '+Trim(ls_dir_distrito)+' '+Trim(ls_dir_direccion)	 
//				
//		 case 'cod_moneda'
//			
//				select descripcion
//			     into :ls_desc_data
//			     from moneda
//				 where (cod_moneda = :data) ;	
//					
//		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			      if SQLCA.SQLCode = 100 then
//						Messagebox('Aviso','Moneda No Existe , Verifique!')				
//			      else
//				      MessageBox('Aviso', SQLCA.SQLErrText)
//			      end if
//				  
//					This.Object.cod_moneda  [row] = ls_null
//					This.Object.desc_moneda [row] = ls_null
//			      RETURN 1
//			   end if
//
//			   This.Object.desc_moneda [row] = ls_desc_data
//				
//				
//		 case 'motivo_traslado'   				
//				
//				select descripcion 
//				  into :ls_desc_data
//				  from motivo_traslado mt
//				 where (mt.motivo_traslado = :data) ;
//					 
//		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			      if SQLCA.SQLCode = 100 then
//						Messagebox('Aviso','Motivo de Traslado No Existe , Verifique!')				
//			      else
//				      MessageBox('Aviso', SQLCA.SQLErrText)
//			      end if
//				  
//					This.Object.motivo_traslado [row] = ls_null
//					This.Object.desc_motivo     [row] = ls_null
//			      RETURN 1
//			   end if
//
//				This.Object.desc_motivo     [row] = ls_desc_data 
//				
//				
//				
//				
//		 case	'almacen'	
//				
//				select desc_almacen 
//			     into :ls_desc_data
//		        from almacen
//   	       where (almacen     = :data      ) and
//				       (flag_estado = '1'        ) and
//						 (cod_origen  = :gs_origen ) ; 
//		  
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de almacen no existe, ' &
//					             + 'no esta activo o no le corresponde a su origen ')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//			     this.Object.almacen	 	[row] = ls_null
//			     this.object.desc_almacen [row] = ls_null
//			     RETURN 1
//			  end if
//			
//		     this.object.desc_almacen [row] = ls_desc_data
//				
//
//		CASE 'vendedor'
//			
//				select nvl(u.nombre,'')
//				  into :ls_nom_vendedor
//				  from vendedor v, usuario u
//				 where v.vendedor = u.cod_usr
//				   and v.vendedor = :data;
//				
//				if ls_nom_vendedor = '' then
//					messagebox('Aviso','Codigo de Vendedor no existe, Verifique!')
//					setnull(ls_nom_vendedor)
//					this.object.vendedor[row] = ls_nom_Vendedor
//					this.object.nom_vendedor[row] = ls_nom_vendedor
//					return 1
//				end if
//				
//				this.object.nom_vendedor[row] = ls_nom_vendedor
//
//end choose
//
end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;
choose case lower(dwo.name)
		
	case "b_imprimir"
		parent.event ue_imprimir( row )
		
	case "b_despacho"
		parent.event dynamic ue_despacho( row )
	
	case "b_motivo_baja"
		parent.event dynamic ue_display_motivo_baja( row )
		
	case "b_cronograma"
		parent.event dynamic ue_cronograma( row )
end choose

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

event ue_display;call super::ue_display;parent.event ue_modify( )
end event

type gb_1 from groupbox within w_ve319_imprimir_tickets
integer width = 2725
integer height = 340
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

