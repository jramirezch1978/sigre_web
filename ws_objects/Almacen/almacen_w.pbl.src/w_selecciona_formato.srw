$PBExportHeader$w_selecciona_formato.srw
forward
global type w_selecciona_formato from window
end type
type rb_2 from radiobutton within w_selecciona_formato
end type
type rb_1 from radiobutton within w_selecciona_formato
end type
type cb_cancelar from commandbutton within w_selecciona_formato
end type
type cb_aceptar from commandbutton within w_selecciona_formato
end type
type p_1 from picture within w_selecciona_formato
end type
type gb_1 from groupbox within w_selecciona_formato
end type
end forward

global type w_selecciona_formato from window
integer width = 2107
integer height = 652
boolean titlebar = true
string title = "Seleecione Tipo Formato"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
rb_2 rb_2
rb_1 rb_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
p_1 p_1
gb_1 gb_1
end type
global w_selecciona_formato w_selecciona_formato

on w_selecciona_formato.create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.p_1=create p_1
this.gb_1=create gb_1
this.Control[]={this.rb_2,&
this.rb_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.p_1,&
this.gb_1}
end on

on w_selecciona_formato.destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.p_1)
destroy(this.gb_1)
end on

type rb_2 from radiobutton within w_selecciona_formato
integer x = 846
integer y = 184
integer width = 558
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Formato Crosstab"
end type

type rb_1 from radiobutton within w_selecciona_formato
integer x = 846
integer y = 80
integer width = 512
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Formato Tabular"
boolean checked = true
end type

type cb_cancelar from commandbutton within w_selecciona_formato
integer x = 1609
integer y = 200
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

lstr_param.b_return = false

CloseWithReturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_selecciona_formato
integer x = 1609
integer y = 76
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

lstr_param.b_return = true

if rb_1.checked then
	lstr_param.string1 = '1'
else
	lstr_param.string1 = '2'
end if

CloseWithReturn(parent, lstr_param)
end event

type p_1 from picture within w_selecciona_formato
integer width = 722
integer height = 488
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_selecciona_formato
integer x = 727
integer width = 1330
integer height = 524
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Seleccione el formato"
end type

