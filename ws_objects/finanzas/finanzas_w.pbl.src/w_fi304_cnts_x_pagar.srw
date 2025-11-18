$PBExportHeader$w_fi304_cnts_x_pagar.srw
forward
global type w_fi304_cnts_x_pagar from w_abc
end type
type st_8 from statictext within w_fi304_cnts_x_pagar
end type
type pb_financiamiento from picturebutton within w_fi304_cnts_x_pagar
end type
type st_7 from statictext within w_fi304_cnts_x_pagar
end type
type pb_adelantos from picturebutton within w_fi304_cnts_x_pagar
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
type sle_confin from singlelineedit within w_fi304_cnts_x_pagar
end type
type rb_ff from radiobutton within w_fi304_cnts_x_pagar
end type
type rb_og from radiobutton within w_fi304_cnts_x_pagar
end type
type sle_2 from singlelineedit within w_fi304_cnts_x_pagar
end type
type st_3 from statictext within w_fi304_cnts_x_pagar
end type
type sle_1 from singlelineedit within w_fi304_cnts_x_pagar
end type
type pb_1 from picturebutton within w_fi304_cnts_x_pagar
end type
type st_2 from statictext within w_fi304_cnts_x_pagar
end type
type st_1 from statictext within w_fi304_cnts_x_pagar
end type
type pb_os from picturebutton within w_fi304_cnts_x_pagar
end type
type pb_oc from picturebutton within w_fi304_cnts_x_pagar
end type
type dw_master from u_dw_abc within w_fi304_cnts_x_pagar
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
type gb_2 from groupbox within w_fi304_cnts_x_pagar
end type
type gb_3 from groupbox within w_fi304_cnts_x_pagar
end type
type gb_4 from groupbox within w_fi304_cnts_x_pagar
end type
type gb_5 from groupbox within w_fi304_cnts_x_pagar
end type
type gb_1 from groupbox within w_fi304_cnts_x_pagar
end type
end forward

global type w_fi304_cnts_x_pagar from w_abc
integer width = 5499
integer height = 2340
string title = "[FI304] Registro de Cntas x Pagar"
string menuname = "m_mantenimiento_cl_anular_cp"
event ue_anular ( )
event ue_estado_no_def ( )
event ue_find_exact ( )
event ue_print_detra ( )
event ue_print_voucher ( )
event ue_grmp ( )
event ue_calcu ( )
event ue_adelantos ( )
st_8 st_8
pb_financiamiento pb_financiamiento
st_7 st_7
pb_adelantos pb_adelantos
st_6 st_6
pb_grmp pb_grmp
st_5 st_5
pb_2 pb_2
st_4 st_4
pb_cd pb_cd
sle_confin sle_confin
rb_ff rb_ff
rb_og rb_og
sle_2 sle_2
st_3 st_3
sle_1 sle_1
pb_1 pb_1
st_2 st_2
st_1 st_1
pb_os pb_os
pb_oc pb_oc
dw_master dw_master
tab_1 tab_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_1 gb_1
end type
global w_fi304_cnts_x_pagar w_fi304_cnts_x_pagar

type variables
String  			 	is_nro_os, is_flag_valida_cp, &
					 	is_grmp, is_doc_grmp, is_salir, is_matriz = '', is_cod_igv, &
					 	is_cod_relacion, is_tipo_doc, is_nro_doc
					 
//Variable de Estado de Transación del Documento
Long 				 	il_dias_vencimiento
DatawindowChild 	idw_doc_tipo ,idw_forma_pago
Boolean 			 	ib_estado_prea = TRUE, ib_modif_dtrp = false, ib_cierre = false

//Para medir el tiempo de provision
DateTime				idt_tiempo_prov_new, idt_tiempo_prov_modif

//Pre Asiento No editado					
u_ds_base			ids_formato_det, ids_voucher	
u_dw_abc				idw_ctas_pag_det, idw_ref_x_pagar, idw_imp_x_pagar, &
						idw_pre_asiento_cab, idw_pre_asiento_det, idw_asiento_aux, &
						idw_totales

n_cst_asiento_contable 	invo_asiento_cntbl
n_cst_detraccion			invo_detraccion
n_cst_cntas_pagar			invo_cntas_pagar

end variables

forward prototypes
public function string wf_verifica_user ()
public function decimal wf_totales ()
public function boolean wf_generacion_pre_aux ()
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public subroutine wf_ver_cant_x_oc (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_oc, string as_accion, decimal adc_cantidad, ref string as_flag_cant, ref decimal adc_precio_unit, string as_cencos, string as_cnta_prsp)
public subroutine wf_doc_anticipos ()
public function string of_cbenef_origen (string as_origen)
public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp)
public subroutine wf_estado_prea ()
protected subroutine wf_total_ref_grmp ()
public subroutine wf_find_fecha_presentacion ()
public function boolean of_verifica_documento ()
public function integer of_get_param ()
public function boolean of_verifica_data_oc (ref string as_cod_relacion, ref decimal adc_tasa_cambio)
public subroutine of_set_estado_prea (boolean ab_valor)
public subroutine of_set_nro_os (string as_nro_os)
public subroutine of_asignar_dws ()
public subroutine of_retrieve (string as_proveedor, string as_tipo_doc, string as_nro_doc)
public subroutine of_calcular_detraccion ()
public function decimal of_total_doc ()
public function boolean of_generar_asiento ()
public subroutine of_total_ref ()
public function decimal of_get_descuento ()
public subroutine of_generacion_imp (string as_item)
public subroutine of_delete_impuesto (string as_item)
public function boolean of_existe_cp (string as_proveedor, string as_tipo_doc, string as_nro_doc)
end prototypes

event ue_anular;String  	ls_flag_estado,ls_origen, &
			ls_codrel_ref, ls_tipo_ref, ls_nro_ref, ls_nro_detraccion, &
			ls_flag_detraccion
Long    	ll_row,ll_row_pasiento,ll_inicio,ll_count
Integer 	li_opcion, li_year, li_mes


dw_master.Accepttext()
ll_row = dw_master.Getrow()

if ll_row = 0 then return

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad', StopSign!)
	return
end if


IF is_action <> 'fileopen' or is_action = 'anular' THEN 
	f_mensaje("No puede anular hasta que todos los cambios hayan sido grabados", "")
	RETURN 
end if

ls_flag_estado = dw_master.object.flag_estado[ll_row]

IF ls_flag_estado = '0' then
	MessageBox('Error', 'El Documento se encuentra ANULADO, por favo verifique', StopSign!)
	return
end if

IF ls_flag_estado <> '1' then
	MessageBox('Error', 'El Documento no se encuentra ACTIVO, por lo que no se puede anular', StopSign!)
	return
end if

IF (dw_master.ii_update 				= 1 OR idw_ctas_pag_det.ii_update 		= 1 OR &
	 idw_ref_x_pagar.ii_update 		= 1 OR idw_imp_x_pagar.ii_update 		= 1 OR &
	 idw_pre_asiento_cab.ii_update 	= 1 OR idw_pre_asiento_det.ii_update 	= 1 OR &
	 idw_asiento_aux.ii_update 		= 1 ) THEN
	 
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF

li_opcion = MessageBox('Anula Documento x Pagar','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN
is_cod_relacion 		= dw_master.object.cod_relacion 		[ll_row]
is_tipo_doc 	 		= dw_master.object.tipo_doc     		[ll_row]
is_nro_doc  	 		= dw_master.object.nro_doc      		[ll_row]

ls_origen   	 		= dw_master.object.origen       		[ll_row]
ls_nro_detraccion 	= dw_master.object.nro_detraccion   [ll_row]
ls_flag_detraccion 	= dw_master.object.flag_detraccion  [ll_row]
li_year					= Integer(dw_master.object.ano  		[ll_row])
li_mes					= Integer(dw_master.object.mes  		[ll_row])

if not invo_asiento_cntbl.of_val_mes_cntbl( li_year, li_mes, 'R' ) then return

/*Verifica Si ha tenido Transaciones*/
SELECT Count(*)
  INTO :ll_count
  FROM doc_referencias
 WHERE cod_relacion 	= :is_cod_relacion 
   AND tipo_ref     	= :is_tipo_doc     
	AND nro_ref	    	= :is_nro_doc    ;
		 
/**/

IF ll_count > 0 THEN
	SELECT cod_relacion, tipo_doc, nro_doc
		into :ls_Codrel_ref, :ls_tipo_ref, :ls_nro_ref
  	FROM doc_referencias
 	WHERE cod_relacion = :is_cod_relacion 
	  AND tipo_ref     = :is_tipo_doc     
	  AND nro_ref	    = :is_nro_doc;
		  
	Messagebox('Aviso','Documento Tiene Transacciones Realizadas ,Verifique!~r~n' &
						  + 'Documento de Referencia ->~r~n' &
						  + 'Codigo Relacion: ' + ls_codrel_ref + '~r~n' &
						  + 'Tipo Doc: ' + ls_tipo_ref + '~r~n' &
						  + 'Nro Doc: ' + ls_nro_ref )
   Return
END IF

//Anulo la detraccion si lo hubiera
if ls_flag_detraccion = '1' then
	if invo_detraccion.of_anular(ls_nro_detraccion) = false then
		return
	end if
end if

//dw_master.object.flag_estado[ll_row] = '0' // Anulado
dw_master.DeleteRow(0)
dw_master.ii_update = 1

/*Elimino detalle de Cntas x pagar*/
DO WHILE idw_ctas_pag_det.Rowcount() > 0
	idw_ctas_pag_det.Deleterow(0)
	idw_ctas_pag_det.ii_update = 1
LOOP

/*Elimino Impuesto de Cntas Pagar*/
DO WHILE idw_imp_x_pagar.Rowcount() > 0
	idw_imp_x_pagar.Deleterow(0)
	idw_imp_x_pagar.ii_update = 1
LOOP

/*Elimino documentos de Referencias*/
DO WHILE idw_ref_x_pagar.Rowcount() > 0
	idw_ref_x_pagar.Deleterow(0)
	idw_ref_x_pagar.ii_update = 1
LOOP

//Cabecera de Asiento
idw_pre_asiento_cab.Object.flag_estado	 [1] = '0'
idw_pre_asiento_cab.Object.tot_solhab	 [1] = 0.00
idw_pre_asiento_cab.Object.tot_dolhab	 [1] = 0.00
idw_pre_asiento_cab.Object.tot_soldeb	 [1] = 0.00
idw_pre_asiento_cab.Object.tot_doldeb   [1] = 0.00
idw_pre_asiento_cab.ii_update = 1

//Detalle de Asiento
FOR ll_inicio = 1 TO idw_pre_asiento_det.Rowcount()
	idw_pre_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
  	idw_pre_asiento_det.Object.imp_movdol [ll_inicio] = 0.00		
	idw_pre_asiento_det.ii_update = 1
NEXT

///*Elimino documentos de Referencias*/
DO WHILE idw_asiento_aux.Rowcount() > 0
	  idw_asiento_aux.Deleterow(0)
	  idw_asiento_aux.ii_update = 1
LOOP

is_action = 'anular'

//* Inicialización de Variables de Modificación de Data *//
dw_master.ii_update  			= 1
idw_ctas_pag_det.ii_update 	= 1
idw_ref_x_pagar.ii_update  	= 1
idw_imp_x_pagar.ii_update  	= 1
idw_pre_asiento_cab.ii_update = 1
idw_pre_asiento_det.ii_update = 1
idw_asiento_aux.ii_update     = 1

ib_estado_prea = TRUE   //Autogeneración de Pre Asientos

idw_pre_asiento_det.ii_protect = 0
idw_pre_asiento_det.of_protect()


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
	is_Action = 'fileopen'	
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

event ue_print_detra();String 				ls_nro_detrac
str_parametros		lstr_param

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_nro_detrac = dw_master.object.nro_detraccion[dw_master.getrow()]

IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
	Messagebox('Aviso','No existe Detraccion Verifique!')
	return
END IF

Open(w_print_preview)
lstr_param = Message.PowerObjectParm

if lstr_param.i_return < 0 then return

if lstr_param.i_return = 1 then
	ids_formato_det.Retrieve(ls_nro_detrac)
	
	if ids_formato_det.rowcount() = 0 then 
		f_mensaje('No hay registros que mostrar para esta detraccion', 'FIN_304_02')
		return
	end if
	
	ids_formato_det.object.t_nombre.text = gs_empresa
	ids_formato_det.object.t_user.text = gs_user
	ids_formato_det.Print(True)
	
else
	lstr_param.dw1 		= 'd_rpt_formato_detraccion_x_pagar_tbl'
	lstr_param.titulo 	= 'Previo de Detraccion'
	lstr_param.string1 	= ls_nro_detrac
	lstr_param.tipo		= '1S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if



end event

event ue_print_voucher();String ls_origen
Long   ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros lstr_param

IF dw_master.RowCount() = 0 or dw_master.GetRow() = 0 THEN
	gnvo_app.of_mensaje_error('No existe Registro en la cabecera del documento, Verifique!', 'FIN_NOT_DOC')
	Return
END IF

Open(w_print_preview)
lstr_param = Message.PowerObjectParm

if lstr_param.i_return < 0 then return



ls_origen 		= dw_master.object.origen 	    [dw_master.getrow()]
ll_ano			= dw_master.object.ano	  	    [dw_master.getrow()]
ll_mes			= dw_master.object.mes	  	    [dw_master.getrow()]
ll_nro_libro	= dw_master.object.nro_libro   [dw_master.getrow()]
ll_nro_asiento	= dw_master.object.nro_asiento [dw_master.getrow()]

if lstr_param.i_return = 1 then
	ids_voucher.retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,gs_empresa)
	
	//Valido que el voucher tenga algun registro
	if ids_voucher.rowcount() = 0 then 
		gnvo_app.of_mensaje_error('Voucher no tiene registro Verifique', 'FIN_304_02')
		return
	end if
	
	ids_voucher.Object.p_logo.filename = gs_logo
	
	if ids_voucher.of_ExistsText("t_titulo1") then
		ids_voucher.object.t_titulo1.text = "Provisión de Cuentas x Pagar"
		ids_voucher.object.t_titulo1.visible = '1'
	end if	

	ids_voucher.Print(True)
else
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cp_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.integer1 	= ll_ano
	lstr_param.integer2 	= ll_mes
	lstr_param.integer3 	= ll_nro_libro
	lstr_param.integer4 	= ll_nro_asiento
	lstr_param.string2	= gs_empresa
	lstr_param.titulo		= "Provisión de Cuentas x Pagar"
	lstr_param.tipo		= '1S1I2I3I4I2S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if

end event

event ue_grmp();//Evento para mostrar las guias de Recepción de Materia Prima (GRMP)

String  		ls_tipo_doc_oc, ls_tipo_ref, ls_cod_cliente, ls_cod_moneda, &
				ls_result, ls_mensaje, ls_tipo_doc_os, ls_tipo_doc_mov_alm //,&ls_flag_os
Decimal {4} ldc_tasa_cambio
Decimal {2} ldc_total
Long        ll_row, ll_ano, ll_mes

str_parametros sl_param

IF of_verifica_data_oc (ls_cod_cliente, ldc_tasa_cambio) = FALSE THEN Return

ll_row = dw_master.Getrow()
ll_ano = dw_master.object.ano [ll_row]
ll_mes = dw_master.object.mes [ll_row]

/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

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

sl_param.tipo			= '15'
sl_param.opcion		= 14         //Guia de Recepción de Materia Prima
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
END IF

end event

event ue_adelantos();String	ls_proveedor
Decimal	ldc_total
str_parametros lstr_param


if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if

//if of_verifica_documento () = false then Return 

ls_proveedor 		= dw_master.object.cod_relacion 		[1]


lstr_param.tipo		 = '4S'
lstr_param.opcion	 	 = 1         //Descuentos pendientes
lstr_param.titulo 	 = 'Anticipos del Proveedor pendientes de Pago'
lstr_param.dw1		 	 = 'd_lista_anticipos_pend_tbl'
lstr_param.dw_m		 = dw_master
lstr_param.dw_d		 = idw_ctas_pag_det
lstr_param.dw_c		 = idw_ref_x_pagar
lstr_param.dw_i		 = idw_imp_x_pagar
lstr_param.lw_1		 = this
lstr_param.string1	 = ls_proveedor
lstr_param.string2	 = gnvo_app.finparam.is_cnta_cntbl_ant1
lstr_param.string3	 = gnvo_app.finparam.is_cnta_cntbl_ant2
lstr_param.string4	 = gnvo_app.finparam.is_cnta_cntbl_ant3

dw_master.Accepttext()

OpenWithParm( w_abc_seleccion, lstr_param)

If isNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = message.PowerObjectParm	

IF lstr_param.titulo = 's' THEN
	OF_CALCULAr_DETRACCION()
	
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	
	dw_master.ii_update = 1
	
	
	wf_doc_anticipos () 
		
	
	of_total_ref ()
	
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
String  ls_signo, ls_moneda, ls_flag_detraccion
Decimal ldc_impuesto        = 0.00,  ldc_total_imp     = 0.00 ,ldc_bruto = 0.00 , &
		   ldc_total_bruto     = 0.00, ldc_total_general = 0.00 , ldc_monto_detr, &
			ldc_tasa_cambio


idw_totales.Reset()
idw_totales.Insertrow(0)

FOR ll_inicio = 1 TO idw_ctas_pag_det.Rowcount()
	
	 ldc_bruto 		= Round(idw_ctas_pag_det.object.total [ll_inicio],2)
	 
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
	 
NEXT


FOR ll_inicio = 1 TO idw_imp_x_pagar.Rowcount()
	
	 ldc_impuesto = tab_1.tabpage_3.dw_imp_x_pagar.Object.importe [ll_inicio]
	 ls_signo	  = tab_1.tabpage_3.dw_imp_x_pagar.Object.signo   [ll_inicio]	
	 
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
	 IF     ls_signo = '+' THEN
		 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT


idw_totales.object.bruto 	 [1] = ldc_total_bruto
idw_totales.object.impuesto [1] = ldc_total_imp

//Obtengo la detraccion
ls_flag_detraccion = dw_master.object.flag_detraccion [1]

if gnvo_app.finparam.is_dtrp_prov = '1' and ls_flag_detraccion = '1' then
	ldc_monto_detr  = Dec(dw_master.object.imp_detraccion [1])
	ls_moneda		 = dw_master.object.cod_moneda	[1]
	ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio [1])
	
	if IsNull(ldc_monto_detr) then ldc_monto_detr = 0
	
	if ls_moneda = gnvo_app.is_dolares then
		if IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0 then
			ldc_monto_detr = 0
		else
			ldc_monto_detr = ldc_monto_detr / ldc_tasa_cambio
		end if
	end if
else
	ldc_monto_detr = 0
end if


ldc_total_general = ldc_total_bruto + ldc_total_imp - ldc_monto_detr




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
IF is_action = 'fileopen' THEN
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
String      ls_moneda_master, ls_moneda_ref, &
				ls_nro_guia, ls_tipo_doc_guia, ls_nro_ref, ls_nro_doc_cxp, &
				ls_doc_mov_alm, ls_expresion
Long        ll_row_master , ll_j, ll_row_ref, ll_nro_item, ll_found
Decimal 		ldc_tasa_cambio, ldc_importe, ldc_monto_soles

