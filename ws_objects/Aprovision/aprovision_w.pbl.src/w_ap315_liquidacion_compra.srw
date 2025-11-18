$PBExportHeader$w_ap315_liquidacion_compra.srw
forward
global type w_ap315_liquidacion_compra from w_abc
end type
type pb_1 from picturebutton within w_ap315_liquidacion_compra
end type
type st_descripcion from statictext within w_ap315_liquidacion_compra
end type
type sle_origen from singlelineedit within w_ap315_liquidacion_compra
end type
type st_1 from statictext within w_ap315_liquidacion_compra
end type
type dw_master from u_dw_abc within w_ap315_liquidacion_compra
end type
type tab_1 from tab within w_ap315_liquidacion_compra
end type
type tabpage_1 from userobject within tab_1
end type
type dw_ctas_pag_det from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_ctas_pag_det dw_ctas_pag_det
end type
type tabpage_2 from userobject within tab_1
end type
type dw_ref_x_pagar from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_ref_x_pagar dw_ref_x_pagar
end type
type tabpage_3 from userobject within tab_1
end type
type dw_imp_x_pagar from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_imp_x_pagar dw_imp_x_pagar
end type
type tabpage_4 from userobject within tab_1
end type
type dw_totales from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_totales dw_totales
end type
type tabpage_5 from userobject within tab_1
end type
type dw_pre_asiento_cab from u_dw_abc within tabpage_5
end type
type dw_pre_asiento_det from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_pre_asiento_cab dw_pre_asiento_cab
dw_pre_asiento_det dw_pre_asiento_det
end type
type tabpage_6 from userobject within tab_1
end type
type dw_asiento_aux from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_asiento_aux dw_asiento_aux
end type
type tab_1 from tab within w_ap315_liquidacion_compra
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type gb_1 from groupbox within w_ap315_liquidacion_compra
end type
end forward

global type w_ap315_liquidacion_compra from w_abc
integer width = 4485
integer height = 2184
string title = "Liquidación de Compra (AP315)"
string menuname = "m_liquidacion_compra"
event ue_anular ( )
event ue_estado_no_def ( )
event ue_find_exact ( )
event ue_print_voucher ( )
event ue_grmp ( )
pb_1 pb_1
st_descripcion st_descripcion
sle_origen sle_origen
st_1 st_1
dw_master dw_master
tab_1 tab_1
gb_1 gb_1
end type
global w_ap315_liquidacion_compra w_ap315_liquidacion_compra

type variables
String  		is_nro_guia, is_tip_cred  //Variable de Estado de Transación del Documento
String		is_salir, is_doc_lc, is_confin_lc, is_pago_con, &
				is_desc_pago, is_doc_grmp, is_tipo_cred_fis, &
				is_matriz_cntbl, is_cencos_lc, is_doc_mov_alm, &
				is_cnta_prsp_mp, is_numero_tramite, is_irlc
				
Long 			il_dias_vencimiento, il_nro_libro

Boolean 		ib_estado_prea = TRUE //Pre Asiento No editado
				

Decimal		idc_monto_afec_lc   // Monto no afecto a  impuesto en LC

u_dw_abc  	idw_detail, idw_referencias, idw_impuesto, idw_totales, &
				idw_pre_asiento_det, idw_pre_asiento_cab, idw_asiento_aux

DataStore	ids_matriz_cntbl_det ,ids_data_glosa, ids_voucher	
					 
n_cst_asiento_contable invo_asiento_Cntbl








end variables

forward prototypes
public function string wf_verifica_user ()
public function decimal wf_totales ()
public function boolean wf_generacion_pre_aux ()
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public function integer of_get_param ()
public function boolean of_verifica_data_guia (ref string as_cod_relacion, ref decimal adc_tasa_cambio)
public function integer of_set_numera ()
protected subroutine wf_total_ref ()
public function decimal of_genera_impuesto ()
public function boolean of_get_datos_lc (string as_proveedor, long al_row)
public subroutine of_asigna_dws ()
public function boolean of_genera_asiento ()
end prototypes

event ue_anular;String  ls_flag_estado, ls_origen, ls_tipo_doc, ls_nro_doc, ls_cod_relacion
Long    ll_row, ll_row_pasiento, ll_inicio, ll_count
Integer li_opcion

dw_master.Accepttext()
ll_row = dw_master.Getrow()

IF ll_row = 0 OR is_Action = 'new' THEN 
	MessageBox("Aviso", "Debe Grabar los cambios antes de anular")
	RETURN 
end if

ls_flag_estado = dw_master.object.flag_estado[ll_row]

IF Not(ls_flag_estado = '1' OR ls_flag_estado = '0') THEN RETURN 

IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR &
	 idw_referencias.ii_update = 1 OR idw_impuesto.ii_update = 1 OR &
	 idw_pre_asiento_cab.ii_update = 1 OR idw_pre_asiento_det.ii_update = 1 OR &
	 idw_asiento_aux.ii_update = 1 ) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF

li_opcion = MessageBox('Anula Documento x Pagar','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN
ls_cod_relacion = dw_master.object.cod_relacion [ll_row]
ls_origen   	 = dw_master.object.origen       [ll_row]
ls_tipo_doc 	 = dw_master.object.tipo_doc     [ll_row]
ls_nro_doc  	 = dw_master.object.nro_doc      [ll_row]

/*Verifica Si ha tenido Transaciones*/
SELECT Count(*)
  INTO :ll_count
  FROM doc_referencias
 WHERE ((cod_relacion = :ls_cod_relacion ) AND
        (origen_ref   = :ls_origen       ) AND
 		  (tipo_ref     = :ls_tipo_doc     ) AND
		  (nro_ref	    = :ls_nro_doc      )) ;

IF ll_count > 0 THEN
	Messagebox('Aviso',"Documento Tiene " + string(ll_count) + " Transaciones Realizadas ,Verifique!")
   Return
END IF

/*Elimino Cabecera de Cntas x pagar*/
/*DO WHILE dw_master.Rowcount() > 0
	dw_master.Deleterow(0)
LOOP*/

//Anulo el documento
dw_master.object.flag_estado 	[dw_master.GetRow()] = '0'
dw_master.object.saldo_sol 	[dw_master.GetRow()] = 0
dw_master.object.saldo_dol	 	[dw_master.GetRow()] = 0

/*Elimino detalle de Cntas x pagar*/
DO WHILE idw_detail.Rowcount() > 0
	idw_detail.Deleterow(0)
	idw_detail.ii_update = 1
LOOP

/*Elimino Impuesto de Cntas Pagar*/
DO WHILE idw_impuesto.Rowcount() > 0
	idw_impuesto.Deleterow(0)
	idw_impuesto.ii_update = 1
LOOP

/*Elimino documentos de Referencias*/
DO WHILE idw_referencias.Rowcount() > 0
	idw_referencias.Deleterow(0)
	idw_referencias.ii_update = 1
LOOP

//Cabecera de Asiento
idw_pre_asiento_cab.Object.flag_estado	 [1] = '0'
idw_pre_asiento_cab.Object.tot_solhab	 [1] = 0.00
idw_pre_asiento_cab.Object.tot_dolhab	 [1] = 0.00
idw_pre_asiento_cab.Object.tot_soldeb	 [1] = 0.00
idw_pre_asiento_cab.Object.tot_doldeb   [1] = 0.00

//Detalle de Asiento
FOR ll_inicio = 1 TO idw_pre_asiento_det.Rowcount()
  	 idw_pre_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
  	 idw_pre_asiento_det.Object.imp_movdol [ll_inicio] = 0.00		
NEXT

///*Elimino documentos de Referencias*/
DO WHILE idw_asiento_aux.Rowcount() > 0
	  idw_asiento_aux.Deleterow(0)
	  idw_asiento_aux.ii_update = 1
LOOP

is_Action = 'anular'

//* Inicialización de Variables de Modificación de Data *//
dw_master.ii_update  			= 1
idw_detail.ii_update 		= 1
idw_referencias.ii_update  	= 1
idw_impuesto.ii_update  		= 1
idw_pre_asiento_cab.ii_update = 1
idw_pre_asiento_det.ii_update = 1
idw_asiento_aux.ii_update     = 1

ib_estado_prea = TRUE   //Autogeneración de Pre Asientos

idw_pre_asiento_det.ii_protect = 0
idw_pre_asiento_det.of_protect()


end event

event ue_estado_no_def();dw_master.ii_update 				= 0
idw_detail.ii_update 		= 0
idw_referencias.ii_update  	= 0
idw_impuesto.ii_update  		= 0
idw_pre_asiento_cab.ii_update = 0
idw_pre_asiento_det.ii_update = 0
idw_asiento_aux.ii_update     = 0
end event

event ue_find_exact();// Asigna valores a structura 
String ls_tipo_doc, ls_nro_doc, ls_origen, ls_cod_relacion
Long   ll_row_master, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento, ll_inicio
str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_ctas_x_pagar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 2 //cuentas x pagar
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	ll_row_master = dw_master.getrow()
	ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]	//Codigo de Relación
	ls_tipo_doc  	 = dw_master.object.tipo_doc		[ll_row_master]
	ls_nro_doc   	 = dw_master.object.nro_doc		[ll_row_master]
	ls_origen	 	 = dw_master.object.origen			[ll_row_master] 
	ll_ano		 	 = dw_master.object.ano          [ll_row_master]
	ll_mes		 	 = dw_master.object.mes          [ll_row_master]
	ll_nro_libro 	 = dw_master.object.nro_libro    [ll_row_master]
	ll_nro_asiento  = dw_master.object.nro_asiento  [ll_row_master]

	idw_detail.Retrieve(ls_cod_relacion, ls_tipo_doc, ls_nro_doc)
	idw_referencias.Retrieve(ls_tipo_doc, ls_nro_doc, ls_cod_relacion)
	idw_impuesto.Retrieve(ls_cod_relacion, ls_tipo_doc, ls_nro_doc)
	idw_pre_asiento_cab.Retrieve(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)
	idw_pre_asiento_det.Retrieve(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)
	idw_asiento_aux.Retrieve(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)	
	
	//**//
	IF idw_referencias.Rowcount() > 0 THEN
		FOR ll_inicio = 1 TO idw_detail.Rowcount()
			 idw_detail.object.flag_hab [ll_inicio] = '1'
		NEXT
	END IF	
	//**//
	
	ib_estado_prea = False   //asiento editado					
	TriggerEvent('ue_modify')
	is_Action = 'fileopen'	
ELSE
	dw_master.Reset()
	idw_detail.Reset()
	idw_referencias.Reset()
	idw_impuesto.Reset()
	idw_pre_asiento_cab.Reset()
	idw_pre_asiento_det.Reset()
	idw_asiento_aux.Reset()
	ib_estado_prea = False   //asiento editado		
END IF





	


end event

event ue_print_voucher();String ls_origen
Long   ll_year, ll_mes, ll_nro_libro, ll_nro_asiento

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_origen 		= dw_master.object.origen 	    [dw_master.getrow()]
ll_year			= dw_master.object.ano	  	    [dw_master.getrow()]
ll_mes			= dw_master.object.mes	  	    [dw_master.getrow()]
ll_nro_libro	= dw_master.object.nro_libro   [dw_master.getrow()]
ll_nro_asiento	= dw_master.object.nro_asiento [dw_master.getrow()]


ids_voucher.retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento, gs_empresa)

ids_voucher.Object.p_logo.filename = gs_logo

if ids_voucher.rowcount() = 0 then 
	messagebox('Aviso','Voucher no tiene registro Verifique')
	return
end if


ids_voucher.Print(True)

end event

event ue_grmp();String        ls_tipo_ref ,ls_cod_cliente, ls_origen, ls_mensaje
Decimal {2}   ldc_total
Decimal {3}   ldc_tasa_cambio
str_parametros sl_param

IF of_verifica_data_guia (ls_cod_cliente, ldc_tasa_cambio) = FALSE THEN RETURN

IF idw_referencias.Rowcount() > 0 THEN
	/*Recuperacion de Tipo doc Guia de Recepcion de Materia Prima*/
	IF Isnull(is_doc_grmp) OR Trim(is_doc_grmp) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Guia de Remision en Tabla de Parametros APPARAM, Comuniquese Con Sistemas!')
		Return		
	END IF
ELSE
	SetNull(is_nro_guia)
END IF

ls_origen = sle_origen.text

IF Isnull(ls_origen) OR Trim(ls_origen) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un Codigo de Origen')
		RETURN		
END IF

//Actualizar el monto facturado de las GRMP cuya LC este anulada o eliminada
update ap_guia_recepcion_det ap
   set ap.monto_facturado = 0
 where ap.cod_guia_rec in (select gd.cod_guia_rec
                            from ap_guia_recepcion_det gd
                            where gd.monto_facturado <> 0
                            minus
                            select distinct cpd.nro_ref
                            from cntas_pagar cp,
                                 cntas_pagar_det cpd
                            where cp.cod_relacion = cpd.cod_relacion
                              and cp.tipo_doc     = cpd.tipo_doc
                              and cp.nro_doc      = cpd.nro_doc
                              and cp.tipo_doc     like 'LC%'
                              and cpd.tipo_ref is not null);
If SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al momento de actualizar GRMP', ls_mensaje)
	return 
end if

commit;

sl_param.tipo		 = '1'
sl_param.opcion	 =  2        //Guia de recepcion de Materia Prima
sl_param.titulo 	 = 'Selección de Guias de Recepcón de Materia Prima'
sl_param.dw_master = 'd_guias_recepcion_pendientes_liq_tbl'
sl_param.dw1		 = 'd_detalle_guia_pendientes_liq_tbl'
sl_param.dw_m		 = dw_master
sl_param.dw_d		 = idw_detail
sl_param.dw_c		 = idw_referencias
sl_param.string1	 = ls_cod_cliente
sl_param.string2	 = is_doc_grmp
sl_param.string3   = is_doc_mov_alm
sl_param.string4	 = ls_origen
sl_param.db1		 = ldc_tasa_cambio

dw_master.Accepttext()

