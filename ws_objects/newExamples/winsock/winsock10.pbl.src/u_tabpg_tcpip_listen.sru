$PBExportHeader$u_tabpg_tcpip_listen.sru
$PBExportComments$Base tabpage object
forward
global type u_tabpg_tcpip_listen from u_tabpg
end type
type cb_reset from commandbutton within u_tabpg_tcpip_listen
end type
type cb_stop2 from commandbutton within u_tabpg_tcpip_listen
end type
type cb_listen2 from commandbutton within u_tabpg_tcpip_listen
end type
type cb_stop1 from commandbutton within u_tabpg_tcpip_listen
end type
type cb_listen1 from commandbutton within u_tabpg_tcpip_listen
end type
type lb_msgs from listbox within u_tabpg_tcpip_listen
end type
type st_2 from statictext within u_tabpg_tcpip_listen
end type
type st_1 from statictext within u_tabpg_tcpip_listen
end type
type sle_port from singlelineedit within u_tabpg_tcpip_listen
end type
type gb_1 from groupbox within u_tabpg_tcpip_listen
end type
type gb_2 from groupbox within u_tabpg_tcpip_listen
end type
end forward

global type u_tabpg_tcpip_listen from u_tabpg
string text = "TCP/IP Listen"
event ue_listen pbm_custom01
cb_reset cb_reset
cb_stop2 cb_stop2
cb_listen2 cb_listen2
cb_stop1 cb_stop1
cb_listen1 cb_listen1
lb_msgs lb_msgs
st_2 st_2
st_1 st_1
sle_port sle_port
gb_1 gb_1
gb_2 gb_2
end type
global u_tabpg_tcpip_listen u_tabpg_tcpip_listen

type variables
ULong iul_socket
ULong iul_listen
Boolean ib_Running

end variables

event ue_listen;// listen for messages

String ls_message, ls_ipaddress

choose case lparam
	case gn_ws.FD_ACCEPT
		// accept the incoming socket
		iul_listen = gn_ws.of_Accept(iul_socket)
		ls_ipaddress = gn_ws.of_GetPeerName(iul_listen)
		lb_msgs.AddItem("Incoming IP Address: " + ls_ipaddress)
	case gn_ws.FD_READ
		// read data from the incoming socket
		If gn_ws.of_Recv(iul_listen, ls_message) Then
			lb_msgs.AddItem(ls_message)
		Else
			lb_msgs.AddItem("of_Recv Error: " + gn_ws.of_GetLastError())
		End If
		// let the sender know we got the message
		gn_ws.of_Send(iul_listen, &
			String(Len(ls_message)) + " Bytes Received")
		// close the incoming socket
		gn_ws.of_Close(iul_listen)
end choose

end event

on u_tabpg_tcpip_listen.create
int iCurrent
call super::create
this.cb_reset=create cb_reset
this.cb_stop2=create cb_stop2
this.cb_listen2=create cb_listen2
this.cb_stop1=create cb_stop1
this.cb_listen1=create cb_listen1
this.lb_msgs=create lb_msgs
this.st_2=create st_2
this.st_1=create st_1
this.sle_port=create sle_port
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reset
this.Control[iCurrent+2]=this.cb_stop2
this.Control[iCurrent+3]=this.cb_listen2
this.Control[iCurrent+4]=this.cb_stop1
this.Control[iCurrent+5]=this.cb_listen1
this.Control[iCurrent+6]=this.lb_msgs
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_port
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on u_tabpg_tcpip_listen.destroy
call super::destroy
destroy(this.cb_reset)
destroy(this.cb_stop2)
destroy(this.cb_listen2)
destroy(this.cb_stop1)
destroy(this.cb_listen1)
destroy(this.lb_msgs)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_port)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_pagechanged;call super::ue_pagechanged;sle_port.SetFocus()

end event

event constructor;call super::constructor;sle_port.text = of_getreg("ListenPort", "")

end event

event destructor;call super::destructor;of_setreg("ListenPort", sle_port.text)

end event

type cb_reset from commandbutton within u_tabpg_tcpip_listen
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

type cb_stop2 from commandbutton within u_tabpg_tcpip_listen
integer x = 549
integer y = 832
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

event clicked;ib_Running = False

end event

