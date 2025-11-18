$PBExportHeader$w_logon_ancst.srw
$PBExportComments$Ancestro para Logon
forward
global type w_logon_ancst from window
end type
type ole_skin from olecustomcontrol within w_logon_ancst
end type
type pb_cancelar from u_pb_cancelar within w_logon_ancst
end type
type pb_ok from u_pb_aceptar within w_logon_ancst
end type
type p_logo from picture within w_logon_ancst
end type
type p_1 from picture within w_logon_ancst
end type
type st_psswd_db from statictext within w_logon_ancst
end type
type sle_psswd_db from singlelineedit within w_logon_ancst
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
integer width = 2208
integer height = 1408
boolean titlebar = true
string title = "Indentificarse para ingresar al sistema"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
event ue_help_topic ( )
event ue_help_index ( )
event ue_logon ( )
ole_skin ole_skin
pb_cancelar pb_cancelar
pb_ok pb_ok
p_logo p_logo
p_1 p_1
st_psswd_db st_psswd_db
sle_psswd_db sle_psswd_db
sle_psswd_sys sle_psswd_sys
st_psswd_sys st_psswd_sys
st_user st_user
sle_user sle_user
end type
global w_logon_ancst w_logon_ancst

type prototypes

end prototypes

type variables
Integer 	ii_help, ii_nro_intentos, ii_NRO_INTENTOS_LOGIN, ii_dias_cambio
String  	is_logon, is_control_db, is_basedatos, is_esquema
String  	is_password, is_dbms, is_dbparm
String	is_flag_cambio_clv
Boolean	ib_coneccion = False
n_cst_encriptor  invo_enc
n_cst_errorlogging invo_log
n_cst_tooltiptext ToolTip

end variables

forward prototypes
public function long of_get_login_parametros ()
public subroutine of_activa_skin ()
end prototypes

event ue_help_topic();ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index();ShowHelp(gnvo_app.is_help, Index!)
end event

event ue_logon();String 	ls_password, ls_digitado, ls_basedato, ls_user, &
			ls_flag_estado, ls_mensaje, ls_flag_origen_alt, ls_origen_alt
Long 		ll_rc, ll_timeout, ll_nroVeces
Integer	li_nivel_log_objeto_usr, li_nivel_log_objeto_sis, &
			li_desde_ult_cambio
Date		ld_fecha_ucc
str_parametros lstr_param

ls_user = TRIM(sle_user.text)

if gnvo_app.ib_new_struct then
	 SELECT clave, NVL(flag_estado, '0'), timeout, NRO_CLAVES_REPETIDAS, 
				nvl(nivel_log_objeto,0), nvl(fecha_ucc, SYSDATE)
		INTO :ls_password, :ls_flag_estado, :ll_timeout, :ll_nroVeces, 
				:li_nivel_log_objeto_usr, :ld_fecha_ucc
		FROM MAE_usuario
	  WHERE cod_usr = :ls_user ;
else
	 SELECT USR_CLAVE, NVL(flag_estado, '0'), timeout, NRO_CLAVES_REPETIDAS, 
				nvl(nivel_log_objeto,0), nvl(fecha_ucc, SYSDATE), 
				nvl(FLAG_ORIGEN, 'S'), origen_alt
		INTO :ls_password, :ls_flag_estado, :ll_timeout, :ll_nroVeces, 
				:li_nivel_log_objeto_usr, :ld_fecha_ucc, 
				:ls_flag_origen_alt, :ls_origen_alt
		FROM USUARIO
	  WHERE cod_usr = :ls_user ;
end if

IF SQLCA.SQLCode = 100 THEN
	ls_mensaje = "Usuario no existe, por favor verifique"
	invo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	sle_user.SetFocus()
	ll_rc = sle_user.SelectText(1, Len(sle_user.text))
	return
END IF

