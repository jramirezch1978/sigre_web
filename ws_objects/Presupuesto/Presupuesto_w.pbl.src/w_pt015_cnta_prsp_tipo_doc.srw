$PBExportHeader$w_pt015_cnta_prsp_tipo_doc.srw
forward
global type w_pt015_cnta_prsp_tipo_doc from w_abc_master_smpl
end type
end forward

global type w_pt015_cnta_prsp_tipo_doc from w_abc_master_smpl
string title = "Cnta Prsp Vs Tipo Doc (PT015)"
string menuname = "m_mantenimiento_simple"
end type
global w_pt015_cnta_prsp_tipo_doc w_pt015_cnta_prsp_tipo_doc

on w_pt015_cnta_prsp_tipo_doc.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_pt015_cnta_prsp_tipo_doc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_pt015_cnta_prsp_tipo_doc
event ue_display ( string as_columna,  long al_row )
string dataobject = "d_abc_cnta_prsp_tipo_doc_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cnta_prsp"
		ls_sql = "SELECT cnta_prsp AS CODIGO, " &
				  + "DESCripcion AS DESC_cnta_prsp " &
				  + "FROM presupuesto_cuenta " &
				  + "WHERE NVL(flag_estado, '0') = '1'"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_doc"
		ls_sql = "SELECT tipo_doc AS CODIGO, " &
				  + "DESC_tipo_doc AS DESCripcion " &
				  + "FROM doc_tipo " &
				  + "where NVL(FLAG_AFECTA_PRSP, '0') = '1'"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::doubleclicked;call super::doubleclicked;String ls_columna

If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string ls_desc, ls_null
SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cnta_prsp"
		
		select descripcion
			into :ls_desc
		from presupuesto_cuenta
		where cnta_prsp = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal no existe o no esta activo", StopSign!)
			this.object.cnta_prsp		[row] = ls_null
			this.object.desc_cnta_prsp	[row] = ls_null
			return 1
		end if

		this.object.desc_cnta_prsp	[row] = ls_desc

	case "tipo_doc"
		
		select desc_tipo_doc
			into :ls_desc
		from doc_tipo
		where tipo_doc = :data
		  and NVL(FLAG_AFECTA_PRSP, '0') = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal no existe o no esta activo", StopSign!)
			this.object.tipo_doc			[row] = ls_null
			this.object.desc_tipo_doc	[row] = ls_null
			return 1
		end if

		this.object.desc_tipo_doc	[row] = ls_desc
		
end choose

end event

