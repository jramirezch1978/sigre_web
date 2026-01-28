$PBExportHeader$n_cst_ventas.sru
forward
global type n_cst_ventas from nonvisualobject
end type
end forward

global type n_cst_ventas from nonvisualobject
end type
global n_cst_ventas n_cst_ventas

type prototypes
//Funciones para la generación del codigo QR
SUBROUTINE FastQRCode(REF String Texto, REF String FileName) LIBRARY "i:\sigre_exe\QRCodeLib.dll" Alias for "FastQRCode;Ansi"
//subroutine FastQRCode(ref string text, ref string filename) library '\sigre_exe\QRCodeLib.dll' ALIAS FOR "FastQRCode"
Function String QRCodeLibVer() LIBRARY "i:\sigre_exe\QRCodeLib.dll" Alias for "QRCodeLibVer;Ansi"
end prototypes

type variables
String 		is_datos_tarjeta_default
Long			il_dias_atrazo_fec_vta

//Determino si es emisor electronico o no
String 		is_emisor_electronico

//Definir si tiene impresora termica
String		is_impresion_termica

//Generar el asiento y cxc de las facturas simplificada
String		is_generar_cxc_fact_simpl

//Ruta donde se genera el archivo PDF, se guarda para algunas funciones internas
String 		is_filename_pdf

//FActura Electronica
String		is_flag_efact, is_nro_resolucion, is_url, is_texto_devolucion, is_modif_precio_unit

//Flag Enviar por email ni bien se grabe el CE
String		is_send_email_post_save

//Flag de envio de email solo al cliente
String		is_send_email_only_cliente

//Ticket electronico
u_ds_base 	ids_ticket, ids_despacho, ids_boletas

//NOmbre de la impresora de despacho
String		is_name_printer_desp 

//Nombre de la impresora de tickets (boleta/factura)
String		is_name_printer_ticket 

//Flag que indica si valida o no la fecha de emisión de la factura
String		is_valida_fec_emision_fac

//Indicador del numero de días maximo para la fecha de emisión del comprobante por cobrar
Long 			il_nro_dias_max_fec_emision

//Vendedor por defecto
String		is_default_vendedor

//Observacion que esta por defecto en la facturación simplificada
String 		is_observacion

//Tamaños y distancias para el comprobante en termico
Long			il_width_efact, il_height_efact, il_height_row_efact, il_height_row_fp, il_height_despacho, &
				il_header_row_alm, il_header_row_desp

//Ruta donde se ejecuta el SIGRE
String		is_path_sigre

//Arreglos de documentos para validar
String 		is_doc_validos[] = {'FAC', 'BVC', 'NCC', 'NDC'}

//Versiones de ubl validos 
String 		is_ubl_validos[] = {'UBL20', 'UBL21'}

//Impuesto	ICBPER
String		is_icbper


n_cst_utilitario	invo_util
n_cst_xml			invo_xml
n_cst_numlet 		invo_numlet
n_cst_serversmtp	invo_email
n_cst_wait			invo_wait
n_smtp				invo_smtp
n_cst_inifile		invo_inifile

end variables

forward prototypes
public function boolean of_load ()
public function boolean of_datos_nota_venta (str_parametros astr_param)
public function string of_choice_bien_servicio ()
public function boolean of_generar_pdf (str_qrcode astr_param)
public function boolean of_generar_qrcode (str_qrcode astr_param)
public function boolean of_almacenar_qrcode (string as_filename, string as_nro_registro)
public function boolean of_almacenar_qrcode (string as_filename, string as_tipo_doc, string as_nro_doc)
public function boolean of_pdf_export (string as_filename, string as_nro_registro)
public function boolean of_pdf_export (string as_filename, string as_tipo_doc, string as_nro_doc)
public function boolean of_generar_pdf (date ad_fecha)
public function boolean of_pdf_export (string as_filename, string as_nro_registro, u_dw_rpt adw_report)
public function boolean of_pdf_export (string as_filename, string as_tipo_doc, string as_nro_doc, u_dw_rpt adw_report)
public function boolean of_print_efact (string as_nro_registro)
public function boolean of_generar_qrcode (date ad_fecha)
public function boolean of_generar_pdf (str_qrcode astr_param, u_dw_rpt adw_report)
public function boolean of_generar_qrcode (str_qrcode astr_param, u_dw_rpt adw_reporte)
public function boolean of_rpt_cierre_caja (date adi_fecha1, date adi_fecha2)
public function boolean of_print_despacho (string as_nro_registro)
public function boolean of_print_efact (string as_tipo_doc, string as_nro_doc, boolean ab_preview)
public function boolean of_config_dw_ce (u_dw_rpt adw_reporte)
public function boolean of_config_dw_cierre_caja (u_dw_rpt adw_report)
public function boolean of_print_mov_almacen (string as_nro_vale)
public function boolean of_export_ce_pdf (string as_tipo_doc, string as_nro_doc)
public function boolean of_send_email (string as_nro_registro, string as_tipo_doc, string as_nro_doc)
public function string of_get_pdf_filename (string as_nro_registro, string as_tipo_doc, string as_nro_doc)
public function boolean of_valida_inputs (string as_nro_registro, string as_tipo_doc, string as_nro_doc)
public function boolean of_get_body_subject (string as_nro_registro, string as_tipo_doc, string as_nro_doc, ref string as_body_html, ref string as_subject)
public function boolean of_cxc_factura_smpl_genera (string as_nro_registro)
public function boolean of_cxc_factura_smpl_anula (string as_nro_registro)
public function boolean of_create_only_pdf (string as_nro_registro, string as_tipo_doc, string as_nro_doc)
public function boolean of_anular_pago_fs_smpl (string as_nro_registro, string as_flag_forma_pago, long al_nro_item)
public function boolean of_send_email_changes_vta (u_dw_abc adw_detail)
public function boolean of_send_email_changes_cmp (u_dw_abc adw_detail)
public function boolean of_resumen_rc_fs (date adi_fecha)
public function string of_string_nro_cuota (string as_nro_letra, date ad_fecha)
public function string of_string_codigo_cliente (string as_ruc_dni, string as_mnz, string as_lote)
public function string of_select_dataobject (string as_nro_registro, string as_tipo_doc, string as_serie, string as_flag_mercado) throws exception
public function boolean of_print_ce (string as_tipo_doc, string as_nro_doc, str_parametros astr_param)
public function string of_select_dataobject_email (string as_nro_registro, string as_tipo_doc, string as_serie, string as_flag_mercado) throws exception
public function boolean of_create_only_pdf (string as_nro_registro)
public function boolean of_create_only_pdf (string as_tipo_doc, string as_serie, string as_nro_doc, str_parametros astr_param)
public function boolean of_resumen_ra_bvc (date adi_fecha)
public function boolean of_resumen_ra_fac (date adi_fecha)
public function boolean of_allow_modify (string as_tipo_doc, string as_nro_doc)
public function boolean of_print_proforma (string as_nro_proforma)
public function boolean of_generar_xml_fac_ubl20 (string asi_tipo_doc, string asi_nro_doc)
public function boolean of_generar_xml_ncc_ubl20 (string asi_tipo_doc, string asi_nro_doc)
public function boolean of_generar_xml_ndc_ubl20 (string asi_tipo_doc, string asi_nro_doc)
public function boolean of_generar_xml_fac_ubl20 (string asi_nro_registro)
public function boolean of_generar_xml_ncc_ubl20 (string as_nro_registro)
public function boolean of_generar_xml_ndc_ubl20 (string as_nro_registro)
public function boolean of_generar_xml_fac_ubl21 (string asi_nro_registro)
public function boolean of_generar_xml_fac_ubl21 (string asi_tipo_doc, string asi_nro_doc)
public function boolean of_generar_xml_ncc_ubl21 (string as_nro_registro)
public function boolean of_generar_xml_ncc_ubl21 (string asi_tipo_doc, string asi_nro_doc)
public function boolean of_generar_xml_ndc_ubl21 (string as_nro_registro)
public function boolean of_generar_xml_ndc_ubl21 (string asi_tipo_doc, string asi_nro_doc)
public function boolean of_create_only_xml (string as_nro_registro, string as_tipo_doc, string as_nro_doc) throws exception
public function string of_get_xml_filename (string as_nro_registro, string as_tipo_doc, string as_nro_doc) throws exception
public function boolean of_create_only_xml (string as_nro_registro, string as_tipo_doc) throws exception
public function boolean of_generar_vale_almacen (string as_nro_registro)
public function boolean of_cerrar_ov (string as_tipo_doc, string as_nro_doc)
public function boolean of_gen_transformacion (str_parametros astr_param)
public function boolean of_print_only_efact (string as_nro_registro)
end prototypes

public function boolean of_load ();try 
	invo_inifile.of_set_inifile(gnvo_app.is_empresas_iniFile)
	
	//Llenar los datos de la tarjeta por defecto
	is_datos_tarjeta_default 	= gnvo_app.of_get_parametro("FIN_DATOS_TARJETA_DEFAUL", "1")
	il_dias_atrazo_fec_vta 		= gnvo_app.of_get_parametro("VTA_DIAS_ATRAZO_FECHA_VTA", 2)
	
	//Indicador si es emisor electronico
	is_emisor_electronico 		= gnvo_app.of_get_parametro("VTA_EMISOR_ELECTRONICO", "1")

	//Indicador para ver si envia la factura electronica el usuario
	is_flag_efact 			= gnvo_app.of_get_parametro( "PROC_FACTURA_ELECTRONICA", "0")
	
	//Flag que indica si tiene impresión termica
	is_impresion_termica	= gnvo_app.of_get_parametro("IMPRESION_TERMICA", "0")
	
	//Flag Enviar por email ni bien se grabe el CE
	is_send_email_post_save		= gnvo_app.of_get_parametro("SEND_EMAIL_POST_SAVE", "0")
	
	//Flag de envio de email solo al cliente
	is_send_email_only_cliente = gnvo_app.of_get_parametro("SEND_EMAIL_ONLY_CLIENTE", "1")
	
	//Flag que indica si valida o no la fecha de emisión de la factura
	is_valida_fec_emision_fac = gnvo_app.of_get_parametro("VTA_VALIDA_FEC_EMISION_FAC", "1")
	
	//Indicador del numero de días maximo para la fecha de emisión del comprobante por cobrar
	il_nro_dias_max_fec_emision = gnvo_app.of_get_parametro("VTA_NRO_DIAS_MAX_FEC_EMISION", 7)

	//Vendedor por defecto
	is_default_vendedor 	= gnvo_app.of_get_parametro("DEFAULT_VENDEDOR", "")

	//Observacion que esta por defecto en la facturación simplificada
	is_observacion 		= gnvo_app.of_get_parametro("OBSERVACION_DEFAULT", &
																	  "VENTAS USANDO FACTURACIÓN SIMPLIFICADA.")
	
	
	
	this.is_path_sigre 	= invo_inifile.of_get_parametro( "SIGRE_EXE", "PATH_SIGRE", "i:\SIGRE_EXE")
	
	if right(this.is_path_sigre, 1) = '\' then
		this.is_path_sigre = left(this.is_path_sigre, len(this.is_path_sigre) - 1)
	end if
	
	//Datos para la factura electronica
	//Nro Resolucion de SUNAT
	is_nro_resolucion		= gnvo_app.of_get_parametro( "NRO_RESOLUCION_SUNAT_EFACT", "082-005-0000087/SUNAT")			
	is_url					= gnvo_app.of_get_parametro( "URL_EFACT", "http://www.miurl.pe")			
	il_width_efact			= gnvo_app.of_get_parametro( "WITH_EFACT", 80)			//Ancho 80 mm
	il_height_efact		= gnvo_app.of_get_parametro( "HEIGHT_EFACT", 300)		//Altura 260 mm
	il_height_row_efact	= gnvo_app.of_get_parametro( "HEIGHT_ROW_EFACT", 12) 	//Altura de cada fila 10 mm
	il_height_row_fp		= gnvo_app.of_get_parametro( "HEIGHT_ROW_FP", 20) 		//Altura de cada fila 20 mm

	//Altura para el ticket de despacho
	il_height_despacho	= gnvo_app.of_get_parametro( "HEIGHT_DESPACHO", 130)		//Altura 130 mm
	il_header_row_alm		= gnvo_app.of_get_parametro( "HEIGHT_ROW_ALMACEN", 12)		//Altura 130 mm
	is_name_printer_desp = gnvo_app.of_get_parametro( "NAME_PRINTER_DESPACHO", "DESPACHO")		//Nombre de la impresora de despacho
	il_header_row_desp	= gnvo_app.of_get_parametro( "HEIGHT_ROW_DESPACHO", 12)		//Altura de fila de despacho
	
	//Nombre de la impresora de tickets (vacio = impresora por defecto), sería por usuario
	is_name_printer_ticket = gnvo_app.of_get_parametro( "NAME_PRINTER_TICKET_"+UPPER(trim(gs_user)), "")		

	//Texto para la devolución
	is_texto_devolucion 	= gnvo_app.of_get_parametro( "TEXTO_DEVOLUCION", "Estimado Cliente. " &
		+ "Conserve su comprobante por regulación de SUNAT es indispensable presentarlo para " &
		+ "solicitar cambios o devoluciones. Toda devolución deberá realizarse dentro de los " &
		+ "7 días calendarios a partir de la fecha de emisión de este comprobante.") 		
	
	//Generacion de asiento y cxc de factura simpl
	is_generar_cxc_fact_simpl = gnvo_app.of_get_parametro( "VENTA_GENERAR_CXC_FACT_SIMPL", "1")		//Nombre de la impresora de despacho
	
	//Impuesto icbper
	is_icbper 	= gnvo_app.of_get_parametro( "IMPUESTO_ICBPER", "ICBPE")	
	
	invo_xml.of_load()
	
	return true
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción en la función OF_LOAD del objeto ' + this.classname() &
							+ '.~r~nMensaje de error: ' + ex.getMessage() + '.' &
							+ '~r~nPor favor verifique!', StopSign!)
	return false
finally
	/*statementBlock*/
end try



end function

public function boolean of_datos_nota_venta (str_parametros astr_param);str_parametros lstr_return

OpenWithParm(w_select_datos_ncc_ndc, astr_param)

lstr_return = Message.PowerObjectParm

if not lstr_return.b_return then return false


return true
end function

public function string of_choice_bien_servicio ();str_parametros lstr_return

try 
	if gnvo_app.of_get_parametro("CHOISE_BIEN_SERVICIO", "1") = "1" then
	
		Open(w_choice_bien_servicio)
		
		lstr_return = Message.PowerObjectParm
		
		if not lstr_return.b_return then return ''
		
		return lstr_return.string1
		
	else
		
		//Siempre será un bien
		return '1'
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en n_cst_ventas.of_choice_bien_servicio()')
	
	return ''
	
end try






end function

public function boolean of_generar_pdf (str_qrcode astr_param);String	ls_nro_registro, ls_path, ls_file_pdf, ls_tipo_doc_sunat, ls_serie_cxc, ls_nro_cxc, &
			ls_tipo_doc, ls_nro_doc, ls_full_nro_doc, ls_mensaje
Integer 	li_filenum
Date		ld_fec_emision

//Lleno los datos necesarios
ls_nro_registro	= astr_param.nro_registro
ls_tipo_doc_sunat	= astr_param.tipo_doc_sunat
ls_tipo_doc			= astr_param.tipo_doc
ls_nro_doc			= astr_param.nro_doc
ls_serie_cxc		= astr_param.serie
ls_nro_cxc 			= astr_param.numero
ld_fec_emision		= astr_param.fec_emision


select PKG_FACT_ELECTRONICA.of_get_full_nro(:ls_nro_doc)
	into :ls_full_nro_doc
from dual;

if SQLCA.SQLcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_app.of_mensaje_error("Error al ejecutar PKG_FACT_ELECTRONICA.of_get_full_nro(). Mensaje: " + ls_mensaje)
	return false
end if

//Directorio donde se guardan los PDF
ls_path = this.is_path_sigre + '\EFACT_PDF\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			  + '\' + string(ld_fec_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	if not invo_util.of_CreateDirectory( ls_path ) then return false
	
End If

//Nombre del archivo  PDF
ls_file_pdf = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_full_nro_doc + '.pdf'

//Genero el PDF
if Not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
	this.of_pdf_export( ls_file_pdf, ls_nro_registro )
else
	this.of_pdf_export( ls_file_pdf, ls_tipo_doc, ls_nro_doc )
end if


return true
end function

public function boolean of_generar_qrcode (str_qrcode astr_param);String 	ls_ruc_emisor, ls_serie_cxc, ls_nro_cxc, ls_tipo_doc_ident, ls_nro_doc_ident, &
			ls_txt_code, ls_file_qr, ls_path, ls_nro_registro, ls_tipo_doc_sunat, ls_tipo_doc, &
			ls_nro_doc, ls_full_nro_doc, ls_mensaje
decimal 	ldc_igv, ldc_venta
Date		ld_fecha_emision
Integer 	li_filenum

//Lleno los datos necesarios
ls_nro_registro	= astr_param.nro_registro
ls_ruc_emisor 		= astr_param.ruc_emisor
ls_tipo_doc_sunat = astr_param.tipo_doc_sunat
ls_tipo_doc			= astr_param.tipo_doc
ls_nro_doc			= astr_param.nro_doc
ls_serie_cxc		= astr_param.serie
ls_nro_cxc 			= astr_param.numero
ls_tipo_doc_ident = astr_param.tipo_doc_ident
ls_nro_doc_ident 	= astr_param.nro_doc_ident

ldc_igv				= astr_param.imp_igv
ldc_venta			= astr_param.imp_total

ld_fecha_emision	= astr_param.fec_emision

select PKG_FACT_ELECTRONICA.of_get_full_nro(:ls_nro_doc)
	into :ls_full_nro_doc
from dual;

if SQLCA.SQLcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_app.of_mensaje_error("Error al ejecutar PKG_FACT_ELECTRONICA.of_get_full_nro(). Mensaje: " + ls_mensaje)
	return false
end if


//Valido la información
if IsNull(ls_nro_doc_ident) or trim(ls_nro_doc_ident) = '' then
	MEssageBox('Error', 'El Cliente del Comprobante ' + ls_tipo_doc + ' ' + ls_serie_cxc + '-' + ls_nro_cxc &
					+ ' no tiene especificado un numero de documento de Identidad (RUC, DNI, OTROS), por favor corija', StopSign!)
	return false
end if

//Genero el texto para codificar
ls_txt_code = ls_ruc_emisor + '|' + trim(ls_tipo_doc_sunat) + '|' + ls_serie_cxc + '|' + ls_nro_cxc + '|' &
				+ string(ldc_igv, '###,###,##0.00') + '|' + string(ldc_venta, '###,###,##0.00') + '|' &
				+ string(ld_fecha_emision, 'ddmmyyyy') + '|' + ls_tipo_doc_ident + '|' + ls_nro_doc_ident + '|' 

//Directorio donde se guardan los codeQR
ls_path = this.is_path_sigre + '\QR_CODE\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
		  + '\' + string(ld_fecha_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	
	if not invo_util.of_CreateDirectory( ls_path ) then return false

End If

//Nombre del archivo 
ls_file_qr = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_full_nro_doc + '.bmp'

//Nombro el datawindow
ids_ticket.object.DAtaWindow.Print.DocumentName	= trim(ls_tipo_doc_sunat) + '_' + ls_full_nro_doc

//Genero el codigo QR
FastQRCode(ls_txt_code, ls_file_qr)

If FileExists ( ls_file_qr ) Then
	//Guardo el codigo qr en la tabla
	if not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
		if not this.of_almacenar_qrcode( ls_file_qr, ls_nro_registro ) then return false
	else
		if not this.of_almacenar_qrcode( ls_file_qr, ls_tipo_doc, ls_nro_doc ) then return false
	end if
	
	//Coloco la imagen en el ticket
	ids_ticket.object.p_codeqr.filename = ls_file_qr

End If

return true
end function

public function boolean of_almacenar_qrcode (string as_filename, string as_nro_registro);//Todo el siguiente codigo en el evento click del CommandButton, "Elegir Imagen"
//Definir parametros para ventana que muestra la carpeta de las imagenes
/// mostrar la imagen
String	ls_mensaje
blob		lblb_total

