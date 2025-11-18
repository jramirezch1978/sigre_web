$PBExportHeader$n_cst_asiento_contable.sru
forward
global type n_cst_asiento_contable from nonvisualobject
end type
end forward

global type n_cst_asiento_contable from nonvisualobject
end type
global n_cst_asiento_contable n_cst_asiento_contable

type variables
String					is_soles, is_dolares, is_cnta_ajuste_deb, is_cnta_ajuste_hab, is_cencos_aj, &
							is_centro_benef_aj
Decimal					idc_max_dif_ajuste
u_ds_base 				ids_matriz_cntbl, ids_doc_pend_cta_cte, ids_doc_pend_adic_tbl, ids_glosa, &
							ids_glosa_cb
							
n_cst_asiento_glosa 	invo_asiento_glosa
n_cst_contabilidad	invo_cntbl
end variables

forward prototypes
public function boolean of_get_nro_asiento (ref string as_origen, ref long al_ano, ref long al_mes, ref long al_nro_libro, ref long al_nro_asiento)
public function boolean of_cnta_cntbl (string as_cnta_ctbl, ref string as_flag_ctabco, ref string as_flag_cencos, ref string as_flag_doc_ref, ref string as_flag_cod_rel, ref string as_flag_centro_benef)
public function string of_generar_expresion (str_cnta_cntbl astr_cnta, str_parametros astr_param)
public function boolean of_nro_libro_pagos (ref long al_nro_libro)
public function integer of_nro_libro (string as_tipo_doc)
public subroutine of_monto_detalle_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, ref decimal adc_monto_sol, ref decimal adc_monto_dol)
public function boolean of_recall_asiento (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_cod_moneda, decimal adc_tasa_cambio, datetime adt_fecha, decimal adc_monto_doc, u_dw_abc adw_det)
public subroutine of_recall_asiento_doc (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, ref string as_cnta_cntbl)
public function boolean of_get_libro_aplicacion (ref long al_nro_libro)
public function boolean of_val_cntbl_mes_bk (long al_ano, long al_mes, string as_tipo, ref string as_flag_result, ref string as_mensaje)
public function boolean of_val_mes_cntbl (long al_year, long al_mes, string as_tipo, ref string as_flag_result, ref string as_mensaje)
public subroutine of_update_asientos ()
public function boolean of_val_mes_cntbl (long al_year, long al_mes, string as_tipo)
public function boolean of_glosa_cxc_cxp (u_dw_abc adw_master, u_dw_abc adw_detail, long al_row, str_cnta_cntbl astr_cnta, string as_flag_cxc_cxp)
public subroutine of_glosa_cb (u_dw_abc adw_1, u_dw_abc adw_2, datastore ads_1, long al_row_cab, long al_row_det, string as_cnta_cntbl, string as_desc_cnta)
public function boolean of_glosa_ncp_ndp (u_dw_abc adw_master, u_dw_abc adw_detail, long al_row, str_cnta_cntbl astr_cnta)
public function boolean of_generar_asiento_ncp_ndp (u_dw_abc adw_master, u_dw_abc adw_detail, u_dw_abc adw_referencias, u_dw_abc adw_impuestos, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, tab at_tab1)
public function boolean of_validar_asiento (u_dw_abc adw_asiento_det)
public function boolean of_mes_cerrado (long al_year, long al_mes, string as_tipo)
public function boolean of_existe_mes_cntbl (long al_year, long al_mes)
public function boolean of_generar_asiento_liq_og (u_dw_abc adw_master, u_dw_abc adw_detail, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, tab at_tab1, str_parametros astr_param) throws exception
public function boolean of_glosa_liq_og (u_dw_abc adw_1, u_dw_abc adw_2, u_ds_base ads_1, long al_row_det, string as_cnta_cntbl, string as_desc_cnta)
public function boolean of_get_datos_asiento_og (string as_nro_og, ref str_cnta_cntbl astr_cnta)
public function boolean of_generar_asiento (u_dw_abc adw_master, u_dw_abc adw_detail, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, str_parametros astr_param) throws exception
public function boolean of_generar_asiento_cxp_cxc (u_dw_abc adw_master, u_dw_abc adw_detail, u_dw_abc adw_referencias, u_dw_abc adw_impuestos, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, tab at_tab1, string as_flag_cxc_cxp)
public function boolean of_glosa_cxc_nv (u_dw_abc adw_master, u_dw_abc adw_detail, long al_row, str_cnta_cntbl astr_cnta, string as_flag_cxc_cxp)
public function boolean of_generar_asiento_cxc_nv (u_dw_abc adw_master, u_dw_abc adw_detail, u_dw_abc adw_impuestos, u_dw_abc adw_asiento_cab, u_dw_abc adw_asiento_det, tab at_tab1, string as_flag_cxc_cxp)
public function boolean of_generar_ajuste (ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det) throws exception
public function boolean of_generar_asiento_cb (ref u_dw_abc adw_master, ref u_dw_abc adw_detail, u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, datastore ads_datos_asiento, ref datastore ads_relacion_ext)
end prototypes

public function boolean of_get_nro_asiento (ref string as_origen, ref long al_ano, ref long al_mes, ref long al_nro_libro, ref long al_nro_asiento);Long    ll_count
String  ls_mensaje


SELECT Count(*)
	INTO :ll_count
FROM cntbl_libro_mes
WHERE origen	  = :as_origen    AND
 		nro_libro  = :al_nro_libro AND  
		ano 		  = :al_ano		   AND
		mes		  = :al_mes      ;

if ll_count = 0 then
	
	INSERT INTO cntbl_libro_mes(origen, ano, mes, nro_libro, nro_asiento)
	values(:as_origen, :al_ano, :al_mes, :al_nro_libro, 1);
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'Error al insertar cntbl_libro_mes en funcion ' + this.ClassName() &
			+ '.of_get_nro_asiento: ' + trim(ls_mensaje) + '~r~n' &
			+ "Datos a Insertar: ~r~n " &
			+ "Origen = (" + as_origen + ")~r~n" &
			+ "Año = (" + string(al_ano) + ")~r~n" &
			+ "Mes = (" + string(al_mes) + ")~r~n" &
			+ "Nro Libro = (" + string(al_nro_libro) + ")", Exclamation!)
		Return false
	end if
	
	al_nro_asiento = 1
else
	SELECT nro_asiento
	  INTO :al_nro_asiento
	  FROM cntbl_libro_mes
	 WHERE origen	  = :as_origen    AND
			 nro_libro = :al_nro_libro AND  
			 ano 		  = :al_ano		   AND
			 mes		  = :al_mes       
	FOR UPDATE;
end if


UPDATE cntbl_libro_mes
   SET nro_asiento = :al_nro_asiento + 1
 WHERE origen	  = :as_origen    AND
 		 nro_libro = :al_nro_libro AND  
		 ano 		  = :al_ano		   AND
		 mes		  = :al_mes       ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	f_mensaje('Error al momento de actualizar cntbl_libro_mes en funcion ' + this.ClassName() &
			+ '.of_get_nro_asiento: ' + ls_mensaje, '')
	return false
END IF	
 
Return true


end function

public function boolean of_cnta_cntbl (string as_cnta_ctbl, ref string as_flag_ctabco, ref string as_flag_cencos, ref string as_flag_doc_ref, ref string as_flag_cod_rel, ref string as_flag_centro_benef);SELECT flag_ctabco  ,
       flag_cencos  ,
       flag_doc_ref ,
       flag_codrel  ,
		 flag_centro_benef
 INTO  :as_flag_ctabco,
 		 :as_flag_cencos,
		 :as_flag_doc_ref,
 		 :as_flag_cod_rel,
		 :as_flag_centro_benef
 FROM  cntbl_cnta
WHERE cnta_ctbl = :as_cnta_ctbl ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error  CNTBL_CNTA", "Error al buscar cuenta Contable: " + as_cnta_ctbl + ", Error: " + SQLCA.SQLErrText)
	return false
END IF

IF SQLCA.SQLCode = 100 THEN 
	MessageBox("SQL error  CNTBL_CNTA", "No se encuentra cuenta contable: " + as_cnta_ctbl + ", por favor verifique!")
	return false
END IF

Return true
end function

public function string of_generar_expresion (str_cnta_cntbl astr_cnta, str_parametros astr_param);String ls_expresion

ls_expresion 	 = "cnta_ctbl ='"+ astr_cnta.cnta_cntbl + "'" &
					 + " AND flag_debhab = '"+astr_param.flag_debhab + "'"
					 
if astr_cnta.flag_cencos = '1' then
	if ISNull(astr_param.cencos) or astr_param.cencos = '' then
		ls_expresion += " AND (IsNull(cencos) or cencos = '')"
	else
		ls_expresion += " AND cencos ='" + astr_param.cencos + "'"
	end if
end if

if astr_cnta.flag_centro_benef = '1' then
	if ISNull(astr_param.centro_benef) or astr_param.centro_benef = '' then
		ls_expresion += " AND (IsNull(centro_benef) or centro_benef = '')"
	else
		ls_expresion += " AND centro_benef ='" + astr_param.centro_benef + "'"
	end if
end if

if astr_cnta.flag_codrel = '1' then
	if ISNull(astr_param.cod_relacion) or astr_param.cod_relacion = '' then
		ls_expresion += " AND (IsNull(cod_relacion) or cod_relacion = '')"
	else
		ls_expresion += " AND cod_relacion ='" + astr_param.cod_relacion + "'"
	end if
end if

if astr_cnta.flag_doc_ref = '1' then
	if ISNull(astr_param.tipo_docref1) or astr_param.tipo_docref1 = '' then
		ls_expresion += " AND (IsNull(tipo_docref1) or tipo_docref1 = '')"
	else
		ls_expresion += " AND tipo_docref1 ='" + astr_param.tipo_docref1 + "'"
	end if
	if ISNull(astr_param.nro_docref1) or astr_param.nro_docref1 = '' then
		ls_expresion += " AND (ISNull(nro_docref1) or nro_docref1 = '')"
	else
		ls_expresion += " AND nro_docref1 ='" + astr_param.nro_docref1 + "'"
	end if
end if

if astr_cnta.flag_ctabco = '1' then
	if ISNull(astr_param.cod_ctabco) or astr_param.cod_ctabco = '' then
		ls_expresion += " AND (IsNull(cod_ctabco) or cod_ctabco = '')"
	else
		ls_expresion += " AND cod_ctabco ='" + astr_param.cod_ctabco + "'"
	end if
end if

return ls_expresion
end function

public function boolean of_nro_libro_pagos (ref long al_nro_libro);
SELECT libro_pagos
  INTO :al_nro_libro
FROM finparam
WHERE (reckey = '1') ;
 
IF SQLCA.SQLCode < 0 then
	rollback;
	MessageBox('Error en ' + this.ClassName() + '.of_nro_libro', &
			SQLCA.SQLErrText, StopSign!)
	return false
end if

IF Isnull(al_nro_libro) OR al_nro_libro = 0 THEN
	return false
END IF

Return true
end function

public function integer of_nro_libro (string as_tipo_doc);Int li_nro_libro


SELECT Nvl(nro_libro,0)  
INTO   :li_nro_libro
FROM   doc_tipo  
WHERE  tipo_doc = :as_tipo_doc ; 
  
if SQLCA.SQLCode = 100 then
	rollbacK;
	MessageBox("Error en " + this.Classname( ) + ".of_nro_libro", "No existe Tipo Doc: " + as_tipo_doc + ", por favor verifique!" )
	return -1
end if

IF Isnull(li_nro_libro) OR li_nro_libro = 0 THEN
   Messagebox('Funcion Nro Libro','Verifique, El Tipo de Documento no tiene Libro Considerado en TAbla DOC_TIPO')
	return -1
END IF 

Return li_nro_libro
end function

public subroutine of_monto_detalle_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, ref decimal adc_monto_sol, ref decimal adc_monto_dol);String ls_flag_debhab
Decimal {2} ldc_monto_sol = 0.00,ldc_monto_dol = 0.00


adc_monto_sol = 0.00
adc_monto_dol = 0.00

/*Declaración de Cursor*/
DECLARE c_detalle CURSOR FOR
  SELECT imp_movsol,
         imp_movdol,
			flag_debhab
    FROM cntbl_asiento_det
   WHERE origen       = :as_origen      
	  AND ano          = :al_ano         
	  AND mes          = :al_mes         
	  AND nro_libro    = :al_nro_libro   
	  AND nro_asiento  = :al_nro_asiento 
	  AND cod_relacion = :as_cod_relacion
	  AND tipo_docref1 = :as_tipo_doc	   
	  AND nro_docref1  = :as_nro_doc	   
	  and imp_movsol	 <> 0 
	  and imp_movdol	 <> 0;
								

/*Abrir Cursor*/		  	
OPEN c_detalle ;
	
	DO 				/*Recorro Cursor*/	
	 FETCH c_detalle INTO :ldc_monto_sol,:ldc_monto_dol,:ls_flag_debhab;
	 IF sqlca.sqlcode = 100 THEN EXIT
	 
	 IF Isnull(ldc_monto_sol) then ldc_monto_sol = 0.00
	 IF Isnull(ldc_monto_dol) then ldc_monto_dol = 0.00
	 
	 //soles
	 IF ls_flag_debhab = 'D' then
		 adc_monto_sol = adc_monto_sol - ldc_monto_sol
	 ELSE	 
		 adc_monto_sol = adc_monto_sol + ldc_monto_sol
	 END IF
    //dolares
 	 IF ls_flag_debhab = 'D' then
		 adc_monto_dol = adc_monto_dol - ldc_monto_dol
	 ELSE	 
		 adc_monto_dol = adc_monto_dol + ldc_monto_dol
	 END IF
	 
	 
	 
	 
	LOOP WHILE TRUE
	
CLOSE c_detalle ; /*Cierra Cursor*/								

adc_monto_sol = abs(adc_monto_sol)
adc_monto_dol = abs(adc_monto_dol)


end subroutine

public function boolean of_recall_asiento (string as_cod_relacion, string as_tipo_doc, string as_nro_doc, string as_cod_moneda, decimal adc_tasa_cambio, datetime adt_fecha, decimal adc_monto_doc, u_dw_abc adw_det);String   ls_flag_tabla,ls_cnta_ctbl,ls_flag_debhab
Decimal {2} ldc_saldo_sol,ldc_saldo_dol
Long     ll_row
Boolean  lb_ret = TRUE


SELECT flag_tabla ,cnta_ctbl ,DECODE(flag_debhab,'D','H','D')
  INTO :ls_flag_tabla ,:ls_cnta_ctbl ,:ls_flag_debhab
  FROM doc_pendientes_cta_cte 
 WHERE ((cod_relacion = :as_cod_relacion ) AND
 		  (tipo_doc	    = :as_tipo_doc     ) AND
		  (nro_doc		 = :as_nro_doc      )) ;



IF Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '' THEN
	Messagebox('Aviso','Documento no Existe en Cuenta Corriente '+as_tipo_doc+' '+as_nro_doc+' Verifique!')
	lb_ret = FALSE
END IF


IF lb_ret THEN /*INSERTA ASIENTO EN DETALLE*/
	ll_row = adw_det.event ue_insert()
	
	if ll_row > 0 then
		adw_det.object.item         [ll_row] = ll_row
		adw_det.object.cnta_ctbl    [ll_row] =	ls_cnta_ctbl
		adw_det.object.fec_cntbl    [ll_row] = adt_fecha
		adw_det.object.det_glosa    [ll_row] = ''
		adw_det.object.flag_debhab  [ll_row] = ls_flag_debhab
		adw_det.object.tipo_docref1 [ll_row] = as_tipo_doc
		adw_det.object.nro_docref1  [ll_row] = as_nro_doc
		adw_det.object.cod_relacion [ll_row] = as_cod_relacion
	end if
	
END IF



RETURN lb_ret

end function

public subroutine of_recall_asiento_doc (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento, string as_cod_relacion, string as_tipo_doc, string as_nro_doc, ref string as_cnta_cntbl);/**************************/
/*Recupera Asiento Generado*/
/**************************/

SELECT cnta_ctbl    
  INTO :as_cnta_cntbl
  FROM (select * 
  			 from cntbl_asiento_det cad2
			where origen       = :as_origen       
			  and ano          = :al_ano          
			  and mes			  = :al_mes          
			  and nro_libro    = :al_nro_libro    
			  and nro_asiento  = :al_nro_asiento  
			  and cod_relacion = :as_cod_relacion 
			  and tipo_docref1 = :as_tipo_doc     
			  and trim(nro_docref1)  = trim(:as_nro_doc) 		
			order by cad2.item desc) ;

end subroutine

public function boolean of_get_libro_aplicacion (ref long al_nro_libro);
/*SELECT libro_pagos
  INTO :al_nro_libro
FROM finparam
WHERE (reckey = '1') ;
 
IF SQLCA.SQLCode < 0 then
	rollback;
	MessageBox('Error en ' + this.ClassName() + '.of_nro_libro', &
			SQLCA.SQLErrText, StopSign!)
	return false
end if

IF Isnull(al_nro_libro) OR al_nro_libro = 0 THEN
	return false
END IF
*/

al_nro_libro = 6

Return true
end function

public function boolean of_val_cntbl_mes_bk (long al_ano, long al_mes, string as_tipo, ref string as_flag_result, ref string as_mensaje);//create or replace function USF_CNT_CIERRE_CNTBL(
//       ani_year in cntbl_asiento.ano%type,
//       ani_mes  in cntbl_asiento.mes%type,
//       asi_tipo in string
//) return varchar2 is
//

String ls_mensaje
DECLARE USF_CNT_CIERRE_CNTBL PROCEDURE FOR 
	USF_CNT_CIERRE_CNTBL (:al_ano,
								 :al_mes,
								 :as_tipo);
EXECUTE USF_CNT_CIERRE_CNTBL ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error en procedimiento USF_CNT_CIERRE_CNTBL", "Se ha producido un error en función USF_CNT_CIERRE_CNTBL: " + ls_mensaje)
	return false
END IF

FETCH USF_CNT_CIERRE_CNTBL INTO :as_flag_result ;
CLOSE USF_CNT_CIERRE_CNTBL ;

IF as_flag_result = '0' THEN
	ROLLBACK;
	as_mensaje = 'Mes Cerrado , Verifique!'
	return false
END IF

return true
end function

public function boolean of_val_mes_cntbl (long al_year, long al_mes, string as_tipo, ref string as_flag_result, ref string as_mensaje);Long 		ll_count
String	ls_flag_reg_cntbl, 			ls_flag_mov_banco, 			ls_flag_cierre_mes,  		ls_flag_gen_asnt_autom, &
			ls_pd_campo,       			ls_pd_dma,         			ls_pd_mtto_fab,      		ls_pd_mtto_maq

/* Retorna false, no debe grabar asiento,
  retorna true, debe grabar asiento */

/* as_tipo tiene los siguientes valores, para los siguientes casos:
  R = caso registros de compras y ventas,
  B = caso movimiento bancario (tesorería),
  M = cualquier asiento contable (por contabilidad) y
  A = para asientos contables por proceso
  C = caso de inventarios -almacenes-
  D = ????????
  F = partes diarios relacionados a OT
  P = parte diario de mantenimiento de maquinarias
*/

SELECT count(*)
  INTO :ll_count
  FROM cntbl_cierre
 WHERE ano = :al_year
   and mes = :al_mes ;

if ll_count = 0 then
	ROLLBACK;
	f_mensaje("No se aperturado periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') &
						  + ", por favor coordinar con contabilidad para la apertura del periodo contable", "")
	return false
end if

SELECT 	NVL(flag_reg_cntbl,'0'),	NVL(flag_mov_banco,'0'),	NVL(flag_cierre_mes,'0'),	NVL(flag_gen_asnt_autom,'0'),
			NVL(pd_campo, '0'),			NVL(pd_dma,'0'),				NVL(pd_mtto_fab, '0'),		NVL(pd_mtto_maq, '0')
  INTO   :ls_flag_reg_cntbl, 			:ls_flag_mov_banco, 			:ls_flag_cierre_mes,  		:ls_flag_gen_asnt_autom,
			:ls_pd_campo,       			:ls_pd_dma,         			:ls_pd_mtto_fab,      		:ls_pd_mtto_maq
  FROM   cntbl_cierre
 WHERE  ano = :al_year
   and  mes = :al_mes ;
	
