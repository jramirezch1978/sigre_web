$PBExportHeader$n_cst_finanzas.sru
forward
global type n_cst_finanzas from nonvisualobject
end type
end forward

global type n_cst_finanzas from nonvisualobject
end type
global n_cst_finanzas n_cst_finanzas

type prototypes
//Funciones para la generación del codigo QR
SUBROUTINE FastQRCode(REF String Texto, REF String FileName) LIBRARY "\sigre_exe\QRCodeLib.dll" Alias for "FastQRCode;Ansi"
//subroutine FastQRCode(ref string text, ref string filename) library '\sigre_exe\QRCodeLib.dll' ALIAS FOR "FastQRCode"
Function String QRCodeLibVer() LIBRARY "\sigre_exe\QRCodeLib.dll" Alias for "QRCodeLibVer;Ansi"

end prototypes

type variables
//Parametros de Finparam
Decimal		idc_tasa_retencion, 	idc_monto_retencion

String		is_cnta_prsp_gfinan, is_doc_ret			, is_agente_ret			, is_flag_val_asiento,  &
				is_doc_ex, 				is_doc_ncp			, is_doc_cnc				, is_cta_ctbl_gan,		&
				is_cta_ctbl_per,		is_doc_og			, is_cnta_ctbl_ret_igv	, is_confin_cnj_cob	, 	&
				is_confin_rnv_cob,	is_confin_cnj_pag	, is_confin_rnv_pag		, is_confin_chq,			&
				is_doc_chd,				is_pcon			   , is_doc_fap				, is_cta_ctbl_liq_hab,	&
				is_cta_ctbl_liq_deb, is_doc_ce			, is_flag_os				, is_igv,					&
				is_modif_precio_unit
				

				
Long			il_nro_libro_cmp, il_libro_pagos

//Sistema de embargos por medios Telemáticos
/*******************************************/
//idc_porc_embarco_cp es el 5% de la UIT, y idc_porc_embargo_rh es la tercera parte del 50% de la UIT
//ambos con la fecha de pago del documento

String		is_flag_embargo_tele, is_doc_rcem  //Resolución coactiva de embargo
String		is_doc_bvp, is_doc_rh
Decimal		idc_porc_embargo_cp, idc_porc_embargo_rh


//Detraccion x Pagar
String		is_doc_dtrp, is_cencos_dtrp, is_cnta_prsp_dtrp, is_dtrp_prov, is_cnta_cntbl_dtrp

//Detraccion x Cobrar
String		is_doc_dtrc, is_cencos_dtrc, is_dtrc_prov, is_cnta_cntbl_dtrc

//Cobranza coactiva
String		is_flag_cobranza_coac, is_doc_coba, is_prov_SUNAT
Decimal		idc_limite_sol, idc_limite_dol, idc_porc_igv

//Cuentas Contables para ADelantos
String		is_cnta_cntbl_ant1, is_cnta_cntbl_ant2, is_cnta_cntbl_ant3

//Documentos por cobrar
String		is_doc_fac, is_doc_bvc, is_cliente_gen, is_nom_cliente_gen, is_doc_cli_gen, is_doc_ncc, is_doc_ndc

//Tipos de Credito Fiscal
String		is_cred_fiscal_exp, is_cred_fiscal_VNG, is_cred_fiscal_VNI, is_cred_fiscal_VNE

//Parametros para boleta
decimal		idc_uit, idc_max_uit_bvc, idc_max_monto_bvc

//Grupos de documentos
string		is_grp_doc_ntvnt

//Conceptos financieros para reversión de adelantos
String 		is_confin_sol, is_confin_dol, is_cnta_anticipo_sol, is_cnta_anticipo_dol

decimal		idc_descuento_max

//Nro de Cuenta de Detraccion para la empresa
String 		is_cnta_cnte_detraccion

//USuario cajero
String		is_usr_cajero, is_nom_cajero
string		is_cf_anticipo_sol

//Documentos especiales
String		is_doc_dua

u_ds_base 	ids_boletas

//Objeto para crear XML
n_cst_xml			invo_xml
n_cst_numlet 		invo_numlet
n_cst_utilitario	invo_util

end variables

forward prototypes
public function boolean of_load ()
public function decimal of_get_tipo_cambio (date ad_fecha)
public function decimal of_tasa_cambio ()
public subroutine of_get_monto_os (string as_nro_os, ref decimal adc_monto_fap, ref decimal adc_monto_os)
public subroutine of_get_monto_oc (string as_nro_oc, ref decimal adc_monto_fap, ref decimal adc_monto_oc)
public function boolean of_informar_sunat (datawindow adw_report)
public function boolean of_validar_coba (u_dw_abc adw_master, u_dw_abc adw_detail)
public function boolean of_eliminina_deuda_financiera (u_dw_abc adw_master)
public function boolean of_elimina_cheque (u_dw_abc adw_master)
public function decimal of_tasa_cambio (date ad_fecha)
public function str_cliente of_get_cliente ()
public function str_cliente of_get_cliente (string as_tipo_doc)
public function string of_desc_cred_fiscal (string as_cred_fiscal)
public function str_cliente of_get_cliente (string as_tipo_doc, string as_serie)
public function decimal of_conv_mon (decimal adc_importe, string as_mon_org, string as_mon_dst, date ad_fecha)
public function boolean of_actualiza_saldo_cc ()
public function boolean of_actualiza_saldo_cp ()
public function boolean of_validar_rcem (u_dw_abc adw_master, u_dw_abc adw_detail)
public function boolean of_generar_txt_recm (u_dw_abc adw_master, u_dw_abc adw_detail, ref string aso_filename_txt)
end prototypes

