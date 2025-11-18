$PBExportHeader$p_cancelar.sru
forward
global type p_cancelar from picturebutton
end type
end forward

global type p_cancelar from picturebutton
integer width = 402
integer height = 188
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
boolean originalsize = true
string picturename = "H:\source\BMP\CANCELAR.BMP"
alignment htextalign = right!
vtextalign vtextalign = vcenter!
boolean map3dcolors = true
string powertiptext = "Cancelar la operación"
end type
global p_cancelar p_cancelar

on p_cancelar.create
end on

on p_cancelar.destroy
end on

event clicked;close(parent)
end event