if ls_flag_cierre_mes = '0' then
	ROLLBACK;
	f_mensaje ("El periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + " se encuentra cerrado. Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Registros contables, libros 3 y 4 */
IF as_tipo='R' and ls_flag_reg_cntbl = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer operaciones de este tipo en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Movimientos bancarios, libros 7 y 8 */
IF as_tipo='B' and ls_flag_mov_banco = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer operaciones Bancarias en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Asientos contables generados por procesos */
IF as_tipo='A' and ls_flag_gen_asnt_autom = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer Procesos Automatizados que generen Asientos Contables en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Asientos contables generados por almacen */
IF as_tipo='A' and ls_flag_gen_asnt_autom = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer o modificar Movimientos de Almacén en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if


RETURN true

end function

public subroutine of_update_asientos ();update cntbl_Asiento ca
   set ca.tot_soldeb = (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_soldeb <> (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);
                                                                            
update cntbl_Asiento ca
   set ca.tot_solhab = (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_solhab <> (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);
                           
update cntbl_Asiento ca
   set ca.tot_doldeb = (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_doldeb <> (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);

update cntbl_Asiento ca
   set ca.tot_dolhab = (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_dolhab <> (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);         

commit;

                           
end subroutine

public function boolean of_val_mes_cntbl (long al_year, long al_mes, string as_tipo);Long 		ll_count
String	ls_flag_reg_cntbl, 			ls_flag_mov_banco, 			ls_flag_cierre_mes,  		ls_flag_gen_asnt_autom, &
			ls_pd_campo,       			ls_pd_dma,         			ls_pd_mtto_fab,      		ls_pd_mtto_maq

/* Retorna false, no debe grabar asiento,
  retorna true, debe grabar asiento */

/* as_tipo tiene los siguientes valores, para los siguientes casos:
  R = caso registros de compras y ventas,
  B = caso movimiento bancario (tesorería),
  M = cualquier asiento contable (por contabilidad) y
  A = para asientos contables por proceso
  C = caso de inventarios -almacenes-
  D = ????????
  F = partes diarios relacionados a OT
  P = parte diario de mantenimiento de maquinarias
*/

SELECT count(*)
  INTO :ll_count
  FROM cntbl_cierre
 WHERE ano = :al_year
   and mes = :al_mes ;

if ll_count = 0 then
	ROLLBACK;
	f_mensaje("No se aperturado periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') &
						  + ", por favor coordinar con contabilidad para la apertura del periodo contable", "")
	return false
end if

SELECT 	NVL(flag_reg_cntbl,'0'),	NVL(flag_mov_banco,'0'),	NVL(flag_cierre_mes,'0'),	NVL(flag_gen_asnt_autom,'0'),
			NVL(pd_campo, '0'),			NVL(pd_dma,'0'),				NVL(pd_mtto_fab, '0'),		NVL(pd_mtto_maq, '0')
  INTO   :ls_flag_reg_cntbl, 			:ls_flag_mov_banco, 			:ls_flag_cierre_mes,  		:ls_flag_gen_asnt_autom,
			:ls_pd_campo,       			:ls_pd_dma,         			:ls_pd_mtto_fab,      		:ls_pd_mtto_maq
  FROM   cntbl_cierre
 WHERE  ano = :al_year
   and  mes = :al_mes ;
	
if ls_flag_cierre_mes = '0' then
	ROLLBACK;
	f_mensaje ("El periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + " se encuentra cerrado. Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Registros contables, libros 3 y 4 */
IF as_tipo='R' and ls_flag_reg_cntbl = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer operaciones de este tipo en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Movimientos bancarios, libros 7 y 8 */
IF as_tipo='B' and ls_flag_mov_banco = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer operaciones Bancarias en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Asientos contables generados por procesos */
IF as_tipo='A' and ls_flag_gen_asnt_autom = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer Procesos Automatizados que generen Asientos Contables en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if

/* Asientos contables generados por almacen */
IF as_tipo='A' and ls_flag_gen_asnt_autom = '0' then
	ROLLBACK;
	f_mensaje("No esta permitido hacer o modificar Movimientos de Almacén en el periodo contable: " + string(al_mes, '00') + "/" + string(al_year, '0000') & 
						  + ". Por favor coordine con el Área de Contabilidad", "")
	return false
end if


RETURN true

end function

public function boolean of_glosa_cxc_cxp (u_dw_abc adw_master, u_dw_abc adw_detail, long al_row, str_cnta_cntbl astr_cnta, string as_flag_cxc_cxp);/****************************************************/
/*LLenado de Datastore en Caso de Liquidación       */
/* adw_master = Cabecera de Cntas_Cobrar					    */
/* adw_detail = Detalle  de Cntas_Cobrar                 */
/* ids_glosa = Datastore de Datos Para Glosa				 */
/* al_row = Linea de Detalle de cntas_cobrar	 */
/****************************************************/
Long   ll_ins_ds

ids_glosa.Reset()

ll_ins_ds = ids_glosa.InsertRow(0)
/*Cabecera*/
ids_glosa.Object.origen			 [ll_ins_ds] = adw_master.Object.origen 	       	[1]
ids_glosa.Object.tipo_doc		 [ll_ins_ds] = adw_master.Object.tipo_doc 	    	[1]
ids_glosa.Object.nro_doc		 [ll_ins_ds] = adw_master.Object.nro_doc  	    	[1]
ids_glosa.Object.cod_relacion	 [ll_ins_ds] = adw_master.Object.cod_relacion   	[1]
ids_glosa.Object.nom_proveedor [ll_ins_ds] = adw_master.Object.nom_proveedor  	[1]
ids_glosa.Object.cod_moneda	 [ll_ins_ds] = adw_master.Object.cod_moneda 	 		[1]
ids_glosa.Object.tasa_cambio   [ll_ins_ds] = adw_master.Object.tasa_cambio    	[1] 
ids_glosa.Object.ano 			 [ll_ins_ds] = adw_master.Object.ano		       	[1] 
ids_glosa.Object.mes 			 [ll_ins_ds] = adw_master.Object.mes   		    	[1] 
ids_glosa.Object.nro_libro 	 [ll_ins_ds] = adw_master.Object.nro_libro      	[1] 
ids_glosa.Object.nro_asiento   [ll_ins_ds] = adw_master.Object.nro_asiento    	[1] 
ids_glosa.Object.fecha_registro[ll_ins_ds] =	adw_master.Object.fecha_registro 	[1]
ids_glosa.Object.cod_usr		 [ll_ins_ds] = adw_master.Object.cod_usr				[1]

ids_glosa.Object.cnta_ctbl		 [ll_ins_ds] = astr_cnta.cnta_cntbl
ids_glosa.Object.desc_cnta		 [ll_ins_ds] = Mid(astr_cnta.desc_cnta,1,100)

/*Detalle*/
ids_glosa.Object.cod_art		 [ll_ins_ds] = adw_detail.Object.cod_art		[al_row]
ids_glosa.Object.descripcion	 [ll_ins_ds] = adw_detail.Object.descripcion [al_row]


IF as_flag_cxc_cxp = 'C' THEN 
	//Cuentas Por Cobrar
	ids_glosa.Object.observacion		  [ll_ins_ds] =	Mid(adw_master.Object.observacion	[1],1,100) 
	ids_glosa.Object.fecha_documento   [ll_ins_ds] = adw_master.Object.fecha_documento 	 	[1]
	ids_glosa.Object.punto_venta	     [ll_ins_ds] =	adw_master.Object.punto_venta 		[1]
	ids_glosa.Object.fecha_vencimiento [ll_ins_ds] = adw_master.Object.fecha_vencimiento 	[1]
	ids_glosa.Object.cantidad			  [ll_ins_ds] = adw_detail.Object.cantidad		  	 	[al_row]
	ids_glosa.Object.importe			  [ll_ins_ds] = adw_detail.Object.precio_unitario	 	[al_row]
ELSEIF as_flag_cxc_cxp = 'P' THEN 
	//Cuenta Por pagar
	ids_glosa.Object.fecha_vencimiento 	[ll_ins_ds] = adw_master.Object.vencimiento 		 	[1]
	ids_glosa.Object.forma_pago		  	[ll_ins_ds] = adw_master.Object.forma_pago 		 	[1]
	ids_glosa.Object.fecha_emision		[ll_ins_ds] = adw_master.Object.fecha_emision		[1]
	ids_glosa.Object.observacion		 	[ll_ins_ds] = Mid(adw_master.Object.descripcion		[1],1,100)
	ids_glosa.Object.item					[ll_ins_ds] = adw_detail.Object.item				  	[al_row]
	ids_glosa.Object.cantidad			 	[ll_ins_ds] = adw_detail.Object.cantidad		  	 	[al_row]
	ids_glosa.Object.importe				[ll_ins_ds] = adw_detail.Object.importe		  	  	[al_row]
	ids_glosa.Object.total				 	[ll_ins_ds] = adw_detail.Object.total			  	 	[al_row]
	ids_glosa.Object.cencos				 	[ll_ins_ds] = adw_detail.Object.cencos			  	 	[al_row]
	ids_glosa.Object.cnta_prsp			 	[ll_ins_ds] =	adw_detail.Object.cnta_prsp		  	[al_row]
	ids_glosa.Object.tipo_cred_fiscal	[ll_ins_ds] = adw_detail.Object.tipo_cred_fiscal	[al_row]
END IF	

return true

end function

public subroutine of_glosa_cb (u_dw_abc adw_1, u_dw_abc adw_2, datastore ads_1, long al_row_cab, long al_row_det, string as_cnta_cntbl, string as_desc_cnta);/****************************************************/
/*LLenado de Datastore 										 */
/* adw_1 = Cabecera de Caja Bancos					    */
/* adw_2 = Detalle  de Caja Bancos                  */
/* ads_1 = Datastore de Datos Para Glosa				 */
/* al_row_cab = Linea de Cabecera de Caja Bancos	 */
/* al_row_det = Linea de Detalle de Caja Bancos  	 */
/****************************************************/
Long   ll_ins_ds

ads_1.Reset()

ll_ins_ds = ads_1.InsertRow(0)
ads_1.Object.origen			   [ll_ins_ds] = adw_1.Object.origen 				[al_row_cab]
ads_1.Object.nro_registro     [ll_ins_ds] = adw_1.Object.nro_registro 	 	[al_row_cab]
ads_1.Object.flag_estado	   [ll_ins_ds] = adw_1.Object.flag_estado 		[al_row_cab]
ads_1.Object.fecha_emision	 	[ll_ins_ds] = adw_1.Object.fecha_emision 	[al_row_cab]
ads_1.Object.fecha_programada [ll_ins_ds] = adw_1.Object.fecha_programada	[al_row_cab]
ads_1.Object.flag_pago		   [ll_ins_ds] = adw_1.Object.flag_pago	 		[al_row_cab]
ads_1.Object.cod_moneda		 	[ll_ins_ds] = adw_1.Object.cod_moneda 	 	[al_row_cab]
ads_1.Object.cod_usr			 	[ll_ins_ds] = adw_1.Object.cod_usr 		 	[al_row_cab]
ads_1.Object.tasa_cambio      [ll_ins_ds] = adw_1.Object.tasa_cambio 		[al_row_cab]
ads_1.Object.obs					[ll_ins_ds] = adw_1.Object.obs		 		 	[al_row_cab] 
ads_1.Object.imp_total			[ll_ins_ds] = adw_1.Object.imp_total 		 	[al_row_cab] 
ads_1.Object.cod_ctabco		 	[ll_ins_ds] = adw_1.Object.cod_ctabco			[al_row_cab]
ads_1.Object.cod_relacion		[ll_ins_ds] = adw_2.Object.cod_relacion		[al_row_det]
ads_1.Object.tipo_doc			[ll_ins_ds] = adw_2.Object.tipo_doc		 	[al_row_det]
ads_1.Object.nro_doc			 	[ll_ins_ds] = adw_2.Object.nro_doc		 		[al_row_det]
ads_1.Object.importe			 	[ll_ins_ds] = adw_2.Object.importe		 		[al_row_det]
ads_1.Object.cnta_ctbl			[ll_ins_ds] = as_cnta_cntbl
ads_1.Object.desc_cnta			[ll_ins_ds] = as_desc_cnta


end subroutine

public function boolean of_glosa_ncp_ndp (u_dw_abc adw_master, u_dw_abc adw_detail, long al_row, str_cnta_cntbl astr_cnta);/****************************************************/
/*LLenado de Datastore en Caso de Notas x Pagar	    */
/* adw_master = Cabecera de Notas de Cntas_Pagar		    */
/* adw_detail = Detalle  de Notas de Cntas_Pagar         */
/* ids_glosa = Datastore de Datos Para Glosa		 		 */
/* al_row = Linea de Detalle de cntas_pagar	    */
/****************************************************/
Long   ll_row

ids_glosa.Reset()

ll_row = ids_glosa.InsertRow(0)

/*Cabecera*/
ids_glosa.Object.cod_relacion    	[ll_row] = adw_master.object.cod_relacion   	[1] 	 
ids_glosa.Object.tipo_doc		    	[ll_row] = adw_master.object.tipo_doc	    	[1] 	  	
ids_glosa.Object.nro_doc			  	[ll_row] = adw_master.object.nro_doc		   [1] 	 
ids_glosa.Object.cod_moneda		  	[ll_row] = adw_master.object.cod_moneda	   [1] 	 	
ids_glosa.Object.tasa_cambio	  	 	[ll_row] = adw_master.object.tasa_cambio    	[1] 	 
ids_glosa.Object.ano				  	 	[ll_row] = adw_master.object.ano			    	[1] 	 	
ids_glosa.Object.mes				  	 	[ll_row] = adw_master.object.mes			    	[1] 	 	
ids_glosa.Object.nro_libro		  	 	[ll_row] = adw_master.object.nro_libro	    	[1] 	 	 
ids_glosa.Object.nro_asiento	  	 	[ll_row] = adw_master.object.nro_asiento    	[1] 	 	
ids_glosa.Object.origen			  	 	[ll_row] = adw_master.object.origen		    	[1] 	
ids_glosa.Object.fecha_registro  	[ll_row] = adw_master.object.fecha_registro 	[1] 	
ids_glosa.Object.fecha_emision		[ll_row] = adw_master.object.fecha_emision  	[1]  
ids_glosa.Object.fecha_vencimiento 	[ll_row] = adw_master.object.vencimiento	 	[1]  
ids_glosa.Object.forma_pago			[ll_row] = adw_master.object.forma_pago		[1]  
ids_glosa.Object.total_pagar		 	[ll_row] = adw_master.object.total_pagar	 	[1] 	
ids_glosa.Object.observacion		 	[ll_row] = Mid(adw_master.object.descripcion	[1] ,1,100)	
ids_glosa.Object.motivo				 	[ll_row] = adw_master.object.motivo			 	[1]
ids_glosa.Object.nom_proveedor	   [ll_row] = adw_master.object.nom_proveedor  	[1]

/* Cuenta */
ids_glosa.Object.cnta_ctbl		    	[ll_row] = astr_cnta.cnta_cntbl
ids_glosa.Object.desc_cnta		    	[ll_row] = Mid(astr_cnta.desc_cnta,1,100)
/**/

ids_glosa.Object.item					[ll_row] = adw_detail.object.item 					[al_row]
ids_glosa.Object.cod_art				[ll_row] = adw_detail.object.cod_art     			[al_row]	
ids_glosa.Object.descripcion		 	[ll_row] = adw_detail.object.descripcion 			[al_row]
ids_glosa.Object.cantidad			 	[ll_row] = adw_detail.object.cantidad    			[al_row]
ids_glosa.Object.importe				[ll_row] = adw_detail.object.importe     			[al_row]
ids_glosa.Object.cencos				 	[ll_row] = adw_detail.object.cencos		 			[al_row]
ids_glosa.Object.cnta_prsp			 	[ll_row] = adw_detail.object.cnta_prsp	 			[al_row]	
ids_glosa.Object.tipo_cred_fiscal	[ll_row] = adw_detail.object.tipo_cred_fiscal 	[al_row]

return true

end function

public function boolean of_generar_asiento_ncp_ndp (u_dw_abc adw_master, u_dw_abc adw_detail, u_dw_abc adw_referencias, u_dw_abc adw_impuestos, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, tab at_tab1);Long    			ll_inicio,ll_row_ins,ll_imatriz,ll_found,ll_j,ll_found_imp
Integer 			li_pos = 1, li_pos_ini , li_pos_fin , li_cont ,li_item
String  			ls_confin,ls_matriz,ls_cnta_ctbl, &
		  			ls_expresion,ls_formula,ls_glosa_campo,ls_glosa_texto,ls_campo,&
		  			ls_expresion_form,ls_signo,ls_desc_glosa,ls_tipo_doc,ls_nro_doc,&
		  			ls_cod_relacion,ls_motivo,ls_moneda, ls_mensaje, ls_cencos, &
					ls_centro_benef
String  			ls_armado[],ls_inicio[]
Decimal 			ldc_monto,ldc_monto_imp,ldc_importe_imp, ldc_tasa_cambio

str_cnta_cntbl	lstr_cnta
str_parametros	lstr_param


ls_motivo 		 = adw_master.object.motivo       		[1]
ls_moneda 		 = adw_master.object.cod_moneda   		[1]
ldc_tasa_cambio = Dec(adw_master.object.tasa_cambio  	[1])
ls_cod_relacion = adw_master.object.cod_relacion 		[1]
ls_tipo_doc		 = adw_master.object.tipo_doc     		[1]
ls_nro_doc		 = adw_master.object.nro_doc      		[1]

DO WHILE adw_asiento_det.Rowcount() > 0
	adw_asiento_det.deleterow(0)
	adw_asiento_det.ii_update = 1
LOOP

For ll_inicio = 1 TO adw_detail.Rowcount()
	/*Inicialización de Variables*/
	ls_confin 	= adw_detail.object.confin 			[ll_inicio]	
	li_item	 	= Integer(adw_detail.object.item   	[ll_inicio])
	
	IF Isnull(ls_confin) OR Trim(ls_confin) = '' THEN
		Messagebox('Item Nº '+String(li_item) ,'Item No se Ha ingresado Concepto Financiero', StopSign!)
		adw_asiento_det.Reset()
		at_tab1.SelectedTab = 1
		return false
	end if
	
	//Insercion de Cuentas dependiendo de la Matriz Contable
	ls_matriz = adw_detail.object.matriz_cntbl[ll_inicio]
	IF Isnull(ls_matriz) OR Trim(ls_matriz) = ''  THEN
	 	Messagebox('Aviso','Concepto Financiero Nº '+ls_confin+' No se ha Vinculado Matriz', StopSign!)
	 	adw_asiento_det.Reset()
	 	at_tab1.SelectedTab = 1
	 	return false
	END IF
							
	ids_matriz_cntbl.Retrieve(ls_matriz) // Recuperación de Información de Matriz Detalle
		 
	FOR ll_imatriz = 1 TO ids_matriz_cntbl.Rowcount()
		/**Inicializacion de Variables**/
		ls_armado = ls_inicio
		
		ldc_monto   	= 0.00
		ldc_monto_imp 	= 0.00
		li_pos 	    	= 1
		li_pos_ini  	= 0
		li_pos_fin  	= 0
		li_cont   	 	= 0
		
		ls_cnta_ctbl   			= ids_matriz_cntbl.Object.cnta_ctbl   [ll_imatriz]
		lstr_cnta.desc_cnta		= ids_matriz_cntbl.Object.desc_cnta   [ll_imatriz]
		lstr_param.flag_debhab 	= ids_matriz_cntbl.Object.flag_debhab [ll_imatriz]
			  
		if trim(ls_tipo_doc) = trim(gnvo_app.is_doc_ncp) or trim(ls_tipo_doc) = trim(gnvo_app.is_doc_cnc) then
			if lstr_param.flag_debhab = "D" then
				lstr_param.flag_debhab = "H"
			else
				lstr_param.flag_debhab = "D"
			end if
		end if

		ls_formula     = ids_matriz_cntbl.Object.formula 	 	[ll_imatriz]
		ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo 	[ll_imatriz]
		ls_glosa_texto = ids_matriz_cntbl.Object.glosa_texto 	[ll_imatriz]
						 
		/***************************************************/
		/*Asignación de Información requerida x Cta Cntbl */
		/***************************************************/
		if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then return false
		
		//Centro de Costo
		IF lstr_cnta.flag_cencos = '1' THEN
		  	IF adw_detail.of_ExisteCampo('cencos') THEN  
			  	lstr_param.cencos = adw_detail.object.cencos [ll_inicio] 		 
		  	ELSE															  
			  	SetNull(lstr_param.cencos)
		  	END IF
			
			if IsNull(lstr_param.cencos) or lstr_param.cencos = '' then
				ROLLBACK;
				MessageBox('Error', "La Cuenta " + ls_cnta_ctbl + " pide centro de costo, pero no se ha indicado ningun centro de costo." &
								+ "~r~nMatriz: " + ls_matriz &
								+ "Item: " + string(li_item))
				return false
			end if
		ELSE
		  	SetNull(lstr_param.cencos)
		END IF
				  
				  
		//Centro de Beneficio
		IF lstr_cnta.flag_centro_benef = '1' THEN  
			IF adw_detail.of_ExisteCampo('centro_benef') THEN  
			  	lstr_param.centro_benef = adw_detail.object.centro_benef [ll_inicio] 		 
		  	ELSE															  
			  	SetNull(lstr_param.centro_benef)
		  	END IF
			
			if IsNull(lstr_param.centro_benef) or lstr_param.centro_benef = '' then
				ROLLBACK;
				MessageBox('Error', "La Cuenta " + ls_cnta_ctbl + " pide centro de Beneficio, pero no se ha indicado ningun Centro de Beneficio en el detalle del documento. Por favor verifique" &
								+ "~r~nMatriz: " + ls_matriz &
								+ "Item: " + string(li_item))
				return false
			end if
		else
			SetNull(lstr_param.centro_benef)
		END IF
		
		//Documento de Referencia
		IF lstr_cnta.flag_doc_ref = '1' THEN
			if ids_matriz_cntbl.object.flag_tip_ref[ll_imatriz] = 'O' then
				
				//Documento Origen
				lstr_param.tipo_docref1 	= ls_tipo_doc
				lstr_param.nro_docref1		= ls_nro_doc
				
			elseif ids_matriz_cntbl.object.flag_tip_ref[ll_imatriz] = 'R' then
				
				//Primero la referencia del documento
				if adw_detail.of_existeCampo("doc_oc") and adw_detail.of_existeCampo("nro_oc") &
					and not IsNull(adw_detail.object.nro_oc [ll_inicio]) &
					and not IsNull(adw_detail.object.doc_oc [ll_inicio])  then
					
					lstr_param.tipo_docref1 = adw_detail.object.doc_oc 	[ll_inicio]
					lstr_param.nro_docref1  = adw_detail.object.nro_oc 	[ll_inicio]
					
				elseif adw_referencias.RowCount() > 0 then
					
					//Documento de Referencia
					lstr_param.tipo_docref1 = adw_referencias.object.tipo_ref 	[1]
					lstr_param.nro_docref1  = adw_referencias.object.nro_ref 	[1]
					
				else
					
					SetNull(lstr_param.tipo_docref1)
					SetNull(lstr_param.nro_docref1)
					
				end if
			else
				
				MessageBox('Error', 'Tipo de referencia en detalle de Matriz contable ' + ls_matriz &
					+ ' es incorecta. Tipo de Referencia: ' &
					+ String(ids_matriz_cntbl.object.flag_tip_ref[ll_imatriz]), StopSign!)
					
				return false
			end if
			
			if IsNull(lstr_param.tipo_docref1) or lstr_param.tipo_docref1 = '' or IsNull(lstr_param.nro_docref1) or lstr_param.nro_docref1 = '' then
				ROLLBACK;
				if ids_matriz_cntbl.object.flag_doc_ref[ll_inicio] = 'O' then
					ls_mensaje = "La Cuenta " + ls_cnta_ctbl + " pide Documento de Referencia, sin embargo en el detalle no hay documento. Por favor verifique"
				else
					ls_mensaje = "La Cuenta " + ls_cnta_ctbl + " pide Documento de Referencia, sin embargo no existe documento de referencia. Por favor verifique"
				end if
				MessageBox('Error',  ls_mensaje &
								+ "~r~nMatriz: " + ls_matriz &
								+ "Item: " + string(li_item))
				return false
			end if
		else
			SetNull(lstr_param.tipo_docref1)
			SetNull(lstr_param.nro_docref1)
		END IF
		
		//Codigo de Relacion
		IF lstr_cnta.flag_codrel = '1' THEN
			if ids_matriz_cntbl.object.flag_doc_ref[ll_imatriz] = 'O' then
				//Documento Origen
				lstr_param.cod_relacion 	= ls_cod_relacion
			else
				//Documento de Referencia
				if adw_referencias.RowCount() > 0 then
					lstr_param.cod_relacion = adw_referencias.object.proveedor_ref [1]
				else
					SetNull(lstr_param.cod_relacion)
				end if
				
			end if
			
			if IsNull(lstr_param.cod_relacion) or lstr_param.cod_relacion = ''  then
				ROLLBACK;
				if ids_matriz_cntbl.object.flag_doc_ref[ll_inicio] = 'O' then
					ls_mensaje = "La Cuenta " + ls_cnta_ctbl + " pide Codigo de Relación sin embargo en el detalle no hay código de Relacion. Por favor verifique"
				else
					ls_mensaje = "La Cuenta " + ls_cnta_ctbl + " pide Código de Relación, sin embargo no existe en la referencia. Por favor verifique"
				end if
				MessageBox('Error',  ls_mensaje &
								+ "~r~nMatriz: " + ls_matriz &
								+ "Item: " + string(li_item))
				return false
			end if
		else
			SetNull(lstr_param.cod_relacion)
		END IF

		/**/
		/**Formula**/
		li_cont = 0
		li_pos_ini     = Pos(ls_formula,'[',li_pos) 
		
		IF li_pos_ini = 1 THEN       /*Formula Pura */
			ldc_monto  = 0.00
		ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
			ls_campo = Mid(ls_formula,1,li_pos_ini - 2)
			if not adw_detail.of_ExisteCampo(ls_campo) then
				ROLLBACK;
				MessageBox('Error', "Error en la formula de la matriz, esta solicitando datos del campo " &
								+ ls_campo + " el cual no existe en el detalle del documento. Por favor verifique" &
								+ "~r~nMatriz: " + ls_matriz &
								+ "Item: " + string(li_item))
				return false
			end if
			ldc_monto  = adw_detail.Getitemnumber(ll_inicio,ls_campo)
		ELSEIF li_pos_ini = 0 THEN	  /*Campo*/
			ldc_monto  = adw_detail.Getitemnumber(ll_inicio,ls_formula)
		END IF
							  
							  
		DO WHILE li_pos_ini > 0
			li_cont ++
			li_pos_fin = Pos(ls_formula,']',li_pos_ini) 
			if li_pos_fin > 0 then
				ls_armado [li_cont] = Mid(ls_formula,li_pos_ini + 1,li_pos_fin - (li_pos_ini + 1))
			else
				MessageBox('Error', "Error en la formula de la matriz, por favor revise los campos de impuestos y corrijalos de ser necesarios." &
								+ "~r~nFormula: " + ls_formula &
								+ "~r~nMatriz: " + ls_matriz &
								+ "Item: " + string(li_item))
				return false
			end if
			//Inicializa Valor
			li_pos_ini = Pos(ls_formula,'[',li_pos_fin) 
		LOOP
							  
		/*****Calculo de Monto si existiese Formula*****/
		IF UpperBound(ls_armado) > 0 THEN
			
			For ll_j = 1 TO UpperBound(ls_armado)
				 /*Inicializa Monto de Impuesto*/
				 ls_expresion_form	= "item = " + Trim(String(li_item)) + " AND  tipo_impuesto = '"+ls_armado[ll_j]+"'"
				 ll_found_imp = adw_impuestos.find(ls_expresion_form,1,adw_impuestos.Rowcount())
		
				 IF ll_found_imp > 0 THEN
					 ls_signo 		  = adw_impuestos.object.signo 	 		[ll_found_imp] 	
					 ldc_importe_imp = Dec(adw_impuestos.object.importe 	[ll_found_imp])
					 
					 IF ls_signo   = '+' THEN
						 ldc_monto_imp += ldc_importe_imp
					 ELSEIF ls_signo = '-'	THEN
						 ldc_monto_imp -= - ldc_importe_imp
					 END IF
					 
				 END IF
			Next
			
			ldc_monto = (ldc_monto + ldc_monto_imp)
		END IF
			  
			  
		/*Función de llenado de datastore*/
		this.of_glosa_ncp_ndp(adw_master,adw_detail, ll_inicio, lstr_cnta)
		/**/
		ls_expresion 	= this.of_generar_expresion( lstr_cnta, lstr_param )
		ll_found       = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
			  
		/****/
		IF ll_found = 0 THEN
		  	/*Extraer Glosa*/
		  	ls_desc_glosa = invo_asiento_glosa.of_set_glosa(ids_glosa,1,ls_glosa_texto,ls_glosa_campo)
		  	ll_row_ins    = adw_asiento_det.event ue_insert()
			if ll_row_ins > 0 then
				adw_asiento_det.Object.item		   [ll_row_ins] = ll_row_ins
			  	adw_asiento_det.Object.cnta_ctbl    [ll_row_ins] = ls_cnta_ctbl
			  	adw_asiento_det.Object.flag_debhab  [ll_row_ins] = lstr_param.flag_debhab
			  	adw_asiento_det.Object.det_glosa    [ll_row_ins] = Mid(ls_desc_glosa,1,100)
			  	adw_asiento_det.Object.cencos		   [ll_row_ins] = lstr_param.cencos
			  	adw_asiento_det.Object.centro_benef [ll_row_ins] = lstr_param.centro_benef
				adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
			  	adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = lstr_param.tipo_docref1
				adw_asiento_det.Object.nro_docref1  [ll_row_ins] = lstr_param.nro_docref1
							  
			  /*Montos de Pre Asientos*/
			  IF ls_moneda = gnvo_app.is_soles THEN
				  adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
				  adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_tasa_cambio,2)
			  ELSEIF ls_moneda = gnvo_app.is_dolares THEN
				  adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
				  adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_tasa_cambio,2)					
			  END IF
			end if
		ELSE
		  IF ls_moneda = gnvo_app.is_soles THEN
			  adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
			  adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_tasa_cambio,2)
		  ELSEIF ls_moneda = gnvo_app.is_dolares THEN
			  adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
			  adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_tasa_cambio,2)					
		  END IF
		END IF
			  
	Next  //Registro de Matriz Contable
	 
Next  //Registro de detalle Cntas x Pagar
			
	
//Ahora proceso los impuestos
FOR ll_inicio = 1 TO adw_impuestos.Rowcount()

	ls_cnta_ctbl    			=	adw_impuestos.Object.cnta_ctbl   	[ll_inicio]
	IF Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '' THEN
		Messagebox('Fila de Impuestos Nº '+String(ll_inicio) ,' No se Ha ingresado Cuenta Contable de Impuesto')
		adw_asiento_det.Reset()
		adw_impuestos.SetRow(ll_inicio)
		at_tab1.SelectedTab = 3
		return false
	END IF

	IF Isnull(lstr_param.flag_debhab) OR Trim(lstr_param.flag_debhab) = '' THEN
		Messagebox('Fila de Impuestos Nº '+String(ll_inicio) ,' No se Ha ingresado Flag de Debe ó Haber de Impuesto')
		adw_asiento_det.Reset()
		adw_impuestos.SetRow(ll_inicio)
		at_tab1.SelectedTab = 3
		return false
	END IF

	li_item			 			= adw_impuestos.Object.item  	    	[ll_inicio]
	lstr_param.flag_debhab  = adw_impuestos.object.flag_dh_cxp 	[ll_inicio]				
	lstr_cnta.desc_cnta 		= adw_impuestos.object.desc_cnta	 	[ll_inicio]
	ldc_importe_imp 			= Dec(adw_impuestos.Object.importe 	[ll_inicio])
	
	//Ubico el Item correspondiente en el Detalle del Documento
	ls_expresion = "item=" + string(li_item)
	ll_found = adw_detail.find(ls_expresion, 1, adw_detail.RowCount())
	
	if ll_found = 0 then
		Messagebox("Error" ,"Item " + string(li_item) + " de impuestos no existe en el detalle del documento, por favor verifique!")
		adw_asiento_det.Reset()
		adw_impuestos.SetRow(ll_inicio)
		adw_detail.SetFocus()
		at_tab1.SelectedTab = 1
		return false
	end if
	
	//Obtengo los parametros de la cuenta contable
	if not invo_cntbl.of_cnta_cntbl( ls_cnta_ctbl, lstr_cnta ) then return false
	
	//Centro de Costo
	IF lstr_cnta.flag_cencos = '1' THEN
		IF adw_detail.of_ExisteCampo('cencos') THEN  
			lstr_param.cencos = adw_detail.object.cencos [ll_found] 		 
		ELSE															  
			SetNull(lstr_param.cencos)
		END IF
		
		if IsNull(lstr_param.cencos) or lstr_param.cencos = '' then
			ROLLBACK;
			MessageBox('Error', "La Cuenta " + ls_cnta_ctbl + " pide centro de costo, pero no se ha indicado ningun centro de costo." &
							+ "~r~nMatriz: " + ls_matriz &
							+ "Item: " + string(li_item))
			return false
		end if
	ELSE
		SetNull(lstr_param.cencos)
	END IF
		  
		  
	//Centro de Beneficio
	IF lstr_cnta.flag_centro_benef = '1' THEN  
		IF adw_detail.of_ExisteCampo('centro_benef') THEN  
			lstr_param.centro_benef = adw_detail.object.centro_benef [ll_found] 		 
		ELSE															  
			SetNull(lstr_param.centro_benef)
		END IF
		
		if IsNull(lstr_param.centro_benef) or lstr_param.centro_benef = '' then
			ROLLBACK;
			MessageBox('Error', "La Cuenta " + ls_cnta_ctbl + " pide centro de Beneficio, pero no se ha indicado ningun Centro de Beneficio en el detalle del documento. Por favor verifique" &
							+ "~r~nMatriz: " + ls_matriz &
							+ "Item: " + string(li_item))
			return false
		end if
	else
		SetNull(lstr_param.centro_benef)
	END IF
	
	//Documento de Referencia
	IF lstr_cnta.flag_doc_ref = '1' THEN
		//Documento Origen
		lstr_param.tipo_docref1 	= ls_tipo_doc
		lstr_param.nro_docref1		= ls_nro_doc
	
		if IsNull(lstr_param.tipo_docref1) or lstr_param.tipo_docref1 = '' or IsNull(lstr_param.nro_docref1) or lstr_param.nro_docref1 = '' then
			ROLLBACK;
			ls_mensaje = "La Cuenta " + ls_cnta_ctbl + " pide Documento de Referencia, sin embargo en el detalle no hay documento. Por favor verifique"
			MessageBox('Error',  ls_mensaje &
							+ "~r~nMatriz: " + ls_matriz &
							+ "Item: " + string(li_item))
			return false
		end if
	else
		SetNull(lstr_param.tipo_docref1)
		SetNull(lstr_param.nro_docref1)
	END IF
	
	//Codigo de Relacion
	IF lstr_cnta.flag_codrel = '1' THEN
		//Documento Origen
		lstr_param.cod_relacion 	= ls_cod_relacion
	
		if IsNull(lstr_param.cod_relacion) or lstr_param.cod_relacion = ''  then
			ROLLBACK;
			ls_mensaje = "La Cuenta " + ls_cnta_ctbl + " pide Codigo de Relación sin embargo en el detalle no hay código de Relacion. Por favor verifique"
			MessageBox('Error',  ls_mensaje &
							+ "~r~nMatriz: " + ls_matriz &
							+ "Item: " + string(li_item))
			return false
		end if
	else
		SetNull(lstr_param.cod_relacion)
	END IF

	
	IF trim(ls_tipo_doc)="NCP" then
		if lstr_param.flag_debhab = "D" then
			lstr_param.flag_debhab = "H"
		else
			lstr_param.flag_debhab = "D"
		end if
	end if
	
	//Ahora Busco la cuenta en el detalle del asiento, generando la expresión de busqueda
	ls_expresion	 = this.of_generar_expresion( lstr_cnta, lstr_param )
	ll_found        = adw_asiento_det.find(ls_expresion, 1, adw_asiento_det.rowcount())

	IF ll_found = 0 THEN
				
		ll_row_ins    = adw_asiento_det.event ue_insert()
		if ll_row_ins > 0 then
			adw_asiento_det.Object.item		  		[ll_row_ins] = ll_row_ins
			adw_asiento_det.Object.cnta_ctbl   		[ll_row_ins] = ls_cnta_ctbl
			adw_asiento_det.Object.flag_debhab 		[ll_row_ins] = lstr_param.flag_debhab
			adw_asiento_det.Object.det_glosa   		[ll_row_ins] = mID(lstr_cnta.desc_cnta,1,6100)
			adw_asiento_det.Object.cencos		   	[ll_row_ins] = lstr_param.cencos
			adw_asiento_det.Object.centro_benef 	[ll_row_ins] = lstr_param.centro_benef
			adw_asiento_det.Object.cod_relacion 	[ll_row_ins] = lstr_param.cod_relacion
			adw_asiento_det.Object.tipo_docref1 	[ll_row_ins] = lstr_param.tipo_docref1
			adw_asiento_det.Object.nro_docref1  	[ll_row_ins] = lstr_param.nro_docref1
				
			IF ls_moneda = gnvo_app.is_soles THEN
				adw_asiento_det.Object.imp_movsol 	[ll_row_ins] = ldc_importe_imp					
				adw_asiento_det.Object.imp_movdol 	[ll_row_ins] = Round(ldc_importe_imp / ldc_tasa_cambio,2)
			ELSEIF ls_moneda = gnvo_app.is_dolares THEN
				adw_asiento_det.Object.imp_movdol 	[ll_row_ins] = ldc_importe_imp
				adw_asiento_det.Object.imp_movsol	[ll_row_ins] = Round(ldc_importe_imp * ldc_tasa_cambio,2)					
			END IF
		end if
	ELSE
		IF ls_moneda = gnvo_app.is_soles THEN
			adw_asiento_det.Object.imp_movsol 	[ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_importe_imp
			adw_asiento_det.Object.imp_movdol 	[ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_importe_imp / ldc_tasa_cambio,2)
		ELSEIF ls_moneda = gnvo_app.is_dolares THEN
			adw_asiento_det.Object.imp_movdol 	[ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_importe_imp
			adw_asiento_det.Object.imp_movsol 	[ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_importe_imp * ldc_tasa_cambio,2)					
		END IF
	END IF
NEXT

return true
end function

public function boolean of_validar_asiento (u_dw_abc adw_asiento_det);// Funcion para validar que no grabe asientos descuadrados

decimal {2} ldc_tot_dol_h, ldc_tot_dol_d, ldc_tot_sol_d, ldc_tot_sol_h , &
				ldc_dif_dol, ldc_dif_sol
integer	ll_i

//Para validar Asiento

ldc_tot_dol_h = 0; ldc_tot_dol_d = 0;  ldc_tot_sol_d = 0; ldc_tot_sol_h = 0

IF gnvo_app.is_flag_val_asiento = '1' THEN
	FOR ll_i = 1 TO adw_asiento_det.rowcount()
		IF adw_asiento_det.object.flag_debhab[ll_i] = 'H' THEN
			ldc_tot_sol_h = ldc_tot_sol_h + Round(adw_asiento_det.object.imp_movsol[ll_i],2)
			ldc_tot_dol_h = ldc_tot_dol_h + Round(adw_asiento_det.object.imp_movdol[ll_i],2)
		ELSEIF adw_asiento_det.object.flag_debhab[ll_i] = 'D' THEN
			ldc_tot_sol_d = ldc_tot_sol_d + Round(adw_asiento_det.object.imp_movsol[ll_i],2)
			ldc_tot_dol_d = ldc_tot_dol_d + Round(adw_asiento_det.object.imp_movdol[ll_i],2)
		END IF
		
	NEXT
	
	ldc_dif_dol = ldc_tot_dol_h - ldc_tot_dol_d
	ldc_dif_sol = ldc_tot_sol_h - ldc_tot_sol_d
	
	IF ldc_dif_dol <> 0 THEN
		messagebox('DESCUADRE EN US$', 'DEBE ==> ' + string(ldc_tot_dol_d)  + ' HABER ==> ' + STRING(ldc_tot_dol_h))		
		return false
	ELSEIF ldc_dif_sol <> 0 THEN
		messagebox('DESCUADRE EN S/.', 'DEBE ==> ' + string(ldc_tot_sol_d)  + ' HABER ==> ' + STRING(ldc_tot_sol_h))	
		return false
	END IF

END IF

RETURN true



end function

public function boolean of_mes_cerrado (long al_year, long al_mes, string as_tipo);Long 		ll_count
String	ls_flag_reg_cntbl, 			ls_flag_mov_banco, 			ls_flag_cierre_mes,  		ls_flag_gen_asnt_autom, &
			ls_pd_campo,       			ls_pd_dma,         			ls_pd_mtto_fab,      		ls_pd_mtto_maq, &
			ls_flag_almacen

/* Retorna false, no debe grabar asiento,
  retorna true, debe grabar asiento */

/* as_tipo tiene los siguientes valores, para los siguientes casos:
  R = caso registros de compras y ventas,
  B = caso movimiento bancario (tesorería),
  M = cualquier asiento contable (por contabilidad) y
  A = para asientos contables por proceso
  L = Movimientos de almacen
  C = caso de inventarios -almacenes-
  D = ????????
  F = partes diarios relacionados a OT
  P = parte diario de mantenimiento de maquinarias
*/

SELECT count(*)
  INTO :ll_count
  FROM cntbl_cierre
 WHERE ano = :al_year
   and mes = :al_mes ;

if ll_count = 0 then
	ROLLBACK;
	return true
end if

SELECT 	NVL(flag_reg_cntbl,'0'),	NVL(flag_mov_banco,'0'),	NVL(flag_cierre_mes,'0'),	NVL(flag_gen_asnt_autom,'0'),
			NVL(pd_campo, '0'),			NVL(pd_dma,'0'),				NVL(pd_mtto_fab, '0'),		NVL(pd_mtto_maq, '0'),
			NVL(flag_almacen, '0')
  INTO   :ls_flag_reg_cntbl, 			:ls_flag_mov_banco, 			:ls_flag_cierre_mes,  		:ls_flag_gen_asnt_autom,
			:ls_pd_campo,       			:ls_pd_dma,         			:ls_pd_mtto_fab,      		:ls_pd_mtto_maq,
			:ls_flag_almacen
  FROM   cntbl_cierre
 WHERE  ano = :al_year
   and  mes = :al_mes ;
	
if ls_flag_cierre_mes = '0' then
	ROLLBACK;
	return true
end if

/* Movimientos de almacen */
IF as_tipo='L' and ls_flag_almacen = '1' then
	ROLLBACK;
	return true
end if


/* Registros contables, libros 3 y 4 */
IF as_tipo='R' and ls_flag_reg_cntbl = '0' then
	ROLLBACK;
	return true
end if

/* Movimientos bancarios, libros 7 y 8 */
IF as_tipo='B' and ls_flag_mov_banco = '0' then
	ROLLBACK;
	return true
end if

/* Asientos contables generados por procesos */
IF as_tipo='A' and ls_flag_gen_asnt_autom = '0' then
	ROLLBACK;
	return true
end if

/* Asientos contables generados por almacen */
IF as_tipo='A' and ls_flag_gen_asnt_autom = '0' then
	ROLLBACK;
	return true
end if


RETURN false

end function

public function boolean of_existe_mes_cntbl (long al_year, long al_mes);Long 		ll_count

/* Retorna false, no debe grabar asiento,
  retorna true, debe grabar asiento */


SELECT count(*)
  INTO :ll_count
  FROM cntbl_cierre
 WHERE ano = :al_year
   and mes = :al_mes ;

if ll_count = 0 then
	MessageBox("Error", "Periodo contable: " + string(al_year, '0000') + "/" + string(al_mes, '00') + " no existe o no ha sido aperturado, por favor coordinar con contabilidad")
	return false
end if

return true
end function

public function boolean of_generar_asiento_liq_og (u_dw_abc adw_master, u_dw_abc adw_detail, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, tab at_tab1, str_parametros astr_param) throws exception;String 	ls_cnta_ctbl_ref   ,ls_det_glosa_ref   ,ls_flag_debhab_ref ,ls_cencos_ref        ,&
		 	ls_cod_ctabco_ref  ,ls_cod_relacion_sg ,ls_nro_doc_sg	   ,ls_moneda_sg		    ,&
		 	ls_moneda			  ,ls_cod_relacion    ,ls_tipo_doc			,ls_nro_doc			    ,&
		 	ls_cencos			  ,ls_matriz		    ,ls_desc_cnta		   ,ls_flag_debhab	    ,&
		 	ls_expresion		  ,ls_formula		    ,ls_glosa_campo	   ,ls_glosa_texto	    ,&
	 	 	ls_campo			  ,ls_expresion_form  ,ls_signo				,ls_desc_glosa		    ,&
		 	ls_cnta_ctbl_sg    ,ls_moneda_det	    ,ls_det_glosa_sg	   ,ls_flag_debhab_sg    ,&
		 	ls_cencos_sg		  ,ls_cnta_ctbl_dif   ,ls_flag_debhab_dif ,ls_flag_debhab_og_dif,&
		 	ls_doc_cegreso	  ,ls_flag_tipo_gasto ,ls_flag_retec		,ls_flag_ret			 ,&
		 	ls_nro_retencion   ,ls_confin			 ,&
		 	ls_flab_tabor		  ,ls_msj_err			 ,ls_cebef				,ls_centro_benef		 ,&
		 	ls_descripcion_cab ,ls_origen, ls_mensaje		
		 
String 	ls_armado[] ,ls_inicio[],ls_cnta_ctbl,ls_cod_ctabco_sg, ls_descripcion, ls_flag_debhab_dif_doc, &
			ls_det_glosa

Long   	ll_inicio    ,ll_count,ll_row_ins,ll_imatriz,ll_found,ll_inicio_for,ll_found_imp,&
		 	ll_nro_reg_cb,ll_item ,ll_inicio_imp,ll_inicio_cebef, ll_year, ll_mes, ll_nro_libro
		 
Integer 	li_item,li_pos,li_pos_ini,li_pos_fin,li_cont

Boolean 	lb_gen_dif = FALSE,lb_ajust_x_conv = FALSE

Date 		ld_cierre_og
Decimal 	ldc_tasa_cambio_liq		,ldc_tasa_cambio		,ldc_tasa_cambio_sg	,ldc_tasa_cambio_det, &
			ldc_importe        	   ,ldc_importe_sol     ,ldc_monto				,&
			ldc_importe_dol           ,ldc_monto_imp       ,ldc_importe_imp     ,&
			ldc_saldo_sol           ,ldc_saldo_dol       ,ldc_imp_docs        ,&
			ldc_total_sol   ,&
			ldc_dif_x_cambio        ,ldc_total_dol			, &
			ldc_total_og_sol			,ldc_total_og_dol		, &
			ldc_monto_diferencia		,ldc_monto_diferencia_sol,&
			ldc_monto_diferencia_dol,ldc_total_imp_sol_hab  ,ldc_total_imp_sol_deb	 ,ldc_imp_movsol_hab		    ,ldc_imp_movsol_deb  ,ldc_imp_ret_sol			  ,&	
			ldc_imp_ret_dol			,ldc_imp_ret 
			
DateTime	ldt_fec_registro

str_cnta_cntbl	lstr_cnta
str_parametros	lstr_param
				
//Declarar DataStore
u_ds_base 	lds_cbenef

try 
	/*Datastore de Centro de Beneficio*/
	lds_cbenef 			   = Create u_ds_base
	lds_cbenef.DataObject = 'd_abc_montos_x_cbenef_tbl'
	lds_cbenef.SettransObject(sqlca)
	
	/* CAmbio el objeto datawindows del DataStore */
	ids_glosa.DataObject = 'd_data_glosa_liquidacion'
	ids_glosa.SettransObject(sqlca)
				
				
	adw_master.Accepttext()
	adw_detail.Accepttext()

	DO WHILE adw_asiento_det.Rowcount() > 0
		adw_asiento_det.deleterow(0)
	LOOP

	/*datos de cabecera de orden de giro*/
	ls_cod_relacion_sg	= adw_master.object.cod_relacion     		[1]
	ls_nro_doc_sg			= adw_master.object.nro_solicitud    		[1]
	ls_moneda_sg			= adw_master.object.cod_moneda	    		[1]
	ld_cierre_og  			= Date(adw_master.object.fecha_aprobacion [1])
	ls_descripcion			= adw_master.object.descripcion	    		[1]
	ls_origen				= adw_master.object.origen						[1]
	
	//ACtualizo la fecha de cierre solo como date
	adw_master.object.fecha_aprobacion [1] = ld_cierre_og

	/*TASA CAMBIO DEL DIA DE CIERRE DE LIQUIDACION*/
	ldc_tasa_cambio_liq =	gnvo_app.of_tasa_cambio( ld_cierre_og )
	
	//Fecha de registro
	ldt_fec_registro = gnvo_app.of_fecha_actual( )
	
	/**/ 
	
	/***************************************************************/
	/*Inserta Cabecera de Asiento de Solicitud de giro*/
	if adw_asiento_cab.RowCount() = 0 then
		ll_row_ins = adw_asiento_cab.event ue_insert()
	else
		ll_row_ins = adw_asiento_cab.GetRow()
	end if
	
	if ll_row_ins <= 0 then 
		MessageBox('Error', 'Ha ocurrido un Error al insertar la cabecera del asiento contable, por favor Verifique!', StopSign!)
		return false
	end if
	
	//Obtengo los datos 
	ll_nro_libro = astr_param.longa[1]
	ll_year		 = astr_param.longa[2]
	ll_mes		 = astr_param.longa[3]
	
	
	adw_asiento_cab.object.origen          [ll_row_ins] = ls_origen
	adw_asiento_cab.object.ano   	       	[ll_row_ins] = ll_year
	adw_asiento_cab.object.mes	          	[ll_row_ins] = ll_mes
	adw_asiento_cab.object.nro_libro       [ll_row_ins] = ll_nro_libro
	adw_asiento_cab.object.cod_moneda      [ll_row_ins] = ls_moneda_sg
	adw_asiento_cab.object.tasa_cambio     [ll_row_ins] = ldc_tasa_cambio_liq
	adw_asiento_cab.object.desc_glosa      [ll_row_ins] = ls_descripcion
	adw_asiento_cab.object.fec_registro    [ll_row_ins] = ldt_fec_registro 
	adw_asiento_cab.object.fecha_cntbl     [ll_row_ins] = ld_cierre_og 
	adw_asiento_cab.object.cod_usr         [ll_row_ins] = gs_user
	adw_asiento_cab.object.flag_estado     [ll_row_ins] = '1'	
	adw_asiento_cab.Object.flag_tabla 		[ll_row_ins] = '6'
	
	/*Activo update*/
	adw_asiento_cab.ii_update = 1
	/***************************************************************/

	/*************************************************************************/
	//Recorro el detalle de la liquidacion para Generar el asiento contable
	/*************************************************************************/
	FOR ll_inicio = 1 TO adw_detail.Rowcount()  
		/*Inicialización de Variables*/
		ls_confin  		  		= adw_detail.object.confin 	      [ll_inicio]	
		li_item	  		  		= adw_detail.object.item   	      [ll_inicio]	
		ls_moneda       		= adw_detail.object.cod_moneda      [ll_inicio]	
		ldc_tasa_cambio 		= adw_detail.object.tasa_cambio     [ll_inicio]	
		ls_cod_relacion 		= adw_detail.object.proveedor	      [ll_inicio]	
		ls_tipo_doc	  	 		= adw_detail.object.tipo_doc	      [ll_inicio]	
		ls_nro_doc		    	= adw_detail.object.nro_doc	      [ll_inicio]		
		ls_cencos				= adw_detail.object.cencos		      [ll_inicio]
		ldc_importe				= Dec(adw_detail.object.importe	   [ll_inicio])
		ls_flag_retec			= adw_detail.object.flag_ret_igv	   [ll_inicio]
		ldc_imp_ret 			= adw_detail.object.importe_ret_igv [ll_inicio]	 
		ls_nro_Retencion		= adw_detail.object.nro_retencion   [ll_inicio]	 
	 
		if ls_tipo_doc <> gnvo_app.is_doc_og then
			ls_flab_tabor = '3'	 
		end if

	 
		IF Isnull(ls_confin) OR Trim(ls_confin) = '' THEN
			gnvo_app.of_message_error('Error en Item Nº '+String(li_item) + ', No se ha especificado Concepto Financiero, por favor verifique!')
			at_tab1.SelectedTab = 1
			return false
		end if
		
		//Obtengo los importes en soles y dolares
		IF ls_moneda = gnvo_app.is_soles THEN
			ldc_importe_sol = ldc_importe
			ldc_importe_dol = Round(ldc_importe / ldc_tasa_cambio_liq,2)
		ELSEIF ls_moneda = gnvo_app.is_dolares THEN	 
			ldc_importe_dol = ldc_importe
			ldc_importe_sol = Round(ldc_importe * ldc_tasa_cambio_liq,2)					 
		END IF

		/*documento de provision*/
		SELECT Count(*)
		INTO :ll_count
		FROM cntas_pagar cp,
			  cntbl_asiento_det cad
		WHERE cp.cod_relacion 	= :ls_cod_relacion 
		  AND cp.tipo_doc	    	= :ls_tipo_doc		
		  AND cp.nro_doc		 	= :ls_nro_doc		
		  AND cp.origen       	= cad.origen        
		  AND cp.ano          	= cad.ano           
		  AND cp.mes          	= cad.mes     
		  and cad.flag_debhab	= 'H'
		  AND cp.nro_libro    	= cad.nro_libro     
		  AND cp.nro_asiento  	= cad.nro_asiento   
		  AND cp.cod_relacion 	= cad.cod_relacion  
		  AND cp.tipo_doc     	= cad.tipo_docref1  
		  AND cp.nro_doc      	= cad.nro_docref1;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQlErrText
			ROLLBACK;
			MessageBox('Error', "Ha ocurrido un error al obtener datos de la provision del documento. Por favor verifique!" &
									+ "~r~nCod Relacion: " + ls_cod_relacion &
									+ "~r~nTipo Documento: " + ls_tipo_doc &
									+ "~r~nNro Documento: " + ls_nro_doc &
									+ "~r~nMensaje: " + ls_mensaje, StopSign!)
			return false
		end if
			
	 
		IF ll_count > 0 THEN
			/*****************************************************************************/
			/*El documento esta provisionado, asi que no necesito recorrer ninguna matriz*/
			/*****************************************************************************/
			
			//El documento por pagar debe esta en el Debe
			SELECT cad.cnta_ctbl, cad.det_glosa ,cad.flag_debhab, cad.cencos   ,cad.cod_ctabco,
					 cad.centro_benef, cp.descripcion, cp.tasa_cambio
			  INTO :ls_cnta_ctbl_ref, :ls_det_glosa_ref , :ls_flag_debhab_ref, :ls_cencos_ref, 
					 :ls_cod_ctabco_ref, :ls_centro_benef, :ls_descripcion_cab, :ldc_tasa_cambio
			FROM 	cntas_pagar 		cp,
					cntbl_asiento_det cad
			WHERE cp.cod_relacion 	= :ls_cod_relacion 
			  AND cp.tipo_doc	  	 	= :ls_tipo_doc		
			  AND cp.nro_doc		 	= :ls_nro_doc		
			  AND cp.origen       	= cad.origen        
			  AND cp.ano          	= cad.ano           
			  AND cp.mes          	= cad.mes      
			  and cad.flag_debhab  	= 'H'       	 	
			  AND cp.nro_libro    	= cad.nro_libro     
			  AND cp.nro_asiento  	= cad.nro_asiento   
			  AND cp.cod_relacion 	= cad.cod_relacion  
			  AND cp.tipo_doc     	= cad.tipo_docref1  
			  AND cp.nro_doc      	= cad.nro_docref1;
			  
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQlErrText
				ROLLBACK;
				MessageBox('Error', "Ha ocurrido un error al obtener datos de la provision del documento. Por favor verifique!" &
										+ "~r~nCod Relacion: " + ls_cod_relacion &
										+ "~r~nTipo Documento: " + ls_tipo_doc &
										+ "~r~nNro Documento: " + ls_nro_doc &
										+ "~r~nMensaje: " + ls_mensaje, StopSign!)
				return false
			end if
			
			//SI el tipo de cambio es nulo entonces lo pongo en cero
			if IsNull(ldc_tasa_cambio) then ldc_tasa_cambio = 0
			
			if ldc_tasa_cambio = 0 then
				gnvo_app.of_mensaje_error( "No se ha especificado tasa de cambio en la provisión del documento. Por favor verifique!" &
										+"~r~nCod Relacion: " + ls_cod_relacion &
										+"~r~nTipo Documento: " + ls_tipo_doc &
										+"~r~nNro Documento: " + ls_nro_doc)
				return false
			end if
			
			/**/
			IF ls_flag_debhab_ref = 'D' THEN
				ls_flag_debhab_ref = 'H'
			ELSE
				ls_flag_debhab_ref = 'D'				 
			END IF
			/**/
			
			if ISNull(ls_det_glosa_ref) or trim(ls_det_glosa_ref) = '' then ls_det_glosa_ref = ls_descripcion_cab
			
			if ISNull(ls_det_glosa_ref) or trim(ls_det_glosa_ref) = '' then 
				select desc_cnta
					into :ls_det_glosa_ref
				from cntbl_cnta cc
				where cc.cnta_ctbl = :ls_cnta_ctbl_ref;
			end if
		
			 
			ll_row_ins = adw_asiento_det.event ue_insert()
			if ll_row_ins > 0 then
				adw_asiento_det.Object.origen 			[ll_row_ins] = ls_origen
				adw_asiento_det.Object.ano		 			[ll_row_ins] = ll_year
				adw_asiento_det.Object.mes 				[ll_row_ins] = ll_mes
				adw_asiento_det.Object.nro_libro 		[ll_row_ins] = ll_nro_libro
				adw_asiento_det.Object.item				[ll_row_ins] = ll_row_ins
				adw_asiento_det.Object.cnta_ctbl			[ll_row_ins] = ls_cnta_ctbl_ref
				adw_asiento_det.Object.fec_cntbl 		[ll_row_ins] = ld_cierre_og
				adw_asiento_det.Object.det_glosa			[ll_row_ins] = left(ls_det_glosa_ref,100)
				adw_asiento_det.Object.flag_debhab		[ll_row_ins] = ls_flag_debhab_ref
				adw_asiento_det.Object.cencos 			[ll_row_ins] = ls_cencos_ref
				adw_asiento_det.Object.centro_benef		[ll_row_ins] = ls_centro_benef
				adw_asiento_det.Object.cod_ctabco		[ll_row_ins] = ls_cod_ctabco_ref
				adw_asiento_det.Object.tipo_docref1		[ll_row_ins] = ls_tipo_doc
				adw_asiento_det.Object.nro_docref1 		[ll_row_ins] = ls_nro_doc
				adw_asiento_det.Object.cod_relacion		[ll_row_ins] = ls_cod_relacion
				adw_asiento_det.Object.imp_movsol  		[ll_row_ins] = ldc_importe_sol
				adw_asiento_det.Object.imp_movdol  		[ll_row_ins] = ldc_importe_dol
				adw_asiento_det.Object.flag		  		[ll_row_ins] = 'S'
				adw_asiento_det.Object.flag_edit  		[ll_row_ins] = 'E'
			end if

			/************************/
			/*Diferencia en Cambio  */
			/************************/
			IF ls_moneda = gnvo_app.is_dolares THEN /*SE REVISARA DIFERENCIA EN CAMBIO*/
				

				if ldc_tasa_cambio > 0 and ldc_tasa_cambio <> ldc_tasa_cambio_liq then
					if ldc_tasa_cambio_liq > ldc_tasa_cambio then
						ls_cnta_ctbl_dif         = gnvo_app.is_cta_ctbl_per
					 
						ls_flag_debhab_dif     = 'D'
						ls_flag_debhab_dif_doc = 'H'
					 
						ls_det_glosa  = 'Diferencia en Cambio Dolar se Incremento [' + string(ldc_tasa_cambio, '###,##0.0000') + ' -> ' + string(ldc_tasa_cambio_liq, '###,##0.0000')  + ']'
	
					else
						ls_cnta_ctbl_dif         = gnvo_app.is_cta_ctbl_gan
					 
						ls_flag_debhab_dif     = 'H'
						ls_flag_debhab_dif_doc = 'D'		
					 
						ls_det_glosa  = 'Diferencia en Cambio Dolar Disminuyo [' + string(ldc_tasa_cambio, '###,##0.0000') + ' -> ' + string(ldc_tasa_cambio_liq, '###,##0.0000')  + ']'
					end if
					
					//Genero el tipo de cambio
					ls_expresion = "cnta_ctbl = '" + ls_cnta_ctbl_dif &
									 + "' AND flag_debhab = '" + ls_flag_debhab_dif &
									 + "' AND tipo_docref1 = '" + ls_tipo_doc &
									 + "' and nro_docref1 = '" + ls_nro_doc + "'"
									 
					ll_found     = adw_asiento_Det.Find(ls_expresion,1,adw_asiento_Det.Rowcount())
					IF ll_found > 0 THEN
						ldc_importe_sol = adw_asiento_Det.object.imp_movsol  [ll_found]
						adw_asiento_Det.object.imp_movsol  [ll_found] = abs(ldc_importe_sol) + abs((ldc_tasa_cambio - ldc_tasa_cambio_liq) * ldc_importe)
					ELSE
						/*Asiento de Diferencia en cambio*/
						ll_row_ins = adw_asiento_Det.event ue_insert()
						if ll_row_ins > 0 then
							adw_asiento_Det.Object.item	      [ll_row_ins] = ll_row_ins
							adw_asiento_Det.Object.cnta_ctbl    [ll_row_ins] = ls_cnta_ctbl_dif
							adw_asiento_Det.Object.det_glosa    [ll_row_ins] = ls_det_glosa
							adw_asiento_Det.Object.flag_debhab  [ll_row_ins] = ls_flag_debhab_dif  
							adw_asiento_Det.Object.tipo_docref1 [ll_row_ins] = ls_tipo_doc
							adw_asiento_Det.Object.nro_docref1	[ll_row_ins] = ls_nro_doc
							adw_asiento_Det.object.imp_movsol   [ll_row_ins] = abs((ldc_tasa_cambio - ldc_tasa_cambio_liq) * ldc_importe)
							adw_asiento_Det.object.imp_movdol   [ll_row_ins] = 0.00
							adw_asiento_Det.object.flag_edit 	[ll_row_ins] = 'E' 
						end if
					END IF /*Busqueda de cuenta generada para acumular*/		
					 
					/*Asiento de doc x diferencia en cambio*/	
					ll_row_ins = adw_asiento_Det.event ue_insert()
					if ll_row_ins > 0 then
						adw_asiento_Det.Object.item	        	[ll_row_ins] = ll_row_ins
						adw_asiento_Det.Object.cnta_ctbl     	[ll_row_ins] = ls_cnta_ctbl_ref
						adw_asiento_Det.Object.det_glosa     	[ll_row_ins] = left(ls_det_glosa_ref,100)
						adw_asiento_Det.Object.tipo_docref1  	[ll_row_ins] = ls_tipo_doc     
						adw_asiento_Det.Object.nro_docref1   	[ll_row_ins] = ls_nro_doc     
						adw_asiento_Det.Object.flag_debhab  	[ll_row_ins] = ls_flag_debhab_dif_doc  
						adw_asiento_Det.Object.cod_relacion  	[ll_row_ins] = ls_cod_relacion 
						adw_asiento_Det.Object.cencos 		  	[ll_row_ins] = ls_cencos_ref	
						adw_asiento_Det.Object.centro_benef	  	[ll_row_ins] = ls_centro_benef
						adw_asiento_Det.object.imp_movsol    	[ll_row_ins] = abs((ldc_tasa_cambio - ldc_tasa_cambio_liq) * ldc_importe)
						adw_asiento_Det.object.imp_movdol    	[ll_row_ins] = 0.00
						adw_asiento_Det.object.flag_edit 		[ll_row_ins] = 'E' 
					end if
				end if
				
			END IF /*CIERRA X TIPO DE MONEDA*/

			
		else
			
			// En caso que no sea un documento provisionado, entonces tomo las cuentas que dicen la matriz contable
			SELECT matriz_cntbl
				INTO :ls_matriz
				FROM concepto_financiero
			WHERE (confin = :ls_confin);
			
			IF Isnull(ls_matriz) OR Trim(ls_matriz) = ''  THEN
				gnvo_app.of_message_error('Concepto Financiero Nº '+ls_confin+' No se ha Vinculado ninguna Matriz, por favor verifique!')
				at_tab1.SelectedTab = 1
				return false
			END IF
			
			ids_matriz_cntbl.Retrieve(ls_matriz)					// Recuperación de Información de Matriz Detalle
			
			if ids_matriz_cntbl.RowCount() = 0 then
				gnvo_app.of_mensaje_error( "El documento no esta provisionado, y la matriz contable " + ls_matriz + "no tiene cuentas asignadas. Por favor verifique!" &
										+"~r~nCod Relacion: " + ls_cod_relacion &
										+"~r~nTipo Documento: " + ls_tipo_doc &
										+"~r~nNro Documento: " + ls_nro_doc)
				
			end if
			  
			FOR ll_imatriz = 1 TO ids_matriz_cntbl.Rowcount()
					
				/**Inicializacion de Variables**/
				ls_armado = ls_inicio
				
				li_pos 	   	= 1
				li_pos_ini  	= 0
				li_pos_fin  	= 0
				li_cont   		= 0
				/**/
				ls_cnta_ctbl 	= ids_matriz_cntbl.Object.cnta_ctbl   [ll_imatriz]
				ls_desc_cnta	= ids_matriz_cntbl.Object.desc_cnta   [ll_imatriz]
					
				/*Verifica Flag de Cnta Contable*/
				if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then
					gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + ls_cnta_ctbl)
					return false
				end if
		
				IF lstr_cnta.flag_cencos = '1' THEN
					lstr_param.cencos = ls_cencos
				ELSE
					lstr_param.cencos = ''
				END IF
				
				IF lstr_cnta.flag_centro_benef = '1' THEN  //CENTRO DE BENEFICIO
					lstr_param.centro_benef = ls_centro_benef
				else
					lstr_param.centro_benef = ''
				END IF
				
				IF lstr_cnta.flag_codrel = '1' THEN  //CENTRO DE BENEFICIO
					lstr_param.cod_relacion = ls_cod_relacion
				else
					lstr_param.cod_relacion = ''
				END IF
				
				//Documento de Referencia
				IF lstr_cnta.flag_doc_ref = '1' THEN  
					lstr_param.tipo_docref1 = ls_tipo_doc
					lstr_param.nro_docref1 	= ls_nro_doc
				else
					lstr_param.tipo_docref1 = ''
					lstr_param.nro_docref1 = ''
				END IF
					
				
				ls_flag_debhab = ids_matriz_cntbl.Object.flag_debhab 	[ll_imatriz]
				ls_formula     = ids_matriz_cntbl.Object.formula 		[ll_imatriz]
				ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo 	[ll_imatriz]
				ls_glosa_texto	= ids_matriz_cntbl.Object.glosa_texto 	[ll_imatriz]
					
					
				/*funcion de llenado de datastore*/
				this.of_glosa_liq_og(adw_master, adw_detail, ids_glosa, ll_inicio,ls_cnta_ctbl,ls_desc_cnta)
				/**/
					
				/***********************/
				li_pos_ini     = Pos(ls_formula,'[',li_pos) 
					
				IF li_pos_ini = 1 THEN       /*Formula Pura */
					ldc_monto  = 0.00
				ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
					ls_campo = Mid(ls_formula,1,li_pos_ini - 2)
					
					//Si tiene una coma la saco tambien
					if Pos(ls_campo, ',', 1) > 0 then
						ls_campo = lower(Mid(ls_campo,1,Pos(ls_campo, ',', 1) - 1))
					end if
					
					if adw_detail.of_ExisteCampo(ls_Campo) then
						ldc_monto  = adw_detail.Getitemnumber(ll_inicio, ls_campo)
					else
						gnvo_app.of_message_error('Error, no existe el campo ' + ls_campo + ' en el datawindow, por favor revise la formula de la matriz')
						return false
					end if
				ELSEIF li_pos_ini = 0 THEN	  /*Campo*/
					ls_formula = lower(trim(ls_formula))
					
					if adw_detail.of_ExisteCampo(ls_formula) then
						ldc_monto  = adw_detail.Getitemnumber(ll_inicio, ls_formula)
					else
						gnvo_app.of_message_error('Error, no existe el campo ' + ls_formula + ' en el datawindow, por favor revise la formula de la matriz')
						return false
					end if
				END IF
					
				/**Creo la expresión mas adecuada para la busqueda**/	
				lstr_param.flag_debhab = ls_flag_debhab
				
				ls_expresion = this.of_generar_expresion(lstr_cnta, lstr_param)
				ll_found     = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
				
				IF ll_found = 0 THEN
					/*Extraer Glosa*/
					ls_desc_glosa = invo_asiento_glosa.of_set_glosa(ids_glosa,1,ls_glosa_texto,ls_glosa_campo)
					
					if IsNull(ls_desc_glosa) or trim(ls_desc_glosa) = '' then
						ls_desc_glosa = ls_desc_cnta
					end if
	
					/*centro de beneficio*/
					if lstr_cnta.flag_centro_benef = '1' then
						//INSERTA DISTRIBUCION DE ACUERDO 
						DECLARE USP_FIN_DISTRIB_X_CBENEFICIO PROCEDURE FOR 
							USP_FIN_DISTRIB_X_CBENEFICIO(	:ls_cod_relacion,
																	:ls_tipo_doc,
																	:ls_nro_doc,
																	:ls_flab_tabor,
																	:ldc_monto);
						EXECUTE USP_FIN_DISTRIB_X_CBENEFICIO ;
							
						IF SQLCA.SQLCode = -1 THEN 
							ls_msj_err = SQLCA.SQLErrText 	
							Rollback ;	
							gnvo_app.of_message_error('SQL error en procedure USP_FIN_DISTRIB_X_CBENEFICIO: ' + ls_msj_err)
							return false
						END IF
							  
						CLOSE USP_FIN_DISTRIB_X_CBENEFICIO ;
							
						//recupera dw
						lds_cbenef.Retrieve()
							
						For ll_inicio_cebef = 1 to lds_cbenef.Rowcount()
							ls_cebef  = lds_cbenef.object.centro_benef 	[ll_inicio_cebef]
							ldc_monto = lds_cbenef.object.monto		  		[ll_inicio_cebef]
								 
							//inserta registro
							ll_row_ins    = adw_asiento_det.event ue_insert()
							if ll_row_ins > 0 then
								adw_asiento_det.Object.item		    	[ll_row_ins] = ll_row_ins
								adw_asiento_det.Object.cnta_ctbl     	[ll_row_ins] = ls_cnta_ctbl
								adw_asiento_det.Object.flag_debhab   	[ll_row_ins] = ls_flag_debhab
								adw_asiento_det.Object.det_glosa     	[ll_row_ins] = left(ls_desc_glosa, 100)
								adw_asiento_det.Object.fec_cntbl			[ll_row_ins] = ld_cierre_og
								adw_asiento_det.Object.origen	      	[ll_row_ins] = ls_origen
								adw_asiento_det.Object.ano		      	[ll_row_ins] = ll_year
								adw_asiento_det.Object.mes		      	[ll_row_ins] = ll_mes
								adw_asiento_det.Object.nro_libro     	[ll_row_ins] = ll_nro_libro
								adw_asiento_det.Object.flag		  	 	[ll_row_ins] = 'N'					
								adw_asiento_det.Object.flag_edit  	 	[ll_row_ins] = 'E'
								 
								adw_asiento_det.Object.centro_benef [ll_row_ins] = lds_cbenef.object.centro_benef [ll_inicio_cebef]
								 
								if lstr_cnta.flag_cencos = '1' then
									adw_asiento_det.Object.cencos 	[ll_row_ins] = lstr_param.cencos
								end if
								
								if lstr_cnta.flag_codrel = '1' then
									adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
								end if
								
								if lstr_cnta.flag_doc_ref = '1' then
									adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = lstr_param.tipo_docref1
									adw_asiento_det.Object.nro_docref1 	[ll_row_ins] = lstr_param.nro_docref1
								end if
								 
								 IF ls_moneda = gnvo_app.is_soles THEN
									 adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
									 adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_tasa_cambio_liq,2)
								 ELSEIF ls_moneda = gnvo_app.is_dolares THEN
									 adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
									 adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_tasa_cambio_liq,2)					
								 END IF
							end if
								 
						Next
					else
						ll_row_ins    = adw_asiento_det.event ue_insert()
						if ll_row_ins > 0 then
							adw_asiento_det.Object.item		     [ll_row_ins] = ll_row_ins
							adw_asiento_det.Object.cnta_ctbl      [ll_row_ins] = ls_cnta_ctbl
							adw_asiento_det.Object.flag_debhab    [ll_row_ins] = lstr_param.flag_debhab
							adw_asiento_det.Object.det_glosa      [ll_row_ins] = left(ls_desc_glosa, 100)
							adw_asiento_det.Object.fec_cntbl		  [ll_row_ins] = ld_cierre_og
							adw_asiento_det.Object.origen	        [ll_row_ins] = gs_origen
							adw_asiento_det.Object.ano		        [ll_row_ins] = ll_year
							adw_asiento_det.Object.mes		        [ll_row_ins] = ll_mes
							adw_asiento_det.Object.nro_libro      [ll_row_ins] = ll_nro_libro

							adw_asiento_det.Object.flag		  	  [ll_row_ins] = 'N'					
							adw_asiento_det.Object.flag_edit  	  [ll_row_ins] = 'E'
	
							if lstr_cnta.flag_cencos = '1' then
								adw_asiento_det.Object.cencos [ll_row_ins] = lstr_param.cencos
							end if
							
							if lstr_cnta.flag_codrel = '1' then
								adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
							end if
							
							if lstr_cnta.flag_doc_ref = '1' then
								adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = lstr_param.tipo_docref1
								adw_asiento_det.Object.nro_docref1 [ll_row_ins] = lstr_param.nro_docref1
							end if
							
	
							IF ls_moneda = gnvo_app.is_soles THEN
								adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
								adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_tasa_cambio_liq,2)
							ELSEIF ls_moneda = gnvo_app.is_dolares THEN
								adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
								adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_tasa_cambio_liq,2)					
							END IF
						end if
							
					end if
				/**/
				ELSE
					IF ls_moneda = gnvo_app.is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
						adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_tasa_cambio,2)
					ELSEIF ls_moneda = gnvo_app.is_dolares THEN
						adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
						adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_tasa_cambio,2)					
					END IF
				END IF
			NEXT
			
		END IF


	 	/********************************************************/
		//generacion de asientos de retención
		/********************************************************/
		IF ls_flag_retec = '1' THEN //genera asiento de retencion	 
		 
			if Isnull(ldc_imp_ret) then ldc_imp_ret = 0.00
			 
			if ldc_imp_ret > 0 then
				ldc_imp_ret_sol = ldc_imp_ret 
				ldc_imp_ret_dol = Round(ldc_imp_ret / ldc_tasa_cambio,2)
				
				ls_cod_relacion 	= adw_detail.object.proveedor	   [ll_inicio]	
				ls_tipo_doc	  	 	= adw_detail.object.tipo_doc	   [ll_inicio]	
				ls_nro_doc		   = adw_detail.object.nro_doc	   [ll_inicio]		
				
				//Obtengo el flag del asiento contable
				ls_expresion = "tipo_docref1 = '" + ls_tipo_doc + "' " &
						 		 + "and nro_docref1 = '" + ls_nro_doc + "' " &
								 + "and cod_relacion = '" + ls_cod_relacion + "'"
								 
				ll_found     = adw_asiento_Det.Find(ls_expresion,1,adw_asiento_Det.Rowcount())
		
				IF ll_found =  0 THEN
					MEssageBox('Error', 'No se ha encontrado un registro Cuenta Corriente en el asiento de Cierre de la ORden de Giro, por favor corrija!' &
											+ '~r~n Tipo Doc: ' + ls_tipo_doc &
											+ '~r~n Nro Doc: ' + ls_nro_doc &
											+ '~r~n Cod Relacion: ' + ls_cod_relacion)
					return false
											
				end if
				
				ls_flag_debhab = adw_asiento_Det.object.flag_debhab  [ll_found]
				 
				//Inserto un nuevo registro
				ll_row_ins    = adw_asiento_det.event ue_insert()
				if ll_row_ins > 0 then
					adw_asiento_det.Object.item		   	[ll_row_ins] = ll_row_ins
					adw_asiento_det.Object.cnta_ctbl    	[ll_row_ins] = gnvo_app.is_cnta_ctbl_ret_igv
					adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = ls_flag_debhab
					adw_asiento_det.Object.det_glosa    	[ll_row_ins] = 'RETENCION - '+ls_cod_relacion+' - '+ls_tipo_doc+' - '+ls_nro_doc
					adw_asiento_det.Object.fec_cntbl			[ll_row_ins] = ld_cierre_og
					adw_asiento_det.Object.origen	      	[ll_row_ins] = gs_origen
					adw_asiento_det.Object.ano		      	[ll_row_ins] = ll_year
					adw_asiento_det.Object.mes		      	[ll_row_ins] = ll_mes
					adw_asiento_det.Object.nro_libro    	[ll_row_ins] = ll_nro_libro
					adw_asiento_det.Object.flag		  		[ll_row_ins] = 'N'					
					adw_asiento_det.Object.flag_edit  		[ll_row_ins] = 'E'
					adw_asiento_det.Object.imp_movsol  		[ll_row_ins] = ldc_imp_ret_sol
					adw_asiento_det.Object.imp_movdol  		[ll_row_ins] = ldc_imp_ret_dol
					adw_asiento_det.Object.cod_relacion		[ll_row_ins] = ls_cod_relacion
					adw_asiento_det.Object.tipo_docref1		[ll_row_ins] = gnvo_app.finparam.is_doc_ret
					adw_asiento_det.Object.nro_docref1 		[ll_row_ins] = ls_nro_retencion
				end if
			
			end if	 
		 
			
		END IF
	NEXT
	/*************************************************************************/
	
	/******************************************/
	/* Generacion de Asiento de Orden de Giro */
	/* Recupera datos de  Solicitud de Giro   */	
	/******************************************/
	IF not this.of_get_datos_asiento_og( ls_nro_doc_sg, lstr_cnta) then
		at_tab1.SelectedTab = 1
		return false
	END IF					
	
	ldc_tasa_cambio 		= lstr_cnta.tasa_cambio
	ls_Cencos_sg	 		= lstr_cnta.cencos
	ls_cnta_ctbl_sg		= lstr_cnta.cnta_cntbl
	ls_flag_debhab_sg		= lstr_cnta.flag_dh
	ls_moneda_sg			= lstr_cnta.cod_moneda
	
	if ls_moneda_sg = gnvo_app.is_soles then
		ldc_total_og_sol = lstr_cnta.saldo_sol
		ldc_total_og_dol = lstr_cnta.saldo_sol / ldc_tasa_cambio_liq
	else
		ldc_total_og_dol = lstr_cnta.saldo_dol
		ldc_total_og_sol = lstr_cnta.saldo_dol * ldc_tasa_cambio_liq
	end if
	
	/*Inserción de contra partida de orden de giro*/
	ll_row_ins = adw_asiento_det.event ue_insert()
	if ll_row_ins > 0 then
		adw_asiento_det.Object.origen 		  	[ll_row_ins] = ls_origen
		adw_asiento_det.Object.ano		 	  		[ll_row_ins] = ll_year
		adw_asiento_det.Object.mes 			  	[ll_row_ins] = ll_mes
		adw_asiento_det.Object.nro_libro 	  	[ll_row_ins] = ll_nro_libro
		adw_asiento_det.Object.item			  	[ll_row_ins] = ll_row_ins
		adw_asiento_det.Object.cnta_ctbl	  		[ll_row_ins] = ls_cnta_ctbl_sg
		adw_asiento_det.Object.fec_cntbl	  		[ll_row_ins] = ld_cierre_og		
		adw_asiento_det.Object.det_glosa	  		[ll_row_ins] = left(lstr_cnta.detalle_glosa, 100)
		adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = ls_flag_debhab_sg
		adw_asiento_det.Object.cencos 		  	[ll_row_ins] = ls_cencos_sg
		adw_asiento_det.Object.tipo_docref1 	[ll_row_ins] = gnvo_app.is_doc_og
		adw_asiento_det.Object.nro_docref1  	[ll_row_ins] = ls_nro_doc_sg
		adw_asiento_det.Object.cod_relacion 	[ll_row_ins] = ls_cod_relacion_sg
		adw_asiento_det.Object.imp_movsol   	[ll_row_ins] = ldc_total_og_sol
		adw_asiento_det.Object.imp_movdol   	[ll_row_ins] = ldc_total_og_dol
		adw_asiento_det.Object.flag		  	  	[ll_row_ins] = 'S'
		adw_asiento_det.Object.flag_edit    	[ll_row_ins] = 'E'
		/**/
	end if
	/************************************************************/
	
	/***********************************************/
	/*Diferencia en tasa de cambio en orden de giro*/
	/***********************************************/
	IF ls_moneda_sg = gnvo_app.is_dolares and ldc_tasa_cambio_liq <> ldc_tasa_cambio THEN
		if ldc_tasa_cambio_liq > ldc_tasa_cambio then
			ls_cnta_ctbl_dif      = gnvo_app.is_cta_ctbl_per
			ls_flag_debhab_dif    = lstr_cnta.flag_dh
			
			//FLAG DEBE / HABER DE ITEM DE OG 
			IF lstr_cnta.flag_dh = 'D' THEN
				ls_flag_debhab_dif_doc = 'H'
			ELSE
				ls_flag_debhab_dif_doc = 'D'
			END IF
			ls_det_glosa  = 'Diferencia en Cambio Dolar se Incremento [' + string(ldc_tasa_cambio, '###,##0.0000') + ' -> ' + string(ldc_tasa_cambio_liq, '###,##0.0000')  + ']'

		else
			ls_cnta_ctbl_dif      = gnvo_app.is_cta_ctbl_gan
			ls_flag_debhab_dif    = lstr_cnta.flag_dh
		 
			//FLAG DEBE / HABER DE ITEM DE OG 
			IF lstr_cnta.flag_dh = 'D' THEN
				ls_flag_debhab_dif_doc = 'H'
			ELSE
				ls_flag_debhab_dif_doc = 'D'
			END IF
			ls_det_glosa  = 'Diferencia en Cambio Dolar Disminuyo [' + string(ldc_tasa_cambio, '###,##0.0000') + ' -> ' + string(ldc_tasa_cambio_liq, '###,##0.0000')  + ']'
			
		end if
		
		//Genero el tipo de cambio
		ls_expresion = "cnta_ctbl = '" + ls_cnta_ctbl_dif &
						 + "' AND flag_debhab = '" + ls_flag_debhab_dif &
						 + "' AND tipo_docref1 = '" + ls_tipo_doc &
						 + "' and nro_docref1 = '" + ls_nro_doc + "'"
						 
		ll_found     = adw_asiento_Det.Find(ls_expresion,1,adw_asiento_Det.Rowcount())
		
		IF ll_found > 0 THEN
			ldc_importe_sol = adw_asiento_Det.object.imp_movsol  [ll_found]
			adw_asiento_Det.object.imp_movsol  [ll_found] = abs(ldc_importe_sol) + abs((ldc_tasa_cambio - ldc_tasa_cambio_liq) * ldc_importe)
		ELSE
			/*Asiento de Diferencia en cambio*/
			ll_row_ins = adw_asiento_Det.event ue_insert()
			if ll_row_ins > 0 then
				adw_asiento_Det.Object.item	       [ll_row_ins] = ll_row_ins
				adw_asiento_Det.Object.cnta_ctbl     [ll_row_ins] = ls_cnta_ctbl_dif
				adw_asiento_Det.Object.det_glosa     [ll_row_ins] = ls_det_glosa
				adw_asiento_Det.Object.flag_debhab   [ll_row_ins] = ls_flag_debhab_dif  
				adw_asiento_Det.Object.tipo_docref1  [ll_row_ins] = gnvo_app.finparam.is_doc_og
				adw_asiento_Det.Object.nro_docref1	 [ll_row_ins] = ls_nro_doc_sg
				adw_asiento_Det.object.imp_movsol    [ll_row_ins] = abs((ldc_tasa_cambio - ldc_tasa_cambio_liq) * ldc_importe)
				adw_asiento_Det.object.imp_movdol    [ll_row_ins] = 0.00
				adw_asiento_Det.object.flag_edit 	 [ll_row_ins] = 'E' 
				adw_asiento_det.Object.flag		  	 [ll_row_ins] = 'S'
			end if
		END IF /*Busqueda de cuenta generada para acumular*/		
		 
		/*Asiento de doc x diferencia en cambio*/	
		ll_row_ins = adw_asiento_Det.event ue_insert()
		if ll_row_ins > 0 then
			adw_asiento_Det.Object.item	        	[ll_row_ins] = ll_row_ins
			adw_asiento_Det.Object.cnta_ctbl     	[ll_row_ins] = ls_cnta_ctbl_sg
			adw_asiento_Det.Object.det_glosa     	[ll_row_ins] = left(lstr_cnta.detalle_glosa, 100)
			adw_asiento_Det.Object.tipo_docref1  	[ll_row_ins] = gnvo_app.finparam.is_doc_og     
			adw_asiento_Det.Object.nro_docref1   	[ll_row_ins] = ls_nro_doc_sg
			adw_asiento_det.Object.cod_relacion 	[ll_row_ins] = ls_cod_relacion_sg 
			adw_asiento_Det.Object.flag_debhab   	[ll_row_ins] = ls_flag_debhab_dif_doc  
			adw_asiento_Det.object.imp_movsol    	[ll_row_ins] = abs((ldc_tasa_cambio - ldc_tasa_cambio_liq) * ldc_importe)
			adw_asiento_Det.object.imp_movdol    	[ll_row_ins] = 0.00
			adw_asiento_Det.object.flag_edit 		[ll_row_ins] = 'E' 
			adw_asiento_det.Object.flag		  	  	[ll_row_ins] = 'S'
		end if
		
	END IF		

	/*******************************************/
	/*  Acumulo la retención */
	/*******************************************/
	ldc_imp_ret_sol = 0.00 
	ldc_imp_ret_dol = 0.00 
	ldc_total_sol	 = 0.00
	ldc_total_dol	 = 0.00
	
	/*Acumula Monto Detalle*/
	FOR ll_inicio = 1 TO adw_detail.Rowcount()
		ls_moneda_det 			= adw_detail.Object.cod_moneda   [ll_inicio]
		ll_item					= adw_detail.Object.item		   [ll_inicio]
		ls_flag_ret		   	= adw_detail.Object.flag_ret_igv [ll_inicio]
		ldc_importe				= Dec(adw_detail.object.importe	[ll_inicio])
		 
		if IsNull(ldc_importe) then ldc_importe = 0
		 
		 /*Obtengo los importes adecuados*/
		IF ls_moneda_det = gnvo_app.is_soles THEN
			ldc_importe_sol = ldc_importe
			ldc_importe_dol = Round(ldc_importe / ldc_tasa_cambio_liq,2)
		ELSE
			ldc_importe_sol = Round(ldc_importe * ldc_tasa_cambio_liq,2)
			ldc_importe_dol = ldc_importe
		END IF
		 
		//retencion
		
		if ls_flag_ret = '1' then
			//Siempre el importe de la retención será en soles
			ldc_imp_ret = adw_detail.object.importe_ret_igv [ll_inicio]
			  
			if Isnull(ldc_imp_ret) then ldc_imp_ret = 0.00
			 
			if ldc_imp_ret > 0 then
				//totalizar retenciones
				ldc_imp_ret_sol = ldc_imp_ret_sol + ldc_imp_ret 
				ldc_imp_ret_dol = ldc_imp_ret_dol + Round(ldc_imp_ret / ldc_tasa_cambio_liq,2)
			end if
			 
		end if
		 
		 /**Acumula Totales para diferencia**/	 
		 ldc_total_sol += ldc_importe_sol
		 
		 ldc_total_dol += ldc_importe_dol
		 
	NEXT

	/*Diferencia de Pago sea mayor o menor*/
	IF ls_moneda_sg = gnvo_app.is_soles THEN
		ldc_monto_diferencia = (ldc_total_sol - ldc_total_og_sol)
		
		if ldc_imp_ret_sol <> 0 then
			if ldc_monto_diferencia < 0 then
				ldc_monto_diferencia = (Abs(ldc_monto_diferencia) - ldc_imp_ret_sol) * - 1
			elseif ldc_imp_ret_sol > 0 then
				ldc_monto_diferencia = (ldc_monto_diferencia + ldc_imp_ret_sol) 
			end if
		end if
		
	ELSE
		ldc_monto_diferencia = (ldc_total_dol - ldc_total_og_dol)
		if ldc_imp_ret_dol <> 0 then
			if ldc_monto_diferencia < 0 then
				ldc_monto_diferencia = (Abs(ldc_monto_diferencia) - ldc_imp_ret_dol) * - 1
			elseif ldc_imp_ret_dol > 0 then
				ldc_monto_diferencia = (ldc_monto_diferencia + ldc_imp_ret_dol) 
			end if
		end if
	END IF

	IF ldc_monto_diferencia < 0 THEN /*Generación de Asientos en Liquidacion*/
												/*de Monto Mayor                       */	
		ldc_monto_diferencia = ldc_monto_diferencia * -1
		
		IF ls_moneda_sg = gnvo_app.is_soles THEN
			ldc_monto_diferencia_sol = ldc_monto_diferencia 
			ldc_monto_diferencia_dol = Round(ldc_monto_diferencia / ldc_tasa_cambio_liq,2)
		ELSE
			ldc_monto_diferencia_dol = ldc_monto_diferencia 
			ldc_monto_diferencia_sol = Round(ldc_monto_diferencia * ldc_tasa_cambio_liq,2)
		END IF
		
		//*ASIENTO PARA DEVOLVER DINERO CUANDO SOBREPASAS*//
		ll_row_ins = adw_asiento_det.event ue_insert()
		if ll_Row_ins > 0 then
			adw_asiento_det.Object.origen 		  	[ll_row_ins] = ls_origen
			adw_asiento_det.Object.ano		 	  		[ll_row_ins] = ll_year
			adw_asiento_det.Object.mes 			  	[ll_row_ins] = ll_mes
			adw_asiento_det.Object.nro_libro 	  	[ll_row_ins] = ll_nro_libro
			adw_asiento_det.Object.item			  	[ll_row_ins] = ll_row_ins
			adw_asiento_det.Object.tipo_docref1 	[ll_row_ins] = gnvo_app.is_doc_og
			adw_asiento_det.Object.nro_docref1  	[ll_row_ins] = ls_nro_doc_sg
			adw_asiento_det.Object.cod_relacion 	[ll_row_ins] = ls_cod_relacion_sg	
			adw_asiento_det.Object.cnta_ctbl	  		[ll_row_ins] = gnvo_app.finparam.is_cta_ctbl_liq_deb
			adw_asiento_det.Object.fec_cntbl	  		[ll_row_ins] = ld_cierre_og			
			adw_asiento_det.Object.det_glosa	  		[ll_row_ins] ='DEVOLUCION (REINTEGRO)  '
			adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = 'D'
			adw_asiento_det.Object.imp_movsol   	[ll_row_ins] = ldc_monto_diferencia_sol
			adw_asiento_det.Object.imp_movdol   	[ll_row_ins] = ldc_monto_diferencia_dol
			adw_asiento_det.Object.flag		  	  	[ll_row_ins] = 'S'
			adw_asiento_det.Object.flag_edit    	[ll_row_ins] = 'E'	
		end if
		
	ELSEIF ldc_monto_diferencia > 0 THEN /*Generación de Asientos en Liquidacion*/
													 /*de Monto Menor                       */	
		
		IF ls_moneda_sg = gnvo_app.is_soles THEN
			ldc_monto_diferencia_sol = ldc_monto_diferencia 
			ldc_monto_diferencia_dol = Round(ldc_monto_diferencia / ldc_tasa_cambio_liq,2)
		ELSE
			ldc_monto_diferencia_dol = ldc_monto_diferencia 
			ldc_monto_diferencia_sol = Round(ldc_monto_diferencia * ldc_tasa_cambio_liq,2)
		END IF
		
		//*ASIENTO PARA DEVOLVER DINERO CUANDO SOBREPASAS*//
		ll_row_ins = adw_asiento_det.event ue_insert()
		if ll_Row_ins > 0 then
			adw_asiento_det.Object.origen 		  	[ll_row_ins] = ls_origen
			adw_asiento_det.Object.ano		 	  		[ll_row_ins] = ll_year
			adw_asiento_det.Object.mes 			  	[ll_row_ins] = ll_mes
			adw_asiento_det.Object.nro_libro 	  	[ll_row_ins] = ll_nro_libro
			adw_asiento_det.Object.item			  	[ll_row_ins] = ll_row_ins
			adw_asiento_det.Object.tipo_docref1 	[ll_row_ins] = gnvo_app.is_doc_og
			adw_asiento_det.Object.nro_docref1  	[ll_row_ins] = ls_nro_doc_sg
			adw_asiento_det.Object.cod_relacion 	[ll_row_ins] = ls_cod_relacion_sg
			adw_asiento_det.Object.cnta_ctbl	  		[ll_row_ins] = gnvo_app.finparam.is_cta_ctbl_liq_hab
			adw_asiento_det.Object.fec_cntbl	  		[ll_row_ins] = ld_cierre_og			
			adw_asiento_det.Object.det_glosa	  		[ll_row_ins] = 'POR COBRAR AL TRABAJADOR / USUARIO '
			adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = 'H'
			adw_asiento_det.Object.imp_movsol   	[ll_row_ins] = ldc_monto_diferencia_sol
			adw_asiento_det.Object.imp_movdol   	[ll_row_ins] = ldc_monto_diferencia_dol
			adw_asiento_det.Object.flag		  	  	[ll_row_ins] = 'S'
			adw_asiento_det.Object.flag_edit    	[ll_row_ins] = 'E'	
		end if
	END IF
	
	FOR ll_inicio = 1 TO adw_detail.Rowcount()
		 ls_moneda = adw_detail.object.cod_moneda [ll_inicio]
		 
		 IF ls_moneda_sg 	<> ls_moneda THEN
			 lb_ajust_x_conv = TRUE
			 exit
		END IF
	NEXT	


	/*DIFERENCIA DE DOCUMENTOS A LIQUIDAR*/ /*VERIFICACION*/
	IF lb_ajust_x_conv THEN
		ldc_total_imp_sol_hab = 0.00
		ldc_total_imp_sol_deb = 0.00
	
		adw_asiento_det.accepttext()
	
		FOR ll_inicio = 1 TO adw_asiento_det.Rowcount() 
			 ldc_imp_movsol_hab 	 = 0.00
			 ldc_imp_movsol_deb 	 = 0.00
	
			 ls_flag_debhab = adw_asiento_det.Object.flag_debhab  [ll_inicio]
		 
			 IF ls_flag_debhab = 'H' THEN
				 ldc_imp_movsol_hab = adw_asiento_det.object.imp_movsol [ll_inicio]
			 ELSEIF ls_flag_debhab = 'D' THEN	
				 ldc_imp_movsol_deb = adw_asiento_det.object.imp_movsol [ll_inicio]
			 END IF
		 
			IF Isnull(ldc_imp_movsol_hab)	 THEN ldc_imp_movsol_hab = 0.00
			IF Isnull(ldc_imp_movsol_deb)	 THEN ldc_imp_movsol_deb = 0.00
		
			ldc_total_imp_sol_hab = ldc_total_imp_sol_hab + ldc_imp_movsol_hab
			ldc_total_imp_sol_deb = ldc_total_imp_sol_deb + ldc_imp_movsol_deb
		NEXT
	
		IF ldc_total_imp_sol_deb > ldc_total_imp_sol_hab THEN
			/*GANANCIA*/
			ls_cnta_ctbl_dif   = gnvo_app.is_cta_ctbl_per
			ls_flag_debhab_dif = 'H'
			ldc_monto_diferencia_sol = Round(ldc_total_imp_sol_deb - ldc_total_imp_sol_hab,2)
		ELSEIF ldc_total_imp_sol_deb < ldc_total_imp_sol_hab THEN	
			/*PERDIDA*/
			ls_cnta_ctbl_dif   = gnvo_app.is_cta_ctbl_per
			ls_flag_debhab_dif = 'D'
			ldc_monto_diferencia_sol = Round(ldc_total_imp_sol_hab - ldc_total_imp_sol_deb ,2)
		ELSE
			return true
		END IF	
	
		/**/
		//*ASIENTO PARA DEVOLVER DINERO CUANDO SOBREPASAS*//
		ll_row_ins = adw_asiento_det.event ue_insert()
		if ll_row_ins > 0 then
			adw_asiento_det.Object.origen 		  	[ll_row_ins] = ls_origen
			adw_asiento_det.Object.ano		 	  		[ll_row_ins] = ll_year
			adw_asiento_det.Object.mes 			  	[ll_row_ins] = ll_mes
			adw_asiento_det.Object.nro_libro 	  	[ll_row_ins] = ll_nro_libro
			adw_asiento_det.Object.item			  	[ll_row_ins] = ll_row_ins
			adw_asiento_det.Object.cnta_ctbl	  		[ll_row_ins] = ls_cnta_ctbl_dif
			adw_asiento_det.Object.fec_cntbl	  		[ll_row_ins] = ld_cierre_og			
			adw_asiento_det.Object.det_glosa	  		[ll_row_ins] ='Diferencia de documento liquidados'
			adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = ls_flag_debhab_dif
			adw_asiento_det.Object.imp_movsol   	[ll_row_ins] = ldc_monto_diferencia_sol
			adw_asiento_det.Object.imp_movdol   	[ll_row_ins] = 0.00
			adw_asiento_det.Object.flag		  	  	[ll_row_ins] = 'S'
			adw_asiento_det.Object.flag_edit    	[ll_row_ins] = 'E'	
		end if
	
	
	END IF
	
	this.of_generar_ajuste(adw_asiento_cab, adw_asiento_det)

	Return true
	