public function boolean of_load ();String 	ls_mensaje
Long		ll_count

try 
	
	select 	porc_ret_igv,					cntas_prsp_gfinan,					doc_ret_igv_crt, 		NVL(flag_retencion,'0'),
				NVL(imp_min_ret_igv, 700), NVL(FLAG_VALIDAR_ASIENTO, '0'), 	doc_ex,					cnta_ctbl_dc_ganancia,		
				cnta_ctbl_dc_perdida,		doc_sol_giro,							cnta_cntbl_ret_igv,	confin_cnj_let_cob,			
				confin_rnv_let_cob,			confin_cnj_let_pag,					confin_rnv_let_pag,	confin_cheque_dif,			
				doc_cheque_dif,				doc_detrac_cp,							cencos_detraccion, 	cnta_prsp_detraccion,				
				pago_contado,					libro_compras,							doc_fact_pagar,		libro_pagos,
				cnta_ctbl_liq_haber, 		cnta_ctbl_liq_debe,					comprobante_egr,		doc_ntvnt
		into 	:idc_tasa_retencion,			:is_cnta_prsp_gfinan,				:is_doc_ret, 				:is_agente_ret,
				:idc_monto_retencion, 		:is_flag_val_asiento, 				:is_doc_ex,					:is_cta_ctbl_gan,				
				:is_cta_ctbl_per,				:is_doc_og,								:is_cnta_ctbl_ret_igv,	:is_confin_cnj_cob,			
				:is_confin_rnv_cob,			:is_confin_cnj_pag,					:is_confin_rnv_pag,		:is_confin_chq,				
				:is_doc_chd,					:is_doc_dtrp,							:is_cencos_dtrp,			:is_cnta_prsp_dtrp, 					
				:is_pcon,						:il_nro_libro_cmp,					:is_doc_fap,				:il_libro_pagos,
				:is_cta_ctbl_liq_hab,		:is_cta_ctbl_liq_deb,				:is_doc_ce,					:is_grp_doc_ntvnt
	from finparam 

	where reckey = '1' ;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha sucedido un error al consultar la tabla FINPARAM. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if	
	
	if IsNull(is_cta_ctbl_per) or trim(is_cta_ctbl_per) = '' then
		ROLLBACK;
		MessageBox('Error', 'No ha especificado el parametro cnta_ctbl_dc_perdida en FINPARAM, por favor verifique!', StopSign!)
		return false
	end if

	if IsNull(is_cta_ctbl_gan) or trim(is_cta_ctbl_gan) = '' then
		ROLLBACK;
		MessageBox('Error', 'No ha especificado el parametro cnta_ctbl_dc_ganancia en FINPARAM, por favor verifique!', StopSign!)
		return false
	end if

	if IsNull(is_cta_ctbl_liq_deb) or trim(is_cta_ctbl_liq_deb) = '' then
		ROLLBACK;
		MessageBox('Error', 'No ha especificado el parametro cnta_ctbl_liq_debe en FINPARAM, por favor verifique!', StopSign!)
		return false
	end if

	
	//Nota de Credito para no domiciliados
	is_doc_cnc = gnvo_app.of_get_parametro("NOTA_CRED_NO_DOMIC", 'CNC')
	is_doc_ncp = gnvo_app.of_get_parametro("NOTA_NCP", 'NCP')

	// Detracciones por pagar
	is_dtrp_prov			= gnvo_app.of_get_parametro("DTRP_PROVISION", '0')
	is_cnta_cntbl_dtrp	= gnvo_app.of_get_parametro("CNTA_CNTBL_DTRP", '42501101')
	
	// Detracciones por cobrar
	is_dtrc_prov			= gnvo_app.of_get_parametro("DTRC_PROVISION", '1')
	is_doc_dtrc 			= gnvo_app.of_get_parametro("DOC_DTRC", 'DTRC')
	is_cnta_cntbl_dtrc	= gnvo_app.of_get_parametro("CNTA_CNTBL_DTRC", '12501101')
	is_IGV					= gnvo_app.of_get_parametro("IMPUESTO_IGV", 'IGV18')
	
	// Flag Para Cobranza Coactiva
	is_doc_coba 			= gnvo_app.of_get_parametro("DOC_COBRANZA_COACTIVA", 'RCP')
	is_prov_SUNAT 			= gnvo_app.of_get_parametro("COD_PROVEEDOR_SUNAT", 'E0005614')
	
	if gs_empresa = 'CANTABRIA' then
		is_flag_cobranza_coac = '1'
	else
		is_flag_cobranza_coac = gnvo_app.of_get_parametro("COBRANZA_COACTIVA", '1')
	END IF
	
	idc_limite_sol				 = gnvo_app.of_get_parametro("LIMITE_COBRANZA_COACTIVA_SOL", 3500.00)
	idc_limite_dol				 = gnvo_app.of_get_parametro("LIMITE_COBRANZA_COACTIVA_DOL", 1500.00)
	
	//Cuentas Contables para los anticipos
	is_cnta_cntbl_ant1		= gnvo_app.of_get_parametro( "CNTA_CNTBL_ANTIC_MN", "42201101")
	is_cnta_cntbl_ant2		= gnvo_app.of_get_parametro( "CNTA_CNTBL_ANTIC_ME", "42201102")
	is_cnta_cntbl_ant3		= gnvo_app.of_get_parametro( "CNTA_CNTBL_ANTIC_ME_IMP", "42201103")
	
	//Documentos por cobrar
	is_doc_fac					= gnvo_app.of_get_parametro( "DOC_FAC_X_COBRAR", "FAC")
	is_doc_bvc					= gnvo_app.of_get_parametro( "DOC_BOL_X_COBRAR", "BVC")
	is_doc_ncc					= gnvo_app.of_get_parametro( "DOC_NOTA_CREDITO_X_COBRAR", "NCC")
	is_doc_ndc					= gnvo_app.of_get_parametro( "DOC_NOTA_debito_X_COBRAR", "NDC")
	
	//Cliente Generico
	is_cliente_gen				= gnvo_app.of_get_parametro( "CLIENTE_GENERICO", "CLIEGENE")
	is_nom_cliente_gen		= gnvo_app.of_get_parametro( "NOM_CLIENTE_GENERICO", "CLIENTE GENERICO")
	is_doc_cli_gen				= gnvo_app.of_get_parametro( "NRO_DOC_IDENT_GENERICO", "00000000")
	
	is_confin_sol				= gnvo_app.of_get_parametro( "CONFIN_REV_ADEL_SOL", "CC-034")
	is_confin_dol				= gnvo_app.of_get_parametro( "CONFIN_REV_ADEL_DOL", "CC-035")
	
	//Cuentas Contables para Anciticipos por Cobrar
	is_cnta_anticipo_sol		= gnvo_app.of_get_parametro( "CNTA CNTBL ANTICIPOS M.N.", "12201101")
	is_cnta_anticipo_dol		= gnvo_app.of_get_parametro( "CNTA CNTBL ANTICIPOS M.E.", "12201102")
	
	//Configuracion para el precio unitario
	is_modif_precio_unit	= gnvo_app.of_get_parametro( "MODIFICAR_PRECIO_UNIT", "0")
	is_usr_cajero 			= gnvo_app.of_get_parametro( "USUARIO_CAJERO", "")
	
	//Nro de cuenta de detraccion
	is_cnta_cnte_detraccion = gnvo_app.of_get_parametro( "CUENTA_BANCO_DETRACCION", "00-631-065937")
	
	//Documento DUA
	is_doc_dua 					= gnvo_app.of_get_parametro( "FIN_DOCUMENTO_DUA", "DUA")

	
	select nombre
		into :is_nom_cajero
	from usuario
	where cod_usr = :is_usr_cajero;
	
	//Proveedor generico
	select count(*)
		into :ll_count
	from proveedor p
	where p.proveedor = :is_cliente_gen;

	
	if ll_count = 0 then
		
		insert into proveedor(proveedor, nom_proveedor, tipo_doc_ident, nro_doc_ident, flag_estado, flag_clie_prov)
		values(:is_cliente_gen, :is_nom_cliente_gen, '1', :is_doc_cli_gen, '1', '0');

		if SQLCA.SQlcode < 0 then
			ls_mensaje = SQLCA.SQLErrtext
			ROLLBACK;
			MessageBox('Error', 'Error al momento de insertar Cliente Generico. Mensaje: ' + ls_mensaje, StopSign!)
		end if
		
	else
		
		update proveedor p
			set p.nom_proveedor  = :is_nom_cliente_gen,
				 p.tipo_doc_ident = '0',
				 p.nro_doc_ident	= :is_doc_cli_gen,
				 p.flag_clie_prov = '0'
		where p.proveedor = :is_cliente_gen;

		if SQLCA.SQlcode < 0 then
			ls_mensaje = SQLCA.SQLErrtext
			ROLLBACK;
			MessageBox('Error', 'Error al momento de actualizar Cliente Generico. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if

	end if
	
	commit;
	
	//Tipos de credito Fiscal
	is_cred_fiscal_exp	= gnvo_app.of_get_parametro("CRED_FISCAL_EXPORTACION", '08')
	is_cred_fiscal_VNG	= gnvo_app.of_get_parametro("CRED_FISCAL_VNG", '09')
	is_cred_fiscal_VNG	= gnvo_app.of_get_parametro("CRED_FISCAL_VNI", '10')
	is_cred_fiscal_VNG	= gnvo_app.of_get_parametro("CRED_FISCAL_VNE", '11')
	
	//Max UIT para las BVC
	idc_max_uit_bvc 		= gnvo_app.of_get_parametro_dec("MAX_UIT_BVC", 0.2500)
	
	//Maximo porcentaje de descuento
	idc_descuento_max 		= gnvo_app.of_get_parametro_dec("MAX_DESCUENTO_PRECIO_VTA", 40.00)
	
	//UIT Valido
	select count(*)
		into :ll_count
	  from uit;
	
	if ll_count = 0 then
		MessageBox('Error', 'No ha especificado la UIT, por favor coordine con contabilidad para que lo ingrese.', StopSign!)
		return false
	end if
	
	select importe
		into :idc_uit
	  from uit
	where rownum = 1
	order by fec_ini_vigen desc;
	
	//Calculo el monto maximo de la BVC para que pida DNI
	idc_max_monto_bvc = idc_max_uit_bvc * idc_uit
	 
	//Porcentaje del IGV
	select tasa_impuesto
		into :idc_porc_igv
	from impuestos_tipo t
	where t.tipo_impuesto = :is_igv;
	
	//Concepto Financiero
	is_cf_anticipo_sol = gnvo_app.of_get_parametro("CONFIN_ANCITIPO_SOL", "CC-007")
	
	//Sistema de embargos por medios Telemáticos
	/*******************************************/

	is_flag_embargo_tele = gnvo_app.of_get_parametro("SEMMT_FLAG_EMBARGO_TELEMATICO", "0")
	is_doc_rcem  			= gnvo_app.of_get_parametro("SEMMT_DOC_RESULUCION_COACTIVA_EBARGO", "RCEM")

	idc_porc_embargo_cp	= gnvo_app.of_get_parametro_dec("SEMMT_PORC_EMBARGO_COMPROBANTES", 0.05)
	idc_porc_embargo_rh	= gnvo_app.of_get_parametro_dec("SEMMT_PORC_EMBARGO_RRHH", 0.1666666667)
	
	is_doc_bvp				= gnvo_app.of_get_parametro("DOC_BVP", "BVP ")
	is_doc_rh				= gnvo_app.of_get_parametro("DOC_RECIBO_HONORARIOS", "RE  ")
	
	
	
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción en la función OF_LOAD del objeto ' + this.classname() &
							+ '.~r~nMensaje de error: ' + ex.getMessage() + '.' &
							+ '~r~nPor favor verifique!', StopSign!)
