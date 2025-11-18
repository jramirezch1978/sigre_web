$PBExportHeader$w_al301_solicitud_salida.srw
forward
global type w_al301_solicitud_salida from w_abc
end type
type dw_1 from datawindow within w_al301_solicitud_salida
end type
type cb_1 from commandbutton within w_al301_solicitud_salida
end type
type sle_nro from singlelineedit within w_al301_solicitud_salida
end type
type st_2 from statictext within w_al301_solicitud_salida
end type
type sle_ori from singlelineedit within w_al301_solicitud_salida
end type
type st_1 from statictext within w_al301_solicitud_salida
end type
type dw_detail from u_dw_abc within w_al301_solicitud_salida
end type
type dw_master from u_dw_abc within w_al301_solicitud_salida
end type
end forward

global type w_al301_solicitud_salida from w_abc
integer width = 3881
integer height = 2268
string title = "Solicitud de Salida [al301]"
string menuname = "m_mtto_impresion"
windowstate windowstate = maximized!
event ue_anular ( )
event ue_cancelar ( )
dw_1 dw_1
cb_1 cb_1
sle_nro sle_nro
st_2 st_2
sle_ori sle_ori
st_1 st_1
dw_detail dw_detail
dw_master dw_master
end type
global w_al301_solicitud_salida w_al301_solicitud_salida

type variables
String 	is_vnta_terc, is_cons_interno, is_doc_ss, is_flag_cnta_prsp, &
			is_salir, is_doc_ot
DateTime	id_fecha_proc
end variables

forward prototypes
public function integer of_set_status_doc (datawindow idw)
public function integer of_set_numera ()
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_articulo_restriccion (string as_cod_art, string as_tipo_doc, string as_cencos)
public subroutine of_saldos (string as_cod_art)
public function integer of_get_param ()
end prototypes

event ue_anular();Long j

IF dw_master.getrow() = 0 then return
IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.Object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1		// Activa indicar para grabacion

// Anulando Detalle
For j = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[j] = '0'
	dw_detail.object.cant_proyect[j] = 0
Next
dw_detail.ii_update = 1		// Activa indicar para grabacion
is_action = 'anu'
of_set_Status_doc(dw_master)
end event

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()

is_Action = ''
of_set_status_doc(dw_master)

end event

public function integer of_set_status_doc (datawindow idw);this.changemenu( m_mtto_impresion)
Int li_estado

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled 	= true
else
	m_master.m_file.m_basedatos.m_insertar.enabled 	= false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled 	= true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled 	= false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled 	= true
else
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled 	= true
else
	m_master.m_file.m_basedatos.m_anular.enabled 	= false
end if

m_master.m_file.m_basedatos.m_abrirlista.enabled = true
m_master.m_file.m_printer.m_print1.enabled = true

if dw_master.getrow() = 0 then return 0
if is_Action = 'new' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false		
	// Activa desactiva opcion de modificacion, eliminacion	
	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	else		
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= false
		end if
	end if
end if
if is_Action = 'open' then
	li_estado = Long( dw_master.object.flag_estado[dw_master.getrow()])
	
	Choose case li_estado
		case 0		// Anulado			
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
	CASE 2,3   // Atendido parcial, total
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
		if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
			if is_flag_insertar = '1' then
				m_master.m_file.m_basedatos.m_insertar.enabled 	= true
			else
				m_master.m_file.m_basedatos.m_insertar.enabled 	= false
			end if
	   else			
		   m_master.m_file.m_basedatos.m_insertar.enabled = false
	   end if
	end CHOOSE
end if

if is_Action = 'anu' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false
end if

if is_Action = 'edit' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled = false
end if

if is_Action = 'del' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled = false
end if
return 1
end function

public function integer of_set_numera ();String ls_next_nro
Long ll_next_nro, j

// Numera documento
if is_action = 'new' then	
	ls_next_nro = f_numera_documento('num_sol_salida', 9)
	dw_master.object.nro_sol_salida[dw_master.getrow()] = ls_next_nro
else 
	ls_next_nro = dw_master.object.nro_sol_salida[dw_master.getrow()] 
end if
// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_doc[j] = ls_next_nro
next

return 1
end function

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

dw_master.Reset()
dw_detail.Reset()

