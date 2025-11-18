$PBExportHeader$w_ve310_cnts_x_cobrar.srw
forward
global type w_ve310_cnts_x_cobrar from w_abc
end type
type cbx_4 from checkbox within w_ve310_cnts_x_cobrar
end type
type rb_2 from radiobutton within w_ve310_cnts_x_cobrar
end type
type rb_1 from radiobutton within w_ve310_cnts_x_cobrar
end type
type cb_3 from commandbutton within w_ve310_cnts_x_cobrar
end type
type tab_1 from tab within w_ve310_cnts_x_cobrar
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
type dw_detail_referencias from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detail_referencias dw_detail_referencias
end type
type tabpage_3 from userobject within tab_1
end type
type cb_5 from commandbutton within tabpage_3
end type
type dw_det_imp from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_5 cb_5
dw_det_imp dw_det_imp
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
type dw_cnt_ctble_cab from u_dw_abc within tabpage_5
end type
type dw_cnt_ctble_det from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_cnt_ctble_cab dw_cnt_ctble_cab
dw_cnt_ctble_det dw_cnt_ctble_det
end type
type tabpage_6 from userobject within tab_1
end type
type dw_exportacion from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_exportacion dw_exportacion
end type
type tab_1 from tab within w_ve310_cnts_x_cobrar
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_master from u_dw_abc within w_ve310_cnts_x_cobrar
end type
type gb_1 from groupbox within w_ve310_cnts_x_cobrar
end type
type cb_salidas from commandbutton within w_ve310_cnts_x_cobrar
end type
type gb_3 from groupbox within w_ve310_cnts_x_cobrar
end type
end forward

global type w_ve310_cnts_x_cobrar from w_abc
integer width = 4448
integer height = 2900
string title = "Cuentas por Cobrar (VE310)"
string menuname = "m_mantenimiento_cl_anular_ext"
event ue_anular ( )
event ue_find_exact ( )
event ue_anul_trans ( )
event ue_preview ( )
event ue_print_alter ( )
event ue_print_cdep ( )
event ue_print_detra ( )
event ue_print_voucher ( )
event ue_print_gen ( )
cbx_4 cbx_4
rb_2 rb_2
rb_1 rb_1
cb_3 cb_3
tab_1 tab_1
dw_master dw_master
gb_1 gb_1
cb_salidas cb_salidas
gb_3 gb_3
end type
global w_ve310_cnts_x_cobrar w_ve310_cnts_x_cobrar

type variables
DataStore       ids_matriz_cntbl_det,ids_articulos_x_guia,ids_data_glosa,ids_const_dep,ids_formato_det,&
					 ids_voucher
		 
DatawindowChild idw_tasa,idw_doc_tipo,idw_forma_pago
Integer			 ii_lin_x_doc = 23   //colocar en tabla de parametros
String          is_accion,is_orden_venta,  is_doc_ov ,is_flag_valida_cbe , &
					 is_doc_parte_pesca, is_IGV, is_doc_fac
decimal			 idc_tasa_igv
Boolean			 ib_estado_prea = TRUE
Long            il_fila
uf_asiento_contable if_asiento_contable
					 // False = Impuesto No ha Sido Editado
					 // True	 = Impuesto ha Sido Editado
					 													
u_dw_abc			idw_exportacion, idw_det_imp	, idw_detail, idw_referencias,  &
					idw_totales,	idw_cnt_ctble_cab, idw_cnt_ctble_det

u_ds_base		ids_factura, ids_boleta, ids_opersec, ids_fact_after
end variables

forward prototypes
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public function string wf_verifica_user ()
public function boolean wf_generacion_cntas ()
public subroutine wf_ver_cant_x_ov (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_ov, string as_accion, decimal adc_cantidad, ref string as_flag_cant)
public function integer wf_count_update ()
public function decimal wf_totales ()
public subroutine wf_retrieve_doc_x_find (string as_param1, string as_param2, string as_param3, long al_param4, long al_param5, long al_param6, long al_param7, string as_param4)
public function boolean wf_recupera_nro_ov ()
public function boolean wf_nro_doc (string as_tip_doc, long al_nro_serie, ref string as_mensaje)
public subroutine wf_fact_cobrar_alter (string as_tipo_doc, string as_nro_doc)
public function boolean wf_facturacion_operacion (string as_oper_sec, long al_item, string as_tipo_doc, string as_nro_doc)
public subroutine of_asigna_dws ()
public function string wf_verifica_mercado (string as_nro_ov)
public function string of_cbenef_origen (string as_origen)
public function integer of_valida_datos ()
public subroutine of_hab_des_botones (integer al_opcion)
public function integer of_set_articulo (string as_articulo, long al_row)
public subroutine wf_generacion_imp (long al_row)
public subroutine wf_retrieve_doc (string as_param1, string as_param2, string as_param3)
public subroutine wf_fact_cobrar (string as_tipo_doc, string as_nro_doc, string as_empresa)
public subroutine wf_bol_cobrar (string as_tipo_doc, string as_nro_doc, string as_empresa)
public function string of_getdireccion (string as_codigo)
public subroutine wf_fact_cobrar_preview (string as_empresa, string as_tipo_doc, string as_nro_doc)
public subroutine wf_bol_cobrar_preview (string as_empresa, string as_tipo_doc, string as_nro_doc)
public function boolean of_all_articulos ()
public function boolean of_act_cntas_cobrar_det ()
public subroutine of_precio_unitario (long al_row)
public subroutine of_precio_venta (long al_row)
end prototypes

event ue_anular;String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc,ls_result,ls_mensaje
Long    ll_row,ll_row_pasiento,ll_inicio,ll_count,ll_ano,ll_mes
Integer li_opcion

dw_master.Accepttext()
ll_row 			 = dw_master.Getrow()

IF ll_row = 0 OR is_accion = 'new' THEN Return 

ls_flag_estado = dw_master.object.flag_estado [ll_row]


IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1 ) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF

li_opcion = MessageBox('Anula Documento x Cobrar','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN

ls_origen   = dw_master.object.origen   [ll_row]
ls_tipo_doc = dw_master.object.tipo_doc [ll_row]
ls_nro_doc  = dw_master.object.nro_doc  [ll_row]


FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
    idw_detail.object.cantidad		  [ll_inicio] = 0.00
	 idw_detail.object.precio_unitario [ll_inicio] = 0.00
	 idw_detail.object.descuento		  [ll_inicio] = 0.00
	 idw_detail.object.impuesto		  [ll_inicio] = 0.00
	 idw_detail.object.redondeo_manual [ll_inicio] = 0.00
	 idw_detail.object.flag_estado	  [ll_inicio] = '0'
NEXT


dw_master.object.flag_estado[ll_row] 				= '0' // Anulado

is_accion = 'delete'
dw_master.ii_update = 1
idw_detail.ii_update = 1
ib_estado_prea = FALSE


end event

event ue_find_exact();// Asigna valores a structura 
String ls_tipo_doc,ls_nro_doc,ls_origen,ls_cod_relacion
Long   ll_row_master,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_ctas_x_cobrar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 1
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	//TIPO_DOC
	ll_row_master = dw_master.getrow()
	ls_tipo_doc  	 = dw_master.object.tipo_doc		[ll_row_master]
	ls_nro_doc   	 = dw_master.object.nro_doc		[ll_row_master]
	ls_origen	 	 = dw_master.object.origen			[ll_row_master] 
	ll_ano		 	 = dw_master.object.ano          [ll_row_master]
	ll_mes		 	 = dw_master.object.mes          [ll_row_master]
	ll_nro_libro 	 = dw_master.object.nro_libro    [ll_row_master]
	ll_nro_asiento  = dw_master.object.nro_asiento  [ll_row_master]
	ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master] 

	wf_retrieve_doc_x_find(ls_tipo_doc   ,ls_nro_doc,ls_origen   ,&
								  ll_ano        ,ll_mes	   ,ll_nro_libro,&
								  ll_nro_asiento,ls_cod_relacion)
	ib_estado_prea = False   //asiento editado					
	TriggerEvent('ue_modify')
ELSE
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_detail_referencias.Reset()
	idw_det_imp.Reset()
	tab_1.tabpage_4.dw_totales.Reset()
	tab_1.tabpage_5.dw_cnt_ctble_cab.Reset()
	tab_1.tabpage_5.dw_cnt_ctble_det.Reset()
	
	ib_estado_prea = False   //asiento editado						
END IF
















end event

event ue_anul_trans();String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc,ls_result,&
		  ls_mensaje    ,ls_nro_detrac,ls_flag_detrac
Long    ll_row,ll_count,ll_inicio,ll_ano,ll_mes
Integer li_opcion

dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()
tab_1.tabpage_2.dw_detail_referencias.Accepttext()
idw_det_imp.Accepttext()
tab_1.tabpage_5.dw_cnt_ctble_cab.Accepttext()
tab_1.tabpage_5.dw_cnt_ctble_det.Accepttext()

ll_row 			 = dw_master.Getrow()

IF ll_row = 0 OR is_accion = 'new' THEN RETURN //NO EXISTE REGISTRO PARA ANULAR TRANSACION

ls_flag_estado = dw_master.object.flag_estado	  [ll_row]
ll_ano			= dw_master.object.ano 				  [ll_row]
ll_mes			= dw_master.object.mes 				  [ll_row]
ls_nro_detrac  = dw_master.object.nro_detraccion  [ll_row]
ls_flag_detrac	= dw_master.object.flag_detraccion [ll_row]
				
/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario

IF Not(ls_flag_estado = '1' OR ls_flag_estado = '0') OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	 tab_1.tabpage_2.dw_detail_referencias.ii_update = 1	OR idw_det_imp.ii_update = 1 OR &
	 tab_1.tabpage_5.dw_cnt_ctble_cab.ii_update = 1 OR tab_1.tabpage_5.dw_cnt_ctble_det.ii_update = 1 ) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular Toda la Transación Realizada',Exclamation!)
	 RETURN
END IF