catch ( Exception ex )

	f_mensaje("Ha ocurrido una exception: " + ex.getMessage() + ", por favor verifique", '')
	
	return false
	
finally
	destroy lds_cbenef
	

end try



end function

public function boolean of_glosa_liq_og (u_dw_abc adw_1, u_dw_abc adw_2, u_ds_base ads_1, long al_row_det, string as_cnta_cntbl, string as_desc_cnta);/****************************************************/
/*LLenado de Datastore en Caso de Liquidación       */
/* adw_1 = Cabecera de Solicitud Giro					 */
/* adw_2 = Detalle de Liquidacion de Solicitud Giro */
/* ads_1 = Datastore de Datos Para Glosa				 */
/* al_row_det = Linea de Detalle de Liquidación		 */
/****************************************************/

Long   ll_ins_ds
String ls_descripcion

DO WHILE ads_1.Rowcount() > 0
	ads_1.deleterow(0)
LOOP

ll_ins_ds = ads_1.InsertRow(0)
/*Cabecera de Solicitud de Giro*/
ads_1.Object.origen_sg            [ll_ins_ds] = adw_1.Object.origen 			    [1]
ads_1.Object.nro_solicitud_sg     [ll_ins_ds] = adw_1.Object.nro_solicitud     [1]
ads_1.Object.cod_relacion_sg      [ll_ins_ds] = adw_1.Object.cod_relacion      [1]
ads_1.Object.nom_proveedor_sg     [ll_ins_ds] = adw_1.Object.nom_proveedor     [1]
ads_1.Object.aprobacion_sg		    [ll_ins_ds] = adw_1.Object.aprobacion		    [1]
ads_1.Object.nombre_sg			    [ll_ins_ds] = adw_1.Object.nombre			    [1]
ads_1.Object.fecha_aprobacion_sg  [ll_ins_ds] = adw_1.Object.fecha_aprobacion  [1]
ads_1.Object.usuario_aprob_sg 	 [ll_ins_ds] = adw_1.Object.usuario_aprob		 [1]
ads_1.Object.importe_liquidado_sg [ll_ins_ds] = adw_1.Object.importe_liquidado [1]
ads_1.Object.importe_sg			    [ll_ins_ds] = adw_1.Object.importe_doc		 [1]


