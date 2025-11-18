$PBExportHeader$w_rango_numeros.srw
forward
global type w_rango_numeros from w_abc
end type
type sle_max from singlelineedit within w_rango_numeros
end type
type st_2 from statictext within w_rango_numeros
end type
type st_1 from statictext within w_rango_numeros
end type
type sle_min from singlelineedit within w_rango_numeros
end type
type cb_cancelar from commandbutton within w_rango_numeros
end type
type cb_aceptar from commandbutton within w_rango_numeros
end type
type gb_1 from groupbox within w_rango_numeros
end type
end forward

global type w_rango_numeros from w_abc
integer width = 1266
integer height = 600
string title = "Rango de números"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_max sle_max
st_2 st_2
st_1 st_1
sle_min sle_min
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_rango_numeros w_rango_numeros

on w_rango_numeros.create
int iCurrent
call super::create
this.sle_max=create sle_max
this.st_2=create st_2
this.st_1=create st_1
this.sle_min=create sle_min
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_max
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_min
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_aceptar
this.Control[iCurrent+7]=this.gb_1
end on

on w_rango_numeros.destroy
call super::destroy
destroy(this.sle_max)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_min)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

sle_min.text = lstr_param.string1
sle_max.text = lstr_param.string2



end event

type sle_max from singlelineedit within w_rango_numeros
integer x = 622
integer y = 160
integer width = 590
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 18
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rango_numeros
integer x = 622
integer y = 88
integer width = 590
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Maximo"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rango_numeros
integer x = 27
integer y = 88
integer width = 590
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Minimo"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_min from singlelineedit within w_rango_numeros
integer x = 27
integer y = 160
integer width = 590
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 18
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_rango_numeros
integer x = 805
integer y = 372
integer width = 402
integer height = 112
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

event clicked;str_parametros lstr_param
lstr_param.b_return = false

closeWithREturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_rango_numeros
integer x = 398
integer y = 372
integer width = 402
integer height = 112
integer taborder = 20
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

lstr_param.string1 = sle_min.text
lstr_param.string2 = sle_max.text
lstr_param.b_return = true

closeWithREturn(parent, lstr_param)
end event

type gb_1 from groupbox within w_rango_numeros
integer width = 1243
integer height = 504
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango"
end type

