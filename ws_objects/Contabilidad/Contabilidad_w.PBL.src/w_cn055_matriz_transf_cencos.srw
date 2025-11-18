$PBExportHeader$w_cn055_matriz_transf_cencos.srw
forward
global type w_cn055_matriz_transf_cencos from w_abc_master_smpl
end type
end forward

global type w_cn055_matriz_transf_cencos from w_abc_master_smpl
integer height = 1064
string title = "[CN055] Matriz Tranferencia x Cencos"
string menuname = "m_abc_master_smpl"
end type
global w_cn055_matriz_transf_cencos w_cn055_matriz_transf_cencos

on w_cn055_matriz_transf_cencos.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn055_matriz_transf_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn055_matriz_transf_cencos
string dataobject = "d_abc_matriz_transf_cencos_tbl"
end type

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
str_cnta_cntbl 	lstr_cnta

choose case lower(as_columna)
	case "org_cnta_ctbl"
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.org_cnta_ctbl 		[al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta_origen	[al_row] = lstr_cnta.desc_cnta
			this.ii_update = 1
		end if
		
		/*
		ls_sql = "select cc.cnta_ctbl as cuenta_contable, " &
				 + "cc.desc_cnta as descripcion_cnta_cntbl " &
				 + "from cntbl_cnta cc " &
				 + "where cc.flag_estado = '1' " &
				 + "  and cc.flag_permite_mov = '1'" 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.org_cnta_ctbl		[al_row] = ls_codigo
			this.object.desc_cnta_origen	[al_row] = ls_data
			this.ii_update = 1
		end if
		*/
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "dst_cnta_ctbl"
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.dst_cnta_ctbl 		[al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta_destino	[al_row] = lstr_cnta.desc_cnta
			this.ii_update = 1
		end if
		
		/*
		ls_sql = "select cc.cnta_ctbl as cuenta_contable, " &
				 + "cc.desc_cnta as descripcion_cnta_cntbl " &
				 + "from cntbl_cnta cc " &
				 + "where cc.flag_estado = '1' " &
				 + "  and cc.flag_permite_mov = '1'" 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.dst_cnta_ctbl		[al_row] = ls_codigo
			this.object.desc_cnta_destino	[al_row] = ls_data
			this.ii_update = 1
		end if
		*/
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc
Long ll_count

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'org_cnta_ctbl'
		
		Select desc_cnta
	     into :ls_desc
		from cntbl_cnta
		Where cnta_ctbl = :data 
		  and flag_estado = '1';  
		
			
		if SQLCA.SQLCode = 100 then
			Messagebox( "Error", "Cuenta Contable no existe o no esta activo, por favor verifique")
			this.object.org_cnta_ctbl		[row] = gnvo_app.is_null
			this.object.desc_cnta_origen	[row] = gnvo_app.is_null			
			return 1
		end if
		
		this.object.desc_cnta_origen[row] = ls_desc

	CASE 'cencos' 
		// Verifica que centro_costo exista
		Select desc_cencos
	     into :ls_desc
		from centros_costo
		Where cencos = :data 
		  and flag_estado = '1';  
		
			
		if SQLCA.SQLCode = 100 then
			Messagebox( "Error", "Centro de costo no existe o no esta activo, por favor verifique")
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null			
			return 1
		end if
		
		this.object.desc_cencos[row] = ls_desc

	CASE 'dst_cnta_ctbl'
		
		Select desc_cnta
	     into :ls_desc
		from cntbl_cnta
		Where cnta_ctbl = :data 
		  and flag_estado = '1';  
		
			
		if SQLCA.SQLCode = 100 then
			Messagebox( "Error", "Cuenta Contable no existe o no esta activo, por favor verifique")
			this.object.dst_cnta_ctbl		[row] = gnvo_app.is_null
			this.object.desc_cnta_destino	[row] = gnvo_app.is_null			
			return 1
		end if
		
		this.object.desc_cnta_destino	[row] = ls_desc
END CHOOSE
end event

