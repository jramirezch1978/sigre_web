$PBExportHeader$u_pb_calendario.sru
$PBExportComments$boton que abre un calendario para seleccionar la fecha y la setea a una columna de tipo fecha de un datawindow
forward
global type u_pb_calendario from u_pb_std
end type
end forward

global type u_pb_calendario from u_pb_std
integer width = 114
string picturename = "DataWindow!"
end type
global u_pb_calendario u_pb_calendario

type variables
datawindow	idw_fecha
string		is_campo_fecha
long			il_row
end variables

on u_pb_calendario.create
call super::create
end on

on u_pb_calendario.destroy
call super::destroy
end on

event clicked;call super::clicked;Long ll_rs
str_calendar lstr_cal
lstr_cal.active_datawindow = idw_fecha 
lstr_cal.active_column = is_campo_fecha
lstr_cal.active_row = il_row

ll_rs = OpenWithParm(w_pb_calendar,lstr_cal)

IF ll_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
END IF

end event

event mousemove;//Override
end event

