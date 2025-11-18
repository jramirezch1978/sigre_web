$PBExportHeader$n_cst_serversmtp.sru
forward
global type n_cst_serversmtp from nonvisualobject
end type
end forward

global type n_cst_serversmtp from nonvisualobject autoinstantiate
end type

type variables
String 	is_server, is_uid, is_pwd, is_AuthSMTP, is_encrypt, is_FromEmail, &
			is_NameFromEmail, is_pathLogEmail
boolean	ib_html, ib_load = false
UInt 		iui_port
n_smtp 	invo_smtp
n_cst_encriptor	invo_encriptor
n_cst_utilitario	invo_utilitario
end variables

forward prototypes
public function boolean of_load () throws exception
public function boolean of_send_email (string as_subject, string as_body, n_cst_usuario anvo_usr_dst[]) throws exception
public function boolean of_send_email (string as_subject, string as_body, n_cst_usuario anvo_usr_dst) throws exception
public function boolean of_send (n_cst_emailmessage anvo_msg)
public function boolean of_reload () throws exception
public function boolean of_save () throws exception
public function string of_logfile () throws exception
end prototypes

public function boolean of_load () throws exception;Exception ex
String		ls_logFile

if this.ib_load then return false

if IsNull(gnvo_app) or not IsValid(gnvo_app) then return false

is_server = gnvo_app.of_get_parametro("ServerSMTP", "smtp.gmail.com")

If is_server = "" Then
	ex = create Exception
	ex.setMessage("Debes Especificar un servidor SMTP para envío de email, por favor verifique en el tab SMTP Setting")
	throw ex
	Return false
End If

ib_html = True

iui_port = Long(gnvo_app.of_get_parametro("PortSMTP", "465"))

//Archivo para LOG
ls_logFile = this.of_logfile( )


is_AuthSMTP = gnvo_app.of_get_parametro("AuthSMTP", "Y")
is_uid 		= gnvo_app.of_get_parametro("UseridSMTP", "no-reply@npssac.com.pe")
is_pwd 		= gnvo_app.of_get_parametro("PasswordSMTP", "noreply1234")

//if trim(is_pwd) <> "" then
//	is_pwd = invo_encriptor.of_desencriptarjr( is_pwd )
//end if

if is_AuthSMTP = 'Y' and (is_uid = '' or is_pwd = '') then
	ex = create Exception
	ex.setMessage("No se ha especificado las credenciales para el servidor SMTP, por favor verifique en el tab SMTP Setting")
	throw ex
	Return false
end if
	
// *** send the message *************************
is_encrypt			= gnvo_app.of_get_parametro("EncryptSMTP", "SSL")

is_FromEmail 		= gnvo_app.of_get_parametro("FromAddressSMTP", "sigre@npssac.com.pe")
is_NameFromEmail 	= gnvo_app.of_get_parametro("NameFromEmailSMTP", "ERP SIGRE")

ib_load = true

return true
end function

public function boolean of_send_email (string as_subject, string as_body, n_cst_usuario anvo_usr_dst[]) throws exception;String 		ls_body, ls_filename, ls_errormsg, ls_logFile
Integer 		li_idx, li_max, li_i
Exception	ex
boolean		lb_return

