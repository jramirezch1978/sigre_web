$PBExportHeader$w_imagen.srw
forward
global type w_imagen from w_abc
end type
type cb_aceptar from commandbutton within w_imagen
end type
type cb_cancelar from commandbutton within w_imagen
end type
type p_foto from picture within w_imagen
end type
end forward

global type w_imagen from w_abc
integer width = 3566
integer height = 2412
string title = "Preview de Imagen"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
p_foto p_foto
end type
global w_imagen w_imagen

type variables
str_parametros 	istr_param
end variables

on w_imagen.create
int iCurrent
call super::create
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
this.p_foto=create p_foto
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.p_foto
end on

on w_imagen.destroy
call super::destroy
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
destroy(this.p_foto)
end on

event resize;call super::resize;p_foto.width  = newwidth  - p_foto.x - 10
p_foto.height = newheight - p_foto.y - 10
end event

event ue_open_pre;call super::ue_open_pre;
if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	MessageBox('Error', 'No ha especificado parametros', StopSign!)
	post event close()	
	return
end if

istr_param = Message.PowerObjectParm

if not IsNull(istr_param.blb_datos) then
	p_foto.SetRedraw(FALSE)
	p_foto.SetPicture(istr_param.blb_datos)
	p_foto.SetRedraw(TRUE)
end if

end event

type cb_aceptar from commandbutton within w_imagen
integer width = 489
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_param

lstr_param.b_Return = true

CloseWithReturn(parent, lstr_param)
end event

type cb_cancelar from commandbutton within w_imagen
integer x = 498
integer width = 489
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.b_Return = false

CloseWithReturn(parent, lstr_param)
end event

type p_foto from picture within w_imagen
integer y = 116
integer width = 3077
integer height = 2000
boolean border = true
boolean focusrectangle = false
string powertiptext = "Imagen Previa del ARTICULO"
end type

