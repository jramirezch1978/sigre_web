$PBExportHeader$w_pt319_add_edit_docs.srw
forward
global type w_pt319_add_edit_docs from w_abc
end type
type cb_3 from commandbutton within w_pt319_add_edit_docs
end type
type dw_detail from u_dw_abc within w_pt319_add_edit_docs
end type
type dw_master from u_dw_abc within w_pt319_add_edit_docs
end type
type cb_2 from commandbutton within w_pt319_add_edit_docs
end type
type cb_1 from commandbutton within w_pt319_add_edit_docs
end type
end forward

global type w_pt319_add_edit_docs from w_abc
integer width = 3241
integer height = 2264
string title = "[PT319] Ingresar los datos jalando de las facturas"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
cb_3 cb_3
dw_detail dw_detail
dw_master dw_master
cb_2 cb_2
cb_1 cb_1
end type
global w_pt319_add_edit_docs w_pt319_add_edit_docs

type variables
str_parametros istr_param
Long				il_find
Date				id_fec_fin
end variables

event ue_aceptar();Long	ll_row, ll_i
String	ls_detalle, ls_descripcion
u_dw_abc	ldw_master, ldw_detail
str_parametros	lstr_param

ldw_master = istr_param.dw_m
ldw_detail = istr_param.dw_d

if istr_param.accion = 'new' then
	//Si es nuevo entonces se procede a ingresar el dato
	for ll_i = 1 to dw_detail.RowCount() 
		ll_row = ldw_detail.event ue_insert( )
		
		if ll_row > 0 then
			ldw_detail.object.flag_ing_egr 		[ll_row] = dw_master.object.flag_ing_egr 		[1]
			ldw_detail.object.flag_flujo_caja 	[ll_row] = dw_master.object.flag_flujo_caja 	[1]
			ldw_detail.object.cod_seccion 		[ll_row] = dw_master.object.cod_seccion 		[1]
			ldw_detail.object.desc_seccion 		[ll_row] = dw_master.object.desc_seccion 		[1]
			ldw_detail.object.cod_detalle 		[ll_row] = dw_master.object.cod_detalle 		[1]
			ldw_detail.object.desc_detalle 		[ll_row] = dw_master.object.desc_detalle 		[1]
			ldw_detail.object.cencos		 		[ll_row] = dw_master.object.cencos 				[1]
			ldw_detail.object.cnta_prsp			[ll_row] = dw_master.object.cnta_prsp 			[1]
			
			ls_descripcion = dw_detail.object.descripcion 		[ll_i]
			
			if IsNull(ls_descripcion) or ls_descripcion = '' then
				ls_Descripcion = dw_master.object.desc_detalle 		[1]
			end if
			//Ahora el detalle
			ldw_detail.object.proveedor			[ll_row] = dw_detail.object.proveedor 			[ll_i]
			ldw_detail.object.nom_proveedor		[ll_row] = dw_detail.object.nom_proveedor 	[ll_i]
			ldw_detail.object.cod_moneda			[ll_row] = dw_detail.object.cod_moneda 		[ll_i]
			ldw_detail.object.imp_proyectado		[ll_row] = dw_detail.object.importe 			[ll_i]
			ldw_detail.object.descripcion			[ll_row] = ls_descripcion
			ldw_detail.object.tipo_doc				[ll_row] = dw_detail.object.tipo_doc 			[ll_i]
			ldw_detail.object.nro_doc				[ll_row] = dw_detail.object.nro_doc 			[ll_i]
			
			if dw_detail.object.cod_moneda [ll_i] = gnvo_app.is_soles then
				ldw_detail.object.imp_soles	[ll_row] = dw_detail.object.importe 			[ll_i]
				ldw_detail.object.imp_dolares	[ll_row] = 0.00
			else
				ldw_detail.object.imp_soles	[ll_row] = 0.00
				ldw_detail.object.imp_dolares	[ll_row] = dw_detail.object.importe 			[ll_i]
			end if
				
			
			
		end if

	next
end if

