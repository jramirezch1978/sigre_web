$PBExportHeader$w_password_db.srw
$PBExportComments$modificacion de password
forward
global type w_password_db from window
end type
type sle_verificacion_password from singlelineedit within w_password_db
end type
type st_2 from statictext within w_password_db
end type
type st_1 from statictext within w_password_db
end type
type sle_nuevo_password from singlelineedit within w_password_db
end type
type sle_password from singlelineedit within w_password_db
end type
type pb_cancel from picturebutton within w_password_db
end type
type pb_ok from picturebutton within w_password_db
end type
type st_password from statictext within w_password_db
end type
type st_user from statictext within w_password_db
end type
type sle_user from singlelineedit within w_password_db
end type
type ln_1 from line within w_password_db
end type
end forward

global type w_password_db from window
integer x = 823
integer y = 360
integer width = 1641
integer height = 992
boolean titlebar = true
string title = "Cambio de Password"
boolean controlmenu = true
boolean minbox = true
long backcolor = 16711680
event ue_help_topic ( )
event ue_help_index ( )
sle_verificacion_password sle_verificacion_password
st_2 st_2
st_1 st_1
sle_nuevo_password sle_nuevo_password
sle_password sle_password
pb_cancel pb_cancel
pb_ok pb_ok
st_password st_password
st_user st_user
sle_user sle_user
ln_1 ln_1
end type
global w_password_db w_password_db

type variables
Integer ii_help
end variables

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
end event

on w_password_db.create
this.sle_verificacion_password=create sle_verificacion_password
this.st_2=create st_2
this.st_1=create st_1
this.sle_nuevo_password=create sle_nuevo_password
this.sle_password=create sle_password
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.st_password=create st_password
this.st_user=create st_user
this.sle_user=create sle_user
this.ln_1=create ln_1
this.Control[]={this.sle_verificacion_password,&
this.st_2,&
this.st_1,&
this.sle_nuevo_password,&
this.sle_password,&
this.pb_cancel,&
this.pb_ok,&
this.st_password,&
this.st_user,&
this.sle_user,&
this.ln_1}
end on

on w_password_db.destroy
destroy(this.sle_verificacion_password)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nuevo_password)
destroy(this.sle_password)
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.st_password)
destroy(this.st_user)
destroy(this.sle_user)
destroy(this.ln_1)
end on

event open;sle_user.text = gnvo_app.is_user

// ii_help = 101           // help topic

end event

type sle_verificacion_password from singlelineedit within w_password_db
integer x = 987
integer y = 520
integer width = 558
integer height = 92
integer taborder = 30
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

type st_2 from statictext within w_password_db
integer x = 119
integer y = 536
integer width = 827
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
string text = "Verificacion Password:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_password_db
integer x = 110
integer y = 400
integer width = 645
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
string text = "Nuevo Password:"
boolean focusrectangle = false
end type

type sle_nuevo_password from singlelineedit within w_password_db
integer x = 992
integer y = 404
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

type sle_password from singlelineedit within w_password_db
integer x = 987
integer y = 192
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
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from picturebutton within w_password_db
integer x = 969
integer y = 704
integer width = 247
integer height = 144
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type pb_ok from picturebutton within w_password_db
integer x = 603
integer y = 708
integer width = 247
integer height = 144
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ok"
alignment htextalign = left!
end type

event clicked;String ls_password, ls_group
Long ll_return
//
//DECLARE sp_password PROCEDURE FOR sp_password
//			@new = :sle_nuevo_password.text,
//			@loginame = :gnvo_app.is_user ;
			
SELECT usuario.clave, usuario.grupo_usr					
	INTO :ls_password, :ls_group
	FROM usuario
	WHERE usuario.cod_usr = :sle_user.text ;
	
IF SQLCA.SQLCode = 100 THEN
	MessageBox("Busqueda de Usuario", "Usuario no encontrado")
	GOTO FIN
END IF

IF SQLCA.SQLCode > 0 THEN
	MessageBox("Database Error", SQLCA.SQLErrText, Exclamation!)
	HALT
END IF

IF ls_password <> sle_password.text THEN
	MessageBox("Password Error", "Reintente", Exclamation!)
	sle_password.SetFocus()
	ll_return = sle_password.SelectText(1, Len(sle_password.text))
ELSE
	IF sle_nuevo_password.text <> sle_verificacion_password.text THEN
		MessageBox("Vericacion de Password", "Verificacion Errada", Exclamation!)	
		sle_nuevo_password.SetFocus()
		ll_return = sle_nuevo_password.SelectText(1, Len(sle_nuevo_password.text))
	ELSE
		UPDATE usuario 
				SET clave = :sle_nuevo_password.Text
				WHERE usuario.cod_usr  = :gnvo_app.is_user ;
		IF SQLCA.SQLNRows > 0 THEN
			COMMIT ;
//			EXECUTE sp_password  ;
			Close(Parent)
		ELSE
			Rollback ;
		END IF
	END IF
END IF

FIN:
end event

type st_password from statictext within w_password_db
integer x = 146
integer y = 204
integer width = 635
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
string text = "Password Actual:"
boolean focusrectangle = false
end type

type st_user from statictext within w_password_db
integer x = 151
integer y = 88
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

type sle_user from singlelineedit within w_password_db
integer x = 987
integer y = 64
integer width = 558
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type ln_1 from line within w_password_db
long linecolor = 16777215
integer linethickness = 4
integer beginx = 105
integer beginy = 352
integer endx = 1568
integer endy = 352
end type