ll_row = dw_master.retrieve(as_origen, as_nro)
is_action = 'open'

if ll_row > 0 then		
	dw_detail.retrieve( as_nro)
	of_set_status_doc( dw_master )
end if
dw_master.il_row = ll_row

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

return 


end subroutine

public function integer of_articulo_restriccion (string as_cod_art, string as_tipo_doc, string as_cencos);// Verifica que articulo no este restringido
Long ln_count

Select count(cod_art) into :ln_count 
  from articulo_doc_restriccion where cod_Art = :as_cod_art
  and tipo_doc = :as_tipo_doc and cencos = :as_cencos;
if ln_count > 0 then
	messagebox( "Atencion", "Codigo " + as_cod_Art + " esta restringido", exclamation!)
	return 0
end if

return 1
end function

public subroutine of_saldos (string as_cod_art);// Busca el saldo de un articulo


end subroutine

public function integer of_get_param ();// busca tipo doc. sol. compra
Select doc_ss, oper_cons_interno, doc_ot
	into :is_doc_ss, :is_cons_interno, :is_doc_ot
from logparam 
where reckey = '1';  

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en logparam')
	return 0
end if

if IsNull(is_doc_ss) or is_doc_ss = '' then
	MessageBox('Aviso', 'No ha definido Documento de Solicitud de Salida en logparam')
	return 0
end if

if IsNull(is_cons_interno) or is_cons_interno = '' then
	MessageBox('Aviso', 'No ha definido Ingreso por Compra en logparam')
	return 0
end if

if IsNull(is_doc_ot) or is_doc_ot = '' then
	MessageBox('Aviso', 'No ha definido Ingreso por Compra en logparam')
	return 0
end if

//Parametros de presupuesto
select NVL(flag_mod_cnta_prsp,'0')
	into :is_flag_cnta_prsp
from presup_param
where llave = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en Presupuesto')
	return 0
end if

if is_flag_cnta_prsp = '' or IsNull(is_flag_cnta_prsp) then
	MessageBox('Aviso', 'No ha definido flag_mod_cnta_prsp en Presup_param')
	return 0
end if

return 1
end function

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

idw_1 = dw_master              		// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 
dw_detail.of_protect()

ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101     

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery() 
	return 
end if

dw_master.object.p_logo.filename = gs_logo	
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
Long j, ln_ano
String ls_cod_art, ls_cencos, ls_almacen

ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

if is_action <> 'del' then
	if dw_detail.rowcount() = 0 then
		Messagebox( "Error", "Accion no valida, Ingrese detalle")
		return
	end if
end if

if dw_master.GetRow() = 0 then return

ls_almacen = dw_master.object.almacen[dw_master.GetRow()]

For j = 1 to dw_detail.rowcount()
	ls_cod_art = dw_detail.object.cod_art[j]	
	ls_cencos  = dw_detail.object.cencos[j]
	dw_detail.object.almacen[j] = ls_almacen
	dw_detail.ii_update = 1
   if of_articulo_restriccion( ls_cod_Art, is_doc_ss, ls_cencos) = 0 then return	
Next

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_set_numera() = 0 then return
if is_action <> 'anu' then
	dw_master.of_protect()         			// bloquear modificaciones 
	dw_detail.of_protect()
end if

//is_action = ''  
ib_update_check = true


end event

on w_al301_solicitud_salida.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_impresion" then this.MenuID = create m_mtto_impresion
this.dw_1=create dw_1
this.cb_1=create cb_1
this.sle_nro=create sle_nro
this.st_2=create st_2
this.sle_ori=create sle_ori
this.st_1=create st_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_ori
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_detail
this.Control[iCurrent+8]=this.dw_master
end on

on w_al301_solicitud_salida.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.sle_nro)
destroy(this.st_2)
destroy(this.sle_ori)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_modify;call super::ue_modify;if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then return

is_action = 'edit'

dw_master.of_protect()
dw_detail.of_protect()

dw_detail.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
dw_detail.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

