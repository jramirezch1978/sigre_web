$PBExportHeader$w_profiles.srw
forward
global type w_profiles from w_base_response
end type
type cb_favorite from u_cb within w_profiles
end type
type cb_delete from u_cb within w_profiles
end type
type st_profile from statictext within w_profiles
end type
type sle_profile from singlelineedit within w_profiles
end type
type em_port from editmask within w_profiles
end type
type cb_connect from u_cb within w_profiles
end type
type st_password from statictext within w_profiles
end type
type sle_password from singlelineedit within w_profiles
end type
type sle_userid from singlelineedit within w_profiles
end type
type st_userid from statictext within w_profiles
end type
type sle_server from singlelineedit within w_profiles
end type
type st_server from statictext within w_profiles
end type
type cbx_anonymous from checkbox within w_profiles
end type
type cbx_passive from checkbox within w_profiles
end type
type st_port from statictext within w_profiles
end type
type st_initialdir from statictext within w_profiles
end type
type sle_initialdir from singlelineedit within w_profiles
end type
type cb_save from u_cb within w_profiles
end type
type cb_cancel from u_cb within w_profiles
end type
end forward

global type w_profiles from w_base_response
integer width = 1769
integer height = 1140
string title = "Server Profiles"
cb_favorite cb_favorite
cb_delete cb_delete
st_profile st_profile
sle_profile sle_profile
em_port em_port
cb_connect cb_connect
st_password st_password
sle_password sle_password
sle_userid sle_userid
st_userid st_userid
sle_server sle_server
st_server st_server
cbx_anonymous cbx_anonymous
cbx_passive cbx_passive
st_port st_port
st_initialdir st_initialdir
sle_initialdir sle_initialdir
cb_save cb_save
cb_cancel cb_cancel
end type
global w_profiles w_profiles

type variables
Integer ii_profile

end variables

forward prototypes
public subroutine wf_load ()
public function boolean wf_edit ()
public subroutine wf_save ()
end prototypes

public subroutine wf_load ();String ls_subkey

ls_subkey = "Profiles\" + String(ii_profile)

sle_profile.text		= gn_app.of_GetReg(ls_subkey, "", "")
sle_server.text		= gn_app.of_GetReg(ls_subkey, "Server", "")
sle_userid.text		= gn_app.of_GetReg(ls_subkey, "Userid", "")
sle_password.text		= gn_app.of_GetReg(ls_subkey, "Password", "")
sle_initialdir.text	= gn_app.of_GetReg(ls_subkey, "InitialDir", "")
em_port.text			= gn_app.of_GetReg(ls_subkey, "Port", "21")

If gn_app.of_GetReg(ls_subkey, "Anonymous", "false") = "true" Then
	cbx_anonymous.Checked = True
Else
	cbx_anonymous.Checked = False
End If
sle_userid.Enabled	= Not cbx_anonymous.Checked
sle_password.Enabled	= Not cbx_anonymous.Checked

If gn_app.of_GetReg(ls_subkey, "Passive", "false") = "true" Then
	cbx_passive.Checked = True
Else
	cbx_passive.Checked = False
End If

end subroutine

public function boolean wf_edit ();If sle_profile.text = "" Then
	sle_profile.SetFocus()
	MessageBox("Edit Error", "Profile Name is required!")
	Return False
End If

If sle_server.text = "" Then
	sle_server.SetFocus()
	MessageBox("Edit Error", "Server is required!")
	Return False
End If

If Not cbx_anonymous.Checked Then
	If sle_userid.text = "" Then
		sle_userid.SetFocus()
		MessageBox("Edit Error", "Userid is required!")
		Return False
	End If
	If sle_password.text = "" Then
		sle_password.SetFocus()
		MessageBox("Edit Error", "Password is required!")
		Return False
	End If
End If

Return True

end function

public subroutine wf_save ();String ls_subkey

ls_subkey = "Profiles\" + String(ii_profile)