try 
	if gnvo_app.of_get_parametro('ALWAY_SAVE_QRCODE_IMAGE', '0') = '1' THEN
	
	lblb_total = invo_util.of_load_blob( as_filename )

	// Actualizamos la columna de la imagen para el registro correspondiente
	// al CODIGO, para esto usamos la funcion UPDATEBLOB
	UPDATEBLOB fs_factura_simpl 
			SET imagen_qr = :lblb_total 
		WHERE nro_registro = :as_nro_registro; 
	
	//Verificamos si no hubo error
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox ("Error", 'No se ha podido actualizar el codigo QR para el registro ' + as_nro_registro &
								+ ".Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;
end if

return true

catch ( Exception ex )
	MessageBox('Exception', 'HA ocurrido una exception: ' +  ex.getMessage(), StopSign!)
	return false
end try


end function

public function boolean of_almacenar_qrcode (string as_filename, string as_tipo_doc, string as_nro_doc);//Todo el siguiente codigo en el evento click del CommandButton, "Elegir Imagen"
//Definir parametros para ventana que muestra la carpeta de las imagenes
/// mostrar la imagen
String	ls_mensaje
blob		lblb_total


lblb_total = invo_util.of_load_blob( as_filename )

// Actualizamos la columna de la imagen para el registro correspondiente
// al CODIGO, para esto usamos la funcion UPDATEBLOB
UPDATEBLOB cntas_cobrar 
		SET imagen_qr = :lblb_total 
	WHERE tipo_doc = :as_tipo_doc
	  and nro_doc	= :as_nro_doc; 

//Verificamos si no hubo error
if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox ("Error", 'No se ha podido actualizar el codigo QR para el comprobante ' &
							+ as_tipo_doc + '/' + as_nro_doc &
							+ ".Mensaje: " + ls_mensaje, StopSign!)
	return false
end if

commit;

return true
end function

public function boolean of_pdf_export (string as_filename, string as_nro_registro);n_cst_email	lnv_email
blob			lblb_data
string		ls_mensaje
Long			ll_height


lnv_email = CREATE n_cst_email
try

	if not lnv_email.of_create_pdf( ids_ticket, as_filename, 1) then return false
	lblb_data = invo_util.of_load_blob( as_filename )
	
	
	// Actualizamos la columna de la imagen para el registro correspondiente
	// al CODIGO, para esto usamos la funcion UPDATEBLOB
	UPDATEBLOB fs_factura_simpl 
			SET data_pdf = :lblb_data 
		WHERE nro_registro = :as_nro_registro; 
	
	//Verificamos si no hubo error
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox ("Error", 'No se ha podido actualizar DATA_PDF para el registro ' + as_nro_registro &
								+ ".Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

	
	
catch (Exception ex)
	MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + as_filename + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
	
finally
	Destroy lnv_email
	
end try
	
return true
end function

public function boolean of_pdf_export (string as_filename, string as_tipo_doc, string as_nro_doc);n_cst_email	lnv_email
blob			lblb_data
string		ls_mensaje
Long			ll_height


lnv_email = CREATE n_cst_email
try

	if not lnv_email.of_create_pdf( ids_ticket, as_filename, 1) then return false
	lblb_data = invo_util.of_load_blob( as_filename )
	
	
	// Actualizamos la columna de la imagen para el registro correspondiente
	// al CODIGO, para esto usamos la funcion UPDATEBLOB
	UPDATEBLOB cntas_cobrar 
			SET data_pdf = :lblb_data 
		WHERE tipo_doc = :as_tipo_doc
		  and nro_doc	= :as_nro_doc; 
	
	//Verificamos si no hubo error
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox ("Error", 'No se ha podido actualizar DATA_PDF para el comprobante ' &
								+ as_tipo_doc + '/' + as_nro_doc &
								+ ".Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

	
	
catch (Exception ex)
	MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + as_filename + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
	
finally
	Destroy lnv_email
	
end try
	
return true
end function

public function boolean of_generar_pdf (date ad_fecha);String	ls_nro_registro, ls_path, ls_tipo_doc_sunat, ls_serie_cxc, ls_nro_cxc, &
			ls_tipo_doc, ls_nro_doc
Integer 	li_filenum

//Lleno los datos necesarios
if ids_ticket.of_existecampo('nro_registro') then
	ls_nro_registro	= ids_ticket.object.nro_registro		[1]
end if

ls_tipo_doc_sunat	= ids_ticket.object.tipo_doc_sunat 	[1]
ls_tipo_doc			= ids_ticket.object.tipo_doc 			[1]

if ids_ticket.of_existecampo('serie_cxc') then
	ls_serie_cxc		= ids_ticket.object.serie_cxc 		[1]
else
	ls_serie_cxc		= ids_ticket.object.serie		 		[1]
end if

if ids_ticket.of_existecampo('nro_cxc') then
	ls_nro_cxc 			= ids_ticket.object.nro_cxc	 		[1]
else
	ls_nro_cxc 			= ids_ticket.object.numero	 		[1]
end if


if ids_ticket.of_existecampo("nro_doc") then
	ls_nro_doc 			= ids_ticket.object.nro_doc	 	[1]
else
	ls_nro_doc 			= ""
end if

//Directorio donde se guardan los PDF
ls_path = this.is_path_sigre + '\EFACT_PDF\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	if not invo_util.of_CreateDirectory( ls_path ) then return false
	
End If

//Nombre del archivo  PDF
is_filename_pdf = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_serie_cxc + '-' + ls_nro_cxc + '.pdf'

//Genero el PDF
if Not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
	this.of_pdf_export( is_filename_pdf, ls_nro_registro )
else
	this.of_pdf_export( is_filename_pdf, ls_tipo_doc, ls_nro_doc )
end if


return true
end function

public function boolean of_pdf_export (string as_filename, string as_nro_registro, u_dw_rpt adw_report);n_cst_email	lnv_email
blob			lblb_data
string		ls_mensaje
Long			ll_height


lnv_email = CREATE n_cst_email
try

	if not lnv_email.of_create_pdf( adw_report, as_filename) then return false
	lblb_data = invo_util.of_load_blob( as_filename )
	
	
	// Actualizamos la columna de la imagen para el registro correspondiente
	// al CODIGO, para esto usamos la funcion UPDATEBLOB
	UPDATEBLOB fs_factura_simpl 
			SET data_pdf = :lblb_data 
		WHERE nro_registro = :as_nro_registro; 
	
	//Verificamos si no hubo error
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox ("Error", 'No se ha podido actualizar DATA_PDF para el registro ' + as_nro_registro &
								+ ".Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

	
	
catch (Exception ex)
	MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + as_filename + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
	
finally
	Destroy lnv_email
	
end try
	
return true
end function

public function boolean of_pdf_export (string as_filename, string as_tipo_doc, string as_nro_doc, u_dw_rpt adw_report);n_cst_email	lnv_email
blob			lblb_data
string		ls_mensaje
Long			ll_height


lnv_email = CREATE n_cst_email
try

	if not lnv_email.of_create_pdf( adw_report, as_filename) then return false
	lblb_data = invo_util.of_load_blob( as_filename )
	
	
	// Actualizamos la columna de la imagen para el registro correspondiente
	// al CODIGO, para esto usamos la funcion UPDATEBLOB
	UPDATEBLOB cntas_cobrar 
			SET data_pdf = :lblb_data 
		WHERE tipo_doc = :as_tipo_doc
		  and nro_doc	= :as_nro_doc; 
	
	//Verificamos si no hubo error
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox ("Error", 'No se ha podido actualizar DATA_PDF para en la tabla CNTAS_COBRAR, Comprobante ' &
								+ as_tipo_doc + '/' + as_nro_doc &
								+ ". Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

	
	
catch (Exception ex)
	MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + as_filename + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
	
finally
	Destroy lnv_email
	
end try
	
return true
end function

public function boolean of_print_efact (string as_nro_registro);Long 		ll_height, ll_rows_fp
Date		ld_fecha
String	ls_origen, ls_direccion, ls_fono, ls_tipo_doc_cxc, ls_nro_doc_cxc, ls_serie, &
			ls_flag_tipo_impresion
Long		ll_i

try 
	
	invo_wait.of_mensaje("Obteniendo la Serie")
	//Obtengo la serie
	select serie_cxc, tipo_doc_cxc, 
			 decode(nro_doc_cxc, null, serie_cxc || '-' || nro_Cxc, nro_doc_cxc)
		into :ls_Serie, :ls_tipo_doc_cxc, :ls_nro_doc_cxc
	from fs_factura_simpl
	where nro_registro = :as_nro_registro;
	
	//Obtengo los flag adecuados
	select nvl(flag_tipo_impresion, '0')
		into :ls_flag_tipo_impresion
	from num_doc_tipo
	where nro_serie = :ls_serie
	  and tipo_doc	= :ls_tipo_doc_cxc;
		
	//Genero el PDF
	invo_wait.of_mensaje("Generando el PDF")
	if trim(ls_tipo_doc_cxc) <> 'NVC' then
		if not this.of_create_only_pdf(as_nro_registro) then return false
	end if
	
	invo_wait.of_mensaje("Preparando el reporte")
	
	//Imprimo el ticket
	ids_ticket.DataObject = this.of_select_DataObject(as_nro_registro, ls_tipo_doc_cxc, ls_serie, 'L')
	
	ids_ticket.SetTransObject(SQLCA)
	
	if ls_flag_tipo_impresion <> '2' then
	
		ids_ticket.Retrieve(as_nro_registro, gs_empresa)
		
	else
		
		ids_ticket.Retrieve(ls_tipo_doc_cxc, ls_nro_doc_cxc, gs_empresa)
		
	end if


	
	//Actualizo los datos de la direccion y telefono por origen
	ls_origen = ids_ticket.object.cod_origen [1]
	
	ls_direccion 	= gnvo_app.empresa.of_direccion(ls_origen)
	ls_fono			= gnvo_app.empresa.of_telefono(ls_origen)	
	
	for ll_i = 1 to ids_ticket.RowCount()
		ids_ticket.object.direccion [ll_i] = ls_direccion
		ids_ticket.object.fono_fijo [ll_i] = ls_fono
	next
	
	//Pongo el nombre al documento
	ids_ticket.object.DataWindow.Print.DocumentName	= trim(ls_tipo_doc_cxc) + '-' + ls_nro_doc_cxc

	//Cuantas formas de pago tiene
	if ls_flag_tipo_impresion <> '2' then
		select count(*)
			into :ll_rows_fp
		from fs_factura_simpl_pagos
		where nro_registro = :as_nro_registro;
		
		//ASigno el tamaño requerido
		ll_height = il_height_efact + il_height_row_efact * ids_ticket.RowCount( ) + il_height_row_fp * ll_rows_fp
		ids_ticket.Object.DataWindow.Print.Paper.Size = 256 
		ids_ticket.Object.DataWindow.Print.CustomPage.Width = il_width_efact
		ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height
	end if
	
	//Coloco el logo
	if FileExists(gs_logo) then
		ids_ticket.object.p_logo.filename = gs_logo
	end if
	
	invo_wait.of_mensaje("Ajustando la configuracion")
	//Lleno los datos necesarios
	if trim(ls_tipo_doc_cxc) <> 'NVC' then
		if ids_ticket.of_Existstext( "nro_resolucion") then
			ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
		end if
		
		if ids_ticket.of_Existstext( "url_t") then
			ids_ticket.object.url_t.text 					= this.is_url
		end if
		
		if ids_ticket.of_Existstext( "devolucion_t") then
			ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
		end if
		
		//Genero el codigo QR
		invo_wait.of_mensaje("Generando el Codigo QR")
		if not this.of_generar_qrcode( ld_fecha ) then return false
	end if
	
	invo_wait.of_mensaje("Imprimiendo el comprobante")
	
	
	if trim(ls_tipo_doc_cxc) = 'NVC' then
		if gnvo_app.of_get_parametro( "VTA_PRINT_NOTA_VENTA", "0") = "1" then
			ids_ticket.Print()
		end if
	else
		//MessageBox('Aviso of_print_efact()', 'Datawindow.printer: ' + ids_ticket.Describe("DataWindow.Printer") , Information!)
		ids_ticket.Print()
		//MessageBox('Aviso of_print_efact()', 'Impresión completa', Information!)
	end if
	
	
	if trim(ls_tipo_doc_cxc) <> 'NVC' THEN
		if gnvo_app.of_get_parametro( "DOBLE_COMPROBANTE", "0") = "1" then
			
			invo_wait.of_mensaje("Imprimiendo otra vez el comprobante")
			ids_ticket.Print()
			
		end if
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false

finally
	invo_wait.of_close()
end try





end function

public function boolean of_generar_qrcode (date ad_fecha);String 	ls_ruc_emisor, ls_serie_cxc, ls_nro_cxc, ls_tipo_doc_ident, ls_nro_doc_ident, &
			ls_txt_code, ls_file_qr, ls_path, ls_nro_registro, ls_tipo_doc_sunat, ls_tipo_doc, &
			ls_nro_doc
decimal 	ldc_igv, ldc_venta
Date		ld_fecha_emision
Integer 	li_filenum

//MEssageBox('Error', 'Datawindow ' + ids_ticket.DataObject, Information!)

//Lleno los datos necesarios
if ids_ticket.of_existecampo('nro_registro') then
	ls_nro_registro	= ids_ticket.object.nro_registro		[1]
end if

if ids_ticket.of_existecampo('ruc') then
	ls_ruc_emisor 		= ids_ticket.object.ruc 				[1]
elseif ids_ticket.of_existecampo('ruc_emisor') then
	ls_ruc_emisor 		= ids_ticket.object.ruc_emisor		[1]
else
	MEssageBox('Error', 'No existe el campo ni RUC ni RUC_EMISOR en datawindow ' + ids_ticket.DataObject, StopSign!)
	return false
end if

ls_tipo_doc_sunat = ids_ticket.object.tipo_doc_sunat 	[1]
ls_tipo_doc			= ids_ticket.object.tipo_doc 			[1]

if ids_ticket.of_existecampo('serie_cxc') then
	ls_serie_cxc		= ids_ticket.object.serie_cxc 		[1]
else
	ls_serie_cxc		= ids_ticket.object.serie 				[1]
end if

if ids_ticket.of_existecampo('nro_cxc') then
	ls_nro_cxc 			= ids_ticket.object.nro_cxc	 		[1]
else
	ls_nro_cxc 			= ids_ticket.object.numero	 		[1]
end if

ls_tipo_doc_ident = ids_ticket.object.tipo_doc_ident	[1]
ls_nro_doc_ident 	= ids_ticket.object.ruc_dni			[1]

ldc_igv				= Dec(ids_ticket.object.igv				[1])
ldc_venta			= Dec(ids_ticket.object.importe_total	[1])

if ids_ticket.of_existecampo('fec_registro') then
	ld_fecha_emision	= Date(ids_ticket.object.fec_registro		[1])
else
	ld_fecha_emision	= Date(ids_ticket.object.fecha_documento	[1])
end if



if ids_ticket.of_existecampo("nro_doc") then
	ls_nro_doc 			= ids_ticket.object.nro_doc	 		[1]
else
	ls_nro_doc 			= ""
end if

//Genero el texto para codificar
ls_txt_code = ls_ruc_emisor + '|' + trim(ls_tipo_doc_sunat) + '|' + ls_serie_cxc + '|' + ls_nro_cxc + '|' &
				+ string(ldc_igv, '###,###,##0.00') + '|' + string(ldc_venta, '###,###,##0.00') + '|' &
				+ string(ld_fecha_emision, 'ddmmyyyy') + '|' + ls_tipo_doc_ident + '|' + ls_nro_doc_ident + '|' 

//Directorio donde se guardan los codeQR
ls_path = this.is_path_sigre + '\QR_CODE\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
		  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	
	if not invo_util.of_CreateDirectory( ls_path ) then return false

End If

//Nombre del archivo 
ls_file_qr = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_serie_cxc + '-' + ls_nro_cxc + '.bmp'

//Nombro el datawindow
ids_ticket.object.DAtaWindow.Print.DocumentName	= trim(ls_tipo_doc_sunat) + '_' + ls_serie_cxc + '-' + ls_nro_cxc

//Genero el codigo QR
FastQRCode(ls_txt_code, ls_file_qr)

If FileExists ( ls_file_qr ) Then
	//Guardo el codigo qr en la tabla
	if not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
		if not this.of_almacenar_qrcode( ls_file_qr, ls_nro_registro ) then return false
	else
		if not this.of_almacenar_qrcode( ls_file_qr, ls_tipo_doc, ls_nro_doc ) then return false
	end if
	
	//Coloco la imagen en el ticket
	ids_ticket.object.p_codeqr.filename = ls_file_qr

End If

return true
end function

public function boolean of_generar_pdf (str_qrcode astr_param, u_dw_rpt adw_report);String	ls_nro_registro, ls_path, ls_file_pdf, ls_tipo_doc_sunat, ls_serie_cxc, ls_nro_cxc, &
			ls_tipo_doc, ls_nro_doc
Integer 	li_filenum
Date		ld_fec_emision

//Lleno los datos necesarios
ls_nro_registro	= astr_param.nro_registro
ls_tipo_doc_sunat	= astr_param.tipo_doc_sunat
ls_tipo_doc			= astr_param.tipo_doc
ls_nro_doc			= astr_param.nro_doc
ls_serie_cxc		= astr_param.serie
ls_nro_cxc 			= astr_param.numero
ld_fec_emision		= astr_param.fec_emision


//Directorio donde se guardan los PDF
ls_path = this.is_path_sigre + '\EFACT_PDF\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			  + '\' + string(ld_fec_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	if not invo_util.of_CreateDirectory( ls_path ) then return false
	
End If

//Nombre del archivo  PDF
ls_file_pdf = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_serie_cxc + '-' + ls_nro_cxc + '.pdf'

//Genero el PDF
if Not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
	this.of_pdf_export( ls_file_pdf, ls_nro_registro, adw_report )
else
	this.of_pdf_export( ls_file_pdf, ls_tipo_doc, ls_nro_doc, adw_report )
end if


return true
end function

public function boolean of_generar_qrcode (str_qrcode astr_param, u_dw_rpt adw_reporte);String 	ls_ruc_emisor, ls_serie_cxc, ls_nro_cxc, ls_tipo_doc_ident, ls_nro_doc_ident, &
			ls_txt_code, ls_file_qr, ls_path, ls_nro_registro, ls_tipo_doc_sunat, ls_tipo_doc, &
			ls_nro_doc
decimal 	ldc_igv, ldc_venta
Date		ld_fecha_emision
Integer 	li_filenum

//Lleno los datos necesarios
ls_nro_registro	= astr_param.nro_registro
ls_ruc_emisor 		= astr_param.ruc_emisor
ls_tipo_doc_sunat = astr_param.tipo_doc_sunat
ls_tipo_doc			= astr_param.tipo_doc
ls_nro_doc			= astr_param.nro_doc
ls_serie_cxc		= astr_param.serie
ls_nro_cxc 			= astr_param.numero
ls_tipo_doc_ident = astr_param.tipo_doc_ident
ls_nro_doc_ident 	= astr_param.nro_doc_ident

ldc_igv				= astr_param.imp_igv
ldc_venta			= astr_param.imp_total

ld_fecha_emision	= astr_param.fec_emision

//Genero el texto para codificar
ls_txt_code = ls_ruc_emisor + '|' + trim(ls_tipo_doc_sunat) + '|' + ls_serie_cxc + '|' + ls_nro_cxc + '|' &
				+ string(ldc_igv, '###,###,##0.00') + '|' + string(ldc_venta, '###,###,##0.00') + '|' &
				+ string(ld_fecha_emision, 'ddmmyyyy') + '|' + ls_tipo_doc_ident + '|' + ls_nro_doc_ident + '|' 

//Directorio donde se guardan los codeQR
ls_path = this.is_path_sigre + '\QR_CODE\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
		  + '\' + string(ld_fecha_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	
	if not invo_util.of_CreateDirectory( ls_path ) then return false

End If

//Nombre del archivo 
ls_file_qr = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_serie_cxc + '-' + ls_nro_cxc + '.bmp'

//Nombro el datawindow
adw_reporte.object.DAtaWindow.Print.DocumentName	= trim(ls_tipo_doc_sunat) + '_' + ls_serie_cxc + '-' + ls_nro_cxc

//Genero el codigo QR
FastQRCode(ls_txt_code, ls_file_qr)

If FileExists ( ls_file_qr ) Then
	//Guardo el codigo qr en la tabla
	if not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
		if not this.of_almacenar_qrcode( ls_file_qr, ls_nro_registro ) then return false
	else
		if not this.of_almacenar_qrcode( ls_file_qr, ls_tipo_doc, ls_nro_doc ) then return false
	end if
	
	//Coloco la imagen en el ticket
	adw_reporte.object.p_codeqr.filename = ls_file_qr

End If

return true
end function

public function boolean of_rpt_cierre_caja (date adi_fecha1, date adi_fecha2);Long 				ll_height, ll_rows_fp, ll_rpta
string			ls_tipo_rpt
str_parametros	lstr_param

//Primero Elijo el tipo de Reporte de Cierre de Caja
Open(w_choice_cierre_caja)
lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return true
ls_tipo_rpt = lstr_param.string1

//Solicita si es impresión directa o previsualización
ll_rpta = gnvo_app.utilitario.of_print_preview()
if ll_rpta < 0 then return false

if ll_rpta = 1 then
	
	//Elijo el datawindows adecuado
	if FileExists(gs_logo) then
		if ls_tipo_rpt = '1' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_t1_tbl'
		elseif ls_tipo_rpt = '2' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_t2_tbl'
		elseif ls_tipo_rpt = '3' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_t3_tbl'
		elseif ls_tipo_rpt = '4' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_t4_tbl'
		else
			MessageBox('Error', 'Tipo de reporte Elegido [' + ls_tipo_rpt &
						+ '] no esta implementado o no existe, por favor verifique!', StopSign!)
			return false
		end if
	else
		if ls_tipo_rpt = '1' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_sinlogo_t1_tbl'
		elseif ls_tipo_rpt = '2' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_sinlogo_t2_tbl'
		elseif ls_tipo_rpt = '3' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_sinlogo_t3_tbl'
		elseif ls_tipo_rpt = '4' then
			ids_ticket.DataObject = 'd_rpt_cierre_caja_sinlogo_t4_tbl'
		else
			MessageBox('Error', 'Tipo de reporte Elegido [' + ls_tipo_rpt &
						+ '] no esta implementado o no existe, por favor verifique!', StopSign!)
			return false
		end if
		
	end if
	
	ids_ticket.SetTransObject(SQLCA)
	
	ids_ticket.Retrieve(adi_fecha1, adi_fecha2, gs_empresa, gs_user, gs_origen)
	
	if ids_ticket.RowCount( ) = 0 then
		MessageBox('Error', 'No existen registros entre las fecha ' + string(adi_Fecha1, 'dd/mm/yyyy') &
			+ '-' + string(adi_fecha2, 'dd/mm/yyyy') + ', por favor verifique!', StopSign!)
		return false
	end if
	
	//Coloco el logo
	if FileExists(gs_logo) then
		ids_ticket.object.p_logo.filename = gs_logo
	end if	
	
	//Imprimo el ticket
	ids_ticket.Print()
	
else
	if FileExists(gs_logo) then
		if ls_tipo_rpt = '1' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_t1_tbl'
		elseif ls_tipo_rpt = '2' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_t2_tbl'
		elseif ls_tipo_rpt = '3' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_t3_tbl'
		elseif ls_tipo_rpt = '4' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_t4_tbl'
		else
			MessageBox('Error', 'Tipo de reporte Elegido [' + ls_tipo_rpt &
						+ '] no esta implementado o no existe, por favor verifique!', StopSign!)
			return false
		end if
	else
		if ls_tipo_rpt = '1' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_sinlogo_t1_tbl'
		elseif ls_tipo_rpt = '2' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_sinlogo_t2_tbl'
		elseif ls_tipo_rpt = '3' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_sinlogo_t3_tbl'
		elseif ls_tipo_rpt = '4' then
			lstr_param.dw1 = 'd_rpt_cierre_caja_sinlogo_t4_tbl'
		else
			MessageBox('Error', 'Tipo de reporte Elegido [' + ls_tipo_rpt &
						+ '] no esta implementado o no existe, por favor verifique!', StopSign!)
			return false
		end if
		
	end if

	lstr_param.titulo = 'Cierre de Caja ' + string(adi_Fecha1, 'dd/mm/yyyy') + '-' + string(adi_Fecha2, 'dd/mm/yyyy')
	lstr_param.date1 		= adi_fecha1
	lstr_param.date2 		= adi_fecha2
	lstr_param.string1 	= gs_empresa
	lstr_param.string2 	= gs_user
	lstr_param.string3 	= gs_origen
	lstr_param.tipo		= 'CIERRE_CAJA_PREVIEW'
	
	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if


return true
end function

public function boolean of_print_despacho (string as_nro_registro);Long ll_height, ll_count_almacen

//Imprimo el comprobante
if upper(gs_empresa) = 'FRANCIS' then
	if FileExists(gs_logo) then
		ids_despacho.DataObject = 'd_rpt_despacho_pos_francis_tbl'
	else
		ids_despacho.DataObject = 'd_rpt_despacho_pos_francis_sinlogo_tbl'
	end if

else
	if FileExists(gs_logo) then
		ids_despacho.DataObject = 'd_rpt_despacho_pos_tbl'
	else
		ids_despacho.DataObject = 'd_rpt_despacho_pos_sinlogo_tbl'
	end if
end if

ids_despacho.SetTransObject(SQLCA)

ids_despacho.Retrieve(as_nro_registro, gs_empresa)

if ids_despacho.RowCount( ) = 0 then
	MessageBox('Error', 'No existen registros para el ticket de DESPACHO ' + as_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

//Cuento el nro de almacenes
select count(distinct t.almacen )
	into :ll_count_almacen
from FS_FACTURA_SIMPL_DET t
where t.nro_registro = :as_nro_registro;

//ASigno el tamaño requerido
ll_height = il_height_despacho + il_header_row_alm * ll_count_almacen + il_header_row_desp * ids_despacho.RowCount( ) 
ids_despacho.Object.DataWindow.Print.Paper.Size = 256 
ids_despacho.Object.DataWindow.Print.CustomPage.Width = il_width_efact
ids_despacho.Object.DataWindow.Print.CustomPage.Length = ll_height

//Coloco el logo
if FileExists(gs_logo) then
	ids_despacho.object.p_logo.filename = gs_logo
end if

//Imprimo el ticket
ids_despacho.Print()

return true
end function

public function boolean of_print_efact (string as_tipo_doc, string as_nro_doc, boolean ab_preview);Long 		ll_height, ll_rows_fp, ll_i
Date		ld_fecha
string	ls_origen, ls_direccion, ls_fono, ls_serie

try 
	
	/*
	if FileExists(gs_logo) then
		ids_ticket.DataObject = 'd_rpt_ticket_termica_tbl'
	else
		ids_ticket.DataObject = 'd_rpt_ticket_termica_sinlogo_tbl'
	end if
	*/
	
	//Obtengo la serie
	select PKG_FACT_ELECTRONICA.of_get_serie(:as_nro_doc)
		into :ls_serie
	from dual;
	
	ids_ticket.DataObject = this.of_select_DataObject('', as_tipo_doc, ls_serie, 'L')
	
	ids_ticket.SetTransObject(SQLCA)
	
	if not ab_preview then
	
		ids_ticket.Retrieve(as_tipo_doc, as_nro_doc, gs_empresa)
		
		if ids_ticket.RowCount( ) = 0 then
			MessageBox('Error', 'No existen registros para el comprobante ' + as_tipo_doc + '/' + as_nro_doc + ', por favor verifique!', StopSign!)
			return false
		end if
		
		//Actualizar la dirección y el telefono por origen
		ls_origen = ids_ticket.object.cod_origen [1]
		
		ls_direccion 	= gnvo_app.empresa.of_direccion(ls_origen)
		ls_fono			= gnvo_app.empresa.of_telefono(ls_origen)	
		
		for ll_i = 1 to ids_ticket.RowCount()
			ids_ticket.object.direccion [ll_i] = ls_direccion
			ids_ticket.object.fono_fijo [ll_i] = ls_fono
		next
		
		ld_fecha = Date(ids_ticket.object.fec_registro [1])
		
		//ASigno el tamaño requerido
		ll_height = il_height_efact + il_height_row_efact * ids_ticket.RowCount( ) 
		ids_ticket.Object.DataWindow.Print.Paper.Size = 256 
		ids_ticket.Object.DataWindow.Print.CustomPage.Width = il_width_efact
		ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height
		
		//Coloco el logo
		if FileExists(gs_logo) then
			ids_ticket.object.p_logo.filename = gs_logo
		end if
		
		//Lleno los datos necesarios
		if trim(as_tipo_Doc) <> 'NVC' then
			ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
			ids_ticket.object.url_t.text 					= this.is_url
			ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
			
			//Genero el codigo QR
			if not this.of_generar_qrcode( ld_fecha ) then return false
			
			//Genero el archivo PDF
			if not this.of_generar_pdf( ld_fecha ) then return false
		end if
		
		//Imprimo el ticket
		if trim(as_tipo_Doc) = 'NVC' then
			if gnvo_app.of_get_parametro( "VTA_PRINT_NOTA_VENTA", "0") = "1" then
				ids_ticket.Print()
			end if
		else
			ids_ticket.Print()
		end if
		
		if trim(as_tipo_Doc) <> 'NVC' then
			if gnvo_app.of_get_parametro( "DOBLE_COMPROBANTE", "0") = "1" then
				ids_ticket.Print()
			end if
		end if
		
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false
end try





end function

public function boolean of_config_dw_ce (u_dw_rpt adw_reporte);Long 			ll_height, ll_rows_fp, ll_i
Date			ld_fecha
string		ls_origen, ls_direccion, ls_fono, ls_flag_detraccion, ls_tipo_doc, ls_nro_doc, &
				ls_desc_oper_detr, ls_desc_bien_serv
decimal		ldc_igv, ldc_total, ldc_imp_detraccion, ldc_porc_detraccion
str_qrcode	lstr_qrcode
str_parametros lstr_param

try 
	
	if adw_reporte.RowCount( ) = 0 then
		MessageBox('Error', 'No existen registros para el comprobante. Por favor verifique!', StopSign!)
		return false
	end if
	
	ld_fecha = Date(adw_reporte.object.fecha_documento [1])
	
	//Coloco el logo
	if FileExists(gs_logo) then
		adw_reporte.object.p_logo.filename = gs_logo
	end if
	
	//Lleno los datos necesarios
	if adw_reporte.of_existstext("nro_resolucion_t") then
		adw_reporte.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
	end if
	
	if adw_reporte.of_existstext("url_t") then
		adw_reporte.object.url_t.text 				= this.is_url
	end if
	
	if adw_reporte.of_existstext("devolucion_t") then
		adw_reporte.object.devolucion_t.text 		= this.is_texto_devolucion
	end if
	
	
	//Verifico si tiene o no detraccion
	if adw_reporte.of_existstext("detraccion_t") then
		ls_flag_detraccion = adw_reporte.object.flag_detraccion 			[1]
		
		if ls_flag_detraccion = '1' then
			
			ldc_porc_detraccion 	= Dec(adw_reporte.object.porc_detraccion 	[1])
			ldc_imp_detraccion 	= Dec(adw_reporte.object.imp_detraccion 	[1])
			ls_desc_oper_detr		= adw_reporte.object.oper_detr 				[1]
			ls_desc_bien_serv		= adw_reporte.object.desc_bien_serv 		[1]
			
			adw_reporte.object.detraccion_t.visible = '1'
			adw_reporte.object.detraccion_t.text 	= "OPERACION SUJETA AL SISTEMA DE PAGO DE OBLIGACIONES " &
																+ "TRIBUTARIAS CON EL GOBIERNO CENTRAL. BCO DE LA NACION NRO: " &
																+ gnvo_app.finparam.is_cnta_cnte_detraccion &
																+ " (OPERACIONES AFECTAS s/. 700.00 SOLES POR CLIENTE) " &
																+ "RESOLUCIÓN No. 207-2004 SU." &
																+ "~r~nOPERACION: " + ls_desc_oper_detr &
																+ " BIEN o SERV: " + ls_desc_bien_serv &
																+ "~r~nPORCENTAJE: " + string(ldc_porc_detraccion, '####,##0.00') + "%" &
																+ " Importe Detraccion: " + gnvo_app.is_soles + " " + string(ldc_imp_detraccion, '####,##0.00')
		else
			adw_reporte.object.detraccion_t.visible = '0'
			adw_reporte.object.detraccion_t.text 	= ""
		end if
	end if
	
	//Genero el codigo QR
	if adw_reporte.of_existspicturename("p_codeqr") then
		lstr_qrcode.tipo_doc 		= adw_reporte.object.tipo_doc 		[1]
		lstr_qrcode.nro_doc 			= adw_reporte.object.nro_doc 			[1]
		lstr_qrcode.ruc_emisor 		= adw_reporte.object.ruc_emisor 		[1]
		lstr_qrcode.serie 			= adw_reporte.object.serie 			[1]
		lstr_qrcode.numero 			= adw_reporte.object.numero 			[1]
		lstr_qrcode.tipo_doc_sunat = adw_reporte.object.tipo_doc_sunat	[1]
		lstr_qrcode.tipo_doc_ident	= adw_reporte.object.tipo_doc_ident [1]
		lstr_qrcode.nro_doc_ident 	= adw_reporte.object.ruc_dni 			[1]
		
		//Acumulo el IGV y el total
		ldc_igv = 0
		ldc_total = 0
		for ll_i = 1 to adw_reporte.RowCount()
			ldc_igv 		+= Dec(adw_reporte.object.importe_igv 	[ll_i])
			ldc_total 	+= Dec(adw_reporte.object.sub_total 	[ll_i])
		next
		
		lstr_qrcode.imp_igv 		= ldc_igv
		lstr_qrcode.imp_total 	= ldc_igv + ldc_total
		lstr_qrcode.fec_emision	= Date(adw_reporte.object.fecha_documento 	[1])
	
		if not this.of_generar_qrcode( lstr_qrcode, adw_reporte ) then return false
	end if
	
	//Genero el archivo PDF
	if not this.of_generar_pdf( lstr_qrcode, adw_reporte ) then return false
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false
end try





end function

public function boolean of_config_dw_cierre_caja (u_dw_rpt adw_report);if adw_report.RowCount( ) = 0 then
	MessageBox('Error', 'No existen registros para el reporte, por favor verifique!', StopSign!)
	return false
end if

//ASigno el tamaño requerido
adw_report.Object.DataWindow.Print.Paper.Size = 256 
adw_report.Object.DataWindow.Print.CustomPage.Width = il_width_efact
//ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height


//Coloco el logo
if FileExists(gs_logo) then
	adw_report.object.p_logo.filename = gs_logo
end if	
	

return true
end function

public function boolean of_print_mov_almacen (string as_nro_vale);Long ll_height, ll_count_almacen

//Imprimo el comprobante
ids_despacho.DataObject = 'd_rpt_mov_almacen_tbl'
ids_despacho.SetTransObject(SQLCA)

ids_despacho.Retrieve(as_nro_Vale, gs_empresa)

if ids_despacho.RowCount( ) = 0 then
	MessageBox('Error', 'No existen registros para el MOVIMIENTO DE ALMACEN ' + as_nro_Vale + ', por favor verifique!', StopSign!)
	return false
end if

//ASigno el tamaño requerido
ll_height = il_height_despacho + il_header_row_alm + il_header_row_desp * ids_despacho.RowCount( ) 
ids_despacho.Object.DataWindow.Print.Paper.Size = 256 
ids_despacho.Object.DataWindow.Print.CustomPage.Width = il_width_efact
ids_despacho.Object.DataWindow.Print.CustomPage.Length = ll_height

//Coloco el logo
ids_despacho.object.p_logo.filename = gs_logo

//Imprimo el ticket
ids_despacho.Print()

return true
end function

public function boolean of_export_ce_pdf (string as_tipo_doc, string as_nro_doc);Long 			ll_height, ll_rows_fp, ll_i
Date			ld_fecha
string		ls_origen, ls_direccion, ls_fono, ls_flag_mercado, ls_mensaje, ls_flag_detraccion
Decimal		ldc_igv, ldc_total
str_qrcode	lstr_qrcode

try 
	//Exporto el documento a PDF
	if this.is_impresion_termica = "0" then
		//Verifica el flag_mercado
		select flag_mercado
			into :ls_flag_mercado
		from cntas_cobrar cc
		where cc.tipo_doc = :as_tipo_doc
		  and cc.nro_doc	= :as_nro_doc;
		
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			MessageBox('Error', 'No existe registro ' + as_tipo_doc + '/' + as_nro_doc + 'en CNTAS_COBRAR. Por favor verifique!', StopSign!)
			return false
		end if
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un erro al consultar al tabla CNTAS_COBRAR. Mensaje: ' &
				+ ls_mensaje + '. Por favor verifique!', StopSign!)
			return false
		end if

		if ls_flag_mercado = 'L' then
			ids_ticket.DataObject = 'd_rpt_comp_elect_tbl'
		else
			ids_ticket.DataObject = 'd_rpt_comp_elect_exp_tbl'
		end if

	else
		if FileExists(gs_logo) then
			ids_ticket.DataObject = 'd_rpt_ticket_termica_tbl'
		else
			ids_ticket.DataObject = 'd_rpt_ticket_termica_sinlogo_tbl'
		end if
	end if
	
	//REcupero los registros
	ids_ticket.SetTransObject(SQLCA)
	
	ids_ticket.Retrieve(as_tipo_doc, as_nro_doc, gs_empresa)

	if ids_ticket.RowCount( ) = 0 then
		MessageBox('Error', 'No existen registros para el comprobante ' + as_tipo_doc + '/' + as_nro_doc + ', por favor verifique!', StopSign!)
		return false
	end if

	//Generación del archivo PDF
	if this.is_impresion_termica = "0" then
		ld_fecha = Date(ids_ticket.object.fecha_documento [1])
		
		//Coloco el logo
		if FileExists(gs_logo) then
			ids_ticket.object.p_logo.filename = gs_logo
		end if
		
		//Lleno los datos necesarios
		ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
		ids_ticket.object.url_t.text 					= this.is_url
		ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
		
		
		//Verifico si tiene o no detraccion
		ls_flag_detraccion = ids_ticket.object.flag_detraccion 			[1]
		
		if ls_flag_detraccion = '1' then
			ids_ticket.object.detraccion_t.visible = '1'
			ids_ticket.object.detraccion_t.text 	= "OPERACION SUJETA AL SISTEMA DE PAGO DE OBLIGACIONES " &
																+ "TRIBUTARIAS CON EL GOBIERNO CENTRAL. BCO DE LA NACION NRO: " &
																+ gnvo_app.finparam.is_cnta_cnte_detraccion &
																+ " (OPERACIONES AFECTAS s/. 700.00 SOLES POR CLIENTE) " &
																+ "RESOLUCIÓN No. 207-2004 SU"
		else
			ids_ticket.object.detraccion_t.visible = '0'
			ids_ticket.object.detraccion_t.text 	= ""
		end if
		
		//Genero el codigo QR
		lstr_qrcode.tipo_doc 		= ids_ticket.object.tipo_doc 			[1]
		lstr_qrcode.nro_doc 			= ids_ticket.object.nro_doc 			[1]
		lstr_qrcode.ruc_emisor 		= ids_ticket.object.ruc_emisor 		[1]
		lstr_qrcode.serie 			= ids_ticket.object.serie 				[1]
		lstr_qrcode.numero 			= ids_ticket.object.numero 			[1]
		lstr_qrcode.tipo_doc_sunat = ids_ticket.object.tipo_doc_sunat	[1]
		lstr_qrcode.tipo_doc_ident	= ids_ticket.object.tipo_doc_ident 	[1]
		lstr_qrcode.nro_doc_ident 	= ids_ticket.object.ruc_dni 			[1]
		
		//Acumulo el IGV y el total
		ldc_igv = 0
		ldc_total = 0
		for ll_i = 1 to ids_ticket.RowCount()
			ldc_igv 		+= Dec(ids_ticket.object.importe_igv 	[ll_i])
			ldc_total 	+= Dec(ids_ticket.object.sub_total 		[ll_i])
		next
		
		lstr_qrcode.imp_igv 		= ldc_igv
		lstr_qrcode.imp_total 	= ldc_igv + ldc_total
		lstr_qrcode.fec_emision	= Date(ids_ticket.object.fecha_documento 	[1])

		if not this.of_generar_qrcode( lstr_qrcode ) then return false
		
		//Genero el archivo PDF
		if not this.of_generar_pdf( lstr_qrcode ) then return false
		
	else
		if upper(gs_empresa) = 'SERVIMOTOR' then
			ls_origen = ids_ticket.object.cod_origen [1]
			
			ls_direccion 	= gnvo_app.empresa.of_direccion(ls_origen)
			ls_fono			= gnvo_app.empresa.of_telefono(ls_origen)	
			
			for ll_i = 1 to ids_ticket.RowCount()
				ids_ticket.object.direccion [ll_i] = ls_direccion
				ids_ticket.object.fono_fijo [ll_i] = ls_fono
			next
		end if
		
		ld_fecha = Date(ids_ticket.object.fec_registro [1])
		
		//ASigno el tamaño requerido
		ll_height = il_height_efact + il_height_row_efact * ids_ticket.RowCount( ) 
		ids_ticket.Object.DataWindow.Print.Paper.Size = 256 
		ids_ticket.Object.DataWindow.Print.CustomPage.Width = il_width_efact
		ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height
		
		//Coloco el logo
		if FileExists(gs_logo) then
			ids_ticket.object.p_logo.filename = gs_logo
		end if
		
		//Lleno los datos necesarios
		ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
		ids_ticket.object.url_t.text 					= this.is_url
		ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
		
		//Genero el codigo QR
		if not this.of_generar_qrcode( ld_fecha ) then return false
		
		//Genero el archivo PDF
		if not this.of_generar_pdf( ld_fecha ) then return false
		
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false
end try





end function

public function boolean of_send_email (string as_nro_registro, string as_tipo_doc, string as_nro_doc);String 					ls_email_cliente, ls_email_soporte
String 					ls_filename_pdf, ls_filename_xml, ls_nom_cliente, ls_nom_user, ls_email_user
String					ls_mensaje, ls_body_html, ls_subject
Long						ll_len
n_cst_emailMessage	lnvo_msg

try 
	invo_wait.of_mensaje("Validando inputs")
	if not this.of_valida_inputs(as_nro_registro, as_tipo_doc, as_nro_doc) then return false
	
	//Obtengo el email y el nombre del cliente
	if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
		select t.nom_proveedor, t.email, u.email, u.nombre
			into :ls_nom_cliente, :ls_email_cliente, :ls_email_user, :ls_nom_user
		  from proveedor 			t,
		  		 fs_factura_simpl f,
				 usuario				u
		 where f.cliente 		= t.proveedor
		   and f.cod_usr 		= u.cod_usr (+)
		   and f.nro_registro = :as_nro_registro;

		if SQLCA.SQLCode = 100 then
			ls_mensaje = SQLCA.SQLErrText
			rollback;
			MessageBox('Error', 'No existe codigo de relacion para el registro ' + as_nro_registro &
									+ '.Por favor verifique!', StopSign!)
			return false			
		end if

	else
		select t.nom_proveedor, t.email, u.email, u.nombre
		  into :ls_nom_cliente, :ls_email_cliente, :ls_email_user, :ls_nom_user
		  from proveedor 		t,
		  		 cntas_cobrar 	cc,
				 usuario			u
		 where cc.cod_relacion 	= t.proveedor
		   and cc.cod_usr 		= u.cod_usr (+)
		   and cc.tipo_doc		= :as_tipo_doc
			and cc.nro_doc			= :as_nro_doc;
		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = SQLCA.SQLErrText
			rollback;
			MessageBox('Error', 'No existe codigo de relacion para el comprobante ' + trim(as_tipo_doc) &
									+ '/' + as_nro_doc + '.Por favor verifique!', StopSign!)
			return false			
		end if

	end if	
	
	//Añado el email del cliente al arreglo de emails
	if IsNull(ls_email_cliente) or trim(ls_email_cliente) = '' then
		//Valido si se ingreso el email del cliente
		//if this.is_send_email_only_cliente = '1' then return false
	end if
	
	//Si el email del cliente es valido entonces lo agrego
	try
		if trim(ls_email_cliente) <> '' and pos(ls_email_cliente, '@', 1) > 0 then
			
			if pos(ls_email_cliente, '/', 1) > 0 or pos(ls_email_cliente, ';', 1) > 0 then
			
				//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
				if not lnvo_msg.of_add_emails_client_from_string(ls_nom_cliente, ls_email_cliente) then return false
				
			else
				//Si no solamente adiciono el email del cliente como un unico email
				if not invo_smtp.of_ValidEmail(ls_email_cliente, ls_mensaje) then
				
						
					yield()
					invo_wait.of_mensaje("Error al validar: " + ls_mensaje)
					sleep(2)
					yield()
	
					//invo_wait.of_close()
					
					//return false
				end if
				
				invo_wait.of_mensaje("Adicionando Email del cliente")
				if not lnvo_msg.of_add_email_to(ls_nom_cliente, ls_email_cliente) then return false
	
			end if
			
		else
			//if this.is_send_email_only_cliente = '1' then return false
		end if
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del cliente: " + e.getMessage())
	end try
	
	//Adiciono el email del usuario que lo ha creado
	if Not IsNull(ls_email_user) and trim(ls_email_user) <> '' then
		if not invo_smtp.of_ValidEmail(ls_email_user, ls_mensaje) then
		
				
			yield()
			invo_wait.of_mensaje("Error al validar email del usuario " + ls_mensaje + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()
	
			//invo_wait.of_close()
			
			//return false
		else
			if not lnvo_msg.of_add_email_to(ls_nom_user, ls_email_user) then return false
		end if
		
		
	end if
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el mensaje que sería HTML
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	if not this.of_get_body_subject(as_nro_registro, as_tipo_doc, as_nro_doc, ls_body_html, ls_subject) then return false
	
	//Poner Body y Subject (Asunto)
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Obtengo los Archivos correctos
	ls_filename_pdf = this.of_get_pdf_filename(as_nro_Registro, as_tipo_doc, as_nro_doc)
	ls_filename_xml = this.of_get_xml_filename(as_nro_Registro, as_tipo_doc, as_nro_doc)
	
	invo_wait.of_mensaje("Adicionando Archivos")
	//Adiciono ambos archivos al email
	if trim(ls_filename_pdf) <> '' then 
		lnvo_msg.of_add_attach(ls_filename_pdf)
	end if
	if trim(ls_filename_xml) <> '' then 
		lnvo_msg.of_add_attach(ls_filename_xml)
	end if
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	//Actualizo la fecha de envio de email
	invo_wait.of_mensaje("Actualizando Fecha de Envio de Email")
	
	if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
		
		update sunat_envio_ce t
			set t.fec_envio_email = sysdate
		  where t.nro_envio_id in (select f.nro_envio_id
											  from fs_factura_simpl f
											 where f.nro_registro = :as_nro_registro);
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			rollback;
			MessageBox('Error', 'No se pudo actualizar la fec_envio_email en la tabla SUNAT_ENVIO_CE  ' &
									+ 'con numero de registro: ' + as_nro_registro &
									+ 'Mensaje de Error: ' + ls_mensaje + '.Por favor verifique!', StopSign!)
			return false			
		end if
											 
	else
		update sunat_envio_ce t
			set t.fec_envio_email = sysdate
		  where t.nro_envio_id in (select cc.nro_envio_id
											  from cntas_cobrar cc
											 where cc.tipo_doc 	= :as_tipo_doc
												and cc.nro_doc		= :as_nro_doc);
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			rollback;
			MessageBox('Error', 'No se pudo actualizar la fec_envio_email en la tabla SUNAT_ENVIO_CE  ' &
									+ 'con Nro de Comprobante: ' + trim(as_tipo_doc) + '/' + as_nro_doc &
									+ 'Mensaje de Error: ' + ls_mensaje + '.Por favor verifique!', StopSign!)
			return false			
		end if
	end if

	commit;

	invo_wait.of_mensaje("Fecha de Envio Actualizada correctamente")
	
	return true
		

	
catch ( Exception ex )
	
	//gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function string of_get_pdf_filename (string as_nro_registro, string as_tipo_doc, string as_nro_doc);String			ls_path, ls_file_pdf, ls_tipo_doc, ls_serie_cxc, ls_nro_cxc, ls_flag_mercado
Date				ld_fec_emision
str_parametros	lstr_param

//Valido la informacion
if not this.of_valida_inputs(as_nro_registro, as_tipo_doc, as_nro_doc) then return ''
	
//Obtengo la fecha de emision
if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
	
	select 	trunc(fec_registro), dt.cod_sunat,
				fs.serie_cxc,
				lpad(trim(fs.nro_cxc), 8, '0')
	  into 	:ld_fec_emision, :ls_tipo_doc,
	  			:ls_serie_cxc,
				:ls_nro_cxc
	  from 	fs_factura_simpl 	fs,
	  			doc_tipo				dt
	 where fs.tipo_doc_cxc	= dt.tipo_doc
	   and nro_registro 		= :as_nro_registro;
	 
else 	 
	select 	trunc(cc.fecha_documento), dt.cod_sunat,
				pkg_fact_electronica.of_get_serie(cc.nro_doc),
				pkg_fact_electronica.of_get_nro(cc.nro_doc),
				nvl(flag_mercado,'L')
	  into 	:ld_fec_emision, :ls_tipo_doc,
	  			:ls_serie_cxc,
				:ls_nro_cxc,
				:ls_flag_mercado
	  from 	cntas_cobrar 	cc,
	  			doc_tipo			dt
	 where cc.tipo_doc	= dt.tipo_doc
	   and cc.tipo_doc 	= :as_tipo_doc
	   and cc.nro_doc		= :as_nro_doc;
end if


//Directorio donde se guardan los PDF
ls_path = this.is_path_sigre + '\EFACT_PDF\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			  + '\' + string(ld_fec_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

//Nombre del archivo  PDF
ls_file_pdf = ls_path + trim(ls_tipo_doc) + '_' + ls_serie_cxc + '-' + ls_nro_cxc + '.pdf'

if not FileExists(ls_file_pdf) then 
	if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
		if not this.of_create_only_pdf(as_nro_registro) then return ''
	else
		lstr_param.flag_mercado = ls_flag_mercado 
		if not this.of_create_only_pdf(as_tipo_doc, ls_serie_cxc, as_nro_doc, lstr_param) then return ''
	end if
	
	return ls_file_pdf
end if

return ls_file_pdf
end function

public function boolean of_valida_inputs (string as_nro_registro, string as_tipo_doc, string as_nro_doc);//Valido la informacion
if (IsNull(as_nro_registro) or trim(as_nro_registro) = '') and &
   (IsNull(as_tipo_doc) or trim(as_tipo_doc) = '') and &
	(IsNull(as_nro_doc) or trim(as_nro_doc) = '') then
	
	MessageBox('Error', 'Error en funcion of_get_pdf_filename(). No ha especificado ningun parametro valido', StopSign!)
	return false

end if

return true
end function

public function boolean of_get_body_subject (string as_nro_registro, string as_tipo_doc, string as_nro_doc, ref string as_body_html, ref string as_subject);string 	ls_ruc_dni, ls_nom_cliente, ls_tipo_doc, ls_full_nro_doc, ls_nom_sucursal, ls_moneda,&
			ls_flag_afecto_igv
Decimal	ldc_total_base_imponible, ldc_total_descuento, ldc_total_igv, ldc_total_doc, &
			ldc_icbper, ldc_total_icbper, ldc_total_op_grav, ldc_total_op_inaf, ldc_total_op_exon, &
			ldc_total_op_grat, ldc_total_op_expo
Long		ll_Row
date		ld_fec_emision

//Detalle del registro
decimal	ldc_precio_unit, ldc_igv, ldc_descuento, ldc_cantidad, ldc_subtotal
String	ls_codigo, ls_descripcion, ls_und
Long		ll_nro_item

if not IsNull(as_nro_registro) and trim(as_nro_Registro) <> '' then
	ids_boletas.DataObject = 'd_cns_fs_factura_simpl_body_tbl'
	
	ids_boletas.setTransObject(SQLCA)
	ids_boletas.Retrieve(as_nro_registro)
	
else
	ids_boletas.DataObject = 'd_cns_cntas_cobrar_body_tbl'
	
	ids_boletas.setTransObject(SQLCA)
	ids_boletas.Retrieve(as_tipo_doc, as_nro_doc)
	
end if

if ids_boletas.RowCount() = 0 then
	if not IsNull(as_nro_registro) and trim(as_nro_Registro) <> '' then
		MessageBox('Error', 'No hay registros para fs_factura_simpl. Nro Registro: ' + as_nro_registro, StopSign!)
		return false
		
	else
		
		MessageBox('Error', 'No hay registros para cntas_cobrar. Nro Comprobante: ' + as_tipo_doc + '/' + as_nro_doc, StopSign!)
		return false
		
	end if

end if

//Obtengo los datos necesarios
ls_ruc_dni 			= ids_boletas.object.ruc_dni 				[1]
ls_nom_cliente 	= ids_boletas.object.nom_cliente 		[1]
ls_tipo_doc			= ids_boletas.object.tipo_doc 			[1]
ls_full_nro_doc	= ids_boletas.object.full_nro_doc 		[1]
ls_nom_sucursal	= ids_boletas.object.nom_sucursal 		[1]
ls_moneda			= ids_boletas.object.cod_moneda 			[1]
ld_fec_emision		= Date(ids_boletas.object.fec_emision 	[1])

if IsNull(ls_full_nro_doc) or trim(ls_full_nro_doc) = '' then
	MessageBox('Error', 'El nro completo del comprobante esta VACIO o NULO, es posible que tenga problemas con las matrices contables, por favor corrija e intente nuevamente', stopSign!)
	return false
end if

//Armo la cabecera la tabla
as_body_html = '<table width="100%">'

//1. El saludo preliminar
as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			<h4>Estimado Cliente: </h4>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '	</tr>'

//2. Datos del cliente
as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			<table>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>RUC / DNI</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + ls_ruc_dni + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>RAZON SOCIAL</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + ls_nom_cliente + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>NRO COMPROBANTE</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + trim(ls_tipo_doc) + ' - ' + ls_full_nro_doc + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>FECHA COMPRA</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + string(ld_fec_emision, 'dd/mm/yyyy') + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>SUCURSAL</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + ls_nom_sucursal + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '			</table>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '	</tr>' + char(10) + char(13) 


//3. Linea anterior de verificacion
as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			Se le hace llegar la representación del comprobante de pago correspondiente a la compra realizada con nosotros' + char(10) + char(13) &
				  + '		</td>' + char(10) + char(13) &
				  + '	</TR>' + char(10) + char(13)

//4. Cabecera de tabla del detalle de venta
as_body_html += '	<TR>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			<table border="1" cellspacing="0" cellpadding="5" style="font-family: Lucida Sans Unicode, Lucida Grande, Sans-Serif; font-size: 12px;">' + char(10) + char(13) &
				  + '				<tr style="font-size: 13px;     ' + char(10) + char(13) &
				  + '						   font-weight: normal;   ' + char(10) + char(13) &  
				  + '						   padding: 8px;     	  ' + char(10) + char(13) &
				  + '						   background: #b9c9fe;   ' + char(10) + char(13) &
				  + '						   border-top: 4px solid #aabcfe;    ' + char(10) + char(13) &
				  + '						   border-bottom: 1px solid #fff; ' + char(10) + char(13) &
				  + '						   color: #039;">' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						NRO ITEM' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						CODIGO' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center" width="300px">' + char(10) + char(13) &
				  + '						DESCRIPCION' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						UNIDAD' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						CANTIDAD' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						MONEDA' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						PRECIO UNITARIO' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						DESCUENTO' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						IGV' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						ICBPER' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						SUBTOTAL' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13)

//5. Inserto el detalle del comprobante,
ldc_total_base_imponible 	= 0
ldc_total_descuento			= 0
ldc_total_igv					= 0
ldc_total_doc					= 0
ldc_total_icbper				= 0

//Totales
ldc_total_op_grav				= 0
ldc_total_op_inaf				= 0
ldc_total_op_exon				= 0
ldc_total_op_grat				= 0
ldc_total_op_expo				= 0

for ll_row = 1 to ids_boletas.RowCount()
	ll_nro_item			= Long(ids_boletas.object.nro_item 		[ll_row])
	ls_codigo 			= ids_boletas.object.codigo 				[ll_row]
	ls_descripcion 	= ids_boletas.object.descripcion			[ll_row]
	ls_und 				= ids_boletas.object.und 					[ll_row]
	ls_flag_afecto_igv= ids_boletas.object.flag_afecto_igv	[ll_row]
	
	If IsNull(ls_codigo) then ls_codigo = ''
	If IsNull(ls_Descripcion) then ls_descripcion = ''
	If IsNull(ls_und) then ls_und = ''
	
	ldc_cantidad	= Dec(ids_boletas.object.cant_proyect	[ll_row])
	ldc_precio_unit= Dec(ids_boletas.object.precio_unit	[ll_row])
	ldc_descuento	= Dec(ids_boletas.object.descuento		[ll_row])
	ldc_igv			= Dec(ids_boletas.object.importe_igv	[ll_row])
	ldc_icbper		= Dec(ids_boletas.object.icbper			[ll_row])
	
	ldc_subtotal 	= ldc_cantidad * (ldc_precio_unit - ldc_descuento + ldc_igv) + ldc_icbper
	
	//Acumulo los totales
	ldc_total_base_imponible 	+= ldc_precio_unit * ldc_cantidad
	ldc_total_descuento			+= ldc_descuento * ldc_cantidad
	ldc_total_igv					+= ldc_igv * ldc_cantidad
	ldc_total_doc					+= ldc_subtotal
	ldc_total_icbper				+= ldc_icbper
	
	if ls_flag_afecto_igv = '1' then
		ldc_total_op_grav			+= ldc_precio_unit * ldc_cantidad
	elseif ls_flag_afecto_igv = '2' then
		ldc_total_op_inaf			+= ldc_precio_unit * ldc_cantidad
	elseif ls_flag_afecto_igv = '3' then
		ldc_total_op_exon			+= ldc_precio_unit * ldc_cantidad
	elseif ls_flag_afecto_igv = '4' then
		ldc_total_op_expo			+= ldc_precio_unit * ldc_cantidad
	elseif ls_flag_afecto_igv = '0' then
		ldc_total_op_grat			+= ldc_precio_unit * ldc_cantidad
	end if
	
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')

	
	as_body_html += '					<tr>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ll_nro_item, '#,###') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="center">' + char(10) + char(13) &
					  + '						' + ls_codigo + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="left">' + char(10) + char(13) &
					  + '						' + ls_descripcion + char(10) + char(13) &
					  + '					</td >' + char(10) + char(13) &
					  + '					<td valign="top" align="center">' + char(10) + char(13) &
					  + '						' + ls_und + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ldc_cantidad, '###,##0.0000') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="center">' + char(10) + char(13) &
					  + '						' + ls_moneda + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ldc_precio_unit, '###,##0.0000') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ldc_descuento, '###,##0.0000') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ldc_igv, '###,##0.0000') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ldc_icbper, '###,##0.0000') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '					<td valign="top" align="right">' + char(10) + char(13) &
					  + '						' + string(ldc_subtotal, '###,##0.0000') + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13)
