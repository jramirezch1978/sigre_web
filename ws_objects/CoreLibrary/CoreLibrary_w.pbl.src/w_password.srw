$PBExportHeader$w_password.srw
$PBExportComments$modificacion de password
forward
global type w_password from window
end type
type st_database from statictext within w_password
end type
type pb_ok_db from picturebutton within w_password
end type
type sle_nuevo_password_db from singlelineedit within w_password
end type
type st_4 from statictext within w_password
end type
type st_3 from statictext within w_password
end type
type sle_verificacion_password_db from singlelineedit within w_password
end type
type sle_verificacion_password from singlelineedit within w_password
end type
type st_2 from statictext within w_password
end type
type st_1 from statictext within w_password
end type
type sle_nuevo_password from singlelineedit within w_password
end type
type sle_password from singlelineedit within w_password
end type
type pb_cancel from picturebutton within w_password
end type
type pb_ok from picturebutton within w_password
end type
type st_password from statictext within w_password
end type
type st_sistema from statictext within w_password
end type
type ln_2 from line within w_password
end type
type ln_3 from line within w_password
end type
end forward

global type w_password from window
integer x = 823
integer y = 360
integer width = 3296
integer height = 920
boolean titlebar = true
string title = "Cambio de Password"
boolean controlmenu = true
boolean minbox = true
long backcolor = 16711680
event ue_help_topic ( )
event ue_help_index ( )
st_database st_database
pb_ok_db pb_ok_db
sle_nuevo_password_db sle_nuevo_password_db
st_4 st_4
st_3 st_3
sle_verificacion_password_db sle_verificacion_password_db
sle_verificacion_password sle_verificacion_password
st_2 st_2
st_1 st_1
sle_nuevo_password sle_nuevo_password
sle_password sle_password
pb_cancel pb_cancel
pb_ok pb_ok
st_password st_password
st_sistema st_sistema
ln_2 ln_2
ln_3 ln_3
end type
global w_password w_password

type variables
String	is_flag_rep_clv
Integer	ii_help, ii_dias_cambio_clv, ii_dias_rep_clv, ii_long_min
end variables

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

on w_password.create
this.st_database=create st_database
this.pb_ok_db=create pb_ok_db
this.sle_nuevo_password_db=create sle_nuevo_password_db
this.st_4=create st_4
this.st_3=create st_3
this.sle_verificacion_password_db=create sle_verificacion_password_db
this.sle_verificacion_password=create sle_verificacion_password
this.st_2=create st_2
this.st_1=create st_1
this.sle_nuevo_password=create sle_nuevo_password
this.sle_password=create sle_password
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.st_password=create st_password
this.st_sistema=create st_sistema
this.ln_2=create ln_2
this.ln_3=create ln_3
this.Control[]={this.st_database,&
this.pb_ok_db,&
this.sle_nuevo_password_db,&
this.st_4,&
this.st_3,&
this.sle_verificacion_password_db,&
this.sle_verificacion_password,&
this.st_2,&
this.st_1,&
this.sle_nuevo_password,&
this.sle_password,&
this.pb_cancel,&
this.pb_ok,&
this.st_password,&
this.st_sistema,&
this.ln_2,&
this.ln_3}
end on

on w_password.destroy
destroy(this.st_database)
destroy(this.pb_ok_db)
destroy(this.sle_nuevo_password_db)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_verificacion_password_db)
destroy(this.sle_verificacion_password)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nuevo_password)
destroy(this.sle_password)
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.st_password)
destroy(this.st_sistema)
destroy(this.ln_2)
destroy(this.ln_3)
end on

event open;
// ii_help = 101           // help topic


IF gi_control_db = 0 THEN 	THIS.Width = 1637
end event

type st_database from statictext within w_password
integer x = 1783
integer y = 28
integer width = 1467
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16776960
boolean enabled = false
string text = "BASE DE DATOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_ok_db from picturebutton within w_password
integer x = 1792
integer y = 676
integer width = 247
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Ok"
end type

event clicked;String  	ls_clave, ls_user, ls_password, ls_nuevo_password
String   ls_verificacion_password, ls_cmd
Long 		ll_rc

ls_user = gs_user
ls_nuevo_password = sle_nuevo_password_db.text
ls_verificacion_password = sle_verificacion_password_db.text
ls_cmd = 'ALTER USER ' + ls_user + ' IDENTIFIED BY ' + ls_nuevo_password

