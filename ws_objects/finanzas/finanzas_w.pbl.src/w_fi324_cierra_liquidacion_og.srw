$PBExportHeader$w_fi324_cierra_liquidacion_og.srw
forward
global type w_fi324_cierra_liquidacion_og from w_abc
end type
type cb_1 from commandbutton within w_fi324_cierra_liquidacion_og
end type
type tab_1 from tab within w_fi324_cierra_liquidacion_og
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
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
type tab_1 from tab within w_fi324_cierra_liquidacion_og
tabpage_1 tabpage_1
tabpage_3 tabpage_3
end type
type dw_master from u_dw_abc within w_fi324_cierra_liquidacion_og
end type
end forward

global type w_fi324_cierra_liquidacion_og from w_abc
integer width = 3378
integer height = 1936
string title = "[FI324] Cierre de Liquidacion de Solicitud de Adelanto"
string menuname = "m_mantenimiento_cl_print"
event ue_anular ( )
event ue_update_anular ( ref boolean abo_ok )
event ue_find_exact ( )
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_fi324_cierra_liquidacion_og w_fi324_cierra_liquidacion_og

type variables
Datastore 	ids_matriz_cntbl_det,ids_data_glosa
Decimal 		idc_porct_ret
boolean		ib_cierre = false

n_cst_asiento_contable invo_asiento_cntbl

u_dw_abc 	idw_detail, idw_asiento_cab, idw_asiento_det
end variables

forward prototypes
public subroutine wf_total_asiento_cab (decimal adc_totsoldeb, decimal adc_totdoldeb, decimal adc_totsolhab, decimal adc_totdolhab, long al_row, ref datawindow adw_1)
public subroutine wf_reset_dw ()
public subroutine wf_insert_asiento_cab_ctas_x_pagar (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_descripcion, datetime adt_fecha_registro, long al_row)
public subroutine wf_insert_ctas_x_pagar (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flag_estado, datetime adt_fecha_registro, datetime adt_fecha_emision, datetime adt_fecha_vencimiento, string as_forma_pago, string as_cod_moneda, decimal adc_tasa_cambio, decimal adc_total_pagar, decimal adc_total_pagado, string as_user, string as_origen, long al_nro_libro, long al_nro_asiento, string as_descripcion, string as_cencos, string as_cnta_prsp, string as_confin, long al_ano, long al_mes, string as_item)
public subroutine wf_verifica_ganacia_perdida ()
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_origen, string as_nro_solicitud)
public function boolean of_saldo_og ()
end prototypes

event ue_anular;String  ls_variable     ,ls_flag_estado ,ls_result ,ls_mensaje  ,ls_origen,ls_nro_sg,&
		  ls_cod_relacion ,ls_msj_err     ,ls_cencos ,ls_cnta_prsp,ls_desc  ,&
		  ls_cod_moneda
Long    ll_inicio,ll_var,ll_ano,ll_mes
Integer li_return,li_max_permitido
Date	  ldt_fecha_emision
Decimal ldc_tasa_cambio, ldc_importe_doc,ldc_saldo_dol
 
IF dw_master.Getrow() = 0 THEN RETURN


ll_ano = dw_master.object.ano 		[1]
ll_mes = dw_master.object.mes 		[1]

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return

IF dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR &
	idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1 THEN
	gnvo_app.of_message_error('Grabe Cambios Antes de Anular Cierre de Liquidación , por favor Verifique !')
	Return
END IF
	

ls_flag_estado    = dw_master.object.flag_estado   [1]
ls_origen		   = dw_master.object.origen 		   [1]
ls_nro_sg		   = dw_master.object.nro_solicitud [1]
ls_cod_relacion   = dw_master.object.cod_relacion  [1]
ldt_fecha_emision = Date(dw_master.object.fecha_emision [1])
ls_cencos			= dw_master.object.cencos			[1]
ls_cnta_prsp		= dw_master.object.cnta_prsp		[1]
ls_desc				= dw_master.object.descripcion	[1]
ls_cod_moneda		= dw_master.object.cod_moneda		[1]
ldc_importe_doc	= dw_master.object.importe_doc	[1]

IF ls_flag_estado <> '5' THEN RETURN

//Elimino la ejecución presupuestal correspondiente a la OG
delete presupuesto_ejec
where tipo_doc_ref = :gnvo_app.finparam.is_doc_og
  and nro_doc_ref	 = :ls_nro_sg;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_app.of_message_error( "Error al borrar del presupuesto ejecutado la orden de giro " + ls_nro_sg + ". Por favor verifique!")
	return
end if

//INCREMENTAR CONTADOR DE SOLICITUD DE GIRO
/*Recuperar solicitudes activas*/
select Nvl(nro_maximo_sol_pend,0) - Nvl(nro_solicitudes_pend,0) 
into :li_max_permitido
from maestro_param_autoriz 
where (cod_relacion = :ls_cod_relacion) ;
  
/*Replicacion*/
if li_max_permitido <= 0 then
	Rollback ;
	Messagebox('Aviso','No puede Revertir Cierre , Verifique Solicitudes Pendientes ')	
	Return
end if

UPDATE maestro_param_autoriz
   SET 	nro_solicitudes_pend = Nvl(nro_solicitudes_pend,0) + 1,
			flag_replicacion 		= '1'
 WHERE (cod_relacion = :ls_cod_relacion) ;
 
IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;	
   gnvo_app.of_message_error("Ha ocurrido un error al actualizar la tabla maestro_param_autoriz, por favor verifique!" &
								+ "~r~nMensaje de Error: " + ls_mensaje)
	Return
END IF


/*caebcera de sg*/
dw_master.object.flag_estado       [1] = '4'
dw_master.object.importe_liquidado [1] = 0.00
dw_master.object.importe_liquidado [1] = 0.00
dw_master.object.saldo_sol			  [1] = 0.00
dw_master.object.saldo_dol			  [1] = 0.00
dw_master.object.cnt_origen        [1] = gnvo_app.is_null
dw_master.object.ano               [1] = gnvo_app.il_null
dw_master.object.mes               [1] = gnvo_app.il_null
dw_master.object.nro_libro         [1] = gnvo_app.il_null
dw_master.object.nro_asiento       [1] = gnvo_app.il_null

FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
	 idw_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
	 idw_asiento_det.Object.imp_movdol [ll_inicio] = 0.00
NEXT

idw_asiento_cab.object.tot_soldeb  [1]= 0.00
idw_asiento_cab.object.tot_solhab  [1]= 0.00
idw_asiento_cab.object.tot_doldeb  [1]= 0.00
idw_asiento_cab.object.tot_dolhab  [1]= 0.00
idw_asiento_cab.object.flag_estado [1] = '0'



is_action = 'anular'
dw_master.ii_update = 1
idw_detail.ii_update = 1
idw_asiento_cab.ii_update = 1
idw_asiento_det.ii_update = 1



end event

