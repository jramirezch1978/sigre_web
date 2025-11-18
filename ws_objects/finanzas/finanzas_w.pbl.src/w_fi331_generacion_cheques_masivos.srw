$PBExportHeader$w_fi331_generacion_cheques_masivos.srw
forward
global type w_fi331_generacion_cheques_masivos from w_abc_list
end type
type dw_master from datawindow within w_fi331_generacion_cheques_masivos
end type
type rb_1 from radiobutton within w_fi331_generacion_cheques_masivos
end type
type rb_2 from radiobutton within w_fi331_generacion_cheques_masivos
end type
type gb_1 from groupbox within w_fi331_generacion_cheques_masivos
end type
type cb_1 from commandbutton within w_fi331_generacion_cheques_masivos
end type
type cb_2 from commandbutton within w_fi331_generacion_cheques_masivos
end type
end forward

global type w_fi331_generacion_cheques_masivos from w_abc_list
integer width = 3557
integer height = 1924
string title = "Generación de Cheques Masivos (FI-331)"
string menuname = "m_consulta"
dw_master dw_master
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
cb_1 cb_1
cb_2 cb_2
end type
global w_fi331_generacion_cheques_masivos w_fi331_generacion_cheques_masivos

type variables
Long il_nro_doc,il_nro_asiento
String is_nro_ret
DataStore ids_asiento_det,ids_doc_pend,ids_matriz_cntbl_det
end variables

forward prototypes
public function boolean wf_nro_libro_pagos (ref long al_nro_libro)
public function boolean wf_actualiza_cab_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento)
public subroutine wf_verifica_total ()
public function boolean wf_bloqueo_nro_asiento (string as_origen, long al_nro_libro, long al_ano, long al_mes, ref long al_nro_asiento)
public function boolean wf_bloqueo_reg_cb ()
public function boolean wf_insert_asiento_det_dp (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, decimal adc_monto_total, decimal adc_tasa_cambio, string as_cnta_ctbl_bco, string as_desc_ctabco, string as_cta_bco, string as_nro_cheque, string as_flag_ret, decimal adc_impsol_ret, decimal adc_impdol_ret, decimal adc_monto_soles, decimal adc_monto_dolares)
public function boolean wf_genera_cheque (string as_codctabco, string as_user, decimal adc_monto_soles, decimal adc_monto_dolares, string as_afav, ref long al_reg_cheque, ref long al_nro_cheque, string as_cod_moneda, string as_soles)
public function boolean wf_bloqueo_cr (long al_nro_serie, ref string as_mensaje)
public function boolean wf_insert_caja_bancos_det (string as_origen, long al_nro_registro, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, decimal adc_importe, string as_flag_ret, decimal adc_imp_ret, string as_flab_tabor, string as_confin, string as_origen_doc, string as_cod_moneda, string as_flag_prov, long al_factor)
public function boolean wf_insert_cab_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_moneda, decimal adc_tasa_cambio, datetime adt_f_cntbl, datetime adt_f_registro, string as_cod_usr, string as_flag_estado, string as_flag_tabla, string as_obs)
public function boolean wf_generacion_cntas_x_cf (string as_matriz_cntbl, string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, decimal adc_tasa_cambio, string as_cod_moneda, long al_row_det, string as_ctabco, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_cnta_ctbl_bco, string as_desc_ctabco, string as_cta_bco, string as_nro_cheque, string as_obs)
public function boolean wf_insert_caja_bancos (string as_origen, long al_nro_registro, string as_flag_estado, datetime adt_fecha_emision, string as_flag_pago, string as_cod_moneda, string as_cod_relacion, decimal adc_tasa_cambio, decimal adc_importe_soles, decimal adc_importe_dolares, string as_ctabco, long al_nro_reg_cheque, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_flag_tiptran, string as_nro_cheque, string as_soles, string as_confin, string as_obs)
end prototypes

public function boolean wf_nro_libro_pagos (ref long al_nro_libro);Boolean lb_retorno = TRUE

SELECT libro_pagos
  INTO :al_nro_libro
  FROM finparam
 WHERE (reckey = '1') ;
 
IF Isnull(al_nro_libro) OR al_nro_libro = 0 THEN
	Messagebox('Aviso','Campo Libro_Pagos en tabla Finparam esta Vacio , Verifique!')
	lb_retorno = FALSE
END IF

Return lb_retorno
end function

public function boolean wf_actualiza_cab_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento);Boolean lb_ret = TRUE

DECLARE PB_USP_FIN_ACT_CAB_ASIENTO PROCEDURE FOR USP_FIN_ACT_CAB_ASIENTO
(:as_origen,:al_ano,:al_mes,:al_nro_libro,:al_nro_asiento);
EXECUTE PB_USP_FIN_ACT_CAB_ASIENTO ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_ACT_CAB_ASIENTO , Comunicar en Area de Sistemas' )
	lb_ret = FALSE
	GOTO SALIDA
END IF


CLOSE PB_USP_FIN_ACT_CAB_ASIENTO ;

SALIDA:

Return lb_ret 
end function

public subroutine wf_verifica_total ();Long ll_inicio 
Decimal {2} ldc_saldo,ldc_total = 0.00

FOR ll_inicio = 1 TO dw_2.Rowcount()
	 ldc_saldo = dw_2.object.importe [ll_inicio]
	 IF Isnull(ldc_saldo) THEN ldc_saldo = 0.00
	 ldc_total = ldc_total + ldc_saldo
NEXT

dw_master.object.monto_util[1] = ldc_total
end subroutine

public function boolean wf_bloqueo_nro_asiento (string as_origen, long al_nro_libro, long al_ano, long al_mes, ref long al_nro_asiento);Boolean lb_retorno =TRUE
Long    ll_count

SELECT nro_asiento
  INTO :al_nro_asiento
  FROM cntbl_libro_mes
 WHERE ((origen	 = :as_origen   ) AND
 		  (nro_libro = :al_nro_libro) AND  
		  (ano 		 = :al_ano		 ) AND
		  (mes		 = :al_mes      )) 
FOR UPDATE NOWAIT		  ;
	
IF Isnull(al_nro_asiento) OR al_nro_asiento = 0 THEN
	SELECT Count(*)
  	  INTO :ll_count
     FROM cntbl_libro_mes
	  WHERE ((origen	  = :as_origen   ) AND
 		      (nro_libro = :al_nro_libro) AND  
		      (ano 		  = :al_ano		  ) AND
		      (mes		  = :al_mes      ));

	/*Crear Nro de Asiento Mes */
	IF al_nro_libro > 0 THEN
		al_nro_asiento = 1 
	ELSE
		Messagebox('Aviso','Numero de Asiento de Libro No Existe , Verifique Tabla cntbl_libro_mes')
		lb_retorno = FALSE
	END IF
	
END IF

Return lb_retorno

end function

public function boolean wf_bloqueo_reg_cb ();Boolean lb_retorno = TRUE
String  ls_lock_table

ls_lock_table = 'LOCK TABLE NUM_CAJA_BANCOS IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT ult_nro
  INTO :il_nro_doc
  FROM num_caja_bancos
 WHERE (origen = :gs_origen) ;

	
IF Isnull(il_nro_doc) OR il_nro_doc = 0 THEN
	Messagebox('Aviso','Debe Verificar Tabla de Numeración NUM_CAJA_BANCOS , Comuniquese con Sistemas!')
	Return FALSE	
END IF

	
RETURN lb_retorno
end function

public function boolean wf_insert_asiento_det_dp (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, decimal adc_monto_total, decimal adc_tasa_cambio, string as_cnta_ctbl_bco, string as_desc_ctabco, string as_cta_bco, string as_nro_cheque, string as_flag_ret, decimal adc_impsol_ret, decimal adc_impdol_ret, decimal adc_monto_soles, decimal adc_monto_dolares);Boolean lb_ret = TRUE
String  ls_cnta_ctbl  ,ls_flag_debhab,ls_glosa_dp,ls_cencos_dp,ls_codctabco_dp,&
		  ls_nro_docref2,ls_moneda_det,ls_cta_ctbl_gan,ls_cta_ctbl_per,ls_soles,&
		  ls_dolares,ls_cnta_ctbl_dif,ls_flag_debhab_dif,ls_flag_debhab_dif_x_doc,&
		  ls_det_glosa,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		  ls_t_doc_cheque,ls_cnta_ctbl_ret,ls_desc_cta_ret,ls_debhab_ret,ls_t_doc_ret,&
		  ls_flag_cebef
Integer li_item = 1
Long    ll_count		  
Decimal {2} ldc_saldo_sol,ldc_saldo_dol,ldc_monto_soles,ldc_imp_soles,ldc_imp_dolares
Datetime	ldt_fecha_actual




/*tipo de moneda*/
ls_moneda_det = dw_master.object.moneda [1]


/*Cuentas Contables para Diferencia de Cambio*/
SELECT cnta_ctbl_dc_ganancia,cnta_ctbl_dc_perdida,doc_cheque,cnta_cntbl_ret_igv,doc_ret_igv_crt
  INTO :ls_cta_ctbl_gan,:ls_cta_ctbl_per,:ls_t_doc_cheque,:ls_cnta_ctbl_ret,:ls_t_doc_ret
  FROM finparam
 WHERE (reckey = '1') ;


/*descripcion de cnta contable*/
SELECT desc_cnta
  INTO :ls_desc_cta_ret
  FROM cntbl_cnta
 WHERE (cnta_ctbl = :ls_cnta_ctbl_ret );


IF Isnull(ls_t_doc_cheque) OR Trim(ls_t_doc_cheque) = '' THEN
	Messagebox('Aviso','Debe Colocar Tipo de Documento Cheque en tabla de parametros')
	lb_ret = FALSE
	GOTO SALIDA
END IF
//Monedas
f_monedas (ls_soles,ls_dolares)


//**Se Genera Asientos de Acuerdo A al Mismo Documento **//
//adc_monto_total monto del documento a generar

ids_doc_pend.Retrieve(as_cod_relacion,as_tipo_doc,as_nro_doc)
			 
