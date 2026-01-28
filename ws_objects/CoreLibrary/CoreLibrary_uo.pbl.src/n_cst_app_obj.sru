$PBExportHeader$n_cst_app_obj.sru
$PBExportComments$funciones basicas para el aplication object
forward
global type n_cst_app_obj from nonvisualobject
end type
end forward

global type n_cst_app_obj from nonvisualobject
end type
global n_cst_app_obj n_cst_app_obj

type prototypes

end prototypes

type variables
Public:

string 	is_empresas_iniFile = "\sigre_exe\empresas.ini"


String   Is_estacion, is_user, is_help, is_origen, is_empresa, is_logo, &
			is_sistema, is_ruc, is_esquema, is_lpp, is_inifile, is_firma_digital, &
			is_db, is_telefono, is_noimagen, is_path_sigre
			
Integer  	ii_nivel, ii_control_db, ii_feriado[]
Date  		id_fecha
DateTime    idt_ingreso, idt_login
Boolean 		ib_log_objeto 

//Parametros de LogParam
String		is_soles, is_dolares, is_doc_oc, is_doc_ot, is_doc_ov, is_flag_valida_cbe, is_doc_gr, &
				is_doc_os, is_euros, is_doc_ost = 'OST'


//Parametros de Finparam
Decimal		idc_tasa_retencion, 	idc_monto_retencion

String		is_cnta_prsp_gfinan, 	is_doc_ret, 			is_agente_ret, 	is_flag_val_asiento, is_doc_ex, &
				is_doc_ncp, 				is_doc_cnc, 			is_cta_ctbl_gan,	is_cta_ctbl_per,		is_doc_og, &
				is_cnta_ctbl_ret_igv, 	is_FLAG_ENVIO_EMAIL, is_und_kg, 			is_und_ton,				is_und_hrs

//Variable para indicar si se ha iniciado sesion o no
Boolean		ib_session = false

//PArametro de empresa
Public:
n_cst_empresa		empresa
n_cst_finanzas		finparam
n_cst_rrhh			rrhhparam
n_cst_almacen		almacen
n_cst_utilitario 	utilitario
n_cst_efact			efact
n_cst_compras		logistica
n_cst_ventas		ventas
n_cst_flota			invo_flota

n_cst_wait			invo_wait
n_cst_regkey		invo_regkey
n_cst_encriptor  	invo_encriptor
n_cst_database		invo_database

//Otros parametros de utilidad
String 		is_crlf = char(13) + char(10)

//Parametros de Valor nulo
String 	is_null
integer	ii_null
Long		il_null
Date		id_null
DateTime	idt_null
Decimal	idc_null

//Utilitario
n_cst_inifile		invo_inifile


end variables

forward prototypes
public function integer of_set_login_log ()
public function integer of_open_db (transaction atr_obj, string as_file)
public function string of_get_sistema (string as_file)
public function long of_open_system (string as_inifile, integer ai_test, integer ai_control_db)
public function string of_get_origen (string as_file)
public function integer of_set_feriado ()
public function integer of_set_logout_log ()
public function integer of_get_parametro (string as_parametro, integer ai_default) throws exception
public function string of_get_parametro (string as_parametro, string as_default) throws exception
public function boolean of_prompt_value (string as_titulo, ref string as_value, string as_sql)
public function datetime of_fecha_actual (boolean ab_server)
public function boolean of_row_processing (u_dw_abc adw_id)
public function string of_direccion_origen (string as_origen)
public subroutine of_centrar (window aw_ventana)
public function datetime of_fecha_actual ()
public function date of_last_date (date ad_fecha)
public function boolean of_existserror (transaction as_trans)
public function long of_select_current_row (datawindow adw_1)
public function boolean of_existserror (transaction as_trans, string as_mensaje)
public function boolean of_prompt_value (string as_titulo, ref string as_value)
public function string of_email_user (string as_user, string as_origen)
public function boolean of_logparam ()
public function boolean of_finparam ()
public function integer of_nro_lineas (string as_tipo_doc, string as_origen)
public function decimal of_get_tipo_cambio (date ad_fecha)
public function decimal of_get_tipo_cambio () throws exception
public function boolean of_set_parametro (string as_parametro, string as_valor) throws exception
public function integer of_get_semana (date ad_fecha)
public subroutine of_get_fechas (integer ai_year, integer ai_semana, ref date ad_fecha1, ref date ad_fecha2) throws exception
public function str_maquinas of_get_maquina ()
public function n_cst_usuario of_create_usr (string as_user) throws exception
public subroutine of_load_param () throws exception
public subroutine of_catch_exception (exception ex, string as_url)
public subroutine of_mensaje_error (string as_mensaje, string as_url)
public subroutine of_mensaje_error (string as_mensaje)
public function date of_first_date (date ad_fecha)
public function string of_nombre_mes (integer li_mes)
public subroutine of_message_error (string as_mensaje)
public function decimal of_tasa_cambio_euro (date ad_fecha)
public function Long of_last_day (long al_mes, long al_year)
public function string of_get_message (string as_titulo, string as_default)
public function string of_set_numera (string as_origen, string as_tabla)
public function decimal of_get_parametro_dec (string as_parametro, decimal adc_default) throws exception
public function boolean of_add_mensaje_error (long al_row, string as_funcion, string as_objeto, string as_mensaje)
public function string of_left_trim (string as_cadena, string as_char)
public function boolean of_prompt_string (string as_titulo, ref string as_value)
public function decimal of_tasa_cambio ()
public function decimal of_tasa_cambio (date ad_fecha)
public function boolean of_prompt_number (string as_titulo, ref decimal adc_value)
public function String of_current_unidad ()
public subroutine of_mensaje_ok (string as_mensaje)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, string as_columna)
public function boolean of_get_rango (ref string as_nro_min, ref string as_nro_max)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, ref string as_string8, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, ref string as_string8, ref string as_string9, string as_columna)
public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, ref string as_string8, ref string as_string9, ref string as_string10, string as_columna)
public function integer of_get_print_size ()
public subroutine of_mensaje_sql (string as_mensaje, string as_sql)
public function boolean of_valida_sistema (string as_sistema, string as_user)
public function decimal of_tasa_cambio_vta (date ad_fecha)
public function decimal of_get_icbper (date adi_fec_emision) throws exception
public subroutine of_set_minidump_path (string as_path)
end prototypes

public function integer of_set_login_log ();DateTime		ldt_fecha
string 		ls_user_so, ls_mensaje
n_cst_api	lnvo_api


lnvo_api = CREATE n_cst_api
ls_user_so = lnvo_api.of_get_user( )
DESTROY lnvo_api

ldt_fecha = this.of_fecha_actual(true)

INSERT INTO "LOG_LOGIN"  
          ( "FECHA", "COD_USR", "SISTEMA", "ESTACION", "EMPRESA", "USER_SO")  
  VALUES ( :ldt_fecha, :gs_user, substr(:gs_sistema,1,8), :gs_estacion, :gs_empresa, :ls_user_so )  ;

