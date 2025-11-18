$PBExportHeader$w_password.srw
$PBExportComments$modificacion de password
forward
global type w_password from window
end type
type ole_skin from olecustomcontrol within w_password
end type
type pb_ok_db from u_pb_aceptar within w_password
end type
type pb_cancel from u_pb_cancelar within w_password
end type
type pb_ok from u_pb_aceptar within w_password
end type
type st_database from statictext within w_password
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
integer height = 976
boolean titlebar = true
string title = "Cambio de Password"
boolean controlmenu = true
long backcolor = 67108864
boolean center = true
event ue_help_topic ( )
event ue_help_index ( )
ole_skin ole_skin
pb_ok_db pb_ok_db
pb_cancel pb_cancel
pb_ok pb_ok
st_database st_database
sle_nuevo_password_db sle_nuevo_password_db
st_4 st_4
st_3 st_3
sle_verificacion_password_db sle_verificacion_password_db
sle_verificacion_password sle_verificacion_password
st_2 st_2
st_1 st_1
sle_nuevo_password sle_nuevo_password
sle_password sle_password
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

forward prototypes
public subroutine of_activa_skin ()
end prototypes

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
end event

public subroutine of_activa_skin ();String ls_mensaje

IF LEN(Trim(gnvo_app.is_skin)) > 0 and gnvo_app.ib_skin THEN
	Long hWnd
	hWnd=Handle(W_main)
	IF FileExists(gnvo_app.is_skin) then
		ole_skin.object.LoadSkin(gnvo_app.is_skin)
		OLE_Skin.object.ApplySkin (hWnd)
	end if
END IF
end subroutine

on w_password.create
this.ole_skin=create ole_skin
this.pb_ok_db=create pb_ok_db
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.st_database=create st_database
this.sle_nuevo_password_db=create sle_nuevo_password_db
this.st_4=create st_4
this.st_3=create st_3
this.sle_verificacion_password_db=create sle_verificacion_password_db
this.sle_verificacion_password=create sle_verificacion_password
this.st_2=create st_2
this.st_1=create st_1
this.sle_nuevo_password=create sle_nuevo_password
this.sle_password=create sle_password
this.st_password=create st_password
this.st_sistema=create st_sistema
this.ln_2=create ln_2
this.ln_3=create ln_3
this.Control[]={this.ole_skin,&
this.pb_ok_db,&
this.pb_cancel,&
this.pb_ok,&
this.st_database,&
this.sle_nuevo_password_db,&
this.st_4,&
this.st_3,&
this.sle_verificacion_password_db,&
this.sle_verificacion_password,&
this.st_2,&
this.st_1,&
this.sle_nuevo_password,&
this.sle_password,&
this.st_password,&
this.st_sistema,&
this.ln_2,&
this.ln_3}
end on

on w_password.destroy
destroy(this.ole_skin)
destroy(this.pb_ok_db)
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.st_database)
destroy(this.sle_nuevo_password_db)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_verificacion_password_db)
destroy(this.sle_verificacion_password)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_nuevo_password)
destroy(this.sle_password)
destroy(this.st_password)
destroy(this.st_sistema)
destroy(this.ln_2)
destroy(this.ln_3)
end on

event open;
// ii_help = 101           // help topic


IF gnvo_app.ii_control_db = 0 THEN 	
	THIS.Width = 1637
	sle_nuevo_password_db.enabled = false
	sle_verificacion_password_db.enabled = false
	pb_ok_db.enabled = false
end if

//Aplico los skin
if gnvo_app.ib_skin then
	this.of_activa_skin( )
end if
end event

type ole_skin from olecustomcontrol within w_password
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
integer x = 869
integer y = 708
integer width = 146
integer height = 128
integer taborder = 70
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_password.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type pb_ok_db from u_pb_aceptar within w_password
integer x = 1774
integer y = 676
integer taborder = 60
boolean originalsize = false
end type

event clicked;call super::clicked;String  	ls_clave, ls_user, ls_password, ls_nuevo_password
String   ls_verificacion_password, ls_cmd
Long 		ll_rc

