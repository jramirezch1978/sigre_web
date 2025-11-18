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
String   	is_estacion, is_user, is_help, is_origen, &
				is_logo, is_sistema, is_ruc, is_esquema, is_lpp, is_db,  is_dir, &
				is_inifile, is_TitleMessageBox ="Error de Sistema", is_appname, &
				is_user_so, is_UND_OPERAT, is_IP, is_desc_sistema, &
				is_agenda, is_TitleQuestion, is_LocalLog, is_LogName, is_LogPath, &
				is_ErrorLog = "1", is_TraceLog = "0", is_WarningLog = "1", is_skin, &
				is_ImageSplash, is_logo2

				
Integer  	ii_nivel, ii_control_db, ii_feriado[], ii_logon
Date  		id_fecha
Boolean		ib_log_objeto, ib_connect  = false, ib_skin, &
				ib_new_struct  // Nueva estructura de la base de datos
DateTime   	idt_ingreso

//Variables para la logica de la aplicacion
n_cst_sistema	invo_Sistema
n_cst_empresa	invo_Empresa
n_cst_usuario	invo_usuario

// Variables privadas
Private:
String is_nom_user = '', is_desc_origen = ''


end variables

forward prototypes
public function integer of_set_login_log ()
public function integer of_open_db (transaction atr_obj, string as_file)
public function string of_get_sistema (string as_file)
public function string of_get_origen (string as_file)
public function integer of_set_feriado ()
public function integer of_set_logout_log ()
public subroutine of_showmessagedialog (string as_mensaje)
public function long of_open_system (string as_inifile, integer ai_test, integer ai_control_db)
public function integer of_iniciar (string as_inifile, integer ai_logon, integer ai_control_db)
public subroutine of_splashscreen ()
public function boolean of_iniciar_parametros (string as_inifile)
public function boolean of_create_inifile (string as_inifile)
public function integer of_showconfirmdialog (string as_mensaje)
public function boolean of_control_active ()
public subroutine of_activa_skin ()
public function boolean of_elegir_und_operativa ()
public function boolean of_valida_transaccion (string as_mensaje, transaction atr_trans)
public function string of_nom_usuario ()
public function string of_desc_origen ()
public function boolean of_elegir_empresa ()
end prototypes

public function integer of_set_login_log ();string 		 	ls_mensaje, ls_tabla
n_cst_api		lnvo_api

lnvo_api = CREATE n_cst_api

//Obtengo el nombre del sistema operativo
is_user_so = lnvo_api.of_get_user( )
DESTROY lnvo_api

idt_ingreso = f_fecha_actual(0) //Fecha del Servidor de Base de datos

if this.ib_new_struct then
	ls_tabla = 'HIS_LOG_LOGIN'
	INSERT INTO HIS_LOG_LOGIN( 
		FECHA_INI, COD_USR, UND_OPERAT, ESTACION, USR_SISTEMA_OPER, 
		IP, SISTEMA_APLIC)  
	VALUES ( 	
		:idt_ingreso, :is_user, :is_UND_OPERAT, :is_estacion, :is_user_so, 
		:is_IP, :is_sistema )  ;
else
	ls_tabla = 'LOG_LOGIN'
	INSERT INTO LOG_LOGIN( 
		FECHA, COD_USR, ESTACION, EMPRESA, USER_SO, IP, SISTEMA)  
	VALUES ( 	
		:idt_ingreso, :is_user, :invo_empresa.is_empresa, :is_estacion, :is_user_so, 
		:is_IP, :is_sistema )  ;
end if

IF this.of_valida_transaccion( 'No se pudo ingresar registro en ' + ls_tabla, SQLCA) then
	commit;	
	gnvo_log.of_Tracelog(idt_ingreso, "Ingreso correcto del usuario: " + is_user)
	ib_connect = true
END IF

RETURN SQLCA.SQLCode
end function