next

//6. Linea de cierre con los totales
ldc_total_doc = ldc_total_base_imponible - ldc_total_descuento + ldc_total_igv + ldc_total_icbper

as_body_html += '				<tr style="background: #eee; font-weight: bold">' + char(10) + char(13) &
				  + '					<td valign="top" align="right" colspan="5">' + char(10) + char(13) &
				  + '						TOTAL GENERAL :' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="center">' + char(10) + char(13) &
				  + '						' + ls_moneda + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="right">' + char(10) + char(13) &
				  + '						' + string(ldc_total_base_imponible, '###,##0.0000') + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="right">' + char(10) + char(13) &
				  + '						' + string(ldc_total_descuento, '###,##0.0000') + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="right">' + char(10) + char(13) &
				  + '						' + string(ldc_total_igv, '###,##0.0000') + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="right">' + char(10) + char(13) &
				  + '						' + string(ldc_total_icbper, '###,##0.0000') + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '					<td valign="top" align="right">' + char(10) + char(13) &
				  + '						' + string(ldc_total_doc, '###,##0.0000') + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td colspan="11" align="right">' + char(10) + char(13) &
				  + '						<table>' + char(10) + char(13) &
				  + '							<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total Op. Gravadas ' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_op_grav, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total Op. Inafectas ' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_op_inaf, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total Op. Exoneradas ' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_op_exon, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total Op. Gratuitas ' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_op_grat, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &		
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total Op. Exportaciones ' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_op_expo, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &					  
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total IGV' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_igv, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									ICBPER' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_icbper, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &
				  + '			   			<tr>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									Total Comprobante' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td style="font-weight: bold">' + char(10) + char(13) &
				  + '									:' + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '								<td valign="top" align="center">' + char(10) + char(13) &
				  + '									' + ls_moneda + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &				  
				  + '								<td align="right">' + char(10) + char(13) &
				  + '									' + string(ldc_total_doc, '###,##0.00') + char(10) + char(13) &
				  + '								</td>' + char(10) + char(13) &
				  + '			   			</tr>' + char(10) + char(13) &
				  + '						</table>' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '	   		</tr>' + char(10) + char(13) &
				  + '			</table>' + char(10) + char(13) &
				  + '		</td>' + char(10) + char(13) &
				  + '	</tr>' + char(10) + char(13) &
				  + ' <tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) 

//7. Sello de Powered by SIGRE
as_body_html += '			<table>' + char(10) + char(13) &
				  + '				<tr style="font-size:10px">' + char(10) + char(13) &
				  + '					<td valign="top" align="right" colspan="10">' + char(10) + char(13) &
				  + '						Powered by SIGRE' + char(10) + char(13) &
				  + '					</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '			</table>' + char(10) + char(13) &
				  + '		</td>' + char(10) + char(13) &
				  + '	</tr>' + char(10) + char(13)
				  
//8. Cierro la tabla
as_body_html += '</table>'

//Ahora preparo el Subject
as_subject = 'DOCUMENTO: ' + trim(ls_tipo_doc) + '-' + ls_full_nro_doc + '. Fecha: ' + string(ld_fec_emision, 'dd/mm/yyyy') &
			  + ' CLIENTE: ' + ls_ruc_dni + '-' + ls_nom_cliente + '. Total Venta: ' + string(ldc_total_doc, '###,##0.00')

//reseteo del datasource
ids_boletas.Reset()

return true
end function

public function boolean of_cxc_factura_smpl_genera (string as_nro_registro);String ls_mensaje
//procedure sp_cxc_factura_smpl(asi_registro fs_factura_simpl.nro_registro%TYPE ) is

DECLARE sp_cxc_factura_smpl PROCEDURE FOR 
	pkg_fact_electronica.sp_cxc_factura_smpl(:as_nro_registro);
	
EXECUTE sp_cxc_factura_smpl ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL Error', "Error en PAQUETE pkg_fact_electronica.sp_cxc_factura_smpl(" + as_nro_registro + "): " + ls_mensaje)	
	return false
end if

COMMIT ;
CLOSE sp_cxc_factura_smpl ;

return true
end function

public function boolean of_cxc_factura_smpl_anula (string as_nro_registro);String ls_mensaje
//  procedure sp_anular_fs_simpl(
//            asi_registro fs_factura_simpl.nro_registro%TYPE 
//  )is

DECLARE sp_anular_fs_simpl PROCEDURE FOR 
	PKG_FACT_ELECTRONICA.sp_anular_fs_simpl(:as_nro_registro);
	
EXECUTE sp_anular_fs_simpl ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL Error', "Error en PAQUETE PKG_FACT_ELECTRONICA.sp_anular_fs_simpl(" + as_nro_registro + "): " + ls_mensaje)	
	return false
end if

COMMIT ;
CLOSE sp_anular_fs_simpl ;

return true
end function

public function boolean of_create_only_pdf (string as_nro_registro, string as_tipo_doc, string as_nro_doc);string 			ls_flag_mercado, ls_mensaje, ls_serie
str_parametros	lstr_param

if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
	
	if not this.of_create_only_pdf(as_nro_registro) then return false
	
else
	
	select nvl(flag_mercado, 'L'),
			 PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc)
		into :ls_flag_mercado,
			  :ls_serie
	from cntas_cobrar cc
	where cc.tipo_doc = :as_tipo_doc
	  and cc.nro_Doc	= :as_nro_doc;
	 
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al consultar la tabla CNTAS_COBRAR. procedimiento of_create_only_pdf(). Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	lstr_param.flag_mercado = ls_flag_mercado 
	if not this.of_create_only_pdf(as_tipo_doc, ls_Serie, as_nro_doc, lstr_param) then return false
end if
	

return true
end function

public function boolean of_anular_pago_fs_smpl (string as_nro_registro, string as_flag_forma_pago, long al_nro_item);// procedure sp_anular_pago_fs_simpl(
//     asi_registro    in fs_factura_simpl_pagos.nro_registro%TYPE,
//     asi_forma_pago  in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
//     ani_nro_item    in fs_factura_simpl_pagos.nro_item%TYPE
//            
//  );

String	ls_mensaje

DECLARE sp_anular_pago_fs_simpl PROCEDURE FOR 
	  pkg_fact_electronica.sp_anular_pago_fs_simpl(:as_nro_registro,
                                               	  :as_flag_forma_pago,
                                               	  :al_nro_item);
	
EXECUTE sp_anular_pago_fs_simpl;		

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	messagebox( "Error ", "Error en FUNCTION pkg_fact_electronica.sp_anular_pago_fs_simpl(). " &
							+ "~r~nNro Registro: " + as_nro_registro &
							+ "~r~nForma Pago: " + as_flag_forma_pago &
							+ "~r~nNro Item: " + String(al_nro_item) &
							+ "~r~nMensaje: " + ls_mensaje, StopSign!)
	return false
end if

close sp_anular_pago_fs_simpl;

return true
end function

public function boolean of_send_email_changes_vta (u_dw_abc adw_detail);String 					ls_email_cliente, ls_email_soporte, ls_mensaje
String					ls_body_html, ls_subject, ls_cod_art, ls_desc_art, ls_cod_sku, ls_und, &
							ls_email_reply
Long						ll_i, ll_item
decimal					ldc_precio_vta_old, ldc_precio_vta_new, ldc_cantidad, ldc_total_cantidad, &
							ldc_total_vta_old, ldc_total_vta_new
boolean					lb_precios_modify
n_cst_emailMessage	lnvo_msg

try 
	
	invo_wait.of_mensaje("Validando inputs")
	
	if adw_detail.RowCount() = 0 then return false
	
	lb_precios_modify = false
	for ll_i = 1 to adw_detail.RowCount()
		//Seleciono el registro
		adw_detail.SelectRow(0, false)
		adw_detail.SelectRow(ll_i, true)
		adw_detail.ScrollToRow(ll_i)
		adw_detail.setRow(ll_i)
		
		ldc_cantidad 			= Dec(adw_detail.object.cantidad [ll_i])
		
		if ldc_cantidad > 0 then
			//Obtener los precios de venta para detectar los cambios
			ldc_precio_vta_old 	= Dec(adw_detail.object.precio_vta_old [ll_i])
			ldc_precio_vta_new 	= Dec(adw_detail.object.precio_vta_new [ll_i])
			
			if IsNull(ldc_precio_vta_new) then ldc_precio_vta_new = 0
			if IsNull(ldc_precio_vta_old) then ldc_precio_vta_old = 0
			
			if ldc_precio_vta_new <= 0 then
				MessageBox('Error', 'Debe Especificar un precio de venta mayor que cero, Por favor verifique!', StopSign!)
				return false
			end if
			
			//Verifico que haya cambiado de precio, pero unicamente si el precio de venta antiguo
			//no es cero
			if ldc_precio_vta_old > 0 and ldc_precio_vta_new <> ldc_precio_vta_old then
				lb_precios_modify = true
			end if
		end if
	next
	
	if not lb_precios_modify then return false
	
	//Ahora inserto el email de soporte
	invo_wait.of_mensaje("Adicionando email de venta")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_VENTA", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el BODY del Correo
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "ARTICULOS QUE CAMBIARON EL PRECIO DE VENTA"
	
	ls_body_html = '<table width="100%">' &
					 + '	<tr>' &
					 + '		<td>' &
					 + '			<h4>Sres. Se lec informa que los siguientes artículos han cambiado de precio de Venta: </h4>'&
					 + '		<td>' &
					 + '	</tr>'&
					 + '	<TR>'&
					 + '		<td>'&
					 + '			<table border="1" cellspacing="0" cellpadding="5" style="font-family: Lucida Sans Unicode, Lucida Grande, Sans-Serif; font-size: 12px;">'&
					 + '				<tr style="font-size: 13px;' &
					 + '						   font-weight: normal;     ' &
					 + '						   padding: 8px;     ' &
					 + '						   background: #b9c9fe; ' &
					 + '						   border-top: 4px solid #aabcfe;    ' &
					 + '						   border-bottom: 1px solid #fff; ' &
					 + '						   color: #039;">' &
					 + '					<td valign="top" align="center">' &
					 + '						NRO ITEM' &
					 + '					</td>' &
					 + '					<td valign="top" align="center">' &
					 + '						CODIGO' &
					 + '					</td>'&
					 + '					<td valign="top" align="center" width="300px">'&
					 + '						DESCRIPCION'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						CODIGO SKU'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						UNIDAD'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						CANTIDAD'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						MONEDA'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						PRECIO UNITARIO ANTERIOR'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						PRECIO UNITARIO NUEVO'&
					 + '					</td>'&
					 + '				</tr>'
	
	ll_item = 1
	ldc_total_cantidad = 0
	ldc_total_vta_old = 0
	ldc_total_vta_new = 0
	
	for ll_i = 1 to adw_detail.RowCount()
		//Obtengo los datos que necesito
		ls_cod_Art 		= adw_detail.object.cod_art		[ll_i]
		ls_desc_art 	= adw_detail.object.desc_art		[ll_i]
		ls_und 			= adw_detail.object.und				[ll_i]
		ls_cod_sku		= adw_detail.object.cod_sku		[ll_i]
		ldc_cantidad 	= Dec(adw_detail.object.cantidad	[ll_i])

		//Obtener los precios de venta para detectar los cambios
		ldc_precio_vta_old = Dec(adw_detail.object.precio_vta_old [ll_i])
		ldc_precio_vta_new = Dec(adw_detail.object.precio_vta_new [ll_i])
		
		//Genero el texto
		if ldc_precio_vta_old > 0 and ldc_precio_vta_new <> ldc_precio_vta_old then
			ldc_total_cantidad 	+= ldc_cantidad
			ldc_total_vta_old 	+= ldc_cantidad * ldc_precio_vta_old
			ldc_total_vta_new 	+= ldc_cantidad * ldc_precio_vta_new
			
			ls_body_html += '				<tr>' &
							  + '					<td valign="top" align="right">' &
							  + '						' + string(ll_item) &
							  + '					</td>' &
							  + '					<td valign="top" align="center">' &
							  + '						' + ls_cod_art &
							  + '					</td>' &
							  + '					<td valign="top" align="left">' &
							  + '						' + ls_desc_art &
							  + '					</td >' &
							  + '					<td valign="top" align="center">' &
							  + '						' + ls_cod_sku &
							  + '					</td>' &
							  + '					<td valign="top" align="center">' &
							  + '						' + ls_und &
							  + '					</td>' &
							  + '					<td valign="top" align="right">' &
							  + '						' + string(ldc_cantidad, '###,##0.00') &
							  + '					</td>' &
							  + '					<td valign="top" align="center">' &
							  + '						' + gnvo_app.is_soles &
							  + '					</td>' &
							  + '					<td valign="top" align="right">' &
							  + '						' + string(ldc_precio_vta_old, '###,##0.00') &
							  + '					</td>' &
							  + '					<td valign="top" align="right">' &
							  + '						' + + string(ldc_precio_vta_new, '###,##0.00') &
							  + '					</td>' &
							  + '				</tr>'

			ll_item ++
		end if

	next	
	
	ls_body_html += '<tr style="background: #eee; font-weight: bold"> '&
					  + '					<td valign="top" align="right" colspan="5">'&
					  + '						TOTAL GENERAL :'&
					  + '					</td>'&
					  + '					<td valign="top" align="center">'&
					  + '						' + string(ldc_total_cantidad, '###,##0.00') &
					  + '					</td>'&
					  + '					<td valign="top" align="center">'&
					  + '						' + gnvo_app.is_soles &
					  + '					</td>'&
					  + '					<td valign="top" align="right">'&
					  + '						' + string(ldc_total_vta_old, '###,##0.00')&
					  + '					</td>'&
					  + '					<td valign="top" align="right">'&
					  + '						' + string(ldc_total_vta_new, '###,##0.00')& 
					  + '					</td>'&
					  + '				</tr>'&
					  + '			</table>'&
					  + '			<table>'&
					  + '				<tr style="font-size:10px">'&
					  + '					<td valign="top" align="right" colspan="10">'&
					  + '						Powered by SIGRE'&
					  + '					</td>'&
					  + '				</tr>'&
					  + '			</table>'&
					  + '		</td>'&
					  + '	</tr>'&
					  + '<table>'
	
	//Poner Body y Subject (Asunto)
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	ls_email_reply = gnvo_app.of_get_parametro("EMAIL_REPLY", 'no-reply@' + gnvo_app.empresa.is_sigla + '.com.pe')
	if not lnvo_msg.of_add_email_to('NO REPLY', ls_email_reply) then return false
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	invo_wait.of_mensaje("Email con los cambios de precio de Venta fue enviado Satisfactoriamente")
	
	return true
		

	
catch ( Exception ex )
	
	invo_wait.of_close()
	
	gnvo_app.of_catch_exception(ex, 'Error al enviar por email los cambios de precio de venta')
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_send_email_changes_cmp (u_dw_abc adw_detail);String 					ls_email_cliente, ls_email_soporte, ls_mensaje
String					ls_body_html, ls_subject, ls_cod_art, ls_desc_art, ls_cod_sku, ls_und, &
							ls_email_reply, ls_proveedor, ls_nom_proveedor, ls_ruc_dni
Long						ll_i, ll_item
decimal					ldc_precio_compra_old, ldc_precio_compra_new, ldc_cantidad, ldc_total_cantidad, &
							ldc_total_compra_old, ldc_total_compra_new
boolean					lb_precios_modify
n_cst_emailMessage	lnvo_msg

try 
	
	invo_wait.of_mensaje("Validando inputs")
	
	if adw_detail.RowCount() = 0 then return false
	
	lb_precios_modify = false
	for ll_i = 1 to adw_detail.RowCount()
		//Seleciono el registro
		adw_detail.SelectRow(0, false)
		adw_detail.SelectRow(ll_i, true)
		adw_detail.ScrollToRow(ll_i)
		adw_detail.setRow(ll_i)
		
		ldc_cantidad = Dec(adw_detail.object.cantidad [ll_i])
		
		if ldc_cantidad > 0 then
			//Obtener los precios de venta para detectar los cambios
			ldc_precio_compra_old = Dec(adw_detail.object.precio_compra_old [ll_i])
			ldc_precio_compra_new = Dec(adw_detail.object.precio_compra_new [ll_i])
			
			if IsNull(ldc_precio_compra_old) then ldc_precio_compra_old = 0
			if IsNull(ldc_precio_compra_new) then ldc_precio_compra_new = 0
			
			if ldc_precio_compra_new <= 0 then
				MessageBox('Error', 'Debe Especificar un precio de compra mayor que cero, Por favor verifique!', StopSign!)
				return false
			end if
			
			//Verifico que haya cambiado de precio, pero unicamente si el precio de venta antiguo
			//no es cero
			if ldc_precio_compra_old > 0 and ldc_precio_compra_new <> ldc_precio_compra_old then
				lb_precios_modify = true
			end if
		end if
	next
	
	if not lb_precios_modify then return false
	
	//Ahora inserto el email de soporte
	invo_wait.of_mensaje("Adicionando email de venta")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_LOGISTICA", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el BODY del Correo
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "ARTICULOS QUE CAMBIARON EL PRECIO DE COMPRA"
	
	ls_body_html = '<table width="100%">' &
					 + '	<tr>' &
					 + '		<td>' &
					 + '			<h4>Sres LOGISTICA se les envia los artículos que han cambiado de precio de compra: </h4>'&
					 + '		<td>' &
					 + '	</tr>'&
					 + '	<TR>'&
					 + '		<td>'&
					 + '			<table border="1" cellspacing="0" cellpadding="5" style="font-family: Lucida Sans Unicode, Lucida Grande, Sans-Serif; font-size: 12px;">'&
					 + '				<tr style="font-size: 13px;' &
					 + '						   font-weight: normal;     ' &
					 + '						   padding: 8px;     ' &
					 + '						   background: #b9c9fe; ' &
					 + '						   border-top: 4px solid #aabcfe;    ' &
					 + '						   border-bottom: 1px solid #fff; ' &
					 + '						   color: #039;">' &
					 + '					<td valign="top" align="center">' &
					 + '						NRO ITEM' &
					 + '					</td>' &
					 + '					<td valign="top" align="center">' &
					 + '						RUC / DNI DEL PROVEEDOR' &
					 + '					</td>'&
					 + '					<td valign="top" align="center">' &
					 + '						RAZON SOCIAL O NOMBRE COMPLETO DEL PROVEEDOR' &
					 + '					</td>'&
					 + '					<td valign="top" align="center">' &
					 + '						CODIGO ARTICULO' &
					 + '					</td>'&
					 + '					<td valign="top" align="center" width="300px">'&
					 + '						DESCRIPCION ARTICULO'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						CODIGO SKU'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						UNIDAD'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						CANTIDAD'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						MONEDA'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						PRECIO COMPRA ANTERIOR'&
					 + '					</td>'&
					 + '					<td valign="top" align="center">'&
					 + '						PRECIO COMPRA NUEVO'&
					 + '					</td>'&
					 + '				</tr>'
	
	ll_item = 1
	ldc_total_cantidad = 0
	ldc_total_compra_old = 0
	ldc_total_compra_new = 0
	
	for ll_i = 1 to adw_detail.RowCount()
		//Obtengo los datos que necesito
		ls_cod_Art 		= adw_detail.object.cod_art		[ll_i]
		ls_desc_art 	= adw_detail.object.desc_art		[ll_i]
		ls_und 			= adw_detail.object.und				[ll_i]
		ls_cod_sku		= adw_detail.object.cod_sku		[ll_i]
		ldc_cantidad 	= Dec(adw_detail.object.cantidad	[ll_i])
		ls_proveedor	= adw_detail.object.proveedor		[ll_i]
		
		if ldc_cantidad > 0 then
			//Obtener los precios de venta para detectar los cambios
			ldc_precio_compra_old = Dec(adw_detail.object.precio_compra_old [ll_i])
			ldc_precio_compra_new = Dec(adw_detail.object.precio_compra_new [ll_i])
			
			//Genero el texto
			if ldc_precio_compra_old > 0 and round(ldc_precio_compra_new,4) <> round(ldc_precio_compra_old,4) then
				ldc_total_cantidad 	+= ldc_cantidad
				ldc_total_compra_old 	+= ldc_cantidad * ldc_precio_compra_old
				ldc_total_compra_new 	+= ldc_cantidad * ldc_precio_compra_new
				
				//Obtengo datos del proveedor
				select p.nom_proveedor,
						 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident)
					into :ls_nom_proveedor, :ls_ruc_dni
				from proveedor p
				where p.proveedor = :ls_proveedor;
				
				if SQLCA.SQLCode = 100 then
					MessageBox('Error', 'No existe el codigo de proveedor ' + ls_proveedor + ' por favor verifique!', StopSign!)
					return false
				end if
				
				ls_body_html += '				<tr>' &
								  + '					<td valign="top" align="right">' &
								  + '						' + string(ll_item) &
								  + '					</td>' &
								  + '					<td valign="top" align="center">' &
								  + '						' + ls_ruc_dni &
								  + '					</td>' &
								  + '					<td valign="top" align="center">' &
								  + '						' + ls_nom_proveedor &
								  + '					</td>' &
								  + '					<td valign="top" align="center">' &
								  + '						' + ls_cod_art &
								  + '					</td>' &
								  + '					<td valign="top" align="left">' &
								  + '						' + ls_desc_art &
								  + '					</td >' &
								  + '					<td valign="top" align="center">' &
								  + '						' + ls_cod_sku &
								  + '					</td>' &
								  + '					<td valign="top" align="center">' &
								  + '						' + ls_und &
								  + '					</td>' &
								  + '					<td valign="top" align="right">' &
								  + '						' + string(ldc_cantidad, '###,##0.00') &
								  + '					</td>' &
								  + '					<td valign="top" align="center">' &
								  + '						' + gnvo_app.is_soles &
								  + '					</td>' &
								  + '					<td valign="top" align="right">' &
								  + '						' + string(ldc_precio_compra_old, '###,##0.00000') &
								  + '					</td>' &
								  + '					<td valign="top" align="right">' &
								  + '						' + + string(ldc_precio_compra_new, '###,##0.0000') &
								  + '					</td>' &
								  + '				</tr>'
	
				ll_item ++
			end if
		end if
	next	
	
	ls_body_html += '<tr style="background: #eee; font-weight: bold"> '&
					  + '					<td valign="top" align="right" colspan="7">'&
					  + '						TOTAL GENERAL :'&
					  + '					</td>'&
					  + '					<td valign="top" align="center">'&
					  + '						' + string(ldc_total_cantidad, '###,##0.00') &
					  + '					</td>'&
					  + '					<td valign="top" align="center">'&
					  + '						' + gnvo_app.is_soles &
					  + '					</td>'&
					  + '					<td valign="top" align="right">'&
					  + '						' + string(ldc_total_compra_old, '###,##0.00')&
					  + '					</td>'&
					  + '					<td valign="top" align="right">'&
					  + '						' + string(ldc_total_compra_new, '###,##0.00')& 
					  + '					</td>'&
					  + '				</tr>'&
					  + '			</table>'&
					  + '			<table>'&
					  + '				<tr style="font-size:10px">'&
					  + '					<td valign="top" align="right" colspan="10">'&
					  + '						Powered by SIGRE'&
					  + '					</td>'&
					  + '				</tr>'&
					  + '			</table>'&
					  + '		</td>'&
					  + '	</tr>'&
					  + '<table>'
	
	//Poner Body y Subject (Asunto)
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	ls_email_reply = gnvo_app.of_get_parametro("EMAIL_REPLY", 'no-reply@' + gnvo_app.empresa.is_sigla + '.com.pe')
	if not lnvo_msg.of_add_email_to('NO REPLY', ls_email_reply) then return false
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	invo_wait.of_mensaje("Email con los cambios de precio de compra fue enviado Satisfactoriamente")
	
	return true
		

	
catch ( Exception ex )
	
	invo_wait.of_close()
	
	gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_resumen_rc_fs (date adi_fecha);String 	ls_texto, ls_nro_rc, ls_nro_rc_id, ls_mensaje, ls_tipo_doc, ls_nro_doc, ls_serie, ls_nro, &
			ls_nro_registro, ls_moneda, ls_tipo_doc_cxc, ls_nro_doc_cxc
String	ls_PathFileXML			
Long		ll_row, ll_nro_envio, ll_ult_nro, ll_nro_item
Decimal	ldc_vta_gravada, ldc_vta_exonerada, ldc_vta_inafecta, ldc_total_igv, ldc_total_vta
Date		ld_hoy

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_lista_bvc_rc_fs_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(adi_fecha)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Aviso', 'No hay boletas pendientes para resumen Diario. Fecha ' &
		+ string(adi_fecha, 'dd/mm/yyyy'), Information!)
	return false
end if

ld_hoy = Date(gnvo_app.of_fecha_actual( ))
/*
SQL> desc sunat_rc_diario
Name            Type          Nullable Default Comments                             
--------------- ------------- -------- ------- ------------------------------------ 
NRO_RC_ID       CHAR(10)                                                            
NRO_RC          VARCHAR2(20)  Y                                                     
FEC_REGISTRO    DATE          Y                                                     
FEC_EMISION     DATE          Y                fecha de emision de los comprobantes 
NRO_ENVIO       NUMBER(4)     Y                                                     
COD_USR         CHAR(6)       Y                                                     
NRO_TICKET      VARCHAR2(20)  Y                                                     
PATH_FILE       VARCHAR2(200) Y                                                     
FEC_ENVIO_SUNAT DATE          Y                                                     
DATA_CDR        BLOB          Y                                                     
DATA_XML        BLOB          Y      
*/


//Obtengo el siguiente numero en la tabla de resumen diario
select nvl(max(nro_envio), 0)
	into :ll_nro_envio
from sunat_rc_diario
where trunc(FEC_REGISTRO) = trunc(:ld_hoy);

//Incremento el numero de envio
ll_nro_envio ++

//Genero el nro_rc
ls_nro_rc = "RC-" + string(ld_hoy, 'yyyymmdd') + "-" + trim(string(ll_nro_envio))

//Inserto en la tabla de SUNAT_RC_DIARIO
ls_nro_rc_id = invo_util.of_set_numera( "SUNAT_RC_DIARIO" )

if IsNull(ls_nro_rc_id) or trim(ls_nro_rc_id) = '' then return false

Insert into SUNAT_RC_DIARIO( 
	nro_rc_id, nro_rc, fec_registro, fec_emision, nro_envio, cod_usr)
values(
	:ls_nro_rc_id, :ls_nro_rc, sysdate, :adi_fecha, :ll_nro_envio, :gs_user);

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al insertar registro en SUNAT_RC_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

//Linea 2 = Datos
ls_texto = '<SummaryDocuments xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '				   xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10) &
			+ '				   xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '				   xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '				   xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '				   xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10)&
			+ '				   xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10)&
			+ '				   xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '				   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+ char(13) + char(10) &
			+ '				   xmlns="urn:sunat:names:specification:ubl:peru:schema:xsd:SummaryDocuments-1">'
			
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

//Linea 3: Firma Digital
ls_texto = '<ext:UBLExtensions>' + char(13) + char(10) 			&
			+ '   <ext:UBLExtension>' + char(13) + char(10)		&
			+ '      <ext:ExtensionContent>'+ char(13) + char(10)	&
			+ '      </ext:ExtensionContent>'+ char(13) + char(10)	&
			+ '   </ext:UBLExtension>' + char(13) + char(10)		&
			+ '</ext:UBLExtensions>'
			
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

//Line 5: Versión de la estructura del documento
ls_texto = '<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

//Line 6: Identificador del resumen
ls_texto = '<cbc:ID>' + ls_nro_rc + '</cbc:ID>'
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)
   
//Line 7: Fecha de emisión de los documentos
ls_texto = '<cbc:ReferenceDate>' + string(adi_fecha, 'yyyy-mm-dd') + '</cbc:ReferenceDate>' 
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)
   
//Line 8: Fecha de generación del resumen
ls_texto = '<cbc:IssueDate>' + string(ld_hoy, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)
    
//Line 9: Signature del archivo
ls_texto = '<cac:Signature>' + char(13) + char(10) &
			+ '   <cbc:ID>sign' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '   <cac:SignatoryParty>' + char(13) + char(10) &
			+ '      <cac:PartyIdentification>' + char(13) + char(10) &
			+ '         <cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '      </cac:PartyIdentification>' + char(13) + char(10) &
			+ '      <cac:PartyName>' + char(13) + char(10) &
			+ '         <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '      </cac:PartyName>' + char(13) + char(10) &
			+ '   </cac:SignatoryParty> '+ char(13) + char(10) &
			+ '   <cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '      <cac:ExternalReference>' + char(13) + char(10)&
			+ '         <cbc:URI>#sign' + gnvo_app.empresa.is_ruc + '</cbc:URI>' + char(13) + char(10) &
			+ '      </cac:ExternalReference>' + char(13) + char(10) &
			+ '   </cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '</cac:Signature>'
			
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)
    
//Line 10: Datos del Emisor
ls_texto = '<cac:AccountingSupplierParty>' + char(13) + char(10) &
    		+ '   <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '   <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '   <cac:Party>' + char(13) + char(10) &
			+ '      <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '         <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '      </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   </cac:Party>' + char(13) + char(10) &
			+ '</cac:AccountingSupplierParty>'
			
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

//Reinicio el nro de item
ll_nro_item = 0

//REcorro el registro
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ll_nro_item ++
	ls_tipo_doc 		= ids_boletas.object.tipo_doc 			[ll_row]
	ls_serie 			= ids_boletas.object.serie 				[ll_row]
	ls_nro				= ids_boletas.object.nro 					[ll_row]
	ls_moneda			= ids_boletas.object.moneda 				[ll_row]
	ls_nro_registro	= ids_boletas.object.nro_registro		[ll_row]
	ldc_vta_gravada 	= Dec(ids_boletas.object.vta_gravada 	[ll_row])
	ldc_vta_exonerada = Dec(ids_boletas.object.vta_exonerada	[ll_row])
	ldc_vta_inafecta 	= Dec(ids_boletas.object.vta_inafecta 	[ll_row])
	ldc_total_igv 		= Dec(ids_boletas.object.total_igv 		[ll_row])	
	
	ls_tipo_doc_cxc	= ids_boletas.object.tipo_doc_cxc		[ll_row]
	ls_nro_doc_cxc		= ids_boletas.object.nro_doc_cxc			[ll_row]
	
	//Total de la venta
	
	if ldc_vta_gravada < 0 then ldc_vta_gravada = 0.00
	if ldc_vta_exonerada < 0 then ldc_vta_exonerada = 0.00
	if ldc_vta_inafecta < 0 then ldc_vta_inafecta = 0.00
	if ldc_total_igv < 0 then ldc_total_igv = 0.00
	
	ldc_total_vta = ldc_vta_gravada + ldc_vta_exonerada + ldc_vta_inafecta + ldc_total_igv
	
	if ls_moneda = gnvo_app.is_soles then
		ls_moneda = 'PEN'
	else
		ls_moneda = 'USD'
	end if
	
	ls_texto = '<sac:SummaryDocumentsLine>' + char(13) + char(10)							&
				+ '  <cbc:LineID>' + trim(string(ll_nro_item)) + '</cbc:LineID>' + char(13) + char(10)	&
				+ '  <cbc:DocumentTypeCode>' + ls_tipo_doc + '</cbc:DocumentTypeCode>'+ char(13) + char(10)	&
				+ '  <sac:DocumentSerialID>' + ls_serie + '</sac:DocumentSerialID>' + char(13) + char(10)		&
				+ '  <sac:StartDocumentNumberID>' + gnvo_app.of_left_trim(ls_nro, '0') + '</sac:StartDocumentNumberID>' + char(13) + char(10)	&
				+ '  <sac:EndDocumentNumberID>' + gnvo_app.of_left_trim(ls_nro, '0') + '</sac:EndDocumentNumberID>' + char(13) + char(10)		&
				+ '  <sac:TotalAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_vta, '#####0.00')) + '</sac:TotalAmount>' + char(13) + char(10) &
				+ '  <sac:BillingPayment> ' + char(13) + char(10) &
				+ '    <cbc:PaidAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_vta_gravada, '#####0.00')) + '</cbc:PaidAmount>' + char(13) + char(10) &
				+ '    <cbc:InstructionID>01</cbc:InstructionID>' + char(13) + char(10) &
				+ '  </sac:BillingPayment>' + char(13) + char(10) &
				+ '  <sac:BillingPayment> ' + char(13) + char(10) &
				+ '    <cbc:PaidAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_vta_exonerada, '#####0.00')) + '</cbc:PaidAmount>' + char(13) + char(10) &
				+ '    <cbc:InstructionID>02</cbc:InstructionID>' + char(13) + char(10) &
				+ '  </sac:BillingPayment>' + char(13) + char(10) &
				+ '  <sac:BillingPayment> ' + char(13) + char(10) &
				+ '    <cbc:PaidAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_vta_inafecta, '#####0.00')) + '</cbc:PaidAmount>' + char(13) + char(10) &
				+ '    <cbc:InstructionID>03</cbc:InstructionID>' + char(13) + char(10) &
				+ '  </sac:BillingPayment>' + char(13) + char(10) &
				+ '  <cac:AllowanceCharge>' + char(13) + char(10) &
				+ '     <cbc:ChargeIndicator>true</cbc:ChargeIndicator>' + char(13) + char(10) &
				+ '     <cbc:Amount currencyID="' + ls_moneda + '">0.00</cbc:Amount>' + char(13) + char(10) &
				+ '  </cac:AllowanceCharge>' + char(13) + char(10)&
				+ '  <cac:TaxTotal>' + char(13) + char(10) &
				+ '     <cbc:TaxAmount currencyID="' + ls_moneda + '">0.00</cbc:TaxAmount>' + char(13) + char(10) &
				+ '     <cac:TaxSubtotal>' + char(13) + char(10) &
				+ '        <cbc:TaxAmount currencyID="' + ls_moneda + '">0.00</cbc:TaxAmount>' + char(13) + char(10) &
				+ '        <cac:TaxCategory>' + char(13) + char(10) &
				+ '           <cac:TaxScheme>' + char(13) + char(10) &
				+ '              <cbc:ID>2000</cbc:ID>' + char(13) + char(10) &
				+ '              <cbc:Name>ISC</cbc:Name>' + char(13) + char(10) &
				+ '              <cbc:TaxTypeCode>EXC</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '           </cac:TaxScheme>' + char(13) + char(10) &
				+ '        </cac:TaxCategory>' + char(13) + char(10) &
				+ '     </cac:TaxSubtotal>' + char(13) + char(10) &
				+ '  </cac:TaxTotal>' + char(13) + char(10) &
				+ '  <cac:TaxTotal>' + char(13) + char(10) &
				+ '     <cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '     <cac:TaxSubtotal>' + char(13) + char(10) &
				+ '       <cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '          <cac:TaxCategory>' + char(13) + char(10) &
				+ '             <cac:TaxScheme>' + char(13) + char(10) &
				+ '                <cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '                <cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '                <cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '             </cac:TaxScheme>' + char(13) + char(10) &
				+ '          </cac:TaxCategory>' + char(13) + char(10) &
				+ '     </cac:TaxSubtotal>' + char(13) + char(10) &
				+ '  </cac:TaxTotal>' + char(13) + char(10) &
				+ ' </sac:SummaryDocumentsLine>'
			
	invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)
	
	//actualizo el nro_rc en la tabla
	if Not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
		update fs_factura_simpl
		  set NRO_RC_ID = :ls_nro_rc_id
		 where nro_registro = :ls_nro_registro;
		 
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if

	else
		update cntas_cobrar
		  set NRO_RC_ID = :ls_nro_rc_id
		 where tipo_doc = :ls_tipo_doc_cxc
		   and nro_doc	 = :ls_nro_doc_cxc;
		 
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al actualizar registro en cntas_cobrar. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if

	end if
	
	
next

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_RC( ls_nro_rc, ld_hoy)

update SUNAT_RC_DIARIO
	set path_file = :ls_PathFileXML
 where NRO_RC_ID = :ls_nro_rc_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_RC_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Cierro el documento
ls_texto = '</SummaryDocuments>'
invo_xml.of_write_rc_xml( ls_nro_rc, ls_texto, ld_hoy)

 
//Guardo los cambios
commit;

return true
end function

public function string of_string_nro_cuota (string as_nro_letra, date ad_fecha);String ls_return, ls_year, ls_mes