finally
	/*statementBlock*/
end try

return true
end function

public function decimal of_get_tipo_cambio (date ad_fecha);decimal ldc_tasa_cambio

select vta_dol_prom
	into :ldc_tasa_cambio
from calendario
where fecha = :ad_fecha;

//En caso de no existir tipo de cambio de la fecha, tomo el ultimo tipo de cambio menor a la fecha indicada
if SQLCA.SQLCode = 100 then
	select vta_dol_prom
		into :ldc_tasa_cambio
	from calendario
	where fecha < :ad_fecha
	order by fecha desc;
	
end if

if IsNull(ldc_tasa_cambio) then ldc_tasa_cambio = 0

return ldc_tasa_cambio
end function

public function decimal of_tasa_cambio ();decimal 	ldc_tasa_cambio
Date		ld_fecha

ld_fecha = Date(gnvo_app.of_fecha_actual())

select vta_dol_prom
	into :ldc_tasa_cambio
from calendario
where trunc(fecha) = trunc(:ld_fecha);

//En caso de no existir tipo de cambio de la fecha, tomo el ultimo tipo de cambio menor a la fecha indicada
if SQLCA.SQLCode = 100 then
	select vta_dol_prom
		into :ldc_tasa_cambio
	from calendario
	where trunc(fecha) < trunc(:ld_fecha)
	order by fecha desc;
	
