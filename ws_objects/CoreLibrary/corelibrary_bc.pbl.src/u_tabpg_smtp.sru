$PBExportHeader$u_tabpg_smtp.sru
forward
global type u_tabpg_smtp from u_tabpg
end type
type cbx_debugviewer from checkbox within u_tabpg_smtp
end type
type cbx_logfile from checkbox within u_tabpg_smtp
end type
type cb_del from commandbutton within u_tabpg_smtp
end type
type cb_addfile from commandbutton within u_tabpg_smtp
end type
type st_7 from statictext within u_tabpg_smtp
end type
type lb_attachments from listbox within u_tabpg_smtp
end type
type cbx_sendhtml from checkbox within u_tabpg_smtp
end type
type st_6 from statictext within u_tabpg_smtp
end type
type sle_send_email from singlelineedit within u_tabpg_smtp
end type
type st_4 from statictext within u_tabpg_smtp
end type
type st_3 from statictext within u_tabpg_smtp
end type
type sle_from_email from singlelineedit within u_tabpg_smtp
end type
type sle_from_name from singlelineedit within u_tabpg_smtp
end type
type st_2 from statictext within u_tabpg_smtp
end type
type mle_body from multilineedit within u_tabpg_smtp
end type
type cb_send from commandbutton within u_tabpg_smtp
end type
type sle_subject from singlelineedit within u_tabpg_smtp
end type
type st_1 from statictext within u_tabpg_smtp
end type
type sle_send_name from singlelineedit within u_tabpg_smtp
end type
type st_5 from statictext within u_tabpg_smtp
end type
end forward

global type u_tabpg_smtp from u_tabpg
string text = "Send Mail"
cbx_debugviewer cbx_debugviewer
cbx_logfile cbx_logfile
cb_del cb_del
cb_addfile cb_addfile
st_7 st_7
lb_attachments lb_attachments
cbx_sendhtml cbx_sendhtml
st_6 st_6
sle_send_email sle_send_email
st_4 st_4
st_3 st_3
sle_from_email sle_from_email
sle_from_name sle_from_name
st_2 st_2
mle_body mle_body
cb_send cb_send
sle_subject sle_subject
st_1 st_1
sle_send_name sle_send_name
st_5 st_5
end type
global u_tabpg_smtp u_tabpg_smtp

type variables
n_cst_serversmtp 	invo_email
n_smtp				invo_smtp
end variables

forward prototypes
public subroutine of_send_old ()
public subroutine of_send ()
end prototypes

public subroutine of_send_old ();String 	ls_body, ls_server, ls_uid, ls_pwd
String 	ls_filename, ls_port, ls_encrypt, ls_errormsg
Integer 	li_idx, li_max
Boolean 	lb_html, lb_Return
UInt 		lui_port

try 
	SetPointer(HourGlass!)

	invo_email.of_load()
	
	ls_server = invo_email.is_server
	
	If ls_server = "" Then
		MessageBox("Edit Error", &
			"You must specify Server on the Settings tab first!", StopSign!)
		Return
	End If
	
	If sle_send_email.text = "" Then
		sle_send_email.SetFocus()
		MessageBox("Edit Error", &
			"To Email is a required field!", StopSign!)
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
		ls_body += of_replaceall(mle_body.text, "~r~n", "<br>") + "</h2>"
		ls_body += "</body></html>"
		lb_html = True
	Else
		ls_body = mle_body.text
		lb_html = False
	End If
	
	lui_port = invo_email.iui_port
	
	// *** set email properties *********************
	invo_smtp.of_ResetAll()
	invo_smtp.of_SetPort(lui_port)
	invo_smtp.of_SetServer(ls_server)
	invo_smtp.of_SetLogFile(cbx_logfile.Checked, "smtp_logfile8.txt")
	invo_smtp.of_SetDebugViewer(cbx_debugviewer.Checked)
	invo_smtp.of_SetSubject(sle_subject.text)
	invo_smtp.of_SetBody(ls_body, lb_html)
	invo_smtp.of_SetFrom(sle_from_email.text, sle_from_name.text)
	invo_smtp.of_AddAddress(sle_send_email.text, sle_send_name.text)
	
	// *** set Userid/Password if required **********
	If invo_email.is_AuthSMTP = "Y" Then
		ls_uid = invo_email.is_uid
		ls_pwd = invo_email.is_pwd
		invo_smtp.of_SetLogin(ls_uid, ls_pwd)
	End If
	
	// *** add any attachments **********************
	li_max = lb_attachments.TotalItems()
	For li_idx = 1 To li_max
		ls_filename = lb_attachments.Text(li_idx)
		invo_smtp.of_AddAttachment(ls_filename)
	Next
	
	// *** send the message *************************
	ls_encrypt = invo_email.is_encrypt
	choose case ls_encrypt
		case "SSL"
			lb_Return = invo_smtp.of_SendSSLMail()
		case "TLS"
			lb_Return = invo_smtp.of_SendTLSMail()
		case else
			lb_Return = invo_smtp.of_SendMail()
	end choose
	
	If lb_Return Then
		MessageBox("SendMail", "Mail successfully sent!")
	Else
		MessageBox("SendMail Error", invo_smtp.of_GetLastError())
	End If

catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Error en cb_send')
	
finally
	SetPointer(Arrow!)
end try



end subroutine

public subroutine of_send ();// =========================================================================
// FUNCION: of_send
// DESCRIPCION: Envía correo usando el DLL SigreWebServiceWrapper
// Usa la función EnviarEmail con formato unificado
// =========================================================================

String ls_body, ls_errormsg, ls_resultado
String ls_remitente, ls_destinatarios, ls_adjuntos
String ls_filename
Integer li_idx, li_max
Integer li_esHtml
n_cst_api_sigre_dll lnvo_api

try
    SetPointer(HourGlass!)
	
	lnvo_api = create n_cst_api_sigre_dll
    
    // *** Validaciones ***
    If sle_send_email.text = "" Then
        sle_send_email.SetFocus()
        MessageBox("Edit Error", "To Email is a required field!", StopSign!)
        Return
    End If
    
    If sle_from_email.text = "" Then
        sle_from_email.SetFocus()
        MessageBox("Edit Error", "From Email is a required field!", StopSign!)
        Return
    End If
    
    If sle_subject.text = "" Then
        sle_subject.SetFocus()
        MessageBox("Edit Error", "Subject is a required field!", StopSign!)
        Return
    End If
    
    If mle_body.text = "" Then
        mle_body.SetFocus()
        MessageBox("Edit Error", "Body is a required field!", StopSign!)
        Return
    End If
    
    // *** Preparar el cuerpo del mensaje ***
    If cbx_sendhtml.Checked Then
        ls_body  = "<html><body bgcolor='#FFFFFF' topmargin=8 leftmargin=8><h2>"
        ls_body += of_replaceall(mle_body.text, "~r~n", "<br>") + "</h2>"
        ls_body += "</body></html>"
        li_esHtml = 1
    Else
        ls_body = mle_body.text
        li_esHtml = 0
    End If
    
    // *** Preparar remitente: "email, nombre" ***
    ls_remitente = trim(sle_from_email.text) + ", " + trim(sle_from_name.text)
    
    // *** Preparar destinatarios: "email, nombre;" ***
    ls_destinatarios = trim(sle_send_email.text) + ", " + trim(sle_send_name.text) + ";"
    
    // *** Preparar adjuntos (separados por |) ***
    ls_adjuntos = ""
    li_max = lb_attachments.TotalItems()
    For li_idx = 1 To li_max
        ls_filename = lb_attachments.Text(li_idx)
        If li_idx > 1 Then
            ls_adjuntos += "|"
        End If
        ls_adjuntos += ls_filename
    Next
    
    // *** Enviar usando el DLL con formato unificado ***
    ls_resultado = lnvo_api.EnviarEmail( &
        ls_remitente, &
        ls_destinatarios, &
        "", &
        "", &
        sle_subject.text, &
        ls_body, &
        li_esHtml, &
        ls_adjuntos)
    
    // *** Procesar resultado (JSON) ***
    // El resultado es: {"exitoso":true,"mensaje":"..."} o {"exitoso":false,"mensaje":"..."}
    If Pos(ls_resultado, '"exitoso":true') > 0 Then
        MessageBox("SendMail", "Mail successfully sent!")
    Else
        // Extraer mensaje de error del JSON
        ls_errormsg = ls_resultado
        MessageBox("SendMail Error", ls_errormsg)
    End If

catch ( Exception ex )
    gnvo_app.of_Catch_exception(ex, 'Error en of_send')
    
finally
	destroy lnvo_api
    SetPointer(Arrow!)
end try
end subroutine

on u_tabpg_smtp.create
int iCurrent
call super::create
this.cbx_debugviewer=create cbx_debugviewer
this.cbx_logfile=create cbx_logfile
this.cb_del=create cb_del
this.cb_addfile=create cb_addfile
this.st_7=create st_7
this.lb_attachments=create lb_attachments
this.cbx_sendhtml=create cbx_sendhtml
this.st_6=create st_6
this.sle_send_email=create sle_send_email
this.st_4=create st_4
this.st_3=create st_3
this.sle_from_email=create sle_from_email
this.sle_from_name=create sle_from_name
this.st_2=create st_2
this.mle_body=create mle_body
this.cb_send=create cb_send
this.sle_subject=create sle_subject
this.st_1=create st_1
this.sle_send_name=create sle_send_name
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_debugviewer
this.Control[iCurrent+2]=this.cbx_logfile
this.Control[iCurrent+3]=this.cb_del
this.Control[iCurrent+4]=this.cb_addfile
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.lb_attachments
this.Control[iCurrent+7]=this.cbx_sendhtml
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.sle_send_email
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_from_email
this.Control[iCurrent+13]=this.sle_from_name
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.mle_body
this.Control[iCurrent+16]=this.cb_send
this.Control[iCurrent+17]=this.sle_subject
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.sle_send_name
this.Control[iCurrent+20]=this.st_5
end on

