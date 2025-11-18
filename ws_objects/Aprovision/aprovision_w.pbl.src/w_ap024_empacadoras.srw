$PBExportHeader$w_ap024_empacadoras.srw
forward
global type w_ap024_empacadoras from w_abc_master_smpl
end type
end forward

global type w_ap024_empacadoras from w_abc_master_smpl
integer width = 2697
integer height = 2296
string title = "[AP024] Empacadoras"
string menuname = "m_mantto_smpl"
end type
global w_ap024_empacadoras w_ap024_empacadoras

on w_ap024_empacadoras.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap024_empacadoras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_ap024_empacadoras
integer x = 0
integer y = 0
integer width = 2638
integer height = 984
string dataobject = "d_abc_empacadoras_tbl"
end type

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_base

this.acceptText()

choose case lower(as_columna)
		
	case "zona_descarga"

		ls_sql = "SELECT t.zona_descarga AS codigo_zona_descarga, " &
				  + "t.descripcion AS descripcion_zona_descarga " &
				  + "FROM ap_zona_descarga t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.zona_descarga			[al_row] = ls_codigo
			this.object.desc_zona_descarga	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cencos"

		ls_sql = "SELECT t.cencos AS codigo_cencos, " &
				  + "t.desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cod_sector"
		
		ls_base = this.object.cod_base [al_row]
		
		if IsNull(ls_base) or ls_base = "" then
			MessageBox('Error', "Debe indicar primero una base")
			this.setColumn('cod_base')
			return
		end if
		
		ls_sql = "SELECT t.cod_sector AS codigo_sector, " &
				  + "t.desc_sector AS descripcion_sector " &
				  + "FROM ap_sectores t " &
				  + "where t.flag_estado = '1' " &
				  + "  and t.cod_base = '" + ls_base + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sector	[al_row] = ls_codigo
			this.object.desc_Sector	[al_row] = ls_data
			this.ii_update = 1
		end if
		
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
		
	case "centro_benef"
	
		ls_sql = "SELECT t.centro_benef AS codigo_centro_beneficio, " &
				  + "t.desc_centro AS descripcion_centro_beneficio " &
				  + "FROM centro_beneficio t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo
			this.object.desc_centro_benef	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "ot_adm"

		ls_sql = "SELECT t.ot_adm AS ot_adm, " &
				  + "t.descripcion AS descripcion_ot_adm " &
				  + "FROM ot_administracion t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	 [al_row] = '1'
this.object.tipo_empacadora [al_row] = 'F'
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc, ls_sector
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull(ls_null)

CHOOSE CASE dwo.name
	CASE 'zona_descarga'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from ap_zona_descarga
		 Where zona_descarga = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Zona de descarga o no se encuentra activo, por favor verifique")
			this.object.zona_descarga			[row] = ls_null
			this.object.desc_zona_descarga	[row] = ls_null
			return 1
		end if

		this.object.desc_zona_descarga		[row] = ls_desc

	CASE 'cencos'
		
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
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

		this.object.desc_cencos		[row] = ls_desc
	
	CASE 'cod_sector'
		
		// Verifica que codigo ingresado exista			
		Select desc_sector
	     into :ls_desc
		  from ap_Sectores
		 Where cod_sector = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Sector o no se encuentra activo, por favor verifique")
			this.object.cod_sector	[row] = ls_null
			this.object.desc_sector	[row] = ls_null
			return 1
		end if

		this.object.desc_sector		[row] = ls_desc
	
	CASE 'cod_base'
		
		ls_Sector = this.object.cod_base [row]
		
		if IsNull(ls_Sector) or ls_Sector = "" then
			MessageBox('Error', "Debe indicar primero un sector")
			return
		end if
		
		// Verifica que codigo ingresado exista			
		Select desc_base
	     into :ls_desc
		  from ap_bases
		 Where cod_base = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.cod_base		[row] = ls_null
			this.object.desc_base	[row] = ls_null
			return 1
		end if

		this.object.desc_base		[row] = ls_desc

	case "centro_benef"
		// Verifica que codigo ingresado exista			
		Select desc_Centro
	     into :ls_desc
		  from centro_beneficio
		 Where centro_benef = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.centro_benef		[row] = ls_null
			this.object.desc_centro_benef	[row] = ls_null
			return 1
		end if

		this.object.desc_centro_benef		[row] = ls_desc
		
	case "ot_adm"
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from ot_administracion
		 Where ot_adm = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe OT_ADM o no se encuentra activo, por favor verifique")
			this.object.ot_adm		[row] = ls_null
			this.object.desc_ot_adm	[row] = ls_null
			return 1
		end if

		this.object.desc_ot_adm		[row] = ls_desc

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