u_dw_abc ldw_referencias, ldw_cntas_pagar

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
			ELSEIF ls_moneda_ref = gnvo_app.is_soles		THEN
				ldc_importe = Round(ldw_cntas_pagar.object.importe[ll_j] * ldc_tasa_cambio,2)
			ELSEIF ls_moneda_ref = gnvo_app.is_dolares	THEN
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

public function boolean of_verifica_documento ();Boolean 	lb_ret =  TRUE
String  	ls_cod_relacion,ls_tipo_doc,ls_nro_doc, ls_user
Long    	ll_nro_libro,ll_count
Date		ld_fec_registro

if dw_master.RowCount() = 0 then return false

ls_cod_relacion = dw_master.object.cod_relacion [1]
ls_tipo_doc	 	 = dw_master.object.tipo_doc 	   [1]
ls_nro_doc	 	 = trim(dw_master.object.nro_doc [1])
ll_nro_libro	 = dw_master.object.nro_libro  	[1]
					

//verifica tramite documentario
if (ll_nro_libro = gnvo_app.finparam.il_nro_libro_cmp and &
	 ls_tipo_doc = gnvo_app.finparam.is_doc_fap 			and &
	 is_flag_valida_cp = '1'  ) then
	 
	select count(*) 
	  into :ll_count 
	  from cd_doc_recibido c
	 where c.cod_relacion  	= :ls_cod_relacion 
	   and c.tipo_doc	   	= :ls_tipo_doc		 
		and trim(c.nro_doc) 	= :ls_nro_doc;
							 
					
	if ll_count = 0 then
		Messagebox('Aviso','Verifique Documento no se encuentra en Tramite Documentario', StopSign!)						
		return false
	end if
end if
					
					
//VERIFIQUE SI EXISTE
select Count(*) 
	into :ll_count 
	from cntas_pagar
  where cod_relacion = :ls_cod_relacion  
    and tipo_doc		= :ls_tipo_doc      
	 and nro_doc		= :ls_nro_doc		 ;
			
if ll_count > 0 then
	select cod_usr, trunc(fecha_registro)
		into :ls_user, :ld_fec_registro
	from cntas_pagar
 	where cod_relacion 	= :ls_cod_relacion  
	  and tipo_doc			= :ls_tipo_doc      
	  and nro_doc			= :ls_nro_doc;


	Messagebox('Aviso','Verifique Documento ya ha sido Registrado! ~n~r'  &
					 		+ 'el usuario que lo registro es: ' + ls_user &
						   + ' y lo registro el día: ' + string(ld_fec_registro, 'dd/mm/yyyy') &
							+ '~r~nCod Relacion: ' + ls_cod_relacion &
							+ '~r~nTipo Doc: ' + ls_tipo_doc &
							+ '~r~nNro Doc: ' + ls_nro_doc, StopSign! )						
	return false
end if					

Return true
end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

/*Recuperacion de Tipo doc GRMP*/
SELECT DOC_GUIA_MP
  INTO :is_doc_grmp
FROM ap_param
WHERE origen = 'XX';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en AP_PARAM")
	return 0
end if

IF Isnull(is_doc_grmp) OR Trim(is_doc_grmp) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un tipo de Documento para Guia de Recepción en Tabla de Parametros APPARAM, Comuniquese Con Sistemas!')
	RETURN 0
END IF
/**/


select cod_igv
	into :is_cod_igv
from logparam
where reckey = '1';

IF Isnull(is_cod_igv) OR Trim(is_cod_igv) = '' THEN
	Messagebox('Aviso','No ha ingresado el tipo de impuesto de IGV en LOGPARAM, Comuniquese Con Sistemas!')
	RETURN 0
END IF

return 1
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

public subroutine of_set_estado_prea (boolean ab_valor);ib_estado_prea = ab_valor
end subroutine

public subroutine of_set_nro_os (string as_nro_os);is_nro_os = as_nro_os
end subroutine

public subroutine of_asignar_dws ();idw_ctas_pag_det 		= tab_1.tabpage_1.dw_ctas_pag_det
idw_ref_x_pagar  		= tab_1.tabpage_2.dw_ref_x_pagar
idw_imp_x_pagar  		= tab_1.tabpage_3.dw_imp_x_pagar
idw_totales				= tab_1.tabpage_4.dw_totales
idw_pre_asiento_cab 	= tab_1.tabpage_5.dw_pre_asiento_cab
idw_pre_asiento_det	= tab_1.tabpage_5.dw_pre_asiento_det
idw_asiento_aux		= tab_1.tabpage_6.dw_asiento_aux

end subroutine

public subroutine of_retrieve (string as_proveedor, string as_tipo_doc, string as_nro_doc);String 	ls_origen, ls_cencos, ls_cnta_prsp
Integer	li_year, li_mes, li_nro_libro, li_nro_asiento
Long		ll_inicio, ll_count

//La hora de inicio se cambia
SetNull(idt_tiempo_prov_new)
SetNull(idt_tiempo_prov_modif)

dw_master.Retrieve(as_proveedor, as_tipo_doc, as_nro_doc)

if dw_master.RowCount() = 0 then return

idw_ctas_pag_det.Retrieve(as_proveedor, as_tipo_doc, as_nro_doc)
idw_ref_x_pagar.Retrieve(as_proveedor, as_tipo_doc, as_nro_doc)
idw_imp_x_pagar.Retrieve(as_proveedor, as_tipo_doc, as_nro_doc)

ls_origen 		= dw_master.object.origen 	[dw_master.GetRow()]
li_year 			= Integer(dw_master.object.ano 			[dw_master.GetRow()])
li_mes 			= Integer(dw_master.object.mes 			[dw_master.GetRow()])
li_nro_libro	= Integer(dw_master.object.nro_libro	[dw_master.GetRow()])
li_nro_asiento	= Integer(dw_master.object.nro_asiento	[dw_master.GetRow()])

idw_pre_asiento_cab.Retrieve(ls_origen, li_year, li_mes, li_nro_libro, li_nro_asiento)
idw_pre_asiento_det.Retrieve(ls_origen, li_year, li_mes, li_nro_libro, li_nro_asiento)
idw_asiento_aux.Retrieve(ls_origen, li_year, li_mes, li_nro_libro, li_nro_asiento)	

//**//
IF idw_ref_x_pagar.Rowcount() > 0 THEN
	li_year		  = Year(date(dw_master.object.fecha_emision [dw_master.getRow()]))
	FOR ll_inicio = 1 TO idw_ctas_pag_det.Rowcount()
		 idw_ctas_pag_det.object.flag_hab  [ll_inicio] = '1'
		 
		 if gnvo_app.logistica.is_flag_valida_cbe = '1' then //valida centro de beneficio
			 ls_cencos    = idw_ctas_pag_det.object.cencos	  			[ll_inicio]
			 ls_cnta_prsp = idw_ctas_pag_det.object.cnta_prsp 			[ll_inicio]
			 
		 
			 //VERIFICAR SIEMPRE Y CUANDO CUMPLA CONDICIONES DE PARTIDA FONDO
			 ll_count = of_verif_partida(li_year,ls_cencos,ls_cnta_prsp)
					
			 idw_ctas_pag_det.object.flag_cebef   [ll_inicio] = '1'     //editable		
			
		 end if	 
		
	 NEXT
	 
END IF	
//**//

dw_master.ii_update 				= 0
idw_ctas_pag_det.ii_update		= 0
idw_ref_x_pagar.ii_update		= 0 
idw_imp_x_pagar.ii_update		= 0 
idw_pre_asiento_cab.ii_update = 0 
idw_pre_asiento_det.ii_update = 0 
idw_asiento_aux.ii_update 		= 0 

dw_master.of_protect()
idw_ctas_pag_det.of_protect()
idw_ref_x_pagar.of_protect()
idw_imp_x_pagar.of_protect()
idw_pre_asiento_cab.of_protect()
idw_pre_asiento_det.of_protect()
idw_asiento_aux.of_protect()

ib_estado_prea = False   //pre-asiento editado					
is_Action = 'fileopen'	

//Verificacion de Cierre por contabilidad
li_year 			= Integer(dw_master.object.ano [dw_master.GetRow()])
if invo_asiento_cntbl.of_mes_cerrado( li_year, li_mes, "R") then
	ib_cierre = true
	dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	dw_master.object.t_cierre.text = ''
	ib_cierre = false
end if

end subroutine

public subroutine of_calcular_detraccion ();//Actualizo el importe de la detraccion
decimal 	ldc_total, ldc_tasa_cambio, ldc_imp_soles, ldc_porc_detr
string	ls_moneda

if dw_master.getRow() = 0 then return

if ib_modif_dtrp = true then return

ldc_total = of_total_doc ()
if dw_master.object.flag_detraccion [1] = '1' then
	
	ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio [1])
	ls_moneda		 = dw_master.object.cod_moneda	[1]
	ldc_porc_detr	 = Dec(dw_master.object.porc_detraccion [1])
	
	if ls_moneda = gnvo_app.is_soles then
		ldc_imp_soles = round(ldc_total * ldc_porc_detr/ 100,invo_detraccion.of_nro_decimales())
	else
		ldc_total 	  = ldc_total * ldc_tasa_cambio
		ldc_imp_soles = round(ldc_total * ldc_porc_detr/ 100,invo_detraccion.of_nro_decimales())
	end if
	
	dw_master.object.imp_detraccion [1] = ldc_imp_soles

end if

ldc_total = wf_totales ()		
dw_master.object.importe_doc [1] = ldc_total
dw_master.ii_update = 1

end subroutine

public function decimal of_total_doc ();Long 	  ll_inicio
String  ls_signo
Decimal ldc_impuesto        = 0.00,  ldc_total_imp     = 0.00 ,ldc_bruto = 0.00 , &
		   ldc_total_bruto     = 0.00, ldc_total_general = 0.00 


FOR ll_inicio = 1 TO idw_ctas_pag_det.Rowcount()
	
	 ldc_bruto 		= Round(idw_ctas_pag_det.object.total [ll_inicio],2)
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
	 
NEXT


FOR ll_inicio = 1 TO idw_imp_x_pagar.Rowcount()
	
	 ldc_impuesto = tab_1.tabpage_3.dw_imp_x_pagar.Object.importe [ll_inicio]
	 ls_signo	  = tab_1.tabpage_3.dw_imp_x_pagar.Object.signo   [ll_inicio]	
	 
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
	 IF     ls_signo = '+' THEN
		 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT


ldc_total_general = ldc_total_bruto + ldc_total_imp




Return ldc_total_general

end function

public function boolean of_generar_asiento ();Long    ll_row
String  ls_moneda
Decimal ldc_tasa_cambio
Boolean lb_retorno

ll_row   = dw_master.Getrow()

dw_master.Accepttext()
idw_ctas_pag_det.Accepttext()
idw_imp_x_pagar.Accepttext()


IF ll_row   = 0 THEN RETURN FALSE

ls_moneda 		 = dw_master.object.cod_moneda  [ll_row]
ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio [ll_row])

IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda en la cabecera del documento, por favor verifique!', StopSign!)
	dw_master.SetFocus()
	dw_master.Setcolumn('cod_moneda')
	Return FALSE
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio en la cabecera del documento, por favor verifique!', StopSign!)
	dw_master.SetFocus()
	dw_master.Setcolumn('tasa_cambio')
	Return FALSE
END IF

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_Processing( idw_ctas_pag_det ) <> true then	
	tab_1.SelectTab(1)
END IF


lb_retorno  = invo_asiento_cntbl.of_generar_asiento_cxp_cxc (dw_master, &
																				 idw_ctas_pag_det, &
																				 idw_ref_x_pagar, &
																				 idw_imp_x_pagar, &
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

public subroutine of_total_ref ();String      ls_moneda_fap, ls_moneda_ref, ls_flag_detraccion, ls_nro_oc, ls_nro_os, ls_nro_ref, &
				ls_tipo_ref, ls_expresion, ls_nro_item
Long        ll_row_master , ll_i, ll_found
Decimal		ldc_tasa_cambio, ldc_importe, ldc_impuestos

IF idw_ref_x_pagar.Rowcount() = 0 THEN return
ll_row_master = dw_master.Getrow()

if ll_row_master = 0 then return
ls_moneda_fap		= dw_master.object.cod_moneda			[ll_row_master]
ldc_tasa_cambio 	= Dec(dw_master.object.tasa_cambio	[ll_row_master])

if IsNull(ldc_tasa_cambio) or ldc_tasa_cambio =0 then 
	gnvo_app.of_message_error( "No ha indicado la tasa de cambio por favor verifique!")
	return
end if

//Inicializo los importes de la referencia
for ll_i = 1 to idw_ref_x_pagar.RowCount()
	idw_ref_x_pagar.object.importe [ll_i] = 0
next

for ll_i = 1 to idw_ctas_pag_det.RowCount() 
	ls_nro_oc 	= idw_ctas_pag_det.object.nro_oc 	[ll_i]
	ls_nro_os 	= idw_ctas_pag_det.object.nro_os 	[ll_i]
	ls_nro_ref 	= idw_ctas_pag_det.object.nro_ref 	[ll_i]
	
	if not IsNull(ls_nro_oc) and trim(ls_nro_oc) <> '' then
		ls_nro_ref = ls_nro_oc
		ls_tipo_ref = gnvo_app.is_doc_oc
	elseif not IsNull(ls_nro_os) and trim(ls_nro_os) <> '' then
		ls_nro_ref = ls_nro_os
		ls_tipo_ref = gnvo_app.is_doc_os
	elseif ISNull(ls_nro_ref) or ls_nro_ref = '' then
		gnvo_app.of_message_error("No se ha especificado un documento de referencia en el detalle de la factura, por favor verifique!")
		idw_ctas_pag_det.SetFocus()
		idw_ctas_pag_det.selectRow(0, false)
		idw_ctas_pag_det.selectRow(ll_i, false)
		idw_ctas_pag_det.setRow(ll_i)
		return
	end if
	
	//Obtengo el importe
	ldc_importe = Dec(idw_ctas_pag_det.Object.importe [ll_i])
	
	//Obtengo el impuesto
	ldc_impuestos = 0
	ls_nro_item = String(idw_ctas_pag_det.Object.item	[ll_i])
	ls_expresion = "item=" + ls_nro_item
	ll_found	= idw_imp_x_pagar.Find(ls_expresion, 1, idw_imp_x_pagar.RowCount())
	do while ll_found > 0 and ll_found <= idw_imp_x_pagar.RowCount( )
		ldc_impuestos += Dec(idw_imp_x_pagar.object.importe [ll_found])
		
		ll_found ++
		if ll_found <= idw_imp_x_pagar.RowCount() then
			ll_found	= idw_imp_x_pagar.Find(ls_expresion, ll_found, idw_imp_x_pagar.RowCount())
		end if
	loop
	
	//ADiciono el impuesto al importe
	ldc_importe += ldc_impuestos
	
	//Buscamos la referencia para actualizar el monto
	ls_expresion = "tipo_ref='" + ls_tipo_ref +"' and nro_ref='" + ls_nro_ref +"'"
	ll_found	= idw_ref_x_pagar.Find(ls_expresion, 1, idw_ref_x_pagar.RowCount())
	if ll_found > 0 then
		//Calculo el importe para la referencia
		ls_moneda_ref		= idw_ref_x_pagar.object.cod_moneda_det	[ll_found]
		IF ls_moneda_fap = ls_moneda_ref THEN
			idw_ref_x_pagar.object.importe [ll_found] = Dec(idw_ref_x_pagar.object.importe [ll_found]) + ldc_importe
		ELSEIF ls_moneda_ref = gnvo_app.is_soles		THEN
			idw_ref_x_pagar.object.importe [ll_found] = Dec(idw_ref_x_pagar.object.importe [ll_found]) + ldc_importe / ldc_tasa_cambio
		ELSEIF ls_moneda_ref = gnvo_app.is_dolares	THEN
			idw_ref_x_pagar.object.importe [ll_found] = Dec(idw_ref_x_pagar.object.importe [ll_found]) + ldc_importe * ldc_tasa_cambio
		END IF
	end if
	
	
	idw_ref_x_pagar.ii_update =1	                
next    


end subroutine

public function decimal of_get_descuento ();decimal 	ldc_descuento, ldc_importe
Integer	li_row

ldc_descuento = 0

for li_row = 1 to idw_ctas_pag_det.RowCount()
	if (IsNull(idw_ctas_pag_det.object.nro_oc 	[li_row]) or idw_ctas_pag_det.object.nro_oc 		[li_row] = "") and &
		(IsNull(idw_ctas_pag_det.object.nro_vale 	[li_row]) or idw_ctas_pag_det.object.nro_vale 	[li_row] = "") and &
		(IsNull(idw_ctas_pag_det.object.nro_os 	[li_row]) or idw_ctas_pag_det.object.nro_os 		[li_row] = "") and &
		(IsNull(idw_ctas_pag_det.object.nro_vale 	[li_row]) or idw_ctas_pag_det.object.nro_vale 	[li_row] = "") then
	
		ldc_importe = Dec(idw_ctas_pag_det.object.importe [li_row])
		
		if ldc_importe < 0 then
			ldc_descuento += ldc_importe
		end if
	end if	
	
next

return ldc_descuento
end function

public subroutine of_generacion_imp (string as_item);String   ls_item,ls_expresion
Long 		ll_inicio,ll_found
Decimal 	ldc_total,ldc_tasa_impuesto


ls_expresion = 'item = '+as_item

//Obtengo el importe del detalle de cntas_pagar
ll_found 	  = idw_ctas_pag_det.find(ls_expresion ,1,idw_ctas_pag_det.rowcount())
IF ll_found = 0 THEN
	MessageBox('Error', 'No existe el Item ' + as_item + ' en el detalle del documento, por favor verifique!', StopSign!)
	return 
end if

ldc_total			 = idw_ctas_pag_det.object.total		    [ll_found]


//Aplico el filtro en el datawindows de impuestos
idw_imp_x_pagar.Setfilter(ls_expresion)
idw_imp_x_pagar.filter()

FOR ll_inicio = 1 TO idw_imp_x_pagar.Rowcount()
	
	idw_imp_x_pagar.ii_update = 1
	ldc_tasa_impuesto = Dec(idw_imp_x_pagar.object.tasa_impuesto [ll_inicio])
	idw_imp_x_pagar.object.importe [ll_inicio] = Round((ldc_total * ldc_tasa_impuesto ) / 100 ,2)
		 			 
NEXT
	
idw_imp_x_pagar.Setfilter('')
idw_imp_x_pagar.filter()


idw_imp_x_pagar.SetSort('item a')
idw_imp_x_pagar.Sort()


end subroutine

public subroutine of_delete_impuesto (string as_item);String   ls_expresion
Long 		ll_inicio,ll_found


ls_expresion = 'item = '+as_item

//Aplico el filtro en el datawindows de impuestos
idw_imp_x_pagar.Setfilter(ls_expresion)
idw_imp_x_pagar.filter()

FOR ll_inicio = 1 TO idw_imp_x_pagar.Rowcount()
	
	idw_imp_x_pagar.ii_update = 1
	idw_imp_x_pagar.deleteRow(ll_inicio)
		 			 
NEXT
	
idw_imp_x_pagar.Setfilter('')
idw_imp_x_pagar.filter()


idw_imp_x_pagar.SetSort('item a')
idw_imp_x_pagar.Sort()


end subroutine

public function boolean of_existe_cp (string as_proveedor, string as_tipo_doc, string as_nro_doc);return true
end function

on w_fi304_cnts_x_pagar.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_cp" then this.MenuID = create m_mantenimiento_cl_anular_cp
this.st_8=create st_8
this.pb_financiamiento=create pb_financiamiento
this.st_7=create st_7
this.pb_adelantos=create pb_adelantos
this.st_6=create st_6
this.pb_grmp=create pb_grmp
this.st_5=create st_5
this.pb_2=create pb_2
this.st_4=create st_4
this.pb_cd=create pb_cd
this.sle_confin=create sle_confin
this.rb_ff=create rb_ff
this.rb_og=create rb_og
this.sle_2=create sle_2
this.st_3=create st_3
this.sle_1=create sle_1
this.pb_1=create pb_1
this.st_2=create st_2
this.st_1=create st_1
this.pb_os=create pb_os
this.pb_oc=create pb_oc
this.dw_master=create dw_master
this.tab_1=create tab_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_8
this.Control[iCurrent+2]=this.pb_financiamiento
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.pb_adelantos
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.pb_grmp
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.pb_cd
this.Control[iCurrent+11]=this.sle_confin
this.Control[iCurrent+12]=this.rb_ff
this.Control[iCurrent+13]=this.rb_og
this.Control[iCurrent+14]=this.sle_2
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.sle_1
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.pb_os
this.Control[iCurrent+21]=this.pb_oc
this.Control[iCurrent+22]=this.dw_master
this.Control[iCurrent+23]=this.tab_1
this.Control[iCurrent+24]=this.gb_2
this.Control[iCurrent+25]=this.gb_3
this.Control[iCurrent+26]=this.gb_4
this.Control[iCurrent+27]=this.gb_5
this.Control[iCurrent+28]=this.gb_1
end on

on w_fi304_cnts_x_pagar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_8)
destroy(this.pb_financiamiento)
destroy(this.st_7)
destroy(this.pb_adelantos)
destroy(this.st_6)
destroy(this.pb_grmp)
destroy(this.st_5)
destroy(this.pb_2)
destroy(this.st_4)
destroy(this.pb_cd)
destroy(this.sle_confin)
destroy(this.rb_ff)
destroy(this.rb_og)
destroy(this.sle_2)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_os)
destroy(this.pb_oc)
destroy(this.dw_master)
destroy(this.tab_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_1)
end on

