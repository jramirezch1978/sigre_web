$PBExportHeader$w_report_smpl.srw
$PBExportComments$Reporte simple de impresion
forward
global type w_report_smpl from w_rpt
end type
type uo_filter from cls_vuo_filter within w_report_smpl
end type
type st_filtro from statictext within w_report_smpl
end type
type dw_report from u_dw_rpt within w_report_smpl
end type
end forward

global type w_report_smpl from w_rpt
integer width = 2985
integer height = 1612
uo_filter uo_filter
st_filtro st_filtro
dw_report dw_report
end type
global w_report_smpl w_report_smpl

event resize;call super::resize;dw_report.width = newwidth - dw_report.x - this.cii_windowborder
dw_report.height = p_pie.y - dw_report.y - this.cii_windowborder

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Visible = True

uo_h.of_set_sistema( gnvo_app.is_sistema )
uo_h.of_set_title( this.Title + "   Nro Registros: " &
		+ string(idw_1.rowCount()))

if idw_1.isvaliddataobject( ) then
	uo_filter.of_set_dw( idw_1 )
	uo_filter.of_retrieve_fields( )
end if

//idw_1.Retrieve(gs_empresa)
//idw_1.Object.p_logo.filename = gs_logo
end event

on w_report_smpl.create
int iCurrent
call super::create
this.uo_filter=create uo_filter
this.st_filtro=create st_filtro
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_filter
this.Control[iCurrent+2]=this.st_filtro
this.Control[iCurrent+3]=this.dw_report
end on

on w_report_smpl.destroy
call super::destroy
destroy(this.uo_filter)
destroy(this.st_filtro)
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

event ue_saveas;call super::ue_saveas;////Overrding
//string ls_path, ls_file
//int li_rc
//
//li_rc = GetFileSaveName ( "Select File", &
//   ls_path, ls_file, "XLS", &
//   "XLS Files (*.xls),*.xls" , "C:\", 32770)
//
//IF li_rc = 1 Then
//   uf_save_dw_as_excel ( dw_report, ls_file )
//End If
// 
end event

type p_pie from w_rpt`p_pie within w_report_smpl
end type

type ole_skin from w_rpt`ole_skin within w_report_smpl
end type

type uo_h from w_rpt`uo_h within w_report_smpl
end type

type st_box from w_rpt`st_box within w_report_smpl
end type

type phl_logonps from w_rpt`phl_logonps within w_report_smpl
end type

type p_mundi from w_rpt`p_mundi within w_report_smpl
end type

type p_logo from w_rpt`p_logo within w_report_smpl
end type

type uo_filter from cls_vuo_filter within w_report_smpl
integer x = 914
integer y = 156
integer taborder = 50
end type

on uo_filter.destroy
call cls_vuo_filter::destroy
end on

type st_filtro from statictext within w_report_smpl
integer x = 590
integer y = 180
integer width = 302
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Filtrar por :"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_report_smpl
integer x = 498
integer y = 272
integer width = 1778
integer height = 1176
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;uo_h.of_set_title( parent.Title + "   Nro Registros: " &
		+ string(this.rowCount()))
end event

