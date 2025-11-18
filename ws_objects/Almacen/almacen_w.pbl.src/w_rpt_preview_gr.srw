$PBExportHeader$w_rpt_preview_gr.srw
forward
global type w_rpt_preview_gr from w_report_smpl
end type
end forward

global type w_rpt_preview_gr from w_report_smpl
integer width = 2807
integer height = 1908
string title = ""
string menuname = "m_impresion"
boolean toolbarvisible = false
end type
global w_rpt_preview_gr w_rpt_preview_gr

type variables

end variables

forward prototypes
public subroutine of_modify_dw (datawindow adw_data, string as_inifile)
end prototypes

public subroutine of_modify_dw (datawindow adw_data, string as_inifile);string 	ls_modify, ls_error
Long		ll_num_act, ll_i

if not FileExists(as_inifile) then return

ll_num_act = Long(ProfileString(as_inifile, "Total_lineas", 'Total', "0"))

for ll_i = 1 to ll_num_act
	ls_modify = ProfileString(as_inifile, "Modify", 'Linea' + string(ll_i), "")
	if ls_modify <> "" then
		ls_error = adw_data.Modify(ls_modify)
		if ls_error <> '' then
			MessageBox('Error en Modify datastore', ls_Error + ' ls_modify: ' + ls_modify)
		end if
	end if
next

end subroutine

on w_rpt_preview_gr.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_rpt_preview_gr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm

idw_1 = dw_report
idw_1.Visible = False

this.Event ue_preview()
This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String 		ls_cad1, ls_cad2, ls_inifile, ls_fileqr
Integer		li_opi
str_qrcode	lstr_qrcode

this.title = istr_rep.titulo
ls_inifile = istr_rep.inifile

dw_report.dataobject = istr_rep.dw1
dw_report.SetTransObject(sqlca)

CHOOSE CASE istr_rep.tipo 
		case '1S'
			dw_report.retrieve(istr_rep.string1)
		case '1S2S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2)
		case else
			dw_report.retrieve()
END CHOOSE

dw_report.Visible = True
dw_report.object.datawindow.print.preview = 'Yes'
dw_report.object.datawindow.print.Paper.Size = 1 //Tamaño Carta

if dw_report.of_ExistePicture("p_logo") then
	dw_report.Object.p_logo.filename = gs_logo
end if

//Genero el codigo QR
if dw_report.of_ExistePicture("p_codeqr") and dw_report.RowCount() > 0 then
	
	lstr_qrcode.tipo_doc 		= 'GR'  //Guia de Remision
	
	if dw_report.of_ExisteCampo("nro_guia") then
		lstr_qrcode.nro_doc 		= dw_report.object.nro_guia 		[1]
	else
		MessageBox('Error', 'No hay campo que represente el nro de la GUIA en el datawindow ' + dw_report.dataObject + ', por favor verifique', StopSign!)
		return 
	end if

	if dw_report.of_ExisteCampo("ruc_empresa") then
		lstr_qrcode.ruc_emisor 		= dw_report.object.ruc_empresa 		[1]
	else
		MessageBox('Error', 'No hay campo que represente el ruc del emisor en el datawindow ' + dw_report.dataObject + ', por favor verifique', StopSign!)
		return 
	end if
	
	if dw_report.of_ExisteCampo("serie") then
		lstr_qrcode.serie 			= dw_report.object.serie 				[1]
	else
		MessageBox('Error', 'No hay campo que represente la Serie de la GUIA en el datawindow ' + dw_report.dataObject + ', por favor verifique', StopSign!)
		return 
	end if

	if dw_report.of_ExisteCampo("numero") then
		lstr_qrcode.numero 			= dw_report.object.numero 			[1]
	else
		MessageBox('Error', 'No hay campo que represente el numero de la GUIA en el datawindow ' + dw_report.dataObject + ', por favor verifique', StopSign!)
		return 
	end if
	
	lstr_qrcode.tipo_doc_sunat = '09'
	lstr_qrcode.tipo_doc_ident	= dw_report.object.tipo_doc_cliente	[1]
	lstr_qrcode.nro_doc_ident 	= dw_report.object.ruc_cliente		[1]
	
	lstr_qrcode.imp_igv 		= 0
	lstr_qrcode.imp_total 	= 0
	
	if dw_report.of_ExisteCampo("fec_registro") then
		lstr_qrcode.fec_emision	= Date(dw_report.object.fec_registro 	[1])
	else
		MessageBox('Error', 'No hay campo que represente la fecha de emisión de la GUIA en el datawindow ' + dw_report.dataObject + ', por favor verifique', StopSign!)
		return 
	end if		

	//Genero el codigo QR
	ls_fileqr = gnvo_app.almacen.of_generar_qrcode( lstr_qrcode )
	
	if not IsNull(ls_fileqr) and trim(ls_fileqr) <> '' then
		dw_report.object.p_codeqr.filename = ls_fileqr
	end if
	
	//Genero el archivo PDF
	if not gnvo_app.almacen.of_generar_pdf( lstr_qrcode, dw_report ) then return

end if


if ls_inifile <> '' and Not isnull(ls_inifile) then
	of_modify_dw(dw_report, ls_inifile)
end if

end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type dw_report from w_report_smpl`dw_report within w_rpt_preview_gr
integer x = 0
integer y = 0
integer width = 2519
integer height = 1624
boolean hsplitscroll = true
end type

