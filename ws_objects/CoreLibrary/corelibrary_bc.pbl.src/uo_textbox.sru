$PBExportHeader$uo_textbox.sru
forward
global type uo_textbox from singlelineedit
end type
end forward

global type uo_textbox from singlelineedit
integer width = 343
integer height = 92
integer taborder = 10
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
event keypress pbm_keydown
end type
global uo_textbox uo_textbox

event keypress;graphicobject var

if key = keyenter! then
	message.processed = true
	message.returnvalue = 0
	var = getfocus()
	send(handle(var),256,9,long(0,0))
end if
end event

event getfocus;if Len(This.Text) > 0 Then This.SelectText(1,Len(This.Text))
this.backcolor = RGB(191,220,207)
end event

event losefocus;this.backcolor = 1073741824
end event

on uo_textbox.create
end on

on uo_textbox.destroy
end on

