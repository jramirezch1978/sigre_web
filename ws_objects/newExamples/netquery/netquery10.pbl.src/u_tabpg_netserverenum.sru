$PBExportHeader$u_tabpg_netserverenum.sru
forward
global type u_tabpg_netserverenum from u_tabpg
end type
type dw_sessions from u_dw within u_tabpg_netserverenum
end type
type cb_execute from commandbutton within u_tabpg_netserverenum
end type
type dw_choose from datawindow within u_tabpg_netserverenum
end type
end forward

global type u_tabpg_netserverenum from u_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="ServerEnum"
dw_sessions dw_sessions
cb_execute cb_execute
dw_choose dw_choose
end type
global u_tabpg_netserverenum u_tabpg_netserverenum

on u_tabpg_netserverenum.create
int iCurrent
call super::create
this.dw_sessions=create dw_sessions
this.cb_execute=create cb_execute
this.dw_choose=create dw_choose
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sessions
this.Control[iCurrent+2]=this.cb_execute
this.Control[iCurrent+3]=this.dw_choose
end on

on u_tabpg_netserverenum.destroy
call super::destroy
destroy(this.dw_sessions)
destroy(this.cb_execute)
destroy(this.dw_choose)
end on

type dw_sessions from u_dw within u_tabpg_netserverenum
int X=37
int Y=32
int Width=1431
int Height=1220
string DataObject="d_netserverenum"
boolean VScrollBar=true
end type

event constructor;call super::constructor;this.of_set_selectrow(true)

end event

type cb_execute from commandbutton within u_tabpg_netserverenum
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

event clicked;String ls_computer, ls_domain, ls_import
Integer li_major, li_minor
ULong lul_type

SetPointer(HourGlass!)

dw_choose.AcceptText()
lul_type = dw_choose.GetItemNumber(1, "svrtype")

gn_netapi.of_NetWkstaGetInfo(ls_computer, &
					ls_domain, li_major, li_minor)

ls_import = gn_netapi.of_NetServerEnum(ls_domain, lul_type)

If Len(ls_import) > 0 Then
	dw_sessions.Reset()
	dw_sessions.ImportString(ls_import)
End If

end event

type dw_choose from datawindow within u_tabpg_netserverenum
int X=1499
int Y=192
int Width=846
int Height=196
int TabOrder=30
boolean BringToTop=true
string DataObject="d_choose_servertype"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;this.InsertRow(0)

end event

