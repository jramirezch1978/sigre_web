$PBExportHeader$w_fi343_liquidacion_caja.srw
forward
global type w_fi343_liquidacion_caja from w_abc
end type
type cb_1 from commandbutton within w_fi343_liquidacion_caja
end type
type tab_1 from tab within w_fi343_liquidacion_caja
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
type tab_1 from tab within w_fi343_liquidacion_caja
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_fi343_liquidacion_caja
end type
end forward

global type w_fi343_liquidacion_caja from w_abc
integer width = 3845
integer height = 2144
string title = "Liquidacion de Caja (FI343)"
string menuname = "m_mantenimiento_cl_anular"
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_fi343_liquidacion_caja w_fi343_liquidacion_caja

type variables
n_cst_asiento_contable invo_cntbl_asiento
String is_accion,is_doc_cri
DataStore ids_matriz_cntbl_det  ,ids_glosa ,ids_doc_pend_tbl ,ids_asiento_adic ,&
			 ids_crelacion_ext_tbl 
Boolean ib_estado_asiento = TRUE //generacion de asientos

end variables

forward prototypes
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_nro_liquidacion, long al_item, string as_tipo_doc, string as_nro_doc, decimal adc_importe, string as_flag_tabor, string as_accion, ref string as_flag)
public function decimal wf_total_documento ()
public subroutine wf_actualiza_datos_detalle (string as_cod_moneda, decimal adc_tasa_cambio)
public function boolean wf_generacion_cntas ()
public function boolean wf_genera_cretencion (long al_nro_serie, ref string as_mensaje, ref string as_nro_doc)
public function long wf_verifica_liquidacion (string as_cod_relacion, string as_tipo_doc, string as_nro_liquidacion)
end prototypes

public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_nro_liquidacion, long al_item, string as_tipo_doc, string as_nro_doc, decimal adc_importe, string as_flag_tabor, string as_accion, ref string as_flag);DECLARE PB_USP_FIN_INS_DOC_LIQ_CAJ PROCEDURE FOR USP_FIN_INS_DOC_LIQ_CAJ
(:as_cod_relacion ,:as_nro_liquidacion ,:al_item       ,:as_tipo_doc ,
 :as_nro_doc      ,:adc_importe        ,:as_flag_tabor ,:as_accion);
EXECUTE PB_USP_FIN_INS_DOC_LIQ_CAJ ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_INS_DOC_LIQ_CAJ INTO :as_flag ;
CLOSE PB_USP_FIN_INS_DOC_LIQ_CAJ ;
end subroutine

public function decimal wf_total_documento ();String ls_soles,ls_dolares,ls_moneda_ref,ls_moneda_cab,ls_tipo_doc
Long   ll_inicio,ll_factor
Decimal {2} ldc_importe_total,ldc_importe_ref,ldc_importe_ret
Decimal {3} ldc_tasa_cambio


f_monedas(ls_soles,ls_dolares)


dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()

/*VERIFICAR DOCUMENTO DE LIQUIDACION*/
ls_tipo_doc = dw_master.object.tipo_doc [dw_master.getrow()]
/**/

ldc_importe_total = 0.00
ldc_importe_ref   = 0.00
ldc_importe_ret	= 0.00

For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_importe_ref = tab_1.tabpage_1.dw_detail.object.importe          [ll_inicio]
	 ldc_importe_ret = tab_1.tabpage_1.dw_detail.object.importe_retenido [ll_inicio]	 	 
	 ls_moneda_ref	  = tab_1.tabpage_1.dw_detail.object.cod_moneda       [ll_inicio]
 	 ll_factor       = tab_1.tabpage_1.dw_detail.object.factor_signo     [ll_inicio]
	 ls_moneda_cab   = tab_1.tabpage_1.dw_detail.object.moneda_cab       [ll_inicio]
	 ldc_tasa_cambio = tab_1.tabpage_1.dw_detail.object.tasa_cambio      [ll_inicio]
	 
	 
	 IF Isnull(ldc_importe_ref) THEN ldc_importe_ref = 0.00
	 IF Isnull(ldc_importe_ret) THEN ldc_importe_ret = 0.00
	 

	 
	 IF ls_moneda_cab =  ls_moneda_ref THEN
		 ldc_importe_ref = ldc_importe_ref * ll_factor
	 ELSEIF ls_moneda_ref = ls_soles THEN
		 ldc_importe_ref = Round(ldc_importe_ref / ldc_tasa_cambio,2) * ll_factor
	 ELSEIF ls_moneda_ref = ls_dolares THEN
		 ldc_importe_ref = Round(ldc_importe_ref * ldc_tasa_cambio,2)  * ll_factor
	 END IF	


	  
	 //acumulador
	 ldc_importe_total = ldc_importe_total + ldc_importe_ref
	 
	 /*IMPORTE DE RETENCION*/
	 IF ls_moneda_cab <> ls_soles THEN
		 ldc_importe_ret = Round(ldc_importe_ret / ldc_tasa_cambio,2)
	 ELSE	
		ldc_importe_ret = ldc_importe_ret 
	 END IF	 
	 
	
	//de acuerdo a tipo de liquidacion
	IF trim(ls_tipo_doc) = 'LQP' THEN

		
		IF ll_factor = 1 THEN
			ldc_importe_total = ldc_importe_total + (ldc_importe_ret * 1)
		ELSE
			ldc_importe_total = ldc_importe_total + (ldc_importe_ret * -1)
		END IF
	ELSE//LIQUIDACION POR COBRAR
		IF ll_factor = -1 THEN
			ldc_importe_total = ldc_importe_total + (ldc_importe_ret * -1)
		ELSE
			ldc_importe_total = ldc_importe_total + (ldc_importe_ret * 1)
		END IF
	END IF
	 
	 