//is_flag_guia = 'S' // Para indicar que se ingresaran Guias de Recepcion de Materia Prima
OpenWithParm( w_abc_seleccion_md, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.titulo = 's' THEN

//	wf_doc_anticipos () 
	of_genera_impuesto()
	wf_total_ref ()
	
	ldc_total = wf_totales ()
	dw_master.object.importe_doc [1] = ldc_total
	dw_master.ii_update = 1
END IF

end event

public function string wf_verifica_user ();String ls_doc_cxp,ls_mensaje = ''
Long   ll_count

/**/
SELECT doc_cxp
  INTO :ls_doc_cxp
  FROM finparam
 WHERE reckey = '1' ;

IF Isnull(ls_doc_cxp) OR Trim(ls_doc_cxp) = '' THEN
	ls_mensaje = 'Debe Ingresar Grupo de Documento de Cuentas Por Pagar en Archivo de Parametros'
	Return ls_mensaje	
END IF

/**************/	
SELECT Count(*)
  INTO :ll_count
  FROM doc_grupo_relacion
 WHERE (doc_grupo_relacion.grupo = :ls_doc_cxp ) ;


 IF ll_count = 0 THEN
	 ls_mensaje = 'Grupo de Cuentas x Pagar No esta Definido en Tabla doc_grupo_relacion'
	 Return ls_mensaje	 	
 END IF
 
 
 Return ls_mensaje

  
         

end function

public function decimal wf_totales ();Long 	  ll_inicio
String  ls_signo
Decimal {2} ldc_impuesto        = 0.00, ldc_total_imp     = 0.00 ,ldc_bruto = 0.00 , &
		      ldc_total_bruto     = 0.00, ldc_total_general = 0.00,	ldc_impto = 0.00


idw_totales.Reset()
idw_totales.Insertrow(0)

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 ldc_bruto 		= Round(idw_detail.object.total [ll_inicio],2)
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
NEXT

// Llamar a la función para calcular el impuesto
//ldc_impto = of_genera_impuesto(ldc_total_bruto)
// 

FOR ll_inicio = 1 TO idw_impuesto.Rowcount()
	 ldc_impuesto = idw_impuesto.Object.importe [ll_inicio]
	 ls_signo	  = idw_impuesto.Object.signo   [ll_inicio]	
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
	 IF     ls_signo = '+' THEN
		 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT

tab_1.tabpage_4.dw_totales.object.bruto 	 [1] = ldc_total_bruto
tab_1.tabpage_4.dw_totales.object.impuesto [1] = ldc_total_imp

ldc_total_general = ldc_total_bruto + ldc_total_imp

Return ldc_total_general

end function

public function boolean wf_generacion_pre_aux ();Long    ll_inicio,ll_row,ll_count = 0,ll_nro_libro,ll_nro_asiento,&
		  ll_row_master,ll_ano,ll_mes
String  ls_cencos,ls_flag_presup,ls_origen
Integer li_item
Boolean lb_retorno = TRUE

DO WHILE idw_asiento_aux.rowcount() > 0
	idw_asiento_aux.deleterow(0)
LOOP

///***************************///
IF is_Action = 'fileopen' THEN
	/**Recuperació de Datos de Cabecera**/
	ll_row_master  = dw_master.GetRow()
	ls_origen		= dw_master.Object.origen		 [ll_row_master]
	ll_ano			= dw_master.Object.ano			 [ll_row_master]
	ll_mes			= dw_master.Object.mes			 [ll_row_master]
	ll_nro_libro	= dw_master.Object.nro_libro	 [ll_row_master]
	ll_nro_asiento = dw_master.object.nro_asiento [ll_row_master]
	
	SELECT Count(*)
	  INTO :ll_count
	  FROM cntbl_asiento_det_aux
	 WHERE ((origen    	= :ls_origen    	) AND
	 		  (ano			= :ll_ano			) AND
			  (mes			= :ll_mes			) AND
	 		  (nro_libro 	= :ll_nro_libro 	) AND
			  (nro_asiento = :ll_nro_asiento )) ;

	IF ll_count > 0 THEN
		/**Actualiza Proceso de Eliminación de Pre Asientos Auxiliares*/
   	IF idw_asiento_aux.Update() = -1 THEN
			Messagebox('Aviso','Fallo Autogeneración de Asientos Auxiliares ,Comuniquese Con Sistemas')
			lb_retorno = FALSE
			GOTO SALIDA
		END IF
	END IF
	
END IF			  




/*Verificación de Pre - Asientos Generados**/
FOR ll_inicio = 1 TO idw_pre_asiento_det.Rowcount()
	 li_item   = idw_pre_asiento_det.object.item   [ll_inicio]
	 ls_cencos = idw_pre_asiento_det.object.cencos [ll_inicio]
	 
	 IF Not(Isnull(ls_cencos) OR Trim(ls_cencos) = '') THEN
		/**Verificación de Flag Presupuestal de Centro de Costo**/
		SELECT flag_cta_presup
		  INTO :ls_flag_presup 
		  FROM centros_costo
		 WHERE (cencos = :ls_cencos) ;
		
		 
		IF ls_flag_presup = '1' THEN
			ll_row = idw_asiento_aux.InsertRow(0)
			idw_asiento_aux.object.item [ll_row] = li_item
			idw_asiento_aux.ii_update = 1
		END IF
		/**/
	 END IF

NEXT

SALIDA:

Return lb_retorno



end function

public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_tip_ref,ls_nro_ref,&
		  ls_flag_tip_ref	,ls_flag_cbef
Boolean lb_retorno = TRUE


IF f_cntbl_cnta(as_cta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref, &
					 ls_flag_cod_rel,ls_flag_cbef)  THEN


	IF ls_flag_ctabco = '1' THEN
		Messagebox('Aviso','Campo No Ha Sido Definido , Cuenta de Banco')
	   lb_retorno = FALSE	
		GOTO SALIDA
	END IF


	IF ls_flag_cod_rel = '1' THEN
		tab_1.tabpage_5.dw_pre_asiento_det.object.cod_relacion [al_row] = as_cod_relacion
	ELSE
		SetNull(as_cod_relacion)
		tab_1.tabpage_5.dw_pre_asiento_det.object.cod_relacion [al_row] = as_cod_relacion
	END IF	

ELSE
   lb_retorno = FALSE
END IF

//**/
SALIDA:

Return lb_retorno
end function

public function integer of_get_param ();//Carga los parametros definidos en ap_param

SELECT  A.DOC_LC,  A.CONFIN_LC,   B.NRO_LIBRO,   A.DOC_GUIA_MP,  
		  B.TIPO_CRED_FISCAL, A.CENCOS_LC, A.CNTA_PRSP_MP, 
		  A.MTO_INAFEC_IMP, a.IMPUESTO_LC
  INTO :is_doc_lc, :is_confin_lc, :il_nro_libro, :is_doc_grmp,  
  		 :is_tipo_cred_fis, :is_cencos_lc,  :is_cnta_prsp_mp, 
		 :idc_monto_afec_lc, :is_irlc
FROM AP_PARAM  A ,
     DOC_TIPO  B
WHERE ORIGEN = 'XX'
  AND A.DOC_LC = B.TIPO_DOC (+);

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros en AP_Param")
	return 0
END IF

IF IsNull(is_confin_lc) or is_confin_lc = "" THEN
	Messagebox( "Error", "No se ha especificado confin para LC en AP_PARAM")
	return 0
END IF

IF IsNull(is_irlc) or is_irlc = "" THEN
	Messagebox( "Error", "No se ha especificado Impuesto IRLC para LC en AP_PARAM")
	return 0
END IF

// Carga parametros de pago contado y su descripcion
SELECT F.PAGO_CONTADO, B.DESC_FORMA_PAGO
  INTO :is_pago_con, :is_desc_pago
FROM finparam   F,
     FORMA_PAGO B
WHERE f.RECKEY = '1'
  AND f.PAGO_CONTADO = B.FORMA_PAGO;

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros de PCON EN FL_PARAM")
	return 0
END IF

//Carga la matriz contable para el confin de la LC
SELECT MATRIZ_CNTBL
 INTO :is_matriz_cntbl
 FROM concepto_financiero
WHERE confin = :is_confin_lc
  AND flag_estado = '1';

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No Matriz Contable para el confin : " + is_confin_lc)
	return 0
END IF

//Parametro de tipo de documento movimiento de Almacen
SELECT doc_mov_almacen
 INTO  :is_doc_mov_alm
FROM logparam
WHERE reckey = '1';

IF Isnull(is_doc_mov_alm) OR Trim(is_doc_mov_alm) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Movimiento de Almacen en Tabla de Parametros LOGPARAM, Comuniquese Con Sistemas!')
	RETURN 0
END IF
//

RETURN 1
end function

public function boolean of_verifica_data_guia (ref string as_cod_relacion, ref decimal adc_tasa_cambio);/*******************************************************/
/*Funcion de Ventana creada con el fin de Verificar    */
/*que Proveedor ,Moneda ,Tasa Cambio esten Ingresados  */
/*y Estado Este Activo para poder Invocar un Documento */
/*******************************************************/

Boolean lb_ret = TRUE
Long 	  ll_row
String  ls_flag_estado, ls_moneda, ls_serie


ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN FALSE

as_cod_relacion = dw_master.Object.cod_relacion [ll_row] 
adc_tasa_cambio =	dw_master.Object.tasa_cambio  [ll_row]
ls_flag_estado	 = dw_master.Object.flag_estado  [ll_row]
ls_moneda		 = dw_master.Object.cod_moneda	[ll_row]
ls_serie			 = dw_master.Object.serie			[ll_row]


IF ls_flag_estado <> '1' THEN RETURN FALSE

IF tab_1.tabpage_1.dw_ctas_pag_det.Rowcount() > 0 AND tab_1.tabpage_2.dw_ref_x_pagar.rowcount () = 0 THEN
	Messagebox ('Aviso','No Puede Seleccionar Documentos , Por Haber Ingresados Registros Sin Referencia , Verifique!')
	Return FALSE
END IF
	
IF Isnull(as_cod_relacion) OR Trim(as_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Proveedor')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')			
	Return FALSE		
END IF

IF Isnull(adc_tasa_cambio) OR adc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')	
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')	
	Return FALSE	
END IF

IF IsNull(ls_moneda) OR TRIM(ls_moneda) = '' THEN
	Messagebox('Aviso', 'Debe ingresar una moneda')
	dw_master.Setfocus( )
	dw_master.Setcolumn('cod_moneda')
	RETURN False
END IF

IF IsNull(ls_serie) OR TRIM(ls_serie) = '' THEN
	Messagebox('Aviso', 'Debe ingresar una serie para el documento')
	dw_master.Setfocus()
	dw_master.setcolumn('serie')
	RETURN FALSE
END IF

Return lb_ret
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_mensaje, ls_serie, ls_nro_doc

IF dw_master.getrow() = 0 THEN RETURN 0

ls_serie 	= dw_master.object.serie	[dw_master.getrow()]
ls_nro_doc 	= dw_master.object.nro_doc	[dw_master.getrow()]

IF is_Action = 'new' or (IsNull(ls_nro_doc) or trim(ls_nro_doc) = '') THEN
	SELECT count(*)
	  INTO :ll_count
	FROM NUM_DOC_TIPO
	WHERE TIPO_DOC = :is_doc_lc
	AND NRO_SERIE 	= :ls_serie;
	
	IF ll_count = 0 THEN
		ROLLBACK;
		MEssageBox('Error', 'No existe numeracion para la serie: ' + ls_serie + '. Por favor verifique!', StopSign!)
		return 0
	END IF
		
	SELECT ULTIMO_NUMERO
	  INTO :ll_ult_nro
	FROM NUM_DOC_TIPO
	WHERE TIPO_DOC = :is_doc_lc
	AND   NRO_SERIE = :ls_serie for update;
	
	UPDATE NUM_DOC_TIPO
		SET ultimo_numero = ultimo_numero + 1
	WHERE TIPO_DOC = :is_doc_lc
	AND NRO_SERIE = :ls_serie;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'Ha ocurrido un error al num_doc_tipo. Mensaje: ' + ls_mensaje)
		RETURN 0
	END IF
	
	ls_next_nro = gnvo_app.utilitario.lpad(ls_serie, 4, '0') + '-' +  gnvo_app.utilitario.lpad(trim(string(ll_ult_nro)), 5, '0')
	
	IF LEN(ls_next_nro) < 10 THEN
		Messagebox('Aviso', 'Se ha generado el numero de Liquidacion de Compra: ' + ls_next_nro + ', que tiene una longitud menor a 10 caracteres, revisar la serie ' + ls_serie + ' del documento', StopSign!)
		RETURN 0
	END IF
	
	dw_master.object.nro_doc[dw_master.getrow()] = ls_next_nro
	
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_doc[dw_master.getrow()] 
end if

// Asigna numero a detalle cntas_pagar
FOR ll_i = 1 TO idw_detail.RowCount()
	idw_detail.object.nro_doc			[ll_i] = ls_next_nro
//	idw_detail.Object.guia_nro_doc_cxp[ll_i] = ls_next_nro
NEXT

// Asigna numero a detalle referencias
FOR ll_i = 1 TO idw_referencias.RowCount()
	idw_referencias.object.nro_doc[ll_i] = ls_next_nro
NEXT