end if

if IsNull(ldc_tasa_cambio) then ldc_tasa_cambio = 0

return ldc_tasa_cambio
end function

public subroutine of_get_monto_os (string as_nro_os, ref decimal adc_monto_fap, ref decimal adc_monto_os);//recupera monto facturado
select Nvl(os.monto_facturado,0), Nvl(os.monto_total,0)
  into :adc_monto_fap, :adc_monto_os
  from orden_servicio os
 where os.nro_os		 = :as_nro_os ;
  

end subroutine

public subroutine of_get_monto_oc (string as_nro_oc, ref decimal adc_monto_fap, ref decimal adc_monto_oc);
//recupera monto facturado
select Nvl(oc.monto_total,0),Nvl(oc.monto_facturado,0)
  into :adc_monto_oc, :adc_monto_fap
  from orden_compra oc
 where oc.nro_oc		 = :as_nro_oc ;

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	gnvo_app.of_message_error( "La Orden de Compra " + as_nro_oc + " no existe. Por favor verifique!")
	return
end if
  
end subroutine

public function boolean of_informar_sunat (datawindow adw_report);Decimal	ldc_imp_total, ldc_limite
String	ls_moneda, ls_flag_cobranza_coac, ls_proveedor
Long		ll_i

if adw_report.RowCount() = 0 then return false

