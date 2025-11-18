$PBExportHeader$w_fi310_cartera_de_pagos.srw
forward
global type w_fi310_cartera_de_pagos from w_abc
end type
type cb_rcem from commandbutton within w_fi310_cartera_de_pagos
end type
type st_dif from statictext within w_fi310_cartera_de_pagos
end type
type em_dif from editmask within w_fi310_cartera_de_pagos
end type
type dw_report from datawindow within w_fi310_cartera_de_pagos
end type
type cb_gen_tlc from commandbutton within w_fi310_cartera_de_pagos
end type
type sle_1 from singlelineedit within w_fi310_cartera_de_pagos
end type
type cbx_ts from checkbox within w_fi310_cartera_de_pagos
end type
type dw_rpt from datawindow within w_fi310_cartera_de_pagos
end type
type rb_cv from radiobutton within w_fi310_cartera_de_pagos
end type
type rb_v from radiobutton within w_fi310_cartera_de_pagos
end type
type rb_cr from radiobutton within w_fi310_cartera_de_pagos
end type
type cb_genera_cheque from commandbutton within w_fi310_cartera_de_pagos
end type
type cb_retenciones from commandbutton within w_fi310_cartera_de_pagos
end type
type cbx_ref from checkbox within w_fi310_cartera_de_pagos
end type
type tab_1 from tab within w_fi310_cartera_de_pagos
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
type tab_1 from tab within w_fi310_cartera_de_pagos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_1 from commandbutton within w_fi310_cartera_de_pagos
end type
type gb_1 from groupbox within w_fi310_cartera_de_pagos
end type
type gb_2 from groupbox within w_fi310_cartera_de_pagos
end type
type dw_master from u_dw_abc within w_fi310_cartera_de_pagos
end type
end forward

global type w_fi310_cartera_de_pagos from w_abc
integer width = 4617
integer height = 2412
string title = "Cartera de Pagos (FI310)"
string menuname = "m_mantenimiento_cl_tes_anular"
event ue_anular ( )
event ue_print_preview ( )
cb_rcem cb_rcem
st_dif st_dif
em_dif em_dif
dw_report dw_report
cb_gen_tlc cb_gen_tlc
sle_1 sle_1
cbx_ts cbx_ts
dw_rpt dw_rpt
rb_cv rb_cv
rb_v rb_v
rb_cr rb_cr
cb_genera_cheque cb_genera_cheque
cb_retenciones cb_retenciones
cbx_ref cbx_ref
tab_1 tab_1
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
dw_master dw_master
end type
global w_fi310_cartera_de_pagos w_fi310_cartera_de_pagos

type variables
Boolean 			ib_estado_asiento = TRUE, ib_cierre = false
u_dw_abc			idw_detail, idw_asiento_cab, idw_asiento_det

n_cst_asiento_contable 	invo_asiento_contable
n_cst_caja_bancos			invo_caja_bancos
n_cst_cri					invo_cri
u_ds_base 					ids_asiento_adic, ids_crelacion_ext_tbl
		
end variables

forward prototypes
public subroutine wf_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio)
public subroutine wf_verificacion_items_x_retencion ()
public subroutine wf_verificacion_retencion ()
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado)
public function boolean wf_insert_referencia (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_referencia)
public function boolean wf_update_deuda_financiera ()
public subroutine wf_post_update ()
public subroutine of_asigna_dws ()
public function boolean of_retrieve (string as_origen, long al_nro_registro)
public function decimal of_recalcular_monto_det ()
public function decimal of_recalcular_ret_igv ()
public function integer of_get_param ()
public function boolean of_padron_sunat ()
public function boolean of_generar_asiento ()
end prototypes

event ue_anular;Integer 	li_opcion

String  	ls_flag_estado ,ls_origen_cb  ,ls_result     ,ls_mensaje ,ls_nro_programa, ls_nro_og

Long    	ll_row_master  ,ll_nro_reg_cb ,ll_nro_reg_ch ,ll_ano	 ,&
		  	ll_mes			,ll_inicio	  ,ll_count	 	  ,ll_i

if dw_master.getRow() = 0 then return

if ib_cierre then 
	Messagebox('Aviso','No se puede anular el voucher, el PERIODO CONTABLE esta CERRADO, coordinar con contabilidad', StopSign!)
	return
end if

ll_row_master  = dw_master.getrow()

ls_flag_estado 	= dw_master.Object.flag_estado  	[ll_row_master]
ll_ano				= dw_master.object.ano 			[ll_row_master]
ll_mes			= dw_master.object.mes			[ll_row_master]

IF ls_flag_estado <> '1' THEN
	gnvo_app.of_message_error('Cartera de Pagos se encuentra ANULADO, no se puede completar la operacion.')
	Return
END IF

/*verifica cierre*/
invo_asiento_contable.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	Return
END IF


//programa de pagos
select Count(*) 
  into :ll_count
  from programacion_pagos_det
 where (origen_caja  = :ls_origen_cb  ) AND  
       (nro_reg_caja = :ll_nro_reg_cb )   ;
		 
if ll_count > 0 then
	select nro_prog_pago into :ls_nro_programa
	  from programacion_pagos_det
	 where (origen_caja  = :ls_origen_cb  ) AND  
   	    (nro_reg_caja = :ll_nro_reg_cb )   ;
	
	
	gnvo_app.of_message_error('No se puede Anular Registro esta Vinculado a Programa de Pago Nº '+ls_nro_programa)
	Return
end if

//Si hay una orden de Giro en el detalle de la cartera de pagos y la misma esta liquidada no debería 
//permitir anular la operacion
for ll_i =1 to idw_detail.RowCount()
	if idw_detail.object.tipo_doc	[ll_i] = gnvo_app.is_doc_og then
		ls_nro_og = idw_detail.object.nro_doc [ll_i]
		
		select Count(*) 
		  into :ll_count
		  from solicitud_giro_liq_det
		 where nro_solicitud  = :ls_nro_og;
		
		if ll_count > 0 then
			gnvo_app.of_message_error('La Orden de Giro ' + ls_nro_og + ' esta liquidada por lo que no se puede anular esta cartera de pagos. Por favor verifique!' )
			Return
		end if
		
	end if
next
		 

//*************************************************************************//
//*Si hay actualizacion pendientes por grabar, entonces no se puede anular*//
//*************************************************************************//
IF (dw_master.ii_update = 1       OR idw_detail.ii_update      = 1 OR &
    idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1) THEN
	 gnvo_app.of_message_error('Por favor grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF	 

//------------------------------------------------
li_opcion = MessageBox('Anula Cartera de Pagos','Esta Seguro de Anular este Documento',Question!, YesNo!, 2)

IF li_opcion = 2 THEN RETURN

dw_master.object.flag_estado 	[ll_row_master] = '0'
dw_master.object.imp_total   	[ll_row_master] = 0.00

DO WHILE idw_detail.Rowcount() > 0 
	idw_detail.DeleteRow(0)
LOOP

//Anulo el asiento
if idw_asiento_cab.RowCount() > 0 then
	idw_asiento_cab.object.flag_estado[idw_asiento_cab.getRow()] = '0'
end if
FOR ll_inicio =1 TO idw_asiento_det.Rowcount() 
	 idw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 idw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT

//Indico todo para actualizar
idw_asiento_cab.ii_update = 1
idw_asiento_det.ii_update = 1
dw_master.ii_update = 1
idw_detail.ii_update = 1

//Bloqueo todos los paneles
dw_master.ii_protect = 0
dw_master.of_protect()	

idw_detail.ii_protect = 0
idw_detail.of_protect()	

idw_asiento_det.ii_protect = 0
idw_asiento_det.of_protect()	
	
is_action = 'anular'

/*No  Generación de Pre Asientos*/
ib_estado_asiento = FALSE
/**/
end event

event ue_print_preview();String      ls_origen
Long			ll_nro_registro, ll_row
str_parametros	lstr_param

ll_row = dw_master.getRow()
if ll_row = 0 then return

//////Verificacion de Nro de Orden
ls_origen	    = dw_master.object.origen       [ll_row]
ll_nro_registro = dw_master.object.nro_registro [ll_row]	

lstr_param.dw1 		= 'd_rpt_formato_chq_voucher_preview'
lstr_param.titulo 	= 'Previo de Voucher'
lstr_param.string1 	= ls_origen
lstr_param.long1 		= ll_nro_registro
lstr_param.titulo		= 'CARTERA DE PAGOS'
lstr_param.tipo		= '1S1L'

OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)

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
String ls_cod_relacion,ls_expresion     ,ls_tipo_doc     ,ls_cadena  , &
		 ls_flag_retencion,ls_flag_ret_igv ,ls_nro_doc ,ls_cod_moneda,&
		 ls_flag_impuesto,ls_doc_gr_ret
Decimal	ldc_imp_min_ret_igv,ldc_porc_ret_igv   ,ldc_imp_pagar    ,ldc_total_pagar,&
				ldc_imp_total      ,ldc_imp_total_pagar,ldc_imp_retencion
Decimal {4} ldc_tasa_cambio
Boolean     lb_flag = FALSE
Datetime		ldt_fecha_emision
Datetime	   ldt_fec_ret_igv

dw_master.accepttext()
idw_detail.accepttext()

/**/
ldc_tasa_cambio  = dw_master.object.tasa_cambio  [dw_master.Getrow()]


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
	 
		        IF ls_cod_moneda <> gnvo_app.is_soles THEN 
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
				  ls_cod_moneda 	 = idw_detail.object.cod_moneda    [ll_inicio_det]
				  
		 		  IF ls_flag_impuesto = '1' THEN
 	
			 		  IF ls_cod_moneda <> gnvo_app.is_soles THEN 
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
				  ls_cod_moneda 	 = idw_detail.object.cod_moneda    [ll_inicio_det]
 
				  IF ls_flag_impuesto = '1' THEN

					  IF ls_cod_moneda <> gnvo_app.is_soles THEN 
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
select cod_origen 
	into :ls_origen_ov 
from orden_venta 
where nro_ov = :as_referencia ;

Insert Into doc_referencias(
	cod_relacion ,tipo_doc ,nro_doc ,tipo_mov ,origen_ref ,tipo_ref ,nro_ref)
 Values (
 	:as_cod_relacion ,:as_tipo_doc ,:as_nro_doc ,'R',:ls_origen_ov ,:gnvo_app.is_doc_ov,:as_referencia ) ;
			 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error',ls_msj_err)
   lb_ret = false
END IF

Return lb_ret
end function

public function boolean wf_update_deuda_financiera ();Long   ll_inicio,ll_nro_reg,ll_item
String ls_origen,ls_tipo_doc,ls_nro_doc, ls_mensaje
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
	DECLARE USP_FIN_UPD_CUOTAS_DEUDA_FIN PROCEDURE FOR 
	 	USP_FIN_UPD_CUOTAS_DEUDA_FIN(	:ls_origen,
		 										:ll_nro_reg,
												:ll_item,
												:ls_tipo_doc,
												:ls_nro_doc,
												:ldc_monto_real);
	 EXECUTE USP_FIN_UPD_CUOTAS_DEUDA_FIN ;

	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('SQL error', "Error en procedure USP_FIN_UPD_CUOTAS_DEUDA_FIN: " + ls_mensaje)
		return false
	end if
	
	CLOSE USP_FIN_UPD_CUOTAS_DEUDA_FIN;
Next	


Return lb_ret
end function

public subroutine wf_post_update ();Long   ll_inicio,ll_row_master
String ls_null,ls_flag_provisionado


ll_row_master = dw_master.getrow()

/*Elimina Informacion de Tabla Temporal*/
delete from tt_fin_deuda_financiera ;

/*No Genera Asientos */
ib_estado_asiento = FALSE
		

/* actualiza valores flag detalle */
for ll_inicio = 1 to idw_detail.Rowcount()
	 idw_detail.object.flag_doc [ll_inicio] = ls_null
	 
	 ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
	 
	 IF ls_flag_provisionado = 'N' THEN
		 idw_detail.object.flag_partida [ll_inicio] = '1'
	 END IF

next

/*setear flag de retencion*/
//SetNull(ls_flag_retencion)
//dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
end subroutine

public subroutine of_asigna_dws ();idw_detail 			= tab_1.tabpage_1.dw_detail
idw_asiento_cab 	= tab_1.tabpage_2.dw_asiento_cab
idw_asiento_det 	= tab_1.tabpage_2.dw_asiento_det
end subroutine

