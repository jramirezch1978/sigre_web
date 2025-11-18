$PBExportHeader$w_abc_list_new.srw
forward
global type w_abc_list_new from w_abc_list
end type
type uo_h from cls_vuo_head within w_abc_list_new
end type
type st_box from statictext within w_abc_list_new
end type
type phl_logonps from picturehyperlink within w_abc_list_new
end type
type p_mundi from picture within w_abc_list_new
end type
type p_logo from picture within w_abc_list_new
end type
type st_filter from statictext within w_abc_list_new
end type
type uo_filter from cls_vuo_filter within w_abc_list_new
end type
end forward

global type w_abc_list_new from w_abc_list
integer width = 2857
integer height = 2148
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = fadeanimation!
event ue_set_access ( )
event ue_close_pre ( )
event ue_update_request ( )
event ue_update_pre ( )
event ue_update ( )
event ue_sort ( )
event ue_set_access_cb ( )
event ue_retrieve_list ( )
event ue_retrieve_dddw ( )
event ue_list_open ( )
event ue_anular ( )
event ue_cancelar ( )
event ue_delete ( )
event ue_delete_list ( )
event ue_delete_pos ( long al_row )
event ue_insert_pre ( )
event ue_open_pos ( )
event ue_open_pre ( )
event ue_dw_share ( )
event ue_filter ( )
event ue_insert ( )
event ue_query_retrieve ( )
uo_h uo_h
st_box st_box
phl_logonps phl_logonps
p_mundi p_mundi
p_logo p_logo
st_filter st_filter
uo_filter uo_filter
end type
global w_abc_list_new w_abc_list_new

type variables
u_dw_abc  		idw_1, idw_n
datawindow		idw_query
Integer			ii_pregunta_delete = 0
Integer     	ii_consulta = 0, ii_access = 0
Boolean     	ib_update_check = TRUE, ib_insert_check


end variables

forward prototypes
public subroutine of_close_sheet ()
end prototypes

event ue_set_access();Datastore	lds_nc
Long			ll_total
Integer		li_x, li_y, li_opcion, li_niveles, li_c[6]
String		ls_temp, ls_c, ls_niveles, ls_mensaje

IF ii_access = 1 THEN RETURN

IF NOT IsValid(THIS.MenuID) THEN
	ls_mensaje = '[' + this.ClassName() + ']: Esta Ventana no tiene Menu'
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	RETURN
END IF

lds_nc = CREATE Datastore
lds_nc.DataObject = 'd_nivel_cord'
lds_nc.SetTransObject(SQLCA)
ll_total = lds_nc.Retrieve(gnvo_app.is_sistema)

IF ll_total < 7 THEN
	ls_mensaje = 'Faltan las Coordenadas de los Niveles, Nro Registros: ' + string(ll_total)
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	RETURN
END IF

//Validar que INSERTAR sea la posición 1
IF Upper(Mid(lds_nc.GetItemString(1, 'opcion'),1,3)) <> 'INS' THEN 
	ls_mensaje = 'INSERTAR tiene que ser la opción 1'
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

//Validar que ELIMINAR sea la posición 2
IF Upper(Mid(lds_nc.GetItemString(2, 'opcion'),1,3)) <> 'ELI' THEN 
	ls_mensaje = 'ELIMINAR tiene que ser la opción 2'
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

//Validar que MODIFICAR sea la posición 3
IF Upper(Mid(lds_nc.GetItemString(3, 'opcion'),1,3)) <> 'MOD' THEN 
	ls_mensaje = 'MODIFICAR tiene que ser la opción 3'
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

//Validar que CONSULTAR sea la posición 4
IF Upper(Mid(lds_nc.GetItemString(4, 'opcion'),1,3)) <> 'CON' THEN 
	ls_mensaje = 'CONSULTAR tiene que ser la opción 4, la opcion actual es: ' &
				  + Upper(Mid(lds_nc.GetItemString(4, 'opcion'),1,3))
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

//Validar que DUPLICAR sea la posición 5
IF Upper(Mid(lds_nc.GetItemString(5, 'opcion'),1,3)) <> 'DUP' THEN 
	ls_mensaje = 'DUPLICAR tiene que ser la opción 5, la opción actual es: ' &
				  + Upper(Mid(lds_nc.GetItemString(5, 'opcion'),1,3))
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

