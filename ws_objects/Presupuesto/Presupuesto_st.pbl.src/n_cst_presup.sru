$PBExportHeader$n_cst_presup.sru
forward
global type n_cst_presup from nonvisualobject
end type
end forward

global type n_cst_presup from nonvisualobject
end type
global n_cst_presup n_cst_presup

forward prototypes
public function boolean of_actualiza_prsp_caja ()
end prototypes

public function boolean of_actualiza_prsp_caja ();string ls_mensaje

update prsp_caja_det pcd
   set pcd.imp_ejecutado = (select round(nvl(sum(vw.imp_ejecutado), 0),4)
                              from vw_pto_presup_caja_ejec vw
                             where vw.nro_presupuesto = pcd.nro_presupuesto
                               and vw.nro_item        = pcd.nro_item)
where pcd.imp_ejecutado <> (select round(nvl(sum(vw.imp_ejecutado),0),4)
                              from vw_pto_presup_caja_ejec vw
                             where vw.nro_presupuesto = pcd.nro_presupuesto
                               and vw.nro_item        = pcd.nro_item);

if SQLCA.SQLCode < 0 then
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al actualizar el importe ejecutado del presupuesto de Caja. Por favor verifique!~r~n' &
						   + 'Error: ' + ls_mensaje, StopSign!)
	return false
end if

commit;

return true
end function

on n_cst_presup.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_presup.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

