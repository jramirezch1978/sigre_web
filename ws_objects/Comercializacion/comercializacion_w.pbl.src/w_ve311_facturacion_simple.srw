$PBExportHeader$w_ve311_facturacion_simple.srw
forward
global type w_ve311_facturacion_simple from w_abc
end type
type cbx_cop_det from checkbox within w_ve311_facturacion_simple
end type
type cbx_copiar from checkbox within w_ve311_facturacion_simple
end type
type dw_report_fact from datawindow within w_ve311_facturacion_simple
end type
type rb_2 from radiobutton within w_ve311_facturacion_simple
end type
type rb_1 from radiobutton within w_ve311_facturacion_simple
end type
type dw_detail from u_dw_abc within w_ve311_facturacion_simple
end type
type dw_master from u_dw_abc within w_ve311_facturacion_simple
end type
type dw_boleta from datawindow within w_ve311_facturacion_simple
end type
end forward

global type w_ve311_facturacion_simple from w_abc
integer width = 4192
integer height = 2552
string title = "[VE311] Punto de Venta Rapido - POS"
string menuname = "m_mantenimiento_simplificado"
cbx_cop_det cbx_cop_det
cbx_copiar cbx_copiar
dw_report_fact dw_report_fact
rb_2 rb_2
rb_1 rb_1
dw_detail dw_detail
dw_master dw_master
dw_boleta dw_boleta
end type
global w_ve311_facturacion_simple w_ve311_facturacion_simple

type variables
String 		is_tipo_mov,is_doc_gr,is_doc_fac,is_doc_bvc,is_cencos_vsal,is_accion
Datastore 	ids_cntas_cobrar_cab ,ids_cntas_cobrar_det ,ids_impuesto_det,&
			 	ids_matriz_cntbl_det ,ids_data_glosa       ,ids_data_ref   

String 		is_cod_moneda, is_desc_moneda, is_forma_pago, is_desc_forma_pago, &
				is_tipo_impuesto, is_desc_impuesto, &
				is_motivo_traslado, is_desc_motivo, &
				is_almacen, is_desc_almacen, &
				is_punto_venta, is_desc_pto_vta, &
				is_forma_embarque, is_desc_forma_embarque, is_salir  
		 
//Boolean ib_log = true
//n_cst_log_diario	in_log
//String      		is_tabla, is_colname[], is_coltype[]
end variables

forward prototypes
public function boolean wf_num_doc_tipo (long al_nro_serie, string as_tipo_doc, ref string as_nro_doc)
public subroutine wf_insert_impuesto_det (string as_tipo_doc, string as_nro_doc, long al_item, string as_tipo_imp, decimal adc_impuesto)
public subroutine wf_insert_glosa (string as_tipo_doc, string as_nro_doc, string as_cnta_cntbl, string as_desc_cnta, decimal adc_cantidad, decimal adc_precio_unitario, string as_cod_art, string as_descripcion)
public subroutine wf_insert_ref_cc (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_origen_ref, string as_tipo_ref, string as_nro_ref)
public function boolean wf_insert_det_vale_mov (string as_cod_origen, string as_nro_vale, string as_cod_art, decimal adc_cant_procesada, decimal adc_precio_unit, string as_cod_moneda, string as_cencos, string as_cnta_prsp)
public function boolean wf_guia_vale (string as_nro_guia, string as_nro_vale, string as_cod_origen)
public function boolean wf_insert_fact_simple ()
public function boolean wf_update_cta_cobrar (string as_tipo_doc, string as_nro_doc, string as_flag_detrac, decimal adc_porc_det, string as_nro_detrac, decimal adc_total_fin, string as_soles, string as_dolares, string as_moneda, decimal adc_tasa_cambio)
public subroutine wf_insert_refer_cc_ov (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_origen_ref, string as_tipo_ref, string as_nro_ref)
public function boolean wf_insert_ttemp (string as_cod_origen, string as_nro_ov, long al_item, string as_flag_estado, string as_tipo_doc_cc, string as_nro_doc_cc, string as_nro_guia, string as_nro_vale)
public subroutine wf_insert_cntas_cobrar_det (string as_tipo_doc, string as_nro_doc, long al_item, string as_confin, string as_descripcion, string as_cod_art, decimal adc_cantidad, decimal adc_precio_unitario, decimal adc_precio_unitario_exp, string as_tipo_ov, string as_nro_ov, ref long al_ins_row_det, string as_rubro)
public function boolean wf_insert_guia (long al_nro_serie, string as_tipo_doc, ref string as_nro_guia, string as_cod_origen, string as_almacen, datetime adt_fecha_reg, string as_mot_traslado, string as_cliente, string as_nom_chofer, string as_nro_brevete, string as_nro_placa, string as_nro_placa_carr, string as_destino, string as_cod_usr, string as_prov_transp, string as_obs, string as_marca_veh, string as_cert_insc)
public function boolean wf_insert_det_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, long al_row_ins_det, datetime adt_fecha_reg, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_relacion, boolean ab_imp, string as_cnta_ctbl_imp, string as_flag_debhab_imp, string as_desc_impuesto, decimal adc_importe_imp)
public function boolean wf_genera_detraccion (string as_item_doc, ref string as_flag_detrac, datetime adt_fecha_reg, ref decimal adc_porc_det, ref string as_nro_detrac, string as_cod_origen, decimal adc_monto_doc)
public function boolean wf_update_vale_mov (string as_origen, string as_nro_vale, string as_tipo_doc, string as_nro_doc)
public function boolean wf_update_ov (string as_nro_ov, decimal adc_monto_ov)
public function boolean wf_insert_orden_venta (string as_cod_origen, datetime adt_fecha_reg, string as_forma_pago, string as_cod_moneda, string as_nom_vendedor, string as_cod_usr, string as_cod_relacion, string as_destinatario, string as_punto_partida, string as_forma_embarque, string as_obs, ref string as_nro_ov, decimal adc_total_ov, string as_comp_final, string as_vendedor)
public function integer of_get_param ()
public function boolean wf_insert_cab_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, ref long al_nro_asiento, string as_moneda, decimal adc_tasa_cambio, string as_desc_glosa, datetime adt_fec_reg, date ad_fec_venta, string as_cod_usr)
public function boolean wf_insert_cntas_cobrar_cab (long al_nro_serie, string as_tipo_doc, ref string as_nro_doc, string as_cod_relacion, long al_item_direccion, datetime adt_fec_reg, date ad_fec_venta, string as_forma_embarque, string as_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_forma_pago, string as_obs, string as_vendedor, string as_punto_venta)
public function boolean wf_insert_det_ov (string as_cod_origen, string as_cod_art, string as_doc_ov, string as_nro_ov, datetime adt_fec_reg, date ad_fec_venta, decimal adc_cant_proy, decimal adc_precio_unit, decimal adc_impuesto, string as_moneda, string as_cod_almacen, string as_cencos, string as_cnta_prsp)
public function boolean wf_insert_mov_almacen (string as_cod_origen, ref string as_nro_vale, string as_cod_almacen, datetime adt_fecha_registro, date ad_fec_venta, string as_cod_usr, string as_proveedor, string as_nombre_usr, string as_origen_refer, string as_tipo_refer, string as_nro_refer)
end prototypes

public function boolean wf_num_doc_tipo (long al_nro_serie, string as_tipo_doc, ref string as_nro_doc);String ls_table,ls_msg
Long   ll_nro

// Numera documento
ls_table = 'LOCK TABLE NUM_DOC_TIPO IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_table ;
		
SELECT ultimo_numero	INTO :ll_nro FROM num_doc_tipo 
 WHERE (tipo_doc  = :as_tipo_doc  ) and
	    (nro_serie = :al_nro_serie ) ;
	  
IF SQLCA.SQLCode = 100 OR Isnull( ll_nro ) OR ll_nro = 0 then
	Messagebox( "Error", "Defina la numeracion", Exclamation!)
	Return FALSE
END IF

// Incrementa contador
UPDATE num_doc_tipo SET ultimo_numero = ultimo_numero + 1
 WHERE (tipo_doc  = :as_tipo_doc  ) AND
	    (nro_serie = :al_nro_serie );	
	  
IF SQLCA.SQLCode = -1 THEN 
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("SQL error Num Doc Tipo", ls_msg )
	Return FALSE
END IF

// Asigna numero a cabecera		
as_nro_doc = String(al_nro_serie, '000')+ '-' + String(ll_nro, '000000')

Return TRUE
end function

public subroutine wf_insert_impuesto_det (string as_tipo_doc, string as_nro_doc, long al_item, string as_tipo_imp, decimal adc_impuesto);Long ll_row_ins

ll_row_ins = ids_impuesto_det.InsertRow(0)

/*Replicacion*/

ids_impuesto_det.object.tipo_doc		     [ll_row_ins] = as_tipo_doc
ids_impuesto_det.object.nro_doc		     [ll_row_ins] = as_nro_doc	 
ids_impuesto_det.object.item			     [ll_row_ins] = al_item	
ids_impuesto_det.object.tipo_impuesto    [ll_row_ins] = as_tipo_imp
ids_impuesto_det.object.importe          [ll_row_ins] = adc_impuesto
ids_impuesto_det.object.flag_replicacion [ll_row_ins] = '1'


end subroutine

public subroutine wf_insert_glosa (string as_tipo_doc, string as_nro_doc, string as_cnta_cntbl, string as_desc_cnta, decimal adc_cantidad, decimal adc_precio_unitario, string as_cod_art, string as_descripcion);Long   ll_ins_ds,ll_found_ccc
String ls_expresion

//datastore de cabecera y detalle
ids_cntas_cobrar_cab.Accepttext()
ids_cntas_cobrar_det.Accepttext()

//
ids_data_glosa.Reset()

ll_ins_ds = ids_data_glosa.InsertRow(0)

//
ls_expresion = 'tipo_doc ='+"'"+as_tipo_doc+"'"+' AND nro_doc = '+"'"+as_nro_doc+"'"

//busqueda de Documento
ll_found_ccc = ids_cntas_cobrar_cab.find(ls_expresion,1,ids_cntas_cobrar_cab.Rowcount())

IF ll_found_ccc > 0 THEN
	/*Cabecera*/
	ids_data_glosa.Object.origen			    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.origen 	          [ll_found_ccc]
	ids_data_glosa.Object.tipo_doc		    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.tipo_doc 	       [ll_found_ccc]
	ids_data_glosa.Object.nro_doc			    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.nro_doc  	       [ll_found_ccc]
	ids_data_glosa.Object.cod_relacion	    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.cod_relacion      [ll_found_ccc]
	ids_data_glosa.Object.nom_proveedor	    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.nom_proveedor     [ll_found_ccc]
	ids_data_glosa.Object.cod_moneda		    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.cod_moneda 	    [ll_found_ccc]
	ids_data_glosa.Object.tasa_cambio       [ll_ins_ds] = ids_cntas_cobrar_cab.Object.tasa_cambio       [ll_found_ccc] 
	ids_data_glosa.Object.ano 				    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.ano		          [ll_found_ccc] 
	ids_data_glosa.Object.mes 				    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.mes   		       [ll_found_ccc] 
	ids_data_glosa.Object.nro_libro 		    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.nro_libro         [ll_found_ccc] 
	ids_data_glosa.Object.nro_asiento       [ll_ins_ds] = ids_cntas_cobrar_cab.Object.nro_asiento       [ll_found_ccc] 
	ids_data_glosa.Object.fecha_registro    [ll_ins_ds] =	ids_cntas_cobrar_cab.Object.fecha_registro    [ll_found_ccc]
	ids_data_glosa.Object.cod_usr			    [ll_ins_ds] = ids_cntas_cobrar_cab.Object.cod_usr			    [ll_found_ccc]
	ids_data_glosa.Object.observacion		 [ll_ins_ds] =	ids_cntas_cobrar_cab.Object.observacion 		 [ll_found_ccc] 
	ids_data_glosa.Object.fecha_documento   [ll_ins_ds] = ids_cntas_cobrar_cab.Object.fecha_documento 	 [ll_found_ccc]
	ids_data_glosa.Object.punto_venta	    [ll_ins_ds] =	ids_cntas_cobrar_cab.Object.punto_venta 		 [ll_found_ccc]
	ids_data_glosa.Object.fecha_vencimiento [ll_ins_ds] = ids_cntas_cobrar_cab.Object.fecha_vencimiento [ll_found_ccc]
	ids_data_glosa.Object.cnta_ctbl		    [ll_ins_ds] = as_cnta_cntbl
	ids_data_glosa.Object.desc_cnta		    [ll_ins_ds] = Mid(as_desc_cnta,1,60)

	/*Detalle*/
	ids_data_glosa.Object.cantidad			 [ll_ins_ds] = adc_cantidad
	ids_data_glosa.Object.importe			    [ll_ins_ds] = adc_precio_unitario
	ids_data_glosa.Object.cod_art			    [ll_ins_ds] = as_cod_art
	ids_data_glosa.Object.descripcion	    [ll_ins_ds] = as_descripcion
END IF	
end subroutine

public subroutine wf_insert_ref_cc (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_origen_ref, string as_tipo_ref, string as_nro_ref);Long ll_ins_row

ll_ins_row = ids_data_ref.InsertRow(0)

ids_data_ref.Object.cod_relacion     [ll_ins_row] = as_cod_relacion
ids_data_ref.Object.tipo_doc	       [ll_ins_row] = as_tipo_doc
ids_data_ref.Object.nro_doc		    [ll_ins_row] = as_nro_doc
ids_data_ref.Object.tipo_mov		    [ll_ins_row] = 'C'
ids_data_ref.Object.origen_ref	    [ll_ins_row] =	as_origen_ref
ids_data_ref.Object.tipo_ref		    [ll_ins_row] = as_tipo_ref
ids_data_ref.Object.nro_ref	 	    [ll_ins_row] = as_nro_ref
ids_data_ref.Object.nro_ref	 	    [ll_ins_row] = as_nro_ref
ids_data_ref.Object.flab_tabor	    [ll_ins_row] = '9'
ids_data_ref.Object.flag_replicacion [ll_ins_row] = '1'
end subroutine

public function boolean wf_insert_det_vale_mov (string as_cod_origen, string as_nro_vale, string as_cod_art, decimal adc_cant_procesada, decimal adc_precio_unit, string as_cod_moneda, string as_cencos, string as_cnta_prsp);Long    ll_nro_mov_proy
String  ls_msj_err
Boolean lb_ret = TRUE

//ultimo nro de movimiento proyectado
select nro_mov_proy into :ll_nro_mov_proy 
  from tt_art_mov_proy ;
  
/*Replicacion*/


Insert Into articulo_mov
(cod_origen     ,origen_mov_proy ,nro_mov_proy    ,
 nro_vale	    ,flag_estado     ,cod_art         ,
 cant_procesada ,precio_unit     ,cod_moneda      ,
 cencos			 ,cnta_prsp	      ,flag_replicacion)   
Values
(:as_cod_origen      ,:as_cod_origen   ,:ll_nro_mov_proy ,
 :as_nro_vale        ,'1'              ,:as_cod_art      ,
 :adc_cant_procesada ,:adc_precio_unit ,:as_cod_moneda   ,
 :as_cencos          ,:as_cnta_prsp    ,'1' )  ;

 
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox("SQL error Vale Mov", ls_msj_err)
	lb_ret = FALSE
END IF 
 
 

RETURN lb_ret
end function

public function boolean wf_guia_vale (string as_nro_guia, string as_nro_vale, string as_cod_origen);String ls_msj_err
Boolean lb_ret = TRUE

/*Replicacion*/  
Insert Into guia_vale
(nro_guia   , nro_vale , origen_guia , origen_vale,flag_replicacion )  
Values
(:as_nro_guia ,:as_nro_vale , :as_cod_origen , :as_cod_origen,'1')  ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox("SQL error Guia Vale", ls_msj_err)
	lb_ret = false
END IF

Return lb_ret
end function

public function boolean wf_insert_fact_simple ();Boolean lb_ret = TRUE
String  ls_msj_err,ls_cadena,ls_cadena_2,ls_tipo_doc_cc,ls_nro_doc_cc

Insert Into factura_simpl
select * from tt_fin_factura_simpl ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err =  SQLCA.SQLErrText
	Rollback;
   MessageBox('Aviso factura_simpl',ls_msj_err)
	lb_ret = FALSE
	GOTO SALIDA
END IF

//CURSOR 
DECLARE FACT_SIMPLE CURSOR FOR
  select TRIM(origen)||TRIM(nro_ov)||TRIM(TO_CHAR(item)),tipo_doc_cc||nro_doc_cc
  	 from tt_fin_factura_simpl ;