gdt_ingreso = ldt_fecha
idt_login = ldt_fecha

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox ("Error", 'No se pudo grabar el Log Login al Iniciar. Mensaje de Error: ' + ls_mensaje, Exclamation!)
	return -1
end if

COMMIT ;

this.ib_Session = true

RETURN SQLCA.SQLCode
end function

public function integer of_open_db (transaction atr_obj, string as_file);Integer	li_rc = 1

atr_obj.DBMS       = ProfileString (as_file, "database", "dbms",       "")
atr_obj.logid      = ProfileString (as_file, "database", "logid",      "")
atr_obj.logpass    = ProfileString (as_file, "database", "LogPass", "*****")
atr_obj.servername = ProfileString (as_file, "database", "servername", "")
atr_obj.dbparm     = ProfileString (as_file, "database", "dbparm",     "")

CONNECT ;
IF atr_obj.sqlcode <> 0 THEN
   MessageBox ("No Pude Conectar a la Base de Datos", atr_obj.sqlerrtext)
	li_rc = -1
   HALT
END IF


RETURN li_rc
end function

public function string of_get_sistema (string as_file);RETURN ProfileString (as_file, "varios", "sistema", "TEST")
end function

public function long of_open_system (string as_inifile, integer ai_test, integer ai_control_db);String   ls_cmd, ls_empresa, ls_password, ls_pw_encrypt, &
			ls_dbms, ls_dbparm
boolean	lb_Exists = false
str_parametros lstr_param, lstr_return

// Objetos
n_cst_api				lnvo_api

try 
	if not FileExists ( as_inifile ) then
		MessageBox('Error', 'No Existe el Inifile: ' + as_inifile)
		return -1
	END IF
	
	lnvo_api = CREATE n_cst_api 
	
	// Determinar Empresa
	ls_cmd = CommandParm()
	IF Len(ls_cmd) > 0 THEN
		gs_empresa = ls_cmd
	ELSE
		gs_empresa = ProfileString (as_inifile, "Default", "Empresa","ninguno")
	END IF
	
	// Cargar Parametros Generales
	gs_estacion = lnvo_api.of_get_work_station()
	gs_sistema  = ProfileString (as_inifile, "varios", "sistema", "TEST")
	gs_help		= ProfileString (as_inifile, "Varios", "Help",  "")
	
		
	if FileExists( this.is_empresas_iniFile) then
		// Cargar Parametros Segun Empresa
		gs_logo		 = ProfileString (this.is_empresas_iniFile, "Logo", gs_empresa, "")
		gs_origen	= ProfileString (this.is_empresas_iniFile, "Origen", gs_empresa, "")
		
		lstr_param.i_test 		= ai_test
		lstr_param.i_control_db = ai_control_db
		lstr_param.s_iniFile 	= this.is_empresas_iniFile
		
		lb_Exists = true
		
	end if
	
	IF FileExists ( as_inifile ) and not lb_Exists THEN
	
		// Cargar Parametros Segun Empresa
		gs_logo		 = ProfileString (as_inifile, "Logo", gs_empresa, "")
		gs_origen	= ProfileString (as_inifile, "Origen", gs_empresa, "")
		
		lstr_param.i_test 		= ai_test
		lstr_param.i_control_db = ai_control_db
		lstr_param.s_iniFile 	= as_inifile
		
	END IF
	
	//Me conecto con la base de datos
	gs_db  			= ProfileString (is_empresas_iniFile, "BaseDatos", gs_empresa, "")
	gs_esquema    	= ProfileString (is_empresas_iniFile, "Esquema", gs_empresa, "")
	ls_password   	= ProfileString (is_empresas_iniFile, "Password", gs_empresa, "")
	ls_pw_encrypt 	= ProfileString (is_empresas_iniFile, "PW_ENCRYPT", gs_empresa, "0")
	
	//invo_encriptor.is_key = 'SigreEsUnaFilosofiaDeVidaSigreEsUnaFilosofiaDeVida'
	ls_dbms   		= ProfileString (is_empresas_iniFile, "database", "dbms", "")
	ls_dbparm 		= ProfileString (is_empresas_iniFile, "database", "dbparm", "")
	
	gs_lpp 			= ProfileString (is_empresas_iniFile, "Lectura_Pagina", gs_empresa, "N")
			
	// En caso de que el password este encriptado entonces lo desencripto
	if ls_pw_encrypt = '1' then
		ls_password = invo_encriptor.of_desencriptar( ls_password )
	end if
	
	invo_wait.of_mensaje("Conectandose con la base de datos")
	
	SQLCA.DBMS       = ls_dbms
	SQLCA.logid      = gs_esquema
	SQLCA.logpass    = ls_password
	SQLCA.servername = gs_db
	SQLCA.dbparm     = ls_dbparm
	CONNECT ;
	
	IF SQLCA.sqlcode <> 0 THEN
		MessageBox ("Logon/Open/ Sin Conneccion a la Base de Datos", &
					"Objeto: " + this.ClassName() + '~r~n' + &
					"DBMS: " + ls_dbms + '~r~n' + &
					"Esquema: " + gs_esquema + '~r~n' + &
					"Password: " + ls_password + '~r~n' + &
					"Base de datos: " + gs_db + '~r~n' + &
					"DBParm: " + ls_dbparm + '~r~n' + &
					"Mensaje de Error: " + SQLCA.sqlerrtext, StopSign!)
		DISCONNECT ;
		HALT
		
	END IF
	

	
	//VErifico la estructura de la base de datos
	invo_database.of_valida_database()
	
	//Verifico si existen sesiones activas o no
	if invo_regkey.of_existen_sesiones(gs_empresa) then
		OpenWithParm(w_lista_sesiones, lstr_param)
		
		//Si cancelo o salio del cuadro entonces simplemente tiene que salir el login normal
		lstr_return = Message.PowerObjectParm
		
		if not lstr_return.b_Return then
			OpenWithParm(w_logon, lstr_param)
			lstr_return = Message.PowerObjectParm
	
			if IsNull(lstr_return) or not lstr_return.b_return then return -1
		end if

	else
		
		OpenWithParm(w_logon, lstr_param)
		if ISNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return -1
		
		if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
			MessageBox('Error', 'La ventana w_logon no devolvió un parametro de tipo STR_PARAMETROS, por favor verifique!', StopSign!)
			return -1
		end if
		
		lstr_return = Message.PowerObjectParm
	
		if not lstr_return.b_return then return -1
		
	end if
	
	//----
	//Valido si tengo acceso al Modulo
	//----
	
	if not this.of_valida_sistema( gs_sistema, gs_user) then
		MessageBox('Error', 'El usuario ' + gs_user + ' no tiene acceso al sistema ' + gs_sistema + ', por favor verifique!', StopSign!)
		return -1
	end if
	
	invo_wait.of_mensaje("Cargando Parametros por EMPRESA")
	empresa.of_load(gs_empresa)
	
	//Cargo los parametros
	invo_wait.of_mensaje("Cargando Parametros de Logistica")
	//Cargo los parametros de Logparam
	of_logparam()
	Logistica.of_load()
	
	invo_wait.of_mensaje("Cargando Parametros de Finanzas")
	//Cargo los parametros de FinParam
	of_finParam()
	finparam.of_load( )
	
	invo_wait.of_mensaje("Cargando Parametros de RRHH")
	rrhhparam.load_param( )
	
	invo_wait.of_mensaje("Cargando Parametros de ALMACEN")
	this.almacen.of_load( )
	
	invo_wait.of_mensaje("Cargando Parametros de EFACT")
	efact.of_load( )
	
	invo_wait.of_mensaje("Cargando Parametros de VENTAS")
	ventas.of_load( )
	

	//Parametros generales guardados en la tabla configuración
	invo_wait.of_mensaje("Cargando Parametros generales de CONFIGURACION")
	this.of_load_param( )
	
	
	RETURN 1
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción al momento de abrir el sistema. Mensaje de error: ' &
						+ ex.getMessage() + ". Por favor verifique!", StopSign!)
	return -1
	