dw_detail.Modify("cod_art.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
dw_detail.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

of_set_status_doc( dw_master)

// Si esta activo el flag de Presupuesto para que no eliga
// la cuenta presupuestal
if is_flag_cnta_prsp = '1' then
	dw_detail.object.cnta_prsp.protect = 1
	dw_detail.object.cnta_prsp.background.color = RGB(192,192,192)
end if

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String ls_msg1, ls_msg2, ls_origen, ls_nro_sol


dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	// Parche, que al grabar o insertar detalle haga un retrieve del detalle
	ls_origen		= dw_master.object.cod_origen[dw_master.getrow()]
	ls_nro_sol 		= dw_master.object.nro_sol_salida[dw_master.getrow()]
	of_retrieve(ls_origen, ls_nro_sol)
	is_action = 'open'	
	of_set_status_doc( dw_master)
//	dw_detail.reset()
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1,ls_msg2, exclamation!)
END IF
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_dddw_solicitud_salida"
sl_param.titulo = "Solicitud de Salida"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

event ue_insert;call super::ue_insert;string 	ls_almacen
Long  	ll_row, ll_mov_atrazados
n_cst_diaz_retrazo lnvo_amp_retr

IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

IF idw_1 = dw_detail then
	ls_almacen = dw_master.object.almacen[dw_master.getrow()]
	if isnull(ls_almacen) or trim(ls_almacen) = '' then
		messagebox('Almacenes', 'Debe seleccionar un almacén antes de poder insertar un detalle')
		return
	end if
end if

id_fecha_proc = f_fecha_actual() 

if idw_1 = dw_master then
	// Obtengo los movimientos proyectados atrazados 
	// Solo por el tipo de documento
	// Los dias de retrazo los toma de LogParam y el usuario de gs_user
	lnvo_amp_retr = CREATE n_cst_diaz_retrazo
	ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_ss )
	DESTROY lnvo_amp_retr
	
	if ll_mov_atrazados > 0 then
		MessageBox('Aviso', 'Tiene pendientes ' + string(ll_mov_atrazados) &
			+ ' movimientos Proyectados en Solicitud de Salida')
		return
	end if
end if


if idw_1 = dw_master then dw_master.reset()
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_print();call super::ue_print;str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_sol_salida[dw_master.getrow()]
OpenSheetWithParm(w_al301_solicitud_salida_frm, lstr_rep, This, 2, layered!)

end event

event ue_delete();// Override
IF dw_master.getrow() = 0 then return
if idw_1 = dw_master then 
	Messagebox( "Operacion no válida", "No se permite Eliminar este documento")	
	return 
end if

if dw_detail.rowcount() = 1 then
	messagebox( "Operacion no válida", "No se permite dejar el documento vacio")
	return 
end if

Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

IF is_action <> 'new' then	
	is_action = 'del'
	of_Set_Status_doc(dw_detail)
end if
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

type dw_1 from datawindow within w_al301_solicitud_salida
integer y = 1544
integer width = 3383
integer height = 448
integer taborder = 60
string title = "none"
string dataobject = "d_sel_saldos_articulo_x_almacen"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_al301_solicitud_salida
integer x = 1522
integer y = 24
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_ori.text, sle_nro.text)
end event

type sle_nro from singlelineedit within w_al301_solicitud_salida
integer x = 928
integer y = 32
integer width = 512
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type st_2 from statictext within w_al301_solicitud_salida
integer x = 645
integer y = 48
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

type sle_ori from singlelineedit within w_al301_solicitud_salida
integer x = 361
integer y = 32
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_al301_solicitud_salida
integer x = 82
integer y = 40
integer width = 261
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
string text = "Origen:"
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_al301_solicitud_salida
integer y = 724
integer width = 3826
integer height = 812
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_solicitud_salidad_det"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
idw_mst = dw_master
idw_det = dw_detail

end event

event itemchanged;call super::itemchanged;String 		ls_tipo_mov,ls_cod_art,ls_almacen, as_codart, ls_null, ls_estado, &
				ls_rep, ls_column, ls_desc_art, ls_und, ls_cencos, ls_cnta_prsp, &
				ls_mensaje
Decimal{4} 	ln_saldo = 0, ln_cant, ld_cant_proyectada, ld_sldo_total, ld_ppto, &
				ldc_precio, ld_saldo_act, ldc_importe
Long 			ll_count, ll_null
Date 			ad_fecha, ld_fecha, ldt_fec_proyect
Long 			ll_ano, ll_mes

dw_master.Accepttext()
dw_detail.Accepttext()

SetNull(ls_null)
SetNull(ll_null)

