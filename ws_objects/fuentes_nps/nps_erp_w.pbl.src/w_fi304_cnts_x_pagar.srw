$PBExportHeader$w_fi304_cnts_x_pagar.srw
forward
global type w_fi304_cnts_x_pagar from w_abc
end type
type gb_1 from groupbox within w_fi304_cnts_x_pagar
end type
type gb_4 from groupbox within w_fi304_cnts_x_pagar
end type
type gb_5 from groupbox within w_fi304_cnts_x_pagar
end type
type dw_master from u_dw_abc within w_fi304_cnts_x_pagar
end type
type pb_oc from picturebutton within w_fi304_cnts_x_pagar
end type
type st_6 from statictext within w_fi304_cnts_x_pagar
end type
type pb_grmp from picturebutton within w_fi304_cnts_x_pagar
end type
type st_5 from statictext within w_fi304_cnts_x_pagar
end type
type pb_2 from picturebutton within w_fi304_cnts_x_pagar
end type
type st_4 from statictext within w_fi304_cnts_x_pagar
end type
type pb_cd from picturebutton within w_fi304_cnts_x_pagar
end type
type st_2 from statictext within w_fi304_cnts_x_pagar
end type
type st_1 from statictext within w_fi304_cnts_x_pagar
end type
type pb_os from picturebutton within w_fi304_cnts_x_pagar
end type
type tab_1 from tab within w_fi304_cnts_x_pagar
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
type tab_1 from tab within w_fi304_cnts_x_pagar
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
end forward

global type w_fi304_cnts_x_pagar from w_abc
integer width = 5221
integer height = 2648
string title = "Proveedores (FI304)"
string menuname = "m_mantenimiento_cl_anular_cp"
event ue_anular ( )
event ue_estado_no_def ( )
event ue_find_exact ( )
event ue_print_detra ( )
event ue_print_voucher ( )
event ue_grmp ( )
gb_1 gb_1
gb_4 gb_4
gb_5 gb_5
dw_master dw_master
pb_oc pb_oc
st_6 st_6
pb_grmp pb_grmp
st_5 st_5
pb_2 pb_2
st_4 st_4
pb_cd pb_cd
st_2 st_2
st_1 st_1
pb_os pb_os
tab_1 tab_1
end type
global w_fi304_cnts_x_pagar w_fi304_cnts_x_pagar

type variables
String  			 is_accion, is_orden_compra, is_orden_serv, is_tip_cred, &
					 is_doc_fap , is_flag_valida_cp, is_flag_valida_cbe, &
					 is_grmp, is_doc_grmp
					 
//Variable de Estado de Transación del Documento
Long 				 il_dias_vencimiento,il_nro_libro_cmp
DatawindowChild idw_tasa ,idw_doc_tipo ,idw_forma_pago
Boolean 			 ib_estado_prea = TRUE

//Pre Asiento No editado					
DataStore		 ids_matriz_cntbl_det , ids_data_glosa,ids_formato_det,&
					 ids_voucher	
uf_asiento_contable if_asiento_contable

end variables

forward prototypes
public subroutine wf_total_ref (decimal adc_total_x_doc)
public function string wf_verifica_user ()
public function decimal wf_totales ()
public function boolean wf_generacion_pre_aux ()
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public subroutine wf_generacion_imp (string as_item)
public subroutine wf_ver_cant_x_oc (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_oc, string as_accion, decimal adc_cantidad, ref string as_flag_cant, ref decimal adc_precio_unit, string as_cencos, string as_cnta_prsp)
public subroutine wf_doc_anticipos ()
public function string of_cbenef_origen (string as_origen)
public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp)
public subroutine wf_estado_prea ()
protected subroutine wf_total_ref_grmp ()
public subroutine wf_find_fecha_presentacion ()
public function boolean of_verifica_documento ()
public function boolean of_verifica_data_oc (ref string as_cod_relacion, ref decimal adc_tasa_cambio)
public function boolean of_generacion_cntas ()
end prototypes

event ue_anular;String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc,ls_cod_relacion
Long    ll_row,ll_row_pasiento,ll_inicio,ll_count
Integer li_opcion


dw_master.Accepttext()
ll_row = dw_master.Getrow()

IF ll_row = 0 OR is_accion = 'new' THEN RETURN 

ls_flag_estado = dw_master.object.flag_estado[ll_row]


IF Not(ls_flag_estado = '1' OR ls_flag_estado = '0') THEN RETURN 

IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 1 OR &
	 tab_1.tabpage_2.dw_ref_x_pagar.ii_update = 1 OR tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1 OR &
	 tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 OR tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 OR &
	 tab_1.tabpage_6.dw_asiento_aux.ii_update = 1 ) THEN
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
		 
/**/

IF ll_count > 0 THEN
	Messagebox('Aviso','Documento Tiene Transaciones Realizadas ,Verifique!')
   Return
END IF


/*Elimino Cabecera de Cntas x pagar*/
DO WHILE dw_master.Rowcount() > 0
	dw_master.Deleterow(0)
LOOP

/*Elimino detalle de Cntas x pagar*/
DO WHILE tab_1.tabpage_1.dw_ctas_pag_det.Rowcount() > 0
	tab_1.tabpage_1.dw_ctas_pag_det.Deleterow(0)
LOOP

/*Elimino Impuesto de Cntas Pagar*/
DO WHILE tab_1.tabpage_3.dw_imp_x_pagar.Rowcount() > 0
	tab_1.tabpage_3.dw_imp_x_pagar.Deleterow(0)
LOOP

/*Elimino documentos de Referencias*/
DO WHILE tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0
	tab_1.tabpage_2.dw_ref_x_pagar.Deleterow(0)
LOOP

//Cabecera de Asiento
tab_1.tabpage_5.dw_pre_asiento_cab.Object.flag_estado	 [1] = '0'
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_solhab	 [1] = 0.00
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_dolhab	 [1] = 0.00
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_soldeb	 [1] = 0.00
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_doldeb   [1] = 0.00

//Detalle de Asiento
FOR ll_inicio = 1 TO tab_1.tabpage_5.dw_pre_asiento_det.Rowcount()
  	 tab_1.tabpage_5.dw_pre_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
  	 tab_1.tabpage_5.dw_pre_asiento_det.Object.imp_movdol [ll_inicio] = 0.00		
NEXT

///*Elimino documentos de Referencias*/
DO WHILE tab_1.tabpage_6.dw_asiento_aux.Rowcount() > 0
	  tab_1.tabpage_6.dw_asiento_aux.Deleterow(0)
LOOP

is_accion = 'delete'
//* Inicialización de Variables de Modificación de Data *//
dw_master.ii_update  								= 1
tab_1.tabpage_1.dw_ctas_pag_det.ii_update 	= 1
tab_1.tabpage_2.dw_ref_x_pagar.ii_update  	= 1
tab_1.tabpage_3.dw_imp_x_pagar.ii_update  	= 1
tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1
tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1
tab_1.tabpage_6.dw_asiento_aux.ii_update     = 1



ib_estado_prea = TRUE   //Autogeneración de Pre Asientos

tab_1.tabpage_5.dw_pre_asiento_det.ii_protect = 0
tab_1.tabpage_5.dw_pre_asiento_det.of_protect()


end event

event ue_estado_no_def();dw_master.ii_update = 0
tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 0
tab_1.tabpage_2.dw_ref_x_pagar.ii_update  = 0
tab_1.tabpage_3.dw_imp_x_pagar.ii_update  = 0
tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 0
tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 0
tab_1.tabpage_6.dw_asiento_aux.ii_update     = 0
end event

event ue_find_exact();// Asigna valores a structura 
String ls_tipo_doc,ls_nro_doc,ls_origen,ls_cod_relacion
Long   ll_row_master,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,ll_inicio
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

	tab_1.tabpage_1.dw_ctas_pag_det.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	tab_1.tabpage_2.dw_ref_x_pagar.Retrieve(ls_tipo_doc,ls_nro_doc,ls_cod_relacion)
	tab_1.tabpage_3.dw_imp_x_pagar.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	tab_1.tabpage_5.dw_pre_asiento_cab.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)
	tab_1.tabpage_5.dw_pre_asiento_det.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)
	tab_1.tabpage_6.dw_asiento_aux.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)	
	
	//**//
	IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
		FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_ctas_pag_det.Rowcount()
			 tab_1.tabpage_1.dw_ctas_pag_det.object.flag_hab [ll_inicio] = '1'
		NEXT
	END IF	
	//**//
	
	ib_estado_prea = False   //asiento editado					
	TriggerEvent('ue_modify')
	is_accion = 'fileopen'	
ELSE
	dw_master.Reset()
	tab_1.tabpage_1.dw_ctas_pag_det.Reset()
	tab_1.tabpage_2.dw_ref_x_pagar.Reset()
	tab_1.tabpage_3.dw_imp_x_pagar.Reset()
	tab_1.tabpage_5.dw_pre_asiento_cab.Reset()
	tab_1.tabpage_5.dw_pre_asiento_det.Reset()
	tab_1.tabpage_6.dw_asiento_aux.Reset()
	ib_estado_prea = False   //asiento editado		
END IF





	


end event

event ue_print_detra();String ls_nro_detrac

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_nro_detrac = dw_master.object.nro_detraccion[dw_master.getrow()]

IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
	Messagebox('Aviso','No existe Detraccion Verifique!')
END IF

ids_formato_det.Retrieve(ls_nro_detrac)
ids_formato_det.object.t_nombre.text = gnvo_app.invo_empresa.is_empresa
ids_formato_det.object.t_user.text = gnvo_app.is_user
ids_formato_det.Print(True)
end event

event ue_print_voucher();String ls_origen
Long   ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_origen 		= dw_master.object.origen 	    [dw_master.getrow()]
ll_ano			= dw_master.object.ano	  	    [dw_master.getrow()]
ll_mes			= dw_master.object.mes	  	    [dw_master.getrow()]
ll_nro_libro	= dw_master.object.nro_libro   [dw_master.getrow()]
ll_nro_asiento	= dw_master.object.nro_asiento [dw_master.getrow()]


ids_voucher.retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,gnvo_app.invo_empresa.is_empresa)

ids_voucher.Object.p_logo.filename = gnvo_app.is_logo

if ids_voucher.rowcount() = 0 then 
	messagebox('Aviso','VOucher no tiene registro Verifique')
	return
end if


ids_voucher.Print(True)

end event

event ue_grmp();//Evento para mostrar las guias de Recepción de Materia Prima (GRMP)

String  		ls_tipo_doc_oc, ls_tipo_ref, ls_cod_cliente, ls_cod_moneda, &
				ls_result, ls_mensaje, ls_tipo_doc_os, ls_tipo_doc_mov_alm //,&ls_flag_os
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_total
Long        ll_row, ll_ano, ll_mes

str_parametros sl_param

IF of_verifica_data_oc (ls_cod_cliente, ldc_tasa_cambio) = FALSE THEN Return

ll_row = dw_master.Getrow()
ll_ano = dw_master.object.ano [ll_row]
ll_mes = dw_master.object.mes [ll_row]

/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	Return
END IF

// Parametro de tipo de documento Guia de Recepción de Materia Prima
SELECT DOC_GUIA_MP
INTO :is_doc_grmp
FROM ap_param
WHERE origen = 'XX';

IF Isnull(is_doc_grmp) OR Trim(is_doc_grmp) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Guia de Recepción en Tabla de Parametros APPARAM, Comuniquese Con Sistemas!')
	Return		
END IF

//Parametro de tipo de documento movimiento de Almacen
SELECT doc_mov_almacen
 INTO  :ls_tipo_doc_mov_alm
FROM logparam
WHERE reckey = '1';

IF Isnull(ls_tipo_doc_mov_alm) OR Trim(ls_tipo_doc_mov_alm) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Movimiento de Almacen en Tabla de Parametros LOGPARAM, Comuniquese Con Sistemas!')
	Return		
END IF
//


IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
	/*Recuperacion de Tipo doc Orden Servicio*/
	SELECT doc_os 
	  INTO :ls_tipo_doc_os
	  FROM logparam
	 WHERE (reckey = '1' ) ;
	 
	IF Isnull(ls_tipo_doc_os) OR Trim(ls_tipo_doc_os) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Orden de Servicio en Tabla de Parametros LOGPARAM, Comuniquese Con Sistemas!')
		Return		
	END IF
	/**/
	
	/*Recuperacion de Tipo doc Orden Compra*/
	SELECT doc_oc 
	  INTO :ls_tipo_doc_oc
	  FROM logparam
	 WHERE (reckey = '1' ) ;
	
	IF Isnull(ls_tipo_doc_oc) OR Trim(ls_tipo_doc_oc) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Orden de Compra en Tabla de Parametros LOGPARAM, Comuniquese Con Sistemas!')
		Return		
	END IF
	/**/
	
	ls_tipo_ref = tab_1.tabpage_2.dw_ref_x_pagar.Object.tipo_ref[1]
	IF ls_tipo_ref = ls_tipo_doc_os OR ls_tipo_ref = ls_tipo_doc_oc THEN
		Messagebox('Aviso','No Puede Seleccionar Una Guia de Recepción de Materia Prima , Verifique!')
		RETURN
	END IF
	
	is_grmp = tab_1.tabpage_2.dw_ref_x_pagar.Object.nro_ref[1]
ELSE
	SetNull(is_grmp)
END IF

sl_param.tipo			= '1S'
sl_param.opcion		= 24         //GRMP  ANTES 14
sl_param.titulo 		= 'Selección de Guia de Recepción de Materia Prima'
sl_param.dw_master	= 'd_abc_lista_guia_recepcion_tbl'
sl_param.dw1			= 'd_abc_lista_guia_recepcion_det_tbl'
sl_param.dw_m			= dw_master
sl_param.dw_d			= tab_1.tabpage_1.dw_ctas_pag_det
sl_param.dw_c			= tab_1.tabpage_2.dw_ref_x_pagar
sl_param.string1		= ls_cod_cliente
sl_param.string2		= is_grmp
sl_param.string3		= is_doc_grmp
sl_param.string4		= ls_tipo_doc_mov_alm
sl_param.db1			= ldc_tasa_cambio
sl_param.w1				= This

dw_master.Accepttext()

OpenWithParm( w_abc_seleccion_md, sl_param)
IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.titulo = 's' THEN
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	dw_master.ii_update = 1
	wf_total_ref_grmp ()
	tab_1.tabpage_1.dw_ctas_pag_det.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")
END IF

end event

public subroutine wf_total_ref (decimal adc_total_x_doc);String      ls_moneda_master, ls_moneda_ref,ls_soles,ls_dolares
Long        ll_row_master , ll_row_ref
Decimal {3} ldc_tasa_cambio


f_monedas(ls_soles,ls_dolares)


IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
	ll_row_master = dw_master.Getrow()
	ll_row_ref	  = tab_1.tabpage_2.dw_ref_x_pagar.Getrow()

	ls_moneda_master = dw_master.object.cod_moneda 									[ll_row_master]
	ldc_tasa_cambio  = dw_master.object.tasa_cambio 								[ll_row_master]
	ls_moneda_ref	  = tab_1.tabpage_2.dw_ref_x_pagar.object.cod_moneda_det	[ll_row_ref	  ]
	
	IF ls_moneda_master = ls_moneda_ref THEN
		tab_1.tabpage_2.dw_ref_x_pagar.object.importe [ll_row_ref] = Round(adc_total_x_doc,2)	
	ELSEIF ls_moneda_ref = ls_soles		THEN
		tab_1.tabpage_2.dw_ref_x_pagar.object.importe [ll_row_ref] = Round(adc_total_x_doc * ldc_tasa_cambio,2)
	ELSEIF ls_moneda_ref = ls_dolares	THEN
		tab_1.tabpage_2.dw_ref_x_pagar.object.importe [ll_row_ref] = Round(adc_total_x_doc / ldc_tasa_cambio,2)
	END IF
	
	
	tab_1.tabpage_2.dw_ref_x_pagar.ii_update =1	                