Next


Return Round(ldc_importe_total,2)







end function

public subroutine wf_actualiza_datos_detalle (string as_cod_moneda, decimal adc_tasa_cambio);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.moneda_cab  [ll_inicio] = as_cod_moneda
	 tab_1.tabpage_1.dw_detail.object.tasa_cambio [ll_inicio] = adc_tasa_cambio
	 
	 
next

end subroutine

public function boolean wf_generacion_cntas ();Boolean lb_ret = TRUE
/*generacion de cntas*/

IF f_generacion_cntas_liq_caj (dw_master                      ,tab_1.tabpage_1.dw_detail , &
								  		 tab_1.tabpage_2.dw_asiento_det ,ids_matriz_cntbl_det      , &
								       ids_glosa                      ,ids_doc_pend_tbl          , &
								       ids_asiento_adic					  ,ids_crelacion_ext_tbl ) = FALSE THEN
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

public function long wf_verifica_liquidacion (string as_cod_relacion, string as_tipo_doc, string as_nro_liquidacion);Long ll_count

/*verificar que liquidacion no esta pagada para poder ser anulada*/
select count(*) into :ll_count from caja_bancos cb,caja_bancos_det cbd
 where (cb.origen			 = cbd.origen		    ) and
 		 (cb.nro_registro	 = cbd.nro_registro   ) and
		 (cb.flag_estado	 <> '0'				    ) and
 		 (cbd.cod_relacion = :as_cod_relacion   ) and
 		 (cbd.tipo_doc		 = :as_tipo_doc	    ) and
		 (cbd.nro_doc		 = :as_nro_liquidacion) ;





Return ll_count
end function

on w_fi343_liquidacion_caja.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi343_liquidacion_caja.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_detail.width       = newwidth  - tab_1.tabpage_1.dw_detail.x - 50
tab_1.tabpage_1.dw_detail.height      = newheight - tab_1.tabpage_1.dw_detail.y - 900
tab_1.tabpage_2.dw_asiento_det.width  = newwidth  - tab_1.tabpage_2.dw_asiento_det.x - 50
tab_1.tabpage_2.dw_asiento_det.height = newheight - tab_1.tabpage_2.dw_asiento_det.y - 900
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asiento_cab.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asiento_det.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija


//crea objeto
invo_cntbl_asiento = create n_cst_asiento_contable

/*recuperar tipo doc cri*/
select doc_ret_igv_crt into :is_doc_cri from finparam where reckey = '1' ;




//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)
//** **//


//** Datastore Glosa **//
ids_glosa = Create Datastore
ids_glosa.DataObject = 'd_glosa_cb_tbl'
ids_glosa.SettransObject(sqlca)
//** **//


//** Datastore Doc Pendientes Cta CTE **//
ids_doc_pend_tbl = Create Datastore
ids_doc_pend_tbl.DataObject = 'd_doc_pend_x_aplic_doc_tbl'
ids_doc_pend_tbl.SettransObject(sqlca)
//** **//


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

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF


IF idw_1 = dw_master THEN
	triggerevent('ue_update_request')
	
	IF ib_update_check = False THEN RETURN
	
	is_accion = 'new'
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_asiento_cab.Reset()
	tab_1.tabpage_2.dw_asiento_det.Reset()
	ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
	
ELSEIF idw_1 = tab_1.tabpage_1.dw_detail OR idw_1 = tab_1.tabpage_2.dw_asiento_cab OR idw_1 = tab_1.tabpage_2.dw_asiento_det THEN
	
	RETURN
	
END IF


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update;call super::ue_update;Long     ll_row_master ,ll_inicio,ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
String   ls_nro_liquidacion,ls_origen,ls_flag_retencion,ls_cod_relacion,ls_nro_cr
Datetime ldt_fecha_doc
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_imp_ret_sol,ldc_imp_ret_dol
Boolean  lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()




THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

/*Datos de Cabecera*/
ll_row_master      = dw_master.getrow()
ls_nro_liquidacion = dw_master.object.nro_liquidacion   [ll_row_master]
ls_origen 		    = dw_master.object.origen			     [ll_row_master]
ls_flag_retencion  = dw_master.object.flag_retencion    [ll_row_master]
ldt_fecha_doc	    = dw_master.object.fecha_liquidacion [ll_row_master]
ldc_tasa_cambio	 = dw_master.object.tasa_cambio	 	  [ll_row_master]


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


IF tab_1.tabpage_1.dw_detail.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF




IF ls_flag_retencion = '1' THEN /*cabecera*/
	FOR ll_inicio = 1 TO ids_crelacion_ext_tbl.Rowcount()
		 ls_cod_relacion = ids_crelacion_ext_tbl.object.cod_relacion [ll_inicio]
		 ls_nro_cr	     = ids_crelacion_ext_tbl.object.nro_cr       [ll_inicio]
	 
	   /*encontrar monto de cri x proveedor*/
		f_monto_cri_x_ccrel(tab_1.tabpage_1.dw_detail,ls_cod_relacion,ldc_tasa_cambio,ldc_imp_ret_sol,ldc_imp_ret_dol)
		
		
		
	   
		/*SE GENERA COMPROBANTE DE RETENCION*/
		INSERT INTO retencion_igv_crt
		(nro_certificado,fecha_emision,origen    ,nro_liquidacion,
		 proveedor      ,flag_estado  ,flag_tabla,importe_doc     ,
		 saldo_sol		 ,saldo_dol    ,flag_replicacion)  
		VALUES
		(:ls_nro_cr       ,:ldt_fecha_doc   ,:ls_origen ,:ls_nro_liquidacion,
     	 :ls_cod_relacion ,'1'			      ,'5'			 ,:ldc_imp_ret_sol,
		 :ldc_imp_ret_sol ,:ldc_imp_ret_dol ,'1'	)  ;
	   
		
		IF SQLCA.SQLCode = -1 THEN 
			MessageBox("SQL error", SQLCA.SQLErrText)
			lbo_ok = FALSE
			GOTO SALIDA
		END IF
	 
	NEXT