ls_column = lower(string(dwo.name))

ls_almacen = dw_master.object.almacen[dw_master.getrow()]
ls_cod_art = this.object.cod_art[row]

if isnull(ls_almacen) or trim(ls_almacen) = '' then
	messagebox('Almacenes', 'Debe seleccionar un almacen')
	return
end if

CHOOSE CASE ls_column
	CASE 'cod_art'
		this.object.cant_proyect[row] = 0
		if f_articulo_inventariable( data ) <> 1 then 
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null		
			return 1
		end if
		// Verifica que codigo ingresado exista			
		Select desc_art, und, NVL( flag_reposicion, '0') 
			into :ls_desc_art, :ls_und, :ls_rep 
		from articulo 
   	Where cod_Art = :data
		  and flag_estado = '1';
		  
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'El codigo de articulo no existe o no esta activo')
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null		
			return 1
		end if
		
		// Verifica que articulo solo sea de reposicion		
		if ls_rep = '0' then
			MESSAGEBOX( 'Atencion', 'Articulo no es de reposicion')
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null		
			this.object.cant_proyect[row] = 0
			return 1
		end if
		this.object.desc_Art	[row] = ls_desc_art
		this.object.und		[row] = ls_und	
		
		dw_1.retrieve( data )

	CASE 'cencos' 
		// Verifica que codigo exista
		
		if is_flag_cnta_prsp = '1' then
			Select cc.flag_estado 
				into :ls_estado 
			from centros_costo cc,
				  presup_usr_autorizdos p
			where p.cencos = cc.cencos
			  and p.cod_usr = :gs_user
			  and cc.cencos = :data;		
		else
			Select flag_estado 
				into :ls_estado 
			from centros_costo 
			where cencos = :data;		
		end if
		
		if SQLCA.SQLCode = 100 then
			if is_flag_cnta_prsp = '1' then
				Messagebox( "Error", "Centro de costo no existe, o no esta autorizado")
			else
				Messagebox( "Error", "Centro de costo no existe")
			end if
			this.object.cencos			[row] = ls_null
			this.object.cant_proyect	[row] = 0
			return 1
		end if

   	if ls_estado <> '1' then
			Messagebox( "Error", "Centro de costo esta desactivado", Exclamation!)		
			this.object.cencos			[row] = ls_null
			this.object.cant_proyect	[row] = 0
			return 1
		end if
		
	CASE "cnta_prsp" 
		//Verifica que exista dato ingresado	
		Select count( cnta_prsp) 
			into :ll_count 
		from presupuesto_cuenta 
		where cnta_prsp = :data;	
		
		if ll_count = 0 then
			Messagebox( "Error", "Cuenta no existe", Exclamation!)		
			this.object.cnta_prsp		[row] = ls_null
			this.object.cant_proyect	[row] = 0
			Return 1
		end if
		
	CASE 'cant_proyect'
		
		ld_cant_proyectada 	= this.object.cant_proyect[row]
		ldt_fec_proyect 		= date(this.object.fec_proyect[row])
		
		if isnull(ldt_fec_proyect) then
			messagebox('Almacenes', 'Debe ingresar primero la fecha')
			this.object.cant_proyect[row] = 0
			return 1
		end if
		
	   select distinct aa.sldo_total
      	into :ld_sldo_total
	   from articulo_almacen aa 
   	where trim(aa.almacen) = trim(:ls_almacen)
        and trim(aa.cod_art) = trim(:ls_cod_art);
		
		if SQLCA.SQLCode = 100 then ld_sldo_total = 0
		
		if ld_cant_proyectada > ld_sldo_total then
			messagebox('Almacenes', 'El saldo para el articulo ' &
				+ trim(this.object.desc_art[row]) + ' es sólo de ' &
				+ string (ld_sldo_total))
				
			this.object.cant_proyect[row] = ld_sldo_total
			ld_cant_proyectada = ld_sldo_total
		end if
		
END CHOOSE

// Evalua presupuesto.	
ls_cod_art = this.object.cod_art[row]
if IsNull(ls_cod_art) then return 

select costo_prom_dol
	into :ldc_precio
from articulo_almacen
where cod_art = :ls_cod_art
 and almacen = :ls_almacen;

