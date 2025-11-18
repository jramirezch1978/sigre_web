$PBExportHeader$w_abc.srw
$PBExportComments$Ventana base para Mantenimientos tipo ABC
forward
global type w_abc from w_base
end type
type uo_h from cls_vuo_head within w_abc
end type
type st_box from statictext within w_abc
end type
type phl_logonps from picturehyperlink within w_abc
end type
type p_mundi from picture within w_abc
end type
type p_logo from picture within w_abc
end type
end forward

global type w_abc from w_base
integer x = 823
integer y = 360
integer width = 2889
integer height = 2660
event ue_close_pre ( )
event ue_delete ( )
event ue_delete_list ( )
event ue_delete_pos ( long al_row )
event ue_dw_share ( )
event ue_filter ( )
event ue_insert ( )
event ue_insert_pos ( long al_row )
event ue_modify ( )
event ue_open_pre ( )
event ue_retrieve_dddw ( )
event ue_retrieve_list ( )
event ue_retrieve_list_pos ( )
event type long ue_scrollrow ( string as_value )
event ue_sort ( )
event ue_update ( )
event ue_update_request ( )
event ue_help_topic ( )
event ue_help_index ( )
event ue_print ( )
event ue_refresh ( )
event ue_update_pre ( )
event ue_mail_send ( )
event ue_list_open ( )
event ue_list_close ( )
event ue_set_access ( )
event ue_set_access_cb ( )
event ue_open_pos ( )
event ue_popm ( integer ai_pointerx,  integer ai_pointery )
event ue_query_retrieve ( )
event ue_query_clear ( )
event ue_query_set ( )
event ue_about ( )
event ue_duplicar ( )
event ue_anular ( )
event ue_cancelar ( )
event type integer ue_get_param ( )
event ue_update_pos ( )
event type boolean ue_post_update_dw ( u_dw_abc adw_1 )
event ue_insert_pre ( )
uo_h uo_h
st_box st_box
phl_logonps phl_logonps
p_mundi p_mundi
p_logo p_logo
end type
global w_abc w_abc

type variables
u_dw_abc  		idw_1, idw_n
datawindow		idw_query
Integer			ii_pregunta_delete = 0
Integer     	ii_consulta = 0, ii_access = 0
Boolean     	ib_update_check = TRUE, ib_insert_check


end variables

forward prototypes
public function integer of_update (datawindow adw_1)
public subroutine of_color (long al_value)
public subroutine of_close_sheet ()
public function integer of_new_list (str_list_pop astr_1)
public subroutine of_set_menu_abc ()
public subroutine of_get_row_update (datawindow adw_1, ref long al_row[])
public function boolean of_validacion_null (datawindow adw_1, string as_campo)
public subroutine of_conv_und ()
public subroutine of_calendar ()
public subroutine of_copy ()
public subroutine of_cut ()
public subroutine of_paste ()
public subroutine of_calculator ()
public subroutine of_conv_hr_dc ()
public subroutine of_conv_hr_dia ()
public subroutine of_estructura ()
public subroutine of_calc_fechas ()
end prototypes

event ue_close_pre();//close(w_abc_mastdet_pop)
this.of_logout_objeto( )
end event

event ue_delete;Long  ll_row

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

event ue_delete_list;// w_treeview_pop.Event ue_delete_item

end event

event ue_dw_share;//dw_lista.of_share_lista(dw_master)
//dw_lista.Retrieve()

//Integer li_share_status
//
//li_share_status = dw_master.ShareData (tab_1.tabpage_1.dw_1)
//IF li_share_status <> 1 THEN
//	messagebox("Error en Sharedata","Error al compartir con DW1",exclamation!)
//	RETURN
//END IF

end event

event ue_filter;IF idw_1.is_dwform = 'tabular' THEN	idw_1.Event ue_filter()


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

event ue_modify;//dw_master.of_protect()
//dw_detail.of_protect()
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

event ue_retrieve_dddw;//DataWindowChild	dwc_dddw	

//tab_master.tabpage_data1.dw_data1.GetChild ("state", dwc_dddw)
//dwc_dddw.SetTransObject (sqlca)
//dwc_dddw.Retrieve ()

end event

event ue_retrieve_list;IF ii_list = 0 THEN
	ii_list = 1
	THIS.Event ue_update_request()
	THIS.Event ue_list_open()
ELSE
	ii_list = 0
	THIS.Event ue_list_close()	
END IF

THIS.Event ue_retrieve_list_pos()
end event

event ue_sort;IF idw_1.is_dwform = 'tabular' THEN idw_1.Event ue_sort()


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

event ue_update_request;//Integer li_msg_result
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

event ue_help_topic();ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index();ShowHelp(gnvo_app.is_help, Index!)
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

event ue_mail_send;String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, ls_note, ls_path
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

