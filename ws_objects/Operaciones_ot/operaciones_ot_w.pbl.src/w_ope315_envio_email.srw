$PBExportHeader$w_ope315_envio_email.srw
forward
global type w_ope315_envio_email from window
end type
type pb_2 from picturebutton within w_ope315_envio_email
end type
type p_1 from picture within w_ope315_envio_email
end type
type st_4 from statictext within w_ope315_envio_email
end type
type sle_para from singlelineedit within w_ope315_envio_email
end type
type st_3 from statictext within w_ope315_envio_email
end type
type st_2 from statictext within w_ope315_envio_email
end type
type sle_asunto from singlelineedit within w_ope315_envio_email
end type
type st_1 from statictext within w_ope315_envio_email
end type
type mle_mensaje from multilineedit within w_ope315_envio_email
end type
type pb_1 from picturebutton within w_ope315_envio_email
end type
type gb_1 from groupbox within w_ope315_envio_email
end type
end forward

global type w_ope315_envio_email from window
integer width = 2505
integer height = 1384
boolean titlebar = true
string title = "Envio Correo Elec (OPE315)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
pb_2 pb_2
p_1 p_1
st_4 st_4
sle_para sle_para
st_3 st_3
st_2 st_2
sle_asunto sle_asunto
st_1 st_1
mle_mensaje mle_mensaje
pb_1 pb_1
gb_1 gb_1
end type
global w_ope315_envio_email w_ope315_envio_email

on w_ope315_envio_email.create
this.pb_2=create pb_2
this.p_1=create p_1
this.st_4=create st_4
this.sle_para=create sle_para
this.st_3=create st_3
this.st_2=create st_2
this.sle_asunto=create sle_asunto
this.st_1=create st_1
this.mle_mensaje=create mle_mensaje
this.pb_1=create pb_1
this.gb_1=create gb_1
this.Control[]={this.pb_2,&
this.p_1,&
this.st_4,&
this.sle_para,&
this.st_3,&
this.st_2,&
this.sle_asunto,&
this.st_1,&
this.mle_mensaje,&
this.pb_1,&
this.gb_1}
end on

on w_ope315_envio_email.destroy
destroy(this.pb_2)
destroy(this.p_1)
destroy(this.st_4)
destroy(this.sle_para)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_asunto)
destroy(this.st_1)
destroy(this.mle_mensaje)
destroy(this.pb_1)
destroy(this.gb_1)
end on

type pb_2 from picturebutton within w_ope315_envio_email
integer x = 2117
integer y = 264
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type p_1 from picture within w_ope315_envio_email
integer x = 576
integer y = 76
integer width = 155
integer height = 176
string picturename = "H:\Source\BMP\tramite.jpg"
boolean focusrectangle = false
end type

type st_4 from statictext within w_ope315_envio_email
integer x = 41
integer y = 100
integer width = 480
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Se Adjunta Archivo "
boolean focusrectangle = false
end type

type sle_para from singlelineedit within w_ope315_envio_email
integer x = 41
integer y = 492
integer width = 2423
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_ope315_envio_email
integer x = 41
integer y = 432
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Para :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope315_envio_email
integer x = 41
integer y = 580
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Asunto :"
boolean focusrectangle = false
end type

type sle_asunto from singlelineedit within w_ope315_envio_email
integer x = 41
integer y = 656
integer width = 2423
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ope315_envio_email
integer x = 41
integer y = 760
integer width = 279
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mensaje :"
boolean focusrectangle = false
end type

type mle_mensaje from multilineedit within w_ope315_envio_email
integer x = 41
integer y = 828
integer width = 2423
integer height = 456
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ope315_envio_email
integer x = 2112
integer y = 64
integer width = 315
integer height = 180
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\mail_up.bmp"
alignment htextalign = left!
end type

event clicked;//enviar email
OLEObject lole_SMTP
lole_SMTP = CREATE OleObject
Integer li_con,li_count,li_index,li_return_ole,li_i
String  ls_para[],ls_texto_para,ls_inifile
String  ls_para_mail, ls_para_mail1
Boolean lb_ret = TRUE


Parent.SetRedraw(FALSE)
SetPointer(hourglass!)