// Asigna numero a detalle impuestos
FOR ll_i = 1 TO idw_impuesto.RowCount()
	idw_impuesto.object.nro_doc[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

protected subroutine wf_total_ref ();// Totales por documentos de referencia
String      ls_moneda_master, ls_moneda_ref, ls_soles,ls_dolares, &
				ls_nro_guia, ls_tipo_doc_guia, ls_nro_ref, ls_nro_doc_cxp, &
				ls_doc_mov_alm, ls_expresion
Long        ll_row_master , ll_j, ll_row_ref, ll_nro_item, ll_found
Decimal {3} ldc_tasa_cambio, ldc_importe, ldc_monto_soles, ldc_total
Datetime		ldt_fecha

u_dw_abc ldw_referencias, ldw_cntas_pagar

f_monedas(ls_soles, ls_dolares)

ldc_importe = 0.00

ldw_referencias = tab_1.tabpage_2.dw_ref_x_pagar
ldw_cntas_pagar = tab_1.tabpage_1.dw_ctas_pag_det

IF ldw_cntas_pagar.Rowcount( ) = 0 THEN RETURN
IF ldw_referencias.ROwcount( ) = 0 THEN RETURN

ls_tipo_doc_guia = ldw_cntas_pagar.object.tipo_ref[1]

IF ls_tipo_doc_guia <> is_doc_grmp THEN RETURN

SELECT doc_mov_almacen
 INTO  :ls_doc_mov_alm
FROM 	 logparam
WHERE  reckey = '1';

IF ldw_referencias.Rowcount() > 0 THEN
	ll_row_ref	     = ldw_referencias.Getrow()
	ls_moneda_ref	  = ldw_referencias.object.cod_moneda_det	[ll_row_ref]
	ll_row_master    = dw_master.Getrow()
	ls_moneda_master = dw_master.object.cod_moneda     [ll_row_master]
	ldc_tasa_cambio  = dw_master.object.tasa_cambio    [ll_row_master]
	ldt_fecha		  = dw_master.object.fecha_registro	[ll_row_master]
	
	//Limpiamos el importe del dw_referencias
	FOR ll_j = 1 TO ldw_referencias.Rowcount( )
		ldw_referencias.Object.importe[ll_j] = 0.00
	NEXT
	
	FOR ll_j = 1 TO ldw_cntas_pagar.rowcount( )	// Recorremos el dw, dw_cntas_pagar
		ls_nro_doc_cxp =  ldw_cntas_pagar.Object.nro_ref[ll_j]
		ll_nro_item		=	ldw_cntas_pagar.Object.item_ref[ll_j]
		// Obtenemos el nro de vale de referencia para la GRMP			
		SELECT NRO_VALE
		  INTO :ls_nro_ref
		FROM ARTICULO_MOV           A,
			  AP_GUIA_RECEPCION_DET  B
		WHERE A.COD_ORIGEN = B.ORIGEN_MOV
		  AND A.NRO_MOV    = B.NRO_MOV
		  AND B.COD_GUIA_REC = :ls_nro_doc_cxp
		  AND B.ITEM         = :ll_nro_item;
		
		ls_expresion = " tipo_ref = '" + ls_doc_mov_alm + "' AND nro_ref = '" + ls_nro_ref + "'"
		ll_found		 = ldw_referencias.find(ls_expresion, 1 , ldw_referencias.rowcount( ))
		
		IF ll_found > 0 THEN 
//			IF ls_moneda_master = ls_moneda_ref THEN
			ldc_importe = ldw_cntas_pagar.object.importe[ll_j]
//			ELSEIF ls_moneda_ref = ls_soles		THEN
//				ldc_importe = Round(ldw_cntas_pagar.object.importe[ll_j] * ldc_tasa_cambio,2)
//			ELSEIF ls_moneda_ref = ls_dolares	THEN
//				ldc_importe = Round(ldw_cntas_pagar.object.importe[ll_j] / ldc_tasa_cambio,2)
//			END IF
		   
			SELECT usf_fl_conv_mon(:ldc_importe, :ls_moneda_ref, :ls_moneda_master, :ldt_fecha)
				INTO :ldc_total
			FROM dual;
			
			ldc_total = ldc_total + ldw_referencias.object.importe [ll_found]
			
			ldw_referencias.object.importe [ll_found] = ldc_total
			
		END IF
	NEXT		
	ldw_referencias.ii_update =1	                
END IF    

//// Totales por documentos de referencia
//String      ls_moneda_master, ls_moneda_ref,ls_soles,ls_dolares, ls_origen_guia, &
//				ls_nro_guia, ls_tipo_ref
//Long        ll_row_master , ll_row_ref, ll_count, ll_i, ll_count_cp, ll_j
//Decimal {3} ldc_tasa_cambio, ldc_importe, ldc_monto_soles
//
//f_monedas(ls_soles, ls_dolares)
//
//ldc_importe = 0.00
//
//IF idw_referencias.Rowcount() > 0 THEN
//	ll_count 		  = idw_referencias.Rowcount( )
//	ll_row_ref	     = idw_referencias.Getrow()
//	ls_moneda_ref	  = idw_referencias.object.cod_moneda_det	[ll_row_ref]
//	ll_row_master    = dw_master.Getrow()
//	ls_moneda_master = dw_master.object.cod_moneda  [ll_row_master]
//	ldc_tasa_cambio  = dw_master.object.tasa_cambio [ll_row_master]
//	ll_count_cp		  = idw_detail.rowcount( )
//	
//	FOR ll_i = 1 TO ll_count    //Recorremos el dw Referencias
//		FOR ll_j = 1 TO ll_count_cp	// Recorremos el dw, idw_detail
//			IF     idw_referencias.object.origen_ref[ll_i] = idw_detail.object.origen_guia [ll_j]  &
//			   AND idw_referencias.object.tipo_ref  [ll_i] = idw_detail.object.tipo_ref	   [ll_j]  &
//			   AND idw_referencias.object.nro_ref 	 [ll_i] = idw_detail.object.cod_guia_rec[ll_j] &
//			THEN 
//				ldc_importe = ldc_importe + idw_detail.object.importe[ll_j]
//		   END IF
//		NEXT	
//		
//		IF ls_moneda_master = ls_moneda_ref THEN
//			idw_referencias.object.importe[ll_i] = Round(ldc_importe,2)	
//		ELSEIF ls_moneda_ref = ls_soles		THEN
//			idw_referencias.object.importe[ll_i] = Round(ldc_importe,2)
//		ELSEIF ls_moneda_ref = ls_dolares	THEN
//			idw_referencias.object.importe[ll_i] = Round(ldc_importe / ldc_tasa_cambio,2)
//		END IF
//		ldc_importe = 0.00
//	NEXT		
//	idw_referencias.ii_update =1	                
//END IF    

end subroutine

public function decimal of_genera_impuesto ();String	ls_signo, ls_cnta_cntbl, ls_flag_dh_cxp, &
			ls_desc_cnta, ls_moneda_lc, ls_desc_impuesto
Decimal 	ldc_total_impuesto, ldc_tasa_impuesto, ldc_mont_sol
Integer	li_row
Datetime	ldt_fecha

Long 	  ll_inicio
Decimal ldc_bruto = 0


idw_totales.Reset()
idw_totales.Insertrow(0)
//Inserto el impuesto de acuerdo al monto afecto
ldt_fecha	 = dw_master.object.fecha_registro	[dw_master.Getrow()]   // Fecha para TC.
ls_moneda_lc = dw_master.object.cod_moneda		[dw_master.Getrow()]

//Eliminamos todos los impuestos
do while idw_impuesto.RowCount() > 0 
	idw_impuesto.DeleteRow(0)
loop

/*Busqueda de Impuesto Pre Definido en AP_PARAM*/
ldc_total_impuesto = 0

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 ldc_bruto 		= Dec(idw_detail.object.importe [ll_inicio])
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 
	 //Convierte el monto total en soles
	SELECT usf_fl_conv_mon(:ldc_bruto, :ls_moneda_lc, :gnvo_app.is_soles, :ldt_fecha)
	  INTO :ldc_mont_sol
	FROM   dual;

	IF ldc_mont_sol > idc_monto_afec_lc THEN
		li_row = idw_impuesto.event ue_insert()
		if li_row > 0 then
			idw_impuesto.object.item [li_row] = Long(idw_detail.object.item[ll_inicio])
			/*Tasa Impuesto Pre Definido*/
			SELECT it.desc_impuesto, it.tasa_impuesto, it.signo, it.cnta_ctbl, it.flag_dh_cxp, cc.desc_cnta
			  INTO :ls_desc_impuesto, :ldc_tasa_impuesto, :ls_signo, :ls_cnta_cntbl, :ls_flag_dh_cxp, :ls_desc_cnta
			  FROM impuestos_tipo it,
					 cntbl_cnta		 cc
			 WHERE it.cnta_ctbl		 = cc.cnta_ctbl (+)
			   AND it.tipo_impuesto = :is_irlc;
				
			idw_impuesto.object.tipo_impuesto [li_row] = is_irlc
			idw_impuesto.object.desc_impuesto [li_row] = ls_desc_impuesto
			idw_impuesto.object.tasa_impuesto [li_row] = ldc_tasa_impuesto 	
			idw_impuesto.object.cnta_ctbl	    [li_row] = ls_cnta_cntbl
			idw_impuesto.object.desc_cnta     [li_row] = ls_desc_cnta
			idw_impuesto.object.signo		    [li_row] = ls_signo
			idw_impuesto.object.flag_dh_cxp   [li_row] = ls_flag_dh_cxp
			idw_impuesto.object.importe 		 [li_row] = Round(ldc_bruto * ldc_tasa_impuesto / 100 ,2)
			
			idw_impuesto.ii_update = 1
			
			//Añado el impuesto
			ldc_total_impuesto += Round(ldc_bruto * ldc_tasa_impuesto / 100 ,2)
		end if
	END IF

NEXT




RETURN ldc_total_impuesto
end function

public function boolean of_get_datos_lc (string as_proveedor, long al_row);Long		ll_count
string	ls_lc_nombre, ls_dni_nombre, ls_flag_datos_lc

select count(*)
	into :ll_count
from ap_proveedor_mp
where proveedor = :as_proveedor;

if ll_Count = 0 then return true

select flag_datos_lc, dni_lc_benef, lc_a_nombre
	into :ls_flag_datos_lc, :ls_dni_nombre, :ls_lc_nombre
from ap_proveedor_mp
where proveedor = :as_proveedor;

if ls_flag_datos_lc = '1' then
	dw_master.object.nom_proveedor [dw_master.getRow()] = ls_lc_nombre
	dw_master.object.nro_doc_ident [dw_master.getRow()] = ls_dni_nombre
end if


return true
end function

public subroutine of_asigna_dws ();idw_detail  	  = tab_1.tabpage_1.dw_ctas_pag_det
idw_referencias 	  = tab_1.tabpage_2.dw_ref_x_pagar
idw_impuesto	 	  = tab_1.tabpage_3.dw_imp_x_pagar
idw_totales		 	  = tab_1.tabpage_4.dw_totales
idw_pre_asiento_cab = tab_1.tabpage_5.dw_pre_asiento_cab
idw_pre_asiento_det = tab_1.tabpage_5.dw_pre_asiento_det
idw_asiento_aux	  = tab_1.tabpage_6.dw_asiento_aux

end subroutine

public function boolean of_genera_asiento ();Long    ll_row,ll_count
String  ls_moneda,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_campo_formula,&
		  ls_cencos,ls_cebef
Decimal ldc_tasa_cambio
Boolean lb_retorno

ll_row   = dw_master.Getrow()

dw_master.Accepttext()
idw_detail.Accepttext()
idw_impuesto.Accepttext()


//*Limpia DataStore*//
ids_matriz_cntbl_det.Reset()

IF ll_row   = 0 THEN RETURN FALSE

ls_moneda 		 = dw_master.object.cod_moneda  [ll_row]
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row]

IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	dw_master.SetFocus()
	dw_master.Setcolumn('cod_moneda')
	Return FALSE
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	dw_master.SetFocus()
	dw_master.Setcolumn('tasa_cambio')
	Return FALSE
END IF

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_processing( idw_detail ) <> true then	
	tab_1.SelectTab(1)
END IF

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_processing( idw_impuesto ) <> true then	
	tab_1.SelectTab(2)
END IF

ls_tipo_doc 	  = dw_master.object.tipo_doc     [ll_row]
ls_nro_doc  	  = dw_master.object.nro_doc	    [ll_row]  
ls_cod_relacion  = dw_master.object.cod_relacion [ll_row]
ls_campo_formula = 'tipo_impuesto'
///**/

lb_retorno  = invo_asiento_cntbl.of_generar_asiento_cxp_cxc (dw_master, &
																				 idw_detail, &
																				 idw_referencias, &
																				 idw_impuesto, &
																				 idw_pre_asiento_cab, &
																				 idw_pre_asiento_det, &
																				 tab_1, &
																				 'P' )

IF lb_retorno = TRUE THEN
	idw_pre_asiento_det.ii_update = 1
	idw_pre_asiento_det.SetSort('item a,cnta_ctbl a')
	/**Generación de Pre Asientos Auxiliares**/
	//wf_generacion_pre_aux ()
	/****/
END IF


Return lb_retorno
end function

on w_ap315_liquidacion_compra.create
int iCurrent
call super::create
if this.MenuName = "m_liquidacion_compra" then this.MenuID = create m_liquidacion_compra
this.pb_1=create pb_1
this.st_descripcion=create st_descripcion
this.sle_origen=create sle_origen
this.st_1=create st_1
this.dw_master=create dw_master
this.tab_1=create tab_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.st_descripcion
this.Control[iCurrent+3]=this.sle_origen
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_ap315_liquidacion_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.st_descripcion)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.tab_1)
destroy(this.gb_1)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_ctas_pag_det.width     = tab_1.tabpage_1.width   - tab_1.tabpage_1.dw_ctas_pag_det.x - 10
tab_1.tabpage_1.dw_ctas_pag_det.height    = tab_1.tabpage_1.height  - tab_1.tabpage_1.dw_ctas_pag_det.y - 10

tab_1.tabpage_2.dw_ref_x_pagar.height     = tab_1.tabpage_2.height  - tab_1.tabpage_2.dw_ref_x_pagar.y  - 10

tab_1.tabpage_3.dw_imp_x_pagar.height     = tab_1.tabpage_3.height - tab_1.tabpage_3.dw_imp_x_pagar.y  - 10

tab_1.tabpage_4.dw_totales.width     		= tab_1.tabpage_4.width   - tab_1.tabpage_4.dw_totales.x - 10
tab_1.tabpage_4.dw_totales.height         = tab_1.tabpage_4.height  - tab_1.tabpage_4.dw_totales.y - 10

tab_1.tabpage_5.dw_pre_asiento_det.width  = tab_1.tabpage_5.width   - tab_1.tabpage_5.dw_pre_asiento_det.x - 10
tab_1.tabpage_5.dw_pre_asiento_det.height = tab_1.tabpage_5.height  - tab_1.tabpage_5.dw_pre_asiento_det.y - 10

tab_1.tabpage_6.dw_asiento_aux.height     = tab_1.tabpage_6.height  - tab_1.tabpage_6.dw_asiento_aux.y     - 10
end event

event ue_open_pre;call super::ue_open_pre;String 	ls_mensaje
Integer	li_count

is_salir = ''
of_asigna_dws()

//Verifico que se cargen los parametros en variables de instancia
IF of_get_param() = 0 THEN
   is_salir = 'S'
	post event closequery()   
	RETURN
END IF

// Verifico que el usuario tenga numeros de serie asiganadas a la LC
SELECT COUNT(*)
 INTO  :li_count
FROM   DOC_TIPO_USUARIO
WHERE  COD_USR   = :gs_user
AND    TIPO_DOC  = :is_doc_lc
AND    NRO_SERIE IS NOT NULL;

