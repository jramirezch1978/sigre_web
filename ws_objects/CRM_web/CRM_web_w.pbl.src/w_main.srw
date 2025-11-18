$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
integer width = 1545
integer height = 1740
end type
global w_main w_main

on w_main.create
call super::create
end on

on w_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

