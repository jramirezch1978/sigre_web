$PBExportHeader$w_texto.srw
forward
global type w_texto from window
end type
type mle_texto from multilineedit within w_texto
end type
type cb_cancelar from commandbutton within w_texto
end type
type cb_aceptar from commandbutton within w_texto
end type
type st_titulo from statictext within w_texto
end type
end forward

global type w_texto from window
integer width = 2647
integer height = 2124
boolean titlebar = true
string title = "Ingreso de Texto"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
mle_texto mle_texto
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_titulo st_titulo
end type
global w_texto w_texto

event ue_cancelar();Str_parametros	lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();Str_parametros	lstr_param

if trim(mle_texto.text) = '' then
	MessageBox('Aviso', 'Debe ingresar un texto, por favor verifique!', StopSign!)
	mle_texto.setFocus()
	return
end if

lstr_param.b_return 	= true
lstr_param.texto 	= trim(mle_texto.text)

CloseWithReturn(this, lstr_param)
end event

on w_texto.create
this.mle_texto=create mle_texto
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_titulo=create st_titulo
this.Control[]={this.mle_texto,&
this.cb_cancelar,&
this.cb_aceptar,&
this.st_titulo}
end on

on w_texto.destroy
destroy(this.mle_texto)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_titulo)
end on

event open;str_parametros lstr_param

If not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
	lstr_param = Message.PowerObjectParm
	
	st_titulo.text = lstr_param.titulo
	this.title 		= lstr_param.titulo
	mle_texto.text = lstr_param.texto
	
	if lstr_param.DisplayOnly then
		mle_texto.DisplayOnly = true
	end if
	

end if
end event

type mle_texto from multilineedit within w_texto
integer y = 108
integer width = 2629
integer height = 1752
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean hscrollbar = true
boolean vscrollbar = true
integer limit = 1000
borderstyle borderstyle = stylelowered!
boolean ignoredefaultbutton = true
end type

type cb_cancelar from commandbutton within w_texto
integer x = 1353
integer y = 1880
integer width = 882
integer height = 132
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()

end event

type cb_aceptar from commandbutton within w_texto
integer x = 462
integer y = 1880
integer width = 882
integer height = 132
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.dynamic event ue_aceptar()
end event

type st_titulo from statictext within w_texto
integer width = 2629
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

