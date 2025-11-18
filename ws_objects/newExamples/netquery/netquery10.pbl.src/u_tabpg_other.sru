$PBExportHeader$u_tabpg_other.sru
forward
global type u_tabpg_other from u_tabpg
end type
type st_6 from statictext within u_tabpg_other
end type
type sle_commserver from singlelineedit within u_tabpg_other
end type
type st_5 from statictext within u_tabpg_other
end type
type sle_findusername from singlelineedit within u_tabpg_other
end type
type cb_finduser from commandbutton within u_tabpg_other
end type
type cb_wnetgetuser from commandbutton within u_tabpg_other
end type
type cb_getcomputername from commandbutton within u_tabpg_other
end type
type cb_netgetdcname from commandbutton within u_tabpg_other
end type
type cb_netwkstainfo from commandbutton within u_tabpg_other
end type
type cb_getdrivetype from commandbutton within u_tabpg_other
end type
type ddlb_drivetype from dropdownlistbox within u_tabpg_other
end type
type cb_messagesend from commandbutton within u_tabpg_other
end type
type sle_sendto from singlelineedit within u_tabpg_other
end type
type st_1 from statictext within u_tabpg_other
end type
type mle_message from multilineedit within u_tabpg_other
end type
type st_2 from statictext within u_tabpg_other
end type
type cb_whatdriveshare from commandbutton within u_tabpg_other
end type
type sle_sharename from singlelineedit within u_tabpg_other
end type
type st_3 from statictext within u_tabpg_other
end type
type cb_getconnection from commandbutton within u_tabpg_other
end type
type st_4 from statictext within u_tabpg_other
end type
type cb_netusergetinfo from commandbutton within u_tabpg_other
end type
type cb_whosecomputer from commandbutton within u_tabpg_other
end type
type sle_whosecomputer from singlelineedit within u_tabpg_other
end type
type st_7 from statictext within u_tabpg_other
end type
end forward

global type u_tabpg_other from u_tabpg
string text = "Other"
long tabbackcolor = 79416533
long picturemaskcolor = 553648127
st_6 st_6
sle_commserver sle_commserver
st_5 st_5
sle_findusername sle_findusername
cb_finduser cb_finduser
cb_wnetgetuser cb_wnetgetuser
cb_getcomputername cb_getcomputername
cb_netgetdcname cb_netgetdcname
cb_netwkstainfo cb_netwkstainfo
cb_getdrivetype cb_getdrivetype
ddlb_drivetype ddlb_drivetype
cb_messagesend cb_messagesend
sle_sendto sle_sendto
st_1 st_1
mle_message mle_message
st_2 st_2
cb_whatdriveshare cb_whatdriveshare
sle_sharename sle_sharename
st_3 st_3
cb_getconnection cb_getconnection
st_4 st_4
cb_netusergetinfo cb_netusergetinfo
cb_whosecomputer cb_whosecomputer
sle_whosecomputer sle_whosecomputer
st_7 st_7
end type
global u_tabpg_other u_tabpg_other

on u_tabpg_other.create
int iCurrent
call super::create
this.st_6=create st_6
this.sle_commserver=create sle_commserver
this.st_5=create st_5
this.sle_findusername=create sle_findusername
this.cb_finduser=create cb_finduser
this.cb_wnetgetuser=create cb_wnetgetuser
this.cb_getcomputername=create cb_getcomputername
this.cb_netgetdcname=create cb_netgetdcname
this.cb_netwkstainfo=create cb_netwkstainfo
this.cb_getdrivetype=create cb_getdrivetype
this.ddlb_drivetype=create ddlb_drivetype
this.cb_messagesend=create cb_messagesend
this.sle_sendto=create sle_sendto
this.st_1=create st_1
this.mle_message=create mle_message
this.st_2=create st_2
this.cb_whatdriveshare=create cb_whatdriveshare
this.sle_sharename=create sle_sharename
this.st_3=create st_3
this.cb_getconnection=create cb_getconnection
this.st_4=create st_4
this.cb_netusergetinfo=create cb_netusergetinfo
this.cb_whosecomputer=create cb_whosecomputer
this.sle_whosecomputer=create sle_whosecomputer
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.sle_commserver
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.sle_findusername
this.Control[iCurrent+5]=this.cb_finduser
this.Control[iCurrent+6]=this.cb_wnetgetuser
this.Control[iCurrent+7]=this.cb_getcomputername
this.Control[iCurrent+8]=this.cb_netgetdcname
this.Control[iCurrent+9]=this.cb_netwkstainfo
this.Control[iCurrent+10]=this.cb_getdrivetype
this.Control[iCurrent+11]=this.ddlb_drivetype
this.Control[iCurrent+12]=this.cb_messagesend
this.Control[iCurrent+13]=this.sle_sendto
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.mle_message
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.cb_whatdriveshare
this.Control[iCurrent+18]=this.sle_sharename
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.cb_getconnection
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.cb_netusergetinfo
this.Control[iCurrent+23]=this.cb_whosecomputer
this.Control[iCurrent+24]=this.sle_whosecomputer
this.Control[iCurrent+25]=this.st_7
end on

