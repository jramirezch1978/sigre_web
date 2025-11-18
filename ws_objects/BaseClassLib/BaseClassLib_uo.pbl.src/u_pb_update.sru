$PBExportHeader$u_pb_update.sru
$PBExportComments$Boton para grabar el contenido del datawindow
forward
global type u_pb_update from u_pb_std
end type
end forward

global type u_pb_update from u_pb_std
int Width=142
int Height=112
string Tag="Grabar Registro"
string PictureName="\source\bmp\diskette2.bmp"
end type
global u_pb_update u_pb_update

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_update()
end event

