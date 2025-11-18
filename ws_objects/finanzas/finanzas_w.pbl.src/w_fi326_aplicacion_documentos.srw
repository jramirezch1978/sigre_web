$PBExportHeader$w_fi326_aplicacion_documentos.srw
forward
global type w_fi326_aplicacion_documentos from w_abc
end type
type dw_rpt from datawindow within w_fi326_aplicacion_documentos
end type
type rb_v from radiobutton within w_fi326_aplicacion_documentos
end type
type rb_cr from radiobutton within w_fi326_aplicacion_documentos
end type
type cb_retenciones from commandbutton within w_fi326_aplicacion_documentos
end type
type tab_1 from tab within w_fi326_aplicacion_documentos
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
type tab_1 from tab within w_fi326_aplicacion_documentos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_1 from commandbutton within w_fi326_aplicacion_documentos
end type
type dw_master from u_dw_abc within w_fi326_aplicacion_documentos
end type
type gb_1 from groupbox within w_fi326_aplicacion_documentos
end type
end forward

global type w_fi326_aplicacion_documentos from w_abc
integer width = 3813
integer height = 1828
string title = "[FI326] Aplicacion de Documentos"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
event ue_print_voucher ( )
event ue_print_detra ( )
dw_rpt dw_rpt
rb_v rb_v
rb_cr rb_cr
cb_retenciones cb_retenciones
tab_1 tab_1
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_fi326_aplicacion_documentos w_fi326_aplicacion_documentos

type variables
String 					is_soles, is_dolar, is_cnta_prsp, is_doc_ret, is_agente_ret
Boolean 					ib_estado_asiento = TRUE, ib_cierre = false
Decimal					idc_tasa_retencion

n_cst_asiento_contable 	invo_asiento_cntbl
n_cst_cri					invo_cri
n_cst_caja_bancos			invo_caja_bancos

DatawindowChild 		idw_doc_tipo
Datastore 				ids_asiento_adic, ids_crelacion_ext_tbl
u_dw_abc					idw_detail, idw_asiento_cab, idw_asiento_det

end variables

forward prototypes
public subroutine wf_verificacion_items_x_retencion ()
public subroutine wf_verificacion_retencion ()
public function boolean wf_genera_cretencion (long al_nro_serie, ref string as_mensaje, ref string as_nro_doc)
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, long al_nro_registro, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado)
public subroutine of_asigna_dws ()
public function integer of_get_param ()
public function decimal of_recalcular_monto_det ()
public function decimal of_recalcular_ret_igv ()
public subroutine of_retrieve (string as_origen, long al_nro_registro)
public function boolean of_generacion_asiento ()
public subroutine of_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio)
end prototypes

event ue_anular;Integer li_opcion
String  ls_flag_estado ,ls_origen_cb  ,ls_result ,ls_mensaje
Long    ll_row_master  ,ll_nro_reg_cb ,ll_ano	 ,ll_mes		 ,&
        ll_inicio

if dw_master.getRow() = 0 then return

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if


ll_row_master  = dw_master.getrow()

ls_origen_cb	= dw_master.Object.origen		  [ll_row_master]
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
   SET flag_estado = '0' ,flag_replicacion = '1'
 WHERE ((origen           = :ls_origen_cb ) AND
        (nro_reg_caja_ban = :ll_nro_reg_cb )) ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Update Retencion IGV CRT', SQLCA.SQLErrText)
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
is_action = 'delete'
/*No  Generación de Pre Asientos*/
ib_estado_asiento = FALSE
/**/
end event

event ue_print_voucher();String 		ls_origen,ls_nro_certificado, ls_ruc, ls_razonsocial
Long   		ll_nro_registro,ll_row_master
Double		ldb_rc
str_parametros	lstr_param
u_ds_base	lds_voucher

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update 			= 1 OR &
	idw_detail.ii_update 		= 1 OR &
	idw_asiento_cab.ii_update 		= 1 OR &
   idw_asiento_det.ii_update 	= 1 then 
	Messagebox('Aviso','Debe Grabar Los Cambios Verifique! ')	
	Return
END IF	

Open(w_print_preview)
lstr_param = Message.PowerObjectParm

if lstr_param.i_return < 0 then return

ls_origen	    = dw_master.object.origen       [ll_row_master]
ll_nro_registro = dw_master.object.nro_registro [ll_row_master]	

if lstr_param.i_return = 1 then
	
	try 
		/*asignacion de dw*/
		lds_voucher = Create u_ds_base
		lds_voucher.DataObject = 'd_rpt_formato_aplicacion_tbl'
		lds_voucher.SettransObject(sqlca)
	
		lds_voucher.retrieve(ls_origen,ll_nro_registro)
		if lds_voucher.rowcount() = 0 then 
			gnvo_app.of_mensaje_error('El registro ' + ls_origen + '-' + string(ll_nro_registro) + ' no tiene un Voucher activo, por favor Verifique!')
			return
		end if
	
		lds_voucher.Object.p_logo.filename = gs_logo
		lds_voucher.Object.t_titulo1.Text = 'APLICACIÓN DE DOCUMENTOS'
		lds_voucher.Print(True)
		
	catch ( Exception ex)
		gnvo_app.of_mensaje_error("Error, ha ocurrido una exception: " + ex.getMessage())
		
	finally
		destroy lds_voucher
	end try
	
	
else
	lstr_param.dw1 		= 'd_rpt_formato_aplicacion_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.long1 		= ll_nro_registro
	lstr_param.titulo		= 'APLICACION DE DOCUMENTOS'
	lstr_param.tipo		= '1S1L'

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if





end event

event ue_print_detra();gnvo_app.of_mensaje_error("Opción de impresión no está disponible, por favor verifique!")
end event

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
Decimal		ldc_imp_min_ret_igv,ldc_porc_ret_igv   ,ldc_imp_pagar    ,ldc_total_pagar,&
				ldc_imp_total      ,ldc_imp_total_pagar,ldc_imp_retencion, ldc_tasa_cambio
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

public subroutine of_asigna_dws ();idw_detail = tab_1.tabpage_1.dw_detail
idw_asiento_cab = tab_1.tabpage_2.dw_asiento_cab
idw_asiento_det = tab_1.tabpage_2.dw_asiento_det

end subroutine

