$PBExportHeader$w_rh062_tipo_renuncia_lbs.srw
forward
global type w_rh062_tipo_renuncia_lbs from w_abc_master_smpl
end type
end forward

global type w_rh062_tipo_renuncia_lbs from w_abc_master_smpl
integer width = 2853
integer height = 1604
string title = "[RH062] Tipo Renuncia LBS"
string menuname = "m_master_simple"
end type
global w_rh062_tipo_renuncia_lbs w_rh062_tipo_renuncia_lbs

on w_rh062_tipo_renuncia_lbs.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh062_tipo_renuncia_lbs.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_rh062_tipo_renuncia_lbs
integer width = 2601
integer height = 1228
string dataobject = "d_abc_tipo_renuncia_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

