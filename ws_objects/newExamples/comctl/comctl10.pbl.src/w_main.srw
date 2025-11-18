$PBExportHeader$w_main.srw
$PBExportComments$Main window
forward
global type w_main from window
end type
type tab_main from u_tab_main within w_main
end type
type tab_main from u_tab_main within w_main
end type
type uo_statusbar from u_comctl_statusbar within w_main
end type
end forward

global type w_main from window
integer x = 69
integer y = 72
integer width = 2194
integer height = 1524
boolean titlebar = true
string title = "Microsoft Common Controls"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79416533
string icon = "AppIcon!"
event menuselect pbm_menuselect
tab_main tab_main
uo_statusbar uo_statusbar
end type
global w_main w_main

type prototypes

end prototypes

type variables

end variables

event menuselect;// display MicroHelp
uo_statusbar.of_MicroHelp(hMenu, ItemID, 1)

end event

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.tab_main=create tab_main
this.uo_statusbar=create uo_statusbar
this.Control[]={this.tab_main,&
this.uo_statusbar}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_main)
destroy(this.uo_statusbar)
end on

event resize;// notify statusbar to resize itself
uo_statusbar.Resize(-1, -1)

tab_main.Width  = this.Width - 100
tab_main.Height = this.Height - 360

uo_statusbar.of_SetText(2, "w: " + String(this.Width))
uo_statusbar.of_SetText(3, "h: " + String(this.Height))

end event

event open;Long ll_aWidths[3]

// set starting point of Statusbar parts (pixels)
ll_aWidths[1] = 300
ll_aWidths[2] = 400
ll_aWidths[3] = -1	// -1 = remainder

// pass the array of widths to Statusbar
uo_statusbar.of_SetParts(ll_aWidths)

// set text values
uo_statusbar.of_SetText(1, "One")
uo_statusbar.of_SetText(2, "Two")
uo_statusbar.of_SetText(3, "Three")

end event

type tab_main from u_tab_main within w_main
integer x = 37
integer y = 32
end type

type uo_statusbar from u_comctl_statusbar within w_main
integer y = 1376
boolean bringtotop = true
end type

