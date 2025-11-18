$PBExportHeader$w_fi309_cartera_de_cobros.srw
forward
global type w_fi309_cartera_de_cobros from w_abc
end type
type sle_1 from singlelineedit within w_fi309_cartera_de_cobros
end type
type cbx_ts from checkbox within w_fi309_cartera_de_cobros
end type
type rb_1 from radiobutton within w_fi309_cartera_de_cobros
end type
type cb_3 from commandbutton within w_fi309_cartera_de_cobros
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
type dw_master from u_dw_abc within w_fi309_cartera_de_cobros
end type
type gb_1 from groupbox within w_fi309_cartera_de_cobros
end type
type gb_2 from groupbox within w_fi309_cartera_de_cobros
end type
type cb_1 from commandbutton within w_fi309_cartera_de_cobros
end type
end forward

global type w_fi309_cartera_de_cobros from w_abc
integer width = 4411
integer height = 1828
string title = "Cartera de Cobros (FI309)"
string menuname = "m_mantenimiento_cl_tes_anular"
event ue_anular ( )
event ue_print_preview ( )
sle_1 sle_1
cbx_ts cbx_ts
rb_1 rb_1
cb_3 cb_3
cb_2 cb_2
cbx_ref cbx_ref
tab_1 tab_1
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
cb_1 cb_1
end type
global w_fi309_cartera_de_cobros w_fi309_cartera_de_cobros

type variables
String is_accion
uf_asiento_contable if_asiento_contable
Boolean ib_estado_asiento = TRUE
DatawindowChild idw_doc_tipo
u_ds_base 	ids_asiento_adic,ids_doc_pend_tbl,ids_matriz_cntbl_Det, &
			 	ids_glosa, ids_crelacion_ext_tbl, ids_rpt
end variables

forward prototypes
public subroutine wf_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio)
public subroutine wf_verificacion_items_x_retencion ()
public subroutine wf_verificacion_retencion ()
public function boolean wf_genera_cretencion (long al_nro_serie, ref string as_mensaje, ref string as_nro_doc)
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado)
public function boolean wf_generacion_cntas ()
public function decimal wf_recalcular_monto_det ()
public function boolean wf_update_deuda_financiera ()
end prototypes

event ue_anular;Integer li_opcion
String  ls_flag_estado ,ls_origen_cb  ,ls_result     ,ls_mensaje ,ls_nro_planilla
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



IF (dw_master.ii_update = 1                      OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
    tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1) THEN
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
lstr_cns_pop.arg[3] = 'd_rpt_formato_chq_voucher_tbl_solo'



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

public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado);DECLARE PB_USP_FIN_INS_DOC_A_PAGAR PROCEDURE FOR USP_FIN_INS_DOC_A_PAGAR 
(:as_cod_relacion,:as_origen,:al_nro_registro,:as_tip_doc,:as_nro_doc,:adc_importe,:as_accion);
EXECUTE PB_USP_FIN_INS_DOC_A_PAGAR ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_INS_DOC_A_PAGAR INTO :as_flag_estado ;
CLOSE PB_USP_FIN_INS_DOC_A_PAGAR ;
end subroutine

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

public function decimal wf_recalcular_monto_det ();String ls_soles,ls_dolares,ls_moneda_ref,ls_moneda_cab
Long   ll_inicio,ll_factor
Decimal {2} ldc_importe_total,ldc_importe_ref,ldc_importe_ret
Decimal {3} ldc_tasa_cambio


f_monedas(ls_soles,ls_dolares)


dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()


ldc_importe_total = 0.00
ldc_importe_ref   = 0.00
ldc_importe_ret	= 0.00

For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
	
	 ldc_importe_ref = tab_1.tabpage_1.dw_detail.object.importe        [ll_inicio]
	 ldc_importe_ret = tab_1.tabpage_1.dw_detail.object.impt_ret_igv   [ll_inicio]	 	 
	 ls_moneda_ref	  = tab_1.tabpage_1.dw_detail.object.cod_moneda     [ll_inicio]
 	 ll_factor       = tab_1.tabpage_1.dw_detail.object.factor	       [ll_inicio]
	 ls_moneda_cab   = tab_1.tabpage_1.dw_detail.object.cod_moneda_cab [ll_inicio]
	 ldc_tasa_cambio = tab_1.tabpage_1.dw_detail.object.tasa_cambio    [ll_inicio]
	 
	 
	 
	 IF Isnull(ldc_importe_ref) THEN ldc_importe_ref = 0.00
	 IF Isnull(ldc_importe_ret) THEN ldc_importe_ret = 0.00
	 

	 
	 IF ls_moneda_cab =  ls_moneda_ref THEN
		 ldc_importe_ref = ldc_importe_ref * ll_factor
	 ELSEIF ls_moneda_ref = ls_soles THEN
		 ldc_importe_ref = Round(ldc_importe_ref / ldc_tasa_cambio,2) * ll_factor
	 ELSEIF ls_moneda_ref = ls_dolares THEN
		 ldc_importe_ref = Round(ldc_importe_ref * ldc_tasa_cambio,2) * ll_factor
	 END IF	
	 
	 //acumulador
	 ldc_importe_total = ldc_importe_total + ldc_importe_ref
	 
	 /*IMPORTE DE RETENCION*/
	 IF ls_moneda_cab <> ls_soles THEN
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
Decimal {2} ldc_monto_proy,ldc_monto_real
Boolean lb_ret = TRUE   


		 

For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.rowcount()
	 ls_origen  	 = tab_1.tabpage_1.dw_detail.object.origen       [ll_inicio]
	 ll_nro_reg 	 = tab_1.tabpage_1.dw_detail.object.nro_registro [ll_inicio]
	 ll_item			 = tab_1.tabpage_1.dw_detail.object.item		    [ll_inicio]
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

on w_fi309_cartera_de_cobros.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_tes_anular" then this.MenuID = create m_mantenimiento_cl_tes_anular
this.sle_1=create sle_1
this.cbx_ts=create cbx_ts
this.rb_1=create rb_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cbx_ref=create cbx_ref
this.tab_1=create tab_1
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.cbx_ts
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cbx_ref
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.cb_1
end on

on w_fi309_cartera_de_cobros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_1)
destroy(this.cbx_ts)
destroy(this.rb_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cbx_ref)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.cb_1)
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
idw_doc_tipo.SetFilter('cod_usr = '+"'"+gnvo_app.is_user+"'")
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

ids_rpt = Create u_ds_base


end event