ls_user = gnvo_app.is_user
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

type pb_cancel from u_pb_cancelar within w_password
integer x = 1129
integer y = 676
integer taborder = 70
boolean originalsize = false
end type

event clicked;call super::clicked;Close(Parent)
end event

type pb_ok from u_pb_aceptar within w_password
integer x = 133
integer y = 676
integer taborder = 60
boolean originalsize = false
end type

event clicked;call super::clicked;String  	ls_clave, ls_user, ls_password, ls_nuevo_password, ls_verificacion_password
Long 		ll_rc, ll_retorno
str_parametros lstr_param

n_cst_encriptor  lnv_1
lnv_1 						 = CREATE n_cst_encriptor
ls_user 						 = gnvo_app.is_user
ls_password 				 = sle_password.text
ls_nuevo_password 		 = sle_nuevo_password.text
ls_verificacion_password = sle_verificacion_password.text
lnv_1.is_key 				 = "ProfileString(ls_inifile,Password,gs_empresa)"

if gnvo_app.ib_new_struct then
	SELECT CLAVE					
		INTO :ls_clave
		FROM MAE_USUARIO
		WHERE COD_USR = :ls_user ;
else
	SELECT USR_CLAVE					
		INTO :ls_clave
		FROM USUARIO
		WHERE COD_USR = :ls_user ;
end if 

ls_clave = TRIM(ls_clave)
IF Lower(ls_clave) <> 'x' THEN ls_clave = lnv_1.of_desencriptar(ls_clave)
	
IF SQLCA.SQLCode = 100 THEN
	MessageBox("Busqueda de Usuario", "Usuario no encontrado")
	GOTO FIN
END IF

IF SQLCA.SQLCode > 0 THEN
	MessageBox("Database Error", SQLCA.SQLErrText, Exclamation!)
	HALT
END IF

IF ls_clave <> ls_password THEN
	MessageBox("Password Error", "contraseña antigua incorrecta, Reintente", Exclamation!)
	sle_password.SetFocus()
	ll_rc = sle_password.SelectText(1, Len(ls_password))
ELSE
	IF ls_nuevo_password <> ls_verificacion_password THEN
		MessageBox("Vericacion de Password", "Verificacion Errada", Exclamation!)	
		sle_nuevo_password.SetFocus()
		ll_rc = sle_nuevo_password.SelectText(1, Len(sle_nuevo_password.text))
	ELSE
		// Verificacion de Longitud de Password
		IF ii_long_min <>0 AND ii_long_min > LEN(ls_nuevo_password) THEN
			MessageBox("Error en longitud de clave", "Longitud Minima: " + String(ii_long_min) + ", Reintente", Exclamation!)
			sle_password.SetFocus()
			ll_rc = sle_password.SelectText(1, Len(ls_password))
		   GOTO FIN
		END IF
		ls_nuevo_password = lnv_1.of_encriptar(ls_nuevo_password)
		if gnvo_app.ib_new_struct then
			UPDATE MAE_USUARIO 
				SET CLAVE = :ls_nuevo_password
			 WHERE COD_USR  = :ls_user ;
		else
			UPDATE USUARIO 
				SET USR_CLAVE = :ls_nuevo_password
			 WHERE COD_USR  = :ls_user ;
		end if
		
		IF SQLCA.SQLNRows > 0 THEN
			COMMIT ;
			Close(parent)
		ELSE
			Rollback ;
		END IF
	END IF
END IF

FIN:

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
long backcolor = 67108864
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
long backcolor = 67108864
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
long backcolor = 67108864
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
long backcolor = 67108864
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
long backcolor = 67108864
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


Start of PowerBuilder Binary Data Section : Do NOT Edit
00w_password.bin 
2900000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000005506988001cade8600000003000004800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000021c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000030944d16c4389d0f485a02a98b39e5a59000000005506988001cade865506988001cade86000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000090000021c000000000000000100000002000000030000000400000005000000060000000700000008fffffffe0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
28ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d0073006200720074006100540000006700000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d007300620072007400610054000000670000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10w_password.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
