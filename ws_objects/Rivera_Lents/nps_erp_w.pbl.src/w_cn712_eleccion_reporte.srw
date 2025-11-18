$PBExportHeader$w_cn712_eleccion_reporte.srw
forward
global type w_cn712_eleccion_reporte from window
end type
type rb_2 from radiobutton within w_cn712_eleccion_reporte
end type
type rb_1 from radiobutton within w_cn712_eleccion_reporte
end type
type cb_2 from commandbutton within w_cn712_eleccion_reporte
end type
type cb_1 from commandbutton within w_cn712_eleccion_reporte
end type
type gb_1 from groupbox within w_cn712_eleccion_reporte
end type
end forward

global type w_cn712_eleccion_reporte from window
integer width = 1175
integer height = 608
boolean titlebar = true
string title = "Elegir Tipo de Reporte"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
rb_2 rb_2
rb_1 rb_1
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_cn712_eleccion_reporte w_cn712_eleccion_reporte

event ue_aceptar();str_parametros lstr_param
if rb_1.checked then
	lstr_param.titulo = '1'
elseif rb_2.checked then
	lstr_param.titulo = '2'
else
	lstr_param.titulo = '0'
end if

CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param
lstr_param.titulo = '0'
CloseWithReturn(this, lstr_param)
end event

on w_cn712_eleccion_reporte.create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.rb_2,&
this.rb_1,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_cn712_eleccion_reporte.destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type rb_2 from radiobutton within w_cn712_eleccion_reporte
integer x = 187
integer y = 208
integer width = 777
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumido por Documento"
end type

type rb_1 from radiobutton within w_cn712_eleccion_reporte
integer x = 187
integer y = 108
integer width = 777
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado por movimientos"
boolean checked = true
end type

type cb_2 from commandbutton within w_cn712_eleccion_reporte
integer x = 649
integer y = 348
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar( )
end event

type cb_1 from commandbutton within w_cn712_eleccion_reporte
integer x = 82
integer y = 352
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_aceptar( )
end event

type gb_1 from groupbox within w_cn712_eleccion_reporte
integer x = 50
integer y = 20
integer width = 1029
integer height = 312
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir un tipo de reporte"
end type

