$PBExportHeader$w_cm782_listado_servicios.srw
forward
global type w_cm782_listado_servicios from w_rpt
end type
type dw_report from u_dw_rpt within w_cm782_listado_servicios
end type
end forward

global type w_cm782_listado_servicios from w_rpt
integer x = 283
integer y = 248
integer width = 3150
integer height = 1384
string title = "Compras Sugeridas  Articulos Rep Sotck[CM717]"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
dw_report dw_report
end type
global w_cm782_listado_servicios w_cm782_listado_servicios

on w_cm782_listado_servicios.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm782_listado_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1.Visible = False
idw_1 = dw_report
ii_help = 101           // help topic

idw_1.SetTransObject( SQLCA )
THIS.Event ue_preview()
This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;dw_report.Retrieve()
dw_report.Visible = True
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
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

type dw_report from u_dw_rpt within w_cm782_listado_servicios
integer width = 3063
integer height = 1068
boolean bringtotop = true
string dataobject = "d_rpt_listado_servicios_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

