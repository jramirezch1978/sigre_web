$PBExportHeader$w_ve314_planilla_cobranza.srw
forward
global type w_ve314_planilla_cobranza from w_abc
end type
type dw_cheque from u_dw_abc within w_ve314_planilla_cobranza
end type
type cb_1 from commandbutton within w_ve314_planilla_cobranza
end type
type dw_detail_det from u_dw_abc within w_ve314_planilla_cobranza
end type
type dw_detail from u_dw_abc within w_ve314_planilla_cobranza
end type
type dw_master from u_dw_abc within w_ve314_planilla_cobranza
end type
end forward

global type w_ve314_planilla_cobranza from w_abc
integer width = 3593
integer height = 2008
string title = "Planilla de Cobranza (VE314)"
string menuname = "m_mantenimiento_cl_anular_not_print"
event ue_anular ( )
dw_cheque dw_cheque
cb_1 cb_1
dw_detail_det dw_detail_det
dw_detail dw_detail
dw_master dw_master
end type
global w_ve314_planilla_cobranza w_ve314_planilla_cobranza

type variables
String is_accion,is_soles,is_dolares
DataStore ids_caja_bancos       ,ids_caja_bancos_det  ,ids_detraccion  ,ids_cntbl_asiento   ,&
			 ids_cntbl_asiento_det ,ids_asiento_adic	   ,ids_doc_pend_tbl,ids_matriz_cntbl_det,&
			 ids_glosa				  ,ids_crelacion_ext_tbl
end variables

forward prototypes
public function decimal wf_recalculo_monto ()
public function boolean wf_gen_planilla_cob (string as_origen, ref string as_nro_liquidacion)
public subroutine wf_insert_detraccion (string as_nro_detrac, string as_nro_deposito, date adt_fecha_deposito, string as_origen, long al_nro_registro)
public subroutine wf_insert_cbdetalle (string as_origen, long al_nro_registro, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flab_tabor, string as_confin, decimal adc_importe, long al_factor, string as_matriz_cntbl, string as_cod_moneda, string as_flag_provisionado)
public subroutine wf_insert_caja_bancos (string as_origen, long al_nro_registro, string as_flag_pago, string as_moneda, string as_cod_relacion, decimal adc_imp_total, string as_ctabco, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_obs, string as_tipo_doc, string as_nro_doc, string as_cta_ctbl, string as_descripcion, date adt_fecha_actual, string as_confin)
public function boolean wf_detalle_doc (string as_origen, long al_ano, long al_mes, string as_flag_pago, decimal adc_tasa_cambio, date adt_finicio, string as_doc_dep, string as_nro_dep, string as_cnta_ctbl_bco, string as_cta_bco, string as_moneda_bco, string as_desc_ctabco, decimal adc_imp_total, string as_cod_relacion)
end prototypes

event ue_anular();String ls_flag_estado

TriggerEvent('ue_update_request')

if ib_update_check = false then return

ls_flag_estado = dw_master.object.flag_estado [dw_master.Getrow()]



if ls_flag_estado <> '1' then
	Messagebox('Aviso','Verifique estado de la Planilla de COBRANZAS ,ya no se puede Anular')
	return
end if



dw_master.object.flag_estado [dw_master.Getrow()] = '0' //anulado
dw_master.ii_update = 1



end event

public function decimal wf_recalculo_monto ();Long   ll_inicio,ll_factor,ll_factor_det
String ls_moneda_det,ls_flag_detrac,ls_cod_moneda
Decimal {2} ldc_importe_det,ldc_imp_detrac,ldc_imp_soles,ldc_imp_dolares,ldc_importe_det_sol,ldc_importe_det_Dol,&
				ldc_imp_total
Decimal {4} ldc_tasa_cambio


/*inicializacion*/
ldc_imp_soles   = 0.00
ldc_imp_dolares = 0.00

/*tasa de cambio del deposito*/
ldc_tasa_cambio = dw_detail.object.tasa_cambio [dw_detail.getrow()]
ls_cod_moneda	 = dw_detail.object.cod_moneda  [dw_detail.getrow()]

