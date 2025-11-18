$PBExportHeader$uo_zarpe.sru
forward
global type uo_zarpe from nonvisualobject
end type
end forward

global type uo_zarpe from nonvisualobject
end type
global uo_zarpe uo_zarpe

type variables
private:
string 	is_nave, is_puerto, is_situac, is_zona, is_registro
string 	is_unidad, is_origen, is_aprobado, is_user, is_observ
string 	is_nro_parte
integer 	ii_tiempo, ii_flag
datetime id_fecha1, id_fecha2


end variables

forward prototypes
public function boolean of_save (ref string as_mensaje)
public function string of_get_nro_parte ()
public function boolean of_validar (ref string as_mensaje)
public function boolean of_save_zarpe (string as_nave, string as_puerto, string as_zona, string as_situac, string as_registro, string as_unidad, string as_origen, string as_aprobado, string as_user, string as_observ, integer ai_tiempo, datetime ad_fecha1, datetime ad_fecha2, string as_nro_parte, integer ai_flag)
public subroutine of_set_cod_nave (string as_nave)
public function boolean of_verif_reg_zarpe (string as_registro)
public subroutine of_set_reg_zarpe (string as_registro)
public function boolean of_verif_nav_zarpe (string as_nave)
public function boolean of_delete_zarpe (string as_nro_parte)
public function boolean of_delete_zarpe ()
end prototypes

public function boolean of_save (ref string as_mensaje);integer li_ok

if ii_flag = 1 then
	// Se va a insertar un nuevo zarpe

	DECLARE usp_fl_insert_zarpe PROCEDURE FOR
		usp_fl_insert_zarpe( :is_nave, :is_puerto, 
			:is_situac, :is_zona, :is_registro,
			:is_unidad, :is_origen, :is_aprobado,
			:is_user, :is_observ, :ii_tiempo, 
			:id_fecha1, :id_fecha2 );

	EXECUTE usp_fl_insert_zarpe;
	
	IF SQLCA.sqlcode = -1 THEN
		as_mensaje = "PROCEDURE USP_FL_INSERT_ZARPE:" &
				  + SQLCA.SQLErrText
		Rollback;
		//MessageBox('SQL ERROR', as_mensaje )	
		Return false
	END IF
	
	FETCH usp_fl_insert_zarpe INTO :is_nro_parte, :as_mensaje, :li_ok;
	CLOSE usp_fl_insert_zarpe;
else
	// Se va a actualizar un zarpe

	DECLARE usp_fl_update_zarpe PROCEDURE FOR
		usp_fl_update_zarpe( :is_nave, :is_puerto, 
			:is_situac, :is_zona, :is_registro,
			:is_unidad, :is_origen, :is_aprobado,
			:is_user, :is_observ, :ii_tiempo, 
			:id_fecha1, :id_fecha2, :is_nro_parte );

	EXECUTE usp_fl_update_zarpe;
	
	IF SQLCA.sqlcode = -1 THEN
		as_mensaje = "PROCEDURE USP_FL_UPDATE_ZARPE:" &
				  + SQLCA.SQLErrText
		Rollback;
//		MessageBox('SQL ERROR', as_mensaje )	
		Return false
	END IF
	
	FETCH usp_fl_update_zarpe INTO :as_mensaje, :li_ok;
	CLOSE usp_fl_update_zarpe;

end if

if li_ok <> 1 then
	return false
end if

return true

end function

public function string of_get_nro_parte ();return is_nro_parte
end function

public function boolean of_validar (ref string as_mensaje);// Verifico REGISTRO_ARRIBO
if IsNull(is_registro) or trim(is_registro) = '' then
	as_mensaje = 'LA EMBARCACIÓN DEBE TENER UN REGISTRO DE ZARPE'
   RETURN false
end if

// Verifico ORIGEN
if IsNull(is_origen) or trim(is_origen) = '' then
	as_mensaje = 'NO SE HA INGRESADO UN ORIGEN'
   RETURN false
end if


// Verifico el codigo de la nave
if IsNull(is_nave) or trim(is_nave) = '' then
	as_mensaje = 'EL CODIGO DE LA NAVE NO PUEDE ESTAR EN BLANCO'
   RETURN false
end if

// Verifico el PUERTO
if IsNull(is_puerto) or trim(is_puerto) = '' then
	as_mensaje = 'EL PUERTO NO PUEDE ESTAR EN BLANCO'
   RETURN false
end if

// Verifico la ZONA DE PESCA
if IsNull(is_zona) or trim(is_zona) = '' then
	as_mensaje = 'LA ZONA DE PESCA NO PUEDE ESTAR EN BLANCO'
   RETURN false
