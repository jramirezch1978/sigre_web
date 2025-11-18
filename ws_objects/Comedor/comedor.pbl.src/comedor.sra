$PBExportHeader$comedor.sra
$PBExportComments$Generated Application Object
forward
global type comedor from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, gs_inifile
String 	gs_sistema, gs_ruc, gs_esquema, gs_lpp, gs_db, gs_firma_digital
Integer gi_nivel, gi_control_db, gi_feriado[]
Date  	gd_fecha
Boolean	gb_log_objeto
DateTime gdt_ingreso

n_cst_app_obj	gnvo_app
end variables

global type comedor from application
string appname = "comedor"
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
string appicon = "C:\SIGRE\resources\ICO\Recipes.ico"
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
global comedor comedor

on comedor.create
appname="comedor"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on comedor.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Integer	li_logon, li_multi_emp
Long		ll_rc

// Objetos 
n_cst_app_obj	lnv_obj
lnv_obj = CREATE n_cst_app_obj

// API Functions
n_cst_api lnv_api
lnv_api = CREATE n_cst_api

// Verificar y Cancelar si la aplicacion ya esta en uso
lnv_api.of_close_app_duplicada(AppName)

// IDLE Event: Numero de Segundos de inactividad 
idle(900)

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos 

// Parametros
gs_inifile    = "\sigre_exe\comedor.ini"	

// Proceso
ll_rc = lnv_obj.of_open_system(gs_inifile, li_logon, gi_control_db) 

IF ll_rc = 1 THEN 
	lnv_obj.of_set_feriado()
 	Open(w_main)  // Abir MDI frame window
 	lnv_obj.of_set_login_log()
END IF	

DESTROY n_cst_app_obj


end event

event idle;Rollback ;
DISCONNECT ;
HALT CLOSE
end event

event systemerror;open(w_system_error)
end event

event close;// grabar hora de Logout
gnvo_app.of_set_logout_log()
DESTROY gnvo_app
 
DISCONNECT ;
end event

