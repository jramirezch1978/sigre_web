$PBExportHeader$u_pb_previous.sru
$PBExportComments$Boton para pasar al registro o pagina anterior
forward
global type u_pb_previous from u_pb_std
end type
end forward

global type u_pb_previous from u_pb_std
int Width=128
int Height=104
string Tag="Mostrar Registro/Pagina Anterior"
string PictureName="\source\bmp\previous2.bmp"
boolean OriginalSize=true
end type
global u_pb_previous u_pb_previous

event clicked;call super::clicked;Parent.Event Dynamic ue_scrollrow('P')
end event

