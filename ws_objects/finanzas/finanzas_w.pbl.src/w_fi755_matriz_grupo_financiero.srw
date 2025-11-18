$PBExportHeader$w_fi755_matriz_grupo_financiero.srw
forward
global type w_fi755_matriz_grupo_financiero from w_rpt
end type
type dw_report from u_dw_rpt within w_fi755_matriz_grupo_financiero
end type
end forward

global type w_fi755_matriz_grupo_financiero from w_rpt
integer width = 2629
integer height = 1356
string title = "[FI755] Matrices y Grupos Financieros"
string menuname = "m_reporte"
dw_report dw_report
end type
global w_fi755_matriz_grupo_financiero w_fi755_matriz_grupo_financiero

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
idw_1.ii_zoom_actual = 100
This.Event ue_preview()
This.Event ue_retrieve()


end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()

idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text	= gs_empresa
idw_1.Object.t_user.text		= gs_user
end event

on w_fi755_matriz_grupo_financiero.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_fi755_matriz_grupo_financiero.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

type dw_report from u_dw_rpt within w_fi755_matriz_grupo_financiero
integer width = 2546
integer height = 1144
string dataobject = "d_rpt_grupo_financiero_tbl"
end type