public function integer of_open_db (transaction atr_obj, string as_file);Integer	li_rc = 1
String ls_mensaje
atr_obj.DBMS       = ProfileString (as_file, "database", "dbms",       "")
atr_obj.logid      = ProfileString (as_file, "database", "logid",      "")
atr_obj.logpass    = ProfileString (as_file, "database", "LogPass", "*****")
atr_obj.servername = ProfileString (as_file, "database", "servername", "")
atr_obj.dbparm     = ProfileString (as_file, "database", "dbparm",     "")

CONNECT ;
IF atr_obj.sqlcode <> 0 THEN
	ls_mensaje = gnvo_log.of_MensajeDB("No Pude Conectar a la Base de Datos")
	gnvo_log.of_errorlog(ls_mensaje)
	this.of_ShowMessageDialog(ls_mensaje)
	li_rc = -1
   HALT
END IF


RETURN li_rc
end function

public function string of_get_sistema (string as_file);is_sistema = ProfileString (as_file, "varios", "sistema", "TEST")

return is_sistema
end function

public function string of_get_origen (string as_file);is_origen = ProfileString (as_file, "varios", "origen", "")

return is_origen
end function

public function integer of_set_feriado ();Integer	li_x, li_mes, li_dia
Long	ll_rc
Datastore	lds_feriado

lds_feriado = CREATE Datastore
lds_feriado.Dataobject = 'd_cal_feriado_ds'
lds_feriado.SetTransObject(SQLCA)
ll_rc = lds_feriado.Retrieve()

IF ll_rc >= 0 THEN 

	FOR li_x = 1 TO ll_rc
		li_mes = lds_feriado.GetItemNumber(li_x, 'mes')
		li_dia = lds_feriado.GetItemNumber(li_x, 'dia')
		// value = Month * 100 + Day
		ii_feriado[li_x] = li_mes *100 + li_dia
	NEXT 
end if

RETURN ll_rc
end function

public function integer of_set_logout_log ();DateTime		ldt_db
string 		ls_mensaje, ls_tabla

if not ib_connect then return -1

ldt_db = f_fecha_actual(0)

if this.ib_new_struct then
	ls_tabla = 'HIS_LOG_LOGIN'
	UPDATE HIS_LOG_LOGIN  
		SET FECHA_FIN = :ldt_db  
	 WHERE COD_USR = :is_user
		and FECHA_INI = :idt_ingreso
		and SISTEMA_APLIC = :this.is_sistema;
else
	ls_tabla = 'LOG_LOGIN'
	UPDATE LOG_LOGIN  
		SET FECHA_FIN = :ldt_db  
	 WHERE COD_USR = :is_user
		and FECHA 	= :idt_ingreso
		and SISTEMA = :this.is_sistema;
end if

IF this.of_valida_transaccion( "No se pudo grabar en " + ls_tabla + " al Cerrar", SQLCA) then
	commit;	
	gnvo_log.of_Tracelog(ldt_db, "Cerrado correcto de la sesión: " + is_user)
	ib_connect = false
END IF

RETURN SQLCA.SQLCode
end function

public subroutine of_showmessagedialog (string as_mensaje);MessageBox(is_TitleMessageBox, as_mensaje, Exclamation!)
end subroutine

public function long of_open_system (string as_inifile, integer ai_test, integer ai_control_db);String   ls_mensaje
Long		ll_rc
str_parametros lstr_param

// Objetos
n_cst_api	lnv_api
lnv_api = CREATE n_cst_api  


IF FileExists ( as_inifile ) THEN

	// Cargar Parametros Generales
	this.of_iniciar_parametros( as_inifile )
	
	//Antes de pedir el login, abro el ScreenSplash
	this.of_splashscreen( )
	
	//Luego ya pido el usuario y password
	lstr_param.i_test 		= ai_test
	lstr_param.i_control_db = ai_control_db
	lstr_param.s_iniFile 	= as_inifile
	
	OpenWithParm(w_logon, lstr_param)
	
	ll_rc = Message.DoubleParm
	
	if IsNull(ll_rc) then ll_rc = -1

	DESTROY n_cst_api
