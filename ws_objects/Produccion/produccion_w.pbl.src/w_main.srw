$PBExportHeader$w_main.srw
$PBExportComments$Ancestro Main
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
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

if gs_remoto = '0' and trim(gs_WallPaper) <> "" then
	This.SetRedraw(false)
	OpenSheet(w_fondo, w_main, 9, Layered!)
	//f_centerwindow( w_fondo )
	//w_fondo.y = w_fondo.y - 200
	this.SetRedraw(true)
end if
end event

