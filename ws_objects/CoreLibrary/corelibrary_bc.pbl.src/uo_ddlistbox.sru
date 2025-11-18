$PBExportHeader$uo_ddlistbox.sru
forward
global type uo_ddlistbox from dropdownlistbox
end type
end forward

global type uo_ddlistbox from dropdownlistbox
integer width = 727
integer height = 524
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
event keypress pbm_keydown
end type
global uo_ddlistbox uo_ddlistbox

type variables
String is_buscar_cadena
end variables

event keypress;graphicobject var

if key = KeyEnter! then
	message.processed = true
	message.returnvalue = 0
	var = getfocus()
	send(handle(var),256,9,long(0,0))
end if

if Key = KeyEscape! then
	is_buscar_cadena = ''
	Return
end if
if Key = KeyA! then 	is_buscar_cadena = is_buscar_cadena + "A"
if Key = KeyB! then 	is_buscar_cadena = is_buscar_cadena + "B"
if Key = KeyC! then 	is_buscar_cadena = is_buscar_cadena + "C"
if Key = KeyD! then 	is_buscar_cadena = is_buscar_cadena + "D"
if Key = KeyE! then 	is_buscar_cadena = is_buscar_cadena + "E"
if Key = KeyF! then 	is_buscar_cadena = is_buscar_cadena + "F"
if Key = KeyG! then 	is_buscar_cadena = is_buscar_cadena + "G"
if Key = KeyH! then 	is_buscar_cadena = is_buscar_cadena + "H"
if Key = KeyI! then 	is_buscar_cadena = is_buscar_cadena + "I"
if Key = KeyJ! then 	is_buscar_cadena = is_buscar_cadena + "J"
if Key = KeyK! then 	is_buscar_cadena = is_buscar_cadena + "K"
if Key = KeyL! then 	is_buscar_cadena = is_buscar_cadena + "L"
if Key = KeyM! then 	is_buscar_cadena = is_buscar_cadena + "M"
if Key = KeyN! then 	is_buscar_cadena = is_buscar_cadena + "N"
if Key = KeyO! then 	is_buscar_cadena = is_buscar_cadena + "O"
if Key = KeyP! then 	is_buscar_cadena = is_buscar_cadena + "P"
if Key = KeyQ! then 	is_buscar_cadena = is_buscar_cadena + "Q"
if Key = KeyR! then 	is_buscar_cadena = is_buscar_cadena + "R"
if Key = KeyS! then 	is_buscar_cadena = is_buscar_cadena + "S"
if Key = KeyT! then 	is_buscar_cadena = is_buscar_cadena + "T"
if Key = KeyU! then 	is_buscar_cadena = is_buscar_cadena + "U"
if Key = KeyV! then 	is_buscar_cadena = is_buscar_cadena + "V"
if Key = KeyW! then 	is_buscar_cadena = is_buscar_cadena + "W"
if Key = KeyX! then 	is_buscar_cadena = is_buscar_cadena + "X"
if Key = KeyY! then 	is_buscar_cadena = is_buscar_cadena + "Y"
if Key = KeyZ! then 	is_buscar_cadena = is_buscar_cadena + "Z"
if Key = Key0! then 	is_buscar_cadena = is_buscar_cadena + "0"
if Key = Key1! then 	is_buscar_cadena = is_buscar_cadena + "1"
if Key = Key2! then 	is_buscar_cadena = is_buscar_cadena + "2"
if Key = Key3! then 	is_buscar_cadena = is_buscar_cadena + "3"
if Key = Key4! then 	is_buscar_cadena = is_buscar_cadena + "4"
if Key = Key5! then 	is_buscar_cadena = is_buscar_cadena + "5"
if Key = Key6! then 	is_buscar_cadena = is_buscar_cadena + "6"
if Key = Key7! then 	is_buscar_cadena = is_buscar_cadena + "7"
if Key = Key8! then 	is_buscar_cadena = is_buscar_cadena + "8"
if Key = Key9! then 	is_buscar_cadena = is_buscar_cadena + "9"
This.Selectitem(is_buscar_cadena, 0)
This.selectedtext( )
end event

on uo_ddlistbox.create
end on

on uo_ddlistbox.destroy
end on

event constructor;is_buscar_cadena = ''
end event

event getfocus;is_buscar_cadena = ''
end event

