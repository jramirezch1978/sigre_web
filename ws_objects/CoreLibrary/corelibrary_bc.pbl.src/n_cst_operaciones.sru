$PBExportHeader$n_cst_operaciones.sru
forward
global type n_cst_operaciones from nonvisualobject
end type
end forward

global type n_cst_operaciones from nonvisualobject autoinstantiate
end type

forward prototypes
public function boolean of_validar_ot_adm (string as_ot_adm, string as_usuario)
end prototypes

public function boolean of_validar_ot_adm (string as_ot_adm, string as_usuario);Long			ll_nro_ot_max, ll_count
u_ds_base  	lds_base

try 
	lds_base = create u_ds_base
	lds_base.DataObject = 'd_rpt_ots_validacion_tbl'
	lds_base.setTransObject(SQLCA)
	
	select count(*)
	  into :ll_count
	  from ot_adm_usuario t
	 where t.cod_usr = :as_usuario
	   and t.ot_adm  = :as_ot_adm;
	
	if ll_count = 0 then
		MessageBox('Error', 'No se ha asociado al usuario ' + as_usuario + ' con el ot_adm ' + as_ot_adm &
								+ ', por favor coordine con su jefe superior', StopSign!)
		return false
	end if
	
	select t.nro_ot_max
	  into :ll_nro_ot_max
	  from ot_adm_usuario t
	 where t.cod_usr = :as_usuario
	   and t.ot_adm  = :as_ot_adm;
		
	if ll_nro_ot_max > 0 then
	
		lds_base.Retrieve(as_ot_adm, as_usuario)
		
		if lds_base.RowCount() >= ll_nro_ot_max then
			MessageBox('Error', 'El usuario ' + as_usuario + ' con el ot_adm ' + as_ot_adm &
									+ ' a alcanzado el nro maximo de OT ' + String(ll_nro_ot_max) &
									+ ',por favor verifique!', StopSign!)
			return false
		end if
	end if
	
	return true
	
catch ( Exception ex)
	
	gnvo_app.of_Catch_exception(ex, 'Error en validacion')
	//return false
	
finally
	destroy lds_base
end try


end function

on n_cst_operaciones.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_operaciones.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

