$PBExportHeader$w_fi333_cierra_liquidacion_og_devolucion.srw
forward
global type w_fi333_cierra_liquidacion_og_devolucion from w_abc
end type
type cb_1 from commandbutton within w_fi333_cierra_liquidacion_og_devolucion
end type
type tab_1 from tab within w_fi333_cierra_liquidacion_og_devolucion
end type
type tabpage_3 from userobject within tab_1
end type
type dw_asiento_cab_liq from u_dw_abc within tabpage_3
end type
type dw_asiento_det_liq from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_asiento_cab_liq dw_asiento_cab_liq
dw_asiento_det_liq dw_asiento_det_liq
end type
type tab_1 from tab within w_fi333_cierra_liquidacion_og_devolucion
tabpage_3 tabpage_3
end type
type dw_master from u_dw_abc within w_fi333_cierra_liquidacion_og_devolucion
end type
end forward

global type w_fi333_cierra_liquidacion_og_devolucion from w_abc
integer width = 3461
integer height = 1896
string title = "Devolución Orden de Giro (FI333)"
string menuname = "m_mantenimiento_proceso_cl"
event ue_anular ( )
event ue_update_anular ( ref boolean abo_ok )
event ue_find_exact ( )
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_fi333_cierra_liquidacion_og_devolucion w_fi333_cierra_liquidacion_og_devolucion

type variables
Datastore ids_matriz_cntbl_det,ids_data_glosa
String is_accion
n_cst_asiento_contable invo_cntbl_asiento
end variables

forward prototypes
public subroutine wf_total_asiento_cab (decimal adc_totsoldeb, decimal adc_totdoldeb, decimal adc_totsolhab, decimal adc_totdolhab, long al_row, ref datawindow adw_1)
public subroutine wf_reset_dw ()
public subroutine wf_insert_asiento_cab_ctas_x_pagar (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_descripcion, datetime adt_fecha_registro, long al_row)
public subroutine wf_insert_ctas_x_pagar (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flag_estado, datetime adt_fecha_registro, datetime adt_fecha_emision, datetime adt_fecha_vencimiento, string as_forma_pago, string as_cod_moneda, decimal adc_tasa_cambio, decimal adc_total_pagar, decimal adc_total_pagado, string as_user, string as_origen, long al_nro_libro, long al_nro_asiento, string as_descripcion, string as_cencos, string as_cnta_prsp, string as_confin, long al_ano, long al_mes, string as_item)
public subroutine wf_insert_asiento_cab_sg (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_descripcion, datetime adt_fecha_registro, long al_row)
public function boolean wf_genera_asiento_devolucion ()
public subroutine wf_genera_datos_dp ()
end prototypes

event ue_anular();String ls_variable,ls_flag_estado,ls_result,ls_mensaje
Long   ll_inicio,ll_var,ll_ano,ll_mes

SetNull(ls_variable)
SetNull(ll_var)

IF dw_master.Getrow() = 0 THEN RETURN

ll_ano = dw_master.object.ano 		[1]
ll_mes = dw_master.object.mes 		[1]



/*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	Return
END IF	

IF dw_master.ii_update = 1 OR	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1 OR & 
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1 THEN
	Messagebox('Aviso','Grabe Cambios Antes de Anular Cierre de Liquidación , Verifique !')
	Return
END IF
	

ls_flag_estado = dw_master.object.flag_estado [1]

IF ls_flag_estado <> '5' THEN RETURN


/*caebcera de sg*/
dw_master.object.flag_estado       [1] = '3'
dw_master.object.importe_liquidado [1] = 0.00
dw_master.object.cnt_origen        [1] = ls_variable
dw_master.object.ano               [1] = ll_var
dw_master.object.mes               [1] = ll_var
dw_master.object.nro_libro         [1] = ll_var
dw_master.object.nro_asiento       [1] = ll_var

FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_asiento_det_liq.Rowcount()
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.imp_movsol [ll_inicio] = 0.00
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.imp_movdol [ll_inicio] = 0.00
NEXT

tab_1.tabpage_3.dw_asiento_cab_liq.object.tot_soldeb  [1]= 0.00
tab_1.tabpage_3.dw_asiento_cab_liq.object.tot_solhab  [1]= 0.00
tab_1.tabpage_3.dw_asiento_cab_liq.object.tot_doldeb  [1]= 0.00
tab_1.tabpage_3.dw_asiento_cab_liq.object.tot_dolhab  [1]= 0.00
tab_1.tabpage_3.dw_asiento_cab_liq.object.flag_estado [1] = '0'



is_accion = 'delete'
dw_master.ii_update = 1
tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1
tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1



end event

event ue_update_anular(ref boolean abo_ok);IF	dw_master.ii_update = 1 AND abo_ok THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		abo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1 AND abo_ok THEN
	IF tab_1.tabpage_3.dw_asiento_det_liq.Update() = -1 THEN //Grabación de Detalle de Asiento
		abo_ok = FALSE
		Messagebox('Error en Grabación Detalle Asientos Confin de Liquidación','Se ha procedido al Rollback',Exclamation!)	
	END IF
END IF

IF tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1 AND abo_ok THEN
	IF tab_1.tabpage_3.dw_asiento_cab_liq.Update() = -1 THEN //Grabación de Cabecera de Pre - Asientos
		abo_ok = FALSE
		Messagebox('Error en Grabación Cabecera Asientos de Confin de Liquidacion','Se ha procedido al Rollback',Exclamation!)	
	END IF
END IF




end event

event ue_find_exact();// Asigna valores a structura 
String ls_origen,ls_nro_solicitud
str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_letras_x_cobrar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 3 //SOLICITUD GIRO
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	ls_origen		  = dw_master.object.origen        [dw_master.getrow()]
	ls_nro_solicitud = dw_master.object.nro_solicitud [dw_master.getrow()]
	
	tab_1.tabpage_3.dw_asiento_cab_liq.retrieve(ls_origen,ls_nro_solicitud)
	tab_1.tabpage_3.dw_asiento_det_liq.retrieve(ls_origen,ls_nro_solicitud)
	
	TriggerEvent('ue_modify')
	dw_master.ii_update = 0
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
	
ELSE
	dw_master.Reset()
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
	
