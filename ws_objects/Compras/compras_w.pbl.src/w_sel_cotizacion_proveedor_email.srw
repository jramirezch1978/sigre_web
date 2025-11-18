$PBExportHeader$w_sel_cotizacion_proveedor_email.srw
forward
global type w_sel_cotizacion_proveedor_email from window
end type
type st_1 from statictext within w_sel_cotizacion_proveedor_email
end type
type mle_1 from multilineedit within w_sel_cotizacion_proveedor_email
end type
type pb_2 from picturebutton within w_sel_cotizacion_proveedor_email
end type
type pb_1 from picturebutton within w_sel_cotizacion_proveedor_email
end type
type dw_1 from datawindow within w_sel_cotizacion_proveedor_email
end type
end forward

global type w_sel_cotizacion_proveedor_email from window
integer width = 1851
integer height = 1256
boolean titlebar = true
string title = "Proveedores a cotizar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_1 st_1
mle_1 mle_1
pb_2 pb_2
pb_1 pb_1
dw_1 dw_1
end type
global w_sel_cotizacion_proveedor_email w_sel_cotizacion_proveedor_email

type variables
str_parametros istr_par
end variables

on w_sel_cotizacion_proveedor_email.create
this.st_1=create st_1
this.mle_1=create mle_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.Control[]={this.st_1,&
this.mle_1,&
this.pb_2,&
this.pb_1,&
this.dw_1}
end on

on w_sel_cotizacion_proveedor_email.destroy
destroy(this.st_1)
destroy(this.mle_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_1)
end on

event open;f_centrar( this)
str_parametros lst_par

lst_par = message.powerobjectparm

istr_par.string1 = lst_par.string1
istr_par.string2 = lst_par.string2

dw_1.SetTransObject(sqlca)
dw_1.retrieve( lst_par.string1, lst_par.string2)
end event

type st_1 from statictext within w_sel_cotizacion_proveedor_email
integer x = 23
integer y = 16
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

type mle_1 from multilineedit within w_sel_cotizacion_proveedor_email
integer x = 23
integer y = 88
integer width = 1801
integer height = 324
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type pb_2 from picturebutton within w_sel_cotizacion_proveedor_email
integer x = 1024
integer y = 972
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\source\Bmp\Close_up.bmp"
alignment htextalign = left!
end type

event clicked;close( parent)
end event

type pb_1 from picturebutton within w_sel_cotizacion_proveedor_email
integer x = 631
integer y = 972
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\Bmp\mail_up.bmp"
alignment htextalign = left!
end type

event clicked;String ls_name, ls_address, ls_subject, ls_note, ls_origen, ls_nro, ls_prov
String 	ls_path, ls_file
Datastore	lds_data
Long ll_row
n_cst_email	lnv_1

dw_1.AcceptText()

lnv_1 = CREATE n_cst_email
if dw_1.getrow() > 0 then
	ls_prov = dw_1.object.proveedor[dw_1.getrow()]	
	ls_origen = istr_par.string1
	ls_nro = istr_par.string2

	istr_par.string3 = ls_prov
	lds_data = Create DataStore
	lds_data.DataObject = 'd_rpt_cotizacion_cab' 
	lds_data.SetTransObject(SQLCA)
	ll_row = lds_data.Retrieve(ls_origen, ls_nro, ls_prov)
	
	ls_file = 'test.html'
	ls_path = 'c:\manuales\test.html'
	lnv_1.of_logon()
	lnv_1.of_create_html(lds_data, ls_path)
	
	ls_name = dw_1.object.nom_proveedor[dw_1.getrow()]
	ls_address = dw_1.object.email[dw_1.getrow()]
	IF isnull(ls_address) or trim( ls_address) = '' then
		Messagebox( "Error", "Ingrese direccion de correo", Exclamation!)
		Return
	end if
	
	ls_subject = "Cotizacion"
	ls_note = mle_1.text
	lnv_1.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
	lnv_1.of_logoff()
	Destroy lds_data
	close( parent)
end if
end event

type dw_1 from datawindow within w_sel_cotizacion_proveedor_email
integer x = 9
integer y = 424
integer width = 1801
integer height = 484
integer taborder = 10
string title = "none"
string dataobject = "d_sel_cotizacion_proveedor"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

