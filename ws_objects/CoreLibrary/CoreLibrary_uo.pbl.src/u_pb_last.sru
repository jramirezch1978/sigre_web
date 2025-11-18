$PBExportHeader$u_pb_last.sru
$PBExportComments$Boton para ubicar el ultimo registro
forward
global type u_pb_last from u_pb_std
end type
end forward

global type u_pb_last from u_pb_std
int Width=128
int Height=104
string Tag="Mostrar ultimo Registro/Pagina"
string PictureName="\source\bmp\last2.bmp"
end type
global u_pb_last u_pb_last

event clicked;call super::clicked;Parent.Event Dynamic ue_scrollrow('L')
end event

