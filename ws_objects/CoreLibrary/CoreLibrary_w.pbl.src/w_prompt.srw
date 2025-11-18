$PBExportHeader$w_prompt.srw
forward
global type w_prompt from window
end type
type cb_sql from commandbutton within w_prompt
end type
type sle_return from singlelineedit within w_prompt
end type
type st_titulo from statictext within w_prompt
end type
type p_1 from picture within w_prompt
end type
type cb_cancelar from commandbutton within w_prompt
end type
type cb_aceptar from commandbutton within w_prompt
end type
end forward

global type w_prompt from window
integer width = 3081
integer height = 408
boolean titlebar = true
string title = "Ingrese dato solicitado..."
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
cb_sql cb_sql
sle_return sle_return
st_titulo st_titulo
p_1 p_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_prompt w_prompt

type variables
string is_sql
end variables

on w_prompt.create
this.cb_sql=create cb_sql
this.sle_return=create sle_return
this.st_titulo=create st_titulo
this.p_1=create p_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.Control[]={this.cb_sql,&
this.sle_return,&
this.st_titulo,&
this.p_1,&
this.cb_cancelar,&
this.cb_aceptar}
end on

on w_prompt.destroy
destroy(this.cb_sql)
destroy(this.sle_return)
destroy(this.st_titulo)
destroy(this.p_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

event open;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

st_titulo.text = lstr_param.titulo
sle_return.text = lstr_param.string1

if trim(lstr_param.sql_text) <> '' then
	cb_sql.visible = true
	cb_sql.enabled = true
	is_sql = lstr_param.sql_text
else
	cb_sql.visible = false
	cb_sql.enabled = false
end if


end event

type cb_sql from commandbutton within w_prompt
boolean visible = false
integer x = 2487
integer y = 160
integer width = 128
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
String 	ls_codigo, ls_data

lb_ret = f_lista(is_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_return.text = ls_codigo
end if
end event

type sle_return from singlelineedit within w_prompt
integer x = 635
integer y = 160
integer width = 1842
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_titulo from statictext within w_prompt
integer x = 640
integer y = 44
integer width = 1975
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type p_1 from picture within w_prompt
integer width = 562
integer height = 304
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_prompt
integer x = 2656
integer y = 168
integer width = 402
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

lstr_param.i_return = -1

CloseWithReturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_prompt
integer x = 2656
integer y = 36
integer width = 402
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

lstr_param.string1 = trim(sle_return.text)
lstr_param.i_return = 1

CloseWithReturn(parent, lstr_param)
end event

