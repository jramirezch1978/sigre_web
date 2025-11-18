$PBExportHeader$w_data.srw
forward
global type w_data from window
end type
type dw_1 from datawindow within w_data
end type
end forward

global type w_data from window
integer width = 974
integer height = 460
boolean titlebar = true
string title = "DataWindow"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "OleGenReg!"
dw_1 dw_1
end type
global w_data w_data

on w_data.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_data.destroy
destroy(this.dw_1)
end on

event resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

type dw_1 from datawindow within w_data
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

