$PBExportHeader$w_ve326_proformas.srw
forward
global type w_ve326_proformas from w_abc
end type
type cb_1 from commandbutton within w_ve326_proformas
end type
type cb_guias from commandbutton within w_ve326_proformas
end type
type hpb_progreso from hprogressbar within w_ve326_proformas
end type
type cb_facturas from commandbutton within w_ve326_proformas
end type
type uo_fecha from u_ingreso_rango_fechas within w_ve326_proformas
end type
type cb_refresh from commandbutton within w_ve326_proformas
end type
type dw_master from u_dw_abc within w_ve326_proformas
end type
type gb_1 from groupbox within w_ve326_proformas
end type
end forward

global type w_ve326_proformas from w_abc
integer width = 4581
integer height = 2552
string title = "[VE326] POS - Generacion de Proformas"
string menuname = "m_mantenimiento_sl"
event ue_editar ( long al_row )
event ue_anular_row ( long al_row )
event ue_print_facturas ( )
event ue_print_guias ( )
event ue_print_vales ( )
cb_1 cb_1
cb_guias cb_guias
hpb_progreso hpb_progreso
cb_facturas cb_facturas
uo_fecha uo_fecha
cb_refresh cb_refresh
dw_master dw_master
gb_1 gb_1
end type
global w_ve326_proformas w_ve326_proformas

type prototypes

end prototypes

type variables
String 		is_salir
n_Cst_wait 	invo_wait
u_ds_base 			ids_print
end variables

forward prototypes
public function integer of_get_param ()
public function long of_selected_rows ()
public function boolean of_print_ce (long al_row)
end prototypes

event ue_editar(long al_row);//Modify
String			ls_nro_proforma, ls_mensaje, ls_flag_estado
Str_parametros	lstr_param

if al_row <= 0 then return

ls_nro_proforma 	= dw_master.object.nro_proforma 	[al_row]
ls_flag_estado 	= dw_master.object.flag_estado 	[al_row]

if ls_flag_estado <> '1' then 
	gnvo_app.of_mensaje_error("No se puede editar la proforma, ya que no se encuentra ACTIVO")
	return
end if

lstr_param.string1 = 'edit'
lstr_param.string2 = ls_nro_proforma

OpenWithParm(w_ve326_proforma_popup, lstr_param)

this.event ue_refresh( )
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

event ue_print_facturas();Long 		ll_rows, ll_row, ll_index
String 	ls_tipo_doc, ls_full_nro_doc

try
	invo_wait = create n_cst_wait
	hpb_progreso.visible = true
	
	ll_rows = of_selected_rows()
	
	if ll_rows = 0 then
		MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
		return
	end if
	
	if PrintSetupPrinter () <= 0 then return
	
	ll_index = dw_master.GetSelectedRow( 0 )
	ll_row = 0
	
	DO WHILE ll_index > 0
	
		ll_row ++
		
		ls_tipo_doc 		= dw_master.object.tipo_doc_cxc [ll_index]
		ls_full_nro_doc	= dw_master.object.full_nro_doc [ll_index]
		
		invo_wait.of_mensaje('Imprimiendo el Comprobante ' + trim(ls_tipo_doc) + " / " + ls_full_nro_doc)
		
		of_print_ce(ll_index)
		
		hpb_progreso.Position = ll_row / ll_rows * 100
		
		ll_index = dw_master.GetSelectedRow( ll_index )
	
	LOOP

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al imprimir las facturas')
	return

finally
	invo_wait.of_close()
	destroy invo_wait
	
	hpb_progreso.visible = false
	
end try

end event

event ue_print_guias();Long 		ll_rows, ll_row, ll_index
String 	ls_org_guia, ls_nro_guia, ls_full_nro_guia

try
	invo_wait = create n_cst_wait
	hpb_progreso.visible = true
	hpb_progreso.Position = 0
	
	ll_rows = of_selected_rows()
	
	if ll_rows = 0 then
		MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
		return
	end if
	
	if PrintSetupPrinter () <= 0 then return
	
	ll_index = dw_master.GetSelectedRow( 0 )
	ll_row = 0
	
	DO WHILE ll_index > 0
	
		ll_row ++
		
		ls_full_nro_guia	= dw_master.object.full_nro_guia [ll_index]
		ls_org_guia			= dw_master.object.org_guia 		[ll_index]
		ls_nro_guia			= dw_master.object.nro_guia 		[ll_index]
		
		invo_wait.of_mensaje('Imprimiendo la GUIA DE REMISION ' + ls_full_nro_guia + " por favor espere un momento")
		
		gnvo_app.almacen.of_print_guia(ls_org_guia, ls_nro_guia)
		
		hpb_progreso.Position = ll_row / ll_rows * 100
		
		ll_index = dw_master.GetSelectedRow( ll_index )
	
	LOOP

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al imprimir las GUIAS DE REMISION')
	return

