$PBExportHeader$w_ap027_cuadrillas.srw
forward
global type w_ap027_cuadrillas from w_abc_master_smpl
end type
end forward

global type w_ap027_cuadrillas from w_abc_master_smpl
integer width = 2697
integer height = 1856
string title = "[AP027] Cuadrillas"
string menuname = "m_mantto_smpl"
end type
global w_ap027_cuadrillas w_ap027_cuadrillas

on w_ap027_cuadrillas.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap027_cuadrillas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_ap027_cuadrillas
integer x = 0
integer y = 0
integer width = 2638
integer height = 1544
string dataobject = "d_abc_cuadrillas_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	 [al_row] = '1'

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_sector
choose case lower(as_columna)
		
	case "jefe_cuadrilla"

		ls_sql = "SELECT t.cod_trabajador AS codigo_trabajador, " &
				  + "t.nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.jefe_cuadrilla	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cuadrilla_rrhh"

		ls_sql = "SELECT t.cod_cuadrilla AS cod_cuadrilla_rrhh, " &
				  + "t.turno AS turno_cuadrilla, " &
				  + "t.desc_cuadrilla AS descripcion_cuadrilla " &
				  + "FROM tg_cuadrillas t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cuadrilla_rrhh	[al_row] = ls_codigo
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
	CASE 'jefe_cuadrilla'
		
		// Verifica que codigo ingresado exista			
		Select nom_trabajador
	     into :ls_desc
		  from vw_pr_trabajador
		 Where cod_trabajador = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de trabajador o no se encuentra activo, por favor verifique")
			this.object.jefe_cuadrilla	[row] = ls_null
			this.object.nom_trabajador	[row] = ls_null
			return 1
		end if

		this.object.nom_trabajador		[row] = ls_desc
		
	CASE 'cuadrilla_rrhh'
		
		// Verifica que codigo ingresado exista			
		Select desc_cuadrilla
	     into :ls_desc
		  from tg_cuadrillas
		 Where cod_cuadrilla = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de Cuadrilla de RRHH o no se encuentra activo, por favor verifique")
			this.object.cuadrilla_rrhh	[row] = ls_null
			return 1
		end if
		
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

