$PBExportHeader$w_fi037_bancos_ov.srw
forward
global type w_fi037_bancos_ov from w_abc_master_smpl
end type
end forward

global type w_fi037_bancos_ov from w_abc_master_smpl
integer width = 2574
integer height = 1636
string title = "[FI037] Bancos para Ordenes de Venta"
string menuname = "m_mantenimiento_sl"
end type
global w_fi037_bancos_ov w_fi037_bancos_ov

on w_fi037_bancos_ov.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi037_bancos_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion ()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi037_bancos_ov
integer x = 5
integer y = 4
integer width = 2519
integer height = 1336
string dataobject = "d_abc_bancos_ov_tbl"
boolean hscrollbar = false
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row (this)
end event

