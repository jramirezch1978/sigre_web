$PBExportHeader$w_logon_ancst.srw
$PBExportComments$Ancestro para Logon
forward
global type w_logon_ancst from window
end type
type cbx_sesion from checkbox within w_logon_ancst
end type
type cb_cancel from commandbutton within w_logon_ancst
end type
type cb_ok from commandbutton within w_logon_ancst
end type
type sle_psswd_sys from singlelineedit within w_logon_ancst
end type
type st_psswd_sys from statictext within w_logon_ancst
end type
type st_user from statictext within w_logon_ancst
end type
type sle_user from singlelineedit within w_logon_ancst
end type
end forward

global type w_logon_ancst from window
integer x = 823
integer y = 360
integer width = 1765
integer height = 864
boolean titlebar = true
string title = "Logon"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
boolean center = true
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = toproll!
event ue_help_topic ( )
event ue_help_index ( )
event ue_logon ( )
cbx_sesion cbx_sesion
cb_cancel cb_cancel
cb_ok cb_ok
sle_psswd_sys sle_psswd_sys
st_psswd_sys st_psswd_sys
st_user st_user
sle_user sle_user
end type
global w_logon_ancst w_logon_ancst

type prototypes

end prototypes

type variables
Integer 	ii_help, ii_nro_intentos, ii_flag_login, ii_dias_cambio
String	is_flag_login, is_flag_cambio_clv
Boolean	ib_coneccion = False

n_cst_encriptor  	invo_encriptor
n_cst_wait			invo_wait
n_cst_utilitario	invo_util
n_cst_regkey		invo_regkey
n_cst_seguridad	invo_seguridad
	
end variables

forward prototypes
public function long of_param ()
public function boolean of_sesion_activa ()
end prototypes

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

event ue_logon();String 			ls_user, ls_clave
Long				ll_return
str_parametros	lstr_param

ls_user = lower(TRIM(sle_user.text))
IF LEN(ls_user) > 6 THEN ls_user = Left(ls_user, 6)
ls_clave = Trim(sle_psswd_sys.text)

//Asigno los datos
invo_Seguridad.invo_app = gnvo_app
invo_seguridad.iw_parent = this

ll_return = invo_seguridad.of_validar_credenciales(ls_user, ls_Clave)

IF ll_return = -1 THEN
	sle_user.SetFocus()
	sle_user.SelectText(1, Len(sle_user.text))
	return
END IF

IF ll_return = -2 THEN
	sle_psswd_sys.SetFocus()
	sle_psswd_sys.SelectText(1, Len(sle_psswd_sys.text))
	return
end if

//Si es necesario el cambio de la contraseña
IF invo_seguridad.ii_desde_ult_cambio >= 0 THEN
	IF is_flag_cambio_clv = '1' AND ii_dias_cambio <= invo_seguridad.ii_desde_ult_cambio THEN 
		Open(w_password_chg, THIS)
	END IF
END IF

//GRabo mi sesión directamente en el registro de Windows
if cbx_sesion.checked then
	of_sesion_activa()
end if

// Salida
lstr_param.b_Return = true
CloseWithReturn(THIS, lstr_param)


end event

public function long of_param ();String	ls_mensaje


SELECT NVL(FLAG_LOGIN,'0'), NVL(FLAG_CAMBIO_FORZOSO,'0'), NVL(DIAS_CAMBIO,0)
  INTO :is_flag_login, :is_flag_cambio_clv, :ii_dias_cambio
  FROM LOGINPARAM  
 WHERE RECKEY = '1' ;	
	
IF SQLCA.SQLCODE = 100 THEN
	MessageBox("Error", 'No se ha especificado parametros en LOGINPARAM', StopSign!)
	return -1
end if

IF SQLCA.SQLCODE < 0 THEN
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error", 'No se pudo leer LOGINPARAM, Mensaje: ' + ls_mensaje, StopSign!)
	return -1