END IF
end event

public subroutine wf_total_asiento_cab (decimal adc_totsoldeb, decimal adc_totdoldeb, decimal adc_totsolhab, decimal adc_totdolhab, long al_row, ref datawindow adw_1);adw_1.object.tot_soldeb [al_row] = adc_totsoldeb
adw_1.object.tot_doldeb [al_row] = adc_totdoldeb
adw_1.object.tot_solhab [al_row] = adc_totsolhab	
adw_1.object.tot_dolhab [al_row] = adc_totdolhab
end subroutine

public subroutine wf_reset_dw ();/*Inicializacion de Variables*/

tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0

/*Limpieza de datawindows*/
tab_1.tabpage_3.dw_asiento_cab_liq.Reset()
tab_1.tabpage_3.dw_asiento_det_liq.Reset()	


is_accion = 'fileopen'
end subroutine

public subroutine wf_insert_asiento_cab_ctas_x_pagar (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_descripcion, datetime adt_fecha_registro, long al_row);

end subroutine

public subroutine wf_insert_ctas_x_pagar (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flag_estado, datetime adt_fecha_registro, datetime adt_fecha_emision, datetime adt_fecha_vencimiento, string as_forma_pago, string as_cod_moneda, decimal adc_tasa_cambio, decimal adc_total_pagar, decimal adc_total_pagado, string as_user, string as_origen, long al_nro_libro, long al_nro_asiento, string as_descripcion, string as_cencos, string as_cnta_prsp, string as_confin, long al_ano, long al_mes, string as_item);
end subroutine

public subroutine wf_insert_asiento_cab_sg (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_descripcion, datetime adt_fecha_registro, long al_row);/*Inserta Cabecera de Asiento de Solicitud de giro*/
tab_1.tabpage_3.dw_asiento_cab_liq.object.origen          [al_row] = as_origen
tab_1.tabpage_3.dw_asiento_cab_liq.object.ano   	       [al_row] = al_ano
tab_1.tabpage_3.dw_asiento_cab_liq.object.mes	          [al_row] = al_mes
tab_1.tabpage_3.dw_asiento_cab_liq.object.nro_libro       [al_row] = al_nro_libro
tab_1.tabpage_3.dw_asiento_cab_liq.object.nro_asiento		 [al_row] = al_nro_asiento
tab_1.tabpage_3.dw_asiento_cab_liq.object.cod_moneda      [al_row] = as_cod_moneda
tab_1.tabpage_3.dw_asiento_cab_liq.object.tasa_cambio     [al_row] = adc_tasa_cambio
tab_1.tabpage_3.dw_asiento_cab_liq.object.desc_glosa      [al_row] = as_descripcion
tab_1.tabpage_3.dw_asiento_cab_liq.object.fec_registro    [al_row] = adt_fecha_registro 
tab_1.tabpage_3.dw_asiento_cab_liq.object.fecha_cntbl     [al_row] = adt_fecha_registro 
tab_1.tabpage_3.dw_asiento_cab_liq.object.cod_usr         [al_row] = gs_user
tab_1.tabpage_3.dw_asiento_cab_liq.object.flag_estado     [al_row] = '1'	


/*Activo update*/
tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1
end subroutine

public function boolean wf_genera_asiento_devolucion ();Boolean lb_ret = TRUE
Long    ll_count,ll_row,ll_row_master
String  ls_cod_rel        ,ls_tipo_doc,ls_nro_doc,ls_flag_debhab ,ls_cnta_ctbl_debe,ls_cnta_ctbl_haber,&
		  ls_moneda_det     ,ls_soles   ,ls_dolares,ls_cta_ctbl_gan,ls_cta_ctbl_per  ,ls_cnta_ctbl_dif  ,&
		  ls_flag_debhab_dif,ls_flag_debhab_dif_x_doc,ls_det_glosa
Decimal {2} ldc_impmovsol,ldc_impmovdol,ldc_saldo_sol,ldc_saldo_dol
Decimal {3} ldc_tasa_cambio
Datetime    ldt_fec_aprob

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Alguna Orden de Giro, Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF	


f_monedas(ls_soles,ls_dolares)
/*parametro de finparam*/
select cnta_ctbl_liq_debe,doc_sol_giro,cnta_ctbl_dc_ganancia,cnta_ctbl_dc_perdida into :ls_cnta_ctbl_debe,:ls_tipo_doc,:ls_cta_ctbl_gan,:ls_cta_ctbl_per  from finparam where reckey = '1' ;
/**/



/*cabecera de solicitud  de giro*/
ls_cod_rel	  = dw_master.object.cod_relacion	  [ll_row_master]	
ls_nro_doc    = dw_master.object.nro_solicitud	  [ll_row_master]	
ls_moneda_det = dw_master.object.cod_moneda  	  [ll_row_master]	
ldt_fec_aprob = dw_master.object.fecha_aprobacion [ll_row_master]

IF Isnull(ldt_fec_aprob) OR String(ldt_fec_aprob,'yyyymmdd') = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar alguna Fecha de Liquidacion , Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF
/**/

ldc_tasa_cambio  = gnvo_app.of_tasa_cambio(Date(ldt_fec_aprob))

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	lb_ret = FALSE
	GOTO SALIDA
END IF


select count(*)
  into :ll_count
  from cntbl_asiento          ca ,
	    cntbl_asiento_det 		cad    
 where ((ca.origen        = cad.origen       )  AND
	     (ca.ano           = cad.ano          )  AND
	     (ca.mes           = cad.mes          )  AND
	     (ca.nro_libro     = cad.nro_libro    )  AND
	     (ca.nro_asiento   = cad.nro_asiento  )) AND
		 ((ca.flag_estado	  <> '0'					)) AND
		  (ca.nro_libro     IN (select nro_libro from cntbl_libro_grp_det  where lbro_grp in (SELECT LBRO_GRP_CAJA_BANCOS FROM FINPARAM))          )  AND
	    ((cad.tipo_docref1 = :ls_tipo_doc     )  AND  
	     (cad.nro_docref1  = :ls_nro_doc      )  AND  
	     (cad.cod_relacion = :ls_cod_rel      )) ;

