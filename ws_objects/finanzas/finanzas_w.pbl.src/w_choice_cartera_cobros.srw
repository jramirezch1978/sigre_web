$PBExportHeader$w_choice_cartera_cobros.srw
forward
global type w_choice_cartera_cobros from window
end type
type rb_3 from radiobutton within w_choice_cartera_cobros
end type
type p_1 from picture within w_choice_cartera_cobros
end type
type rb_2 from radiobutton within w_choice_cartera_cobros
end type
type rb_1 from radiobutton within w_choice_cartera_cobros
end type
type pb_salir from picturebutton within w_choice_cartera_cobros
end type
type pb_aceptar from picturebutton within w_choice_cartera_cobros
end type
type gb_1 from groupbox within w_choice_cartera_cobros
end type
end forward

global type w_choice_cartera_cobros from window
integer width = 1778
integer height = 508
boolean titlebar = true
string title = "Opciones de Cartera de Cobros"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
rb_3 rb_3
p_1 p_1
rb_2 rb_2
rb_1 rb_1
pb_salir pb_salir
pb_aceptar pb_aceptar
gb_1 gb_1
end type
global w_choice_cartera_cobros w_choice_cartera_cobros

on w_choice_cartera_cobros.create
this.rb_3=create rb_3
this.p_1=create p_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
this.gb_1=create gb_1
this.Control[]={this.rb_3,&
this.p_1,&
this.rb_2,&
this.rb_1,&
this.pb_salir,&
this.pb_aceptar,&
this.gb_1}
end on

on w_choice_cartera_cobros.destroy
destroy(this.rb_3)
destroy(this.p_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
destroy(this.gb_1)
end on

type rb_3 from radiobutton within w_choice_cartera_cobros
integer x = 613
integer y = 280
integer width = 763
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "&3.- Cheque Voucher"
end type

type p_1 from picture within w_choice_cartera_cobros
integer x = 14
integer y = 60
integer width = 512
integer height = 276
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_choice_cartera_cobros
integer x = 613
integer y = 188
integer width = 763
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "&2.- Voucher"
end type

type rb_1 from radiobutton within w_choice_cartera_cobros
integer x = 613
integer y = 96
integer width = 773
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "&1.- Recibo de Pago"
boolean checked = true
end type

type pb_salir from picturebutton within w_choice_cartera_cobros
integer x = 1413
integer y = 212
integer width = 325
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;str_parametros lstr_param

lstr_param.b_return = false
CloseWithReturn(Parent, lstr_param)

end event

type pb_aceptar from picturebutton within w_choice_cartera_cobros
integer x = 1413
integer y = 12
integer width = 325
integer height = 188
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;str_parametros lstr_param

if rb_1.checked then
	lstr_param.i_return = 1
elseif rb_2.checked then
	lstr_param.i_return = 2
elseif rb_3.checked then
	lstr_param.i_return = 3
end if

lstr_param.b_return = true
CloseWithReturn(parent, lstr_param)
end event

type gb_1 from groupbox within w_choice_cartera_cobros
integer x = 549
integer y = 12
integer width = 850
integer height = 392
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Opciones de reporte"
end type