event resize;call super::resize;of_asignar_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_ctas_pag_det.width     = tab_1.tabpage_1.width   - idw_ctas_pag_det.x - 10
idw_ctas_pag_det.height    = tab_1.tabpage_1.height  - idw_ctas_pag_det.y - 10

idw_ref_x_pagar.width     	= tab_1.tabpage_2.width  - idw_ref_x_pagar.x  - 10
idw_ref_x_pagar.height     = tab_1.tabpage_2.height  - idw_ref_x_pagar.y  - 10

idw_imp_x_pagar.width     	= tab_1.tabpage_3.width - idw_imp_x_pagar.x  - 10
idw_imp_x_pagar.height     = tab_1.tabpage_3.height - idw_imp_x_pagar.y  - 10

idw_totales.width     		= tab_1.tabpage_4.width   - idw_totales.x - 10
idw_totales.height         = tab_1.tabpage_4.height  - idw_totales.y - 10

idw_pre_asiento_det.width  = tab_1.tabpage_5.width   - idw_pre_asiento_det.x - 10
idw_pre_asiento_det.height = tab_1.tabpage_5.height  - idw_pre_asiento_det.y - 10

idw_asiento_aux.height     = tab_1.tabpage_6.height  - idw_asiento_aux.y     - 10
end event

event ue_open_pre;call super::ue_open_pre;String ls_mensaje

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

of_asignar_dws()

setNull(idt_tiempo_prov_new)
setNull(idt_tiempo_prov_modif)

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_ctas_pag_det.SettransObject(sqlca)
idw_ref_x_pagar.SettransObject(sqlca)
idw_imp_x_pagar.SettransObject(sqlca)
idw_pre_asiento_cab.SettransObject(sqlca)
idw_pre_asiento_det.SettransObject(sqlca)
idw_asiento_aux.SettransObject(sqlca)

//** Datastore Formato Detraccion **//
ids_formato_det = Create u_ds_base
ids_formato_det.DataObject = 'd_rpt_formato_detraccion_x_pagar_tbl'
ids_formato_det.SettransObject(sqlca)
////** **//

//** Datastore Voucher **//
ids_voucher = Create u_ds_base
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

idw_1 = dw_master              				// asignar dw corriente
idw_ctas_pag_det.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
//TriggerEvent('ue_insert')


//Crear Objeto
invo_asiento_cntbl 	= create n_cst_asiento_contable
invo_detraccion		= create n_cst_detraccion
invo_cntas_pagar		= create n_cst_cntas_pagar

// Este flag indica si se valida el documento CP con el control documentario
select flag_valida_cp 
	into :is_flag_valida_cp 
from cdparam 
where reckey = '1' ;  



end event

event ue_insert;//Override

String  ls_flag_estado,ls_result,ls_mensaje
Long    ll_row,ll_currow,ll_ano,ll_mes
Boolean lb_result

of_asignar_dws()

ll_row = dw_master.Getrow()

CHOOSE CASE idw_1
	 	 CASE dw_master
				TriggerEvent('ue_update_request')
				
				idw_1.Reset()
				idw_ctas_pag_det.Reset	()
				idw_ref_x_pagar.Reset	()
				idw_imp_x_pagar.Reset	()
				idw_totales.Reset()
				idw_pre_asiento_cab.Reset ()
				idw_pre_asiento_det.Reset ()
				is_action = 'new'
				ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
				
 		 CASE idw_ctas_pag_det
			
				
			   IF ll_row = 0 THEN RETURN
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ll_ano			= dw_master.object.ano 			 [ll_row]
				ll_mes			= dw_master.object.mes 			 [ll_row]

				/*verifica cierre*/
				invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				//Si el periodo contable esta cerrado entonces no hago nada
				if ls_result = '0' then return
				
				//EL documento no esta activo entonces tampoco hago nada
				if ls_flag_estado <> '1' then
					gnvo_app.of_message_error("El comprobante de pago no se encuentra activo para hacer modificaciones, por favor verifique!")
					return
				end if
				
				//El comprobante de pago tiene referencias por lo que habría que preguntar al usuario si esta de acuerdo
				IF idw_ref_x_pagar.Rowcount() > 0 THEN 
					if MessageBox("Informacion", "El comprobante de pago tiene referencia a " &
						+ string(idw_ref_x_pagar.RowCount()) &
						+ " documento(s), ¿Desea ingresar una linea sin referencia?", &
						Information!, YesNo!, 2) = 2 then return
						
				end if
				
				ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
				
		 CASE idw_imp_x_pagar
			
				ll_currow 		= idw_ctas_pag_det.GetRow()
				lb_result 		= idw_ctas_pag_det.IsSelected(ll_currow)
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ll_ano			= dw_master.object.ano 			 [ll_row]
				ll_mes			= dw_master.object.mes 			 [ll_row]

				/*verifica cierre*/
				invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

				IF lb_result = FALSE then
					Messagebox('Aviso','Debe Seleccionar un item del comprobante de pago para ingresar sus impuestos')
					Return
				END IF
				
				ib_estado_prea = TRUE    //Pre Asiento No editado	Autogeneración				
				/**/
				
		 CASE	ELSE
				Return
END CHOOSE


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

idw_1.SetFocus()

IF idw_1 = dw_master THEN
	idw_1.Setcolumn('tipo_doc')
ELSEIF idw_1 = tab_1.tabpage_1.dw_ctas_pag_det THEN
	idw_1.Setcolumn('descripcion')
END IF
end event

event ue_insert_pos(long al_row);call super::ue_insert_pos;IF idw_1 = dw_master THEN
	tab_1.tabpage_5.dw_pre_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_delete;//Override
Long   ll_row,ll_ano,ll_mes
String ls_flag_estado, ls_item ,ls_expresion_imp,ls_result,ls_mensaje


if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if


CHOOSE CASE idw_1
		 CASE tab_1.tabpage_1.dw_ctas_pag_det
			
				ll_row = idw_1.Getrow()
				IF ll_row = 0 THEN RETURN		
				ls_flag_estado = dw_master.object.flag_estado [1]
				
				invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
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
				invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				
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
				invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)
				
				
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
of_total_ref ()
wf_total_ref_grmp() // Llama a la función que acumula por referencia

if idw_1 = tab_1.tabpage_2.dw_ref_x_pagar then
	wf_doc_anticipos ()
end if


end event

event ue_update_pre;Long    	ll_nro_libro, ll_nro_asiento ,ll_inicio,ll_ano,ll_mes,ll_count
Integer 	li_opcion, ll_i
String  	ls_tipo_doc      , ls_nro_doc    , ls_cod_origen 		, ls_periodo        	, ls_cod_proveedor   ,&
		  	ls_flag_estado   , ls_cnta_ctbl  , ls_tipo_ref   		, ls_nro_ref        	, &
		  	ls_origen_ref    , ls_cencos     , ls_cta_presup 		, ls_cod_moneda     	, &
		  	ls_mensaje    	 , ls_result     , ls_flag_detraccion	, ls_nro_detraccion	, &
		  	ls_const_dep		 , ls_cta_cte	  , ls_desc_glosa			, ls_bien_serv			, &
		  	ls_oper			 , ls_flag_serie , ls_msj_err		  		, ls_flag_ind			,&
		  	ls_centro_benef	 ,	ls_oper_detr  , ls_serie_cp			, ls_numero_cp
		  
Date    	ld_last_day, ld_fecha_dep, ld_fecha_emision
DateTime	ldt_tiempo_fin

Decimal 	ldc_totsoldeb,   		ldc_totdoldeb,		ldc_totsolhab     = 0.00,ldc_totdolhab     = 0.00,ldc_importe_imp = 0.00,&
			ldc_total_pagar,		ldc_monto_tot_os,	ldc_monto_fact_os = 0.00,ldc_monto_pend_os = 0.00,ldc_total_pagar_old = 0.00,&
			ldc_porc_ret_x_doc,	ldc_monto_fac,		ldc_monto_detrac,&
			ldc_porc_detrac,		ldc_saldo_sol,		ldc_saldo_dol ,	ldc_tasa_pdbe, ldc_tasa_cambio, &
			ldc_monto_tot_oc,		ldc_monto_fact_oc = 0.00,	ldc_monto_pend_oc = 0.00, ldc_total, &
			ldc_descuento,			ldc_tasa_cambio_new, ldc_tiempo_min
Boolean	lb_retorno

str_parametros 	lstr_param
nvo_numeradores 	lnvo_numeradores

