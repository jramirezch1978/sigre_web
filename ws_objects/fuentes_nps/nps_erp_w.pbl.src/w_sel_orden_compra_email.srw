$PBExportHeader$w_sel_orden_compra_email.srw
forward
global type w_sel_orden_compra_email from window
end type
type st_1 from statictext within w_sel_orden_compra_email
end type
type mle_1 from multilineedit within w_sel_orden_compra_email
end type
type pb_2 from picturebutton within w_sel_orden_compra_email
end type
type pb_1 from picturebutton within w_sel_orden_compra_email
end type
end forward

global type w_sel_orden_compra_email from window
integer width = 1851
integer height = 788
boolean titlebar = true
string title = "Envio de orden de compra"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_1 st_1
mle_1 mle_1
pb_2 pb_2
pb_1 pb_1
end type
global w_sel_orden_compra_email w_sel_orden_compra_email

type variables
String is_origen, is_nro, is_prov
end variables

on w_sel_orden_compra_email.create
this.st_1=create st_1
this.mle_1=create mle_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.Control[]={this.st_1,&
this.mle_1,&
this.pb_2,&
this.pb_1}
end on

on w_sel_orden_compra_email.destroy
destroy(this.st_1)
destroy(this.mle_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event open;//f_centrar( this)
str_parametros lst_par

lst_par = message.powerobjectparm

is_origen = lst_par.string1
is_nro 	 = lst_par.string2
is_prov 	 = lst_par.string3
end event

type st_1 from statictext within w_sel_orden_compra_email
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

type mle_1 from multilineedit within w_sel_orden_compra_email
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

type pb_2 from picturebutton within w_sel_orden_compra_email
integer x = 942
integer y = 488
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\source\Bmp\Close_up.bmp"
alignment htextalign = left!
end type

event clicked;close( parent)
end event

type pb_1 from picturebutton within w_sel_orden_compra_email
integer x = 549
integer y = 488
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

event clicked;String ls_name, ls_address, ls_subject, ls_note
String 	ls_path, ls_file
Datastore	lds_data
Long ll_row
n_cst_email	lnv_1

lnv_1 = CREATE n_cst_email

	lds_data = Create DataStore
	lds_data.DataObject = 'd_rpt_orden_compra_cab' 
	lds_data.SetTransObject(SQLCA)
	ll_row = lds_data.Retrieve(is_origen, is_nro)
	lds_data.object.p_logo.filename = gnvo_app.is_logo
	
	ls_file = 'test.html'
	ls_path = '\pb_exe\test.html'
	lnv_1.of_logon()
	lnv_1.of_create_html(lds_data, ls_path)
	
	// Busca nombre de proveedor
	Select nom_proveedor, email into :ls_name, :ls_address from proveedor 
	    where proveedor = :is_prov;
	IF isnull(ls_address) or trim( ls_address) = '' then
		Messagebox( "Error", "Defina direccion de correo al proveedor", Exclamation!)
		Return
	end if
	
	ls_subject = "Orden de compra"
	ls_note = mle_1.text
	lnv_1.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
	lnv_1.of_logoff()
	Destroy lds_data
	close( parent)

end event

