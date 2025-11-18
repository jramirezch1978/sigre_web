$PBExportHeader$w_fi309_cartera_de_cobros.srw
forward
global type w_fi309_cartera_de_cobros from w_abc
end type
type sle_1 from singlelineedit within w_fi309_cartera_de_cobros
end type
type dw_rpt from datawindow within w_fi309_cartera_de_cobros
end type
type cb_2 from commandbutton within w_fi309_cartera_de_cobros
end type
type cbx_ref from checkbox within w_fi309_cartera_de_cobros
end type
type tab_1 from tab within w_fi309_cartera_de_cobros
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_asiento_det from u_dw_abc within tabpage_2
end type
type dw_asiento_cab from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_asiento_det dw_asiento_det
dw_asiento_cab dw_asiento_cab
end type
type tab_1 from tab within w_fi309_cartera_de_cobros
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_1 from commandbutton within w_fi309_cartera_de_cobros
end type
type dw_master from u_dw_abc within w_fi309_cartera_de_cobros
end type
type gb_2 from groupbox within w_fi309_cartera_de_cobros
end type
end forward

global type w_fi309_cartera_de_cobros from w_abc
integer width = 3872
integer height = 2152
string title = "Cartera de Cobros (FI309)"
string menuname = "m_mantenimiento_cl_tes_anular"
event ue_anular ( )
event ue_print_preview ( )
sle_1 sle_1
dw_rpt dw_rpt
cb_2 cb_2
cbx_ref cbx_ref
tab_1 tab_1
cb_1 cb_1
dw_master dw_master
gb_2 gb_2
end type
global w_fi309_cartera_de_cobros w_fi309_cartera_de_cobros

type variables
Boolean 			ib_estado_asiento = TRUE, ib_cierre = false
u_dw_abc			idw_detail, idw_asiento_cab, idw_asiento_det
u_ds_base 		ids_asiento_adic, ids_crelacion_ext_tbl
w_rpt_preview	iw_rpt[]

DatawindowChild 			idw_doc_tipo
n_cst_asiento_contable 	invo_asiento_cntbl
n_cst_caja_bancos			invo_caja_bancos



end variables

forward prototypes
public subroutine wf_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio)
public subroutine wf_verificacion_items_x_retencion ()
public subroutine wf_verificacion_retencion ()
public function boolean wf_genera_cretencion (long al_nro_serie, ref string as_mensaje, ref string as_nro_doc)
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado)
public function decimal wf_recalcular_monto_det ()
public function boolean wf_update_deuda_financiera ()
public subroutine of_asigna_dws ()
public function boolean of_generar_asiento ()
end prototypes

event ue_anular;Integer li_opcion
String  ls_flag_estado ,ls_origen_cb  ,ls_result     ,ls_mensaje ,ls_nro_planilla
Long    ll_row_master  ,ll_nro_reg_cb ,ll_nro_reg_ch ,ll_ano	 ,&
		  ll_mes			  ,ll_inicio	  ,ll_count	

ll_row_master  = dw_master.getrow()

if ll_row_master = 0 then return

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ls_origen_cb	= dw_master.Object.origen		  [ll_row_master]
ll_nro_reg_ch  = dw_master.Object.reg_cheque	  [ll_row_master]
ll_nro_reg_cb	= dw_master.Object.nro_registro [ll_row_master]
ls_flag_estado = dw_master.Object.flag_estado  [ll_row_master]
ll_ano			= dw_master.object.ano 			  [ll_row_master]
ll_mes			= dw_master.object.mes			  [ll_row_master]

IF ls_flag_estado <> '1' THEN
	Messagebox('Aviso','Registro Ha Sido Anulado ,Verifique!')
	Return
END IF

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'B') then return //movimiento bancario


