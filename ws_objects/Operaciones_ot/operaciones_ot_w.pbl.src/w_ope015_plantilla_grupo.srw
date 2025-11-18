$PBExportHeader$w_ope015_plantilla_grupo.srw
forward
global type w_ope015_plantilla_grupo from w_abc_master_smpl
end type
end forward

global type w_ope015_plantilla_grupo from w_abc_master_smpl
integer width = 1467
integer height = 1656
string title = "Grupo de plantillas (ope015)"
string menuname = "m_master_sin_lista"
end type
global w_ope015_plantilla_grupo w_ope015_plantilla_grupo

on w_ope015_plantilla_grupo.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope015_plantilla_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(100,100) 
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope015_plantilla_grupo
integer width = 1376
integer height = 1416
string dataobject = "d_abc_plantilla_grupo_tbl"
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