public function integer of_get_param ();/*PARAMETRO DE SOLES*/
select 	cod_soles, cod_dolares
	into 	:is_soles, :is_dolar
from logparam 
where reckey = '1' ;

select 	porc_ret_igv,			cntas_prsp_gfinan,	doc_ret_igv_crt, 	NVL(flag_retencion,'0')
	into 	:idc_tasa_retencion,	:is_cnta_prsp,			:is_doc_ret, 		:is_agente_ret
from finparam 
where reckey = '1' ;

if is_agente_ret = '0' then
	cb_retenciones.enabled = false
end if

return 1
end function

public function decimal of_recalcular_monto_det ();String 	ls_moneda_ref,ls_moneda_cab
Long   	ll_inicio,ll_factor
Decimal 	ldc_importe_total,ldc_importe_ref,ldc_importe_ret, ldc_tasa_cambio


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

public subroutine of_retrieve (string as_origen, long al_nro_registro);Long		ll_year, ll_mes, ll_nro_libro, ll_nro_Asiento, ll_inicio, ll_factor, ll_count
String	ls_origen, ls_cta_ctbl, ls_flag_provisionado, ls_cod_relacion, &
			ls_tipo_doc, ls_nro_doc, ls_flag_tabla, ls_doc_sgiro, ls_flag_ctrl_reg


dw_master.Retrieve(as_origen, al_nro_registro,'4')

if dw_master.RowCount() = 0 then return

//Obtengo los datos para recuperar el asiento contable
ls_origen 		= dw_master.object.origen 				[1]
ll_year 			= Long(dw_master.object.ano 			[1])
ll_mes 			= Long(dw_master.object.mes 			[1])
ll_nro_libro 	= Long(dw_master.object.nro_libro 	[1])
ll_nro_asiento = Long(dw_master.object.nro_asiento [1])

//Verifico Cierre contable
if invo_asiento_cntbl.of_mes_cerrado( ll_year, ll_mes, "B") then
	ib_cierre = true
	dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	dw_master.object.t_cierre.text = ''
	ib_cierre = false
end if

select doc_sol_giro into :ls_doc_sgiro from finparam where reckey = '1' ;

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
	
/*asociacion de moneda de cabecera*/
IF dw_master.rowcount()  > 0 THEN
	ls_cta_ctbl		 = dw_master.object.cnta_ctbl   [dw_master.getrow()]
	
	For ll_inicio = 1 to idw_detail.Rowcount()
		 
		 ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
		 ls_cod_relacion		 = idw_detail.object.cod_relacion		[ll_inicio]
		 ls_tipo_doc			 = idw_detail.object.tipo_doc				[ll_inicio]
		 ls_nro_doc				 = idw_detail.object.nro_doc       		[ll_inicio]
		 ll_factor				 = idw_detail.object.factor       		[ll_inicio]
		 ls_flag_tabla			 = idw_detail.object.flab_tabor    		[ll_inicio]
		 
		 IF ls_flag_provisionado = 'N' THEN
			 //*ingresos indirectos PARTIDA EDITABLE*//
			 idw_detail.object.flag_partida [ll_inicio] = '1'
		 END IF
		 
		 //verificar condiciones de documentos
		 IF ls_tipo_doc = ls_doc_sgiro THEN
			 idw_detail.object.t_tipdoc [ll_inicio] = gnvo_app.is_null
		 ELSE
			 //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
			 select count(*) into :ll_count from doc_grupo_relacion dg 
			  where (dg.grupo    = 'C2'         ) and
					  (dg.tipo_doc = :ls_tipo_doc ) ;
		 
			 if (ll_count > 0 AND ls_flag_provisionado = 'D' AND ll_factor = 1 AND ls_flag_tabla = '3') then
				 select cp.flag_control_reg into :ls_flag_ctrl_reg
					from cntas_pagar cp
				  where (cp.cod_relacion = :ls_cod_relacion) and
						  (cp.tipo_doc     = :ls_tipo_doc    ) and
						  (cp.nro_doc      = :ls_nro_doc     ) ;
			 
				 if ls_flag_ctrl_reg = '1' then
					 idw_detail.object.t_tipdoc [ll_inicio] = gnvo_app.is_null
				 else
					 idw_detail.object.t_tipdoc [ll_inicio] = '1'	
				 end if
			 else
				 idw_detail.object.t_tipdoc [ll_inicio] = '1'	
			 end if				 
			 
		 END IF			
		 
	Next
END IF
	
is_action = 'fileopen'
ib_estado_asiento = FALSE

end subroutine

public function boolean of_generacion_asiento ();Boolean lb_ret = TRUE
/*generacion de cntas*/

IF invo_asiento_cntbl.of_generar_asiento_cb (dw_master         , &
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
END IF	



Return lb_ret
end function

public subroutine of_act_datos_detalle (string as_moneda, decimal adc_tasa_cambio);Long   ll_inicio
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

on w_fi326_aplicacion_documentos.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.dw_rpt=create dw_rpt
this.rb_v=create rb_v
this.rb_cr=create rb_cr
this.cb_retenciones=create cb_retenciones
this.tab_1=create tab_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rpt
this.Control[iCurrent+2]=this.rb_v
this.Control[iCurrent+3]=this.rb_cr
this.Control[iCurrent+4]=this.cb_retenciones
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
end on

on w_fi326_aplicacion_documentos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rpt)
destroy(this.rb_v)
destroy(this.rb_cr)
destroy(this.cb_retenciones)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;of_Asigna_dws()
of_get_param()

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_asiento_cab.SetTransObject(sqlca)
idw_asiento_det.SetTransObject(sqlca)



idw_1 = dw_master              				             // asignar dw corriente
idw_detail.BorderStyle = StyleRaised!	 // indicar dw_detail como no activado

//crea objeto
invo_asiento_cntbl 	= create n_cst_asiento_contable
invo_caja_bancos		= create n_cst_caja_bancos
invo_cri					= create n_cst_cri


/*Datastore de Generacion de Cuentas*/
//** Datastore Detalle Asiento **//
ids_asiento_adic 			   = Create Datastore
ids_asiento_adic.DataObject = 'd_abc_datos_asiento_x_doc_tbl'
ids_asiento_adic.SettransObject(sqlca)
//** **//

