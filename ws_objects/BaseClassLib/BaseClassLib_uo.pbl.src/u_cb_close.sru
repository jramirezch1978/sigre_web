$PBExportHeader$u_cb_close.sru
$PBExportComments$Boton para Cerrar Ventana
forward
global type u_cb_close from u_cb_std
end type
end forward

global type u_cb_close from u_cb_std
int Width=302
int Height=80
string Tag="Cerrar Ventana"
string Text="Cerrar"
int Weight=700
end type
global u_cb_close u_cb_close

event clicked;call super::clicked;Close(Parent)
end event

