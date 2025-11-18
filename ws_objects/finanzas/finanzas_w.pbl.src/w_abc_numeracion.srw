$PBExportHeader$w_abc_numeracion.srw
forward
global type w_abc_numeracion from w_abc_master
end type
end forward

global type w_abc_numeracion from w_abc_master
integer width = 1006
integer height = 556
string title = "Numeradores"
string menuname = "m_logparam_num"
end type
global w_abc_numeracion w_abc_numeracion

on w_abc_numeracion.create
call super::create
if this.MenuName = "m_logparam_num" then this.MenuID = create m_logparam_num
end on

on w_abc_numeracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

dw_master.dataobject = message.stringparm
dw_master.SetTransObject( sqlca)
ll_row = dw_master.retrieve()
if ll_row = 0 then
	dw_master.event ue_insert()
end if
end event

type dw_master from w_abc_master`dw_master within w_abc_numeracion
integer width = 937
integer height = 332
string dataobject = "d_campo"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