IF (dw_master.ii_update = 1                      OR idw_detail.ii_update      = 1 OR &
    idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF	 


//planilla de cobranza
select Count(*)
  into :ll_count
  from pln_cobranza_dep
 where (org_caja_banc     = :ls_origen_cb  ) AND  
       (nro_reg_caja_banc = :ll_nro_reg_cb ) ;
		 
if ll_count > 0 then
	//recupera nro de planilla
	select nro_planilla into :ls_nro_planilla from pln_cobranza_dep
    where (org_caja_banc     = :ls_origen_cb  ) AND  
          (nro_reg_caja_banc = :ll_nro_reg_cb ) ;
	
	
	Messagebox('Aviso','No se puede Anular Registro de Cartera de Cobros ,'+&
							 'Esta Vinculada a Planilla de Cobranza '+ ls_nro_planilla)
							 
	RETURN							 
end if




//------------------------------------------------
li_opcion = MessageBox('Anula Cartera de Pagos','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN

//*****************************************************************//
//*actualizar flag de estado de comprobante de retencion y cheques*//
//*****************************************************************//
/*Replicacion*/
UPDATE retencion_igv_crt
   SET flag_estado = '0',flag_replicacion = '1'
 WHERE ((origen           = :ls_origen_cb ) AND
        (nro_reg_caja_ban = :ll_nro_reg_cb )) ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Update Retencion IGV CRT', SQLCA.SQLErrText)
	Return
END IF
	


//*****************************************************************//
//ELIMINA DATOS DE DEUDA FINANCIERA
delete from deuda_fin_det_cja_ban_det 
 where (origen 			 = :ls_origen_cb  ) and
 		 (nro_registro_cja = :ll_nro_reg_cb ) ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Delete Deuda Financiera', SQLCA.SQLErrText)
	Return
END IF



dw_master.object.flag_estado [ll_row_master] = '0'
dw_master.object.imp_total   [ll_row_master] = 0.00

DO WHILE idw_detail.Rowcount() > 0 
	idw_detail.TriggerEvent('ue_delete')
LOOP

FOR ll_inicio =1 TO idw_asiento_det.Rowcount() 
	 idw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 idw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT


dw_master.ii_update = 1
idw_asiento_det.ii_update = 1

TriggerEvent('ue_modify')
is_Action = 'delete'
/*No  Generación de Pre Asientos*/
ib_estado_asiento = FALSE
/**/
end event

event ue_print_preview();String      	ls_origen
Long				ll_nro_registro, ll_row, ll_index
str_parametros	lstr_param

//Debe grabar todos los cambios antes de imprimir
if dw_master.ii_update = 1 or idw_detail.ii_update = 1 or &
	idw_asiento_cab.ii_update = 1 or idw_asiento_det.ii_update = 1 then
	
	MessageBox('Aviso', 'Debe grabar los cambios antes de imprimir, por favor verifique!', StopSign!)
	return

end if

ll_row = dw_master.getRow()
if ll_row = 0 then 
	MessageBox('Aviso', 'La cabecera del documento no tiene registro alguno, por favor verifique!', StopSign!)
	return
end if

open(w_choice_cartera_cobros)
lstr_param = message.PowerObjectParm

if not lstr_param.b_return then return

//Obteniendo el nro de registro de caja
ls_origen	    = dw_master.object.origen       [ll_row]
ll_nro_registro = dw_master.object.nro_registro [ll_row]	

//ASignando el Datawindow adecuado
if lstr_param.i_return = 1 then
	if upper(gs_empresa) = 'SERVIMOTOR' then
		lstr_param.dw1 		= 'd_rpt_recibo_caja_servimotor_tbl'
	else
		lstr_param.dw1 		= 'd_rpt_recibo_caja_tbl'
	end if
	
	lstr_param.titulo 	= 'Previo de Recibo de Pago del Cliente'
	
elseif lstr_param.i_return = 2 then
	
	lstr_param.dw1 		= 'd_rpt_formato_voucher_cobrar'	
	lstr_param.titulo 	= 'Previo de Voucher'
	
elseif lstr_param.i_return = 3 then
	
	MessageBox('Aviso', 'El reporte de Cheque - Voucher no es viable para la CARTERA DE COBROS, ' &
							+ 'por favor verifique!', StopSign!)
	
end if


lstr_param.string1 	= ls_origen
lstr_param.Long1 		= ll_nro_registro
lstr_param.titulo		= 'CARTERA DE COBROS'
lstr_param.tipo		= '1S1L'

ll_index = UpperBound(iw_rpt)
ll_index ++
OpenSheetWithParm(iw_rpt[ll_index], lstr_param, w_main, 0, Layered!)


end event

public subroutine wf_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio);Long   ll_inicio
String ls_flag_provisionado

for ll_inicio = 1  to idw_detail.Rowcount()
	 ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
	 
	 idw_detail.object.cod_moneda_cab [ll_inicio] = as_moneda
	 idw_detail.object.tasa_cambio	 [ll_inicio] = adc_tasa_cambio
	 
	 //colocar moneda en el detalle cuando sea un ingreso indirecto
	 IF ls_flag_provisionado = 'N' THEN
		 idw_detail.object.cod_moneda [ll_inicio] = as_moneda
		 idw_detail.ii_update = 1	 
	 END IF
next


end subroutine

public subroutine wf_verificacion_items_x_retencion ();String ls_expresion,ls_flag_retencion
Long   ll_found,ll_row_master

ll_row_master = dw_master.getrow()
Setnull(ls_flag_retencion)


idw_detail.Accepttext()

ls_expresion = "flag_ret_igv = '1'"

ll_found = idw_detail.find(ls_expresion,1,idw_detail.rowcount())


IF ll_found > 0 THEN
	dw_master.object.flag_retencion [ll_row_master] = '1'
ELSE
	dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
END IF

dw_master.ii_update = 1
end subroutine

public subroutine wf_verificacion_retencion ();Long   ll_inicio,ll_found,ll_ins_new,ll_count,ll_inicio_det,ll_factor
String ls_cod_relacion,ls_expresion     ,ls_tipo_doc     ,ls_cadena  ,ls_soles     ,&
		 ls_dolares     ,ls_flag_retencion,ls_flag_ret_igv ,ls_nro_doc ,ls_cod_moneda,&
		 ls_flag_impuesto,ls_doc_gr_ret
Decimal 	ldc_imp_min_ret_igv,ldc_porc_ret_igv   ,ldc_imp_pagar    ,ldc_total_pagar,&
			ldc_imp_total      ,ldc_imp_total_pagar,ldc_imp_retencion, ldc_tasa_cambio
Boolean     lb_flag = FALSE
Datetime		ldt_fecha_emision
Datetime	   ldt_fec_ret_igv

dw_master.accepttext()
idw_detail.accepttext()

/**/
ldc_tasa_cambio  = dw_master.object.tasa_cambio  [dw_master.Getrow()]


/*parametros del sistema*/
f_monedas(ls_soles,ls_dolares)

/*datos de archivos de parametros*/
SELECT flag_retencion    ,imp_min_ret_igv      ,porc_ret_igv     ,
		 doc_grupo_ret_igv ,fecha_inicio_ret_igv
  INTO :ls_flag_retencion ,:ldc_imp_min_ret_igv  ,:ldc_porc_ret_igv  ,
  		 :ls_doc_gr_ret	  ,:ldt_fec_ret_igv	
  FROM finparam
 WHERE (reckey = '1' ) ;

/**********************************/

IF ls_flag_retencion = '0' THEN
	Messagebox('Aviso','Empresa No Realiza Retenciones')
	Return
END IF

/*eliminacion de informacion en tabla temporal*/

DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
	ids_crelacion_ext_tbl.deleterow(0)
LOOP



/*Armar Cadena de Documentos x Grupo de retenciones*/
DECLARE c_doc_retencion CURSOR FOR  
 SELECT doc_grupo_relacion.tipo_doc
   FROM doc_grupo_relacion
  WHERE doc_grupo_relacion.grupo = :ls_doc_gr_ret ;
  
OPEN c_doc_retencion ;
DO
// Lee datos de cursor
FETCH c_doc_retencion into :ls_tipo_doc;
	

IF SQLCA.SQLCODE = 100 THEN EXIT
	
	IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN
   	ls_cadena = "'"+ls_tipo_doc+"'"
	ELSE
		ls_cadena = ls_cadena +", '"+ls_tipo_doc+"'"
	END IF
	// Continua proceso
	LOOP WHILE TRUE
CLOSE c_doc_retencion ;

ls_cadena = 'tipo_doc in ('+ls_cadena+')'


//**separar los codigos de relacion**//
FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 ls_cod_relacion = idw_detail.object.cod_relacion [ll_inicio]
	 
	 ls_expresion = "cod_relacion = '"+ls_cod_relacion+"'"
	 
	 ll_found = ids_crelacion_ext_tbl.find(ls_expresion,1,ids_crelacion_ext_tbl.Rowcount())
	 

	 IF ll_found = 0 THEN
		 ll_ins_new = ids_crelacion_ext_tbl.InsertRow(0)
		 ids_crelacion_ext_tbl.object.cod_relacion [ll_ins_new] = ls_cod_relacion
	 END IF
	 /**/
NEXT

/*VERIFICACION X PROVEEDOR*/
FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount()

	 ls_cod_relacion = ids_crelacion_ext_tbl.object.cod_relacion [ll_inicio]
	 

	 /**VERIFICAR FLAG RETENCION DE PROVEEDOR**/
	 SELECT p.flag_ret_igv
	   INTO :ls_flag_ret_igv
      FROM proveedor  p
     WHERE (p.proveedor = :ls_cod_relacion );
	 
	 IF ls_flag_ret_igv = '0' THEN //no retiene
		 Messagebox('Aviso','Proveedor '+ls_cod_relacion +' No Habilitado para Retenciones')
		 
	 ELSE  /**/
		 
		 ls_expresion = ls_cadena+" AND cod_relacion = '"+ls_cod_relacion+"'"
		 /*FILTRAR DOCUMENTOS X GRUPO Y CODIGO DE RELACION*/
	 	 idw_detail.SetFilter(ls_expresion)
	 	 idw_detail.Filter() 
		  

		  
		 FOR ll_inicio_det = 1 TO idw_detail.Rowcount()
			  ls_tipo_doc   = idw_detail.object.tipo_doc   [ll_inicio_det]
			  ls_nro_doc    = idw_detail.object.nro_doc    [ll_inicio_det]
			  ldc_imp_pagar = idw_detail.object.importe    [ll_inicio_det] 
			  ls_cod_moneda = idw_detail.object.cod_moneda [ll_inicio_det] 	
			  ll_factor		 = idw_detail.object.factor	  [ll_inicio_det] 	
			  
			  /*busqueda en impuesto cntas x pagar*/		 
			  SELECT Count(*)
				 INTO :ll_count
			    FROM cp_doc_det_imp
		      WHERE ((cod_relacion = :ls_cod_relacion  ) AND
				  	    (tipo_doc     = :ls_tipo_doc      ) AND
		  			    (nro_doc	   = :ls_nro_doc       ));
				
				

			  /**/
			  /*RECUPERAR MONTO DE FACTURA*/
	   	  /*TIPO DE MONEDA EN QUE SE GENERO EL DOCUMENTO*/
	     	  SELECT importe_doc,fecha_emision
             INTO :ldc_total_pagar,:ldt_fecha_emision
             FROM cntas_pagar
            WHERE ((cod_relacion = :ls_cod_relacion ) AND
 		             (tipo_doc     = :ls_tipo_doc     ) AND
		             (nro_doc      = :ls_nro_doc      )) ;
			  
			  
			  /*documento tiene que tener impuesto y fecha de emision debe ser >= 01/06/2002*/ 
			  IF ll_count > 0 AND String(ldt_fecha_emision,'yyyymmdd') > String(ldt_fec_ret_igv,'yyyymmdd') THEN
				
 		  		  idw_detail.object.flag_impuesto [ll_inicio_det] = '1' //activo
	 
		        IF ls_cod_moneda <> ls_soles THEN 
		           ldc_total_pagar = Round(ldc_total_pagar * ldc_tasa_cambio,2)
			        ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
	           END IF

		        IF ldc_total_pagar > ldc_imp_min_ret_igv THEN
			        lb_flag = TRUE //OPERACION > 700
		        END IF
		 
 		        /*total de doc*/ 
				  /*provision*/
				  ldc_imp_total       = ldc_imp_total       + (ldc_total_pagar * ll_factor)
				  /*pago*/
				  ldc_imp_total_pagar = ldc_imp_total_pagar + (ldc_imp_pagar   * ll_factor)
			  END IF	
		 NEXT /*FIN DE DETALLE FILTRADO*/
		 
		 /*SUMATORIA TOTAL*/
		 IF lb_flag AND ldc_imp_total > ldc_imp_min_ret_igv THEN /*provision*/
		 
			 For ll_inicio_det = 1 TO idw_detail.Rowcount()
				  ls_cod_relacion  = idw_detail.object.cod_relacion  [ll_inicio_det]
				  ls_tipo_doc		 = idw_detail.object.tipo_doc		  [ll_inicio_det] 
				  ls_nro_doc		 = idw_detail.object.nro_doc 		  [ll_inicio_det]
		        ldc_imp_pagar    = idw_detail.object.importe       [ll_inicio_det] 		
				  ls_flag_impuesto = idw_detail.object.flag_impuesto [ll_inicio_det]
			
		 		  IF ls_flag_impuesto = '1' THEN
 	
			 		  IF ls_cod_moneda <> ls_soles THEN 
			 	 		  ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
	    	 		  END IF
			  
					  idw_detail.object.flag_ret_igv [ll_inicio_det] = '1' //retencion activada
			 
			 		  ldc_imp_retencion = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
			 		  idw_detail.object.impt_ret_igv [ll_inicio_det] = ldc_imp_retencion
					  
					  
		        END IF
		 
			 Next
		 END IF
		 
		 /*operacion de pago*/
		 
		 IF ldc_imp_total_pagar > ldc_imp_min_ret_igv THEN
			
		    For ll_inicio_det = 1 TO idw_detail.Rowcount()
				  ls_cod_relacion  = idw_detail.object.cod_relacion  [ll_inicio_det]
				  ls_tipo_doc		 = idw_detail.object.tipo_doc		  [ll_inicio_det] 
				  ls_nro_doc		 = idw_detail.object.nro_doc 		  [ll_inicio_det]
				  ldc_imp_pagar    = idw_detail.object.importe       [ll_inicio_det] 		
				  ls_flag_impuesto = idw_detail.object.flag_impuesto [ll_inicio_det]
				  
 
				  IF ls_flag_impuesto = '1' THEN

					  IF ls_cod_moneda <> ls_soles THEN 
					 	  ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
			    	  END IF
						
		 			  idw_detail.object.flag_ret_igv [ll_inicio_det] = '1' //retencion activada
		 
		 			  ldc_imp_retencion = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
					  idw_detail.object.impt_ret_igv [ll_inicio_det] = ldc_imp_retencion
					  
				  END IF /*segun flag de impuesto*/
			 Next /*fin del for*/
	    END IF /*fin de operacion de pago*/
    END IF /*fin de proveedor habilitado*/
	 
	/*inicializar*/	 
	
	lb_flag = false	 
	ldc_imp_total_pagar = 0.00
	ldc_imp_total		  = 0.00	

	/*desfiltrado*/ 
	idw_detail.SetFilter('')
	idw_detail.Filter()
	/*ordenamiento*/
	idw_detail.SetSort('item a')
	idw_detail.Sort()
NEXT


/*eliminacion de informacion en tabla temporal*/

DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
	ids_crelacion_ext_tbl.deleterow(0)
LOOP


end subroutine

public function boolean wf_genera_cretencion (long al_nro_serie, ref string as_mensaje, ref string as_nro_doc);Long    ll_nro_doc
Integer li_dig_serie,li_dig_numero
String  ls_nro_doc,ls_tip_doc
Boolean lb_retorno = TRUE

/*Archivo de Parametros*/
SELECT digitos_serie,digitos_numero,doc_ret_igv_crt
  INTO :li_dig_serie,:li_dig_numero,:ls_tip_doc
  FROM finparam
 WHERE (reckey = '1')  ;




//*Genero Comprobate de Retencion*/
SELECT ultimo_numero
  INTO :ll_nro_doc
  FROM num_doc_tipo
 WHERE ((tipo_doc  = :ls_tip_doc   )  AND
 		  (nro_serie = :al_nro_serie )) 
FOR UPDATE NOWAIT		  ;

	
IF Isnull(ll_nro_doc) OR ll_nro_doc = 0 THEN
	lb_retorno = FALSE
	as_mensaje = 'Numerador de Tipo de Documento No Ha sido Inicializado, Verifique!'
	GOTO SALIDA
END IF	


//****************************//
//Actualiza Tabla num_doc_tipo//
//****************************//
	
 UPDATE num_doc_tipo
    SET ultimo_numero = :ll_nro_doc + 1
  WHERE ((tipo_doc  = :ls_tip_doc   )) AND
	      (nro_serie = :al_nro_serie ) ;
	
IF SQLCA.SQLCode = -1 THEN 
	as_mensaje = 'No se Pudo Actualizar Tabla num_doc_tipo por Tipo de Documento Ha Generar, Verifique!'
	lb_retorno = FALSE
	GOTO SALIDA
ELSE
	/**/
	
	IF Isnull(li_dig_serie) OR li_dig_serie = 0 THEN
		lb_retorno = FALSE
		as_mensaje = 'Digitos Para Serie de Documento No ha sido inicializado en Tabla FINPARAM, Verifique!'
		GOTO SALIDA
	END IF

	IF Isnull(li_dig_numero) OR li_dig_numero = 0 THEN
		lb_retorno = FALSE
		as_mensaje = 'Digitos Para Numeros de Documento No ha sido inicializado en Tabla FINPARAM, Verifique!'
		GOTO SALIDA
	END IF

	as_nro_doc = f_llena_caracteres('0',Trim(String(al_nro_serie)),li_dig_serie)+'-'+ f_llena_caracteres('0',Trim(String(ll_nro_doc)),li_dig_numero)


	
END IF
SALIDA:

Return lb_retorno

end function

public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado);DECLARE PB_USP_FIN_INS_DOC_A_PAGAR PROCEDURE FOR USP_FIN_INS_DOC_A_PAGAR 
(:as_cod_relacion,:as_origen,:al_nro_registro,:as_tip_doc,:as_nro_doc,:adc_importe,:as_accion);
EXECUTE PB_USP_FIN_INS_DOC_A_PAGAR ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_INS_DOC_A_PAGAR INTO :as_flag_estado ;
CLOSE PB_USP_FIN_INS_DOC_A_PAGAR ;
end subroutine

public function decimal wf_recalcular_monto_det ();String ls_moneda_ref,ls_moneda_cab
Long   ll_inicio,ll_factor
Decimal ldc_importe_total,ldc_importe_ref,ldc_importe_ret, ldc_tasa_cambio


dw_master.Accepttext()
idw_detail.Accepttext()


ldc_importe_total = 0.00
ldc_importe_ref   = 0.00
ldc_importe_ret	= 0.00

