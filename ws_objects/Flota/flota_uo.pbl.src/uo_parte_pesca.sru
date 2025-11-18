$PBExportHeader$uo_parte_pesca.sru
forward
global type uo_parte_pesca from nonvisualobject
end type
end forward

global type uo_parte_pesca from nonvisualobject
end type
global uo_parte_pesca uo_parte_pesca

type variables
private:
string 	is_nave, is_puerto, is_situac, is_zona, is_registro
string 	is_unidad, is_origen, is_aprobado, is_user, is_observ
string   is_tipo_flota, is_nomb_nave, is_naved, is_tpesca
string 	is_nro_parte, is_regpos, is_orden
integer 	ii_tiempo, ii_flag
datetime id_fecha1, id_fecha2


end variables

forward prototypes
public function string of_get_nro_parte ()
public function boolean of_save_zarpe (string as_nave, string as_puerto, string as_zona, string as_situac, string as_registro, string as_unidad, string as_origen, string as_aprobado, string as_user, string as_observ, integer ai_tiempo, datetime ad_fecha1, datetime ad_fecha2, string as_nro_parte, integer ai_flag)
public subroutine of_set_cod_nave (string as_nave)
public function boolean of_verif_reg_zarpe (string as_registro)
public subroutine of_set_reg_zarpe (string as_registro)
public function boolean of_verif_nav_zarpe (string as_nave)
public function boolean of_delete_zarpe (string as_nro_parte)
public function boolean of_delete_zarpe ()
public function string of_nomb_nave (string as_nave)
public subroutine of_set_nro_parte (string as_parte)
public subroutine of_set_tipo_flota (string as_tipo_flota)
public subroutine of_set_nomb_nave (string as_nomb_nave)
public function string of_get_cod_nave ()
public function string of_get_nomb_nave ()
public function string of_get_tipo_flota ()
public function string of_get_nomb_pto ()
public subroutine of_find_datos_zarpe ()
public function string of_get_cod_pto ()
public function string of_get_cod_zona ()
public function boolean of_verif_reg_arribo (string as_registro)
public subroutine of_set_reg_arribo (string as_registro)
public function string of_get_descr_zona (string as_zona)
public function string of_get_descr_situac (string as_codigo)
public function string of_get_nomb_pto (string as_puerto)
public function string of_get_nomb_nave (string as_nave)
public function string of_get_descr_unidad (string as_unidad)
public function string of_get_cencos_nave (string as_nave)
public function string of_get_tipo_flota (string as_nave)
public function boolean of_valid_dat_zarpe (ref string as_mensaje)
public function boolean of_save_zarpe (ref string as_mensaje)
public function boolean of_valid_dat_arrib (ref string as_mensaje)
public function boolean of_save_arribo (ref string as_mensaje)
public function string of_find_zarpe_nave (string as_nave)
public function string of_get_nomb_especie (string as_codigo)
public function string of_get_nomb_cliente (string as_codigo)
public function string of_get_descr_moneda (string as_codigo)
public function string of_get_descr_zona ()
public function boolean of_delete_arribo ()
public function boolean of_delete_arribo (string as_nro_parte)
public function string of_find_cargo_trip (string as_tripulante)
public function string of_find_desc_cargo (string as_cargo)
public subroutine of_asig_ot_nave (string as_orden, string as_nave)
public subroutine of_liberar_ot_nave (string as_orden, string as_nave)
public function boolean of_save_arribo (string as_parte, string as_origen, string as_registro, string as_naver, string as_naved, string as_puerto, string as_zona, string as_situac, string as_observ, string as_regpos, string as_tpesca, string as_orden, string as_aprobado, datetime ad_fecha, integer ai_flag)
public function boolean of_tripulante_zarpe (u_dw_abc adw_tripulantes, string as_nave, date ad_fecha)
end prototypes

public function string of_get_nro_parte ();return is_nro_parte
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

if not of_valid_dat_zarpe(ls_mensaje) then
	MessageBox('Error', ls_mensaje, StopSign!)
	return false
end if

if not of_save_zarpe(ls_mensaje) then
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

public function string of_nomb_nave (string as_nave);string ls_result

SetNull(ls_result)
select nomb_nave
	into :ls_result
from tg_naves
where nave = :as_nave;

if IsNull(ls_result) then
	ls_result ='';
end if

return ls_result
end function

public subroutine of_set_nro_parte (string as_parte);is_nro_parte = as_parte
end subroutine

