$PBExportHeader$n_cst_seguridad.sru
forward
global type n_cst_seguridad from nonvisualobject
end type
end forward

global type n_cst_seguridad from nonvisualobject autoinstantiate
end type

type variables
string 	is_nom_usuario, is_xclavex
Integer	ii_desde_ult_cambio
n_cst_encriptor	invo_encriptor
n_cst_app_obj		invo_app
window				iw_parent
end variables

forward prototypes
public function integer of_validar_credenciales (string as_usuario, string as_clave)
end prototypes

public function integer of_validar_credenciales (string as_usuario, string as_clave);String 			ls_clave_db, ls_clave, ls_flag_estado, ls_mensaje
String			ls_origen_alt, ls_flag_origen
Long 				ll_rc, ll_timeout
Integer			li_nivel_log_objeto_usr, li_nivel_log_objeto_sis, li_desde_ult_cambio
Date				ld_fecha_ucc
DateTime 		ldt_Today
str_parametros lstr_param

SELECT u.clave, u.flag_estado, u.origen_alt, u.flag_origen, 
       u.timeout, nvl(u.nivel_log_objeto,0), nvl(fecha_ucc, SYSDATE),
		 u.nombre
	INTO :ls_clave_db, :ls_flag_estado, :ls_origen_alt, :ls_flag_origen, 
	     :ll_timeout, :li_nivel_log_objeto_usr, :ld_fecha_ucc,
		  :is_nom_usuario
	FROM usuario u
  WHERE u.cod_usr = :as_usuario ;

IF SQLCA.SQLCode < 0 THEN
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox("Error", "Error al obtener datos de la tabla usuario. Mensaje: " + ls_mensaje, Exclamation!)
	HALT CLOSE
END IF

	
IF SQLCA.SQLCode = 100 THEN
	MessageBox("Busqueda de Usuario", "Usuario " + as_usuario + " no existe, por favor verifique", StopSign!)
	return -1
END IF


IF ls_flag_estado <>'1' THEN
	MessageBox("Error", "Usuario " + as_usuario + " existente, pero esta Desactivado. SQLCode " &
			+ string(SQLCA.SQLCode) + " Estado: " + ls_flag_estado)
	return -1
END IF

ls_clave 	= Trim(as_clave)

//Guardo la clave encriptada
is_xclavex		= ls_clave_db

//Si la clave es distinta a x entonces la desencripto
IF Lower(ls_clave_db) <> 'x' THEN ls_clave_db = invo_encriptor.of_desencriptarJR(ls_clave_db)


IF Lower(ls_clave_db) <> Lower(ls_clave) THEN
	MessageBox("Password Error", "Error en la contraseña, por favor reintente nuevamente", Exclamation!)
	return -2
end if

// Asignar Origen Alterno
IF ls_flag_origen = 'A' THEN gs_origen = ls_origen_alt
gs_user = as_usuario
idle(ll_timeout)  // timeout

// Si la contraseña por defecto es 'x' entonces el usuario debe de cambiarla
if Lower(ls_clave) = 'x' then
	MessageBox('Aviso', 'El administrador del sistema le ha asignado ' &
					+ 'una contraseña temporal, debe cambiarla de inmediato para continuar trabajando...', Information!)
					
	Open(w_password_chg, iw_parent)
	
	If Message.PowerObjectparm.ClassName( ) <> 'str_parametros' then
		MessageBox('Error', 'Parametro de retorno no esperado', Exclamation!)
		HALT
	end if
	
	lstr_param = Message.PowerObjectparm
	
	if lstr_param.titulo = 'n' then
		MessageBox('Error', 'No puede iniciar el sistema hasta que haya cambiado su contraseña')
		HALT
	end if
	
end if

// Determinar Si debe grabarse el log 
gb_log_objeto = True

// Segun Parametros de Logon, controlar Cambio de Password
ldt_today = invo_app.of_fecha_Actual()

ii_desde_ult_cambio = DaysAfter(ld_fecha_ucc, Date(ldt_Today))


return 1
end function

on n_cst_seguridad.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_seguridad.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