ls_descripcion = adw_2.Object.descripcion [al_row_det]
/*Detalle de Liquidacion de Solicitud de Giro*/
ads_1.Object.origen			 [ll_ins_ds] = adw_2.Object.origen 	    [al_row_det]
ads_1.Object.cod_relacion	 [ll_ins_ds] = adw_2.Object.proveedor   [al_row_det] 
ads_1.Object.tipo_doc		 [ll_ins_ds] = adw_2.Object.tipo_doc    [al_row_det]
ads_1.Object.nro_doc			 [ll_ins_ds] = adw_2.Object.nro_doc	    [al_row_det]
ads_1.Object.cod_moneda		 [ll_ins_ds] = adw_2.Object.cod_moneda  [al_row_det]
ads_1.Object.tasa_cambio	 [ll_ins_ds] = adw_2.Object.tasa_cambio [al_row_det]
ads_1.Object.descripcion	 [ll_ins_ds] = adw_2.Object.descripcion [al_row_det]
ads_1.Object.obs				 [ll_ins_ds] = adw_2.Object.descripcion [al_row_det]
ads_1.Object.fecha_registro [ll_ins_ds] = adw_2.Object.fecha_doc	 [al_row_det]
ads_1.Object.fecha_emision  [ll_ins_ds] = adw_2.Object.fecha_doc	 [al_row_det]
ads_1.Object.vencimiento	 [ll_ins_ds] = adw_2.Object.fecha_doc	 [al_row_det]
ads_1.Object.total_pagar	 [ll_ins_ds] = adw_2.Object.importe		 [al_row_det]
ads_1.Object.cnta_ctbl		 [ll_ins_ds] = as_cnta_cntbl
ads_1.Object.desc_cnta		 [ll_ins_ds] = as_desc_cnta

return true

end function

public function boolean of_get_datos_asiento_og (string as_nro_og, ref str_cnta_cntbl astr_cnta);Boolean lb_ret = TRUE

SELECT 	cad.cnta_ctbl    ,cad.det_glosa    , decode(cad.flag_debhab,'D','H','D') as flag_debhab ,   
       	cad.cencos       , cad.centro_benef,
			cad.cod_ctabco   ,cad.imp_movsol ,
     		cad.imp_movdol   ,cb.tasa_cambio	, 
			sg.importe_doc,
			sg.cod_moneda
  INTO 	:astr_cnta.cnta_cntbl,
  		 	:astr_cnta.detalle_glosa,
		 	:astr_cnta.flag_dh,
  		 	:astr_cnta.cencos,
			:astr_cnta.centro_benef,
			:astr_cnta.ctabco   ,
			:astr_cnta.saldo_sol,
		 	:astr_cnta.saldo_dol,
			:astr_cnta.tasa_cambio,
			:astr_cnta.importe,
			:astr_cnta.cod_moneda
	  
  FROM cntbl_asiento_det     cad ,
       caja_bancos           cb,
       solicitud_giro        sg
where sg.origen_caja_banc0 = cb.origen
  and sg.nro_reg_caja_banco = cb.nro_registro
  and cb.origen             = cad.origen
  and cb.ano                = cad.ano
  and cb.mes                = cad.mes       
  and cb.nro_libro          = cad.nro_libro
  and cb.nro_Asiento        = cad.nro_asiento
  and sg.nro_solicitud      = cad.nro_docref1
  and cad.tipo_docref1      = :gnvo_app.is_doc_og
  and sg.nro_solicitud      = :as_nro_og
  and cb.flag_estado			 <> '0';
  

IF SQLCA.SQLCOde = 100 THEN
	//Si existe en el asiento de cartera de pagos, seguramente debe estar como pago de alguna orden de giro
	
	select 	cad.cnta_ctbl    ,cad.det_glosa    , 
				decode(cad.flag_debhab,'D','H','D') as flag_debhab ,   
       		cad.cencos       , 
				cad.centro_benef,
				cad.imp_movsol ,
     			cad.imp_movdol   ,
				ca.tasa_cambio	, 
				sg.cod_moneda
	  INTO 	:astr_cnta.cnta_cntbl,
				:astr_cnta.detalle_glosa,
				:astr_cnta.flag_dh,
				:astr_cnta.cencos,
				:astr_cnta.centro_benef,
				:astr_cnta.saldo_sol,
				:astr_cnta.saldo_dol,
				:astr_cnta.tasa_cambio,
				:astr_cnta.cod_moneda	
	from cntbl_asiento ca,
		  cntbl_asiento_Det cad,
		  solicitud_giro    sg
	where ca.origen        = cad.origen
	  and ca.ano           = cad.ano
	  and ca.mes           = cad.mes
	  and ca.nro_libro     = cad.nro_libro
	  and ca.nro_asiento   = cad.nro_asiento
	  and ca.origen        = sg.origen
	  and ca.ano           = sg.ano
	  and ca.mes           = sg.mes
	  and ca.nro_libro     = sg.nro_libro
	  and ca.nro_asiento   = sg.nro_Asiento
	  and cad.tipo_docref1 = :gnvo_app.is_doc_og
	  and cad.nro_docref1  = :as_nro_og
	  and sg.nro_solicitud <> :gnvo_app.is_doc_og
	  and ca.flag_estado	  <> '0';

	if SQLCA.SQLCode = 100 then
		gnvo_app.of_message_error('Problemas al Recuperar Cuenta Contable de la OG ' + as_nro_og + ' en Cartera de pagos. ' &
								+ 'El asiento debe tener una cuenta contable que tenga como referencia a dicho documento.' &
								+ '~r~nPor favor verifique el asiento contable generado por Cartera de pagos para dicha OG.')
		return false
	end if
END IF

Return true

end function

public function boolean of_generar_asiento (u_dw_abc adw_master, u_dw_abc adw_detail, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, str_parametros astr_param) throws exception;/*Generación de Cuentas Automaticas*/
/***********Declaro Variables  ********************/
String  ls_desc_cnta_ret  	,ls_flag_doc_ref_ret 	,ls_flag_codrel_ret 			, &
        ls_confin         ,&
		  ls_matriz_cntbl   	,ls_tip_trans        	,ls_cnta_ctbl       			,ls_flag_debhab    ,&
		  ls_expresion      	,ls_formula          	,ls_glosa_texto    			,ls_glosa_campo	 ,&
		  ls_desc_glosa     	,ls_moneda		     		,ls_cod_relacion	  			,ls_tipo_doc		 ,&
		  ls_nro_doc		  	,ls_moneda_det		  		,ls_flag_ret_igv   			,ls_origen         ,&
		  ls_glosa_dp       	,ls_cencos_dp        	,ls_codctabco_dp   			,ls_nro_docref2	 ,&
		  ls_cnta_ctbl_dif 	,ls_flag_debhab_dif		,ls_flag_debhab_dif_x_doc	,ls_det_glosa  	 ,&
		  ls_flag_ret_cab    ,ls_flag_debhab_ret		, &
		  ls_tipo_doc_cab	 	,ls_confin_det		 		,ls_desc_cnta
Decimal 		ldc_monto_total,ldc_imp_retencion,ldc_saldo_dol,ldc_saldo_sol,ldc_imp_sol,&
				ldc_imp_dol		,ldc_monto_soles, ldc_importe_conv, ldc_tasa_cambio, ldc_monto		  
Long    		ll_row_master,ll_inicio ,ll_found,ll_row_ins,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,&
		  		ll_count     ,ll_ins_det,ll_factor,ll_inicio_det
Boolean 		lb_ret = TRUE
Exception	ex


/***********Recupero Parametros*******************/
ex = create Exception


/*Recupero Valores de Cuenta Contable de Retenciones*/
SELECT desc_cnta				,flag_doc_ref				,flag_codrel
  INTO :ls_desc_cnta_ret	,:ls_flag_doc_ref_ret	,:ls_flag_codrel_ret
  FROM cntbl_cnta 
 WHERE (cnta_ctbl = :gnvo_app.finparam.is_cnta_ctbl_ret_igv) ;
 
/************************Proceso de Generacion de Asientos*****************************/
adw_master.Accepttext()
adw_detail.Accepttext()
adw_asiento_cab.Accepttext()
adw_asiento_det.Accepttext()

//ELIMINO ASIENTOS ANTERIORMENTE PROCESADOS
DO WHILE adw_asiento_det.Rowcount() > 0
	adw_asiento_det.deleterow(0)
LOOP

//VERIFICAR QUE CONCEPTO FINANCIERO ESTE VINCULADA CON UNA MATRIZ CONTABLE
ll_row_master = adw_master.Getrow ()

IF ll_row_master = 0 THEN 
	ex.SetMessage('Debe Ingresar Un Registro En La Cabecera de Documento')
	throw ex
END IF	

//recupero tipo de transación 
ls_tip_trans 	 = adw_master.object.flag_tipo_ltr  [ll_row_master]
ls_moneda		 = adw_master.object.cod_moneda     [ll_row_master]
ldc_tasa_cambio = adw_master.object.tasa_cambio    [ll_row_master]
ls_origen       = adw_master.object.origen      	[ll_row_master]
ll_ano	       = adw_master.object.ano         	[ll_row_master]
ll_mes	       = adw_master.object.mes         	[ll_row_master]
ll_nro_libro    = adw_master.object.nro_libro  	 	[ll_row_master]
ll_nro_asiento	 = adw_master.object.nro_asiento  	[ll_row_master]
ls_flag_ret_cab = adw_master.object.flag_retencion [ll_row_master]
ls_tipo_doc 	 = adw_master.object.tipo_doc 		[ll_row_master]
ls_nro_doc 	 	 = adw_master.object.nro_doc			[ll_row_master]
ls_cod_relacion = adw_master.object.cod_relacion	[ll_row_master]

if IsNull(ls_nro_doc) then ls_nro_doc = ''

if astr_param.confin = '' or Isnull(astr_param.confin) then
	IF astr_param.tipo_mov = 'C' THEN //POR COBRAR
		if ls_tip_trans = 'C'     then // CANJE
			//verificar documento para cheque diferido
			if ls_tipo_doc_cab = gnvo_app.finparam.is_doc_chd then
				ls_confin = gnvo_app.finparam.is_confin_chq
			else
				ls_confin = gnvo_app.finparam.is_confin_cnj_cob	
			end if	
			
		elseif ls_tip_trans = 'R' then // RENOVACION
			ls_confin = gnvo_app.finparam.is_confin_rnv_cob
		end if	
	ELSEIF astr_param.tipo_mov = 'P' THEN //POR PAGAR
		if ls_tip_trans = 'C'     then // CANJE
			ls_confin = gnvo_app.finparam.is_confin_cnj_pag
		elseif ls_tip_trans = 'R' then // RENOVACION
			ls_confin = gnvo_app.finparam.is_confin_rnv_pag
		end if	
	END IF
else
	ls_confin = astr_param.confin
end if

//buscar matriz contable
select matriz_cntbl into :ls_matriz_cntbl from concepto_financiero where confin = :ls_confin ;

IF Isnull(ls_matriz_cntbl) OR Trim(ls_matriz_cntbl) = ''  THEN
	ex.SetMessage('Concepto Financiero ' + ls_confin + ', no Tiene Vinculada una Matriz Contable , Verifique!')
	throw ex
END IF

//** Datastore Detalle Matriz Contable **//

ids_matriz_cntbl.Retrieve(ls_matriz_cntbl)					// Recuperación de Información de Matriz Detalle


//generacion de asientos x  matriz contable
FOR ll_inicio = 1 TO ids_matriz_cntbl.Rowcount()
	ls_cnta_ctbl   = ids_matriz_cntbl.Object.cnta_ctbl   [ll_inicio]
	ls_flag_debhab = ids_matriz_cntbl.Object.flag_debhab [ll_inicio]
	ls_formula     = ids_matriz_cntbl.Object.formula 	  [ll_inicio]
	ls_glosa_texto = ids_matriz_cntbl.Object.glosa_texto [ll_inicio]
	ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo [ll_inicio]
	
	if not adw_master.of_ExisteCampo(ls_formula) then
		MessageBox('Error', "Error, no existe el campo " + ls_formula + " en la cabecera del documento, por favor revisar la formula de la matriz " + ls_matriz_cntbl)
		return false
	end if
					
				
	ldc_monto = adw_master.Getitemnumber(ll_inicio,ls_formula)

	ls_expresion 	 = "cnta_ctbl = '" + ls_cnta_ctbl + "'" &
						 + " AND flag_debhab = '" + ls_flag_debhab + "'" &
						 + " AND cod_relacion = '" + ls_cod_relacion + "'" &
						 + " AND tipo_docref1 = '" + ls_tipo_doc + "'" &
						 + " AND nro_docref1 = '" + ls_nro_doc + "'"
						 
	ll_found       = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
	IF ll_found = 0 THEN
		ll_row_ins    = adw_asiento_det.event ue_insert()		
		/*Extraer Glosa*/
		ls_desc_glosa = invo_asiento_glosa.of_set_glosa(adw_master,ll_inicio,ls_glosa_texto,ls_glosa_campo)
		
		if ls_desc_glosa = '' or ISNull(ls_desc_glosa) then
			ls_desc_glosa = ids_matriz_cntbl.Object.desc_cnta   [ll_inicio]
		end if
			
	 	adw_asiento_det.Object.item			[ll_row_ins] = ll_row_ins
		adw_asiento_det.Object.cnta_ctbl   	[ll_row_ins] = ls_cnta_ctbl
		adw_asiento_det.Object.flag_debhab 	[ll_row_ins] = ls_flag_debhab
		adw_asiento_det.Object.det_glosa   	[ll_row_ins] = mid(ls_desc_glosa,1,100)
		
		/*verifica asigna codigo de relacion,tipo_doc,nro_doc */
		adw_asiento_det.Object.cod_relacion [ll_row_ins] = ls_cod_relacion
		adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = ls_tipo_doc
		adw_asiento_det.Object.nro_docref1  [ll_row_ins] = ls_nro_doc
		
					
		IF ls_moneda = is_soles THEN
			adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
		 	adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_tasa_cambio,2)
		ELSEIF ls_moneda = is_dolares THEN
			adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
			adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_tasa_cambio,2)					
		END IF
	ELSE
		IF ls_moneda = is_soles THEN
			adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
			adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_tasa_cambio,2)
      ELSEIF ls_moneda = is_dolares THEN
			adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
			adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_tasa_cambio,2)					
      END IF
	END IF
NEXT

