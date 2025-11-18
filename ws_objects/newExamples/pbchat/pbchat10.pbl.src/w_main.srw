$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
integer width = 3150
integer height = 2072
boolean titlebar = true
string title = "Example Application with Chat"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_listen pbm_custom01
mdi_1 mdi_1
end type
global w_main w_main

type variables
ULong iul_listen
ULong iul_receive

end variables

event ue_listen;// listen for chat requests

String ls_ipaddress

choose case lparam
	case gn_ws.FD_ACCEPT
		// accept the incoming socket
		iul_receive = gn_ws.of_Accept(iul_listen)
	case gn_ws.FD_READ
		ls_ipaddress = gn_ws.of_GetPeerName(iul_listen)
		gn_ws.of_Recv(iul_receive, ls_ipaddress)
		If Not IsValid(w_chat) Then
			OpenWithParm(w_chat, ls_ipaddress)
		End If
end choose

end event

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;String ls_ipaddress

// initialize Winsock
gn_ws.of_Startup()

// create a listening socket
iul_listen = gn_ws.of_Listen(LISTENPORT, Handle(this), 1)

end event

event close;// close the listening socket
gn_ws.of_Close(iul_listen)

end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