IF SQLCA.SQLCode <> 0 THEN
	ls_mensaje = gnvo_log.of_MensajeDB("Error de Base de datos, por favor verificar")
	invo_log.of_errorlog(ls_mensaje)
	MessageBox(gnvo_app.is_TitleMessageBox, ls_mensaje, Exclamation!)
	HALT CLOSE
END IF

IF ls_flag_estado <>'1' THEN
	ls_mensaje = gnvo_log.of_MensajeDB("Usuario existente, pero esta Desactivado")
	invo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog(ls_mensaje)
	sle_user.SetFocus()
	ll_rc = sle_user.SelectText(1, Len(sle_user.text))
	RETURN
END IF

ls_digitado = Trim(sle_psswd_sys.text)
ls_basedato = Trim(ls_password)
IF Lower(ls_basedato) <> 'x' THEN ls_basedato = invo_enc.of_desencriptar(ls_basedato)

IF Lower(ls_digitado) <> Lower(ls_basedato) THEN
	ls_mensaje = "Error en  ingreso de contraseña, por favor verifique"
	invo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	sle_psswd_sys.SetFocus()
	ll_rc = sle_psswd_sys.SelectText(1, Len(sle_psswd_sys.text))
	return
ELSE
	gnvo_app.is_user = ls_user
	
	// Cargo los datos del usuario
	gnvo_app.invo_usuario.of_load_usuario( ls_user)
	
	//Especifico el timeout
	idle(ll_timeout)  // timeout
	// leer indicador de Log Objeto
	SELECT nvl(nivel_log_objeto,0)
	  INTO :li_nivel_log_objeto_sis
	  FROM PAR_SISTEMA
	 WHERE reckey = '1' ;
	 
	// Determinar Si debe grabarse el log 
	IF li_nivel_log_objeto_sis = 0 OR li_nivel_log_objeto_sis < li_nivel_log_objeto_usr THEN 
		gnvo_app.ib_log_objeto = False
	ELSE
		gnvo_app.ib_log_objeto = True
	END IF
	
	// Segun Parametros de Logon, controlar Cambio de Password
	li_desde_ult_cambio = DaysAfter(ld_fecha_ucc, Date(f_fecha_actual(1)))
	
	IF li_desde_ult_cambio >= 0 THEN
		IF is_flag_cambio_clv = '1' AND ii_dias_cambio <= li_desde_ult_cambio THEN 
			// cambio de Clave
			Open(w_password_chg, THIS)
			if IsNull(Message.PowerObjectParm) or Not isValid(Message.powerobjectparm) then 
				ls_mensaje = "No puede ingresar hasta que haya modificado su password"
				gnvo_log.of_errorlog( ls_mensaje )
				gnvo_app.of_showmessagedialog( ls_mensaje )
				HALT CLOSE
			end if
			
			if Message.powerObjectparm.ClassNAme() <> 'str_parametros' then
				ls_mensaje = "Error, parametro devuelto no es del tipo str_parametros"
				gnvo_log.of_errorlog( ls_mensaje )
				gnvo_app.of_showmessagedialog( ls_mensaje )
				HALT CLOSE
			end if
			
			lstr_param = message.powerObjectParm
			
			if lstr_param.titulo = 'n' then
				ls_mensaje = "No puede ingresar hasta que haya modificado su password"
				gnvo_log.of_errorlog( ls_mensaje )
				gnvo_app.of_showmessagedialog( ls_mensaje )
				HALT CLOSE
			end if
			
		END IF
	END IF
	
	if gnvo_app.ib_new_struct = false then
		// Si es la antigua estructura entonces obtengo el origen del usuario
		if ls_flag_origen_alt = 'A' then
			gnvo_app.is_origen = ls_origen_alt
		end if
	end if
	
	// Salida
	if gnvo_app.is_origen = '' or IsNull(gnvo_app.is_origen) then
		ls_mensaje = "No ha especificado un código de Origen"
		gnvo_log.of_errorlog( ls_mensaje )
		gnvo_app.of_showmessagedialog( ls_mensaje )
		return
	end if
	
	CloseWithReturn(THIS, 1)