//Validar que ANULAR sea la posición 6
IF Upper(Mid(lds_nc.GetItemString(6, 'opcion'),1,3)) <> 'ANU' THEN 
	ls_mensaje = 'ANULAR tiene que ser la opción 6'
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

//Validar que CANCELAR sea la posición 7
IF Upper(Mid(lds_nc.GetItemString(7, 'opcion'),1,3)) <> 'CAN' THEN 
	ls_mensaje = 'CANCELAR tiene que ser la opción 7'
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return
end if

ls_niveles = is_niveles

//'IEMCGPANR'

FOR li_x = 1 to Len(is_niveles)
	ls_temp = Mid(is_niveles, li_x, 1)
	CHOOSE CASE ls_temp
		CASE 'I'
			li_opcion = 1
			IF ll_total >= 5 THEN is_niveles = is_niveles + 'D' // Incluir Duplicacion // IF Provisional
		CASE 'E'
			li_opcion = 2
		CASE 'M'
			li_opcion = 3
		CASE 'C'
			IF ii_consulta = 0 THEN CONTINUE
			li_opcion = 4
		CASE 'D'
			li_opcion = 5
		CASE 'A'
			li_opcion = 6
		CASE 'N'
			li_opcion = 7	
		CASE 'G', 'R'
			li_opcion = 8
		CASE ELSE
			gnvo_log.of_warninglog("El Nivel '" + ls_temp + " no ha sido configurado todavía")
			
	END CHOOSE
	// Habilitar opcion en el Menu y Toolbar
	li_niveles = lds_nc.GetItemNumber(li_opcion, 'niveles')
	IF li_niveles < 1 THEN gnvo_app.of_showmessagedialog('El nro de Niveles esta errado')
	FOR li_y = 1 TO li_niveles
		if gnvo_app.ib_new_struct then
			ls_c = 'n'+ String(li_y)
		else
			ls_c = 'C'+ String(li_y)
		end if
		
		li_c[li_y] =  lds_nc.GetItemNumber(li_opcion, ls_c)
	NEXT
	CHOOSE CASE li_niveles
		CASE 1
			THIS.MenuID.item[li_c[1]].enabled = TRUE
		CASE 2
			THIS.MenuID.item[li_c[1]].item[li_c[2]].enabled = TRUE
		CASE 3
			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].enabled = TRUE
		CASE 4
			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].enabled = TRUE
		CASE 5
			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].item[li_c[5]].enabled = TRUE
		CASE 6
			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].item[li_c[5]].item[li_c[6]].enabled = TRUE
		CASE ELSE
			MessageBox('Error', 'No hay tantos Niveles')
	END CHOOSE
NEXT


end event

event ue_close_pre();//close(w_abc_mastdet_pop)
this.of_logout_objeto( )
end event

event ue_update_request();//Integer li_msg_result
//
//// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
//IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
//	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
//	IF li_msg_result = 1 THEN
// 		this.TriggerEvent("ue_update")
//	ELSE
//		dw_master.ii_update = 0
//		dw_detail.ii_update = 0
//	END IF
//END IF
//
end event

event ue_update_pre();//Long 		ll_x, ll_row[]
//
//of_get_row_update(dw_master, ll_row[])
//
//For ll_x = 1 TO UpperBound(ll_row)
//	Validar registro ll_x
//	IF ERROR THEN
//		MessageBox(  )
//		ib_update_check = False
//	END IF
//NEXT


//dw_master.of_set_flag_replicacion()

end event

event ue_update();//Boolean lbo_ok = TRUE
//
//dw_master.AcceptText()
//dw_detail.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN RETURN
//
//IF dw_detail.ii_update = 1 THEN
//	IF dw_detail.Update() = -1 then		// Grabacion del detalle
//		lbo_ok = FALSE
//    Rollback ;
//		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
//	END IF
//END IF
//
//IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_master.Update() = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//    Rollback ;
//		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
//	END IF
//END IF
//
//IF lbo_ok THEN
//	COMMIT using SQLCA;
//	dw_master.ii_update = 0
//	dw_detail.ii_update = 0
//END IF

end event

event ue_sort();IF idw_1.is_dwform = 'tabular' THEN idw_1.Event ue_sort()


end event

event ue_set_access_cb();IF ii_access = 0 THEN RETURN

//cb_insertar.enabled = FALSE
//cb_eliminar.enabled = FALSE
//cb_modificar.enabled = FALSE
//cb_buscar.enabled = FALSE

