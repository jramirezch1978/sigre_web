$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
type cb_1 from commandbutton within w_main
end type
type lb_1 from listbox within w_main
end type
type cb_microhelp from commandbutton within w_main
end type
type cb_update from commandbutton within w_main
end type
type sle_message from singlelineedit within w_main
end type
type str_point from structure within w_main
end type
type str_minmaxinfo from structure within w_main
end type
end forward

type str_point from structure
	long		lx
	long		ly
end type

type str_minmaxinfo from structure
	str_point		ptreserved
	str_point		ptmaxsize
	str_point		ptmaxposition
	str_point		ptmintracksize
	str_point		ptmaxtracksize
end type

global type w_main from window
integer x = 55
integer y = 76
integer width = 2597
integer height = 1492
boolean titlebar = true
string title = "Sample Status Bar Program"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 281067712
event ue_getminmaxinfo pbm_getminmaxinfo
mdi_1 mdi_1
cb_1 cb_1
lb_1 lb_1
cb_microhelp cb_microhelp
cb_update cb_update
sle_message sle_message
end type
global w_main w_main

type prototypes
Subroutine GetMinMaxInfo ( &
	Ref str_minmaxinfo d, &
	long s, &
	long l &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine SetMinMaxInfo ( &
	long d, &
	str_minmaxinfo s, &
	long l &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Function integer GetClassName ( &
	ulong hWind, &
	Ref string name, &
	int cbmax &
	) Library "user32.dll" Alias For "GetClassNameW"

Function ulong GetWindow ( &
	ulong hWind, &
	uint fuRel &
	) Library "user32.dll"

Function integer GetWindowText ( &
	ulong hWind, &
	Ref string text, &
	int cbmax &
	) Library "user32.dll" Alias For "GetWindowTextW"

end prototypes

type variables

end variables

event ue_getminmaxinfo;str_minmaxinfo lstr_minmaxinfo
Environment le_env

GetEnvironment(le_env)

// copy the data to local structure
GetMinMaxInfo(lstr_minmaxinfo, minmaxinfo, 40)

// set the minimum size for our window
lstr_minmaxinfo.ptMinTrackSize.lx = 400
lstr_minmaxinfo.ptMinTrackSize.ly = 300

// set the maximum size for our window
lstr_minmaxinfo.ptMaxTrackSize.lx = le_env.ScreenWidth * .9
lstr_minmaxinfo.ptMaxTrackSize.ly = le_env.ScreenHeight * .9

// copy the structure back into memory
SetMinMaxInfo(minmaxinfo, lstr_minmaxinfo, 40)

// important: must return 0
Return 0

end event

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.cb_1=create cb_1
this.lb_1=create lb_1
this.cb_microhelp=create cb_microhelp
this.cb_update=create cb_update
this.sle_message=create sle_message
this.Control[]={this.mdi_1,&
this.cb_1,&
this.lb_1,&
this.cb_microhelp,&
this.cb_update,&
this.sle_message}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.cb_1)
destroy(this.lb_1)
destroy(this.cb_microhelp)
destroy(this.cb_update)
destroy(this.sle_message)
end on

event open;// open status bar
Open(w_statusbar)

end event

event resize;// notify status bar of resize
If IsValid(w_statusbar) Then
	w_statusbar.wf_reposition()
End If

// notify tool bar of resize
If IsValid(w_toolbar) Then
	w_toolbar.wf_reposition()
End If

sle_message.SetFocus()

end event

event close;// close status bar
If IsValid(w_statusbar) Then
	Close(w_statusbar)
End If

// close tool bar window
If IsValid(w_toolbar) Then
	Close(w_toolbar)
End If

end event

event toolbarmoved;Boolean lb_visible
String ls_title
ToolbarAlignment lta_align

// set global frame pointer
gw_frame = this

// open toolbar window
gw_frame.GetToolbar(1, lb_visible, lta_align, ls_title)
CHOOSE CASE lta_align
	CASE AlignAtTop!, AlignAtBottom!
		// open tool bar window
		Open(w_toolbar)
	CASE AlignAtLeft!, AlignAtRight!
		// open tool bar window
		Open(w_toolbar)
END CHOOSE

end event

type mdi_1 from mdiclient within w_main
long BackColor=281067712
end type

type cb_1 from commandbutton within w_main
integer x = 1353
integer y = 224
integer width = 443
integer height = 100
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Display Controls"
end type

event clicked;String ls_name, ls_text
ULong lul_hwnd
Integer li_rc

lb_1.Reset()

// find the microhelp handle
lul_hwnd = GetWindow(Handle(gw_frame), 5)
DO UNTIL lul_hwnd = 0
	ls_name = Space(25)
	ls_text = Space(100)
	li_rc = GetClassName(lul_hwnd, ls_name, Len(ls_name))
	li_rc = GetWindowText(lul_hwnd, ls_text, Len(ls_text))
	If Len(ls_text) > 0 Then
		lb_1.AddItem(ls_name + " <" + ls_text + ">")
	Else
		lb_1.AddItem(ls_name)
	End If
	lul_hwnd = GetWindow(lul_hwnd, 2)
LOOP

end event

type lb_1 from listbox within w_main
integer x = 1353
integer y = 352
integer width = 809
integer height = 772
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type cb_microhelp from commandbutton within w_main
integer x = 37
integer y = 352
integer width = 553
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Update Microhelp"
end type

event clicked;// update microhelp
Parent.SetMicroHelp(sle_message.text)

end event

type cb_update from commandbutton within w_main
integer x = 658
integer y = 352
integer width = 553
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Update Status Text"
end type

event clicked;// update status bar message
If IsValid(w_statusbar) Then
	w_statusbar.wf_set_message(sle_message.text)
End If

end event

type sle_message from singlelineedit within w_main
integer x = 37
integer y = 224
integer width = 1175
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