event ue_update_anular(ref boolean abo_ok);IF	dw_master.ii_update = 1 AND abo_ok THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		abo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 AND abo_ok THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		abo_ok = FALSE
		messagebox("Error en Grabacion Detalle Liquidación","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF idw_asiento_det.ii_update = 1 AND abo_ok THEN
	IF idw_asiento_det.Update(true, false) = -1 THEN //Grabación de Detalle de Asiento
		abo_ok = FALSE
		Messagebox('Error en Grabación Detalle Asientos Confin de Liquidación','Se ha procedido al Rollback',Exclamation!)	
	END IF
END IF

IF idw_asiento_cab.ii_update = 1 AND abo_ok THEN
	IF idw_asiento_cab.Update(true, false) = -1 THEN //Grabación de Cabecera de Pre - Asientos
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
	
	tab_1.tabpage_1.dw_detail.retrieve(ls_origen,ls_nro_solicitud)
	tab_1.tabpage_3.dw_asiento_cab_liq.retrieve(ls_origen,ls_nro_solicitud)
	tab_1.tabpage_3.dw_asiento_det_liq.retrieve(ls_origen,ls_nro_solicitud)
	
	TriggerEvent('ue_modify')
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update  = 0
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
	
ELSE
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.reset()
	tab_1.tabpage_1.dw_detail.ii_update  = 0
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
	
END IF
end event

public subroutine wf_total_asiento_cab (decimal adc_totsoldeb, decimal adc_totdoldeb, decimal adc_totsolhab, decimal adc_totdolhab, long al_row, ref datawindow adw_1);
adw_1.object.tot_soldeb [al_row] = adc_totsoldeb
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


is_action = 'fileopen'
end subroutine

public subroutine wf_insert_asiento_cab_ctas_x_pagar (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_moneda, decimal adc_tasa_cambio, string as_descripcion, datetime adt_fecha_registro, long al_row);

end subroutine

public subroutine wf_insert_ctas_x_pagar (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_flag_estado, datetime adt_fecha_registro, datetime adt_fecha_emision, datetime adt_fecha_vencimiento, string as_forma_pago, string as_cod_moneda, decimal adc_tasa_cambio, decimal adc_total_pagar, decimal adc_total_pagado, string as_user, string as_origen, long al_nro_libro, long al_nro_asiento, string as_descripcion, string as_cencos, string as_cnta_prsp, string as_confin, long al_ano, long al_mes, string as_item);
end subroutine

public subroutine wf_verifica_ganacia_perdida ();//VERIFICAR CUENTA EN DETALLE DE ASIENTOS
//BUSCO CUENTA DE GANANCIA Y PERDIDA
/*Cuenta para generar Asiento en debe y haber*/
String  ls_cnta_ctbl_hab,ls_cnta_ctbl_deb ,ls_flag_estado   ,ls_cod_relacion ,ls_nro_doc,ls_tipo_doc,&
		  ls_msj_err	   ,ls_expresion_rel	,ls_expresion_tipo,ls_expresion_nro,ls_expresion_cnta	    ,&
		  ls_expresion
Long    ll_found,ll_row
Boolean lb_ret = TRUE


ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado   [ll_row]
ls_cod_relacion = dw_master.object.cod_relacion  [ll_row]
ls_nro_doc		 = dw_master.object.nro_solicitud [ll_row]


IF ls_flag_estado <> '5' THEN RETURN
	
	
SELECT cnta_ctbl_liq_haber,cnta_ctbl_liq_debe,doc_sol_giro
  INTO :ls_cnta_ctbl_hab,:ls_cnta_ctbl_deb,:ls_tipo_doc
  FROM finparam
 WHERE (reckey = '1') ;


 	 

 
 
ls_expresion_rel  = 'cod_relacion = '+"'"+ls_cod_relacion+"'" 
ls_expresion_tipo = 'tipo_docref1 = '+"'"+ls_tipo_doc+"'"
ls_expresion_nro  = 'nro_docref1  = '+"'"+ls_nro_doc+"'"
ls_expresion_cnta = 'cnta_ctbl    = '+"'"+ls_cnta_ctbl_hab+"'"


ls_expresion = ls_expresion_rel+" and "+ls_expresion_tipo+" and "+ls_expresion_nro+" and "+ls_expresion_cnta

/**/
//busco cuenta de ganancia	
ll_found = tab_1.tabpage_3.dw_asiento_det_liq.Find(ls_expresion,1,tab_1.tabpage_3.dw_asiento_det_liq.rowcount())

	
IF ll_found > 0 THEN
	update doc_pendientes_cta_cte
	   set cnta_ctbl = :ls_cnta_ctbl_hab,flag_debhab = 'H',factor = -1
    where (cod_relacion = :ls_cod_relacion) and
	 		 (tipo_doc     = :ls_tipo_doc	   ) and
			 (nro_doc		= :ls_nro_doc		) ;
			 
		IF SQLCA.SQLCode = -1 THEN 
			ls_msj_err = SQLCA.SQLErrText
			rollback;
			lb_ret = FALSE
 	      MessageBox("SQL error", ls_msj_err)
		END IF	 
			 
			 
ELSE
	//busco cuenta de perdida	
	
	ls_expresion_rel  = 'cod_relacion = '+"'"+ls_cod_relacion+"'" 
	ls_expresion_tipo = 'tipo_docref1 = '+"'"+ls_tipo_doc+"'"
	ls_expresion_nro  = 'nro_docref1  = '+"'"+ls_nro_doc+"'"
	ls_expresion_cnta = 'cnta_ctbl    = '+"'"+ls_cnta_ctbl_deb+"'"
	
	ls_expresion = ls_expresion_rel+" and "+ls_expresion_tipo+" and "+ls_expresion_nro+" and "+ls_expresion_cnta
	
	ll_found = tab_1.tabpage_3.dw_asiento_det_liq.Find(ls_expresion,1,tab_1.tabpage_3.dw_asiento_det_liq.rowcount())
	
	IF ll_found > 0 THEN
		update doc_pendientes_cta_cte
	   	set cnta_ctbl = :ls_cnta_ctbl_deb,flag_debhab = 'D',factor = 1
	    where (cod_relacion = :ls_cod_relacion) and
		 		 (tipo_doc     = :ls_tipo_doc	   ) and
				 (nro_doc		= :ls_nro_doc		) ;
			 
		IF SQLCA.SQLCode = -1 THEN 
			ls_msj_err = SQLCA.SQLErrText
			rollback;
			lb_ret = FALSE
 	      MessageBox("SQL error", ls_msj_err)
		END IF	 
			 
	END IF
			
END IF



IF lb_ret and ll_found > 0 THEN
	Commit;
END if
end subroutine

public subroutine of_asigna_dws ();idw_detail = tab_1.tabpage_1.dw_detail
idw_asiento_cab = tab_1.tabpage_3.dw_asiento_cab_liq
idw_asiento_det = tab_1.tabpage_3.dw_asiento_det_liq


end subroutine

public subroutine of_retrieve (string as_origen, string as_nro_solicitud);Long ll_year, ll_mes

dw_master.retrieve(as_origen, as_nro_solicitud)

if dw_master.RowCount () = 0 then return


idw_detail.retrieve(as_origen, as_nro_solicitud)
idw_asiento_cab.Retrieve(as_origen, as_nro_solicitud)
idw_asiento_det.Retrieve(as_origen, as_nro_solicitud)
	
dw_master.ii_update = 0
idw_detail.ii_update = 0
idw_asiento_cab.ii_update = 0
idw_asiento_det.ii_update = 0
  
  
dw_master.ii_protect = 0
idw_detail.ii_protect = 0
idw_asiento_cab.ii_protect = 0
idw_asiento_det.ii_protect = 0

dw_master.of_protect()
idw_detail.of_protect()
idw_asiento_cab.of_protect()
idw_asiento_det.of_protect()

is_action = 'fileopen'
	
//Verificacion de Cierre por contabilidad
ll_year 			= Long(dw_master.object.ano			[1])
ll_mes 			= Long(dw_master.object.mes			[1])

if not Isnull(ll_year) and ll_year <> 0 and not Isnull(ll_mes) and ll_mes <> 0 and invo_asiento_cntbl.of_mes_cerrado( ll_year, ll_mes, "R") then
	ib_cierre = true
	dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	dw_master.object.t_cierre.text = ''
	ib_cierre = false
end if
end subroutine

public function boolean of_saldo_og ();Decimal 	ldc_imp_liquidacion, ldc_total_sol, ldc_total_dol, ldc_monto_sol, ldc_monto_dol, ldc_importe, &
			ldc_tasa_cambio, ldc_importe_doc, ldc_saldo_sol, ldc_saldo_dol
String	ls_moneda_det, ls_flag_ret, ls_moneda_sg, ls_origen_sg, ls_nro_og, ls_mensaje, ls_cod_relacion
Long		ll_item, ll_inicio, ll_count
Date		ld_cierre_og

/*total a liquidar*/
ldc_imp_liquidacion 	= 0.00
ldc_total_dol			= 0.00
ldc_total_sol			= 0.00

ls_moneda_sg 		= dw_master.object.cod_moneda 				[1]
ls_origen_sg 		= dw_master.object.origen						[1]
ls_nro_og	 		= dw_master.object.nro_solicitud				[1]
ls_cod_relacion	= dw_master.object.cod_relacion				[1]
ldc_importe_doc	= Dec(dw_master.object.importe_doc			[1])
ld_cierre_og		= Date(dw_master.object.fecha_aprobacion	[1])

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 ldc_importe  		 = Dec(idw_detail.Object.importe     	[ll_inicio])
	 ldc_tasa_cambio   = Dec(idw_detail.Object.tasa_cambio 	[ll_inicio])
	 ls_moneda_det		 = idw_detail.Object.cod_moneda  		[ll_inicio]
	 ll_item				 = idw_detail.Object.item		   		[ll_inicio]
	 ls_flag_ret		 = idw_detail.Object.flag_ret_igv		[ll_inicio]
	 
	 IF Isnull(ldc_importe) THEN ldc_importe = 0.00
	 
	 IF ls_moneda_det = gnvo_app.is_soles THEN
		 ldc_monto_sol   = ldc_importe
		 ldc_monto_dol = Round(ldc_importe / ldc_tasa_cambio,2)
	 ELSE
		 ldc_monto_sol   = Round(ldc_importe * ldc_tasa_cambio,2)
		 ldc_monto_dol = ldc_importe
	 END IF
	 
	 /**Acumula Totales para diferencia**/	 
	 ldc_total_sol	+= ldc_monto_sol
	 ldc_total_dol	+= ldc_monto_dol

NEXT

/*TASA CAMBIO DEL DIA DE CIERRE DE LIQUIDACION*/
ldc_tasa_cambio =	gnvo_app.of_tasa_cambio( ld_cierre_og )

IF gnvo_app.is_soles = ls_moneda_sg THEN
	ldc_imp_liquidacion = ldc_total_sol
	
	ldc_saldo_sol = ldc_importe_doc - ldc_total_sol
	ldc_saldo_dol = (ldc_importe_doc * ldc_tasa_cambio) - ldc_total_dol
	
ELSEIF gnvo_app.is_dolares = ls_moneda_sg THEN
	ldc_imp_liquidacion = ldc_total_dol
	
	ldc_saldo_sol = (ldc_importe_doc / ldc_tasa_cambio) - ldc_total_sol
	ldc_saldo_dol = ldc_importe_doc  - ldc_total_dol

END IF	


/******************/
dw_master.object.cnt_origen        [1] = idw_asiento_cab.object.origen			[1]
dw_master.object.ano 			     [1] = idw_asiento_cab.object.ano 				[1]
dw_master.object.mes 			     [1] = idw_asiento_cab.object.mes 				[1]
dw_master.object.nro_libro 	     [1] = idw_asiento_cab.object.nro_libro 		[1]
dw_master.object.nro_asiento       [1] = idw_asiento_cab.object.nro_Asiento 	[1]
dw_master.object.usuario_aprob     [1] = gs_user
dw_master.object.importe_liquidado [1] = ldc_imp_liquidacion
dw_master.object.flag_estado 	     [1] = '5' 				 	// Liquidacion Cerrada
dw_master.object.saldo_sol 	     [1] = ldc_saldo_sol 		// Saldo soles
dw_master.object.saldo_dol 	     [1] = ldc_saldo_dol 		// Saldo Dolares
dw_master.ii_update = 1




/*Eliminar Movimiento de bolsa presupuestal*/
DELETE FROM presupuesto_ejec
WHERE origen_ref   = :ls_origen_sg
  AND tipo_doc_ref = :gnvo_app.finparam.is_doc_og  
  AND nro_doc_ref  = :ls_nro_og    ;
				  
				  
IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	gnvo_app.of_message_error('Ha ocurrido un error al momento de eliminar la ejecución presupuestal de la Orden de Giro ' &
			+ ls_nro_og + '. Mensaje de Error: ' + ls_mensaje )
	wf_reset_dw ()
	return false
 END IF


//actualizar contador de acuerdo a solicitudes pendientes
//MENORAR CONTADOR DE SOLICITUD DE GIRO
select count(*) 
  into :ll_count 
  from solicitud_giro 
 where cod_relacion = :ls_cod_relacion 
   and flag_estado  in ('3','4');


/*Replicacion*/
UPDATE maestro_param_autoriz
	SET nro_solicitudes_pend = :ll_count  - 1,
		 flag_replicacion = '1'
 WHERE (cod_relacion = :ls_cod_relacion) ;
 
IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK ;
	gnvo_app.of_message_error("Error al momento de actualizar la cantidad de OG pendientes. Mensaje: " + ls_mensaje )
	return false
END IF


return true
end function

on w_fi324_cierra_liquidacion_og.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_print" then this.MenuID = create m_mantenimiento_cl_print
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi324_cierra_liquidacion_og.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;of_asigna_dws()

tab_1.height = newheight - tab_1.y - 10
tab_1.width  = newwidth  - tab_1.x - 10


idw_detail.width    = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height   = tab_1.tabpage_1.height - idw_detail.y - 10

idw_asiento_det.width  = tab_1.tabpage_3.width  - idw_asiento_det.x - 10
idw_asiento_det.height = tab_1.tabpage_3.height - idw_asiento_det.y - 10

end event

event ue_open_pre;call super::ue_open_pre;String  ls_origen,ls_nro_solicitud,ls_flag_estado
Boolean lb_ret = FALSE

idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
dw_master.il_row = 1


//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)
//** **//
//** Datastore de Glosa **//
ids_data_glosa = Create Datastore
ids_data_glosa.DataObject = 'd_data_glosa_liquidacion'
ids_data_glosa.SettransObject(sqlca)
//** **//

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
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
 WHERE (rowid IN (SELECT MAX(rowid) FROM solicitud_giro where flag_estado in ('4','5') )) ;
 
 

dw_master.Retrieve(ls_origen,ls_nro_solicitud)
if dw_master.Rowcount( ) = 0 then return

tab_1.tabpage_1.dw_detail.Retrieve(ls_origen,ls_nro_solicitud)
tab_1.tabpage_3.dw_asiento_cab_liq.Retrieve(ls_origen,ls_nro_solicitud)
tab_1.tabpage_3.dw_asiento_det_liq.Retrieve(ls_origen,ls_nro_solicitud)
  
ls_flag_estado = dw_master.object.flag_estado [dw_master.Getrow()]

IF ls_flag_estado = '5' THEN
	cb_1.Enabled = FALSE //DESACTIVACION YA ESTA CERRADA LIQUIDACION
END IF

TriggerEvent('ue_modify')
 
 //crea objeto
invo_asiento_cntbl = create n_cst_asiento_contable

select porc_ret_igv 
	into :idc_porct_ret 
from finparam 
where reckey = '1' ;


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	 tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 1 OR tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
		tab_1.tabpage_3.dw_asiento_cab_liq.ii_update = 0
		tab_1.tabpage_3.dw_asiento_det_liq.ii_update = 0
		Rollback;
	
	END IF
END IF

end event

event ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()



THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN
	Rollback ;
	RETURN
END IF	

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if

IF idw_detail.ii_update = 1 THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle de Liqudación
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle de Liquidacion","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF idw_asiento_cab.ii_update = 1 THEN
	IF idw_asiento_cab.update(true, false) = -1 then
		lbo_ok = FALSE
		Messagebox("Error en Grabación Cabecera de Asiento Liquidación","Se ha procedido al rollback",exclamation!)			
	END IF
END IF

IF idw_asiento_det.ii_update = 1 THEN
	IF idw_asiento_det.update(true, false) = -1 then
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de Asiento Liquidación","Se ha procedido al rollback",exclamation!)			
	END IF
END IF

IF dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion detalle de Cntas x Pagar
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Cabecera de Solicitud giro","Se ha procedido al rollback",exclamation!)
	END IF
END IF

if lbo_ok then
	if ib_log then
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_asiento_cab.of_save_log()
		lbo_ok = idw_asiento_det.of_save_log()
	end if
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_asiento_cab.ii_update = 0
	idw_asiento_det.ii_update = 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate() 
	idw_asiento_det.ResetUpdate() 

	if is_action = 'new' then
	
		wf_verifica_ganacia_perdida()
	elseif is_action = 'delete' then
		wf_reset_dw()
	end if
	
	is_action = 'fileopen'	
	TriggerEvent('ue_modify')	
	
	f_mensaje('Cambios grabados satisfactoriamente', '')

ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_modify;call super::ue_modify;String ls_flag_estado
Long   ll_row_master

dw_master.Accepttext()
ll_row_master = dw_master.Getrow()

if ll_row_master = 0 then return

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado = '5' THEN
	/*Cabecera*/
	dw_master.ii_protect = 0
	dw_master.of_protect() // protege el dw	
	/*Detalle*/
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	tab_1.tabpage_1.dw_detail.of_protect() // protege el dw	
	
	/*  Asientos Liquidación  */
	tab_1.tabpage_3.dw_asiento_cab_liq.ii_protect = 0
	tab_1.tabpage_3.dw_asiento_det_liq.ii_protect = 0
	
	tab_1.tabpage_3.dw_asiento_cab_liq.of_protect() // protege el dw		
	IF is_action <> 'new' THEN
		tab_1.tabpage_3.dw_asiento_det_liq.of_protect() // protege el dw	
	ELSE
		tab_1.tabpage_3.dw_asiento_det_liq.Modify("cnta_ctbl.Protect='1~tIf(IsNull(flag_edit),0,1)'")	
		tab_1.tabpage_3.dw_asiento_det_liq.Modify("flag_debhab.Protect='1~tIf(IsNull(flag_edit),0,1)'")	
	END IF
	

	

	
	cb_1.Enabled = FALSE //DESACTIVACION YA ESTA CERRADA LIQUIDACION
ELSE
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	tab_1.tabpage_3.dw_asiento_cab_liq.of_protect() 
	tab_1.tabpage_3.dw_asiento_det_liq.of_protect() 
	
	
	cb_1.Enabled = TRUE //DESACTIVACION YA ESTA CERRADA LIQUIDACION
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long   ll_row,ll_inicio
String ls_cod_moneda
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_liquidacion_cierre_og_tbl'
sl_param.titulo = 'Cierra Liquidacion de Orden de Giro ,Fondo Fijo'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	
	
	
	this.of_retrieve(sl_param.field_ret[1],sl_param.field_ret[2])

	
END IF


end event

event ue_delete;//OVERRIDE
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

	
	IF Not(Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' ) OR Not(Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '') OR	Not(Isnull(ls_nro_doc) OR Trim(ls_nro_doc) = '' ) THEN
		Messagebox('Aviso','No se Puede Eliminar Estos Items , Verifique!')
		Return			
	END IF	
	
	IF ls_flag_estado = '5' AND is_action <> 'new' THEN
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

event ue_insert;String ls_flag_estado
Long   ll_row,ll_row_master

if idw_1 <> dw_master then
	if ib_cierre then 
		Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
		return
	end if
end if

IF idw_1 <> tab_1.tabpage_3.dw_asiento_det_liq THEN
	Messagebox('Aviso','No se Puede insertar Datos , Verifique!')
	Return 
ELSE
	ll_row_master = dw_master.Getrow()
	IF ll_row_master = 0 THEN RETURN
	ls_flag_estado = dw_master.object.flag_estado [ll_row_master]
	IF ls_flag_estado = '5' AND is_action <> 'new' THEN
		Messagebox('Aviso','Liquidacion ya Ha sido Cerrada , Verifique!')
		Return
	END IF	
	tab_1.tabpage_3.dw_asiento_cab_liq.il_row = 1

END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update_pre;Decimal 		ldc_total_sol_deb,ldc_total_dol_deb,ldc_total_sol_hab,ldc_total_dol_hab
Long        ll_count	
String      ls_mensaje,ls_result,ls_flag_provisionado,lc_flag_ctrl_reg,ls_cnta_ctbl,&
				ls_msj_err

Long   	ll_inicio				,ll_nro_libro_x_doc	,ll_year					,ll_mes					,&
			ll_nro_asiento			,ll_found				,ll_inicio_det			,ll_nro_libro			,&
			ll_i
			
String 	ls_expresion			,ls_tipo_doc			,ls_item					,ls_nro_solicitud		, &
 			ls_cta_ctbl_liq_hab	,ls_cta_ctbl_liq_deb	,ls_cnta_ctbl_gan		,ls_cnta_ctbl_per		,&
		 	ls_cod_relacion		,ls_nro_doc				,ls_expresion_rel		,ls_expresion_tipo	,&
			ls_expresion_nro		,ls_origen				,ls_expresion_cnta
Decimal ldc_monto_dev_sol,ldc_monto_dev_dol

ib_update_check = False	

if is_action = 'anular' then
	ib_update_check = true
	return
end if

//Valido si hay detalle en el asiento contable
if idw_asiento_det.RowCount() = 0 then
	gnvo_app.of_message_error( "No ha generado el asiento de cierre, no esta permitido grabar los cambios, por favor veirique!")
	return
end if

/*Replicacion*/
dw_master.of_set_flag_replicacion ()
idw_detail.of_set_flag_replicacion ()
idw_asiento_cab.of_set_flag_replicacion ()
idw_asiento_det.of_set_flag_replicacion ()

ls_origen		  	= dw_master.object.origen				[1] 
ll_year 		 	  	= dw_master.object.ano 					[1]
ll_mes 		 	  	= dw_master.object.mes					[1]
ll_nro_libro		= Long(dw_master.object.nro_libro 	[1])
ll_nro_asiento	   = Long(dw_master.object.nro_asiento	[1])
ls_nro_solicitud 	= dw_master.object.nro_solicitud 	[1]
ls_cod_relacion 	= dw_master.object.cod_relacion  	[1]



/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_year,ll_mes,'R') then return

/*verifica cabecera de asiento*/
IF not gnvo_app.of_row_Processing( idw_asiento_cab ) then return
IF not gnvo_app.of_row_Processing( idw_asiento_det ) then return

//Obtengo el numero de Asiento
if IsNull(ll_nro_asiento) or is_action = 'new' then
	if not invo_asiento_cntbl.of_get_nro_asiento(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento) then
		return
	end if
	
	dw_master.object.nro_asiento	[1] = ll_nro_asiento
	dw_master.ii_update = 1
end if

idw_asiento_cab.object.origen			[1] = ls_origen
idw_asiento_cab.object.ano				[1] = ll_year
idw_asiento_cab.object.mes				[1] = ll_mes
idw_asiento_cab.object.nro_libro		[1] = ll_nro_libro
idw_asiento_cab.object.nro_asiento 	[1] = ll_nro_asiento
//idw_asiento_cab.ii_update = 1

for ll_i = 1 to idw_asiento_det.RowCount()
	idw_asiento_det.object.origen			[ll_i] = ls_origen
	idw_asiento_det.object.ano				[ll_i] = ll_year
	idw_asiento_det.object.mes				[ll_i] = ll_mes
	idw_asiento_det.object.nro_libro		[ll_i] = ll_nro_libro
	idw_asiento_det.object.nro_asiento 	[ll_i] = ll_nro_asiento
	//idw_asiento_det.ii_update = 1
next


/*totales de asiento generado solicitud de giro*/
IF idw_asiento_det.Rowcount() > 0 THEN	  
	if not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then return 
END IF

ib_update_check = true



end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_print;call super::ue_print;str_parametros lstr_rep
Long ll_row
w_fi324_rpt_asiento_liq lw_1

setPointer(HourGlass!)

if dw_master.getRow() = 0 then return
ll_row = dw_master.GetRow( )

//	is_origen  = lstr_rep.string1
//	ii_ano     = Integer(lstr_rep.string2)
//	ii_mes	  = Integer(lstr_rep.string3)
//	ii_libro   = Integer(lstr_rep.string4)
//	ii_asiento = Integer(lstr_rep.string5)
	
lstr_rep.string1 = dw_master.object.cnt_origen[ll_row]
lstr_rep.string2 = String(dw_master.object.ano[ll_row])
lstr_rep.string3 = String(dw_master.object.mes[ll_row])
lstr_rep.string4 = String(dw_master.object.nro_libro[ll_row])
lstr_rep.string5 = String(dw_master.object.nro_asiento[ll_row])

OpenSheetWithParm(lw_1, lstr_rep, this, 0, Layered!)
setPointer(Arrow!)
end event

event close;call super::close;destroy invo_asiento_cntbl
end event

type cb_1 from commandbutton within w_fi324_cierra_liquidacion_og
integer x = 2825
integer y = 48
integer width = 439
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cierra Liquidación"
end type

event clicked;Long 		ll_row_master, ll_year, ll_mes
String	ls_cod_origen_og, ls_nro_sg, ls_cod_relacion, ls_moneda_sg
Date		ld_fecha_liq
DateTime	ldt_fecha_cierre_og, ldt_fecha_registro
Decimal	ldc_tasa_cambio

str_parametros	lstr_param


try 
	dw_master.Accepttext()
	idw_detail.Accepttext()
	
	IF idw_detail.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Algun Item para Liquidar', StopSign!)
		Return
	END IF
	
	if ib_cierre then 
		Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad', StopSign!)
		return
	end if
	
	/*Origen de Solicitud de Giro*/
	ll_row_master       = dw_master.getrow()
	ls_cod_origen_og    = dw_master.object.origen	        			[ll_row_master]
	ls_nro_sg	        = dw_master.object.nro_solicitud    			[ll_row_master]
	ls_cod_relacion	  = dw_master.object.cod_relacion	  			[ll_row_master]	
	ld_fecha_liq        = Date(dw_master.object.fecha_aprobacion 	[ll_row_master])
	ls_moneda_sg	     = dw_master.object.cod_moneda       			[ll_row_master]
	ldt_fecha_cierre_og = dw_master.object.fecha_aprobacion 			[ll_row_master]
	
	IF Isnull(ld_fecha_liq) OR string(ld_fecha_liq, 'yyyymmdd') = '00000000' then
		gnvo_app.of_message_error('Debe Ingresar Fecha de Cierre de la liquidación, por favor Verifique!')
		dw_master.Setfocus()
		dw_master.SetColumn('fecha_aprobacion')
		Return
	END IF
	
	/**Fecha de Registro**/
	ldt_fecha_registro = gnvo_app.of_fecha_actual( )
	/****/
	
	/*TASA CAMBIO DEL DIA DE CIERRE DE LIQUIDACION*/
	ldc_tasa_cambio =	gnvo_app.of_tasa_cambio( date(ldt_fecha_registro))
	IF ldc_tasa_cambio = 0 OR Isnull(ldc_tasa_cambio) THEN Return
	
	/*Verifica que Concepto Financiero Liquidación Debe estar Ingresado*/
	IF gnvo_app.of_row_Processing( idw_detail ) <> true then	return
	
	//* Open de Ventana de Ayuda para seleccionar libro y año , mes*//
	
	lstr_param.fecha1 = Date(ldt_fecha_cierre_og)
	OpenWithParm(w_pop_periodo_liq, lstr_param)
	
	//*Datos Recuperados  *//
	if IsNull(message.PowerObjectParm) or not IsValid(Message.PowerObjectparm) then return
	
	lstr_param = message.PowerObjectParm
	
	if not lstr_param.b_return then return
	
	//Obtengo el año y el mes del periodo seleccionado
	ll_year = lstr_param.longa[2]
	ll_mes  = lstr_param.longa[3]
	
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_year,ll_mes,'R') then return
	
	//Si ha cancelado la ventana popup de ayuda, entonces se cancela la operacion no continuo
	if not lstr_param.b_return then return
	
	IF not invo_asiento_cntbl.of_generar_asiento_liq_og(dw_master, 				&
																		 idw_detail,				&
																		 idw_asiento_cab,			&
																		 idw_asiento_det,			&
																		 tab_1,						&
																		 lstr_param ) THEN
		gnvo_app.of_message_error('Ha ocurrido un error en la generación del asiento de cierre de liquidación, por favor verifique')
		wf_reset_dw ()
		dw_master.object.cnt_origen 	[1] = gnvo_app.is_null
		dw_master.object.ano 			[1] = gnvo_app.il_null
		dw_master.object.mes 			[1] = gnvo_app.il_null
		dw_master.object.nro_libro	 	[1] = gnvo_app.il_null
		dw_master.object.nro_asiento 	[1] = gnvo_app.il_null
		
		Rollback ;
		return 
	END IF
	
	of_saldo_og()
	
	
	is_action = 'new'
	Parent.TriggerEvent('ue_modify')
	
	
	f_mensaje('Asiento de Cierre generado correctamente, por favor reviselo', '')
	
