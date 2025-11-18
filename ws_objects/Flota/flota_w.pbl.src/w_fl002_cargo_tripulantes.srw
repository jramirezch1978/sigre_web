$PBExportHeader$w_fl002_cargo_tripulantes.srw
forward
global type w_fl002_cargo_tripulantes from w_abc_master_smpl
end type
end forward

global type w_fl002_cargo_tripulantes from w_abc_master_smpl
integer width = 3246
integer height = 1928
string title = "Cargo de tripulantes (FL002)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl002_cargo_tripulantes w_fl002_cargo_tripulantes

on w_fl002_cargo_tripulantes.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl002_cargo_tripulantes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl002_cargo_tripulantes
integer width = 3017
integer height = 1600
string dataobject = "d_cargo_trip_grid"
end type

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

