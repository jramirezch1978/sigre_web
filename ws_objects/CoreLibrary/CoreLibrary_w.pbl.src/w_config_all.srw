$PBExportHeader$w_config_all.srw
forward
global type w_config_all from w_abc
end type
type tab_1 from tab within w_config_all
end type
type tabpage_1 from userobject within tab_1
end type
type st_1 from statictext within tabpage_1
end type
type sle_server from singlelineedit within tabpage_1
end type
type cb_save from commandbutton within tabpage_1
end type
type sle_userid from singlelineedit within tabpage_1
end type
type st_2 from statictext within tabpage_1
end type
type st_3 from statictext within tabpage_1
end type
type sle_password from singlelineedit within tabpage_1
end type
type cbx_smtpauth from checkbox within tabpage_1
end type
type st_4 from statictext within tabpage_1
end type
type sle_port from singlelineedit within tabpage_1
end type
type cb_gmail from commandbutton within tabpage_1
end type
type rb_none from radiobutton within tabpage_1
end type
type rb_ssl from radiobutton within tabpage_1
end type
type rb_tls from radiobutton within tabpage_1
end type
type st_5 from statictext within tabpage_1
end type
type cb_o365 from commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_1 st_1
sle_server sle_server
cb_save cb_save
sle_userid sle_userid
st_2 st_2
st_3 st_3
sle_password sle_password
cbx_smtpauth cbx_smtpauth
st_4 st_4
sle_port sle_port
cb_gmail cb_gmail
rb_none rb_none
rb_ssl rb_ssl
rb_tls rb_tls
st_5 st_5
cb_o365 cb_o365
end type
type tabpage_2 from userobject within tab_1
end type
type st_12 from statictext within tabpage_2
end type
type sle_send_name from singlelineedit within tabpage_2
end type
type st_11 from statictext within tabpage_2
end type
type sle_subject from singlelineedit within tabpage_2
end type
type cb_send from commandbutton within tabpage_2
end type
type mle_body from multilineedit within tabpage_2
end type
type st_10 from statictext within tabpage_2
end type
type sle_from_name from singlelineedit within tabpage_2
end type
type sle_from_email from singlelineedit within tabpage_2
end type
type st_9 from statictext within tabpage_2
end type
type st_8 from statictext within tabpage_2
end type
type sle_send_email from singlelineedit within tabpage_2
end type
type st_6 from statictext within tabpage_2
end type
type cbx_sendhtml from checkbox within tabpage_2
end type
type lb_attachments from listbox within tabpage_2
end type
type st_7 from statictext within tabpage_2
end type
type cb_addfile from commandbutton within tabpage_2
end type
type cb_del from commandbutton within tabpage_2
end type
type cbx_logfile from checkbox within tabpage_2
end type
type cbx_debugviewer from checkbox within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_12 st_12
sle_send_name sle_send_name
st_11 st_11
sle_subject sle_subject
cb_send cb_send
mle_body mle_body
st_10 st_10
sle_from_name sle_from_name
sle_from_email sle_from_email
st_9 st_9
st_8 st_8
sle_send_email sle_send_email
st_6 st_6
cbx_sendhtml cbx_sendhtml
lb_attachments lb_attachments
st_7 st_7
cb_addfile cb_addfile
cb_del cb_del
cbx_logfile cbx_logfile
cbx_debugviewer cbx_debugviewer
end type
type tab_1 from tab within w_config_all
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_config_all from w_abc
integer width = 2994
integer height = 2196
string title = "Panel de Configuracio General"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
tab_1 tab_1
end type
global w_config_all w_config_all

type variables
n_cst_register 	invo_reg
n_cst_encriptor  	invo_encriptor
n_smtp				invo_smtp
n_cst_utilitario	invo_utilitario
end variables

forward prototypes
public subroutine of_set_datos ()
end prototypes

public subroutine of_set_datos ();
end subroutine

on w_config_all.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_config_all.destroy
call super::destroy
destroy(this.tab_1)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10
end event

event ue_open_pre;call super::ue_open_pre;//invo_encriptor 	= create n_cst_encriptor  


end event

