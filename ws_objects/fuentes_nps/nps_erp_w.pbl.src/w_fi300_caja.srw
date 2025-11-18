$PBExportHeader$w_fi300_caja.srw
forward
global type w_fi300_caja from w_abc
end type
type cb_2 from commandbutton within w_fi300_caja
end type
type tab_1 from tab within w_fi300_caja
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
type tab_1 from tab within w_fi300_caja
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_1 from commandbutton within w_fi300_caja
end type
type dw_master from u_dw_abc within w_fi300_caja
end type
type cb_3 from commandbutton within w_fi300_caja
end type
end forward

global type w_fi300_caja from w_abc
integer width = 4389
integer height = 2212
string title = "Caja y Bancos (FI300)"
string menuname = "m_mantenimiento_cl_tes_anular"
event ue_anular ( )
event ue_print_preview ( )
cb_2 cb_2
tab_1 tab_1
cb_1 cb_1
dw_master dw_master
cb_3 cb_3
end type
global w_fi300_caja w_fi300_caja

type variables
String is_accion,is_soles,is_doc_ov,is_cnta_prsp,is_doc_ret 
Boolean ib_estado_asiento = TRUE
Decimal {2} idc_tasa_retencion
uf_asiento_contable if_asiento_contable
u_dw_abc  	idw_detail
DatawindowChild idw_doc_tipo
u_ds_base 	ids_asiento_adic, ids_doc_pend_tbl, &
				ids_matriz_cntbl_Det, ids_glosa, &
				ids_crelacion_ext_tbl, ids_rpt
end variables

forward prototypes
public subroutine wf_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio)
public function decimal wf_recalcular_monto_det ()
public subroutine wf_verificacion_items_x_retencion ()
public subroutine wf_verificacion_retencion ()
public function boolean wf_genera_cretencion (long al_nro_serie, ref string as_mensaje, ref string as_nro_doc)
public function boolean wf_generacion_cntas ()
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado)
public function boolean wf_insert_referencia (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_referencia)
public function boolean wf_update_deuda_financiera ()
public subroutine wf_post_update ()
public function boolean wf_genera_doc_retencion (string as_flag_retencion, decimal adc_tasa_cambio, decimal adc_imp_ret_sol, decimal adc_imp_ret_dol, datetime adt_fecha_doc, string as_origen, long al_nro_registro)
public function date of_ultima_fecha (string as_banco)
public function decimal of_tasa_cambio (date ad_fecha)
end prototypes

event ue_anular;Integer li_opcion
String  ls_flag_estado ,ls_origen_cb  ,ls_result     ,ls_mensaje ,ls_nro_programa
Long    ll_row_master  ,ll_nro_reg_cb ,ll_nro_reg_ch ,ll_ano	 ,&
		  ll_mes			  ,ll_inicio	  ,ll_count	 

ll_row_master  = dw_master.getrow()

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
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	Return
END IF


//programa de pagos
select Count(*) into :ll_count
  from programacion_pagos_det
 where (origen_caja  = :ls_origen_cb  ) AND  
       (nro_reg_caja = :ll_nro_reg_cb )   ;
		 
if ll_count > 0 then
	select nro_prog_pago into :ls_nro_programa
	  from programacion_pagos_det
	 where (origen_caja  = :ls_origen_cb  ) AND  
   	    (nro_reg_caja = :ll_nro_reg_cb )   ;
	
	
	Messagebox('Aviso','No se puede Anular Registro esta Vinculado a Programa de Pago Nº '+ls_nro_programa)
	Return
end if




