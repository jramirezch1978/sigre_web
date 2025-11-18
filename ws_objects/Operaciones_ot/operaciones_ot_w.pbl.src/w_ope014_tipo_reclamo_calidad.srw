$PBExportHeader$w_ope014_tipo_reclamo_calidad.srw
forward
global type w_ope014_tipo_reclamo_calidad from w_abc_master_smpl
end type
end forward

global type w_ope014_tipo_reclamo_calidad from w_abc_master_smpl
integer width = 1239
integer height = 1232
string title = "Tipo de Reclamo de Calidad (ope014)"
string menuname = "m_master_sin_lista"
end type
global w_ope014_tipo_reclamo_calidad w_ope014_tipo_reclamo_calidad

on w_ope014_tipo_reclamo_calidad.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope014_tipo_reclamo_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(100,100) 
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope014_tipo_reclamo_calidad
integer width = 1166
integer height = 1016
string dataobject = "d_abc_cal_tipo_reclamo_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