lstr_param.titulo = 's'
CloseWithReturn(this, lstr_param)

end event

on w_pt319_add_edit_docs.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
end on

on w_pt319_add_edit_docs.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()


end event

event ue_open_pre;call super::ue_open_pre;String 	ls_cod_seccion, ls_desc_seccion, ls_flag_ing_egr, ls_flag_flujo_Caja, ls_codigo, &
			ls_data, ls_ruc
Long 		ll_nro_item

u_dw_abc ldw_detail

istr_param = Message.PowerObjectParm

id_fec_fin	= istr_param.date1


//verifico entonces si es una accion nueva
if istr_param.accion = 'new' then
	dw_master.Reset()
	dw_master.event ue_insert( )
	
	//El flag de Ingreso o egreso
	if istr_param.opcion = 1 or istr_param.opcion = 2 or istr_param.opcion = 3 then
		ls_flag_ing_egr = 'I'
	else
		ls_flag_ing_egr = 'E'
	end if
	dw_master.object.flag_ing_egr [1] = ls_flag_ing_egr
	
	//Ahora el Flag de Flujo de Caja
	if istr_param.opcion = 1 then
		ls_flag_flujo_caja = '1'
	elseif istr_param.opcion = 2 or istr_param.opcion = 3 then
		ls_flag_flujo_caja = '2'
	else
		ls_flag_flujo_caja = istr_param.string1
	end if
	dw_master.object.Flag_flujo_caja [1] = ls_flag_flujo_caja
	
	
	//Codigo de seccion que ya viene con algunos datawindow
	if istr_param.opcion = 1 or istr_param.opcion = 2 then
		ls_cod_seccion = istr_param.string1
		
		select desc_seccion
			into :ls_desc_seccion
		from prsp_caja_seccion p
		where p.cod_seccion = :ls_cod_seccion;
		
	else
		//Ubico la primera seccion dependiendo del flag_ing_egr y el flag_flujo_caja
		select cod_seccion, desc_seccion
			into :ls_cod_Seccion, :ls_desc_seccion
		from prsp_caja_seccion
		where flag_ing_egr = :ls_flag_ing_egr
		  and flag_flujo_Caja = :ls_flag_flujo_caja
		 order by cod_seccion;
		 
	end if
	
	dw_master.object.cod_seccion 	[1] = ls_cod_seccion
	dw_master.object.desc_seccion [1] = ls_desc_seccion
	
	//Por defecto la moneda será soles
	dw_master.object.cod_moneda 		[1] = gnvo_app.is_soles
	dw_master.object.imp_proyectado 	[1] = 0.00