END IF



SALIDA:

IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_1.tabpage_2.dw_asiento_cab.ii_update = 0
	tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	dw_master.ii_update 							  = 0
	tab_1.tabpage_1.dw_detail.ii_update 	  = 0
	if is_accion = 'new' then is_accion = 'fileopen'
	/*No Genera Asientos */
	ib_estado_asiento = FALSE

	/*setear flag de retencion*/
	SetNull(ls_flag_retencion)
	dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
	
	
	triggerEvent('ue_modify')	
END IF

end event

event ue_update_pre;call super::ue_update_pre;String ls_tipo_doc  ,cod_relacion      , ls_cod_moneda    ,ls_confin     ,ls_cod_relacion ,&
		 ls_origen    ,ls_nro_liquidacion, ls_tipo_doc_cc   ,ls_nro_doc_cc ,ls_tipo_doc_cp  ,&
		 ls_nro_doc_cp,ls_nro_doc			, ls_flag_retencion,ls_expresion  ,ls_mensaje		,&
		 ls_nro_ret	  ,ls_flag_tliq		, ls_cod_usr		 ,ls_flag_estado
Long   ll_ano      ,ll_mes,ll_nro_libro,ll_row_master,ll_inicio,ll_nro_asiento,ll_found,ll_ins_new,&	
		 ll_nro_serie
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_importe,ldc_totsoldeb,ldc_totdoldeb,ldc_totsolhab,ldc_totdolhab
Datetime    ldt_fecha_cntbl


ll_row_master = dw_master.Getrow()


//datos de cabecera
ls_cod_moneda		 = dw_master.object.cod_moneda		  [ll_row_master]
ls_origen		    = dw_master.object.origen			     [ll_row_master]
ls_nro_liquidacion = dw_master.object.nro_liquidacion   [ll_row_master]
ldc_tasa_cambio    = dw_master.object.tasa_cambio	     [ll_row_master]
ll_ano			    = dw_master.object.ano				     [ll_row_master]
ll_mes			    = dw_master.object.mes				     [ll_row_master]
ll_nro_libro	    = dw_master.object.nro_libro		     [ll_row_master]
ll_nro_asiento		 = dw_master.object.nro_asiento 	     [ll_row_master]	
ls_flag_retencion	 = dw_master.object.flag_retencion    [ll_row_master]	
ldt_fecha_cntbl	 = dw_master.object.fecha_liquidacion [ll_row_master]	
ls_cod_usr			 = dw_master.object.cod_usr		     [ll_row_master]	
ls_flag_estado		 = dw_master.object.flag_estado	     [ll_row_master]	

IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF



IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio , Verifique!')
	ib_update_check = False	
	Return
END IF



if is_accion = 'new' then
	//genera nro liquidacion
	IF f_genera_liq_cb (ls_origen,ls_nro_liquidacion)	= FALSE THEN
		ib_update_check = False	
		Return
	END IF

	//
	dw_master.object.nro_liquidacion [ll_row_master] = ls_nro_liquidacion
	
	
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
	IF invo_cntbl_asiento.of_get_nro_asiento(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  = FALSE THEN
		ib_update_check = False	
		Return
	ELSE
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
	END IF	
	
	//cabecera de asiento
	tab_1.tabpage_2.dw_asiento_cab.Object.origen      [1] = ls_origen
	tab_1.tabpage_2.dw_asiento_cab.Object.ano 		  [1] = ll_ano
	tab_1.tabpage_2.dw_asiento_cab.Object.mes 		  [1] = ll_mes
	tab_1.tabpage_2.dw_asiento_cab.Object.nro_libro   [1] = ll_nro_libro
	tab_1.tabpage_2.dw_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento	
	
end if





/*eliminar informacion de tabla temporal*/
DO WHILE ids_crelacion_ext_tbl.Rowcount() > 0
	ids_crelacion_ext_tbl.deleterow(0)
LOOP

IF ls_flag_retencion = '1' THEN /*flag de retencion de cabecera*/

	/*filtrar documentos marcados para la retencion*/
	ls_expresion = "flag_retencion = '1'"
	tab_1.tabpage_1.dw_detail.SetFilter(ls_expresion)
	tab_1.tabpage_1.dw_detail.Filter()

	//**separar los codigos de relacion**//
	FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
		 ls_cod_relacion = tab_1.tabpage_1.dw_detail.object.cxp_cod_rel [ll_inicio]
		 ls_expresion = "cod_relacion = '"+ls_cod_relacion+"'"
		 ll_found = ids_crelacion_ext_tbl.find(ls_expresion,1,ids_crelacion_ext_tbl.Rowcount())
		 
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
		 ll_nro_serie  = dw_master.Getitemnumber(ll_row_master,'nro_serie')
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



//detalle de liquidacion

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
	
	 ls_tipo_doc_cc = tab_1.tabpage_1.dw_detail.object.cxc_tipo_doc [ll_inicio]
	 ls_nro_doc_cc  = tab_1.tabpage_1.dw_detail.object.cxc_nro_doc  [ll_inicio]
	 ls_tipo_doc_cp = tab_1.tabpage_1.dw_detail.object.cxp_tipo_doc [ll_inicio]
	 ls_nro_doc_cp  = tab_1.tabpage_1.dw_detail.object.cxp_nro_doc  [ll_inicio]
	 ls_confin		 = tab_1.tabpage_1.dw_detail.object.confin		 [ll_inicio]
	 

	 IF Isnull(ls_tipo_doc_cc) OR Trim(ls_tipo_doc_cc) = '' THEN
		 ls_tipo_doc = ls_tipo_doc_cp
		 ls_nro_doc	 = ls_nro_doc_cp
	 ELSE
		 ls_tipo_doc = ls_tipo_doc_cc
		 ls_nro_doc	 = ls_nro_doc_cc
	 END IF
	 
	 
	 ldc_importe = tab_1.tabpage_1.dw_detail.object.importe [ll_inicio]
	 
	 IF Isnull(ldc_importe) OR ldc_importe = 0.00 THEN
		 Messagebox('Aviso','Colocar Importe del Documento '+ls_tipo_doc+' '+ls_nro_doc)
		 ib_update_check = False	
		 Return
	 END IF
	 
	 
	 IF Isnull(ls_confin) OR Trim(ls_confin) = '' THEN
		 Messagebox('Aviso','Colocar Concepto Financiero del Documento '+ls_tipo_doc+' '+ls_nro_doc)
		 ib_update_check = False	
		 Return
	 END IF
	 
	 tab_1.tabpage_1.dw_detail.object.nro_liquidacion [ll_inicio] = ls_nro_liquidacion
	 
next



//Detalle de pre asiento
FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount()
	 tab_1.tabpage_2.dw_asiento_det.object.origen   	[ll_inicio] = ls_origen
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



IF dw_master.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 THEN 
	dw_master.ii_update = 1	
	tab_1.tabpage_2.dw_asiento_det.ii_update = 1
	tab_1.tabpage_2.dw_asiento_cab.ii_update = 1
	dw_master.object.obs [1] = dw_master.object.obs [1]
	
END IF


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1                      OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	 tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 ) THEN
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

