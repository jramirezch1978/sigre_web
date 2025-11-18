$PBExportHeader$n_cst_register.sru
forward
global type n_cst_register from nonvisualobject
end type
end forward

global type n_cst_register from nonvisualobject autoinstantiate
end type

type variables
String is_regkey = "HKEY_CURRENT_USER\Software\NPSSAC\SIGRE"
end variables

forward prototypes
public subroutine of_setreg (string as_entry, string as_value)
public function string of_getreg (string as_entry, string as_default)
end prototypes

public subroutine of_setreg (string as_entry, string as_value);RegistrySet(is_regkey, as_entry, as_value)
end subroutine

public function string of_getreg (string as_entry, string as_default);String ls_regvalue

RegistryGet(is_regkey, as_entry, ls_regvalue)

If ls_regvalue = "" Then
	ls_regvalue = as_default
End If

Return ls_regvalue
end function

on n_cst_register.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_register.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