on u_tabpg_other.destroy
call super::destroy
destroy(this.st_6)
destroy(this.sle_commserver)
destroy(this.st_5)
destroy(this.sle_findusername)
destroy(this.cb_finduser)
destroy(this.cb_wnetgetuser)
destroy(this.cb_getcomputername)
destroy(this.cb_netgetdcname)
destroy(this.cb_netwkstainfo)
destroy(this.cb_getdrivetype)
destroy(this.ddlb_drivetype)
destroy(this.cb_messagesend)
destroy(this.sle_sendto)
destroy(this.st_1)
destroy(this.mle_message)
destroy(this.st_2)
destroy(this.cb_whatdriveshare)
destroy(this.sle_sharename)
destroy(this.st_3)
destroy(this.cb_getconnection)
destroy(this.st_4)
destroy(this.cb_netusergetinfo)
destroy(this.cb_whosecomputer)
destroy(this.sle_whosecomputer)
destroy(this.st_7)
end on

type st_6 from statictext within u_tabpg_other
integer x = 1719
integer y = 532
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Common Server:"
boolean focusrectangle = false
end type

type sle_commserver from singlelineedit within u_tabpg_other
integer x = 1719
integer y = 596
integer width = 590
integer height = 80
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within u_tabpg_other
integer x = 1719
integer y = 372
integer width = 352
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "User Name:"
boolean focusrectangle = false
end type

type sle_findusername from singlelineedit within u_tabpg_other
integer x = 1719
integer y = 436
integer width = 590
integer height = 80
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type cb_finduser from commandbutton within u_tabpg_other
integer x = 1170
integer y = 416
integer width = 517
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "FindUser"
end type

event clicked;String ls_server, ls_username, ls_computer[]
Integer li_cnt, li_max

SetPointer(HourGlass!)

ls_username = sle_findusername.text
ls_server = sle_commserver.text

If gn_netapi.of_FindUser(ls_server, ls_username, ls_computer) Then
	li_max = UpperBound(ls_computer)
	For li_cnt = 1 To li_max
		MessageBox(ls_username, ls_computer[li_cnt])
	Next
Else
	MessageBox(ls_username, "Not Found!")
End If

end event

type cb_wnetgetuser from commandbutton within u_tabpg_other
integer x = 37
integer y = 32
integer width = 517
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "WNetGetUser"
end type

event clicked;String ls_userid

ls_userid = gn_netapi.of_WNetGetUser()

MessageBox("Userid", ls_userid)

end event

type cb_getcomputername from commandbutton within u_tabpg_other
integer x = 37
integer y = 192
integer width = 517
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "GetComputerName"
end type

event clicked;String ls_name

ls_name = gn_netapi.of_GetComputerName()

MessageBox("Computer Name", ls_name)

end event

type cb_netgetdcname from commandbutton within u_tabpg_other
integer x = 622
integer y = 32
integer width = 517
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "NetGetDCName"
end type

event clicked;String ls_domain, ls_name

ls_name = gn_netapi.of_NetGetDCName(ls_domain)

MessageBox("Domain Controller Name", ls_name)

end event

type cb_netwkstainfo from commandbutton within u_tabpg_other
integer x = 622
integer y = 192
integer width = 517
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "NetWkstaInfo"
end type

event clicked;String ls_computer, ls_domain
Integer li_major, li_minor

gn_netapi.of_NetWkstaGetInfo(ls_computer, &
					ls_domain, li_major, li_minor)

MessageBox(	"Workstation Info", &
				"Computer: " + ls_computer + "~r~n" + &
				"Domain: " + ls_domain + "~r~n" + &
				"OSVer: " + String(li_major) + "." + String(li_minor) )

end event

type cb_getdrivetype from commandbutton within u_tabpg_other
integer x = 1536
integer y = 32
integer width = 517
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "GetDriveType"
end type

event clicked;String ls_drive, ls_type
Integer li_type

ls_drive = ddlb_drivetype.text

li_type = gn_netapi.of_GetDriveType(ls_drive)

