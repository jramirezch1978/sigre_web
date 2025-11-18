$PBExportHeader$n_cst_api_sys.sru
forward
global type n_cst_api_sys from nonvisualobject
end type
end forward

global type n_cst_api_sys from nonvisualobject
end type
global n_cst_api_sys n_cst_api_sys

type prototypes
Function uint GetWindowsDirectoryA (ref string dirtext, uint textlen) library "kernel32.dll" alias for "GetWindowsDirectoryA;Ansi" 
Function uint GetSystemDirectoryA  (ref string dirtext, uint textlen) library "kernel32.dll" alias for "GetSystemDirectoryA;Ansi"

//Nombre del usuario
FUNCTION Boolean GetUserName(  ref string lpBuffer, ref long nBufferLength ) LIBRARY "Advapi32.dll" ALIAS FOR "GetUserNameA;Ansi"

//Nombre de la PC
FUNCTION boolean GetComputerName(ref string lpBuffer,ref long nBufferLength) LIBRARY "Kernel32.dll" ALIAS FOR "GetComputerNameA;Ansi"

//Funcion para saber si estas ejecutando o no en Remote Desktop
FUNCTION int GetSystemMetrics (int index) LIBRARY "USER32.DLL"
end prototypes

type variables
Constant Integer SM_REMOTESESSION = 4096
end variables

forward prototypes
public function string of_get_windows_dir ()
public function string of_get_system_dir ()
public function string of_get_user_so () throws exception
public function string of_get_computer_name () throws exception
public function boolean is_remote_desktop () throws exception
end prototypes

public function string of_get_windows_dir ();string  ls_temp 
uint    lui_value
boolean lb_rc

lui_value = 255
ls_temp = Space( 255 )

GetWindowsDirectoryA( ls_temp, lui_value )

RETURN Trim( ls_temp )

end function

public function string of_get_system_dir ();string ls_temp
uint    lui_value
boolean lb_rc

lui_value = 255
ls_temp = Space( 255 )

GetSystemDirectoryA( ls_temp, lui_value )

RETURN Trim( ls_temp )
end function

public function string of_get_user_so () throws exception;string 		ls_username
long 			lu_val
boolean 		lb_rtn
exception 	ex


lu_val = 255;
ls_username = space (lu_val);
lb_rtn = GetUserName(ls_username, lu_val );
if not lb_rtn then
		ex = create exception
		ex.setMessage( "Fallo en llamada para username SO");
        	throw ex;
end if

return  ls_username;
end function

public function string of_get_computer_name () throws exception;string 		ls_computer_name
long 			lu_val
boolean 		lb_rtn
exception 	ex


lu_val = 255;
ls_computer_name = space (lu_val);
lb_rtn = GetComputerName(ls_computer_name, lu_val );
if not lb_rtn then
		ex = create exception
		ex.setMessage( "Fallo en llamada para username SO");
        	throw ex;
end if

return  ls_computer_name;
end function

public function boolean is_remote_desktop () throws exception;boolean	lb_IsRemoteSession = false

//Constant used to check for remote sessions
Integer li_Value

//This function will return 0 if the session is local
li_Value = GetSystemMetrics(SM_REMOTESESSION)

if li_Value <> 0 then
	lb_IsRemoteSession = true;
else
	lb_IsRemoteSession = false;
end if

return lb_IsRemoteSession;

end function

on n_cst_api_sys.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_api_sys.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

