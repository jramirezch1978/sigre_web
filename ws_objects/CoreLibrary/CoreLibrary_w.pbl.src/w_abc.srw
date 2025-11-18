$PBExportHeader$w_abc.srw
$PBExportComments$Ventana base para Mantenimientos tipo ABC
forward
global type w_abc from w_base
end type
end forward

global type w_abc from w_base
integer x = 823
integer y = 360
integer width = 2523
integer height = 1888
long backcolor = 79741120
boolean center = true
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
event ue_filter_avanzado ( )
event ue_aceptar ( )
event ue_saveas_excel ( )
event ue_saveas_pdf ( )
event ue_saveas ( )
end type
global w_abc w_abc

type variables
public :
u_dw_abc  	idw_1, idw_n
u_dw_cns		idw_query
Integer		ii_pregunta_delete = 0
Integer     ii_consulta = 0, ii_access = 0
Boolean     ib_update_check = TRUE
String		is_action



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
public function integer of_set_numera ()
public function integer of_get_param ()
public subroutine of_centrar ()
public function integer of_nro_item (u_dw_abc adw_1)
end prototypes

event ue_close_pre;//close(w_abc_mastdet_pop)
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

event ue_filter();
if Not IsNull(idw_1) and IsValid(idw_1) then
	IF idw_1.is_dwform = 'tabular' THEN	
		idw_1.Event ue_filter()
	end if
end if

if Not IsNull(idw_query) and IsValid(idw_query) then
	idw_query.Event ue_filter()
end if

end event

event ue_insert;//Long  ll_row
//
//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF
//
//ll_row = idw_1.Event ue_insert()
//
//IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify;//dw_master.of_protect()
//dw_detail.of_protect()
end event

event ue_open_pre;THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton      						// crear menu de boton derecho del mouse
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

event ue_sort();if Not IsNull(idw_1) and IsValid(idw_1) then
	IF idw_1.is_dwform = 'tabular' THEN	
		idw_1.Event ue_sort()
	end if
end if

if Not IsNull(idw_query) and IsValid(idw_query) then
	idw_query.Event ue_sort()
end if

end event

event ue_update();//Boolean lbo_ok = TRUE
//String	ls_msg, ls_crlf
//
//ls_crlf = char(13) + char(10)
//dw_master.AcceptText()
//dw_detail.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN RETURN
//
//IF ib_log THEN
//	dw_master.of_create_log()
//	dw_detail.of_create_log()
//END IF
//
////Open(w_log)
////lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
//
//IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		ls_msg = "Se ha procedido al rollback"
//		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
//	END IF
//END IF
//
//IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		ls_msg = "Se ha procedido al rollback"
//		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
//	END IF
//END IF
//
//IF ib_log THEN
//	IF lbo_ok THEN
//		lbo_ok = dw_master.of_save_log()
//		lbo_ok = dw_detail.of_save_log()
//	END IF
//END IF
//
//IF lbo_ok THEN
//	COMMIT using SQLCA;
//	dw_master.ii_update = 0
//	dw_detail.ii_update = 0
//	dw_master.il_totdel = 0
//	dw_detail.il_totdel = 0
//	
//	dw_master.ResetUpdate()
//	dw_detail.ResetUpdate()
//	
//	f_mensaje('Grabación realizada satisfactoriamente', '')
//END IF
//
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

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

event ue_update_pre();//
//
//ib_update_check = False
//// Verifica que campos son requeridos y tengan valores
//if f_row_Processing( dw_master, "form") <> true then return
//
//// Verifica que campos son requeridos y tengan valores
//if f_row_Processing( dw_detail, "tabular") <> true then	return
//
//if dw_detail.rowcount() = 0 then 
//	messagebox( "Atencion", "No se grabara el documento, falta detalle")
//	return
//end if
//
//if of_verifica_precio() = 0 then return	
//
//if of_verifica_fondo_oc() = 0 then return	
//
//if of_verifica_aoc() = 0 then return	
//
//ls_moneda = dw_master.object.cod_moneda [dw_master.GetRow()]
//
//for ll_i = 1 to dw_detail.RowCount()
//	dw_detail.object.cod_moneda[ll_i] = ls_moneda
//next
//
////of_set_total_oc()
//if of_set_numera() = 0 then return	
//IF	of_crea_mov_proy() = 0 then return
//
//ib_update_check = true
//
//dw_master.of_set_flag_replicacion()
//dw_detail.of_set_flag_replicacion()

//Long 		ll_x, ll_row[]
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


end event

event ue_mail_send();String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, ls_note, ls_path
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api
try
	ls_subject = THIS.Title
	ls_path = 'c:\report.html'
	ls_file = 'report.html'
	
	//lnv_mail.of_create_html(idw_1, ls_path)
	idw_1.SaveAs(ls_path, HTMLTable!, True)
	
	lnv_mail.of_logon()
	lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
	lnv_mail.of_logoff()
	lnv_api.of_file_delete(ls_path)

