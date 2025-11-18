$PBExportHeader$n_cst_liq_pago.sru
forward
global type n_cst_liq_pago from nonvisualobject
end type
end forward

global type n_cst_liq_pago from nonvisualobject
end type
global n_cst_liq_pago n_cst_liq_pago

type variables
u_ds_base	ids_matriz_cntbl, ids_data_glosa
string		is_cnta_ctbl_ref, is_det_glosa_ref, is_flag_debhab_ref, is_cencos_ref, &
				is_cod_ctabco_ref
end variables

forward prototypes
public subroutine of_create_matriz_cntbl ()
public subroutine of_create_data_glosa ()
public subroutine of_destroy_matriz_cnbtl ()
public subroutine of_destroy_data_glosa ()
public subroutine of_select_liq_det (ref datawindow adw_liq_det, long al_row, string as_columna)
public function boolean of_cntas_pagar (string as_codrel, string as_tipo_doc, string as_nro_doc)
public function boolean of_monedas (ref string as_soles, ref string as_dolares)
public function boolean of_cntas_cobrar (string as_codrel, string as_tipo_doc, string as_nro_doc)
public function boolean of_verifica_flag_cntbl_cnta (string as_cnta_cntbl)
public subroutine of_llenar_data_glosa (u_dw_abc adw_liq_cab, u_dw_abc adw_liq_det, long al_row, string as_cnta_cntbl, string as_desc_cnta)
public function boolean of_llenar_flags_cnta_cntbl (ref datawindow adw_asiento_det, long al_row, string as_cnta_cntbl, string as_cencos, string as_tipo_doc, string as_nro_doc, string as_tipo_doc_ref, string as_nro_doc_ref, string as_cod_rel, string as_flag_docref)
public function boolean of_verifica_columna (datawindow adw_1, string as_colname)
public function boolean of_generar_asiento (u_dw_abc adw_liq_cab, u_dw_abc adw_liq_det, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, ref tab at_tab1)
public function boolean of_saldo_doc (string as_origen, integer ai_ano, integer ai_mes, integer ai_libro, integer ai_nro_asiento, string as_cod_rel, string as_tipo_doc, string as_nro_doc, ref decimal adc_sldo_sol, ref decimal adc_sldo_dol)
public subroutine of_calcula_imp_liq (ref u_dw_abc adw_liq_cab, ref u_dw_abc adw_liq_det)
public function boolean of_detracciones (string as_codrel, string as_tipo_doc, string as_nro_doc)
public function boolean of_letras_cobrar (string as_codrel, string as_tipo_doc, string as_nro_doc)
public function boolean of_letras_pagar (string as_codrel, string as_tipo_doc, string as_nro_doc)
end prototypes

public subroutine of_create_matriz_cntbl ();//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl = Create u_ds_base
ids_matriz_cntbl.DataObject = 'd_matriz_cntbl_financiera_det2_tbl'
ids_matriz_cntbl.SettransObject(sqlca)
//** **//
end subroutine

public subroutine of_create_data_glosa ();//** Datastore de Glosa **//
ids_data_glosa = Create u_ds_base
ids_data_glosa.DataObject = 'd_data_glosa_liq_pag_grd'
ids_data_glosa.SettransObject(sqlca)
//** **//
end subroutine

public subroutine of_destroy_matriz_cnbtl ();if IsValid(ids_matriz_cntbl) and Not IsNull(ids_matriz_cntbl) then
	DESTROY ids_matriz_cntbl
end if
end subroutine

public subroutine of_destroy_data_glosa ();if IsValid(ids_data_glosa) and Not IsNull(ids_data_glosa) then
	DESTROY ids_data_glosa
end if
end subroutine

public subroutine of_select_liq_det (ref datawindow adw_liq_det, long al_row, string as_columna);if adw_liq_det.RowCount() >= al_row then
	adw_liq_det.triggerEvent(Clicked!)
	adw_liq_det.SelectRow(0, false)
	adw_liq_det.SelectRow(al_row, true)
	adw_liq_det.SetRow(al_row)
	
	if as_columna <> '' then 
		adw_liq_det.SetColumn(as_columna)
	end if
else
	MessageBox('Error en funcion of_select_liq_det ' + This.ClassName(), &
			'Nro re registros en adw_liq_det: ' + string(adw_liq_det.RowCount()) &
			+ 'supera a al_row: ' + string(al_row), StopSign!)
	return
end if
end subroutine

public function boolean of_cntas_pagar (string as_codrel, string as_tipo_doc, string as_nro_doc);/*documento de provision*/
Long 		ll_count
string	ls_desc_prov

SELECT 	Count(*)
	INTO 	:ll_count
FROM 	cntas_pagar cp,
		cntbl_asiento_det cd
WHERE cp.cod_relacion = :as_codrel 		  	AND
	   cp.tipo_doc	    = :as_tipo_doc  		AND
		cp.nro_doc		 = :as_nro_doc			AND
  	  	cp.origen       = cd.origen        	AND
      cp.ano          = cd.ano            AND
	   cp.mes          = cd.mes            AND
		cp.nro_libro    = cd.nro_libro      AND
		cp.nro_asiento  = cd.nro_asiento    AND
		cp.cod_relacion = cd.cod_relacion   AND
		cp.tipo_doc     = cd.tipo_docref1   AND
		cp.nro_doc      = cd.nro_docref1 ;
/**/
			

// Genero el detalle solo si existen algun registro
IF ll_count = 0 then
	select nom_proveedor
		into :ls_desc_prov

	from proveedor
	where proveedor = :as_codrel;
	
	MessageBox('Aviso', 'El Documento no tiene asiento contable de provision ' &
				+ '~r~n Tipo Doc: ' + as_tipo_doc &
				+ '~r~n Nro Doc : ' + as_nro_doc &
				+ '~r~n Cod Relacion: ' + as_codrel + ' - ' + ls_desc_prov, &
				Exclamation!)
				
	return false
end if

/*Datos de la cuenta contable*/
SELECT 	cd.cnta_ctbl,
			cd.det_glosa,
			cd.flag_debhab ,
			cd.cencos   ,
			cd.cod_ctabco
	INTO 	:is_cnta_ctbl_ref,
			:is_det_glosa_ref ,
			:is_flag_debhab_ref,
			:is_cencos_ref	 ,
			:is_cod_ctabco_ref
FROM 	cntas_pagar cp,
  		cntbl_asiento_det cd
WHERE cp.cod_relacion = :as_codrel   		AND
      cp.tipo_doc	    = :as_tipo_doc		AND
		cp.nro_doc		 = :as_nro_doc			AND
      cp.origen       = cd.origen         AND
	   cp.ano          = cd.ano            AND
		cp.mes          = cd.mes            AND
		cp.nro_libro    = cd.nro_libro      AND
		cp.nro_asiento  = cd.nro_asiento    AND
		cp.cod_relacion = cd.cod_relacion   AND
		cp.tipo_doc     = cd.tipo_docref1   AND
		cp.nro_doc      = cd.nro_docref1   ;

return true
end function

public function boolean of_monedas (ref string as_soles, ref string as_dolares);SELECT cod_soles,
		 cod_dolares
  INTO :as_soles,
  		 :as_dolares
 FROM  logparam
 WHERE reckey = '1' ; 
 
IF SQLCA.SQLCode = -1 THEN 
	MessageBox('SQL error , Recuperación de Moneda', SQLCA.SQLErrText, StopSign!)
	return false
END IF

IF SQLCA.SQLCode = 100 THEN 
	MessageBox('Aviso', 'No ha definido parametros de Logistica', Exclamation!)
	return false
END IF

if as_soles = '' or IsNull(as_soles) then
	MessageBox('Aviso', 'No ha definido Moneda Soles en LogParam', Exclamation!)
	return false
end if

if as_dolares = '' or IsNull(as_dolares) then
	MessageBox('Aviso', 'No ha definido Moneda Dolares en LogParam', Exclamation!)
	return false
end if

return true
end function

public function boolean of_cntas_cobrar (string as_codrel, string as_tipo_doc, string as_nro_doc);/*documento de provision*/
Long 		ll_count
string	ls_desc_prov

SELECT 	Count(*)
	INTO 	:ll_count
FROM 	cntas_cobrar cc,
		cntbl_asiento_det cd
WHERE cc.cod_relacion = :as_codrel 		  	AND
	   cc.tipo_doc	    = :as_tipo_doc  		AND
		cc.nro_doc		 = :as_nro_doc			AND
  	  	cc.origen       = cd.origen        	AND
      cc.ano          = cd.ano            AND
	   cc.mes          = cd.mes            AND
		cc.nro_libro    = cd.nro_libro      AND
		cc.nro_asiento  = cd.nro_asiento    AND
		cc.cod_relacion = cd.cod_relacion   AND
		cc.tipo_doc     = cd.tipo_docref1   AND
		cc.nro_doc      = cd.nro_docref1 ;
