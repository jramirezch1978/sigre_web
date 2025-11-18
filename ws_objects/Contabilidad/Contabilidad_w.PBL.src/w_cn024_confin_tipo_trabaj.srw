$PBExportHeader$w_cn024_confin_tipo_trabaj.srw
forward
global type w_cn024_confin_tipo_trabaj from w_abc_master_smpl
end type
end forward

global type w_cn024_confin_tipo_trabaj from w_abc_master_smpl
integer width = 2693
integer height = 1404
string title = "[CN024] CONFIN X TIPO DE TRABAJADOR"
string menuname = "m_abc_master_smpl"
end type
global w_cn024_confin_tipo_trabaj w_cn024_confin_tipo_trabaj

on w_cn024_confin_tipo_trabaj.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn024_confin_tipo_trabaj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cn024_confin_tipo_trabaj
integer x = 0
integer y = 0
integer width = 2624
integer height = 1172
string dataobject = "d_abc_confin_tipo_trabaj_tbl"
end type

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
	case "tipo_trabajador"
		ls_sql = "select tipo_trabajador as tipo_trabajador, " &
				 + "       tt.desc_tipo_tra as descripcion_tipo_trabajador " &
				 + "from tipo_trabajador tt " &
				 + "where tt.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_trabajador		[al_row] = ls_codigo
			this.object.desc_tipo_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "confin"
		ls_sql = "select cf.confin as codigo_confin, " &
				 + "       cf.descripcion as descripcion_confin " &
				 + "from concepto_financiero cf " &
				 + "where cf.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.confin		[al_row] = ls_codigo
			this.object.desc_confin	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc
Long ll_count

this.Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'tipo_trabajador'
		
		// Verifica que codigo ingresado exista			
		Select desc_tipo_tra
	     into :ls_desc
		  from tipo_trabajador
		 Where tipo_trabajador = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if sqlca.sqlcode= 100 then
			Messagebox( "Error", "Tipo de Trabajador no existe o no está activo")
			this.object.tipo_trabajador			[row] = ls_null
			this.object.desc_tipo_trabajador		[row] = ls_null
			return 1
		end if
		
		this.object.desc_tipo_trabajador		[row] = ls_desc

CASE 'confin' 
	
		Select descripcion
	     into :ls_desc
		  from concepto_financiero
		 Where confin = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if sqlca.sqlcode= 100 then
			Messagebox( "Error", "Concepto Financiero no existe o no está activo")
			this.object.confin			[row] = ls_null
			this.object.desc_confin		[row] = ls_null
			return 1
		end if
		
		this.object.desc_confin		[row] = ls_desc
		
END CHOOSE

//boolean lb_ret
//string ls_codigo, ls_data, ls_sql
//
//choose case lower(as_columna)
//	case ""
//		select tt. 
//			into :ls_data
//		from  tt " &
//				 + "where tt.flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//
//		if ls_codigo <> '' then
//			this.object.tipo_trabajador		[al_row] = ls_codigo
//			this.object.desc_tipo_trabajador	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//	case ""
//		ls_sql = "select cf.confin as codigo_confin, " &
//				 + "       cf.descripcion as descripcion_confin " &
//				 + "from concepto_financiero cf " &
//				 + "where cf.flag_estado = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.confin		[al_row] = ls_codigo
//			this.object.desc_confin	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.setcolumn("flag_concepto_lbs")
end event

