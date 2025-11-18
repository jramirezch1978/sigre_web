$PBExportHeader$w_pr019_prod_plant_ot_adm.srw
forward
global type w_pr019_prod_plant_ot_adm from w_abc_master_smpl
end type
end forward

global type w_pr019_prod_plant_ot_adm from w_abc_master_smpl
integer height = 1016
string title = "Plantilla de Costos OT_ADM(PR019)"
string menuname = "m_mantto_consulta"
end type
global w_pr019_prod_plant_ot_adm w_pr019_prod_plant_ot_adm

on w_pr019_prod_plant_ot_adm.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_pr019_prod_plant_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'PLAN_COSTO_OT_ADM'

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr019_prod_plant_ot_adm
event ue_display ( string as_columna,  long al_row )
string dataobject = "d_abc_plant_ot_adm_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

choose case upper(as_columna)
		
		case "OT_ADM"

		ls_sql = "SELECT OT_ADM AS CODIGO, " &
				  + "DESCRIPCION AS DESCRIPCION1 " &
				  + "FROM OT_ADMINISTRACION " &
				  + "WHERE FLAG_REPLICACION = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.descripcion		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "ot_adm"
		

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from ot_administracion
		where ot_adm= :data
		  and flag_replicacion = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "OT_ADM no existe o no esta definida", StopSign!)
			SetNull(ls_codigo)
			this.object.ot_adm	  	[row] = data
			this.object.descripcion		[row] = data
			return 1
		end if

		this.object.descripcion			[row] = ls_data
		
end choose
end event

