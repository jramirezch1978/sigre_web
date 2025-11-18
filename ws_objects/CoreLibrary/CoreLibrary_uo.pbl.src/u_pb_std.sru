$PBExportHeader$u_pb_std.sru
$PBExportComments$Boton standard ancestro de los demas botones
forward
global type u_pb_std from picturebutton
end type
end forward

global type u_pb_std from picturebutton
int Width=137
int Height=100
int TabOrder=10
Alignment HTextAlign=Left!
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event ue_clicked_pre ( )
event mousemove pbm_mousemove
end type
global u_pb_std u_pb_std

type variables
Integer   ii_flag_acceso, ii_flag_log
end variables

event ue_clicked_pre;//idw_1.BorderStyle = StyleRaised!
//idw_1 = dw_master
//idw_1.BorderStyle = StyleLowered!

end event

event mousemove;Parent.DYNAMIC SetMicrohelp( this.tag )
end event

event clicked;THIS.EVENT ue_clicked_pre()
end event

