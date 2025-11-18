$PBExportHeader$w_get_fecha.srw
forward
global type w_get_fecha from window
end type
type uo_fecha from u_ingreso_fecha within w_get_fecha
end type
type cb_1 from commandbutton within w_get_fecha
end type
type cb_ok from commandbutton within w_get_fecha
end type
end forward

global type w_get_fecha from window
integer x = 1815
integer y = 1608
integer width = 777
integer height = 364
boolean titlebar = true
string title = "Ratio"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
uo_fecha uo_fecha
cb_1 cb_1
cb_ok cb_ok
end type
global w_get_fecha w_get_fecha

on w_get_fecha.create
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.cb_ok=create cb_ok
this.Control[]={this.uo_fecha,&
this.cb_1,&
this.cb_ok}
end on

on w_get_fecha.destroy
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.cb_ok)
end on

type uo_fecha from u_ingreso_fecha within w_get_fecha
event destroy ( )
integer x = 82
integer y = 28
integer taborder = 30
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Fecha:') // para seatear el titulo del boton
of_set_fecha(date(f_fecha_Actual(1))) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_1 from commandbutton within w_get_fecha
integer x = 393
integer y = 156
integer width = 297
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_ok from commandbutton within w_get_fecha
integer x = 82
integer y = 156
integer width = 297
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_param

lstr_param.fecha1 = uo_fecha.of_get_fecha()

CloseWithReturn(Parent, lstr_param)
end event

