$PBExportHeader$nvo_insert_documentos.sru
forward
global type nvo_insert_documentos from nonvisualobject
end type
end forward

global type nvo_insert_documentos from nonvisualobject
end type
global nvo_insert_documentos nvo_insert_documentos

forward prototypes
public function boolean uf_insert_cnta_x_cobrar (string as_tipo_doc, string as_nro_doc, string as_cod_relacion, string as_flag_estado, date adt_fecha_registro, date adt_fecha_documento, date adt_fecha_vencimiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_forma_pago, string as_origen, string as_obs, decimal adc_importe_doc, decimal adc_saldo_sol, decimal adc_saldo_dol, string as_flag_ctrl_reg, string as_flag_caja_bancos, string as_flag_provisionado)
public function boolean uf_genera_nro_doc_tipo (string as_tipo_doc, ref string as_nro_doc, string as_origen)
public function boolean uf_insert_cnta_x_cobrar_det (string as_tipo_doc, string as_nro_doc, long al_item, string as_flag_estado, string as_descripcion, decimal adc_cantidad, decimal adc_precio)
public function boolean uf_insert_cnta_x_pagar (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flag_estado, date adt_fregistro, date adt_femision, date adt_fec_venc, string as_forma_pago, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_origen, string as_descripcion, string as_flag_prov, decimal adc_importe_doc, decimal adc_saldo_sol, decimal adc_saldo_dol, string as_flag_c_reg, string as_flag_cbancos)
public function boolean uf_insert_cnta_x_pagar_det (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, long al_item, string as_descripcion, decimal adc_cantidad, decimal adc_importe, string as_cencos, string as_cnta_prsp)
end prototypes

public function boolean uf_insert_cnta_x_cobrar (string as_tipo_doc, string as_nro_doc, string as_cod_relacion, string as_flag_estado, date adt_fecha_registro, date adt_fecha_documento, date adt_fecha_vencimiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_forma_pago, string as_origen, string as_obs, decimal adc_importe_doc, decimal adc_saldo_sol, decimal adc_saldo_dol, string as_flag_ctrl_reg, string as_flag_caja_bancos, string as_flag_provisionado);Boolean lb_ret = true
String  ls_msj_err

Insert Into cntas_cobrar 
(tipo_doc          ,nro_doc         ,cod_relacion    ,
 flag_estado       ,fecha_registro  ,fecha_documento ,
 fecha_vencimiento ,cod_moneda      ,tasa_cambio     ,
 cod_usr			    ,forma_pago	   ,origen			  ,
 observacion 	    ,importe_doc     ,saldo_sol       ,
 saldo_dol			 ,flag_control_reg,flag_caja_bancos,
 flag_provisionado )
Values
(:as_tipo_doc          ,:as_nro_doc         ,:as_cod_relacion    ,
 :as_flag_estado       ,:adt_fecha_registro ,:adt_fecha_documento,
 :adt_fecha_vencimiento,:as_cod_moneda		  ,:adc_tasa_cambio    ,
 :as_cod_usr			  ,:as_forma_pago		  ,:as_origen			  ,
 :as_obs					  ,:adc_importe_doc	  ,:adc_saldo_sol		  ,
 :adc_saldo_dol		  ,:as_flag_ctrl_reg	  ,:as_flag_caja_bancos,
 :as_flag_provisionado) ;
 
IF SQLCA.SQLCode = -1 THEN
	ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	Rollback ;
   MessageBox('SQL error (Fallo Insert en Cuentas Cobrar)',ls_msj_err)
END IF 
 
 
 Return lb_ret
end function

public function boolean uf_genera_nro_doc_tipo (string as_tipo_doc, ref string as_nro_doc, string as_origen);Long    ll_nro_ce = 0
String  ls_lock_table,ls_msj_err
Boolean lb_ret = TRUE



ls_lock_table = 'LOCK TABLE NUM_DOC_TIPO IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;


SELECT ultimo_numero
  INTO :ll_nro_ce
  FROM num_doc_tipo
 WHERE tipo_doc = :as_tipo_doc ;

  