CHOOSE CASE li_type
	CASE 0
		ls_type = "The drive type cannot be determined."
	CASE 1
		ls_type = "The root path is invalid."
	CASE 2
		ls_type = ls_drive + ": is a floppy drive."
	CASE 3
		ls_type = ls_drive + ": is a hard drive."
	CASE 4
		ls_type = ls_drive + ": is a network drive."
	CASE 5
		ls_type = ls_drive + ": is a CD-ROM drive."
	CASE 6
		ls_type = ls_drive + ": is a RAM drive."
END CHOOSE

MessageBox(this.text, ls_type, Information!)

end event

type ddlb_drivetype from dropdownlistbox within u_tabpg_other
integer x = 2085
integer y = 120
integer width = 224
integer height = 1156
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
borderstyle borderstyle = stylelowered!
end type

event constructor;this.SelectItem(3)

end event

type cb_messagesend from commandbutton within u_tabpg_other
integer x = 37
integer y = 960
integer width = 517
integer height = 100
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "NetMessageSend"
end type

event clicked;String ls_sendto, ls_msgtext

ls_sendto  = sle_sendto.text
ls_msgtext = mle_message.text

gn_netapi.of_NetMessageBufferSend(ls_sendto, ls_msgtext)

end event

type sle_sendto from singlelineedit within u_tabpg_other
integer x = 1097
integer y = 968
integer width = 590
integer height = 80
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within u_tabpg_other
integer x = 622
integer y = 980
integer width = 475
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Send to Machine:"
boolean focusrectangle = false
end type

type mle_message from multilineedit within u_tabpg_other
integer x = 622
integer y = 1088
integer width = 1065
integer height = 132
integer taborder = 180
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within u_tabpg_other
integer x = 224
integer y = 1088
integer width = 398
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Message Text:"
boolean focusrectangle = false
end type

type cb_whatdriveshare from commandbutton within u_tabpg_other
integer x = 37
integer y = 576
integer width = 517
integer height = 100
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "WhatDriveShare"
end type

event clicked;String ls_share, ls_drive

ls_share = sle_sharename.text

ls_drive = gn_netapi.of_WhatDriveShare(ls_share)

MessageBox("Share Drive", ls_drive)

end event

type sle_sharename from singlelineedit within u_tabpg_other
integer x = 585
integer y = 596
integer width = 590
integer height = 80
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within u_tabpg_other
integer x = 585
integer y = 536
integer width = 352
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Share Name:"
boolean focusrectangle = false
end type

type cb_getconnection from commandbutton within u_tabpg_other
integer x = 1536
integer y = 192
integer width = 517
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "WNetGetConnection"
end type

event clicked;String ls_drive, ls_share

ls_drive = ddlb_drivetype.text

ls_share = gn_netapi.of_WNetGetConnection(ls_drive)

MessageBox("Drive " + ls_drive, ls_share)

end event

type st_4 from statictext within u_tabpg_other
integer x = 2085
integer y = 56
integer width = 187
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Drive:"
boolean focusrectangle = false
end type

type cb_netusergetinfo from commandbutton within u_tabpg_other
integer x = 37
integer y = 352
integer width = 517
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "NetUserGetInfo"
end type

event clicked;String ls_server, ls_userid, ls_fullname, ls_comment

ls_server = gn_netapi.of_NetGetDCName("")

ls_userid = gn_netapi.of_WNetGetUser()

gn_netapi.of_NetUserGetInfo(ls_server, ls_userid, ls_fullname, ls_comment)

MessageBox(ls_fullname, ls_comment)

end event

type cb_whosecomputer from commandbutton within u_tabpg_other
integer x = 1170
integer y = 736
integer width = 517
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Whose Computer"
end type

event clicked;String ls_server, ls_computer, ls_userid, ls_fullname, ls_comment

SetPointer(HourGlass!)

ls_computer = sle_whosecomputer.text
ls_server   = sle_commserver.text

If gn_netapi.of_WhoseComputer(ls_server, ls_computer, ls_userid) Then
	ls_server = gn_netapi.of_NetGetDCName("")
	gn_netapi.of_NetUserGetInfo(ls_server, ls_userid, ls_fullname, ls_comment)
	MessageBox(ls_computer, ls_fullname)
Else
	MessageBox(ls_computer, "Not Found!")
End If

end event

type sle_whosecomputer from singlelineedit within u_tabpg_other
integer x = 1719
integer y = 760
integer width = 590
integer height = 80
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within u_tabpg_other
integer x = 1719
integer y = 696
integer width = 443
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Computer Name:"
boolean focusrectangle = false
end type