// Parametros
ls_inifile    = "\pb_exe\oper_ot.ini"

li_con = lole_SMTP.ConnectToNewObject("EasyMail.SMTP.6")
lole_SMTP.LicenseKey = "Louise Priest (Single Developer)/0010630410721500AB30"
lole_SMTP.MailServer   = ProfileString (ls_inifile, "Email", "Mailserver","ninguno")
lole_SMTP.FromAddr   = "titanium@cgaip.com.pe"


ls_texto_para = Trim(sle_para.Text)

if ls_texto_para='' then
	MessageBox("E-Mail", 'El campo destinatario no esta llenado.')
	lb_ret = FALSE
	GOTO SALIDA
end if

if pos(ls_texto_para, '@') = 0 then
	MessageBox("E-Mail", 'No es una direccion de correo valido.')
	lb_ret = FALSE
	GOTO SALIDA
end if

li_index = 1

for li_i = 1 to len(ls_texto_para) 

	if mid(ls_texto_para, li_i,1)=',' or mid(ls_texto_para, li_i,1)=';' then
		li_index++
	elseif mid(ls_texto_para, li_i,1)=' ' then
		continue
	else
		ls_para[li_index] = ls_para[li_index] + mid(ls_texto_para, li_i,1)
	end if
	
next

if UpperBound(ls_para) <= 0 then
	MessageBox("E-Mail", 'Debe haber al menos un destinatario.')
	lb_ret = FALSE
	GOTO SALIDA
end if

lole_SMTP.Subject = sle_asunto.Text
lole_SMTP.BodyText = mle_mensaje.Text



x = lole_SMTP.AddAttachment ('c:\informe_tit.pdf', 0)


for li_i = 1 to UpperBound(ls_para) 
	 ls_para_mail = mid( ls_para[li_i], 1, pos( ls_para[li_i], '@') - 1 )
	 ls_para_mail1 = "'" + ls_para[li_i] + "'"
	 ls_para_mail1 = ls_para[li_i]
    lole_SMTP.AddRecipient( ls_para_mail, ls_para_mail1, 1 )
next

lole_SMTP.AutoWrap = 0
lole_SMTP.AutoWrap = 0
lole_SMTP.AutoWrap = 0
li_return_ole = lole_SMTP.Send()




IF li_return_ole <> 0 THEN
	choose case li_return_ole
	case 1 		
		messagebox ('Aviso','An exception has occurred.')
	case 3
		messagebox ('Aviso','The process has run out of memory.')
	case 4
		messagebox ('Aviso','An error has occurred due to a problem with the message body or attachments.')
	case 7
		messagebox ('Aviso','The from address was not formatted correctly or was rejected by the SMTP mail server. Some SMTP mail servers will only accept mail from particular addresses or domains. SMTP mail servers may also reject a from address if the server can not successfully do a reverse lookup on the from address.')
	case 8
		messagebox ('Aviso','An error was reported in response to a recipient address. The SMTP server may refuse to handle mail for unknown recipients.')
	case 10
		messagebox ('Aviso','There was an error opening a file. If you have specified file attachments, ensure that they exist and that you have access to them.')
	case 11
		messagebox ('Aviso','There was an error reading a file. If you have specified file attachments, ensure that they exist and the you have access to them.')
	case 16
		messagebox ('Aviso','There was a problem with the connection and a socket error occurred.')
	case 19
		messagebox ('Aviso','Could not create thread.')
	case 20
		messagebox ('Aviso','Cancelled as a result of calling the Cancel() method.')
	case 27
		messagebox ('Aviso','Socket Timeout Error')
	case else
		messagebox ('Aviso','Ni idea del error ' + string(li_return_ole) )
   end choose
	
	MessageBox("Envio de E-Mail", 'Mail No se envió')
	lb_ret = FALSE
	GOTO SALIDA
	
END IF



SALIDA:
lole_SMTP.DisconnectObject()
Destroy lole_SMTP

SetPointer(Arrow!)
Parent.SetRedraw(true)

IF lb_ret THEN Close (parent)

end event

type gb_1 from groupbox within w_ope315_envio_email
integer x = 23
integer y = 16
integer width = 2469
integer height = 1284
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Envio de Correo"
end type