event ue_insert_pos;call super::ue_insert_pos;IF idw_1 = dw_master THEN
	tab_1.tabpage_2.dw_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;String ls_null       	 ,ls_moneda_cab    ,ls_tipo_doc_cab ,ls_flag_provisionado ,ls_cod_relacion ,ls_tipo_doc_cc,&
		 ls_nro_doc_cc 	 ,ls_tipo_doc_cp   ,ls_nro_doc_cp   ,ls_flag_tabla			 ,ls_tipo_doc		,ls_nro_doc 	,&
		 ls_liq_doc_cobrar ,ls_liq_doc_pagar ,ls_flag_ctrl_reg
Long   ll_inicio		,ll_factor ,ll_count
Decimal {3} ldc_tasa_cambio
str_parametros sl_param

TriggerEvent ('ue_update_request')




sl_param.dw1     = 'd_abc_liquidacion_tbl'
sl_param.titulo  = 'Cartera de Pagos'
sl_param.field_ret_i[1] = 3  //nro liquiacion
sl_param.field_ret_i[2] = 1  //origen
sl_param.field_ret_i[3] = 8  //ano
sl_param.field_ret_i[4] = 9  //mes
sl_param.field_ret_i[5] = 10 //nro libro
sl_param.field_ret_i[6] = 11 //nro asiento


