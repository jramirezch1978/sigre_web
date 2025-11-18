$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
integer width = 2898
integer height = 2116
string title = ""
string menuname = "m_master"
long backcolor = 15780518
string pointer = "h:\Source\CUR\P-ARGYLE.ANI"
boolean center = true
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

event resize;call super::resize;//p_1.X = (newwidth - p_1.width)/2
//p_1.Y = (newheight - p_1.height)/2 - 50
end event

event open;call super::open;if gs_remoto = '0' then
	This.SetRedraw(false)
	OpenSheet(w_fondo, w_main, 9, Layered!)
	//f_centerwindow( w_fondo )
	//w_fondo.y = w_fondo.y - 200
	this.SetRedraw(true)
end if


end event

