$PBExportHeader$nps_erp.sra
$PBExportComments$Generated Application Object
forward
global type nps_erp from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
// Objetos
n_cst_app_obj 			gnvo_app
n_cst_errorlogging 	gnvo_log
end variables

global type nps_erp from application
string appname = "nps_erp"
end type
global nps_erp nps_erp

on nps_erp.create
appname="nps_erp"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on nps_erp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;String   ls_inifile
Integer li_logon, li_control_db
Long  ll_rc

//Creo el objeto que representa la aplicacion
gnvo_app = CREATE n_cst_app_obj

//Creo el objeto Log para grabar en el archivo log del sistema
gnvo_log = CREATE n_cst_errorlogging

// Flags
li_logon      = 1    // 0 = desahabilita logon
li_control_db = 0    // 0 = no hace control de password en Base de Datos

// Parametros
ls_inifile    = "\sigre_exe\nps_erp.ini"

gnvo_app.of_iniciar(ls_inifile, li_logon, li_control_db)
end event

event close;// grabar hora de Logout
//MessageBox('', 'Se ejecuta el close de la aplicacion')
if Not IsNull(gnvo_app) and isValid(gnvo_app) then
	gnvo_app.of_set_logout_log()
	DESTROY gnvo_app
end if

if not IsNull(gnvo_log) and IsValid(gnvo_log) then
	DESTROY gnvo_log
end if

DISCONNECT ;
end event

event idle;Rollback ;
HALT CLOSE
end event

event systemerror;open(w_system_error)
end event

