$PBExportHeader$w_message_user.srw
forward
global type w_message_user from window
end type
type shl_help from statichyperlink within w_message_user
end type
type shl_1 from statichyperlink within w_message_user
end type
type pb_1 from picturebutton within w_message_user
end type
type st_mensaje from statictext within w_message_user
end type
type p_1 from picture within w_message_user
end type
end forward

global type w_message_user from window
integer width = 2811
integer height = 924
boolean titlebar = true
string title = "Mensaje"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
shl_help shl_help
shl_1 shl_1
pb_1 pb_1
st_mensaje st_mensaje
p_1 p_1
end type
global w_message_user w_message_user

on w_message_user.create
this.shl_help=create shl_help
this.shl_1=create shl_1
this.pb_1=create pb_1
this.st_mensaje=create st_mensaje
this.p_1=create p_1
this.Control[]={this.shl_help,&
this.shl_1,&
this.pb_1,&
this.st_mensaje,&
this.p_1}
end on

on w_message_user.destroy
destroy(this.shl_help)
destroy(this.shl_1)
destroy(this.pb_1)
destroy(this.st_mensaje)
destroy(this.p_1)
end on

event open;// Asigna parametro
str_parametros lstr_param

if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) &
	or Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	
	MessageBox('Aviso ' + This.ClassName(), 'Parametros mal pasados', StopSign!)
	return 
	
end if

lstr_param = MESSAGE.POWEROBJECTPARM	

st_mensaje.text = lstr_param.string1

if lstr_param.string2 <> '' then
	shl_help.URL = "http://sigre.serveftp.com/Sigre/HelpDesk?Id=" + lstr_param.string2
	shl_help.visible = true
	shl_help.enabled = true
else
	shl_help.visible = false
	shl_help.enabled = false
end if

end event

type shl_help from statichyperlink within w_message_user
boolean visible = false
integer x = 992
integer y = 540
integer width = 1778
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 16777215
boolean enabled = false
string text = "Consultar Ayuda aqui"
alignment alignment = right!
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_message_user
integer x = 59
integer y = 676
integer width = 841
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 16777215
string text = "NPSSAC - SIGRE"
alignment alignment = center!
boolean focusrectangle = false
string url = "http://sigre.serveftp.com/help"
end type

type pb_1 from picturebutton within w_message_user
integer x = 2107
integer y = 624
integer width = 617
integer height = 172
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
boolean originalsize = true
string picturename = "C:\SIGRE\resources\Gif\aceptar.gif"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type st_mensaje from statictext within w_message_user
integer x = 992
integer y = 60
integer width = 1778
integer height = 452
integer textsize = -13
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_message_user
integer x = 18
integer y = 8
integer width = 965
integer height = 616
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