/*Abrir Cursor*/		  	
open FACT_SIMPLE ;
	
	do 				/*Recorro Cursor*/	
	 fetch FACT_SIMPLE into :ls_cadena,:ls_cadena_2 ;
	 
	 IF sqlca.sqlcode = 100 THEN EXIT

	 /**Inserción de Arreglo**/ 
	 //log de cambios
	 Insert Into log_diario
	 (fecha,tabla,operacion,llave,campo,val_nuevo,cod_usr)
	 Values
	 (sysdate,'FACTURA_SIMPL','Insert',:ls_cadena,'tipo_doc_cc,nro_doc_cc',:ls_cadena_2,:gs_user);

	 IF SQLCA.SQLCode = -1 THEN 
		 ls_msj_err =  SQLCA.SQLErrText
		 Rollback;
   	 MessageBox('Aviso LOG DIARIO DE factura_simpl',ls_msj_err)
		 lb_ret = FALSE
	 	 GOTO SALIDA
	 END IF
loop while true
	
close FACT_SIMPLE ; /*Cierra Cursor*/

SALIDA:

Return lb_ret
end function

public function boolean wf_update_cta_cobrar (string as_tipo_doc, string as_nro_doc, string as_flag_detrac, decimal adc_porc_det, string as_nro_detrac, decimal adc_total_fin, string as_soles, string as_dolares, string as_moneda, decimal adc_tasa_cambio);Long    ll_found
String  ls_expresion
Decimal {2} ldc_total_soles,ldc_total_dolares
Boolean lb_ret = TRUE

ls_expresion = 'tipo_doc = '+"'"+as_tipo_doc+"'"+' AND nro_doc = '+"'"+as_nro_doc+"'"

//busqueda de documento
ll_found = ids_cntas_cobrar_cab.Find(ls_expresion,1,ids_cntas_cobrar_cab.Rowcount())

IF ll_found > 0 THEN
	if as_moneda = as_dolares then
		ldc_total_soles   = Round(adc_total_fin * adc_tasa_cambio,2)
		ldc_total_dolares = adc_total_fin
	elseif as_moneda = as_soles then
		ldc_total_soles	= adc_total_fin
		ldc_total_dolares	= Round(adc_total_fin / adc_tasa_cambio ,2)
	end if
		
	ids_cntas_cobrar_cab.Object.flag_detraccion [ll_found] = as_flag_detrac
	ids_cntas_cobrar_cab.Object.nro_detraccion  [ll_found] = as_nro_detrac
	ids_cntas_cobrar_cab.Object.porc_detraccion [ll_found] = adc_porc_det
	ids_cntas_cobrar_cab.Object.importe_doc	  [ll_found] = adc_total_fin
	ids_cntas_cobrar_cab.Object.saldo_sol	  	  [ll_found] = ldc_total_soles
	ids_cntas_cobrar_cab.Object.saldo_dol	  	  [ll_found] = ldc_total_dolares
	
ELSE
	Messagebox('Aviso','Doumento Cabecera no se encontro en cntas x cobrar , verifique!')
	lb_ret = FALSE
END IF

Return lb_ret
end function

public subroutine wf_insert_refer_cc_ov (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_origen_ref, string as_tipo_ref, string as_nro_ref);Long ll_ins_row

ll_ins_row = ids_data_ref.InsertRow(0)

ids_data_ref.Object.cod_relacion 	 [ll_ins_row] = as_cod_relacion
ids_data_ref.Object.tipo_doc	   	 [ll_ins_row] = as_tipo_doc
ids_data_ref.Object.nro_doc			 [ll_ins_row] = as_nro_doc
ids_data_ref.Object.tipo_mov			 [ll_ins_row] = 'C'
ids_data_ref.Object.origen_ref		 [ll_ins_row] =	as_origen_ref
ids_data_ref.Object.tipo_ref			 [ll_ins_row] = as_tipo_ref
ids_data_ref.Object.nro_ref	 		 [ll_ins_row] = as_nro_ref
ids_data_ref.Object.flab_tabor	    [ll_ins_row] = 'A'
ids_data_ref.Object.flag_replicacion [ll_ins_row] = '1'
end subroutine

public function boolean wf_insert_ttemp (string as_cod_origen, string as_nro_ov, long al_item, string as_flag_estado, string as_tipo_doc_cc, string as_nro_doc_cc, string as_nro_guia, string as_nro_vale);String  ls_msj_err
Boolean lb_ret = TRUE

Insert Into tt_fin_factura_simpl
(origen      ,nro_ov      ,item       ,
 flag_estado ,tipo_doc_cc ,nro_doc_cc ,
 nro_guia    ,nro_vale    ,flag_replicacion)  
Values
(:as_cod_origen  ,:as_nro_ov      ,:al_item       ,
 :as_flag_estado ,:as_tipo_doc_cc ,:as_nro_doc_cc ,
 :as_nro_guia    ,:as_nro_vale	 ,'1')  ;

IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
	lb_ret = FALSE
END IF

Return lb_ret
end function

public subroutine wf_insert_cntas_cobrar_det (string as_tipo_doc, string as_nro_doc, long al_item, string as_confin, string as_descripcion, string as_cod_art, decimal adc_cantidad, decimal adc_precio_unitario, decimal adc_precio_unitario_exp, string as_tipo_ov, string as_nro_ov, ref long al_ins_row_det, string as_rubro);al_ins_row_det = ids_cntas_cobrar_det.InsertRow(0)

ids_cntas_cobrar_det.object.tipo_doc          [al_ins_row_det] = as_tipo_doc
ids_cntas_cobrar_det.object.nro_doc	          [al_ins_row_det] = as_nro_doc
ids_cntas_cobrar_det.object.item		          [al_ins_row_det] = al_item
ids_cntas_cobrar_det.object.flag_estado       [al_ins_row_det] = '1'
ids_cntas_cobrar_det.object.confin		       [al_ins_row_det] = as_confin
ids_cntas_cobrar_det.object.descripcion       [al_ins_row_det] = as_descripcion
ids_cntas_cobrar_det.object.cod_art           [al_ins_row_det] = as_cod_art
ids_cntas_cobrar_det.object.cantidad	       [al_ins_row_det] = adc_cantidad
ids_cntas_cobrar_det.object.precio_unitario   [al_ins_row_det] = adc_precio_unitario
ids_cntas_cobrar_det.object.precio_unit_exp   [al_ins_row_det] = adc_precio_unitario_exp
ids_cntas_cobrar_det.object.tipo_ref          [al_ins_row_det] = as_tipo_ov
ids_cntas_cobrar_det.object.nro_ref           [al_ins_row_det] = as_nro_ov
ids_cntas_cobrar_det.object.flag_replicacion  [al_ins_row_det] = '1'
ids_cntas_cobrar_det.object.rubro				 [al_ins_row_det] = as_rubro
end subroutine

public function boolean wf_insert_guia (long al_nro_serie, string as_tipo_doc, ref string as_nro_guia, string as_cod_origen, string as_almacen, datetime adt_fecha_reg, string as_mot_traslado, string as_cliente, string as_nom_chofer, string as_nro_brevete, string as_nro_placa, string as_nro_placa_carr, string as_destino, string as_cod_usr, string as_prov_transp, string as_obs, string as_marca_veh, string as_cert_insc);String ls_msj_err
Boolean lb_ret = TRUE

wf_num_doc_tipo(al_nro_serie,as_tipo_doc,as_nro_guia)
/*Replicacion*/
Insert Into guia 
(cod_origen      ,nro_guia            ,almacen            ,
 fec_registro    ,fec_impresion       ,flag_estado        ,
 motivo_traslado ,cliente		        ,nom_chofer		    ,
 nro_brevete	  ,nro_placa	        ,nro_placa_carreta  ,
 destino         ,cod_usr             ,prov_transp        ,
 obs 			     ,fec_inicio_traslado ,marca_vehiculo     ,
 cert_insc_mtc   ,flag_replicacion)  
Values
(:as_cod_origen   ,:as_nro_guia   ,:as_almacen        ,
 :adt_fecha_reg   ,:adt_fecha_reg ,'1'			         ,
 :as_mot_traslado ,:as_cliente	 ,:as_nom_chofer     ,
 :as_nro_brevete  ,:as_nro_placa  ,:as_nro_placa_carr ,
 :as_destino      ,:as_cod_usr	 ,:as_prov_transp		,
 :as_obs          ,:adt_fecha_reg ,:as_marca_veh      ,
 :as_cert_insc    ,'1')  ;

IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox("SQL error Guia ", ls_msj_err)
END IF

Return lb_ret 
end function

public function boolean wf_insert_det_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, long al_row_ins_det, datetime adt_fecha_reg, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_relacion, boolean ab_imp, string as_cnta_ctbl_imp, string as_flag_debhab_imp, string as_desc_impuesto, decimal adc_importe_imp);String  ls_matriz_cntbl ,ls_cnta_ctbl    ,ls_desc_cnta    ,ls_flag_debhab   ,ls_formula      ,&
		  ls_glosa_campo  ,ls_glosa_texto  ,ls_flag_cta_bco ,ls_flag_cencos   ,ls_flag_doc_ref ,&
		  ls_flag_cod_rel	,ls_campo_formula,ls_campo		    ,ls_expresion_form,ls_tipo_doc		,&
		  ls_nro_doc		,ls_confin       ,ls_cod_art		 ,ls_descripcion	 ,ls_soles			,&
		  ls_dolares		,ls_desc_glosa	  ,ls_msj_err		 ,ls_flag_cebef	
String  ls_armado[],ls_inicio []
Long    ll_inicio,ll_count,ll_inicio_for,ll_found_imp
Integer li_pos_ini,li_pos,li_cont,li_pos_fin,li_item,li_item_asiento
Decimal {2} ldc_monto,ldc_importe_imp,ldc_monto_imp,ldc_monto_soles,ldc_monto_dolares
Decimal {4} ldc_cant_proy
Decimal {6} ldc_precio_unit
Boolean lb_ret = true


n_cst_asiento_glosa lnv_asiento_glosa
lnv_asiento_glosa    = CREATE n_cst_asiento_glosa

//tipo de oneda
f_monedas(ls_soles,ls_dolares) 


//recuperar datos del detalle
ls_campo_formula = 'tipo_impuesto'
li_item         = ids_cntas_cobrar_det.object.item            [al_row_ins_det]
ls_confin       = ids_cntas_cobrar_det.object.confin          [al_row_ins_det]
ls_tipo_doc     = ids_cntas_cobrar_det.object.tipo_doc        [al_row_ins_det]
ls_nro_doc      = ids_cntas_cobrar_det.object.nro_doc         [al_row_ins_det]
ldc_cant_proy   = ids_cntas_cobrar_det.object.cantidad        [al_row_ins_det]
ldc_precio_unit = ids_cntas_cobrar_det.object.precio_unitario [al_row_ins_det]
ls_cod_art		 = ids_cntas_cobrar_det.object.cod_art			  [al_row_ins_det]
ls_descripcion  = ids_cntas_cobrar_det.object.descripcion     [al_row_ins_det]

//recupero matriz contable
select matriz_cntbl into :ls_matriz_cntbl 
  from concepto_financiero 
 where (confin = :ls_confin);

ids_matriz_cntbl_det.Retrieve(ls_matriz_cntbl)

