$PBExportHeader$w_ap025_sectores.srw
forward
global type w_ap025_sectores from w_abc_master_smpl
end type
end forward

global type w_ap025_sectores from w_abc_master_smpl
integer width = 2697
integer height = 1856
string title = "[AP025] Sectores"
string menuname = "m_mantto_smpl"
end type
global w_ap025_sectores w_ap025_sectores

on w_ap025_sectores.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap025_sectores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_ap025_sectores
integer x = 0
integer y = 0
integer width = 2638
integer height = 1544
string dataobject = "d_abc_sectores_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	 [al_row] = '1'

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
		
	case "cod_base"

		ls_sql = "SELECT t.cod_base AS codigo_base, " &
				  + "t.desc_base AS descripcion_base " &
				  + "FROM ap_bases t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_base		[al_row] = ls_codigo
			this.object.desc_base	[al_row] = ls_data
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
	CASE 'cod_base'
		
		// Verifica que codigo ingresado exista			
		Select desc_base
	     into :ls_desc1
		  from ap_bases
		 Where cod_base = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Codigo de Base o no se encuentra activo, por favor verifique")
			this.object.cod_base		[row] = ls_null
			this.object.desc_base	[row] = ls_null
			return 1
			
		end if

		this.object.desc_base		[row] = ls_desc1

END CHOOSE
end event

