$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_4 from statictext within w_main
end type
type st_remote from statictext within w_main
end type
type cb_choose from commandbutton within w_main
end type
type lb_strings from listbox within w_main
end type
type st_strings from statictext within w_main
end type
type st_3 from statictext within w_main
end type
type st_2 from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type st_edition from statictext within w_main
end type
type cb_cancel from commandbutton within w_main
end type
type st_csdvers from statictext within w_main
end type
type st_version from statictext within w_main
end type
end forward

global type w_main from window
integer width = 2281
integer height = 1620
boolean titlebar = true
string title = "OS Version Information"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
st_remote st_remote
cb_choose cb_choose
lb_strings lb_strings
st_strings st_strings
st_3 st_3
st_2 st_2
st_1 st_1
st_edition st_edition
cb_cancel cb_cancel
st_csdvers st_csdvers
st_version st_version
end type
global w_main w_main

type variables
n_osversion in_osver

end variables

forward prototypes
public subroutine wf_display ()
end prototypes

public subroutine wf_display ();// display values

lb_strings.Reset()

If in_osver.FixedProductVersion <> "" Then
	lb_strings.AddItem("FixedProductVersion: " + &
					in_osver.FixedProductVersion)
End If

If in_osver.FixedFileVersion <> "" Then
	lb_strings.AddItem("FixedFileVersion: " + &
					in_osver.FixedFileVersion)
End If

If in_osver.Comments <> "" Then
	lb_strings.AddItem("Comments: " + in_osver.Comments)
End If

If in_osver.CompanyName <> "" Then
	lb_strings.AddItem("CompanyName: " + in_osver.CompanyName)
End If

If in_osver.FileDescription <> "" Then
	lb_strings.AddItem("FileDescription: " + in_osver.FileDescription)
End If

If in_osver.FileVersion <> "" Then
	lb_strings.AddItem("FileVersion: " + in_osver.FileVersion)
End If

If in_osver.InternalName <> "" Then
	lb_strings.AddItem("InternalName: " + in_osver.InternalName)
End If

If in_osver.LegalCopyright <> "" Then
	lb_strings.AddItem("LegalCopyright: " + in_osver.LegalCopyright)
End If

If in_osver.LegalTrademarks <> "" Then
	lb_strings.AddItem("LegalTrademarks: " + in_osver.LegalTrademarks)
End If

If in_osver.OriginalFilename <> "" Then
	lb_strings.AddItem("OriginalFilename: " + in_osver.OriginalFilename)
End If

If in_osver.ProductName <> "" Then
	lb_strings.AddItem("ProductName: " + in_osver.ProductName)
End If

If in_osver.ProductVersion <> "" Then
	lb_strings.AddItem("ProductVersion: " + in_osver.ProductVersion)
End If

If in_osver.PrivateBuild <> "" Then
	lb_strings.AddItem("PrivateBuild: " + in_osver.PrivateBuild)
End If

If in_osver.SpecialBuild <> "" Then
	lb_strings.AddItem("SpecialBuild: " + in_osver.SpecialBuild)
End If

end subroutine

on w_main.create
this.st_4=create st_4
this.st_remote=create st_remote
this.cb_choose=create cb_choose
this.lb_strings=create lb_strings
this.st_strings=create st_strings
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.st_edition=create st_edition
this.cb_cancel=create cb_cancel
this.st_csdvers=create st_csdvers
this.st_version=create st_version
this.Control[]={this.st_4,&
this.st_remote,&
this.cb_choose,&
this.lb_strings,&
this.st_strings,&
this.st_3,&
this.st_2,&
this.st_1,&
this.st_edition,&
this.cb_cancel,&
this.st_csdvers,&
this.st_version}
end on

on w_main.destroy
destroy(this.st_4)
destroy(this.st_remote)
destroy(this.cb_choose)
destroy(this.lb_strings)
destroy(this.st_strings)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_edition)
destroy(this.cb_cancel)
destroy(this.st_csdvers)
destroy(this.st_version)
end on

event open;String ls_version, ls_edition, ls_csd, ls_pbvmname

in_osver.of_GetOSVersion(ls_version, ls_edition, ls_csd)

ls_pbvmname = in_osver.of_PBVMName()
st_strings.text = ls_pbvmname + " version strings:"

st_version.text = ls_version
st_edition.text = ls_edition
st_csdvers.text = ls_csd

If in_osver.of_GetFileVersionInfo(ls_pbvmname) Then
	wf_Display()
End If

If in_osver.of_RemoteSession() Then
	st_remote.text = "True"
Else
	st_remote.text = "False"
End If

end event

type st_4 from statictext within w_main
integer x = 37
integer y = 320
integer width = 370
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Remote:"
boolean focusrectangle = false
end type

type st_remote from statictext within w_main
integer x = 439
integer y = 320
integer width = 1760
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_choose from commandbutton within w_main
integer x = 37
integer y = 1376
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Choose File"
end type

event clicked;Integer li_rtn
String ls_pathname, ls_filename, ls_filter

ls_filter = "Executables (*.exe), *.exe," + &
				"Libraries (*.dll), *.dll"

li_rtn = GetFileOpenName("Select File", ls_pathname, &
								ls_filename, "exe", ls_filter)

If li_rtn = 1 Then
	st_strings.text = ls_filename + " version strings:"
	If in_osver.of_GetFileVersionInfo(ls_pathname) Then
		wf_Display()
	End If
End If

end event

type lb_strings from listbox within w_main
integer x = 37
integer y = 532
integer width = 2162
integer height = 784
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

type st_strings from statictext within w_main
integer x = 37
integer y = 448
integer width = 2162
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Version Strings for "
boolean focusrectangle = false
end type

type st_3 from statictext within w_main
integer x = 37
integer y = 224
integer width = 370
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "CSD:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_main
integer x = 37
integer y = 128
integer width = 370
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Edition:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer x = 37
integer y = 32
integer width = 370
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "OS:"
boolean focusrectangle = false
end type

type st_edition from statictext within w_main
integer x = 439
integer y = 128
integer width = 1760
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_main
integer x = 1865
integer y = 1376
integer width = 334
integer height = 100
integer taborder = 20
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

type st_csdvers from statictext within w_main
integer x = 439
integer y = 224
integer width = 1760
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_version from statictext within w_main
integer x = 439
integer y = 32
integer width = 1760
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

