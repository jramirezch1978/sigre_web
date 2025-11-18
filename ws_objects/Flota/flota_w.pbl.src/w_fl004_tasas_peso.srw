$PBExportHeader$w_fl004_tasas_peso.srw
forward
global type w_fl004_tasas_peso from w_abc_master_smpl
end type
end forward

global type w_fl004_tasas_peso from w_abc_master_smpl
integer width = 2016
integer height = 1100
string title = "Tasas Aplicables al Peso (FL004)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl004_tasas_peso w_fl004_tasas_peso

on w_fl004_tasas_peso.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl004_tasas_peso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl004_tasas_peso
integer x = 0
integer y = 0
integer width = 1938
integer height = 824
string dataobject = "d_tasas_peso_grid"
end type

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