ELSE
	ls_mensaje = 'No Existe el Inifile: ' + as_inifile
	gnvo_log.of_errorlog(ls_mensaje)
	this.of_showmessagedialog( ls_mensaje )
	ll_rc = -1
END IF
	
RETURN ll_rc
end function

public function integer of_iniciar (string as_inifile, integer ai_logon, integer ai_control_db);Integer li_logon, li_multi_emp
Long  ll_rc
String ls_mensaje

// API Functions
n_cst_api lnvo_api
lnvo_api = CREATE n_cst_api

// Flags
ii_logon      = ai_logon    // 0 = desahabilita logon
ii_control_db = ai_control_db    // 0 = no hace control de password en Base de Datos

// Usuario del Sistema Operativo

is_user_so = lnvo_api.of_get_user()
is_estacion = lnvo_api.of_get_work_station()
is_ip = lnvo_api.of_getIpAddress( )

// Directorio de la aplicacion
is_dir=GetCurrentDirectory ( )

//Obtencion del inifile
if as_inifile = '' then
	MessageBox("Error", "No se ha especificado un archivo de configuración, " &
							 + "se tomará el archivo por defecto")
	as_inifile = "\pb_exe\default.ini"
end if

if not FileExists(as_inifile) then
	MessageBox(is_TitleMessageBox, "No existe archivo de configuracion: " + as_inifile)
	return 0
end if

is_inifile = as_inifile

//Obtengo el nombre de la aplicación
is_appname = GetApplication().appname

// Verificar y Cancelar si la aplicacion ya esta en uso
//lnvo_api.of_close_app_duplicada(this)
 
// IDLE Event: Numero de Segundos de inactividad 
idle(60)

// Proceso
ll_rc = this.of_open_system(as_inifile, ai_logon, ai_control_db)

IF ll_rc = 1 THEN 
	//Elegir la empresa correspondiente
	if not this.of_elegir_empresa( ) then
		ls_mensaje = "Debe elegir una empresa para continuar"
		gnvo_log.of_errorlog(ls_mensaje)
		this.of_showmessagedialog( ls_mensaje)
		HALT CLOSE
	end if
	
	//Cargar los datos del Sistema
	this.invo_sistema.of_loaddatos( is_sistema )
	
	this.of_set_feriado()
	this.of_set_login_log()
	
	//Colocar los titulos correpondientes
	GetApplication().microhelpdefault = this.invo_sistema.is_descripcion + " (Listo) ..."
	GetApplication().toolbarframetitle = 'Barra de Herramientas Principal'
	GetApplication().toolbarsheettitle = 'Barra de Herramientas Ventana Actual'
	GetApplication().toolbarpopmenutext = 'Izquierda, Arriba, Derecha, Abajo, Flotando, Mostrar Nombres, Mostrar Tips'

	
 	Open(w_main)  // Abir MDI frame window

END IF
end function

public subroutine of_splashscreen ();Open(w_splash)
end subroutine

public function boolean of_iniciar_parametros (string as_inifile);String ls_mensaje, ls_skin, ls_new_struct

is_help			= ProfileString (as_inifile, "Varios", "Help",  "")
is_sistema  	= ProfileString (as_inifile, "varios", "sistema", "")

if trim(is_sistema) = '' then
	ls_mensaje = "No ha especificado el nombre del sistema en archivo de configuración"
	gnvo_log.of_errorlog(ls_mensaje)
	this.of_showmessagedialog(ls_mensaje)
	return false
end if

