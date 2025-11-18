$PBExportHeader$comercializacion.sra
$PBExportComments$Generated Application Object
forward
global type comercializacion from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  		 	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo
String 			gs_sistema, gs_ruc, gs_esquema, gs_lpp, gs_inifile
Integer  		gi_nivel, gi_control_db, gi_feriado[]
Date  			gd_fecha
String 			gs_db, gs_firma_digital
DateTime 		gdt_ingreso
Boolean			gb_log_objeto
TreeView 		gtv_actual
n_cst_app_obj		gnvo_app
n_cst_api			gnvo_api
n_cst_utilitario	gnvo_util
end variables

global type comercializacion from application
string appname = "comercializacion"
long richtextedittype = 0
long richtexteditversion = 0
string richtexteditkey = ""
integer highdpimode = 0
string appruntimeversion = "25.0.0.3711"
end type
global comercializacion comercializacion

type prototypes

end prototypes

on comercializacion.create
appname="comercializacion"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on comercializacion.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;// grabar hora de Logout
gnvo_app.of_set_logout_log()
DESTROY gnvo_app
Destroy gnvo_api
 
DISCONNECT ;
end event

event open;Integer li_logon, li_multi_emp
Long    ll_rc

// Objetos
gnvo_app = CREATE n_cst_app_obj

// Api functions
gnvo_api = CREATE n_cst_api

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos

// Parametros
gs_inifile = "\sigre_exe\comercializacion.ini"

// Verificar y cancelar si la aplicacion ya esta en uso
gnvo_api.of_close_app_duplicada(AppName)

// IDLE Event : numero de segundos de inactividad
idle(600)

// Proceso
ll_rc = gnvo_app.of_open_system(gs_inifile, li_logon, gi_control_db)


IF ll_rc = 1 THEN 
	gnvo_app.of_set_feriado()
	gnvo_app.of_set_login_log()
	Open(w_main)  // Abir MDI frame window
END IF


end event

event idle;rollback ;
halt close

end event

event systemerror;open(w_system_error)
end event