For ll_inicio = 1 to idw_detail.Rowcount()
	
	 ldc_importe_ref = idw_detail.object.importe        [ll_inicio]
	 ldc_importe_ret = idw_detail.object.impt_ret_igv   [ll_inicio]	 	 
	 ls_moneda_ref	  = idw_detail.object.cod_moneda     [ll_inicio]
 	 ll_factor       = idw_detail.object.factor	       [ll_inicio]
	 ls_moneda_cab   = idw_detail.object.cod_moneda_cab [ll_inicio]
	 ldc_tasa_cambio = idw_detail.object.tasa_cambio    [ll_inicio]
	 
	 
	 
	 IF Isnull(ldc_importe_ref) THEN ldc_importe_ref = 0.00
	 IF Isnull(ldc_importe_ret) THEN ldc_importe_ret = 0.00
	 

	 
	 IF ls_moneda_cab =  ls_moneda_ref THEN
		 ldc_importe_ref = ldc_importe_ref * ll_factor
	 ELSEIF ls_moneda_ref = gnvo_app.is_soles THEN
		 ldc_importe_ref = Round(ldc_importe_ref / ldc_tasa_cambio,2) * ll_factor
	 ELSEIF ls_moneda_ref = gnvo_app.is_dolares THEN
		 ldc_importe_ref = Round(ldc_importe_ref * ldc_tasa_cambio,2) * ll_factor
	 END IF	
	 
	 //acumulador
	 ldc_importe_total = ldc_importe_total + ldc_importe_ref
	 
	 /*IMPORTE DE RETENCION*/
	 IF ls_moneda_cab <> gnvo_app.is_soles THEN
		 ldc_importe_ret = Round(ldc_importe_ret / ldc_tasa_cambio,2)
	 ELSE	
		ldc_importe_ret = ldc_importe_ret 
	 END IF	 
	 
	 
	 IF ll_factor = 1 THEN
		 ldc_importe_total = ldc_importe_total + (ldc_importe_ret * -1)
	 ELSE
		 ldc_importe_total = ldc_importe_total + (ldc_importe_ret *  1)
	 END IF

	
	
	 
	 
Next


Return Round(ldc_importe_total,2)
end function

public function boolean wf_update_deuda_financiera ();Long   ll_inicio,ll_nro_reg,ll_item
String ls_origen,ls_tipo_doc,ls_nro_doc
Decimal ldc_monto_proy,ldc_monto_real
Boolean lb_ret = TRUE   


		 

For ll_inicio = 1 to idw_detail.rowcount()
	 ls_origen  	 = idw_detail.object.origen       [ll_inicio]
	 ll_nro_reg 	 = idw_detail.object.nro_registro [ll_inicio]
	 ll_item			 = idw_detail.object.nro_item		 [ll_inicio]
	 ls_tipo_doc	 = idw_detail.object.tipo_doc	    [ll_inicio]
	 ls_nro_doc		 = idw_detail.object.nro_doc	    [ll_inicio]
	 ldc_monto_real = idw_detail.object.importe	    [ll_inicio]
	 
	 
	 //ejecuta procedimiento
	 DECLARE PB_USP_FIN_UPD_CUOTAS_DEUDA_FIN PROCEDURE FOR USP_FIN_UPD_CUOTAS_DEUDA_FIN 
	 (:ls_origen,:ll_nro_reg,:ll_item,:ls_tipo_doc,:ls_nro_doc,:ldc_monto_real);
	 EXECUTE PB_USP_FIN_UPD_CUOTAS_DEUDA_FIN ;

	 IF SQLCA.SQLCode = -1 THEN 
		 MessageBox('SQL error', SQLCA.SQLErrText)
		 lb_ret = FALSE
		 GOTO SALIDA
	 END IF

	 
Next	


SALIDA:


Return lb_ret
end function

public subroutine of_asigna_dws ();idw_detail 			= tab_1.tabpage_1.dw_detail
idw_asiento_cab 	= tab_1.tabpage_2.dw_asiento_cab
idw_asiento_det 	= tab_1.tabpage_2.dw_asiento_det
end subroutine

public function boolean of_generar_asiento ();Boolean lb_ret = TRUE
/*generacion de cntas*/

if dw_master.GetRow() = 0 then return false

if idw_detail.RowCount( ) = 0 then return false

IF invo_Asiento_cntbl.of_generar_asiento_cb (	dw_master			, &
																idw_detail 			, &
																idw_asiento_cab	, &
								  								idw_asiento_det 	, &
								  								ids_asiento_adic	, &
																ids_crelacion_ext_tbl ) = FALSE THEN
	//elimina asientos generados
	DO WHILE idw_asiento_det.Rowcount() > 0
		idw_asiento_det.deleterow(0)
	LOOP								  
	/**/
	
	lb_ret = FALSE
	
ELSE
	idw_asiento_det.ii_update = 1
	idw_asiento_cab.ii_update = 1
END IF	



Return lb_ret
end function

on w_fi309_cartera_de_cobros.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_tes_anular" then this.MenuID = create m_mantenimiento_cl_tes_anular
this.sle_1=create sle_1
this.dw_rpt=create dw_rpt
this.cb_2=create cb_2
this.cbx_ref=create cbx_ref
this.tab_1=create tab_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.dw_rpt
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cbx_ref
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_2
end on

on w_fi309_cartera_de_cobros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_1)
destroy(this.dw_rpt)
destroy(this.cb_2)
destroy(this.cbx_ref)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;try 
	of_asigna_dws()
	of_get_param()
	
	
	dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
	idw_asiento_cab.SetTransObject(sqlca)
	idw_asiento_det.SetTransObject(sqlca)
	
	//El detalle cambia según el indicador
	if gnvo_app.of_get_parametro( "USE_PRSP_CAJA", '0') = '1' then
		idw_detail.DataObject = 'd_abc_cartera_cobros_prsp_caja_tbl'
	else
		if gnvo_app.of_get_parametro( "USE_FLUJO_CAJA", '0') = '1' then
			idw_detail.DataObject = 'd_abc_cartera_cobros_flujo_caja_tbl'
		else
			idw_detail.DataObject = 'd_abc_caja_bancos_det_cartera_cobros_tbl'
		end if
	end if
	
	idw_detail.setTransObject(SQLCA)
	
	idw_1 = dw_master              				             // asignar dw corriente
	idw_detail.BorderStyle = StyleRaised!	 // indicar dw_detail como no activado
	
	//crea objeto
	invo_asiento_cntbl = create n_cst_asiento_contable
	invo_caja_bancos			= create n_cst_caja_bancos
	
	
	/*Datastore de Generacion de Cuentas*/
	//** Datastore Detalle Asiento **//
	ids_asiento_adic 			   = Create u_ds_base
	ids_asiento_adic.DataObject = 'd_abc_datos_asiento_x_doc_tbl'
	ids_asiento_adic.SettransObject(sqlca)
	//** **//
	
	//** Datastore de datawindow Externo**//
	ids_crelacion_ext_tbl = Create u_ds_base
	ids_crelacion_ext_tbl.DataObject = 'd_abc_ext_codigo_tbl'
	ids_crelacion_ext_tbl.SettransObject(sqlca)
	//** **//


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception: ' + ex.getMessage())
end try

end event

event ue_insert;call super::ue_insert;Long   ll_row
String ls_cod_moneda
Decimal ldc_tasa_cambio

IF idw_1 = idw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

IF idw_1 = idw_asiento_det THEN RETURN

IF idw_1 = idw_detail THEN
	IF cbx_ref.checked = FALSE THEN //SIN REFERENCIA
		Messagebox('Aviso','No Puede Ingresar Documento sin referencia si no Selecciona Opcion')
		Return		
	END IF	
	
	//Verificar si cabecera tiene tasa de cambio y tipo de moneda
	ls_cod_moneda	 = dw_master.object.cod_moneda  [dw_master.getrow()]
	ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
	
	IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
		Messagebox('Aviso','Debe Seleccionar un tipo de moneda en la cabecera , Verifique!')
		Return		
	END IF

	IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
		Messagebox('Aviso','Debe Ingresar Tasa de Cambio , Verifique!')
		Return		
	END IF

ELSE
	triggerevent('ue_update_request')
	
	IF ib_update_check = False THEN RETURN
	//cabecera
	is_Action = 'new'
	dw_master.Reset()
	idw_detail.Reset()
	idw_asiento_cab.Reset()
	idw_asiento_det.Reset()
	
	/*Elimina Informacion de Tabla Temporal*/
	delete from tt_fin_deuda_financiera ;
	
	/*ACTIVO VERIFICACION DE RETENCIONES*/
	cb_2.Enabled = TRUE
END IF	

ll_row = idw_1.Event ue_insert()
	
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width       = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height      = tab_1.tabpage_1.height - idw_detail.y - 10

idw_asiento_det.width  = tab_1.tabpage_2.width  - idw_asiento_det.x - 10
idw_asiento_det.height = tab_1.tabpage_2.height - idw_asiento_det.y - 10


end event

event ue_update_pre;call super::ue_update_pre;Long   	ll_ano,ll_mes,ll_nro_registro,ll_inicio,ll_found,ll_ins_new,ll_item,ll_nro_libro,&
		 	ll_nro_asiento
String 	ls_result    ,ls_mensaje      ,ls_cod_origen , ls_flag_estado,&
		 	ls_expresion ,ls_cod_relacion ,ls_nro_ret    ,ls_tipo_doc       ,ls_nro_doc	,ls_cod_moneda ,&
		 	ls_cod_usr, ls_desc_glosa
Decimal 	ldc_importe_total,ldc_totsoldeb,ldc_totdoldeb,ldc_totsolhab,ldc_totdolhab, ldc_tasa_cambio
Datetime	ldt_fecha_cntbl

