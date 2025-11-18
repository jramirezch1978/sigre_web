$PBExportHeader$w_main.srw
$PBExportComments$Window object
forward
global type w_main from window
end type
type pb_getipaddress from picturebutton within w_main
end type
type pb_gethostname from picturebutton within w_main
end type
type cb_identity from commandbutton within w_main
end type
type cb_reset from commandbutton within w_main
end type
type st_2 from statictext within w_main
end type
type sle_hostname from singlelineedit within w_main
end type
type lb_results from listbox within w_main
end type
type st_1 from statictext within w_main
end type
type sle_ipaddress from singlelineedit within w_main
end type
type cb_ping from commandbutton within w_main
end type
type cb_close from commandbutton within w_main
end type
end forward

global type w_main from window
integer x = 1170
integer y = 736
integer width = 1614
integer height = 1196
boolean titlebar = true
string title = "Ping Utility"
boolean controlmenu = true
boolean resizable = true
long backcolor = 79416533
string icon = "AppIcon!"
pb_getipaddress pb_getipaddress
pb_gethostname pb_gethostname
cb_identity cb_identity
cb_reset cb_reset
st_2 st_2
sle_hostname sle_hostname
lb_results lb_results
st_1 st_1
sle_ipaddress sle_ipaddress
cb_ping cb_ping
cb_close cb_close
end type
global w_main w_main

on w_main.create
this.pb_getipaddress=create pb_getipaddress
this.pb_gethostname=create pb_gethostname
this.cb_identity=create cb_identity
this.cb_reset=create cb_reset
this.st_2=create st_2
this.sle_hostname=create sle_hostname
this.lb_results=create lb_results
this.st_1=create st_1
this.sle_ipaddress=create sle_ipaddress
this.cb_ping=create cb_ping
this.cb_close=create cb_close
this.Control[]={this.pb_getipaddress,&
this.pb_gethostname,&
this.cb_identity,&
this.cb_reset,&
this.st_2,&
this.sle_hostname,&
this.lb_results,&
this.st_1,&
this.sle_ipaddress,&
this.cb_ping,&
this.cb_close}
end on

on w_main.destroy
destroy(this.pb_getipaddress)
destroy(this.pb_gethostname)
destroy(this.cb_identity)
destroy(this.cb_reset)
destroy(this.st_2)
destroy(this.sle_hostname)
destroy(this.lb_results)
destroy(this.st_1)
destroy(this.sle_ipaddress)
destroy(this.cb_ping)
destroy(this.cb_close)
end on

type pb_getipaddress from picturebutton within w_main
integer x = 1134
integer y = 224
integer width = 407
integer height = 164
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get IP Address from Hostname"
vtextalign vtextalign = multiline!
end type

event clicked;String ls_hostname, ls_ipaddress

If sle_hostname.text = "" Then
	ls_hostname = gn_ping.of_GetHostName()
	sle_hostname.text = ls_hostname
Else
	ls_hostname = sle_hostname.text
End If

ls_ipaddress = gn_ping.of_GetIPAddress(ls_hostname)

sle_ipaddress.text = ls_ipaddress

sle_ipaddress.SetFocus()

end event

type pb_gethostname from picturebutton within w_main
integer x = 1134
integer y = 32
integer width = 407
integer height = 164
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Hostname from IP Address"
vtextalign vtextalign = multiline!
end type

event clicked;String ls_hostname, ls_ipaddress

ls_ipaddress = sle_ipaddress.text
If ls_ipaddress = "" Then
	MessageBox("Ping", "IP Address is required!")
	sle_ipaddress.SetFocus()
	Return
End If

ls_hostname = gn_ping.of_GetHostName(ls_ipaddress)

sle_hostname.text = ls_hostname

sle_hostname.SetFocus()

end event

type cb_identity from commandbutton within w_main
integer x = 1134
integer y = 800
integer width = 407
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Identity"
end type

event clicked;String ls_compname, ls_userid

ls_compname = gn_ping.of_GetComputerName()
ls_userid = gn_ping.of_WNetGetUser()

MessageBox(	"Get Identity", &
				"Computer Name: " + ls_compname + "~r~n~r~n" + &
				"Network Userid: " + ls_userid)

end event

type cb_reset from commandbutton within w_main
integer x = 1134
integer y = 640
integer width = 407
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;lb_results.Reset()

end event

type st_2 from statictext within w_main
integer x = 37
integer y = 224
integer width = 311
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Host Name:"
boolean focusrectangle = false
end type

type sle_hostname from singlelineedit within w_main
integer x = 37
integer y = 288
integer width = 1029
integer height = 80
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

type lb_results from listbox within w_main
integer x = 37
integer y = 420
integer width = 1029
integer height = 640
integer taborder = 30
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

type st_1 from statictext within w_main
integer x = 37
integer y = 32
integer width = 311
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "IP Address:"
boolean focusrectangle = false
end type

type sle_ipaddress from singlelineedit within w_main
integer x = 37
integer y = 96
integer width = 443
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 15
borderstyle borderstyle = stylelowered!
end type

type cb_ping from commandbutton within w_main
integer x = 1134
integer y = 480
integer width = 407
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ping"
end type

event clicked;Boolean lb_success
String ls_ipaddress
Double ldbl_elapsed

ls_ipaddress = sle_ipaddress.text
If ls_ipaddress = "" Then
	MessageBox("Ping", "IP Address is required!")
	sle_ipaddress.SetFocus()
	Return
End If

gn_ping.of_Performance_Beg()

lb_success = gn_ping.of_Ping(ls_ipaddress)

ldbl_elapsed = gn_ping.of_Performance_End()

If lb_success Then
	lb_results.AddItem("Elapsed Time: " + String(ldbl_elapsed))
Else
	lb_results.AddItem("Ping Failed")
End If

end event

type cb_close from commandbutton within w_main
integer x = 1134
integer y = 960
integer width = 407
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