END IF
end event

public function long of_get_login_parametros ();Long		ll_rc = 0
String 	ls_mensaje


SELECT NVL(FLAG_CAMBIO_LOGIN,'0'), NVL(NRO_DIAS_CAMBIO_LOG,0), 
		NVL(NRO_INTENTOS_LOGIN, 0)
  INTO :is_flag_cambio_clv, :ii_dias_cambio, :ii_NRO_INTENTOS_LOGIN
  FROM PAR_SISTEMA  
 WHERE RECKEY = '1' ;	
	
IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = gnvo_log.of_MensajeDB('No se pudo leer PAR_SISTEMA')
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_ShowMessageDialog( ls_mensaje )
	ll_rc = -1
END IF


RETURN ll_rc



end function

public subroutine of_activa_skin ();String 		ls_mensaje
Long			ll_i
StaticText 	lst_1

IF LEN(Trim(gnvo_app.is_skin)) > 0 and gnvo_app.ib_skin THEN
	Long hWnd
	hWnd=Handle(W_main)
	IF FileExists(gnvo_app.is_skin) then
		ole_skin.object.LoadSkin(gnvo_app.is_skin)
		OLE_Skin.object.ApplySkin (hWnd)
		
		for ll_i = 1 to Upperbound(this.Control)
			if left(this.Control[ll_i].ClassName(),3) = "st_" then
				lst_1 = this.Control[ll_i]
				lst_1.backColor = this.backcolor
				this.Control[ll_i] = lst_1
			end if
		next
	end if
END IF
end subroutine

on w_logon_ancst.create
this.ole_skin=create ole_skin
this.pb_cancelar=create pb_cancelar
this.pb_ok=create pb_ok
this.p_logo=create p_logo
this.p_1=create p_1
this.st_psswd_db=create st_psswd_db
this.sle_psswd_db=create sle_psswd_db
this.sle_psswd_sys=create sle_psswd_sys
this.st_psswd_sys=create st_psswd_sys
this.st_user=create st_user
this.sle_user=create sle_user
this.Control[]={this.ole_skin,&
this.pb_cancelar,&
this.pb_ok,&
this.p_logo,&
this.p_1,&
this.st_psswd_db,&
this.sle_psswd_db,&
this.sle_psswd_sys,&
this.st_psswd_sys,&
this.st_user,&
this.sle_user}
end on

on w_logon_ancst.destroy
destroy(this.ole_skin)
destroy(this.pb_cancelar)
destroy(this.pb_ok)
destroy(this.p_logo)
destroy(this.p_1)
destroy(this.st_psswd_db)
destroy(this.sle_psswd_db)
destroy(this.sle_psswd_sys)
destroy(this.st_psswd_sys)
destroy(this.st_user)
destroy(this.sle_user)
end on

event open;String	ls_inifile, ls_pw_encrypt, ls_mensaje
Long		ll_rc
str_parametros lstr_param

//Aplico los skin
if gnvo_app.ib_skin then
	this.of_activa_skin( )
end if

if IsNull(Message.powerobjectparm) or not IsValid(Message.powerobjectparm) then
	MessageBox(gnvo_app.is_TitleMessageBox, "El parametro enviado es nulo o no es válido")
	return -1
end if

if Message.Powerobjectparm.Classname( ) <> 'str_parametros' then
	MessageBox(gnvo_app.is_TitleMessageBox, "El parametro no es del tipo str_parametros")
	return -1
end if

lstr_param = Message.PowerObjectparm

is_logon      	= String(lstr_param.i_test)
is_control_db 	= String(lstr_param.i_control_db)
ls_inifile    		= lstr_param.s_inifile

invo_enc = CREATE n_cst_encriptor
invo_log = CREATE n_cst_errorlogging

p_logo.picturename = gnvo_app.is_logo

