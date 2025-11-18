$PBExportHeader$w_cm303_solicitud_servicio_frm.srw
forward
global type w_cm303_solicitud_servicio_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_cm303_solicitud_servicio_frm
end type
end forward

global type w_cm303_solicitud_servicio_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1712
string title = "Formato de orden de compra (CM303)"
string menuname = "m_impresion"
long backcolor = 12632256
dw_report dw_report
end type
global w_cm303_solicitud_servicio_frm w_cm303_solicitud_servicio_frm

type variables
String is_cod_origen, is_nro_os
end variables

on w_cm303_solicitud_servicio_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm303_solicitud_servicio_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;str_parametros lstr_rep

lstr_rep = message.powerobjectparm

is_cod_origen = lstr_rep.string1
is_nro_os = lstr_rep.string2

idw_1.Retrieve(is_cod_origen, is_nro_os)
idw_1.Visible = True

idw_1.Object.p_logo.filename = gs_logo
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type dw_report from u_dw_rpt within w_cm303_solicitud_servicio_frm
integer y = 4
integer width = 3273
integer height = 1016
boolean bringtotop = true
string dataobject = "d_rpt_sol_servicio"
boolean hscrollbar = true
boolean vscrollbar = true
end type

