$PBExportHeader$w_cam004_tipos_riego.srw
forward
global type w_cam004_tipos_riego from w_abc_master_smpl
end type
end forward

global type w_cam004_tipos_riego from w_abc_master_smpl
integer height = 1064
string title = "[CAM004] Tipos de Riego"
string menuname = "m_abc_master_smpl"
end type
global w_cam004_tipos_riego w_cam004_tipos_riego

on w_cam004_tipos_riego.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam004_tipos_riego.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam004_tipos_riego
integer x = 0
integer y = 0
string dataobject = "d_abc_tipo_riego_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

