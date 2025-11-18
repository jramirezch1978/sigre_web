$PBExportHeader$w_main.srw
forward
global type w_main from Window
end type
type tab_main from u_tab within w_main
end type
type cbx_livesizing from checkbox within w_main
end type
type dw_bottom_right from datawindow within w_main
end type
type dw_bottom_left from datawindow within w_main
end type
type dw_top_right from datawindow within w_main
end type
type dw_top_left from datawindow within w_main
end type
type st_vertical from u_splitbar_vertical within w_main
end type
type st_horizontal from u_splitbar_horizontal within w_main
end type
type cb_close from commandbutton within w_main
end type
type tab_main from u_tab within w_main
end type
end forward

global type w_main from Window
int X=521
int Y=48
int Width=2674
int Height=2284
boolean TitleBar=true
string Title="Demo of horizontal and vertical splitbars"
long BackColor=79416533
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
tab_main tab_main
cbx_livesizing cbx_livesizing
dw_bottom_right dw_bottom_right
dw_bottom_left dw_bottom_left
dw_top_right dw_top_right
dw_top_left dw_top_left
st_vertical st_vertical
st_horizontal st_horizontal
cb_close cb_close
end type
global w_main w_main

type prototypes

end prototypes

type variables
Dragobject idrg_Left
Dragobject idrg_Right
Long il_maxright

end variables

on w_main.create
this.tab_main=create tab_main
this.cbx_livesizing=create cbx_livesizing
this.dw_bottom_right=create dw_bottom_right
this.dw_bottom_left=create dw_bottom_left
this.dw_top_right=create dw_top_right
this.dw_top_left=create dw_top_left
this.st_vertical=create st_vertical
this.st_horizontal=create st_horizontal
this.cb_close=create cb_close
this.Control[]={this.tab_main,&
this.cbx_livesizing,&
this.dw_bottom_right,&
this.dw_bottom_left,&
this.dw_top_right,&
this.dw_top_left,&
this.st_vertical,&
this.st_horizontal,&
this.cb_close}
end on

on w_main.destroy
destroy(this.tab_main)
destroy(this.cbx_livesizing)
destroy(this.dw_bottom_right)
destroy(this.dw_bottom_left)
destroy(this.dw_top_right)
destroy(this.dw_top_left)
destroy(this.st_vertical)
destroy(this.st_horizontal)
destroy(this.cb_close)
end on

event open;// register objects with horizontal splitbar
st_horizontal.of_set_topobject(dw_top_left)
st_horizontal.of_set_topobject(dw_top_right)
st_horizontal.of_set_bottomobject(dw_bottom_left)
st_horizontal.of_set_bottomobject(dw_bottom_right)
st_horizontal.of_set_minsize(250, 250)

// register objects with vertical splitbar
st_vertical.of_set_leftobject(dw_top_left)
st_vertical.of_set_leftobject(dw_bottom_left)
st_vertical.of_set_rightobject(dw_top_right)
st_vertical.of_set_rightobject(dw_bottom_right)
st_vertical.of_set_minsize(250, 250)

// trigger event on tab control
tab_main.TriggerEvent("ue_postopen")

end event

type tab_main from u_tab within w_main
int X=37
int Y=1408
int Width=2126
int TabOrder=50
end type

type cbx_livesizing from checkbox within w_main
int X=2231
int Y=192
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

event clicked;st_horizontal.of_set_livesizing(this.Checked)
st_vertical.of_set_livesizing(this.Checked)

end event

type dw_bottom_right from datawindow within w_main
int X=1262
int Y=468
int Width=901
int Height=912
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;this.DataObject = "d_employees.psr"

end event

type dw_bottom_left from datawindow within w_main
int X=37
int Y=468
int Width=1207
int Height=912
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;this.DataObject = "d_employees.psr"

end event

type dw_top_right from datawindow within w_main
int X=1262
int Y=32
int Width=901
int Height=416
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;this.DataObject = "d_employees.psr"

end event

type dw_top_left from datawindow within w_main
int X=37
int Y=32
int Width=1207
int Height=416
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;this.DataObject = "d_employees.psr"

end event

type st_vertical from u_splitbar_vertical within w_main
int X=1243
int Y=32
int Height=1348
end type

event constructor;call super::constructor;// restore location from registry
this.of_get_location()

end event

event destructor;call super::destructor;// save location into registry
this.of_set_location()

end event

type st_horizontal from u_splitbar_horizontal within w_main
int X=37
int Y=448
int Width=2126
end type

event constructor;call super::constructor;// restore location from registry
this.of_get_location()

end event

event destructor;call super::destructor;// save location into registry
this.of_set_location()

end event

type cb_close from commandbutton within w_main
int X=2231
int Y=32
int Width=334
int Height=100
int TabOrder=60
string Text="Close"
boolean Cancel=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close(Parent)

end event

