$PBExportHeader$w_sg530_oper_procesos.srw
forward
global type w_sg530_oper_procesos from w_cns_smpl
end type
end forward

global type w_sg530_oper_procesos from w_cns_smpl
integer width = 1179
integer height = 1008
string title = "Procesos Realizados (SG530)"
string menuname = "m_cns_simple"
end type
global w_sg530_oper_procesos w_sg530_oper_procesos

on w_sg530_oper_procesos.create
call super::create
if this.MenuName = "m_cns_simple" then this.MenuID = create m_cns_simple
end on

on w_sg530_oper_procesos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()
end event

type dw_cns from w_cns_smpl`dw_cns within w_sg530_oper_procesos
integer x = 0
integer y = 0
string dataobject = "d_oper_procesos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_cns::constructor;call super::constructor;ii_ck[1] = 1
end event

