$PBExportHeader$w_get_rango_fechas.srw
forward
global type w_get_rango_fechas from window
end type
type cb_cancelar from commandbutton within w_get_rango_fechas
end type
type cb_aceptar from commandbutton within w_get_rango_fechas
end type
type uo_fecha from u_ingreso_rango_fechas within w_get_rango_fechas
end type
end forward

global type w_get_rango_fechas from window
integer width = 1358
integer height = 372
boolean titlebar = true
string title = "Ingrese Rango de FEchas"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
uo_fecha uo_fecha
end type
global w_get_rango_fechas w_get_rango_fechas

event ue_cancelar();str_parametros lstr_param
lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();str_parametros lstr_param
lstr_param.fecha1 = uo_fecha.of_get_fecha1( )
lstr_param.fecha2 = uo_fecha.of_get_fecha2( )

if lstr_param.fecha2 < lstr_param.fecha1 then
	MessageBox('Aviso', 'Rango de fechas invalido')
	return
end if

CloseWithReturn(this, lstr_param)
end event

on w_get_rango_fechas.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.uo_fecha=create uo_fecha
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.uo_fecha}
end on

on w_get_rango_fechas.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.uo_fecha)
end on

type cb_cancelar from commandbutton within w_get_rango_fechas
integer x = 681
integer y = 144
integer width = 379
integer height = 96
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Parent.event dynamic ue_cancelar()
end event

type cb_aceptar from commandbutton within w_get_rango_fechas
integer x = 302
integer y = 144
integer width = 379
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Parent.event dynamic ue_aceptar()
end event

type uo_fecha from u_ingreso_rango_fechas within w_get_rango_fechas
integer x = 27
integer y = 8
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )

ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )

end event