//Integer	li_x
//String	ls_temp
//
//FOR li_x = 1 to Len(is_niveles)
//	ls_temp = Mid(is_niveles, li_x, 1)
//	CHOOSE CASE ls_temp
//		CASE 'I'
//			cb_insertar.enabled = TRUE
//		CASE 'E'
//			cb_eliminar.enabled = TRUE
//		CASE 'M'
//			cb_modificar.enabled = TRUE
//		CASE 'C'
//			cb_buscar.enabled = TRUE
//	END CHOOSE
//NEXT

end event

event ue_retrieve_list();//IF ii_list = 0 THEN
//	ii_list = 1
//	THIS.Event ue_update_request()
//	THIS.Event ue_list_open()
//ELSE
//	ii_list = 0
//	THIS.Event ue_list_close()	
//END IF
//
//THIS.Event ue_retrieve_list_pos()
end event

event ue_retrieve_dddw();//DataWindowChild	dwc_dddw	

//tab_master.tabpage_data1.dw_data1.GetChild ("state", dwc_dddw)
//dwc_dddw.SetTransObject (sqlca)
//dwc_dddw.Retrieve ()

end event

event ue_list_open();//Open(w_master_pop,THIS)
end event

event ue_anular();//idw_1.Event ue_anular()

end event

event ue_cancelar();//idw_1.Event ue_cancelar()

end event

event ue_delete();Long  ll_row

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

end event

event ue_delete_list();// w_treeview_pop.Event ue_delete_item

end event

event ue_insert_pre();//if idw_1 = dw_master then 		
//	// Verifica tipo de cambio
//	id_fecha_proc = f_fecha_actual()
//	in_tipo_cambio = f_get_tipo_cambio(Date(id_fecha_proc))
//	
//	if in_tipo_cambio = 0 THEN return
//	dw_master.reset()
//	dw_detail.reset()
//	
//	is_action = 'new'
//else
//	IF dw_master.getrow() = 0 then return
//	if rb_programa.checked = true or rb_ot.checked = true then
//		return
//	end if
//end if
end event

event ue_open_pre();THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton      						// crear menu de boton derecho del mouse

uo_h.of_set_sistema( gnvo_app.invo_Sistema.is_SIGLAS)
p_logo.picturename = gnvo_app.is_logo

//im_1.m_cortar.visible = false

//dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
//dw_detail.SetTransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

//idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
//dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

//dw_master.of_protect()         		// bloquear modificaciones 
//dw_detail.of_protect()

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
//ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
//ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones
end event

event ue_dw_share();//dw_lista.of_share_lista(dw_master)
//dw_lista.Retrieve()

//Integer li_share_status
//
//li_share_status = dw_master.ShareData (tab_1.tabpage_1.dw_1)
//IF li_share_status <> 1 THEN
//	messagebox("Error en Sharedata","Error al compartir con DW1",exclamation!)
//	RETURN
//END IF

end event

event ue_filter();IF idw_1.is_dwform = 'tabular' THEN	idw_1.Event ue_filter()


end event

event ue_insert();//Long  ll_row
//
//IF idw_1 = dw_detail AND dw_master.getRow() = 0 THEN
//	MessageBox("Error", "No ha existe registro Maestro")
//	RETURN
//END IF
//
//ib_insert_check = true
//this.event ue_insert_pre( )
//if not ib_insert_check then return
//
//ll_row = idw_1.Event ue_insert()
//
//IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_query_retrieve();idw_query.AcceptText()
idw_query.Object.datawindow.querymode = 'no'
idw_query.Retrieve()
end event

public subroutine of_close_sheet ();Integer	 li_x

FOR li_x = 2 to ii_x							// eliminar todas las ventanas pop
	IF IsValid(iw_sheet[li_x]) THEN close(iw_sheet[li_x])
NEXT

end subroutine

on w_abc_list_new.create
int iCurrent
call super::create
this.uo_h=create uo_h
this.st_box=create st_box
this.phl_logonps=create phl_logonps
this.p_mundi=create p_mundi
this.p_logo=create p_logo
this.st_filter=create st_filter
this.uo_filter=create uo_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_h
this.Control[iCurrent+2]=this.st_box
this.Control[iCurrent+3]=this.phl_logonps
this.Control[iCurrent+4]=this.p_mundi
this.Control[iCurrent+5]=this.p_logo
this.Control[iCurrent+6]=this.st_filter
this.Control[iCurrent+7]=this.uo_filter
end on

