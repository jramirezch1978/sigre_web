$PBExportHeader$w_1.srw
forward
global type w_1 from window
end type
type mdi_1 from mdiclient within w_1
end type
end forward

global type w_1 from window
integer width = 3168
integer height = 1952
boolean titlebar = true
string title = "Untitled"
string menuname = "m_menu"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
mdi_1 mdi_1
end type
global w_1 w_1

on w_1.create
if this.MenuName = "m_menu" then this.MenuID = create m_menu
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_1.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;f_habilita_opc(m_menu)
end event

type mdi_1 from mdiclient within w_1
long BackColor=268435456
end type

