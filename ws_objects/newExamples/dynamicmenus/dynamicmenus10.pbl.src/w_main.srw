$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
integer width = 2455
integer height = 1584
boolean titlebar = true
string title = "Dynamic Menu"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
mdi_1 mdi_1
end type
global w_main w_main

type variables

end variables

forward prototypes
public subroutine wf_dynamicmenus (integer ai_index)
end prototypes

public subroutine wf_dynamicmenus (integer ai_index);// Dynamic Menu Item Clicked

m_main lm_menu
String ls_text

lm_menu = this.MenuID

ls_text = lm_menu.in_dyn.of_GetItemString(ai_index, "text")

choose case ls_text
	case "File3"
		If lm_menu.in_dyn.of_GetItemBool(ai_index, "checked") Then
			lm_menu.in_dyn.of_SetItem(ai_index, "checked", False)
		Else
			lm_menu.in_dyn.of_SetItem(ai_index, "checked", True)
		End If
	case else
		MessageBox("Clicked", ls_text)
end choose

end subroutine

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;m_main lm_menu
Menu lm_item
Integer li_item

// get reference to the menu
lm_menu = this.MenuID

// get reference to the menu item
lm_item = lm_menu.m_file.m_recentfiles

// set the parent window
lm_menu.in_dyn.of_SetParent(this)

// add the items
li_item = lm_menu.in_dyn.of_AddItem(lm_item, "File1")
li_item = lm_menu.in_dyn.of_AddItem(lm_item, "File2")
li_item = lm_menu.in_dyn.of_AddSeparator(lm_item)
li_item = lm_menu.in_dyn.of_AddItem(lm_item, "File3")

// turn on the checked property
lm_menu.in_dyn.of_SetItem(li_item, "checked", True)

end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

