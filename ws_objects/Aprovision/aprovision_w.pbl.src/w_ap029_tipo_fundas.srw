$PBExportHeader$w_ap029_tipo_fundas.srw
forward
global type w_ap029_tipo_fundas from w_abc_master_smpl
end type
end forward

global type w_ap029_tipo_fundas from w_abc_master_smpl
integer width = 2697
integer height = 1856
string title = "[AP029] Tipos de Fundas"
string menuname = "m_mantto_smpl"
end type
global w_ap029_tipo_fundas w_ap029_tipo_fundas

on w_ap029_tipo_fundas.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap029_tipo_fundas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_ap029_tipo_fundas
integer x = 0
integer y = 0
integer width = 2638
integer height = 1544
string dataobject = "d_abc_tipo_fundas_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	 [al_row] = '1'

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_sector
choose case lower(as_columna)
		
	case "cod_art"

		ls_sql = "SELECT t.cod_art AS codigo_articulo, " &
				  + "t.desc_art AS descripcion_articulo " &
				  + "FROM articulo t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc, ls_sector
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull(ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select desc_Art
	     into :ls_desc
		  from articulo
		 Where cod_art = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Artículo o no se encuentra activo, por favor verifique")
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			return 1
		end if

		this.object.desc_art		[row] = ls_desc
		
END CHOOSE
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