IF ll_count > 0 THEN

	SELECT cad.cnta_ctbl  ,decode(cad.flag_debhab,'D','H','D') as flag_debhab ,   
   	    cad.imp_movsol ,cad.imp_movdol 
	  INTO :ls_cnta_ctbl_haber,:ls_flag_debhab,:ldc_impmovsol,:ldc_impmovdol
	  FROM cntbl_asiento          ca ,
	       cntbl_asiento_det 		cad    
	 WHERE ((ca.origen        = cad.origen       )  AND
	        (ca.ano           = cad.ano          )  AND
	        (ca.mes           = cad.mes          )  AND
	        (ca.nro_libro     = cad.nro_libro    )  AND
	        (ca.nro_asiento   = cad.nro_asiento  )) AND
			 ((ca.flag_estado	  <> '0'					))  AND
			  (ca.nro_libro     IN (select nro_libro from cntbl_libro_grp_det  where lbro_grp in (SELECT LBRO_GRP_CAJA_BANCOS FROM FINPARAM))          )  AND
	       ((cad.tipo_docref1 = :ls_tipo_doc     )  AND  
	        (cad.nro_docref1  = :ls_nro_doc      )  AND  
	        (cad.cod_relacion = :ls_cod_rel      )) ;

ELSE
	Messagebox('Aviso','No se ha Generado Cuenta Corriente de Orden de Giro , Verifique!')
	lb_ret = FALSE
	GOTO SALIDA		
END IF




/*GENERA ASIENTOS*/

ll_row = tab_1.tabpage_3.dw_asiento_det_liq.InsertRow(0)
tab_1.tabpage_3.dw_asiento_det_liq.object.item         [ll_row] = ll_row
tab_1.tabpage_3.dw_asiento_det_liq.object.fec_cntbl    [ll_row] = ldt_fec_aprob
tab_1.tabpage_3.dw_asiento_det_liq.object.cnta_ctbl    [ll_row] = ls_cnta_ctbl_haber
tab_1.tabpage_3.dw_asiento_det_liq.object.det_glosa    [ll_row] = 'DEVOLUCION DE ORDEN DE GIRO'
tab_1.tabpage_3.dw_asiento_det_liq.object.flag_debhab  [ll_row] = ls_flag_debhab
tab_1.tabpage_3.dw_asiento_det_liq.object.cod_relacion [ll_row] = ls_cod_rel
tab_1.tabpage_3.dw_asiento_det_liq.object.tipo_docref1 [ll_row] = ls_tipo_doc
tab_1.tabpage_3.dw_asiento_det_liq.object.nro_docref1  [ll_row] = ls_nro_doc

IF ls_moneda_det = ls_soles THEN
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol [ll_row] = ldc_impmovsol
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol [ll_row] = Round(ldc_impmovsol / ldc_tasa_cambio,2)
ELSE
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol [ll_row] = ldc_impmovdol
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol [ll_row] = Round(ldc_impmovdol * ldc_tasa_cambio,2)
END IF




/*diferencia  en cambio (solo cuando moneda es dolares)*/
ldc_saldo_sol = Round(ldc_impmovdol * ldc_tasa_cambio,2) - ldc_impmovsol

IF ls_moneda_det = ls_dolares THEN
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
						 
	 ELSEIF ldc_saldo_sol = 0 THEN /*No Genera Diferencia en Cambio*/
		 GOTO SAL_ASIENTO					
	 END IF /*VERIFICACION SALDO*/
	 
	 
	 /*Asiento de Diferencia en cambio*/
	 ll_row = tab_1.tabpage_3.dw_asiento_det_liq.InsertRow(0)	//Inserta Registro 
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.item        [ll_row] = ll_row
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.cnta_ctbl   [ll_row] = ls_cnta_ctbl_dif
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.det_glosa   [ll_row] = ls_det_glosa
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.flag_debhab [ll_row] = ls_flag_debhab_dif  							 
    tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol  [ll_row] = ldc_saldo_sol
	 tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol  [ll_row] = 0.00

			
	 /*Asiento de doc x diferencia en cambio*/	
 	 ll_row = tab_1.tabpage_3.dw_asiento_det_liq.InsertRow(0)	//Inserta Registro 
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.item	         [ll_row] = ll_row
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.cnta_ctbl     [ll_row] = ls_cnta_ctbl_haber
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.det_glosa     [ll_row] = 'DIFERENCIA EN CAMBIO'
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.tipo_docref1  [ll_row] = ls_tipo_doc     
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.nro_docref1   [ll_row] = ls_nro_doc     
	 tab_1.tabpage_3.dw_asiento_det_liq.Object.cod_relacion  [ll_row] = ls_cod_rel

	 tab_1.tabpage_3.dw_asiento_det_liq.Object.flag_debhab   [ll_row] = ls_flag_debhab_dif_x_doc  
	 tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol    [ll_row] = ldc_saldo_sol
	 tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol    [ll_row] = 0.00
	 
END IF





SAL_ASIENTO:
/*asiento de tabla de parametros*/
IF ls_flag_debhab	= 'D' THEN
	ls_flag_debhab	= 'H' 
ELSE
	ls_flag_debhab	= 'D' 
END IF


ll_row = tab_1.tabpage_3.dw_asiento_det_liq.InsertRow(0)
tab_1.tabpage_3.dw_asiento_det_liq.object.item         [ll_row] = ll_row
tab_1.tabpage_3.dw_asiento_det_liq.object.fec_cntbl    [ll_row] = ldt_fec_aprob
tab_1.tabpage_3.dw_asiento_det_liq.object.cnta_ctbl    [ll_row] = ls_cnta_ctbl_debe
tab_1.tabpage_3.dw_asiento_det_liq.object.det_glosa    [ll_row] = 'DEVOLUCION DE ORDEN DE GIRO'
tab_1.tabpage_3.dw_asiento_det_liq.object.flag_debhab  [ll_row] = ls_flag_debhab
tab_1.tabpage_3.dw_asiento_det_liq.object.cod_relacion [ll_row] = ls_cod_rel
tab_1.tabpage_3.dw_asiento_det_liq.object.tipo_docref1 [ll_row] = ls_tipo_doc
tab_1.tabpage_3.dw_asiento_det_liq.object.nro_docref1  [ll_row] = ls_nro_doc

