$PBExportHeader$w_pr003_grupo_atributo.srw
forward
global type w_pr003_grupo_atributo from w_abc_master_smpl
end type
end forward

global type w_pr003_grupo_atributo from w_abc_master_smpl
integer width = 2386
integer height = 1088
string title = "Grupos de Atributos de Medición(PR003) "
string menuname = "m_mantto_smpl"
boolean center = true
end type
global w_pr003_grupo_atributo w_pr003_grupo_atributo

on w_pr003_grupo_atributo.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr003_grupo_atributo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

event ue_update;call super::ue_update;if dw_master.ii_update = 0 then
	this.event ue_dw_share( )
end if
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr003_grupo_atributo
integer width = 2331
integer height = 880
string dataobject = "d_tg_med_act_atributo_grp_tbl"
end type