/**/
			

// Genero el detalle solo si existen algun registro
IF ll_count = 0 then
	select nom_proveedor
		into :ls_desc_prov
	from proveedor
	where proveedor = :as_codrel;
	
	MessageBox('Aviso', 'El Documento no tiene asiento contable de Venta ' &
				+ '~r~n Tipo Doc: ' + as_tipo_doc &
				+ '~r~n Nro Doc : ' + as_nro_doc &
				+ '~r~n Cod Relacion: ' + as_codrel + ' - ' + ls_desc_prov, &
				Exclamation!)
				
	return false
end if

/*Datos de la cuenta contable*/
SELECT 	cd.cnta_ctbl,
			cd.det_glosa,
			cd.flag_debhab ,
			cd.cencos   ,
			cd.cod_ctabco
	INTO 	:is_cnta_ctbl_ref,
			:is_det_glosa_ref ,
			:is_flag_debhab_ref,
			:is_cencos_ref	 ,
			:is_cod_ctabco_ref
FROM 	cntas_cobrar cc,
  		cntbl_asiento_det cd
WHERE cc.cod_relacion = :as_codrel   		AND
      cc.tipo_doc	    = :as_tipo_doc		AND
		cc.nro_doc		 = :as_nro_doc			AND
      cc.origen       = cd.origen         AND
	   cc.ano          = cd.ano            AND
		cc.mes          = cd.mes            AND
		cc.nro_libro    = cd.nro_libro      AND
		cc.nro_asiento  = cd.nro_asiento    AND
		cc.cod_relacion = cd.cod_relacion   AND
		cc.tipo_doc     = cd.tipo_docref1   AND
		cc.nro_doc      = cd.nro_docref1   ;

return true
end function

public function boolean of_verifica_flag_cntbl_cnta (string as_cnta_cntbl);Boolean lb_retorno = FALSE
String  ls_flag_ctabco, ls_flag_cencos, ls_flag_cod_rel, ls_flag_doc_ref

SELECT Nvl(flag_ctabco,'0')  ,
       Nvl(flag_cencos ,'0') ,
       Nvl(flag_doc_ref,'0') ,
       Nvl(flag_codrel,'0') 
 INTO  :ls_flag_ctabco,
 		 :ls_flag_cencos,
		 :ls_flag_doc_ref,
 		 :ls_flag_cod_rel
 FROM  cntbl_cnta
WHERE cnta_ctbl = :as_cnta_cntbl ;


IF Integer(ls_flag_ctabco) + Integer(ls_flag_cencos) + Integer(ls_flag_cod_rel) &
	+ Integer(ls_flag_doc_ref) > 0 THEN
	lb_retorno = TRUE
END IF

Return lb_retorno
end function

public subroutine of_llenar_data_glosa (u_dw_abc adw_liq_cab, u_dw_abc adw_liq_det, long al_row, string as_cnta_cntbl, string as_desc_cnta);/****************************************************/
/*LLenado de Datastore en Caso de Liquidación       */
/* adw_1 = Cabecera de Solicitud Giro					 */
/* adw_2 = Detalle de Liquidacion de Solicitud Giro */
/* ads_1 = Datastore de Datos Para Glosa				 */
/* al_row_det = Linea de Detalle de Liquidación		 */
/****************************************************/

Long   ll_ins_ds, ll_row_mas

ids_data_glosa.Reset()
ll_row_mas = adw_liq_cab.GetRow()
if ll_row_mas <=0 then
	MessageBox('Aviso', 'Cabecera de liquidacion no esta definida', StopSign!)
	return
end if

ll_ins_ds = ids_data_glosa.InsertRow(0)
/*Cabecera de Liquidacion de pago*/
ids_data_glosa.Object.origen           [ll_ins_ds] = adw_liq_cab.Object.origen 			   [ll_row_mas]
ids_data_glosa.Object.nro_liquidacion  [ll_ins_ds] = adw_liq_cab.Object.nro_liquidacion   [ll_row_mas]
ids_data_glosa.Object.tipo_doc      	[ll_ins_ds] = adw_liq_cab.Object.cod_relacion      [ll_row_mas]
ids_data_glosa.Object.cod_relacion    	[ll_ins_ds] = adw_liq_cab.Object.cod_relacion     	[ll_row_mas]
ids_data_glosa.Object.nom_proveedor   	[ll_ins_ds] = adw_liq_cab.Object.nom_proveedor     [ll_row_mas]
ids_data_glosa.Object.observacion   	[ll_ins_ds] = adw_liq_cab.Object.observacion     	[ll_row_mas]
ids_data_glosa.Object.cod_usr   			[ll_ins_ds] = adw_liq_cab.Object.cod_usr     		[ll_row_mas]

if al_row > 0 AND al_row <= adw_liq_det.RowCount() then
	/*Detalle de Liquidacion de Pago*/
	ids_data_glosa.Object.origen_doc_ref	[ll_ins_ds] = adw_liq_det.Object.origen_doc_ref	[al_row]
	ids_data_glosa.Object.tipo_doc_ref	 	[ll_ins_ds] = adw_liq_det.Object.tipo_doc_ref   [al_row]
	ids_data_glosa.Object.nro_doc_ref	 	[ll_ins_ds] = adw_liq_det.Object.nro_doc_ref	   [al_row]
end if

ids_data_glosa.Object.cnta_ctbl		 	[ll_ins_ds] = as_cnta_cntbl
ids_data_glosa.Object.desc_cnta		 	[ll_ins_ds] = as_desc_cnta

end subroutine

public function boolean of_llenar_flags_cnta_cntbl (ref datawindow adw_asiento_det, long al_row, string as_cnta_cntbl, string as_cencos, string as_tipo_doc, string as_nro_doc, string as_tipo_doc_ref, string as_nro_doc_ref, string as_cod_rel, string as_flag_docref);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef
Boolean lb_retorno = TRUE


IF f_cntbl_cnta(as_cnta_cntbl,ls_flag_ctabco, ls_flag_cencos, ls_flag_doc_ref, &
					 ls_flag_cod_rel ,ls_flag_cebef)  THEN

	IF ls_flag_cencos = '1' THEN
		adw_asiento_det.object.cencos [al_row] = as_cencos
	ELSE
		SetNull(as_cencos)
		adw_asiento_det.object.cencos [al_row] = as_cencos		
	END IF

	IF ls_flag_doc_ref = '1' THEN
		if as_flag_docref = 'O' then
			// Documento Origen = Liquidacion de Pago

			adw_asiento_det.object.tipo_docref1 [al_row] = as_tipo_doc
			adw_asiento_det.object.nro_docref1  [al_row] = as_nro_doc
		ELSEIF as_flag_docref = 'R' then
			// Documento Origen = Documento de Referencia
			adw_asiento_det.object.tipo_docref1 [al_row] = as_tipo_doc_ref
			adw_asiento_det.object.nro_docref1  [al_row] = as_nro_doc_ref
		end if
	ELSE
		SetNull(as_tipo_doc)
		SetNull(as_nro_doc)
		adw_asiento_det.object.tipo_docref1 [al_row] = as_tipo_doc
		adw_asiento_det.object.nro_docref1  [al_row] = as_nro_doc
	END IF

	IF ls_flag_cod_rel = '1' THEN
		adw_asiento_det.object.cod_relacion [al_row] = as_cod_rel
	ELSE
		SetNull(as_cod_rel)
		adw_asiento_det.object.cod_relacion [al_row] = as_cod_rel
	END IF	

ELSE
   lb_retorno = FALSE
END IF

/**/
Return lb_retorno
end function

public function boolean of_verifica_columna (datawindow adw_1, string as_colname);Integer li_totcol ,li_x,li_pos
String  ls_colname
Boolean lb_retorno = FALSE