event close;call super::close;//destroy invo_encriptor 


end event

type tab_1 from tab within w_config_all
integer width = 2857
integer height = 1988
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 2821
integer height = 1868
long backcolor = 79741120
string text = "STMP Setting"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_1 st_1
sle_server sle_server
cb_save cb_save
sle_userid sle_userid
st_2 st_2
st_3 st_3
sle_password sle_password
cbx_smtpauth cbx_smtpauth
st_4 st_4
sle_port sle_port
cb_gmail cb_gmail
rb_none rb_none
rb_ssl rb_ssl
rb_tls rb_tls
st_5 st_5
cb_o365 cb_o365
end type

on tabpage_1.create
this.st_1=create st_1
this.sle_server=create sle_server
this.cb_save=create cb_save
this.sle_userid=create sle_userid
this.st_2=create st_2
this.st_3=create st_3
this.sle_password=create sle_password
this.cbx_smtpauth=create cbx_smtpauth
this.st_4=create st_4
this.sle_port=create sle_port
this.cb_gmail=create cb_gmail
this.rb_none=create rb_none
this.rb_ssl=create rb_ssl
this.rb_tls=create rb_tls
this.st_5=create st_5
this.cb_o365=create cb_o365
this.Control[]={this.st_1,&
this.sle_server,&
this.cb_save,&
this.sle_userid,&
this.st_2,&
this.st_3,&
this.sle_password,&
this.cbx_smtpauth,&
this.st_4,&
this.sle_port,&
this.cb_gmail,&
this.rb_none,&
this.rb_ssl,&
this.rb_tls,&
this.st_5,&
this.cb_o365}
end on

on tabpage_1.destroy
destroy(this.st_1)
destroy(this.sle_server)
destroy(this.cb_save)
destroy(this.sle_userid)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_password)
destroy(this.cbx_smtpauth)
destroy(this.st_4)
destroy(this.sle_port)
destroy(this.cb_gmail)
destroy(this.rb_none)
destroy(this.rb_ssl)
destroy(this.rb_tls)
destroy(this.st_5)
destroy(this.cb_o365)
end on

event constructor;String ls_clave


try 
	
	ls_clave = gnvo_app.of_get_parametro("PasswordSMTP", "")
	
	if len(trim(ls_clave)) > 0 then
		ls_clave = invo_encriptor.of_desencriptarjr( ls_clave )
	end if
	

	sle_server.text   = gnvo_app.of_get_parametro("ServerSMTP", "smtp.gmail.com")
	sle_userid.text   = gnvo_app.of_get_parametro("UseridSMTP", "jramirez@npssac.com.pe")
	sle_password.text = ls_clave
	sle_port.text     = gnvo_app.of_get_parametro("PortSMTP", "465")
	
	If gnvo_app.of_get_parametro("AuthSMTP", "N") = "Y" Then
		cbx_smtpauth.checked = True
	Else
		cbx_smtpauth.checked = False
	End If
	
	rb_none.Checked = True
	If gnvo_app.of_get_parametro("EncryptSMTP", "None") = "SSL" Then
		rb_ssl.checked = True
	End If
	If gnvo_app.of_get_parametro("EncryptSMTP", "None") = "TLS" Then
		rb_tls.checked = True
	End If

catch ( Exception ex)
	MessageBox("Error", "Ha ocurrido una excepción, Mensaje de Error: " + ex.getMessage() + ", por favor verirque!", StopSign!)
end try

end event

type st_1 from statictext within tabpage_1
integer x = 37
integer y = 48
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "SMTP Server:"
boolean focusrectangle = false
end type

type sle_server from singlelineedit within tabpage_1
integer x = 366
integer y = 40
integer width = 846
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_save from commandbutton within tabpage_1
integer x = 2011
integer y = 1344
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;//invo_reg.of_setreg("Server",   sle_server.text)
//invo_reg.of_setreg("Userid",   sle_userid.text)
//invo_reg.of_setreg("Password", sle_password.text)
//invo_reg.of_setreg("Port",     sle_port.text)
//
//If cbx_smtpauth.checked Then
//	invo_reg.of_setreg("Auth", "Y")
//Else
//	invo_reg.of_setreg("Auth", "N")
//End If
//
//If rb_none.Checked Then
//	invo_reg.of_setreg("Encrypt", "None")
//End If
//If rb_ssl.Checked Then
//	invo_reg.of_setreg("Encrypt", "SSL")
//End If
//If rb_tls.Checked Then
//	invo_reg.of_setreg("Encrypt", "TLS")
//End If