is_logo 			= ProfileString (as_inifile, is_sistema, "Logo", "")
is_logo2			= ProfileString (as_inifile, is_sistema, "Logo2", "")
is_agenda 		= ProfileString (as_inifile, is_sistema, "ShowAgenda", "1")
is_LocalLog 	= ProfileString (as_inifile, is_sistema, "LocalLog", "0")
is_LogName 		= ProfileString (as_inifile, is_sistema, "LogName", "")
is_LogPath  	= ProfileString (as_inifile, is_sistema, "LogPath", "")
is_ErrorLog 	= ProfileString (as_inifile, is_sistema, "ErrorLog", "1")
is_WarningLog 	= ProfileString (as_inifile, is_sistema, "WarningLog", "1")
is_TraceLog  	= ProfileString (as_inifile, is_sistema, "TraceLog", "0")
ls_skin 		 	= ProfileString (as_inifile, is_sistema, "UsarSkin", "1")
ls_new_struct	= ProfileString (as_inifile, is_sistema, "NewStruct", "1")
is_origen		= ProfileString (as_inifile, is_sistema, "Origen", "1")
is_ImageSplash	= ProfileString (as_inifile, is_sistema, "ImageSplash", &
							"\SIGRE\resources\JPG\11280.jpg")

is_TitleMessageBox = ProfileString (as_inifile, is_sistema, "TitleMessageBox", "")
is_TitleQuestion = ProfileString (as_inifile, is_sistema, "TitleQuestion", "")


if is_appName = '' then is_appName = GetApplication().AppName
	
if is_titleMessageBox = '' then
	is_TitleMessageBox = "Error de Aplicación: " + is_appname
end if

if is_titleQuestion = '' then
	is_titleQuestion = is_appname + " necesita mas información"
end if

if ls_skin = '1' then
	ib_skin = true
	if this.of_control_active( ) then
		this.of_activa_skin( )
	end if
else
	ib_skin = false
end if

if ls_new_struct = '1' then
	this.ib_new_struct = true  // Se usa la nueva structura de DB
else
	this.ib_new_struct = false // Se usa la antigua estructura de DB
end if


return true
end function

public function boolean of_create_inifile (string as_inifile);return true
end function

public function integer of_showconfirmdialog (string as_mensaje);integer li_rc

li_rc = MessageBox(is_TitleQuestion, as_mensaje, Question!, YesNo!, 2)

return li_rc
end function

public function boolean of_control_active ();String   ls_path, ls_name, ls_valor, ls_run
Boolean  lb_exist, lb_result
Integer  li_FileNum, li_run

n_cst_api_sys lnv_api_sys
lnv_api_sys = CREATE n_cst_api_sys

lb_result = False

// Verifica que el archivo actskin4.ocx exista en el system
ls_path = lnv_api_sys.of_get_system_dir()
ls_name = trim(ls_path)+'\actskin4.ocx'
lb_exist = FileExists(ls_name)

IF NOT lb_exist THEN 
   li_FileNum = FileCopy ("/Pb_exe/ActiveX/actskin4.ocx", ls_name) 
ELSE
	li_filenum = 1
	lb_result = True
END IF

// Verifica que el active x este registrado
RegistryGet("HKEY_CLASSES_ROOT\ActiveSkin4.Skin", &
             "", RegString!, ls_valor)

//li_filenum <> 1 error

IF TRIM(ls_valor) = '' AND li_FileNum = 1  THEN
	ls_run = "REGSVR32.EXE /S "+ls_name
	li_run = Run(ls_run)
	IF li_run <> 1 THEN lb_result = False
END IF

RETURN lb_result
end function

public subroutine of_activa_skin ();long   ll_num_act 
int    li_ran
String ls_skin, ls_mensaje

Randomize (0)

ll_num_act = Long(ProfileString(is_inifile, "Skins", 'Total', ""))
li_ran = Rand(ll_num_act)
ls_skin = ProfileString(is_inifile, "Skins", String(li_ran), "")

//Seteo el skin para toda la aplicación
IF LEN(Trim(ls_skin)) > 0 THEN
	IF not FileExists(ls_skin) then
		ls_mensaje = "[this.of_activa_skin()] No existe el archivo: " + ls_skin
		gnvo_log.of_errorlog(ls_mensaje)
		this.of_showmessagedialog( ls_mensaje )
	else
		is_skin = ls_skin
	end if
END IF
end subroutine

public function boolean of_elegir_und_operativa ();str_parametros lstr_parm
long 				ll_rc = 0
String 			ls_mensaje

