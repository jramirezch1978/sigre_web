$PBExportHeader$u_tabpg_netwkstauserenum.sru
forward
global type u_tabpg_netwkstauserenum from u_tabpg
end type
type dw_users from u_dw within u_tabpg_netwkstauserenum
end type
type cb_execute from commandbutton within u_tabpg_netwkstauserenum
end type
type st_1 from statictext within u_tabpg_netwkstauserenum
end type
type sle_server from singlelineedit within u_tabpg_netwkstauserenum
end type
end forward

global type u_tabpg_netwkstauserenum from u_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="UserEnum"
dw_users dw_users
cb_execute cb_execute
st_1 st_1
sle_server sle_server
end type
global u_tabpg_netwkstauserenum u_tabpg_netwkstauserenum

on u_tabpg_netwkstauserenum.create
int iCurrent
call super::create
this.dw_users=create dw_users
this.cb_execute=create cb_execute
this.st_1=create st_1
this.sle_server=create sle_server
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_users
this.Control[iCurrent+2]=this.cb_execute
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_server
end on

on u_tabpg_netwkstauserenum.destroy
call super::destroy
destroy(this.dw_users)
destroy(this.cb_execute)
destroy(this.st_1)
destroy(this.sle_server)
end on

type dw_users from u_dw within u_tabpg_netwkstauserenum
int X=37
int Y=32
int Width=736
int Height=1220
string DataObject="d_netwkstauserenum"
boolean VScrollBar=true
end type

event constructor;call super::constructor;this.of_set_selectrow(true)

end event

type cb_execute from commandbutton within u_tabpg_netwkstauserenum
int X=1536
int Y=32
int Width=297
int Height=100
int TabOrder=20
string Text="Execute"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String ls_server, ls_import

SetPointer(HourGlass!)

ls_server = sle_server.text

ls_import = gn_netapi.of_NetWkstaUserEnum(ls_server)

If Len(ls_import) > 0 Then
	dw_users.Reset()
	dw_users.ImportString(ls_import)
End If

end event

type st_1 from statictext within u_tabpg_netwkstauserenum
int X=1536
int Y=192
int Width=215
int Height=60
boolean Enabled=false
boolean BringToTop=true
string Text="Server:"
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

type sle_server from singlelineedit within u_tabpg_netwkstauserenum
int X=1536
int Y=256
int Width=773
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

event constructor;this.text = gn_netapi.of_GetComputerName()

end event