try 
	Boolean	lb_retorno
	
	ib_update_check = False
	
	IF dw_master.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Registro en la Cabecera, por favor verifique!', StopSign!)
		Return
	END IF
	
	IF not gnvo_app.of_row_Processing( dw_master ) then return
	IF not gnvo_app.of_row_Processing( idw_detail ) then return
	
	/*datos de cabecera*/
	ll_ano            = dw_master.object.ano            [dw_master.getrow()]
	ll_mes            = dw_master.object.mes            [dw_master.getrow()]
	ll_nro_libro		= dw_master.object.nro_libro      [dw_master.getrow()]
	ll_nro_asiento		= dw_master.object.nro_asiento	 [dw_master.getrow()]
	ls_cod_origen     = dw_master.object.origen		  	 [dw_master.getrow()]				 
	ll_nro_registro   = dw_master.object.nro_registro	 [dw_master.getrow()]				 
	ls_flag_estado		= dw_master.object.flag_estado    [dw_master.getrow()]
	ldc_importe_total	= dw_master.object.imp_total	    [dw_master.getrow()]
	ldt_fecha_cntbl	= dw_master.object.fecha_emision  [dw_master.getrow()]
	ls_cod_moneda		= dw_master.object.cod_moneda     [dw_master.getrow()]
	ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [dw_master.getrow()]
	ls_cod_usr			= dw_master.object.cod_usr 	 	 [dw_master.getrow()]
	ls_flag_estado	   = dw_master.object.flag_estado    [dw_master.getrow()]
	ls_desc_glosa	   = dw_master.object.obs    			 [dw_master.getrow()]
	
	
	
	/*verifica cierre*/
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'B') then return //movimiento bancario
	
	/*importe del documento > 0*/
	IF ls_flag_estado <> '0' THEN
		IF Isnull(ldc_importe_total) OR ldc_importe_total <= 0 THEN
			Messagebox('Aviso','Debe Ingresar Importe del Documento')
			Return
		END IF
	END IF
	
	
	IF idw_detail.Rowcount() = 0  AND is_Action <> 'delete' THEN
		Messagebox('Aviso','Debe Ingresar Registro en el Detalle , Verifique!')
		Return
	END IF
	
	
	IF (IsNull(ls_desc_glosa) or trim(ls_desc_glosa) = "")  AND is_Action <> 'delete' THEN
		Messagebox('Aviso','Debe Ingresar Una Glosa en la cabacera de la cartera de cobros , Verifique!')
		Return
	END IF
	
	
	
	IF is_action = 'new' or ll_nro_registro = 0 THEN
		ll_nro_registro = invo_caja_bancos.of_nro_registro_cb(ls_cod_origen)
		dw_master.object.nro_registro	[dw_master.getrow()] = ll_nro_registro
		
		
		//verificacion de año y mes	
		IF Isnull(ll_ano) OR ll_ano = 0 THEN
			Messagebox('Aviso','Ingrese Año Contable , Verifique!')
			Return
		END IF
		
		IF Isnull(ll_mes) OR ll_mes = 0 THEN
			Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
			Return
		END IF
		
		/*generacion de asientos*/	
		IF not invo_asiento_cntbl.of_get_nro_asiento(ls_cod_origen,ll_ano,ll_mes, ll_nro_libro, ll_nro_asiento)  then return
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
		
		//cabecera de asiento
		idw_asiento_cab.Object.origen      [1] = ls_cod_origen
		idw_asiento_cab.Object.ano 		  [1] = ll_ano
		idw_asiento_cab.Object.mes 		  [1] = ll_mes
		idw_asiento_cab.Object.nro_libro   [1] = ll_nro_libro
		idw_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento	
	END IF
	
	
	
	/*eliminar informacion de tabla temporal*/
	DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
		ids_crelacion_ext_tbl.deleterow(0)
	LOOP
	
	//generacion de asientos automaticos
	IF ib_estado_asiento THEN
		IF not of_generar_asiento () then return
	END IF	
	
	
	
			
	//Detalle de Documento
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		 /*validar que datos esten completos*/
		 ls_cod_relacion = idw_detail.object.cod_relacion [ll_inicio]
		 ls_tipo_doc	  = idw_detail.object.tipo_doc	  [ll_inicio]	
		 ls_nro_doc		  = idw_detail.object.nro_doc		  [ll_inicio]	
		 ll_item			  = idw_detail.object.nro_item	  [ll_inicio]	
		 
		 IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
			 Messagebox('Aviso','Debe Ingresar Codigo de Relacion en el Detalle ,Item : '+Trim(String(ll_item)))
			 tab_1.SelectedTab = 1
			 idw_detail.Setfocus()
			 idw_detail.Setcolumn('cod_relacion')
			 idw_detail.Setrow(ll_inicio)
			 RETURN		
		 END IF
		 
		 IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
			 Messagebox('Aviso','Debe Ingresar Tipo de Documento en el Detalle ,Item : '+Trim(String(ll_item)))
			 tab_1.SelectedTab = 1
			 idw_detail.Setfocus()
			 idw_detail.Setcolumn('tipo_doc')
			 idw_detail.Setrow(ll_inicio)
			 RETURN		
		 END IF
		 
		 IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
			 Messagebox('Aviso','Debe Ingresar Nro de Documento en el Detalle ,Item : '+Trim(String(ll_item)))
			 tab_1.SelectedTab = 1
			 idw_detail.Setfocus()
			 idw_detail.Setcolumn('nro_doc')
			 idw_detail.Setrow(ll_inicio)
			 RETURN		
		 END IF
		 
		 idw_detail.object.origen        [ll_inicio]  = ls_cod_origen
		 idw_detail.object.nro_registro  [ll_inicio]  = ll_nro_registro		 
	NEXT
	
	
	//Detalle de pre asiento
	FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
		 idw_asiento_det.object.origen   	[ll_inicio] = ls_cod_origen
		 idw_asiento_det.object.ano   	 	[ll_inicio] = ll_ano
		 idw_asiento_det.object.mes	   	[ll_inicio] = ll_mes
		 idw_asiento_det.object.nro_libro	[ll_inicio] = ll_nro_libro
		 idw_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
		 idw_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_cntbl
	NEXT
	
	
	
	ldc_totsoldeb  = idw_asiento_det.object.monto_soles_cargo   [1]
	ldc_totdoldeb  = idw_asiento_det.object.monto_dolares_cargo [1]
	ldc_totsolhab  = idw_asiento_det.object.monto_soles_abono	[1]
	ldc_totdolhab  = idw_asiento_det.object.monto_dolares_abono [1]
	
	
	
	idw_asiento_cab.Object.cod_moneda	[1] = ls_cod_moneda
	idw_asiento_cab.Object.tasa_cambio	[1] = ldc_tasa_cambio
	idw_asiento_cab.Object.fec_registro [1] = ldt_fecha_cntbl
	idw_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_cntbl
	idw_asiento_cab.Object.cod_usr	   [1] = ls_cod_usr
	idw_asiento_cab.Object.flag_estado  [1] = ls_flag_estado
	idw_asiento_cab.Object.desc_glosa  	[1] = ls_desc_glosa
	idw_asiento_cab.Object.tot_solhab	[1] = ldc_totsolhab
	idw_asiento_cab.Object.tot_dolhab	[1] = ldc_totdolhab
	idw_asiento_cab.Object.tot_soldeb	[1] = ldc_totsoldeb
	idw_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb
	
	IF dw_master.ii_update = 1 OR idw_asiento_det.ii_update = 1 THEN 
		idw_asiento_det.ii_update = 1
		idw_asiento_cab.ii_update = 1
	END IF
	
	
	// valida asientos descuadrados
	if not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then return
	
	/*Replicacion*/
	dw_master.of_set_flag_replicacion ()
	idw_detail.of_set_flag_replicacion ()
	idw_asiento_cab.of_set_flag_replicacion ()
	idw_asiento_det.of_set_flag_replicacion ()
	
	ib_update_check = true

Catch(exception ex)
	ROLLBACK;
	gnvo_app.of_catch_exception( ex, '')
	ib_update_check = False	
	RETURN

end try


end event

event ue_update;call super::ue_update;Long     ll_row_det     ,ll_ano       ,ll_mes          ,ll_nro_libro ,&
         ll_nro_asiento ,ll_row_master,ll_nro_registro ,ll_inicio		
String   ls_origen   ,ls_flag_retencion ,ls_cod_relacion , ls_nro_cr,&
			ls_null 		,ls_flag_provisionado 
Boolean  lbo_ok = TRUE
Datetime ldt_fecha_doc
Decimal ldc_tasa_cambio, ldc_imp_ret_sol,ldc_imp_ret_dol


dw_master.AcceptText()
idw_detail.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

SetNull(ls_null)

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if


/*datos de la cabecera*/
ll_row_master     = dw_master.getrow()
ll_nro_registro   = dw_master.object.nro_registro   [ll_row_master]
ls_origen 		   = dw_master.object.origen			 [ll_row_master]
ls_flag_retencion = dw_master.object.flag_retencion [ll_row_master]
ldt_fecha_doc	   = dw_master.object.fecha_emision  [ll_row_master]
ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [ll_row_master]

//ejecuta procedimiento de actualizacion de tabla temporal
IF idw_asiento_det.ii_update = 1 and is_action <> 'new' THEN
	ll_row_det     = idw_asiento_det.Getrow()
	ll_ano         = idw_asiento_det.Object.ano         [ll_row_det]
	ll_mes         = idw_asiento_det.Object.mes         [ll_row_det]
	ll_nro_libro   = idw_asiento_det.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = idw_asiento_det.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
END IF


IF idw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF idw_asiento_cab.Update (true, false) = -1 THEN // Cabecera de Asiento
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Cabecera de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF idw_asiento_det.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF idw_asiento_det.Update (true, false) = -1 THEN 
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


if lbo_ok then
	IF ls_flag_retencion = '1' THEN /*cabecera*/
		FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount()
			ls_cod_relacion = ids_crelacion_ext_tbl.object.cod_relacion [ll_inicio]
			ls_nro_cr	    = ids_crelacion_ext_tbl.object.nro_cr       [ll_inicio]
		 
			/*encontrar monto de cri x proveedor*/
			f_monto_cri_x_prov(idw_detail,ls_cod_relacion,ldc_tasa_cambio,ldc_imp_ret_sol,ldc_imp_ret_dol)
			
			/*SE GENERA COMPROBANTE DE RETENCION*/
			INSERT INTO retencion_igv_crt
			(nro_certificado,fecha_emision   ,origen    ,nro_reg_caja_ban,
			 proveedor      ,flag_estado     ,flag_tabla,saldo_sol		 ,
			 saldo_dol      ,flag_replicacion)  
			VALUES
			(:ls_nro_cr       ,:ldt_fecha_doc,:ls_origen ,:ll_nro_registro,
			 :ls_cod_relacion ,'1'			   ,'5'			,:ldc_imp_ret_sol,
			 :ldc_imp_ret_dol	,'1')  ;
			
			
			IF SQLCA.SQLCode = -1 THEN 
				MessageBox("SQL error", SQLCA.SQLErrText)
				lbo_ok = FALSE
				GOTO SALIDA
			END IF
			
		 
		NEXT
	END IF
	
	//acciones despues de grabar
	/*Datos de Deuda Financiera*/
	if is_Action <> 'delete' then
		if wf_update_deuda_financiera() = false then
			lbo_ok = FALSE
			GOTO SALIDA
		end if
	end if
	
	if ib_log then
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_asiento_cab.of_save_log()
		lbo_ok = idw_asiento_det.of_save_log()
	end if

end if


SALIDA:

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_asiento_cab.ii_update = 0
	idw_asiento_det.ii_update = 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()

	is_action = 'fileopen'
	

	/* actualiza valores flag detalle */
	for ll_inicio = 1 to idw_detail.Rowcount()
		 idw_detail.object.flag_doc     	    [ll_inicio] = ls_null
		 
		 ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
		 
		 IF ls_flag_provisionado = 'N' THEN
			 idw_detail.object.flag_partida [ll_inicio] = '1'
		 END IF

	next

	/*setear flag de retencion*/
	SetNull(ls_flag_retencion)
	dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
	
	/*Elimina Informacion de Tabla Temporal*/
	delete from tt_fin_deuda_financiera ;
	
	triggerEvent('ue_modify')
	
	/*Generacion de Asientos*/
	ib_estado_asiento = FALSE
	
	f_mensaje("Transación Guardada satisfactoriamente", "")
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;Long   ll_inicio,ll_found,ll_count,ll_factor
String ls_moneda_cab,ls_flag_provisionado,ls_cta_ctbl  ,ls_expresion,ls_null        ,&
		 ls_doc_sgiro ,ls_tipo_doc	        ,ls_flag_tabla,ls_nro_doc  ,ls_cod_relacion,&
		 ls_flag_ctrl_reg
Decimal ldc_tasa_cambio
str_parametros sl_param

TriggerEvent ('ue_update_request')


sl_param.dw1     = 'd_abc_cartera_cobros_tbl'
sl_param.titulo  = 'Cartera de Cobros'

sl_param.field_ret_i[1] = 1 //origen
sl_param.field_ret_i[2] = 2 //registro	
sl_param.field_ret_i[3] = 5 //ano
sl_param.field_ret_i[4] = 6 //mes
sl_param.field_ret_i[5] = 7 //nro libro
sl_param.field_ret_i[6] = 8 //nro asiento

