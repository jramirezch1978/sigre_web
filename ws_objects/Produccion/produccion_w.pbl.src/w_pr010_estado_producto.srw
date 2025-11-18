$PBExportHeader$w_pr010_estado_producto.srw
forward
global type w_pr010_estado_producto from w_abc_master_smpl
end type
end forward

global type w_pr010_estado_producto from w_abc_master_smpl
integer width = 1742
integer height = 1028
string title = "Estados del Producto(PR010)"
string menuname = "m_mantto_smpl"
end type
global w_pr010_estado_producto w_pr010_estado_producto

on w_pr010_estado_producto.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr010_estado_producto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr010_estado_producto
integer width = 1641
integer height = 812
string dataobject = "d_abc_estado_producto_tbl"
end type

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

