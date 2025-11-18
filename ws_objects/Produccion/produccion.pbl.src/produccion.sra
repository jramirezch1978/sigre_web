$PBExportHeader$produccion.sra
$PBExportComments$Generated Application Object
forward
global type produccion from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  			gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, gs_sistema, &
					gs_ruc, gs_esquema,gs_lpp, gs_remoto, gs_wallpaper, gs_db, gs_inifile, &
					gs_firma_digital
					
Integer 			gi_nivel, gi_control_db, gi_feriado[]
Date    			gd_fecha
Boolean			gb_log_objeto
DateTime 		gdt_ingreso
n_cst_app_obj	gnvo_app


end variables

global type produccion from application
string appname = "produccion"
long richtextedittype = 0
long richtexteditversion = 0
string richtexteditkey = ""
integer highdpimode = 0
string appruntimeversion = "25.0.0.3711"
end type
global produccion produccion

type prototypes
//SUBROUTINE keybd_event( int bVk, int bScan, int dwFlags, int dwExtraInfo) LIBRARY "user32.dll"
end prototypes

on produccion.create
appname="produccion"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on produccion.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Integer li_logon, li_multi_emp
Long  ll_rc

// Objetos
gnvo_app = CREATE n_cst_app_obj

// API Functions
n_cst_api lnv_api
lnv_api = CREATE n_cst_api

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos

// Parametros
gs_inifile    = "\sigre_exe\produc.ini"

gs_remoto 	 = ProfileString(gs_inifile, "VARIOS", 'Remoto', "0")
gs_wallPaper = ProfileString(gs_inifile, "VARIOS", 'WallPaper', "H:\source\Jpg\Constante.JPG")


// Verificar y Cancelar si la aplicacion ya esta en uso
lnv_api.of_close_app_duplicada(AppName)
 
// IDLE Event: Numero de Segundos de inactividad 
idle(600)

// Proceso
ll_rc = gnvo_app.of_open_system(gs_inifile, li_logon, gi_control_db)

IF ll_rc = 1 THEN 
	gnvo_app.of_set_login_log()
 	Open(w_main)  // Abir MDI frame window
END IF



end event

event systemerror;open(w_system_error)
 
end event

event idle;rollback ;
halt close
end event

event close;// grabar hora de Logout

gnvo_app.of_set_logout_log()

DESTROY gnvo_app

DISCONNECT ;

end event