ls_year 	= string(ad_fecha, 'yyyy')
ls_mes	= string(ad_fecha, 'mm')

ls_return = 'CUOTA NRO: ' + trim(as_nro_letra) + ' (' + ls_year + '-' &

if ls_mes = '01' then
	ls_return += 'ENERO'
elseif ls_mes = '02' then
	ls_return += 'FEBRERO'
elseif ls_mes = '03' then
	ls_return += 'MARZO'
elseif ls_mes = '04' then
	ls_return += 'ABRIL'
elseif ls_mes = '05' then
	ls_return += 'MAYO'
elseif ls_mes = '06' then
	ls_return += 'JUNIO'
elseif ls_mes = '07' then
	ls_return += 'JULIO'
elseif ls_mes = '08' then
	ls_return += 'AGOSTO'
elseif ls_mes = '09' then
	ls_return += 'SETIEMBRE'
elseif ls_mes = '10' then
	ls_return += 'OCTUBRE'
elseif ls_mes = '11' then
	ls_return += 'NOVIEMBRE'
elseif ls_mes = '12' then
	ls_return += 'DICIEMBRE'
	
end if

ls_return += ')'
					



return ls_return
end function

public function string of_string_codigo_cliente (string as_ruc_dni, string as_mnz, string as_lote);String ls_return

ls_return = 'CODIGO DE CLIENTE ' + as_ruc_dni + trim(as_mnz) + trim(as_lote)					



return ls_return
end function

public function string of_select_dataobject (string as_nro_registro, string as_tipo_doc, string as_serie, string as_flag_mercado) throws exception;String 		ls_dw, ls_FLAG_TIPO_IMPRESION, ls_mensaje
Exception 	ex

//Obtengo el tipo de impresion de la tabla num_doc_tipo
select nvl(flag_tipo_impresion , '0')
  into :ls_flag_tipo_impresion
  from num_doc_tipo
where tipo_doc 	= :as_tipo_doc
  and NRO_SERIE	= :as_serie;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	
	ex = create Exception
	ex.setMessage('Error al consultar TIPO_IMPRESION en tabla NUM_DOC_TIPO. Mensaje de Error: ' + ls_mensaje)
	throw ex
	
	return gnvo_app.is_null
end if

IF trim(as_tipo_doc) = 'NVC' then
	//Si es una nota de venta entonces es otro tipo de documento
	if upper(gs_empresa) = 'FLORES' then
		ls_dw = 'd_rpt_nvc_pos_flores_tbl'
	else
					
		if FileExists(gs_logo) then
			ls_dw = 'd_rpt_nvc_pos_tbl'
		else
			ls_dw = 'd_rpt_nvc_pos_sinlogo_tbl'
		end if
	end if
else
	if ls_flag_tipo_impresion = '0' then
		//DEjo la impresion como ha estado
		if gnvo_app.ventas.is_impresion_termica = "0" then
			if as_flag_mercado = 'L' then
				if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
					trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) or &
					trim(as_tipo_doc) = 'NVC' then
					
					ls_dw = 'd_rpt_comp_elect_tbl'
				else
					ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
				end if
				
			else
				
				if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
					trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
					
					ls_dw = 'd_rpt_comp_elect_exp_tbl'
					
				else
					
					ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
					
				end if
				
			end if
		else
			if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
				if upper(gs_empresa) = 'FLORES' then
					
					ls_dw = 'd_rpt_ticket_pos_flores_tbl'
				
				elseif upper(gs_empresa) = 'MIA' or upper(gs_empresa) = 'MIA_NAILS' then
					
					ls_dw = 'd_rpt_ticket_pos_mia_tbl'
				
				elseif upper(gs_empresa) = 'COMERCIAL_MIGUEL' then
					
					ls_dw = 'd_rpt_ticket_pos_miguel_tbl'
					
				elseif upper(gs_empresa) = 'INTIMIDADES' or upper(gs_empresa) = 'GRUPO_INTIMIDADES' &
					or upper(gs_empresa) = 'ILUSIONES_&_SECRETOS' then
					
					ls_dw = 'd_rpt_ticket_pos_intimidades_tbl'
				
				elseif upper(gs_empresa) = 'NEGOCIOS_CARRILLO' or upper(gs_empresa) = 'YOLANDA_GRANDA' &
					or upper(gs_empresa) = 'CORPORACION_INTERNACIONAL' then
					
					ls_dw = 'd_rpt_ticket_pos_gda_tbl'
				
				elseif upper(gs_empresa) = 'NEGOCIOS_ANTON' OR upper(gs_empresa) = '24HORAS' then
					
					ls_dw = 'd_rpt_ticket_pos_anton_tbl'
				
				elseif upper(gs_empresa) = 'CARLOS_WILLIAM' then
					
					ls_dw = 'd_rpt_ticket_pos_carlos_william_tbl'
				
				elseif upper(gs_empresa) = 'FRANCIS' then
					
					ls_dw = 'd_rpt_ticket_pos_francis_tbl'
					
				else
					
					if FileExists(gs_logo) then
						ls_dw = 'd_rpt_ticket_pos_tbl'
					else
						ls_dw = 'd_rpt_ticket_pos_sinlogo_tbl'
					end if
					
				end if
			else
				if FileExists(gs_logo) then
					ls_dw = 'd_rpt_ticket_termica_tbl'
				else
					ls_dw = 'd_rpt_ticket_termica_sinlogo_tbl'
				end if
			end if
		end if
		
	elseif ls_flag_tipo_impresion = '1' then
		
		//Impresion en etiquetera
		if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
			if upper(gs_empresa) = 'FLORES' then
				
				ls_dw = 'd_rpt_ticket_pos_flores_tbl'
			
			elseif upper(gs_empresa) = 'MIA' or upper(gs_empresa) = 'MIA_NAILS' then
					
					ls_dw = 'd_rpt_ticket_pos_mia_tbl'
					
			elseif upper(gs_empresa) = 'COMERCIAL_MIGUEL' then
					
					ls_dw = 'd_rpt_ticket_pos_miguel_tbl'
				
			elseif upper(gs_empresa) = 'INTIMIDADES' or upper(gs_empresa) = 'GRUPO_INTIMIDADES' &
					or upper(gs_empresa) = 'ILUSIONES_&_SECRETOS' then
					
				ls_dw = 'd_rpt_ticket_pos_intimidades_tbl'
			
			elseif upper(gs_empresa) = 'NEGOCIOS_CARRILLO' or upper(gs_empresa) = 'YOLANDA_GRANDA' &
					or upper(gs_empresa) = 'CORPORACION_INTERNACIONAL' then
					
					ls_dw = 'd_rpt_ticket_pos_gda_tbl'
					
			elseif upper(gs_empresa) = 'NEGOCIOS_ANTON' OR upper(gs_empresa) = '24HORAS' then
				
				ls_dw = 'd_rpt_ticket_pos_anton_tbl'
			
			elseif upper(gs_empresa) = 'CARLOS_WILLIAM' then
					
					ls_dw = 'd_rpt_ticket_pos_carlos_william_tbl'
				
			else
				
				if FileExists(gs_logo) then
					ls_dw = 'd_rpt_ticket_pos_tbl'
				else
					ls_dw = 'd_rpt_ticket_pos_sinlogo_tbl'
				end if
				
			end if
		else
			if FileExists(gs_logo) then
				ls_dw = 'd_rpt_ticket_termica_tbl'
			else
				ls_dw = 'd_rpt_ticket_termica_sinlogo_tbl'
			end if
		end if
	
	elseif ls_flag_tipo_impresion = '2' then
		
		//Impresion en hoja Din A-4
		if as_flag_mercado = 'L' then
			if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
				trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) or &
				trim(as_tipo_doc) = 'NVC' then
				
				ls_dw = 'd_rpt_comp_elect_tbl'
			else
				ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
			end if
			
		else
			
			if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
				trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
				
				ls_dw = 'd_rpt_comp_elect_exp_tbl'
				
			else
				
				ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
				
			end if
			
		end if
		
		
	end if
end if

return ls_dw

end function

public function boolean of_print_ce (string as_tipo_doc, string as_nro_doc, str_parametros astr_param);Long 			ll_height, ll_rows_fp, ll_i
Date			ld_fecha
string		ls_origen, ls_direccion, ls_fono, ls_flag_detraccion, ls_Serie, ls_mensaje
decimal		ldc_igv, ldc_total
str_qrcode	lstr_qrcode
str_parametros lstr_param

try 
	//Obtengo la serie
	select PKG_FACT_ELECTRONICA.of_get_serie(:as_nro_doc)
		into :ls_Serie
	from dual;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MEssageBox('Error', 'Error al obtener la serie llamando a la funcion PKG_FACT_ELECTRONICA.of_get_serie().' &
								+ 'Mensaje: ' + ls_mensaje, STopSign!)
		return false
	end if
	
	if not astr_param.b_preview then

		//Selecciono el datawindow correspondiente
		ids_ticket.DataObject = this.of_select_DataObject('', as_tipo_doc, ls_serie, astr_param.flag_mercado)
		ids_ticket.SetTransObject(SQLCA)

		//Recupero datos del datawindow
		ids_ticket.Retrieve(as_tipo_doc, as_nro_doc, gs_empresa)
		
		if ids_ticket.RowCount( ) = 0 then
			MessageBox('Error', 'No existen registros para el comprobante ' + as_tipo_doc + '/' + as_nro_doc + ', por favor verifique!', StopSign!)
			return false
		end if
		
		ld_fecha = Date(ids_ticket.object.fecha_documento [1])
		
		//Coloco el logo
		if FileExists(gs_logo) then
			ids_ticket.object.p_logo.filename = gs_logo
		end if
		
		//Lleno los datos necesarios
		if as_tipo_doc <> 'NVC' then
			ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
			ids_ticket.object.url_t.text 					= this.is_url
			ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
			
			
			//Verifico si tiene o no detraccion
			ls_flag_detraccion = ids_ticket.object.flag_detraccion 			[1]
			
			if ls_flag_detraccion = '1' then
				ids_ticket.object.detraccion_t.visible = '1'
				ids_ticket.object.detraccion_t.text 	= "OPERACION SUJETA AL SISTEMA DE PAGO DE OBLIGACIONES " &
																	+ "TRIBUTARIAS CON EL GOBIERNO CENTRAL. BCO DE LA NACION NRO: " &
																	+ gnvo_app.finparam.is_cnta_cnte_detraccion &
																	+ " (OPERACIONES AFECTAS s/. 700.00 SOLES POR CLIENTE) " &
																	+ "RESOLUCIÓN No. 207-2004 SU"
			else
				ids_ticket.object.detraccion_t.visible = '0'
				ids_ticket.object.detraccion_t.text 	= ""
			end if
			
			//Genero el codigo QR
			lstr_qrcode.tipo_doc 		= ids_ticket.object.tipo_doc 			[1]
			lstr_qrcode.nro_doc 			= ids_ticket.object.nro_doc 			[1]
			lstr_qrcode.ruc_emisor 		= ids_ticket.object.ruc_emisor 		[1]
			lstr_qrcode.serie 			= ids_ticket.object.serie 				[1]
			lstr_qrcode.numero 			= ids_ticket.object.numero 			[1]
			lstr_qrcode.tipo_doc_sunat = ids_ticket.object.tipo_doc_sunat	[1]
			lstr_qrcode.tipo_doc_ident	= ids_ticket.object.tipo_doc_ident 	[1]
			lstr_qrcode.nro_doc_ident 	= ids_ticket.object.ruc_dni 			[1]
			
			//Acumulo el IGV y el total
			ldc_igv = 0
			ldc_total = 0
			for ll_i = 1 to ids_ticket.RowCount()
				ldc_igv 		+= Dec(ids_ticket.object.importe_igv 	[ll_i])
				ldc_total 	+= Dec(ids_ticket.object.sub_total 		[ll_i])
			next
			
			lstr_qrcode.imp_igv 		= ldc_igv
			lstr_qrcode.imp_total 	= ldc_igv + ldc_total
			lstr_qrcode.fec_emision	= Date(ids_ticket.object.fecha_documento 	[1])
	
			if not this.of_generar_qrcode( lstr_qrcode ) then return false
			
			//Genero el archivo PDF
			if not this.of_generar_pdf( lstr_qrcode ) then return false
		end if
		
		
		//Imprimo el ticket
		if as_tipo_doc = 'NVC' then
			if gnvo_app.of_get_parametro( "VTA_PRINT_NOTA_VENTA", "0") = "1" THEN
				ids_ticket.Print()
			end if
		else
			ids_ticket.Print()
		end if
		
		if as_tipo_doc <> 'NVC' then
			if gnvo_app.of_get_parametro( "DOBLE_COMPROBANTE", "0") = "1" then
				ids_ticket.Print()
			end if
		end if
	
	else
	
		if astr_param.flag_mercado = 'L' then
			if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
				lstr_param.dw1 = 'd_rpt_comp_elect_tbl'
			else
				lstr_param.dw1 = 'd_rpt_comp_elect_ncc_ndc_tbl'
			end if
		else
			if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
				
				if gs_empresa = 'SEAFROST' then
					if astr_param.long1 = 2 then
						lstr_param.dw1 = 'd_rpt_comp_elect_exp_seafrost_tbl'
					elseif astr_param.long1 = 3 then
						lstr_param.dw1 = 'd_rpt_comp_elect_exp_seafrost02_tbl'
					else 
						lstr_param.dw1 = 'd_rpt_comp_elect_exp_tbl'
					end if
						
				else
					lstr_param.dw1 = 'd_rpt_comp_elect_exp_tbl'
				end if
				
			else
				lstr_param.dw1 = 'd_rpt_comp_elect_ncc_ndc_tbl'
			end if
		end if

		lstr_param.titulo = 'Comprobante Electronico - ' + as_tipo_doc + ' ' + as_nro_doc
		lstr_param.string1 	= as_tipo_doc
		lstr_param.string2 	= as_nro_doc
		lstr_param.string3 	= gs_empresa
		lstr_param.tipo		= 'EFACT_PREVIEW'
		
		OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
	
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false
end try

end function

public function string of_select_dataobject_email (string as_nro_registro, string as_tipo_doc, string as_serie, string as_flag_mercado) throws exception;String 		ls_dw, ls_flag_tipo_email, ls_mensaje
Exception 	ex

//SI no existe la serie entonces lanzo el mensaje de error
if IsNull(as_serie) or trim(as_serie) = '' then
	ex = create Exception
	ex.setMessage("El argumento as_serie de la funcion of_select_dataObject_email no puede nulo " &
					+ "o vacío. Mensaje de Error: " + ls_mensaje)
	throw ex
	
	return gnvo_app.is_null
end if

//Obtengo el tipo de impresion de la tabla num_doc_tipo
select nvl(flag_tipo_email , '0')
  into :ls_flag_tipo_email
  from num_doc_tipo
where tipo_doc 	= :as_tipo_doc
  and NRO_SERIE	= :as_serie;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	
	ex = create Exception
	ex.setMessage('Error al consultar TIPO_IMPRESION en tabla NUM_DOC_TIPO. Mensaje de Error: ' + ls_mensaje)
	throw ex
	
	return gnvo_app.is_null
end if

IF trim(as_tipo_doc) = 'NVC' then
	//Si es una nota de venta entonces es otro tipo de documento
	if FileExists(gs_logo) then
		ls_dw = 'd_rpt_nvc_pos_tbl'
	else
		ls_dw = 'd_rpt_nvc_pos_sinlogo_tbl'
	end if
else
	
	if ls_flag_tipo_email = '0' then
		//DEjo la impresion como ha estado
		if gnvo_app.ventas.is_impresion_termica = "0" then
			//Impresion en hoja Din A-4
			if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
				//Aca no importe el tipo de mercado, ya que se supone que viene de la factura
				//simplificada y será siempre para venta Local
				if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
					trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
					
					ls_dw = 'd_rpt_comp_elect_fs_tbl'
					
				else
					
					ls_dw = 'd_rpt_comp_elect_ncc_ndc_fs_tbl'
					
				end if
					
			else
			
				if as_flag_mercado = 'L' then
					if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
						trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
						
						ls_dw = 'd_rpt_comp_elect_tbl'
					else
						ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
					end if
					
				else
					
					if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
						trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
						
						ls_dw = 'd_rpt_comp_elect_exp_tbl'
						
					else
						
						ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
						
					end if
					
				end if
			end if
		else
			if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
				if upper(gs_empresa) = 'FLORES' then
				
					ls_dw = 'd_rpt_ticket_pos_flores_tbl'
				
				elseif upper(gs_empresa) = 'COMERCIAL_MIGUEL' then
					
					ls_dw = 'd_rpt_ticket_pos_miguel_tbl'
					
				elseif upper(gs_empresa) = 'INTIMIDADES' or upper(gs_empresa) = 'GRUPO_INTIMIDADES' &
					or upper(gs_empresa) = 'ILUSIONES_&_SECRETOS' then
						
					ls_dw = 'd_rpt_ticket_pos_intimidades_tbl'
				
				elseif upper(gs_empresa) = 'NEGOCIOS_CARRILLO' or upper(gs_empresa) = 'YOLANDA_GRANDA' &
					or upper(gs_empresa) = 'CORPORACION_INTERNACIONAL' then
					
					ls_dw = 'd_rpt_ticket_pos_gda_tbl'
				
				elseif upper(gs_empresa) = 'NEGOCIOS_ANTON' OR upper(gs_empresa) = '24HORAS' then
					
					ls_dw = 'd_rpt_ticket_pos_anton_tbl'
				
				elseif upper(gs_empresa) = 'CARLOS_WILLIAM' then
					
					ls_dw = 'd_rpt_ticket_pos_carlos_william_tbl'
					
				else
					if FileExists(gs_logo) then
						ls_dw = 'd_rpt_ticket_pos_tbl'
					else
						ls_dw = 'd_rpt_ticket_pos_sinlogo_tbl'
					end if
				end if
			end if
		end if
		
	elseif ls_flag_tipo_email = '1' then
		
		//Impresion en etiquetera
		if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
			if upper(gs_empresa) = 'FLORES' then
				
				ls_dw = 'd_rpt_ticket_pos_flores_tbl'
			
			elseif upper(gs_empresa) = 'COMERCIAL_MIGUEL' then
					
					ls_dw = 'd_rpt_ticket_pos_miguel_tbl'
				
			elseif upper(gs_empresa) = 'INTIMIDADES' or upper(gs_empresa) = 'GRUPO_INTIMIDADES' &
					or upper(gs_empresa) = 'ILUSIONES_&_SECRETOS' then
					
				ls_dw = 'd_rpt_ticket_pos_intimidades_tbl'
				
			elseif upper(gs_empresa) = 'NEGOCIOS_CARRILLO' or upper(gs_empresa) = 'YOLANDA_GRANDA' &
					or upper(gs_empresa) = 'CORPORACION_INTERNACIONAL' then
					
					ls_dw = 'd_rpt_ticket_pos_gda_tbl'
			
			elseif upper(gs_empresa) = 'NEGOCIOS_ANTON' OR upper(gs_empresa) = '24HORAS' then
				
				ls_dw = 'd_rpt_ticket_pos_anton_tbl'
				
			elseif upper(gs_empresa) = 'CARLOS_WILLIAM' then
					
					ls_dw = 'd_rpt_ticket_pos_carlos_william_tbl'
				
			else
				if FileExists(gs_logo) then
					ls_dw = 'd_rpt_ticket_pos_tbl'
				else
					ls_dw = 'd_rpt_ticket_pos_sinlogo_tbl'
				end if
			end if
			
		else
			
			if FileExists(gs_logo) then
				ls_dw = 'd_rpt_ticket_termica_tbl'
			else
				ls_dw = 'd_rpt_ticket_termica_sinlogo_tbl'
			end if
		end if
	
	elseif ls_flag_tipo_email = '2' then
		
		//Impresion en hoja Din A-4
		if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
			//Aca no importe el tipo de mercado, ya que se supone que viene de la factura
			//simplificada y será siempre para venta Local
			if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
				trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
				
				ls_dw = 'd_rpt_comp_elect_fs_tbl'
				
			else
				
				ls_dw = 'd_rpt_comp_elect_ncc_ndc_fs_tbl'
				
			end if
				
		else
		
			if as_flag_mercado = 'L' then
				if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
					trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
					
					ls_dw = 'd_rpt_comp_elect_tbl'
				else
					ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
				end if
				
			else
				
				if trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_fac) or &
					trim(as_tipo_doc) = trim(gnvo_app.finparam.is_doc_bvc) then
					
					ls_dw = 'd_rpt_comp_elect_exp_tbl'
					
				else
					
					ls_dw = 'd_rpt_comp_elect_ncc_ndc_tbl'
					
				end if
				
			end if
		end if
		
		
	end if
end if

return ls_dw

end function

public function boolean of_create_only_pdf (string as_nro_registro);Long 		ll_height, ll_rows_fp
Date		ld_fecha
String	ls_origen, ls_direccion, ls_fono, ls_tipo_doc_cxc, ls_nro_doc_cxc, ls_serie, &
			ls_flag_tipo_email
Long		ll_i

try 
	//Obtengo la serie
	select serie_cxc, tipo_doc_cxc, 
			 decode(nro_doc_cxc, null, serie_cxc || '-' || nro_cxc, nro_doc_cxc)
		into :ls_Serie, :ls_tipo_doc_cxc, :ls_nro_doc_cxc
	from fs_factura_simpl
	where nro_registro = :as_nro_registro;
	
	//Obtengo los flag adecuados
	select nvl(FLAG_TIPO_EMAIL, '0')
		into :ls_flag_tipo_email
	from num_doc_tipo
	where nro_serie = :ls_serie
	  and tipo_doc	 = :ls_tipo_doc_cxc;
	  
	//Imprimo el comprobante
	ids_ticket.DataObject = this.of_select_DataObject_email(as_nro_registro, ls_tipo_doc_cxc, ls_Serie, 'L')
	ids_ticket.SetTransObject(SQLCA)
	
	ids_ticket.Retrieve(as_nro_registro, gs_empresa)
		
	if ids_ticket.RowCount( ) = 0 then
		MessageBox('Error', 'No existen registros para el ticket ' + as_nro_registro &
								+ '~r~nof_create_only_pdf() ' &
								+ '~r~nDataObject:' + ids_ticket.DataObject &
								+ '~r~nPor favor verifique!', StopSign!)
		return false
	end if
	
	if upper(gs_empresa) = 'SERVIMOTOR' then
		ls_origen = ids_ticket.object.cod_origen [1]
		
		ls_direccion 	= gnvo_app.empresa.of_direccion(ls_origen)
		ls_fono			= gnvo_app.empresa.of_telefono(ls_origen)	
		
		for ll_i = 1 to ids_ticket.RowCount()
			ids_ticket.object.direccion [ll_i] = ls_direccion
			ids_ticket.object.fono_fijo [ll_i] = ls_fono
		next
	end if
	
	//Pongo el nombre al documento
	ids_ticket.object.DataWindow.Print.DocumentName	= trim(ls_tipo_doc_cxc) + '-' + ls_nro_doc_cxc
	
	if ids_ticket.of_existeCampo('fec_registro') then
	
		ld_fecha = Date( ids_ticket.object.fec_registro [1] )
		
	elseif ids_ticket.of_existeCampo('fecha_documento') then
		
		ld_fecha = Date( ids_ticket.object.fecha_documento [1] )
		
	else
		MessageBox('Error', 'No existe el campo fec_registro o fecha_documento en datawindow. Nro ticket ' + as_nro_registro + ', por favor verifique!', StopSign!)
		return false
	end if
	
	
	//Cuantas formas de pago tiene
	if ls_flag_tipo_email <> '2' then
		select count(*)
			into :ll_rows_fp
		from fs_factura_simpl_pagos
		where nro_registro = :as_nro_registro;
		
		//ASigno el tamaño requerido
		ll_height = il_height_efact + il_height_row_efact * ids_ticket.RowCount( ) + il_height_row_fp * ll_rows_fp
		ids_ticket.Object.DataWindow.Print.Paper.Size = 256 
		ids_ticket.Object.DataWindow.Print.CustomPage.Width = il_width_efact
		ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height
	end if
	
	//Coloco el logo
	if FileExists(gs_logo) then
		ids_ticket.object.p_logo.filename = gs_logo
	end if
	
	//Lleno los datos necesarios
	if trim(ls_tipo_doc_cxc) <> 'NVC' then
		if ids_ticket.of_existsText( "nro_resolucion_t") then
			ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
		end if
		
		if ids_ticket.of_existsText("url_t") then
			ids_ticket.object.url_t.text 					= this.is_url	
		end if
		
		if ids_ticket.of_existsText("devolucion_t") then
			ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
		end if
		
		//Genero el codigo QR
		if not this.of_generar_qrcode( ld_fecha ) then return false
		
		//Genero el archivo PDF
		if not this.of_generar_pdf( ld_fecha ) then return false
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false
end try





end function

public function boolean of_create_only_pdf (string as_tipo_doc, string as_serie, string as_nro_doc, str_parametros astr_param);Long 			ll_height, ll_rows_fp, ll_i
Date			ld_fecha
string		ls_origen, ls_direccion, ls_fono, ls_flag_detraccion, ls_mensaje
Decimal		ldc_igv, ldc_total
str_qrcode	lstr_qrcode

try 
	//Imprimo el comprobante
	ids_ticket.DataObject = this.of_select_DataObject('', as_tipo_doc, as_serie, astr_param.flag_mercado)
	ids_ticket.SetTransObject(SQLCA)
	
	ids_ticket.Retrieve(as_tipo_doc, as_nro_doc, gs_empresa)
	
	if ids_ticket.RowCount( ) = 0 then
		MessageBox('Error', 'No existen registros para el comprobante ' + as_tipo_doc + '/' + as_nro_doc + ', por favor verifique!', StopSign!)
		return false
	end if
	
	if upper(gs_empresa) = 'SERVIMOTOR' then
		ls_origen = ids_ticket.object.cod_origen [1]
		
		ls_direccion 	= gnvo_app.empresa.of_direccion(ls_origen)
		ls_fono			= gnvo_app.empresa.of_telefono(ls_origen)	
		
		for ll_i = 1 to ids_ticket.RowCount()
			//Direccion
			if ids_ticket.of_ExistsCampo('direccion') then
				ids_ticket.object.direccion [ll_i] = ls_direccion
			end if
			
			//Fono Fijo
			if ids_ticket.of_ExistsCampo('fono_fijo') then
				ids_ticket.object.fono_fijo [ll_i] = ls_fono
			end if
			
		next
	end if
	
	if gnvo_app.ventas.is_impresion_termica = '0' then
		ld_fecha = Date(ids_ticket.object.fecha_documento 	[1])
	else
		ld_fecha = Date(ids_ticket.object.fec_registro 		[1])
	end if
	
	//ASigno el tamaño requerido
	if gnvo_app.ventas.is_impresion_termica = '1' then
		ll_height = il_height_efact + il_height_row_efact * ids_ticket.RowCount( ) 
		ids_ticket.Object.DataWindow.Print.Paper.Size = 256 
		ids_ticket.Object.DataWindow.Print.CustomPage.Width = il_width_efact
		ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height
	end if
	
	//Coloco el logo
	if FileExists(gs_logo) then
		ids_ticket.object.p_logo.filename = gs_logo
	end if
	
	//Lleno los datos necesarios
	if trim(as_tipo_doc) <> 'NVC' then
		ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
		ids_ticket.object.url_t.text 					= this.is_url
		ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
		
		if gnvo_app.ventas.is_impresion_termica = '0' then
			//Verifico si tiene o no detraccion
			ls_flag_detraccion = ids_ticket.object.flag_detraccion 			[1]
			
			if ls_flag_detraccion = '1' then
				ids_ticket.object.detraccion_t.visible = '1'
				ids_ticket.object.detraccion_t.text 	= "OPERACION SUJETA AL SISTEMA DE PAGO DE OBLIGACIONES " &
																	+ "TRIBUTARIAS CON EL GOBIERNO CENTRAL. BCO DE LA NACION NRO: " &
																	+ gnvo_app.finparam.is_cnta_cnte_detraccion &
																	+ " (OPERACIONES AFECTAS s/. 700.00 SOLES POR CLIENTE) " &
																	+ "RESOLUCIÓN No. 207-2004 SU"
			else
				ids_ticket.object.detraccion_t.visible = '0'
				ids_ticket.object.detraccion_t.text 	= ""
			end if
		end if
	
		//Genero el codigo QR
		if ids_ticket.of_ExistePicture("p_codeqr") then
			
			lstr_qrcode.tipo_doc 		= ids_ticket.object.tipo_doc 			[1]
			
			if ids_ticket.of_ExisteCampo("nro_doc") then
				lstr_qrcode.nro_doc 			= ids_ticket.object.nro_doc 			[1]
			elseif ids_ticket.of_ExisteCampo("nro_doc_cxc") then
				lstr_qrcode.nro_doc 			= ids_ticket.object.nro_doc_cxc		[1]
			else
				MessageBox('Error', 'No hay campo que represente el nro del comprobante en el datawindow ' + ids_ticket.dataObject + ', por favor verifique', StopSign!)
				return false
			end if
			
			if ids_ticket.of_ExisteCampo("ruc_emisor") then
				lstr_qrcode.ruc_emisor 		= ids_ticket.object.ruc_emisor 		[1]
			elseif ids_ticket.of_ExisteCampo("ruc") then
				lstr_qrcode.ruc_emisor 		= ids_ticket.object.ruc 		[1]
			else
				MessageBox('Error', 'No hay campo que represente el ruc del emisor en el datawindow ' + ids_ticket.dataObject + ', por favor verifique', StopSign!)
				return false
			end if
			
			if ids_ticket.of_ExisteCampo("serie") then
				lstr_qrcode.serie 			= ids_ticket.object.serie 				[1]
			elseif ids_ticket.of_ExisteCampo("serie_cxc") then
				lstr_qrcode.serie 			= ids_ticket.object.serie_cxc 				[1]
			else
				MessageBox('Error', 'No hay campo que represente la Serie del comprobante en el datawindow ' + ids_ticket.dataObject + ', por favor verifique', StopSign!)
				return false
			end if
	
			if ids_ticket.of_ExisteCampo("numero") then
				lstr_qrcode.numero 			= ids_ticket.object.numero 			[1]
			elseif ids_ticket.of_ExisteCampo("nro_cxc") then
				lstr_qrcode.numero 			= ids_ticket.object.nro_cxc 			[1]
			else
				MessageBox('Error', 'No hay campo que represente el numero del comprobante en el datawindow ' + ids_ticket.dataObject + ', por favor verifique', StopSign!)
				return false
			end if
			
			lstr_qrcode.tipo_doc_sunat = ids_ticket.object.tipo_doc_sunat	[1]
			lstr_qrcode.tipo_doc_ident	= ids_ticket.object.tipo_doc_ident 	[1]
			lstr_qrcode.nro_doc_ident 	= ids_ticket.object.ruc_dni 			[1]
			
			//Acumulo el IGV y el total
			ldc_igv = 0
			ldc_total = 0
			for ll_i = 1 to ids_ticket.RowCount()
				ldc_igv 		+= Dec(ids_ticket.object.importe_igv 	[ll_i])
				ldc_total 	+= Dec(ids_ticket.object.sub_total 		[ll_i])
			next
			
			lstr_qrcode.imp_igv 		= ldc_igv
			lstr_qrcode.imp_total 	= ldc_igv + ldc_total
			
			if ids_ticket.of_ExisteCampo("fecha_documento") then
				lstr_qrcode.fec_emision	= Date(ids_ticket.object.fecha_documento 	[1])
			elseif ids_ticket.of_ExisteCampo("fec_registro") then
				lstr_qrcode.fec_emision	= Date(ids_ticket.object.fec_registro 	[1])
			else
				MessageBox('Error', 'No hay campo que represente la fecha de emisión del comprobante en el datawindow ' + ids_ticket.dataObject + ', por favor verifique', StopSign!)
				return false
			end if		
			
		
			//Genero el codigo QR
			if not this.of_generar_qrcode( lstr_qrcode ) then return false
			
			//Genero el archivo PDF
			if not this.of_generar_pdf( lstr_qrcode ) then return false

		else
			
			//Genero el archivo PDF
			if not this.of_generar_pdf( ld_fecha ) then return false
	
		end if
	end if
	
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false
end try





end function

public function boolean of_resumen_ra_bvc (date adi_fecha);String 	ls_texto, ls_NRO_RC, ls_NRO_RC_id, ls_mensaje, ls_tipo_doc, ls_nro_doc,&
			ls_serie, ls_nro, ls_nro_registro, ls_motivo_baja, ls_tipo_doc_cxc, &
			ls_full_nro_doc, ls_tipo_doc_ident, ls_nro_doc_ident, ls_moneda, &
			ls_nro_ra_id
String	ls_PathFileXML			
Long		ll_row, ll_nro_envio, ll_ult_nro, ll_nro_item
Date		ld_hoy
Decimal	ldc_vta_gravada, ldc_vta_inafecta, ldc_vta_exonerada, ldc_igv, ldc_total_doc

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_lista_comp_elect_ra_bvc_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(adi_fecha)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Aviso', 'No hay comprobantes electrónicos pendientes para Resumen de Baja. Fecha ' &
		+ string(adi_fecha, 'dd/mm/yyyy'), Information!)
	return false
end if

ld_hoy = Date(gnvo_app.of_fecha_actual( ))
/*
SQL> desc SUNAT_RC_DIARIO
Name            Type          Nullable Default Comments                             
--------------- ------------- -------- ------- ------------------------------------ 
NRO_RC_ID       CHAR(10)                                                            
NRO_RC          VARCHAR2(20)  Y                                                     
FEC_REGISTRO    DATE          Y                                                     
FEC_EMISION     DATE          Y                fecha de emision de los comprobantes 
NRO_ENVIO       NUMBER(4)     Y                                                     
COD_USR         CHAR(6)       Y                                                     
NRO_TICKET      VARCHAR2(20)  Y                                                     
PATH_FILE       VARCHAR2(200) Y                                                     
FEC_ENVIO_SUNAT DATE          Y                                                     
DATA_CDR        BLOB          Y                                                     
DATA_XML        BLOB          Y    
*/


//Obtengo el siguiente numero en la tabla de resumen diario
select nvl(max(nro_envio), 0)
	into :ll_nro_envio
from SUNAT_RC_DIARIO
where trunc(FEC_REGISTRO) = trunc(:ld_hoy);

//Incremento el numero de envio
ll_nro_envio ++

//Genero el NRO_RC
ls_NRO_RC = "RC-" + string(ld_hoy, 'yyyymmdd') + "-" + trim(string(ll_nro_envio))

//Inserto en la tabla de SUNAT_RC_DIARIO
ls_NRO_RC_id = invo_util.of_set_numera( "SUNAT_RC_DIARIO" )

if IsNull(ls_NRO_RC_id) or trim(ls_NRO_RC_id) = '' then return false

Insert into SUNAT_RC_DIARIO( 
	NRO_RC_id, NRO_RC, fec_registro, fec_emision, nro_envio, cod_usr)
values(
	:ls_NRO_RC_id, :ls_NRO_RC, sysdate, :adi_fecha, :ll_nro_envio, :gs_user);

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al insertar registro en SUNAT_RC_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Inserto en la tabla de SUNAT_RA_DIARIO
ls_nro_ra_id = invo_util.of_set_numera( "SUNAT_RA_DIARIO" )

if IsNull(ls_nro_ra_id) or trim(ls_nro_ra_id) = '' then return false

Insert into SUNAT_RA_DIARIO( 
	NRO_RA_id, NRO_RA, fec_registro, fec_emision, nro_envio, cod_usr, fec_envio_sunat)
values(
	:ls_nro_ra_id, :ls_NRO_RC, sysdate, :adi_fecha, :ll_nro_envio, :gs_user, sysdate);

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al insertar registro en SUNAT_RA_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="UTF-8"?>'
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Linea 2 = Datos
ls_texto = '<SummaryDocuments xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) & 
			+ '						xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '						xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '						xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '						xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '						xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '						xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '						xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '						xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' + char(13) + char(10) &
			+ '						xmlns="urn:sunat:names:specification:ubl:peru:schema:xsd:SummaryDocuments-1">'
			
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Linea 3: Firma Digital
ls_texto = '   <ext:UBLExtensions>' + char(13) + char(10) &
			+ '      <ext:UBLExtension>' + char(13) + char(10)&
			+ '         <ext:ExtensionContent>' + char(13) + char(10) &
			+ '         </ext:ExtensionContent>' + char(13) + char(10) &
			+ '      </ext:UBLExtension>' + char(13) + char(10) &
			+ '   </ext:UBLExtensions>' 
			
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '   <cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Line 5: Versión de la estructura del documento
ls_texto = '   <cbc:CustomizationID>1.1</cbc:CustomizationID>'
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Line 6: Identificador del resumen
ls_texto = '   <cbc:ID>' + ls_NRO_RC + '</cbc:ID>'
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
   
//Line 7: Fecha de generacion del resumen
ls_texto = '   <cbc:ReferenceDate>' + string(adi_Fecha, 'yyyy-mm-dd') + '</cbc:ReferenceDate>' 
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
   
