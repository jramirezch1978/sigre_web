$PBExportHeader$w_preview_email.srw
forward
global type w_preview_email from window
end type
type sle_subject from singlelineedit within w_preview_email
end type
type rb_pdf from radiobutton within w_preview_email
end type
type rb_excel from radiobutton within w_preview_email
end type
type rb_html from radiobutton within w_preview_email
end type
type st_1 from statictext within w_preview_email
end type
type mle_1 from multilineedit within w_preview_email
end type
type pb_2 from picturebutton within w_preview_email
end type
type pb_1 from picturebutton within w_preview_email
end type
type gb_1 from groupbox within w_preview_email
end type
type gb_2 from groupbox within w_preview_email
end type
end forward

global type w_preview_email from window
integer width = 2519
integer height = 1308
boolean titlebar = true
string title = "Envio de orden de compra"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
sle_subject sle_subject
rb_pdf rb_pdf
rb_excel rb_excel
rb_html rb_html
st_1 st_1
mle_1 mle_1
pb_2 pb_2
pb_1 pb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_preview_email w_preview_email

type variables
u_dw_abc			idw_report
str_parametros istr_param
end variables

on w_preview_email.create
this.sle_subject=create sle_subject
this.rb_pdf=create rb_pdf
this.rb_excel=create rb_excel
this.rb_html=create rb_html
this.st_1=create st_1
this.mle_1=create mle_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.sle_subject,&
this.rb_pdf,&
this.rb_excel,&
this.rb_html,&
this.st_1,&
this.mle_1,&
this.pb_2,&
this.pb_1,&
this.gb_1,&
this.gb_2}
end on

on w_preview_email.destroy
destroy(this.sle_subject)
destroy(this.rb_pdf)
destroy(this.rb_excel)
destroy(this.rb_html)
destroy(this.st_1)
destroy(this.mle_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;if not IsValid(Message.PowerObjectParm) or IsNull(Message.PowerObjectParm) then
	MessageBox('Error', 'No ha especificado parámetros')
	post event close()
	return
end if

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Error', 'Parametros ingresados no son del tipo correcto')
	post event close()
	return
end if

istr_param = message.powerobjectparm

idw_report = istr_param.dw_report
sle_subject.text = istr_param.subject
end event

event close;istr_param.titulo = 's'
closeWithReturn( this, istr_param)
end event

type sle_subject from singlelineedit within w_preview_email
integer x = 32
integer y = 236
integer width = 2414
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;istr_param.subject = trim(this.text)
end event

type rb_pdf from radiobutton within w_preview_email
integer x = 1737
integer y = 60
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PDF"
boolean checked = true
end type

type rb_excel from radiobutton within w_preview_email
integer x = 1047
integer y = 60
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Excel"
end type

type rb_html from radiobutton within w_preview_email
integer x = 357
integer y = 60
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "HTML"
end type

type st_1 from statictext within w_preview_email
integer y = 364
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mensaje:"
boolean focusrectangle = false
end type

type mle_1 from multilineedit within w_preview_email
integer x = 5
integer y = 448
integer width = 2482
integer height = 564
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
boolean ignoredefaultbutton = true
end type

type pb_2 from picturebutton within w_preview_email
integer x = 1326
integer y = 1028
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Close_up.bmp"
alignment htextalign = left!
end type

event clicked;istr_param.titulo = 's'
closeWithReturn( parent, istr_param)
end event

type pb_1 from picturebutton within w_preview_email
integer x = 933
integer y = 1028
integer width = 325
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\mail_up.bmp"
alignment htextalign = left!
end type

event clicked;String 		ls_name, ls_address, ls_subject, ls_note
String 		ls_path, ls_file
Long 			ll_row
n_cst_email	lnv_email

lnv_email = CREATE n_cst_email

	ls_file = 'test'
	ls_path = 'c:'
	
	try
			if idw_report.RowCount() = 0 then
				MessageBox('Error', 'El documento no tiene registros, por favor verifique')
				return
			end if
		
			if rb_html.checked then
				ls_file += '.html'
				ls_path += '\' + ls_file
				
				lnv_email.of_create_html(idw_report, ls_path)

			elseif rb_pdf.checked then
				ls_file += '.pdf'
				ls_path += '\' + ls_file
				if not lnv_email.of_create_pdf( idw_report, ls_path) then return
				
			elseif rb_excel.checked then
				ls_file += '.xls'
				ls_path += '\' + ls_file
				//uf_save_dw_as_excel ( idw_report, ls_path )
			end if
			
			// Si ha espeicificado un proveedor entonces busco el nombre y el email
			//del proveedor
			if not isNull(istr_param.s_proveedor) and trim(istr_param.s_proveedor) <> '' then
				Select trim(nom_proveedor), trim(email)
					into :ls_name, :ls_address 
				from proveedor
				where proveedor = :istr_param.s_proveedor;
				
				if SQLCA.SQlCode = 100 then
					Messagebox( "Error", "El código de proveedor " + istr_param.s_proveedor &
						+ " no existe, por favor verifique", Exclamation!)
					return
				end if
				
				IF isnull(ls_address) or trim( ls_address) = '' then
					Messagebox( "Error", "Defina direccion de correo al proveedor " &
						+ istr_param.s_proveedor, Exclamation!)
					Return
				end if
			else
				// De lo contrario entonces obtengo el email y la direccion del istr_param
				ls_name = istr_param.s_NombreEmail
				ls_address = istr_param.s_Email
				
				IF isnull(ls_address) or trim( ls_address) = '' then
					Messagebox( "Error", "No ha definido la dirección email para envío de correo, " &
						+ "por favor verifique", Exclamation!)
					Return
				end if
				
				
			end if
			
			lnv_email.of_logon()
			ls_subject = istr_param.subject
			ls_note = mle_1.text
			lnv_email.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
			lnv_email.of_logoff()
			
			istr_param.titulo = 's'
			closeWithReturn( parent, istr_param)

	catch (Exception ex)
		MessageBox('Error de exception ' + ex.ClassName(), 'Mensaje de la exception: ' + ex.getMessage(), StopSign!)
	finally
		Destroy lnv_email
	end try


end event

type gb_1 from groupbox within w_preview_email
integer y = 4
integer width = 2482
integer height = 148
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato"
end type

type gb_2 from groupbox within w_preview_email
integer y = 160
integer width = 2482
integer height = 204
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Subject"
end type