String ls_clave

try 
	
	ls_clave = sle_password.text
	
	if len(trim(ls_clave)) > 0 then
		ls_clave = invo_encriptor.of_encriptarJR(ls_clave)
	end if
	
	gnvo_app.of_set_parametro( "ServerSMTP",   sle_server.text)
	gnvo_app.of_set_parametro("UseridSMTP",   sle_userid.text)
	gnvo_app.of_set_parametro("PasswordSMTP", ls_clave)
	gnvo_app.of_set_parametro("PortSMTP",     sle_port.text)
	
	If cbx_smtpauth.checked Then
		gnvo_app.of_set_parametro("AuthSMTP", "Y")
	Else
		gnvo_app.of_set_parametro("AuthSMTP", "N")
	End If
	
	If rb_none.Checked Then
		gnvo_app.of_set_parametro("EncryptSMTP", "None")
	End If
	If rb_ssl.Checked Then
		gnvo_app.of_set_parametro("EncryptSMTP", "SSL")
	End If
	If rb_tls.Checked Then
		gnvo_app.of_set_parametro("EncryptSMTP", "TLS")
	End If
	
	commit;
	
	f_mensaje("Datos de SMTP Config han sido grabados satisfactoriamente", "")

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción, Mensaje de Error: ' + ex.getMessage() + ', por favor verifique!', StopSign!)

end try


end event

type sle_userid from singlelineedit within tabpage_1
integer x = 366
integer y = 296
integer width = 846
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within tabpage_1
integer x = 37
integer y = 304
integer width = 206
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Userid:"
boolean focusrectangle = false
end type

type st_3 from statictext within tabpage_1
integer x = 37
integer y = 432
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password:"
boolean focusrectangle = false
end type

type sle_password from singlelineedit within tabpage_1
integer x = 366
integer y = 424
integer width = 846
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type cbx_smtpauth from checkbox within tabpage_1
integer x = 37
integer y = 576
integer width = 992
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "SMTP Server requires userid/password"
end type

type st_4 from statictext within tabpage_1
integer x = 37
integer y = 176
integer width = 151
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port:"
boolean focusrectangle = false
end type

type sle_port from singlelineedit within tabpage_1
integer x = 366
integer y = 168
integer width = 215
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_gmail from commandbutton within tabpage_1
integer x = 1280
integer y = 32
integer width = 699
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Click for GMail settings"
end type

event clicked;// set GMail properties
sle_server.text = "smtp.gmail.com"
sle_port.text = "465"
sle_userid.text = "myaddress@gmail.com"
sle_password.text = ""
cbx_smtpauth.checked = True
rb_ssl.checked = True

MessageBox("GMail Security", &
	"You must login to your GMail account and " + &
	"enable 'Access for less secure apps' before " + &
	"the application can connect.")

sle_userid.SetFocus()

end event

type rb_none from radiobutton within tabpage_1
integer x = 37
integer y = 800
integer width = 261
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "None"
end type

event clicked;sle_port.text = "25"

end event

type rb_ssl from radiobutton within tabpage_1
integer x = 329
integer y = 800
integer width = 261
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "SSL"
end type

event clicked;sle_port.text = "465"

end event

type rb_tls from radiobutton within tabpage_1
integer x = 622
integer y = 800
integer width = 261
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "TLS"
end type

event clicked;sle_port.text = "587"

end event

type st_5 from statictext within tabpage_1
integer x = 37
integer y = 708
integer width = 699
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "SMTP Server Encryption Type:"
boolean focusrectangle = false
end type

type cb_o365 from commandbutton within tabpage_1
integer x = 1280
integer y = 192
integer width = 699
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Click for Office365 settings"
end type

