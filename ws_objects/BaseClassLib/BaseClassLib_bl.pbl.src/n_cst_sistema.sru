$PBExportHeader$n_cst_sistema.sru
forward
global type n_cst_sistema from nonvisualobject
end type
end forward

global type n_cst_sistema from nonvisualobject
end type
global n_cst_sistema n_cst_sistema

type variables
Public:

String is_Codigo, is_descripcion, is_siglas, is_version, is_edicion

end variables

forward prototypes
public function boolean of_loaddatos (string as_codigo)
end prototypes

public function boolean of_loaddatos (string as_codigo);//Esta funcion carga los datos de la tabla sistema aplicativo mapeandolo
//a esta clase
String 					ls_flag_estado, ls_mensaje
n_cst_app_obj 			lnvo_app
n_cst_errorlogging 	lnvo_log
Exception				lex_error

lnvo_app = create n_cst_app_obj
lnvo_log = create n_cst_errorlogging
lex_error = create Exception

try
	select sistema, descripcion, siglas, flag_estado, version, edicion
		into 	:is_codigo, :is_descripcion, :is_siglas, :ls_flag_estado,
				:is_version, :is_edicion
	from sistema_aplicativo
	where sistema = :as_codigo;
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = lnvo_log.of_mensajedb( "No existe registro en Sistema_aplicativo para " &
								+ as_codigo)
	
		lex_error.setMessage( ls_mensaje )
		throw lex_error
		
		Return False
	end if
	
	if ls_flag_estado = '0' then
		ls_mensaje = lnvo_log.of_mensajedb( "la empresa " + as_codigo + " no se encuentra activo "&
			+ "en Sistema_aplicativo, por favor verifique")
	
		lex_error.setMessage( ls_mensaje )
		throw lex_error
		
		Return False
	end if
	
catch (Exception ex)
	lnvo_log.of_errorlog( ex.getMessage())
	lnvo_app.of_showmessagedialog( ex.getMessage())
	return false
finally
	destroy lnvo_app
	destroy lnvo_log
end try

return true

end function

on n_cst_sistema.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_sistema.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

