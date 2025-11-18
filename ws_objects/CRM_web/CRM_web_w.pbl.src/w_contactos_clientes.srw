$PBExportHeader$w_contactos_clientes.srw
forward
global type w_contactos_clientes from window
end type
type cb_agregar from commandbutton within w_contactos_clientes
end type
type cb_cancelar from commandbutton within w_contactos_clientes
end type
type cb_guardar from commandbutton within w_contactos_clientes
end type
type st_1 from statictext within w_contactos_clientes
end type
type dw_nuevo_contacto from u_dw_abc within w_contactos_clientes
end type
end forward

global type w_contactos_clientes from window
integer width = 3269
integer height = 2128
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_agregar cb_agregar
cb_cancelar cb_cancelar
cb_guardar cb_guardar
st_1 st_1
dw_nuevo_contacto dw_nuevo_contacto
end type
global w_contactos_clientes w_contactos_clientes

on w_contactos_clientes.create
this.cb_agregar=create cb_agregar
this.cb_cancelar=create cb_cancelar
this.cb_guardar=create cb_guardar
this.st_1=create st_1
this.dw_nuevo_contacto=create dw_nuevo_contacto
this.Control[]={this.cb_agregar,&
this.cb_cancelar,&
this.cb_guardar,&
this.st_1,&
this.dw_nuevo_contacto}
end on

on w_contactos_clientes.destroy
destroy(this.cb_agregar)
destroy(this.cb_cancelar)
destroy(this.cb_guardar)
destroy(this.st_1)
destroy(this.dw_nuevo_contacto)
end on

type cb_agregar from commandbutton within w_contactos_clientes
integer x = 3017
integer y = 72
integer width = 114
integer height = 112
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "+"
end type

type cb_cancelar from commandbutton within w_contactos_clientes
integer x = 1975
integer y = 648
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "CANCELAR"
end type

type cb_guardar from commandbutton within w_contactos_clientes
integer x = 814
integer y = 648
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "GUARDAR"
end type

type st_1 from statictext within w_contactos_clientes
integer x = 178
integer y = 64
integer width = 613
integer height = 128
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "CONTACTO"
boolean focusrectangle = false
end type

type dw_nuevo_contacto from u_dw_abc within w_contactos_clientes
integer width = 3173
integer height = 816
string dataobject = "dw_abc_contactos_clientes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