li_opcion = MessageBox('Anula Transación','Esta Seguro de Anular Transación Totalmente',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN //no desea anular transacion

ls_origen   = dw_master.object.origen   [ll_row]
ls_tipo_doc = dw_master.object.tipo_doc [ll_row]
ls_nro_doc  = dw_master.object.nro_doc  [ll_row]

/*Verifica Si ha tenido Transaciones*/
SELECT Count(*)
  INTO :ll_count
  FROM doc_referencias
 WHERE (origen_ref = :ls_origen   ) AND
 		 (tipo_ref   = :ls_tipo_doc ) AND
		 (nro_ref	 = :ls_nro_doc  ) ;
/**/
IF ll_count > 0 THEN
	Messagebox('Aviso','Documento Tiene Transaciones Realizadas ,Verifique!')
   Return
END IF

//facturacion de operacion
update facturacion_operacion fo
   set fo.tipo_doc = null ,fo.nro_doc = null,flag_replicacion = '1'
 where (fo.tipo_doc	= :ls_tipo_doc) and
 		 (fo.nro_doc	= :ls_nro_doc ) ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Error UPDATE Operaciones', SQLCA.SQLErrText)
	RETURN
END IF

/*Elimino Cabecera de Cntas x Cobrar*/
DO WHILE dw_master.Rowcount() > 0
	dw_master.Deleterow(0)
LOOP

/*Elimino detalle de Cntas x cobrar*/
DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
	tab_1.tabpage_1.dw_detail.Deleterow(0)
LOOP

/*Elimino Impuesto de Cntas Cobrar*/
DO WHILE idw_det_imp.Rowcount() > 0
	idw_det_imp.Deleterow(0)
LOOP

/*Elimino documentos de Referencias*/
DO WHILE tab_1.tabpage_2.dw_detail_referencias.Rowcount() > 0
	tab_1.tabpage_2.dw_detail_referencias.Deleterow(0)
LOOP

// Elimino Factura de exportacion
idw_exportacion.Deleterow(0)

//Cabecera de Asiento
tab_1.tabpage_5.dw_cnt_ctble_cab.Object.flag_estado [1] = '0'
tab_1.tabpage_5.dw_cnt_ctble_cab.Object.tot_solhab	 [1] = 0.00
tab_1.tabpage_5.dw_cnt_ctble_cab.Object.tot_dolhab	 [1] = 0.00
tab_1.tabpage_5.dw_cnt_ctble_cab.Object.tot_soldeb	 [1] = 0.00
tab_1.tabpage_5.dw_cnt_ctble_cab.Object.tot_doldeb  [1] = 0.00

//Detalle de Asiento
FOR ll_inicio = 1 TO tab_1.tabpage_5.dw_cnt_ctble_det.Rowcount()
  	 tab_1.tabpage_5.dw_cnt_ctble_det.Object.imp_movsol [ll_inicio] = 0.00
  	 tab_1.tabpage_5.dw_cnt_ctble_det.Object.imp_movdol [ll_inicio] = 0.00		
NEXT
//


is_accion = 'anular'
dw_master.ii_update = 1
tab_1.tabpage_1.dw_detail.ii_update = 1
tab_1.tabpage_2.dw_detail_referencias.ii_update = 1
idw_det_imp.ii_update = 1
tab_1.tabpage_5.dw_cnt_ctble_cab.ii_update = 1
tab_1.tabpage_5.dw_cnt_ctble_det.ii_update = 1
idw_exportacion.ii_update						 = 1
ib_estado_prea = FALSE //no autogeneracion de asientos

tab_1.tabpage_5.dw_cnt_ctble_det.ii_protect = 0
tab_1.tabpage_5.dw_cnt_ctble_det.of_protect()
end event

event ue_preview();Long   ll_row
String ls_tipo_doc,ls_fact_cobrar,ls_bol_cobrar,ls_nro_doc, ls_empresa


IF dw_master.Getrow() = 0 THEN RETURN

IF (dw_master.ii_update = 1 OR idw_detail.ii_update  = 1 ) THEN
	 Messagebox('Aviso','Existen Actualizaciones Pendientes Verifique!')
	 Return
END IF	 

SELECT doc_fact_cobrar, doc_bol_cobrar
  INTO :ls_fact_cobrar,:ls_bol_cobrar
  FROM finparam 
 WHERE (reckey = '1') ;

IF Isnull(ls_fact_cobrar) OR Trim(ls_fact_cobrar) = '' THEN
	Messagebox('Aviso','Documentos de Factura x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
	Return
END IF

IF Isnull(ls_bol_cobrar) OR Trim(ls_bol_cobrar) = '' THEN
	Messagebox('Aviso','Documentos de Boleta x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
	Return
END IF

//Impresión de Documento 
ls_tipo_doc = dw_master.object.tipo_doc 		[dw_master.getrow()]
ls_nro_doc 	= dw_master.object.nro_doc  		[dw_master.getrow()]
ls_empresa 	= dw_master.object.cod_empresa  	[dw_master.getrow()]
	
IF ls_tipo_doc = ls_fact_cobrar THEN       //Caso Facturas
	wf_fact_cobrar_preview(ls_empresa, ls_tipo_doc,ls_nro_doc)
ELSEIF ls_tipo_doc = ls_bol_cobrar THEN	 //Caso Boletas
	wf_bol_cobrar_preview (ls_empresa, ls_tipo_doc,ls_nro_doc)
END IF
	


end event

event ue_print_alter();Long   ll_row
String ls_tipo_doc,ls_fact_cobrar,ls_bol_cobrar,ls_nro_doc


IF dw_master.Getrow() = 0 THEN RETURN
IF (dw_master.ii_update = 1 						 			  OR tab_1.tabpage_1.dw_detail.ii_update  = 1 OR &
	 tab_1.tabpage_2.dw_detail_referencias.ii_update = 1 OR idw_det_imp.ii_update	= 1 OR &
	 tab_1.tabpage_5.dw_cnt_ctble_cab.ii_update      = 1 OR tab_1.tabpage_5.dw_cnt_ctble_det.ii_update = 1 )THEN
	 Messagebox('Aviso','Existen Actualizaciones Pendientes Verifique!')
	 Return
END IF	 

SELECT doc_fact_cobrar, doc_bol_cobrar
  INTO :ls_fact_cobrar,:ls_bol_cobrar
  FROM finparam 
 WHERE (reckey = '1') ;

IF Isnull(ls_fact_cobrar) OR Trim(ls_fact_cobrar) = '' THEN
	Messagebox('Aviso','Documentos de Factura x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
	Return
END IF

IF Isnull(ls_bol_cobrar) OR Trim(ls_bol_cobrar) = '' THEN
	Messagebox('Aviso','Documentos de Boleta x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
	Return
END IF

//Impresión de Documento 

ls_tipo_doc = dw_master.object.tipo_doc [dw_master.getrow()]
ls_nro_doc 	= dw_master.object.nro_doc  [dw_master.getrow()]
	
IF ls_tipo_doc = ls_fact_cobrar THEN       //Caso Facturas
	wf_fact_cobrar_ALTER(ls_tipo_doc,ls_nro_doc)
ELSEIF ls_tipo_doc = ls_bol_cobrar THEN	 //Caso Boletas
	Messagebox('Aviso','No Existe Formato ,Verifique!')
END IF
	
end event

event ue_print_cdep;
String ls_nro_detrac

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_nro_detrac =dw_master.object.nro_detraccion[dw_master.getrow()]

IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
	Messagebox('Aviso','No existe Detraccion Verifique!')
END IF
ids_const_dep.Retrieve(gnvo_app.invo_empresa.is_empresa,ls_nro_detrac)
ids_const_dep.Print(True)
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

event ue_print_gen();String ls_tipo_doc,ls_nro_doc

dw_master.accepttext()
ls_tipo_doc = dw_master.object.tipo_doc [1]
ls_nro_doc	= dw_master.object.nro_doc  [1]


DECLARE pb_usp_fin_tt_ctas_x_cobrar PROCEDURE FOR usp_fin_tt_ctas_x_cobrar
(:ls_tipo_doc,:ls_nro_doc);
EXECUTE pb_usp_fin_tt_ctas_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure usp_fin_tt_ctas_x_cobrar , Comunicar en Area de Sistemas' )
	RETURN
END IF


//dw_1.retrieve()

//dw_1.object.p_logo.filename = gnvo_app.is_logo
//dw_1.print()
end event

public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef
Boolean lb_retorno = TRUE


IF f_cntbl_cnta(as_cta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref, &
					 ls_flag_cod_rel,ls_flag_cebef)  THEN


	IF ls_flag_ctabco = '1' THEN
		Messagebox('Generacion de Asientos','Campo Cta.Banco es Requerido para Generar Asientos de Cuenta '+as_cta_cntbl+' Verifique !')
	   lb_retorno = FALSE	
	END IF

	IF ls_flag_cencos = '1' THEN
		Messagebox('Generacion de Asientos','Campo C.Costos es Requerido para Generar Asientos de Cuenta '+as_cta_cntbl+' Verifique !')
	   lb_retorno = FALSE	
	END IF

	IF ls_flag_doc_ref = '1' THEN
		tab_1.tabpage_5.dw_cnt_ctble_det.object.tipo_docref1[al_row] = as_tipo_doc
		tab_1.tabpage_5.dw_cnt_ctble_det.object.nro_docref1 [al_row] = as_nro_doc
	ELSE
		SetNull(as_tipo_doc)
		SetNull(as_nro_doc)
		tab_1.tabpage_5.dw_cnt_ctble_det.object.tipo_docref1[al_row] = as_tipo_doc
		tab_1.tabpage_5.dw_cnt_ctble_det.object.nro_docref1 [al_row] = as_nro_doc
	END IF

	IF ls_flag_cod_rel = '1' THEN
		tab_1.tabpage_5.dw_cnt_ctble_det.object.cod_relacion [al_row] = as_cod_relacion
	ELSE
		SetNull(as_cod_relacion)
		tab_1.tabpage_5.dw_cnt_ctble_det.object.cod_relacion [al_row] = as_cod_relacion
	END IF	

ELSE
   lb_retorno = FALSE
END IF

///**/
Return lb_retorno
end function

public function string wf_verifica_user ();String ls_doc_ventas,ls_mensaje = ''
Long   ll_count

/**/
SELECT doc_ventas
  INTO :ls_doc_ventas
  FROM finparam
 WHERE reckey = '1' ;

IF Isnull(ls_doc_ventas) OR Trim(ls_doc_ventas) = '' THEN
	ls_mensaje = 'Debe Ingresar Grupo de Documento de Venta en Archivo de Parametros'
	Return ls_mensaje	
END IF
	
/**/
SELECT Count(*)
  INTO :ll_count
  FROM doc_tipo_usuario
 WHERE (cod_usr = :gnvo_app.is_user) ;

 IF ll_count = 0 THEN
	 ls_mensaje = 'Usuario No Ha Sido definido en tipo de Documento a Visualizar'
	Return ls_mensaje	 	
 END IF
 
/**/
SELECT Count(*)
  INTO :ll_count
  FROM doc_grupo_relacion
 WHERE (doc_grupo_relacion.tipo_doc = (SELECT tipo_doc FROM doc_tipo_usuario  WHERE cod_usr = :gnvo_app.is_user )) ;


 IF ll_count = 0 THEN
	 ls_mensaje = 'Tipos de Documentos del Usuario No tiene Relacion en Archivo DOC_GRUPO_RELACION'
	 Return ls_mensaje	 	
 END IF
 
 
 Return ls_mensaje

  
         

end function

public function boolean wf_generacion_cntas ();Long    ll_row,ll_count
String  ls_moneda,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_campo_formula,&
		  ls_cencos,ls_cebef
Decimal ldc_tasa_cambio
Boolean lb_retorno

ll_row   = dw_master.Getrow()

dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()

//*Limpia DataStore*//
ids_matriz_cntbl_det.Reset()

IF ll_row   = 0 THEN RETURN FALSE


ls_moneda 		 = dw_master.object.cod_moneda  [1]
ldc_tasa_cambio = dw_master.object.tasa_cambio [1]

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



ls_tipo_doc 	  = dw_master.object.tipo_doc     [1]
ls_nro_doc  	  = dw_master.object.nro_doc	    [1]  
ls_cod_relacion  = dw_master.object.cod_relacion [1]
ls_campo_formula = 'tipo_impuesto'


lb_retorno  = f_generacion_ctas_cxc_cxp(dw_master, &
					idw_detail, &
					idw_referencias, &
					idw_det_imp, &
					idw_cnt_ctble_det, &
					ids_matriz_cntbl_det, &
					ids_data_glosa, &
					ls_moneda, &
					ldc_tasa_cambio, &
					ls_campo_formula, &
					tab_1, &
					'C', &
					ls_cencos, &
					ls_cebef)

IF lb_retorno = TRUE THEN
	idw_cnt_ctble_det.ii_update = 1
END IF


Return lb_retorno
end function

public subroutine wf_ver_cant_x_ov (string as_tipo_doc, string as_nro_doc, string as_cod_art, string as_nro_ov, string as_accion, decimal adc_cantidad, ref string as_flag_cant);DECLARE PB_USP_FIN_CANT_X_ART_X_OV PROCEDURE FOR USP_FIN_CANT_X_ART_X_OV 
(:as_tipo_doc,:as_nro_doc,:as_cod_art,:as_nro_ov,:as_accion,:adc_cantidad);
EXECUTE PB_USP_FIN_CANT_X_ART_X_OV ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_CANT_X_ART_X_OV INTO :as_flag_cant ;
CLOSE PB_USP_FIN_CANT_X_ART_X_OV ;
end subroutine

public function integer wf_count_update ();Integer li_update,li_update_pre_asiento


IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR tab_1.tabpage_2.dw_detail_referencias.ii_update = 1 OR idw_det_imp.ii_update = 1 THEN
	li_update = 4
END IF	



Return li_update
end function

public function decimal wf_totales ();Long 	  ll_inicio
String  ls_signo
Decimal {2} ldc_impuesto        = 0.00, ldc_total_imp = 0     ,ldc_bruto           = 0 , &
		      ldc_total_bruto     = 0.00, ldc_descuento = 0     ,ldc_total_descuento = 0 , &
		      ldc_redondeo        = 0.00, ldc_total_redondeo = 0,ldc_total_general	 = 0


tab_1.tabpage_4.dw_totales.Reset()
tab_1.tabpage_4.dw_totales.Insertrow(0)


ldc_total_general = 0
FOR ll_inicio = 1 TO idw_detail.Rowcount()
	
	 ldc_bruto 		= Round(idw_detail.object.cantidad[ll_inicio] * idw_detail.object.precio_unitario [ll_inicio],2)
	 ldc_impuesto 	= Round(idw_detail.object.cantidad[ll_inicio] * idw_detail.object.impuesto		   [ll_inicio],2)
	 
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 IF isnull(ldc_impuesto)  THEN ldc_impuesto  = 0 		 
	 
	 ldc_total_general 		+= ldc_bruto + ldc_impuesto
NEXT


IF Isnull(ldc_total_general) THEN ldc_total_general = 0.00
Return ldc_total_general

end function

public subroutine wf_retrieve_doc_x_find (string as_param1, string as_param2, string as_param3, long al_param4, long al_param5, long al_param6, long al_param7, string as_param4);String ls_periodo,ls_expresion,ls_doc_gr,ls_cod_art ,ls_flag_mercado
Long 	 ll_inicio


tab_1.tabpage_1.dw_detail.retrieve(as_param1,as_param2)
tab_1.tabpage_2.dw_detail_referencias.retrieve(as_param1,as_param2,as_param4)
idw_det_imp.retrieve(as_param1,as_param2)
tab_1.tabpage_5.dw_cnt_ctble_cab.retrieve(as_param3,al_param4,al_param5,al_param6,al_param7)	
tab_1.tabpage_5.dw_cnt_ctble_det.retrieve(as_param3,al_param4,al_param5,al_param6,al_param7)	
wf_totales()
//


	
dw_master.il_row = 1

/*Verifico referencias*/
SELECT doc_gr
  INTO :ls_doc_gr
  FROM logparam
 WHERE (reckey = '1') ;
/**/
IF Isnull(ls_doc_gr) OR Trim(ls_doc_gr) = '' THEN
	Messagebox('Aviso','Tipo de Documento Guia de Remision No Existe , Verifique Tabla de Parmetros Logparam !')
	ls_expresion = ''
ELSE
	ls_expresion = 'tipo_ref = '+"'"+ls_doc_gr+"'"
END IF


tab_1.tabpage_2.dw_detail_referencias.Setfilter(ls_expresion)
tab_1.tabpage_2.dw_detail_referencias.Filter()

IF tab_1.tabpage_2.dw_detail_referencias.rowcount() > 0 THEN
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
		 tab_1.tabpage_1.dw_detail.object.flag [ll_inicio] = 'G'			//Guia de Remisión
	Next
	
END IF

tab_1.tabpage_2.dw_detail_referencias.SetFilter('')
tab_1.tabpage_2.dw_detail_referencias.Filter()

IF tab_1.tabpage_1.dw_detail.Rowcount() > 0 THEN
	IF tab_1.tabpage_2.dw_detail_referencias.rowcount() = 0 THEN
		ls_cod_art = tab_1.tabpage_1.dw_detail.object.cod_art [1]
		IF Not(Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' ) THEN
			
			For ll_inicio = 1  TO tab_1.tabpage_1.dw_detail.Rowcount()
				 tab_1.tabpage_1.dw_detail.object.flag_art [ll_inicio] = 'P' //Productos Terminados	
			Next
		END IF
	END IF	
END IF

dw_master.ii_update = 0
tab_1.tabpage_1.dw_detail.ii_update 				= 0
tab_1.tabpage_2.dw_detail_referencias.ii_update = 0
idw_det_imp.ii_update 				= 0
tab_1.tabpage_5.dw_cnt_ctble_cab.ii_update 		= 0
tab_1.tabpage_5.dw_cnt_ctble_det.ii_update 		= 0



//buscar si orden de venta es de exportacion
//buscar referencias
if tab_1.tabpage_1.dw_detail.Rowcount() > 0 then
	is_orden_venta = tab_1.tabpage_1.dw_detail.object.nro_ref [1]
end if	



ls_flag_mercado = wf_verifica_mercado (is_orden_venta)

if ls_flag_mercado = 'E' then 

	idw_exportacion.Retrieve(as_param1, as_param2 )
	idw_exportacion.ii_update = 0
	if idw_exportacion.Rowcount( ) = 0 then idw_exportacion.event ue_insert( )
end if

is_accion = 'fileopen'
end subroutine

public function boolean wf_recupera_nro_ov ();String ls_tipo_doc,ls_origen_ref,ls_nro_ref,ls_origen_ov

IF tab_1.tabpage_2.dw_detail_referencias.Rowcount() > 0 THEN
	IF Len(Trim(is_orden_venta)) = 0 THEN
		
		ls_origen_ref = tab_1.tabpage_2.dw_detail_referencias.Object.origen_ref [1]
		ls_nro_ref	  = tab_1.tabpage_2.dw_detail_referencias.Object.nro_ref	   [1]
		
		DECLARE PB_USP_FIN_NRO_OV_X_GUIA PROCEDURE FOR USP_FIN_NRO_OV_X_GUIA
		(:ls_origen_ref, :ls_nro_ref);
		EXECUTE PB_USP_FIN_NRO_OV_X_GUIA ;

		IF SQLCA.SQLCode = -1 THEN 
			MessageBox("SQL error", SQLCA.SQLErrText)
			Return False
		END IF

		FETCH PB_USP_FIN_NRO_OV_X_GUIA INTO :ls_tipo_doc  ,:is_orden_venta,:ls_origen_ov;
		CLOSE PB_USP_FIN_NRO_OV_X_GUIA;		
	END IF
ELSE
	is_orden_venta = ''
END IF
Return True
 

end function

public function boolean wf_nro_doc (string as_tip_doc, long al_nro_serie, ref string as_mensaje);Long    ll_nro_doc,ll_row, ll_count
Integer li_dig_serie,li_dig_numero
String  ls_lock_table
Boolean lb_retorno = TRUE

ll_row = idw_doc_tipo.Getrow()

ls_lock_table = 'LOCK TABLE NUM_DOC_TIPO IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT count(*)
  INTO :ll_count
  FROM num_doc_tipo
 WHERE tipo_doc  = :as_tip_doc   
   AND nro_serie = :al_nro_serie
	and cod_empresa = :gnvo_app.invo_empresa.is_empresa;

if ll_count = 0 then
	insert into num_doc_tipo(tipo_doc, nro_serie, ultimo_numero, cod_empresa)
	values(:as_tip_doc, :al_nro_serie, 1, :gnvo_app.invo_empresa.is_empresa);
end if

SELECT ultimo_numero
  INTO :ll_nro_doc
  FROM num_doc_tipo
 WHERE tipo_doc  = :as_tip_doc   
   AND nro_serie = :al_nro_serie 
	and cod_empresa = :gnvo_app.invo_empresa.is_empresa for update ;
	
//****************************//
//Actualiza Tabla num_doc_tipo//
//****************************//

UPDATE num_doc_tipo
SET 	 ultimo_numero = ultimo_numero + 1
WHERE  tipo_doc  = :as_tip_doc   
  AND  nro_serie = :al_nro_serie 
  and  cod_empresa = :gnvo_app.invo_empresa.is_empresa;
	
IF SQLCA.SQLCode = -1 THEN 
	as_mensaje = 'No se Pudo Actualizar Tabla num_doc_tipo por Tipo de Documento Ha Generar, Verifique!'
	lb_retorno = FALSE
	ROLLBACK;
	GOTO SALIDA
ELSE
	/**/
	SELECT digitos_serie, digitos_numero
	  INTO :li_dig_serie, :li_dig_numero
	  FROM finparam
	 WHERE (reckey = '1')  ;
	/**/
	
	IF Isnull(li_dig_serie) OR li_dig_serie = 0 or SQLCA.SQLCode = 100 THEN
		li_dig_serie = 3
	END IF
	
	IF Isnull(li_dig_numero) OR li_dig_numero = 0 or SQLCA.SQLCode = 100 THEN
		li_dig_numero = 6
	END IF
	
	dw_master.object.nro_doc [1] =  f_llena_caracteres('0',Trim(String(al_nro_serie)),li_dig_serie)+'-'+ f_llena_caracteres('0',Trim(String(ll_nro_doc)),li_dig_numero)
END IF	


SALIDA:

Return lb_retorno


end function

public subroutine wf_fact_cobrar_alter (string as_tipo_doc, string as_nro_doc);DECLARE pb_usp_fin_tt_ctas_x_cobrar PROCEDURE FOR usp_fin_tt_ctas_x_cobrar
(:as_tipo_doc,:as_nro_doc);
EXECUTE pb_usp_fin_tt_ctas_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure usp_fin_tt_ctas_x_cobrar , Comunicar en Area de Sistemas' )
	RETURN
END IF

//*Imprime Factura*//
f_imp_bol_fact() 
//dw_factura.visible = FALSE
//dw_fact_alter.Retrieve()
//dw_fact_alter.Print(True)

end subroutine

public function boolean wf_facturacion_operacion (string as_oper_sec, long al_item, string as_tipo_doc, string as_nro_doc);String ls_msj_err
Boolean lb_ret = FALSE

UPDATE facturacion_operacion
   SET tipo_doc = :as_tipo_doc ,nro_doc = :as_nro_doc
 WHERE (oper_sec = :as_oper_sec ) AND
 		 (item     = :al_item     )	;
		  
		  
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	Rollback;
   MessageBox("SQL error", ls_msj_err)

END IF		  


Return lb_ret
end function

public subroutine of_asigna_dws ();idw_det_imp	 	 	= tab_1.tabpage_3.dw_det_imp
idw_exportacion 	= tab_1.tabpage_6.dw_exportacion
idw_detail		   = tab_1.tabpage_1.dw_detail
idw_referencias   = tab_1.tabpage_2.dw_detail_referencias
idw_totales		   = tab_1.tabpage_4.dw_totales
idw_cnt_ctble_cab = tab_1.tabpage_5.dw_cnt_ctble_cab
idw_cnt_ctble_det = tab_1.tabpage_5.dw_cnt_ctble_det

end subroutine

public function string wf_verifica_mercado (string as_nro_ov);String ls_flag_mercado

select flag_mercado into :ls_flag_mercado from orden_venta where nro_ov = :as_nro_ov ;


if isnull(ls_flag_mercado) or Trim(ls_flag_mercado) = '' then
	ls_flag_mercado = 'L'
end if

Return ls_flag_mercado
end function

public function string of_cbenef_origen (string as_origen);String ls_cen_ben

select cen_bef_gen_vtas into :ls_cen_ben
  from origen where cod_origen = :as_origen ;
  

Return ls_cen_ben  
end function

public function integer of_valida_datos ();// Valida datos de cliente, moneda, tipo_cambio

String   ls_cod_cliente, ls_cod_moneda
Long     ll_row_master
Decimal {4} ldc_tasa_cambio 

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN 0

ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN 0
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN 0
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN 0
END IF


RETURN 1
end function

public subroutine of_hab_des_botones (integer al_opcion);// Funcion para habilitar y deshabilitar los botones
// al_opcion :  1 = habilita, 0 = deshabilita

IF al_opcion = 0 THEN
	//cb_1.Enabled = False
	//cb_2.enabled = False
	//cb_3.enabled = False
	//cb_4.enabled = False
ELSE
	//cb_1.Enabled = True
	//cb_2.enabled = True
	//cb_3.enabled = True
	//cb_4.enabled = True
END IF
end subroutine

public function integer of_set_articulo (string as_articulo, long al_row);string 	ls_desc_art, ls_und, ls_flag_und2, ls_und2, ls_cod_art, &
			ls_codigo_serie, ls_mon_vta, ls_msg
Decimal	ldc_fac_conv, ldc_precio_vta, ldc_igv
integer	li_garantia_cliente

			
if dw_master.GetRow() = 0 then 
	MessageBox('Aviso', 'No existe cabecera de Factura o boleta')
	return 0
end if


// Verifica que codigo ingresado exista			
Select 	desc_art, und, Nvl(flag_und2,'0'), und2, NVL(factor_conv_und, 0),
			cod_art, codigo_serie, precio_venta, moneda_vta, garantia_cliente
	into 	:ls_desc_art, :ls_und, :ls_flag_und2, :ls_und2,:ldc_fac_conv,
			:ls_cod_art, :ls_codigo_serie, :ldc_precio_vta, :ls_mon_vta,
			:li_garantia_cliente
from articulo 
Where cod_art = :as_articulo
   or codigo_serie = :as_articulo ;

if Sqlca.sqlcode = 100 then 
	ROLLBACK;
	Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
		+ "' no existe", StopSign!)
	Return 0
end if		

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_msg)
	return 0
end if

// Saco el IGV del precio de venta ya que tiene el IGV
ldc_precio_vta = round(ldc_precio_vta / (1 + idc_tasa_igv/100),2)
idw_detail.object.descripcion 		[al_row] = ls_desc_art
idw_detail.object.precio_unitario	[al_row] = ldc_precio_vta
ldc_igv = dec(idw_detail.object.tasa_impuesto	[al_row])
idw_detail.object.impuesto				[al_row] = round(ldc_precio_vta * ldc_igv / 100,2)

dw_master.object.importe_doc [dw_master.getRow()] = wf_totales( )

return 1
end function

public subroutine wf_generacion_imp (long al_row);String      ls_item,ls_expresion, ls_tipo_doc ,ls_flag_mercado
Long 			ll_inicio,ll_found
Decimal {2} ldc_total,ldc_tasa_impuesto,ldc_redondeo, ldc_precio, ldc_impuesto


ldc_tasa_impuesto	= idw_detail.object.tasa_impuesto 	 [al_row]
ldc_precio 			= idw_detail.object.precio_unitario  [al_row]

IF Isnull(ldc_tasa_impuesto)    THEN ldc_tasa_impuesto    = 0.00
IF Isnull(ldc_precio) THEN ldc_precio = 0.00
 
ldc_impuesto = Round((ldc_precio * ldc_tasa_impuesto ) / 100 ,2)

idw_detail.object.impuesto 		[al_row] = ldc_impuesto
idw_detail.object.precio_venta 	[al_row] = ldc_precio + ldc_impuesto
 
		

end subroutine

public subroutine wf_retrieve_doc (string as_param1, string as_param2, string as_param3);String ls_periodo,ls_expresion,ls_doc_gr,ls_cod_art,ls_flag_mercado
Long 	 ll_inicio


dw_master.retrieve(as_param1,as_param2, as_param3)
dw_master.ii_update = 0

tab_1.tabpage_1.dw_detail.retrieve(as_param1,as_param2, as_param3)
tab_1.tabpage_1.dw_detail.ii_update = 0

wf_totales()


dw_master.il_row = 1


is_accion = 'fileopen'
end subroutine

public subroutine wf_fact_cobrar (string as_tipo_doc, string as_nro_doc, string as_empresa);string ls_mensaje
u_ds_base ds_factura

//create or replace procedure usp_fin_tt_ctas_x_cobrar(
//       asi_tipo_doc in cntas_cobrar.tipo_doc%type,
//       asi_nro_doc  in cntas_cobrar.nro_doc%type,
//       asi_empresa  in cntas_cobrar.cod_empresa%TYPE  
//) is

DECLARE usp_fin_tt_ctas_x_cobrar PROCEDURE FOR 
	usp_fin_tt_ctas_x_cobrar(:as_tipo_doc,
									 :as_nro_doc,
									 :as_empresa );
EXECUTE usp_fin_tt_ctas_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Fallo Store Procedure usp_fin_tt_ctas_x_cobrar', ls_mensaje )
	RETURN
END IF

ds_factura = create u_ds_base

IF gnvo_app.invo_empresa.is_empresa = 'E0000004' THEN
	ds_factura.dataobject = 'd_rpt_fact_cobrar_rho_ff'
else
	ds_factura.dataobject = 'd_rpt_fact_cobrar_ff'
end if

ds_factura.Settransobject(sqlca)

//*Imprime Factura*//
//f_imp_bol_fact()


ds_factura.Retrieve(as_empresa, as_tipo_doc, as_nro_doc)
ds_factura.object.dataWindow.Print.Paper.Size = 256  //personalizado
ds_factura.object.dataWindow.Print.CustomPage.Length = 210
ds_factura.object.dataWindow.Print.CustomPage.width = 164

ds_factura.Print(True, true)
	
destroy ds_factura
end subroutine

public subroutine wf_bol_cobrar (string as_tipo_doc, string as_nro_doc, string as_empresa);String ls_mensaje
u_ds_base ds_boleta

//create or replace procedure usp_fin_tt_bol_x_cobrar(
//       asi_tipo_doc in cntas_cobrar.tipo_doc%type,
//       asi_nro_doc  in cntas_cobrar.nro_doc%type,
//       asi_empresa  in cntas_cobrar.cod_empresa%TYPE  
//) is

ds_boleta = create u_ds_base

if rb_1.checked then //local

	ds_boleta.dataobject = 'd_rpt_bol_cobrar_ff'
	ds_boleta.Settransobject(sqlca)

	
	ds_boleta.Retrieve(as_empresa, as_tipo_doc, as_nro_doc)
	ds_boleta.object.dataWindow.Print.Paper.Size = 256  //personalizado
	ds_boleta.object.dataWindow.Print.CustomPage.Length = 210
	ds_boleta.object.dataWindow.Print.CustomPage.width = 164	
	
	ds_boleta.Print(True, true)

elseif rb_2.checked then //externo
	
	
end if

//seteo boleta a objeto original
//dw_boleta.dataobject = 'd_rpt_bol_cobrar_ff'
//dw_boleta.Settransobject(sqlca)

destroy ds_boleta
end subroutine

public function string of_getdireccion (string as_codigo);string 	ls_null, ls_pais, ls_distrito, ls_provincia, ls_dpto_estado, &
			ls_ciudad, ls_urb, ls_direccion, ls_mnz, ls_lote, ls_nro, &
			ls_cod_postal, ls_full_direccion
Long		ll_count

SetNull(ls_null)

IF Isnull(as_codigo) OR Trim(as_codigo)  = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Verifique!')
	Return ''
END IF

SELECT Count(*)
  INTO :ll_count
  FROM direcciones
 WHERE codigo = :as_codigo
   and flag_uso = '1' ;
		  
		  
IF ll_count = 0 THEN
	Messagebox('Aviso','Cliente no tiene Direccion de Facturación, Verifique!')				
	Return ''
end if
	
	

SELECT 	dir_pais, dir_distrito, dir_provincia, dir_dep_estado,
			dir_ciudad, dir_urbanizacion, dir_direccion, dir_mnz, dir_lote,
			dir_numero, dir_cod_postal
  INTO :ls_pais, :ls_distrito, :ls_provincia, :ls_dpto_estado, &
		 :ls_ciudad, :ls_urb, :ls_direccion, :ls_mnz, :ls_lote, &
		 :ls_nro, :ls_cod_postal		
  FROM direcciones
 WHERE codigo = :as_codigo 
	AND flag_uso = '1' 
order by item;
	 
ls_full_direccion = ""

if Not IsNull(ls_urb) and ls_urb <> '' then
	ls_full_direccion += "Urb. " + trim(ls_urb) + ", " 
end if

if Not IsNull(ls_direccion) and ls_direccion <> '' then
	ls_full_direccion += trim(ls_direccion) + " " 
end if

if Not IsNull(ls_nro) and ls_nro <> '' then
	ls_full_direccion += "# " + trim(ls_nro) + " " 
end if

if Not IsNull(ls_mnz) and ls_mnz <> '' then
	ls_full_direccion += "Mnz. " + trim(ls_mnz) + " " 
end if
	 
if Not IsNull(ls_lote) and ls_lote <> '' then
	ls_full_direccion += "Lote. " + trim(ls_lote) + " " 
end if

if Not IsNull(ls_ciudad) and ls_ciudad <> '' then
	ls_full_direccion += trim(ls_ciudad) + " " 
end if

if Not IsNull(ls_distrito) and ls_distrito <> '' then
	ls_full_direccion += ", " + trim(ls_distrito)
end if

if Not IsNull(ls_provincia) and ls_provincia <> '' then
	ls_full_direccion += ", " + trim(ls_provincia)
end if

if Not IsNull(ls_dpto_estado) and ls_dpto_estado <> '' then
	ls_full_direccion += ", " + trim(ls_dpto_estado)
end if

if Not IsNull(ls_pais) and ls_pais <> '' then
	ls_full_direccion += ", " + trim(ls_pais)
end if


return ls_full_direccion
end function

public subroutine wf_fact_cobrar_preview (string as_empresa, string as_tipo_doc, string as_nro_doc);// vista previa de guia
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 = 'd_rpt_fact_cobrar_ff'

lstr_rep.titulo = 'Previo de Factura'
lstr_rep.string1 = as_empresa
lstr_rep.string2 = as_tipo_doc
lstr_rep.string3 = as_nro_doc
lstr_rep.tipo 	  = '1S2S3S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end subroutine

public subroutine wf_bol_cobrar_preview (string as_empresa, string as_tipo_doc, string as_nro_doc);// vista previa de guia
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 = 'd_rpt_bol_cobrar_ff'

lstr_rep.titulo = 'Previo de Factura'
lstr_rep.string1 = as_empresa
lstr_rep.string2 = as_tipo_doc
lstr_rep.string3 = as_nro_doc
lstr_rep.tipo 	  = '1S2S3S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end subroutine

public function boolean of_all_articulos ();string  ls_mensaje, ls_null
integer li_ok

SetNull(ls_null)

//CREATE OR REPLACE PROCEDURE usp_alm_act_saldo_all(
//       asi_nada             in  string,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_saldo_all PROCEDURE FOR
	usp_alm_act_saldo_all( :ls_null );

EXECUTE usp_alm_act_saldo_all;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_saldo_all:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH usp_alm_act_saldo_all INTO :ls_mensaje, :li_ok;
CLOSE usp_alm_act_saldo_all;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return false
end if

return true
end function

public function boolean of_act_cntas_cobrar_det ();string  ls_mensaje, ls_null

SetNull(ls_null)

//create or replace procedure USP_VTAS_CNTAS_COBRAR_DET(
//       asi_nada   in varchar2
//) is

DECLARE USP_VTAS_CNTAS_COBRAR_DET PROCEDURE FOR
	USP_VTAS_CNTAS_COBRAR_DET( :ls_null );

EXECUTE USP_VTAS_CNTAS_COBRAR_DET;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_VTAS_CNTAS_COBRAR_DET:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_VTAS_CNTAS_COBRAR_DET;

return true
end function

public subroutine of_precio_unitario (long al_row);Decimal {2} ldc_tasa_impuesto, ldc_precio_venta, ldc_impuesto, &
				ldc_precio_unit


ldc_tasa_impuesto	= idw_detail.object.tasa_impuesto 	[al_row]
ldc_precio_venta 	= idw_detail.object.precio_venta  	[al_row]

IF Isnull(ldc_tasa_impuesto)    THEN ldc_tasa_impuesto    = 0.00
IF Isnull(ldc_precio_venta) THEN ldc_precio_venta = 0.00
 
ldc_precio_unit = Round(ldc_precio_venta / (1 + ldc_tasa_impuesto / 100) ,2)
ldc_impuesto 	 = ldc_precio_venta - ldc_precio_unit

idw_detail.object.impuesto 			[al_row] = ldc_impuesto
idw_detail.object.precio_unitario 	[al_row] = ldc_precio_unit
 
		

end subroutine

public subroutine of_precio_venta (long al_row);Decimal {2} ldc_precio, ldc_impuesto


ldc_impuesto 		= idw_detail.object.impuesto 	 		[al_row]
ldc_precio 			= idw_detail.object.precio_unitario  [al_row]

IF Isnull(ldc_impuesto)    THEN ldc_impuesto    = 0.00
IF Isnull(ldc_precio) THEN ldc_precio = 0.00
 
idw_detail.object.precio_venta 	[al_row] = ldc_precio + ldc_impuesto
 
		

end subroutine

on w_ve310_cnts_x_cobrar.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_ext" then this.MenuID = create m_mantenimiento_cl_anular_ext
this.cbx_4=create cbx_4
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_3=create cb_3
this.tab_1=create tab_1
this.dw_master=create dw_master
this.gb_1=create gb_1
this.cb_salidas=create cb_salidas
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_4
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.cb_salidas
this.Control[iCurrent+9]=this.gb_3
end on

on w_ve310_cnts_x_cobrar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_4)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_3)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.cb_salidas)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;
String ls_mensaje

idw_exportacion = tab_1.tabpage_6.dw_exportacion
idw_det_imp = tab_1.tabpage_3.dw_det_imp

select doc_ov, cod_igv, flag_centro_benef
	into :is_doc_ov, :is_igv, :is_flag_valida_cbe
from logparam
where reckey = '1';

if is_doc_ov = '' or IsNull(is_doc_ov) then
	MessageBox('Error', 'No ha definido doc_ov en logparam')
	this.post event close()
	return
end if

select tasa_impuesto
	into :idc_tasa_igv
	from impuestos_tipo
where tipo_impuesto = :is_igv;

//Obtengo el tipo de documento FAC
select doc_fact_cobrar
  into :is_doc_fac
from finparam
where reckey = '1';

dw_master.SetTransObject(sqlca)  				                // Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_detail_referencias.SetTransObject(sqlca)
idw_det_imp.settransobject( sqlca )
tab_1.tabpage_4.dw_totales.SetTransObject(sqlca)
tab_1.tabpage_5.dw_cnt_ctble_cab.SetTransObject(sqlca)
tab_1.tabpage_5.dw_cnt_ctble_det.SetTransObject(sqlca)
idw_exportacion.SetTransObject( SQLCA )
//dw_factura.Settransobject(sqlca)
//dw_boleta.Settransobject(sqlca)
//dw_fact_alter.Settransobject(sqlca)
//dw_opersec.Settransobject(sqlca)

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

//** Datastore Articulos x Guia **//
ids_articulos_x_guia = Create Datastore
ids_articulos_x_guia.DataObject = 'd_art_guia_vale_tbl'
ids_articulos_x_guia.SettransObject(sqlca)
////** **//

//** Datastore Detraccion **//
ids_const_dep = Create Datastore
ids_const_dep.DataObject = 'd_rpt_detraccion_tbl'
ids_const_dep.SettransObject(sqlca)

//** Datastore Formato Detraccion **//
ids_formato_det = Create Datastore
ids_formato_det.DataObject = 'd_rpt_formato_detraccion_tbl'
ids_formato_det.SettransObject(sqlca)

//** Datastore Voucher **//
ids_voucher = Create Datastore
ids_voucher.DataObject = 'd_rpt_voucher_imp_cc_tbl'
ids_voucher.SettransObject(sqlca)


ls_mensaje = wf_verifica_user ()

IF Not(Isnull(ls_mensaje) OR Trim(ls_mensaje) = '' ) THEN
	Messagebox('Aviso',ls_mensaje)
END IF

//** Insertamos GetChild de Tipo de Documento dw_master **//
dw_master.Getchild('tipser',idw_doc_tipo )
idw_doc_tipo.settransobject(sqlca)
idw_doc_tipo.Retrieve(gnvo_app.invo_empresa.is_empresa)
idw_doc_tipo.SetFilter("cod_usr = '" + gnvo_app.is_user + "'")
idw_doc_tipo.Filter()
	
//** Insertamos GetChild de Forma de Pago **//
dw_master.Getchild('forma_pago',idw_forma_pago)
idw_forma_pago.settransobject(sqlca)
idw_forma_pago.Retrieve()
//** **//

//** Insertamos GetChild de Tasa de Impuesto Tab 3 **//
idw_det_imp.Getchild('tipo_impuesto',idw_tasa )
idw_tasa.settransobject(sqlca)
idw_tasa.Retrieve()
//** **//
	
idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
//TriggerEvent('ue_insert')

of_position_window(0,0)       			// Posicionar la ventana en forma fija

//Crear Objeto
if_asiento_contable = create uf_asiento_contable


end event

event resize;call super::resize;of_asigna_dws( )

tab_1.width  = newwidth  - tab_1.x - this.cii_windowborder
tab_1.height = p_pie.y - tab_1.y 

idw_detail.width        = tab_1.tabpage_1.width  - idw_detail.x - this.cii_windowborder
idw_detail.height       = tab_1.tabpage_1.height - idw_detail.y - this.cii_windowborder

idw_referencias.width 	= tab_1.tabpage_2.width - idw_referencias.x - this.cii_windowborder
idw_referencias.height 	= tab_1.tabpage_2.height - idw_referencias.y - this.cii_windowborder


//idw_det_imp.height            = newheight - idw_det_imp.y - 900
//tab_1.tabpage_4.dw_totales.height            = newheight - tab_1.tabpage_4.dw_totales.y - 900
//tab_1.tabpage_5.dw_cnt_ctble_det.width       = newwidth  - tab_1.tabpage_5.dw_cnt_ctble_det.x - 75
//tab_1.tabpage_5.dw_cnt_ctble_det.height      = newheight - tab_1.tabpage_5.dw_cnt_ctble_det.y - 1090
//
//idw_exportacion.width   = newwidth  - idw_exportacion.X - 75
//idw_exportacion.height  = newheight - idw_exportacion.y - 1090

end event

event ue_insert;String  ls_flag_estado, ls_mensaje, ls_result, ls_tipo_doc, &
			ls_flag_mercado, ls_doc_ex
Long    ll_row, ll_currow, ll_ano, ll_mes, ll_dir
Boolean lb_result

ll_row = dw_master.Getrow()

CHOOSE CASE idw_1
	 	 CASE dw_master
				TriggerEvent('ue_update_request')
				idw_1.Reset()
				tab_1.tabpage_1.dw_detail.Reset()
				tab_1.tabpage_2.dw_detail_referencias.Reset()
				idw_det_imp.Reset()
				tab_1.tabpage_4.dw_totales.Reset()
				tab_1.tabpage_5.dw_cnt_ctble_cab.Reset()
				tab_1.tabpage_5.dw_cnt_ctble_det.Reset()
				idw_exportacion.Reset()
				is_accion = 'new'
				ib_estado_prea = TRUE   //Pre Asiento No editado	
				
				//habilita botones
				of_hab_des_botones ( 1 )
				
	
 		 CASE idw_detail
			
				IF dw_master.Getrow( ) = 0 THEN RETURN
				
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				
				
				IF ls_flag_estado <> '1' OR idw_referencias.Rowcount() > 0 THEN RETURN //Documento Ha sido Anulado o facturado
									
				IF idw_detail.Rowcount () = ii_lin_x_doc	THEN
					Messagebox('Aviso','No Puede Exceder de '+Trim(String(ii_lin_x_doc))+' Items x Documento')	
					Return
				END IF
				
							
				ib_estado_prea = TRUE   //Pre Asiento No editado	
				
		 CASE	ELSE
				Return
END CHOOSE


ll_row = idw_1.Event ue_insert()
IF idw_1 = dw_master THEN
	idw_1.Setcolumn('cod_relacion')
END IF

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_insert_pos;call super::ue_insert_pos;//IF idw_1 = dw_master THEN
//	tab_1.tabpage_5.dw_cnt_ctble_cab.TriggerEvent('ue_insert')
//ELSEIF idw_1 = tab_1.tabpage_1.dw_detail THEN
//	IF cbx_2.checked = TRUE THEN
//		tab_1.tabpage_1.dw_detail.Object.flag_art [al_row] = 'P'
//		tab_1.tabpage_1.dw_detail.Setcolumn('cod_art')
//	ELSE
//		tab_1.tabpage_1.dw_detail.Setcolumn('descripcion')
//	END IF
//END IF

tab_1.tabpage_1.dw_detail.Setcolumn('cod_art')
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 						 			  OR tab_1.tabpage_1.dw_detail.ii_update  = 1 OR &
	 tab_1.tabpage_2.dw_detail_referencias.ii_update = 1 OR idw_det_imp.ii_update	= 1 OR &
	 tab_1.tabpage_5.dw_cnt_ctble_cab.ii_update      = 1 OR tab_1.tabpage_5.dw_cnt_ctble_det.ii_update = 1 OR &
	 idw_exportacion.ii_update = 1 )THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update  				= 1 
	   tab_1.tabpage_2.dw_detail_referencias.ii_update = 1 
	   idw_det_imp.ii_update				= 1 
		tab_1.tabpage_5.dw_cnt_ctble_cab.ii_update      = 1 
	   tab_1.tabpage_5.dw_cnt_ctble_det.ii_update      = 1 
		idw_exportacion.ii_update								= 1
	END IF