gn_app.of_SetReg(ls_subkey, "", sle_profile.text)
gn_app.of_SetReg(ls_subkey, "Server", sle_server.text)
gn_app.of_SetReg(ls_subkey, "Userid", sle_userid.text)
gn_app.of_SetReg(ls_subkey, "Password", sle_password.text)
gn_app.of_SetReg(ls_subkey, "InitialDir", sle_initialdir.text)
gn_app.of_SetReg(ls_subkey, "Port", em_port.text)

If cbx_anonymous.Checked Then
	gn_app.of_SetReg(ls_subkey, "Anonymous", "true")
Else
	gn_app.of_SetReg(ls_subkey, "Anonymous", "false")
End If

If cbx_passive.Checked Then
	gn_app.of_SetReg(ls_subkey, "Passive", "true")
Else
	gn_app.of_SetReg(ls_subkey, "Passive", "false")
End If

end subroutine

on w_profiles.create
int iCurrent
call super::create
this.cb_favorite=create cb_favorite
this.cb_delete=create cb_delete
this.st_profile=create st_profile
this.sle_profile=create sle_profile
this.em_port=create em_port
this.cb_connect=create cb_connect
this.st_password=create st_password
this.sle_password=create sle_password
this.sle_userid=create sle_userid
this.st_userid=create st_userid
this.sle_server=create sle_server
this.st_server=create st_server
this.cbx_anonymous=create cbx_anonymous
this.cbx_passive=create cbx_passive
this.st_port=create st_port
this.st_initialdir=create st_initialdir
this.sle_initialdir=create sle_initialdir
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_favorite
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.st_profile
this.Control[iCurrent+4]=this.sle_profile
this.Control[iCurrent+5]=this.em_port
this.Control[iCurrent+6]=this.cb_connect
this.Control[iCurrent+7]=this.st_password
this.Control[iCurrent+8]=this.sle_password
this.Control[iCurrent+9]=this.sle_userid
this.Control[iCurrent+10]=this.st_userid
this.Control[iCurrent+11]=this.sle_server
this.Control[iCurrent+12]=this.st_server
this.Control[iCurrent+13]=this.cbx_anonymous
this.Control[iCurrent+14]=this.cbx_passive
this.Control[iCurrent+15]=this.st_port
this.Control[iCurrent+16]=this.st_initialdir
this.Control[iCurrent+17]=this.sle_initialdir
this.Control[iCurrent+18]=this.cb_save
this.Control[iCurrent+19]=this.cb_cancel
end on

on w_profiles.destroy
call super::destroy
destroy(this.cb_favorite)
destroy(this.cb_delete)
destroy(this.st_profile)
destroy(this.sle_profile)
destroy(this.em_port)
destroy(this.cb_connect)
destroy(this.st_password)
destroy(this.sle_password)
destroy(this.sle_userid)
destroy(this.st_userid)
destroy(this.sle_server)
destroy(this.st_server)
destroy(this.cbx_anonymous)
destroy(this.cbx_passive)
destroy(this.st_port)
destroy(this.st_initialdir)
destroy(this.sle_initialdir)
destroy(this.cb_save)
destroy(this.cb_cancel)
end on

event open;call super::open;String ls_regkey, ls_subkeys[]
Integer li_idx, li_max, li_profile, li_highest

ii_profile = Message.DoubleParm

If ii_profile = 0 Then
	cb_favorite.Enabled = False
	cb_delete.Enabled = False
	em_port.Text = "21"
	// determine the next profile number
	ls_regkey = "HKEY_CURRENT_USER\Software\" + &
						gn_app.is_company + "\Ftpclient\Profiles"
	RegistryKeys(ls_regkey, ls_subkeys)
	li_max = UpperBound(ls_subkeys)
	For li_idx = 1 To li_max
		li_profile = Integer(ls_subkeys[li_idx])
		If li_profile > li_highest Then
			li_highest = li_profile
		End If
	Next
	ii_profile = li_highest + 1
Else
	// load the profile
	wf_load()
End If

end event

type cb_favorite from u_cb within w_profiles
integer x = 1280
integer y = 576
integer width = 407
integer taborder = 90
string text = "Make Favorite"
end type

event clicked;call super::clicked;gn_app.of_SetReg("Profiles", "Toolbar", String(ii_profile))

gw_frame.wf_ServerProfiles()

end event

