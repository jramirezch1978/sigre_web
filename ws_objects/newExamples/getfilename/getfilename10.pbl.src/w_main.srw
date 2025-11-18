$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cbx_showhelp from checkbox within w_main
end type
type cbx_defaults from checkbox within w_main
end type
type cb_savefile from commandbutton within w_main
end type
type cb_opensingle from commandbutton within w_main
end type
type lb_files from listbox within w_main
end type
type cb_openmulti from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 2574
integer height = 1108
boolean titlebar = true
string title = "GetOpenFileName and GetSaveFileName"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_showhelp cbx_showhelp
cbx_defaults cbx_defaults
cb_savefile cb_savefile
cb_opensingle cb_opensingle
lb_files lb_files
cb_openmulti cb_openmulti
cb_cancel cb_cancel
end type
global w_main w_main

type variables
ULong iul_HelpMessage
String is_HelpFile, is_HelpTopic

end variables

on w_main.create
this.cbx_showhelp=create cbx_showhelp
this.cbx_defaults=create cbx_defaults
this.cb_savefile=create cb_savefile
this.cb_opensingle=create cb_opensingle
this.lb_files=create lb_files
this.cb_openmulti=create cb_openmulti
this.cb_cancel=create cb_cancel
this.Control[]={this.cbx_showhelp,&
this.cbx_defaults,&
this.cb_savefile,&
this.cb_opensingle,&
this.lb_files,&
this.cb_openmulti,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.cbx_showhelp)
destroy(this.cbx_defaults)
destroy(this.cb_savefile)
destroy(this.cb_opensingle)
destroy(this.lb_files)
destroy(this.cb_openmulti)
destroy(this.cb_cancel)
end on

event other;// display the help topic
If Message.Number = iul_HelpMessage And iul_HelpMessage > 0 Then
	If ShowHelp(is_HelpFile, Keyword!, is_HelpTopic)  <> 1 Then
		MessageBox("Help Error", "Help file '" + is_HelpFile + "' was not found.")
	End If
End If

end event

type cbx_showhelp from checkbox within w_main
integer x = 1682
integer y = 48
integer width = 370
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show Help"
boolean checked = true
end type

type cbx_defaults from checkbox within w_main
integer x = 1243
integer y = 48
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Use Defaults"
boolean checked = true
end type

type cb_savefile from commandbutton within w_main
integer x = 841
integer y = 32
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save File"
end type

event clicked;n_getfilename ln_ofn
Integer li_rc
String ls_title, ls_extension, ls_filter, ls_initdir
String ls_pathname, ls_filename

ls_title		= "Save File"
ls_filter	= "Source Files (*.sr*), *.sr*, Resource Files (*.pbr), *.pbr, Text Files (*.txt), *.txt"
ls_filename = "default.txt"
ls_initdir	= ln_ofn.of_GetFolderPath(ln_ofn.CSIDL_MYDOCUMENTS)

// activate the Help button (see window Other event)
If cbx_showhelp.Checked Then
	iul_HelpMessage = ln_ofn.of_SetHelp(Parent)
	is_HelpFile		 = "SampleHelp.chm"
	is_HelpTopic	 = "Second topic"
Else
	ln_ofn.of_SetHelpOff()
End If

lb_files.Reset()

If cbx_defaults.Checked Then
	li_rc = ln_ofn.of_GetSaveFileName(ls_title, ls_pathname, ls_filename)
Else
	li_rc = ln_ofn.of_GetSaveFileName(ls_title, ls_pathname, ls_filename, &
								ls_extension, ls_filter, ls_initdir)
End If

If li_rc = 1 Then
	lb_files.AddItem(ls_pathname)
End If

end event

type cb_opensingle from commandbutton within w_main
integer x = 439
integer y = 32
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open Single"
end type

event clicked;n_getfilename ln_ofn
Integer li_rc
String ls_title, ls_extension, ls_filter, ls_initdir
String ls_pathname, ls_filename

ls_title		= "Open File"
ls_filter	= "Source Files (*.sr*), *.sr*, Resource Files (*.pbr), *.pbr, Text Files (*.txt), *.txt"
ls_initdir	= ln_ofn.of_GetFolderPath(ln_ofn.CSIDL_MYDOCUMENTS)
ls_filename = "default.txt"

// activate the Help button (see window Other event)
If cbx_showhelp.Checked Then
	iul_HelpMessage = ln_ofn.of_SetHelp(Parent)
	is_HelpFile		 = "SampleHelp.chm"
	is_HelpTopic	 = "Second topic"
Else
	ln_ofn.of_SetHelpOff()
End If

lb_files.Reset()

If cbx_defaults.Checked Then
	li_rc = ln_ofn.of_GetOpenFileName(ls_title, ls_pathname, ls_filename)
Else
	li_rc = ln_ofn.of_GetOpenFileName(ls_title, ls_pathname, ls_filename, &
								ls_extension, ls_filter, ls_initdir)
End If

If li_rc = 1 Then
	lb_files.AddItem(ls_pathname)
End If

end event

type lb_files from listbox within w_main
integer x = 37
integer y = 192
integer width = 2455
integer height = 772
integer taborder = 50
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

type cb_openmulti from commandbutton within w_main
integer x = 37
integer y = 32
integer width = 334
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Open Multi"
end type

event clicked;n_getfilename ln_ofn
Integer li_rc, li_idx, li_max
String ls_title, ls_extension, ls_filter, ls_initdir
String ls_pathname[], ls_filename[]

ls_title		= "Open Files"
ls_filter	= "Source Files (*.sr*), *.sr*, Resource Files (*.pbr), *.pbr, Text Files (*.txt), *.txt"
ls_initdir	= ln_ofn.of_GetFolderPath(ln_ofn.CSIDL_MYDOCUMENTS)
ls_filename[1] = "default.txt"

// activate the Help button (see window Other event)
If cbx_showhelp.Checked Then
	iul_HelpMessage = ln_ofn.of_SetHelp(Parent)
	is_HelpFile		 = "SampleHelp.chm"
	is_HelpTopic	 = "Second topic"
Else
	ln_ofn.of_SetHelpOff()
End If

lb_files.Reset()

If cbx_defaults.Checked Then
	li_rc = ln_ofn.of_GetOpenFileName(ls_title, ls_pathname, ls_filename)
Else
	li_rc = ln_ofn.of_GetOpenFileName(ls_title, ls_pathname, ls_filename, &
								ls_extension, ls_filter, ls_initdir)
End If

If li_rc = 1 Then
	li_max = UpperBound(ls_pathname)
	For li_idx = 1 To li_max
		lb_files.AddItem(ls_pathname[li_idx])
	Next
End If

end event

type cb_cancel from commandbutton within w_main
integer x = 2158
integer y = 32
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

