$PBExportHeader$nvo_numeradores_varios.sru
forward
global type nvo_numeradores_varios from nonvisualobject
end type
end forward

global type nvo_numeradores_varios from nonvisualobject
end type
global nvo_numeradores_varios nvo_numeradores_varios

type variables
n_cst_wait	invo_wait
end variables

forward prototypes
public function boolean uf_num_ot (string as_origen, ref string as_nro_ot)
public function boolean uf_num_oper_sec (string as_origen, ref string as_nro_oper_sec)
public function boolean uf_num_parte (string as_origen, ref string as_nro_parte)
public function boolean uf_num_manten_prog (string as_origen, ref string as_nro_mant_prog)
public function boolean uf_num_solicitud_ot (string as_origen, ref string as_nro_solicitud)
public function boolean of_num_parte_empaque (string as_origen, string as_tabla, ref string as_nro_parte)
public function boolean of_nro_pallet (string as_origen, string as_nro_parte, ref string as_nro_pallet)
public function boolean of_crear_cajas (string as_origen, string as_nro_parte)
public function boolean of_nro_pallet (string as_origen, ref string as_nro_pallet)
public function boolean of_num_parte_envasado (string as_origen, string as_tabla, ref string as_nro_parte)
public function boolean of_num_codigo_cu (string as_origen, ref string as_codigo_cu)
end prototypes

public function boolean uf_num_ot (string as_origen, ref string as_nro_ot);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_CAM_NUM_OT PROCEDURE FOR USF_CAM_NUM_OT (:as_origen) ; 
EXECUTE PB_USF_CAM_NUM_OT ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de OT', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_CAM_NUM_OT INTO :as_nro_ot ;
CLOSE PB_USF_CAM_NUM_OT ;



Return lb_ret
end function

public function boolean uf_num_oper_sec (string as_origen, ref string as_nro_oper_sec);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_CAM_NUM_OPERACIONES PROCEDURE FOR USF_CAM_NUM_OPERACIONES (:as_origen) ; 
EXECUTE PB_USF_CAM_NUM_OPERACIONES ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Oper Sec', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_CAM_NUM_OPERACIONES INTO :as_nro_oper_sec ;

CLOSE PB_USF_CAM_NUM_OPERACIONES ;



Return lb_ret
end function

public function boolean uf_num_parte (string as_origen, ref string as_nro_parte);Boolean lb_ret = TRUE
String  ls_msj_err

//Recupero numero de ot 
DECLARE PB_USF_CAM_NUM_PARTE PROCEDURE FOR 
	USF_CAM_NUM_PARTE (:as_origen) ; 
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
DECLARE PB_USF_MTT_NUM_SOL PROCEDURE FOR USF_MTT_NUM_SOL (:as_origen) ; 
EXECUTE PB_USF_MTT_NUM_SOL ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Fallo el Numerador de Solicitud de OT', ls_msj_err)
	lb_ret = FALSE
END IF

FETCH PB_USF_MTT_NUM_SOL INTO :as_nro_solicitud ;

CLOSE PB_USF_MTT_NUM_SOL ;
 
RETURN lb_ret
end function

public function boolean of_num_parte_empaque (string as_origen, string as_tabla, ref string as_nro_parte);// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje
n_cst_utilitario 	lnvo_util