catch(Exception ex)
	MessageBox('Error al intentar email', 'Exception: ' + ex.getMessage())
finally
	DESTROY lnv_mail
	DESTROY lnv_api	
end try

end event

event ue_list_open;//Open(w_master_pop,THIS)
end event

event ue_set_access();Datastore		lds_nc
Long				ll_total
Integer			li_x, li_y, li_opcion, li_niveles, li_c[6]
String			ls_temp, ls_c
m_master_ancst	lnvo_menu

IF ii_access = 1 THEN RETURN

if this.WindowType = response! then return

IF NOT IsValid(THIS.MenuID) THEN
	MessageBox('Error', 'Esta Ventana no tiene Menu', StopSign!)
	RETURN
END IF

lnvo_menu = this.MenuID


//Indico cada uno de los accesos
if is_flag_insertar = '1' then
	lnvo_menu.m_file.m_basedatos.m_insertar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	lnvo_menu.m_file.m_basedatos.m_eliminar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	lnvo_menu.m_file.m_basedatos.m_modificar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_consultar = '1' then
	lnvo_menu.m_file.m_basedatos.m_abrirlista.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_abrirlista.enabled = false
end if

if is_flag_anular = '1' then
	lnvo_menu.m_file.m_basedatos.m_anular.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cancelar = '1' then
	lnvo_menu.m_file.m_basedatos.m_cancelar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_cancelar.enabled = false
end if

if is_flag_duplicar = '1' then
	lnvo_menu.m_file.m_basedatos.m_duplicar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_duplicar.enabled = false
end if

if is_flag_cerrar = '1' then
	lnvo_menu.m_file.m_basedatos.m_cerrar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_insertar = '0' and is_flag_eliminar = '0' and is_flag_modificar = '0' and &
	is_flag_anular	  = '0' and is_flag_cerrar   = '0' and is_flag_duplicar  = '0' then
	
	lnvo_menu.m_file.m_basedatos.m_grabar.enabled = false
else
	lnvo_menu.m_file.m_basedatos.m_grabar.enabled = true
	
end if


//lds_nc = CREATE Datastore
//lds_nc.DataObject = 'd_nivel_cord'
//lds_nc.SetTransObject(SQLCA)
//ll_total = lds_nc.Retrieve(gs_sistema)
//
//IF ll_total < 4 THEN
//	MessageBox('Error Sistema Seguridad', 'Faltan las Coordenadas de los Niveles', StopSign!)
//	RETURN
//END IF
//
//IF Upper(Mid(lds_nc.GetItemString(1, 'opcion'),1,3)) <> 'INS' THEN MessageBox('Error', 'Inserar tiene que ser 1')
//IF Upper(Mid(lds_nc.GetItemString(2, 'opcion'),1,3)) <> 'ELI' THEN MessageBox('Error', 'Eliminar tiene que ser 2')
//IF Upper(Mid(lds_nc.GetItemString(3, 'opcion'),1,3)) <> 'MOD' THEN MessageBox('Error', 'Modificar tiene que ser 3')
//IF Upper(Mid(lds_nc.GetItemString(4, 'opcion'),1,3)) <> 'CON' THEN MessageBox('Error', 'Consultar tiene que ser 4')
//
//IF ll_total >= 5 THEN // IF Provisional
//	IF Upper(Mid(lds_nc.GetItemString(5, 'opcion'),1,3)) <> 'DUP' THEN MessageBox('Error', 'Duplicar tiene que ser 5')
//	IF Upper(Mid(lds_nc.GetItemString(6, 'opcion'),1,3)) <> 'ANU' THEN MessageBox('Error', 'Anunar tiene que ser 6')
//	IF Upper(Mid(lds_nc.GetItemString(7, 'opcion'),1,3)) <> 'CAN' THEN MessageBox('Error', 'Cancelar tiene que ser 7')
//END IF
//
//ls_niveles = is_niveles
//
//FOR li_x = 1 to Len(is_niveles)
//	ls_temp = Mid(is_niveles, li_x, 1)
//	CHOOSE CASE ls_temp
//		CASE 'I'
//			li_opcion = 1
//			IF ll_total >= 5 THEN is_niveles = is_niveles + 'D' // Incluir Duplicacion // IF Provisional
//		CASE 'E'
//			li_opcion = 2
//		CASE 'M'
//			li_opcion = 3
//		CASE 'C'
//			IF ii_consulta = 0 THEN CONTINUE
//			li_opcion = 4
//		CASE 'D'
//			li_opcion = 5
//		CASE 'A'
//			li_opcion = 6
//		CASE 'N'
//			li_opcion = 7	
//		CASE ELSE
//			MessageBox('Error', 'Los niveles de la Ventana son Errados')
//	END CHOOSE
//	
//	// Habilitar opcion en el Menu y Toolbar
//	li_niveles = lds_nc.GetItemNumber(li_opcion, 'niveles')
//	
//	IF li_niveles < 1 THEN MessageBox('Error', 'El nro de Niveles esta errado', StopSign!)
//	FOR li_y = 1 TO li_niveles
//		ls_c = 'c'+ String(li_y)
//		li_c[li_y] =  lds_nc.GetItemNumber(li_opcion, ls_c)
//	NEXT
//	
//	CHOOSE CASE li_niveles
//		CASE 1
//			THIS.MenuID.item[li_c[1]].enabled = TRUE
//		CASE 2
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].enabled = TRUE
//		CASE 3
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].enabled = TRUE
//		CASE 4
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].enabled = TRUE
//		CASE 5
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].item[li_c[5]].enabled = TRUE
//		CASE 6
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].item[li_c[5]].item[li_c[6]].enabled = TRUE
//		CASE ELSE
//			MessageBox('Error', 'No hay tantos Niveles')
//	END CHOOSE
//NEXT


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

