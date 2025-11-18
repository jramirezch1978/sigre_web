$PBExportHeader$n_cst_regkey.sru
forward
global type n_cst_regkey from nonvisualobject
end type
end forward

global type n_cst_regkey from nonvisualobject autoinstantiate
end type

type variables
String	is_Software				= "SIGRE"

end variables

forward prototypes
public subroutine of_set_register (string as_empresa, string as_entry, string as_value) throws exception
public function string of_regkey_register ()
public function string of_regkey_config ()
public function string of_get_register (string as_empresa, string as_entry, string as_default) throws exception
public function str_sesion of_get_keys (string as_regkey) throws exception
public function boolean of_save_sesion (string as_empresa, str_sesion astr_sesion) throws exception
public function string of_get_register (string as_regkey, string as_entry)
public subroutine of_set_regkey (string as_regkey, string as_entry, string as_value)
public function boolean of_existen_sesiones (string as_empresa)
public function str_array of_get_sesiones (string as_empresa) throws exception
public function boolean of_delete_sesion (string as_empresa, string as_id_sesion) throws exception
end prototypes

public subroutine of_set_register (string as_empresa, string as_entry, string as_value) throws exception;String	ls_regkey
Exception	ex

if trim(as_empresa) = '' then
	ex = create Exception
	ex.setMessage('Debe indicar una empresa, por favor verifique!')
	throw ex
end if

ls_regkey = this.of_regkey_register() + "\" + as_empresa

RegistrySet(ls_regkey, as_entry, as_value)

end subroutine

public function string of_regkey_register ();String	ls_return
ls_Return = "HKEY_CURRENT_USER\Software\" + is_Software + "\Register"

return ls_return
end function

public function string of_regkey_config ();string	ls_return

ls_return = "HKEY_CURRENT_USER\Software\" + is_Software + "\Configuration"

return ls_return
end function

public function string of_get_register (string as_empresa, string as_entry, string as_default) throws exception;String 		ls_regvalue, ls_regkey
Exception	ex

if trim(as_empresa) = '' then
	ex = create Exception
	ex.setMessage('Debe indicar una empresa, por favor verifique!')
	throw ex
end if

ls_regkey = this.of_regkey_register() + "\" + as_empresa

RegistryGet(ls_regkey, as_entry, ls_regvalue)

If trim(ls_regvalue) = "" Then
	if trim(as_default) <> "" then
		ls_regvalue = as_default
	
		this.of_set_Register(as_empresa, as_entry, ls_regvalue)
	end if
End If

Return ls_regvalue

end function

public function str_sesion of_get_keys (string as_regkey) throws exception;string 		ls_subKeyList[]
str_sesion	lstr_return
Exception	ex
integer 		li_rtn

li_rtn = RegistryKeys(as_regkey, ls_subKeyList)

IF li_rtn = -1 THEN
	
	ex = create Exception
	ex.setMessage("Ha ocurrido un error para obtener un listado del registro " + as_regkey)
	throw ex
	
END IF

if UpperBound(ls_subKeyList) = 0 then
	ex = create Exception
	ex.setMessage("La llave del registro " + as_regkey + " no ha devuelto ningun listado de llaves.")
	throw ex
end if

lstr_return.b_Return = true
lstr_return.keys	 	= ls_subKeyList
return lstr_return

end function

public function boolean of_save_sesion (string as_empresa, str_sesion astr_sesion) throws exception;str_sesion 	lstr_return
String		ls_regkey, ls_subRegKey, ls_fecha, ls_max_sesiones, ls_id_sesion, ls_codigo
integer		li_i, li_max_sesiones
boolean		lb_find
Date 			ld_fecha

try 
	
	//Obtengo el regky de las sesiones
	ls_regkey 			= this.of_regkey_register() + "\" + as_empresa + "\Sessiones"
	ls_max_sesiones 	= this.of_get_register(as_empresa, "MAX_SESIONES", "000")
	
	li_max_sesiones = Integer(ls_max_sesiones)
	
	if li_max_sesiones = 0 then
		//Si no hay sesiones ingresadas entonces tomo la primera
		li_max_sesiones ++;
		
		//designo el id de la sesion
		ls_id_sesion = string(li_max_sesiones, '000')
		
		//Obtengo la subcadena
		ls_subRegKey = ls_regkey + "\Session" + ls_id_sesion
		
		
		//Grabo los detalles de la sesión
		this.of_set_regkey(ls_subRegKey, 'ID_SESSION', ls_id_sesion)
		this.of_set_regkey(ls_subRegKey, 'COD_USR', astr_sesion.codigo)
		this.of_set_regkey(ls_subRegKey, 'FECHA', string(astr_sesion.fecha, 'dd/mm/yyyy'))
		this.of_set_regkey(ls_subRegKey, 'NOM_USUARIO', astr_sesion.nombre)
		this.of_set_regkey(ls_subRegKey, 'XCLAVEX', astr_sesion.clave)
		
		//Grabo el maximo de sesiones
		this.of_set_register(as_empresa, "MAX_SESIONES", string(li_max_sesiones, '000'))
		
	else
		
		
		lb_find = false
		
		for li_i = 1 to li_max_sesiones
			ls_subRegKey = ls_regKey + "\Session" + string(li_i, '000')
			
			ls_id_sesion	= this.of_get_register(ls_subRegKey, "ID_SESSION")
			ls_fecha 		= this.of_get_register(ls_subRegKey, "FECHA")
			ls_codigo		= this.of_get_register(ls_subRegKey, "COD_USR")
			
			if trim(ls_fecha) <> '' then
				ld_fecha = date(ls_fecha)
				
				//Si encuentro uno que ya vención entonces ese lo tomo como libre
				if ld_fecha < Today() then
					lb_find = true
					exit
				end if
				
				if ls_codigo = astr_sesion.codigo then
					lb_find = true
					exit
				end if
			else
				lb_find = true
				exit
			end if
		next
		
		//si no lo he encontrado entonces adiciono un item mas
		if not lb_find then
			//Si no hay sesiones ingresadas entonces tomo la primera
			li_max_sesiones ++;
			
			//designo el id de la sesion
			ls_id_sesion = string(li_max_sesiones, '000')
			
			//Obtengo la subcadena
			ls_subRegKey = ls_regkey + "\Session" + ls_id_sesion
			
			//Grabo el maximo de sesiones
			this.of_set_register(as_empresa, "MAX_SESIONES", string(li_max_sesiones, '000'))

		end if
		
		//Grabo los detalles de la sesión
		this.of_set_regkey(ls_subRegKey, 'ID_SESSION', ls_id_sesion)
		this.of_set_regkey(ls_subRegKey, 'COD_USR', astr_sesion.codigo)
		this.of_set_regkey(ls_subRegKey, 'FECHA', string(astr_sesion.fecha, 'dd/mm/yyyy'))
		this.of_set_regkey(ls_subRegKey, 'NOM_USUARIO', astr_sesion.nombre)
		this.of_set_regkey(ls_subRegKey, 'XCLAVEX', astr_sesion.clave)


	end if
	
	return true

