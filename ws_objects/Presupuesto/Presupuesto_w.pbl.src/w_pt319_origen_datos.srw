$PBExportHeader$w_pt319_origen_datos.srw
forward
global type w_pt319_origen_datos from window
end type
type rb_2 from radiobutton within w_pt319_origen_datos
end type
type rb_1 from radiobutton within w_pt319_origen_datos
end type
type pb_1 from picturebutton within w_pt319_origen_datos
end type
type pb_2 from picturebutton within w_pt319_origen_datos
end type
end forward

global type w_pt319_origen_datos from window
integer width = 1477
integer height = 632
boolean titlebar = true
string title = "Origen de Datos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
rb_2 rb_2
rb_1 rb_1
pb_1 pb_1
pb_2 pb_2
end type
global w_pt319_origen_datos w_pt319_origen_datos

event ue_aceptar();str_parametros  lstr_param

lstr_param.titulo = 's'

if rb_1.checked then
	lstr_param.long1	= 1
elseif rb_2.checked then
	lstr_param.long1	= 2
end if

CloseWithReturn(this, lstr_param)
end event

event ue_salir();str_parametros  lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_pt319_origen_datos.create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.Control[]={this.rb_2,&
this.rb_1,&
this.pb_1,&
this.pb_2}
end on

on w_pt319_origen_datos.destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type rb_2 from radiobutton within w_pt319_origen_datos
integer x = 46
integer y = 152
integer width = 1358
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingresar los datos manualmante"
end type

type rb_1 from radiobutton within w_pt319_origen_datos
integer x = 41
integer y = 40
integer width = 1358
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Jalar los datos de la factura"
boolean checked = true
end type

type pb_1 from picturebutton within w_pt319_origen_datos
integer x = 480
integer y = 328
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
boolean default = true
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_aceptar()
end event

type pb_2 from picturebutton within w_pt319_origen_datos
integer x = 855
integer y = 328
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

