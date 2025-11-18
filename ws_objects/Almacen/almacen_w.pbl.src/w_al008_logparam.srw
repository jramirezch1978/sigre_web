$PBExportHeader$w_al008_logparam.srw
forward
global type w_al008_logparam from w_abc_master_smpl
end type
end forward

global type w_al008_logparam from w_abc_master_smpl
integer width = 1957
integer height = 1560
string title = "Parametros de almacenes"
string menuname = "m_only_grabar"
end type
global w_al008_logparam w_al008_logparam

on w_al008_logparam.create
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
end on

on w_al008_logparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_al008_logparam
integer x = 0
integer y = 0
integer width = 1883
integer height = 1352
string dataobject = "d_abc_logparam"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.reckey[al_row] = '1'
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'
//ii_ck[1] = 1
end event

