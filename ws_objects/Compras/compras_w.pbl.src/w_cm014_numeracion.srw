$PBExportHeader$w_cm014_numeracion.srw
forward
global type w_cm014_numeracion from w_abc_master
end type
end forward

global type w_cm014_numeracion from w_abc_master
integer width = 2199
integer height = 1328
string title = "Numeradores (CM014)"
string menuname = "m_logparam"
end type
global w_cm014_numeracion w_cm014_numeracion

on w_cm014_numeracion.create
call super::create
if this.MenuName = "m_logparam" then this.MenuID = create m_logparam
end on

on w_cm014_numeracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

f_centrar(this)

dw_master.dataobject = message.stringparm
dw_master.SetTransObject( sqlca)
ll_row = dw_master.retrieve()
if ll_row = 0 then
	dw_master.event ue_insert()
end if
end event

type dw_master from w_abc_master`dw_master within w_cm014_numeracion
integer width = 1952
integer height = 868
string dataobject = "d_campo"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen[al_row] = trim(gs_user)
end event

