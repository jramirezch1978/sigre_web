$PBExportHeader$w_chat.srw
forward
global type w_chat from window
end type
type cb_clear from commandbutton within w_chat
end type
type dw_messages from datawindow within w_chat
end type
type dw_clients from datawindow within w_chat
end type
type cb_send from commandbutton within w_chat
end type
type st_3 from statictext within w_chat
end type
type sle_message from singlelineedit within w_chat
end type
type st_2 from statictext within w_chat
end type
type st_1 from statictext within w_chat
end type
type cb_cancel from commandbutton within w_chat
end type
end forward

global type w_chat from window
integer width = 1399
integer height = 1296
boolean titlebar = true
string title = "Chat"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_listen pbm_custom01
cb_clear cb_clear
dw_messages dw_messages
dw_clients dw_clients
cb_send cb_send
st_3 st_3
sle_message sle_message
st_2 st_2
st_1 st_1
cb_cancel cb_cancel
end type
global w_chat w_chat

type variables
ULong iul_socket
ULong iul_listen
UInt iui_port
String is_myipaddress

end variables

forward prototypes
public function long wf_addclient (string as_ipaddress, string as_name)
public subroutine wf_addmsg (string as_msg, boolean ab_bold, unsignedinteger aui_color)
end prototypes

event ue_listen;// listen for messages

Long ll_find
String ls_msg, ls_findstr, ls_name, ls_ipaddress

choose case lparam
	case gn_ws.FD_ACCEPT
		// accept the incoming socket
		iul_listen = gn_ws.of_Accept(iul_socket)
	case gn_ws.FD_READ
		// read data from the incoming socket
		If gn_ws.of_Recv(iul_listen, ls_msg) Then
			ls_ipaddress = gn_ws.of_GetPeerName(iul_listen)
			ls_findstr = "ipaddress = '" + ls_ipaddress + "'"
			ll_find = dw_clients.Find(ls_findstr, 1, dw_clients.RowCount())
			If ll_find > 0 Then
				ls_name = dw_clients.GetItemString(ll_find, "name")
				wf_AddMsg(ls_name + " - " + ls_msg, False, 0)
			Else
				wf_AddMsg(ls_ipaddress + " - " + ls_msg, False, 0)
			End If
		Else
			wf_AddMsg("Error: " + gn_ws.of_GetLastError(), True, 255)
		End If
		// close the incoming socket
		gn_ws.of_Close(iul_listen)
end choose

end event

public function long wf_addclient (string as_ipaddress, string as_name);// add a client

Long ll_next

ll_next = dw_clients.InsertRow(0)

dw_clients.SetItem(ll_next, "ipaddress", as_ipaddress)
dw_clients.SetItem(ll_next, "name", as_name)

Return ll_next

end function

public subroutine wf_addmsg (string as_msg, boolean ab_bold, unsignedinteger aui_color);// add message

Long ll_next

dw_messages.SetRedraw(False)

ll_next = dw_messages.InsertRow(1)

dw_messages.SetItem(ll_next, "when", DateTime(Today(), Now()))
dw_messages.SetItem(ll_next, "message", as_msg)
If ab_bold Then
	dw_messages.SetItem(ll_next, "weight", 700)
Else
	dw_messages.SetItem(ll_next, "weight", 400)
End If
dw_messages.SetItem(ll_next, "color", aui_color)

dw_messages.SetRedraw(True)

end subroutine

on w_chat.create
this.cb_clear=create cb_clear
this.dw_messages=create dw_messages
this.dw_clients=create dw_clients
this.cb_send=create cb_send
this.st_3=create st_3
this.sle_message=create sle_message
this.st_2=create st_2
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.Control[]={this.cb_clear,&
this.dw_messages,&
this.dw_clients,&
this.cb_send,&
this.st_3,&
this.sle_message,&
this.st_2,&
this.st_1,&
this.cb_cancel}
end on

