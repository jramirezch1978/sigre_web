$PBExportHeader$w_fl701_pend_arribos.srw
forward
global type w_fl701_pend_arribos from w_rpt
end type
type dw_report from u_dw_rpt within w_fl701_pend_arribos
end type
type pb_recuperar from u_pb_std within w_fl701_pend_arribos
end type
end forward

global type w_fl701_pend_arribos from w_rpt
integer width = 2226
integer height = 1868
string title = "Embarcaciones Pendientes de Arribo (FL701)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
dw_report dw_report
pb_recuperar pb_recuperar
end type
global w_fl701_pend_arribos w_fl701_pend_arribos

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()


end event

on w_fl701_pend_arribos.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.dw_report=create dw_report
this.pb_recuperar=create pb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.pb_recuperar
end on

on w_fl701_pend_arribos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.pb_recuperar)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
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

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.usuario_t.text 	= gs_user
idw_1.object.p_logo.filename 	= gs_logo


end event

type dw_report from u_dw_rpt within w_fl701_pend_arribos
integer y = 172
integer width = 2167
integer height = 1464
integer taborder = 60
string dataobject = "d_rpt_arribos_pendientes_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type pb_recuperar from u_pb_std within w_fl701_pend_arribos
integer x = 1856
integer y = 24
integer width = 155
integer height = 132
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

