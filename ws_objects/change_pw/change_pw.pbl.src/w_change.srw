$PBExportHeader$w_change.srw
forward
global type w_change from window
end type
type st_9 from statictext within w_change
end type
type sle_empresa from singlelineedit within w_change
end type
type sle_encriptado from singlelineedit within w_change
end type
type st_8 from statictext within w_change
end type
type st_statusbar from statictext within w_change
end type
type st_7 from statictext within w_change
end type
type sle_servidor from singlelineedit within w_change
end type
type hpb_1 from hprogressbar within w_change
end type
type st_6 from statictext within w_change
end type
type lb_filelist from listbox within w_change
end type
type cb_browse from commandbutton within w_change
end type
type sle_directorio from singlelineedit within w_change
end type
type cbx_2 from checkbox within w_change
end type
type st_5 from statictext within w_change
end type
type sle_newpass2 from singlelineedit within w_change
end type
type sle_newpass1 from singlelineedit within w_change
end type
type sle_pass from singlelineedit within w_change
end type
type sle_user from singlelineedit within w_change
end type
type st_4 from statictext within w_change
end type
type st_3 from statictext within w_change
end type
type st_2 from statictext within w_change
end type
type st_1 from statictext within w_change
end type
type cbx_1 from checkbox within w_change
end type
type cb_1 from commandbutton within w_change
end type
type cb_aceptar from commandbutton within w_change
end type
type gb_1 from groupbox within w_change
end type
type gb_2 from groupbox within w_change
end type
end forward

global type w_change from window
integer width = 2107
integer height = 2160
boolean titlebar = true
string title = "Cambio de contraseña en Esquema (Oracle)"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_filtrar_files ( )
event ue_aceptar ( )
event type boolean ue_change_pass ( )
event ue_encrypt_inifiles ( )
st_9 st_9
sle_empresa sle_empresa
sle_encriptado sle_encriptado
st_8 st_8
st_statusbar st_statusbar
st_7 st_7
sle_servidor sle_servidor
hpb_1 hpb_1
st_6 st_6
lb_filelist lb_filelist
cb_browse cb_browse
sle_directorio sle_directorio
cbx_2 cbx_2
st_5 st_5
sle_newpass2 sle_newpass2
sle_newpass1 sle_newpass1
sle_pass sle_pass
sle_user sle_user
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cbx_1 cbx_1
cb_1 cb_1
cb_aceptar cb_aceptar
gb_1 gb_1
gb_2 gb_2
end type
global w_change w_change

event ue_filtrar_files();String ls_path

ls_path = sle_directorio.text

if trim(ls_path) = "" then return

if right(ls_path,1) = '\' then
	ls_path = mid(ls_path,1, len(ls_path) - 1) 
end if

lb_filelist.DirList(ls_path + "\*.ini", 0 + 1 + 2 + 4)
end event

event ue_aceptar();//Valido que ingrese el usuario
boolean lb_ret = true

if trim(sle_user.text) = "" then
	MessageBox("Aviso", "Debe ingresar el usuario")
	sle_user.setFocus( )
	return
end if

//Valido que ingrese el password
if trim(sle_pass.text) = "" then
	MessageBox("Aviso", "Debe ingresar el password")
	sle_pass.setFocus( )
	return
end if

//Valido que ingrese el server
if trim(sle_servidor.text) = "" then
	MessageBox("Aviso", "Debe ingresar el nombre del servidor")
	sle_servidor.setFocus( )
	return
end if

if cbx_1.checked then
	lb_ret = this.event ue_change_pass( )
end if

if cbx_2.checked and lb_ret then
	this.event ue_encrypt_inifiles( )
end if
end event

event type boolean ue_change_pass();// Profile work5_lc1
String ls_server, ls_user, ls_old_pass, ls_new_pass, ls_sql

if trim(sle_newpass1.text) = "" then
	MessageBox("Aviso", "Debe ingresar el nuevo password")
	sle_newpass1.setFocus( )
	return false
end if

if sle_newpass1.text <> sle_newpass2.text then
	MessageBox("Aviso", "Los password ingresados son diferentes")
	sle_newpass1.setFocus( )
	return false
end if

ls_server 	= sle_servidor.text
ls_user		= sle_user.text
ls_old_pass		= sle_pass.text
ls_new_pass		= sle_newpass1.text

SQLCA.DBMS = "O90 Oracle9i (9.0.1)"
SQLCA.LogPass = ls_old_pass
SQLCA.ServerName = ls_server
SQLCA.LogId = ls_user
SQLCA.AutoCommit = False

connect;

if SQLCA.SQLCode < 0 then
	MessageBox("Error en conexion DBCode:" + String(SQLCA.SQLDBCode), &
				SQLCA.SQLErrtext)
	return false