IF ls_moneda_det = ls_soles THEN
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol [ll_row] = ldc_impmovsol
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol [ll_row] = Round(ldc_impmovsol / ldc_tasa_cambio,2)
ELSE
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol [ll_row] = ldc_impmovdol
   tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol [ll_row] = Round(ldc_impmovdol * ldc_tasa_cambio,2)
END IF



tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1

SALIDA:

Return lb_ret
end function

public subroutine wf_genera_datos_dp ();//VERIFICAR CUENTA EN DETALLE DE ASIENTOS
//BUSCO CUENTA 
/*Cuenta para generar Asiento en debe y haber*/
String  ls_cnta_ctbl_deb,ls_flag_estado ,ls_cod_relacion,ls_nro_doc,ls_tipo_doc,&
		  ls_msj_err	   ,ls_expresion   ,ls_doc_sgiro
Long    ll_found,ll_row
Boolean lb_ret = TRUE


ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado   [ll_row]
ls_cod_relacion = dw_master.object.cod_relacion  [ll_row]
ls_nro_doc		 = dw_master.object.nro_solicitud [ll_row]


IF ls_flag_estado <> '5' THEN RETURN
	
	
SELECT cnta_ctbl_liq_debe,doc_sol_giro INTO :ls_cnta_ctbl_deb,:ls_doc_sgiro FROM finparam WHERE (reckey = '1') ;
 
 
 
//busco cuenta de perdida	
ls_expresion = "cnta_ctbl = '"+ls_cnta_ctbl_deb+"'" 


	
ll_found = tab_1.tabpage_3.dw_asiento_det_liq.Find(ls_expresion,1,tab_1.tabpage_3.dw_asiento_det_liq.rowcount())
	
IF ll_found > 0 THEN
	/*Replicacion*/	
	update doc_pendientes_cta_cte
   	set cnta_ctbl = :ls_cnta_ctbl_deb,flag_debhab = 'D',factor = 1,flag_replicacion = '1'
    where (cod_relacion = :ls_cod_relacion ) and
	 		 (tipo_doc     = :ls_doc_sgiro    ) and
			 (nro_doc		= :ls_nro_doc		 ) ;
		 
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		rollback;
		lb_ret = FALSE
      MessageBox("SQL error", ls_msj_err)
	END IF	 
			 
END IF
			

IF lb_ret and ll_found > 0 THEN
	Commit;
END if
end subroutine

on w_fi333_cierra_liquidacion_og_devolucion.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_proceso_cl" then this.MenuID = create m_mantenimiento_proceso_cl
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi333_cierra_liquidacion_og_devolucion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;tab_1.height = newheight - tab_1.y - 10
tab_1.width  = newwidth  - tab_1.x - 10



tab_1.tabpage_3.dw_asiento_det_liq.width  = newwidth  - tab_1.tabpage_3.dw_asiento_det_liq.x - 110
tab_1.tabpage_3.dw_asiento_det_liq.height = newheight - tab_1.tabpage_3.dw_asiento_det_liq.y - 900

end event

event ue_open_pre;call super::ue_open_pre;String  ls_origen,ls_nro_solicitud,ls_flag_estado
Boolean lb_ret = FALSE

idw_1 = dw_master              				// asignar dw corriente

dw_master.il_row = 1





dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

tab_1.tabpage_3.dw_asiento_cab_liq.SetTransObject(sqlca)
tab_1.tabpage_3.dw_asiento_det_liq.SetTransObject(sqlca)

/********************************/
/*Recuperacion de Solicitud Giro*/
/********************************/
SELECT sg.origen			,
		 sg.nro_solicitud	
  INTO :ls_origen ,
  		 :ls_nro_solicitud
  FROM solicitud_giro sg
 WHERE (rowid IN (SELECT MAX(rowid) FROM solicitud_giro where flag_estado in ('3','5') and flag_tipo_mvto = 'G')) ;
 
 

dw_master.Retrieve(ls_origen,ls_nro_solicitud)
tab_1.tabpage_3.dw_asiento_cab_liq.Retrieve(ls_origen,ls_nro_solicitud)
tab_1.tabpage_3.dw_asiento_det_liq.Retrieve(ls_origen,ls_nro_solicitud)
 
//crea objeto
invo_cntbl_asiento = create n_cst_asiento_contable
 
 IF dw_master.Rowcount() = 0 THEN
	 Messagebox('Aviso','No Existe Ninguna Solicitud de Giro ')
	 Return
 END IF
 
 
ls_flag_estado = dw_master.object.flag_estado [dw_master.Getrow()]
IF ls_flag_estado = '5' THEN
	cb_1.Enabled = FALSE //DESACTIVACION YA ESTA CERRADA LIQUIDACION
END IF

TriggerEvent('ue_modify')
 



end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1 OR &
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

		tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
		tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
		rollback ;	
	END IF
END IF

end event

event ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_3.dw_asiento_cab_liq.AcceptText()
tab_1.tabpage_3.dw_asiento_det_liq.AcceptText()



THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	Rollback ;
	RETURN
END IF	



	IF tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1 THEN
		IF tab_1.tabpage_3.dw_asiento_cab_liq.update() = -1 then
			lbo_ok = FALSE
			Messagebox("Error en Grabación Cabecera de Asiento Liquidación","Se ha procedido al rollback",exclamation!)			
		END IF
	END IF

	IF tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1 THEN
		IF tab_1.tabpage_3.dw_asiento_det_liq.update() = -1 then
			lbo_ok = FALSE
			Messagebox("Error en Grabación Detalle de Asiento Liquidación","Se ha procedido al rollback",exclamation!)			
		END IF
	END IF


IF dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion detalle de Cntas x Pagar
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Cabecera de Solicitud giro","Se ha procedido al rollback",exclamation!)
	END IF
END IF








IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
	if is_accion = 'new' then
		wf_genera_datos_dp()
	end if
	is_accion = 'fileopen'	
	TriggerEvent('ue_modify')	
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_modify();call super::ue_modify;String ls_flag_estado
Long   ll_row_master

