$PBExportHeader$n_cst_diaz_retrazo.sru
forward
global type n_cst_diaz_retrazo from nonvisualobject
end type
end forward

global type n_cst_diaz_retrazo from nonvisualobject
end type
global n_cst_diaz_retrazo n_cst_diaz_retrazo

type variables
string 	is_doc_ot, is_doc_otr, is_doc_oc, is_doc_sc, &
			is_doc_sl, is_doc_ov

integer	ii_dias_retrazo_ot, ii_dias_retrazo_otr, &
			ii_dias_retrazo_oc, ii_dias_retrazo_sc, &
			ii_dias_retrazo_sl, ii_dias_retrazo_ov
end variables

forward prototypes
public function datetime of_fecha_actual ()
private function boolean of_get_dias_retrazo ()
public function long of_amp_retrazados (string as_tipo_doc, string as_usuario, integer ai_dias_retrazo)
public function long of_amp_retrazados (string as_tipo_doc)
end prototypes

public function datetime of_fecha_actual ();Datetime ldt_fecha_actual

SELECT SYSDATE
INTO   :ldt_fecha_actual
FROM   DUAL ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error','Fecha Actual no ha sido Recuperada'+' '+SQLCA.SQLErrText)
END IF

Return ldt_fecha_actual
end function

private function boolean of_get_dias_retrazo ();select NVL(DIAS_RETRAZO_OTR, -1)	, NVL(DIAS_RETRAZO_OV, -1), NVL(DIAS_RETRAZO_OC, -1), 
		 NVL(DIAS_RETRAZO_OT, -1)	, NVL(DIAS_RETRAZO_SC, -1), NVL(DIAS_RETRAZO_SL, -1)
	into :ii_dias_retrazo_otr, :ii_dias_retrazo_ov, :ii_dias_retrazo_oc,
		  :ii_dias_retrazo_ot, :ii_dias_retrazo_sc, :ii_dias_retrazo_sl
from logparam 
where reckey = '1';	  

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha ingresado parametros en logparam')
	return false
end if

return true
end function

public function long of_amp_retrazados (string as_tipo_doc, string as_usuario, integer ai_dias_retrazo);// Esta funcion te devuelve el numero de movimientos
// Proyectados de un determinado documento que tienen 
// mas de "as_dias_retrazo" dias
// de Retrazo de un determinado usuario
Long 		ll_result
Date 		ld_fecha

// Si dias de retrazo es negativo entonces 
// No proceso nada
if ai_dias_retrazo < 0 then return 0

ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ai_dias_retrazo * -1)

choose case as_tipo_doc
		
	case is_doc_ot
		// Orden de Trabajo
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				operaciones			op,
				orden_trabajo		ot,
				articulo				a
		where amp.oper_sec 	= op.oper_sec
		  and ot.nro_orden	= op.nro_orden
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and amp.flag_estado = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and ot.cod_usr = :as_usuario;

	case is_doc_otr
		// Orden de Traslado
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				orden_traslado		otr,
				articulo				a
		where amp.nro_doc 		= otr.nro_otr
		  and amp.tipo_doc 		= :is_doc_otr
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and otr.usr_registra		= :as_usuario;
	
	case is_doc_oc
		// Orden de Compra
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				orden_compra		oc,
				articulo				a
		where amp.nro_doc 		= oc.nro_oc
		  and amp.tipo_doc 		= :is_doc_oc
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and oc.cod_usr				= :as_usuario;

	case is_doc_sc
		// Solicitud de Compra
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				sol_compra			sc,
				articulo				a
		where amp.nro_doc 		= sc.nro_sol_comp
		  and amp.tipo_doc 		= :is_doc_sc
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and sc.cod_usr				= :as_usuario;

	case is_doc_sl
		// Solicitud de Salida
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				sol_salida			sl,
				articulo				a
		where amp.nro_doc 		= sl.nro_sol_salida
		  and amp.tipo_doc 		= :is_doc_sl
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and sl.cod_usr				= :as_usuario;
		  
	case is_doc_ov
		// Orden de Venta
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				orden_venta			ov,
				articulo				a
		where amp.nro_doc 		= ov.nro_ov
		  and amp.tipo_doc 		= :is_doc_ov
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and ov.cod_usr				= :as_usuario;
		  
	case else				
		MessageBox('Error', 'Tipo de Documento ' + as_tipo_doc + ' no ha sido definido en logaparam')
		ll_result = -1