event ue_insert;call super::ue_insert;Long   ll_row
String ls_cod_moneda
Decimal {3} ldc_tasa_cambio

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

IF idw_1 = tab_1.tabpage_2.dw_asiento_det THEN RETURN

IF idw_1 = tab_1.tabpage_1.dw_detail THEN
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
	is_accion = 'new'
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_asiento_cab.Reset()
	tab_1.tabpage_2.dw_asiento_det.Reset()
	
	/*Elimina Informacion de Tabla Temporal*/
	delete from tt_fin_deuda_financiera ;
	
	/*ACTIVO VERIFICACION DE RETENCIONES*/
	cb_2.Enabled = TRUE
END IF	

ll_row = idw_1.Event ue_insert()
	
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
end event

event resize;call super::resize;
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_detail.width       = newwidth  - tab_1.tabpage_1.dw_detail.x - 50
tab_1.tabpage_1.dw_detail.height      = newheight - tab_1.tabpage_1.dw_detail.y - 900
tab_1.tabpage_2.dw_asiento_det.width  = newwidth  - tab_1.tabpage_2.dw_asiento_det.x - 50
tab_1.tabpage_2.dw_asiento_det.height = newheight - tab_1.tabpage_2.dw_asiento_det.y - 900


end event

event ue_update_pre;call super::ue_update_pre;Long   ll_ano,ll_mes,ll_nro_registro,ll_inicio,ll_found,ll_ins_new,ll_nro_serie,ll_item,ll_nro_libro,&
		 ll_nro_asiento
String ls_result    ,ls_mensaje      ,ls_cod_origen ,ls_flag_retencion ,ls_tip_ser  ,ls_flag_estado,&
		 ls_expresion ,ls_cod_relacion ,ls_nro_ret    ,ls_tipo_doc       ,ls_nro_doc	,ls_cod_moneda ,&
		 ls_cod_usr
Decimal {2} ldc_importe_total,ldc_totsoldeb,ldc_totdoldeb,ldc_totsolhab,ldc_totdolhab
Decimal {3} ldc_tasa_cambio
Datetime    ldt_fecha_cntbl

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
ll_ano            = dw_master.object.ano            [dw_master.getrow()]
ll_mes            = dw_master.object.mes            [dw_master.getrow()]
ll_nro_libro		= dw_master.object.nro_libro      [dw_master.getrow()]
ll_nro_asiento		= dw_master.object.nro_asiento	 [dw_master.getrow()]
ls_cod_origen     = dw_master.object.origen		  	 [dw_master.getrow()]				 
ll_nro_registro   = dw_master.object.nro_registro	 [dw_master.getrow()]				 
ls_flag_retencion = dw_master.object.flag_retencion [dw_master.getrow()]
ls_tip_ser			= dw_master.object.tipser			 [dw_master.getrow()]
ls_flag_estado		= dw_master.object.flag_estado    [dw_master.getrow()]
ldc_importe_total	= dw_master.object.imp_total	    [dw_master.getrow()]
ldt_fecha_cntbl	= dw_master.object.fecha_emision  [dw_master.getrow()]
ls_cod_moneda		= dw_master.object.cod_moneda    [dw_master.getrow()]
ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [dw_master.getrow()]
ls_cod_usr			= dw_master.object.cod_usr 	 	 [dw_master.getrow()]
ls_flag_estado	   = dw_master.object.flag_estado   [dw_master.getrow()]



/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	ib_update_check = False	
	Return	
END IF

/*verificar tipo de serie en retenciones*/
IF ls_flag_retencion = '1' THEN //GENERAR COMPROBANTE DE RETENCION
	IF Isnull(ls_tip_ser) OR Trim(ls_tip_ser) = '' THEN
		Messagebox('Aviso','Ingrese Serie de Comprobante de Retencion')
		ib_update_check = False	
		Return
	END IF
END IF	


/*importe del documento > 0*/
IF ls_flag_estado <> '0' THEN
	IF Isnull(ldc_importe_total) OR ldc_importe_total <= 0 THEN
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
	
   //verificacion de año y mes	
	IF Isnull(ll_ano) OR ll_ano = 0 THEN
		ib_update_check = False	
		Messagebox('Aviso','Ingrese Año Contable , Verifique!')
		Return
	END IF
	
	IF Isnull(ll_mes) OR ll_mes = 0 THEN
		ib_update_check = False	
		Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
		Return
	END IF
	
	/*generacion de asientos*/	
	IF f_asiento(ls_cod_origen,ll_nro_libro,ll_ano,ll_mes,ll_nro_asiento)  = FALSE THEN
		ib_update_check = False	
		Return
	ELSE
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
	END IF	
	
	//cabecera de asiento
	tab_1.tabpage_2.dw_asiento_cab.Object.origen      [1] = ls_cod_origen
	tab_1.tabpage_2.dw_asiento_cab.Object.ano 		  [1] = ll_ano
	tab_1.tabpage_2.dw_asiento_cab.Object.mes 		  [1] = ll_mes
	tab_1.tabpage_2.dw_asiento_cab.Object.nro_libro   [1] = ll_nro_libro
	tab_1.tabpage_2.dw_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento	
END IF



/*eliminar informacion de tabla temporal*/
DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
	ids_crelacion_ext_tbl.deleterow(0)
LOOP

IF ls_flag_retencion = '1' THEN /*flag de retencion de cabecera*/

	/*filtrar documentos marcados para la retencion*/
	ls_expresion = "flag_ret_igv = '1'"
	tab_1.tabpage_1.dw_detail.SetFilter(ls_expresion)
	tab_1.tabpage_1.dw_detail.Filter()

	//**separar los codigos de relacion**//
	FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
		 ls_cod_relacion = tab_1.tabpage_1.dw_detail.object.cod_relacion [ll_inicio]
		 ls_expresion = "cod_relacion = '"+ls_cod_relacion+"'"
		 ll_found = ids_crelacion_ext_tbl.find(ls_expresion,1,tab_1.tabpage_1.dw_detail.Rowcount())
		 IF ll_found = 0 THEN
			 ll_ins_new = ids_crelacion_ext_tbl.InsertRow(0)
			 ids_crelacion_ext_tbl.object.cod_relacion[ll_ins_new] = ls_cod_relacion
		 END IF
		 /**/
	NEXT

	/*desfiltrado*/ 
	tab_1.tabpage_1.dw_detail.SetFilter('')
	tab_1.tabpage_1.dw_detail.Filter()
	/*ordenamiento*/
	tab_1.tabpage_1.dw_detail.SetSort('item a')
	tab_1.tabpage_1.dw_detail.Sort()


	/***generar numero para comprobantes de retencion***/
	FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount() 
		 //Asignación  de Nro de Serie
		 ll_nro_serie  = idw_doc_tipo.Getitemnumber(idw_doc_tipo.getrow(),'nro_serie')
		 IF wf_genera_cretencion(ll_nro_serie,ls_mensaje,ls_nro_ret) = FALSE THEN
			 Messagebox('Aviso',ls_mensaje)
			 ib_update_check = False	
			 RETURN
		 END IF		 

		 /*ASIGNACION DE NUMERO DE C. RETENCION X C.RELACION*/
		 ids_crelacion_ext_tbl.object.nro_cr [ll_inicio] = ls_nro_ret
		 
	NEXT
	
