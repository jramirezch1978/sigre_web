$PBExportHeader$u_cb_insert.sru
$PBExportComments$Boton para Insertar Registro
forward
global type u_cb_insert from u_cb_std
end type
end forward

global type u_cb_insert from u_cb_std
int Width=302
int Height=80
string Tag="Ingresar Registro Nuevo"
string Text="Insertar"
int Weight=700
end type
global u_cb_insert u_cb_insert

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_insert()
end event

