$PBExportHeader$w_al012_motivo_traslado.srw
forward
global type w_al012_motivo_traslado from w_abc_master_smpl
end type
end forward

global type w_al012_motivo_traslado from w_abc_master_smpl
integer width = 3067
integer height = 1732
string title = "Motivo Traslado  (AL012)"
string menuname = "m_mantenimiento_sl"
end type
global w_al012_motivo_traslado w_al012_motivo_traslado

on w_al012_motivo_traslado.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_al012_motivo_traslado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_al012_motivo_traslado
integer width = 2967
integer height = 1492
string dataobject = "d_motivo_traslado_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
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
		
	case "cod_sunat"

		ls_sql = "select t.codigo as codigo, " &
				 + "       t.descripcion as descripcion " &
				 + "from SUNAT_CATALOGO20 t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sunat			[al_row] = ls_codigo
			this.object.desc_catalogo20	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