li_totcol = Integer(adw_1.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_colname = '#'+String(li_x)+ ".dbName"
	ls_colname = adw_1.Describe(ls_colname)
	li_pos = Pos(ls_colname,".")
	
	ls_colname = Mid(ls_colname,li_pos + 1)
	IF ls_colname = as_colname THEN
		lb_retorno = TRUE
		EXIT
	END IF
NEXT

Return lb_retorno
end function

public function boolean of_generar_asiento (u_dw_abc adw_liq_cab, u_dw_abc adw_liq_det, ref u_dw_abc adw_asiento_cab, ref u_dw_abc adw_asiento_det, ref tab at_tab1);/* Flag tabla 	1: Cuentas x Cobrar 
					2: Letras x Cobrar
					3: Cuentas x Pagar
					4: Letras x Pagar
*/

string 		ls_tipo_doc, ls_nro_liq, ls_origen_doc_ref, ls_tipo_doc_ref, &
				ls_nro_doc_ref, ls_concepto, ls_flag_tabla, ls_moneda, &
				ls_flujo_caja, ls_retencion, ls_flag_cxp, ls_confin, ls_codrel, &
				ls_soles, ls_dolares, ls_matriz, ls_glosa_texto, ls_glosa_campo, &
				ls_cnta_cntbl, ls_desc_cnta, ls_flag_debhab, ls_expresion, ls_formula, &
				ls_campo, ls_desc_glosa, ls_flag_docref, ls_observacion, &
				ls_cnta_cntbl_dif, ls_flag_debhab_dif,	ls_flag_debhab_dif_x_doc, &
				ls_det_glosa, ls_cnta_cntbl_per, ls_cnta_cntbl_gan, &
				ls_flag_tabla_liq = 'Q'
				
Long 			ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento, ll_row, ll_i, ll_imatriz, &
				ll_found, ll_row_ins
				
Integer  	li_item, li_pos_fin, li_pos_ini, li_pos, li_cont
decimal{3}	ldc_cambio
Decimal{2} 	ldc_importe_ret, ldc_importe_liq, ldc_importe_sol, &
				ldc_importe_dol, ldc_monto, ldc_saldo_sol, ldc_saldo_dol, &
				ldc_dc_sol, ldc_dc_dol
				
Date			ld_fecha_liq
boolean		lb_asiento_cntbl, lb_flag, lb_asiento_dif
n_cst_asiento_glosa lnv_asiento_glosa

/*********************************************************
	Obtengo los tipos de monedas de FinParam
**********************************************************/

if this.of_monedas(ls_soles, ls_dolares) = false then
	return false
end if

/*********************************************************
	Aplico cualquier cambio hecho en la liquidacion
**********************************************************/
adw_liq_det.AcceptText()
adw_liq_cab.AcceptText()

ll_row = adw_liq_cab.GetRow()

if ll_row = 0 then 
	MessageBox('Aviso', 'No ha definido la cabecera de la liquidacion', StopSign!)
	return false
end if

if adw_liq_det.RowCount() = 0 then 
	MessageBox('Aviso', 'No existe detalle en la liquidacion', StopSign!)
	return false
end if

ll_ano 			= Long(adw_liq_cab.object.ano				[ll_row])
ll_mes 			= Long(adw_liq_cab.object.mes				[ll_row])
ll_nro_libro 	= Long(adw_liq_cab.object.nro_libro		[ll_row])
ll_nro_asiento = Long(adw_liq_cab.object.nro_asiento	[ll_row])
ls_codrel		= adw_liq_cab.object.cod_relacion		[ll_row]
ls_moneda      = adw_liq_cab.object.cod_moneda			[ll_row]
ldc_cambio 		= dec(adw_liq_cab.object.tasa_cambio 	[ll_row]	)
ls_tipo_doc		= adw_liq_cab.object.tipo_doc				[ll_row]	
ls_nro_liq		= adw_liq_cab.object.nro_liquidacion	[ll_row]	
ld_fecha_liq	= Date(adw_liq_cab.object.fecha_liquidacion	[ll_row]	 )
ls_observacion = adw_liq_cab.object.observacion			[ll_row]	

if IsNull(ls_nro_liq) then ls_nro_liq = ''

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'No ha denifinido el tipo de documento de Liquidacion', Exclamation!)
	return false
end if