end choose

return ll_result

end function

public function long of_amp_retrazados (string as_tipo_doc);// Esta funcion te devuelve el numero de movimientos
// Proyectados de un determinado documento que tienen 
// mas de "as_dias_retrazo" dias
// de Retrazo de un determinado usuario
Long 		ll_result
Date 		ld_fecha

//primero Obtengo los dias de retrazo de todos los documentos
this.of_get_dias_retrazo()

choose case as_tipo_doc
		
	case is_doc_ot
		// Orden de Trabajo
		if ii_dias_retrazo_ot < 0 then return 0
		
		ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ii_dias_retrazo_ot * -1)
		
		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				articulo				a
		where amp.tipo_doc 	= :is_doc_ot
		  and amp.flag_estado = '1'
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.cod_usr = :gs_user;

	case is_doc_otr
		// Orden de Traslado
		if ii_dias_retrazo_otr < 0 then return 0
		
		ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ii_dias_retrazo_otr * -1)

		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				articulo				a
		where amp.tipo_doc 		= :is_doc_otr
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and amp.cod_usr				= :gs_user;
	
	case is_doc_oc
		// Orden de Compra
		if ii_dias_retrazo_oc < 0 then return 0
		
		ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ii_dias_retrazo_oc * -1)

		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				articulo				a
		where amp.tipo_doc		= :is_doc_oc
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and amp.cod_usr				= :gs_user;

	case is_doc_sc
		// Solicitud de Compra
		if ii_dias_retrazo_sc < 0 then return 0
		
		ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ii_dias_retrazo_sc * -1)

		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				articulo				a
		where amp.tipo_doc 		= :is_doc_sc
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and amp.cod_usr				= :gs_user;

	case is_doc_sl
		// Solicitud de Salida
		if ii_dias_retrazo_sl < 0 then return 0
		
		ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ii_dias_retrazo_sl * -1)

		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				articulo				a
		where amp.tipo_doc 		= :is_doc_sl
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and amp.cod_usr				= :gs_user;
		  
	case is_doc_ov
		// Orden de Venta
		if ii_dias_retrazo_ov < 0 then return 0
		
		ld_fecha = RelativeDate(Date(this.of_fecha_actual()), ii_dias_retrazo_ov * -1)

		select count(*)
			into :ll_result
		from 	articulo_mov_proy amp,
				articulo				a
		where amp.tipo_doc 		= :is_doc_ov
		  and a.cod_art			= amp.cod_art
		  and NVL(a.flag_estado, '0') = '1'
		  and NVL(a.flag_inventariable, '0') = '1'
		  and trunc(amp.fec_proyect) < trunc(:ld_fecha)
		  and amp.flag_estado 		= '1'
		  and amp.cod_usr				= :gs_user;
		  
	case else				
		MessageBox('Error', 'Tipo de Documento ' + as_tipo_doc + ' no ha sido definido en logaparam')
		ll_result = -1
end choose

return ll_result

end function

on n_cst_diaz_retrazo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_diaz_retrazo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;select doc_ot, doc_otr, doc_oc, doc_sc, doc_ss, doc_ov
into :is_doc_ot, :is_doc_otr, :is_doc_oc, :is_doc_sc, 
			:is_doc_sl, :is_doc_ov
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'No ha definido ningun parametro en logparam')
	return
end if

if IsNUll(is_doc_ot) or is_doc_ot = '' then
	MessageBox('Error', 'No ha definido doc_ot en logparam')
	return
end if

if IsNUll(is_doc_otr) or is_doc_otr = '' then
	MessageBox('Error', 'No ha definido doc_otr en logparam')
	return
end if

if IsNUll(is_doc_oc) or is_doc_oc = '' then
	MessageBox('Error', 'No ha definido doc_oc en logparam')
	return
end if

if IsNUll(is_doc_sc) or is_doc_sc = '' then
	MessageBox('Error', 'No ha definido doc_sc en logparam')
	return
end if

if IsNUll(is_doc_sl) or is_doc_sl = '' then
	MessageBox('Error', 'No ha definido doc_oc en logparam')
	return
end if

if IsNUll(is_doc_ov) or is_doc_ov = '' then
	MessageBox('Error', 'No ha definido doc_ov en logparam')
	return
end if
end event

