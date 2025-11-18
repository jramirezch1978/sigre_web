$PBExportHeader$w_rpt_factura_exportacion.srw
forward
global type w_rpt_factura_exportacion from w_rpt
end type
type dw_report from u_dw_rpt within w_rpt_factura_exportacion
end type
end forward

global type w_rpt_factura_exportacion from w_rpt
integer x = 256
integer y = 348
integer width = 3387
integer height = 2152
string title = "Factura de Exportación "
string menuname = "m_impresion"
long backcolor = 12632256
dw_report dw_report
end type
global w_rpt_factura_exportacion w_rpt_factura_exportacion

type variables
String is_tipo_doc, is_nro_doc
end variables

on w_rpt_factura_exportacion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rpt_factura_exportacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

//dw_report.object.desc_forma_pago.visible  = false
//dw_report.object.incoterm.visible  = true
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

type dw_report from u_dw_rpt within w_rpt_factura_exportacion
integer width = 3241
integer height = 1884
boolean bringtotop = true
string dataobject = "d_rpt_factura_exportacion_tbl"
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