catch ( Exception ex )
	MEssageBox('Error', 'Ha ocurrido una expcetion, por favor verifique!' &
						+ '~r~nMensaje de Error: ' + ex.getMessage(), StopSign!)
end try

end event

type tab_1 from tab within w_fi324_cierra_liquidacion_og
event ue_find_exact ( )
integer y = 748
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
tabpage_1 tabpage_1
tabpage_3 tabpage_3
end type

event ue_find_exact();Parent.TriggerEvent('ue_find_exact')
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_3)
end on

event key;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3214
integer height = 804
long backcolor = 79741120
string text = "Documentos Liquidación"
long tabtextcolor = 8388608
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
integer width = 3186
integer height = 780
integer taborder = 20
string dataobject = "d_abc_solicitud_giro_liq_cierre_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = dw_master					    // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Long    ll_count
String  ls_codigo ,ls_cod_moneda,ls_null
Decimal ldc_importe ,ldc_imp_ret, ldc_tasa_cambio

Accepttext()

Setnull(ls_null)

CHOOSE CASE dwo.name
		 CASE	'flag_ret_igv'
				if data = '1' then
					//porcentaje de retencion y en soles
					ls_cod_moneda   = this.object.cod_moneda  [row]
					ldc_importe   	 = this.object.importe 	   [row]
					ldc_tasa_cambio = this.object.tasa_cambio [row]
				
					if isnull(ldc_importe) then ldc_importe = 0.00
				
					if ls_cod_moneda = gnvo_app.is_soles then
						ldc_imp_ret = (ldc_importe * idc_porct_ret) / 100
					elseif ls_cod_moneda = gnvo_app.is_dolares then
						ldc_importe = Round(ldc_importe * ldc_tasa_cambio,2)
						ldc_imp_ret = (ldc_importe * idc_porct_ret) / 100
					end if
					
				elseif data = '0' then
					ldc_imp_ret = 0.00
					this.object.nro_retencion [row] = ls_null
				end if
				
				this.object.importe_ret_igv [row] = ldc_imp_ret		
		
		
		 CASE 'confin'
				SELECT Count(*)
				  INTO :ll_count
				  FROM concepto_financiero
				 WHERE (confin = :data ) ;
				
				IF ll_count = 0 THEN
					Setnull(ls_codigo)
					This.object.confin [row] = ls_codigo
					Messagebox('Aviso','Debe Ingresar Una Concepto Financiero Valido , Verifique!')
					Return 1
				END IF
				 
		 CASE 'confin2'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM concepto_financiero
				 WHERE (confin = :data ) ;
				
				IF ll_count = 0 THEN
					Setnull(ls_codigo)
					This.object.confin2 [row] = ls_codigo
					Messagebox('Aviso','Debe Ingresar Una Concepto Financiero Valido , Verifique!')
					Return 1
				END IF

	
