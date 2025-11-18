$PBExportHeader$w_cam008_lotes_campo.srw
forward
global type w_cam008_lotes_campo from w_abc_master_smpl
end type
end forward

global type w_cam008_lotes_campo from w_abc_master_smpl
integer height = 1064
string title = "[CAM008] Lotes Campos"
string menuname = "m_abc_master_smpl"
end type
global w_cam008_lotes_campo w_cam008_lotes_campo

on w_cam008_lotes_campo.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam008_lotes_campo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam008_lotes_campo
string dataobject = "d_abc_lote_campo_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado	[al_row] = '1'
this.object.cod_usr		[al_row] = gs_user
this.object.cod_origen	[al_row] = gs_origen

this.object.total_ha			[al_row] = 0.00
this.object.nro_plantas		[al_row] = 0
this.object.nro_lineas		[al_row] = 0
this.object.total_plantas	[al_row] = 0
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
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cencos"
		ls_sql = "SELECT cencos AS centro_costo, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_sector"
		ls_sql = "SELECT COD_SECTOR AS codigo_sector, " &
				  + "DESC_SECTOR AS descripcion_sector " &
				  + "FROM sector_campo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.COD_SECTOR	[al_row] = ls_codigo
			this.object.DESC_SECTOR	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "centro_benef"
		ls_sql = "SELECT CENTRO_BENEF AS centro_beneficio, " &
				  + "DESC_CENTRO AS descripcion_centro " &
				  + "FROM centro_beneficio " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.DESC_CENTRO		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count, ll_nro_lineas, ll_nro_plantas, ll_total_plantas

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cencos'
		
		// Verifica que codigo ingresado exista			
		Select desc_cencos
	     into :ls_desc1
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

		this.object.desc_cencos		[row] = ls_desc1

	CASE 'cod_sector'
		
		// Verifica que codigo ingresado exista			
		Select desc_sector
	     into :ls_desc1
		  from sector_campo
		 Where cod_sector = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.cod_sector	[row] = ls_null
			this.object.desc_sector	[row] = ls_null
			return 1
			
		end if

		this.object.desc_sector		[row] = ls_desc1

	CASE 'centro_benef'
		
		// Verifica que codigo ingresado exista			
		Select desc_centro
	     into :ls_desc1
		  from centro_beneficio
		 Where centro_benef = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Beneficio o no se encuentra activo, por favor verifique")
			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			return 1
			
		end if

		this.object.desc_centro		[row] = ls_desc1
	
	case 'nro_lineas', 'nro_plantas'
		
		ll_nro_lineas = integer(this.object.nro_lineas[row])
		ll_nro_plantas= integer(this.object.nro_plantas[row])
		
		this.object.total_plantas [row] = ll_nro_lineas * ll_nro_plantas
		
		
END CHOOSE
end event