select doc_sol_giro into :ls_doc_sgiro from finparam where reckey = '1' ;


OpenWithParm( w_lista, sl_param)
sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]),'3')
	if dw_master.GetRow() = 0 then return
	
	dw_master.il_row = dw_master.getRow()
	
	idw_detail.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]))
	idw_asiento_cab.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	idw_asiento_det.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	
	
	/*Elimina Informacion de Tabla Temporal*/
	delete from tt_fin_deuda_financiera ;
	
	/*asociacion de moneda de cabecera*/
	IF dw_master.rowcount()  > 0 THEN
		ls_moneda_cab   = dw_master.object.cod_moneda  [dw_master.getrow()]
		ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
		ls_cta_ctbl		 = dw_master.object.cnta_ctbl   [dw_master.getrow()]
		
		For ll_inicio = 1 to idw_detail.Rowcount()
			 idw_detail.object.cod_moneda_cab [ll_inicio] = ls_moneda_cab
			 idw_detail.object.tasa_cambio    [ll_inicio] = ldc_tasa_cambio
			 
			 ls_tipo_doc			 = idw_detail.object.tipo_doc				[ll_inicio]
			 ls_nro_doc				 = idw_detail.object.nro_doc				[ll_inicio]
			 ls_cod_relacion		 = idw_detail.object.cod_relacion		[ll_inicio]
			 ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
			 ll_factor				 = idw_detail.object.factor				[ll_inicio]
			 ls_flag_tabla			 = idw_detail.object.flab_tabor			[ll_inicio]
			 
			 IF ls_flag_provisionado = 'N' THEN
				 //*ingresos indirectos PARTIDA EDITABLE*//
				 idw_detail.object.flag_partida [ll_inicio] = '1'
// 				 cbx_ref.checked = TRUE
			 END IF
			 
 			 //verificar condiciones de documentos
			 IF ls_tipo_doc = ls_doc_sgiro THEN
			    idw_detail.object.t_tipdoc [ll_inicio] = ls_null
		    ELSE
			    //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
	          select count(*) into :ll_count from doc_grupo_relacion dg 
			     where (dg.grupo    = 'C1'         ) and
			           (dg.tipo_doc = :ls_tipo_doc ) ;
			 
			    if (ll_count > 0 AND ls_flag_provisionado = 'D' AND ll_factor = 1 AND ls_flag_tabla = '1') then
		          select cc.flag_control_reg into :ls_flag_ctrl_reg
           	      from cntas_cobrar cc
	              where (cc.cod_relacion = :ls_cod_relacion) and
   	                 (cc.tipo_doc     = :ls_tipo_doc    ) and
      	              (cc.nro_doc      = :ls_nro_doc     ) ;
			 	 
				    if ls_flag_ctrl_reg = '1' then
					    idw_detail.object.t_tipdoc [ll_inicio] = ls_null
				    else
					    idw_detail.object.t_tipdoc [ll_inicio] = '1'	
				    end if
			    else
				    idw_detail.object.t_tipdoc [ll_inicio] = '1'	
			    end if				 
			    
		    END IF			
			 
			 
		Next
	END IF
	
	ls_expresion = 'cnta_ctbl = '+"'"+ls_cta_ctbl+"'"
	//flag de doc editable en cuenta de banco..
	ll_found = idw_asiento_det.Find(ls_expresion,1,idw_asiento_det.Rowcount())
	
	IF ll_found > 0 THEN //ENCONTRO CUENTA CONTABLE DE BANCO
		Setnull(ls_null)
		idw_asiento_det.object.flag_doc_edit [ll_found] = ls_null
	END IF
	

		 
		 
	
	
	is_Action = 'fileopen'
	TriggerEvent('ue_modify')
	/*Generacion de Asientos*/
	ib_estado_asiento = FALSE	
END IF	
end event

event ue_delete;//override
Long  ll_row

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if


IF idw_1 = dw_master OR idw_1 = idw_asiento_det THEN
	Messagebox('Aviso','No se puede ELiminar Cabecera de Registro')
	Return	
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

//evento que recalcula total de la cabecera
dw_master.object.imp_total [dw_master.getrow()] = wf_recalcular_monto_det ()
dw_master.ii_update = 1

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update       = 1 OR idw_detail.ii_update      = 1 OR &
	 idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_asiento_cab.ii_update = 0
		idw_asiento_det.ii_update = 0
		
		ib_update_check = true
		
	END IF
else
	ib_update_check = true
END IF
end event

event ue_modify;call super::ue_modify;String ls_flag_estado,ls_origen,ls_result,ls_mensaje
Long   ll_row,ll_nro_registro,ll_count,ll_ano,ll_mes

ll_row = dw_master.getrow()

IF ll_row = 0 THEN RETURN

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if


ls_flag_estado  = dw_master.object.flag_estado  [ll_row]
ls_origen		 = dw_master.object.origen       [ll_row]
ll_nro_registro = dw_master.object.nro_registro [ll_row]
ll_ano 			 = dw_master.object.ano 			[ll_row]
ll_mes 			 = dw_master.object.mes 			[ll_row]

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'B') then return //movimiento bancario



IF ls_flag_estado <> '1' OR ll_count > 0 OR ls_result = '0' THEN
	dw_master.ii_protect = 0
	dw_master.of_protect()	
	idw_detail.ii_protect = 0
	idw_detail.of_protect()	
	idw_asiento_det.ii_protect = 0
	idw_asiento_det.of_protect()	
	
	IF ls_flag_estado = '1' AND ls_result <> '0' THEN
		idw_asiento_det.Modify("imp_movsol.Protect='0'")
		idw_asiento_det.Modify("imp_movdol.Protect='0'")	
		idw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
		idw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")		
	END IF

	
ELSE
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_asiento_det.of_protect()

	IF idw_detail.ii_protect = 0 THEN //MODIFICABLE DETALLE DOCUMENTOS
		//bloqueo de campos...
		idw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
		idw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
		idw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
		idw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
		idw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")
		idw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")						
	END IF
	
	//MODIFICABLE DETALLE ASIENTOS
	IF idw_asiento_det.ii_protect = 0 THEN
		idw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
		idw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	
	END IF
	
	IF is_Action <> 'new' THEN
		dw_master.object.ano.Protect = 1
		dw_master.object.mes.Protect = 1
		dw_master.object.nro_libro.Protect = 1		
	END IF 
	
	

END IF




end event

event ue_insert_pos;call super::ue_insert_pos;

IF idw_1 = dw_master THEN
	idw_asiento_cab.TriggerEvent('ue_insert')
END IF

/*Generacion de Asientos*/
ib_estado_asiento = TRUE
end event

event ue_delete_pos;call super::ue_delete_pos;	/*Generacion de Asientos*/
	ib_estado_asiento = TRUE
end event

event closequery;call super::closequery;DESTROY 	ids_asiento_adic
DESTROY	invo_caja_bancos
DESTROY 	ids_crelacion_ext_tbl
destroy 	invo_Asiento_cntbl

end event

event ue_print;call super::ue_print;String ls_origen,ls_print
Long ll_row_master,ll_nro_registro,ll_tiempo,ll_i


n_cst_impresion lnvo_impresion

sle_1.backcolor = rgb (255,255,0)


//declaracion de objecto
lnvo_impresion = create n_cst_impresion


ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR &
   idw_asiento_det.ii_update = 1 then //OR idw_asiento_det.ii_update = 1 THEN 
	Messagebox('Aviso','Debe Grabar Los Cambios Verifique! ')	

	Return
END IF	


ls_origen	    = dw_master.object.origen       [ll_row_master]
ll_nro_registro = dw_master.object.nro_registro [ll_row_master]	

//nombre de impresora
ls_print = Upper(dw_master.describe('datawindow.printer'))

/*IMPRESION LOCAL O TERMINAL SERVER*/
lnvo_impresion.of_voucher ('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gs_empresa, '0', ls_print)


//destruccion de objeto
destroy lnvo_impresion


ll_tiempo = 1500


For ll_i = 1 to ll_tiempo 
	 SetMicrohelp( String( ll_i ))
End For 


sle_1.backcolor = rgb (255,0,0)


SetMicrohelp( String( 0 ))
end event

event open;call super::open;of_asigna_dws()
end event

event close;call super::close;Long 	ll_i
if upperBound(iw_rpt) > 0 then
	for ll_i = 1 to upperBound(iw_rpt)
		if Not IsNull(iw_rpt[ll_i]) and IsValid(iw_rpt[ll_i]) then
			Close(iw_rpt[ll_i])
		end if
	next
end if
end event

type sle_1 from singlelineedit within w_fi309_cartera_de_cobros
integer x = 3314
integer y = 260
integer width = 123
integer height = 52
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
borderstyle borderstyle = stylelowered!
end type

type dw_rpt from datawindow within w_fi309_cartera_de_cobros
boolean visible = false
integer x = 3342
integer y = 1308
integer width = 686
integer height = 400
integer taborder = 50
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_fi309_cartera_de_cobros
integer x = 3136
integer y = 124
integer width = 439
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retenciones"
end type

event clicked;String ls_cod_moneda,ls_flag_retencion,ls_cod_relacion
Long   ll_row_master,ll_inicio
Decimal ldc_tasa_cambio


ll_row_master 	 = dw_master.getrow()
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Moneda')
	RETURN
END IF

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Relación')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF

IF idw_detail.Rowcount() = 0 THEN
	Messagebox('Aviso','No Existen Registros para Verificar Retención')
	RETURN
END IF




SetNull(ls_flag_retencion)

ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]

/*limpieza de flag e importe de retencion*/
FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 idw_detail.object.impt_ret_igv [ll_inicio] = 0.00 
	 idw_detail.object.flag_ret_igv [ll_inicio] = '0'  //desactivado
NEXT


wf_verificacion_retencion()
wf_verificacion_items_x_retencion()

/*cabecera*/
dw_master.Object.imp_total [ll_row_master] =	wf_recalcular_monto_det()
idw_detail.ii_update = 1
/*Generacion de Asientos*/
ib_estado_asiento = TRUE
end event

type cbx_ref from checkbox within w_fi309_cartera_de_cobros
integer x = 3150
integer y = 360
integer width = 581
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingreso Sin Referencia"
end type

event clicked;////solamente se habilitan si no se encuentra doc. de referencias
//IF This.Checked THEN
//	if idw_detail.Rowcount() > 0 then
//		Messagebox('Aviso','Ya ingreso documentos con referencia , no podra utilizar esta opción , Verifique!')
//		This.Checked = FALSE
//		Return
//	end if
//ELSE	
//	if idw_detail.Rowcount() > 0 then
//		Messagebox('Aviso','Ya ingreso documentos sin referencia ,  Verifique!')
//		This.Checked = TRUE
//		Return
//	end if
//END IF
//
end event

type tab_1 from tab within w_fi309_cartera_de_cobros
integer y = 1092
integer width = 3214
integer height = 872
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;CHOOSE CASE newindex
		 CASE 2
			   IF ib_estado_asiento THEN //REGENERA ASIENTOS
		 	 		of_generar_asiento ()
			 END IF	
END CHOOSE			 

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3177
integer height = 744
long backcolor = 79741120
string text = "  Referencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
event ue_items ( )
integer width = 3099
integer height = 680
integer taborder = 30
string dataobject = "d_abc_caja_bancos_det_cartera_cobros_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_items();String ls_cod_moneda
Long   ll_row_master
Decimal {4} ldc_tasa_cambio

ll_row_master = dw_master.getrow()
ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]

f_verificacion_items_x_retencion (dw_master,idw_detail)

