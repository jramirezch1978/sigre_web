$PBExportHeader$w_al326_solicitud_pedido.srw
forward
global type w_al326_solicitud_pedido from w_abc_mastdet_smpl
end type
type sle_nro from u_sle_codigo within w_al326_solicitud_pedido
end type
type cb_1 from commandbutton within w_al326_solicitud_pedido
end type
type st_nro from statictext within w_al326_solicitud_pedido
end type
end forward

global type w_al326_solicitud_pedido from w_abc_mastdet_smpl
integer width = 4073
integer height = 2724
string title = "[AL326] Solicitud de Pedido"
string menuname = "m_mantenimiento"
event ue_cerrar_documento ( )
sle_nro sle_nro
cb_1 cb_1
st_nro st_nro
end type
global w_al326_solicitud_pedido w_al326_solicitud_pedido

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_solicitud)
end prototypes

event ue_cerrar_documento();string 	ls_estado
Integer	li_i

if dw_master.RowCount() = 0 then return

//Valido si la cabecera del documento esta activo
ls_estado = dw_master.object.flag_estado [1]

if ls_estado = '0' then
	f_mensaje("Error, El Documento esta Anulado no se puede cerrar, por favor verifique!", "")
	return
elseif ls_estado = '2' then
	f_mensaje("Error, El Documento ya se encuentra Cerrado, por favor verifique!", "")
	return
end if

//Pregunto si desea cerrar el documento
if MessageBox('Aviso', 'Desea cerrar el documento?, una vez confirmado y grabado no podrá revertirlo', Information!, Yesno!, 2 ) =  2 then return

dw_master.object.flag_estado [1] = '2'

for li_i = 1 to dw_Detail.Rowcount()
	dw_Detail.object.flag_estado [li_i] = '2'
next	

dw_master.ii_update = 1
dw_detail.ii_update = 1
end event

public function integer of_set_numera ();//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro
string 	ls_origen

//Obtengo origen seleccionado
ls_origen 	 =	dw_master.object.cod_origen [1]

