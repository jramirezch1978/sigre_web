$PBExportHeader$contabilidad.sra
$PBExportComments$Generated Application Object
forward
global type contabilidad from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String   gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo
String   gs_sistema, gs_ruc, gs_esquema, gs_lpp,gs_inifile
Integer  gi_nivel, gi_control_db, gi_feriado[]
Date     gd_fecha
String   gs_db
DateTime gdt_ingreso
Boolean 	gb_log_objeto
String	gs_firma_digital

n_cst_app_obj	gnvo_app
n_cst_contabilidad gnvo_cntbl
end variables

global type contabilidad from application
string appname = "contabilidad"
long richtextedittype = 2
long richtexteditversion = 1
string richtexteditkey = ""
integer highdpimode = 0
string appruntimeversion = "25.0.0.3711"
end type
global contabilidad contabilidad

on contabilidad.create
appname="contabilidad"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on contabilidad.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;String   ls_inifile
Integer li_logon, li_multi_emp
Long  ll_rc

// Objetos
gnvo_app 	= create n_cst_app_obj
gnvo_cntbl	= create n_cst_contabilidad

// API Functions
n_cst_api lnv_api
lnv_api = CREATE n_cst_api

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos

// Parametros
gs_inifile    = "\sigre_exe\contab.ini"

// Verificar y Cancelar si la aplicacion ya esta en uso
lnv_api.of_close_app_duplicada(AppName)
 
// IDLE Event: Numero de Segundos de inactividad 
idle(60)

// Proceso
ll_rc = gnvo_app.of_open_system(gs_inifile, li_logon, gi_control_db)

//IF ll_rc = 1 THEN Open(w_main)  // Abir MDI frame window

IF ll_rc = 1 THEN 
	gnvo_app.of_set_feriado()
 	Open(w_main)  // Abir MDI frame window
 	gnvo_app.of_set_login_log()
END IF


end event

event close;// grabar hora de Logout
gnvo_app.of_set_logout_log()
DESTROY gnvo_app
destroy gnvo_cntbl
 
DISCONNECT ;
end event

event idle;Rollback ;
HALT CLOSE
 
end event

event systemerror;open(w_system_error)

end event

