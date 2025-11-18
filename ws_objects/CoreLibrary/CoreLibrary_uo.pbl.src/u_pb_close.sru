$PBExportHeader$u_pb_close.sru
$PBExportComments$Boton que cierra la Ventana
forward
global type u_pb_close from u_pb_std
end type
end forward

global type u_pb_close from u_pb_std
int Width=142
int Height=112
string Tag="Cerrar Ventana"
string PictureName="\source\bmp\window.bmp"
end type
global u_pb_close u_pb_close

event clicked;call super::clicked;close(Parent)
end event

