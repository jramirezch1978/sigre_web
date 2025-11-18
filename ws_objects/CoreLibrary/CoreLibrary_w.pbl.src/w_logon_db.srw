$PBExportHeader$w_logon_db.srw
$PBExportComments$Ancestro para Logon
forward
global type w_logon_db from window
end type
type cb_cancel from commandbutton within w_logon_db
end type
type cb_ok from commandbutton within w_logon_db
end type
type sle_password from singlelineedit within w_logon_db
end type
type st_password from statictext within w_logon_db
end type
type st_user from statictext within w_logon_db
end type
type sle_user from singlelineedit within w_logon_db
end type
end forward

global type w_logon_db from window
integer x = 823
integer y = 360
integer width = 1285
integer height = 624
boolean titlebar = true
string title = "Logon"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16711680
event ue_help_topic ( )
event ue_help_index ( )
cb_cancel cb_cancel
cb_ok cb_ok
sle_password sle_password
st_password st_password
st_user st_user
sle_user sle_user
end type
global w_logon_db w_logon_db

type prototypes

end prototypes

type variables
Integer ii_help
end variables

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

on w_logon_db.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_password=create sle_password
this.st_password=create st_password
this.st_user=create st_user
this.sle_user=create sle_user
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.sle_password,&
this.st_password,&
this.st_user,&
this.sle_user}
end on

on w_logon_db.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_password)
destroy(this.st_password)
destroy(this.st_user)
destroy(this.sle_user)
end on

event open;// ii_help = 101           // help topic

end event

type cb_cancel from commandbutton within w_logon_db
integer x = 873
integer y = 408
integer width = 247
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;DISCONNECT ;

HALT
end event

type cb_ok from commandbutton within w_logon_db
integer x = 402
integer y = 404
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ok"
end type

event clicked;String ls_password, ls_digitado, ls_basedato
Long ll_return

SELECT usuario.clave
	INTO :ls_password
	FROM usuario
	WHERE usuario.cod_usr = :sle_user.text ;
	
IF SQLCA.SQLCode = 100 THEN
	MessageBox("Busqueda de Usuario", "Usuario no encontrado")
	sle_user.SetFocus()
	ll_return = sle_user.SelectText(1, Len(sle_user.text))
	GOTO FIN
END IF

IF SQLCA.SQLCode > 0 THEN
	MessageBox("Database Error", SQLCA.SQLErrText, Exclamation!)
	HALT
END IF

ls_digitado = Trim(sle_password.text)
ls_basedato = Trim(ls_password)

IF Lower(ls_digitado) <> Lower(ls_basedato) THEN
	MessageBox("Password Error", "Reintente", Exclamation!)
	sle_password.SetFocus()
	ll_return = sle_password.SelectText(1, Len(sle_password.text))
ELSE
	gs_user = sle_user.text
	CloseWithReturn(Parent, 1)
END IF

FIN:

//DISCONNECT ;

end event

type sle_password from singlelineedit within w_logon_db
integer x = 585
integer y = 180
integer width = 558
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_password from statictext within w_logon_db
integer x = 155
integer y = 192
integer width = 398
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
boolean enabled = false
string text = "Password:"
boolean focusrectangle = false
end type

type st_user from statictext within w_logon_db
integer x = 151
integer y = 72
integer width = 398
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
boolean enabled = false
string text = "Usuario:"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_logon_db
integer x = 590
integer y = 60
integer width = 558
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

