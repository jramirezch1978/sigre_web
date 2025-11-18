$PBExportHeader$u_tabpg_udp_listen.sru
$PBExportComments$Base tabpage object
forward
global type u_tabpg_udp_listen from u_tabpg
end type
type cb_gethost from commandbutton within u_tabpg_udp_listen
end type
type sle_port from singlelineedit within u_tabpg_udp_listen
end type
type st_3 from statictext within u_tabpg_udp_listen
end type
type st_1 from statictext within u_tabpg_udp_listen
end type
type sle_hostname from singlelineedit within u_tabpg_udp_listen
end type
type cb_reset from commandbutton within u_tabpg_udp_listen
end type
type cb_stop from commandbutton within u_tabpg_udp_listen
end type
type cb_receive from commandbutton within u_tabpg_udp_listen
end type
type lb_msgs from listbox within u_tabpg_udp_listen
end type
type st_2 from statictext within u_tabpg_udp_listen
end type
type gb_1 from groupbox within u_tabpg_udp_listen
end type
end forward

global type u_tabpg_udp_listen from u_tabpg
string text = "UDP Listen"
event ue_notify pbm_custom01
cb_gethost cb_gethost
sle_port sle_port
st_3 st_3
st_1 st_1
sle_hostname sle_hostname
cb_reset cb_reset
cb_stop cb_stop
cb_receive cb_receive
lb_msgs lb_msgs
st_2 st_2
gb_1 gb_1
end type
global u_tabpg_udp_listen u_tabpg_udp_listen

type variables

end variables

event ue_notify;// receive data

String ls_data

ls_data = String(wparam, "address")

lb_msgs.AddItem(ls_data)

If ls_data = "stop" Then
	cb_receive.Enabled = True
	cb_stop.Enabled = False
	SharedObjectUnRegister("shared_udp")
End If

end event

on u_tabpg_udp_listen.create
int iCurrent
call super::create
this.cb_gethost=create cb_gethost
this.sle_port=create sle_port
this.st_3=create st_3
this.st_1=create st_1
this.sle_hostname=create sle_hostname
this.cb_reset=create cb_reset
this.cb_stop=create cb_stop
this.cb_receive=create cb_receive
this.lb_msgs=create lb_msgs
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_gethost
this.Control[iCurrent+2]=this.sle_port
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_hostname
this.Control[iCurrent+6]=this.cb_reset
this.Control[iCurrent+7]=this.cb_stop
this.Control[iCurrent+8]=this.cb_receive
this.Control[iCurrent+9]=this.lb_msgs
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.gb_1
end on

on u_tabpg_udp_listen.destroy
call super::destroy
destroy(this.cb_gethost)
destroy(this.sle_port)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.sle_hostname)
destroy(this.cb_reset)
destroy(this.cb_stop)
destroy(this.cb_receive)
destroy(this.lb_msgs)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_pagechanged;call super::ue_pagechanged;sle_port.SetFocus()

end event

event constructor;call super::constructor;sle_port.text = of_getreg("ListenPort", "")
sle_hostname.text = of_getreg("SendHostName", "")

end event

event destructor;call super::destructor;of_setreg("ListenPort", sle_port.text)
of_setreg("SendHostName", sle_hostname.text)

end event

type cb_gethost from commandbutton within u_tabpg_udp_listen
integer x = 914
integer y = 96
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Get Host"
end type

event clicked;String ls_hostname

ls_hostname = gn_ws.of_GetHostName()

sle_hostname.text = ls_hostname

end event

type sle_port from singlelineedit within u_tabpg_udp_listen
integer x = 219
integer y = 224
integer width = 224
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 5
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within u_tabpg_udp_listen
integer x = 37
integer y = 228
integer width = 142
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port:"
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpg_udp_listen
integer x = 37
integer y = 116
integer width = 160
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Host:"
boolean focusrectangle = false
end type

type sle_hostname from singlelineedit within u_tabpg_udp_listen
integer x = 219
integer y = 104
integer width = 626
integer height = 80
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

type cb_reset from commandbutton within u_tabpg_udp_listen
integer x = 987
integer y = 1248
integer width = 334
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset Msgs"
end type

event clicked;lb_msgs.Reset()

end event

type cb_stop from commandbutton within u_tabpg_udp_listen
integer x = 549
integer y = 512
integer width = 334
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Stop"
end type

event clicked;UInt lui_port
String ls_ipaddress

// get port
lui_port = Long(sle_port.text)

// get IP Address of the remote host
ls_ipaddress = gn_ws.of_GetIPAddress(sle_hostname.text)

// send the message
gn_ws.of_SendTo(ls_ipaddress, lui_port, "stop")

// enable controls
sle_port.Enabled = True
cb_receive.Enabled = True
cb_stop.Enabled = False

end event

type cb_receive from commandbutton within u_tabpg_udp_listen
integer x = 146
integer y = 512
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Receive"
end type

event clicked;n_sharedobj ln_shr
String ls_hostname
UInt lui_port

SetPointer(HourGlass!)

ls_hostname = sle_hostname.text
If ls_hostname = "" Then
	sle_hostname.SetFocus()
	MessageBox("Edit Error", "Server Host Name is required!")
	Return
End If

lui_port = Long(sle_port.text)
If lui_port = 0 Then
	sle_port.SetFocus()
	MessageBox("Edit Error", "Server Port is required!")
	Return
End If

If SharedObjectRegister("n_sharedobj", "shared_udp") = Success! Then
	If SharedObjectGet("shared_udp", ln_shr) = Success! Then
		ln_shr.of_Register(Handle(Parent), 1)
		ln_shr.of_SetUnicode(w_main.cbx_setunicode.checked,w_main.cbx_setunicode.checked)
		ln_shr.Post of_RecvFrom(lui_port, 250)
		cb_receive.Enabled = False
		cb_stop.Enabled = True
	End If
End If

end event

type lb_msgs from listbox within u_tabpg_udp_listen
integer x = 1353
integer y = 96
integer width = 1541
integer height = 1252
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within u_tabpg_udp_listen
integer x = 1353
integer y = 32
integer width = 283
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Messages:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within u_tabpg_udp_listen
integer x = 37
integer y = 384
integer width = 1248
integer height = 324
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Listen with SharedObject thread"
end type