public function boolean of_retrieve (string as_origen, long al_nro_registro);String 	ls_origen, ls_Null, ls_moneda_cab, ls_cta_ctbl, ls_flag_provisionado, &
			ls_cod_relacion, ls_tipo_doc, ls_nro_doc, ls_flag_tabla, ls_doc_og, &
			ls_flag_ctrl_reg, ls_expresion
			
Long		ll_year, ll_mes, ll_nro_libro, ll_nro_asiento, ll_inicio, ll_factor, &
			ll_count, ll_found
Decimal	ldc_tasa_cambio

SetNull(ls_null)
select doc_sol_giro 
	into :ls_doc_og 
from finparam 
where reckey = '1' ;

of_asigna_dws()

dw_master.Retrieve(as_origen, al_nro_registro,'2')

if dw_master.getRow() = 0 then return false

//Obtengo los datos para recuperar el asiento contable
ls_origen 		= dw_master.object.origen 		[dw_master.getRow()]
ll_year 			= Long(dw_master.object.ano 	[dw_master.getRow()])
ll_mes 			= Long(dw_master.object.mes 	[dw_master.getRow()])
ll_nro_libro 	= Long(dw_master.object.nro_libro [dw_master.getRow()])
ll_nro_asiento = Long(dw_master.object.nro_asiento [dw_master.getRow()])

//Verifico Cierre contable
if invo_asiento_contable.of_mes_cerrado( ll_year, ll_mes, "B") then
	ib_cierre = true
	dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	dw_master.object.t_cierre.text = ''
	ib_cierre = false
end if

//REcupero el detalle del comprobante
idw_detail.retrieve(as_origen, al_nro_registro)
idw_asiento_cab.retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)
idw_asiento_det.retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)

//Limpio los flags
dw_master.ResetUpdate()
idw_detail.ResetUpdate()
idw_asiento_cab.ResetUpdate()
idw_asiento_det.resetUpdate()

dw_master.ii_update = 0
idw_detail.ii_update = 0
idw_asiento_cab.ii_update = 0
idw_asiento_det.ii_update = 0


//Lo hago no editable
dw_master.ii_protect = 0
idw_detail.ii_protect = 0
idw_asiento_cab.ii_protect = 0
idw_asiento_det.ii_protect = 0

dw_master.of_protect()
idw_detail.of_protect()
idw_asiento_cab.of_protect()
idw_asiento_det.of_protect()

/*Elimina Informacion de Tabla Temporal*/
delete from tt_fin_deuda_financiera ;
	
/*asociacion de moneda de cabecera*/
ls_moneda_cab   = dw_master.object.cod_moneda  [dw_master.getrow()]
ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
ls_cta_ctbl		 = dw_master.object.cnta_ctbl   [dw_master.getrow()]
		
For ll_inicio = 1 to idw_detail.Rowcount()
	idw_detail.object.cod_moneda_cab [ll_inicio] = ls_moneda_cab
	idw_detail.object.tasa_cambio    [ll_inicio] = ldc_tasa_cambio
			 
	ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
	ls_cod_relacion		= idw_detail.object.cod_relacion		[ll_inicio]
	ls_tipo_doc			 	= idw_detail.object.tipo_doc				[ll_inicio]
	ls_nro_doc				= idw_detail.object.nro_doc       		[ll_inicio]
	ll_factor				= idw_detail.object.factor       		[ll_inicio]
	ls_flag_tabla			= idw_detail.object.flab_tabor    		[ll_inicio]
			 
	IF ls_flag_provisionado = 'N' THEN
		//*ingresos indirectos PARTIDA EDITABLE*//
		idw_detail.object.flag_partida [ll_inicio] = '1'
				 
		//habiltar ingresos indirectos
	 	//cbx_ref.checked = TRUE
	END IF
			 
	//verificar condiciones de documentos
	IF ls_tipo_doc = ls_doc_og THEN
		idw_detail.object.t_tipdoc [ll_inicio] = ls_null
	ELSE
		//verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
	   select count(*) 
			into :ll_count 
		from doc_grupo_relacion dg 
		where dg.grupo    = 'C2'         
		  and dg.tipo_doc = :ls_tipo_doc;
			 
		if (ll_count > 0 AND ls_flag_provisionado = 'D' AND ll_factor = 1 AND ls_flag_tabla = '3') then
			select cp.flag_control_reg 
				into :ls_flag_ctrl_reg
			from cntas_pagar cp
			where cp.cod_relacion = :ls_cod_relacion
			  and cp.tipo_doc     = :ls_tipo_doc    
			  and cp.nro_doc      = :ls_nro_doc;
			 	 
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

	
ls_expresion = "cnta_ctbl = '" +ls_cta_ctbl + "'"
//flag de doc editable en cuenta de banco..
ll_found = idw_asiento_det.Find(ls_expresion,1,idw_asiento_det.Rowcount())
	
IF ll_found > 0 THEN //ENCONTRO CUENTA CONTABLE DE BANCO
	idw_asiento_det.object.flag_doc_edit [ll_found] = ls_null
END IF

IF dw_master.object.tipo_doc[dw_master.getRow()] = 'TLC ' then
	cb_gen_tlc.enabled = true
ELSE
	cb_gen_tlc.enabled = false
END IF

if dw_master.getRow() > 0 and dw_master.object.flag_pago[dw_master.getRow()] = 'C' then
	if Long(dw_master.object.nro_cheque [dw_master.getRow()]) = 0 or IsNull(dw_master.object.nro_cheque [dw_master.getRow()]) then
		cb_genera_cheque.enabled = true
	else
		cb_genera_cheque.enabled = false
	end if
else
	cb_genera_cheque.enabled = false
end if

is_action = 'fileopen'
ib_estado_asiento = FALSE

return true
end function

public function decimal of_recalcular_monto_det ();String ls_moneda_ref,ls_moneda_cab
Long   ll_inicio,ll_factor
Decimal ldc_importe_total,ldc_importe_ref,ldc_importe_ret
Decimal {4} ldc_tasa_cambio


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

public function decimal of_recalcular_ret_igv ();String ls_moneda_ref,ls_moneda_cab
Long   ll_inicio,ll_factor
Decimal ldc_importe_ret, ldc_tasa_cambio, ldc_importe_total


dw_master.Accepttext()
idw_detail.Accepttext()

ldc_importe_ret	= 0.00
ldc_importe_total	= 0.00

For ll_inicio = 1 to idw_detail.Rowcount()
	 ldc_importe_ret = idw_detail.object.impt_ret_igv   [ll_inicio]	 	 
	 ls_moneda_ref	  = idw_detail.object.cod_moneda     [ll_inicio]
 	 ll_factor       = idw_detail.object.factor	       [ll_inicio]
	 ls_moneda_cab   = idw_detail.object.cod_moneda_cab [ll_inicio]
	 ldc_tasa_cambio = idw_detail.object.tasa_cambio    [ll_inicio]
	 
	 IF Isnull(ldc_importe_ret) THEN ldc_importe_ret = 0.00
	 
	 ldc_importe_total += ldc_importe_ret * ll_factor
	 
Next


Return ldc_importe_total
end function

public function integer of_get_param ();if gnvo_app.is_agente_ret = '0' then
	cb_retenciones.enabled = false
end if

return 1
end function

public function boolean of_padron_sunat ();Str_parametros	lstr_param

if dw_master.RowCount() = 0 then return false

lstr_param.string1 = dw_master.object.flag_padron_sunat [1]

OpenWithParm(w_datos_sunat, lstr_param)

if IsNull(Message.PowerObjectparm) or not IsValid(Message.Powerobjectparm) then return false

lstr_param = Message.PowerObjectparm
if not lstr_param.b_return then return false

dw_master.object.flag_padron_sunat [1] = lstr_param.string1
dw_master.ii_update = 1

end function

public function boolean of_generar_asiento ();Boolean lb_ret = TRUE
/*generacion de cntas*/

of_asigna_dws()

IF invo_asiento_contable.of_generar_asiento_cb (	dw_master        	, &
																	idw_detail 			, &
																	idw_asiento_cab	, &
								  									idw_asiento_det  	, &
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
END IF	



Return lb_ret
end function

on w_fi310_cartera_de_pagos.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_tes_anular" then this.MenuID = create m_mantenimiento_cl_tes_anular
this.cb_rcem=create cb_rcem
this.st_dif=create st_dif
this.em_dif=create em_dif
this.dw_report=create dw_report
this.cb_gen_tlc=create cb_gen_tlc
this.sle_1=create sle_1
this.cbx_ts=create cbx_ts
this.dw_rpt=create dw_rpt
this.rb_cv=create rb_cv
this.rb_v=create rb_v
this.rb_cr=create rb_cr
this.cb_genera_cheque=create cb_genera_cheque
this.cb_retenciones=create cb_retenciones
this.cbx_ref=create cbx_ref
this.tab_1=create tab_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_rcem
this.Control[iCurrent+2]=this.st_dif
this.Control[iCurrent+3]=this.em_dif
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.cb_gen_tlc
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.cbx_ts
this.Control[iCurrent+8]=this.dw_rpt
this.Control[iCurrent+9]=this.rb_cv
this.Control[iCurrent+10]=this.rb_v
this.Control[iCurrent+11]=this.rb_cr
this.Control[iCurrent+12]=this.cb_genera_cheque
this.Control[iCurrent+13]=this.cb_retenciones
this.Control[iCurrent+14]=this.cbx_ref
this.Control[iCurrent+15]=this.tab_1
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.dw_master
end on

on w_fi310_cartera_de_pagos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_rcem)
destroy(this.st_dif)
destroy(this.em_dif)
destroy(this.dw_report)
destroy(this.cb_gen_tlc)
destroy(this.sle_1)
destroy(this.cbx_ts)
destroy(this.dw_rpt)
destroy(this.rb_cv)
destroy(this.rb_v)
destroy(this.rb_cr)
destroy(this.cb_genera_cheque)
destroy(this.cb_retenciones)
destroy(this.cbx_ref)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;
try 
	of_asigna_dws()
	of_get_param()
	
	dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
	
	idw_asiento_cab.SetTransObject(sqlca)
	idw_asiento_det.SetTransObject(sqlca)
	
	//El detalle cambia según el indicador
	if gnvo_app.of_get_parametro( "USE_PRSP_CAJA", '0') = '1' then
		idw_detail.DataObject = 'd_abc_cartera_pago_prsp_caja_tbl'
	else
		if gnvo_app.of_get_parametro( "USE_FLUJO_CAJA", '0') = '1' then
			idw_detail.DataObject = 'd_abc_cartera_pago_flujo_caja_tbl'
		else
			idw_detail.DataObject = 'd_abc_caja_bancos_det_cartera_pago_tbl'
		end if
	end if
	
	idw_detail.setTransObject(SQLCA)
	
	idw_1 = dw_master              				             // asignar dw corriente
	idw_detail.BorderStyle = StyleRaised!	 // indicar dw_detail como no activado
	
	//crea objeto
	invo_asiento_contable 	= create n_cst_asiento_contable
	invo_caja_bancos			= create n_cst_caja_bancos
	invo_cri						= create n_cst_cri
	
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
	gnvo_app.of_message_error('Ha ocurrido una excepcion: ' + ex.getMessage() + ', por favor verifique!')
end try






end event

event ue_insert;call super::ue_insert;Long   	ll_row
String 	ls_cod_moneda
Decimal 	ldc_tasa_cambio

IF idw_1 = idw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

if idw_1 <> dw_master then
	if ib_cierre then 
		Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
		return
	end if
end if

IF idw_1 = idw_asiento_det THEN RETURN

IF idw_1 = idw_detail THEN
	IF cbx_ref.checked = FALSE THEN //SIN REFERENCIA
		Messagebox('Aviso','No Puede Ingresar Documento sin referencia, por favor verififque que la opción se encuentre marcada')
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
   
   /*Generacion de Asientos*/
	ib_estado_asiento = true		
	dw_master.il_row = dw_master.Getrow()
ELSE
	triggerevent('ue_update_request')
	IF ib_update_check = False THEN RETURN
	
	//cabecera
	is_action = 'new'
	dw_master.Reset()
	idw_detail.Reset()
	idw_asiento_cab.Reset()
	idw_asiento_det.Reset()
	
	/*Elimina Informacion de Tabla Temporal*/
	delete from tt_fin_deuda_financiera ;
	
	/*Genera Asientos */
	ib_estado_asiento = TRUE	
	
	/*ACTIVO VERIFICACION DE RETENCIONES*/
	if gnvo_app.is_agente_ret = '1' then cb_retenciones.Enabled = TRUE
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

