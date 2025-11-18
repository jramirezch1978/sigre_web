$PBExportHeader$w_cam011_ingenios.srw
forward
global type w_cam011_ingenios from w_abc_master_smpl
end type
end forward

global type w_cam011_ingenios from w_abc_master_smpl
integer width = 2866
integer height = 1604
string title = "[CAM011] Ingenios Azucareros"
string menuname = "m_abc_master_smpl"
end type
global w_cam011_ingenios w_cam011_ingenios

on w_cam011_ingenios.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam011_ingenios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam011_ingenios
integer width = 2706
integer height = 1200
string dataobject = "d_abc_ingenios_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'

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
	case "proveedor"
		ls_sql = "SELECT proveedor AS codigo_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
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

