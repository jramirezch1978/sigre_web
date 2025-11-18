$PBExportHeader$n_cst_empresa_data.sru
$PBExportComments$funciones para obtener informacion de la empresa
forward
global type n_cst_empresa_data from nonvisualobject
end type
end forward

global type n_cst_empresa_data from nonvisualobject
end type
global n_cst_empresa_data n_cst_empresa_data

forward prototypes
public function integer of_get_origen (ref string as_origen)
public function integer of_get_ruc (ref string as_ruc)
public function integer of_get_codigo (ref string as_codigo)
public function integer of_get_data (ref string as_empresa, ref string as_logo)
end prototypes

public function integer of_get_origen (ref string as_origen);Select cod_origen
	into :as_origen
	from genparam
	where reckey = '1' ;
	
IF SQLCA.SQLCode > 0 THEN	MessageBox("Error Base Datos", SQLCA.SQLErrText)
	
RETURN	SQLCA.SQLCode

end function

public function integer of_get_ruc (ref string as_ruc);String	ls_codigo
Integer	li_rc

li_rc = of_get_codigo(ls_codigo)

IF li_rc = 0 THEN 
	Select  ruc
		into :as_ruc
		from empresa
		where cod_empresa = :ls_codigo ;
		
	IF SQLCA.SQLCode > 0 THEN
		MessageBox("Error Base Datos", SQLCA.SQLErrText)
		li_rc = SQLCA.SQLCode
	END IF
END IF
	
RETURN	li_rc


end function

public function integer of_get_codigo (ref string as_codigo);Select COD_EMPRESA
	into :as_codigo
	from GENPARAM
	where reckey = '1' ;
	
IF SQLCA.SQLCode > 0 THEN	MessageBox("Error Base Datos", SQLCA.SQLErrText)
	
RETURN	SQLCA.SQLCode


end function

public function integer of_get_data (ref string as_empresa, ref string as_logo);String	ls_codigo
Integer	li_rc

li_rc = of_get_codigo(ls_codigo)

IF li_rc = 0 THEN 
	Select NOMBRE, LOGO
		into :as_empresa, :as_logo
		from EMPRESA
		where COD_EMPRESA = :ls_codigo ;
		
	IF SQLCA.SQLCode > 0 THEN
		MessageBox("Error Base Datos", SQLCA.SQLErrText)
		li_rc = SQLCA.SQLCode
	END IF
END IF
	
RETURN	li_rc



end function

on n_cst_empresa_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_empresa_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