dw_master.Accepttext()
ll_row_master = dw_master.Getrow()

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado = '5' THEN
	/*Cabecera*/
	dw_master.ii_protect = 0
	dw_master.of_protect() // protege el dw	

	
	/*  Asientos Liquidación  */
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_protect = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_protect = 0
	
	tab_1.tabpage_3.dw_asiento_cab_liq.of_protect() // protege el dw		
	tab_1.tabpage_3.dw_asiento_det_liq.of_protect() // protege el dw	
	
	cb_1.Enabled = FALSE //DESACTIVACION YA ESTA CERRADA LIQUIDACION
ELSE
	dw_master.of_protect()
	tab_1.tabpage_3.dw_asiento_cab_liq.of_protect() 
	tab_1.tabpage_3.dw_asiento_det_liq.of_protect() 
	
	
	cb_1.Enabled = TRUE //DESACTIVACION YA ESTA CERRADA LIQUIDACION
END IF

end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long   ll_row
String ls_periodo
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_liquidacion_cierre_og_dev_tbl'
sl_param.titulo = 'Cierra Liquidacion de Orden de Giro'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_search_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.retrieve(sl_param.field_ret[1],sl_param.field_ret[2])

	tab_1.tabpage_3.dw_asiento_cab_liq.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	tab_1.tabpage_3.dw_asiento_det_liq.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	
	
	dw_master.ii_update = 0

	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
  
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	

	
END IF

end event

event ue_delete();//OVERRIDE
String ls_flag_estado,ls_cod_relacion,ls_tipo_doc,ls_nro_doc
Long   ll_row,ll_row_master,ll_row_det

IF idw_1 <> tab_1.tabpage_3.dw_asiento_det_liq THEN
	Messagebox('Aviso','No se Pueden Eliminar datos , Verifique!')
	Return
ELSE
	ll_row_master = dw_master.Getrow() 
   ls_flag_estado  = dw_master.object.flag_estado [ll_row_master]	
	
	IF ll_row_master = 0 THEN RETURN
	
	/*Datos del Detalle*/
	ll_row_det = idw_1.Getrow()
	ls_cod_relacion = idw_1.Object.cod_relacion [ll_row_det]
	ls_tipo_doc     = idw_1.Object.tipo_docref1 [ll_row_det]
	ls_nro_doc      = idw_1.Object.nro_docref1  [ll_row_det]

	
	
	IF ls_flag_estado = '5' AND is_accion <> 'new' THEN
		Messagebox('Aviso','Liquidacion ya Ha sido Cerrada , Verifique!')
		Return
	END IF
	
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_insert();String   ls_flag_estado
Long     ll_row,ll_row_master
Datetime ldt_fecha_liq

ll_row_master = dw_master.Getrow()
IF ll_row_master = 0 THEN RETURN

IF idw_1 <> tab_1.tabpage_3.dw_asiento_det_liq THEN
	Messagebox('Aviso','No se Pueden Eliminar datos , Verifique!')
	Return
ELSE
	ldt_fecha_liq = dw_master.object.fecha_aprobacion [dw_master.getrow()]
	//Fecha de Liquidacion 
	IF Isnull(ldt_fecha_liq) OR String(ldt_fecha_liq,'dd/mm/yyyy') = '00/00/0000' THEN
		Messagebox ('Aviso','Debe Ingresar Fecha de Cierre de Liquidación , Verifique!')
		Return
	END IF
	
	//Cabecera de Asiento
	IF tab_1.tabpage_3.dw_asiento_cab_liq.Rowcount() = 0 THEN 
		Messagebox('Aviso','Debe Cerrar Liquidación ,Verifique!')
		Return
	END IF
	
END IF

tab_1.tabpage_3.dw_asiento_cab_liq.il_row = 1


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update_pre;Decimal {2} ldc_total_sol_deb ,ldc_total_dol_deb ,ldc_total_sol_hab ,ldc_total_dol_hab ,&
				ldc_imp_sol			,ldc_imp_dol       ,ldc_monto_soles	  ,ldc_monto_dolares
Decimal {3} ldc_tasa_cambio				
String      ls_mensaje,ls_result,ls_cod_moneda,ls_soles,ls_dolares
Datetime		ldt_fecha_og


IF is_accion <> 'new' THEN RETURN 

Long   ll_inicio,ll_nro_libro_x_doc,ll_ano,ll_mes,ll_nro_asiento,ll_found,&
		 ll_inicio_det,ll_nro_libro_sg
String ls_cod_origen ,ls_cod_relacion ,ls_nro_solicitud




f_monedas(ls_soles,ls_dolares)

ls_cod_origen    = dw_master.object.cnt_origen		  [1]
ll_nro_libro_sg  = dw_master.object.nro_libro 		  [1]
ll_ano 		 	  = dw_master.object.ano 				  [1]
ll_mes 		 	  = dw_master.object.mes 				  [1]
ldt_fecha_og 	  = dw_master.object.fecha_aprobacion [1]
ls_cod_relacion  = dw_master.object.cod_relacion  	  [1]
ls_nro_solicitud = dw_master.object.nro_solicitud 	  [1]
ls_cod_moneda	  = dw_master.object.cod_moneda	 	  [1]	
ldc_tasa_cambio  = gnvo_app.of_tasa_cambio (Date(ldt_fecha_og))


/*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	ib_update_check = False	
	Return
END IF	


SetNull(ll_nro_asiento)

/*verifica cabecera de asiento*/
IF f_row_Processing( tab_1.tabpage_3.dw_asiento_cab_liq, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

/*----- Recuperar Nro Asiento para documento Solicitud de giro ----*/
IF invo_cntbl_asiento.of_get_nro_asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro_sg, ll_nro_asiento)  = FALSE THEN
	wf_reset_dw ()
	ib_update_check = FALSE
	Return	
END IF

/*Cabecera*/
dw_master.object.nro_asiento [1] = ll_nro_asiento
/*Asiento de Cabecera*/
tab_1.tabpage_3.dw_asiento_cab_liq.object.nro_asiento [1] = ll_nro_asiento