try 
	ib_update_check = false
	
	dw_master.AcceptText()
	idw_ctas_pag_det.AcceptText ()
	idw_ref_x_pagar.AcceptText  ()
	idw_imp_x_pagar.AcceptText  ()
	idw_pre_asiento_cab.AcceptText ()
	idw_pre_asiento_det.AcceptText ()
	
	/*Replicación*/
	dw_master.of_set_flag_replicacion ()
	idw_ctas_pag_det.of_set_flag_replicacion ()
	idw_ref_x_pagar.of_set_flag_replicacion  ()
	idw_imp_x_pagar.of_set_flag_replicacion  ()
	idw_pre_asiento_cab.of_set_flag_replicacion ()
	idw_pre_asiento_det.of_set_flag_replicacion ()
	
	IF is_action = 'anular' THEN 
		ib_update_check = TRUE
		RETURN
	END IF
	
	/*DATOS DE CABECERA */
	IF dw_master.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Registro en la Cabecera', StopSign!)
		Return
	END IF
	
	//Obtengo el tiempo de provision
	if not IsNull(idt_tiempo_prov_new) and is_action = 'new' then
		ldt_tiempo_fin = gnvo_app.of_fecha_Actual()
		
		//Obtengo el tiempo en minutos
		select (:ldt_tiempo_fin - :idt_tiempo_prov_new) * 24 * 60
			into :ldc_tiempo_min
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al calcular el tiempo de provision NEW. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		dw_master.object.tiempo_prov_new [1] = ldc_tiempo_min
		
	end if

	//Obtengo el tiempo de provision
	if not IsNull(idt_tiempo_prov_modif) then
		ldt_tiempo_fin = gnvo_app.of_fecha_Actual()
		
		//Obtengo el tiempo en minutos
		select (:ldt_tiempo_fin - :idt_tiempo_prov_modif) * 24 * 60
			into :ldc_tiempo_min
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al calcular el tiempo de provision MODIFY. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		dw_master.object.tiempo_prov_modif [1] = DEc(dw_master.object.tiempo_prov_modif [1]) + ldc_tiempo_min
		
	end if

	//Actualizo el importe de la detraccion
	of_calcular_detraccion()
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	dw_master.ii_update = 1
	of_total_ref ()
	wf_total_ref_grmp()
	
	
	//Creo el objeto para los numeradores
	lnvo_numeradores = CREATE nvo_numeradores
	
	
	ls_tipo_doc     	= dw_master.object.tipo_doc        	[dw_master.getRow()]
	ls_nro_doc	    	= dw_master.object.nro_doc         	[dw_master.getRow()]
	ls_cod_proveedor  = dw_master.object.cod_relacion    	[dw_master.getRow()]
	ls_serie_cp			= dw_master.object.serie_cp    		[dw_master.getRow()]
	ls_numero_cp		= dw_master.object.numero_cp	    	[dw_master.getRow()]
	
	IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
		gnvo_app.of_message_error('Debe Ingresar Tipo de Documento, por favor verifique!')		
		dw_master.SetFocus( )
		dw_master.setColumn("tipo_doc")
		RETURN	
	END IF	
	
	IF Isnull(ls_serie_cp)  OR Trim(ls_serie_cp) = '' THEN
		gnvo_app.of_message_error('Debe Ingresar la serie del comprobante de pago, por favor verifique!')		
		dw_master.SetFocus( )
		dw_master.setColumn("serie_cp")
		RETURN		
	END IF
	
	IF Isnull(ls_numero_cp)  OR Trim(ls_numero_cp) = '' THEN
		gnvo_app.of_message_error('Debe Ingresar el numero del comprobante de pago, por favor verifique!')		
		dw_master.SetFocus( )
		dw_master.setColumn("numero_cp")
		RETURN		
	END IF
	
	IF Isnull(ls_cod_proveedor) OR Trim(ls_cod_proveedor) = '' THEN
		gnvo_app.of_message_error('Debe Ingresar Codigo del proveedor, por favor verifique!')		
		dw_master.SetFocus( )
		dw_master.setColumn("cod_relacion")
		RETURN	
	END IF	
	
	
	IF is_Action = 'new' THEN
		if invo_cntas_pagar.of_validar_doc( dw_master) = false then
			ROLLBACK;
			Return
		end if
		
	END IF
	
	//Verificación de Data en Cabecera de Documento
	IF gnvo_app.of_row_processing( dw_master) <> true then return
	
	//Verificación de Data en Detalle de Documento
	IF gnvo_app.of_row_processing( idw_ctas_pag_det) <> true then return 	
	
	//Verificación de Data en Impuesto de Documento
	IF gnvo_app.of_row_processing( idw_imp_x_pagar) <> true then return
	
	//Verificación de Data en Pre Asientos Auxiliares
	IF gnvo_app.of_row_processing(idw_asiento_aux) <> true then	return
	
	
	//Verificación de Detalle de Documento
	IF idw_ctas_pag_det.Rowcount() = 0 THEN 
		Messagebox('Aviso','Debe Ingresar Items en el Detalle')
		RETURN
	END IF
	
	
	////Seleccionar Informacion de Cabecera
	ls_cod_origen   	 = dw_master.Object.origen          	[dw_master.getRow()]
	ls_nro_doc	    	 = dw_master.object.nro_doc         	[dw_master.getRow()]
	ls_cod_moneda	 	 = dw_master.object.cod_moneda	   	[dw_master.getRow()]
	ll_nro_libro    	 = dw_master.object.nro_libro       	[dw_master.getRow()]
	ll_nro_asiento	 	 = dw_master.object.nro_asiento	   	[dw_master.getRow()]
	ll_ano			    = dw_master.object.ano	  			   	[dw_master.getRow()]
	ll_mes		       = dw_master.object.mes				   	[dw_master.getRow()]
	ls_flag_estado	    = dw_master.object.flag_estado	   	[dw_master.getRow()]
	ld_fecha_emision   = Date(dw_master.object.fecha_emision [dw_master.getRow()])
	ldc_monto_fac	    = dw_master.object.importe_doc	   	[dw_master.getRow()]
	ldc_tasa_cambio    = dw_master.object.tasa_cambio	   	[dw_master.getRow()]
	ls_desc_glosa		 = dw_master.object.descripcion			[dw_master.getRow()]
	
	//Detraccion
	ls_bien_serv		 = dw_master.object.bien_serv		   		[dw_master.getRow()]
	ldc_monto_detrac   = Dec(dw_master.object.imp_detraccion 	[dw_master.getRow()])
	ls_nro_detraccion  = dw_master.object.nro_detraccion  		[dw_master.getRow()]
	ldc_porc_detrac	 = Dec(dw_master.object.porc_detraccion 	[dw_master.getRow()])
	ls_flag_detraccion = dw_master.object.flag_detraccion 		[dw_master.getRow()]
	ls_oper_detr		 = dw_master.object.oper_detr			 		[dw_master.getRow()]
	
	//Valido si la tasa de cambio corresponde a la de la fecha de emision, sino no me deja guardarlo
	ldc_tasa_cambio_new = gnvo_app.of_tasa_cambio(ld_fecha_emision)
	
	if ldc_tasa_Cambio <> ldc_tasa_cambio_new then
		MessageBox('Error', 'El tipo de cambio que tiene el documento no es el mismo que esta registrado ' &
								+ 'en la tabla de Tipo de Cambio, por favor verifique!' &
								+ '~r~nFecha Emision: ' + string(ld_fecha_emision, 'dd/mm/yyyy') &
								+ '~r~nTipo Cambio Documento: ' + string(ldc_tasa_cambio, '###,##0.0000') &
								+ '~r~nTipo Cambio Tabla: ' + string(ldc_tasa_cambio_new, '###,##0.0000'), StopSign!)
								
								 
		dw_master.SetFocus()
		dw_master.setColumn( "fecha_emision" )
		return
	end if
	
	select flag_separ_serie 
		into :ls_flag_serie 
	from doc_tipo 
	where tipo_doc = :ls_tipo_doc ;
	
	if ls_flag_serie = '1' then
		if IsNull(ls_serie_cp) or trim(ls_serie_cp) = '' or ls_serie_cp = '0000' then
			gnvo_app.of_message_error('El tipo de documento ' + ls_tipo_doc + ' exige que tenga un numero de serie en el comprobante de pago por favor verifique!')
			dw_master.object.serie_cp [1] = gnvo_app.is_null
			dw_master.SetFocus()
			dw_master.setColumn( "serie_cp" )
			RETURN
		end if
		
		if Pos(ls_nro_doc,'-',1) = 0  then
			gnvo_app.of_message_error('Debe Colocar un guion (-) en el numero del documento, para separar la serie del numero, por favor Verifique!')
			RETURN
		end if
	end if
	
	if ls_flag_detraccion = '1' then
		if IsNull(ls_bien_serv) or trim(ls_bien_serv) = '' then
			Messagebox('Error','No se ha especificado el codigo del bien o servicio para la detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('bien_serv')
			dw_master.setFocus( )
			RETURN	
		end if
		if IsNull(ls_oper_detr) or trim(ls_oper_detr) = '' then
			Messagebox('Error','No se ha especificado el codigo de la operacion de la detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('oper_detr')
			dw_master.setFocus( )
			RETURN	
		end if
		if IsNull(ldc_porc_detrac) or ldc_porc_detrac = 0.00 then
			Messagebox('Error','No se ha especificado el porcentaje de detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('bien_serv')
			dw_master.setFocus( )
			RETURN	
		end if
		if IsNull(ldc_monto_detrac) or ldc_monto_detrac = 0.00 then
			Messagebox('Error','No se ha especificado el Importe de detraccion, por favor verifique!', StopSign!)		
			dw_master.SetColumn('bien_serv')
			dw_master.setFocus( )
			RETURN	
		end if
	end if
	
	
	/*verifica cierre*/
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return 
	
	
	//Verificación de importe de documento
	of_total_ref()
	for ll_i = 1 to idw_ref_x_pagar.Rowcount()
		ls_tipo_ref     = idw_ref_x_pagar.object.tipo_ref   	[1]
		ls_origen_ref   = idw_ref_x_pagar.object.origen_ref 	[1]
		ls_nro_ref	    = idw_ref_x_pagar.object.nro_ref    	[1]
		ldc_total_pagar = Dec(idw_ref_x_pagar.object.nro_ref  [1])
		
		IF ls_tipo_ref = gnvo_app.is_doc_os THEN
			
			gnvo_app.finparam.of_get_monto_os(ls_nro_ref, ldc_monto_fact_os, ldc_monto_tot_os)
		
			IF is_Action = 'fileopen' THEN
				SELECT Nvl(importe_doc,0) + 
						case when cod_moneda = :gnvo_app.is_soles then
							nvl(cp.imp_detraccion, 0)
						else
							nvl(cp.imp_detraccion / cp.tasa_cambio, 0)
						end 
				  INTO :ldc_total_pagar_old
				  FROM cntas_pagar cp
				 WHERE cod_relacion = :ls_cod_proveedor 
					AND tipo_doc     = :ls_tipo_doc    
					AND nro_doc      = :ls_nro_doc     ;
						  
				ldc_total_pagar 	= ldc_total_pagar + (ldc_monto_fact_os - ldc_total_pagar_old)
				ldc_monto_pend_os	= Round(ldc_monto_tot_os - (ldc_monto_fact_os - ldc_total_pagar_old),2)
				
			ELSEIF is_Action = 'new' THEN 	
				
				ldc_total_pagar 	= Round(ldc_total_pagar + ldc_monto_fact_os,2)
				ldc_monto_pend_os	= Round(ldc_monto_tot_os - ldc_monto_fact_os,2)
				
			END IF
			
			ldc_descuento = abs(this.of_get_descuento())
			
			IF ldc_total_pagar - ldc_descuento > ldc_monto_tot_os THEN
				if MessageBox("Informacion", &
								  'La Orden de Servicio ' + ls_nro_ref + &
								  ' no puede ser Facturado por un monto mayor a ' &
								  + Trim(String(ldc_monto_tot_os, '#,###,##0.00')) &
								  + " y el monto que se desea provisionar es de " &
								  + trim(string((ldc_total_pagar - ldc_descuento), '#,###,##0.00')) &
								  + "~r~nDesea continuar?", Information!, YesNo!, 2 ) = 2 then 
					return
				end if

			END IF
			
		ELSEIF ls_tipo_ref = gnvo_app.is_doc_oc THEN		
			
			gnvo_app.finparam.of_get_monto_oc(ls_nro_ref, ldc_monto_fact_oc, ldc_monto_tot_oc)
		
			IF is_Action = 'fileopen' THEN
				SELECT Nvl(importe_doc,0) + 
						case when cod_moneda = :gnvo_app.is_soles then
							nvl(cp.imp_detraccion, 0)
						else
							nvl(cp.imp_detraccion / cp.tasa_cambio, 0)
						end
				  INTO :ldc_total_pagar_old
				  FROM cntas_pagar cp
				 WHERE cod_relacion = :ls_cod_proveedor 
					AND tipo_doc     = :ls_tipo_doc    
					AND nro_doc      = :ls_nro_doc     ;
						  
				ldc_total_pagar 	= ldc_total_pagar + (ldc_monto_fact_oc - ldc_total_pagar_old)
				ldc_monto_pend_oc	= Round(ldc_monto_tot_oc - (ldc_monto_fact_oc - ldc_total_pagar_old),2)
				
			ELSEIF is_Action = 'new' THEN 	
				
				ldc_total_pagar 	= Round(ldc_total_pagar + ldc_monto_fact_oc,2)
				ldc_monto_pend_oc	= Round(ldc_monto_tot_oc - ldc_monto_fact_oc,2)
				
			END IF
			
			ldc_descuento = abs(this.of_get_descuento())
			
			IF ldc_total_pagar - ldc_descuento > ldc_monto_tot_oc THEN
				if MessageBox("Informacion", &
								  'La Orden de Compra ' + ls_nro_ref + &
								  ' no puede ser Facturado por un monto mayor a ' + &
								  Trim(String((ldc_monto_tot_oc - ldc_descuento), '#,###,##0.00')) &
								  + " y el monto que se desea provisionar es de " + &
								  trim(string(ldc_total_pagar, '#,###,##0.00')) + &
								  "~r~nDesea continuar?", &
								  Information!, Yesno!, 2) = 2 then
					RETURN
				end if
			END IF
	
		END IF
	NEXT
	
	
	//Montos en soles y dolares
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
	
	
	IF gnvo_app.is_agente_ret = '1' and ls_flag_detraccion = '0' THEN /*RETIENE Y NO TIENE DETRACCION*/
		/*CONVERTIR A SOLES*/
		IF ls_cod_moneda = gnvo_app.is_soles THEN
			ldc_monto_fac	 = dw_master.object.importe_doc [1]
		ELSE
			ldc_monto_fac	 = Round(dw_master.object.importe_doc [1] * ldc_tasa_cambio,2)
		END IF
	
		IF ldc_monto_fac > gnvo_app.idc_monto_retencion THEN
			ldc_porc_ret_x_doc = dw_master.Object.porc_ret_igv [1]
			IF Isnull(ldc_porc_ret_x_doc) THEN ldc_porc_ret_x_doc = 0.00
			IF ldc_porc_ret_x_doc <> gnvo_app.idc_tasa_retencion THEN
				dw_master.Object.porc_ret_igv [1] = gnvo_app.idc_tasa_retencion
				dw_master.ii_update = 1
			end if	
		END IF
	else
		ldc_porc_ret_x_doc = dw_master.Object.porc_ret_igv [1]
		IF Isnull(ldc_porc_ret_x_doc) THEN ldc_porc_ret_x_doc = 0.00
		IF ldc_porc_ret_x_doc <> 0 THEN
			dw_master.Object.porc_ret_igv [1] = 0
			dw_master.ii_update = 1
		end if	
	END IF	
	
	//GENERO EL NUMERO DE LA DETRACCION
	IF ls_flag_detraccion = '1' THEN
		//Recalcula la detraccion
		of_calcular_detraccion()
	
		//verifica porcentaje	
		if isnull(ldc_porc_detrac) or ldc_porc_detrac = 0.00 then
			Messagebox('Aviso','Debe Ingresar Porcentaje Detracción')
			dw_master.Setfocus()
			dw_master.SetColumn('porc_detraccion')
			Return			
		end if
		
		//Si no hay detraccion entonces creo el numero de la detraccion y solicito si tiene o 
		//no la constancia de deposito
		if IsNull(ls_nro_detraccion) or ls_nro_detraccion = "" or is_action = 'new' then
			ls_nro_detraccion = invo_detraccion.of_next_nro(ls_cod_origen)
			
			dw_master.object.nro_detraccion [1] = ls_nro_detraccion
			dw_master.object.ind_detrac	  [1]	= gnvo_app.is_null
			
			ib_estado_prea = true
			
		else
			
			select count(*)
			  into :ll_count
			from detraccion
			where nro_detraccion = :ls_nro_detraccion;
			
			// Obtengo la constancia de desposito y la fecha de deposito
			if ll_count > 0 then
				select nro_deposito, fecha_deposito
					into :ls_const_dep, :ld_fecha_dep
				from detraccion
				where nro_detraccion = :ls_nro_detraccion;
			end if			
		end if
		
		if IsNull(ls_const_dep) or trim(ls_const_dep) = '' or IsNull(ld_fecha_dep) then
			li_opcion = Messagebox('Aviso','Desea Colocar Datos del Deposito o Detracción',Question!,Yesno!,2)
			
			if li_opcion = 1 then
				//ventana de ayuda
				lstr_param.string1 = ls_const_dep
				lstr_param.fecha1	 = ld_fecha_dep
				
				OpenWithParm(w_help_constacia_dep_x_pag, lstr_param)
				
				//*Datos Recuperados
				If IsValid(message.PowerObjectParm) Then
					lstr_param = message.PowerObjectParm
					
					If lstr_param.bret Then
						ls_const_dep  = lstr_param.string1
						ld_fecha_dep  = lstr_param.fecha1
					Else
						Return	
					End If 
				end if 
			else
				SetNull(ls_const_dep)
				SetNull(ld_fecha_dep)
			end if //si ingreso constancia
		end if
		
		if is_action = 'new' then
			if invo_detraccion.of_duplicado( ls_nro_detraccion ) then
				ROLLBACK;
				gnvo_app.of_mensaje_error( "Número de detracción " + ls_nro_detraccion + " ya existe en cntas por pagar, por favor verifique!" )
				return
			end if
			
		end if
	END IF
	
	// Genero el numero de Asiento
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
		
		/*generacion de asientos*/	
		IF invo_asiento_cntbl.of_get_nro_asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  = FALSE THEN
			ROLLBACK;
			Return
		END IF	
		
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
		
		//asignacion de año y mes
		idw_pre_asiento_cab.Object.ano [1] = ll_ano
		idw_pre_asiento_cab.Object.mes [1] = ll_mes
	
	END IF
	
	
	//Generación Automaticas de pre Asientos
	IF ib_estado_prea = TRUE THEN 
		IF of_generar_asiento() = FALSE THEN  return 
	END IF
	
	
	//DETRACCION
	IF ls_flag_detraccion = '1' THEN
		
		ldc_monto_detrac   = Dec(dw_master.object.imp_detraccion 	[dw_master.getRow()])
		//update de la detraccion
		invo_detraccion.idw_master = dw_master
		
		IF invo_detraccion.of_update(	ls_cod_origen, &			
												ls_nro_detraccion,&
												ls_cod_proveedor, &
												ls_desc_glosa, &
												ld_fecha_emision, &
												ls_const_dep,&
												ld_fecha_dep,&
												gnvo_app.is_soles, &
												ldc_tasa_cambio, &
												ldc_monto_detrac, &
												'3') = FALSE THEN
			ROLLBACK;
			Return								 
		END IF
		
	elseIF ls_flag_detraccion = '0' THEN
		
		if is_Action = 'fileopen'	 then
			/*Buscar Nro de Detracción*/
			select nro_detraccion 
				into :ls_nro_detraccion 
				from cntas_pagar cp
			 where cp.cod_relacion 	= :ls_cod_proveedor 
				and cp.tipo_doc		= :ls_tipo_doc		
				and cp.nro_doc			= :ls_nro_doc;
	
			select count(*) 
			  into :ll_count 
			from detraccion 
			where nro_detraccion = :ls_nro_detraccion ;
			
			if ll_count > 0 then
				li_opcion = Messagebox('Aviso','Esta Segura de Eliminar Datos de la Detracción ' + ls_nro_detraccion + '?',Question!,YesNo!,2)
				
				if li_opcion = 2 then return
					
				if invo_detraccion.of_anular(ls_nro_detraccion) = false then return
				
			end if		
		end if	
	END IF
	
	
	///detalle de Documento
	FOR ll_inicio = 1 TO idw_ctas_pag_det.Rowcount()
		 
		 idw_ctas_pag_det.object.tipo_doc 	  [ll_inicio]  = ls_tipo_doc		 
		 idw_ctas_pag_det.object.nro_doc  	  [ll_inicio]  = ls_nro_doc		
		 idw_ctas_pag_det.object.cod_relacion [ll_inicio]  = ls_cod_proveedor
		 ls_centro_benef = idw_ctas_pag_det.object.centro_benef [ll_inicio]	 
		 
		 if gnvo_app.logistica.is_flag_valida_cbe = '1' then //valida centro de beneficio
			 IF Isnull(ls_centro_benef) OR Trim(ls_centro_benef) = '' THEN
				  Messagebox('Aviso','Debe Ingresar Centro de Beneficio , Verifique!')
				  idw_ctas_pag_det.SetFocus()
				  idw_ctas_pag_det.Scrolltorow(ll_inicio)
				  idw_ctas_pag_det.SetColumn('centro_benef')
				  Return	
			 END IF
		 end if
	
		 IF ls_flag_estado = '1' THEN //GENERADO
			 IF idw_ref_x_pagar.Rowcount() = 0 THEN
				 ls_cencos     = idw_ctas_pag_det.object.cencos    [ll_inicio]
				 ls_cta_presup = idw_ctas_pag_det.object.cnta_prsp [ll_inicio]
			 
				 IF Isnull(ls_cencos) OR Trim(ls_cencos) = '' THEN
					 Messagebox('Aviso','Debe Ingresar Centro de Costo , Verifique!')
					 idw_ctas_pag_det.SetFocus()
					 idw_ctas_pag_det.Scrolltorow(ll_inicio)
					 idw_ctas_pag_det.SetColumn('cencos')
					 Return
				 END IF
			 
				 IF Isnull(ls_cta_presup) OR Trim(ls_cta_presup) = '' THEN
					 Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal , Verifique!')
					 idw_ctas_pag_det.SetFocus()
					 idw_ctas_pag_det.Scrolltorow(ll_inicio)
					 idw_ctas_pag_det.SetColumn('cnta_prsp')
					 Return
				 END IF
			END IF
		END IF
		
		
	NEXT
	
	///Referencias de Documentos
	FOR ll_inicio = 1 TO idw_ref_x_pagar.Rowcount()
		 idw_ref_x_pagar.object.tipo_doc     [ll_inicio] = ls_tipo_doc		 
		 idw_ref_x_pagar.object.nro_doc      [ll_inicio] = ls_nro_doc		 
		 idw_ref_x_pagar.object.cod_relacion [ll_inicio] = ls_cod_proveedor	 
	NEXT
	
	///Impuestos
	FOR ll_inicio = 1 TO idw_imp_x_pagar.Rowcount()
		 idw_imp_x_pagar.object.tipo_doc 	  [ll_inicio] = ls_tipo_doc		 
		 idw_imp_x_pagar.object.nro_doc  	  [ll_inicio] = ls_nro_doc	
		 idw_imp_x_pagar.object.cod_relacion  [ll_inicio] = ls_cod_proveedor
		 
		 /*Verifica Monto de Impuesto sea Mayor a 0*/
		 ldc_importe_imp = idw_imp_x_pagar.object.importe [ll_inicio]
		 IF ls_flag_estado = '1' THEN   //Generado
			 IF Isnull(ldc_importe_imp) OR ldc_importe_imp = 0 THEN
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
		 idw_pre_asiento_det.object.fec_cntbl   [ll_inicio] = ld_fecha_emision
		 
		 IF wf_verifica_flag_cntas (ls_cnta_ctbl,ls_tipo_doc,ls_nro_doc,ls_cod_proveedor,ll_inicio) = FALSE THEN
			 Messagebox('Aviso','Flag de Cuenta Contable '+ls_cnta_ctbl +'Tiene Problemas ,Verifique!')
			 Return	
		 END IF
	NEXT
	
	//Detalle de Pre Asientos Auxiliares
	FOR ll_inicio = 1 TO idw_asiento_aux.Rowcount()
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
	IF is_Action = 'new' THEN
		idw_pre_asiento_cab.Object.origen      [1] = ls_cod_origen
		idw_pre_asiento_cab.Object.nro_libro 	[1] = ll_nro_libro
		idw_pre_asiento_cab.Object.ano 			[1] = ll_ano
		idw_pre_asiento_cab.Object.mes 			[1] = ll_mes
		idw_pre_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento
	END IF	
	
	//Cabecera de asiento datos Complementarios
	idw_pre_asiento_cab.Object.cod_moneda	 [1] = dw_master.object.cod_moneda     [1]
	idw_pre_asiento_cab.Object.tasa_cambio	 [1] = dw_master.object.tasa_cambio    [1]
	idw_pre_asiento_cab.Object.desc_glosa	 [1] = mid(ls_desc_glosa, 1, 200)
	idw_pre_asiento_cab.Object.fec_registro [1] = dw_master.object.fecha_registro [1]
	idw_pre_asiento_cab.Object.fecha_cntbl  [1] = ld_fecha_emision
	idw_pre_asiento_cab.Object.cod_usr		 [1] = dw_master.object.cod_usr 	 	   [1]
	idw_pre_asiento_cab.Object.flag_estado	 [1] = dw_master.object.flag_estado    [1]
	idw_pre_asiento_cab.Object.tot_solhab	 [1] = ldc_totsolhab
	idw_pre_asiento_cab.Object.tot_dolhab	 [1] = ldc_totdolhab
	idw_pre_asiento_cab.Object.tot_soldeb	 [1] = ldc_totsoldeb
	idw_pre_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb
	
	IF idw_pre_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1
	IF dw_master.ii_update = 1 THEN idw_pre_asiento_cab.ii_update = 1
	
	// valida asientos descuadrados
	if not invo_asiento_cntbl.of_validar_asiento(idw_pre_asiento_det) then return 
	
	ib_update_check = true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	
finally
	destroy lnvo_numeradores
	
end try



end event

event ue_update;Boolean 	lbo_ok = TRUE
Long    	ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento, ll_row
String  	ls_flag_estado,ls_origen, ls_mensaje, ls_cod_relacion, ls_tipo_doc, ls_nro_doc, &
			ls_action_old

try 
	//Almaceno la variable action
	ls_action_old = is_action
	
	dw_master.AcceptText()
	idw_ctas_pag_det.AcceptText()
	idw_ref_x_pagar.AcceptText()
	idw_imp_x_pagar.AcceptText()
	idw_pre_asiento_cab.AcceptText()
	idw_pre_asiento_det.AcceptText()
	idw_asiento_aux.AcceptText()
	
	
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN 
		Rollback ;
		RETURN
	END IF
	
	// Grabo el Log de Maestro
	IF ib_log THEN
		dw_master.of_create_log()
		idw_ctas_pag_det.of_create_log()
		idw_ref_x_pagar.of_create_log()
		idw_imp_x_pagar.of_create_log()
		idw_pre_asiento_cab.of_create_log()
		idw_pre_asiento_det.of_create_log()
		idw_asiento_aux.of_create_log()
	END IF
	
	//ejecuta procedimiento de actualizacion de tabla temporal
	IF idw_pre_asiento_det.ii_update = 1 and is_Action <> 'new' THEN
		ll_row_det     = idw_pre_asiento_cab.Getrow()
		ls_origen      = idw_pre_asiento_cab.Object.origen      [ll_row_det]
		ll_ano         = idw_pre_asiento_cab.Object.ano         [ll_row_det]
		ll_mes         = idw_pre_asiento_cab.Object.mes         [ll_row_det]
		ll_nro_libro   = idw_pre_asiento_cab.Object.nro_libro   [ll_row_det]
		ll_nro_asiento = idw_pre_asiento_cab.Object.nro_asiento [ll_row_det]
		
		if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
			Rollback ;
			Return
		end if	
	END IF	
	
	
	IF idw_pre_asiento_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
		IF idw_pre_asiento_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
			lbo_ok = FALSE
			Messagebox("Error en Grabacion Asiento Cabecera","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_pre_asiento_det.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF tab_1.tabpage_5.dw_pre_asiento_det.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Asiento Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF is_Action <> 'anular' THEN
		
		IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
			IF dw_master.Update(true, false) = -1 then		// Grabación Cabecera de Ctas x Pagar
				lbo_ok = FALSE
				Messagebox('Error en Grabación de Cabecera de Ctas x Pagar','Se ha procedido al rollback',exclamation!)
			END IF
		END IF
		
		IF	idw_ref_x_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_ref_x_pagar.Update(true, false) = -1 then		// Grabacion de Doc Referencias
				lbo_ok = FALSE
				Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
			END IF
		END IF
	
	
		IF	idw_ctas_pag_det.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_ctas_pag_det.Update(true, false) = -1 then		// Grabacion de Doc Referencias
				lbo_ok = FALSE
				Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
			END IF
		END IF
		
		IF idw_imp_x_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_imp_x_pagar.Update (true, false) = -1 then //Grabacion de Impuestos
				lbo_ok = FALSE
				Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
			END IF
		END IF
	
		
	ELSE
		
		//Anulacion del asiento contable
		update cntbl_asiento ca
		   set ca.flag_estado = '0'
		where ca.origen 		= :ls_origen
		  and ca.ano			= :ll_ano
		  and ca.mes			= :ll_mes
		  and ca.nro_libro	= :ll_nro_libro
		  and ca.nro_asiento	= :ll_nro_asiento;

		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al ANULAR el Asiento Contable. Mensaje: ' + ls_mensaje, STopSign!)
			return
		end if
		  
		//Anulacion del documento
		update cntas_pagar cp
		   set cp.flag_estado 	= '0',
				 cp.descripcion	= 'ANULADO POR SIGRE'
		 where cp.cod_relacion = :is_cod_relacion
		   and cp.tipo_doc	  = :is_tipo_doc
			and cp.nro_doc		  = :is_nro_doc;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al cambiar el flag de estado en tabla Cntas_pagar. Mensaje: ' + ls_mensaje, STopSign!)
			return
		end if
		
		//Eliminar doc_referencias
		delete doc_referencias dr
		 where dr.cod_relacion = :is_cod_relacion
		   and dr.tipo_doc	  = :is_tipo_doc
			and dr.nro_doc		  = :is_nro_doc;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al eliminar registros en tabla DOC_REFERENCIAS. Mensaje: ' + ls_mensaje, STopSign!)
			return
		end if

		//Eliminar cp_doc_det_imp
		delete cp_doc_det_imp i
		 where i.cod_relacion = :is_cod_relacion
		   and i.tipo_doc	  = :is_tipo_doc
			and i.nro_doc		  = :is_nro_doc;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al eliminar registros en tabla CP_DOC_DET_IMP. Mensaje: ' + ls_mensaje, STopSign!)
			return
		end if
		
		//Eliminar CNTAS_PAGAR_DET
		delete cntas_pagar_Det cpd
		 where cpd.cod_relacion = :is_cod_relacion
		   and cpd.tipo_doc	  = :is_tipo_doc
			and cpd.nro_doc		  = :is_nro_doc;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al eliminar registros en tabla CNTAS_PAGAR_DET. Mensaje: ' + ls_mensaje, STopSign!)
			return
		end if

		//Eliminar CNTAS_PAGAR
		delete cntas_pagar cp
		 where cp.cod_relacion = :is_cod_relacion
		   and cp.tipo_doc	  = :is_tipo_doc
			and cp.nro_doc		  = :is_nro_doc;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al eliminar registros en tabla CNTAS_PAGAR. Mensaje: ' + ls_mensaje, STopSign!)
			return
		end if
		
	END IF
	
	IF idw_asiento_aux.ii_update = 1 AND lbo_ok = TRUE THEN
		IF	idw_asiento_aux.Update (true, false) = -1 then //Grabación de Pre Asientos Auxiliares
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Pre Asientos Auxiliares ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
	IF ib_log and lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_ctas_pag_det.of_save_log()
		lbo_ok = idw_ref_x_pagar.of_save_log()
		lbo_ok = idw_imp_x_pagar.of_save_log()
		lbo_ok = idw_pre_asiento_cab.of_save_log()
		lbo_ok = idw_pre_asiento_det.of_save_log()
		lbo_ok = idw_asiento_aux.of_save_log()
		
	END IF
	
	if not lbo_ok then
		ROLLBACK;
		return
	end if
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_ctas_pag_det.ii_update 	= 0
	idw_ref_x_pagar.ii_update 		= 0
	idw_imp_x_pagar.ii_update 		= 0
	idw_pre_asiento_cab.ii_update = 0
	idw_pre_asiento_det.ii_update = 0
	idw_asiento_aux.ii_update 		= 0

	//QUITO LOS FLAGS DE ACTUALIZACION
	dw_master.ResetUpdate()
	idw_ctas_pag_det.ResetUpdate()
	idw_ref_x_pagar.ResetUpdate()
	idw_imp_x_pagar.ResetUpdate()
	idw_pre_asiento_cab.ResetUpdate()
	idw_pre_asiento_det.ResetUpdate()
	idw_asiento_aux.ResetUpdate()

	ib_estado_prea = False   //pre-asiento editado		
	
	if dw_master.RowCount() > 0 then
		ls_cod_relacion 	= dw_master.object.cod_relacion 	[1]
		ls_tipo_doc 		= dw_master.object.tipo_doc 		[1]
		ls_nro_doc 			= dw_master.object.nro_doc 		[1]
	end if
	
	
	ls_mensaje = 'Cambios grabados satisfactoriamente ' 
	if dw_master.RowCount() > 0  then
		if is_Action = 'new' then
			ll_row = dw_master.getRow()
			ls_origen      = dw_master.Object.origen      [ll_row]
			ll_ano         = dw_master.Object.ano         [ll_row]
			ll_mes         = dw_master.Object.mes         [ll_row]
			ll_nro_libro   = dw_master.Object.nro_libro   [ll_row]
			ll_nro_asiento = dw_master.Object.nro_asiento [ll_row]
	
	
			ls_mensaje += '~n~rVoucher Generado: ' +  ls_origen + string(ll_ano, '0000') &
						  + string(ll_mes, '00') + string(ll_nro_libro, '00') &
						  + string(ll_nro_asiento, '000000')
		end if
		
		//Hago un retrieve
		of_retrieve(ls_cod_relacion, ls_tipo_doc, ls_nro_doc)
		
	end if


	f_mensaje(ls_mensaje, "")
	
	//Enviar email al proveedor
	if dw_master.getRow() > 0 then
		if ls_action_old = 'new' then
			
			if gnvo_app.of_Get_parametro("FIN_ENVIO_CNTAS_PAGAR_PROV", "0") = "1" then
				if MessageBox('Aviso', 'Comprobante Registrado. Desea enviar por email al proveedor, sobre el registro de su comprobante de pago?', &
											Information!, YesNo!, 1) = 1 then
					
					
					invo_cntas_pagar.of_enviar_email(ls_cod_relacion, ls_tipo_doc, ls_nro_doc)
				end if
			end if
		end if
		
		
		
	end if
	
	IF is_Action <> 'anular' THEN
		is_Action = 'fileopen'
	END IF
	
	//this.event ue_modify()

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Ha ocurrido una excepcion al momento de actualizar")
finally
	/*statementBlock*/
	
	dw_master.setFocus()
end try

end event

event ue_modify;call super::ue_modify;Long    ll_row,ll_mes,ll_ano
String  ls_flag_estado,ls_result,ls_mensaje, ls_nro_detraccion
Integer li_protect

ll_row = dw_master.Getrow()
dw_master.accepttext()

IF ll_row = 0 THEN RETURN

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if


ls_flag_estado = dw_master.object.flag_estado [ll_row]
ll_ano			= dw_master.object.ano 			 [ll_row]
ll_mes			= dw_master.object.mes 			 [ll_row]

ls_nro_detraccion = dw_master.object.nro_detraccion [ll_row]
			  
/*Buscar Documento tipo Cta Cte*/	 
if invo_detraccion.of_pagado(ls_nro_detraccion) then
	Messagebox('Aviso',"No Puede Editar el documento, la detraccion " + ls_nro_detraccion &
						  + "ya ha sido pagada, por favor verifique.!" &
						  + Char(13) +"Nro de voucher de pago: " + invo_detraccion.of_voucher_pago(ls_nro_detraccion))
	Return 					 
end if


/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then 
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	idw_ctas_pag_det.ii_protect = 0
	idw_ctas_pag_det.of_protect()
	
	idw_ref_x_pagar.ii_protect = 0
	idw_ref_x_pagar.of_protect()
	
	idw_imp_x_pagar.ii_protect = 0
	idw_imp_x_pagar.of_protect()
	
	idw_pre_asiento_det.ii_protect = 0
	idw_pre_asiento_det.of_protect()
	
	idw_asiento_aux.ii_protect = 0
	idw_asiento_aux.of_protect()
	return 
end if


IF ls_flag_estado <> '1' THEN
	f_mensaje("Comprobante no se encuentra activo, por favor verificar!", "")
	dw_master.ii_protect = 0
	idw_ctas_pag_det.ii_protect	 = 0
	idw_ref_x_pagar.ii_protect		 = 0
	idw_imp_x_pagar.ii_protect		 = 0
	idw_pre_asiento_det.ii_protect = 0
	idw_asiento_aux.ii_protect = 0
	
	dw_master.of_protect()
	idw_ctas_pag_det.of_protect()
	idw_ref_x_pagar.of_protect()
	idw_imp_x_pagar.of_protect()
	idw_pre_asiento_det.of_protect()
	idw_asiento_aux.of_protect()
	return
end if

dw_master.of_protect()
idw_ctas_pag_det.of_protect()
idw_ref_x_pagar.of_protect()
idw_imp_x_pagar.of_protect()
idw_pre_asiento_det.of_protect()
idw_asiento_aux.of_protect()

IF is_Action <> 'new' THEN
	li_protect = integer(dw_master.Object.tipo_doc.Protect)
	IF li_protect = 0	THEN
		dw_master.object.tipo_doc.Protect 	  = 1
		dw_master.object.serie_cp.Protect 	  = 1
		dw_master.object.numero_cp.Protect 	  = 1
		dw_master.object.cod_relacion.Protect = 1
		dw_master.object.nro_libro.Protect 	  = 1
		dw_master.object.mes.Protect		 	  = 1
		dw_master.object.ano.Protect 	  		  = 1
		
		idt_tiempo_prov_modif = gnvo_app.of_fecha_actual()
	else
		setNull(idt_tiempo_prov_modif)
	END IF
END IF

IF idw_ctas_pag_det.ii_protect = 0 then
	idw_ctas_pag_det.Modify("precio_unit.Protect   ='1 ~t If(not isnull(item_oc),1,0)'")			
end if

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio ,ll_ano ,ll_count
String ls_cencos,ls_cnta_prsp ,ls_null ,ls_origen
str_parametros sl_param

Setnull(ls_null)

of_asignar_dws()

TriggerEvent ('ue_update_request')	

sl_param.dw1    = 'd_abc_lista_cta_x_pagar_tbl'
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
	of_retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
END IF


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update 			 = 1 OR idw_ctas_pag_det.ii_update    = 1 OR &
	 idw_ref_x_pagar.ii_update     = 1 OR idw_imp_x_pagar.ii_update	  = 1 OR &
	 idw_pre_asiento_cab.ii_update = 1 OR idw_pre_asiento_det.ii_update = 1 OR &
	 idw_asiento_aux.ii_update     = 1 )THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 				= 0
		idw_ctas_pag_det.ii_update		= 0
	   idw_ref_x_pagar.ii_update		= 0 
	   idw_imp_x_pagar.ii_update		= 0 
		idw_pre_asiento_cab.ii_update = 0 
	   idw_pre_asiento_det.ii_update = 0 
		idw_asiento_aux.ii_update 		= 0 
	END IF
END IF

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_print;call super::ue_print;String ls_origen
Long   ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento

IF dw_master.RowCount() = 0 or dw_master.GetRow() = 0 THEN
	gnvo_app.of_mensaje_error('No existe Registro en la cabecera del documento, Verifique!', 'FIN_NOT_DOC')
	Return
END IF

ls_origen 		= dw_master.object.origen 	    [dw_master.getrow()]
ll_ano			= dw_master.object.ano	  	    [dw_master.getrow()]
ll_mes			= dw_master.object.mes	  	    [dw_master.getrow()]
ll_nro_libro	= dw_master.object.nro_libro   [dw_master.getrow()]
ll_nro_asiento	= dw_master.object.nro_asiento [dw_master.getrow()]

ids_voucher.retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,gs_empresa)

IF ids_voucher.RowCount() = 0 THEN
	gnvo_app.of_mensaje_error('No existe Voucher de provisión, Verifique!', 'FIN_NOT_DOC')
	Return
END IF

ids_voucher.Object.p_logo.filename = gs_logo
if ids_voucher.of_ExistsText("t_titulo1") then
	ids_voucher.object.t_titulo1.text = "Provisión de Cuentas x Pagar"
end if	


ids_voucher.Print(True)
end event

event close;call super::close;Destroy ids_formato_det
Destroy ids_voucher

//Objetos de negocio
Destroy invo_asiento_cntbl
destroy invo_detraccion
destroy invo_cntas_pagar
end event

type st_8 from statictext within w_fi304_cnts_x_pagar
integer x = 4146
integer y = 444
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Financiamientos"
boolean focusrectangle = false
end type

type pb_financiamiento from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 428
integer width = 142
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\financiamiento.png"
string disabledname = "C:\SIGRE\resources\PNG\financiamiento.png"
boolean map3dcolors = true
end type

event clicked;if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if

if of_verifica_documento () = false then Return 
//Parent.Event Dynamic ue_adelantos()
end event

type st_7 from statictext within w_fi304_cnts_x_pagar
integer x = 4146
integer y = 352
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Adelantos a Cuenta"
boolean focusrectangle = false
end type

type pb_adelantos from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 336
integer width = 142
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "CheckDiff!"
boolean map3dcolors = true
end type

event clicked;if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if

//if of_verifica_documento () = false then Return 
Parent.Event Dynamic ue_adelantos()
end event

type st_6 from statictext within w_fi304_cnts_x_pagar
integer x = 4146
integer y = 260
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Guia de Recepción"
boolean focusrectangle = false
end type

type pb_grmp from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 244
integer width = 142
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "CrossTab!"
boolean map3dcolors = true
end type

event clicked;if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if

if of_verifica_documento () = false then Return 
Parent.Event Dynamic ue_grmp()
end event

type st_5 from statictext within w_fi304_cnts_x_pagar
integer x = 4146
integer y = 788
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Asociar OT"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 776
integer width = 142
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom083!"
boolean map3dcolors = true
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
integer x = 4146
integer y = 616
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Provision Pendiente"
boolean focusrectangle = false
end type

type pb_cd from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 600
integer width = 142
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom070!"
boolean map3dcolors = true
end type

event clicked;str_parametros sl_param
dwobject   dwo_1

if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if


if of_verifica_documento () = false then Return 

if is_Action <> 'new' or dw_master.Getrow() = 0 then
	
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
sl_param.string1 = gs_origen
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

type sle_confin from singlelineedit within w_fi304_cnts_x_pagar
integer x = 3986
integer y = 948
integer width = 306
integer height = 68
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_data
Long   ll_count

ls_data = This.Text

select count(*) into :ll_count from concepto_financiero where confin = :ls_data ;

if ll_count > 0 then
	select matriz_cntbl into :is_matriz from concepto_financiero where confin = :ls_data ;
	
else
	SetNull(is_matriz)

end if

end event

type rb_ff from radiobutton within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 5065
integer y = 176
integer width = 416
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Fondo Fijo"
end type

type rb_og from radiobutton within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 5065
integer y = 112
integer width = 416
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Orden de Giro"
boolean checked = true
end type

type sle_2 from singlelineedit within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 5001
integer y = 324
integer width = 137
integer height = 68
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 4768
integer y = 328
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Nro Doc. :"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 5143
integer y = 324
integer width = 338
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 4773
integer y = 104
integer width = 256
integer height = 176
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "C:\SIGRE\resources\Gif\arrowl.gif"
string disabledname = "C:\SIGRE\resources\Gif\arrowl.gif"
alignment htextalign = right!
vtextalign vtextalign = top!
boolean map3dcolors = true
end type

event clicked;Long     ll_row_master,ll_item,ll_count
String   ls_flag_estado,ls_origen    ,ls_nro_sol,ls_descrip,ls_cod_rel,ls_tipo_doc,&
			ls_nro_doc    ,ls_cod_moneda,ls_msj_err
Datetime ldt_fec_emis
Decimal {2} ldc_monto_total
Decimal {4} ldc_tasa_cambio
Boolean     lb_ind = TRUE

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0  THEN RETURN

IF dw_master.ii_update = 1                          OR tab_1.tabpage_1.dw_ctas_pag_det.ii_update = 1    OR &
	tab_1.tabpage_2.dw_ref_x_pagar.ii_update = 1     OR tab_1.tabpage_3.dw_imp_x_pagar.ii_update  = 1    OR &
	tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 OR tab_1.tabpage_5.dw_pre_asiento_det.ii_update = 1 OR &
	tab_1.tabpage_6.dw_asiento_aux.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
	Return
END IF

/*datos del documento provisionado*/
ls_cod_rel      = dw_master.object.cod_relacion  [ll_row_master]
ls_tipo_doc		 = dw_master.object.tipo_doc     [ll_row_master]
ls_nro_doc		 = dw_master.object.nro_doc      [ll_row_master]
ldt_fec_emis    = dw_master.object.fecha_emision [ll_row_master]
ls_flag_estado  = dw_master.object.flag_estado   [ll_row_master]
ls_cod_moneda	 = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio   [ll_row_master]
ls_descrip		 = mid(trim(dw_master.object.descripcion  [ll_row_master]),1,60)
ldc_monto_total = dw_master.object.total_pagar   [ll_row_master]



select flag_estado into :ls_flag_estado from cntas_pagar 
where tipo_doc     = :ls_tipo_doc and
	   nro_doc	    = :ls_nro_doc and
		cod_relacion = :ls_cod_rel ;

/*inserta registro pre-liquidación*/
IF ls_flag_estado <> '1'  THEN
	Messagebox('Aviso','Estado del Documento no Permite Transferirlo, Verifique!')
	RETURN
END IF
		

ls_origen  = sle_2.text
ls_nro_sol = sle_1.text


IF Isnull(ls_origen) OR Trim(ls_origen) = '' THEN
	Messagebox('Aviso','Debe Ingresar Origen de Solicitud de Giro , Verifique!')	
	Return
END IF

IF Isnull(ls_nro_sol) OR Trim(ls_nro_sol) = '' THEN
	Messagebox('Aviso','Debe Ingresar Nro de Solicitud de Giro , Verifique!')	
	Return
END IF

/*verifica si existe solicitud de giro (pagada o pre-liquidada)*/
select count(*) into :ll_count from solicitud_giro 
where origen = :ls_origen and nro_solicitud = :ls_nro_sol AND flag_estado in ('3','4') ;



IF ll_count = 0 THEN
	Messagebox('Aviso','Solicitud de giro No Existe Verifique!')
	Return
END IF

	

IF rb_og.checked THEN 
	//encuentra item maximo a incrementar
	select max(item) into :ll_item from solicitud_giro_liq_det 
	where (origen        = :ls_origen  ) and
			(nro_solicitud = :ls_nro_sol ) ;
		
	IF Isnull(ll_item) OR ll_item = 0 THEN
		ll_item = 1
	ELSE
		ll_item = ll_item + 1 
	END IF
	
	
	//ORDEN DE GIRO 
	Insert Into solicitud_giro_liq_det
	(origen          ,nro_solicitud  ,item       ,proveedor,tipo_doc,nro_doc,fecha_doc,
	 cod_moneda      ,tasa_cambio    ,descripcion,importe,flag_tipo_gasto   )  
	Values
	(:ls_origen ,:ls_nro_sol ,:ll_item ,:ls_cod_rel,:ls_tipo_doc,:ls_nro_doc,:ldt_fec_emis,
	 :ls_cod_moneda,:ldc_tasa_cambio,:ls_descrip,:ldc_monto_total,'P');
	
	IF SQLCA.SQLCode = -1 THEN 
      ls_msj_err =  SQLCA.SQLErrText
		lb_ind = FALSE
		GOTO SALIDA_ERR		
	END IF
	
	//actualizar cabecera de solicitud_giro
	update solicitud_giro 
		set flag_estado = '4'
	where origen = :ls_origen and nro_solicitud = :ls_nro_sol ;
	
	IF SQLCA.SQLCode = -1 THEN 
      ls_msj_err =  SQLCA.SQLErrText
		lb_ind = FALSE
		GOTO SALIDA_ERR		
	END IF
	
ELSEIF rb_ff.cheCked THEN
	select max(item) into :ll_item from solicitud_giro_liq_det 
	where (origen        = :ls_origen  ) and
			(nro_solicitud = :ls_nro_sol ) ;
		
	IF Isnull(ll_item) OR ll_item = 0 THEN
		ll_item = 1
	ELSE
		ll_item = ll_item + 1 
	END IF
	
	
	//FONDO FIJO
	Insert Into solicitud_giro_liq_det_usr
   (origen     ,nro_solicitud ,item       ,proveedor,tipo_doc   ,nro_doc        ,fecha_doc,
	 cod_moneda ,tasa_cambio   ,descripcion,importe  ,flag_estado,flag_tipo_gasto)  
   Values
	(:ls_origen ,:ls_nro_sol ,:ll_item ,:ls_cod_rel,:ls_tipo_doc,:ls_nro_doc,:ldt_fec_emis,
	 :ls_cod_moneda,:ldc_tasa_cambio,:ls_descrip,:ldc_monto_total,'1','P')  ;

	IF SQLCA.SQLCode = -1 THEN 
      ls_msj_err =  SQLCA.SQLErrText
		lb_ind = FALSE
		GOTO SALIDA_ERR
	END IF	 
	
	//actualizar cabecera de solicitud_giro
	update solicitud_giro 
		set flag_estado = '4'
	where origen = :ls_origen and nro_solicitud = :ls_nro_sol ;
	
	IF SQLCA.SQLCode = -1 THEN 
      ls_msj_err =  SQLCA.SQLErrText
		lb_ind = FALSE
		GOTO SALIDA_ERR		
	END IF

	 
END IF



IF lb_ind THEN
	Commit ;
	Messagebox('Aviso','Transferencia Satisfactoria !')
ELSE
	SALIDA_ERR:
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF
end event

type st_2 from statictext within w_fi304_cnts_x_pagar
integer x = 4146
integer y = 168
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Orden de Servicio"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi304_cnts_x_pagar
integer x = 4146
integer y = 76
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "&Orden de Compra"
boolean focusrectangle = false
end type

type pb_os from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 152
integer width = 142
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom076!"
boolean map3dcolors = true
end type

event clicked;String  		ls_tipo_ref, ls_cod_cliente, ls_cod_moneda, &
			   ls_result, ls_mensaje, ls_flag_os, ls_tipo_doc_grmp
Decimal {4} ldc_tasa_cambio
Decimal {2} ldc_total
Long        ll_row,ll_ano,ll_mes

str_parametros sl_param

if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if


if of_verifica_documento () = false then Return 

IF of_verifica_data_oc (ls_cod_cliente,ldc_tasa_cambio) = FALSE THEN Return

ll_row = dw_master.Getrow()
ll_ano = dw_master.object.ano [ll_row]
ll_mes = dw_master.object.mes [ll_row]


/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	RETURN
END IF

IF tab_1.tabpage_2.dw_ref_x_pagar.Rowcount() > 0 THEN
	
	ls_tipo_ref = tab_1.tabpage_2.dw_ref_x_pagar.Object.tipo_ref[1]
	IF ls_tipo_ref = gnvo_app.is_doc_oc THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Servicio , Verifique!')
		RETURN
	END IF
	
	ls_tipo_ref = tab_1.tabpage_1.dw_ctas_pag_det.object.tipo_ref[1]
	IF ls_tipo_ref = is_doc_grmp THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Compra , Verifique!')
		RETURN
	END IF
	
	is_nro_os = tab_1.tabpage_2.dw_ref_x_pagar.Object.nro_ref[1]
ELSE
	SetNull(is_nro_os)
END IF

//parametro de finanzas
select Nvl(flag_os_provision,'0') 
	into :ls_flag_os 
from finparam 
where reckey = '1' ;

	
sl_param.tipo			= '12'
sl_param.opcion		= 11         //Ordenes de Servicio
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
sl_param.string2		= is_nro_os
sl_param.db1			= ldc_tasa_cambio
sl_param.lw1			= parent
sl_param.dw_imp_x_pagar = tab_1.tabpage_3.dw_imp_x_pagar


dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.titulo = 's' THEN
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc 			[1] = ldc_total
	
	//El importe minimo para la depreciación es de 400 soles
	if ldc_total >= 400 then
		dw_master.object.flag_detraccion 	[1] = '1'
		
		dw_master.object.bien_serv.protect = '0'
		dw_master.object.bien_serv.Background.Color = RGB(255,255,255)
		
		dw_master.object.oper_detr.protect = '0'
		dw_master.object.oper_detr.Background.Color = RGB(255,255,255)
		
		dw_master.object.porc_detraccion.protect = '0'
		dw_master.object.porc_detraccion.Background.Color = RGB(255,255,255)
	end if
	
	of_calcular_detraccion ()
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	dw_master.ii_update = 1
	wf_doc_anticipos () 
	of_total_ref ()


END IF

end event

type pb_oc from picturebutton within w_fi304_cnts_x_pagar
integer x = 3982
integer y = 60
integer width = 142
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Compute!"
boolean map3dcolors = true
end type

event clicked;String  	ls_tipo_ref ,ls_cod_cliente, ls_tipo_doc
Decimal 	ldc_total, ldc_tasa_cambio
str_parametros lstr_param


if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if

if of_verifica_documento () = false then Return 
	
IF of_verifica_data_oc (ls_cod_cliente,ldc_tasa_cambio) = FALSE THEN Return

//Actualizo los saldos
//gnvo_app.logistica.of_act_monto_facturado( )
//gnvo_app.logistica.of_act_cant_procesada( )

//Obtengo el tipo de documento
ls_tipo_doc = dw_master.object.tipo_doc [1]

if IsNull(ls_tipo_Doc) or trim(ls_tipo_doc) = '' then
	MessageBox('Error', 'No ha especificado el tipo de documento, por favor corrija')
	dw_master.setFocus()
	dw_master.setColumn('tipo_doc')
	return
end if
	
//Coloco la información para mostrar los datos	
lstr_param.tipo		 = '11'
lstr_param.opcion	 	 = 10         //Ordenes de Compra
lstr_param.titulo 	 = 'Selección de Ordenes de Compra'

//Si el documento elegido es la dua entonces debe mostrar solo las ordenes de compra 
//de importación
if trim(ls_tipo_doc) = gnvo_app.finparam.is_doc_dua then
	lstr_param.dw_master  = 'd_abc_lista_oc_pend_importacion_tbl'
else
	lstr_param.dw_master  = 'd_abc_lista_oc_pendientes_tbl'
end if
lstr_param.dw1		 	 = 'd_abc_art_mov_oc_pendientes_tbl'
lstr_param.dw_m		 = dw_master
lstr_param.dw_d		 = idw_ctas_pag_det
lstr_param.dw_c		 = idw_ref_x_pagar
lstr_param.dw_i		 = idw_imp_x_pagar
lstr_param.string1	 = ls_cod_cliente
lstr_param.db1		 	 = ldc_tasa_cambio
lstr_param.lw_1		 = parent

dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, lstr_param)

If isNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = message.PowerObjectParm	

IF lstr_param.titulo = 's' THEN
	OF_CALCULAr_DETRACCION()
	
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	
	dw_master.ii_update = 1
	
	
	wf_doc_anticipos () 
	
	
	of_total_ref ()
	
END IF

end event

type dw_master from u_dw_abc within w_fi304_cnts_x_pagar
integer x = 5
integer width = 3945
integer height = 1028
string dataobject = "d_abc_cntas_pagar_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_nom_proveedor  , ls_forma_pago   , ls_mes  	,ls_flag_detraccion	, &
				ls_nro_detraccion , ls_desc_fpago   , ls_ano		,ls_periodo				, &
				ls_cod_relacion 	, ls_flag_imp, ls_desc
Date       	ld_fecha_emision, ld_fecha_vencimiento, ld_fecha_emision_old, ld_fecha_presentacion_old,&
				ld_fecha_presentacion
DateTime    ldt_fecha_vencim_new, ldt_now
Decimal 		ldc_tasa_cambio, ldc_tasa, ldc_total
Integer		li_dias_venc , li_opcion, li_year, li_mes
Long        ll_nro_libro,ll_count
String		ls_serie_cp, ls_nro_doc, ls_numero_cp, ls_proveedor, ls_tipo_doc

try 
	ld_fecha_emision_old 	  = Date(This.Object.fecha_emision [row])	
	ld_fecha_presentacion_old = Date(This.Object.fecha_presentacion [row])	
	
	this.Accepttext()
	
	/*Datos del Registro Modificado*/
	ib_estado_prea = TRUE
	/**/
	ldt_now = gnvo_app.of_fecha_actual()
	
	CHOOSE CASE dwo.name
		case 'serie_cp' 
			
			ls_serie_cp 	= this.object.serie_cp 		[row]
			ls_numero_cp 	= this.object.numero_cp 	[row]
			ls_proveedor	= this.object.cod_relacion [row]
			ls_tipo_doc  	= this.object.tipo_doc		[row]
			ls_nro_doc		= this.object.nro_doc		[row]
			
			if len(trim(ls_serie_cp)) < 4 then
				ls_serie_cp = gnvo_app.utilitario.lpad(ls_serie_cp, 4, '0')
				this.object.serie_cp [row] = ls_serie_cp
			end if
			
			
			if not IsNull(ls_numero_cp) and trim(ls_numero_cp) <> '' then
				ls_numero_cp = gnvo_app.utilitario.lpad(ls_numero_cp, 10, '0')
				this.object.numero_cp [row] = ls_numero_cp
			end if
			
			if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) and not IsNull(ls_proveedor) &
				and not IsNull(ls_tipo_doc) and trim(ls_proveedor) <> '' and trim(ls_tipo_doc) <> '' &
				and trim(ls_serie_cp) <> '' and trim(ls_numero_cp) <> '' then
				
				//Valido si el documento ya ha sido registrado o no
				if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
					this.object.serie_cp [row] = gnvo_app.is_null
					this.SetColumn("serie_cp")
					return 1
				end if
				
				//GEnero el numero de documento
				ls_nro_doc = this.object.nro_doc [row]
				if is_action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
					this.object.nro_doc [row] = invo_cntas_pagar.of_get_nro_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp)
				end if
			end if
			
			return 2
		
		case 'numero_cp' 
			
			ls_serie_cp 	= this.object.serie_cp 		[row]
			ls_numero_cp 	= this.object.numero_cp 	[row]
			ls_proveedor	= this.object.cod_relacion [row]
			ls_tipo_doc  	= this.object.tipo_doc		[row]
			ls_nro_doc		= this.object.nro_doc		[row]
			
			if not IsNull(ls_numero_cp) and trim(ls_numero_cp) <> '' then
				if IsNull(ls_serie_cp) or trim(ls_serie_cp) = '' then
					if MessageBox('Aviso', 'No ha ingresado un numero de serie, desea continuar ingresando el numero del comprobante de pago sin haber ingresado el numero de Serie?', &
						Information!, YesNo!, 2) = 2 then
						
						this.object.numero_cp [row] = gnvo_app.is_null
						this.setColumn("serie_cp")
						return 1
						
					end if
				end if
			end if
			
			if not IsNull(ls_numero_cp) and trim(ls_numero_cp) <> '' then
				ls_numero_cp = gnvo_app.utilitario.lpad(ls_numero_cp, 10, '0')
				this.object.numero_cp [row] = ls_numero_cp
			end if
			
			if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) and not IsNull(ls_proveedor) &
				and not IsNull(ls_tipo_doc) and trim(ls_proveedor) <> '' and trim(ls_tipo_doc) <> '' &
				and trim(ls_serie_cp) <> '' and trim(ls_numero_cp) <> '' then
				
				//Valido si el documento ya ha sido registrado o no
				if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
					this.object.numero_cp [row] = gnvo_app.is_null
					this.SetColumn("numero_cp")
					return 1
				end if
				
				//GEnero el numero de documento
				ls_nro_doc = this.object.nro_doc [row]
				if is_action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
					this.object.nro_doc [row] = invo_cntas_pagar.of_get_nro_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp)
				end if
			end if
			
			return 2
	
		CASE 'cod_relacion'
			ls_serie_cp 	= this.object.serie_cp 		[row]
			ls_numero_cp 	= this.object.numero_cp 	[row]
			ls_proveedor	= this.object.cod_relacion [row]
			ls_tipo_doc  	= this.object.tipo_doc		[row]
			ls_nro_doc		= this.object.nro_doc		[row]
			
			//Valido si el documento ya ha sido registrado o no
			if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) and not IsNull(ls_proveedor) &
				and not IsNull(ls_tipo_doc) and trim(ls_proveedor) <> '' and trim(ls_tipo_doc) <> '' &
				and trim(ls_serie_cp) <> '' and trim(ls_numero_cp) <> '' then
				
				if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
					this.object.cod_relacion 	[row] = gnvo_app.is_null
					this.object.nom_proveedor	[row] = gnvo_app.is_null
					this.SetColumn("cod_relacion")
					return 1
				end if
				
				//GEnero el numero de documento
				ls_nro_doc = this.object.nro_doc [row]
				if is_action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
					this.object.nro_doc [row] = invo_cntas_pagar.of_get_nro_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp)
				end if
				
			end if
		
			IF idw_ref_x_pagar.rowcount() > 0 THEN
				gnvo_app.of_message_error('No puede	Cambiar El codigo del Cliente Tiene Doumentos Referenciados , por favor Verifique!')
				This.Object.cod_relacion [1] = This.Object.cod_relacion_det [1]
				Return 1
			END IF
		
			SELECT prov.nom_proveedor
			  INTO :ls_nom_proveedor
			  FROM proveedor prov
			 WHERE prov.proveedor   = :data 
				and prov.flag_estado = '1'  ;
					 
			
			IF SQLCA.SQLCode = 100 THEN
				gnvo_app.of_message_error('Código de Proveedor ' + data + ' No Existe o no se encuentra ACTIVO, por favor Verifique!')
				This.Object.cod_relacion [1] = gnvo_app.is_null
				this.SetColumn('cod_relacion')
				Return 1
			end if
			
			This.Object.nom_proveedor[row] = ls_nom_proveedor
			
		CASE 'forma_pago'
			//BUSCA FECHA DE RECEPCION				
			wf_find_fecha_presentacion()
			
			select desc_forma_pago, dias_vencimiento 
			 into :ls_desc_fpago,:li_dias_venc
			  from forma_pago
			 where (forma_pago = :data ) ;
			 
			IF Isnull(ls_desc_fpago) OR Trim(ls_desc_fpago) = '' THEN
				Messagebox('Aviso','No Existe Forma Pago ,Verifique !')
				This.object.forma_pago [row] = gnvo_app.is_null
				Return 1
			END IF	
			 
			this.object.desc_forma_pago  [row] = ls_desc_fpago
			this.object.dias_vencimiento [row] = li_dias_venc
			
			IF li_dias_venc > 0 THEN
				ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_presentacion [row]) , li_dias_venc )
				This.Object.vencimiento [row] = ld_fecha_vencimiento
			END IF
								
		CASE	'tipo_doc'
	
			SELECT dt.nro_libro
				into :ll_nro_libro
			FROM 	FINPARAM          F, 
					DOC_GRUPO_RELACION  DGR, 
					DOC_TIPO          DT
			WHERE F.DOC_CXP     	= DGR.GRUPO
			  and DGR.TIPO_DOC  	= DT.TIPO_DOC
			  and F.RECKEY    	= '1'  
			  and dt.flag_estado	= '1'
			  and dt.tipo_doc		= :data; 
	
			if SQLCA.SQLCode = 100 then
				MessageBox('Error', 'Tipo de documento ' + data + ' no existe,  no esta activo o no se encuentra en el grupo de Cntas x Pagar. ' &
										+ '. Por favor verifique!', StopSign!)
										
				this.object.tipo_doc		[row] = gnvo_app.is_null
				this.object.nro_libro	[row] = gnvo_app.il_null
	
				return 1
			end if
			
			ls_serie_cp 	= this.object.serie_cp 			[row]
			ls_numero_cp 	= this.object.numero_cp 		[row]
			ls_proveedor	= this.object.cod_relacion 	[row]
			ls_tipo_doc  	= this.object.tipo_doc			[row]
			
			//Valido si el documento ya ha sido registrado o no
			if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) and &
				not IsNull(ls_proveedor) and not IsNull(ls_tipo_doc) and &
				trim(ls_proveedor) <> '' and trim(ls_tipo_doc) <> '' then
				
				if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
					this.object.tipo_doc [row] = gnvo_app.is_null
					this.SetColumn("tipo_doc")
					return 1
				end if
				
			end if
				
			//Coloco el numero del Libro
			This.Object.nro_libro [row] = ll_nro_libro		
			
			
					
					
		CASE 'cod_moneda'
			IF idw_ref_x_pagar.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda', StopSign!)
				This.Object.cod_moneda [1] = This.Object.moneda_det [1]
				Return 1
			END IF
			
			select count(*) 
				into :ll_count 
			from moneda 
			where cod_moneda = :data 
			  and flag_estado = '1';
			
			if ll_count = 0 then
				Messagebox('Aviso','Codigo de moneda ' + data + ' No existe o no esta activo, por favor Verifique!', StopSign!)
				this.object.cod_moneda [row] = gnvo_app.is_null
				Return 1
			end if
			
	
		CASE	'clase_bien_serv'
			select descripcion
				into :ls_desc
			  from sunat_tabla30
			 where codigo   = :data 
				and flag_estado = '1';
					  
			
			if sqlca.sqlcode = 100 then
				Messagebox('Aviso','Codigo de Clasificación de Bien o Servicio (SUNAT TABLA30) No Existe o Esta Inactivo,Verifique!')	
				this.object.clase_bien_serv      [row] = gnvo_app.is_null
				this.object.desc_clase_bien_serv	[row] = gnvo_app.is_null
				Return 1
			end if
			
			this.object.desc_clase_bien_serv [row] =	ls_desc
	
		CASE	'bien_serv'
			IF this.object.flag_detraccion[row] = '0' THEN
				this.object.bien_serv 	[row] = gnvo_app.is_null
				Messagebox('Aviso','Debe Seleccionar que Generara Detracción')
				this.setColumn("flag_detraccion")
				Return 2
			END IF
			
			select tasa_pdbe ,flag_ind_imp 
				into :ldc_tasa ,:ls_flag_imp 
			  from detr_bien_serv
			 where bien_serv   = :data 
				and flag_estado = '1';
					  
			
			if sqlca.sqlcode = 100 then
				Messagebox('Aviso','Codigo de Detraccion No Existe o Esta Inactivo,Verifique!')	
				this.object.bien_serv       [row] = gnvo_app.is_null
				this.object.flag_ind_imp    [row] =	gnvo_app.is_null
				this.object.porc_detraccion [row] =	0.00
				Return 1
			end if
			
			this.object.porc_detraccion [row] =	ldc_tasa
			this.object.flag_ind_imp    [row] =	ls_flag_imp
			
			
			of_calcular_detraccion()
			ldc_total = wf_totales ()		
			dw_master.object.importe_doc [1] = ldc_total
			dw_master.ii_update = 1
			of_total_ref ()
					
			ib_modif_dtrp = false
					
		CASE	'imp_detraccion'
			ib_modif_dtrp = true
					
		CASE 'tasa_cambio'
			of_calcular_detraccion()
					
		
	
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
			
			if not invo_asiento_cntbl.of_val_mes_cntbl( Long(ls_ano), Long(ls_mes), "R") then
				dw_master.object.ano [row] = Long(String(gnvo_app.of_fecha_actual(),'yyyy'))
				dw_master.object.mes [row] = Long(String(gnvo_app.of_fecha_actual(),'mm'))
				RETURN 1
			end if
			
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
			
			if not invo_asiento_cntbl.of_val_mes_cntbl( Long(ls_ano), Long(ls_mes), "R") then
				dw_master.object.ano [row] = Long(String(gnvo_app.of_fecha_actual(),'yyyy'))
				dw_master.object.mes [row] = Long(String(gnvo_app.of_fecha_actual(),'mm'))
				RETURN 1
			end if
			
		CASE	'fecha_emision'
			
			ld_fecha_emision      	= Date(This.Object.fecha_emision [row])	
			
			if DaysAfter(ld_fecha_emision, Date(ldt_Now)) + 1 > 365 then
				if MessageBox('Error', 'La Fecha de Emision Ingresada ' + String(ld_fecha_emision, 'dd/mm/yyyy') &
										+ ' es mayor a 365 dias. Desea continuar con la provision?', &
										Information!, Yesno!, 2) = 2 then
										
					This.Object.fecha_emision 	[row] = gnvo_app.id_null
					This.Object.vencimiento 	[row] = gnvo_app.id_null
					this.setColumn('fecha_emision')
				
					return 1
					
				end if
		
			end if
			
			if ld_fecha_emision > Date(ldt_now) then
				MessageBox('Error', 'La Fecha de Emision ' + String(ld_fecha_emision, 'dd/mm/yyyy') + 'no puede ser mayor al actual. ' &
										+ 'Por favor verifique!', StopSign!)
										
				This.Object.fecha_emision 	[row] = gnvo_app.id_null
				This.Object.vencimiento 	[row] = gnvo_app.id_null
				this.setColumn('fecha_emision')
				
				return 1
		
			end if
			
			ld_fecha_vencimiento	 	= Date(This.Object.vencimiento   [row])	
			
			IF idw_ref_x_pagar.rowcount() > 0 THEN
				Messagebox('Aviso','No puede Cambiar la Fecha de Emision por que Cambiaria la Tasa de Cambio y Tiene Doc. de Referencias ,Verifique!')
				This.Object.fecha_emision[1] = ld_fecha_emision_old
				Return 1
			END IF		
			
			
			// Si el registro es nuevo, tambien asigno el periodo
			if is_action = 'new' then
	
				ls_ano 		= String(this.object.ano [row])
				ls_mes 		= String(this.object.mes [row],'00')
	
				dw_master.object.ano 	[row] = Long(String(ld_fecha_emision, 'yyyy'))
				dw_master.object.mes 	[row] = Long(String(ld_fecha_emision, 'mm'))	
	
			end if
			
			IF ld_fecha_emision > ld_fecha_vencimiento THEN
				This.Object.vencimiento [row] = ld_fecha_emision
				Return 1
			END IF
			
			this.object.fecha_presentacion [row] = ld_fecha_emision
			
		
			//Obteniendo la tasa de cambio
			This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
			
		CASE	'fecha_presentacion'
			
			ld_fecha_presentacion = Date(This.Object.fecha_presentacion [row])	
			
			if ld_fecha_presentacion > Date(ldt_now) then
				MessageBox('Error', 'La Fecha de Presentacion ' + String(ld_fecha_emision, 'dd/mm/yyyy') + ' no puede ser mayor al actual. ' &
										+ 'Por favor verifique!', StopSign!)
										
				This.Object.fecha_presentacion 	[row] = gnvo_app.id_null
				This.Object.vencimiento 			[row] = gnvo_app.id_null
				
				this.setColumn('fecha_presentacion')
				
				return 1
		
			end if
			
			ld_fecha_vencimiento	 = Date(This.Object.vencimiento   [row])			
			ls_forma_pago			 = This.Object.forma_pago [row]	
			
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
			invo_detraccion.of_change_estado(this, is_action)
						  
		CASE 'porc_detraccion'	
			
			  ls_flag_detraccion = This.object.flag_detraccion [row]	
			  
			  IF ls_flag_detraccion = '0' THEN
				  this.object.porc_detraccion	[row] = 0.00
				  Messagebox('Aviso','Documento no tiene indicador detracción Activo ,Verifique!')	  	
				  RETURN 1
			  END IF
			  
			  of_calcular_detraccion()
	
								
	
	END CHOOSE
	
catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Ha ocurrido una exception')
	
end try

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

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_today

ib_cierre = false
this.object.t_cierre.text = ''

ldt_today 				= gnvo_app.of_fecha_actual( )
idt_tiempo_prov_new 	= gnvo_app.of_fecha_actual()

This.object.origen 			  		[al_row] = gs_origen
This.object.cod_usr 			  		[al_row] = gs_user
This.object.fecha_registro   		[al_row] = ldt_today
This.object.fecha_emision 	  		[al_row] = Date(ldt_today)
This.object.fecha_presentacion  	[al_row] = Date(ldt_today)
This.object.vencimiento 	  		[al_row] = Date(ldt_today)
This.object.ano 				  		[al_row] = Long(String(ldt_today,'YYYY'))
This.object.mes	 			  		[al_row] = Long(String(ldt_today,'MM'))
This.object.tasa_cambio 	  		[al_row] = gnvo_app.of_tasa_cambio()
This.object.flag_estado 	  		[al_row] = '1'
This.Object.ind_detrac	     		[al_row] = '1'
This.object.flag_detraccion  		[al_row] = '0'
This.object.flag_provisionado		[al_row] = 'R'
This.object.flag_cntr_almacen		[al_row] = '1'
This.object.imp_detraccion	  		[al_row] = 0.00
This.object.tiempo_prov_new  		[al_row] = 0.00
This.object.tiempo_prov_modif		[al_row] = 0.00

