$PBExportHeader$w_choise_factura_comercial.srw
forward
global type w_choise_factura_comercial from window
end type
type rb_modelo2 from radiobutton within w_choise_factura_comercial
end type
type p_1 from picture within w_choise_factura_comercial
end type
type rb_modelo1 from radiobutton within w_choise_factura_comercial
end type
type rb_impresion from radiobutton within w_choise_factura_comercial
end type
type pb_salir from picturebutton within w_choise_factura_comercial
end type
type pb_aceptar from picturebutton within w_choise_factura_comercial
end type
type gb_1 from groupbox within w_choise_factura_comercial
end type
end forward

global type w_choise_factura_comercial from window
integer width = 1778
integer height = 508
boolean titlebar = true
string title = "Elija el MODELO de Factura"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
rb_modelo2 rb_modelo2
p_1 p_1
rb_modelo1 rb_modelo1
rb_impresion rb_impresion
pb_salir pb_salir
pb_aceptar pb_aceptar
gb_1 gb_1
end type
global w_choise_factura_comercial w_choise_factura_comercial

on w_choise_factura_comercial.create
this.rb_modelo2=create rb_modelo2
this.p_1=create p_1
this.rb_modelo1=create rb_modelo1
this.rb_impresion=create rb_impresion
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
this.gb_1=create gb_1
this.Control[]={this.rb_modelo2,&
this.p_1,&
this.rb_modelo1,&
this.rb_impresion,&
this.pb_salir,&
this.pb_aceptar,&
this.gb_1}
end on

on w_choise_factura_comercial.destroy
destroy(this.rb_modelo2)
destroy(this.p_1)
destroy(this.rb_modelo1)
destroy(this.rb_impresion)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
destroy(this.gb_1)
end on

type rb_modelo2 from radiobutton within w_choise_factura_comercial
integer x = 613
integer y = 264
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
string text = "&Model Comercial 02"
end type

type p_1 from picture within w_choise_factura_comercial
integer x = 14
integer y = 60
integer width = 512
integer height = 276
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type rb_modelo1 from radiobutton within w_choise_factura_comercial
integer x = 613
integer y = 180
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
string text = "&Model Comercial 01"
end type

type rb_impresion from radiobutton within w_choise_factura_comercial
integer x = 613
integer y = 96
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
string text = "&Modelo SUNAT"
boolean checked = true
end type

type pb_salir from picturebutton within w_choise_factura_comercial
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

lstr_param.i_return = -1
CloseWithReturn(Parent, lstr_param)

end event

type pb_aceptar from picturebutton within w_choise_factura_comercial
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

if rb_impresion.checked then
	lstr_param.i_return = 1
elseif rb_modelo1.checked then
	lstr_param.i_return = 2
elseif rb_modelo2.checked then
	lstr_param.i_return = 3
end if

CloseWithReturn(parent, lstr_param)
end event

type gb_1 from groupbox within w_choise_factura_comercial
integer x = 549
integer y = 12
integer width = 850
integer height = 364
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Modelo de la factura"
end type

