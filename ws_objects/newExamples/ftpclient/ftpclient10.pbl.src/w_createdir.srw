$PBExportHeader$w_createdir.srw
forward
global type w_createdir from w_base_response
end type
type sle_directory from singlelineedit within w_createdir
end type
type st_directory from statictext within w_createdir
end type
type cb_ok from u_cb within w_createdir
end type
type cb_cancel from u_cb within w_createdir
end type
end forward

global type w_createdir from w_base_response
integer width = 1294
integer height = 490
string title = "Create Directory"
sle_directory sle_directory
st_directory st_directory
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_createdir w_createdir

forward prototypes
public subroutine wf_save ()
public function boolean wf_edit ()
end prototypes

public subroutine wf_save ();String ls_directory

ls_directory = sle_directory.text

gw_frame.wf_addmsg("Create current directory: " + ls_directory)
If Not gn_ftp.of_ftp_CreateDirectory(ls_directory) Then
	gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
	MessageBox("CreateDirectory Error " + String(gn_ftp.LastErrorNbr), &
					gn_ftp.LastErrorMsg, StopSign!)
	Return
End If

end subroutine

public function boolean wf_edit ();If sle_directory.text = "" Then
	sle_directory.SetFocus()
	MessageBox("Edit Error", "Directory is required!")
	Return False
End If

Return True

end function

on w_createdir.create
int iCurrent
call super::create
this.sle_directory=create sle_directory
this.st_directory=create st_directory
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_directory
this.Control[iCurrent+2]=this.st_directory
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
end on

on w_createdir.destroy
call super::destroy
destroy(this.sle_directory)
destroy(this.st_directory)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

type sle_directory from singlelineedit within w_createdir
integer x = 73
integer y = 128
integer width = 1138
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

type st_directory from statictext within w_createdir
integer x = 73
integer y = 64
integer width = 251
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
string text = "Directory:"
boolean focusrectangle = false
end type

type cb_ok from u_cb within w_createdir
integer x = 73
integer y = 256
integer taborder = 10
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;// if edits pass, create directory and close
If wf_Edit() Then
	wf_Save()
	CloseWithReturn(Parent, this.ClassName())
End If

end event

type cb_cancel from u_cb within w_createdir
integer x = 878
integer y = 256
integer taborder = 20
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;CloseWithReturn(Parent, this.ClassName())

end event

