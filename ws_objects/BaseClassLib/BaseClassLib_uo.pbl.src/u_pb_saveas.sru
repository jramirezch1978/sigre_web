$PBExportHeader$u_pb_saveas.sru
$PBExportComments$Boton para grabar el contenido del datawindow corriente
forward
global type u_pb_saveas from u_pb_std
end type
end forward

global type u_pb_saveas from u_pb_std
int Width=142
int Height=112
string Tag="Salvar Reporte en Archivo"
string PictureName="\source\bmp\excell.bmp"
end type
global u_pb_saveas u_pb_saveas

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_saveas()
end event