IF ids_doc_pend.Rowcount() > 0   THEN
	ls_cnta_ctbl   = ids_doc_pend.object.cnta_ctbl   [1]
	ls_flag_debhab = ids_doc_pend.object.flag_debhab [1]
	ldc_saldo_sol  = ids_doc_pend.object.sldo_sol	 [1]
	ldc_saldo_dol	= ids_doc_pend.object.saldo_dol   [1]
ELSE
	/*AVISO DE ERROR*/
	lb_ret = FALSE
   GOTO SALIDA		
END IF			 
			 
//Recupera Datos Complementarios
ids_asiento_det.Retrieve(as_cod_relacion,as_tipo_doc,as_nro_doc)	 
			 
IF ids_asiento_det.Rowcount() > 0 THEN
   ls_glosa_dp     = ids_asiento_det.object.det_glosa   [1]
	ls_cencos_dp    = ids_asiento_det.object.cencos      [1]
	ls_codctabco_dp = ids_asiento_det.object.cod_ctabco  [1]
	ls_nro_docref2  = ids_asiento_det.object.nro_docref2 [1]
ELSE
	SetNull(ls_glosa_dp)
	SetNull(ls_cencos_dp)
	SetNull(ls_codctabco_dp)
	SetNull(ls_nro_docref2)
END IF

			 
			 
IF Not(Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '') THEN
 	/************************/
   /*Diferencia en Cambio  */
	/************************/
	IF ls_moneda_det = ls_dolares THEN /*SE REVISARA DIFERENCIA EN CAMBIO*/				 
	  	ldc_saldo_sol = Round(ldc_saldo_dol * adc_tasa_cambio,2) - ldc_saldo_sol
		 
		IF ldc_saldo_sol > 0 THEN     /*Dolar Subio*/
		   ls_cnta_ctbl_dif         = ls_cta_ctbl_per
			ls_flag_debhab_dif       = ls_flag_debhab
			
			/*invertir flag debhab de doc*/
			IF ls_flag_debhab = 'D' THEN
			   ls_flag_debhab_dif_x_doc = 'H'
			ELSE
			   ls_flag_debhab_dif_x_doc = 'D'
		   END IF
						 
			ldc_saldo_dol = 0.00
			ls_det_glosa  = 'Diferencia en Cambio Dolar se Incremento'
			
		/*monto de Diferencia en CAMBIO*/
		ELSEIF ldc_saldo_sol < 0 THEN /*Dolar Bajo*/		
			ls_cnta_ctbl_dif = ls_cta_ctbl_gan
			/*invertir flag debhab de DIF*/	
			IF ls_flag_debhab = 'D' THEN
			   ls_flag_debhab_dif = 'H'
			ELSE
			   ls_flag_debhab_dif = 'D'
			END IF
			
		   ls_flag_debhab_dif_x_doc = ls_flag_debhab
			ldc_saldo_dol = 0.00
			ldc_saldo_sol = ldc_saldo_sol * -1
						 
			ls_det_glosa  = 'Diferencia en Cambio Dolar Disminuyo'
			
		/*Monto de diferencia en CAMBIO*/
	   ELSEIF ldc_saldo_sol = 0 THEN /*No Genera Diferencia en Cambio*/
		   GOTO SAL_ASIENTO					
		END IF /*VERIFICACION SALDO*/
												  
//		/*Insertar Nuevo Registro*/						 
		/*Busqueda x Origen,ano,mes,nro_libro,nro_asiento,cuenta contable,flag_debhab*/
		SELECT Count(*)
		  INTO :ll_count
		  FROM cntbl_asiento_det
		 WHERE ((origen      = :as_origen          ) AND
		 		  (ano         = :al_ano				 ) AND	
		 		  (mes         = :al_mes	          ) AND
				  (nro_libro   = :al_nro_libro       ) AND
				  (nro_asiento = :al_nro_asiento     ) AND
				  (cnta_ctbl   = :ls_cnta_ctbl_dif   ) AND
				  (flag_debhab = :ls_flag_debhab_dif )) ;
				  
		
		IF ll_count > 0 THEN
			/*Actualizo Monto en Soles*/
			/*Replicacion*/
			UPDATE cntbl_asiento_det
				SET imp_movsol = Nvl(imp_movsol,0.00) + :ldc_saldo_sol,flag_replicacion = '1'
		    WHERE ((origen      = :as_origen          ) AND
		 		     (ano         = :al_ano				 ) AND	
		 		     (mes         = :al_mes	          ) AND
				     (nro_libro   = :al_nro_libro       ) AND
				     (nro_asiento = :al_nro_asiento     ) AND
				     (cnta_ctbl   = :ls_cnta_ctbl_dif   ) AND
				     (flag_debhab = :ls_flag_debhab_dif )) ;
					  
					  
			IF SQLCA.SQLCode = -1 THEN 
				MessageBox('SQL error de Update Asiento a Doc. x Diferencia en Cambio', SQLCA.SQLErrText)
				lb_ret = FALSE
				GOTO SALIDA
			END IF					  
			
		ELSE
			
			ldt_fecha_actual = f_fecha_actual()	
			
			/*Inserto Nuevo Asiento de Diferencia en cambio*/
			/*Replicacion*/
			INSERT INTO cntbl_asiento_det
         (origen    ,ano       ,mes         ,nro_libro  ,nro_asiento ,   
          item      ,cnta_ctbl ,fec_cntbl   ,det_glosa  ,flag_debhab ,   
          imp_movsol,imp_movdol,flag_replicacion)  
			VALUES
			(:as_origen    ,:al_ano          ,:al_mes          ,:al_nro_libro,:al_nro_asiento    ,
          :li_item      ,:ls_cnta_ctbl_dif,:ldt_fecha_actual,:ls_det_glosa,:ls_flag_debhab_dif,
          :ldc_saldo_sol,0.00             ,'1')  ;
			 
		   IF SQLCA.SQLCode = -1 THEN 
				MessageBox('SQL error de Nuevo Asiento a Doc. x Diferencia en Cambio', SQLCA.SQLErrText)
				lb_ret = FALSE
				GOTO SALIDA
			END IF
	 
			 
		END IF /*fin de bucle de busqueda*/
		

		//incrementa item de asiento detalle
		li_item  = li_item + 1
		
		ldt_fecha_actual = f_fecha_actual()	
		/*Inserto Asiento de doc x diferencia en cambio*/	
		/*Replicacion*/
		INSERT INTO cntbl_asiento_det
      (origen     ,ano         ,mes         ,nro_libro     ,nro_asiento ,   
       item       ,cnta_ctbl   ,fec_cntbl   ,det_glosa     ,flag_debhab ,
		 cencos     ,cod_ctabco  ,tipo_docref1,nro_docref1   ,cod_relacion,
		 imp_movsol ,imp_movdol  ,flag_replicacion)  
	   VALUES
		(:as_origen   ,:al_ano         ,:al_mes          ,:al_nro_libro ,:al_nro_asiento          ,
		 :li_item     ,:ls_cnta_ctbl   ,:ldt_fecha_actual,:ls_glosa_dp  ,:ls_flag_debhab_dif_x_doc,
		 :ls_cencos_dp,:ls_codctabco_dp,:as_tipo_doc     ,:as_nro_doc   ,:as_cod_relacion			  ,
		 :ldc_saldo_sol,0.00           ,'1'   )  ;
		 
		IF SQLCA.SQLCode = -1 THEN 
			MessageBox('SQL error de Asiento a Doc. x Diferencia en Cambio', SQLCA.SQLErrText)
			lb_ret = FALSE
			GOTO SALIDA
		END IF

	END IF /*CIERRA X TIPO DE MONEDA*/
			 
SAL_ASIENTO:

//incrementa item de asiento detalle
li_item  = li_item + 1
ldt_fecha_actual = f_fecha_actual()	
/*Monto de asiento*/
IF ls_moneda_det = ls_soles THEN
	ldc_imp_soles   = adc_monto_total
   ldc_imp_dolares = Round(adc_monto_total / adc_tasa_cambio,2)						  
ELSE
	ldc_imp_soles	 = Round(adc_monto_total * adc_tasa_cambio,2)						  
	ldc_imp_dolares = adc_monto_total
END IF

/*insercion de asiento a documento a pagar*/
/*Replicacion*/
INSERT INTO cntbl_asiento_det
(origen     ,ano ,mes   ,nro_libro   ,nro_asiento ,   
 item       ,cnta_ctbl  ,fec_cntbl   ,det_glosa	 ,	
 flag_debhab,cencos     ,cod_ctabco  ,tipo_docref1,   
 nro_docref1,nro_docref2,cod_relacion,imp_movsol  ,   
 imp_movdol ,flag_replicacion)
VALUES 
(:as_origen      ,:al_ano         ,:al_mes          ,:al_nro_libro ,:al_nro_asiento ,
 :li_item		  ,:ls_cnta_ctbl	 ,:ldt_fecha_actual,:ls_glosa_dp  ,
 :ls_flag_debhab ,:ls_cencos_dp	,:ls_codctabco_dp  ,:as_tipo_doc  ,
 :as_nro_doc	  ,:ls_nro_docref2 ,:as_cod_relacion ,:ldc_imp_soles,
 :ldc_imp_dolares,'1' );


IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error de Asiento a Doc. x Pagar', SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF

ELSE	  
   lb_ret = FALSE
	Messagebox('Aviso','Documento de Referencias '+Trim(as_tipo_doc)+' '+Trim(as_nro_doc) +' Tiene Problemas , Verifique!')
   GOTO SALIDA
END IF /*por cuenta*/


/**Genero Asiento x Cuenta de Banco**/
//incrementa item de asiento detalle
li_item  = li_item + 1
ldt_fecha_actual = f_fecha_actual()	

/*Replicacion*/
INSERT INTO cntbl_asiento_det
(origen     ,ano ,mes   ,nro_libro   ,nro_asiento     ,   
 item       ,cnta_ctbl  ,fec_cntbl   ,det_glosa	      ,	
 flag_debhab,imp_movsol ,imp_movdol  ,flag_replicacion )
VALUES 
(:as_origen    ,:al_ano           ,:al_mes           ,:al_nro_libro   ,:al_nro_asiento ,
 :li_item		,:as_cnta_ctbl_bco ,:ldt_fecha_actual ,:as_desc_ctabco ,
 'H'			   ,:adc_monto_soles  ,:adc_monto_dolares,'1' );

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error de Asiento Cuenta de Banco', SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF


