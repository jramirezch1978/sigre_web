$PBExportHeader$w_pr043_especies.srw
forward
global type w_pr043_especies from w_abc_master_smpl
end type
end forward

global type w_pr043_especies from w_abc_master_smpl
integer height = 1064
string title = "[PR043] Especies para producción"
string menuname = "m_mantto_smpl"
end type
global w_pr043_especies w_pr043_especies

on w_pr043_especies.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr043_especies.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr043_especies
string dataobject = "d_abc_especies_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cencos_os"

		ls_sql = "SELECT t.cencos AS codigo_Cencos, " &
				  + "t.desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos_os	[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "centro_benef"

		ls_sql = "SELECT t.centro_benef AS centro_beneficio, " &
				  + "t.desc_centro AS descripcion_Centro_benef " &
				  + "FROM centro_beneficio t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo
			this.object.desc_centro_benef	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cencos_os'
		
		// Verifica que codigo ingresado exista			
		Select desc_cencos
	     into :ls_desc
		  from centros_costo
		 Where cencos = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.cencos_os	[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
			
		end if

		this.object.desc_cencos		[row] = ls_desc

	CASE 'centro_benef'
		
		// Verifica que codigo ingresado exista			
		Select desc_centro
	     into :ls_desc
		  from centro_beneficio
		 Where centro_benef = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Beneficio o no se encuentra activo, por favor verifique")
			this.object.centro_benef		[row] = ls_null
			this.object.desc_centro_benef	[row] = ls_null
			return 1
			
		end if

		this.object.desc_centro_benef		[row] = ls_desc

END CHOOSE
end event