try 
	SetPointer(HourGlass!)

	If UpperBound(anvo_usr_dst) = 0 Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " &
			+ "Debe Especificar a quien enviarle el email. Por favor verifique!")
		throw ex
		Return false
	End If
	
	If as_subject = "" Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " &
			+ "Es requerido el campo de ASUNTO en el email, por favor verifique!")
		throw ex
		Return false
	End If
	
	If as_body = "" Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " &
			+ "Es requerido el CUERPO del email, por favor verifique!")
		throw ex
		Return false
	End If
	
	//Valido el email desde el cual voy a enviar el email
	If Not invo_smtp.of_ValidEmail(is_FromEmail, ls_errormsg) Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " & 
			+ "No se pudo validar la direccion de FROM " + is_FromEmail + ", Mensaje de Error: " + ls_errormsg)
		throw ex
		Return false
	End If
	
	for li_i = 1 to UpperBound(anvo_usr_dst) 
		If Not invo_smtp.of_ValidEmail(anvo_usr_dst[li_i].is_email, ls_errormsg) Then
			ex = create Exception
			ex.setMessage("Error en clase " + this.ClassName() + ". " & 
				+ "No se pudo validar la direccion de TO " + anvo_usr_dst[li_i].is_email + ", Mensaje de Error: " + ls_errormsg)
			throw ex
			Return false
		End If	
		
	next
	
	If ib_html Then
		ls_body  = "<html><body bgcolor='#FFFFFF' topmargin=8 leftmargin=8><h2>"
		ls_body += invo_utilitario.of_replaceall(as_body, "~r~n", "<br>") + "</h2>"
		ls_body += "</body></html>"
	Else
		ls_body = as_body
	End If
	
	// *** set email properties *********************
	ls_LogFile = this.of_logfile( )
	
	invo_smtp.of_ResetAll()
	invo_smtp.of_SetPort(iui_port)
	invo_smtp.of_SetServer(is_server)
	invo_smtp.of_SetLogFile(true, ls_LogFile)
	//invo_smtp.of_SetDebugViewer(true)
	invo_smtp.of_SetSubject(as_subject)
	invo_smtp.of_SetBody(as_body, ib_html)
	invo_smtp.of_SetFrom(is_FromEmail, is_NameFromEmail)
	
	for li_i = 1 to UpperBound(anvo_usr_dst) 
		invo_smtp.of_AddAddress(anvo_usr_dst[li_i].is_email, anvo_usr_dst[li_i].is_nombre)
	next
	
	
	// *** set Userid/Password if required **********
	If is_AuthSMTP = "Y" Then
		invo_smtp.of_SetLogin(is_uid, is_pwd)
	End If
	
	// *** send the message *************************
	choose case is_encrypt
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
		MessageBox("Error en Envío de Email", "Mensaje de Error: " + invo_smtp.of_GetLastError(), StopSign!)
	End If
	
	return lb_Return

catch ( Exception ex1 )
	throw ex1
	
finally
	SetPointer(Arrow!)
	
end try


return true
end function

public function boolean of_send_email (string as_subject, string as_body, n_cst_usuario anvo_usr_dst) throws exception;String 		ls_body, ls_filename, ls_errormsg, ls_LogFile
Integer 		li_idx, li_max
boolean		lb_return
Exception	ex

try 
	SetPointer(HourGlass!)

	If trim(anvo_usr_dst.is_email) = '' Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " &
			+ "El usuario destino ' + anvo_usr_dst.is_cod_usr + ' no tiene email asignado, por favor verifique. Por favor verifique!")
		throw ex
		Return false
	End If
	
	If as_subject = "" Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " &
			+ "Es requerido el campo de ASUNTO en el email, por favor verifique!")
		throw ex
		Return false
	End If
	
	If as_body = "" Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " &
			+ "Es requerido el CUERPO del email, por favor verifique!")
		throw ex
		Return false
	End If
	
	//Valido el email desde el cual voy a enviar el email
	If Not invo_smtp.of_ValidEmail(is_FromEmail, ls_errormsg) Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " & 
			+ "No se pudo validar la direccion de FROM " + is_FromEmail + ", Mensaje de Error: " + ls_errormsg)
		throw ex
		Return false
	End If
	
	If Not invo_smtp.of_ValidEmail(anvo_usr_dst.is_email, ls_errormsg) Then
		ex = create Exception
		ex.setMessage("Error en clase " + this.ClassName() + ". " & 
			+ "No se pudo validar la direccion de TO " + anvo_usr_dst.is_email + ", Mensaje de Error: " + ls_errormsg)
		throw ex
		Return false
	End If	
		
	If ib_html Then
		ls_body  = "<html>"
		ls_body += invo_utilitario.of_replaceall(as_body, "~r~n", "<br>")
		ls_body += "</html>"
	Else
		ls_body = as_body
	End If
	
	// *** set email properties *********************
	ls_LogFile = this.of_logfile( )
	
	invo_smtp.of_ResetAll()
	invo_smtp.of_SetPort(iui_port)
	invo_smtp.of_SetServer(is_server)
	invo_smtp.of_SetLogFile(true, ls_LogFile)
	invo_smtp.of_SetSubject(as_subject)
	invo_smtp.of_SetBody(ls_body, ib_html)
	invo_smtp.of_SetFrom(is_FromEmail, is_NameFromEmail)
	
	invo_smtp.of_AddAddress(anvo_usr_dst.is_email, anvo_usr_dst.is_nombre)
	
	
	// *** set Userid/Password if required **********
	If is_AuthSMTP = "Y" Then
		invo_smtp.of_SetLogin(is_uid, is_pwd)
	End If
	
	// *** send the message *************************
	choose case is_encrypt
		case "SSL"
			lb_Return = invo_smtp.of_SendSSLMail()
		case "TLS"
			lb_Return = invo_smtp.of_SendTLSMail()
		case else
			lb_Return = invo_smtp.of_SendMail()
	end choose
	
	If lb_Return Then
		MessageBox("Envío de Email", "Email enviado satisfactoriamente al usuario " + anvo_usr_dst.is_nombre + ".", Information!)
	Else
		MessageBox("Error en Envío de Email", "Mensaje de Error: " + invo_smtp.of_GetLastError(), StopSign!)
	End If
	
	return lb_Return

