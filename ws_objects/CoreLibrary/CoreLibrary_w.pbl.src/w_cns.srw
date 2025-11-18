$PBExportHeader$w_cns.srw
$PBExportComments$Ventana base para crear consultas
forward
global type w_cns from w_base
end type
end forward

global type w_cns from w_base
integer x = 823
integer y = 360
integer width = 1760
integer height = 1560
string title = ""
long backcolor = 79741120
event ue_close_pre ( )
event ue_dw_share ( )
event ue_filter ( )
event ue_open_pre ( )
event ue_retrieve_list ( )
event ue_retrieve_list_pos ( )
event ue_scrollrow ( string as_value )
event ue_sort ( )
event ue_help_topic ( )
event ue_help_index ( )
event ue_mail_send ( )
event ue_print ( )
event ue_list_open ( )
event ue_list_close ( )
event ue_about ( )
event ue_set_retrieve_as_needed ( string as_parametro )
event ue_filter_avanzado ( )
event ue_saveas_excel ( )
end type
global w_cns w_cns

type variables
u_dw_cns   idw_1

end variables

forward prototypes
public subroutine of_position_window (integer ai_x, integer ai_y)
public subroutine of_color (long al_value)
public function integer of_get_sheet_count ()
public subroutine of_close_sheet ()
public function integer of_new_list (str_list_pop astr_1)
end prototypes

event ue_close_pre;//close(w_abc_mastdet_pop)
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

event ue_filter;IF idw_1.is_dwform = 'tabular' or idw_1.is_dwform = 'grid' THEN
	idw_1.Event ue_filter()
END IF

end event

event ue_open_pre;iw_sheet[1] = THIS

//dw_master.SetTransObject(sqlca)
//dw_detail.SetTransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

//idw_1 = dw_master              // asignar dw corriente
//dw_detail.BorderStyle = StyleRaised! // indicar dw_detail como no activado

// ii_help = 101           // help topic
//of_position_window(0,0)        // Posicionar la ventana en forma fija
end event

event ue_retrieve_list;IF ii_list = 0 THEN
	ii_list = 1
	THIS.Event ue_list_open()
ELSE
	ii_list = 0
	THIS.Event ue_list_close()	
END IF

THIS.Event ue_retrieve_list_pos()
end event

event ue_scrollrow;//Long ll_rc
//
//ll_rc = dw_master.of_ScrollRow(as_value)
//
//RETURN ll_rc
end event

event ue_sort;IF idw_1.is_dwform = 'tabular' THEN	idw_1.Event ue_sort()


end event

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
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

event ue_print();idw_1.EVENT ue_print()
end event

event ue_list_open;//Open(w_master_pop,THIS)
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

event ue_filter_avanzado();idw_1.EVENT ue_filter_avanzado()
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

public subroutine of_position_window (integer ai_x, integer ai_y);THIS.x = ai_x
THIS.y = ai_y
end subroutine

public subroutine of_color (long al_value);THIS.BackColor = al_value
end subroutine

public function integer of_get_sheet_count ();integer	li_count=0
window	lw_sheet

// Return number of open sheets
lw_sheet = this.GetFirstSheet ()
if IsValid (lw_sheet) then
	do
		li_count += 1
		lw_sheet  = this.GetNextSheet (lw_sheet)
	loop while IsValid (lw_sheet)
end if

return li_count

end function

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

on w_cns.create
call super::create
end on

on w_cns.destroy
call super::destroy
end on

event open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
ELSE
	CLOSE(THIS)
END IF
end event

event close;THIS.Event ue_close_pre()

of_close_sheet()

end event

event resize;//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

