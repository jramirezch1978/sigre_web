$PBExportHeader$u_cb_update.sru
$PBExportComments$Boton para Grabar el Contenido del Datawindow
forward
global type u_cb_update from u_cb_std
end type
end forward

global type u_cb_update from u_cb_std
int Width=302
int Height=80
string Tag="Grabar Registro"
string Text="Grabar"
int Weight=700
event ue_insert_key ( )
end type
global u_cb_update u_cb_update

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_update()
end event