catch ( Exception ex1 )
	throw ex1
	
finally
	SetPointer(Arrow!)
	
end try


return true
end function

public function boolean of_send (n_cst_emailmessage anvo_msg);String 		ls_body, ls_filename, ls_errormsg, ls_LogFile
Integer 		li_idx, li_max
Long			ll_index
boolean 		lb_Return

try 
	SetPointer(HourGlass!)

	If upperbound(anvo_msg.istr_email_to) = 0 Then
		MessageBox("Error funcion of_send(). ", &
					+ "No se ha especificado emails de Destino en el objeto n_cst_emailMessage. Por favor verifique!")
		Return false
	End If
	
	If trim(anvo_msg.is_subject) = "" Then
		MessageBox("Error funcion of_send(). ", &
					+ "No se ha especificado el ASUNTO en el objeto n_cst_emailMessage. Por favor verifique!")
		Return false
	End If
	
	If trim(anvo_msg.is_body) = "" Then
		MessageBox("Error funcion of_send(). ", &
					+ "No se ha especificado el CUERPO DEL CORREO en el objeto n_cst_emailMessage. Por favor verifique!")
		Return false
	End If
	
	//Valido los emails de la estructura
	If Not invo_smtp.of_ValidEmail(is_FromEmail, ls_errormsg) Then
		MessageBox("Error funcion of_send(). ", &
					+ "El correo Origen: " + anvo_msg.istr_email_from.email &
					+ " del objeto n_cst_emailMessage no es VALIDO. Mensaje: " + ls_errormsg + ". Por favor verifique!")
		Return false
	End If
	
	
	//Adiciono el CUERPO del email
	If ib_html Then
		ls_body  = "<html><body>"
		ls_body += anvo_msg.is_body
		ls_body += "</body>"
		ls_body += "</html>"
	Else
		ls_body = anvo_msg.is_body
	End If
	
	// *** set email properties *********************
	ls_LogFile = this.of_logfile( )
	
	invo_smtp.of_ResetAll()
	invo_smtp.of_SetPort(iui_port)
	invo_smtp.of_SetServer(is_server)
	invo_smtp.of_SetLogFile(true, ls_LogFile)
	invo_smtp.of_SetDebugViewer(false)
	invo_smtp.of_SetSubject(anvo_msg.is_subject)
	invo_smtp.of_SetBody(ls_body, ib_html)
	invo_smtp.of_SetFrom(is_FromEmail, is_NameFromEmail + ' EMPRESA: ' + gnvo_app.empresa.is_sigla)
	
	//Adiciono los Emails de Salida
	for ll_index = 1 to upperBound(anvo_msg.istr_email_to)
		
		If Not invo_smtp.of_ValidEmail(anvo_msg.istr_email_to[ll_index].email, ls_errormsg) Then
			
			MessageBox("Error funcion of_send(). ", &
						+ "El correo Destino: " + anvo_msg.istr_email_to[ll_index].email &
						+ " del objeto n_cst_emailMessage no es VALIDO. Mensaje: " + ls_errormsg + ". Por favor verifique!")
			Return false
		End If
		
		//Adiciono las direcciones de destino
		invo_smtp.of_AddAddress(anvo_msg.istr_email_to[ll_index].email, anvo_msg.istr_email_to[ll_index].nombre)
		
	next
	
	//Adiciono los Emails de Salida (Copia BCC)
	for ll_index = 1 to upperBound(anvo_msg.istr_email_bcc)
		
		If Not invo_smtp.of_ValidEmail(anvo_msg.istr_email_bcc[ll_index].email, ls_errormsg) Then
			
			MessageBox("Error funcion of_send(). ", &
						+ "El correo Destino: " + anvo_msg.istr_email_bcc[ll_index].email &
						+ " del objeto n_cst_emailMessage no es VALIDO. Mensaje: " + ls_errormsg + ". Por favor verifique!")
			Return false
		End If
		
		//Adiciono las direcciones de destino
		invo_smtp.of_AddBCC(anvo_msg.istr_email_bcc[ll_index].email, anvo_msg.istr_email_bcc[ll_index].nombre)
		
	next

	//Adiciono los attach
	if UpperBound(anvo_msg.is_attachment) > 0 then
		for ll_index = 1 to upperBound(anvo_msg.is_attachment)
			
			//Adiciono las direcciones de destino
			invo_smtp.of_AddAttachment(anvo_msg.is_attachment[ll_index])
			
		next
		
	end if


	// *** set Userid/Password if required **********
	If is_AuthSMTP = "Y" Then
		invo_smtp.of_SetLogin(is_uid, is_pwd)
	End If
	
	//Incremento el TimeOut
	invo_smtp.of_setTimeOut(20)
	
	// *** send the message *************************
	choose case is_encrypt
		case "SSL"
			lb_Return = invo_smtp.of_SendSSLMail()
		case "TLS"
			lb_Return = invo_smtp.of_SendTLSMail()
		case else
			lb_Return = invo_smtp.of_SendMail()
	end choose
	
	If not lb_Return Then
		MessageBox("Error en Envío de Email", "Ha ocurrido un error al enviar el email. Mensaje de Error: " + invo_smtp.of_GetLastError(), StopSign!)
	End If
	
	return lb_Return

