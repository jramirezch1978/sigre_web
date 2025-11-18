$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type p_logo from picture within w_login
end type
type sle_user from singlelineedit within w_login
end type
type st_user from statictext within w_login
end type
type st_psswd_sys from statictext within w_login
end type
type sle_password from singlelineedit within w_login
end type
type cb_ok from commandbutton within w_login
end type
type cb_cancel from commandbutton within w_login
end type
end forward

global type w_login from window
integer width = 2391
integer height = 712
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
event ue_logon ( )
p_logo p_logo
sle_user sle_user
st_user st_user
st_psswd_sys st_psswd_sys
sle_password sle_password
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_login w_login

type variables
Integer 	ii_nro_intentos, ii_flag_login
end variables

event ue_logon();String 			ls_password, ls_digitado, ls_basedato, ls_user, ls_flag_estado
String				ls_origen_alt, ls_flag_origen
Long 				ll_rc, ll_timeout
Integer			li_nivel_log_objeto_usr, li_nivel_log_objeto_sis, li_desde_ult_cambio, li_user
Date				ld_fecha_ucc
DateTime 		ldt_Today
str_parametros lstr_param

ls_user = lower(TRIM(sle_user.text))
//IF LEN(ls_user) > 6 THEN ls_user = Left(ls_user, 6)

SELECT usuario_id, trim(us.clave), us.flag_estado
	INTO :li_user, :ls_password, :ls_flag_estado
	FROM usuarios us
  WHERE us.cod_usr = :ls_user ;

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

if trim(Lower(ls_digitado)) = 'x' and trim(ls_password) = 'x' then
	//MessageBox('Aviso', 'El administrador del sistema le ha asignado ' &
	//				+ 'una contraseña temporal, debe cambiarla de inmediato para continuar trabajando...', Information!)
					
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

on w_login.create
this.p_logo=create p_logo
this.sle_user=create sle_user
this.st_user=create st_user
this.st_psswd_sys=create st_psswd_sys
this.sle_password=create sle_password
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.Control[]={this.p_logo,&
this.sle_user,&
this.st_user,&
this.st_psswd_sys,&
this.sle_password,&
this.cb_ok,&
this.cb_cancel}
end on

on w_login.destroy
destroy(this.p_logo)
destroy(this.sle_user)
destroy(this.st_user)
destroy(this.st_psswd_sys)
destroy(this.sle_password)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;//CENTRO LOGO
p_logo.x = (this.width/2)-(p_logo.width/2)
p_logo.y = (this.height/2)-(p_logo.height)

//CENTRAR DEMAS CONTROLES
st_user.y = p_logo.y + 748
st_user.x = p_logo.x
st_psswd_sys.y = p_logo.y + 860
st_psswd_sys.x = p_logo.x - 200

sle_user.y = p_logo.y + 748
sle_user.x = p_logo.x + 654
sle_password.y = p_logo.y + 860
sle_password.x = p_logo.x + 654

cb_ok.x = p_logo.x + 676
cb_ok.y = p_logo.y + 996

cb_cancel.x = p_logo.x + 976
cb_cancel.y = p_logo.y + 996
end event

type p_logo from picture within w_login
integer width = 805
integer height = 496
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_login
integer x = 1737
integer y = 248
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

event modified;sle_password.SetFocus()
end event

type st_user from statictext within w_login
integer x = 1289
integer y = 256
integer width = 398
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "Usuario:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_psswd_sys from statictext within w_login
integer x = 937
integer y = 380
integer width = 750
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "Contraseña Sistema:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_password from singlelineedit within w_login
integer x = 1733
integer y = 368
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

event modified;//IF is_control_db = '0' THEN
//	cb_ok.SetFocus()
//ELSE
//	sle_psswd_db.SetFocus()
//END IF
//
end event

type cb_ok from commandbutton within w_login
integer x = 1408
integer y = 520
integer width = 247
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Ok"
boolean default = true
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

type cb_cancel from commandbutton within w_login
integer x = 1879
integer y = 520
integer width = 279
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//DISCONNECT ;
//
//HALTa

close(w_login)
end event