type cb_listen2 from commandbutton within u_tabpg_tcpip_listen
integer x = 146
integer y = 832
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Listen"
end type

event clicked;// start listening

ULong lul_accept
String ls_message
UInt lui_port

SetPointer(HourGlass!)

lb_msgs.Reset()
lb_msgs.AddItem("Running...")

// make sure Port is specified
lui_port = Long(sle_port.text)
If lui_port = 0 Then
	sle_port.SetFocus()
	MessageBox("Edit Error", "Server Port is required!")
	Return
End If

// disable controls
sle_port.Enabled = False
cb_listen2.Enabled = False
cb_stop2.Enabled = True
cb_listen1.Enabled = False

// create a listening socket
iul_socket = gn_ws.of_Listen(lui_port)
If iul_socket = 0 Then
	MessageBox("Winsock Error in of_Listen", gn_ws.of_GetLastError())
	Return
Else
	// make the socket non-blocking
	gn_ws.of_SetBlockingMode(iul_socket, False)
	cb_listen2.Enabled = False
	cb_stop2.Enabled = True
End If

// loop until Stop button clicked
ib_Running = True
do while ib_Running
	// create a temporary socket for the incoming request
	lul_accept = gn_ws.of_Accept(iul_socket)
	If lul_accept > 0 Then
		// make the socket blocking
		gn_ws.of_SetBlockingMode(lul_accept, True)
		// receive the incoming data
		If gn_ws.of_Recv(lul_accept, ls_message) Then
			lb_msgs.AddItem("Msg Recvd: " + ls_message)
			// let the sender know we got the message
			If Not gn_ws.of_Send(lul_accept, &
						String(Len(ls_message)) + " Bytes Received") Then
				lb_msgs.AddItem("of_Send Error: " + gn_ws.of_GetLastError())
				Exit
			End If
		Else
			lb_msgs.AddItem("of_Recv Error: " + gn_ws.of_GetLastError())
			Exit
		End If
		// close the temporary socket
		gn_ws.of_Close(lul_accept)
	End If
	// Yield cpu so listbox can redraw and stop button will work
	Yield()
loop

// close the listen socket
gn_ws.of_Close(iul_socket)

// enable controls
sle_port.Enabled = True
cb_listen2.Enabled = True
cb_stop2.Enabled = False
cb_listen1.Enabled = True

lb_msgs.AddItem("Stopped...")

end event

type cb_stop1 from commandbutton within u_tabpg_tcpip_listen
integer x = 549
integer y = 416
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Stop"
end type

event clicked;// stop listening

SetPointer(HourGlass!)

// close the listening socket
gn_ws.of_Close(iul_socket)

// enable controls
sle_port.Enabled = True
cb_listen1.Enabled = True
cb_stop1.Enabled = False
cb_listen2.Enabled = True

lb_msgs.AddItem("Stopped...")

end event

type cb_listen1 from commandbutton within u_tabpg_tcpip_listen
integer x = 146
integer y = 416
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Listen"
end type

event clicked;// start listening

UInt lui_port

SetPointer(HourGlass!)

lb_msgs.Reset()
lb_msgs.AddItem("Running...")

// make sure Port is specified
lui_port = Long(sle_port.text)
If lui_port = 0 Then
	sle_port.SetFocus()
	MessageBox("Edit Error", "Server Port is required!")
	Return
End If

// disable controls
sle_port.Enabled = False
cb_listen1.Enabled = False
cb_stop1.Enabled = True
cb_listen2.Enabled = False

// create a listening socket
iul_socket = gn_ws.of_Listen(lui_port, Handle(Parent), 1)

end event

type lb_msgs from listbox within u_tabpg_tcpip_listen
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

type st_2 from statictext within u_tabpg_tcpip_listen
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

type st_1 from statictext within u_tabpg_tcpip_listen
integer x = 37
integer y = 116
integer width = 151
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

type sle_port from singlelineedit within u_tabpg_tcpip_listen
integer x = 219
integer y = 104
integer width = 224
integer height = 80
integer taborder = 10
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

type gb_1 from groupbox within u_tabpg_tcpip_listen
integer x = 37
integer y = 288
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
string text = "Listen with Window Event Notification"
end type

type gb_2 from groupbox within u_tabpg_tcpip_listen
integer x = 37
integer y = 704
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
string text = "Listen with non Window loop"
end type