event ue_update_pre;call super::ue_update_pre;Long   ll_ano,ll_mes,ll_nro_registro,ll_inicio,ll_found,ll_ins_new,ll_item,ll_nro_libro,&
		 ll_nro_asiento,ll_found_cri
String ls_result    ,ls_mensaje      ,ls_cod_origen ,ls_flag_retencion    ,ls_flag_estado ,&
		 ls_expresion ,ls_cod_relacion ,ls_nro_cri    ,ls_tipo_doc          ,ls_nro_doc	       ,ls_cod_moneda  ,&
		 ls_cod_usr   ,ls_cencos		 ,ls_cnta_prsp  ,ls_flag_provisionado ,ls_flag_referencia ,ls_referencia  ,&
		 ls_expresion_cri, ls_desc_glosa, ls_serie_cri
		 
		 
Decimal 		ldc_importe_total, ldc_totsoldeb, ldc_totdoldeb, ldc_totsolhab, ldc_totdolhab, &
				ldc_imp_cri, ldc_tasa_cambio
Datetime    ldt_fecha_cntbl
dwItemStatus ldis_status

Boolean	lb_retorno

try
	ib_update_check = false
		
	IF dw_master.Rowcount() = 0 THEN
		gnvo_app.of_message_error('Debe Ingresar Registro en la Cabecera, por favor verifique!')
		dw_master.Setfocus()
		Return
	END IF

	//Si el registro esta para anular entonces simplemente lo grabo nada mas
	if is_action ='anular' then 
		//Liberar el CRI
		invo_cri.of_liberar_cri( dw_master )
		
		//Eliminar la deuda financiera
		if not gnvo_app.finparam.of_eliminina_deuda_financiera( dw_master ) then return

		//Eliminar el cheque
		if not gnvo_app.finparam.of_elimina_cheque( dw_master ) then return		
		
		//Si todo salio bien entonces simplemente retorno ok
		ib_update_check = true
		return
	end if

	//Si no existe detalle entonces no puedo avanzar con la grabación
	IF idw_detail.Rowcount() = 0  THEN
		ROLLBACK;
		gnvo_app.of_mensaje_error('Debe Ingresar Registro en el Detalle , Verifique!')
		Return
	END IF
	
	// Valido si tiene o no Cobranza coactiva antes de siquiera hacer la grabación
	if gnvo_app.finparam.is_flag_embargo_tele = '1' then
		if not gnvo_app.finparam.of_validar_coba(dw_master, idw_detail) then
			ROLLBACK;
			return
		end if
	else
		if not gnvo_app.finparam.of_validar_rcem(dw_master, idw_detail) then
			ROLLBACK;
			return
		end if
	end if
	
	/*datos de cabecera*/
	ll_ano            = dw_master.object.ano            [dw_master.getrow()]
	ll_mes            = dw_master.object.mes            [dw_master.getrow()]
	ll_nro_libro		= dw_master.object.nro_libro      [dw_master.getrow()]
	ll_nro_asiento		= dw_master.object.nro_asiento    [dw_master.getrow()]
	ls_cod_origen     = dw_master.object.origen		  	 [dw_master.getrow()]				 
	ll_nro_registro   = dw_master.object.nro_registro	 [dw_master.getrow()]				 
	ls_flag_retencion = dw_master.object.flag_retencion [dw_master.getrow()]
	ls_serie_cri		= dw_master.object.serie_cri		 [dw_master.getrow()]
	ls_nro_cri			= dw_master.object.nro_certificado[dw_master.getrow()]
	ls_flag_estado		= dw_master.object.flag_estado    [dw_master.getrow()]
	ldc_importe_total	= dw_master.object.imp_total	    [dw_master.getrow()]
	ldt_fecha_cntbl	= dw_master.object.fecha_emision  [dw_master.getrow()]
	ls_cod_moneda		= dw_master.object.cod_moneda     [dw_master.getrow()]
	ldc_tasa_cambio	= dw_master.object.tasa_cambio	 [dw_master.getrow()]
	ls_cod_usr			= dw_master.object.cod_usr 	 	 [dw_master.getrow()]
	ls_flag_estado	   = dw_master.object.flag_estado    [dw_master.getrow()]
	ls_desc_glosa	   = dw_master.object.obs    			 [dw_master.getrow()]
	
	
	/*verifica cierre de movimientos bancarios*/
	if not invo_asiento_contable.of_val_mes_cntbl(ll_ano,ll_mes,'B') then
		ROLLBACK;
		Return	
	END IF
	
	IF not gnvo_app.of_row_Processing( dw_master ) then return 
	IF not gnvo_app.of_row_Processing( idw_detail ) then	return 

	
	//Verifico si tiene o no flag de retencion
	ls_flag_retencion = '0'
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		if idw_detail.object.flag_ret_igv [ll_inicio] = '1' then
			ls_flag_retencion = '1'
		END IF
	NEXT
	
	if ls_flag_retencion = '1' and gnvo_app.is_agente_ret = '0' then
		Messagebox('Aviso','Usted no es agente de retención para aplicar CERTIFICADO DE RETENCIÓN, por favor verifique')
		Return	
	end if
	
	
	/*verificar tipo de serie en retenciones*/
	IF ls_flag_retencion = '1' THEN //GENERAR COMPROBANTE DE RETENCION
		IF Isnull(ls_serie_cri) OR Trim(ls_serie_cri) = '' THEN
			Messagebox('Aviso','Ingrese Serie de Comprobante de Retencion')
			Return
		END IF
	END IF	
	
	IF ls_flag_retencion = '1' THEN /*flag de retencion de cabecera*/
		
		/*eliminar informacion de tabla temporal*/
		ids_crelacion_ext_tbl.Reset()
	
		/*filtrar documentos marcados para la retencion*/
		ls_expresion = "flag_ret_igv = '1'"
		idw_detail.SetFilter(ls_expresion)
		idw_detail.Filter()
	
		//**separar los codigos de relacion**//
		ldc_imp_cri = 0
		FOR ll_inicio = 1 TO idw_detail.Rowcount()
			 ls_cod_relacion = idw_detail.object.cod_relacion [ll_inicio]
			 ls_expresion = "cod_relacion = '"+ls_cod_relacion+"'"
			 ll_found = ids_crelacion_ext_tbl.find(ls_expresion,1,ids_crelacion_ext_tbl.Rowcount())
			 IF ll_found = 0 THEN
				 ll_found = ids_crelacion_ext_tbl.InsertRow(0)
				 ids_crelacion_ext_tbl.object.cod_relacion[ll_found] = ls_cod_relacion
			 END IF
			 
			 ldc_imp_cri += Dec(idw_detail.object.impt_ret_igv [ll_inicio])
			 /**/
		NEXT
		dw_master.object.importe_cri[dw_master.getRow()] = ldc_imp_cri
	
		/*desfiltrado*/ 
		idw_detail.SetFilter('')
		idw_detail.Filter()
		
		/*ordenamiento*/
		idw_detail.SetSort('nro_item a')
		idw_detail.Sort()
		
		// Solo debe haber un solo proveedor para la retención
		if ids_crelacion_ext_tbl.RowCount() > 1 then
			ROLLBACK;
			gnvo_app.of_mensaje_error('Solo se debe hacer retención de un solo proveedor, y ha seleccionado ' + string(ids_crelacion_ext_tbl.RowCount()) &
									+ ' proveedores diferentes en este Registro de Caja, por favor verifique')
			Return
		end if
		
		
		/***generar numero para comprobantes de retencion***/
		if is_action = "new" or ls_nro_cri = '' then
			FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount() 
				//Asignación  de Nro de Serie
			 
				IF invo_cri.of_get_nro_cri(ls_serie_cri, ls_nro_cri) = FALSE THEN
					ROLLBACK;
					RETURN
				END IF		 
		
				/*ASIGNACION DE NUMERO DE C. RETENCION X C.RELACION*/
				ids_crelacion_ext_tbl.object.nro_cr 	[ll_inicio] = ls_nro_cri
				dw_master.object.nro_certificado			[dw_master.getRow()] = ls_nro_cri
				 
			NEXT
		else
			ls_nro_cri = dw_master.object.nro_certificado [dw_master.getRow()] 
			FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount() 
				/*ASIGNACION DE NUMERO DE C. RETENCION X C.RELACION*/
				ids_crelacion_ext_tbl.object.nro_cr 	[ll_inicio] = ls_nro_cri
			NEXT
		end if
		
	END IF	
	
	
	/*importe del documento > 0*/
	IF ls_flag_estado <> '0' THEN
		IF Isnull(ldc_importe_total) OR ldc_importe_total <= 0 THEN
			ROLLBACK;
			gnvo_app.of_mensaje_error('Debe Ingresar Importe del Documento')
			Return
		END IF
	END IF
	
	
	//Obtengo el numero de registro
	IF is_action = 'new' or ll_nro_registro = 0 THEN
	
		ll_nro_registro = invo_caja_bancos.of_nro_registro_cb(ls_cod_origen)
		dw_master.object.nro_registro	[dw_master.getrow()] = ll_nro_registro
			
		//verificacion de año y mes	
		IF Isnull(ll_ano) OR ll_ano = 0 THEN
			ROLLBACK;
			Messagebox('Aviso','Ingrese Año Contable , Verifique!')
			Return
		END IF
		
		IF Isnull(ll_mes) OR ll_mes = 0 THEN
			ROLLBACK;
			Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
			Return
		END IF
		
		/*generacion de asientos*/	
		IF invo_asiento_contable.of_get_nro_asiento(ls_cod_origen,ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  = FALSE THEN
			ROLLBACK;
			Return
		END IF	
		
		dw_master.object.nro_asiento 			[1] = ll_nro_asiento 
		
		//cabecera de asiento
		idw_asiento_cab.Object.origen      	[1] = ls_cod_origen
		idw_asiento_cab.Object.ano 		  	[1] = ll_ano
		idw_asiento_cab.Object.mes 		  	[1] = ll_mes
		idw_asiento_cab.Object.nro_libro   	[1] = ll_nro_libro
		idw_asiento_cab.Object.nro_asiento 	[1] = ll_nro_asiento	
	END IF
	
	
	
	//generacion de asientos automaticos
	IF ib_estado_asiento THEN
		IF of_generar_asiento () = FALSE THEN
			ROLLBACK;
			RETURN
		END IF
	END IF	
	
	//coloca CRI EN ASIENTOS
	IF ls_flag_retencion = '1' THEN /*flag de retencion de cabecera*/
		FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
			if idw_asiento_det.object.tipo_docref1 [ll_inicio] = gnvo_app.is_doc_ret then
				idw_asiento_det.object.nro_docref1 	[ll_inicio] = ls_nro_cri
			end if
		NEXT
	END IF
	
	//Detalle de Documento
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		/*validar que datos esten completos*/
		ls_cod_relacion      = idw_detail.object.cod_relacion      	[ll_inicio]
		ls_tipo_doc	       	= idw_detail.object.tipo_doc	         [ll_inicio]	
		ls_nro_doc		      = idw_detail.object.nro_doc		      [ll_inicio]	
		ls_cencos		      = idw_detail.object.cencos		      	[ll_inicio]	
		ls_cnta_prsp	  		= idw_detail.object.cnta_prsp         	[ll_inicio]	
		ls_flag_provisionado = idw_detail.object.flag_provisionado 	[ll_inicio]	 
		ls_flag_referencia   = idw_detail.object.flag_referencia   	[ll_inicio]	 	 
		ls_referencia   		= idw_detail.object.referencia   		[ll_inicio]	 	 
		ll_item			      = idw_detail.object.nro_item		      [ll_inicio]	
		 
		 
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
			ROLLBACK;
			Messagebox('Aviso','Debe Ingresar Codigo de Relacion en el Detalle ,Item : '+Trim(String(ll_item)))
			tab_1.SelectedTab = 1
			idw_detail.Setfocus()
			idw_detail.Setcolumn('cod_relacion')
			idw_detail.Setrow(ll_inicio)
			RETURN		
		END IF
		 
		IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
			ROLLBACK;
			Messagebox('Aviso','Debe Ingresar Tipo de Documento en el Detalle ,Item : '+Trim(String(ll_item)))
			tab_1.SelectedTab = 1
			idw_detail.Setfocus()
			idw_detail.Setcolumn('tipo_doc')
			idw_detail.Setrow(ll_inicio)
			RETURN		
		END IF
		 
		IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
			ROLLBACK;
			Messagebox('Aviso','Debe Ingresar Nro de Documento en el Detalle ,Item : '+Trim(String(ll_item)))
			tab_1.SelectedTab = 1
			idw_detail.Setfocus()
			idw_detail.Setcolumn('nro_doc')
			idw_detail.Setrow(ll_inicio)
			RETURN		
		END IF
		 
		 
		/*VERIFICAR SI ES REGISTRO NUEVO*/
		ldis_status = idw_detail.GetItemStatus(ll_inicio,0,Primary!)
	
		IF ldis_status = NewModified! THEN
			if (ls_flag_provisionado = 'N' AND ls_flag_referencia = '1') then //INDIRECTO CON REFERENCIA A OV
				IF Isnull(ls_referencia) OR Trim(ls_referencia) = '' THEN
					ROLLBACK;
					Messagebox('Aviso','Debe Ingresar Nro de Referencia en el Detalle ,Item : '+Trim(String(ll_item)))
					idw_detail.Setfocus()
					idw_detail.Setrow(ll_inicio)				 
					RETURN		
				ELSE
					if wf_insert_referencia (ls_cod_relacion,ls_tipo_doc ,ls_nro_doc ,ls_referencia) = false then
						ROLLBACK;
						RETURN		
					end if
				END IF
			end if
			 
		END IF
		 
		/**/
		idw_detail.object.origen        [ll_inicio]  = ls_cod_origen
		idw_detail.object.nro_registro  [ll_inicio]  = ll_nro_registro		 
	NEXT
	
	
	//Detalle de pre asiento
	FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
		idw_asiento_det.object.origen   		[ll_inicio] = ls_cod_origen
		idw_asiento_det.object.ano   	 		[ll_inicio] = ll_ano
		idw_asiento_det.object.mes	   		[ll_inicio] = ll_mes
		idw_asiento_det.object.nro_libro		[ll_inicio] = ll_nro_libro
		idw_asiento_det.object.nro_asiento 	[ll_inicio] = ll_nro_asiento
		idw_asiento_det.object.fec_cntbl   	[ll_inicio] = ldt_fecha_cntbl
	NEXT
	
	ldc_totsoldeb  = idw_asiento_det.object.monto_soles_cargo   [1]
	ldc_totdoldeb  = idw_asiento_det.object.monto_dolares_cargo [1]
	ldc_totsolhab  = idw_asiento_det.object.monto_soles_abono	[1]
	ldc_totdolhab  = idw_asiento_det.object.monto_dolares_abono [1]
	
	//Datos de la cabecera
	idw_asiento_cab.Object.desc_glosa	[1] = left(ls_desc_glosa, 200)
	idw_asiento_cab.Object.cod_moneda	[1] = ls_cod_moneda
	idw_asiento_cab.Object.tasa_cambio	[1] = ldc_tasa_cambio
	idw_asiento_cab.Object.fec_registro [1] = ldt_fecha_cntbl
	idw_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_cntbl
	idw_asiento_cab.Object.cod_usr	   [1] = ls_cod_usr
	idw_asiento_cab.Object.flag_estado  [1] = ls_flag_estado
	idw_asiento_cab.Object.tot_solhab	[1] = ldc_totsolhab
	idw_asiento_cab.Object.tot_dolhab	[1] = ldc_totdolhab
	idw_asiento_cab.Object.tot_soldeb	[1] = ldc_totsoldeb
	idw_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb
	
	IF dw_master.ii_update = 1 OR idw_asiento_det.ii_update = 1 THEN 
		idw_asiento_det.ii_update = 1
		idw_asiento_cab.ii_update = 1
	END IF
	
	
	// valida asientos descuadrados
	lb_retorno  = invo_asiento_contable.of_validar_asiento(idw_asiento_det)
	
	IF lb_retorno = FALSE THEN
		ROLLBACK;
		Return
	END IF
	
	/*Replicacion*/
	dw_master.of_set_flag_replicacion()
	idw_detail.of_set_flag_replicacion()
	idw_asiento_cab.of_set_flag_replicacion()
	idw_asiento_det.of_set_flag_replicacion()
	
	ib_update_check = True
	
	return 
	
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
			ls_flag_provisionado, ls_flag_padron_sunat, ls_proveedor
Boolean  lbo_ok = TRUE
Datetime ldt_fecha_doc
Decimal 	ldc_tasa_cambio, ldc_imp_ret_sol,ldc_imp_ret_dol


dw_master.AcceptText()
idw_detail.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	
	DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
		ids_crelacion_ext_tbl.deleterow(0)
	LOOP	
	
	ROLLBACK ;
	RETURN
END IF	


if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if

/*datos de la cabecera*/
ll_row_master     		= dw_master.getrow()
ll_nro_registro   		= dw_master.object.nro_registro   	[ll_row_master]
ls_origen 		   		= dw_master.object.origen			 	[ll_row_master]
ls_flag_retencion 		= dw_master.object.flag_retencion 	[ll_row_master]
ldt_fecha_doc	   		= dw_master.object.fecha_emision  	[ll_row_master]
ldc_tasa_cambio			= dw_master.object.tasa_cambio	 	[ll_row_master]
ls_flag_padron_sunat		= dw_master.object.flag_padron_sunat[ll_row_master]
ls_proveedor				= dw_master.object.cod_relacion		[ll_row_master]

//ejecuta procedimiento de actualizacion de tabla temporal
IF idw_asiento_det.ii_update = 1 and is_action <> 'new' THEN
	ll_row_det     	= idw_asiento_det.Getrow()
	ll_ano         	= idw_asiento_det.Object.ano         [ll_row_det]
	ll_mes         	= idw_asiento_det.Object.mes         [ll_row_det]
	ll_nro_libro   	= idw_asiento_det.Object.nro_libro   [ll_row_det]
	ll_nro_asiento 	= idw_asiento_det.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
	
END IF


IF idw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF idw_asiento_cab.Update (true,false) = -1 THEN // Cabecera de Asiento
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Cabecera de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF idw_asiento_det.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF idw_asiento_det.Update (true,false) = -1 THEN 
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detail.Update(true,false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

if lbo_ok then
	/*Datos de Retencion*/
	if invo_cri.of_update(dw_master, idw_detail, ids_crelacion_ext_tbl) = false then
		ROLLBACK;
		lbo_ok = FALSE
		GOTO SALIDA
	end if
	
	/*Datos de Deuda Financiera*/
	if is_action <> 'anular' then
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
	// Actualizar el flag_padron_sunat
	update proveedor
		set flag_padron_sunat = :ls_flag_padron_sunat
	 where proveedor = :ls_proveedor;
	 
	//acciones despues de grabar
	wf_post_update()

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
	
	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.origen[dw_master.getRow()], Long(dw_master.object.nro_registro[dw_master.getRow()]))
	end if
	
	f_mensaje("Transaccion guardada satisfactoriamente", "")
	
ELSE
	Rollback ;
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;str_parametros sl_param

TriggerEvent ('ue_update_request')

sl_param.dw1     = 'd_abc_cartera_pagos_tbl'
sl_param.titulo  = 'Cartera de Pagos'
sl_param.field_ret_i[1] = 1 //origen
sl_param.field_ret_i[2] = 2 //registro	
sl_param.field_ret_i[3] = 5 //ano
sl_param.field_ret_i[4] = 6 //mes
sl_param.field_ret_i[5] = 7 //nro libro
sl_param.field_ret_i[6] = 8 //nro asiento


OpenWithParm( w_lista, sl_param)
sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1], Long(sl_param.field_ret[2]))
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
dw_master.object.imp_total 	[dw_master.getrow()] = of_recalcular_monto_det ()
dw_master.object.importe_cri 	[dw_master.getrow()] = of_recalcular_ret_igv ()
dw_master.ii_update = 1

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update                      = 1 OR idw_detail.ii_update      = 1 OR &
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