//** Datastore de datawindow Externo**//
ids_crelacion_ext_tbl = Create Datastore
ids_crelacion_ext_tbl.DataObject = 'd_abc_ext_codigo_tbl'
ids_crelacion_ext_tbl.SettransObject(sqlca)
//** **//


end event

event ue_insert;call super::ue_insert;Long   ll_row
String ls_cod_moneda
Decimal ldc_tasa_cambio

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

if idw_1 <> dw_master then
	if ib_cierre then 
		Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
		return
	end if
end if

IF idw_1 = tab_1.tabpage_2.dw_asiento_det THEN RETURN

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
   
   /*Generacion de Asientos*/
	ib_estado_asiento = true		
	
ELSE
	triggerevent('ue_update_request')
	
	IF ib_update_check = False THEN RETURN
	//cabecera
	is_action = 'new'
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_asiento_cab.Reset()
	tab_1.tabpage_2.dw_asiento_det.Reset()
	
	/*Genera Asientos */
	ib_estado_asiento = TRUE	
	
	/*ACTIVO VERIFICACION DE RETENCIONES*/
	cb_retenciones.Enabled = TRUE
END IF	

ll_row = idw_1.Event ue_insert()
	
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
end event

event resize;call super::resize;of_Asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width       = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height       = tab_1.tabpage_1.height  - idw_detail.y - 10

idw_asiento_det.width  = tab_1.tabpage_1.width  - idw_asiento_det.x - 10
idw_asiento_det.height = tab_1.tabpage_1.height - idw_asiento_det.y - 10


end event

event ue_update_pre;call super::ue_update_pre;Long   		ll_ano	, ll_mes			, ll_nro_registro	, ll_inicio	, ll_found	, ll_ins_new	,&
		 		ll_item	, ll_nro_libro	, ll_nro_asiento	, ll_row
String 		ls_mensaje     , ls_cod_origen 	, ls_flag_retencion 	,ls_serie_cri ,ls_flag_estado	,&
		 		ls_expresion 	, ls_cod_relacion , ls_nro_ret    		,ls_tipo_doc  ,ls_nro_doc		,&
				ls_cod_moneda 	, ls_cod_usr		, ls_obs
Decimal 		ldc_importe_total	, ldc_totsoldeb	, ldc_totdoldeb	,ldc_totsolhab,ldc_totdolhab, ldc_tasa_cambio, &
				ldc_imp_cri
Datetime    ldt_fecha_cntbl