if is_action = 'new' then

	Select ult_nro 
		into :ll_ult_nro 
	from num_solicitud_pedido
	where origen = :ls_origen for update;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_solicitud_pedido (origen, ult_nro)
			values( :ls_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox("Error al iniciar el numerador" , "Error al insertar registro en num_solicitud_pedido: " + ls_mensaje)
			return 0
		end if
		
		ll_ult_nro = 1
 	end if
	
	
	//Asigna numero a cabecera
	ls_nro = TRIM( ls_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_solicitud[dw_master.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_solicitud_pedido 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :ls_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar num_solicitud_pedido', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_solicitud[dw_master.getrow()] 
end if

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.nro_solicitud [ll_i] = ls_nro
next

return 1
end function

public subroutine of_retrieve (string as_nro_solicitud);String ls_flag_sub_categ

dw_master.Retrieve(as_nro_solicitud)
dw_master.ii_update = 0
dw_master.ResetUpdate ()

if dw_master.RowCount() > 0 then
	if trim(dw_master.object.nro_solicitud[1]) <> '' then
		dw_master.object.cod_origen.edit.DisplayOnly = 'yes'
	end if
	ls_flag_sub_categ = dw_master.object.flag_sub_categ	[1]
	if ls_flag_sub_categ = '1' then
		dw_detail.dataobject = "d_abc_solicitud_pedido_det2_tbl"
	else
		dw_detail.dataobject = "d_abc_solicitud_pedido_det_tbl"
	end if
	dw_detail.settransobject(sqlca) 
	dw_detail.Retrieve(as_nro_solicitud)	
	dw_detail.ii_update = 0
	dw_detail.ResetUpdate ()
end if
is_Action  ='open'
end subroutine

on w_al326_solicitud_pedido.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.st_nro=create st_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_nro
end on

on w_al326_solicitud_pedido.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.st_nro)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master
end event

event ue_update_pre;call super::ue_update_pre;
ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail) <> true then return


//Valido que siempre el documento se guarde con un detalle
if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_lista_solicitud_pedido_tbl'
sl_param.titulo = 'Solicitud de Pedido'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_modify;//Override
String ls_estado

if dw_master.RowCount() = 0 then return

ls_estado = dw_master.object.flag_estado [1]

if ls_estado = '0' or ls_estado = '2' then
	
	f_mensaje("Error, no esta permitido modificar documentos no activos, por favor verifique!", "")
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	return
end if

dw_master.Modify("cod_origen.Protect ='1~tIf(not IsNull(nro_solicitud),1,0)'")

dw_master.of_protect()
dw_detail.of_protect()

dw_master.Modify("flag_sub_categ.Protect='1'")
end event

event ue_print;call super::ue_print;//''
str_parametros lstr_param

try 
	// vista previa de mov. almacen
	str_parametros lstr_rep
	String			ls_tipo_almacen
	
	if dw_master.rowcount() = 0 then return
	
	//Corresponde a un almacen de Productos Terminados
	Open(w_selecciona_formato)
	
	if Isnull(Message.Powerobjectparm) or not isValid(Message.Powerobjectparm) then 
		f_mensaje("Error, debe seleecionar un formato de impresión para continuar", "")
		return
	end if
	
	lstr_param = Message.PowerObjectParm
	if not lstr_param.b_Return then return
	
	if dw_master.object.flag_sub_categ	[1] = '2' then
		if lstr_param.string1 = '1' then
			lstr_rep.dw1 		= 'd_rpt_solicitud_pedido_tbl'
		else
			lstr_rep.dw1 		= 'd_rpt_solicitud_pedido_cmp'
		end if
	else
		if lstr_param.string1 = '1' then
			lstr_rep.dw1 		= 'd_rpt_solicitud_pedido2_tbl'
		else
			lstr_rep.dw1 		= 'd_rpt_solicitud_pedido2_cmp'
		end if
	end if
	
	lstr_rep.titulo 	= 'Previo de Solicitud de Pedido'
	lstr_rep.string1 	= dw_master.object.nro_solicitud	[dw_master.getrow()]
	lstr_rep.tipo		= '1S'
	
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de Solicitud de Pedido")
end try
end event

event ue_anular;call super::ue_anular;string 	ls_estado
Integer	li_i
Decimal	ldc_cant_atendida

if dw_master.RowCount() = 0 then return

//Valido si la cabecera del documento esta activo
ls_estado = dw_master.object.flag_estado [1]

if ls_estado <> '1' then
	f_mensaje("Error, El documento no se puede anular, por favor verifique!", "")
	return
end if

//Valido que todo el detalle del documento este activo
for li_i = 1 to dw_Detail.Rowcount()
	ls_estado 			= dw_detail.object.flag_estado [1]
	ldc_cant_atendida = Dec (dw_detail.object.cant_atendida [1])
	
	if ls_estado <> '1' then
		f_mensaje("Error, El documento no se puede anular, un item del detalle no esta activo, por favor verifique!", "")
		return
	end if
	
	if ldc_cant_atendida >0 then
		f_mensaje("Error, El documento no se puede anular, un item del detalle ya tiene cantidad, por favor verifique!", "")
		return
	end if

next	

//Pregunto si desea anular el documento
if MessageBox('Aviso', 'Desea anular el documento?, una vez confirmado y grabado no podrá revertirlo', Information!, Yesno!, 2 ) =  2 then return

dw_master.object.flag_estado [1] = '0'

for li_i = 1 to dw_Detail.Rowcount()
	dw_Detail.object.flag_estado [li_i] = '0'
next	


dw_master.ii_update = 1
dw_detail.ii_update = 1
end event

event ue_insert;//Override

Long  	ll_row
String	ls_estado

if idw_1 = dw_detail then
	if dw_master.Rowcount() = 0 then return
	ls_estado = dw_master.object.flag_estado [1]
	
	if ls_estado <> '1' then
		f_mensaje("Error, el documento no se encuentra activo para ingresar mas detalle, por favor verifique", "XER_564")
		return
	end if

end if



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	is_action = 'open'
	
	if dw_master.RowCount() > 0 then
		of_retrieve(dw_master.object.nro_solicitud [1])
	end if
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_al326_solicitud_pedido
integer x = 0
integer y = 128
integer width = 4014
integer height = 1264
string dataobject = "d_abc_solicitud_pedido_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String 	ls_nom_usuario, ls_desc_origen
DateTime ldt_fecha

ldt_fecha = gnvo_app.of_fecha_actual( )

this.object.fec_registro 		[al_row] = ldt_fecha
this.object.flag_estado 		[al_row] = '1'
this.object.create_by	 		[al_row] = gs_user
this.object.flag_sub_categ	 	[al_row] = '2'  			//Por defecto subcategorias
this.object.fec_solicitud	 	[al_row] = Date(ldt_fecha)
this.object.cod_origen	 		[al_row] = gs_origen



//Obtener el nombre del usuario que se ha lgueado
select nombre
	into :ls_nom_usuario
from usuario
where cod_usr = :gs_user;

this.object.nom_usr_registro 	[al_row] = ls_nom_usuario

//Obtener la descripcion del origen
select nombre	
	into :ls_desc_origen
from origen
where cod_origen = :gs_origen;

this.object.desc_origen 	[al_row] = ls_desc_origen


this.setColumn("cod_origen")

//Cuando se agrega una nueva cabecera hay que eliminar el detalle
dw_detail.Reset()
dw_detail.REsetUpdate( )
dw_detail.ii_update = 0

is_action = 'new'


end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_nro_solicitud

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_origen"

		ls_nro_solicitud = this.object.nro_Solicitud [al_row]
		
		if not IsNull(ls_nro_solicitud) and trim(ls_nro_solicitud) <> '' then
			MessageBox('Error', 'No puede cambiar el codigo de origen cuando se ha generado el numero de documento, por favor verifique!', Exclamation!)
			return
		end if
		
		ls_sql = "select cod_origen as codigo_origen, " &
				 + "nombre as descripcion_sucursal " &
				 + "from origen  " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.desc_origen	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "usr_solicita"

		ls_sql = "select cod_usr as codigo_usuario, " &
				 + "nombre as nombre_usuario " &
				 + "from usuario  " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.usr_solicita		[al_row] = ls_codigo
			this.object.nom_usr_solicita	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "forma_pago"

		ls_sql = "select fp.forma_pago as forma_pago, " &
				 + "fp.desc_forma_pago  as descripcion_forma_pago " &
				 + "from forma_pago fp " &
				 + "where fp.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.forma_pago			[al_row] = ls_codigo
			this.object.desc_forma_pago	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_moneda"

		ls_sql = "select m.cod_moneda as codigo_moneda, " &
				 + "m.descripcion  as descripcion_moneda " &
				 + "from moneda m " &
				 + "where m.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda			[al_row] = ls_codigo
			this.object.nom_moneda			[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_origen'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from origen
		 Where cod_origen = :data  
		   and flag_estado = '1';
			
		// Verifica que el registro exista o no
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Surcursal ingresada o no se encuentra activo, por favor verifique")
			this.object.cod_origen	[row] = ls_null
			this.object.desc_origen	[row] = ls_null
			return 1
			
		end if

		this.object.desc_origen		[row] = ls_desc

	CASE 'usr_solicita' 

		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from usuario
		 Where cod_usr = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Usuario solicitante o no se encuentra activo, por favor verifique")
			this.object.usr_solicita		[row] = ls_null
			this.object.nom_usr_solicita	[row] = ls_null
			return 1
			
		end if

		this.object.nom_usr_solicita		[row] = ls_desc

	CASE 'forma_pago' 

		// Verifica que codigo ingresado exista			
		Select desc_forma_pago
	     into :ls_desc
		  from forma_pago
		 Where forma_pago = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Forma de Pago o no se encuentra activo, por favor verifique")
			this.object.forma_pago			[row] = ls_null
			this.object.desc_forma_pago	[row] = ls_null
			return 1
			
		end if

		this.object.desc_forma_pago		[row] = ls_desc

	CASE 'cod_moneda' 

		// Verifica que codigo ingresado exista	
		Select descripcion
	     into :ls_desc
		  from moneda
		 Where cod_moneda = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Moneda o no se encuentra activo, por favor verifique")
			this.object.cod_moneda			[row] = ls_null
			this.object.nom_moneda			[row] = ls_null
			return 1
			
		end if

		this.object.nom_moneda		[row] = ls_desc
	
	CASE 'flag_sub_categ' 

		if data = '1' then
			dw_detail.dataobject = "d_abc_solicitud_pedido_det2_tbl"
			dw_detail.settransobject(sqlca) 
		elseif data = '2' then
			dw_detail.dataobject = "d_abc_solicitud_pedido_det_tbl"
			dw_detail.settransobject(sqlca) 
		end if
		
END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_al326_solicitud_pedido
integer x = 0
integer y = 1408
integer width = 2962
integer height = 1156
string dataobject = "d_abc_solicitud_pedido_det_tbl"
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1]	= 3

idw_mst  = 		dw_master
//idw_det  =  				// dw_detail
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.cantidad 		[al_row] = 0
this.object.precio_unit	 	[al_row] = 0
this.object.precio_unit	 	[al_row] = 0
this.object.flag_estado 	[al_row] = '1'
this.object.create_by 		[al_row] = gs_user
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_Actual()

this.object.nro_item			[al_row] = of_nro_item( )

dw_master.Modify("flag_sub_categ.Protect='1'")

this.setColumn("nro_pedido_prov")
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_und, ls_cod_sub_cat
choose case lower(as_columna)
		
	case "proveedor"

		ls_sql = "select p.proveedor as proveedor, " &
				 + "p.nom_proveedor as razon_social, " &
				 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
				 + "from proveedor p " &
				 + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_sub_cat"

		ls_sql = "select a2.cod_sub_cat as codigo_sub_categ, " &
				 + "a2.desc_sub_cat as descripcion_sub_categ " &
				 + "from articulo_sub_categ a2 " &
				 + "where a2.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sub_cat		[al_row] = ls_codigo
			this.object.desc_sub_cat	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "color"

		ls_sql = "select color as color, " &
				 + "descripcion as descripcion_color " &
				 + "from color " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.color			[al_row] = ls_codigo
			this.object.desc_color	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "almacen"

		ls_sql = "select a.almacen as almacen, " &
				 + "a.desc_almacen as descripcion_almacen " &
				 + "from almacen a " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_art"
		//Verifico que primero haya elegido la subcategoría
		ls_cod_sub_cat = this.object.cod_sub_cat [al_row]
		
		if IsNull(ls_cod_sub_cat) or ls_cod_sub_cat = '' then
			MessageBox('Error', 'Debe Seleccionar previamente la subcategoría del artículo', StopSign!)
			this.object.cod_art	[al_row] = gnvo_app.is_null
			this.object.desc_art	[al_row] = gnvo_app.is_null
			this.object.und		[al_row] = gnvo_app.is_null
			
			this.SetColumn("cod_sub_cat")
			
			return 
		end if
		
		ls_sql = "select a.cod_art as codigo, " &
				 + "a.desc_art as descripcion, " &
				 + "a.und as unidad " &
				 + "from articulo a " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.object.und		[al_row] = ls_und
			this.ii_update = 1
		end if
		
end choose


end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc, ls_und, ls_cod_sub_cat
Long 		ll_count

Accepttext()

CHOOSE CASE dwo.name
	CASE 'proveedor'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_desc
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Codigo de Proveedor o no se encuentra activo, por favor verifique")
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_proveedor		[row] = ls_desc

	CASE 'cod_sub_cat' 

		// Verifica que codigo ingresado exista			
		select a2.desc_sub_cat 
			into :ls_desc
		from articulo_sub_categ a2 
		where a2.cod_sub_cat = :data
		  and a2.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe subcategoría o no se encuentra activo, por favor verifique")
			this.object.cod_sub_cat		[row] = gnvo_app.is_null
			this.object.desc_sub_cat	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_sub_cat		[row] = ls_desc

	CASE 'color' 

		// Verifica que codigo ingresado exista			
		select descripcion
			into :ls_desc
		from color 
		where color = :data
		  and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Color o no se encuentra activo, por favor verifique")
			this.object.color			[row] = gnvo_app.is_null
			this.object.desc_color	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_color		[row] = ls_desc

	CASE 'almacen' 

		// Verifica que codigo ingresado exista			
		select a.desc_almacen
			into :ls_desc
		from almacen a 
		where a.almacen = :data
		  and a.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Almacén o no se encuentra activo, por favor verifique")
			this.object.almacen			[row] = gnvo_app.is_null
			this.object.desc_almacen	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_almacen		[row] = ls_desc

		
	CASE 'cod_art' 
		//Obtengo ls sub categoría
		ls_cod_sub_cat = this.object.cod_sub_cat [row]
		
		if IsNull(ls_cod_sub_cat) or ls_cod_sub_cat = '' then
			MessageBox('Error', 'Debe Seleccionar previamente la subcategoría del artículo', StopSign!)
			this.object.cod_art	[row] = gnvo_app.is_null
			this.object.desc_art	[row] = gnvo_app.is_null
			
			this.SetColumn("cod_sub_cat")
			return 1

		end if

		// Verifica que codigo ingresado exista			
		select a.desc_art, a.und
			into :ls_desc, :ls_und
		from articulo a 
		where a.cod_art 		= :data
		  and a.sub_cat_art 	= :ls_cod_sub_cat
		  and a.flag_estado 	= '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Artículo o no le corresponde a la subcategoría " + trim(ls_cod_sub_cat) + " o no se encuentra activo, por favor verifique")
			this.object.cod_art	[row] = gnvo_app.is_null
			this.object.desc_art	[row] = gnvo_app.is_null
			this.object.und		[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_art		[row] = ls_desc		
		this.object.und			[row] = ls_und		
END CHOOSE

end event

type sle_nro from u_sle_codigo within w_al326_solicitud_pedido
integer x = 283
integer y = 4
integer width = 471
integer height = 92
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;dw_detail.reset()
cb_1.event clicked()
end event

type cb_1 from commandbutton within w_al326_solicitud_pedido
integer x = 855
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type st_nro from statictext within w_al326_solicitud_pedido
integer y = 16
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