IF is_action = 'new' then return

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
if not invo_asiento_contable.of_val_mes_cntbl(ll_ano,ll_mes,'B') then return //movimiento bancario



/*Verificación de comprobante de retencion*/
SELECT Count(*) INTO :ll_count FROM retencion_igv_crt 
WHERE ((origen           = :ls_origen		  ) AND
		 (nro_reg_caja_ban = :ll_nro_registro ));

IF ll_count > 0 THEN
	cb_retenciones.Enabled = FALSE
ELSE
	cb_retenciones.Enabled = TRUE
END IF


IF ls_flag_estado <> '1' THEN
	dw_master.ii_protect = 0
	dw_master.of_protect()	
	idw_detail.ii_protect = 0
	idw_detail.of_protect()	
	idw_asiento_det.ii_protect = 0
	idw_asiento_det.of_protect()	
	
	MessageBox('Error', 'El comprobante no se encuentra activo por favor verificar')
	return
end if	

dw_master.of_protect()
idw_detail.of_protect()
idw_asiento_det.of_protect()

IF idw_detail.ii_protect = 0 THEN //MODIFICABLE DETALLE DOCUMENTOS
	//bloqueo de campos...
	idw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
	idw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
	idw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")		
	idw_detail.Modify("flag_referencia.Protect ='1~tIf(IsNull(flag_doc),1,0)'")		
	idw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
	idw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")
	idw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")				
	idw_detail.Modify("tasa_cambio.Protect ='1~tIf(IsNull(t_detrac),0,1)'")		
END IF

//MODIFICABLE DETALLE ASIENTOS
IF idw_asiento_det.ii_protect = 0 THEN
	idw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
	idw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	
END IF





end event

event ue_insert_pos;call super::ue_insert_pos;

IF idw_1 = dw_master THEN
	idw_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;ib_estado_asiento = TRUE
end event

event ue_print;call super::ue_print;String 	ls_origen,ls_nro_certificado,ls_flag_ts,ls_print, ls_moneda
Long   	ll_nro_registro,ll_row_master,ll_count,ll_tiempo,ll_i, ll_nrchq, ll_rpta
Double	ldb_rc
Date		ld_fecimp
str_parametros 	lstr_param
n_cst_impresion 	lnvo_impresion
u_ds_base			lds_voucher

