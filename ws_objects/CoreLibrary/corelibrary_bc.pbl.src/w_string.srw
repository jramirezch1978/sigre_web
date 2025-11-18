$PBExportHeader$w_string.srw
forward
global type w_string from window
end type
type sle_texto from singlelineedit within w_string
end type
type cb_cancelar from commandbutton within w_string
end type
type cb_aceptar from commandbutton within w_string
end type
type st_titulo from statictext within w_string
end type
end forward

global type w_string from window
integer width = 2647
integer height = 508
boolean titlebar = true
string title = "Ingreso de Texto"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
sle_texto sle_texto
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_titulo st_titulo
end type
global w_string w_string

event ue_cancelar();Str_parametros	lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();Str_parametros	lstr_param

if trim(sle_texto.text) = '' then
	MessageBox('Aviso', 'Debe ingresar un texto, por favor verifique!', StopSign!)
	sle_texto.setFocus()
	return
end if

lstr_param.b_return 	= true
lstr_param.texto 	= trim(sle_texto.text)

CloseWithReturn(this, lstr_param)
end event

on w_string.create
this.sle_texto=create sle_texto
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_titulo=create st_titulo
this.Control[]={this.sle_texto,&
this.cb_cancelar,&
this.cb_aceptar,&
this.st_titulo}
end on

on w_string.destroy
destroy(this.sle_texto)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_titulo)
end on

event open;str_parametros lstr_param

If not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
	lstr_param = Message.PowerObjectParm
	
	st_titulo.text = lstr_param.titulo
	this.title 		= lstr_param.titulo
	sle_Texto.text = lstr_param.texto
	
	if lstr_param.DisplayOnly then
		sle_texto.DisplayOnly = true
	end if
	

end if
end event

type sle_texto from singlelineedit within w_string
integer x = 27
integer y = 108
integer width = 2578
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "texto"
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_string
integer x = 1723
integer y = 260
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

type cb_aceptar from commandbutton within w_string
integer x = 832
integer y = 260
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

type st_titulo from statictext within w_string
integer width = 2629
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Titulo :"
boolean focusrectangle = false
end type