type cb_delete from u_cb within w_profiles
integer x = 1280
integer y = 736
integer width = 407
integer taborder = 100
string text = "Delete"
end type

event clicked;call super::clicked;String ls_regkey
Integer li_rc

ls_regkey = "HKEY_CURRENT_USER\Software\" + &
					gn_app.is_company + "\Ftpclient\Profiles"
ls_regkey = ls_regkey + "\" + String(ii_profile)

li_rc = MessageBox("Confirm Delete", &
				"Do you really want to delete the profile?", &
				Question!, YesNo!)
If li_rc = 1 Then
	RegistryDelete(ls_regkey, "")
End If

CloseWithReturn(Parent, this.ClassName())

end event

type st_profile from statictext within w_profiles
integer x = 73
integer y = 64
integer width = 325
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
string text = "Profile Name:"
boolean focusrectangle = false
end type

type sle_profile from singlelineedit within w_profiles
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

type em_port from editmask within w_profiles
integer x = 658
integer y = 880
integer width = 187
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type cb_connect from u_cb within w_profiles
integer x = 1280
integer y = 124
integer width = 407
integer height = 200
integer taborder = 70
integer textsize = -10
integer weight = 700
string text = "Connect"
boolean default = true
end type

event clicked;call super::clicked;String ls_profile, ls_subkey

// if edits pass, connect and close
If wf_Edit() Then
	// connect to server
	gw_frame.uo_remote.of_Connect(ii_profile)
	// initialize the remote panel
	gw_frame.uo_remote.of_Populate_Listview()
	// change the window title
	ls_subkey = "Profiles\" + String(ii_profile)
	ls_profile = gn_app.of_GetReg(ls_subkey, "", "")
	gw_frame.Title = "FTPClient - " + ls_profile
	// close window
	CloseWithReturn(Parent, this.ClassName())
End If

end event

type st_password from statictext within w_profiles
integer x = 658
integer y = 432
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
string text = "Password:"
boolean focusrectangle = false
end type

type sle_password from singlelineedit within w_profiles
integer x = 658
integer y = 496
integer width = 553
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_userid from singlelineedit within w_profiles
integer x = 73
integer y = 496
integer width = 553
integer height = 84
integer taborder = 30
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

type st_userid from statictext within w_profiles
integer x = 73
integer y = 432
integer width = 187
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
string text = "Userid:"
boolean focusrectangle = false
end type

type sle_server from singlelineedit within w_profiles
integer x = 73
integer y = 320
integer width = 1138
integer height = 84
integer taborder = 20
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

type st_server from statictext within w_profiles
integer x = 73
integer y = 256
integer width = 197
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
string text = "Server:"
boolean focusrectangle = false
end type

type cbx_anonymous from checkbox within w_profiles
integer x = 73
integer y = 800
integer width = 503
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anonymous Login"
end type

event clicked;sle_userid.Enabled	= Not this.Checked
sle_password.Enabled	= Not this.Checked

sle_userid.text	= ""
sle_password.text	= ""

end event

type cbx_passive from checkbox within w_profiles
integer x = 73
integer y = 896
integer width = 416
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Passive Mode"
end type

type st_port from statictext within w_profiles
integer x = 658
integer y = 800
integer width = 142
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
string text = "Port:"
boolean focusrectangle = false
end type

type st_initialdir from statictext within w_profiles
integer x = 73
integer y = 608
integer width = 384
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
string text = "Initial Directory:"
boolean focusrectangle = false
end type

type sle_initialdir from singlelineedit within w_profiles
integer x = 73
integer y = 672
integer width = 1138
integer height = 84
integer taborder = 50
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

type cb_save from u_cb within w_profiles
integer x = 1280
integer y = 416
integer width = 407
integer taborder = 80
string text = "Save"
end type

event clicked;call super::clicked;// if edits pass, save changes and close
If wf_Edit() Then
	wf_Save()
	CloseWithReturn(Parent, this.ClassName())
End If

end event

type cb_cancel from u_cb within w_profiles
integer x = 1280
integer y = 896
integer width = 407
integer taborder = 110
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;CloseWithReturn(Parent, this.ClassName())

end event