catch ( Exception ex1 )
	throw ex1
	
finally
	SetPointer(Arrow!)
	
end try

return true
end function

public function boolean of_reload () throws exception;this.ib_load = false

return this.of_load()


end function

public function boolean of_save () throws exception;Exception 	ex
Date			ld_fec_registro

ld_fec_registro = Date(gnvo_app.of_fecha_Actual())

if IsNull(gnvo_app) or not IsValid(gnvo_app) then return false

If is_server = "" Then
	ex = create Exception
	ex.setMessage("Debes Especificar un servidor SMTP para envío de email, por favor verifique en el tab SMTP Setting")
	throw ex
	Return false
End If


gnvo_app.of_set_parametro("ServerSMTP", this.is_server)
gnvo_app.of_set_parametro("PortSMTP", string(iui_port))

if trim(is_pathLogEmail) = "" then
	is_pathLogEmail = "i:\SIGRE_EXE\EMAIL_LOG\"
end if

gnvo_app.of_set_parametro("PathLogServerMail", is_pathLogEmail) 

if is_AuthSMTP = 'Y' and (is_uid = '' or is_pwd = '') then
	ex = create Exception
	ex.setMessage("No se ha especificado las credenciales para el servidor SMTP, por favor verifique en el tab SMTP Setting")
	throw ex
	Return false
end if

gnvo_app.of_set_parametro("AuthSMTP", this.is_AuthSMTP)
gnvo_app.of_set_parametro("UseridSMTP", this.is_uid)
gnvo_app.of_set_parametro("PasswordSMTP", this.is_pwd)

	
// *** send the message *************************
gnvo_app.of_set_parametro("EncryptSMTP", this.is_encrypt)
gnvo_app.of_set_parametro("FromAddressSMTP", this.is_FromEmail)
gnvo_app.of_set_parametro("NameFromEmailSMTP", this.is_NameFromEmail)

commit;

return true
end function

public function string of_logfile () throws exception;String 	ls_LogFile
Date 		ld_fec_registro

ld_fec_registro = Date(gnvo_app.of_fecha_Actual())

is_pathLogEmail = gnvo_app.of_get_parametro("PathLogServerMail", "i:\SIGRE_EXE\EMAIL_LOG\") 

ls_LogFile = is_pathLogEmail + trim(this.ClassName()) + "_" + string(ld_fec_registro, 'yyyymmdd') + ".log"

return ls_LogFile
end function

on n_cst_serversmtp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_serversmtp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;try 
	this.of_load( )
catch ( Exception ex )
	throw ex
finally
	/*statementBlock*/
end try

end event

