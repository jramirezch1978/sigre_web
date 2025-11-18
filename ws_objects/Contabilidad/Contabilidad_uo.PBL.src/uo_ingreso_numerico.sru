$PBExportHeader$uo_ingreso_numerico.sru
forward
global type uo_ingreso_numerico from editmask
end type
end forward

global type uo_ingreso_numerico from editmask
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.00"
boolean spin = true
string minmax = "2000~~9999"
end type
global uo_ingreso_numerico uo_ingreso_numerico

on uo_ingreso_numerico.create
end on

on uo_ingreso_numerico.destroy
end on