ls_subject = THIS.Title
ls_path = 'c:\report.html'
ls_file = 'report.html'

//lnv_mail.of_create_html(idw_1, ls_path)
idw_1.SaveAs(ls_path, HTMLTable!, True)

lnv_mail.of_logon()
lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
lnv_mail.of_logoff()
lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
end event

event ue_list_open;//Open(w_master_pop,THIS)
end event

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

event ue_set_access_cb;IF ii_access = 0 THEN RETURN

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

event ue_popm(integer ai_pointerx, integer ai_pointery);im_1.PopMenu(ai_pointerx, ai_pointery)
end event

event ue_query_retrieve;idw_query.AcceptText()
idw_query.Object.datawindow.querymode = 'no'
idw_query.Retrieve()
end event

event ue_query_clear;idw_query.Object.datawindow.queryclear = 'yes'
end event

event ue_query_set;idw_query.Object.datawindow.querymode = 'yes'
idw_query.SetFocus()

end event

event ue_duplicar();//idw_1.Event ue_duplicar()

end event

event ue_anular();//idw_1.Event ue_anular()

end event

event ue_cancelar();//idw_1.Event ue_cancelar()

end event

event type integer ue_get_param();//Este evento sirve para leer los parámetros iniciales de la ventana, si pasa un error
// retorno un valor distinto de uno

return 1
end event

event type boolean ue_post_update_dw(u_dw_abc adw_1);//Este evento se dispara por cada datawindows que se actualice correctamente
//aca se pueden colocar los procesos que se deben de disparar cuando 
//se grabe cada datawindow

return true
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

public function integer of_update (datawindow adw_1);Integer	li_rc

idw_n = adw_1

IF idw_n.Update() = -1 then
	ROLLBACK using SQLCA;
	li_rc = -1
	messagebox("Error en Grabacion","Se ha procedido al rollback",exclamation!)
ELSE
	COMMIT using SQLCA;
	idw_n.ii_update =0
	li_rc = 1
END IF
	
RETURN li_rc


end function

public subroutine of_color (long al_value);THIS.BackColor = al_value
end subroutine

public subroutine of_close_sheet ();Integer	 li_x

FOR li_x = 2 to ii_x							// eliminar todas las ventanas pop
	IF IsValid(iw_sheet[li_x]) THEN close(iw_sheet[li_x])
NEXT

end subroutine

public function integer of_new_list (str_list_pop astr_1);Integer 			li_rc
w_list_qs_pop	lw_sheet

li_rc = OpenSheetWithParm(lw_sheet, astr_1, this, 0, Original!)
ii_x ++
iw_sheet[ii_x]  = lw_sheet

RETURN li_rc     						//	Valores de Retorno: 1 = exito, -1 = error
end function

public subroutine of_set_menu_abc ();
end subroutine

public subroutine of_get_row_update (datawindow adw_1, ref long al_row[]);Long	ll_total, ll_x, ll_y
dwItemStatus	ldis_status

ll_total = adw_1.RowCount()

For ll_x = 1 TO ll_total
	ldis_status = adw_1.GetItemStatus(ll_x,0,Primary!)
	IF ldis_status = NewMOdified! or ldis_status = DataModified! THEN
		ll_y ++
		al_row[ll_y] = ll_x
	END IF
NEXT
	

end subroutine

public function boolean of_validacion_null (datawindow adw_1, string as_campo);Boolean	lb_rc = TRUE
Integer	li_ck
Long		ll_row[], ll_x
Any		la_id


li_ck = Integer(adw_1.Describe(as_campo + '.ID'))  // obtener el numero del campo dentro dw
IF li_ck < 1 THEN
	MessageBox('Error', 'Campo no existe = ' + as_campo)
	lb_rc = FALSE
	Goto salida
END IF

of_get_row_update(adw_1, ll_row[])  // recoger numero de registros a grabar
IF UpperBound(ll_row) < 1 THEN
	MessageBox('Error', 'No hay Registro que Grabar')
	lb_rc = FALSE
	Goto salida
END IF


FOR ll_x = 1 TO UpperBound(ll_row)
	la_id = adw_1.object.data.primary.current[ll_row[ll_x], li_ck]
	IF IsNull(la_id) OR la_id = '' THEN
		MessageBox('Error Campo: ' + as_campo + ' nulo', 'Registro: ' + String(ll_row[ll_x])) 
		lb_rc = False
	END IF
NEXT

salida :
RETURN lb_rc   // False = Error
end function

public subroutine of_conv_und ();str_calculos	lstr_calc
integer			li_pos, li_height, li_x, li_y
string			ls_col
window			lw_parent

SetPointer(HourGlass!)

li_height = 800

ls_col = idw_1.is_colname
li_x   = idw_1.x
li_y   = idw_1.y

