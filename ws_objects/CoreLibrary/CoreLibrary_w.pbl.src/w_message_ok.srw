$PBExportHeader$w_message_ok.srw
forward
global type w_message_ok from window
end type
type p_2 from picture within w_message_ok
end type
type shl_help from statichyperlink within w_message_ok
end type
type shl_1 from statichyperlink within w_message_ok
end type
type pb_1 from picturebutton within w_message_ok
end type
type st_mensaje from statictext within w_message_ok
end type
type p_1 from picture within w_message_ok
end type
end forward

global type w_message_ok from window
integer width = 2811
integer height = 988
boolean titlebar = true
string title = "Error o exception en la ejecución del programa"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
p_2 p_2
shl_help shl_help
shl_1 shl_1
pb_1 pb_1
st_mensaje st_mensaje
p_1 p_1
end type
global w_message_ok w_message_ok

on w_message_ok.create
this.p_2=create p_2
this.shl_help=create shl_help
this.shl_1=create shl_1
this.pb_1=create pb_1
this.st_mensaje=create st_mensaje
this.p_1=create p_1
this.Control[]={this.p_2,&
this.shl_help,&
this.shl_1,&
this.pb_1,&
this.st_mensaje,&
this.p_1}
end on

on w_message_ok.destroy
destroy(this.p_2)
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

type p_2 from picture within w_message_ok
integer x = 23
integer y = 28
integer width = 786
integer height = 536
string picturename = "C:\SIGRE\resources\JPG\todo_ok_3d.jpg"
boolean focusrectangle = false
end type

type shl_help from statichyperlink within w_message_ok
boolean visible = false
integer x = 530
integer y = 820
integer width = 2162
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
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_message_ok
integer x = 507
integer y = 720
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

type pb_1 from picturebutton within w_message_ok
integer x = 2112
integer y = 644
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

type st_mensaje from statictext within w_message_ok
integer x = 869
integer width = 1929
integer height = 616
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

type p_1 from picture within w_message_ok
integer x = 37
integer y = 588
integer width = 453
integer height = 288
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

