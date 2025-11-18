$PBExportHeader$w_cam003_sectores_campo.srw
forward
global type w_cam003_sectores_campo from w_abc_master_smpl
end type
end forward

global type w_cam003_sectores_campo from w_abc_master_smpl
integer height = 1064
string title = "[CAM003] Sectores de Campo"
string menuname = "m_abc_master_smpl"
end type
global w_cam003_sectores_campo w_cam003_sectores_campo

on w_cam003_sectores_campo.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam003_sectores_campo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam003_sectores_campo
integer x = 0
integer y = 0
string dataobject = "d_abc_sector_campo_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

