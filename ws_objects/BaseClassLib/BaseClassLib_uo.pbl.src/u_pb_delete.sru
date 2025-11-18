$PBExportHeader$u_pb_delete.sru
$PBExportComments$Boton para Borrar el Registro
forward
global type u_pb_delete from u_pb_std
end type
end forward

global type u_pb_delete from u_pb_std
int Width=142
int Height=112
string Tag="Borrar Registro Actual"
string PictureName="\source\bmp\trash.bmp"
end type
global u_pb_delete u_pb_delete

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_delete()
end event

