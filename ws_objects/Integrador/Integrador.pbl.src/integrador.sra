$PBExportHeader$integrador.sra
$PBExportComments$Generated Application Object
forward
global type integrador from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String 	gs_inifile,  gs_user_so, gs_computer_name, gs_path, gs_ws = "0"

String		gs_usrempresas[]

n_cst_wait 			gnvo_wait
n_cst_api_sys		gnvo_api

end variables

global type integrador from application
string appname = "integrador"
integer highdpimode = 0
string appruntimeversion = "25.0.0.3711"
end type
global integrador integrador

type prototypes
function ulong CreateMutexA( ulong lpMutexAttributes, &
   										int bInitialOwner,  &
										ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi"
function ulong GetLastError() library "kernel32.dll"

end prototypes

type variables

end variables

on integrador.create
appname="integrador"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on integrador.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;ContextKeyword 	lcxk_base
string 				ls_values[]

// Verifica si aplicacion ya esta en uso  
ulong ll_mutex, ll_err
String ls_mutex_name, ls_cmd


try 
	//Creo el objeto wait
	gnvo_wait 	= create n_cst_wait
	gnvo_api 	= create n_cst_api_sys
	
	gs_path = 'i:\sigre_exe'
	
	gs_inifile = gs_path + "\empresas.ini"
	
	if not fileexists(gs_inifile) then
		MessageBox('Aviso', 'Archivo ' + gs_inifile + ' no existe o no es accesible, por favor verifique!', StopSign!)
		HALT CLOSE
	end if
	
	ls_cmd = CommandParm()
	
	if Len(ls_cmd) > 0 then
		//si tiene parametros entonces hay otro comportamiento
		choose case ls_cmd
			case "-backup"
				//Saco un backup de la base de datos
				f_backup()
			case "-config"
				f_config()
			case else
				MessageBox("Aviso", "Opción no soportada")
				return // No hay nada que hacer
		end choose
	
	else
		if handle(GetApplication(), false) <> 0 then
			ls_mutex_name = Appname + char(0)
				
			ll_mutex = CreateMutexA( 0,0, ls_mutex_name)
			ll_err = GEtLastError()
				
			if ll_err = 183 then  // esta ejecutandose
				Messagebox( "Aviso", "Aplicacion ya esta en uso", Information!)
				halt
			end if
		end if
	end if
	
	//Obtiene el Origen de la Sesión Console o TS
	gs_user_so = gnvo_api.of_get_user_so()
	if trim(gs_user_so) = '' or IsNull(gs_user_so) then
		gs_user_so = 'no-user'
	end if
		
	//Obtengo el nombre de la PC
	gs_computer_name = gnvo_api.of_get_computer_name()
	if trim(gs_computer_name) = '' or IsNull(gs_computer_name) then
		gs_computer_name = 'no-computer-name'
	end if

	//Abre la Ventana del Skin
	gnvo_wait.of_mensaje("Abriendo aplicacion")
	
	open(w_login)

catch ( Exception ex )
	MessageBox('Exception', 'Ha ocurrido una exception. Mensaje: ' + ex.getMessage(), StopSign!)
	Halt Close;

end try
end event

event close;gnvo_wait.of_close()
destroy gnvo_wait
destroy gnvo_api
end event

