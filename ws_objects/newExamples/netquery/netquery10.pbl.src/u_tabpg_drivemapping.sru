$PBExportHeader$u_tabpg_drivemapping.sru
forward
global type u_tabpg_drivemapping from u_tabpg
end type
type st_4 from statictext within u_tabpg_drivemapping
end type
type ddlb_drivetype from dropdownlistbox within u_tabpg_drivemapping
end type
type st_3 from statictext within u_tabpg_drivemapping
end type
type sle_sharename from singlelineedit within u_tabpg_drivemapping
end type
type cb_connect from commandbutton within u_tabpg_drivemapping
end type
type cbx_reconnect from checkbox within u_tabpg_drivemapping
end type
type cb_disconnect from commandbutton within u_tabpg_drivemapping
end type
end forward

global type u_tabpg_drivemapping from u_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="DriveMapping"
st_4 st_4
ddlb_drivetype ddlb_drivetype
st_3 st_3
sle_sharename sle_sharename
cb_connect cb_connect
cbx_reconnect cbx_reconnect
cb_disconnect cb_disconnect
end type
global u_tabpg_drivemapping u_tabpg_drivemapping

on u_tabpg_drivemapping.create
int iCurrent
call super::create
this.st_4=create st_4
this.ddlb_drivetype=create ddlb_drivetype
this.st_3=create st_3
this.sle_sharename=create sle_sharename
this.cb_connect=create cb_connect
this.cbx_reconnect=create cbx_reconnect
this.cb_disconnect=create cb_disconnect
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.ddlb_drivetype
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_sharename
this.Control[iCurrent+5]=this.cb_connect
this.Control[iCurrent+6]=this.cbx_reconnect
this.Control[iCurrent+7]=this.cb_disconnect
end on

on u_tabpg_drivemapping.destroy
call super::destroy
destroy(this.st_4)
destroy(this.ddlb_drivetype)
destroy(this.st_3)
destroy(this.sle_sharename)
destroy(this.cb_connect)
destroy(this.cbx_reconnect)
destroy(this.cb_disconnect)
end on

type st_4 from statictext within u_tabpg_drivemapping
int X=37
int Y=32
int Width=187
int Height=60
boolean Enabled=false
boolean BringToTop=true
string Text="Drive:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type ddlb_drivetype from dropdownlistbox within u_tabpg_drivemapping
int X=37
int Y=96
int Width=224
int Height=1156
int TabOrder=10
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
string Item[]={"A",&
"B",&
"C",&
"D",&
"E",&
"F",&
"G",&
"H",&
"I",&
"J",&
"K",&
"L",&
"M",&
"N",&
"O",&
"P",&
"Q",&
"R",&
"S",&
"T",&
"U",&
"V",&
"W",&
"X",&
"Y",&
"Z"}
end type

event constructor;this.SelectItem(3)

end event

type st_3 from statictext within u_tabpg_drivemapping
int X=37
int Y=228
int Width=352
int Height=60
boolean Enabled=false
boolean BringToTop=true
string Text="Share Name:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_sharename from singlelineedit within u_tabpg_drivemapping
int X=37
int Y=288
int Width=590
int Height=80
int TabOrder=20
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_connect from commandbutton within u_tabpg_drivemapping
int X=768
int Y=64
int Width=517
int Height=100
int TabOrder=30
boolean BringToTop=true
string Text="Connect"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String ls_drive, ls_share
Boolean lb_result

ls_drive = ddlb_drivetype.text

ls_share = sle_sharename.text

lb_result = gn_netapi.of_WNetAddConnection2(ls_drive, &
						ls_share, cbx_reconnect.checked)
If lb_result Then
	MessageBox("AddConnection", "Success!")
Else
	MessageBox("AddConnection", "Failure!")
End If

end event

type cbx_reconnect from checkbox within u_tabpg_drivemapping
int X=37
int Y=448
int Width=626
int Height=68
boolean BringToTop=true
string Text="Reconnect at Logon"
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_disconnect from commandbutton within u_tabpg_drivemapping
int X=763
int Y=256
int Width=517
int Height=100
int TabOrder=30
boolean BringToTop=true
string Text="Disconnect"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String ls_drive
Boolean lb_result

ls_drive = ddlb_drivetype.text

lb_result = gn_netapi.of_WNetCancelConnection2(ls_drive)
If lb_result Then
	MessageBox("CancelConnection", "Success!")
Else
	MessageBox("CancelConnection", "Failure!")
End If

end event

