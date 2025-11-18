$PBExportHeader$n_cst_caja_bancos.sru
forward
global type n_cst_caja_bancos from nonvisualobject
end type
end forward

global type n_cst_caja_bancos from nonvisualobject
end type
global n_cst_caja_bancos n_cst_caja_bancos

forward prototypes
public function Long of_nro_registro_cb (string as_origen) throws exception
end prototypes

public function Long of_nro_registro_cb (string as_origen) throws exception;Boolean 	lb_retorno = TRUE
Long		ll_nro
String	ls_mensaje
Exception ex

SELECT ult_nro 
	INTO :ll_nro 
FROM num_caja_bancos 
WHERE origen = :as_origen for update;

if SQLCA.SQLCode = 100 then
	insert into num_caja_bancos(origen, ult_nro)
	values(:as_origen, 1);
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = "SQL Error, al momento de insertar num_caja_bancos: " + SQLCA.SQLErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage(ls_mensaje)
		throw ex
	END IF	

	ll_nro = 1
end if

	
//*******************************//
//Actualiza Tabla num_caja_bancos//
//*******************************//

UPDATE num_caja_bancos
   SET ult_nro = :ll_nro + 1
 WHERE origen = :as_origen ;
	

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = "SQL Error, al momento de actualizar numerador en num_caja_bancos: " + SQLCA.SQLErrText
	ROLLBACK;
	ex = create Exception
	ex.setMessage(ls_mensaje)
	throw ex
END IF	

RETURN ll_nro	

end function

on n_cst_caja_bancos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_caja_bancos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