try 
	
	ib_update_check = false
	
	IF dw_master.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Registro en la Cabecera', StopSign!)
		Return
	END IF
	
	IF gnvo_app.of_row_Processing( dw_master ) <> true then return 
	IF gnvo_app.of_row_Processing( idw_detail ) <> true then return
	IF gnvo_app.of_row_Processing( idw_asiento_cab ) <> true then return
	IF gnvo_app.of_row_Processing( idw_asiento_det ) <> true then return
	
	
	/*datos de cabecera*/
	ll_ano            = dw_master.object.ano            	[dw_master.getrow()]
	ll_mes            = dw_master.object.mes            	[dw_master.getrow()]
	ll_nro_libro		= dw_master.object.nro_libro      	[dw_master.getrow()]
	ll_nro_asiento		= dw_master.object.nro_asiento    	[dw_master.getrow()]
	ls_cod_origen     = dw_master.object.origen		  	 	[dw_master.getrow()]				 
	ll_nro_registro   = dw_master.object.nro_registro	 	[dw_master.getrow()]				 
	ls_flag_retencion = dw_master.object.flag_retencion 	[dw_master.getrow()]
	ls_serie_cri		= dw_master.object.serie_cri		 	[dw_master.getrow()]
	ls_flag_estado		= dw_master.object.flag_estado    	[dw_master.getrow()]
	ldc_importe_total	= dw_master.object.imp_total	    	[dw_master.getrow()]
	ldt_fecha_cntbl	= dw_master.object.fecha_emision  	[dw_master.getrow()]
	ls_cod_moneda		= dw_master.object.cod_moneda     	[dw_master.getrow()]
	ldc_tasa_cambio	= dw_master.object.tasa_cambio	 	[dw_master.getrow()]
	ls_cod_usr			= dw_master.object.cod_usr 	 	 	[dw_master.getrow()]
	ls_flag_estado	   = dw_master.object.flag_estado    	[dw_master.getrow()]
	ls_nro_ret			= dw_master.object.nro_certificado	[dw_master.getRow()]
	ls_obs				= dw_master.object.obs					[dw_master.getRow()]
	
	
	/*verifica cierre*/
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'B') then return //movimiento bancario
	
	//Verifico que la aplicación tenga una glosa de todas maneras
	if IsNull(ls_obs) or trim(ls_obs) = '' then
		Messagebox('Aviso','Debe ingresar alguna observación para esta aplicación, por favor corrija', StopSign!)
		dw_master.setFocus()
		dw_master.setColumn('obs')
		return
	end if
	
	//Verifico si tiene o no flag de retencion
	ls_flag_retencion = '0'
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		if idw_detail.object.flag_ret_igv [ll_inicio] = '1' then
			ls_flag_retencion = '1'
		END IF
	NEXT
	
	if ls_flag_retencion = '1' and is_agente_ret = '0' then
		Messagebox('Aviso','Usted no es agente de retención para generar CERTIFICADO DE RETENCIÓN, elija la opción NO en retención, por favor verifique!')
		Return	
	end if
	
	/*verificar tipo de serie en retenciones*/
	IF ls_flag_retencion = '1' THEN //GENERAR COMPROBANTE DE RETENCION
		IF Isnull(ls_serie_cri) OR Trim(ls_serie_cri) = '' THEN
			Messagebox('Aviso','Ingrese Serie de Comprobante de Retencion')
			Return
		END IF
	END IF	
	
	/*importe del documento > 0*/
	IF ls_flag_estado <> '0' THEN
		IF ldc_importe_total <> 0 THEN
			Messagebox('Aviso','Importe del Documento debe ser igual a cero')
			Return
		END IF
	END IF
	
	
	IF idw_detail.Rowcount() = 0  AND is_action <> 'delete' THEN
		Messagebox('Aviso','Debe Ingresar Registro en el Detalle , Verifique!')
		Return
	END IF

	IF ls_flag_retencion = '1' THEN /*flag de retencion de cabecera*/
		
		/*eliminar informacion de tabla temporal*/
		ids_crelacion_ext_tbl.Reset()
	
		//**separar los codigos de relacion**//
		ldc_imp_cri = 0
		FOR ll_inicio = 1 TO idw_detail.Rowcount()
			if idw_detail.object.flag_ret_igv [ll_inicio] = '1' then
				ls_cod_relacion = idw_detail.object.cod_relacion [ll_inicio]
			 	ls_expresion = "cod_relacion = '"+ls_cod_relacion+"'"
			 	ll_found = ids_crelacion_ext_tbl.find(ls_expresion,1,ids_crelacion_ext_tbl.Rowcount())
			 	IF ll_found = 0 THEN
					ll_ins_new = ids_crelacion_ext_tbl.InsertRow(0)
				 	ids_crelacion_ext_tbl.object.cod_relacion[ll_ins_new] = ls_cod_relacion
			 	END IF
			 
			 	ldc_imp_cri += Dec(idw_detail.object.impt_ret_igv [ll_inicio])
			end if
		NEXT
		
		dw_master.object.importe_cri[dw_master.getRow()] = ldc_imp_cri
	
		// Solo debe haber un solo proveedor para la retención
		if ids_crelacion_ext_tbl.RowCount() > 1 then
			ROLLBACK;
			Messagebox('Aviso','Solo se debe hacer retención de un solo proveedor, y ha seleccionado ' + string(ids_crelacion_ext_tbl.RowCount()) &
									+ ' proveedores diferentes en este Registro de Caja, por favor verifique')
			Return
		end if
		
		
		/***generar numero para comprobantes de retencion***/
		if is_action = "new"  then
			if IsNull(ls_nro_ret) or trim(ls_nro_ret) = '' then
				FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount() 
					//Asignación  de Nro de Serie
					 
					IF invo_cri.of_get_nro_cri(ls_serie_cri, ls_nro_ret) = FALSE THEN
						ROLLBACK;
						if trim(ls_mensaje) <> '' then
							Messagebox('Aviso',ls_mensaje)
						end if
						RETURN
					END IF		 
			
					/*ASIGNACION DE NUMERO DE C. RETENCION X C.RELACION*/
					ids_crelacion_ext_tbl.object.nro_cr 	[ll_inicio] = ls_nro_ret
					dw_master.object.nro_certificado			[dw_master.getRow()] = ls_nro_ret
					 
				NEXT
			end if
		else
			ls_nro_ret = dw_master.object.nro_certificado [dw_master.getRow()] 
		end if
	END IF /*END de flag de retencion de cabecera*/
	
	//Generación del correlativo de asientos y del numero de registros de caja
	IF is_action = "new" then
	
		Setnull(ll_nro_registro)
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
		IF invo_asiento_cntbl.of_get_nro_asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, &
				ll_nro_asiento)  = FALSE THEN return
		
		//cabecera de asiento
		dw_master.object.nro_asiento 			[dw_master.getRow()] = ll_nro_asiento
		if idw_asiento_cab.RowCount() = 0 then
			ll_row = idw_asiento_cab.event ue_insert()
		else
			ll_row = idw_asiento_cab.getRow()
		end if
		
		if ll_row > 0 then
			idw_asiento_cab.Object.origen      [ll_row] = ls_cod_origen
			idw_asiento_cab.Object.ano 		  [ll_row] = ll_ano
			idw_asiento_cab.Object.mes 		  [ll_row] = ll_mes
			idw_asiento_cab.Object.nro_libro   [ll_row] = ll_nro_libro
			idw_asiento_cab.Object.nro_asiento [ll_row] = ll_nro_asiento	
		end if

	end if
	
	
	
	//generacion de asientos automaticos
	IF ib_estado_asiento THEN
		IF of_generacion_asiento () = FALSE THEN return
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
	
	
	//Actualizando los datos en la cabecera del asiento
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
	idw_asiento_cab.Object.desc_glosa   [1] = ls_obs
	
	// valida asientos descuadrados
	if not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then
		ROLLBACK;
		Return
	END IF
	
	IF dw_master.ii_update = 1 OR idw_asiento_det.ii_update = 1 THEN 
		idw_asiento_det.ii_update = 1
		idw_asiento_cab.ii_update = 1
	END IF
	
	
	dw_master.of_set_flag_replicacion()
	idw_detail.of_set_flag_replicacion()
	idw_asiento_cab.of_set_flag_replicacion()
	idw_asiento_det.of_set_flag_replicacion()
	
	ib_update_check = True
	
Catch(exception ex)
	ROLLBACK;
	f_mensaje(ex.getMessage(), '')
	ib_update_check = False	
	RETURN
end try
	

end event

event ue_update;call super::ue_update;Long     ll_row_det     ,ll_ano       ,ll_mes          ,ll_nro_libro ,&
         ll_nro_asiento ,ll_row_master,ll_nro_registro ,ll_inicio		
String   ls_origen   ,ls_flag_retencion ,ls_cod_relacion , ls_nro_cr,&
			ls_flag_provisionado, ls_mensaje
Boolean  lbo_ok = TRUE
Datetime ldt_fecha_doc
Decimal 	ldc_tasa_cambio	
Decimal 	ldc_imp_ret_sol,ldc_imp_ret_dol


dw_master.AcceptText()
idw_detail.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


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

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if

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



//IF ls_flag_retencion = '1' THEN /*cabecera*/
//	FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount()
//		ls_cod_relacion = ids_crelacion_ext_tbl.object.cod_relacion [ll_inicio]
//		ls_nro_cr	    = ids_crelacion_ext_tbl.object.nro_cr       [ll_inicio]
//	 
//	   /*encontrar monto de cri x proveedor*/
//		f_monto_cri_x_prov(idw_detail,ls_cod_relacion,ldc_tasa_cambio,ldc_imp_ret_sol,ldc_imp_ret_dol)
//		
//		
//		
//	   
//		/*SE GENERA COMPROBANTE DE RETENCION*/
//		INSERT INTO retencion_igv_crt(
//				nro_certificado,fecha_emision,origen    ,nro_reg_caja_ban,
//		 		proveedor      ,flag_estado  ,flag_tabla,importe_doc     ,
//		 		saldo_sol		 ,saldo_dol    ,flag_replicacion)  
//		VALUES(	
//				:ls_nro_cr       ,:ldt_fecha_doc  ,:ls_origen ,:ll_nro_registro,
//	     	 	:ls_cod_relacion ,'1'			     ,'5'			 ,:ldc_imp_ret_sol,
//		 		:ldc_imp_ret_sol ,:ldc_imp_ret_dol,'1'	)  ;
//	   
//		
//		IF SQLCA.SQLCode = -1 THEN 
//			ls_mensaje = SQLCA.SQLErrText
//			ROLLBACK;
//			f_mensaje("Error al generar CRI " + ls_nro_cr + ": " + ls_mensaje, '')
//			lbo_ok = false
//			exit
//		END IF
//		
//	 
//	NEXT
//END IF

