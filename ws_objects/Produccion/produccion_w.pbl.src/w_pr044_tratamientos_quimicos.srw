$PBExportHeader$w_pr044_tratamientos_quimicos.srw
forward
global type w_pr044_tratamientos_quimicos from w_abc_master_smpl
end type
end forward

global type w_pr044_tratamientos_quimicos from w_abc_master_smpl
integer width = 3086
integer height = 1628
string title = "[PR044] Tratamientos Quimicos PPTT"
string menuname = "m_mantto_smpl"
end type
global w_pr044_tratamientos_quimicos w_pr044_tratamientos_quimicos

on w_pr044_tratamientos_quimicos.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr044_tratamientos_quimicos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

event ue_update;call super::ue_update;if dw_master.ii_update = 0 then
	this.event ue_dw_share( )
end if
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr044_tratamientos_quimicos
integer width = 2930
integer height = 1256
string dataobject = "d_abc_tratamientos_quimicos_tbl"
end type

