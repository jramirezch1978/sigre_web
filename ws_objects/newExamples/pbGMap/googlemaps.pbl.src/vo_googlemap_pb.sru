$PBExportHeader$vo_googlemap_pb.sru
forward
global type vo_googlemap_pb from statichyperlink
end type
end forward

global type vo_googlemap_pb from statichyperlink
integer width = 4498
integer height = 1800
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string pointer = "HyperLink!"
long textcolor = 15780518
long backcolor = 67108864
string text = "Google Maps for .NET Webform Targets"
alignment alignment = center!
boolean focusrectangle = false
end type
global vo_googlemap_pb vo_googlemap_pb

type variables

end variables

on vo_googlemap_pb.create
end on

on vo_googlemap_pb.destroy
end on

event constructor;#IF DEFINED PBWEBFORM THEN
	this.embedded = true
#END IF
end event