//genera asientos por referencia
FOR ll_inicio = 1 TO adw_detail.Rowcount()
	ls_cod_relacion   = adw_detail.Object.proveedor_ref  	[ll_inicio]
	ls_tipo_doc		 	= adw_detail.Object.tipo_ref 			[ll_inicio]
	ls_nro_doc		   = adw_detail.Object.nro_ref	      [ll_inicio]
	ls_moneda_det 	 	= adw_detail.Object.cod_moneda_det 	[ll_inicio]
	ls_flag_ret_igv   = adw_detail.Object.flag_ret_igv   	[ll_inicio]
	ldc_imp_retencion = adw_detail.Object.imp_ret_igv    	[ll_inicio]
	ll_factor			= adw_detail.Object.factor	      	[ll_inicio]			
	ls_confin_det		= adw_detail.Object.confin	      	[ll_inicio]	
	
	/*************************************************/
	if ISNull(ls_confin_det) or ls_confin_det = "" then
		f_mensaje("Debe Seleccionar un Concepto financiero para el registro " + String(ll_inicio), "")
		return false
	end if
	
	//buscar matriz contable
	select matriz_cntbl 
		into :ls_matriz_cntbl 
	from concepto_financiero 
	where confin = :ls_confin_det ;

	IF Isnull(ls_matriz_cntbl) OR Trim(ls_matriz_cntbl) = ''  THEN
		ex.SetMessage('Concepto Financiero ' + ls_confin_det + ' Detalle No Tiene Vinculada una Matriz Contable , Verifique!')
		throw ex
	END IF

	ids_matriz_cntbl.Retrieve(ls_matriz_cntbl)

	if ids_matriz_cntbl.Rowcount() > 0 then

		/*generacion de asientos x  matriz contable*/
		FOR ll_inicio_det = 1 TO ids_matriz_cntbl.Rowcount()
			ls_cnta_ctbl   = ids_matriz_cntbl.Object.cnta_ctbl   [ll_inicio_det]
			ls_flag_debhab = ids_matriz_cntbl.Object.flag_debhab [ll_inicio_det]
			ls_formula     = ids_matriz_cntbl.Object.formula 	  [ll_inicio_det]
			ls_glosa_texto = ids_matriz_cntbl.Object.glosa_texto [ll_inicio_det]
			ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo [ll_inicio_det]
		  	ldc_monto 		= adw_detail.Getitemnumber(ll_inicio,ls_formula)

			ls_expresion 	= "cnta_ctbl = '" + ls_cnta_ctbl + "'" &
						 		+ " AND flag_debhab = '" + ls_flag_debhab + "'" &
						 		+ " AND cod_relacion = '" + ls_cod_relacion + "'" &
						 		+ " AND tipo_docref1 = '" + ls_tipo_doc + "'" &
						 		+ " AND nro_docref1 = '" + ls_nro_doc + "'"

			ll_found       = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
		  
		  	IF ll_found = 0 THEN
			  	ll_row_ins    = adw_asiento_det.event ue_insert()
				  
			  	/*Extraer Glosa*/
			  	ls_desc_glosa = invo_asiento_glosa.of_set_glosa(adw_master,ll_inicio,ls_glosa_texto,ls_glosa_campo)
				if ls_desc_glosa = '' or ISNull(ls_desc_glosa) or trim(ls_desc_glosa) = 'Error: OBS' then
					ls_desc_glosa = ids_matriz_cntbl.Object.desc_cnta   [ll_inicio_det]
				end if
				
			  	adw_asiento_det.Object.item		  [ll_row_ins] = ll_row_ins
			  	adw_asiento_det.Object.cnta_ctbl   [ll_row_ins] = ls_cnta_ctbl
			  	adw_asiento_det.Object.flag_debhab [ll_row_ins] = ls_flag_debhab
			  	adw_asiento_det.Object.det_glosa   [ll_row_ins] = mid(ls_desc_glosa,1,100)
			  
			  	/*verifica asigna codigo de relacion,tipo_doc,nro_doc */
			  	adw_asiento_det.Object.cod_relacion [ll_row_ins] = ls_cod_relacion
			  	adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = ls_tipo_doc
			  	adw_asiento_det.Object.nro_docref1  [ll_row_ins] = ls_nro_doc
			  
			  	IF ls_moneda_det = is_soles THEN
					adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
				  	adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_tasa_cambio,2)
			  	ELSEIF ls_moneda = is_dolares THEN
					adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
					adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_tasa_cambio,2)					
			  	END IF
		  	ELSE
				IF ls_moneda_det = is_soles THEN
					adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
				 	adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_tasa_cambio,2)
			 	ELSEIF ls_moneda = is_dolares THEN
				 	adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
				 	adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_tasa_cambio,2)					
			 	END IF
		 	END IF
		NEXT

	else
		//**Se Genera Asientos de Acuerdo A al Mismo Documento **//
		ldc_monto_total = adw_detail.object.importe [ll_inicio]
	 
   	IF astr_param.tipo_mov = 'P' THEN //X PAGAR
			IF ll_factor = 1 THEN
		   	ls_flag_debhab = 'D'
			ELSE
				ls_flag_debhab = 'H'
			END IF
	   ELSEIF astr_param.tipo_mov = 'C' THEN //X COBRAR
			IF ll_factor = 1 THEN
			   ls_flag_debhab = 'H'
			ELSE
			 	ls_flag_debhab = 'D'
			END IF
	   END IF
	 
		ids_doc_pend_cta_cte.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
		
		IF ids_doc_pend_cta_cte.Rowcount() > 0   THEN
			ls_cnta_ctbl   = ids_doc_pend_cta_cte.object.cnta_ctbl   [1]
			ldc_saldo_sol  = ids_doc_pend_cta_cte.object.sldo_sol	 	[1]
			ldc_saldo_dol	= ids_doc_pend_cta_cte.object.saldo_dol  [1]
	   ELSE
	   	/*adelantos o cancelaciones totales*/
	      SELECT cnta_ctbl    
	        INTO :ls_cnta_ctbl
	        FROM cntbl_asiento_det
	       WHERE origen       = :ls_origen      
			   AND ano          = :ll_ano         
			   AND mes          = :ll_mes         
			   AND nro_libro    = :ll_nro_libro   
				AND nro_asiento  = :ll_nro_asiento 
				AND cod_relacion = :ls_cod_relacion
				AND tipo_docref1 = :ls_tipo_doc	  
				AND nro_docref1  = :ls_nro_doc	  
			order by item desc;
		end if
													 
		//Recupera Datos Complementarios
		ids_doc_pend_adic_tbl.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)	 

		IF ids_doc_pend_adic_tbl.Rowcount() > 0 THEN
			ls_glosa_dp     = ids_doc_pend_adic_tbl.object.det_glosa   [1]
			ls_cencos_dp    = ids_doc_pend_adic_tbl.object.cencos      [1]
			ls_codctabco_dp = ids_doc_pend_adic_tbl.object.cod_ctabco  [1]
			ls_nro_docref2  = ids_doc_pend_adic_tbl.object.nro_docref2 [1]
		ELSE
			SetNull(ls_glosa_dp)
			SetNull(ls_cencos_dp)
			SetNull(ls_codctabco_dp)
			SetNull(ls_nro_docref2)
		END IF

		IF Not(Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '') THEN
			
			select desc_cnta 
			  into :ls_desc_cnta 
			  from cntbl_cnta 
			where cnta_ctbl = :ls_cnta_ctbl;
			
			/*Verificar DIFERENCIA DE TASA DE CAMBIO*/
			IF ls_moneda_det = is_dolares THEN /*SE REVISARA DIFERENCIA EN CAMBIO*/		
			 
				IF astr_param.accion = 'new' THEN
		 	   	ldc_saldo_sol = Round(ldc_saldo_dol * ldc_tasa_cambio,2) - ldc_saldo_sol
					 
			   ELSEIF astr_param.accion = 'fileopen' THEN
					
					this.of_monto_detalle_asiento (ls_origen    ,ll_ano        ,ll_mes         ,&
					  		     					 ll_nro_libro ,ll_nro_asiento,ls_cod_relacion,&
						 						 	 ls_tipo_doc  ,ls_nro_doc    ,ldc_imp_sol    ,&
												 	 ldc_imp_dol)
												 
					/*Buscar si existe algun saldo en doc_pendientes_cta_cte*/			
					SELECT sldo_sol,	saldo_dol 
					  INTO :ldc_saldo_sol,	:ldc_saldo_dol
					  FROM doc_pendientes_cta_cte
					 WHERE cod_relacion = :ls_cod_relacion 
						AND tipo_doc     = :ls_tipo_doc     
						AND nro_doc      = :ls_nro_doc;
								  
					If SQLCA.SQLCode = 100 then
						ldc_saldo_sol = 0
						ldc_saldo_dol = 0
					end if
					
					IF Isnull(ldc_imp_sol) THEN ldc_imp_sol = 0.00
					IF Isnull(ldc_imp_dol) THEN ldc_imp_dol = 0.00
					
								 
					ldc_imp_sol = ldc_imp_sol + ldc_saldo_sol
					ldc_imp_dol = ldc_imp_dol + ldc_saldo_dol
					
				
					ldc_saldo_sol = Round(ldc_imp_dol * ldc_tasa_cambio,2) - ldc_imp_sol

				END IF /*Cierra Movimento*/

				IF ldc_saldo_sol > 0 THEN     /*Dolar Subio*/
					IF astr_param.tipo_mov = 'P' THEN //POR PAGAR
						ls_cnta_ctbl_dif  = gnvo_app.finparam.is_cta_ctbl_per								
						ls_flag_debhab_dif       = 'D'
						ls_flag_debhab_dif_x_doc = 'H'
					ELSEIF astr_param.tipo_mov = 'C' THEN //POR COBRAR
						ls_cnta_ctbl_dif  = gnvo_app.finparam.is_cta_ctbl_gan								
						ls_flag_debhab_dif       = 'H'
						ls_flag_debhab_dif_x_doc = 'D'
					END IF
					
					ldc_saldo_dol = 0.00
					ls_det_glosa  = 'Diferencia en Cambio Dolar se Incremento'
							 
				ELSEIF ldc_saldo_sol < 0 THEN /*Dolar Bajo*/		
					IF astr_param.tipo_mov = 'P' THEN //POR PAGAR
						ls_cnta_ctbl_dif  = gnvo_app.finparam.is_cta_ctbl_gan
						ls_flag_debhab_dif       = 'H'
						ls_flag_debhab_dif_x_doc = 'D'
					ELSEIF astr_param.tipo_mov = 'C' THEN //POR COBRAR
						ls_cnta_ctbl_dif  = gnvo_app.finparam.is_cta_ctbl_per								
						ls_flag_debhab_dif       = 'D'
						ls_flag_debhab_dif_x_doc = 'H'
					END IF
					
					ldc_saldo_dol = 0.00
					ldc_saldo_sol = ldc_saldo_sol * -1
							 
					ls_det_glosa  = 'Diferencia en Cambio Dolar Disminuyo'
				  
				ELSEIF ldc_saldo_sol = 0 THEN /*No Genera Diferencia en Cambio*/
					 GOTO SAL_ASIENTO					
				END IF /*VERIFICACION SALDO*/
			
				/*Insertar Nuevo Registro*/						 
				ls_expresion = "cnta_ctbl = '" + ls_cnta_ctbl_dif+"' AND flag_debhab = '"+ls_flag_debhab_dif+"'"			 			 
				ll_found = adw_asiento_det.Find(ls_expresion,1,adw_asiento_det.Rowcount())
				
				IF ll_found > 0 THEN
					ldc_monto_soles = adw_asiento_det.object.imp_movsol [ll_found]
					adw_asiento_det.object.imp_movsol  [ll_found] = ldc_monto_soles + ldc_saldo_sol
				ELSE
					ll_ins_det = adw_asiento_det.event ue_insert()
					adw_asiento_det.Object.item	      [ll_ins_det] = ll_ins_det
					adw_asiento_det.Object.cnta_ctbl   	[ll_ins_det] = ls_cnta_ctbl_dif
					adw_asiento_det.Object.det_glosa   	[ll_ins_det] = mid(ls_det_glosa,1,100)
					adw_asiento_det.Object.flag_debhab 	[ll_ins_det] = ls_flag_debhab_dif  							 
					adw_asiento_det.object.imp_movsol  	[ll_ins_det] = ldc_saldo_sol
					adw_asiento_det.object.imp_movdol  	[ll_ins_det] = 0.00
				END IF
								
				/*Insercion de Documento por diferencia en cambio*/		
				ll_ins_det = adw_asiento_det.event ue_insert()	//Inserta Registro 
				adw_asiento_det.Object.item	       [ll_ins_det] = ll_ins_det
				adw_asiento_det.Object.cnta_ctbl     [ll_ins_det] = ls_cnta_ctbl
				adw_asiento_det.Object.det_glosa     [ll_ins_det] = mid(ls_glosa_dp,1,100)
				adw_asiento_det.Object.tipo_docref1  [ll_ins_det] = ls_tipo_doc     
				adw_asiento_det.Object.nro_docref1   [ll_ins_det] = ls_nro_doc     
				adw_asiento_det.Object.cod_relacion  [ll_ins_det] = ls_cod_relacion 
				adw_asiento_det.Object.cencos 		 [ll_ins_det] = ls_cencos_dp		
				adw_asiento_det.Object.cod_ctabco    [ll_ins_det] = ls_codctabco_dp
				adw_asiento_det.Object.nro_docref2   [ll_ins_det] = ls_nro_docref2  
				adw_asiento_det.Object.flag_debhab   [ll_ins_det] = ls_flag_debhab_dif_x_doc  	
				adw_asiento_det.object.imp_movsol    [ll_ins_det] = ldc_saldo_sol
				adw_asiento_det.object.imp_movdol    [ll_ins_det] = 0.00
				
			END IF /*cierre de Moneda*/
		
			SAL_ASIENTO:
			/*insercion de asiento x documento */
			ll_ins_det = adw_asiento_det.event ue_insert()	//Inserta Registro 
				
			if ls_glosa_dp = '' or IsNull(ls_glosa_dp) then
				ls_glosa_dp = ls_desc_cnta
			end if
				
			adw_asiento_det.Object.item	       [ll_ins_det] = ll_ins_det
			adw_asiento_det.Object.cnta_ctbl     [ll_ins_det] = ls_cnta_ctbl
			adw_asiento_det.Object.det_glosa     [ll_ins_det] = mid(ls_glosa_dp,1,100)
			adw_asiento_det.Object.tipo_docref1  [ll_ins_det] = ls_tipo_doc     
			adw_asiento_det.Object.nro_docref1   [ll_ins_det] = ls_nro_doc     
			adw_asiento_det.Object.cod_relacion  [ll_ins_det] = ls_cod_relacion 
			adw_asiento_det.Object.cencos 		 [ll_ins_det] = ls_cencos_dp		
			adw_asiento_det.Object.cod_ctabco    [ll_ins_det] = ls_codctabco_dp
			adw_asiento_det.Object.nro_docref2   [ll_ins_det] = ls_nro_docref2  
			adw_asiento_det.Object.flag_debhab   [ll_ins_det] = ls_flag_debhab  
						  
			IF ls_moneda_det = is_soles THEN
				adw_asiento_det.object.imp_movsol [ll_ins_det] = ldc_monto_total
				adw_asiento_det.object.imp_movdol [ll_ins_det] = Round(ldc_monto_total / ldc_tasa_cambio,2)						  
			ELSE
				adw_asiento_det.object.imp_movsol [ll_ins_det] = Round(ldc_monto_total * ldc_tasa_cambio,2)						  
				adw_asiento_det.object.imp_movdol [ll_ins_det] = ldc_monto_total
			END IF
			
			/*asiento de flag de retencion*/
			IF ls_flag_ret_igv = '1' AND ls_flag_ret_cab = '1' THEN
				/*invertir flag debhab de doc*/	
				IF ls_flag_debhab = 'D' THEN
					ls_flag_debhab_ret = 'H'
				ELSE
					ls_flag_debhab_ret = 'D'
				END IF
				
				select desc_cnta 
				  into :ls_desc_cnta_ret 
				  from cntbl_cnta 
				where cnta_ctbl = :gnvo_app.finparam.is_cnta_ctbl_ret_igv;
					 
				ls_expresion = "cnta_ctbl = '" + gnvo_app.finparam.is_cnta_ctbl_ret_igv + "' AND flag_debhab = '"+ls_flag_debhab_ret+"'"
				ll_found = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
					  
				IF ll_found = 0 THEN
					/*Asiento Retencion*/	
					ll_ins_det = adw_asiento_det.event ue_insert()	//Inserta Registro 					 
					adw_asiento_det.object.item 		   [ll_ins_det] = ll_ins_det
					adw_asiento_det.object.cnta_ctbl		[ll_ins_det] = gnvo_app.finparam.is_cnta_ctbl_ret_igv
					adw_asiento_det.object.det_glosa		[ll_ins_det] = Mid(ls_desc_cnta_ret,1,100)
					adw_asiento_det.object.flag_debhab 	[ll_ins_det] = ls_flag_debhab_ret
					adw_asiento_det.object.imp_movsol  	[ll_ins_det] = ldc_imp_retencion
					adw_asiento_det.object.imp_movdol  	[ll_ins_det] = Round(ldc_imp_retencion / ldc_tasa_cambio,2)						  
							
					/*Indicadores de Cnta Cntbl*/
					IF ls_flag_doc_ref_ret = '1' THEN
						adw_asiento_det.object.tipo_docref1 [ll_ins_det] = gnvo_app.finparam.is_doc_ret
						adw_asiento_det.object.nro_docref1  [ll_ins_det] = astr_param.nro_certificado
					END IF
					 
					IF ls_flag_codrel_ret = '1' THEN
						adw_asiento_det.object.cod_relacion [ll_ins_det]	= ls_cod_relacion
					END IF
							
				ELSE
					adw_asiento_det.object.imp_movsol  [ll_found] = adw_asiento_det.object.imp_movsol  [ll_found] + ldc_imp_retencion
					adw_asiento_det.object.imp_movdol  [ll_found] = adw_asiento_det.object.imp_movdol  [ll_found] + Round(ldc_imp_retencion / ldc_tasa_cambio,2)						  						 
				END IF
			END IF
		ELSE
			adw_asiento_det.Reset()
			ex.SetMessage('Documento de Referencias '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc) +' Tiene Problemas , Verifique!')
			throw ex
		END IF	/*cierre de cnta contable*/
	end if	
	
NEXT	

//Hago el asiento de ajuste
this.of_generar_ajuste(adw_asiento_cab, adw_asiento_det)

return true
end function

public function boolean of_generar_asiento_cxp_cxc (u_dw_abc adw_master, u_dw_abc adw_detail, u_dw_abc adw_referencias, u_dw_abc adw_impuestos, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, tab at_tab1, string as_flag_cxc_cxp);Long 		   ll_inicio,			ll_imatriz,				ll_row_ins,			ll_found,		ll_found_imp,	ll_inicio_for, 	&
				ll_row_det
String      ls_confin,			ls_matriz,				ls_formula, 		ls_cnta_ctbl,	ls_expresion, 	ls_campo,		&
				ls_signo,			ls_glosa_texto,		ls_glosa_campo,	ls_desc_glosa,	ls_tipo_ref,	ls_nro_ref, 	&
				ls_flag_tip_ref, 	ls_moneda, 				ls_nro_oc, 			ls_nro_os,		ls_tipo_ref_det, &
				ls_nro_ref_det,	ls_cnta_ctbl_dif,		ls_desc_glosa_dif
				
Boolean     lb_retorno = TRUE ,lb_flag_cta = TRUE
Integer 	   li_pos = 1, li_pos_ini , li_pos_fin , li_cont ,li_item
String      ls_impuestos[],	ls_inicio[], ls_moneda_ref
Decimal 		ldc_importe_imp,	ldc_monto,	ldc_monto_imp,		ldc_imp_sol_old,	ldc_imp_dol_old, &
				ldc_tasa_cambio, ldc_impuesto

//Variables para la detraccion	
String			ls_flag_detraccion, ls_nro_detraccion, ls_flag_debhab_dif, ls_flag_debhab_dif_x_doc
decimal			ldc_imp_detraccion, ldc_tasa_cambio_ref, ldc_monto_soles

str_cnta_cntbl	lstr_cnta
str_parametros	lstr_param