else
	
	// En tal caso entra como edición por lo que pongo todos los datos necesarios
	ll_nro_item = istr_param.long1
	//Busco la fila correspondiente al item recibido
	ldw_detail = istr_param.dw_d
	il_find = ldw_detail.Find("nro_item=" + string(ll_nro_item), 1, ldw_detail.RowCount())
	
	if il_find > 0 then
		//Encontrado el registro procedo a llenar los datos
		dw_master.object.nro_presupuesto [1] = ldw_detail.object.nro_presupuesto 	[il_find]
		dw_master.object.nro_item 			[1] = ldw_detail.object.nro_item 			[il_find]
		dw_master.object.fec_registro 	[1] = ldw_detail.object.fec_registro	 	[il_find]
		dw_master.object.flag_estado		[1] = ldw_detail.object.flag_estado			[il_find]
		dw_master.object.cod_usr		 	[1] = ldw_detail.object.cod_usr 				[il_find]
		dw_master.object.flag_ing_egr 	[1] = ldw_detail.object.flag_ing_egr 		[il_find]
		dw_master.object.flag_flujo_caja	[1] = ldw_detail.object.flag_flujo_caja	[il_find]
		dw_master.object.cod_moneda		[1] = ldw_detail.object.cod_moneda			[il_find]
		dw_master.object.imp_proyectado	[1] = ldw_detail.object.imp_proyectado		[il_find]
		dw_master.object.imp_ejecutado	[1] = ldw_detail.object.imp_ejecutado		[il_find]
		dw_master.object.descripcion		[1] = ldw_detail.object.descripcion			[il_find]
		
		dw_master.object.cod_seccion		[1] = ldw_detail.object.cod_seccion			[il_find]
		dw_master.object.desc_seccion		[1] = ldw_detail.object.desc_seccion		[il_find]
		
		dw_master.object.cod_detalle		[1] = ldw_detail.object.cod_detalle			[il_find]
		dw_master.object.desc_detalle		[1] = ldw_detail.object.desc_detalle		[il_find]
		
		//Centro de Costos
		ls_codigo = ldw_detail.object.cencos			[il_find]
		
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :ls_codigo;
		
		dw_master.object.cencos				[1] = ls_codigo
		dw_master.object.desc_cencos		[1] = ls_Data
		
		//Cuenta PResupuestal
		ls_codigo = ldw_detail.object.cnta_prsp			[il_find]
		
		select descripcion
			into :ls_data
		from presupuesto_cuenta
		where cnta_prsp = :ls_codigo;
		
		dw_master.object.cnta_prsp				[1] = ls_codigo
		dw_master.object.desc_cnta_prsp		[1] = ls_data
		
		//Proveedor
		ls_codigo = ldw_detail.object.proveedor			[il_find]
		
		if IsNull(ls_codigo) or ls_codigo = '' then
			dw_master.object.proveedor				[1] = gnvo_app.is_null
			dw_master.object.nom_proveedor		[1] = gnvo_app.is_null
			dw_master.object.ruc_dni				[1] = gnvo_app.is_null
		else
			select p.nom_proveedor, decode(p.ruc, null, p.nro_doc_ident, p.ruc)
				into :ls_data, :ls_ruc
			from proveedor p
			where p.proveedor = :ls_codigo;
			
	
			dw_master.object.proveedor				[1] = ls_codigo
			dw_master.object.nom_proveedor		[1] = ls_data
			dw_master.object.ruc_dni				[1] = ls_ruc
		end if

	else
		MessageBox('Error', 'No se ha encontrado el item ' + string(ll_nro_item) + ' en el detalle de presupuesto de caja, por favor verifique!')
		Post event close()
		return
	end if
	
	
	
end if
end event

type cb_3 from commandbutton within w_pt319_add_edit_docs
integer x = 1102
integer y = 2036
integer width = 599
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Jalar Documentos"
end type

event clicked;String			ls_flag_ing_egr
str_parametros lstr_param

dw_master.AcceptText()

ls_flag_ing_egr = dw_master.object.flag_ing_egr [1]

if ls_flag_ing_egr = 'I' then
	//Movimiento para Orden de Traslado
	lstr_param.titulo    = 'Cntas x Cobrar Pendientes'
	lstr_param.dw_master = 'd_sel_proveedor_cxc_tbl'
	lstr_param.dw1       = 'd_sel_cntas_cobrar_tbl' 
else
	//Movimiento para Orden de Traslado
	lstr_param.titulo    = 'Cntas x Pagar Pendientes'
	lstr_param.dw_master = 'd_sel_proveedor_cxp_tbl'
	lstr_param.dw1       = 'd_sel_cntas_pagar_tbl' 
end if

 
lstr_param.tipo		= '1D'
lstr_param.opcion    = 2
lstr_param.dw_m	   = dw_detail
lstr_param.date1		= id_fec_fin

OpenWithParm( w_abc_seleccion_md, lstr_param)
end event

