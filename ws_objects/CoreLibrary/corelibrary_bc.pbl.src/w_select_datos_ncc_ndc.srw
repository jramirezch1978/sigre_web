$PBExportHeader$w_select_datos_ncc_ndc.srw
forward
global type w_select_datos_ncc_ndc from w_abc
end type
type uo_documentos from n_cst_search within w_select_datos_ncc_ndc
end type
type cb_2 from commandbutton within w_select_datos_ncc_ndc
end type
type cb_aceptar from commandbutton within w_select_datos_ncc_ndc
end type
type dw_comprobantes from u_dw_abc within w_select_datos_ncc_ndc
end type
type st_3 from statictext within w_select_datos_ncc_ndc
end type
type uo_search from n_cst_search within w_select_datos_ncc_ndc
end type
type dw_clientes from u_dw_abc within w_select_datos_ncc_ndc
end type
type st_2 from statictext within w_select_datos_ncc_ndc
end type
type st_1 from statictext within w_select_datos_ncc_ndc
end type
type dw_motivo from u_dw_abc within w_select_datos_ncc_ndc
end type
end forward

global type w_select_datos_ncc_ndc from w_abc
integer width = 4091
integer height = 1960
string title = "Datos para la Nota de Credito / Debito"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
uo_documentos uo_documentos
cb_2 cb_2
cb_aceptar cb_aceptar
dw_comprobantes dw_comprobantes
st_3 st_3
uo_search uo_search
dw_clientes dw_clientes
st_2 st_2
st_1 st_1
dw_motivo dw_motivo
end type
global w_select_datos_ncc_ndc w_select_datos_ncc_ndc

type variables
str_parametros	istr_param
end variables

on w_select_datos_ncc_ndc.create
int iCurrent
call super::create
this.uo_documentos=create uo_documentos
this.cb_2=create cb_2
this.cb_aceptar=create cb_aceptar
this.dw_comprobantes=create dw_comprobantes
this.st_3=create st_3
this.uo_search=create uo_search
this.dw_clientes=create dw_clientes
this.st_2=create st_2
this.st_1=create st_1
this.dw_motivo=create dw_motivo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_documentos
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_aceptar
this.Control[iCurrent+4]=this.dw_comprobantes
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.uo_search
this.Control[iCurrent+7]=this.dw_clientes
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.dw_motivo
end on

on w_select_datos_ncc_ndc.destroy
call super::destroy
destroy(this.uo_documentos)
destroy(this.cb_2)
destroy(this.cb_aceptar)
destroy(this.dw_comprobantes)
destroy(this.st_3)
destroy(this.uo_search)
destroy(this.dw_clientes)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_motivo)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros lstr_param
u_dw_abc	 		ldw_master, ldw_detail
Long				ll_row, ll_i
String			ls_nro_registro, ls_nro_registro_ref, ls_serie, ls_nro, ls_nro_doc, ls_tipo_doc, &
					ls_mensaje, ls_cliente, ls_nom_cliente, ls_tipo_doc_ident, ls_ruc_dni, ls_motivo, &
					ls_desc_motivo
u_ds_base		lds_master, lds_detail