if IsNull(ldc_precio) then ldc_precio = 0
ldc_importe = ldc_precio * Dec(this.object.cant_proyect[row])

if IsNull(ldc_importe)  or ldc_importe = 0 then return

ls_cencos = trim(this.object.cencos[row])
If IsNull(ls_cencos) then ls_cencos = ''

ls_cnta_prsp = trim(this.object.cnta_prsp[row])
If IsNull(ls_cnta_prsp) then ls_cnta_prsp = ''

ll_mes = Month( DAte( this.object.fec_proyect[row]) )
ll_ano = Year( Date(this.object.fec_proyect [row]) )

if ls_cencos = '' or ls_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( ls_cencos, ls_cnta_prsp, ll_ano) = '1' then
	MessageBox('Aviso', 'La Partida Presupuestal no acepta movimiento de almacen')
	dw_detail.object.cnta_prsp		[row] = ls_null
	dw_detail.object.cant_proyect	[row] = ll_null		
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
end if
	
IF f_afecta_presup(ll_mes, ll_ano, ls_cencos, ls_cnta_prsp, ldc_importe) = 0 THEN
	dw_detail.object.cnta_prsp		[row] = ls_null
	dw_detail.object.cant_proyect	[row] = ll_null		
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
END IF


end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc(dw_detail)

if row > 0 then
	dw_1.retrieve(this.object.cod_art[row])
end if
end event

event ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return

this.object.flag_estado			[al_row] = '1'
this.object.fec_registro		[al_row] = DateTime(Today(), Now())
this.object.fec_proyect			[al_row] = Today()
this.object.tipo_doc				[al_row] = is_doc_ss
this.object.tipo_mov				[al_row] = is_cons_interno
this.object.cod_origen			[al_row] = gs_origen
this.object.almacen				[al_row] = dw_master.object.almacen [dw_master.GetRow()]
this.object.flag_replicacion 	[al_row] = '1'
this.object.flag_Reservado		[al_row] = '0'
this.object.flag_modificacion [al_row] = '1'
this.object.cod_usr 				[al_row] = gs_user

this.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
this.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

