$PBExportHeader$auditoria.sra
$PBExportComments$Generated Application Object
forward
global type auditoria from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, gs_sistema, gs_ruc, &
		gs_esquema, gs_lpp, gs_db, gs_inifile, gs_firma_digital
Integer  	gi_nivel, gi_control_db, gi_feriado[]
Date  		gd_fecha
DateTime 	gdt_ingreso
Boolean 	gb_log_objeto
n_cst_app_obj 	gnvo_app
end variables

global type auditoria from application
string appname = "auditoria"
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
string appicon = "C:\SIGRE\resources\ICO\PERSON.ICO"
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
global auditoria auditoria

on auditoria.create
appname="auditoria"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on auditoria.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;// grabar hora de Logout
gnvo_app.of_set_logout_log()
DESTROY gnvo_app
 
DISCONNECT ;
end event

event open;
String   ls_inifile
Integer li_logon, li_multi_emp
Long  ll_rc

// Objetos
gnvo_app = CREATE n_cst_app_obj

// Api functions
n_cst_api lnv_api
lnv_api = CREATE n_cst_api

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos

// Parametros
ls_inifile = "\sigre_exe\auditoria.ini"

// Verificar y cancelar si la aplicacion ya esta en uso
lnv_api.of_close_app_duplicada(AppName)

// IDLE Event : numero de segundos de inactividad
idle(60)

// Proceso
ll_rc = gnvo_app.of_open_system(ls_inifile, li_logon, gi_control_db)

//IF ll_rc = 1 THEN Open(w_main)  // Abir MDI frame window

IF ll_rc = 1 THEN 
	gnvo_app.of_set_feriado()
 	Open(w_main)  // Abir MDI frame window
 	gnvo_app.of_set_login_log()
END IF


end event

event idle;rollback ;
halt close

end event

event systemerror;Open(w_system_error)
end event