IF lbo_ok THEN
	/*Datos de Retencion*/
	if invo_cri.of_update(dw_master, idw_detail, ids_crelacion_ext_tbl) = false then
		Rollback using SQLCA;
		lbo_ok = false
	end if
	
	if ib_log and lbo_ok then
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_asiento_cab.of_save_log()
		lbo_ok = idw_asiento_det.of_save_log()
	end if
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update 			= 0
	idw_detail.ii_update 		= 0
	idw_asiento_cab.ii_update 	= 0
	idw_asiento_det.ii_update 	= 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()
	
	/*No Genera Asientos */
	ib_estado_asiento = FALSE
		

	/* actualiza valores flag detalle */
	for ll_inicio = 1 to idw_detail.Rowcount()
		 idw_detail.object.flag_doc     	    [ll_inicio] = gnvo_app.is_null
		 
		 ls_flag_provisionado = idw_detail.object.flag_provisionado [ll_inicio]
		 
		 IF ls_flag_provisionado = 'N' THEN
			 idw_detail.object.flag_partida [ll_inicio] = '1'
		 END IF

	next

	/*setear flag de retencion*/
	SetNull(ls_flag_retencion)
	dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
	
	is_action = 'fileopen'
	
	
	triggerEvent('ue_modify')
	f_mensaje("Grabación realizada satisfactoriamente", '')
	
ELSE
	Rollback using SQLCA;
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;str_parametros sl_param

TriggerEvent ('ue_update_request')

sl_param.dw1     = 'd_abc_aplicacion_documentos_tbl'
sl_param.titulo  = 'Aplicacion de Documentos'
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
dw_master.object.imp_total [dw_master.getrow()] = of_recalcular_monto_det ()
dw_master.ii_update = 1

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

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

event ue_modify;call super::ue_modify;String ls_flag_estado,ls_origen
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


/*Verificación de comprobante de retencion*/
SELECT Count(*) INTO :ll_count FROM retencion_igv_crt 
WHERE ((origen           = :ls_origen		  ) AND
		 (nro_reg_caja_ban = :ll_nro_registro ));

IF ll_count > 0 THEN
	cb_retenciones.Enabled = FALSE
ELSE
	cb_retenciones.Enabled = TRUE
END IF


IF ls_flag_estado <> '1' OR ll_count > 0 THEN
	dw_master.ii_protect = 0
	dw_master.of_protect()	
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	tab_1.tabpage_1.dw_detail.of_protect()	
	tab_1.tabpage_2.dw_asiento_det.ii_protect = 0
	tab_1.tabpage_2.dw_asiento_det.of_protect()	
	
	IF ls_flag_estado = '1' THEN
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
	
	IF is_action <> 'new' THEN
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
end event

event ue_delete_pos;call super::ue_delete_pos;ib_estado_asiento = TRUE
end event

event ue_print;call super::ue_print;String 	ls_origen,ls_nro_certificado, ls_ruc, ls_razonsocial
Long   	ll_nro_registro,ll_row_master, ll_count
Double	ldb_rc

str_parametros	lstr_param
u_ds_base		lds_voucher

try 
	ll_row_master = dw_master.Getrow()
	
	IF ll_row_master = 0 THEN RETURN
	
	IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
		tab_1.tabpage_2.dw_asiento_det.ii_update = 1 then //OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 THEN 
		Messagebox('Aviso','Debe Grabar Los Cambios Verifique! ')	
		Return
	END IF	
	
	
	ls_origen	    = dw_master.object.origen       [ll_row_master]
	ll_nro_registro = dw_master.object.nro_registro [ll_row_master]	

	lds_voucher = Create u_ds_base
	
	/*******************/
	IF rb_v.checked THEN
		
			/*asignacion de dw*/
			
			lds_voucher.DataObject = 'd_rpt_formato_aplicacion_tbl'
			lds_voucher.SettransObject(sqlca)
		
			lds_voucher.retrieve(ls_origen,ll_nro_registro)
			if lds_voucher.rowcount() = 0 then 
				gnvo_app.of_mensaje_error('El registro ' + ls_origen + '-' + string(ll_nro_registro) + ' no tiene un Voucher activo, por favor Verifique!')
				return
			end if
		
			lds_voucher.Object.p_logo.filename = gs_logo
			lds_voucher.Object.t_titulo1.Text = 'APLICACIÓN DE DOCUMENTOS'
			
			IF gs_empresa = 'FISHOLG' then
				lds_voucher.Object.DataWindow.Print.Paper.Size = 256 
				lds_voucher.Object.DataWindow.Print.CustomPage.Width = 210
				lds_voucher.Object.DataWindow.Print.CustomPage.Length = 148
			END IF
	
			lds_voucher.Print(True)
			
		
	ELSEIF rb_cr.checked THEN
		
		invo_cri.of_print( ls_origen, ll_nro_registro)
					  
	ELSE
		Messagebox('Aviso','Debe Seleccionar Un Tipo de Impresion')
		Return
		
	END IF

catch ( Exception ex)
	gnvo_app.of_mensaje_error("Error, ha ocurrido una exception: " + ex.getMessage(), '')
	
finally
	destroy lds_voucher
end try


end event

event closequery;call super::closequery;DESTROY ids_asiento_adic
DESTROY ids_crelacion_ext_tbl

destroy invo_asiento_cntbl
destroy invo_cri
end event

