$PBExportHeader$w_nro_copias.srw
forward
global type w_nro_copias from window
end type
type pb_1 from picturebutton within w_nro_copias
end type
type pb_2 from picturebutton within w_nro_copias
end type
type st_6 from statictext within w_nro_copias
end type
type em_ano from editmask within w_nro_copias
end type
end forward

global type w_nro_copias from window
integer width = 1001
integer height = 480
boolean titlebar = true
string title = "Nro de Copias"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
pb_1 pb_1
pb_2 pb_2
st_6 st_6
em_ano em_ano
end type
global w_nro_copias w_nro_copias

event ue_aceptar;str_parametros  lstr_param

lstr_param.titulo = 's'
lstr_param.long1	= Long(em_ano.text)

CloseWithReturn(this, lstr_param)
end event

event ue_salir();str_parametros  lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_nro_copias.create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_6=create st_6
this.em_ano=create em_ano
this.Control[]={this.pb_1,&
this.pb_2,&
this.st_6,&
this.em_ano}
end on

on w_nro_copias.destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_6)
destroy(this.em_ano)
end on

type pb_1 from picturebutton within w_nro_copias
integer x = 146
integer y = 184
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

type pb_2 from picturebutton within w_nro_copias
integer x = 521
integer y = 184
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

type st_6 from statictext within w_nro_copias
integer x = 73
integer y = 48
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro de Copias"
boolean focusrectangle = false
end type

type em_ano from editmask within w_nro_copias
integer x = 507
integer y = 40
integer width = 315
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

