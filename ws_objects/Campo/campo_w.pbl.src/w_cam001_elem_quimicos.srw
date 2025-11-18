$PBExportHeader$w_cam001_elem_quimicos.srw
forward
global type w_cam001_elem_quimicos from w_abc_master_smpl
end type
end forward

global type w_cam001_elem_quimicos from w_abc_master_smpl
integer height = 1064
string title = "[CAM001] Elementos Químicos"
string menuname = "m_abc_master_smpl"
end type
global w_cam001_elem_quimicos w_cam001_elem_quimicos

on w_cam001_elem_quimicos.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam001_elem_quimicos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam001_elem_quimicos
string dataobject = "d_abc_elemento_quimico_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

