$PBExportHeader$ejemplo.sra
$PBExportComments$Generated Application Object
forward
global type ejemplo from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, gs_esquema, gs_db
String		gs_sistema
Integer 	gi_nivel, gi_control_db
Date		gd_fecha
end variables

global type ejemplo from application
string appname = "ejemplo"
end type
global ejemplo ejemplo

on ejemplo.create
appname="ejemplo"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on ejemplo.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;String   ls_inifile          
Integer	li_logon, li_multi_emp
Long		ll_rc

// APPlication Object 
n_cst_app_obj	lnv_obj
lnv_obj = CREATE n_cst_app_obj

// API Functions
n_cst_api	lnv_api
lnv_api = CREATE n_cst_api

// Verificar y Cancelar si la aplicacion ya esta en uso
lnv_api.of_close_app_duplicada(AppName)

// IDLE Event: Numero de Segundos de inactividad 
idle(900)

// Flags
li_logon      = 0    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos 

// Parametros
ls_inifile    = "\sigre_exe\creditos.ini"	

// Proceso
ll_rc = lnv_obj.of_open_system(ls_inifile, li_logon, gi_control_db) 

//IF ll_rc = 1 THEN
// lnv_obj.of_set_feriado()
//	Open(w_main)	 // Abir MDI frame window
//END IF

DESTROY n_cst_app_obj

// Variables Globales
////String  	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo
////String		gs_sistema
////Integer 	gi_nivel, gi_control_db, gi_feriado[]
////Date		gd_fecha


end event

event idle;Rollback ;
DISCONNECT ;
HALT CLOSE

end event

event systemerror;Open(w_system_error)
end event

