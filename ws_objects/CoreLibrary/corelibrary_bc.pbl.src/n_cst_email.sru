$PBExportHeader$n_cst_email.sru
$PBExportComments$Funciones para enviar emails
forward
global type n_cst_email from nonvisualobject
end type
end forward

global type n_cst_email from nonvisualobject
end type
global n_cst_email n_cst_email

type variables
mailSession          imSes
mailReturnCode       imRet
mailMessage				imMsg
mailFileDescription	imAttach
u_ds_base            ids_inbox



Private:
n_cst_pdf				invo_pdf
end variables

forward prototypes
public function string of_error (mailreturncode a_mret)
public function string of_delete_mail (long al_row)
public function string of_logoff ()
public function string of_send_mail (string as_name, string as_address, string as_subject, string as_message, string as_file, string as_path)
public function integer of_create_html (datawindow adw_obj, string as_path)
public function string of_send_mail (string as_name[], string as_address[], string as_subject, string as_message, string as_file[], string as_path[])
public function integer of_create_html (datastore ads_obj, string as_path)
public function integer of_receive_mail ()
public function string of_send_mail (string as_name, string as_address, string as_subject, string as_message)
public function string of_logon ()
public function boolean of_create_pdf (datastore ads_obj, string as_path)
public function boolean of_create_pdf (datawindow adw_report, string as_path)
public function boolean of_create_pdf (datastore ads_obj, string as_path, integer ai_type_export_pdf)
public function boolean of_create_pdf (datawindow adw_report, string as_path, integer ai_type_export_pdf)
public function boolean of_send (n_cst_emailmessage invo_msg)
end prototypes

public function string of_error (mailreturncode a_mret);string	ls_message

choose case a_mret
	case mailReturnAccessDenied!
		ls_message = 'Acceso Denegado'
	case mailReturnAttachmentNotFound!
		ls_message = 'Attachment No Encontrado'
	case mailReturnAttachmentOpenFailure!
		ls_message = 'Apertura de Attachment Fallida'
	case mailReturnAttachmentWriteFailure!
		ls_message = 'Escritura de Attachment Fallida'
	case mailReturnDiskFull!
		ls_message = 'Disco Lleno'
	case mailReturnFailure!
		ls_message = 'Retorno Fallido'
	case mailReturnInsufficientMemory!
		ls_message = 'Insuficiente Memoria'
	case mailReturnInvalidMessage!
		ls_message = 'Mensaje Invalido'
	case mailReturnLoginFailure!
		ls_message = 'Login Fallido'
	case mailReturnMessageInUse!
		ls_message = 'Mensaje en Uso'
	case mailReturnNoMessages!
		ls_message = 'No hay Mensajes'
	case mailReturnSuccess!
		ls_message = 'Exito'
	case mailReturnTextTooLarge!
		ls_message = 'Texto Muy Grande'
	case mailReturnTooManyFiles!
		ls_message = 'Muchos Archivos'
	case mailReturnTooManyRecipients!
		ls_message = 'Muchos Recibidores'
	case mailReturnTooManySessions!
		ls_message = 'Muchas Sesiones'
	case mailReturnUnknownRecipient!
		ls_message = 'Recibidor Desconocido'
	case mailReturnUserAbort!
		ls_message = 'Abortado por el Usuario'
	case else
		ls_message = 'Otro'
end choose

return ls_message


end function

public function string of_delete_mail (long al_row);
long					ll_row
mailReturnCode 	mret
string				ls_messgeid, ls_ret

ls_messgeid = ids_inbox.object.MessageID[al_row]

mRet = imses.mailDeleteMessage ( ls_messgeid )

if mRet = mailReturnSuccess! then
	ll_row = ids_inbox.DeleteRow ( ll_row )
end if

ls_ret = of_error(mRet)

RETURN ls_ret






end function

public function string of_logoff ();String	ls_rc

imRet = imSes.mailLogoff()

IF imRet = mailReturnSuccess! THEN DESTROY imSes

ls_rc = of_error(imRet)

RETURN ls_rc





