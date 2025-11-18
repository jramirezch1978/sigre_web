$PBExportHeader$w_fi009_flujo_caja_concepto.srw
forward
global type w_fi009_flujo_caja_concepto from w_abc_master_smpl
end type
end forward

global type w_fi009_flujo_caja_concepto from w_abc_master_smpl
integer width = 3177
integer height = 2044
string title = "[FI-009]  FLUJO DE CAJA - CONCEPTO"
string menuname = "m_mantenimiento_sl"
end type
global w_fi009_flujo_caja_concepto w_fi009_flujo_caja_concepto

on w_fi009_flujo_caja_concepto.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi009_flujo_caja_concepto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
end event

event ue_modify();call super::ue_modify;
IF integer(dw_master.Object.cod_flujo_caja.protect) = 0 THEN
	dw_master.Object.cod_flujo_caja.protect = 1
END IF	
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi009_flujo_caja_concepto
integer width = 3150
integer height = 1748
string dataobject = "d_abc_flujo_caja_concepto_tbl"
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr			[al_row] = gs_user
this.object.flag_estado		[al_row] = '1'
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_actual()
this.SetColumn('cod_actividad')
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

Accepttext()

CHOOSE CASE dwo.name
	CASE 'grp_flujo_caja'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from grupo_cod_flujo_caja
		 Where grp_flujo_caja = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "El código de Grupo de Flujo de Caja no existe o no esta activo, por favor verifique")
			this.object.grp_flujo_caja	[row] = gnvo_app.is_null
			this.object.desc_grupo		[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_grupo		[row] = ls_desc

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
string ls_codigo, ls_data, ls_sql, ls_cod_actividad
choose case lower(as_columna)

	case "cod_actividad"

		ls_sql = "select t.cod_actividad as codigo_actividad, " &
				 + "t.desc_actividad as descripcion_actividad " &
				 + "from fin_actividad_flujo t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_actividad	[al_row] = ls_codigo
			this.object.desc_actividad	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "grp_flujo_caja"
		
		ls_cod_actividad = this.object.cod_actividad [al_Row]
		
		if ISNull(ls_cod_actividad) or ls_cod_actividad = '' then
			MessageBox('Error', 'Debe Elegir primero una actividad')
			this.setColumn('cod_actividad')
			return
		end if

		ls_sql = "select t.grp_flujo_caja as codigo_grupo, " &
				 + "t.descripcion as descripcion_grupo " &
				 + "from grupo_cod_flujo_caja t " &
				 + "where t.flag_estado = '1' " &
				 + "and t.cod_actividad = '" + ls_cod_actividad + "' " &
				 + "order by descripcion_grupo"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.grp_flujo_caja	[al_row] = ls_codigo
			this.object.desc_grupo		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

