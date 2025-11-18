$PBExportHeader$w_fi013_param_autoriz.srw
forward
global type w_fi013_param_autoriz from w_abc_master_smpl
end type
end forward

global type w_fi013_param_autoriz from w_abc_master_smpl
integer width = 2633
integer height = 1708
string title = "AUTORIZADOS A GENERAR ADELANTOS (FI013)"
string menuname = "m_mantenimiento_sl"
end type
global w_fi013_param_autoriz w_fi013_param_autoriz

on w_fi013_param_autoriz.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi013_param_autoriz.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;//of_position_window(0,0)

update maestro_param_autoriz m
   set m.nro_solicitudes_pend = (select count(*)
											  from solicitud_giro sg 
											 where sg.cod_relacion = m.cod_relacion 
											   and sg.flag_estado in ('2', '3', '4'))
where m.nro_solicitudes_pend <> (select count(*)
											  from solicitud_giro sg 
											 where sg.cod_relacion = m.cod_relacion 
											   and sg.flag_estado in ('2', '3', '4'));

if gnvo_app.of_existsError(SQLCA) then
	rollback;
	return
end if

commit;
	
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi013_param_autoriz
integer width = 2555
integer height = 1476
string dataobject = "d_abc_param_autoriz_tbl"
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;
str_seleccionar lstr_seleccionar 

IF row = 0 THEN RETURN
CHOOSE CASE dwo.Name
	CASE 'cod_relacion'  
      lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CODIGO_RELACION.COD_RELACION AS RELACION_CODIGO, '&
		                              +' CODIGO_RELACION.NOMBRE AS NOMBRES '&
										      +' FROM CODIGO_RELACION '&

										 
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF isValid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			setitem(row,'cod_relacion' ,lstr_seleccionar.param1[1])
			setitem(row,'nombre' ,lstr_seleccionar.param2[1])
         ii_update = 1
		END IF 
END CHOOSE			

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("cod_relacion.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(This)
end event

event dw_master::itemchanged;call super::itemchanged;Long   ll_count
String ls_nombres,ls_codigo

Accepttext()

CHOOSE CASE dwo.name
		 CASE 'cod_relacion'
				SELECT Count(*)
				  INTO :ll_count
				  FROM proveedor 
				 WHERE (proveedor = :data) ;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					Messagebox('Aviso','Codigo No Existe , Verifique!')
					This.object.cod_relacion [row] = ls_codigo
					Return 1
				ELSE
					SELECT nom_proveedor
					  INTO :ls_nombres
					  FROM proveedor 
					 WHERE (proveedor = :data) ;
				   
					This.object.nombre [row] = ls_nombres					
				END IF
		
END CHOOSE

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