catch ( Exception ex )
	
	throw ex
	return false
	
end try

end function

public function string of_get_register (string as_regkey, string as_entry);String 		ls_regvalue

RegistryGet(as_regkey, as_entry, ls_regvalue)

Return ls_regvalue

end function

public subroutine of_set_regkey (string as_regkey, string as_entry, string as_value);
RegistrySet(as_regkey, as_entry, as_value)

end subroutine

public function boolean of_existen_sesiones (string as_empresa);str_array lstr_return

try 
	lstr_return = this.of_get_sesiones(as_empresa)

	if not lstr_return.b_return then return false
	
	if UpperBound(lstr_return.session_array) > 0 then
		
		return true
		
	else
		
		return false
		
	end if

catch (Exception ex)
	
	throw ex
	
end try



end function

public function str_array of_get_sesiones (string as_empresa) throws exception;str_array 	lstr_return
str_sesion	lstr_sesiones[]
String		ls_regkey, ls_subRegKey, ls_fecha, ls_max_sesiones, ls_codigo, ls_nom_usuario, &
				ls_xclavex, ls_id_sesion
integer		li_i, li_max_sesiones, li_index
boolean		lb_find
Date 			ld_fecha

try 
	
	//Obtengo el regky de las sesiones
	ls_regkey 			= this.of_regkey_register() + "\" + as_empresa + "\Sessiones"
	ls_max_sesiones 	= this.of_get_register(as_empresa, "MAX_SESIONES", "000")
	
	li_max_sesiones = Integer(ls_max_sesiones)
	
	for li_i = 1 to li_max_sesiones
		ls_subRegKey = ls_regKey + "\Session" + string(li_i, '000')
		
		ls_id_sesion	= this.of_get_register(ls_subRegKey, "ID_SESSION")
		ls_fecha 		= this.of_get_register(ls_subRegKey, "FECHA")
		ls_codigo		= this.of_get_register(ls_subRegKey, "COD_USR")
		ls_nom_usuario	= this.of_get_register(ls_subRegKey, "NOM_USUARIO")
		ls_xclavex		= this.of_get_register(ls_subRegKey, "XCLAVEX")
		
		if trim(ls_fecha) <> '' then
			ld_fecha = date(ls_fecha)
			
			//Si encuentro uno que ya vención entonces ese lo tomo como libre
			if ld_fecha >= Today() and trim(ls_codigo) <> '' then
				li_index = UpperBound(lstr_sesiones) + 1
				
				//Lleno la sesión con los datos necesarios
				lstr_sesiones[li_index].id_sesion 	= ls_id_sesion
				lstr_sesiones[li_index].fecha 		= ld_fecha
				lstr_sesiones[li_index].codigo 		= ls_codigo
				lstr_sesiones[li_index].nombre 		= ls_nom_usuario
				lstr_sesiones[li_index].clave 		= ls_xclavex
				
			end if
			
		end if
	next
	
	lstr_return.session_array = lstr_sesiones
	lstr_return.b_return = true
		
	return lstr_return

catch ( Exception ex )
	
	throw ex
	
	lstr_return.b_return = false
	return lstr_return
	
end try

end function

public function boolean of_delete_sesion (string as_empresa, string as_id_sesion) throws exception;str_sesion 	lstr_return
String		ls_regkey, ls_subRegKey
integer		li_i

try 
	
	//Obtengo el regky de las sesiones
	ls_regkey 			= this.of_regkey_register() + "\" + as_empresa + "\Sessiones"
	
	//Obtengo la subcadena
	ls_subRegKey = ls_regkey + "\Session" + as_id_sesion
		
	//Grabo los detalles de la sesión
	this.of_set_regkey(ls_subRegKey, 'COD_USR', '')
	this.of_set_regkey(ls_subRegKey, 'FECHA', '')
	this.of_set_regkey(ls_subRegKey, 'NOM_USUARIO', '')
	this.of_set_regkey(ls_subRegKey, 'XCLAVEX', '')
		
	
	return true

catch ( Exception ex )
	
	throw ex
	return false
	
end try

end function

on n_cst_regkey.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_regkey.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

