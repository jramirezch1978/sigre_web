$PBExportHeader$n_cst_empresa.sru
forward
global type n_cst_empresa from nonvisualobject
end type
end forward

global type n_cst_empresa from nonvisualobject
end type
global n_cst_empresa n_cst_empresa

type variables
String 	is_nom_empresa, is_ruc, is_direccion, is_distrito, is_SIGLA, is_empresa, is_telefono, is_email
string	is_nom_origen, is_ubigeo, is_provincia, is_departamento, is_siglas_cod_sku
n_cst_utilitario	invo_util
end variables

forward prototypes
public subroutine of_load (string as_empresa)
public function string nombre ()
public function string ruc ()
public function string of_telefono (string as_origen)
public function string of_email (string as_origen, string as_user)
public subroutine of_load_origen (string as_origen)
public function string of_direccion (string as_origen)
end prototypes

public subroutine of_load (string as_empresa);Integer				li_count
String 				ls_mensaje


try 
	select count(*)
		into :li_count
	from empresa
	where cod_empresa = :as_empresa
	  OR SIGLA			= :as_empresa;
	
	// Si no hay datos entonces cargo con la empresa que esta en genparam
	if li_count = 0 then
		select cod_empresa
			into :is_empresa
		from genparam
		where reckey = '1';
	end if
		
		
	select 	cod_empresa, nombre, ruc, decode(dir_calle, null, direccion, dir_calle) , sigla, dir_distrito, dir_ubigeo, 
				dir_provincia, dir_departamento
		into 	:is_empresa, :is_nom_empresa, :is_ruc, :is_direccion, :is_sigla, :is_distrito, :is_ubigeo, 
				:is_provincia, :is_departamento
	from empresa
	where cod_empresa = :as_empresa
	  OR SIGLA			= :as_empresa;
	  
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al recuperar parametros de la tabla EMPRESA. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	  
	IF SQLCA.SQLCode =100 then
		ROLLBACK;
		MessageBox('Error', 'No hay parametros en tabla empresa que cumpla con el parametro: ' + as_empresa, StopSign!)
		return
	end if
	
	//Remplazo las comillas dobles y otros caracteres especiales por nada
	is_direccion = invo_util.of_replace(is_direccion, '"', '')
	
	
	
	//Cargo Datos según el origen
	this.of_load_origen(gs_origen)
	
	//Cargo las siglas para el codigo SKU
	if trim(is_sigla) <> '' then
		this.is_siglas_cod_sku = left(trim(is_sigla),1) + right(trim(is_sigla), 1)
	else
		this.is_siglas_cod_sku = left(trim(is_empresa),1) + right(trim(is_empresa), 1)
	end if
	
	this.is_siglas_cod_sku = gnvo_app.of_get_parametro("SIGLAS_EMPRESA_CODIGO_SKU", this.is_siglas_cod_sku)

catch ( Exception ex )
	
	ls_mensaje = ex.getMessage()
	ROLLBACK;
	
	MessageBox('Error', 'Ha ocurrido una excepcion en la función of_load de n_cst_empresa. Mensaje: ' + ls_mensaje, StopSign!)
	
end try



end subroutine

public function string nombre ();return this.is_nom_empresa
end function

public function string ruc ();return this.is_ruc
end function

public function string of_telefono (string as_origen);String ls_tel, ls_fax, ls_cad, ls_mensaje

Select telefono, fax
	into :ls_tel, :ls_fax 
from origen
where cod_origen = :as_origen;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'A ocurrido un problema al consultar la tabla ORIGEN. Mensaje: ' + ls_mensaje, StopSign!)
	return gnvo_app.is_null
end if
	

ls_Cad = ''
if not isnull( ls_tel) then ls_cad = 'Tel.: ' + ls_tel 
if not isnull( ls_fax) then ls_cad += ' Fax: ' + ls_fax
  
Return ls_cad
end function

public function string of_email (string as_origen, string as_user);String ls_email
/*
	Cambio Solicitado por PEZEX, 
	25/10/2012, Que tome el email del usuario, si no existe entonces se toma el email de la empresa
*/

Select email 
	into :ls_email 
from usuario
where cod_usr = :as_user;

if SQLCA.SQLCode = 100 or IsNull(ls_email) or ls_email = '' then
	Select email 
		into :ls_email 
	from origen
	where cod_origen = :as_origen;
end if

if Not IsNull(ls_email) then ls_email = 'Email: ' + ls_email

Return ls_email
end function

public subroutine of_load_origen (string as_origen);select email, telefono, nombre
	into :is_email, :is_telefono, :is_nom_origen
from origen 
where cod_origen = :as_origen;


end subroutine

public function string of_direccion (string as_origen);string ls_direccion, ls_distrito, ls_provincia, ls_departamento, ls_return, ls_mensaje

select t.dir_calle, t.dir_distrito, t.dir_provincia, t.dir_departamento
	into :ls_direccion, :ls_distrito, :ls_provincia, :ls_departamento
from origen t
where t.cod_origen = :as_origen;

if SQLCA.SQLCode < 0 then 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al obtener datos por origen. Mensaje: ' + ls_mensaje, StopSign!)
	return gnvo_app.is_null
end if

ls_return = ''

if Not IsNull(ls_direccion) and trim(ls_direccion) <> '' then
	ls_return += trim(ls_direccion)
end if

if Not IsNull(ls_distrito) and trim(ls_distrito) <> '' then
	ls_return += ' ' + trim(ls_distrito)
end if

if Not IsNull(ls_provincia) and trim(ls_provincia) <> '' then
	ls_return += ' ' + trim(ls_provincia)
end if

if Not IsNull(ls_departamento) and trim(ls_departamento) <> '' then
	ls_return += ' ' + trim(ls_departamento)
end if


return ls_return


end function

on n_cst_empresa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_empresa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

