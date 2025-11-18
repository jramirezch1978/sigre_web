$PBExportHeader$w_ma301_solicit_ot_acept.srw
forward
global type w_ma301_solicit_ot_acept from window
end type
type dw_1 from datawindow within w_ma301_solicit_ot_acept
end type
type cb_1 from commandbutton within w_ma301_solicit_ot_acept
end type
end forward

global type w_ma301_solicit_ot_acept from window
integer x = 823
integer y = 360
integer width = 1970
integer height = 1328
boolean titlebar = true
string title = "Confirmación de Solicitud de oden de trabajo"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
dw_1 dw_1
cb_1 cb_1
end type
global w_ma301_solicit_ot_acept w_ma301_solicit_ot_acept

type variables
String is_nro_solicitud
end variables

forward prototypes
public function string wf_subject ()
public subroutine wf_setea ()
public subroutine wf_retrieve ()
end prototypes

public function string wf_subject ();Long 	 ll_row_master
String ls_subject,ls_nro_solicitud

ll_row_master = dw_1.GetRow()
ls_nro_solicitud = dw_1.GetItemString( ll_row_master, 'nro_solicitud')
ls_subject = 'Aceptación de Sol OT: ' + ls_nro_solicitud

return ls_subject

end function

public subroutine wf_setea ();String ls_nro_solicitud


dw_1.Retrieve( ls_nro_solicitud )



end subroutine

public subroutine wf_retrieve ();dw_1.Retrieve( is_nro_solicitud )

end subroutine

on w_ma301_solicit_ot_acept.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.dw_1,&
this.cb_1}
end on

on w_ma301_solicit_ot_acept.destroy
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;f_centrar(This)
is_nro_solicitud = Message.StringParm

dw_1.SetTransObject(SQLCA)
wf_retrieve()
dw_1.SetItem( 1, 'flag_estado', '2' )



end event

type dw_1 from datawindow within w_ma301_solicit_ot_acept
integer x = 23
integer y = 188
integer width = 1911
integer height = 1040
integer taborder = 20
string dataobject = "d_abc_solicitud_orden_trabajo_ff_recha"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ma301_solicit_ot_acept
integer x = 14
integer y = 36
integer width = 768
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Enviar correo de aceptación"
end type

event clicked;/*
mailSession mSes

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

ls_archivo ="i:\pb_exe\sol_ot.HTML" 

dw_1.SaveAs(ls_archivo, HTMLTable!, FALSE)

ls_cod_usr = dw_1.GetItemString( 1, 'cod_usuario_sol')

Select email into :ls_email from usuario where cod_usr = :ls_cod_usr;
// Populate the mailMessage structure
mMsg.Subject = wf_subject()
mMsg.NoteText = 'Su solicitud de trabajo ha sido ACEPTADA'
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

close ( w_ma301_solicit_ot_acept )
*/

String ls_name, ls_address, ls_subject, ls_note, ls_path, ls_file, ls_cod_usr, ls_cencos_slc, ls_ret
Datastore 		lds_data
Long ll_row
n_cst_email		lnv_1

lnv_1 = CREATE n_cst_email

lds_data = Create DataStore
lds_data.DataObject = 'd_abc_solicitud_orden_trabajo_ff_recha'
lds_data.SetTransObject(SQLCA)
ll_row = lds_data.Retrieve(is_nro_solicitud)
ls_file = 'sol_ot.HTML'
ls_path = 'i:\pb_exe\'
//ls_file = "i:\pb_exe\sol_ot.HTML" 
ls_name = 'Marco Moran'
lnv_1.of_logon()
lnv_1.of_create_html(lds_data, ls_path)

//ls_cod_usr = dw_1.GetItemString( 1, 'cod_usuario_sol')
ls_cencos_slc = dw_1.GetItemString( 1, 'cencos_slc')

Select email, desc_cencos 
into :ls_address, :ls_name 
from centros_costo 
where cencos = :ls_cencos_slc;
	
IF isnull(ls_address) or trim( ls_address) = '' then
	ls_address = 'mmoran@cgaip.com.pe'
	Messagebox( "Error", "Centro de costo solicitante no tiene definido email", Exclamation!)
	//Return
end if

ls_subject = "Aprobacion de solicitud de orden de trabajo"
ls_note = "Solicitud de trabajo aceptada"
messagebox( ls_name, ls_Address)
messagebox( ls_file, ls_path)
ls_ret = lnv_1.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
messagebox( '', ls_ret)
lnv_1.of_logoff()
Destroy lds_data

wf_setea()
close ( w_ma301_solicit_ot_acept )
//close( parent)


end event

