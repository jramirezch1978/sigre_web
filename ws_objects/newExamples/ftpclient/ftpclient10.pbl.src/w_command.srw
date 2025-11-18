$PBExportHeader$w_command.srw
forward
global type w_command from w_base_response
end type
type sle_command from singlelineedit within w_command
end type
type st_command from statictext within w_command
end type
type cb_ok from u_cb within w_command
end type
type cb_cancel from u_cb within w_command
end type
end forward

global type w_command from w_base_response
integer width = 1294
integer height = 492
string title = "Send Command"
sle_command sle_command
st_command st_command
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_command w_command

forward prototypes
public subroutine wf_save ()
public function boolean wf_edit ()
end prototypes

public subroutine wf_save ();String ls_command, ls_response

ls_command = sle_command.text

gw_frame.wf_addmsg("Send Command: " + ls_command)
If Not gn_ftp.of_Ftp_Command(ls_command, ls_response) Then
	gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
	MessageBox("Send Command Error " + String(gn_ftp.LastErrorNbr), &
					gn_ftp.LastErrorMsg, StopSign!)
	Return
End If

MessageBox("Send Command Response", ls_response)

end subroutine

public function boolean wf_edit ();If sle_command.text = "" Then
	sle_command.SetFocus()
	MessageBox("Edit Error", "Command is required!")
	Return False
End If

Return True

end function

on w_command.create
int iCurrent
call super::create
this.sle_command=create sle_command
this.st_command=create st_command
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_command
this.Control[iCurrent+2]=this.st_command
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
end on

on w_command.destroy
call super::destroy
destroy(this.sle_command)
destroy(this.st_command)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

type sle_command from singlelineedit within w_command
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

type st_command from statictext within w_command
integer x = 73
integer y = 64
integer width = 261
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
string text = "Command:"
boolean focusrectangle = false
end type

type cb_ok from u_cb within w_command
integer x = 73
integer y = 256
integer taborder = 10
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;// if edits pass, change directory and close
If wf_Edit() Then
	wf_Save()
	CloseWithReturn(Parent, this.ClassName())
End If

end event

type cb_cancel from u_cb within w_command
integer x = 878
integer y = 256
integer taborder = 20
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;CloseWithReturn(Parent, this.ClassName())

end event

