$PBExportHeader$w_al020_logparam.srw
forward
global type w_al020_logparam from w_abc_master
end type
end forward

global type w_al020_logparam from w_abc_master
integer width = 3227
integer height = 1864
string title = "Mantenimiento Logparam (AL020)"
string menuname = "m_only_grabar"
end type
global w_al020_logparam w_al020_logparam

on w_al020_logparam.create
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
end on

on w_al020_logparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

idw_1.Retrieve()
end event

type dw_master from w_abc_master`dw_master within w_al020_logparam
integer width = 3141
integer height = 1640
string dataobject = "d_logparam"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

