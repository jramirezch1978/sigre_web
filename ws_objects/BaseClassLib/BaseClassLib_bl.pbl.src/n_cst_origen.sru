$PBExportHeader$n_cst_origen.sru
forward
global type n_cst_origen from nonvisualobject
end type
end forward

global type n_cst_origen from nonvisualobject
end type
global n_cst_origen n_cst_origen

forward prototypes
public function string of_desc_origen (string as_origen)
end prototypes

public function string of_desc_origen (string as_origen);string ls_desc_origen

if gnvo_app.ib_new_struct then
else
	select nombre
	  into :ls_desc_origen
	from origen
	where cod_origen = :gnvo_app.is_origen;
end if

gnvo_app.of_valida_transaccion( "No se pudo consultar maestro de orígenes", SQLCA)

return ls_desc_origen
end function

on n_cst_origen.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_origen.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

