$PBExportHeader$w_rpt.srw
$PBExportComments$ventan base para reportes
forward
global type w_rpt from w_base
end type
end forward

global type w_rpt from w_base
integer x = 5
integer y = 4
integer width = 1851
integer height = 1160
string title = "[]"
event ue_print ( )
event type long ue_scrollrow ( string as_value )
event ue_zoom ( integer ai_zoom )
event ue_saveas ( )
event ue_retrieve ( )
event ue_help_topic ( )
event ue_help_index ( )
event ue_filter ( )
event ue_sort ( )
event ue_open_pre ( )
event ue_mail_send ( )
event ue_about ( )
event ue_preview ( )
event ue_set_retrieve_as_needed ( string as_parametro )
event ue_saveas_excel ( )
event ue_saveas_pdf ( )
event ue_filter_avanzado ( )
end type
global w_rpt w_rpt

type variables
u_dw_rpt 		idw_1
Boolean			ib_preview = False
str_parametros istr_rep


end variables

forward prototypes
public subroutine of_position (integer ai_x, integer ai_y)
public subroutine of_color (long al_value)
end prototypes

event ue_print;//idw_1.EVENT ue_print()
end event

event ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc

end event

event ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

event ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_retrieve();//idw_1.Retrieve()
//idw_1.Visible = True
//idw_1.Object.p_logo.filename = gs_logo


//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text = gs_empresa
//idw_1.object.t_user.text = gs_user
end event

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

event ue_filter;idw_1.EVENT ue_filter()
end event

event ue_sort;idw_1.EVENT ue_sort()
end event

event ue_open_pre();//idw_1 = dw_report
//idw_1.Visible = False
//idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()
//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

// ii_help = 101           // help topic


end event

event ue_mail_send();str_parametros lstr_rep

if IsNull(idw_1) or not IsValid(idw_1) then
	MessageBox('Error', 'No ha especificado el Reporte a enviar por email')
	return
end if

IF idw_1.getrow() > 0 THEN
	lstr_rep.dw_report = idw_1
	
	openWithParm (w_preview_email, lstr_rep)
	
	if Not IsNull(Message.Powerobjectparm) and IsValid(Message.PowerObjectparm) then
		if message.powerobjectparm.classname( ) = 'str_parametros' then
				lstr_rep = Message.Powerobjectparm
				
				if lstr_rep.titulo = 's' and istr_rep.b_EnvioEmail then 
					close(this)
				end if
		end if
	end if
END IF

//String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, &
//            ls_note, ls_path, ls_type, ls_format
//Double	ldb_rc
//n_cst_email	lnv_mail
//n_cst_api	lnv_api
//
//lnv_mail = CREATE n_cst_email
//lnv_api  = CREATE n_cst_api
//
//ls_subject = THIS.Title
//ls_path = 'c:\report.'
//ls_file = 'report.'
//
//// Consulta de formato del archivo
//OpenWithParm(w_saveas_opt, THIS)
//ldb_rc = Message.DoubleParm
//IF ldb_rc = -1 Then 	RETURN
//
//// Creacion del Archivo
//CHOOSE CASE ldb_rc
//	CASE 1
//		ls_type = 'html'
//		ls_path = ls_path + ls_type
//		idw_1.SaveAs(ls_path, HTMLTable!, True)
//	CASE 2
//		ls_type = 'xls'
//		ls_path = ls_path + ls_type
//		idw_1.SaveAs(ls_path, Excel5!, True)
//	CASE 3
//		ls_type = 'pdf'
//		ls_path = ls_path + ls_type
//		idw_1.SaveAs(ls_path, PDF!, True)
//END CHOOSE
//
//ls_file = ls_file + ls_type
//lnv_mail.of_logon()
//lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
//lnv_mail.of_logoff()
//lnv_api.of_file_delete(ls_path)
//
//DESTROY lnv_mail
//DESTROY lnv_api
end event

event ue_preview;//IF ib_preview THEN
//	idw_1.Modify("DataWindow.Print.Preview=No")
//	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
//	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
//	SetPointer(hourglass!)
//	ib_preview = FALSE
//ELSE
//	idw_1.Modify("DataWindow.Print.Preview=Yes")
//	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
//	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
//	SetPointer(hourglass!)
//	ib_preview = TRUE
//END IF
end event

event ue_set_retrieve_as_needed(string as_parametro);String	ls_setting

ls_setting = idw_1.Object.DataWindow.Retrieve.AsNeeded

IF Upper(as_parametro) = 'S' THEN
	idw_1.Object.DataWindow.Retrieve.AsNeeded = 'Yes'
ELSE
	IF Upper(as_parametro) = 'N' THEN
		idw_1.Object.DataWindow.Retrieve.AsNeeded = 'No'
	END IF
END IF


end event

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

event ue_saveas_pdf();string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = idw_1.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( idw_1, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

event ue_filter_avanzado();idw_1.EVENT ue_filter_avanzado()
end event

public subroutine of_position (integer ai_x, integer ai_y);THIS.x = ai_x
THIS.y = ai_y
end subroutine

public subroutine of_color (long al_value);THIS.BackColor = al_value
end subroutine

on w_rpt.create
call super::create
end on

on w_rpt.destroy
call super::destroy
end on

event open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF

end event

event resize;//dw_report.width = newwidth - dw_report.x
//dw_report.height = newheight - dw_report.y
end event