IF f_cntbl_cnta(as_cnta_ctbl_bco,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,&
			       ls_flag_cod_rel,ls_flag_cebef)  THEN
					 
	IF ls_flag_ctabco = '1' THEN
		/*Replicacion*/
		UPDATE cntbl_asiento_det 
	      SET cod_ctabco = :as_cta_bco ,flag_replicacion = '1'
       WHERE (( origen      = :as_origen     ) AND  
              ( ano         = :al_ano        ) AND  
              ( mes         = :al_mes        ) AND  
              ( nro_libro   = :al_nro_libro  ) AND  
              ( nro_asiento = :al_nro_asiento) AND  
              ( item        = :li_item       ))   ;

		IF SQLCA.SQLCode = -1 THEN 
			MessageBox('SQL error de Update de Cuenta de Banco', SQLCA.SQLErrText)
			lb_ret = FALSE
			GOTO SALIDA
		END IF
		
	END IF
	
	IF ls_flag_doc_ref = '1' THEN
		/*Replicacion*/
		UPDATE cntbl_asiento_det
         SET tipo_docref1 = :ls_t_doc_cheque, nro_docref1 = :as_nro_cheque ,flag_replicacion = '1'
   	 WHERE (( origen      = :as_origen      ) AND  
       		  ( ano         = :al_ano         ) AND  
         	  ( mes         = :al_mes         ) AND  
         	  ( nro_libro   = :al_nro_libro   ) AND  
         	  ( nro_asiento = :al_nro_asiento ) AND  
         	  ( item 		 = :li_item			 ))   ;
				  


		IF SQLCA.SQLCode = -1 THEN 
			MessageBox('SQL error de Update de Cuenta de Banco x nro de Documento', SQLCA.SQLErrText)
			lb_ret = FALSE
			GOTO SALIDA
		END IF				  
		
	END IF
END IF



IF as_flag_ret = '1' THEN
	/*asiento de comprobante de retenciones*/
	IF ls_flag_debhab = 'D' THEN
		ls_debhab_ret = 'H'
	ELSE
		ls_debhab_ret = 'D'
	END IF

	li_item  = li_item + 1
	ldt_fecha_actual = f_fecha_actual()	
   /*Replicacion*/
	INSERT INTO cntbl_asiento_det
	(origen     ,ano ,mes   ,nro_libro   ,nro_asiento     ,   
	 item       ,cnta_ctbl  ,fec_cntbl   ,det_glosa	      ,	
	 flag_debhab,imp_movsol ,imp_movdol  ,flag_replicacion )
	VALUES 
	(:as_origen    ,:al_ano           ,:al_mes          ,:al_nro_libro    ,:al_nro_asiento ,
	 :li_item		,:ls_cnta_ctbl_ret ,:ldt_fecha_actual,:ls_desc_cta_ret ,
	 :ls_debhab_ret,:adc_impsol_ret   ,:adc_impdol_ret  ,'1');

	IF SQLCA.SQLCode = -1 THEN 
		MessageBox('SQL error de Asiento Cuenta de Banco', SQLCA.SQLErrText)
		lb_ret = FALSE
		GOTO SALIDA
	END IF
	
	IF f_cntbl_cnta(ls_cnta_ctbl_ret,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,&
			          ls_flag_cod_rel,ls_flag_cebef)  THEN
		
		IF ls_flag_cod_rel = '1' THEN
			/*Replicacion*/
			UPDATE cntbl_asiento_det
         	SET cod_relacion = :as_cod_relacion,flag_replicacion = '1'
   	 	 WHERE (( origen      = :as_origen     ) AND  
       		     ( ano         = :al_ano         ) AND  
         	  	  ( mes         = :al_mes         ) AND  
         	  	  ( nro_libro   = :al_nro_libro   ) AND  
         	  	  ( nro_asiento = :al_nro_asiento ) AND  
         	  	  ( item 		 = :li_item			 ))   ;

			IF SQLCA.SQLCode = -1 THEN 
				MessageBox('SQL error de Update de C. de Retencion en Cod Relacion', SQLCA.SQLErrText)
				lb_ret = FALSE
				GOTO SALIDA
			END IF				  			
			
		END IF
		
		IF ls_flag_doc_ref = '1' THEN
			/*Replicacion*/
			UPDATE cntbl_asiento_det
         	SET tipo_docref1     = :ls_t_doc_ret,   
         		 nro_docref1      = :is_nro_ret  ,
					 flag_replicacion = '1'
   	 	 WHERE (( origen      = :as_origen      ) AND  
       		     ( ano         = :al_ano         ) AND  
         	  	  ( mes         = :al_mes         ) AND  
         	  	  ( nro_libro   = :al_nro_libro   ) AND  
         	  	  ( nro_asiento = :al_nro_asiento ) AND  
         	  	  ( item 		 = :li_item			 ))   ;

			IF SQLCA.SQLCode = -1 THEN 
				MessageBox('SQL error de Update de C. de Retencion en tipo doc', SQLCA.SQLErrText)
				lb_ret = FALSE
				GOTO SALIDA
			END IF				  			
		END IF
		
		
		
					 
					 
	END IF

END IF


SALIDA:

Return lb_ret
end function

public function boolean wf_genera_cheque (string as_codctabco, string as_user, decimal adc_monto_soles, decimal adc_monto_dolares, string as_afav, ref long al_reg_cheque, ref long al_nro_cheque, string as_cod_moneda, string as_soles);Boolean lb_ret = TRUE
Decimal {2} ldc_imp_total


IF as_cod_moneda = as_soles THEN
	ldc_imp_total = adc_monto_soles
ELSE
	ldc_imp_total = adc_monto_dolares
END IF

DECLARE PB_USP_FIN_GENER_CHEQUE_X_DOC PROCEDURE FOR USP_FIN_GENER_CHEQUE_X_DOC
(:as_codctabco , :gs_user ,:ldc_imp_total ,:as_afav );
EXECUTE PB_USP_FIN_GENER_CHEQUE_X_DOC ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_GENER_CHEQUE_X_DOC , Comunicar en Area de Sistemas '+SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF

FETCH PB_USP_FIN_GENER_CHEQUE_X_DOC INTO :al_reg_cheque,:al_nro_cheque ;

CLOSE PB_USP_FIN_GENER_CHEQUE_X_DOC ;

IF Isnull(al_nro_cheque) OR al_nro_cheque = 0 THEN
	Messagebox('Aviso','Coloque Correlativo de Cheque de Cuenta de BANCO ,Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF

SALIDA:

Return lb_ret
end function

public function boolean wf_bloqueo_cr (long al_nro_serie, ref string as_mensaje);Long    ll_nro_doc
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

	is_nro_ret = f_llena_caracteres('0',Trim(String(al_nro_serie)),li_dig_serie)+'-'+ f_llena_caracteres('0',Trim(String(ll_nro_doc)),li_dig_numero)


SALIDA:

Return lb_retorno

end function

public function boolean wf_insert_caja_bancos_det (string as_origen, long al_nro_registro, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, decimal adc_importe, string as_flag_ret, decimal adc_imp_ret, string as_flab_tabor, string as_confin, string as_origen_doc, string as_cod_moneda, string as_flag_prov, long al_factor);Boolean lb_ret = TRUE
Long ll_item

ll_item = ll_item + 1


INSERT INTO caja_bancos_det 
(origen          ,nro_registro ,item             ,cod_relacion ,
 tipo_doc        ,nro_doc      ,importe          ,flab_tabor   ,
 confin          ,origen_doc   ,flag_ret_igv     ,impt_ret_igv ,
 flag_flujo_caja ,cod_moneda   ,flag_provisionado,factor       ,
 flag_replicacion)  
VALUES 
(:as_origen       ,:al_nro_registro ,:ll_item      ,
 :as_cod_relacion ,:as_tipo_doc     ,:as_nro_doc   ,
 :adc_importe     ,:as_flab_tabor   ,:as_confin    ,
 :as_origen_doc   ,:as_flag_ret     ,:adc_imp_ret  ,
 '1'              ,:as_cod_moneda   ,:as_flag_prov ,
 :al_factor       ,'1')  ;
 
 
IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error Insert Caja Bancos det', SQLCA.SQLErrText)
	lb_ret = FALSE
END IF 

Return lb_ret

//FLAB_TABOR
end function

public function boolean wf_insert_cab_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_moneda, decimal adc_tasa_cambio, datetime adt_f_cntbl, datetime adt_f_registro, string as_cod_usr, string as_flag_estado, string as_flag_tabla, string as_obs);Boolean lb_ret = TRUE

/****************************************/
/*Cabecera de Asiento    					 */
/****************************************/
INSERT INTO CNTBL_ASIENTO
(origen     ,ano        ,mes             ,nro_libro   ,nro_asiento ,   
 cod_moneda ,tasa_cambio,fecha_cntbl     ,fec_registro,cod_usr		,
 flag_estado,flag_tabla ,flag_replicacion,desc_glosa)   
VALUES 
(:as_origen     ,:al_ano	       ,:al_mes     ,:al_nro_libro  ,:al_nro_asiento,
 :as_moneda     ,:adc_tasa_cambio ,:adt_f_cntbl,:adt_f_registro,:as_cod_usr	  ,
 :as_flag_estado,:as_flag_tabla   ,'1'			  ,:as_obs	)  ;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error (Inserción de Cntbl Asiento)", SQLCA.SQLErrText)
	lb_ret = FALSE
END IF


Return lb_ret
end function

public function boolean wf_generacion_cntas_x_cf (string as_matriz_cntbl, string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, decimal adc_tasa_cambio, string as_cod_moneda, long al_row_det, string as_ctabco, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_cnta_ctbl_bco, string as_desc_ctabco, string as_cta_bco, string as_nro_cheque, string as_obs);Boolean lb_ret = TRUE
Long    ll_row_preas
String  ls_cnta_ctbl,ls_desc_cnta,ls_glosa_texto,ls_glosa_campo,ls_campo,&
		  ls_soles,ls_dolares,ls_flag_debhab,ls_flag_ctabco,ls_flag_cencos,&
		  ls_flag_doc_ref,ls_flag_cod_rel,ls_t_doc_cheque,ls_flag_cebef
