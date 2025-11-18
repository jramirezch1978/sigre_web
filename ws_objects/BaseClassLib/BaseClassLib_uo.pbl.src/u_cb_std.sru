$PBExportHeader$u_cb_std.sru
$PBExportComments$Boton Standard, Ancestro de los demas botones
forward
global type u_cb_std from commandbutton
end type
end forward

global type u_cb_std from commandbutton
int Width=265
int Height=72
int TabOrder=10
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event ue_clicked_pre ( )
event mousemove pbm_mousemove
end type
global u_cb_std u_cb_std

type variables
Integer   ii_flag_acceso, ii_flag_log
end variables

event ue_clicked_pre;//idw_1.BorderStyle = StyleRaised!
//idw_1 = dw_master
//idw_1.BorderStyle = StyleLowered!

end event

event mousemove;Parent.DYNAMIC SetMicrohelp( this.tag )
end event

event clicked;THIS.Event ue_clicked_pre()

end event