IF (dw_master.ii_update = 1                      OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
    tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF	 

//------------------------------------------------
li_opcion = MessageBox('Anula Cartera de Pagos','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN

//*****************************************************************//
//*actualizar flag de estado de comprobante de retencion y cheques*//
//*****************************************************************//
/*Replicacion*/
UPDATE retencion_igv_crt
   SET flag_estado = '0',flag_replicacion = '1'
 WHERE ((origen           = :ls_origen_cb  ) AND
        (nro_reg_caja_ban = :ll_nro_reg_cb )) ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Update Retencion IGV CRT', SQLCA.SQLErrText)
	Return
END IF

//ELIMINA DATOS DE DEUDA FINANCIERA
delete from deuda_fin_det_cja_ban_det 
 where (origen 			 = :ls_origen_cb  ) and
 		 (nro_registro_cja = :ll_nro_reg_cb ) ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Delete Deuda Financiera', SQLCA.SQLErrText)
	Return
END IF
		 

	
//cheque 	
/*Replicacion*/
UPDATE cheque_emitir
   SET flag_estado = '0' ,importe = 0.00 ,flag_replicacion = '1'
 WHERE (nro_registro = :ll_nro_reg_ch);

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Update Cheque Emitir', SQLCA.SQLErrText)
	Return
END IF

//*****************************************************************//


dw_master.object.flag_estado [ll_row_master] = '0'
dw_master.object.imp_total   [ll_row_master] = 0.00

DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0 
	tab_1.tabpage_1.dw_detail.TriggerEvent('ue_delete')
LOOP

FOR ll_inicio =1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount() 
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT


dw_master.ii_update = 1
tab_1.tabpage_2.dw_asiento_det.ii_update = 1

TriggerEvent('ue_modify')
is_accion = 'delete'
/*No  Generación de Pre Asientos*/
ib_estado_asiento = FALSE
/**/
end event

event ue_print_preview();Str_cns_pop lstr_cns_pop
String      ls_origen,ls_nro_reg

//////Verificacion de Nro de Orden
ls_origen  = dw_master.GetItemString(1, 'origen'   )
ls_nro_reg = Trim(String(dw_master.GetItemNumber(1, 'nro_registro')))


lstr_cns_pop.arg[1] = ls_origen
lstr_cns_pop.arg[2] = ls_nro_reg


//voucher
lstr_cns_pop.arg[3] = 'd_rpt_formato_chq_voucher_preview'


//tipo de ot
OpenSheetWithParm(w_fi728_voucher_o_chq, lstr_cns_pop, this, 2, Layered!)

end event

public subroutine wf_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio);Long   ll_inicio
String ls_flag_provisionado

for ll_inicio = 1  to tab_1.tabpage_1.dw_detail.Rowcount()
	 ls_flag_provisionado = tab_1.tabpage_1.dw_detail.object.flag_provisionado [ll_inicio]
	 
	 tab_1.tabpage_1.dw_detail.object.cod_moneda_cab [ll_inicio] = as_moneda
	 tab_1.tabpage_1.dw_detail.object.tasa_cambio	 [ll_inicio] = adc_tasa_cambio
	 
	 //colocar moneda en el detalle cuando sea un ingreso indirecto
	 IF ls_flag_provisionado = 'N' THEN
		 tab_1.tabpage_1.dw_detail.object.cod_moneda [ll_inicio] = as_moneda
		 tab_1.tabpage_1.dw_detail.ii_update = 1	 
	 END IF
next


end subroutine

public function decimal wf_recalcular_monto_det ();String ls_soles,ls_dolares,ls_moneda_ref,ls_moneda_cab
Long   ll_inicio,ll_factor
Decimal {2} ldc_importe_total,ldc_importe
Decimal {3} ldc_tasa_cambio


f_monedas(ls_soles,ls_dolares)

dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()


ldc_importe_total = 0.00
ldc_importe   = 0.00

For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_importe 		= tab_1.tabpage_1.dw_detail.object.importe        	[ll_inicio]
	 ls_moneda_ref	  	= tab_1.tabpage_1.dw_detail.object.cod_moneda    [ll_inicio]
 	 ll_factor       	= tab_1.tabpage_1.dw_detail.object.factor	      [ll_inicio]
	 ls_moneda_cab   	= dw_master.object.cod_moneda							[dw_master.GetRow()]
	 
	 IF Isnull(ldc_importe) THEN ldc_importe = 0.00
	 
	 IF ls_moneda_cab =  ls_moneda_ref THEN
		 ldc_importe = ldc_importe * ll_factor
	 ELSEIF ls_moneda_ref = ls_soles THEN
		 ldc_importe = Round(ldc_importe / ldc_tasa_cambio,2) * ll_factor
	 ELSEIF ls_moneda_ref = ls_dolares THEN
		 ldc_importe = Round(ldc_importe * ldc_tasa_cambio,2) * ll_factor
	 END IF	
	 
	 //acumulador
	 ldc_importe_total += ldc_importe
	 
Next


Return Round(ldc_importe_total,2)
end function

public subroutine wf_verificacion_items_x_retencion ();String ls_expresion,ls_flag_retencion
Long   ll_found,ll_row_master

ll_row_master = dw_master.getrow()
Setnull(ls_flag_retencion)


tab_1.tabpage_1.dw_detail.Accepttext()

ls_expresion = "flag_ret_igv = '1'"

ll_found = tab_1.tabpage_1.dw_detail.find(ls_expresion,1,tab_1.tabpage_1.dw_detail.rowcount())


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
Decimal {2}	ldc_imp_min_ret_igv,ldc_porc_ret_igv   ,ldc_imp_pagar    ,ldc_total_pagar,&
				ldc_imp_total      ,ldc_imp_total_pagar,ldc_imp_retencion
Decimal {3} ldc_tasa_cambio
Boolean     lb_flag = FALSE
Datetime		ldt_fecha_emision
Datetime	   ldt_fec_ret_igv

dw_master.accepttext()
tab_1.tabpage_1.dw_detail.accepttext()

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
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ls_cod_relacion = tab_1.tabpage_1.dw_detail.object.cod_relacion [ll_inicio]
	 
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
	 	 tab_1.tabpage_1.dw_detail.SetFilter(ls_expresion)
	 	 tab_1.tabpage_1.dw_detail.Filter() 
		  

		  
		 FOR ll_inicio_det = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
			  ls_tipo_doc   = tab_1.tabpage_1.dw_detail.object.tipo_doc   [ll_inicio_det]
			  ls_nro_doc    = tab_1.tabpage_1.dw_detail.object.nro_doc    [ll_inicio_det]
			  ldc_imp_pagar = tab_1.tabpage_1.dw_detail.object.importe    [ll_inicio_det] 
			  ls_cod_moneda = tab_1.tabpage_1.dw_detail.object.cod_moneda [ll_inicio_det] 	
			  ll_factor		 = tab_1.tabpage_1.dw_detail.object.factor	  [ll_inicio_det] 	
			  
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
				
 		  		  tab_1.tabpage_1.dw_detail.object.flag_impuesto [ll_inicio_det] = '1' //activo
	 
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
		 
			 For ll_inicio_det = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
				  ls_cod_relacion  = tab_1.tabpage_1.dw_detail.object.cod_relacion  [ll_inicio_det]
				  ls_tipo_doc		 = tab_1.tabpage_1.dw_detail.object.tipo_doc		  [ll_inicio_det] 
				  ls_nro_doc		 = tab_1.tabpage_1.dw_detail.object.nro_doc 		  [ll_inicio_det]
		        ldc_imp_pagar    = tab_1.tabpage_1.dw_detail.object.importe       [ll_inicio_det] 		
				  ls_flag_impuesto = tab_1.tabpage_1.dw_detail.object.flag_impuesto [ll_inicio_det]
				  ls_cod_moneda 	 = tab_1.tabpage_1.dw_detail.object.cod_moneda    [ll_inicio_det]
				  
		 		  IF ls_flag_impuesto = '1' THEN
 	
			 		  IF ls_cod_moneda <> ls_soles THEN 
			 	 		  ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
	    	 		  END IF
			  
					  tab_1.tabpage_1.dw_detail.object.flag_ret_igv [ll_inicio_det] = '1' //retencion activada
			 
			 		  ldc_imp_retencion = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
			 		  tab_1.tabpage_1.dw_detail.object.impt_ret_igv [ll_inicio_det] = ldc_imp_retencion
					  
					  
		        END IF
		 
			 Next
		 END IF
		 
		 /*operacion de pago*/
		 
		 IF ldc_imp_total_pagar > ldc_imp_min_ret_igv THEN
			
		    For ll_inicio_det = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
				  ls_cod_relacion  = tab_1.tabpage_1.dw_detail.object.cod_relacion  [ll_inicio_det]
				  ls_tipo_doc		 = tab_1.tabpage_1.dw_detail.object.tipo_doc		  [ll_inicio_det] 
				  ls_nro_doc		 = tab_1.tabpage_1.dw_detail.object.nro_doc 		  [ll_inicio_det]
				  ldc_imp_pagar    = tab_1.tabpage_1.dw_detail.object.importe       [ll_inicio_det] 		
				  ls_flag_impuesto = tab_1.tabpage_1.dw_detail.object.flag_impuesto [ll_inicio_det]
				  ls_cod_moneda 	 = tab_1.tabpage_1.dw_detail.object.cod_moneda    [ll_inicio_det]
 
				  IF ls_flag_impuesto = '1' THEN

					  IF ls_cod_moneda <> ls_soles THEN 
					 	  ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
			    	  END IF
						
		 			  tab_1.tabpage_1.dw_detail.object.flag_ret_igv [ll_inicio_det] = '1' //retencion activada
		 
		 			  ldc_imp_retencion = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
					  tab_1.tabpage_1.dw_detail.object.impt_ret_igv [ll_inicio_det] = ldc_imp_retencion
					  
				  END IF /*segun flag de impuesto*/
			 Next /*fin del for*/
	    END IF /*fin de operacion de pago*/
    END IF /*fin de proveedor habilitado*/
	 
	/*inicializar*/	 
	
	lb_flag = false	 
	ldc_imp_total_pagar = 0.00
	ldc_imp_total		  = 0.00	

	/*desfiltrado*/ 
	tab_1.tabpage_1.dw_detail.SetFilter('')
	tab_1.tabpage_1.dw_detail.Filter()
	/*ordenamiento*/
	tab_1.tabpage_1.dw_detail.SetSort('item a')
	tab_1.tabpage_1.dw_detail.Sort()
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

public function boolean wf_generacion_cntas ();Boolean lb_ret = TRUE
/*generacion de cntas*/

IF f_generacion_cntas_cb (dw_master                      ,tab_1.tabpage_1.dw_detail , &
								  tab_1.tabpage_2.dw_asiento_det ,ids_matriz_cntbl_det      , &
								  ids_glosa                      ,ids_doc_pend_tbl          , &
								  ids_asiento_adic					,ids_crelacion_ext_tbl ) = FALSE THEN
	//elimina asientos generados
	DO WHILE tab_1.tabpage_2.dw_asiento_det.Rowcount() > 0
		tab_1.tabpage_2.dw_asiento_det.deleterow(0)
	LOOP								  
	/**/
	
	lb_ret = FALSE
	
ELSE
	tab_1.tabpage_2.dw_asiento_det.ii_update = 1
END IF	



Return lb_ret
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

public function boolean wf_insert_referencia (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_referencia);Boolean lb_ret = TRUE
String  ls_msj_err,ls_origen_ov



 /*BUSCAR ORIGEN*/
select cod_origen into :ls_origen_ov from orden_venta where nro_ov = :as_referencia ;

Insert Into doc_referencias
(cod_relacion ,tipo_doc ,nro_doc ,tipo_mov ,origen_ref ,tipo_ref ,nro_ref)
 Values
 (:as_cod_relacion ,:as_tipo_doc ,:as_nro_doc ,'R',:ls_origen_ov ,:is_doc_ov,:as_referencia ) ;
			 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error',ls_msj_err)
   lb_ret = false
END IF

Return lb_ret
end function

public function boolean wf_update_deuda_financiera ();Long   ll_inicio,ll_nro_reg,ll_item
String ls_origen,ls_tipo_doc,ls_nro_doc
Decimal {2} ldc_monto_proy,ldc_monto_real
Boolean lb_ret = TRUE   


		 

For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.rowcount()
	 ls_origen  	 = tab_1.tabpage_1.dw_detail.object.origen       [ll_inicio]
	 ll_nro_reg 	 = tab_1.tabpage_1.dw_detail.object.nro_registro [ll_inicio]
	 ll_item			 = tab_1.tabpage_1.dw_detail.object.nro_item		 [ll_inicio]
	 ls_tipo_doc	 = tab_1.tabpage_1.dw_detail.object.tipo_doc	    [ll_inicio]
	 ls_nro_doc		 = tab_1.tabpage_1.dw_detail.object.nro_doc	    [ll_inicio]
	 ldc_monto_real = tab_1.tabpage_1.dw_detail.object.importe	    [ll_inicio]
	 
	 
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

public subroutine wf_post_update ();Long   ll_inicio,ll_row_master
String ls_null,ls_flag_provisionado,ls_flag_retencion


ll_row_master = dw_master.getrow()

/*Elimina Informacion de Tabla Temporal*/
delete from tt_fin_deuda_financiera ;

/*No Genera Asientos */
ib_estado_asiento = FALSE
		

/* actualiza valores flag detalle */
for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.flag_doc [ll_inicio] = ls_null
	 
	 ls_flag_provisionado = tab_1.tabpage_1.dw_detail.object.flag_provisionado [ll_inicio]
	 
	 IF ls_flag_provisionado = 'N' THEN
		 tab_1.tabpage_1.dw_detail.object.flag_partida [ll_inicio] = '1'
	 END IF

next

/*setear flag de retencion*/
SetNull(ls_flag_retencion)
dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
end subroutine

public function boolean wf_genera_doc_retencion (string as_flag_retencion, decimal adc_tasa_cambio, decimal adc_imp_ret_sol, decimal adc_imp_ret_dol, datetime adt_fecha_doc, string as_origen, long al_nro_registro);String ls_cod_relacion,ls_nro_cr
Long   ll_inicio
Boolean lb_ret = true

IF as_flag_retencion = '1' THEN /*cabecera*/
	FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount()
		ls_cod_relacion = ids_crelacion_ext_tbl.object.cod_relacion [ll_inicio]
		ls_nro_cr	    = ids_crelacion_ext_tbl.object.nro_cr       [ll_inicio]
	 
	   /*encontrar monto de cri x proveedor*/
		f_monto_cri_x_prov(tab_1.tabpage_1.dw_detail,ls_cod_relacion,adc_tasa_cambio,adc_imp_ret_sol,adc_imp_ret_dol)
	   
		/*SE GENERA COMPROBANTE DE RETENCION*/
		INSERT INTO retencion_igv_crt
		(nro_certificado,fecha_emision,origen    ,nro_reg_caja_ban,
		 proveedor      ,flag_estado  ,flag_tabla,importe_doc     ,
		 saldo_sol		 ,saldo_dol    ,flag_replicacion)  
		VALUES
		(:ls_nro_cr       ,:adt_fecha_doc   ,:as_origen ,:al_nro_registro,
     	 :ls_cod_relacion ,'1'			      ,'5'			 ,:adc_imp_ret_sol,
		 :adc_imp_ret_sol ,:adc_imp_ret_dol ,'1'	)  ;
	   
		
		IF SQLCA.SQLCode = -1 THEN 
			MessageBox("SQL error", SQLCA.SQLErrText)
			lb_ret = FALSE
			GOTO SALIDA
		END IF
		
		
		
	NEXT
END IF


SALIDA:

Return lb_ret


end function

public function date of_ultima_fecha (string as_banco);date ld_fecha
string ls_mensaje

select max(fecha)
	into :ld_fecha
from cierre_caja
where cod_banco = :as_banco;

if SQLCA.SQLCode = 100 or IsNull(ld_fecha) then
	ls_mensaje = "Caja nunca ha sido aperturada " 
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)