try 
	adw_master.AcceptText()
	adw_detail.Accepttext()
	adw_asiento_det.Accepttext()
	
	DO WHILE adw_asiento_det.Rowcount() > 0
		adw_asiento_det.deleterow(0)
	LOOP
	
	/*Datos de Cabecera*/
	lstr_param.tipo_docref1	= adw_master.object.tipo_doc 	  		[1]
	lstr_param.nro_docref1	= adw_master.object.nro_doc  	  		[1]
	lstr_param.cod_relacion	= adw_master.object.cod_relacion 	[1]
	ldc_tasa_cambio		   = Dec(adw_master.object.tasa_cambio	[1])
	ls_moneda					= adw_master.object.cod_moneda		[1]
	
	//DAtos para la detraccion
	if adw_master.of_ExisteCampo("flag_detraccion") then
		ls_flag_detraccion		= adw_master.object.flag_detraccion	[1]
	else
		ls_flag_detraccion		= '0'
	end if
	
	if adw_master.of_ExisteCampo("imp_detraccion") then
		ldc_imp_detraccion		= Dec(adw_master.object.imp_detraccion	[1])
	else
		ldc_imp_detraccion		= 0
	end if
	
	if adw_master.of_ExisteCampo("nro_detraccion") then
		ls_nro_detraccion		= adw_master.object.nro_detraccion	[1]
	else
		ls_nro_detraccion		= ''
	end if
	/**/
	
	FOR ll_inicio = 1 TO adw_detail.Rowcount()  //Recorro dw Origen de los items A generar Cuenta Contable
		
		//Obtengo el numero de Item
		if adw_detail.of_ExisteCampo("nro_item") then
			li_item	 	= adw_detail.object.nro_item 		[ll_inicio]	
		elseif adw_detail.of_ExisteCampo("item") then
			li_item	 	= adw_detail.object.item 			[ll_inicio]	
		else
			MessageBox("Error", "No se ha especificado un campo nro_item / Item en el datawindows detalle, por favor verifique!", StopSign!)
			return false
		end if
	
		//Obtengo la tipo y numero de documento de referencia en el detalle, en el caso que existan
		If adw_detail.of_ExisteCampo("tipo_ref") then
			ls_tipo_ref_det	= adw_detail.object.tipo_ref	[ll_inicio]
		end if
		If adw_detail.of_ExisteCampo("nro_ref") then
			ls_nro_ref_det	= adw_detail.object.nro_ref	[ll_inicio]
		end if
		
		//SI no Tiene Documento de referencia entonces procedo a generar el asiento según la referencia o la matriz
		if IsNull(ls_tipo_ref_det) or IsNull(ls_nro_ref_det) or trim(lstr_param.tipo_docref1) = 'LC' &
			or as_flag_cxc_cxp = 'C' then
			
			/*Inicialización de Variables*/
			ls_confin 			= adw_detail.object.confin 		[ll_inicio]	
			ls_matriz 			= adw_detail.object.matriz_cntbl	[ll_inicio]
	
			/*Valido Si tiene concepto Financiero*/
			IF Isnull(ls_confin) OR Trim(ls_confin) = '' THEN
				Messagebox('Item Nº '+String(li_item) ,' no tiene asignado un concepto financiero, por favor verifique')
				adw_detail.setFocus()
				adw_detail.setColumn("confin")
				adw_asiento_det.Reset()
				at_tab1.SelectedTab = 1
				return false
			end if
			
			//Insercion de Cuentas dependiendo de la Matriz Contable
			IF Isnull(ls_matriz) OR Trim(ls_matriz) = ''  THEN
				Messagebox('Aviso','Concepto Financiero '+ls_confin+' No tiene vinculado ninguna matriz, por favor verifique')
				adw_detail.setFocus()
				adw_detail.setColumn("confin")
				adw_asiento_det.Reset()
				at_tab1.SelectedTab = 1
				return false
			END IF
				
			//Obtengo los datos de la referencia
			ls_nro_oc = '' ; ls_nro_os = ''
			if adw_detail.of_ExisteCampo("nro_oc") then
				ls_nro_oc = adw_detail.object.nro_oc [ll_inicio]
			end if
			if adw_detail.of_ExisteCampo("nro_os") then
				ls_nro_os = adw_detail.object.nro_os [ll_inicio]
			end if
			
			if as_flag_cxc_cxp = 'C' then
				
				if not IsNull(ls_tipo_ref_det) and trim(ls_tipo_ref_det) <> '' then
					
					ls_tipo_ref = ls_tipo_ref_det
					ls_nro_ref 	= ls_nro_ref_det
					
				elseif adw_referencias.RowCount() > 0 then
					
					ls_tipo_ref = adw_referencias.object.tipo_ref [1] 
					ls_nro_ref 	= adw_referencias.object.nro_ref  [1]
				
				else
					
					SetNull(ls_tipo_ref) 
					setNull(ls_nro_ref)
				
				end if
				
			elseif not IsNull(ls_nro_oc) and trim(ls_nro_oc) <> '' then
				
				ls_tipo_ref = gnvo_app.is_doc_oc
				ls_nro_ref	= ls_nro_oc
				
			elseif not IsNull(ls_nro_os) and trim(ls_nro_os) <> '' then
				
				ls_tipo_ref = gnvo_app.is_doc_os
				ls_nro_ref	= ls_nro_os
			
			elseif adw_referencias.RowCount() > 0 then
				
				ls_tipo_ref = adw_referencias.object.tipo_ref [1] 
				ls_nro_ref 	= adw_referencias.object.nro_ref  [1]
			
			else
				SetNull(ls_tipo_ref) 
				setNull(ls_nro_ref)
			end if
			
			//Recupero los datos de la matriz
			ids_matriz_cntbl.Retrieve(ls_matriz)					// Recuperación de Información de Matriz Detalle
			
			FOR ll_imatriz = 1 TO ids_matriz_cntbl.Rowcount()
				/**Inicializacion de Variables**/
				ls_impuestos = ls_inicio
			
				ldc_monto   	= 0.00
				ldc_monto_imp  = 0.00
				li_pos 	   	= 1
				li_pos_ini  	= 0
				li_pos_fin  	= 0
				li_cont   		= 0
				
				
				ls_cnta_ctbl 	 		  = ids_matriz_cntbl.Object.cnta_ctbl   	[ll_imatriz]
				lstr_cnta.desc_Cnta	  = ids_matriz_cntbl.Object.desc_cnta    	[ll_imatriz]
				lstr_param.flag_debhab = ids_matriz_cntbl.Object.flag_debhab  	[ll_imatriz]
		
				
				ls_formula      = ids_matriz_cntbl.Object.formula 	  		[ll_imatriz]
				ls_glosa_campo  = ids_matriz_cntbl.Object.glosa_campo  	[ll_imatriz]
				ls_glosa_texto	 = ids_matriz_cntbl.Object.glosa_texto  	[ll_imatriz]
				ls_flag_tip_ref = ids_matriz_cntbl.Object.flag_tip_ref 	[ll_imatriz]
				
				if IsNull(ls_formula) or trim(ls_formula) = '' then
					gnvo_app.of_message_error("La cuenta contable " + ls_cnta_ctbl + " de la matriz " + ls_matriz + " no tiene formula definida, por favor verifique!")
					return false
				end if
				
		
				/***************************************************/
				/*Asignación de Información requerida x Cta Cntbl */
				/***************************************************/
				if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then
					gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + ls_cnta_ctbl)
					return false
				end if
		
				IF lstr_cnta.flag_cencos = '1' THEN
					//*Verifico si columna existe en el detalle*//
					IF adw_detail.of_ExisteCampo('cencos') THEN  //Cuentas x Pagar	
						lstr_param.cencos = adw_detail.object.cencos [ll_inicio] 		 
						IF Isnull(lstr_param.cencos) THEN lstr_param.cencos = ''
					ELSE															  //Cuentas x Cobrar
						lstr_param.cencos = ''
					END IF
					/**/
				ELSE
					lstr_param.cencos = ''
				END IF
				
				IF lstr_cnta.flag_centro_benef = '1' THEN  //CENTRO DE BENEFICIO
					IF adw_detail.of_ExisteCampo('centro_benef') THEN  //Cuentas x Pagar	
						lstr_param.centro_benef = adw_detail.object.centro_benef [ll_inicio] 	
						IF Isnull(lstr_param.centro_benef) THEN lstr_param.centro_benef = ''	
					else
						lstr_param.centro_benef = ''
					end if
				else
					lstr_param.centro_benef = ''
				END IF
				
				IF lstr_cnta.flag_codrel = '1' THEN  //CENTRO DE BENEFICIO
					IF adw_master.of_ExisteCampo('cod_relacion') THEN  //Cuentas x Pagar	
						lstr_param.cod_relacion = adw_master.object.cod_relacion [1] 	
						IF Isnull(lstr_param.cod_relacion) THEN lstr_param.cod_relacion = ''	
					else
						lstr_param.cod_relacion = ''
					end if
				else
					lstr_param.cod_relacion = ''
				END IF
				
				//Documento de Referencia
				IF lstr_cnta.flag_doc_ref = '1' THEN  
					IF ls_flag_tip_ref = 'R' THEN /*DATOS DE DOCUMENTO DE REFERENCIA*/
						IF adw_referencias.Rowcount() = 0 or isNull(ls_nro_ref) or trim(ls_nro_ref) = '' THEN
							Messagebox('Aviso','Cuenta Contable '+ls_cnta_ctbl+' Requiere Documento de Referencia y en la matriz se ha configurado que se coloque el documento de referencia, por favor revisar la Matriz Contable ')
							adw_asiento_det.Reset()
							at_tab1.SelectedTab = 1
							return false
						end if
						
						lstr_param.tipo_docref1 = ls_tipo_ref //*en ctas x pagar solamnete existe una referencia*//
						lstr_param.nro_docref1 	= ls_nro_ref
						
					ELSE
						lstr_param.tipo_docref1	= adw_master.object.tipo_doc 	  		[1]
						lstr_param.nro_docref1	= adw_master.object.nro_doc  	  		[1]
					END IF
					
					IF Isnull(lstr_param.tipo_docref1) THEN lstr_param.tipo_docref1 = ''	
					IF Isnull(lstr_param.nro_docref1) THEN lstr_param.nro_docref1 = ''	
					
				else
					lstr_param.tipo_docref1 = ''
					lstr_param.nro_docref1 = ''
				END IF
		
				
				/*Función de llenado de datastore*/
				this.of_glosa_cxc_cxp(	adw_master, &
												adw_detail, &
												ll_inicio, &
												lstr_cnta, &
												as_flag_cxc_cxp)
				/**/
				
				/***********************/
				li_pos_ini     = Pos(ls_formula,'[',li_pos) 
				
				IF li_pos_ini = 1 THEN       /*Formula Pura de Impuestos */
					ldc_monto  = 0.00
				ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
					ls_campo = Mid(ls_formula,1,li_pos_ini - 2)
		
					if not adw_detail.of_ExisteCampo(ls_campo) then
						gnvo_app.of_mensaje_error("Error, no existe el campo " + ls_campo + ", por favor revisar la formula de la matriz " + ls_matriz, '')
						return false
					end if
					
					ldc_monto  = adw_detail.Getitemnumber(ll_inicio,ls_campo)
					
				ELSEIF li_pos_ini = 0 THEN	  /*Campo*/
					
					if not adw_detail.of_ExisteCampo(ls_formula) then
						f_mensaje("Error, no existe el campo " + ls_formula + ", por favor revisar la formula de la matriz " + ls_matriz, '')
						return false
					end if
					
					ldc_monto  = adw_detail.Getitemnumber(ll_inicio,ls_formula)
				END IF
				
				
				//Revisando la formula para sacar los datos de los impuestos
				DO WHILE li_pos_ini > 0
					li_cont ++
					li_pos_fin = Pos(ls_formula,']',li_pos_ini) 
					ls_impuestos [li_cont] = Mid(ls_formula,li_pos_ini + 1,li_pos_fin - (li_pos_ini + 1))
					
					//Inicializa Valor
					li_pos_ini = Pos(ls_formula,'[',li_pos_fin) 
				LOOP
				
				/*****Calculo de Monto si existiese Formula*****/
				IF UpperBound(ls_impuestos) > 0 THEN
					FOR ll_inicio_for = 1 TO UpperBound(ls_impuestos)
						 /*Inicializa Monto de Impuesto*/
						 ls_expresion = "item = " + Trim(String(li_item)) &
										  + " AND tipo_impuesto = '"+ls_impuestos[ll_inicio_for]+"'"
			
						 ll_found = adw_impuestos.find(ls_expresion, 1, adw_impuestos.Rowcount())
						 
						 IF ll_found > 0 THEN
							 ls_signo  			 = adw_impuestos.object.signo 	[ll_found] 	
							 ldc_importe_imp   = adw_impuestos.object.importe	[ll_found] 	
							 
							 IF ls_signo   = '+' THEN
								 ldc_monto_imp = ldc_monto_imp + ldc_importe_imp
							 ELSEIF ls_signo = '-'	THEN
								 ldc_monto_imp = ldc_monto_imp - ldc_importe_imp
							 END IF
							 
						 END IF
					 NEXT
					 
					 ldc_monto += ldc_monto_imp
				END IF
				
				/***************************************************/
				/*Expresión para busqueda en el detalle del asiento */
				/***************************************************/
				ls_expresion 	 = this.of_generar_expresion(lstr_cnta, lstr_param)
				ll_found        = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
			
				IF ll_found = 0 THEN
					/*Extraer Glosa*/
					ls_desc_glosa = invo_asiento_glosa.of_set_glosa(ids_glosa,1,ls_glosa_texto,ls_glosa_campo)
					
					//Si la glosa es nula o esta en blanco entonces le pongo la descripción de la cuenta contable
					if IsNull(ls_desc_glosa) or trim(ls_desc_glosa) = '' then
						ls_desc_glosa = lstr_cnta.desc_cnta
					end if
					
					ll_row_ins    = adw_asiento_det.event ue_insert()
					if ll_row_ins > 0 then
						adw_asiento_det.Object.item		  [ll_row_ins] = ll_row_ins
						adw_asiento_det.Object.cnta_ctbl   [ll_row_ins] = Mid(ids_matriz_cntbl.Object.cnta_ctbl  [ll_imatriz],1,60)
						adw_asiento_det.Object.flag_debhab [ll_row_ins] = ids_matriz_cntbl.Object.flag_debhab[ll_imatriz]
						adw_asiento_det.Object.det_glosa   [ll_row_ins] = Mid(ls_desc_glosa,1,100)
						
						/*Asignacion de Valores de Acuerdo a Flag de Cuentas*/
						IF lstr_cnta.flag_doc_ref = '1' THEN
							adw_asiento_det.Object.tipo_docref1[ll_row_ins] = lstr_param.tipo_docref1
							adw_asiento_det.Object.nro_docref1 [ll_row_ins] = lstr_param.nro_docref1
						END IF
						
						IF lstr_cnta.flag_codrel = '1' THEN
							adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
						END IF
						
						IF lstr_cnta.flag_cencos = '1' THEN
							adw_asiento_det.Object.cencos [ll_row_ins] = lstr_param.cencos
						END IF
						
						IF lstr_cnta.flag_centro_benef = '1' THEN
							adw_asiento_det.Object.centro_benef [ll_row_ins] = lstr_param.centro_benef
						END IF
						
						IF lstr_cnta.flag_ctabco = '1' THEN
							adw_asiento_det.Object.cod_ctabco [ll_row_ins] = lstr_param.cod_ctabco
						END IF
					end if
					
					/*Montos de Pre Asientos*/
					IF ls_moneda = is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_row_ins] = abs(ldc_monto)					
						adw_asiento_det.Object.imp_movdol [ll_row_ins] = abs(Round(ldc_monto / ldc_tasa_cambio,2))
					ELSEIF ls_moneda = is_dolares THEN
						adw_asiento_det.Object.imp_movdol [ll_row_ins] = abs(ldc_monto)
						adw_asiento_det.Object.imp_movsol [ll_row_ins] = abs(Round(ldc_monto * ldc_tasa_cambio,2))
					END IF
					
				ELSE
			
					IF ls_moneda = is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + abs(ldc_monto)					
						adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + abs(Round(ldc_monto / ldc_tasa_cambio,2))
					ELSEIF ls_moneda = is_dolares THEN
						ldc_imp_sol_old = adw_asiento_det.Object.imp_movsol [ll_found]
						ldc_imp_dol_old = adw_asiento_det.Object.imp_movdol [ll_found]
						
						adw_asiento_det.Object.imp_movdol [ll_found] = ldc_imp_dol_old + abs(ldc_monto)
						adw_asiento_det.Object.imp_movsol [ll_found] = ldc_imp_sol_old + abs(Round(ldc_monto * ldc_tasa_cambio,2))
						
					END IF
				END IF
			NEXT  //For de la matriz
		
		else
			if as_flag_cxc_cxp <> 'C' then //Por ahora es solo para cntas por pagar
				/**********************************************************************
				 ***** Cuanto Tiene Documento de Referencia entonces busco el documento
				 ***** de referencia y saco la cuenta contable y demas datos
				 ***** para el asiento contable
				 ************************************************************************/
				lstr_param.cod_relacion	= adw_master.object.cod_relacion 	[1]
				
				ldc_monto					= Dec(adw_detail.object.importe 	[ll_inicio])
				lstr_param.cencos			= adw_detail.object.cencos 		[ll_inicio]
				
				select 	cp.cod_moneda, cad.cnta_ctbl, cp.tasa_cambio, cp.descripcion, 
							cp.tasa_cambio
					into 	:ls_moneda_ref, :ls_cnta_ctbl, :ldc_tasa_cambio_ref, :ls_desc_glosa, 
							:ldc_tasa_cambio_ref
				from cntbl_asiento ca,
					  cntbl_Asiento_det cad,
					  cntas_pagar       cp
				where ca.origen        = cad.origen
				  and ca.ano           = cad.ano
				  and ca.mes           = cad.mes
				  and ca.nro_libro     = cad.nro_libro
				  and ca.nro_asiento   = cad.nro_asiento     
				  and cad.cod_relacion = cp.cod_relacion
				  and cad.tipo_docref1 = cp.tipo_doc
				  and cad.nro_docref1  = cp.nro_doc
				  and cp.nro_asiento      is not null
				  and cp.cod_relacion	= :lstr_param.cod_relacion
				  and cp.tipo_doc			= :ls_tipo_ref_det
				  and cp.nro_doc			= :ls_nro_ref_det
				  and cad.cnta_ctbl    in (:gnvo_app.finparam.is_cnta_cntbl_ant1, 
													:gnvo_app.finparam.is_cnta_cntbl_ant2, 
													:gnvo_app.finparam.is_cnta_cntbl_ant3)
				group by cp.tipo_doc,
						 cp.nro_doc,
						 cp.fecha_emision,
						 cp.tasa_cambio,
						 cp.descripcion,
						 cp.cod_moneda,
						 cad.cnta_ctbl;
				
				//Valido que exista alguna informacion
				if SQLCA.SQLCode = 100 then
					MessageBox('Error', 'No se ha encontrado informacion de Documento por pagar, por favor verifique!' &
											 + "~r~nCod Relacion: " + lstr_param.cod_relacion &
											 + "~r~nTipo Doc: " + ls_tipo_ref_Det &
											 + "~r~nCod Relacion: " + ls_nro_ref_det, StopSign!)
					return false
				end if
				
				/***************************************************/
				/*Asignación de Información requerida x Cta Cntbl */
				/***************************************************/
				if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then
					gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + ls_cnta_ctbl)
					return false
				end if
			
				IF lstr_cnta.flag_cencos = '1' THEN
					//*Verifico si columna existe en el detalle*//
					IF adw_detail.of_ExisteCampo('cencos') THEN  //Cuentas x Pagar	
						lstr_param.cencos = adw_detail.object.cencos [ll_inicio] 		 
						IF Isnull(lstr_param.cencos) THEN lstr_param.cencos = ''
					ELSE															  //Cuentas x Cobrar
						lstr_param.cencos = ''
					END IF
					/**/
				ELSE
					lstr_param.cencos = ''
				END IF
					
				IF lstr_cnta.flag_centro_benef = '1' THEN  //CENTRO DE BENEFICIO
					IF adw_detail.of_ExisteCampo('centro_benef') THEN  //Cuentas x Pagar	
						lstr_param.centro_benef = adw_detail.object.centro_benef [ll_inicio] 	
						IF Isnull(lstr_param.centro_benef) THEN lstr_param.centro_benef = ''	
					else
						lstr_param.centro_benef = ''
					end if
				else
					lstr_param.centro_benef = ''
				END IF
					
				IF lstr_cnta.flag_codrel = '1' THEN  //CENTRO DE BENEFICIO
					IF adw_master.of_ExisteCampo('cod_relacion') THEN  //Cuentas x Pagar	
						lstr_param.cod_relacion = adw_master.object.cod_relacion [1] 	
						IF Isnull(lstr_param.cod_relacion) THEN lstr_param.cod_relacion = ''	
					else
						lstr_param.cod_relacion = ''
					end if
				else
					lstr_param.cod_relacion = ''
				END IF
					
				//Documento de Referencia
				IF lstr_cnta.flag_doc_ref = '1' THEN  
					lstr_param.tipo_docref1	= ls_tipo_ref_det
					lstr_param.nro_docref1	= ls_nro_ref_det
					
				else
					lstr_param.tipo_docref1 = ''
					lstr_param.nro_docref1 = ''
				END IF
				
				//Inserto el registro
				/***************************/
				ls_expresion 	 = this.of_generar_expresion(lstr_cnta, lstr_param)
				ll_found        = adw_asiento_det.find(ls_expresion, 1, adw_asiento_det.rowcount())
			
				IF ll_found = 0 THEN
					/*Extraer Glosa*/
					ls_desc_glosa = invo_asiento_glosa.of_set_glosa(ids_glosa,1,ls_glosa_texto,ls_glosa_campo)
					
					//Si la glosa es nula o esta en blanco entonces le pongo la descripción de la cuenta contable
					if IsNull(ls_desc_glosa) or trim(ls_desc_glosa) = '' then
						ls_desc_glosa = lstr_cnta.desc_cnta
					end if
					
					//Inserto nuevo registro
					ll_row_ins    = adw_asiento_det.event ue_insert()
					if ll_row_ins > 0 then
						adw_asiento_det.Object.item		  	[ll_row_ins] = ll_row_ins
						adw_asiento_det.Object.cnta_ctbl   	[ll_row_ins] = ls_cnta_ctbl
						adw_asiento_det.Object.flag_debhab 	[ll_row_ins] = 'H'
						adw_asiento_det.Object.det_glosa   	[ll_row_ins] = Mid(ls_desc_glosa,1,100)
						
						/*Asignacion de Valores de Acuerdo a Flag de Cuentas*/
						IF lstr_cnta.flag_doc_ref = '1' THEN
							adw_asiento_det.Object.tipo_docref1[ll_row_ins] = lstr_param.tipo_docref1
							adw_asiento_det.Object.nro_docref1 [ll_row_ins] = lstr_param.nro_docref1
						END IF
						
						IF lstr_cnta.flag_codrel = '1' THEN
							adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
						END IF
						
						IF lstr_cnta.flag_cencos = '1' THEN
							adw_asiento_det.Object.cencos [ll_row_ins] = lstr_param.cencos
						END IF
						
						IF lstr_cnta.flag_centro_benef = '1' THEN
							adw_asiento_det.Object.centro_benef [ll_row_ins] = lstr_param.centro_benef
						END IF
						
						IF lstr_cnta.flag_ctabco = '1' THEN
							adw_asiento_det.Object.cod_ctabco [ll_row_ins] = lstr_param.cod_ctabco
						END IF
					end if
					
					/*Montos de Pre Asientos*/
					IF ls_moneda = is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_row_ins] = abs(ldc_monto)					
						adw_asiento_det.Object.imp_movdol [ll_row_ins] = abs(Round(ldc_monto / ldc_tasa_cambio,2))
					ELSEIF ls_moneda = is_dolares THEN
						adw_asiento_det.Object.imp_movdol [ll_row_ins] = abs(ldc_monto)
						adw_asiento_det.Object.imp_movsol [ll_row_ins] = abs(Round(ldc_monto * ldc_tasa_cambio,2))
					END IF
					
				ELSE
			
					IF ls_moneda = is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + abs(ldc_monto)					
						adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + abs(Round(ldc_monto / ldc_tasa_cambio,2))
					ELSEIF ls_moneda = is_dolares THEN
						ldc_imp_sol_old = adw_asiento_det.Object.imp_movsol [ll_found]
						ldc_imp_dol_old = adw_asiento_det.Object.imp_movdol [ll_found]
						
						adw_asiento_det.Object.imp_movdol [ll_found] = ldc_imp_dol_old + abs(ldc_monto)
						adw_asiento_det.Object.imp_movsol [ll_found] = ldc_imp_sol_old + abs(Round(ldc_monto * ldc_tasa_cambio,2))
					END IF
				END IF
				
				/********************************************************************************/
				/*
					Hago el proceso de ajuste por tipo de cambio
				*/
				/********************************************************************************/
				lstr_param.tipo_docref1	= adw_master.object.tipo_doc 	[1]
				lstr_param.nro_docref1	= adw_master.object.nro_doc  	[1]
				lstr_param.cencos			= adw_detail.object.cencos 	[ll_inicio]
				
				IF ls_moneda_ref = gnvo_app.is_dolares THEN /*SE REVISARA DIFERENCIA EN CAMBIO*/
					
					if IsNull(ldc_tasa_cambio_ref) then ldc_tasa_cambio_ref = 0
					
					if ldc_tasa_cambio_ref > 0 and ldc_tasa_cambio_ref <> ldc_tasa_cambio then
						if ldc_tasa_cambio > ldc_tasa_cambio_ref then
							ls_cnta_ctbl_dif         = gnvo_app.is_cta_ctbl_per
						 
							ls_flag_debhab_dif       = 'H'
							ls_flag_debhab_dif_x_doc = 'D'
						 
							ls_desc_glosa_dif  = 'Diferencia en Cambio Dolar se Incremento [' + string(ldc_tasa_cambio_ref, '###,##0.0000') + ']'
		
						else
							ls_cnta_ctbl_dif         = gnvo_app.is_cta_ctbl_gan
						 
							ls_flag_debhab_dif       = 'D'
							ls_flag_debhab_dif_x_doc = 'H'
						 
							ls_desc_glosa_dif  = 'Diferencia en Cambio Dolar Disminuyo [' + string(ldc_tasa_cambio_ref, '###,##0.0000') + ']'
						end if
						
						//Genero el tipo de cambio
						ls_expresion = "cnta_ctbl = '" + ls_cnta_ctbl_dif + "'" &
										 + " AND flag_debhab = '" + ls_flag_debhab_dif + "'" &
										 + " AND tipo_docref1 = '" + lstr_param.tipo_docref1 + "'" &
										 + " and nro_docref1 = '" + lstr_param.nro_docref1 + "'"
						ll_found     = adw_asiento_det.Find(ls_expresion, 1, adw_asiento_det.Rowcount())
						
						IF ll_found > 0 THEN
							ldc_monto_soles = adw_asiento_det.object.imp_movsol  [ll_found]
							adw_asiento_det.object.imp_movsol  [ll_found] = abs(ldc_monto_soles) + abs((ldc_tasa_cambio_ref - ldc_tasa_cambio) * ldc_monto)
						ELSE
							/*Asiento de Diferencia en cambio*/
							ll_found = adw_asiento_det.event ue_insert()
							if ll_found > 0 then
								adw_asiento_det.Object.item	       [ll_found] = ll_found
								adw_asiento_det.Object.cnta_ctbl     [ll_found] = ls_cnta_ctbl_dif
								adw_asiento_det.Object.det_glosa     [ll_found] = ls_desc_glosa_dif
								adw_asiento_det.Object.flag_debhab   [ll_found] = ls_flag_debhab_dif  
								adw_asiento_det.Object.cencos 		 [ll_found] = lstr_param.cencos
								adw_asiento_det.Object.tipo_docref1  [ll_found] = ls_tipo_ref_det
								adw_asiento_det.Object.nro_docref1	 [ll_found] = ls_nro_ref_det
								adw_asiento_det.object.imp_movsol    [ll_found] = abs((ldc_tasa_cambio_ref - ldc_tasa_cambio) * ldc_monto)
								adw_asiento_det.object.imp_movdol    [ll_found] = 0.00
								adw_asiento_det.object.flag_doc_edit [ll_found] = 'E' 
							end if
						END IF /*Busqueda de cuenta generada para acumular*/		
						 
						/*Asiento de doc x diferencia en cambio*/	
						ll_found = adw_asiento_det.event ue_insert()
						if ll_found > 0 then
							adw_asiento_det.Object.item	        	[ll_found] = ll_found
							adw_asiento_det.Object.cnta_ctbl     	[ll_found] = ls_cnta_ctbl
							adw_asiento_det.Object.det_glosa     	[ll_found] = ls_desc_glosa
							adw_asiento_det.Object.tipo_docref1  	[ll_found] = ls_tipo_ref_det
							adw_asiento_det.Object.nro_docref1   	[ll_found] = ls_nro_ref_det
							adw_asiento_det.Object.cod_relacion  	[ll_found] = lstr_param.cod_relacion 
							adw_asiento_det.Object.cencos 		  	[ll_found] = lstr_param.cencos		
							adw_asiento_det.Object.flag_debhab   	[ll_found] = ls_flag_debhab_dif_x_doc  
							adw_asiento_det.object.imp_movsol    	[ll_found] = abs((ldc_tasa_cambio_ref - ldc_tasa_cambio) * ldc_monto)
							adw_asiento_det.object.imp_movdol    	[ll_found] = 0.00
							adw_asiento_det.object.flag_doc_edit 	[ll_found] = 'E' 
						end if
					end if
					
				END IF /*CIERRA X TIPO DE MONEDA*/
		
				
				/********************************************************************************/
				/*
					Inserto ahora la cuenta de proveedores disminuyendo el importe de la factura
					tambien tengo que restar el impuesto de la factura
				*/
				/********************************************************************************/
				lstr_param.tipo_docref1	= adw_master.object.tipo_doc 	  		[1]
				lstr_param.nro_docref1	= adw_master.object.nro_doc  	  		[1]
				ldc_monto					= abs(Dec(adw_detail.object.importe 		[ll_inicio]))
				
				
				if ldc_monto > 0 then
					/*Inicializa Monto de Impuesto*/
					ldc_importe_imp = 0
					
					ls_expresion = "item = " + Trim(String(li_item))
					ll_found = adw_impuestos.find(ls_expresion, 1, adw_impuestos.Rowcount())
					
					do while ll_found > 0 
						ls_signo  			= adw_impuestos.object.signo 		[ll_found] 	
						
						IF ls_signo   = '+' THEN
							ldc_importe_imp   = ldc_importe_imp + Dec(adw_impuestos.object.importe	[ll_found]) 	
						ELSEIF ls_signo = '-'	THEN
							ldc_importe_imp   = ldc_importe_imp - Dec(adw_impuestos.object.importe	[ll_found]) 	
						END IF
						if ll_found < adw_impuestos.RowCount() then
							ll_found = adw_impuestos.find(ls_expresion, ll_found + 1, adw_impuestos.Rowcount())
						else
							ll_found = 0
						end if
					loop
					
					ldc_monto += abs(ldc_importe_imp)
					
					ls_expresion = "cod_relacion='" + lstr_param.cod_relacion + "'" &
									 + " and tipo_docref1='" + lstr_param.tipo_docref1 + "'" &
									 + " and nro_docref1='" + lstr_param.nro_docref1 + "'"
					ll_found = adw_asiento_det.Find(ls_expresion, 1, adw_asiento_det.RowCount())
					
					if ll_found = 0 then
						MessageBox("Error", "No existe referencia del comprobante de pago que esta " &
														 + "provisionando en el asiento contable. Debe tener una " &
														 + "referencia completa para aplicar el descuento." &
														 + "~r~n1. Verifique si el descuento esta al final del documento. " &
														 + "~r~n2. Verifique que la matriz que esta usando en todo el detalle del documento es correcto" &
														 + "~r~n3. Verifique si las cuentas contables que esta usando en esta provisión han sido configuradas correctamente" &
														 + "~r~nDatos del document. " &
														 + "~r~nCod Relacion : " + lstr_param.cod_relacion &
														 + "~r~nTipo Documento : " + lstr_param.tipo_docref1 &
														 + "~r~nNro. Documento : " + lstr_param.nro_docref1, STopSign! )
						return false
					end if
					
					//Valido si el docuemtno esta en una sola cuenta corriente, sino hay que modificarla
					if adw_asiento_det.Find(ls_expresion, ll_found + 1, adw_asiento_det.RowCount()) > 0 then
						MessageBox("Error", "Existe mas de una cuenta contable que tienen como referencia al documento, por favor revise los siguientes puntos:" &
														 + "~r~n1. Verifique si el descuento esta al final del documento. " &
														 + "~r~n2. Verifique que la matriz que esta usando en todo el detalle del documento es correcto" &
														 + "~r~n3. Verifique si las cuentas contables que esta usando en esta provisión han sido configuradas correctamente" &
														 + "~r~nDatos del document. " &
														 + "~r~nCod Relacion : " + lstr_param.cod_relacion &
														 + "~r~nTipo Documento : " + lstr_param.tipo_docref1 &
														 + "~r~nNro. Documento : " + lstr_param.nro_docref1, StopSign! )
						return false
					end if
					
					IF ls_moneda = is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] - abs(ldc_monto)
						adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] - abs(Round(ldc_monto / ldc_tasa_cambio,2))
					ELSEIF ls_moneda = is_dolares THEN
						adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] - abs(ldc_monto)
						adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] - abs(Round(ldc_monto * ldc_tasa_cambio,2))
					END IF
				end if
				
			end if
		end if
		
	NEXT	//For de idw_Detail
	
	
	/********************************************************************************/
	/*
	//Ingreso la linea de la detraccion
	*/
	/********************************************************************************/
	if (gnvo_app.finparam.is_dtrp_prov = '1' or gnvo_app.finparam.is_dtrc_prov = '1') and ls_flag_detraccion = '1' then
		Decimal ldc_detr_sol, ldc_detr_dol
		
		lstr_param.tipo_docref1	= adw_master.object.tipo_doc 	  		[1]
		lstr_param.nro_docref1	= adw_master.object.nro_doc  	  		[1]
		lstr_param.cod_relacion	= adw_master.object.cod_relacion 	[1]
	
	
		if ldc_imp_detraccion = 0 then 
			gnvo_app.of_message_error("No se ha indicado un monto de detraccion, por favor verifique!")
			return false
		end if
		
		if ISNull(ls_nro_detraccion) or trim(ls_nro_detraccion) = '' then 
			gnvo_app.of_message_error("No se especificado un numero de detraccion, por favor verifique!")
			return false
		end if
		
		//Valido la cuenta contable de la detraccion ya sea por cobrar o por pagar
		if as_flag_cxc_cxp = 'C' then
			if ISNull(gnvo_app.finparam.is_cnta_cntbl_dtrc) or trim(gnvo_app.finparam.is_cnta_cntbl_dtrc) = '' then 
				gnvo_app.of_message_error("No se especificado una cuenta contable para las detracciones por COBRAR en tabla de CONFIGURACION, por favor verifique!")
				return false
			end if
		else
			if ISNull(gnvo_app.finparam.is_cnta_cntbl_dtrp) or trim(gnvo_app.finparam.is_cnta_cntbl_dtrp) = '' then 
				gnvo_app.of_message_error("No se especificado una cuenta contable para las detracciones por PAGAR en tabla de CONFIGURACION, por favor verifique!")
				return false
			end if
		end if
		
		/***************************************************/
		/*Asignación de Información requerida x Cta Cntbl */
		/***************************************************/
		if as_flag_cxc_cxp = 'C' then
			if not invo_cntbl.of_cnta_cntbl(gnvo_app.finparam.is_cnta_cntbl_dtrc, lstr_cnta) then
				gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + gnvo_app.finparam.is_cnta_cntbl_dtrc)
				return false
			end if
		else
			if not invo_cntbl.of_cnta_cntbl(gnvo_app.finparam.is_cnta_cntbl_dtrp, lstr_cnta) then
				gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + gnvo_app.finparam.is_cnta_cntbl_dtrp)
				return false
			end if
		end if
		
		//Obtengo el valor según la moneda
		ldc_detr_sol = ldc_imp_detraccion
		ldc_detr_dol = Round(ldc_imp_detraccion / ldc_tasa_cambio,2)
		
		//Busco el item en el asiento contable donde esta la factura correspondiente
		//para restarle su valor
		ls_expresion = "cod_relacion='"       + lstr_param.cod_relacion &
						 + "' and tipo_docref1='" + lstr_param.tipo_docref1 &
						 + "' and nro_docref1='"  + lstr_param.nro_docref1  + "'" 
			
		if as_flag_cxc_cxp = 'C' then
			ls_expresion += " and flag_debhab='D'"
		else
			ls_expresion += " and flag_debhab='H'"
		end if
	
		ll_found = adw_asiento_det.Find(ls_expresion, 1, adw_asiento_det.RowCount())
		
		if ll_found  = 0 then
			gnvo_app.of_message_error("No existe el detalle del asiento contable una referencia al documento de origen, por favor verifique! " &
										+ "~r~nCod Relacion: " + lstr_param.cod_relacion &
										+ "~r~nTipo Doc: " + lstr_param.tipo_docref1 &
										+ "~r~nNro Documento: " + lstr_param.nro_docref1)
			return false
		end if
		
		adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] - ldc_detr_sol
		adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] - ldc_detr_dol
		
		// Ahora inserto la linea de la detraccion
		if as_flag_cxc_cxp = 'C' then
			lstr_param.flag_debhab = 'D' //adw_asiento_det.Object.flag_debhab 	[ll_found]
		else
			lstr_param.flag_debhab = 'H' //adw_asiento_det.Object.flag_debhab 	[ll_found]
		end if
		
		ll_row_ins    = adw_asiento_det.event ue_insert()
		if ll_row_ins > 0 then
			adw_asiento_det.Object.item	  		[ll_row_ins] = ll_row_ins
			
			if as_flag_cxc_cxp = 'C' then
				adw_asiento_det.Object.cnta_ctbl	[ll_row_ins] = gnvo_app.finparam.is_cnta_cntbl_dtrc
			else
				adw_asiento_det.Object.cnta_ctbl	[ll_row_ins] = gnvo_app.finparam.is_cnta_cntbl_dtrp
			end if
			
			adw_asiento_det.Object.flag_debhab 	[ll_row_ins] = lstr_param.flag_debhab
			adw_asiento_det.Object.det_glosa    [ll_row_ins] = lstr_cnta.desc_cnta
			
			/*Asignacion de Valores de Acuerdo a Flag de Cuentas*/
			IF lstr_cnta.flag_doc_ref = '1' THEN
				if as_flag_cxc_cxp = 'C' then
					adw_asiento_det.Object.tipo_docref1	[ll_row_ins] = gnvo_app.finparam.is_doc_dtrc
				else
					adw_asiento_det.Object.tipo_docref1	[ll_row_ins] = gnvo_app.finparam.is_doc_dtrp
				end if
				adw_asiento_det.Object.nro_docref1 		[ll_row_ins] = ls_nro_detraccion
			END IF
			
			IF lstr_cnta.flag_codrel = '1' THEN
				adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
			END IF
			
			adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_detr_sol
			adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_detr_dol
			
		end if
	
		
	end if
	
	/********************************************************************************/
	/*
	//Añado al asiento los impuestos
	*/
	/********************************************************************************/
	FOR ll_inicio = 1 TO adw_impuestos.Rowcount()
	
		ls_cnta_ctbl    		  = adw_impuestos.Object.cnta_ctbl   	[ll_inicio]
		li_item			 		  = adw_impuestos.Object.item  			[ll_inicio]
		
		if adw_impuestos.object.flag_igv [ll_inicio] = '1' then
			//En caso de IGV se debe poner ya un falg_debe_haber según si es Cuenta por Cobrar o por Pagar
			if as_flag_cxc_cxp = 'C' then
				lstr_param.flag_debhab = 'H'
			else
				lstr_param.flag_debhab = 'D'
			end if
		else
			lstr_param.flag_debhab = adw_impuestos.object.flag_dh_cxp 	[ll_inicio]				
		end if
		
		
		IF Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '' THEN
			Messagebox('Fila de Impuestos Nº '+String(ll_inicio) ,' No se Ha ingresado Cuenta Contable de Impuesto, por favor verifique!')
			adw_asiento_det.Reset()
			adw_impuestos.SetRow(ll_inicio)
			at_tab1.SelectedTab = 3
			return false
		END IF
		
		IF Isnull(lstr_param.flag_debhab) OR Trim(lstr_param.flag_debhab) = '' THEN
			Messagebox('Fila de Impuestos Nº '+String(ll_inicio) ,' No se Ha ingresado Flag de Debe ó Haber de Impuesto, por favor verifique!')
			adw_asiento_det.Reset()
			adw_impuestos.SetRow(ll_inicio)
			at_tab1.SelectedTab = 3
			return false
		END IF
		
		lstr_cnta.desc_cnta	= adw_impuestos.object.desc_cnta	 	[ll_inicio]
		ldc_importe_imp 		= Dec(adw_impuestos.Object.importe 	[ll_inicio])
		
		//Si el importe del impuesto es negativo entonces simplemente cambio el flag
		if ldc_importe_imp < 0 then
			if lstr_param.flag_debhab = 'H' then
				lstr_param.flag_debhab = 'D'
			else
				lstr_param.flag_debhab = 'H'
			end if
			ldc_importe_imp = abs(ldc_importe_imp)
		end if
		
		//Obtengo la descripcion de la cuenta
		lstr_cnta.desc_cnta = Mid(lstr_cnta.desc_cnta,1,100)
		
		/***************************************************/
		/*Asignación de Información requerida x Cta Cntbl */
		/***************************************************/
		if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then
			gnvo_app.of_mensaje_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + ls_cnta_ctbl)
			return false
		end if
		
		//Busco el item correspondiente en el detalle del comprobante
		if adw_detail.of_ExisteCampo("nro_item") then
			ls_expresion = "nro_item =" + string(li_item)
		elseif adw_detail.of_ExisteCampo("item") then
			ls_expresion = "item =" + string(li_item)
		else
			MessageBox("Error", "No se ha especificado un campo nro_item / Item en el datawindows detalle, por favor verifique!", StopSign!)
			return false
		end if
		
		ll_row_det = adw_detail.Find(ls_expresion, 1, adw_detail.RowCount())
		if ll_row_det  = 0 then
			gnvo_app.of_mensaje_error("No existe el registro con item " + string(li_item) + " en el detalle del documento.", "")
			return false
		end if
		
		if adw_detail.of_ExisteCampo("tipo_ref") then
			ls_tipo_ref_det = adw_detail.Object.tipo_ref [ll_row_det]
		else
			SetNull(ls_tipo_ref_det)
		end if
		
		if adw_detail.of_ExisteCampo("nro_ref") then
			ls_nro_ref_det	= adw_detail.Object.nro_ref [ll_row_det]
		else
			SetNull(ls_nro_ref_det)
		end if
		
		//Lleno los datos de la cuenta contable según los flags de la cuenta contable
		IF lstr_cnta.flag_cencos = '1' THEN
			//*Verifico si columna existe en el detalle*//
			IF adw_detail.of_ExisteCampo('cencos') THEN  //Cuentas x Pagar	
				lstr_param.cencos = adw_detail.object.cencos [ll_row_det] 		 
				IF Isnull(lstr_param.cencos) THEN lstr_param.cencos = ''
			ELSE															  //Cuentas x Cobrar
				lstr_param.cencos = ''
			END IF
			/**/
		ELSE
			lstr_param.cencos = ''
		END IF
		
		IF lstr_cnta.flag_centro_benef = '1' THEN  //CENTRO DE BENEFICIO
			IF adw_detail.of_ExisteCampo('centro_benef') THEN  //Cuentas x Pagar	
				lstr_param.centro_benef = adw_detail.object.centro_benef [ll_row_det] 	
				IF Isnull(lstr_param.centro_benef) THEN lstr_param.centro_benef = ''	
			else
				lstr_param.centro_benef = ''
			end if
		else
			lstr_param.centro_benef = ''
		END IF
		
		IF lstr_cnta.flag_codrel = '1' THEN  //CENTRO DE BENEFICIO
			IF adw_detail.of_ExisteCampo('cod_relacion') THEN  //Cuentas x Pagar	
				lstr_param.cod_relacion = adw_detail.object.cod_relacion [ll_row_det] 	
				IF Isnull(lstr_param.cod_relacion) THEN lstr_param.cod_relacion = ''	
			else
				lstr_param.cod_relacion = ''
			end if
		else
			lstr_param.cod_relacion = ''
		END IF
	
		IF lstr_cnta.flag_doc_ref = '1' THEN  //CENTRO DE BENEFICIO
		
			/*if not IsNull(ls_tipo_ref) and not IsNull(ls_nro_ref) then
				lstr_param.tipo_docref1	= ls_tipo_ref_det
				lstr_param.nro_docref1	= ls_nro_ref_det
			else*/
			lstr_param.tipo_docref1	= adw_master.object.tipo_doc 	  		[1]
			lstr_param.nro_docref1	= adw_master.object.nro_doc  	  		[1]
			//end if
			
			
			IF Isnull(lstr_param.tipo_docref1) THEN lstr_param.tipo_docref1 = ''	
			IF Isnull(lstr_param.nro_docref1) THEN lstr_param.nro_docref1 = ''	
			
		else
			lstr_param.tipo_docref1 = ''
			lstr_param.nro_docref1 = ''
		END IF
	
	
		/****************************************************/
		/*Expresión para busqueda en el detalle del asiento */
		/****************************************************/
		ls_expresion 	 = this.of_generar_expresion(lstr_cnta, lstr_param)
		ll_found        = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
	
		IF ll_found = 0 THEN
					
			ll_row_ins    = adw_asiento_det.event ue_insert()
			if ll_row_ins > 0 then
				adw_asiento_det.Object.item	  		[ll_row_ins] = ll_row_ins
				adw_asiento_det.Object.cnta_ctbl   	[ll_row_ins] = ls_cnta_ctbl
				adw_asiento_det.Object.flag_debhab 	[ll_row_ins] = lstr_param.flag_debhab
				adw_asiento_det.Object.det_glosa    [ll_row_ins] = lstr_cnta.desc_cnta
				
				/*Asignacion de Valores de Acuerdo a Flag de Cuentas*/
				IF lstr_cnta.flag_doc_ref = '1' THEN
					adw_asiento_det.Object.tipo_docref1[ll_row_ins] = lstr_param.tipo_docref1
					adw_asiento_det.Object.nro_docref1 [ll_row_ins] = lstr_param.nro_docref1
				END IF
				
				IF lstr_cnta.flag_codrel = '1' THEN
					adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_relacion
				END IF
				
				IF lstr_cnta.flag_cencos = '1' THEN
					adw_asiento_det.Object.cencos [ll_row_ins] = lstr_param.cencos
				END IF
				
				IF lstr_cnta.flag_centro_benef = '1' THEN
					adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.centro_benef
				END IF
				
				IF lstr_cnta.flag_ctabco = '1' THEN
					adw_asiento_det.Object.cod_relacion [ll_row_ins] = lstr_param.cod_ctabco
				END IF
	
	
				IF ls_moneda = is_soles THEN
					adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_importe_imp
					adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_importe_imp / ldc_tasa_cambio,2)
				ELSEIF ls_moneda = is_dolares THEN
					adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_importe_imp
					adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_importe_imp * ldc_tasa_cambio,2)					
				END IF
			end if
				
		ELSE
			IF ls_moneda = is_soles THEN
				adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_importe_imp
				adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_importe_imp / ldc_tasa_cambio,2)
				
			ELSEIF ls_moneda = is_dolares THEN
				
				adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_importe_imp
				adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_importe_imp * ldc_tasa_cambio,2)					
			END IF
		END IF
	NEXT
	
	//Hago el asiento de ajuste
	this.of_generar_ajuste(adw_asiento_cab, adw_asiento_det)

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Ha ocurrido una excepcion')
finally
	/*statementBlock*/
end try



Return true

end function

public function boolean of_glosa_cxc_nv (u_dw_abc adw_master, u_dw_abc adw_detail, long al_row, str_cnta_cntbl astr_cnta, string as_flag_cxc_cxp);/****************************************************/
/*LLenado de Datastore en Caso de Liquidación       */
/* adw_master = Cabecera de Cntas_Cobrar					    */
/* adw_detail = Detalle  de Cntas_Cobrar                 */
/* ids_glosa = Datastore de Datos Para Glosa				 */
/* al_row = Linea de Detalle de cntas_cobrar	 */
/****************************************************/
Long   ll_ins_ds

ids_glosa.Reset()

ll_ins_ds = ids_glosa.InsertRow(0)
/*Cabecera de Nota de ventas*/
ids_glosa.Object.origen			    [ll_ins_ds] = adw_master.Object.origen 				 [1]
ids_glosa.Object.tipo_doc		    [ll_ins_ds] =	adw_master.Object.tipo_doc 			 [1]
ids_glosa.Object.nro_doc			    [ll_ins_ds] =	adw_master.Object.nro_doc  			 [1]
ids_glosa.Object.cod_relacion	    [ll_ins_ds] =	adw_master.Object.cod_relacion 		 [1]
ids_glosa.Object.nom_proveedor	    [ll_ins_ds] =	adw_master.Object.nom_proveedor 	 [1]
ids_glosa.Object.cod_moneda			 [ll_ins_ds] = adw_master.Object.cod_moneda 		 [1]
ids_glosa.Object.tasa_cambio       [ll_ins_ds] = adw_master.Object.tasa_cambio 		 [1] 
ids_glosa.Object.observacion		 [ll_ins_ds] =	adw_master.Object.observacion 		 [1] 
ids_glosa.Object.fecha_documento   [ll_ins_ds] = adw_master.Object.fecha_documento 	 [1]
ids_glosa.Object.fecha_vencimiento [ll_ins_ds] = adw_master.Object.fecha_vencimiento [1]
ids_glosa.Object.fecha_registro	 [ll_ins_ds] = adw_master.Object.fecha_registro	 [1]
ids_glosa.Object.item_direccion    [ll_ins_ds] = adw_master.Object.item_direccion	 [1]
ids_glosa.Object.flag_estado       [ll_ins_ds] = adw_master.Object.flag_estado	 	 [1]
ids_glosa.Object.motivo            [ll_ins_ds] = adw_master.Object.motivo	 			 [1]
ids_glosa.Object.ano               [ll_ins_ds] = adw_master.Object.ano	 				 [1]
ids_glosa.Object.mes               [ll_ins_ds] = adw_master.Object.mes	 				 [1]
ids_glosa.Object.nro_libro         [ll_ins_ds] = adw_master.Object.nro_libro	 		 [1]
ids_glosa.Object.nro_asiento       [ll_ins_ds] = adw_master.Object.nro_asiento 	 	 [1]
ids_glosa.Object.importe_a_cobrar  [ll_ins_ds] = adw_master.Object.importe_doc		 [1]
ids_glosa.Object.cod_usr           [ll_ins_ds] = adw_master.Object.cod_usr 	 		 [1]