if ll_ano = 0 or IsNull(ll_ano) then
	MessageBox('Aviso', 'No ha definido el año, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('ano')
	return false
end if

if ll_mes = 0 or IsNull(ll_mes) then
	MessageBox('Aviso', 'No ha definido el mes, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('mes')
	return false
end if

if ll_ano = 0 or IsNull(ll_ano) then
	MessageBox('Aviso', 'No ha definido el Nro de Libro, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('nro_libro')
	return false
end if

if ldc_cambio = 0 or IsNull(ldc_cambio) then
	MessageBox('Aviso', 'No ha definido la tasa de cambio, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('tasa_cambio')
	return false
end if

if ls_codrel = '' or IsNull(ls_codrel) then
	MessageBox('Aviso', 'No ha definido el año, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('cod_relacion')
	return false
end if

if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'No ha definido el tipo de moneda, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('cod_moneda')
	return false
end if

if ls_observacion = '' or IsNull(ls_observacion) then
	MessageBox('Aviso', 'No ha ingresado ninguna observacion, Verifique', StopSign!)
	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('observacion')
	return false
end if

/*Cuentas Contables para Diferencia de Cambio*/
SELECT 	cnta_ctbl_dc_ganancia,
			cnta_ctbl_dc_perdida
	INTO 	:ls_cnta_cntbl_gan,
  			:ls_cnta_cntbl_per
FROM finparam
WHERE (reckey = '1')  ;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existen parametros en FINPARAM', Exclamation!)
	return false
end if

if SQLCA.SQLCode < 0 then
	MessageBox('Aviso', SQLCA.SQLErrText, Exclamation!)
	return false
end if

if ls_cnta_cntbl_gan = '' or IsNull(ls_cnta_cntbl_gan) then
	MessageBox('Aviso', 'No ha definido la cuenta Contable para diferencia de tipo de cambio ' &
		+ ' cnta_ctbl_dc_ganancia en FinParam', Exclamation!)
	return false
end if
 
if ls_cnta_cntbl_per = '' or IsNull(ls_cnta_cntbl_per) then
	MessageBox('Aviso', 'No ha definido la cuenta Contable para diferencia de tipo de cambio ' &
		+ ' cnta_ctbl_dc_perdida en FinParam', Exclamation!)
	return false
end if


// Creo el DataStore para la matriz Comtable
this.of_create_matriz_cntbl( )

// Creo el DataStore para guardar los datos para la glosa
this.of_create_data_glosa( )

// Objeto para la creacion de la glosa del asiento
lnv_asiento_glosa    = CREATE n_cst_asiento_glosa

/*********************************************************
	Elimino todo el detalle del asiento
**********************************************************/
adw_asiento_det.SetRedraw(false)
do while adw_asiento_det.RowCount() > 0
	adw_asiento_det.DeleteRow(0)
loop

/*********************************************************
	Genero la cabecera del asiento
**********************************************************/

if adw_asiento_cab.RowCount() = 0 then
	ll_row = adw_asiento_cab.event dynamic ue_insert()
	if ll_row <= 0 then 
		adw_asiento_det.SetRedraw(true)
		return false
	end if
	/*Inserta Cabecera de Asiento de Solicitud de giro*/
	adw_asiento_cab.object.origen      	[ll_row] = gs_origen
	adw_asiento_cab.object.ano   	      [ll_row] = ll_ano
	adw_asiento_cab.object.mes	         [ll_row] = ll_mes
	adw_asiento_cab.object.nro_libro    [ll_row] = ll_nro_libro
	adw_asiento_cab.object.nro_asiento	[ll_row] = ll_nro_asiento
end if

adw_asiento_cab.object.cod_moneda   [ll_row] = ls_moneda
adw_asiento_cab.object.tasa_cambio  [ll_row] = ldc_cambio
adw_asiento_cab.object.desc_glosa   [ll_row] = ls_observacion
adw_asiento_cab.object.fec_registro [ll_row] = ld_fecha_liq
adw_asiento_cab.object.fecha_cntbl  [ll_row] = ld_fecha_liq
adw_asiento_cab.object.cod_usr      [ll_row] = gs_user
adw_asiento_cab.object.flag_tabla   [ll_row] = ls_flag_tabla_liq
adw_asiento_cab.object.flag_estado  [ll_row] = '1'	

/*Activo update*/
adw_asiento_cab.ii_update = 1


/*********************************************************
	Armo el asiento deacuerdo al detalle de la liquidacion
**********************************************************/

FOR ll_i = 1 TO adw_liq_det.Rowcount()  //Recorro detalle de la liquidacion
	 /*Inicialización de Variables*/
	 ls_origen_doc_ref	= adw_liq_det.object.origen_doc_ref 	[ll_i]
	 ls_tipo_doc_ref		= adw_liq_det.object.tipo_doc_ref		[ll_i]
	 ls_nro_doc_ref		= adw_liq_det.object.nro_doc_ref			[ll_i]
	 ls_concepto			= adw_liq_det.object.concepto				[ll_i]
	 ls_flag_tabla			= adw_liq_det.object.flag_tabla			[ll_i]
	 ls_confin  		  	= adw_liq_det.object.confin 	  			[ll_i]	
	 li_item	  		  		= adw_liq_det.object.item   	  			[ll_i]	
	 ldc_importe_ret		= adw_liq_det.object.importe_retenido	[ll_i]
	 ldc_importe_liq		= adw_liq_det.object.importe_liq			[ll_i]
	 ls_flag_cxp			= adw_liq_det.object.flag_cxp				[ll_i]
	 
	choose case ls_flag_tabla
		case '1'  //Cuentas por cobrar
			if this.of_cntas_cobrar( ls_codrel, ls_tipo_doc_ref, ls_nro_doc_ref ) = FALSE then
				lb_asiento_cntbl = false
			else
				lb_asiento_cntbl = true
			end if

		case '2'  //Letras por cobrar
			if this.of_letras_cobrar( ls_codrel, ls_tipo_doc_ref, ls_nro_doc_ref ) = FALSE then
				lb_asiento_cntbl = false
			else
				lb_asiento_cntbl = true
			end if

		case '3'  // Cuentas por Pagar
			if this.of_cntas_pagar( ls_codrel, ls_tipo_doc_ref, ls_nro_doc_ref ) = FALSE then
				lb_asiento_cntbl = false
			else
				lb_asiento_cntbl = true
			end if

		case '4'  //Letras por pagar
			if this.of_letras_pagar( ls_codrel, ls_tipo_doc_ref, ls_nro_doc_ref ) = FALSE then
				lb_asiento_cntbl = false
			else
				lb_asiento_cntbl = true
			end if

		case 'N', 'G'  //Detracciones
			if this.of_detracciones( ls_codrel, ls_tipo_doc_ref, ls_nro_doc_ref ) = FALSE then
				lb_asiento_cntbl = false
			else
				lb_asiento_cntbl = true
			end if

		case else
			MessageBox('Aviso', 'Flag Tabla fuera de definición: ' + ls_flag_tabla, StopSign!)
			continue
	end choose
	
	if lb_asiento_cntbl = false then
		continue
	end if

	IF is_flag_debhab_ref = 'D' THEN
		is_flag_debhab_ref = 'H'
	ELSE
		is_flag_debhab_ref = 'D'				 
	END IF
		
	IF ls_moneda = ls_soles THEN
		ldc_importe_sol = ldc_importe_liq
		ldc_importe_dol = Round(ldc_importe_liq / ldc_cambio, 2)
	ELSEIF ls_moneda = ls_dolares THEN	 
	  	ldc_importe_dol = ldc_importe_liq
		ldc_importe_sol = Round(ldc_importe_liq * ldc_cambio, 2)					 
	END IF

	ll_row = adw_asiento_det.event dynamic ue_insert()
			
	if ll_row > 0 then
		adw_asiento_det.Object.origen 			[ll_row] = gs_origen
		adw_asiento_det.Object.ano		 			[ll_row] = ll_ano
		adw_asiento_det.Object.mes 				[ll_row] = ll_mes
		adw_asiento_det.Object.nro_libro 		[ll_row] = ll_nro_libro
		adw_asiento_det.Object.nro_asiento  	[ll_row] = ll_nro_asiento
		adw_asiento_det.Object.item				[ll_row] = ll_row
		adw_asiento_det.Object.cnta_ctbl			[ll_row] = is_cnta_ctbl_ref
		adw_asiento_det.Object.fec_cntbl 		[ll_row] = ld_fecha_liq
		adw_asiento_det.Object.det_glosa			[ll_row] = is_det_glosa_ref
		adw_asiento_det.Object.flag_debhab		[ll_row] = is_flag_debhab_ref
		adw_asiento_det.Object.cencos 			[ll_row] = is_cencos_ref
		adw_asiento_det.Object.cod_ctabco		[ll_row] = is_cod_ctabco_ref
		adw_asiento_det.Object.tipo_docref1		[ll_row] = ls_tipo_doc_ref
		adw_asiento_det.Object.nro_docref1 		[ll_row] = ls_nro_doc_ref
		adw_asiento_det.Object.cod_relacion		[ll_row] = ls_codrel
  		adw_asiento_det.Object.imp_movsol  		[ll_row] = ldc_importe_sol
		adw_asiento_det.Object.imp_movdol  		[ll_row] = ldc_importe_dol
		adw_asiento_det.Object.flag		  		[ll_row] = 'S'
		adw_asiento_det.Object.flag_doc_edit  	[ll_row] = 'E'
	END IF
	
	/*********************************************************
		Armo el asiento por Diferencia de cambio
	**********************************************************/

	this.of_saldo_doc( ls_origen_doc_ref, ll_ano, ll_mes, ll_nro_libro, &
				ll_nro_asiento, ls_codrel, ls_tipo_doc_ref, ls_nro_doc_ref, &
				ldc_saldo_sol, ldc_saldo_dol )
	
	IF ls_moneda = ls_dolares THEN /*SE REVISARA DIFERENCIA EN CAMBIO EN SOLES*/				 
		// Solo pongo la diferencia en cambio si el importe es igual al saldo
		// controlo la diferencia en Soles
		if ldc_importe_dol = ldc_saldo_dol and ldc_importe_sol <> ldc_saldo_sol then
			ldc_dc_dol = 0 
			ldc_dc_sol = ldc_importe_sol - ldc_saldo_sol
			
			IF ldc_dc_sol > 0 THEN     /*Dolar Subio*/
		 		ls_cnta_cntbl_dif         = ls_cnta_cntbl_per
				 
				IF is_flag_debhab_ref = 'D' THEN
					ls_flag_debhab_dif       = 'D'
					ls_flag_debhab_dif_x_doc = 'H'
				ELSE
					ls_flag_debhab_dif       = 'H'
					ls_flag_debhab_dif_x_doc = 'D'
				END IF

				ls_det_glosa  = 'Diferencia en Tipo de Cambio, ha incrementado'
				lb_asiento_dif = true
				
							 
			ELSEIF ldc_dc_sol < 0 THEN /*Dolar Bajo*/		
				ls_cnta_cntbl_dif = ls_cnta_cntbl_gan
				IF is_flag_debhab_ref = 'D' THEN
					ls_flag_debhab_dif       = 'H'
					ls_flag_debhab_dif_x_doc = 'D'
				ELSE
					ls_flag_debhab_dif       = 'D'
					ls_flag_debhab_dif_x_doc = 'H'
				END IF
				
				ls_det_glosa  = 'Diferencia en Tipo de Cambio, ha disminuido'
				lb_asiento_dif = true
				  
			ELSEIF ldc_dc_sol = 0 THEN /*No Genera Diferencia en Cambio*/
				 lb_asiento_dif = false					
		 	END IF /*VERIFICACION SALDO*/
		else
			lb_asiento_dif = false
		end if
	ELSEIF ls_moneda = ls_soles THEN /*SE REVISARA DIFERENCIA EN CAMBIO EN DOLARES*/				 
		// Solo pongo la diferencia en cambio si el importe es igual al saldo
		// controlo la diferencia en dolares
		if ldc_importe_sol = ldc_saldo_sol and ldc_importe_dol <> ldc_saldo_dol then
			ldc_dc_sol = 0 
			ldc_dc_dol = ldc_importe_dol - ldc_saldo_dol
			
			IF ldc_dc_dol < 0 THEN     /*Dolar Subio*/
		 		ls_cnta_cntbl_dif         = ls_cnta_cntbl_per
				 
				IF is_flag_debhab_ref = 'D' THEN
					ls_flag_debhab_dif       = 'H'
					ls_flag_debhab_dif_x_doc = 'D'
				ELSE
					ls_flag_debhab_dif       = 'D'
					ls_flag_debhab_dif_x_doc = 'H'
				END IF

				ls_det_glosa  = 'Diferencia en Tipo de Cambio, ha incrementado'
				lb_asiento_dif = true
							 
			ELSEIF ldc_dc_dol > 0 THEN /*Dolar Bajo*/		
				ls_cnta_cntbl_dif = ls_cnta_cntbl_gan
				IF is_flag_debhab_ref = 'D' THEN
					ls_flag_debhab_dif       = 'D'
					ls_flag_debhab_dif_x_doc = 'H'
				ELSE
					ls_flag_debhab_dif       = 'H'
					ls_flag_debhab_dif_x_doc = 'D'
				END IF
					 
				ls_det_glosa  = 'Diferencia en Tipo de Cambio, ha disminuido'
				lb_asiento_dif = true
				  
			ELSEIF ldc_dc_dol = 0 THEN /*No Genera Diferencia en Cambio*/
				 lb_asiento_dif = false					
		 	END IF /*VERIFICACION SALDO*/
		else
			lb_asiento_dif = false
		end if
	END IF
	
	if lb_asiento_dif = true then
 		/************************/
		/*Diferencia en Cambio  */
		/************************/
												  
	 	/*Insertar Nuevo Registro*/
		ldc_dc_sol = abs(ldc_dc_sol)
		ldc_dc_dol = abs(ldc_dc_dol)
		
		ls_expresion = "cnta_ctbl = '" + ls_cnta_cntbl_dif + "'"
		ll_found     = adw_asiento_det.Find(ls_expresion,1,adw_asiento_det.Rowcount())
		
		IF ll_found > 0 THEN
			ls_flag_debhab  = adw_asiento_det.object.flag_debhab [ll_found]
			ldc_importe_sol = adw_asiento_det.object.imp_movsol  [ll_found]
			ldc_importe_dol = adw_asiento_det.object.imp_movdol  [ll_found]
			
			if ls_flag_debhab <> ls_flag_debhab_dif then
				ldc_importe_sol -= ldc_dc_sol
				ldc_importe_dol -= ldc_dc_dol
			else
				ldc_importe_sol += ldc_dc_sol
				ldc_importe_dol += ldc_dc_dol
			end if
			
			if ldc_importe_sol < 0 or ldc_importe_dol < 0 then
				if ls_flag_debhab = 'D' then
					ls_flag_debhab = 'H'
				else
					ls_flag_debhab = 'D'
				end if
				
				ldc_importe_sol = abs(ldc_importe_sol)
				ldc_importe_dol = abs(ldc_importe_dol)
				
			end if
			
 			adw_asiento_det.object.imp_movsol  [ll_found] = ldc_importe_sol
			adw_asiento_det.object.imp_movdol  [ll_found] = ldc_importe_dol
		ELSE
			/*Asiento de Diferencia en cambio*/
			ll_row = adw_asiento_det.event dynamic ue_insert( )	//Inserta Registro 
			
			if ll_row <= 0 then
				continue
			end if
    		adw_asiento_det.Object.origen 		 [ll_row] = gs_origen
			adw_asiento_det.Object.ano		 		 [ll_row] = ll_ano
			adw_asiento_det.Object.mes 			 [ll_row] = ll_mes
			adw_asiento_det.Object.nro_libro 	 [ll_row] = ll_nro_libro
			adw_asiento_det.Object.nro_asiento   [ll_row] = ll_nro_asiento
			adw_asiento_det.Object.item	       [ll_row] = ll_row
		   adw_asiento_det.Object.cnta_ctbl     [ll_row] = ls_cnta_cntbl_dif
			adw_asiento_det.Object.det_glosa     [ll_row] = ls_det_glosa
     		adw_asiento_det.Object.flag_debhab   [ll_row] = ls_flag_debhab_dif  							 
	      adw_asiento_det.object.imp_movsol    [ll_row] = ldc_dc_sol
		 	adw_asiento_det.object.imp_movdol    [ll_row] = ldc_dc_dol
			adw_asiento_det.object.flag_doc_edit [ll_row] = 'E' 
			
		END IF /*Busqueda de cuenta generada para acumular*/		
		
		/*Asiento de doc x diferencia en cambio*/	
 		ll_row =adw_asiento_det.event dynamic ue_insert()	//Inserta Registro 
		
		if ll_row <= 0 then
			continue
		end if
  		adw_asiento_det.Object.origen 		 [ll_row] = gs_origen
		adw_asiento_det.Object.ano		 		 [ll_row] = ll_ano
		adw_asiento_det.Object.mes 			 [ll_row] = ll_mes
		adw_asiento_det.Object.nro_libro 	 [ll_row] = ll_nro_libro
		adw_asiento_det.Object.nro_asiento   [ll_row] = ll_nro_asiento
		adw_asiento_det.Object.item	       [ll_row] = ll_row
		adw_asiento_det.Object.cnta_ctbl     [ll_row] = is_cnta_ctbl_ref
		adw_asiento_det.Object.det_glosa     [ll_row] = is_det_glosa_ref
		adw_asiento_det.Object.tipo_docref1	 [ll_row] = ls_tipo_doc_ref
		adw_asiento_det.Object.nro_docref1 	 [ll_row] = ls_nro_doc_ref
		adw_asiento_det.Object.cod_relacion  [ll_row] = ls_codrel
		adw_asiento_det.Object.cencos 		 [ll_row] = is_cencos_ref
		adw_asiento_det.Object.cod_ctabco	 [ll_row] = is_cod_ctabco_ref
		adw_asiento_det.Object.flag_debhab   [ll_row] = ls_flag_debhab_dif_x_doc  
		adw_asiento_det.object.imp_movsol    [ll_row] = ldc_dc_sol
		adw_asiento_det.object.imp_movdol    [ll_row] = ldc_dc_dol
  		adw_asiento_det.object.flag_doc_edit [ll_row] = 'E' 
		  
	END IF /*CIERRA X TIPO DE MONEDA*/


	/*********************************************************
		En caso que el detalle no tenga su concepto financiero
		no me hago problemas simplemente no lo evaluo
	**********************************************************/

	if ls_confin = '' or IsNull(ls_confin) then
		continue
	end if

	/*********************************************************
		Insercion de Cuentas dependiendo de la Matriz Contable
	**********************************************************/

	SELECT matriz_cntbl
		INTO :ls_matriz
	FROM concepto_financiero
	WHERE confin = :ls_confin;
		  
	IF Isnull(ls_matriz) OR Trim(ls_matriz) = ''  THEN
		Messagebox('Aviso','Concepto Financiero Nº '+ls_confin+' No se ha Vinculado Matriz', Exclamation!)
	 	at_tab1.SelectedTab = 1
	 	this.of_select_liq_det( adw_liq_det, ll_i, 'confin')
	 	this.of_destroy_matriz_cnbtl( )
	 	this.of_destroy_data_glosa()
	 	DESTROY lnv_asiento_glosa
		 adw_asiento_det.SetRedraw(true)
	 	return false
	END IF

	ids_matriz_cntbl.Retrieve(ls_matriz)					// Recuperación de Información de Matriz Detalle
	  
	FOR ll_imatriz = 1 TO ids_matriz_cntbl.Rowcount()
			   
		/**Inicializacion de Variables**/
		lb_flag	 = FALSE
		ldc_monto   	= 0.00
  		li_pos 	   	= 1
		li_pos_ini  	= 0
		li_pos_fin  	= 0
		li_cont   		= 0
		/**/
			
		ls_cnta_cntbl 	= ids_matriz_cntbl.Object.cnta_ctbl   [ll_imatriz]
		ls_desc_cnta	= ids_matriz_cntbl.Object.desc_cnta   [ll_imatriz]
		ls_flag_docref = ids_matriz_cntbl.Object.flag_docref [ll_imatriz]
		
		if IsNull(ls_flag_docref) then ls_flag_docref = ''
		
 		/*Verifica si requieres algun Flag en la Cnta Contable*/
		lb_flag = f_verifica_flag_cntbl_cnta(ls_cnta_cntbl)
		/**/
				
		ls_flag_debhab = ids_matriz_cntbl.Object.flag_debhab [ll_imatriz]
		//Busco la cnta cntbl en el asiento de acuerdo al tipo de documento de referencia

		ls_expresion 	= "cnta_ctbl =	'" + ls_cnta_cntbl + "' AND flag_debhab	= '" &
							+ ls_flag_debhab + "' AND flag <> 'S' "
		
		ll_found       = adw_asiento_det.find(ls_expresion, 1, adw_asiento_det.rowcount())
		ls_formula     = ids_matriz_cntbl.Object.formula 		[ll_imatriz]
		ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo  [ll_imatriz]
		ls_glosa_texto	= ids_matriz_cntbl.Object.glosa_texto  [ll_imatriz]
				
		/*funcion de llenado de datastore*/
		this.of_llenar_data_glosa(adw_liq_cab, adw_liq_det, ll_i, ls_cnta_cntbl, ls_desc_cnta)
		/**/
				
		/***********************/
		li_pos_ini     = Pos(ls_formula,'[',li_pos) 
				
		IF li_pos_ini = 1 THEN       /*Formula Pura */
			ldc_monto  = 0.00
			
			MessageBox('Aviso', 'Para la liquidación de pago no se puede usar formula pura, por favor ' &
				+ 'especifique un campo, sin los corchetes', Exclamation!)
			continue
			
			
		ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
			
			ls_campo = Mid(ls_formula, 1, li_pos_ini - 2)
			
			if this.of_verifica_columna(adw_liq_det, ls_campo) = false then
				MessageBox('Aviso', 'Error en formula, campo: ' + ls_campo + ' no xiste', Exclamation!)
				continue
			end if
			
			ldc_monto  = adw_liq_cab.GetItemNumber(ll_i,ls_campo)
	
		ELSEIF li_pos_ini = 0 THEN	  /*Campo*/
	
			if this.of_verifica_columna(adw_liq_det, ls_formula) = false then
				MessageBox('Aviso', 'Error en formula, campo: ' + ls_formula + ' no xiste', Exclamation!)
				continue
			end if
	
			ldc_monto  = adw_liq_det.GetItemNumber(ll_i,ls_formula)
		END IF
	
		// En la liquidacion de pago no existen impuestos 
		IF ll_found = 0 THEN
			/*Extraer Glosa*/
			ls_desc_glosa = lnv_asiento_glosa.of_set_glosa(ids_data_glosa, 1, ls_glosa_texto, ls_glosa_campo)
				
			ll_row_ins    = adw_asiento_det.Insertrow(0)		
			
			adw_asiento_det.Object.item		 		[ll_row_ins] = ll_row_ins
			adw_asiento_det.Object.cnta_ctbl       [ll_row_ins] = ids_matriz_cntbl.Object.cnta_ctbl  [ll_imatriz]
			adw_asiento_det.Object.flag_debhab     [ll_row_ins] = ids_matriz_cntbl.Object.flag_debhab[ll_imatriz]
			adw_asiento_det.Object.det_glosa       [ll_row_ins] = trim(Mid(ls_desc_glosa, 1, 60))
			adw_asiento_det.Object.fec_cntbl		  	[ll_row_ins] = ld_fecha_liq
			adw_asiento_det.Object.origen	        	[ll_row_ins] = gs_origen
			adw_asiento_det.Object.ano		        	[ll_row_ins] = ll_ano
			adw_asiento_det.Object.mes		        	[ll_row_ins] = ll_mes
			adw_asiento_det.Object.nro_libro       [ll_row_ins] = ll_nro_libro
			adw_asiento_det.Object.nro_asiento	  	[ll_row_ins] = ll_nro_asiento
		   adw_asiento_det.Object.flag		  		[ll_row_ins] = 'N'					
			adw_asiento_det.Object.flag_doc_edit  	[ll_row_ins] = 'E'
				

			/**/
			if lb_flag then
				this.of_llenar_flags_cnta_cntbl( adw_asiento_det, ll_row_ins, &
					ls_cnta_cntbl, is_cencos_ref, ls_tipo_doc, ls_nro_liq, &
					ls_tipo_doc_ref, ls_nro_doc_ref, ls_codrel, ls_flag_docref )
			end if
			/**/
				
			IF ls_moneda = ls_soles THEN
				adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
				adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_cambio,2)
			ELSEIF ls_moneda = ls_dolares THEN
				adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
				adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_cambio,2)					
			END IF
				
		ELSE
			
			IF ls_moneda = ls_soles THEN
				adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
				adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_cambio,2)
			ELSEIF ls_moneda = ls_dolares THEN
				adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
				adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_cambio,2)					
			END IF
		END IF
			
	NEXT

NEXT

/**************************************************************
*
*
*
*
*
	Armo el asiento deacuerdo a la cabacera de la liquidacion
*
*
*
*
*
***************************************************************/

// Calculo el monto neto de la liquidacion
this.of_calcula_imp_liq(adw_liq_cab, adw_liq_det)

//Insercion de Cuentas dependiendo de la Matriz Contable
ll_row 		= adw_liq_cab.GetRow()
ldc_monto 	= Dec(adw_liq_cab.object.monto_neto[ll_row])

if ldc_monto = 0 or IsNull(ldc_monto) then
	this.of_destroy_matriz_cnbtl( )
	this.of_destroy_data_glosa()
	DESTROY lnv_asiento_glosa
	adw_asiento_det.SetRedraw(true)
	return false
end if

ls_confin 	= adw_liq_cab.object.confin[ll_row]


SELECT matriz_cntbl
	INTO :ls_matriz
FROM concepto_financiero
WHERE confin = :ls_confin;
		  
IF Isnull(ls_matriz) OR Trim(ls_matriz) = ''  THEN
	Messagebox('Aviso','Concepto Financiero en cabecera de liquidacion no tiene Vinculado Matriz', Exclamation!)
 	adw_liq_cab.SetFocus()
	adw_liq_cab.SetColumn('confin')
 	this.of_destroy_matriz_cnbtl( )
 	this.of_destroy_data_glosa()
 	DESTROY lnv_asiento_glosa
	 adw_asiento_det.SetRedraw(true)
 	return false
END IF

ids_matriz_cntbl.Retrieve(ls_matriz)					// Recuperación de Información de Matriz Detalle
	  
FOR ll_imatriz = 1 TO ids_matriz_cntbl.Rowcount()
			   
	/**Inicializacion de Variables**/
	lb_flag	 = FALSE
	li_pos 	   	= 1
	li_pos_ini  	= 0
	li_pos_fin  	= 0
	li_cont   		= 0
	ldc_monto      = 0
	/**/
			
	ls_cnta_cntbl 	= ids_matriz_cntbl.Object.cnta_ctbl   [ll_imatriz]
	ls_desc_cnta	= ids_matriz_cntbl.Object.desc_cnta   [ll_imatriz]
	ls_flag_docref = ids_matriz_cntbl.Object.flag_docref [ll_imatriz]
	
	if IsNull(ls_flag_docref) then ls_flag_docref = ''
				
	/*Verifica si requieres algun Flag en la Cnta Contable*/
	lb_flag = f_verifica_flag_cntbl_cnta(ls_cnta_cntbl)
	/**/
				
	ls_flag_debhab = ids_matriz_cntbl.Object.flag_debhab [ll_imatriz]
	ls_expresion 	= "cnta_ctbl =	'" + ls_cnta_cntbl + "' AND flag_debhab	= '" &
						+ ls_flag_debhab + "' AND flag <> 'S' "
	ll_found       = adw_asiento_det.find(ls_expresion, 1, adw_asiento_det.rowcount())
	ls_formula     = ids_matriz_cntbl.Object.formula 		[ll_imatriz]
	ls_glosa_campo = ids_matriz_cntbl.Object.glosa_campo  [ll_imatriz]
	ls_glosa_texto	= ids_matriz_cntbl.Object.glosa_texto  [ll_imatriz]
				
	/*funcion de llenado de datastore*/
	this.of_llenar_data_glosa(adw_liq_cab, adw_liq_det, 0, ls_cnta_cntbl, ls_desc_cnta)
	/**/
				
	/***********************/
	li_pos_ini     = Pos(ls_formula,'[',li_pos) 
				
	IF li_pos_ini = 1 THEN       /*Formula Pura */
		ldc_monto  = 0.00
		
		MessageBox('Aviso', 'Para la liquidación de pago no se puede usar formula pura, por favor ' &
			+ 'especifique un campo', Exclamation!)
		continue
		
		
	ELSEIF li_pos_ini > 1 THEN	  /*Campo + Formula*/
		
		ls_campo = Mid(ls_formula, 1, li_pos_ini - 2)

		if this.of_verifica_columna(adw_liq_cab, ls_campo) = false then
			MessageBox('Aviso', 'Error en formula, campo: ' + ls_campo + ' no xiste', Exclamation!)
			continue
		end if
		
		ldc_monto  = adw_liq_cab.GetItemNumber(ll_row, ls_campo)

	ELSEIF li_pos_ini = 0 THEN	  /*Campo*/

		if this.of_verifica_columna(adw_liq_cab, ls_formula) = false then
			MessageBox('Aviso', 'Error en formula, campo: ' + ls_formula + ' no xiste', Exclamation!)
			continue
		end if

		ldc_monto  = adw_liq_cab.GetItemNumber(ll_row, ls_formula)
	END IF
				
	// En la liquidacion de pago no existen impuestos 
	IF ll_found = 0 THEN
		/*Extraer Glosa*/
		ls_desc_glosa = lnv_asiento_glosa.of_set_glosa(ids_data_glosa, 1, ls_glosa_texto, ls_glosa_campo)
			
		ll_row_ins    = adw_asiento_det.event Dynamic ue_insert() //Insertrow(0)		
			
		adw_asiento_det.Object.item		 		[ll_row_ins] = ll_row_ins
		adw_asiento_det.Object.cnta_ctbl       [ll_row_ins] = ids_matriz_cntbl.Object.cnta_ctbl  [ll_imatriz]
		adw_asiento_det.Object.flag_debhab     [ll_row_ins] = ids_matriz_cntbl.Object.flag_debhab[ll_imatriz]
		adw_asiento_det.Object.det_glosa       [ll_row_ins] = trim(Mid(ls_desc_glosa, 1, 60))
		adw_asiento_det.Object.fec_cntbl		  	[ll_row_ins] = ld_fecha_liq
		adw_asiento_det.Object.origen	        	[ll_row_ins] = gs_origen
		adw_asiento_det.Object.ano		        	[ll_row_ins] = ll_ano
		adw_asiento_det.Object.mes		        	[ll_row_ins] = ll_mes
		adw_asiento_det.Object.nro_libro       [ll_row_ins] = ll_nro_libro
		adw_asiento_det.Object.nro_asiento	  	[ll_row_ins] = ll_nro_asiento
	   adw_asiento_det.Object.flag		  		[ll_row_ins] = 'N'					
		adw_asiento_det.Object.flag_doc_edit  	[ll_row_ins] = 'E'
			
		/**/
		if lb_flag then
			SetNull(is_cencos_ref)
			SetNull(ls_tipo_doc_ref)
			SetNull(ls_nro_doc_ref)
			
			this.of_llenar_flags_cnta_cntbl( adw_asiento_det, ll_row_ins, &
				ls_cnta_cntbl, is_cencos_ref, ls_tipo_doc, ls_nro_liq, &
				ls_tipo_doc_ref, ls_nro_doc_ref, ls_codrel, ls_flag_docref )
		end if
		/**/
				
		IF ls_moneda = ls_soles THEN
			adw_asiento_det.Object.imp_movsol [ll_row_ins] = ldc_monto					
			adw_asiento_det.Object.imp_movdol [ll_row_ins] = Round(ldc_monto / ldc_cambio,2)
		ELSEIF ls_moneda = ls_dolares THEN
			adw_asiento_det.Object.imp_movdol [ll_row_ins] = ldc_monto
			adw_asiento_det.Object.imp_movsol [ll_row_ins] = Round(ldc_monto * ldc_cambio,2)					
		END IF
				
	ELSE
			
		IF ls_moneda = ls_soles THEN
			adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + ldc_monto					
			adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + Round(ldc_monto / ldc_cambio,2)
		ELSEIF ls_moneda = ls_dolares THEN
			adw_asiento_det.Object.imp_movdol [ll_found] = adw_asiento_det.Object.imp_movdol [ll_found] + ldc_monto
			adw_asiento_det.Object.imp_movsol [ll_found] = adw_asiento_det.Object.imp_movsol [ll_found] + Round(ldc_monto * ldc_cambio,2)					
		END IF
	END IF

NEXT			


this.of_destroy_matriz_cnbtl( )
this.of_destroy_data_glosa()
DESTROY lnv_asiento_glosa

adw_asiento_det.ii_update = 1
adw_asiento_det.SetRedraw(true)

return true


end function

public function boolean of_saldo_doc (string as_origen, integer ai_ano, integer ai_mes, integer ai_libro, integer ai_nro_asiento, string as_cod_rel, string as_tipo_doc, string as_nro_doc, ref decimal adc_sldo_sol, ref decimal adc_sldo_dol);String 	ls_flag_debhab
Decimal {2} ldc_sldo_sol = 0.00,ldc_sldo_dol = 0.00
Integer	li_count

adc_sldo_sol = 0.00
adc_sldo_dol = 0.00

if IsNull(ai_nro_asiento) or ai_nro_asiento = 0 then
	select sldo_sol, saldo_dol
		into :adc_sldo_sol, :adc_sldo_dol
	from doc_pendientes_cta_cte
	where cod_relacion 	= :as_cod_rel 	AND
			tipo_doc			= :as_tipo_doc AND
			nro_doc			= :as_nro_doc;
	
	if SQLCA.SQlCode = 100 then
		MessageBox('Aviso', 'Documento no se encuentra en Doc Pendientes, Verifique', StopSign!)
		adc_sldo_sol = 0.00
		adc_sldo_dol = 0.00
		return false
	end if
	
	if SQLCA.SQlCode < 0 then
		MessageBox('Aviso', SQLCA.SQLErrText, StopSign!)
		adc_sldo_sol = 0.00
		adc_sldo_dol = 0.00
		return false
	end if
	
else
	
	select count(*)
		into :li_count
 	FROM cntbl_asiento_det
	WHERE origen       = :as_origen      AND
			ano          = :ai_ano         AND
			mes          = :ai_mes         AND
			nro_libro    = :ai_libro   	 AND
			nro_asiento  = :ai_nro_asiento AND
			cod_relacion = :as_cod_rel  	 AND
			tipo_docref1 = :as_tipo_doc	 AND
			nro_docref1  = :as_nro_doc	;
	
	if li_count > 0 then
	
		/*Declaración de Cursor*/
		/* Cojo el asiento y voy recorriendolo para encontrar el saldo total*/
		DECLARE c_detalle CURSOR FOR
			SELECT 	imp_movsol,
						imp_movdol,
						flag_debhab
			FROM cntbl_asiento_det
			WHERE origen       = :as_origen      AND
					ano          = :ai_ano         AND
					mes          = :ai_mes         AND
					nro_libro    = :ai_libro   	 AND
					nro_asiento  = :ai_nro_asiento AND
					cod_relacion = :as_cod_rel  	 AND
					tipo_docref1 = :as_tipo_doc	 AND
					nro_docref1  = :as_nro_doc	;
									
	
		/*Abrir Cursor*/		  	
		OPEN c_detalle ;
			
		DO 				/*Recorro Cursor*/	
			FETCH c_detalle INTO :ldc_sldo_sol, :ldc_sldo_dol, :ls_flag_debhab;
			IF sqlca.sqlcode = 100 THEN EXIT
			 
			IF Isnull(ldc_sldo_sol) then ldc_sldo_sol = 0.00
			IF Isnull(ldc_sldo_dol) then ldc_sldo_dol = 0.00
			 
			//soles
			IF ls_flag_debhab = 'D' then
			 	adc_sldo_sol = adc_sldo_sol - ldc_sldo_sol
			ELSE	 
			 	adc_sldo_sol = adc_sldo_sol + ldc_sldo_sol
			END IF
			
			//dolares
			IF ls_flag_debhab = 'D' then
				adc_sldo_dol = adc_sldo_dol - ldc_sldo_dol
			ELSE	 
			 	adc_sldo_dol = adc_sldo_dol + ldc_sldo_dol
			END IF
			 
			LOOP WHILE TRUE
			
		CLOSE c_detalle ; /*Cierra Cursor*/								
	else
		// Lo busco en doc_pendientes, porque puede ser que sea un nuevo registro
		
			select sldo_sol, saldo_dol
				into :adc_sldo_sol, :adc_sldo_dol
			from doc_pendientes_cta_cte
			where cod_relacion 	= :as_cod_rel 	AND
					tipo_doc			= :as_tipo_doc AND
					nro_doc			= :as_nro_doc;
			
			if SQLCA.SQlCode = 100 then
				MessageBox('Aviso', 'Documento no se encuentra en Detalle de asiento ni en Doc Pendientes, Verifique', StopSign!)
				adc_sldo_sol = 0.00
				adc_sldo_dol = 0.00
				return false
			end if
			
			if SQLCA.SQlCode < 0 then
				MessageBox('Aviso', SQLCA.SQLErrText, StopSign!)
				adc_sldo_sol = 0.00
				adc_sldo_dol = 0.00
				return false
			end if

	end if
	
end if

adc_sldo_sol = abs(adc_sldo_sol)
adc_sldo_dol = abs(adc_sldo_dol)

return true
end function

public subroutine of_calcula_imp_liq (ref u_dw_abc adw_liq_cab, ref u_dw_abc adw_liq_det);Long ll_row, ll_row_mas
Decimal {2} ldc_monto

ll_row_mas = adw_liq_cab.GetRow()
if ll_row_mas = 0 then
	MessageBox('Aviso', 'No existe cabecera del documento, Verifique!', StopSign!)
	return
end if

ldc_monto = 0
// Calculo el total de la liquidacion y lo pongo en la cabecera
For ll_row = 1 to adw_liq_det.Rowcount()
	if adw_liq_det.object.flag_cxp[ll_row] = '+' then
		ldc_monto += dec(adw_liq_det.object.importe_liq[ll_row])
	else
		ldc_monto -= dec(adw_liq_det.object.importe_liq[ll_row])
	end if
Next

adw_liq_cab.object.monto_neto[ll_row_mas] = ldc_monto
end subroutine

public function boolean of_detracciones (string as_codrel, string as_tipo_doc, string as_nro_doc);/*documento de provision*/
Long 		ll_count, ll_ano, ll_mes, ll_nro_asiento, ll_nro_libro
string	ls_desc_prov, ls_flag_tabla, ls_flag_estado, ls_origen

select flag_tabla, flag_estado
	into :ls_flag_tabla, :ls_flag_estado
from detraccion
where nro_detraccion = :as_nro_doc;

if ls_flag_estado = '0' then
	MessageBox('Aviso', 'El comprobante de detraccion: ' + as_nro_doc &
		+ ' ya no esta activo, por favor verifique', StopSign!)
	return false
end if

choose case ls_flag_tabla
	case '3', '1'  //Cuentas por pagar, Cuentas por cobrar
		
		select cb.ano, cb.mes, cb.nro_libro, cb.nro_asiento, cb.origen
			into :ll_ano, :ll_mes, :ll_nro_libro, :ll_nro_asiento, :ls_origen
		from 	caja_bancos_det 	cbd,
				caja_bancos			cb
			
		where cb.origen 			= cbd.origen   		AND
				cb.nro_registro	= cbd.nro_registro	AND
				cbd.nro_doc 		= :as_nro_doc 			AND
				cbd.cod_relacion 	= :as_codrel			AND
				cbd.tipo_doc		= :as_tipo_doc ;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Doc. Detraccion: ' + as_nro_doc + ' no esta amarrado a caja_bancos_det, Verifique')
			return false
		end if
		
		if SQLCA.SQlCode < 0 then
			MessageBox('Aviso', SQLCA.SQLErrtext, Exclamation!)
			return false
		end if
		
end choose

SELECT 	Count(*)
	INTO 	:ll_count
FROM 	cntbl_asiento_det cd
WHERE cd.cod_relacion = :as_codrel 		  	 AND
		cd.tipo_docref1 = :as_tipo_doc  		 AND
		cd.nro_docref1  = :as_nro_doc			 AND
		cd.origen       = :ls_origen      	 AND
		cd.ano          = :ll_ano            AND
		cd.mes          = :ll_mes            AND
		cd.nro_libro    = :ll_nro_libro      AND
		cd.nro_asiento  = :ll_nro_asiento;
/**/
	

// Genero el detalle solo si existen algun registro
IF ll_count = 0 then
	select nom_proveedor
		into :ls_desc_prov
	from proveedor
	where proveedor = :as_codrel;
	
	MessageBox('Aviso', 'La detraccion: ' + as_nro_doc + 'no tiene asiento de pago ' &
				+ '~r~n Tipo Doc: ' + as_tipo_doc &
				+ '~r~n Nro Doc : ' + as_nro_doc &
				+ '~r~n Cod Relacion: ' + as_codrel + ' - ' + ls_desc_prov, &
				Exclamation!)
	return false
end if

/*Datos de la cuenta contable*/
SELECT 	cd.cnta_ctbl,
			cd.det_glosa,
			cd.flag_debhab ,
			cd.cencos   ,
			cd.cod_ctabco
	INTO 	:is_cnta_ctbl_ref,
			:is_det_glosa_ref ,
			:is_flag_debhab_ref,
			:is_cencos_ref	 ,
			:is_cod_ctabco_ref
FROM 	cntbl_asiento_det cd
WHERE cd.cod_relacion = :as_codrel 		  	 AND
		cd.tipo_docref1 = :as_tipo_doc  		 AND
		cd.nro_docref1  = :as_nro_doc			 AND
		cd.origen       = :ls_origen      	 AND
		cd.ano          = :ll_ano            AND
		cd.mes          = :ll_mes            AND
		cd.nro_libro    = :ll_nro_libro      AND
		cd.nro_asiento  = :ll_nro_asiento;


return true
end function

public function boolean of_letras_cobrar (string as_codrel, string as_tipo_doc, string as_nro_doc);/*documento de provision*/
Long 		ll_count
string	ls_desc_prov

SELECT 	Count(*)
	INTO 	:ll_count
FROM 	letras_x_cobrar lc,
		cntbl_asiento_det cd
WHERE lc.cod_relacion = :as_codrel 		  	AND
		lc.nro_letra	 = :as_nro_doc			AND
  	  	lc.origen       = cd.origen        	AND
      lc.ano          = cd.ano            AND
	   lc.mes          = cd.mes            AND
		lc.nro_libro    = cd.nro_libro      AND
		lc.nro_asiento  = cd.nro_asiento    AND
		lc.cod_relacion = cd.cod_relacion   AND
		cd.tipo_docref1 = :as_tipo_doc	   AND
		lc.nro_letra    = cd.nro_docref1 ;
/**/
			

// Genero el detalle solo si existen algun registro
IF ll_count = 0 then
	select nom_proveedor
		into :ls_desc_prov
	from proveedor
	where proveedor = :as_codrel;
	
	MessageBox('Aviso', 'El Documento no tiene asiento contable de Venta ' &
				+ '~r~n Tipo Doc: ' + as_tipo_doc &
				+ '~r~n Nro Doc : ' + as_nro_doc &
				+ '~r~n Cod Relacion: ' + as_codrel + ' - ' + ls_desc_prov, &
				Exclamation!)
				
	return false
end if

/*Datos de la cuenta contable*/
SELECT 	cd.cnta_ctbl,
			cd.det_glosa,
			cd.flag_debhab ,
			cd.cencos   ,
			cd.cod_ctabco
	INTO 	:is_cnta_ctbl_ref,
			:is_det_glosa_ref ,
			:is_flag_debhab_ref,
			:is_cencos_ref	 ,
			:is_cod_ctabco_ref
FROM 	letras_x_cobrar lc,
		cntbl_asiento_det cd
WHERE lc.cod_relacion = :as_codrel 		  	AND
		lc.nro_letra	 = :as_nro_doc			AND
  	  	lc.origen       = cd.origen        	AND
      lc.ano          = cd.ano            AND
	   lc.mes          = cd.mes            AND
		lc.nro_libro    = cd.nro_libro      AND
		lc.nro_asiento  = cd.nro_asiento    AND
		lc.cod_relacion = cd.cod_relacion   AND
		cd.tipo_docref1 = :as_tipo_doc	   AND
		lc.nro_letra    = cd.nro_docref1 ;

return true
end function

public function boolean of_letras_pagar (string as_codrel, string as_tipo_doc, string as_nro_doc);/*documento de provision*/
Long 		ll_count
string	ls_desc_prov

SELECT 	Count(*)
	INTO 	:ll_count
FROM 	letras_x_pagar lp,
		cntbl_asiento_det cd
WHERE lp.cod_relacion = :as_codrel 		  	AND
		lp.nro_letra	 = :as_nro_doc			AND
  	  	lp.origen       = cd.origen        	AND
      lp.ano          = cd.ano            AND
	   lp.mes          = cd.mes            AND
		lp.nro_libro    = cd.nro_libro      AND
		lp.nro_asiento  = cd.nro_asiento    AND
		lp.cod_relacion = cd.cod_relacion   AND
		cd.tipo_docref1 = :as_tipo_doc	   AND
		lp.nro_letra    = cd.nro_docref1 ;
/**/
			

// Genero el detalle solo si existen algun registro
IF ll_count = 0 then
	select nom_proveedor
		into :ls_desc_prov
	from proveedor
	where proveedor = :as_codrel;
	
	MessageBox('Aviso', 'El Documento no tiene asiento contable de Venta ' &
				+ '~r~n Tipo Doc: ' + as_tipo_doc &
				+ '~r~n Nro Doc : ' + as_nro_doc &
				+ '~r~n Cod Relacion: ' + as_codrel + ' - ' + ls_desc_prov, &
				Exclamation!)
				
	return false
end if

/*Datos de la cuenta contable*/
SELECT 	cd.cnta_ctbl,
			cd.det_glosa,
			cd.flag_debhab ,
			cd.cencos   ,
			cd.cod_ctabco
	INTO 	:is_cnta_ctbl_ref,
			:is_det_glosa_ref ,
			:is_flag_debhab_ref,
			:is_cencos_ref	 ,
			:is_cod_ctabco_ref
FROM 	letras_x_pagar lp,
		cntbl_asiento_det cd
WHERE lp.cod_relacion = :as_codrel 		  	AND
		lp.nro_letra	 = :as_nro_doc			AND
  	  	lp.origen       = cd.origen        	AND
      lp.ano          = cd.ano            AND
	   lp.mes          = cd.mes            AND
		lp.nro_libro    = cd.nro_libro      AND
		lp.nro_asiento  = cd.nro_asiento    AND
		lp.cod_relacion = cd.cod_relacion   AND
		cd.tipo_docref1 = :as_tipo_doc	   AND
		lp.nro_letra    = cd.nro_docref1 ;

return true
end function

on n_cst_liq_pago.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_liq_pago.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

