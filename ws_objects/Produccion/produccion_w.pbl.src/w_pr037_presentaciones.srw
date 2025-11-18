$PBExportHeader$w_pr037_presentaciones.srw
forward
global type w_pr037_presentaciones from w_abc_master_smpl
end type
end forward

global type w_pr037_presentaciones from w_abc_master_smpl
integer height = 1064
string title = "[PR037] Presentaciones del producto"
string menuname = "m_mantto_smpl"
end type
global w_pr037_presentaciones w_pr037_presentaciones

on w_pr037_presentaciones.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr037_presentaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr037_presentaciones
integer x = 0
integer y = 0
string dataobject = "d_abc_presentacion_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

