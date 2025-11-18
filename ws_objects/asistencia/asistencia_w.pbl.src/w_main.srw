$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
integer width = 3689
integer height = 2504
string title = "Sistema de Asistencia"
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

event open;call super::open;mdi_1.backcolor = RGB(128,128,128)
//if gs_remoto = '0' then
	This.SetRedraw(false)
	OpenSheet(w_fondo, this, 9,Layered!)
	//f_centerwindow( w_fondo )
	//w_fondo.y = w_fondo.y - 200
//end if 	


this.SetRedraw(true)


end event