IF li_count = 0 OR IsNull(li_count) THEN
	is_salir  = 'A'
	post event closequery()
	RETURN
END IF

// Asigna el origen del usuario para las referencias
sle_origen.text = gs_origen
sle_origen.Event modified()

// asignar dw corriente variables de instancia tipo dw
idw_1 			 	  = dw_master  

// Relacionar los dw con la base de datos
dw_master.SetTransObject			 (sqlca)  	
idw_detail.SettransObject	 (sqlca)
idw_referencias.SettransObject	 (sqlca)
idw_impuesto.SettransObject		 (sqlca)
idw_pre_asiento_cab.SettransObject(sqlca)
idw_pre_asiento_det.SettransObject(sqlca)
idw_asiento_aux.SettransObject	 (sqlca)

//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)

//** Datastore de Glosa **//
ids_data_glosa = Create Datastore
ids_data_glosa.DataObject = 'd_data_glosa_grd'
ids_data_glosa.SettransObject(sqlca)

//** Datastore Voucher **//
ids_voucher = Create Datastore
ids_voucher.DataObject = 'd_rpt_voucher_imp_cp_tbl'
ids_voucher.SettransObject(sqlca)

ls_mensaje = wf_verifica_user ()

IF Not(Isnull(ls_mensaje) OR Trim(ls_mensaje) = '' ) THEN
	Messagebox('Aviso',ls_mensaje)
END IF

idw_detail.BorderStyle = StyleRaised!	// indicar dw_detail como no activado

of_position_window(0,0)       					// Posicionar la ventana en forma fija

//Crear Objeto
invo_asiento_cntbl = create n_cst_asiento_contable


// Para grabar el log diario
ib_log = TRUE



end event

event ue_insert;call super::ue_insert;String  ls_flag_estado,ls_result,ls_mensaje
Long    ll_row,ll_currow,ll_ano,ll_mes
Boolean lb_result

ll_row = dw_master.Getrow()

CHOOSE CASE idw_1
	 CASE dw_master
			TriggerEvent('ue_update_request')
			SetNull(is_tip_cred)
			idw_1.Reset()
			idw_detail.Reset()
			idw_referencias.Reset()
			idw_impuesto.Reset()
			idw_totales.Reset()
			idw_pre_asiento_cab.Reset()
			idw_pre_asiento_det.Reset()
			is_Action = 'new'
	//		is_flag_guia = 'N'
			ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
			
	 CASE idw_detail
			IF ll_row = 0 THEN RETURN
			ls_flag_estado = dw_master.object.flag_estado [ll_row]
			ll_ano			= dw_master.object.ano 			 [ll_row]
			ll_mes			= dw_master.object.mes 			 [ll_row]

			/*verifica cierre*/
			invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R', ls_result, ls_mensaje)
			IF ls_flag_estado <> '1' OR idw_referencias.Rowcount() > 0 OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
			ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración

	CASE idw_impuesto
		
			ll_currow 		= idw_detail.GetRow()
			lb_result 		= idw_detail.IsSelected(ll_currow)
			ls_flag_estado = dw_master.object.flag_estado [ll_row]
			ll_ano			= dw_master.object.ano 			 [ll_row]
			ll_mes			= dw_master.object.mes 			 [ll_row]

			if idw_detail.getRow() = 0 then
				gnvo_app.of_mensaje_error('Debe Seleccionar un item del detalle para agregarle su impuesto')
			end if
			
			/*verifica cierre*/
			invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R', ls_result, ls_mensaje)
			IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

			IF lb_result = FALSE then
				Messagebox('Aviso','Debe Seleccionar Un documento para generar su Respectivo Impuesto')
				Return
			END IF
			ib_estado_prea = TRUE    //Pre Asiento No editado	Autogeneración				
			/**/
			
	 CASE	idw_asiento_aux
			ll_currow 		= idw_pre_asiento_det.GetRow()
			lb_result 		= idw_pre_asiento_det.IsSelected(ll_currow)
			ls_flag_estado = dw_master.object.flag_estado [ll_row]
			ll_ano			= dw_master.object.ano 			 [ll_row]
			ll_mes			= dw_master.object.mes 			 [ll_row]

			/*verifica cierre*/
			invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
			IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
			ib_estado_prea = TRUE
			IF lb_result = FALSE THEN RETURN
			
	 CASE	ELSE
			Return
END CHOOSE


ll_row = idw_1.Event ue_insert()
IF idw_1 = dw_master THEN
	idw_1.Setcolumn('serie')
ELSEIF idw_1 = idw_detail THEN
	idw_1.Setcolumn('descripcion')
END IF

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_insert_pos;call super::ue_insert_pos;IF idw_1 = dw_master THEN
	idw_pre_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_delete;//Override
Long   	ll_row, ll_ano, ll_mes, ll_x, ll_found, ll_nro_item
String 	ls_flag_estado, ls_item, ls_expresion_imp, ls_result, ls_mensaje, &
			ls_origen_ref, ls_nro_ref, ls_expresion, ls_salir, &
			ls_nro_doc_cxp
	
CHOOSE CASE idw_1
	CASE idw_detail
		ll_row = idw_1.Getrow()
		IF ll_row = 0 THEN RETURN		
		ls_flag_estado = dw_master.object.flag_estado [1]
		
		invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R', ls_result, ls_mensaje)
		
		IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

      // Elimino las referecnias de las guias
		ls_nro_doc_cxp = idw_detail.Object.nro_ref [ll_row]
	   ll_nro_item	  = idw_detail.Object.item_ref [ll_row]
	  
	   SELECT NRO_VALE
		  INTO :ls_nro_ref
		FROM ARTICULO_MOV           A,
			  AP_GUIA_RECEPCION_DET  B
		WHERE A.COD_ORIGEN = B.ORIGEN_MOV
		  AND A.NRO_MOV    = B.NRO_MOV
		  AND B.COD_GUIA_REC = :ls_nro_doc_cxp
		  AND B.ITEM         = :ll_nro_item;
		
		ls_expresion = " tipo_ref = '" + is_doc_mov_alm + "' AND nro_ref = '" + ls_nro_ref + "'"
		ll_found		 = idw_referencias.find(ls_expresion, 1 , idw_referencias.rowcount( ))

		IF ll_found > 0 THEN idw_referencias.deleterow(ll_found)

			 
 CASE idw_asiento_aux
		//los articulos tomandos en cuenta por el doc 
		ls_flag_estado = dw_master.object.flag_estado [1]
		ll_ano			= dw_master.object.ano 			 [1]
		ll_mes			= dw_master.object.mes 			 [1]

		/*verifica cierre*/
		invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R', ls_result, ls_mensaje)
		
		IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
		ll_row = idw_1.Getrow()
		IF ll_row = 0 THEN RETURN		
		
END CHOOSE


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF


end event

event ue_delete_pos;call super::ue_delete_pos;Decimal {2} ldc_total
long			ll_found, ll_row, ll_nro_item
String		ls_nro_ref, ls_expresion, ls_nro_doc_cxp

/*Genera Pre Asientos*/
ib_estado_prea = TRUE
/**/

ldc_total = wf_totales ()		
dw_master.object.importe_doc [1] = ldc_total
dw_master.ii_update = 1
wf_total_ref ()


end event

event ue_update_pre;Long    ll_nro_libro, ll_nro_asiento, ll_inicio, ll_ano, ll_mes, &
		  ll_count, li_lin_x_doc
Integer li_opcion
String  ls_nro_doc    , ls_cod_origen , ls_periodo        , ls_cod_cliente   ,&
		  ls_flag_estado   , ls_cnta_ctbl  , ls_tipo_ref   , ls_nro_ref        , ls_doc_os        ,&
		  ls_origen_ref    , ls_cencos     , ls_cta_presup , ls_cod_moneda     , &
		  ls_flag_retencion, ls_mensaje    , ls_result     , ls_flag_detraccion, ls_nro_detraccion,&
		  ls_const_dep		 , ls_cta_cte		, ls_obs				  , ls_bien_serv		,&
		  ls_oper			 , ls_flag_serie , ls_doc_oc	
Date    	ld_last_day,ldt_fecha_dep
Decimal 	ldc_totsoldeb   = 0.00,ldc_totdoldeb    = 0.00,ldc_totsolhab     = 0.00,ldc_totdolhab     = 0.00,ldc_importe_imp = 0.00,&
			ldc_total_pagar = 0.00,ldc_monto_tot_os = 0.00,ldc_monto_fact_os = 0.00,ldc_monto_pend_os = 0.00,ldc_total_pagar_old = 0.00,&
			ldc_porc_ret_igv      ,ldc_porc_ret_x_doc	    ,ldc_monto_fac ,ldc_imp_min_igv,ldc_monto_detrac,&
			ldc_porc_detrac		 ,ldc_saldo_sol          ,ldc_saldo_dol, ldc_tasa_cambio
			
Datetime ldt_fecha_doc
str_parametros lstr_param
nvo_numeradores lnvo_numeradores


