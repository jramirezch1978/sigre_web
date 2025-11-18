$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_launch from commandbutton within w_main
end type
type dw_applets from datawindow within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 1435
integer height = 1100
boolean titlebar = true
string title = "Control Panel Launcher"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_launch cb_launch
dw_applets dw_applets
cb_cancel cb_cancel
end type
global w_main w_main

type prototypes
Function ulong GetSystemDirectory ( &
	Ref string lpBuffer, &
	ulong uSize &
	) Library "kernel32.dll" Alias For "GetSystemDirectoryW"

Function long ShellExecute ( &
	long hwnd, &
	string lpVerb, &
	string lpFile, &
	string lpParameters, &
	string lpDirectory, &
	long nShowCmd &
	) Library "shell32.dll" Alias For "ShellExecuteW"

end prototypes

on w_main.create
this.cb_launch=create cb_launch
this.dw_applets=create dw_applets
this.cb_cancel=create cb_cancel
this.Control[]={this.cb_launch,&
this.dw_applets,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.cb_launch)
destroy(this.dw_applets)
destroy(this.cb_cancel)
end on

event open;dw_applets.Event RowFocusChanged(1)

end event

type cb_launch from commandbutton within w_main
integer x = 1024
integer y = 32
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Launch"
end type

event clicked;Long ll_hwnd, ll_size
String ls_code, ls_verb, ls_parms
String ls_dirname, ls_system

ll_hwnd = Handle(this)

ls_code = dw_applets.GetItemString(dw_applets.GetRow(), "code")

If Right(ls_code, 4) = ".cpl" Then
	// .cpl Control Panel Extension
	ShellExecute(ll_hwnd, ls_verb, &
				"rundll32.exe", &
				"shell32.dll,Control_RunDLL " + &
				ls_code + ",", ls_dirname, 1)
Else
	// .msc Microsoft Common Console Document
	ll_size = 260
	ls_system = Space(ll_size)
	GetSystemDirectory(ls_system, ll_size)
	ShellExecute(ll_hwnd, "Open", &
				ls_system + "\" + ls_code, &
				ls_parms, ls_dirname, 1)
End If

dw_applets.SetFocus()

end event

type dw_applets from datawindow within w_main
integer x = 37
integer y = 32
integer width = 955
integer height = 908
integer taborder = 10
string title = "none"
string dataobject = "d_applets"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.SelectRow(0, False)
this.SelectRow(currentrow, True)

end event

type cb_cancel from commandbutton within w_main
integer x = 1024
integer y = 840
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

