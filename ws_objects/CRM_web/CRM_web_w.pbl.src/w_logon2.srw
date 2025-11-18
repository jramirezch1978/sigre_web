$PBExportHeader$w_logon2.srw
forward
global type w_logon2 from window
end type
type st_mensaje from statictext within w_logon2
end type
type p_logo from picture within w_logon2
end type
type st_user from statictext within w_logon2
end type
type st_pass from statictext within w_logon2
end type
type sle_user from singlelineedit within w_logon2
end type
type sle_password from singlelineedit within w_logon2
end type
type cb_ingresar from commandbutton within w_logon2
end type
type st_leyenda from statictext within w_logon2
end type
end forward

global type w_logon2 from window
integer width = 3931
integer height = 1624
boolean titlebar = true
string title = "Sistema de Cotizacion Sytco"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
event doprocess ( )
event ue_logon ( )
st_mensaje st_mensaje
p_logo p_logo
st_user st_user
st_pass st_pass
sle_user sle_user
sle_password sle_password
cb_ingresar cb_ingresar
st_leyenda st_leyenda
end type
global w_logon2 w_logon2

type variables
Integer 	ii_nro_intentos, ii_flag_login
end variables

event ue_logon();String 			ls_password, ls_digitado, ls_basedato, ls_user, ls_flag_estado, ls_nivel
String				ls_origen_alt, ls_flag_origen
Long 				ll_rc, ll_timeout
Integer			li_nivel_log_objeto_usr, li_nivel_log_objeto_sis, li_desde_ult_cambio, li_user
Date				ld_fecha_ucc
DateTime 		ldt_Today
str_parametros lstr_param

ls_user = lower(TRIM(sle_user.text))
//IF LEN(ls_user) > 6 THEN ls_user = Left(ls_user, 6)

SELECT us.usuario_id, trim(us.clave), us.flag_estado, v.cod_tipo_usuario
	INTO :li_user, :ls_password, :ls_flag_estado, :ls_nivel
	FROM usuarios us, tipo_usuario v
  WHERE us.cod_tipo_usuario=v.cod_tipo_usuario and us.cod_usr = :ls_user ;

IF SQLCA.SQLCode = 100 THEN
	MessageBox("Busqueda de Usuario", "Usuario no existe, por favor verifique", Exclamation!)
	sle_user.SetFocus()
	ll_rc = sle_user.SelectText(1, Len(sle_user.text))
	return
END IF

IF SQLCA.SQLCode < 0 THEN
	MessageBox("Database Error", "Hubo un error al conectar la base de datos: " + SQLCA.SQLErrText, Exclamation!)
	HALT
END IF

IF ls_flag_estado <>'1' THEN
	MessageBox("Error", "Usuario existente, pero esta Desactivado; SQLCode " &
			+ string(SQLCA.SQLCode) + " Estado: " + ls_flag_estado)
	sle_user.SetFocus()
	ll_rc = sle_user.SelectText(1, Len(sle_user.text))
	return
END IF

ls_digitado = Trim(sle_password.text)

gs_user = ls_user
gi_user = li_user
gs_nivel = ls_nivel 

if trim(Lower(ls_digitado)) = 'x' and trim(ls_password) = 'x' then
	//MessageBox('Aviso', 'El administrador del sistema le ha asignado ' &
		//			+ 'una contraseña temporal, debe cambiarla de inmediato para continuar trabajando...', Information!)
					
	Open(w_password_chg)
	
	If Message.PowerObjectparm.ClassName( ) <> 'str_parametros' then
		MessageBox('Error', 'Parametro de retorno no esperado')
		HALT
	end if
	
	lstr_param = Message.PowerObjectparm
	
	if lstr_param.titulo = 'n' then
		MessageBox('Error', 'No puede iniciar el sistema hasta que haya cambiado su contraseña')
		sle_user.SetFocus()
		return
	end if
	
	sle_user.text = ''
	sle_password.text = ''
	sle_user.setFocus()
	
	return
	
end if
	