//Line 8: Fecha de emision de los documentos
ls_texto = '   <cbc:IssueDate>' + string(ld_hoy, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
 
ls_texto = '   <cbc:Note><![CDATA[CONSOLIDADO DE BOLETAS DE VENTA]]></cbc:Note>' 
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Line 9: Signature del archivo
ls_texto = '<cac:Signature>' + char(13) + char(10) &
			+ '   <cbc:ID>#sign' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '   <cac:SignatoryParty>' + char(13) + char(10) &
			+ '      <cac:PartyIdentification>' + char(13) + char(10) &
			+ '         <cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '      </cac:PartyIdentification>' + char(13) + char(10) &
			+ '      <cac:PartyName>' + char(13) + char(10) &
			+ '         <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '      </cac:PartyName>' + char(13) + char(10) &
			+ '   </cac:SignatoryParty> '+ char(13) + char(10) &
			+ '   <cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '      <cac:ExternalReference>' + char(13) + char(10)&
			+ '         <cbc:URI>#sign' + gnvo_app.empresa.is_ruc + '</cbc:URI>' + char(13) + char(10) &
			+ '      </cac:ExternalReference>' + char(13) + char(10) &
			+ '   </cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '</cac:Signature>'
			
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
    
//Line 10: Datos del Emisor
ls_texto = '<cac:AccountingSupplierParty>' + char(13) + char(10) &
    		+ '   <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '   <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '   <cac:Party>' + char(13) + char(10) &
			+ '      <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '         <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '      </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   </cac:Party>' + char(13) + char(10) &
			+ '</cac:AccountingSupplierParty>'
			
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//REcorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_tipo_doc 			= ids_boletas.object.tipo_doc 			[ll_row]
	ls_serie 				= ids_boletas.object.serie 				[ll_row]
	ls_nro					= ids_boletas.object.nro 					[ll_row]
	ls_nro_registro		= ids_boletas.object.nro_registro		[ll_row]
	ls_motivo_baja			= ids_boletas.object.motivo_baja			[ll_row]
	ls_tipo_doc_cxc		= ids_boletas.object.tipo_doc_cxc		[ll_row]
	ls_nro_doc				= ids_boletas.object.nro_doc_cxc			[ll_row]
	ls_full_nro_doc		= ids_boletas.object.full_nro_doc		[ll_row]
	ls_tipo_doc_ident		= ids_boletas.object.tipo_doc_ident		[ll_row]
	ls_nro_doc_ident		= ids_boletas.object.nro_doc_ident		[ll_row]
	ls_moneda				= ids_boletas.object.cod_moneda			[ll_row]
	
	ldc_vta_gravada		= Dec(ids_boletas.object.vta_gravada		[ll_row])
	ldc_vta_inafecta		= Dec(ids_boletas.object.vta_inafecta		[ll_row])
	ldc_vta_exonerada		= Dec(ids_boletas.object.vta_exonerada		[ll_row])
	ldc_igv					= Dec(ids_boletas.object.total_igv			[ll_row])
	
	ldc_total_doc 		= ldc_vta_gravada + ldc_vta_inafecta + ldc_vta_exonerada + ldc_igv
	
	if IsNull(ls_motivo_baja) or trim(ls_motivo_baja) = '' then
		ls_motivo_baja = "ANULACIÓN DEL COMPROBANTE ELECTRONICO NRO " + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0') 
	end if
	
	if ls_moneda = gnvo_app.is_soles then
		ls_moneda = 'PEN'
	else
		ls_moneda = 'USD'
	end if
	
	//Coloco los datos en el documento
	//Line 01: Aperturo de Linea
	ls_texto = '	<sac:SummaryDocumentsLine>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	
	//Line 02: Nro Item
	ls_texto = '		<cbc:LineID>' + string(ll_nro_item) + '</cbc:LineID>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	
	//Line 03: Tipo Documento
	ls_texto = '		<cbc:DocumentTypeCode>' + ls_tipo_doc + '</cbc:DocumentTypeCode>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	
	//Line 04: Serie y nro de documento
	ls_texto = '		<cbc:ID>' + ls_full_nro_doc + '</cbc:ID>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	
	//Line 05: Identificacion del adquiriente
	ls_texto = '		<cac:AccountingCustomerParty>' + char(13) + char(10) &
				+ '			<!-- Numero de documento de identidad -->' + char(13) + char(10) &
				+ '			<cbc:CustomerAssignedAccountID>' + ls_nro_doc_ident + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
				+ '			<!-- Tipo de documento de identidad - Catalogo No. 06 -->' + char(13) + char(10) &
				+ '			<cbc:AdditionalAccountID>' + ls_tipo_doc_ident + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
				+ '		</cac:AccountingCustomerParty>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

	//Line 06: Estado del documento, en este caso anulado
	ls_texto = '		<cac:Status>' + char(13) + char(10) &
				+ '			<!-- (Codigo de operacion del item - catalogo No. 19) -->' + char(13) + char(10) &
				+ '			<cbc:ConditionCode>3</cbc:ConditionCode>' + char(13) + char(10) &
				+ '		</cac:Status>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)	
	
	//Line 05: Importe total de la venta
	ls_texto = '		<sac:TotalAmount currencyID="' + ls_moneda + '">' + string(ldc_total_doc, '########0.00') + '</sac:TotalAmount>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	
	//Line 05: Total de Venta - operaciones gravadas
	if ldc_vta_gravada > 0 then
		ls_texto = '		<sac:BillingPayment>' + char(13) + char(10) &
					+ '			<cbc:PaidAmount currencyID="' + ls_moneda + '">' + string(ldc_vta_gravada, '########0.00') + '</cbc:PaidAmount>' + char(13) + char(10) &
					+ '			<cbc:InstructionID>01</cbc:InstructionID>' + char(13) + char(10) &
					+ '		</sac:BillingPayment>'
		invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)	
	end if
	
	//Line 06: Total de Venta - operaciones exoneradas
	if ldc_vta_exonerada > 0 then 
		ls_texto = '		<sac:BillingPayment>' + char(13) + char(10) &
					+ '			<cbc:PaidAmount currencyID="' + ls_moneda + '">' + string(ldc_vta_exonerada, '########0.00') + '</cbc:PaidAmount>' + char(13) + char(10) &
					+ '			<cbc:InstructionID>02</cbc:InstructionID>' + char(13) + char(10) &
					+ '		</sac:BillingPayment>'
		invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	end if
	
	//Line 07: Total de Venta - operaciones inafectas
	if ldc_vta_inafecta > 0 then 
		ls_texto = '		<sac:BillingPayment>' + char(13) + char(10) &
					+ '			<cbc:PaidAmount currencyID="' + ls_moneda + '">' + string(ldc_vta_inafecta, '########0.00') + '</cbc:PaidAmount>' + char(13) + char(10) &
					+ '			<cbc:InstructionID>03</cbc:InstructionID>' + char(13) + char(10) &
					+ '		</sac:BillingPayment>'
		invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)
	end if
	
	//Line 08: Total de IGV
	ls_texto = '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<!-- Monto Total y Moneda -->' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + string(ldc_igv, '########0.00') + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<!-- Monto Total y Moneda -->' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + string(ldc_igv, '########0.00') + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<!-- Codigo de tributo - Catalogo No. 05 -->' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<!-- Nombre de tributo - Catalogo No. 05 -->' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<!-- Codigo internacional tributo - Catalogo No. 05 -->' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' 
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)	
	
	//Line 99: Cierre de Limea
	ls_texto = '	</sac:SummaryDocumentsLine>'
	invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

	
	//actualizo el NRO_RC en la tabla
	if not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
		update fs_factura_simpl
		  set NRO_RA_ID 	= :ls_NRO_RA_id,
		  		NRO_RC_ID	= :ls_NRO_RC_id
		 where nro_registro = :ls_nro_registro;

		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		 
	elseif not IsNull(ls_tipo_doc_cxc) and trim(ls_tipo_doc_cxc) <> '' and &
			 not IsNull(ls_nro_doc) and trim(ls_nro_doc) <> '' then
		
		update cntas_cobrar cc
		  set cc.NRO_RA_ID 	= :ls_NRO_RA_id,
		  		cc.NRO_RC_ID	= :ls_NRO_RC_id
		 where tipo_doc 	= :ls_tipo_doc_cxc
		   and nro_doc		= :ls_nro_doc;

		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		
	else
		
		MessageBox('Error ', 'No se ha espcificado un nro de registro o un nro de documento para actualizar. Por favor verifique!', StopSign!)
	end if
	
	ll_nro_item ++
next

//Cierro el documento
ls_texto = '</SummaryDocuments>'
invo_xml.of_write_rc_xml( ls_NRO_RC, ls_texto, ld_hoy)

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_RC( ls_NRO_RC, ld_hoy)

update SUNAT_RC_DIARIO
	set path_file = :ls_PathFileXML
where NRO_RC_ID = :ls_NRO_RC_id;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_RC_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


update SUNAT_RA_DIARIO
	set path_file = :ls_PathFileXML
where NRO_RA_ID = :ls_NRO_RA_id;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_RA_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if





//Guardo los cambios
commit;

return true
end function

public function boolean of_resumen_ra_fac (date adi_fecha);String 	ls_texto, ls_nro_ra, ls_nro_ra_id, ls_mensaje, ls_tipo_doc, ls_nro_doc,&
			ls_serie, ls_nro, ls_nro_registro, ls_motivo_baja, ls_tipo_doc_cxc, &
			ls_nro_doc_cxc
String	ls_PathFileXML			
Long		ll_row, ll_nro_envio, ll_ult_nro, ll_nro_item
Date		ld_hoy

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_lista_comp_elect_ra_fac_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(adi_fecha)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Aviso', 'No hay comprobantes electrónicos pendientes para Resumen de Baja. Fecha ' &
		+ string(adi_fecha, 'dd/mm/yyyy'), Information!)
	return false
end if

ld_hoy = Date(gnvo_app.of_fecha_actual( ))
/*
SQL> desc SUNAT_RA_DIARIO;
Name            Type          Nullable Default Comments 
--------------- ------------- -------- ------- -------- 
NRO_RA_ID       CHAR(10)                                
NRO_RA          VARCHAR2(20)  Y                         
FEC_REGISTRO    DATE          Y                         
FEC_EMISION     DATE          Y                         
NRO_ENVIO       NUMBER(4)     Y                         
COD_USR         CHAR(6)       Y                         
NRO_TICKET      VARCHAR2(20)  Y                         
PATH_FILE       VARCHAR2(200) Y                         
FEC_ENVIO_SUNAT DATE          Y                         
DATA_XML        BLOB          Y                         
DATA_CDR        BLOB          Y 
*/


//Obtengo el siguiente numero en la tabla de resumen diario
select nvl(max(nro_envio), 0)
	into :ll_nro_envio
from sunat_ra_diario
where trunc(FEC_REGISTRO) = trunc(:ld_hoy);

//Incremento el numero de envio
ll_nro_envio ++

//Genero el nro_rc
ls_nro_ra = "RA-" + string(ld_hoy, 'yyyymmdd') + "-" + trim(string(ll_nro_envio))

//Inserto en la tabla de SUNAT_RC_DIARIO
ls_nro_ra_id = invo_util.of_set_numera( "SUNAT_RA_DIARIO" )

if IsNull(ls_nro_ra_id) or trim(ls_nro_ra_id) = '' then return false

Insert into SUNAT_RA_DIARIO( 
	nro_ra_id, nro_ra, fec_registro, fec_emision, nro_envio, cod_usr)
values(
	:ls_nro_ra_id, :ls_nro_ra, sysdate, :adi_fecha, :ll_nro_envio, :gs_user);

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al insertar registro en SUNAT_RA_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)

//Linea 2 = Datos
ls_texto = '<VoidedDocuments xmlns="urn:sunat:names:specification:ubl:peru:schema:xsd:VoidedDocuments-1"' + char(13) + char(10) &
			+ '				 	  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10)&
			+ '				 	  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '				 	  xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '				 	  xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10)&
			+ '				 	  xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '				 	  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)

//Linea 3: Firma Digital
ls_texto = '   <ext:UBLExtensions>' + char(13) + char(10) &
			+ '      <ext:UBLExtension>' + char(13) + char(10)&
			+ '         <ext:ExtensionContent>' + char(13) + char(10) &
			+ '         </ext:ExtensionContent>' + char(13) + char(10) &
			+ '      </ext:UBLExtension>' + char(13) + char(10) &
			+ '   </ext:UBLExtensions>' 
			
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '   <cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)

//Line 5: Versión de la estructura del documento
ls_texto = '   <cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)

//Line 6: Identificador del resumen
ls_texto = '   <cbc:ID>' + ls_nro_ra + '</cbc:ID>'
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)
   
//Line 7: Fecha de emisión de los documentos
ls_texto = '   <cbc:ReferenceDate>' + string(adi_fecha, 'yyyy-mm-dd') + '</cbc:ReferenceDate>' 
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)
   
//Line 8: Fecha de generación del resumen
ls_texto = '   <cbc:IssueDate>' + string(ld_hoy, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)
    
//Line 9: Signature del archivo
ls_texto = '<cac:Signature>' + char(13) + char(10) &
			+ '   <cbc:ID>sign' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '   <cac:SignatoryParty>' + char(13) + char(10) &
			+ '      <cac:PartyIdentification>' + char(13) + char(10) &
			+ '         <cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '      </cac:PartyIdentification>' + char(13) + char(10) &
			+ '      <cac:PartyName>' + char(13) + char(10) &
			+ '         <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '      </cac:PartyName>' + char(13) + char(10) &
			+ '   </cac:SignatoryParty> '+ char(13) + char(10) &
			+ '   <cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '      <cac:ExternalReference>' + char(13) + char(10)&
			+ '         <cbc:URI>#sign' + gnvo_app.empresa.is_ruc + '</cbc:URI>' + char(13) + char(10) &
			+ '      </cac:ExternalReference>' + char(13) + char(10) &
			+ '   </cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '</cac:Signature>'
			
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)
    
//Line 10: Datos del Emisor
ls_texto = '<cac:AccountingSupplierParty>' + char(13) + char(10) &
    		+ '   <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '   <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '   <cac:Party>' + char(13) + char(10) &
			+ '      <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '         <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '      </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   </cac:Party>' + char(13) + char(10) &
			+ '</cac:AccountingSupplierParty>'
			
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)

//REcorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_tipo_doc 		= ids_boletas.object.tipo_doc 			[ll_row]
	ls_serie 			= ids_boletas.object.serie 				[ll_row]
	ls_nro				= ids_boletas.object.nro 					[ll_row]
	ls_nro_registro	= ids_boletas.object.nro_registro		[ll_row]
	ls_motivo_baja		= ids_boletas.object.motivo_baja			[ll_row]
	ls_tipo_doc_cxc	= ids_boletas.object.tipo_doc_cxc		[ll_row]
	ls_nro_doc_cxc		= ids_boletas.object.nro_doc_cxc			[ll_row]
	
	if IsNull(ls_motivo_baja) or trim(ls_motivo_baja) = '' then
		ls_motivo_baja = "ANULACIÓN DEL COMPROBANTE ELECTRONICO NRO " + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0') 
	end if
	
	
	ls_texto = '   <sac:VoidedDocumentsLine>' + char(13) + char(10)&
				+ '      <cbc:LineID>' + trim(string(ll_nro_item)) + '</cbc:LineID> ' + char(13) + char(10) &
				+ '      <cbc:DocumentTypeCode>' + ls_tipo_doc + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
				+ '  	   <sac:DocumentSerialID>' + ls_serie + '</sac:DocumentSerialID>' + char(13) + char(10) &
				+ '      <sac:DocumentNumberID>' + gnvo_app.of_left_trim(ls_nro, '0') + '</sac:DocumentNumberID>' + char(13) + char(10) &
				+ ' 	   <sac:VoidReasonDescription>' + ls_motivo_baja + '</sac:VoidReasonDescription>' + char(13) + char(10) &
				+ '   </sac:VoidedDocumentsLine>'
			
	invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)
	
	//actualizo el nro_rc en la tabla
	if not IsNull(ls_nro_registro) and trim(ls_nro_registro) <> '' then
		update fs_factura_simpl
		  set NRO_RA_ID = :ls_nro_ra_id
		 where nro_registro = :ls_nro_registro;

		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		 
	elseif not IsNull(ls_tipo_doc_cxc) and trim(ls_tipo_doc_cxc) <> '' and &
			 not IsNull(ls_nro_doc_cxc) and trim(ls_nro_doc_cxc) <> '' then
		
		update cntas_cobrar cc
		  set cc.NRO_RA_ID = :ls_nro_ra_id
		 where tipo_doc 	= :ls_tipo_doc_cxc
		   and nro_doc		= :ls_nro_doc_cxc;

		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		
	else
		
		MessageBox('Error ', 'No se ha espcificado un nro de registro o un nro de documento para actualizar. Por favor verifique!', StopSign!)
	end if
	
	ll_nro_item ++
next

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_RA( ls_nro_ra, ld_hoy)

update SUNAT_RA_DIARIO
	set path_file = :ls_PathFileXML
where NRO_RA_ID = :ls_nro_ra_id;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_RA_DIARIO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Cierro el documento
ls_texto = '</VoidedDocuments>'
invo_xml.of_write_ra_xml( ls_nro_ra, ls_texto, ld_hoy)



//Guardo los cambios
commit;

return true
end function

public function boolean of_allow_modify (string as_tipo_doc, string as_nro_doc);String 	ls_nro_registro_fs, ls_fec_envio_sunat
DateTime	ldt_fec_envio_sunat

//Esta función permite verificar si un documento de cntas_cobrar puede ser modificable directamente


//Valido si es un documento producto de la facturación simplificada, si lo es entonces 
//no deberia poderlo modificar
select nro_registro_fs
	into :ls_nro_registro_fs
from cntas_Cobrar cc
where cc.tipo_doc = :as_tipo_doc
  and cc.nro_doc	= :as_nro_doc;

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Error', 'El Documento por cobrar ' + as_tipo_doc + ' ' + as_nro_doc + ' no existe, por favor corrija', StopSign!)
	return false
end if

//Si no es nulo entonces si tiene un registro en facturacion simplificada
if not ISNull(ls_nro_registro_fs) and trim(ls_nro_registro_fs) <> '' then
	ROLLBACK;
	MessageBox('Error', 'No se puede modificar el documento ' + as_tipo_doc + ' ' + as_nro_doc &
							+ ' ya que sido generado por FACTURACION SIMPLIFICADA' &
							+ '~r~nNro Registro: ' + ls_nro_registro_fs + ', por favor corrija', StopSign!)
	return false
end if

//Verifico si ya tiene registro en la tabla SUNAT_ENVIO_CE
select to_char(t.fec_envio_sunat, 'dd/mm/yyyy hh:mi:ss'), t.fec_envio_sunat
	into :ls_fec_envio_sunat, :ldt_fec_envio_sunat
from sunat_envio_ce t,
     cntas_cobrar  cc
where t.nro_envio_id = cc.nro_envio_id    
  and cc.tipo_doc		= :as_tipo_doc
  and cc.nro_doc		= :as_nro_doc;

if SQLCA.SQlCode = 100 then
	return true
end if

If IsNull(ldt_fec_envio_sunat) then
	return true
end if

//Si no es nulo entonces si tiene una fecha de envio a SUNAT
if not ISNull(ls_fec_envio_sunat) and trim(ls_fec_envio_sunat) <> '' then
	ROLLBACK;
	MessageBox('Error', 'No se puede modificar el documento ' + as_tipo_doc + ' ' + as_nro_doc &
							+ ' ya que ha sido enviado a SUNAT por FACTURACION ELECTRONICA.' &
							+ '~r~nFecha envio SUNAT: ' + ls_fec_envio_sunat + ', por favor corrija', StopSign!)
	return false
end if

return true
end function

public function boolean of_print_proforma (string as_nro_proforma);Long ll_height, ll_count_almacen

//Imprimo el comprobante
if FileExists(gs_logo) then
	ids_despacho.DataObject = 'd_rpt_proforma_pos_tbl'
else
	ids_despacho.DataObject = 'd_rpt_proforma_pos_sinlogo_tbl'
end if
ids_despacho.SetTransObject(SQLCA)

ids_despacho.Retrieve(as_nro_proforma, gs_empresa)

if ids_despacho.RowCount( ) = 0 then
	MessageBox('Error', 'No existen registros para el ticket de DESPACHO ' + as_nro_proforma + ', por favor verifique!', StopSign!)
	return false
end if

//Cuento el nro de almacenes
select count(distinct t.almacen )
	into :ll_count_almacen
from FS_FACTURA_SIMPL_DET t
where t.nro_registro = :as_nro_proforma;

//ASigno el tamaño requerido
ll_height = il_height_despacho + il_header_row_alm * ll_count_almacen + il_header_row_desp * ids_despacho.RowCount( ) 
ids_despacho.Object.DataWindow.Print.Paper.Size = 256 
ids_despacho.Object.DataWindow.Print.CustomPage.Width = il_width_efact
ids_despacho.Object.DataWindow.Print.CustomPage.Length = ll_height

//Coloco el logo
if FileExists(gs_logo) then
	ids_despacho.object.p_logo.filename = gs_logo
end if

//Imprimo el ticket
ids_despacho.Print()

return true
end function

public function boolean of_generar_xml_fac_ubl20 (string asi_tipo_doc, string asi_nro_doc);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, ls_direccion_cliente, &
			ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, ls_und, ls_descripcion, ls_codigo, &
			ls_TaxExemptionReasonCode
String	ls_PathFileXML, ls_observacion
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf, ldc_total_op_exon, ldc_total_exp, ldc_LineExtensionAmount, &
			ldc_PriceAmount

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_cntas_cobrar_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_tipo_doc, asi_nro_doc)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_cntas_cobrar', 'No hay detalle para el comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc, Information!)
	return false
end if

//Descuento Global
ldc_dscto_global = 0

//Total Operaciones Gravadas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_grav
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '09';

//Total exportaciones
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_exp
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '08';

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_inaf
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '10';

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_exon
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '11';

//Impuesto IGV
select nvl(sum(ci.importe),0)
  into :ldc_total_igv
  from cc_doc_det_imp ci
 where ci.tipo_doc = :asi_tipo_doc
   and ci.nro_doc  = :asi_nro_doc;

//Total del documento
ldc_total_doc = round(ldc_total_exp + ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exon + ldc_total_igv,2)



//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion	= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Nro de Envio
ls_nro_envio_id		= ids_boletas.object.nro_envio_id	[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))
	
	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"' + char(13) + char(10) &
		   + '			xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '			xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '		  	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '		  	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '		  	xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '		  	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '		  	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '		  	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '		  	xmlns:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" ' + char(13) + char(10) &
			+ '		  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>'+ char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '      			<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
			+ '       				<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '      			</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '     				<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1003</cbc:ID>' + char(13) + char(10) &
			+ '        				<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exon + ldc_total_exp, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '      			</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
      	+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10)&
			+ '       				<cbc:ID>2005</cbc:ID>' + char(13) + char(10)&
			+ '       				<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10)&
			+ '     				</sac:AdditionalMonetaryTotal>' + char(13) + char(10)&
			+ '					<sac:AdditionalProperty>' + char(13) + char(10) &
			+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:Value>' + ls_total_txt + '</cbc:Value>' + char(13) + char(10) &
			+ '					</sac:AdditionalProperty>' + char(13) + char(10)
			
if ldc_total_doc <= 0 then
	ls_texto += '					<sac:AdditionalProperty>' + char(13) + char(10) &
				 + '						<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
				 + '						<cbc:Value>TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO GRATUITAMENTE</cbc:Value>' + char(13) + char(10) &
				 + '					</sac:AdditionalProperty>' + char(13) + char(10)
end if

//Si es una exportación
if ldc_total_exp > 0 then
	ls_texto += '					<sac:SUNATTransaction>' + char(13) + char(10) &
				 + '						<cbc:ID>02</cbc:ID>' + char(13) + char(10) &
				 + '					</sac:SUNATTransaction>' + char(13) + char(10)
else				 
	//Venta Interna
	ls_texto += '					<sac:SUNATTransaction>' + char(13) + char(10) &
				 + '						<cbc:ID>01</cbc:ID>' + char(13) + char(10) &
				 + '					</sac:SUNATTransaction>' + char(13) + char(10)
end if

			
ls_texto += '				</sac:AdditionalInformation>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '		<ext:UBLExtension>' + char(13) + char(10) &
			 + '			<ext:ExtensionContent>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Tipo de Documento
ls_texto = '   <cbc:InvoiceTypeCode>' + ls_tipo_doc + '</cbc:InvoiceTypeCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
//Adecuo las observaciones para el formato de la FACTURA
ls_observacion = invo_util.of_replace(ls_observacion, '~r~n', '<br/>')
ls_observacion = invo_util.of_replace(ls_observacion, '~r', '')
ls_observacion = invo_util.of_replace(ls_observacion, '~n', '')
ls_observacion = invo_util.of_replace(ls_observacion, 'Ú', 'U')
ls_observacion = invo_util.of_replace(ls_observacion, 'ú', 'u')
ls_observacion = invo_util.of_replace(ls_observacion, 'í', 'i')
ls_observacion = invo_util.of_replace(ls_observacion, 'Í', 'I')
ls_observacion = invo_util.of_replace(ls_observacion, '-', ' ')

if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if

//Line 9: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 11: Datos del Emisor
//Valido la información del emisor
if ISNull(gnvo_app.empresa.is_ruc) or trim(gnvo_app.empresa.is_ruc) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el RUC del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_ubigeo) or trim(gnvo_app.empresa.is_ubigeo) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el UBIGEO del emisor en registro, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_direccion) or trim(gnvo_app.empresa.is_direccion) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la direccion del emisor en registro, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_departamento) or trim(gnvo_app.empresa.is_departamento) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el DEPARTAMENTO del emisor, por favor verifique!', StopSign!)
	return false
end if


ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Datos del Cliente
if IsNull(ls_direccion_cliente) then
	MessageBox('Error', 'Debe Especificar la direccion del cliente, por favor verifique!', StopSign!)
	return false
end if
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Resumen total del documento
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav + ldc_total_exp + ldc_total_op_inaf + ldc_total_op_exon, '#####0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
			+ '  		<cbc:TaxExclusiveAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxExclusiveAmount>' + char(13) + char(10) &
			+ '  		<cbc:AllowanceTotalAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:AllowanceTotalAmount>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro	[ll_row]
	ls_und				= ids_boletas.object.und				[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion		[ll_row]
	ls_codigo			= ids_boletas.object.cod_art			[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)


	//Calculo el precio de venta
	ldc_LineExtensionAmount = ldc_precio_unit - ldc_descuento
	ldc_precio_vta				= ldc_LineExtensionAmount + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0
	
	if ldc_total_exp > 0 then
		ls_TaxExemptionReasonCode = '40'
	else
		if ldc_igv > 0 then
			ls_TaxExemptionReasonCode = '10'
		else
			ls_TaxExemptionReasonCode = '30'
		end if
	end if
	
	if ldc_total_doc > 0 then
		ldc_PriceAmount = 0
	else
		ldc_PriceAmount = ldc_precio_vta
		ldc_precio_vta = 0
	end if
	
	ls_texto = '	<cac:InvoiceLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:InvoicedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:InvoicedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_LineExtensionAmount, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)
	
	//Si la operacion es gratuita
	if ldc_PriceAmount > 0 then
		ls_texto += '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
					+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">0.00</cbc:PriceAmount>' + char(13) + char(10)&
					+ '				<cbc:PriceTypeCode>02</cbc:PriceTypeCode>' + char(13) + char(10) &
					+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10) 
	end if
				
	ls_texto += '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>18.0</cbc:Percent> ' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme> ' + char(13) + char(10)&
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '						</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '		</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_LineExtensionAmount, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:InvoiceLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update cntas_cobrar
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where tipo_doc = :asi_tipo_doc
   and nro_doc	 = :asi_nro_doc;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :invo_xml.is_file_xml
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Cierro el documento
ls_texto = '</Invoice>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ncc_ubl20 (string asi_tipo_doc, string asi_nro_doc);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo, ls_TaxExemptionReasonCode, ls_tipo_cred_fiscal
String 	ls_PathFileXML, ls_observacion
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_cxc_ncc_ndc_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_tipo_doc, asi_nro_doc)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_cxc_ncc_ndc', 'No hay detalle para el comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc, Information!)
	return false
end if

//Descuento Global
ldc_dscto_global = 0

//Total Operaciones Gravadas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_grav
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '09';

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_inaf
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal <> '09';

//Impuesto IGV
select nvl(sum(ci.importe),0)
  into :ldc_total_igv
  from cc_doc_det_imp ci
 where ci.tipo_doc = :asi_tipo_doc
   and ci.nro_doc  = :asi_nro_doc;

//Total del documento
ldc_total_doc = round(ldc_total_op_grav + ldc_total_op_inaf + ldc_total_igv,2)


//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion	= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nc				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Obtengo el nro_envio_id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_Envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio		[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" ' + char(13) + char(10) &
			+ '  				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '			 	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '			 	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '			 	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '			 	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '			 	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '    		<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + string(ldc_total_doc, '#####0.00') + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)


//Leyenda 01: Leyenda observaciones
/*
if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if
*/

//Line 9: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 12: Datos del Emisor
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15: Resumen total del documento
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro		= ids_boletas.object.nro_registro		[ll_row]
	ls_und					= ids_boletas.object.und					[ll_row]
	ls_descripcion			= ids_boletas.object.descripcion			[ll_row]
	ls_codigo				= ids_boletas.object.cod_art				[ll_row]
	ls_tipo_cred_fiscal 	= ids_boletas.object.tipo_cred_fiscal	[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	if ls_tipo_cred_fiscal = '08' then
		//Exportacion
		ls_TaxExemptionReasonCode = '40'
	elseif ls_tipo_cred_fiscal = '09' then
		//Venta nacional Gravada
		ls_TaxExemptionReasonCode = '10'
	elseif ls_tipo_cred_fiscal = '10' then
		//Venta nacional inafecta
		ls_TaxExemptionReasonCode = '30'
	elseif ls_tipo_cred_fiscal = '11' then
		//Venta nacional exonerada
		ls_TaxExemptionReasonCode = '20'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)


	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:CreditNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:CreditedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:CreditedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * (ldc_precio_unit - ldc_descuento), '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>18.0</cbc:Percent>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit - ldc_descuento, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:CreditNoteLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update cntas_cobrar
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where tipo_doc = :asi_tipo_doc
   and nro_doc	 = :asi_nro_doc;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR - Funcion of_generar_xml_cxc_ncc. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Cierro el documento
ls_texto = '</CreditNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ndc_ubl20 (string asi_tipo_doc, string asi_nro_doc);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo, ls_TaxExemptionReasonCode, ls_tipo_cred_fiscal
String 	ls_PathFileXML, ls_observacion	
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_cxc_ncc_ndc_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_tipo_doc, asi_nro_doc)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_cxc_ndc', 'No hay detalle para el comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc, Information!)
	return false
end if

//Descuento Global
ldc_dscto_global = 0

//Total Operaciones Gravadas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_grav
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '09';

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_inaf
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal <> '09';

//Impuesto IGV
select nvl(sum(ci.importe),0)
  into :ldc_total_igv
  from cc_doc_det_imp ci
 where ci.tipo_doc = :asi_tipo_doc
   and ci.nro_doc  = :asi_nro_doc;

//Total del documento
ldc_total_doc = round(ldc_total_op_grav + ldc_total_op_inaf + ldc_total_igv,2)


//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion	= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nd				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Obtengo el nro_envio_id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_Envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio		[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<DebitNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2" ' + char(13) + char(10) &
			+ '  				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '			 	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '			 	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '			 	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '			 	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '			 	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '    		<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + string(ldc_total_doc, '#####0.00') + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
/*
if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if
*/
//Line 9: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 12: Datos del Emisor
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15: Resumen total del documento
ls_texto = '	<cac:RequestedMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:RequestedMonetaryTotal>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro		= ids_boletas.object.nro_registro		[ll_row]
	ls_und					= ids_boletas.object.und					[ll_row]
	ls_descripcion			= ids_boletas.object.descripcion			[ll_row]
	ls_codigo				= ids_boletas.object.cod_art				[ll_row]
	ls_tipo_cred_fiscal 	= ids_boletas.object.tipo_cred_fiscal	[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	if ls_tipo_cred_fiscal = '08' then
		//Exportacion
		ls_TaxExemptionReasonCode = '40'
	elseif ls_tipo_cred_fiscal = '09' then
		//Venta nacional Gravada
		ls_TaxExemptionReasonCode = '10'
	elseif ls_tipo_cred_fiscal = '10' then
		//Venta nacional inafecta
		ls_TaxExemptionReasonCode = '30'
	elseif ls_tipo_cred_fiscal = '11' then
		//Venta nacional exonerada
		ls_TaxExemptionReasonCode = '20'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)


	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:DebitNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:DebitedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:DebitedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * (ldc_precio_unit - ldc_descuento), '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>18.0</cbc:Percent>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit - ldc_descuento, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:DebitNoteLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update cntas_cobrar
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where tipo_doc = :asi_tipo_doc
   and nro_doc	 = :asi_nro_doc;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR - Funcion of_generar_xml_cxc_ndc. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Cierro el documento
ls_texto = '</DebitNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_fac_ubl20 (string asi_nro_registro);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, ls_direccion_cliente, &
			ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, ls_und, ls_descripcion, ls_codigo, &
			ls_TaxExemptionReasonCode
String	ls_PathFileXML, ls_observacion			
Long		ll_row, ll_ult_nuevo, ll_nro_item, ll_count
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_total_op_inaf, &
			ldc_total_op_exon, ldc_total_op_gratuitas, ldc_PriceAmount, ldc_Percent, ldc_TaxAmount, &
			ldc_LineExtensionAmount

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_fs_factura_smpl_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_nro_registro)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Aviso', 'No hay detalle para el comprobante de pago correspondiente al registro ' &
			+ asi_nro_registro, Information!)
	return false
end if

//Descuento Global
select round(nvl(sum(fd.cant_proyect * abs(fd.precio_unit - fd.descuento)),0),2)
  into :ldc_dscto_global
from fs_factura_simpl_det fd
where (fd.precio_unit < 0 or fd.descuento > 0)
  and fd.nro_registro = :asi_nro_registro;
  
//Total del documento
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv)),0),2)
  into :ldc_total_doc
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro;

//Total Operaciones Gravadas
select round(nvl(sum(fd.cant_proyect * fd.precio_unit),0),2)
  into :ldc_total_op_grav
from fs_factura_simpl_det fd
where fd.importe_igv > 0
  and fd.nro_registro = :asi_nro_registro;

//Impuesto IGV
select round(nvl(sum(fd.cant_proyect * fd.importe_igv),0),2)
  into :ldc_total_igv
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro;

//Operaciones inafectas
ldc_total_op_inaf = 0

//Operaciones exoneradas
ldc_total_op_exon = 0

//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion = ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Nro Envio
ls_nro_envio_id		= ids_boletas.object.nro_envio_id	[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if ISNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then
	//La fecha de envio es la de hoy día
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])
end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"' + char(13) + char(10) &
			+ ' 			xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"' + char(13) + char(10) &
			+ '			xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10) &
			+ '			xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"' + char(13) + char(10) &
			+ '			xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"' + char(13) + char(10) &
			+ '			xmlns:ccts="urn:un:unece:uncefact:documentation:2"' + char(13) + char(10) &
			+ '			xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"' + char(13) + char(10) & 
		  	+ '			xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"' + char(13) + char(10) & 
		   + '			xmlns:ds="http://www.w3.org/2000/09/xmldsig#"' + char(13) + char(10) & 
		  	+ ' 			xmlns:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"' + char(13) + char(10) & 
		  	+ '			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

ldc_LineExtensionAmount =ldc_total_op_grav

if ldc_total_doc <= 0 then
	ldc_total_op_gratuitas = ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exon
	ldc_dscto_global 	= 0
	ldc_total_op_grav = 0
	ldc_total_op_inaf = 0 
	ldc_total_op_exon = 0
else
	ldc_total_op_gratuitas = 0
	
end if


//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>'+ char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1003</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exon, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1004</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_gratuitas, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>2005</cbc:ID>' + char(13) + char(10)&
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10)&
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10)&
			+ '					<sac:AdditionalProperty>' + char(13) + char(10) &
			+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:Value>' + ls_total_txt + '</cbc:Value>' + char(13) + char(10) &
			+ '					</sac:AdditionalProperty>' + char(13) + char(10)

if ldc_total_doc <= 0 then
	ls_texto += '					<sac:AdditionalProperty>' + char(13) + char(10) &
				 + '						<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
				 + '						<cbc:Value>TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO GRATUITAMENTE</cbc:Value>' + char(13) + char(10) &
				 + '					</sac:AdditionalProperty>' + char(13) + char(10)
end if

ls_texto += '				</sac:AdditionalInformation>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '		<ext:UBLExtension>' + char(13) + char(10) &
			 + '			<ext:ExtensionContent>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Tipo de Documento
ls_texto = '   <cbc:InvoiceTypeCode>' + ls_tipo_doc + '</cbc:InvoiceTypeCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
ls_observacion = invo_util.of_replace(ls_observacion, '~r~n', '<br/>')
ls_observacion = invo_util.of_replace(ls_observacion, '~r', '')
ls_observacion = invo_util.of_replace(ls_observacion, '~n', '')
ls_observacion = invo_util.of_replace(ls_observacion, 'Ú', 'U')
ls_observacion = invo_util.of_replace(ls_observacion, 'ú', 'u')
ls_observacion = invo_util.of_replace(ls_observacion, 'í', 'i')
ls_observacion = invo_util.of_replace(ls_observacion, 'Í', 'I')
ls_observacion = invo_util.of_replace(ls_observacion, '-', ' ')
if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if

//Line 9: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 11: Datos del Emisor
//Valido la información del emisor
if ISNull(gnvo_app.empresa.is_ruc) or trim(gnvo_app.empresa.is_ruc) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el RUC del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_ubigeo) or trim(gnvo_app.empresa.is_ubigeo) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el UBIGEO del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_direccion) or trim(gnvo_app.empresa.is_direccion) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la direccion del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_departamento) or trim(gnvo_app.empresa.is_departamento) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el DEPARTAMENTO del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Datos del Cliente
//Valido la información del cliente
if ISNull(ls_nro_doc_cliente) or trim(ls_nro_doc_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el Nro de Documento de Identificacion del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_tipo_doc_cliente) or trim(ls_tipo_doc_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el tipo de Documento de Identificacion del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_nom_cliente) or trim(ls_nom_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_direccion_cliente) or trim(ls_direccion_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado o esta incompleta la direccion del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_pais_cliente) or trim(ls_pais_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el pais del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if


ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '			<cac:TaxCategory>' + char(13) + char(10) &
			+ '				<cac:TaxScheme>' + char(13) + char(10) &
			+ '					<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '					<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '				</cac:TaxScheme>' + char(13) + char(10) &
			+ '			</cac:TaxCategory>' + char(13) + char(10) &
			+ '		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ '	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Resumen total del documento
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_LineExtensionAmount, '#####0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
			+ '  		<cbc:TaxExclusiveAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxExclusiveAmount>' + char(13) + char(10) &
			+ '  		<cbc:AllowanceTotalAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:AllowanceTotalAmount>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro	[ll_row]
	ls_und				= ids_boletas.object.und				[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion		[ll_row]
	ls_codigo			= ids_boletas.object.cod_art			[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)
	
	//Calculo el precio de venta
	ldc_TaxAmount = ldc_cantidad * ldc_igv
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0
	
	if ldc_total_doc > 0 then
	
		ldc_PriceAmount = 0
		ldc_Percent = 18
		ls_TaxExemptionReasonCode= '10'
		
	else
		ldc_PriceAmount = ldc_precio_vta
		
		ldc_precio_unit = 0
		ldc_precio_vta = 0
		ldc_Percent = 0
		
		ls_TaxExemptionReasonCode= '13'
	end if
	
	ls_texto = '	<cac:InvoiceLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:InvoicedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:InvoicedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)
				
	//Si la operacion es gratuita agrego esta linea de lo contrario no lo hago
	if ldc_PriceAmount > 0 then
		ls_texto += '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
					+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_PriceAmount, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10)&
					+ '				<cbc:PriceTypeCode>02</cbc:PriceTypeCode>' + char(13) + char(10) &
					+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10) 
	end if
	
	
	ls_texto += '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_TaxAmount, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_TaxAmount, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>' + trim(string(ldc_Percent, '######0.0')) + '</cbc:Percent> ' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme> ' + char(13) + char(10)&
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '						</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:InvoiceLine>'
			
				
	
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update fs_factura_simpl
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_registro = :ls_nro_registro;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Cierro el documento
ls_texto = '</Invoice>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ncc_ubl20 (string as_nro_registro);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo
String	ls_PathFileXML, ls_observacion
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf, ldc_total_op_exon

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_fs_factura_smpl_det_ncc_ndc_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(as_nro_registro)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_fs_ncc', 'No hay detalle para el comprobante de pago con numero de registro ' + as_nro_registro, Information!)
	return false
