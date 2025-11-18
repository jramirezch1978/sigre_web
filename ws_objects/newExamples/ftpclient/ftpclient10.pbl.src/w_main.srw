$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
type uo_local from u_panel_local within w_main
end type
type uo_remote from u_panel_remote within w_main
end type
type lb_msgbox from listbox within w_main
end type
type st_vertical from u_splitbar_vertical within w_main
end type
type st_horizontal from u_splitbar_horizontal within w_main
end type
type point from structure within w_main
end type
type minmaxinfo from structure within w_main
end type
end forward

type point from structure
	long		lx
	long		ly
end type

type minmaxinfo from structure
	point		ptreserved
	point		ptmaxsize
	point		ptmaxposition
	point		ptmintracksize
	point		ptmaxtracksize
end type

global type w_main from window
boolean visible = false
integer x = 101
integer y = 100
integer width = 3442
integer height = 2116
boolean titlebar = true
string title = "FTPClient"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
string icon = "AppIcon!"
event getminmaxinfo pbm_getminmaxinfo
event ue_postopen ( )
event ue_percent_download pbm_custom01
event ue_percent_upload pbm_custom02
mdi_1 mdi_1
uo_local uo_local
uo_remote uo_remote
lb_msgbox lb_msgbox
st_vertical st_vertical
st_horizontal st_horizontal
end type
global w_main w_main

