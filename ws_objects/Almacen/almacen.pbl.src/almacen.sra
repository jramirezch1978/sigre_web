$PBExportHeader$almacen.sra
forward
global type almacen from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String   	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, gs_sistema, &
				gs_ruc, gs_esquema, gs_lpp, gs_db, gs_razonsocial, gs_direccion, gs_telefono, &
				gs_email, gs_inifile, gs_firma_digital
Integer  	gi_nivel, gi_control_db, gi_feriado[]
Date  		gd_fecha
Boolean		gb_log_objeto
DateTime    gdt_ingreso

n_cst_app_obj		gnvo_app
n_cst_utilitario 	gnvo_utility

end variables

global type almacen from application
string appname = "almacen"
integer highdpimode = 0
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 25.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "C:\SIGRE\resources\ICO\Almacen.ico"
string appruntimeversion = "25.0.0.3711"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
end type
global almacen almacen

type prototypes

end prototypes

type variables
String 			is_path_sigre

end variables

on almacen.create
appname="almacen"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on almacen.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Integer 			li_logon, li_multi_emp
Long  			ll_rc
n_cst_inifile 	lnvo_inifile

try 
	// Objetos
	gnvo_app = CREATE n_cst_app_obj
	lnvo_inifile = create n_cst_inifile
	
	// API Functions
	n_cst_api lnv_api
	lnv_api = CREATE n_cst_api
	
	// Flags
	li_logon      = 1    // 0 = desahabilita logon
	gi_control_db = 0    // 0 = no hace control de password en Base de Datos
	
	// Parametros
	lnvo_inifile.of_set_inifile("\sigre_exe\empresas.ini")
	
	is_path_sigre 			= lnvo_inifile.of_get_parametro( "SIGRE_EXE", "PATH_SIGRE", "i:\SIGRE_EXE")
		
	if right(this.is_path_sigre, 1) = '\' then
		this.is_path_sigre = left(this.is_path_sigre, len(this.is_path_sigre) - 1)
	end if
		
	gs_inifile    = is_path_sigre + "\almacen.ini"
	
	// Verificar y Cancelar si la aplicacion ya esta en uso
	lnv_api.of_close_app_duplicada(AppName)
	 
	// IDLE Event: Numero de Segundos de inactividad 
	idle(600)
	
	
	// Proceso
	ll_rc = gnvo_app.of_open_system(gs_inifile, li_logon, gi_control_db)
	
	IF ll_rc = 1 THEN 
		gnvo_app.of_set_feriado()
		Open(w_main)  // Abir MDI frame window
		gnvo_app.of_set_login_log()
	END IF


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')

finally 
	destroy lnvo_inifile
end try



end event

event idle;Rollback ;
HALT CLOSE
 
end event

event systemerror;open(w_system_error)
end event

event close;// grabar hora de Logout
gnvo_app.of_set_logout_log()


DESTROY gnvo_app
//DESTROY gnvo_utility

DISCONNECT ;

end event