public subroutine of_set_tipo_flota (string as_tipo_flota);is_tipo_flota = as_tipo_flota
end subroutine

public subroutine of_set_nomb_nave (string as_nomb_nave);is_nomb_nave = as_nomb_nave
end subroutine

public function string of_get_cod_nave ();return is_nave
end function

public function string of_get_nomb_nave ();return is_nomb_nave
end function

public function string of_get_tipo_flota ();return is_tipo_flota
end function

public function string of_get_nomb_pto ();string ls_result

SetNull(ls_result)

select descr_puerto
	into :ls_result
from fl_puertos
where puerto = :is_puerto;

If IsNull(ls_result) then
	ls_result = ''
end if

return ls_result
end function

public subroutine of_find_datos_zarpe ();setNull(is_puerto)
SetNull(is_zona)

select puerto_zarpe, zona_pesca_zarpe
	into :is_puerto, :is_zona
from fl_parte_de_pesca
where parte_pesca = :is_nro_parte;

if IsNull(is_puerto) then
	is_puerto = ''
end if

if IsNull(is_zona) then
	is_zona = ''
end if

end subroutine

public function string of_get_cod_pto ();return is_puerto
end function

public function string of_get_cod_zona ();return is_zona

end function

public function boolean of_verif_reg_arribo (string as_registro);string ls_mensaje

// Esta funcion valida que el registro de Zarpe no se repita

if as_registro = is_registro then
	return true
end if

DECLARE usf_fl_verf_reg_arribo PROCEDURE FOR
	usf_fl_verf_reg_arribo( :as_registro );

EXECUTE usf_fl_verf_reg_arribo;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION usf_fl_verf_reg_arribo: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', SQLCA.SQLErrText)	
	Return false
END IF

FETCH usf_fl_verf_reg_arribo INTO :ls_mensaje;
CLOSE usf_fl_verf_reg_arribo;

if ls_mensaje <> "" then
	MessageBox('Error', ls_mensaje, StopSign!)	
	Return false
end if

return true
end function

public subroutine of_set_reg_arribo (string as_registro);is_registro = as_registro
end subroutine

public function string of_get_descr_zona (string as_zona);string ls_data
SetNull(ls_data)

select descr_zona
	into :ls_data
from tg_zonas_pesca
where zona_pesca = :as_zona;
			
if IsNull(ls_data) then
	ls_data = ""
end if

return ls_data
end function

public function string of_get_descr_situac (string as_codigo);string ls_data

SetNull(ls_data)
select descr_situacion
	into :ls_data
from fl_motivo_movimiento
where motivo_movimiento = :as_codigo;
			
if IsNull(ls_data) then
	ls_data = ""
end if

return ls_data
end function

public function string of_get_nomb_pto (string as_puerto);string ls_result

SetNull(ls_result)

select descr_puerto
	into :ls_result
from fl_puertos
where puerto = :as_puerto;

If IsNull(ls_result) then
	ls_result = ''
end if

return ls_result
end function

public function string of_get_nomb_nave (string as_nave);string ls_result

SetNull(ls_result)
select nomb_nave
	into :ls_result
from tg_naves
where nave = :as_nave;

if IsNull(ls_result) then
	ls_result =''
end if

return ls_result
end function

public function string of_get_descr_unidad (string as_unidad);string ls_data

SetNull(ls_data)
select desc_unidad
	into :ls_data
from unidad
where und = :as_unidad;
			
if IsNull(ls_data) then
	ls_data = ""
end if

return ls_data
end function

public function string of_get_cencos_nave (string as_nave);string ls_data

SetNull(ls_data)
select cencos
	into :ls_data
from tg_naves
where nave = :as_nave;

if IsNull(ls_data) then
	ls_data = ""
end if

return ls_data


end function

public function string of_get_tipo_flota (string as_nave);string ls_result

SetNull(ls_result)
Select flag_tipo_flota	
	into :ls_result
from tg_naves
where nave = :as_nave;

If IsNull(ls_result) then
	ls_result = ''
end if
return ls_result
end function

public function boolean of_valid_dat_zarpe (ref string as_mensaje);// Verifico REGISTRO_ARRIBO
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

public function boolean of_save_zarpe (ref string as_mensaje);integer li_ok

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

public function boolean of_valid_dat_arrib (ref string as_mensaje);// Verifico el codigo de la nave Real
if IsNull(is_nave) or trim(is_nave) = '' then
	as_mensaje = 'EL CODIGO DE LA NAVE REAL ESTA EN BLANCO'
   RETURN false