end if

//Descuento Global
select round(nvl(sum(fd.cant_proyect * abs(fd.precio_unit - fd.descuento)),0),2)
  into :ldc_dscto_global
from fs_factura_simpl_det fd
where (fd.precio_unit < 0 or fd.descuento > 0)
  and fd.nro_registro = :as_nro_registro;
  
//Total del documento
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv)),0),2)
  into :ldc_total_doc
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Total Operaciones Gravadas
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento)),0),2)
  into :ldc_total_op_grav
from fs_factura_simpl_det fd
where fd.importe_igv > 0
  and fd.nro_registro = :as_nro_registro;

//Impuesto IGV
select round(nvl(sum(fd.cant_proyect * (fd.importe_igv)),0),2)
  into :ldc_total_igv
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Operaciones inafectas
ldc_total_op_inaf = 0

//Operaciones exoneradas
ldc_total_op_exon = 0


//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion	= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nc				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Nro Envio Id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" ' + char(13) + char(10) &
			+ '  				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '			 	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '			 	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '			 	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '			 	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '			 	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '    		<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + string(ldc_total_op_grav, '#####0.00') + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
/*
if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if
*/
//Line 9: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 12: Datos del Emisor
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15: Resumen total del documento
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro	[ll_row]
	ls_und				= ids_boletas.object.und				[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion		[ll_row]
	ls_codigo			= ids_boletas.object.cod_art			[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)

	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:CreditNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:CreditedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:CreditedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * (ldc_precio_unit - ldc_descuento), '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>18.0</cbc:Percent>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>10</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit - ldc_descuento, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:CreditNoteLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update fs_factura_simpl
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_registro = :ls_nro_registro;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Cierro el documento
ls_texto = '</CreditNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ndc_ubl20 (string as_nro_registro);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo
String	ls_PathFileXML, ls_observacion
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf, ldc_total_op_exon

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_fs_factura_smpl_det_ncc_ndc_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(as_nro_registro)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_fs_ndc', 'No hay detalle para el comprobante de pago con numero de registro ' + as_nro_registro, Information!)
	return false
end if

//Descuento Global
select round(nvl(sum(fd.cant_proyect * abs(fd.precio_unit - fd.descuento)),0),2)
  into :ldc_dscto_global
from fs_factura_simpl_det fd
where (fd.precio_unit < 0 or fd.descuento > 0)
  and fd.nro_registro = :as_nro_registro;
  
//Total del documento
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv)),0),2)
  into :ldc_total_doc
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Total Operaciones Gravadas
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento)),0),2)
  into :ldc_total_op_grav
from fs_factura_simpl_det fd
where fd.importe_igv > 0
  and fd.nro_registro = :as_nro_registro;

//Impuesto IGV
select round(nvl(sum(fd.cant_proyect * (fd.importe_igv)),0),2)
  into :ldc_total_igv
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Operaciones inafectas
ldc_total_op_inaf = 0

//Operaciones exoneradas
ldc_total_op_exon = 0


//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion	= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nd				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Nro Envio Id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<DebitNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2" ' + char(13) + char(10) &
			+ '  				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '			 	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '			 	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '			 	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '			 	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '			 	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '    		<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + string(ldc_total_op_grav, '#####0.00') + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
/*
if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if
*/
//Line 9: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 12: Datos del Emisor
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15: Resumen total del documento
ls_texto = '	<cac:RequestedMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:RequestedMonetaryTotal>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro	[ll_row]
	ls_und				= ids_boletas.object.und				[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion		[ll_row]
	ls_codigo			= ids_boletas.object.cod_art			[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)

	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:DebitNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:DebitedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:DebitedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * (ldc_precio_unit - ldc_descuento), '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>18.0</cbc:Percent>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>10</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit - ldc_descuento, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:DebitNoteLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update fs_factura_simpl
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_registro = :ls_nro_registro;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Cierro el documento
ls_texto = '</DebitNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_fac_ubl21 (string asi_nro_registro);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, ls_direccion_cliente, &
			ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, ls_und, ls_descripcion, ls_codigo, &
			ls_TaxExemptionReasonCode, ls_hora_emision, ls_PriceTypeCode, ls_flag_afecto_igv, &
			ls_IdTaxScheme, ls_NameTaxScheme, ls_TaxTypeCode, lsTaxCategoryId
String	ls_PathFileXML, ls_observacion			
Long		ll_row, ll_ult_nuevo, ll_nro_item, ll_count, ll_LineCountNumeric, ll_cant_bolsas
Date		ld_fec_envio, ld_fec_emision, ld_fec_vencimiento
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, &
			ldc_total_op_inaf, ldc_total_op_exon, &
			ldc_total_op_grat, ldc_PriceAmount, ldc_Percent, ldc_TaxAmount, &
			ldc_total_venta, ldc_icbper
	
//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_fs_factura_smpl_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_nro_registro)

ll_LineCountNumeric = ids_boletas.RowCount()

if ll_LineCountNumeric = 0 then 
	MessageBox('Aviso', 'No hay detalle para el comprobante de pago correspondiente al registro ' &
			+ asi_nro_registro, Information!)
	return false
end if

//Descuento Global
select round(nvl(sum(fd.cant_proyect * abs(fd.precio_unit - fd.descuento)),0),2)
  into :ldc_dscto_global
from fs_factura_simpl_det fd
where (fd.precio_unit < 0 or fd.descuento > 0)
  and fd.nro_registro = :asi_nro_registro;
  
//Total del documento incluido impuestos
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv) + fd.icbper),0),2)
  into :ldc_total_doc
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro;

//Total de venta sin impuestos ni descuentos
select round(nvl(sum(fd.cant_proyect * fd.precio_unit),0),2)
  into :ldc_total_venta
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro;

//Total Operaciones Gravadas
select round(nvl(sum(fd.cant_proyect * fd.precio_unit),0),2)
  into :ldc_total_op_grav
from fs_factura_simpl_det fd
where fd.importe_igv > 0
  and fd.nro_registro = :asi_nro_registro
  and fd.flag_afecto_igv = '1';

//Impuesto IGV
select round(nvl(sum(fd.cant_proyect * fd.importe_igv),0),2)
  into :ldc_total_igv
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro;

//Impuesto ICBPER
select round(nvl(sum(fd.icbper),0),2)
  into :ldc_icbper
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro;

//Cantidad de bolsas plasticas
select count(*)
  into :ll_cant_bolsas
from fs_factura_simpl_det fd
where fd.nro_registro = :asi_nro_registro
  and fd.icbper 		 > 0;

//Operaciones inafectas
select round(nvl(sum(fd.cant_proyect * fd.precio_unit),0),2)
  into :ldc_total_op_inaf
from fs_factura_simpl_det fd
where fd.importe_igv      = 0
  and fd.flag_afecto_igv   = '2'
  and fd.precio_unit      > 0
  and fd.nro_registro = :asi_nro_registro;
  
//Operaciones exoneradas
select round(nvl(sum(fd.cant_proyect * fd.precio_unit),0),2)
  into :ldc_total_op_exon
from fs_factura_simpl_det fd
where fd.importe_igv      = 0
  and fd.flag_afecto_igv   = '3'
  and fd.precio_unit      > 0
  and fd.nro_registro = :asi_nro_registro;

//Datos del comprobante
ls_tipo_doc 		= ids_boletas.object.tipo_doc					[1]
ls_serie				= ids_boletas.object.serie						[1]
ls_nro				= ids_boletas.object.nro						[1]
ls_moneda			= ids_boletas.object.moneda					[1]
ls_desc_moneda		= ids_boletas.object.desc_moneda				[1]
ls_observacion 	= ids_boletas.object.observacion				[1]
ls_hora_emision 	= ids_boletas.object.hora_emision			[1]
ld_fec_emision 	= Date(ids_boletas.object.fec_emision		[1])
ld_fec_vencimiento= Date(ids_boletas.object.fec_vencimiento	[1])
//ls_und 				= ids_boletas.object.und						[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Nro Envio
ls_nro_envio_id		= ids_boletas.object.nro_envio_id	[1]

ls_total_txt 			= invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if ISNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then
	//La fecha de envio es la de hoy día
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])
end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"' + char(13) + char(10) &
			+ ' 			xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"' + char(13) + char(10) &
			+ '			xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10) &
			+ '			xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"' + char(13) + char(10) &
			+ '			xmlns:ccts="urn:un:unece:uncefact:documentation:2"' + char(13) + char(10) &
		   + '			xmlns:ds="http://www.w3.org/2000/09/xmldsig#"' + char(13) + char(10) & 
			+ '			xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"' + char(13) + char(10) & 
		  	+ '			xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"' + char(13) + char(10) & 
			+ '			xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"' + char(13) + char(10) &
		  	+ '			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

if ldc_total_doc <= 0 then
	ldc_total_op_grat = ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exon
	ldc_dscto_global 	= 0
	ldc_total_op_grav = 0
	ldc_total_op_inaf = 0 
	ldc_total_op_exon = 0
else
	ldc_total_op_grat = ldc_icbper
	
end if


//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>'+ char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1003</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exon, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1004</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grat, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>2005</cbc:ID>' + char(13) + char(10)&
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10)&
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10)&
			+ '					<sac:AdditionalProperty>' + char(13) + char(10) &
			+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:Value>' + ls_total_txt + '</cbc:Value>' + char(13) + char(10) &
			+ '					</sac:AdditionalProperty>' + char(13) + char(10)

if ldc_total_doc <= 0 then
	ls_texto += '					<sac:AdditionalProperty>' + char(13) + char(10) &
				 + '						<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
				 + '						<cbc:Value>TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO GRATUITAMENTE</cbc:Value>' + char(13) + char(10) &
				 + '					</sac:AdditionalProperty>' + char(13) + char(10)
end if

ls_texto += '				</sac:AdditionalInformation>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '		<ext:UBLExtension>' + char(13) + char(10) &
			 + '			<ext:ExtensionContent>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>2.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 8: Hora de emisión 
ls_texto = '   <cbc:IssueTime>' + ls_hora_emision + '</cbc:IssueTime>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 9: Fecha vencimiento
ls_texto = '   <cbc:DueDate>' + string(ld_fec_vencimiento, 'yyyy-mm-dd') + '</cbc:DueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Tipo de Documento
//listName="SUNAT:Identificador de Tipo de Documento
ls_texto = '   <cbc:InvoiceTypeCode listID="0101"' + char(13) + char(10) &
			+ '								listAgencyName="PE:SUNAT"' + char(13) + char(10) &
         + '								listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo01">' + ls_tipo_doc + '</cbc:InvoiceTypeCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
ls_observacion = invo_util.of_replace(ls_observacion, '~r~n', '<br/>')
ls_observacion = invo_util.of_replace(ls_observacion, '~r', '')
ls_observacion = invo_util.of_replace(ls_observacion, '~t', ' ')
ls_observacion = invo_util.of_replace(ls_observacion, '~n', '')
ls_observacion = invo_util.of_replace(ls_observacion, 'Ú', 'U')
ls_observacion = invo_util.of_replace(ls_observacion, 'ú', 'u')
ls_observacion = invo_util.of_replace(ls_observacion, 'í', 'i')
ls_observacion = invo_util.of_replace(ls_observacion, 'Í', 'I')
ls_observacion = invo_util.of_replace(ls_observacion, '-', ' ')
ls_observacion = invo_util.of_replace(ls_observacion, '.', ' ')
ls_observacion = trim(ls_observacion)

if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + left(ls_observacion, 200) + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if

//Line 11: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Numero de Lineas del Documento
ls_texto = '   <cbc:LineCountNumeric>' + string(ll_LineCountNumeric) + '</cbc:LineCountNumeric>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 14: Datos del Emisor
//Valido la información del emisor
if ISNull(gnvo_app.empresa.is_ruc) or trim(gnvo_app.empresa.is_ruc) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el RUC del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_ubigeo) or trim(gnvo_app.empresa.is_ubigeo) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el UBIGEO del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_direccion) or trim(gnvo_app.empresa.is_direccion) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la direccion del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_departamento) or trim(gnvo_app.empresa.is_departamento) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el DEPARTAMENTO del emisor en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

//<cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
//schemeName="SUNAT:Identificador de Documento de Identidad"
			
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
         + '				<cbc:ID schemeID="6"' + char(13) + char(10) &
         + '						  schemeAgencyName="PE:SUNAT"' + char(13) + char(10) &
         + '						  schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
      	+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
         + '				<cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
         + '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '            	<cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '					<cbc:AddressTypeCode>0000</cbc:AddressTypeCode>' + char(13) + char(10) &
			+ '					<cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '					<cbc:CountrySubentity><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '					<cbc:District><![CDATA[' + gnvo_app.empresa.is_distrito + ']]></cbc:District>' + char(13) + char(10) &
			+ '					<cac:AddressLine>' + char(13) + char(10) &
         + '						<cbc:Line><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:Line>' + char(13) + char(10) &
         + '					</cac:AddressLine>' + char(13) + char(10) &
         + '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
  			+ '		   	</cac:RegistrationAddress>' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15: Datos del Cliente
//Valido la información del cliente
if ISNull(ls_nro_doc_cliente) or trim(ls_nro_doc_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el Nro de Documento de Identificacion del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_tipo_doc_cliente) or trim(ls_tipo_doc_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el tipo de Documento de Identificacion del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_nom_cliente) or trim(ls_nom_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_direccion_cliente) or trim(ls_direccion_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado o esta incompleta la direccion del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_pais_cliente) or trim(ls_pais_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el pais del cliente en registro ' + asi_nro_registro + ', por favor verifique!', StopSign!)
	return false
end if

ls_nom_cliente 		= invo_util.of_replace( ls_nom_cliente, 'Ñ', 'N')
ls_direccion_cliente = invo_util.of_replace( ls_direccion_cliente, 'Ñ', 'N')

ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
      	+ '		<cac:Party>' + char(13) + char(10) &
         + '			<cac:PartyIdentification>' + char(13) + char(10) &
         + '				<cbc:ID schemeID="' + ls_tipo_doc_cliente + '">' + ls_nro_doc_cliente + '</cbc:ID>' + char(13) + char(10) &
         + '			</cac:PartyIdentification>' + char(13) + char(10) &
         + '			<cac:PartyLegalEntity>' + char(13) + char(10) &
         + '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName>' + char(13) + char(10) &
         + '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cac:AddressLine>' + char(13) + char(10) &
         + '         			<cbc:Line><![CDATA[' + ls_direccion_cliente + ']]></cbc:Line>' + char(13) + char(10) &
         + '					</cac:AddressLine>' + char(13) + char(10) &
         + '					<cac:Country>' + char(13) + char(10) &
         + '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
         + '					</cac:Country>' + char(13) + char(10) &
         + '				</cac:RegistrationAddress>' + char(13) + char(10) &
         + '			</cac:PartyLegalEntity>' + char(13) + char(10) &
      	+ '		</cac:Party>' + char(13) + char(10) &
   		+ '	</cac:AccountingCustomerParty>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15-B: Forma de Pago
ls_texto = '	<cac:PaymentTerms>' + char(13) + char(10) &
      	+ '		<cbc:ID>FormaPago</cbc:ID>' + char(13) + char(10) &
      	+ '		<cbc:PaymentMeansID>Contado</cbc:PaymentMeansID>' + char(13) + char(10) &
   	   + '	</cac:PaymentTerms>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 16: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10)

if ldc_total_op_grav > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">S</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">1000</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_inaf > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">O</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9998</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>INA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_exon + ldc_icbper > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exon + ldc_icbper, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">E</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9997</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXO</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_grat > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grat, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">Z</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9996</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>GRA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_icbper > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">7152</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if
			
ls_texto += '	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 17: Resumen total del documento
//<cbc:TaxtInclusiveAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:TaxtInclusiveAmount>'
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_venta, '#####0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
			+ '		<cbc:TaxInclusiveAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:TaxInclusiveAmount>' + char(13) + char(10) &
			+ '  		<cbc:AllowanceTotalAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:AllowanceTotalAmount>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro		= ids_boletas.object.nro_registro		[ll_row]
	ls_und					= ids_boletas.object.und					[ll_row]
	ls_descripcion			= ids_boletas.object.descripcion			[ll_row]
	ls_codigo				= ids_boletas.object.cod_art				[ll_row]
	ls_flag_afecto_igv	= ids_boletas.object.flag_afecto_igv	[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	ldc_icbper			= Dec(ids_boletas.object.icbper			[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	If IsNull(ldc_icbper) then ldc_icbper = 0
	
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	//if IsNull(ls_und) or trim(ls_und) = '' then
	//	ls_und = 'ZZ'
	//else
	//	ls_und = 'NIU'
	//end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~t', ' ')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'Ú', 'U')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'ú', 'u')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'í', 'i')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'Í', 'I')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '-', ' ')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '.', ' ')

	ls_descripcion = left(trim(ls_descripcion), 200)
	
	//Calculo el precio de venta
	ldc_TaxAmount = ldc_cantidad * ldc_igv
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv + ldc_icbper
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0
	
	if ldc_total_doc > 0 then
	
		ldc_PriceAmount = 0
		ldc_Percent = 18
		
		if ls_flag_afecto_igv = '1' then
			
			ls_TaxExemptionReasonCode= '10'
			ls_IdTaxScheme = '1000'
			ls_NameTaxScheme = 'IGV'
			ls_TaxTypeCode = 'VAT'
			ls_PriceTypeCode = '01'
			lsTaxCategoryId = 'S'
			
		elseif ls_flag_afecto_igv = '2' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '30'
			ls_IdTaxScheme = '9998'
			ls_NameTaxScheme = 'INA'
			ls_TaxTypeCode = 'FRE'
			ls_PriceTypeCode = '01'
			lsTaxCategoryId = 'O'
			
		elseif ls_flag_afecto_igv = '3' then
			
			//Exonerado
			ls_TaxExemptionReasonCode= '20'
			ls_IdTaxScheme = '9997'
			ls_NameTaxScheme = 'EXO'
			ls_TaxTypeCode = 'VAT'
			ls_PriceTypeCode = '01'
			lsTaxCategoryId = 'E'
			
		elseif ls_flag_afecto_igv = '0' then
			
			//Gratuito
			if ldc_icbper = 0 then
				ls_TaxExemptionReasonCode= '20'
			else
				ls_TaxExemptionReasonCode= '21'
			end if
			
			ls_IdTaxScheme = '9996'
			ls_NameTaxScheme = 'GRA'
			ls_TaxTypeCode = 'FRE'
			ls_PriceTypeCode = '02'
			lsTaxCategoryId = 'Z'
			
		end if
		
	else
		ldc_PriceAmount = ldc_precio_vta
		
		ldc_precio_unit = 0
		ldc_precio_vta = 0
		ldc_Percent = 0
		
		ls_TaxExemptionReasonCode= '11'
		
		ls_IdTaxScheme = '9996'
		ls_NameTaxScheme = 'GRA'
		ls_TaxTypeCode = 'FRE'
		
		ls_PriceTypeCode = '02'
	end if
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		Rollback;
		MessageBox('Error', 'No ha especificado la UNIDAD en registro ' + asi_nro_registro &
							   + ', Item ' + trim(string(ll_nro_item)) + ', por favor verifique!', StopSign!)
		return false
	end if
	
	
	
	ls_texto = '	<cac:InvoiceLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:InvoicedQuantity unitCode="' + trim(ls_und) + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:InvoicedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit + ldc_icbper, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10)
				
	//Si la operacion es gratuita agrego esta linea de lo contrario no lo hago
	if ldc_PriceAmount > 0 then
		ls_texto += '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
					 + '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_PriceAmount, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10)&
					 + '				<cbc:PriceTypeCode>02</cbc:PriceTypeCode>' + char(13) + char(10) &
					 + '			</cac:AlternativeConditionPrice>' + char(13) + char(10) 
	else
		ls_texto += '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
					 + '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
					 + '				<cbc:PriceTypeCode>' + ls_PriceTypeCode + '</cbc:PriceTypeCode> ' + char(13) + char(10) &
					 + '			</cac:AlternativeConditionPrice>' + char(13) + char(10)				
	end if
	
	
	ls_texto += '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_TaxAmount + ldc_icbper, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit + ldc_icbper, '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_TaxAmount, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	+ '						  		schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	+ '						  		schemeAgencyName="United Nations Economic Commission for Europe">' + lsTaxCategoryId + '</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:Percent>' + trim(string(ldc_Percent, '######0.0')) + '</cbc:Percent> ' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cac:TaxScheme> ' + char(13) + char(10)&
				+ '						<cbc:ID>' + ls_IdTaxScheme + '</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>' + ls_NameTaxScheme + '</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>' + ls_TaxTypeCode + '</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) 

	if ldc_icbper > 0 then
		ls_texto +='			<cac:TaxSubtotal>' + char(13) + char(10) &
            	+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper * ll_cant_bolsas, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
            	+ '				<cbc:BaseUnitMeasure unitCode="NIU">' + trim(string(ll_cant_bolsas, '######0')) + '</cbc:BaseUnitMeasure>' + char(13) + char(10) &
            	+ '				<cac:TaxCategory>' + char(13) + char(10) &
					+ '					<cbc:PerUnitAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper, '######0.00')) + '</cbc:PerUnitAmount>' + char(13) + char(10) &
               + '					<cac:TaxScheme>' + char(13) + char(10) &
               + '						<cbc:ID>7152</cbc:ID>' + char(13) + char(10) &
               + '						<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
               + '						<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
               + '					</cac:TaxScheme>' + char(13) + char(10) &
            	+ '				</cac:TaxCategory>' + char(13) + char(10) &
         		+ '			</cac:TaxSubtotal>' + char(13) + char(10) &

	end if

	ls_texto +='		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit, '######0.000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:InvoiceLine>'
			
				
	
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//Cierro el documento
ls_texto = '</Invoice>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//actualizo el nro_rc en la tabla
update fs_factura_simpl
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_registro = :ls_nro_registro;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_fac_ubl21 (string asi_tipo_doc, string asi_nro_doc);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, ls_direccion_cliente, &
			ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, ls_und, ls_descripcion, ls_codigo, &
			ls_TaxExemptionReasonCode, ls_hora_emision, ls_PriceTypeCode
String	ls_PathFileXML, ls_observacion, ls_IdTaxScheme, ls_NameTaxScheme, ls_TaxTypeCode, &
			ls_TipoCredFiscal
Long		ll_row, ll_ult_nuevo, ll_nro_item, ll_LineCountNumeric, ll_cant_bolsas, ll_dias_vencimiento
Date		ld_fec_envio, ld_fec_emision, ld_fec_vencimiento
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf, ldc_total_op_exon, ldc_total_op_expo, ldc_LineExtensionAmount, &
			ldc_PriceAmount, ldc_percent, ldc_total_icbper, ldc_total_op_gratuitas, &
			ldc_total_extorno, ldc_icbper, ldc_total_venta, ldc_importe_neto, ldc_imp_detraccion
			
//Variables para la detraccion
String 	ls_PaymentMeansCode, ls_PaymentMeansID, ls_flag_detraccion
Decimal	ldc_PaymentPercent


//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_cntas_cobrar_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_tipo_doc, asi_nro_doc)

ll_LineCountNumeric = ids_boletas.RowCount()

if ll_LineCountNumeric = 0 then 
	MessageBox('Funcion n_cst_ventas.of_generar_xml_fac_ubl21()', 'No hay detalle para el comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc, Information!)
	return false
end if

//Importe neto del comprobante de venta
select 	importe_doc, nvl(imp_detraccion, 0), 
			oper_detr, bien_serv, nvl(porc_detraccion, 0), NVL(flag_detraccion, '0')
  into 	:ldc_importe_neto, :ldc_imp_detraccion, 
  			:ls_PaymentMeansCode, :ls_PaymentMeansID, :ldc_PaymentPercent, :ls_flag_detraccion
from cntas_Cobrar cc
where cc.tipo_doc		= :asi_tipo_doc
  and cc.nro_doc		= :asi_nro_doc;

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Importe Neto / Importe Detraccion. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Descuento Global
ldc_dscto_global = 0

//Total Operaciones Gravadas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_grav
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.precio_unitario > 0
	and ccd.tipo_cred_fiscal = '09';
	
if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Operaciones Gravadas. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if	

//Total exportaciones
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_expo
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.precio_unitario > 0
	and ccd.tipo_cred_fiscal = '08';

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Exportaciones. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if	

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_inaf
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.precio_unitario > 0
	and ccd.tipo_cred_fiscal = '10';

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Operaciones Inafectas. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if		

//Total Operaciones Exonerados
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_exon
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.precio_unitario > 0
	and ccd.tipo_cred_fiscal = '11';

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Operaciones Exoneradas. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if		

//Total Operaciones Gratuitas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0) +
		 nvl(sum((select nvl(ci.importe,0)
                 from cc_doc_det_imp  ci,
                    impuestos_tipo    it
               where ci.tipo_impuesto   = it.tipo_impuesto
                and it.flag_igv       = '1'
                and ci.tipo_doc     = ccd.tipo_doc
                and ci.nro_doc      = ccd.nro_doc
                and ci.item       = ccd.item
                and ci.tipo_impuesto not in ('ICBPER'))), 0)
  into :ldc_total_op_gratuitas
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.precio_unitario > 0
	and ccd.tipo_cred_fiscal = '12';

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Operaciones Gratuitas. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if		

//Total Operaciones Extorno
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_extorno
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.precio_unitario <= 0;

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Operaciones Extorno. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if		
	
//Impuesto IGV
select nvl(sum(ci.importe),0)
  into :ldc_total_igv
  from cc_doc_det_imp 	ci,
       impuestos_tipo  	it,
		 cntas_cobrar_det ccd
 where ccd.tipo_doc		= ci.tipo_doc
   and ccd.nro_doc		= ci.nro_doc
	and ccd.item       	= ci.item
   and ci.tipo_impuesto = it.tipo_impuesto
   and it.flag_igv      = '1'
   and ci.tipo_doc 		= :asi_tipo_doc
   and ci.nro_doc  		= :asi_nro_doc
	and ccd.tipo_cred_fiscal not in ('12')
	and ci.tipo_impuesto not in (:is_icbper);

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Impuesto IGV. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if		

//ICBPER
select nvl(sum(ci.importe),0)
  into :ldc_total_icbper
  from cc_doc_det_imp ci
 where ci.tipo_doc = :asi_tipo_doc
   and ci.nro_doc  = :asi_nro_doc
	and ci.tipo_impuesto = :is_icbper;

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de ICBPER. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if	

//Cantidad de bolsas plasticas
select count(*)
  into :ll_cant_bolsas
from VW_VTA_CNTAS_COBRAR_DET ccd
where ccd.tipo_doc = :asi_tipo_doc
  and ccd.nro_doc  = :asi_nro_doc
  and ccd.icbper 		 > 0;

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error en funcion of_generar_xml_fac_ubl21(asi_tipo_doc, asi_nro_doc). ' &
							+ '~r~nNo se ha podido obtener el Total de Bolsas Plasticas. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if	  
  
//Total del documento
ldc_total_doc 	 = round(ldc_total_op_expo + ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exon + ldc_total_igv + ldc_total_icbper + ldc_total_op_gratuitas + ldc_total_extorno,2)
ldc_total_venta = round(ldc_total_op_expo + ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exon + ldc_total_op_gratuitas + ldc_total_extorno,2)

if ldc_total_venta < 0 then ldc_total_venta = 0


//Datos del comprobante
ls_tipo_doc 			= ids_boletas.object.tipo_doc						[1]
ls_serie					= ids_boletas.object.serie							[1]
ls_nro					= ids_boletas.object.nro							[1]
ld_fec_emision 		= Date(ids_boletas.object.fec_emision			[1])
ls_hora_emision		= ids_boletas.object.hora_emision				[1]
ld_fec_vencimiento 	= Date (ids_boletas.object.fec_vencimiento 	[1])
ls_moneda				= ids_boletas.object.moneda						[1]
ls_desc_moneda			= ids_boletas.object.desc_moneda					[1]
ls_observacion			= ids_boletas.object.observacion					[1]
ll_dias_vencimiento 	= Long (ids_boletas.object.dias_vencimiento 	[1])

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Nro de Envio
ls_nro_envio_id		= ids_boletas.object.nro_envio_id	[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))
	
	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio) then return false

//Linea 2 = Datos
ls_texto = '<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" ' + char(13) + char(10) &
		 	+ '			xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
		 	+ '			xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
		 	+ '			xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" ' + char(13) + char(10) &
		 	+ '			xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
		 	+ '			xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
		 	+ '			xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
		 	+ '			xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
		 	+ '			xmlns:stat="urn:oasis:names:specification:ubl:schema:xsd:DocumentStatusCode-1.0"' + char(13) + char(10) & 
		 	+ '			xmlns:udt="urn:un:unece:uncefact:data:draft:UnqualifiedDataTypesSchemaModule:2"' + char(13) + char(10) & 
		 	+ '			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>'+ char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '						<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '      			<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
			+ '       				<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '      			</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '     				<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1003</cbc:ID>' + char(13) + char(10) &
			+ '        				<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exon + ldc_total_op_expo, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '      			</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
      	+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10)&
			+ '       				<cbc:ID>2005</cbc:ID>' + char(13) + char(10)&
			+ '       				<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10)&
			+ '     				</sac:AdditionalMonetaryTotal>' + char(13) + char(10)&
			+ '					<sac:AdditionalProperty>' + char(13) + char(10) &
			+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:Value>' + ls_total_txt + '</cbc:Value>' + char(13) + char(10) &
			+ '					</sac:AdditionalProperty>' + char(13) + char(10)

// Transferencia Gratuita			
if ldc_total_doc <= 0 then
	ls_texto += '					<sac:AdditionalProperty>' + char(13) + char(10) &
				 + '						<cbc:ID>1002</cbc:ID>' + char(13) + char(10) &
				 + '						<cbc:Value>TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO GRATUITAMENTE</cbc:Value>' + char(13) + char(10) &
				 + '					</sac:AdditionalProperty>' + char(13) + char(10)
end if

//Si es una exportación
if ldc_total_op_expo > 0 then
	ls_texto += '					<sac:SUNATTransaction>' + char(13) + char(10) &
				 + '						<cbc:ID>02</cbc:ID>' + char(13) + char(10) &
				 + '					</sac:SUNATTransaction>' + char(13) + char(10)
else				 
	//Venta Interna
	ls_texto += '					<sac:SUNATTransaction>' + char(13) + char(10) &
				 + '						<cbc:ID>01</cbc:ID>' + char(13) + char(10) &
				 + '					</sac:SUNATTransaction>' + char(13) + char(10)
end if

			
ls_texto += '				</sac:AdditionalInformation>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '		<ext:UBLExtension>' + char(13) + char(10) &
			 + '			<ext:ExtensionContent>' + char(13) + char(10) &
			 + '			</ext:ExtensionContent>' + char(13) + char(10) &
			 + '		</ext:UBLExtension>' + char(13) + char(10) &
			 + '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>2.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 8: Hora de emisión 
ls_texto = '   <cbc:IssueTime>' + ls_hora_emision + '</cbc:IssueTime>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 9: Fecha vencimiento
ls_texto = '   <cbc:DueDate>' + string(ld_fec_vencimiento, 'yyyy-mm-dd') + '</cbc:DueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 10: Tipo de Documento
//listName="SUNAT:Identificador de Tipo de Documento
if ldc_total_op_expo = 0 then
	ls_texto = '   <cbc:InvoiceTypeCode listID="0101"' + char(13) + char(10) &
				+ '								listAgencyName="PE:SUNAT"' + char(13) + char(10) &
				+ '								listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo01">' + ls_tipo_doc + '</cbc:InvoiceTypeCode>'
else
	ls_texto = '   <cbc:InvoiceTypeCode listID="0200"' + char(13) + char(10) &
				+ '								listAgencyName="PE:SUNAT"' + char(13) + char(10) &
				+ '								listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo01">' + ls_tipo_doc + '</cbc:InvoiceTypeCode>'
end if

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
if IsNull(ls_observacion) then ls_observacion = "";
ls_observacion = invo_util.of_replace(ls_observacion, '~r~n', '<br/>')
ls_observacion = invo_util.of_replace(ls_observacion, '~r', '')
ls_observacion = invo_util.of_replace(ls_observacion, '~t', ' ')
ls_observacion = invo_util.of_replace(ls_observacion, '~n', '')
ls_observacion = invo_util.of_replace(ls_observacion, 'Ú', 'U')
ls_observacion = invo_util.of_replace(ls_observacion, 'ú', 'u')
ls_observacion = invo_util.of_replace(ls_observacion, 'í', 'i')
ls_observacion = invo_util.of_replace(ls_observacion, 'Í', 'I')
ls_observacion = invo_util.of_replace(ls_observacion, '-', ' ')
ls_observacion = invo_util.of_replace(ls_observacion, '.', ' ')
ls_observacion = trim(ls_observacion)

ls_texto = "   <cbc:Note><![CDATA[" + left(ls_observacion,200) + "]]></cbc:Note>"
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Detracciones
if ldc_imp_detraccion > 0 and ls_flag_detraccion = '1' then
	ls_texto = '   <cbc:Note languageLocaleID="2006"><![CDATA[Operación sujeta a detracción]]></cbc:Note>'
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if

//Line 11: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Numero de Lineas del Documento
ls_texto = '   <cbc:LineCountNumeric>' + string(ll_LineCountNumeric) + '</cbc:LineCountNumeric>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 14: Datos del Emisor
//Valido la información del emisor
if ISNull(gnvo_app.empresa.is_ruc) or trim(gnvo_app.empresa.is_ruc) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el RUC del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_nom_empresa) or trim(gnvo_app.empresa.is_nom_empresa) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_ubigeo) or trim(gnvo_app.empresa.is_ubigeo) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el UBIGEO del emisor en registro, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_direccion) or trim(gnvo_app.empresa.is_direccion) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la direccion del emisor en registro, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_provincia) or trim(gnvo_app.empresa.is_provincia) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado la provincia del emisor, por favor verifique!', StopSign!)
	return false
end if

if ISNull(gnvo_app.empresa.is_departamento) or trim(gnvo_app.empresa.is_departamento) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el DEPARTAMENTO del emisor, por favor verifique!', StopSign!)
	return false
end if


ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
         + '				<cbc:ID schemeID="6"' + char(13) + char(10) &
         + '						  schemeAgencyName="PE:SUNAT"' + char(13) + char(10) &
         + '						  schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
      	+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
         + '				<cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
         + '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '            	<cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '					<cbc:AddressTypeCode>0000</cbc:AddressTypeCode>' + char(13) + char(10) &
			+ '					<cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '					<cbc:CountrySubentity><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '					<cbc:District><![CDATA[' + gnvo_app.empresa.is_distrito + ']]></cbc:District>' + char(13) + char(10) &
			+ '					<cac:AddressLine>' + char(13) + char(10) &
         + '						<cbc:Line><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:Line>' + char(13) + char(10) &
         + '					</cac:AddressLine>' + char(13) + char(10) &
         + '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
  			+ '				</cac:RegistrationAddress>' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Datos del Cliente
if ISNull(ls_nro_doc_cliente) or trim(ls_nro_doc_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el Nro de Documento de Identificacion del cliente en comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_tipo_doc_cliente) or trim(ls_tipo_doc_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el tipo de Documento de Identificacion del cliente en comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_nom_cliente) or trim(ls_nom_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el nombre o razon social del cliente en comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_direccion_cliente) or trim(ls_direccion_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado o esta incompleta la direccion del cliente en comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc + ', por favor verifique!', StopSign!)
	return false
end if