try 
	select count(*)
		into :ll_count
	from NUM_TABLAS
	where tabla	 = :as_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_TABLAS(tabla, origen, ult_nro)
		values( :as_tabla, :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_TABLAS
	where tabla  = :as_tabla
	  and origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando NRO DE PARTE para Parte de EMPAQUE " + string(ll_ult_nro) )
		
		if gnvo_app.of_get_parametro("PROD_NRO_PARTE_EMPAQUE_HEXADECIMAL", "0") = "1" then
			as_nro_parte = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		else
			as_nro_parte = trim(as_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		end if
		
		SELECT count(*)
			into :ll_count
		from tg_parte_empaque t
		where t.nro_parte = :as_nro_parte;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_TABLAS
		set ult_nro = :ll_ult_nro + 1
	where tabla  = :as_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean of_nro_pallet (string as_origen, string as_nro_parte, ref string as_nro_pallet);// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje, ls_tabla
n_cst_utilitario 	lnvo_util


try 
	//Tabla por defecto
	ls_tabla = 'NRO_PALLET'
	
	select count(*)
		into :ll_count
	from NUM_TABLAS
	where tabla	 = :ls_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_TABLAS(tabla, origen, ult_nro)
		values( :ls_tabla, :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_TABLAS
	where tabla  = :ls_tabla
	  and origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando NRO DE PALLET para Parte de EMPAQUE " + string(ll_ult_nro) )
		
		as_nro_pallet = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 13 - len(trim(as_origen)), '0')
		
		
		SELECT count(*)
			into :ll_count
		from tg_parte_empaque t
		where t.nro_pallet = :as_nro_pallet;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_TABLAS
		set ult_nro = :ll_ult_nro + 1
	where tabla  = :ls_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	update tg_parte_empaque
	   set nro_pallet = :as_nro_pallet
	where nro_parte	= :as_nro_parte;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla TG_PARTE_EMPAQUE. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Actualizo los cambios
	//commit;
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean of_crear_cajas (string as_origen, string as_nro_parte);// Numera documento
Long 		ll_count, ll_ult_nro, ll_i, ll_nro_item, ll_total_cajas, ll_diferencia
String  	ls_mensaje, ls_tabla, ls_codigo_cu
DEcimal	ldc_total_caja
n_cst_utilitario 	lnvo_util


try 
	//Tabla por defecto
	ls_tabla = 'CODIGO_CU_CAJA'
	
	//obtengo el total de cajas
	select total_caja
		into :ll_total_cajas
	from tg_parte_empaque
	where nro_parte = :as_nro_parte;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Si no hay cajas simplemente salgo del programa
	if ll_total_cajas = 0 then
		MessageBox('Error', 'No se ha ingresado ningún nro de cajas para el parte ' + as_nro_parte, StopSign!)
		return false
	end if
	
	//Obtengo el nro de cajas y el nro de item maximo
	select nvl(max(nro_item), 0), count(*)
		into :ll_nro_item, :ll_count
	from tg_parte_empaque_und
	where nro_parte = :as_nro_parte;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque_und. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	ll_diferencia = ll_total_cajas - ll_count
	
	if ll_Diferencia < 0 then
		MessageBox('Error', 'El total de cajas es menor al nro de cajas ya generadas para el parte Nro ' + as_nro_parte, StopSign!)
		return false
	end if
	
	//Si no hay cajas simplemente salgo del programa
	if ll_Diferencia = 0 then
		MessageBox('Error', 'Ya se han procesado la cantidad de cajas para el parte ' + as_nro_parte, StopSign!)
		return false
	end if
	
	for ll_i = 1 to ll_diferencia
		
		//Por cada registro genero el numerador
		select count(*)
			into :ll_count
		from NUM_TABLAS
		where tabla	 = :ls_tabla
		  and origen = :as_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		if ll_count = 0 then
			insert into NUM_TABLAS(tabla, origen, ult_nro)
			values( :ls_tabla, :as_origen, 1);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
				return false
			end if
		
		end if
		
		SELECT ult_nro
		  INTO :ll_ult_nro
		FROM NUM_TABLAS
		where tabla  = :ls_tabla
		  and origen = :as_origen for update;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		//Verifico que el numero del oper_sec no exista
		do
			invo_wait.of_mensaje( "Generando NRO DE CAJA " + string(ll_ult_nro) + " para Parte de EMPAQUE " + as_nro_parte )
			
			ls_codigo_cu = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 13 - len(trim(as_origen)), '0')
			
			
			SELECT count(*)
				into :ll_count
			from tg_parte_empaque_und t
			where t.CODIGO_CU = :ls_codigo_cu;
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque_und. Mensaje: " + ls_mensaje, StopSign!)
				return false
			end if
			
			if ll_count > 0 then 
				ll_ult_nro++ 
			end if
			
		loop while ll_count <> 0 
		
		update NUM_TABLAS
			set ult_nro = :ll_ult_nro + 1
		where tabla  = :ls_tabla
		  and origen = :as_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		//Actualizo el numero de item
		ll_nro_item ++
		
		insert into tg_parte_empaque_und(
			NRO_PARTE, NRO_ITEM, CODIGO_CU, FEC_REGISTRO, COD_USR, NRO_CAJA)
		values(
			:as_nro_parte, :ll_nro_item, :ls_codigo_cu, sysdate, :gs_user, :ll_ult_nro);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al realizar INSERT en tabla tg_parte_empaque_und. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		
	next
	
	
	//Actualizo los cambios
	commit;
	
	MessageBox('Aviso', "Se han procesado satisfactoriamente " + string(ll_diferencia) + " CAJAS", Information!)
		
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean of_nro_pallet (string as_origen, ref string as_nro_pallet);// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje, ls_tabla
n_cst_utilitario 	lnvo_util


try 
	//Tabla por defecto
	ls_tabla = 'NRO_PALLET'
	
	select count(*)
		into :ll_count
	from NUM_TABLAS
	where tabla	 = :ls_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_TABLAS(tabla, origen, ult_nro)
		values( :ls_tabla, :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_TABLAS
	where tabla  = :ls_tabla
	  and origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando NRO DE PALLET " + string(ll_ult_nro) )
		
		as_nro_pallet = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 13 - len(trim(as_origen)), '0')
		
		
		SELECT count(*)
			into :ll_count
		from tg_parte_empaque t
		where t.nro_pallet = :as_nro_pallet;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_TABLAS
		set ult_nro = :ll_ult_nro + 1
	where tabla  = :ls_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Actualizo los cambios
	//commit;
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean of_num_parte_envasado (string as_origen, string as_tabla, ref string as_nro_parte);// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje
n_cst_utilitario 	lnvo_util


try 
	select count(*)
		into :ll_count
	from NUM_TABLAS
	where tabla	 = :as_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_TABLAS(tabla, origen, ult_nro)
		values( :as_tabla, :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_TABLAS
	where tabla  = :as_tabla
	  and origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando NRO DE PARTE para Parte de ENVASADO " + string(ll_ult_nro) )
		
		if gnvo_app.of_get_parametro("PROD_NRO_PARTE_ENVASADO_HEXADECIMAL", "0") = "1" then
			as_nro_parte = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		else
			as_nro_parte = trim(as_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		end if
		
		SELECT count(*)
			into :ll_count
		from TG_PARTE_ENVASADO t
		where t.nro_parte = :as_nro_parte;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla TG_PARTE_ENVASADO. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_TABLAS
		set ult_nro = :ll_ult_nro + 1
	where tabla  = :as_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de PARTE para TG_PARTE_ENVASADO")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean of_num_codigo_cu (string as_origen, ref string as_codigo_cu);// Numera documento
Long 		ll_count, ll_ult_nro, ll_i, ll_nro_item, ll_total_cajas, ll_diferencia
String  	ls_mensaje, ls_tabla
DEcimal	ldc_total_caja
n_cst_utilitario 	lnvo_util


try 
	//Tabla por defecto
	ls_tabla = 'CODIGO_CU_CAJA'
	
	//Por cada registro genero el numerador
	select count(*)
		into :ll_count
	from NUM_TABLAS
	where tabla	 = :ls_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	if ll_count = 0 then
		insert into NUM_TABLAS(tabla, origen, ult_nro)
		values( :ls_tabla, :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_TABLAS
	where tabla  = :ls_tabla
	  and origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando NRO DE CAJA " + string(ll_ult_nro) )
		
		as_codigo_cu = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 13 - len(trim(as_origen)), '0')
		
		
		SELECT count(*)
			into :ll_count
		from tg_parte_empaque_und t
		where t.CODIGO_CU = :as_codigo_cu;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla tg_parte_empaque_und. Mensaje: " + ls_mensaje, StopSign!)
			return false
		end if
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_TABLAS
		set ult_nro = :ll_ult_nro + 1
	where tabla  = :ls_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Actualizo el numero de item
	ll_nro_item ++
	
	insert into tg_parte_empaque_und(
		 CODIGO_CU, FEC_REGISTRO, COD_USR, NRO_CAJA)
	values(
		:as_codigo_cu, sysdate, :gs_user, :ll_ult_nro);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar INSERT en tabla tg_parte_empaque_und. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

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