IF ids_matriz_cntbl_det.Rowcount () = 0 THEN
	Messagebox('Aviso','Matriz Contable '+ ls_matriz_cntbl +' No Tiene Juego Contable Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF	

For ll_inicio = 1 to ids_matriz_cntbl_det.Rowcount ()
	 //INICIALIZACION DE VARIABLES	
	 ls_armado = ls_inicio

    ldc_monto   	= 0.00
	 ldc_monto_imp = 0.00
    li_pos 	   	= 1
	 li_pos_ini  	= 0
	 li_pos_fin  	= 0
	 li_cont   		= 0

	//buscar item mayor para incrementar
	 select count(*) into :ll_count from cntbl_asiento_det
	  where (origen      = :as_origen      ) and
			  (ano         = :al_ano			) and
			  (mes         = :al_mes         ) and
	  		  (nro_libro   = :al_nro_libro   ) and
			  (nro_asiento = :al_nro_asiento ) ;
			  
    if ll_count > 0 then
    	 select Max(item) into :li_item_asiento from cntbl_asiento_det
	     where (origen      = :as_origen      ) and
			     (ano         = :al_ano			) and
			     (mes         = :al_mes         ) and
	  		     (nro_libro   = :al_nro_libro   ) and
			     (nro_asiento = :al_nro_asiento ) ;
	 else			  
		 li_item_asiento = 0
	 end if
	 
	 	
	 ls_cnta_ctbl 	 = ids_matriz_cntbl_det.Object.cnta_ctbl   [ll_inicio]
	 ls_desc_cnta	 = ids_matriz_cntbl_det.Object.desc_cnta   [ll_inicio]
	 ls_flag_debhab = ids_matriz_cntbl_det.Object.flag_debhab [ll_inicio]
    ls_formula     = ids_matriz_cntbl_det.Object.formula 	 [ll_inicio]
	 ls_glosa_campo = ids_matriz_cntbl_det.Object.glosa_campo [ll_inicio]
	 ls_glosa_texto = ids_matriz_cntbl_det.Object.glosa_texto [ll_inicio]
	 
	 
	 ls_desc_cnta = Mid(ls_desc_cnta,1,60)
	 
	 //==si existe cuenta contable y flag_debhab
	 select Count(*) into :ll_count from cntbl_asiento_det
	  where (origen      = :as_origen      ) and
			  (ano         = :al_ano			) and
			  (mes         = :al_mes         ) and
	  		  (nro_libro   = :al_nro_libro   ) and
			  (nro_asiento = :al_nro_asiento ) and			  
			  (cnta_ctbl   = :ls_cnta_ctbl   ) and
			  (flag_debhab = :ls_flag_debhab ) ;
			  
	 IF ll_count > 0	THEN	  
	    //recuperar item de asiento
	    select item into :li_item_asiento
	      from cntbl_asiento_det
	     where (origen      = :as_origen      ) and
			     (ano         = :al_ano			) and
			     (mes         = :al_mes         ) and
	  		     (nro_libro   = :al_nro_libro   ) and
			     (nro_asiento = :al_nro_asiento ) and			  
			     (cnta_ctbl   = :ls_cnta_ctbl   ) and
			     (flag_debhab = :ls_flag_debhab ) ;
	  END IF 
			  
 	 /***************************************************/
	 /*Asignación de Información requerida x Cta Cntbl */
	 /***************************************************/
	 IF f_cntbl_cnta(ls_cnta_ctbl,ls_flag_cta_bco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef) = FALSE THEN
	 	 lb_ret = FALSE
		 GOTO SALIDA
	 END IF
			  
	  			
	 //llena data glosa
	 wf_insert_glosa(ls_tipo_doc  ,ls_nro_doc   ,ls_cnta_ctbl    ,&
	                 ls_desc_cnta ,ldc_cant_proy,ldc_precio_unit ,&
						  ls_cod_art   ,ls_descripcion )
    
	 
	/***********************/
	li_pos_ini     = Pos(ls_formula,'[',li_pos) 
				
	IF li_pos_ini = 1 THEN       /*Formula Pura */
		ldc_monto  = 0.00
	ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
		ls_campo = Mid(ls_formula,1,li_pos_ini - 2)
		ldc_monto  = ids_cntas_cobrar_det.Getitemnumber(al_row_ins_det,ls_campo)
	ELSEIF li_pos_ini = 0 THEN	  /*Campo*/
		ldc_monto  = ids_cntas_cobrar_det.Getitemnumber(al_row_ins_det,ls_formula)
	END IF
				
				
				
	DO WHILE li_pos_ini > 0
		li_cont ++
		li_pos_fin = Pos(ls_formula,']',li_pos_ini) 
		ls_armado [li_cont] = Mid(ls_formula,li_pos_ini + 1,li_pos_fin - (li_pos_ini + 1))
		//Inicializa Valor
		li_pos_ini = Pos(ls_formula,'[',li_pos_fin) 
	LOOP
	
	/*****Calculo de Monto si existiese Formula*****/
	IF UpperBound(ls_armado) > 0 THEN
		FOR ll_inicio_for = 1 TO UpperBound(ls_armado)
			 /*Inicializa Monto de Impuesto*/
			 
			 ls_expresion_form	= 'item = '+Trim(String(li_item))+' AND  '+ ls_campo_formula+" = '"+ls_armado[ll_inicio_for]+"'"
			 
			 ll_found_imp = ids_impuesto_det.find(ls_expresion_form,1,ids_impuesto_det.Rowcount())
						 
			 IF ll_found_imp > 0 THEN
				 ldc_importe_imp = ids_impuesto_det.object.importe	[ll_found_imp] 	
				 ldc_monto_imp   = ldc_monto_imp + ldc_importe_imp
							 
		    END IF
	   NEXT
		
			 
	  ldc_monto = (ldc_monto + ldc_monto_imp)
	END IF


	/*Monto soles y dolares*/
	IF as_cod_moneda = ls_soles THEN
		ldc_monto_soles   = Round(ldc_monto,2)					
		ldc_monto_dolares = Round(ldc_monto / adc_tasa_cambio,2)
	ELSEIF as_cod_moneda = ls_dolares THEN
		ldc_monto_dolares = round(ldc_monto,2)					
		ldc_monto_soles   = round(ldc_monto * adc_tasa_cambio,2)
	END IF		



	IF ll_count = 0 THEN
		li_item_asiento = li_item_asiento + 1
		

		/*Extraer Glosa*/
		ls_desc_glosa = Mid(lnv_asiento_glosa.of_set_glosa(ids_data_glosa,1,ls_glosa_texto,ls_glosa_campo),1,60)

		/*Inserta Detalle de Asiento*/			
		/*Replicacion*/
      Insert Into cntbl_asiento_det
      (origen      ,ano         ,mes       ,   
       nro_libro   ,nro_asiento ,item      ,  
       cnta_ctbl   ,fec_cntbl	  ,det_glosa ,
       flag_debhab ,imp_movsol  ,imp_movdol,
		 flag_replicacion)  
		Values
		(:as_origen      ,:al_ano         ,:al_mes           ,
		 :al_nro_libro   ,:al_nro_asiento ,:li_item_asiento  ,
		 :ls_cnta_ctbl   ,:adt_fecha_reg  ,:ls_desc_glosa	  ,
		 :ls_flag_debhab ,:ldc_monto_soles,:ldc_monto_dolares,
		 '1');
		 
		 
		IF SQLCA.SQLCode = -1 THEN 
			ls_msj_err = SQLCA.SQLErrText
			lb_ret = FALSE
			Rollback ;
        	MessageBox("SQL error cntbl_asiento_det", ls_msj_err)
			GOTO SALIDA			  
		END IF 
		
			
		IF ls_flag_doc_ref = '1' THEN //pide tipo de documento
			/*Replicacion*/
		   Update cntbl_asiento_det
			   set tipo_docref1 = :ls_tipo_doc,nro_docref1 = :ls_nro_doc,flag_replicacion = '1'
			 where (origen      = :as_origen      ) and
			 		 (ano         = :al_ano         ) and
					 (mes         = :al_mes		     ) and
					 (nro_libro   = :al_nro_libro	  ) and
					 (nro_asiento = :al_nro_asiento ) and
					 (item		  = :li_item_asiento) ;

			IF SQLCA.SQLCode = -1 THEN 
				ls_msj_err = SQLCA.SQLErrText
				lb_ret = FALSE
				Rollback ;
         	MessageBox("SQL error cntbl_asiento_det", ls_msj_err)
				GOTO SALIDA				
			END IF					 
			
		END IF	
				
		IF ls_flag_cod_rel = '1' THEN
			/*Replicacion*/
			Update cntbl_asiento_det
			   set cod_relacion = :as_cod_relacion,flag_replicacion = '1'
			 where (origen      = :as_origen      ) and
			 		 (ano         = :al_ano         ) and
					 (mes         = :al_mes		     ) and
					 (nro_libro   = :al_nro_libro	  ) and
					 (nro_asiento = :al_nro_asiento ) and
					 (item		  = :li_item_asiento) ;
					 
			IF SQLCA.SQLCode = -1 THEN 
				ls_msj_err = SQLCA.SQLErrText
				lb_ret = FALSE
				Rollback ;
         	MessageBox("SQL error cntbl_asiento_det", ls_msj_err)
				GOTO SALIDA				
			END IF

		END IF
		
	ELSE //asiento igual
		/*Replicacion*/		
		UPDATE cntbl_asiento_det
		   SET imp_movsol = Nvl(imp_movsol,0) + :ldc_monto_soles, imp_movdol = Nvl(imp_movdol,0) + :ldc_monto_dolares,flag_replicacion = '1'
		 WHERE (origen      = :as_origen      ) and
		 		 (ano         = :al_ano         ) and
				 (mes         = :al_mes		     ) and
				 (nro_libro   = :al_nro_libro	  ) and
				 (nro_asiento = :al_nro_asiento ) and
				 (item		  = :li_item_asiento) ;
		
		IF SQLCA.SQLCode = -1 THEN 
			ls_msj_err = SQLCA.SQLErrText
			lb_ret = FALSE
			Rollback ;
         MessageBox("SQL error cntbl_asiento_det", ls_msj_err)
			GOTO SALIDA
		END IF
		
	END IF
	
Next

IF ab_imp THEN //GENERA ASIENTO DE IMPUESTO
	//buscar item mayor para incrementar
	select count(*) into :ll_count from cntbl_asiento_det
	 where (origen      = :as_origen      ) and
		    (ano         = :al_ano			) and
			 (mes         = :al_mes         ) and
	  		 (nro_libro   = :al_nro_libro   ) and
			 (nro_asiento = :al_nro_asiento ) ;
			  
    if ll_count > 0 then
    	 select Max(item) into :li_item_asiento from cntbl_asiento_det
	     where (origen      = :as_origen      ) and
			     (ano         = :al_ano			) and
			     (mes         = :al_mes         ) and
	  		     (nro_libro   = :al_nro_libro   ) and
			     (nro_asiento = :al_nro_asiento ) ;
	 else			  
		 li_item_asiento = 0
	 end if

	//==si existe cuenta contable y flag_debhab
	select Count(*) into :ll_count from cntbl_asiento_det
	 where (origen      = :as_origen      		) and
		    (ano         = :al_ano					) and
			 (mes         = :al_mes         		) and
	  		 (nro_libro   = :al_nro_libro   		) and
			 (nro_asiento = :al_nro_asiento 		) and			  
			 (cnta_ctbl   = :as_cnta_ctbl_imp   ) and
			 (flag_debhab = :as_flag_debhab_imp ) ;

	/*Monto soles y dolares*/
	IF as_cod_moneda = ls_soles THEN
		ldc_monto_soles   = adc_importe_imp					
		ldc_monto_dolares = Round(adc_importe_imp / adc_tasa_cambio,2)
	ELSEIF as_cod_moneda = ls_dolares THEN
		ldc_monto_dolares = adc_importe_imp
		ldc_monto_soles   = round(adc_importe_imp * adc_tasa_cambio,2)
	END IF		
		
	if ll_count = 0 then
	   li_item_asiento = li_item_asiento + 1 
		/*Inserta Detalle de Asiento de impuesto*/			
      Insert Into cntbl_asiento_det
      (origen      ,ano         ,mes       ,   
       nro_libro   ,nro_asiento ,item      ,  
       cnta_ctbl   ,fec_cntbl	  ,det_glosa ,
       flag_debhab ,imp_movsol  ,imp_movdol,
		 flag_replicacion)  
		Values
		(:as_origen      		,:al_ano          ,:al_mes           ,
		 :al_nro_libro   		,:al_nro_asiento  ,:li_item_asiento  ,
		 :as_cnta_ctbl_imp   ,:adt_fecha_reg   ,:as_desc_impuesto ,
		 :as_flag_debhab_imp ,:ldc_monto_soles ,:ldc_monto_dolares,
		 '1');
	else
      //recuperar item de asiento
      select item into :li_item_asiento
        from cntbl_asiento_det
       where (origen      = :as_origen      		) and
		       (ano         = :al_ano			  		) and
		       (mes         = :al_mes         		) and
  		       (nro_libro   = :al_nro_libro   		) and
		       (nro_asiento = :al_nro_asiento 		) and			  
		       (cnta_ctbl   = :as_cnta_ctbl_imp   ) and
		       (flag_debhab = :as_flag_debhab_imp ) ;
				
		UPDATE cntbl_asiento_det
		   SET imp_movsol = Nvl(imp_movsol,0) + :ldc_monto_soles   ,
			    imp_movdol = Nvl(imp_movdol,0) + :ldc_monto_dolares ,
				 flag_replicacion = '1'
		 WHERE (origen      = :as_origen      ) and
		 		 (ano         = :al_ano         ) and
				 (mes         = :al_mes		     ) and
				 (nro_libro   = :al_nro_libro	  ) and
				 (nro_asiento = :al_nro_asiento ) and
				 (item		  = :li_item_asiento) ;
		end if
	
END IF

SALIDA:

destroy lnv_asiento_glosa 

Return lb_ret
end function

public function boolean wf_genera_detraccion (string as_item_doc, ref string as_flag_detrac, datetime adt_fecha_reg, ref decimal adc_porc_det, ref string as_nro_detrac, string as_cod_origen, decimal adc_monto_doc);//ventana de ayuda
String      ls_const_det
Date			ldt_fecha_det
Decimal {2} ldc_monto_detrac
Boolean lb_ret = TRUE
str_parametros lstr_param
nvo_numeradores lnvo_numeradores
lnvo_numeradores = CREATE nvo_numeradores

//* Open de Ventana de Ayuda*//
lstr_param.string2 = as_item_doc

OpenWithParm(w_help_const_dep_fact_simpl,lstr_param)
			  
//Open(w_help_const_dep_fact_simpl)

//*Datos Recuperados  *//
IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm
	IF lstr_param.bret THEN //genera detraccion
	   ls_const_det  = lstr_param.string1 
		ldt_fecha_det = lstr_param.date1   
		adc_porc_det  = lstr_param.dec1   
					  
		SetNull(as_nro_detrac)
		
      IF lnvo_numeradores.uf_num_detraccion( as_cod_origen,as_nro_detrac) = FALSE THEN
			lb_ret = FALSE			
			GOTO SALIDA
	   END IF
		
		//MONTO DETRACCION
		ldc_monto_detrac = ( Round(adc_monto_doc * adc_porc_det,0 ) / 100 )
		
		//inserto detraccion
		IF f_insert_detrac (as_nro_detrac ,'1'    ,Date(adt_fecha_reg),ls_const_det,&
							     ldt_fecha_det ,gs_user,ldc_monto_detrac	 ,'1') = FALSE THEN
			lb_ret = FALSE
			GOTO SALIDA
		END IF
		
		as_flag_detrac = '1' //genera detraccion
		
	 ELSE
		 as_flag_detrac = '0' //no genera detraccion
		 
		 SetNull(adc_porc_det)
		 SetNull(as_nro_detrac)
    END IF

				  
SALIDA:

Destroy lnvo_numeradores
				  
Return lb_ret				  
end function

public function boolean wf_update_vale_mov (string as_origen, string as_nro_vale, string as_tipo_doc, string as_nro_doc);Boolean lb_ret = TRUE
String  ls_msj_err

/*actualizacion*/
Update vale_mov
   Set tipo_doc_int = :as_tipo_doc  ,
       nro_doc_int  = :as_nro_doc
 Where ( cod_origen = :as_origen   ) and
       ( nro_vale   = :as_nro_vale ) ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	Rollback ;
   MessageBox("SQL error Update Vale Mov", ls_msj_err)
END IF

Return lb_ret
end function

public function boolean wf_update_ov (string as_nro_ov, decimal adc_monto_ov);Boolean lb_ret = true

UPDATE orden_venta
   SET monto_total = :adc_monto_ov
 WHERE nro_ov = :as_nro_ov   ;

IF SQLCA.SQLCode = -1 THEN 
   MessageBox('Error Actualizacion de Orden Venta', SQLCA.SQLErrText)
	lb_ret = false
END IF

Return lb_ret
end function

public function boolean wf_insert_orden_venta (string as_cod_origen, datetime adt_fecha_reg, string as_forma_pago, string as_cod_moneda, string as_nom_vendedor, string as_cod_usr, string as_cod_relacion, string as_destinatario, string as_punto_partida, string as_forma_embarque, string as_obs, ref string as_nro_ov, decimal adc_total_ov, string as_comp_final, string as_vendedor);Boolean lb_ret = TRUE

//ELIMINAR INFORMACION DE TABLA TEMPORAL
try
	as_nro_ov = f_numera_documento('num_orden_venta',10)
catch(Exception ex)
	gnvo_app.of_catch_exception(ex, 'ha ocurrido una exception')
end try

//replicacion
//genera nro de orden de venta
Insert Into orden_venta 
(cod_origen      ,nro_ov        ,flag_estado   ,   
 fec_registro    ,forma_pago    ,cod_moneda    ,   
 nom_vendedor    ,cod_usr       ,cliente		  ,
 comprador_final ,destino		  ,punto_partida ,
 forma_embarque  ,obs			  ,flag_mercado  ,
 monto_total     ,flag_replicacion,vendedor    ,
 fecha_doc)  
Values
(:as_cod_origen     ,:as_nro_ov		  ,'5'	            ,
 :adt_fecha_reg     ,:as_forma_pago   ,:as_cod_moneda    ,
 :as_nom_vendedor   ,:as_cod_usr		  ,:as_cod_relacion  , 
 :as_comp_final     ,:as_destinatario ,:as_punto_partida ,
 :as_forma_embarque ,:as_obs			  ,'L'               ,
 :adc_total_ov      ,'1' 				  ,:as_vendedor		,
 :adt_fecha_reg) ; 

IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error Orden Venta", SQLCA.SQLErrText)
	Rollback ;
	lb_ret = FALSE
END IF

Return lb_ret
end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
//SELECT 	FS_PARAM.COD_MONEDA, moneda.DESCRIPCION, 
//			FS_PARAM.FORMA_PAGO, FORMA_PAGO.DESC_FORMA_PAGO,  
//			FS_PARAM.TIPO_IMPUESTO, IMPUESTOS_TIPO.DESC_IMPUESTO,   
//			FS_PARAM.MOTIVO_TRASLADO, MOTIVO_TRASLADO.DESCRIPCION,   
//			FS_PARAM.ALMACEN, ALMACEN.DESC_ALMACEN,   
//         FS_PARAM.PUNTO_VENTA, PUNTOS_VENTA.DESC_PTO_VTA,
//			FS_PARAM.FORMA_EMBARQUE, FORMA_EMBARQUE.DESCRIPCION
//   into 	:is_cod_moneda, :is_desc_moneda,
// 			:is_forma_pago, :is_desc_forma_pago,
//			:is_tipo_impuesto, :is_desc_impuesto,
//			:is_motivo_traslado, :is_desc_motivo,
//			:is_almacen, :is_desc_almacen,
//			:is_punto_venta, :is_desc_pto_vta,
//			:is_forma_embarque, :is_desc_forma_embarque         
//    FROM FS_PARAM,   
//         MONEDA,   
//         FORMA_PAGO,   
//         IMPUESTOS_TIPO,   
//         MOTIVO_TRASLADO,   
//         ALMACEN,   
//         PUNTOS_VENTA,   
//         FORMA_EMBARQUE  
//   WHERE moneda.cod_moneda (+) = fs_param.cod_moneda
//	  and forma_pago.forma_pago (+) = fs_param.forma_pago
//	  and impuestos_tipo.tipo_impuesto (+) = fs_param.tipo_impuesto
//	  and motivo_traslado.motivo_traslado (+) = fs_param.motivo_traslado
//	  and almacen.almacen (+) = fs_param.almacen
//	  and puntos_venta.punto_venta (+) = fs_param.punto_venta
//	  and forma_embarque.forma_embarque (+) = fs_param.forma_embarque
//	  and fs_param.cod_origen = :gs_origen;    
//
//
//if sqlca.sqlcode = 100 then
//	Messagebox( "Error", "no ha definido parametros en fs_param")
//	return 0
//end if
//
//if sqlca.sqlcode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	Messagebox( "Error", ls_mensaje)
//	return 0
//end if



return 1
end function

public function boolean wf_insert_cab_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, ref long al_nro_asiento, string as_moneda, decimal adc_tasa_cambio, string as_desc_glosa, datetime adt_fec_reg, date ad_fec_venta, string as_cod_usr);Boolean lb_ret = TRUE
String  ls_msj_err
n_cst_asiento_contable lnvo_asiento


try
	lnvo_asiento = create n_cst_asiento_contable
	//genera nro de asiento
	IF lnvo_asiento.of_get_nro_asiento(as_origen,al_ano,al_mes,al_nro_libro, al_nro_asiento)  = FALSE THEN
		lb_ret = False	
		return lb_ret
	END IF

	//
	
	/*Replicacion*/
	Insert Into cntbl_asiento(
		origen       ,ano         ,mes         ,
	 	nro_libro    ,nro_asiento ,cod_moneda  ,
	 	tasa_cambio  ,desc_glosa  ,fecha_cntbl ,
	 	fec_registro ,cod_usr     ,flag_estado ,
	 	flag_tabla   ,flag_replicacion)  
	Values(
		:as_origen       ,:al_ano         ,:al_mes      ,
	 	:al_nro_libro    ,:al_nro_asiento ,:as_moneda   ,
	 	:adc_tasa_cambio ,:as_desc_glosa  ,:ad_fec_venta ,
	 	:adt_fec_reg     ,:as_cod_usr	  ,'1'          ,
	 	'1' 					,'1')  ;
	 
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error Asiento Cabecera',ls_msj_err )
		lb_ret = FALSE
	END IF

catch(Exception ex)

	MessageBox('Exception', ex.getMessage())
	lb_ret = false

finally
	destroy lnvo_asiento
end try


RETURN lb_ret
end function

