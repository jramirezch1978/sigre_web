$PBExportHeader$u_tab.sru
forward
global type u_tab from tab
end type
type tabpage_first from u_tabpage within u_tab
end type
end forward

global type u_tab from tab
int Width=2117
int Height=712
int TabOrder=10
boolean RaggedRight=true
int SelectedTab=1
long BackColor=79416533
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
tabpage_first tabpage_first
event ue_postopen ( )
end type
global u_tab u_tab

event ue_postopen;this.TabTriggerEvent("ue_postopen")

end event

on u_tab.create
this.tabpage_first=create tabpage_first
this.Control[]={this.tabpage_first}
end on

on u_tab.destroy
destroy(this.tabpage_first)
end on

type tabpage_first from u_tabpage within u_tab
int X=18
int Y=100
int Width=2080
int Height=596
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

