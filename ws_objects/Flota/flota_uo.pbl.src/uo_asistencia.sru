$PBExportHeader$uo_asistencia.sru
forward
global type uo_asistencia from nonvisualobject
end type
end forward

global type uo_asistencia from nonvisualobject
end type
global uo_asistencia uo_asistencia

forward prototypes
public function boolean of_copy_asist (date ad_origen, date ad_destino[], string as_nave)
public function boolean of_copy_asist (date ad_origen, date ad_destino, string as_nave)
public function boolean of_copy_trip_zarpe (string as_parte, date ad_destino[], string as_nave)
public function boolean of_copy_trip_zarpe (string as_parte, date ad_destino, string as_nave)
end prototypes

public function boolean of_copy_asist (date ad_origen, date ad_destino[], string as_nave);long ll_x
boolean lb_result

lb_result = true
for ll_x = 1 to UpperBound(ad_destino)
	if ad_origen <> ad_destino[ll_x] then
		lb_result = of_copy_asist(ad_origen, ad_destino[ll_x], as_nave)
		if lb_result = false then exit
	end if
next

return lb_result
end function

public function boolean of_copy_asist (date ad_origen, date ad_destino, string as_nave);integer li_ok
string ls_mensaje

//create or replace procedure usp_fl_copy_asist(
//       adi_origen in date, 
//       adi_destino in date, 
//       asi_nave in varchar2) is

DECLARE usp_fl_copy_asist PROCEDURE FOR
	usp_fl_copy_asist( :ad_origen, :ad_destino, :as_nave );

EXECUTE usp_fl_copy_asist;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_copy_asist: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_fl_copy_asist INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_copy_asist;

if li_ok <> 1 then
	MessageBox('Error al copiar la asistencia', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

public function boolean of_copy_trip_zarpe (string as_parte, date ad_destino[], string as_nave);long ll_x
boolean lb_result

lb_result = true
for ll_x = 1 to UpperBound(ad_destino)
	lb_result = of_copy_trip_zarpe(as_parte, ad_destino[ll_x], as_nave)
	if lb_result = false then exit
next

return lb_result
end function

public function boolean of_copy_trip_zarpe (string as_parte, date ad_destino, string as_nave);integer li_ok
string ls_mensaje

//create or replace procedure usp_fl_copy_trip_zarpe(
//       asi_parte 	  in varchar2, 
//       adi_destino 	in date, 
//       asi_nave 		in varchar2,
//       aso_mensaje 	out varchar2,
//       aio_ok				out number) is

DECLARE usp_fl_copy_trip_zarpe PROCEDURE FOR
	usp_fl_copy_trip_zarpe( :as_parte, :ad_destino, :as_nave );

EXECUTE usp_fl_copy_trip_zarpe;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_copy_trip_zarpe: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_fl_copy_trip_zarpe INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_copy_trip_zarpe;

if li_ok <> 1 then
	MessageBox('Error al copiar la asistencia', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

on uo_asistencia.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_asistencia.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

