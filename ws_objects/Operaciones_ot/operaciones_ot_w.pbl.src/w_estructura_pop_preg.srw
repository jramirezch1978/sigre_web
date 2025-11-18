$PBExportHeader$w_estructura_pop_preg.srw
forward
global type w_estructura_pop_preg from window
end type
type st_1 from statictext within w_estructura_pop_preg
end type
type cb_1 from commandbutton within w_estructura_pop_preg
end type
type cb_ok from commandbutton within w_estructura_pop_preg
end type
type em_cantidad from editmask within w_estructura_pop_preg
end type
end forward

global type w_estructura_pop_preg from window
integer x = 1815
integer y = 1608
integer width = 805
integer height = 376
boolean titlebar = true
string title = "Ratio"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
st_1 st_1
cb_1 cb_1
cb_ok cb_ok
em_cantidad em_cantidad
end type
global w_estructura_pop_preg w_estructura_pop_preg

on w_estructura_pop_preg.create
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_ok=create cb_ok
this.em_cantidad=create em_cantidad
this.Control[]={this.st_1,&
this.cb_1,&
this.cb_ok,&
this.em_cantidad}
end on

on w_estructura_pop_preg.destroy
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_ok)
destroy(this.em_cantidad)
end on

type st_1 from statictext within w_estructura_pop_preg
integer x = 91
integer y = 52
integer width = 283
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ratio"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_estructura_pop_preg
integer x = 393
integer y = 156
integer width = 297
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Double ldb_cantidad

SetNull(ldb_cantidad)

CloseWithReturn(Parent,ldb_cantidad)
end event

type cb_ok from commandbutton within w_estructura_pop_preg
integer x = 82
integer y = 156
integer width = 297
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Double ldb_cantidad

ldb_cantidad = Double(em_cantidad.text)

CloseWithReturn(Parent,ldb_cantidad)
end event

type em_cantidad from editmask within w_estructura_pop_preg
integer x = 398
integer y = 36
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
string text = "1.00"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "####.00"
end type

