$PBExportHeader$u_cb_modify.sru
$PBExportComments$Boton para Habilitar la Modificacion del Registro
forward
global type u_cb_modify from u_cb_std
end type
end forward

global type u_cb_modify from u_cb_std
int Width=302
int Height=80
string Tag="Modificar Registro Actual"
string Text="Modificar"
int Weight=700
end type
global u_cb_modify u_cb_modify

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_modify()
end event