if upper(gs_empresa) = 'JARCH' or upper(gs_user) = 'MILAGR' then
	This.object.cod_moneda				[al_row] = gnvo_app.is_soles
end if

tab_1.SelectedTab = 1

//Inhabilito los campos de detracccion
this.object.porc_detraccion 	[al_row] = 0.00
this.object.nro_detraccion  	[al_row] = gnvo_app.is_null
this.object.bien_serv  			[al_row] = gnvo_app.is_null
this.object.oper_detr  			[al_row] = gnvo_app.is_null

ib_modif_dtrp = false


this.SetColumn('tipo_doc')
this.SetFocus()

is_Action = 'new'
ib_modif_dtrp = false
invo_detraccion.of_change_estado(this, is_action)


end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event ue_display;call super::ue_display;String      ls_name ,ls_prot ,ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc ,ls_flag_detrac, ls_tasa, &
				ls_flag_importe, ls_data2, ls_sql, ls_codigo, ls_data, ls_serie_cp, ls_numero_cp, &
				ls_proveedor, ls_tipo_cred_fiscal, ls_nro_libro
Date		   ld_fecha_emision ,ld_fecha_vencimiento	,ld_fecha_presentacion
Long        ll_count,ll_nro_libro
boolean		lb_ret
Decimal		ldc_tasa_cambio, ldc_total

