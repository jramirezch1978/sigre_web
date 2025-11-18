$PBExportHeader$w_rpt.srw
$PBExportComments$ventan base para reportes
forward
global type w_rpt from w_base
end type
type uo_h from cls_vuo_head within w_rpt
end type
type st_box from statictext within w_rpt
end type
type phl_logonps from picturehyperlink within w_rpt
end type
type p_mundi from picture within w_rpt
end type
type p_logo from picture within w_rpt
end type
end forward

global type w_rpt from w_base
integer x = 5
integer y = 4
integer width = 2688
integer height = 2112
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
uo_h uo_h
st_box st_box
phl_logonps phl_logonps
p_mundi p_mundi
p_logo p_logo
end type
global w_rpt w_rpt

type variables
u_dw_rpt idw_1
Boolean	ib_preview = False
n_cst_errorlogging invo_log


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
//idw_1.object.t_user.text = gnvo_app.is_user
end event

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
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

uo_h.of_set_sistema( gnvo_app.invo_Sistema.is_SIGLAS)
p_logo.picturename = gnvo_app.is_logo



end event

event ue_mail_send();String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, &
            ls_note, ls_path, ls_type, ls_format
Double	ldb_rc
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

ls_subject = THIS.Title
ls_path = 'c:\report.'
ls_file = 'report.'

// Consulta de formato del archivo
OpenWithParm(w_saveas_opt, THIS)
ldb_rc = Message.DoubleParm
IF ldb_rc = -1 Then 	RETURN

// Creacion del Archivo
CHOOSE CASE ldb_rc
	CASE 1
		ls_type = 'html'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, HTMLTable!, True)
	CASE 2
		ls_type = 'xls'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, Excel5!, True)
	CASE 3
		ls_type = 'pdf'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, PDF!, True)
END CHOOSE

ls_file = ls_file + ls_type
lnv_mail.of_logon()
lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
lnv_mail.of_logoff()
lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
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

public subroutine of_position (integer ai_x, integer ai_y);THIS.x = ai_x
THIS.y = ai_y
end subroutine

public subroutine of_color (long al_value);THIS.BackColor = al_value
end subroutine

on w_rpt.create
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

on w_rpt.destroy
call super::destroy
destroy(this.uo_h)
destroy(this.st_box)
destroy(this.phl_logonps)
destroy(this.p_mundi)
destroy(this.p_logo)
end on

event open;call super::open;invo_log = create n_cst_errorlogging

IF this.of_access() THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;call super::resize;//dw_report.width = newwidth - dw_report.x
//dw_report.height = newheight - dw_report.y

uo_h.width		= newwidth
uo_h.of_resize( newwidth )
st_box.height	= newheight -  st_box.y - cii_WindowBorder

phl_logonps.y = st_box.y + 10
phl_logonps.width = st_box.width - (phl_logonps.x - st_box.x) * 2
p_mundi.y = phl_logonps.y + phl_logonps.height + 10
p_mundi.width = phl_logonps.width

p_logo.x = uo_h.width - this.cii_WindowBorder - p_logo.width
end event

event close;call super::close;destroy invo_log
end event

type p_pie from w_base`p_pie within w_rpt
end type

type ole_skin from w_base`ole_skin within w_rpt
end type

type uo_h from cls_vuo_head within w_rpt
integer taborder = 10
boolean bringtotop = true
end type

on uo_h.destroy
call cls_vuo_head::destroy
end on

type st_box from statictext within w_rpt
integer y = 140
integer width = 485
integer height = 1956
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

type phl_logonps from picturehyperlink within w_rpt
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

type p_mundi from picture within w_rpt
integer x = 14
integer y = 440
integer width = 448
integer height = 704
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\JPG\MUNDI.jpg"
boolean focusrectangle = false
end type

type p_logo from picture within w_rpt
integer x = 2382
integer y = 24
integer width = 462
integer height = 208
boolean bringtotop = true
boolean focusrectangle = false
end type

