$PBExportHeader$u_base_button.sru
$PBExportComments$Base button object
forward
global type u_base_button from commandbutton
end type
end forward

global type u_base_button from commandbutton
int Width=334
int Height=100
int TabOrder=10
string Text="none"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_base_button u_base_button

event clicked;SetPointer(HourGlass!)

end event

