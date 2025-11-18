$PBExportHeader$u_comctl_statusbar.sru
$PBExportComments$Statusbar Control
forward
global type u_comctl_statusbar from userobject
end type
type initcommoncontrolsex from structure within u_comctl_statusbar
end type
type menuiteminfo from structure within u_comctl_statusbar
end type
end forward

type initcommoncontrolsex from structure
	unsignedlong		dwsize
	unsignedlong		dwicc
end type

type menuiteminfo from structure
	unsignedlong		cbsize
	unsignedlong		fmask
	unsignedlong		ftype
	unsignedlong		fstate
	unsignedlong		wid
	unsignedlong		hsubmenu
	unsignedlong		hbmpchecked
	unsignedlong		hbmpunchecked
	unsignedlong		dwitemdata
	string		dwtypedata
	unsignedlong		cch
	unsignedlong		hbmpitem
end type

global type u_comctl_statusbar from userobject
integer width = 992
integer height = 72
userobjects objecttype = externalvisual!
string classname = "msctls_statusbar32"
string libraryname = "comctl32.dll"
long style = 1174405120
end type
global u_comctl_statusbar u_comctl_statusbar

type prototypes
Function boolean InitCommonControlsEx( &
	INITCOMMONCONTROLSEX lpInitCtrls &
	) Library "comctl32.dll" alias for "InitCommonControlsEx;Ansi"

Function boolean SendMessageLong(&
	ulong hWnd, &
	ulong Msg, &
	ulong wParam, &
	Ref long aWidths[] ) &
	Library "user32.dll" alias for "SendMessageA"

Function boolean SendMessageString(&
	ulong hWnd, &
	ulong Msg, &
	ulong wParam, &
	Ref string szText ) &
	Library "user32.dll" alias for "SendMessageA;Ansi"

Function boolean GetMenuItemInfo( &
	ulong hMenu, &
	ulong uItem, &
	boolean fByPosition, &
	Ref MENUITEMINFO lpmii ) &
	Library "user32.dll" Alias For "GetMenuItemInfoA;Ansi"

end prototypes

type variables
Public:

Private:

Window iw_parent
Menu im_menu
String is_text[]
String is_help[]

// Status Bar Messages
CONSTANT ulong WM_USER		= 1024
CONSTANT ulong SB_SETTEXT		= (WM_USER+1)
CONSTANT ulong SB_GETTEXT		= (WM_USER+2)
CONSTANT ulong SB_GETTEXTLENGTH	= (WM_USER+3)
CONSTANT ulong SB_SETPARTS		= (WM_USER+4)
CONSTANT ulong SB_GETPARTS		= (WM_USER+6)
CONSTANT ulong SB_GETBORDERS		= (WM_USER+7)
CONSTANT ulong SB_SETMINHEIGHT	= (WM_USER+8)
CONSTANT ulong SB_SIMPLE		= (WM_USER+9)
CONSTANT ulong SB_GETRECT		= (WM_USER+10)
CONSTANT ulong SB_ISSIMPLE		= (WM_USER+14)
CONSTANT ulong SB_SETICON		= (WM_USER+15)
CONSTANT ulong SB_SETTIPTEXT		= (WM_USER+16)
CONSTANT ulong SB_GETTIPTEXT		= (WM_USER+18)
CONSTANT ulong SB_GETICON		= (WM_USER+20)

CONSTANT ulong CCM_FIRST		= 8192
CONSTANT ulong CCM_SETBKCOLOR	= (CCM_FIRST+1)
CONSTANT ulong SB_SETBKCOLOR		= CCM_SETBKCOLOR

end variables

forward prototypes
public function boolean of_setparts (long al_widths[])
public function boolean of_settext (integer ai_part, string as_text)
public subroutine of_initialize ()
private subroutine of_submenu (menu am_menu)
public subroutine of_microhelp (unsignedlong hmenu, unsignedlong itemid, integer part)
end prototypes

public function boolean of_setparts (long al_widths[]);// Sets the number of parts in a status window and
// the coordinate of the right edge of each part.

Boolean lb_result
ULong lul_nparts

lul_nparts = UpperBound(al_widths[])

If lul_nparts > 0 Then
	lb_result = SendMessageLong(Handle(This), &
						SB_SETPARTS, lul_nparts, al_widths[])
End If

Return lb_result

end function

public function boolean of_settext (integer ai_part, string as_text);// Sets the text in the specified part of a status window.

Boolean lb_result

lb_result = SendMessageString(Handle(This), &
					SB_SETTEXT, ai_part - 1, as_text)

Return lb_result

end function

public subroutine of_initialize ();// called by constructor or after window menu has changed

String ls_empty[]

// initialize arrays
is_text = ls_empty
is_help = ls_empty

// populate arrays
of_submenu(im_menu)

end subroutine

private subroutine of_submenu (menu am_menu);Integer li_index, li_max

li_max = UpperBound(am_menu.Item)
FOR li_index = 1 TO li_max
	is_text[UpperBound(is_text) + 1] = am_menu.Item[li_index].Text
	is_help[UpperBound(is_help) + 1] = am_menu.Item[li_index].Microhelp
	of_submenu(am_menu.Item[li_index])
NEXT

end subroutine

public subroutine of_microhelp (unsignedlong hmenu, unsignedlong itemid, integer part);// Sets the menu microhelp text in the specified part
// of a status window.

Constant ulong MIIM_TYPE	= 16
Constant ulong MFT_STRING	= 0
MENUITEMINFO lstr_info
Integer li_item, li_max
Boolean lb_rc
String ls_text, ls_msg

lstr_info.cbSize = 48
lstr_info.fMask  = MIIM_TYPE
lstr_info.fType = MFT_STRING
lstr_info.dwTypeData = Space(256)
lstr_info.cch = Len(lstr_info.dwTypeData)

// get menu item text
If ItemId < 500 Then
	lb_rc = GetMenuItemInfo(hMenu, ItemId, True, lstr_info)
Else
	lb_rc = GetMenuItemInfo(hMenu, ItemId, False, lstr_info)
End If

If lb_rc Then
	ls_text = Trim(lstr_info.dwTypeData)
	li_max = UpperBound(is_text)
	FOR li_item = 1 TO li_max
		If ls_text = is_text[li_item] Then
			ls_msg = is_help[li_item]
			Exit
		End If
	NEXT
	of_SetText(part, ls_msg)
End If

end subroutine

event constructor;// initialize parent objects
iw_parent = this.GetParent()
im_menu = iw_parent.MenuID

// initialize array
of_initialize()

end event

on u_comctl_statusbar.create
end on

on u_comctl_statusbar.destroy
end on