Datetime ldt_fecha
Decimal {2} ldc_monto_total,ldc_imp_sol,ldc_imp_dol

/*monedas*/
f_monedas(ls_soles,ls_dolares)

/**/
SELECT doc_cheque
  INTO :ls_t_doc_cheque
  FROM finparam
 WHERE (reckey = '1') ;


IF Isnull(ls_t_doc_cheque) OR Trim(ls_t_doc_cheque) = '' THEN
	Messagebox('Aviso','Debe Colocar Tipo de Documento Cheque en tabla de parametros')
	lb_ret = FALSE
	GOTO SALIDA
END IF




ids_matriz_cntbl_det.Retrieve(as_matriz_cntbl)			 
IF ids_matriz_cntbl_det.Rowcount() > 0 THEN
	FOR ll_row_preas = 1 TO ids_matriz_cntbl_det.Rowcount() 
		
		 /*Recuperación de Información de Matriz*/	
  	    ls_cnta_ctbl   = ids_matriz_cntbl_det.object.cnta_ctbl	 [ll_row_preas]	
		 ls_flag_debhab = ids_matriz_cntbl_det.object.flag_debhab [ll_row_preas]
		 ls_desc_cnta   = ids_matriz_cntbl_det.object.desc_cnta	 [ll_row_preas]	
		 ls_glosa_texto = ids_matriz_cntbl_det.object.glosa_texto [ll_row_preas]	
		 ls_glosa_campo = ids_matriz_cntbl_det.object.glosa_campo [ll_row_preas] 	
		 
	    ls_campo = ids_matriz_cntbl_det.object.formula [ll_row_preas]
		 ldc_monto_total = dw_2.Getitemnumber(al_row_det,ls_campo)
		 
  		 /*monto de asiento*/
		 IF as_cod_moneda = ls_soles THEN
			 ldc_imp_sol = ldc_monto_total
			 ldc_imp_dol = Round(ldc_monto_total / adc_tasa_cambio,2)
       ELSE
			 ldc_imp_sol = Round(ldc_monto_total * adc_tasa_cambio,2)
			 ldc_imp_dol = ldc_monto_total
       END IF
		 
		 ldt_fecha = f_fecha_actual()
		 /*Replicacion*/
		 INSERT INTO cntbl_asiento_det
       (origen    ,ano       ,mes         ,nro_libro ,nro_asiento , 
		  item	   ,cnta_ctbl ,fec_cntbl   ,flag_debhab ,
        imp_movsol,imp_movdol,flag_replicacion,det_glosa )  
  	    VALUES
		 (:as_origen   ,:al_ano      ,:al_mes	   ,:al_nro_libro  ,:al_nro_asiento,
		  :ll_row_preas,:ls_cnta_ctbl,:ldt_fecha	,:ls_flag_debhab,:ldc_imp_sol	  ,
		  :ldc_imp_dol	,'1'			  ,:as_obs	)  ;
		  
		 IF SQLCA.SQLCode = -1 THEN 
			 lb_ret = FALSE
			 MessageBox('SQL error de Asiento de Matriz Contable', SQLCA.SQLErrText)
			 GOTO SALIDA
		 END IF 
      
		 IF f_cntbl_cnta(ls_cnta_ctbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,&
					 		  ls_flag_cod_rel,ls_flag_cebef)  THEN
			 
			 IF ls_flag_ctabco = '1' THEN //*cuenta de banco*//
			 	 /*Replicacion*/
			 	 UPDATE cntbl_asiento_det
				    SET cod_ctabco = :as_ctabco,flag_replicacion = '1'
				  WHERE ((origen      = :as_origen     ) AND
						  	(ano	       = :al_ano        ) AND
							(mes	       = :al_mes	      ) AND
							(nro_libro   = :al_nro_libro  ) AND
							(nro_asiento = :al_nro_asiento) AND
							(item			 = :ll_row_preas	)) ;	
           							
		 		 IF SQLCA.SQLCode = -1 THEN 
					 lb_ret = FALSE
					 MessageBox('SQL error de Update de Ctabco Asiento de Matriz Contable', SQLCA.SQLErrText)
					 GOTO SALIDA
				 END IF 

			 END IF
			 
			 IF ls_flag_doc_ref = '1' THEN //*documento de referencia*//
			 	 /*Replicacion*/
			 	 UPDATE cntbl_asiento_det
				    SET tipo_docref1 = :as_tipo_doc,nro_docref1 = :as_nro_doc,flag_replicacion = '1'
				  WHERE ((origen      = :as_origen     ) AND
						  	(ano	       = :al_ano        ) AND
							(mes	       = :al_mes	      ) AND
							(nro_libro   = :al_nro_libro  ) AND
							(nro_asiento = :al_nro_asiento) AND
							(item			 = :ll_row_preas	)) ;	
							
		 		 IF SQLCA.SQLCode = -1 THEN 
					 lb_ret = FALSE
					 MessageBox('SQL error de Update dr de Asiento de Matriz Contable', SQLCA.SQLErrText)
					 GOTO SALIDA
				 END IF 
							
			 END IF
			 
			 IF ls_flag_cod_rel = '1' THEN //*codigo de relacion*//
			 	 /*Replicacion*/
			 	 UPDATE cntbl_asiento_det
				    SET cod_relacion = :as_cod_relacion,flag_replicacion = '1'
				  WHERE ((origen      = :as_origen     ) AND
						  	(ano	       = :al_ano        ) AND
							(mes	       = :al_mes	      ) AND
							(nro_libro   = :al_nro_libro  ) AND
							(nro_asiento = :al_nro_asiento) AND
							(item			 = :ll_row_preas	)) ;

		 		 IF SQLCA.SQLCode = -1 THEN 
					 lb_ret = FALSE
					 MessageBox('SQL error de Update cr Asiento de Matriz Contable', SQLCA.SQLErrText)
					 GOTO SALIDA
				 END IF 
							
				
			 END IF
		 END IF	
	NEXT
ELSE
	Messagebox('Aviso','Matriz Contable No Contiene Cuentas Contable ,Verifique!')	
	lb_ret = FALSE
	GOTO SALIDA
END IF

/**Genero Asiento x Cuenta de Banco**/
//incrementa item de asiento detalle
ll_row_preas  = ll_row_preas + 1
ldt_fecha = f_fecha_actual()	
/*Replicacion*/
INSERT INTO cntbl_asiento_det
(origen     ,ano ,mes   ,nro_libro   ,nro_asiento ,   
 item       ,cnta_ctbl  ,fec_cntbl   ,det_glosa	 ,	
 flag_debhab,imp_movsol ,imp_movdol  ,flag_replicacion)
VALUES 
(:as_origen    ,:al_ano           ,:al_mes      ,:al_nro_libro   ,:al_nro_asiento ,
 :ll_row_preas ,:as_cnta_ctbl_bco ,:ldt_fecha   ,:as_desc_ctabco ,
 'H'			   ,:ldc_imp_sol      ,:ldc_imp_dol ,'1'              );

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error de Asiento Cuenta de Banco', SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF


IF f_cntbl_cnta(as_cnta_ctbl_bco,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,&
			       ls_flag_cod_rel,ls_flag_cebef)  THEN
					 
	IF ls_flag_ctabco = '1' THEN
		/*Replicacion*/
		UPDATE cntbl_asiento_det
	      SET cod_ctabco = :as_cta_bco,flag_replicacion = '1'
       WHERE (( origen      = :as_origen     ) AND  
              ( ano         = :al_ano        ) AND  
              ( mes         = :al_mes        ) AND  
              ( nro_libro   = :al_nro_libro  ) AND  
              ( nro_asiento = :al_nro_asiento) AND  
              ( item        = :ll_row_preas  ))   ;

		IF SQLCA.SQLCode = -1 THEN 
			MessageBox('SQL error de Update de Cuenta de Banco', SQLCA.SQLErrText)
			lb_ret = FALSE
			GOTO SALIDA
		END IF
		
	END IF
	
	IF ls_flag_doc_ref = '1' THEN
		/*Replicacion*/
		UPDATE cntbl_asiento_det
         SET tipo_docref1     = :ls_t_doc_cheque,   
         	 nro_docref1      = :as_nro_cheque  ,
				 flag_replicacion = '1'
   	 WHERE (( origen      = :as_origen      ) AND  
       		  ( ano         = :al_ano         ) AND  
         	  ( mes         = :al_mes         ) AND  
         	  ( nro_libro   = :al_nro_libro   ) AND  
         	  ( nro_asiento = :al_nro_asiento ) AND  
         	  ( item 		 = :ll_row_preas   ))   ;

		IF SQLCA.SQLCode = -1 THEN 
			MessageBox('SQL error de Update de Cuenta de Banco x nro de Documento', SQLCA.SQLErrText)
			lb_ret = FALSE
			GOTO SALIDA
		END IF				  
	END IF
END IF



SALIDA:

Return lb_ret



end function

public function boolean wf_insert_caja_bancos (string as_origen, long al_nro_registro, string as_flag_estado, datetime adt_fecha_emision, string as_flag_pago, string as_cod_moneda, string as_cod_relacion, decimal adc_tasa_cambio, decimal adc_importe_soles, decimal adc_importe_dolares, string as_ctabco, long al_nro_reg_cheque, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_flag_tiptran, string as_nro_cheque, string as_soles, string as_confin, string as_obs);Boolean lb_ret = TRUE
String  ls_tcheque
Decimal {2} ldc_importe_total

IF as_cod_moneda = as_soles THEN
	ldc_importe_total = adc_importe_soles
ELSE	
	ldc_importe_total = adc_importe_dolares
END IF	

/***/
SELECT doc_cheque
  INTO :ls_tcheque
  FROM finparam
 WHERE (reckey ='1') ;
 