IF ls_nuevo_password <> ls_verificacion_password THEN
	MessageBox("Vericacion de Password", "Verificacion Errada", Exclamation!)	
	sle_nuevo_password.SetFocus()
	ll_rc = sle_nuevo_password.SelectText(1, Len(sle_nuevo_password.text))
ELSE
	EXECUTE IMMEDIATE :ls_cmd  ;
END IF



end event

type sle_nuevo_password_db from singlelineedit within w_password
integer x = 2674
integer y = 392
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
boolean enabled = false
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_password
integer x = 1783
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

type st_3 from statictext within w_password
integer x = 1783
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

type sle_verificacion_password_db from singlelineedit within w_password
integer x = 2674
integer y = 528
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
boolean enabled = false
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_verificacion_password from singlelineedit within w_password
integer x = 1001
integer y = 528
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

type st_2 from statictext within w_password
integer x = 110
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

type st_1 from statictext within w_password
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

type sle_nuevo_password from singlelineedit within w_password
integer x = 1001
integer y = 392
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

type sle_password from singlelineedit within w_password
integer x = 1001
integer y = 196
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

type pb_cancel from picturebutton within w_password
integer x = 1303
integer y = 676
integer width = 247
integer height = 100
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

type pb_ok from picturebutton within w_password
integer x = 110
integer y = 676
integer width = 247
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ok"
end type

event clicked;String  			ls_clave, ls_user, ls_password, ls_nuevo_password, &
					ls_verificacion_password, ls_mensaje
Long 				ll_rc, ll_retorno
str_parametros	lstr_param
n_cst_encriptor  lnv_1

ls_user 				= gs_user
ls_password 		= sle_password.text
ls_nuevo_password = sle_nuevo_password.text
ls_verificacion_password = sle_verificacion_password.text
lnv_1.is_key = "SigreEsUnaFilosofiaDeVidaSigreEsUnaFilosofiaDeVida"

SELECT CLAVE					
	INTO :ls_clave
	FROM USUARIO
	WHERE COD_USR = :ls_user ;

IF SQLCA.SQLCode = 100 THEN
	MessageBox("Busqueda de Usuario", "Usuario no encontrado")
	return
END IF

IF SQLCA.SQLCode < 0 THEN
	MessageBox("Database Error", SQLCA.SQLErrText, Exclamation!)
	return
END IF

ls_clave = TRIM(ls_clave)
IF Lower(ls_clave) <> 'x' THEN ls_clave = lnv_1.of_desencriptarJR(ls_clave)
	
IF ls_clave <> ls_password THEN
	MessageBox("Password Error", "Contraseña anterior no es correcta", Exclamation!)
	sle_password.SetFocus()
	ll_rc = sle_password.SelectText(1, Len(ls_password))
	//destroy lnv_1
	return
end if

IF ls_nuevo_password <> ls_verificacion_password THEN
	MessageBox("Vericacion de Password", "Las nuevas contraseñas ingresadas no coinciden", Exclamation!)	
	sle_nuevo_password.SetFocus()
	ll_rc = sle_nuevo_password.SelectText(1, Len(sle_nuevo_password.text))
	//destroy lnv_1
	return
end if

// Verificacion de Longitud de Password
IF ii_long_min <> 0 AND ii_long_min > LEN(ls_nuevo_password) THEN
	MessageBox("Longitud Minima: " + String(ii_long_min), "Reintente", Exclamation!)
	sle_password.SetFocus()
	ll_rc = sle_password.SelectText(1, Len(ls_password))
	//destroy lnv_1
	return
END IF

ls_nuevo_password = lnv_1.of_encriptarJR(ls_nuevo_password)
UPDATE USUARIO 
	SET CLAVE = :ls_nuevo_password, 
		 fecha_ucc = sysdate
 WHERE COD_USR  = :ls_user ;

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al actualizar tabla usuario', ls_mensaje)
	//destroy lnv_1
	return
end if

//destroy lnv_1

COMMIT ;

MessageBox('Aviso', 'Cambio realizado satisfactoriamente', Information!)
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)




end event

type st_password from statictext within w_password
integer x = 110
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

type st_sistema from statictext within w_password
integer x = 91
integer y = 28
integer width = 1467
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16776960
boolean enabled = false
string text = "SISTEMA"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ln_2 from line within w_password
long linecolor = 16777215
integer linethickness = 1
integer beginx = 1554
integer beginy = 352
integer endx = 101
integer endy = 352
end type

type ln_3 from line within w_password
long linecolor = 16777215
integer linethickness = 1
integer beginx = 1664
integer beginy = 40
integer endx = 1664
integer endy = 784
end type

