$PBExportHeader$u_pb_modify.sru
$PBExportComments$Boton para Habilitar la modificacion del Registro
forward
global type u_pb_modify from u_pb_std
end type
end forward

global type u_pb_modify from u_pb_std
int Width=142
int Height=112
string Tag="Modificar Registro Actual"
string PictureName="\source\bmp\write.bmp"
end type
global u_pb_modify u_pb_modify

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_modify()
end event