end if

// Verifico el codigo de la nave Real
if IsNull(is_naved) or trim(is_naved) = '' then
	as_mensaje = 'EL CODIGO DE LA NAVE DECLARADA ESTA EN BLANCO'
   RETURN false
end if

is_tipo_flota = of_get_tipo_flota( is_nave )

// Verifico REGISTRO_ARRIBO
if ( IsNull(is_registro) or trim(is_registro) = '') &
	and is_tipo_flota = "P" then
	
	as_mensaje = 'LA EMBARCACIÓN PROPIA DEBE TENER UN REGISTRO DE ARRIBO'
   RETURN false
	
end if

// Verifico REGISTRO_ARRIBO
//if ( IsNull(is_orden) or trim(is_orden) = '') &
//	and is_tipo_flota = "P" then
//	
//	as_mensaje = 'LA EMBARCACIÓN PROPIA DEBE TENER UNA ORDEN DE TRABAJO'
//   RETURN false
//	
//end if

// Verifico ORIGEN
if IsNull(is_origen) or trim(is_origen) = '' then
	as_mensaje = 'NO SE HA INGRESADO UN ORIGEN'
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
	as_mensaje = 'LA EMBARCACIÓN DEBE ARRIBAR POR ALGUN MOTIVO'
   RETURN false
end if

// Verifico TIPO DE PESCA
if IsNull(is_tpesca) or trim(is_tpesca) = '' then
	as_mensaje = 'NO SE HA ESPECIFICADO UN TIPO DE PESCA'
   RETURN false
end if

// Verifico TIPO DE PESCA
if IsNull(id_fecha1) then
	as_mensaje = 'SE DEBE TENER UNA FECHA Y HORA DE ARRIBO'
   RETURN false
end if

return true
end function

public function boolean of_save_arribo (ref string as_mensaje);integer li_ok

if ii_flag = 1 then
// Se va a insertar un nuevo arribo
	
//create or replace procedure usp_fl_insert_arribo(
//       asi_parte     in varchar2,
//       asi_origen    in varchar2,
//       asi_registro  in varchar2,
//       asi_naver     in varchar2, 
//       asi_naved     in varchar2, 
//       asi_puerto    in varchar2, 
//       asi_zona      in varchar2,
//       asi_situac    in varchar2,
//       asi_observ    in varchar2,
//       asi_regpos    in varchar2,
//       asi_tpesca    in varchar2,
//       asi_orden     in varchar2,
//       asi_aprobado  in varchar2,
//       adi_fecha     in date,
//       aso_parte     out varchar2,
//       aso_mensaje   out varchar2,
//       aio_ok        out number) is

	DECLARE usp_fl_insert_arribo PROCEDURE FOR
		usp_fl_insert_arribo( :is_nro_parte, :is_origen, 
		   :is_registro, :is_nave, :is_naved, :is_puerto, 
			:is_zona, :is_situac, :is_observ, :is_regpos, 
			:is_tpesca, :is_orden, :is_aprobado, :id_fecha1);

	EXECUTE usp_fl_insert_arribo;
	
	IF SQLCA.sqlcode = -1 THEN
		as_mensaje = "PROCEDURE USP_FL_INSERT_ARRIBO:" &
				  + SQLCA.SQLErrText
		Rollback;
		Return false
	END IF
	
	FETCH usp_fl_insert_arribo INTO :is_nro_parte, :as_mensaje, :li_ok;
	CLOSE usp_fl_insert_arribo;
	
else
	// Se va a actualizar un zarpe

//create or replace procedure usp_fl_update_arribo(
//       asi_parte     in varchar2,
//       asi_origen    in varchar2,
//       asi_registro  in varchar2,
//       asi_naver     in varchar2, 
//       asi_naved     in varchar2, 
//       asi_puerto    in varchar2, 
//       asi_zona      in varchar2,
//       asi_situac    in varchar2,
//       asi_observ    in varchar2,
//       asi_regpos    in varchar2,
//       asi_tpesca    in varchar2,
//       asi_orden     in varchar2,
//       asi_aprobado  in varchar2,
//       adi_fecha     in date,
//       aso_mensaje   out varchar2,
//       aio_ok        out number) is

	DECLARE usp_fl_update_arribo PROCEDURE FOR
		usp_fl_update_arribo( :is_nro_parte, :is_origen, :is_registro,
       	:is_nave, :is_naved, :is_puerto, :is_zona, :is_situac,
       	:is_observ, :is_regpos, :is_tpesca, :is_orden, :is_aprobado,
	      :id_fecha1 );

	EXECUTE usp_fl_update_arribo;
	
	IF SQLCA.sqlcode = -1 THEN
		as_mensaje = "PROCEDURE USP_FL_UPDATE_ARRIBO:" &
				  + SQLCA.SQLErrText
		Rollback;
		Return false
	END IF
	
	FETCH usp_fl_update_arribo INTO :as_mensaje, :li_ok;
	CLOSE usp_fl_update_arribo;

