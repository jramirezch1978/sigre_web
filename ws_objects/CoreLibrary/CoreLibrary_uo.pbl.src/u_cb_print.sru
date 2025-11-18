$PBExportHeader$u_cb_print.sru
$PBExportComments$Boton para Imprimir la Ventana Corriente
forward
global type u_cb_print from u_cb_std
end type
end forward

global type u_cb_print from u_cb_std
int Width=302
int Height=80
string Tag="Imprimir Reporte"
string Text="Imprimir"
int Weight=700
end type
global u_cb_print u_cb_print

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_print()
end event