gnvo_enc.is_key 	= "SigreEsUnaFilosofiaDeVidaSigreEsUnaFilosofiaDeVida"
ls_password = gnvo_enc.of_desencriptarJR( ls_password)

IF ls_digitado <> ls_password THEN
	MessageBox("Password Error", "Error en la contraseña, por favor reintente nuevamente", Exclamation!)
	sle_password.text = ''
	sle_password.SetFocus()
	return
end if

lstr_param.b_return = true

CloseWithReturn(this, lstr_param)

end event

on w_logon2.create
this.st_mensaje=create st_mensaje
this.p_logo=create p_logo
this.st_user=create st_user
this.st_pass=create st_pass
this.sle_user=create sle_user
this.sle_password=create sle_password
this.cb_ingresar=create cb_ingresar
this.st_leyenda=create st_leyenda
this.Control[]={this.st_mensaje,&
this.p_logo,&
this.st_user,&
this.st_pass,&
this.sle_user,&
this.sle_password,&
this.cb_ingresar,&
this.st_leyenda}
end on

on w_logon2.destroy
destroy(this.st_mensaje)
destroy(this.p_logo)
destroy(this.st_user)
destroy(this.st_pass)
destroy(this.sle_user)
destroy(this.sle_password)
destroy(this.cb_ingresar)
destroy(this.st_leyenda)
end on

event open;//CENTRO LOGO
p_logo.x = (this.width/2)-(p_logo.width/2)
p_logo.y = (this.height/2)-(p_logo.height)

//CENTRAR DEMAS CONTROLES
st_user.y = p_logo.y + 748
st_user.x = p_logo.x
st_pass.y = p_logo.y + 860
st_pass.x = p_logo.x

sle_user.y = p_logo.y + 748
sle_user.x = p_logo.x + 654
sle_password.y = p_logo.y + 860
sle_password.x = p_logo.x + 654

cb_ingresar.x = p_logo.x + 976
cb_ingresar.y = p_logo.y + 996

st_leyenda.x = (this.width/2)-(st_leyenda.width/2)
st_leyenda.y = cb_ingresar.y + 600
end event

type st_mensaje from statictext within w_logon2
integer x = 558
integer y = 1128
integer width = 946
integer height = 80
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean italic = true
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type p_logo from picture within w_logon2
integer x = 567
integer y = 100
integer width = 1321
integer height = 700
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type st_user from statictext within w_logon2
integer x = 571
integer y = 848
integer width = 617
integer height = 88
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Codigo de Usuario"
boolean focusrectangle = false
end type

type st_pass from statictext within w_logon2
integer x = 562
integer y = 960
integer width = 613
integer height = 88
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Clave de Usuario"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_logon2
integer x = 1221
integer y = 848
integer width = 667
integer height = 88
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_password from singlelineedit within w_logon2
integer x = 1221
integer y = 960
integer width = 667
integer height = 88
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type cb_ingresar from commandbutton within w_logon2
integer x = 1545
integer y = 1096
integer width = 343
integer height = 140
integer taborder = 10
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "Ingresar"
end type

event clicked;ii_nro_intentos ++

// Segun Parametros de Logon, controlar Nro de Intentos
IF ii_flag_login = 0 THEN
	PARENT.EVENT ue_logon()
ELSE
	IF ii_nro_intentos <= ii_flag_login THEN
		PARENT.EVENT ue_logon()
	ELSE
		// Bloquear Usuario
		UPDATE USUARIOS
		   SET FLAG_ESTADO = '2'
		 WHERE COD_USR = :sle_user.text ;
		COMMIT ; 
		// Mensaje al Operador 
		MessageBox('Error', 'Ha sobrepasado el # de Intentos Permitidos')
		Disconnect;
		Halt
	END IF
END IF
end event

type st_leyenda from statictext within w_logon2
integer x = 622
integer y = 1460
integer width = 1627
integer height = 64
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean italic = true
long textcolor = 33554432
long backcolor = 16777215
string text = "Modulo de Cotizacion Web - Uso exclusivo SYTCO"
alignment alignment = center!
boolean focusrectangle = false
end type