ls_moneda 					= adw_report.object.cod_moneda 			[1]
ldc_imp_total 				= Dec(adw_report.object.imp_total 		[1])
ls_proveedor				= adw_report.object.proveedor 			[1]

if ls_moneda = gnvo_app.is_soles then
	ldc_limite = gnvo_app.finparam.idc_limite_sol
else
	ldc_limite = gnvo_app.finparam.idc_limite_dol
end if

if is_flag_cobranza_coac = '1' and ls_proveedor <> is_prov_SUNAT  then
	adw_report.object.t_informacion.visible = '1'
	if ldc_imp_total < ldc_limite then
		adw_report.object.t_informacion.text = 'Sin obligación de informar a SUNAT'
	else
		ls_flag_cobranza_coac = '0'
		for ll_i = 1 to adw_report.RowCount()
			if trim(adw_report.object.tipo_docref1 [ll_i]) 	= trim(is_doc_coba) then
				ls_flag_cobranza_coac = '1'
				exit
			end if
		next
		
		if ls_flag_cobranza_coac = '1' then
			adw_report.object.t_informacion.text = 'Con Cobranza Coactiva'
		else
			adw_report.object.t_informacion.text = 'Sin Cobranza Coactiva'
		end if
		

	end if
else
	adw_report.object.t_informacion.visible = '0'
	adw_report.object.t_informacion.text = ''
end if

return true
end function

public function boolean of_validar_coba (u_dw_abc adw_master, u_dw_abc adw_detail);Decimal	ldc_imp_total, ldc_limite, ldc_imp_cobranza, ldc_tasa_cambio, ldc_importe_det
String	ls_moneda, ls_flag_estado, ls_moneda_coba, ls_moneda_det, ls_tipo_doc
Long		ll_i

if is_flag_cobranza_coac = '0' then return true

if adw_master.RowCount() = 0 then 
	MessageBox('Error', 'La cabecera del documento debe tener al menos un regristro', StopSign!)
	return false
end if

if adw_detail.RowCount() = 0 then 
	MessageBox('Error', 'La operacion de TESORERIA debe tener al menos un documento', StopSign!)
	return false
end if

ls_flag_estado = adw_master.object.flag_estado [1]

if ls_flag_estado = '0' then return false

ldc_imp_total 		= Dec(adw_master.object.imp_total 	[1])
ls_moneda			= adw_master.object.cod_moneda		[1]
ldc_tasa_cambio 	= Dec(adw_master.object.tasa_cambio	[1]) 

if ls_moneda = gnvo_app.is_soles then
	ldc_limite = idc_limite_sol
else
	ldc_limite = idc_limite_dol
end if

if ldc_imp_total < ldc_limite then return true

//Busco ahora si que hay algun documento de cobranza coactiva y acumulo la cantidad
ldc_imp_cobranza = 0
ls_moneda_coba = ''
for ll_i = 1 to adw_detail.RowCount()
	ls_moneda_det 		= adw_detail.object.cod_moneda 	[ll_i]
	ls_tipo_doc			= adw_detail.object.tipo_doc	 	[ll_i]
	ldc_importe_det 	= Dec(adw_detail.object.importe	[ll_i]) 
	
	if trim(ls_tipo_doc) = trim(is_doc_coba) then
		if trim(ls_moneda_coba) = '' then
			ls_moneda_coba = ls_moneda_det
			ldc_imp_cobranza += ldc_importe_det
		else
			if ls_moneda_coba = ls_moneda_det then
				ldc_imp_cobranza += ldc_importe_det
			elseif ls_moneda_det = gnvo_app.is_soles then
				ldc_imp_cobranza += ldc_importe_det / ldc_tasa_cambio
			else
				ldc_imp_cobranza += ldc_importe_det * ldc_tasa_cambio
			end if
		end if
	end if
next

if ldc_imp_cobranza > 0 then
	if MessageBox('Aviso', 'Esta aplicando una cobranza coactiva de ' + trim(ls_moneda_coba) + ' ' &
							+ string(ldc_imp_cobranza, '###,##0.00') +  '. ' &
							+ '~r~n¿Es correcta la información?', Information!, Yesno!, 1) = 2 then return false
else
	if MessageBox('Aviso', 'Esta cartera de pagos supera el límite de ' + trim(ls_moneda) + ' ' &
							+ string(ldc_limite, '###,##0.00') +  '. Revise en SUNAT si tiene Resolución de Cobranza coactiva y responda la pregunta.' &
							+ '~r~n¿Este proveedor tiene cobranza coactiva?', Information!, Yesno!, 1) = 1 then 
							
		ROLLBACK;
		gnvo_app.of_mensaje_error( "No se puede continuar con la grabación de la Cartera de pagos hasta que registre la cobranza coactiva")
		return false
	end if
							
