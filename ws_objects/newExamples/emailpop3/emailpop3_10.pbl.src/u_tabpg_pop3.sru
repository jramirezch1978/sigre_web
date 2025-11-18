$PBExportHeader$u_tabpg_pop3.sru
forward
global type u_tabpg_pop3 from u_tabpg
end type
type cb_download from commandbutton within u_tabpg_pop3
end type
type cb_delete from commandbutton within u_tabpg_pop3
end type
type st_status from statictext within u_tabpg_pop3
end type
type hpb_progress from hprogressbar within u_tabpg_pop3
end type
type tab_pop3 from u_tab_pop3 within u_tabpg_pop3
end type
type tab_pop3 from u_tab_pop3 within u_tabpg_pop3
end type
type cb_load from commandbutton within u_tabpg_pop3
end type
type cb_save from commandbutton within u_tabpg_pop3
end type
type dw_received from datawindow within u_tabpg_pop3
end type
type cb_receive from commandbutton within u_tabpg_pop3
end type
end forward

global type u_tabpg_pop3 from u_tabpg
integer width = 3406
integer height = 2436
string text = "Receive Mail"
event ue_progress pbm_custom01
cb_download cb_download
cb_delete cb_delete
st_status st_status
hpb_progress hpb_progress
tab_pop3 tab_pop3
cb_load cb_load
cb_save cb_save
dw_received dw_received
cb_receive cb_receive
end type
global u_tabpg_pop3 u_tabpg_pop3

type variables
String is_email[]
String is_subject[]
String is_display[]

end variables

event ue_progress;// update the progress bar

choose case wparam
	case 0	// Status message
		st_status.text = String(lparam, "address")
		Yield()
	case 1	// Start
		hpb_progress.Position = 0
		Yield()
	case 2	// Update
		hpb_progress.Position = lparam
		Yield()
	case 3	// Done
		hpb_progress.Position = 0
		Yield()
end choose

end event

on u_tabpg_pop3.create
int iCurrent
call super::create
this.cb_download=create cb_download
this.cb_delete=create cb_delete
this.st_status=create st_status
this.hpb_progress=create hpb_progress
this.tab_pop3=create tab_pop3
this.cb_load=create cb_load
this.cb_save=create cb_save
this.dw_received=create dw_received
this.cb_receive=create cb_receive
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_download
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.hpb_progress
this.Control[iCurrent+5]=this.tab_pop3
this.Control[iCurrent+6]=this.cb_load
this.Control[iCurrent+7]=this.cb_save
this.Control[iCurrent+8]=this.dw_received
this.Control[iCurrent+9]=this.cb_receive
end on

on u_tabpg_pop3.destroy
call super::destroy
destroy(this.cb_download)
destroy(this.cb_delete)
destroy(this.st_status)
destroy(this.hpb_progress)
destroy(this.tab_pop3)
destroy(this.cb_load)
destroy(this.cb_save)
destroy(this.dw_received)
destroy(this.cb_receive)
end on

type cb_download from commandbutton within u_tabpg_pop3
integer x = 1682
integer y = 2304
integer width = 297
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Download"
end type

event clicked;Integer li_rc, li_idx[]
String ls_encrypt
Boolean lb_Return
Long ll_row

ll_row = dw_received.GetRow()
If ll_row = 0 Then Return

li_rc = MessageBox("Delete Email", &
				"Do you really want to download this email?", &
				Question!, YesNo!)

If li_rc = 1 Then
	li_idx[1] = dw_received.GetItemNumber(ll_row, "msgnum")

	ls_encrypt = of_getreg("Encrypt", "None")
	choose case ls_encrypt
		case "SSL"
			lb_Return = gn_pop3.of_RecvSSLMail(li_idx)
		case else
			lb_Return = gn_pop3.of_RecvMail(li_idx)
	end choose
	If lb_return Then
		dw_received.Event RowFocusChanged(dw_received.GetRow())
	End If
End If

end event

type cb_delete from commandbutton within u_tabpg_pop3
integer x = 2011
integer y = 2304
integer width = 297
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;Integer li_rc, li_idx
Long ll_row
String ls_uidl[], ls_encrypt
Boolean lb_Return

ll_row = dw_received.GetRow()
If ll_row = 0 Then Return

li_rc = MessageBox("Delete Email", &
				"Do you really want to delete this email?", &
				Question!, YesNo!)

If li_rc = 1 Then
	li_idx = dw_received.GetItemNumber(ll_row, "msgnum")
	ls_uidl[1] = gn_pop3.of_MsgUIDL(li_idx)
	ls_encrypt = of_getreg("Encrypt", "None")
	choose case ls_encrypt
		case "SSL"
			lb_Return = gn_pop3.of_DeleteSSLMail(ls_uidl)
		case else
			lb_Return = gn_pop3.of_DeleteMail(ls_uidl)
	end choose
	If lb_return Then
		dw_received.DeleteRow(ll_row)
		dw_received.Event RowFocusChanged(dw_received.GetRow())
	End If
End If

end event

type st_status from statictext within u_tabpg_pop3
integer x = 37
integer y = 2320
integer width = 1614
integer height = 68
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

type hpb_progress from hprogressbar within u_tabpg_pop3
integer x = 37
integer y = 2176
integer width = 3333
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type tab_pop3 from u_tab_pop3 within u_tabpg_pop3
integer x = 37
integer y = 416
integer width = 3333
integer height = 1700
integer taborder = 20
end type

type cb_load from commandbutton within u_tabpg_pop3
integer x = 2670
integer y = 2304
integer width = 297
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Load .eml"
end type

event clicked;String ls_pathname, ls_filename, ls_name, ls_email, ls_from, ls_subject
Integer li_rc, li_idx
Long ll_next
DateTime ldt_SentDate