END IF    

end subroutine

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
		      ldc_total_bruto     = 0.00, ldc_total_general = 0.00


tab_1.tabpage_4.dw_totales.Reset()
tab_1.tabpage_4.dw_totales.Insertrow(0)



FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_ctas_pag_det.Rowcount()
	
	 ldc_bruto 		= Round(tab_1.tabpage_1.dw_ctas_pag_det.object.total [ll_inicio],2)
	 
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
	 
NEXT


FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_imp_x_pagar.Rowcount()
	
	 ldc_impuesto = tab_1.tabpage_3.dw_imp_x_pagar.Object.importe [ll_inicio]
	 ls_signo	  = tab_1.tabpage_3.dw_imp_x_pagar.Object.signo   [ll_inicio]	
	 
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

DO WHILE tab_1.tabpage_6.dw_asiento_aux.rowcount() > 0
	tab_1.tabpage_6.dw_asiento_aux.deleterow(0)

LOOP

///***************************///
IF is_accion = 'fileopen' THEN
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
   	IF tab_1.tabpage_6.dw_asiento_aux.Update() = -1 THEN
			Messagebox('Aviso','Fallo Autogeneración de Asientos Auxiliares ,Comuniquese Con Sistemas')
			lb_retorno = FALSE
			GOTO SALIDA
		END IF
	END IF
	
END IF			  




/*Verificación de Pre - Asientos Generados**/
FOR ll_inicio = 1 TO tab_1.tabpage_5.dw_pre_asiento_det.Rowcount()
	 li_item   = tab_1.tabpage_5.dw_pre_asiento_det.object.item   [ll_inicio]
	 ls_cencos = tab_1.tabpage_5.dw_pre_asiento_det.object.cencos [ll_inicio]
	 
	 IF Not(Isnull(ls_cencos) OR Trim(ls_cencos) = '') THEN
		/**Verificación de Flag Presupuestal de Centro de Costo**/
		SELECT flag_cta_presup
		  INTO :ls_flag_presup 
		  FROM centros_costo
		 WHERE (cencos = :ls_cencos) ;
		
		 
		IF ls_flag_presup = '1' THEN
			ll_row = tab_1.tabpage_6.dw_asiento_aux.InsertRow(0)
			tab_1.tabpage_6.dw_asiento_aux.object.item [ll_row] = li_item
			tab_1.tabpage_6.dw_asiento_aux.ii_update = 1
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

public subroutine wf_generacion_imp (string as_item);String      ls_item,ls_expresion
Long 			ll_inicio,ll_found
Decimal {2} ldc_total,ldc_tasa_impuesto


ls_expresion = 'item = '+as_item

tab_1.tabpage_3.dw_imp_x_pagar.Setfilter(ls_expresion)
tab_1.tabpage_3.dw_imp_x_pagar.filter()
Setnull(ls_expresion)
	
FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_imp_x_pagar.Rowcount()
	 tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1
	 ls_item		  = Trim(String(tab_1.tabpage_3.dw_imp_x_pagar.object.item [ll_inicio]))
	 ls_expresion = 'item = ' + ls_item
	 ll_found 	  = tab_1.tabpage_1.dw_ctas_pag_det.find(ls_expresion ,1,tab_1.tabpage_1.dw_ctas_pag_det.rowcount())
	 IF ll_found > 0 THEN
		 ldc_tasa_impuesto = tab_1.tabpage_3.dw_imp_x_pagar.object.tasa_impuesto [ll_inicio]
		 ldc_total			 = tab_1.tabpage_1.dw_ctas_pag_det.object.total		    [ll_found]
		 tab_1.tabpage_3.dw_imp_x_pagar.object.importe [ll_inicio] = Round((ldc_total * ldc_tasa_impuesto ) / 100 ,2)
	 END IF			 
NEXT
	
tab_1.tabpage_3.dw_imp_x_pagar.Setfilter('')
tab_1.tabpage_3.dw_imp_x_pagar.filter()


tab_1.tabpage_3.dw_imp_x_pagar.SetSort('item a')
tab_1.tabpage_3.dw_imp_x_pagar.Sort()


end subroutine

public subroutine wf_ver_cant_x_oc (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_oc, string as_accion, decimal adc_cantidad, ref string as_flag_cant, ref decimal adc_precio_unit, string as_cencos, string as_cnta_prsp);DECLARE PB_USP_FIN_CANT_X_ART_X_OC PROCEDURE FOR USP_FIN_CANT_X_ART_X_OC 
(:as_tipo_doc,:as_nro_doc,:as_cod_art,:as_nro_oc,:as_accion,:adc_cantidad,:as_cencos,:as_cnta_prsp);
EXECUTE PB_USP_FIN_CANT_X_ART_X_OC ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_CANT_X_ART_X_OC INTO :as_flag_cant ,:adc_precio_unit ;
CLOSE PB_USP_FIN_CANT_X_ART_X_OC ;
end subroutine

public subroutine wf_doc_anticipos ();String ls_origen_ref,ls_nro_ref,ls_doc_ant_oc ,ls_doc_ant_os,ls_doc_oc,ls_doc_os,ls_tipo_ref
Long 	 ll_inicio
Decimal {2} ldc_saldo_sol,ldc_saldo_dol


/*PARAMETROS*/
select doc_oc,doc_os                   into :ls_doc_oc     ,:ls_doc_os     from logparam where reckey = '1' ;
select doc_anticipo_oc,doc_anticipo_os into :ls_doc_ant_oc ,:ls_doc_ant_os from finparam where reckey = '1' ;

for ll_inicio = 1 to tab_1.tabpage_2.dw_ref_x_pagar.rowcount( )
	 ls_origen_ref = tab_1.tabpage_2.dw_ref_x_pagar.object.origen_ref [ll_inicio]
	 ls_tipo_ref	= tab_1.tabpage_2.dw_ref_x_pagar.object.tipo_ref   [ll_inicio]
	 ls_nro_ref 	= tab_1.tabpage_2.dw_ref_x_pagar.object.nro_ref 	[ll_inicio]
	 
	 if ls_tipo_ref = ls_doc_oc then
		 select sum(saldo_sol),sum(saldo_dol) into :ldc_saldo_sol,:ldc_saldo_dol
	      from cntas_pagar cp,doc_referencias dr
	     where (cp.cod_relacion 	  = dr.cod_relacion ) and
	  		     (cp.tipo_doc 	 	  = dr.tipo_doc 	  ) and
			     (cp.nro_doc      	  = dr.nro_doc  	  ) and	 
				  (cp.flag_caja_bancos = '1' 				  ) and
				  (cp.flag_estado		  = '1'				  ) and
			     (dr.tipo_ref		 	  = :ls_doc_oc		  ) and
			     (cp.tipo_doc		 	  = :ls_doc_ant_oc  ) and
			     (dr.origen_ref	 	  = :ls_origen_ref  ) and
			     (dr.nro_ref		 	  = :ls_nro_ref	  ) ;
			  
	 elseif ls_tipo_ref = ls_doc_os then
		 select sum(saldo_sol),sum(saldo_dol) into :ldc_saldo_sol,:ldc_saldo_dol
	      from cntas_pagar cp,doc_referencias dr
	     where (cp.cod_relacion     = dr.cod_relacion ) and
	  		     (cp.tipo_doc 	     = dr.tipo_doc 	  ) and
			     (cp.nro_doc          = dr.nro_doc  	  ) and	 
				  (cp.flag_caja_bancos = '1' 			     ) and
				  (cp.flag_estado		  = '1'			     ) and
			     (dr.tipo_ref		     = :ls_doc_os		  ) and
			     (cp.tipo_doc		     = :ls_doc_ant_os  ) and
			     (dr.origen_ref	     = :ls_origen_ref  ) and
			     (dr.nro_ref		     = :ls_nro_ref	  ) ;

		
	 end if
	 
	 //
	  
		
	
	 
	 if ldc_saldo_sol > 0 or ldc_saldo_dol > 0 then
		 dw_master.object.saldo_aplicado_sol [dw_master.Getrow()] = ldc_saldo_sol
		 dw_master.object.saldo_aplicado_dol [dw_master.Getrow()] = ldc_saldo_dol
	
		 dw_master.ii_update = 1
	 end if
	 
	 
next
end subroutine

public function string of_cbenef_origen (string as_origen);String ls_cen_ben

select cen_bef_gen_oc into :ls_cen_ben
  from origen where cod_origen = :as_origen ;
  

Return ls_cen_ben  
end function

public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp);Long ll_count 

select Count(*) 
  into :ll_count 
  from presupuesto_partida pp,tipo_prtda_prsp_det ttd
 where (pp.tipo_prtda_prsp = ttd.tipo_prtda_prsp ) and
       (ttd.grp_prtda_prsp = (select ppa.grp_prtda_prsp_fondos from  presup_param ppa)) and
       (pp.ano             = :al_ano             ) and
       (pp.cencos          = :as_cencos          ) and
       (pp.cnta_prsp       = :as_cnta_prsp       ) ;
		 
		 
Return ll_count
end function

public subroutine wf_estado_prea ();ib_estado_prea = TRUE
end subroutine

protected subroutine wf_total_ref_grmp ();// Totales por documentos de referencia
String      ls_moneda_master, ls_moneda_ref, ls_soles,ls_dolares, &
				ls_nro_guia, ls_tipo_doc_guia, ls_nro_ref, ls_nro_doc_cxp, &
				ls_doc_mov_alm, ls_expresion
Long        ll_row_master , ll_j, ll_row_ref, ll_nro_item, ll_found
Decimal {3} ldc_tasa_cambio, ldc_importe, ldc_monto_soles

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
	ls_moneda_master = dw_master.object.cod_moneda  [ll_row_master]
	ldc_tasa_cambio  = dw_master.object.tasa_cambio [ll_row_master]
	
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
			IF ls_moneda_master = ls_moneda_ref THEN
				ldc_importe = ldw_cntas_pagar.object.importe[ll_j]
			ELSEIF ls_moneda_ref = ls_soles		THEN
				ldc_importe = Round(ldw_cntas_pagar.object.importe[ll_j] * ldc_tasa_cambio,2)
			ELSEIF ls_moneda_ref = ls_dolares	THEN
				ldc_importe = Round(ldw_cntas_pagar.object.importe[ll_j] / ldc_tasa_cambio,2)
			END IF
		
			ldc_importe = ldc_importe + ldw_referencias.object.importe [ll_found]
			ldw_referencias.object.importe [ll_found] = ldc_importe
			
		END IF
	NEXT		
	ldw_referencias.ii_update =1	                
END IF    
end subroutine

public subroutine wf_find_fecha_presentacion ();String ls_cod_relacion,ls_tipo_doc,ls_nro_doc
Long 	 ll_count
Date 	 ld_fecha_recepcion 


//recupero codigo de relacion tipo nro doc
ls_cod_relacion = dw_master.object.cod_relacion [1]
ls_tipo_doc 	 = dw_master.object.tipo_doc 		[1]
ls_nro_doc  	 = dw_master.object.nro_doc 		[1]

select count(*) into :ll_count from cd_doc_recibido cd
where (cd.cod_relacion = :ls_cod_relacion ) and
      (cd.tipo_doc     = :ls_tipo_doc     ) and
      (cd.nro_doc      = :ls_nro_doc		) ;

if ll_count > 0 then
	select fecha_recepcion into :ld_fecha_recepcion from cd_doc_recibido cd
	 where (cd.cod_relacion = :ls_cod_relacion ) and
          (cd.tipo_doc     = :ls_tipo_doc     ) and
          (cd.nro_doc      = :ls_nro_doc		 ) ;
	
	dw_master.object.fecha_presentacion [1] = ld_fecha_recepcion
			 
else
	dw_master.object.fecha_presentacion [1] = dw_master.object.fecha_emision [1]
end if	


dw_master.ii_update = 1
dw_master.ACCEPTTEXT()
end subroutine

public function boolean of_verifica_documento ();Boolean lb_ret =  TRUE
String  ls_cod_relacion,ls_tipo_doc,ls_nro_doc
Long    ll_nro_libro,ll_count

ls_cod_relacion = dw_master.object.cod_relacion [1]
ls_tipo_doc	 	 = dw_master.object.tipo_doc 	   [1]
ls_nro_doc	 	 = trim(dw_master.object.nro_doc [1])
ll_nro_libro	 = dw_master.object.nro_libro  	[1]
					

//verifica tramite documentario
if (ll_nro_libro = il_nro_libro_cmp and ls_tipo_doc = is_doc_fap and is_flag_valida_cp = '1'  ) then
	select count(*) into :ll_count from cd_doc_recibido c
	 where (c.cod_relacion  = :ls_cod_relacion ) and
	 		 (c.tipo_doc	   = :ls_tipo_doc		 ) and
			 (trim(c.nro_doc) = :ls_nro_doc		 ) ;
							 
					
	if ll_count = 0 then
		Messagebox('Aviso','Verifique Documento no se encuentra en Tramite Documentario')						
		lb_ret = False
		GOTO SALIDA
	end if
end if
					
					
//VERIFIQUE SI EXISTE
select Count(*) into :ll_count from cntas_pagar
 where (cod_relacion = :ls_cod_relacion  ) and
 		 (tipo_doc		= :ls_tipo_doc      ) and
		 (nro_doc		= :ls_nro_doc		  ) ;
			
if ll_count > 0 then
	Messagebox('Aviso','Verifique Documento ya ha sido Registrado')						
	lb_ret = False
	GOTO SALIDA
end if					

SALIDA:

Return lb_ret
end function

public function boolean of_verifica_data_oc (ref string as_cod_relacion, ref decimal adc_tasa_cambio);/*******************************************************/
/*Funcion de Ventana creada con el fin de Verificar    */
/*que Proveedor ,Moneda ,Tasa Cambio esten Ingresados  */
/*y Estado Este Activo para poder Invocar un Documento */
/*******************************************************/

Boolean lb_ret = TRUE
Long 	  ll_row
String  ls_flag_estado


ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN FALSE

as_cod_relacion = dw_master.Object.cod_relacion [ll_row] 
adc_tasa_cambio =	dw_master.Object.tasa_cambio  [ll_row]
ls_flag_estado	 = dw_master.Object.flag_estado  [ll_row]

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

Return lb_ret
end function

public function boolean of_generacion_cntas ();Long    ll_row,ll_count
String  ls_moneda,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_campo_formula,&
		  ls_cencos,ls_cebef
Decimal ldc_tasa_cambio
Boolean lb_retorno

ll_row   = dw_master.Getrow()

dw_master.Accepttext()
tab_1.tabpage_1.dw_ctas_pag_det.Accepttext()
tab_1.tabpage_3.dw_imp_x_pagar.Accepttext()


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
IF f_row_Processing( tab_1.tabpage_1.dw_ctas_pag_det, "tabular") <> true then	
	tab_1.SelectTab(1)
END IF

ls_tipo_doc 	  = dw_master.object.tipo_doc     [ll_row]
ls_nro_doc  	  = dw_master.object.nro_doc	    [ll_row]  
ls_cod_relacion  = dw_master.object.cod_relacion [ll_row]
ls_campo_formula = 'tipo_impuesto'
///**/