type dw_rpt from datawindow within w_fi326_aplicacion_documentos
boolean visible = false
integer x = 3319
integer y = 684
integer width = 283
integer height = 196
integer taborder = 60
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_v from radiobutton within w_fi326_aplicacion_documentos
integer x = 2953
integer y = 376
integer width = 270
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
boolean checked = true
end type

type rb_cr from radiobutton within w_fi326_aplicacion_documentos
integer x = 2953
integer y = 448
integer width = 672
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

type cb_retenciones from commandbutton within w_fi326_aplicacion_documentos
integer x = 2985
integer y = 136
integer width = 457
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

event clicked;String ls_cod_moneda,ls_flag_retencion,ls_cod_relacion
Long   ll_row_master,ll_inicio
Decimal ldc_tasa_cambio

ll_row_master 	 = dw_master.getrow()

if ll_row_master = 0 then return

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

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
dw_master.Object.imp_total [ll_row_master] =	of_recalcular_monto_det()
tab_1.tabpage_1.dw_detail.ii_update = 1
ib_estado_asiento = TRUE

end event

type tab_1 from tab within w_fi326_aplicacion_documentos
integer y = 788
integer width = 3214
integer height = 840
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
		 	 		of_generacion_asiento ()
			 END IF	
END CHOOSE			 

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3177
integer height = 712
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
string dataobject = "d_abc_caja_bancos_det_cartera_pago_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_items();String ls_cod_moneda
Long   ll_row_master
Decimal ldc_tasa_cambio

ll_row_master = dw_master.getrow()
ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]

f_verificacion_items_x_retencion (dw_master,tab_1.tabpage_1.dw_detail)

dw_master.object.imp_total [ll_row_master] = of_recalcular_monto_det()
dw_master.ii_update= 1
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

event ue_insert_pre;call super::ue_insert_pre;

dw_master.Accepttext()
//datos del banco

This.object.nro_item 	    	[al_row] = of_nro_item(this)
This.object.flag_flujo_caja 	[al_row] = '1'
This.object.flag_aplic_comp 	[al_row] = '0' // compesacion
this.object.tasa_cambio		 	[al_row] = dw_master.object.tasa_cambio 	[1]
this.object.cod_moneda_cab		[al_row] = dw_master.object.cod_moneda 	[1]
this.object.confin				[al_row] = dw_master.object.confin		 	[1]
this.object.matriz_cntbl		[al_row] = dw_master.object.matriz_cntbl	[1]
This.object.flag_ret_igv 		[al_row] = '0' // no tiene retencion


//bloqueo de campos....
idw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
idw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
idw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
idw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
idw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")			

end event

event itemchanged;call super::itemchanged;Long   	ll_count,ll_mes,ll_ano,ll_null,ll_nro_registro
String 	ls_data, ls_cod_moneda,ls_null,ls_cencos,ls_cnta_prsp,&
		 	ls_flag_provisionado,ls_matriz,ls_origen,ls_cod_relacion,ls_tip_doc_ref ,&
		 	ls_nro_doc_ref,ls_accion,ls_flag_estado,ls_nom_proveedor, ls_flag_ret_igv
Decimal 	ldc_importe,ldc_imp_retencion, ldc_tasa_cambio
Long		ll_row
dwItemStatus ldis_status


Accepttext()

/*Generacion de Asientos*/
ib_estado_asiento = TRUE

choose case dwo.name
	case 'confin'
		SELECT matriz_cntbl
		  INTO :ls_matriz
		  FROM concepto_financiero
		 WHERE confin = :data 
		   and flag_estado <> '0' ;
		 
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Concepto Financiero No existe Verifique')
			This.Object.confin [row] = gnvo_app.is_null
			Return 1
		end if
		
		This.object.matriz_cntbl [row] = ls_matriz
		
				
	case	'cod_relacion'
		select p.nom_proveedor 
			into :ls_nom_proveedor 
		from proveedor p 
		where (p.proveedor = :data) 
		  and p.flag_estado <> '0';	
				  
		if SQLCA.SQLCode = 100 then
			This.object.cod_relacion  	[row] = gnvo_app.is_null
			This.object.razon_social 	[row] = gnvo_app.is_null
			Messagebox('Aviso','Codigo de Relacion No Existe o no esta activo, por favor Verifique!')
			Return 1
		end if
			
		This.object.razon_social [row] = ls_nom_proveedor
		
		 
	case 'cencos'
		ls_flag_provisionado = this.object.flag_provisionado [row]				
		select Count(*) 
			into :ll_count 
		from centros_costo 
		where	(cencos = :data) 
		  and flag_estado <> '0';
		
		if ll_count = 0 then
			This.object.cencos [row] = gnvo_app.is_null
			Messagebox('Aviso','Centro de Costo No Existe o no esta activo, por favor Verifique!')
			Return 1
		end if
			
		ls_flag_provisionado = This.object.flag_provisionado [row]
		//afectacion presupuestal verificacion
		IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
			ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
			ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
			ls_cencos	 = this.object.cencos    [row]
			ls_cnta_prsp = this.object.cnta_prsp [row]
			ldc_importe  = this.object.importe   [row]
		
			IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
				this.object.cnta_prsp 		[row] = gnvo_app.is_null
				this.object.importe   		[row] = gnvo_app.il_null
				dw_master.Object.imp_total [1] =	of_recalcular_monto_det()
				dw_master.ii_update = 1
				RETURN 1
			END IF
		END IF
			
	case 'cnta_prsp'			
		ls_flag_provisionado = this.object.flag_provisionado [row]			
		
		select Count(*) 
		  into :ll_count 
		 from presupuesto_cuenta 
		 where (cnta_prsp = :data) 
		   and flag_estado <> '0';			   
		
		if ll_count = 0 then
			This.object.cnta_prsp [row] = gnvo_app.is_null
			Messagebox('Aviso','Cuenta Presupuestal No Existe , Verifique!')
			Return 1
		end if
			
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
				
				dw_master.Object.imp_total [1] =	of_recalcular_monto_det()
				dw_master.ii_update = 1							
				RETURN 1
			END IF
		END IF
				
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
		dw_master.Object.imp_total [1] =	of_recalcular_monto_det()
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
				this.object.importe 		 [row] = 0.00
				this.object.impt_ret_igv [row] = 0.00
				dw_master.Object.imp_total [1] =	of_recalcular_monto_det()
				dw_master.ii_update = 1
				Return 1
			end if
		END IF		
	
		//porcentaje de retencion
		IF ls_flag_ret_igv = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
			
			ldc_importe     = This.object.importe     [row] 		
			ls_cod_moneda   = This.object.cod_moneda  [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio [row] 					
			
			IF ls_cod_moneda <> gnvo_app.is_soles THEN 
				ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * idc_tasa_retencion)/ 100,2)
			 
			This.object.impt_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
			This.object.impt_ret_igv [row] = 0.00
		END IF
		//
	
		dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
		dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
		dw_master.ii_update = 1
		
		
		//afectacion presupuestal verificacion
		IF ls_flag_provisionado = 'N'  THEN //EGRESOS INDIRECTO
		
			ll_mes = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'MM'  ))		
			ll_ano = Long(String(dw_master.object.fecha_emision[dw_master.getrow()], 'YYYY'))		
			ls_cencos	  	 = this.object.cencos      [row]
			ls_cnta_prsp  	 = this.object.cnta_prsp   [row]
			ldc_importe   	 = this.object.importe     [row]
			ls_cod_moneda   = this.object.cod_moneda  [row]		
			ldc_tasa_cambio = this.object.tasa_cambio [row]		
			
			if ls_cod_moneda = is_soles then
				ldc_importe = Round(ldc_importe / ldc_tasa_cambio,2)
			end if
				
			IF f_afecta_presup(ll_mes,ll_ano , ls_cencos, ls_cnta_prsp,ldc_importe) = 0 THEN
				this.object.cnta_prsp [row] = gnvo_app.is_null
				this.object.importe   [row] = gnvo_app.il_null
				dw_master.Object.imp_total 	[1] =	of_recalcular_monto_det()
				dw_master.Object.importe_cri 	[1] =	of_recalcular_ret_igv()
				dw_master.ii_update = 1
				RETURN 1
			END IF
		END IF
				

				
	case	'flag_ret_igv'			
		
		IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/

			ldc_importe     = This.object.importe     [row] 		
			ls_cod_moneda   = This.object.cod_moneda  [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio [row] 					
			
			IF ls_cod_moneda <> is_soles THEN 
				ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * idc_tasa_retencion)/ 100,2)
			 
			This.object.impt_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
			This.object.impt_ret_igv [row] = 0.00
		END IF
		
		//Aplico la retencion al resto de registros
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar El mismo FLAG de RETENCION para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;String 		ls_name,ls_prot,ls_flag_provisionado,ls_cencos,ls_cnta_prsp,ls_null
Long   		ll_null,ll_mes ,ll_ano
Decimal 		ldc_importe
str_parametros lstr_param
str_seleccionar lstr_seleccionar

