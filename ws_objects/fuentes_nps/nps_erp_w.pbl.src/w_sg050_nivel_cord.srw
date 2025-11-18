$PBExportHeader$w_sg050_nivel_cord.srw
forward
global type w_sg050_nivel_cord from w_abc_master_smpl
end type
end forward

global type w_sg050_nivel_cord from w_abc_master_smpl
integer width = 2501
integer height = 1520
string title = "Mantenimiento de Nivel Coord  (SG050)  "
string menuname = "m_mtto_smpl"
end type
global w_sg050_nivel_cord w_sg050_nivel_cord

on w_sg050_nivel_cord.create
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sg050_nivel_cord.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;//f_centrar( this)
end event

type dw_master from w_abc_master_smpl`dw_master within w_sg050_nivel_cord
integer width = 2432
integer height = 768
string dataobject = "d_nivel_cord_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