OpenWithParm( w_lista, sl_param)
sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	/*parametros de documentos*/
	select doc_liq_x_cobrar,doc_liq_x_pagar into :ls_liq_doc_cobrar,:ls_liq_doc_pagar from finparam where (reckey = '1') ;
	
	
	dw_master.Retrieve(sl_param.field_ret[1])
	tab_1.tabpage_1.dw_detail.retrieve(sl_param.field_ret[1])
	tab_1.tabpage_2.dw_asiento_cab.retrieve(sl_param.field_ret[2],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	tab_1.tabpage_2.dw_asiento_det.retrieve(sl_param.field_ret[2],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	
	/*asociacion de moneda de cabecera*/
	IF dw_master.rowcount()  > 0 THEN
		SetNull(ls_null)
		ls_moneda_cab   = dw_master.object.cod_moneda  [dw_master.getrow()]
		ldc_tasa_cambio = dw_master.object.tasa_cambio [dw_master.getrow()]
		ls_tipo_doc_cab = dw_master.object.tipo_doc 	  [dw_master.getrow()]
		
		For ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()
			 tab_1.tabpage_1.dw_detail.object.moneda_cab  [ll_inicio] = ls_moneda_cab
			 tab_1.tabpage_1.dw_detail.object.tasa_cambio [ll_inicio] = ldc_tasa_cambio
			 
			 ls_flag_provisionado = tab_1.tabpage_1.dw_detail.object.flag_provisionado [ll_inicio]
			 ls_cod_relacion		 = tab_1.tabpage_1.dw_detail.object.cxp_cod_rel 		[ll_inicio]
			 ls_tipo_doc_cc		 =	tab_1.tabpage_1.dw_detail.object.cxc_tipo_doc 		[ll_inicio]
			 ls_nro_doc_cc			 = tab_1.tabpage_1.dw_detail.object.cxc_nro_doc 		[ll_inicio]
			 ls_tipo_doc_cp		 = tab_1.tabpage_1.dw_detail.object.cxp_tipo_doc 		[ll_inicio]
			 ls_nro_doc_cp			 = tab_1.tabpage_1.dw_detail.object.cxp_nro_doc 		[ll_inicio]
			 ll_factor				 = tab_1.tabpage_1.dw_detail.object.factor_signo 		[ll_inicio]
			 
			 IF Isnull(ls_tipo_doc_cc) OR Trim(ls_tipo_doc_cc) = '' THEN //cntas x pagar
				 ls_flag_tabla = '3'
				 ls_tipo_doc = ls_tipo_doc_cp
				 ls_nro_doc	 = ls_nro_doc_cp
			 ELSEIF Isnull(ls_tipo_doc_cp) OR Trim(ls_tipo_doc_cp) = '' THEN //cntas x cobrar
				 ls_flag_tabla = '1'
				 ls_tipo_doc = ls_tipo_doc_cc
				 ls_nro_doc	 = ls_nro_doc_cc
			 END IF
			 
			 
			 IF ls_tipo_doc_cab = ls_liq_doc_pagar	THEN //LIQUIDACION X PAGAR
			    //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
		       select count(*) into :ll_count from doc_grupo_relacion dg where (dg.grupo = 'C2') and	(dg.tipo_doc = :ls_tipo_doc) ;
				 
			    if (ll_count > 0 AND ls_flag_provisionado = 'D' AND ll_factor = 1 AND ls_flag_tabla = '3') then
		          select cp.flag_control_reg into :ls_flag_ctrl_reg from cntas_pagar cp
	              where (cp.cod_relacion = :ls_cod_relacion) and
   	                 (cp.tipo_doc     = :ls_tipo_doc    ) and
      	              (cp.nro_doc      = :ls_nro_doc     ) ;
			 	 
				    if ls_flag_ctrl_reg = '1' then
					    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = ls_null
				    else
					    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = '1'	
				    end if
			    else
				    tab_1.tabpage_1.dw_detail.object.t_tipdoc [ll_inicio] = '1'	
			    end if				 
				 
			 ELSEIF ls_tipo_doc_cab = ls_liq_doc_cobrar	THEN //LIQUIDACION X COBRAR
				
				 //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
		       select count(*) into :ll_count from doc_grupo_relacion dg where (dg.grupo = 'C1') and	(dg.tipo_doc = :ls_tipo_doc) ;
				 
			    if (ll_count > 0 AND ls_flag_provisionado = 'D' AND ll_factor = 1 AND ls_flag_tabla = '1') then
		          select cc.flag_control_reg into :ls_flag_ctrl_reg from cntas_cobrar cc
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
	
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	ib_estado_asiento = FALSE
END IF	
end event

event ue_delete;Long  ll_row

if idw_1 = dw_master then return
	

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF


ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
	

dw_master.Object.importe_neto [1] =	wf_total_documento ()
dw_master.ii_update = 1

end event

event ue_modify;call super::ue_modify;String ls_flag_estado,ls_origen,ls_result,ls_mensaje,ls_nro_liquidacion
Long   ll_row,ll_count,ll_ano,ll_mes

ll_row = dw_master.getrow()

IF ll_row = 0 THEN RETURN

ls_flag_estado  	 = dw_master.object.flag_estado  	[ll_row]
ls_origen		 	 = dw_master.object.origen       	[ll_row]
ls_nro_liquidacion = dw_master.object.nro_liquidacion [ll_row]
ll_ano 			 	 = dw_master.object.ano 				[ll_row]
ll_mes 			 	 = dw_master.object.mes 				[ll_row]

/*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario



/*Verificación de comprobante de retencion*/
SELECT Count(*) INTO :ll_count FROM retencion_igv_crt 
WHERE ((origen          = :ls_origen		    ) AND
		 (nro_liquidacion = :ls_nro_liquidacion ));

IF ll_count > 0 THEN
//	cb_2.Enabled = FALSE
ELSE
//	cb_2.Enabled = TRUE
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

	
	//MODIFICABLE DETALLE ASIENTOS
	IF tab_1.tabpage_2.dw_asiento_det.ii_protect = 0 THEN
		tab_1.tabpage_2.dw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
		tab_1.tabpage_2.dw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	
	END IF
	
	IF tab_1.tabpage_1.dw_detail.ii_protect = 0 THEN //MODIFICABLE DETALLE DOCUMENTOS
		//bloqueo de campos...
		tab_1.tabpage_1.dw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")				
	END IF

	
	IF is_accion <> 'new' THEN
		dw_master.object.tipo_doc.Protect = 1
		dw_master.object.ano.Protect = 1
		dw_master.object.mes.Protect = 1
		dw_master.object.nro_libro.Protect = 1
	END IF 
	
END IF



end event

event ue_print;call super::ue_print;IF dw_master.rowcount() = 0 then return

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.nro_liquidacion[dw_master.getrow()]

OpenSheetWithParm(w_fi343_liquidacion_caja_frm, lstr_rep, w_main, 2, Layered!)
end event

event ue_anular;call super::ue_anular;Long   ll_row_master,ll_count,ll_inicio,ll_ano,ll_mes
String ls_nro_liquidacion,ls_cod_relacion,ls_tipo_doc,ls_result,&
		 ls_mensaje	

ll_row_master = dw_master.Getrow()


ls_cod_relacion	 = dw_master.object.cod_relacion 	[ll_row_master]
ls_tipo_doc			 = dw_master.object.cod_relacion 	[ll_row_master]
ls_nro_liquidacion = dw_master.object.nro_liquidacion [ll_row_master]
ll_ano				 = dw_master.object.ano					[ll_row_master]
ll_mes				 = dw_master.object.mes 				[ll_row_master]

/*verificar que liquidacion no esta pagada para poder ser anulada*/
IF wf_verifica_liquidacion (ls_cod_relacion,ls_tipo_doc,ls_nro_liquidacion) > 0 THEN
	Messagebox('Aviso','No se puede Anular liquidacion tiene movimiento')
	RETURN
END IF	
		 


/*verificar que mes contable no este cerrado*/		 
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	Return
END IF

/**/



dw_master.object.flag_estado  [ll_row_master] = '0'
dw_master.object.importe_neto [ll_row_master] = 0.00

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

/*No  Generación de Pre Asientos*/
ib_estado_asiento = FALSE
/**/
		 

	
end event

type cb_1 from commandbutton within w_fi343_liquidacion_caja
integer x = 3305
integer y = 28
integer width = 466
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Referencias"
end type

event clicked;Long    ll_row_master,ll_ano,ll_mes
String  ls_cod_moneda ,ls_cod_relacion ,ls_result,ls_mensaje,ls_confin,ls_grupo,&
		  ls_flag_ge    ,ls_tipo_doc	   ,ls_matriz
Decimal {3} ldc_tasa_cambio
str_parametros sl_param

ll_row_master = dw_master.Getrow()

dw_master.Accepttext()
IF ll_row_master = 0 THEN Return


ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master]
ll_ano 			 = dw_master.object.ano 		   [ll_row_master]
ll_mes 			 = dw_master.object.mes 		   [ll_row_master]
ls_confin		 = dw_master.object.confin		   [ll_row_master]
ls_tipo_doc		 = trim(dw_master.object.tipo_doc	   [ll_row_master])
ls_matriz		 = dw_master.object.matriz_cntbl [ll_row_master]

//*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

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

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un Tipo de Documento, Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tipo_doc')
	Return
END IF

/*Verificar si pertenece grupo economico*/
select grupo into :ls_grupo from grupo_proveedor_rel 
 where (proveedor = :ls_cod_relacion) ;



IF Not(Isnull(ls_grupo) OR Trim(ls_grupo) = '') THEN //CODIGO DE RELACION NO 

	select flag_grp_econ into :ls_flag_ge 
	  from grupo_proveedor
	 where (grupo = :ls_grupo) ;
	 


	
	if ls_flag_ge = '1' then //inserta tabla temporal tt_fin_prov_ge
		Insert Into tt_fin_proveedor
		select proveedor from grupo_proveedor_rel where (grupo = :ls_grupo );	
		
	else
		Insert Into tt_fin_proveedor						//PERTENCE A NINGUN GRUPO
		(cod_proveedor)
		Values
		(:ls_cod_relacion)		;
	end if
	 
	 
	
ELSE															//VERIFICACION DE GRUPO ECONOMICO
		Insert Into tt_fin_proveedor						//PERTENCE A NINGUN GRUPO
	(cod_proveedor)
	Values
	(:ls_cod_relacion);

END IF


sl_param.dw1		= 'd_doc_pendientes_x_temp_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor o Grupo Economico'
sl_param.string2	= ls_cod_moneda
sl_param.string3	= ls_confin
sl_param.string4	= ls_tipo_doc
sl_param.string5	= ls_matriz
sl_param.db2		= ldc_tasa_cambio
sl_param.opcion   = 16  //liquidacion de caja
sl_param.db1 		= 1600
sl_param.dw_m		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_master.Object.importe_neto [1] = wf_total_documento ()
	dw_master.ii_update = 1
	tab_1.tabpage_1.dw_detail.ii_update = 1
END IF

end event

type tab_1 from tab within w_fi343_liquidacion_caja
integer x = 14
integer y = 788
integer width = 3794
integer height = 1152
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
integer y = 104
integer width = 3758
integer height = 1032
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
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
integer x = 9
integer y = 32
integer width = 3730
integer height = 980
integer taborder = 20
string dataobject = "d_abc_ap_liquidacion_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_items();Long   ll_row_master

ll_row_master = dw_master.getrow()

f_verificacion_items_x_retencion_lqc (dw_master,tab_1.tabpage_1.dw_detail)

dw_master.object.importe_neto [ll_row_master] = wf_total_documento ()
dw_master.ii_update= 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                      	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event itemchanged;call super::itemchanged;String  ls_accion      ,ls_cod_relacion ,ls_tipo_doc_cc ,ls_nro_doc_cc      ,&
		  ls_tipo_doc_cp ,ls_nro_doc_cp   ,ls_flag_tabla  ,ls_nro_liquidacion ,&
		  ls_tipo_doc	  ,ls_nro_doc      ,ls_flag		  ,ls_soles				 ,&
		  ls_dolares	  ,ls_cod_moneda	 ,ls_null		  ,ls_matriz_cntbl
Long 	  ll_item
Decimal {2} ldc_importe,ldc_porc_ret_igv,ldc_imp_retencion
Decimal {3} ldc_tasa_cambio
dwItemStatus ldis_status

Accepttext()


ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS


choose case dwo.name
		 case 'confin'
				select matriz_cntbl into :ls_matriz_cntbl from concepto_financiero where confin = :data ;
				
				IF Isnull(ls_matriz_cntbl) or Trim(ls_matriz_cntbl) = '' THEN
					Messagebox('Aviso','Concepto Financiero No tiene Matriz Contable ,Verifique!')
					This.object.confin 		 [row] = ls_null
					This.object.matriz_cntbl [row] = ls_null
					Return 1
				ELSE
					This.object.matriz_cntbl [row] = ls_matriz_cntbl
				END IF
				
				dw_master.Object.importe_neto [1] =	wf_total_documento ()
				dw_master.ii_update = 1
				
		 case 'importe'
			   ldis_status = this.GetItemStatus(row,0,Primary!)				

				IF ldis_status = NewModified! THEN
					ls_accion = 'new'
				ELSE	
					ls_accion = 'fileopen'					
				END IF
				
				ls_cod_relacion    = this.object.cxp_cod_rel     [row]
				ls_nro_liquidacion = this.object.nro_liquidacion [row]
				ls_tipo_doc_cc     = this.object.cxc_tipo_doc    [row]
				ls_nro_doc_cc      = this.object.cxc_nro_doc     [row]
				ls_tipo_doc_cp     = this.object.cxp_tipo_doc    [row]
				ls_nro_doc_cp	    = this.object.cxp_nro_doc     [row]
				ll_item			    = this.object.item			    [row]
				ldc_importe		    = this.object.importe		    [row]
				
				
				
				IF Isnull(ls_tipo_doc_cc) OR Trim(ls_tipo_doc_cc) = '' THEN
					ls_flag_tabla = '3' //POR PAGAR
					ls_tipo_doc = ls_tipo_doc_cp
					ls_nro_doc  = ls_nro_doc_cp
				ELSE
					ls_flag_tabla = '1' //POR COBRAR
					ls_tipo_doc = ls_tipo_doc_cc
					ls_nro_doc  = ls_nro_doc_cc					
				END IF
				
				
				wf_verifica_monto_doc(ls_cod_relacion ,ls_nro_liquidacion ,ll_item   ,ls_tipo_doc,ls_nro_doc,&
											 ldc_importe     ,ls_flag_tabla      ,ls_accion ,ls_flag )
											 
											 
				IF Trim(ls_flag) = '1' THEN //exceso de pago
					Messagebox('Aviso','Se esta excediendo en el monto del documento')
					This.object.importe [row] = 0.00
					Return 1
				END IF
				
				
				dw_master.Object.importe_neto [1] =	wf_total_documento ()
				dw_master.ii_update = 1
				
		 case 'importe_retenido'
			
				dw_master.Object.importe_neto [1] =	wf_total_documento ()
				dw_master.ii_update = 1
				
		 case 'flag_retencion'
				IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
					/*porcentaje de retencion igv*/
					SELECT porc_ret_igv INTO :ldc_porc_ret_igv FROM finparam WHERE reckey = '1' ;
					/**/
				
					f_monedas(ls_soles,ls_dolares)
					
		 			ldc_importe     = This.object.importe     [row] 		
			 		ls_cod_moneda   = This.object.cod_moneda  [row] 					
				   ldc_tasa_cambio = This.object.tasa_cambio [row] 					
					
					IF ls_cod_moneda <> ls_soles THEN 
				 	 	ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
		    	 	END IF
				  
		 			ldc_imp_retencion = Round((ldc_importe * ldc_porc_ret_igv)/ 100,2)
					 
				 	This.object.importe_retenido [row] = ldc_imp_retencion					
					 
				ELSE /*INICIALIZAR IMPORTE DE RETENCION*/
					This.object.importe_retenido [row] = 0.00
				END IF
				
				

				PostEvent('ue_items')

			
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar
str_parametros   sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if




CHOOSE CASE dwo.name
		 CASE	'confin'	
				
				lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN       AS CODIGO_CONFIN      ,'&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION  AS DESCRIPCION_CONFIN ,'&
														 +'CONCEPTO_FINANCIERO.MATRIZ_CNTBL AS MATRIZ_CNTBL		  '&
			      									 +'FROM CONCEPTO_FINANCIERO '&
														 

														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'confin'      ,lstr_seleccionar.param1[1])
					Setitem(row,'matriz_cntbl',lstr_seleccionar.param3[1])
				   ii_update = 1
					ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
			   END IF	
				
