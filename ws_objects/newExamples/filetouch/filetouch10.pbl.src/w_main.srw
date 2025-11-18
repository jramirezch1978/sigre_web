$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type dw_entry from datawindow within w_main
end type
type cb_touchselected from commandbutton within w_main
end type
type dw_files from datawindow within w_main
end type
type sle_directory from singlelineedit within w_main
end type
type cb_directory from commandbutton within w_main
end type
type cb_touchdirectory from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
type n_filetouch_ds from n_filetouch within w_main
end type
end forward

global type w_main from window
integer width = 3232
integer height = 1588
boolean titlebar = true
string title = "File Touch Utility"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_entry dw_entry
cb_touchselected cb_touchselected
dw_files dw_files
sle_directory sle_directory
cb_directory cb_directory
cb_touchdirectory cb_touchdirectory
cb_cancel cb_cancel
n_filetouch_ds n_filetouch_ds
end type
global w_main w_main

type variables
String is_style
Long il_start

end variables

forward prototypes
public subroutine wf_setstyle (string as_style)
public subroutine wf_select_single (long al_row)
public subroutine wf_select_extend (long al_row, boolean ab_ctrl, boolean ab_shift)
end prototypes

public subroutine wf_setstyle (string as_style);is_style = Lower(as_style)


end subroutine

public subroutine wf_select_single (long al_row);If al_row = 0 Then Return

// deselect all rows
dw_files.SelectRow(0, False)

// select this row
dw_files.SelectRow(al_row, True)
il_start = al_row

// make this the current row
If dw_files.GetRow() <> al_row Then
	dw_files.SetRow(al_row)
	dw_files.ScrollToRow(al_row)
End If

end subroutine

public subroutine wf_select_extend (long al_row, boolean ab_ctrl, boolean ab_shift);Long ll_row

If al_row = 0 Then Return

If ab_ctrl Then
	If dw_files.IsSelected(al_row) Then
		dw_files.SelectRow(al_row, False)
	Else
		dw_files.SelectRow(al_row, True)
	End If
Else
	If ab_shift Then
		If il_start = 0 Then
			dw_files.SelectRow(al_row, True)
		Else
			If il_start < al_row Then
				FOR ll_row = il_start TO al_row
					dw_files.SelectRow(ll_row, True)
				NEXT
			Else
				FOR ll_row = al_row TO il_start
					dw_files.SelectRow(ll_row, True)
				NEXT
			End If
		End If
	Else
		wf_select_single(al_row)
	End If 
End If

end subroutine

on w_main.create
this.dw_entry=create dw_entry
this.cb_touchselected=create cb_touchselected
this.dw_files=create dw_files
this.sle_directory=create sle_directory
this.cb_directory=create cb_directory
this.cb_touchdirectory=create cb_touchdirectory
this.cb_cancel=create cb_cancel
this.n_filetouch_ds=create n_filetouch_ds
this.Control[]={this.dw_entry,&
this.cb_touchselected,&
this.dw_files,&
this.sle_directory,&
this.cb_directory,&
this.cb_touchdirectory,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.dw_entry)
destroy(this.cb_touchselected)
destroy(this.dw_files)
destroy(this.sle_directory)
destroy(this.cb_directory)
destroy(this.cb_touchdirectory)
destroy(this.cb_cancel)
destroy(this.n_filetouch_ds)
end on

event open;DateTime ldt_current

n_filetouch_ds.ShareData(dw_files)

ldt_current = DateTime(Today(), Now())

dw_entry.InsertRow(0)
dw_entry.SetItem(1, "create_date", ldt_current)
dw_entry.SetItem(1, "access_date", ldt_current)
dw_entry.SetItem(1, "written_date", ldt_current)

end event

type dw_entry from datawindow within w_main
integer x = 37
integer y = 1248
integer width = 3150
integer height = 100
integer taborder = 40
string title = "none"
string dataobject = "d_dateentry"
boolean border = false
boolean livescroll = true
end type

