$PBExportHeader$w_cam005_etapas_fenologicas.srw
forward
global type w_cam005_etapas_fenologicas from w_abc_master_smpl
end type
end forward

global type w_cam005_etapas_fenologicas from w_abc_master_smpl
integer height = 1064
string title = "[CAM005] Etapas Fenológicas"
string menuname = "m_abc_master_smpl"
end type
global w_cam005_etapas_fenologicas w_cam005_etapas_fenologicas

on w_cam005_etapas_fenologicas.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam005_etapas_fenologicas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam005_etapas_fenologicas
integer x = 0
integer y = 0
string dataobject = "d_abc_etapa_fenologica_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

