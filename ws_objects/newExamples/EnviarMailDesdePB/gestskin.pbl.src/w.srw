$PBExportHeader$w.srw
forward
global type w from window
end type
type cb_1 from commandbutton within w
end type
end forward

global type w from window
integer width = 1051
integer height = 460
boolean titlebar = true
string title = "Carlos Johnny Vera Garcia - Enviar E-mail"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
end type
global w w

on w.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on w.destroy
destroy(this.cb_1)
end on

event open;SetPointer(HourGlass!)


end event

type cb_1 from commandbutton within w
integer x = 343
integer y = 108
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Enviar E-mail"
end type

event clicked;// Carlos Vera Garcia
mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailFileDescription mAttach

// Inicio Adjuntando archivo
mAttach.FileType = mailAttach!
mAttach.PathName = 'C:\sql.ini'
mAttach.FileName = 'sql.ini'
mAttach.Position = len(mMsg.notetext) - 1
mMsg.AttachmentFile[1] = mAttach
mMsg.AttachmentFile[2] = mAttach
// Fin

// Inicio Inisiando session
mSes = create mailSession
mRet = mSes.mailLogon(mailNewSession!)

IF mRet <> mailReturnSuccess! THEN
    MessageBox("Mail", 'No ha inisiado session en su correo ')
    RETURN
END IF
// Fin

// Inicio Armando correo
mMsg.Subject = 'CVG'
mMsg.NoteText = 'HOLA CARLOS'

mMsg.Recipient[1].name = 'info@calzadocaley.com'
mMsg.Recipient[2].name = 'calzadocaley@hotmail.com'
mMsg.Recipient[2].recipientType = mailbcc! //mailto!, mailcc!, mailbcc!
// Fin 

// Inicio Abriendo libreta de direcciones
mRet = mSes.mailAddress ( mMsg )
If mRet = mailReturnUserAbort! Then 
	MessageBox("Enviando Mail", 'Usuario cancelo el envio')	
	Return
End If
// Fin

// Enviando Correo
mRet = mSes.mailSend(mMsg)
IF mRet <> mailReturnSuccess! THEN
    MessageBox("Enviando Mail", 'Mail no enviado')
    RETURN
END IF
// Fin 

// Inicio Cerrando session
mSes.mailLogoff()
// Fin 

// Inicio Destruyendo session
DESTROY mSes
// Fin 
MessageBox("Enviando Mail", 'Mail enviado satisfactoriamente')	


end event