type dw_detail from u_dw_abc within w_pt319_add_edit_docs
integer y = 536
integer width = 3205
integer height = 1484
string dataobject = "d_abc_prsp_caja_docs_det_tbl"
boolean livescroll = false
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

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

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_sql, ls_flag_ing_egr, ls_flag_flujo_caja, ls_seccion, ls_ruc, &
			ls_cnta_prsp, ls_desc_cnta, ls_descripcion

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_seccion'
		ls_flag_ing_egr = this.object.flag_ing_egr [row]

		if IsNull(ls_flag_ing_egr) or ls_flag_ing_egr = '' then
			MessageBox('Error', 'Debe especificar el flag de ingreso o egreso, por favor verifique!')
			this.setColumn("flag_ing_egr")
			return
		end if
		
		ls_flag_flujo_caja = this.object.flag_flujo_caja [row]

		if IsNull(ls_flag_flujo_caja) or ls_flag_flujo_caja = '' then
			MessageBox('Error', 'Debe especificar el flag de Flujo de Caja Adecuado, por favor verifique!')
			this.setColumn("flag_flujo_caja")
			return
		end if
		
		
		// Verifica que codigo ingresado exista			
		Select desc_seccion
	     into :ls_data
		  from prsp_caja_seccion
		 Where cod_seccion = :data 
		   and flag_estado = '1'
			and flag_ing_egr = :ls_flag_ing_egr 
		   and flag_flujo_caja = :ls_flag_flujo_caja;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_seccion		[row] = gnvo_app.is_null
			this.object.desc_seccion	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Sección no existe, no esta activo o no pertenece al flag indicado, por favor verifique')
			return 1
		end if

		this.object.desc_seccion			[row] = ls_data

	CASE 'cod_detalle'
		ls_seccion = this.object.cod_seccion 	[row]
		
		if IsNull(ls_seccion) or ls_seccion = '' then
			MessageBox('Error', 'Debe especificar primero la seccion, por favor verifique!')
			this.setColumn("cod_seccion")
			return
		end if

		// Verifica que codigo ingresado exista			
		Select t.desc_detalle, t.cnta_prsp, pc.descripcion
	     into :ls_data, :ls_cnta_prsp, :ls_desc_cnta
		  from 	prsp_caja_seccion_det 	t,
		  			presupuesto_cuenta		pc
		 Where t.cnta_prsp = pc.cnta_prsp (+)
		   and t.flag_estado = '1'
			and t.cod_detalle = :data
			and t.cod_seccion = :ls_seccion;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_detalle		[row] = gnvo_app.is_null
			this.object.desc_detalle	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Detalle no existe, no esta activo o no está asignado a la sección indicada, por favor verifique')
			return 1
		end if
		
		this.object.desc_detalle	[row] = ls_data
		this.object.cnta_prsp		[row] = ls_cnta_prsp
		this.object.desc_cnta_prsp	[row] = ls_desc_cnta
		
		ls_descripcion = this.object.descripcion [row]
			
		if IsNull(ls_descripcion) or len(trim(ls_descripcion)) = 0 then
			this.object.descripcion [row] = ls_data
		end if

	CASE 'cencos'

		// Verifica que codigo ingresado exista			
		Select t.desc_cencos
	     into :ls_data
		  from 	centros_costo 	t
		 Where t.cencos = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null
			MessageBox('Error', 'Centro de Costos no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_cencos	[row] = ls_data

	CASE 'cnta_prsp'

		// Verifica que codigo ingresado exista			
		Select t.descripcion
	     into :ls_data
		  from 	presupuesto_cuenta 	t
		 Where t.cnta_prsp = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null
			MessageBox('Error', 'Cuenta Presupuestal no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_cnta_prsp	[row] = ls_data

	CASE 'proveedor'

		// Verifica que codigo ingresado exista			
		Select t.nom_proveedor, decode(t.ruc, null, t.nro_doc_ident, t.ruc)
	     into :ls_data, :ls_ruc
		  from 	proveedor 	t
		 Where t.proveedor = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.object.ruc_dni			[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de proveedor no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.nom_proveedor	[row] = ls_data
		this.object.ruc_dni			[row] = ls_ruc
		

	CASE 'cod_moneda'

		// Verifica que codigo ingresado exista			
		Select t.descripcion
	     into :ls_data
		  from 	moneda 	t
		 Where t.cod_moneda = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_moneda		[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Moneda no existe o no esta activo, por favor verifique')
			return 1
		end if
		
	

END CHOOSE




//choose case lower(as_columna)
//	case ""
//		ls_sql = "select cc.cencos as codigo_cencos, " &
//				 + "cc.desc_cencos as descripcion_cencos " &
//				 + "from  cc " &
//				 + "where cc.flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cencos		[al_row] = ls_codigo
//			this.object.desc_cencos	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	case ""
//		ls_sql = "select pc.cnta_prsp as cnta_prsp, " &
//				 + "pc.descripcion as desc_cnta_prsp " &
//				 + "from  Pc " &
//				 + "where pc.flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cnta_prsp		[al_row] = ls_codigo
//			this.object.desc_cnta_prsp	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	case "proveedor"
//		ls_sql = "select p.proveedor as codigo_proveedor, " &	
//				 + "p.nom_proveedor as razon_social, " &
//				 + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni " &
//				 + "from proveedor p " &
//				 + "where p.flag_estado = '1'"
//
//		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
//
//		if ls_codigo <> '' then
//			this.object.proveedor		[al_row] = ls_codigo
//			this.object.nom_proveedor	[al_row] = ls_data
//			this.object.ruc_dni			[al_row] = ls_ruc
//			this.ii_update = 1
//		end if
//
//	case "cod_moneda"
//		ls_sql = "select cod_moneda as codigo_moneda, " &
//				 + "descripcion as descripcion_moneda " &
//				 + "from moneda " &
//				 + "where flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_moneda [al_row] = ls_codigo
//			this.ii_update = 1
//		end if
//end choose
end event

event keydwn;//Override
Integer 	li_column
String	ls_cadena, ls_columna
Long		ll_row


// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

type dw_master from u_dw_abc within w_pt319_add_edit_docs
integer width = 3205
integer height = 516
string dataobject = "d_abc_prsp_caja_docs_det_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr			[al_row] = gs_user
this.object.imp_proyectado	[al_row] = 0.00
this.object.imp_ejecutado	[al_row] = 0.00
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_ing_egr, ls_flag_flujo_caja, ls_seccion, ls_ruc, &
			ls_cnta_prsp, ls_desc_cnta, ls_descripcion

choose case lower(as_columna)
	case "cod_seccion"
		ls_flag_ing_egr = this.object.flag_ing_egr [al_row]

		if IsNull(ls_flag_ing_egr) or ls_flag_ing_egr = '' then
			MessageBox('Error', 'Debe especificar el flag de ingreso o egreso, por favor verifique!')
			this.setColumn("flag_ing_egr")
			return
		end if
		
		ls_flag_flujo_caja = this.object.flag_flujo_caja [al_row]

		if IsNull(ls_flag_flujo_caja) or ls_flag_flujo_caja = '' then
			MessageBox('Error', 'Debe especificar el flag de Flujo de Caja Adecuado, por favor verifique!')
			this.setColumn("flag_flujo_caja")
			return
		end if

		ls_sql = "select t.cod_seccion as codigo_seccion, " &
				 + "t.desc_seccion as descripcion_seccion " &
				 + "from prsp_caja_seccion t " &
				 + "WHERE t.FLAG_ESTADO = '1' " &
				 + "  and t.flag_ing_egr = '" + ls_flag_ing_egr + "'" &
				 + "  and t.flag_flujo_caja = '" + ls_flag_flujo_caja + "' " &
				 + "ORDER BY descripcion_seccion"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_seccion		[al_row] = ls_codigo
			this.object.desc_seccion	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_detalle"
		ls_seccion = this.object.cod_seccion 	[al_row]
		
		if IsNull(ls_seccion) or ls_seccion = '' then
			MessageBox('Error', 'Debe especificar primero la seccion, por favor verifique!')
			this.setColumn("cod_detalle")
			return
		end if
		
		ls_sql = "select t.cod_detalle as codigo_detalle, " &
				 + "t.desc_detalle as descripcion_detalle, " &
				 + "t.cnta_prsp as cnta_prsp, " &
				 + "pc.descripcion as desc_cnta_prsp " &
				 + "from prsp_caja_seccion_det t, " &
				 + "		presupuesto_cuenta pc " &
				 + "where t.cnta_prsp = pc.cnta_prsp (+) " &
				 + "  and t.flag_estado = '1' " &
				 + "  and t.cod_seccion = '" + ls_seccion + "' " &
				 + "ORDER BY descripcion_detalle"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_cnta_prsp, ls_desc_cnta, '2')

		if ls_codigo <> '' then
			this.object.cod_detalle		[al_row] = ls_codigo
			this.object.desc_detalle	[al_row] = ls_data
			this.object.cnta_prsp		[al_row] = ls_cnta_prsp
			this.object.desc_cnta_prsp	[al_row] = ls_desc_cnta
			
			ls_descripcion = this.object.descripcion [al_row]
			
			if IsNull(ls_descripcion) or len(trim(ls_descripcion)) = 0 then
				this.object.descripcion [al_row] = ls_data
			end if
			
			this.ii_update = 1
		end if
		
	case "cencos"
		ls_sql = "select cc.cencos as codigo_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo cc " &
				 + "where cc.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_prsp"
		ls_sql = "select pc.cnta_prsp as cnta_prsp, " &
				 + "pc.descripcion as desc_cnta_prsp " &
				 + "from presupuesto_cuenta Pc " &
				 + "where pc.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "proveedor"
		ls_sql = "select p.proveedor as codigo_proveedor, " &	
				 + "p.nom_proveedor as razon_social, " &
				 + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni " &
				 + "from proveedor p " &
				 + "where p.flag_estado = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc_dni			[al_row] = ls_ruc
			this.ii_update = 1
		end if

	case "cod_moneda"
		ls_sql = "select cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_moneda [al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_sql, ls_flag_ing_egr, ls_flag_flujo_caja, ls_seccion, ls_ruc, &
			ls_cnta_prsp, ls_desc_cnta, ls_descripcion

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_seccion'
		ls_flag_ing_egr = this.object.flag_ing_egr [row]

		if IsNull(ls_flag_ing_egr) or ls_flag_ing_egr = '' then
			MessageBox('Error', 'Debe especificar el flag de ingreso o egreso, por favor verifique!')
			this.setColumn("flag_ing_egr")
			return
		end if
		
		ls_flag_flujo_caja = this.object.flag_flujo_caja [row]

		if IsNull(ls_flag_flujo_caja) or ls_flag_flujo_caja = '' then
			MessageBox('Error', 'Debe especificar el flag de Flujo de Caja Adecuado, por favor verifique!')
			this.setColumn("flag_flujo_caja")
			return
		end if
		
		
		// Verifica que codigo ingresado exista			
		Select desc_seccion
	     into :ls_data
		  from prsp_caja_seccion
		 Where cod_seccion = :data 
		   and flag_estado = '1'
			and flag_ing_egr = :ls_flag_ing_egr 
		   and flag_flujo_caja = :ls_flag_flujo_caja;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_seccion		[row] = gnvo_app.is_null
			this.object.desc_seccion	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Sección no existe, no esta activo o no pertenece al flag indicado, por favor verifique')
			return 1
		end if

		this.object.desc_seccion			[row] = ls_data

	CASE 'cod_detalle'
		ls_seccion = this.object.cod_seccion 	[row]
		
		if IsNull(ls_seccion) or ls_seccion = '' then
			MessageBox('Error', 'Debe especificar primero la seccion, por favor verifique!')
			this.setColumn("cod_seccion")
			return
		end if

		// Verifica que codigo ingresado exista			
		Select t.desc_detalle, t.cnta_prsp, pc.descripcion
	     into :ls_data, :ls_cnta_prsp, :ls_desc_cnta
		  from 	prsp_caja_seccion_det 	t,
		  			presupuesto_cuenta		pc
		 Where t.cnta_prsp = pc.cnta_prsp (+)
		   and t.flag_estado = '1'
			and t.cod_detalle = :data
			and t.cod_seccion = :ls_seccion;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_detalle		[row] = gnvo_app.is_null
			this.object.desc_detalle	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Detalle no existe, no esta activo o no está asignado a la sección indicada, por favor verifique')
			return 1
		end if
		
		this.object.desc_detalle	[row] = ls_data
		this.object.cnta_prsp		[row] = ls_cnta_prsp
		this.object.desc_cnta_prsp	[row] = ls_desc_cnta
		
		ls_descripcion = this.object.descripcion [row]
			
		if IsNull(ls_descripcion) or len(trim(ls_descripcion)) = 0 then
			this.object.descripcion [row] = ls_data
		end if

	CASE 'cencos'

		// Verifica que codigo ingresado exista			
		Select t.desc_cencos
	     into :ls_data
		  from 	centros_costo 	t
		 Where t.cencos = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null
			MessageBox('Error', 'Centro de Costos no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_cencos	[row] = ls_data

	CASE 'cnta_prsp'

		// Verifica que codigo ingresado exista			
		Select t.descripcion
	     into :ls_data
		  from 	presupuesto_cuenta 	t
		 Where t.cnta_prsp = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null
			MessageBox('Error', 'Cuenta Presupuestal no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_cnta_prsp	[row] = ls_data

	CASE 'proveedor'

		// Verifica que codigo ingresado exista			
		Select t.nom_proveedor, decode(t.ruc, null, t.nro_doc_ident, t.ruc)
	     into :ls_data, :ls_ruc
		  from 	proveedor 	t
		 Where t.proveedor = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.object.ruc_dni			[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de proveedor no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.nom_proveedor	[row] = ls_data
		this.object.ruc_dni			[row] = ls_ruc
		

	CASE 'cod_moneda'

		// Verifica que codigo ingresado exista			
		Select t.descripcion
	     into :ls_data
		  from 	moneda 	t
		 Where t.cod_moneda = :data
		   and t.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_moneda		[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Moneda no existe o no esta activo, por favor verifique')
			return 1
		end if
		
	

END CHOOSE




//choose case lower(as_columna)
//	case ""
//		ls_sql = "select cc.cencos as codigo_cencos, " &
//				 + "cc.desc_cencos as descripcion_cencos " &
//				 + "from  cc " &
//				 + "where cc.flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cencos		[al_row] = ls_codigo
//			this.object.desc_cencos	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	case ""
//		ls_sql = "select pc.cnta_prsp as cnta_prsp, " &
//				 + "pc.descripcion as desc_cnta_prsp " &
//				 + "from  Pc " &
//				 + "where pc.flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cnta_prsp		[al_row] = ls_codigo
//			this.object.desc_cnta_prsp	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	case "proveedor"
//		ls_sql = "select p.proveedor as codigo_proveedor, " &	
//				 + "p.nom_proveedor as razon_social, " &
//				 + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni " &
//				 + "from proveedor p " &
//				 + "where p.flag_estado = '1'"
//
//		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
//
//		if ls_codigo <> '' then
//			this.object.proveedor		[al_row] = ls_codigo
//			this.object.nom_proveedor	[al_row] = ls_data
//			this.object.ruc_dni			[al_row] = ls_ruc
//			this.ii_update = 1
//		end if
//
//	case "cod_moneda"
//		ls_sql = "select cod_moneda as codigo_moneda, " &
//				 + "descripcion as descripcion_moneda " &
//				 + "from moneda " &
//				 + "where flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_moneda [al_row] = ls_codigo
//			this.ii_update = 1
//		end if
//end choose
end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event keydwn;//Override
Integer 	li_column
String	ls_cadena, ls_columna
Long		ll_row


// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

type cb_2 from commandbutton within w_pt319_add_edit_docs
integer x = 2203
integer y = 2036
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn( parent, lstr_param)
end event

type cb_1 from commandbutton within w_pt319_add_edit_docs
integer x = 1751
integer y = 2036
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

