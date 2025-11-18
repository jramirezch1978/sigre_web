$PBExportHeader$u_cb_delete.sru
$PBExportComments$Boton para Eliminar Registro
forward
global type u_cb_delete from u_cb_std
end type
end forward

global type u_cb_delete from u_cb_std
int Width=302
int Height=80
string Tag="Eliminar Registro Actual"
string Text="Eliminar"
int Weight=700
end type
global u_cb_delete u_cb_delete

event clicked;call super::clicked;PARENT.EVENT Dynamic POST ue_delete()
end event

