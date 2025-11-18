$PBExportHeader$w_sr001_empresas.srw
forward
global type w_sr001_empresas from w_abc_master_smpl
end type
end forward

global type w_sr001_empresas from w_abc_master_smpl
integer height = 1064
string title = "[SR001] Maestro de Empresas"
string menuname = "m_mtto_smpl"
end type
global w_sr001_empresas w_sr001_empresas

on w_sr001_empresas.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr001_empresas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type ole_skin from w_abc_master_smpl`ole_skin within w_sr001_empresas
end type

type st_1 from w_abc_master_smpl`st_1 within w_sr001_empresas
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr001_empresas
end type

type st_box from w_abc_master_smpl`st_box within w_sr001_empresas
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr001_empresas
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr001_empresas
string dataobject = "d_abc_empresas_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_Estado[al_row] = '1'
end event