/*Detalle de Nota de venta*/
ids_glosa.Object.cnta_ctbl			 [ll_ins_ds] = astr_cnta.cnta_cntbl
ids_glosa.Object.desc_cnta			 [ll_ins_ds] = Mid(astr_cnta.desc_cnta,1,60)
ids_glosa.Object.item					 [ll_ins_ds] = adw_detail.Object.item					 [al_row]
ids_glosa.Object.cod_art				 [ll_ins_ds] = adw_detail.Object.cod_art				 [al_row]
ids_glosa.Object.descripcion		 [ll_ins_ds] = Mid(adw_detail.Object.descripcion	[al_row],1,60)
ids_glosa.Object.cantidad		    [ll_ins_ds] = adw_detail.Object.cantidad          [al_row]
ids_glosa.Object.precio_unitario   [ll_ins_ds] = adw_detail.Object.precio_unitario	 [al_row] 	
ids_glosa.Object.total             [ll_ins_ds] = adw_detail.Object.total             [al_row]
ids_glosa.Object.tipo_ref          [ll_ins_ds] = adw_detail.Object.tipo_ref          [al_row] 
ids_glosa.Object.nro_ref           [ll_ins_ds] = adw_detail.Object.nro_ref           [al_row] 
ids_glosa.Object.item_ref          [ll_ins_ds] = adw_detail.Object.item_ref          [al_row]

return true


end function

public function boolean of_generar_asiento_cxc_nv (u_dw_abc adw_master, u_dw_abc adw_detail, u_dw_abc adw_impuestos, u_dw_abc adw_asiento_cab, u_dw_abc adw_asiento_det, tab at_tab1, string as_flag_cxc_cxp);Long 		   ll_inicio,ll_imatriz,ll_row_ins,ll_found,ll_found_imp,ll_inicio_for
String      ls_c_fin,ls_matriz,ls_formula,ls_cnta_ctbl,&
				ls_flag_debhab,ls_expresion,ls_expresion_form,ls_campo,ls_signo,&
				ls_desc_cnta,ls_glosa_texto,ls_glosa_campo,ls_desc_glosa,ls_tipo_doc,&
				ls_nro_doc,ls_cod_relacion, ls_motivo,ls_cencos, ls_campo_formula, &
				ls_moneda, ls_centro_benef
				
Boolean     lb_retorno = TRUE
Integer 	   li_pos = 1, li_pos_ini , li_pos_fin , li_cont ,li_item
String      ls_armado[],ls_inicio[]
Decimal 		ldc_importe_imp,ldc_monto,ldc_monto_imp, ldc_tasa_cambio

str_cnta_cntbl	lstr_cnta

try 
	
	
	ls_campo_formula = 'tipo_impuesto'
	
	adw_detail.Accepttext()
	adw_asiento_det.Accepttext()
	
	
	DO WHILE adw_asiento_det.Rowcount() > 0
		adw_asiento_det.deleterow(0)
	LOOP
	
	/*Datos de Cabecera*/
	ls_tipo_doc		 = adw_master.object.tipo_doc 	  		[1]
	ls_nro_doc		 = adw_master.object.nro_doc  	  		[1]
	ls_cod_relacion = adw_master.object.cod_relacion 		[1]
	ls_motivo		 = adw_master.object.motivo		  		[1]
	ls_moneda		 = adw_master.object.cod_moneda		 	[1]
	ldc_tasa_cambio = Dec(adw_master.object.tasa_Cambio	[1])
	/**/
	
	//Valido la informacion
	ls_moneda 		 = adw_master.object.cod_moneda  [1]
	ldc_tasa_cambio = adw_master.object.tasa_cambio [1]
	
	IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
		Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
		adw_master.SetFocus()
		adw_master.Setcolumn('cod_moneda')
		Return FALSE
	END IF
	
	IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
		Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
		adw_master.SetFocus()
		adw_master.Setcolumn('tasa_cambio')
		Return FALSE
	END IF
	
	
	//ls_cencos = ''
	
	FOR ll_inicio = 1 TO adw_detail.Rowcount()  //Recorro dw Origen de los items A generar Cuenta Contable
		/*Inicialización de Variables*/
		 
		ls_c_fin = adw_detail.object.confin [ll_inicio]	
		li_item	 = adw_detail.object.item   [ll_inicio]	
		
		//**//
		IF Isnull(ls_c_fin) OR Trim(ls_c_fin) = '' THEN
			Messagebox('Error','Item ' + string(li_item) + ' No se Ha ingresado Concepto Financiero', StopSign!)
			adw_asiento_det.Reset()
			adw_detail.setFocus()
			adw_detail.setColumn('confin')
			at_tab1.SelectedTab = 2
			 
			return false
		end if
		
		//Insercion de Cuentas dependiendo de la Matriz Contable
		ls_matriz = adw_detail.object.matriz_cntbl[ll_inicio]
		IF Isnull(ls_matriz) OR Trim(ls_matriz) = ''  THEN
			Messagebox('Aviso','Concepto Financiero Nº '+ls_c_fin+' No se ha Vinculado Matriz')
			adw_asiento_det.Reset()
			adw_detail.SetFocus()
			adw_detail.setColumn('confin')
			at_tab1.SelectedTab = 2
			return false
		END IF
	
		ids_matriz_cntbl.Retrieve(ls_matriz)					// Recuperación de Información de Matriz Detalle
			  
		FOR ll_imatriz = 1 TO ids_matriz_cntbl.Rowcount()
			
			/**Inicializacion de Variables**/
		
			ls_armado = ls_inicio
		
			ldc_monto   	= 0.00
			ldc_monto_imp  = 0.00
			li_pos 	   	= 1
			li_pos_ini  	= 0
			li_pos_fin  	= 0
			li_cont   		= 0
			
			ls_cnta_ctbl 	= ids_matriz_cntbl.Object.cnta_ctbl   		[ll_imatriz]
			ls_desc_cnta	= MID(ids_matriz_cntbl.Object.desc_cnta  	[ll_imatriz],1,60)
			ls_flag_debhab = ids_matriz_cntbl.Object.flag_debhab 		[ll_imatriz]
			ls_formula     = ids_matriz_cntbl.Object.formula 		[ll_imatriz]
			ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo 	[ll_imatriz]
			ls_glosa_texto	= ids_matriz_cntbl.Object.glosa_texto 	[ll_imatriz]
			
			CHOOSE CASE left(ls_motivo,3)
				CASE 'NCC'
				
					IF ls_flag_debhab = 'H' THEN //Invertir Codigo
						ls_flag_debhab = 'D'
					ELSE
						ls_flag_debhab = 'H'
					END IF
			END CHOOSE
		
		
			/***************************************************/
			/*Asignación de Información requerida x Cta Cntbl */
			/***************************************************/
			if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then
				gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + ls_cnta_ctbl)
				return false
			end if
			
			IF lstr_cnta.flag_cencos = '1' THEN
				//*Verifico si columna existe en el detalle*//
				IF adw_detail.of_ExisteCampo('cencos') THEN  //Cuentas x Pagar	
					ls_cencos = adw_detail.object.cencos [ll_inicio] 		 
					
				ELSE															  //Cuentas x Cobrar
					ls_cencos = ''
				END IF
				
				IF Isnull(ls_cencos) or trim(ls_cencos) = '' THEN 
					MessageBox('Error', 'La cuenta contable ' + ls_cnta_ctbl + ', pide centro de ' &
											+ 'costos, y no se ha asignado ninguno en la linea ' &
											+ string(ll_inicio), StopSign!)
					return false
				end if
					
			ELSE
				ls_cencos = ''
			END IF
			
			//Verifico si pide centro de beneficio
			IF lstr_cnta.flag_centro_benef = '1' THEN
				//*Verifico si columna existe en el detalle*//
				IF adw_detail.of_ExisteCampo('centro_benef') THEN  //Cuentas x Pagar	
					ls_centro_benef = adw_detail.object.centro_benef [ll_inicio] 		 
					
				ELSE															  //Cuentas x Cobrar
					ls_centro_benef = ''
				END IF
				
				IF Isnull(ls_centro_benef) or trim(ls_centro_benef) = '' THEN 
					MessageBox('Error', 'La cuenta contable ' + ls_cnta_ctbl + ', pide centro de ' &
											+ 'BENEFICIO, y no se ha asignado ninguno en la linea ' &
											+ string(ll_inicio), StopSign!)
					return false
				end if
					
			ELSE
				ls_centro_benef = ''
			END IF
			
			
			/*Función de llenado de datastore*/
			//f_generacion_glosa_cxc_nv(adw_master, adw_detail, ids_glosa, ll_inicio, ls_cnta_ctbl, ls_desc_cnta, as_flag_cxc_cxp)
			this.of_glosa_cxc_cxp(	adw_master, &
											adw_detail, &
											ll_inicio, &
											lstr_cnta, &
											as_flag_cxc_cxp)

			/**/
			
			// Obtener de la formula los impuestos adicionales
			/***********************/
			li_pos_ini     = Pos(ls_formula,'[',li_pos) 
			
			IF li_pos_ini = 1 THEN       /*Formula Pura */
				ldc_monto  = 0.00
			ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
				ls_campo = Mid(ls_formula,1,li_pos_ini - 2)
				ldc_monto  = adw_detail.Getitemnumber(ll_inicio,ls_campo)
			ELSEIF li_pos_ini = 0 THEN	  /*Campo*/
				ldc_monto  = adw_detail.Getitemnumber(ll_inicio,ls_formula)
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
					 ls_expresion_form	= 'item = '+Trim(String(li_item))+' AND '+ ls_campo_formula + " = '"+ls_armado[ll_inicio_for]+"'"
		
					 ll_found_imp = adw_impuestos.find(ls_expresion_form,1,adw_impuestos.Rowcount())
					 
					 IF ll_found_imp > 0 THEN
						 ls_signo  			 = adw_impuestos.object.signo 	[ll_found_imp] 	
						 ldc_importe_imp   = adw_impuestos.object.importe	[ll_found_imp] 	
						 
						 IF ls_signo   = '+' THEN
							 ldc_monto_imp = ldc_monto_imp + ldc_importe_imp
						 ELSEIF ls_signo = '-'	THEN
							 ldc_monto_imp = ldc_monto_imp - ldc_importe_imp
						 END IF
						 
					 END IF
				 NEXT
				 
				 ldc_monto = (ldc_monto + ldc_monto_imp)
			END IF
			
		
			ls_expresion 	= "cnta_ctbl =	'" + ls_cnta_ctbl + "' AND flag_debhab	= '" + ls_flag_debhab + "'"
								
			ll_found       = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
			//Si no existe un registro que coincida en el detalle del asiento entonces lo debo insertar
			/****/				
			IF ll_found = 0 THEN
				/*Extraer Glosa*/
				ls_desc_glosa = invo_asiento_glosa.of_set_glosa(ids_glosa,1,ls_glosa_texto,ls_glosa_campo)
				
				ll_row_ins    = adw_asiento_det.InsertRow(0)
				
				if ll_row_ins > 0 then
					adw_asiento_det.Object.item		  	[ll_row_ins] = ll_row_ins
					adw_asiento_det.Object.cnta_ctbl   	[ll_row_ins] = ids_matriz_cntbl.Object.cnta_ctbl  [ll_imatriz]
					adw_asiento_det.Object.flag_debhab 	[ll_row_ins] = ls_flag_debhab
					adw_asiento_det.Object.det_glosa   	[ll_row_ins] = Mid(ls_desc_glosa,1,60)
				
					/*Asignacion de Valores de Acuerdo a Flag de Cuentas*/
					IF lstr_cnta.flag_doc_ref = '1' THEN
						adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = ls_tipo_doc
						adw_asiento_det.Object.nro_docref1 	[ll_row_ins] = ls_nro_doc
					END IF
						
					IF lstr_cnta.flag_codrel = '1' THEN
						adw_asiento_det.Object.cod_relacion [ll_row_ins] = ls_cod_relacion	
					END IF
						
					IF lstr_cnta.flag_cencos = '1' THEN
						adw_asiento_det.Object.cencos 		[ll_row_ins] = ls_cencos
					END IF
					
					IF lstr_cnta.flag_centro_benef = '1' THEN
						adw_asiento_det.Object.centro_benef [ll_row_ins] = ls_centro_benef
					END IF

					/*Montos de Pre Asientos*/
					IF ls_moneda = gnvo_app.is_soles THEN
						adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
						adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_tasa_cambio,2)
					ELSEIF ls_moneda = gnvo_app.is_dolares THEN
						adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
						adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_tasa_cambio,2)					
					END IF
	
				end if
				
			ELSE
		
				IF ls_moneda = gnvo_app.is_soles THEN
					adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
					adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_tasa_cambio,2)
				ELSEIF ls_moneda = gnvo_app.is_dolares THEN
					adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
					adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_tasa_cambio,2)					
				END IF
			END IF
			
			
		NEXT
	NEXT
	
	//Ahora proceso el detalle de los impuestos
	FOR ll_inicio = 1 TO adw_impuestos.Rowcount()
	
		ls_cnta_ctbl    =	adw_impuestos.Object.cnta_ctbl   [ll_inicio]
		li_item			 = adw_impuestos.Object.item  	    [ll_inicio]
		ls_flag_debhab  =	adw_impuestos.object.flag_dh_cxp [ll_inicio]				
		
		CHOOSE CASE trim(ls_tipo_doc)
			CASE 'NCC'
				IF ls_flag_debhab = 'H' THEN //Invertir Codigo
					ls_flag_debhab = 'D'
				ELSE
					ls_flag_debhab = 'H'
				END IF
		END CHOOSE
		
		IF Isnull(ls_cnta_ctbl) OR Trim(ls_cnta_ctbl) = '' THEN
			Messagebox('Error', 'Fila de Impuestos Nº '+String(ll_inicio) +', no se Ha ingresado Cuenta Contable de Impuesto', StopSign!)
			adw_asiento_det.Reset()
			
			adw_impuestos.SetFocus()
			adw_impuestos.SetColumn('tipo_impuesto')
			adw_impuestos.SetRow(ll_inicio)
			adw_impuestos.SelectRow(0,false)
			adw_impuestos.SelectRow(ll_inicio, true)
			
			at_tab1.SelectedTab = 2
			
			return false
		END IF
	
	
		IF Isnull(ls_flag_debhab) OR Trim(ls_flag_debhab) = '' THEN
			Messagebox('Error', 'Fila de Impuestos Nº '+String(ll_inicio) +', no se Ha ingresado Flag de Debe ó Haber de Impuesto', StopSign!)
			adw_asiento_det.Reset()
			
			adw_impuestos.SetRow(ll_inicio)
			adw_impuestos.SetColumn('tipo_impuesto')
			adw_impuestos.SelectRow(0,false)
			adw_impuestos.SelectRow(ll_inicio, true)
			
			at_tab1.SelectedTab = 2
			return false
		END IF
		
		/***************************************************/
		/*Asignación de Información requerida x Cta Cntbl */
		/***************************************************/
		if not invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl, lstr_cnta) then
			gnvo_app.of_message_error("Ha ocurrido un error al tratar de obtener los flags de la cuenta contable " + ls_cnta_ctbl)
			return false
		end if
		
		IF lstr_cnta.flag_cencos = '1' THEN
			//*Verifico si columna existe en el detalle*//
			IF adw_detail.of_ExisteCampo('cencos') THEN  //Cuentas x Pagar	
				ls_cencos = adw_detail.object.cencos [ll_inicio] 		 
				
			ELSE															  //Cuentas x Cobrar
				ls_cencos = ''
			END IF
			
			IF Isnull(ls_cencos) or trim(ls_cencos) = '' THEN 
				MessageBox('Error', 'La cuenta contable ' + ls_cnta_ctbl + ', pide centro de ' &
										+ 'costos, y no se ha asignado en la Linea de Impuestos ' &
										+ string(ll_inicio), StopSign!)
				return false
			end if
				
		ELSE
			ls_cencos = ''
		END IF
		
		//Verifico si pide centro de beneficio
		IF lstr_cnta.flag_centro_benef = '1' THEN
			//*Verifico si columna existe en el detalle*//
			IF adw_detail.of_ExisteCampo('centro_benef') THEN  //Cuentas x Pagar	
				ls_centro_benef = adw_detail.object.centro_benef [ll_inicio] 		 
				
			ELSE															  //Cuentas x Cobrar
				ls_centro_benef = ''
			END IF
			
			IF Isnull(ls_centro_benef) or trim(ls_centro_benef) = '' THEN 
				MessageBox('Error', 'La cuenta contable ' + ls_cnta_ctbl + ', pide centro de ' &
										+ 'BENEFICIOS, y no se ha asignado en la Linea de Impuestos ' &
										+ string(ll_inicio), StopSign!)
				return false
			end if
				
		ELSE
			ls_centro_benef = ''
		END IF
		
		ls_desc_cnta	 = MID(adw_impuestos.object.desc_cnta	 [ll_inicio],1,60)
		ls_expresion 	 = "cnta_ctbl = '"+ls_cnta_ctbl+"' AND flag_debhab	= '"+ls_flag_debhab+"'"
		ll_found        = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
		ldc_importe_imp = adw_impuestos.Object.importe 	[ll_inicio]
		
		IF ll_found = 0 THEN
					
			ll_row_ins    = adw_asiento_det.InsertRow(0)
			
			if ll_row_ins > 0 then
				adw_asiento_det.Object.item		  [ll_row_ins] = ll_row_ins
				adw_asiento_det.Object.cnta_ctbl   [ll_row_ins] = ls_cnta_ctbl
				adw_asiento_det.Object.flag_debhab [ll_row_ins] = ls_flag_debhab
				adw_asiento_det.Object.det_glosa   [ll_row_ins] = ls_desc_cnta
				
				/*Asignacion de Valores de Acuerdo a Flag de Cuentas*/
				IF lstr_cnta.flag_doc_ref = '1' THEN
					adw_asiento_det.Object.tipo_docref1 [ll_row_ins] = ls_tipo_doc
					adw_asiento_det.Object.nro_docref1 	[ll_row_ins] = ls_nro_doc
				END IF
					
				IF lstr_cnta.flag_codrel = '1' THEN
					adw_asiento_det.Object.cod_relacion [ll_row_ins] = ls_cod_relacion	
				END IF
					
				IF lstr_cnta.flag_cencos = '1' THEN
					adw_asiento_det.Object.cencos [ll_row_ins] = ls_cencos
				END IF
				
				IF lstr_cnta.flag_centro_benef = '1' THEN
					adw_asiento_det.Object.cencos [ll_row_ins] = ls_centro_benef
				END IF
				
				IF ls_moneda = gnvo_app.is_soles THEN
					adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_importe_imp					
					adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_importe_imp / ldc_tasa_cambio,2)
				ELSEIF ls_moneda = gnvo_app.is_dolares THEN
					adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_importe_imp
					adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_importe_imp * ldc_tasa_cambio,2)					
				END IF
	
			end if
				
		ELSE
			IF ls_moneda = gnvo_app.is_soles THEN
				adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_importe_imp
				adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_importe_imp / ldc_tasa_cambio,2)
			ELSEIF ls_moneda = gnvo_app.is_dolares THEN
				adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_importe_imp
				adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_importe_imp * ldc_tasa_cambio,2)					
			END IF
		END IF
	NEXT
	
	//Hago el asiento de ajuste
	this.of_generar_ajuste(adw_asiento_cab, adw_asiento_det)
	
	Return true
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
	return false
finally
	/*statementBlock*/
end try


end function

public function boolean of_generar_ajuste (ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det) throws exception;Long		ll_inicio, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento, ll_found, ll_row_ins
String	ls_flag_debhab, ls_cnta_cntbl, ls_origen, ls_expresion
Decimal	ldc_total_sol_deb, ldc_total_sol_hab, ldc_total_dol_deb, ldc_total_dol_hab, &
			ldc_imp_movsol, ldc_imp_movdol
Date		ld_fecha_cntbl

str_cnta_cntbl	lstr_cnta
str_parametros	lstr_param
				
