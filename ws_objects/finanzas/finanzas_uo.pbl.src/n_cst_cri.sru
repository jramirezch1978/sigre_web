$PBExportHeader$n_cst_cri.sru
forward
global type n_cst_cri from nonvisualobject
end type
end forward

global type n_cst_cri from nonvisualobject
end type
global n_cst_cri n_cst_cri

type variables
Public:
String 	is_nro_certificado, is_origen, is_flag_estado, is_flag_tabla, is_cod_relacion
Date		id_fecha_emision
Decimal	idc_saldo_sol, idc_saldo_dol, idc_importe_doc, idc_tasa_cambio

end variables

forward prototypes
public function boolean of_print (string as_origen, long al_nro_registro)
public function boolean of_update ()
public function boolean of_update (u_dw_abc adw_master, u_dw_abc adw_detail, datastore ads_crelacion_cri)
public function boolean of_pagado (string as_nro_cri)
public function boolean of_print (string as_origen, long al_nro_registro, str_parametros astr_param)
public function boolean of_print (string as_nro_certificado, str_parametros astr_param)
public function boolean of_liberar_cri (u_dw_abc adw_master)
public function boolean of_get_nro_cri (string as_nro_serie, ref string as_nro_doc) throws exception
end prototypes

public function boolean of_print (string as_origen, long al_nro_registro);Long 				ll_count
String			ls_nro_certificado
u_ds_base		lds_voucher
str_parametros	lstr_param

try 
	lds_voucher = create u_ds_base
	
	/*verifico si existe mas de un comprobante de retencion	*/
		select count(*) 
			into :ll_count 
		from retencion_igv_crt 
		where origen			  = :as_origen      
		  and nro_reg_caja_ban = :al_nro_registro;
	
		if ll_count > 1 then
			Open(w_pop_comprobante_ret)
			//*Datos Recuperados  *//
			IF isvalid(message.PowerObjectParm) THEN
				lstr_param = message.PowerObjectParm
				ls_nro_certificado = lstr_param.string1
			END IF	
		elseif ll_count = 1 then
			select nro_certificado 
				into :ls_nro_certificado 
			from retencion_igv_crt 
			where origen				 = :as_origen      
			  and nro_reg_caja_ban = :al_nro_registro;
		end if
		
		
		
		/*IMPRESION LOCAL */
		if gs_empresa = "BLUEWAVE" or gs_empresa = "PEZEX" or gs_empresa = "CEPIBO" then
			lds_voucher.dataobject =  'd_rpt_formato_ret_bluewave_igv_tbl'		
		ELSEIF gs_empresa = 'CANTABRIA' then
			lds_voucher.dataobject =  'd_rpt_formato_ret_cantabria_igv_tbl'		
		else
			lds_voucher.dataobject =  'd_rpt_formato_retencion_igv_tbl'		
		end if
		
		lds_voucher.Settransobject(sqlca)
		lds_voucher.Retrieve(ls_nro_certificado)
		
		if lds_voucher.RowCount( ) > 0 then
			lds_voucher.Print(True)	
		else
			MessageBox('Error', 'La retencion ' + ls_nro_certificado + ' no tiene registros, por favor verificar')
		end if
		
		return true
		
catch ( Exception ex )
	f_mensaje("Error al momento de imprimir el Certificado de retención. Error: " + ex.getMessage(), "")
	return false
	
finally
	destroy lds_voucher
end try


end function

public function boolean of_update ();Long ll_count

if not this.of_pagado(is_nro_certificado) then return false

select count(*)
  into :ll_count
 from retencion_igv_crt
 where nro_certificado = :is_nro_Certificado;
 
if ll_count > 0 then
	update retencion_igv_crt
		set 	saldo_sol 		= :idc_saldo_sol,
				saldo_dol 		= :idc_saldo_dol,
				importe_doc		= :idc_importe_doc,
				flag_estado		= :is_flag_estado,
				flag_tabla		= :is_flag_tabla,
				proveedor		= :is_cod_relacion,
				tasa_cambio		= :idc_tasa_cambio,
				fec_registro	= sysdate,
				cod_usr			= :gs_user
		where nro_certificado = :is_nro_Certificado;
else

	Insert Into retencion_igv_crt(
		nro_certificado 	,fecha_emision ,   
	 	origen			  	,flag_estado   ,
	 	flag_tabla		  	,importe_doc	,
	 	saldo_sol		  	,saldo_dol 	  	,
	 	proveedor			,tasa_cambio	,
		cod_usr				,fec_registro	)  
	Values(
		:is_nro_certificado 	,:id_fecha_emision  ,
	 	:is_origen          	,:is_flag_estado    ,
	 	:is_flag_tabla			,:idc_saldo_sol     ,
	 	:idc_saldo_sol	   	,:idc_saldo_dol     ,
	 	:is_cod_relacion		,:idc_tasa_cambio	  ,
		:gs_user					,sysdate)  ;

