$PBExportHeader$w_password_chg.srw
$PBExportComments$modificacion de password
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
type ln_2 from line within w_password_chg
end type
type p_1 from picture within w_password_chg
end type
end forward

global type w_password_chg from window
integer x = 823
integer y = 360
integer width = 2510
integer height = 900
boolean titlebar = true
string title = "Cambio de Password"
windowtype windowtype = response!
long backcolor = 16777215
event ue_help_topic ( )
event ue_help_index ( )
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
ln_2 ln_2
p_1 p_1
end type
global w_password_chg w_password_chg

type variables
Integer	ii_help, ii_dias_cambio_clv, ii_long_min
end variables

forward prototypes
public function long of_get_login_parametros ()
end prototypes

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

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
UPDATE USUARIO 
	SET CLAVE = :ls_nuevo_password, 
		 fecha_ucc = sysdate
 WHERE COD_USR  = :ls_user ;

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al actualizar tabla usuario', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(this, lstr_param)



end event

public function long of_get_login_parametros ();Long		ll_rc = 0


SELECT NVL(DIAS_CAMBIO,0), NVL(LONGITUD_MIN,1)
  INTO :ii_dias_cambio_clv, :ii_long_min
  FROM LOGINPARAM  
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGINPARAM')
	ll_rc = -1
END IF

RETURN ll_rc

end function

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
this.ln_2=create ln_2
this.p_1=create p_1
this.Control[]={this.pb_1,&
this.sle_verificacion_password,&
this.st_2,&
this.st_1,&
this.sle_nuevo_password,&
this.sle_password,&
this.pb_ok,&
this.st_password,&
this.st_sistema,&
this.ln_2,&
this.p_1}
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
destroy(this.ln_2)
destroy(this.p_1)
end on

event open;Long	ll_rc

// ii_help = 101           // help topic
//IF gi_control_db = 0 THEN 	THIS.Width = 1637

// Lectura de Parametros de Logon
ll_rc = of_get_login_parametros()
end event

type pb_1 from picturebutton within w_password_chg
integer x = 1838
integer y = 636
integer width = 329
integer height = 144
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "Repita contraseña:"
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
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "Nueva contraseña:"
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
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_password from singlelineedit within w_password_chg
integer x = 1874
integer y = 128
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

type pb_ok from picturebutton within w_password_chg
integer x = 1371
integer y = 644
integer width = 361
integer height = 136
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ok"
vtextalign vtextalign = vcenter!
long backcolor = 67108864
end type

event clicked;PARENT.EVENT ue_cambio()
end event

type st_password from statictext within w_password_chg
integer x = 983
integer y = 136
integer width = 827
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "Contraseña actual:"
alignment alignment = right!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type st_sistema from statictext within w_password_chg
integer x = 960
integer width = 1527
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
string text = "Cambio de contraseña"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ln_2 from line within w_password_chg
integer linethickness = 9
integer beginx = 2427
integer beginy = 284
integer endx = 974
integer endy = 284
end type

type p_1 from picture within w_password_chg
integer width = 896
integer height = 436
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

