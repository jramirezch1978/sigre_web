$PBExportHeader$n_cst_numerador.sru
forward
global type n_cst_numerador from nonvisualobject
end type
end forward

global type n_cst_numerador from nonvisualobject autoinstantiate
end type

type variables
n_cst_wait	invo_wait
end variables

forward prototypes
public function boolean of_nro_zc_parte_ingreso (string as_origen, string as_tabla, ref string as_nro_parte)
end prototypes

public function boolean of_nro_zc_parte_ingreso (string as_origen, string as_tabla, ref string as_nro_parte);// Numera documento
Long 					ll_count, ll_ult_nro, ll_j
String  				ls_mensaje
n_cst_utilitario 	lnvo_util

try 
	Select count(*)
		into :ll_count 
	from num_tablas 
	where tabla = :as_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	
	if ll_count = 0 then
		Insert into num_tablas ( tabla, origen, ult_nro)
		values( :as_tabla, :as_origen, 1 );
			
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al insertar registro en num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_tablas 
	where tabla = :as_tabla
	  and origen = :as_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla num_tablas. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	//Verifico que el numero de la OT no exista
	do
		invo_wait.of_mensaje( "Generando numero de PARTE DE RECEPCION " + string(ll_ult_nro) )
		
		if gnvo_app.of_get_parametro("ZC_PARTE_RECEPCION_HEXADECIMAL", "1") = "1" then
			as_nro_parte = trim(as_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		else
			as_nro_parte = trim(as_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(as_origen)), '0')
		end if	
		
		SELECT count(*)
			into :ll_count
		from zc_parte_ingreso ot
		where ot.nro_parte = :as_nro_parte;
		
		if ll_count <> 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update num_tablas
		set ult_nro = :ll_ult_nro + 1
	where tabla = :as_tabla
	  and origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	return TRUE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en numerar PARTE DE RECEPCION')

finally
	invo_wait.of_close()	
end try

end function

on n_cst_numerador.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_numerador.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_Wait = create n_cst_wait
end event

event destructor;destroy invo_wait
end event

