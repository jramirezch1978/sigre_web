$PBExportHeader$w_ve300_orden_venta_frm.srw
forward
global type w_ve300_orden_venta_frm from w_rpt
end type
type rb_3 from radiobutton within w_ve300_orden_venta_frm
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
integer width = 2432
integer height = 1340
string title = "Formato de orden de Venta (VE300)"
string menuname = "m_reporte"
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
dw_report dw_report
end type
global w_ve300_orden_venta_frm w_ve300_orden_venta_frm

type variables
String 			is_cod_origen, is_nro_oc

end variables

on w_ve300_orden_venta_frm.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.dw_report
end on

on w_ve300_orden_venta_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;if gs_empresa = 'CANAGRANDE' then
	rb_3.checked = true
end if

istr_rep = message.powerobjectparm

is_cod_origen = istr_rep.string1
is_nro_oc     = istr_rep.string2

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()



// ii_help = 101           // help topic


end event

event ue_retrieve;string 			ls_ruc, ls_nom_empresa, ls_direccion, ls_email, ls_telefono, &
					ls_firma_digital, ls_cod_usr
str_parametros	lstr_param

Select nombre, ruc, dir_calle
	into :ls_nom_empresa, :ls_ruc, :ls_direccion
from empresa
where SIGLA = substr(:gs_empresa,1,8);

Select email, telefono
	into :ls_email, :ls_telefono
from origen
where cod_origen = :gs_origen;

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc

if rb_3.checked then
	
	dw_report.dataobject = 'd_ord_venta_etiquetera_ff'
	dw_report.settransobject(sqlca)
	dw_report.Retrieve(is_nro_oc)
	
elseif rb_2.checked then
	
	if istr_rep.string3 = 'E' then
		
		Open(w_abc_select_language)
		lstr_param = Message.PowerObjectParm
	
		if lstr_param.i_Return < 1 or lstr_param.language = -1 then 
			Post Event Close()
			return
		end if
	
		if upper(gs_empresa) = 'SEAFROST' then
			if lstr_param.language = 2 then
				dw_report.dataObject = 'd_rpt_ov_eng_seafrost_exp_tbl'
			else
				dw_report.dataobject = 'd_rpt_ov_esp_seafrost_exp_tbl'
			end if
		else
			if lstr_param.language = 2 then
				dw_report.dataObject = 'd_rpt_ov_eng_exp_tbl'
			else
				dw_report.dataobject = 'd_rpt_ov_esp_exp_tbl'
			end if
		end if
	
	else
		if upper(gs_empresa) = 'SEAFROST' then
			dw_report.dataobject = 'd_rpt_orden_venta_seafrost_tbl'
		else
			dw_report.dataobject = 'd_rpt_orden_venta_tbl'
		end if
	end if
	
	dw_report.settransobject(sqlca)
	dw_report.Retrieve(is_cod_origen, is_nro_oc)
	
	idw_1.object.t_ruc.text 		= ls_ruc
	idw_1.object.t_empresa.text	= ls_nom_empresa
	idw_1.object.t_direccion.text	= gnvo_app.of_direccion_origen(is_cod_origen)	
	idw_1.object.t_email.text		= "Email: "+ls_email
	idw_1.object.t_telefono.text	= "Telef: "+ls_telefono
	
elseif rb_1.checked then
	
	dw_report.dataobject = 'd_rpt_orden_venta'
	dw_report.settransobject(sqlca)
	dw_report.Retrieve(is_cod_origen, is_nro_oc)	
	
end if

if idw_1.of_ExistsPictureName('p_logo') then
	idw_1.Object.p_logo.filename  = gs_logo
end if

// Firma digital
if dw_report.RowCount( ) > 0 then
	if dw_report.of_existecampo( "cod_usr") then
		ls_cod_usr = dw_report.object.cod_usr [1]
		ls_firma_digital  = ProfileString (gs_inifile, "Firma_digital_" + gs_empresa, ls_cod_usr, "")
		
		// Coloco la firma escaneada del representante 
		if ls_firma_digital <> "" then
			
			if dw_report.of_ExistsPictureName("p_firma") then
				if Not FileExists(ls_firma_digital) then
					MessageBox('Error', 'No existe el archivo ' + ls_firma_digital + ", por favor verifique!!", StopSign!)
					return
				end if
			
				dw_report.object.p_firma.filename = ls_firma_digital
			end if
			
			
		end if
	end if
end if


idw_1.Visible = True

ib_preview = false
event ue_preview()

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

type rb_3 from radiobutton within w_ve300_orden_venta_frm
integer y = 20
integer width = 594
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Para Etiquetera"
end type

event clicked;parent.event ue_Retrieve()
end event

type rb_2 from radiobutton within w_ve300_orden_venta_frm
integer x = 631
integer y = 20
integer width = 594
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Completo"
boolean checked = true
end type

event clicked;parent.event ue_Retrieve()
end event

type rb_1 from radiobutton within w_ve300_orden_venta_frm
integer x = 1262
integer y = 24
integer width = 594
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Pre - Impreso"
end type

event clicked;parent.event ue_Retrieve()
end event

type dw_report from u_dw_rpt within w_ve300_orden_venta_frm
integer y = 128
integer width = 2222
integer height = 924
boolean bringtotop = true
string dataobject = "d_rpt_orden_venta"
end type

event retrievestart;//// ejecuta store procedure para mostrar totales
//DECLARE PB_USP_RPT_ORDEN_COMPRA PROCEDURE FOR USP_CMP_ORDEN_COMPRA( :is_cod_origen, :is_nro_oc);
//EXECUTE PB_USP_RPT_ORDEN_COMPRA;
//IF SQLCA.SQLCODE = -1 THEN
//	Messagebox( "Error", "Al ejecutar Store Procedure")
//	Return
//END IF 
end event

