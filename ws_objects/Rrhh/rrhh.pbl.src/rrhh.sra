$PBExportHeader$rrhh.sra
forward
global type rrhh from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String   gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, &
			gs_sistema, gs_ruc, gs_esquema, gs_lpp, gs_inifile, gs_firma_digital, &
			gs_db
			
Integer  	gi_nivel, gi_control_db, gi_feriado[]
Date  		gd_fecha
DateTime    gdt_ingreso
Boolean 		gb_log_objeto      

n_cst_app_obj 			gnvo_app
n_cst_contabilidad 	gnvo_cntbl
end variables

global type rrhh from application
string appname = "rrhh"
long richtextedittype = 0
long richtexteditversion = 0
string richtexteditkey = ""
integer highdpimode = 0
string appruntimeversion = "25.0.0.3711"
end type
global rrhh rrhh

type prototypes
Function int _lopen(ref string str, int num) Library "KERNEL32.DLL" alias for "_lopen;Ansi"
Function ulong WinExec(ref string str, uint num) Library "KERNEL32.DLL" alias for "WinExec;Ansi"
end prototypes

type variables
string is_path_sigre
end variables

on rrhh.create
appname="rrhh"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on rrhh.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Integer li_logon, li_multi_emp
Long  ll_rc
n_cst_inifile 	lnvo_inifile

try 

	// Objetos
	gnvo_app 	= CREATE n_cst_app_obj
	gnvo_cntbl	= CREATE n_cst_contabilidad
	lnvo_inifile = create n_cst_inifile
	
	// Api functions
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
		
	gs_inifile    = is_path_sigre + "\rrhh.ini"
	
	
	// Verificar y cancelar si la aplicacion ya esta en uso
	lnv_api.of_close_app_duplicada(AppName)
	
	// IDLE Event : numero de segundos de inactividad
	idle(600)
	
	// Proceso
	ll_rc = gnvo_app.of_open_system(gs_inifile, li_logon, gi_control_db)
	
	// Firma digital
	gs_firma_digital  = ProfileString (gs_inifile, "Firma_digital", gs_empresa, "")
	
	if gs_empresa = 'CATACAOS' then
		MessageBox('Aviso', 'La licencia para uso de este programa ha caducado por favor ponerse en contacto con su proveedor o visite su pagina web', Information!)
		HALT CLOSE	
	end if
	
	//IF ll_rc = 1 THEN Open(w_main)  // Abir MDI frame window
	
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

event close;// grabar hora de Logout
gnvo_app.of_set_logout_log()
DESTROY gnvo_app
DESTROY gnvo_cntbl
 
DISCONNECT ;
end event

event idle;rollback ;
halt close

end event

event systemerror;open(w_system_error)
end event

