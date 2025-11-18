$PBExportHeader$w_pr046_lugar_empaque.srw
forward
global type w_pr046_lugar_empaque from w_abc_master_smpl
end type
end forward

global type w_pr046_lugar_empaque from w_abc_master_smpl
integer width = 3383
integer height = 2172
string title = "[PR046] Lugares de empaque"
string menuname = "m_mantto_smpl"
end type
global w_pr046_lugar_empaque w_pr046_lugar_empaque

on w_pr046_lugar_empaque.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr046_lugar_empaque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr046_lugar_empaque
integer width = 3269
integer height = 1860
string dataobject = "d_abc_lugar_empaque_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