end if

return true
end function

public function boolean of_eliminina_deuda_financiera (u_dw_abc adw_master);String	ls_origen_cb, ls_mensaje
Long		ll_nro_reg_cb

if adw_master.RowCount() = 0 then return false

ls_origen_cb	= adw_master.object.origen 				[1]
ll_nro_reg_cb	= Long(adw_master.object.nro_registro	[1])

//ELIMINA DATOS DE DEUDA FINANCIERA
delete from deuda_fin_det_cja_ban_det 
 where origen 			   = :ls_origen_cb  
   and nro_registro_cja = :ll_nro_reg_cb;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_app.of_message_error('Error al Eliminar deuda financiera, tabla deuda_fin_det_cja_ban_det: ' + ls_mensaje)
	Return false
END IF

return true
end function

public function boolean of_elimina_cheque (u_dw_abc adw_master);String	ls_mensaje
Long		ll_nro_reg_ch

if adw_master.RowCount() = 0 then return false

ll_nro_reg_ch	= Long(adw_master.object.reg_cheque		[1])

//Elimina el cheque
/*Replicacion*/
UPDATE cheque_emitir
   SET flag_estado = '0' ,
	    importe = 0.00 ,
		 flag_replicacion = '1'
 WHERE nro_registro = :ll_nro_reg_ch;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	gnvo_app.of_message_error("Error al anular cheque; Tabla cheque_emitir. Error: "+ ls_mensaje)
	Return false
END IF

return true
end function

public function decimal of_tasa_cambio (date ad_fecha);decimal 	ldc_tasa_cambio

select vta_dol_prom
	into :ldc_tasa_cambio
from calendario
where trunc(fecha) = trunc(:ad_fecha);

//En caso de no existir tipo de cambio de la fecha, tomo el ultimo tipo de cambio menor a la fecha indicada
if SQLCA.SQLCode = 100 then
	select vta_dol_prom
		into :ldc_tasa_cambio
	from calendario
	where trunc(fecha) < trunc(:ad_fecha)
	order by fecha desc;
	
end if

if IsNull(ldc_tasa_cambio) then ldc_tasa_cambio = 0

return ldc_tasa_cambio
end function

public function str_cliente of_get_cliente ();str_cliente lstr_return

Open(w_search_clientes)

if IsValid(Message.PowerObjectParm) and not isNull(Message.PowerObjectParm) then
	lstr_return = Message.PowerObjectParm
else
	lstr_return.b_return = false
end if

return lstr_return
end function

public function str_cliente of_get_cliente (string as_tipo_doc);str_cliente 	lstr_return
str_parametros lsrt_param

lsrt_param.tipo_doc = as_tipo_doc

OpenWithParm(w_search_clientes, lsrt_param)

if IsValid(Message.PowerObjectParm) and not isNull(Message.PowerObjectParm) then
	lstr_return = Message.PowerObjectParm
else
	lstr_return.b_return = false
end if

return lstr_return
end function

public function string of_desc_cred_fiscal (string as_cred_fiscal);String ls_return

select descripcion
	into :ls_return
from credito_fiscal
where tipo_cred_fiscal = :as_cred_fiscal;

return ls_return
end function

public function str_cliente of_get_cliente (string as_tipo_doc, string as_serie);str_cliente 	lstr_return
str_parametros lstr_param

lstr_param.tipo_doc 	= as_tipo_doc
lstr_param.serie		= as_serie	

OpenWithParm(w_search_clientes, lstr_param)

if IsValid(Message.PowerObjectParm) and not isNull(Message.PowerObjectParm) then
	lstr_return = Message.PowerObjectParm
else
	lstr_return.b_return = false
end if

return lstr_return
end function

public function decimal of_conv_mon (decimal adc_importe, string as_mon_org, string as_mon_dst, date ad_fecha);decimal 	ldc_precio
String	ls_mensaje

DECLARE usf_fl_conv_mon PROCEDURE FOR 
	usf_fl_conv_mon(:adc_importe, 
						 :as_mon_org, 
						 :as_mon_dst, 
						 :ad_fecha) ;
	
EXECUTE usf_fl_conv_mon;		

if sqlca.sqlcode <> 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	messagebox( "Error ", "Error en FUNCTION usf_fl_conv_mon. Mensaje: " + ls_mensaje, StopSign!)
	return -1
end if

Fetch usf_fl_conv_mon into :ldc_precio;	
close usf_fl_conv_mon;

return ldc_precio
end function

public function boolean of_actualiza_saldo_cc ();String	ls_mensaje, ls_nada

//procedure of_actualiza_saldo_cc(
//	 asi_nada in varchar2
//) is
  
DECLARE of_actualiza_saldo_cc PROCEDURE FOR 
	PKG_SIGRE_FINANZAS.of_actualiza_saldo_cc(:ls_nada);
	
EXECUTE of_actualiza_saldo_cc;		

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	messagebox( "Error ", "Error en PROCEDURE PKG_SIGRE_FINANZAS.of_actualiza_saldo_cc(). Mensaje: " + ls_mensaje, StopSign!)
	return false
