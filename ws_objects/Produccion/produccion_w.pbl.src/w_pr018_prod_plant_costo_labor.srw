$PBExportHeader$w_pr018_prod_plant_costo_labor.srw
forward
global type w_pr018_prod_plant_costo_labor from w_abc_master_smpl
end type
end forward

global type w_pr018_prod_plant_costo_labor from w_abc_master_smpl
integer width = 3195
integer height = 1020
string title = "Costos Labor(PR018)"
string menuname = "m_mantto_consulta"
end type
global w_pr018_prod_plant_costo_labor w_pr018_prod_plant_costo_labor

on w_pr018_prod_plant_costo_labor.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_pr018_prod_plant_costo_labor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'PLAN_COSTO_LABOR'

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr018_prod_plant_costo_labor
event ue_display ( string as_columna,  long al_row )
integer width = 3095
string dataobject = "d_abc_prod_costo_labor_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

choose case upper(as_columna)
		
		case "COD_LABOR"

		ls_sql = "SELECT COD_LABOR AS CODIGO_LABOR, " &
				  + "DESC_LABOR AS DESCRIPCION " &
				  + "FROM LABOR " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor		[al_row] = ls_codigo
			this.object.desc_labor		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
//str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cod_labor"
		
		ls_codigo = this.object.cod_labor[row]

		SetNull(ls_data)
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Labor no existe o no esta definida", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_labor	  	[row] = ls_codigo
			this.object.desc_labor		[row] = ls_codigo
			return 1
		end if

		this.object.desc_labor			[row] = ls_data
		
end choose
end event