lb_retorno  = f_generacion_ctas_cxc_cxp (dw_master, tab_1.tabpage_1.dw_ctas_pag_det, tab_1.tabpage_2.dw_ref_x_pagar, tab_1.tabpage_3.dw_imp_x_pagar, tab_1.tabpage_5.dw_pre_asiento_det, ids_matriz_cntbl_det,ids_data_glosa,ls_moneda,ldc_tasa_cambio,ls_campo_formula,tab_1,'P',ls_cencos,ls_cebef)

IF lb_retorno = TRUE THEN
	tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1
	tab_1.tabpage_5.dw_pre_asiento_det.SetSort('item a,cnta_ctbl a')
	/**Generación de Pre Asientos Auxiliares**/
	wf_generacion_pre_aux ()
	/****/
END IF


Return lb_retorno
end function

on w_fi304_cnts_x_pagar.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_cp" then this.MenuID = create m_mantenimiento_cl_anular_cp
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_5=create gb_5
this.dw_master=create dw_master
this.pb_oc=create pb_oc
this.st_6=create st_6
this.pb_grmp=create pb_grmp
this.st_5=create st_5
this.pb_2=create pb_2
this.st_4=create st_4
this.pb_cd=create pb_cd
this.st_2=create st_2
this.st_1=create st_1
this.pb_os=create pb_os
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.pb_oc
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.pb_grmp
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.pb_cd
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.pb_os
this.Control[iCurrent+15]=this.tab_1
end on

on w_fi304_cnts_x_pagar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.dw_master)
destroy(this.pb_oc)
destroy(this.st_6)
destroy(this.pb_grmp)
destroy(this.st_5)
destroy(this.pb_2)
destroy(this.st_4)
destroy(this.pb_cd)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_os)
destroy(this.tab_1)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - this.cii_windowborder
tab_1.height = p_pie.y - tab_1.y

tab_1.tabpage_1.dw_ctas_pag_det.width     = tab_1.tabpage_1.width   - tab_1.tabpage_1.dw_ctas_pag_det.x
tab_1.tabpage_1.dw_ctas_pag_det.height    = tab_1.tabpage_1.height  - tab_1.tabpage_1.dw_ctas_pag_det.y

tab_1.tabpage_2.dw_ref_x_pagar.width      = tab_1.tabpage_2.width  - tab_1.tabpage_2.dw_ref_x_pagar.x
tab_1.tabpage_2.dw_ref_x_pagar.height     = tab_1.tabpage_2.height  - tab_1.tabpage_2.dw_ref_x_pagar.y

tab_1.tabpage_3.dw_imp_x_pagar.Width      = tab_1.tabpage_3.width - tab_1.tabpage_3.dw_imp_x_pagar.x
tab_1.tabpage_3.dw_imp_x_pagar.height     = tab_1.tabpage_3.height - tab_1.tabpage_3.dw_imp_x_pagar.y

tab_1.tabpage_4.dw_totales.width     		= tab_1.tabpage_4.width   - tab_1.tabpage_4.dw_totales.x
tab_1.tabpage_4.dw_totales.height         = tab_1.tabpage_4.height  - tab_1.tabpage_4.dw_totales.y

tab_1.tabpage_5.dw_pre_asiento_det.width  = tab_1.tabpage_5.width   - tab_1.tabpage_5.dw_pre_asiento_det.x
tab_1.tabpage_5.dw_pre_asiento_det.height = tab_1.tabpage_5.height  - tab_1.tabpage_5.dw_pre_asiento_det.y

tab_1.tabpage_6.dw_asiento_aux.width      = tab_1.tabpage_6.width  - tab_1.tabpage_6.dw_asiento_aux.x
tab_1.tabpage_6.dw_asiento_aux.height     = tab_1.tabpage_6.height  - tab_1.tabpage_6.dw_asiento_aux.y
end event

event ue_open_pre;call super::ue_open_pre;String ls_mensaje


dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_ctas_pag_det.SettransObject(sqlca)
tab_1.tabpage_2.dw_ref_x_pagar.SettransObject(sqlca)
tab_1.tabpage_3.dw_imp_x_pagar.SettransObject(sqlca)
tab_1.tabpage_5.dw_pre_asiento_cab.SettransObject(sqlca)
tab_1.tabpage_5.dw_pre_asiento_det.SettransObject(sqlca)
tab_1.tabpage_6.dw_asiento_aux.SettransObject(sqlca)

//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)
//** **//
//** Datastore de Glosa **//
ids_data_glosa = Create Datastore
ids_data_glosa.DataObject = 'd_data_glosa_grd'
ids_data_glosa.SettransObject(sqlca)
//** **//


//** Datastore Formato Detraccion **//
ids_formato_det = Create Datastore
ids_formato_det.DataObject = 'd_rpt_formato_detraccion_x_pagar_tbl'
ids_formato_det.SettransObject(sqlca)
////** **//

//** Datastore Voucher **//
ids_voucher = Create Datastore
ids_voucher.DataObject = 'd_rpt_voucher_imp_cp_tbl'
ids_voucher.SettransObject(sqlca)


ls_mensaje = wf_verifica_user ()

IF Not(Isnull(ls_mensaje) OR Trim(ls_mensaje) = '' ) THEN
	Messagebox('Aviso',ls_mensaje)
END IF

//** Insertamos GetChild de Tipo de Documento dw_master **//
dw_master.Getchild('tipo_doc',idw_doc_tipo )
idw_doc_tipo.settransobject(sqlca)
idw_doc_tipo.Retrieve()
//** **//
	
//** Insertamos GetChild de Forma de Pago **//
dw_master.Getchild('forma_pago',idw_forma_pago)
idw_forma_pago.settransobject(sqlca)
idw_forma_pago.Retrieve()
//** **//

//** Insertamos GetChild de Tasa de Impuesto Tab 3 **//
tab_1.tabpage_3.dw_imp_x_pagar.Getchild('tipo_impuesto',idw_tasa )
idw_tasa.settransobject(sqlca)
idw_tasa.Retrieve()
//** **//

idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_ctas_pag_det.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
//TriggerEvent('ue_insert')


of_position_window(0,0)       			// Posicionar la ventana en forma fija

//Crear Objeto
if_asiento_contable = create uf_asiento_contable

// Obtengo los parámetros iniciales
select libro_compras,doc_fact_pagar
	into :il_nro_libro_cmp,:is_doc_fap
from finparam f 
where (f.reckey = '1') ;
 
// Este flag indica si se valida el documento CP con el control documentario
select flag_valida_cp 
	into :is_flag_valida_cp 
from cdparam 
where reckey = '1' ;  

select flag_centro_benef 
	into :is_flag_valida_cbe 
from logparam 
where reckey = '1' ;


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
				tab_1.tabpage_1.dw_ctas_pag_det.Reset	()
				tab_1.tabpage_2.dw_ref_x_pagar.Reset	()
				tab_1.tabpage_3.dw_imp_x_pagar.Reset	()
				tab_1.tabpage_4.dw_totales.Reset()
				tab_1.tabpage_5.dw_pre_asiento_cab.Reset ()
				tab_1.tabpage_5.dw_pre_asiento_det.Reset ()
				is_accion = 'new'
				ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
				
 		 CASE tab_1.tabpage_1.dw_ctas_pag_det
			
				
			   IF ll_row = 0 THEN RETURN
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ll_ano			= dw_master.object.ano 			 [ll_row]
				ll_mes			= dw_master.object.mes 			 [ll_row]

				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				IF ls_flag_estado <> '1' OR tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
				ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
		 CASE tab_1.tabpage_3.dw_imp_x_pagar
			
				ll_currow = tab_1.tabpage_1.dw_ctas_pag_det.GetRow()
				lb_result = tab_1.tabpage_1.dw_ctas_pag_det.IsSelected(ll_currow)
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ll_ano			= dw_master.object.ano 			 [ll_row]
				ll_mes			= dw_master.object.mes 			 [ll_row]

				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

				IF lb_result = FALSE then
					Messagebox('Aviso','Debe Seleccionar Un documento para generar su Respectivo Interes')
					Return
				END IF
				ib_estado_prea = TRUE    //Pre Asiento No editado	Autogeneración				
				/**/
		 CASE	tab_1.tabpage_6.dw_asiento_aux
				ll_currow = tab_1.tabpage_5.dw_pre_asiento_det.GetRow()
				lb_result = tab_1.tabpage_5.dw_pre_asiento_det.IsSelected(ll_currow)
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ll_ano			= dw_master.object.ano 			 [ll_row]
				ll_mes			= dw_master.object.mes 			 [ll_row]

				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
				
				ib_estado_prea = TRUE
				
				IF lb_result = FALSE THEN RETURN
				
				
		 CASE	ELSE
				Return
END CHOOSE


ll_row = idw_1.Event ue_insert()
IF idw_1 = dw_master THEN
	idw_1.Setcolumn('tipo_doc')
ELSEIF idw_1 = tab_1.tabpage_1.dw_ctas_pag_det THEN
	idw_1.Setcolumn('descripcion')
END IF

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_insert_pos(long al_row);call super::ue_insert_pos;IF idw_1 = dw_master THEN
	tab_1.tabpage_5.dw_pre_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_delete;//Override
Long   ll_row,ll_ano,ll_mes
String ls_flag_estado, ls_item ,ls_expresion_imp,ls_result,ls_mensaje

CHOOSE CASE idw_1
		 CASE tab_1.tabpage_1.dw_ctas_pag_det
			
				ll_row = idw_1.Getrow()
				IF ll_row = 0 THEN RETURN		
				ls_flag_estado = dw_master.object.flag_estado [1]
				
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

				//Eliminar impuesto del item a eliminar
				ls_item			   = Trim(String(tab_1.tabpage_1.dw_ctas_pag_det.object.item [ll_row]))
				ls_expresion_imp = 'item = '+ls_item
				
				tab_1.tabpage_3.dw_imp_x_pagar.SetFilter(ls_expresion_imp)
				tab_1.tabpage_3.dw_imp_x_pagar.Filter()
				
			   DO WHILE tab_1.tabpage_3.dw_imp_x_pagar.Rowcount() > 0 
				   tab_1.tabpage_3.dw_imp_x_pagar.deleterow(0)
					tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1
 			   LOOP
  			   tab_1.tabpage_3.dw_imp_x_pagar.SetFilter('')
				tab_1.tabpage_3.dw_imp_x_pagar.Filter()
				
		 CASE tab_1.tabpage_2.dw_ref_x_pagar
			   //Si Se Elimina Una Referencia se tiene que eliminar la cantidad de 
				//los articulos tomandos en cuenta por el doc 
				ll_row = idw_1.Getrow()
				IF ll_row = 0 THEN RETURN
				ls_flag_estado = dw_master.object.flag_estado [1]
				ll_ano			= dw_master.object.ano 			 [1]
				ll_mes			= dw_master.object.mes 			 [1]

				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
				/*Elimina Impuestos*/	
				DO WHILE tab_1.tabpage_3.dw_imp_x_pagar.Rowcount() > 0
				   tab_1.tabpage_3.dw_imp_x_pagar.deleterow(0)
					tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1
				LOOP
					 
				/*Elimina Items de Detalle*/
				DO WHILE tab_1.tabpage_1.dw_ctas_pag_det.Rowcount() > 0
				   tab_1.tabpage_1.dw_ctas_pag_det.deleterow(0)
				   tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 1
				LOOP
					 
				
		 CASE tab_1.tabpage_6.dw_asiento_aux
				//los articulos tomandos en cuenta por el doc 
				ls_flag_estado = dw_master.object.flag_estado [1]
				ll_ano			= dw_master.object.ano 			 [1]
				ll_mes			= dw_master.object.mes 			 [1]

				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				
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

/*Genera Pre Asientos*/
ib_estado_prea = TRUE
/**/

ldc_total = wf_totales ()		
dw_master.object.importe_doc [1] = ldc_total
dw_master.ii_update = 1
wf_total_ref (ldc_total)
wf_total_ref_grmp() // Llama a la función que acumula por referencia

if idw_1 = tab_1.tabpage_2.dw_ref_x_pagar then
	wf_doc_anticipos ()
end if


end event

event ue_update_pre;Long    ll_nro_libro, ll_nro_asiento ,ll_inicio,ll_ano,ll_mes,ll_count
Integer li_opcion
String  ls_tipo_doc      , ls_nro_doc    , ls_cod_origen , ls_periodo        , ls_cod_cliente   ,&
		  ls_flag_estado   , ls_cnta_ctbl  , ls_tipo_ref   , ls_nro_ref        , ls_doc_os        ,&
		  ls_origen_ref    , ls_cencos     , ls_cta_presup , ls_cod_moneda     , ls_cod_soles     ,&
		  ls_flag_retencion, ls_mensaje    , ls_result     , ls_flag_detraccion, ls_nro_detraccion,&
		  ls_const_dep		 , ls_cod_dolares, ls_cta_cte		, ls_obs				  , ls_bien_serv		,&
		  ls_oper			 , ls_flag_serie , ls_doc_oc		, ls_msj_err		  ,ls_flag_ind			,&
		  ls_centro_benef
Date    ld_last_day,ldt_fecha_dep
Decimal {2} ldc_totsoldeb   = 0.00,ldc_totdoldeb    = 0.00,ldc_totsolhab     = 0.00,ldc_totdolhab     = 0.00,ldc_importe_imp = 0.00,&
				ldc_total_pagar = 0.00,ldc_monto_tot_os = 0.00,ldc_monto_fact_os = 0.00,ldc_monto_pend_os = 0.00,ldc_total_pagar_old = 0.00,&
				ldc_porc_ret_igv      ,ldc_porc_ret_x_doc	    ,ldc_monto_fac ,ldc_imp_min_igv,ldc_monto_detrac,&
				ldc_porc_detrac		 ,ldc_saldo_sol          ,ldc_saldo_dol ,ldc_tasa_pdbe	
				
Decimal {3} ldc_tasa_cambio
Datetime ldt_fecha_doc
Boolean	lb_retorno
str_parametros lstr_param


/*Replicación*/
dw_master.of_set_flag_replicacion ()
tab_1.tabpage_1.dw_ctas_pag_det.of_set_flag_replicacion ()
tab_1.tabpage_2.dw_ref_x_pagar.of_set_flag_replicacion  ()
tab_1.tabpage_3.dw_imp_x_pagar.of_set_flag_replicacion  ()
tab_1.tabpage_5.dw_pre_asiento_cab.of_set_flag_replicacion ()
tab_1.tabpage_5.dw_pre_asiento_det.of_set_flag_replicacion ()

IF is_accion = 'delete' THEN 
	ib_update_check = TRUE
	RETURN
END IF


nvo_numeradores lnvo_numeradores
lnvo_numeradores = CREATE nvo_numeradores


/****/
SELECT cod_soles,cod_dolares 
	INTO :ls_cod_soles,:ls_cod_dolares 
FROM logparam 
WHERE reckey = '1' ;
/****/


/*DATOS DE CABECERA */
IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF


IF is_accion = 'new' THEN
	if of_verifica_documento () = false then
		ib_update_check = False	
		Return
	end if
END IF

