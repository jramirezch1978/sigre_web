$PBExportHeader$u_tabpage.sru
forward
global type u_tabpage from UserObject
end type
type cbx_livesizing from checkbox within u_tabpage
end type
type dw_right from datawindow within u_tabpage
end type
type dw_left from datawindow within u_tabpage
end type
type st_splitbar from u_splitbar_vertical within u_tabpage
end type
end forward

global type u_tabpage from UserObject
int Width=2135
int Height=588
boolean Border=true
long BackColor=79416533
long PictureMaskColor=553648127
long TabTextColor=33554432
long TabBackColor=79416533
string Text="Tabpage"
event ue_postopen ( )
cbx_livesizing cbx_livesizing
dw_right dw_right
dw_left dw_left
st_splitbar st_splitbar
end type
global u_tabpage u_tabpage

event ue_postopen;// set main drag objects
st_splitbar.of_set_leftobject(dw_left)
st_splitbar.of_set_rightobject(dw_right)

end event

on u_tabpage.create
this.cbx_livesizing=create cbx_livesizing
this.dw_right=create dw_right
this.dw_left=create dw_left
this.st_splitbar=create st_splitbar
this.Control[]={this.cbx_livesizing,&
this.dw_right,&
this.dw_left,&
this.st_splitbar}
end on

on u_tabpage.destroy
destroy(this.cbx_livesizing)
destroy(this.dw_right)
destroy(this.dw_left)
destroy(this.st_splitbar)
end on

type cbx_livesizing from checkbox within u_tabpage
int X=1719
int Y=480
int Width=334
int Height=76
string Text="Live Sizing"
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;st_splitbar.of_set_livesizing(this.Checked)

end event

type dw_right from datawindow within u_tabpage
int X=969
int Y=32
int Width=1083
int Height=420
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;this.DataObject = "d_employees.psr"

end event

type dw_left from datawindow within u_tabpage
int X=37
int Y=32
int Width=914
int Height=420
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;this.DataObject = "d_employees.psr"

end event

type st_splitbar from u_splitbar_vertical within u_tabpage
int X=951
int Y=32
int Height=420
end type

event constructor;call super::constructor;// restore location from registry
this.of_get_location()

end event

event destructor;call super::destructor;// save location into registry
this.of_set_location()

end event