this.Modify("cod_art.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
this.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

// Si esta activo el flag de Presupuesto para que no eliga
// la cuenta presupuestal
if is_flag_cnta_prsp = '1' then
	this.object.cnta_prsp.protect = 1
	this.object.cnta_prsp.background.color = RGB(192,192,192)
end if
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String 	ls_name, ls_prot, ls_cod, ls_rep, ls_nro_orden, ls_almacen, ls_sql, &
			ls_return1, ls_return2, ls_return3, ls_cencos, ls_cnta_prsp, &
			ls_mensaje, ls_null, ls_cod_art
long 		ll_return, ll_mes, ll_ano, ll_null
date 		ld_fec_estimada
Integer	li_ano
decimal	ldc_precio, ldc_importe
str_parametros sl_param

if row= 0 then return

SetNull(ls_null)
SetNull(ll_null)

ls_name = dwo.name
if this.Describe( lower(dwo.name) + ".Protect") = '1' then return
dw_master.Accepttext( )


// Ayuda de busqueda para articulos
if ls_name = 'cod_art' then
	ls_nro_orden = dw_master.object.nro_orden	[dw_master.getrow()]
	ls_almacen 	 = dw_master.object.almacen	[dw_master.getrow()]
	ls_cencos 	 = dw_master.object.cencos_slc[dw_master.getrow()]
	
	if ls_almacen = '' or IsNull(ls_almacen) then
		MessageBox('Aviso', 'No ha indicado ningun almacen')
		return
	end if
	
	if ls_nro_orden = '' or IsNull(ls_nro_orden) then
		// Si no he indicado ninguna orden de Trabajo entonces debo mostrar
		// Todos los articulos de reposicion de stock que tengan saldo, y
		// se encuentren activos
		ls_sql = "select a.cod_Art as codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad, " &
				 + "a2.cnta_prsp_egreso as cuenta_prsp_egreso, " &
				 + "aa.sldo_total as saldo " &
				 + "from articulo a, " &
				 + "articulo_almacen aa, " &
				 + "articulo_sub_categ a2 " &
				 + "where aa.cod_art = a.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and a.flag_estado = '1' " &
				 + "and a.flag_Reposicion= '1' " &
				 + "and aa.sldo_total > 0 " &
				 + "and aa.almacen = '" + ls_almacen + "' " &
				 + "order by a.desc_art"
		
	else
		// Solamente me debe mostrar aquellos articulos que no han
		// sido programados en la Orden de Trabajo y que sean de 
		// reposicion de stock y que ademas esten activos
		ls_sql = "select a.cod_Art as codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad, " &
				 + "a2.cnta_prsp_egreso as cuenta_prsp_egreso, " &
				 + "aa.sldo_total as saldo " &
				 + "from articulo a, " &
				 + "articulo_almacen aa, " &
				 + "articulo_sub_categ a2, " &
				 + "articulo_mov_proy amp " &
				 + "where aa.cod_art = a.cod_art " &
				 + "and a2.cod_sub_cat = a.sub_cat_art " &
				 + "and amp.cod_art = a.cod_Art " &
				 + "and amp.almacen = aa.almacen " &
				 + "and a.flag_estado = '1' " &
				 + "and a.flag_Reposicion= '1' " &
				 + "and aa.sldo_total > 0 " &
				 + "and aa.almacen = '" + ls_almacen + "' " &
				 + "and amp.nro_doc = '" + ls_nro_orden + "' " &
				 + "and amp.tipo_doc = '" + is_doc_ot + "' " &
				 + "and amp.flag_Estado = '1' " &
				 + "and NVL(amp.cant_procesada,0) < NVL(amp.cant_proyect,0) " &
				 + "order by a.desc_art"
	end if
			 
	f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_cnta_prsp, '2')
	
	if isnull(ls_return1) or trim(ls_return1) = '' then return
	this.object.cod_art	[row] = ls_return1
	this.object.desc_art	[row] = ls_return2
	this.object.und		[row] = ls_return3
	this.object.cencos	[row] = ls_cencos
	this.object.cnta_prsp[row] = ls_cnta_prsp
	
	//Calculo la fecha estimada
	ld_fec_estimada = date(dw_master.object.fec_estimada[dw_master.getrow()])
	
	if isnull(ld_fec_estimada) then ld_fec_estimada = today()
	idw_1.object.fec_proyect	[row] = ld_fec_estimada
	idw_1.object.cant_proyect	[row] = 0
	this.ii_update = 1		// activa flag de modificado
	
	dw_1.Retrieve(ls_return1)
	
elseif ls_name = 'cnta_prsp' then
	
	ls_cencos = this.object.cencos 		[row]
	li_ano 	 = Year( Date( this.object.fec_proyect	[row] ) )
	if li_ano = 0 or IsNull(li_ano) then li_ano = Year(Today())
	
	if ls_cencos = '' or IsNull(ls_Cencos) then 
		MessageBox('Aviso', 'Debe indicar primero un centro de costo')
		return
	end if
	
	ls_sql = "select distinct pc.cnta_prsp as codigo_cuenta, " &
			 + "pc.descripcion as descripcion_cuenta " &
			 + "from presupuesto_cuenta pc, " &
			 + "presupuesto_partida pp " &
			 + "where pp.cnta_prsp = pc.cnta_prsp " &
			 + "and cencos = '"+trim(ls_cencos)+"' " &
			 + "and ano = " + string(li_ano) + " " &
			 + "and NVL(pp.flag_cmp_directa, '') <> '1' " &
			 + "and pp.flag_estado <> '0' " &
			 + "order by pc.descripcion"
			 
	f_lista(ls_sql, ls_return1, ls_return2, '2')
	
	if isnull(ls_return1) or trim(ls_return1) = '' then return

	this.object.cnta_prsp		[row] = ls_return1
	this.object.cant_proyect	[row] = 0
	this.ii_update = 1		
	
elseif ls_name = 'fec_proyect' then
	
	Datawindow ldw
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1
	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.object.cant_proyect[row] = 0
	this.ii_update = 1
	