//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( tab_1.tabpage_1.dw_ctas_pag_det, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//Verificación de Data en Impuesto de Documento
IF f_row_Processing( tab_1.tabpage_3.dw_imp_x_pagar, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//Verificación de Data en Pre Asientos Auxiliares
IF f_row_Processing(tab_1.tabpage_6.dw_asiento_aux, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


//Verificación de Detalle de Documento
IF tab_1.tabpage_1.dw_ctas_pag_det.Rowcount() = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Items en el Detalle')
	ib_update_check = False	
	RETURN
END IF


////Seleccionar Informacion de Cabecera
ls_cod_origen   	 = dw_master.Object.origen          [1]
ls_tipo_doc     	 = dw_master.object.tipo_doc        [1]
ls_nro_doc	    	 = dw_master.object.nro_doc         [1]
ls_cod_cliente  	 = dw_master.object.cod_relacion    [1] 
ls_cod_moneda	 	 = dw_master.object.cod_moneda	   [1]
ll_nro_libro    	 = dw_master.object.nro_libro       [1] 
ll_nro_asiento	 	 = dw_master.object.nro_asiento	   [1] 
ll_ano			    = dw_master.object.ano	  			   [1]
ll_mes		       = dw_master.object.mes				   [1]
ls_flag_estado	    = dw_master.object.flag_estado	   [1]
ls_bien_serv		 = dw_master.object.bien_serv		   [1]
ldt_fecha_doc      = dw_master.object.fecha_emision   [1]
ldc_monto_fac	    = dw_master.object.importe_doc	   [1]
ldc_tasa_cambio    = dw_master.object.tasa_cambio	   [1]
ls_flag_detraccion = dw_master.object.flag_detraccion [1]
ldc_monto_detrac   = dw_master.object.monto_detrac	   [1]
ls_nro_detraccion  = dw_master.object.nro_detraccion  [1]
ldc_porc_detrac	 = dw_master.object.porc_detraccion [1]
ls_obs				 = dw_master.object.descripcion		[1]


/*Datos de Documentos*/
select flag_separ_serie 
	into :ls_flag_serie 
from doc_tipo 
where tipo_doc = :ls_tipo_doc ;

if ls_flag_serie = '1' then
	if Not(Pos(ls_nro_doc,'-',1) = 4 OR Pos(ls_nro_doc,'-',1) = 5)  then
		Messagebox('Aviso','Debe Colocar Nro de Serie en 4ta o 5ta Posición , Verifique!')
		ib_update_check = False	
		RETURN
	end if
end if


/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	ib_update_check = False	
	RETURN
END IF

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Documento')		
	ib_update_check = False	
	RETURN	
ELSE
	ib_update_check = True	
END IF	

IF Isnull(ls_nro_doc)  OR Trim(ls_nro_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Nro de Documento')		
	ib_update_check = False	
	RETURN		
ELSE
	ib_update_check = True	
END IF

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')		
	ib_update_check = False	
	RETURN	
ELSE	
	ib_update_check = True
END IF	
	

//Verificación de importe de documento


IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
	//*Documento de tipo Orden de Servicio*//
	SELECT doc_os,doc_oc
	  INTO :ls_doc_os,:ls_doc_oc
	  FROM logparam
	 WHERE (reckey = '1');
	 
	IF Isnull(ls_doc_os) OR Trim(ls_doc_os) = '' THEN
		Messagebox('Aviso','Tipo de Documento de Orden de Servicio no Existe en Tabla de Parametros LOGPARAM')
		ib_update_check = False	
		RETURN
	END IF
		
	
	ls_tipo_ref     = tab_1.tabpage_2.dw_ref_x_pagar.object.tipo_ref   [1]
	ls_origen_ref   = tab_1.tabpage_2.dw_ref_x_pagar.object.origen_ref [1]
	ls_nro_ref	    = tab_1.tabpage_2.dw_ref_x_pagar.object.nro_ref    [1]
	ldc_total_pagar = tab_1.tabpage_2.dw_ref_x_pagar.object.importe    [1]
	
	IF ls_tipo_ref = ls_doc_os THEN
		
	   f_verificacion_monto_os(ls_origen_ref,ls_nro_ref,ldc_monto_fact_os,ldc_monto_tot_os)
	
		IF is_accion = 'fileopen' THEN
			SELECT Nvl(importe_doc,0)
			  INTO :ldc_total_pagar_old
			  FROM cntas_pagar
			 WHERE ((cod_relacion = :ls_cod_cliente ) AND
			 		  (tipo_doc     = :ls_tipo_doc    ) AND
					  (nro_doc      = :ls_nro_doc     )) ;
					  
			ldc_total_pagar 	= ldc_total_pagar + (ldc_monto_fact_os - ldc_total_pagar_old)
			ldc_monto_pend_os	= Round(ldc_monto_tot_os - (ldc_monto_fact_os - ldc_total_pagar_old),2)
			
		ELSEIF is_accion = 'new' THEN 	
			ldc_total_pagar 	= Round(ldc_total_pagar + ldc_monto_fact_os,2)
			ldc_monto_pend_os	= Round(ldc_monto_tot_os - ldc_monto_fact_os,2)
			
		END IF
		
		IF ldc_total_pagar > ldc_monto_tot_os THEN
			Messagebox('Aviso','La Orden de Servicio no puede ser Facturado por un monto mayor a '+Trim(String(ldc_monto_pend_os)))
			ib_update_check = False	
			RETURN
		END IF
		
	ELSEIF ls_tipo_ref = ls_doc_oc THEN		
		f_verificacion_monto_oc(ls_origen_ref,ls_nro_ref,ldc_monto_fact_os,ldc_monto_tot_os)
	
		IF is_accion = 'fileopen' THEN
			SELECT Nvl(importe_doc,0)
			  INTO :ldc_total_pagar_old
			  FROM cntas_pagar
			 WHERE ((cod_relacion = :ls_cod_cliente ) AND
			 		  (tipo_doc     = :ls_tipo_doc    ) AND
					  (nro_doc      = :ls_nro_doc     )) ;
					  
			ldc_total_pagar 	= ldc_total_pagar + (ldc_monto_fact_os - ldc_total_pagar_old)
			ldc_monto_pend_os	= Round(ldc_monto_tot_os - (ldc_monto_fact_os - ldc_total_pagar_old),2)
			
		ELSEIF is_accion = 'new' THEN 	
			ldc_total_pagar 	= Round(ldc_total_pagar + ldc_monto_fact_os,2)
			ldc_monto_pend_os	= Round(ldc_monto_tot_os - ldc_monto_fact_os,2)
			
		END IF
		
		IF ldc_total_pagar > ldc_monto_tot_os THEN
			Messagebox('Aviso','La Orden de Compra no puede ser Facturado por un monto mayor a '+Trim(String(ldc_monto_pend_os)))
			ib_update_check = False	
			RETURN
		END IF

	END IF
END IF



IF is_accion = 'new' THEN
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
	
	IF f_asiento(ls_cod_origen,ll_nro_libro,ll_ano,ll_mes,ll_nro_asiento)  = FALSE THEN
		ib_update_check = False	
		Return
	ELSE
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
	END IF	
	
	//asignacion de año y mes
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.ano [1] = ll_ano
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.mes [1] = ll_mes

END IF


IF ls_cod_moneda = ls_cod_soles THEN 
	ldc_saldo_sol = ldc_monto_fac
	ldc_saldo_dol = Round(ldc_monto_fac / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = ls_cod_dolares THEN
	ldc_saldo_sol = Round(ldc_monto_fac *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_monto_fac
END IF

//saldos
dw_master.object.saldo_sol [1] = ldc_saldo_sol 
dw_master.object.saldo_dol [1] = ldc_saldo_dol



IF ib_estado_prea = TRUE THEN //Generación Automaticas de pre Asientos
	IF of_generacion_cntas() = FALSE THEN  
		ib_update_check = False	
		Return
	END IF
END IF


/*RECUPERACION DE ARCHIVO DE PARAMETROS*/
SELECT porc_ret_igv,flag_retencion,imp_min_ret_igv 
	INTO :ldc_porc_ret_igv,:ls_flag_retencion,:ldc_imp_min_igv 
FROM finparam           
WHERE reckey = '1' ;

IF ls_flag_retencion = '1' OR ls_flag_detraccion = '0' THEN /*RETIENE Y NO TIENE DETRACCION*/
	/*CONVERTIR A SOLES*/
	IF ls_cod_moneda = ls_cod_soles THEN
		ldc_monto_fac	 = dw_master.object.importe_doc [1]
	ELSE
		ldc_monto_fac	 = Round(dw_master.object.importe_doc [1] * ldc_tasa_cambio,2)
	END IF

	IF ldc_monto_fac > ldc_imp_min_igv THEN
		IF tab_1.tabpage_3.dw_imp_x_pagar.Rowcount() > 0 THEN
	
			SELECT Count(*) 
				INTO :ll_count 
			FROM doc_grupo_relacion 
			WHERE grupo = '07' 
			AND tipo_doc = :ls_tipo_doc ;
			
			IF ll_count > 0 THEN 
				ldc_porc_ret_x_doc = dw_master.Object.porc_ret_igv [1]
				IF Isnull(ldc_porc_ret_x_doc) THEN ldc_porc_ret_x_doc = 0.00
					IF ldc_porc_ret_x_doc <> ldc_porc_ret_igv THEN
						/*Asignar porc. retencion*/
						if ls_flag_detraccion = '1' then
							dw_master.Object.porc_ret_igv [1] = 0.00
							dw_master.ii_update = 1
						else	
							dw_master.Object.porc_ret_igv [1] = ldc_porc_ret_igv
							dw_master.ii_update = 1
					   end if	
						
					END IF
				END IF
			END IF
	END IF
END IF	



//DETRACCION
IF ls_flag_detraccion = '1' THEN
	
	select count(*) 
		into :ll_count 
	from detraccion 
	where nro_detraccion = :ls_nro_detraccion ;
	
  	if ll_count = 0 then
		//verifica porcentaje	
		if isnull(ldc_porc_detrac) or ldc_porc_detrac = 0.00 then
			Messagebox('Aviso','Debe Ingresar Porcentaje Detracción')
			dw_master.Setfocus()
			dw_master.SetColumn('porc_detraccion')
			ib_update_check = False	
			Return			
		end if
		
		SetNull(ls_nro_detraccion)
		
		IF lnvo_numeradores.uf_num_detraccion(ls_cod_origen,ls_nro_detraccion) = FALSE THEN
			ib_update_check = False	
			Return			
		END IF
		
		li_opcion = Messagebox('Aviso','Desea Colocar Datos del Deposito o Detracción',Question!,Yesno!,2)
		
		if li_opcion = 1 then
		   //ventana de ayuda
			OpenWithParm(w_help_constacia_dep_x_pag,ls_bien_serv)
			
			//*Datos Recuperados
			If IsValid(message.PowerObjectParm) Then
				lstr_param = message.PowerObjectParm
				
				If lstr_param.bret Then
					ls_const_dep  = lstr_param.string1
					ldt_fecha_dep = lstr_param.date1
					ls_cta_cte	  = lstr_param.string2
					ls_bien_serv  = lstr_param.string3
					ls_oper		  = lstr_param.string4
					
				   //asignar porcentaje e indicador	
					select tasa_pdbe,flag_ind_imp 
					  into :ldc_tasa_pdbe,:ls_flag_ind 
					  from detr_bien_serv 
					 where bien_serv = :ls_bien_serv ;
					 
					dw_master.object.porc_detraccion [1] =	ldc_tasa_pdbe
					dw_master.object.flag_ind_imp    [1] =	ls_flag_ind
		
					
				Else
					SetNull(ls_const_dep)
					SetNull(ldt_fecha_dep)
					SetNull(ls_cta_cte)
// 					SetNull(ls_bien_serv)
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
		IF f_insert_detrac(ls_nro_detraccion,'1',Date(ldt_fecha_doc),ls_const_dep,ldt_fecha_dep,&
								 gnvo_app.is_user          ,ldc_monto_detrac,'3') = FALSE THEN
			ib_update_check = False	
			Return								 
		END IF
		
		//genera documento detraccion
		IF ls_cta_cte = '1' THEN 
			IF f_insert_cta_cte_detrac(ls_cod_cliente ,ls_nro_detraccion ,DATE(ldt_fecha_doc), &
						ls_cod_moneda   ,ldc_tasa_cambio, gnvo_app.is_user, ls_cod_origen , ls_obs, &
						ldc_monto_detrac	) = FALSE THEN
												
												
				ib_update_check = FALSE
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
				ib_update_check = False	
				Return								 
			end if
			
			
			//actualiza cta cte
			
			if f_update_cta_cte_detrac(ls_nro_detraccion,ls_cod_cliente,DATE(ldt_fecha_doc),ldc_tasa_cambio,&
				ldc_monto_detrac,ls_cod_moneda) = FALSE THEN
				ib_update_check = False	
				Return
			end if
			
		End if
	
   end if //si comprobante detraccion existe
ELSEIF ls_flag_detraccion = '0' THEN
	
	if is_accion = 'fileopen'	 then
		/*Buscar Nro de Detracción*/
		select nro_detraccion into :ls_nro_detraccion from cntas_pagar cp
		 where (cp.cod_relacion = :ls_cod_cliente ) and
				 (cp.tipo_doc		= :ls_tipo_doc		) and
				 (cp.nro_doc		= :ls_nro_doc		) ;

		
		
		select count(*) into :ll_count from detraccion where nro_detraccion = :ls_nro_detraccion ;
		
		if ll_count > 0 then
			li_opcion = Messagebox('Aviso','Esta Segura de Eliminar Datos de la Detracción?',Question!,YesNo!,2)
			
			if li_opcion = 1 then
				

				IF dw_master.Update() = -1 then
					Messagebox('Error en Grabacion de Cabecera ','Se ha procedido al rollback',exclamation!)
					ib_update_check = False	
				END IF	
				
				
				//eliminar detraccion
				delete from detraccion where nro_detraccion = :ls_nro_detraccion ;
				
				IF SQLCA.SQLCode = -1 THEN
					ls_msj_err = SQLCA.SQLErrText
					Rollback ;
					MessageBox('SQL error',ls_msj_err)
					ib_update_check = False	
					Return
				END IF
				
		   else
				ib_update_check = False	
				Return
			end if
			
		end if		
	end if	
END IF


///detalle de Documento
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_ctas_pag_det.Rowcount()
	 
	 tab_1.tabpage_1.dw_ctas_pag_det.object.tipo_doc 	  [ll_inicio]  = ls_tipo_doc		 
	 tab_1.tabpage_1.dw_ctas_pag_det.object.nro_doc  	  [ll_inicio]  = ls_nro_doc		
	 tab_1.tabpage_1.dw_ctas_pag_det.object.cod_relacion [ll_inicio]  = ls_cod_cliente
	 ls_centro_benef = tab_1.tabpage_1.dw_ctas_pag_det.object.centro_benef [ll_inicio]	 
 	 
	 if is_flag_valida_cbe = '1' then //valida centro de beneficio
	 	 IF Isnull(ls_centro_benef) OR Trim(ls_centro_benef) = '' THEN
			  Messagebox('Aviso','Debe Ingresar Centro de Beneficio , Verifique!')
			  tab_1.tabpage_1.dw_ctas_pag_det.SetFocus()
			  tab_1.tabpage_1.dw_ctas_pag_det.Scrolltorow(ll_inicio)
			  tab_1.tabpage_1.dw_ctas_pag_det.SetColumn('centro_benef')
			  ib_update_check = False	
			  Return	
		 END IF
	 end if

	 IF ls_flag_estado = '1' THEN //GENERADO
	 	 IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() = 0 THEN
		 	 ls_cencos     = tab_1.tabpage_1.dw_ctas_pag_det.object.cencos    [ll_inicio]
			 ls_cta_presup = tab_1.tabpage_1.dw_ctas_pag_det.object.cnta_prsp [ll_inicio]
		 
		 	 IF Isnull(ls_cencos) OR Trim(ls_cencos) = '' THEN
			 	 Messagebox('Aviso','Debe Ingresar Centro de Costo , Verifique!')
			 	 tab_1.tabpage_1.dw_ctas_pag_det.SetFocus()
			 	 tab_1.tabpage_1.dw_ctas_pag_det.Scrolltorow(ll_inicio)
			 	 tab_1.tabpage_1.dw_ctas_pag_det.SetColumn('cencos')
				 ib_update_check = False	
				 Return
 		 	 END IF
		 
		 	 IF Isnull(ls_cta_presup) OR Trim(ls_cta_presup) = '' THEN
			 	 Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal , Verifique!')
			 	 tab_1.tabpage_1.dw_ctas_pag_det.SetFocus()
			 	 tab_1.tabpage_1.dw_ctas_pag_det.Scrolltorow(ll_inicio)
			 	 tab_1.tabpage_1.dw_ctas_pag_det.SetColumn('cnta_prsp')
				 ib_update_check = False	
				 Return
		 	 END IF
	 	END IF
	END IF
	
	
NEXT

///Referencias de Documentos
FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_ref_x_pagar.Rowcount()
	 tab_1.tabpage_2.dw_ref_x_pagar.object.tipo_doc     [ll_inicio] = ls_tipo_doc		 
	 tab_1.tabpage_2.dw_ref_x_pagar.object.nro_doc      [ll_inicio] = ls_nro_doc		 
	 tab_1.tabpage_2.dw_ref_x_pagar.object.cod_relacion [ll_inicio] = ls_cod_cliente	 
NEXT

///Impuestos
FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_imp_x_pagar.Rowcount()
	 tab_1.tabpage_3.dw_imp_x_pagar.object.tipo_doc 	  [ll_inicio] = ls_tipo_doc		 
	 tab_1.tabpage_3.dw_imp_x_pagar.object.nro_doc  	  [ll_inicio] = ls_nro_doc	
	 tab_1.tabpage_3.dw_imp_x_pagar.object.cod_relacion  [ll_inicio] = ls_cod_cliente
	 
	 /*Verifica Monto de Impuesto sea Mayor a 0*/
	 ldc_importe_imp = tab_1.tabpage_3.dw_imp_x_pagar.object.importe [ll_inicio]
	 IF ls_flag_estado = '1' THEN   //Generado
		 IF Isnull(ldc_importe_imp) OR ldc_importe_imp = 0 THEN
			 ib_update_check = False	
			 Messagebox('Aviso','Verifique Importe de Impuesto debe ser Mayor que 0')
			 EXIT			 
		 END IF
	END IF
NEXT

///Detalle de pre asiento
FOR ll_inicio = 1 TO tab_1.tabpage_5.dw_pre_asiento_det.Rowcount()
	 ls_cnta_ctbl = tab_1.tabpage_5.dw_pre_asiento_det.object.cnta_ctbl [ll_inicio]
	 tab_1.tabpage_5.dw_pre_asiento_det.object.origen   	 [ll_inicio] = ls_cod_origen
	 tab_1.tabpage_5.dw_pre_asiento_det.object.ano	   	 [ll_inicio] = ll_ano
	 tab_1.tabpage_5.dw_pre_asiento_det.object.mes	   	 [ll_inicio] = ll_mes
	 tab_1.tabpage_5.dw_pre_asiento_det.object.nro_libro	 [ll_inicio] = ll_nro_libro
	 tab_1.tabpage_5.dw_pre_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
	 tab_1.tabpage_5.dw_pre_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_doc
	 
	 IF wf_verifica_flag_cntas (ls_cnta_ctbl,ls_tipo_doc,ls_nro_doc,ls_cod_cliente,ll_inicio) = FALSE THEN
		 Messagebox('Aviso','Flag de Cuenta Contable '+ls_cnta_ctbl +'Tiene Problemas ,Verifique!')
		 ib_update_check = False	
		 Return	
	 END IF
NEXT

//Detalle de Pre Asientos Auxiliares
FOR ll_inicio = 1 TO tab_1.tabpage_6.dw_asiento_aux.Rowcount()
	 tab_1.tabpage_6.dw_asiento_aux.object.origen		[ll_inicio] = ls_cod_origen
	 tab_1.tabpage_6.dw_asiento_aux.object.nro_libro	[ll_inicio] = ll_nro_libro
 	 tab_1.tabpage_6.dw_asiento_aux.object.ano			[ll_inicio] = ll_ano
  	 tab_1.tabpage_6.dw_asiento_aux.object.mes			[ll_inicio] = ll_mes
	 tab_1.tabpage_6.dw_asiento_aux.object.nro_asiento [ll_inicio] = ll_nro_asiento
NEXT

//*Totales Para Cabecera de Pre - Asientos*//
ldc_totsoldeb  = tab_1.tabpage_5.dw_pre_asiento_det.object.monto_soles_cargo   [1]
ldc_totdoldeb  = tab_1.tabpage_5.dw_pre_asiento_det.object.monto_dolares_cargo [1]
ldc_totsolhab  = tab_1.tabpage_5.dw_pre_asiento_det.object.monto_soles_abono	 [1]
ldc_totdolhab  = tab_1.tabpage_5.dw_pre_asiento_det.object.monto_dolares_abono [1]

///Cabecera de pre asiento
IF is_accion = 'new' THEN
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.origen      [1] = ls_cod_origen
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.nro_libro 	[1] = ll_nro_libro
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.ano 			[1] = ll_ano
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.mes 			[1] = ll_mes
	tab_1.tabpage_5.dw_pre_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento
END IF	

//Cabecera de asiento datos Complementarios
tab_1.tabpage_5.dw_pre_asiento_cab.Object.cod_moneda	 [1] = dw_master.object.cod_moneda     [1]
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tasa_cambio	 [1] = dw_master.object.tasa_cambio    [1]
tab_1.tabpage_5.dw_pre_asiento_cab.Object.desc_glosa	 [1] = Mid(dw_master.object.descripcion[1],1,60)
tab_1.tabpage_5.dw_pre_asiento_cab.Object.fec_registro [1] = dw_master.object.fecha_registro [1]
tab_1.tabpage_5.dw_pre_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_doc
tab_1.tabpage_5.dw_pre_asiento_cab.Object.cod_usr		 [1] = dw_master.object.cod_usr 	 	   [1]
tab_1.tabpage_5.dw_pre_asiento_cab.Object.flag_estado	 [1] = dw_master.object.flag_estado    [1]
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_solhab	 [1] = ldc_totsolhab
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_dolhab	 [1] = ldc_totdolhab
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_soldeb	 [1] = ldc_totsoldeb
tab_1.tabpage_5.dw_pre_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb

IF tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1
IF dw_master.ii_update = 1 THEN tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1

// valida asientos descuadrados
lb_retorno  = f_validar_asiento(tab_1.tabpage_5.dw_pre_asiento_det)

IF lb_retorno = FALSE THEN
	ib_update_check = False	
	Return
END IF



end event

event ue_update;Boolean lbo_ok = TRUE
Long    ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
String  ls_flag_estado,ls_origen

dw_master.AcceptText()
tab_1.tabpage_1.dw_ctas_pag_det.AcceptText()
tab_1.tabpage_2.dw_ref_x_pagar.AcceptText()
tab_1.tabpage_3.dw_imp_x_pagar.AcceptText()
tab_1.tabpage_5.dw_pre_asiento_cab.AcceptText()
tab_1.tabpage_5.dw_pre_asiento_det.AcceptText()
tab_1.tabpage_6.dw_asiento_aux.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF

//ejecuta procedimiento de actualizacion de tabla temporal
IF tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 and is_accion <> 'new' THEN
	ll_row_det     = tab_1.tabpage_5.dw_pre_asiento_cab.Getrow()
	ls_origen      = tab_1.tabpage_5.dw_pre_asiento_cab.Object.origen      [ll_row_det]
	ll_ano         = tab_1.tabpage_5.dw_pre_asiento_cab.Object.ano         [ll_row_det]
	ll_mes         = tab_1.tabpage_5.dw_pre_asiento_cab.Object.mes         [ll_row_det]
	ll_nro_libro   = tab_1.tabpage_5.dw_pre_asiento_cab.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = tab_1.tabpage_5.dw_pre_asiento_cab.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
END IF	


IF tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
	IF tab_1.tabpage_5.dw_pre_asiento_cab.Update() = -1 then		// Grabacion Pre - Asiento Cabecera
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Asiento Cabecera","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 AND lbo_ok = TRUE  THEN
	IF tab_1.tabpage_5.dw_pre_asiento_det.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Asiento Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF is_accion <> 'delete' THEN
	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update() = -1 then		// Grabación Cabecera de Ctas x Pagar
			lbo_ok = FALSE
			Messagebox('Error en Grabación de Cabecera de Ctas x Pagar','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF	tab_1.tabpage_2.dw_ref_x_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
		IF tab_1.tabpage_2.dw_ref_x_pagar.Update() = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
		END IF
	END IF


	IF	tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 1 AND lbo_ok = TRUE THEN
		IF tab_1.tabpage_1.dw_ctas_pag_det.Update() = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
		IF tab_1.tabpage_3.dw_imp_x_pagar.Update () = -1 then //Grabacion de Impuestos
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	
ELSE
	IF tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
		IF tab_1.tabpage_3.dw_imp_x_pagar.Update () = -1 then //Grabacion de Impuestos
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF	tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 1 AND lbo_ok = TRUE THEN
		IF tab_1.tabpage_1.dw_ctas_pag_det.Update() = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	
	IF	tab_1.tabpage_2.dw_ref_x_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
		IF tab_1.tabpage_2.dw_ref_x_pagar.Update() = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update() = -1 then		// Grabación Cabecera de Ctas x Pagar
			MessageBox("SQL error", SQLCA.SQLErrText)
			lbo_ok = FALSE
			Messagebox('Error en Grabación de Cabecera de Ctas x Pagar','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
END IF

IF tab_1.tabpage_6.dw_asiento_aux.ii_update = 1 AND lbo_ok = TRUE THEN
   IF	tab_1.tabpage_6.dw_asiento_aux.Update () = -1 then //Grabación de Pre Asientos Auxiliares
		lbo_ok = FALSE
		Messagebox('Error en Grabacion de Pre Asientos Auxiliares ','Se ha procedido al rollback',exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_ctas_pag_det.ii_update 	= 0
	tab_1.tabpage_2.dw_ref_x_pagar.ii_update 		= 0
	tab_1.tabpage_3.dw_imp_x_pagar.ii_update 		= 0
	tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 0
	tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 0
	tab_1.tabpage_6.dw_asiento_aux.ii_update 		= 0
	ib_estado_prea = False   //pre-asiento editado					
	IF is_accion <> 'delete' THEN
		is_accion = 'fileopen'
	END IF
	TriggerEvent('ue_modify')
ELSE 
	ROLLBACK USING SQLCA;
END IF



end event

event closequery;call super::closequery;Destroy ids_matriz_cntbl_det
Destroy ids_data_glosa
Destroy if_asiento_contable
Destroy ids_formato_det
Destroy ids_voucher
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
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 



dw_master.of_protect()
tab_1.tabpage_1.dw_ctas_pag_det.of_protect()
tab_1.tabpage_2.dw_ref_x_pagar.of_protect()
tab_1.tabpage_3.dw_imp_x_pagar.of_protect()
tab_1.tabpage_5.dw_pre_asiento_det.of_protect()
tab_1.tabpage_6.dw_asiento_aux.of_protect()
	

IF ls_flag_estado <> '1' OR ls_result = '0' THEN
	dw_master.ii_protect = 0
	tab_1.tabpage_1.dw_ctas_pag_det.ii_protect	 = 0
	tab_1.tabpage_2.dw_ref_x_pagar.ii_protect		 = 0
	tab_1.tabpage_3.dw_imp_x_pagar.ii_protect		 = 0
	tab_1.tabpage_5.dw_pre_asiento_det.ii_protect = 0
	tab_1.tabpage_6.dw_asiento_aux.ii_protect = 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_ctas_pag_det.of_protect()
	tab_1.tabpage_2.dw_ref_x_pagar.of_protect()
	tab_1.tabpage_3.dw_imp_x_pagar.of_protect()
	tab_1.tabpage_5.dw_pre_asiento_det.of_protect()
	tab_1.tabpage_6.dw_asiento_aux.of_protect()
ELSE
	
	IF is_accion <> 'new' THEN
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
		tab_1.tabpage_1.dw_ctas_pag_det.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	
	END IF	
	

END IF

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio ,ll_ano ,ll_count
String ls_cencos,ls_cnta_prsp ,ls_null ,ls_origen
str_parametros sl_param

Setnull(ls_null)
TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_cta_x_pagar_x_tbl'
sl_param.titulo = 'Cuentas x Pagar'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc
sl_param.field_ret_i[4] = 8	//Origen
sl_param.field_ret_i[5] = 9	//Año
sl_param.field_ret_i[6] = 10	//Mes
sl_param.field_ret_i[7] = 11	//Nro Libro
sl_param.field_ret_i[8] = 12	//Nro Asiento


//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)


sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	
	

	
	dw_master.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_1.dw_ctas_pag_det.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_2.dw_ref_x_pagar.Retrieve(sl_param.field_ret[2],sl_param.field_ret[3],sl_param.field_ret[1])
	tab_1.tabpage_3.dw_imp_x_pagar.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_5.dw_pre_asiento_cab.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))
	tab_1.tabpage_5.dw_pre_asiento_det.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))
	tab_1.tabpage_6.dw_asiento_aux.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))	

	//**//
	IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
		FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_ctas_pag_det.Rowcount()
			
			 tab_1.tabpage_1.dw_ctas_pag_det.object.flag_hab  [ll_inicio] = '1'
			 
			 if is_flag_valida_cbe = '1' then //valida centro de beneficio
				 ls_cencos    = tab_1.tabpage_1.dw_ctas_pag_det.object.cencos	  [ll_inicio]
				 ls_cnta_prsp = tab_1.tabpage_1.dw_ctas_pag_det.object.cnta_prsp [ll_inicio]
				 ll_ano		  = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
				 ls_origen	  = dw_master.object.origen 		  [1]	
			 
				 //VERIFICAR SIEMPRE Y CUANDO CUMPLA CONDICIONES DE PARTIDA FONDO
				 ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)

				 if ll_count > 0 then
					 tab_1.tabpage_1.dw_ctas_pag_det.object.flag_cebef   [ll_inicio] = ls_null	//no editable tipo fondo
					 tab_1.tabpage_1.dw_ctas_pag_det.object.centro_benef [ll_inicio] = of_cbenef_origen(ls_origen)
				 else
				    tab_1.tabpage_1.dw_ctas_pag_det.object.flag_cebef   [ll_inicio] = '1'     //editable		
				 end if
				 
			 end if	 
			
		 NEXT
		 
	END IF	
	//**//
	

	ib_estado_prea = False   //pre-asiento editado					
	TriggerEvent('ue_modify')
	is_accion = 'fileopen'	
END IF


end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 						 		  OR tab_1.tabpage_1.dw_ctas_pag_det.ii_update    = 1 OR &
	 tab_1.tabpage_2.dw_ref_x_pagar.ii_update     = 1 OR tab_1.tabpage_3.dw_imp_x_pagar.ii_update	  = 1 OR &
	 tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 OR tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 OR &
	 tab_1.tabpage_6.dw_asiento_aux.ii_update     = 1 )THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_ctas_pag_det.ii_update		= 1 
	   tab_1.tabpage_2.dw_ref_x_pagar.ii_update		= 1 
	   tab_1.tabpage_3.dw_imp_x_pagar.ii_update		= 1 
		tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 
	   tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 
		tab_1.tabpage_6.dw_asiento_aux.ii_update 		= 1 
	END IF