try 
	ib_update_check = true

	/*Replicación*/
	dw_master.of_set_flag_replicacion 			  ()
	idw_detail.of_set_flag_replicacion 	  ()
	idw_referencias.of_set_flag_replicacion  	  ()
	idw_impuesto.of_set_flag_replicacion  		  ()
	idw_pre_asiento_cab.of_set_flag_replicacion ()
	idw_pre_asiento_det.of_set_flag_replicacion ()
	
	IF is_Action = 'delete' or is_Action = 'anular' THEN 
		RETURN
	END IF
	
	ib_update_check = FALSE
	
	
	lnvo_numeradores = CREATE nvo_numeradores
	
	/*DATOS DE CABECERA */
	IF dw_master.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
		Return
	END IF
	
	//Verificación de Data en Cabecera de Documento
	IF gnvo_app.of_row_Processing( dw_master ) <> true then return
	IF gnvo_app.of_row_Processing( idw_detail ) <> true then return
	IF gnvo_app.of_row_Processing( idw_impuesto ) <> true then return
	IF gnvo_app.of_row_Processing( idw_asiento_aux ) <> true then return
	
	//Verificación de Detalle de Documento
	IF idw_detail.Rowcount() = 0 THEN 
		Messagebox('Aviso','Debe Ingresar Items en el Detalle')
		RETURN
	END IF
	
	// Genera el numero de la Liquidación de compra
	IF of_set_numera() = 0 THEN return
	
	//Seleccionar Informacion de Cabecera
	ls_cod_origen   	 = dw_master.Object.origen          [1]
	ls_nro_doc	    	 = dw_master.object.nro_doc         [1]
	ls_cod_cliente  	 = dw_master.object.cod_relacion    [1] 
	ls_cod_moneda	 	 = dw_master.object.cod_moneda	   [1]
	ll_nro_libro    	 = dw_master.object.nro_libro       [1] 
	ll_nro_asiento	 	 = dw_master.object.nro_asiento	   [1] 
	ll_ano			    = dw_master.object.ano	  			   [1]
	ll_mes		       = dw_master.object.mes				   [1]
	ls_flag_estado	    = dw_master.object.flag_estado	   [1]
	ldt_fecha_doc      = dw_master.object.fecha_emision   [1]
	ldc_monto_fac	    = dw_master.object.importe_doc	   [1]
	ldc_tasa_cambio    = dw_master.object.tasa_cambio	   [1]
	ls_flag_detraccion = dw_master.object.flag_detraccion [1]
	ldc_monto_detrac   = dw_master.object.monto_detrac	   [1]
	ls_nro_detraccion  = dw_master.object.nro_detraccion  [1]
	ldc_porc_detrac	 = dw_master.object.porc_detraccion [1]
	ls_obs				 = dw_master.object.descripcion		[1]
	
	/*Datos de Documentos LC*/
	SELECT flag_separ_serie 
	 INTO :ls_flag_serie 
	FROM   doc_tipo 
	WHERE  tipo_doc = :is_doc_lc ;
	
	IF ls_flag_serie = '1' THEN
		IF Not(Pos(ls_nro_doc,'-',1) = 4 OR Pos(ls_nro_doc,'-',1) = 5)  THEN
			Messagebox('Aviso','Debe Colocar Nro de Serie en 4ta o 5ta Posición , Verifique!')
			RETURN
		END IF
	END IF
	
	/*verifica cierre*/
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R') then return
	
	IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
		Messagebox('Aviso','Debe Ingresar Codigo de Cliente')		
		RETURN	
	END IF	
		
	IF is_Action = 'new' THEN
		//verificacion de año y mes	
		IF Isnull(ll_ano) OR ll_ano = 0 THEN
			Messagebox('Aviso','Ingrese Año Contable , Verifique!')
			Return
		END IF
		
		IF Isnull(ll_mes) OR ll_mes = 0 THEN
			Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
			Return
		END IF
		
		IF not invo_asiento_cntbl.of_get_nro_asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento) THEN return
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
		
		
	END IF
	
	IF ls_cod_moneda = gnvo_app.is_soles THEN 
		ldc_saldo_sol = ldc_monto_fac
		ldc_saldo_dol = Round(ldc_monto_fac / ldc_tasa_cambio ,2)
	ELSEIF ls_cod_moneda = gnvo_app.is_dolares THEN
		ldc_saldo_sol = Round(ldc_monto_fac *  ldc_tasa_cambio ,2)
		ldc_saldo_dol = ldc_monto_fac
	END IF
	
	//saldos
	dw_master.object.saldo_sol [1] = ldc_saldo_sol 
	dw_master.object.saldo_dol [1] = ldc_saldo_dol
	
	IF ib_estado_prea = TRUE THEN //Generación Automaticas de pre Asientos
		IF of_genera_Asiento() = FALSE THEN return
	END IF
	
	/*RECUPERACION DE ARCHIVO DE PARAMETROS*/
	SELECT porc_ret_igv, flag_retencion, imp_min_ret_igv 
	 INTO :ldc_porc_ret_igv, :ls_flag_retencion, :ldc_imp_min_igv  
	FROM finparam           
	WHERE reckey = '1' ;
	
	IF ls_flag_retencion = '1' OR ls_flag_detraccion = '0' THEN /*RETIENE Y NO TIENE DETRACCION*/
		/*CONVERTIR A SOLES*/
		IF ls_cod_moneda = gnvo_app.is_soles THEN
			ldc_monto_fac	 = dw_master.object.importe_doc [1]
		ELSE
			ldc_monto_fac	 = Round(dw_master.object.importe_doc [1] * ldc_tasa_cambio,2)
		END IF
	
		IF ldc_monto_fac > ldc_imp_min_igv THEN
			IF idw_impuesto.Rowcount() > 0 THEN
				SELECT Count(*) 
				  INTO :ll_count 
				FROM doc_grupo_relacion 
				WHERE grupo = '07' 
				AND tipo_doc = :is_doc_lc ;
				IF ll_count > 0 THEN 
					ldc_porc_ret_x_doc = dw_master.Object.porc_ret_igv [1]
					IF Isnull(ldc_porc_ret_x_doc) THEN ldc_porc_ret_x_doc = 0.00
						IF ldc_porc_ret_x_doc <> ldc_porc_ret_igv THEN
							/*Asignar porc. retencion*/
							IF ls_flag_detraccion = '1' THEN
								dw_master.Object.porc_ret_igv [1] = 0.00
								dw_master.ii_update = 1
							ELSE
								dw_master.Object.porc_ret_igv [1] = ldc_porc_ret_igv
								dw_master.ii_update = 1
							END IF
						END IF
					END IF
				END IF
		END IF
	END IF	
	
	//DETRACCION
	IF ls_flag_detraccion = '1' THEN
		select count(*) into :ll_count from detraccion where nro_detraccion = :ls_nro_detraccion ;
		if ll_count = 0 then
			//verifica porcentaje	
			if isnull(ldc_porc_detrac) or ldc_porc_detrac = 0.00 then
				Messagebox('Aviso','Debe Ingresar Porcentaje Detracció')
				dw_master.Setfocus()
				dw_master.SetColumn('porc_detraccion')
				Return			
			end if
			
			SetNull(ls_nro_detraccion)
			IF lnvo_numeradores.uf_num_detraccion(ls_cod_origen,ls_nro_detraccion) = FALSE THEN
				Return			
			END IF
			
			li_opcion = Messagebox('Aviso','Desea Colocar Datos del Deposito o Detracción',Question!,Yesno!,2)
			
			if li_opcion = 1 then
				//ventana de ayuda
				Open(w_help_constacia_dep_x_pag)
				
				//*Datos Recuperados
				If IsValid(message.PowerObjectParm) Then
					lstr_param = message.PowerObjectParm
					
					If lstr_param.bret Then
						ls_const_dep  = lstr_param.string1
						ldt_fecha_dep = lstr_param.date1
						ls_cta_cte	  = lstr_param.string2
						ls_bien_serv  = lstr_param.string3
						ls_oper		  = lstr_param.string4
					Else
						SetNull(ls_const_dep)
						SetNull(ldt_fecha_dep)
						SetNull(ls_cta_cte)
						SetNull(ls_bien_serv)
						SetNull(ls_oper)
					
					End If //si recupero informacion
				end if // si estructura es valida
			else
				SetNull(ls_const_dep)
				SetNull(ldt_fecha_dep)
				SetNull(ls_bien_serv)
				SetNull(ls_oper)
			end if //si ingreso constancia	
			
			//insert detraccion
			IF f_insert_detrac(ls_nro_detraccion,'1', Date(ldt_fecha_doc), ls_const_dep, ldt_fecha_dep,&
									 gs_user          ,ldc_monto_detrac,'3') = FALSE THEN
				Return								 
			END IF
			
			//genera documento detraccion
			IF ls_cta_cte = '1' THEN 
				IF f_insert_cta_cte_detrac(ls_cod_cliente ,ls_nro_detraccion ,DATE(ldt_fecha_doc),ls_cod_moneda   ,ldc_tasa_cambio,&
													gs_user		   ,ls_cod_origen ,ls_obs					  ,ldc_monto_detrac	) = FALSE THEN
													
					RETURN
				END IF
			END IF
			
			//coloca datos de la detracción
			dw_master.object.bien_serv		  [1] = ls_bien_serv
			dw_master.object.oper_detr		  [1] = ls_oper
			dw_master.object.nro_detraccion [1] = ls_nro_detraccion
			SetNull(ls_nro_detraccion)
			dw_master.object.ind_detrac	  [1]	= ls_nro_detraccion
			
		else //existe detraccion
			If ls_flag_estado = '1' Then // solamnet en estado activo se actualiza
				//verificar si ha cambiado fecha docuemnto y monto detraccion
				if f_update_detraccion(ls_nro_detraccion,Date(ldt_fecha_doc),ldc_monto_detrac) = FALSE THEN
					Return								 
				end if
				
				//actualiza cta cte
				if f_update_cta_cte_detrac(ls_nro_detraccion,ls_cod_cliente,DATE(ldt_fecha_doc),ldc_tasa_cambio,&
					ldc_monto_detrac,ls_cod_moneda) = FALSE THEN
					Return
				end if
				
			End if
		
		end if //si comprobante detraccion existe
	END IF
	
	
	///detalle de Documento
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		 IF ls_flag_estado = '1' THEN //GENERADO
			 IF idw_referencias.Rowcount() = 0 THEN
				 ls_cencos     = idw_detail.object.cencos    [ll_inicio]
				 ls_cta_presup = idw_detail.object.cnta_prsp [ll_inicio]
			 
				 IF Isnull(ls_cencos) OR Trim(ls_cencos) = '' THEN
					 Messagebox('Aviso','Debe Ingresar Centro de Costo , Verifique!')
					 idw_detail.SetFocus()
					 idw_detail.Scrolltorow(ll_inicio)
					 idw_detail.SetColumn('cencos')
					 Return
				 END IF
			 
				 IF Isnull(ls_cta_presup) OR Trim(ls_cta_presup) = '' THEN
					 Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal , Verifique!')
					 idw_detail.SetFocus()
					 idw_detail.Scrolltorow(ll_inicio)
					 idw_detail.SetColumn('cnta_prsp')
					 Return
				 END IF
			END IF
		END IF
	NEXT
	/////////******************************//////////////////
	///Referencias de Documentos
	FOR ll_inicio = 1 TO idw_referencias.Rowcount()
		 idw_referencias.object.cod_relacion [ll_inicio] = ls_cod_cliente	 
	NEXT
	
	///Impuestos
	FOR ll_inicio = 1 TO idw_impuesto.Rowcount()
		 idw_impuesto.object.tipo_doc 	  [ll_inicio] = is_doc_lc		 
		 idw_impuesto.object.cod_relacion  [ll_inicio] = ls_cod_cliente
		 
		 /*Verifica Monto de Impuesto sea Mayor a 0*/
		 ldc_importe_imp = idw_impuesto.object.importe [ll_inicio]
		 IF ls_flag_estado = '1' THEN   //Generado
			 IF Isnull(ldc_importe_imp) OR ldc_importe_imp = 0 THEN
				 ib_update_check = False	
				 Messagebox('Aviso','Verifique Importe de Impuesto debe ser Mayor que 0')
				 EXIT			 
			 END IF
		END IF
	NEXT
	
	///Detalle de pre asiento
	FOR ll_inicio = 1 TO idw_pre_asiento_det.Rowcount()
		 ls_cnta_ctbl = idw_pre_asiento_det.object.cnta_ctbl [ll_inicio]
		 idw_pre_asiento_det.object.origen   	 [ll_inicio] = ls_cod_origen
		 idw_pre_asiento_det.object.ano	   	 [ll_inicio] = ll_ano
		 idw_pre_asiento_det.object.mes	   	 [ll_inicio] = ll_mes
		 idw_pre_asiento_det.object.nro_libro	 [ll_inicio] = ll_nro_libro
		 idw_pre_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
		 idw_pre_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_doc
		 
		 IF wf_verifica_flag_cntas (ls_cnta_ctbl, is_doc_lc, ls_nro_doc, ls_cod_cliente, ll_inicio) = FALSE THEN
			 Messagebox('Aviso','Flag de Cuenta Contable '+ls_cnta_ctbl +'Tiene Problemas ,Verifique!')
			 Return	
		 END IF
		 
	NEXT
	
	//Detalle de Pre Asientos Auxiliares
	FOR ll_inicio = 1 TO tab_1.tabpage_6.dw_asiento_aux.Rowcount()
		 idw_asiento_aux.object.origen		[ll_inicio] = ls_cod_origen
		 idw_asiento_aux.object.nro_libro	[ll_inicio] = ll_nro_libro
		 idw_asiento_aux.object.ano			[ll_inicio] = ll_ano
		 idw_asiento_aux.object.mes			[ll_inicio] = ll_mes
		 idw_asiento_aux.object.nro_asiento [ll_inicio] = ll_nro_asiento
		 
	NEXT
	
	//*Totales Para Cabecera de Pre - Asientos*//
	ldc_totsoldeb  = idw_pre_asiento_det.object.monto_soles_cargo   [1]
	ldc_totdoldeb  = idw_pre_asiento_det.object.monto_dolares_cargo [1]
	ldc_totsolhab  = idw_pre_asiento_det.object.monto_soles_abono	 [1]
	ldc_totdolhab  = idw_pre_asiento_det.object.monto_dolares_abono [1]
	
	///Cabecera de pre asiento
	idw_pre_asiento_cab.Object.origen      [1] = ls_cod_origen
	idw_pre_asiento_cab.Object.nro_libro 	[1] = ll_nro_libro
	idw_pre_asiento_cab.Object.ano 			[1] = ll_ano
	idw_pre_asiento_cab.Object.mes 			[1] = ll_mes
	idw_pre_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento
	
	idw_pre_asiento_cab.Object.cod_moneda	 [1] = dw_master.object.cod_moneda     [1]
	idw_pre_asiento_cab.Object.tasa_cambio	 [1] = dw_master.object.tasa_cambio    [1]
	idw_pre_asiento_cab.Object.desc_glosa	 [1] = Mid(dw_master.object.descripcion[1],1,60)
	idw_pre_asiento_cab.Object.fec_registro [1] = dw_master.object.fecha_registro [1]
	idw_pre_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_doc
	idw_pre_asiento_cab.Object.cod_usr		 [1] = dw_master.object.cod_usr 	 	   [1]
	idw_pre_asiento_cab.Object.flag_estado	 [1] = dw_master.object.flag_estado    [1]
	idw_pre_asiento_cab.Object.tot_solhab	 [1] = ldc_totsolhab
	idw_pre_asiento_cab.Object.tot_dolhab	 [1] = ldc_totdolhab
	idw_pre_asiento_cab.Object.tot_soldeb	 [1] = ldc_totsoldeb
	idw_pre_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb
	
	IF idw_pre_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1
	IF dw_master.ii_update = 1 THEN idw_pre_asiento_cab.ii_update = 1
	
	
	//VERIFICAR NRO DE LINEAS EN LA IMPRESION
	SELECT nro_lineas 
	  INTO :li_lin_x_doc 
	FROM   doc_tipo_origen 
	WHERE  tipo_doc   = :is_doc_lc   
	  AND	 cod_origen = :gs_origen ;
	
	If SQLCA.SQLCOde = 100 then
		Messagebox('Aviso','No ha especificado parametros en la tabla DOC_TIPO_ORIGEN'  )
		RETURN		
	end if
			  
	IF idw_detail.rowcount() > li_lin_x_doc then
		Messagebox('Aviso','Nro de Lineas no debe Exceder las ' + Trim(String(li_lin_x_doc))  )
		RETURN		
	END IF
	
	// valida asientos descuadrados
	if not f_validar_asiento(tab_1.tabpage_5.dw_pre_asiento_det) then return
	
	ib_update_check = true
	
catch ( Exception ex )
	f_mensaje("Error, ha ocurrido una excepción, Mensaje: " + ex.GetMessage(), "")
	ib_update_check = false
	
finally
	destroy lnvo_numeradores
end try

end event

event ue_update;Boolean lbo_ok = TRUE
Long    ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento, ll_i, &
		  ll_item_cxp, ll_item_guia
String  ls_flag_estado,ls_origen, ls_mensaje, ls_cod_rel_cxp,  & 
		  ls_tipo_doc_cxp, ls_guia_cxp, ls_nro_doc_cxp


dw_master.AcceptText()
idw_detail.AcceptText()
idw_referencias.AcceptText()
idw_impuesto.AcceptText()
idw_pre_asiento_cab.AcceptText()
idw_pre_asiento_det.AcceptText()
idw_asiento_aux.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF

//ejecuta procedimiento de actualizacion de tabla temporal
IF idw_pre_asiento_det.ii_update = 1 and is_Action <> 'new' THEN
	ll_row_det     = idw_pre_asiento_cab.Getrow()
	ls_origen      = idw_pre_asiento_cab.Object.origen      [ll_row_det]
	ll_ano         = idw_pre_asiento_cab.Object.ano         [ll_row_det]
	ll_mes         = idw_pre_asiento_cab.Object.mes         [ll_row_det]
	ll_nro_libro   = idw_pre_asiento_cab.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = idw_pre_asiento_cab.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
END IF	

// Para Grabar el log diario
IF ib_log THEN
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_referencias.of_create_log()
	idw_impuesto.of_create_log()
	idw_pre_asiento_cab.of_create_log()
	idw_pre_asiento_det.of_create_log()
	idw_asiento_aux.of_create_log()
END IF