dw_master.object.imp_total [ll_row_master] = wf_recalcular_monto_det()
dw_master.ii_update= 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'd'		 // 'm' = master sin detalle (default), 'd' =  detalle,
                      // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      


idw_mst = dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;Long   	ll_row,ll_item
String 	ls_moneda,ls_confin,ls_matriz
Decimal 	ldc_tasa_cambio
Integer	li_semana
Date		ld_fecha_pago

//datos del banco
ls_moneda 		 = dw_master.object.cod_moneda  [dw_master.getrow()]
ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
ls_confin		 = dw_master.object.confin		  [dw_master.getrow()]
ls_matriz		 = dw_master.object.matriz_cntbl[dw_master.getrow()]
ld_fecha_pago 	 = Date(dw_master.object.fecha_emision	[dw_master.getRow()])

This.object.flag_flujo_caja 	[al_row] = '1'
This.object.nro_item 			[al_row] = of_nro_item(this)
this.object.flag_ret_igv		[al_row] = '0'

//Obtengo la semana de pago
try 
	if gnvo_app.of_get_parametro( "USE_PRSP_CAJA", '0') = '1' then
		li_semana = gnvo_app.of_get_semana( ld_fecha_pago )
		This.object.semana 				[al_row] = li_Semana
	end if
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception: ' + ex.getMessage())
end try

IF cbx_ref.Checked THEN
	This.object.origen_doc		   [al_row] = gs_origen //INDIRECTO
	This.object.flag_provisionado [al_row] = 'N'       //INDIRECTO
	This.object.cod_moneda			[al_row]	= ls_moneda
	This.object.cod_moneda_cab 	[al_row] = ls_moneda
	This.object.tasa_cambio       [al_row] = ldc_tasa_cambio
	This.object.flag_doc			   [al_row] = '1'       //tipo de documento editable.

	//por cobrar partida no editable
	This.object.factor			   [al_row] = 1
	This.object.confin			   [al_row] = ls_confin
	this.object.matriz_cntbl		[al_row]	= ls_matriz
	this.object.flag_aplic_comp	[al_row]	= '0'			//compesacion
	
END IF	


//bloqueo de campos....
idw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
idw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
idw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
idw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
idw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")			

end event

event itemchanged;call super::itemchanged;Long   	ll_count,ll_mes,ll_ano,ll_null,ll_nro_registro, ll_row
String 	ls_data,  ls_cod_moneda,ls_null,ls_cencos,ls_cnta_prsp,&
		 	ls_flag_provisionado,ls_matriz,ls_accion,ls_origen,ls_cod_relacion,ls_tip_doc_ref,&
		 	ls_nro_doc_ref,ls_flag_estado,ls_nom_proveedor
Decimal 	ldc_importe,ldc_imp_retencion, ldc_tasa_cambio

dwItemStatus ldis_status

SetNull(ls_flag_estado)

this. Accepttext()
/*Generacion de Asientos*/
ib_estado_asiento = TRUE

choose case dwo.name
	
	case 'centro_benef'
		select Count(*) into :ll_count from centro_benef_usuario 
		 Where cod_usr      = :gs_user and
				 centro_benef = :data	;
		 
		IF ll_count = 0  THEN
			Messagebox('Aviso','Centro de Beneficio No esta Asignado al Usuario Verifique')
			Setnull(ls_null)
			This.Object.centro_benef [row] = ls_null
			Return 1
		END IF

	case 'cod_flujo_caja'
		select descripcion
			into :ls_data 
			from CODIGO_FLUJO_CAJA
		Where COD_FLUJO_CAJA = :data	
		  and flag_estado = '1';
		 
		IF SQLCA.SQLCOde = 100  THEN
			Messagebox('Aviso','Código de Flujo de Caja No esta Activo o no existe, por favor verifique')
			This.Object.cod_flujo_caja 	[row] = gnvo_app.is_null
			This.Object.desc_flujo_caja 	[row] = gnvo_app.is_null
			Return 1
		END IF
		
		This.Object.desc_flujo_caja 	[row] = ls_data
		
	case 'flag_aplic_comp'	
	
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
	case 'flag_flujo_caja'	
		
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
	case 'confin'
		SELECT matriz_cntbl
		  INTO :ls_matriz
		  FROM concepto_financiero
		 WHERE confin = :data ;
		 
		
		IF Isnull(ls_matriz) OR Trim(ls_matriz) = '' THEN
			Messagebox('Aviso','Concepto Financiero No existe Verifique')
			SetNull(ls_data)					
			This.Object.confin [row] = ls_data
			Return 1
		ELSE
			This.object.matriz_cntbl [row] = ls_matriz
		END IF
		
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
	case	'cod_relacion'
		select Count(*) into :ll_count
		  from proveedor p
		 where (p.proveedor   = :data ) and
				 (p.flag_estado = '1'   ) ;
	
				  
		if ll_count = 0 then
			SetNull(ls_data)
			This.object.cod_relacion  [row] = ls_data
			This.object.nom_proveedor [row] = ls_data
			Messagebox('Aviso','Codigo de Relacion No Existe , Verifique!')
			Return 1
		else
			select p.nom_proveedor into :ls_nom_proveedor from proveedor p where (p.proveedor = :data) ;
			This.object.nom_proveedor [row] = ls_nom_proveedor
		end if
	
	case 'cencos'
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
		ls_flag_provisionado = this.object.flag_provisionado [row]				
		
		select Count(*) into :ll_count from centros_costo where	(cencos = :data) ;
		
		if ll_count = 0 then
			SetNull(ls_data)
			This.object.cencos [row] = ls_data
			Messagebox('Aviso','Centro de Costo No Existe , Verifique!')
			Return 1
		else
			
			ls_flag_provisionado = This.object.flag_provisionado [row]
			//afectacion presupuestal verificacion
			IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
				ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
				ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
				ls_cencos	 = this.object.cencos    [row]
				ls_cnta_prsp = this.object.cnta_prsp [row]
				ldc_importe  = this.object.importe   [row]
			
				IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
					this.object.cnta_prsp [row] = ls_null
					this.object.importe   [row] = ll_null		
					dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
					dw_master.ii_update = 1
					RETURN 1
				END IF
			END IF
			
		end if
		
	case 'cnta_prsp'
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
		ls_flag_provisionado = this.object.flag_provisionado [row]							
		select Count(*) into :ll_count from presupuesto_cuenta where (cnta_prsp = :data) ;			   
		
		if ll_count = 0 then
			SetNull(ls_data)
			This.object.cnta_prsp [row] = ls_data
			Messagebox('Aviso','Cuenta Presupuestal No Existe , Verifique!')
			Return 1
		else
			
			ls_flag_provisionado = This.object.flag_provisionado [row]
			//afectacion presupuestal verificacion
			IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
				ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
				ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
				ls_cencos	 = this.object.cencos    [row]
				ls_cnta_prsp = this.object.cnta_prsp [row]
				ldc_importe  = this.object.importe   [row]
			
				IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
					this.object.cnta_prsp [row] = ls_null
					this.object.importe   [row] = ll_null		
					
					dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
					dw_master.ii_update = 1							
					RETURN 1
				END IF
			END IF
			
		end if
		
	case 'tipo_doc'
		select Count(*) into :ll_count
		  from doc_grupo dg, doc_grupo_relacion dgr, finparam fp 
		 where (dg.grupo     = dgr.grupo ) and
				 (dg.grupo     = fp.doc_grp_cob_directo) and
				 (dgr.tipo_doc = :data     ) ;
				 
		if ll_count = 0 then
			SetNull(ls_data)
			This.object.tipo_doc [row] = ls_data
			Messagebox('Aviso','Documento No Existe en Grupo de Documento x Cobrar , Verifique!')
			Return 1
		end if
		
	case 'impt_ret_igv'
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
	case 'importe'
		
		ls_flag_provisionado = This.object.flag_provisionado [row]
		
		ldis_status = this.GetItemStatus(row,0,Primary!)				
	
		IF ldis_status = NewModified! THEN
			ls_accion = 'new'
		ELSE	
			ls_accion = 'fileopen'					
		END IF
		
		//verifica monto de documento
		ls_origen		 = dw_master.object.origen			[dw_master.getrow()]
		ll_nro_registro = dw_master.object.nro_registro [dw_master.getrow()]
		ls_cod_relacion = this.object.cod_relacion [row]				
		ls_tip_doc_ref	 = this.object.tipo_doc     [row]
		ls_nro_doc_ref	 = this.object.nro_doc      [row]
		ldc_importe		 = this.object.importe      [row]
		
		IF ls_flag_provisionado <> 'N' THEN //SIN UN ORIGEN DEL REGISTRO
			wf_verifica_monto_doc(ls_cod_relacion,ls_origen,ll_nro_registro,ls_tip_doc_ref,ls_nro_doc_ref,ldc_importe,ls_accion,ls_flag_estado)
	
			if Trim(ls_flag_estado) = '1' then
				Messagebox('Aviso','Importe se ha excedido, Verifique')
				this.object.importe 		 [row] = 0.00
				this.object.impt_ret_igv [row] = 0.00
				dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
				dw_master.ii_update = 1
				Return 1
			end if
		END IF		
		
		dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
		dw_master.ii_update = 1
		
	case	'flag_ret_igv'			
		
		IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
			
			ldc_importe     = This.object.importe     [row] 		
			ls_cod_moneda   = This.object.cod_moneda  [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio [row] 					
			
			IF ls_cod_moneda <> gnvo_app.is_soles THEN 
				//ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
				ldc_importe   = ldc_importe * ldc_tasa_cambio
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * gnvo_app.idc_tasa_retencion)/ 100,2)
			 
			This.object.impt_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
			This.object.impt_ret_igv [row] = 0.00
		END IF
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar El mismo FLAG de RETENCION para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.flag_ret_igv	[ll_row] = data
				
				IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
					
				
					ldc_importe     = This.object.importe     [ll_row] 		
					ls_cod_moneda   = This.object.cod_moneda  [ll_row] 					
					ldc_tasa_cambio = This.object.tasa_cambio [ll_row] 					
					
					IF ls_cod_moneda <> gnvo_app.is_soles THEN 
						//ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
						ldc_importe   = ldc_importe * ldc_tasa_cambio
					END IF
				  
					ldc_imp_retencion = Round((ldc_importe * gnvo_app.idc_tasa_retencion)/ 100,2)
					 
					This.object.impt_ret_igv [ll_row] = ldc_imp_retencion					
					 
				ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
					This.object.impt_ret_igv [ll_row] = 0.00
				END IF
	
			next
		end if
	
		PostEvent('ue_items')

end choose


end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event dberror;//override
String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

//CHOOSE CASE sqldbcode
//	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK: ' + this.ClassName(),'Llave Duplicada, Linea: ' + String(row))
//		  Return 1
//	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
//		SELECT TABLE_NAME
//        INTO :ls_name
//        FROM ALL_CONSTRAINTS
//       WHERE ((OWNER          = :ls_prop  ) AND 
//             (CONSTRAINT_NAME = :ls_const )) ;
//        Messagebox('Error FK: ' + this.ClassName(),'Registro Tiene Movimientos en Tabla: '+ls_name)
//        Return 1
//	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox('dberror: ' + this.ClassName(), ls_msg, StopSign!)
//END CHOOSE





end event

event ue_display;call super::ue_display;String ls_name,ls_prot,ls_flag_provisionado,ls_cencos,ls_cnta_prsp,ls_null,ls_cod_relacion
Long   ll_null,ll_mes ,ll_ano
Decimal ldc_importe
str_parametros lstr_param
str_seleccionar lstr_seleccionar



