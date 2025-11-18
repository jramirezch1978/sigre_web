$PBExportHeader$u_ingreso_fec.sru
$PBExportComments$Custom Object para ingreso de un rango de fechas
forward
global type u_ingreso_fec from u_ingreso_rango_fechas
end type
end forward

global type u_ingreso_fec from u_ingreso_rango_fechas
end type
global u_ingreso_fec u_ingreso_fec

on u_ingreso_fec.create
call super::create
end on

on u_ingreso_fec.destroy
call super::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(relativedate(today(), -30), today()) //para setear la fecha inicial


of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type em_1 from u_ingreso_rango_fechas`em_1 within u_ingreso_fec
integer textsize = -8
end type

type em_2 from u_ingreso_rango_fechas`em_2 within u_ingreso_fec
integer textsize = -8
end type

