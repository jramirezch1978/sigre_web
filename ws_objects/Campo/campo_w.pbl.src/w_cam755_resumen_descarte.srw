$PBExportHeader$w_cam755_resumen_descarte.srw
forward
global type w_cam755_resumen_descarte from window
end type
type cb_1 from commandbutton within w_cam755_resumen_descarte
end type
type dw_report from datawindow within w_cam755_resumen_descarte
end type
end forward

global type w_cam755_resumen_descarte from window
integer width = 3378
integer height = 1408
boolean titlebar = true
string title = "[CAM755] Resumen de Descarte"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
dw_report dw_report
end type
global w_cam755_resumen_descarte w_cam755_resumen_descarte

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_cam755_resumen_descarte.create
this.cb_1=create cb_1
this.dw_report=create dw_report
this.Control[]={this.cb_1,&
this.dw_report}
end on

on w_cam755_resumen_descarte.destroy
destroy(this.cb_1)
destroy(this.dw_report)
end on

type cb_1 from commandbutton within w_cam755_resumen_descarte
integer x = 279
integer y = 64
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

type dw_report from datawindow within w_cam755_resumen_descarte
integer x = 87
integer y = 212
integer width = 3173
integer height = 1068
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

