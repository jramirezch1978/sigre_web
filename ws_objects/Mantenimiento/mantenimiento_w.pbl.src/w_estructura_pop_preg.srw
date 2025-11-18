$PBExportHeader$w_estructura_pop_preg.srw
forward
global type w_estructura_pop_preg from window
end type
type cb_ok from commandbutton within w_estructura_pop_preg
end type
type em_cantidad from editmask within w_estructura_pop_preg
end type
end forward

global type w_estructura_pop_preg from window
integer x = 1815
integer y = 1608
integer width = 590
integer height = 248
boolean titlebar = true
string title = "Cantidad"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
cb_ok cb_ok
em_cantidad em_cantidad
end type
global w_estructura_pop_preg w_estructura_pop_preg

on w_estructura_pop_preg.create
this.cb_ok=create cb_ok
this.em_cantidad=create em_cantidad
this.Control[]={this.cb_ok,&
this.em_cantidad}
end on

on w_estructura_pop_preg.destroy
destroy(this.cb_ok)
destroy(this.em_cantidad)
end on

type cb_ok from commandbutton within w_estructura_pop_preg
integer x = 366
integer y = 24
integer width = 192
integer height = 116
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ok"
boolean default = true
end type

event clicked;Double ldb_cantidad

ldb_cantidad = Double(em_cantidad.text)

CloseWithReturn(Parent,ldb_cantidad)
end event

type em_cantidad from editmask within w_estructura_pop_preg
integer x = 73
integer y = 32
integer width = 247
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

