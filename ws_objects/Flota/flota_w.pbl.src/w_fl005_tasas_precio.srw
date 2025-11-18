$PBExportHeader$w_fl005_tasas_precio.srw
forward
global type w_fl005_tasas_precio from w_abc_master_smpl
end type
end forward

global type w_fl005_tasas_precio from w_abc_master_smpl
integer width = 2066
integer height = 1036
string title = "Tasas Aplicables al Precio (FL005)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl005_tasas_precio w_fl005_tasas_precio

on w_fl005_tasas_precio.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl005_tasas_precio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl005_tasas_precio
integer width = 1998
integer height = 824
string dataobject = "d_tasas_precio_grid"
end type

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