if ISNull(ls_pais_cliente) or trim(ls_pais_cliente) = '' then
	Rollback;
	MessageBox('Error', 'No ha especificado el pais del cliente en comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc + ', por favor verifique!', StopSign!)
	return false
end if

ls_nom_cliente 		= invo_util.of_replace( ls_nom_cliente, 'Ñ', 'N')
ls_direccion_cliente = invo_util.of_replace( ls_direccion_cliente, 'Ñ', 'N')

ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
      	+ '		<cac:Party>' + char(13) + char(10) &
         + '			<cac:PartyIdentification>' + char(13) + char(10) &
         + '				<cbc:ID schemeID="' + ls_tipo_doc_cliente + '">' + ls_nro_doc_cliente + '</cbc:ID>' + char(13) + char(10) &
         + '			</cac:PartyIdentification>' + char(13) + char(10) &
         + '			<cac:PartyLegalEntity>' + char(13) + char(10) &
         + '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName>' + char(13) + char(10) &
         + '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cac:AddressLine>' + char(13) + char(10) &
         + '         			<cbc:Line><![CDATA[' + ls_direccion_cliente + ']]></cbc:Line>' + char(13) + char(10) &
         + '					</cac:AddressLine>' + char(13) + char(10) &
         + '					<cac:Country>' + char(13) + char(10) &
         + '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
         + '					</cac:Country>' + char(13) + char(10) &
         + '				</cac:RegistrationAddress>' + char(13) + char(10) &
         + '			</cac:PartyLegalEntity>' + char(13) + char(10) &
      	+ '		</cac:Party>' + char(13) + char(10) &
   		+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15-A: Detracciones
if ldc_imp_detraccion > 0 and ls_flag_detraccion = '1' then
	ls_texto = '	<cac:PaymentMeans> ' + char(13) + char(10) &
				+ ' 		<cbc:ID>Detraccion</cbc:ID> ' + char(13) + char(10) &
				+ '		<cbc:PaymentMeansCode>' + ls_PaymentMeansCode + '</cbc:PaymentMeansCode> ' + char(13) + char(10) &
				+ '		<cac:PayeeFinancialAccount> ' + char(13) + char(10) &
				+ '		<cbc:ID>' + gnvo_app.finparam.is_cnta_cnte_detraccion + '</cbc:ID> ' + char(13) + char(10) &
				+ '		</cac:PayeeFinancialAccount> ' + char(13) + char(10) &
				+ '	</cac:PaymentMeans> ' + char(13) + char(10) &
				+ '	<cac:PaymentTerms> ' + char(13) + char(10) &
				+ '		<cbc:PaymentMeansID schemeAgencyName="PE:SUNAT" schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo54">' + ls_PaymentMeansID + '</cbc:PaymentMeansID> ' + char(13) + char(10) &
				+ '		<cbc:PaymentPercent>' + trim(string(ldc_PaymentPercent, "#0.00")) + '</cbc:PaymentPercent> ' + char(13) + char(10) &
				+ '		<cbc:Amount currencyID="PEN">' + trim(string(ldc_imp_detraccion, "#####0.00")) + '</cbc:Amount> ' + char(13) + char(10) &
				+ '	</cac:PaymentTerms>' + char(13) + char(10)

	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if

//Line 15-B: Forma de Pago
if ll_dias_vencimiento <= 0 then
	ls_texto = '	<cac:PaymentTerms>' + char(13) + char(10) &
				+ '		<cbc:ID>FormaPago</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:PaymentMeansID>Contado</cbc:PaymentMeansID>' + char(13) + char(10) &
				+ '	</cac:PaymentTerms>'
else
	// Si es credito entonces se añade la unica cuota
	
	ls_texto = '	<cac:PaymentTerms>' + char(13) + char(10) &
				+ '		<cbc:ID>FormaPago</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:PaymentMeansID>Credito</cbc:PaymentMeansID>' + char(13) + char(10) &
				+ '		<cbc:Amount currencyID="' + ls_moneda + '">' + trim(string(ldc_importe_neto, '#####0.00')) + '</cbc:Amount>' + char(13) + char(10) &
				+ '	</cac:PaymentTerms>' + char(13) + char(10) &
				+ '	<cac:PaymentTerms>' + char(13) + char(10) &
				+ '		<cbc:ID>FormaPago</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:PaymentMeansID>Cuota001</cbc:PaymentMeansID>' + char(13) + char(10) &
				+ '		<cbc:Amount currencyID="' + ls_moneda + '">' + trim(string(ldc_importe_neto, '#####0.00')) + '</cbc:Amount>' + char(13) + char(10) &
				+ '		<cbc:PaymentDueDate>' + string(ld_fec_vencimiento, 'yyyy-mm-dd') + '</cbc:PaymentDueDate>' + char(13) + char(10) &
				+ '	</cac:PaymentTerms>'
	
end if				
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)


//Line 16: Total de Impuestos
if ldc_total_op_gratuitas > 0 then
	ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cbc:TaxAmount currencyID="' + ls_moneda + '">0.00</cbc:TaxAmount>' + char(13) + char(10)
else
	ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10)
end if			

if ldc_total_op_grav > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">S</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">1000</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_inaf > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">O</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9998</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>INA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_exon > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exon, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">E</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9997</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXO</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_expo > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_expo, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9995</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXP</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_gratuitas > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_gratuitas, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID>Z</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9996</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>GRA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_icbper > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_icbper, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">7152</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if
			
ls_texto += '	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 17: Resumen total del documento
//<cbc:TaxtInclusiveAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:TaxtInclusiveAmount>'
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_venta, '#####0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
			+ '		<cbc:TaxInclusiveAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:TaxInclusiveAmount>' + char(13) + char(10) &
			+ '  		<cbc:AllowanceTotalAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_dscto_global, '#####0.00')) + '</cbc:AllowanceTotalAmount>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro		[ll_row]
	ls_und				= ids_boletas.object.und					[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion			[ll_row]
	ls_codigo			= ids_boletas.object.cod_art				[ll_row]
	ls_TipoCredFiscal	= ids_boletas.object.tipo_cred_fiscal	[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	ldc_icbper		 	= Dec(ids_boletas.object.icbper		 	[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	
	If IsNull(ls_descripcion) OR TRIM(ls_descripcion) = '' then 
		ROLLBACK;
		MessageBox('Error ', 'Una linea del detalle de la factura. ' + ls_serie + '-'  &
							+ gnvo_app.of_left_trim(ls_nro, '0') + '. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~t', ' ')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'Ú', 'U')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'ú', 'u')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'í', 'i')
	ls_descripcion = invo_util.of_replace(ls_descripcion, 'Í', 'I')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '-', ' ')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '.', ' ')

	ls_descripcion = left(trim(ls_descripcion), 200)


	//Calculo el precio de venta
	ldc_LineExtensionAmount = (ldc_precio_unit - ldc_descuento) * ldc_cantidad
	ldc_precio_vta				= (ldc_LineExtensionAmount + ldc_igv) / ldc_cantidad
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0
	
	/*
		9	08	EXPORTACIONES	1	1	8 	3	C	40
		10	09	VENTAS NACIONALES GRAVADAS	1	1	1 	3	C	10
		11	10	VENTAS NACIONALES INAFECTAS	0	1	4 	3	C	30
		8	11	VENTAS NACIONALES EXONERADAS	1	1	4 	3	C	20
		11	VENTAS NO ONEROSAS	1	1	4 	3	C	20
	*/
	
	ldc_Percent = 18
	ls_PriceTypeCode = '01'
	
	if ls_TipoCredFiscal = '08' then
		
		ls_TaxExemptionReasonCode = '40'
		
		ls_IdTaxScheme = '9995'
		ls_NameTaxScheme = 'EXP'
		ls_TaxTypeCode = 'FRE'
		
	else
		
		if ls_TipoCredFiscal = '09' then
			
			ls_TaxExemptionReasonCode= '10'
			ls_IdTaxScheme = '1000'
			ls_NameTaxScheme = 'IGV'
			ls_TaxTypeCode = 'VAT'
			
		elseif ls_TipoCredFiscal = '10' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '30'
			ls_IdTaxScheme = '9998'
			ls_NameTaxScheme = 'INA'
			ls_TaxTypeCode = 'FRE'
			
		elseif ls_TipoCredFiscal = '11' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '20'
			ls_IdTaxScheme = '9997'
			ls_NameTaxScheme = 'EXO'
			ls_TaxTypeCode = 'VAT'
		
		elseif ls_TipoCredFiscal = '12' then
		
			//Gratuito
			//if ldc_igv = 0 then
			//	ls_TaxExemptionReasonCode= '20'
			//else
			//	ls_TaxExemptionReasonCode= '11'
			//end if
			ls_TaxExemptionReasonCode= '21'
			ls_IdTaxScheme = '9996'
			ls_NameTaxScheme = 'GRA'
			ls_TaxTypeCode = 'FRE'
			ls_PriceTypeCode = '02'
			
			ldc_LineExtensionAmount = 0.00
			ldc_precio_unit = ldc_precio_vta
			ldc_igv = 0
			
		end if
		
	end if
	
	ls_texto = '	<cac:InvoiceLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:InvoicedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:InvoicedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_LineExtensionAmount, '######0.00')) + '</cbc:LineExtensionAmount>'
	
	if ls_tipoCredFiscal = '12' then
		ls_texto += '		<cbc:FreeOfChargeIndicator>true</cbc:FreeOfChargeIndicator>' + char(13) + char(10)
	end if
	
	ls_texto += '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>' + ls_PriceTypeCode + '</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)


	
	
	ls_texto += '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:Percent>' + trim(string(ldc_Percent, '######0.0')) + '</cbc:Percent> ' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cac:TaxScheme> ' + char(13) + char(10)&
				+ '						<cbc:ID>' + ls_IdTaxScheme + '</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>' + ls_NameTaxScheme + '</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>' + ls_TaxTypeCode + '</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10)

	if ldc_icbper > 0 then
		ls_texto +='			<cac:TaxSubtotal>' + char(13) + char(10) &
            	+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper * ll_cant_bolsas, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
            	+ '				<cbc:BaseUnitMeasure unitCode="NIU">' + trim(string(ll_cant_bolsas, '######0')) + '</cbc:BaseUnitMeasure>' + char(13) + char(10) &
            	+ '				<cac:TaxCategory>' + char(13) + char(10) &
					+ '					<cbc:PerUnitAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper, '######0.00')) + '</cbc:PerUnitAmount>' + char(13) + char(10) &
               + '					<cac:TaxScheme>' + char(13) + char(10) &
               + '						<cbc:ID>7152</cbc:ID>' + char(13) + char(10) &
               + '						<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
               + '						<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
               + '					</cac:TaxScheme>' + char(13) + char(10) &
            	+ '				</cac:TaxCategory>' + char(13) + char(10) &
         		+ '			</cac:TaxSubtotal>' + char(13) + char(10) &

	end if
	
	ls_texto += '		</cac:TaxTotal>' + char(13) + char(10) &
				 + '		<cac:Item>' + char(13) + char(10) &
				 + '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				 + '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				 + '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '		</cac:Item>' + char(13) + char(10)
				
	if ls_tipoCredFiscal = '12' then
		ls_texto += '		<cac:Price>' + char(13) + char(10) &
					 + '			<cbc:PriceAmount currencyID="' + ls_moneda + '">0.00</cbc:PriceAmount>' + char(13) + char(10) &
					 + '		</cac:Price>' + char(13) + char(10)
	else
		ls_texto += '		<cac:Price>' + char(13) + char(10) &
					 + '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit, '######0.00000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
					 + '		</cac:Price>' + char(13) + char(10)
	end if
	
	ls_texto += '	</cac:InvoiceLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update cntas_cobrar
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where tipo_doc = :asi_tipo_doc
   and nro_doc	 = :asi_nro_doc;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :invo_xml.is_file_xml
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Cierro el documento
ls_texto = '</Invoice>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ncc_ubl21 (string as_nro_registro);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo, ls_AddressTypeCode
String	ls_PathFileXML, ls_observacion, ls_hora_emision
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf, ldc_total_op_exon, ldc_total_icbper

try
	
	ls_AddressTypeCode = gnvo_app.of_get_parametro('EFACT_AddressTypeCode','0001')
	
catch(Exception ex)

	MessageBox('Error', 'HA ocurrido una exception al procesar el parametro ' &
							+ 'EFACT_AddressTypeCode. Mensaje: ' + ex.getMessage(), StopSign!)
							
end try

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_fs_factura_smpl_det_ncc_ndc_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(as_nro_registro)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_fs_ncc', 'No hay detalle para el comprobante de pago con numero de registro ' + as_nro_registro, Information!)
	return false
end if

//Descuento Global
select round(nvl(sum(fd.cant_proyect * abs(fd.precio_unit - fd.descuento)),0),2)
  into :ldc_dscto_global
from fs_factura_simpl_det fd
where (fd.precio_unit < 0 or fd.descuento > 0)
  and fd.nro_registro = :as_nro_registro;
  
//Total del documento
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv)),0),2)
  into :ldc_total_doc
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Total Operaciones Gravadas
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento)),0),2)
  into :ldc_total_op_grav
from fs_factura_simpl_det fd
where fd.importe_igv > 0
  and fd.nro_registro = :as_nro_registro;

//Impuesto IGV
select round(nvl(sum(fd.cant_proyect * (fd.importe_igv)),0),2)
  into :ldc_total_igv
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Operaciones inafectas
ldc_total_op_inaf = 0

//Operaciones exoneradas
ldc_total_op_exon = 0


//Datos del comprobante
ls_tipo_doc 		= ids_boletas.object.tipo_doc					[1]
ls_serie				= ids_boletas.object.serie						[1]
ls_nro				= ids_boletas.object.nro						[1]
ls_moneda			= ids_boletas.object.moneda					[1]
ls_desc_moneda		= ids_boletas.object.desc_moneda				[1]
ls_observacion		= ids_boletas.object.observacion				[1]
ls_hora_emision 	= ids_boletas.object.hora_emision			[1]
ld_fec_emision 	= Date(ids_boletas.object.fec_emision		[1])

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nc				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Nro Envio Id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" ' + char(13) + char(10) &
         + '				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10) &
         + '				xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"' + char(13) + char(10) &
         + '				xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
         + '				xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
         + '				xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
         + '				xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
         + '				xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
         + '				xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
         + '				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'

			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '    		<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + string(ldc_total_op_grav, '#####0.00') + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>2.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '	<cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '	<cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 8: Hora de emisión 
ls_texto = '	<cbc:IssueTime>' + ls_hora_emision + '</cbc:IssueTime>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Leyenda, codigo interno generado por el mismo software
//ls_texto = '	<cbc:Note languageLocaleID="3000">' + as_nro_registro + '</cbc:Note>'
//invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Moneda
ls_texto = '	<cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + gnvo_app.utilitario.of_replace(ls_desc_motivo, 'Ó', 'O') + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 15: Datos del Emisor
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
        	+ '				<cbc:ID schemeID="6"' + char(13) + char(10) &
			+ '						  schemeName="SUNAT:Identificador de Documento de Identidad"' + char(13) + char(10) &
			+ '						  schemeAgencyName="PE:SUNAT"' + char(13) + char(10) &
			+ ' 						  schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
      	+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cbc:AddressTypeCode>' + ls_AddressTypeCode + '</cbc:AddressTypeCode>' + char(13) + char(10) &
         + '				</cac:RegistrationAddress>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 16: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
        	+ '				<cbc:ID 	schemeID="' + ls_tipo_doc_cliente + '"' + char(13) + char(10) & 
			+ '							schemeName="SUNAT:Identificador de Documento de Identidad"' + char(13) + char(10) & 
			+ '							schemeAgencyName="PE:SUNAT"' + char(13) + char(10) & 
			+ '							schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + ls_nro_doc_cliente + '</cbc:ID>' + char(13) + char(10) & 
      	+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 17: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID schemeID="UN/ECE 5153" schemeAgencyID="6">1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 18: Resumen total del documento
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro	[ll_row]
	ls_und				= ids_boletas.object.und				[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion		[ll_row]
	ls_codigo			= ids_boletas.object.cod_art			[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)

	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:CreditNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:CreditedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:CreditedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_vta, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * (ldc_precio_unit - ldc_descuento), '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:Percent>18.0</cbc:Percent>' + char(13) + char(10) &				
				+ '					<cbc:TaxExemptionReasonCode>10</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit - ldc_descuento, '######0.000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:CreditNoteLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update fs_factura_simpl
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_registro = :ls_nro_registro;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Cierro el documento
ls_texto = '</CreditNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ncc_ubl21 (string asi_tipo_doc, string asi_nro_doc);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo, ls_TaxExemptionReasonCode
			
String 	ls_PathFileXML, ls_observacion, ls_hora_emision, ls_TipoCredFiscal, ls_idTaxScheme, &
			ls_nameTaxScheme, ls_taxTypeCode, ls_priceTypeCode
			
Long		ll_row, ll_ult_nuevo, ll_nro_item, ll_cant_bolsas

Date		ld_fec_envio, ld_fec_emision

//Totales
Decimal	ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible
			
Decimal	ldc_total_op_grav, ldc_total_op_inaf, ldc_total_op_exo, ldc_total_op_expo, &
			ldc_icbper, ldc_total_icbper, ldc_total_op_gratuitas, ldc_LineExtensionAmount, &
			ldc_Percent

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_cxc_ncc_ndc_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_tipo_doc, asi_nro_doc)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_cxc_ncc_ndc', 'No hay detalle para el comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc, Information!)
	return false
end if



/*
	08	EXPORTACIONES	1	1	8 	3	C	40
	09	VENTAS NACIONALES GRAVADAS	1	1	1 	3	C	10
	10	VENTAS NACIONALES INAFECTAS	1	1	4 	3	C	30
	11	VENTAS NACIONALES EXONERADAS	1	1	4 	3	C	20
*/

//Total Operaciones Exportacion
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_expo
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '08';
	
//Total Operaciones Gravadas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_grav
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '09';

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_inaf
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '10';

//Total Operaciones Exoneradas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_exo
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal ='11';

//Total Operaciones Gratuitas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_gratuitas
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '12';
	
//Descuento Global
select abs(nvl(sum(ccd.cantidad * ccd.precio_unitario),0))
  into :ldc_dscto_global
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.cantidad * ccd.precio_unitario < 0;

	
//Impuesto IGV
select nvl(sum(ci.importe),0)
  into :ldc_total_igv
  from cc_doc_det_imp 	ci,
  		 impuestos_tipo	it
 where ci.tipo_impuesto = it.tipo_impuesto
   and it.flag_igv		= '1'
   and ci.tipo_doc 		= :asi_tipo_doc
   and ci.nro_doc  		= :asi_nro_doc
	and ci.tipo_impuesto <> :is_icbper;

//ICBPER
select nvl(sum(ci.importe),0)
  into :ldc_total_icbper
  from cc_doc_det_imp ci
 where ci.tipo_doc = :asi_tipo_doc
   and ci.nro_doc  = :asi_nro_doc
	and ci.tipo_impuesto = :is_icbper;

//Cantidad de bolsas plasticas
select count(*)
  into :ll_cant_bolsas
from VW_VTA_CNTAS_COBRAR_DET ccd
where ccd.tipo_doc = :asi_tipo_doc
  and ccd.nro_doc  = :asi_nro_doc
  and ccd.icbper 		 > 0;

//Total del documento
ldc_total_doc = round(ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exo + ldc_total_op_expo + ldc_total_igv - ldc_dscto_global,2)

//Datos del comprobante
ls_tipo_doc 		= ids_boletas.object.tipo_doc				[1]
ls_serie				= ids_boletas.object.serie					[1]
ls_nro				= ids_boletas.object.nro					[1]
ld_fec_emision 	= Date(ids_boletas.object.fec_emision	[1])
ls_hora_emision 	= ids_boletas.object.hora_emision		[1]
ls_moneda			= ids_boletas.object.moneda				[1]
ls_desc_moneda		= ids_boletas.object.desc_moneda			[1]
ls_observacion		= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nc				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Obtengo el nro_envio_id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

//Obtengo el total en letras
ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_Envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio		[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"' + char(13) + char(10) &
         + '				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10) &
         + '				xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"' + char(13) + char(10) &
         + '				xmlns:ccts="urn:un:unece:uncefact:documentation:2"' + char(13) + char(10) &
         + '				xmlns:ds="http://www.w3.org/2000/09/xmldsig#"' + char(13) + char(10) &
         + '				xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"' + char(13) + char(10) &
         + '				xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"' + char(13) + char(10) &
         + '				xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"' + char(13) + char(10) &
         + '				xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"' + char(13) + char(10) &
         + '				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>'+ char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalProperty>' + char(13) + char(10) &
			+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:Value>' + ls_total_txt + '</cbc:Value>' + char(13) + char(10) &
			+ '					</sac:AdditionalProperty>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>2.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 8: Hora de emisión 
ls_texto = '   <cbc:IssueTime>' + ls_hora_emision + '</cbc:IssueTime>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 9: Total en Letras
ls_texto = '   <cbc:Note languageLocaleID="1000">' + ls_total_txt + '</cbc:Note>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Nro de Lineas
ls_texto = '   <cbc:LineCountNumeric>' + string(ids_boletas.RowCount()) + '</cbc:LineCountNumeric>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Tipo Nota de Credito
if Isnull(ls_serie_ref) or trim(ls_serie_ref) = '' then
	rollbacK;
	MessageBox('Error', 'El comprobante ' + asi_tipo_doc + '/' + asi_nro_doc + ', no tiene serie de Documento de referencia, por favor verifique!', StopSign!)
	return false
end if

if Isnull(ls_nro_ref) or trim(ls_nro_ref) = '' then
	rollbacK;
	MessageBox('Error', 'El comprobante ' + asi_tipo_doc + '/' + asi_nro_doc + ', no tiene Numero de Documento de referencia, por favor verifique!', StopSign!)
	return false
end if

if Isnull(ls_tipo_nota) or trim(ls_tipo_nota) = '' then
	rollbacK;
	MessageBox('Error', 'El comprobante ' + asi_tipo_doc + '/' + asi_nro_doc + ', no tiene tipo de Nota, por favor verifique!', StopSign!)
	return false
end if

if Isnull(ls_desc_motivo) or trim(ls_desc_motivo) = '' then
	rollbacK;
	MessageBox('Error', 'El comprobante ' + asi_tipo_doc + '/' + asi_nro_doc + ', no tiene Descripcion Motivo, revisar el Motivo de VOTA, por favor verifique!', StopSign!)
	return false
end if

ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 15: Datos del Emisor
ls_texto = '	<cac:AccountingSupplierParty>' + char(13) + char(10) &
    		+ '		<cac:Party>' + char(13) + char(10) &
      	+ '			<cac:PartyIdentification>' + char(13) + char(10) &
        	+ '				<cbc:ID 	schemeID="6"' + char(13) + char(10) &
			+ '						  	schemeName="SUNAT:Identificador de Documento de Identidad" ' + char(13) + char(10) &
			+ '						  	schemeAgencyName="PE:SUNAT"' + char(13) + char(10) &
			+ '							schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
      	+ '			</cac:PartyIdentification>' + char(13) + char(10) &
      	+ '			<cac:PartyName>' + char(13) + char(10) &
        	+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
      	+ '			</cac:PartyName>' + char(13) + char(10) &
      	+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
        	+ '				<cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
        	+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cbc:AddressTypeCode>0000</cbc:AddressTypeCode>' + char(13) + char(10) &
        	+ '				</cac:RegistrationAddress>' + char(13) + char(10) &
      	+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
    		+ '		</cac:Party>' + char(13) + char(10) &
  			+ '	</cac:AccountingSupplierParty>'

			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

if IsNull(ls_tipo_doc_cliente) or trim(ls_tipo_doc_cliente) = '' then
	rollbacK;
	MessageBox('Error', 'El Cliente no tiene tipo de Doc Verifique', StopSign!)
	return false
end if

if IsNull(ls_nom_cliente) or trim(ls_nom_cliente) = '' then
	rollbacK;
	MessageBox('Error', 'El Cliente no tiene Nombre, por favor verifique', StopSign!)
	return false
end if

if IsNull(ls_direccion_cliente) or trim(ls_direccion_cliente) = '' then
	rollbacK;
	MessageBox('Error', 'El Cliente no tiene DIRECCION, por favor verifique', StopSign!)
	return false
end if

if IsNull(ls_pais_cliente) or trim(ls_pais_cliente) = '' then
	rollbacK;
	MessageBox('Error', 'El Cliente no tiene PAIS, por favor verifique', StopSign!)
	return false
end if

//Line 16: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
      	+ '		<cac:Party>' + char(13) + char(10) &
         + '			<cac:PartyIdentification>' + char(13) + char(10) &
         + '				<cbc:ID schemeID="' + ls_tipo_doc_cliente + '">' + ls_nro_doc_cliente + '</cbc:ID>' + char(13) + char(10) &
         + '			</cac:PartyIdentification>' + char(13) + char(10) &
         + '			<cac:PartyLegalEntity>' + char(13) + char(10) &
         + '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName>' + char(13) + char(10) &
         + '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cac:AddressLine>' + char(13) + char(10) &
         + '         			<cbc:Line><![CDATA[' + ls_direccion_cliente + ']]></cbc:Line>' + char(13) + char(10) &
         + '					</cac:AddressLine>' + char(13) + char(10) &
         + '					<cac:Country>' + char(13) + char(10) &
         + '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
         + '					</cac:Country>' + char(13) + char(10) &
         + '				</cac:RegistrationAddress>' + char(13) + char(10) &
         + '			</cac:PartyLegalEntity>' + char(13) + char(10) &
      	+ '		</cac:Party>' + char(13) + char(10) &
   		+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 17: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10)

if ldc_total_op_grav > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">S</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">1000</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_inaf > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">O</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9998</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>INA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_exo > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exo, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">E</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9997</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXO</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_expo > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_expo, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9995</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXP</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_gratuitas > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_gratuitas, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9996</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>GRA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_icbper > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_icbper, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">7152</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if
			
ls_texto += '	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 18: Resumen total del documento
ls_texto = '	<cac:LegalMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:LegalMonetaryTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro		= ids_boletas.object.nro_registro		[ll_row]
	ls_und					= ids_boletas.object.und					[ll_row]
	ls_descripcion			= ids_boletas.object.descripcion			[ll_row]
	ls_codigo				= ids_boletas.object.cod_art				[ll_row]
	ls_TipoCredFiscal 	= ids_boletas.object.tipo_cred_fiscal	[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	ldc_icbper		 	= Dec(ids_boletas.object.icbper		 	[ll_row])

	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	//Calculo el precio de venta
	ldc_LineExtensionAmount = (ldc_precio_unit - ldc_descuento) * ldc_cantidad
	ldc_precio_vta				= (ldc_LineExtensionAmount + ldc_igv) / ldc_Cantidad
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0
	
	ldc_Percent = 18
	ls_PriceTypeCode = '01'
	
	if ls_TipoCredFiscal = '08' then
		
		ls_TaxExemptionReasonCode = '40'
		
		ls_IdTaxScheme = '9995'
		ls_NameTaxScheme = 'EXP'
		ls_TaxTypeCode = 'FRE'
		
	else
		
		if ls_TipoCredFiscal = '09' then
			
			ls_TaxExemptionReasonCode= '10'
			ls_IdTaxScheme = '1000'
			ls_NameTaxScheme = 'IGV'
			ls_TaxTypeCode = 'VAT'
			
		elseif ls_TipoCredFiscal = '10' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '30'
			ls_IdTaxScheme = '9998'
			ls_NameTaxScheme = 'INA'
			ls_TaxTypeCode = 'FRE'
			
		elseif ls_TipoCredFiscal = '11' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '20'
			ls_IdTaxScheme = '9997'
			ls_NameTaxScheme = 'EXO'
			ls_TaxTypeCode = 'VAT'
		
		elseif ls_TipoCredFiscal = '12' then
		
			//Gratuito
			if ldc_igv = 0 then
				ls_TaxExemptionReasonCode= '20'
			else
				ls_TaxExemptionReasonCode= '11'
			end if
			ls_IdTaxScheme = '9996'
			ls_NameTaxScheme = 'GRA'
			ls_TaxTypeCode = 'FRE'
			ls_PriceTypeCode = '02'
			
			ldc_LineExtensionAmount = 0.00
			
		end if
		
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)


	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:CreditNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:CreditedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:CreditedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_LineExtensionAmount, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>' + ls_PriceTypeCode + '</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10)
	
	//Impuestos
	ls_texto += '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:Percent>' + trim(string(ldc_Percent, '######0.0')) + '</cbc:Percent> ' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cac:TaxScheme> ' + char(13) + char(10)&
				+ '						<cbc:ID>' + ls_IdTaxScheme + '</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>' + ls_NameTaxScheme + '</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>' + ls_TaxTypeCode + '</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10)
			
	if ldc_icbper > 0 then
		ls_texto +='			<cac:TaxSubtotal>' + char(13) + char(10) &
            	+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper * ll_cant_bolsas, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
            	+ '				<cbc:BaseUnitMeasure unitCode="NIU">' + trim(string(ll_cant_bolsas, '######0')) + '</cbc:BaseUnitMeasure>' + char(13) + char(10) &
            	+ '				<cac:TaxCategory>' + char(13) + char(10) &
					+ '					<cbc:PerUnitAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper, '######0.00')) + '</cbc:PerUnitAmount>' + char(13) + char(10) &
               + '					<cac:TaxScheme>' + char(13) + char(10) &
               + '						<cbc:ID>7152</cbc:ID>' + char(13) + char(10) &
               + '						<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
               + '						<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
               + '					</cac:TaxScheme>' + char(13) + char(10) &
            	+ '				</cac:TaxCategory>' + char(13) + char(10) &
         		+ '			</cac:TaxSubtotal>' + char(13) + char(10) 

	end if	
	
	ls_texto += '		</cac:TaxTotal>' + char(13) + char(10) &
				 + '		<cac:Item>' + char(13) + char(10) &
				 + '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				 + '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				 + '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '		</cac:Item>' + char(13) + char(10)
				
	if ls_tipoCredFiscal = '12' then
		ls_texto += '		<cac:Price>' + char(13) + char(10) &
					 + '			<cbc:PriceAmount currencyID="' + ls_moneda + '">0.00</cbc:PriceAmount>' + char(13) + char(10) &
					 + '		</cac:Price>' + char(13) + char(10)
	else
		ls_texto += '		<cac:Price>' + char(13) + char(10) &
					 + '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit, '######0.000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
					 + '		</cac:Price>' + char(13) + char(10)
	end if
	
	ls_texto += '	</cac:CreditNoteLine>'
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//Cierro el documento
ls_texto = '</CreditNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//actualizo el nro_rc en la tabla
update cntas_cobrar
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where tipo_doc = :asi_tipo_doc
   and nro_doc	 = :asi_nro_doc;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR - Funcion of_generar_xml_ncc_ubl21. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ndc_ubl21 (string as_nro_registro);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo
String	ls_PathFileXML, ls_observacion
Long		ll_row, ll_ult_nuevo, ll_nro_item
Date		ld_fec_envio, ld_fec_emision
Decimal	ldc_total_op_grav, ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible, &
			ldc_total_op_inaf, ldc_total_op_exon

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_fs_factura_smpl_det_ncc_ndc_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(as_nro_registro)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_fs_ndc', 'No hay detalle para el comprobante de pago con numero de registro ' + as_nro_registro, Information!)
	return false
end if

//Descuento Global
select round(nvl(sum(fd.cant_proyect * abs(fd.precio_unit - fd.descuento)),0),2)
  into :ldc_dscto_global
from fs_factura_simpl_det fd
where (fd.precio_unit < 0 or fd.descuento > 0)
  and fd.nro_registro = :as_nro_registro;
  
//Total del documento
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv)),0),2)
  into :ldc_total_doc
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Total Operaciones Gravadas
select round(nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento)),0),2)
  into :ldc_total_op_grav
from fs_factura_simpl_det fd
where fd.importe_igv > 0
  and fd.nro_registro = :as_nro_registro;

//Impuesto IGV
select round(nvl(sum(fd.cant_proyect * (fd.importe_igv)),0),2)
  into :ldc_total_igv
from fs_factura_simpl_det fd
where fd.nro_registro = :as_nro_registro;

//Operaciones inafectas
ldc_total_op_inaf = 0

//Operaciones exoneradas
ldc_total_op_exon = 0


//Datos del comprobante
ls_tipo_doc 	= ids_boletas.object.tipo_doc				[1]
ls_serie			= ids_boletas.object.serie					[1]
ls_nro			= ids_boletas.object.nro					[1]
ld_fec_emision = Date(ids_boletas.object.fec_emision	[1])
ls_moneda		= ids_boletas.object.moneda				[1]
ls_desc_moneda	= ids_boletas.object.desc_moneda			[1]
ls_observacion	= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nd				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Nro Envio Id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio	[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if

/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<DebitNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2" ' + char(13) + char(10) &
			+ '  				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:ccts="urn:un:unece:uncefact:documentation:2" ' + char(13) + char(10) &
			+ '			 	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '			 	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '			 	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '			 	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1" ' + char(13) + char(10) &
			+ '			 	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' + char(13) + char(10) &
			+ '			 	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '    		<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '       				<cbc:ID>1001</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:PayableAmount currencyID="' + ls_moneda + '">' + string(ldc_total_op_grav, '#####0.00') + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ '					</sac:AdditionalMonetaryTotal>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.0</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>1.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 8: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Leyenda 01: Leyenda observaciones
/*
if Not IsNull(ls_observacion) and trim(ls_observacion) <> "" then
	ls_texto = "   <cbc:Note><![CDATA[" + ls_observacion + "]]></cbc:Note>"
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
end if
*/
//Line 9: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 12: Datos del Emisor
ls_texto = '   <cac:AccountingSupplierParty>' + char(13) + char(10) &
			+ '      <cbc:CustomerAssignedAccountID>' + gnvo_app.empresa.is_ruc + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '      <cbc:AdditionalAccountID>6</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ ' 	   <cac:Party>' + char(13) + char(10) &
			+ '         <cac:PartyName>' + char(13) + char(10) &
			+ '            <cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '         </cac:PartyName>' + char(13) + char(10) &
			+ '         <cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cbc:ID>' + gnvo_app.empresa.is_ubigeo + '</cbc:ID>' + char(13) + char(10) &
			+ '    		   <cbc:StreetName><![CDATA[' + gnvo_app.empresa.is_direccion + ']]></cbc:StreetName>' + char(13) + char(10) &
			+ '    		   <cbc:CitySubdivisionName><![CDATA[]]></cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '    	  	   <cbc:CityName><![CDATA[' + gnvo_app.empresa.is_provincia + ']]></cbc:CityName>' + char(13) + char(10) &
			+ '    		   <cbc:CountrySubentity><![CDATA[]]></cbc:CountrySubentity>' + char(13) + char(10) &
			+ '    		   <cbc:District><![CDATA[' + gnvo_app.empresa.is_departamento + ']]></cbc:District>' + char(13) + char(10) &
			+ '    		   <cac:Country>' + char(13) + char(10) &
			+ '       	      <cbc:IdentificationCode>PE</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '    		   </cac:Country>' + char(13) + char(10) &
			+ '    	   </cac:PostalAddress>' + char(13) + char(10) &
  			+ '		   <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '   	      <cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '  	 	   </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ ' 	   </cac:Party>' + char(13) + char(10) &
			+ '   </cac:AccountingSupplierParty>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
			+ '		<cbc:CustomerAssignedAccountID>' + ls_nro_doc_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '		<cbc:AdditionalAccountID>' + ls_tipo_doc_cliente + '</cbc:AdditionalAccountID>' + char(13) + char(10) &
			+ '		<cac:Party>' + char(13) + char(10) &
			+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName> ' + char(13) + char(10) &
			+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
			+ '					<cbc:StreetName>' + ls_direccion_cliente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '					<cac:Country>' + char(13) + char(10) &
			+ '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '					</cac:Country>' + char(13) + char(10) &
			+ '				</cac:RegistrationAddress> ' + char(13) + char(10) &
			+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '		</cac:Party>' + char(13) + char(10) &
			+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '  		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '  		<cac:TaxSubtotal>' + char(13) + char(10) &
			+ '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
			+ '   		<cac:TaxCategory>' + char(13) + char(10) &
			+ '    			<cac:TaxScheme>' + char(13) + char(10) &
			+ '     				<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '     				<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
			+ '     				<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
			+ '    			</cac:TaxScheme>' + char(13) + char(10) &
			+ '   		</cac:TaxCategory>' + char(13) + char(10) &
			+ '  		</cac:TaxSubtotal>' + char(13) + char(10) &
			+ ' 	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 15: Resumen total del documento
ls_texto = '	<cac:RequestedMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:RequestedMonetaryTotal>'
	
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro	= ids_boletas.object.nro_registro	[ll_row]
	ls_und				= ids_boletas.object.und				[ll_row]
	ls_descripcion		= ids_boletas.object.descripcion		[ll_row]
	ls_codigo			= ids_boletas.object.cod_art			[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)

	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:DebitNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:DebitedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:DebitedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>01</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10) &
				+ '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * (ldc_precio_unit - ldc_descuento), '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cbc:Percent>18.0</cbc:Percent>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:ID>VAT</cbc:ID>' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>10</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cbc:TierRange>00</cbc:TierRange>' + char(13) + char(10) &
				+ '					<cac:TaxScheme>' + char(13) + char(10) &
				+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10) &
				+ '		</cac:TaxTotal>' + char(13) + char(10) &
				+ '		<cac:Item>' + char(13) + char(10) &
				+ '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				+ '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				+ '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				+ '		</cac:Item>' + char(13) + char(10) &
				+ '		<cac:Price>' + char(13) + char(10) &
				+ '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit - ldc_descuento, '######0.000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '		</cac:Price>' + char(13) + char(10) &
				+ '	</cac:DebitNoteLine>'
			
				
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//actualizo el nro_rc en la tabla
update fs_factura_simpl
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_registro = :ls_nro_registro;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en fs_factura_simpl. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Cierro el documento
ls_texto = '</DebitNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_generar_xml_ndc_ubl21 (string asi_tipo_doc, string asi_nro_doc);String 	ls_texto, ls_filename_xml, ls_tipo_doc, ls_serie, ls_nro, ls_moneda, ls_nro_envio_id, &
			ls_mensaje, ls_nro_registro, ls_total_txt, ls_desc_moneda, ls_nom_cliente, &
			ls_direccion_cliente, ls_nro_doc_cliente, ls_tipo_doc_cliente, ls_pais_cliente, &
			ls_und, ls_descripcion, ls_codigo, ls_serie_ref, ls_nro_ref, ls_tipo_doc_ref, &
			ls_tipo_nota, ls_desc_motivo, ls_TaxExemptionReasonCode
			
String 	ls_PathFileXML, ls_observacion, ls_hora_emision, ls_TipoCredFiscal, ls_idTaxScheme, &
			ls_nameTaxScheme, ls_taxTypeCode, ls_priceTypeCode
			
Long		ll_row, ll_ult_nuevo, ll_nro_item, ll_cant_bolsas

Date		ld_fec_envio, ld_fec_emision

//Totales
Decimal	ldc_total_doc, ldc_total_igv, ldc_cantidad, ldc_precio_unit, &
			ldc_igv, ldc_descuento, ldc_precio_vta, ldc_dscto_global, ldc_base_imponible
			
Decimal	ldc_total_op_grav, ldc_total_op_inaf, ldc_total_op_exo, ldc_total_op_expo, &
			ldc_icbper, ldc_total_icbper, ldc_total_op_gratuitas, ldc_LineExtensionAmount, &
			ldc_Percent

//Configuro el dataStore para el resumen diario
ids_boletas.dataobject = 'd_cxc_ncc_ndc_det_tbl'
ids_boletas.setTransObject( SQLCA )
ids_boletas.REtrieve(asi_tipo_doc, asi_nro_doc)

if ids_boletas.RowCount() = 0 then 
	MessageBox('Funcion of_generar_xml_cxc_ncc_ndc', 'No hay detalle para el comprobante de pago ' + asi_tipo_doc + '/' + asi_nro_doc, Information!)
	return false
end if

//Descuento Global
ldc_dscto_global = 0

/*
	08	EXPORTACIONES	1	1	8 	3	C	40
	09	VENTAS NACIONALES GRAVADAS	1	1	1 	3	C	10
	10	VENTAS NACIONALES INAFECTAS	1	1	4 	3	C	30
	11	VENTAS NACIONALES EXONERADAS	1	1	4 	3	C	20
*/

//Total Operaciones Exportacion
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_expo
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '08';
	
//Total Operaciones Gravadas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_grav
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '09';

//Total Operaciones Inafectas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_inaf
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '10';

//Total Operaciones Exoneradas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_exo
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal ='11';