END IF	


//generacion de asientos automaticos
IF ib_estado_asiento THEN
	IF wf_generacion_cntas () = FALSE THEN
		ib_update_check = False	
		RETURN
	ELSE
		ib_update_check = True
	END IF
END IF	



		
//Detalle de Documento
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 /*validar que datos esten completos*/
	 ls_cod_relacion = tab_1.tabpage_1.dw_detail.object.cod_relacion [ll_inicio]
	 ls_tipo_doc	  = tab_1.tabpage_1.dw_detail.object.tipo_doc	  [ll_inicio]	
	 ls_nro_doc		  = tab_1.tabpage_1.dw_detail.object.nro_doc		  [ll_inicio]	
	 ll_item			  = tab_1.tabpage_1.dw_detail.object.item			  [ll_inicio]	
	 
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


//Detalle de pre asiento
FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount()
	 tab_1.tabpage_2.dw_asiento_det.object.origen   	[ll_inicio] = ls_cod_origen
	 tab_1.tabpage_2.dw_asiento_det.object.ano   	 	[ll_inicio] = ll_ano
	 tab_1.tabpage_2.dw_asiento_det.object.mes	   	[ll_inicio] = ll_mes
	 tab_1.tabpage_2.dw_asiento_det.object.nro_libro	[ll_inicio] = ll_nro_libro
	 tab_1.tabpage_2.dw_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
	 tab_1.tabpage_2.dw_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_cntbl
NEXT



ldc_totsoldeb  = tab_1.tabpage_2.dw_asiento_det.object.monto_soles_cargo   [1]
ldc_totdoldeb  = tab_1.tabpage_2.dw_asiento_det.object.monto_dolares_cargo [1]
ldc_totsolhab  = tab_1.tabpage_2.dw_asiento_det.object.monto_soles_abono	[1]
ldc_totdolhab  = tab_1.tabpage_2.dw_asiento_det.object.monto_dolares_abono [1]



tab_1.tabpage_2.dw_asiento_cab.Object.cod_moneda	[1] = ls_cod_moneda
tab_1.tabpage_2.dw_asiento_cab.Object.tasa_cambio	[1] = ldc_tasa_cambio
tab_1.tabpage_2.dw_asiento_cab.Object.fec_registro [1] = ldt_fecha_cntbl
tab_1.tabpage_2.dw_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_cntbl
tab_1.tabpage_2.dw_asiento_cab.Object.cod_usr	   [1] = ls_cod_usr
tab_1.tabpage_2.dw_asiento_cab.Object.flag_estado  [1] = ls_flag_estado
tab_1.tabpage_2.dw_asiento_cab.Object.tot_solhab	[1] = ldc_totsolhab
tab_1.tabpage_2.dw_asiento_cab.Object.tot_dolhab	[1] = ldc_totdolhab
tab_1.tabpage_2.dw_asiento_cab.Object.tot_soldeb	[1] = ldc_totsoldeb
tab_1.tabpage_2.dw_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb

IF dw_master.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 THEN 
	tab_1.tabpage_2.dw_asiento_det.ii_update = 1
	tab_1.tabpage_2.dw_asiento_cab.ii_update = 1
END IF


// valida asientos descuadrados
lb_retorno  = f_validar_asiento(tab_1.tabpage_2.dw_asiento_det)

IF lb_retorno = FALSE THEN
	ib_update_check = False	
	Return
END IF


/*Replicacion*/
dw_master.of_set_flag_replicacion ()
tab_1.tabpage_1.dw_detail.of_set_flag_replicacion ()
tab_1.tabpage_2.dw_asiento_cab.of_set_flag_replicacion ()
tab_1.tabpage_2.dw_asiento_det.of_set_flag_replicacion ()




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
tab_1.tabpage_2.dw_asiento_cab.AcceptText()
tab_1.tabpage_2.dw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

SetNull(ls_null)

/*datos de la cabecera*/
ll_row_master     = dw_master.getrow()
ll_nro_registro   = dw_master.object.nro_registro   [ll_row_master]
ls_origen 		   = dw_master.object.origen			 [ll_row_master]
ls_flag_retencion = dw_master.object.flag_retencion [ll_row_master]
ldt_fecha_doc	   = dw_master.object.fecha_emision  [ll_row_master]
ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [ll_row_master]

//ejecuta procedimiento de actualizacion de tabla temporal
IF tab_1.tabpage_2.dw_asiento_det.ii_update = 1 and is_accion <> 'new' THEN
	ll_row_det     = tab_1.tabpage_2.dw_asiento_det.Getrow()
	ll_ano         = tab_1.tabpage_2.dw_asiento_det.Object.ano         [ll_row_det]
	ll_mes         = tab_1.tabpage_2.dw_asiento_det.Object.mes         [ll_row_det]
	ll_nro_libro   = tab_1.tabpage_2.dw_asiento_det.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = tab_1.tabpage_2.dw_asiento_det.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
END IF


IF tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF tab_1.tabpage_2.dw_asiento_cab.Update () = -1 THEN // Cabecera de Asiento
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Cabecera de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF tab_1.tabpage_2.dw_asiento_det.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF tab_1.tabpage_2.dw_asiento_det.Update () = -1 THEN 
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF



IF ls_flag_retencion = '1' THEN /*cabecera*/
	FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount()
		ls_cod_relacion = ids_crelacion_ext_tbl.object.cod_relacion [ll_inicio]
		ls_nro_cr	    = ids_crelacion_ext_tbl.object.nro_cr       [ll_inicio]
	 
	   /*encontrar monto de cri x proveedor*/
		f_monto_cri_x_prov(tab_1.tabpage_1.dw_detail,ls_cod_relacion,ldc_tasa_cambio,ldc_imp_ret_sol,ldc_imp_ret_dol)
		
		
		
	   
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
if is_accion <> 'delete' then
	if wf_update_deuda_financiera() = false then
		lbo_ok = FALSE
		GOTO SALIDA
	end if