For ll_inicio = 1 TO tab_1.tabpage_3.dw_asiento_det_liq.Rowcount()
	 tab_1.tabpage_3.dw_asiento_det_liq.object.origen  	 [ll_inicio] = ls_cod_origen
	 tab_1.tabpage_3.dw_asiento_det_liq.object.nro_libro   [ll_inicio] = ll_nro_libro_sg
	 tab_1.tabpage_3.dw_asiento_det_liq.object.ano         [ll_inicio] = ll_ano
	 tab_1.tabpage_3.dw_asiento_det_liq.object.mes         [ll_inicio] = ll_mes
	 tab_1.tabpage_3.dw_asiento_det_liq.object.nro_asiento [ll_inicio] = ll_nro_asiento
	 tab_1.tabpage_3.dw_asiento_det_liq.object.fec_cntbl	 [ll_inicio] = ldt_fecha_og
	 
	 ldc_imp_sol = tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movsol [ll_inicio]
	 ldc_imp_dol = tab_1.tabpage_3.dw_asiento_det_liq.object.imp_movdol [ll_inicio]
	 
Next


/*totales de asiento generado solicitud de giro*/
IF tab_1.tabpage_3.dw_asiento_det_liq.Rowcount() > 0 THEN	  
	ldc_total_sol_deb = tab_1.tabpage_3.dw_asiento_det_liq.Object.monto_soles_cargo   [1]
	ldc_total_dol_deb = tab_1.tabpage_3.dw_asiento_det_liq.Object.monto_dolares_cargo [1]
	ldc_total_sol_hab = tab_1.tabpage_3.dw_asiento_det_liq.Object.monto_soles_abono   [1]
	ldc_total_dol_hab = tab_1.tabpage_3.dw_asiento_det_liq.Object.monto_dolares_abono [1]
	
	wf_total_asiento_cab (ldc_total_sol_deb,ldc_total_dol_deb,ldc_total_sol_hab,ldc_total_dol_hab,1,tab_1.tabpage_3.dw_asiento_cab_liq)
END IF





//actualizo orden de giro
if ls_cod_moneda = ls_soles then
	ldc_monto_soles   = dw_master.object.importe_doc [1] * -1
	ldc_monto_dolares = Round(dw_master.object.importe_doc [1] / ldc_tasa_cambio,2) * -1
else
	ldc_monto_dolares = dw_master.object.importe_doc [1] * -1
	ldc_monto_soles   = Round(dw_master.object.importe_doc [1] * ldc_tasa_cambio,2) * -1	
end if

dw_master.object.saldo_sol [1] = ldc_monto_soles
dw_master.object.saldo_dol [1] = ldc_monto_dolares

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event closequery;call super::closequery;Destroy invo_cntbl_asiento

ROLLBACK ;
end event

type cb_1 from commandbutton within w_fi333_cierra_liquidacion_og_devolucion
integer x = 2930
integer y = 24
integer width = 439
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cierre Liquidación"
end type

event clicked;Long   ll_row_master,ll_ano,ll_mes,ll_nro_libro_sg,ll_nro_asiento
String ls_doc_sol_giro ,ls_cod_origen_og,ls_nro_sg,ls_moneda_sg,ls_descripcion,&
		 ls_flag_estado  ,ls_cod_relacion ,ls_msj_err	 
Decimal {3} ldc_tasa_cambio
Datetime ldt_fecha_cierre_og

select doc_sol_giro into :ls_doc_sol_giro from finparam where reckey = '1' ;

ll_row_master = dw_master.Getrow()
IF ll_row_master = 0 THEN 
	Messagebox('Aviso','No existe Solicitud de Giro Pagada ,Verifique!')
	RETURN
END IF	




ls_nro_sg        = dw_master.object.nro_solicitud [ll_row_master]
ls_cod_origen_og = dw_master.object.cnt_origen	  [ll_row_master]
ll_ano			  = dw_master.object.ano			  [ll_row_master]
ll_mes			  = dw_master.object.mes			  [ll_row_master]
ll_nro_libro_sg  = dw_master.object.nro_libro	  [ll_row_master]
ls_moneda_sg	  = dw_master.object.cod_moneda	  [ll_row_master]
ldt_fecha_cierre_og = dw_master.object.fecha_aprobacion [ll_row_master]
ldc_tasa_cambio  = gnvo_app.of_tasa_cambio(Date(ldt_fecha_cierre_og))
ls_flag_estado	  = dw_master.object.flag_estado   [ll_row_master]	
ls_descripcion	  = ''
ls_cod_relacion  = dw_master.object.cod_relacion  [ll_row_master]


IF ls_flag_estado <> '3' THEN
	Messagebox('Aviso','Solicitud de Giro No Se Encuentra Pagada , Verifique!')
	Return
END IF

/*validaciones*/
IF Isnull(ls_cod_origen_og) OR Trim(ls_cod_origen_og)  = '' THEN
	Messagebox('Aviso','Debe Ingresar Origen de Asiento Contable ,Verifique!')
	Return
END IF

IF Isnull(ll_ano) OR ll_ano = 0 THEN
	Messagebox('Aviso','Debe Ingresar el Año Contable,Verifique!')
	Return
END IF

IF Isnull(ll_mes) OR ll_mes = 0 THEN
	Messagebox('Aviso','Debe Seleccionar El Mes Contable,Verifique!')
	Return
END IF

IF Isnull(ll_nro_libro_sg) OR ll_nro_libro_sg = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Un Nro de Libro,Verifique!')
	Return
END IF

IF Isnull(ls_moneda_sg) OR Trim (ls_moneda_sg) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un Tipo de Moneda,Verifique!')
	Return
END IF	

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar una Fecha Valida,Verifique!')
	Return
END IF





is_accion = 'new'

