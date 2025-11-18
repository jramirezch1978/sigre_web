$PBExportHeader$ou_rango_fechas.sru
forward
global type ou_rango_fechas from u_ingreso_rango_fechas
end type
end forward

global type ou_rango_fechas from u_ingreso_rango_fechas
integer width = 1262
integer height = 88
end type
global ou_rango_fechas ou_rango_fechas

on ou_rango_fechas.create
call super::create
end on

on ou_rango_fechas.destroy
call super::destroy
end on

event constructor;call super::constructor;string ls_mes, ls_ano
date ld_ini, ld_fin

ls_mes = right('0' + string(month(today())),2)
ls_ano = string(year(today()))

ld_ini = date(ls_ano + '-' + ls_mes + '-01')

if ls_mes = '12' then
	ls_mes = '01'
	ls_ano = string(integer(ls_ano) + 1)
else
	ls_mes = string(integer(ls_mes) + 1)
end if

ld_fin = relativedate(date(ls_ano + '-' + ls_mes + '-01'), -1)

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_ini, ld_fin) //para setear la fecha inicial

of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type shl_2 from u_ingreso_rango_fechas`shl_2 within ou_rango_fechas
end type

type shl_1 from u_ingreso_rango_fechas`shl_1 within ou_rango_fechas
end type

type em_1 from u_ingreso_rango_fechas`em_1 within ou_rango_fechas
integer x = 256
end type

type em_2 from u_ingreso_rango_fechas`em_2 within ou_rango_fechas
integer x = 901
end type