IF idw_pre_asiento_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
	IF idw_pre_asiento_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Asiento Cabecera","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_pre_asiento_det.ii_update = 1 AND lbo_ok = TRUE  THEN
	IF idw_pre_asiento_det.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Asiento Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF is_Action <> 'delete' and is_Action <> 'anular' THEN
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabación Cabecera de Ctas x Pagar
			lbo_ok = FALSE
			Messagebox('Error en Grabación de Cabecera de Ctas x Pagar','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF	idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_referencias.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF idw_impuesto.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_impuesto.Update (true, false) = -1 then //Grabacion de Impuestos
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
ELSE
	IF idw_impuesto.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_impuesto.Update (true, false) = -1 then //Grabacion de Impuestos
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF	idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF	idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_referencias.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabación Cabecera de Ctas x Pagar
			MessageBox("SQL error", SQLCA.SQLErrText)
			lbo_ok = FALSE
			Messagebox('Error en Grabación de Cabecera de Ctas x Pagar','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
END IF

IF idw_asiento_aux.ii_update = 1 AND lbo_ok = TRUE THEN
   IF	idw_asiento_aux.Update (true, false) = -1 then //Grabación de Pre Asientos Auxiliares
		lbo_ok = FALSE
		Messagebox('Error en Grabacion de Pre Asientos Auxiliares ','Se ha procedido al rollback',exclamation!)
	END IF
END IF



/// Para Grabar el Log Diario
IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_referencias.of_save_log()
		lbo_ok = idw_impuesto.of_save_log()
		lbo_ok = idw_pre_asiento_cab.of_save_log()
		lbo_ok = idw_pre_asiento_det.of_save_log()
		lbo_ok = idw_asiento_aux.of_save_log()
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update 			= 0
	idw_detail.ii_update 	= 0
	idw_referencias.ii_update 	= 0
	idw_impuesto.ii_update 		= 0
	idw_pre_asiento_cab.ii_update = 0
	idw_pre_asiento_det.ii_update = 0
	idw_asiento_aux.ii_update 		= 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_referencias.ResetUpdate()
	idw_impuesto.ResetUpdate()
	idw_pre_asiento_cab.ResetUpdate()
	idw_pre_asiento_det.ResetUpdate()
	idw_asiento_aux.ResetUpdate()
	
	ib_estado_prea = False   //pre-asiento editado	
	
	IF is_Action <> 'delete' THEN
		is_Action = 'fileopen'
	END IF
	
	f_mensaje("Cambios han sido guardados satisfactoriamente.", "")
ELSE 
	ROLLBACK USING SQLCA;
END IF



end event

event closequery;// Override Ancester Script
IF is_salir = '' THEN
	Destroy ids_matriz_cntbl_det
	Destroy ids_data_glosa
	Destroy invo_asiento_cntbl
	Destroy ids_voucher
END IF

CHOOSE CASE is_salir
	CASE 'S'
		CLOSE (this)
		
	CASE 'A'
	   Messagebox('Aviso', 'El usuario '+ gs_user + ' No tiene Nro de series ' &
					+ 'asignadas para este documento ' + '~n~r '+ 'Por favor verificar')
		CLOSE (THIS)
	
	CASE ELSE
		THIS.Event ue_close_pre()
		THIS.EVENT ue_update_request()
		Destroy	im_1
		of_close_sheet()
END CHOOSE


end event

event ue_modify;call super::ue_modify;Long    ll_row,ll_mes,ll_ano
String  ls_flag_estado,ls_result,ls_mensaje
Integer li_protect

ll_row = dw_master.Getrow()
dw_master.accepttext()

IF ll_row = 0 THEN RETURN


ls_flag_estado = dw_master.object.flag_estado [ll_row]
ll_ano			= dw_master.object.ano 			 [ll_row]
ll_mes			= dw_master.object.mes 			 [ll_row]

/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R', ls_result, ls_mensaje) 

dw_master.of_protect()
idw_detail.of_protect()
idw_referencias.of_protect()
idw_impuesto.of_protect()
idw_pre_asiento_det.of_protect()
idw_asiento_aux.of_protect()
	

IF ls_flag_estado <> '1' OR ls_result = '0' THEN
	dw_master.ii_protect 			= 0
	idw_detail.ii_protect		= 0
	idw_referencias.ii_protect		= 0
	idw_impuesto.ii_protect			= 0
	idw_pre_asiento_det.ii_protect= 0
	idw_asiento_aux.ii_protect 	= 0
	dw_master.of_protect				()
	idw_detail.of_protect		()
	idw_referencias.of_protect		()
	idw_impuesto.of_protect			()
	idw_pre_asiento_det.of_protect()
	idw_asiento_aux.of_protect		()
ELSE
	
	IF is_Action <> 'new' THEN
		li_protect = integer(dw_master.Object.tipo_doc.Protect)
		IF li_protect = 0	THEN
			dw_master.object.tipo_doc.Protect 	  = 1
			dw_master.object.nro_doc.Protect 	  = 1
			dw_master.object.cod_relacion.Protect = 1
			dw_master.object.nro_libro.Protect 	  = 1
			dw_master.object.mes.Protect		 	  = 1
			dw_master.object.ano.Protect 	  		  = 1
		END IF
	END IF	
	
	li_protect = dw_master.ii_protect
	
	IF li_protect = 0 THEN
		dw_master.Modify("flag_detraccion.Protect='1~tIf(IsNull(ind_detrac),1,0)'")			
	END IF
END IF

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_cta_x_pagar_x_tbl'
sl_param.titulo = 'Listado de Liquidaciones de Compra'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc
sl_param.field_ret_i[4] = 8	//Origen
sl_param.field_ret_i[5] = 9	//Año
sl_param.field_ret_i[6] = 10	//Mes
sl_param.field_ret_i[7] = 11	//Nro Libro
sl_param.field_ret_i[8] = 12	//Nro Asiento

OpenWithParm( w_lista, sl_param)
sl_param = Message.PowerObjectParm

if IsNull(sl_param) then return

IF sl_param.titulo <> 'n' THEN
	
	dw_master.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	idw_detail.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	
	idw_referencias.Retrieve(sl_param.field_ret[2],sl_param.field_ret[3],sl_param.field_ret[1])

	idw_impuesto.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	idw_pre_asiento_cab.Retrieve(sl_param.field_ret[4], Long(sl_param.field_ret[5]), Long(sl_param.field_ret[6]), Long(sl_param.field_ret[7]), Long(sl_param.field_ret[8]))
	idw_pre_asiento_det.Retrieve(sl_param.field_ret[4], Long(sl_param.field_ret[5]), Long(sl_param.field_ret[6]), Long(sl_param.field_ret[7]), Long(sl_param.field_ret[8]))

	IF idw_referencias.Rowcount() > 0 THEN
		FOR ll_inicio = 1 TO idw_detail.Rowcount()
			 idw_detail.object.flag_hab [ll_inicio] = '1'
		NEXT
	END IF	
	
	ib_estado_prea = False   //pre-asiento editado					
	TriggerEvent('ue_modify')
	is_Action = 'fileopen'	
	
	idw_detail.ii_update 		= 0
	idw_referencias.ii_update 		= 0
	idw_impuesto.ii_update 			= 0
	idw_totales.ii_update			= 0
	idw_pre_asiento_cab.ii_update = 0
	idw_pre_asiento_det.ii_update = 0
	
END IF


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 			  OR idw_detail.ii_update    = 1 OR &
	 idw_referencias.ii_update     = 1 OR idw_impuesto.ii_update	    = 1 OR &
	 idw_pre_asiento_cab.ii_update = 1 OR idw_pre_asiento_det.ii_update= 1 OR &
	 idw_asiento_aux.ii_update     = 1 )THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update		= 1 
	   idw_referencias.ii_update		= 1 
	   idw_impuesto.ii_update			= 1 
		idw_pre_asiento_cab.ii_update = 1 
	   idw_pre_asiento_det.ii_update = 1 
		idw_asiento_aux.ii_update 		= 1 
	END IF
END IF

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_print;call super::ue_print;IF dw_master.rowcount() = 0 then return

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_relacion[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.tipo_doc		[dw_master.getrow()]
lstr_rep.string3 = dw_master.object.nro_doc		[dw_master.getrow()]

OpenSheetWithParm(w_ap315_liquidacion_compra_frm, lstr_rep, w_main, 0, Layered!)
end event

type pb_1 from picturebutton within w_ap315_liquidacion_compra
integer x = 3589
integer y = 272
integer width = 133
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Compute!"
end type

event clicked;Parent.Event ue_grmp()
end event

type st_descripcion from statictext within w_ap315_liquidacion_compra
integer x = 3749
integer y = 168
integer width = 471
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_ap315_liquidacion_compra
event dobleclick pbm_lbuttondblclk
integer x = 3579
integer y = 164
integer width = 160
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "h:\source\cur\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tolva, ls_balanza

ls_sql = "SELECT COD_ORIGEN AS ORIGEN, "  &
       + "NOMBRE    AS DESCRIPCION "  &
    	 + "FROM  ORIGEN "  &
		 + "WHERE  FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
IF ls_codigo <> '' THEN
	THIS.text 		     = ls_codigo
	st_descripcion.text = ls_data
END IF
end event

event modified;String 	ls_descripcion, ls_origen

ls_origen = This.text

IF ls_origen = '' OR IsNull(ls_origen) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	RETURN
END IF

SELECT nombre
  INTO :ls_descripcion
FROM   origen
WHERE  cod_origen = :ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de ORIGEN no existe')
	st_descripcion.text 		= ''
	RETURN
END IF

st_descripcion.text 		= ls_descripcion

end event

type st_1 from statictext within w_ap315_liquidacion_compra
integer x = 3735
integer y = 312
integer width = 480
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Guia de Recepción"
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_ap315_liquidacion_compra
event ue_display ( string as_columna,  long al_row )
integer width = 3301
integer height = 1064
string dataobject = "d_abc_cntas_pagar_cab_x_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display;boolean lb_ret
string  ls_codigo, ls_data, ls_sql, ls_data2, ls_data3
Date	  ld_fecha_vencimiento, ld_fecha_emision

Datawindow  ldw_dw

CHOOSE CASE lower(as_columna)
		
	CASE 'cod_moneda'
		IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
			Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda')
			Return 
		END IF
				
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
			  + "DESCRIPCION AS DESC_MONEDA " &
			  + "FROM MONEDA " &
			  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
				
		IF ls_codigo <> '' THEN
			this.object.cod_moneda [al_row] = ls_codigo
			this.ii_update = 1
			ib_estado_prea = TRUE
		END IF
	
	CASE 'serie'
		ls_sql = "SELECT TIPO_DOC AS TIPO_DOC, "  		&
				  +"NRO_SERIE AS SERIE, "	&
				  +"COD_USR AS USUARIO  "						&
				  +"FROM   DOC_TIPO_USUARIO " 				&
  			     +"WHERE  COD_USR = '" + gs_user + "'"   &
				  +"AND TIPO_DOC = '" + is_doc_lc + "'"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.serie[al_row] = ls_data
			This.ii_update 			  = 1
			ib_estado_prea 			  = TRUE
		END IF
		
	CASE	'forma_pago'	
		ls_sql = 'SELECT FORMA_PAGO.FORMA_PAGO  AS CODIGO_FPAGO, ' &
					 +'FORMA_PAGO.DESC_FORMA_PAGO  AS DESCRIPCION,  ' &
					 +'FORMA_PAGO.DIAS_VENCIMIENTO AS VENCIMIENTO   ' &
					 +'FROM FORMA_PAGO '
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '1')
				
		IF ls_codigo <> '' THEN
			this.object.forma_pago 		 [al_row] = ls_codigo
			this.object.desc_forma_pago [al_row] = ls_data
			this.ii_update = 1
		END IF
				
		il_dias_vencimiento = dec(ls_data2)
					
		IF il_dias_vencimiento > 0 THEN
			ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_emision [al_row]) , il_dias_vencimiento )
			This.Object.vencimiento[al_row] = ld_fecha_vencimiento
			This.ii_update = 1
		END IF

		ii_update = 1
		/*Datos del Registro Modificado*/
		ib_estado_prea = TRUE


	CASE 'cod_relacion'
		IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
			Messagebox('Aviso','No puede	Cambiar El codigo del Cliente')
			Return
		END IF
	
		ls_sql = "SELECT P.Proveedor AS COD_PROVEEDOR, " &
				 + "		  P.Nom_Proveedor AS NOM_PROVEEDOR ,	"   &
				 + "		  P.Tipo_doc_ident as tipo_doc_ident, "  &
				 + "		  P.Nro_Doc_Ident AS NRO_DNI " 			 &
				 + "FROM  PROVEEDOR P "					  		 &
				 + "WHERE TIPO_DOC_IDENT <> '6' "			    &
				 + "  AND FLAG_ESTADO = '1' "
	
	   lb_ret = f_lista_4ret_text(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')
		
		IF ls_codigo <> '' THEN
			this.object.cod_relacion  	[al_row] = ls_codigo
			this.object.nom_proveedor 	[al_row] = ls_data
			this.object.tipo_doc_ident [al_row] = ls_data2
			this.object.nro_doc_ident 	[al_row] = ls_data3
			
			of_get_datos_lc(ls_codigo, al_row)
			
			this.ii_update = 1
			ib_estado_prea = TRUE
		END IF
	
	CASE	'fecha_emision'
		IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
			Messagebox('Aviso','No puede Cambiar la Fecha de Emision por que Cambiaria la Tasa de Cambio y Tiene Doc. de Referencias ,Verifique!')
			Return 
		END IF
		
		ld_fecha_emision = Date(This.Object.fecha_emision [al_row])				
		ldw_dw = This
		f_call_calendar(ldw_dw, as_columna, "datetime", al_row)
				
		IF ld_fecha_emision <> Date(This.Object.fecha_emision [al_row]) THEN
			ld_fecha_emision     = Date(This.Object.fecha_emision [al_row])				
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [al_row])			
						
			IF ld_fecha_emision > ld_fecha_vencimiento THEN
				This.Object.fecha_emision [al_row] = ld_fecha_vencimiento
				Messagebox('Aviso','Fecha de Emisión del Documento No '&
										+'Puede Ser Mayor a la Fecha de Vencimiento')
			END IF
			
			ld_fecha_emision = Date(This.Object.fecha_emision [al_row])		
			
			This.Object.tasa_cambio [al_row] = f_tasa_cambio_x_arg(ld_fecha_emision)	
			This.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF			
			
	CASE 'vencimiento'	
		ld_fecha_vencimiento = Date(This.Object.vencimiento [al_row])				
		ldw_dw = This
		f_call_calendar(ldw_dw, as_columna, "datetime", al_row)
		
		IF ld_fecha_vencimiento <> Date(This.Object.vencimiento [al_row])	THEN
			ld_fecha_emision     = Date(This.Object.fecha_emision [al_row])			
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [al_row])			

			IF ld_fecha_vencimiento < ld_fecha_emision THEN
				This.Object.vencimiento [al_row] = ld_fecha_emision
				Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
										+'Puede Ser Menor a la Fecha de Emisión')
			END IF					
			This.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF		

END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_nom_proveedor  , ls_forma_pago , ls_mes,ls_flag_detraccion,&
				ls_nro_detraccion , ls_desc_fpago , ls_null, ls_serie
Date        ld_fecha_emision, ld_fecha_vencimiento,ld_fecha_emision_old
DateTime    ldt_fecha_vencim_new
Decimal {3} ldc_tasa_cambio
Integer		li_dias_venc , li_opcion
Long        ll_nro_libro,ll_count

