$PBExportHeader$sig_web.sra
$PBExportComments$Generated Application Object
forward
global type sig_web from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String   gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo
String   gs_sistema, gs_ruc, gs_esquema, gs_lpp, gs_db, gs_sig
Integer  gi_nivel, gi_control_db, gi_feriado[]
Date     gd_fecha
DateTime	gdt_ingreso
Boolean	gb_log_objeto

n_cst_app_obj gnvo_app
end variables

global type sig_web from application
string appname = "sig_web"
end type
global sig_web sig_web

type variables

end variables

on sig_web.create
appname="sig_web"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sig_web.destroy
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
n_cst_app_obj lnv_obj
lnv_obj = CREATE n_cst_app_obj

// Api functions
n_cst_api lnv_api
lnv_api = CREATE n_cst_api

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos

// Parametros
ls_inifile    = "\sigre_exe\sig.ini"

// Verificar y cancelar si la aplicacion ya esta en uso
lnv_api.of_close_app_duplicada(AppName)

// IDLE Event : numero de segundos de inactividad
idle(900)

// Proceso
ll_rc = lnv_obj.of_open_system(ls_inifile, li_logon, gi_control_db)

//IF ll_rc = 1 THEN Open(w_main)  // Abir MDI frame window

IF ll_rc = 1 THEN 
	lnv_obj.of_set_feriado()
	Open(w_main)  // Abir MDI frame window
	lnv_obj.of_set_login_log()
END IF

gs_sig = 'A'

DESTROY lnv_obj


end event

event idle;rollback ;
halt close

end event

event close;// grabar hora de Logout
n_cst_app_obj lnv_obj
lnv_obj = CREATE n_cst_app_obj
lnv_obj.of_set_logout_log()
DESTROY n_cst_app_obj

DISCONNECT ;

end event

event systemerror;Open(w_system_error)
end event