if this.ib_new_struct then
	Open(w_empresa_und_op)
	if Not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
		lstr_parm = Message.powerobjectparm
	end if
	
	if lstr_parm.retorno = '1' then
		return true
	else
		return false
	end if
else
	select cod_empresa
		into :this.invo_empresa.is_empresa
	from genparam
	where reckey = '1';
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = "No ha especificado parámetros en genparam"
		gnvo_log.of_errorlog( ls_mensaje )
		this.of_showmessagedialog( ls_mensaje )
		return false
	elseif SQLCA.SQLCode < 0 then
		ls_mensaje = gnvo_log.of_MensajeDB("Error al consultar datos en la tabla GENPARAM")
		gnvo_log.of_errorlog( ls_mensaje )
		this.of_showmessagedialog( ls_mensaje )
		return false
	end if
	
	return true
end if

return false


end function

public function boolean of_valida_transaccion (string as_mensaje, transaction atr_trans);String ls_mensaje

if atr_trans.SQLCode = 0 then
	return true
elseif atr_trans.SQLCode = 100 then
	ls_mensaje = gnvo_log.of_mensajedb( as_mensaje + "~n~rRegistro no encontrado" )
	Rollback Using atr_trans;
	
	gnvo_log.of_errorlog( ls_mensaje )
	this.of_showmessagedialog( ls_mensaje )
	Return False
	
else
	ls_mensaje = gnvo_log.of_mensajedb( as_mensaje )
	Rollback Using atr_trans;
	
	gnvo_log.of_errorlog( ls_mensaje )
	this.of_showmessagedialog( ls_mensaje )
	Return False
END IF
end function

public function string of_nom_usuario ();n_cst_usuario lnvo_user

if is_nom_user = '' then
	lnvo_user = CREATE n_cst_usuario
	
	is_nom_user = lnvo_user.of_nom_usuario(is_user)
	
	destroy lnvo_user
end if

return is_nom_user
end function

public function string of_desc_origen ();n_cst_origen lnvo_origen

if is_desc_origen = '' then
	lnvo_origen = CREATE n_cst_origen
	is_desc_origen = lnvo_origen.of_desc_origen( is_origen )
	destroy lnvo_origen
end if

return is_desc_origen
end function

public function boolean of_elegir_empresa ();str_parametros lstr_parm
long 				ll_rc = 0, ll_count
String 			ls_mensaje, ls_empresa, ls_origen

if this.ib_new_struct then
	//Aun por definirse
else
	/*
			Name         Type    Nullable Default Comments       
		------------ ------- -------- ------- -------------- 
		COD_USR      CHAR(6)                  cod usuario    
		COD_EMPRESA  CHAR(8)                  Codigo Empresa 
		FEC_REGISTRO DATE    Y        SYSDATE FEC_REGISTRO   
	*/
	select count(*)
		into :ll_count
	from user_empresa
	where cod_usr = :this.is_user;
	
	if ll_count = 0 then
		ls_mensaje = "El usuario " + this.is_user + " no tiene asignada una empresa"
		gnvo_log.of_errorlog( ls_mensaje )
		this.of_showmessagedialog( ls_mensaje )
		return false
	end if
	
	if ll_count = 1 then
			select COD_EMPRESA, cod_origen
				into :ls_empresa, :ls_origen
			from user_empresa
			where cod_usr = :this.is_user;
			
			invo_empresa.of_load_datos( ls_empresa )
			this.is_origen = ls_origen
			
			return true

	else
		Open(w_elegir_empresa)
		if Not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
			lstr_parm = Message.powerobjectparm
		end if
	
		if lstr_parm.retorno = '1' then
			return true
		else
			return false
		end if
	end if
	
end if

return false


end function

on n_cst_app_obj.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_app_obj.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_sistema = create n_cst_sistema
invo_empresa = create n_cst_empresa
invo_usuario = create n_cst_usuario
end event

event destructor;destroy invo_Sistema
destroy invo_empresa
destroy invo_usuario
end event