//recalculo monto detalle
for ll_inicio = 1 to dw_detail_det.Rowcount()
	 /*INICIALIZACION*/
	 ldc_importe_det_sol = 0.00
	 ldc_importe_det_dol = 0.00
	 
	 
	 
	 ls_moneda_det   = dw_detail_det.object.moneda			  [ll_inicio]
	 ldc_importe_det = dw_detail_det.object.importe			  [ll_inicio]
	 ls_flag_detrac  = dw_detail_det.object.flag_detraccion [ll_inicio]	 
	 ll_factor		  = dw_detail_det.object.factor			  [ll_inicio]	 
	 ldc_imp_detrac  = dw_detail_det.object.importe_ret_det [ll_inicio]	 
	 
	 //**factor detraccion**//
	 IF ll_factor = 1 THEN
		 ll_factor_det = -1
	 ELSE
		 ll_factor_det = 1
	 END IF
	 //** **//
	 
	 
	 IF ls_moneda_det = is_soles THEN
		 ldc_imp_soles   = ldc_imp_soles   + (ldc_importe_det * ll_factor)
		 ldc_imp_dolares = ldc_imp_dolares + (Round(ldc_importe_det / ldc_tasa_cambio ,2) * ll_factor)
		 
		 if ls_flag_detrac = '1' then
			 ldc_importe_det_sol = Round(ldc_imp_detrac ,2) * ll_factor_det
			 ldc_importe_det_dol = Round(ldc_imp_detrac / ldc_tasa_cambio,2) * ll_factor_det 
			 
			 
			 
		 end if
		 
	 ELSEIF ls_moneda_det = is_dolares THEN
		 ldc_imp_soles   = ldc_imp_soles   + (Round(ldc_importe_det * ldc_tasa_cambio ,2) * ll_factor) 
		 ldc_imp_dolares = ldc_imp_dolares + (ldc_importe_det * ll_factor)

		 if ls_flag_detrac = '1' then
			 ldc_importe_det_sol = Round(ldc_imp_detrac * ldc_tasa_cambio,2) * ll_factor_det
			 ldc_importe_det_dol = Round(ldc_imp_detrac ,2) * ll_factor_det
		 end if
		 
	 END IF
	 
	 IF Isnull(ldc_importe_det_sol) THEN ldc_importe_det_sol = 0.00
	 IF Isnull(ldc_importe_det_dol) THEN ldc_importe_det_dol = 0.00
	 
	 if ls_flag_detrac = '1' then //detraccion
		
		 IF ldc_importe_det_sol <> 0 OR ldc_importe_det_dol <> 0 THEN
			 ldc_imp_soles   = ldc_imp_soles   + ldc_importe_det_sol
			 ldc_imp_dolares = ldc_imp_dolares + ldc_importe_det_dol
		 END IF	 
		 
	 end if	 
	 


next


IF ls_cod_moneda = is_soles THEN
	ldc_imp_total = ldc_imp_soles  
ELSE
	ldc_imp_total = ldc_imp_dolares
END IF

Return ldc_imp_total
end function

public function boolean wf_gen_planilla_cob (string as_origen, ref string as_nro_liquidacion);Boolean lb_retorno = TRUE
Long 	  ll_nro_reg
String  ls_lock_table,ls_msj_err

ls_lock_table = 'LOCK TABLE NUM_PLN_COBRANZA IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT ult_nro INTO :ll_nro_reg FROM num_pln_cobranza WHERE (origen = :as_origen ) ;

	
IF Isnull(ll_nro_reg) OR ll_nro_reg = 0 THEN
	Messagebox('Aviso','Debe Verificar Tabla de Numeración NUM_PLN_COBRANZA , Comuniquese con Sistemas!')
	lb_retorno = FALSE
	GOTO SALIDA
END IF

//*******************************//
//Actualiza Tabla num_caja_bancos//
//*******************************//

UPDATE num_pln_cobranza
   SET ult_nro = :ll_nro_reg + 1
 WHERE (origen = :as_origen ) ;
	

	
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox("SQL error",ls_msj_err)
	lb_retorno = FALSE
	GOTO SALIDA
END IF	


/*genera liquidacion*/
as_nro_liquidacion = gs_origen+f_llena_caracteres('0',Trim(String(ll_nro_reg)),8) 

SALIDA:

RETURN lb_retorno	


end function

public subroutine wf_insert_detraccion (string as_nro_detrac, string as_nro_deposito, date adt_fecha_deposito, string as_origen, long al_nro_registro);Long ll_row 

ll_row = ids_detraccion.InsertRow(0)

ids_detraccion.object.nro_detraccion 	 [ll_row] = as_nro_detrac
ids_detraccion.object.nro_deposito	 	 [ll_row] = as_nro_deposito
ids_detraccion.object.fecha_deposito 	 [ll_row] = adt_fecha_deposito
ids_detraccion.object.org_caja_banc	 	 [ll_row] = as_origen
ids_detraccion.object.nro_reg_caja_banc [ll_row] = al_nro_registro

end subroutine

public subroutine wf_insert_cbdetalle (string as_origen, long al_nro_registro, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flab_tabor, string as_confin, decimal adc_importe, long al_factor, string as_matriz_cntbl, string as_cod_moneda, string as_flag_provisionado);Long   ll_row_ins,ll_item,ll_rowcount
String ls_origen_doc

IF as_flab_tabor = '1' THEN
	select origen into :ls_origen_doc from cntas_cobrar where (tipo_doc = :as_tipo_doc) and
																				 (nro_doc  = :as_nro_doc ) ;	
ELSE
	select origen into :ls_origen_doc from cntas_pagar where (cod_relacion = :as_cod_relacion ) and
																				(tipo_doc 	  = :as_tipo_doc		) and
																				(nro_doc  	  = :as_nro_doc 		) ;	
END IF																				

ll_row_ins  = ids_caja_bancos_det.Insertrow(0)

/*INSERT PRE*/
ll_rowcount = ids_caja_bancos_det.RowCount()

IF ll_rowcount = 1 THEN 
	 ll_item = 0
ELSE
 	 ll_item = ids_caja_bancos_det.Getitemnumber(ll_rowcount - 1,"item")
END IF

ll_item = ll_item + 1 