IF Parent.wf_genera_asiento_devolucion ()  THEN
	dw_master.object.usuario_aprob     [ll_row_master] = gs_user
	dw_master.object.importe_liquidado [ll_row_master] = dw_master.object.importe_doc [ll_row_master]
	dw_master.object.flag_estado 	     [ll_row_master] = '5' 				 // Liquidacion Cerrada
	dw_master.ii_update = 1

	/*Eliminar Movimiento de bolsa presupuestal*/

	DELETE FROM presupuesto_ejec
	WHERE ((origen_ref   = :ls_cod_origen_og ) AND
			 (tipo_doc_ref = :ls_doc_sol_giro  ) AND
		    (nro_doc_ref  = :ls_nro_sg        )) ;
				  
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		wf_reset_dw ()
	   Rollback ;
		MessageBox('Reversión Presupuesto SG', ls_msj_err)
	   Return 
	END IF	
	
	//MENORAR CONTADOR DE SOLICITUD DE GIRO
   /*Replicacion*/
	UPDATE maestro_param_autoriz
      SET nro_solicitudes_pend = Nvl(nro_solicitudes_pend,0) - 1,flag_replicacion = '1'
    WHERE (cod_relacion = :ls_cod_relacion) ;
 
   IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = sqlca.sqlerrtext
	   Rollback ;
      MessageBox("SQL error", ls_msj_err)
		Return
   END IF
	
	
	/*Insertar Asiento de Cabecera*/
	tab_1.tabpage_3.dw_asiento_cab_liq.TriggerEvent('ue_insert')
	tab_1.tabpage_3.dw_asiento_cab_liq.Object.flag_tabla [1] = '6'

	Parent.wf_insert_asiento_cab_sg (gs_origen,ll_ano,ll_mes,ll_nro_libro_sg,ll_nro_asiento,ls_moneda_sg,&
												ldc_tasa_cambio,ls_descripcion,ldt_fecha_cierre_og,1)

END IF



end event

type tab_1 from tab within w_fi333_cierra_liquidacion_og_devolucion
event ue_find_exact ( )
integer x = 23
integer y = 764
integer width = 3250
integer height = 924
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_3 tabpage_3
end type

event ue_find_exact();Parent.TriggerEvent('ue_find_exact')
end event

on tab_1.create
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_3)
end on

event key;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3214
integer height = 804
long backcolor = 79741120
string text = "Asientos Liquidacion"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_asiento_cab_liq dw_asiento_cab_liq
dw_asiento_det_liq dw_asiento_det_liq
end type

on tabpage_3.create
this.dw_asiento_cab_liq=create dw_asiento_cab_liq
this.dw_asiento_det_liq=create dw_asiento_det_liq
this.Control[]={this.dw_asiento_cab_liq,&
this.dw_asiento_det_liq}
end on

on tabpage_3.destroy
destroy(this.dw_asiento_cab_liq)
destroy(this.dw_asiento_det_liq)
end on

type dw_asiento_cab_liq from u_dw_abc within tabpage_3
boolean visible = false
integer x = 14
integer y = 436
integer width = 3186
integer height = 356
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_asiento_cab_og_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple



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



idw_mst = tab_1.tabpage_3.dw_asiento_cab_liq // dw_master
idw_det = tab_1.tabpage_3.dw_asiento_det_liq // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.flag_tabla [al_row] = '6' //solicitud giro
end event

event dberror;
String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
//	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK','Llave Duplicada, Linea: ' + String(row))
//        Return 1
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	CASE ELSE
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
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE





end event

type dw_asiento_det_liq from u_dw_abc within tabpage_3
integer x = 14
integer y = 20
integer width = 3186
integer height = 404
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_asiento_og_dev_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw
ii_ck[6] = 6			// columnas de lectrua de este dw


ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master
ii_rk[4] = 4 	      // columnas que recibimos del master
ii_rk[5] = 5 	      // columnas que recibimos del master

idw_mst = tab_1.tabpage_3.dw_asiento_cab_liq // dw_master
idw_det = tab_1.tabpage_3.dw_asiento_det_liq // dw_detail

end event

event itemchanged;String   ls_codigo,ls_cnta_ctbl,ls_flag_ctbco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef
Datetime ldt_fec_aprob
Decimal	{2} ldc_imp_sol,ldc_imp_dol
Decimal  {3} ldc_tasa_cambio
Accepttext()



ldt_fec_aprob   = dw_master.object.fecha_aprobacion [dw_master.getrow()]

CHOOSE CASE dwo.name
		 CASE 'cnta_ctbl','cod_relacion','tipo_docref1','nro_docref1','cencos','cod_ctabco'	
				ls_cnta_ctbl = This.object.cnta_ctbl [row]
				SetNull(ls_codigo)
				IF f_cntbl_cnta (ls_cnta_ctbl,ls_flag_ctbco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef) = FALSE THEN
					This.object.cnta_ctbl	 [row] = ls_codigo
					This.object.cod_relacion [row] = ls_codigo
					This.object.tipo_docref1 [row] = ls_codigo
					This.object.cencos		 [row] = ls_codigo
					This.object.cod_ctabco	 [row] = ls_codigo
					This.object.imp_movsol	 [row] = 0.00
					This.object.imp_movdol	 [row] = 0.00
					Return 1
				ELSE
					
					IF ls_flag_ctbco = '1' THEN
						This.object.cod_ctabco.protect = 0
					ELSE	
						This.object.cod_ctabco.protect = 1
						This.object.cod_ctabco [row] = ls_codigo
					END IF
					
					IF ls_flag_cencos = '1' THEN
						This.object.cencos.protect = 0
					ELSE	
						This.object.cencos.protect = 1
						This.object.cencos [row] = ls_codigo
					END IF
					
					IF ls_flag_doc_ref = '1' THEN
						This.object.tipo_docref1.protect = 0
						This.object.nro_docref1.protect  = 0
					ELSE	
						This.object.tipo_docref1.protect = 1
						This.object.nro_docref1.protect  = 1

						This.object.tipo_docref1 [row] = ls_codigo
						This.object.nro_docref1  [row] = ls_codigo
					END IF
					
					IF ls_flag_cod_rel = '1' THEN
						This.object.cod_relacion.protect = 0
					ELSE	
						This.object.cod_relacion.protect = 1
						This.object.cod_relacion [row] = ls_codigo
					END IF
					
				END IF
			
		 CASE 'imp_movsol'
				ldc_tasa_cambio = gnvo_app.of_tasa_cambio(Date(ldt_fec_aprob))
				
				ldc_imp_sol = This.object.imp_movsol [row]
				
				This.object.imp_movdol [row] = Round(ldc_imp_sol / ldc_tasa_cambio ,2)
				
		 CASE 'imp_movdol'
				ldc_tasa_cambio = gnvo_app.of_tasa_cambio(Date(ldt_fec_aprob))
				
				ldc_imp_dol = This.object.imp_movdol [row]
				
				This.object.imp_movsol [row] = Round(ldc_imp_dol * ldc_tasa_cambio ,2)
				