END CHOOSE


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3758
integer height = 1032
long backcolor = 79741120
string text = "Asientos "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
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
integer x = 9
integer y = 32
integer width = 3730
integer height = 980
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_bak"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()

ib_estado_asiento = FALSE //NO generacion de asientos AUTOMATICOS



end event

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

type dw_asiento_cab from u_dw_abc within tabpage_2
boolean visible = false
integer x = 9
integer y = 32
integer width = 3730
integer height = 396
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                   	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


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

event ue_insert_pre;call super::ue_insert_pre;This.Object.flag_tabla [al_row] = 'L' //LIQUIDACION DE CAJA
end event

type dw_master from u_dw_abc within w_fi343_liquidacion_caja
integer x = 14
integer y = 28
integer width = 3109
integer height = 712
string dataobject = "d_abc_ap_liquidacion"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle


idw_mst  = dw_master
idw_det  = tab_1.tabpage_1.dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;

DateTime ldt_now

ldt_now = gnvo_app.of_Fecha_actual()

this.object.origen      	   [al_row] = gs_origen
this.object.cod_usr 	   	   [al_row] = gs_user
this.object.fecha_registro    [al_row] = ldt_now
this.object.fecha_liquidacion [al_row] = Date(ldt_now)
this.object.tasa_cambio			[al_row] = gnvo_app.of_tasa_cambio  ()
this.object.ano	  	   		[al_row] = Long(String(ldt_now,'YYYY'))
this.object.mes 		   		[al_row] = Long(String(ldt_now,'MM'))
this.object.flag_estado			[al_row] = '1'


