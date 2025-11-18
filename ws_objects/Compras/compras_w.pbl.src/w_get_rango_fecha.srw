$PBExportHeader$w_get_rango_fecha.srw
forward
global type w_get_rango_fecha from window
end type
type cb_2 from commandbutton within w_get_rango_fecha
end type
type cb_aceptar from commandbutton within w_get_rango_fecha
end type
type uo_1 from u_ingreso_rango_fechas within w_get_rango_fecha
end type
end forward

global type w_get_rango_fecha from window
integer width = 1381
integer height = 344
boolean titlebar = true
string title = "Rango de Fechas "
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_aceptar cb_aceptar
uo_1 uo_1
end type
global w_get_rango_fecha w_get_rango_fecha

on w_get_rango_fecha.create
this.cb_2=create cb_2
this.cb_aceptar=create cb_aceptar
this.uo_1=create uo_1
this.Control[]={this.cb_2,&
this.cb_aceptar,&
this.uo_1}
end on

on w_get_rango_fecha.destroy
destroy(this.cb_2)
destroy(this.cb_aceptar)
destroy(this.uo_1)
end on

type cb_2 from commandbutton within w_get_rango_fecha
integer x = 951
integer y = 164
integer width = 398
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;str_parametros 	lstr_param
lstr_param.b_return = false


Closewithreturn(Parent,lstr_param) 


end event

type cb_aceptar from commandbutton within w_get_rango_fecha
integer x = 553
integer y = 164
integer width = 398
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;str_parametros 	lstr_param

lstr_param.fecha1  = uo_1.of_get_fecha1()
lstr_param.fecha2  = uo_1.of_get_fecha2()
lstr_param.b_return = true


Closewithreturn(Parent,lstr_param) 
end event

type uo_1 from u_ingreso_rango_fechas within w_get_rango_fecha
integer x = 18
integer y = 36
integer width = 1312
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecha1, ld_fecha2

ld_fecha1 = RelativeDate(Date(f_fecha_Actual()), -30)
ld_fecha2 = RelativeDate(Date(f_fecha_Actual()), 30)

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
of_set_fecha( ld_fecha1, ld_fecha2)

end event

