$PBExportHeader$w_message_sql.srw
forward
global type w_message_sql from window
end type
type mle_sql from multilineedit within w_message_sql
end type
type shl_help from statichyperlink within w_message_sql
end type
type shl_1 from statichyperlink within w_message_sql
end type
type pb_1 from picturebutton within w_message_sql
end type
type st_mensaje from statictext within w_message_sql
end type
type p_1 from picture within w_message_sql
end type
end forward

global type w_message_sql from window
integer width = 2811
integer height = 1580
boolean titlebar = true
string title = "Mensaje error SQL"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
mle_sql mle_sql
shl_help shl_help
shl_1 shl_1
pb_1 pb_1
st_mensaje st_mensaje
p_1 p_1
end type
global w_message_sql w_message_sql

on w_message_sql.create
this.mle_sql=create mle_sql
this.shl_help=create shl_help
this.shl_1=create shl_1
this.pb_1=create pb_1
this.st_mensaje=create st_mensaje
this.p_1=create p_1
this.Control[]={this.mle_sql,&
this.shl_help,&
this.shl_1,&
this.pb_1,&
this.st_mensaje,&
this.p_1}
end on

on w_message_sql.destroy
destroy(this.mle_sql)
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

st_mensaje.text 	= lstr_param.string1
mle_sql.text		= lstr_param.string2

shl_help.visible = false
shl_help.enabled = false

end event

type mle_sql from multilineedit within w_message_sql
integer x = 14
integer y = 656
integer width = 2770
integer height = 640
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type shl_help from statichyperlink within w_message_sql
boolean visible = false
integer x = 27
integer y = 1408
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
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_message_sql
integer x = 1006
integer y = 560
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
string text = "NPSSAC - SIGRE"
alignment alignment = center!
boolean focusrectangle = false
string url = "http://sigre.serveftp.com/help"
end type

type pb_1 from picturebutton within w_message_sql
integer x = 2162
integer y = 1308
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

type st_mensaje from statictext within w_message_sql
integer x = 1006
integer width = 1778
integer height = 524
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

type p_1 from picture within w_message_sql
integer x = 18
integer y = 8
integer width = 965
integer height = 616
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

