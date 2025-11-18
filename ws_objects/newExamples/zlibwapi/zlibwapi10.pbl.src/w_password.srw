$PBExportHeader$w_password.srw
forward
global type w_password from window
end type
type sle_password from singlelineedit within w_password
end type
type st_1 from statictext within w_password
end type
type cb_ok from commandbutton within w_password
end type
type cb_cancel from commandbutton within w_password
end type
end forward

global type w_password from window
integer width = 1001
integer height = 436
boolean titlebar = true
string title = "Set Password"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_password sle_password
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_password w_password

on w_password.create
this.sle_password=create sle_password
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.Control[]={this.sle_password,&
this.st_1,&
this.cb_ok,&
this.cb_cancel}
end on

on w_password.destroy
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

type sle_password from singlelineedit within w_password
integer x = 293
integer y = 36
integer width = 626
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_password
integer x = 37
integer y = 52
integer width = 256
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_password
integer x = 37
integer y = 192
integer width = 224
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;// set password
gn_zlib.of_SetPassword(sle_password.text)

Close(parent)

end event

type cb_cancel from commandbutton within w_password
integer x = 695
integer y = 192
integer width = 224
integer height = 100
integer taborder = 30
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