end if

// Verifico la SITUACION AL ZARPE
if IsNull(is_situac) or trim(is_situac) = '' then
	as_mensaje = 'LA EMBARCACIÓN DEBE VIAJAR POR ALGUN MOTIVO'
   RETURN false
end if


// Verifico TIEMPO ESTIMADO OPERACION
if IsNull(ii_tiempo) or ii_tiempo = 0 then
	as_mensaje = 'LA EMBARCACIÓN DEBE TENER UN TIEMPO ESTIMADO DE OPERACION'
   RETURN false
end if


// Verifico USUARIO
if IsNull(is_user) or trim(is_user) = '' then
	as_mensaje = 'NO SE HA INGRESADO UN USUARIO'
   RETURN false
end if

return true
end function

public function boolean of_save_zarpe (string as_nave, string as_puerto, string as_zona, string as_situac, string as_registro, string as_unidad, string as_origen, string as_aprobado, string as_user, string as_observ, integer ai_tiempo, datetime ad_fecha1, datetime ad_fecha2, string as_nro_parte, integer ai_flag);string ls_mensaje
// Esta funcion ingresa el zarpe y returna true si lo hizo bien, de lo
// contrario retorna false

is_nave 		= as_nave
is_puerto	= as_puerto
is_zona		= as_zona
is_situac   = as_situac
is_registro = as_registro
is_unidad   = as_unidad
is_origen   = as_origen
is_aprobado = as_aprobado
is_user     = as_user
is_observ   = as_observ
is_nro_parte= as_nro_parte
ii_tiempo   = ai_tiempo
ii_flag		= ai_flag
id_fecha1	= ad_fecha1
id_fecha2	= ad_fecha2

if not of_validar(ls_mensaje) then
	MessageBox('Error', ls_mensaje, StopSign!)
	return false
end if

if not of_save(ls_mensaje) then
	MessageBox('Error', ls_mensaje, StopSign!)
	return false
end if

return true
end function

public subroutine of_set_cod_nave (string as_nave);is_nave = as_nave
end subroutine

public function boolean of_verif_reg_zarpe (string as_registro);string ls_mensaje

// Esta funcion valida que el registro de Zarpe no se repita

if as_registro = is_registro then
	return true
end if

DECLARE usf_fl_verf_reg_zarpe PROCEDURE FOR
	usf_fl_verf_reg_zarpe( :as_registro );

EXECUTE usf_fl_verf_reg_zarpe;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION usf_fl_verf_reg_zarpe: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', SQLCA.SQLErrText)	
	Return false
END IF

FETCH usf_fl_verf_reg_zarpe INTO :ls_mensaje;
CLOSE usf_fl_verf_reg_zarpe;

if ls_mensaje <> "" then
	MessageBox('Error', ls_mensaje, StopSign!)	
	Return false
end if

return true
end function

public subroutine of_set_reg_zarpe (string as_registro);is_registro = as_registro
end subroutine

public function boolean of_verif_nav_zarpe (string as_nave);string ls_mensaje

// Esta funcion valida que la embarcacion que se esta ingresando
// no tenga un arribo pendiente 
// returna true si no hay ningun arribo pendiente y false de lo 
// contrario

if as_nave = is_nave then
	// si el codigo de la nave del parametro es igual al que esta en 
	// el objeto no hay ningun caso verificar
	return true
end if

DECLARE pb_usf_fl_verf_nav_zarpe PROCEDURE FOR
	usf_fl_verf_nav_zarpe( :as_nave );

EXECUTE pb_usf_fl_verf_nav_zarpe;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_FL_VERF_NAV_ZARPE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', SQLCA.SQLErrText)	
	Return false
END IF

FETCH pb_usf_fl_verf_nav_zarpe INTO :ls_mensaje;
CLOSE pb_usf_fl_verf_nav_zarpe;

if ls_mensaje <> "" then
	MessageBox('Error', ls_mensaje, StopSign!)	
	Return false
end if

return true
end function

public function boolean of_delete_zarpe (string as_nro_parte);is_nro_parte = as_nro_parte

return of_delete_zarpe()
end function

public function boolean of_delete_zarpe ();integer li_ok
string ls_mensaje

DECLARE usp_fl_delete_zarpe PROCEDURE FOR
	usp_fl_delete_zarpe( :is_nro_parte );

EXECUTE usp_fl_delete_zarpe;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_DELETE_ZARPE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje)	
	return false
END IF

FETCH usp_fl_delete_zarpe INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_delete_zarpe;

if li_ok <> 1 then
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

on uo_zarpe.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_zarpe.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

