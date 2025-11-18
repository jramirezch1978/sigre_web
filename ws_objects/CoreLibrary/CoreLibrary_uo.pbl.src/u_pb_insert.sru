$PBExportHeader$u_pb_insert.sru
$PBExportComments$Boton para Insertar un Registro
forward
global type u_pb_insert from u_pb_std
end type
end forward

global type u_pb_insert from u_pb_std
int Width=142
int Height=112
string Tag="Ingresar Registro Nuevo"
string PictureName="\source\bmp\new.bmp"
end type
global u_pb_insert u_pb_insert

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_insert()
end event

