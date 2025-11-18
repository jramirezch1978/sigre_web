$PBExportHeader$w_cam757_fairtrade.srw
forward
global type w_cam757_fairtrade from window
end type
type cb_1 from commandbutton within w_cam757_fairtrade
end type
type uo_1 from u_ingreso_rango_fechas within w_cam757_fairtrade
end type
type dw_report from datawindow within w_cam757_fairtrade
end type
end forward

global type w_cam757_fairtrade from window
integer width = 3378
integer height = 1408
boolean titlebar = true
string title = "[CAM757] Reporte de Cajas FairTrade"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
uo_1 uo_1
dw_report dw_report
end type
global w_cam757_fairtrade w_cam757_fairtrade

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_cam757_fairtrade.create
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_report=create dw_report
this.Control[]={this.cb_1,&
this.uo_1,&
this.dw_report}
end on

on w_cam757_fairtrade.destroy
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_report)
end on

type cb_1 from commandbutton within w_cam757_fairtrade
integer x = 1595
integer y = 20
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

type uo_1 from u_ingreso_rango_fechas within w_cam757_fairtrade
integer x = 105
integer y = 32
integer taborder = 40
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from datawindow within w_cam757_fairtrade
integer x = 110
integer y = 176
integer width = 3104
integer height = 1048
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

