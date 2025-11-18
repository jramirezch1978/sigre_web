$PBExportHeader$w_password_chg.srw
forward
global type w_password_chg from window
end type
type pb_1 from picturebutton within w_password_chg
end type
type sle_verificacion_password from singlelineedit within w_password_chg
end type
type st_2 from statictext within w_password_chg
end type
type st_1 from statictext within w_password_chg
end type
type sle_nuevo_password from singlelineedit within w_password_chg
end type
type sle_password from singlelineedit within w_password_chg
end type
type pb_ok from picturebutton within w_password_chg
end type
type st_password from statictext within w_password_chg
end type
type st_sistema from statictext within w_password_chg
end type
type p_1 from picture within w_password_chg
end type
type gb_1 from groupbox within w_password_chg
end type
type ln_2 from line within w_password_chg
end type
end forward

global type w_password_chg from window
integer width = 2505
integer height = 908
boolean titlebar = true
string title = "Cambio de contraseña"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
event ue_cambio ( )
pb_1 pb_1
sle_verificacion_password sle_verificacion_password
st_2 st_2
st_1 st_1
sle_nuevo_password sle_nuevo_password
sle_password sle_password
pb_ok pb_ok
st_password st_password
st_sistema st_sistema
p_1 p_1
gb_1 gb_1
ln_2 ln_2
end type
global w_password_chg w_password_chg

type variables
Integer	ii_help, ii_dias_cambio_clv, ii_long_min
end variables

event ue_cambio();String  			ls_clave, ls_user, ls_password, ls_nuevo_password, &
					ls_verificacion_password, ls_mensaje
Long 				ll_rc, ll_retorno
str_parametros	lstr_param
n_cst_encriptor  lnv_1

//lnv_1 				= CREATE n_cst_encriptor
ls_user 				= gs_user
ls_password 		= sle_password.text
ls_nuevo_password = sle_nuevo_password.text
ls_verificacion_password = sle_verificacion_password.text
lnv_1.is_key = "SigreEsUnaFilosofiaDeVidaSigreEsUnaFilosofiaDeVida"

SELECT CLAVE					
	INTO :ls_clave
	FROM USUARIOS
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
	return
end if

IF ls_nuevo_password <> ls_verificacion_password THEN
	MessageBox("Vericacion de Password", "Las nuevas contraseñas ingresadas no coinciden", Exclamation!)	
	sle_nuevo_password.SetFocus()
	ll_rc = sle_nuevo_password.SelectText(1, Len(sle_nuevo_password.text))
	return
end if

// Verificacion de Longitud de Password
IF ii_long_min <> 0 AND ii_long_min > LEN(ls_nuevo_password) THEN
	MessageBox("Longitud Minima: " + String(ii_long_min), "Reintente", Exclamation!)
	sle_password.SetFocus()
	ll_rc = sle_password.SelectText(1, Len(ls_password))
	return
END IF

ls_nuevo_password = lnv_1.of_encriptarJR(ls_nuevo_password)
UPDATE USUARIOS
	SET CLAVE = :ls_nuevo_password
 WHERE COD_USR  = :ls_user ;

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al actualizar tabla usuario', ls_mensaje)
	return
end if
	MessageBox('Correcto', " Cambio realizado correctamente", Exclamation!)
COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(this, lstr_param)

end event

on w_password_chg.create
this.pb_1=create pb_1
this.sle_verificacion_password=create sle_verificacion_password
this.st_2=create st_2
this.st_1=create st_1
this.sle_nuevo_password=create sle_nuevo_password
this.sle_password=create sle_password
this.pb_ok=create pb_ok
this.st_password=create st_password
this.st_sistema=create st_sistema
this.p_1=create p_1
this.gb_1=create gb_1
this.ln_2=create ln_2
this.Control[]={this.pb_1,&
this.sle_verificacion_password,&
this.st_2,&
this.st_1,&
this.sle_nuevo_password,&
this.sle_password,&
this.pb_ok,&
this.st_password,&
this.st_sistema,&
this.p_1,&
this.gb_1,&
this.ln_2}
end on

on w_password_chg.destroy
destroy(this.pb_1)
destroy(this.sle_verificacion_password)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nuevo_password)
destroy(this.sle_password)
destroy(this.pb_ok)
destroy(this.st_password)
destroy(this.st_sistema)
destroy(this.p_1)
destroy(this.gb_1)
destroy(this.ln_2)
end on

type pb_1 from picturebutton within w_password_chg
integer x = 1838
integer y = 640
integer width = 329
integer height = 144
integer taborder = 50
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "Cancelar"
boolean cancel = true
vtextalign vtextalign = vcenter!
long backcolor = 67108864
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type sle_verificacion_password from singlelineedit within w_password_chg
integer x = 1874
integer y = 460
integer width = 558
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_password_chg
integer x = 983
integer y = 468
integer width = 827
integer height = 76
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long backcolor = 16777215
boolean enabled = false
string text = "Verificacion Password:"
alignment alignment = right!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type st_1 from statictext within w_password_chg
integer x = 983
integer y = 332
integer width = 827
integer height = 76
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long backcolor = 16777215
boolean enabled = false
string text = "Nuevo Password:"
alignment alignment = right!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type sle_nuevo_password from singlelineedit within w_password_chg
integer x = 1874
integer y = 324
integer width = 558
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_password from singlelineedit within w_password_chg
integer x = 1874
integer y = 188
integer width = 558
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type pb_ok from picturebutton within w_password_chg
event ue_cambio ( )
integer x = 1371
integer y = 640
integer width = 361
integer height = 136
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "Ok"
vtextalign vtextalign = vcenter!
long backcolor = 67108864
end type

event ue_cambio();parent.event ue_cambio( )
end event

event clicked;string ls_new_psw
string ls_Hash
//sle_nuevo_password, sle_verificacion_password
IF(trim(sle_nuevo_password.text)=trim(sle_verificacion_password.text)) THEN
	ls_new_psw = trim(sle_nuevo_password.text)
	ls_Hash = gnvo_enc.of_encriptar(ls_new_psw)
ELSE
	MessageBox("Error", "Claves no coinciden, por favor verifique", Exclamation!)
END IF
EVENT ue_cambio()
end event

type st_password from statictext within w_password_chg
integer x = 983
integer y = 196
integer width = 827
integer height = 76
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long backcolor = 16777215
boolean enabled = false
string text = "Password Actual:"
alignment alignment = right!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type st_sistema from statictext within w_password_chg
integer x = 64
integer y = 56
integer width = 2363
integer height = 92
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long backcolor = 16777215
boolean enabled = false
string text = "Cambio de Contraseña"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type p_1 from picture within w_password_chg
integer x = 78
integer y = 148
integer width = 896
integer height = 436
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_password_chg
integer width = 2464
integer height = 796
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
end type

type ln_2 from line within w_password_chg
integer linethickness = 9
integer beginx = 2427
integer beginy = 284
integer endx = 974
integer endy = 284
end type