on w_abc_list_new.destroy
call super::destroy
destroy(this.uo_h)
destroy(this.st_box)
destroy(this.phl_logonps)
destroy(this.p_mundi)
destroy(this.p_logo)
destroy(this.st_filter)
destroy(this.uo_filter)
end on

event resize;//Ancestor Override
uo_h.width		= newwidth
uo_h.of_resize( newwidth )
st_box.height	= newheight -  st_box.y - cii_WindowBorder

phl_logonps.y = st_box.y + 10
phl_logonps.width = st_box.width - (phl_logonps.x - st_box.x) * 2
p_mundi.y = phl_logonps.y + phl_logonps.height + 10
p_mundi.width = phl_logonps.width

p_logo.x = uo_h.width - this.cii_WindowBorder - p_logo.width

p_pie.x 		= st_box.x + st_box.width
p_pie.width = newwidth - p_pie.x - this.cii_WindowBorder
p_pie.y 		= newheight - p_pie.height - this.cii_windowborder

//REdimensionar y colocar los botones de acuerdo a la nueva dimensión

pb_1.x = (newwidth - st_box.x - st_box.width) * idc_factor - pb_1.width / 2 + st_box.x + st_box.width
pb_2.x = pb_1.x

//REdimensionamos los datawindows
dw_1.height = p_pie.y - dw_1.y - this.cii_Windowborder
dw_2.height = p_pie.y - dw_2.y - this.cii_Windowborder

dw_1.width = pb_1.x - dw_1.x - this.cii_Windowborder
dw_2.x = pb_1.x + pb_1.width + this.cii_Windowborder
dw_2.width = newwidth - dw_2.x - this.cii_Windowborder
end event

event open;call super::open;IF this.of_access() THEN

	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event closequery;call super::closequery;THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

IF ib_update_check = False THEN
	ib_update_check = TRUE
	RETURN 1
END IF

Destroy	im_1

of_close_sheet()

end event

type p_pie from w_abc_list`p_pie within w_abc_list_new
integer x = 9
integer y = 1768
end type

type ole_skin from w_abc_list`ole_skin within w_abc_list_new
end type

type dw_1 from w_abc_list`dw_1 within w_abc_list_new
integer x = 494
integer y = 276
end type

event dw_1::retrieveend;call super::retrieveend;if idw_1 = this then
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(rowCount))
end if
end event

event dw_1::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
	
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end if


end event

type dw_2 from w_abc_list`dw_2 within w_abc_list_new
integer x = 1472
integer y = 276
end type

event dw_2::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
	
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end if
end event

event dw_2::retrieveend;call super::retrieveend;if idw_1 = this then
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(rowCount))
end if
end event

type pb_1 from w_abc_list`pb_1 within w_abc_list_new
integer x = 1294
integer y = 620
end type

type pb_2 from w_abc_list`pb_2 within w_abc_list_new
integer x = 1294
integer y = 868
end type

type uo_h from cls_vuo_head within w_abc_list_new
integer taborder = 10
boolean bringtotop = true
end type

on uo_h.destroy
call cls_vuo_head::destroy
end on

type st_box from statictext within w_abc_list_new
integer y = 144
integer width = 485
integer height = 2400
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217741
boolean focusrectangle = false
end type

type phl_logonps from picturehyperlink within w_abc_list_new
integer x = 18
integer y = 184
integer width = 448
integer height = 240
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\SIGRE\resources\JPG\LogoNPS.jpg"
boolean focusrectangle = false
string url = "http://www.npssac.com.pe"
end type

type p_mundi from picture within w_abc_list_new
integer x = 14
integer y = 440
integer width = 448
integer height = 704
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\JPG\MUNDI.jpg"
boolean focusrectangle = false
end type

type p_logo from picture within w_abc_list_new
integer x = 2382
integer y = 24
integer width = 462
integer height = 208
boolean bringtotop = true
boolean focusrectangle = false
end type

type st_filter from statictext within w_abc_list_new
boolean visible = false
integer x = 590
integer y = 180
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
string text = "Filtrar por :"
boolean focusrectangle = false
end type

type uo_filter from cls_vuo_filter within w_abc_list_new
boolean visible = false
integer x = 914
integer y = 156
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
end type

on uo_filter.destroy
call cls_vuo_filter::destroy
end on

