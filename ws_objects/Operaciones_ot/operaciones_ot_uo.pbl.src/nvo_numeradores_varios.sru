$PBExportHeader$nvo_numeradores_varios.sru
forward
global type nvo_numeradores_varios from nonvisualobject
end type
end forward

global type nvo_numeradores_varios from nonvisualobject
end type
global nvo_numeradores_varios nvo_numeradores_varios

type variables
n_cst_wait			invo_wait
end variables

forward prototypes
public function boolean uf_num_ot (string as_origen, ref string as_nro_ot)
public function boolean uf_num_oper_sec (string as_origen, ref string as_nro_oper_sec)
public function boolean uf_num_parte (string as_origen, ref string as_nro_parte)
public function boolean uf_num_manten_prog (string as_origen, ref string as_nro_mant_prog)
public function boolean uf_num_solicitud_ot (string as_origen, ref string as_nro_solicitud)
public function boolean uf_num_reservados (string as_origen, ref string as_nro_ot)
end prototypes

public function boolean uf_num_ot (string as_origen, ref string as_nro_ot);// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje
n_cst_utilitario lnvo_util

try 
	select count(*)
		into :ll_count
	from NUM_ORD_TRAB
	where origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_ORD_TRAB. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_ORD_TRAB(origen, ult_nro)
		values( :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_ORD_TRAB. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_ORD_TRAB
	where origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_ORD_TRAB. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero de la OT no exista
	do
		invo_wait.of_mensaje( "Generando numero de OT " + string(ll_ult_nro) )
		
		if gnvo_app.of_get_parametro("OPER_OT_NRO_OT_HEXADECIMAL", "0") = "1" then
			as_nro_ot = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		else
			as_nro_ot = trim(as_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		end if	
		
		SELECT count(*)
			into :ll_count
		from orden_trabajo ot
		where ot.nro_orden = :as_nro_ot;
		
		if ll_count <> 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_ORD_TRAB
		set ult_nro = :ll_ult_nro + 1
	where origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_ORD_TRAB. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en numerar OT')

finally
	invo_wait.of_close()	
end try

end function

public function boolean uf_num_oper_sec (string as_origen, ref string as_nro_oper_sec);// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje
n_cst_utilitario 	lnvo_util


try 
	select count(*)
		into :ll_count
	from NUM_OPERACIONES
	where origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_OPERACIONES. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_OPERACIONES(origen, ult_nro)
		values( :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_OPERACIONES. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_OPERACIONES
	where origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_OPERACIONES. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando numero de Opersec " + string(ll_ult_nro) )
		
		if gnvo_app.of_get_parametro("ORDEN_TRABAJO_OPERSEC_HEXADECIMAL", "0") = "1" then
			as_nro_oper_sec = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		else
			as_nro_oper_sec = trim(as_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		end if
		
		SELECT count(*)
			into :ll_count
		from OPERACIONES ot
		where ot.oper_sec = :as_nro_oper_sec;
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_OPERACIONES
		set ult_nro = :ll_ult_nro + 1
	where origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_OPERACIONES. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean uf_num_parte (string as_origen, ref string as_nro_parte);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_CAM_NUM_PARTE PROCEDURE FOR USF_CAM_NUM_PARTE (:as_origen) ; 
EXECUTE PB_USF_CAM_NUM_PARTE ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Parte', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_CAM_NUM_PARTE INTO :as_nro_parte ;

CLOSE PB_USF_CAM_NUM_PARTE ;



Return lb_ret
end function

public function boolean uf_num_manten_prog (string as_origen, ref string as_nro_mant_prog);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_CAM_NUM_MANT_PROG PROCEDURE FOR USF_CAM_NUM_MANT_PROG (:as_origen) ; 
EXECUTE PB_USF_CAM_NUM_MANT_PROG ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Programa Trabajo', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_CAM_NUM_MANT_PROG INTO :as_nro_mant_prog ;

CLOSE PB_USF_CAM_NUM_MANT_PROG ;



Return lb_ret
end function

public function boolean uf_num_solicitud_ot (string as_origen, ref string as_nro_solicitud);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE USF_MTT_NUM_SOL PROCEDURE FOR 
	USF_MTT_NUM_SOL (:as_origen) ; 
EXECUTE USF_MTT_NUM_SOL ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Solicitud de OT', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH USF_MTT_NUM_SOL INTO :as_nro_solicitud ;

CLOSE USF_MTT_NUM_SOL ;
 
RETURN lb_ret
end function

public function boolean uf_num_reservados (string as_origen, ref string as_nro_ot);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_OPE_NUM_RESERVADOS PROCEDURE FOR USF_OPE_NUM_RESERVADOS (:as_origen) ; 
EXECUTE PB_USF_OPE_NUM_RESERVADOS ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Reservados', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_OPE_NUM_RESERVADOS INTO :as_nro_ot ;

CLOSE PB_USF_OPE_NUM_RESERVADOS ;

Return lb_ret
end function

on nvo_numeradores_varios.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_numeradores_varios.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_wait = create n_cst_wait
end event

event destructor;destroy invo_wait
end event