end if

ii_flag_login = Integer(is_flag_login)


RETURN 0



end function

public function boolean of_sesion_activa ();str_sesion 	lstr_Sesion

try 
	
	lstr_Sesion.fecha 	= Date(gnvo_app.of_fecha_actual())
	lstr_sesion.codigo	= gs_user
	lstr_sesion.nombre	= invo_seguridad.is_nom_usuario
	lstr_sesion.clave		= invo_seguridad.is_xclavex
	
	invo_regkey.of_save_sesion(gs_empresa, lstr_sesion)
	
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Ha ocurrido una excepcion')
	return false
end try


end function

on w_logon_ancst.create
this.cbx_sesion=create cbx_sesion
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_psswd_sys=create sle_psswd_sys
this.st_psswd_sys=create st_psswd_sys
this.st_user=create st_user
this.sle_user=create sle_user
this.Control[]={this.cbx_sesion,&
this.cb_cancel,&
this.cb_ok,&
this.sle_psswd_sys,&
this.st_psswd_sys,&
this.st_user,&
this.sle_user}
end on

on w_logon_ancst.destroy
destroy(this.cbx_sesion)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_psswd_sys)
destroy(this.st_psswd_sys)
destroy(this.st_user)
destroy(this.sle_user)
end on

event open;String			ls_inifile, ls_pw_encrypt
Long				ll_rc

invo_wait = create n_cst_wait

try 

	if gnvo_app.of_get_parametro("ALWAYS_SESION_ACTIVA", "0") = "1" then
		cbx_sesion.checked = true
	else
		cbx_sesion.checked = false
	end if
	
	// Lectura de Parametros de Logon
	invo_wait.of_mensaje('Leyendo parametros del origen')
	ll_rc = of_param()
	
	if ll_rc = -1 then HALT CLOSE
			
catch ( Exception ex)
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage(), StopSign!)
	
finally
	invo_wait.of_close()
end try




	

end event

event close;destroy invo_wait
end event

type cbx_sesion from checkbox within w_logon_ancst
integer x = 987
integer y = 304
integer width = 667
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Mantener activa mi session"
end type

type cb_cancel from commandbutton within w_logon_ancst
integer x = 1390
integer y = 560
integer width = 279
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
DISCONNECT ;

HALT
end event

type cb_ok from commandbutton within w_logon_ancst
integer x = 919
integer y = 560
integer width = 247
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Ok"
boolean default = true
end type

event clicked;String	ls_mensaje

ii_nro_intentos ++
// Segun Parametros de Logon, controlar Nro de Intentos
IF ii_flag_login = 0 THEN
	PARENT.EVENT ue_logon()
ELSE
	IF ii_nro_intentos <= ii_flag_login THEN
		PARENT.EVENT ue_logon()
	ELSE
		// Bloquear Usuario
		UPDATE USUARIO
		   SET FLAG_ESTADO = '2'
		 WHERE COD_USR = :sle_user.text ;
		
		If SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al actualizar tabla USUARIO. Mensaje: ' + ls_mensaje, StopSign!)
			Disconnect;
			Halt
		end if
		
		COMMIT ; 
		
		// Mensaje al Operador 
		MessageBox('Error', 'Ha sobrepasado el # de Intentos Permitidos. Maximo permitidos: ' + string(ii_flag_login), StopSign!)
		Disconnect;
		Halt
	END IF
END IF



end event

type sle_psswd_sys from singlelineedit within w_logon_ancst
integer x = 1097
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

event modified;cb_ok.SetFocus()

end event

type st_psswd_sys from statictext within w_logon_ancst
integer x = 155
integer y = 192
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
boolean focusrectangle = false
end type

type st_user from statictext within w_logon_ancst
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
long backcolor = 16777215
boolean enabled = false
string text = "Usuario:"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_logon_ancst
integer x = 1102
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

event modified;sle_psswd_sys.SetFocus()
end event

