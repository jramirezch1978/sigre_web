$PBExportHeader$w_abc_numeracion_ve_origen.srw
forward
global type w_abc_numeracion_ve_origen from w_abc_master
end type
end forward

global type w_abc_numeracion_ve_origen from w_abc_master
integer width = 1184
integer height = 548
string title = "Numeradores"
string menuname = "m_mantenimiento"
end type
global w_abc_numeracion_ve_origen w_abc_numeracion_ve_origen

on w_abc_numeracion_ve_origen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

this.MenuId.item[1].item[1].item[2].enabled 					= False
this.MenuId.item[1].item[1].item[2].ToolbarItemvisible	= False
this.MenuId.item[1].item[1].item[13].enabled 				= False
this.MenuId.item[1].item[1].item[13].ToolbarItemvisible	= False
this.MenuId.item[1].item[1].item[14].enabled 				= False
this.MenuId.item[1].item[1].item[14].ToolbarItemvisible	= False


f_centrar(this)

dw_master.dataobject = message.stringparm
dw_master.SetTransObject( sqlca)
ll_row = dw_master.retrieve(gs_origen)
if ll_row = 0 then
	dw_master.event ue_insert()
end if
dw_master.ii_protect = 0
dw_master.of_protect()
end event

on w_abc_numeracion_ve_origen.create
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
end on

type dw_master from w_abc_master`dw_master within w_abc_numeracion_ve_origen
integer width = 1134
integer height = 352
string dataobject = "d_campo"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen [al_row] = gs_origen
end event

