$PBExportHeader$w_abc_numeracion_ope_origen.srw
forward
global type w_abc_numeracion_ope_origen from w_abc_master
end type
end forward

global type w_abc_numeracion_ope_origen from w_abc_master
integer width = 1207
integer height = 572
string title = "Numeradores"
string menuname = "m_abc_master_limitado"
end type
global w_abc_numeracion_ope_origen w_abc_numeracion_ope_origen

on w_abc_numeracion_ope_origen.create
call super::create
if this.MenuName = "m_abc_master_limitado" then this.MenuID = create m_abc_master_limitado
end on

on w_abc_numeracion_ope_origen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

f_centrar(this)

dw_master.dataobject = message.stringparm
dw_master.SetTransObject( sqlca)
ll_row = dw_master.retrieve(gs_origen)
if ll_row = 0 then
	dw_master.event ue_insert()
end if
end event

type dw_master from w_abc_master`dw_master within w_abc_numeracion_ope_origen
integer x = 0
integer y = 0
integer width = 1134
integer height = 352
string dataobject = "d_campo"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen [al_row] = gs_origen
end event