END CHOOSE




end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;


This.Object.item      [al_row] = al_row	




end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot ,ls_cod_relacion,ls_flag_cencos,ls_cnta_ctbl,&
			  ls_cencos,ls_codigo,ls_flag_ctbco,ls_flag_doc_ref,ls_flag_cod_rel,&
			  ls_flag_cebef
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if



CHOOSE CASE dwo.name
		 CASE 'cnta_ctbl','cod_relacion','tipo_docref1','cencos','cod_ctabco'	
				IF dwo.name = 'cnta_ctbl' THEN
					lstr_seleccionar.s_seleccion = 'S'
   				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA , '&
											      		 +'CNTBL_CNTA.DESC_CNTA  AS DESCRIPCION '&
									  				       +'FROM CNTBL_CNTA ' 
														

 					OpenWithParm(w_seleccionar,lstr_seleccionar)
				
					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					IF lstr_seleccionar.s_action = "aceptar" THEN
						Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
						ii_update = 1
					END IF				

				ELSEIF dwo.name = 'cod_relacion' THEN //codigo de relacion
					
					lstr_seleccionar.s_seleccion = 'S'
   				lstr_seleccionar.s_sql = 'SELECT CODIGO_RELACION.COD_RELACION AS CODIGO , '&
											      		 +'CODIGO_RELACION.NOMBRE       AS NOM_RELACION '&
									  				       +'FROM CODIGO_RELACION ' 

 					OpenWithParm(w_seleccionar,lstr_seleccionar)
				
					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					IF lstr_seleccionar.s_action = "aceptar" THEN
						Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
						ii_update = 1
					END IF				
					
				ELSEIF dwo.name = 'tipo_docref1' THEN //tipo de documento
					
					lstr_seleccionar.s_seleccion = 'S'
   				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO , '&
											      		 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
									  				       +'FROM DOC_TIPO ' 
														

 					OpenWithParm(w_seleccionar,lstr_seleccionar)
				
					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					IF lstr_seleccionar.s_action = "aceptar" THEN
						Setitem(row,'tipo_docref1',lstr_seleccionar.param1[1])
						ii_update = 1
					END IF				
					
				ELSEIF dwo.name = 'cencos'			THEN //Centro de costo
					
					lstr_seleccionar.s_seleccion = 'S'
   				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CODIGO , '&
											      		 +'CENTROS_COSTO.DESC_CNTA  AS DESCRIPCION '&
									  				       +'FROM CENTROS_COSTO ' 
														

 					OpenWithParm(w_seleccionar,lstr_seleccionar)
				
					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					IF lstr_seleccionar.s_action = "aceptar" THEN
						Setitem(row,'cencos',lstr_seleccionar.param1[1])
						ii_update = 1
					END IF				
					
				ELSEIF dwo.name = 'cod_ctabco'	THEN //Cuenta de Banco	
					
					lstr_seleccionar.s_seleccion = 'S'
   				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA , '&
											      		 +'BANCO_CNTA.DESCRIPCION AS DESC_CUENTA'&
									  				       +'FROM BANCO_CNTA ' 
														

 					OpenWithParm(w_seleccionar,lstr_seleccionar)
				
					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					IF lstr_seleccionar.s_action = "aceptar" THEN
						Setitem(row,'cod_ctabco',lstr_seleccionar.param1[1])
						ii_update = 1
					END IF				
					
				END IF
				
				/*Validacion de Cnta Ctbl*/
				ls_cnta_ctbl = This.object.cnta_ctbl [row]
				SetNull(ls_codigo)
				IF f_cntbl_cnta (ls_cnta_ctbl,ls_flag_ctbco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef) = FALSE THEN
					This.object.cnta_ctbl	 [row] = ls_codigo
					This.object.cod_relacion [row] = ls_codigo
					This.object.tipo_docref1 [row] = ls_codigo
					This.object.cencos		 [row] = ls_codigo
					This.object.cod_ctabco	 [row] = ls_codigo
					This.object.imp_movsol	 [row] = 0.00
					This.object.imp_movdol	 [row] = 0.00
					Return 
				ELSE
					IF ls_flag_ctbco = '1' THEN
						This.object.cod_ctabco.protect = 0
					ELSE	
						This.object.cod_ctabco.protect = 1
						This.object.cod_ctabco [row] = ls_codigo
					END IF
				
					IF ls_flag_cencos = '1' THEN
						This.object.cencos.protect = 0
					ELSE	
						This.object.cencos.protect = 1
						This.object.cencos [row] = ls_codigo
					END IF
				
					IF ls_flag_doc_ref = '1' THEN
						This.object.tipo_docref1.protect = 0
						This.object.nro_docref1.protect  = 0
					ELSE	
						This.object.tipo_docref1.protect = 1
						This.object.nro_docref1.protect  = 1
						This.object.tipo_docref1 [row] = ls_codigo
						This.object.nro_docref1  [row] = ls_codigo
					END IF
					
					IF ls_flag_cod_rel = '1' THEN
						This.object.cod_relacion.protect = 0
					ELSE	
						This.object.cod_relacion.protect = 1
						This.object.cod_relacion [row] = ls_codigo
					END IF
					
				END IF
				
END CHOOSE



end event

type dw_master from u_dw_abc within w_fi333_cierra_liquidacion_og_devolucion
integer x = 9
integer y = 12
integer width = 2784
integer height = 748
string dataobject = "d_abc_liquidacion_solicitud_giro_dev_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				


idw_mst  = dw_master	// dw_master

end event

event itemchanged;Datetime ldt_fec_aprob
Decimal {3} ldc_tasa_x_dia

Accepttext()
CHOOSE CASE dwo.name
		 CASE 'fecha_aprobacion'
				ldt_fec_aprob = This.object.fecha_aprobacion [row]
				IF gnvo_app.of_tasa_cambio(Date(ldt_fec_aprob)) = 0.000 THEN
					Setnull(ldt_fec_aprob) 
					This.object.fecha_aprobacion [row] = ldt_fec_aprob
					Return 1
				END IF
					
					
			
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