type prototypes
Subroutine GetMinMaxInfo ( &
	Ref MINMAXINFO d, &
	long s, &
	long l &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine SetMinMaxInfo ( &
	long d, &
	MINMAXINFO s, &
	long l &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

end prototypes

type variables
Constant String WindowMemory = "Window\w_main"
Boolean ib_StopAction

end variables

forward prototypes
public subroutine wf_statesave ()
public subroutine wf_staterestore ()
public subroutine wf_dynamicmenus (integer ai_index)
public subroutine wf_serverprofiles ()
public subroutine wf_addmsg (string as_msg)
public subroutine wf_connect ()
public subroutine wf_disconnect ()
public subroutine wf_stopaction ()
end prototypes

event getminmaxinfo;MINMAXINFO lstr_minmaxinfo

// copy the data to local structure
GetMinMaxInfo(lstr_minmaxinfo, minmaxinfo, 40)

// set the minimum size for our window
lstr_minmaxinfo.ptMinTrackSize.lx = UnitsToPixels(2500, XUnitsToPixels!)
lstr_minmaxinfo.ptMinTrackSize.ly = UnitsToPixels(1650, YUnitsToPixels!)

// set the maximum size for our window
lstr_minmaxinfo.ptMaxTrackSize.lx = 5000
lstr_minmaxinfo.ptMaxTrackSize.ly = 5000

// copy the structure back into memory
SetMinMaxInfo(MINMAXINFO, lstr_minmaxinfo, 40)

// important: must return 0
Return 0

end event

event ue_postopen();m_main lm_menu

// restore window state
wf_StateRestore()

// add profiles to menu
wf_ServerProfiles()

// disable ftp actions
lm_menu = this.MenuID
lm_menu.mf_Status(False)

// trigger this event on panels
uo_local.Event ue_postopen()
uo_remote.Event ue_postopen()

end event

event ue_percent_download;String ls_msg

ls_msg = "Download " + &
			String(wparam / lparam, "#0%") + " complete."

this.SetMicroHelp(ls_msg)

Yield()

end event

event ue_percent_upload;String ls_msg

ls_msg = "Upload " + &
			String(wparam / lparam, "#0%") + " complete."

this.SetMicroHelp(ls_msg)

Yield()

end event

public subroutine wf_statesave ();// save window state

Application la_app

// remember toolbartext
la_app = GetApplication()
If la_app.ToolbarText Then
	gn_app.of_SetReg(WindowMemory,"ToolbarText", "true")
Else
	gn_app.of_SetReg(WindowMemory,"ToolbarText", "false")
End If

// remember window state
If this.WindowState = Maximized! Then
	// window is maximized
	gn_app.of_SetReg(WindowMemory,"WindowState", "Maximized")
Else
	If this.WindowState = Normal! Then
		// window is normal
		gn_app.of_SetReg(WindowMemory,"WindowState", "Normal")
		// remember window size/position
		gn_app.of_SetReg(WindowMemory,"WindowXPos", String(this.X))
		gn_app.of_SetReg(WindowMemory,"WindowYPos", String(this.Y))
		gn_app.of_SetReg(WindowMemory,"WindowWidth", String(this.Width))
		gn_app.of_SetReg(WindowMemory,"WindowHeight", String(this.Height))
	End If
End If

// save location of splitbars into registry
If this.WindowState <> Minimized! Then
	st_horizontal.of_set_location()
	st_vertical.of_set_location()
End If

end subroutine

public subroutine wf_staterestore ();// restore window state

Application la_app
Integer li_newwidth, li_newheight
String ls_toolbar, ls_state

gw_frame = this

// set toolbartext
la_app = GetApplication()
ls_toolbar = gn_app.of_GetReg(WindowMemory,"ToolbarText","false")
If ls_toolbar = "true" Then
	la_app.ToolbarText = True
Else
	la_app.ToolbarText = False
End If

// set window state
ls_state = gn_app.of_GetReg(WindowMemory,"WindowState","Normal")
If Lower(ls_state) = "maximized" Then
	// maximize window
	gn_app.of_ShowWindow(gw_frame, Maximized!)
Else
	// restore window size/position
	li_newwidth  = Integer(gn_app.of_GetReg(WindowMemory,"WindowWidth", String(this.Width)))
	li_newheight = Integer(gn_app.of_GetReg(WindowMemory,"WindowHeight", String(this.Height)))
	this.Resize(li_newwidth, li_newheight)
	this.X = Integer(gn_app.of_GetReg(WindowMemory,"WindowXPos", String(this.X)))
	this.Y = Integer(gn_app.of_GetReg(WindowMemory,"WindowYPos", String(this.Y)))
End If

// restore location of splitbars from registry
st_horizontal.of_get_location()
st_vertical.of_get_location()

// make visible after repositioned
this.Visible = True

end subroutine

public subroutine wf_dynamicmenus (integer ai_index);// Handle Server Profiles

m_main lm_menu
Integer li_profile

lm_menu = this.MenuID

If ai_index = 0 Then
	// New Profile
	OpenWithParm(w_profiles, 0)
Else
	// Existing Profile
	li_profile = Integer(lm_menu.in_dyn.of_GetItemString(ai_index, "tag"))
	OpenWithParm(w_profiles, li_profile)
End If

choose case Message.StringParm
	case "cb_connect"
		// initialize the remote panel
		uo_remote.of_Populate_Listview()
	case "cb_delete"
		// rebuild dynamic menu items
		wf_ServerProfiles()
	case "cb_save"
		// rebuild dynamic menu items
		wf_ServerProfiles()
	case "cb_cancel"
		// do nothing
end choose

end subroutine

public subroutine wf_serverprofiles ();m_main lm_menu
Menu lm_item
Integer li_item, li_idx, li_max, li_toolbar
String ls_regkey, ls_subkey, ls_subkeys[], ls_profile, ls_microhelp

// reset the menu
this.ChangeMenu(lm_menu)

// get local reference to the menu
lm_menu = this.MenuID

// get reference to the menu item
lm_item = lm_menu.m_profiles

// set the parent window
lm_menu.in_dyn.of_SetParent(this)

li_toolbar = Integer(gn_app.of_GetReg("Profiles", "Toolbar", "0"))

// get profiles
ls_regkey = "HKEY_CURRENT_USER\Software\" + &
					gn_app.is_company + "\Ftpclient\Profiles"
RegistryKeys(ls_regkey, ls_subkeys)
li_max = UpperBound(ls_subkeys)
For li_idx = 1 To li_max
	ls_subkey = "Profiles\" + String(li_idx)
	ls_profile = gn_app.of_GetReg(ls_subkey, "", "")
	// add the items
	li_item = lm_menu.in_dyn.of_AddItem(lm_item, ls_profile)
	lm_menu.in_dyn.of_SetItem(li_item, "Tag", String(li_idx))
	ls_microhelp = "Edit " + ls_profile
	lm_menu.in_dyn.of_SetItem(li_item, "Microhelp", ls_microhelp)
Next

end subroutine

public subroutine wf_addmsg (string as_msg);lb_msgbox.InsertItem(as_msg,1)

Yield()

lb_msgbox.SetRedraw(True)

end subroutine

public subroutine wf_connect ();// connect to the remote server

Integer li_profile
String ls_profile, ls_subkey

li_profile = Integer(gn_app.of_GetReg("Profiles", "Toolbar", "0"))
If li_profile = 0 Then
	MessageBox("Connect to Profile", &
		"Your 'favorite' profile needs to be set by " + &
		"clicking the Toolbar button on the profile window.")
Else
	// connect to server
	uo_remote.of_Connect(li_profile)
	// initialize the remote panel
	uo_remote.of_Populate_Listview()
	// change the window title
	ls_subkey = "Profiles\" + String(li_profile)
	ls_profile = gn_app.of_GetReg(ls_subkey, "", "")
	this.Title = "FTPClient - " + ls_profile
End If

end subroutine

public subroutine wf_disconnect ();// disconnect from the remote server

uo_remote.of_Disconnect()

this.Title = "FTPClient"

end subroutine

public subroutine wf_stopaction ();// stop the current FTP action

gn_ftp.of_StopAction()

ib_StopAction = True

gw_frame.wf_addmsg("The current action was stopped!")

end subroutine

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.uo_local=create uo_local
this.uo_remote=create uo_remote
this.lb_msgbox=create lb_msgbox
this.st_vertical=create st_vertical
this.st_horizontal=create st_horizontal
this.Control[]={this.mdi_1,&
this.uo_local,&
this.uo_remote,&
this.lb_msgbox,&
this.st_vertical,&
this.st_horizontal}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.uo_local)
destroy(this.uo_remote)
destroy(this.lb_msgbox)
destroy(this.st_vertical)
destroy(this.st_horizontal)
end on

event close;// disconnect session
gn_ftp.of_SessionClose()

// trigger this event on panels
uo_local.Event ue_preclose()
uo_remote.Event ue_preclose()

// save window state
wf_StateSave()

end event

event open;// register objects with vertical splitbar
st_vertical.of_set_leftobject(uo_local)
st_vertical.of_set_rightobject(uo_remote)
st_vertical.of_set_minsize(500, 500)
st_vertical.of_set_livesizing(False)

// register objects with horizontal splitbar
st_horizontal.of_set_topobject(uo_local)
st_horizontal.of_set_topobject(st_vertical)
st_horizontal.of_set_topobject(uo_remote)
st_horizontal.of_set_bottomobject(lb_msgbox)
st_horizontal.of_set_minsize(500, 500)
st_horizontal.of_set_livesizing(False)

// trigger postopen event
this.Post Event ue_postopen()

end event

event resize;// resize objects on the window

Application la_app
Integer li_workspace, li_toolbar

// determine current Toolbar height
la_app = GetApplication()
If la_app.ToolbarText Then
	li_toolbar = 160
Else
	li_toolbar = 106
End If

// update Width of objects touching the right edge
uo_remote.Width      = this.WorkSpaceWidth() - (uo_remote.X + 10)
st_horizontal.Width = this.WorkSpaceWidth() - 20
lb_msgbox.Width     = this.WorkSpaceWidth() - 20

// update Y position of the bottom objects
li_workspace    = this.WorkSpaceHeight() - mdi_1.MicroHelpHeight + li_toolbar
lb_msgbox.Y     = li_workspace - lb_msgbox.Height
st_horizontal.Y = lb_msgbox.Y - st_horizontal.Height

// update Y position of the top objects
uo_local.Y = li_toolbar + 6
st_vertical.Y   = uo_local.Y
uo_remote.Y      = uo_local.Y

// update Height of the top objects
If la_app.ToolbarText Then
	uo_local.Height = st_horizontal.Y - (li_toolbar + 8)
Else
	uo_local.Height = st_horizontal.Y - (li_toolbar + 6)
End If
st_vertical.Height = uo_local.Height
uo_remote.Height   = uo_local.Height

end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

type uo_local from u_panel_local within w_main
integer x = 9
integer y = 112
integer width = 1166
integer height = 1436
integer taborder = 30
end type

on uo_local.destroy
call u_panel_local::destroy
end on

type uo_remote from u_panel_remote within w_main
integer x = 1193
integer y = 112
integer width = 2139
integer height = 1436
integer taborder = 30
end type

on uo_remote.destroy
call u_panel_remote::destroy
end on

type lb_msgbox from listbox within w_main
integer x = 9
integer y = 1568
integer width = 3323
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type st_vertical from u_splitbar_vertical within w_main
integer x = 1175
integer y = 112
integer height = 1436
end type

type st_horizontal from u_splitbar_horizontal within w_main
integer x = 9
integer y = 1548
integer width = 3323
end type