CHOOSE CASE lower(as_columna)
	CASE 'semana', 'nro_prsp', 'item_prsp'
		lstr_param.long1 		= Long(this.object.semana [al_row])
		lstr_param.string1	= 'I'  // Para que solo muestre los egresos
		lstr_param.dw_m 		= dw_master
		lstr_param.dw_d		= idw_detail
		
		OpenWithParm(w_fi310_choice_prsp_caja, lstr_param)
		
	CASE 'b_2'
		//BUSCAR CODIGO DE RELACION EN DETALLE DE PAGO
		ls_cod_relacion = this.object.cod_relacion [al_row]
		
		if Isnull(ls_cod_relacion) or Trim(ls_cod_relacion) = ''  then
			Messagebox('Aviso','Codigo de Relacion del Detalle debe Colocarse para ' &
									+' Buscar Deudadas Financieras' )
			Return						 
		end if
		
		lstr_param.tipo			= '14' 
		lstr_param.opcion		= 13
		lstr_param.titulo 		= 'Selección de Deudas Financieras'
		lstr_param.dw_master	= 'd_abc_lista_deuda_financiera_cab_tbl'
		lstr_param.dw1			= 'd_abc_lista_deuda_financiera_det_tbl'
		lstr_param.dw_m			= dw_master
		lstr_param.dw_d			= idw_detail
		lstr_param.long1			= al_row
		lstr_param.string1		= ls_cod_relacion
		
	
		dw_master.Accepttext()
	
	
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		
		if lstr_param.bret then
			ii_update = 1	
		end if
				
	CASE 'confin'
	
			/*
				1	Cntas x Cobrar
				2	Cntas x Pagar
				3	Tesoreria - Aplicaciones
				4	Todos
				5	Letras
				6	Liquidacion de Beneficios
				7	Devengados OS
				8	Liquidacion de OG
			*/
			
			lstr_param.tipo			= 'ARRAY'
			lstr_param.opcion			= 3	
			lstr_param.str_array[1] = '3'		//Tesoreria
			lstr_param.str_array[2] = '4'		//Todos
			lstr_param.titulo 		= 'Selección de Concepto Financiero'
			lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
			lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
			lstr_param.dw_m			=  This
			
			OpenWithParm( w_abc_seleccion_md, lstr_param)
			IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
			IF lstr_param.titulo = 's' THEN
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_asiento = TRUE
				/**/
			END IF

	CASE 'cod_flujo_caja'

		lstr_param.tipo			= '1S'
		lstr_param.opcion			= 16
		lstr_param.string1 		= 'I'
		lstr_param.titulo 		= 'Selección de Concepto de Flujo de Caja'
		lstr_param.dw_master		= 'd_list_grupo_flujo_caja_tbl'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_list_codigo_flujo_caja_tbl'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			this.ii_update = 1
		END IF
		
	CASE 'tipo_doc'
	  ls_flag_provisionado = this.object.flag_provisionado [al_row]
	  IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O' ) OR is_Action = 'fileopen' THEN RETURN
	  
	  lstr_seleccionar.s_seleccion = 'S'
	  lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_COBRAR.TIPO_DOC AS CODIGO_DOC,'&
												+'VW_FIN_DOC_X_GRUPO_COBRAR.DESC_TIPO_DOC AS DESCRIPCION '&
												+'FROM VW_FIN_DOC_X_GRUPO_COBRAR '  
												
	  OpenWithParm(w_seleccionar,lstr_seleccionar)
	  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	  IF lstr_seleccionar.s_action = "aceptar" THEN
		  Setitem(al_row,'tipo_doc',lstr_seleccionar.param1[1])
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = TRUE
	  END IF	
												
	CASE 'cod_relacion'
	  ls_flag_provisionado = this.object.flag_provisionado [al_row]
	  IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O') OR is_action = 'fileopen' THEN RETURN
	  
	  lstr_seleccionar.s_seleccion = 'S'
	  lstr_seleccionar.s_sql =	'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO , '&
												+'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE   '&
												+'FROM PROVEEDOR '&
												+'WHERE (PROVEEDOR.FLAG_ESTADO =   '+"'"+'1'+"')"
												
	  OpenWithParm(w_seleccionar,lstr_seleccionar)
	  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
	  IF lstr_seleccionar.s_action = "aceptar" THEN
		  Setitem(al_row,'cod_relacion',lstr_seleccionar.param1[1])
		  Setitem(al_row,'nom_proveedor',lstr_seleccionar.param2[1])				  
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = TRUE
	  END IF	
	  
	CASE 'cencos'
	  ls_flag_provisionado = this.object.flag_provisionado [al_row]
	  IF (ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'O') THEN RETURN
	  
	  lstr_seleccionar.s_seleccion = 'S'
	  lstr_seleccionar.s_sql =	'SELECT CENTROS_COSTO.CENCOS      AS CODIGO , '&
												+'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION  '&
												+'FROM CENTROS_COSTO '&
												+'WHERE (CENTROS_COSTO.FLAG_ESTADO =   '+"'"+'1'+"')"
												
	  OpenWithParm(w_seleccionar,lstr_seleccionar)
	  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
	  IF lstr_seleccionar.s_action = "aceptar" THEN
		
		  Setitem(al_row,'cencos',lstr_seleccionar.param1[1])
		  //afectacion presupuestal verificacion
		  IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
			  ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
			  ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
			  ls_cencos	   = this.object.cencos    [al_row]
			  ls_cnta_prsp = this.object.cnta_prsp [al_row]
			  ldc_importe  = this.object.importe   [al_row]
			
			  IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
				  this.object.cnta_prsp [al_row] = ls_null
				  this.object.importe   [al_row] = ll_null		
				  dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
				  dw_master.ii_update = 1
				  RETURN 
			  END IF
		  END IF				  
		  
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = TRUE				  
	  END IF	
	CASE 'centro_benef'
	
	
	  lstr_seleccionar.s_seleccion = 'S'
	  lstr_seleccionar.s_sql =	 'SELECT C.CENTRO_BENEF AS CODIGO, '&
												 +'B.DESC_CENTRO AS DESCRIPCION '&       
												 +'  FROM CENTRO_BENEF_USUARIO C,CENTRO_BENEFICIO B '&
												 +'WHERE C.CENTRO_BENEF = B.CENTRO_BENEF AND '&
												 +'C.COD_USR = '+"'"+gs_user+"'"
		  
	  OpenWithParm(w_seleccionar,lstr_seleccionar)
	  
	  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		  IF lstr_seleccionar.s_action = "aceptar" THEN
			  Setitem(al_row,'centro_benef',lstr_seleccionar.param1[1])
			  ii_update = 1
		  END IF
	CASE 'cnta_prsp'
	
	  ls_flag_provisionado = this.object.flag_provisionado [al_row]
	  IF (ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'O') THEN RETURN
	  
	  lstr_seleccionar.s_seleccion = 'S'
	  lstr_seleccionar.s_sql =	'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP   AS CODIGO , '&
												+'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION  '&
												+'FROM PRESUPUESTO_CUENTA '
			
												
	  OpenWithParm(w_seleccionar,lstr_seleccionar)
	  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
	  IF lstr_seleccionar.s_action = "aceptar" THEN
		
		  Setitem(al_row,'cnta_prsp',lstr_seleccionar.param1[1])
		  //afectacion presupuestal verificacion
		  IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
			  ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
			  ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
			  ls_cencos	   = this.object.cencos    [al_row]
			  ls_cnta_prsp = this.object.cnta_prsp [al_row]
			  ldc_importe  = this.object.importe   [al_row]
			
			  IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
				  this.object.cencos    [al_row] = ls_null
				  this.object.importe   [al_row] = ll_null		
				  dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
				  dw_master.ii_update = 1
				  RETURN 
			  END IF
		  END IF				  
		  
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = TRUE				  				  
	  END IF	
			  
END CHOOSE





end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3177
integer height = 744
long backcolor = 79741120
string text = "  Asientos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Compute!"
long picturemaskcolor = 536870912
dw_asiento_det dw_asiento_det
dw_asiento_cab dw_asiento_cab
end type

on tabpage_2.create
this.dw_asiento_det=create dw_asiento_det
this.dw_asiento_cab=create dw_asiento_cab
this.Control[]={this.dw_asiento_det,&
this.dw_asiento_cab}
end on

on tabpage_2.destroy
destroy(this.dw_asiento_det)
destroy(this.dw_asiento_cab)
end on

type dw_asiento_det from u_dw_abc within tabpage_2
integer width = 3099
integer height = 432
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_bak"
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw
ii_ck[6] = 6			// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master
ii_rk[4] = 4 	      // columnas que recibimos del master
ii_rk[5] = 5 	      // columnas que recibimos del master


idw_mst  = idw_asiento_cab // dw_master
idw_det  = idw_asiento_det // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()
/*Generacion de Asientos*/
ib_estado_asiento = FALSE
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_gen_aut[al_row] = '0'
end event

type dw_asiento_cab from u_dw_abc within tabpage_2
boolean visible = false
integer y = 448
integer width = 2729
integer height = 264
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                   	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
ii_dk[3] = 3 	      // columnas que se pasan al detalle
ii_dk[4] = 4 	      // columnas que se pasan al detalle
ii_dk[5] = 5 	      // columnas que se pasan al detalle


idw_mst  = idw_asiento_cab // dw_master
idw_det  = idw_asiento_det // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.flag_tabla [al_row] = '5'
end event

type cb_1 from commandbutton within w_fi309_cartera_de_cobros
integer x = 3136
integer y = 28
integer width = 439
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Referencias"
end type

event clicked;Long    ll_row_master,ll_ano,ll_mes
String  ls_cod_moneda,ls_cod_relacion,ls_mensaje,ls_confin
Decimal ldc_tasa_cambio
str_parametros sl_param

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return

//IF cbx_ref.checked THEN
//	Messagebox('Aviso','No Puede Ingresar Documentos con Referencia ya que Opcion de Ingresos sin referencia Esta Activa')
//	RETURN
//END IF

ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master]
ll_ano 			 = dw_master.object.ano 		   [ll_row_master]
ll_mes 			 = dw_master.object.mes 		   [ll_row_master]
ls_confin		 = dw_master.object.confin		   [ll_row_master]