end if

close of_actualiza_saldo_cc;

return true

end function

public function boolean of_actualiza_saldo_cp ();String	ls_mensaje, ls_nada

//procedure of_actualiza_saldo_cp(
//	 asi_nada in varchar2
//) is
  
DECLARE of_actualiza_saldo_cp PROCEDURE FOR 
	PKG_SIGRE_FINANZAS.of_actualiza_saldo_cp(:ls_nada);
	
EXECUTE of_actualiza_saldo_cp;		

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	messagebox( "Error ", "Error en PROCEDURE PKG_SIGRE_FINANZAS.of_actualiza_saldo_cp(). Mensaje: " + ls_mensaje, StopSign!)
	return false
end if

close of_actualiza_saldo_cp;

return true

end function

public function boolean of_validar_rcem (u_dw_abc adw_master, u_dw_abc adw_detail);Decimal		ldc_tasa_cambio, ldc_uit, ldc_imp_cobranza, &
				ldc_soles, ldc_importe, ldc_max_imp_rcem_cp, ldc_max_imp_rcem_rh
String		ls_moneda, ls_flag_estado, ls_mensaje, ls_moneda_det, ls_tipo_doc, ls_moneda_recm, &
				ls_cod_relacion
date			ld_fec_pago
Long			ll_i
n_cst_rcem	lnvo_rcem

//Procedimiento de la Resolucion de Cobranza Coactiva
if is_flag_cobranza_coac = '0' then return true

if adw_master.RowCount() = 0 then 
	MessageBox('Error', 'La cabecera del documento debe tener al menos un regristro', StopSign!)
	return false
end if

if adw_detail.RowCount() = 0 then 
	MessageBox('Error', 'La operacion de TESORERIA debe tener al menos un documento', StopSign!)
	return false
end if

ls_flag_estado = adw_master.object.flag_estado [1]

if ls_flag_estado = '0' then return false

ls_moneda			= adw_master.object.cod_moneda			[1]
ldc_tasa_cambio 	= Dec(adw_master.object.tasa_cambio		[1]) 
ld_fec_pago			= Date(adw_master.object.fecha_emision	[1]) 

//Obtengo la UIT
select importe
  into :ldc_uit
  from uit
 where fec_ini_vigen <= trunc(:ld_fec_pago)
   and to_char(fec_ini_vigen, 'yyyy' ) = to_char(:ld_fec_pago, 'yyyy')
   and rownum = 1
order by fec_ini_vigen desc;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al obtener la UIT de la consulta. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Calculo el importe limite para cada 
ldc_max_imp_rcem_cp = round(idc_porc_embargo_cp * ldc_uit, 0)
ldc_max_imp_rcem_rh = round(idc_porc_embargo_rh * ldc_uit, 0)

ldc_imp_cobranza = 0
//Obtengo el total del importe en ambas
for ll_i = 1 to adw_detail.RowCount()
	ls_moneda_det 		= adw_detail.object.cod_moneda 	[ll_i]
	ls_tipo_doc			= adw_detail.object.tipo_doc	 	[ll_i]
	ls_cod_relacion	= adw_detail.object.cod_relacion	[ll_i]
	ldc_importe			= Dec(adw_detail.object.importe	[ll_i])
	
	if ls_moneda_det = gnvo_app.is_soles then
		ldc_soles = ldc_importe * ldc_tasa_cambio
	else
		ldc_soles = ldc_importe
	end if
	
	if ls_tipo_doc = is_doc_fap or ls_tipo_doc = is_doc_bvp then
		
		if not lnvo_rcem.add(ls_cod_relacion, ldc_soles, 0) then return false
		
	elseif ls_tipo_doc = is_doc_rh then
		
		if not lnvo_rcem.add(ls_cod_relacion, 0, ldc_soles) then return false
		
	elseif ls_tipo_doc = is_doc_rcem then
		
		ls_moneda_recm = ls_moneda_det
		ldc_imp_cobranza += ldc_importe
		
	end if
next



if ldc_imp_cobranza > 0 then
	if MessageBox('Aviso', 'Esta aplicando una cobranza coactiva de ' + trim(ls_moneda_recm) + ' ' &
							+ string(ldc_imp_cobranza, '###,##0.00') +  '. ' &
							+ '~r~n¿Es correcta la información?', Information!, Yesno!, 1) = 2 then return false