end function

public function string of_send_mail (string as_name, string as_address, string as_subject, string as_message, string as_file, string as_path);String	ls_rc

imMsg.Recipient[1].Name = as_name
imMsg.Recipient[1].Address = as_address
imMsg.Subject	= as_subject
imMsg.notetext = as_message
imMsg.Recipient[1].RecipientType = mailTo!
imMsg.AttachmentFile[1].FileType = mailAttach!
imMsg.AttachmentFile[1].Filename = as_file
imMsg.AttachmentFile[1].Pathname = as_path
imAttach.Position = len(imMsg.notetext) - 1               //Ira atachado al final

//imRet = mSes.mailAddress(mMsg)
	
imRet = imSes.mailsend ( imMsg )

ls_rc = of_error(imRet)

RETURN ls_rc

end function

public function integer of_create_html (datawindow adw_obj, string as_path);String 	ls_html, ls_SS
Integer	li_filenum, li_rc = 0

// turn on style sheets and set properties
adw_obj.Object.DataWindow.HTMLTable.Border=10
adw_obj.Modify("DataWindow.HTMLTable.GenerateCSS=~"yes~"") 

ls_html = adw_obj.Object.DataWindow.Data.HTMLTable

// put a width attribute in the <table> 
ls_HTML = Replace ( ls_HTML, Pos(ls_HTML,"<table "), 6, "<table width=100% " )
// Save off the Style Sheet in the datastore
//ls_SS = adw_obj.Object.DataWindow.HTMLTable.StyleSheet
ls_HTML = ls_SS + ls_HTML 
 
li_filenum = FileOpen(as_path, StreamMode!, Write!, LockWrite!, Replace!)
li_rc = FileWrite(li_filenum, ls_html)

IF li_rc > 0 THEN
	li_rc = FileClose(li_filenum)
End if
 
RETURN li_rc
end function

public function string of_send_mail (string as_name[], string as_address[], string as_subject, string as_message, string as_file[], string as_path[]);String	ls_rc
Integer	li_x


IF (UpperBound(as_name) <> UpperBound(as_address)) THEN
	ls_rc = 'Error :   arreglos diferentes as_name, as_address'
	GOTO SALIDA
END IF

IF (UpperBound(as_file) <> UpperBound(as_path)) THEN
	ls_rc = 'Error :   arreglos diferentes as_file, as_path'
	GOTO SALIDA
END IF


FOR li_x = 1 TO UpperBound(as_name)
	imMsg.Recipient[li_x].Name = as_name[li_x]
	imMsg.Recipient[li_x].Address = as_address[li_x]
NEXT

imMsg.Subject	= as_subject
imMsg.notetext = as_message
imMsg.Recipient[1].RecipientType = mailTo!

FOR li_x = 1 TO UpperBound(as_file)
	imMsg.AttachmentFile[li_x].FileType = mailAttach!
	imMsg.AttachmentFile[li_x].Filename = as_file[li_x]
	imMsg.AttachmentFile[li_x].Pathname = as_path[li_x]
NEXT

imAttach.Position = len(imMsg.notetext) - 1               //Ira atachado al final

//imRet = mSes.mailAddress(mMsg)
	
imRet = imSes.mailsend ( imMsg )

ls_rc = of_error(imRet)

SALIDA:
RETURN ls_rc

end function

public function integer of_create_html (datastore ads_obj, string as_path);String 	ls_html, ls_SS
Integer	li_filenum, li_rc = 0
// turn on style sheets and set properties
ads_obj.Object.DataWindow.HTMLTable.Border=10
ads_obj.Modify("DataWindow.HTMLTable.GenerateCSS=~"yes~"") 

ls_html = ads_obj.Object.DataWindow.Data.HTMLTable

// put a width attribute in the <table> 
ls_HTML = Replace ( ls_HTML, Pos(ls_HTML,"<table "), 6, "<table width=100% " )
// Save off the Style Sheet in the datastore
//ls_SS = ads_obj.Object.DataWindow.HTMLTable.StyleSheet
ls_HTML = ls_SS + ls_HTML 
 