end if

st_statusbar.text = "Conexion realizada satisfactoriamente"

// cambio el password
ls_sql = 'ALTER USER ' + ls_user + ' IDENTIFIED BY "' &
				+ ls_new_pass + '"'

execute immediate :ls_sql;

if SQLCA.SQLCode < 0 then
	MessageBox("Error al momento de modificar el password DbCode" &
				+ String(SQLCA.SQLDBCode), SQLCA.SQLErrtext &
				+ "SQL DDL: " + ls_sql)
else
	st_statusbar.text = "Cambio realizado satisfactoriamente"		
end if

// Me desconecto
disconnect;

if SQLCA.SQLCode < 0 then
	MessageBox("Error en desconexion DBCode:" + String(SQLCA.SQLDBCode), &
				SQLCA.SQLErrtext)
	return false
end if

st_statusbar.text = "Desconexion realizada satisfactoriamente"
return true
end event

event ue_encrypt_inifiles();String 	ls_user, ls_pass, ls_path, ls_inifile, ls_empresa, &
			ls_pass_encrypt, ls_work, ls_esquema, ls_mensaje
integer 	li_i
n_cst_encriptor lnv_encriptor

ls_user = sle_user.text

if cbx_1.checked then
	ls_pass = sle_newpass1.text
else
	ls_pass = sle_pass.text
end if

ls_path = sle_directorio.text
ls_empresa = sle_empresa.text

lnv_encriptor = create n_cst_encriptor
lnv_encriptor.is_key 	= "ProfileString(ls_inifilePasswordgs_empresa)"

ls_pass_encrypt = lnv_encriptor.of_encriptar( ls_pass )

sle_encriptado.text = ls_pass_encrypt

if right(ls_path, 1) = '\' then
	ls_path = mid(ls_path, 1, len(ls_path) - 1)
end if

hpb_1.Maxposition = lb_filelist.totalitems( )
hpb_1.visible = true

ls_mensaje = ''
for li_i = 1 to lb_filelist.TotalItems( )
	hpb_1.position = li_i
	ls_inifile = ls_path + '\' + lb_filelist.text( li_i )
	st_statusbar.text = 'Inifile: ' + ls_inifile
	ls_esquema    	= ProfileString (ls_inifile, "Esquema", ls_empresa, "")
	
	if ls_esquema = ls_user then
		//is_password   	= ProfileString (ls_inifile, "Password", gs_empresa, "")
		//ProfileString (ls_inifile, "Varios", "pw_encrypt", "0")
		setProfileString(ls_inifile, "Password", ls_empresa, ls_pass_encrypt)
		setProfileString(ls_inifile, "PW_ENCRYPT", ls_empresa, "1")
	else
		ls_mensaje += "IniFile: " + ls_inifile + " " + &
					   + "esquema: " + ls_esquema + " " + &
					   + "empresa: " + ls_empresa + " " + &
					   + "Password: " + ls_pass_encrypt + char(13)
	end if
	
next

if len(ls_mensaje) > 0 then
	MessageBox('Error', ls_mensaje)
end if

hpb_1.visible = false
end event

on w_change.create
this.st_9=create st_9
this.sle_empresa=create sle_empresa
this.sle_encriptado=create sle_encriptado
this.st_8=create st_8
this.st_statusbar=create st_statusbar
this.st_7=create st_7
this.sle_servidor=create sle_servidor
this.hpb_1=create hpb_1
this.st_6=create st_6
this.lb_filelist=create lb_filelist
this.cb_browse=create cb_browse
this.sle_directorio=create sle_directorio
this.cbx_2=create cbx_2
this.st_5=create st_5
this.sle_newpass2=create sle_newpass2
this.sle_newpass1=create sle_newpass1
this.sle_pass=create sle_pass
this.sle_user=create sle_user
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_9,&
this.sle_empresa,&
this.sle_encriptado,&
this.st_8,&
this.st_statusbar,&
this.st_7,&
this.sle_servidor,&
this.hpb_1,&
this.st_6,&
this.lb_filelist,&
this.cb_browse,&
this.sle_directorio,&
this.cbx_2,&
this.st_5,&
this.sle_newpass2,&
this.sle_newpass1,&
this.sle_pass,&
this.sle_user,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cbx_1,&
this.cb_1,&
this.cb_aceptar,&
this.gb_1,&
this.gb_2}
end on

