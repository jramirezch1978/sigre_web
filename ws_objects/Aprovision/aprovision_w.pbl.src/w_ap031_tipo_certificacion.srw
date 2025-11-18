$PBExportHeader$w_ap031_tipo_certificacion.srw
forward
global type w_ap031_tipo_certificacion from w_abc_mastdet_smpl
end type
end forward

global type w_ap031_tipo_certificacion from w_abc_mastdet_smpl
integer width = 2336
integer height = 2208
string title = "[Ap031] Tipo de Certificacion"
string menuname = "m_mantto_smpl"
end type
global w_ap031_tipo_certificacion w_ap031_tipo_certificacion

on w_ap031_tipo_certificacion.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap031_tipo_certificacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap031_tipo_certificacion
integer x = 0
integer y = 0
integer width = 2240
integer height = 908
string dataobject = "d_abc_tipo_Certificacion_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_Row] = '1'
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap031_tipo_certificacion
integer x = 0
integer y = 924
integer width = 2222
integer height = 892
string dataobject = "d_abc_tipo_certificacion_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 4				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "tipo_caja"

		ls_sql = "SELECT t.tipo_caja AS tipo_caja, " &
				  + "t.desc_tipo_caja AS descripcion_tipo_caja " &
				  + "FROM ap_tipo_caja t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_caja		[al_row] = ls_codigo
			this.object.desc_tipo_caja	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_funda"

		ls_sql = "SELECT t.tipo_funda AS tipo_funda, " &
				  + "t.desc_tipo_funda AS descripcion_tipo_funda " &
				  + "FROM ap_tipo_funda t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_funda		[al_row] = ls_codigo
			this.object.desc_tipo_funda[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_art_pptt"

		ls_sql = "SELECT t.cod_art AS codigo_Articulo, " &
				  + "t.desc_art AS descripcion_articulo " &
				  + "FROM articulo t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art_pptt[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.ii_update = 1
		end if
end choose



end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)
end event