ids_caja_bancos_det.object.origen 		      [ll_row_ins] = as_origen
ids_caja_bancos_det.object.nro_registro      [ll_row_ins] = al_nro_registro
ids_caja_bancos_det.object.item			      [ll_row_ins] = ll_item
ids_caja_bancos_det.object.cod_relacion      [ll_row_ins] = as_cod_relacion
ids_caja_bancos_det.object.tipo_doc		      [ll_row_ins] = as_tipo_doc
ids_caja_bancos_det.object.nro_doc		      [ll_row_ins] = as_nro_doc
ids_caja_bancos_det.object.flab_tabor	      [ll_row_ins] = as_flab_tabor
ids_caja_bancos_det.object.confin		      [ll_row_ins] = as_confin
ids_caja_bancos_det.object.origen_doc	      [ll_row_ins] = ls_origen_doc
ids_caja_bancos_det.object.importe           [ll_row_ins] = adc_importe
ids_caja_bancos_det.object.flag_ret_igv      [ll_row_ins] = '0'
ids_caja_bancos_det.object.flag_provisionado [ll_row_ins] = as_flag_provisionado
ids_caja_bancos_det.object.factor    	 	   [ll_row_ins] = al_factor
ids_caja_bancos_det.object.flag_replicacion  [ll_row_ins] = '1'
ids_caja_bancos_det.object.flag_flujo_caja   [ll_row_ins] = '1'
ids_caja_bancos_det.object.matriz_cntbl	   [ll_row_ins] = as_matriz_cntbl
ids_caja_bancos_det.object.cod_moneda		   [ll_row_ins] = as_cod_moneda



end subroutine

public subroutine wf_insert_caja_bancos (string as_origen, long al_nro_registro, string as_flag_pago, string as_moneda, string as_cod_relacion, decimal adc_imp_total, string as_ctabco, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_obs, string as_tipo_doc, string as_nro_doc, string as_cta_ctbl, string as_descripcion, date adt_fecha_actual, string as_confin);Long ll_row_ins

ll_row_ins = ids_caja_bancos.InsertRow(0)

ids_caja_bancos.object.origen        	  [ll_row_ins] = as_origen
ids_caja_bancos.object.nro_registro  	  [ll_row_ins] = al_nro_registro
ids_caja_bancos.object.flag_estado   	  [ll_row_ins] = '1'
ids_caja_bancos.object.fecha_emision 	  [ll_row_ins] = adt_fecha_actual
ids_caja_bancos.object.flag_pago		 	  [ll_row_ins] = as_flag_pago
ids_caja_bancos.object.cod_moneda	 	  [ll_row_ins] = as_moneda 
ids_caja_bancos.object.cod_relacion  	  [ll_row_ins] = as_cod_relacion
ids_caja_bancos.object.cod_usr		 	  [ll_row_ins] = gs_user
ids_caja_bancos.object.imp_total		 	  [ll_row_ins] = adc_imp_total
ids_caja_bancos.object.cod_ctabco	 	  [ll_row_ins] = as_ctabco
ids_caja_bancos.object.cnta_ctbl  	 	  [ll_row_ins] = as_cta_ctbl
ids_caja_bancos.object.descripcion 	 	  [ll_row_ins] = as_descripcion
ids_caja_bancos.object.ano				 	  [ll_row_ins] = al_ano
ids_caja_bancos.object.mes				 	  [ll_row_ins] = al_mes
ids_caja_bancos.object.nro_libro		 	  [ll_row_ins] = al_nro_libro
ids_caja_bancos.object.nro_asiento	 	  [ll_row_ins] = al_nro_asiento
ids_caja_bancos.object.flag_tiptran	 	  [ll_row_ins] = '3'
ids_caja_bancos.object.obs					  [ll_row_ins] = as_obs
ids_caja_bancos.object.tipo_doc		 	  [ll_row_ins] = as_tipo_doc
ids_caja_bancos.object.nro_doc		 	  [ll_row_ins] = as_nro_doc
ids_caja_bancos.object.flag_conciliacion [ll_row_ins] = '1'
ids_caja_bancos.object.tasa_cambio       [ll_row_ins] = gnvo_app.of_tasa_cambio_vta(adt_fecha_actual)
ids_caja_bancos.object.flag_replicacion  [ll_row_ins] = '1'
ids_caja_bancos.object.flag_retencion    [ll_row_ins] = '1'
ids_caja_bancos.object.confin			     [ll_row_ins] = as_confin

end subroutine

public function boolean wf_detalle_doc (string as_origen, long al_ano, long al_mes, string as_flag_pago, decimal adc_tasa_cambio, date adt_finicio, string as_doc_dep, string as_nro_dep, string as_cnta_ctbl_bco, string as_cta_bco, string as_moneda_bco, string as_desc_ctabco, decimal adc_imp_total, string as_cod_relacion);return true
end function

on w_ve314_planilla_cobranza.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_not_print" then this.MenuID = create m_mantenimiento_cl_anular_not_print
this.dw_cheque=create dw_cheque
this.cb_1=create cb_1
this.dw_detail_det=create dw_detail_det
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cheque
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_detail_det
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_master
end on

on w_ve314_planilla_cobranza.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cheque)
destroy(this.cb_1)
destroy(this.dw_detail_det)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_detail_det.SetTransObject(sqlca)
dw_cheque.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado


of_position_window(0,0)       			// Posicionar la ventana en forma fija