type cb_touchselected from commandbutton within w_main
integer x = 549
integer y = 1376
integer width = 443
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Touch Selected"
end type

event clicked;Long ll_row, ll_max
String ls_filename
DateTime ldt_CreateTime, ldt_AccessTime, ldt_WriteTime

SetPointer(HourGlass!)

dw_entry.AcceptText()

ldt_CreateTime = dw_entry.GetItemDateTime(1, "create_date")
ldt_AccessTime = dw_entry.GetItemDateTime(1, "access_date")
ldt_WriteTime  = dw_entry.GetItemDateTime(1, "written_date")

ll_max = dw_files.RowCount()
For ll_row = 1 To ll_max
	If dw_files.IsSelected(ll_row) Then
		ls_filename = dw_files.GetItemString(ll_row, "filename")
		n_filetouch_ds.of_SetFileTime(ls_filename, ldt_CreateTime, ldt_AccessTime, ldt_WriteTime)
	End If
Next

SetRedraw(False)
n_filetouch_ds.of_Directory(sle_directory.text)
SetRedraw(True)

end event

type dw_files from datawindow within w_main
integer x = 37
integer y = 160
integer width = 3150
integer height = 1060
integer taborder = 20
string title = "none"
string dataobject = "d_filetouch"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Choose Case is_style
	Case "single"
		wf_Select_Single(row)
	Case "extend"
		wf_Select_Extend(row, KeyDown(KeyControl!), KeyDown(KeyShift!))
End Choose

Return 0

end event

event constructor;wf_setstyle("extend")

end event

event doubleclicked;If Len(is_style) > 0 And row > 0 Then
	this.SelectRow(0, False)
	this.SelectRow(row, True)
End If

Return 0

end event

event rowfocuschanged;CHOOSE CASE is_style
	CASE "single"
		this.SelectRow(0, False)
		this.SelectRow(currentrow, True)
	CASE "extend"
		If Not KeyDown(KeyControl!) Then
			If Not KeyDown(KeyShift!) Then
				this.SelectRow(0, False)
				this.SelectRow(currentrow, True)
			Else
				this.SelectRow(currentrow, True)
			End If
		End If
END CHOOSE
il_start = currentrow

Return 0

end event

type sle_directory from singlelineedit within w_main
integer x = 439
integer y = 40
integer width = 2747
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_directory from commandbutton within w_main
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
string text = "Directory"
end type

event clicked;String ls_path

If GetFolder("Select Directory", ls_path) = 1 Then
	sle_directory.text = ls_path
	SetPointer(HourGlass!)
	SetRedraw(False)
	n_filetouch_ds.of_Directory(ls_path)
	SetRedraw(True)
	cb_touchdirectory.enabled = true
	cb_touchselected.enabled = true
End If

end event

type cb_touchdirectory from commandbutton within w_main
integer x = 37
integer y = 1376
integer width = 443
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Touch Directory"
end type

event clicked;String ls_filespec
DateTime ldt_CreateTime, ldt_AccessTime, ldt_WriteTime

SetPointer(HourGlass!)

dw_entry.AcceptText()

ldt_CreateTime = dw_entry.GetItemDateTime(1, "create_date")
ldt_AccessTime = dw_entry.GetItemDateTime(1, "access_date")
ldt_WriteTime  = dw_entry.GetItemDateTime(1, "written_date")

ls_filespec = sle_directory.text

n_filetouch_ds.of_TouchDirectory(ls_filespec, &
			ldt_CreateTime, ldt_AccessTime, ldt_WriteTime)

SetRedraw(False)
n_filetouch_ds.of_Directory(ls_filespec)
SetRedraw(True)

end event

type cb_cancel from commandbutton within w_main
integer x = 2853
integer y = 1376
integer width = 334
integer height = 100
integer taborder = 80
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

type n_filetouch_ds from n_filetouch within w_main descriptor "pb_nvo" = "true" 
end type

on n_filetouch_ds.create
call super::create
end on

on n_filetouch_ds.destroy
call super::destroy
end on

