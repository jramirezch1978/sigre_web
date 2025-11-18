$PBExportHeader$u_tab.sru
$PBExportComments$Base tab object
forward
global type u_tab from tab
end type
end forward

global type u_tab from tab
int Width=1582
int Height=1000
int TabOrder=10
boolean RaggedRight=true
boolean BoldSelectedText=true
int SelectedTab=1
long BackColor=79416533
int TextSize=-8
int Weight=400
string FaceName="Tahoma"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_tab u_tab

event selectionchanged;// trigger event on new tab page
If newindex > 0 Then
	Control[newindex].Event Dynamic ue_pagechanged(oldindex)
End If

end event