lw_parent = THIS
lstr_calc.x = lw_parent.WorkSpaceX() + li_x + Integer(idw_1.Describe(ls_col + ".X")) - 2
lstr_calc.y = lw_parent.WorkSpaceY() + li_y + Integer(idw_1.Describe(ls_col + ".Y")) &
			  + Integer(idw_1.Describe(ls_col + ".Height")) + 12

//Si la ventana no cabe en el fondo colocarla arriba
if (lstr_calc.y + li_height) > (w_main.WorkSpaceY() + w_main.WorkSpaceHeight()) then
	lstr_calc.y -= (integer(idw_1.Describe(ls_col + ".height")) + li_height + 4)
end if

lstr_calc.window     = THIS
lstr_calc.datawindow = idw_1
lstr_calc.columna    = ls_col
lstr_calc.valor   	= idw_1.GetText()

OpenWithParm(w_conv_und, lstr_calc)
idw_1.SetColumn(ls_col)
end subroutine

public subroutine of_calendar ();f_call_calendar(idw_1,idw_1.is_colname,idw_1.is_coltype,idw_1.il_row)
end subroutine

public subroutine of_copy ();idw_1.copy()
end subroutine

public subroutine of_cut ();idw_1.cut()
end subroutine

public subroutine of_paste ();idw_1.paste()
end subroutine

public subroutine of_calculator ();str_calculos	lstr_c
integer			li_pos, li_height, li_x, li_y
string			ls_col
window			lw_parent

SetPointer(HourGlass!)
Clipboard('')
li_height = 800

ls_col = idw_1.is_colname
li_x   = idw_1.x
li_y   = idw_1.y

lw_parent = THIS
lstr_c.x = lw_parent.WorkSpaceX() + li_x + Integer(idw_1.Describe(ls_col + ".X")) - 2
lstr_c.y = lw_parent.WorkSpaceY() + li_y + Integer(idw_1.Describe(ls_col + ".Y")) &
			  + Integer(idw_1.Describe(ls_col + ".Height")) + 12

//Si la ventana no cabe en el fondo colocarla arriba
if (lstr_c.y + li_height) > (w_main.WorkSpaceY() + w_main.WorkSpaceHeight()) then
	lstr_c.y -= (integer(idw_1.Describe(ls_col + ".height")) + li_height + 4)
end if

lstr_c.window  	= THIS
lstr_c.datawindow	= idw_1
lstr_c.columna  	= ls_col
lstr_c.valor		= idw_1.GetText()

OpenWithParm(w_calculator, lstr_c)
idw_1.SetColumn(ls_col)
end subroutine

public subroutine of_conv_hr_dc ();str_calculos	lstr_calc
integer			li_pos, li_height, li_x, li_y
string			ls_col
window			lw_parent

SetPointer(HourGlass!)
Clipboard('')
li_height = 400

ls_col = idw_1.is_colname
li_x   = idw_1.x
li_y   = idw_1.y

lw_parent = THIS
lstr_calc.x = lw_parent.WorkSpaceX() + li_x + Integer(idw_1.Describe(ls_col + ".X")) - 2
lstr_calc.y = lw_parent.WorkSpaceY() + li_y + Integer(idw_1.Describe(ls_col + ".Y")) &
			  + Integer(idw_1.Describe(ls_col + ".Height")) + 12

//Si la ventana no cabe en el fondo colocarla arriba
if (lstr_calc.y + li_height) > (w_main.WorkSpaceY() + w_main.WorkSpaceHeight()) then
	lstr_calc.y -= (integer(idw_1.Describe(ls_col + ".height")) + li_height + 4)
end if

lstr_calc.window     = THIS
lstr_calc.datawindow = idw_1
lstr_calc.columna    = ls_col
lstr_calc.valor   	= idw_1.GetText()

OpenWithParm(w_conv_hr_dc, lstr_calc)
idw_1.SetColumn(ls_col)
end subroutine

public subroutine of_conv_hr_dia ();str_calculos	lstr_calc
integer			li_pos, li_height, li_x, li_y
string			ls_col
window			lw_parent

SetPointer(HourGlass!)
Clipboard('')
li_height = 400

ls_col = idw_1.is_colname
li_x   = idw_1.x
li_y   = idw_1.y

lw_parent = THIS
lstr_calc.x = lw_parent.WorkSpaceX() + li_x + Integer(idw_1.Describe(ls_col + ".X")) - 2
lstr_calc.y = lw_parent.WorkSpaceY() + li_y + Integer(idw_1.Describe(ls_col + ".Y")) &
			  + Integer(idw_1.Describe(ls_col + ".Height")) + 12

//Si la ventana no cabe en el fondo colocarla arriba
if (lstr_calc.y + li_height) > (w_main.WorkSpaceY() + w_main.WorkSpaceHeight()) then
	lstr_calc.y -= (integer(idw_1.Describe(ls_col + ".height")) + li_height + 4)
