$PBExportHeader$u_rango_fechas.sru
forward
global type u_rango_fechas from u_ingreso_rango_fechas
end type
end forward

global type u_rango_fechas from u_ingreso_rango_fechas
integer width = 1179
integer height = 88
end type
global u_rango_fechas u_rango_fechas

event constructor;call super::constructor;string ls_mes_ini, ls_mes_fin, ls_ano_ini, ls_ano_fin
date ld_fecha_desde, ld_fecha_hasta
ls_mes_ini = right('0' + trim(string(month(today()))),2)
ls_ano_ini = trim(string(year(today())))

ls_mes_fin = right('0' + trim(string(month(today())+1)),2)
if ls_mes_fin = '13' then
	ls_mes_fin = '01'
	ls_ano_fin = trim(string(year(today())+1))
else
	ls_ano_fin = trim(string(year(today())))
end if

ld_fecha_desde = date(ls_ano_ini + '-' + ls_mes_ini + '-01')
ld_fecha_hasta = relativedate(date(ls_ano_fin + '-' + ls_mes_fin + '-01'),-1)

of_set_label('Desde','Hasta') // para seatear el titulo del boton
of_set_fecha(ld_fecha_desde, ld_fecha_hasta) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(ld_fecha_hasta) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on u_rango_fechas.create
call super::create
end on

on u_rango_fechas.destroy
call super::destroy
end on

type em_1 from u_ingreso_rango_fechas`em_1 within u_rango_fechas
integer x = 274
integer width = 297
integer taborder = 20
integer textsize = -8
end type

type em_2 from u_ingreso_rango_fechas`em_2 within u_rango_fechas
integer x = 873
integer width = 297
integer taborder = 40
integer textsize = -8
end type