CHOOSE CASE lower(as_columna)
		 CASE 'confin'

			/*
				1	Cntas x Cobrar
				2	Cnas x Pagar
				3	Tesoreria
				4	Todos
				5	Letras
				6	Liquidacion de Beneficios
				7	Devengados OS
				8	Liquidacion de OG
			*/
			
			lstr_param.tipo			= 'ARRAY'
			lstr_param.opcion			= 3	
			lstr_param.str_array[1] = '3'		//Cntas x Pagar
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
				
		 CASE 'tipo_doc'
			  ls_flag_provisionado = this.object.flag_provisionado [al_row]
			  
  			  IF (ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'O') OR is_action = 'fileopen' THEN RETURN
			  
			  lstr_seleccionar.s_seleccion = 'S'
           lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_PAGAR.TIPO_DOC AS CODIGO_DOC,'&
			  											+'VW_FIN_DOC_X_GRUPO_PAGAR.DESC_TIPO_DOC AS DESCRIPCION '&
			   										+'FROM VW_FIN_DOC_X_GRUPO_PAGAR '  
														
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
				  Setitem(al_row,'cod_relacion' ,lstr_seleccionar.param1[1])
				  Setitem(al_row,'nom_proveedor',lstr_seleccionar.param2[1])
				  ii_update = 1
				  /*Generacion de Asientos*/
				  ib_estado_asiento = TRUE
				  
			  END IF	
			  
		CASE 'cencos'
			  ls_flag_provisionado = this.object.flag_provisionado [al_row]
			  IF ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' THEN RETURN
			  
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
						  dw_master.Object.imp_total [1] =	of_recalcular_monto_det()
						  dw_master.ii_update = 1
						  RETURN 
					  END IF
				  END IF				  
				  
				  ii_update = 1
				  /*Generacion de Asientos*/
				  ib_estado_asiento = TRUE
				  
				  
			  END IF	
			  
		CASE 'cnta_prsp'
			
			  ls_flag_provisionado = this.object.flag_provisionado [al_row]
			  
			  IF (ls_flag_provisionado = 'R' OR ls_flag_provisionado = 'D' OR ls_flag_provisionado = 'O' )THEN RETURN
			  
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
						  dw_master.Object.imp_total [1] =	of_recalcular_monto_det()
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
integer height = 712
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
integer height = 392
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
integer y = 408
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

event ue_insert_pre;call super::ue_insert_pre;This.Object.flag_tabla [al_row] = 'D' //APLICACION DE DOCUMENTOS
end event

type cb_1 from commandbutton within w_fi326_aplicacion_documentos
integer x = 2985
integer y = 24
integer width = 457
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
Decimal ldc_tasa_cambio
str_parametros sl_param

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master]
ll_ano 			 = dw_master.object.ano 		   [ll_row_master]
ll_mes 			 = dw_master.object.mes 		   [ll_row_master]
ls_confin		 = dw_master.object.confin		   [ll_row_master]

//*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

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
sl_param.tipo 		= '1CP'
sl_param.opcion   = 25  //APLICACION DE DOCUMENTOS
sl_param.db1 		= 2000
sl_param.dw_m		= dw_master
sl_param.dw_d		= idw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_master.Object.imp_total [1] = of_recalcular_monto_det ()
	dw_master.ii_update 	= 1
	idw_detail.ii_update = 1
	
	/*Generacion de Asientos*/
	ib_estado_asiento = TRUE
END IF

end event