END CHOOSE



end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_ret_igv [al_row]  = '0'
end event

event ue_display;call super::ue_display;str_parametros lstr_param

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
			lstr_param.str_array[1] = '8'		//Liquidaciones de OG
			lstr_param.str_array[2] = '4'		//Todos
			lstr_param.titulo 		= 'Selección de Concepto Financiero'
			lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
			lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
			lstr_param.dw_m			=  This
			
			OpenWithParm( w_abc_seleccion_md, lstr_param)
			IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
			IF lstr_param.titulo = 's' THEN
				this.ii_update = 1
				/**/
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
integer y = 416
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
integer width = 3186
integer height = 404
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_asiento_og_tbl"
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

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_flag_edit

Setnull(ls_flag_edit)

This.Object.item      [al_row] = al_row	
This.Object.flag_edit [al_row] = ls_flag_edit

tab_1.tabpage_3.dw_asiento_det_liq.Modify("cnta_ctbl.Protect='1~tIf(IsNull(flag_edit),0,1)'")	
tab_1.tabpage_3.dw_asiento_det_liq.Modify("flag_debhab.Protect='1~tIf(IsNull(flag_edit),0,1)'")	
this.object.flag_gen_aut[al_row] = '0'

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type dw_master from u_dw_abc within w_fi324_cierra_liquidacion_og
integer width = 2683
integer height = 736
string dataobject = "d_abc_liquidacion_solicitud_giro_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				
ii_dk[1] = 1				// columnas de que pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master	// dw_master
idw_det  = tab_1.tabpage_1.dw_detail	// dw_detail
end event

event itemchanged;Datetime ldt_fec_aprob
Decimal {3} ldc_tasa_x_dia

Accepttext()
CHOOSE CASE dwo.name
	CASE 'fecha_aprobacion'
		ldt_fec_aprob = This.object.fecha_aprobacion [row]
		IF gnvo_app.of_tasa_cambio(Date(ldt_fec_aprob)) = 0.000 THEN
			f_mensaje("No existe tipo de cambio para la fecha " + string(Date(ldt_fec_aprob), 'dd/mm/yyyy') + ", por favor verifique", '')
			Setnull(ldt_fec_aprob) 
			This.object.fecha_aprobacion [row] = ldt_fec_aprob
			Return 1
		END IF
		this.ii_update = 1
					
					
			
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

