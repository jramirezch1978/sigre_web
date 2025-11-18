$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
string title = "Módulo de Recursos Humanos"
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

event open;call super::open;mdi_1.backcolor = rgb(128,128,128)

open(w_valida_origen)
if Message.DoubleParm = 0 then close(this)
end event