end if

return ld_fecha
end function

public function decimal of_tasa_cambio (date ad_fecha);Decimal {3} ldc_tasa_cambio



SELECT vta_dol_prom
  INTO :ldc_tasa_cambio
  FROM calendario
 WHERE trunc(fecha) = :ad_fecha;   

 
IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','No existe Tasa de Cambio del Dia ' + string(ad_fecha, 'dd/mm/yyyy') + ', Verifique!')	
	return 0
END IF

Return ldc_tasa_cambio
end function

on w_fi300_caja.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_tes_anular" then this.MenuID = create m_mantenimiento_cl_tes_anular
this.cb_2=create cb_2
this.tab_1=create tab_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.cb_3
end on

on w_fi300_caja.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.cb_3)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asiento_cab.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asiento_det.SetTransObject(sqlca)

idw_1 = dw_master              				             // asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!	 // indicar dw_detail como no activado

//crea objeto
if_asiento_contable = create uf_asiento_contable


//** Insertamos GetChild de Tipo de Documento dw_master **//
dw_master.Getchild('tipser',idw_doc_tipo )
idw_doc_tipo.settransobject(sqlca)
idw_doc_tipo.Retrieve()
idw_doc_tipo.SetFilter("cod_usr = '"+gnvo_app.is_user+"'")
idw_doc_tipo.Filter()