try
	
	sle_1.backcolor = rgb (255,255,0)
	
	//declaracion de objecto
	lnvo_impresion = create n_cst_impresion
	lds_voucher		= create u_ds_base
	
	ll_row_master = dw_master.Getrow()
	IF ll_row_master = 0 THEN RETURN
	
	IF dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR &
		idw_asiento_det.ii_update = 1 then //OR idw_asiento_det.ii_update = 1 THEN 
		Messagebox('Aviso','Debe Grabar Los Cambios Verifique! ', Information!)	
		Return
	END IF	
	
	ls_origen	    = dw_master.object.origen       [ll_row_master]
	ll_nro_registro = dw_master.object.nro_registro [ll_row_master]	
	ls_moneda 		 = dw_master.object.cod_moneda	[ll_row_master]
	ll_nrchq			 = dw_master.object.reg_cheque	[ll_row_master]
	
	IF cbx_ts.checked THEN
		ls_flag_ts = '1' 
	ELSE
		ls_flag_ts = '0' 
	END IF
	
	//nombre de impresora
	ls_print = Upper(dw_master.describe('datawindow.printer'))
	
	
	//Solicita si es impresión directa o previsualización
	if not rb_cv.checked then
		Open(w_print_preview)
		lstr_param = Message.PowerObjectParm
		if lstr_param.i_return < 0 then return
	end if

	
	/*******************/
	IF rb_cv.checked THEN
		/*IMPRESION LOCAL O TERMINAL SERVER*/
		if ls_moneda = gnvo_app.is_soles then
			lnvo_impresion.of_cheque_voucher_bcp('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gs_empresa,ls_flag_ts,ls_print,'P')
	
		else
			if Not IsDate(em_dif.text) then
				MessageBox("Error Fecha Diferida","Debe Ingresar una Fecha Diferida")
				return
			end if
			
			gd_fecimp = date(em_dif.text)
			select ce.fecha_impresion 
				into :ld_fecimp 
			from cheque_emitir ce
			where ce.nro_registro = :ll_nrchq;
			
			if not IsNull(ld_fecimp) then
				ll_rpta = MessageBox("Cheque Impreso","El Cheque Voucher ya ha sido Impreso, Desea Volver a Imprimir?", Question!, YesNo!)
			else
				ll_rpta = 1
			end if
			
			if ll_rpta = 1 then
				lnvo_impresion.of_chq_voucher_bcp_dol('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gs_empresa,ls_flag_ts,ls_print,'P')
			end if
			
			update cheque_emitir ce 
				set ce.fecha_impresion = sysdate 
			where ce.nro_registro = :ll_nrchq ;
			
			commit;
		end if
		
		
	ELSEIF rb_v.checked THEN
		/*IMPRESION LOCAL O TERMINAL SERVER*/
		lnvo_impresion.of_voucher ('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gs_empresa,ls_flag_ts,ls_print)
		
	
	ELSEIF rb_cr.checked THEN


		invo_cri.of_print(ls_origen, ll_nro_registro, lstr_param)
	
	ELSE
		Messagebox('Aviso','Debe Seleccionar Un Tipo de Impresion')
		Return
		
	END IF

	
catch ( Exception ex)
	f_mensaje("Error, ha ocurrido una exception: " + ex.getMessage(), '')
	
finally
	destroy lds_voucher
	destroy lnvo_impresion
end try
	
end event

event close;call super::close;DESTROY ids_asiento_adic
DESTROY ids_crelacion_ext_tbl

destroy invo_asiento_contable
destroy invo_cri
destroy invo_caja_bancos
end event

type cb_rcem from commandbutton within w_fi310_cartera_de_pagos
integer x = 3099
integer y = 420
integer width = 466
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Embargo Telematico"
end type

event clicked;String ls_filename_txt

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

if gnvo_app.finparam.of_generar_txt_recm(dw_master, idw_detail, ls_filename_txt) then
	MessageBox('Aviso', 'Se ha creado el archivo ' + ls_filename_txt + ' satisfactoriamente', Information!)
end if
end event

type st_dif from statictext within w_fi310_cartera_de_pagos
boolean visible = false
integer x = 3118
integer y = 756
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Diferida"
boolean focusrectangle = false
end type

type em_dif from editmask within w_fi310_cartera_de_pagos
string tag = "Fecha de Diferido"
boolean visible = false
integer x = 3109
integer y = 820
integer width = 379
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type dw_report from datawindow within w_fi310_cartera_de_pagos
boolean visible = false
integer x = 3538
integer y = 696
integer width = 242
integer height = 164
integer taborder = 50
string title = "none"
string dataobject = "d_txt_telecredito_tbl"
boolean border = false
boolean livescroll = true
end type

type cb_gen_tlc from commandbutton within w_fi310_cartera_de_pagos
integer x = 3099
integer y = 320
integer width = 466
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean enabled = false
string text = "Generar TLC"
end type

event clicked;string 	ls_origen, ls_mensaje, ls_tipo_trabaj, ls_nro_cuenta, &
			ls_directorio, ls_file
Long 		ll_nro_registro
date ld_fecha

ls_directorio 		= 'i:\telecredito\'
ls_origen   		= dw_master.Object.origen					[dw_master.getRow()]
ll_nro_registro 	= Long(dw_master.object.nro_registro	[dw_master.getRow()])
ld_fecha    		= date(dw_master.Object.fecha_emision	[dw_master.getRow()])
ls_nro_cuenta 		= dw_master.Object.cod_ctabco				[dw_master.getRow()]

if ls_nro_cuenta = '' or IsNull(ls_nro_cuenta) then
	MessageBox('Error', 'Debe Elegir un numero de cuenta')
	return
end if

if ll_nro_registro = 0 or IsNull(ll_nro_registro) then
	MessageBox('Error', 'Debe Guardar Primero')
	return
end if

ls_file = 'PAG_PROV_'+string(dw_master.object.nro_registro[dw_master.getRow()])

//create or replace procedure USP_FIN_PAGO_PROVEEDORES (
//  asi_origen       in origen.cod_origen%TYPE,
//  asi_nro_registro in caja_bancos.nro_registro%TYPE
//) is
DECLARE USP_FIN_PAGO_PROVEEDORES PROCEDURE FOR 
	USP_FIN_PAGO_PROVEEDORES( :ls_origen, 
									  :ll_nro_registro) ;
EXECUTE USP_FIN_PAGO_PROVEEDORES;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	rollback ;
	MessageBox("Error ", "Error al invocar procedure USP_FIN_PAGO_PROVEEDORES. Mensaje: " + ls_mensaje, StopSign!)
	return
end if

commit ;

CLOSE USP_FIN_PAGO_PROVEEDORES;

dw_report.settransobject( SQLCA)
dw_report.retrieve()

if dw_report.RowCount() <= 0 then
	MessageBox('Error', 'No hay datos que recuperar', StopSign!)
	return
end if

//CReo la carpeta para el telecredito
if not DirectoryExists(ls_directorio) then CreateDirectory(ls_directorio)
	
ls_file = ls_directorio + ls_file + '_' + string(ld_fecha, 'ddmmyyyy') + '.txt'

if dw_report.saveas( ls_file, Text!, false) = -1 then
	MessageBox('Error', 'No se ha podido generar archivo de telecredito ' + ls_file, StopSign!)
	return
end if

MessageBox('Aviso', 'Archivo de telecredito ' + ls_file + ' generado satisfactoriamente', StopSign!)

end event

type sle_1 from singlelineedit within w_fi310_cartera_de_pagos
integer x = 3218
integer y = 612
integer width = 224
integer height = 64
integer taborder = 80
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

type cbx_ts from checkbox within w_fi310_cartera_de_pagos
integer x = 3584
integer y = 120
integer width = 782
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Terminal Server"
end type

type dw_rpt from datawindow within w_fi310_cartera_de_pagos
boolean visible = false
integer x = 3826
integer y = 692
integer width = 283
integer height = 196
integer taborder = 100
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_cv from radiobutton within w_fi310_cartera_de_pagos
integer x = 3607
integer y = 288
integer width = 590
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cheque Voucher"
boolean checked = true
end type

event clicked;if rb_cv.checked then
	st_dif.visible = true
	em_dif.visible = true
else
	st_dif.visible = false
	em_dif.visible = false
end if
end event

type rb_v from radiobutton within w_fi310_cartera_de_pagos
integer x = 3607
integer y = 360
integer width = 590
integer height = 64
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

type rb_cr from radiobutton within w_fi310_cartera_de_pagos
integer x = 3607
integer y = 428
integer width = 590
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comp. Retención"
end type

type cb_genera_cheque from commandbutton within w_fi310_cartera_de_pagos
integer x = 3099
integer y = 220
integer width = 466
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera Cheque"
end type

event clicked;Long   ll_row,ll_reg_cheque,ll_nro_cheque,ll_found
String ls_flag_estado ,ls_codctabco    ,ls_afav       ,ls_cnta_ctbl   ,ls_expresion   ,&
		 ls_t_cheque	 ,ls_flag_cta_bco ,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		 ls_flag_cbebef, ls_mensaje
Decimal ldc_imp_total
Date ld_fecemi

str_parametros lstr_param

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

/*verificar grabaciones*/
IF (dw_master.ii_update                      = 1 OR idw_detail.ii_update      = 1 OR &
	 idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1 )THEN
	 Messagebox('Aviso','Tiene Grabaciones Pendientes , Verifique!')
	 Return
END IF


dw_master.Accepttext()
ll_row = dw_master.Getrow ()



/*parametros*/
SELECT doc_cheque INTO :ls_t_cheque FROM finparam WHERE (reckey = '1') ;

ll_reg_cheque  = dw_master.object.reg_cheque	   [ll_row]
ls_flag_estado = dw_master.object.flag_estado   [ll_row]
ls_codctabco	= dw_master.object.cod_ctabco    [ll_row]
ldc_imp_total	= dw_master.object.imp_total	   [ll_row]
ls_afav			= dw_master.object.nom_proveedor [ll_row]
ld_fecemi		= date(dw_master.object.fecha_emision [ll_row])

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
	
	if lstr_param.i_return < 0 then return
	ls_afav = lstr_param.string1
END IF
//**//

//create or replace procedure USP_FIN_GENER_CHEQUE_X_DOC(
//       ac_codctabco   in     banco_cnta.cod_ctabco%type ,
//       ac_user        in     cheque_emitir.cod_usr%type ,
//       an_importe_tot in     cheque_emitir.importe%type ,
//       ac_afav        in     cheque_emitir.afavor%type  ,
//       an_registro_ch in out cheque_emitir.nro_registro%type,
//       an_cheque_corr in out cheque_emitir.nro_cheque%type   
//) is

DECLARE USP_FIN_GENER_CHEQUE_X_DOC PROCEDURE FOR 
	USP_FIN_GENER_CHEQUE_X_DOC(:ls_codctabco , 
										:gs_user ,
										:ldc_imp_total ,
										:ls_afav,
										:ld_fecemi
										);
EXECUTE USP_FIN_GENER_CHEQUE_X_DOC ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	f_mensaje('Fallo Store Procedure USP_FIN_GENER_CHEQUE_X_DOC: ' + ls_mensaje, 'ERR_PROCEDURE')
	RETURN
END IF

FETCH USP_FIN_GENER_CHEQUE_X_DOC INTO :ll_reg_cheque,:ll_nro_cheque ;

CLOSE USP_FIN_GENER_CHEQUE_X_DOC ;

IF Isnull(ll_nro_cheque) OR ll_nro_cheque = 0 THEN
	Rollback ;
	f_mensaje('Coloque Correlativo de Cheque de Cuenta de BANCO ,Verifique!', 'FI-0001')
	RETURN
END IF

COMMIT;
//**actualiza cabecera**//
dw_master.object.reg_cheque [ll_row] = ll_reg_cheque
dw_master.object.nro_cheque [ll_row] = ll_nro_cheque
dw_master.object.tipo_doc   [ll_row] = ls_t_cheque
dw_master.object.nro_doc    [ll_row] = Trim(String(ll_nro_cheque))



//*BUSCAR CUENTA DE BANCO EN ASIENTO*/
ls_cnta_ctbl = dw_master.object.cnta_ctbl [ll_row]

ls_expresion = "cnta_ctbl = '"+ls_cnta_ctbl+"'"
ll_found     = idw_asiento_det.find(ls_expresion,1,idw_asiento_det.rowcount()) 

IF ll_found > 0 THEN
	IF f_cntbl_cnta(ls_cnta_ctbl,ls_flag_cta_bco,ls_flag_cencos,ls_flag_doc_ref, &
					    ls_flag_cod_rel,ls_flag_cbebef)  THEN
		IF ls_flag_doc_ref = '1' THEN
			idw_asiento_det.object.tipo_docref1 [ll_found] = ls_t_cheque
			idw_asiento_det.object.nro_docref1  [ll_found] = Trim(String(ll_nro_cheque))
			idw_asiento_det.ii_update = 1
		END IF

	END IF		
END IF


dw_master.ii_update = 1

/*Genera Asientos*/
//ib_estado_asiento = TRUE

end event

type cb_retenciones from commandbutton within w_fi310_cartera_de_pagos
integer x = 3099
integer y = 120
integer width = 466
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retenciones"
end type

event clicked;String 	ls_cod_moneda,ls_flag_retencion,ls_cod_relacion
Long   	ll_row_master,ll_inicio
Decimal 	ldc_tasa_cambio

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

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
dw_master.Object.imp_total 	[ll_row_master] =	of_recalcular_monto_det()
dw_master.Object.importe_cri 	[ll_row_master] =	of_recalcular_ret_igv()

idw_detail.ii_update = 1
ib_estado_asiento = TRUE


end event

type cbx_ref from checkbox within w_fi310_cartera_de_pagos
integer x = 3584
integer y = 36
integer width = 782
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

type tab_1 from tab within w_fi310_cartera_de_pagos
integer y = 1092
integer width = 3758
integer height = 1024
integer taborder = 40
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
integer width = 3721
integer height = 896
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
integer x = 5
integer width = 3666
integer height = 904
integer taborder = 30
string dataobject = "d_abc_caja_bancos_det_cartera_pago_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_items();String ls_cod_moneda
Long   ll_row_master
Decimal {4} ldc_tasa_cambio

ll_row_master = dw_master.getrow()
ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]

f_verificacion_items_x_retencion (dw_master,idw_detail)

dw_master.object.imp_total 	[ll_row_master] = of_recalcular_monto_det()
dw_master.object.importe_cri 	[ll_row_master] = of_recalcular_ret_igv()
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
date		ld_fecha_pago
integer	li_semana

if dw_master.getRow() = 0 then return 

dw_master.Accepttext()
//datos del banco
ls_moneda 		 	= dw_master.object.cod_moneda  			[dw_master.getrow()]
ldc_tasa_cambio 	= dw_master.object.tasa_cambio 			[dw_master.getrow()]
ls_confin		 		= dw_master.object.confin		  			[dw_master.getrow()]
ls_matriz		 		= dw_master.object.matriz_cntbl			[dw_master.getrow()]
ld_fecha_pago 	 	= Date(dw_master.object.fecha_emision	[dw_master.getRow()])

This.object.nro_item 			[al_row] = this.of_nro_item()
This.object.flag_flujo_caja 	[al_row] = '1'
This.object.flag_referencia 	[al_row] = '0'   //INDIRECTO

//Obtengo la semana de pago
try 
	if gnvo_app.of_get_parametro( "USE_PRSP_CAJA", '0') = '1' then
		li_semana = gnvo_app.of_get_semana( ld_fecha_pago )
		This.object.semana 				[al_row] = li_Semana
	end if
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception: ' + ex.getMessage())
end try


//Si la empresa no es agente de retención, entonces indico que no hay detraccion
if gnvo_app.is_agente_ret = '0' then
	this.object.flag_ret_igv		[al_row] = '0'
end if

IF cbx_ref.Checked THEN
	This.object.origen_doc		   [al_row] = gs_origen //INDIRECTO
	This.object.flag_provisionado [al_row] = 'N'       //INDIRECTO
	This.object.cod_moneda			[al_row]	= ls_moneda
	This.object.cod_moneda_cab 	[al_row] = ls_moneda
	This.object.tasa_cambio       [al_row] = ldc_tasa_cambio
	This.object.flag_doc			   [al_row] = '1'       //tipo de documento editable.
	This.object.flag_partida		[al_row] = '1'       //partida editable
	This.object.factor			   [al_row] = 1
	This.object.confin			   [al_row] = ls_confin
	This.object.matriz_cntbl      [al_row]	= ls_matriz
	This.object.t_tipdoc 			[al_row] = '1'		//editable
	This.object.flag_aplic_comp	[al_row] = '0'		//editable
END IF	


//bloqueo de campos....
this.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
this.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
this.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")
this.Modify("flag_referencia.Protect ='1~tIf(IsNull(flag_doc),1,0)'")		
this.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
this.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")			
this.Modify("tasa_cambio.Protect ='1~tIf(IsNull(t_detrac),0,1)'")		

this.SetColumn('cod_relacion')

end event

event itemchanged;call super::itemchanged;Long   	ll_count,ll_mes,ll_ano,ll_null,ll_nro_registro
String 	ls_data, ls_cod_moneda, ls_cencos,ls_cnta_prsp,&
		 	ls_flag_provisionado,ls_matriz,ls_origen,ls_cod_relacion,ls_tip_doc_ref ,&
		 	ls_nro_doc_ref,ls_accion,ls_flag_estado,ls_nom_proveedor,ls_flag_ret_igv, &
			ls_nro_certificado
Decimal 	ldc_importe,ldc_imp_retencion, ldc_tasa_cambio
Long		ll_row
dwItemStatus ldis_status


Accepttext()

setNull(ls_flag_estado)

/*Generacion de Asientos*/
ib_estado_asiento = TRUE

choose case dwo.name
	
		
	case 'centro_benef'
		select Count(*) 
			into :ll_count 
			from centro_beneficio
		Where centro_benef = :data	
		  and flag_estado = '1';
		 
		IF ll_count = 0  THEN
			Messagebox('Aviso','Centro de Beneficio No esta Activo o no existe, por favor verifique')
			This.Object.centro_benef [row] = gnvo_app.is_null
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
	
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
	case 'flag_flujo_caja'	
		
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
	case 'confin'
		SELECT matriz_cntbl
		  INTO :ls_matriz
		  FROM concepto_financiero
		 WHERE confin = :data ;
		 
		
		IF Isnull(ls_matriz) OR Trim(ls_matriz) = '' THEN
			Messagebox('Aviso','Concepto Financiero No existe Verifique')
			This.Object.confin [row] = gnvo_app.is_null
			Return 1
		ELSE
			This.object.matriz_cntbl [row] = ls_matriz
		END IF
		
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
	case	'cod_relacion'
		select p.nom_proveedor 
			into :ls_nom_proveedor
		  	from proveedor p
		 where (p.proveedor   = :data ) and
				 (p.flag_estado = '1'   ) ;
	
				  
		if SQLCA.SQLCode = 100 then
			This.object.cod_relacion  [row] = gnvo_app.is_null
			This.object.nom_proveedor [row] = gnvo_app.is_null
			Messagebox('Aviso','Codigo de Relacion No Existe o no esta activo, Verifique!')
			Return 1
		end if
		
		This.object.nom_proveedor [row] = ls_nom_proveedor
	
	case 'cencos'
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
				ls_cod_moneda   = this.object.cod_moneda  [row]		
				ldc_tasa_cambio = this.object.tasa_cambio [row]		
			
				if ls_cod_moneda = gnvo_app.is_soles then
					ldc_importe = Round(ldc_importe / ldc_tasa_cambio,2)
				end if						
			
	
				IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
					this.object.cnta_prsp [row] = gnvo_app.is_null
					this.object.importe   [row] = ll_null		
					dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
					dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
					dw_master.ii_update = 1
					RETURN 1
				END IF
			END IF
			
		end if
		
	case 'cnta_prsp'			
		ls_flag_provisionado = this.object.flag_provisionado [row]			
		
		select Count(*) 
			into :ll_count 
		from presupuesto_cuenta 
		where (cnta_prsp = :data) ;			   
		
		if ll_count = 0 then
			This.object.cnta_prsp [row] = gnvo_app.is_null
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
				ls_cod_moneda   = this.object.cod_moneda  [row]		
				ldc_tasa_cambio = this.object.tasa_cambio [row]		
			
				if ls_cod_moneda = gnvo_app.is_soles then
					ldc_importe = Round(ldc_importe / ldc_tasa_cambio,2)
				end if
				
			
				IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
					this.object.cnta_prsp [row] = gnvo_app.is_null
					this.object.importe   [row] = ll_null		
					
					dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
					dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
					dw_master.ii_update = 1							
					RETURN 1
				END IF
			END IF
			
		end if
		
	case 'tipo_doc'
	
		select Count(*) into :ll_count
		  from doc_grupo dg, doc_grupo_relacion dgr, finparam fp 
		 where (dg.grupo     = dgr.grupo ) and
				 (dg.grupo     = fp.doc_grp_pag_directo) and
				 (dgr.tipo_doc = :data     ) ;
				 
		if ll_count = 0 then
			SetNull(ls_data)
			This.object.tipo_doc [row] = ls_data
			Messagebox('Aviso','Documento No Existe en Grupo de Documento x Pagar , Verifique!')
			Return 1
		end if
		
	case 'impt_ret_igv'
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
	case	'tasa_cambio' 	
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
	case 'importe'
		
		ls_flag_provisionado = this.object.flag_provisionado [row]
		
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
		ls_flag_ret_igv = this.object.flag_ret_igv [row]
	
		IF ls_flag_provisionado <> 'N' THEN //SIN UN ORIGEN DEL REGISTRO
			
			wf_verifica_monto_doc(ls_cod_relacion,ls_origen,ll_nro_registro,ls_tip_doc_ref,ls_nro_doc_ref,ldc_importe,ls_accion,ls_flag_estado)
	
			if Trim(ls_flag_estado) = '1' then
				Messagebox('Aviso','Importe se ha excedido, Verifique')
				this.object.importe 		   [row] = 0.00
				this.object.impt_ret_igv   [row] = 0.00
				dw_master.Object.imp_total 	[1] 	= of_recalcular_monto_det()
				dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
				dw_master.ii_update = 1
				Return 1
			end if
		END IF		
	
	
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
		//porcentaje de retencion
		IF ls_flag_ret_igv = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
			
			ldc_importe     = This.object.importe     [row] 		
			ls_cod_moneda   = This.object.cod_moneda  [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio [row] 					
			
			IF ls_cod_moneda <> gnvo_app.is_soles THEN 
				ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * gnvo_app.idc_tasa_retencion)/ 100,2)
			 
			This.object.impt_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
			This.object.impt_ret_igv [row] = 0.00
		END IF
		//
		
		
		//afectacion presupuestal verificacion
		IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
		
			ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
			ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
			ls_cencos	  	 = this.object.cencos      [row]
			ls_cnta_prsp  	 = this.object.cnta_prsp   [row]
			ldc_importe   	 = this.object.importe     [row]
			ls_cod_moneda   = this.object.cod_moneda  [row]		
			ldc_tasa_cambio = this.object.tasa_cambio [row]		
			
			if ls_cod_moneda = gnvo_app.is_soles then
				ldc_importe = Round(ldc_importe / ldc_tasa_cambio,2)
			end if
				
			
			IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
				this.object.cnta_prsp [row] = gnvo_app.is_null
				this.object.importe   [row] = ll_null		
				dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
				dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
				dw_master.ii_update = 1
				RETURN 1
			END IF
		END IF
		
	CASE 'flag_ret_igv'
	
		//Si tiene detraccion entonces no es necesario la retencion
		ls_nro_certificado = this.object.nro_Certificado [row]				
		
		if not IsNull(ls_nro_certificado) and trim(ls_nro_certificado) = '' then
			This.object.flag_ret_igv [row] = '0'
			Return 1
		end if
		
		
		IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
			/*porcentaje de retencion igv*/
			
			/**/
		
			ldc_importe     = This.object.importe     [row] 		
			ls_cod_moneda   = This.object.cod_moneda  [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio [row] 					
			
			IF ls_cod_moneda <> gnvo_app.is_soles THEN 
				ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * gnvo_app.idc_tasa_retencion)/ 100,2)
			 
			This.object.impt_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
			This.object.impt_ret_igv [row] = 0.00
		END IF
		
		//Aplico la retencion al resto de registros
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar El mismo FLAG de RETENCION para los registros restantes?', &
							Information!, YesNo!, 2) = 1 then
							
				for ll_row = row + 1 to this.RowCount()
					this.object.flag_ret_igv	[ll_row] = data
					
					IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
						/*porcentaje de retencion igv*/
						
						/**/
					
						ldc_importe     = This.object.importe     [ll_row] 		
						ls_cod_moneda   = This.object.cod_moneda  [ll_row] 					
						ldc_tasa_cambio = This.object.tasa_cambio [ll_row] 					
						
						IF ls_cod_moneda <> gnvo_app.is_soles THEN 
							ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
						END IF
					  
						ldc_imp_retencion = Round((ldc_importe * gnvo_app.idc_tasa_retencion)/ 100,2)
						 
						This.object.impt_ret_igv [ll_row] = ldc_imp_retencion					
						 
					ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
						This.object.impt_ret_igv [ll_row] = 0.00
					END IF
		
				next
			end if
			
			
		end if
		
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
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
			THIS.object.cnta_prsp    [ll_row_ope] = gnvo_app.is_cnta_prsp_gfinan
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_relacion, ls_flag_provisionado, ls_accion, &
			ls_cencos, ls_cnta_prsp, ls_cod_banco, ls_cod_moneda, ls_cnta_bco_prov, ls_nom_banco
