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


end prototypes

forward prototypes
public function string of_get_windows_dir ()
public function string of_get_system_dir ()
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

on n_cst_api_sys.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_api_sys.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