/*u_ds_base de Generacion de Cuentas*/
//** u_ds_base Detalle Asiento **//
ids_asiento_adic 			   = Create u_ds_base
ids_asiento_adic.DataObject = 'd_abc_datos_asiento_x_doc_tbl'
ids_asiento_adic.SettransObject(sqlca)
//** **//

//** u_ds_base Doc Pendientes Cta CTE **//
ids_doc_pend_tbl = Create u_ds_base
ids_doc_pend_tbl.DataObject = 'd_doc_pend_x_aplic_doc_tbl'
ids_doc_pend_tbl.SettransObject(sqlca)
//** **//


//** u_ds_base Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create u_ds_base
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)
//** **//

//** u_ds_base Glosa **//
ids_glosa = Create u_ds_base
ids_glosa.DataObject = 'd_glosa_cb_tbl'
ids_glosa.SettransObject(sqlca)


//** u_ds_base de datawindow Externo**//
ids_crelacion_ext_tbl = Create u_ds_base
ids_crelacion_ext_tbl.DataObject = 'd_abc_ext_codigo_tbl'
ids_crelacion_ext_tbl.SettransObject(sqlca)
//** **//

//** u_ds_base de reportes externos **//
ids_crelacion_ext_tbl = Create u_ds_base
//** **//


/*PARAMETRO DE SOLES*/
select cod_soles,doc_ov 
	into :is_soles,:is_doc_ov 
from logparam 
where reckey = '1' ;

select porc_ret_igv,cntas_prsp_gfinan,doc_ret_igv_crt 
	into :idc_tasa_retencion,:is_cnta_prsp,:is_doc_ret  
from finparam 
where reckey = '1' ;

end event

event ue_insert;call super::ue_insert;Long   ll_row
String ls_cod_moneda
Decimal {3} ldc_tasa_cambio

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

IF idw_1 = tab_1.tabpage_1.dw_detail THEN
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
   
	dw_master.il_row = dw_master.Getrow()
ELSE
	triggerevent('ue_update_request')
	
	IF ib_update_check = False THEN RETURN
	//cabecera
	is_accion = 'new'
	dw_master.Reset()
	idw_detail.Reset()
END IF	

ll_row = idw_1.Event ue_insert()
	
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
end event

event resize;call super::resize;
tab_1.width  = newwidth  - tab_1.x - this.cii_windowborder
tab_1.height = p_pie.y - tab_1.y

idw_detail = tab_1.tabpage_1.dw_detail

idw_detail.width       = tab_1.tabpage_1.width  - idw_detail.x - this.cii_windowborder
idw_detail.height      = tab_1.tabpage_1.height - idw_detail.y - this.cii_windowborder


end event

event ue_update_pre;call super::ue_update_pre;Long   ll_ano,ll_mes,ll_nro_registro,ll_inicio,ll_found,ll_ins_new,ll_nro_serie,ll_item,ll_nro_libro,&
		 ll_nro_asiento,ll_found_cri, ll_count
		 
String ls_result    ,ls_mensaje      ,ls_cod_origen ,ls_flag_retencion    ,ls_tip_ser         ,ls_flag_estado ,&
		 ls_expresion ,ls_cod_relacion ,ls_nro_ret    ,ls_tipo_doc          ,ls_nro_doc	       ,ls_cod_moneda  ,&
		 ls_cod_usr   ,ls_cencos		 ,ls_cnta_prsp  ,ls_flag_provisionado ,ls_flag_referencia ,ls_referencia  ,&
		 ls_expresion_cri
		 
		 
Decimal {2} ldc_importe_total,ldc_totsoldeb,ldc_totdoldeb,ldc_totsolhab,ldc_totdolhab
Decimal {3} ldc_tasa_cambio
Datetime    ldt_fecha_cntbl
dwItemStatus ldis_status

Boolean	lb_retorno


IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


/*datos de cabecera*/
ls_cod_origen     = dw_master.object.origen		  	 [dw_master.getrow()]				 
ll_nro_registro   = dw_master.object.nro_registro	 [dw_master.getrow()]				 
ls_flag_estado		= dw_master.object.flag_estado    [dw_master.getrow()]
ldc_importe_total	= dw_master.object.imp_total	    [dw_master.getrow()]
ls_cod_moneda		= dw_master.object.cod_moneda     [dw_master.getrow()]
ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [dw_master.getrow()]
ls_cod_usr			= dw_master.object.cod_usr 	 	 [dw_master.getrow()]

/*importe del documento > 0*/
IF ls_flag_estado <> '0' THEN
	IF Isnull(ldc_importe_total) OR ldc_importe_total = 0 THEN
		Messagebox('Aviso','Debe Ingresar Importe del Documento')
		ib_update_check = False	
		Return
	ELSE
		ib_update_check = True
	END IF
END IF


IF tab_1.tabpage_1.dw_detail.Rowcount() = 0  AND is_accion <> 'delete' THEN
	Messagebox('Aviso','Debe Ingresar Registro en el Detalle , Verifique!')
	ib_update_check = False	
	Return
END IF


IF is_accion = 'new' THEN
	Setnull(ll_nro_registro)
	IF f_genera_registro_cb(ls_cod_origen,ll_nro_registro) = FALSE THEN
		ib_update_check = False	
		RETURN
	ELSE
		dw_master.object.nro_registro	[dw_master.getrow()] = ll_nro_registro
		ib_update_check = True
	END IF
	
END IF



		
//Detalle de Documento
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 /*validar que datos esten completos*/
	 ls_cod_relacion      = tab_1.tabpage_1.dw_detail.object.cod_relacion      [ll_inicio]
	 ls_tipo_doc	       = tab_1.tabpage_1.dw_detail.object.tipo_doc	         [ll_inicio]	
	 ls_nro_doc		       = tab_1.tabpage_1.dw_detail.object.nro_doc		      [ll_inicio]	
	 ll_item			       = tab_1.tabpage_1.dw_detail.object.nro_item			   [ll_inicio]	
	 
	 
	 IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
		 Messagebox('Aviso','Debe Ingresar Codigo de Relacion en el Detalle ,Item : '+Trim(String(ll_item)))
		 tab_1.SelectedTab = 1
		 tab_1.tabpage_1.dw_detail.Setfocus()
		 tab_1.tabpage_1.dw_detail.Setcolumn('cod_relacion')
		 tab_1.tabpage_1.dw_detail.Setrow(ll_inicio)
		 ib_update_check = False	
		 RETURN		
	 END IF
	 
	 IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
		 Messagebox('Aviso','Debe Ingresar Tipo de Documento en el Detalle ,Item : '+Trim(String(ll_item)))
		 tab_1.SelectedTab = 1
		 tab_1.tabpage_1.dw_detail.Setfocus()
		 tab_1.tabpage_1.dw_detail.Setcolumn('tipo_doc')
		 tab_1.tabpage_1.dw_detail.Setrow(ll_inicio)
		 ib_update_check = False	
		 RETURN		
	 END IF
	 
	 IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
		 Messagebox('Aviso','Debe Ingresar Nro de Documento en el Detalle ,Item : '+Trim(String(ll_item)))
		 tab_1.SelectedTab = 1
		 tab_1.tabpage_1.dw_detail.Setfocus()
		 tab_1.tabpage_1.dw_detail.Setcolumn('nro_doc')
		 tab_1.tabpage_1.dw_detail.Setrow(ll_inicio)
		 ib_update_check = False	
		 RETURN		
	 END IF
	 
	 
	 
	 tab_1.tabpage_1.dw_detail.object.origen        [ll_inicio]  = ls_cod_origen
	 tab_1.tabpage_1.dw_detail.object.nro_registro  [ll_inicio]  = ll_nro_registro		 
	 
