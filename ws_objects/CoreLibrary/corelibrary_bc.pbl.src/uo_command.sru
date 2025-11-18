$PBExportHeader$uo_command.sru
forward
global type uo_command from commandbutton
end type
end forward

global type uo_command from commandbutton
integer width = 402
integer height = 124
integer textsize = -11
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
event keypress pbm_keydown
end type
global uo_command uo_command

event keypress;if key = keyenter! then
	this.event clicked()
	Send(Handle(This),256,9,0)
end if
end event

on uo_command.create
end on

on uo_command.destroy
end on