IF Isnull(ll_nro_ce) OR ll_nro_ce = 0 THEN
	Messagebox('Aviso','Verificar Información En Tabla NUM_DOC_TIPO, Comuniquese Con Sistemas')	
	Rollback ;
	lb_ret = FALSE
	GOTO SALIDA
ELSE
	UPDATE num_doc_tipo
	   SET ultimo_numero = ultimo_numero + 1
	 WHERE tipo_doc = :as_tipo_doc ;
	 
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err =  SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error',ls_msj_err)
		lb_ret = FALSE
		GOTO SALIDA
	END IF	 
	 
END IF

as_nro_doc = as_origen+f_llena_caracteres('0',Trim(String(ll_nro_ce)),8)

SALIDA:

Return lb_ret
end function

public function boolean uf_insert_cnta_x_cobrar_det (string as_tipo_doc, string as_nro_doc, long al_item, string as_flag_estado, string as_descripcion, decimal adc_cantidad, decimal adc_precio);Boolean lb_ret = true
String  ls_msj_err
 
Insert Into cntas_cobrar_det
(tipo_doc    ,nro_doc  ,item           ,flag_estado ,
 descripcion ,cantidad ,precio_unitario )
Values
(:as_tipo_doc    ,:as_nro_doc   ,:al_item   ,:as_flag_estado,
 :as_descripcion ,:adc_cantidad ,:adc_precio) ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
   MessageBox('SQL error',ls_msj_err )
	lb_ret = FALSE
END IF


Return lb_ret
end function

public function boolean uf_insert_cnta_x_pagar (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flag_estado, date adt_fregistro, date adt_femision, date adt_fec_venc, string as_forma_pago, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_origen, string as_descripcion, string as_flag_prov, decimal adc_importe_doc, decimal adc_saldo_sol, decimal adc_saldo_dol, string as_flag_c_reg, string as_flag_cbancos);Boolean lb_ret = TRUE
String  ls_msj_err

Insert Into cntas_pagar
(cod_relacion   ,tipo_doc          ,nro_doc     ,flag_estado ,
 fecha_registro ,fecha_emision     ,vencimiento ,forma_pago  ,   
 cod_moneda     ,tasa_cambio       ,cod_usr     ,origen  	 ,
 descripcion 	 ,flag_provisionado ,importe_doc ,saldo_sol   ,        
 saldo_dol      ,flag_control_reg  ,flag_caja_bancos )
Values
(:as_cod_relacion ,:as_tipo_doc     ,:as_nro_doc      ,:as_flag_estado ,
 :adt_fregistro   ,:adt_femision    ,:adt_fec_venc    ,:as_forma_pago  ,   
 :as_cod_moneda   ,:adc_tasa_cambio ,:as_cod_usr      ,:as_origen  	  ,
 :as_descripcion 	,:as_flag_prov    ,:adc_importe_doc ,:adc_saldo_sol  ,        
 :adc_saldo_dol   ,:as_flag_c_reg   ,:as_flag_cbancos);
 

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error',ls_msj_err )
	lb_ret = false
END IF

Return lb_ret
end function

public function boolean uf_insert_cnta_x_pagar_det (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, long al_item, string as_descripcion, decimal adc_cantidad, decimal adc_importe, string as_cencos, string as_cnta_prsp);Boolean lb_ret = TRUE
String  ls_msj_err

Insert Into cntas_pagar_det
(cod_relacion ,tipo_doc    ,nro_doc  ,
 item         ,descripcion ,cantidad ,
 importe  	  ,cencos   	,cnta_prsp  )
Values
(:as_cod_relacion ,:as_tipo_doc    ,:as_nro_doc   ,
 :al_item         ,:as_descripcion ,:adc_cantidad ,
 :adc_importe  	,:as_cencos   	  ,:as_cnta_prsp ) ; 


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', SQLCA.SQLErrText)
	lb_ret = FALSE
END IF




Return lb_ret



end function

on nvo_insert_documentos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_insert_documentos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