end if
		
IF gnvo_app.of_existserror( SQLCA, 'Actualizar datos de CRI: ' + is_nro_certificado) THEN 
	Rollback ;
	return false
END IF


Return true
end function

public function boolean of_update (u_dw_abc adw_master, u_dw_abc adw_detail, datastore ads_crelacion_cri);String 	ls_cod_relacion,ls_nro_cr, ls_flag_retencion, ls_origen, ls_expresion ,ls_order
Long   	ll_inicio, ll_nro_registro, ll_row, ll_count
Boolean 	lb_ret = true
Decimal	ldc_tasa_cambio, ldc_impt_ret_igv, ldc_imp_ret_sol, ldc_imp_ret_dol
Date		ld_fecha_emision

if adw_master.getRow() = 0 then return true
ls_nro_cr 			= adw_master.object.nro_certificado [adw_master.getRow()]

if IsNull(ls_nro_cr) or ls_nro_cr = "" then return true

//Verifico si el CRI esta pagado o no, sino no se puede hacer nada
if not this.of_pagado(ls_nro_cr) then return false

ll_nro_registro   = adw_master.object.nro_registro   		[adw_master.getRow()]
ls_origen 		   = adw_master.object.origen			 		[adw_master.getRow()]
ls_flag_retencion = adw_master.object.flag_retencion 		[adw_master.getRow()]
ld_fecha_emision	= Date(adw_master.object.fecha_emision [adw_master.getRow()])
ldc_tasa_cambio	= adw_master.object.tasa_cambio	 		[adw_master.getRow()]

if ldc_tasa_cambio = 0 or IsNull(ldc_tasa_cambio) then
	MessageBox('Error', 'No se ha especificado una tasa de cambio, por favor verifique')
	adw_master.setColumn('tasa_cambio')
	adw_master.setFocus()
	return false
end if

if ls_flag_retencion = '0' then
	
	update retencion_igv_crt
		set 	importe_doc	= 0,
				flag_estado	= '0'
		where nro_certificado = :ls_nro_cr;
	
	IF gnvo_app.of_existsError(SQLCA, "anular el retencion_igv_crt") THEN 
		ROLLBACK;
		return false
	END IF
else
	FOR ll_inicio = 1 TO ads_crelacion_cri.Rowcount()
		ls_cod_relacion = ads_crelacion_cri.object.cod_relacion [ll_inicio]
	 
		/*encontrar monto de cri x proveedor*/
		ldc_imp_ret_sol = 0.00 
		ldc_imp_ret_dol = 0.00

		For ll_row = 1 TO adw_detail.Rowcount()
			if (adw_detail.object.cod_relacion [ll_row] = ls_cod_relacion) then
	 			ldc_impt_ret_igv = Dec(adw_detail.object.impt_ret_igv [ll_row])
	 			IF Isnull(ldc_impt_ret_igv) THEN ldc_impt_ret_igv = 0.00
	 			ldc_imp_ret_sol += ldc_impt_ret_igv
			end if
		Next	
		ldc_imp_ret_dol = Round(ldc_imp_ret_sol / ldc_tasa_cambio ,2)
		
		/* Se actualiza el comprobante o se inserta dependiendo del tema*/
		select count(*)
			into :ll_count
		from retencion_igv_crt
		where nro_certificado = :ls_nro_cr;
		
		if ll_count = 0 then
			/*SE GENERA COMPROBANTE DE RETENCION*/
			INSERT INTO retencion_igv_crt	(
				nro_certificado,	fecha_emision,		origen          ,		nro_reg_caja_ban,
				proveedor      ,	flag_estado  ,		flag_tabla      ,		importe_doc     ,
				saldo_sol		,	saldo_dol    ,		flag_replicacion,		tasa_cambio		 ,
				cod_usr			, fec_registro)  
			VALUES(
				:ls_nro_cr     ,	:ld_fecha_emision,	:ls_origen,		:ll_nro_registro,
				:ls_cod_relacion,	'1'			  	  ,	'5',				:ldc_imp_ret_sol,
				:ldc_imp_ret_sol,	:ldc_imp_ret_dol ,	'1'		 ,		:ldc_tasa_cambio,
				:gs_user			 ,	sysdate)  ;

			IF gnvo_app.of_existsError(SQLCA, "Insert en retencion_igv_crt Nro: " + ls_nro_cr) THEN 
				ROLLBACK;
				return false
			END IF
		else
			update retencion_igv_crt
				set 	fecha_emision 	= :ld_fecha_emision,
						importe_doc		= :ldc_imp_ret_sol,
						saldo_sol		= :ldc_imp_ret_sol,
						saldo_dol		= :ldc_imp_ret_dol,
						tasa_cambio		= :ldc_tasa_cambio,
						cod_usr			= :gs_user
				where nro_certificado = :ls_nro_cr;
			
			IF gnvo_app.of_existsError(SQLCA, "Update en retencion_igv_crt Nro: " + ls_nro_cr) THEN 
				ROLLBACK;
				return false
			END IF

		end if
	NEXT
	
