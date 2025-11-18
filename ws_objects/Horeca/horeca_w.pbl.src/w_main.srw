$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
string title = ""
string menuname = "m_master"
end type
global w_main w_main

on w_main.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_master" then this.MenuID = create m_master
end on

on w_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

