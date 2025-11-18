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
integer width = 3593
integer height = 2864
boolean titlebar = true
string title = "POP3 Email"
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
integer width = 3479
integer height = 2564
end type

type cb_cancel from commandbutton within w_main
integer x = 3182
integer y = 2624
integer width = 334
integer height = 100
integer taborder = 20
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

