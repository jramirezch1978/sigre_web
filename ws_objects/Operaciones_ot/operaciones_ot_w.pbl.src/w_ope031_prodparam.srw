$PBExportHeader$w_ope031_prodparam.srw
forward
global type w_ope031_prodparam from w_abc_master
end type
end forward

global type w_ope031_prodparam from w_abc_master
integer width = 2638
integer height = 1204
string title = "[OP031] Parametros de módulo de operaciones OT"
string menuname = "m_master_sin_lista"
end type
global w_ope031_prodparam w_ope031_prodparam

on w_ope031_prodparam.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope031_prodparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()
end event

type dw_master from w_abc_master`dw_master within w_ope031_prodparam
integer width = 2354
integer height = 860
string dataobject = "d_prod_param_ff"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
idw_mst  = dw_master

end event