IF Isnull(ls_tcheque) OR Trim(ls_tcheque) = '' THEN
	Messagebox('Aviso','No se Ha definido tipo de Documento de Cheque en Finparam ,Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF
/***/

/*Replicacion*/
INSERT INTO caja_bancos
(origen       ,nro_registro ,flag_estado,   
 fecha_emision,flag_pago    ,cod_moneda ,
 cod_relacion ,cod_usr      ,tasa_cambio,  
 imp_total    ,cod_ctabco   ,reg_cheque ,
 ano          ,mes   		 ,nro_libro	 ,
 nro_asiento  ,flag_tiptran ,tipo_doc	 ,   
 nro_doc      ,confin		 ,flag_replicacion,
 obs)  
VALUES 
(:as_origen        ,:al_nro_registro,:as_flag_estado   ,
 :adt_fecha_emision,:as_flag_pago   ,:as_cod_moneda    ,
 :as_cod_relacion	 ,:gs_user			,:adc_tasa_cambio  ,
 :ldc_importe_total,:as_ctabco		,:al_nro_reg_cheque,
 :al_ano				 ,:al_mes			,:al_nro_libro	    ,
 :al_nro_asiento   ,:as_flag_tiptran,:ls_tcheque	    ,
 :as_nro_cheque    ,:as_confin      ,'1'               ,
 :as_obs)  ;
 
 

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error Insert Caja Bancos', SQLCA.SQLErrText)
	lb_ret = FALSE
	GOTO SALIDA
END IF

SALIDA:

Return lb_ret
end function

on w_fi331_generacion_cheques_masivos.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.dw_master=create dw_master
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
end on

on w_fi331_generacion_cheques_masivos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event resize;call super::resize;dw_1.height = newheight - dw_1.y - 10
dw_2.height = newheight - dw_2.y - 10
dw_2.width  = newwidth  - dw_2.x - 10
end event

event ue_open_pre();call super::ue_open_pre;dw_1.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_2.SetTransObject(sqlca)


of_position_window(0,0)       			// Posicionar la ventana en forma fija


//** Datastore Detalle Asiento **//
ids_asiento_det 			   = Create Datastore
ids_asiento_det.DataObject = 'd_pre_asiento_x_doc_tbl'
ids_asiento_det.SettransObject(sqlca)
//** **//

//** Datastore Doc Pendientes Cta Cte **//
ids_doc_pend = Create Datastore
ids_doc_pend.DataObject = 'd_doc_pend_x_aplic_doc_tbl'
ids_doc_pend.SettransObject(sqlca)
//** **//

//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)
//** **//

end event

type dw_1 from w_abc_list`dw_1 within w_fi331_generacion_cheques_masivos
integer y = 664
integer width = 1627
integer height = 892
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ss 	  = 0
is_mastdet = 'm'        // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 			// dw_detail 

ii_ck[1] = 1            // columnas de lectrua de este dw


ii_dk[1]  = 1 //codigo relacion
ii_dk[2]  = 2 //tipo doc
ii_dk[3]  = 3 //nro doc
ii_dk[4]  = 4 //saldo
ii_dk[5]  = 5 //vencimiento
ii_dk[6]  = 6 //flab tabor
ii_dk[7]  = 7 //Origen Documento
ii_dk[9]  = 9 //Origen 
ii_dk[10] = 10 //Flag de Edición
ii_dk[11] = 11 //nombre
ii_dk[12] = 12 //obs

ii_rk[1] = 1 //codigo relacion
ii_rk[2] = 2 //tipo doc
ii_rk[3] = 3 //nro doc
ii_rk[4] = 4 //saldo
ii_rk[5] = 5 //vencimiento
ii_rk[6] = 6 //flab tabor
ii_rk[7] = 7 //Origen Documento
ii_rk[9] = 9 //Origen
ii_rk[10] = 10 //Flag de Edición
ii_rk[11] = 11 //nombre
ii_rk[12] = 12 //obs

ii_ss = 0
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT


wf_verifica_total ()

idw_det.object.nro [ll_row] = ll_row



/***********/
dw_2.Accepttext()
dw_2.SetRedraw(false)
dw_2.SetSort("#12 A")
dw_2.Sort()
dw_2.SetRedraw(true)
/***********/



end event

event dw_1::retrieveend;call super::retrieveend;dw_1.Modify("importe.Protect='1'")	
end event

event dw_1::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_1.Modify("importe.Protect='1'")	

end event

type dw_2 from w_abc_list`dw_2 within w_fi331_generacion_cheques_masivos
integer x = 1824
integer y = 664
integer width = 1627
integer height = 892
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;is_mastdet = 'm'		 // 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular' // tabular, form (default)

ii_ss = 0 				 // indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1			 // columnas de lectrua de este dw

idw_det  = dw_1       //dw_detalle


ii_dk[1]  = 1 //codigo relacion
ii_dk[2]  = 2 //tipo doc
ii_dk[3]  = 3 //nro doc
ii_dk[4]  = 4 //saldo
ii_dk[5]  = 5 //vencimiento
ii_dk[6]  = 6 //flab tabor
ii_dk[7]  = 7 //Origen Documento
ii_dk[9]  = 9 //Origen
ii_dk[10] = 10 //flag edicion
ii_dk[11] = 11 //flag edicion
ii_dk[12] = 12 //obs


ii_rk[1] = 1 //codigo relacion
ii_rk[2] = 2 //tipo doc
ii_rk[3] = 3 //nro doc
ii_rk[4] = 4 //saldo
ii_rk[5] = 5 //vencimiento
ii_rk[6] = 6 //flab tabor
ii_rk[7] = 7 //Origen Documento
ii_rk[9] = 9 //Origen
ii_rk[10] = 10 //flag edicion
ii_rk[11] = 11 //flag edicion
ii_rk[12] = 12 //obs
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

wf_verifica_total ()
end event

event dw_2::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

event dw_2::ue_insert_pre(long al_row);call super::ue_insert_pre;String ls_confin

ls_confin = dw_master.object.confin [dw_master.getrow()]

This.object.confin [al_row] = ls_confin

dw_2.Modify("importe.Protect='1~tIf(IsNull(flag_edit),0,1)'")		



end event

event dw_2::itemchanged;call super::itemchanged;String ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_cod_moneda,&
		 ls_soles,ls_dolares
Decimal {2} ldc_saldo_sol,ldc_saldo_dol,ldc_importe,ldc_porc_ret,&
				ldc_imp_ret
Decimal {3} ldc_tasa_cambio
Accepttext()

CHOOSE CASE dwo.name
		 CASE	'flag_ret'
			   SELECT porc_ret_igv
			     INTO :ldc_porc_ret  
			     FROM finparam
			    WHERE (reckey = '1')   ;

				f_monedas(ls_soles,ls_dolares)
			   ldc_tasa_cambio = gnvo_app.of_tasa_cambio ()
				ls_cod_moneda	 = dw_master.Object.moneda  [dw_master.Getrow()]
				ldc_importe		 = This.Object.importe		 [row]				
				
				
				IF data = '1' THEN /*RETENCION IGV*/
				   IF ls_cod_moneda <> ls_soles THEN /*CONVERTIR A SOLES*/
						ldc_importe = Round(ldc_importe * ldc_tasa_cambio,2)
					END IF
					
					/*calcular porcentaje de retencion*/
					ldc_imp_ret = Round(ldc_importe * ldc_porc_ret,2)
					
					This.object.monto_ret [row] = ldc_imp_ret
			   ELSE /*NO RETENCION IGV*/
					This.object.monto_ret [row] = 0.00
				END IF
				
				
		 CASE 'importe'
				f_monedas(ls_soles,ls_dolares)
				
				ls_cod_relacion = This.Object.cod_relacion [row]
				ls_tipo_doc		 = This.Object.tipo_doc     [row]
				ls_nro_doc		 = This.Object.nro_doc      [row]
				ls_cod_moneda	 = dw_master.Object.moneda  [dw_master.Getrow()]
				ldc_importe		 = This.Object.importe		 [row]
				
				wf_verifica_total ()			
				/*******************/
				SELECT sldo_sol,saldo_dol
				  INTO :ldc_saldo_sol,:ldc_saldo_dol
				  FROM doc_pendientes_cta_cte
				 WHERE ((cod_relacion = :ls_cod_relacion) AND
				 		  (tipo_doc     = :ls_tipo_doc    ) AND	
						  (nro_doc      = :ls_nro_doc     )) ;
				/*******************/
				
				
				IF ls_cod_moneda = ls_soles THEN				
					IF ldc_importe > ldc_saldo_sol THEN					
						This.Object.importe [row] = ldc_saldo_sol
						Messagebox('Aviso','Importe No Puede Ser Mayor que El Saldo , Verifique!')
						Return 1
					END IF	
				ELSE
					IF ldc_importe > ldc_saldo_dol THEN					
						This.Object.importe [row] = ldc_saldo_dol
						Messagebox('Aviso','Importe No Puede Ser Mayor que El Saldo , Verifique!')
						Return 1
					END IF	
				END IF	
				
END CHOOSE

end event

event dw_2::itemerror;call super::itemerror;Return 1
end event

type pb_1 from w_abc_list`pb_1 within w_fi331_generacion_cheques_masivos
integer x = 1664
integer y = 788
integer height = 124
end type

type pb_2 from w_abc_list`pb_2 within w_fi331_generacion_cheques_masivos
integer x = 1664
integer y = 1036
integer height = 132
end type

type dw_master from datawindow within w_fi331_generacion_cheques_masivos
integer width = 2615
integer height = 432
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_ext_gen_cheques_masivos_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

event itemchanged;String 		ls_descripcion,ls_ctabco,ls_cod_moneda,ls_ctabco_old,&
				ls_old_select, ls_new_select, ls_where,ls_desc_confin
Long        ll_count
Decimal {2} ldc_saldo_disponible
str_parametros lstr_param

ls_ctabco_old = This.object.cod_ctabco [row]

Accepttext()

CHOOSE CASE dwo.name
		 CASE	'flag_doc'
				IF data  = 'D' THEN //DOC PENDIENTES CTA CTE
					ls_cod_moneda = This.object.moneda [row]
					
					IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = ''  THEN
						Messagebox('Aviso','Debe Ingresar Cuenta de Banco')
						Return 1
					END IF
					
					//*Ejecuto Procediminto llenado de TTemporal*//
					DECLARE PB_USP_FIN_DOC_PEND_GEN_CHEQUE PROCEDURE FOR USP_FIN_DOC_PEND_GEN_CHEQUE
					(:ls_cod_moneda);
					EXECUTE PB_USP_FIN_DOC_PEND_GEN_CHEQUE;

					IF SQLCA.SQLCode = -1 THEN 
						MessageBox("SQL error", SQLCA.SQLErrText)
					END IF

					CLOSE PB_USP_FIN_DOC_PEND_GEN_CHEQUE ;	
					
					dw_1.dataobject = 'd_abc_doc_pend_gen_ch_tbl'
					dw_1.Settransobject(sqlca)
					IF dw_2.Rowcount() = 0 THEN
						dw_2.dataobject = 'd_abc_doc_pend_gen_ch_tbl'
						dw_2.Settransobject(sqlca)
					END IF
					
					//* Open de Ventana de Ayuda para Seleccionar Documento*//
					lstr_param.string1 = ls_cod_moneda
					lstr_param.opcion  = 1 //Doc Pendientes Cta Cte
					OpenWithParm(w_abc_help_gen_chq_mas,lstr_param)

					IF isvalid(message.PowerObjectParm) THEN
					   lstr_param = message.PowerObjectParm
						ls_old_select = dw_1.GetSQLSelect()
						ls_where      = 'WHERE tipo_doc in '+lstr_param.string2
						ls_new_select = ls_old_select + ls_where
						
						dw_1.SetSQLSelect(ls_new_select)
						dw_1.Retrieve()
					END IF
					/**/
				ELSEIF data = 'C' THEN //CUENTAS X PAGAR
					ls_cod_moneda = This.object.moneda [row]
					
					IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = ''  THEN
						Messagebox('Aviso','Debe Ingresar Cuenta de Banco')
						Return 1
					END IF
					
					
					dw_1.dataobject = 'd_abc_cuentas_pagar_gen_ch_tbl'
					dw_1.Settransobject(sqlca)
					IF dw_2.Rowcount() = 0 THEN
						dw_2.dataobject = 'd_abc_cuentas_pagar_gen_ch_tbl'
						dw_2.Settransobject(sqlca)
					END IF
					
					//* Open de Ventana de Ayuda para Seleccionar Documento*//
					lstr_param.string1 = ls_cod_moneda
					lstr_param.opcion  = 2 //Doc Pendientes Cta Cte
					OpenWithParm(w_abc_help_gen_chq_mas,lstr_param)

					IF isvalid(message.PowerObjectParm) THEN
					   lstr_param = message.PowerObjectParm
						ls_old_select = dw_1.GetSQLSelect()
						ls_where      = ' AND cntas_pagar.tipo_doc in '+lstr_param.string2 +" AND cntas_pagar.cod_moneda = '"+ls_cod_moneda+"'"
						ls_new_select = ls_old_select + ls_where
						messagebox('ls_new_select',ls_new_select)
						dw_1.SetSQLSelect(ls_new_select)
						dw_1.Retrieve()
					END IF
				END IF
		 CASE 'confin'
				SELECT descripcion
    				INTO :ls_desc_confin  
				   FROM concepto_financiero
			     WHERE (confin = :data)   ;
				  
				IF Isnull(ls_desc_confin) OR Trim(ls_desc_confin) = '' THEN
					SetNull(ls_desc_confin)
					Messagebox('Aviso','Concepto Financiero No Existe , Verirfique! ' )				
					This.object.confin 		[row] = ls_desc_confin
					This.object.desc_confin [row] = ls_desc_confin
					Return 1
				ELSE
					This.object.desc_confin [row] = ls_desc_confin
				END IF
				

		 CASE 'cod_ctabco'
			
				IF dw_2.Rowcount() > 0 THEN
					Messagebox('Aviso','No Puede Cambiar Cuenta de Banco , Verifique! ' )				
					This.object.cod_ctabco [row] = ls_ctabco_old
					Return 1
				END IF
				
											   
				SELECT Count(*)
			     INTO :ll_count
	           FROM banco_cnta
				 WHERE (cod_ctabco = :data) ;
				
				IF ll_count > 0 THEN
					SELECT descripcion ,saldo_disponible, cod_moneda
			     	  INTO :ls_descripcion,:ldc_saldo_disponible ,:ls_cod_moneda
	           	  FROM banco_cnta
				 	 WHERE (cod_ctabco = :data) ;
					
				
					This.object.des_ctabco [row] = ls_descripcion	
					This.object.saldo		  [row] = ldc_saldo_disponible
					This.object.moneda     [row] = ls_cod_moneda
					
				ELSE
					SetNull(ls_ctabco)
					SetNull(ls_descripcion)
					SetNull(ldc_saldo_disponible)
					
					This.object.cod_ctabco [row] = ls_ctabco
					This.object.des_ctabco [row] = ls_descripcion	
					This.object.saldo		  [row] = ldc_saldo_disponible
					This.object.moneda     [row] = ls_cod_moneda
					
					Messagebox('Aviso','Cuenta de Banco No existe , Verifique !')
					Return 2
				END IF
			   
END CHOOSE

end event

event doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot

str_seleccionar lstr_seleccionar
str_parametros   sl_param
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")



CHOOSE CASE dwo.name
		 CASE 'cod_ctabco'
				IF dw_2.Rowcount() > 0 THEN
					Messagebox('Aviso','No Puede Cambiar Cuenta de Banco , Verifique! ' )				
					Return
				END IF

				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO		 AS CUENTA,'&	
				                               +'BANCO_CNTA.DESCRIPCION      AS DESCRIPCION,'&
								      				 +'BANCO_CNTA.SALDO_DISPONIBLE AS SALDO, '&
														 +'BANCO_CNTA.COD_MONEDA       AS MONEDA, '&
														 +'BANCO_CNTA.CNTA_CTBL			 AS CUENTA_CONTABLE '&
								   					 +'FROM BANCO_CNTA '

														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = 'aceptar' THEN
					Setitem(row,'cod_ctabco',lstr_seleccionar.param1[1])
					Setitem(row,'des_ctabco',lstr_seleccionar.param2[1])
					Setitem(row,'saldo',lstr_seleccionar.paramdc3[1])
					Setitem(row,'moneda',lstr_seleccionar.param4[1])
				END IF		

				
		
END CHOOSE



				
											   
				

end event

event itemerror;Return 1
end event

type rb_1 from radiobutton within w_fi331_generacion_cheques_masivos
boolean visible = false
integer x = 78
integer y = 532
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Doc. Pendientes"
end type

event clicked;String ls_cod_moneda,ls_old_select,ls_where,ls_new_select
str_parametros lstr_param

IF rb_1.Checked THEN
	ls_cod_moneda = dw_master.object.moneda [dw_master.getrow()]
					
	IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = ''  THEN
		Messagebox('Aviso','Debe Ingresar Cuenta de Banco')
		Return 
	END IF
					
	//*Ejecuto Procediminto llenado de TTemporal*//
	DECLARE PB_USP_FIN_DOC_PEND_GEN_CHEQUE PROCEDURE FOR USP_FIN_DOC_PEND_GEN_CHEQUE
	(:ls_cod_moneda);
	EXECUTE PB_USP_FIN_DOC_PEND_GEN_CHEQUE;

	IF SQLCA.SQLCode = -1 THEN 
		MessageBox("SQL error", SQLCA.SQLErrText)
		Return
	END IF

	CLOSE PB_USP_FIN_DOC_PEND_GEN_CHEQUE ;	
					
	dw_1.dataobject = 'd_abc_doc_pend_gen_ch_tbl'
	dw_1.Settransobject(sqlca)

	IF dw_2.Rowcount() = 0 THEN
		dw_2.dataobject = 'd_abc_doc_pend_gen_ch_tbl'
		dw_2.Settransobject(sqlca)
	END IF
					
	//* Open de Ventana de Ayuda para Seleccionar Documento*//
	lstr_param.string1 = ls_cod_moneda
	lstr_param.opcion  = 1 //Doc Pendientes Cta Cte
	OpenWithParm(w_abc_help_gen_chq_mas,lstr_param)
	IF isvalid(message.PowerObjectParm) THEN
	   lstr_param = message.PowerObjectParm
		IF Not(Isnull(lstr_param.string2)  OR Trim(lstr_param.string2) = '') THEN 
			ls_old_select = dw_1.GetSQLSelect()
			ls_where      = ' AND tt_fin_doc_pend_cheque.tipo_doc in '+lstr_param.string2
			ls_new_select = ls_old_select + ls_where
			
	

			dw_1.SetSQLSelect(ls_new_select)
			dw_1.Retrieve()
		END IF
	END IF
	/**/
END IF	

end event

type rb_2 from radiobutton within w_fi331_generacion_cheques_masivos
integer x = 82
integer y = 528
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuentas por Pagar"
end type

event clicked;String ls_cod_moneda,ls_old_select,ls_where,ls_new_select
str_parametros lstr_param

IF rb_2.checked THEN
	
	ls_cod_moneda = dw_master.object.moneda [dw_master.getrow()]
					
	IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = ''  THEN
		Messagebox('Aviso','Debe Ingresar Cuenta de Banco')
		Return 1
	END IF
					
					
	dw_1.dataobject = 'd_abc_cuentas_pagar_gen_ch_tbl'
	dw_1.Settransobject(sqlca)

	IF dw_2.Rowcount() = 0 THEN
		dw_2.dataobject = 'd_abc_cuentas_pagar_gen_ch_tbl'
		dw_2.Settransobject(sqlca)
	END IF
					
	//* Open de Ventana de Ayuda para Seleccionar Documento*//
	lstr_param.string1 = ls_cod_moneda
	lstr_param.opcion  = 2 //Doc Pendientes Cta Cte
	OpenWithParm(w_abc_help_gen_chq_mas,lstr_param)

	IF isvalid(message.PowerObjectParm) THEN
	   lstr_param = message.PowerObjectParm
		
		IF Not(Isnull(lstr_param.string2)  OR Trim(lstr_param.string2) = '') THEN 
			ls_old_select = dw_1.GetSQLSelect()
			ls_where      = ' AND cntas_pagar.tipo_doc in '+lstr_param.string2 +" AND cntas_pagar.cod_moneda = '"+ls_cod_moneda+"'"
			ls_new_select = ls_old_select + ls_where
			dw_1.SetSQLSelect(ls_new_select)
			dw_1.Retrieve()
		END IF
	END IF
END IF
end event

type gb_1 from groupbox within w_fi331_generacion_cheques_masivos
integer x = 32
integer y = 456
integer width = 1426
integer height = 176
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documentos Visualizar"
end type

type cb_1 from commandbutton within w_fi331_generacion_cheques_masivos
integer x = 2921
integer y = 20
integer width = 521
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String  ls_cod_moneda,ls_flag_tabla,ls_origen_doc,ls_cod_relacion,ls_tipo_doc,ls_nro_doc,&
		  ls_confin,ls_matriz_cntbl,ls_ctabco,ls_nombre,ls_cnta_ctbl,ls_des_cta_bco,ls_flag_tabor,&
		  ls_origen,ls_flag_ret,ls_mensaje,ls_tipo_doc_ret,ls_soles,ls_dolares,ls_expresion,ls_obs
Long    ll_inicio,ll_nro_libro,ll_ano,ll_mes,ll_reg_cheque,ll_nro_cheque,ll_nro_serie_cr,&
		  ll_digitos_serie,ll_digitos_numero,ll_corr_cr,ll_found,ll_count
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_monto_total,ldc_imp_sol_ret,ldc_imp_dol_ret,ldc_monto_dolares,ldc_monto_soles
Boolean lb_ret = TRUE,lb_flag_ret = FALSE
Datetime ldt_fecha_actual

dw_master.Accepttext()
dw_2.Accepttext()

ldt_fecha_actual = f_fecha_actual()
/***********/
dw_2.SetRedraw(false)
dw_2.SetSort("#12 A")
dw_2.Sort()
dw_2.SetRedraw(true)
/***********/



/*Seteo Variable de Nro de Documento para caja bancos , Nro de Asiento*/
SetNull(il_nro_doc)
SetNull(il_nro_asiento)

/*Datos de Cabecera*/
ls_cod_moneda   = dw_master.object.moneda 	 [dw_master.Getrow()]
ls_ctabco		 = dw_master.object.cod_ctabco [dw_master.Getrow()]
ldc_tasa_cambio = gnvo_app.of_tasa_cambio ()

f_monedas(ls_soles,ls_dolares)

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.00 THEN
	lb_ret = FALSE
	GOTO SALIDA	
END IF



/*Cuenta de Banco*/
IF Isnull(ls_ctabco) OR Trim(ls_ctabco) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Cuenta de Banco , Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF

/*Cuenta Contable de Banco*/
SELECT cnta_ctbl,descripcion
  INTO :ls_cnta_ctbl,:ls_des_cta_bco
  FROM banco_cnta
 WHERE (cod_ctabco = :ls_ctabco) ;


IF Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '' THEN
	Messagebox('Aviso','Cuenta de Banco no tiene Cuenta Contable ,Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF
/*DATOS DE FINPARAM*/
SELECT digitos_serie,digitos_numero,doc_ret_igv_crt
  INTO :ll_digitos_serie,:ll_digitos_numero,:ls_tipo_doc_ret
  FROM finparam
 WHERE (reckey = '1') ;
             
/**************************/

/*****Datos de Año y Mes*****/
ll_ano = Long(String(f_fecha_actual(),'YYYY'))
ll_mes = Long(String(f_fecha_actual(),'MM'))

//*Recupero Nro de Libro de Pagos de FINPARAM*//
IF wf_nro_libro_pagos (ll_nro_libro) = FALSE THEN
	lb_ret = FALSE
	GOTO SALIDA
END IF 


/******Recupero nro a insertar en Caja Bancos*******/
IF wf_bloqueo_reg_cb () = FALSE THEN
	lb_ret = FALSE
	GOTO SALIDA
END IF


/******Recupero nro Asiento*******/
IF wf_bloqueo_nro_asiento (gs_origen,ll_nro_libro,ll_ano,ll_mes,il_nro_asiento) = FALSE THEN
	lb_ret = FALSE
	GOTO SALIDA
END IF

/*solamente se trabaja con un numero de serie del comprobante de retención*/
/*BUSCAR SI EXISTE RETENCIONES*/
ls_expresion = "flag_ret = '1'"
ll_found = dw_2.find(ls_expresion,1,dw_2.rowcount())

IF ll_found > 0 THEN
	ll_nro_serie_cr = dw_master.object.serie_cr [1]

	/*verificar si usuario tiene acceso a serie*/
	SELECT Count(*)
	  INTO :ll_count
	  FROM doc_tipo_usuario
	 WHERE ((tipo_doc  = :ls_tipo_doc_ret) AND
	 		  (nro_serie = :ll_nro_serie_cr) AND
			  (cod_usr   = :gs_user        )) ;
	

	IF ll_count = 0 THEN
		Messagebox('Aviso','Usuario No Tiene Acceso A Serie '+Trim(String(ll_nro_serie_cr)))	
		lb_ret = FALSE
		GOTO SALIDA
	END IF
	
	IF wf_bloqueo_cr (ll_nro_serie_cr,ls_mensaje) = FALSE THEN
		Messagebox('Aviso',ls_mensaje)	
		lb_ret = FALSE
		GOTO SALIDA
	END IF
	
END IF






/*Detalle de Documentos a Pagar*/
FOR ll_inicio = 1 TO dw_2.Rowcount()

	 
	 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
	 ls_tipo_doc	  = dw_2.object.tipo_doc 	  [ll_inicio]
	 ls_nro_doc		  = dw_2.object.nro_doc  	  [ll_inicio]
	 ldc_monto_total = dw_2.object.importe	  	  [ll_inicio]
	 ls_confin		  = dw_2.object.confin	  	  [ll_inicio]
	 ls_flag_tabor	  = dw_2.object.flab_tabor	  [ll_inicio]
	 ls_origen		  = dw_2.object.origen  	  [ll_inicio]
	 ls_flag_ret	  = dw_2.object.flag_ret  	  [ll_inicio]
	 ls_obs			  = dw_2.object.obs		  	  [ll_inicio]
	 
	 
	 /*descontar monto general*/
	 IF ls_cod_moneda = ls_soles THEN
		 ldc_monto_soles	 = ldc_monto_total
		 ldc_monto_dolares = Round(ldc_monto_total / ldc_tasa_cambio,2)
	 ELSE
		 ldc_monto_soles	 = Round(ldc_monto_total * ldc_tasa_cambio,2)
		 ldc_monto_dolares = ldc_monto_total
	 END IF			 
	 

 	 IF ls_flag_ret = '1' THEN
		 lb_flag_ret = TRUE
		 ldc_imp_sol_ret   = dw_2.object.monto_ret [ll_inicio]
		 ldc_imp_dol_ret   = Round(dw_2.object.monto_ret [ll_inicio] / ldc_tasa_cambio,2)
		 
		 ldc_monto_soles   = ldc_monto_soles - ldc_imp_sol_ret
		 ldc_monto_dolares = ldc_monto_dolares - ldc_imp_dol_ret
	 ELSE
		 ldc_imp_sol_ret = 0.00
		 ldc_imp_dol_ret = 0.00
	 END IF
	 
	 


		  
	 /*Recupero Descripcion de Proveedor Para generar cheque*/
	 SELECT nombre       
      INTO :ls_nombre   
      FROM codigo_relacion
	  WHERE (cod_relacion = :ls_cod_relacion);
	 
	 
	 IF Isnull(ls_nombre) OR Trim(ls_nombre) = '' THEN
		 Messagebox('Aviso','Codigo Relacion '+ls_cod_relacion+' No tiene Descripción ,Verifique!')
		 lb_ret = FALSE
	 	 GOTO SALIDA			 										 	
	 END IF
	 /**/
	 
	 //matriz contable
	 SELECT matriz_cntbl
	   INTO :ls_matriz_cntbl
	   FROM concepto_financiero
	  WHERE (confin = :ls_confin) ;
	 //
	 
	 IF Isnull(ls_matriz_cntbl) OR TRIM(ls_matriz_cntbl) = '' THEN
		 Messagebox('Aviso','Concepto Financiero '+ls_confin+' No tiene Matriz Contable Verifique')
		 lb_ret = FALSE
	 	 GOTO SALIDA			 										 	
	 END IF
	 
	 IF ll_inicio <> 1 THEN
		 /*Incremento Variable para Caja Bancos*/
		 il_nro_doc = il_nro_doc + 1
		 /*Incremento Variable para Asiento Cntbl*/
		 il_nro_asiento = il_nro_asiento + 1
		 /**************************************/
	 END IF
	 

	 /*genera cheque*/
	 IF wf_genera_cheque(ls_ctabco,gs_user,ldc_monto_soles,ldc_monto_dolares ,ls_nombre,ll_reg_cheque,ll_nro_cheque,ls_cod_moneda,ls_soles) = FALSE THEN
		 lb_ret = FALSE
		 GOTO SALIDA
	 END IF
	 
	 
	 /*****************/
	 /*Datos de Origen*/
	 /*****************/
	 ls_origen_doc = dw_2.object.origen_doc [ll_inicio]
	 
	 IF ls_origen_doc = 'D' THEN //doc pendientes cta cte
		 ls_flag_tabla = '2'
	 ELSEIF ls_origen_doc = 'C' THEN //cuentas x pagar
		 ls_flag_tabla = '2'
	 END IF	
	 
	 //se genera asiento cabecera
	 IF wf_insert_cab_asiento (gs_origen,ll_ano,ll_mes,ll_nro_libro,il_nro_asiento,ls_cod_moneda,&
	 									ldc_tasa_cambio,f_fecha_actual(),f_fecha_actual(),gs_user,'1','5',ls_obs) = FALSE THEN
		 lb_ret = FALSE
	 	 GOTO SALIDA			 										 
 	 END IF
	  
	  
									 
	 //se genera asiento detalle de acuerdo a origen
	 IF ls_origen_doc = 'D' THEN //DOCUMENTOS PENDIENTES 
		 
		 IF wf_insert_asiento_det_dp(gs_origen,ll_ano,ll_mes,ll_nro_libro,il_nro_asiento,&
											  ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ldc_monto_total,&
											  ldc_tasa_cambio,ls_cnta_ctbl,ls_des_cta_bco,ls_ctabco,&
											  Trim(String(ll_nro_cheque)),ls_flag_ret,ldc_imp_sol_ret,ldc_imp_dol_ret,&
											  ldc_monto_soles,ldc_monto_dolares) = FALSE THEN
			 lb_ret = FALSE
			 GOTO SALIDA
		 END IF
		 
	 ELSE //generacion de asientos de acuerdo a concepto financiero
		
		IF wf_generacion_cntas_x_cf(ls_matriz_cntbl,gs_origen,ll_ano,ll_mes,ll_nro_libro,il_nro_asiento,&
										   ldc_tasa_cambio,ls_cod_moneda,ll_inicio,ls_ctabco,ls_cod_relacion,ls_tipo_doc,&
											ls_nro_doc,ls_cnta_ctbl,ls_des_cta_bco,ls_ctabco,&
										   Trim(String(ll_nro_cheque)),ls_obs) = FALSE THEN
			lb_ret = FALSE
		   GOTO SALIDA
		END IF
		
	 END IF
	 
	 /*actualiza cabecera de asiento*/		 	 
	 IF wf_actualiza_cab_asiento (gs_origen,ll_ano,ll_mes,ll_nro_libro,il_nro_asiento) = FALSE THEN
		 lb_ret =FALSE
 		 GOTO SALIDA
	 END IF
	 
	 /*INSERTA DATOS EN CABECERA DE CAJA BANCOS*/
	 IF wf_insert_caja_bancos (gs_origen      ,il_nro_doc,'1', f_fecha_actual(),'C'      ,ls_cod_moneda,&
			   		 				ls_cod_relacion,ldc_tasa_cambio,ldc_monto_soles,ldc_monto_dolares ,ls_ctabco,ll_reg_cheque,&
									   ll_ano,ll_mes,ll_nro_libro,il_nro_asiento,ls_flag_tabla,Trim(String(ll_nro_cheque)),ls_soles,&
										ls_confin,ls_obs) = FALSE THEN
		 lb_ret =FALSE
 		 GOTO SALIDA								
	 END IF
	 
	 /*INSERTA DATOS EN DETALLE DE CAJA BANCOS*/	 
	 IF wf_insert_caja_bancos_det (gs_origen,il_nro_doc,ls_cod_relacion,ls_tipo_doc,ls_nro_doc,&
	                               ldc_monto_total,ls_flag_ret,ldc_imp_sol_ret,ls_flag_tabor,ls_confin,ls_origen,&
											 ls_cod_moneda,'D',1) = FALSE THEN
		 lb_ret = FALSE
		 GOTO SALIDA
	 END IF	 
	 
	 
	 
	 
	 /******************************************/
	 /*Inserción de Tabla Temporal para Reporte*/
	 /******************************************/
	 Insert Into tt_fin_rpt_gen_ch
	 (cod_relacion ,tipo_doc ,nro_doc     ,origen    ,ano       ,
	  mes          ,nro_libro,nro_asiento ,nro_cheque,nro_reg_cb)
	 Values
	 (:ls_cod_relacion,:ls_tipo_doc ,:ls_nro_doc     ,:gs_origen    ,:ll_ano    ,
	  :ll_mes		,:ll_nro_libro   ,:il_nro_asiento ,:ll_nro_cheque,:il_nro_doc);
	  
	  
	 IF SQLCA.SQLCode = -1 THEN 
		 MessageBox('Error de Inserción en tt_fin_rpt_gen_ch', SQLCA.SQLErrText)
		 lb_ret = FALSE
		 GOTO SALIDA
	 END IF 

	 
	 
	 
	 /*incrementa valor para actualizar numerador de comprobante de retencion*/
 	 IF ls_flag_ret = '1' THEN
		
		 /******************************************/
		 /* Insercion de Comprobante de Retencion	 */	
	 	 /******************************************/
		 /*Replicacion*/ 
	 	 INSERT INTO retencion_igv_crt
       (nro_certificado,fecha_emision,origen,nro_reg_caja_ban,
        proveedor      ,flag_estado  ,flag_replicacion)  
	    VALUES
		 (:is_nro_ret     ,:ldt_fecha_actual,:gs_origen,:il_nro_doc,
		  :ls_cod_relacion,'1'              ,'1')  ;
		 
		 
		 IF SQLCA.SQLCode = -1 THEN 
		 	 MessageBox('Error de Inserción en retencion_igv_crt', SQLCA.SQLErrText)
		 	 lb_ret = FALSE
		 	 GOTO SALIDA
	 	 END IF 

		
		 /*Incremento Variable de comprobante de retencion*/
		
		 
		 ll_corr_cr = Long(Mid(is_nro_ret,ll_digitos_serie + 2,ll_digitos_numero)) + 1 
		 is_nro_ret = f_llena_caracteres('0',Trim(String(ll_nro_serie_cr)),ll_digitos_serie)+'-'+ f_llena_caracteres('0',Trim(String(ll_corr_cr)),ll_digitos_numero)		 
		 
		 
		 
	 END IF

	 
NEXT

/********************************/



SALIDA:
IF lb_ret = FALSE THEN
	SetNull(il_nro_doc)
	SetNull(il_nro_asiento)		
	SetNull(is_nro_ret)		
	Rollback ;
ELSE
	IF lb_flag_ret THEN
		/*ACTUALIZA CORRELATIVO DE RETENCION*/
   	UPDATE num_doc_tipo
	      SET ultimo_numero = :ll_corr_cr
	    WHERE ((tipo_doc  = :ls_tipo_doc_ret   )) AND
		        (nro_serie = :ll_nro_serie_cr ) ;
	END IF
	
	il_nro_asiento = il_nro_asiento + 1
	/*actualiza numerador de asiento x origen,libro,año,mes*/
	UPDATE cntbl_libro_mes
		SET nro_asiento = :il_nro_asiento
	 WHERE ((origen	 = :gs_origen    ) AND
	 		  (nro_libro = :ll_nro_libro ) AND
			  (ano		 = :ll_ano		  ) AND    
			  (mes 		 = :ll_mes       )) ;
	
	il_nro_doc = il_nro_doc + 1
	/*actualiza numerador de caja bancos*/
	UPDATE num_caja_bancos
	   SET ult_nro = :il_nro_doc
	 WHERE (origen = :gs_origen);
	
	/**/
	OpenSheet(w_fi707_rpt_doc_generados_masivos, Parent, 2, Original!)
	/**/
	
	/*Confirmación de Grabación*/
	Commit ;
	
	/*Eliminación de Docuemtos Generados*/
	DO WHILE dw_2.Rowcount() > 0
		dw_2.Deleterow(0)
	LOOP
	

	
END IF


end event

type cb_2 from commandbutton within w_fi331_generacion_cheques_masivos
integer x = 2921
integer y = 168
integer width = 521
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Verificar Retención"
end type

event clicked;Long   ll_inicio,ll_count
String ls_origen_doc,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_cod_moneda,&
		 ls_soles,ls_flag_retencion,ls_dolares
Decimal 		ldc_tasa_cambio, ldc_total_pagar,ldc_imp_pagar,ldc_imp_ret_igv,ldc_porc_ret_igv,&
				ldc_monto_ret
Datetime    ldt_fecha_emision

ldc_tasa_cambio = gnvo_app.of_tasa_cambio()
ls_cod_moneda   = dw_master.object.moneda [1]

f_monedas(ls_soles,ls_dolares)

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.00 THEN
	Return
END IF
	

SELECT flag_retencion,imp_min_ret_igv,porc_ret_igv
  INTO :ls_flag_retencion,:ldc_imp_ret_igv,:ldc_porc_ret_igv
  FROM finparam
 WHERE (reckey = '1');


FOR ll_inicio = 1 TO dw_2.Rowcount() 
	 ls_origen_doc   = dw_2.object.origen_doc   [ll_inicio]
	 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
    ls_tipo_doc	  = dw_2.object.tipo_doc     [ll_inicio]
	 ls_nro_doc	     = dw_2.object.nro_doc      [ll_inicio]
	 ldc_imp_pagar	  = dw_2.object.importe      [ll_inicio]
	 
	 IF ls_origen_doc = 'D' THEN /*DOC PENDIENTES*/
		 SELECT Count(*)
		   INTO :ll_count
		   FROM doc_grupo_relacion
		  WHERE ((grupo    = '07'         ) AND
		  			(tipo_doc = :ls_tipo_doc )) 	;
					  
		  IF ll_count > 0 THEN /*DOCUMENTO DE RETENCION*/
		  	  /*VERIFICAR IMPUESTO*/	
			  SELECT Count(*)
				 INTO :ll_count
				 FROM cp_doc_det_imp
			   WHERE ((cod_relacion  = :ls_cod_relacion ) AND  
         			 (tipo_doc      = :ls_tipo_doc ) AND  
			          (nro_doc       = :ls_nro_doc )) AND  
			          (tipo_impuesto = (SELECT cod_igv FROM logparam WHERE reckey = '1') );

				
			  IF ll_count > 0 THEN
			     SELECT fecha_emision ,importe_doc 
				    INTO :ldt_fecha_emision,:ldc_total_pagar
				    FROM cntas_pagar
				   WHERE ((cod_relacion = :ls_cod_relacion ) AND  
         				 (tipo_doc     = :ls_tipo_doc     ) AND  
         				 (nro_doc      = :ls_nro_doc      )) ;
					
					 IF ls_cod_moneda <> ls_soles THEN
						 ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
						 ldc_total_pagar = Round(ldc_total_pagar * ldc_tasa_cambio,2) 
					 END IF
					 
				 IF String(ldt_fecha_emision,'yyyymmdd') > '20020531' THEN /*DOCUMENTO A RETENER X FECHA DE ALCANCE*/
					 IF ldc_total_pagar > ldc_imp_ret_igv THEN //*SE RETIENE*//
					    
						 ldc_monto_ret = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
						 dw_2.object.flag_ret  [ll_inicio] = '1'
						 dw_2.object.monto_ret [ll_inicio] = ldc_monto_ret
					 END IF
					 
				 END IF
				 
			  END IF
		  END IF
	 END IF
NEXT	
	
end event