type dw_master from u_dw_abc within w_fi326_aplicacion_documentos
integer width = 2898
integer height = 772
string dataobject = "d_abc_caja_bancos_cab_aplicacion_doc_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
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
Long       	ll_row_gch,ll_count
String     	ls_cod_moneda,ls_nom_proveedor,ls_matriz,ls_descripcion,&
			  	ls_cta_cntbl ,ls_ctabco       ,ls_codigo
Decimal		ldc_tasa_cambio
Date		  	ld_fecha_emision


/*Generacion de Asientos*/
ib_estado_asiento = true

CHOOSE CASE dwo.name
					
	CASE 'tasa_cambio'
		ls_cod_moneda   = This.object.cod_moneda  [row]	
		ldc_tasa_cambio = This.object.tasa_cambio [row]
		
		// Actualiza Tipo de Moneda y Tasa Cambio
		of_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
		This.Object.imp_total [row] =	of_recalcular_monto_det()	
		
	CASE	'fecha_emision'
			ld_fecha_emision = date(this.object.fecha_emision[row])
	
			
			This.object.mes [row] = Long(String(ld_fecha_emision,'MM'))					
			This.object.ano [row] = Long(String(ld_fecha_emision,'YYYY'))					
			
			//busca tipo de cambio
			This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
			
			ls_cod_moneda   = This.object.cod_moneda  [row]	
			ldc_tasa_cambio = This.object.tasa_cambio [row]
			
			// Actualiza Tipo de Moneda y Tasa Cambio
			of_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
			This.Object.imp_total [row] =	of_recalcular_monto_det()								

				
	CASE 'cod_relacion'
		
		SELECT Count(*)
		  INTO :ll_count
		  FROM proveedor p 
		 WHERE (p.proveedor   = :data) and
				 (p.flag_estado = '1'  ) ;
		 
		
		IF ll_count = 0 THEN
			Messagebox('Aviso','Codigo de proveedor No Existe')
			This.Object.razon_social 	  [row] = gnvo_app.is_null
			Return 1
		end if
		
		SELECT p.nom_proveedor
		  INTO :ls_nom_proveedor
		  FROM proveedor p
		 WHERE p.proveedor = :data ;

		This.Object.razon_social    [row]   = ls_nom_proveedor
		
	CASE	'fecha_emision'	
		ld_fecha_emision = Date(This.object.fecha_emision  [row]	)
		ls_cod_moneda    = This.object.cod_moneda  [row]	
		This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
		ldc_tasa_cambio = This.object.tasa_cambio [row]
		
		// Actualiza Tipo de Moneda y Tasa Cambio
		of_act_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
		This.Object.imp_total [row] =	of_recalcular_monto_det()								
				
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
		where tipo_doc = :data ;
		
		if SQLCA.SQLCode = 100 then
			
			this.object.tipo_doc      [row] = gnvo_app.is_null
			this.object.desc_tipo_doc [row] = gnvo_app.is_null
			messagebox('Aviso','Documento No Existe Verifique!')
			return 1
		end if
		
		this.object.desc_tipo_doc [row] = ls_descripcion
	
	
END CHOOSE				
				






end event

event ue_insert_pre;call super::ue_insert_pre;Long 		ll_nro_libro 
dateTime	ldt_now
ib_cierre = false
dw_master.object.t_cierre.text = ''

IF invo_asiento_cntbl.of_get_libro_aplicacion(ll_nro_libro) = FALSE THEN Messagebox('Aviso','No Existe Nro de Libro de Aplicacion de Documentos, Verifique Tabla de Parametros Finparam')

ldt_now = gnvo_app.of_fecha_Actual()

This.Object.origen 		      [al_row] = gs_origen
This.Object.cod_usr 		      [al_row] = gs_user
This.Object.nro_libro	      [al_row] = ll_nro_libro
This.Object.fecha_emision     [al_row] = Date(ldt_now)
This.Object.tasa_cambio       [al_row] = gnvo_app.of_tasa_cambio()
This.Object.ano			      [al_row] = Long(String(ldt_now,'YYYY'))
This.Object.mes			      [al_row] = Long(String(ldt_now,'MM'))
This.Object.flag_estado       [al_row] = '1'
This.Object.flag_tiptran      [al_row] = '4' //Aplicacion de Documentos
This.Object.flag_pago	      [al_row] = 'E' //EFECTIVO
This.Object.flag_conciliacion [al_row] = '0' //NO CONCILIABLE
//
is_action = "new"
end event

event ue_display;call super::ue_display;IF Getrow() = 0 THEN Return

String 	ls_name,ls_prot, ls_codigo, ls_data, ls_data2, ls_data3, ls_data4, ls_sql
boolean	lb_ret

str_parametros   lstr_param
String ls_cod_moneda, ls_saldo_disponible
Decimal ldc_tasa_cambio, ldc_saldo

CHOOSE CASE lower(as_columna)
				
	CASE 'cod_relacion'
		ls_sql = "SELECT P.Proveedor     AS CODIGO_PROVEEDOR ,"&
				 + "P.NOM_PROVEEDOR AS NOMBRES, "&
				 + "P.RUC as RUC_PROVEEDOR " &
				 + "FROM PROVEEDOR P " &
				 + "WHERE ((p.proveedor like 'E%' and P.FLAG_ESTADO ='1') or (p.proveedor not like 'E%') )"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_relacion 	[al_row] = ls_codigo
			this.object.razon_social	[al_row] = ls_data
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
		ls_sql = "SELECT dt.TIPO_DOC AS CODIGO_DOC, "&
				 + "dt.DESC_TIPO_DOC AS DESCRIPCION "&
				 + "FROM DOC_TIPO dt " &
				 + "where dt.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.tipo_doc 		[al_row] = ls_codigo
			this.object.desc_tipo_doc 	[al_row] = ls_data
			
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = true					
		  
		END IF	

	CASE 'serie_cri'
		if is_agente_ret = '0' then
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
				 + "  and dt.tipo_doc 	  = '"+ is_doc_ret + "'" &
				 + "  and dtu.cod_usr     = '" + gs_user + "'" &
				 + "  and dt.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.serie_cri 	[al_row] = string(integer(ls_data), '000')
			
		  ii_update = 1
		  /*Generacion de Asientos*/
		  ib_estado_asiento = true					
		  
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

type gb_1 from groupbox within w_fi326_aplicacion_documentos
integer x = 2935
integer y = 308
integer width = 782
integer height = 236
integer taborder = 50
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