on w_chat.destroy
destroy(this.cb_clear)
destroy(this.dw_messages)
destroy(this.dw_clients)
destroy(this.cb_send)
destroy(this.st_3)
destroy(this.sle_message)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cancel)
end on

event open;String ls_ipaddress, ls_findstr
Long ll_find

ls_ipaddress = Message.StringParm

// set the port
iui_port = LISTENPORT + 1

// get this computer's ipaddress
is_myipaddress = gn_ws.of_GetIPAddress(gn_ws.of_GetHostName())

// create a listening socket
iul_socket = gn_ws.of_Listen(iui_port, Handle(this), 1)

// add clients
wf_AddClient(is_myipaddress, "This computer")

// select the client
If dw_clients.RowCount() > 0 Then
	If ls_ipaddress = "" Then
		ll_find = 1
	Else
		ls_findstr = "ipaddress = '" + ls_ipaddress + "'"
		ll_find = dw_clients.Find(ls_findstr, 1, dw_clients.RowCount())
		If ll_find = 0 Then
			// if not found, add it
			ll_find = wf_AddClient(ls_ipaddress, "Unknown")
		End If
	End If
	dw_clients.SetRow(ll_find)
	dw_clients.Event RowFocusChanged(ll_find)
End If

end event

event close;// close the listening socket
gn_ws.of_Close(iul_socket)

end event

type cb_clear from commandbutton within w_chat
integer x = 512
integer y = 1056
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear Msgs"
end type

event clicked;dw_messages.Reset()

sle_message.SetFocus()

end event

type dw_messages from datawindow within w_chat
integer x = 37
integer y = 96
integer width = 1285
integer height = 360
integer taborder = 10
string title = "none"
string dataobject = "d_messages"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_clients from datawindow within w_chat
integer x = 37
integer y = 576
integer width = 1285
integer height = 228
integer taborder = 50
string title = "none"
string dataobject = "d_clients"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.SelectRow(0, False)
this.SelectRow(currentrow, True)

sle_message.SetFocus()

end event

type cb_send from commandbutton within w_chat
integer x = 37
integer y = 1056
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
boolean default = true
end type

event clicked;ULong lul_socket
Long ll_current
String ls_ipaddress, ls_msg

ls_msg = Trim(sle_message.text)
sle_message.text = ""

If ls_msg <> "" Then
	// show messages you sent
	wf_addmsg("You - " + ls_msg, True, 0)
	Yield()
	// get ipaddress of remote client
	ll_current = dw_clients.GetRow()
	ls_ipaddress = dw_clients.GetItemString(ll_current, "ipaddress")
	// tell remote client to open the chat window
	lul_socket = gn_ws.of_Connect(ls_ipaddress, LISTENPORT)
	If lul_socket > 0 Then
		gn_ws.of_Send(lul_socket, is_myipaddress)
		gn_ws.of_Close(lul_socket)
	Else
		MessageBox(	"Send failed to connect!", &
						gn_ws.of_GetLastError(), StopSign!)
		Return
	End If
	// send your message to the remote client
	lul_socket = gn_ws.of_Connect(ls_ipaddress, iui_port)
	If lul_socket > 0 Then
		gn_ws.of_Send(lul_socket, ls_msg)
		gn_ws.of_Close(lul_socket)
	Else
		MessageBox(	"Send failed to connect!", &
						gn_ws.of_GetLastError(), StopSign!)
	End If
End If

sle_message.SetFocus()

end event

type st_3 from statictext within w_chat
integer x = 37
integer y = 864
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Message text:"
boolean focusrectangle = false
end type

type sle_message from singlelineedit within w_chat
integer x = 37
integer y = 928
integer width = 1285
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

type st_2 from statictext within w_chat
integer x = 37
integer y = 32
integer width = 558
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incoming messages:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_chat
integer x = 37
integer y = 512
integer width = 512
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send messages to:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_chat
integer x = 987
integer y = 1056
integer width = 334
integer height = 100
integer taborder = 30
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

