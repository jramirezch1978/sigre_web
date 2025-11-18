$PBExportHeader$n_cst_flota.sru
forward
global type n_cst_flota from nonvisualobject
end type
end forward

global type n_cst_flota from nonvisualobject
end type
global n_cst_flota n_cst_flota

forward prototypes
public function str_nave of_get_nave (string as_tipo_flota)
public function String of_get_cod_nave ()
end prototypes

public function str_nave of_get_nave (string as_tipo_flota);str_nave 		lstr_nave
str_parametros	lstr_param

lstr_param.string1 = as_tipo_flota

OpenWithParm(w_search_naves, lstr_param)
if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_nave.b_return = false
	return lstr_nave
end if

lstr_nave = Message.PowerObjectParm

return lstr_nave
end function

public function String of_get_cod_nave ();string ls_mensaje, ls_cod_nave

//create or replace function USF_FL_COD_NAVE
//(ac_cod_origen origen.cod_origen%type)
//return varchar2 is

DECLARE USF_FL_COD_NAVE PROCEDURE FOR
		USF_FL_COD_NAVE( :gs_origen );

EXECUTE USF_FL_COD_NAVE;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_FL_COD_NAVE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(ls_cod_nave)
	return ls_cod_nave
END IF


FETCH USF_FL_COD_NAVE INTO :ls_cod_nave ;
CLOSE USF_FL_COD_NAVE ;

return ls_cod_nave
end function

on n_cst_flota.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_flota.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

