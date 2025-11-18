$PBExportHeader$u_pb_first.sru
$PBExportComments$Boton para ubicar el primer registro
forward
global type u_pb_first from u_pb_std
end type
end forward

global type u_pb_first from u_pb_std
int Width=128
int Height=104
string Tag="Mostrar Primer Registro/Pagina"
string PictureName="\source\bmp\first2.bmp"
boolean OriginalSize=true
end type
global u_pb_first u_pb_first

event clicked;call super::clicked;Parent.Event Dynamic ue_scrollrow('F')
end event