event ue_filter_avanzado();if Not IsNull(idw_1) and IsValid(idw_1) then
	IF idw_1.is_dwform = 'tabular' THEN	
		idw_1.Event ue_filter_avanzado()
	end if
end if

if Not IsNull(idw_query) and IsValid(idw_query) then
	idw_query.Event ue_filter_avanzado()
end if

end event

event ue_aceptar();//Este evento se ejecuta cuando se hace click en el boton aceptar
end event

event ue_saveas_excel();//string ls_path, ls_file
//int li_rc
//
//li_rc = GetFileSaveName ( "Select File", &
//   ls_path, ls_file, "XLS", &
//   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)
//
//IF li_rc = 1 Then
//   uf_save_dw_as_excel ( idw_1, ls_file )
//End If
end event

event ue_saveas_pdf;//string ls_path, ls_file
//int li_rc
//n_cst_email	lnv_email
//
//ls_file = idw_1.Object.DataWindow.Print.DocumentName
//
//li_rc = GetFileSaveName ( "Select File", &
//   ls_path, ls_file, "PDF", &
//   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)
//
//IF li_rc = 1 Then
//	lnv_email = CREATE n_cst_email
//	try
//		if not lnv_email.of_create_pdf( idw_1, ls_path) then return
//		
//		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
//		
//	catch (Exception ex)
//		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
//		
//	finally
//		Destroy lnv_email
//		
//	end try
//	
//End If
end event

event ue_saveas();//idw_1.EVENT ue_saveas()
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

public function integer of_set_numera ();// 
////Numera documento
//Long 		ll_ult_nro
//string	ls_mensaje, ls_nro
//
//if is_action = 'new' then
//
//	Select ult_nro 
//		into :ll_ult_nro 
//	from num_rrhh_permiso_vacac 
//	where cod_origen = :gs_origen;
//	
//	IF SQLCA.SQLCode = 100 then
//		ll_ult_nro = 1
//		
//		Insert into num_rrhh_permiso_vacac (cod_origen, ult_nro)
//			values( :gs_origen, 1);
//		
//		IF SQLCA.SQLCode < 0 then
//			ls_mensaje = SQLCA.SQLErrText
//			ROLLBACK;
//			MessageBox('Error al insertar registro en num_rrhh_permiso_vacac', ls_mensaje)
//			return 0
//		end if
//	end if
//	
//	//Asigna numero a cabecera
//	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
//	
//	dw_master.object.nro_permiso[dw_master.getrow()] = ls_nro
//	
//	//Incrementa contador
//	Update num_rrhh_permiso_vacac 
//		set ult_nro = :ll_ult_nro + 1 
//	 where cod_origen = :gs_origen;
//	
//	IF SQLCA.SQLCode < 0 then
//		ls_mensaje = SQLCA.SQLErrText
//		ROLLBACK;
//		MessageBox('Error al actualizar num_rrhh_permiso_vacac', ls_mensaje)
//		return 0
//	end if
//		
//else 
//	ls_nro = dw_master.object.nro_permiso[dw_master.getrow()] 
//end if
//
return 1
end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