else
	for ll_i = 1 to lnvo_rcem.size()
		
		if lnvo_rcem.get_importe_cp(ll_i) >= ldc_max_imp_rcem_cp then
			
			if MessageBox('Aviso', 'En esta cartera de pagos, el PROVEEDOR ' + lnvo_rcem.get_ruc(ll_i) + ' - ' &
										+ lnvo_rcem.get_nom_proveedor(ll_i) + ', supera el límite de ' + trim(gnvo_app.is_soles) &
										+ ' ' + string(ldc_max_imp_rcem_cp, '###,##0.00') &
										+ '. Revise en SUNAT si tiene Resolución de Cobranza coactiva y responda ' &
										+ 'la pregunta.' &
									+ '~r~n¿Este proveedor tiene cobranza coactiva?', Information!, Yesno!, 1) = 1 then 
									
				ROLLBACK;
				gnvo_app.of_mensaje_error( "No se puede continuar con la grabación de la Cartera de pagos hasta que registre " &
												 + "la cobranza coactiva")
				return false
			end if
			
		elseif lnvo_rcem.get_importe_rh(ll_i) >= ldc_max_imp_rcem_rh then
			
			if MessageBox('Aviso', 'En esta cartera de pagos, el PROVEEDOR ' + lnvo_rcem.get_ruc(ll_i) + ' - ' &
										+ lnvo_rcem.get_nom_proveedor(ll_i) + ', supera el límite de ' + trim(gnvo_app.is_soles) &
										+ ' ' + string(ldc_max_imp_rcem_rh, '###,##0.00') &
										+ '. Revise en SUNAT si tiene Resolución de Cobranza coactiva y responda ' &
										+ 'la pregunta.' &
									+ '~r~n¿Este proveedor tiene cobranza coactiva?', Information!, Yesno!, 1) = 1 then 
									
				ROLLBACK;
				gnvo_app.of_mensaje_error( "No se puede continuar con la grabación de la Cartera de pagos hasta que registre " &
												 + "la cobranza coactiva")
				return false
			end if
			
		end if
	next

					
end if

return true
end function

public function boolean of_generar_txt_recm (u_dw_abc adw_master, u_dw_abc adw_detail, ref string aso_filename_txt);Decimal		ldc_tasa_cambio, ldc_uit, ldc_imp_cobranza, &
				ldc_soles, ldc_importe, ldc_max_imp_rcem_cp, ldc_max_imp_rcem_rh
String		ls_flag_estado, ls_mensaje, ls_moneda_det, ls_tipo_doc, ls_moneda_recm, &
				ls_cod_relacion
date			ld_fec_pago
Long			ll_i
n_cst_rcem	lnvo_rcem

//Procedimiento de la Resolucion de Cobranza Coactiva
if is_flag_cobranza_coac = '0' then return true

if adw_master.RowCount() = 0 then 
	MessageBox('Error', 'La cabecera del documento debe tener al menos un regristro', StopSign!)
	return false
end if

if adw_detail.RowCount() = 0 then 
	MessageBox('Error', 'La operacion de TESORERIA debe tener al menos un documento', StopSign!)
	return false
end if

ls_flag_estado 	= adw_master.object.flag_estado 			[1]
ldc_tasa_cambio 	= Dec(adw_master.object.tasa_cambio		[1]) 
ld_fec_pago			= Date(adw_master.object.fecha_emision	[1]) 

if ls_flag_estado = '0' then return false

//Obtengo la UIT
select importe
  into :ldc_uit
  from uit
 where fec_ini_vigen <= trunc(:ld_fec_pago)
   and to_char(fec_ini_vigen, 'yyyy' ) = to_char(:ld_fec_pago, 'yyyy')
   and rownum = 1
order by fec_ini_vigen desc;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al obtener la UIT de la consulta. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Calculo el importe limite para cada 
ldc_max_imp_rcem_cp = round(idc_porc_embargo_cp * ldc_uit, 0)
ldc_max_imp_rcem_rh = round(idc_porc_embargo_rh * ldc_uit, 0)

//Obtengo el total del importe en ambas
for ll_i = 1 to adw_detail.RowCount()
	ls_moneda_det 		= adw_detail.object.cod_moneda 	[ll_i]
	ls_tipo_doc			= adw_detail.object.tipo_doc	 	[ll_i]
	ls_cod_relacion	= adw_detail.object.cod_relacion	[ll_i]
	ldc_importe			= Dec(adw_detail.object.importe	[ll_i])
	
	if ls_moneda_det = gnvo_app.is_soles then
		ldc_soles = ldc_importe * ldc_tasa_cambio
	else
		ldc_soles = ldc_importe
	end if
	
	if ls_tipo_doc = is_doc_fap or ls_tipo_doc = is_doc_bvp then
		
		lnvo_rcem.add(ls_cod_relacion, ldc_soles, 0)
		
	elseif ls_tipo_doc = is_doc_rh then
		
		lnvo_rcem.add(ls_cod_relacion, 0, ldc_soles)
		
	end if
next

if lnvo_rcem.size() > 0 then
	aso_filename_txt = lnvo_rcem.of_create_txt(ld_fec_pago)
end if

if IsNull(aso_filename_txt) or trim(aso_filename_txt) = '' then
	
	return false
	
end if



return true
end function

on n_cst_finanzas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_finanzas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//this.of_load( )
ids_boletas = create u_ds_base

invo_xml = create n_cst_xml
invo_numlet = create n_cst_numlet

end event

event destructor;destroy ids_boletas

destroy invo_xml
destroy invo_numlet
end event

