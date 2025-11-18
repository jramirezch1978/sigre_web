$PBExportHeader$w_pr042_procesos.srw
forward
global type w_pr042_procesos from w_abc_master_smpl
end type
end forward

global type w_pr042_procesos from w_abc_master_smpl
integer height = 1064
string title = "[PR042] Procesos de Produccion"
string menuname = "m_mantto_smpl"
end type
global w_pr042_procesos w_pr042_procesos

on w_pr042_procesos.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr042_procesos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr042_procesos
integer x = 0
integer y = 0
string dataobject = "d_abc_procesos"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