end event

event itemchanged;call super::itemchanged;Long   ll_count,ll_null
String ls_nom_prov,ls_null,ls_cod_moneda,ls_matriz
Date   ld_fecha_liq
Decimal {3} ldc_tasa_cambio


Accepttext()

ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS

SetNull(ls_null)

choose case dwo.name
		 case	'nro_serie'
				select count(*) into :ll_count
				  from doc_tipo_usuario
				 where (tipo_doc  = :is_doc_cri ) and
						 (cod_usr	= :gs_user    ) ;
						 
				IF ll_count = 0 THEN
					SetNull(ll_null)
					This.object.nro_serie [row] = ll_null
					Messagebox('Aviso','Verifique Nro de Serie Por Usuario ')
					Return 1
				END IF

		 case 'tipo_doc'
				select count(*) into :ll_count from vw_fin_liquidacion_ctacte
				 where (tipo_doc = :data) ;
				 
				if ll_count = 0 then
					SetNull(ls_null)
					This.object.tipo_doc [row] = ls_null					
					Messagebox('Aviso','Tipo de Documento No Existe')
					return 1
				end if
				
				this.object.nro_libro [row] = f_nro_libro (data)
				
		 case 'cod_relacion'
				select nom_proveedor into :ls_nom_prov from proveedor p
				 where (p.proveedor = :data ) ;
				 
				 
				if Isnull(ls_nom_prov) or Trim(ls_nom_prov) = '' then

					this.object.cod_relacion  [row] = ls_null
					this.object.nom_proveedor [row] = ls_null
					Messagebox('Aviso','Codigo no existe, Verifique!')
					Return 1
				else
					this.object.nom_proveedor [row] = ls_nom_prov
				end if
				
		 case 'confin'		
				select count(*) into :ll_count from concepto_financiero
				 where (confin = :data) ;
				 
				if ll_count = 0 then
					Messagebox('Aviso','Concepto Financiero No Existe')
					This.object.confin [row] = ls_null
					Return 1
				else
					select matriz_cntbl into :ls_matriz from concepto_financiero  where confin = :data ;
					
					This.object.matriz_cntbl [row] = ls_matriz
				end if
				
		 case 'cod_moneda'	 			
				select count(*) into :ll_count from moneda where (cod_moneda = :data) ;
				
				if ll_count = 0 then
					This.object.cod_moneda [row] = ls_null					
					Messagebox('Aviso','Moneda No Existe , Verifica!')
					Return 1
				else
					ldc_tasa_cambio = This.object.tasa_cambio [row]
					
					wf_actualiza_datos_detalle (data,ldc_tasa_cambio)
					
					//actualiza total de documento
					dw_master.Object.importe_neto [1] =	wf_total_documento ()
					dw_master.ii_update = 1
					
				end if	
		CASE	'tasa_cambio'	
				ls_cod_moneda   = This.object.cod_moneda  [row]
				ldc_tasa_cambio = This.object.tasa_cambio [row]
					
				wf_actualiza_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
					
				//actualiza total de documento
				dw_master.Object.importe_neto [1] =	wf_total_documento ()
				dw_master.ii_update = 1
				
		CASE	'fecha_liquidacion'
				ld_fecha_liq = date(this.object.fecha_liquidacion[row])

				
				This.object.mes [row] = Long(String(ld_fecha_liq,'MM'))					
				This.object.ano [row] = Long(String(ld_fecha_liq,'YYYY'))					
				
				//busca tipo de cambio
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_liq)
				
				ls_cod_moneda   = This.object.cod_moneda  [row]	
				ldc_tasa_cambio = This.object.tasa_cambio [row]
				
				// Actualiza Tipo de Moneda y Tasa Cambio
				wf_actualiza_datos_detalle (ls_cod_moneda,ldc_tasa_cambio)
				This.Object.importe_neto [row] =	wf_total_documento ()		
				dw_master.ii_update = 1
				
