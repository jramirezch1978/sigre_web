$PBExportHeader$w_report_smpl.srw
$PBExportComments$Reporte simple de impresion
forward
global type w_report_smpl from w_rpt
end type
type dw_report from u_dw_rpt within w_report_smpl
end type
end forward

global type w_report_smpl from w_rpt
integer width = 1193
integer height = 1044
long backcolor = 67108864
dw_report dw_report
end type
global w_report_smpl w_report_smpl

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Visible = True

//idw_1.Retrieve(gs_empresa)
//idw_1.Object.p_logo.filename = gs_logo

//idw_1.Object.p_logo.filename = gs_logo
//idw_1.Object.empresa_t.text = gs_empresa
//idw_1.Object.usuario_t.text = gs_user
//idw_1.Object.objeto_t.text = this.ClassName( )
end event

on w_report_smpl.create
int iCurrent
call super::create
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_report_smpl.destroy
call super::destroy
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
idw_1.Visible = False
//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

//This.Event ue_retrieve()

// ii_help = 101           // help topic

//dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
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

type dw_report from u_dw_rpt within w_report_smpl
integer x = 5
integer y = 4
integer width = 960
integer height = 760
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

