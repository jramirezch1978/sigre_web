$PBExportHeader$w_abc_opcion_pesca.srw
forward
global type w_abc_opcion_pesca from w_abc
end type
type pb_2 from picturebutton within w_abc_opcion_pesca
end type
type pb_1 from picturebutton within w_abc_opcion_pesca
end type
type rb_2 from radiobutton within w_abc_opcion_pesca
end type
type rb_1 from radiobutton within w_abc_opcion_pesca
end type
type st_1 from statictext within w_abc_opcion_pesca
end type
end forward

global type w_abc_opcion_pesca from w_abc
integer width = 1527
integer height = 792
string title = "Facturación Pesca"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_2 pb_2
pb_1 pb_1
rb_2 rb_2
rb_1 rb_1
st_1 st_1
end type
global w_abc_opcion_pesca w_abc_opcion_pesca

type variables
str_parametros is_param
end variables

on w_abc_opcion_pesca.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.st_1
end on

on w_abc_opcion_pesca.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
end on

event ue_open_pre;//Overrido
IF NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
END IF
end event

type pb_2 from picturebutton within w_abc_opcion_pesca
integer x = 942
integer y = 484
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\source\BMP\CLOSE_UP.BMP"
alignment htextalign = left!
end type

event clicked;is_param.string4 = '0' // Cancelar Accion

Closewithreturn(parent,is_param)
end event

type pb_1 from picturebutton within w_abc_opcion_pesca
integer x = 242
integer y = 484
integer width = 315
integer height = 180
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;IF rb_1.checked THEN
	is_param.string4 = '1' // Factura Cantidad
ELSE
	is_param.string4 = '2' // Facturat Aparejo
END IF

Closewithreturn(parent,is_param)
end event

type rb_2 from radiobutton within w_abc_opcion_pesca
integer x = 530
integer y = 340
integer width = 517
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aparejo"
end type

type rb_1 from radiobutton within w_abc_opcion_pesca
integer x = 530
integer y = 208
integer width = 517
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cantidad"
boolean checked = true
end type

type st_1 from statictext within w_abc_opcion_pesca
integer x = 430
integer y = 72
integer width = 809
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Que desea Facturar?"
boolean focusrectangle = false
end type