on u_tabpg_smtp.destroy
call super::destroy
destroy(this.cbx_debugviewer)
destroy(this.cbx_logfile)
destroy(this.cb_del)
destroy(this.cb_addfile)
destroy(this.st_7)
destroy(this.lb_attachments)
destroy(this.cbx_sendhtml)
destroy(this.st_6)
destroy(this.sle_send_email)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_from_email)
destroy(this.sle_from_name)
destroy(this.st_2)
destroy(this.mle_body)
destroy(this.cb_send)
destroy(this.sle_subject)
destroy(this.st_1)
destroy(this.sle_send_name)
destroy(this.st_5)
end on

event constructor;call super::constructor;try 
	invo_email.of_reload()
	
	sle_send_name.text 	= of_getreg("SendName", "")
	sle_send_email.text 	= of_getreg("SendEmail", "")
	sle_from_name.text 	= invo_email.is_NameFromEmail + ' ' + gnvo_app.empresa.is_sigla
	sle_from_email.text 	= invo_email.is_FromEmail
	sle_subject.text 		= of_getreg("Subject", "")
	mle_body.text 			= of_getreg("Body", "")
	
	If of_getreg("SendHTML", "N") = "Y" Then
		cbx_sendhtml.checked = True
	Else
		cbx_sendhtml.checked = False
	End If
	
	If of_getreg("LogFile", "N") = "Y" Then
		cbx_logfile.checked = True
	Else
		cbx_logfile.checked = False
	End If
	
	If of_getreg("DebugViewer", "N") = "Y" Then
		cbx_debugviewer.checked = True
	Else
		cbx_debugviewer.checked = False
	End If

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error en constructor de u_tabpg_smtp')
end try

end event

event destructor;call super::destructor;of_setreg("SendName", sle_send_name.text)
of_setreg("SendEmail", sle_send_email.text)
of_setreg("FromName", sle_from_name.text)
of_setreg("FromEmail", sle_from_email.text)
of_setreg("Subject", sle_subject.text)
of_setreg("Body", mle_body.text)

If cbx_sendhtml.checked Then
	of_setreg("SendHTML", "Y")
Else
	of_setreg("SendHTML", "N")
End If

If cbx_logfile.checked Then
	of_setreg("LogFile", "Y")
Else
	of_setreg("LogFile", "N")
End If

If cbx_debugviewer.checked Then
	of_setreg("DebugViewer", "Y")
Else
	of_setreg("DebugViewer", "N")
End If

end event

event ue_pagechanged;call super::ue_pagechanged;sle_send_name.SetFocus()

end event

type cbx_debugviewer from checkbox within u_tabpg_smtp
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

type cbx_logfile from checkbox within u_tabpg_smtp
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

type cb_del from commandbutton within u_tabpg_smtp
integer x = 37
integer y = 1120
integer width = 261
integer height = 100
integer taborder = 90
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

type cb_addfile from commandbutton within u_tabpg_smtp
integer x = 37
integer y = 992
integer width = 261
integer height = 100
integer taborder = 80
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

type st_7 from statictext within u_tabpg_smtp
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

type lb_attachments from listbox within u_tabpg_smtp
integer x = 329
integer y = 992
integer width = 2016
integer height = 292
integer taborder = 70
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

type cbx_sendhtml from checkbox within u_tabpg_smtp
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

type st_6 from statictext within u_tabpg_smtp
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

type sle_send_email from singlelineedit within u_tabpg_smtp
integer x = 1499
integer y = 40
integer width = 846
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within u_tabpg_smtp
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

type st_3 from statictext within u_tabpg_smtp
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

type sle_from_email from singlelineedit within u_tabpg_smtp
integer x = 1499
integer y = 168
integer width = 846
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_from_name from singlelineedit within u_tabpg_smtp
integer x = 329
integer y = 168
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

type st_2 from statictext within u_tabpg_smtp
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

type mle_body from multilineedit within u_tabpg_smtp
integer x = 329
integer y = 424
integer width = 2016
integer height = 444
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_send from commandbutton within u_tabpg_smtp
integer x = 2011
integer y = 1344
integer width = 334
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
end type

event clicked;of_send()
end event

type sle_subject from singlelineedit within u_tabpg_smtp
integer x = 329
integer y = 296
integer width = 2016
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within u_tabpg_smtp
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

type sle_send_name from singlelineedit within u_tabpg_smtp
integer x = 329
integer y = 40
integer width = 846
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within u_tabpg_smtp
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

