$PBExportHeader$w_pr038_tareas.srw
forward
global type w_pr038_tareas from w_abc_master_smpl
end type
end forward

global type w_pr038_tareas from w_abc_master_smpl
integer height = 1064
string title = "[PR038] Tareas de Produccion"
string menuname = "m_mantto_smpl"
end type
global w_pr038_tareas w_pr038_tareas

on w_pr038_tareas.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr038_tareas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr038_tareas
integer x = 0
integer y = 0
string dataobject = "d_abc_tareas_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