event clicked;// set Office365 properties
sle_server.text = "smtp.office365.com"
sle_port.text = "587"
sle_userid.text = "myaddress@mydomain.com"
sle_password.text = ""
cbx_smtpauth.checked = True
rb_tls.checked = True

sle_userid.SetFocus()

end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 2821
integer height = 1868
long backcolor = 79741120
string text = "Send Email"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_12 st_12
sle_send_name sle_send_name
st_11 st_11
sle_subject sle_subject
cb_send cb_send
mle_body mle_body
st_10 st_10
sle_from_name sle_from_name
sle_from_email sle_from_email
st_9 st_9
st_8 st_8
sle_send_email sle_send_email
st_6 st_6
cbx_sendhtml cbx_sendhtml
lb_attachments lb_attachments
st_7 st_7
cb_addfile cb_addfile
cb_del cb_del
cbx_logfile cbx_logfile
cbx_debugviewer cbx_debugviewer
end type

on tabpage_2.create
this.st_12=create st_12
this.sle_send_name=create sle_send_name
this.st_11=create st_11
this.sle_subject=create sle_subject
this.cb_send=create cb_send
this.mle_body=create mle_body
this.st_10=create st_10
this.sle_from_name=create sle_from_name
this.sle_from_email=create sle_from_email
this.st_9=create st_9
this.st_8=create st_8
this.sle_send_email=create sle_send_email
this.st_6=create st_6
this.cbx_sendhtml=create cbx_sendhtml
this.lb_attachments=create lb_attachments
this.st_7=create st_7
this.cb_addfile=create cb_addfile
this.cb_del=create cb_del
this.cbx_logfile=create cbx_logfile
this.cbx_debugviewer=create cbx_debugviewer
this.Control[]={this.st_12,&
this.sle_send_name,&
this.st_11,&
this.sle_subject,&
this.cb_send,&
this.mle_body,&
this.st_10,&
this.sle_from_name,&
this.sle_from_email,&
this.st_9,&
this.st_8,&
this.sle_send_email,&
this.st_6,&
this.cbx_sendhtml,&
this.lb_attachments,&
this.st_7,&
this.cb_addfile,&
this.cb_del,&
this.cbx_logfile,&
this.cbx_debugviewer}
end on

on tabpage_2.destroy
destroy(this.st_12)
destroy(this.sle_send_name)
destroy(this.st_11)
destroy(this.sle_subject)
destroy(this.cb_send)
destroy(this.mle_body)
destroy(this.st_10)
destroy(this.sle_from_name)
destroy(this.sle_from_email)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.sle_send_email)
destroy(this.st_6)
destroy(this.cbx_sendhtml)
destroy(this.lb_attachments)
destroy(this.st_7)
destroy(this.cb_addfile)
destroy(this.cb_del)
destroy(this.cbx_logfile)
destroy(this.cbx_debugviewer)
end on

event constructor;sle_send_name.text 	= invo_reg.of_getreg("SendName", "")
sle_send_email.text 	= invo_reg.of_getreg("SendEmail", "")
sle_from_name.text 	= invo_reg.of_getreg("FromName", "")
sle_from_email.text 	= invo_reg.of_getreg("FromEmail", "")
sle_subject.text 		= invo_reg.of_getreg("Subject", "")
mle_body.text 			= invo_reg.of_getreg("Body", "")

If invo_reg.of_getreg("SendHTML", "N") = "Y" Then
	cbx_sendhtml.checked = True
Else
	cbx_sendhtml.checked = False
End If

If invo_reg.of_getreg("LogFile", "N") = "Y" Then
	cbx_logfile.checked = True
Else
	cbx_logfile.checked = False
End If

If invo_reg.of_getreg("DebugViewer", "N") = "Y" Then
	cbx_debugviewer.checked = True
Else
	cbx_debugviewer.checked = False
End If

end event

event destructor;invo_reg.of_setreg("SendName", sle_send_name.text)
invo_reg.of_setreg("SendEmail", sle_send_email.text)
invo_reg.of_setreg("FromName", sle_from_name.text)
invo_reg.of_setreg("FromEmail", sle_from_email.text)
invo_reg.of_setreg("Subject", sle_subject.text)
invo_reg.of_setreg("Body", mle_body.text)