public function boolean wf_insert_cntas_cobrar_cab (long al_nro_serie, string as_tipo_doc, ref string as_nro_doc, string as_cod_relacion, long al_item_direccion, datetime adt_fec_reg, date ad_fec_venta, string as_forma_embarque, string as_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_forma_pago, string as_obs, string as_vendedor, string as_punto_venta);Long    ll_ins_row
Boolean lb_ret = TRUE

ll_ins_row = ids_cntas_cobrar_cab.InsertRow(0)

wf_num_doc_tipo(al_nro_serie,as_tipo_doc,as_nro_doc)

/*REPLICACION*/
//===GENERA NRO DE DOCUMENTO
ids_cntas_cobrar_cab.object.tipo_doc          [ll_ins_row] = as_tipo_doc
ids_cntas_cobrar_cab.object.nro_doc           [ll_ins_row] = as_nro_doc
ids_cntas_cobrar_cab.object.cod_relacion      [ll_ins_row] = as_cod_relacion
ids_cntas_cobrar_cab.object.item_direccion    [ll_ins_row] = al_item_direccion
ids_cntas_cobrar_cab.object.flag_estado       [ll_ins_row] = '1'
ids_cntas_cobrar_cab.object.fecha_registro    [ll_ins_row] = adt_fec_reg
ids_cntas_cobrar_cab.object.punto_venta       [ll_ins_row] = as_forma_embarque
ids_cntas_cobrar_cab.object.fecha_documento   [ll_ins_row] = ad_fec_venta
ids_cntas_cobrar_cab.object.fecha_vencimiento [ll_ins_row] = ad_fec_venta
ids_cntas_cobrar_cab.object.cod_moneda			 [ll_ins_row] = as_moneda
ids_cntas_cobrar_cab.object.tasa_cambio       [ll_ins_row] = adc_tasa_cambio
ids_cntas_cobrar_cab.object.cod_usr		       [ll_ins_row] = as_cod_usr
ids_cntas_cobrar_cab.object.origen		       [ll_ins_row] = as_origen
ids_cntas_cobrar_cab.object.ano			       [ll_ins_row] = al_ano
ids_cntas_cobrar_cab.object.mes			       [ll_ins_row] = al_mes
ids_cntas_cobrar_cab.object.nro_libro	       [ll_ins_row] = al_nro_libro
ids_cntas_cobrar_cab.object.nro_asiento       [ll_ins_row] = al_nro_asiento
ids_cntas_cobrar_cab.object.forma_pago	       [ll_ins_row] = as_forma_pago
ids_cntas_cobrar_cab.object.observacion       [ll_ins_row] = Mid(as_obs,1,40)
ids_cntas_cobrar_cab.object.flag_provisionado [ll_ins_row] = 'R'
ids_cntas_cobrar_cab.object.flag_replicacion  [ll_ins_row] = '1'
ids_cntas_cobrar_cab.object.vendedor			 [ll_ins_row] = as_vendedor
ids_cntas_cobrar_cab.object.punto_venta		 [ll_ins_row] = as_punto_venta

Return lb_ret
end function

public function boolean wf_insert_det_ov (string as_cod_origen, string as_cod_art, string as_doc_ov, string as_nro_ov, datetime adt_fec_reg, date ad_fec_venta, decimal adc_cant_proy, decimal adc_precio_unit, decimal adc_impuesto, string as_moneda, string as_cod_almacen, string as_cencos, string as_cnta_prsp);Boolean lb_ret = TRUE
String  ls_msj_err


Insert Into articulo_mov_proy
(cod_origen      ,flag_estado ,cod_art      ,
 tipo_mov        ,tipo_doc	   ,nro_doc      ,
 fec_registro    ,fec_proyect ,cant_proyect ,
 precio_unit     ,impuesto    ,cod_moneda   ,
 flag_replicacion,almacen		,cod_usr		  ,
 cencos			  ,cnta_prsp)
Values
(:as_cod_origen   , '1'           ,:as_cod_art    ,
 :is_tipo_mov     ,:as_doc_ov     ,:as_nro_ov     ,
 :adt_fec_reg	   ,:ad_fec_venta  ,:adc_cant_proy ,
 :adc_precio_unit ,:adc_impuesto  ,:as_moneda     ,
 '1'					,:as_cod_almacen,:gs_user		  ,
 :as_cencos			,:as_cnta_prsp	) ;

        
		  
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox("SQL error Error en AMP_OV", ls_msj_err)
	lb_ret = FALSE
END IF


RETURN lb_ret
end function

public function boolean wf_insert_mov_almacen (string as_cod_origen, ref string as_nro_vale, string as_cod_almacen, datetime adt_fecha_registro, date ad_fec_venta, string as_cod_usr, string as_proveedor, string as_nombre_usr, string as_origen_refer, string as_tipo_refer, string as_nro_refer);String  	ls_nro_vale,ls_msj_err
Boolean 	lb_ret = TRUE
DateTime	ldt_fecha

ldt_fecha = DateTime(ad_fec_venta, Time(adt_fecha_registro))

//ELIMINAR INFORMACION DE TABLA TEMPORAL
try
	as_nro_vale = f_numera_documento('num_vale_mov',10)
catch(Exception ex)
	gnvo_app.of_catch_exception(ex, 'Exception al numerar num_vale_mov')
end try

/*Replicacion*/
Insert Into vale_mov (
		cod_origen   ,nro_vale     ,almacen    ,flag_estado ,
	 	fec_registro ,tipo_mov     ,cod_usr    ,proveedor   ,
 		nom_receptor ,origen_refer ,tipo_refer ,nro_refer   ,
 		flag_replicacion
)Values(
		:as_cod_origen      ,:as_nro_vale    ,:as_cod_almacen , '1'         ,
 		:ldt_fecha 			  ,:is_tipo_mov    ,:as_cod_usr     ,:as_proveedor,
 		:as_nombre_usr      ,:as_origen_refer,:as_tipo_refer  ,:as_nro_refer,
 		'1' 
) ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	Rollback ;
   MessageBox("SQL error Vale Mov", ls_msj_err)
END IF

Return lb_ret
end function

on w_ve311_facturacion_simple.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_simplificado" then this.MenuID = create m_mantenimiento_simplificado
this.cbx_cop_det=create cbx_cop_det
this.cbx_copiar=create cbx_copiar
this.dw_report_fact=create dw_report_fact
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.dw_boleta=create dw_boleta
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_cop_det
this.Control[iCurrent+2]=this.cbx_copiar
this.Control[iCurrent+3]=this.dw_report_fact
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.dw_detail
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.dw_boleta
end on

on w_ve311_facturacion_simple.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_cop_det)
destroy(this.cbx_copiar)
destroy(this.dw_report_fact)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.dw_boleta)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)  				

idw_1 = dw_master              				// asignar dw corriente
//dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija


//tipo de movimiento de terceros
select oper_vnta_terc,doc_gr,cencos_vale_salida 
  into :is_tipo_mov,:is_doc_gr,:is_cencos_vsal 
  from logparam where reckey = '1' ;

//Factura y Boleta x Cobrar
select doc_fact_cobrar,doc_bol_cobrar 
  into :is_doc_fac,:is_doc_bvc 
  from finparam where reckey = '1' ;


//DataStore de Cntas Cobrar Cabecera y Detalle
ids_cntas_cobrar_cab = Create u_ds_base
ids_cntas_cobrar_cab.DataObject = 'd_abc_cntas_x_cobrar_cab_ff'
ids_cntas_cobrar_cab.SettransObject(sqlca)


ids_cntas_cobrar_det = Create Datastore
ids_cntas_cobrar_det.DataObject = 'd_abc_cntas_x_cobrar_det_ff'
ids_cntas_cobrar_det.SettransObject(sqlca)
//** **//


//DataStore de Impuesto
ids_impuesto_det = Create Datastore
ids_impuesto_det.DataObject = 'd_abc_cc_det_imp_tbl'
ids_impuesto_det.SettransObject(sqlca)


//Datastore de Matriz Contable
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)

//Datastore de Glosa
ids_data_glosa = Create Datastore
ids_data_glosa.Dataobject = 'd_data_glosa_grd'
ids_data_glosa.SettransObject(sqlca)

//Datastore de ref
ids_data_ref = Create Datastore
ids_data_ref.Dataobject = 'd_abc_doc_referencias_ctas_cob_tbl'
ids_data_ref.SettransObject(sqlca)

end event

event ue_insert;call super::ue_insert;Long    ll_row,ll_row_master,ll_count
String  ls_timpuesto,ls_almacen
Boolean lb_ret  = false

IF idw_1 = dw_detail THEN
	//verificar datos de la cabecera
	ll_row_master = dw_master.Getrow ()
	
	if ll_row_master = 0 or is_accion = 'fileopen' then return
	
	ls_timpuesto = dw_master.object.tipo_impuesto [ll_row_master]
	ls_almacen	 = dw_master.object.almacen	    [ll_row_master]
		
	IF Isnull(ls_timpuesto) OR Trim(ls_timpuesto) = '' THEN
		Messagebox('Aviso','Debe Ingresar Tipo de Impuesto ,Verifique!')
		Return
	END IF
	
	select count(*) into :ll_count from almacen_tipo_mov 
	 where (almacen  = :ls_almacen ) and
	 		 (tipo_mov = :is_tipo_mov) ;
	
	if ll_count = 0 then
		Messagebox('Aviso','Almacen no tiene tipo de movimiento de venta a Terceros')
		Return
	end if
ELSE
	lb_ret = true
	/*recupera datos*/
	String   ls_cod_relacion    ,ls_tipo_impuesto ,&
				ls_forma_pago	    ,ls_cod_moneda	  ,ls_forma_embarque,&
				ls_motivo_traslado ,ls_destinatario	  ,ls_punto_partida ,&
				ls_nom_vendedor	 ,ls_obs
	Decimal {3} ldc_tasa_cambio
	Long     ll_item_direccion
	Datetime ldt_fecha_registro
	
	//verificar datos de la cabecera
	ll_row_master = dw_master.Getrow ()

	if ll_row_master > 0 then
		ls_cod_relacion    = dw_master.object.cod_relacion    [ll_row_master]
		ll_item_direccion  = dw_master.object.item_direccion  [ll_row_master]
		ldt_fecha_registro = dw_master.object.fecha_registro  [ll_row_master]
		ls_tipo_impuesto	 = dw_master.object.tipo_impuesto   [ll_row_master]
		ls_almacen			 = dw_master.object.almacen		   [ll_row_master]
		ls_forma_pago		 = dw_master.object.forma_pago	   [ll_row_master]
		ls_cod_moneda		 = dw_master.object.cod_moneda	   [ll_row_master]
		ldc_tasa_cambio	 = dw_master.object.tasa_cambio	   [ll_row_master]
		ls_forma_embarque  = dw_master.object.forma_embarque  [ll_row_master]
		ls_motivo_traslado = dw_master.object.motivo_traslado [ll_row_master]
		ls_destinatario	 = dw_master.object.destinatario    [ll_row_master]
		ls_punto_partida	 = dw_master.object.punto_partida	[ll_row_master]
		ls_nom_vendedor	 = dw_master.object.nom_vendedor  	[ll_row_master]
		ls_obs				 = dw_master.object.observacion		[ll_row_master]
	end if
	
	dw_master.Reset()
	dw_detail.Reset()
	ids_cntas_cobrar_cab.Reset()
	ids_cntas_cobrar_det.Reset()
	ids_impuesto_det.Reset()	
	ids_data_glosa.Reset()
	ids_data_ref.Reset()
	
	is_accion = 'new'
	rb_1.enabled = true
	rb_2.enabled = true
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

	/*si exista registro copia los datos de cabecera*/
	if cbx_copiar.checked = true and lb_ret = true then
		dw_master.object.cod_relacion    [ll_row] = ls_cod_relacion
		dw_master.object.item_direccion  [ll_row] = ll_item_direccion
		dw_master.object.fecha_registro  [ll_row] = ldt_fecha_registro
		dw_master.object.tipo_impuesto   [ll_row] = ls_tipo_impuesto
		dw_master.object.almacen		   [ll_row] = ls_almacen
		dw_master.object.forma_pago	   [ll_row] = ls_forma_pago
		dw_master.object.cod_moneda	   [ll_row] = ls_cod_moneda
		dw_master.object.tasa_cambio	   [ll_row] = ldc_tasa_cambio
	   dw_master.object.forma_embarque  [ll_row] = ls_forma_embarque
		dw_master.object.motivo_traslado [ll_row] = ls_motivo_traslado
		dw_master.object.destinatario    [ll_row] = ls_destinatario
		dw_master.object.punto_partida	[ll_row] = ls_punto_partida
		dw_master.object.nom_vendedor  	[ll_row] = ls_nom_vendedor
		dw_master.object.observacion		[ll_row] = ls_obs
	end if

end event

event resize;call super::resize;dw_detail.width  = newwidth  - dw_detail.x - 20
dw_detail.height = newheight - dw_detail.y - 20

end event

event ue_update_pre;call super::ue_update_pre;String ls_expresion      , ls_item_doc_old  ,ls_order          ,ls_cod_origen    ,&
		 ls_cod_relacion   , ls_cod_moneda	  ,ls_forma_pago     ,ls_cod_usr	      ,&
		 ls_destinatario   , ls_punto_partida ,ls_obs		      ,ls_nom_vendedor  ,&
		 ls_forma_embarque , ls_nombre_usr	  ,ls_doc_ov	      ,ls_nro_ov		   ,&
		 ls_cod_almacen	 , ls_doc_gr		  ,ls_nro_guia       ,ls_mot_traslado  ,&
		 ls_nom_chofer		 , ls_nro_brevete	  ,ls_nro_placa      ,ls_nro_placa_carr,&
	    ls_prov_transp	 , ls_marca_veh	  ,ls_nro_vale_mov   ,ls_cod_art			,&
		 ls_cencos			 , ls_cnta_prsp	  ,ls_msj_err	      ,ls_doc_fac			,&
		 ls_doc_bvc			 , ls_tipo_doc		  ,ls_nro_doc        ,ls_confin			,&
		 ls_nom_art			 , ls_tipo_impuesto ,ls_flag_detraccion,ls_nro_detrac		,&
		 ls_soles          , ls_dolares       ,ls_cert_insc		,ls_cnta_ctbl		,&
		 ls_flag_debhab	 , ls_desc_impuesto ,ls_rubro				,ls_result			,&
		 ls_mensaje			 , ls_comp_final    , ls_vendedor		, ls_pto_vta
		 
String ls_item_doc [],ls_item_null []
Long   ll_inicio    ,ll_inicio_arr = 1 ,ll_inicio_det  ,ll_nro_serie_guia ,ll_item_doc     ,&
		 ll_nro_libro ,ll_ano            ,ll_mes		    ,ll_nro_asiento    ,ll_nro_serie_doc,&
		 ll_item_direccion,ll_row_ins_det,ll_item_new_doc = 0
Decimal {2} ldc_total_lin,ldc_total_fin,ldc_importe_igv,ldc_total_ov,ldc_porc_det,ldc_tasa_impuesto,ldc_total_fin_d
Decimal {3} ldc_tasa_cambio
Decimal {4} ldc_cant_proy
Decimal {6} ldc_precio_unit,ldc_precio_unit_exp
Datetime	   ldt_fecha_reg
Date			ld_fec_venta
Boolean		lb_imp = FALSE

//declaracion local de objeto
n_cst_asiento_contable lnvo_asiento_cntbl

ib_update_check = TRUE

if is_accion = 'fileopen' then return

if dw_detail.Rowcount() = 0 then 
	Messagebox('Aviso','Debe Ingresar Datos en el detalle ,Verifique!')
	ib_update_check = FALSE
	RETURN											 
end if	

//datos 
dw_master.AcceptText()
ll_nro_serie_guia	= dw_master.object.nro_serie_guia  [1]
ll_nro_serie_doc	= dw_master.object.nro_serie_doc   [1]
ls_cod_origen     = dw_master.object.cod_origen      [1]
ls_cod_relacion   = dw_master.object.cod_relacion    [1]
ls_comp_final		= dw_master.object.comp_final 	  [1]
ldt_fecha_reg	   = dw_master.object.fecha_registro  [1]
ld_fec_venta		= Date(dw_master.object.fec_venta  [1])
ls_cod_moneda	   = dw_master.object.cod_moneda	     [1]
ls_forma_pago	   = dw_master.object.forma_pago	     [1]
ls_cod_usr		   = dw_master.object.cod_usr		     [1]
ls_destinatario   = dw_master.object.destinatario	  [1]
ls_punto_partida  = dw_master.object.punto_partida   [1]
ls_obs			   = Mid(dw_master.object.observacion [1],1,60)
ls_nom_vendedor   = dw_master.object.nom_vendedor    [1]
ls_forma_embarque = dw_master.object.forma_embarque  [1]
ls_cod_almacen		= dw_master.object.almacen			  [1]
ls_mot_traslado	= dw_master.object.motivo_traslado [1]
ls_tipo_impuesto  = dw_master.object.tipo_impuesto   [1]
ldc_tasa_cambio	= dw_master.object.tasa_cambio	  [1]
ll_ano				= Long(String(dw_master.object.fecha_registro  [1],'yyyy'))
ll_mes				= Long(String(dw_master.object.fecha_registro  [1],'mm'))
ll_item_direccion	= dw_master.object.item_direccion  [1]
ls_vendedor			= dw_master.object.vendedor        [1]
ls_pto_vta			= dw_master.object.punto_venta     [1]

