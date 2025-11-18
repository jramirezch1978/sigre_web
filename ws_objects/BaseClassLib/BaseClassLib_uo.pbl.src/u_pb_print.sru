$PBExportHeader$u_pb_print.sru
$PBExportComments$Boton para Imprimir el datawindow corriente
forward
global type u_pb_print from u_pb_std
end type
end forward

global type u_pb_print from u_pb_std
int Width=142
int Height=112
string Tag="Imprimir Reporte"
string PictureName="\source\bmp\printer.bmp"
end type
global u_pb_print u_pb_print

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_print()
end event