Long		ll_mes, ll_ano
Decimal	ldc_importe
str_parametros		lstr_param
dwItemStatus 		ldis_status

choose case lower(as_columna)
		
	CASE 'semana', 'nro_prsp', 'item_prsp'
		lstr_param.long1 		= Long(this.object.semana [al_row])
		lstr_param.string1	= 'E'  // Para que solo muestre los egresos
		lstr_param.dw_m 		= dw_master
		lstr_param.dw_d		= idw_detail
		
		OpenWithParm(w_fi310_choice_prsp_caja, lstr_param)
	
	CASE 'b_1'
		Open(w_fi512_cns_carta_credito)
				
				
	CASE 'b_2'
		//BUSCAR CODIGO DE RELACION EN DETALLE DE PAGO
		ls_cod_relacion = this.object.cod_relacion [al_row]
		
		if Isnull(ls_cod_relacion) or Trim(ls_cod_relacion) = ''  then
			Messagebox('Aviso','Codigo de Relacion del Detalle debe Colocarse para ' &
									+' Buscar Deudadas Financieras' )
			Return						 
		end if
		
		lstr_param.tipo			= '14' 
		lstr_param.opcion			= 13
		lstr_param.titulo 		= 'Selección de Deudas Financieras'
		lstr_param.dw_master		= 'd_abc_lista_deuda_financiera_cab_tbl'
		lstr_param.dw1				= 'd_abc_lista_deuda_financiera_det_tbl'
		lstr_param.dw_m			= dw_master
		lstr_param.dw_d			= idw_detail
		lstr_param.long1			= al_row
		lstr_param.string1		= ls_cod_relacion
		
		
		dw_master.Accepttext()
		
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		lstr_param = Message.PowerObjectParm
		
		if lstr_param.bret then
			ii_update = 1	
		end if
				
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
				
	CASE 'cod_flujo_caja'
	
		lstr_param.tipo			= '1S'
		lstr_param.opcion			= 16
		lstr_param.string1 		= 'E'
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
		
		ldis_status = this.GetItemStatus(al_row,0,Primary!)				
		
		IF ldis_status = NewModified! THEN
		  ls_accion = 'new'
		ELSE	
		  ls_accion = 'fileopen'					
		END IF
		
		
		IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O') OR ls_accion = 'fileopen' THEN RETURN
		
		ls_sql = "SELECT VW.TIPO_DOC AS CODIGO_DOC,"&
				 + "VW.DESC_TIPO_DOC AS DESCRIPCION "&
				 + "FROM VW_FIN_DOC_X_GRUPO_PAGAR VW" 
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.tipo_doc[al_row] = ls_codigo
			this.ii_update = 1
			ib_estado_asiento = TRUE
		END IF
		
													
	CASE 'cod_relacion'
		ls_flag_provisionado = this.object.flag_provisionado [al_row]
		
		ldis_status = this.GetItemStatus(al_row,0,Primary!)				
		
		IF ldis_status = NewModified! THEN
		  ls_accion = 'new'
		ELSE	
		  ls_accion = 'fileopen'					
		END IF
		
		IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O') OR ls_accion = 'fileopen' THEN RETURN

		ls_sql = "SELECT P.PROVEEDOR     AS CODIGO , "&
				 + "P.NOM_PROVEEDOR AS razon_social,   "&
				 + "DECODE(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni " &
				 + "FROM PROVEEDOR P "&
				 + "WHERE P.FLAG_ESTADO = '1'" 
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_relacion	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
			ib_estado_asiento = TRUE
		END IF
		
	CASE 'cnta_bco_prov'
		
		ls_cod_relacion 	= this.object.cod_relacion 	[al_row]
		ls_cod_banco		= dw_master.object.cod_banco	[1]
		ls_cod_moneda		= this.object.cod_moneda 		[al_row]
		
		ls_sql = "select t.cnta_bco_prov, t.cod_banco, b.nom_banco, t.cod_moneda, " &
				 + "t.proveedor, t.cod_moneda " &
				 + "  from PROV_BANCO_CNTA t, " &
				 + "       banco           b " &
				 + " where t.cod_banco   = b.cod_banco "&
				 + "   and t.proveedor	 = '" + ls_cod_relacion + "'" &
				 + "   and t.cod_moneda	 = '" + ls_cod_moneda + "'" &
			    + "	 and t.cod_banco	 = '" + ls_cod_banco + "'" &
				 + "   AND t.FLAG_ESTADO = '1'" 
			 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_cnta_bco_prov, ls_cod_banco, ls_nom_banco, "2")
		
		if ls_codigo <> "" then
			this.object.cnta_bco_prov			[al_row] = ls_cnta_bco_prov
			this.object.cod_moneda_bco_prov	[al_row] = ls_cod_moneda					
			this.object.cod_banco           	[al_row] = ls_cod_banco
			this.object.nom_banco				[al_row] = ls_nom_banco
				
			this.ii_update = 1
			ib_estado_asiento = TRUE
		END IF
		

		
	CASE 'cencos'
		ls_flag_provisionado = this.object.flag_provisionado [al_row]
		IF ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' THEN RETURN
		
		ls_sql = "SELECT CC.CENCOS AS CODIGO , "&
				 + "CC.DESC_CENCOS AS DESCRIPCION  " &
				 + "FROM CENTROS_COSTO CC " &
				 + "WHERE CC.FLAG_ESTADO = '1'"
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cencos	[al_row] = ls_codigo
			
			//afectacion presupuestal verificacion
			IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
				ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
				ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
				ls_cencos	   = this.object.cencos    [al_row]
				ls_cnta_prsp = this.object.cnta_prsp 	[al_row]
				ldc_importe  = this.object.importe   	[al_row]
				
				IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
					this.object.cnta_prsp [al_row] = gnvo_app.is_null
					this.object.importe   [al_row] = gnvo_app.idc_null
					dw_master.Object.imp_total 		[1] =	of_recalcular_monto_det()
					dw_master.Object.importe_cri 		[1] =	of_recalcular_ret_igv()
					dw_master.ii_update = 1
					RETURN 
				END IF
			END IF			
		  
			this.ii_update = 1
			ib_estado_asiento = TRUE
		END IF
		
		  
	CASE 'centro_benef'
		ls_sql = "SELECT b.CENTRO_BENEF AS CODIGO, "&
				 + "B.DESC_CENTRO AS DESCRIPCION "&       
				 + "FROM CENTRO_BENEFICIO B "&
				 + "WHERE B.FLAG_ESTADO = '1'" 
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.centro_benef[al_row] = ls_codigo
			this.ii_update = 1
		END IF
	
		  
	CASE 'cnta_prsp'
		
		ls_flag_provisionado = this.object.flag_provisionado [al_row]
		
		IF (ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'O' )THEN RETURN
		
		ls_sql = "SELECT PC.CNTA_PRSP   AS CODIGO , "&
				 + "PC.DESCRIPCION AS DESCRIPCION  " &
				 + "FROM PRESUPUESTO_CUENTA PC "&
				 + "WHERE PC.FLAG_ESTADO = '1'" 
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cnta_prsp [al_Row] = ls_codigo

		  	//afectacion presupuestal verificacion
		  	IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
			  ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
			  ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
			  ls_cencos	   = this.object.cencos    [al_row]
			  ls_cnta_prsp = this.object.cnta_prsp [al_row]
			  ldc_importe  = this.object.importe   [al_row]
			
			  IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
				  this.object.cencos    [al_row] = gnvo_app.is_null
				  this.object.importe   [al_row] = gnvo_app.idc_null
				  dw_master.Object.imp_total 		[1] =	of_recalcular_monto_det()
				  dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
				  dw_master.ii_update = 1
				  RETURN 
			  END IF
			END IF				  
		  
		  	this.ii_update = 1
		  	/*Generacion de Asientos*/
		  	ib_estado_asiento = TRUE

		END IF	