END IF

end event

event ue_update_pre;String   ls_cod_origen   ,ls_tipo_doc ,ls_nro_doc   ,ls_cod_cliente,ls_cnta_ctbl  ,ls_periodo   ,&
		   ls_tdoc_fac     ,ls_mensaje  ,ls_result    ,ls_flag_detrac,ls_nro_detrac ,ls_const_dep ,&
			ls_flag_estado  ,ls_oper_sec ,ls_cod_moneda,ls_soles      ,ls_dolares    ,ls_cta_cte   ,&
			ls_cod_relacion ,ls_descrip  , ls_vendedor ,ls_flag_mercado,&
			ls_centro_benef, ls_empresa
			
Long 	   ll_inicio,ll_flag_ov,ll_nro_libro,ll_nro_serie,ll_nro_asiento = 0,&
		   ll_item,ll_count,ll_ano,ll_mes,li_opcion,ll_item_op
			
Date     ld_last_day,ldt_fecha_dep
Datetime ldt_fecha_doc
Decimal {2} ldc_totsoldeb = 0,ldc_totdoldeb = 0,ldc_totsolhab = 0,ldc_totdolhab = 0,ldc_importe_imp ,&
			   ldc_porc_detr	 ,ldc_monto_detrac ,ldc_import_cob    ,ldc_saldo_sol    ,ldc_saldo_dol	 ,&
				ldc_precio_unit_exp