END IF

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

type p_pie from w_abc`p_pie within w_fi304_cnts_x_pagar
end type

type ole_skin from w_abc`ole_skin within w_fi304_cnts_x_pagar
end type

type uo_h from w_abc`uo_h within w_fi304_cnts_x_pagar
end type

type st_box from w_abc`st_box within w_fi304_cnts_x_pagar
end type

type phl_logonps from w_abc`phl_logonps within w_fi304_cnts_x_pagar
end type

type p_mundi from w_abc`p_mundi within w_fi304_cnts_x_pagar
end type

type p_logo from w_abc`p_logo within w_fi304_cnts_x_pagar
end type

type gb_1 from groupbox within w_fi304_cnts_x_pagar
integer x = 3314
integer y = 168
integer width = 759
integer height = 404
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
string text = "&Referencias"
end type

type gb_4 from groupbox within w_fi304_cnts_x_pagar
integer x = 3314
integer y = 788
integer width = 759
integer height = 308
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
string text = "Orden Trabajo"
end type

type gb_5 from groupbox within w_fi304_cnts_x_pagar
integer x = 3314
integer y = 600
integer width = 759
integer height = 176
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
string text = "Control Documentario"
end type

type dw_master from u_dw_abc within w_fi304_cnts_x_pagar
integer x = 503
integer y = 192
integer width = 2793
integer height = 900
string dataobject = "d_abc_cntas_pagar_cab_x_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_nom_proveedor  , ls_forma_pago   , ls_mes  ,ls_flag_detraccion ,&
				ls_nro_detraccion , ls_desc_fpago   , ls_null ,ls_ano				 ,&
				ls_periodo			, ls_cod_relacion , ls_flag_imp 
Date        ld_fecha_emision, ld_fecha_vencimiento,ld_fecha_emision_old,ld_fecha_presentacion_old,&
				ld_fecha_presentacion
DateTime    ldt_fecha_vencim_new
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_tasa 
Integer		li_dias_venc , li_opcion
Long        ll_nro_libro,ll_count
Date			ld_null

ld_fecha_emision_old 	  = Date(This.Object.fecha_emision [row])	
ld_fecha_presentacion_old = Date(This.Object.fecha_presentacion [row])	

Accepttext()
setnull(ls_null)
setnull(ld_null)
/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/


CHOOSE CASE dwo.name
		 CASE	'bien_serv'
				IF ls_flag_detraccion = '1' THEN
					Messagebox('Aviso','Debe Seleccionar que Generara Detracción')
					Return 2
				END IF
				
				select tasa_pdbe ,flag_ind_imp into :ldc_tasa ,:ls_flag_imp 
				  from detr_bien_serv
				 where (bien_serv   = :data ) and
				 		 (flag_estado = '1'   ) ;
						  
				
				if sqlca.sqlcode = 100 then
				   Messagebox('Aviso','Codigo de Detraccion No Existe o Esta Inactivo,Verifique!')	
				   this.object.bien_serv       [row] = ls_null
					this.object.flag_ind_imp    [row] =	ls_null
					this.object.porc_detraccion [row] =	0.00
				   Return 1
			   else
					this.object.porc_detraccion [row] =	ldc_tasa
					this.object.flag_ind_imp    [row] =	ls_flag_imp
			   end if
				
			
		 CASE 'forma_pago'
				//BUSCA FECHA DE RECEPCION				
				wf_find_fecha_presentacion()
				
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
					ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_presentacion [row]) , li_dias_venc )
					This.Object.vencimiento [row] = ld_fecha_vencimiento
				END IF
							
	    CASE	'tipo_doc'
				ll_nro_libro = idw_doc_tipo.Getitemnumber(idw_doc_tipo.getrow(),'nro_libro')
				
				is_tip_cred	 = idw_doc_tipo.Getitemstring(idw_doc_tipo.getrow(),'tipo_cred_fiscal')
				
				This.Object.nro_libro [row] = ll_nro_libro
				
				
				
		 CASE 'cod_moneda'
				IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
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
				IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
					Messagebox('Aviso','No puede Cambiar la Tasa de Cambio por que Tiene Doc. de Referencias ,Verifique!')
					This.Object.tasa_cambio[1] =	This.Object.tasa_cambio_det[1] 
					Return 1
				END IF		
				
		CASE 'cod_relacion'
			
				IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
					Messagebox('Aviso','No puede	Cambiar El codigo del Cliente Tiene Doumentos Referenciados , Verifique!')
					This.Object.cod_relacion [1] = This.Object.cod_relacion_det [1]
					Return 1
				END IF

				SELECT prov.nom_proveedor
				  INTO :ls_nom_proveedor
				  FROM proveedor prov
				 WHERE (prov.proveedor   = :data ) and
				 		 (prov.flag_estado = '1'   ) ;
						 
				
				IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
					Messagebox('Aviso','Proveedor No Existe , Verifique!')
					This.Object.cod_relacion [1] = ''
					Return 1
				ELSE
					This.Object.nom_proveedor[row] = ls_nom_proveedor
					
				END IF

		 CASE	'ano'
				// Verificando el periodo contable
				ls_ano = String(this.object.ano [row])
				ls_mes = String(this.object.mes [row],'00')
				ls_periodo = String(Date(This.Object.fecha_emision [row]),'yyyymm')
				
				IF (ls_ano + ls_mes) < ls_periodo THEN
					dw_master.object.ano [row] = Long(String(Date(This.Object.fecha_emision [row]),'yyyy'))
					dw_master.object.mes [row] = Long(String(Date(This.Object.fecha_emision [row]),'mm'))
					MessageBox('Aviso','Periodo contable errado, corrija')
					RETURN 1
				END IF 

		CASE	'mes'
				// Verificando el periodo contable
				ls_ano = String(this.object.ano [row])
				ls_mes = String(this.object.mes [row],'00')
				ls_periodo = String(Date(This.Object.fecha_emision [row]),'yyyymm')
				
				IF (ls_ano + ls_mes) < ls_periodo THEN
					dw_master.object.ano [row] = Long(String(Date(This.Object.fecha_emision [row]),'yyyy'))
					dw_master.object.mes [row] = Long(String(Date(This.Object.fecha_emision [row]),'mm'))

					MessageBox('Aviso','Periodo contable errado, corrija')
					Return 1
					
				END IF 

		 CASE	'fecha_emision'
				
				IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
					Messagebox('Aviso','No puede Cambiar la Fecha de Emision por que Cambiaria la Tasa de Cambio y Tiene Doc. de Referencias ,Verifique!')
					This.Object.fecha_emision[1] = ld_fecha_emision_old
					Return 1
				END IF		
				
				// Verificando el periodo contable
				ls_ano = String(this.object.ano [row])
				ls_mes = String(this.object.mes [row],'00')
				ls_periodo = String(Date(This.Object.fecha_emision [row]),'yyyymm')
				
				IF (ls_ano + ls_mes) < ls_periodo THEN
					dw_master.object.ano [row] = Long(String(Date(This.Object.fecha_emision [row]),'yyyy'))
					dw_master.object.mes [row] = Long(String(Date(This.Object.fecha_emision [row]),'mm'))
					
					MessageBox('Aviso','Periodo contable errado, corrija')
					This.Object.fecha_emision [row] = f_fecha_actual(1)
					return 2
				END IF 
				//
				ld_fecha_emision      = Date(This.Object.fecha_emision [row])			
				ld_fecha_vencimiento	 = Date(This.Object.vencimiento   [row])			
				ls_forma_pago			 = This.Object.forma_pago [row]	
				
				//busco fecha de recepcion en control documentario
				wf_find_fecha_presentacion()
				
				
				ld_fecha_presentacion = Date(This.Object.fecha_presentacion [row])			
				
				IF ld_fecha_presentacion > ld_fecha_vencimiento THEN
					This.Object.fecha_presentacion [row] = ld_fecha_presentacion_old
					Messagebox('Aviso','Fecha de Presentacion del Documento No '&
											+'Puede Ser Mayor a la Fecha de Vencimiento')
					Return 1
				END IF

				
				This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
				
				IF Not (Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
					
					li_dias_venc = this.object.dias_vencimiento [row]
				   
					IF li_dias_venc > 0 THEN
						li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
						
						IF li_opcion = 1 THEN
							ld_fecha_presentacion = Date(This.Object.fecha_presentacion [row])
							ld_fecha_vencimiento = Relativedate(ld_fecha_presentacion,li_dias_venc)
							This.Object.vencimiento [row] = ld_fecha_vencimiento
						END IF
					END IF	
				END IF
				
				

		 CASE 'vencimiento'	
				ld_fecha_presentacion = Date(This.Object.fecha_presentacion [row])			
				ld_fecha_vencimiento	 = Date(This.Object.vencimiento   [row])			
				
				IF ld_fecha_vencimiento < ld_fecha_presentacion THEN
					This.Object.vencimiento [row] = ld_fecha_emision
					Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
											+'Puede Ser Menor a la Fecha de Presentacion')
					Return 1
				END IF
				

		CASE 'flag_detraccion'
			
			  if data = '0' then
				
				  IF is_accion = 'fileopen' THEN //modificacion
	  				  ls_nro_detraccion = this.object.nro_detraccion [row]
					  ls_cod_relacion	  = this.object.cod_relacion   [row]
					  
					  /*Buscar Documento tipo Cta Cte*/	 
					  select count(*) into :ll_count from cntas_pagar
					   where (cod_relacion = :ls_cod_relacion   ) and
								(tipo_doc	  = (select doc_detrac_cp  from finparam where reckey = '1')) and
								(nro_doc		  = :ls_nro_detraccion ) ;
					  
					  
					  if ll_count > 0 then
						  Messagebox('Aviso','No Puede Revertir Detraccion por que '  + Char(13) & 
						  						  +'se ha generado Documento tipo Cuenta Corriente , Verifique!')
						  this.object.flag_detraccion [row] = '1'
						  Return 1							 
					  end if
					  
				  END IF
				  

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

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// 
ii_ck[3] = 3			// 

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // 
ii_dk[3] = 3 	      // 

idw_mst  = dw_master								 // dw_master
idw_det  = tab_1.tabpage_1.dw_ctas_pag_det // dw_detail

end event

event ue_insert_pre;call super::ue_insert_pre;This.object.origen 			  [al_row] = gnvo_app.is_origen
This.object.cod_usr 			  [al_row] = gnvo_app.is_user
This.object.fecha_registro   [al_row] = f_fecha_actual(1)
This.object.fecha_emision 	  [al_row] = f_fecha_actual(1)
This.object.vencimiento 	  [al_row] = f_fecha_actual(1)
This.object.ano 				  [al_row] = Long(String(f_fecha_actual(1),'YYYY'))
This.object.mes	 			  [al_row] = Long(String(f_fecha_actual(1),'MM'))
This.object.tasa_cambio 	  [al_row] = f_tasa_cambio()
This.object.flag_estado 	  [al_row] = '1'
This.Object.ind_detrac	     [al_row] = '1'
This.object.flag_detraccion  [al_row] = '0'
This.object.flag_provisionado[al_row] = 'R'
This.object.flag_cntr_almacen[al_row] = '1'


end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot ,ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,ls_flag_detrac
Date		   ld_fecha_emision ,ld_fecha_vencimiento	,ld_fecha_presentacion
Long        ll_count,ll_nro_libro
Decimal {3} ldc_tasa_cambio
Str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'b_1'
				IF is_accion = 'new' THEN
					
					if of_verifica_documento () = false then
						Return
					end if
				END IF
 		 CASE	'bien_serv'	
			
				ls_flag_detrac = This.object.flag_detraccion [row]
				
				if ls_flag_detrac <> '1' then
					Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
					Return 	
				end if
				
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql =  'SELECT DETR_BIEN_SERV.BIEN_SERV    AS CODIGO ,'&
												 +'		 DETR_BIEN_SERV.DESCRIPCION  AS DESCRIPCION ,'&
												 +'		 DETR_BIEN_SERV.TASA_PDBE	  AS TASA_BIEN_SERV, '&
												 +'		 DETR_BIEN_SERV.FLAG_IND_IMP AS FLAG_IMPORTE	  '&	
												 +'  FROM DETR_BIEN_SERV '&
												 +' WHERE DETR_BIEN_SERV.FLAG_ESTADO = '+"'"+'1'+"'"
												
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.bien_serv       [row] = lstr_seleccionar.param1   [1]
					this.object.porc_detraccion [row] =	lstr_seleccionar.paramdc3 [1]
					this.object.flag_ind_imp    [row] =	lstr_seleccionar.param4   [1]
					ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE
					/**/
					
					
					
				END IF
				
		 CASE 'cod_moneda'
				IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
					Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda')
					Return 
				END IF
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA  AS CODIGO      ,'&
								      				 +'MONEDA.DESCRIPCION AS DESCRIPCION  '&
									   				 +'FROM MONEDA '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.cod_moneda [row] = lstr_seleccionar.param1[1]
					ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE
					/**/
				END IF
				
		 CASE	'forma_pago'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT FORMA_PAGO.FORMA_PAGO       AS CODIGO_FPAGO ,'&
								      				 +'FORMA_PAGO.DESC_FORMA_PAGO  AS DESCRIPCION  ,'&
														 +'FORMA_PAGO.DIAS_VENCIMIENTO AS VENCIMIENTO   '&
									   				 +'FROM FORMA_PAGO '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					//BUSCA FECHA DE RECEPCION				
					wf_find_fecha_presentacion()
				
					
					Setitem(row,'forma_pago'      ,lstr_seleccionar.param1[1])
					Setitem(row,'desc_forma_pago' ,lstr_seleccionar.param2[1])
					Setitem(row,'dias_vencimiento',lstr_seleccionar.paramdc3[1])
					
					il_dias_vencimiento = lstr_seleccionar.paramdc3[1]
					
					IF il_dias_vencimiento > 0 THEN
						ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_presentacion [row]) , il_dias_vencimiento )
						This.Object.vencimiento [row] = ld_fecha_vencimiento
					END IF

					ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE

					/**/
				END IF
		 CASE 'cod_relacion'
				IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
					Messagebox('Aviso','No puede	Cambiar El codigo del Cliente')
					Return
				END IF
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_FIN_PROV_X_CAMPO.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'VW_FIN_PROV_X_CAMPO.NOM_PROVEEDOR AS NOMBRES ,'&
														 +'VW_FIN_PROV_X_CAMPO.RUC AS NUMERO_DE_RUC ,'&
														 +'VW_FIN_PROV_X_CAMPO.DESC_CAMPO AS DESCRIPCION_CAMPO ,'&
								   					 +'VW_FIN_PROV_X_CAMPO.EMAIL AS EMAIL '&
									   				 +'FROM VW_FIN_PROV_X_CAMPO '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE
					/**/
				END IF
				
			
		 CASE 'vencimiento'	
				ld_fecha_vencimiento = Date(This.Object.vencimiento [row])				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				IF ld_fecha_vencimiento <> Date(This.Object.vencimiento [row])	THEN
					
					ld_fecha_presentacion = Date(This.Object.fecha_presentacion [row])			
					ld_fecha_vencimiento	 = Date(This.Object.vencimiento        [row])			
				
					IF ld_fecha_vencimiento < ld_fecha_presentacion THEN
						This.Object.vencimiento [row] = ld_fecha_emision
						
						Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
												+'Puede Ser Menor a la Fecha de Presentacion')
												
					END IF					
					This.ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE
					/**/
				END IF		
			
							
END CHOOSE




end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type pb_oc from picturebutton within w_fi304_cnts_x_pagar
integer x = 3333
integer y = 232
integer width = 142
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Compute!"
end type

event clicked;String        ls_tipo_doc_os ,ls_tipo_ref ,ls_cod_cliente, &
					ls_tipo_doc_grmp, ls_mensaje
Decimal {2}   ldc_total
Decimal {3}   ldc_tasa_cambio
str_parametros sl_param

IF of_verifica_data_oc (ls_cod_cliente,ldc_tasa_cambio) = FALSE THEN Return

IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
	/*Recuperacion de Tipo doc Orden Servicio*/
	SELECT doc_os 
	  INTO :ls_tipo_doc_os
	  FROM logparam
	 WHERE (reckey = '1' ) ;
	 
	IF Isnull(ls_tipo_doc_os) OR Trim(ls_tipo_doc_os) = '' THEN
		ls_mensaje = 'Debe Ingresar Un tipo de Documento para Orden de Servicio en Tabla de Parametros LOGPARAM, Comuniquese Con Sistemas!'
		gnvo_log.of_errorlog( ls_mensaje )
		gnvo_app.of_showmessagedialog( ls_mensaje )
		Return		
	END IF
	/**/
	
	/*Recuperacion de Tipo doc GRMP*/
	SELECT DOC_GUIA_MP
	  INTO :ls_tipo_doc_grmp
	FROM ap_param
	WHERE origen = 'XX';
	
	IF Isnull(ls_tipo_doc_grmp) OR Trim(ls_tipo_doc_grmp) = '' THEN
		ls_mensaje = 'Debe Ingresar Un tipo de Documento para Guia de Recepción en Tabla de Parametros APPARAM, Comuniquese Con Sistemas!'
		gnvo_log.of_errorlog( ls_mensaje )
		gnvo_app.of_showmessagedialog( ls_mensaje )
		Return		
	END IF
	/**/
	
	ls_tipo_ref = tab_1.tabpage_2.dw_ref_x_pagar.Object.tipo_ref[1]
	IF ls_tipo_ref = ls_tipo_doc_os THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Compra , Verifique!')
		RETURN
	END IF
	
	ls_tipo_ref = tab_1.tabpage_1.dw_ctas_pag_det.object.tipo_ref[1]
	IF ls_tipo_ref = ls_tipo_doc_grmp THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Compra , Verifique!')
		RETURN
	END IF
	
	//*Selecciona Nro de Orden de Compra*//
	is_orden_compra = tab_1.tabpage_2.dw_ref_x_pagar.Object.nro_ref[1]

ELSE
	SetNull(is_orden_compra)
END IF

sl_param.tipo		 = '1S'
sl_param.opcion	 = 22         //Ordenes de Compra  ANTES 10
sl_param.titulo 	 = 'Selección de Ordenes de Compra'
sl_param.dw_master = 'd_abc_lista_oc_pendientes_tbl'
sl_param.dw1		 = 'd_abc_art_mov_oc_pendientes_tbl'
sl_param.dw_m		 = dw_master
sl_param.dw_d		 = tab_1.tabpage_1.dw_ctas_pag_det
sl_param.dw_c		 = tab_1.tabpage_2.dw_ref_x_pagar
sl_param.string1	 = ls_cod_cliente
sl_param.string2	 = is_orden_compra
sl_param.db1		 = ldc_tasa_cambio

dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
	IF sl_param.titulo = 's' THEN
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		
		
      wf_doc_anticipos () 
		
		
		wf_total_ref (ldc_total)
		
		tab_1.tabpage_1.dw_ctas_pag_det.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")			
	END IF

end event

type st_6 from statictext within w_fi304_cnts_x_pagar
integer x = 3511
integer y = 488
integer width = 480
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
boolean enabled = false
string text = "Guia de Recepción"
boolean focusrectangle = false
end type

type pb_grmp from picturebutton within w_fi304_cnts_x_pagar
integer x = 3333
integer y = 460
integer width = 142
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "CrossTab!"
string disabledname = "CrossTab!"
end type

event clicked;Parent.Event Dynamic ue_grmp()
end event

type st_5 from statictext within w_fi304_cnts_x_pagar
integer x = 3502
integer y = 880
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
boolean enabled = false
string text = "Asociar OT"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_fi304_cnts_x_pagar
integer x = 3342
integer y = 844
integer width = 142
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "Custom083!"
string disabledname = "Custom083!"
end type

event clicked;Long  ll_row_master 

str_parametros sl_param


ll_row_master = dw_master.Getrow()

IF ll_row_master = 0  THEN RETURN


IF dw_master.ii_update = 1                          OR tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 1    OR &
	tab_1.tabpage_2.dw_ref_x_pagar.ii_update = 1     OR tab_1.tabpage_3.dw_imp_x_pagar.ii_update  = 1    OR &
	tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 OR tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 OR &
	tab_1.tabpage_6.dw_asiento_aux.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
	Return
END IF

//datos del documento/
sl_param.string1     = dw_master.object.cod_relacion  [ll_row_master]
sl_param.string2		 = dw_master.object.tipo_doc     [ll_row_master]
sl_param.string3		 = dw_master.object.nro_doc      [ll_row_master]

OpenWithParm(w_abc_relacionar_ot, sl_param)

end event

type st_4 from statictext within w_fi304_cnts_x_pagar
integer x = 3506
integer y = 692
integer width = 535
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
boolean enabled = false
string text = "Provision Pendiente"
boolean focusrectangle = false
end type

type pb_cd from picturebutton within w_fi304_cnts_x_pagar
integer x = 3342
integer y = 660
integer width = 142
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "Custom070!"
string disabledname = "Custom070!"
end type

event clicked;str_parametros sl_param
dwobject   dwo_1


if is_accion <> 'new' or dw_master.Getrow() = 0 then
	
	Messagebox('Aviso','Debe Ser Un Documento Nuevo para Ingresar')
	Return
end if	


if tab_1.tabpage_1.dw_ctas_pag_det.Rowcount() > 0 then
	Messagebox('Aviso','No Debe Haber Ingresado Detalle del Documento')
	Return
end if


sl_param.dw1  	  = 'd_abc_doc_sin_provisionar_cd_tbl'
sl_param.tipo 	  = '1CD'
sl_param.titulo  = 'Pendientes de Provisionar'
sl_param.string1 = gnvo_app.is_origen
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3
sl_param.field_ret_i[4] = 4
sl_param.field_ret_i[5] = 5
sl_param.field_ret_i[6] = 6
sl_param.field_ret_i[7] = 7
sl_param.field_ret_i[8] = 8



OpenWithParm( w_search_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.object.tipo_doc      [dw_master.getrow()] = sl_param.field_ret[1]
	dwo_1 = dw_master.object.tipo_doc
	dw_master.Event itemchanged(dw_master.getrow(),dwo_1,sl_param.field_ret[1])
	
	dw_master.object.nro_doc       [dw_master.getrow()] = trim(sl_param.field_ret[2])
	
	dw_master.object.cod_relacion  [dw_master.getrow()] = sl_param.field_ret[3]	
	dwo_1 = dw_master.object.cod_relacion
	dw_master.Event itemchanged(dw_master.getrow(),dwo_1,sl_param.field_ret[3])
	
	

	dw_master.object.forma_pago    [dw_master.getrow()] = sl_param.field_ret[4]
	dwo_1 = dw_master.object.forma_pago
	dw_master.Event itemchanged(dw_master.getrow(),dwo_1,sl_param.field_ret[4])
	
	
	dw_master.object.cod_moneda    [dw_master.getrow()] = sl_param.field_ret[6]
	dwo_1 = dw_master.object.cod_moneda
	dw_master.Event itemchanged(dw_master.getrow(),dwo_1,sl_param.field_ret[6])
	
	dw_master.object.descripcion   [dw_master.getrow()] = sl_param.field_ret[8]
	
	dw_master.object.fecha_emision [dw_master.getrow()] = sl_param.field_date[1]
	dwo_1 = dw_master.object.fecha_emision
	dw_master.Event itemchanged(dw_master.getrow(),dwo_1,mid(sl_param.field_ret[5],1,10))
	
	dw_master.object.vencimiento [dw_master.getrow()] = sl_param.field_date[2]
	dwo_1 = dw_master.object.vencimiento
	dw_master.Event itemchanged(dw_master.getrow(),dwo_1,mid(sl_param.field_ret[7],1,10))
	
		dw_master.accepttext()
	dw_master.ii_update = 1
	
END IF
end event

type st_2 from statictext within w_fi304_cnts_x_pagar
integer x = 3511
integer y = 372
integer width = 462
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
boolean enabled = false
string text = "Orden de Servicio"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi304_cnts_x_pagar
integer x = 3511
integer y = 256
integer width = 462
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
string text = "Orden de Compra"
boolean focusrectangle = false
end type

type pb_os from picturebutton within w_fi304_cnts_x_pagar
integer x = 3333
integer y = 344
integer width = 142
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "Cursor!"
string disabledname = "Cursor!"
end type

event clicked;String  		ls_tipo_doc_oc, ls_tipo_ref, ls_cod_cliente, ls_cod_moneda, &
			   ls_result, ls_mensaje, ls_flag_os, ls_tipo_doc_grmp
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_total
Long        ll_row,ll_ano,ll_mes

str_parametros sl_param

IF of_verifica_data_oc (ls_cod_cliente,ldc_tasa_cambio) = FALSE THEN Return

ll_row = dw_master.Getrow()
ll_ano = dw_master.object.ano [ll_row]
ll_mes = dw_master.object.mes [ll_row]


/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	RETURN
END IF

IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
	/*Recuperacion de Tipo doc Orden Compra*/
	SELECT doc_oc 
	  INTO :ls_tipo_doc_oc
	  FROM logparam
	 WHERE (reckey = '1' ) ;
	
	IF Isnull(ls_tipo_doc_oc) OR Trim(ls_tipo_doc_oc) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Orden de Compra en Tabla de Parametros LOGPARAM, Comuniquese Con Sistemas!')
		Return		
	END IF
	/**/
	
	/*Recuperacion de Tipo doc GRMP*/
	SELECT DOC_GUIA_MP
	  INTO :ls_tipo_doc_grmp
	FROM ap_param
	WHERE origen = 'XX';
	
	IF Isnull(ls_tipo_doc_grmp) OR Trim(ls_tipo_doc_grmp) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Guia de Recepción en Tabla de Parametros APPARAM, Comuniquese Con Sistemas!')
		RETURN		
	END IF
	/**/
	
	ls_tipo_ref = tab_1.tabpage_2.dw_ref_x_pagar.Object.tipo_ref[1]
	IF ls_tipo_ref = ls_tipo_doc_oc THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Servicio , Verifique!')
		RETURN
	END IF
	
	ls_tipo_ref = tab_1.tabpage_1.dw_ctas_pag_det.object.tipo_ref[1]
	IF ls_tipo_ref = ls_tipo_doc_grmp THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Compra , Verifique!')
		RETURN
	END IF
	
	is_orden_serv = tab_1.tabpage_2.dw_ref_x_pagar.Object.nro_ref[1]
ELSE
	SetNull(is_orden_serv)
END IF

//parametro de finanzas
select Nvl(flag_os_provision,'0') into :ls_flag_os from finparam where reckey = '1' ;

	
sl_param.tipo			= '1S'
sl_param.opcion		= 23         //Ordenes de Servicio ANTES 11
sl_param.titulo 		= 'Selección de Ordenes de Servicio'
//de acuerdo a control de parametros
if ls_flag_os = '1' then
	sl_param.dw_master	= 'd_abc_lista_os_pendientes_tbl'
	sl_param.dw1			= 'd_abc_item_x_os_pendientes_tbl'
else
	sl_param.dw_master	= 'd_abc_lista_os_pendientes_no_control_tbl'
	sl_param.dw1			= 'd_abc_item_x_os_pendientes_nocontrol_tbl'
end if	

sl_param.dw_m			= dw_master
sl_param.dw_d			= tab_1.tabpage_1.dw_ctas_pag_det
sl_param.dw_c			= tab_1.tabpage_2.dw_ref_x_pagar
sl_param.string1		= ls_cod_cliente
sl_param.string2		= is_orden_serv
sl_param.db1			= ldc_tasa_cambio


dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, sl_param)
IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
	IF sl_param.titulo = 's' THEN
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		wf_doc_anticipos () 
		wf_total_ref (ldc_total)
		tab_1.tabpage_1.dw_ctas_pag_det.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")
	END IF

end event

type tab_1 from tab within w_fi304_cnts_x_pagar
event ue_find_exact ( )
integer x = 507
integer y = 1104
integer width = 3593
integer height = 892
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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
		 CASE	4	
				wf_totales		   ()
		 CASE 5	//Pre Asientos
			   IF ib_estado_prea = FALSE THEN RETURN //  Editado
				of_generacion_cntas ()
END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
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
integer width = 3543
integer height = 736
integer taborder = 20
string dataobject = "d_abc_cntas_pagar_det_tbl"
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
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master



idw_mst  = dw_master								 // dw_master
idw_det  = tab_1.tabpage_1.dw_ctas_pag_det // dw_detail
end event

event itemchanged;call super::itemchanged;String  ls_matriz_cntbl, ls_item   , ls_cod_art  , ls_tipo_doc , ls_nro_doc , ls_nro_oc ,&
		  ls_flag_cant   , ls_cencos , ls_cnta_prsp, ls_null		, ls_origen  , ls_flag_cebef, &
		  ls_tipo_ref_grmp
Long    ll_count,ll_ano
Decimal {6} ldc_precio_unit
Decimal {4} ldc_cantidad
Decimal {2} ldc_total

Accepttext()

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

SetNull(ls_null)

CHOOSE CASE dwo.name
		 CASE	'centro_benef'
				ls_flag_cebef = This.object.flag_cebef   [row]
		
				IF ls_flag_cebef = '1' THEN
					select count (*) into :ll_count
					  from centro_beneficio cb,centro_benef_usuario cbu
				    where (cb.centro_benef = cbu.centro_benef ) AND
       					 (cbu.cod_usr     = :gnvo_app.is_user			 ) AND
							 (cb.centro_benef	= :data				 ) ;
						 
				   if ll_count = 0 then
						Messagebox('Aviso','Centro Beneficio No Existe ,Verifique!')
						This.Object.centro_benef [row] = ls_null
						Return 1
					end if
				END IF
				
		 CASE 'confin'
				SELECT Count(*)
				  INTO :ll_count
				  FROM concepto_financiero
				 WHERE (confin = :data);
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Concepto Financiero '+data+' No Existe , Verifique!')
					This.Object.confin 		 [row] = ''
					This.Object.matriz_cntbl [row] = ''
					Return 1
				ELSE
					SELECT matriz_cntbl
				     INTO :ls_matriz_cntbl
				     FROM concepto_financiero
				    WHERE (confin = :data);	


					IF Isnull(ls_matriz_cntbl) OR Trim(ls_matriz_cntbl) = '' THEN
						Messagebox('Aviso','Concepto Financiero '+data+' No Tiene Matriz Contable Relacionada , Verifique!')
						This.Object.confin 		 [row] = ''
						This.Object.matriz_cntbl [row] = ''
						Return 1
					ELSE
						This.Object.matriz_cntbl [row] = ls_matriz_cntbl
					END IF
				END IF
				
		 CASE 'cencos'				 
				ls_cencos    = this.object.cencos 	 [row]
				ls_cnta_prsp = this.object.cnta_prsp [row]
				ll_ano	 	 =	Long(String(dw_master.object.fecha_emision	[1],'yyyy'))
				ls_origen	 =	dw_master.object.origen [1]
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM centros_costo
			    WHERE (flag_estado = '1'   ) AND
				 		 (cencos		  = :data ) ;
						  
				IF ll_count = 0 THEN
					Messagebox('Aviso','Centro de Costo '+data+' No Existe , Verifique!')
					This.Object.cencos [row] = ''
					Return 1
				END IF
				
				if is_flag_valida_cbe = '1' then //valida centro de beneficio
					//de acuerdo a parametros 
					ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)

					if ll_count > 0 then
						This.object.flag_cebef   [row] = ls_null	//no editable tipo fondo
						This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
					else
						This.object.flag_cebef [row] = '1'     //editable		
					end if
				
					this.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	
				end if
				
		 CASE 'cnta_prsp'
				ls_cencos = this.object.cencos 			[row]
				ll_ano	 =	Long(String(dw_master.object.fecha_emision	[1],'yyyy'))
				ls_origen =	dw_master.object.origen [1]
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM presupuesto_cuenta
				 WHERE (cnta_prsp = :data) ;
				 
				IF ll_count = 0 THEN
					Messagebox('Aviso','Cuenta Presupuestal No Existe , Verifique!')
					This.Object.cnta_prsp [row] = ''
					Return 1
				END IF
				
				//de acuerdo a parametros 
				if is_flag_valida_cbe = '1' then //valida centro de beneficio
					ll_count = of_verif_partida(ll_ano,ls_cencos,data)

					if ll_count > 0 then
						This.object.flag_cebef   [row] = ls_null	//no editable tipo fondo
						This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
					else
						This.object.flag_cebef [row] = '1'     //editable		
					end if

					this.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	
				end if
				
		 CASE 'cantidad'
				/*Verificacion de Cantidad */
				ls_cod_art = this.object.cod_art [row]
				
				IF Not(Isnull(ls_cod_art) OR Trim(ls_cod_art) = '') THEN
					
					ls_tipo_doc  = This.Object.tipo_doc	 [row]
					ls_nro_doc   = This.Object.nro_doc	 [row]
					ldc_cantidad = This.Object.cantidad  [row]
					ls_cencos    = This.Object.cencos    [row]
					ls_cnta_prsp = This.Object.cnta_prsp [row]
					
					/*Recupero Nro. de Documento  Doc Referencia*/
					IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
						ls_nro_oc =tab_1.tabpage_2.dw_ref_x_pagar.Object.nro_ref  [1]
					ELSE
						Messagebox('Aviso','Verifique Documentos de Referencias , Comuniquese Con Sistemas!')
						This.object.cantidad [row] = 0.0000						
						Return 1
					END IF
					
				   ls_tipo_ref_grmp = This.object.tipo_ref[row]
					messagebox('ls_tipo_doc = ', ls_tipo_ref_grmp)
					messagebox('is_doc_grmp = ', is_doc_grmp)
					IF ls_tipo_ref_grmp = is_doc_grmp THEN 				
						ldc_precio_unit = This.object.precio_unit [row]
					ELSE
						wf_ver_cant_x_oc(ls_tipo_doc,ls_nro_doc,ls_cod_art,ls_nro_oc,is_accion,ldc_cantidad,ls_flag_cant,ldc_precio_unit,ls_cencos,ls_cnta_prsp)
					END IF
					
					IF Trim(ls_flag_cant) = '1' THEN
						Messagebox('Aviso','Se esta Excediendo en Cantidad Proyectada, Verifique!')
						This.object.cantidad [row] = 0.0000
						This.object.importe  [row] = 0.00
						Return 1
						
					ELSE
						IF Isnull(ldc_cantidad) THEN ldc_cantidad = 0.0000
						IF Isnull(ldc_precio_unit) THEN ldc_precio_unit = 0.000000
						IF ls_tipo_doc <> is_doc_grmp THEN
							This.object.importe [row] = Round(ldc_cantidad * ldc_precio_unit,2)
						END IF						
					END IF
					
				END IF
				
				ls_item = Trim(String(This.object.item [row]))
				//Recalculo de Impuesto	
			  	wf_generacion_imp (ls_item)		
				//Total  
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1
				wf_total_ref (ldc_total)
				wf_total_ref_grmp()
				
		 CASE 'importe'
				ls_item = Trim(String(This.object.item [row]))
				//Recalculo de Impuesto	
			  	wf_generacion_imp (ls_item)		
				//Total  
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1
				wf_total_ref (ldc_total)
				wf_total_ref_grmp()

END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String  		ls_cod_igv,ls_signo ,ls_cnta_cntbl ,ls_flag_dh_cxp ,ls_desc_cnta,&
				ls_item   ,ls_matriz,ls_confin
Integer 		li_row
Decimal {3} ldc_tasa_impuesto

This.Object.item[al_row] = al_row	
/*Autogeneración de Cuentas*/
ib_estado_prea = TRUE

/**/
//This.Modify("importe.Protect='1~tIf(IsNull(flag_hab),0,1)'")
//ls_matriz = sle_matriz.text

IF Isnull(ls_matriz) OR Trim(ls_matriz) = '' THEN
	SetNull(ls_confin)
	SetNull(ls_matriz)
ELSE
	//ls_confin = sle_confin.text
END IF
/**/

This.object.confin           [al_row] = ls_confin
This.object.matriz_cntbl     [al_row] = ls_matriz
This.object.tipo_cred_fiscal [al_row] = is_tip_cred
This.object.flag_cebef		  [al_row] = '1'

this.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	



/*Inserto Impuesto x Cada Item Ingresado Cuentas x Pagar Detalle*/
li_row = tab_1.tabpage_3.dw_imp_x_pagar.InsertRow(0)

tab_1.tabpage_3.dw_imp_x_pagar.object.item         [li_row] = al_row

/*Busqueda de Impuesto Pre Definido en LOGPARAM*/
SELECT cod_igv
  INTO :ls_cod_igv
  FROM logparam
 WHERE reckey = '1' ;

IF Isnull(ls_cod_igv) OR Trim(ls_cod_igv) = '' THEN
	Messagebox('Aviso','Falta Definir Codigo de I.G.V en tabla de Parametros LOGPARAM, Comuniquese Con Sistemas !')
ELSE	
	/*Tasa Impuesto Pre Definido*/
	SELECT it.tasa_impuesto,it.signo,it.cnta_ctbl,it.flag_dh_cxp,cc.desc_cnta
	  INTO :ldc_tasa_impuesto,:ls_signo,:ls_cnta_cntbl,:ls_flag_dh_cxp,:ls_desc_cnta
	  FROM impuestos_tipo it,
	  		 cntbl_cnta		 cc
	 WHERE (it.cnta_ctbl		 = cc.cnta_ctbl ) AND
	       (it.tipo_impuesto = :ls_cod_igv	  ) ;
	 
	
	tab_1.tabpage_3.dw_imp_x_pagar.object.tipo_impuesto [li_row] = ls_cod_igv
   tab_1.tabpage_3.dw_imp_x_pagar.object.tasa_impuesto [li_row] = ldc_tasa_impuesto 	
	tab_1.tabpage_3.dw_imp_x_pagar.object.cnta_ctbl	    [li_row] = ls_cnta_cntbl
	tab_1.tabpage_3.dw_imp_x_pagar.object.desc_cnta     [li_row] = ls_desc_cnta
	tab_1.tabpage_3.dw_imp_x_pagar.object.signo		    [li_row] = ls_signo
	tab_1.tabpage_3.dw_imp_x_pagar.object.flag_dh_cxp   [li_row] = ls_flag_dh_cxp
	
	
	
	tab_1.tabpage_3.dw_imp_x_pagar.ii_update = 1
	//Recalculo de Impuesto	
	ls_item = Trim(String(tab_1.tabpage_3.dw_imp_x_pagar.object.item [li_row]))
	wf_generacion_imp (ls_item)		
	
END IF
/**/

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String 		    ls_name,ls_prot,ls_flag_cebef
str_parametros   sl_param
Str_seleccionar lstr_seleccionar
dwobject   dwo_1

ls_name = dwo.name
ls_prot = This.Describe( ls_name + ".Protect")


if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'centro_benef'
				ls_flag_cebef = This.object.flag_cebef   [row]
		
				IF ls_flag_cebef = '1' THEN
					lstr_seleccionar.s_seleccion = 'S'
												 
					lstr_seleccionar.s_sql = 'SELECT CB.CENTRO_BENEF AS CODIGO,CB.DESC_CENTRO AS DESCRIPCION '&
													    +'FROM CENTRO_BENEFICIO CB,CENTRO_BENEF_USUARIO CBU '&
												       +'WHERE (CB.CENTRO_BENEF = CBU.CENTRO_BENEF) AND '&
														 +' 		(CBU.COD_USR     = '+"'"+ gnvo_app.is_user +"')"
												 
												 
				   OpenWithParm(w_seleccionar,lstr_seleccionar)
				   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    				IF lstr_seleccionar.s_action = "aceptar" THEN
		   	   	Setitem(row,'centro_benef',lstr_seleccionar.param1[1])
			    		ii_update = 1
						/*Datos del Registro Modificado*/
						ib_estado_prea = TRUE
						/**/	 
			    	END IF
				END IF
		 CASE 'confin'

				sl_param.tipo			= ''
				sl_param.opcion		= 27
				sl_param.titulo 		= 'Selección de Concepto Financiero'
				sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
				sl_param.dw1			= 'd_lista_concepto_financiero_grd'
				sl_param.dw_m			=  This
				
				OpenWithParm( w_abc_seleccion_md, sl_param)
				IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
				IF sl_param.titulo = 's' THEN
					ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE
					/**/
				END IF


		 CASE	'cencos'
			    lstr_seleccionar.s_seleccion = 'S'
			    lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS   AS CENT_COSTO ,'&
				     	      				 +'CENTROS_COSTO.DESC_CENCOS  AS DESCRIPCION_CENT_COSTO '&
			   		      				 +'FROM CENTROS_COSTO ' &
							   				 +'WHERE FLAG_ESTADO IN '+'(1)'
			    OpenWithParm(w_seleccionar,lstr_seleccionar)
			    IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    			 IF lstr_seleccionar.s_action = "aceptar" THEN
		   		 Setitem(row,'cencos',lstr_seleccionar.param1[1])
			    	 ii_update = 1
					  
					 //de acuerdo a parametros 
					 //ejecuta itemchanged
					 dwo_1 = this.object.cencos
		
					 this.Event itemchanged(row,dwo_1,lstr_seleccionar.param1[1])
					 
					 /*Datos del Registro Modificado*/
					 ib_estado_prea = TRUE
					 /**/	 
			    END IF

		 CASE 'cnta_prsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CUENTA_PRESUP ,'&
												+'PRESUPUESTO_CUENTA.DESCRIPCION		  AS DESCRIPCION	 '&
												+'FROM PRESUPUESTO_CUENTA '
												
		      OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    			IF lstr_seleccionar.s_action = "aceptar" THEN
		   		Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
			    	ii_update = 1
					 
				   dwo_1 = this.object.cnta_prsp
		
					this.Event itemchanged(row,dwo_1,lstr_seleccionar.param1[1]) 
					
					/*Datos del Registro Modificado*/
					ib_estado_prea = TRUE
					/**/	 
			   END IF


END CHOOSE
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
integer x = 9
integer y = 8
integer width = 2583
integer height = 732
integer taborder = 20
string dataobject = "d_abc_doc_referencias_ctas_pag_tbl"
boolean vscrollbar = true
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

event ue_insert_pre(long al_row);call super::ue_insert_pre;ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
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
integer x = 9
integer y = 8
integer width = 2350
integer height = 752
integer taborder = 20
string dataobject = "d_abc_cp_det_imp_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String  ls_expresion,ls_item,ls_timpuesto,ls_signo,ls_cnta_ctbl,ls_desc_cnta,&
		  ls_flag_dh_cxp
Long    ll_found
Decimal {3} ldc_tasa_impuesto 
Decimal {2} ldc_imp_total,ldc_total

Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado	


CHOOSE CASE dwo.name
		 CASE 'tipo_impuesto'
				ls_item = Trim(String(This.object.item [row]))
				
				ls_expresion = 'item = ' + ls_item + ' and '+'tipo_impuesto = '+"'"+data+"'"
				ll_found 	 = This.find(ls_expresion ,1, This.rowcount())				

				IF Not(ll_found = row OR ll_found = 0 ) THEN
					Messagebox('Aviso','Nro de Item ya Tiene Considerado Tipo de Impuesto, Verifique!')
					SetNull(ls_timpuesto)
					This.Object.tipo_impuesto [row] = ls_timpuesto
					Return 1
				END IF
				
				ls_expresion = 'item = '+ls_item
				ll_found		 = tab_1.tabpage_1.dw_ctas_pag_det.find(ls_expresion,1,tab_1.tabpage_1.dw_ctas_pag_det.Rowcount())
				
				IF ll_found > 0 THEN
					ldc_imp_total = tab_1.tabpage_1.dw_ctas_pag_det.object.total [ll_found]							
				END IF
								
				idw_tasa.Getrow()
			   ldc_tasa_impuesto = idw_tasa.GetItemNumber(idw_tasa.getrow(),'tasa_impuesto')
				ls_signo				= idw_tasa.GetItemString(idw_tasa.getrow(),'signo')
				ls_cnta_ctbl		= idw_tasa.GetItemString(idw_tasa.getrow(),'cnta_ctbl')
				ls_desc_cnta		= idw_tasa.GetItemString(idw_tasa.getrow(),'desc_cnta')
				ls_flag_dh_cxp		= idw_tasa.GetItemString(idw_tasa.getrow(),'flag_dh_cxp')
				
				
				This.Object.tasa_impuesto [row] = ldc_tasa_impuesto
				This.Object.signo			  [row] = ls_signo
				This.Object.cnta_ctbl	  [row] = ls_cnta_ctbl
				This.Object.flag_dh_cxp	  [row] = ls_flag_dh_cxp
				This.Object.desc_cnta	  [row] = ls_desc_cnta
				This.Object.importe		  [row] = Round(ldc_imp_total * ldc_tasa_impuesto ,2)/ 100
				
				//Total  
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1
				wf_total_ref (ldc_total)
				
		 CASE 'importe'						
				//Total  
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1
				wf_total_ref (ldc_total)
END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw


idw_mst  = tab_1.tabpage_3.dw_imp_x_pagar	// dw_master

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_currow,ll_item

ll_currow = tab_1.tabpage_1.dw_ctas_pag_det.GetRow()
ll_item 	 = tab_1.tabpage_1.dw_ctas_pag_det.Object.item [ll_currow]

This.Object.item [al_row] = ll_item

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
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
boolean visible = false
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
boolean enabled = false
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
integer x = 9
integer y = 8
integer width = 3081
integer height = 364
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
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
boolean visible = false
integer x = 18
integer y = 104
integer width = 3557
integer height = 772
boolean enabled = false
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
boolean vscrollbar = true
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