elseif ls_name = 'cencos' then
	
	ls_cnta_prsp 	= trim(idw_1.object.cnta_prsp[row])
	li_ano 	 		= Year( Date( this.object.fec_proyect	[row] ) )
	if li_ano 		= 0 or IsNull(li_ano) then li_ano = Year(Today())
	
	if is_flag_cnta_prsp = '1' then
		ls_sql = "select distinct cc.cencos as codi_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo cc, " & 
				 + "presupuesto_partida pp, " &
				 + "PRESUP_USR_AUTORIZDOS pup " &
				 + "where pp.cencos = cc.cencos " &
				 + "and pup.cencos = cc.cencos " &
				 + "and cc.flag_estado = '1' " &
				 + "and pup.cod_usr = '" + gs_user + "' " &
				 + "and pp.ano = " + string(li_ano) &
				 + "and NVL(pp.flag_cmp_directa,'') <> '1' " &
				 + "and pp.flag_estado <> '0' " &
				 + "order by cc.desc_cencos"
	else
		ls_sql = "select distinct cc.cencos as codi_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo cc, " & 
				 + "presupuesto_partida pp " &
				 + "where pp.cencos = cc.cencos " &
				 + "and pup.cencos = cc.cencos " &
				 + "and cc.flag_estado = '1' " &
				 + "and pp.ano = " + string(li_ano) &
				 + "and NVL(pp.flag_cmp_directa,'') <> '1' " &
				 + "and pp.flag_estado <> '0' " &
				 + "order by cc.desc_cencos"
	end if

	f_lista(ls_sql, ls_return1, ls_return2, '2')
	if isnull(ls_return1) or trim(ls_return1) = '' then return
	idw_1.object.cencos			[row] = ls_return1
	idw_1.object.cant_proyect	[row] = 0
	this.ii_update = 1
	
end if

Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
this.accepttext()

// Evalua presupuesto.	
ls_cod_art = this.object.cod_art[row]
if IsNull(ls_cod_art) then return 

select costo_prom_dol
	into :ldc_precio
from articulo_almacen
where cod_art = :ls_cod_art
 and almacen = :ls_almacen;

if IsNull(ldc_precio) then ldc_precio = 0
ldc_importe = ldc_precio * Dec(this.object.cant_proyect[row])

if IsNull(ldc_importe)  or ldc_importe = 0 then return

ls_cencos = trim(this.object.cencos[row])
If IsNull(ls_cencos) then ls_cencos = ''

ls_cnta_prsp = trim(this.object.cnta_prsp[row])
If IsNull(ls_cnta_prsp) then ls_cnta_prsp = ''

ll_mes = Month( DAte( this.object.fec_proyect[row]) )
ll_ano = Year( Date(this.object.fec_proyect [row]) )

if ls_cencos = '' or ls_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( ls_cencos, ls_cnta_prsp, ll_ano) = '1' then
	MessageBox('Aviso', 'La Partida Presupuestal no acepta movimiento de almacen')
	dw_detail.object.cnta_prsp		[row] = ls_null
	dw_detail.object.cant_proyect	[row] = ll_null		
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
end if
	
IF f_afecta_presup(ll_mes, ll_ano, ls_cencos, ls_cnta_prsp, ldc_importe) = 0 THEN
	dw_detail.object.cnta_prsp		[row] = ls_null
	dw_detail.object.cant_proyect	[row] = ll_null		
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
END IF



end event

type dw_master from u_dw_abc within w_al301_solicitud_salida
integer x = 9
integer y = 140
integer width = 3803
integer height = 576
integer taborder = 40
string dataobject = "d_abc_solicitud_salida_ff"
end type

event constructor;call super::constructor;is_mastdet = 'md'	
is_dwform = 'form' // tabular form

ii_ck[1] = 1				// columnas de lectura de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master
idw_det	= dw_detail

// Busca tipo de documento sol. salida
Select doc_ss into :is_doc_ss from logparam where reckey = '1';
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen  [al_row]  = gs_origen
this.object.flag_estado [al_row]  = '1'		// Activo
this.object.cod_usr     [al_row]  = gs_user
THIS.object.fec_registro[al_row]  = f_fecha_Actual()
is_action = 'new'

of_set_status_doc(dw_master)


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc(dw_master)
end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2], is_doc_ss)

end event

event doubleclicked;call super::doubleclicked;string ls_column, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5,  ls_return6,  ls_return7,  ls_return8
date ld_null

if dw_detail.rowcount() >= 1 then 
	messagebox('Almacenes', 'No se pueden cambiar los valores de la cabecera ' &
		+ '~rmientras tenga artículos en el detalle' )
	return