finally
	invo_wait.of_close()
	destroy invo_wait
	
	hpb_progreso.visible = false
	
end try

end event

event ue_print_vales();Long 		ll_rows, ll_row, ll_index
String 	ls_org_guia, ls_nro_guia, ls_full_nro_guia

try
	invo_wait = create n_cst_wait
	hpb_progreso.visible = true
	hpb_progreso.Position = 0
	
	ll_rows = of_selected_rows()
	
	if ll_rows = 0 then
		MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
		return
	end if
	
	if PrintSetupPrinter () <= 0 then return
	
	ll_index = dw_master.GetSelectedRow( 0 )
	ll_row = 0
	
	DO WHILE ll_index > 0
	
		ll_row ++
		
		ls_full_nro_guia	= dw_master.object.full_nro_guia [ll_index]
		ls_nro_guia			= dw_master.object.nro_guia 		[ll_index]
		
		invo_wait.of_mensaje('Imprimiendo los Vales de SALIDA de la GUIA ' + ls_full_nro_guia + " por favor espere un momento")
		
		gnvo_app.almacen.of_print_vales_from_guia(ls_nro_guia)
		
		hpb_progreso.Position = ll_row / ll_rows * 100
		
		ll_index = dw_master.GetSelectedRow( ll_index )
	
	LOOP

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al imprimir las GUIAS DE REMISION')
	return

finally
	invo_wait.of_close()
	destroy invo_wait
	
	hpb_progreso.visible = false
	
end try

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

public function long of_selected_rows ();Long ll_row = 0
String ls_flag_estado, ls_nro_guia, ls_tipo_doc, ls_nro_doc

for ll_row = 1 to dw_master.RowCount()
	if dw_master.IsSelected(ll_row) then
		ls_flag_estado = dw_master.object.flag_estado 	[ll_row]
		ls_nro_guia 	= dw_master.object.nro_guia	 	[ll_row]
		ls_tipo_doc 	= dw_master.object.tipo_doc_cxc 	[ll_row]
		ls_nro_doc 		= dw_master.object.nro_doc_cxc 	[ll_row]
		
		if ls_flag_estado = '0' then
			MessageBox('Error', 'La proforma ' + dw_master.object.nro_proforma [ll_row] &
								+ ' se encuentra anulado, por favor verifique!', StopSign!)
			return 0
		end if
		
		if IsNull(ls_nro_guia) or trim(ls_nro_guia) = '' then
			MessageBox('Error', 'La proforma ' + dw_master.object.nro_proforma [ll_row] &
								+ ' no tiene Nro de Guia generado, por favor verifique!', StopSign!)
			return 0
		end if
		
		if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' or isNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
			MessageBox('Error', 'La proforma ' + dw_master.object.nro_proforma [ll_row] &
								+ 'no tiene Nro de comprobante generado, por favor verifique!', StopSign!)
			return 0
		end if
		
		ll_row ++
	end if
next

return ll_row
end function

public function boolean of_print_ce (long al_row);String ls_nro_registro, ls_tipo_doc, ls_nro_doc

//Imprimo el comprobante
ls_nro_registro 	= dw_master.object.nro_registro 	[al_row]
ls_tipo_doc 		= dw_master.object.tipo_doc_cxc 	[al_row]
ls_nro_doc 			= dw_master.object.nro_doc_cxc	[al_row]

return gnvo_app.ventas.of_print_only_efact( ls_nro_registro )

end function

on w_ve326_proformas.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.cb_1=create cb_1
this.cb_guias=create cb_guias
this.hpb_progreso=create hpb_progreso
this.cb_facturas=create cb_facturas
this.uo_fecha=create uo_fecha
this.cb_refresh=create cb_refresh
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_guias
this.Control[iCurrent+3]=this.hpb_progreso
this.Control[iCurrent+4]=this.cb_facturas
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.cb_refresh
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve326_proformas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_guias)
destroy(this.hpb_progreso)
destroy(this.cb_facturas)
destroy(this.uo_fecha)
destroy(this.cb_refresh)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ids_print = create u_ds_base

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente


this.event ue_refresh()
end event

event ue_insert;//Override
w_ve326_proforma_popup	lw_1

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

event ue_refresh;call super::ue_refresh;date ld_Fecha1, ld_fecha2

ld_fecha1 = uo_Fecha.of_Get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

dw_master.Retrieve( ld_Fecha1, ld_fecha2)
end event