//--parametros
select cod_soles,cod_dolares into :is_soles,:is_dolares from logparam where reckey = '1' ;




end event

event resize;call super::resize;dw_detail_det.height = newheight - dw_detail_det.y - 100
dw_detail_det.width  = newwidth  - dw_detail_det.x - 10

end event

event ue_insert;call super::ue_insert;Long   ll_row
String ls_flag_estado

IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
ELSEIF idw_1 = dw_detail_det THEN
	Return
END IF


IF idw_1 = dw_master THEN
	TriggerEvent('ue_update_request')
	IF ib_update_check = FALSE THEN RETURN
	
	is_accion = 'new'
	dw_detail.Reset()
	dw_detail_det.Reset()
	dw_cheque.Reset()
ELSEIF idw_1 = dw_detail  OR idw_1 = dw_cheque THEN
	
	ls_flag_estado = dw_master.object.flag_estado [dw_master.getrow()]
	
	IF ls_flag_estado <> '1' THEN
		Messagebox('Aviso','Planilla de Cobranza se encuentra aprobada ,Verifique!')
		Return
	END IF
	
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_delete;//override
Long   ll_row,ll_row_master
String ls_flag_estado

IF idw_1 = dw_master THEN
	Return
END IF

//verirficar estado de documentos
ll_row_master = dw_master.Getrow()

ls_flag_estado = dw_master.object.flag_estado [ll_row_master] 

IF ls_flag_estado <> '1' THEN
	Messagebox('Aviso','Planilla de Cobranza ya ha sido aprobada ,Verifique!')
	RETURN
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;IF idw_1 = dw_detail_det THEN
	dw_detail.object.imp_total [dw_detail.getrow()] =	wf_recalculo_monto ()
	dw_detail.ii_update = 1
END IF


end event

event ue_update_pre;call super::ue_update_pre;String ls_origen,ls_nro_plan
Long   ll_row_master,ll_inicio

/*Datos de Cabecera*/
ll_row_master = dw_master.getrow()

ls_origen 	= dw_master.object.cod_origen   [ll_row_master]
ls_nro_plan = dw_master.object.nro_planilla [ll_row_master]

//GENERAR NRO PLANILLA
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing( dw_detail, "form") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing( dw_detail_det, "form") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF


IF is_accion = 'new' THEN
	
	IF wf_gen_planilla_cob(ls_origen,ls_nro_plan) = FALSE THEN
		ib_update_check = FALSE
		RETURN
	END IF
	
	/*asinacion de nro de planilla*/
	dw_master.object.nro_planilla [ll_row_master] = ls_nro_plan

END IF


/*Asignacion de nro de planilla a deposito*/
For ll_inicio = 1 to dw_detail.Rowcount()
	 dw_detail.object.nro_planilla [ll_inicio] = ls_nro_plan

Next

/*Asignacion de nro de planilla a cheque*/
For ll_inicio = 1 to dw_cheque.Rowcount()
	 dw_cheque.object.nro_planilla [ll_inicio] = ls_nro_plan

Next
/*Asiganacion de nro de planilla a documentos*/
For ll_inicio = 1 to dw_detail_det.Rowcount()
	 dw_detail_det.object.nro_planilla [ll_inicio] = ls_nro_plan

Next

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()
dw_detail_det.AcceptText()
dw_cheque.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	ROLLBACK ;
	RETURN
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
      Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
      Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_cheque.ii_update = 1 THEN
	IF dw_cheque.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
      Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF dw_detail_det.ii_update = 1 THEN
	IF dw_detail_det.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
      Rollback ;
		messagebox("Error en Grabacion Detalle Documento","Se ha procedido al rollback",exclamation!)
	END IF
END IF



IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_detail_det.ii_update = 0
	dw_cheque.ii_update = 0
	is_accion = 'fileopen'
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_detail_det.ii_update = 1 or dw_cheque.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_detail_det.ii_update = 0
		dw_cheque.ii_update = 0
	END IF
END IF

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_pln_cobranza_tbl'
sl_param.titulo = 'Planilla de Cobranza'
sl_param.field_ret_i[1] = 1  //origen
sl_param.field_ret_i[2] = 2  //nro planilla




OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	
	dw_master.retrieve(sl_param.field_ret[2])
   dw_detail.retrieve(sl_param.field_ret[2])
	dw_detail_det.reset()
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	
END IF
end event

event ue_modify;call super::ue_modify;Long    ll_row
Integer li_protect
String  ls_flag_estado


ll_row = dw_master.Getrow()
dw_master.accepttext()

IF ll_row = 0 THEN RETURN


ls_flag_estado = dw_master.object.flag_estado [ll_row]


dw_master.of_protect()
dw_detail.of_protect()
dw_detail_det.of_protect()
dw_cheque.of_protect()
	

IF ls_flag_estado <> '1'  THEN
	dw_master.ii_protect = 0
   dw_detail.ii_protect = 0
   dw_detail_det.ii_protect = 0
	dw_cheque.ii_protect = 0
