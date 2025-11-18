$PBExportHeader$u_pb_next.sru
$PBExportComments$Boton para pasar al siguiente registro o pagina
forward
global type u_pb_next from u_pb_std
end type
end forward

global type u_pb_next from u_pb_std
int Width=128
int Height=104
string Tag="Mostrar Registro/Pagina Siguiente"
string PictureName="\source\bmp\next2.bmp"
boolean OriginalSize=true
end type
global u_pb_next u_pb_next

event clicked;call super::clicked;Parent.Event Dynamic ue_scrollrow('N')
end event