//*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'B') then return //movimiento bancario

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Moneda en la cabecera, Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	Return
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	Messagebox('Aviso','Debe Ingresar Una Tasa de Cambio, Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF



sl_param.string3 = ls_cod_relacion

OpenWithParm(w_pop_help_edirecto,sl_param)

//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	sl_param = message.PowerObjectParm
END IF

sl_param.string1 = sl_param.string3

if upper(gs_empresa) = 'INNOVA' then
	sl_param.dw1		= 'd_doc_pendientes_innova_tbl'
else
	sl_param.dw1		= 'd_doc_pendientes_tbl'
end if
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.string2	= ls_cod_moneda
sl_param.string3	= ls_confin
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1CC'
sl_param.opcion   = 18  //cartera de cobros
sl_param.db1 		= 1350
sl_param.dw_m		= idw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_master.Object.imp_total [1] = wf_recalcular_monto_det ()
	dw_master.ii_update = 1
	idw_detail.ii_update = 1
	/*Generacion de Asientos*/
	ib_estado_asiento = TRUE
END IF

end event

type dw_master from u_dw_abc within w_fi309_cartera_de_cobros
integer width = 3026
integer height = 1068
string dataobject = "d_abc_cartera_cobros_cab_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)




ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst = dw_master
idw_det = idw_detail
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
Long       ll_row_gch,ll_count, ll_year, ll_mes
String     ls_cod_moneda,ls_nom_proveedor,ls_matriz,ls_descripcion,&
			  ls_cta_cntbl ,ls_ctabco       ,ls_codigo
Decimal{3} ldc_tasa_cambio
Date		  ld_fecha_emision


/*Generacion de Asientos*/
ib_estado_asiento = TRUE

CHOOSE CASE dwo.name
					
		 CASE 'cod_ctabco'
				select count(*)
				  into :ll_count
              from banco_cnta
				 where (cod_ctabco  = :data) ;
				
				if ll_count = 0 then
					Setnull(ls_ctabco)
					Setnull(ls_descripcion)
					Setnull(ls_cta_cntbl)
					Setnull(ls_cod_moneda)
					
					this.object.cod_ctabco             [row] = ls_ctabco
				   this.object.banco_cnta_descripcion [row] = ls_descripcion
				   this.object.cnta_ctbl				  [row] = ls_cta_cntbl
				   this.object.banco_cnta_cod_moneda  [row] = ls_cod_moneda	
			
			
				   /*actualizo moneda de transacion*/
				   This.object.cod_moneda  [row]	= ls_cod_moneda
					
				   wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
					
				   This.Object.imp_total [row] =	wf_recalcular_monto_det()

					Messagebox('Aviso','Cuenta de Banco No Existe Verifique!')
					Return 1
				else
					select cod_ctabco,descripcion,cnta_ctbl,cod_moneda
				     into :ls_ctabco,:ls_descripcion,:ls_cta_cntbl,:ls_cod_moneda
                 from banco_cnta
				    where (cod_ctabco = :data) ;
				
	
				   this.object.cod_ctabco             [row] = ls_ctabco
				   this.object.banco_cnta_descripcion [row] = ls_descripcion
				   this.object.cnta_ctbl				  [row] = ls_cta_cntbl
				   this.object.banco_cnta_cod_moneda  [row] = ls_cod_moneda	
					
			
			
				   /*actualizo moneda de transacion*/
				   This.object.cod_moneda  [row]	= ls_cod_moneda
				
				   ldc_tasa_cambio = This.object.tasa_cambio [row]
					
					
				   // Actualiza Tipo de Moneda y Tasa Cambio
				   wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
					
				   This.Object.imp_total [row] =	wf_recalcular_monto_det()

					
				end if
				
		 CASE 'tasa_cambio'
			   ls_cod_moneda   = This.object.cod_moneda  [row]	
				ldc_tasa_cambio = This.object.tasa_cambio [row]
				
				// Actualiza Tipo de Moneda y Tasa Cambio
				wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
				This.Object.imp_total [row] =	wf_recalcular_monto_det()				
				
		CASE	'fecha_emision'
				ld_fecha_emision = date(this.object.fecha_emision[row])
				ll_year 	= Long(String(ld_fecha_emision,'yyyy'))
				ll_mes	= Long(String(ld_fecha_emision,'mm'))
				
				if not invo_asiento_cntbl.of_val_mes_cntbl( ll_year, ll_mes, "B") then
					this.object.fecha_emision	[row] = Date(gnvo_app.of_fecha_actual())
					this.object.ano 				[row] = Long(String(gnvo_app.of_fecha_actual(),'yyyy'))
					this.object.mes			 	[row] = Long(String(gnvo_app.of_fecha_actual(),'mm'))
					RETURN 1
				end if 
				
				This.object.mes [row] = ll_mes					
				This.object.ano [row] = ll_year
				
				//busca tipo de cambio
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
				
				ls_cod_moneda   = This.object.cod_moneda  [row]	
				ldc_tasa_cambio = This.object.tasa_cambio [row]
				
				// Actualiza Tipo de Moneda y Tasa Cambio
				wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
				This.Object.imp_total [row] =	wf_recalcular_monto_det()								

				
		 CASE 'cod_relacion'
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM proveedor p 
				 WHERE (p.proveedor   = :data) and
				 		 (p.flag_estado = '1'  ) ;
				 
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Codigo de proveedor No Existe')
					This.Object.cod_relacion 	  [row] = ''
					Return 1
				ELSE
					SELECT p.nom_proveedor
			 		  INTO :ls_nom_proveedor
					  FROM proveedor p
					 WHERE p.proveedor = :data ;

					This.Object.nom_proveedor    [row]   = ls_nom_proveedor

				END IF
		 CASE	'fecha_emision'	
				ld_fecha_emision = Date(This.object.fecha_emision  [row]	)
				ls_cod_moneda    = This.object.cod_moneda  [row]	
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
				ldc_tasa_cambio = This.object.tasa_cambio [row]
				
				// Actualiza Tipo de Moneda y Tasa Cambio
				wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
				This.Object.imp_total [row] =	wf_recalcular_monto_det()								
				
		 CASE 'confin'
				SELECT matriz_cntbl,descripcion
				  INTO :ls_matriz,:ls_descripcion
			     FROM concepto_financiero
				 WHERE confin = :data ;
				 
				
				IF Isnull(ls_matriz) OR Trim(ls_matriz) = '' THEN
					Messagebox('Aviso','Concepto Financiero No existe Verifique')
					This.Object.confin [row] = ''
					Return 1
				ELSE
					This.object.matriz_cntbl [row] = ls_matriz
					This.object.descripcion  [row] = ls_descripcion
				END IF
		
		CASE 'tipo_doc'
				select desc_tipo_doc
				  into :ls_descripcion 
				  from doc_tipo 
				 where tipo_doc = :data 
				   and flag_estado = '1'
					and cod_sunat_tabla1 is not null;
				
				if SQLCA.SQlCode = 100 then
					
					messagebox('Aviso',"Documento " + data + " No Existe, no esta activo o no corresponde a un medio de pago, por favor Verifique!")
					this.object.tipo_doc      [row] = gnvo_app.is_null
					this.object.desc_tipo_doc [row] = gnvo_app.is_null
					return 1
				end if
				
				this.object.desc_tipo_doc [row] = ls_descripcion
							
END CHOOSE				
				






end event

event ue_insert_pre;call super::ue_insert_pre;Long 		ll_nro_libro 
DateTime	ldt_now

ldt_now = gnvo_app.of_fecha_Actual()

ib_cierre = false
dw_master.object.t_cierre.text = ''

IF f_nro_libro_cobros(ll_nro_libro) = FALSE THEN Messagebox('Aviso','No Existe Nro de Libro , Verifique Tabla de Parametros Finparam , Campo libro_cobros')

This.Object.origen 		      [al_row] = gs_origen
This.Object.cod_usr 		      [al_row] = gs_user
This.Object.nro_libro	      [al_row] = ll_nro_libro
This.Object.fecha_emision     [al_row] = Date(ldt_now)
This.Object.tasa_cambio       [al_row] = gnvo_app.of_tasa_cambio()
This.Object.ano			      [al_row] = Long(String(ldt_now,'YYYY'))
This.Object.mes			      [al_row] = Long(String(ldt_now,'MM'))
This.Object.flag_estado       [al_row] = '1'
This.Object.flag_tiptran      [al_row] = '3' //cartera de cobros
This.Object.flag_conciliacion [al_row] = '1' //falta conciliar
this.object.fec_registro		[al_row] = ldt_now

is_action = 'new'
//

end event

event ue_display;call super::ue_display;IF Getrow() = 0 THEN Return

String 	ls_name,ls_prot, ls_codigo, ls_data, ls_data2, ls_data3, ls_data4, ls_sql
boolean	lb_ret

str_parametros   lstr_param
String ls_cod_moneda, ls_saldo_disponible
Decimal {4} ldc_tasa_cambio
Decimal ldc_saldo

CHOOSE CASE lower(as_columna)
	CASE 'cod_ctabco'
		ls_sql = "SELECT 	bc.COD_CTABCO AS CUENTA_BANCO ,"&
				 + "		  	bc.DESCRIPCION AS DESCRIPCION ,"&
				 + "			bc.CNTA_CTBL AS CUENTA_CONTABLE,"&      
				 + "			bc.COD_MONEDA AS MONEDA,"&
				 + "			bc.SALDO_DISPONIBLE  AS SALDO "&
			    + "FROM BANCO_CNTA bc " &
				 + "where bc.flag_estado = '1'"
				 
		lb_ret = f_lista_5ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, ls_data4, "2")
		
		if ls_codigo <> "" then
			this.object.cod_ctabco							[al_row] = ls_codigo
			this.object.desc_banco_cnta					[al_row] = ls_data
			this.object.cnta_ctbl							[al_row] = ls_data2
			this.object.banco_cnta_cod_moneda			[al_row] = ls_data3
			this.object.cod_moneda							[al_row] = ls_data3
			this.object.saldo_disponible					[al_row] = dec(ls_data4)
			
			ldc_tasa_cambio = This.object.tasa_cambio [al_row]
			ls_cod_moneda	 = ls_data3
					
			// Actualiza Tipo de Moneda y Tasa Cambio
			wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
					
			// Recalcula Detalle					
			This.Object.imp_total [al_row] =	wf_recalcular_monto_det()
					
			this.ii_update = 1
					
			/*Generacion de Asientos*/
			ib_estado_asiento = true					
					
		END IF	
				
	CASE 'cod_relacion'
		if upper(gs_empresa) = 'INNOVA' then
			ls_sql = "select distinct " &
					 + "       p.proveedor as codigo, " &
					 + "       p.nom_proveedor as nom_cliente, " &
					 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, " &
					 + "       a.mnz, " &
					 + "       a.lote " &
					 + "from proveedor p, " &
					 + "     cntas_cobrar cc, " &
					 + "     cntas_cobrar_det ccd, " &
					 + "     articulo         a " &
					 + "where p.proveedor = cc.cod_relacion (+) " &
					 + "  and cc.tipo_doc = ccd.tipo_doc    (+) " &
					 + "  and cc.nro_doc  = ccd.nro_doc     (+) " &
					 + "  and ccd.cod_art = a.cod_art       (+) " &
					 + "  and p.flag_estado	= '1'"
			
		else
			ls_sql = "SELECT P.Proveedor     AS codigo ,"&
					 + "P.NOM_PROVEEDOR AS NOMBRE_cliente, "&
					 + "decode(p.tipo_doc_ident, '6', P.RUC, p.nro_doc_ident) as RUC_DNI " &
					 + "FROM PROVEEDOR P " &
					 + "WHERE P.FLAG_ESTADO ='1'"
		end if
			
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_relacion 	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
					
			/*Generacion de Asientos*/
			ib_estado_asiento = true					
					
		END IF		
				
	CASE 'confin'
		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 3
		lstr_param.str_array[1] = '3'
		lstr_param.str_array[2] = '4'
		lstr_param.titulo 		= 'Selección de Concepto Financiero'
		lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_asiento = TRUE
			/**/
		END IF


	CASE 'tipo_doc'
		ls_sql = "SELECT dt.TIPO_DOC AS CODIGO_DOC, " &
				 + "dt.DESC_TIPO_DOC AS DESCRIPCION " &
				 + "FROM DOC_TIPO dt " &
				 + "where dt.flag_estado = '1' " &
				 + "  and dt.cod_sunat_tabla1 is not null "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.tipo_doc 		[al_row] = ls_codigo
			this.object.desc_tipo_doc 	[al_row] = ls_data
			
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = true					
		  
		END IF	
														
		
END CHOOSE



end event

type gb_2 from groupbox within w_fi309_cartera_de_cobros
integer x = 3209
integer y = 224
integer width = 347
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

