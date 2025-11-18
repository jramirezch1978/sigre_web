$PBExportHeader$w_sr008_usuarios.srw
forward
global type w_sr008_usuarios from w_abc_master_smpl
end type
end forward

global type w_sr008_usuarios from w_abc_master_smpl
integer width = 2971
integer height = 1784
string title = "(SR008) Maestro de usuarios "
string menuname = "m_mtto_smpl"
end type
global w_sr008_usuarios w_sr008_usuarios

on w_sr008_usuarios.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr008_usuarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type ole_skin from w_abc_master_smpl`ole_skin within w_sr008_usuarios
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr008_usuarios
end type

type st_box from w_abc_master_smpl`st_box within w_sr008_usuarios
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr008_usuarios
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr008_usuarios
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr008_usuarios
integer width = 2322
integer height = 1152
string dataobject = "d_abc_usuarios_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