end if

setnull(ld_null)
if dw_master.ii_protect = 1 then return
ls_column = lower(string(dwo.name))

choose case ls_column
	case 'almacen'
		ls_sql = "select almacen as codigo_almacen, " &
				 + "desc_almacen as descripcion_almacen " &
				 + "FROM almacen " &
				 + "where cod_origen = '" + gs_origen + "' " &
				 + "and flag_estado = '1' " &
  				 + "order by almacen "
					
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		idw_1.object.almacen						[row] = ls_return1
		idw_1.object.desc_almacen				[row] = ls_return2
		
	case 'nro_orden'
		ls_sql = "select nro_orden as orden, " &
				 + "fec_sol as soliticado, " &
				 + "fec_est as estimado, " &
				 + "cencos_rsp as cencos_resp, " &
				 + "cencos_rsp_desc as desc_cencos_resp, " &
				 + "cencos_slc as cencos_solic, " &
				 + "cencos_slc_desc as desc_cencos_solic, " &
				 + "flag_estado as estado " &
				 + "from vw_al_ot_abi_plan"
				 
		f_lista_8ret(ls_sql, ls_return1, ls_return2, ls_return3, &
				ls_return4, ls_return5, ls_return6, ls_return7, &
				ls_return8, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		idw_1.object.nro_orden		[row] = ls_return1
		idw_1.object.cencos_slc		[row] = ls_return6
		idw_1.object.desc_cencos	[row] = ls_return7
		if not isnull(ls_return2) then
			idw_1.object.fec_solicitud[row] = date(mid(ls_return2,7,4) + '-' + mid(ls_return2,4,2) + '-' + mid(ls_return2,1,2))
		else
			idw_1.object.fec_solicitud[row] = ld_null
		end if
		
		if not isnull(ls_return3) then
			idw_1.object.fec_estimada[row] = date(mid(ls_return3,7,4) + '-' + mid(ls_return3,4,2) + '-' + mid(ls_return3,1,2))
		else
			idw_1.object.fec_estimada[row] = ld_null
		end if
end choose

end event

event itemchanged;call super::itemchanged;string 	ls_column, ls_almacen,ls_desc_almacen, ls_nro_orden, &
			ls_cencos_slc, ls_desc_cencos, ls_null
date ldt_fec_estimada, ldt_fec_solicitud
this.accepttext()

SetNull(ls_null)
ls_column = lower(string(dwo.name))

choose case ls_column
	case 'almacen'
		select a.desc_almacen
			into :ls_desc_almacen
		from almacen a
		where a.almacen = :data
		  and flag_estado = '1'
		  and cod_origen = :gs_origen;
		
		if sqlca.sqlcode = 100 then
			this.object.desc_almacen		[row] = ls_null
			messagebox('Almacen','Almacen no existe, no esta activo o no le corresponde al origen')
			return 1
		end if
		
		this.object.desc_almacen		[row] = ls_desc_almacen
		return 1
		
	case 'nro_orden'
		select ot.nro_orden, ot.fec_estimada, ot.fec_solicitud, ot.cencos_slc, cc.desc_cencos
			into :ls_nro_orden, :ldt_fec_estimada, :ldt_fec_solicitud, :ls_cencos_slc, :ls_desc_cencos
		from 	orden_trabajo ot,
				centros_costo cc 
		where ot.flag_estado in ('1','3')
			and ot.cencos_slc = cc.cencos
			and trim(ot.nro_orden) = :data;
			
		if sqlca.sqlcode = 100 then
			messagebox('Almacen','no existe Orden de Trabajo, o no tiene definido centro de costo solicitante')
			this.object.nro_orden		[row] = ls_null
			this.object.fec_estimada	[row] = ls_null
			this.object.fec_solicitud	[row] = ls_null
			this.object.cencos_slc		[row] = ls_null
			this.object.desc_cencos		[row] = ls_null			
		end if
		this.object.nro_orden		[row] = ls_nro_orden
		this.object.fec_estimada	[row] = ldt_fec_estimada
		this.object.fec_solicitud	[row] = ldt_fec_solicitud
		this.object.cencos_slc		[row] = ls_cencos_slc
		this.object.desc_cencos		[row] = ls_desc_cencos
		return 1
end choose
this.accepttext()
end event