ELSE
	li_protect = dw_detail.ii_protect
	
	IF li_protect = 0 THEN
		dw_detail.Modify("cod_relacion.Protect  ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("cod_ctabco.Protect ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("obs.Protect        ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("flag_pago.Protect  ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("tasa_cambio.Protect  ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("confin.Protect  ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("fecha_deposito.Protect  ='1~tIf(IsNull(flag_null),0,1)'")			
		dw_detail.Modify("doc_deposito.Protect    ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail.Modify("nro_deposito.Protect    ='1~tIf(IsNull(flag_null),0,1)'")	
		
	END IF 
	
	//bloqueo de detalle de documento
	li_protect = dw_detail_det.ii_protect
	
	IF li_protect = 0 THEN
		dw_detail_det.Modify("importe.Protect         ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail_det.Modify("flag_detraccion.Protect ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail_det.Modify("factor_ret_det.Protect  ='1~tIf(IsNull(flag_null),0,1)'")		
		dw_detail_det.Modify("importe_ret_det.Protect ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail_det.Modify("nro_deposito.Protect    ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail_det.Modify("fecha_deposito.Protect  ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_detail_det.Modify("confin.Protect          ='1~tIf(IsNull(flag_null),0,1)'")	
	END IF
	
	li_protect = dw_cheque.ii_protect
	IF li_protect = 0 THEN
		dw_cheque.Modify("cod_banco.Protect   ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_cheque.Modify("cnta_banco.Protect  ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_cheque.Modify("nro_chq.Protect     ='1~tIf(IsNull(flag_null),0,1)'")	
		dw_cheque.Modify("importe.Protect     ='1~tIf(IsNull(flag_null),0,1)'")			
	END IF
	
	
END IF

end event

event ue_print;call super::ue_print;String  ls_nro_planilla
Str_cns_pop lstr_cns_pop


dw_master.Accepttext()

//Verificacion de Nro de Orden
ls_nro_planilla = dw_master.GetItemString(1,'nro_planilla')


lstr_cns_pop.arg[1] = ls_nro_planilla

//tipo de ot
OpenSheetWithParm(w_ve734_rpt_pln_cobranza, lstr_cns_pop, this, 2, Layered!)
	


end event

type dw_cheque from u_dw_abc within w_ve314_planilla_cobranza
boolean visible = false
integer x = 238
integer y = 608
integer width = 2555
integer height = 576
integer taborder = 30
boolean titlebar = true
string title = "Cheques"
string dataobject = "d_abc_pln_cobranza_chq_tbl"
boolean controlmenu = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		   // 'm' = master sin detalle (default), 'd' =  detalle,
	                     // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3


idw_mst = dw_cheque

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Long    ll_item_deposito ,ll_row_count
Integer li_item


ll_item_deposito = dw_detail.object.item_deposito [dw_detail.Getrow()]

This.object.item_deposito [al_row] = ll_item_deposito





/*Asignacion de item_doc*/
ll_row_count = This.RowCount()
	 
IF ll_row_count = 1 THEN 
	li_item = 0
ELSE
   li_item = This.Getitemnumber(ll_row_count - 1,"item_cheque")
END IF


This.SetItem(al_row, "item_cheque", li_item + 1)  

/***********************/
end event

event itemchanged;call super::itemchanged;String ls_desc_banco,ls_null
Long   ll_count

Accepttext()

Setnull(ls_null)

choose case dwo.name
		 case 'cod_banco'
				select count(*) into :ll_count from banco
				where (cod_banco = :data ) ;
				
				if ll_count  = 0 then
					This.Object.cod_banco       [row] = ls_null
					This.Object.banco_nom_banco [row] = ls_null
					
					Messagebox('Aviso','Debe Ingresar Codigo de Banco , Verifique!')
					Return 1
				else
					
					select nom_banco into :ls_desc_banco from banco where (cod_banco = :data ) ;
					
					This.Object.banco_nom_banco [row] = ls_desc_banco
				end if
				
end choose

end event

event doubleclicked;call super::doubleclicked;String ls_name,ls_prot ,ls_nro_planilla
Date   ldt_fecha_deposito
Long   ll_item_dep
Datawindow	ldw	
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


choose case dwo.name
		 case 'cod_banco'
				lstr_seleccionar.s_seleccion = 'S'
			   lstr_seleccionar.s_sql =	'SELECT BANCO.COD_BANCO AS CODIGO      ,'&
														   +'BANCO.NOM_BANCO AS DESCRIPCION  '&
												         +'FROM BANCO '

														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			   IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_banco' ,lstr_seleccionar.param1[1])
				   Setitem(row,'banco_nom_banco' ,lstr_seleccionar.param2[1])
				  ii_update = 1
			  END IF	
				
end choose

end event

type cb_1 from commandbutton within w_ve314_planilla_cobranza
integer x = 2926
integer y = 24
integer width = 402
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

event clicked;Long 	  ll_row_master,ll_item
Integer li_protect
String  ls_cod_relacion,ls_cod_moneda,ls_flag_estado,ls_confin
Decimal {3} ldc_tasa_cambio
str_parametros sl_param

ll_row_master = dw_detail.Getrow()

IF ll_row_master = 0 THEN Return

ls_flag_estado	 = dw_master.object.flag_estado   [dw_master.Getrow()]
ls_cod_relacion = dw_detail.object.cod_relacion	 [ll_row_master]
ll_item			 = dw_detail.object.item_deposito [ll_row_master]
ls_confin		 = dw_detail.object.confin		    [ll_row_master]
ldc_tasa_cambio = dw_detail.object.tasa_cambio   [ll_row_master]

IF ls_flag_estado <> '1' THEN
	Messagebox('Aviso','No se puede Insertar , Revise Estado de Planilla ')
	RETURN
END IF

IF ldc_tasa_cambio = 0 OR Isnull(ldc_tasa_cambio) THEN
	Messagebox('Aviso','Debe Ingresar Tasa Cambio ,Verifique!')		
	Return
END IF


sl_param.string3 = ls_cod_relacion

OpenWithParm(w_pop_help_edirecto,sl_param)

//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	sl_param = message.PowerObjectParm
END IF

sl_param.string1  = sl_param.string3
sl_param.string2  = ls_confin
sl_param.dw1		= 'd_doc_pendientes_pc_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.tipo 		= '1CP'
sl_param.long1		= ll_item
sl_param.opcion   = 23  //planilla de cobranzas
sl_param.db1 		= 1600
sl_param.dw_m		= dw_detail_det




OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_detail.object.imp_total [dw_detail.getrow()] = wf_recalculo_monto ()
	dw_detail.ii_update		= 1
   dw_detail_det.ii_update = 1
END IF
end event

type dw_detail_det from u_dw_abc within w_ve314_planilla_cobranza
integer x = 37
integer y = 1068
integer width = 3506
integer height = 756
integer taborder = 30
string dataobject = "d_abc_pln_cobranza_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //     'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2



idw_mst = dw_detail
idw_det = dw_detail_det

end event

event itemchanged;call super::itemchanged;Long   ll_count
Date	 ld_fecha_dep,ld_null
String ls_cta_bco ,ls_cnta_ctbl ,ls_nombre,ls_null,ls_flag_detrac
Decimal {2} ldc_importe,ldc_factor_ret,ldc_imp_detrac

Accepttext()

SetNull(ls_null)

choose case dwo.name
	    case 'flag_detraccion'
				if data = '0' then
					This.object.factor_ret_det  [row] = 0.00
					This.object.importe_ret_det [row] = 0.00
					This.object.nro_deposito	 [row] = ls_null
					This.object.fecha_deposito	 [row] = ld_null
					
				end if
				dw_detail.object.imp_total [dw_detail.getrow()] = wf_recalculo_monto ()
				dw_detail.ii_update		= 1
		 case 'factor_ret_det'
				ldc_importe    = this.object.importe		  [row]
				ldc_factor_ret = this.object.factor_ret_det [row]
				ls_flag_detrac = this.object.flag_detraccion [row]
				
				if Isnull(ldc_importe)    then ldc_importe    = 0.00
				if Isnull(ldc_factor_ret) then ldc_factor_ret = 0.00
				
		
				
				IF ldc_factor_ret > 0 AND ls_flag_detrac = '1' THEN //calcular detraccion
					ldc_imp_detrac = (ldc_importe * ldc_factor_ret) / 100
					This.object.importe_ret_det [row] = ldc_imp_detrac
				END IF	
				
				dw_detail.object.imp_total [dw_detail.getrow()] = wf_recalculo_monto ()
				dw_detail.ii_update		= 1
				
		 case	'importe'	
				ldc_importe    = this.object.importe		   [row]
				ldc_factor_ret = this.object.factor_ret_det  [row]
				ls_flag_detrac = this.object.flag_detraccion [row]
				
				if Isnull(ldc_importe)    then ldc_importe    = 0.00
				if Isnull(ldc_factor_ret) then ldc_factor_ret = 0.00
				
				IF ldc_factor_ret > 0 AND ls_flag_detrac = '1' THEN //calcular detraccion
					ldc_imp_detrac = (ldc_importe * ldc_factor_ret) / 100

					This.object.importe_ret_det [row] = ldc_imp_detrac
				END IF	

				dw_detail.object.imp_total [dw_detail.getrow()] = wf_recalculo_monto ()
				dw_detail.ii_update		= 1
				
		case	'doc_deposito'
				select count(*) into :ll_count from doc_tipo where (tipo_doc 	 = :data ) ;
				
				if ll_count = 0 then
					this.object.doc_deposito [row] = ls_null
					Messagebox('Aviso','Documento No existe , Verifique! ')
					Return 1
				end if
				
		 case 'cod_relacion'
				select Count(*) into :ll_count from proveedor 
 				 where (flag_estado = '1'  ) and
				  		 (proveedor   = :data) ;
							
				if ll_count = 0 then
					Messagebox('Aviso','Codigo de Relacion No Existe , Verifique!')
					Return 1	
				else
					select nom_proveedor into :ls_nombre from proveedor
 				    where (flag_estado = '1'  ) and
				  		    (proveedor   = :data) ;
					
					This.Object.proveedor_nom_proveedor [row] = ls_nombre
					
				end if
				
		 case 'cod_ctabco'
			
				select count(*) into :ll_count from banco_cnta where (cod_ctabco  = :data) ;
				
				if ll_count = 0 then
					

					
					This.object.cod_ctabco  [row] = ls_null
					This.object.descripcion [row] = ls_null
					This.object.cnta_ctbl	[row] = ls_null

					Messagebox('Aviso','Cuenta de Banco No Existe Verifique!')
					Return 1
				else
					
					select bc.cnta_ctbl ,bc.descripcion into :ls_cnta_ctbl,:ls_nombre
					  from banco_cnta bc
				    where (bc.cod_ctabco  = :data) ;	
					 
					This.object.descripcion [row] = ls_nombre
					This.object.cnta_ctbl	[row] = ls_cnta_ctbl

				end if
				
			
		CASE	'fecha_deposito'
			
				ld_fecha_dep = date(this.object.fecha_deposito[row])

				//busca tipo de cambio
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio_vta(ld_fecha_dep)
				
		CASE	'confin'          				
			
				select count(*) into :ll_count from concepto_financiero where (confin = :data) ;
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Debe Ingresar Un Concepto Financiero Valido , Verifique!')
					This.object.confin [row] = ls_null
					Return 1
				END IF
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;String ls_name,ls_prot
Date   ldt_fecha_deposito
Datawindow	ldw	
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


choose case dwo.name
	case 'confin'
				lstr_seleccionar.s_seleccion = 'S'
			   lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN		   AS CODIGO         ,'&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION  AS DESC_CONFIN    ,'&
														 +'CONCEPTO_FINANCIERO.MATRIZ_CNTBL AS CONTABLE_MATRIZ '&
														 +'FROM CONCEPTO_FINANCIERO '&
														 +'WHERE CONCEPTO_FINANCIERO.FLAG_ESTADO = '+"'"+'1'+"'"
			   
				OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			   IF lstr_seleccionar.s_action = "aceptar" THEN
					This.object.confin 		 [row] = lstr_seleccionar.param1[1]
					This.object.matriz_cntbl [row] = lstr_seleccionar.param3[1]
				   ii_update = 1
			  END IF	
			  
			  
end choose
			  
end event

type dw_detail from u_dw_abc within w_ve314_planilla_cobranza
integer x = 37
integer y = 376
integer width = 3182
integer height = 680
integer taborder = 20
string dataobject = "d_abc_pln_cobranza_dep_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'dd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2	
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 


idw_mst  = dw_master
idw_det  = dw_detail_det
end event

event itemchanged;call super::itemchanged;Long   ll_count
Date	 ld_fecha_dep
String ls_cta_bco ,ls_cnta_ctbl ,ls_nombre,ls_null,ls_cod_moneda

Accepttext()

SetNull(ls_null)

choose case dwo.name
		 case	'doc_deposito'
				select count(*) into :ll_count from doc_tipo where (tipo_doc 	 = :data ) ;
				
				if ll_count = 0 then
					this.object.doc_deposito [row] = ls_null
					Messagebox('Aviso','Documento No existe , Verifique! ')
					Return 1
				end if
				
		 case 'cod_relacion'
				select Count(*) into :ll_count from proveedor 
 				 where (flag_estado = '1'  ) and
				  		 (proveedor   = :data) ;
							
				if ll_count = 0 then
					Messagebox('Aviso','Codigo de Relacion No Existe , Verifique!')
					Return 1	
				else
					select nom_proveedor into :ls_nombre from proveedor
 				    where (flag_estado = '1'  ) and
				  		    (proveedor   = :data) ;
					
					This.Object.proveedor_nom_proveedor [row] = ls_nombre
					
				end if
				
		 case 'cod_ctabco'
			
				select count(*) into :ll_count from banco_cnta where (cod_ctabco  = :data) ;
				
				if ll_count = 0 then
					

					
					This.object.cod_ctabco  [row] = ls_null
					This.object.descripcion [row] = ls_null
					This.object.cnta_ctbl	[row] = ls_null
					This.object.cod_moneda	[row] = ls_null

					Messagebox('Aviso','Cuenta de Banco No Existe Verifique!')
					Return 1
				else
					
					select bc.cnta_ctbl ,bc.descripcion ,bc.cod_moneda into :ls_cnta_ctbl,:ls_nombre,:ls_cod_moneda
					  from banco_cnta bc
				    where (bc.cod_ctabco  = :data) ;	
					 
					This.object.descripcion [row] = ls_nombre
					This.object.cnta_ctbl	[row] = ls_cnta_ctbl
					This.object.cod_moneda	[row] = ls_cod_moneda

				end if
				
			
		CASE	'fecha_deposito'
			
				ld_fecha_dep = date(this.object.fecha_deposito[row])

				//busca tipo de cambio
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio_vta(ld_fecha_dep)
				
		CASE	'confin'          				
			
				select count(*) into :ll_count from concepto_financiero where (confin = :data) ;
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Debe Ingresar Un Concepto Financiero Valido , Verifique!')
					This.object.confin [row] = ls_null
					Return 1
				END IF
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Long    ll_row_count
Integer li_item

/*Asignacion de item_doc*/
ll_row_count = This.RowCount()
	 
IF ll_row_count = 1 THEN 
	li_item = 0
ELSE
   li_item = This.Getitemnumber(ll_row_count - 1,"item_deposito")
END IF


This.SetItem(al_row, "item_deposito", li_item + 1)  

/***********************/
end event

event doubleclicked;call super::doubleclicked;String ls_name,ls_prot ,ls_nro_planilla
Date   ldt_fecha_deposito
Long   ll_item_dep
Datawindow	ldw	
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


choose case dwo.name
		 case 'b_1'
				ls_nro_planilla = this.object.nro_planilla  [row]
				ll_item_dep		 = this.object.item_deposito [row]
				
				dw_cheque.Visible = TRUE
			
				dw_cheque.Retrieve (ls_nro_planilla,ll_item_dep)

		 case 'doc_deposito'
				lstr_seleccionar.s_seleccion = 'S'
			   lstr_seleccionar.s_sql =	'SELECT DOC_TIPO.TIPO_DOC      AS CODIGO      ,'&
														   +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION  '&
												         +'FROM DOC_TIPO '

														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'doc_deposito' ,lstr_seleccionar.param1[1])
				  ii_update = 1
			  END IF	
				
		 case	'fecha_deposito'
			
				ldw = This
				
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				ldt_fecha_deposito = Date(This.Object.fecha_deposito [row])		
					
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio_vta(ldt_fecha_deposito)
				
		 case 'cod_relacion'
			   lstr_seleccionar.s_seleccion = 'S'
			   lstr_seleccionar.s_sql =	'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO ,'&
														   +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE  '&
												         +'FROM PROVEEDOR '&
												         +'WHERE (PROVEEDOR.FLAG_ESTADO =   '+"'"+'1'+"')"
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			   IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'cod_relacion' ,lstr_seleccionar.param1[1])
				   Setitem(row,'proveedor_nom_proveedor',lstr_seleccionar.param2[1])
				  ii_update = 1
			  END IF	
			  
		 case 'cod_ctabco'
				lstr_seleccionar.s_seleccion = 'S'
			   lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO  AS CUENTA_BANCO      ,'&
														 +'BANCO_CNTA.CNTA_CTBL   AS CUENTA_CONTABLE   ,'&
														 +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION_CUENTA,'&
														 +'BANCO_CNTA.COD_MONEDA  AS MONEDA '&
														 +'FROM BANCO_CNTA '
			   
				OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			   IF lstr_seleccionar.s_action = "aceptar" THEN
					This.object.cod_ctabco  [row] = lstr_seleccionar.param1[1]
					This.object.descripcion [row] = lstr_seleccionar.param3[1]
					This.object.cnta_ctbl	[row] = lstr_seleccionar.param2[1]
					This.object.cod_moneda	[row] = lstr_seleccionar.param4[1]
				   ii_update = 1
			  END IF	
			  
		case 'confin'
				lstr_seleccionar.s_seleccion = 'S'
			   lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN		   AS CODIGO         ,'&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION  AS DESC_CONFIN    ,'&
														 +'CONCEPTO_FINANCIERO.MATRIZ_CNTBL AS CONTABLE_MATRIZ '&
														 +'FROM CONCEPTO_FINANCIERO '&
														 +'WHERE CONCEPTO_FINANCIERO.FLAG_ESTADO = '+"'"+'1'+"'"
			   
				OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm														
			   IF lstr_seleccionar.s_action = "aceptar" THEN
					This.object.confin [row] = lstr_seleccionar.param1[1]
				   ii_update = 1
			  END IF				  
		
end choose

end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;String  ls_flag_estado
Long    ll_inicio
Integer li_protect


ls_flag_estado = dw_master.object.flag_estado [dw_master.Getrow()]


idw_det.retrieve(aa_id[1],aa_id[2])



if ls_flag_estado <> '1' then
	For ll_inicio = 1 to dw_detail_det.rowcount()
		 dw_detail_det.object.flag_null [ll_inicio] = 'A'
	Next
end if


//bloqueo de detalle de documento
li_protect = dw_detail_det.ii_protect
	
IF li_protect = 0 THEN
	dw_detail_det.Modify("importe.Protect         ='1~tIf(IsNull(flag_null),0,1)'")	
	dw_detail_det.Modify("flag_detraccion.Protect ='1~tIf(IsNull(flag_null),0,1)'")
	dw_detail_det.Modify("factor_ret_det.Protect  ='1~tIf(IsNull(flag_null),0,1)'")
	dw_detail_det.Modify("importe_ret_det.Protect ='1~tIf(IsNull(flag_null),0,1)'")
	dw_detail_det.Modify("nro_deposito.Protect    ='1~tIf(IsNull(flag_null),0,1)'")
	dw_detail_det.Modify("fecha_deposito.Protect  ='1~tIf(IsNull(flag_null),0,1)'")
	dw_detail_det.Modify("confin.Protect          ='1~tIf(IsNull(flag_null),0,1)'")	
END IF 
	



dw_detail.object.imp_total [dw_detail.getrow()] =	wf_recalculo_monto ()
dw_detail.ii_update = 1



end event

type dw_master from u_dw_abc within w_ve314_planilla_cobranza
integer x = 37
integer y = 24
integer width = 2729
integer height = 336
string dataobject = "d_abc_pln_cobranza_cab_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		

is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

idw_mst  = dw_master
idw_det  = dw_detail
end event

event itemchanged;call super::itemchanged;Accepttext()

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen  [al_row] = gs_origen
this.object.usr_resp	   [al_row] = gs_user
this.object.flag_estado [al_row] = '1'
this.object.fecha_reg	[al_row] = gd_fecha
end event

