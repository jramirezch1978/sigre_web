$PBExportHeader$u_cb_help.sru
$PBExportComments$Boton para llamar el Help Index
forward
global type u_cb_help from u_cb_std
end type
end forward

global type u_cb_help from u_cb_std
int Width=302
int Height=80
string Tag="Mostrar Ayuda"
string Text="Ayuda"
int Weight=700
end type
global u_cb_help u_cb_help

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_help_index()
end event

