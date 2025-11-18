$PBExportHeader$w_main.srw
$PBExportComments$Sample window
forward
global type w_main from window
end type
type st_status from statictext within w_main
end type
type st_msg from statictext within w_main
end type
type cb_tray from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer x = 142
integer y = 144
integer width = 1513
integer height = 788
boolean titlebar = true
string title = "Icontray Sample"
boolean controlmenu = true
long backcolor = 79416533
string icon = "AppIcon!"
event trayevent pbm_custom01
event m_modifyicon ( )
event m_automodify ( )
event m_modifytip ( )
event m_restore ( )
event m_exit ( )
event m_balloontip ( )
st_status st_status
st_msg st_msg
cb_tray cb_tray
cb_cancel cb_cancel
end type
global w_main w_main

type variables
n_icontray in_tray
Integer ii_index
Boolean ib_timer
String is_menufunction

end variables

forward prototypes
public subroutine wf_popupmenu ()
public subroutine wf_setfunction (string as_function)
end prototypes

event trayevent;// process tray events
Choose Case lparam
	Case in_tray.WM_LBUTTONDBLCLK
		st_status.text = "Double clicked on the icon"
		in_tray.of_delete_icon(this, True)
	Case in_tray.WM_RBUTTONDOWN
		wf_popupmenu()
	Case in_tray.NIN_BALLOONTIMEOUT
		st_status.text = "Balloon timeout or clicked X"
		in_tray.of_delete_icon(this, True)
	Case in_tray.NIN_BALLOONUSERCLICK
		st_status.text = "User clicked the balloon"
		in_tray.of_delete_icon(this, True)
End Choose

end event

event m_modifyicon();// change icon in the tray
If in_tray.of_modify_icon(this, "shell32.dll", ii_index) Then
	ii_index = ii_index + 1
Else
	// first call failed so go back to icon #0
	in_tray.of_modify_icon(this, "shell32.dll", 0)
	ii_index = 1
End If

end event

event m_automodify();// toggle timer event on/off
If ib_timer Then
	Timer(0)
Else
	Timer(1)
End If

end event

event m_modifytip;// modify tip message
in_tray.of_modify_tip(this, "New Message")

end event

event m_restore;// remove icon from system tray
in_tray.of_delete_icon(this, True)

end event

event m_exit;// remove icon from system tray
in_tray.of_delete_icon(this, True)

// close window
Close(this)

end event

event m_balloontip();// create balloon tip
in_tray.of_balloon_tip(this, "PB Icontray", &
		"Isn't this just the coolest?", Information!)

end event

public subroutine wf_popupmenu ();// display and process the popup menu

m_icontray lm_icontray
Long ll_xpos, ll_ypos
Boolean lb_result

// get mouse position
in_tray.of_GetPointerPos(ll_xpos, ll_ypos)

// display popup menu
in_tray.of_SetFocus(this)
lm_icontray = CREATE m_icontray
lm_icontray.m_popup.PopMenu(ll_xpos, ll_ypos)
DESTROY lm_icontray

// give focus to the system tray
lb_result = in_tray.of_TrayFocus()

// process the menu choice
this.TriggerEvent(is_menufunction)

end subroutine

public subroutine wf_setfunction (string as_function);// set the menu function name
is_menufunction = as_function

end subroutine

on w_main.create
this.st_status=create st_status
this.st_msg=create st_msg
this.cb_tray=create cb_tray
this.cb_cancel=create cb_cancel
this.Control[]={this.st_status,&
this.st_msg,&
this.cb_tray,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.st_status)
destroy(this.st_msg)
destroy(this.cb_tray)
destroy(this.cb_cancel)
end on

event open;// add window icon to tray
in_tray.of_add_icon(this)

// register hotkey
If Not in_tray.of_RegisterHotKey(this, 1, in_tray.MOD_WIN, in_tray.KeyF8) Then
	MessageBox(this.title, "RegisterHotKey failed, hotkey already in use!")
End If

end event

event timer;// modify icon
this.Event Post m_modifyicon()

end event

event close;// unregister hotkey
in_tray.of_UnRegisterHotKey(this, 1)

end event

event other;// detect HotKey event
If in_tray.of_isHotKey(wparam, lparam) Then
	// remove icon from system tray
	in_tray.of_delete_icon(this, True)
End If

end event

type st_status from statictext within w_main
integer x = 37
integer y = 576
integer width = 1065
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_msg from statictext within w_main
integer x = 37
integer y = 224
integer width = 1431
integer height = 324
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "I recommend downloading IconEdit32 and IconJack32 from www.pcmag.com.  IconEdit32 can be used to edit/create your own icons.  IconJack32 can be used to extract icons from a .dll or .exe file.  It also can be used to create a icon .dll file."
boolean focusrectangle = false
end type

type cb_tray from commandbutton within w_main
integer x = 37
integer y = 32
integer width = 517
integer height = 132
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Back to Tray"
end type

event clicked;// modify icon
in_tray.of_add_icon(Parent, "hamburg.ico")

end event

type cb_cancel from commandbutton within w_main
integer x = 1134
integer y = 576
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

