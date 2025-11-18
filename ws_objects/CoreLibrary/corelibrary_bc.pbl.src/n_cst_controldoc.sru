$PBExportHeader$n_cst_controldoc.sru
forward
global type n_cst_controldoc from nonvisualobject
end type
end forward

global type n_cst_controldoc from nonvisualobject autoinstantiate
end type

type variables
n_cst_serversmtp invo_serversmtp

end variables

forward prototypes
public function boolean of_enviar_email (datawindow adw_datos, n_cst_usuario anvo_usr_org, n_cst_usuario anvo_usr_dst) throws exception
end prototypes

public function boolean of_enviar_email (datawindow adw_datos, n_cst_usuario anvo_usr_org, n_cst_usuario anvo_usr_dst) throws exception;Long 		ll_i
string	ls_html_body, ls_subject
decimal	ldc_base_imponible, ldc_impuestos, ldc_total_importe

if not anvo_usr_org.ib_isOk then return false

//Cargo los datos, los datos se cargan una sola vez nada mas
invo_serversmtp.of_load() 

//Si no tiene email el usuario destinatario, entonces no envio el email
if Isnull(anvo_usr_dst.is_email) or trim(anvo_usr_dst.is_email) = '' then return true


//Si no hay documentos que le han trasnferido entonces no hay email que enviar
if adw_datos.RowCount() = 0 then return true

ls_html_body = "<body bgcolor='#FFFFFF' topmargin=8 leftmargin=8>"
ls_html_body += "Estimado Sr(ta) " + anvo_usr_dst.is_nombre + ".<br/><br/>"

ls_html_body += "EL usuario " + anvo_usr_org.is_nombre + " le ha transferido " &
				 + string(adw_datos.RowCount()) + " documentos los cuales se listan a continuación:" &
				 + "<br/><br/><br/>"

ls_html_body += "<table border=1px cellpadding=0px cellspacing=0px>"
ls_html_body += "<tr >"
ls_html_body += "<td align='center' valign='middle' ><strong>Numero Registro</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Codigo Relacion</strong></td>"
ls_html_body += "<td width='200px' align='center' valign='middle' ><strong>Razón Social o Nombre Comercial</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>RUC / DNI</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Tipo Doc</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Numero Documento</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Fecha recepción</strong></td>"
ls_html_body += "<td align='center' valign='middle'  width=200px><strong>Glosa del documento</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Moneda</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Base Imponible</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Impuestos</strong></td>"
ls_html_body += "<td align='center' valign='middle' ><strong>Importe Total</strong></td>"
ls_html_body += "</tr>"

for ll_i = 1 to adw_datos.RowCount()
	ldc_base_imponible 	= dec(adw_datos.object.base_imponible	[ll_i])
	ldc_impuestos 			= dec(adw_datos.object.impuestos			[ll_i])
	ldc_total_importe		= dec(adw_datos.object.total_importe	[ll_i])
	
	ls_html_body += "<tr>"
	ls_html_body += "<td align='center' valign='middle'>" + adw_datos.object.nro_registro	[ll_i] + "</td>"
	ls_html_body += "<td align='center' valign='middle'>" + adw_datos.object.cod_relacion	[ll_i] + "</td>"
	ls_html_body += "<td align='left' valign='middle'>" + adw_datos.object.nom_proveedor	[ll_i] + "</td>"
	ls_html_body += "<td align='center' valign='middle'>" + adw_datos.object.ruc_dni			[ll_i] + "</td>"
	ls_html_body += "<td align='center' valign='middle'>" + adw_datos.object.Tipo_Doc			[ll_i] + "</td>"
	ls_html_body += "<td align='center' valign='middle'>" + adw_datos.object.nro_doc			[ll_i] + "</td>"
	ls_html_body += "<td align='center' valign='middle'>" + string(date(adw_datos.object.fecha_recepcion	[ll_i]), 'dd/mm/yyyy') + "</td>"
	ls_html_body += "<td align='left' valign='middle'>" + adw_datos.object.observacion		[ll_i] + "</td>"
	ls_html_body += "<td align='center' valign='middle'>" + adw_datos.object.cod_moneda		[ll_i] + "</td>"
	ls_html_body += "<td align='right' valign='middle'>" + string(ldc_base_imponible, '###,##0.00') + "</td>"
	ls_html_body += "<td align='right' valign='middle'>" + string(ldc_impuestos, '###,##0.00') + "</td>"
	ls_html_body += "<td align='right' valign='middle'>" + string(ldc_total_importe, '###,##0.00') + "</td>"
	ls_html_body += "</tr>"
next

ls_html_body += "</table>"
ls_html_body += "<br/><br/>"
ls_html_body += "Para aceptar esta transferencia, debe ingresar al módulo de Control documentario e ingresar a la opción de Aceptar Tranasferencia.<br/>"
ls_html_body += "</body>"

ls_subject = "Transferencia de Documentos desde Control Documentario"

invo_serversmtp.of_send_email(ls_subject, ls_html_body, anvo_usr_dst)

return true
end function

on n_cst_controldoc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_controldoc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