event ue_modify;//Modify
String			ls_nro_proforma, ls_mensaje, ls_flag_estado
Str_parametros	lstr_param
Long				ll_row

ll_row = dw_master.getRow()

if ll_row <= 0 then return

ls_nro_proforma 	= dw_master.object.nro_proforma 	[ll_row]
ls_flag_estado 	= dw_master.object.flag_estado 	[ll_row]

if ls_flag_estado <> '1' then 
	gnvo_app.of_mensaje_error("No se puede editar la proforma, ya que no se encuentra ACTIVO")
	return
end if

lstr_param.string1 = 'edit'
lstr_param.string2 = ls_nro_proforma

OpenWithParm(w_ve326_proforma_popup, lstr_param)

this.event ue_refresh( )



end event

event ue_anular;//Override

if dw_master.RowCount() = 0 then return

this.event ue_anular_Row(dw_master.getRow())


end event

event close;call super::close;destroy ids_print
end event

type cb_1 from commandbutton within w_ve326_proformas
integer x = 2752
integer y = 52
integer width = 713
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir Vales de Salida"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_print_vales()
setPointer(Arrow!)
end event

type cb_guias from commandbutton within w_ve326_proformas
integer x = 2039
integer y = 52
integer width = 713
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir Guias Remision"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_print_guias()
setPointer(Arrow!)
end event

type hpb_progreso from hprogressbar within w_ve326_proformas
boolean visible = false
integer x = 1330
integer y = 192
integer width = 1856
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cb_facturas from commandbutton within w_ve326_proformas
integer x = 1326
integer y = 52
integer width = 713
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir Bolestas / Facturas"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_print_facturas()
setPointer(Arrow!)
end event

type uo_fecha from u_ingreso_rango_fechas within w_ve326_proformas
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 70
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_refresh from commandbutton within w_ve326_proformas
integer x = 14
integer y = 168
integer width = 1285
integer height = 100
integer taborder = 20
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

