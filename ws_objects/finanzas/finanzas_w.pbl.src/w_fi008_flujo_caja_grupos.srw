$PBExportHeader$w_fi008_flujo_caja_grupos.srw
forward
global type w_fi008_flujo_caja_grupos from w_abc_master_smpl
end type
end forward

global type w_fi008_flujo_caja_grupos from w_abc_master_smpl
integer width = 4338
integer height = 1616
string title = "[FI008] FLUJO DE CAJA - GRUPOS"
string menuname = "m_mantenimiento_sl"
end type
global w_fi008_flujo_caja_grupos w_fi008_flujo_caja_grupos

on w_fi008_flujo_caja_grupos.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi008_flujo_caja_grupos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
ii_pregunta_delete = 1   		// 1 = si pregunta, 0 = no pregunta (default)

end event

event ue_modify;call super::ue_modify;Int li_protect

li_protect = integer(dw_master.Object.grp_flujo_caja.Protect)

IF li_protect = 0 THEN
   dw_master.Object.grp_flujo_caja.Protect = 1
END IF



dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi008_flujo_caja_grupos
integer width = 4206
integer height = 1400
string dataobject = "d_abc_flujo_caja_grupo_tbl"
boolean hscrollbar = false
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_row] = '1'
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual( )
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_data
Long 		ll_count

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_actividad'
		
		// Verifica que codigo ingresado exista			
		Select desc_actividad
	     into :ls_data
		  from fin_actividad_flujo
		 Where cod_actividad = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de actividad no existe o no se encuentra activo, por favor verifique")
			this.object.cod_actividad	[row] = gnvo_app.is_null
			this.object.desc_actividad	[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_actividad		[row] = ls_data

END CHOOSE
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_actividad"

		ls_sql = "select f.cod_Actividad as codigo_Actividad, " &
				 + "f.desc_actividad as descripcion_actividad " &
				 + "from fin_actividad_flujo f " &
				 + "where f.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_actividad	[al_row] = ls_codigo
			this.object.desc_actividad	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

