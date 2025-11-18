$PBExportHeader$w_sg002_marcas.srw
forward
global type w_sg002_marcas from w_abc_master_smpl
end type
end forward

global type w_sg002_marcas from w_abc_master_smpl
integer height = 1748
string title = "[SG002] Maestro de Marcas"
string menuname = "m_mtto_smpl"
end type
global w_sg002_marcas w_sg002_marcas

on w_sg002_marcas.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sg002_marcas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_pie from w_abc_master_smpl`p_pie within w_sg002_marcas
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_sg002_marcas
end type

type uo_h from w_abc_master_smpl`uo_h within w_sg002_marcas
end type

type st_box from w_abc_master_smpl`st_box within w_sg002_marcas
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_sg002_marcas
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_sg002_marcas
end type

type p_logo from w_abc_master_smpl`p_logo within w_sg002_marcas
end type

type st_filter from w_abc_master_smpl`st_filter within w_sg002_marcas
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sg002_marcas
end type

type dw_master from w_abc_master_smpl`dw_master within w_sg002_marcas
string dataobject = "d_abc_marca_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