end if



Return lb_ret

end function

public function boolean of_pagado (string as_nro_cri);Long		ll_count
String	ls_voucher, ls_user
Date		ld_fecha

select count(*)
	into :ll_count
from caja_bancos_det cbd,
     caja_bancos     cb
where cb.origen       = cbd.origen
  and cb.nro_registro = cbd.nro_registro
  and cb.flag_estado  <> '0'
  and cbd.tipo_doc    = :gnvo_app.is_doc_ret
  and cbd.nro_doc		 = :as_nro_cri;

if ll_count > 0 then
	select 	cb.origen || trim(to_char(cb.ano, '0000')) || trim(to_char(cb.mes, '00')) || trim(to_char(cb.nro_libro, '00')) || trim(to_char(cb.nro_asiento, '000000')) , 
				cb.cod_usr,
				cb.fecha_emision
		into :ls_voucher, :ls_user, :ld_fecha
	from caja_bancos_det cbd,
		  caja_bancos     cb
	where cb.origen       = cbd.origen
	  and cb.nro_registro = cbd.nro_registro
	  and cb.flag_estado  <> '0'
	  and cbd.tipo_doc    = :gnvo_app.is_doc_ret
	  and cbd.nro_doc		 = :as_nro_cri;

	MessageBox('Error', 'El comprobante de Retención tiene movimiento en Caja y Bancos, por lo que no se puede modificar' &
				+ "~r~Fecha Pago: " + string(ld_fecha, 'dd/mm/yyyy') &
				+ "~r~nVoucher: " + ls_voucher &
				+ "~r~Usuario: " + ls_user )
	return false
end if

return true
end function

public function boolean of_print (string as_origen, long al_nro_registro, str_parametros astr_param);Long 				ll_count
String			ls_nro_certificado, ls_dataobject
u_ds_base		lds_voucher
str_parametros	lstr_param

try 
	lds_voucher = create u_ds_base
	
	/*verifico si existe mas de un comprobante de retencion	*/
		select count(*) 
			into :ll_count 
		from retencion_igv_crt 
		where origen			  = :as_origen      
		  and nro_reg_caja_ban = :al_nro_registro;
	
		if ll_count > 1 then
			Open(w_pop_comprobante_ret)
			//*Datos Recuperados  *//
			IF isvalid(message.PowerObjectParm) THEN
				lstr_param = message.PowerObjectParm
				ls_nro_certificado = lstr_param.string1
			END IF	
		elseif ll_count = 1 then
			select nro_certificado 
				into :ls_nro_certificado 
			from retencion_igv_crt 
			where origen				 = :as_origen      
			  and nro_reg_caja_ban = :al_nro_registro;
		end if
		
		
		
		/*IMPRESION LOCAL */
		if gs_empresa = "BLUEWAVE" or gs_empresa = "PEZEX"  then
			ls_dataobject =  'd_rpt_formato_ret_bluewave_igv_tbl'		
		elseif gs_empresa = "CEPIBO" then
			ls_dataobject =  'd_rpt_formato_ret_cepibo_igv_tbl'	
		elseif gs_empresa = "CANTABRIA" then
			ls_dataobject =  'd_rpt_formato_ret_cantabria_igv_tbl'	
		else
			ls_dataobject =  'd_rpt_formato_retencion_igv_tbl'		
		end if

		if astr_param.i_return = 1 then
			lds_voucher.dataobject = ls_dataobject
			lds_voucher.Settransobject(sqlca)
			lds_voucher.Retrieve(ls_nro_certificado)
			
			if lds_voucher.RowCount( ) > 0 then
				lds_voucher.Print(True)	
			else
				MessageBox('Error', 'La retencion ' + ls_nro_certificado + ' no tiene registros, por favor verificar')
			end if
		else
			lstr_param.dw1 		= ls_dataobject
			lstr_param.titulo 	= 'Previo de Comprobante de Retencion: [' + ls_nro_certificado + "]"
			lstr_param.tipo		= '1S'
			lstr_param.string1	= ls_nro_certificado
			
			if gs_empresa = "CEPIBO" or gs_empresa = "CANTABRIA" then
				lstr_param.paper_size = 1  //Letter
			end if

			OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
			
		end if
		
		return true
		
