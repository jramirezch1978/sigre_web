$PBExportHeader$w_pr006_tipo_asistencia.srw
forward
global type w_pr006_tipo_asistencia from w_abc_master_smpl
end type
end forward

global type w_pr006_tipo_asistencia from w_abc_master_smpl
integer width = 1723
integer height = 1620
string title = "Tipos de Asistencia (PR006)"
string menuname = "m_mantto_smpl"
end type
global w_pr006_tipo_asistencia w_pr006_tipo_asistencia

on w_pr006_tipo_asistencia.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr006_tipo_asistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update;call super::ue_update;this.event ue_dw_share( )
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr006_tipo_asistencia
integer width = 1646
integer height = 1396
string dataobject = "d_tipo_mov_asistencia_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