finally
	invo_wait.of_close()
	destroy lnvo_api
end try


end function

public function string of_get_origen (string as_file);RETURN ProfileString (as_file, "varios", "origen", "LM")
end function

public function integer of_set_feriado ();Integer	li_x, li_mes, li_dia
Long	ll_rc
Datastore	lds_feriado

lds_feriado = CREATE Datastore
lds_feriado.Dataobject = 'd_cal_feriado_ds'
lds_feriado.SetTransObject(SQLCA)
ll_rc = lds_feriado.Retrieve()

IF ll_rc < 0 THEN GOTO SALIDA

FOR li_x = 1 TO ll_rc
	li_mes = lds_feriado.GetItemNumber(li_x, 'mes')
	li_dia = lds_feriado.GetItemNumber(li_x, 'dia')
	// value = Month * 100 + Day
	gi_feriado[li_x] = li_mes *100 + li_dia
NEXT 



SALIDA:
RETURN ll_rc
end function

public function integer of_set_logout_log ();DateTime	ldt_logout
String	ls_mensaje

if IsNull(idt_login) or string(idt_login, 'dd/mm/yyyy') = '01/01/1900' then
	idt_login = gdt_ingreso
end if

if not this.ib_Session then return -1

ldt_logout = this.of_fecha_actual(true)

UPDATE LOG_LOGIN
   SET FECHA_FIN = :ldt_logout
 WHERE FECHA = :idt_login AND COD_USR = :gs_user;
 
 if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox ("Error", 'No se pudo grabar el Log Login al Cerrar. Mensaje de Error: ' + ls_mensaje)
	return -1
end if
  
COMMIT ;

RETURN SQLCA.SQLCode
end function

public function integer of_get_parametro (string as_parametro, integer ai_default) throws exception;String 	ls_mensaje
Integer	li_count, li_return
Exception ex

SELECT COUNT(*)
	INTO :li_count