catch ( Exception ex )
	f_mensaje("Error al momento de imprimir el Certificado de retención. Error: " + ex.getMessage(), "")
	return false
	
finally
	destroy lds_voucher
end try


end function

public function boolean of_print (string as_nro_certificado, str_parametros astr_param);Long 				ll_count
u_ds_base		lds_voucher
String			ls_dataobject
str_parametros	lstr_param

try 
	lds_voucher = create u_ds_base
	
	if gs_empresa = "BLUEWAVE" or gs_empresa = "PEZEX" or trim(gs_empresa) = "CEPIBO" then
		
		ls_dataobject =  'd_rpt_formato_ret_igv_ltp_pezex_tbl'	
		
	elseif gs_empresa = "CANTABRIA" then
		
		ls_dataobject =  'd_rpt_formato_ret_igv_ltp_cantabria_tbl'	
		
	else
		
		ls_dataobject =  'd_rpt_formato_retencion_igv_x_letra_tbl'	
		
	end if

	if astr_param.i_return = 1 then
		lds_voucher.dataobject = ls_dataobject
		lds_voucher.Settransobject(sqlca)
		lds_voucher.Retrieve(as_nro_certificado)
		
		if lds_voucher.RowCount( ) > 0 then
			lds_voucher.Print(True)	
		else
			MessageBox('Error', 'La retencion ' + as_nro_certificado + ' no tiene registros, por favor verificar')
		end if
	else
		lstr_param.dw1 		= ls_dataobject
		lstr_param.titulo 	= 'Previo de Comprobante de Retencion: [' + as_nro_certificado + "]"
		lstr_param.tipo		= '1S'
		lstr_param.string1	= as_nro_certificado

		OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
		
	end if
	
	return true
		
catch ( Exception ex )
	f_mensaje("Error al momento de imprimir el Certificado de retención. Error: " + ex.getMessage(), "")
	return false
	
finally
	destroy lds_voucher
end try


//IF cbx_preview.Checked THEN
//	lstr_cns_pop.arg[3] = 'd_rpt_retencion_igv_x_letra_preview_tbl'
//	lstr_cns_pop.arg[1] = ls_nro_certificado
//	//COMPROBANTE DE RETENCION
//	OpenSheetWithParm(w_fi744_preview_cri_cletra, lstr_cns_pop, this, 2, Layered!)
//
//	
//ELSE	
//	IF rb_1.checked THEN  //comprobante de retencion (formato lima / paramonga)
//		if rb_1.checked then //formato lima
//			dw_rpt.dataobject = 'd_rpt_formato_retencion_igv_x_letra_tbl'	
//		end if
//	
//		dw_rpt.settransobject(sqlca)
//	
//		/*Verificación de comprobante de retencion*/
//	   IF Isnull(ls_nro_certificado) OR Trim(ls_nro_certificado) = '' THEN	RETURN	 
//	
//		dw_rpt.retrieve(ls_nro_certificado)
//	
//	
//		OpenWithParm(w_print_opt, dw_rpt)
//		ldb_rc = Message.DoubleParm
//		IF Message.DoubleParm <> -1 Then dw_rpt.Print(True)
//	
//	ELSEIF rb_3.checked THEN
//		OpenSheetWithParm(w_rpt_canje_letra, lstr_cns_pop, this, 2, Original!)
//	
//	ELSE
//		Messagebox('Aviso','Debe Seleccionar un tipo de Impresión')
//	END IF	
//END IF

end function

public function boolean of_liberar_cri (u_dw_abc adw_master);//Este Procedimiento pregunta si desea liberar o no el comprobante de retencion asociado 
//con la cartera de pagos 
String 	ls_nro_cri, ls_origen, ls_mensaje
Long		ll_nro_reg

if adw_master.RowCount() = 0 then return true

ls_origen 	= adw_master.object.origen 				[1]
ll_nro_reg	= Long(adw_master.object.nro_registro	[1])

select nro_certificado
	into :ls_nro_cri