If cbx_sendhtml.checked Then
	invo_reg.of_setreg("SendHTML", "Y")
Else
	invo_reg.of_setreg("SendHTML", "N")
End If

If cbx_logfile.checked Then
	invo_reg.of_setreg("LogFile", "Y")
Else
	invo_reg.of_setreg("LogFile", "N")
End If

If cbx_debugviewer.checked Then
	invo_reg.of_setreg("DebugViewer", "Y")
Else
	invo_reg.of_setreg("DebugViewer", "N")
End If
end event

type st_12 from statictext within tabpage_2
integer x = 73
integer y = 48
integer width = 224
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "To Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_send_name from singlelineedit within tabpage_2
integer x = 329
integer y = 40
integer width = 846
integer height = 84
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within tabpage_2
integer x = 105
integer y = 304
integer width = 192
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Subject:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_subject from singlelineedit within tabpage_2
integer x = 329
integer y = 296
integer width = 2016
integer height = 84
integer taborder = 5
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_send from commandbutton within tabpage_2
integer x = 2011
integer y = 1344
integer width = 334
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
end type

event clicked;String 	ls_body, ls_server, ls_uid, ls_pwd
String 	ls_filename, ls_port, ls_encrypt, ls_errormsg
Integer 	li_idx, li_max
Boolean 	lb_html, lb_Return
UInt 		lui_port

try 
	SetPointer(HourGlass!)
	
	ls_server = gnvo_app.of_get_parametro("ServerSMTP", "")
	
	If ls_server = "" Then
		MessageBox("Edit Error", &
			"Debes Especificar un servidor SMTP para envío de email, por favor verifique en el tab SMTP Setting", StopSign!)
		Return
	End If
	
	If sle_send_email.text = "" Then
		
		MessageBox("Edit Error", &
			"Debe Especificar a quien enviarle el email. Por favor verifique!", StopSign!)
			
		sle_send_email.SetFocus()
		Return
	End If
	
	If sle_from_email.text = "" Then
		sle_from_email.SetFocus()
		MessageBox("Edit Error", &
			"From Email is a required field!", StopSign!)
		Return
	End If
	
	If sle_subject.text = "" Then
		sle_subject.SetFocus()
		MessageBox("Edit Error", &
			"Subject is a required field!", StopSign!)
		Return
	End If
	
	If mle_body.text = "" Then
		mle_body.SetFocus()
		MessageBox("Edit Error", &
			"Body is a required field!", StopSign!)
		Return
	End If
	
	If Not invo_smtp.of_ValidEmail(sle_from_email.text, ls_errormsg) Then
		sle_from_email.SetFocus()
		MessageBox("Edit Error", ls_errormsg, StopSign!)
		Return
	End If
	
	If Not invo_smtp.of_ValidEmail(sle_send_email.text, ls_errormsg) Then
		sle_send_email.SetFocus()
		MessageBox("Edit Error", ls_errormsg, StopSign!)
		Return
	End If
	
	If cbx_sendhtml.Checked Then
		ls_body  = "<html><body bgcolor='#FFFFFF' topmargin=8 leftmargin=8><h2>"
		ls_body += invo_utilitario.of_replaceall(mle_body.text, "~r~n", "<br>") + "</h2>"
		ls_body += "</body></html>"
		lb_html = True
	Else
		ls_body = mle_body.text
		lb_html = False
	End If
	
	lui_port = Long(gnvo_app.of_get_parametro("PortSMTP", "25"))
	
	// *** set email properties *********************
	invo_smtp.of_ResetAll()
	invo_smtp.of_SetPort(lui_port)
	invo_smtp.of_SetServer(ls_server)
	invo_smtp.of_SetLogFile(cbx_logfile.Checked, "smtp_logfile.log")
	invo_smtp.of_SetDebugViewer(cbx_debugviewer.Checked)
	invo_smtp.of_SetSubject(sle_subject.text)
	invo_smtp.of_SetBody(ls_body, lb_html)
	invo_smtp.of_SetFrom(sle_from_email.text, sle_from_name.text)
	invo_smtp.of_AddAddress(sle_send_email.text, sle_send_name.text)
	
	// *** set Userid/Password if required **********
	If gnvo_app.of_get_parametro("AuthSMTP", "N") = "Y" Then
		ls_uid = gnvo_app.of_get_parametro("UseridSMTP", "")
		ls_pwd = gnvo_app.of_get_parametro("PasswordSMTP", "")
		ls_pwd = invo_encriptor.of_desencriptarjr( ls_pwd )
		invo_smtp.of_SetLogin(ls_uid, ls_pwd)
	End If
	
	// *** add any attachments **********************
	li_max = lb_attachments.TotalItems()
	For li_idx = 1 To li_max
		ls_filename = lb_attachments.Text(li_idx)
		invo_smtp.of_AddAttachment(ls_filename)
	Next
	
	// *** send the message *************************
	ls_encrypt = gnvo_app.of_get_parametro("EncryptSMTP", "None")
	choose case ls_encrypt
		case "SSL"
			lb_Return = invo_smtp.of_SendSSLMail()
		case "TLS"
			lb_Return = invo_smtp.of_SendTLSMail()
		case else
			lb_Return = invo_smtp.of_SendMail()
	end choose
	
	If lb_Return Then
		MessageBox("Envío de Email", "Email enviado satisfactoriamente!", Information!)
	Else
		MessageBox("Error en Envío de Email", invo_smtp.of_GetLastError(), StopSign!)
	End If