end choose
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

event buttonclicked;call super::buttonclicked;String 	ls_nro_certificado, ls_sql, ls_codigo, ls_serie_cri, ls_nro_cri, ls_mensaje
Date		ld_fec_pago
Decimal	ldc_tasa_cambio

if row= 0 then return

choose case lower(dwo.name)
	case "b_gen_retencion"
		try 
			
			if dw_master.ii_update = 1 or idw_detail.ii_update = 1 then
				MessageBox('Error', 'Existen grabaciones pendientes, por favor confirme', StopSign!)
				return
			end if
			//VErifico que la serie del certificado sea exclusivamente para ser actualizado
			ls_nro_certificado 	= this.object.nro_certificado [row]
			ls_serie_cri			= this.object.serie_cri			[row]
			
			if IsNull(ls_nro_certificado) or trim(ls_nro_certificado) = '' then
				f_Mensaje('Para usar esta opcion, el documento o LETRA debe tener un numero de certificado, por favor verifique!', '')
				return
			end if
			
			if IsNull(ls_serie_cri) or trim(ls_serie_cri) = '' then
				f_Mensaje('Para usar esta opcion, debe existir una SERIE de un numero de certificado, por favor verifique!', '')
				return
			end if
			
			if gnvo_app.is_agente_ret = '0' then
				f_Mensaje('La empresa no esta asignada como agente de retención, no es posible seleccionar una serie de Comprobante de retención', '')
				return
			end if
			
			ld_fec_pago 		= Date(dw_master.object.fecha_emision 	[1])
			ldc_tasa_cambio 	= Dec(dw_master.object.tasa_cambio 		[1])
			
			
			ls_sql = "select dtu.tipo_doc as tipo_doc, " &
					 + "ndt.nro_serie as numero_serie, " &
					 + "ndt.ultimo_numero as ultimo " &
					 + "from doc_tipo_usuario dtu, " &
					 + "     num_doc_tipo     ndt, " &
					 + "     doc_tipo			  dt " &
					 + "where ndt.tipo_doc    = dtu.tipo_doc " &
					 + "  and ndt.nro_serie   = dtu.nro_serie" &
					 + "  and dt.tipo_doc     = dtu.tipo_doc " &
					 + "  and dt.tipo_doc 	  = '"+ gnvo_app.is_doc_ret + "'" &
					 + "  and dtu.cod_usr     = '" + gs_user + "'" &
					 + "  and dt.flag_estado = '1'"
					 
			
			
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_serie_cri, "2") then
				this.object.serie_cri 	[row] = ls_serie_cri
				
				//Obtengo el nro de CRI
				IF invo_cri.of_get_nro_cri(ls_serie_cri, ls_nro_cri) = FALSE THEN
					ROLLBACK;
					RETURN
				END IF		 
		
				
				
				//Genero un clone del certificado
				insert into retencion_igv_crt(
						 nro_certificado, fecha_emision, origen, proveedor, nro_reg_caja_ban, flag_estado, flag_tabla, saldo_sol,
						 saldo_dol, importe_doc, fec_registro, fec_pago, tasa_cambio, cod_usr)
				select :ls_nro_cri, :ld_Fec_pago, origen, proveedor, nro_reg_caja_ban, flag_estado, flag_tabla, saldo_sol,
						 saldo_dol, importe_doc, sysdate, :ld_Fec_pago, :ldc_tasa_cambio, :gs_user
				  from retencion_igv_crt t
				where t.nro_certificado = :ls_nro_certificado;
				
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'Error al copiar en tabla RETENCION_IGV. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
				
				update cntas_pagar cp
				   set cp.nro_certificado = :ls_nro_cri
				where cp.nro_certificado = :ls_nro_certificado;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'Error al actualizar en tabla cntas_pagar. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
				
				//Anulo el comprobante
				update retencion_igv_crt t
				   set t.saldo_sol = 0,
						 t.saldo_dol = 0,
						 t.flag_estado = '0'
				where t.nro_certificado = :ls_nro_certificado;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'Error al actualizar en tabla retencion_igv_crt. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
				
				commit;
				
				/*ASIGNACION DE NUMERO DE C. RETENCION X C.RELACION*/
				this.object.nro_certificado			[row] = ls_nro_cri
			  
			END IF		
			
		catch ( Exception ex )
			gnvo_app.of_catch_exception(ex, "Error al generar el comprobante de retencion")
		finally
			/*statementBlock*/
		end try
		
		
end choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3721
integer height = 896
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
integer height = 368
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_bak"
end type

event constructor;call super::constructor;of_asigna_dws()
is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

event itemchanged;call super::itemchanged;/*Generacion de Asientos*/
ib_estado_asiento = FALSE

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;/*Generacion de Asientos*/
ib_estado_asiento = FALSE

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_gen_aut[al_row] = '0'
end event

type dw_asiento_cab from u_dw_abc within tabpage_2
boolean visible = false
integer y = 396
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

type cb_1 from commandbutton within w_fi310_cartera_de_pagos
integer x = 3099
integer y = 20
integer width = 466
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

event clicked;Long    			ll_row_master, ll_year, ll_mes
String  			ls_cod_moneda, ls_cod_relacion, ls_result, ls_mensaje, ls_confin
Decimal 			ldc_tasa_cambio
Date				ld_fecha_emision
str_parametros lstr_param

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return

//Valido si el periodo esta abierto o no
if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad', StopSign!)
	return
end if

//IF cbx_ref.checked THEN
//	Messagebox('Aviso','No Puede Ingresar Documentos con Referencia ya que Opcion de Ingresos sin referencia Esta Activa')
//	RETURN
//END IF

ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master]
ll_year 			 = dw_master.object.ano 		   [ll_row_master]
ll_mes 			 = dw_master.object.mes 		   [ll_row_master]
ls_confin		 = dw_master.object.confin		   [ll_row_master]