end if



SALIDA:

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_asiento_cab.ii_update = 0
	tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	is_accion = 'fileopen'
	

	/* actualiza valores flag detalle */
	for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
		 tab_1.tabpage_1.dw_detail.object.flag_doc     	    [ll_inicio] = ls_null
		 
		 ls_flag_provisionado = tab_1.tabpage_1.dw_detail.object.flag_provisionado [ll_inicio]
		 
		 IF ls_flag_provisionado = 'N' THEN
			 tab_1.tabpage_1.dw_detail.object.flag_partida [ll_inicio] = '1'
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
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;Long   ll_inicio,ll_found,ll_count,ll_factor
String ls_moneda_cab,ls_flag_provisionado,ls_cta_ctbl  ,ls_expresion,ls_null        ,&
		 ls_doc_sgiro ,ls_tipo_doc	        ,ls_flag_tabla,ls_nro_doc  ,ls_cod_relacion,&
		 ls_flag_ctrl_reg
Decimal {3} ldc_tasa_cambio
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
	tab_1.tabpage_1.dw_detail.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]))
	tab_1.tabpage_2.dw_asiento_cab.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	tab_1.tabpage_2.dw_asiento_det.retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	
	
	/*Elimina Informacion de Tabla Temporal*/
	delete from tt_fin_deuda_financiera ;
	
	/*asociacion de moneda de cabecera*/
	IF dw_master.rowcount()  > 0 THEN
		ls_moneda_cab   = dw_master.object.cod_moneda  [dw_master.getrow()]
		ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
		ls_cta_ctbl		 = dw_master.object.cnta_ctbl   [dw_master.getrow()]
		
		For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
			 tab_1.tabpage_1.dw_detail.object.cod_moneda_cab [ll_inicio] = ls_moneda_cab
			 tab_1.tabpage_1.dw_detail.object.tasa_cambio    [ll_inicio] = ldc_tasa_cambio
			 
			 ls_tipo_doc			 = tab_1.tabpage_1.dw_detail.object.tipo_doc				[ll_inicio]
			 ls_nro_doc				 = tab_1.tabpage_1.dw_detail.object.nro_doc				[ll_inicio]
			 ls_cod_relacion		 = tab_1.tabpage_1.dw_detail.object.cod_relacion		[ll_inicio]
			 ls_flag_provisionado = tab_1.tabpage_1.dw_detail.object.flag_provisionado [ll_inicio]
			 ll_factor				 = tab_1.tabpage_1.dw_detail.object.factor				[ll_inicio]
			 ls_flag_tabla			 = tab_1.tabpage_1.dw_detail.object.flab_tabor			[ll_inicio]
			 
			 IF ls_flag_provisionado = 'N' THEN
				 //*ingresos indirectos PARTIDA EDITABLE*//
				 tab_1.tabpage_1.dw_detail.object.flag_partida [ll_inicio] = '1'