//Total Operaciones Gratuitas
select nvl(sum(ccd.cantidad * ccd.precio_unitario),0)
  into :ldc_total_op_gratuitas
  from cntas_cobrar_det ccd
 where ccd.tipo_doc = :asi_tipo_doc
   and ccd.nro_doc  = :asi_nro_doc
	and ccd.tipo_cred_fiscal = '12';
	
//Impuesto IGV
select nvl(sum(ci.importe),0)
  into :ldc_total_igv
  from cc_doc_det_imp 	ci,
  		 impuestos_tipo	it
 where ci.tipo_impuesto = it.tipo_impuesto
   and it.flag_igv		= '1'
   and ci.tipo_doc 		= :asi_tipo_doc
   and ci.nro_doc  		= :asi_nro_doc
	and ci.tipo_impuesto <> :is_icbper;

//ICBPER
select nvl(sum(ci.importe),0)
  into :ldc_total_icbper
  from cc_doc_det_imp ci
 where ci.tipo_doc = :asi_tipo_doc
   and ci.nro_doc  = :asi_nro_doc
	and ci.tipo_impuesto = :is_icbper;

//Cantidad de bolsas plasticas
select count(*)
  into :ll_cant_bolsas
from VW_VTA_CNTAS_COBRAR_DET ccd
where ccd.tipo_doc = :asi_tipo_doc
  and ccd.nro_doc  = :asi_nro_doc
  and ccd.icbper 		 > 0;

//Total del documento
ldc_total_doc = round(ldc_total_op_grav + ldc_total_op_inaf + ldc_total_op_exo + ldc_total_op_expo + ldc_total_igv,2)

//Datos del comprobante
ls_tipo_doc 		= ids_boletas.object.tipo_doc				[1]
ls_serie				= ids_boletas.object.serie					[1]
ls_nro				= ids_boletas.object.nro					[1]
ld_fec_emision 	= Date(ids_boletas.object.fec_emision	[1])
ls_hora_emision 	= ids_boletas.object.hora_emision		[1]
ls_moneda			= ids_boletas.object.moneda				[1]
ls_desc_moneda		= ids_boletas.object.desc_moneda			[1]
ls_observacion		= ids_boletas.object.observacion			[1]

//DAtos del cliente
ls_tipo_doc_cliente 	= ids_boletas.object.tipo_doc_ident	[1]
ls_nro_doc_cliente	= ids_boletas.object.nro_doc_ident	[1]
ls_direccion_cliente = ids_boletas.object.direccion		[1]
ls_pais_cliente		= ids_boletas.object.pais				[1]
ls_nom_cliente			= ids_boletas.object.nom_proveedor	[1]

//Documento de referencia
ls_tipo_doc_ref 	= ids_boletas.object.tipo_doc_ref		[1]
ls_serie_ref		= ids_boletas.object.serie_ref			[1]
ls_nro_ref			= ids_boletas.object.nro_ref				[1]

//Tipo de nota de credito
ls_tipo_nota 		= ids_boletas.object.tipo_nd				[1]
ls_Desc_motivo		= ids_boletas.object.desc_motivo			[1]

//Obtengo el nro_envio_id
ls_nro_envio_id	= ids_boletas.object.nro_envio_id		[1]

//Obtengo el total en letras
ls_total_txt = invo_numlet.of_numlet(string( ldc_total_doc )) + ' ' + ls_desc_moneda

//Moneda Soles y Dolares
if ls_moneda = gnvo_app.is_soles then
	ls_moneda = 'PEN'
else
	ls_moneda = 'USD'
end if

/*
SQL> DESC SUNAT_ENVIO_CE
Name         Type         Nullable Default Comments 
------------ ------------ -------- ------- -------- 
NRO_ENVIO_ID CHAR(10)                               
FILENAME_XML VARCHAR2(40) Y                         
FEC_REGISTRO DATE         Y                         
FEC_EMISION  DATE         Y                         
COD_USR      CHAR(6)      Y                         
NRO_TICKET   VARCHAR2(20) Y                         
DATA_XML     BLOB         Y                         
DATA_CDR     BLOB         Y 
*/

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie + "-" + gnvo_app.of_left_trim(ls_nro, '0')

if IsNull(ls_nro_Envio_id) or trim(ls_nro_envio_id) = '' then
	//Obtengo la fecha
	ld_fec_envio = Date(gnvo_app.of_fecha_actual( ))

	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
else
	//Obtengo la fecha
	ld_fec_envio = Date(ids_boletas.object.fec_envio		[1])

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_fec_envio) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 2 = Datos
ls_texto = '<DebitNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"' + char(13) + char(10) &
         + '				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + char(13) + char(10) &
         + '				xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"' + char(13) + char(10) &
         + '				xmlns:ccts="urn:un:unece:uncefact:documentation:2"' + char(13) + char(10) &
         + '				xmlns:ds="http://www.w3.org/2000/09/xmldsig#"' + char(13) + char(10) &
         + '				xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"' + char(13) + char(10) &
         + '				xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"' + char(13) + char(10) &
         + '				xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"' + char(13) + char(10) &
         + '				xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"' + char(13) + char(10) &
         + '				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Linea 3: Firma Digital
ls_texto = '	<ext:UBLExtensions>' + char(13) + char(10) &
   		+ '		<ext:UBLExtension>'+ char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '				<sac:AdditionalInformation>' + char(13) + char(10) &
			+ '					<sac:AdditionalProperty>' + char(13) + char(10) &
			+ '						<cbc:ID>1000</cbc:ID>' + char(13) + char(10) &
			+ '						<cbc:Value>' + ls_total_txt + '</cbc:Value>' + char(13) + char(10) &
			+ '					</sac:AdditionalProperty>' + char(13) + char(10) &
			+ '				</sac:AdditionalInformation>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 4: Versión del UBL utilizado para establecer el formato XML
ls_texto = '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 5: Versión de la estructura del documento
ls_texto = '	<cbc:CustomizationID>2.0</cbc:CustomizationID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 6: Identificador del comprobante
ls_texto = '   <cbc:ID>' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 7: Fecha de emisión 
ls_texto = '   <cbc:IssueDate>' + string(ld_Fec_emision, 'yyyy-mm-dd') + '</cbc:IssueDate>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 8: Hora de emisión 
ls_texto = '   <cbc:IssueTime>' + ls_hora_emision + '</cbc:IssueTime>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
   
//Line 9: Total en Letras
ls_texto = '   <cbc:Note languageLocaleID="1000">' + ls_total_txt + '</cbc:Note>' 
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 10: Moneda
ls_texto = '   <cbc:DocumentCurrencyCode>' + ls_moneda + '</cbc:DocumentCurrencyCode>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 11: Nro de Lineas
ls_texto = '   <cbc:LineCountNumeric>' + string(ids_boletas.RowCount()) + '</cbc:LineCountNumeric>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 12: Tipo Nota de Credito
ls_texto = '	<cac:DiscrepancyResponse>' + char(13) + char(10) &
			+ '		<cbc:ReferenceID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ReferenceID>' + char(13) + char(10) &
			+ '		<cbc:ResponseCode>' + ls_tipo_nota + '</cbc:ResponseCode>' + char(13) + char(10) &
			+ '		<cbc:Description>' + ls_desc_motivo + '</cbc:Description>' + char(13) + char(10) &
			+ '	</cac:DiscrepancyResponse>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 13: Referencia al documento
ls_texto = '	<cac:BillingReference>' + char(13) + char(10) &
 			+ '		<cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '			<cbc:ID>' + ls_serie_ref + '-'  + gnvo_app.of_left_trim(ls_nro_ref, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '			<cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '		</cac:InvoiceDocumentReference>' + char(13) + char(10) &
			+ '	</cac:BillingReference>' 
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 14: Signature del archivo
ls_texto = '	<cac:Signature>' + char(13) + char(10) &
			+ '		<cbc:ID>SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:ID>' + char(13) + char(10) &
			+ '		<cac:SignatoryParty>' + char(13) + char(10) &
			+ '			<cac:PartyIdentification>' + char(13) + char(10) &
			+ '				<cbc:ID>' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
			+ '			</cac:PartyIdentification>' + char(13) + char(10) &
			+ '			<cac:PartyName>' + char(13) + char(10) &
			+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
			+ '			</cac:PartyName>' + char(13) + char(10) &
			+ '		</cac:SignatoryParty> '+ char(13) + char(10) &
			+ '		<cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '			<cac:ExternalReference>' + char(13) + char(10)&
			+ '				<cbc:URI>#SF' + ls_serie + '-'  + gnvo_app.of_left_trim(ls_nro, '0') + '</cbc:URI>' + char(13) + char(10) &
			+ '			</cac:ExternalReference>' + char(13) + char(10) &
			+ '		</cac:DigitalSignatureAttachment>'+ char(13) + char(10) &
			+ '	</cac:Signature>'
			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
    
//Line 15: Datos del Emisor
ls_texto = '	<cac:AccountingSupplierParty>' + char(13) + char(10) &
    		+ '		<cac:Party>' + char(13) + char(10) &
      	+ '			<cac:PartyIdentification>' + char(13) + char(10) &
        	+ '				<cbc:ID 	schemeID="6"' + char(13) + char(10) &
			+ '						  	schemeName="SUNAT:Identificador de Documento de Identidad" ' + char(13) + char(10) &
			+ '						  	schemeAgencyName="PE:SUNAT"' + char(13) + char(10) &
			+ '							schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + gnvo_app.empresa.is_ruc + '</cbc:ID>' + char(13) + char(10) &
      	+ '			</cac:PartyIdentification>' + char(13) + char(10) &
      	+ '			<cac:PartyName>' + char(13) + char(10) &
        	+ '				<cbc:Name><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:Name>' + char(13) + char(10) &
      	+ '			</cac:PartyName>' + char(13) + char(10) &
      	+ '			<cac:PartyLegalEntity>' + char(13) + char(10) &
        	+ '				<cbc:RegistrationName><![CDATA[' + gnvo_app.empresa.is_nom_empresa + ']]></cbc:RegistrationName>' + char(13) + char(10) &
        	+ '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cbc:AddressTypeCode>0000</cbc:AddressTypeCode>' + char(13) + char(10) &
        	+ '				</cac:RegistrationAddress>' + char(13) + char(10) &
      	+ '			</cac:PartyLegalEntity>' + char(13) + char(10) &
    		+ '		</cac:Party>' + char(13) + char(10) &
  			+ '	</cac:AccountingSupplierParty>'

			
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 16: Datos del Cliente
ls_texto = '	<cac:AccountingCustomerParty>' + char(13) + char(10) &
      	+ '		<cac:Party>' + char(13) + char(10) &
         + '			<cac:PartyIdentification>' + char(13) + char(10) &
         + '				<cbc:ID schemeID="' + ls_tipo_doc_cliente + '">' + ls_nro_doc_cliente + '</cbc:ID>' + char(13) + char(10) &
         + '			</cac:PartyIdentification>' + char(13) + char(10) &
         + '			<cac:PartyLegalEntity>' + char(13) + char(10) &
         + '				<cbc:RegistrationName><![CDATA[' + ls_nom_cliente + ']]></cbc:RegistrationName>' + char(13) + char(10) &
         + '				<cac:RegistrationAddress>' + char(13) + char(10) &
         + '					<cac:AddressLine>' + char(13) + char(10) &
         + '         			<cbc:Line><![CDATA[' + ls_direccion_cliente + ']]></cbc:Line>' + char(13) + char(10) &
         + '					</cac:AddressLine>' + char(13) + char(10) &
         + '					<cac:Country>' + char(13) + char(10) &
         + '						<cbc:IdentificationCode>' + ls_pais_cliente + '</cbc:IdentificationCode>' + char(13) + char(10) &
         + '					</cac:Country>' + char(13) + char(10) &
         + '				</cac:RegistrationAddress>' + char(13) + char(10) &
         + '			</cac:PartyLegalEntity>' + char(13) + char(10) &
      	+ '		</cac:Party>' + char(13) + char(10) &
   		+ '	</cac:AccountingCustomerParty>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 17: Total de Impuestos
ls_texto = '	<cac:TaxTotal>' + char(13) + char(10) &
			+ '		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10)

if ldc_total_op_grav > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_grav, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_igv, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">S</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">1000</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>IGV</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_inaf > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_inaf, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">O</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9998</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>INA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_exo > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_exo, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cbc:ID schemeID="UN/ECE 5305"' + char(13) + char(10) &
         	 + '						  schemeName="Tax Category Identifier"' + char(13) + char(10) &
         	 + '						  schemeAgencyName="United Nations Economic Commission for Europe">E</cbc:ID>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9997</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXO</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_expo > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_expo, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9995</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>EXP</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_op_gratuitas > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '			<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_op_gratuitas, '#####0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				 + '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(0.00, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">9996</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>GRA</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if

if ldc_total_icbper > 0 then
	ls_texto += '		<cac:TaxSubtotal>' + char(13) + char(10) &
				 + '   		<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_icbper, '#####0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				 + '			<cac:TaxCategory>' + char(13) + char(10) &
				 + '				<cac:TaxScheme>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="UN/ECE 5153"' + char(13) + char(10) &
         	 + '							  schemeAgencyID="6">7152</cbc:ID>' + char(13) + char(10) &
				 + '					<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
				 + '					<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
				 + '				</cac:TaxScheme>' + char(13) + char(10) &
				 + '			</cac:TaxCategory>' + char(13) + char(10) &
				 + '		</cac:TaxSubtotal>' + char(13) + char(10) 
end if
			
ls_texto += '	</cac:TaxTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Line 18: Resumen total del documento
ls_texto = '	<cac:RequestedMonetaryTotal>' + char(13) + char(10) &
			+ '  		<cbc:PayableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_total_doc, '#####0.00')) + '</cbc:PayableAmount>' + char(13) + char(10) &
			+ ' 	</cac:RequestedMonetaryTotal>'

invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//Recorro el registro
ll_nro_item = 1
for ll_row = 1 to ids_boletas.RowCount()
	//Obtengo los datos
	ls_nro_registro		= ids_boletas.object.nro_registro		[ll_row]
	ls_und					= ids_boletas.object.und					[ll_row]
	ls_descripcion			= ids_boletas.object.descripcion			[ll_row]
	ls_codigo				= ids_boletas.object.cod_art				[ll_row]
	ls_TipoCredFiscal 	= ids_boletas.object.tipo_cred_fiscal	[ll_row]
	
	//Cantidades precios e impuestos
	ldc_cantidad 		= Dec(ids_boletas.object.cant_proyect 	[ll_row])
	ldc_precio_unit 	= Dec(ids_boletas.object.precio_unit 	[ll_row])
	ldc_igv			 	= Dec(ids_boletas.object.importe_igv 	[ll_row])
	ldc_descuento		= Dec(ids_boletas.object.descuento		[ll_row])
	ldc_icbper		 	= Dec(ids_boletas.object.icbper		 	[ll_row])

	
	If IsNull(ldc_descuento) then ldc_descuento = 0
	if IsNull(ls_codigo) then ls_codigo = 'OTROS'
	
	if IsNull(ls_und) or trim(ls_und) = '' then
		ls_und = 'ZZ'
	else
		ls_und = 'NIU'
	end if
	
	//Calculo el precio de venta
	ldc_LineExtensionAmount = ldc_precio_unit - ldc_descuento
	ldc_precio_vta				= ldc_LineExtensionAmount + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0
	
	
	ls_PriceTypeCode = '01'
	
	if ls_TipoCredFiscal = '08' then
		
		// Exportación
		ls_TaxExemptionReasonCode = '40'
		
		ls_IdTaxScheme 	= '9995'
		ls_NameTaxScheme 	= 'EXP'
		ls_TaxTypeCode 	= 'FRE'
		ldc_Percent 		= 0
		
	else
		ldc_Percent = 18
		
		if ls_TipoCredFiscal = '09' then
			
			ls_TaxExemptionReasonCode= '10'
			ls_IdTaxScheme = '1000'
			ls_NameTaxScheme = 'IGV'
			ls_TaxTypeCode = 'VAT'
			
		elseif ls_TipoCredFiscal = '10' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '30'
			ls_IdTaxScheme = '9998'
			ls_NameTaxScheme = 'INA'
			ls_TaxTypeCode = 'FRE'
			
		elseif ls_TipoCredFiscal = '11' then
			
			//Inafecto
			ls_TaxExemptionReasonCode= '20'
			ls_IdTaxScheme = '9997'
			ls_NameTaxScheme = 'EXO'
			ls_TaxTypeCode = 'VAT'
		
		elseif ls_TipoCredFiscal = '12' then
		
			//Gratuito
			if ldc_igv = 0 then
				ls_TaxExemptionReasonCode= '20'
			else
				ls_TaxExemptionReasonCode= '11'
			end if
			ls_IdTaxScheme = '9996'
			ls_NameTaxScheme = 'GRA'
			ls_TaxTypeCode = 'FRE'
			ls_PriceTypeCode = '02'
			
			ldc_LineExtensionAmount = 0.00
			
		end if
		
	end if
	
	ls_descripcion = trim(ls_descripcion)
	if right(ls_Descripcion, 1 ) = '~r~n' then
		ls_descripcion = left(ls_descripcion, len(ls_descripcion) - 1)
	end if
	
	//Reemplazo los saltos de linea
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r~n', '<br/>')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~r', '')
	ls_descripcion = invo_util.of_replace(ls_descripcion, '~n', '')
	ls_descripcion = left(ls_descripcion, 200)


	//Calculo el precio de venta
	ldc_precio_vta		= ldc_precio_unit - ldc_descuento + ldc_igv
	
	if ldc_precio_vta < 0 then ldc_precio_vta = 0

	
	ls_texto = '	<cac:DebitNoteLine>' + char(13) + char(10) &
   			+ '		<cbc:ID>' + trim(string(ll_nro_item)) + '</cbc:ID>' + char(13) + char(10) &
				+ '		<cbc:DebitedQuantity unitCode="' + ls_und + '">' + trim(string(ldc_cantidad, '######0.000')) + '</cbc:DebitedQuantity>' + char(13) + char(10) &
				+ '		<cbc:LineExtensionAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_LineExtensionAmount, '######0.00')) + '</cbc:LineExtensionAmount>' + char(13) + char(10) &
				+ '		<cac:PricingReference>' + char(13) + char(10) &
				+ '			<cac:AlternativeConditionPrice>' + char(13) + char(10) &
				+ '				<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_vta, '######0.00')) + '</cbc:PriceAmount>' + char(13) + char(10) &
				+ '				<cbc:PriceTypeCode>' + ls_PriceTypeCode + '</cbc:PriceTypeCode> ' + char(13) + char(10) &
				+ '			</cac:AlternativeConditionPrice>' + char(13) + char(10)&
				+ '		</cac:PricingReference>' + char(13) + char(10)
	
	//Impuestos
	ls_texto += '		<cac:TaxTotal>' + char(13) + char(10) &
				+ '			<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '			<cac:TaxSubtotal>' + char(13) + char(10) &
				+ '				<cbc:TaxableAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_cantidad * ldc_precio_unit, '######0.00')) + '</cbc:TaxableAmount>' + char(13) + char(10) &
				+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_igv, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
				+ '				<cac:TaxCategory>' + char(13) + char(10) &
				+ '					<cbc:Percent>' + trim(string(ldc_Percent, '######0.0')) + '</cbc:Percent> ' + char(13) + char(10) &
				+ '					<cbc:TaxExemptionReasonCode>' + ls_TaxExemptionReasonCode + '</cbc:TaxExemptionReasonCode>' + char(13) + char(10) &
				+ '					<cac:TaxScheme> ' + char(13) + char(10)&
				+ '						<cbc:ID>' + ls_IdTaxScheme + '</cbc:ID>' + char(13) + char(10) &
				+ '						<cbc:Name>' + ls_NameTaxScheme + '</cbc:Name>' + char(13) + char(10) &
				+ '						<cbc:TaxTypeCode>' + ls_TaxTypeCode + '</cbc:TaxTypeCode>' + char(13) + char(10) &
				+ '					</cac:TaxScheme>' + char(13) + char(10) &
				+ '				</cac:TaxCategory>' + char(13) + char(10) &
				+ '			</cac:TaxSubtotal>' + char(13) + char(10)
			
	if ldc_icbper > 0 then
		ls_texto +='			<cac:TaxSubtotal>' + char(13) + char(10) &
            	+ '				<cbc:TaxAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper * ll_cant_bolsas, '######0.00')) + '</cbc:TaxAmount>' + char(13) + char(10) &
            	+ '				<cbc:BaseUnitMeasure unitCode="NIU">' + trim(string(ll_cant_bolsas, '######0')) + '</cbc:BaseUnitMeasure>' + char(13) + char(10) &
            	+ '				<cac:TaxCategory>' + char(13) + char(10) &
					+ '					<cbc:PerUnitAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_icbper, '######0.00')) + '</cbc:PerUnitAmount>' + char(13) + char(10) &
               + '					<cac:TaxScheme>' + char(13) + char(10) &
               + '						<cbc:ID>7152</cbc:ID>' + char(13) + char(10) &
               + '						<cbc:Name>ICBPER</cbc:Name>' + char(13) + char(10) &
               + '						<cbc:TaxTypeCode>OTH</cbc:TaxTypeCode>' + char(13) + char(10) &
               + '					</cac:TaxScheme>' + char(13) + char(10) &
            	+ '				</cac:TaxCategory>' + char(13) + char(10) &
         		+ '			</cac:TaxSubtotal>' + char(13) + char(10) 

	end if	
	
	ls_texto += '		</cac:TaxTotal>' + char(13) + char(10) &
				 + '		<cac:Item>' + char(13) + char(10) &
				 + '			<cbc:Description><![CDATA[' + ls_descripcion + ']]></cbc:Description>' + char(13) + char(10) &
				 + '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '				<cbc:ID>' + ls_codigo + '</cbc:ID>' + char(13) + char(10) &
				 + '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '		</cac:Item>' + char(13) + char(10)
				
	if ls_tipoCredFiscal = '12' then
		ls_texto += '		<cac:Price>' + char(13) + char(10) &
					 + '			<cbc:PriceAmount currencyID="' + ls_moneda + '">0.00</cbc:PriceAmount>' + char(13) + char(10) &
					 + '		</cac:Price>' + char(13) + char(10)
	else
		ls_texto += '		<cac:Price>' + char(13) + char(10) &
					 + '			<cbc:PriceAmount currencyID="' + ls_moneda + '">' + trim(string(ldc_precio_unit, '######0.000000')) + '</cbc:PriceAmount>' + char(13) + char(10) &
					 + '		</cac:Price>' + char(13) + char(10)
	end if
	
	ls_texto += '	</cac:DebitNoteLine>'
				
	invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)
	
	ll_nro_item ++ 
	
next

//Cierro el documento
ls_texto = '</DebitNote>'
invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_fec_envio)

//actualizo el nro_rc en la tabla
update cntas_cobrar
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where tipo_doc = :asi_tipo_doc
   and nro_doc	 = :asi_nro_doc;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en CNTAS_COBRAR - Funcion of_generar_xml_ndc_ubl21. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_PathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_fec_envio)

update SUNAT_ENVIO_CE
   set path_file = :ls_PathFileXML
 where nro_envio_id = :ls_nro_envio_id;

 IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

 
//Guardo los cambios
commit;

return true
end function

public function boolean of_create_only_xml (string as_nro_registro, string as_tipo_doc, string as_nro_doc) throws exception;boolean 	lb_return
String	ls_version_ubl

//VAlido que el tipo de documento sea de factura electronica
if not invo_util.find_in_array( as_tipo_doc, is_doc_validos) then
	rollback;
	MessageBox('Error', 'Tipo de documento ' + as_tipo_doc + ' no es un documento valido para Factura electronica', StopSign!)					
	return false;
end if

//Verifico la version de UBL que se necesita

//Si la fecha es 01/03/2019 entonces el ubl va a ser obligatoriamente el UBL21

if Date(gnvo_app.of_fecha_actual( )) >= date('01/03/2019') then
	ls_version_ubl = "UBL21"
	gnvo_app.of_set_parametro( "EFACT_VERSION_UBL", ls_version_ubl)
else
	ls_version_ubl = gnvo_app.of_get_parametro("EFACT_VERSION_UBL", "UBL20")
end if

if not invo_util.find_in_array( ls_version_ubl, is_ubl_validos) then
	rollback;
	MessageBox('Error', 'El UBL ' + ls_version_ubl + ' no es un ubl valido para Factura electronica o no se encuentra implementado' &
							  + '~r~nConsulte con el proveedor del SIGRE', StopSign!)					
	return false;
end if



if Not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
	
	if trim(ls_version_ubl) = 'UBL20' then
		if trim(as_tipo_doc) = 'FAC' then
			lb_return = this.of_generar_xml_fac_ubl20( as_nro_registro )
		elseif trim(as_tipo_doc) = 'BVC' then
			lb_return = this.of_generar_xml_fac_ubl20( as_nro_registro )
		elseif trim(as_tipo_doc) = 'NCC' then
			lb_return = this.of_generar_xml_ncc_ubl20( as_nro_registro )
		elseif trim(as_tipo_doc) = 'NDC' then
			lb_return = this.of_generar_xml_ndc_ubl20( as_nro_registro )
		end if
	elseif trim(ls_version_ubl) = 'UBL21' then
		if trim(as_tipo_doc) = 'FAC' then
			lb_return = this.of_generar_xml_fac_ubl21( as_nro_registro )
		elseif trim(as_tipo_doc) = 'BVC' then
			lb_return = this.of_generar_xml_fac_ubl21( as_nro_registro )
		elseif trim(as_tipo_doc) = 'NCC' then
			lb_return = this.of_generar_xml_ncc_ubl21( as_nro_registro )
		elseif trim(as_tipo_doc) = 'NDC' then
			lb_return = this.of_generar_xml_ndc_ubl21( as_nro_registro )
		end if
	end if
	
	if not lb_Return then
		rollback;
		return false
	end if
else
	if trim(ls_version_ubl) = 'UBL20' then
		if trim(as_tipo_doc) = 'FAC' then
			lb_return = this.of_generar_xml_fac_ubl20( as_tipo_doc, as_nro_doc )
		elseif trim(as_tipo_doc) = 'BVC' then
			lb_return = this.of_generar_xml_fac_ubl20( as_tipo_doc, as_nro_doc )
		elseif trim(as_tipo_doc) = 'NCC' then
			lb_return = this.of_generar_xml_ncc_ubl20( as_tipo_doc, as_nro_doc )
		elseif trim(as_tipo_doc) = 'NDC' then
			lb_return = this.of_generar_xml_ndc_ubl20( as_tipo_doc, as_nro_doc )
		end if
	elseif trim(ls_version_ubl) = 'UBL21' then
		if trim(as_tipo_doc) = 'FAC' then
			lb_return = this.of_generar_xml_fac_ubl21( as_tipo_doc, as_nro_doc )
		elseif trim(as_tipo_doc) = 'BVC' then
			lb_return = this.of_generar_xml_fac_ubl21( as_tipo_doc, as_nro_doc )
		elseif trim(as_tipo_doc) = 'NCC' then
			lb_return = this.of_generar_xml_ncc_ubl21( as_tipo_doc, as_nro_doc )
		elseif trim(as_tipo_doc) = 'NDC' then
			lb_return = this.of_generar_xml_ndc_ubl21( as_tipo_doc, as_nro_doc )
		end if
	end if
	
	if not lb_return then
		rollback;
		return false
	end if
end if


return true
end function

public function string of_get_xml_filename (string as_nro_registro, string as_tipo_doc, string as_nro_doc) throws exception;String	ls_nro_envio_id, ls_filename_xml, ls_tipo_doc, ls_serie_cxc, ls_nro_cxc, ls_mensaje
date		ld_fec_envio

//Valido la informacion
if not this.of_valida_inputs(as_nro_registro, as_tipo_doc, as_nro_doc) then return ''
	
//Obtengo la fecha de envio
if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
	
	select 	dt.cod_sunat,
				fs.serie_cxc,
				fs.nro_cxc,
				fs.nro_envio_id
	  into 	:ls_tipo_doc,
	  			:ls_serie_cxc,
				:ls_nro_cxc,
				:ls_nro_envio_id
	  from 	fs_factura_simpl 	fs,
	  			doc_tipo				dt
	 where fs.tipo_doc_cxc	= dt.tipo_doc
	   and nro_registro 		= :as_nro_registro;
	 
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla fs_factura_simpl. Mensaje: ' + ls_mensaje + '. Por favor verifique!', StopSign!)
		return ''
	end if

else 	 
	select 	dt.cod_sunat,
				pkg_fact_electronica.of_get_serie(cc.nro_doc),
				pkg_fact_electronica.of_get_nro(cc.nro_doc),
				cc.nro_envio_id
	  into 	:ls_tipo_doc,
	  			:ls_serie_cxc,
				:ls_nro_cxc,
				:ls_nro_envio_id
	  from 	cntas_cobrar 	cc,
	  			doc_tipo			dt
	 where cc.tipo_doc	= dt.tipo_doc
	   and cc.tipo_doc 	= :as_tipo_doc
	   and cc.nro_doc		= :as_nro_doc;
		
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla cntas_cobrar. Mensaje: ' + ls_mensaje + '. Por favor verifique!', StopSign!)
		return ''
	end if

end if


//Si no hay nro de envio entonces genero el PDF
if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	if not this.of_create_only_xml(as_nro_registro, as_tipo_doc, as_nro_doc) then return ''
	
	//Obtengo nuevamente el nro de envio
	if not IsNull(as_nro_registro) and trim(as_nro_registro) <> '' then
		select 	fs.nro_envio_id
		  into 	:ls_nro_envio_id
		  from 	fs_factura_simpl 	fs
		 where nro_registro 		= :as_nro_registro;
		 
	else 	 
		select 	cc.nro_envio_id
		  into 	:ls_nro_envio_id
		  from 	cntas_cobrar 	cc
		 where cc.tipo_doc 	= :as_tipo_doc
			and cc.nro_doc		= :as_nro_doc;
	end if

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al tratar de obtener el NRO_ENVIO_ID luego de crear el  archivo XML. Mensaje: ' + ls_mensaje + '. Por favor verifique!', StopSign!)
		return ''
	end if
	
	
	if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
		MessageBox('Error', 'No se ha generado el nro de envio correctamente. Por favor verifique!', StopSign!)
		return ''
	end if

end if

//Obtengo la fecha de envio
select trunc(fec_registro)
  into :ld_fec_envio
  from sunat_envio_ce 
 where nro_envio_id = :ls_nro_envio_id;
  

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Error', 'NO existe registro ' + ls_nro_envio_id + ' en tabla SUNAT_ENVIO_CE. Por favor verifique!', StopSign!)
	return ''
end if

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie_cxc + "-" + gnvo_app.of_left_trim(ls_nro_cxc, '0')

/***********************************************/
//En caso de no existir se crea el archivo XML
/***********************************************/
if not invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
	this.of_create_only_xml(as_nro_registro, as_tipo_Doc, as_nro_doc)
	if not invo_xml.of_FileExists_XML(ls_filename_xml, ld_fec_envio) then
		MessageBox('Error', 'Archivo ' + invo_xml.of_get_fullname(ls_filename_xml, ld_fec_envio) + ' no existe. Por favor verifique!', StopSign!)
		return ''
	end if
end if

return invo_xml.of_get_fullname(ls_filename_xml, ld_fec_envio)
end function

public function boolean of_create_only_xml (string as_nro_registro, string as_tipo_doc) throws exception;String ls_nro_doc = ''
return this.of_create_only_xml(as_nro_registro, as_tipo_doc, ls_nro_doc)
end function

public function boolean of_generar_vale_almacen (string as_nro_registro);String ls_mensaje
//procedure sp_fs_vale_almacen(asi_registro fs_factura_simpl.nro_registro%TYPE ) is

DECLARE sp_fs_vale_almacen PROCEDURE FOR 
	pkg_fact_electronica.sp_fs_vale_almacen(:as_nro_registro);
	
EXECUTE sp_fs_vale_almacen ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL Error', "Error en PAQUETE pkg_fact_electronica.sp_fs_vale_almacen(" + as_nro_registro + "): " + ls_mensaje)	
	return false
end if

COMMIT ;

CLOSE sp_fs_vale_almacen ;

return true
end function

public function boolean of_cerrar_ov (string as_tipo_doc, string as_nro_doc);String ls_mensaje

//Cerrando el detalle de la OV
update articulo_mov_proy amp
   set amp.flag_estado = '2'
 where amp.flag_estado = '1'
   and amp.tipo_doc = :as_tipo_doc
   and amp.nro_doc  = :as_nro_doc;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al cerrar el detalle de la OV. Tabla ARTICULO_MOV_PROY. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false;
end if

//Cerrando la cabecera de la OV
update orden_venta ov
   set ov.flag_estado = '2'
 where ov.nro_ov 			= :as_nro_doc
   and ov.flag_estado 	= '1';

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al cerrar la CABECERA de la OV. Tabla ORDEN_VENTA. ' &
							+ '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false;
end if

commit;
	
return true
end function

public function boolean of_gen_transformacion (str_parametros astr_param);String		ls_tipo_doc, ls_nro_doc []
u_ds_base	lds_almacen
Long			ll_i

try 
	
	ls_tipo_doc = astr_param.string1
	ls_nro_doc	= astr_param.str_array
	
	lds_almacen = create u_ds_base
	lds_almacen.DataObject = 'd_lista_almacen_ov_tbl'
	lds_almacen.setTransObject(SQLCA)
	
	lds_almacen.Retrieve(ls_tipo_doc, ls_nro_doc)
	
	for ll_i = 1 to lds_almacen.RowCount()
	next
	
	return true
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en funcion n_cst_ventas.of_gen_transformacion(str_parametros)')
	return false
	
finally
	destroy lds_almacen
	
end try

end function

public function boolean of_print_only_efact (string as_nro_registro);Long 		ll_height, ll_rows_fp
Date		ld_fecha
String	ls_origen, ls_direccion, ls_fono, ls_tipo_doc_cxc, ls_nro_doc_cxc, ls_serie, &
			ls_flag_tipo_impresion
Long		ll_i

try 
	
	invo_wait.of_mensaje("Obteniendo la Serie")
	//Obtengo la serie
	select serie_cxc, tipo_doc_cxc, 
			 decode(nro_doc_cxc, null, serie_cxc || '-' || nro_Cxc, nro_doc_cxc)
		into :ls_Serie, :ls_tipo_doc_cxc, :ls_nro_doc_cxc
	from fs_factura_simpl
	where nro_registro = :as_nro_registro;
	
	//Obtengo los flag adecuados
	select nvl(flag_tipo_impresion, '0')
		into :ls_flag_tipo_impresion
	from num_doc_tipo
	where nro_serie = :ls_serie
	  and tipo_doc	 = :ls_tipo_doc_cxc;
		
	invo_wait.of_mensaje("Preparando el reporte")

	//Imprimo el ticket
	ids_ticket.DataObject = this.of_select_DataObject(as_nro_registro, ls_tipo_doc_cxc, ls_serie, 'L')
	
	ids_ticket.SetTransObject(SQLCA)
	
	if ls_flag_tipo_impresion <> '2' then
	
		ids_ticket.Retrieve(as_nro_registro, gs_empresa)
		
	else
		
		ids_ticket.Retrieve(ls_tipo_doc_cxc, ls_nro_doc_cxc, gs_empresa)
		
	end if


	ls_origen = ids_ticket.object.cod_origen [1]
		
	ls_direccion 	= gnvo_app.empresa.of_direccion(ls_origen)
	ls_fono			= gnvo_app.empresa.of_telefono(ls_origen)	
	
	for ll_i = 1 to ids_ticket.RowCount()
		ids_ticket.object.direccion [ll_i] = ls_direccion
		ids_ticket.object.fono_fijo [ll_i] = ls_fono
	next
	
	//Pongo el nombre al documento
	ids_ticket.object.DataWindow.Print.DocumentName	= trim(ls_tipo_doc_cxc) + '-' + ls_nro_doc_cxc

	//Cuantas formas de pago tiene
	if ls_flag_tipo_impresion <> '2' then
		select count(*)
			into :ll_rows_fp
		from fs_factura_simpl_pagos
		where nro_registro = :as_nro_registro;
		
		//ASigno el tamaño requerido
		ll_height = il_height_efact + il_height_row_efact * ids_ticket.RowCount( ) + il_height_row_fp * ll_rows_fp
		ids_ticket.Object.DataWindow.Print.Paper.Size = 256 
		ids_ticket.Object.DataWindow.Print.CustomPage.Width = il_width_efact
		ids_ticket.Object.DataWindow.Print.CustomPage.Length = ll_height
	end if
	
	//Coloco el logo
	if FileExists(gs_logo) then
		ids_ticket.object.p_logo.filename = gs_logo
	end if
	
	invo_wait.of_mensaje("Ajustando la configuracion")
	//Lleno los datos necesarios
	if trim(ls_tipo_doc_cxc) <> 'NVC' then
		if ids_ticket.of_Existstext( "nro_resolucion") then
			ids_ticket.object.nro_resolucion_t.text 	= "Autorizado mediante Resolución Nro.: " + trim(this.is_nro_resolucion) + "."
		end if
		
		if ids_ticket.of_Existstext( "url_t") then
			ids_ticket.object.url_t.text 					= this.is_url
		end if
		
		if ids_ticket.of_Existstext( "devolucion_t") then
			ids_ticket.object.devolucion_t.text 		= this.is_texto_devolucion
		end if
		
		//Genero el codigo QR
		invo_wait.of_mensaje("Generando el Codigo QR")
		if not this.of_generar_qrcode( ld_fecha ) then return false
	end if
	
	invo_wait.of_mensaje("Imprimiendo el comprobante")
	
	if trim(ls_tipo_doc_cxc) = 'NVC' then
		if gnvo_app.of_get_parametro( "VTA_PRINT_NOTA_VENTA", "0") = "1" then
			ids_ticket.Print()
		end if
	else
		ids_ticket.Print()
	end if
	
	invo_wait.of_mensaje("Imprimiendo otra vez el comprobante")
	if trim(ls_tipo_doc_cxc) <> 'NVC' THEN
		if gnvo_app.of_get_parametro( "DOBLE_COMPROBANTE", "0") = "1" then
			ids_ticket.Print()
		end if
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return false

finally
	invo_wait.of_close()
end try





end function

on n_cst_ventas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_ventas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//this.of_load( )
ids_ticket  = create u_ds_base
ids_despacho = create u_ds_base
ids_boletas = create u_ds_base

invo_xml 	= create n_cst_xml
invo_numlet = create n_cst_numlet
invo_wait 	= create n_Cst_wait

invo_inifile	= create n_cst_inifile

end event

event destructor;destroy ids_ticket
destroy ids_despacho
destroy ids_boletas

destroy invo_xml
destroy invo_numlet
destroy invo_wait

destroy invo_inifile
end event