//// busca tipos de movimiento definidos
//SELECT 	tipo_doc_prog_cmp, cencos_almacen, cnta_prsp_mat, doc_oc, cod_soles,
//			oper_ing_oc, cod_igv, doc_sc, oper_cons_interno, doc_ot,
//			NVL(FLAG_RESTRIC_COMP_OC, '0'), NVL(flag_aut_oc, '0'),
//			NVL(flag_cntrl_fondos, '0'), NVL(flag_mod_fec_oc, '0'), 
//			cod_percepcion, NVL(FLAG_CARGA_OC_PRESUP, '0')
//	INTO 	:is_doc_prog, :is_cencos_mat, :is_cnta_prsp_mat, :is_doc_oc, :is_soles,
//			:is_oper_ing_oc, :is_cod_igv, :is_doc_sc, :is_oper_cons_int, :is_doc_ot,
//			:is_FLAG_RESTRIC_COMP_OC, :is_flag_aut_oc,
//			:is_flag_cntrl_fondos, :is_flag_mod_fec_oc, :is_cod_percepcion, :is_FLAG_CARGA_OC_PRESUP
//FROM logparam 
//where reckey = '1';
//
//if sqlca.sqlcode = 100 then
//	Messagebox( "Error", "no ha definido parametros en Logparam")
//	return 0
//end if
//
//if sqlca.sqlcode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	Messagebox( "Error", ls_mensaje)
//	return 0
//end if
//
//// busca doc. prog. compras
//if ISNULL( is_doc_prog ) or TRIM( is_doc_prog ) = '' then
//	Messagebox("Error", "Defina documento prog. compras en logparam")
//	return 0
//end if
//
//if ISNULL( is_cencos_mat ) or TRIM( is_cencos_mat ) = '' then
//	Messagebox("Error", "Defina Centro de Costo de Bolsa de Compras en logparam")
//	return 0
//end if
//
//if ISNULL( is_cnta_prsp_mat ) or TRIM( is_cnta_prsp_mat ) = '' then
//	Messagebox("Error", "Defina Cuenta Presupuestal de Bolsa de Compras en logparam")
//	return 0
//end if
//
//if ISNULL( is_doc_oc ) or TRIM( is_doc_oc ) = '' then
//	Messagebox("Error", "Defina Documento de Orden de Compra en logparam")
//	return 0
//end if
//
//if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
//	Messagebox("Error", "Defina Codigo de Moneda Soles en logparam")
//	return 0
//end if
//
//if ISNULL( is_cod_igv ) or TRIM( is_cod_igv ) = '' then
//	Messagebox("Error", "Defina Codigo de IGV en logparam")
//	return 0
//end if
//
//if ISNULL( is_oper_ing_oc ) or TRIM( is_oper_ing_oc ) = '' then
//	Messagebox("Error", "Defina Operacion Ingreso x Compras (oper_ing_oc) en logparam")
//	return 0
//end if
//
//if ISNULL( is_oper_cons_int ) or TRIM( is_oper_cons_int ) = '' then
//	Messagebox("Error", "Defina Operacion Consumo Interno (oper_cons_interno) en logparam")
//	return 0
//end if
//
//if ISNULL( is_doc_sc ) or TRIM( is_doc_sc ) = '' then
//	Messagebox("Error", "Defina Documento Solicitud de Compras (is_doc_sc) en logparam")
//	return 0
//end if
//
//if ISNULL( is_doc_ot ) or TRIM( is_doc_ot ) = '' then
//	Messagebox("Error", "Defina Documento Orden de Trabajo (is_doc_ot) en logparam")
//	return 0
//end if
//
//if ISNULL( is_cod_percepcion ) or TRIM( is_cod_percepcion ) = '' then
//	Messagebox("Error", "Defina impuesto de percepción en logparam")
//	return 0
//end if
//
//// Parametros de finanzas
//SELECT 	doc_anticipo_oc
//	INTO 	:is_doc_aoc
//FROM finparam 
//where reckey = '1';
//
//if sqlca.sqlcode = 100 then
//	Messagebox( "Error", "no ha definido parametros en FINPARAM")
//	return 0
//end if
//
//if sqlca.sqlcode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	Messagebox( "Error", ls_mensaje)
//	return 0
//end if
//
//// busca doc. prog. compras
//if ISNULL( is_doc_aoc ) or TRIM( is_doc_aoc ) = '' then
//	Messagebox("Error", "Defina documento Anticipo de Compras en FinParam")
//	return 0
//end if
//
//if of_fondo_oc(gs_origen) = 0 then 
//	return 0
//end if
//


return 1
end function

public subroutine of_centrar ();long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)
end subroutine

public function integer of_nro_item (u_dw_abc adw_1);// Genera numero de item para un dw
return adw_1.of_nro_item()


end function

on w_abc.create
call super::create
end on

on w_abc.destroy
call super::destroy
end on

event open;if this.windowtype <> response! then
	IF this.of_access(gs_user, THIS.ClassName()) THEN
		THIS.EVENT ue_open_pre()
		THIS.EVENT ue_dw_share()
		THIS.EVENT ue_retrieve_dddw()
	ELSE
		CLOSE(THIS)
	END IF
else
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
end if
end event

event resize;//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
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

