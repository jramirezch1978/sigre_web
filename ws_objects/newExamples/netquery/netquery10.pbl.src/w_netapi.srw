$PBExportHeader$w_netapi.srw
forward
global type w_netapi from window
end type
type tab_1 from u_tab_main within w_netapi
end type
type tab_1 from u_tab_main within w_netapi
end type
type cb_close from commandbutton within w_netapi
end type
end forward

global type w_netapi from window
integer x = 1189
integer y = 556
integer width = 2898
integer height = 1576
boolean titlebar = true
string title = "NetAPI Example App"
boolean controlmenu = true
long backcolor = 79416533
tab_1 tab_1
cb_close cb_close
end type
global w_netapi w_netapi

type variables
n_netapi in_netapi
end variables

on w_netapi.create
this.tab_1=create tab_1
this.cb_close=create cb_close
this.Control[]={this.tab_1,&
this.cb_close}
end on

on w_netapi.destroy
destroy(this.tab_1)
destroy(this.cb_close)
end on

type tab_1 from u_tab_main within w_netapi
integer x = 37
integer y = 32
end type

type cb_close from commandbutton within w_netapi
integer x = 2523
integer y = 1344
integer width = 297
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

