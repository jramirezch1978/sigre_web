$PBExportHeader$w_det_planilla_tripultante.srw
forward
global type w_det_planilla_tripultante from w_abc
end type
type rb_2 from radiobutton within w_det_planilla_tripultante
end type
type rb_1 from radiobutton within w_det_planilla_tripultante
end type
type pb_2 from picturebutton within w_det_planilla_tripultante
end type
type pb_1 from picturebutton within w_det_planilla_tripultante
end type
type gb_1 from groupbox within w_det_planilla_tripultante
end type
end forward

global type w_det_planilla_tripultante from w_abc
integer width = 1189
integer height = 632
string title = "Planilla de Tripulantes"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_salir ( )
event ue_aceptar ( )
rb_2 rb_2
rb_1 rb_1
pb_2 pb_2
pb_1 pb_1
gb_1 gb_1
end type
global w_det_planilla_tripultante w_det_planilla_tripultante

event ue_salir();str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();str_parametros lstr_param

lstr_param.b_return = true

if rb_1.Checked then
	lstr_param.string1 = '1'
elseif rb_2.checked then
	lstr_param.string1 = '2'
else
	lstr_param.string1 = '0'
end if

CloseWithReturn(this, lstr_param)
end event

on w_det_planilla_tripultante.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_det_planilla_tripultante.destroy
call super::destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_1)
end on

type rb_2 from radiobutton within w_det_planilla_tripultante
integer x = 78
integer y = 200
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consolidado"
end type

type rb_1 from radiobutton within w_det_planilla_tripultante
integer x = 82
integer y = 108
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado por Barco"
boolean checked = true
end type

type pb_2 from picturebutton within w_det_planilla_tripultante
integer x = 594
integer y = 312
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_salir( )

end event

type pb_1 from picturebutton within w_det_planilla_tripultante
integer x = 219
integer y = 312
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
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

event clicked;parent.event ue_aceptar()
end event

type gb_1 from groupbox within w_det_planilla_tripultante
integer width = 1161
integer height = 536
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte de Planilla Simple"
end type