try 
	ldw_master = istr_param.dw_m
	ldw_detail = istr_param.dw_d
	
	//Creo los datastores
	lds_master = create u_ds_base
	lds_detail = create u_ds_base
	
	lds_master.DataObject = 'd_abc_fs_nota_venta_cab_ff'
	lds_master.SetTransObject(SQLCA)
	
	lds_detail.DataObject = 'd_abc_fs_nota_venta_det_tbl'
	lds_detail.SetTransObject(SQLCA)
	
	//Verifico que han elegido un motivo de nota
	ll_row = dw_motivo.GetSelectedRow(0)
	if ll_row = 0 then 
		MessageBox("Error", "Debe elegir un motivo de nota, no se puede continuar. Por favor verifique!", StopSign!)
		dw_motivo.SetFocus()
		return
	end if
	
	//Obtengo los datos del motivo
	ls_motivo 			= dw_motivo.object.motivo			[ll_row]
	ls_desc_motivo		= dw_motivo.object.descripcion	[ll_row]
	
	
	//Verifico si ha elegido un cliente
	ll_row = dw_clientes.GetSelectedRow(0)
	if ll_row = 0 then 
		MessageBox("Error", "Debe elegir un Cliente para la nota de credito, no se puede continuar. Por favor verifique!", StopSign!)
		dw_clientes.SetFocus()
		return
	end if
	
	//Obtengo el dato del cliente
	ls_cliente 			= dw_clientes.object.cliente			[ll_row]
	ls_nom_cliente		= dw_clientes.object.nom_proveedor	[ll_row]
	ls_tipo_doc_ident	= dw_clientes.object.tipo_doc_ident	[ll_row]
	ls_ruc_dni			= dw_clientes.object.ruc_dni			[ll_row]
	
	//Verifico si ha elegido un comprobante de referencia
	ll_row = dw_comprobantes.GetSelectedRow(0)
	if ll_row = 0 then 
		MessageBox("Error", "Debe elegir un Comprobante de Venta, no se puede continuar. Por favor verifique!", StopSign!)
		dw_comprobantes.SetFocus()
		return
	end if
	
	//Obtengo los datos del comprobante seleccionado
	ls_nro_registro = dw_comprobantes.object.nro_registro 		[ll_row]
	ls_tipo_doc		 = dw_comprobantes.object.tipo_doc_cxc  		[ll_row]
	ls_Serie		 	 = dw_comprobantes.object.serie_cxc  			[ll_row]
	ls_nro			 = dw_comprobantes.object.nro_cxc  				[ll_row]
	
	//Si el detalle no esta vacio entonces no se puede poner mas detalle
	if ldw_master.GetRow() = 0 then
		MessageBox("Error", "No existe cabecera del documento. Por favor verifique!", StopSign!)
		return
	end if
	
	if ldw_detail.RowCount() > 0 then
		MessageBox("Error", "Ya existe detalle en el comprobante de Venta, no se puede insertar mas detalle. Por favor verifique!", StopSign!)
		return
	end if
	
	
	//Obtengo datos de la cabecera del comprobante
	ls_nro_registro_ref = ldw_master.object.nro_registro_ref [1]
	
	//Valido si todo esta ok
	if not IsNull(ls_nro_registro_ref) and trim(ls_nro_registro_ref) <> '' then
		if not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
			if trim(ls_nro_registro) <> ls_nro_registro_ref then
				MessageBox("Error", "El comprobante ya tiene referencia a un documento, no se puede colocar otra referencia diferente. Por favor verifique!", StopSign!)
				return
			end if
		end if
	end if
	
	//Obtengo la cabecera y detalle del registro
	if IsNull(ls_nro_registro) or trim(ls_nro_registro) = '' then
		MessageBox('Error', 'Solo se puede hacer Notas de Credito de facturación Simplificada. Por favor verifique!', StopSign!)
		return
	end if
	
	//Obtengo los datos de la cabecera y detalle del comrpobante de referencia
	lds_master.Retrieve(ls_nro_registro)
	
	if lds_master.RowCount() = 0 then
		MessageBox('Error', 'No existe Datos en la CABECERA del comprobante con numero de registro: ' + ls_nro_registro + '. Por favor verifique!', StopSign!)
		return
	end if
	
	lds_detail.Retrieve(ls_nro_registro)
	
	if lds_detail.RowCount() = 0 then
		MessageBox('Error', 'No existe Datos en el DETALLE del comprobante con numero de registro: ' + ls_nro_registro + '. Por favor verifique!', StopSign!)
		return
	end if

	//Obtengo el numero de documento
	//ls_nro_doc = gnvo_app.efact.of_get_nro_doc(ls_serie, ls_nro)	
	select pkg_fact_electronica.of_get_nro_doc(:ls_serie, :ls_nro)
		into :ls_nro_doc
	from dual;
	
	if SQLCA.SQLCode > 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al obtener el numero de documento. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
													
	//if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then return
	
	//Coloco la referencia del documento
	ldw_master.object.tipo_doc_ref 		[1] = ls_tipo_doc
	ldw_master.object.nro_doc_ref 		[1] = ls_nro_doc
	ldw_master.object.nro_registro_ref 	[1] = ls_nro_registro
	//Coloco el detalle del cliente
	ldw_master.object.cliente 				[1] = ls_cliente
	ldw_master.object.nom_cliente 		[1] = ls_nom_cliente
	ldw_master.object.ruc_dni 				[1] = ls_ruc_dni
	//Coloco  el motivo de la nota
	ldw_master.object.motivo_nota 		[1] = ls_motivo
	ldw_master.object.desc_motivo_nota	[1] = ls_desc_motivo
	ldw_master.object.observacion			[1] = ls_desc_motivo
	
	//Coloco el resto de datos que son importante directamente del comprobante
	ldw_master.object.item_direccion	[1] = lds_master.object.item_direccion [1]
	ldw_master.object.direccion		[1] = lds_master.object.direccion 		[1]
	ldw_master.object.cod_moneda		[1] = lds_master.object.cod_moneda 		[1]
	ldw_master.object.tasa_cambio		[1] = lds_master.object.tasa_cambio		[1]
	ldw_master.object.vendedor			[1] = lds_master.object.vendedor 		[1]
	ldw_master.object.nom_vendedor	[1] = lds_master.object.nom_vendedor	[1]
	
	
	//Ahora inserto el detalle del comprobante de Venta
	for ll_i = 1 to lds_detail.RowCount()
		ll_row = ldw_detail.event ue_insert()
		if ll_row > 0 then
			ldw_detail.object.almacen 				[ll_row] = lds_detail.object.almacen 			[ll_i]
			ldw_detail.object.cod_art 				[ll_row] = lds_detail.object.cod_art 			[ll_i]
			ldw_detail.object.codigo 				[ll_row] = lds_detail.object.codigo 			[ll_i]
			ldw_detail.object.cod_servicio		[ll_row] = lds_detail.object.cod_servicio 	[ll_i]
			ldw_detail.object.cod_sku 				[ll_row] = lds_detail.object.cod_sku 			[ll_i]
			ldw_detail.object.descripcion 		[ll_row] = lds_detail.object.descripcion 		[ll_i]
			ldw_detail.object.und 					[ll_row] = lds_detail.object.und 				[ll_i]
			ldw_detail.object.cant_proyect		[ll_row] = lds_detail.object.cant_proyect 	[ll_i]
			ldw_detail.object.precio_unit 		[ll_row] = lds_detail.object.precio_unit 		[ll_i]
			ldw_detail.object.descuento 			[ll_row] = lds_detail.object.descuento 		[ll_i]
			ldw_detail.object.flag_afecto_igv	[ll_row] = lds_detail.object.flag_afecto_igv [ll_i]
			ldw_detail.object.importe_igv 		[ll_row] = lds_detail.object.importe_igv 		[ll_i]
			ldw_detail.object.precio_vta 			[ll_row] = lds_detail.object.precio_vta 		[ll_i]
			
			ldw_detail.object.nro_proforma		[ll_row] = lds_detail.object.nro_proforma 	[ll_i]
			ldw_detail.object.item_proforma 		[ll_row] = lds_detail.object.item_proforma 	[ll_i]
			
			ldw_detail.object.nro_vale_vd 		[ll_row] = lds_detail.object.nro_vale_vd 		[ll_i]
			ldw_detail.object.imp_dscto 			[ll_row] = lds_detail.object.imp_dscto 		[ll_i]
			
			//Referencia al documento Anticipo 
			ldw_detail.object.tipo_doc_cxc 		[ll_row] = lds_detail.object.tipo_doc_cxc 	[ll_i]
			ldw_detail.object.nro_doc_cxc 		[ll_row] = lds_detail.object.nro_doc_cxc 		[ll_i]
			ldw_detail.object.item_cxc 			[ll_row] = lds_detail.object.item_cxc 			[ll_i]
			
			//Referencia al nro de registro
			ldw_detail.object.nro_registro_ref 	[ll_row] = lds_detail.object.nro_registro_ref 	[ll_i]
			ldw_detail.object.item_ref 			[ll_row] = lds_detail.object.item_ref 				[ll_i]
			
			//Referencia al impuesto de la bolsa plastica
			ldw_detail.object.flag_bolsa_plastica	[ll_row] = lds_detail.object.flag_bolsa_plastica 	[ll_i]
			ldw_detail.object.icbper 					[ll_row] = lds_detail.object.icbper 					[ll_i]
	
		end if
	next
	
	
	
	
	lstr_param.b_return = true
	
	CloseWithReturn(this, lstr_param)
catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al momento de procesar la nota de credito')
finally
	destroy lds_master
	destroy lds_detail
end try


end event

event ue_open_pre;call super::ue_open_pre;


istr_param = Message.PowerObjectParm

dw_motivo.SetTransObject(SQLCA)
dw_clientes.setTransObject(SQLCA)
dw_comprobantes.setTransObject(SQLCA)

dw_motivo.Retrieve(istr_param.string1)
uo_search.of_set_dw(dw_clientes)

dw_Clientes.Retrieve(istr_param.string2)

uo_documentos.of_set_dw(dw_comprobantes)
end event

event resize;call super::resize;uo_search.event ue_resize(sizetype, dw_clientes.width, uo_search.height)
uo_documentos.event ue_resize(sizetype, dw_comprobantes.width, uo_documentos.height)

dw_comprobantes.width 	= newwidth - dw_comprobantes.x - 10
st_3.width 					= newwidth - st_3.x - 10
end event

type uo_documentos from n_cst_search within w_select_datos_ncc_ndc
integer x = 1897
integer y = 112
integer width = 2153
integer taborder = 20
end type

on uo_documentos.destroy
call n_cst_search::destroy
end on

type cb_2 from commandbutton within w_select_datos_ncc_ndc
integer x = 3525
integer y = 1732
integer width = 517
integer height = 132
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_cancelar()
SetPointer(Arrow!)
end event

