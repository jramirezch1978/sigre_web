$PBExportHeader$w_dual.srw
forward
global type w_dual from window
end type
type dw_1 from datawindow within w_dual
end type
end forward

global type w_dual from window
integer width = 974
integer height = 460
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
end type
global w_dual w_dual

on w_dual.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_dual.destroy
destroy(this.dw_1)
end on

event resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

type dw_1 from datawindow within w_dual
integer x = 9
integer y = 4
integer width = 567
integer height = 248
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

