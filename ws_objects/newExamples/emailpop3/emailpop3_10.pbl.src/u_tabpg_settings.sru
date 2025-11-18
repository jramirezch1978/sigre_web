$PBExportHeader$u_tabpg_settings.sru
forward
global type u_tabpg_settings from u_tabpg
end type
type cbx_headers from checkbox within u_tabpg_settings
end type
type cbx_delete from checkbox within u_tabpg_settings
end type
type cbx_logfile from checkbox within u_tabpg_settings
end type
type st_5 from statictext within u_tabpg_settings
end type
type cb_gmail from commandbutton within u_tabpg_settings
end type
type rb_ssl from radiobutton within u_tabpg_settings
end type
type rb_none from radiobutton within u_tabpg_settings
end type
type sle_port from singlelineedit within u_tabpg_settings
end type
type st_4 from statictext within u_tabpg_settings
end type
type sle_password from singlelineedit within u_tabpg_settings
end type
type st_3 from statictext within u_tabpg_settings
end type
type st_2 from statictext within u_tabpg_settings
end type
type sle_userid from singlelineedit within u_tabpg_settings
end type
type cb_save from commandbutton within u_tabpg_settings
end type
type sle_server from singlelineedit within u_tabpg_settings
end type
type st_1 from statictext within u_tabpg_settings
end type
end forward

global type u_tabpg_settings from u_tabpg
integer width = 3406
integer height = 2436
string text = "Settings"
cbx_headers cbx_headers
cbx_delete cbx_delete
cbx_logfile cbx_logfile
st_5 st_5
cb_gmail cb_gmail
rb_ssl rb_ssl
rb_none rb_none
sle_port sle_port
st_4 st_4
sle_password sle_password
st_3 st_3
st_2 st_2
sle_userid sle_userid
cb_save cb_save
sle_server sle_server
st_1 st_1
end type
global u_tabpg_settings u_tabpg_settings

on u_tabpg_settings.create
int iCurrent
call super::create
this.cbx_headers=create cbx_headers
this.cbx_delete=create cbx_delete
this.cbx_logfile=create cbx_logfile
this.st_5=create st_5
this.cb_gmail=create cb_gmail
this.rb_ssl=create rb_ssl
this.rb_none=create rb_none
this.sle_port=create sle_port
this.st_4=create st_4
this.sle_password=create sle_password
this.st_3=create st_3
this.st_2=create st_2
this.sle_userid=create sle_userid
this.cb_save=create cb_save
this.sle_server=create sle_server
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_headers
this.Control[iCurrent+2]=this.cbx_delete
this.Control[iCurrent+3]=this.cbx_logfile
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.cb_gmail
this.Control[iCurrent+6]=this.rb_ssl
this.Control[iCurrent+7]=this.rb_none
this.Control[iCurrent+8]=this.sle_port
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.sle_password
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.sle_userid
this.Control[iCurrent+14]=this.cb_save
this.Control[iCurrent+15]=this.sle_server
this.Control[iCurrent+16]=this.st_1
end on

on u_tabpg_settings.destroy
call super::destroy
destroy(this.cbx_headers)
destroy(this.cbx_delete)
destroy(this.cbx_logfile)
destroy(this.st_5)
destroy(this.cb_gmail)
destroy(this.rb_ssl)
destroy(this.rb_none)
destroy(this.sle_port)
destroy(this.st_4)
destroy(this.sle_password)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_userid)
destroy(this.cb_save)
destroy(this.sle_server)
destroy(this.st_1)
end on

event ue_pagechanged;call super::ue_pagechanged;sle_server.text   = of_getreg("Server", "")
sle_userid.text   = of_getreg("Userid", "")
sle_password.text = of_getreg("Password", "")
sle_port.text     = of_getreg("Port", "110")

rb_none.Checked = True
If of_getreg("Encrypt", "None") = "SSL" Then
	rb_ssl.checked = True
End If

If of_getreg("LogFile", "N") = "Y" Then
	cbx_logfile.checked = True
Else
	cbx_logfile.checked = False
End If

If of_getreg("Delete", "N") = "Y" Then
	cbx_delete.checked = True
Else
	cbx_delete.checked = False
End If

If of_getreg("Headers", "N") = "Y" Then
	cbx_headers.checked = True
Else
	cbx_headers.checked = False
End If

end event

type cbx_headers from checkbox within u_tabpg_settings
integer x = 37
integer y = 1088
integer width = 846
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Only retrieve message headers"
end type

type cbx_delete from checkbox within u_tabpg_settings
integer x = 37
integer y = 960
integer width = 846
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Delete messages from mail server"
end type

type cbx_logfile from checkbox within u_tabpg_settings
integer x = 37
integer y = 832
integer width = 846
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Log server conversation to file"
end type

type st_5 from statictext within u_tabpg_settings
integer x = 37
integer y = 576
integer width = 699
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "POP3 Server Encryption Type:"
boolean focusrectangle = false
end type

type cb_gmail from commandbutton within u_tabpg_settings
integer x = 1280
integer y = 32
integer width = 663
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Click for GMail settings"
end type

event clicked;// set GMail properties
sle_server.text = "pop.gmail.com"
sle_port.text = "995"
sle_userid.text = "myaddress@gmail.com"
sle_password.text = ""
rb_ssl.checked = True

sle_userid.SetFocus()

end event

type rb_ssl from radiobutton within u_tabpg_settings
integer x = 329
integer y = 668
integer width = 261
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "SSL"
end type

event clicked;sle_port.text = "995"

end event

type rb_none from radiobutton within u_tabpg_settings
integer x = 37
integer y = 668
integer width = 261
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "None"
end type

event clicked;sle_port.text = "110"

end event

type sle_port from singlelineedit within u_tabpg_settings
integer x = 366
integer y = 168
integer width = 215
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within u_tabpg_settings
integer x = 37
integer y = 176
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port:"
boolean focusrectangle = false
end type

type sle_password from singlelineedit within u_tabpg_settings
integer x = 366
integer y = 424
integer width = 846
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within u_tabpg_settings
integer x = 37
integer y = 432
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password:"
boolean focusrectangle = false
end type

type st_2 from statictext within u_tabpg_settings
integer x = 37
integer y = 304
integer width = 206
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Userid:"
boolean focusrectangle = false
end type

type sle_userid from singlelineedit within u_tabpg_settings
integer x = 366
integer y = 296
integer width = 846
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_save from commandbutton within u_tabpg_settings
integer x = 1280
integer y = 1056
integer width = 334
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;of_setreg("Server",   sle_server.text)
of_setreg("Userid",   sle_userid.text)
of_setreg("Password", sle_password.text)
of_setreg("Port",     sle_port.text)

If rb_none.Checked Then
	of_setreg("Encrypt", "None")
End If
If rb_ssl.Checked Then
	of_setreg("Encrypt", "SSL")
End If

If cbx_logfile.Checked Then
	of_setreg("LogFile", "Y")
Else
	of_setreg("LogFile", "N")
End If

If cbx_delete.Checked Then
	of_setreg("Delete", "Y")
Else
	of_setreg("Delete", "N")
End If

If cbx_headers.Checked Then
	of_setreg("Headers", "Y")
Else
	of_setreg("Headers", "N")
End If

end event

type sle_server from singlelineedit within u_tabpg_settings
integer x = 366
integer y = 40
integer width = 846
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within u_tabpg_settings
integer x = 37
integer y = 48
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "POP3 Server:"
boolean focusrectangle = false
end type