li_rc = GetFileOpenName("Open Email", &
				ls_pathname, ls_filename, "eml", &
				"Internet E-Mail Message Files (*.eml), *.eml")

If li_rc = 1 Then
	li_idx = gn_pop3.of_MsgLoad(ls_pathname)
	ldt_SentDate = gn_pop3.of_MsgSentDate(li_idx)
	gn_pop3.of_MsgFrom(li_idx, ls_name, ls_email)
	If ls_name = ls_email Then
		ls_from = ls_email
	Else
		ls_from = ls_name + " [" + ls_email + "]"
	End If
	ls_subject = gn_pop3.of_MsgSubject(li_idx)
	ll_next = dw_received.InsertRow(0)
	dw_received.SetItem(ll_next, "sentdate", ldt_SentDate)
	dw_received.SetItem(ll_next, "fromname", ls_from)
	dw_received.SetItem(ll_next, "subject", ls_subject)
	If dw_received.GetRow() <> ll_next Then
		dw_received.SetRow(ll_next)
	End If
End If

end event

type cb_save from commandbutton within u_tabpg_pop3
integer x = 2341
integer y = 2304
integer width = 297
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save .eml"
end type

event clicked;String ls_pathname, ls_filename
Blob lblob_data
Integer li_rc

li_rc = GetFileSaveName("Save Email", &
				ls_pathname, ls_filename, "eml", &
				"Internet E-Mail Message Files (*.eml), *.eml")

If li_rc = 1 Then
	lblob_data = Blob(gn_pop3.of_MsgContent(dw_received.GetRow()), EncodingAnsi!)
	gn_pop3.of_WriteFile(ls_pathname, lblob_data)
End If

end event

type dw_received from datawindow within u_tabpg_pop3
integer x = 37
integer y = 32
integer width = 3333
integer height = 360
integer taborder = 10
string title = "none"
string dataobject = "d_received"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;If currentrow = 0 Then Return

this.SelectRow(0, False)
this.SelectRow(currentrow, True)

SetPointer(HourGlass!)

tab_pop3.of_Load(currentrow)

SetPointer(Arrow!)

end event

type cb_receive from commandbutton within u_tabpg_pop3
integer x = 3035
integer y = 2304
integer width = 334
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Receive"
end type

event clicked;String ls_server, ls_userid, ls_passwd, ls_subject
String ls_name, ls_email, ls_from, ls_encrypt
Integer li_idx, li_max
Long ll_next
Boolean lb_Return, lb_Logfile, lb_Delete, lb_headers
UInt lui_port
DateTime ldt_SentDate

ls_server = of_getreg("Server", "")

If ls_server = "" Then
	MessageBox("Edit Error", &
		"You must specify Server on the Settings tab first!")
	Return
End If

ls_userid = of_getreg("Userid", "")

If ls_userid = "" Then
	MessageBox("Edit Error", &
		"You must specify Userid on the Settings tab first!")
	Return
End If

ls_passwd = of_getreg("Password", "")

If ls_passwd = "" Then
	MessageBox("Edit Error", &
		"You must specify Password on the Settings tab first!")
	Return
End If

lui_port = Long(of_getreg("Port", "110"))

If of_getreg("LogFile", "N") = "Y" Then
	lb_Logfile = True
Else
	lb_Logfile = False
End If

If of_getreg("Delete", "N") = "Y" Then
	lb_Delete = True
Else
	lb_Delete = False
End If

If of_getreg("Headers", "N") = "Y" Then
	lb_headers = True
Else
	lb_headers = False
End If

// initialize Progress meter
gn_pop3.of_Progress_Notify(Handle(Parent), 1)

// set server login properties
gn_pop3.of_SetPort(lui_port)
gn_pop3.of_SetServer(ls_server)
gn_pop3.of_SetLogFile(lb_Logfile, "pop3_logfile.txt")
gn_pop3.of_SetLogin(ls_userid, ls_passwd)

// receive email messages
ls_encrypt = of_getreg("Encrypt", "None")
choose case ls_encrypt
	case "SSL"
		lb_Return = gn_pop3.of_RecvSSLMail(lb_Delete, lb_headers)
	case else
		lb_Return = gn_pop3.of_RecvMail(lb_Delete, lb_headers)
end choose

// display message count
li_max = gn_pop3.of_MsgCount()
If li_max = 0 Then
	gn_pop3.of_Progress_Message("Processing Complete - No messages received!")
Else
	If li_max = 1 Then
		gn_pop3.of_Progress_Message("Processing Complete - 1 message received!")
	Else
		gn_pop3.of_Progress_Message("Processing Complete - " + &
				String(li_max) + " messages received!")
	End If
End If

dw_received.Reset()

If lb_Return Then
	// load messages into datawindow
	For li_idx = 1 To li_max
		ldt_SentDate = gn_pop3.of_MsgSentDate(li_idx)
		gn_pop3.of_MsgFrom(li_idx, ls_name, ls_email)
		If ls_name = ls_email Then
			ls_from = ls_email
		Else
			ls_from = ls_name + " [" + ls_email + "]"
		End If
		ls_subject = gn_pop3.of_MsgSubject(li_idx)
		ll_next = dw_received.InsertRow(0)
		dw_received.SetItem(ll_next, "msgnum", li_idx)
		dw_received.SetItem(ll_next, "sentdate", ldt_SentDate)
		dw_received.SetItem(ll_next, "fromname", ls_from)
		dw_received.SetItem(ll_next, "subject", ls_subject)
	Next
Else
	MessageBox("RecvMail Error", gn_pop3.of_GetLastError())
End If

end event

