$PBExportHeader$w_pr717_certificados_de_calidad.srw
forward
global type w_pr717_certificados_de_calidad from w_rpt
end type
type dw_report from u_dw_rpt within w_pr717_certificados_de_calidad
end type
end forward

global type w_pr717_certificados_de_calidad from w_rpt
integer width = 2039
integer height = 1820
string title = "Certificados de Calidad(w_pr717)"
long backcolor = 67108864
dw_report dw_report
end type
global w_pr717_certificados_de_calidad w_pr717_certificados_de_calidad

on w_pr717_certificados_de_calidad.create
int iCurrent
call super::create
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_pr717_certificados_de_calidad.destroy
call super::destroy
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()

end event

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

type dw_report from u_dw_rpt within w_pr717_certificados_de_calidad
integer x = 5
integer y = 28
integer width = 1961
integer height = 1664
end type