end choose

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar
str_parametros   sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if




CHOOSE CASE dwo.name
		 CASE 'nro_serie'
				lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC  AS TIPO_DOC ,'&
						 								 +'DOC_TIPO_USUARIO.NRO_SERIE AS NRO_SERIE,'&
						 								 +'DOC_TIPO_USUARIO.COD_USR   AS USUARIO   '&
				  										 +'FROM DOC_TIPO_USUARIO '&
				 										 +'WHERE DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+is_doc_cri+"' AND "&
														  		 +'DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user	  +"'"		

			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'nro_serie',lstr_seleccionar.paramdc2[1])
					ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
				   ii_update = 1
			   END IF	
				
		 CASE 'tipo_doc'
			   lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT VW_FIN_LIQUIDACION_CTACTE.TIPO_DOC      AS CODIGO_DOC ,'&
			   										 +'VW_FIN_LIQUIDACION_CTACTE.DESC_TIPO_DOC AS DESCRIPCION,'&
														 +'VW_FIN_LIQUIDACION_CTACTE.FACTOR		  AS FACTOR		  '&
			      									 +'FROM VW_FIN_LIQUIDACION_CTACTE  '  
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
					ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
				   ii_update = 1
			   END IF	
		 												
		 CASE 'cod_relacion'
				
				lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_RELACION,'&
														 +'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION    ,'&
														 +'PROVEEDOR.RUC				AS RUC_PROVEEDOR   '&
			      									 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"
														 

														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
				   ii_update = 1
			   END IF	
				
		 CASE 'cod_moneda'
				
				lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA  AS CODIGO_MONEDA,'&
														 +'MONEDA.DESCRIPCION AS DESCRIPCION_MONEDA   '&
			      									 +'FROM MONEDA '&
														 

														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'cod_moneda',lstr_seleccionar.param1[1])
					ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
				   ii_update = 1
			   END IF	
				
		 CASE	'confin'	
				
				lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN       AS CODIGO_CONFIN      ,'&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION  AS DESCRIPCION_CONFIN ,'&
														 +'CONCEPTO_FINANCIERO.MATRIZ_CNTBL AS MATRIZ_CNTBL		  '&
			      									 +'FROM CONCEPTO_FINANCIERO '&
														 

														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'confin',lstr_seleccionar.param1[1])
					Setitem(row,'matriz_cntbl',lstr_seleccionar.param3[1])
					ib_estado_asiento = TRUE //GENERACION DE ASIENTOS AUTOMATICOS
				   ii_update = 1
			   END IF	
				
END CHOOSE



end event

event itemerror;call super::itemerror;RETURN 1
end event