FROM configuracion c
WHERE c.parametro = :as_parametro;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	ex = create Exception
	ex.setMessage("Error en of_get_parameter (Integer, default). No se pudo consultar la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
	throw ex
end if

IF li_count = 0 THEN
  	insert into configuracion(parametro, valor_int)
  	values( :as_parametro, :ai_default);
	  
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage("Error en of_get_parameter (Integer, default). No se pudo Insertar Registro en la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
		throw ex
	end if

	li_return = ai_default
	
	commit;
	
else
	SELECT valor_int
		INTO :li_return
	FROM configuracion c
	WHERE c.parametro = :as_parametro;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage("Error en of_get_parameter (Integer, default). No se pudo obtener el Valor del parametro en la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
		throw ex
	end if

END IF;

return li_return

end function

public function string of_get_parametro (string as_parametro, string as_default) throws exception;String 	ls_return, ls_mensaje
Integer	li_count
Exception ex

SELECT COUNT(*)
	INTO :li_count
FROM configuracion c
WHERE c.parametro = :as_parametro;

//VErifico que la consulta este correcta
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	ex = create Exception
	ex.setMessage("Error en of_get_parameter (String, default). No se pudo consulta la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
	throw ex
end if
  
IF li_count = 0 THEN
	insert into configuracion(parametro, valor_char)
	values( :as_parametro, :as_default);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage("Error en of_get_parameter (String, default). No se pudo Insertar Registro en la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
		throw ex
	end if

	ls_return = as_default
	
	commit;

else
	SELECT valor_char
		INTO :ls_return
	FROM configuracion c
	WHERE c.parametro = :as_parametro;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage("Error en of_get_parameter (String, default). No se pudo Obtener el valor del parametro de la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
		throw ex
	end if

END IF;




return ls_return	
end function

public function boolean of_prompt_value (string as_titulo, ref string as_value, string as_sql);str_parametros lstr_parametros

lstr_parametros.titulo 		= as_titulo
lstr_parametros.sql_text	= as_sql

OpenWithParm(w_prompt, lstr_parametros)
lstr_parametros = Message.PowerObjectParm

if lstr_parametros.i_return < 0 then return false

as_value = lstr_parametros.string1

return true
end function

public function datetime of_fecha_actual (boolean ab_server);Datetime ldt_fecha_actual

if ab_server then
	SELECT SYSDATE
	INTO   :ldt_fecha_actual
	FROM   DUAL ;
	
	IF SQLCA.SQLCode = -1 THEN 
		MessageBox('SQL error','Fecha Actual no ha sido Recuperada'+' '+SQLCA.SQLErrText)
	END IF
else
	ldt_fecha_actual = Datetime(today(),now())
end if




Return ldt_fecha_actual
end function

public function boolean of_row_processing (u_dw_abc adw_id);// Funcion que valida campos que son requeridos
// Argumentos:	ad_id	   Datawindow a verificar
//				   as_form   Tipo de form del dw
// Valor de Retorno: boolean

DwItemStatus 	l_rowstatus
Integer 			li_col
Long 				ll_row, ll_j, ll_k
String 			ls_colname, ls_campo

// Verifica todos los campos y valida en aquellos que son requeridos
For ll_j = 1 to adw_id.RowCount()
	l_rowStatus = adw_id.GetItemStatus( ll_j, 0, primary! )
	if l_rowStatus = NewModified! or l_rowstatus = DataModified! then
		
		ll_row = ll_j   // Numero de fila a evaluar
		li_col = 1   // numero de la columna a evaluar
		
		adw_id.FindRequired( primary!, ll_row, li_col, ls_colname, true )

		if ll_row = ll_j then
			// Encuentra el texto del campo seleccionado
			ls_campo = ls_colname + "_t.text"
			ls_campo = adw_id.describe( ls_campo )
			if ls_campo <> '!' then
				Messagebox( "Error", "Campo Requerido en " + ls_campo, stopsign!)
			else
				Messagebox( "Error", "Campo Requerido en " + ls_colname, stopsign!)
			end if
			
			adw_id.ScrollToRow( ll_j )
			if adw_id.is_dwform <> 'form' then
				this.of_select_current_row(adw_id)
			end if
			adw_id.SetColumn( ls_colname )
			adw_id.SetFocus()
			Return False		
		end if	
	end if	
Next
Return true
end function

public function string of_direccion_origen (string as_origen);// funcion que devuelve la direccion de la empresa
String 	ls_dir, ls_calle, ls_numero, ls_lote, ls_mnz, ls_urb, ls_distrito, &
			ls_provincia, ls_dpto, ls_cod_postal

Select NVL(dir_calle,''),     NVL(dir_numero,''),        NVL(dir_lote, ''),
		NVL(dir_mnz, '') ,     NVL(dir_urbanizacion, ''), NVL(dir_distrito,''),
		 NVL(dir_provincia,''), NVL(dir_departamento,''),  NVL(dir_cod_postal,'')
 INTO :ls_calle,              :ls_numero,                 :ls_lote,
		:ls_mnz,                :ls_urb,                    :ls_distrito,
		:ls_provincia,          :ls_dpto,                   :ls_cod_postal
from origen
where cod_origen = :as_origen;

ls_dir = ''
if len(ls_calle)      <> 0 then ls_dir += ls_calle + ' '  
if len(ls_numero)     <> 0 then ls_dir += ls_numero + ' ' 
if len(ls_lote)       <> 0 then ls_dir += ls_lote + ' '   
if len(ls_mnz)        <> 0 then ls_dir += ls_mnz + ' '    
if len(ls_urb)        <> 0 then ls_dir += ls_urb + ' '    
if len(ls_distrito)   <> 0 then ls_dir += ls_distrito + ' ' 
if len(ls_provincia)  <> 0 then ls_dir += ls_provincia + ' ' 
if len(ls_dpto)       <> 0 then ls_dir += ls_dpto + ' ' 
if len(ls_cod_postal) <> 0 then ls_dir += ls_cod_postal + ' ' 

Return ls_dir
end function

public subroutine of_centrar (window aw_ventana);// Funcion de centrado de ventanas
// Argumentos:	aw_ventana	Ventana a centrar
// Valor de Retorno: ninguno

Long ll_Width_main, ll_Height_main, ll_x, ll_y

ll_Width_main = w_main.workSpaceWidth()				// Ancho de ventana principal
ll_Height_main = w_main.WorkSpaceHeight() - 150	   // Altura de ventana principal

ll_x = ( ll_Width_main / 2 ) - ( aw_Ventana.Width  / 2)  
ll_y = ( ll_Height_main / 2 ) - ( aw_Ventana.Height / 2)

aw_Ventana.Move( ll_x, ll_y)	
end subroutine

public function datetime of_fecha_actual ();Return this.of_fecha_actual(true)
end function

public function date of_last_date (date ad_fecha);Integer 	li_mes, li_year
Date		ld_fecha

li_year 	= Integer(String(ad_fecha, 'yyyy'))
li_mes 	= Integer(String(ad_fecha, 'mm'))

if li_mes = 12 then
	li_mes = 1
	li_year += 1
else
	li_mes += 1
end if

ld_fecha = Date('01/' + String(li_mes, '00') + '/' + String(li_year, '0000'))

return RelativeDate(ld_fecha, -1)
end function

public function boolean of_existserror (transaction as_trans);String ls_mensaje

if as_trans.SQLCode < 0 then
	ls_mensaje = as_trans.SQLErrText
	ROLLBACK;
	f_mensaje('Error al ejecutar Setencia en Servidor: ' + ls_mensaje, '')
	return true
end if

return false
end function

public function long of_select_current_row (datawindow adw_1);/////////////////////////////////////////////////////////////////
//
// Purpose:
// Will select the row of the datawindow that
// is the current row.
//
// Must pass a datawindow to the function of 
// which you want the current row selected.
//
// Will return the row number of the current
// row.
//
/////////////////////////////////////////////////////////////////


long 	ll_currentrow

ll_currentrow = adw_1.GetRow()

IF ll_currentrow > 0 then
	//change redraw to avoid flicker
	adw_1.setredraw(false)
	
	adw_1.SelectRow(0,False)
	adw_1.SelectRow(ll_currentrow,True)
	adw_1.setfocus()

	adw_1.setredraw(true)
END IF
return ll_currentrow
end function

public function boolean of_existserror (transaction as_trans, string as_mensaje);String ls_mensaje

if as_trans.SQLCode < 0 then
	ls_mensaje = as_trans.SQLErrText
	ROLLBACK;
	f_mensaje("Error " + as_mensaje + ": " + ls_mensaje, '')
	return true
end if

return false
end function

public function boolean of_prompt_value (string as_titulo, ref string as_value);return this.of_prompt_value(as_titulo, as_value, '')
end function

public function string of_email_user (string as_user, string as_origen);String ls_email
/*
	Cambio Solicitado por PEZEX, 
	25/10/2012, Que tome el email del usuario, si no existe entonces se toma el email de la empresa
*/

Select email 
	into :ls_email 
from usuario
where cod_usr = :as_user;

if SQLCA.SQLCode = 100 or IsNull(ls_email) or ls_email = '' then
	Select email 
		into :ls_email 
	from origen
	where cod_origen = :as_origen;
end if

if Not IsNull(ls_email) then ls_email = 'Email: ' + ls_email

Return ls_email
end function

public function boolean of_logparam ();select 	cod_soles, cod_dolares, doc_ov, doc_oc, doc_ot, NVL(flag_centro_benef,'0'), doc_gr,
		 	doc_os
	into 	:is_soles, :is_dolares, :is_doc_ov, :is_doc_oc, :is_doc_ot, :is_flag_valida_cbe, :is_doc_gr,
			:is_doc_os
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	f_mensaje("No se ha especificado parametros en Logparam, por favor verifique!", "")
	return false
end if

if IsNull(is_soles) or is_soles = "" then
	f_mensaje("No se ha especificado cod_soles en logparam, por favor verifique!", "")
	return false
end if

if IsNull(is_dolares) or is_dolares = "" then
	f_mensaje("No se ha especificado cod_dolares en logparam, por favor verifique!", "")
	return false
end if

if IsNull(is_doc_ov) or is_doc_ov = "" then
	f_mensaje("No se ha especificado doc_ov en logparam, por favor verifique!", "")
	return false
end if

if IsNull(is_doc_oc) or is_doc_oc = "" then
	f_mensaje("No se ha especificado doc_oc en logparam, por favor verifique!", "")
	return false
end if

if IsNull(is_doc_ot) or is_doc_ot = "" then
	f_mensaje("No se ha especificado doc_ot en logparam, por favor verifique!", "")
	return false
end if

if IsNull(is_doc_gr) or is_doc_gr = "" then
	f_mensaje("No se ha especificado DOC_GR en logparam, por favor verifique!", "")
	return false
end if

select 	und_tm, und_kg
	into 	:is_und_ton, :is_und_kg
from ap_param
where origen = 'XX';


return true
end function

public function boolean of_finparam ();select 	porc_ret_igv,					cntas_prsp_gfinan,					doc_ret_igv_crt, 	NVL(flag_retencion,'0'),
			NVL(imp_min_ret_igv, 700), NVL(FLAG_VALIDAR_ASIENTO, '0'), 	doc_ex,
			cnta_ctbl_dc_ganancia,		cnta_ctbl_dc_perdida,				doc_sol_giro,		cnta_cntbl_ret_igv
	into 	:idc_tasa_retencion,			:is_cnta_prsp_gfinan,				:is_doc_ret, 		:is_agente_ret,
			:idc_monto_retencion, 		:is_flag_val_asiento, 				:is_doc_ex,
			:is_cta_ctbl_gan,				:is_cta_ctbl_per,						:is_doc_og,			:is_cnta_ctbl_ret_igv
from finparam 
where reckey = '1' ;

//Nota de Credito para no domiciliados
is_doc_cnc = 'CNC'
is_doc_ncp = 'NCP'

return true
end function

public function integer of_nro_lineas (string as_tipo_doc, string as_origen);Integer li_return

//VERIFICAR NRO DE LINEAS EN LA IMPRESION
select NVL(nro_lineas,100)
	into :li_return 
from doc_tipo_origen 
 where tipo_doc   = :as_tipo_doc   
	and cod_origen = :as_origen;

if SQLCA.SQLCode = 100 then
	li_return = 0
end if

return li_return
end function

public function decimal of_get_tipo_cambio (date ad_fecha);// Verifica que tipo de cambio exista
Decimal ld_cambio
Integer	li_count


Select count(*)
  into :li_count
  from calendario 
 where TRUNC(fecha) = trunc(:ad_fecha);
 
if li_count > 1 then
	MessageBox('Error', 'Se han registrado mas de dos tipos de cambio diferentes para el día ' + string(ad_fecha, 'dd/mm/yyyy') + ' por favor verificar y corregir')
	return -1
end if

Select NVL(cmp_dol_prom,0)
  into :ld_cambio 
  from calendario 
 where TRUNC(fecha) = :ad_fecha;

if sqlca.sqlcode < 0 then
	ROLLBACK;
	Messagebox( "Error en " + this.ClassName() + ".of_get_tipo_cambio()", "Error al consultar la tabla calendario: " + sqlca.sqlerrtext)
	Return 0
end if

if sqlca.sqlcode = 100 then
	select NVL(ULT_TIPO_CAM,0)
		into :ld_cambio
	from logparam
	where reckey = '1';
	
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		Messagebox( "Error", "No ha definido ningun parametro en logparam")		
		return 0
	end if
	
	if ld_cambio = 0 or isnull( ld_cambio) then
		ROLLBACK;
		Messagebox( "Error Logparam", "Tasa de cambio en Logparam no debe ser Cero" )
		return 0
	end if
end if

if ld_cambio = 0 or isnull( ld_cambio) then
	ROLLBACK;
	Messagebox( "Error Compra Dolares Promedio", "Tasa de cambio no debe ser Cero~r~nPara el dia " + String( ad_fecha) )
	return 0
end if

Return ld_cambio
end function

public function decimal of_get_tipo_cambio () throws exception;// Verifica que tipo de cambio exista
date ld_fecha

ld_fecha = DAte(this.of_fecha_actual( ))

Return this.of_get_tipo_cambio (ld_fecha)
end function

public function boolean of_set_parametro (string as_parametro, string as_valor) throws exception;String 	ls_return, ls_mensaje
Integer	li_count
Exception ex

SELECT COUNT(*)
	INTO :li_count
FROM configuracion c
WHERE c.parametro = :as_parametro;
  
IF li_count = 0 THEN
  	insert into configuracion(parametro, valor_char)
  	values( :as_parametro, :as_valor);
  
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		ex = create Exception
		ex.SetMessage("Error en of_set_parametro, " &
						+ "no se ha podido INSERTAR en tabla configuracion. " &
						+ "Mensaje: " + ls_mensaje)
		throw ex
  	end if
	  
else
	update configuracion c
	   set c.valor_char = :as_valor
	WHERE c.parametro = :as_parametro;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		ex = create Exception
		ex.SetMessage("Error en of_set_parametro, " &
						+ "no se ha podido ACTUALIZAR en tabla configuracion. " &
						+ "Mensaje: " + ls_mensaje)
		throw ex
  	end if
	  
END IF;

return true


end function

public function integer of_get_semana (date ad_fecha);integer li_semana

select semana
 	into :li_semana
from semanas
where :ad_fecha between fecha_inicio and fecha_fin;

return li_semana
end function

public subroutine of_get_fechas (integer ai_year, integer ai_semana, ref date ad_fecha1, ref date ad_fecha2) throws exception;Exception ex

select fecha_inicio, fecha_fin
	into :ad_fecha1, :ad_fecha2
from semanas
where ano 	 = :ai_year
  and semana = :ai_semana;
  
if SQLCA.SQLCode = 100 then
	ex = create Exception
	ex.setMessage( "No existe la semana " + string(ai_year, '0000') + "-" + string(ai_semana, '00') + " en la tabla semanas, por favor verificar y crearla en caso no exista")
	throw ex
	return
end if


end subroutine

public function str_maquinas of_get_maquina ();str_maquinas lstr_return
str_parametros lstr_param

lstr_param.dw1 	= 'd_maquinas_tv'
lstr_param.titulo = 'LISTADO DE MAQUINAS Y/O EQUIPOS'
lstr_param.opcion	= 2

OpenWithParm(w_search_tv, lstr_param)

if IsValid(Message.PowerObjectParm) and not isNull(Message.PowerObjectParm) then
	lstr_return = Message.PowerObjectParm
else
	lstr_return.b_return = false
end if

return lstr_return
end function

public function n_cst_usuario of_create_usr (string as_user) throws exception;n_cst_usuario lnvo_usuario
Exception		lnvo_exception

//lnvo_usuario = create n_cst_usuario

lnvo_usuario.of_fill_from_usuario( as_user )

return lnvo_usuario
end function

public subroutine of_load_param () throws exception;this.is_FLAG_ENVIO_EMAIL 	= gnvo_app.of_get_parametro( "FLAG_ENVIO_EMAIL", "1")
this.is_und_hrs				= gnvo_app.of_get_parametro( "UND_HORAS", "HRS")
this.is_euros					= gnvo_app.of_get_parametro( "MONEDA_EUROS", "EU")

is_noimagen = 'C:\SIGRE\resources\PNG\noimage.png'

is_empresas_iniFile = this.of_current_unidad() + "\sigre_exe\empresas.ini"

invo_inifile.of_set_inifile(is_empresas_iniFile)
	
this.is_path_sigre	= invo_inifile.of_get_parametro( "SIGRE_EXE", "PATH_SIGRE", "i:\SIGRE_EXE\")

//Si no termina con la barra invertida entonces lo agrego
if right(this.is_path_sigre, 1) <> '\' then
	this.is_path_sigre += '\'
end if

return
end subroutine

public subroutine of_catch_exception (exception ex, string as_url);str_parametros lstr_param

lstr_param.string1 = "Ha ocurrido una exception, Mensaje de Error: " + ex.getMessage() + ". Por favor verifique!"
lstr_param.string2 = as_URL

OpenwithParm(w_message_error, lstr_param)
end subroutine

public subroutine of_mensaje_error (string as_mensaje, string as_url);str_parametros lstr_param

lstr_param.string1 = as_mensaje
lstr_param.string2 = as_URL

OpenwithParm(w_message_error, lstr_param)
end subroutine

public subroutine of_mensaje_error (string as_mensaje);str_parametros lstr_param

lstr_param.string1 = as_mensaje
lstr_param.string2 = "http://sigre.serveftp.com:81"

OpenwithParm(w_message_error, lstr_param)
end subroutine

public function date of_first_date (date ad_fecha);Integer 	li_mes, li_year
Date		ld_fecha

li_year 	= Integer(String(ad_fecha, 'yyyy'))
li_mes 	= Integer(String(ad_fecha, 'mm'))

ld_fecha = Date('01/' + String(li_mes, '00') + '/' + String(li_year, '0000'))

return ld_fecha
end function

public function string of_nombre_mes (integer li_mes);string ls_return

choose case li_mes
	case 1
		ls_return = 'Enero'
	case 2
		ls_return = 'Febrero'
	case 3
		ls_return = 'Marzo'
	case 4
		ls_return = 'Abril'
	case 5
		ls_return = 'Mayo'
	case 6
		ls_return = 'Junio'
	case 7
		ls_return = 'Julio'
	case 8
		ls_return = 'Agosto'
	case 9
		ls_return = 'Setiembre'
	case 10
		ls_return = 'Octubre'
	case 11
		ls_return = 'Noviembre'
	case 12
		ls_return = 'Diciembre'
		
end choose

return ls_return

end function

public subroutine of_message_error (string as_mensaje);str_parametros lstr_param

lstr_param.string1 = as_mensaje
lstr_param.string2 = "http://sigre.serveftp.com:81"

OpenwithParm(w_message_error, lstr_param)
end subroutine

public function decimal of_tasa_cambio_euro (date ad_fecha);// Verifica que tipo de cambio exista
Decimal 	ldc_cambio
Integer	li_count


Select count(*)
  into :li_count
  from calendario 
 where TRUNC(fecha) = trunc(:ad_fecha);
 
if li_count > 1 then
	MessageBox('Error', 'Se han registrado mas de dos tipos de cambio diferentes para el día ' + string(ad_fecha, 'dd/mm/yyyy') + ' por favor verificar y corregir')
	return -1
end if

Select NVL(vta_eur_bnc,0)
  into :ldc_cambio 
  from calendario 
 where TRUNC(fecha) = :ad_fecha;

if sqlca.sqlcode < 0 then
	ROLLBACK;
	Messagebox( "Error en consulta a tabla calendario",  "Error: " + sqlca.sqlerrtext)
	Return 0
end if

if sqlca.sqlcode = 100 then
	select NVL(vta_eur_bnc,0)
		into :ldc_cambio
	from calendario
	where vta_eur_bnc is not null
	  and rownum = 1
	order by fecha desc;
	
	if SQLCA.SQLCode = 100 or ldc_cambio = 0 then
		Messagebox( "Error", "No ha definido ningun parametro en logparam")		
		return 0
	end if
	
end if

if ldc_cambio = 0 or isnull( ldc_cambio) then
	Messagebox( "Error " + this.ClassName() + ".of_tasa_cambio_eur()", &
					"Tasa de cambio del Euro no debe ser Cero~r~nPara el dia " + String( ad_fecha) )
	return 0
end if

Return ldc_cambio
end function

public function Long of_last_day (long al_mes, long al_year);Integer	li_mes, li_year
Date		ld_fecha

li_year 	= al_year
li_mes 	= al_mes

if li_mes = 12 then
	li_mes = 1
	li_year += 1
else
	li_mes += 1
end if

ld_fecha = Date('01/' + String(li_mes, '00') + '/' + String(li_year, '0000'))

ld_fecha = RelativeDate(ld_fecha, -1)

return Long(String(ld_fecha, 'dd'))
end function

public function string of_get_message (string as_titulo, string as_default);// Para la descripcion de la Factura
str_parametros lstr_param

lstr_param.string1   = as_titulo
lstr_param.string2	 = as_default

OpenWithParm( w_descripcion_fac, lstr_param)

IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
IF lstr_param.titulo = 's' THEN
	return lstr_param.string3
else
	return ''
END IF
end function

public function string of_set_numera (string as_origen, string as_tabla);//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro

if as_tabla = '' or Isnull(as_tabla) then
	MessageBox('Error', 'No ha especificado una tabla a actualizar para el datawindows maestro, por favor verifique!')
	return gnvo_app.is_null
end if

Select ult_nro 
	into :ll_ult_nro 
from num_tablas 
where origen = :as_origen
  and tabla	 = :as_tabla for update;

IF SQLCA.SQLCode = 100 then
	ll_ult_nro = 1
	
	Insert into num_tablas (origen, tabla, ult_nro)
		values( :as_origen, :as_tabla, 1);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al insertar registro en num_tablas', 'Error: ' + ls_mensaje)
		return gnvo_app.is_null
	end if
end if

//Asigna numero a cabecera
ls_nro = TRIM(gs_origen) + trim(string(ll_ult_nro, '00000000'))

//Incrementa contador
Update num_tablas 
	set ult_nro = :ll_ult_nro + 1 
 where origen = :as_origen
  and tabla	  = :as_tabla;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al actualizar num_tablas', 'Error: ' + ls_mensaje)
	return gnvo_app.is_null
end if
		
return ls_nro
end function

public function decimal of_get_parametro_dec (string as_parametro, decimal adc_default) throws exception;String 	ls_mensaje
Integer	li_count
decimal	ldc_return
Exception ex

SELECT COUNT(*)
	INTO :li_count
FROM configuracion c
WHERE c.parametro = :as_parametro;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	ex = create Exception
	ex.setMessage("Error en of_get_parameter (Decimal, default). No se pudo consultar la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
	throw ex
end if

  
IF li_count = 0 THEN
  	insert into configuracion(parametro, valor_dec)
  	values( :as_parametro, :adc_default);
	  
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage("Error en of_get_parameter (Decimal, default). No se pudo Insertar el parametro en la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
		throw ex
	end if
	
	ldc_return = adc_default
	
	commit;
  
	
else
	SELECT valor_dec
		INTO :ldc_return
	FROM configuracion c
	WHERE c.parametro = :as_parametro;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex = create Exception
		ex.setMessage("Error en of_get_parameter (Decimal, default). No se pudo Obtener el valor del parametro en la tabla CONFIGURACION. Mensaje: " + ls_mensaje)
		throw ex
	end if

END IF

return ldc_return

end function

public function boolean of_add_mensaje_error (long al_row, string as_funcion, string as_objeto, string as_mensaje);if IsNull(w_messages_error) or not IsValid(w_messages_error) then
	Open(w_messages_error)
end if

yield()
w_messages_error.event ue_add_record(al_row, as_funcion, as_objeto, as_mensaje)
yield()

return true
end function

public function string of_left_trim (string as_cadena, string as_char);String 	ls_return
Long		ll_i, ll_longitud

ls_return = as_cadena

do while left(ls_return, 1) = as_char 
	ls_return = mid(ls_return, 2)
loop


return ls_return
end function

public function boolean of_prompt_string (string as_titulo, ref string as_value);// Para la descripcion de la Factura
str_parametros lstr_param

lstr_param.titulo   	= as_titulo
lstr_param.string1	= as_value

OpenWithParm( w_prompt_string, lstr_param)

If isNull(message.PowerObjectParm) or not isValid(Message.PowerObjectParm) then return false

lstr_param = message.PowerObjectParm			

IF not lstr_param.b_return THEN return false

as_value = lstr_param.string1
return true

end function

public function decimal of_tasa_cambio ();Decimal ldc_tasa_cambio
Date		ld_fecha

ld_fecha = Date(this.of_fecha_actual())

SELECT vta_dol_prom
  INTO :ldc_tasa_cambio
  FROM calendario
 WHERE trunc(fecha) = :ld_fecha;   

 
IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	ROLLBACK;
	Messagebox('Aviso','No existe Tasa de Cambio del Dia ' + string(ld_fecha, 'dd/mm/yyyy') + ' de Hoy Verifique!')	
	return -1
END IF

Return ldc_tasa_cambio
end function

public function decimal of_tasa_cambio (date ad_fecha);Decimal 	ldc_tasa_cambio
Integer	li_count
String	ls_mensaje

Select count(*)
  into :li_count
  from calendario 
 where TRUNC(fecha) = trunc(:ad_fecha);
 
if li_count > 1 then
	ROLLBACK;
	MessageBox('Error', 'Se han registrado mas de dos tipos de cambio diferentes para el día ' &
							 + string(ad_fecha, 'dd/mm/yyyy') + ', por favor verificar y corregir')
	return -1
end if

IF li_count = 0 THEN
	ROLLBACK;
	Messagebox('Aviso','No existe Tasa de Cambio del Dia ' + string(ad_fecha, 'dd/mm/yyyy') &
						  + ', por favor coordine con CONTABILIDAD!')	
	return -1
END IF

SELECT vta_dol_prom
  INTO :ldc_tasa_cambio
  FROM calendario
 WHERE trunc(fecha) = :ad_fecha;   


if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al consultar el tipo de cambio VENTA ' &
							+ 'de la tabla CALENDARIO. Mensaje: ' + ls_mensaje &
							+ '~r~nPor favor verificar y corregir')
	return -1
end if

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio <= 0 THEN
	ROLLBACK;
	Messagebox('Aviso','La Tasa de cambio de la Fecha ' + string(ad_fecha, 'dd/mm/yyyy') &
						  + ' tiene el valor de ' + string(ldc_tasa_cambio, '###,##0.0000') &
						  + ' lo cual es invalido, por favor corrija')
	return -1
END IF

Return ldc_tasa_cambio
end function

public function boolean of_prompt_number (string as_titulo, ref decimal adc_value);// Para la descripcion de la Factura
str_parametros lstr_param, lstr_return

lstr_param.titulo   	= as_titulo
lstr_param.decimal1	= adc_value

OpenWithParm( w_prompt_number, lstr_param)

If isNull(message.PowerObjectParm) or not isValid(Message.PowerObjectParm) then return false

lstr_return = message.PowerObjectParm			

if not lstr_return.b_return THEN return false

adc_value = lstr_return.decimal1
return true

end function

public function String of_current_unidad ();String ls_unidad

ls_unidad = left(GetCurrentDirectory ( ), pos(GetCurrentDirectory ( ), ':', 1) )

return ls_unidad
end function

public subroutine of_mensaje_ok (string as_mensaje);str_parametros lstr_param

lstr_param.string1 = as_mensaje

OpenwithParm(w_message_ok, lstr_param)
end subroutine

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		as_string5 = trim(string(lstr_seleccionar.param5[1]))
		return true
	ELSE
		return false
	end if

else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		return true
	ELSE
		return false
	end if
	
else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		return true
	ELSE
		return false
	end if
	
else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		as_string5 = trim(string(lstr_seleccionar.param5[1]))
		as_string6 = trim(string(lstr_seleccionar.param6[1]))
		as_string7 = trim(string(lstr_seleccionar.param7[1]))
		return true
	ELSE
		return false
	end if

else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		return true
	ELSE
		return false
	end if
	
else
	return false
END IF
end function

public function boolean of_get_rango (ref string as_nro_min, ref string as_nro_max);Str_parametros	lstr_param

lstr_param.string1 = as_nro_min
lstr_param.string2 = as_nro_max

openWithParm(w_rango_numeros, lstr_param)

if IsNull(message.PowerObjectParm) or not IsValid(message.PowerObjectParm) then return false

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return false


as_nro_min = lstr_param.string1
as_nro_max = lstr_param.string2

return true
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, ref string as_string8, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		as_string5 = trim(string(lstr_seleccionar.param5[1]))
		as_string6 = trim(string(lstr_seleccionar.param6[1]))
		as_string7 = trim(string(lstr_seleccionar.param7[1]))
		as_string8 = trim(string(lstr_seleccionar.param8[1]))
		return true
	ELSE
		return false
	end if

else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		as_string5 = trim(string(lstr_seleccionar.param5[1]))
		as_string6 = trim(string(lstr_seleccionar.param6[1]))
		return true
	ELSE
		return false
	end if

else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		return true
	ELSE
		return false
	end if

else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, ref string as_string8, ref string as_string9, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		as_string5 = trim(string(lstr_seleccionar.param5[1]))
		as_string6 = trim(string(lstr_seleccionar.param6[1]))
		as_string7 = trim(string(lstr_seleccionar.param7[1]))
		as_string8 = trim(string(lstr_seleccionar.param8[1]))
		as_string9 = trim(string(lstr_seleccionar.param9[1]))
		return true
	ELSE
		return false
	end if

else
	return false
END IF
end function

public function boolean of_lista (string as_sql, ref string as_string1, ref string as_string2, ref string as_string3, ref string as_string4, ref string as_string5, ref string as_string6, ref string as_string7, ref string as_string8, ref string as_string9, ref string as_string10, string as_columna);long ll_row
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_column 	  = as_columna
lstr_seleccionar.s_sql       = as_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = 'aceptar' THEN
		as_string1 = trim(String(lstr_seleccionar.param1[1]))
		as_string2 = trim(string(lstr_seleccionar.param2[1]))
		as_string3 = trim(string(lstr_seleccionar.param3[1]))
		as_string4 = trim(string(lstr_seleccionar.param4[1]))
		as_string5 = trim(string(lstr_seleccionar.param5[1]))
		as_string6 = trim(string(lstr_seleccionar.param6[1]))
		as_string7 = trim(string(lstr_seleccionar.param7[1]))
		as_string8 = trim(string(lstr_seleccionar.param8[1]))
		as_string9 = trim(string(lstr_seleccionar.param9[1]))
		as_string10 = trim(string(lstr_seleccionar.param9[1]))
		return true
	ELSE
		return false
	end if
	
else
	return false
END IF
end function

public function integer of_get_print_size ();Str_parametros	lstr_param

open(w_print_size)

if IsNull(message.PowerObjectParm) or not IsValid(message.PowerObjectParm) then return -1

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return -1


return lstr_param.i_Return
end function

public subroutine of_mensaje_sql (string as_mensaje, string as_sql);str_parametros lstr_param

lstr_param.string1 = as_mensaje
lstr_param.string2 = as_sql

OpenwithParm(w_message_sql, lstr_param)
end subroutine

public function boolean of_valida_sistema (string as_sistema, string as_user);integer	li_count

try 
	if this.of_get_parametro( "VALIDAR_ACCESO_MODULO", "1") = "0" then return true

	select count(*)
		into :li_count
	from objeto_sis
	where sistema = :as_sistema;
	
	if SQLCA.SQLCode < 0 then
		ROLLBACK;
		MessageBox('Error', 'No tiene acceso al módulo ' + as_sistema + ", por favor verifique!", StopSign!)
		return false
	end if
	
	if li_count = 0 then return true
	
	select count(*)
		into :li_count
	  from (select os.sistema, os.objeto
				 from usr_grp ug,
						grp_obj go,
						objeto_sis os
				 where ug.grupo = go.grupo
				   and go.objeto = os.objeto
					and ug.cod_usr = :as_user
					and os.sistema = :as_sistema
				 union
				 select os.sistema, os.objeto
					from objeto_sis os,
						  usuario_obj uo
				  where os.objeto = uo.objeto
					 and os.sistema  = :as_sistema
					 and uo.cod_usr  = :as_user) s;
	
	if li_count = 0 then 
		return false
	else
		return true
	end if
		
	

catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Error en la validacion de la empresa')
	
finally
	
end try

end function

public function decimal of_tasa_cambio_vta (date ad_fecha);return this.of_tasa_cambio(ad_fecha)
end function

public function decimal of_get_icbper (date adi_fec_emision) throws exception;decimal		ldc_icbper
Integer		li_year
String 		ls_mensaje
Exception 	ex

//Encuento el año segun la fecha de emision
li_year = year(adi_fec_emision)

select tasa
	into :ldc_icbper
from ICBPER_TASA t
where t.periodo = :li_year;


if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	ex = create Exception
	ex.setMessage("Error al momento de consultar la tabla ICBPER_TASA. Mensaje: " + ls_mensaje)
	throw ex
	return -1
end if

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	ex = create Exception
	ex.setMessage("Debe especificar la tasa del impuesto ICBPER para el periodo " + string(li_year) &
					+ " en la tabla ICBPER_TASA para poder continuar")
	throw ex
	
	return -1
end if



return ldc_icbper
end function

public subroutine of_set_minidump_path (string as_path);/********************************************************************
   Subrutina: of_set_minidump_path
   Propósito: Configura la ruta donde PowerBuilder guardará los minidumps
   
   Parámetros:
      - as_path: Ruta donde se guardarán los minidumps (ej: "i:\sigre_exe")
   
   Notas:
      - Configura el registro de Windows para PowerBuilder 25.0 y 12.6
      - Crea el directorio si no existe
      - Los minidumps son archivos de diagnóstico generados cuando hay crashes
********************************************************************/
String 	ls_regkey_pb25, ls_regkey_pb12, ls_regkey_sybase
String 	ls_path
Integer li_rtn

//Asegurar que la ruta no tenga barra al final
ls_path = trim(as_path)
if Right(ls_path, 1) = '\' then
	ls_path = Left(ls_path, Len(ls_path) - 1)
end if

//Crear el directorio si no existe
if not DirectoryExists(ls_path) then
	li_rtn = CreateDirectory(ls_path)
end if

//Crear subdirectorio para minidumps
String ls_minidump_path
ls_minidump_path = ls_path + "\minidumps"

if not DirectoryExists(ls_minidump_path) then
	li_rtn = CreateDirectory(ls_minidump_path)
end if

//Configurar registro para PowerBuilder 25.0 (Appeon) - Clave principal usada por PB 25
ls_regkey_pb25 = "HKEY_CURRENT_USER\Software\Appeon\PowerBuilder 25.0\Debug"
RegistrySet(ls_regkey_pb25, "MiniDumpPath", ls_minidump_path)
RegistrySet(ls_regkey_pb25, "MiniDumpEnabled", "1")

//Configurar registro para PowerBuilder 25.0 bajo Sybase (compatibilidad)
ls_regkey_pb12 = "HKEY_CURRENT_USER\Software\Sybase\PowerBuilder\25.0\Debug"
RegistrySet(ls_regkey_pb12, "MiniDumpPath", ls_minidump_path)
RegistrySet(ls_regkey_pb12, "MiniDumpEnabled", "1")

//Configurar registro genérico de Sybase (fallback para versiones anteriores)
ls_regkey_sybase = "HKEY_CURRENT_USER\Software\Sybase\PowerBuilder\Debug"
RegistrySet(ls_regkey_sybase, "MiniDumpPath", ls_minidump_path)
RegistrySet(ls_regkey_sybase, "MiniDumpEnabled", "1")

end subroutine

on n_cst_app_obj.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_app_obj.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;SetNull(is_null)
SetNull(ii_null)
SetNull(il_null)
SetNull(id_null)
SetNull(idt_null)
SetNull(idc_null)

empresa 		= CREATE n_cst_empresa
finparam 		= CREATE n_cst_finanzas
rrhhparam 		= CREATE n_cst_rrhh
this.almacen 	= CREATE n_cst_almacen
efact 			= CREATE n_cst_efact
logistica 		= create n_Cst_compras
ventas			= create n_Cst_ventas
invo_wait		= create n_Cst_wait
invo_database	= create n_cst_database
invo_flota		= create n_cst_flota

invo_inifile	= create n_cst_inifile		

//Configurar la ruta de los minidumps para evitar que se generen en el escritorio
this.of_set_minidump_path("i:\sigre_exe")

end event

event destructor;destroy empresa
destroy finparam
destroy rrhhparam
destroy this.almacen
destroy efact
destroy logistica
destroy ventas
destroy invo_Wait
destroy invo_database
destroy invo_flota
destroy invo_inifile
end event