NEXT





end event

event ue_update;call super::ue_update;Long     ll_row_det     ,ll_ano       ,ll_mes          ,ll_nro_libro ,&
         ll_nro_asiento ,ll_row_master,ll_nro_registro ,ll_inicio		
String   ls_origen   ,ls_flag_retencion ,ls_cod_relacion , ls_nro_cr,&
			ls_null 		,ls_flag_provisionado 
Boolean  lbo_ok = TRUE
Datetime ldt_fecha_doc
Decimal {3} ldc_tasa_cambio	
Decimal {2} ldc_imp_ret_sol,ldc_imp_ret_dol


dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	
	DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
		ids_crelacion_ext_tbl.deleterow(0)
	LOOP	
	
	ROLLBACK ;
	RETURN
END IF	


SetNull(ls_null)

/*datos de la cabecera*/
ll_row_master     = dw_master.getrow()
ll_nro_registro   = dw_master.object.nro_registro   [ll_row_master]
ls_origen 		   = dw_master.object.origen			 [ll_row_master]
ldt_fecha_doc	   = dw_master.object.fecha_emision  [ll_row_master]
ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [ll_row_master]

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ResetUpdate()
	dw_master.ii_update = 0
	
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_1.dw_detail.ResetUpdate()
	
	is_accion = 'fileopen'
	
	triggerEvent('ue_modify')
ELSE
	Rollback ;
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;Long   ll_inicio,ll_found,ll_count,ll_factor
String ls_moneda_cab   ,ls_flag_provisionado ,ls_cta_ctbl  ,ls_expresion  ,ls_null,ls_tipo_doc,&
		 ls_cod_relacion ,ls_nro_doc	         ,ls_doc_sgiro ,ls_flag_tabla ,ls_flag_ctrl_reg
Decimal {3} ldc_tasa_cambio
str_parametros sl_param

TriggerEvent ('ue_update_request')

select doc_sol_giro into :ls_doc_sgiro from finparam where reckey = '1' ;


sl_param.dw1     = 'd_abc_cajas_tbl'
sl_param.titulo  = 'Cartera de Pagos'
sl_param.tipo	  = '1S'
sl_param.string1 = gnvo_app.invo_empresa.is_empresa
sl_param.field_ret_i[1] = 1 //origen
sl_param.field_ret_i[2] = 2 //registro	
sl_param.field_ret_i[3] = 5 //ano
sl_param.field_ret_i[4] = 6 //mes
sl_param.field_ret_i[5] = 7 //nro libro
sl_param.field_ret_i[6] = 8 //nro asiento


OpenWithParm( w_lista, sl_param)
sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]),'2')
	tab_1.tabpage_1.dw_detail.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]))
	
	/*asociacion de moneda de cabecera*/
	IF dw_master.rowcount()  > 0 THEN
		SetNull(ls_null)
		ls_moneda_cab   = dw_master.object.cod_moneda  [dw_master.getrow()]
		ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
		
		For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
			 tab_1.tabpage_1.dw_detail.object.tasa_cambio    [ll_inicio] = ldc_tasa_cambio
		Next
	END IF
	
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	ib_estado_asiento = FALSE
END IF	
end event

event ue_delete;//override
Long  ll_row


