$PBExportHeader$w_sr002_origenes.srw
forward
global type w_sr002_origenes from w_abc_master_smpl
end type
end forward

global type w_sr002_origenes from w_abc_master_smpl
integer width = 3342
integer height = 2012
string title = "[SR002] Maestro de Orígenes "
string menuname = "m_mtto_smpl"
end type
global w_sr002_origenes w_sr002_origenes

on w_sr002_origenes.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr002_origenes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_pie from w_abc_master_smpl`p_pie within w_sr002_origenes
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_sr002_origenes
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr002_origenes
end type

type st_box from w_abc_master_smpl`st_box within w_sr002_origenes
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_sr002_origenes
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_sr002_origenes
end type

type p_logo from w_abc_master_smpl`p_logo within w_sr002_origenes
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr002_origenes
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr002_origenes
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr002_origenes
string dataobject = "d_abc_origen_tbl"
end type