end if

lstr_calc.window     = THIS
lstr_calc.datawindow = idw_1
lstr_calc.columna    = ls_col
lstr_calc.valor   	= idw_1.GetText()

OpenWithParm(w_conv_hr_dia, lstr_calc)
idw_1.SetColumn(ls_col)
end subroutine

public subroutine of_estructura ();str_tv_estructura_pop	lstr_pop
integer			li_pos, li_height, li_x, li_y
string			ls_col
window			lw_parent

SetPointer(HourGlass!)
Clipboard('')
li_height = 1200

ls_col = idw_1.is_colname
li_x   = idw_1.x
li_y   = idw_1.y

lw_parent = THIS
lstr_pop.x = lw_parent.WorkSpaceX() + li_x + Integer(idw_1.Describe(ls_col + ".X")) - 2
lstr_pop.y = lw_parent.WorkSpaceY() + li_y + Integer(idw_1.Describe(ls_col + ".Y")) &
			  + Integer(idw_1.Describe(ls_col + ".Height")) + 12

//Si la ventana no cabe en el fondo colocarla arriba
if (lstr_pop.y + li_height) > (w_main.WorkSpaceY() + w_main.WorkSpaceHeight()) then
	lstr_pop.y -= (integer(idw_1.Describe(ls_col + ".height")) + li_height + 4)
end if

lstr_pop.dw = idw_1
lstr_pop.field    = ls_col

OpenWithParm(w_cns_estructura_pop, lstr_pop)
idw_1.SetColumn(ls_col)
end subroutine

public subroutine of_calc_fechas ();str_calculos	lstr_calc
integer			li_pos, li_height, li_x, li_y
string			ls_col
window			lw_parent

SetPointer(HourGlass!)

li_height = 400

ls_col = idw_1.is_colname
li_x   = idw_1.x
li_y   = idw_1.y

lw_parent = THIS
lstr_calc.x = lw_parent.WorkSpaceX() + li_x + Integer(idw_1.Describe(ls_col + ".X")) - 2
lstr_calc.y = lw_parent.WorkSpaceY() + li_y + Integer(idw_1.Describe(ls_col + ".Y")) &
			  + Integer(idw_1.Describe(ls_col + ".Height")) + 12

//Si la ventana no cabe en el fondo colocarla arriba
if (lstr_calc.y + li_height) > (w_main.WorkSpaceY() + w_main.WorkSpaceHeight()) then
	lstr_calc.y -= (integer(idw_1.Describe(ls_col + ".height")) + li_height + 4)
end if

lstr_calc.window     = THIS
lstr_calc.datawindow = idw_1
lstr_calc.columna    = ls_col
lstr_calc.valor   	= idw_1.GetText()

OpenWithParm(w_calc_fechas, lstr_calc)
idw_1.SetColumn(ls_col)
end subroutine

on w_abc.create
int iCurrent
call super::create
this.uo_h=create uo_h
this.st_box=create st_box
this.phl_logonps=create phl_logonps
this.p_mundi=create p_mundi
this.p_logo=create p_logo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_h
this.Control[iCurrent+2]=this.st_box
this.Control[iCurrent+3]=this.phl_logonps
this.Control[iCurrent+4]=this.p_mundi
this.Control[iCurrent+5]=this.p_logo
end on

on w_abc.destroy
call super::destroy
destroy(this.uo_h)
destroy(this.st_box)
destroy(this.phl_logonps)
destroy(this.p_mundi)
destroy(this.p_logo)
end on

event open;call super::open;IF this.of_access() THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;//Ancestor Override

//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10

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
end event

event closequery;THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

IF ib_update_check = False THEN
	ib_update_check = TRUE
	RETURN 1
END IF

Destroy	im_1

of_close_sheet()

end event

type p_pie from w_base`p_pie within w_abc
integer x = 0
integer y = 2280
end type

type ole_skin from w_base`ole_skin within w_abc
end type

type uo_h from cls_vuo_head within w_abc
integer taborder = 20
boolean bringtotop = true
end type

on uo_h.destroy
call cls_vuo_head::destroy
end on

type st_box from statictext within w_abc
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

type phl_logonps from picturehyperlink within w_abc
integer x = 18
integer y = 184
integer width = 448
integer height = 240
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\SIGRE\resources\logos\NPSSAC_logo.png"
boolean focusrectangle = false
string url = "http://www.npssac.com.pe"
end type

type p_mundi from picture within w_abc
integer x = 14
integer y = 440
integer width = 448
integer height = 704
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\JPG\MUNDI.jpg"
boolean focusrectangle = false
end type

type p_logo from picture within w_abc
integer x = 2382
integer y = 24
integer width = 462
integer height = 208
boolean bringtotop = true
boolean focusrectangle = false
end type