IF idw_1 = dw_master OR idw_1 = tab_1.tabpage_2.dw_asiento_det THEN
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
IF (	dw_master.ii_update                      = 1 OR &
		tab_1.tabpage_1.dw_detail.ii_update      = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_modify;call super::ue_modify;String ls_flag_estado,ls_origen,ls_result,ls_mensaje
Long   ll_row,ll_nro_registro,ll_count,ll_ano,ll_mes

ll_row = dw_master.getrow()

IF ll_row = 0 THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado  [ll_row]
ls_origen		 = dw_master.object.origen       [ll_row]
ll_nro_registro = dw_master.object.nro_registro [ll_row]


IF ls_flag_estado <> '1' OR ll_count > 0 OR ls_result = '0' THEN
	dw_master.ii_protect = 0
	dw_master.of_protect()	
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	tab_1.tabpage_1.dw_detail.of_protect()	
	
ELSE
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	tab_1.tabpage_2.dw_asiento_det.of_protect()

END IF




end event

event ue_insert_pos;call super::ue_insert_pos;

IF idw_1 = dw_master THEN
	tab_1.tabpage_2.dw_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;ib_estado_asiento = TRUE
end event

event closequery;call super::closequery;DESTROY ids_asiento_adic
DESTROY ids_doc_pend_tbl
DESTROY ids_matriz_cntbl_det
DESTROY ids_glosa
DESTROY ids_crelacion_ext_tbl
DESTROY ids_rpt
end event

type p_pie from w_abc`p_pie within w_fi300_caja
end type

type ole_skin from w_abc`ole_skin within w_fi300_caja
integer x = 3698
integer y = 56
end type

type uo_h from w_abc`uo_h within w_fi300_caja
end type

type st_box from w_abc`st_box within w_fi300_caja
end type

type phl_logonps from w_abc`phl_logonps within w_fi300_caja
end type

type p_mundi from w_abc`p_mundi within w_fi300_caja
end type

type p_logo from w_abc`p_logo within w_fi300_caja
end type

type cb_2 from commandbutton within w_fi300_caja
boolean visible = false
integer x = 3205
integer y = 24
integer width = 347
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Retenciones"
end type

event clicked;String ls_cod_moneda,ls_flag_retencion,ls_cod_relacion
Long   ll_row_master,ll_inicio
Decimal {3} ldc_tasa_cambio


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

IF tab_1.tabpage_1.dw_detail.Rowcount() = 0 THEN
	Messagebox('Aviso','No Existen Registros para Verificar Retención')
	RETURN
END IF




SetNull(ls_flag_retencion)

ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]

/*limpieza de flag e importe de retencion*/
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.impt_ret_igv [ll_inicio] = 0.00 
	 tab_1.tabpage_1.dw_detail.object.flag_ret_igv [ll_inicio] = '0'  //desactivado
NEXT


wf_verificacion_retencion()
wf_verificacion_items_x_retencion()

/*cabecera*/
dw_master.Object.imp_total [ll_row_master] =	wf_recalcular_monto_det()
tab_1.tabpage_1.dw_detail.ii_update = 1
ib_estado_asiento = TRUE

end event

type tab_1 from tab within w_fi300_caja
integer x = 512
integer y = 796
integer width = 3214
integer height = 872
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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
		 	 		wf_generacion_cntas ()
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
string dataobject = "d_abc_caja_bancos_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_items();String ls_cod_moneda
Long   ll_row_master
Decimal {3} ldc_tasa_cambio

ll_row_master = dw_master.getrow()
ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]

f_verificacion_items_x_retencion (dw_master,tab_1.tabpage_1.dw_detail)

dw_master.object.imp_total [ll_row_master] = wf_recalcular_monto_det()
dw_master.ii_update= 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		 // 'm' = master sin detalle (default), 'd' =  detalle,
                      // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      


idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail 
end event

event ue_insert_pre;call super::ue_insert_pre;Long   ll_row,ll_item
String ls_moneda,ls_confin,ls_matriz
Decimal {3} ldc_tasa_cambio

dw_master.Accepttext()

//datos del banco
ls_moneda 		 = dw_master.object.cod_moneda  [dw_master.getrow()]
ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]

This.Object.nro_item		[al_row] = f_numera_item(this)
this.object.cod_moneda	[al_row] = ls_moneda
this.object.tasa_cambio	[al_row] = ldc_tasa_cambio
this.object.importe		[al_row] = 0
this.object.monto_sol	[al_row] = 0
this.object.monto_dol	[al_row] = 0
this.object.factor		[al_row] = -1



end event

event itemchanged;call super::itemchanged;Long   ll_count,ll_null,ll_nro_registro

String ls_desc, ls_null, ls_mensaje
		 
Decimal ldc_importe, ldc_monto_sol, ldc_monto_dol, ldc_tasa_cambio
dwItemStatus ldis_status


Accepttext()

setNull(ls_null)

/*Generacion de Asientos*/
ib_estado_asiento = TRUE

choose case dwo.name
		 case	'cod_relacion'
				select nom_proveedor 
					into :ls_desc
				  from proveedor p
				 where p.proveedor   = :data 
				   and p.flag_estado = '1';

						  
				if SQLCA.SQLCode = 100 then
					This.object.cod_relacion  [row] = ls_null
					This.object.nom_proveedor [row] = ls_null
					Messagebox('Aviso','Codigo de Relacion No Existe , Verifique!')
					Return 1
			   end if
				
				This.object.nom_proveedor [row] = ls_desc
				
		 case 'tipo_doc'
			
		 		select Count(*) into :ll_count
				  from doc_grupo dg, doc_grupo_relacion dgr, finparam fp 
				 where (dg.grupo     = dgr.grupo ) and
				       (dg.grupo     = fp.doc_grp_pag_directo) and
						 (dgr.tipo_doc = :data     ) ;
						 
				if ll_count = 0 then
					This.object.tipo_doc [row] = ls_null
					Messagebox('Aviso','Documento No Existe en Grupo de Documento x Pagar , Verifique!')
					Return 1
				end if
				
	  	 case 'importe'
				
				//verifica monto de documento
				ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio	[dw_master.getrow()])
				
				if ldc_tasa_cambio = 0 or IsNull(ldc_tasa_cambio) then
					this.object.importe [row] = 0.00
					dw_master.setFocus( )
					dw_master.setColumn('tasa_cambio')
					
					ls_mensaje = "No ha ingresado tipo de cambio, por favor verifique"
					gnvo_log.of_errorlog( ls_mensaje )
					gnvo_app.of_showmessagedialog( ls_mensaje)

					return 1
				end if
				
				ldc_importe = Dec(this.object.importe [row])
				
				if this.object.cod_moneda[row] = is_soles then
					this.object.monto_sol	[row] = ldc_importe
					this.object.monto_dol	[row] = round(ldc_importe / ldc_tasa_cambio,2)
				else
					this.object.monto_dol	[row] = ldc_importe
					this.object.monto_sol	[row] = round(ldc_importe * ldc_tasa_cambio,2)
				end if
				
				
				dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
				dw_master.ii_update = 1
				
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

event dragdrop;call super::dragdrop;DataWindow ldw_Source
Long       ll_row ,ll_row_ope
String     ls_nro_ov,ls_flag_referencia ,ls_cencos ,ls_nro_emb
Boolean    lb_result

IF source.TypeOf() = DataWindow! THEN
   ldw_Source = source
	
	ll_row     = ldw_Source.GetRow()
	ls_nro_ov  = ldw_source.object.nro_ov       [ll_row]
	ls_cencos  = ldw_source.object.cencos_gasto [ll_row]
	ls_nro_emb = ldw_source.object.nro_embarque [ll_row]
	
	ll_row_ope = this.GetRow()

	lb_result = this.IsSelected(ll_row_ope)
	
	if lb_result then
		ls_flag_referencia = this.object.flag_referencia [ll_row_ope]
	
		if ls_flag_referencia = '1' then
			THIS.object.referencia   [ll_row_ope] = ls_nro_ov
			THIS.object.cencos		 [ll_row_ope] = ls_cencos
			THIS.object.nro_embarque [ll_row_ope] = ls_nro_emb
			THIS.object.cnta_prsp    [ll_row_ope] = is_cnta_prsp
			THIS.ii_update = 1
		else
			Messagebox('Aviso','Debe Seleccionar Boton de Referencia')
		end if
	else
		Messagebox('Aviso','Debe Seleccionar Algun Registro')
	end if
	
END IF	


ldw_Source.Drag(End!)
end event

event ue_display;call super::ue_display;
String ls_sql, ls_codigo, ls_data

str_parametros sl_param

CHOOSE CASE lower(as_columna)
	CASE 'tipo_doc'
		
		ls_sql = "select tipo_doc as tipo_doc, " &
				 + "desc_tipo_doc as descripcion_tipo_doc " &
				 + "from doc_tipo " &
				 + "where flag_estado = '1'"
					 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if isnull(ls_codigo) or trim(ls_codigo) = '' then return
		
		this.object.tipo_doc	[al_row] = ls_codigo
		this.ii_update = 1		// activa flag de modificado
														
	CASE 'cod_relacion'
		
		ls_sql = "select proveedor as codigo_proveedor, "&
				 + "nom_proveedor as nombre_proveedor, " &
				 + "RUC as RUC " &
				 + "from proveedor " &
				 + "where flag_estado = '1'"
					 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if isnull(ls_codigo) or trim(ls_codigo) = '' then return
		
		this.object.cod_relacion	[al_row] = ls_codigo
		this.object.nom_proveedor	[al_row] = ls_data
		this.ii_update = 1		// activa flag de modificado
			  
END CHOOSE





end event

type tabpage_2 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 112
integer width = 3177
integer height = 744
boolean enabled = false
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
integer height = 464
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_bak"
boolean hscrollbar = true
boolean vscrollbar = true
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


idw_mst  = tab_1.tabpage_2.dw_asiento_cab // dw_master
idw_det  = tab_1.tabpage_2.dw_asiento_det // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;/*Generacion de Asientos*/
ib_estado_asiento = FALSE

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;/*Generacion de Asientos*/
ib_estado_asiento = FALSE

end event

type dw_asiento_cab from u_dw_abc within tabpage_2
boolean visible = false
integer y = 480
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


idw_mst  = tab_1.tabpage_2.dw_asiento_cab // dw_master
idw_det  = tab_1.tabpage_2.dw_asiento_det // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.flag_tabla [al_row] = '5'
end event

type cb_1 from commandbutton within w_fi300_caja
integer x = 2784
integer y = 24
integer width = 347
integer height = 100
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
String  ls_cod_moneda,ls_cod_relacion,ls_result,ls_mensaje,ls_confin
Decimal {3} ldc_tasa_cambio
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
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN 
	Messagebox('Aviso',ls_mensaje)
	RETURN
END IF	

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


sl_param.dw1		= 'd_doc_pendientes_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.string2	= ls_cod_moneda
sl_param.string3	= ls_confin
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1CP'
sl_param.opcion   = 15  //cartera de pagos
sl_param.db1 		= 1350
sl_param.dw_m		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_master.Object.imp_total [1] = wf_recalcular_monto_det ()
	dw_master.ii_update = 1
	tab_1.tabpage_1.dw_detail.ii_update = 1
	/*Generacion de Asientos*/
	ib_estado_asiento = TRUE
END IF

end event

type dw_master from u_dw_abc within w_fi300_caja
integer x = 507
integer y = 244
integer width = 2743
integer height = 544
string dataobject = "d_abc_caja_bancos_cab_ff"
boolean livescroll = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)




ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
Long       ll_row_gch,ll_count
String     ls_cod_moneda,ls_nom_proveedor,ls_matriz,ls_descripcion,&
			  ls_cta_cntbl ,ls_banco       ,ls_codigo, ls_desc, ls_null, &
			  ls_mensaje, ls_estado
Decimal{3} ldc_tasa_cambio
Decimal{2} ldc_saldo
Date		  ld_fecha_emision


/*Generacion de Asientos*/
ib_estado_asiento = true
this.Accepttext( )
SetNull(ls_null)

CHOOSE CASE dwo.name
					
		 CASE 'cod_banco'
				select nom_banco
				  into :ls_desc
              from banco
				 where cod_banco   = :data 
				   and cod_origen  = :gnvo_app.is_origen
					and cod_empresa = :gnvo_app.invo_empresa.is_empresa;
				
				if SQLCA.SQLCode = 100 then
					ls_mensaje = "Código de Banco ingresado " + data &
						+ " no existe, no esta activo o no le corresponde a su empresa, "&
						+ "por favor verifique"
					gnvo_log.of_errorlog( ls_mensaje )
					gnvo_app.of_showmessagedialog( ls_mensaje)

					this.object.cod_banco         [row] = ls_null
				   this.object.nom_banco 			[row] = ls_null
			
			
					Messagebox('Aviso','Cuenta de Banco No Existe Verifique!')
					Return 1
				end if
				
				this.object.nom_banco  [row] = ls_desc

				/*actualizo moneda de transacion*/
				this.object.cod_moneda  [row]	= is_soles
				
				
	 CASE 'tasa_cambio', 'cod_moneda'
			ls_cod_moneda   = This.object.cod_moneda  [row]	
			ldc_tasa_cambio = This.object.tasa_cambio [row]
			
			// Actualiza Tipo de Moneda y Tasa Cambio
			wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
			This.Object.imp_total [row] =	wf_recalcular_monto_det()				
				
	CASE	'fecha_emision'
		ls_banco = this.object.cod_banco	[row]
		ld_fecha_emision = date(this.object.fecha_emision[row])
			
		//Verifico que este aperturada la caja y que exista
		select flag_estado
			into :ls_estado
		from cierre_caja
		where cod_banco = :ls_banco
		  and fecha		 = :ld_fecha_emision;
		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Caja no ha sido aperturada, por favor coordine con administracion "
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			SetNull(ld_fecha_emision)
			this.object.fecha_emision[row] = ld_fecha_emision
			this.SetColumn('fecha_emision')
			return 1
		end if
		
		if ls_estado = '0' then
			ls_mensaje = "Caja esta anulada para la fecha " + string(ld_fecha_emision, 'dd/mm/yyyy') + ", por favor coordine con administracion "
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			SetNull(ld_fecha_emision)
			this.object.fecha_emision[row] = ld_fecha_emision
			this.SetColumn('fecha_emision')
			return 1
		end if
		
		if ls_estado = '2' then
			ls_mensaje = "Caja esta cerrada para la fecha " + string(ld_fecha_emision, 'dd/mm/yyyy') + ", por favor coordine con administracion "
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			SetNull(ld_fecha_emision)
			this.object.fecha_emision[row] = ld_fecha_emision
			this.SetColumn('fecha_emision')
			return 1
		end if
	
		//busca tipo de cambio
		This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
			
		ls_cod_moneda   = This.object.cod_moneda  [row]	
		ldc_tasa_cambio = This.object.tasa_cambio [row]
			
		// Actualiza Tipo de Moneda y Tasa Cambio
		wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
		This.Object.imp_total [row] =	wf_recalcular_monto_det()								

							
END CHOOSE				
				






end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_nro_libro 
date ld_fecha

ld_fecha = date(f_fecha_actual (1))

This.Object.origen 		      [al_row] = gnvo_app.is_origen
This.Object.cod_usr 		      [al_row] = gnvo_app.is_user
This.Object.nro_libro	      [al_row] = ll_nro_libro
This.Object.fecha_emision     [al_row] = ld_fecha
This.Object.tasa_cambio       [al_row] = of_tasa_cambio(ld_fecha)
This.Object.ano			      [al_row] = Long(String(f_fecha_actual(1),'YYYY'))
This.Object.mes			      [al_row] = Long(String(f_fecha_actual(1),'MM'))
This.Object.flag_estado       [al_row] = '1'
This.Object.flag_tiptran      [al_row] = '2' //cartera de pagos
This.Object.flag_conciliacion [al_row] = '1' //falta conciliar
//

end event

event ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql
date 		ld_fecha


choose case lower(as_columna)
		
	case "cod_banco"

		ls_sql = "select cod_banco as codigo_banco, "&
				 + "nom_banco as nombre_banco " &
				 + "from banco " &
				 + "where cod_origen = '" + gnvo_app.is_origen + "' " &
				 + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			//Ubico la ultima fecha de caa activa
			select max(fecha)
				into :ld_fecha
			from cierre_caja
			where cod_banco = :ls_codigo
			  and flag_estado = '1';
			  
			if SQLCA.SQLCode = 100 then
				MessageBox('Error', 'no existe apertura de caja, por favor verifique')
				return
			end if
			
			this.object.cod_banco		[al_row] = ls_codigo
			this.object.nom_banco		[al_row] = ls_data
			this.object.fecha_emision	[al_row] = ld_fecha
			this.object.tasa_cambio		[al_row] = of_tasa_cambio(ld_fecha)
			 
			
			this.ii_update = 1
			
		end if
	

		
end choose


//CHOOSE CASE dwo.name
//		 CASE 'cod_ctabco'
//			   lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA_BANCO ,'&
//												       +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION ,'&
//												       +'BANCO_CNTA.CNTA_CTBL AS CUENTA_CONTABLE,'&      
//											 	       +'BANCO_CNTA.COD_MONEDA AS MONEDA,'&
//												       +'BANCO_CNTA.COD_ORIGEN  CODIGO_ORIGEN, '&
//														 +'BANCO_CNTA.SALDO_DISPONIBLE  AS SALDO '&
//												       +'FROM BANCO_CNTA '
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_ctabco',lstr_seleccionar.param1[1])
//					Setitem(row,'banco_cnta_descripcion',lstr_seleccionar.param2[1])
//					Setitem(row,'cnta_ctbl',lstr_seleccionar.param3[1])
//					Setitem(row,'banco_cnta_cod_moneda',lstr_seleccionar.param4[1])
//					Setitem(row,'cod_moneda',lstr_seleccionar.param4[1])
//					Setitem(row,'banco_cnta_saldo_disponible',lstr_seleccionar.paramdc6[1])					
//					
//				   ldc_tasa_cambio = This.object.tasa_cambio [row]
//					ls_cod_moneda	 = lstr_seleccionar.param4 [1]
//					
//				   // Actualiza Tipo de Moneda y Tasa Cambio
//				   wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
//					
//					// Recalcula Detalle					
//				   This.Object.imp_total [row] =	wf_recalcular_monto_det()
//					
//					ii_update = 1
//					
//					/*Generacion de Asientos*/
//					ib_estado_asiento = true					
//					
//				END IF	
//				
//		 CASE 'cod_relacion'
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
//								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES '&
//								   					 +'FROM PROVEEDOR ' &
//														 +'WHERE PROVEEDOR.FLAG_ESTADO ='+"'"+'1'+"'"
//
//
//														 
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
//					Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
//					ii_update = 1
//					
//					/*Generacion de Asientos*/
//					ib_estado_asiento = true					
//					
//				END IF		
//				
//		 CASE 'confin'
//
//				sl_param.tipo			= ''
//				sl_param.opcion		= 2
//				sl_param.titulo 		= 'Selección de Concepto Financiero'
//				sl_param.dw_master	= 'd_lista_grupo_financiero_grd'
//				sl_param.dw1			= 'd_lista_concepto_financiero_grd'
//				sl_param.dw_m			=  This
//				
//				OpenWithParm( w_abc_seleccion_md, sl_param)
//				IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
//				IF sl_param.titulo = 's' THEN
//					This.ii_update = 1
//					/*Generacion de Asientos*/
//					ib_estado_asiento = true					
//					
//				END IF
//				
//		CASE 'tipo_doc'
//			  lstr_seleccionar.s_seleccion = 'S'
//           lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO_DOC,'&
//			  											+'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
//			   										+'FROM DOC_TIPO '  
//														
//			  OpenWithParm(w_seleccionar,lstr_seleccionar)
//			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//			  IF lstr_seleccionar.s_action = "aceptar" THEN
//				  Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
//				  Setitem(row,'desc_tipo_doc',lstr_seleccionar.param2[1])
//				  ii_update = 1
//				  /*Generacion de Asientos*/
//				  ib_estado_asiento = true					
//				  
//			  END IF	
//														
//		
//END CHOOSE
//
//
//
end event

type cb_3 from commandbutton within w_fi300_caja
integer x = 3351
integer y = 268
integer width = 617
integer height = 132
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cntas x Cobrar"
end type

event clicked;Long    ll_row_master,ll_ano,ll_mes
String  ls_cod_moneda,ls_cod_relacion,ls_result,ls_mensaje,ls_confin
Decimal {3} ldc_tasa_cambio
str_parametros sl_param

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return

ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master]

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

//Proceso a actualizar los saldos de los documentos que no esten confirmes
update cntas_cobrar cc
   set cc.saldo_sol = cc.importe_doc - (select NVL(sum(cbd.monto_sol),0)
                                          from caja_bancos_det cbd,
                                               caja_bancos     cb,
                                               banco           b
                                        where cbd.origen = cb.origen
                                          and cbd.nro_registro = cb.nro_registro
                                          and cb.cod_banco     = b.cod_banco
                                          and b.cod_empresa    = cc.cod_empresa
                                          and cbd.tipo_doc      = cc.tipo_doc
                                          and cbd.nro_doc       = cc.nro_doc
                                          and cbd.cod_relacion  = cc.cod_relacion),
        cc.saldo_dol = DECODE(cc.tasa_cambio, 0, 0, (cc.importe_doc - (select NVL(sum(cbd.monto_sol),0)
                                          from caja_bancos_det cbd,
                                               caja_bancos     cb,
                                               banco           b
                                        where cbd.origen = cb.origen
                                          and cbd.nro_registro = cb.nro_registro
                                          and cb.cod_banco     = b.cod_banco
                                          and b.cod_empresa    = cc.cod_empresa
                                          and cbd.tipo_doc      = cc.tipo_doc
                                          and cbd.nro_doc       = cc.nro_doc
                                          and cbd.cod_relacion  = cc.cod_relacion)) / tasa_cambio)
where cc.flag_estado <> '0'
  and cc.saldo_sol <> 
      cc.importe_doc - (select NVL(sum(cbd.monto_sol),0)
        from caja_bancos_det cbd,
             caja_bancos     cb,
             banco           b
      where cbd.origen = cb.origen
        and cbd.nro_registro = cb.nro_registro
        and cb.cod_banco     = b.cod_banco
        and b.cod_empresa    = cc.cod_empresa
        and cbd.tipo_doc      = cc.tipo_doc
        and cbd.nro_doc       = cc.nro_doc
        and cbd.cod_relacion  = cc.cod_relacion);

IF SQLCA.SQLCode = -1 then
	ls_mensaje = "Error al actualizar el saldo x Cobrar de todos los documentos " &
				  + SQLCA.SQLErrText + ", por favor verifique"
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
else
	COMMIT;
end if


sl_param.string3 = ls_cod_relacion

OpenWithParm(w_pop_help_edirecto,sl_param)

//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	sl_param = message.PowerObjectParm
END IF

if not sl_param.bret then return

sl_param.string1 	= sl_param.string3
sl_param.dw1		= 'd_doc_pendientes_cxc_tbl'
sl_param.titulo	= 'Documentos Pendientes x Cliente '
sl_param.string2	= ls_cod_moneda
sl_param.string1	= gnvo_app.invo_empresa.is_empresa
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1S3S'
sl_param.opcion   = 27  //Caja Bancos
sl_param.dw_d		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_master.Object.imp_total [1] = wf_recalcular_monto_det ()
	dw_master.ii_update = 1
	tab_1.tabpage_1.dw_detail.ii_update = 1
END IF

end event

