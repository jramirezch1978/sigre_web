$PBExportHeader$u_tabpg_netsessionenum.sru
forward
global type u_tabpg_netsessionenum from u_tabpg
end type
type st_1 from statictext within u_tabpg_netsessionenum
end type
type sle_server from singlelineedit within u_tabpg_netsessionenum
end type
type dw_sessions from u_dw within u_tabpg_netsessionenum
end type
type cb_execute from commandbutton within u_tabpg_netsessionenum
end type
type cb_netgetdcname from commandbutton within u_tabpg_netsessionenum
end type
end forward

global type u_tabpg_netsessionenum from u_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="SessionEnum"
st_1 st_1
sle_server sle_server
dw_sessions dw_sessions
cb_execute cb_execute
cb_netgetdcname cb_netgetdcname
end type
global u_tabpg_netsessionenum u_tabpg_netsessionenum

on u_tabpg_netsessionenum.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_server=create sle_server
this.dw_sessions=create dw_sessions
this.cb_execute=create cb_execute
this.cb_netgetdcname=create cb_netgetdcname
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_server
this.Control[iCurrent+3]=this.dw_sessions
this.Control[iCurrent+4]=this.cb_execute
this.Control[iCurrent+5]=this.cb_netgetdcname
end on

on u_tabpg_netsessionenum.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_server)
destroy(this.dw_sessions)
destroy(this.cb_execute)
destroy(this.cb_netgetdcname)
end on

type st_1 from statictext within u_tabpg_netsessionenum
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

type sle_server from singlelineedit within u_tabpg_netsessionenum
int X=1536
int Y=256
int Width=773
int Height=80
int TabOrder=30
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

type dw_sessions from u_dw within u_tabpg_netsessionenum
int X=37
int Y=32
int Width=1431
int Height=1220
int TabOrder=20
string DataObject="d_netsessionenum"
boolean VScrollBar=true
end type

event constructor;call super::constructor;this.of_set_selectrow(true)

end event

type cb_execute from commandbutton within u_tabpg_netsessionenum
int X=1536
int Y=32
int Width=297
int Height=100
int TabOrder=10
string Text="Execute"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String ls_dcname, ls_import

SetPointer(HourGlass!)

ls_dcname = sle_server.text

If Len(ls_dcname) > 0 Then
	ls_import = gn_netapi.of_NetSessionEnum(ls_dcname)
	If Len(ls_import) > 0 Then
		dw_sessions.Reset()
		dw_sessions.ImportString(ls_import)
	End If
End If

end event

type cb_netgetdcname from commandbutton within u_tabpg_netsessionenum
int X=1902
int Y=32
int Width=407
int Height=100
int TabOrder=40
boolean BringToTop=true
string Text="Get DC Name"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String ls_domain

sle_server.text = gn_netapi.of_NetGetDCName(ls_domain)

end event