end if

if li_ok <> 1 then
	MessageBox('Error USP_FL_UPDATE_ARRIBO', as_mensaje, Information! )
	return false
end if

return true

end function

public function string of_find_zarpe_nave (string as_nave);// Esta funcion busca el numero de parte de la nave(as_nave)
// que no tiene arribo

string ls_parte

SetNull(ls_parte)

select parte_pesca
	into :ls_parte
from fl_parte_de_pesca
where nave_real = :as_nave
  and registro_arribo is null;

if IsNull(ls_parte) then
	ls_parte = ''
end if

return ls_parte
end function

public function string of_get_nomb_especie (string as_codigo);string ls_data

SetNull(ls_data)
select descr_especie
	into :ls_data
from TG_ESPECIES
where especie = :as_codigo;

if IsNull(ls_data) then
	ls_data = ""
end if
return ls_data

end function

public function string of_get_nomb_cliente (string as_codigo);string ls_data
SetNull(ls_data)

select nom_proveedor
	into :ls_data
from vw_fl_nomb_cliente
where cliente = :as_codigo;

if IsNull(ls_data) then
	ls_data = ""
end if

return ls_data
end function

public function string of_get_descr_moneda (string as_codigo);string ls_data
SetNull(ls_data)

select descripcion
	into :ls_data
from moneda
where cod_moneda = :as_codigo;
			
if IsNull(ls_data) then
	ls_data = ""
end if
return ls_data
end function

public function string of_get_descr_zona ();string ls_data
SetNull(ls_data)

select descr_zona
	into :ls_data
from tg_zonas_pesca
where zona_pesca = :is_zona;
			
if IsNull(ls_data) then
	ls_data = ''
end if

return ls_data
end function

public function boolean of_delete_arribo ();integer li_ok
string ls_mensaje

DECLARE usp_fl_delete_arribo PROCEDURE FOR
	usp_fl_delete_arribo( :is_nro_parte );

EXECUTE usp_fl_delete_arribo;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_DELETE_ARRIBO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_fl_delete_arribo INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_delete_arribo;

