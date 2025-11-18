$PBExportHeader$w_ve300_orden_venta_frm.srw
forward
global type w_ve300_orden_venta_frm from w_rpt
end type
type rb_2 from radiobutton within w_ve300_orden_venta_frm
end type
type rb_1 from radiobutton within w_ve300_orden_venta_frm
end type
type dw_report from u_dw_rpt within w_ve300_orden_venta_frm
end type
end forward

global type w_ve300_orden_venta_frm from w_rpt
integer x = 256
integer y = 348
integer width = 1499
integer height = 1008
string title = "Formato de orden de Venta (VE300)"
string menuname = "m_impresion"
long backcolor = 67108864
rb_2 rb_2
rb_1 rb_1
dw_report dw_report
end type
global w_ve300_orden_venta_frm w_ve300_orden_venta_frm

type variables
String is_cod_origen, is_nro_oc
end variables

on w_ve300_orden_venta_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.dw_report
end on

on w_ve300_orden_venta_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
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

is_cod_origen = lstr_rep.string1
is_nro_oc     = lstr_rep.string2

Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = substr(:gnvo_app.invo_empresa.is_empresa,1,8);

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc

dw_report.Retrieve(is_cod_origen, is_nro_oc)
idw_1.Visible = True
ib_preview = false
event ue_preview()
//idw_1.Object.p_logo.filename  = gnvo_app.is_logo
//idw_1.object.t_direccion.text = f_direccion_empresa(gs_origen)
//idw_1.object.t_telefono.text  = f_telefono_empresa(gs_origen)
//idw_1.object.t_email.text  	= f_email_empresa(gs_origen)
//idw_1.object.t_ruc.text 		= ls_ruc
//idw_1.object.t_empresa.text	= ls_nom_empresa
//idw_1.object.t_tel_prov.text 	= f_telefono_codrel(dw_report.object.proveedor[dw_report.getrow()], 't')
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

type rb_2 from radiobutton within w_ve300_orden_venta_frm
integer x = 768
integer y = 32
integer width = 594
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Completo"
end type

event clicked;string ls_ruc, ls_nom_empresa
str_parametros lstr_rep

lstr_rep = message.powerobjectparm

is_cod_origen = lstr_rep.string1
is_nro_oc     = lstr_rep.string2

Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = substr(:gnvo_app.invo_empresa.is_empresa,1,8);

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc

dw_report.dataobject = 'd_rpt_orden_venta_cab'
dw_report.settransobject(sqlca)
dw_report.Retrieve(is_cod_origen, is_nro_oc)
idw_1.Visible = True
idw_1.Object.p_logo.filename  = gnvo_app.is_logo
idw_1.object.t_ruc.text 		= ls_ruc
idw_1.object.t_empresa.text	= ls_nom_empresa

ib_preview = false
event ue_preview()
end event

type rb_1 from radiobutton within w_ve300_orden_venta_frm
integer x = 37
integer y = 32
integer width = 677
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Pre - Impreso"
boolean checked = true
end type

event clicked;string ls_ruc, ls_nom_empresa
str_parametros lstr_rep

lstr_rep = message.powerobjectparm

is_cod_origen = lstr_rep.string1
is_nro_oc     = lstr_rep.string2

Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = substr(:gnvo_app.invo_empresa.is_empresa,1,8);

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc

dw_report.dataobject = 'd_rpt_orden_venta'
dw_report.settransobject(sqlca)
dw_report.Retrieve(is_cod_origen, is_nro_oc)
idw_1.Visible = True

ib_preview = false
event ue_preview()
end event

type dw_report from u_dw_rpt within w_ve300_orden_venta_frm
integer x = 37
integer y = 160
integer width = 1358
integer height = 580
boolean bringtotop = true
string dataobject = "d_rpt_orden_venta"
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

