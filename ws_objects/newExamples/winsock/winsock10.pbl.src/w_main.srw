$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type tab_main from u_tab_main within w_main
end type
type tab_main from u_tab_main within w_main
end type
type cbx_setunicode from checkbox within w_main
end type
type st_3 from statictext within w_main
end type
type st_hostname from statictext within w_main
end type
type st_8 from statictext within w_main
end type
type st_ipaddress from statictext within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 3122
integer height = 1932
boolean titlebar = true
string title = "Winsock Example"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
tab_main tab_main
cbx_setunicode cbx_setunicode
st_3 st_3
st_hostname st_hostname
st_8 st_8
st_ipaddress st_ipaddress
cb_cancel cb_cancel
end type
global w_main w_main

type variables

end variables

on w_main.create
this.tab_main=create tab_main
this.cbx_setunicode=create cbx_setunicode
this.st_3=create st_3
this.st_hostname=create st_hostname
this.st_8=create st_8
this.st_ipaddress=create st_ipaddress
this.cb_cancel=create cb_cancel
this.Control[]={this.tab_main,&
this.cbx_setunicode,&
this.st_3,&
this.st_hostname,&
this.st_8,&
this.st_ipaddress,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.tab_main)
destroy(this.cbx_setunicode)
destroy(this.st_3)
destroy(this.st_hostname)
destroy(this.st_8)
destroy(this.st_ipaddress)
destroy(this.cb_cancel)
end on

event open;String ls_hostname

ls_hostname = gn_ws.of_GetHostName()

st_hostname.text = ls_hostname

st_ipaddress.text = gn_ws.of_GetIPAddress(ls_hostname)

end event

type tab_main from u_tab_main within w_main
integer x = 37
integer y = 128
integer width = 3003
integer height = 1528
end type

type cbx_setunicode from checkbox within w_main
integer x = 37
integer y = 36
integer width = 699
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send/Receive Unicode"
boolean checked = true
end type

event clicked;gn_ws.of_SetUnicode(this.checked,this.checked)

end event

type st_3 from statictext within w_main
integer x = 914
integer y = 36
integer width = 320
integer height = 60
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

type st_hostname from statictext within w_main
integer x = 1243
integer y = 36
integer width = 443
integer height = 60
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

type st_8 from statictext within w_main
integer x = 1719
integer y = 36
integer width = 320
integer height = 60
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

type st_ipaddress from statictext within w_main
integer x = 2048
integer y = 36
integer width = 443
integer height = 60
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
integer x = 2706
integer y = 1696
integer width = 334
integer height = 100
integer taborder = 10
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