li_filenum = FileOpen(as_path, StreamMode!, Write!, LockWrite!, Replace!)
li_rc = FileWrite(li_filenum, ls_html)

IF li_rc > 0 THEN
	li_rc = FileClose(li_filenum)
End if
 
RETURN li_rc





end function

public function integer of_receive_mail ();mailReturnCode			lmRet
mailMessage				lmMsg[]
mailFileDescription	lmAttach
string					ls_filename, ls_ret , ls_type
int						li_msgs, li_attachments
int						li_index , li_row

ids_inbox.Reset()                     // Limpiar Datastore ids_inbox
lmRet = imSes.mailGetMessages ( )
//ls_Ret = of_error(lmRet)
li_msgs = UpperBound(imSes.MessageID) // nro total de mensajes

FOR li_index = 1 to li_msgs  // leer recipients, subject, lista de attachments
	lmRet = imSes.mailReadMessage(imSes.MessageID[li_index],lmMsg[li_index],mailEnvelopeOnly!, FALSE)
//	ls_ret = of_error(lmRet)
	li_attachments = UpperBound (lmMsg[li_index].AttachmentFile)

	li_row = ids_inbox.InsertRow ( 0 )	// insertar mensaje a Datastore ids_inbox
	ids_inbox.object.SENDer[li_row] = lmMsg[li_index].Recipient[1].Name
	ids_inbox.object.Subject[li_row] = lmMsg[li_index].Subject 
	ids_inbox.object.fecha[li_row] = lmMsg[li_index].DateReceived 
	ids_inbox.object.MessageId[li_row] = imSes.MessageID[li_index] 
	ids_inbox.object.Attachments[li_row] = li_attachments
	
	IF lmMsg[li_index].unread THEN
		ids_inbox.object.unread[li_row] = 1
	ELSE
		ids_inbox.object.unread[li_row] = 0
	END IF

	IF lmMsg[li_index].ReceiptRequested THEN 
		ids_inbox.object.receipt[li_row] = 1
	ELSE
		ids_inbox.object.receipt[li_row] = 0
	END IF
NEXT

IF ids_inbox.RowCount() < 1  THEN li_msgs = 0		// no hay mensajes

RETURN li_msgs
end function

public function string of_send_mail (string as_name, string as_address, string as_subject, string as_message);String	ls_rc

imMsg.Recipient[1].Name = as_name
imMsg.Recipient[1].Address = as_address
imMsg.Subject	= as_subject
imMsg.notetext = as_message
imMsg.Recipient[1].RecipientType = mailTo!

imRet = imSes.mailsend ( imMsg )

ls_rc = of_error(imRet)

RETURN ls_rc

end function

public function string of_logon ();String	ls_rc

imSes = create mailSession
imRet = imSes.mailLogon ( mailNewSession! )

ls_rc = of_error(imRet)

RETURN ls_rc

end function

public function boolean of_create_pdf (datastore ads_obj, string as_path);return invo_pdf.of_create_pdf(ads_obj, as_path)

end function

public function boolean of_create_pdf (datawindow adw_report, string as_path);return invo_pdf.of_create_pdf(adw_report, as_path)
end function

public function boolean of_create_pdf (datastore ads_obj, string as_path, integer ai_type_export_pdf);return invo_pdf.of_create_pdf(ads_obj, as_path, ai_type_export_pdf)
end function

public function boolean of_create_pdf (datawindow adw_report, string as_path, integer ai_type_export_pdf);return invo_pdf.of_create_pdf(adw_report, as_path, ai_type_export_pdf)
end function

public function boolean of_send (n_cst_emailmessage invo_msg);return true
end function

on n_cst_email.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_email.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_inbox = Create u_ds_base

ids_inbox.DataObject = 'd_email_inbox'

ids_inbox.SetTransObject( SQLCA )

invo_pdf = create n_cst_pdf

invo_pdf.of_load_param()

end event

event destructor;Destroy ids_inbox
destroy invo_pdf
end event