type dw_master from u_dw_abc within w_ve326_proformas
integer y = 288
integer width = 4475
integer height = 1848
string dataobject = "d_lista_proformas_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;//IF Getrow() = 0 THEN Return
//String     ls_name    ,ls_prot ,ls_cod_relacion,ls_estado,ls_distrito,ls_direccion,&
//			  ls_tipo_doc
//str_seleccionar lstr_seleccionar
//str_parametros sl_param
//
//Datawindow		 ldw	
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//
//CHOOSE CASE dwo.name
//		 CASE 'nro_serie_doc'
//			   
//				if rb_1.checked then
//					ls_tipo_doc = is_doc_fac
//				elseif rb_2.checked then
//					ls_tipo_doc = is_doc_bvc
//				end if
//			 
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC AS DOCUMENTO ,'&
//								      				 +'DOC_TIPO_USUARIO.NRO_SERIE AS SERIE '&
//									   				 +'FROM DOC_TIPO_USUARIO '&
//														 +'WHERE DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user     +"' AND "&
//														 		 +'DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+ls_tipo_doc +"'"
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'nro_serie_doc',lstr_seleccionar.paramdc2[1])
//					ii_update = 1
//				END IF																  
//																  
//			
//		 CASE 'nro_serie_guia'	
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC AS DOCUMENTO ,'&
//								      				 +'DOC_TIPO_USUARIO.NRO_SERIE AS SERIE '&
//									   				 +'FROM DOC_TIPO_USUARIO '&
//														 +'WHERE DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user     +"' AND "&
//														 		 +'DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+is_doc_gr +"'"
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'nro_serie_guia',lstr_seleccionar.paramdc2[1])
//					ii_update = 1
//				END IF	
//				
//		 CASE 'cod_relacion'
//
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO_PROVEEDOR, '&
//								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES, '&
//								   					 +'PROVEEDOR.EMAIL AS EMAIL, '&
//														 +'PROVEEDOR.RUC AS R_U_C '&
//									   				 +'FROM PROVEEDOR '&
//														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"
//
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_crelacion',lstr_seleccionar.param2[1])
//					
//					Setitem(row,'comp_final',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_comp_final',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//		
//		 CASE 'comp_final'
//
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
//								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
//								   					 +'PROVEEDOR.EMAIL			AS EMAIL ,'&
//														 +'PROVEEDOR.RUC			   AS R_U_C '&
//									   				 +'FROM PROVEEDOR '&
//														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"
//
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'comp_final',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_comp_final',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//		
//		 CASE 'item_direccion'					
//			
//				ls_cod_relacion = dw_master.object.cod_relacion [row]		
//				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
//					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
//					Return 1
//				END IF
//				
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT DIRECCIONES.ITEM             AS ITEM, '&        
//						 								 +'DIRECCIONES.DIR_PAIS         AS PAIS, '&     
//						 								 +'DIRECCIONES.DIR_DEP_ESTADO   AS DEPARTAMENTO, '&
//						 								 +'DIRECCIONES.DIR_DISTRITO     AS DISTRITO , '&
//						 								 +'DIRECCIONES.DIR_URBANIZACION AS URBANIZACION, '&
//						 								 +'DIRECCIONES.DIR_DIRECCION    AS DIRECCION, '&
//						 							    +'DIRECCIONES.DIR_MNZ          AS MANZANA, '&
//						 								 +'DIRECCIONES.DIR_LOTE         AS LOTE, '&
//						 								 +'DIRECCIONES.DIR_NUMERO       AS NUMERO, '&
//						 								 +'DIRECCIONES.DESCRIPCION      AS DESCRIPCION '&
//				  		 								 +'FROM DIRECCIONES '&
//				 		 								 +'WHERE DIRECCIONES.CODIGO = '+"'"+ls_cod_relacion+"' AND "&
//														 +'	   DIRECCIONES.FLAG_USO = '+"'"+'1'+"'"								
//															
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					This.Object.item_direccion [row] = Integer(lstr_seleccionar.paramdc1[1])
//					ls_estado	 = lstr_seleccionar.param3[1]
//					ls_distrito  = lstr_seleccionar.param4[1]					
//					ls_direccion = lstr_seleccionar.param6[1]
//
//					IF Isnull(ls_estado)    THEN ls_estado 	= ''
//					IF Isnull(ls_distrito)  THEN ls_distrito 	= ''					
//					IF Isnull(ls_direccion) THEN ls_direccion	= ''		
//
//					This.Object.desc_direccion [row] = ls_estado+' '+ls_distrito+' '+ls_direccion
//					ii_update = 1
//					
//				END IF
//															
//		 CASE 'cod_moneda'
//				
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA  AS CODIGO_MONEDA ,'&
//								      				 +'MONEDA.DESCRIPCION AS DESCRIPCION_MON '&
//									   				 +'FROM MONEDA '
//
//
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_moneda',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_moneda',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//
//		 CASE 'motivo_traslado'		 						  
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT MOTIVO_TRASLADO.MOTIVO_TRASLADO AS CODIGO ,'&
//												 		 +'MOTIVO_TRASLADO.DESCRIPCION	  AS DESCRIP_MOTIVO_TRAS '&
//														 +'FROM MOTIVO_TRASLADO '
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'motivo_traslado',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_motivo',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//				
//		 CASE 'punto_venta'		 						  
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT punto_venta AS CODIGO ,'&
//												 		 +'desc_pto_vta AS DESCRIPcion '&
//														 +'FROM puntos_venta ' &
//														 + "where flag_estado = '1'"
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'punto_venta',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_punto_venta',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//
//		case	'almacen'
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT ALMACEN.ALMACEN      AS CODIGO ,'&
//														 +'ALMACEN.DESC_ALMACEN AS DESCRIPCION ,'&
//														 +'ALMACEN.Direccion	AS direccion '&
//														 +'FROM ALMACEN '&
//														 +'WHERE ALMACEN.FLAG_ESTADO = '+"'"+'1'+"'"+' AND '&
//				 		                               +'ALMACEN.COD_ORIGEN  = '+"'"+gs_origen+"'"
//														 
//		      OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'almacen',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_almacen',lstr_seleccionar.param2[1])
//					Setitem(row,'punto_partida',lstr_seleccionar.param3[1])
//					ii_update = 1
//				END IF
//				
//		CASE 'vendedor'
//			
//				sl_param.dw1 = "d_lista_vendedor"
//				sl_param.titulo = "Vendedores"
//				sl_param.field_ret_i[1] = 1
//				sl_param.field_ret_i[2] = 2
//				sl_param.tipo = ''
//				
//				OpenWithParm( w_lista, sl_param)		
//				
//				sl_param = MESSAGE.POWEROBJECTPARM
//				
//				if sl_param.titulo <> 'n' then	
//					Setitem(row,'vendedor',sl_param.field_ret[1])
//					Setitem(row,'nom_vendedor',sl_param.field_ret[2])
//					ii_update = 1
//				END IF
//
//END CHOOSE
//
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
		
	case "b_anular"
		parent.event ue_anular_row( row )
	case "b_editar"
		parent.event ue_editar( row )
		
end choose

end event

type gb_1 from groupbox within w_ve326_proformas
integer width = 3611
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro de Busqueda"
end type