try 
	
	//Obtengo los datos de la cabecera del asiento
	ls_origen 		= adw_asiento_cab.object.origen 				[1]
	ll_year	 		= Long(adw_asiento_cab.object.ano 			[1])
	ll_mes	 		= Long(adw_asiento_cab.object.mes 			[1])
	ll_nro_libro 	= Long(adw_asiento_cab.object.nro_libro	[1])
	ll_nro_asiento	= Long(adw_asiento_cab.object.nro_Asiento	[1])
	ld_fecha_cntbl	= Date(adw_asiento_cab.object.fecha_cntbl	[1])
	
	//Obtengo los totales en dolares y soles
	ldc_total_sol_deb = 0
	ldc_total_sol_hab = 0
	ldc_total_dol_deb = 0
	ldc_total_dol_hab = 0
	
	for ll_inicio = 1 to adw_asiento_det.RowCount()
		ls_flag_debhab = adw_asiento_det.object.flag_debhab [ll_inicio]
		
		if ls_flag_debhab = 'D' then
			ldc_total_sol_deb += Dec(adw_asiento_det.object.imp_movsol [ll_inicio])
			ldc_total_dol_deb += Dec(adw_asiento_det.object.imp_movdol [ll_inicio])
		else
			ldc_total_sol_hab += Dec(adw_asiento_det.object.imp_movsol [ll_inicio])
			ldc_total_dol_hab += Dec(adw_asiento_det.object.imp_movdol [ll_inicio])
		end if
	next
	
	//Primero ajusto los soles
	if ldc_total_sol_deb <> ldc_total_sol_hab and abs(ldc_total_sol_deb - ldc_total_sol_hab) <= idc_max_dif_ajuste then
		if ldc_total_sol_deb > ldc_total_sol_hab then
			ls_flag_debhab = 'H'
			ls_cnta_Cntbl 	= is_cnta_ajuste_hab
			ldc_imp_movsol = abs(ldc_total_sol_deb - ldc_total_sol_hab)
			ldc_imp_movdol = 0
		else
			ls_flag_debhab = 'D'
			ls_cnta_Cntbl 	= is_cnta_ajuste_deb
			ldc_imp_movsol = abs(ldc_total_sol_hab - ldc_total_sol_deb)
			ldc_imp_movdol = 0
		end if
		
		ls_expresion = "cnta_ctbl = '" + ls_cnta_Cntbl + "' " &
						 + "and flag_debhab = '" + ls_flag_debhab + "' " &
						 + "and cencos = '" + is_cencos_aj + "'" &
						 + "and centro_benef = '" + is_centro_benef_aj + "'"
						 
		ll_found     = adw_asiento_Det.Find(ls_expresion,1,adw_asiento_Det.Rowcount())
	
		IF ll_found =  0 THEN
			//Inserto un nuevo registro
			ll_row_ins    = adw_asiento_det.event ue_insert()
			
			if ll_row_ins > 0 then
				adw_asiento_det.Object.item		   	[ll_row_ins] = ll_row_ins
				adw_asiento_det.Object.cnta_ctbl    	[ll_row_ins] = ls_cnta_cntbl
				adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = ls_flag_debhab
				adw_asiento_det.Object.det_glosa    	[ll_row_ins] = 'AJUSTE POR REDONDEO SOLES'
				adw_asiento_det.Object.fec_cntbl			[ll_row_ins] = ld_fecha_cntbl
				adw_asiento_det.Object.origen	      	[ll_row_ins] = ls_origen
				adw_asiento_det.Object.ano		      	[ll_row_ins] = ll_year
				adw_asiento_det.Object.mes		      	[ll_row_ins] = ll_mes
				adw_asiento_det.Object.nro_libro    	[ll_row_ins] = ll_nro_libro
				adw_asiento_det.Object.nro_Asiento    	[ll_row_ins] = ll_nro_asiento
				
				lstr_cnta = invo_cntbl.of_cnta_cntbl(ls_cnta_cntbl)
				
				if not lstr_cnta.b_return then return false
				
				if lstr_cnta.flag_cencos = '1' then
					adw_asiento_det.Object.cencos			[ll_row_ins] = is_cencos_aj
				else
					adw_asiento_det.Object.cencos			[ll_row_ins] = gnvo_app.is_null
				end if
				
				if lstr_cnta.flag_centro_benef = '1' then
					adw_asiento_det.Object.centro_benef	[ll_row_ins] = is_centro_benef_aj
				else
					adw_asiento_det.Object.centro_benef	[ll_row_ins] = gnvo_app.is_null
				end if
				
				if adw_asiento_det.of_existeCampo("flag") then
					adw_asiento_det.Object.flag		  		[ll_row_ins] = 'N'	
				end if
				if adw_asiento_det.of_existeCampo("flag_edit") then
					adw_asiento_det.Object.flag_edit  		[ll_row_ins] = 'E'
				end if
				adw_asiento_det.Object.imp_movsol  		[ll_row_ins] = ldc_imp_movsol
				adw_asiento_det.Object.imp_movdol  		[ll_row_ins] = ldc_imp_movdol
				
			end if
			
		else
			adw_asiento_det.Object.imp_movsol  			[ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_imp_movsol
			adw_asiento_det.Object.imp_movdol  			[ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_imp_movdol
		end if
	end if
	
	//Segundo ajusto los dolares
	if ldc_total_dol_deb <> ldc_total_dol_hab and abs(ldc_total_dol_deb - ldc_total_dol_hab) <= idc_max_dif_ajuste then
		if ldc_total_dol_deb > ldc_total_dol_hab then
			ls_flag_debhab = 'H'
			ls_cnta_Cntbl 	= is_cnta_ajuste_hab
			ldc_imp_movdol = ldc_total_dol_deb - ldc_total_dol_hab
			ldc_imp_movsol	= 0
		else
			ls_flag_debhab = 'D'
			ls_cnta_Cntbl 	= is_cnta_ajuste_deb
			ldc_imp_movdol = ldc_total_dol_hab - ldc_total_dol_deb
			ldc_imp_movsol	= 0
		end if
		
		ls_expresion = "cnta_ctbl = '" + ls_cnta_Cntbl + "' " &
						 + "and flag_debhab = '" + ls_flag_debhab + "' " &
						 + "and cencos = '" + is_cencos_aj + "' " &
						 + "and centro_benef = '" + is_centro_benef_aj + "'"
						 
		ll_found     = adw_asiento_Det.Find(ls_expresion,1,adw_asiento_Det.Rowcount())
	
		IF ll_found =  0 THEN
			//Inserto un nuevo registro
			ll_row_ins    = adw_asiento_det.event ue_insert()
			
			if ll_row_ins > 0 then
				adw_asiento_det.Object.item		   	[ll_row_ins] = ll_row_ins
				adw_asiento_det.Object.cnta_ctbl    	[ll_row_ins] = ls_cnta_cntbl
				adw_asiento_det.Object.flag_debhab  	[ll_row_ins] = ls_flag_debhab
				adw_asiento_det.Object.det_glosa    	[ll_row_ins] = 'AJUSTE POR REDONDEO DOLARES'
				adw_asiento_det.Object.fec_cntbl			[ll_row_ins] = ld_fecha_cntbl
				adw_asiento_det.Object.origen	      	[ll_row_ins] = ls_origen
				adw_asiento_det.Object.ano		      	[ll_row_ins] = ll_year
				adw_asiento_det.Object.mes		      	[ll_row_ins] = ll_mes
				adw_asiento_det.Object.nro_libro    	[ll_row_ins] = ll_nro_libro
				adw_asiento_det.Object.nro_Asiento    	[ll_row_ins] = ll_nro_asiento
				
				lstr_cnta = invo_cntbl.of_cnta_cntbl(ls_cnta_cntbl)
				
				if not lstr_cnta.b_return then return false
				
				if lstr_cnta.flag_cencos = '1' then
					adw_asiento_det.Object.cencos			[ll_row_ins] = is_cencos_aj
				else
					adw_asiento_det.Object.cencos			[ll_row_ins] = gnvo_app.is_null
				end if
				
				if lstr_cnta.flag_centro_benef = '1' then
					adw_asiento_det.Object.centro_benef	[ll_row_ins] = is_centro_benef_aj
				else
					adw_asiento_det.Object.centro_benef	[ll_row_ins] = gnvo_app.is_null
				end if
				
				if adw_asiento_det.of_existeCampo("flag") then
					adw_asiento_det.Object.flag		  		[ll_row_ins] = 'N'	
				end if
				if adw_asiento_det.of_existeCampo("flag_edit") then
					adw_asiento_det.Object.flag_edit  		[ll_row_ins] = 'E'
				end if
				
				adw_asiento_det.Object.imp_movsol  		[ll_row_ins] = ldc_imp_movsol
				adw_asiento_det.Object.imp_movdol  		[ll_row_ins] = ldc_imp_movdol
				
			end if
			
		else
			adw_asiento_det.Object.imp_movsol  			[ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_imp_movsol
			adw_asiento_det.Object.imp_movdol  			[ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_imp_movdol
		end if
	end if

	

	Return true
	
catch ( Exception ex )

	f_mensaje("Ha ocurrido una exception: " + ex.getMessage() + ", por favor verifique", '')
	
	return false
	
finally
	
	

end try



end function

public function boolean of_generar_asiento_cb (ref u_dw_abc adw_master, ref u_dw_abc adw_detail, u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, datastore ads_datos_asiento, ref datastore ads_relacion_ext);/*
	Este procedimiento genera un asiento Contable para movimientos Bancarios
*/
Long    	ll_inicio     ,ll_count 	,ll_inicio_mat ,ll_ins_det   		, &
		  	ll_row_master ,ll_ano	  	,ll_mes		  	,ll_nro_libro 		, &
		  	ll_nro_asiento,ll_found 	,ll_factor 	  	,ll_inicio_cebef	, &
			ll_nro_item
			  
String  	ls_confin		   ,ls_matriz				,ls_cnta_ctbl			,&
			ls_desc_cnta	   ,ls_glosa_texto	   ,ls_flag_edit			,ls_tipo_doc_cab		,&
		  	ls_glosa_campo		,ls_flag_debhab		,ls_tipo_doc	     	,ls_nro_doc		      ,&
		  	ls_cod_relacion 	,ls_campo			   ,ls_moneda_det	     	,ls_desc_glosa	      ,&
		  	ls_origen			,ls_glosa_dp			,ls_cencos_dp	     	,ls_centro_benef_dp	,&
			ls_codctabco_dp   ,ls_nro_docref2  		,ls_cnta_ctbl_dif	   ,ls_flag_debhab_dif 	,&
		  	ls_det_glosa		,ls_expresion			,ls_cta_bco			  	,ls_codctabco			,&
		  	ls_desctabco		,ls_moneda_cab			,ls_flag_debhab_ret 	,ls_flag_retencion	,&
		  	ls_flag_ret_cab 	,ls_cencos				,ls_flag_tip_tran		,&
			ls_obs				,ls_flab_tabor			,ls_centro_benef		,ls_msj_err			  	,&
			ls_cnta_cntbl_ref	,ls_nro_cri				,ls_nro_doc_cab		,ls_flag_debhab_dif_x_doc
			  
			  
Decimal 	ldc_monto_total ,ldc_saldo_sol  ,ldc_saldo_dol ,ldc_imp_sol ,ldc_imp_dol ,&
			ldc_monto_soles ,ldc_monto_final,ldc_imp_retencion, ldc_tasa_cambio, &
			ldc_tasa_cambio_doc, ldc_importe

//CEntro de costos y Centro de beneficio para diferencia de cambio
String	ls_cencos_df, ls_centro_benef_df

//Cuenta Contable
str_Cnta_cntbl	lstr_cnta, lstr_cnta_ret, lstr_cnta_dif
			
dwItemStatus ldis_status

try 
	
	ls_cencos_df 			= gnvo_app.of_get_parametro('CENCOS_AJUSTE_DIF_CAMBIO', '60100301')
	ls_centro_benef_df 	= gnvo_app.of_get_parametro('CENTRO_BENEF_AJUSTE_DIF_CAMBIO', '4010')
	

	//*Datos de cuenta contable de retencion *//
	if gnvo_app.is_agente_ret = '1' then
		
		if IsNull(gnvo_app.is_cnta_ctbl_ret_igv) or gnvo_app.is_cnta_ctbl_ret_igv = ''  then
			ROLLBACK;
			gnvo_app.of_message_error("No se ha especificado la cuenta contable para la retención en parametros de Finanzas, por favor verifique")
			return false
		end if
		
		lstr_cnta_ret = invo_cntbl.of_cnta_cntbl(gnvo_app.is_cnta_ctbl_ret_igv)
		
		if not lstr_cnta_ret.b_Return then
			ROLLBACK;
			gnvo_app.of_message_error("No existe la cuenta Contable para Retención: " + gnvo_app.is_cnta_ctbl_ret_igv &
								  + " en el plan de cuentas, por favor coordine con contabilidad para verificarlo")
			return false
		end if
	end if
	
	//Acepto los cambios realizados 
	adw_master.Accepttext()
	adw_detail.Accepttext()
	adw_asiento_det.Accepttext()
	
	
	//elimina asientos generados
	DO WHILE adw_asiento_det.Rowcount() > 0
		adw_asiento_det.deleterow(0)
	LOOP
	
	//cabecera
	ll_row_master = adw_master.getrow()
	
	//tasa de cambio de cabecera 
	ldc_tasa_cambio  = Dec(adw_master.object.tasa_cambio  [ll_row_master])
	ls_origen		  = adw_master.object.origen		     	[ll_row_master]
	ll_ano			  = adw_master.object.ano			     	[ll_row_master]
	ll_mes			  = adw_master.object.mes			     	[ll_row_master]
	ll_nro_libro	  = adw_master.object.nro_libro	     	[ll_row_master]
	ll_nro_asiento	  = adw_master.object.nro_asiento    	[ll_row_master] 
	ls_moneda_cab	  = adw_master.object.cod_moneda	  		[ll_row_master]
	ls_flag_ret_cab  = adw_master.object.flag_retencion 	[ll_row_master] 	
	ls_tipo_doc_cab  = adw_master.object.tipo_doc		  	[ll_row_master] 	
	ls_nro_doc_cab	  = adw_master.object.nro_doc		  		[ll_row_master]
	ls_flag_tip_tran = adw_master.object.flag_tiptran   	[ll_row_master]
	ls_obs			  = adw_master.object.obs				  	[ll_row_master]
	
	if ldc_tasa_cambio <= 0 then
		MessageBox('Error', 'No ha espcificado el tipo de cambio en este voucher de tesoreria, verifique!', StopSign!)
		return false
	end if
	
	if adw_master.of_ExisteCampo("nro_certificado") then
		ls_nro_cri		  = adw_master.object.nro_certificado[ll_row_master]
	else
		ls_nro_cri		  = gnvo_app.is_null
	end if
	
	
	
	/*Datos del Banco*/
	ls_cta_bco      = adw_master.object.cnta_ctbl 	    			[ll_row_master]  //cuenta contable de banco
	ls_codctabco    = adw_master.object.cod_ctabco     			[ll_row_master]  //Codigo de Cuenta Bancaria
	ls_desctabco 	 = adw_master.object.desc_banco_cnta 			[ll_row_master]	//Descripción de Cuenta Bancaria
	ldc_monto_final = adw_master.object.imp_total      			[ll_row_master]
	
	
	//Recorro del detalle del documento
	for ll_inicio = 1 to adw_detail.Rowcount()
		ll_nro_item				= Long(adw_detail.object.nro_item 	[ll_inicio])
		ls_confin 		      = adw_detail.object.confin 		  	[ll_inicio]
		ls_matriz 		      = adw_detail.object.matriz_cntbl  	[ll_inicio]
		ls_tipo_doc	      	= adw_detail.object.tipo_doc	     	[ll_inicio]	
		ls_nro_doc		      = adw_detail.object.nro_doc		  	[ll_inicio]	
		ls_cod_relacion     	= adw_detail.object.cod_relacion  	[ll_inicio]
		ls_moneda_det	      = adw_detail.object.cod_moneda	  	[ll_inicio]
		ldc_imp_retencion   	= adw_detail.object.impt_ret_igv  	[ll_inicio]
		ls_flag_retencion   	= adw_detail.object.flag_ret_igv  	[ll_inicio]	
		ls_cencos			   = adw_detail.object.cencos		  		[ll_inicio]	
		ll_factor			   = adw_detail.object.factor		  		[ll_inicio]	
		ls_flab_tabor			= adw_detail.object.flab_tabor    	[ll_inicio]	
		ls_centro_benef		= adw_detail.object.centro_benef  	[ll_inicio]	
		ldc_importe				= Dec(adw_detail.object.importe   	[ll_inicio]	)
		 
		 
		//VERIFICAR ESTADO DE DOCUMENTO
		ldis_status = adw_detail.GetItemStatus(ll_inicio,0,Primary!)
		
		if IsNull(ls_confin) or ls_confin = "" then
			ROLLBACK;
			gnvo_app.of_message_error("No se ha especificado un concepto financiero, por favor verifique")
			adw_detail.SetRow(ll_inicio)
			adw_detail.SelectRow(0, false)
			adw_detail.SelectRow(ll_inicio, true)
			return false
		end if
		
		if IsNull(ls_matriz) or ls_matriz = "" then
			ROLLBACK;
			gnvo_app.of_message_error("Concepto Financiero " + ls_confin + " no tiene asignado matriz alguna, por favor coordinar con Contabilidad")
			adw_detail.SetRow(ll_inicio)
			adw_detail.SelectRow(0, false)
			adw_detail.SelectRow(ll_inicio, true)
			return false
		end if
		
		//verifica si tiene detalle
		ids_matriz_cntbl.Retrieve(ls_matriz)
		
		//Si la matriz contable tiene detalle entonces recorro la matriz sin problemas
		//genera asientos de acuerdo a concepto financiero
		if ids_matriz_cntbl.RowCount() > 0 then 
		 
			
			
			//Se recorre la matriz contable
			for ll_inicio_mat = 1 to ids_matriz_cntbl.Rowcount()
				
				/*Recuperación de Información de Matriz*/	
				ls_cnta_ctbl   = ids_matriz_cntbl.object.cnta_ctbl	  		[ll_inicio_mat]	
				ls_flag_debhab = ids_matriz_cntbl.object.flag_debhab 		[ll_inicio_mat]	
				ls_desc_cnta   = ids_matriz_cntbl.object.desc_cnta			[ll_inicio_mat]
				ls_glosa_texto = ids_matriz_cntbl.object.glosa_texto 		[ll_inicio_mat]	
				ls_glosa_campo = ids_matriz_cntbl.object.glosa_campo 		[ll_inicio_mat]
				ls_campo       = ids_matriz_cntbl.object.formula 	  		[ll_inicio_mat]
				
				//Valido que el campo exista
				if not adw_detail.of_ExisteCampo(ls_campo) then
					rollback;
					gnvo_app.of_message_error("No existe el campo " + ls_campo + ", por favor verifique o corrija la formula en la matriz contable.")
					return false
				end if
				
				//encuentro monto de transacion
				ldc_monto_total = adw_detail.GetItemNumber(ll_inicio, ls_campo)
					 
				//lleno glosa
				this.of_glosa_cb(adw_master, adw_detail, ids_glosa_cb, ll_row_master, ll_inicio, ls_cnta_ctbl, ls_desc_cnta)
				  
				/*Extraer Glosa*/
				ls_desc_glosa = invo_asiento_glosa.of_set_glosa(ids_glosa_cb,1,ls_glosa_texto,ls_glosa_campo)
				  
				if trim(ls_desc_glosa) = "" then
					ls_desc_glosa = mid(ls_desc_cnta,1,100)
				end if
		
				//Obtengo los flags necesarios de la cuenta contable
				lstr_cnta = invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl)
				
				if not lstr_cnta.b_return then return false
					
				//Inserta Registro 
				ll_ins_det = adw_asiento_det.event ue_insert()
				
				if ll_ins_det > 0 then
					adw_asiento_det.object.item		    	[ll_ins_det] = ll_ins_det
					adw_asiento_det.object.cnta_ctbl     	[ll_ins_det] = ls_cnta_ctbl	
					adw_asiento_det.Object.flag_debhab   	[ll_ins_det] = ls_flag_debhab
					adw_asiento_det.Object.det_glosa	   	[ll_ins_det] = Mid(ls_desc_glosa,1,100)
					adw_asiento_det.object.flag_doc_edit	[ll_ins_det] = 'E' 					  
				  
					IF lstr_cnta.flag_ctabco = '1' THEN //CUENTA DE BANCO
						adw_asiento_det.object.cod_ctabco [ll_ins_det] = ls_codctabco
					ELSE
						adw_asiento_det.object.cod_ctabco [ll_ins_det] = gnvo_app.is_null
					END IF
					  
					IF lstr_cnta.flag_doc_ref = '1' THEN //DOCUMENTO DE REFERENCIA
						adw_asiento_det.Object.tipo_docref1  [ll_ins_det] = ls_tipo_doc
						adw_asiento_det.Object.nro_docref1   [ll_ins_det] = ls_nro_doc
					ELSE
						adw_asiento_det.Object.tipo_docref1  [ll_ins_det] = gnvo_app.is_null
						adw_asiento_det.Object.nro_docref1   [ll_ins_det] = gnvo_app.is_null
					END IF

					IF lstr_cnta.flag_codrel = '1' THEN //CODIGO DE RELACION
						adw_asiento_det.Object.cod_relacion [ll_ins_det] = ls_cod_relacion
					ELSE
						adw_asiento_det.Object.cod_relacion [ll_ins_det] = gnvo_app.is_null	
					END IF
					
					//Centro de Beneficio
					IF lstr_cnta.flag_centro_benef = '1' THEN
						if ISNull(ls_centro_benef) or ls_centro_benef = '' then
							MessageBox('Aviso', 'La cuenta contable ' + ls_cnta_ctbl + ' pide CENTRO DE BENEFICIO pero no se ha especificado esa informacion en el Item: ' &
													+ string(ll_nro_item) + ', por favor verifique')
							return false
						end if
						adw_asiento_det.Object.centro_benef [ll_ins_det] = ls_centro_benef
					else
						adw_asiento_det.Object.centro_benef [ll_ins_det] = gnvo_app.is_null
					end if

					IF lstr_cnta.flag_cencos = '1' THEN //CENTRO DE COSTO
						if ISNull(ls_cencos) or ls_cencos = '' then
							MessageBox('Aviso', 'La cuenta contable ' + ls_cnta_ctbl + ' pide CENTRO DE COSTOS pero no se ha especificado esa informacion en el Item: ' &
													+ string(ll_nro_item) + ', por favor verifique')
							return false
						end if
						adw_asiento_det.object.cencos [ll_ins_det] = ls_cencos
					ELSE
						
						adw_asiento_det.object.cencos [ll_ins_det] = gnvo_app.is_null
					END IF
					
					IF ls_moneda_det = is_soles THEN
						adw_asiento_det.object.imp_movsol [ll_ins_det] = abs(ldc_monto_total)
						adw_asiento_det.object.imp_movdol [ll_ins_det] = abs(Round(ldc_monto_total / ldc_tasa_cambio,2))
					ELSE
						adw_asiento_det.object.imp_movdol [ll_ins_det] = abs(ldc_monto_total)
						adw_asiento_det.object.imp_movsol [ll_ins_det] = abs(Round(ldc_monto_total * ldc_tasa_cambio,2))
					END IF
				end if
				
			next //detalle de matriz
			 
		else 
			// no hay detalle en la matriz contable, lo que significa que es un documento tipo cuenta corriente
			// o ya tiene una cuenta contable
			
			//**Se Genera Asientos de Acuerdo A al Mismo Documento **//
			ldc_monto_total = adw_detail.object.importe [ll_inicio]
	
			IF ls_flag_tip_tran = '2' OR ls_flag_tip_tran = '4' THEN //CARTERA DE PAGOS ,APLICACION DE DOCUMENTOS
				IF ll_factor = 1 THEN
					ls_flag_debhab = 'D'
				ELSE
					ls_flag_debhab = 'H'
				END IF
					
			ELSEIF ls_flag_tip_tran = '3' THEN //CARTERA DE COBROS
				IF ll_factor = 1 THEN
					ls_flag_debhab = 'H'
				ELSE
					ls_flag_debhab = 'D'
				END IF
			END IF
			
			//Verifico si el documento es cuenta corriente o no
			ids_doc_pend_cta_cte.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
			IF ids_doc_pend_cta_cte.Rowcount() > 0   THEN
				ls_cnta_ctbl   = ids_doc_pend_cta_cte.object.cnta_ctbl   [1]
				ldc_saldo_sol  = ids_doc_pend_cta_cte.object.sldo_sol	  [1]
				ldc_saldo_dol	= ids_doc_pend_cta_cte.object.saldo_dol   [1]
			ELSE
				/*adelantos o cancelaciones totales*/
				this.of_recall_asiento_doc(ls_origen   ,&
													ll_ano, &
													ll_mes, &
													ll_nro_libro,&
													ll_nro_asiento,&
													ls_cod_relacion,&
													ls_tipo_doc,&
													ls_nro_doc,&
													ls_cnta_ctbl)
			END IF
			
			if IsNull(ls_cnta_ctbl) or trim(ls_cnta_ctbl) = "" then
				rollback;
				Messagebox('Aviso',"Documento Tiene Problemas, no se ha podido encontrar referencia de cuenta contable. " &
										+ "~r~n Por favor verifique el asiento de provisión del documento en caso que sea un documento provisionado " &
										+ "~r~n o en su defecto revise el detalle de la matriz contable " + ls_matriz &
										+ "Linea con problemas: Cod.Relacion: " +ls_cod_relacion &
										+ "~r~nTipo Doc: " + ls_tipo_doc &
										+ "~r~nNroDoc: " + ls_nro_doc)
				adw_detail.SetRow(ll_inicio)
				adw_detail.SelectRow(0, false)
				adw_detail.SelectRow(ll_inicio, true)
				return false
			end if
			 
			//datos adicionales del asiento
			ads_datos_asiento.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
			 
			IF ads_datos_asiento.Rowcount() > 0 THEN
				ls_glosa_dp     		= ads_datos_asiento.object.det_glosa   	[1]
				ls_cencos_dp    		= ads_datos_asiento.object.cencos      	[1]
				ls_centro_benef_dp   = ads_datos_asiento.object.centro_benef   [1]
				ls_codctabco_dp 		= ads_datos_asiento.object.cod_ctabco  	[1]
				ls_nro_docref2  		= ads_datos_asiento.object.nro_docref2 	[1]
			ELSE
				SetNull(ls_glosa_dp)
				SetNull(ls_cencos_dp)
				SetNull(ls_centro_benef_dp)
				SetNull(ls_codctabco_dp)
				SetNull(ls_nro_docref2)
			END IF
		
		
			/*insercion de linea con la cuenta contable a pagar*/
			ll_ins_det = adw_asiento_det.event ue_insert()
			if ll_ins_det > 0 then
				adw_asiento_det.Object.item	       	[ll_ins_det] = ll_ins_det
				adw_asiento_det.Object.cnta_ctbl     	[ll_ins_det] = ls_cnta_ctbl
				adw_asiento_det.Object.det_glosa     	[ll_ins_det] = ls_glosa_dp
				adw_asiento_det.Object.tipo_docref1  	[ll_ins_det] = ls_tipo_doc     
				adw_asiento_det.Object.nro_docref1   	[ll_ins_det] = ls_nro_doc     
				adw_asiento_det.Object.cod_relacion  	[ll_ins_det] = ls_cod_relacion 
				adw_asiento_det.Object.cencos 		 	[ll_ins_det] = ls_cencos_dp		
				adw_asiento_det.Object.centro_benef 	[ll_ins_det] = ls_centro_benef_dp		
				adw_asiento_det.Object.cod_ctabco    	[ll_ins_det] = ls_codctabco_dp
				adw_asiento_det.Object.nro_docref2   	[ll_ins_det] = ls_nro_docref2  
				adw_asiento_det.Object.flag_debhab   	[ll_ins_det] = ls_flag_debhab  
				adw_asiento_det.object.flag_doc_edit 	[ll_ins_det] = 'E' 
				  
				IF ls_moneda_det = is_soles THEN
				 adw_asiento_det.object.imp_movsol [ll_ins_det] = abs(ldc_monto_total)
				 adw_asiento_det.object.imp_movdol [ll_ins_det] = abs(Round(ldc_monto_total / ldc_tasa_cambio,2))
				ELSE
				 adw_asiento_det.object.imp_movsol [ll_ins_det] = abs(Round(ldc_monto_total * ldc_tasa_cambio,2))
				 adw_asiento_det.object.imp_movdol [ll_ins_det] = abs(ldc_monto_total)
				END IF
			end if
		end if

		/************************/
		/*Diferencia en Cambio  */
		/************************/
		
				 
		IF ls_moneda_det = is_dolares THEN /*SE REVISARA DIFERENCIA EN CAMBIO*/
			
			//Obtengo el tipo de cambio original
			select cp.tasa_cambio
			  into :ldc_tasa_cambio_doc
			  from cntas_pagar cp
 			 where cp.cod_relacion 	= :ls_cod_relacion
			   and cp.tipo_doc		= :ls_tipo_doc
				and cp.nro_doc			= :ls_nro_doc;
			
			IF SQLCA.SQLCode = 100 then
				//Si no hay tipo de cambio en Cntas por pagar, entonces debe estar en cuentas por cobrar
				select cc.tasa_cambio
				  into :ldc_tasa_cambio_doc
				  from cntas_cobrar cc
				 where cc.tipo_doc		= :ls_tipo_doc
					and cc.nro_doc			= :ls_nro_doc;
				
				//Si no existe ni en cuentas por pagar o cntas por cobrar entonces coloco 0
				IF SQLCA.SQLCode = 100 then
					ldc_tasa_cambio_doc = 0
				end if
			end if
			
			if IsNull(ldc_tasa_cambio_doc) then ldc_tasa_cambio_doc = 0
			
			if ldc_tasa_cambio_doc > 0 and ldc_tasa_cambio_doc <> ldc_tasa_cambio then
				if ldc_tasa_cambio > ldc_tasa_cambio_doc then
					IF ls_flag_tip_tran = '2' OR ls_flag_tip_tran = '4' THEN //CARTERA DE PAGOS ,APLICACION DE DOCUMENTOS
					 
						if ll_factor = 1 then
							ls_flag_debhab_dif       = 'D'
							ls_flag_debhab_dif_x_doc = 'H'
						else
							ls_flag_debhab_dif       = 'H'
							ls_flag_debhab_dif_x_doc = 'D'
						end if
						
					ELSEIF ls_flag_tip_tran = '3' THEN //CARTERA DE COBROS
				
						if ll_factor = 1 then
							ls_flag_debhab_dif       = 'H'
							ls_flag_debhab_dif_x_doc = 'D'
						else
							ls_flag_debhab_dif       = 'D'
							ls_flag_debhab_dif_x_doc = 'H'
						end if
					END IF	
					
					// Dependiendo si el flag es Debe entonces es perdida, sino es ganancia
					if ls_flag_debhab_dif = 'D' then
						ls_cnta_ctbl_dif         = gnvo_app.is_cta_ctbl_per
					else
						ls_cnta_ctbl_dif  	    = gnvo_app.is_cta_ctbl_gan						
					end if
				 
					ls_det_glosa  = 'Diferencia en Cambio Dolar se Incremento [' + string(ldc_tasa_cambio_doc, '###,##0.0000') + ']'

				else
					IF ls_flag_tip_tran = '2' OR ls_flag_tip_tran = '4' THEN //CARTERA DE PAGOS ,APLICACION DE DOCUMENTOS
					 
						if ll_factor = 1 then
							ls_flag_debhab_dif       = 'H'
							ls_flag_debhab_dif_x_doc = 'D'		
						else
							ls_flag_debhab_dif       = 'D'
							ls_flag_debhab_dif_x_doc = 'H'
						end if
					 
					ELSEIF ls_flag_tip_tran = '3' THEN //CARTERA DE COBROS
					  
						if ll_factor = 1 then
							ls_flag_debhab_dif       = 'D'
							ls_flag_debhab_dif_x_doc = 'H'
						else
							ls_flag_debhab_dif       = 'H'
							ls_flag_debhab_dif_x_doc = 'D'
						end if
					END IF	

				 	// Dependiendo si el flag es Debe entonces es perdida, sino es ganancia
					if ls_flag_debhab_dif = 'D' then
						ls_cnta_ctbl_dif         = gnvo_app.is_cta_ctbl_per
					else
						ls_cnta_ctbl_dif  	    = gnvo_app.is_cta_ctbl_gan						
					end if

					ls_det_glosa  = 'Diferencia en Cambio Dolar Disminuyo [' + string(ldc_tasa_cambio_doc, '###,##0.0000') + ']'
				end if
				
				//Genero el tipo de cambio

				ls_expresion = "cnta_ctbl = '" + ls_cnta_ctbl_dif + "' AND flag_debhab = '" + ls_flag_debhab_dif &
								 + "' AND tipo_docref1 = '" + ls_tipo_doc + "' and nro_docref1 = '" + ls_nro_doc + "'"
				ll_found     = adw_asiento_det.Find(ls_expresion,1,adw_asiento_det.Rowcount())
				
				IF ll_found > 0 THEN
					ldc_monto_soles = adw_asiento_det.object.imp_movsol  [ll_found]
					adw_asiento_det.object.imp_movsol  [ll_found] = abs(ldc_monto_soles) + abs((ldc_tasa_cambio_doc - ldc_tasa_cambio) * ldc_importe)
				ELSE
					/*Asiento de Diferencia en cambio*/
					ll_ins_det = adw_asiento_det.event ue_insert()
					if ll_ins_det > 0 then
						adw_asiento_det.Object.item	       [ll_ins_det] = ll_ins_det
						adw_asiento_det.Object.cnta_ctbl     [ll_ins_det] = ls_cnta_ctbl_dif
						adw_asiento_det.Object.det_glosa     [ll_ins_det] = ls_det_glosa
						adw_asiento_det.Object.flag_debhab   [ll_ins_det] = ls_flag_debhab_dif  
						
						//Datos de la cuenta contable
						lstr_cnta_dif = invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl_dif)
						
						if not lstr_cnta_dif.b_return then return false
						
						if lstr_cnta_dif.flag_codrel = '1' then
							adw_asiento_det.Object.cod_relacion		[ll_ins_det] = ls_cod_relacion		
						else
							adw_asiento_det.Object.cod_relacion  	[ll_ins_det] = gnvo_app.is_null		
						end if
						
						if lstr_cnta_dif.flag_doc_ref = '1' then
							adw_asiento_det.Object.tipo_docref1  	[ll_ins_det] = ls_tipo_doc
							adw_asiento_det.Object.nro_docref1	 	[ll_ins_det] = ls_nro_doc
						else
							adw_asiento_det.Object.tipo_docref1  	[ll_ins_det] = gnvo_app.is_null
							adw_asiento_det.Object.nro_docref1	 	[ll_ins_det] = gnvo_app.is_null
						end if
						
						if lstr_cnta_dif.flag_cencos = '1' then
							adw_asiento_det.Object.cencos 		 	[ll_ins_det] = ls_cencos_df		
						else
							adw_asiento_det.Object.cencos 		 	[ll_ins_det] = gnvo_app.is_null		
						end if
						
						if lstr_cnta_dif.flag_centro_benef = '1' then
							adw_asiento_det.Object.centro_benef  	[ll_ins_det] = ls_centro_benef_df		
						else
							adw_asiento_det.Object.centro_benef  	[ll_ins_det] = gnvo_app.is_null		
						end if

						adw_asiento_det.object.imp_movsol    [ll_ins_det] = abs((ldc_tasa_cambio_doc - ldc_tasa_cambio) * ldc_importe)
						adw_asiento_det.object.imp_movdol    [ll_ins_det] = 0.00
						adw_asiento_det.object.flag_doc_edit [ll_ins_det] = 'E' 
					end if
				END IF /*Busqueda de cuenta generada para acumular*/		
				 
				/*Asiento de doc x diferencia en cambio*/	
				ll_ins_det = adw_asiento_det.event ue_insert()
				if ll_ins_det > 0 then
					adw_asiento_det.Object.item	        	[ll_ins_det] = ll_ins_det
					adw_asiento_det.Object.cnta_ctbl     	[ll_ins_det] = ls_cnta_ctbl
					adw_asiento_det.Object.det_glosa     	[ll_ins_det] = ls_det_glosa
					
					//Datos de la cuenta contable
					lstr_cnta = invo_cntbl.of_cnta_cntbl(ls_cnta_ctbl)
					
					if not lstr_cnta.b_return then return false
					
					if lstr_cnta.flag_codrel = '1' then
						adw_asiento_det.Object.cod_relacion 	[ll_ins_det] = ls_cod_relacion		
					else
						adw_asiento_det.Object.cod_relacion		[ll_ins_det] = gnvo_app.is_null		
					end if
					
					if lstr_cnta.flag_doc_ref = '1' then
						adw_asiento_det.Object.tipo_docref1  	[ll_ins_det] = ls_tipo_doc
						adw_asiento_det.Object.nro_docref1	 	[ll_ins_det] = ls_nro_doc
					else
						adw_asiento_det.Object.tipo_docref1  	[ll_ins_det] = gnvo_app.is_null
						adw_asiento_det.Object.nro_docref1	 	[ll_ins_det] = gnvo_app.is_null
					end if
					
					if lstr_cnta.flag_cencos = '1' then
						adw_asiento_det.Object.cencos 		 	[ll_ins_det] = ls_cencos_df		
					else
						adw_asiento_det.Object.cencos 		 	[ll_ins_det] = gnvo_app.is_null		
					end if
					
					if lstr_cnta.flag_centro_benef = '1' then
						adw_asiento_det.Object.centro_benef  	[ll_ins_det] = ls_centro_benef_df		
					else
						adw_asiento_det.Object.centro_benef  	[ll_ins_det] = gnvo_app.is_null		
					end if
						
					adw_asiento_det.Object.cod_ctabco    	[ll_ins_det] = ls_codctabco_dp
					adw_asiento_det.Object.nro_docref2   	[ll_ins_det] = ls_nro_docref2  
					adw_asiento_det.Object.flag_debhab   	[ll_ins_det] = ls_flag_debhab_dif_x_doc  
					adw_asiento_det.object.imp_movsol    	[ll_ins_det] = abs((ldc_tasa_cambio_doc - ldc_tasa_cambio) * ldc_importe)
					adw_asiento_det.object.imp_movdol    	[ll_ins_det] = 0.00
					adw_asiento_det.object.flag_doc_edit 	[ll_ins_det] = 'E' 
				end if
			end if
			
		END IF /*CIERRA X TIPO DE MONEDA*/
			
		/*asiento de retenciones*/		 
		IF ls_flag_retencion = '1' THEN //CABECERA Y DETALLE
			/*invertir flag debhab de doc*/	
			IF ls_flag_debhab = 'D' THEN
				ls_flag_debhab_ret = 'H'
			ELSE
				ls_flag_debhab_ret = 'D'
			END IF
			 
			ls_expresion = "cnta_ctbl = '"+gnvo_app.is_cnta_ctbl_ret_igv+"' AND flag_debhab = '"+ls_flag_debhab_ret+"' AND cod_relacion = '"+ls_cod_relacion+"'"
			ll_found = adw_asiento_det.find(ls_expresion,1,adw_asiento_det.rowcount())
			
			IF ll_found = 0 THEN
				/*Asiento Retencion*/	
				ll_ins_det = adw_asiento_det.event ue_insert()
				if ll_ins_det > 0 then
					adw_asiento_det.object.item 		   [ll_ins_det] = ll_ins_det
					adw_asiento_det.object.cnta_ctbl		[ll_ins_det] = gnvo_app.is_cnta_ctbl_ret_igv
					adw_asiento_det.object.det_glosa		[ll_ins_det] = lstr_cnta_ret.desc_cnta
					adw_asiento_det.object.flag_debhab 	[ll_ins_det] = ls_flag_debhab_ret
					adw_asiento_det.object.imp_movsol  	[ll_ins_det] = abs(ldc_imp_retencion)
					adw_asiento_det.object.imp_movdol  	[ll_ins_det] = abs(Round(ldc_imp_retencion / ldc_tasa_cambio,2))
					
					IF lstr_cnta_ret.flag_codrel = '1' THEN
						adw_asiento_det.object.cod_relacion [ll_ins_det]	= ls_cod_relacion
					else
						adw_asiento_det.object.cod_relacion [ll_ins_det]	= gnvo_app.is_null
					END IF
					 
					/*Indicadores de Cnta Cntbl*/
					IF lstr_cnta_ret.flag_doc_ref = '1' THEN
						adw_asiento_det.object.tipo_docref1 [ll_ins_det] = gnvo_app.is_doc_ret
						/*ASIGNAR NRO DE COMPROBANTE DE RETENCION*/
						adw_asiento_det.object.nro_docref1  [ll_ins_det] = ls_nro_cri
					else
						adw_asiento_det.object.tipo_docref1 [ll_ins_det] = gnvo_app.is_null
						adw_asiento_det.object.nro_docref1  [ll_ins_det] = gnvo_app.is_null
					END IF
				end if
			ELSE
				adw_asiento_det.object.imp_movsol  [ll_found] = abs(adw_asiento_det.object.imp_movsol  [ll_found] + ldc_imp_retencion)
				adw_asiento_det.object.imp_movdol  [ll_found] = abs(adw_asiento_det.object.imp_movdol  [ll_found] + Round(ldc_imp_retencion / ldc_tasa_cambio,2))
			END IF
		end if /*confin*/
		 
	next //detalle de documentos
	
	//Coloco la cuenta contable de la cabecera del documento, la cual es la cuenta 10 en su mayoría de casos
	IF ls_flag_tip_tran <> '4' THEN
		IF Not (Isnull(ls_cta_bco) OR Trim(ls_cta_bco) = '') THEN  //No existe Cuenta 
			ll_ins_det = adw_asiento_det.InsertRow(0)	//Inserta Registro 	 
		
			IF ls_flag_tip_tran = '2' THEN //CARTERA DE PAGOS
				adw_asiento_det.Object.flag_debhab [ll_ins_det] = 'H'	   
			ELSEIF ls_flag_tip_tran = '3' THEN //CARTERA DE COBROS
				adw_asiento_det.Object.flag_debhab [ll_ins_det] = 'D'		
			END IF
		
			adw_asiento_det.object.item		  [ll_ins_det] = ll_ins_det
			adw_asiento_det.object.cnta_ctbl   [ll_ins_det] = ls_cta_bco
		
		
			adw_asiento_det.Object.det_glosa	  [ll_ins_det] = ls_obs
	
			IF ls_moneda_cab = is_soles THEN
				adw_asiento_det.object.imp_movsol [ll_ins_det] = abs(ldc_monto_final)
				adw_asiento_det.object.imp_movdol [ll_ins_det] = abs(Round(ldc_monto_final / ldc_tasa_cambio,2))
			ELSE
				adw_asiento_det.object.imp_movdol [ll_ins_det] = abs(ldc_monto_final)
				adw_asiento_det.object.imp_movsol [ll_ins_det] = abs(Round(ldc_monto_final * ldc_tasa_cambio,2))
			END IF
			
			lstr_cnta = invo_cntbl.of_cnta_cntbl(ls_cta_bco) 
			
			if not lstr_cnta.b_return then return false
						 
			//verificar
			IF lstr_cnta.flag_doc_ref = '1' THEN				 
				adw_asiento_det.object.flag_doc_edit [ll_ins_det] = gnvo_app.is_null
				adw_asiento_det.object.tipo_docref1  [ll_ins_det] = ls_tipo_doc_cab
				adw_asiento_det.object.nro_docref1	 [ll_ins_det] = ls_nro_doc_cab
			ELSE
				adw_asiento_det.object.flag_doc_edit [ll_ins_det] = 'E'
				adw_asiento_det.object.tipo_docref1  [ll_ins_det] = gnvo_app.is_null
				adw_asiento_det.object.nro_docref1	 [ll_ins_det] = gnvo_app.is_null
			END IF
			
			IF lstr_cnta.flag_ctabco = '1' THEN
				adw_asiento_det.object.cod_ctabco [ll_ins_det] = ls_codctabco
			ELSE
				adw_asiento_det.object.cod_ctabco [ll_ins_det] = gnvo_app.is_null
			END IF	
			
		ELSE			 
			Messagebox('Aviso','El Cuenta Bancaria no tiene Cuenta Contable Vinculada , Verifique!' &
								+ "~r~nCuenta Bancaria: " + ls_codctabco )
			return false
		END IF
		
		
	END IF
	
	//Hago el asiento de ajuste
	this.of_generar_ajuste(adw_asiento_cab, adw_asiento_det)
	
	RETURN true
	
catch ( Exception ex )
	ROLLBACK;
	f_mensaje("Error al generar asiento de Tesorería: " + ex.getMessage(), "")
	return false
	
finally

end try


end function

on n_cst_asiento_contable.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_asiento_contable.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;Integer li_count

try 
	/***********Recupero Parametros*******************/
	invo_asiento_glosa	= CREATE n_cst_asiento_glosa
	invo_cntbl				= create n_cst_contabilidad	
	
	
	/***********Matriz Contable*******************/
	ids_matriz_Cntbl		= create u_ds_base
	ids_matriz_cntbl.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
	ids_matriz_cntbl.SettransObject(sqlca)
	
	//** Datastore De Asientos Cta. Cte. **//
	ids_doc_pend_cta_cte = Create u_ds_base
	ids_doc_pend_cta_cte.DataObject = 'd_doc_pend_x_aplic_doc_tbl'
	ids_doc_pend_cta_cte.SettransObject(sqlca)
	
	//** Datastore Doc Pendientes Cta CTE **//
	ids_doc_pend_adic_tbl = Create u_ds_base
	ids_doc_pend_adic_tbl.DataObject = 'd_pre_asiento_x_doc_tbl'
	ids_doc_pend_adic_tbl.SettransObject(sqlca)
	
	//** Datastore de Glosa **//
	ids_glosa = Create u_ds_base
	ids_glosa.DataObject = 'd_data_glosa_grd'
	ids_glosa.SettransObject(sqlca)
	
	//** Glosa para ASiento de Caja y Bancos **//
	ids_glosa_cb = Create u_ds_base
	ids_glosa_cb.DataObject = 'd_glosa_cb_tbl'
	ids_glosa_cb.SettransObject(sqlca)
	
	select cod_soles, cod_dolares
		into :is_soles, :is_dolares
	from logparam
	where reckey = '1';
	
	//Obtengo las cuentas contables
	is_cnta_ajuste_hab = gnvo_app.of_get_parametro("CNTA_CNTBL AJSUTE REDONDEO HABER", "77731002")
	is_cnta_ajuste_deb = gnvo_app.of_get_parametro("CNTA_CNTBL AJSUTE REDONDEO DEBE", "96677132")
	
	//Parametros para ajuste por redondeo
	is_cencos_aj 			= gnvo_app.of_get_parametro('CENCOS_AJUSTE_REDONDEO', '60100301')
	is_centro_benef_aj 	= gnvo_app.of_get_parametro('CENTRO_BENEF_AJUSTE_REDONDEO', '4010')
	idc_max_dif_ajuste	= gnvo_app.of_get_parametro_dec('FIN_AJUSTE_MAX_REDONDEO', 10.00 )
	
	select count(*)
		into :li_count
	from cntbl_cnta cc
	where cc.cnta_ctbl = :is_cnta_ajuste_hab;
	
	if li_count = 0 then
		MessageBox('Error', 'La cuenta contable ' + is_cnta_ajuste_hab + ' que correspodne a ' &
								+ 'CNTA_CNTBL AJSUTE REDONDEO HABER no existe en el plan de cuentas, ' &
								+ 'por favor corrija')
		return
	end if
	
	select count(*)
		into :li_count
	from cntbl_cnta cc
	where cc.cnta_ctbl = :is_cnta_ajuste_deb;
	
	if li_count = 0 then
		MessageBox('Error', 'La cuenta contable ' + is_cnta_ajuste_deb + ' que correspodne a ' &
								+ 'CNTA_CNTBL AJSUTE REDONDEO DEBE no existe en el plan de cuentas, ' &
								+ 'por favor corrija')
		return
	end if
	
	//Validar el centro de beneficio
	select count(*)
		into :li_count
	from centro_beneficio cb
	where cb.centro_benef = :is_centro_benef_aj;
	
	if li_count = 0 then
		MessageBox('Error', 'El centro de Beneficio ' + is_centro_benef_aj + ' que correspodne a ' &
								+ 'CENTRO_BENEF_AJUSTE_REDONDEO no existe en el maestro de centro de beneficios, ' &
								+ 'por favor corrija')
		return
	end if
	
	//Validar el centro de costos
	select count(*)
		into :li_count
	from centros_costo cc
	where cc.cencos = :is_cencos_aj;
	
	if li_count = 0 then
		MessageBox('Error', 'El centro de Costos ' + is_cencos_aj + ' que correspodne a ' &
								+ 'CENCOS_AJUSTE_REDONDEO no existe en el maestro de centros de costos, ' &
								+ 'por favor corrija')
		return
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en evento constructor de n_cst_asiento_contable')
end try
end event

event destructor;/***********Recupero Parametros*******************/
destroy 	invo_asiento_glosa
destroy	invo_cntbl

/***********Matriz Contable*******************/
destroy ids_matriz_Cntbl

//** Datastore De Asientos Cta. Cte. **//
destroy ids_doc_pend_cta_cte

//** Datastore Doc Pendientes Cta CTE **//
destroy ids_doc_pend_adic_tbl

destroy ids_glosa

destroy ids_glosa_cb

end event

