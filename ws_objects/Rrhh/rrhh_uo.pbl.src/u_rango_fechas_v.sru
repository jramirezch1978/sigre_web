$PBExportHeader$u_rango_fechas_v.sru
$PBExportComments$Custom Object para ingreso de un rango de fechas
forward
global type u_rango_fechas_v from u_ingreso_rango_fechas
end type
end forward

global type u_rango_fechas_v from u_ingreso_rango_fechas
integer width = 622
integer height = 204
end type
global u_rango_fechas_v u_rango_fechas_v

on u_rango_fechas_v.create
call super::create
end on

on u_rango_fechas_v.destroy
call super::destroy
end on

type em_1 from u_ingreso_rango_fechas`em_1 within u_rango_fechas_v
integer textsize = -8
end type

type em_2 from u_ingreso_rango_fechas`em_2 within u_rango_fechas_v
integer x = 270
integer y = 112
integer textsize = -8
end type

