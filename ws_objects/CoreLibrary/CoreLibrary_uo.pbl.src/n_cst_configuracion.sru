$PBExportHeader$n_cst_configuracion.sru
forward
global type n_cst_configuracion from nonvisualobject
end type
end forward

global type n_cst_configuracion from nonvisualobject
end type
global n_cst_configuracion n_cst_configuracion

forward prototypes
public function string of_get_parameter (string as_param) throws exception
end prototypes

public function string of_get_parameter (string as_param) throws exception;/* Finalizacion de codigo pedido por gladys aranda*/
String ls_return, ls_mensaje
Exception ex

declare USF_GET_PARAMETER_STR procedure for 
	USF_GET_PARAMETER_STR(:as_param);

execute USF_GET_PARAMETER_STR;

if sqlca.sqlcode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	ex = create Exception
	ex.setMessage('Error en USF_GET_PARAMETER_STR: ' + ls_mensaje)
	throw ex
else
	fetch USF_GET_PARAMETER_STR into :ls_return;
end if

Close USF_GET_PARAMETER_STR;

return ls_return
end function

on n_cst_configuracion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_configuracion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