// 				 cbx_ref.checked = TRUE
			 END IF
			 
 			 //verificar condiciones de documentos
			 IF ls_tipo_doc = ls_doc_sgiro THEN
			    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = ls_null
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
					    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = ls_null
				    else
					    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = '1'	
				    end if
			    else
				    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = '1'	
			    end if				 
			    
		    END IF			
			 
			 
		Next
	END IF
	
	ls_expresion = 'cnta_ctbl = '+"'"+ls_cta_ctbl+"'"
	//flag de doc editable en cuenta de banco..
	ll_found = tab_1.tabpage_2.dw_asiento_det.Find(ls_expresion,1,tab_1.tabpage_2.dw_asiento_det.Rowcount())
	
	IF ll_found > 0 THEN //ENCONTRO CUENTA CONTABLE DE BANCO
		Setnull(ls_null)
		tab_1.tabpage_2.dw_asiento_det.object.flag_doc_edit [ll_found] = ls_null
	END IF
	

		 
		 
	
	
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	/*Generacion de Asientos*/
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
IF (dw_master.ii_update                      = 1 OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
	 tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
		tab_1.tabpage_2.dw_asiento_cab.ii_update = 0
		tab_1.tabpage_2.dw_asiento_det.ii_update = 0
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
ll_ano 			 = dw_master.object.ano 			[ll_row]
ll_mes 			 = dw_master.object.mes 			[ll_row]

/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario



/*Verificación de comprobante de retencion*/
SELECT Count(*) INTO :ll_count FROM retencion_igv_crt 
WHERE ((origen           = :ls_origen		  ) AND
		 (nro_reg_caja_ban = :ll_nro_registro ));

IF ll_count > 0 THEN
	cb_3.Enabled = FALSE
ELSE
	cb_3.Enabled = TRUE
END IF




IF ls_flag_estado <> '1' OR ll_count > 0 OR ls_result = '0' THEN
	dw_master.ii_protect = 0
	dw_master.of_protect()	
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	tab_1.tabpage_1.dw_detail.of_protect()	
	tab_1.tabpage_2.dw_asiento_det.ii_protect = 0
	tab_1.tabpage_2.dw_asiento_det.of_protect()	
	
	IF ls_flag_estado = '1' AND ls_result <> '0' THEN
		tab_1.tabpage_2.dw_asiento_det.Modify("imp_movsol.Protect='0'")
		tab_1.tabpage_2.dw_asiento_det.Modify("imp_movdol.Protect='0'")	
		tab_1.tabpage_2.dw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
		tab_1.tabpage_2.dw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")		
	END IF

	
ELSE
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	tab_1.tabpage_2.dw_asiento_det.of_protect()

	IF tab_1.tabpage_1.dw_detail.ii_protect = 0 THEN //MODIFICABLE DETALLE DOCUMENTOS
		//bloqueo de campos...
		tab_1.tabpage_1.dw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
		tab_1.tabpage_1.dw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
		tab_1.tabpage_1.dw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
		tab_1.tabpage_1.dw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
		tab_1.tabpage_1.dw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")
		tab_1.tabpage_1.dw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")						
	END IF
	
	//MODIFICABLE DETALLE ASIENTOS
	IF tab_1.tabpage_2.dw_asiento_det.ii_protect = 0 THEN
		tab_1.tabpage_2.dw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
		tab_1.tabpage_2.dw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	
	END IF
	
	IF is_accion <> 'new' THEN
		dw_master.object.ano.Protect = 1
		dw_master.object.mes.Protect = 1
		dw_master.object.nro_libro.Protect = 1		
	END IF 
	
	

END IF




end event

event ue_insert_pos;call super::ue_insert_pos;

IF idw_1 = dw_master THEN
	tab_1.tabpage_2.dw_asiento_cab.TriggerEvent('ue_insert')
END IF

/*Generacion de Asientos*/
ib_estado_asiento = TRUE
end event

event ue_delete_pos;call super::ue_delete_pos;	/*Generacion de Asientos*/
	ib_estado_asiento = TRUE
end event

event closequery;call super::closequery;DESTROY ids_asiento_adic
DESTROY ids_doc_pend_tbl
DESTROY ids_matriz_cntbl_det
DESTROY ids_glosa
DESTROY ids_crelacion_ext_tbl
DESTROY ids_rpt
end event

event ue_print;call super::ue_print;String ls_origen,ls_flag_ts,ls_print
Long ll_row_master,ll_nro_registro,ll_tiempo,ll_i


n_cst_impresion lnvo_impresion

sle_1.backcolor = rgb (255,255,0)


//declaracion de objecto
lnvo_impresion = create n_cst_impresion


ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
   tab_1.tabpage_2.dw_asiento_det.ii_update = 1 then //OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 THEN 
	Messagebox('Aviso','Debe Grabar Los Cambios Verifique! ')	

	Return
END IF	


ls_origen	    = dw_master.object.origen       [ll_row_master]
ll_nro_registro = dw_master.object.nro_registro [ll_row_master]	

IF cbx_ts.checked THEN
	ls_flag_ts = '1' 
ELSE
	ls_flag_ts = '0' 
END IF

//nombre de impresora
ls_print = Upper(dw_master.describe('datawindow.printer'))

/*IMPRESION LOCAL O TERMINAL SERVER*/
lnvo_impresion.of_voucher ('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gnvo_app.invo_empresa.is_empresa,ls_flag_ts,ls_print)


//destruccion de objeto
destroy lnvo_impresion


ll_tiempo = 1500


For ll_i = 1 to ll_tiempo 
	 w_fi309_cartera_de_cobros.SetMicrohelp( String( ll_i ))
End For 


sle_1.backcolor = rgb (255,0,0)


w_fi309_cartera_de_cobros.SetMicrohelp( String( 0 ))
end event

type p_pie from w_abc`p_pie within w_fi309_cartera_de_cobros
end type

type ole_skin from w_abc`ole_skin within w_fi309_cartera_de_cobros
end type

type uo_h from w_abc`uo_h within w_fi309_cartera_de_cobros
end type

type st_box from w_abc`st_box within w_fi309_cartera_de_cobros
end type

type phl_logonps from w_abc`phl_logonps within w_fi309_cartera_de_cobros
end type

type p_mundi from w_abc`p_mundi within w_fi309_cartera_de_cobros
end type

type p_logo from w_abc`p_logo within w_fi309_cartera_de_cobros
end type

type sle_1 from singlelineedit within w_fi309_cartera_de_cobros
integer x = 3378
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

type cbx_ts from checkbox within w_fi309_cartera_de_cobros
integer x = 3616
integer y = 636
integer width = 489
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terminal Server"
end type

type rb_1 from radiobutton within w_fi309_cartera_de_cobros
integer x = 3648
integer y = 520
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voucher"
end type

type cb_3 from commandbutton within w_fi309_cartera_de_cobros
boolean visible = false
integer x = 3675
integer y = 252
integer width = 439
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Genera Cheque"
end type

event clicked;
//String        ls_flag_estado ,ls_flag_pago   ,ls_codctabco   ,ls_afav       ,&
//				  ls_tdoc_cab    ,ls_ndoc_cab    ,ls_flag_cta_bco,ls_flag_cencos,&
//				  ls_flag_doc_ref,ls_flag_cod_rel,ls_t_cheque    ,ls_cnta_ctbl  ,&
//				  ls_expresion 
//Long          ll_reg_cheque ,ll_row ,ll_nro_cheque,ll_found,ll_row_ddw
//Decimal {2}   ldc_imp_total
//
//
//
Long   ll_row,ll_reg_cheque,ll_nro_cheque,ll_found
String ls_flag_estado ,ls_codctabco    ,ls_afav       ,ls_cnta_ctbl   ,ls_expresion   ,&
		 ls_t_cheque	 ,ls_flag_cta_bco ,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		 ls_flag_cebef
Decimal {2} ldc_imp_total

str_parametros lstr_param

dw_master.Accepttext()
ll_row = dw_master.Getrow ()

/*parametros*/
SELECT doc_cheque INTO :ls_t_cheque FROM finparam WHERE (reckey = '1') ;

ll_reg_cheque  = dw_master.object.reg_cheque	 [ll_row]
ls_flag_estado = dw_master.object.flag_estado [ll_row]
ls_codctabco	= dw_master.object.cod_ctabco  [ll_row]
ldc_imp_total	= dw_master.object.imp_total	 [ll_row]

//ls_tdoc_cab		= dw_master.object.tipo_doc	 [ll_row]
//ls_ndoc_cab		= dw_master.object.nro_doc		 [ll_row]
ls_afav			= ''
//
//
//
IF ls_flag_estado = '0' THEN
	Messagebox('Aviso','No se Puede Generar Cheque ,Registro Ha sido Anulado')
	Return 
END IF	


IF Isnull(ls_codctabco) OR Trim(ls_codctabco) = '' THEN
	Messagebox('Aviso','No se Puede Generar Cheque ,Verifique Cuenta de banco')
	Return 
END IF


IF Not (Isnull(ll_reg_cheque) ) THEN
	Messagebox('Aviso','No se Puede Generar , Cheque ya Ha Sido Generado!')
	Return 
END IF

 

//* Open de Ventana de Ayuda*//
lstr_param.string1 = ls_afav

OpenWithParm(w_pop_cheque_afavor,lstr_param)
//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	ls_afav = lstr_param.string1
END IF
//**//

DECLARE PB_USP_FIN_GENER_CHEQUE_X_DOC PROCEDURE FOR USP_FIN_GENER_CHEQUE_X_DOC
(:ls_codctabco , :gnvo_app.is_user ,:ldc_imp_total ,:ls_afav );
EXECUTE PB_USP_FIN_GENER_CHEQUE_X_DOC ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_GENER_CHEQUE_X_DOC , Comunicar en Area de Sistemas' )
	Rollback ;
	RETURN
END IF

FETCH PB_USP_FIN_GENER_CHEQUE_X_DOC INTO :ll_reg_cheque,:ll_nro_cheque ;

CLOSE PB_USP_FIN_GENER_CHEQUE_X_DOC ;

IF Isnull(ll_nro_cheque) OR ll_nro_cheque = 0 THEN
	Rollback ;
	Messagebox('Aviso','Coloque Correlativo de Cheque de Cuenta de BANCO ,Verifique!')
	RETURN
END IF

//**actualiza cabecera**//
dw_master.object.reg_cheque [ll_row] = ll_reg_cheque
dw_master.object.nro_cheque [ll_row] = ll_nro_cheque
dw_master.object.tipo_doc   [ll_row] = ls_t_cheque
dw_master.object.nro_doc    [ll_row] = Trim(String(ll_nro_cheque))



//*BUSCAR CUENTA DE BANCO EN ASIENTO*/
ls_cnta_ctbl = dw_master.object.cnta_ctbl [ll_row]

ls_expresion = "cnta_ctbl = '"+ls_cnta_ctbl+"'"
ll_found     = tab_1.tabpage_2.dw_asiento_det.find(ls_expresion,1,tab_1.tabpage_2.dw_asiento_det.rowcount()) 

IF ll_found > 0 THEN
	IF f_cntbl_cnta(ls_cnta_ctbl,ls_flag_cta_bco,ls_flag_cencos,ls_flag_doc_ref, &
					   ls_flag_cod_rel,ls_flag_cebef)  THEN
		IF ls_flag_doc_ref = '1' THEN
			tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [ll_found] = ls_t_cheque
			tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [ll_found] = Trim(String(ll_nro_cheque))
			tab_1.tabpage_2.dw_asiento_det.ii_update = 1
		END IF

	END IF		
END IF


dw_master.ii_update = 1

//--



end event

type cb_2 from commandbutton within w_fi309_cartera_de_cobros
integer x = 3657
integer y = 140
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
/*Generacion de Asientos*/
ib_estado_asiento = TRUE
end event

type cbx_ref from checkbox within w_fi309_cartera_de_cobros
integer x = 3625
integer y = 368
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
//	if tab_1.tabpage_1.dw_detail.Rowcount() > 0 then
//		Messagebox('Aviso','Ya ingreso documentos con referencia , no podra utilizar esta opción , Verifique!')
//		This.Checked = FALSE
//		Return
//	end if
//ELSE	
//	if tab_1.tabpage_1.dw_detail.Rowcount() > 0 then
//		Messagebox('Aviso','Ya ingreso documentos sin referencia ,  Verifique!')
//		This.Checked = TRUE
//		Return
//	end if
//END IF
//
end event

type tab_1 from tab within w_fi309_cartera_de_cobros
integer x = 18
integer y = 720
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
integer y = 8
integer width = 3099
integer height = 680
integer taborder = 30
string dataobject = "d_abc_caja_bancos_det_cartera_pago_new"
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

//datos del banco
ls_moneda 		 = dw_master.object.cod_moneda  [dw_master.getrow()]
ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
ls_confin		 = dw_master.object.confin		  [dw_master.getrow()]
ls_matriz		 = dw_master.object.matriz_cntbl[dw_master.getrow()]

ll_row = This.RowCount()

IF ll_row = 1 THEN 
	ll_item = 0
ELSE
	ll_item = Getitemnumber(ll_row - 1,"item")
END IF

This.SetItem(al_row, "item", ll_item + 1)  
This.object.flag_flujo_caja [al_row] = '1'





IF cbx_ref.Checked THEN
	This.object.origen_doc		   [al_row] = gnvo_app.is_origen //INDIRECTO
	This.object.flag_provisionado [al_row] = 'N'       //INDIRECTO
	This.object.cod_moneda			[al_row]	= ls_moneda
	This.object.cod_moneda_cab 	[al_row] = ls_moneda
	This.object.tasa_cambio       [al_row] = ldc_tasa_cambio
	This.object.flag_doc			   [al_row] = '1'       //tipo de documento editable.
//	This.object.flag_partida		[al_row] = '1'       //partida editable
	//por cobrar partida no editable
	This.object.factor			   [al_row] = 1
	This.object.confin			   [al_row] = ls_confin
	this.object.matriz_cntbl		[al_row]	= ls_matriz
	this.object.flag_aplic_comp	[al_row]	= '0'			//compesacion
	
END IF	


//bloqueo de campos....
tab_1.tabpage_1.dw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
tab_1.tabpage_1.dw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
tab_1.tabpage_1.dw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
tab_1.tabpage_1.dw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
tab_1.tabpage_1.dw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")			

end event

event itemchanged;call super::itemchanged;Long   ll_count,ll_mes,ll_ano,ll_null,ll_nro_registro
String ls_data,ls_soles,ls_dolares,ls_cod_moneda,ls_null,ls_cencos,ls_cnta_prsp,&
		 ls_flag_provisionado,ls_matriz,ls_accion,ls_origen,ls_cod_relacion,ls_tip_doc_ref,&
		 ls_nro_doc_ref,ls_flag_estado,ls_nom_proveedor
Decimal {2} ldc_porc_ret_igv,ldc_importe,ldc_imp_retencion
Decimal {3} ldc_tasa_cambio
dwItemStatus ldis_status

SetNull(ls_flag_estado)

Accepttext()
/*Generacion de Asientos*/
ib_estado_asiento = TRUE

choose case dwo.name
		 case 'centro_benef'
				select Count(*) into :ll_count from centro_benef_usuario 
				 Where cod_usr      = :gnvo_app.is_user and
				 		 centro_benef = :data	;
				 
				IF ll_count = 0  THEN
					Messagebox('Aviso','Centro de Beneficio No esta Asignado al Usuario Verifique')
					Setnull(ls_null)
					This.Object.centro_benef [row] = ls_null
					Return 1
				END IF
				
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
			MESSAGEBOX('AA',DATA)
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
				

//				//afectacion presupuestal verificacion
//				IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
//					ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
//					ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
//					ls_cencos	 = this.object.cencos    [row]
//					ls_cnta_prsp = this.object.cnta_prsp [row]
//					ldc_importe  = this.object.importe   [row]
//					
//					IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
//						this.object.cnta_prsp [row] = ls_null
//						this.object.importe   [row] = ll_null		
//						dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
//						dw_master.ii_update = 1
//						RETURN 1
//					END IF
//				END IF
				
		 case	'flag_ret_igv'			
				
				IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
					/*porcentaje de retencion igv*/
					SELECT porc_ret_igv INTO :ldc_porc_ret_igv FROM finparam WHERE reckey = '1' ;
					/**/
				
					f_monedas(ls_soles,ls_dolares)
					
		 			ldc_importe     = This.object.importe     [row] 		
			 		ls_cod_moneda   = This.object.cod_moneda  [row] 					
				   ldc_tasa_cambio = This.object.tasa_cambio [row] 					
					
					IF ls_cod_moneda <> ls_soles THEN 
				 	 	//ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
				 	 	ldc_importe   = ldc_importe * ldc_tasa_cambio
		    	 	END IF
				  
		 			ldc_imp_retencion = Round((ldc_importe * ldc_porc_ret_igv)/ 100,2)
					 
				 	This.object.impt_ret_igv [row] = ldc_imp_retencion					
					 
				ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
					This.object.impt_ret_igv [row] = 0.00
				END IF
				
				

				PostEvent('ue_items')

end choose


end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot,ls_flag_provisionado,ls_cencos,ls_cnta_prsp,ls_null,ls_cod_relacion
Long   ll_null,ll_mes ,ll_ano
Decimal {2} ldc_importe
str_parametros sl_param
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
 		 CASE 'b_2'
				//BUSCAR CODIGO DE RELACION EN DETALLE DE PAGO
				ls_cod_relacion = this.object.cod_relacion [row]
				
				if Isnull(ls_cod_relacion) or Trim(ls_cod_relacion) = ''  then
					Messagebox('Aviso','Codigo de Relacion del Detalle debe Colocarse para ' &
											+' Buscar Deudadas Financieras' )
					Return						 
				end if
				
				sl_param.tipo			= '14' 
				sl_param.opcion		= 13
				sl_param.titulo 		= 'Selección de Deudas Financieras'
				sl_param.dw_master	= 'd_abc_lista_deuda_financiera_cab_tbl'
				sl_param.dw1			= 'd_abc_lista_deuda_financiera_det_tbl'
				sl_param.dw_m			= dw_master
				sl_param.dw_d			= tab_1.tabpage_1.dw_detail
				sl_param.long1			= row
				sl_param.string1		= ls_cod_relacion
				

				dw_master.Accepttext()


				OpenWithParm( w_abc_seleccion_md, sl_param)
				
				if sl_param.bret then
					ii_update = 1	
				end if
						
		 CASE 'confin'

				sl_param.tipo			= ''
				sl_param.opcion		= 3
				sl_param.titulo 		= 'Selección de Concepto Financiero'
				sl_param.dw_master	= 'd_lista_grupo_financiero_grd'
				sl_param.dw1			= 'd_lista_concepto_financiero_grd'
				sl_param.dw_m			=  This
				
				OpenWithParm( w_abc_seleccion_md, sl_param)
				IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
				IF sl_param.titulo = 's' THEN
					This.ii_update = 1
					/*Generacion de Asientos*/
					ib_estado_asiento = TRUE
				END IF
				
		 CASE 'tipo_doc'
			  ls_flag_provisionado = this.object.flag_provisionado [row]
  			  IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O' ) OR is_accion = 'fileopen' THEN RETURN
			  
			  lstr_seleccionar.s_seleccion = 'S'
           lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_COBRAR.TIPO_DOC AS CODIGO_DOC,'&
			  											+'VW_FIN_DOC_X_GRUPO_COBRAR.DESC_TIPO_DOC AS DESCRIPCION '&
			   										+'FROM VW_FIN_DOC_X_GRUPO_COBRAR '  
														
			  OpenWithParm(w_seleccionar,lstr_seleccionar)
			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			  IF lstr_seleccionar.s_action = "aceptar" THEN
				  Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
				  ii_update = 1
				  /*Generacion de Asientos*/
				  ib_estado_asiento = TRUE
			  END IF	
														
		CASE 'cod_relacion'
			  ls_flag_provisionado = this.object.flag_provisionado [row]
			  IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O') OR is_accion = 'fileopen' THEN RETURN
			  
			  lstr_seleccionar.s_seleccion = 'S'
			  lstr_seleccionar.s_sql =	'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO , '&
														+'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE   '&
												      +'FROM PROVEEDOR '&
												      +'WHERE (PROVEEDOR.FLAG_ESTADO =   '+"'"+'1'+"')"
														
			  OpenWithParm(w_seleccionar,lstr_seleccionar)
			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			  IF lstr_seleccionar.s_action = "aceptar" THEN
				  Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
				  Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])				  
				  ii_update = 1
				  /*Generacion de Asientos*/
				  ib_estado_asiento = TRUE
			  END IF	
			  
		CASE 'cencos'
			  ls_flag_provisionado = this.object.flag_provisionado [row]
			  IF (ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'O') THEN RETURN
			  
			  lstr_seleccionar.s_seleccion = 'S'
			  lstr_seleccionar.s_sql =	'SELECT CENTROS_COSTO.CENCOS      AS CODIGO , '&
														+'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION  '&
												      +'FROM CENTROS_COSTO '&
												      +'WHERE (CENTROS_COSTO.FLAG_ESTADO =   '+"'"+'1'+"')"
														
			  OpenWithParm(w_seleccionar,lstr_seleccionar)
			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			  IF lstr_seleccionar.s_action = "aceptar" THEN
				
				  Setitem(row,'cencos',lstr_seleccionar.param1[1])
				  //afectacion presupuestal verificacion
				  IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
					  ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
					  ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
					  ls_cencos	   = this.object.cencos    [row]
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
														 +'C.COD_USR = '+"'"+gnvo_app.is_user+"'"
				  
		     OpenWithParm(w_seleccionar,lstr_seleccionar)
			  
			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    			  IF lstr_seleccionar.s_action = "aceptar" THEN
			   	  Setitem(row,'centro_benef',lstr_seleccionar.param1[1])
				     ii_update = 1
				  END IF
		CASE 'cnta_prsp'
			
			  ls_flag_provisionado = this.object.flag_provisionado [row]
			  IF (ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'O') THEN RETURN
			  
			  lstr_seleccionar.s_seleccion = 'S'
			  lstr_seleccionar.s_sql =	'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP   AS CODIGO , '&
														+'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION  '&
												      +'FROM PRESUPUESTO_CUENTA '
					
														
			  OpenWithParm(w_seleccionar,lstr_seleccionar)
			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			  IF lstr_seleccionar.s_action = "aceptar" THEN
				
				  Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
				  //afectacion presupuestal verificacion
				  IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
					  ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
					  ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
					  ls_cencos	   = this.object.cencos    [row]
					  ls_cnta_prsp = this.object.cnta_prsp [row]
					  ldc_importe  = this.object.importe   [row]
					
					  IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
						  this.object.cencos    [row] = ls_null
						  this.object.importe   [row] = ll_null		
						  dw_master.Object.imp_total [1] =	wf_recalcular_monto_det()
						  dw_master.ii_update = 1
						  RETURN 1
					  END IF
				  END IF				  
				  
				  ii_update = 1
				  /*Generacion de Asientos*/
				  ib_estado_asiento = TRUE				  				  
			  END IF	
			  
END CHOOSE





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
integer x = 18
integer y = 48
integer width = 3099
integer height = 680
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

event itemchanged;call super::itemchanged;Accepttext()
/*Generacion de Asientos*/
ib_estado_asiento = FALSE
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_asiento_cab from u_dw_abc within tabpage_2
integer x = 27
integer y = 48
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

type dw_master from u_dw_abc within w_fi309_cartera_de_cobros
integer width = 2743
integer height = 696
string dataobject = "d_abc_caja_bancos_cab_cartera_pago_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
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

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot



ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if



str_seleccionar lstr_seleccionar
str_parametros   sl_param
String ls_cod_moneda
Decimal {3} ldc_tasa_cambio

CHOOSE CASE dwo.name
		 CASE 'cod_ctabco'
			   lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA_BANCO ,'&
												       +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION ,'&
												       +'BANCO_CNTA.CNTA_CTBL AS CUENTA_CONTABLE,'&      
											 	       +'BANCO_CNTA.COD_MONEDA AS MONEDA,'&
												       +'BANCO_CNTA.COD_ORIGEN  CODIGO_ORIGEN '&
												       +'FROM BANCO_CNTA '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ctabco',lstr_seleccionar.param1[1])
					Setitem(row,'banco_cnta_descripcion',lstr_seleccionar.param2[1])
					Setitem(row,'cnta_ctbl',lstr_seleccionar.param3[1])
					Setitem(row,'banco_cnta_cod_moneda',lstr_seleccionar.param4[1])
					Setitem(row,'cod_moneda',lstr_seleccionar.param4[1])
					
					
				   ldc_tasa_cambio = This.object.tasa_cambio [row]
					ls_cod_moneda	 = lstr_seleccionar.param4 [1]
					
				   // Actualiza Tipo de Moneda y Tasa Cambio
				   wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
					
					// Recalcula Detalle					
				   This.Object.imp_total [row] =	wf_recalcular_monto_det()
					
					ii_update = 1
               /*Generacion de Asientos*/
				   ib_estado_asiento = TRUE				  
					
				END IF	
				
		 CASE 'cod_relacion'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES '&
								   					 +'FROM PROVEEDOR ' &
														 +'WHERE PROVEEDOR.FLAG_ESTADO ='+"'"+'1'+"'"


														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					ii_update = 1
					/*Generacion de Asientos*/
				   ib_estado_asiento = TRUE				  					
				END IF		
				
		 CASE 'confin'

				sl_param.tipo			= ''
				sl_param.opcion		= 2
				sl_param.titulo 		= 'Selección de Concepto Financiero'
				sl_param.dw_master	= 'd_lista_grupo_financiero_grd'
				sl_param.dw1			= 'd_lista_concepto_financiero_grd'
				sl_param.dw_m			=  This
				
				OpenWithParm( w_abc_seleccion_md, sl_param)
				IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
				IF sl_param.titulo = 's' THEN
					This.ii_update = 1
					/*Generacion de Asientos*/
				   ib_estado_asiento = TRUE				  										
				END IF
				
		CASE 'tipo_doc'
			
			  lstr_seleccionar.s_seleccion = 'S'
           lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO_DOC,'&
			  											+'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
			   										+'FROM DOC_TIPO '  
														
			  OpenWithParm(w_seleccionar,lstr_seleccionar)
			  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			  IF lstr_seleccionar.s_action = "aceptar" THEN
				  Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
				  Setitem(row,'desc_tipo_doc',lstr_seleccionar.param2[1])
				  ii_update = 1
				  /*Generacion de Asientos*/
				  ib_estado_asiento = TRUE				  									  
			  END IF	
														
		
END CHOOSE



end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
Long       ll_row_gch,ll_count
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

				
				This.object.mes [row] = Long(String(ld_fecha_emision,'MM'))					
				This.object.ano [row] = Long(String(ld_fecha_emision,'YYYY'))					
				
				//busca tipo de cambio
				This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
				
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
				This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
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
				select count(*) into :ll_count from doc_tipo where tipo_doc = :data ;
				
				if ll_count = 0 then
					
					
					setnull(ls_codigo)
					setnull(ls_descripcion)
					
					this.object.tipo_doc      [row] = ls_codigo
					this.object.desc_tipo_doc [row] = ls_descripcion
					messagebox('Aviso','Documento No Existe Verifique!')
					return 1
				else
					select desc_tipo_doc into :ls_descripcion from doc_tipo where tipo_doc = :data ;
					
					this.object.desc_tipo_doc [row] = ls_descripcion
				end if
							
END CHOOSE				
				






end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_nro_libro 

IF f_nro_libro_cobros(ll_nro_libro) = FALSE THEN Messagebox('Aviso','No Existe Nro de Libro , Verifique Tabla de Parametros Finparam , Campo libro_cobros')

This.Object.origen 		      [al_row] = gnvo_app.is_origen
This.Object.cod_usr 		      [al_row] = gnvo_app.is_user
This.Object.nro_libro	      [al_row] = ll_nro_libro
This.Object.fecha_emision     [al_row] = f_fecha_actual (1)
This.Object.tasa_cambio       [al_row] = f_tasa_cambio  ()
This.Object.ano			      [al_row] = Long(String(f_fecha_actual(1),'YYYY'))
This.Object.mes			      [al_row] = Long(String(f_fecha_actual(1),'MM'))
This.Object.flag_estado       [al_row] = '1'
This.Object.flag_tiptran      [al_row] = '3' //cartera de cobros
This.Object.flag_conciliacion [al_row] = '1' //falta conciliar
//

end event

type gb_1 from groupbox within w_fi309_cartera_de_cobros
integer x = 3616
integer y = 460
integer width = 567
integer height = 152
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresion"
end type

type gb_2 from groupbox within w_fi309_cartera_de_cobros
integer x = 3223
integer y = 224
integer width = 453
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

type cb_1 from commandbutton within w_fi309_cartera_de_cobros
integer x = 3657
integer y = 752
integer width = 439
integer height = 92
integer taborder = 20
boolean bringtotop = true
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
sl_param.tipo 		= '1CC'
sl_param.opcion   = 18  //cartera de cobros
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