type cb_aceptar from commandbutton within w_select_datos_ncc_ndc
integer x = 2985
integer y = 1732
integer width = 517
integer height = 132
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_aceptar()
SetPointer(Arrow!)
end event

type dw_comprobantes from u_dw_abc within w_select_datos_ncc_ndc
integer x = 1897
integer y = 212
integer width = 2153
integer height = 1512
integer taborder = 20
string dataobject = "d_lista_comprob_for_ncc_ncd_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type st_3 from statictext within w_select_datos_ncc_ndc
integer x = 1897
integer width = 2153
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Seleccione el Comprobante de Venta"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_search from n_cst_search within w_select_datos_ncc_ndc
integer y = 772
integer width = 1893
integer taborder = 20
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type dw_clientes from u_dw_abc within w_select_datos_ncc_ndc
integer y = 868
integer width = 1893
integer height = 856
string dataobject = "d_lista_clientes_fs_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_output;call super::ue_output;String	ls_cliente

ls_Cliente = this.object.cliente	[al_row]

dw_comprobantes.Retrieve(ls_cliente, istr_param.string2)
end event

type st_2 from statictext within w_select_datos_ncc_ndc
integer y = 664
integer width = 1893
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Seelccione el Cliente"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_select_datos_ncc_ndc
integer width = 1893
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Seleccion Motivo de Nota Credito / Debito ..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_motivo from u_dw_abc within w_select_datos_ncc_ndc
integer y = 104
integer width = 1893
integer height = 548
string dataobject = "d_lista_motivo_nota_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

