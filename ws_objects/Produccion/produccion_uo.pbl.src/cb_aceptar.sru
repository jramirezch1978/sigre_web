$PBExportHeader$cb_aceptar.sru
forward
global type cb_aceptar from commandbutton
end type
end forward

global type cb_aceptar from commandbutton
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
event ue_procesar ( )
end type
global cb_aceptar cb_aceptar

event clicked;SetPointer(HourGlass!)
this.Post event Dynamic ue_procesar()
SetPointer(Arrow!)
end event

on cb_aceptar.create
end on

on cb_aceptar.destroy
end on

