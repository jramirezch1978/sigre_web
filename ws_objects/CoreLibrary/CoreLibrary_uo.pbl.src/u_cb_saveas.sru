$PBExportHeader$u_cb_saveas.sru
$PBExportComments$Boton para Salvar el Reporte
forward
global type u_cb_saveas from u_cb_std
end type
end forward

global type u_cb_saveas from u_cb_std
int Width=302
int Height=80
string Tag="Salvar Reporte en  Archivo"
string Text="Salvar"
int Weight=700
end type
global u_cb_saveas u_cb_saveas

event clicked;call super::clicked;PARENT.EVENT Dynamic ue_saveas()
end event