from retencion_igv_crt t
where t.origen 					= :ls_origen
  and t.nro_reg_caja_ban	= :ll_nro_reg;
 
//Si no tiene comprobante de retencion simplemente ya no hago nada
if SQLCA.SQLCOde = 100 then return true

if MessageBox('Information', 'El registro de cartera de pagos tiene asociado el Comprobante de retención ' + ls_nro_cri + '.' &
									+ '~r~n¿Desea Liberarlo?', Information!, YesNo!, 2) = 2 then return true

delete retencion_igv_crt t
where t.origen 					= :ls_origen
  and t.nro_reg_caja_ban	= :ll_nro_reg;
  
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MEssageBox("Error", "Ha ocurrido un error al eliminar comprobante en tabla retencion_igv_crt. Mensaje: " + ls_mensaje, StopSign!)
	return false
end if

return true

end function

public function boolean of_get_nro_cri (string as_nro_serie, ref string as_nro_doc) throws exception;Long    ll_nro_doc
Integer li_dig_serie,li_dig_numero, li_count
String  ls_nro_doc, ls_doc_cri, ls_mensaje
str_parametros lstr_param
Exception 		ex

/*Archivo de Parametros*/
SELECT doc_ret_igv_crt
  INTO :ls_doc_cri
  FROM finparam
 WHERE (reckey = '1')  ;
 
 li_dig_serie = 4
 li_dig_numero = 5

//Primero Genero el numero correlativo según lo que hay
SELECT ultimo_numero
  INTO :ll_nro_doc
  FROM num_doc_tipo
 WHERE ((tipo_doc  = :ls_doc_cri   )  AND
 		  (nro_serie = :as_nro_serie ));

if SQLCA.SQLCode = 100 then
	ll_nro_doc = 1
end if

ls_nro_doc = f_llena_caracteres('0',Trim(as_nro_serie),li_dig_serie)+'-'+ f_llena_caracteres('0',Trim(String(ll_nro_doc)),li_dig_numero)
lstr_param.string1 = ls_nro_doc
OpenWithParm(w_nro_retencion, lstr_param)

lstr_param = Message.PowerObjectParm
if lstr_param.i_return < 0 then
	ROLLBACK;
	return false
end if

if lstr_param.boolean1 then
	as_nro_doc = lstr_param.string1
else
	//*Genero Comprobate de Retencion*/
	SELECT ultimo_numero
	  INTO :ll_nro_doc
	  FROM num_doc_tipo
	 WHERE ((tipo_doc  = :ls_doc_cri   )  AND
			  (nro_serie = :as_nro_serie )) 
	FOR UPDATE;
		
	if SQLCA.SQLCode = 100 then
		insert into num_doc_tipo(tipo_doc, nro_serie, ultimo_numero)
		values(:ls_doc_cri, :as_nro_serie, 1);
		
		ll_nro_doc = 1
		
	end if
	
	//****************************//
	//Actualiza Tabla num_doc_tipo//
	//****************************//
		
	UPDATE num_doc_tipo
	 SET ultimo_numero = :ll_nro_doc + 1
	WHERE ((tipo_doc  = :ls_doc_cri   )) AND
			(nro_serie = :as_nro_serie ) ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ROLLBACK;
		ls_mensaje = 'No se Pudo Actualizar Tabla num_doc_tipo por Tipo de Documento Ha Generar, Verifique!'
		ex = create Exception
		throw ex
		return false
	end if
	/**/
	
	IF Isnull(li_dig_serie) OR li_dig_serie = 0 THEN
		ROLLBACK;
		ls_mensaje = 'Digitos Para Serie de Documento No ha sido inicializado en Tabla FINPARAM, Verifique!'
		ex = create Exception
		throw ex
		return false
	END IF

	IF Isnull(li_dig_numero) OR li_dig_numero = 0 THEN
		ROLLBACK;
		ls_mensaje = 'Digitos Para Numeros de Documento No ha sido inicializado en Tabla FINPARAM, Verifique!'
		ex = create Exception
		throw ex
		return false
	END IF

	as_nro_doc = f_llena_caracteres('0',Trim(as_nro_serie), li_dig_serie)+'-'+ f_llena_caracteres('0',Trim(String(ll_nro_doc)), li_dig_numero)
end if

select count(*)
	into :li_count
from retencion_igv_crt
where nro_certificado = :as_nro_doc;

if li_count > 0 then
	ROLLBACK;
	f_mensaje('El numero de Certificado de Retencion ' + as_nro_doc + ', ya existe, por favor verifique!','')
	return false
end if

Return true

end function

on n_cst_cri.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_cri.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

