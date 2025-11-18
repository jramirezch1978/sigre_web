$PBExportHeader$w_af_observacion.srw
forward
global type w_af_observacion from window
end type
type cb_2 from commandbutton within w_af_observacion
end type
type cb_1 from commandbutton within w_af_observacion
end type
type mle_msj from multilineedit within w_af_observacion
end type
end forward

global type w_af_observacion from window
integer width = 1714
integer height = 1056
boolean titlebar = true
string title = "Observaciones"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 10789024
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
mle_msj mle_msj
end type
global w_af_observacion w_af_observacion

type variables
string is_mensaje
end variables

on w_af_observacion.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.mle_msj=create mle_msj
this.Control[]={this.cb_2,&
this.cb_1,&
this.mle_msj}
end on

on w_af_observacion.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.mle_msj)
end on

event open;mle_msj.SetFocus()
string ls_mensaje
//asignando texto a variable
ls_mensaje = trim(message.stringparm)
//displayando texto enviado en el MLE
mle_msj.text = ls_mensaje
is_mensaje = ls_mensaje
end event

type cb_2 from commandbutton within w_af_observacion
integer x = 896
integer y = 808
integer width = 315
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;CloseWithReturn(Parent, is_mensaje)
end event

type cb_1 from commandbutton within w_af_observacion
integer x = 489
integer y = 808
integer width = 315
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;string ls_msj 
ls_msj = trim(mle_msj.text)

// Envía parámetro a la ventana que llamó
CloseWithReturn(Parent, ls_msj)
end event

type mle_msj from multilineedit within w_af_observacion
integer x = 41
integer y = 40
integer width = 1605
integer height = 712
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
textcase textcase = upper!
integer limit = 200
borderstyle borderstyle = stylelowered!
end type

