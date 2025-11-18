$PBExportHeader$w_rsp_descripcion.srw
forward
global type w_rsp_descripcion from window
end type
type cb_2 from commandbutton within w_rsp_descripcion
end type
type cb_1 from commandbutton within w_rsp_descripcion
end type
type mle_msj from multilineedit within w_rsp_descripcion
end type
end forward

global type w_rsp_descripcion from window
integer width = 1362
integer height = 944
boolean titlebar = true
string title = "Descripción"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
mle_msj mle_msj
end type
global w_rsp_descripcion w_rsp_descripcion

type variables
string is_mensaje
end variables

on w_rsp_descripcion.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.mle_msj=create mle_msj
this.Control[]={this.cb_2,&
this.cb_1,&
this.mle_msj}
end on

on w_rsp_descripcion.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.mle_msj)
end on

event open;mle_msj.SetFocus()
string ls_mensaje
////asignando texto a variable
//ls_mensaje = trim(message.stringparm)
////displayando texto enviado en el MLE
//mle_msj.text = ls_mensaje
//is_mensaje = ls_mensaje

int		li_x
li_x = x

x =(w_main.PointerX())

if WorkSpaceX ( ) > WorkSpaceWidth ( ) then
	x =li_x
end if
ls_mensaje =  message.stringparm
mle_msj.text =ls_mensaje
is_mensaje = ls_mensaje
end event

type cb_2 from commandbutton within w_rsp_descripcion
integer x = 718
integer y = 756
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

type cb_1 from commandbutton within w_rsp_descripcion
integer x = 311
integer y = 756
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

event clicked;//string ls_msj 
//ls_msj = trim(mle_msj.text)
////Mandando Parametro a la ventana que llamo
//CloseWithReturn(Parent, ls_msj)

closeWithReturn(Parent,mle_msj.text)
end event

type mle_msj from multilineedit within w_rsp_descripcion
integer x = 27
integer y = 28
integer width = 1294
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
integer limit = 400
borderstyle borderstyle = stylelowered!
end type

