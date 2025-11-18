$PBExportHeader$n_cst_inifile.sru
forward
global type n_cst_inifile from nonvisualobject
end type
end forward

global type n_cst_inifile from nonvisualobject
end type
global n_cst_inifile n_cst_inifile

type variables
String 	is_inifile
end variables

forward prototypes
public function string of_get_parametro (string as_section, string as_key, string as_default) throws exception
public subroutine of_set_parametro (string as_section, string as_key, string as_value) throws exception
public subroutine of_set_inifile (string as_inifile)
end prototypes

public function string of_get_parametro (string as_section, string as_key, string as_default) throws exception;String 		ls_Return
Exception 	ex

If trim(this.is_inifile) = '' or IsNull(this.is_iniFile) then
	ex = create Exception
	ex.setMessage("Error en of_get_parametro(). No se ha especificado el archivo INI")
	throw ex
end if

If not FileExists(this.is_inifile) then
	ex = create Exception
	ex.setMessage("Error en of_get_parametro(). No existe archivo INI: "+ this.is_iniFile)
	throw ex
end if

ls_REturn = ProfileString (this.is_iniFile, as_section, as_key, "DEFAULT_VALUE")

if ls_REturn = "DEFAULT_VALUE" then
	//no existe el valor asi que lo coloco
	ls_Return = as_default
	this.of_set_Parametro(as_section, as_key, ls_Return)
end if

return ls_return
end function

public subroutine of_set_parametro (string as_section, string as_key, string as_value) throws exception;String 		ls_Return
Exception 	ex

If trim(this.is_inifile) = '' or IsNull(this.is_iniFile) then
	ex = create Exception
	ex.setMessage("Error en of_set_parametro(). No se ha especificado el archivo INI")
	throw ex
end if

If not FileExists(this.is_inifile) then
	ex = create Exception
	ex.setMessage("Error en of_set_parametro(). No existe archivo INI: "+ this.is_iniFile)
	throw ex
end if

if SetProfileString(this.is_iniFile, as_section, as_key, as_value) = -1 then
	ex = create Exception
	ex.setMessage("Error en of_set_parametro(). Ha ocurrido un error en SetProfileString en Archivo INI: "+ this.is_iniFile)
	throw ex
end if
		

end subroutine

public subroutine of_set_inifile (string as_inifile);this.is_inifile = as_inifile
end subroutine

on n_cst_inifile.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_inifile.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

