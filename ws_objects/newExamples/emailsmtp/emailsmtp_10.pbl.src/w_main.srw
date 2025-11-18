$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type tab_main from u_tab_main within w_main
end type
type tab_main from u_tab_main within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 2533
integer height = 1928
boolean titlebar = true
string title = "SMTP Email"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
tab_main tab_main
cb_cancel cb_cancel
end type
global w_main w_main

on w_main.create
this.tab_main=create tab_main
this.cb_cancel=create cb_cancel
this.Control[]={this.tab_main,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.tab_main)
destroy(this.cb_cancel)
end on

type tab_main from u_tab_main within w_main
integer x = 37
integer y = 32
end type

type cb_cancel from commandbutton within w_main
integer x = 2121
integer y = 1696
integer width = 334
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

