$PBExportHeader$w_gotodir.srw
forward
global type w_gotodir from w_base_response
end type
type cb_startup from u_cb within w_gotodir
end type
type cb_remove from u_cb within w_gotodir
end type
type st_saved from statictext within w_gotodir
end type
type cb_add from u_cb within w_gotodir
end type
type lb_directories from listbox within w_gotodir
end type
type cb_browse from u_cb within w_gotodir
end type
type st_directory from statictext within w_gotodir
end type
type sle_directory from singlelineedit within w_gotodir
end type
type cb_ok from u_cb within w_gotodir
end type
type cb_cancel from u_cb within w_gotodir
end type
end forward

global type w_gotodir from w_base_response
integer width = 1915
integer height = 1108
string title = "Goto Directory"
cb_startup cb_startup
cb_remove cb_remove
st_saved st_saved
cb_add cb_add
lb_directories lb_directories
cb_browse cb_browse
st_directory st_directory
sle_directory sle_directory
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_gotodir w_gotodir

forward prototypes
public subroutine wf_load ()
public function boolean wf_edit ()
public subroutine wf_save ()
end prototypes

public subroutine wf_load ();String ls_regkey, ls_subkeys[], ls_value
Integer li_idx, li_max

// get directory list
ls_regkey = "HKEY_CURRENT_USER\Software\" + &
					gn_app.is_company + "\Ftpclient\Directories"
RegistryValues(ls_regkey, ls_subkeys)
li_max = UpperBound(ls_subkeys)
For li_idx = 1 To li_max
	RegistryGet(ls_regkey, ls_subkeys[li_idx], RegString!, ls_value)
	lb_directories.AddItem(ls_value)
Next

end subroutine

public function boolean wf_edit ();If sle_directory.text = "" Then
	sle_directory.SetFocus()
	MessageBox("Edit Error", "Directory is required!")
	Return False
End If

Return True

end function

public subroutine wf_save ();String ls_regkey, ls_value
Integer li_idx, li_max

// delete current directory list
ls_regkey = "HKEY_CURRENT_USER\Software\" + &
					gn_app.is_company + "\Ftpclient\Directories"
RegistryDelete(ls_regkey, "")

li_max = lb_directories.TotalItems()
For li_idx = 1 To li_max
	ls_value = lb_directories.Text(li_idx)
	RegistrySet(ls_regkey, String(li_idx), RegString!, ls_value)
Next

end subroutine

on w_gotodir.create
int iCurrent
call super::create
this.cb_startup=create cb_startup
this.cb_remove=create cb_remove
this.st_saved=create st_saved
this.cb_add=create cb_add
this.lb_directories=create lb_directories
this.cb_browse=create cb_browse
this.st_directory=create st_directory
this.sle_directory=create sle_directory
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_startup
this.Control[iCurrent+2]=this.cb_remove
this.Control[iCurrent+3]=this.st_saved
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.lb_directories
this.Control[iCurrent+6]=this.cb_browse
this.Control[iCurrent+7]=this.st_directory
this.Control[iCurrent+8]=this.sle_directory
this.Control[iCurrent+9]=this.cb_ok
this.Control[iCurrent+10]=this.cb_cancel
end on

on w_gotodir.destroy
call super::destroy
destroy(this.cb_startup)
destroy(this.cb_remove)
destroy(this.st_saved)
destroy(this.cb_add)
destroy(this.lb_directories)
destroy(this.cb_browse)
destroy(this.st_directory)
destroy(this.sle_directory)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;sle_directory.text = Message.StringParm

wf_load()

end event

type cb_startup from u_cb within w_gotodir
integer x = 512
integer y = 864
integer width = 626
integer taborder = 40
string text = "Set Startup Directory"
end type

event clicked;call super::clicked;String ls_regkey, ls_value

// if edits pass, set startup directory
If wf_Edit() Then
	ls_regkey = "HKEY_CURRENT_USER\Software\" + &
						gn_app.is_company + "\Ftpclient"
	ls_value = sle_directory.text
	RegistrySet(ls_regkey, "Startup", RegString!, ls_value)
	MessageBox(this.text, "Startup Directory: " + ls_value)
End If

end event

type cb_remove from u_cb within w_gotodir
integer x = 1499
integer y = 448
integer taborder = 70
string text = "Remove"
end type

event clicked;call super::clicked;Integer li_selected, li_rc

li_selected = lb_directories.SelectedIndex()
If li_selected > 0 Then
	li_rc = MessageBox("Remove", &
				"Are you sure you want to remove the selected item?", &
				Question!, YesNo!)
	If li_rc = 1 Then
		lb_directories.DeleteItem(li_selected)
	End If
End If

end event

type st_saved from statictext within w_gotodir
integer x = 73
integer y = 252
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
string text = "Saved Directories"
boolean focusrectangle = false
end type

type cb_add from u_cb within w_gotodir
integer x = 1499
integer y = 320
integer taborder = 60
string text = "Add"
end type

event clicked;call super::clicked;Integer li_item

li_item = lb_directories.AddItem(sle_directory.text)
lb_directories.SelectItem(li_item)

end event

type lb_directories from listbox within w_gotodir
integer x = 73
integer y = 320
integer width = 1358
integer height = 484
integer taborder = 20
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

event selectionchanged;sle_directory.text = this.Text(index)

end event

event doubleclicked;sle_directory.text = this.Text(index)

cb_ok.Event Clicked()

end event

type cb_browse from u_cb within w_gotodir
integer x = 1499
integer y = 120
integer taborder = 50
string text = "Browse"
end type

event clicked;call super::clicked;Integer li_rc
String ls_directory

li_rc = GetFolder("Get Directory", ls_directory)
If li_rc = 1 Then
	sle_directory.text = ls_directory
End If

end event

type st_directory from statictext within w_gotodir
integer x = 73
integer y = 64
integer width = 347
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Goto Directory:"
boolean focusrectangle = false
end type

type sle_directory from singlelineedit within w_gotodir
integer x = 73
integer y = 128
integer width = 1358
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type cb_ok from u_cb within w_gotodir
integer x = 73
integer y = 864
integer taborder = 30
string text = "OK"
end type

event clicked;call super::clicked;// if edits pass, change directory and close
If wf_Edit() Then
	wf_Save()
	CloseWithReturn(Parent, sle_directory.text)
End If

end event

type cb_cancel from u_cb within w_gotodir
integer x = 1499
integer y = 864
integer taborder = 80
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;CloseWithReturn(Parent, this.ClassName())

end event

