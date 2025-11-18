$PBExportHeader$w_choice_cierre_caja.srw
forward
global type w_choice_cierre_caja from window
end type
type rb_4 from radiobutton within w_choice_cierre_caja
end type
type rb_3 from radiobutton within w_choice_cierre_caja
end type
type rb_2 from radiobutton within w_choice_cierre_caja
end type
type rb_1 from radiobutton within w_choice_cierre_caja
end type
type cb_cancelar from commandbutton within w_choice_cierre_caja
end type
type cb_aceptar from commandbutton within w_choice_cierre_caja
end type
type st_titulo from statictext within w_choice_cierre_caja
end type
end forward

global type w_choice_cierre_caja from window
integer width = 1568
integer height = 640
boolean titlebar = true
string title = "Elija Tipo de Cierra de Caja"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_titulo st_titulo
end type
global w_choice_cierre_caja w_choice_cierre_caja

event ue_cancelar();Str_parametros	lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();Str_parametros	lstr_param

if rb_1.checked then
	lstr_param.string1 = '1'
elseif rb_2.checked then
	lstr_param.string1 = '2'
elseif rb_3.checked then
	lstr_param.string1 = '3'
elseif rb_4.checked then
	lstr_param.string1 = '4'
else
	lstr_param.string1 = '0'
end if

lstr_param.b_return 	= true

CloseWithReturn(this, lstr_param)
end event

on w_choice_cierre_caja.create
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_titulo=create st_titulo
this.Control[]={this.rb_4,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.st_titulo}
end on

on w_choice_cierre_caja.destroy
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_titulo)
end on

type rb_4 from radiobutton within w_choice_cierre_caja
integer x = 37
integer y = 444
integer width = 1006
integer height = 80
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Empresa"
end type

type rb_3 from radiobutton within w_choice_cierre_caja
integer x = 37
integer y = 336
integer width = 1006
integer height = 80
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Sucursal"
end type

type rb_2 from radiobutton within w_choice_cierre_caja
integer x = 37
integer y = 228
integer width = 1006
integer height = 80
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Usuario"
end type

type rb_1 from radiobutton within w_choice_cierre_caja
integer x = 37
integer y = 120
integer width = 1006
integer height = 80
integer textsize = -15
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Serie"
boolean checked = true
end type

type cb_cancelar from commandbutton within w_choice_cierre_caja
integer x = 1074
integer y = 240
integer width = 466
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

type cb_aceptar from commandbutton within w_choice_cierre_caja
integer x = 1074
integer y = 104
integer width = 466
integer height = 132
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

event clicked;parent.dynamic event ue_aceptar()
end event

type st_titulo from statictext within w_choice_cierre_caja
integer width = 1545
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Elegir Reporte de Cierre de Caja"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

