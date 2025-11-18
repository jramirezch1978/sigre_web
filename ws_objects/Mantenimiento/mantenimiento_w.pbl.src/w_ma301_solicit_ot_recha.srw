$PBExportHeader$w_ma301_solicit_ot_recha.srw
forward
global type w_ma301_solicit_ot_recha from window
end type
type dw_1 from datawindow within w_ma301_solicit_ot_recha
end type
type cb_1 from commandbutton within w_ma301_solicit_ot_recha
end type
type sle_respuesta from singlelineedit within w_ma301_solicit_ot_recha
end type
type st_1 from statictext within w_ma301_solicit_ot_recha
end type
end forward

global type w_ma301_solicit_ot_recha from window
integer x = 823
integer y = 360
integer width = 2043
integer height = 1544
boolean titlebar = true
string title = "Rechazar solicitud de oden de trabajo"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
dw_1 dw_1
cb_1 cb_1
sle_respuesta sle_respuesta
st_1 st_1
end type
global w_ma301_solicit_ot_recha w_ma301_solicit_ot_recha

forward prototypes
public function string wf_retrieve ()
public subroutine wf_setea ()
public function string wf_subject ()
end prototypes

public function string wf_retrieve ();long ll_row_master
String ls_nro_solicitud

ll_row_master    = w_ma301_solicit_ot.dw_master.GetRow()
ls_nro_solicitud = w_ma301_solicit_ot.dw_master.GetItemString( ll_row_master, 'nro_solicitud')
dw_1.Retrieve( ls_nro_solicitud )

return ls_nro_solicitud

end function

public subroutine wf_setea ();long   ll_row_master
String ls_nro_solicitud

ll_row_master = w_ma301_solicit_ot.dw_master.GetRow()
w_ma301_solicit_ot.dw_master.SetItem( ll_row_master, 'respuesta', sle_respuesta.Text )
w_ma301_solicit_ot.dw_master.SetItem( ll_row_master, 'flag_estado', '3' )
w_ma301_solicit_ot.dw_master.ii_update = 1
dw_1.Retrieve( ls_nro_solicitud )


end subroutine

public function string wf_subject ();long ll_row_master
String ls_nro_solicitud
string ls_subject

ll_row_master = dw_1.GetRow()
ls_nro_solicitud = dw_1.GetItemString( ll_row_master, 'nro_solicitud')
ls_subject = 'Rechazo de Sol OT: ' + ls_nro_solicitud

return ls_subject

end function

on w_ma301_solicit_ot_recha.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.sle_respuesta=create sle_respuesta
this.st_1=create st_1
this.Control[]={this.dw_1,&
this.cb_1,&
this.sle_respuesta,&
this.st_1}
end on

on w_ma301_solicit_ot_recha.destroy
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.sle_respuesta)
destroy(this.st_1)
end on

event open;f_centrar(This)
dw_1.SetTransObject(SQLCA)
wf_retrieve()
sle_respuesta.Text = dw_1.GetItemString( 1, 'respuesta') 
dw_1.SetItem( 1, 'flag_estado', '3' )



end event

type dw_1 from datawindow within w_ma301_solicit_ot_recha
integer x = 82
integer y = 396
integer width = 1911
integer height = 1040
integer taborder = 30
string dataobject = "d_abc_solicitud_orden_trabajo_ff_recha"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ma301_solicit_ot_recha
integer x = 73
integer y = 244
integer width = 1106
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Rechazar Solicitud de Orden de Trabajo"
end type

event clicked;mailSession mSes

mailReturnCode mRet
mailMessage mMsg
// Create a mail session
mSes = create mailSession
// Log on to the session
mRet = mSes.mailLogon(mailNewSession!)
IF mRet <> mailReturnSuccess! THEN
   MessageBox("Mail", 'Logon failed.')
   RETURN
END IF
// Generar el atachment
String ls_archivo, ls_email, ls_cod_usr
dw_1.SetItem( 1, 'respuesta', sle_respuesta.Text  )

ls_archivo ="i:\pb_exe\sol_ot.HTML" 
dw_1.SaveAs(ls_archivo, HTMLTable!, FALSE)
ls_cod_usr = dw_1.GetItemString( 1, 'cod_usuario_sol')
Select email into :ls_email from usuario where cod_usr = :ls_cod_usr;
// Populate the mailMessage structure
mMsg.Subject = wf_subject()
mMsg.NoteText = 'Su solicitud de trabajo ha sido rechazada'
mMsg.Recipient[1].name = ls_email //'emorante@cgaip.com.pe'
mMsg.AttachmentFile[1].FileType = mailAttach!
mMsg.AttachmentFile[1].Filename = ls_archivo
mMsg.AttachmentFile[1].Pathname = ls_archivo

// Send the mail
mRet = mSes.mailSend(mMsg)

IF mRet <> mailReturnSuccess! THEN
   MessageBox("Mail Send", 'Mail not sent')
   RETURN
END IF
mSes.mailLogoff()
DESTROY mSes
// Cerrando 
wf_setea()
close ( w_ma301_solicit_ot_recha )
end event

type sle_respuesta from singlelineedit within w_ma301_solicit_ot_recha
integer x = 78
integer y = 120
integer width = 1751
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ma301_solicit_ot_recha
integer x = 78
integer y = 40
integer width = 334
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Respuesta :"
boolean focusrectangle = false
end type

