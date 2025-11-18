$PBExportHeader$u_ingreso_rango_fechas_v.sru
$PBExportComments$Custom Object para ingreso de un rango de fechas
forward
global type u_ingreso_rango_fechas_v from u_ingreso_rango_fechas
end type
end forward

global type u_ingreso_rango_fechas_v from u_ingreso_rango_fechas
int Width=622
int Height=204
end type
global u_ingreso_rango_fechas_v u_ingreso_rango_fechas_v

on u_ingreso_rango_fechas_v.create
call super::create
end on

on u_ingreso_rango_fechas_v.destroy
call super::destroy
end on

type em_2 from u_ingreso_rango_fechas`em_2 within u_ingreso_rango_fechas_v
int X=270
int Y=112
end type

type cb_2 from u_ingreso_rango_fechas`cb_2 within u_ingreso_rango_fechas_v
int X=5
int Y=112
end type

