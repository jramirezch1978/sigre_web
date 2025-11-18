$PBExportHeader$u_fecha.sru
forward
global type u_fecha from u_ingreso_fecha
end type
end forward

global type u_fecha from u_ingreso_fecha
end type
global u_fecha u_fecha

event constructor;call super::constructor;of_set_label('Fecha') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

//of_get_fecha1()  //para leer las fechas
end event

on u_fecha.create
call super::create
end on

on u_fecha.destroy
call super::destroy
end on

type cb_1 from u_ingreso_fecha`cb_1 within u_fecha
integer textsize = -8
integer weight = 400
end type

type em_1 from u_ingreso_fecha`em_1 within u_fecha
integer textsize = -8
end type

