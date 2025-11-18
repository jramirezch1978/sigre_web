$PBExportHeader$w_op031_parametro_operac.srw
forward
global type w_op031_parametro_operac from w_abc_master
end type
end forward

global type w_op031_parametro_operac from w_abc_master
integer width = 1431
integer height = 820
string title = "[OP031] Parametros de módulo de operaciones OT"
string menuname = "m_master_sin_lista"
end type
global w_op031_parametro_operac w_op031_parametro_operac

on w_op031_parametro_operac.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_op031_parametro_operac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()



end event

type dw_master from w_abc_master`dw_master within w_op031_parametro_operac
integer width = 562
string dataobject = "d_abc_parametros_ff"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = dw_master				// dw_master

end event