// Parametros para Base de Datos
is_basedatos  	= ProfileString (ls_inifile, gnvo_app.is_sistema, "BaseDatos", "")
is_esquema    	= ProfileString (ls_inifile, gnvo_app.is_sistema, "Esquema", "")
is_password   	= ProfileString (ls_inifile, gnvo_app.is_sistema, "Password", "")
ls_pw_encrypt 	= ProfileString (ls_inifile, gnvo_app.is_sistema, "PW_ENCRYPT", "0")
invo_enc.is_key 	= "ProfileString(ls_inifilePasswordgs_empresa)"
is_dbms   		= ProfileString (ls_inifile, gnvo_app.is_sistema, "dbms", "")
is_dbparm 		= ProfileString (ls_inifile, gnvo_app.is_sistema, "dbparm", "")

gnvo_app.is_esquema = is_esquema
gnvo_app.is_lpp = ProfileString (ls_inifile, gnvo_app.is_sistema, "Lectura_Pagina", "N")
gnvo_app.is_db = is_basedatos
		
// En caso de que el password este encriptado entonces lo desencripto
if ls_pw_encrypt = '1' then
	is_password = invo_enc.of_desencriptar( is_password )
end if

IF is_logon = '0' THEN

	SQLCA.DBMS       	= is_dbms
	SQLCA.logid      	= is_esquema
	SQLCA.logpass    	= is_password
	SQLCA.servername 	= is_basedatos
	SQLCA.dbparm     	= is_dbparm
	
	CONNECT ;
	IF SQLCA.sqlcode <> 0 THEN
		ls_mensaje = gnvo_log.of_Mensajedb("Error al momento de realizar la conexión con la base de datos")
		invo_log.of_errorlog(ls_mensaje)
   		gnvo_app.of_ShowMessageDialog( ls_mensaje)
		
		DISCONNECT ;
		HALT CLOSE
	ELSE
		CloseWithReturn(THIS, 1)
	END IF
ELSE
	// SE desabilita Control Password de Base de datos
	IF is_control_db = '0' THEN
		st_psswd_db.Visible = False
		sle_psswd_db.Visible = False
	END IF
	// Conneccion a Base de Datos
	IF ib_coneccion = False THEN
		SQLCA.DBMS       = is_dbms
		SQLCA.logid      = is_esquema
		SQLCA.logpass    = is_password
		SQLCA.servername = is_basedatos
		SQLCA.dbparm     = is_dbparm
		IF is_control_db <> '0' THEN
			SQLCA.logid      = sle_user.text
			SQLCA.logpass    = sle_psswd_db.text
		END IF
		CONNECT ;
		IF SQLCA.sqlcode <> 0 THEN
			ls_mensaje = invo_log.of_Mensajedb("Error al momento de realizar la conexión con la base de datos")
			invo_log.of_errorlog(ls_mensaje)
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
   		sle_user.SetFocus()
			ll_rc = sle_user.SelectText(1, Len(sle_user.text))
			
			DISCONNECT ;
			HALT			
		ELSE
			ib_coneccion = TRUE
		END IF
	END IF
	// Lectura de Parametros de Logon
	ll_rc = of_get_login_parametros()
END IF


ToolTip.AddTool(sle_user,"Ingrese el nombre de usuario ",0)
ToolTip.AddTool(sle_psswd_sys,"Ingrese la clave de acceso ",0)



end event

event close;destroy invo_enc
destroy invo_log
end event

type ole_skin from olecustomcontrol within w_logon_ancst
event skinevent ( oleobject source,  string eventname )
event render ( oleobject source,  oleobject screenbuffer,  long positionx,  long positiony )
event skintimer ( oleobject source,  long sourcehwnd,  long passedtime )
event click ( oleobject source )
event dblclick ( oleobject source )
event mousedown ( oleobject source,  integer button,  long ocx_x,  long ocx_y )
event mouseup ( oleobject source,  integer button,  long ocx_x,  long ocx_y )
event mousein ( oleobject source )
event mouseout ( oleobject source )
event mousemove ( oleobject source,  long ocx_x,  long ocx_y )
event scroll ( oleobject source,  long newpos )
event scrolltrack ( oleobject source,  long newpos )
integer x = 1947
integer y = 872
integer width = 146
integer height = 128
integer taborder = 40
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_logon_ancst.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type pb_cancelar from u_pb_cancelar within w_logon_ancst
integer x = 1563
integer y = 1012
integer taborder = 70
end type

