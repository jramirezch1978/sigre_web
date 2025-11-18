$PBExportHeader$w_test.srw
forward
global type w_test from w_abc_3panels
end type
end forward

global type w_test from w_abc_3panels
integer height = 2044
string menuname = "m_mtto_smpl"
end type
global w_test w_test

on w_test.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_test.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type ole_skin from w_abc_3panels`ole_skin within w_test
end type

type st_box from w_abc_3panels`st_box within w_test
end type

type uo_h from w_abc_3panels`uo_h within w_test
end type

type dw_master from w_abc_3panels`dw_master within w_test
end type

type dw_detail from w_abc_3panels`dw_detail within w_test
end type

type st_1 from w_abc_3panels`st_1 within w_test
end type

type uo_filter from w_abc_3panels`uo_filter within w_test
end type

type dw_detdet from w_abc_3panels`dw_detdet within w_test
end type

type st_horizontal from w_abc_3panels`st_horizontal within w_test
end type

type st_both from w_abc_3panels`st_both within w_test
end type

type st_vertical from w_abc_3panels`st_vertical within w_test
end type