try 
	
	IF Getrow() = 0 THEN Return

	CHOOSE CASE lower(as_columna)
		CASE 'b_1'
			IF is_Action = 'new' THEN
				if of_verifica_documento () = false then
					Return
				end if
			END IF
	
		CASE	'tipo_doc'	
	
			ls_sql = "SELECT distinct " &
					 + "       DT.TIPO_DOC as tipo_doc, " &
					 + "       DT.DESC_TIPO_DOC as descripcion_tipo_doc, " &
					 + " 		  dt.nro_libro as nro_libro, " &
					 + "		  dt.tipo_cred_fiscal as tipo_cred_fiscal " &
					 + " FROM FINPARAM          F, " &
					 + "    DOC_GRUPO_RELACION  DGR, " &
					 + "    DOC_TIPO          DT " &
					 + "WHERE F.DOC_CXP     = DGR.GRUPO  " &
					 + "  and DGR.TIPO_DOC  = DT.TIPO_DOC " &
					 + "  and F.RECKEY    = '1' " &
					 + "  and dt.flag_estado  = '1' " &
					 + "ORDER BY DT.DESC_TIPO_DOC ASC "
	
			
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_nro_libro, ls_tipo_cred_fiscal, '2') then
				
				ls_serie_cp 	= this.object.serie_cp 			[al_row]
				ls_numero_cp 	= this.object.numero_cp 		[al_row]
				ls_proveedor	= this.object.cod_relacion 	[al_row]
				
				//Valido si el documento ya ha sido registrado o no
				if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) and not IsNull(ls_proveedor) &
					and not IsNull(ls_codigo) and trim(ls_proveedor) <> '' and trim(ls_codigo) <> '' &
					and trim(ls_serie_cp) <> '' and trim(ls_numero_cp) <> '' then
						
					if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_codigo, ls_serie_cp, ls_numero_cp) then 
						return 
					end if
					
				end if
	
	
				this.object.tipo_doc       	[al_row] = ls_codigo
				this.object.tipo_cred_fiscal	[al_row] = ls_tipo_cred_fiscal
				
				if is_Action = 'new' or ISNull(this.object.nro_libro [al_Row]) then
					this.object.nro_libro		[al_Row] = Long(ls_nro_libro)
				end if
				
				ib_modif_dtrp = false
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_prea = TRUE
				/**/
			end if
					
		CASE	'bien_serv'	
				
			ls_flag_detrac = This.object.flag_detraccion [al_row]
			
			if ls_flag_detrac <> '1' then
				Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
				Return 	
			end if
			
			ls_sql = "SELECT 	S.BIEN_SERV    AS CODIGO ,"&
					 + "			S.DESCRIPCION  AS DESCRIPCION ," &
					 + "		 	S.TASA_PDBE	  AS TASA_BIEN_SERV, "&
					 + "		 	S.FLAG_IND_IMP AS FLAG_IMPORTE	  "&	
					 + "  FROM DETR_BIEN_SERV S " & 
					 + " WHERE S.FLAG_ESTADO = '1'"
					 
			lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tasa, ls_flag_importe, "2")
			
			if ls_codigo <> "" then
			
				this.object.bien_serv       [al_row] = ls_codigo
				this.object.porc_detraccion [al_row] =	dec(ls_tasa)
				this.object.flag_ind_imp    [al_row] =	ls_flag_importe
				
				of_calcular_detraccion()
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1
				of_total_ref ()
					
				ib_modif_dtrp = false
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_prea = TRUE
				/**/
			end if
	
		CASE	'clase_bien_serv'	
				
			ls_sql = "select codigo as codigo, " &
					 + "descripcion as descripcion " &
					 + "from sunat_tabla30 " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
			
			if ls_codigo <> "" then
			
				this.object.clase_bien_serv       [al_row] = ls_codigo
				this.object.desc_clase_bien_serv  [al_row] = ls_data
				this.ii_update = 1
				
			end if
			
			
		CASE	'oper_detr'	
				
			ls_flag_detrac = This.object.flag_detraccion [al_row]
			
			if ls_flag_detrac <> '1' then
				Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
				Return 	
			end if
			
			ls_sql = "select oper_detr as codigo_operacion, " &
					 + "descripcion as descripcion_operacion " &
					 + "from detr_operacion " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
			
			if ls_codigo <> "" then
			
				this.object.oper_detr       [al_row] = ls_codigo
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_prea = TRUE
				/**/
			end if
	
		CASE 'cod_moneda'
			IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda')
				Return 
			END IF
					
			ls_sql = "SELECT M.COD_MONEDA  AS CODIGO      ,"&
					 + " 		  M.DESCRIPCION AS DESCRIPCION  "&
					 + "FROM MONEDA M " &
					 + "where M.flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
			
			if ls_codigo <> "" then
				this.object.cod_moneda [al_row] = ls_codigo
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_prea = TRUE
				/**/
			END IF
					
		CASE	'forma_pago'	
			
			ls_sql = "SELECT fp.FORMA_PAGO       AS CODIGO_FPAGO ,"&
					 + "		  fp.DESC_FORMA_PAGO  AS DESCRIPCION  ,"&
					 + "		  fp.DIAS_VENCIMIENTO AS VENCIMIENTO   "&
					 + "FROM FORMA_PAGO fp " &
					 + "where fp.flag_estado = '1'"
					 
			lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, "2")
			
			if ls_codigo <> "" then
				//BUSCA FECHA DE RECEPCION				
				wf_find_fecha_presentacion()
				
				il_dias_vencimiento = integer(ls_data2)
				
				this.object.forma_pago 			[al_row] = ls_codigo
				this.object.desc_forma_pago 	[al_row] = ls_data
				this.object.dias_vencimiento	[al_row] = il_dias_vencimiento
				
				IF il_dias_vencimiento > 0 THEN
					ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_presentacion [al_row]) , il_dias_vencimiento )
					This.Object.vencimiento [al_row] = ld_fecha_vencimiento
				END IF
			
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_prea = TRUE
			
				/**/
			END IF
			
		CASE 'cod_relacion'
			IF tab_1.tabpage_2.dw_ref_x_pagar.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El codigo del Cliente')
				Return
			END IF
			
			ls_sql = "SELECT VW.PROVEEDOR     AS CODIGO_PROVEEDOR ,"&
					 + "		  VW.NOM_PROVEEDOR AS NOMBRES ,"&
					 + "		  VW.RUC AS NUMERO_DE_RUC ,"&
					 + "		  VW.DESC_CAMPO AS DESCRIPCION_CAMPO ,"&
					 + "		  VW.EMAIL AS EMAIL "&
					 + "FROM VW_FIN_PROV_X_CAMPO VW "&
					 + "WHERE VW.RUC is not null "
					 
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, "2") then
				
				ls_serie_cp 	= this.object.serie_cp 			[al_row]
				ls_numero_cp 	= this.object.numero_cp 		[al_row]
				ls_tipo_doc		= this.object.tipo_doc 			[al_row]
				ls_nro_doc		= this.object.nro_doc			[al_row]
				
				//Valido si el documento ya ha sido registrado o no
				if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) and not IsNull(ls_codigo) &
					and not IsNull(ls_tipo_doc) and trim(ls_codigo) <> '' and trim(ls_tipo_doc) <> '' &
					and trim(ls_serie_cp) <> '' and trim(ls_numero_cp) <> '' then
					
					if not invo_cntas_pagar.of_validar_doc( ls_codigo, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
						return 
					end if

					
					//GEnero el numero de documento
					ls_nro_doc = this.object.nro_doc [al_row]
					if is_action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
						ls_nro_doc = invo_cntas_pagar.of_get_nro_doc( ls_codigo, ls_tipo_doc, ls_serie_cp, ls_numero_cp)
						
						if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then return
						
						this.object.nro_doc [al_row] = ls_nro_doc
					end if
					
				end if
				
				this.object.cod_relacion 	[al_row] = ls_codigo
				this.object.nom_proveedor 	[al_row] = ls_data
				
				this.ii_update = 1
				/*Datos del Registro Modificado*/
				ib_estado_prea = TRUE
				/**/
			END IF
								
	END CHOOSE

	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Ha ocurrido una exception")
	
finally
	/*statementBlock*/
end try





end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_fi304_cnts_x_pagar
event ue_find_exact ( )
integer y = 1040
integer width = 3593
integer height = 892
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
				of_generar_asiento ()
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
integer width = 3543
integer height = 736
integer taborder = 20
string dataobject = "d_abc_cntas_pagar_det_tbl"
borderstyle borderstyle = styleraised!
end type

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
		  ls_tipo_ref_grmp, ls_nro_vale, ls_descripcion
Long    ll_count,ll_ano
Decimal ldc_precio_unit, ldc_cantidad, ldc_total, ldc_cant_ingresada

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
			  from centro_beneficio cb
			 where cb.centro_benef	= :data				
				and cb.flag_estado = '1';
				 
			if ll_count = 0 then
				Messagebox('Aviso','Centro Beneficio No Existe o no esta activo ,Verifique!')
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
		
		if gnvo_app.logistica.is_flag_valida_cbe = '1' then //valida centro de beneficio
			//de acuerdo a parametros 
			ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)
	
			if ll_count > 0 then
				This.object.flag_cebef   [row] = ls_null	//no editable tipo fondo
				This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
			else
				This.object.flag_cebef [row] = '1'     //editable		
			end if
		
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
		if gnvo_app.logistica.is_flag_valida_cbe = '1' then //valida centro de beneficio
			ll_count = of_verif_partida(ll_ano,ls_cencos,data)
	
			if ll_count > 0 then
				This.object.flag_cebef   [row] = ls_null	//no editable tipo fondo
				This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
			else
				This.object.flag_cebef [row] = '1'     //editable		
			end if
	
			
		end if
		
	CASE 'cantidad'
		/*Verificacion de Cantidad */
		ls_cod_art 				= this.object.cod_art 				[row]
		ldc_cant_ingresada	= Dec(this.object.cant_ingresada [row])
		ls_nro_vale				= this.object.nro_vale 				[row]
		ldc_precio_unit		= Dec(this.object.precio_unit 	[row])
		ldc_cantidad			= Dec(this.object.cantidad 		[row])
		
		IF Not(Isnull(ls_cod_art) OR Trim(ls_cod_art) = '') THEN
			
			ls_tipo_doc  = This.Object.tipo_doc	 [row]
			ls_nro_doc   = This.Object.nro_doc	 [row]
			ldc_cantidad = This.Object.cantidad  [row]
			ls_cencos    = This.Object.cencos    [row]
			ls_cnta_prsp = This.Object.cnta_prsp [row]
			ls_nro_oc	 = This.Object.cnta_prsp [row]
			
			/*Recupero Nro. de Documento  Doc Referencia*/
			IF idw_ref_x_pagar.Rowcount() = 0 THEN
				Messagebox('Aviso','Provisión debe tener referencia a una Orden de Compra, por favor verifique!')
				This.object.cantidad [row] = 0.0000						
				Return 1
			END IF
			
			if not IsNull(ls_nro_oc) and ls_nro_oc <> '' and not IsNull(ls_nro_Vale) and trim(ls_nro_vale) <> '' and ldc_cant_ingresada > 0 then
				if ldc_cantidad > ldc_cant_ingresada then
					Messagebox('Aviso','Se esta Excediendo en Cantidad Ingresada en Almacén, por favor Verifique!' &
										+ "~r~nNro Vale: " + ls_nro_vale &
										+ "~r~nCant Ingresada: " + String(ldc_cant_ingresada, '999,990.0000'))
					This.object.cantidad [row] = 0.0000
					This.object.importe  [row] = 0.00
					Return 1
				end if
			end if
			
			ls_tipo_ref_grmp 	= This.object.tipo_ref			[row]
			ldc_precio_unit 	= Dec(This.object.precio_unit [row])
			
			IF ls_tipo_ref_grmp <> is_doc_grmp THEN 				
				wf_ver_cant_x_oc(ls_tipo_doc,ls_nro_doc,ls_cod_art,ls_nro_oc,is_Action,ldc_cantidad,ls_flag_cant,ldc_precio_unit,ls_cencos,ls_cnta_prsp)
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
		
		//Actualizo el importe
		this.object.importe [row] = ldc_cantidad * ldc_precio_unit
		
		//ACtualizo los impuestos
		ls_item = Trim(String(This.object.item [row]))
		//Recalculo de Impuesto	
		of_generacion_imp (ls_item)		
		  
		//Total  
		of_calcular_detraccion()
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		of_total_ref ()
		wf_total_ref_grmp()
		
	CASE 'precio_unit'
		ldc_precio_unit		= Dec(this.object.precio_unit 	[row])
		ldc_cantidad			= Dec(this.object.cantidad 		[row])
	
		//Actualizo el importe
		this.object.importe [row] = ldc_cantidad * ldc_precio_unit
	
		//Recalculo de Impuesto	
		ls_item = Trim(String(This.object.item [row]))
		of_generacion_imp (ls_item)		
		
		//Actualizo el importe de la detraccion
		of_calcular_detraccion()
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		
		dw_master.ii_update = 1
		of_total_ref ()
		wf_total_ref_grmp()

	 CASE	'tipo_cred_fiscal'
		
		select descripcion
			into :ls_descripcion
		from 	credito_fiscal 
		where tipo_cred_fiscal	= :data
		  and flag_estado 		= '1'
		  and flag_cxp_cxc 		= 'P';
				 
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Credito Fiscal ' + data + ' no existe, no pertenece a cuentas por pagar o no esta activo,Verifique!')
			This.Object.tipo_cred_fiscal	[row] = gnvo_app.is_null
			This.Object.desc_cred_fiscal 	[row] = gnvo_app.is_null
			Return 1
		
		END IF
		
		This.Object.desc_cred_fiscal [row] = ls_descripcion
		
		//Si el impuesto es 04 - Adquisicion no gravadas entonces elimino el impuesto en el dw impuestos
		if data = '04' then
			ls_item = Trim(String(This.object.item [row]))
			of_delete_impuesto (ls_item)		
			
			//Total  
			of_calcular_detraccion()
			ldc_total = wf_totales ()		
			dw_master.object.importe_doc [1] = ldc_total
			dw_master.ii_update = 1
			of_total_ref ()
			wf_total_ref_grmp()
		end if
		
		
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String  		ls_signo ,ls_cnta_cntbl ,ls_flag_dh_cxp ,ls_desc_cnta,&
				ls_item   , ls_confin, ls_tipo_cred_fiscal, ls_desc_cred_fiscal, ls_tipo_doc
