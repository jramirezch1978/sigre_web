$PBExportHeader$w_ope302_orden_trabajo_rpt_pto.srw
forward
global type w_ope302_orden_trabajo_rpt_pto from w_rpt
end type
type dw_report from u_dw_rpt within w_ope302_orden_trabajo_rpt_pto
end type
end forward

global type w_ope302_orden_trabajo_rpt_pto from w_rpt
integer width = 2903
integer height = 1760
string title = "Reporte de Presupuesto x Articulos de OT"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
dw_report dw_report
end type
global w_ope302_orden_trabajo_rpt_pto w_ope302_orden_trabajo_rpt_pto

on w_ope302_orden_trabajo_rpt_pto.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ope302_orden_trabajo_rpt_pto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)


ib_preview = FALSE
idw_1.ii_zoom_actual = 90
THIS.Event ue_preview()




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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from u_dw_rpt within w_ope302_orden_trabajo_rpt_pto
integer x = 9
integer y = 4
integer width = 2853
integer height = 1564
string dataobject = "d_rpt_pto_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