catch ( Exception ex )
	MessageBox("Error", "Ha ocurrido una excepción, mensaje de error:" + ex.getMessage() + ", por favor verifique!", Information!)
end try

end event

type mle_body from multilineedit within tabpage_2
integer x = 329
integer y = 424
integer width = 2016
integer height = 444
integer taborder = 6
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within tabpage_2
integer x = 155
integer y = 432
integer width = 142
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Body:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_from_name from singlelineedit within tabpage_2
integer x = 329
integer y = 168
integer width = 846
integer height = 84
integer taborder = 3
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_from_email from singlelineedit within tabpage_2
integer x = 1499
integer y = 168
integer width = 846
integer height = 84
integer taborder = 4
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within tabpage_2
integer x = 18
integer y = 176
integer width = 279
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "From Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within tabpage_2
integer x = 1198
integer y = 176
integer width = 270
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "From Email:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_send_email from singlelineedit within tabpage_2
integer x = 1499
integer y = 40
integer width = 846
integer height = 84
integer taborder = 2
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within tabpage_2
integer x = 1257
integer y = 52
integer width = 210
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "To Email:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_sendhtml from checkbox within tabpage_2
integer x = 329
integer y = 1360
integer width = 443
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send as HTML"
end type

type lb_attachments from listbox within tabpage_2
integer x = 329
integer y = 992
integer width = 2016
integer height = 292
integer taborder = 9
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within tabpage_2
integer x = 329
integer y = 928
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Attachments:"
boolean focusrectangle = false
end type

type cb_addfile from commandbutton within tabpage_2
integer x = 37
integer y = 992
integer width = 261
integer height = 100
integer taborder = 7
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Add"
end type

event clicked;String ls_pathname, ls_filename, ls_filter
Integer li_rc

ls_filter = "All files,*.*"

li_rc = GetFileOpenName("Select File to Attach", &
		ls_pathname, ls_filename, "", ls_filter)

If li_rc = 1 Then
	lb_attachments.AddItem(ls_pathname)
End If

end event

type cb_del from commandbutton within tabpage_2
integer x = 37
integer y = 1120
integer width = 261
integer height = 100
integer taborder = 8
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;// delete attachment

Integer li_row

li_row = lb_attachments.SelectedIndex()
If li_row > 0 Then
	lb_attachments.DeleteItem(li_row)
End If

end event

type cbx_logfile from checkbox within tabpage_2
integer x = 805
integer y = 1360
integer width = 443
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Log to file"
end type

type cbx_debugviewer from checkbox within tabpage_2
integer x = 1280
integer y = 1360
integer width = 590
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Log to Debug Viewer"
end type

