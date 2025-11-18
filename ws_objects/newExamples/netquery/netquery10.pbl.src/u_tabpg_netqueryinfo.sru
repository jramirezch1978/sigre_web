$PBExportHeader$u_tabpg_netqueryinfo.sru
forward
global type u_tabpg_netqueryinfo from u_tabpg
end type
type dw_query from u_dw within u_tabpg_netqueryinfo
end type
type rb_users from radiobutton within u_tabpg_netqueryinfo
end type
type rb_groups from radiobutton within u_tabpg_netqueryinfo
end type
type rb_machines from radiobutton within u_tabpg_netqueryinfo
end type
type cb_execute from commandbutton within u_tabpg_netqueryinfo
end type
type st_1 from statictext within u_tabpg_netqueryinfo
end type
type em_flag from editmask within u_tabpg_netqueryinfo
end type
end forward

global type u_tabpg_netqueryinfo from u_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="QueryInfo"
dw_query dw_query
rb_users rb_users
rb_groups rb_groups
rb_machines rb_machines
cb_execute cb_execute
st_1 st_1
em_flag em_flag
end type
global u_tabpg_netqueryinfo u_tabpg_netqueryinfo

on u_tabpg_netqueryinfo.create
int iCurrent
call super::create
this.dw_query=create dw_query
this.rb_users=create rb_users
this.rb_groups=create rb_groups
this.rb_machines=create rb_machines
this.cb_execute=create cb_execute
this.st_1=create st_1
this.em_flag=create em_flag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_query
this.Control[iCurrent+2]=this.rb_users
this.Control[iCurrent+3]=this.rb_groups
this.Control[iCurrent+4]=this.rb_machines
this.Control[iCurrent+5]=this.cb_execute
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.em_flag
end on

on u_tabpg_netqueryinfo.destroy
call super::destroy
destroy(this.dw_query)
destroy(this.rb_users)
destroy(this.rb_groups)
destroy(this.rb_machines)
destroy(this.cb_execute)
destroy(this.st_1)
destroy(this.em_flag)
end on

type dw_query from u_dw within u_tabpg_netqueryinfo
int X=37
int Y=212
int Width=2272
int Height=1040
int TabOrder=30
string DataObject="d_netqueryinfo"
boolean VScrollBar=true
end type

event constructor;call super::constructor;this.of_set_selectrow(true)

end event

type rb_users from radiobutton within u_tabpg_netqueryinfo
int X=37
int Y=60
int Width=224
int Height=68
string Text="Users"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
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

type rb_groups from radiobutton within u_tabpg_netqueryinfo
int X=329
int Y=60
int Width=261
int Height=68
string Text="Groups"
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

type rb_machines from radiobutton within u_tabpg_netqueryinfo
int X=658
int Y=60
int Width=325
int Height=68
string Text="Machines"
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

type cb_execute from commandbutton within u_tabpg_netqueryinfo
int X=2011
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

event clicked;String ls_dcname, ls_domain, ls_import
Integer li_level, li_flag

SetPointer(HourGlass!)

ls_dcname = gn_netapi.of_NetGetDCName(ls_domain)

If Len(ls_dcname) > 0 Then
	If rb_users.checked Then li_level = 1
	If rb_machines.checked Then li_level = 2
	If rb_groups.checked Then li_level = 3
	li_flag = Integer(em_flag.text)
	ls_import = gn_netapi.of_NetQueryDisplayInformation(ls_dcname, li_level, li_flag)
	If Len(ls_import) > 0 Then
		dw_query.Reset()
		dw_query.ImportString(ls_import)
	End If
End If

end event

type st_1 from statictext within u_tabpg_netqueryinfo
int X=1024
int Y=60
int Width=229
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="Flag Bit:"
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

type em_flag from editmask within u_tabpg_netqueryinfo
int X=1257
int Y=52
int Width=101
int Height=80
int TabOrder=10
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
string Mask="#0"
string Text="1"
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