//verificar que tipo de documento se generara
select doc_fact_cobrar,doc_bol_cobrar  
	into :ls_doc_fac,:ls_doc_bvc  
from finparam 
where (reckey = '1') ;
 
 if rb_1.checked then //factura por cobrar
	if Isnull(ls_doc_fac) or trim(ls_doc_fac) = '' then
		Messagebox('Aviso','Debe Ingresar en Tabla Finparam Campo doc_fact_cobrar')
		ib_update_check = FALSE
		RETURN
	else
		ls_tipo_doc = ls_doc_fac
	end if
	
elseif rb_2.checked then //boleta por cobrar
	if Isnull(ls_doc_bvc) or trim(ls_doc_bvc) = '' then
		Messagebox('Aviso','Debe Ingresar en Tabla Finparam Campo doc_bol_cobrar')	
		ib_update_check = FALSE
		RETURN		
	else
		ls_tipo_doc = ls_doc_bvc
	end if
end if

//VALIDAR CIERRE CONTABLE
//Crear Objeto
lnvo_asiento_cntbl = create n_cst_asiento_contable

/*verifica cierre*/
lnvo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	ib_update_check = False	
	Return
END IF

//Validar Cabecera ...
IF IsNull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Relacion ,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_pto_vta) OR Trim(ls_pto_vta) = '' THEN
	Messagebox('Aviso','Debe Ingresar Punto de Venta ,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('punto_venta')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_comp_final) OR Trim(ls_comp_final) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Comprador Final ,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('comp_final')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Moneda ,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio ,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ll_nro_serie_doc)  THEN
	Messagebox('Aviso','Debe Ingresar Nro de Serie de Documento,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('nro_serie_doc')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_forma_pago) OR Trim(ls_forma_pago) = ''  THEN
	Messagebox('Aviso','Debe Ingresar Forma de Pago,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('forma_pago')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_forma_embarque) OR Trim(ls_forma_embarque) = ''  THEN
	Messagebox('Aviso','Debe Ingresar Forma de Embarque,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('forma_embarque')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_tipo_impuesto) OR Trim(ls_tipo_impuesto) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Impuesto,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('tipo_impuesto')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_cod_almacen) OR Trim(ls_cod_almacen) = '' THEN
	Messagebox('Aviso','Debe Ingresar Almacen,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('almacen')
	ib_update_check = FALSE
	RETURN		
END IF

IF IsNull(ls_vendedor) OR Trim(ls_vendedor) = '' THEN
	Messagebox('Aviso','Debe Ingresar un Vendedor Valido,Verifique!')	
	dw_master.SetFocus()
	dw_master.SetColumn('vendedor')
	ib_update_check = FALSE
	RETURN		
END IF

if ls_tipo_doc = ls_doc_fac then //datos obligatorios para factura

	IF IsNull(ll_item_direccion)  THEN
		Messagebox('Aviso','Debe Ingresar Dirección ,Verifique!')	
		dw_master.SetFocus()
		dw_master.SetColumn('item_direccion')
		ib_update_check = FALSE
		RETURN		
	END IF

	IF IsNull(ls_mot_traslado) OR Trim(ls_mot_traslado) = '' THEN
		Messagebox('Aviso','Debe Ingresar Motivo de Traslado,Verifique!')	
		dw_master.SetFocus()
		dw_master.SetColumn('motivo_traslado')
		ib_update_check = FALSE
		RETURN		
	END IF
	
	IF IsNull(ls_punto_partida) OR Trim(ls_punto_partida) = '' THEN
		Messagebox('Aviso','Debe Ingresar Punto de Partida,Verifique!')	
		dw_master.SetFocus()
		dw_master.SetColumn('punto_partida')
		ib_update_check = FALSE
		RETURN		
	END IF
	
	IF IsNull(ls_destinatario) OR Trim(ls_destinatario) = '' THEN
		Messagebox('Aviso','Debe Ingresar Destino ,Verifique!')	
		dw_master.SetFocus()
		dw_master.SetColumn('destinatario')
		ib_update_check = FALSE
		RETURN		
	END IF

	IF IsNull(ll_nro_serie_guia)  THEN
		Messagebox('Aviso','Debe Ingresar Nro de Serie de Guia ,Verifique!')	
		dw_master.SetFocus()
		dw_master.SetColumn('nro_serie_guia')
		ib_update_check = FALSE
		RETURN		
	END IF
	
end if

//no dejar pasar item_doc nulos
//Recuperar impuesto
select cnta_ctbl,decode(flag_dh_cxp ,'D','H','D'),desc_impuesto,tasa_impuesto
  into :ls_cnta_ctbl,:ls_flag_debhab,:ls_desc_impuesto,:ldc_tasa_impuesto
  from impuestos_tipo 
 where ( tipo_impuesto = :ls_tipo_impuesto ) ;
 
if Isnull(ls_cnta_ctbl) or Trim(ls_cnta_ctbl) = '' then
	Messagebox('Aviso',' Cuenta Contable de Impuesto No existe Verifique!')
	ib_update_check = FALSE
	RETURN				
end if

if Isnull(ls_flag_debhab) or Trim(ls_flag_debhab) = '' then
	Messagebox('Aviso',' Flag Debhab de Impuesto No existe Verifique!')
	ib_update_check = FALSE
	RETURN				
end if

//Recuperar Nombre de Usuario
select nombre 
	into :ls_nombre_usr 
	from usuario 
where (cod_usr = :ls_cod_usr);

//Parametros de Orden de Venta,guia
select cod_soles,cod_dolares,doc_ov,doc_gr 
	into :ls_soles,:ls_dolares,:ls_doc_ov ,:ls_doc_gr 
from logparam  
where (reckey = '1' );

//Nro de Libro x tipo de Documento
select nro_libro 
	into :ll_nro_libro 
from doc_tipo 
where (tipo_doc = :ls_tipo_doc) ;

IF Isnull(ll_nro_libro) or ll_nro_libro = 0 THEN
	Messagebox('Aviso','Nro de Libro No Existe para tipo de Documento '+ls_tipo_doc)
	ib_update_check = FALSE
	RETURN			
END IF

//ordenar datawindow
ls_order = 'Trim(String(item_doc)) , Trim(String(fila)) '
dw_detail.SetSort(ls_order)
dw_detail.Sort()
//
dw_detail.Groupcalc()






//inicializacion de variables
ls_item_doc = ls_item_null

ls_item_doc_old = Trim(String(dw_detail.object.item_doc [1]))
ls_item_doc [ll_inicio_arr] = ls_item_doc_old

For ll_inicio = 1 to dw_detail.Rowcount()
	
	 ls_cod_art  		  = dw_detail.object.cod_art  			[ll_inicio]	
	 ll_item_doc 		  = dw_detail.object.item_doc 			[ll_inicio]	 	
	 ldc_cant_proy 	  = dw_detail.Object.cant_proyect	   [ll_inicio]
	 ldc_precio_unit    = dw_detail.Object.precio_unit		   [ll_inicio]	
	 ldc_precio_unit_exp= dw_detail.Object.precio_unit_exp   [ll_inicio]	
	 ls_cencos			  = dw_detail.Object.cencos			   [ll_inicio]	
	 ls_cnta_prsp		  = dw_detail.Object.cnta_prsp		   [ll_inicio] 	
	 ls_nom_art  	  	  = dw_detail.object.nom_articulo      [ll_inicio]	 
   	 ls_nom_chofer      = dw_detail.Object.nom_chofer        [ll_inicio]
	 ls_nro_brevete     = dw_detail.Object.nro_brevete       [ll_inicio]
	 ls_nro_placa	     = dw_detail.Object.nro_placa         [ll_inicio]
	 ls_nro_placa_carr  = dw_detail.Object.nro_placa_carreta [ll_inicio]
	 ls_confin			  = dw_detail.Object.confin				[ll_inicio] 	
	 
	IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' then
		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('cod_art')
		 Messagebox('Aviso','Debe Ingresar Codigo de Articulo , Verifique!')
		 ib_update_check = FALSE
		 RETURN	
	 END IF

	 IF Isnull(ll_item_doc)  then
		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('item_doc')
		 Messagebox('Aviso','Debe Ingresar Item Doc , Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF
	 	 
	 IF Isnull(ldc_cant_proy) OR ldc_cant_proy = 0  then
		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('cant_proyect')
		 Messagebox('Aviso','Debe Ingresar Alguna Cantidad , Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF	
	 
 	 IF Isnull(ldc_precio_unit) OR ldc_precio_unit = 0  then
 		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('precio_unit')
		 Messagebox('Aviso','Debe Ingresar Precio Unitario , Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF	 
	 
	 IF Isnull(ldc_precio_unit_exp) OR ldc_precio_unit_exp = 0  then
 		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('precio_unit_exp')
		 Messagebox('Aviso','Debe Ingresar Precio Unitario Ex - Planta, Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF	 
	 
 	 IF Isnull(ls_cencos) OR Trim(ls_cencos) = ''  then
 		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('cencos')
		 Messagebox('Aviso','Debe Ingresar Centro de Costo , Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF	 
	 
	 IF Isnull(ls_cnta_prsp) OR Trim(ls_cnta_prsp) = ''  then
 		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('cnta_prsp')
		 Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal , Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF

 	 IF Isnull(ls_confin) OR Trim(ls_confin) = ''  then
 		 dw_detail.SetFocus()
		 dw_detail.SelectRow(0, False)
		 dw_detail.SelectRow(ll_inicio, True)
 		 dw_detail.Setrow(ll_inicio)
		 dw_detail.Setcolumn('confin')
		 Messagebox('Aviso','Debe Ingresar Concepto Financiero , Verifique!')		 
		 ib_update_check = FALSE
		 RETURN	
	 END IF	 

	 //cuando tipo de documento sea factura
	 if ls_tipo_doc = ls_doc_fac then
		/*	
		IF Isnull(ls_nom_chofer) OR Trim(ls_nom_chofer) = ''  then
			 dw_detail.SetFocus()
			 dw_detail.SelectRow(0, False)
			 dw_detail.SelectRow(ll_inicio, True)
			 dw_detail.Setrow(ll_inicio)
			 dw_detail.Setcolumn('nom_chofer')
			 Messagebox('Aviso','Debe Ingresar Nombre de Chofer , Verifique!')		 
			 ib_update_check = FALSE
			 RETURN	
		END IF	 	
		
		IF Isnull(ls_nro_brevete) OR Trim(ls_nro_brevete) = ''  then
			 dw_detail.SetFocus()
			 dw_detail.SelectRow(0, False)
			 dw_detail.SelectRow(ll_inicio, True)
			 dw_detail.Setrow(ll_inicio)
			 dw_detail.Setcolumn('nro_brevete')
			 Messagebox('Aviso','Debe Ingresar Nro de Brevete , Verifique!')		 
			 ib_update_check = FALSE
			 RETURN	
		END IF 
		
		IF Isnull(ls_nro_placa) OR Trim(ls_nro_placa) = ''  then
			 dw_detail.SetFocus()
			 dw_detail.SelectRow(0, False)
			 dw_detail.SelectRow(ll_inicio, True)
			 dw_detail.Setrow(ll_inicio)
			 dw_detail.Setcolumn('nro_placa')
			 Messagebox('Aviso','Debe Ingresar Nro de Placa , Verifique!')		 
			 ib_update_check = FALSE
			 RETURN	
		END IF 
		 
		 
		 IF Isnull(ls_nro_placa_carr) OR Trim(ls_nro_placa_carr) = ''  then
		    dw_detail.SetFocus()
		 	 dw_detail.SelectRow(0, False)
		 	 dw_detail.SelectRow(ll_inicio, True)
 		 	 dw_detail.Setrow(ll_inicio)
		 	 dw_detail.Setcolumn('nro_placa_carreta')
		 	 Messagebox('Aviso','Debe Ingresar Nro de Placa de Carreta, Verifique!')		 
		 	 ib_update_check = FALSE
		 	 RETURN	
	 	 END IF  
		*/
		
	 end if

	 IF ls_item_doc_old <> Trim(String(dw_detail.object.item_doc [ll_inicio])) THEN
		 //asigno valor
		 ls_item_doc_old = Trim(String(dw_detail.object.item_doc [ll_inicio]))		
       //diferente
	    ll_inicio_arr = ll_inicio_arr + 1
		ls_item_doc [ll_inicio_arr] = ls_item_doc_old
		 
	 END IF
	 
	 //acumulador
	 ldc_total_lin = dw_detail.object.tot_lin [ll_inicio]
	 
	 if Isnull(ldc_total_lin) then ldc_total_lin = 0.00
	 
	 //TOTAL DE ORDEN DE VENTA
	 ldc_total_ov = ldc_total_ov + ldc_total_lin
	 	
Next	 

//LBRACO estubo DESACTIVADO lo active
////=========================================
////Generacion de Orden de Venta Unica
////=========================================
IF wf_insert_orden_venta(ls_cod_origen     ,ldt_fecha_reg   ,ls_forma_pago    ,&
   	                   ls_cod_moneda     ,ls_nom_vendedor ,ls_cod_usr		   ,&
       	                ls_cod_relacion   ,ls_destinatario ,ls_punto_partida ,&
							 	 ls_forma_embarque ,ls_obs          ,ls_nro_ov        ,&
							 	 ldc_total_ov, ls_comp_final, ls_vendedor ) = FALSE THEN
	
	ib_update_check = FALSE
	RETURN			


END IF
//		ESTO FUE EDITADO estubo DESACTIVADO lo active



/**ESTO NO ESTUBO HERE****/

		  //  cabecera de movimiento de almacen
		 	  IF wf_insert_mov_almacen (ls_cod_origen ,ls_nro_vale_mov ,ls_cod_almacen  ,&
				                         ldt_fecha_reg , ld_fec_venta, ls_cod_usr      ,ls_cod_relacion ,&
											    ls_nombre_usr ,ls_cod_origen   ,ls_doc_ov       ,&
											    ls_nro_ov) = 	FALSE THEN
				  
				  ib_update_check = FALSE
				  RETURN
			  END IF
												 
			  IF ls_tipo_doc = ls_doc_fac THEN							 
				  //  cabecera de guia
 			     IF wf_insert_guia		  (ll_nro_serie_guia ,ls_doc_gr       ,ls_nro_guia      ,&
											      ls_cod_origen     ,ls_cod_almacen  ,ldt_fecha_reg    ,&
												   ls_mot_traslado   ,ls_cod_relacion ,ls_nom_chofer    ,&
													ls_nro_brevete	   ,ls_nro_placa    ,ls_nro_placa_carr,&
												   ls_destinatario   ,ls_cod_usr      ,ls_prov_transp	  ,&
													ls_obs            ,ls_marca_veh    ,ls_cert_insc  ) = FALSE THEN
					  ib_update_check = FALSE
					  RETURN
				  END IF
			  END IF
						
			  // cabecera de asientos
			  IF wf_insert_cab_asiento (ls_cod_origen  , ll_ano        , ll_mes          , ll_nro_libro     ,&
			                            ll_nro_asiento , ls_cod_moneda , ldc_tasa_cambio , Mid(ls_obs,1,60) ,&
											    ldt_fecha_reg  , ld_fec_venta  , ls_cod_usr	 ) = FALSE THEN
				  ib_update_check = FALSE
				  RETURN								 
			  END IF
		
  			  //datastore de cntas cobrar
			  wf_insert_cntas_cobrar_cab (ll_nro_serie_doc  ,ls_tipo_doc       ,ls_nro_doc      , &
			  										ls_cod_relacion   ,ll_item_direccion ,ldt_fecha_reg   , ld_fec_venta, &
													ls_forma_embarque ,ls_cod_moneda     ,ldc_tasa_cambio , &
													ls_cod_usr        ,ls_cod_origen	    ,ll_ano				, &
													ll_mes				,ll_nro_libro      ,ll_nro_asiento  , &
													ls_forma_pago		,ls_obs				 , ls_vendedor		, &
													ls_pto_vta)
		
			//  -------------------------------------------------------------detracc
	/*************/
	
	//GRABA REFERENCIA
			 IF ls_tipo_doc = ls_doc_fac THEN //FACTURA X GUIA
				 wf_insert_ref_cc(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
				 					   ls_cod_origen   ,ls_doc_gr  ,ls_nro_guia )
										 
										 
			 ELSE //BOLETA X ORDEN DE VENTA
				wf_insert_refer_cc_ov(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
				 					       ls_cod_origen   ,ls_doc_ov  ,ls_nro_ov )
				
			 END IF	
	
	//* NO ESTUBO HERE LBRACO */////

//actualizo orden de venta en cabecera
dw_master.object.nro_ov [1] = ls_nro_ov

//Filtrar detalle de documentos x arreglo

//AQUI EDIT LBRACO
for ll_inicio = 1 to UpperBound(ls_item_doc)
	 //inicializacion de variable
	 ldc_total_fin   = 0.00
	 ldc_total_lin   = 0.00
	 
	 //filtrar por item de documento	
	 ls_expresion = 'item_doc = '+ls_item_doc [ll_inicio]	 
	 dw_detail.SetFilter(ls_expresion)
	 dw_detail.Filter()
	 
	 //ESTO ESTUBO ACTIVADO LBRACO
	 //=========================================
	 //Generacion de Orden de Venta Unica
	 //=========================================
//	 IF wf_insert_orden_venta(ls_cod_origen     ,ldt_fecha_reg   ,ls_forma_pago    ,&
//   	                       ls_cod_moneda     ,ls_nom_vendedor ,ls_cod_usr		 ,&
//       	                    ls_cod_relacion   ,ls_destinatario ,ls_punto_partida ,&
//					     		 	  ls_forma_embarque ,ls_obs          ,ls_nro_ov        ,&
//							 	     ldc_total_ov      ,ls_comp_final  ,ls_vendedor ) = FALSE THEN
//	
//		 ib_update_check = FALSE
//		 RETURN			
//	 END IF
	  //ESTO ESTUBO ACTIVADO LBRACO
	  
	 ldc_total_ov = 0.00

	 for ll_inicio_det = 1 to dw_detail.rowcount()
		  
		  //datos
		  ls_nom_chofer       = dw_detail.Object.nom_chofer        [ll_inicio_det]
		  ls_nro_brevete      = dw_detail.Object.nro_brevete       [ll_inicio_det]
		  ls_nro_placa	       = dw_detail.Object.nro_placa         [ll_inicio_det]
		  ls_nro_placa_carr   = dw_detail.Object.nro_placa_carreta [ll_inicio_det]
		  ls_prov_transp	    = dw_detail.Object.prov_transp		  [ll_inicio_det]
		  ls_marca_veh		    = dw_detail.Object.marca_vehiculo    [ll_inicio_det]
		  ls_cert_insc		    = dw_detail.Object.cert_inscp		  [ll_inicio_det]
		  ls_cod_art		    = dw_detail.Object.cod_art			  [ll_inicio_det]
		  ldc_cant_proy 	    = dw_detail.Object.cant_proyect	     [ll_inicio_det]
		  ldc_precio_unit     = dw_detail.Object.precio_unit		  [ll_inicio_det]	
		  ldc_precio_unit_exp = dw_detail.Object.precio_unit_exp   [ll_inicio_det]	
		  ldc_importe_igv     = dw_detail.Object.importe_igv		  [ll_inicio_det]
		  ls_cencos			    = dw_detail.Object.cencos			     [ll_inicio_det]	
		  ls_cnta_prsp		    = dw_detail.Object.cnta_prsp		     [ll_inicio_det] 	
		  ls_confin			    = dw_detail.Object.confin				  [ll_inicio_det] 	
		  ls_nom_art  	  	    = dw_detail.object.nom_articulo      [ll_inicio_det]
		  ll_item_doc		    = dw_detail.object.item_doc		     [ll_inicio_det]
		  ls_rubro				 = dw_detail.object.rubro			     [ll_inicio_det]
		 		  
		  if Isnull(ldc_importe_igv) then ldc_importe_igv = 0.00
		  
		  ldc_total_lin = dw_detail.object.tot_lin	[ll_inicio_det]
		  
		  ldc_total_fin = ldc_total_fin + ldc_total_lin
		  
		  //==========================================
		  //Generacion de Documento Mov Almacen ,Guia 
		  //Una Sola Vez x Cada Item Documento
		  //==========================================
		  
		 /*AQUI ESTUBO*/
//		  if ll_inicio_det = 1 then	
//			  //  cabecera de movimiento de almacen
//		 	  IF wf_insert_mov_almacen (ls_cod_origen ,ls_nro_vale_mov ,ls_cod_almacen  ,&
//				                         ldt_fecha_reg , ld_fec_venta, ls_cod_usr      ,ls_cod_relacion ,&
//											    ls_nombre_usr ,ls_cod_origen   ,ls_doc_ov       ,&
//											    ls_nro_ov) = 	FALSE THEN
//				  
//				  ib_update_check = FALSE
//				  RETURN
//			  END IF
//												 
//			  IF ls_tipo_doc = ls_doc_fac THEN							 
//				  //  cabecera de guia
// 			     IF wf_insert_guia		  (ll_nro_serie_guia ,ls_doc_gr       ,ls_nro_guia      ,&
//											      ls_cod_origen     ,ls_cod_almacen  ,ldt_fecha_reg    ,&
//												   ls_mot_traslado   ,ls_cod_relacion ,ls_nom_chofer    ,&
//													ls_nro_brevete	   ,ls_nro_placa    ,ls_nro_placa_carr,&
//												   ls_destinatario   ,ls_cod_usr      ,ls_prov_transp	  ,&
//													ls_obs            ,ls_marca_veh    ,ls_cert_insc  ) = FALSE THEN
//					  ib_update_check = FALSE
//					  RETURN
//				  END IF
//			  END IF
//						
//			  // cabecera de asientos
//			  IF wf_insert_cab_asiento (ls_cod_origen  , ll_ano        , ll_mes          , ll_nro_libro     ,&
//			                            ll_nro_asiento , ls_cod_moneda , ldc_tasa_cambio , Mid(ls_obs,1,60) ,&
//											    ldt_fecha_reg  , ld_fec_venta  , ls_cod_usr	 ) = FALSE THEN
//				  ib_update_check = FALSE
//				  RETURN								 
//			  END IF
//		
//  			  //datastore de cntas cobrar
//			  wf_insert_cntas_cobrar_cab (ll_nro_serie_doc  ,ls_tipo_doc       ,ls_nro_doc      , &
//			  										ls_cod_relacion   ,ll_item_direccion ,ldt_fecha_reg   , ld_fec_venta, &
//													ls_forma_embarque ,ls_cod_moneda     ,ldc_tasa_cambio , &
//													ls_cod_usr        ,ls_cod_origen	    ,ll_ano				, &
//													ll_mes				,ll_nro_libro      ,ll_nro_asiento  , &
//													ls_forma_pago		,ls_obs				 , ls_vendedor		, &
//													ls_pto_vta)
//		 /*--------------*/											
			  //ACTUALIZA MOVIMIENTO DE ALMACEN
			  if ls_tipo_doc = ls_doc_bvc then
				  IF wf_update_vale_mov(ls_cod_origen ,ls_nro_vale_mov,ls_tipo_doc,ls_nro_doc) = FALSE THEN
					  ib_update_check = FALSE
					  RETURN	
				  END IF
			  end if	
			  
//		  end if
		 /*--------------*/
		  
   	  //generacion de detalle de en Orden de Venta y Movimiento de Almacen	 
		  // detalle de orden de venta
		  IF wf_insert_det_ov (ls_cod_origen   ,ls_cod_art        ,ls_doc_ov     ,&
		                       ls_nro_ov       ,ldt_fecha_reg     ,ld_fec_venta ,ldc_cant_proy ,&
			 					     ldc_precio_unit ,ldc_tasa_impuesto ,ls_cod_moneda ,&
									  ls_cod_almacen	,ls_cencos			 ,ls_cnta_prsp) = FALSE THEN
			  ib_update_check = FALSE
			  RETURN
		  END IF		

		  // detalle de movimiento de almacen
		  IF wf_insert_det_vale_mov(ls_cod_origen ,ls_nro_vale_mov ,ls_cod_art    ,&
		 	 							    ldc_cant_proy ,ldc_precio_unit ,ls_cod_moneda ,&
										    ls_cencos     ,ls_cnta_prsp ) = FALSE THEN
			  ib_update_check = FALSE
			  RETURN											 
		  END IF

		  // Llenar Datastore detalle cntas cobrar                           ll_inicio_det  / change !!!! lbraco
		  wf_insert_cntas_cobrar_det(ls_tipo_doc   ,ls_nro_doc      ,ll_item_doc 		,&
		  									  ls_confin     ,ls_nom_art      ,ls_cod_art    	   ,&
											  ldc_cant_proy ,ldc_precio_unit ,ldc_precio_unit_exp ,&
											  ls_doc_ov	  	 ,ls_nro_ov       ,ll_row_ins_det 		,&
											  ls_rubro)
		
		  if ldc_importe_igv > 0 then
		  	  //genera impuesto                                                        ll_inicio_det  / change !!!! lbraco
			  wf_insert_impuesto_det (ls_tipo_doc      ,ls_nro_doc      ,ll_item_doc,&
			  								  ls_tipo_impuesto ,ldc_importe_igv	)	 
		     
			  lb_imp = TRUE
		  else
			  lb_imp = FALSE
		  end if
		  
		  //Llenar Detalle de Asientos
		  IF wf_insert_det_asiento (ls_cod_origen  ,ll_ano          ,ll_mes        ,ll_nro_libro ,&
			                         ll_nro_asiento ,ll_row_ins_det  ,ldt_fecha_reg ,ls_cod_moneda,&
					   					 ldc_tasa_cambio,ls_cod_relacion ,lb_imp        ,ls_cnta_ctbl ,&
											 ls_flag_debhab ,ls_desc_impuesto,ldc_importe_igv) = FALSE THEN
			  
			  ib_update_check = FALSE
			  RETURN											 
		  END IF

		  //==================================================
		  //Generacion de Guia x Vale
		  //Una Sola Vez x Cada Item Documento 
		  //Generado Una vez Terminado los detalles de C/Item
		  //==================================================
		  //despues de ingresar detalle
		  
		  IF ll_inicio_det = dw_detail.rowcount() THEN
			
			  //contador de generacion de documentos
           ll_item_new_doc = ll_item_new_doc + 1
			  
  			 IF ls_tipo_doc = ls_doc_fac THEN			
					//esto fue editado lbraco
//			    IF wf_guia_vale (ls_nro_guia   ,ls_nro_vale_mov ,ls_cod_origen ) = FALSE THEN
//					 ib_update_check = FALSE
//					 RETURN											 
//				 END IF
//esto fue editado lbraco
			 END IF	  
			  
//			 IF ls_tipo_doc = ls_doc_fac then
				 //PREGUNTAR SI GENERARIA DETRACCION
				 // ESTO FUE DESACTIVADO LBRACO
//				 IF wf_genera_detraccion(ls_item_doc [ll_inicio],ls_flag_detraccion,ldt_fecha_reg,ldc_porc_det,ls_nro_detrac,&
//												 ls_cod_origen     ,ldc_total_fin ) = FALSE THEN 
//					 ib_update_check = FALSE
//					 RETURN													 
//				 END IF
				 // ESTO FUE DESACTIVADO LBRACO
//			end if
											 
			 //=ACTUALIZA CABECERA DE CTAS COBRAR  DESACTIVADP LBRACO
//			 IF wf_update_cta_cobrar(ls_tipo_doc  ,ls_nro_doc   ,ls_flag_detraccion,&
//			 								 ldc_porc_det ,ls_nro_detrac,ldc_total_fin     ,&
//											 ls_soles    ,ls_dolares    ,ls_cod_moneda     ,&
//											 ldc_tasa_cambio ) = FALSE THEN
//				 ib_update_check = FALSE
//				 RETURN													 
//			 END IF
			 
			 IF wf_insert_ttemp(ls_cod_origen ,ls_nro_ov   ,ll_item_new_doc ,&
								     '1'           ,ls_tipo_doc ,ls_nro_doc      ,&
									  ls_nro_guia   ,ls_nro_vale_mov ) = FALSE THEN
				 ib_update_check = FALSE
				 RETURN											 					  
			 END IF

//			 //GRABA REFERENCIA
//ESTO FUE DESACTIVADO LBRACO
//			 IF ls_tipo_doc = ls_doc_fac THEN //FACTURA X GUIA
//				 wf_insert_ref_cc(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
//				 					   ls_cod_origen   ,ls_doc_gr  ,ls_nro_guia )
//										 
//										 
//			 ELSE //BOLETA X ORDEN DE VENTA
//				wf_insert_refer_cc_ov(ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,&
//				 					       ls_cod_origen   ,ls_doc_ov  ,ls_nro_ov )
//				
//			 END IF	
// LBRACO
		   END IF					

			//actualizo detalle
			dw_detail.object.nro_guia    [ll_inicio_det] = ls_nro_guia
			dw_detail.object.nro_vale    [ll_inicio_det] = ls_nro_vale_mov
			dw_detail.object.tipo_doc_cc [ll_inicio_det] = ls_tipo_doc
			dw_detail.object.nro_doc_cc  [ll_inicio_det] = ls_nro_doc
			dw_detail.object.nro_ov		  [ll_inicio_det] = ls_nro_ov
			
		   //acumulador
			ldc_total_lin = dw_detail.object.tot_lin [ll_inicio_det]
 	 
			if Isnull(ldc_total_lin) then ldc_total_lin = 0.00
	 
			//TOTAL DE ORDEN DE VENTA
	 		ldc_total_ov = ldc_total_ov + ldc_total_lin
			 
			//actualiza orden de venta
			if wf_update_ov(ls_nro_ov,ldc_total_ov) = false then
			 	ib_update_check = FALSE
				RETURN											 					  
			end if

	 next
	 		
next

//Desfiltrar
dw_detail.SetFilter('')
dw_detail.Filter()

if dw_detail.RowCount() > 0 then ldc_total_fin_d=dw_detail.object.total_doc[1]

//ldc_total_fin_d
messagebox("",string(ldc_total_fin_d))
IF wf_genera_detraccion(ls_item_doc [1],ls_flag_detraccion,ldt_fecha_reg,ldc_porc_det,ls_nro_detrac,&
 	ls_cod_origen     ,ldc_total_fin_d ) = FALSE THEN 
	ib_update_check = FALSE
	RETURN													 
END IF

 IF wf_update_cta_cobrar(ls_tipo_doc  ,ls_nro_doc   ,ls_flag_detraccion,&
			 								 ldc_porc_det ,ls_nro_detrac,ldc_total_fin_d     ,&
											 ls_soles    ,ls_dolares    ,ls_cod_moneda     ,&
											 ldc_tasa_cambio ) = FALSE THEN
				 ib_update_check = FALSE
				 RETURN													 
			 END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String  ls_msj_err

dw_master.AcceptText()
dw_detail.AcceptText()
ids_cntas_cobrar_cab.AcceptText()
ids_cntas_cobrar_det.AcceptText()
ids_impuesto_det.AcceptText()
ids_data_ref.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN

	Rollback ;
		
	//BORRA DATA DE DWS.
	ids_cntas_cobrar_cab.Reset()
	ids_cntas_cobrar_det.Reset()
	ids_impuesto_det.Reset()	
	ids_data_glosa.Reset()
	ids_data_ref.Reset()
	//====================
	//Desfiltrar
	dw_detail.SetFilter('')
	dw_detail.Filter()
	
	RETURN
END IF	

//actualizo dws...
IF ids_cntas_cobrar_cab.update() = -1 THEN
	lbo_ok = FALSE	
	ls_msj_err = '	Error al Grabar Cabecera de Cuentas x Cobrar'

END IF

IF lbo_ok  THEN
	IF ids_cntas_cobrar_det.update() = -1 THEN
		lbo_ok = FALSE	
		ls_msj_err = '	Error al Grabar Detalle de Cuentas x Cobrar'
	END IF
END IF

IF lbo_ok THEN
	IF ids_impuesto_det.update() = -1 THEN
		lbo_ok = FALSE	
		ls_msj_err = '	Error al Grabar Detalle de Impuesto'
	END IF
END IF	

IF lbo_ok THEN
	IF ids_data_ref.update() = -1 THEN
		lbo_ok = FALSE	
		ls_msj_err = '	Error al Grabar Referencia'
	END IF
END IF

IF lbo_ok THEN
	//insercion de tabla simplificada
	if wf_insert_fact_simple() = false then 
		lbo_ok = FALSE
	end if	
END IF

IF lbo_ok THEN

	COMMIT ;

	is_accion = 'fileopen'
	rb_1.enabled = false
	rb_2.enabled = false
	
ELSE
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF
end event

event ue_delete;//OVERRIDE
if is_accion = 'fileopen' OR idw_1 = dw_master then return

Long  ll_row


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
	
end event

event ue_print;call super::ue_print;String ls_tipo_doc,ls_nro_doc
Long   ll_inicio

IF is_accion = 'fileopen' then
	IF rb_1.checked THEN //FACTURA
		
		IF gs_empresa = 'FISHOLG' THEN
			dw_report_fact.dataobject = 'd_rpt_fact_cobrar_fisholg_ff'
			dw_report_fact.Object.DataWindow.Print.Paper.Size = 256 
			dw_report_fact.Object.DataWindow.Print.CustomPage.Width = 216
			dw_report_fact.Object.DataWindow.Print.CustomPage.Length = 161
			
		elseIF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
			
			dw_report_fact.dataobject = 'd_rpt_fact_cobrar_canagrande_ff'
			dw_report_fact.Object.DataWindow.Print.Paper.Size = 256 
			dw_report_fact.Object.DataWindow.Print.CustomPage.Width = 250
			dw_report_fact.Object.DataWindow.Print.CustomPage.Length = 150
			
		else
			dw_report_fact.dataobject = 'd_rpt_fact_cobrar_ff'
		end if

		dw_report_fact.Settransobject(sqlca)
		
		OpenWithParm(w_print_opt, dw_report_fact)
	
		If Message.DoubleParm = -1 Then Return
	
	//EDITADO LBRACO
		ll_inicio=1
//		For ll_inicio = 1 to dw_detail.Rowcount()
			
			 ls_tipo_doc = dw_detail.object.tipo_doc_cc [ll_inicio]
			 ls_nro_doc  = dw_detail.object.nro_doc_cc  [ll_inicio]

		 	DECLARE usp_fin_tt_ctas_x_cobrar PROCEDURE FOR 
			 	usp_fin_tt_ctas_x_cobrar(:ls_tipo_doc,:ls_nro_doc);
			 EXECUTE usp_fin_tt_ctas_x_cobrar ;
			 
			 dw_boleta.Settransobject(sqlca)

			 dw_report_fact.retrieve(ls_tipo_doc,ls_nro_doc)
			 //RECORRER DETALLE
			 dw_report_fact.Print(True)	
			 
			 CLOSE usp_fin_tt_ctas_x_cobrar;
			
//		Next
		
	ELSE //BOLETA
		
		IF gs_empresa = 'CANAGRANDE' or gs_empresa = "PACESERG" THEN
			
			dw_boleta.dataobject = 'd_rpt_bol_cobrar_canagrande_ff'
			dw_boleta.Object.DataWindow.Print.Paper.Size = 256 
			dw_boleta.Object.DataWindow.Print.CustomPage.Width = 250
			dw_boleta.Object.DataWindow.Print.CustomPage.Length = 150
			
		else
			dw_boleta.dataobject = 'd_rpt_bol_cobrar_fsimple_ff'
		end if
	
		
		OpenWithParm(w_print_opt, dw_boleta)
	
		If Message.DoubleParm = -1 Then Return
		
		ll_inicio = 1
//		For ll_inicio = 1 to dw_detail.Rowcount()
			 //RECORRER DETALLE			
			 ls_tipo_doc = dw_detail.object.tipo_doc_cc [ll_inicio]
			 ls_nro_doc  = dw_detail.object.nro_doc_cc  [ll_inicio]			
			 
			 DECLARE usp_fin_tt_bol_x_cobrar PROCEDURE FOR 
			 	usp_fin_tt_ctas_x_cobrar(:ls_tipo_doc,:ls_nro_doc);
			 EXECUTE usp_fin_tt_bol_x_cobrar ;
			 
			 dw_boleta.Settransobject(sqlca)

			 dw_boleta.retrieve(ls_tipo_doc,ls_nro_doc)

			 dw_boleta.Print(True)	
			 
			 CLOSE usp_fin_tt_bol_x_cobrar;
			
//		Next	
		
		
	END IF	
	
END IF

end event

event closequery;call super::closequery;destroy ids_cntas_cobrar_cab
destroy ids_cntas_cobrar_det
destroy ids_data_glosa
destroy ids_data_ref
destroy ids_impuesto_det
destroy ids_matriz_cntbl_det

if is_salir = 'S' then
	close (this)
end if
end event

type cbx_cop_det from checkbox within w_ve311_facturacion_simple
boolean visible = false
integer x = 3173
integer y = 496
integer width = 576
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Copiar Datos Detalle"
end type

type cbx_copiar from checkbox within w_ve311_facturacion_simple
boolean visible = false
integer x = 3177
integer y = 404
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Copiar Datos"
end type

type dw_report_fact from datawindow within w_ve311_facturacion_simple
boolean visible = false
integer x = 3205
integer y = 656
integer width = 686
integer height = 400
integer taborder = 20
string title = "none"
string dataobject = "d_rpt_imp_fact_simplificada_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)

end event

type rb_2 from radiobutton within w_ve311_facturacion_simple
integer x = 3173
integer y = 144
integer width = 480
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Boleta "
end type

type rb_1 from radiobutton within w_ve311_facturacion_simple
integer x = 3173
integer y = 44
integer width = 480
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Factura"
boolean checked = true
end type

type dw_detail from u_dw_abc within w_ve311_facturacion_simple
event ue_busqueda ( long al_row_fila )
integer y = 1080
integer width = 4110
integer height = 1084
integer taborder = 20
string dataobject = "d_abc_fact_simplificada_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_busqueda(long al_row_fila);String ls_expresion
Long   ll_found

ls_expresion = 'fila = '+Trim(String(al_row_fila))
ll_found = this.find(ls_expresion,1,this.rowcount())
				
if ll_found > 0 then
	this.setrow(ll_found)
	this.setfocus()
	this.setcolumn('cod_art')
end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_detail

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event itemchanged;call super::itemchanged;String ls_rec_data  ,ls_confin ,ls_matriz_cntbl ,ls_null ,ls_impuesto ,ls_cnta_prsp ,&
		 ls_cod_clase ,ls_rubro
Long   ll_count,ll_row_fila
Decimal {2} ldc_tasa_impuesto,ldc_importe
Decimal {6} ldc_precio, ldc_precio_vta
Decimal		ldc_cant_proyect

SetNull(ls_null)

dw_master.Accepttext()
Accepttext()

choose case dwo.name
		 case	'prov_transp'
				select p.nom_proveedor into :ls_rec_data
				  from proveedor p
				 where (p.proveedor   = :data ) and
				       (p.flag_estado = '1'   ) ;
				
				
		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
				     Messagebox('Aviso','Codigo de Relacion no Existe')
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
	  			   This.Object.prov_transp [row] = ls_null

			      RETURN 1
			  end if
			


		 case	'item_doc'
				ll_row_fila = this.object.fila [row]

				this.setsort('Trim(String(item_doc)) , Trim(String(fila)) ')
				this.sort()
		 		this.GroupCalc()
				
				
				post event ue_busqueda(ll_row_fila)
				
		 case 'cant_proyect'
				ls_impuesto = dw_master.object.tipo_impuesto [1]
				ldc_importe	= This.object.total              [row]
				
				select tasa_impuesto into :ldc_tasa_impuesto from impuestos_tipo where (tipo_impuesto = :ls_impuesto) ;
				
				IF Not(Isnull(ldc_importe) or ldc_importe = 0) THEN
					This.object.importe_igv [row] = round((ldc_importe * ldc_tasa_impuesto) / 100,2)
				END IF
				
		 case 'precio_venta'
				ldc_precio_vta 	= Dec(this.object.precio_venta [row])
				ldc_cant_proyect 	= Dec(this.object.cant_proyect [row])
				
				//Obtengo el impuesto
				ls_impuesto = dw_master.object.tipo_impuesto [1]
				select tasa_impuesto 
					into :ldc_tasa_impuesto 
				from impuestos_tipo 
				where (tipo_impuesto = :ls_impuesto) ;
				
				ldc_precio = ldc_precio_vta / (1 + ldc_tasa_impuesto / 100)
				
				this.object.precio_unit 		[row] = ldc_precio
				this.object.precio_unit_exp 	[row] = ldc_precio
				
				ldc_importe	= ldc_precio * ldc_cant_proyect
				IF Not(Isnull(ldc_importe) or ldc_importe = 0) THEN
					This.object.importe_igv [row] = round((ldc_importe * ldc_tasa_impuesto) / 100,2)
				END IF			
				
		 case 'precio_unit'
				ldc_precio = this.object.precio_unit [row]
				
				this.object.precio_unit_exp [row] = ldc_precio
				
				ls_impuesto = dw_master.object.tipo_impuesto [1]
				ldc_importe	= This.object.total              [row]
				
								
				select tasa_impuesto 
					into :ldc_tasa_impuesto 
				from impuestos_tipo 
				where (tipo_impuesto = :ls_impuesto) ;
				
				IF Not(Isnull(ldc_importe) or ldc_importe = 0) THEN
					This.object.importe_igv [row] = round((ldc_importe * ldc_tasa_impuesto) / 100,2)
				END IF			
				
				this.object.precio_venta [row] = ldc_precio * (1 + ldc_tasa_impuesto / 100)
			   
			
		 case 'cod_art'
			
				select art.nom_articulo ,artv.confin ,cf.matriz_cntbl,artv.cnta_prsp_vale_sal,
						 art.cod_clase
				  into :ls_rec_data  ,:ls_confin ,:ls_matriz_cntbl,:ls_cnta_prsp,
				  		 :ls_cod_clase
				  from articulo art,articulo_venta artv ,concepto_financiero cf
				 where (art.cod_art = artv.cod_art ) and 
				 		 (artv.confin = cf.confin	  ) and
				 		 (art.cod_art = :data        ) ;
				 	
				
				
				
		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
				     Messagebox('Aviso','Codigo de Articulo no Existe')
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
					This.object.cod_art      [row] = ls_null
					This.Object.nom_articulo [row] = ls_null
					This.Object.matriz_cntbl [row] = ls_null
					This.Object.confin       [row] = ls_null
					This.Object.cnta_prsp    [row] = ls_null
			      RETURN 1
					
			  end if
			  
			  

																					 
			 /*Recupero Descripción del Articulo*/
			 SELECT ast.factura_rubro INTO :ls_rubro
				FROM articulo ar,articulo_sub_categ ast
			  WHERE (ar.sub_cat_art = ast.cod_sub_cat ) and
				 	  (ar.cod_art 	   = :data			   ) ;																					 
																					 
			  /**/							  

			  
			  
			  This.Object.nom_articulo [row] = ls_rec_data
			  This.Object.matriz_cntbl [row] = ls_matriz_cntbl
			  This.Object.confin       [row] = ls_confin
			  This.Object.cencos       [row] = is_cencos_vsal
			  This.Object.cnta_prsp    [row] = ls_cnta_prsp
			  This.Object.rubro		   [row] = ls_rubro
			  
				
				
		 case 'cencos'
				select Count(*) into :ll_count
				  from centros_costo 
				 where (cencos      = :data ) and
				 		 (flag_estado = '1'   ) ;
				
				if ll_count = 0 then
					This.Object.cencos [row] = ls_null
					Messagebox('Aviso','Centro de Costo No Existe Verifique !')
					Return 1 
				end if
				
		 case 'cnta_prsp'
			
				select Count(*) into :ll_count
				  from presupuesto_cuenta
				 where (cnta_prsp = :data ) ;

				if ll_count = 0 then
					This.Object.cnta_prsp [row] = ls_null
					Messagebox('Aviso','Cuenta Presupuestal No Existe Verifique !')
					Return 1 
				end if
				
		case 'confin'
			  select matriz_cntbl into :ls_rec_data
			    from concepto_financiero 
				where (confin      = :data ) and
						(flag_estado = '1'   ) ;
						
		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
				     Messagebox('Aviso','Concepto financiero no Existe')
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
					This.object.confin       [row] = ls_null
					This.Object.matriz_cntbl [row] = ls_null

			      RETURN 1
			  end if
			  
  			  This.Object.matriz_cntbl [row] = ls_rec_data
						
end choose

end event

event ue_insert_pre;call super::ue_insert_pre;String  ls_tipo_doc,ls_doc_fac,ls_doc_bvc
Long    ll_row
Integer li_item

select doc_fact_cobrar,doc_bol_cobrar
  into :ls_doc_fac,:ls_doc_bvc
  from finparam
 where (reckey = '1') ;
 
// This.object.item_doc[al_row]=This.getrow()
 
if rb_1.checked then //factura por cobrar
	if Isnull(ls_doc_fac) or trim(ls_doc_fac) = '' then
		Messagebox('Aviso','Debe Ingresar en Tabla Finparam Campo doc_fact_cobrar')
	else
		ls_tipo_doc = ls_doc_fac
	end if
	
elseif rb_2.checked then //boleta por cobrar
	if Isnull(ls_doc_bvc) or trim(ls_doc_bvc) = '' then
		Messagebox('Aviso','Debe Ingresar en Tabla Finparam Campo doc_bol_cobrar')	
	else
		ls_tipo_doc = ls_doc_bvc
	end if
end if

This.object.tipo_doc_cc [al_row] = ls_tipo_doc

//numerador de fila
ll_row = This.RowCount()
IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,"fila")
END IF

//copiar datos de registro anterior...a...registro nuevo
if ll_row > 1 then
	This.object.prov_transp       [ll_row] = This.object.prov_transp       [ll_row - 1]
	This.object.nom_chofer        [ll_row] = This.object.nom_chofer        [ll_row - 1]
	This.object.nro_brevete       [ll_row] = This.object.nro_brevete       [ll_row - 1]
	This.object.nro_placa         [ll_row] = This.object.nro_placa         [ll_row - 1]
	This.object.nro_placa_carreta [ll_row] = This.object.nro_placa_carreta [ll_row - 1]
	This.object.marca_vehiculo 	[ll_row] = This.object.marca_vehiculo 	  [ll_row - 1]
end if

if cbx_cop_det.checked then //datos adicionales
	if ll_row > 1 then
		This.object.cod_art         [ll_row] = This.object.cod_art         [ll_row - 1]
		This.object.nom_articulo	 [ll_row] = This.object.nom_articulo    [ll_row - 1]	
		This.object.cant_proyect    [ll_row] = This.object.cant_proyect    [ll_row - 1]
		This.object.precio_unit	    [ll_row] = This.object.precio_unit     [ll_row - 1]
		This.object.precio_unit_exp [ll_row] = This.object.precio_unit_exp [ll_row - 1]
		This.object.importe_igv 	 [ll_row] = This.object.importe_igv 	 [ll_row - 1]
		// Datos que se llenan en automatico cuando el articulo es ingresado
		This.object.cencos 	 	    [ll_row] = This.object.cencos	   	 [ll_row - 1]
		This.object.cnta_prsp 	    [ll_row] = This.object.cnta_prsp 	    [ll_row - 1]
		This.object.confin	 	    [ll_row] = This.object.confin 	    	 [ll_row - 1]
		This.object.rubro		 	    [ll_row] = This.object.rubro	  	    	 [ll_row - 1]
		This.object.matriz_cntbl    [ll_row] = This.object.matriz_cntbl  	 [ll_row - 1]
		
	end if
end if
   
This.SetItem(al_row, "fila", li_item + 1)
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot ,ls_cod_relacion,ls_estado,ls_distrito,ls_direccion,&
			  ls_rubro
str_seleccionar lstr_seleccionar

Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'prov_transp'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
								   					 +'PROVEEDOR.EMAIL			AS EMAIL ,'&
														 +'PROVEEDOR.RUC			   AS R_U_C '&
									   				 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'prov_transp',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
		 CASE 'cod_art'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_FIN_ART_X_VENTA.COD_ART            AS CODIGO_ARTICULO      ,'&
														 +'VW_FIN_ART_X_VENTA.NOM_ARTICULO       AS DESCRIPCION_ARTICULO ,'&
								      				 +'VW_FIN_ART_X_VENTA.CONFIN             AS CONCEPTO_FINANCIERO  ,'&
								   					 +'VW_FIN_ART_X_VENTA.MATRIZ_CNTBL       AS MATRIZ_CONTABLE      ,'&
														 +'VW_FIN_ART_X_VENTA.CNTA_PRSP_VALE_SAL AS CUENTA_PRESUPUESTAL  ,'&
														 +'VW_FIN_ART_X_VENTA.COD_CLASE			  AS CLASE_ART				   '&
									   				 +'FROM VW_FIN_ART_X_VENTA '


				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_art'     ,lstr_seleccionar.param1[1])	
					Setitem(row,'nom_articulo',lstr_seleccionar.param2[1])
					Setitem(row,'confin'      ,lstr_seleccionar.param3[1])
					Setitem(row,'matriz_cntbl',lstr_seleccionar.param4[1])
					Setitem(row,'cencos'		  ,is_cencos_vsal)
					Setitem(row,'cnta_prsp'	  ,lstr_seleccionar.param5[1])
					
					
					/*BUSCO RUBRO*/
					SELECT ast.factura_rubro INTO :ls_rubro
					  FROM articulo ar,articulo_sub_categ ast
					 WHERE (ar.sub_cat_art = ast.cod_sub_cat             ) and
							 (ar.cod_art 	  = :lstr_seleccionar.param1[1] ) ;																							
					
					Setitem(row,'rubro'	  ,ls_rubro)
					
					ii_update = 1
				END IF

		 CASE 'cencos'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS      AS CODIGO_COSTO      ,'&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION_COSTO  '&
									   				 +'FROM CENTROS_COSTO '&
														 +'WHERE CENTROS_COSTO.FLAG_ESTADO = '+"'"+'1'+"'"


				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos'     ,lstr_seleccionar.param1[1])	
					ii_update = 1
				END IF

		
		
		 CASE 'cnta_prsp'					
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP   AS CUENTA_PRESUPUESTAL ,'&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS NOMBRE_CUENTA        '&
									   				 +'FROM PRESUPUESTO_CUENTA '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])	
					ii_update = 1
				END IF


		 CASE 'confin'					
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN       AS CUENTA_PRESUPUESTAL ,'&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION  AS NOMBRE_CUENTA       ,'&
														 +'CONCEPTO_FINANCIERO.MATRIZ_CNTBL AS MATRIZ					'&
									   				 +'FROM CONCEPTO_FINANCIERO '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'confin'      ,lstr_seleccionar.param1[1])
					Setitem(row,'matriz_cntbl',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

				
END CHOOSE



end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot ,ls_cod_relacion,ls_estado,ls_distrito,ls_direccion,&
			  ls_rubro
str_parametros lstr_rep

Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'b_print_ov'
			if this.rowcount() = 0 then return

			lstr_rep.dw1 = 'd_rpt_orden_venta'
			lstr_rep.titulo = 'Previo de Orden de Venta'
			lstr_rep.string2 = this.object.nro_ov[row]
			lstr_rep.string1 = mid(lstr_rep.string2,1,2)
			

			OpenSheetWithParm(w_ve300_orden_venta_frm, lstr_rep, w_main, 0, Layered!)
END CHOOSE



end event

type dw_master from u_dw_abc within w_ve311_facturacion_simple
integer width = 3049
integer height = 1060
string dataobject = "d_abc_fact_simplificada_cab_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Datetime ldt_fecha_act
String   ls_soles,ls_igv,ls_pago, ls_nom_usuario, ls_direccion

ldt_fecha_act = f_Fecha_Actual()

This.Object.fecha_registro 	[al_row] = ldt_fecha_act
This.Object.fec_venta 			[al_row] = date(ldt_fecha_act)
This.Object.cod_origen			[al_row] = gs_origen
This.Object.cod_usr				[al_row] = gs_user
This.Object.tasa_cambio			[al_row] = gnvo_app.of_tasa_cambio_vta(Date(ldt_fecha_act))

This.Object.cod_moneda			[al_row] = is_cod_moneda
This.Object.desc_moneda			[al_row] = is_desc_moneda
This.Object.forma_pago			[al_row] = is_forma_pago
This.Object.tipo_impuesto		[al_row] = is_tipo_impuesto
This.Object.forma_embarque		[al_row] = is_forma_embarque
This.Object.motivo_traslado	[al_row] = is_motivo_traslado
This.Object.desc_motivo			[al_row] = is_Desc_motivo
This.Object.almacen				[al_row] = is_almacen
This.Object.desc_almacen		[al_row] = is_desc_almacen
This.Object.punto_venta			[al_row] = is_punto_venta
This.Object.desc_punto_venta	[al_row] = is_desc_pto_vta

select nombre
	into :ls_nom_usuario	
	from usuario
where cod_usr = :gs_user;
this.object.vendedor				[al_Row] = gs_user
this.object.nom_vendedor		[al_Row] = ls_nom_usuario


select direccion
	into :ls_direccion
from almacen
where almacen = :is_almacen;
this.object.punto_partida		[al_Row] = ls_direccion

//en el caso de boletas
if rb_2.checked = true then
	select l.cod_soles,l.cod_igv into :ls_soles,:ls_igv from logparam l where l.reckey = '1' ;

	select f.pago_contado into :ls_pago from finparam f where f.reckey = '1' ;

	This.object.cod_moneda    [al_row] = ls_soles
	This.object.forma_pago    [al_row] = ls_pago
	This.object.tipo_impuesto [al_row] = ls_igv
	
end if	






end event

event itemchanged;call super::itemchanged;Long    ll_count,ll_nro_serie_doc,ll_null
String  ls_desc_data     ,ls_null         ,ls_cod_relacion ,ls_dir_dep_estado , &
        ls_dir_distrito	,ls_dir_direccion ,ls_tipo_doc	  , ls_nom_vendedor
Integer li_num_dir

Accepttext()

SetNull(ls_null)
SetNull(ll_null)

choose case dwo.name
		 case 'nro_serie_doc'
				ll_nro_serie_doc = Long(data) 
				
				if rb_1.checked then
					ls_tipo_doc = is_doc_fac
				elseif rb_2.checked then
					ls_tipo_doc = is_doc_bvc
				end if	
				
				
				select count(*) into :ll_count 
				  from doc_tipo_usuario 
				 where (cod_usr   = :gs_user          ) and
					    (tipo_doc  = :ls_tipo_doc      ) and
						 (nro_serie	= :ll_nro_serie_doc ) ;
						 
			  if ll_count = 0 then
				  Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
				  this.object.nro_serie_doc [row] = ll_null
				  Return 1
			  end if 
				
		 case 'nro_serie_guia'
				ll_nro_serie_doc = Long(data) 
				
				select count(*) into :ll_count 
				  from doc_tipo_usuario 
				 where (cod_usr   = :gs_user          ) and
					    (tipo_doc  = :is_doc_gr        ) and
						 (nro_serie	= :ll_nro_serie_doc ) ;
						 
			   if ll_count = 0 then
				   Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
				   this.object.nro_serie_guia [row] = ll_null
				   Return 1
			   end if 
			  
		
		 case 'cod_relacion'

				select p.nom_proveedor into :ls_desc_data
				  from proveedor p
				 where (p.proveedor   = :data ) and
				       (p.flag_estado = '1'   ) ;
				
				
		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
				     Messagebox('Aviso','Codigo de Relacion no Existe')
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
					This.object.cod_relacion   [row] = ls_null
					This.Object.desc_crelacion [row] = ls_null
			      RETURN 1
			  end if
			

  			  This.Object.desc_crelacion  [row] = ls_desc_data
		     This.Object.comp_final 		[row] = data
			  This.Object.desc_comp_final [row] = ls_desc_data
		 
		 case 'comp_final'

				select p.nom_proveedor into :ls_desc_data
				  from proveedor p
				 where (p.proveedor   = :data ) and
				       (p.flag_estado = '1'   ) ;
				
				
		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
				     Messagebox('Aviso','Codigo de Relacion no Existe')
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
					This.object.comp_final      [row] = ls_null
					This.Object.desc_comp_final [row] = ls_null
			      RETURN 1
			  end if
			

  			  This.Object.desc_comp_final [row] = ls_desc_data
						  
		 case 'item_direccion'
			
				ls_cod_relacion = dw_master.object.cod_relacion [row]		
				
				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
					Return 1
				END IF

				/**/
				li_num_dir = Integer(data)
				/**/
				

				SELECT Nvl(dir_dep_estado,' ') ,Nvl(dir_distrito,' ')   ,
					 	 Nvl(dir_direccion,' ')  
				  INTO :ls_dir_dep_estado ,:ls_dir_distrito	  ,	
						 :ls_dir_direccion 		
				  FROM direcciones
				 WHERE (codigo = :ls_cod_relacion) AND
				 		 (item	= :li_num_dir     ) AND
						 (flag_uso = '1'           ) ;
						  

		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
 					  Messagebox('Aviso','Direccion No Existe , Verifique!')				
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
					Setnull(li_num_dir)
					This.Object.item_direccion [row] = li_num_dir
					This.Object.desc_direccion [row] = ls_null
			      RETURN 1
			  end if

			  This.Object.desc_direccion [row] = Trim(ls_dir_dep_estado)+' '+Trim(ls_dir_distrito)+' '+Trim(ls_dir_direccion)	 
				
		 case 'cod_moneda'
			
				select descripcion
			     into :ls_desc_data
			     from moneda
				 where (cod_moneda = :data) ;	
					
		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			      if SQLCA.SQLCode = 100 then
						Messagebox('Aviso','Moneda No Existe , Verifique!')				
			      else
				      MessageBox('Aviso', SQLCA.SQLErrText)
			      end if
				  
					This.Object.cod_moneda  [row] = ls_null
					This.Object.desc_moneda [row] = ls_null
			      RETURN 1
			   end if

			   This.Object.desc_moneda [row] = ls_desc_data
				
				
		 case 'motivo_traslado'   				
				
				select descripcion 
				  into :ls_desc_data
				  from motivo_traslado mt
				 where (mt.motivo_traslado = :data) ;
					 
		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			      if SQLCA.SQLCode = 100 then
						Messagebox('Aviso','Motivo de Traslado No Existe , Verifique!')				
			      else
				      MessageBox('Aviso', SQLCA.SQLErrText)
			      end if
				  
					This.Object.motivo_traslado [row] = ls_null
					This.Object.desc_motivo     [row] = ls_null
			      RETURN 1
			   end if

				This.Object.desc_motivo     [row] = ls_desc_data 
				
				
				
				
		 case	'almacen'	
				
				select desc_almacen 
			     into :ls_desc_data
		        from almacen
   	       where (almacen     = :data      ) and
				       (flag_estado = '1'        ) and
						 (cod_origen  = :gs_origen ) ; 
		  
		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
			     if SQLCA.SQLCode = 100 then
				     Messagebox('Aviso','Codigo de almacen no existe, ' &
					             + 'no esta activo o no le corresponde a su origen ')
			     else
				     MessageBox('Aviso', SQLCA.SQLErrText)
			     end if
				  
			     this.Object.almacen	 	[row] = ls_null
			     this.object.desc_almacen [row] = ls_null
			     RETURN 1
			  end if
			
		     this.object.desc_almacen [row] = ls_desc_data
				

		CASE 'vendedor'
			
				select nvl(u.nombre,'')
				  into :ls_nom_vendedor
				  from vendedor v, usuario u
				 where v.vendedor = u.cod_usr
				   and v.vendedor = :data;
				
				if ls_nom_vendedor = '' then
					messagebox('Aviso','Codigo de Vendedor no existe, Verifique!')
					setnull(ls_nom_vendedor)
					this.object.vendedor[row] = ls_nom_Vendedor
					this.object.nom_vendedor[row] = ls_nom_vendedor
					return 1
				end if
				
				this.object.nom_vendedor[row] = ls_nom_vendedor

end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name    ,ls_prot ,ls_cod_relacion,ls_estado,ls_distrito,ls_direccion,&
			  ls_tipo_doc
str_seleccionar lstr_seleccionar
str_parametros sl_param

Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'nro_serie_doc'
			   
				if rb_1.checked then
					ls_tipo_doc = is_doc_fac
				elseif rb_2.checked then
					ls_tipo_doc = is_doc_bvc
				end if
			 
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC AS DOCUMENTO ,'&
								      				 +'DOC_TIPO_USUARIO.NRO_SERIE AS SERIE '&
									   				 +'FROM DOC_TIPO_USUARIO '&
														 +'WHERE DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user     +"' AND "&
														 		 +'DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+ls_tipo_doc +"'"

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'nro_serie_doc',lstr_seleccionar.paramdc2[1])
					ii_update = 1
				END IF																  
																  
			
		 CASE 'nro_serie_guia'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC AS DOCUMENTO ,'&
								      				 +'DOC_TIPO_USUARIO.NRO_SERIE AS SERIE '&
									   				 +'FROM DOC_TIPO_USUARIO '&
														 +'WHERE DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user     +"' AND "&
														 		 +'DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+is_doc_gr +"'"

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'nro_serie_guia',lstr_seleccionar.paramdc2[1])
					ii_update = 1
				END IF	
				
		 CASE 'cod_relacion'

				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO_PROVEEDOR, '&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES, '&
								   					 +'PROVEEDOR.EMAIL AS EMAIL, '&
														 +'PROVEEDOR.RUC AS R_U_C '&
									   				 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'desc_crelacion',lstr_seleccionar.param2[1])
					
					Setitem(row,'comp_final',lstr_seleccionar.param1[1])
					Setitem(row,'desc_comp_final',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		
		 CASE 'comp_final'

				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
								   					 +'PROVEEDOR.EMAIL			AS EMAIL ,'&
														 +'PROVEEDOR.RUC			   AS R_U_C '&
									   				 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'comp_final',lstr_seleccionar.param1[1])
					Setitem(row,'desc_comp_final',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		
		 CASE 'item_direccion'					
			
				ls_cod_relacion = dw_master.object.cod_relacion [row]		
				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
					Return 1
				END IF
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DIRECCIONES.ITEM             AS ITEM, '&        
						 								 +'DIRECCIONES.DIR_PAIS         AS PAIS, '&     
						 								 +'DIRECCIONES.DIR_DEP_ESTADO   AS DEPARTAMENTO, '&
						 								 +'DIRECCIONES.DIR_DISTRITO     AS DISTRITO , '&
						 								 +'DIRECCIONES.DIR_URBANIZACION AS URBANIZACION, '&
						 								 +'DIRECCIONES.DIR_DIRECCION    AS DIRECCION, '&
						 							    +'DIRECCIONES.DIR_MNZ          AS MANZANA, '&
						 								 +'DIRECCIONES.DIR_LOTE         AS LOTE, '&
						 								 +'DIRECCIONES.DIR_NUMERO       AS NUMERO, '&
						 								 +'DIRECCIONES.DESCRIPCION      AS DESCRIPCION '&
				  		 								 +'FROM DIRECCIONES '&
				 		 								 +'WHERE DIRECCIONES.CODIGO = '+"'"+ls_cod_relacion+"' AND "&
														 +'	   DIRECCIONES.FLAG_USO = '+"'"+'1'+"'"								
															
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					This.Object.item_direccion [row] = Integer(lstr_seleccionar.paramdc1[1])
					ls_estado	 = lstr_seleccionar.param3[1]
					ls_distrito  = lstr_seleccionar.param4[1]					
					ls_direccion = lstr_seleccionar.param6[1]

					IF Isnull(ls_estado)    THEN ls_estado 	= ''
					IF Isnull(ls_distrito)  THEN ls_distrito 	= ''					
					IF Isnull(ls_direccion) THEN ls_direccion	= ''		

					This.Object.desc_direccion [row] = ls_estado+' '+ls_distrito+' '+ls_direccion
					ii_update = 1
					
				END IF
															
		 CASE 'cod_moneda'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA  AS CODIGO_MONEDA ,'&
								      				 +'MONEDA.DESCRIPCION AS DESCRIPCION_MON '&
									   				 +'FROM MONEDA '


				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_moneda',lstr_seleccionar.param1[1])
					Setitem(row,'desc_moneda',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

		 CASE 'motivo_traslado'		 						  
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MOTIVO_TRASLADO.MOTIVO_TRASLADO AS CODIGO ,'&
												 		 +'MOTIVO_TRASLADO.DESCRIPCION	  AS DESCRIP_MOTIVO_TRAS '&
														 +'FROM MOTIVO_TRASLADO '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'motivo_traslado',lstr_seleccionar.param1[1])
					Setitem(row,'desc_motivo',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'punto_venta'		 						  
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT punto_venta AS CODIGO ,'&
												 		 +'desc_pto_vta AS DESCRIPcion '&
														 +'FROM puntos_venta ' &
														 + "where flag_estado = '1'"

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'punto_venta',lstr_seleccionar.param1[1])
					Setitem(row,'desc_punto_venta',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

		case	'almacen'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ALMACEN.ALMACEN      AS CODIGO ,'&
														 +'ALMACEN.DESC_ALMACEN AS DESCRIPCION ,'&
														 +'ALMACEN.Direccion	AS direccion '&
														 +'FROM ALMACEN '&
														 +'WHERE ALMACEN.FLAG_ESTADO = '+"'"+'1'+"'"+' AND '&
				 		                               +'ALMACEN.COD_ORIGEN  = '+"'"+gs_origen+"'"
														 
		      OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'almacen',lstr_seleccionar.param1[1])
					Setitem(row,'desc_almacen',lstr_seleccionar.param2[1])
					Setitem(row,'punto_partida',lstr_seleccionar.param3[1])
					ii_update = 1
				END IF
				
		CASE 'vendedor'
			
				sl_param.dw1 = "d_lista_vendedor"
				sl_param.titulo = "Vendedores"
				sl_param.field_ret_i[1] = 1
				sl_param.field_ret_i[2] = 2
				sl_param.tipo = ''
				
				OpenWithParm( w_lista, sl_param)		
				
				sl_param = MESSAGE.POWEROBJECTPARM
				
				if sl_param.titulo <> 'n' then	
					Setitem(row,'vendedor',sl_param.field_ret[1])
					Setitem(row,'nom_vendedor',sl_param.field_ret[2])
					ii_update = 1
				END IF

END CHOOSE

end event

type dw_boleta from datawindow within w_ve311_facturacion_simple
boolean visible = false
integer x = 754
integer y = 1516
integer width = 686
integer height = 400
integer taborder = 30
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