ld_fecha_emision_old = Date(This.Object.fecha_emision [row])			
Accepttext()
setnull(ls_null)

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

CHOOSE CASE dwo.name
	
	CASE 'serie'
		SELECT NRO_SERIE
		  INTO :ls_serie
		FROM   DOC_TIPO_USUARIO
  		WHERE TIPO_DOC 	= :is_doc_lc 
		  AND COD_USR  	= :gs_user
		  AND Nro_SERIE 	= :data;
		
		IF IsNull(ls_serie) OR TRIM(ls_serie) = '' THEN
			Messagebox('Aviso','No Existe Serie asignada,Verifique !', StopSign!)
			This.object.serie[row] = gnvo_app.is_null
			Return 1
		END IF

		This.object.serie[row] = ls_serie
		
	CASE 'forma_pago'
			select desc_forma_pago, dias_vencimiento 
			 into :ls_desc_fpago,:li_dias_venc
			  from forma_pago
			 where (forma_pago = :data ) ;
			 
			IF Isnull(ls_desc_fpago) OR Trim(ls_desc_fpago) = '' THEN
				Messagebox('Aviso','No Existe Forma Pago ,Verifique !')
				This.object.forma_pago [row] = ls_null
				Return 1
			END IF	
			 
			this.object.desc_forma_pago  [row] = ls_desc_fpago
			this.object.dias_vencimiento [row] = li_dias_venc
			
			IF li_dias_venc > 0 THEN
				ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_emision [row]) , li_dias_venc )
				This.Object.vencimiento [row] = ld_fecha_vencimiento
			END IF
				
	 CASE 'cod_moneda'
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda')
				This.Object.cod_moneda [1] = This.Object.moneda_det [1]
				Return 1
			END IF
			
			select count(*) into :ll_count from moneda where cod_moneda = :data ;
			
			if ll_count = 0 then
				this.object.cod_moneda [row] = ls_null
				Messagebox('Aviso','Moneda No existe Verifique!')
				Return 1
			end if
			
	CASE 'tasa_cambio'
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede Cambiar la Tasa de Cambio por que Tiene Doc. de Referencias ,Verifique!')
				This.Object.tasa_cambio[1] =	This.Object.tasa_cambio_det[1] 
				Return 1
			END IF		
			
	CASE 'cod_relacion'
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El codigo del Cliente Tiene Doumentos Referenciados , Verifique!')
				This.Object.cod_relacion [1] = This.Object.cod_relacion_det [1]
				Return 1
			END IF
			
			SELECT P.nom_proveedor
			  INTO :ls_nom_proveedor
			FROM   PROVEEDOR P
			WHERE  P.proveedor = :data
			  AND  RUC IS NULL
			  AND  TIPO_DOC_IDENT = '1'
			  AND  NRO_DOC_IDENT IS NOT NULL
			  AND  FLAG_ESTADO = '1';

			IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
				Messagebox('Aviso','Proveedor No Existe , Verifique!')
				This.Object.cod_relacion [1] = ''
				Return 1
			end if
			
			This.Object.nom_proveedor[row] = ls_nom_proveedor
			of_get_datos_lc(data, row)
			

	 CASE	'fecha_emision'
			IF idw_referencias.rowcount() > 0 THEN
				Messagebox('Aviso','No puede Cambiar la Fecha de Emision por que Cambiaria la Tasa de Cambio y Tiene Doc. de Referencias ,Verifique!')
				This.Object.fecha_emision[1] = ld_fecha_emision_old
				Return 1
			END IF		
			
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
			ls_forma_pago			= This.Object.forma_pago [row]	
			
			IF ld_fecha_emision > ld_fecha_vencimiento THEN
				This.Object.fecha_emision [row] = ld_fecha_emision_old
				Messagebox('Aviso','Fecha de Emisión del Documento No '&
										+'Puede Ser Mayor a la Fecha de Vencimiento')
				Return 1
			END IF
			
			This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
			
			IF Not (Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
				
				li_dias_venc = this.object.dias_vencimiento [row]
				
				IF li_dias_venc > 0 THEN
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					
					IF li_opcion = 1 THEN
						ld_fecha_emision = Date(This.object.fecha_emision[row])
						ld_fecha_vencimiento = Relativedate(ld_fecha_emision,li_dias_venc)
						This.Object.vencimiento [row] = ld_fecha_vencimiento
					END IF
				END IF	
			END IF

	 CASE 'vencimiento'	
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
			
			IF ld_fecha_vencimiento < ld_fecha_emision THEN
				This.Object.vencimiento [row] = ld_fecha_emision
				Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
										+'Puede Ser Menor a la Fecha de Emisión')
				Return 1
			END IF

	 CASE	'forma_pago'
			li_dias_venc = this.object.dias_vencimiento [row]
			IF li_dias_venc > 0 THEN
				
				li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
				IF li_opcion = 1 THEN
					ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_emision[row]),li_dias_venc)
					This.Object.vencimiento [row] = ld_fecha_vencimiento
				END IF
			ELSE
				This.Object.vencimiento [row] = This.object.fecha_emision[row]
			END IF
			
	CASE 'flag_detraccion'
		  if data = '0' then
			  SetNull(ls_nro_detraccion)
			  this.object.porc_detraccion [row] = 0.00
			  this.object.nro_detraccion  [row] = ls_nro_detraccion
		  end if
		  
	CASE 'porc_detraccion'	
		  ls_flag_detraccion = This.object.flag_detraccion [row]	
		  
		  IF ls_flag_detraccion = '0' THEN
			  this.object.porc_detraccion	[row] = 0.00
			  Messagebox('Aviso','Documento no tiene indicador detracción Activo ,Verifique!')	  	
			  RETURN 1
		  END IF
END CHOOSE

				
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                   	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 2			// columnas de lectrua de este dw
ii_ck[2] = 3			// 
ii_ck[3] = 4			// 

ii_dk[1] = 2 	      // columnas que se pasan al detalle
ii_dk[2] = 3 	      // 
ii_dk[3] = 4 	      // 

idw_mst  = dw_master								 // dw_master
idw_det  = tab_1.tabpage_1.dw_ctas_pag_det // dw_detail

end event

event ue_insert_pre;call super::ue_insert_pre;
This.object.origen 			  [al_row] = gs_origen
This.object.cod_usr 			  [al_row] = gs_user
This.object.tipo_doc			  [al_row] = is_doc_lc
This.object.forma_pago		  [al_row] = is_pago_con
This.object.desc_forma_pago  [al_row] = is_desc_pago
This.object.nro_libro		  [al_row] = il_nro_libro
This.object.fecha_registro   [al_row] = f_fecha_actual()
This.object.fecha_emision 	  [al_row] = f_fecha_actual()
This.object.vencimiento 	  [al_row] = f_fecha_actual()
This.object.ano 				  [al_row] = Long(String(f_fecha_actual(),'YYYY'))
This.object.mes	 			  [al_row] = Long(String(f_fecha_actual(),'MM'))
This.object.tasa_cambio 	  [al_row] = f_tasa_cambio()
This.object.flag_estado 	  [al_row] = '1'
This.Object.ind_detrac	     [al_row] = '1'
This.object.flag_detraccion  [al_row] = '0'
This.object.flag_provisionado[al_row] = 'R'
This.object.flag_cntr_almacen[al_row] = '1'

this.SetColumn('serie')
is_action = 'new'
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_type_col
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row


IF row > 0 THEN
	ls_columna  = upper(dwo.name)
	ls_type_col = lower(dwo.coltype)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_ap315_liquidacion_compra
event ue_find_exact ( )
integer y = 1076
integer width = 3593
integer height = 892
integer taborder = 40
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
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

event ue_find_exact();Parent.TriggerEvent('ue_find_exact')
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanged;CHOOSE CASE newindex
	CASE  3  // Impuestos
		
		
	CASE	4	
		wf_totales		   ()
		
	CASE 5	//Pre Asientos
	   IF ib_estado_prea = FALSE THEN RETURN //  Editado
		of_genera_asiento ()
		
END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
long backcolor = 79741120
string text = "Registro"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ctas_pag_det dw_ctas_pag_det
end type

on tabpage_1.create
this.dw_ctas_pag_det=create dw_ctas_pag_det
this.Control[]={this.dw_ctas_pag_det}
end on

on tabpage_1.destroy
destroy(this.dw_ctas_pag_det)
end on

type dw_ctas_pag_det from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer width = 3543
integer height = 736
integer taborder = 20
string dataobject = "d_abc_cntas_pagar_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display;boolean 			lb_ret
string  			ls_codigo, ls_data, ls_sql, ls_flag_cebef
integer			li_year
str_parametros	lstr_param

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
		*/
		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 3	
		lstr_param.str_array[1] = '2'		//Cntas x Pagar
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
			ib_estado_prea = TRUE
			/**/
		END IF
		
	CASE	'cencos'
		li_year = Year(Date(dw_master.object.fecha_emision[dw_master.GetRow()]))
		
		ls_sql = "SELECT distinct cc.cencos AS codigo_cencos, " &
				  + "cc.desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where cc.cencos = pp.cencos " &
				  + "and pp.flag_estado <> '0' " &
				  + "and cc.flag_estado = '1' " &
				  + "and pp.ano = " + string(li_year)
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			this.object.cencos	[al_row] = ls_codigo
			this.ii_update = 1
			ib_estado_prea = TRUE
		END IF


	 CASE 'cnta_prsp'
		ls_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CUENTA_PRESUP, '&
				  +'PRESUPUESTO_CUENTA.DESCRIPCION	  AS DESCRIPCION '     &
				  +'FROM PRESUPUESTO_CUENTA '
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cnta_prsp [al_row] = ls_codigo
			this.ii_update = 1
			ib_estado_prea = TRUE
		END IF
	
	CASE 'centro_benef'
		ls_flag_cebef = This.object.flag_cebef   [al_row]
		
		IF ls_flag_cebef = '1' THEN
			ls_sql = "SELECT CB.CENTRO_BENEF AS CODIGO, " &
					  +"CB.DESC_CENTRO AS DESCRIPCION "		 &
					  +"FROM CENTRO_BENEFICIO CB "			 &
					  +"WHERE CB.flag_estado = '1'"
										 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			IF ls_codigo <> '' THEN
				This.object.centro_benef [al_row] = ls_codigo
				This.ii_update = 1
				ib_estado_prea = TRUE
			END IF
		END IF

END CHOOSE
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'd'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master

idw_mst  = dw_master								 // dw_master
idw_det  = tab_1.tabpage_1.dw_ctas_pag_det // dw_detail
end event

event itemchanged;call super::itemchanged;String  ls_matriz_cntbl, ls_item   , ls_cod_art , ls_tipo_doc , ls_nro_doc , ls_nro_oc ,&
		  ls_flag_cant   , ls_cencos , ls_cnta_prsp, ls_flag_cebef
Long    ll_count
Decimal ldc_precio_unit, ldc_cantidad, ldc_total

Accepttext()

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

CHOOSE CASE dwo.name
	CASE 'cencos'				 
			SELECT Count(*)
			  INTO :ll_count
			  FROM centros_costo
			 WHERE (flag_estado = '1'   ) AND
					 (cencos		  = :data ) ;
					  
			IF ll_count = 0 THEN
				Messagebox('Aviso','Centro de Costo '+data+' No Existe , Verifique!')
				This.Object.cencos [row] = gnvo_app.is_null
				Return 1
			END IF
			
	 CASE 'cnta_prsp'
			SELECT Count(*)
			  INTO :ll_count
			  FROM presupuesto_cuenta
			 WHERE (cnta_prsp = :data) ;
			 
			IF ll_count = 0 THEN
				Messagebox('Aviso','Cuenta Preuspuestal No Existe , Verifique!')
				This.Object.cnta_prsp [row] = gnvo_app.is_null
				Return 1
			END IF
			
	 CASE 'importe'
			ls_item = Trim(String(This.object.item [row]))

			//Total  
			ldc_total = wf_totales ()		
			dw_master.object.importe_doc [1] = ldc_total
			dw_master.ii_update = 1
			wf_total_ref ()
			
	
	 CASE	'centro_benef'
			ls_flag_cebef = This.object.flag_cebef   [row]
		
			IF ls_flag_cebef = '1' THEN
				SELECT  count (*) 
					INTO :ll_count
				FROM  centro_beneficio cb
			   WHERE cb.centro_benef = :data
				  AND cb.flag_estado = '1';
						 
			   IF ll_count = 0 THEN
					Messagebox('Aviso','Centro Beneficio No Existe o no se encuentra activo. Por favor Verifique!')
					This.Object.centro_benef [row] = gnvo_app.is_null
					Return 1
				END IF
			END IF
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String  		ls_cod_igv,ls_signo ,ls_cnta_cntbl ,ls_flag_dh_cxp ,ls_desc_cnta,&
				ls_item   ,ls_matriz
Integer 		li_row
Decimal {3} ldc_tasa_impuesto

This.Object.item[al_row] = al_row	
/*Autogeneración de Cuentas*/
ib_estado_prea = TRUE

This.object.confin            [al_row] = is_confin_lc
This.object.tipo_cred_fiscal  [al_row] = is_tipo_cred_fis
This.Object.matriz_cntbl	   [al_row] = is_matriz_cntbl
This.Object.cnta_prsp			[al_row] = is_cnta_prsp_mp
This.Object.cencos				[al_row] = is_cencos_lc
This.object.flag_cebef		   [al_row] = '1'

This.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	

This.object.cod_art.Protect  = 1
//This.object.cantidad.Protect = 1
//This.object.importe.Protect  = 1

//of_genera_impuesto()
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ref_x_pagar dw_ref_x_pagar
end type

on tabpage_2.create
this.dw_ref_x_pagar=create dw_ref_x_pagar
this.Control[]={this.dw_ref_x_pagar}
end on

on tabpage_2.destroy
destroy(this.dw_ref_x_pagar)
end on

type dw_ref_x_pagar from u_dw_abc within tabpage_2
integer width = 2894
integer height = 732
integer taborder = 20
string dataobject = "d_abc_doc_referencias_ctas_pag_tbl"
borderstyle borderstyle = styleraised!
end type

event itemchanged;call super::itemchanged;Accepttext()

end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'm'		  // 'm' = master sin detalle (default), 'd' =  detalle,
	                    // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, form (default)