event clicked;call super::clicked;DISCONNECT ;

HALT
end event

type pb_ok from u_pb_aceptar within w_logon_ancst
integer x = 1061
integer y = 1016
integer taborder = 60
boolean originalsize = false
end type

event clicked;call super::clicked;String ls_mensaje
ii_nro_intentos ++

// Segun Parametros de Logon, controlar Nro de Intentos
IF ii_NRO_INTENTOS_LOGIN = 0 THEN
	PARENT.EVENT ue_logon()
ELSE
	IF ii_nro_intentos <= ii_NRO_INTENTOS_LOGIN THEN
		PARENT.EVENT ue_logon()
	ELSE
		// Bloquear Usuario
		if gnvo_app.ib_new_struct then
			UPDATE MAE_USUARIO
				SET FLAG_ESTADO = '2'
			WHERE COD_USR = :sle_user.text ;
		else
			UPDATE USUARIO
				SET FLAG_ESTADO = '2'
			WHERE COD_USR = :sle_user.text ;
		end if
		
		if SQLCA.SQLCode <> 0 then
			ls_mensaje = gnvo_log.of_mensajedb( "No se ha podido grabar el estado en MAE_USUARIO")
			ROLLBACK;
			gnvo_app.of_showMessageDialog(ls_mensaje)
			invo_log.of_errorlog(ls_mensaje)
			RETURN;
		end if
		
		COMMIT ; 
		// Mensaje al Operador 
		ls_mensaje = 'Ha sobrepasado el # de Intentos Permitidos, se ha bloqueado ' + &
					'al usuario: ' + sle_user.text
		invo_log.of_errorlog(ls_mensaje)
		gnvo_app.of_showmessagedialog( ls_mensaje)
		Halt Close
	END IF
END IF



end event

type p_logo from picture within w_logon_ancst
integer x = 1161
integer y = 28
integer width = 763
integer height = 376
boolean focusrectangle = false
end type

type p_1 from picture within w_logon_ancst
integer y = 4
integer width = 745
integer height = 1300
string picturename = "C:\SIGRE\resources\JPG\START.JPG"
boolean focusrectangle = false
end type

type st_psswd_db from statictext within w_logon_ancst
integer x = 763
integer y = 752
integer width = 626
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Contraseña DB:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_psswd_db from singlelineedit within w_logon_ancst
integer x = 1403
integer y = 744
integer width = 773
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

event modified;pb_ok.SetFocus()
end event

type sle_psswd_sys from singlelineedit within w_logon_ancst
integer x = 1403
integer y = 628
integer width = 773
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

event modified;IF is_control_db = '0' THEN
	pb_ok.SetFocus()
ELSE
	sle_psswd_db.SetFocus()
END IF

end event

type st_psswd_sys from statictext within w_logon_ancst
integer x = 763
integer y = 636
integer width = 626
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Contraseña:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user from statictext within w_logon_ancst
integer x = 763
integer y = 520
integer width = 626
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Usuario:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_logon_ancst
integer x = 1399
integer y = 512
integer width = 773
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


Start of PowerBuilder Binary Data Section : Do NOT Edit
04w_logon_ancst.bin 
2800000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000005bb94c4001cb108b00000003000004800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000021c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000030944d16c4389d0f485a02a98b39e5a59000000005bafaf5001cb108b5bb94c4001cb108b000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000090000021c000000000000000100000002000000030000000400000005000000060000000700000008fffffffe0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
28ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d0073006200720074006100540000006700000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d007300620072007400610054000000670000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14w_logon_ancst.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