//*verifica cierre*/
if not invo_asiento_contable.of_val_mes_cntbl(ll_year,ll_mes,'B') then return

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	gnvo_app.of_mensaje_error('Debe Ingresar Una Moneda en la cabecera, por favor Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	Return
END IF

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	gnvo_app.of_mensaje_error('Debe Ingresar Un Proveedor de Referencia en la cabecera, por favor Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	Return
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	gnvo_app.of_mensaje_error('Debe Ingresar Una Tasa de Cambio, por favor Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF

IF Isnull(ls_confin) OR ls_confin = '' THEN
	gnvo_app.of_mensaje_error('Debe Ingresar Un concepto financiero, por favor Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('confin')
	Return
END IF

lstr_param.string3 = ls_cod_relacion

OpenWithParm(w_pop_help_edirecto,lstr_param)

//* Check text returned in Message object//
if IsNull(message.PowerObjectParm) or not IsValid(message.PowerObjectParm) then return

lstr_param = message.PowerObjectParm
if lstr_param.titulo = 'n' then return

lstr_param.string1 = lstr_param.string3


lstr_param.dw1			= 'd_doc_pendientes_tbl'
lstr_param.titulo		= 'Documentos Pendientes x Proveedor '
lstr_param.tipo 		= '1CP'
lstr_param.opcion   	= 15  //cartera de pagos
lstr_param.dw_m		= dw_master
lstr_param.dw_d		= idw_detail


OpenWithParm( w_abc_seleccion_lista, lstr_param)

IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
IF lstr_param.bret  THEN
	dw_master.Object.imp_total 	[1] = of_recalcular_monto_det ()
	dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
	dw_master.ii_update = 1
	idw_detail.ii_update = 1
	/*Generacion de Asientos*/
	ib_estado_asiento = TRUE
END IF

end event

type gb_1 from groupbox within w_fi310_cartera_de_pagos
integer x = 3589
integer y = 232
integer width = 782
integer height = 276
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Impresion"
end type

type gb_2 from groupbox within w_fi310_cartera_de_pagos
integer x = 3163
integer y = 576
integer width = 347
integer height = 112
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_master from u_dw_abc within w_fi310_cartera_de_pagos
integer width = 3067
integer height = 1064
boolean bringtotop = true
string dataobject = "d_abc_caja_bancos_cab_cartera_pago_tbl"
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

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
Long       	ll_row_gch,ll_count, ll_year, ll_mes
String     	ls_cod_moneda,ls_nom_proveedor,ls_matriz,ls_descripcion,&
			  	ls_cta_cntbl ,ls_ctabco       ,ls_codigo, ls_flag_padron_sunat
Decimal	 	ldc_tasa_cambio, ldc_saldo
Date		  	ld_fecha_emision


/*Generacion de Asientos*/
ib_estado_asiento = true

CHOOSE CASE dwo.name
	CASE 'serie_cri'
		if gnvo_app.is_agente_ret = '0' then
			this.object.serie_cri [row] = gnvo_app.il_null
			f_Mensaje('La empresa no esta asignada como agente de retención, no es posible seleccionar una serie de Comprobante de retención', '')
			return
		end if
		
		select count(*)
			into :ll_count
		from 	doc_tipo_usuario dtu, 
				num_doc_tipo     ndt, 
				doc_tipo			  dt 
		where ndt.tipo_doc    = dtu.tipo_doc 
		  and ndt.nro_serie   = dtu.nro_serie
		  and dt.tipo_doc     = dtu.tipo_doc 
		  and dt.tipo_doc 	 = :gnvo_app.is_doc_ret 
		  and dtu.cod_usr     = :gs_user
		  and dt.flag_estado  = '1';
		
		if ll_count = 0 then
			this.object.serie_cri 	[row] = gnvo_app.is_null
			Messagebox('Aviso','Serie de Comprobante de Retencion no existe o no tiene permiso para usarlo, por favor Verifique!')
			return 1
		end if
		
		this.object.serie_cri 	[row] = data
			
		/*Generacion de Asientos*/
	 	ib_estado_asiento = true					
		
					
	CASE 'cod_ctabco'
		select cod_ctabco, descripcion, cnta_ctbl, cod_moneda, saldo_disponible 
			  into :ls_ctabco, :ls_descripcion, :ls_cta_cntbl, :ls_cod_moneda, :ldc_saldo
		from banco_cnta
		where cod_ctabco = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			this.object.cod_ctabco             			[row] = gnvo_app.is_null
			this.object.desc_banco_cnta		 			[row] = gnvo_app.is_null
			this.object.cnta_ctbl				  			[row] = gnvo_app.is_null
			this.object.banco_cnta_cod_moneda  			[row] = gnvo_app.is_null	
			this.object.banco_cnta_saldo_disponible  	[row] = gnvo_app.idc_null
	
	
			/*actualizo moneda de transacion*/
			This.object.cod_moneda  [row]	= ls_cod_moneda
			
			wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
			
			This.Object.imp_total 	[row] =	of_recalcular_monto_det()
			This.Object.importe_cri [row] =	of_recalcular_ret_igv()
	
			Messagebox('Aviso','Cuenta de Banco No Existe o no esta activo, por favor Verifique!')
			Return 1
		end if
			
		
	
		this.object.cod_ctabco             			[row] = ls_ctabco
		this.object.banco_cnta_descripcion 			[row] = ls_descripcion
		this.object.cnta_ctbl				  			[row] = ls_cta_cntbl
		this.object.banco_cnta_cod_moneda  			[row] = ls_cod_moneda	
		this.object.banco_cnta_saldo_disponible  	[row] = ldc_saldo


		/*actualizo moneda de transacion*/
		This.object.cod_moneda  [row]	= ls_cod_moneda
	
		ldc_tasa_cambio = This.object.tasa_cambio [row]
		
		
		// Actualiza Tipo de Moneda y Tasa Cambio
		wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
		
		This.Object.imp_total 	[row] =	of_recalcular_monto_det()
		This.Object.importe_cri [row] =	of_recalcular_ret_igv()
		
	CASE 'tasa_cambio'
		ls_cod_moneda   = This.object.cod_moneda  [row]	
		ldc_tasa_cambio = This.object.tasa_cambio [row]
		
		// Actualiza Tipo de Moneda y Tasa Cambio
		wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
		This.Object.imp_total 	[row] =	of_recalcular_monto_det()				
		This.Object.importe_cri [row] =	of_recalcular_ret_igv()
		
	CASE	'fecha_emision'
		ld_fecha_emision = date(this.object.fecha_emision[row])
		ll_year 	= Long(String(ld_fecha_emision,'yyyy'))
		ll_mes	= Long(String(ld_fecha_emision,'mm'))
		
		if not invo_asiento_contable.of_val_mes_cntbl( ll_year, ll_mes, "B") then
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
		This.Object.imp_total 	[row] =	of_recalcular_monto_det()	
		This.Object.importe_cri [row] =	of_recalcular_ret_igv()
	
		
	CASE 'cod_relacion'
		
		SELECT p.nom_proveedor, nvl(p.flag_padron_sunat, '0')
			INTO :ls_nom_proveedor, :ls_flag_padron_sunat
		FROM proveedor p
		WHERE p.proveedor = :data 
		  and p.flag_estado = '1';

		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Codigo de proveedor No Existe o no esta activo, por favor verifique!')
			This.Object.cod_relacion 	  	[row] = gnvo_app.is_null
			this.object.flag_padron_sunat	[row] = '0'
			Return 1
		end if

		This.Object.nom_proveedor    	[row]   = ls_nom_proveedor
		This.Object.flag_padron_sunat	[row]   = ls_flag_padron_sunat
	
	CASE	'fecha_emision'	
		ld_fecha_emision = Date(This.object.fecha_emision  [row]	)
		ls_cod_moneda    = This.object.cod_moneda  [row]	
		This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
		ldc_tasa_cambio = This.object.tasa_cambio [row]
		
		// Actualiza Tipo de Moneda y Tasa Cambio
		wf_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
		This.Object.imp_total 		[row] =	of_recalcular_monto_det()								
		This.Object.importe_cri 	[row] =	of_recalcular_ret_igv()
		
	CASE 'confin'
		SELECT matriz_cntbl,descripcion
		  INTO :ls_matriz,:ls_descripcion
		  FROM concepto_financiero
		 WHERE confin = :data 
		   and flag_estado = '1';
		 
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Concepto Financiero No existe Verifique')
			This.Object.confin 			[row] = gnvo_app.is_null
			This.Object.descripcion 	[row] = gnvo_app.is_null
			This.object.matriz_cntbl 	[row] = gnvo_app.is_null
			Return 1
		end if
	
		This.object.matriz_cntbl [row] = ls_matriz
		This.object.descripcion  [row] = ls_descripcion
	
		
	CASE 'flag_pago'
		if data = 'C' then
			cb_genera_cheque.enabled = true
		else
			cb_genera_cheque.enabled = false
		end if
	
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
				
				IF data = 'TLC' then
					cb_gen_tlc.enabled = true
				ELSE
					cb_gen_tlc.enabled = false
				END IF

END CHOOSE				
				






end event

event ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_today

ib_cierre = false
dw_master.object.t_cierre.text = ''

ldt_today = gnvo_app.of_fecha_actual()

This.Object.origen 		      [al_row] = gs_origen
This.Object.cod_usr 		      [al_row] = gs_user
This.Object.nro_libro	      [al_row] = gnvo_app.finparam.il_libro_pagos
This.Object.fecha_emision     [al_row] = Date(ldt_today)
This.Object.fec_registro     	[al_row] = ldt_today
This.Object.tasa_cambio       [al_row] = gnvo_app.finparam.of_tasa_cambio( )
This.Object.ano			      [al_row] = Long(String(ldt_today,'YYYY'))
This.Object.mes			      [al_row] = Long(String(ldt_today,'MM'))
This.Object.flag_estado       [al_row] = '1'
This.Object.flag_tiptran      [al_row] = '2' //cartera de pagos
This.Object.flag_conciliacion [al_row] = '1' //falta conciliar
this.object.flag_padron_sunat	[al_row]	= '0'
//

if gnvo_app.finparam.is_flag_embargo_tele = '1' then
	cb_rcem.enabled = true
else
	cb_rcem.enabled = false
end if

cb_genera_cheque.enabled = false
is_action = 'new'
end event

event ue_display;call super::ue_display;IF Getrow() = 0 THEN Return

String 	ls_name,ls_prot, ls_codigo, ls_data, ls_data2, ls_data3, ls_data4, ls_sql, &
			ls_flag_padron_sunat, ls_ruc
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
			This.Object.imp_total 	[al_row] =	of_recalcular_monto_det()
			This.Object.importe_cri [al_row] =	of_recalcular_ret_igv()
					
			this.ii_update = 1
					
			/*Generacion de Asientos*/
			ib_estado_asiento = true					
					
		END IF	
				
	CASE 'cod_relacion'
		ls_sql = "SELECT P.Proveedor     AS CODIGO_PROVEEDOR ,"&
				 + "P.NOM_PROVEEDOR AS NOMBRES, "&
				 + "P.RUC as RUC_PROVEEDOR, " &
				 + "NVL(p.flag_padron_Sunat, '0') as flag_padron_sunat " &
				 + "FROM PROVEEDOR P " &
				 + "WHERE ((p.proveedor like 'E%' and P.FLAG_ESTADO ='1') or (p.proveedor not like 'E%') )"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_ruc, ls_flag_padron_sunat, "2")
		
		if ls_codigo <> "" then
			this.object.cod_relacion 		[al_row] = ls_codigo
			this.object.nom_proveedor		[al_row] = ls_data
			this.object.flag_padron_sunat	[al_row] = ls_flag_padron_sunat
			
			parent.of_padron_sunat( )
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
			
			IF ls_codigo = 'TLC ' then
				cb_gen_tlc.enabled = true
			ELSE
				cb_gen_tlc.enabled = false
			END IF
		
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = true					
		  
		END IF	

	CASE 'serie_cri'
		if gnvo_app.is_agente_ret = '0' then
			f_Mensaje('La empresa no esta asignada como agente de retención, no es posible seleccionar una serie de Comprobante de retención', '')
			return
		end if
		
		ls_sql = "select dtu.tipo_doc as tipo_doc, " &
				 + "ndt.nro_serie as numero_serie, " &
				 + "ndt.ultimo_numero as ultimo " &
				 + "from doc_tipo_usuario dtu, " &
				 + "     num_doc_tipo     ndt, " &
				 + "     doc_tipo			  dt " &
				 + "where ndt.tipo_doc    = dtu.tipo_doc " &
				 + "  and ndt.nro_serie   = dtu.nro_serie" &
				 + "  and dt.tipo_doc     = dtu.tipo_doc " &
				 + "  and dt.tipo_doc 	  = '"+ gnvo_app.is_doc_ret + "'" &
				 + "  and dtu.cod_usr     = '" + gs_user + "'" &
				 + "  and dt.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.serie_cri 	[al_row] = ls_data
			
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = true					
		  
		END IF			
														
		
END CHOOSE



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

event buttonclicked;call super::buttonclicked;if row= 0 then return

choose case lower(dwo.name)
	case "b_padron_sunat"
		parent.of_padron_sunat( )
end choose

end event

