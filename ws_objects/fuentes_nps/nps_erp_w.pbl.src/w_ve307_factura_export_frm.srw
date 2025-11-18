$PBExportHeader$w_ve307_factura_export_frm.srw
forward
global type w_ve307_factura_export_frm from w_rpt
end type
type rb_fpago from radiobutton within w_ve307_factura_export_frm
end type
type rb_incoterm from radiobutton within w_ve307_factura_export_frm
end type
type st_1 from statictext within w_ve307_factura_export_frm
end type
type dw_report from u_dw_rpt within w_ve307_factura_export_frm
end type
end forward

global type w_ve307_factura_export_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3387
integer height = 2152
string title = "Formato de orden de Venta (VE307)"
string menuname = "m_impresion"
long backcolor = 12632256
rb_fpago rb_fpago
rb_incoterm rb_incoterm
st_1 st_1
dw_report dw_report
end type
global w_ve307_factura_export_frm w_ve307_factura_export_frm

type variables
String is_tipo_doc, is_nro_doc
end variables

on w_ve307_factura_export_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_fpago=create rb_fpago
this.rb_incoterm=create rb_incoterm
this.st_1=create st_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_fpago
this.Control[iCurrent+2]=this.rb_incoterm
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_report
end on

on w_ve307_factura_export_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_fpago)
destroy(this.rb_incoterm)
destroy(this.st_1)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;string ls_ruc, ls_nom_empresa
str_parametros lstr_rep

lstr_rep = message.powerobjectparm

is_tipo_doc = lstr_rep.string1
is_nro_doc  = lstr_rep.string2

dw_report.Retrieve(is_tipo_doc, is_nro_doc)
idw_1.Visible = True
idw_1.object.datawindow.print.Orientation = 2  //Vertical
idw_1.object.Datawindow.Print.Paper.Size = 1  //Carta

dw_report.object.desc_forma_pago.visible  = false
dw_report.object.incoterm.visible  = true
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_mail_send();//
String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, &
  ls_note, ls_path, ls_prov, ls_res

n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

ls_prov = dw_report.object.proveedor[dw_report.getrow()]
// Busca nombre de proveedor
	Select nom_proveedor, email into :ls_name, :ls_address from proveedor 
	    where proveedor = :ls_prov;
	IF isnull(ls_address) or trim( ls_address) = '' then
		Messagebox( "Error", "Defina direccion de correo al proveedor", Exclamation!)
		Return
	end if
	
	ls_subject = "Orden de compra"


//ls_subject = THIS.Title
ls_path = 'c:\report.html'
ls_file = 'report.html'

//lnv_mail.of_create_html(idw_1, ls_path)
idw_1.SaveAs(ls_path, HTMLTable!, True)

lnv_mail.of_logon()
ls_res = lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
messagebox( 'email', 'se envio mail con ' + ls_res, exclamation!)
lnv_mail.of_logoff()
lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
end event

type rb_fpago from radiobutton within w_ve307_factura_export_frm
integer x = 50
integer y = 232
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Forma Pago"
end type

event clicked;if this.checked then
	rb_incoterm.checked = false
	dw_report.object.desc_forma_pago.visible  = true
	dw_report.object.incoterm.visible  			= false
end if	
end event

type rb_incoterm from radiobutton within w_ve307_factura_export_frm
integer x = 41
integer y = 124
integer width = 795
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Incoterm"
boolean checked = true
end type

event clicked;if this.checked then
	rb_fpago.checked = false
	dw_report.object.desc_forma_pago.visible  = false
	dw_report.object.incoterm.visible  = true
end if	
end event

type st_1 from statictext within w_ve307_factura_export_frm
integer x = 27
integer y = 16
integer width = 741
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Seleccione Condicion :"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_ve307_factura_export_frm
integer y = 344
integer width = 3273
integer height = 1600
boolean bringtotop = true
string dataobject = "d_abc_fact_export_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrievestart;//// ejecuta store procedure para mostrar totales
//DECLARE PB_USP_RPT_ORDEN_COMPRA PROCEDURE FOR USP_CMP_ORDEN_COMPRA( :is_cod_origen, :is_nro_oc);
//EXECUTE PB_USP_RPT_ORDEN_COMPRA;
//IF SQLCA.SQLCODE = -1 THEN
//	Messagebox( "Error", "Al ejecutar Store Procedure")
//	Return
//END IF 
end event

