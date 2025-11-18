$PBExportHeader$w_pr012_tipo_formato.srw
forward
global type w_pr012_tipo_formato from w_abc_master_smpl
end type
end forward

global type w_pr012_tipo_formato from w_abc_master_smpl
integer width = 1856
integer height = 1008
string title = "Tipos de Formato de medición(PR012)"
string menuname = "m_mantto_smpl"
end type
global w_pr012_tipo_formato w_pr012_tipo_formato

on w_pr012_tipo_formato.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr012_tipo_formato.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion( )


end event

type dw_master from w_abc_master_smpl`dw_master within w_pr012_tipo_formato
integer x = 23
integer y = 0
integer width = 1751
integer height = 788
string dataobject = "d_abc_tipo_formato_tbl"
end type

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