Decimal {4}	ldc_tasa_cambio		  
str_parametros lstr_param			  
dwItemStatus ldis_status

ib_update_check = true
nvo_numeradores lnvo_numeradores
lnvo_numeradores = CREATE nvo_numeradores



/**REPLICACION**/

dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_detail.of_set_flag_replicacion()
tab_1.tabpage_2.dw_detail_referencias.of_set_flag_replicacion()
idw_det_imp.of_set_flag_replicacion()
tab_1.tabpage_5.dw_cnt_ctble_cab.of_set_flag_replicacion()
tab_1.tabpage_5.dw_cnt_ctble_det.of_set_flag_replicacion()
idw_exportacion.of_set_flag_replicacion( )


IF is_accion = 'anular' THEN //ANULO TRANSACION
	ib_update_check = TRUE
	destroy lnvo_numeradores
	Return
END IF

//monedas
f_monedas(ls_soles,ls_dolares)
//

/*DATOS DE CABECERA */
IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( idw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

IF tab_1.tabpage_1.dw_detail.Rowcount() = 0 THEN 
	ib_update_check = False	
	RETURN
END IF

ls_tipo_doc = dw_master.object.tipo_doc 		[1]
ls_empresa  = dw_master.object.cod_empresa 	[1]


IF is_accion = 'new' THEN
	//Asignación  de Nro de Serie
	ll_nro_serie  = idw_doc_tipo.Getitemnumber(idw_doc_tipo.getrow(),'nro_serie')

	IF wf_nro_doc(ls_tipo_doc, ll_nro_serie, ls_mensaje) = FALSE THEN
		ib_update_check = False	
		Messagebox('Aviso',ls_mensaje)
		Return
	END IF
	
END IF

ls_nro_doc	= dw_master.object.nro_doc 		[1]

dw_master.object.importe_doc [1] = wf_totales()


//actualiza saldos de documento generado
IF ls_cod_moneda = ls_soles THEN 
	ldc_saldo_sol = ldc_import_cob
	ldc_saldo_dol = Round(ldc_import_cob / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = ls_dolares THEN
	ldc_saldo_sol = Round(ldc_import_cob *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_import_cob
END IF

//saldos
dw_master.object.saldo_sol [1] = ldc_saldo_sol 
dw_master.object.saldo_dol [1] = ldc_saldo_dol


///detalle de Documento
FOR ll_inicio = 1 TO idw_detail.Rowcount()

	 idw_detail.object.tipo_doc 		[ll_inicio]  = ls_tipo_doc		 
	 idw_detail.object.nro_doc  		[ll_inicio]  = ls_nro_doc		 
	 idw_detail.object.cod_empresa  	[ll_inicio]  = ls_empresa
	 
NEXT

///Referencias de Documentos
FOR ll_inicio = 1 TO idw_referencias.Rowcount()
	 idw_referencias.object.tipo_doc     [ll_inicio] = ls_tipo_doc		 
	 idw_referencias.object.nro_doc      [ll_inicio] = ls_nro_doc		 
	 idw_referencias.object.cod_relacion [ll_inicio] = ls_cod_cliente	 
NEXT

destroy lnvo_numeradores




end event

event ue_update;dwItemStatus ldis_status
String ls_tipo_doc,ls_nro_doc,ls_oper_sec, ls_empresa
Long   ll_inicio,ll_item_op
Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()
idw_referencias.AcceptText()
idw_det_imp.AcceptText()
idw_cnt_ctble_cab.AcceptText()
idw_cnt_ctble_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	ROLLBACK USING SQLCA;	
	RETURN
END IF

IF idw_cnt_ctble_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
	IF idw_cnt_ctble_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
		lbo_ok = FALSE
		messagebox("Error en Grabacion Pre - Asiento Cabecera","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_cnt_ctble_det.ii_update = 1 AND lbo_ok = TRUE  THEN
	IF idw_cnt_ctble_det.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Pre - Asiento Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF is_accion <> 'anular' THEN
	//*Transacion Normal*//
	IF	dw_master.ii_update = 1  AND lbo_ok = TRUE  THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_referencias.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Referencias","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_detail.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_det_imp.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_det_imp.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Messagebox("Error en Grabacion Impuestos","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_exportacion.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF idw_exportacion.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_exportacion","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
ELSE
	
	//*Anulo Transacion*//
	// Anulo la Factura de Exportacion	
	IF idw_exportacion.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF idw_exportacion.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_exportacion","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_det_imp.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_det_imp.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Messagebox("Error en Grabacion Impuestos","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_referencias.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Referencias","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_detail.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF	dw_master.ii_update = 1  AND lbo_ok = TRUE  THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
END IF	


IF lbo_ok THEN
	
	if not this.of_act_cntas_cobrar_det() then return;
	
	COMMIT using SQLCA;
	
	if is_accion = 'anular' then
		// Si se anula el documento actualizo el saldo de todos los artículos
		this.of_all_Articulos()
	end if

	
	dw_master.ii_update 			= 0
	idw_detail.ii_update 		= 0
	idw_referencias.ii_update 	= 0
	idw_det_imp.ii_update 		= 0
	idw_cnt_ctble_cab.ii_update 		= 0
	idw_cnt_ctble_det.ii_update 		= 0
	ib_estado_prea = False   //pre-asiento editado	
	idw_exportacion.ii_update = 0
	
	//obtengo el numero de la factura
	ls_tipo_doc = dw_master.object.tipo_doc 	 [dw_master.GetRow()]
	ls_nro_doc 	= dw_master.object.nro_doc 	 [dw_master.GetRow()]
	ls_empresa	= dw_master.object.cod_empresa [dw_master.GetRow()]
	
	this.wf_retrieve_doc( ls_tipo_doc, ls_nro_doc, ls_empresa)
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_delete;//override
Long   ll_row,ll_inicio,ll_found,ll_ano,ll_mes
String ls_cod_art,ls_cod_origen,ls_nro_ref,ls_expresion_det,ls_expresion_imp,ls_item,&
		 ls_flag_estado,ls_flag,ls_tipo_doc,ls_doc_ov,ls_doc_gr,ls_result,ls_mensaje
Decimal {2} ld_cantidad_vale,ld_cantidad_doc


CHOOSE CASE idw_1
		 CASE tab_1.tabpage_1.dw_detail
				ll_row = idw_1.Getrow()
				IF ll_row = 0 THEN RETURN		
				ls_flag_estado = dw_master.object.flag_estado [1]
				ll_ano			= dw_master.object.ano 			 [1]
				ll_mes			= dw_master.object.mes 			 [1]
				
				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

				ls_flag    = idw_1.Object.flag [ll_row]
				IF Not (Isnull(ls_flag) OR Trim(ls_flag) = '' ) THEN
					Return			
				END IF
				
		 CASE tab_1.tabpage_2.dw_detail_referencias
			
			   //Si Se Elimina Una Referencia se tiene que descontar o eliminar la cantidad de 
				//los articulos tomandos en cuenta por el doc 
				ll_row = idw_1.Getrow()
				IF ll_row = 0 THEN RETURN
				ls_flag_estado = dw_master.object.flag_estado [1]
				ll_ano			= dw_master.object.ano 			 [1]
				ll_mes			= dw_master.object.mes 			 [1]
				
				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
				
				
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado
				/***********************************************************/
				/* Recuperación de Tipo de Documento Guia , Orden de Venta */
				/***********************************************************/
				
				SELECT doc_ov, doc_gr
				  INTO :ls_doc_ov, :ls_doc_gr
				  FROM logparam
				 WHERE (reckey = '1') ;
				 
				/**/
				
				ls_tipo_doc		= tab_1.tabpage_2.dw_detail_referencias.Object.tipo_REF	 [ll_row]
				ls_cod_origen  = tab_1.tabpage_2.dw_detail_referencias.Object.origen_ref [ll_row]
				ls_nro_ref	   = tab_1.tabpage_2.dw_detail_referencias.Object.nro_ref 	 [ll_row]
				

				IF ls_tipo_doc = ls_doc_gr THEN /*Guia de Remisión*/
				
					ids_articulos_x_guia.Retrieve(ls_cod_origen,ls_nro_ref)
					
					
				
					FOR ll_inicio = 1 TO ids_articulos_x_guia.Rowcount()

						 ls_cod_art   		= ids_articulos_x_guia.object.cod_art 		   [ll_inicio]	 	
						 ld_cantidad_vale = ids_articulos_x_guia.object.cant_procesada [ll_inicio]	 	
						 ls_expresion_det	= 'cod_art ='+"'"+ls_cod_art+"'"
						 ll_found     		= tab_1.tabpage_1.dw_detail.find(ls_expresion_det,1,tab_1.tabpage_1.dw_detail.rowcount())


					 	 IF ll_found > 0 THEN
							 ld_cantidad_doc = tab_1.tabpage_1.dw_detail.object.cantidad [ll_found] 
						 
							 IF ld_cantidad_doc > ld_cantidad_vale THEN
								 ///Resto Cantidad de Item Considerado
								 tab_1.tabpage_1.dw_detail.object.cantidad [ll_found] = tab_1.tabpage_1.dw_detail.object.cantidad [ll_found] - ld_cantidad_vale
								 tab_1.tabpage_1.dw_detail.ii_update = 1					 
							 ELSE
								 //Eliminar impuesto del item a eliminar
								 ls_item			   = Trim(String(tab_1.tabpage_1.dw_detail.object.nro_item [ll_found]))
								 ls_expresion_imp = 'item = '+ls_item
								 idw_det_imp.SetFilter(ls_expresion_imp)
								 idw_det_imp.Filter()
							 
								 DO WHILE idw_det_imp.Rowcount() > 0
									 idw_det_imp.deleterow(0)
								    idw_det_imp.ii_update = 1
								 LOOP
							 
								 idw_det_imp.SetFilter('')
								 idw_det_imp.Filter()
								
							 
								 tab_1.tabpage_1.dw_detail.deleterow(ll_found)
								 tab_1.tabpage_1.dw_detail.ii_update  = 1
							 
							 END IF
					 	END IF	  
					NEXT
					
			

				ELSEIF ls_tipo_doc = ls_doc_ov THEN    /*Orden de Venta*/
					
					 /*Elimina Impuestos*/	
					 DO WHILE idw_det_imp.Rowcount() > 0
						 idw_det_imp.deleterow(0)
					    idw_det_imp.ii_update = 1
					 LOOP
					 
					 /*Elimina Items de Detalle*/
					 DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
						 tab_1.tabpage_1.dw_detail.deleterow(0)
					    tab_1.tabpage_1.dw_detail.ii_update = 1
					 LOOP
					 
				END IF
				

				
 		 CASE idw_det_imp
				ll_row = dw_master.Getrow()
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ll_ano			= dw_master.object.ano 			 [ll_row]
				ll_mes			= dw_master.object.mes 			 [ll_row]
				
				/*verifica cierre*/
				if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) //movimiento bancario
				
				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN //Documento Ha sido Anulado o facturado

END CHOOSE

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event closequery;call super::closequery;Destroy ids_articulos_x_guia
Destroy ids_data_glosa
Destroy ids_matriz_cntbl_det
Destroy if_asiento_contable
Destroy ids_formato_det
Destroy ids_voucher


end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_cta_x_cobrar_x_tbl'
sl_param.titulo = 'Cuentas x Cobrar'
sl_param.field_ret_i[1] = 1  //TIPO_DOC
sl_param.field_ret_i[2] = 2  //NRO_DOC
sl_param.field_ret_i[3] = 3  //COD_EMPRESA
sl_param.field_ret_i[4] = 12 //ORIGEN
sl_param.field_ret_i[5] = 13 //ANO
sl_param.field_ret_i[6] = 14 //MES
sl_param.field_ret_i[7] = 15 //NRO_LIBRO
sl_param.field_ret_i[8] = 16 //NRO_ASIENTO
sl_param.field_ret_i[9] = 3  //COD_RELACION
sl_param.tipo = '1S'
sl_param.string1 = gnvo_app.invo_empresa.is_empresa


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
   wf_retrieve_doc(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	ib_estado_prea = False   //asiento editado					
	TriggerEvent('ue_modify')
END IF

end event

event ue_modify;Long    ll_row,ll_ano,ll_mes
String  ls_flag_estado,ls_mensaje,ls_result
Integer li_protect

ll_row = dw_master.Getrow()
dw_master.accepttext()
IF ll_row = 0 THEN RETURN


ls_flag_estado = dw_master.object.flag_estado [ll_row]


dw_master.of_protect()
idw_detail.of_protect()
	

IF ls_flag_estado <> '1' OR ls_result = '0' THEN
	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()

ELSE
	IF is_accion <> 'new' THEN
		li_protect = integer(dw_master.Object.tipser.Protect)
		IF li_protect = 0	THEN
			dw_master.object.tipser.Protect 		  = 1
			dw_master.object.cod_relacion.Protect = 1
		END IF
	END IF	
	
	
END IF


end event

event ue_delete_pos;call super::ue_delete_pos;/*Genera Pre Asientos*/
ib_estado_prea = TRUE
/**/

//Asigno total
dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
dw_master.ii_update = 1

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_print;Long   ll_row
String 	ls_tipo_doc,ls_fact_cobrar,ls_bol_cobrar,ls_nro_doc, &
			ls_flag_mercado, ls_empresa
str_parametros lstr_param
w_ve307_factura_export_frm lw_1


IF dw_master.Getrow() = 0 THEN RETURN

IF (dw_master.ii_update = 1 OR idw_detail.ii_update  = 1 ) THEN
	 Messagebox('Aviso','Existen Actualizaciones Pendientes Verifique!')
	 Return
END IF	 

SELECT doc_fact_cobrar, doc_bol_cobrar
  INTO :ls_fact_cobrar,:ls_bol_cobrar
  FROM finparam 
 WHERE (reckey = '1') ;

IF Isnull(ls_fact_cobrar) OR Trim(ls_fact_cobrar) = '' THEN
	Messagebox('Aviso','Documentos de Factura x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
	Return
END IF

IF Isnull(ls_bol_cobrar) OR Trim(ls_bol_cobrar) = '' THEN
	Messagebox('Aviso','Documentos de Boleta x Cobrar No Existe en Tabla de Parametros FINPARAM , Verifique !')
	Return
END IF


//Impresión de Documento 
ls_tipo_doc = dw_master.object.tipo_doc 		[dw_master.getrow()]
ls_nro_doc 	= dw_master.object.nro_doc  		[dw_master.getrow()]
ls_empresa  = dw_master.object.cod_empresa  	[dw_master.getrow()]
	
IF ls_tipo_doc = ls_fact_cobrar THEN       //Caso Facturas
	wf_fact_cobrar(ls_tipo_doc,ls_nro_doc, ls_empresa)
ELSEIF ls_tipo_doc = ls_bol_cobrar THEN	 //Caso Boletas
	wf_bol_cobrar(ls_tipo_doc,ls_nro_doc, ls_empresa)
END IF
	


end event

event open;call super::open;of_asigna_dws( )
end event

type p_pie from w_abc`p_pie within w_ve310_cnts_x_cobrar
end type

type ole_skin from w_abc`ole_skin within w_ve310_cnts_x_cobrar
integer x = 4242
integer y = 176
end type

type uo_h from w_abc`uo_h within w_ve310_cnts_x_cobrar
end type

type st_box from w_abc`st_box within w_ve310_cnts_x_cobrar
end type

type phl_logonps from w_abc`phl_logonps within w_ve310_cnts_x_cobrar
string picturename = "C:\SIGRE\resources\logos\NPSSAC_logo.png"
end type

type p_mundi from w_abc`p_mundi within w_ve310_cnts_x_cobrar
end type

type p_logo from w_abc`p_logo within w_ve310_cnts_x_cobrar
end type

type cbx_4 from checkbox within w_ve310_cnts_x_cobrar
integer x = 4082
integer y = 748
integer width = 78
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean lefttext = true
end type

type rb_2 from radiobutton within w_ve310_cnts_x_cobrar
integer x = 3575
integer y = 756
integer width = 466
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Formato Externo"
end type

type rb_1 from radiobutton within w_ve310_cnts_x_cobrar
integer x = 3575
integer y = 696
integer width = 544
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Formato Local"
boolean checked = true
end type

type cb_3 from commandbutton within w_ve310_cnts_x_cobrar
integer x = 3593
integer y = 452
integer width = 562
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string text = "Guia de Remisión"
end type

event clicked;//override
// Asigna valores a structura 
Long 		ll_row
string	ls_mensaje, ls_nro_guia

if dw_master.GetRow() = 0 then return

ll_row = dw_master.GetRow()

if dw_master.object.flag_estado[ll_row] = '0' then
	ls_mensaje = "El Documento se encuentra anulado, por favor verifique"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return
end if

ls_nro_guia = dw_master.object.nro_guia[ll_row]
if Not IsNull(ls_nro_guia) and trim(ls_nro_guia) <> '' then
	ls_mensaje = "El Documento ya tiene guia de remision, por favor verifique"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	return
end if


str_parametros sl_param

sl_param.dw1    = 'd_sel_guias_tbl'
sl_param.titulo = 'Guias Pendientes'
sl_param.field_ret_i[1] = 1  //Origen GUIA
sl_param.field_ret_i[2] = 2  //NRO GUIA
sl_param.tipo = '1S2S'
sl_param.string1 = gnvo_app.invo_empresa.is_empresa
sl_param.string2 = dw_master.object.cod_relacion[ll_row]


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	dw_master.object.org_guia [ll_row] = sl_param.field_ret[1]
	dw_master.object.nro_guia [ll_row] = sl_param.field_ret[2]
	dw_master.ii_update = 1
END IF

end event

type tab_1 from tab within w_ve310_cnts_x_cobrar
event ue_find_exact ( )
integer x = 503
integer y = 964
integer width = 3648
integer height = 1292
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
boolean pictureonright = true
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

event selectionchanged;

CHOOSE CASE newindex
		 CASE	4	
				IF wf_count_update() = 0 THEN RETURN			
				wf_totales()
		 CASE 5
			   IF ib_estado_prea = FALSE THEN RETURN //  Editado
				wf_generacion_cntas ()
END CHOOSE

end event

event key;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF


end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1172
long backcolor = 79741120
string text = "Registro"
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
integer y = 12
integer width = 3525
integer height = 772
integer taborder = 20
string dataobject = "d_abc_cntas_x_cobrar_det_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		  // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

idw_mst  = dw_master // dw_master
idw_det  = tab_1.tabpage_1.dw_detail	// dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_matriz ,ls_tipo_doc    ,ls_nro_doc ,ls_cod_art ,ls_nro_ov ,ls_flag_cant,&
				ls_item	 ,ls_descripcion ,ls_confin  ,ls_matriz_cntbl,ls_tipo_ref,ls_flag_dl27400,&
				ls_tip_cred_fiscal,ls_null,ls_cod_clase,ls_rubro,ls_origen, &
				ls_desc
Decimal {2}	ldc_cantidad, ldc_tasa
Long        ll_count

Accepttext()


/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

setnull(ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_art'
		if of_set_articulo( data, row) = 0 then
			this.object.cod_art			[row] = ls_null
			this.object.descripcion		[row] = ls_null
			
			this.setColumn("cod_art")
			return 1
		end if
					
					
	CASE 'almacen'
		SELECT desc_almacen
		  INTO :ls_desc
		  FROM almacen
		 WHERE almacen = :data 
			and flag_estado = '1';
				 
				
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Almacen No existe Verifique')
			This.Object.confin 		 [row] = ls_null
			This.object.matriz_cntbl [row] = ls_null
			Return 1
		END IF
		
	CASE 'tipo_impuesto'
		SELECT tasa_impuesto
		  INTO :ldc_tasa
		  FROM impuestos_tipo
		 WHERE tipo_impuesto = :data;
				
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','tipo de Impuesto No existe Verifique')
			This.Object.tipo_impuesto 		 [row] = ls_null
			This.object.tasa_impuesto		 [row] = 0
			Return 1
		END IF
		
		This.object.tasa_impuesto		[row] = ldc_tasa
		this.object.impuesto				[row] = Dec(this.object.precio_unitario [row]) * ldc_tasa/100
		of_precio_venta(row)
		dw_master.object.importe_doc 	[dw_master.getrow()] = wf_totales ()

	CASE 'precio_unitario'
		//Recalculo de Impuesto	
		wf_generacion_imp (row)		
		//Asigno total
		dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
		dw_master.ii_update = 1

	CASE 'precio_venta'
		//Recalculo de Impuesto	
		of_precio_unitario (row)		
		//Asigno total
		dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
		dw_master.ii_update = 1

	case 'cantidad'
		dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
		dw_master.ii_update = 1

	case 'impuesto'
		of_precio_venta(row)
		dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
		dw_master.ii_update = 1

END CHOOSE

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;Long   		li_row
String 		ls_cod_igv,ls_signo,ls_cnta_cntbl,ls_flag_dh_cxp,ls_desc_cnta,ls_cod_art,&
				ls_item, ls_tipo_doc, ls_tipo_cred_fiscal,ls_flag_mercado,ls_centro_benef,&
				ls_origen, ls_null
Decimal {2} ldc_tasa_impuesto

SetNull(ls_null)
//origen de cabecera
ls_origen = dw_master.object.origen [1]

This.Object.nro_item			[al_row] = f_numera_item(this)

This.Object.flag_estado 	[al_row] = '1'

ls_tipo_doc	 = idw_doc_tipo.GetitemString(idw_doc_tipo.getrow(),'tipo_doc')

if ls_tipo_doc = is_doc_fac then
	This.Object.tipo_impuesto 	[al_row] = is_igv
	This.Object.tasa_impuesto 	[al_row] = idc_tasa_igv
else
	This.Object.tipo_impuesto 	[al_row] = ls_null
	This.Object.tasa_impuesto 	[al_row] = 0
end if

//Se Autogenerara Pre Asientos//
ib_estado_prea = TRUE   //Pre Asiento No editado					

//Obtengo el tipo de creditp fiscal de acuerdo al tipo
//de Documento
select Tipo_cred_fiscal	into :ls_tipo_cred_fiscal from doc_tipo
 where tipo_doc = :ls_tipo_doc;

This.object.tipo_cred_fiscal[al_row] = ls_tipo_cred_fiscal


end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event buttonclicked;call super::buttonclicked;String		ls_marcas, ls_desc

str_parametros sl_param

IF row  = 0 THEN RETURN

ls_desc 		= This.object.descripcion 	[row]
ls_marcas	= This.object.marcas 		[row]

CHOOSE CASE lower(dwo.name)
	CASE "b_marcas"
		// Para las marcas
		sl_param.string1   = 'Marcas de Factura '
		sl_param.string2	 = ls_marcas
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
				This.object.marcas [row] = sl_param.string3
		END IF
		
	CASE "b_desc"
		// Para la descripcion de la Factura
		sl_param.string1   = 'Descripcion de Factura '
		sl_param.string2	 = ls_desc
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
				This.object.descripcion [row] = sl_param.string3
		END IF
END CHOOSE		
end event

event ue_display;call super::ue_display;String 	ls_SQL, ls_codigo, ls_data, ls_nro_serie
boolean	lb_ret
str_parametros sl_param

CHOOSE CASE lower(as_columna)
	
	CASE 'cod_art'
	
		ls_codigo = this.object.servicio[al_row]
		
		if not IsNull(ls_codigo) and trim(ls_codigo) <> '' then
			MessageBox('Error', 'No puede elegir un artículo si ha seleccionado un servicio')
			return
		end if

		OpenWithParm (w_pop_articulos_stock, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		IF sl_param.titulo <> 'n' then
			if of_set_articulo( sl_param.field_ret[1], al_row) = 1 then
				this.object.cod_art			[al_row] = sl_param.field_ret[1]
				this.object.descripcion		[al_row] = sl_param.field_ret[2]
				this.object.und				[al_row] = sl_param.field_ret[3]
				this.object.numero_serie	[al_row] = sl_param.field_ret[4]
				this.object.almacen			[al_row] = sl_param.field_ret[5]
				
				ls_nro_serie = this.object.numero_serie	[al_row]
				
				if not IsNull(ls_nro_serie) and ls_nro_serie <> '' then
					this.object.cantidad				[al_row] = 1
					dw_master.object.importe_doc 	[dw_master.getRow()] = wf_totales( )
				end if
				this.ii_update = 1
			end if
		END IF

	case 'servicio'
		ls_codigo = this.object.cod_art[al_row]
		
		if not IsNull(ls_codigo) and trim(ls_codigo) <> '' then
			MessageBox('Error', 'No puede elegir un servicio si ha seleccionado un articulo')
			return
		end if
		
		ls_sql = "SELECT servicio AS codigo_servicio, " &
				 + "descripcion AS descripcion_servicio " &
				 + "FROM servicios " &
				 + "where flag_estado = '1'"
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
		if ls_codigo <> '' then
			this.object.servicio			[al_row] = ls_codigo
			this.object.descripcion		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case 'almacen'
		ls_sql = "SELECT almacen AS codigo_almacen, " &
				 + "desc_almacen AS descripcion_almacen " &
				 + "FROM almacen " &
				 + "where flag_estado = '1' " &
				 + "and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.ii_update = 1
		end if

END CHOOSE
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3611
integer height = 1172
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail_referencias dw_detail_referencias
end type

on tabpage_2.create
this.dw_detail_referencias=create dw_detail_referencias
this.Control[]={this.dw_detail_referencias}
end on

on tabpage_2.destroy
destroy(this.dw_detail_referencias)
end on

type dw_detail_referencias from u_dw_abc within tabpage_2
integer y = 12
integer width = 1518
integer height = 732
integer taborder = 20
string dataobject = "d_abc_doc_referencias_ctas_cob_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_rk[1] = 3				// columnas de lectrua de este dw
ii_rk[2] = 1				// columnas de lectrua de este dw
ii_rk[3] = 2				// columnas de lectrua de este dw


idw_mst = dw_master
idw_det = tab_1.tabpage_2.dw_detail_referencias 

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;ib_estado_prea = TRUE   //Pre Asiento No editado	
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_3 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 104
integer width = 3611
integer height = 1172
boolean enabled = false
long backcolor = 79741120
string text = "Impuestos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_5 cb_5
dw_det_imp dw_det_imp
end type

on tabpage_3.create
this.cb_5=create cb_5
this.dw_det_imp=create dw_det_imp
this.Control[]={this.cb_5,&
this.dw_det_imp}
end on

on tabpage_3.destroy
destroy(this.cb_5)
destroy(this.dw_det_imp)
end on

type cb_5 from commandbutton within tabpage_3
integer x = 2089
integer y = 20
integer width = 453
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Eliminar Impuesto"
end type

event clicked;long ll_row
ll_row = dw_det_imp.getrow()

if ll_row = 0 then
	messagebox('Aviso','Debe de seleccionar un Item de la Lista')
	return
end if

idw_1 = dw_det_imp

w_ve310_cnts_x_cobrar.event ue_delete()
end event

type dw_det_imp from u_dw_abc within tabpage_3
integer y = 12
integer width = 2075
integer height = 732
integer taborder = 20
string dataobject = "d_abc_cc_det_imp_tbl"
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master
ii_rk[2] = 2				// columnas que recibimos del master

idw_mst = dw_master 						  // dw_master
idw_det = idw_det_imp  // dw_detail


end event

event itemchanged;call super::itemchanged;
String  ls_expresion,ls_item,ls_timpuesto,ls_signo,ls_cnta_ctbl,ls_desc_cnta,&
		  ls_flag_dh_cxp
Long    ll_found
Decimal {3} ldc_tasa_impuesto 
Decimal {2} ldc_imp_total,ldc_total,ldc_redondeo

Accepttext()

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

CHOOSE CASE dwo.name
		 CASE	'importe'
				//Asigno total
				dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
				dw_master.ii_update = 1

		 CASE	'tipo_impuesto'
				ls_item = Trim(String(This.object.nro_item [row]))
				
				ls_expresion = 'item = ' + ls_item + ' and '+'tipo_impuesto = '+"'"+data+"'"
				ll_found 	 = This.find(ls_expresion ,1, This.rowcount())				

				IF Not(ll_found = row OR ll_found = 0 ) THEN
					Messagebox('Aviso','Nro de Item ya Tiene Considerado Tipo de Impuesto, Verifique!')
					SetNull(ls_timpuesto)
					This.Object.tipo_impuesto [row] = ls_timpuesto
					Return 1
				END IF
				
				ls_expresion = 'item = '+ls_item
				ll_found		 = tab_1.tabpage_1.dw_detail.find(ls_expresion,1,tab_1.tabpage_1.dw_detail.Rowcount())
				
				IF ll_found > 0 THEN
					ldc_imp_total = tab_1.tabpage_1.dw_detail.object.total           [ll_found]							
					ldc_redondeo  = tab_1.tabpage_1.dw_detail.object.redondeo_manual [ll_found]							
					IF Isnull(ldc_imp_total) THEN ldc_imp_total = 0.00
					IF Isnull(ldc_redondeo)  THEN ldc_redondeo  = 0.00
					ldc_imp_total = Round(ldc_imp_total - ldc_redondeo,2)
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
				
				//Asigno total
				dw_master.object.importe_doc [dw_master.getrow()] = wf_totales ()
				dw_master.ii_update = 1


END CHOOSE
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_currow,ll_item

ll_currow = tab_1.tabpage_1.dw_detail.GetRow()
ll_item 	 = tab_1.tabpage_1.dw_detail.Object.nro_item [ll_currow]

This.Object.nro_item [al_row] = ll_item

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_4 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 104
integer width = 3611
integer height = 1172
boolean enabled = false
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
integer y = 12
integer width = 3575
integer height = 732
integer taborder = 20
string dataobject = "d_tot_ctas_x_cobrar_ext_ff"
end type

event itemerror;call super::itemerror;Return 1
end event

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

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type tabpage_5 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 104
integer width = 3611
integer height = 1172
boolean enabled = false
long backcolor = 79741120
string text = "Asiento"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cnt_ctble_cab dw_cnt_ctble_cab
dw_cnt_ctble_det dw_cnt_ctble_det
end type

on tabpage_5.create
this.dw_cnt_ctble_cab=create dw_cnt_ctble_cab
this.dw_cnt_ctble_det=create dw_cnt_ctble_det
this.Control[]={this.dw_cnt_ctble_cab,&
this.dw_cnt_ctble_det}
end on

on tabpage_5.destroy
destroy(this.dw_cnt_ctble_cab)
destroy(this.dw_cnt_ctble_det)
end on

type dw_cnt_ctble_cab from u_dw_abc within tabpage_5
boolean visible = false
integer y = 624
integer width = 3593
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

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

idw_mst = tab_1.tabpage_5.dw_cnt_ctble_cab // dw_master
idw_det = tab_1.tabpage_5.dw_cnt_ctble_det // dw_detail
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.flag_tabla [al_row] = '1'
end event

type dw_cnt_ctble_det from u_dw_abc within tabpage_5
integer width = 3593
integer height = 608
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

idw_mst = tab_1.tabpage_5.dw_cnt_ctble_cab // dw_master
idw_det = tab_1.tabpage_5.dw_cnt_ctble_det // dw_detail

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.nro_item [al_row] = al_row

end event

event itemchanged;call super::itemchanged;Accepttext()
ib_estado_prea = FALSE


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
integer width = 3611
integer height = 1172
boolean enabled = false
long backcolor = 79741120
string text = "Exportacion"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_exportacion dw_exportacion
end type

on tabpage_6.create
this.dw_exportacion=create dw_exportacion
this.Control[]={this.dw_exportacion}
end on

on tabpage_6.destroy
destroy(this.dw_exportacion)
end on

type dw_exportacion from u_dw_abc within tabpage_6
event ue_display ( string as_columna,  long al_row )
integer y = 4
integer width = 2126
integer height = 748
integer taborder = 20
string dataobject = "d_ve_factura_exportacion_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
Long     ll_found
string 	ls_codigo, ls_data, ls_sql, ls_null 

Setnull(ls_null)

IF tab_1.tabpage_1.dw_detail.rowcount() = 0 THEN RETURN

CHOOSE CASE upper(as_columna)
		
	CASE "NRO_EMBARQUE"
		 
		ls_sql = "SELECT NRO_EMBARQUE AS EMBARQUE, " &
			    + "NAVE AS NAVES, " 	 &
				 + "INCOTERM AS INCOTERM, " &
				 + "FEC_ZARPE_ORG AS FEC_ZARPE_ORG " &
				 + "FROM EMBARQUE " &
				 + "WHERE NRO_OV = '" + is_orden_venta + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_embarque [al_row] = ls_codigo
		END IF
		
		This.ii_update = 1
	

END CHOOSE
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

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

event itemchanged;call super::itemchanged;string 	ls_flag, ls_data, ls_codigo, ls_null
Long		ll_count

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "NRO_EMBARQUE"
		SELECT  count(*)
		  INTO  :ll_count
		FROM EMBARQUE
		WHERE nro_embarque = :data
		  AND nro_ov = :is_orden_venta;
	
		IF ll_count = 0 THEN
			Messagebox('Aviso', "Embarque no existe", StopSign!)
			This.object.nro_embarque	[row] = ls_Null
			RETURN 1
		END IF

END CHOOSE
end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = gnvo_app.is_user
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_ve310_cnts_x_cobrar
integer x = 503
integer y = 244
integer width = 3003
integer height = 704
string dataobject = "d_abc_cntas_x_cobrar_cab_ff"
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1	// columnas de lectura de este dw
ii_ck[2] = 2  	// columnas de lectura de este dw
ii_dk[1] = 1   // columnas que se pasan al detalle
ii_dk[2] = 2	// columnas que se pasan al detalle
idw_mst  = dw_master 					 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.origen		      [al_row] = gnvo_app.is_origen
This.Object.cod_usr		      [al_row] = gnvo_app.is_user
This.Object.fecha_registro    [al_row] = today()
This.Object.fecha_documento   [al_row] = today()
This.Object.fecha_presentacion[al_row] = today()
This.Object.ano				   [al_row] = Long(String(today(),'YYYY'))
This.Object.mes			 	   [al_row] = Long(String(today(),'MM'))
This.Object.tasa_cambio		   [al_row] = f_tasa_cambio()
This.Object.flag_estado	      [al_row] = '1'
This.Object.ind_detrac	      [al_row] = '1'
This.Object.flag_detraccion   [al_row] = '0'
This.Object.flag_provisionado [al_row] = 'R'
This.Object.cod_empresa 		[al_row] = gnvo_app.invo_empresa.is_empresa
//** **//
end event

event itemchanged;call super::itemchanged;String ls_nom_proveedor  ,ls_forma_pago ,ls_cod_relacion,&
		 ls_dir_dep_estado ,ls_dir_distrito ,ls_dir_direccion,&
		 ls_ruc,ls_tipo_doc,ls_flag_detraccion,ls_nro_detraccion,&
		 ls_solicitud_credito, ls_nro_solicitud, ls_nom_vendedor, &
		 ls_null

Date   ld_fecha_documento,ld_fecha_vencimiento,ld_fecha_documento_old
Decimal{4} ldc_tasa_cambio
Integer    li_dias_venc,li_opcion, li_num_dir 
Long       ll_nro_libro,ll_count


ld_fecha_documento_old = Date(This.object.fecha_documento [row])

Accepttext()
SetNull(ls_null)

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

CHOOSE CASE dwo.name
		 CASE	'tipser'
				ll_nro_libro = idw_doc_tipo.Getitemnumber(idw_doc_tipo.getrow(),'nro_libro')
				ls_tipo_doc	 = idw_doc_tipo.GetitemString(idw_doc_tipo.getrow(),'tipo_doc')
				
				This.Object.nro_libro [row] = ll_nro_libro
				This.object.tipo_doc [row] = ls_tipo_doc
				
				
				
	CASE 'cod_relacion'
		IF tab_1.tabpage_2.dw_detail_referencias.rowcount() > 0 THEN
			Messagebox('Aviso','No puede	Cambiar El codigo del Cliente')
			This.Object.cod_relacion [1] = This.Object.cod_relacion_det [1]
			Return 1
		END IF
	
		SELECT prov.nom_proveedor,prov.ruc
		  INTO :ls_nom_proveedor,:ls_ruc
		  FROM proveedor prov
		 WHERE ((prov.proveedor   =  :data ) AND
				  (prov.flag_estado = '1'    )) ;
		
		IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
			Messagebox('Aviso','Proveedor No Existe o no esta activo')
			This.Object.cod_relacion [row] = ls_null
			This.Object.ruc			 [row] = ls_null
			This.Object.direccion	 [row] = ls_null
			Return 1
		end if
		
		
		This.Object.nom_proveedor[row] = ls_nom_proveedor
		This.Object.ruc			 [row] = ls_ruc
		This.Object.direccion	 [row] = of_getdireccion(data)
			
				
	   CASE 'cod_moneda'
				IF tab_1.tabpage_2.dw_detail_referencias.rowcount() > 0 THEN
					Messagebox('Aviso','No puede	Cambiar El Tipo de Moneda')
					This.Object.cod_moneda [1] = This.Object.moneda_det [1]
					Return 1
				END IF
				
	CASE 'fecha_documento'
		
		IF tab_1.tabpage_2.dw_detail_referencias.rowcount() > 0 THEN
			Messagebox('Aviso','No puede Cambiar la Fecha de Documento por que Cambiaria la Tasa de Cambio y tiene  Documentos de Referencia , Verifique!')
			This.Object.fecha_documento [1] = ld_fecha_documento_old
			Return 1
		END IF
		
		ls_forma_pago = This.Object.forma_pago [row]
		
		ld_fecha_documento   = Date(This.Object.fecha_documento   [row])	
		This.object.ano [row] = Long(String(ld_fecha_documento,'yyyy'))
		This.object.mes [row] = Long(String(ld_fecha_documento,'mm'))
		ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
		
		IF ld_fecha_documento > ld_fecha_vencimiento THEN
			This.Object.fecha_documento [row] = ld_fecha_documento_old
			Messagebox('Aviso','Fecha de Emisión del Documento No '&
									+'Puede Ser Mayor a la Fecha de Vencimiento')
			Return 1
		END IF
		
		
		This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_documento)
		
		IF Not(Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
			li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		
			IF li_dias_venc > 0 THEN
				li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
				IF li_opcion = 1 THEN
					ld_fecha_vencimiento = Relativedate(DATE(This.object.fecha_documento[row]),li_dias_venc)
					This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
				END IF
			END IF
		END IF
				
	CASE 'fecha_presentacion'
		ls_forma_pago = This.Object.forma_pago [row]
		
		
		IF Not(Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
			li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		
			IF li_dias_venc > 0 THEN
				li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
				IF li_opcion = 1 THEN
					ld_fecha_vencimiento = Relativedate(DATE(This.object.fecha_presentacion[row]),li_dias_venc)
					This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
				END IF
			END IF
		END IF
	
	CASE 'fecha_vencimiento'	
		ld_fecha_documento   = Date(This.Object.fecha_documento   [row])			
		ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
		
		IF ld_fecha_vencimiento < ld_fecha_documento THEN
			This.Object.fecha_vencimiento [row] = ld_fecha_documento
			Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
									+'Puede Ser Menor a la Fecha de Emisión')
			Return 1
		END IF
				
	CASE 'forma_pago'
			   
		li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		IF li_dias_venc > 0 THEN
			
			li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
			IF li_opcion = 1 THEN
				ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_presentacion[row]),li_dias_venc)
				This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
			END IF
		ELSE
			This.Object.fecha_vencimiento [row] = This.object.fecha_presentacion[row]
		END IF
				
	CASE 'flag_detraccion'
			
		if data = '0' then
		  Setnull(ls_nro_detraccion)
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
			  
	CASE 'vendedor'
			
		select u.nombre
		  into :ls_nom_vendedor
		  from usuario u
		 where u.cod_usr = :data;
		
		if SQLCA.sqlcode = 100 then
			messagebox('Aviso','Codigo de Vendedor no existe, Verifique!')
			this.object.vendedor			[row] = ls_null
			this.object.nom_vendedor	[row] = ls_null
			return 1
		end if
				
		this.object.nom_vendedor	[row] = ls_nom_vendedor
				
END CHOOSE



end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     	ls_name ,ls_prot ,ls_cod_relacion ,ls_distrito ,ls_estado, &
				ls_direccion, ls_vendedor, ls_ruc, ls_sql, ls_data, ls_codigo
Date       	ld_fecha_documento,ld_fecha_vencimiento 
boolean		lb_ret
Decimal{4} 	ldc_tasa_cambio
str_seleccionar lstr_seleccionar
str_parametros   sl_param
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
	CASE 'direccion'
			
		ls_cod_relacion = dw_master.object.cod_relacion [row]		
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
			Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
			Return 1
		END IF
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT DIRECCIONES.item             AS ITEM,'&        
												 +'DIRECCIONES.DIR_PAIS         AS PAIS,'&     
												 +'DIRECCIONES.DIR_DEP_ESTADO   AS DEPARTAMENTO,'&
												 +'DIRECCIONES.DIR_DISTRITO     AS DISTRITO,'&
												 +'DIRECCIONES.DIR_URBANIZACION AS URBANIZACION,'&
												 +'DIRECCIONES.DIR_DIRECCION    AS DIRECCION,'&
												 +'DIRECCIONES.DIR_MNZ          AS MANZANA,'&
												 +'DIRECCIONES.DIR_LOTE         AS LOTE,'&
												 +'DIRECCIONES.DIR_NUMERO       AS NUMERO,'&
												 +'DIRECCIONES.DESCRIPCION      AS DESCRIPCION '&
												 +'FROM DIRECCIONES '&
												 +"WHERE DIRECCIONES.CODIGO = '"+ls_cod_relacion+"' AND "&
												 +"	   DIRECCIONES.FLAG_USO = '1'"		
													
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			This.Object.item_direccion [row] = Integer(lstr_seleccionar.paramdc1[1])
			ls_estado	 = lstr_seleccionar.param3[1]
			ls_distrito  = lstr_seleccionar.param4[1]					
			ls_direccion = lstr_seleccionar.param6[1]
		
			IF Isnull(ls_estado)    THEN ls_estado 	= ''
			IF Isnull(ls_distrito)  THEN ls_distrito 	= ''					
			IF Isnull(ls_direccion) THEN ls_direccion	= ''		
		
			This.Object.direccion [row] = ls_estado+' '+ls_distrito+' '+ls_direccion
			ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF
															
						  
	CASE 'cod_relacion'
			IF idw_detail.rowcount() > 0 THEN
				Messagebox('Aviso','No puede	Cambiar El codigo del Cliente')
				Return
			END IF
			
			ls_sql  = "SELECT P.PROVEEDOR AS CODIGO_CLIENTE, "&
					  + "P.NOM_PROVEEDOR AS NOMBRES, "&
					  + "P.RUC AS R_U_C, "&
					  + "P.EMAIL AS EMAIL "&
					  + "FROM PROVEEDOR P " &
					  + "WHERE P.FLAG_ESTADO = '1' " &
					  + "AND flag_clie_prov in ('0', '2') "
						 
			lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
				
			if ls_codigo <> '' then
				this.object.cod_relacion	[row] = ls_codigo
				this.object.nom_cliente		[row] = ls_data
				this.object.ruc				[row] = ls_ruc
				this.object.direccion		[row] = of_getdireccion(ls_codigo)
				this.ii_update = 1
			end if
			
	
	CASE  'fecha_documento'
			
		IF tab_1.tabpage_2.dw_detail_referencias.rowcount() > 0 THEN
			Messagebox('Aviso','No puede Cambiar la Fecha de Documento por que Cambiaria la Tasa de Cambio y tiene  Documentos de Referencia , Verifique!')
			Return 
		END IF
		
		ld_fecha_documento = Date(This.Object.fecha_documento [row])				
		ldw = This
		f_call_calendar(ldw,dwo.name,dwo.coltype, row)
		IF ld_fecha_documento <> Date(This.Object.fecha_documento [row]) THEN
			ld_fecha_documento   = Date(This.Object.fecha_documento [row])				
			ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
			
			IF ld_fecha_documento > ld_fecha_vencimiento THEN
				This.Object.fecha_documento [row] = ld_fecha_vencimiento
				Messagebox('Aviso','Fecha de Emisión del Documento No '&
										+'Puede Ser Mayor a la Fecha de Vencimiento')
			END IF
			
			ld_fecha_documento = Date(This.Object.fecha_documento [row])		
			
			This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_documento)	
			
			This.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF
				
	CASE	'fecha_vencimiento'		
		ld_fecha_vencimiento = Date(This.Object.fecha_vencimiento [row])				
		ldw = This
		f_call_calendar(ldw,dwo.name,dwo.coltype, row)
		IF ld_fecha_vencimiento <> Date(This.Object.fecha_vencimiento [row])	THEN
			ld_fecha_documento   = Date(This.Object.fecha_documento   [row])			
			ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
		
			IF ld_fecha_vencimiento < ld_fecha_documento THEN
				This.Object.fecha_vencimiento [row] = ld_fecha_documento
				Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
										+'Puede Ser Menor a la Fecha de Emisión')
			END IF					
			This.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF
				
	CASE 'vendedor'
		ls_sql = "SELECT cod_usr AS codigo_usuario, " &
				 + "nombre AS nombre_usuario " &
				 + "FROM usuario " &
				 + "where flag_estado = '1'"
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
		if ls_codigo <> '' then
			this.object.vendedor			[row] = ls_codigo
			this.object.nom_vendedor	[row] = ls_data
			this.ii_update = 1
		end if
			
			
END CHOOSE



end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event buttonclicked;call super::buttonclicked;string 	ls_nom_cliente, ls_ruc, ls_origen = 'XX', ls_mensaje, ls_null, ls_nro, ls_ceros
Long		ll_ult_nro, ll_count

if lower(dwo.name) = "b_new_cliente" then
	ls_nom_cliente = this.object.nom_cliente 	[row]
	ls_ruc 			= this.object.ruc 			[row]
	
	//Verifico que no existe el codigo de relacion
	select count(*)
	  into :ll_count
	  from proveedor
	 where ruc = :ls_ruc;
	
	if ll_count > 0 then
		MessageBox('Error', 'El RUC ya esta registrado en otro cliente, por favor verifique')
		return
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_proveedor 
	where origen = :ls_origen for update;	
	
	if SQLCA.SQLCode = 100 then

		insert into num_proveedor( origen, ult_nro)
		values( :ls_origen, 1);
		
		IF SQLCA.SQLCODE <> 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MESSAGEBOX( 'ERROR', ' No se puede insertar registro en NUM_PROVEEDOR: ' &
				+ ls_mensaje)
			return 
		END IF
		
		ll_ult_nro = 1
		
	end if

	ls_nro = 'E' + String(ll_ult_nro, '0000000')

	// Incrementa contador	
	Update num_proveedor 
		set ult_nro = ult_nro + 1 
	where origen = :ls_origen;
	
	insert into proveedor(
		proveedor, nom_proveedor, ruc, tipo_proveedor, flag_clie_prov, flag_personeria, tipo_doc_ident, cod_usr)
	values(
		:ls_nro, :ls_nom_cliente, :ls_ruc, '01', '1', 'J', '6', :gnvo_app.is_user);
			
	IF SQLCA.SQLCODE <> 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MESSAGEBOX( 'ERROR', ' No se puede insertar nuevo proveedor: ' &
			+ ls_mensaje)
		return 
	END IF
	
	// Asigna numero a cabecera
	this.object.cod_relacion[dw_master.getrow()] = ls_nro
	this.ii_update = 1
	
	
elseif lower(dwo.name) = "b_limpiar" then
	SetNull(ls_null)
	
	if MessageBox('Aviso', 'Desea quitar la referencia de la GUIA DE REMISION de este comprobante', &
			Information!, Yesno!, 2) = 2 then return
			
	
	this.object.nro_guia[row] = ls_null
	this.ii_update = 1

end if
end event

type gb_1 from groupbox within w_ve310_cnts_x_cobrar
integer x = 3534
integer y = 248
integer width = 667
integer height = 384
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
string text = "Referencias"
end type

type cb_salidas from commandbutton within w_ve310_cnts_x_cobrar
integer x = 3598
integer y = 316
integer width = 562
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string text = "Salidas Almacén"
end type

event clicked;String  ls_cod_cliente,ls_cod_moneda,ls_flag_estado,ls_expresion,ls_result,ls_mensaje
Long    ll_row_master,ll_ano,ll_mes
Decimal {4} ldc_tasa_cambio 
str_parametros sl_param


ll_row_master = dw_master.getrow()
IF ll_row_master = 0 THEN RETURN
ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_cod_cliente  = dw_master.object.cod_relacion [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda   [ll_row_master]
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row_master] 
ll_ano			 = dw_master.object.ano 			[ll_row_master]
ll_mes			 = dw_master.object.mes 			[ll_row_master]

if ISNull(dw_master.object.tipser[ll_row_master]) or dw_master.object.tipser[ll_row_master] = '' then
	Messagebox('Aviso','Debe Seleccionar un tipo de Documento x Cobrar')
	return
end if

/*verifica cierre*/
if_asiento_contable.uf_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje)


IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN

IF Isnull(ls_cod_cliente) OR Trim(ls_cod_cliente) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Cliente')
	RETURN
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	RETURN
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	RETURN
END IF


ls_expresion = 'Isnull(cod_art)'
tab_1.tabpage_1.dw_detail.Setfilter(ls_expresion)
tab_1.tabpage_1.dw_detail.filter()
IF tab_1.tabpage_1.dw_detail.Rowcount() > 0 THEN 
	Messagebox('Aviso','Si Ingresa Servicios No Puede tomar en cuenta Guias de Remision') 
	RETURN
END IF
tab_1.tabpage_1.dw_detail.Setfilter('')
tab_1.tabpage_1.dw_detail.filter()


IF tab_1.tabpage_2.dw_detail_referencias.rowcount() > 0 THEN
	
	IF Not(Isnull(is_orden_venta) OR Trim(is_orden_venta) = '') THEN
		Messagebox('Aviso','Ha Seleccionado Guia de Remision referenciados a Orden de Venta , Verifique!')
		RETURN
	END IF
END IF



sl_param.titulo	= 'Guias Pendientes'
sl_param.opcion   = 11
sl_param.dw1		= 'd_abc_guia_vales_tbl'
sl_param.string1	= '1GR'
sl_param.string2	= ls_cod_cliente
sl_param.string3	= ls_cod_moneda
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1GR'
sl_param.dw_m		= dw_master
sl_param.dw_d		= tab_1.tabpage_1.dw_detail
sl_param.dw_c		= tab_1.tabpage_2.dw_detail_referencias
sl_param.db1 		= 1600



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type gb_3 from groupbox within w_ve310_cnts_x_cobrar
integer x = 3538
integer y = 640
integer width = 667
integer height = 188
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Impresión"
end type