on w_change.destroy
destroy(this.st_9)
destroy(this.sle_empresa)
destroy(this.sle_encriptado)
destroy(this.st_8)
destroy(this.st_statusbar)
destroy(this.st_7)
destroy(this.sle_servidor)
destroy(this.hpb_1)
destroy(this.st_6)
destroy(this.lb_filelist)
destroy(this.cb_browse)
destroy(this.sle_directorio)
destroy(this.cbx_2)
destroy(this.st_5)
destroy(this.sle_newpass2)
destroy(this.sle_newpass1)
destroy(this.sle_pass)
destroy(this.sle_user)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.cb_aceptar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;this.event ue_filtrar_files( )
end event

type st_9 from statictext within w_change
integer x = 41
integer y = 452
integer width = 512
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Empresa:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_empresa from singlelineedit within w_change
integer x = 622
integer y = 448
integer width = 1152
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_encriptado from singlelineedit within w_change
event ue_keydown pbm_keydown
integer x = 622
integer y = 1096
integer width = 1152
integer height = 84
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 268435456
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;parent.event ue_filtrar_files( )
end event

type st_8 from statictext within w_change
integer x = 32
integer y = 1104
integer width = 512
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Encriptado"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_statusbar from statictext within w_change
integer y = 1992
integer width = 2098
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_7 from statictext within w_change
integer x = 41
integer y = 352
integer width = 512
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Servidor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_servidor from singlelineedit within w_change
integer x = 622
integer y = 348
integer width = 1152
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type hpb_1 from hprogressbar within w_change
boolean visible = false
integer x = 535
integer y = 1180
integer width = 1541
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 2
end type

type st_6 from statictext within w_change
integer x = 18
integer y = 1184
integer width = 512
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Listado de IniFiles:"
boolean focusrectangle = false
end type

type lb_filelist from listbox within w_change
integer x = 5
integer y = 1264
integer width = 2057
integer height = 544
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type cb_browse from commandbutton within w_change
integer x = 1783
integer y = 980
integer width = 169
integer height = 104
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_path = getCurrentDirectory()
integer li_result

li_result = GetFolder( "Directorio de los IniFiles", ls_path )

// puts the user-selected path in a SingleLineEdit box.
sle_directorio.text = ls_path

parent.event ue_filtrar_files( )
end event

type sle_directorio from singlelineedit within w_change
event ue_keydown pbm_keydown
integer x = 622
integer y = 992
integer width = 1152
integer height = 84
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "i:\pb_exe"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;parent.event ue_filtrar_files( )
end event

type cbx_2 from checkbox within w_change
integer x = 46
integer y = 900
integer width = 1079
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Encriptar la contraseña en los IniFiles"
boolean checked = true
end type

event clicked;if this.checked then
	sle_directorio.enabled = true
	cb_aceptar.enabled = true
	lb_filelist.enabled = true
else
	sle_directorio.enabled = false
	lb_filelist.enabled = false
	if cbx_1.checked then
		cb_aceptar.enabled = true
	else
		cb_aceptar.enabled = false
	end if
end if
end event

type st_5 from statictext within w_change
integer x = 32
integer y = 1000
integer width = 512
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Directorio"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_newpass2 from singlelineedit within w_change
integer x = 622
integer y = 648
integer width = 1152
integer height = 84
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_newpass1 from singlelineedit within w_change
integer x = 622
integer y = 548
integer width = 1152
integer height = 84
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_pass from singlelineedit within w_change
integer x = 622
integer y = 248
integer width = 1152
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_user from singlelineedit within w_change
integer x = 622
integer y = 148
integer width = 1152
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_change
integer x = 41
integer y = 656
integer width = 512
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Repetir contraseña"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_change
integer x = 41
integer y = 556
integer width = 512
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nueva Contraseña"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_change
integer x = 41
integer y = 252
integer width = 512
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contraseña:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_change
integer x = 41
integer y = 156
integer width = 512
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuario"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_change
integer x = 50
integer y = 72
integer width = 1033
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cambiar la contraseña del esquema"
boolean checked = true
end type

event clicked;if this.checked then
	sle_newpass1.enabled = true
	sle_newpass2.enabled = true
	cb_aceptar.enabled = true
else
	sle_newpass1.enabled = false
	sle_newpass2.enabled = false
	if cbx_2.checked then
		cb_aceptar.enabled = true
	else
		cb_aceptar.enabled = false
	end if
end if
end event

type cb_1 from commandbutton within w_change
integer x = 1061
integer y = 1856
integer width = 402
integer height = 112
integer taborder = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_aceptar from commandbutton within w_change
integer x = 590
integer y = 1856
integer width = 402
integer height = 112
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_aceptar( )
end event

type gb_1 from groupbox within w_change
integer width = 2080
integer height = 828
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contraseña a un esquema"
end type

type gb_2 from groupbox within w_change
integer y = 832
integer width = 2089
integer height = 988
integer taborder = 130
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Encriptar Contraseña en los Ini Files"
end type

