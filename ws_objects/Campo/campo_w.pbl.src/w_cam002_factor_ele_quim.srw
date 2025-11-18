$PBExportHeader$w_cam002_factor_ele_quim.srw
forward
global type w_cam002_factor_ele_quim from w_abc_master_smpl
end type
end forward

global type w_cam002_factor_ele_quim from w_abc_master_smpl
integer height = 1064
string title = "[CAM002] Factor del Artículo con Elementos Químicos"
string menuname = "m_abc_master_smpl"
end type
global w_cam002_factor_ele_quim w_cam002_factor_ele_quim

on w_cam002_factor_ele_quim.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam002_factor_ele_quim.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam002_factor_ele_quim
string dataobject = "d_abc_factor_elem_quim_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.factor[al_row] = 0.00
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_data2
choose case lower(as_columna)
	case "cod_art"
		ls_sql = "SELECT cod_art AS codigo_articulo, " &
				  + "desc_art AS descripion_articulo, " &
				  + "und AS unidad " &
				  + "FROM articulo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '1')

		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.object.und		[al_row] = ls_data2
			this.ii_update = 1
		end if
		
	case "cod_elemento"
		ls_sql = "SELECT cod_elemento AS codigo_elemento, " &
				  + "desc_elemento AS descripcion_elemento " &
				  + "FROM cam_elemento_quimico " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_elemento	[al_row] = ls_codigo
			this.object.desc_elemento	[al_row] = ls_data
			this.ii_update = 1
		end if
		

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_desc1, :ls_desc2
		  from articulo
		 Where cod_art = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe artículo o no se encuentra activo, por favor verifique")
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null
			return 1
			
		end if

		this.object.desc_art		[row] = ls_desc1
		this.object.und			[row] = ls_desc2

CASE 'cod_elemento' 

		// Verifica que codigo ingresado exista			
		Select desc_elemento
	     into :ls_desc1
		  from cam_elemento_quimico
		 Where cod_elemento = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Elemento Químico o no se encuentra activo, por favor verifique")
			this.object.cod_elemento	[row] = ls_null
			this.object.desc_elemento	[row] = ls_null
			return 1
			
		end if

		this.object.desc_elemento		[row] = ls_desc1


END CHOOSE
end event

