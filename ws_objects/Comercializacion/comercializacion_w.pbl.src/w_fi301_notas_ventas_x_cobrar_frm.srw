$PBExportHeader$w_fi301_notas_ventas_x_cobrar_frm.srw
forward
global type w_fi301_notas_ventas_x_cobrar_frm from w_rpt
end type
type rb_impl from radiobutton within w_fi301_notas_ventas_x_cobrar_frm
end type
type rb_imp from radiobutton within w_fi301_notas_ventas_x_cobrar_frm
end type
type dw_report from u_dw_rpt within w_fi301_notas_ventas_x_cobrar_frm
end type
end forward

global type w_fi301_notas_ventas_x_cobrar_frm from w_rpt
integer width = 3369
integer height = 1872
string title = "Liquidación Semanal[FI343]"
string menuname = "m_reporte"
rb_impl rb_impl
rb_imp rb_imp
dw_report dw_report
end type
global w_fi301_notas_ventas_x_cobrar_frm w_fi301_notas_ventas_x_cobrar_frm

type variables

end variables

on w_fi301_notas_ventas_x_cobrar_frm.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_impl=create rb_impl
this.rb_imp=create rb_imp
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_impl
this.Control[iCurrent+2]=this.rb_imp
this.Control[iCurrent+3]=this.dw_report
end on

on w_fi301_notas_ventas_x_cobrar_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_impl)
destroy(this.rb_imp)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
dw_report.Settransobject(sqlca)
this.dw_report.Object.DataWindow.Print.Paper.Size = 256 
this.dw_report.Object.DataWindow.Print.CustomPage.Width = 218
this.dw_report.Object.DataWindow.Print.CustomPage.Length = 171
this.Event ue_preview()
This.Event ue_retrieve()

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

event ue_retrieve;call super::ue_retrieve;dw_report.Retrieve()
f_imp_bol_fact()
idw_1.Visible = True
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type rb_impl from radiobutton within w_fi301_notas_ventas_x_cobrar_frm
integer x = 699
integer y = 40
integer width = 562
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Externo"
end type

event clicked;dw_report.DataObject = 'd_rpt_nventas_sica_ff'
dw_report.Settransobject(sqlca)
Event ue_preview()
dw_report.Retrieve()

end event

type rb_imp from radiobutton within w_fi301_notas_ventas_x_cobrar_frm
integer x = 174
integer y = 40
integer width = 480
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Local"
boolean checked = true
end type

event clicked;dw_report.DataObject = 'd_rpt_nventas_formato_ff'
dw_report.Settransobject(sqlca)
Event ue_preview()
dw_report.Retrieve()
f_imp_bol_fact()
end event

type dw_report from u_dw_rpt within w_fi301_notas_ventas_x_cobrar_frm
integer x = 32
integer y = 136
integer width = 3241
integer height = 1456
string dataobject = "d_rpt_nventas_formato_ff"
end type