ii_ss = 1 			// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1		// columnas de lectrua de este dw
ii_ck[2] = 2		// columnas de lectrua de este dw
ii_ck[3] = 3		// columnas de lectrua de este dw
ii_ck[4] = 4		// columnas de lectrua de este dw
ii_ck[5] = 5		// columnas de lectrua de este dw
ii_ck[6] = 6		// columnas de lectrua de este dw
ii_ck[7] = 7		// columnas de lectrua de este dw




idw_mst  = tab_1.tabpage_2.dw_ref_x_pagar			// dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración

This.object.tipo_mov	   	[al_row] = 'P' 		// Pagar
This.object.flab_tabor		[al_row] = '3' 		//Cuentas por Pagar
This.object.tipo_doc			[al_row] = is_doc_lc // Liquidación de compra



end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
long backcolor = 79741120
string text = "Impuestos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_imp_x_pagar dw_imp_x_pagar
end type

on tabpage_3.create
this.dw_imp_x_pagar=create dw_imp_x_pagar
this.Control[]={this.dw_imp_x_pagar}
end on

on tabpage_3.destroy
destroy(this.dw_imp_x_pagar)
end on

type dw_imp_x_pagar from u_dw_abc within tabpage_3
integer width = 2350
integer height = 752
integer taborder = 20
string dataobject = "d_abc_cp_det_imp_tbl"
borderstyle borderstyle = styleraised!
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String  ls_expresion,ls_item,ls_timpuesto,ls_signo,ls_cnta_ctbl,ls_desc_cnta,&
		  ls_flag_dh_cxp, ls_desc_impuesto
Long    ll_found
Decimal ldc_tasa_impuesto, ldc_imp_total,ldc_total

Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado	


CHOOSE CASE dwo.name
	CASE 'tipo_impuesto'
		ls_item = Trim(String(This.object.item [row]))
		
		ls_expresion = "item = " + ls_item + " and tipo_impuesto = '" + data + "'"
		ll_found 	 = This.find(ls_expresion ,1, This.rowcount())				
	
		IF Not(ll_found = row OR ll_found = 0 ) THEN
			Messagebox('Aviso',"Nro de Item: " + ls_item + " ya Tiene Considerado como Tipo de Impuesto en el registro " &
				+ string(ll_found) + ", por favor Verifique!")
				
			This.Object.tipo_impuesto [row] = gnvo_app.is_null
			This.Object.desc_impuesto [row] = gnvo_app.is_null
			This.Object.tasa_impuesto [row] = gnvo_app.idc_null
			This.Object.signo			  [row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  [row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  [row] = gnvo_app.is_null
			This.Object.desc_cnta	  [row] = gnvo_app.is_null
			This.Object.importe		  [row] = gnvo_app.idc_null
			Return 1
		END IF
		
		//Busco el importe correspondiente al item
		ls_expresion = 'item = '+ls_item
		ll_found		 = idw_detail.find(ls_expresion,1,idw_detail.Rowcount())
		
		if ll_found = 0 then
			f_mensaje("Item: " + ls_item + " no existe en el detalle del Documento, por favor verifique!", "")
			This.Object.tipo_impuesto [row] = gnvo_app.is_null
			This.Object.desc_impuesto [row] = gnvo_app.is_null
			This.Object.tasa_impuesto [row] = gnvo_app.idc_null
			This.Object.signo			  [row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  [row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  [row] = gnvo_app.is_null
			This.Object.desc_cnta	  [row] = gnvo_app.is_null
			This.Object.importe		  [row] = gnvo_app.idc_null

			return 1
		end if
									
		
		select t.desc_impuesto, t.cnta_ctbl, cc.desc_cnta, t.tasa_impuesto, t.signo, t.flag_dh_cxp
			into :ls_desc_impuesto, :ls_cnta_ctbl, :ls_desc_cnta, :ldc_tasa_impuesto, :ls_signo, :ls_flag_dh_cxp
		from IMPUESTOS_TIPO t,
			  cntbl_cnta     cc
		where t.cnta_ctbl = cc.cnta_ctbl
		  and t.tipo_impuesto = :data;
		
		if SQLCA.SQLCode = 100 then
			f_mensaje("Error, Tipo de Impuesto " + data + " no existe, por favor verifique!", "")
			This.Object.tipo_impuesto [row] = gnvo_app.is_null
			This.Object.desc_impuesto [row] = gnvo_app.is_null
			This.Object.tasa_impuesto [row] = gnvo_app.idc_null
			This.Object.signo			  [row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  [row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  [row] = gnvo_app.is_null
			This.Object.desc_cnta	  [row] = gnvo_app.is_null
			This.Object.importe		  [row] = gnvo_app.idc_null
			
			return 1
		end if
		
		This.Object.desc_impuesto [row] = ls_desc_impuesto
		This.Object.tasa_impuesto [row] = ldc_tasa_impuesto
		This.Object.signo			  [row] = ls_signo
		This.Object.cnta_ctbl	  [row] = ls_cnta_ctbl
		This.Object.flag_dh_cxp	  [row] = ls_flag_dh_cxp
		This.Object.desc_cnta	  [row] = ls_desc_cnta
		This.Object.importe		  [row] = Round(ldc_imp_total * ldc_tasa_impuesto / 100 ,2)
		
		//Total  
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		wf_total_ref ()
		
	CASE 'importe'						
		//Total  
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		wf_total_ref ()
END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw


idw_mst  = tab_1.tabpage_3.dw_imp_x_pagar	// dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;
This.Object.item 		[al_row] = idw_detail.Object.item [idw_detail.getRow()]


end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_signo, ls_cnta_ctbl, ls_flag_dh_cxp, ls_desc_cnta, &
			ls_expresion, ls_item
Decimal	ldc_tasa_impuesto, ldc_imp_total, ldc_total
Long		ll_found

choose case lower(as_columna)
	case "tipo_impuesto"
		ls_sql = "select t.tipo_impuesto as tipo_impuesto, " &
				 + "t.desc_impuesto as descripcion_impuesto, " &
				 + "t.cnta_ctbl as cnta_cntbl, " &
				 + "cc.desc_cnta as descripcion_Cuenta, " &
				 + "t.tasa_impuesto as tasa_impuesto, " &
				 + "t.signo as signo, " &
				 + "t.flag_dh_cxp as flag_debe_haber " &
				 + "from IMPUESTOS_TIPO t, " &
				 + "cntbl_cnta     cc " &
				 + "where t.cnta_ctbl = cc.cnta_ctbl "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			ls_item = Trim(String(This.object.item [al_row]))
			
			//Valido si el Tipo de Impuesto ya existe
			ls_expresion = "item = " + ls_item + " and tipo_impuesto = '" + ls_codigo + "'"
			ll_found 	 = This.find(ls_expresion ,1, This.rowcount())				
		
			IF Not(ll_found = al_row OR ll_found = 0 ) THEN
				Messagebox('Aviso',"Nro de Item: " + ls_item + " ya Tiene Considerado como Tipo de Impuesto en el registro " &
					+ string(ll_found) + ", por favor Verifique!")
					
				This.Object.tipo_impuesto [al_row] = gnvo_app.is_null
				This.Object.desc_impuesto [al_row] = gnvo_app.is_null
				This.Object.tasa_impuesto [al_row] = gnvo_app.idc_null
				This.Object.signo			  [al_row] = gnvo_app.is_null
				This.Object.cnta_ctbl	  [al_row] = gnvo_app.is_null
				This.Object.flag_dh_cxp	  [al_row] = gnvo_app.is_null
				This.Object.desc_cnta	  [al_row] = gnvo_app.is_null
				This.Object.importe		  [al_row] = gnvo_app.idc_null
				Return 
			END IF


			//Busco el importe correspondiente al item
			ls_expresion = 'item = '+ls_item
			ll_found 	 = This.find(ls_expresion ,1, This.rowcount())	
			if ll_found = 0 then
				gnvo_app.of_mensaje_error("Item: " + ls_item + " no existe en el detalle del Documento, por favor verifique!")
				This.Object.tipo_impuesto [al_row] = gnvo_app.is_null
				This.Object.desc_impuesto [al_row] = gnvo_app.is_null
				This.Object.tasa_impuesto [al_row] = gnvo_app.idc_null
				This.Object.signo			  [al_row] = gnvo_app.is_null
				This.Object.cnta_ctbl	  [al_row] = gnvo_app.is_null
				This.Object.flag_dh_cxp	  [al_row] = gnvo_app.is_null
				This.Object.desc_cnta	  [al_row] = gnvo_app.is_null
				This.Object.importe		  [al_row] = gnvo_app.idc_null
	
				return
			end if
			
			//Inserto los datos indicados
			this.object.tipo_impuesto	[al_row] = ls_codigo
			this.object.desc_impuesto	[al_row] = ls_data
			
			select t.cnta_ctbl, cc.desc_cnta, t.tasa_impuesto, t.signo, t.flag_dh_cxp
				into :ls_cnta_ctbl, :ls_desc_cnta, :ldc_tasa_impuesto, :ls_signo, :ls_flag_dh_cxp
			from 	IMPUESTOS_TIPO t,
			  		cntbl_cnta     cc
			where t.cnta_ctbl = cc.cnta_ctbl
		  	  and t.tipo_impuesto = :ls_codigo;
		
			This.Object.tasa_impuesto [al_row] = ldc_tasa_impuesto
			This.Object.signo			  [al_row] = ls_signo
			This.Object.cnta_ctbl	  [al_row] = ls_cnta_ctbl
			This.Object.flag_dh_cxp	  [al_row] = ls_flag_dh_cxp
			This.Object.desc_cnta	  [al_row] = ls_desc_cnta
			This.Object.importe		  [al_row] = Round(ldc_imp_total * ldc_tasa_impuesto / 100 ,2)
			
			
			//Total  
			ldc_total = wf_totales ()		
			dw_master.object.importe_doc [1] = ldc_total
			dw_master.ii_update = 1
			wf_total_ref ()
		
			this.ii_update = 1
		end if
		
		
		
end choose
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
long backcolor = 79741120
string text = "Totales"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_totales dw_totales
end type

on tabpage_4.create
this.dw_totales=create dw_totales
this.Control[]={this.dw_totales}
end on

on tabpage_4.destroy
destroy(this.dw_totales)
end on

type dw_totales from u_dw_abc within tabpage_4
integer x = 9
integer y = 8
integer width = 2656
integer height = 544
integer taborder = 20
string dataobject = "d_tot_ctas_x_pagar_ext_ff"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'   // tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = dw_master							// dw_master
idw_det  = tab_1.tabpage_4.dw_totales	// dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
long backcolor = 79741120
string text = "Asiento"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pre_asiento_cab dw_pre_asiento_cab
dw_pre_asiento_det dw_pre_asiento_det
end type

on tabpage_5.create
this.dw_pre_asiento_cab=create dw_pre_asiento_cab
this.dw_pre_asiento_det=create dw_pre_asiento_det
this.Control[]={this.dw_pre_asiento_cab,&
this.dw_pre_asiento_det}
end on

on tabpage_5.destroy
destroy(this.dw_pre_asiento_cab)
destroy(this.dw_pre_asiento_det)
end on

type dw_pre_asiento_cab from u_dw_abc within tabpage_5
boolean visible = false
integer x = 5
integer y = 396
integer width = 3081
integer height = 364
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
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

idw_mst = tab_1.tabpage_5.dw_pre_asiento_cab // dw_master
idw_det = tab_1.tabpage_5.dw_pre_asiento_det // dw_detail
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.flag_tabla [al_row] = '3' //Cuentas x Pagar
end event

type dw_pre_asiento_det from u_dw_abc within tabpage_5
integer width = 3081
integer height = 364
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
borderstyle borderstyle = styleraised!
end type

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

idw_mst = tab_1.tabpage_5.dw_pre_asiento_cab // dw_master
idw_det = tab_1.tabpage_5.dw_pre_asiento_det // dw_detail

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()

ib_estado_prea = FALSE   //Pre Asiento editado	
end event

event itemerror;call super::itemerror;Return 1
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
long backcolor = 79741120
string text = "Asientos Auxiliares"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_asiento_aux dw_asiento_aux
end type

on tabpage_6.create
this.dw_asiento_aux=create dw_asiento_aux
this.Control[]={this.dw_asiento_aux}
end on

on tabpage_6.destroy
destroy(this.dw_asiento_aux)
end on

type dw_asiento_aux from u_dw_abc within tabpage_6
integer x = 9
integer y = 8
integer width = 1125
integer height = 756
integer taborder = 20
string dataobject = "d_abc_cntbl_pre_asiento_det_aux_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Long ll_count
Accepttext()


ib_estado_prea = FALSE   //Pre Asiento editado	

CHOOSE CASE dwo.name
		 CASE 'cnta_prsp'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM presupuesto_cuenta
				 WHERE (cnta_prsp = :data ) ;
				 
				IF ll_count = 0 THEN
					Messagebox('Aviso', 'Cuenta Presupuestal No Existe ,Verifique!')
					This.object.cnta_prsp [row] = ''
					Return 2
				END IF
				
		 CASE 'cencos'
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM centros_costo 
				 WHERE (cencos = :data) ;
				
				IF ll_count = 0 THEN
					Messagebox('Aviso', 'Centro de Costo No Existe ,Verifique!')
					This.object.cencos [row] = ''
					Return 2
				END IF
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

idw_mst = tab_1.tabpage_6.dw_asiento_aux // dw_master

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot ,ls_cod_relacion 
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cnta_prsp'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP   AS CUENTA_PRESUPUESTAL ,'&
								      				 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION_CUENTA '&
									   				 +'FROM PRESUPUESTO_CUENTA '&
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					ii_update = 1
					ib_estado_prea = FALSE   //Pre Asiento editado	
				END IF
				
		 CASE	'cencos'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS      AS CENCOS ,'&
								      				 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION    '&
									   				 +'FROM CENTROS_COSTO '&
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					ii_update = 1
					ib_estado_prea = FALSE   //Pre Asiento editado	
				END IF
				
			
END CHOOSE



end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_currow,ll_item

ll_currow = tab_1.tabpage_5.dw_pre_asiento_det.GetRow()
ll_item 	 = tab_1.tabpage_5.dw_pre_asiento_det.Object.item [ll_currow]


This.Object.item [al_row] = ll_item

end event

type gb_1 from groupbox within w_ap315_liquidacion_compra
integer x = 3561
integer y = 68
integer width = 686
integer height = 344
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Referencias"
end type

