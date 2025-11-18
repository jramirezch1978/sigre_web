$PBExportHeader$w_datos_sunat.srw
forward
global type w_datos_sunat from w_abc
end type
type rb_4 from radiobutton within w_datos_sunat
end type
type rb_3 from radiobutton within w_datos_sunat
end type
type rb_2 from radiobutton within w_datos_sunat
end type
type rb_1 from radiobutton within w_datos_sunat
end type
type cb_cancelar from commandbutton within w_datos_sunat
end type
type cb_aceptar from commandbutton within w_datos_sunat
end type
type gb_1 from groupbox within w_datos_sunat
end type
end forward

global type w_datos_sunat from w_abc
integer width = 1157
integer height = 828
string title = "Datos de Razon Social / SUNAT"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_datos_sunat w_datos_sunat

on w_datos_sunat.create
int iCurrent
call super::create
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_4
this.Control[iCurrent+2]=this.rb_3
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_aceptar
this.Control[iCurrent+7]=this.gb_1
end on

on w_datos_sunat.destroy
call super::destroy
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;call super::open;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

if lstr_param.string1 = '0' then
	rb_1.checked = true
elseif lstr_param.string1 = '1' then
	rb_2.checked = true
elseif lstr_param.string1 = '2' then
	rb_3.checked = true
elseif lstr_param.string1 = '3' then
	rb_4.checked = true
end if
end event

type rb_4 from radiobutton within w_datos_sunat
integer x = 46
integer y = 412
integer width = 1056
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "BUEN CONTRIBUYENTE"
end type

type rb_3 from radiobutton within w_datos_sunat
integer x = 46
integer y = 300
integer width = 1056
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AGENTE DE RETENCIÓN"
end type

type rb_2 from radiobutton within w_datos_sunat
integer x = 46
integer y = 188
integer width = 1056
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AGENTES DE PERCEPCION"
end type

type rb_1 from radiobutton within w_datos_sunat
integer x = 46
integer y = 76
integer width = 1056
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "NINGUNO"
end type

type cb_cancelar from commandbutton within w_datos_sunat
integer x = 562
integer y = 596
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

CloseWithReturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_datos_sunat
integer x = 146
integer y = 596
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

lstr_param.b_return = true

if rb_1.checked then
	lstr_param.string1 = '0'
elseif rb_2.checked then	
	lstr_param.string1 = '1'
elseif rb_3.checked then	
	lstr_param.string1 = '2'
elseif rb_4.checked then	
	lstr_param.string1 = '3'
end if

CloseWithReturn(parent, lstr_param)
end event

type gb_1 from groupbox within w_datos_sunat
integer width = 1125
integer height = 560
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Padron SUNAT"
end type