Integer 		li_row
Decimal 		ldc_tasa_impuesto

if dw_master.RowCount() = 0 then 
	return
end if

This.Object.item[al_row] = of_nro_item(this)

/*Autogeneración de Cuentas*/
ib_estado_prea = TRUE

IF Isnull(is_matriz) OR Trim(is_matriz) = '' THEN
	SetNull(ls_confin)
ELSE
	ls_confin = sle_confin.text
END IF
/**/

//Obtengo el tipo doc
ls_tipo_doc 	= dw_master.object.tipo_doc [1]

This.object.confin         [al_row] = ls_confin
This.object.matriz_cntbl	[al_row] = is_matriz
This.object.flag_cebef		[al_row] = '1'
This.object.imp_impuesto	[al_row] = 0.00


//Obtengo el tipo de credito
ls_tipo_cred_fiscal = dw_master.object.tipo_cred_fiscal [1]

select cf.descripcion
	into :ls_desc_cred_fiscal
from credito_fiscal cf
where cf.tipo_cred_fiscal = :ls_tipo_cred_fiscal;

This.object.tipo_cred_fiscal 	[al_row] = ls_tipo_cred_fiscal
This.object.desc_cred_fiscal 	[al_row] = ls_desc_cred_fiscal

/*Inserto Impuesto x Cada Item Ingresado Cuentas x Pagar Detalle*/
li_row = idw_imp_x_pagar.event ue_insert()

idw_imp_x_pagar.object.item [li_row] = al_row

/*Tasa Impuesto Pre Definido*/
SELECT it.tasa_impuesto,it.signo,it.cnta_ctbl,it.flag_dh_cxp,cc.desc_cnta
  INTO :ldc_tasa_impuesto,:ls_signo,:ls_cnta_cntbl,:ls_flag_dh_cxp,:ls_desc_cnta
  FROM impuestos_tipo it,
		 cntbl_cnta		 cc
 WHERE (it.cnta_ctbl		 = cc.cnta_ctbl ) AND
		 (it.tipo_impuesto = :is_cod_igv	  ) ;
 

idw_imp_x_pagar.object.tipo_impuesto 	[li_row] = is_cod_igv
idw_imp_x_pagar.object.tasa_impuesto 	[li_row] = ldc_tasa_impuesto 	
idw_imp_x_pagar.object.cnta_ctbl	    	[li_row] = ls_cnta_cntbl
idw_imp_x_pagar.object.desc_cnta     	[li_row] = ls_desc_cnta
idw_imp_x_pagar.object.signo		   	[li_row] = ls_signo
idw_imp_x_pagar.object.flag_dh_cxp   	[li_row] = ls_flag_dh_cxp



idw_imp_x_pagar.ii_update = 1

//Recalculo de Impuesto	
ls_item = Trim(String(idw_imp_x_pagar.object.item [li_row]))
of_generacion_imp (ls_item)		

/**/
//This.Modify(".Protect='1~tIf(IsNull(item_oc),0,1)'")
this.Modify("precio_unit.Protect   ='1 ~t If(not isnull(item_oc),1,0)'")			
//this.Modify("precio_unit.Edit.Required   ='1 ~t If(not isnull(item_oc),1,0)'")			



end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event ue_display;call super::ue_display;IF Getrow() = 0 THEN Return
str_parametros		lstr_param
String 		    	ls_name,ls_prot,ls_flag_cebef, ls_sql, ls_codigo, ls_data, ls_year, ls_cencos

ls_name = as_columna
ls_prot = This.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE lower(as_columna)
	CASE 'centro_benef'
		ls_sql = "SELECT CB.CENTRO_BENEF AS CODIGO, " &
				 + "CB.DESC_CENTRO AS DESCRIPCION "&
				 + "FROM CENTRO_BENEFICIO CB " &
				 + "WHERE cb.flag_estado = '1'"
				  
				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo

			this.ii_update = 1
		end if

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
		ls_year = string(dw_master.object.ano [dw_master.getRow()])
		
		ls_sql = "SELECT distinct CC.CENCOS   AS CENT_COSTO ,"&
				 + "CC.DESC_CENCOS  AS DESCRIPCION_CENT_COSTO "&
				 + "FROM CENTROS_COSTO CC, " &
				 + "presupuesto_partida pp " &
				 + "where pp.cencos = cc.cencos " &
				 + "  and pp.ano = " + ls_year &
				 + "  and cc.flag_estado <> '0' " &
				 + "  and pp.flag_estado <> '0' "
			  
			 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo

			this.ii_update = 1
		end if
		
	CASE	'tipo_cred_fiscal'
		ls_sql = "select cf.tipo_cred_fiscal as tipo_cred_fiscal, " &
				 + "cf.descripcion as desc_credito_fiscal " &
				 + "from credito_fiscal cf " &
				 + "where cf.flag_cxp_cxc = 'P' " &
				 + "  and cf.flag_estado = '1' " &
				 + "order by 1   "
			  
			 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_cred_fiscal	[al_row] = ls_codigo
			this.object.desc_cred_fiscal	[al_row] = ls_data

			this.ii_update = 1
		end if

	CASE 'cnta_prsp'
		ls_year = string(dw_master.object.ano [dw_master.getRow()])
		ls_cencos = this.object.cencos [al_row]
		
		ls_sql = "SELECT distinct pc.cnta_prsp as cnta_prsp, "&
				 + "pc.descripcion  AS descripcion_cnta_prsp "&
				 + "FROM presupuesto_cuenta pc, " &
				 + "presupuesto_partida pp " &
				 + "where pp.cnta_prsp = pc.cnta_prsp " &
				 + "  and pp.ano = " + ls_year &
				 + "  and pp.cencos = '" + ls_cencos + "'" &
				 + "  and pc.flag_estado <> '0' " &
				 + "  and pp.flag_estado <> '0' "
			  
			 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo

			this.ii_update = 1
		end if

END CHOOSE
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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
integer width = 2583
integer height = 732
integer taborder = 20
string dataobject = "d_abc_doc_referencias_ctas_pag_tbl"
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
this.object.soles 		[al_Row] = gnvo_app.is_soles
this.object.dolares 		[al_Row] = gnvo_app.is_dolares
this.object.tasa_cambio [al_Row] = dw_master.object.tasa_cambio [dw_master.getRow()]
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
integer width = 2875
integer height = 752
integer taborder = 20
string dataobject = "d_abc_cp_det_imp_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String  ls_expresion,ls_item,ls_timpuesto,ls_signo,ls_cnta_cntbl,ls_desc_cnta,&
		  ls_flag_dh_cxp, ls_flag_igv
Long    ll_found
Decimal	ldc_tasa_impuesto, ldc_imp_total,ldc_total

Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado	


CHOOSE CASE dwo.name
	CASE 'tipo_impuesto'
		select it.cnta_ctbl, it.tasa_impuesto, it.signo, it.flag_dh_cxp
			into :ls_cnta_cntbl, :ldc_tasa_impuesto, :ls_signo, :ls_flag_dh_cxp
		from impuestos_tipo it
		where tipo_impuesto = :data
			and it.cnta_ctbl is not null;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Error', 'El impuesto ingresado ' + data + ' no existe o no tiene ninguna cuenta contable asociada, por favor verifique', StopSign!)
			
			This.Object.tasa_impuesto 	[row] = 0.00
			This.Object.signo			  	[row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  		[row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  	[row] = gnvo_app.is_null
			This.Object.desc_cnta	  	[row] = gnvo_app.is_null
			This.Object.importe		  	[row] = 0.00
			
			
			return 1
		end if
		
		//Verifico y busco el importe en el detalle del comprobante
		ls_item = Trim(String(This.object.item [row]))
		
		ls_expresion = 'item = '+ls_item
		ll_found		 = idw_ctas_pag_det.find(ls_expresion, 1, idw_ctas_pag_det.Rowcount())
		
		IF ll_found = 0 THEN
			This.Object.tasa_impuesto 	[row] = 0.00
			This.Object.signo			  	[row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  		[row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  	[row] = gnvo_app.is_null
			This.Object.desc_cnta	  	[row] = gnvo_app.is_null
			This.Object.importe		  	[row] = 0.00
			
			MessageBox('Error', 'No existe el Item ' + ls_item + ' en el detalle del comprobante, por favor verifique', StopSign!)
			return 1
		end if
		
		ldc_imp_total = idw_ctas_pag_det.object.importe [ll_found]							
		
						
		This.Object.tasa_impuesto 	[row] = ldc_tasa_impuesto
		This.Object.signo			  	[row] = ls_signo
		This.Object.cnta_ctbl	  		[row] = ls_cnta_cntbl
		This.Object.flag_dh_cxp	  	[row] = ls_flag_dh_cxp
		This.Object.desc_cnta	  	[row] = ls_desc_cnta
		This.Object.importe		  	[row] = Round(ldc_imp_total * ldc_tasa_impuesto ,4)/ 100
		
		//Recalcula la detraccion
		of_calcular_detraccion()

		//Total  
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		of_total_ref ()
		
		
	CASE 'importe'						
		//Recalcula la detraccion
		of_calcular_detraccion()

		//Total  
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
		of_total_ref ()
	
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cnta_cntbl, ls_flag_dh_cxp, ls_signo, ls_item, ls_expresion
Long		ll_found
decimal	ldc_tasa_impuesto, ldc_importe


choose case lower(as_columna)
	case "tipo_impuesto"
		//Verifico y busco el importe en el detalle del comprobante
		ls_item = Trim(String(This.object.item [al_row]))
		
		ls_expresion = 'item = '+ls_item
		ll_found		 = idw_ctas_pag_det.find(ls_expresion, 1, idw_ctas_pag_det.Rowcount())
		
		IF ll_found = 0 THEN
			This.Object.tasa_impuesto 	[al_row] = 0.00
			This.Object.signo			  	[al_row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  	[al_row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  	[al_row] = gnvo_app.is_null
			This.Object.desc_cnta	  	[al_row] = gnvo_app.is_null
			This.Object.importe		  	[al_row] = 0.00
			
			MessageBox('Error', 'No existe el Item ' + ls_item + ' en el detalle del comprobante, por favor verifique', StopSign!)
			return 
		end if
		
		//Obtengo el importe
		ldc_importe = idw_ctas_pag_det.object.importe [ll_found]	
		
		ls_sql = "select it.tipo_impuesto as tipo_impuesto, " &
				 + "it.desc_impuesto as descripcion_impuesto " &
				 + "from impuestos_tipo it " &
				 + "where it.cnta_ctbl is not null"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			
			select it.cnta_ctbl, it.tasa_impuesto, it.signo, it.flag_dh_cxp
				into :ls_cnta_cntbl, :ldc_tasa_impuesto, :ls_signo, :ls_flag_dh_cxp
			from impuestos_tipo it
			where tipo_impuesto = :ls_codigo;
			
			
			
			this.object.tipo_impuesto	[al_row] = ls_codigo
			this.object.desc_impuesto	[al_row] = ls_data
			this.object.cnta_ctbl		[al_row] = ls_cnta_cntbl
			this.object.tasa_impuesto	[al_row] = ldc_tasa_impuesto
			this.object.signo				[al_row] = ls_signo
			this.object.flag_dh_cxp		[al_row] = ls_flag_dh_cxp
			This.Object.importe		  	[al_row] = Round(ldc_importe * ldc_tasa_impuesto ,4)/ 100
			
			this.ii_update = 1
		end if
		
end choose
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

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_gen_aut[al_row] = '0'
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

type gb_2 from groupbox within w_fi304_cnts_x_pagar
boolean visible = false
integer x = 4741
integer y = 12
integer width = 759
integer height = 388
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Transferir a Solicitud de Giro"
end type

type gb_3 from groupbox within w_fi304_cnts_x_pagar
integer x = 3963
integer y = 888
integer width = 759
integer height = 140
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Confin "
end type

type gb_4 from groupbox within w_fi304_cnts_x_pagar
integer x = 3963
integer y = 720
integer width = 759
integer height = 172
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Orden Trabajo"
end type

type gb_5 from groupbox within w_fi304_cnts_x_pagar
integer x = 3963
integer y = 540
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
long backcolor = 67108864
string text = "Control Documentario"
end type

event constructor;String  ls_tipo_ref ,ls_cod_cliente
Decimal ldc_total, ldc_tasa_cambio
str_parametros lstr_param


if ib_cierre then
	MessageBox('Error', 'Mes contable Cerrado, por favor coordine con contabilidad')
	return
end if

if of_verifica_documento () = false then Return 
	
IF of_verifica_data_oc (ls_cod_cliente,ldc_tasa_cambio) = FALSE THEN Return

lstr_param.tipo		 = '11'
lstr_param.opcion	 	 = 10         //Ordenes de Compra
lstr_param.titulo 	 = 'Selección de Ordenes de Compra'
lstr_param.dw1		 	 = 'd_lista_anticipos_pend_tbl'
lstr_param.dw_m		 = dw_master
lstr_param.dw_d		 = idw_ctas_pag_det
lstr_param.dw_c		 = idw_ref_x_pagar
lstr_param.dw_i		 = idw_imp_x_pagar
lstr_param.string1	 = ls_cod_cliente
lstr_param.db1		 	 = ldc_tasa_cambio
lstr_param.lw_1		 = parent

dw_master.Accepttext()


OpenWithParm( w_abc_seleccion_md, lstr_param)

If isNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = message.PowerObjectParm	

IF lstr_param.titulo = 's' THEN
	OF_CALCULAr_DETRACCION()
	
	ldc_total = wf_totales ()		
	dw_master.object.importe_doc [1] = ldc_total
	
	dw_master.ii_update = 1
	
	
	wf_doc_anticipos () 
	
	
	of_total_ref ()
	
END IF

end event

type gb_1 from groupbox within w_fi304_cnts_x_pagar
integer x = 3963
integer width = 759
integer height = 532
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Referencias"
end type