if li_ok <> 1 then
	MessageBox('Error en la elimimación', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

public function boolean of_delete_arribo (string as_nro_parte);is_nro_parte = as_nro_parte

return of_delete_arribo()
end function

public function string of_find_cargo_trip (string as_tripulante);string ls_data

select cargo_tripulante
	into :ls_data
from fl_tripulantes	
where tripulante = :as_tripulante;

If IsNull(ls_data) then
	ls_data = ""
end if
return ls_data
end function

public function string of_find_desc_cargo (string as_cargo);string ls_data

select descr_cargo
	into :ls_data
from fl_cargo_tripulantes
where cargo_tripulante = :as_cargo;

If IsNull(ls_data) then
	ls_data = ""
end if

return ls_data
end function

public subroutine of_asig_ot_nave (string as_orden, string as_nave);integer 	li_ok
string 	ls_mensaje

//create or replace procedure usp_fl_asign_ot_nave(
//		asi_orden 	in orden_trabajo.nro_orden%TYPE, 
//	  asi_nave 		in tg_naves.nave%TYPE,
//  	aso_mensaje out varchar2,
//    aio_ok      out number) is

DECLARE usp_fl_asign_ot_nave PROCEDURE FOR
	usp_fl_asign_ot_nave( :as_orden, :as_nave );

EXECUTE usp_fl_asign_ot_nave;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_asign_ot_nave: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_fl_asign_ot_nave INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_asign_ot_nave;

if li_ok <> 1 then
	MessageBox('Error al asignar la OT a la NAVE', ls_mensaje, StopSign!)	
	return
end if

return

end subroutine

public subroutine of_liberar_ot_nave (string as_orden, string as_nave);integer 	li_ok
string 	ls_mensaje

//create or replace procedure usp_fl_liberar_ot_nave(
//		asi_orden 	in orden_trabajo.nro_orden%TYPE, 
//	  asi_nave 		in tg_naves.nave%TYPE,
//  	aso_mensaje out varchar2,
//    aio_ok      out number) is

DECLARE usp_fl_liberar_ot_nave PROCEDURE FOR
	usp_fl_liberar_ot_nave( :as_orden, :as_nave );

EXECUTE usp_fl_liberar_ot_nave;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_liberar_ot_nave: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_fl_liberar_ot_nave INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_liberar_ot_nave;

if li_ok <> 1 then
	MessageBox('Error al asignar la OT a la NAVE', ls_mensaje, StopSign!)	
	return
end if

return

end subroutine

public function boolean of_save_arribo (string as_parte, string as_origen, string as_registro, string as_naver, string as_naved, string as_puerto, string as_zona, string as_situac, string as_observ, string as_regpos, string as_tpesca, string as_orden, string as_aprobado, datetime ad_fecha, integer ai_flag);string ls_mensaje
// Esta funcion ingresa el zarpe y returna true si lo hizo bien, de lo
// contrario retorna false

is_nro_parte= as_parte
is_origen   = as_origen
is_registro = as_registro
is_nave 		= as_naver
is_naved 	= as_naved
is_puerto	= as_puerto
is_zona		= as_zona
is_situac   = as_situac
is_observ   = as_observ
is_regpos   = as_regpos
is_tpesca   = as_tpesca
is_orden		= as_orden
is_aprobado = as_aprobado
id_fecha1	= ad_fecha
ii_flag		= ai_flag



if not of_valid_dat_arrib(ls_mensaje) then
	MessageBox('Error', ls_mensaje, StopSign!)
	return false
end if

if not of_save_arribo(ls_mensaje) then
	MessageBox('Error', ls_mensaje, StopSign!)
	return false
end if

return true
end function

public function boolean of_tripulante_zarpe (u_dw_abc adw_tripulantes, string as_nave, date ad_fecha);u_ds_base	lds_base
Long			ll_i, ll_row

try 
	lds_base = create u_ds_base
	lds_base.DataObject = 'd_lista_tripulantes_zarpe_tbl'
	lds_base.setTransobject( SQLCA )
	lds_base.retrieve(as_nave, ad_fecha)
	
	if lds_base.RowCount() = 0 then
		gnvo_app.of_message_error( "No existen registro de tripulantes de zarpe para la nave " + as_nave + " en la fecha " + string(ad_fecha, 'dd/mm/yyyy'))
		return false
	end if
	
	if adw_tripulantes.RowCount() > 0 then 
		if MessageBox('Informacion', 'Existen ' + string(adw_tripulantes.RowCount()) + " tripulantes ya registrados en el zarpe, desea que sean eliminados para pasar la asistencia seleccionada?", &
				Information!, Yesno!, 2) = 2 then return false
		
		do while adw_tripulantes.RowCount() > 0 
			adw_tripulantes.deleteRow(0)
		loop
		
	end if
	
	//Duplico la asistencia
	for ll_i = 1 to lds_base.RowCount()
		ll_row = adw_tripulantes.event ue_insert()
		
		if ll_row > 0 then
			adw_tripulantes.object.tripulante 		[ll_row] = lds_base.object.tripulante 			[ll_i]
			adw_tripulantes.object.nom_trabajador 	[ll_row] = lds_base.object.nom_trabajador 	[ll_i]
			adw_tripulantes.object.nro_censo 		[ll_row] = lds_base.object.libreta_embarque	[ll_i]
			adw_tripulantes.object.fec_vigencia 	[ll_row] = lds_base.object.fec_vigencia 		[ll_i]
			adw_tripulantes.object.cargo_tripulante[ll_row] = lds_base.object.cargo_tripulante 	[ll_i]
			adw_tripulantes.object.descr_cargo 		[ll_row] = lds_base.object.descr_cargo 		[ll_i]
		
		end if
	next
	
	return true
	
	
	
catch ( Exception ex )
	gnvo_App.of_catch_exception( ex, "")
	return false
finally
	if not IsNull(lds_base) and IsValid(lds_base) then
		destroy lds_base
	end if
end try

return true
end function

on uo_parte_pesca.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_parte_pesca.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

