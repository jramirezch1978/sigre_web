$PBExportHeader$u_tabpg_settings.sru
forward
global type u_tabpg_settings from u_tabpg
end type
type cb_o365 from commandbutton within u_tabpg_settings
end type
type st_5 from statictext within u_tabpg_settings
end type
type rb_tls from radiobutton within u_tabpg_settings
end type
type rb_ssl from radiobutton within u_tabpg_settings
end type
type rb_none from radiobutton within u_tabpg_settings
end type
type cb_gmail from commandbutton within u_tabpg_settings
end type
type sle_port from singlelineedit within u_tabpg_settings
end type
type st_4 from statictext within u_tabpg_settings
end type
type cbx_smtpauth from checkbox within u_tabpg_settings
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
string text = "Settings"
cb_o365 cb_o365
st_5 st_5
rb_tls rb_tls
rb_ssl rb_ssl
rb_none rb_none
cb_gmail cb_gmail
sle_port sle_port
st_4 st_4
cbx_smtpauth cbx_smtpauth
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
this.cb_o365=create cb_o365
this.st_5=create st_5
this.rb_tls=create rb_tls
this.rb_ssl=create rb_ssl
this.rb_none=create rb_none
this.cb_gmail=create cb_gmail
this.sle_port=create sle_port
this.st_4=create st_4
this.cbx_smtpauth=create cbx_smtpauth
this.sle_password=create sle_password
this.st_3=create st_3
this.st_2=create st_2
this.sle_userid=create sle_userid
this.cb_save=create cb_save
this.sle_server=create sle_server
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_o365
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.rb_tls
this.Control[iCurrent+4]=this.rb_ssl
this.Control[iCurrent+5]=this.rb_none
this.Control[iCurrent+6]=this.cb_gmail
this.Control[iCurrent+7]=this.sle_port
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cbx_smtpauth
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
destroy(this.cb_o365)
destroy(this.st_5)
destroy(this.rb_tls)
destroy(this.rb_ssl)
destroy(this.rb_none)
destroy(this.cb_gmail)
destroy(this.sle_port)
destroy(this.st_4)
destroy(this.cbx_smtpauth)
destroy(this.sle_password)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_userid)
destroy(this.cb_save)
destroy(this.sle_server)
destroy(this.st_1)
end on

event constructor;call super::constructor;sle_server.text   = of_getreg("Server", "")
sle_userid.text   = of_getreg("Userid", "")
sle_password.text = of_getreg("Password", "")
sle_port.text     = of_getreg("Port", "25")

If of_getreg("Auth", "N") = "Y" Then
	cbx_smtpauth.checked = True
Else
	cbx_smtpauth.checked = False
End If

rb_none.Checked = True
If of_getreg("Encrypt", "None") = "SSL" Then
	rb_ssl.checked = True
End If
If of_getreg("Encrypt", "None") = "TLS" Then
	rb_tls.checked = True
End If



end event

event ue_pagechanged;call super::ue_pagechanged;sle_server.SetFocus()

end event

type cb_o365 from commandbutton within u_tabpg_settings
integer x = 1280
integer y = 192
integer width = 699
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Click for Office365 settings"
end type

event clicked;// set Office365 properties
sle_server.text = "smtp.office365.com"
sle_port.text = "587"
sle_userid.text = "myaddress@mydomain.com"
sle_password.text = ""
cbx_smtpauth.checked = True
rb_tls.checked = True

sle_userid.SetFocus()

end event

type st_5 from statictext within u_tabpg_settings
integer x = 37
integer y = 708
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
string text = "SMTP Server Encryption Type:"
boolean focusrectangle = false
end type

type rb_tls from radiobutton within u_tabpg_settings
integer x = 622
integer y = 800
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
string text = "TLS"
end type

event clicked;sle_port.text = "587"

end event

type rb_ssl from radiobutton within u_tabpg_settings
integer x = 329
integer y = 800
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

event clicked;sle_port.text = "465"

end event

type rb_none from radiobutton within u_tabpg_settings
integer x = 37
integer y = 800
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

event clicked;sle_port.text = "25"

end event

type cb_gmail from commandbutton within u_tabpg_settings
integer x = 1280
integer y = 32
integer width = 699
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
sle_server.text = "smtp.gmail.com"
sle_port.text = "465"
sle_userid.text = "myaddress@gmail.com"
sle_password.text = ""
cbx_smtpauth.checked = True
rb_ssl.checked = True

MessageBox("GMail Security", &
	"You must login to your GMail account and " + &
	"enable 'Access for less secure apps' before " + &
	"the application can connect.")

sle_userid.SetFocus()

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
integer width = 151
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

type cbx_smtpauth from checkbox within u_tabpg_settings
integer x = 37
integer y = 576
integer width = 992
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "SMTP Server requires userid/password"
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
integer x = 2011
integer y = 1344
integer width = 334
integer height = 100
integer taborder = 70
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

If cbx_smtpauth.checked Then
	of_setreg("Auth", "Y")
Else
	of_setreg("Auth", "N")
End If

If rb_none.Checked Then
	of_setreg("Encrypt", "None")
End If
If rb_ssl.Checked Then
	of_setreg("Encrypt", "SSL")
End If
If rb_tls.Checked Then
	of_setreg("Encrypt", "TLS")
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
string text = "SMTP Server:"
boolean focusrectangle = false
end type

