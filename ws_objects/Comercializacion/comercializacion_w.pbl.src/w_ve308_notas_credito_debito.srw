$PBExportHeader$w_ve308_notas_credito_debito.srw
forward
global type w_ve308_notas_credito_debito from w_abc
end type
type cb_referencias from commandbutton within w_ve308_notas_credito_debito
end type
type tab_1 from tab within w_ve308_notas_credito_debito
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail_nv from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail_nv dw_detail_nv
end type
type tabpage_2 from userobject within tab_1
end type
type dw_det_imp from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_det_imp dw_det_imp
end type
type tabpage_3 from userobject within tab_1
end type
type dw_cnt_ctble_cab from u_dw_abc within tabpage_3
end type
type dw_cnt_ctble_det from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_cnt_ctble_cab dw_cnt_ctble_cab
dw_cnt_ctble_det dw_cnt_ctble_det
end type
type tab_1 from tab within w_ve308_notas_credito_debito
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_master from u_dw_abc within w_ve308_notas_credito_debito
end type
end forward

global type w_ve308_notas_credito_debito from w_abc
integer width = 4489
integer height = 2648
string title = "[VE308] Notas de Credito / Debito x Cobrar "
string menuname = "m_mantenimiento_cl_anular_ext"
event ue_find_exact ( )
event ue_anular ( )
event ue_anul_trans ( )
event ue_print_voucher ( )
cb_referencias cb_referencias
tab_1 tab_1
dw_master dw_master
end type
global w_ve308_notas_credito_debito w_ve308_notas_credito_debito

type variables
u_ds_base       ids_voucher
DatawindowChild idw_tasa
Boolean 			 ib_estado_prea = FALSE
        			 //Pre Asiento No editado	
				
n_cst_asiento_contable 	invo_asiento_cntbl
n_cst_contabilidad 		invo_cntbl
u_dw_abc						idw_detail, idw_asiento_cab, idw_asiento_det, idw_impuestos
end variables

forward prototypes
public subroutine wf_generacion_imp (String as_item)
public function string wf_verifica_user ()
public function string wf_verificacion_user ()
public function decimal wf_totales ()
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc)
public function boolean of_nro_doc (string as_tipo_doc, string as_nro_serie)
public function boolean of_generacion_asiento_cntbl ()
public function boolean of_verifica_cnta_cntbl (string as_cnta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
end prototypes

event ue_find_exact();// Asigna valores a structura 
String ls_tipo_doc,ls_nro_doc,ls_origen,ls_cod_relacion,ls_nota_deb,&
		 ls_motivo,ls_tip_doc_filtro
Long   ll_row_master,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,&
		 ll_inicio
str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_ctas_x_cobrar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 1
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	/**Motivos***/
	SELECT nota_debito
     INTO :ls_nota_deb
     FROM finparam
	 WHERE (reckey = '1') ;
	 
	/*****/
	ll_row_master = dw_master.getrow()
	ls_tipo_doc  	 = dw_master.object.tipo_doc		[ll_row_master]
	ls_nro_doc   	 = dw_master.object.nro_doc		[ll_row_master]
	ls_origen	 	 = dw_master.object.origen			[ll_row_master] 
	ll_ano		 	 = dw_master.object.ano          [ll_row_master]
	ll_mes		 	 = dw_master.object.mes          [ll_row_master]
	ll_nro_libro 	 = dw_master.object.nro_libro    [ll_row_master]
	ll_nro_asiento  = dw_master.object.nro_asiento  [ll_row_master]
	ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
	ls_motivo		 = dw_master.object.motivo			[ll_row_master]

	tab_1.tabpage_1.dw_detail_nv.Retrieve(ls_tipo_doc,ls_nro_doc)
	tab_1.tabpage_2.dw_det_imp.Retrieve(ls_tipo_doc,ls_nro_doc)
	tab_1.tabpage_3.dw_cnt_ctble_cab.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)
	tab_1.tabpage_3.dw_cnt_ctble_det.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)

	/*Detalle*/
	FOR ll_inicio = 1 to tab_1.tabpage_1.dw_detail_nv.Rowcount()
		 /*Casos por motivos de nota*/
		 CHOOSE CASE ls_motivo
				  CASE 'NDC001','NCC001' //4
						 tab_1.tabpage_1.dw_detail_nv.Object.flag_rev	 [ll_inicio] = 'AJ'
				  CASE 'NDC002','NCC002' //5
				  CASE 'NDC003'			 //6
						 tab_1.tabpage_1.dw_detail_nv.Object.flag_aj  [ll_inicio] = 'INT' //INTERES
						 tab_1.tabpage_1.dw_detail_nv.Object.flag_rev [ll_inicio] = 'INT'
				  CASE 'NCC003'			 //7
						 tab_1.tabpage_1.dw_detail_nv.Object.flag_aj  [ll_inicio] = 'DES'
						 tab_1.tabpage_1.dw_detail_nv.Object.flag_rev [ll_inicio] = 'DES'
		 END CHOOSE
	NEXT

	/*Impuesto*/
	FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_det_imp.Rowcount()
		 /*Casos por motivos de nota*/
		 CHOOSE CASE ls_motivo
				  CASE 'NDC001','NCC001' //4
						 tab_1.tabpage_2.dw_det_imp.Object.flag_imp	[ll_inicio] = 'AJ'
				  CASE 'NDC002','NCC002' //5
				  CASE 'NDC003'			 //6
						 tab_1.tabpage_2.dw_det_imp.Object.flag_tipo [ll_inicio] = 'INT' //Interes
						 tab_1.tabpage_2.dw_det_imp.Object.flag_imp  [ll_inicio] = 'INT'
				  CASE 'NCC003'			 //7
						 tab_1.tabpage_2.dw_det_imp.Object.flag_tipo [ll_inicio] = 'DES' //Descuento
						 tab_1.tabpage_2.dw_det_imp.Object.flag_imp  [ll_inicio] = 'DES'
		 END CHOOSE
			 
	NEXT

	ib_estado_prea = False   //pre-asiento editado					
	TriggerEvent('ue_modify')
	is_Action = 'fileopen'	
ELSE
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail_nv.Reset()
	tab_1.tabpage_2.dw_det_imp.Reset()
	tab_1.tabpage_3.dw_cnt_ctble_cab.Reset()
	tab_1.tabpage_3.dw_cnt_ctble_det.Reset()
	ib_estado_prea = False   //asiento editado					

END IF



	
	
	
	
	
	
	
	
	



end event

event ue_anular;String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc,ls_result,ls_mensaje
Long    ll_row,ll_row_pasiento,ll_inicio,ll_count,ll_ano,ll_mes
Integer li_opcion

dw_master.Accepttext()
idw_detail.Accepttext()
idw_impuestos.Accepttext()
idw_asiento_cab.Accepttext()
idw_asiento_det.Accepttext()
	
ll_row 			 = dw_master.Getrow()

IF ll_row = 0 then return

IF dw_master.ii_update 			= 1 OR &
	idw_detail.ii_update 		= 1 OR &
   idw_impuestos.ii_update 	= 1 OR &
	idw_asiento_cab.ii_update 	= 1 OR &
	idw_asiento_det.ii_update 	= 1 or &
	is_Action						= 'new' THEN
	 
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento', StopSign!)
	 RETURN
	 
END IF

ls_flag_estado = dw_master.object.flag_estado	[ll_row]
ll_ano			= dw_master.object.ano 			 	[ll_row]
ll_mes			= dw_master.object.mes 			 	[ll_row]
ls_origen   	= dw_master.object.origen   		[ll_row]
ls_tipo_doc 	= dw_master.object.tipo_doc 		[ll_row]
ls_nro_doc  	= dw_master.object.nro_doc  		[ll_row]
	
/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) then return

//Documento Ha sido Anulado
IF ls_flag_estado <> '1' THEN 
	MessageBox('Error', 'El comprobante no se encuentra activo, no es posible ANULARLO',StopSign!)
	RETURN 
end if

li_opcion = MessageBox('Anula Documento x Cobrar','Esta Seguro de Anular el comprobante ' + ls_tipo_doc + '/' + ls_nro_doc,Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN



/*Verifica Si ha tenido Transaciones*/
SELECT Count(*)
  INTO :ll_count
  FROM doc_referencias
 WHERE (origen_ref = :ls_origen   ) AND
 		 (tipo_ref   = :ls_tipo_doc ) AND
		 (nro_ref	 = :ls_nro_doc  ) ;
/**/
IF ll_count > 0 THEN
	Messagebox('Aviso','Documento esta como referencia a otro comprobante, no se puede anular, por favor Verifique!')
   Return
END IF



FOR ll_inicio = 1 TO idw_detail.Rowcount()
    idw_detail.object.cantidad		  	[ll_inicio] = 0.00
	 idw_detail.object.precio_unitario 	[ll_inicio] = 0.00
	 idw_detail.object.descuento		  	[ll_inicio] = 0.00
	 idw_detail.object.redondeo_manual 	[ll_inicio] = 0.00
	 idw_detail.ii_update = 1
NEXT



FOR ll_inicio = 1 TO idw_impuestos.Rowcount()
    idw_impuestos.object.importe		   [ll_inicio] = 0.00
	 idw_impuestos.ii_update = 1
NEXT

//Anulo la cabecera del asiento
idw_asiento_cab.object.flag_estado	[1] = '0'
idw_asiento_cab.object.tot_soldeb	[1] = 0.00
idw_asiento_cab.object.tot_solhab	[1] = 0.00
idw_asiento_cab.object.tot_doldeb	[1] = 0.00
idw_asiento_cab.object.tot_dolhab	[1] = 0.00

//Anulo el detalle del asiento contable
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
	 idw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 idw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT

dw_master.object.flag_estado	[1] = '0'  // Anulado
dw_master.object.importe_doc	[1] = 0.00 // Anulado
dw_master.object.saldo_sol  	[1] = 0.00 // Anulado
dw_master.object.saldo_dol  	[1] = 0.00 // Anulado


is_Action 						= 'delete'
dw_master.ii_update 			= 1
idw_detail.ii_update 		= 1
idw_impuestos.ii_update 	= 1
idw_asiento_cab.ii_update 	= 1
idw_asiento_det.ii_update 	= 1

ib_estado_prea = FALSE

end event

event ue_anul_trans();String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc,ls_mensaje,ls_result
Long    ll_row,ll_count,ll_inicio,ll_ano,ll_mes
Integer li_opcion

dw_master.Accepttext()
idw_detail.Accepttext()
idw_impuestos.Accepttext()
idw_asiento_cab.Accepttext()
idw_asiento_det.Accepttext()
	
ll_row 			 = dw_master.Getrow()

IF ll_row = 0 then return

IF dw_master.ii_update 			= 1 OR &
	idw_detail.ii_update 		= 1 OR &
   idw_impuestos.ii_update 	= 1 OR &
	idw_asiento_cab.ii_update 	= 1 OR &
	idw_asiento_det.ii_update 	= 1 or &
	is_Action						= 'new' THEN
	 
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento', StopSign!)
	 RETURN
	 
END IF

ls_flag_estado = dw_master.object.flag_estado 	[ll_row]
ll_ano			= dw_master.object.ano 			 	[ll_row]
ll_mes			= dw_master.object.mes 			 	[ll_row]
ls_origen   	= dw_master.object.origen   		[ll_row]
ls_tipo_doc 	= dw_master.object.tipo_doc 		[ll_row]
ls_nro_doc  	= dw_master.object.nro_doc  		[ll_row]


/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) then return


IF Not(ls_flag_estado = '1' OR ls_flag_estado = '0') THEN RETURN 

li_opcion = MessageBox('Anula Documento x Cobrar','Esta Seguro de Anular el comprobante ' + ls_tipo_doc + '/' + ls_nro_doc,Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN //no desea anular transacion



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

/*Elimino Cabecera de Cntas x Cobrar*/
DO WHILE dw_master.Rowcount() > 0
	dw_master.Deleterow(0)
	dw_master.ii_update = 1
LOOP

/*Elimino detalle de Cntas x cobrar*/
DO WHILE idw_detail.Rowcount() > 0
	idw_detail.Deleterow(0)
	idw_detail.ii_update = 1
LOOP

/*Elimino Impuesto de Cntas Cobrar*/
DO WHILE idw_impuestos.Rowcount() > 0
	idw_impuestos.Deleterow(0)
	idw_impuestos.ii_update = 1
LOOP


//Cabecera de Asiento
idw_asiento_cab.Object.flag_estado 	[1] = '0'
idw_asiento_cab.Object.tot_solhab	[1] = 0.00
idw_asiento_cab.Object.tot_dolhab	[1] = 0.00
idw_asiento_cab.Object.tot_soldeb	[1] = 0.00
idw_asiento_cab.Object.tot_doldeb  	[1] = 0.00
idw_asiento_cab.ii_update = 1

//Detalle de Asiento
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
  	idw_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
  	idw_asiento_det.Object.imp_movdol [ll_inicio] = 0.00		
	idw_asiento_det.ii_update = 1
NEXT


//
is_Action 						= 'anular'
dw_master.ii_update 			= 1
idw_detail.ii_update 		= 1
idw_impuestos.ii_update 	= 1
idw_asiento_cab.ii_update 	= 1
idw_asiento_det.ii_update 	= 1
ib_estado_prea = FALSE //no autogeneracion de asientos

idw_asiento_det.ii_protect = 0
idw_asiento_det.of_protect()
end event

event ue_print_voucher();String 				ls_origen
Long   				ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros		lstr_param

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

//Solicita si es impresión directa o previsualización
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
		ids_voucher.object.t_titulo1.text = "Provisión de Cuentas x Cobrar"
		ids_voucher.object.t_titulo1.visible = '1'
	end if	

	ids_voucher.Print(True)
else
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cc_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.integer1 	= ll_ano
	lstr_param.integer2 	= ll_mes
	lstr_param.integer3 	= ll_nro_libro
	lstr_param.integer4 	= ll_nro_asiento
	lstr_param.string2	= gs_empresa
	lstr_param.titulo		= "Provisión de Cuentas x Cobrar"
	lstr_param.tipo		= '1S1I2I3I4I2S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if



end event

public subroutine wf_generacion_imp (String as_item);String      ls_item,ls_expresion
Long 			ll_inicio,ll_found
Decimal {2} ldc_total,ldc_tasa_impuesto


ls_expresion = 'item = '+as_item

tab_1.tabpage_2.dw_det_imp.Setfilter(ls_expresion)
tab_1.tabpage_2.dw_det_imp.filter()
Setnull(ls_expresion)
	
FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_det_imp.Rowcount()
	 tab_1.tabpage_2.dw_det_imp.ii_update = 1
	 ls_item		  = Trim(String(tab_1.tabpage_2.dw_det_imp.object.item [ll_inicio]))
	 ls_expresion = 'item = ' + ls_item
	 ll_found 	  = tab_1.tabpage_1.dw_detail_nv.find(ls_expresion ,1,tab_1.tabpage_1.dw_detail_nv.rowcount())
	 IF ll_found > 0 THEN
		 ldc_tasa_impuesto = tab_1.tabpage_2.dw_det_imp.object.tasa_impuesto [ll_inicio]
		 ldc_total			 = tab_1.tabpage_1.dw_detail_nv.object.total		   [ll_found]
		 tab_1.tabpage_2.dw_det_imp.object.importe [ll_inicio] = Round((ldc_total * ldc_tasa_impuesto ) / 100 ,2)
	 END IF			 
NEXT
	
tab_1.tabpage_2.dw_det_imp.Setfilter('')
tab_1.tabpage_2.dw_det_imp.filter()


tab_1.tabpage_2.dw_det_imp.SetSort('item a')
tab_1.tabpage_2.dw_det_imp.Sort()


end subroutine

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
 WHERE (cod_usr = :gs_user) ;

 IF ll_count = 0 THEN
	 ls_mensaje = 'Usuario No Ha Sido definido en tipo de Documento a Visualizar'
	Return ls_mensaje	 	
 END IF
 
/**/
SELECT Count(*)
  INTO :ll_count
  FROM doc_grupo_relacion
 WHERE (doc_grupo_relacion.tipo_doc = (SELECT tipo_doc FROM doc_tipo_usuario  WHERE cod_usr = :gs_user )) ;


 IF ll_count = 0 THEN
	 ls_mensaje = 'Tipos de Documentos del Usuario No tiene Relacion en Archivo DOC_GRUPO_RELACION'
	 Return ls_mensaje	 	
 END IF
 
 
 Return ls_mensaje

  
         

end function

public function string wf_verificacion_user ();String  ls_mensaje,ls_doc_ntvnt
Long    ll_count
Boolean lb_retorno = TRUE

/*Grupo de Documento de Nota de venta*/
SELECT doc_ntvnt
  INTO :ls_doc_ntvnt
  FROM finparam
 WHERE (reckey = '1') ;
 
IF Isnull(ls_doc_ntvnt) OR Trim(ls_doc_ntvnt) = '' THEN
	ls_mensaje = 'Debe Ingresar Un Grupo de Documento para Nota de Venta'
END IF


SELECT Count(*)  
  INTO :ll_count
  FROM doc_grupo_relacion dgr,   
       doc_tipo_usuario   dtu,   
       finparam			  fpm,   
       doc_tipo			  dt	
 WHERE (dgr.tipo_doc  = dtu.tipo_doc ) AND
       (dtu.tipo_doc  = dt.tipo_doc  ) AND  
       (fpm.doc_ntvnt = dgr.grupo    ) AND
       (fpm.reckey    = '1' 			 ) AND
       (dtu.cod_usr   = :gs_user 	 ) ;   


IF ll_count = 0 THEN
	ls_mensaje = 'No Han Considerado Usuarios o Documentos en grupo de Doc. de Not. de Venta (Finparam NTVNT), Verifique!'
END IF




Return ls_mensaje
end function

public function decimal wf_totales ();Long 	  ll_inicio
String  ls_signo,ls_motivo
Decimal {2} ldc_impuesto        = 0.00, ldc_total_imp     = 0.00 ,ldc_bruto = 0.00 , &
		      ldc_total_bruto     = 0.00, ldc_total_general = 0.00


//tab_1.tabpage_4.dw_totales.Reset()
//tab_1.tabpage_4.dw_totales.Insertrow(0)
dw_master.accepttext()
ls_motivo = dw_master.object.motivo [dw_master.Getrow()]


FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail_nv.Rowcount()
	 IF ls_motivo = 'NDC002' OR ls_motivo = 'NCC002' THEN
		 ldc_bruto 		= Round(tab_1.tabpage_1.dw_detail_nv.object.cantidad[ll_inicio] * tab_1.tabpage_1.dw_detail_nv.object.precio_unitario[ll_inicio],2)
	 ELSE
		 ldc_bruto 		= Round(tab_1.tabpage_1.dw_detail_nv.object.total [ll_inicio],2)
	 END IF


	 
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
	 
NEXT


FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_det_imp.Rowcount()
	
	 ldc_impuesto = tab_1.tabpage_2.dw_det_imp.Object.importe [ll_inicio]
	 ls_signo	  = tab_1.tabpage_2.dw_det_imp.Object.signo   [ll_inicio]	
	 
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
	 IF     ls_signo = '+' THEN
		 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT


//tab_1.tabpage_4.dw_totales.object.bruto 	 [1] = ldc_total_bruto
//tab_1.tabpage_4.dw_totales.object.impuesto [1] = ldc_total_imp


ldc_total_general = ldc_total_bruto + ldc_total_imp




Return ldc_total_general

end function

public subroutine of_asigna_dws ();idw_detail 			= tab_1.tabpage_1.dw_detail_nv
idw_impuestos 		= tab_1.tabpage_2.dw_det_imp
idw_asiento_cab 	= tab_1.tabpage_3.dw_cnt_ctble_cab
idw_asiento_det	= tab_1.tabpage_3.dw_cnt_ctble_det

end subroutine

public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc);String 	ls_motivo, ls_tip_doc, ls_origen
Long		ll_inicio, ll_year, ll_mes, ll_nro_libro, ll_nro_Asiento



//Habilito los botones 
if gnvo_app.ventas.is_flag_efact = '1' then
	
	dw_master.object.b_envio_efact.visible = "Yes"
	dw_master.object.b_download.Visible = "Yes"
	
else

	dw_master.object.b_envio_efact.visible = "No"
	dw_master.object.b_download.Visible = "No"

end if

dw_master.Retrieve(as_tipo_doc, as_nro_doc)

if dw_master.RowCount() > 0 then

	if dw_master.object.flag_estado [1] = '0' or (left(dw_master.object.nro_doc [1],1) <> 'F' and left(dw_master.object.nro_doc [1],1) <> 'B') then
		dw_master.object.b_envio_efact.Enabled = "No"
		dw_master.object.b_download.Enabled 	= "No"
	else
	
		if dw_master.object.flag_enviar_efact [1] = '1' then
			
			dw_master.object.b_envio_efact.Enabled = "No"
			dw_master.object.b_download.Enabled = "Yes"
		else
			dw_master.object.b_envio_efact.Enabled = "Yes"
			dw_master.object.b_download.Enabled = "No"
		end if
		
		if dw_master.object.flag_data_xml [1] = '1' or &
			dw_master.object.flag_data_cdr [1] = '1' or &
			dw_master.object.flag_data_pdf [1] = '1' then
		
			dw_master.object.b_download.Enabled = "Yes"
			
		else
			dw_master.object.b_download.Enabled = "No"
		end if
		
	end if

	
	idw_detail.Retrieve(as_tipo_doc, as_nro_doc)
	idw_impuestos.Retrieve(as_tipo_doc, as_nro_doc)
	
	ls_origen		= dw_master.object.origen			[dw_master.getRow()]
	ll_year 			= dw_master.object.ano				[dw_master.getRow()]
	ll_mes 			= dw_master.object.mes				[dw_master.getRow()]
	ll_nro_libro 	= dw_master.object.nro_libro		[dw_master.getRow()]
	ll_nro_Asiento = dw_master.object.nro_asiento	[dw_master.getRow()]
	
	idw_asiento_cab.Retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)
	idw_asiento_det.Retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)
	
	ls_motivo = dw_master.object.motivo [1]
	
	if idw_asiento_cab.RowCount() > 0 then 
		idw_asiento_cab.il_row = 1
	end if
	
	
else
	idw_detail.Reset()
	idw_impuestos.Reset()
	idw_asiento_cab.Reset()
	idw_asiento_det.Reset()
end if




/*Detalle*/
FOR ll_inicio = 1 to idw_detail.Rowcount()
	 /*Casos por motivos de nota*/
	 CHOOSE CASE ls_motivo
			  CASE 'NDC01','NCC01' //4
					 idw_detail.Object.flag_rev	[ll_inicio] = 'AJ'
			  CASE 'NDC02','NCC02' //5
			  CASE 'NDC03'			 //6
					 idw_detail.Object.flag_aj  	[ll_inicio] = 'INT' //INTERES
					 idw_detail.Object.flag_rev 	[ll_inicio] = 'INT'
			  CASE 'NCC03'			 //7
					 idw_detail.Object.flag_aj  	[ll_inicio] = 'DES'
					 idw_detail.Object.flag_rev 	[ll_inicio] = 'DES'
	 END CHOOSE
NEXT

/*Impuesto*/
FOR ll_inicio = 1 TO idw_impuestos.Rowcount()
	 /*Casos por motivos de nota*/
	 CHOOSE CASE ls_motivo
			  CASE 'NDC01','NCC01' //4
					 idw_impuestos.Object.flag_imp	[ll_inicio] = 'AJ'
			  CASE 'NDC02','NCC02' //5
			  CASE 'NDC03'			 //6
					 idw_impuestos.Object.flag_tipo 	[ll_inicio] = 'INT' //Interes
					 idw_impuestos.Object.flag_imp  	[ll_inicio] = 'INT'
			  CASE 'NCC03'			 //7
					 idw_impuestos.Object.flag_tipo 	[ll_inicio] = 'DES' //Descuento
					 idw_impuestos.Object.flag_imp  	[ll_inicio] = 'DES'
	 END CHOOSE
		 
NEXT



ib_estado_prea = False   //pre-asiento editado					
is_Action = 'fileopen'	

dw_master.ii_protect = 0
dw_master.ii_update = 0
dw_master.of_protect()

idw_detail.ii_protect = 0
idw_detail.ii_update = 0
idw_detail.of_protect()

idw_impuestos.ii_protect = 0
idw_impuestos.ii_update = 0
idw_impuestos.of_protect()

idw_asiento_det.ii_protect = 0
idw_asiento_det.ii_update = 0
idw_asiento_det.of_protect()



end subroutine

public function boolean of_nro_doc (string as_tipo_doc, string as_nro_serie);Long    	ll_ult_nro,ll_row, ll_count
Integer 	li_dig_serie,li_dig_numero
String	ls_mensaje


SELECT count(*)
  INTO :ll_count
  FROM num_doc_tipo
 WHERE tipo_doc  = :as_tipo_doc   
   AND nro_serie = :as_nro_serie ;

if ll_count = 0 then
	insert into num_doc_tipo(tipo_doc, nro_Serie, ultimo_numero)
	values(:as_tipo_doc, :as_nro_Serie, 1);
	
	ll_ult_nro = 1
	
	if SQLCA.SQLcode < 0 then
		ls_mensaje = SQLCA.SQLErrtext
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al insertar registro en tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
end if

SELECT ultimo_numero
  INTO :ll_ult_nro
  FROM num_doc_tipo
 WHERE tipo_doc  = :as_tipo_doc   
   AND nro_serie = :as_nro_serie for update;

	
//****************************//
//Actualiza Tabla num_doc_tipo//
//****************************//

UPDATE num_doc_tipo
SET 	 ultimo_numero = :ll_ult_nro + 1
WHERE  tipo_doc  = :as_tipo_doc   AND
		 nro_serie = :as_nro_serie ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al actualizar numerador en tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if
	
dw_master.object.serie 		[1] =  as_nro_serie
dw_master.object.numero 	[1] =  string(ll_ult_nro, '00000')
dw_master.object.nro_doc 	[1] =  f_llena_caracteres('0',Trim(as_nro_serie), 4) +'-'+ f_llena_caracteres('0',Trim(String(ll_ult_nro)), 5)

Return true


end function

public function boolean of_generacion_asiento_cntbl ();Long    ll_count
Boolean lb_retorno

dw_master.Accepttext()
idw_detail.Accepttext()
idw_impuestos.AcceptText()


IF dw_master.GetRow()   = 0 THEN RETURN FALSE

lb_retorno  = invo_asiento_cntbl.of_generar_asiento_cxc_nv(	dw_master,  &
																				idw_detail, &
																				idw_impuestos, &
																				idw_asiento_cab, &
																				idw_asiento_det, &
																				tab_1, &
																				'C')

Return lb_retorno
end function

public function boolean of_verifica_cnta_cntbl (string as_cnta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);Boolean lb_retorno = TRUE
str_cnta_cntbl		lstr_Cnta

lstr_cnta = invo_cntbl.of_cnta_cntbl(as_cnta_cntbl)

if not lstr_cnta.b_Return then return false

IF lstr_cnta.flag_ctabco = '1' THEN
	Messagebox('Aviso','Cuenta Contable ' + as_cnta_cntbl + ' pide Cuenta de Banco, pero no esta disponible en este tipo de comprobante')
	lb_retorno = FALSE	
END IF

IF lstr_cnta.flag_doc_ref = '1' THEN
	tab_1.tabpage_3.dw_cnt_ctble_det.object.tipo_docref1 	[al_row] = as_tipo_doc
	tab_1.tabpage_3.dw_cnt_ctble_det.object.nro_docref1 	[al_row] = as_nro_doc
ELSE
	tab_1.tabpage_3.dw_cnt_ctble_det.object.tipo_docref1 	[al_row] = gnvo_app.is_null
	tab_1.tabpage_3.dw_cnt_ctble_det.object.nro_docref1 	[al_row] = gnvo_app.is_null
END IF

IF lstr_cnta.flag_codrel = '1' THEN
	tab_1.tabpage_3.dw_cnt_ctble_det.object.cod_relacion [al_row] = as_cod_relacion
ELSE
	tab_1.tabpage_3.dw_cnt_ctble_det.object.cod_relacion [al_row] = gnvo_app.is_null
END IF	

Return true
end function

on w_ve308_notas_credito_debito.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_ext" then this.MenuID = create m_mantenimiento_cl_anular_ext
this.cb_referencias=create cb_referencias
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_referencias
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_ve308_notas_credito_debito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_referencias)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

String ls_expresion,ls_mensaje

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_impuestos.SetTransObject(sqlca)
idw_asiento_cab.SetTransObject(sqlca)
idw_asiento_det.SetTransObject(sqlca)


ls_mensaje = wf_verificacion_user()

IF Not(Isnull(ls_mensaje) OR Trim(ls_mensaje) = '' ) THEN
	Messagebox('Aviso',ls_mensaje)
END IF

	
idw_1 = dw_master              				// asignar dw corriente
idw_1.setFocus( )

//Crear Objeto
invo_asiento_cntbl 	= create n_cst_asiento_contable
invo_cntbl				= create n_cst_contabilidad 		

end event

event ue_insert;Long    ll_row,ll_row_master,ll_currow,ll_ano,ll_mes
String  ls_motivo,ls_flag_estado,ls_result,ls_mensaje
Boolean lb_result = TRUE


CHOOSE CASE idw_1
		 CASE dw_master
				TriggerEvent('ue_update_request')					
				dw_master.Reset()
				tab_1.tabpage_1.dw_detail_nv.Reset()
				tab_1.tabpage_2.dw_det_imp.Reset()
				tab_1.tabpage_3.dw_cnt_ctble_cab.Reset()
				tab_1.tabpage_3.dw_cnt_ctble_det.Reset()
				is_Action = 'new'
				ib_estado_prea = TRUE   //Pre Asiento No editado 
												//se activara proceso de Autogeneración
		 CASE	tab_1.tabpage_2.dw_det_imp	
				ll_row_master	= dw_master.Getrow()
				IF ll_row_master = 0 THEN
					Messagebox('Aviso','Debe Ingresar Registro En la Cabecera')
					Return
				END IF
				
				ls_motivo		= dw_master.object.motivo		 [ll_row_master]
				ls_flag_estado = dw_master.object.flag_estado [ll_row_master]
				ll_ano			= dw_master.object.ano 			 [ll_row_master]
				ll_mes			= dw_master.object.mes 			 [ll_row_master]


				/*verifica cierre*/
				if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) then return
				
				IF ls_flag_estado <> '1' THEN
					Messagebox('Aviso','No se Puede Modificar el Documento por el estado en que se Encuentra')
					Return
				END IF
				
				//Registro Detalle
				ll_currow = tab_1.tabpage_1.dw_detail_nv.GetRow()
				lb_result = tab_1.tabpage_1.dw_detail_nv.IsSelected(ll_currow)
				IF lb_result = FALSE then
					Messagebox('Aviso','Debe Seleccionar Un Item para generar su Respectivo Impuesto')
					Return
				END IF
																						
				
				ib_estado_prea = TRUE   //Pre Asiento No editado 
												//se activara proceso de Autogeneración

				
		 CASE ELSE
				RETURN
END CHOOSE


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_detail_nv.width      = tab_1.width  - tab_1.tabpage_1.dw_detail_nv.x - 75
tab_1.tabpage_1.dw_detail_nv.height     = tab_1.height - tab_1.tabpage_1.dw_detail_nv.y - 110
tab_1.tabpage_2.dw_det_imp.height       = tab_1.height - tab_1.tabpage_2.dw_det_imp.y - 110
tab_1.tabpage_3.dw_cnt_ctble_det.width  = tab_1.width  - tab_1.tabpage_3.dw_cnt_ctble_det.x - 75
tab_1.tabpage_3.dw_cnt_ctble_det.height = tab_1.height - tab_1.tabpage_3.dw_cnt_ctble_det.y - 110

end event

event ue_update_request();Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1                  OR tab_1.tabpage_1.dw_detail_nv.ii_update = 1     OR &
	 tab_1.tabpage_2.dw_det_imp.ii_update = 1 OR tab_1.tabpage_3.dw_cnt_ctble_cab.ii_update = 1 OR &
	 tab_1.tabpage_3.dw_cnt_ctble_det.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail_nv.ii_update = 0
		tab_1.tabpage_2.dw_det_imp.ii_update = 0
		tab_1.tabpage_3.dw_cnt_ctble_cab.ii_update = 0
		tab_1.tabpage_3.dw_cnt_ctble_det.ii_update = 0
	END IF
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;IF idw_1 = dw_master THEN
	/*Inserta Pre Asiento Cabecera*/
	tab_1.tabpage_3.dw_cnt_ctble_cab.TriggerEvent('ue_insert')

	dw_master.SetColumn('cod_relacion')
	dw_master.setFocus()

ELSEIF idw_1 = tab_1.tabpage_1.dw_detail_nv THEN
	tab_1.tabpage_1.dw_detail_nv.object.flag_int [al_row] = 'DES'
	tab_1.tabpage_1.dw_detail_nv.object.flag_aj  [al_row] = 'DES'
	tab_1.tabpage_1.dw_detail_nv.object.flag_rev [al_row] = 'DES'
	
	tab_1.tabpage_1.dw_detail_nv.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
	tab_1.tabpage_1.dw_detail_nv.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
	tab_1.tabpage_1.dw_detail_nv.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
END IF

end event

event ue_delete;//override
Long   ll_row,ll_ano,ll_mes
String ls_flag_estado,ls_item,ls_expresion_imp,ls_motivo,ls_mensaje,ls_result


CHOOSE CASE idw_1
	CASE tab_1.tabpage_1.dw_detail_nv
		/*Eliminar Impuesto de este Tipo*/						
		//segun motivo enviar un aviso
		ll_row = idw_1.Getrow()
		IF ll_row = 0 THEN RETURN		
		ls_flag_estado = dw_master.object.flag_estado [1]
		ll_ano			= dw_master.object.ano			 [1]
		ll_mes			= dw_master.object.mes			 [1]
	
	
		/*verifica cierre*/
		if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) then return
	
		IF ls_flag_estado <> '1' THEN
			Messagebox('Aviso','Doumento se encuentra en un estado en el cual no se modificar datos')
			RETURN 
		END IF
	
		//Eliminar impuesto del item a eliminar
		ls_item			   = Trim(String(tab_1.tabpage_1.dw_detail_nv.object.item [ll_row]))
		ls_expresion_imp = 'item = '+ls_item
		
		tab_1.tabpage_2.dw_det_imp.SetFilter(ls_expresion_imp)
		tab_1.tabpage_2.dw_det_imp.Filter()
		
		DO WHILE tab_1.tabpage_2.dw_det_imp.Rowcount() > 0 
			tab_1.tabpage_2.dw_det_imp.deleterow(0)
			tab_1.tabpage_2.dw_det_imp.ii_update = 1
		LOOP
		 
		tab_1.tabpage_2.dw_det_imp.SetFilter('')
		tab_1.tabpage_2.dw_det_imp.Filter()
		
		ib_estado_prea = TRUE   //Pre Asiento No editado 
										//se activara proceso de Autogeneración
	
	CASE	tab_1.tabpage_2.dw_det_imp	
		/*Elimino impuesto */
		/*Eliminar Impuesto de este Tipo*/						
		//segun motivo enviar un aviso
		ll_row = idw_1.Getrow()
		IF ll_row = 0 THEN RETURN		
		ls_flag_estado = dw_master.object.flag_estado [1]
		ls_motivo		= dw_master.object.motivo		 [1]
		ll_ano			= dw_master.object.ano			 [1]
		ll_mes			= dw_master.object.mes			 [1]
	
	
		/*verifica cierre*/
		if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) then return
		
		IF ls_flag_estado <> '1' THEN
			Messagebox('Aviso','Documento se encuentra en un estado en el cual no se modificar datos')
			RETURN 
		END IF
		
		ib_estado_prea = TRUE
	
									
	CASE ELSE
		Return
				
END CHOOSE



ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;Decimal {2} ldc_total

/*Total de Documento*/
ldc_total = wf_totales ()		
dw_master.object.importe_doc [1] = ldc_total
dw_master.ii_update = 1  

ib_estado_prea = TRUE   //Pre Asiento No editado 
								//se activara proceso de Autogeneración

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()
idw_impuestos.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	Return
END IF

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_impuestos.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if


IF idw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
	IF idw_asiento_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
		lbo_ok = FALSE
		messagebox("Error en Grabacion Pre - Asiento Cabecera","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_asiento_det.ii_update = 1 AND lbo_ok = TRUE  THEN
	IF idw_asiento_det.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Pre - Asiento Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF is_Action <> 'anular' THEN
	IF	dw_master.ii_update = 1  AND lbo_ok = TRUE  THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF


	IF idw_detail.ii_update = 1 AND lbo_ok = TRUE  THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF


	IF idw_impuestos.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_impuestos.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Messagebox("Error en Grabacion Impuestos","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
ELSE
	
	IF idw_impuestos.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_impuestos.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Messagebox("Error en Grabacion Impuestos","Se ha procedido al rollback",exclamation!)
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

if lbo_ok and ib_log then
	lbo_ok = dw_master.of_save_log()
	lbo_ok = idw_detail.of_save_log()
	lbo_ok = idw_impuestos.of_save_log()
	lbo_ok = idw_asiento_cab.of_save_log()
	lbo_ok = idw_asiento_det.of_save_log()
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update 			= 0
	idw_detail.ii_update 	 	= 0
	idw_impuestos.ii_update 	= 0
	idw_asiento_cab.ii_update 	= 0
	idw_asiento_det.ii_update 	= 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_impuestos.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()
	
	ib_estado_prea = False   //pre-asiento editado					
	
	if dw_master.RowCount() > 0 then
		of_retrieve(dw_master.object.tipo_doc[1], dw_master.object.nro_doc[1])
	end if
	
	is_Action = 'fileopen'
	//TriggerEvent('ue_modify')
	
	f_mensaje("Cambios Guardados satisfactoriamente", "")
	
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_update_pre;String ls_cod_moneda ,ls_periodo  ,ls_tipo_doc  ,ls_nro_doc,ls_cod_cliente, &
		 ls_flag_estado,ls_cnta_ctbl,ls_cod_origen,ls_obs,ls_cod_usr,ls_mensaje, &
		 ls_nro_serie
Long   ll_row_master,ll_nro_libro,ll_nro_asiento,ll_inicio,&
		 ll_ano,ll_mes
Decimal 	ldc_totsoldeb = 0   ,ldc_totdoldeb = 0,ldc_totsolhab = 0,ldc_totdolhab = 0,ldc_importe_imp,&
			ldc_saldo_sol = 0.00,ldc_saldo_dol = 0.00,ldc_monto_doc = 0.00, ldc_tasa_cambio
			
Datetime	ldt_fecha_registro
Date    	ld_last_day, ld_fecha_doc

/*REPLICACION*/
ib_update_check = False	

dw_master.of_set_flag_replicacion ()
idw_detail.of_set_flag_replicacion ()
idw_impuestos.of_set_flag_replicacion ()
idw_asiento_cab.of_set_flag_replicacion ()
idw_asiento_det.of_set_flag_replicacion ()


IF is_Action = 'anular' THEN //ANULO TRANSACION
	ib_update_check = TRUE
	Return
END IF


/*DATOS DE CABECERA */
IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	Return
END IF

//Verificación de Data en Cabecera de Documento
IF gnvo_app.of_row_Processing( dw_master ) <> true then	return
IF gnvo_app.of_row_Processing( idw_detail ) <> true then	return
IF gnvo_app.of_row_Processing( idw_impuestos ) <> true then	return


/*Datos de Cabecera*/
ll_row_master      = dw_master.Getrow()
ls_cod_moneda      = dw_master.object.cod_moneda 		[ll_row_master]
ll_nro_libro       = dw_master.object.nro_libro  	   [ll_row_master]
ll_nro_asiento		 = dw_master.object.nro_asiento	   [ll_row_master]
ls_cod_origen 		 = dw_master.Object.origen    	   [ll_row_master]
ls_tipo_doc			 = dw_master.object.tipo_doc		   [ll_row_master]
ls_nro_doc			 = dw_master.object.nro_doc		   [ll_row_master]
ls_cod_cliente		 = dw_master.object.cod_relacion	   [ll_row_master]
ldc_tasa_cambio	 = dw_master.object.tasa_cambio	   [ll_row_master]
ls_obs				 = dw_master.object.observacion     [ll_row_master]
ldt_fecha_registro = DateTime(dw_master.object.fecha_registro  [ll_row_master])
ld_fecha_doc		 = date(dw_master.object.fecha_documento 		[ll_row_master])
ls_flag_estado		 = dw_master.object.flag_estado	   [ll_row_master]
ls_cod_usr			 = dw_master.object.cod_usr 	 	   [ll_row_master]
ll_ano				 = dw_master.object.ano		 	 	   [ll_row_master]
ll_mes				 = dw_master.object.mes		 	 	   [ll_row_master]
ldc_monto_doc		 = dw_master.object.importe_doc	   [ll_row_master]



/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un Tipo de Moneda , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	return
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

	//Asignación  de Nro de Serie
	ls_nro_serie  = dw_master.object.serie [1]
	
	
	IF not invo_asiento_cntbl.of_get_nro_Asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  then return
	
	dw_master.object.nro_asiento [1] = ll_nro_asiento 
	
	
	/*Asignacion de Nro de Documento*/	
	IF not of_nro_doc( ls_tipo_doc, ls_nro_serie ) THEN return
	
END IF

//actualiza saldos
IF ls_cod_moneda = gnvo_app.is_soles THEN 
	ldc_saldo_sol = ldc_monto_doc
	ldc_saldo_dol = Round(ldc_monto_doc / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = gnvo_app.is_dolares THEN
	ldc_saldo_sol = Round(ldc_monto_doc *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_monto_doc
END IF

//saldos
dw_master.object.saldo_sol [1] = ldc_saldo_sol 
dw_master.object.saldo_dol [1] = ldc_saldo_dol




IF ib_estado_prea = TRUE THEN //Generación Automaticas de pre Asientos
	IF of_generacion_asiento_cntbl() = FALSE THEN  
		ib_update_check = False	
		Return
	END IF
END IF

///detalle de Documento
ls_tipo_doc = dw_master.object.tipo_doc 	  [1]
ls_nro_doc	= dw_master.object.nro_doc  	  [1]

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 idw_detail.object.tipo_doc 	  [ll_inicio]  = ls_tipo_doc		 
	 idw_detail.object.nro_doc  	  [ll_inicio]  = ls_nro_doc		
NEXT


///Impuestos
FOR ll_inicio = 1 TO idw_impuestos.Rowcount()
	 idw_impuestos.object.tipo_doc 	   [ll_inicio] = ls_tipo_doc		 
	 idw_impuestos.object.nro_doc  	   [ll_inicio] = ls_nro_doc	
	 
	 /*Verifica Monto de Impuesto sea Mayor a 0*/
	 ldc_importe_imp = idw_impuestos.object.importe [ll_inicio]
	 IF ls_flag_estado = '1' THEN   //Generado
		 IF Isnull(ldc_importe_imp) OR ldc_importe_imp = 0 THEN
			 ib_update_check = False	
			 Messagebox('Aviso','Verifique Importe de Impuesto debe ser Mayor que 0')
			 EXIT			 
		 END IF
	END IF
NEXT



///Detalle de pre asiento
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
	 ls_cnta_ctbl = idw_asiento_det.object.cnta_ctbl [ll_inicio]
	 idw_asiento_det.object.origen   	  	[ll_inicio] = ls_cod_origen
	 idw_asiento_det.object.ano			  	[ll_inicio] = ll_ano
	 idw_asiento_det.object.mes 		  		[ll_inicio] = ll_mes
	 idw_asiento_det.object.nro_libro	  	[ll_inicio] = ll_nro_libro
	 idw_asiento_det.object.nro_asiento 	[ll_inicio] = ll_nro_asiento
	 idw_asiento_det.Object.fec_cntbl   	[ll_inicio] = ld_fecha_doc	 
	 IF of_verifica_cnta_cntbl (ls_cnta_ctbl,ls_tipo_doc,ls_nro_doc,ls_cod_cliente,ll_inicio) = FALSE THEN
		 ib_update_check = False	
		 Return	
	 END IF
	 
NEXT


ldc_totsoldeb  = idw_asiento_det.object.monto_soles_cargo   	[1]
ldc_totdoldeb  = idw_asiento_det.object.monto_dolares_cargo 	[1]
ldc_totsolhab  = idw_asiento_det.object.monto_soles_abono	  	[1]
ldc_totdolhab  = idw_asiento_det.object.monto_dolares_abono 	[1]

//*Numero de Voucher*//
idw_asiento_cab.Object.origen 				[1] = ls_cod_origen
idw_asiento_cab.Object.ano 					[1] = ll_ano
idw_asiento_cab.Object.mes 					[1] = ll_mes
idw_asiento_cab.Object.nro_libro 			[1] = ll_nro_libro
idw_asiento_cab.Object.nro_asiento 			[1] = ll_nro_asiento

//*Datos de Cabecera de Asientos*//
idw_asiento_cab.Object.cod_moneda		  	[1] = ls_cod_moneda
idw_asiento_cab.Object.tasa_cambio	  		[1] = ldc_tasa_cambio
idw_asiento_cab.Object.desc_glosa		  	[1] = ls_obs
idw_asiento_cab.Object.fec_registro	  		[1] = ldt_fecha_registro
idw_asiento_cab.Object.fecha_cntbl	  		[1] = ld_fecha_doc
idw_asiento_cab.Object.cod_usr			  	[1] = ls_cod_usr
idw_asiento_cab.Object.flag_estado	  		[1] = ls_flag_estado
idw_asiento_cab.Object.tot_solhab	  	  	[1] = ldc_totsolhab
idw_asiento_cab.Object.tot_dolhab	     	[1] = ldc_totdolhab
idw_asiento_cab.Object.tot_soldeb	  	  	[1] = ldc_totsoldeb
idw_asiento_cab.Object.tot_doldeb	  	  	[1] = ldc_totdoldeb

IF idw_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1

IF dw_master.ii_update = 1 THEN 
	idw_asiento_cab.ii_update = 1
	idw_asiento_det.ii_update = 1
END IF


// valida asientos descuadrados
if not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then return

ib_update_check = true

end event

event ue_modify;call super::ue_modify;Long    ll_row,ll_ano,ll_mes
String  ls_flag_estado, ls_mensaje
Integer li_protect

ll_row = dw_master.Getrow()
dw_master.accepttext()


IF ll_row = 0 THEN RETURN


ls_flag_estado = dw_master.object.flag_estado 	[ll_row]
ll_ano			= Long(dw_master.object.ano 		[ll_row])
ll_mes			= Long(dw_master.object.mes 		[ll_row])

if ls_flag_estado <> '1' then
	f_mensaje("No se puede modificar el documento porque no esta activo", "")
	return
end if

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano, ll_mes, 'R') then return

dw_master.of_protect()
idw_detail.of_protect()
idw_impuestos.of_protect()
idw_asiento_det.of_protect()

IF ls_flag_estado <> '1' THEN
		
	dw_master.ii_protect = 0
	//idw_detail.ii_protect	  = 0
	idw_impuestos.ii_protect		  = 0
	idw_asiento_det.ii_protect = 0
	
	dw_master.of_protect()
	//idw_detail.of_protect ()
	idw_impuestos.of_protect ()
	idw_asiento_det.of_protect ()
	
ELSE

	IF is_Action <> 'new' THEN
		li_protect = integer(dw_master.Object.tipo_doc.Protect)
		IF li_protect = 0	THEN
			dw_master.object.tipo_doc.Protect  = 1
			dw_master.object.nro_libro.Protect = 1
			dw_master.object.ano.Protect 	 	  = 1
			dw_master.object.mes.Protect 	  	  = 1
		END IF
	END IF	
	
	li_protect = idw_detail.ii_protect
	
	IF li_protect = 1 THEN RETURN
	
END IF

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
str_parametros sl_param

TriggerEvent ('ue_update_request')	

sl_param.dw1    = 'd_abc_lista_cntas_cobrar_nv_tbl'
sl_param.titulo = 'Notas de Credito o Debito al Cliente'
sl_param.field_ret_i[1] = 1	//Tipo Doc
sl_param.field_ret_i[2] = 2	//Nro Doc

//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2] )
END IF


end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_print;call super::ue_print;Long   ll_row, ll_rpta
String ls_tipo_doc,ls_nro_doc,ls_flag_mercado, ls_serie
str_parametros lstr_param

IF dw_master.RowCount() = 0 or dw_master.GetRow() = 0 THEN
	f_mensaje('No existe Registro en la cabecera del documento, Verifique!', 'FIN_NOT_DOC')
	Return
END IF

of_asigna_dws()


IF (dw_master.ii_update         	= 1 OR &
	 idw_detail.ii_update  			= 1 OR &
	 idw_impuestos.ii_update		= 1 OR &
	 idw_asiento_cab.ii_update 	= 1 OR &
	 idw_asiento_det.ii_update 	= 1 )THEN
	 
	 Messagebox('Aviso','Existen Actualizaciones Pendientes, por favor grabelos primero antes de Imprimir, por favor Verifique!')
	 Return
	 
END IF	 

//Solicita si es impresión directa o previsualización
ll_rpta = gnvo_app.utilitario.of_print_preview()
if ll_rpta < 0 then return

if ll_rpta = 2 then
	lstr_param.b_preview = true
else
	lstr_param.b_preview = false
end if

//Impresión de Documento 
ls_tipo_doc 		= dw_master.object.tipo_doc 		[1]
ls_nro_doc 			= dw_master.object.nro_doc  		[1]
ls_serie				= dw_master.object.serie  			[1]
ls_flag_mercado 	= dw_master.object.flag_mercado 	[1]

if gnvo_app.ventas.is_impresion_termica = "0" then
	if left(ls_Serie, 1) = 'F' or left(ls_Serie, 1) = 'B' then
			//Comprobante electronico
		lstr_param.flag_mercado = ls_flag_mercado 
		gnvo_app.ventas.of_print_ce(ls_tipo_doc, ls_nro_doc, lstr_param)
		
	elseIF ls_tipo_doc = gnvo_app.finparam.is_doc_ncc THEN       //Caso Facturas
	
		//wf_fact_cobrar(ls_tipo_doc,ls_nro_doc, lstr_param)
		
	ELSEIF ls_tipo_doc = gnvo_app.finparam.is_doc_ndc THEN	 //Caso Boletas
		
		//wf_bol_cobrar(ls_tipo_doc,ls_nro_doc, lstr_param)
		
	end if
else
	gnvo_app.ventas.of_print_efact(ls_tipo_doc, ls_nro_doc, false)
end if


end event

event close;call super::close;destroy invo_asiento_cntbl
destroy invo_cntbl
end event

type cb_referencias from commandbutton within w_ve308_notas_credito_debito
integer x = 3214
integer y = 356
integer width = 864
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Referencias"
end type

event clicked;String 	ls_motivo,ls_cod_proveedor,ls_result,ls_mensaje, ls_flag_cab_det, &
			ls_serie, ls_tipo_nc, ls_tipo_nd, ls_tipo_doc
Decimal 	ldc_total
Long   	ll_ano,ll_mes, ll_opcion

str_parametros lstr_param

if dw_master.RowCount() = 0 then
	MessageBox('Error', 'No han especificado registros en la cabecera del comprobante', StopSign!)
	return
end if

dw_master.Accepttext()

ls_motivo 		  	= trim(dw_master.Object.motivo 	 	[1])
ls_tipo_doc			= dw_master.Object.tipo_doc 			[1]
ls_cod_proveedor 	= dw_master.Object.cod_relacion 		[1]
ll_ano			  	= dw_master.object.ano 					[1]
ll_mes			  	= dw_master.object.mes 					[1]
ls_tipo_nc			= dw_master.object.tipo_nc 			[1]
ls_tipo_nd			= dw_master.object.tipo_nd 			[1]
ls_flag_cab_det	= dw_master.object.flag_cab_det 		[1]
ls_Serie				= dw_master.object.serie		 		[1]


/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) then return

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Documento, Verifique!', StopSign!)
	dw_master.setColumn('tipo_doc')
	dw_master.setFocus()
	Return
END IF

IF Isnull(ls_cod_proveedor) OR Trim(ls_cod_proveedor) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!', StopSign!)
	dw_master.setColumn('cod_relacion')
	dw_master.setFocus()
	Return
END IF

IF Isnull(ls_motivo) OR Trim(ls_motivo) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Motivo , Verifique!', StopSign!)
	dw_master.setColumn('motivo')
	dw_master.setFocus()
	Return
END IF

IF trim(ls_tipo_doc) = 'NCC' and (Isnull(ls_tipo_nc) OR Trim(ls_tipo_nc) = '') THEN
	Messagebox('Aviso','El motivo ' + ls_motivo + ' No tiene especificado un tipo de Nota de Credito ' &
						  + 'de Sunat (CATALOGO 09), Verifique!', StopSign!)
	Return
END IF

IF trim(ls_tipo_doc) = 'NDC' and (Isnull(ls_tipo_nd) OR Trim(ls_tipo_nd) = '') THEN
	Messagebox('Aviso','El motivo ' + ls_motivo + ' No tiene especificado un tipo de Nota de DEBITO ' &
						  + 'de Sunat (CATALOGO 09), Verifique!', StopSign!)
	Return
END IF


CHOOSE CASE ls_flag_cab_det
	//*Ayudas de Acuerdo A Motivos*//	
	
	CASE 'D'  //Mostrar Detalle del documento
		
		lstr_param.tipo			= '1S'
		lstr_param.opcion			= 10          //Ordenes de Venta
		lstr_param.titulo 		= 'Detalle de Comprobantes de Venta'
		
		if trim(ls_tipo_doc) = 'NCC' and (ls_tipo_nc = '06' or ls_tipo_nc = '07') then
			
			if upper(gs_empresa) = 'SEAFROST' then
				if left(ls_serie,1) = 'F' then
					lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_fac_tbl'
				elseif left(ls_serie,1) = 'B' then
					lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_bvc_tbl'
				else
					lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_others_tbl'
				end if
			else
				if left(ls_serie,1) = 'F' then
					lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_0607_fac_tbl'
				elseif left(ls_serie,1) = 'B' then
					lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_0607_bvc_tbl'
				else
					lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_0607_others_tbl'
				end if
			end if
			
			
			if upper(gs_empresa) = 'SEAFROST' then
				lstr_param.dw1				= 'd_lista_cntas_cobrar_det_0607_seafrost_tbl'
			else
				lstr_param.dw1				= 'd_lista_cntas_cobrar_det_0607_tbl'
			end if
			
		else
			
			if left(ls_serie,1) = 'F' then
				lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_fac_tbl'
			elseif left(ls_serie,1) = 'B' then
				lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_bvc_tbl'
			else
				lstr_param.dw_master		= 'd_lista_cntas_cobrar_cab_others_tbl'
			end if
			
			lstr_param.dw1				= 'd_lista_cntas_cobrar_det_tbl'
		end if
		
		lstr_param.dw_m			= dw_master
		lstr_param.dw_d			= idw_detail
		lstr_param.dw_c			= idw_impuestos
		lstr_param.string1		= ls_cod_proveedor
		lstr_param.w1				= parent
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)


			
	CASE 'C'  //Mostrar Cabecera del movimiento 
		
		if trim(ls_tipo_doc) = 'NCC' and (ls_tipo_nc = '06' or ls_tipo_nc = '07') and upper(gs_empresa) <> 'SEAFROST' then
			
			if left(ls_serie,1) = 'F' then
				lstr_param.dw1		= 'd_lista_cntas_cobrar_ncc_0607_fac_tbl'
			elseif left(ls_serie,1) = 'B' then
				lstr_param.dw1		= 'd_lista_cntas_cobrar_ncc_0607_bvc_tbl'
			else
				lstr_param.dw1		= 'd_lista_cntas_cobrar_ncc_0607_others_tbl'
			end if
			
		else
			
			if left(ls_serie,1) = 'F' then
				lstr_param.dw1		= 'd_lista_cntas_cobrar_ncc_fac_tbl'
			elseif left(ls_serie,1) = 'B' then
				lstr_param.dw1		= 'd_lista_cntas_cobrar_ncc_bvc_tbl'
			else
				lstr_param.dw1		= 'd_lista_cntas_cobrar_ncc_others_tbl'
			end if
			
		end if
		
		lstr_param.titulo		= 'Detalle de Comprobantes de Venta'
		lstr_param.opcion		= 5
		lstr_param.db1 		= 1600	
		lstr_param.tipo		= '1S'
		lstr_param.dw_m		= dw_master
		lstr_param.dw_d		= idw_detail
		lstr_param.dw_c		= idw_impuestos			
		lstr_param.string1	= ls_cod_proveedor
		lstr_param.string2	= ls_motivo
		
		OpenWithParm( w_abc_seleccion_lista_search, lstr_param)
			
	case ELSE
		
			MessageBox('Error', 'Motivo ' + ls_motivo + ' no configurado, por favor coordinar con contabilidad')
			return
END CHOOSE


IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
		/*Total de Documento*/
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1
	
		idw_detail.ii_update = 1
		/*si es diferente a descuento por pronto pago se actualizara impuestos*/
		idw_impuestos.ii_update = 1
		
	END IF
end event

type tab_1 from tab within w_ve308_notas_credito_debito
event ue_find_exact ( )
integer y = 1224
integer width = 3771
integer height = 1036
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
end type

event ue_find_exact();Parent.TriggerEvent('ue_find_exact')
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;IF newindex = 3 THEN
	IF ib_estado_prea = FALSE THEN RETURN
	of_generacion_asiento_cntbl ()
END IF


end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3735
integer height = 908
long backcolor = 79741120
string text = " Referencia"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "Custom072!"
long picturemaskcolor = 536870912
dw_detail_nv dw_detail_nv
end type

on tabpage_1.create
this.dw_detail_nv=create dw_detail_nv
this.Control[]={this.dw_detail_nv}
end on

on tabpage_1.destroy
destroy(this.dw_detail_nv)
end on

type dw_detail_nv from u_dw_abc within tabpage_1
integer width = 3575
integer height = 880
string dataobject = "d_cntas_cobrar_det_nv_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

idw_mst  = dw_master								// dw_master
idw_det  = tab_1.tabpage_1.dw_detail_nv 	// dw_detail
end event

event itemchanged;call super::itemchanged;String 	ls_confin,ls_matriz,ls_descripcion,ls_codigo,ls_item, ls_desc
Long   	ll_count
Decimal	ldc_total
Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado 
								//se activara proceso de Autogeneración


CHOOSE CASE dwo.name
	CASE 'cod_art'
		SELECT Count(*)
		  INTO :ll_count
		  FROM articulo
		 WHERE cod_art = :data ;
		
		IF ll_count > 0 THEN
			SELECT nom_articulo
			  INTO :ls_descripcion
			  FROM articulo
			 WHERE (cod_art = :data) ;
			 
			This.Object.descripcion [row] = ls_descripcion
		ELSE
			SetNull(ls_descripcion)
			SetNull(ls_codigo)
			This.Object.cod_art		[row] = ls_codigo
			This.Object.descripcion [row] = ls_descripcion
			Messagebox('Aviso','Codigo de Articulo No Valido , Verifique!')
			Return 1
		END IF
		  
	CASE 'confin'	
		SELECT matriz_cntbl
		  INTO :ls_matriz
		  FROM concepto_financiero
		 WHERE confin = :data ;
		 
		
		IF Isnull(ls_matriz) OR Trim(ls_matriz) = '' THEN
			SetNull(ls_confin)
			SetNull(ls_matriz)
			Messagebox('Aviso','Concepto Financiero No existe Verifique')
			This.Object.confin 		 [row] = ls_confin
			This.object.matriz_cntbl [row] = ls_matriz
			Return 1
		ELSE
			This.object.matriz_cntbl [row] = ls_matriz
		END IF
	CASE	'cantidad','precio_unitario'
		ls_item = Trim(String(This.object.item [row]))
		//Recalculo de Impuesto	
		wf_generacion_imp (ls_item)	
		  
		/*Total de Documento*/
		ldc_total = wf_totales ()		
		dw_master.object.importe_doc [1] = ldc_total
		dw_master.ii_update = 1  

	CASE 'tipo_cred_fiscal'
		SELECT descripcion
		  INTO :ls_desc
		  from credito_fiscal t
		where t.flag_estado = '1'
  		  and t.flag_cxp_cxc = 'C'
		  and t.tipo_cred_fiscal = :data ;
		 
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Tipo de Credito Fiscal no existe, no esta activo o no corresponde a cuentas por cobrar, por favor verifique', Exclamation!)
			This.Object.tipo_cred_fiscal [row] = gnvo_app.is_null
			This.object.desc_cred_fiscal [row] = gnvo_app.is_null
			Return 1
		end if
		
		This.object.desc_cred_fiscal [row] = ls_desc
				  
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_flag_int, ls_und, ls_und2
decimal	ldc_cantidad, ldc_conv
str_parametros	lstr_param

choose case lower(as_columna)
	CASE 'cod_art'
		
		ls_flag_int = This.Object.flag_int [AL_row]
		IF Isnull(ls_flag_int) THEN RETURN
		
		ls_sql = "SELECT A.COD_ART AS CODIGO_articulo ,"&
				 + "A.DESC_ART AS DESCRIPCION_ARTICULO ,"&
				 + "a.UND AS UNIDAD "&
				 + "FROM ARTICULO A " &
				 + "WHERE A.FLAG_ESTADO = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art		[al_row] = ls_codigo
			this.object.descripcion	[al_row] = ls_data
			this.ii_update = 1
			ib_estado_prea = TRUE
		end if
		
	CASE 'und'
		
		ls_sql = "SELECT U.UND AS CODIGO_UNIDAD, " &
				 + "U.DESC_UNIDAD AS DESCRIPCION " &
				 + "FROM UNIDAD U " &
				 + "WHERE U.FLAG_ESTADO = '1'"
				  
				 
		if not gnvo_app.of_lista(ls_sql, ls_und, ls_data, '1') then return
		
		if ls_und <> '' then
			This.Object.und 					[al_row] = ls_und
			this.ii_update = 1
			ib_estado_prea = TRUE
			
			//Obtengo la segunda unodad
			ls_und2 = This.Object.und2 [al_row]
			
			if not IsNull(ls_und2) and trim(ls_und2) <> '' then
				
				//Obtengo la cantidad
				ldc_cantidad = Dec(this.object.cantidad [al_row])
				
				If ISNull(ldc_cantidad) then ldc_cantidad = 0
				
				SELECT U.FACTOR_CONV
				  INTO :ldc_conv
				  FROM UNIDAD_CONV U
				  WHERE U.UND_INGR = :ls_und
				  AND 	U.UND_CONV = :ls_und2;
				
				if ldc_conv > 0 then
					This.Object.cantidad_und2 		[al_row] = ldc_cantidad * ldc_conv
				else
					This.Object.cantidad_und2 	[al_row] = 0.00
				end if
				
			end if			
			
		end if
		
	case "confin"
		lstr_param.tipo		= ''
		lstr_param.opcion		= 3
		lstr_param.titulo 	= 'Selección de Concepto Financiero'
		lstr_param.dw_master	= 'd_lista_grupo_financiero_grd'
		lstr_param.dw1			= 'd_lista_concepto_financiero_grd'
		lstr_param.dw_m		=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		
		IF lstr_param.titulo = 's' THEN
			ii_update = 1
			ib_estado_prea = TRUE   //Pre Asiento No editado 
											//se activara proceso de Autogeneración
		END IF

	CASE 'tipo_cred_fiscal'
		ls_sql = "select t.tipo_cred_fiscal as tipo_cred_fiscal, " &
				 + "t.descripcion as desc_tipo_Cred_fiscal " &
				 + "from credito_fiscal t " &
				 + "where t.flag_estado = '1' " &
				 + "  and t.flag_cxp_cxc = 'C' " &
				 + "order by 1  "
				  
				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_cred_fiscal	[al_row] = ls_codigo
			this.object.desc_cred_fiscal	[al_row] = ls_data
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

event ue_insert_pre;call super::ue_insert_pre;This.Object.item	[al_row] = this.of_nro_item()

This.Object.cantidad			[al_row] = 0.00
This.Object.cantidad_und2	[al_row] = 0.00
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3735
integer height = 908
long backcolor = 79741120
string text = " Impuestos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "Custom023!"
long picturemaskcolor = 536870912
dw_det_imp dw_det_imp
end type

on tabpage_2.create
this.dw_det_imp=create dw_det_imp
this.Control[]={this.dw_det_imp}
end on

on tabpage_2.destroy
destroy(this.dw_det_imp)
end on

type dw_det_imp from u_dw_abc within tabpage_2
integer width = 3671
integer height = 628
integer taborder = 20
string dataobject = "d_abc_cc_det_imp_x_nv_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String 	ls_item,ls_expresion,ls_timpuesto,ls_signo,ls_cnta_cntbl,ls_desc_cnta,&
		 	ls_flag_dh_cxp
Long   	ll_found
Decimal 	ldc_imp_total,ldc_tasa_impuesto,ldc_total
this.Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado 
								//se activara proceso de Autogeneración

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
				ll_found		 = idw_detail.find(ls_expresion, 1, idw_detail.Rowcount())
				
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
				
				ldc_imp_total = idw_detail.object.total [ll_found]							
				
								
				This.Object.tasa_impuesto 	[row] = ldc_tasa_impuesto
				This.Object.signo			  	[row] = ls_signo
				This.Object.cnta_ctbl	  		[row] = ls_cnta_cntbl
				This.Object.flag_dh_cxp	  	[row] = ls_flag_dh_cxp
				This.Object.desc_cnta	  	[row] = ls_desc_cnta
				This.Object.importe		  	[row] = Round(ldc_imp_total * ldc_tasa_impuesto ,4)/ 100
				
				
				/*Total de Documento*/
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1  

		 CASE	'importe'
				/*Total de Documento*/
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1  					
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
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
idw_det = tab_1.tabpage_2.dw_det_imp  // dw_detail
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_currow,ll_item

ll_currow = tab_1.tabpage_1.dw_detail_nv.GetRow()
ll_item 	 = tab_1.tabpage_1.dw_detail_nv.Object.item [ll_currow]

This.Object.item [al_row] = ll_item

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cnta_cntbl, ls_flag_dh_cxp, ls_signo
decimal	ldc_tasa_impuesto


choose case lower(as_columna)
	case "tipo_impuesto"
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
			
			this.ii_update = 1
		end if
		
end choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3735
integer height = 908
long backcolor = 79741120
string text = "Asientos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "DataWindow!"
long picturemaskcolor = 536870912
dw_cnt_ctble_cab dw_cnt_ctble_cab
dw_cnt_ctble_det dw_cnt_ctble_det
end type

on tabpage_3.create
this.dw_cnt_ctble_cab=create dw_cnt_ctble_cab
this.dw_cnt_ctble_det=create dw_cnt_ctble_det
this.Control[]={this.dw_cnt_ctble_cab,&
this.dw_cnt_ctble_det}
end on

on tabpage_3.destroy
destroy(this.dw_cnt_ctble_cab)
destroy(this.dw_cnt_ctble_det)
end on

type dw_cnt_ctble_cab from u_dw_abc within tabpage_3
boolean visible = false
integer y = 644
integer width = 1975
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event itemchanged;call super::itemchanged;Accepttext()
end event

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
ii_dk[4] = 2 	      // columnas que se pasan al detalle
ii_dk[5] = 3 	      // columnas que se pasan al detalle

idw_mst = tab_1.tabpage_3.dw_cnt_ctble_cab // dw_master
idw_det = tab_1.tabpage_3.dw_cnt_ctble_det // dw_detail
end event

event ue_insert_pre(long al_row);This.object.flag_tabla [al_row] = '1' //Cuentas x Cobrar
end event

type dw_cnt_ctble_det from u_dw_abc within tabpage_3
integer width = 3269
integer height = 624
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
end type

event itemchanged;call super::itemchanged;Accepttext()
ib_estado_prea = FALSE   //Pre Asiento editado	
end event

event itemerror;call super::itemerror;Return 1
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
ii_rk[4] = 2	      // columnas que recibimos del master
ii_rk[5] = 3 	      // columnas que recibimos del master


idw_mst = tab_1.tabpage_3.dw_cnt_ctble_cab // dw_master
idw_det = tab_1.tabpage_3.dw_cnt_ctble_det // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	tab_1.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

type dw_master from u_dw_abc within w_ve308_notas_credito_debito
integer width = 4183
integer height = 1216
string dataobject = "d_cntas_cobrar_nv_x_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event itemerror;call super::itemerror;Return 1
end event

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)



ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master		// dw_master
idw_det  = idw_detail	// dw_detail

end event

event itemchanged;call super::itemchanged;String  ls_codigo, ls_descripcion,ls_tipo_doc,ls_motivo,ls_mes,ls_tip_doc,&
		  ls_nota_deb,ls_cod_relacion,ls_dir_dep_estado,ls_dir_distrito,ls_direccion, &
		  ls_ruc_dni, ls_serie, ls_nom_vendedor, ls_flag_cab_det, ls_tipo_nc
Long    ll_count,ll_nro_libro
Integer li_num_dir
Decimal ldc_total
Date    ld_fecha_documento

str_direccion lstr_direccion

Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado 
								//se activara proceso de Autogeneración

CHOOSE CASE dwo.name
	CASE 'forma_pago'
		
		select fp.desc_forma_pago
			into :ls_descripcion
		from forma_pago fp
		where fp.flag_estado = '1'
		  and fp.forma_pago	= :data;
		
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			messagebox('Aviso','Forma de Pago ' + trim(data) + ' no existe o no se encuentra activo. Por favor verifique!', StopSign!)
			this.object.forma_pago			[row] = gnvo_app.is_null
			this.object.desc_forma_pago	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_forma_pago[row] = ls_descripcion
			
	CASE 'vendedor'
	
		select v.nom_vendedor
		  into :ls_nom_vendedor
		  from vendedor v
		 where v.vendedor = :data
			and v.flag_estado <> '0';
		
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			messagebox('Aviso','Codigo de Vendedor no existe o no se encuentra activo. Por favor verifique!', StopSign!)
			this.object.vendedor			[row] = gnvo_app.is_null
			this.object.nom_vendedor	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.nom_vendedor[row] = ls_nom_vendedor
		
	CASE 'fecha_documento'
		ld_fecha_documento = Date(This.object.fecha_documento [row])
		
		This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio_vta(ld_fecha_documento)
	
		This.object.ano [row] = Long(String(ld_fecha_documento,'yyyy'))
		This.object.mes [row] = Long(String(ld_fecha_documento,'mm'))
				
	CASE 'item_direccion'			
			
		ls_cod_relacion = dw_master.object.cod_relacion [row]		
		
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
			Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
			this.object.direccion [row] = gnvo_app.is_null
			Return 1
		END IF

		/**/
		li_num_dir = Integer(data)
		/**/
		

		SELECT pkg_logistica.of_get_direccion(codigo, item)
		  INTO :ls_direccion
		  FROM direcciones
		 WHERE codigo = :ls_cod_relacion
			AND item   = :li_num_dir    ;
						  
						  
		IF sqlca.sqlcode = 100 THEN
			
			Messagebox('Aviso','Item de Direccion No Existe, por favor Verifique!', StopSign!)				
			Setnull(li_num_dir)
			This.Object.item_direccion [row] = gnvo_app.il_null
			This.Object.direccion      [row] = gnvo_app.is_null
			Return 1 
			
		end if
					 
		This.Object.direccion [row] = ls_direccion
				
	CASE 'cod_relacion'
		ls_tipo_doc = this.object.tipo_doc 	[row]
		ls_serie		= this.object.serie 		[row]
		
		if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' then
			MessageBox('Error', 'Debe definir Tipo de Documento antes de elegir un cliente. Por favor verifique!', StopSign!)
			this.setColumn("tipo_doc")
			return
		end if
		
		if IsNull(ls_Serie) or trim(ls_Serie) = '' then
			MessageBox('Error', 'Debe definir la Serie del Documento antes de elegir un cliente. Por favor verifique!', StopSign!)
			this.setColumn("serie")
			return
		end if

		//Obtengo los datos del cliente
		SELECT nom_proveedor, decode(tipo_doc_ident, '6', ruc, nro_doc_ident) 
		  INTO :ls_descripcion, :ls_ruc_dni
		  FROM proveedor p
		 WHERE proveedor = :data
		   and flag_estado = '1';

		IF SQLCA.sqlcode = 100 then
			Messagebox('Aviso','Debe Ingresar Código de Cliente Valido, por favor Verifique !', StopSign!)
			This.Object.cod_relacion  	[row] = gnvo_app.is_null
			This.Object.nom_proveedor 	[row] = gnvo_app.is_null
			This.Object.ruc_dni 			[row] = gnvo_app.is_null
			Return 1
		end if
		
		This.Object.nom_proveedor 	[row] = ls_descripcion
		This.Object.ruc_dni 			[row] = ls_ruc_dni
		
		lstr_direccion = gnvo_app.logistica.of_get_direccion( data )

		if lstr_direccion.b_return then
			this.object.item_direccion	[row] = lstr_direccion.item_direccion
			this.object.direccion		[row] = lstr_direccion.direccion
		else
			this.object.item_direccion	[row] = gnvo_app.il_null
			this.object.direccion		[row] = gnvo_app.is_null
		end if

				
	CASE 'tipo_doc'
			
		IF idw_detail.Rowcount() > 0 THEN
			Messagebox('Aviso','No se puede modificar el tipo de documento cuando ya se tiene detalle. Por favor verifique!', StopSign!)
			return 1
		END IF
		
		
		//** **//
		SELECT dt.NRO_LIBRO
			into :ll_nro_libro
    	FROM 	DOC_GRUPO_RELACION DGR,   
         	DOC_TIPO_USUARIO   dtu,   
         	DOC_TIPO           dt,   
         	NUM_DOC_TIPO       ndt
   	WHERE dtu.tipo_doc = ndt.tipo_doc (+)
     	  and dtu.nro_serie = ndt.nro_serie (+)
        and dgr.TIPO_DOC = dtu.TIPO_DOC
     	  and dtu.TIPO_DOC = dt.TIPO_DOC 
     	  and dt.flag_estado = '1'
     	  and dgr.GRUPO 		= :gnvo_app.finparam.is_grp_doc_ntvnt
		  and dtu.cod_usr		= :gs_user
		  and dt.tipo_doc		= :data;
         
		  
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Tipo de Documento ingresado no existe, no esta activo, " &
									+ "no corrresponde al grupo " + gnvo_app.finparam.is_grp_doc_ntvnt &
									+ " o no tiene asignado ninguna serie a su usuario. Por favor verifique!", StopSign!)
			This.Object.tipo_doc 	[row] = gnvo_app.is_null
			This.Object.serie 		[row] = gnvo_app.is_null
			This.Object.nro_libro 	[row] = gnvo_app.il_null
			This.Object.motivo    	[row] = gnvo_app.is_null
			return 1
		end if
		
		This.Object.nro_libro 	[row] = ll_nro_libro
		This.Object.motivo    	[row] = gnvo_app.is_null
		This.Object.serie 		[row] = gnvo_app.is_null
				
	CASE 'motivo'
			
		ls_tipo_doc = This.Object.tipo_doc [row]				
		IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
			Messagebox('Aviso','Debe Seleccionar Tipo de Documento ,Verifique')
			this.setColumn( "tipo_doc" )
			This.Object.motivo [row] = gnvo_app.is_null
			Return 1
		end if
				
				
		IF idw_detail.Rowcount() > 0 THEN
			Messagebox('Aviso','No se puede cambiar el motivo, porque ya tiene detalle el documento. Por favor verifique!', StopSign!)
			return 1
		END IF
		
		/*
		ls_sql = "select t.motivo as motivo, "&
				 + "t.descripcion as descripcion, " &
				 + "t.flag_cab_det as flag_cabecera_detalle, " &
				 + "t.tipo_nc as tipo_nc " &
				 + "from MOTIVO_NOTA t " &
				 + "where motivo like '" + ls_tipo_doc + "'"
		*/
		
		select descripcion, flag_cab_det, tipo_nc
			into :ls_descripcion, :ls_flag_cab_det, :ls_tipo_nc
		from motivo_nota
		where motivo = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Motivo ' + data + ' no existe o no se encuentra activo. Por favor verifique!', StopSign!)
			This.Object.motivo 			[row] = gnvo_app.is_null
			This.Object.desc_motivo 	[row] = gnvo_app.is_null
			This.Object.flag_cab_det 	[row] = gnvo_app.is_null
			This.Object.tipo_nc 			[row] = gnvo_app.is_null
			return 1
		end if
		
		This.Object.desc_motivo 	[row] = ls_Descripcion
		This.Object.flag_cab_det 	[row] = ls_flag_cab_det
		This.Object.tipo_nc 			[row] = ls_tipo_nc
			
END CHOOSE


end event

event ue_insert_pre;call super::ue_insert_pre;String 	ls_pago
DateTime	ldt_hoy

ldt_hoy = gnvo_app.of_fecha_actual()

This.object.origen 				[al_row] = gs_origen
This.object.cod_usr 				[al_row] = gs_user
This.object.fecha_registro 	[al_row] = ldt_hoy
This.object.fecha_documento   [al_row] = Date(ldt_hoy)
This.object.fecha_vencimiento [al_row] = Date(ldt_hoy)
This.object.ano	 				[al_row] = Long(String(ldt_hoy,'YYYY'))
This.object.mes 					[al_row] = Long(String(ldt_hoy,'MM'))
This.object.tasa_cambio 		[al_row] = f_tasa_cambio()
This.object.flag_estado 		[al_row] = '1'
This.object.flag_provisionado [al_row] = 'R'
This.object.forma_pago 			[al_row] = gnvo_app.finparam.is_pcon
This.object.flag_enviar_efact	[al_row] = '0'
This.object.flag_mercado		[al_row] = 'L'

this.setColumn('cod_relacion')
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_relacion, ls_tipo_doc, ls_data2, ls_data3, ls_serie, &
			ls_data4
Integer	li_opcion
str_cliente		lstr_cliente
str_direccion	lstr_direccion

of_asigna_dws()

choose case lower(as_columna)
	CASE 'forma_pago'
	
		ls_sql = "select fp.forma_pago as forma_pago, " &
				 + "fp.desc_forma_pago as desc_forma_pago " &
				 + "from forma_pago fp " &
				 + "where fp.flag_estado = '1'"

		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.forma_pago			[al_row] = ls_codigo
			this.object.desc_forma_pago	[al_row] = ls_data
			
			this.ii_update = 1
			
		end if
		
	CASE 'vendedor'
	
		ls_sql = "select v.vendedor as codigo_vendedor, " 	&
				 + "v.nom_vendedor as nombre_vendedor "  	&
				 + "from vendedor v " 						&
				 + "where v.flag_estado = '1' "			&
				 + "order by nombre_vendedor"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.vendedor			[al_row] = ls_codigo
			this.object.nom_vendedor	[al_row] = ls_data
			
			this.ii_update = 1
			
		end if
		
		
	CASE 'cod_relacion'
		ls_tipo_doc = this.object.tipo_doc 	[al_row]
		ls_serie		= this.object.serie 		[al_row]
		
		if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' then
			MessageBox('Error', 'Debe definir Tipo de Documento antes de elegir un cliente. Por favor verifique!', StopSign!)
			this.setColumn("tipo_doc")
			return
		end if
		
		if IsNull(ls_Serie) or trim(ls_Serie) = '' then
			MessageBox('Error', 'Debe definir la Serie del Documento antes de elegir un cliente. Por favor verifique!', StopSign!)
			this.setColumn("serie")
			return
		end if
		
		
		IF idw_detail.Rowcount() > 0 THEN
			li_opcion = MessageBox('Aviso', 'El documento tiene Detalle, desea cambiarlo?', Question!, YesNo!, 2)
	
			IF li_opcion = 1 THEN
				Messagebox('Aviso','Se Elimiran Registro Seleccionados en el Detalle', Information!)
				//Detalle de Notas
				DO WHILE idw_detail.rowcount () > 0
					idw_detail.DeleteRow(0)
					idw_detail.ii_update = 1
				LOOP
			
				//Impuesto de Notas
				DO WHILE idw_impuestos.rowcount () > 0
					idw_impuestos.DeleteRow(0)
					idw_impuestos.ii_update = 1
				LOOP
			END IF
		END IF
		
		lstr_cliente = gnvo_app.finparam.of_get_cliente( ls_tipo_doc, ls_serie )
		
		if lstr_cliente.b_return then
			this.object.cod_relacion 		[al_row] = lstr_cliente.proveedor
			this.object.nom_proveedor 		[al_row] = lstr_cliente.nom_proveedor
			this.object.ruc_dni				[al_row] = lstr_cliente.ruc_dni
			
			lstr_direccion = gnvo_app.logistica.of_get_direccion( lstr_cliente.proveedor )
			
			if lstr_direccion.b_return then
				this.object.item_direccion	[al_row] = lstr_direccion.item_direccion
				this.object.direccion		[al_row] = lstr_direccion.direccion
			else
				this.object.item_direccion	[al_row] = gnvo_app.il_null
				this.object.direccion		[al_row] = gnvo_app.is_null
			end if
			
			this.ii_update				= 1
			ib_estado_prea = TRUE
		end if
		
		

	CASE 'item_direccion'
	
		ls_cod_relacion = dw_master.object.cod_relacion [al_row]		
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
			Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Verifique!')
			this.setColumn( "cod_relacion" )
			Return 
		END IF

		// Solo Tomo la Direccion de facturacion
		ls_sql = "SELECT D.ITEM AS ITEM," &    
				 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
				 + "FROM DIRECCIONES D "&
				 + "WHERE D.CODIGO = '" + ls_cod_relacion +"' " &
				 + "AND D.FLAG_USO in ('1', '3')"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.item_direccion	[al_row] = Long(ls_codigo)
			this.object.direccion		[al_row] = ls_data
			this.ii_update = 1
			ib_estado_prea = TRUE
		end if

	case "tipo_doc"
		
		ls_sql = "SELECT dtu.TIPO_DOC as tipo_doc, " &
				 + "dtu.NRO_SERIE as nro_serie, " &
				 + "dt.NRO_LIBRO as nro_libro, " &
				 + "ndt.ULTIMO_NUMERO as ultimo_numero " &
				 + "FROM DOC_GRUPO_RELACION DGR, " &
				 + "DOC_TIPO_USUARIO   dtu, " &
				 + "DOC_TIPO           dt, " &
				 + "NUM_DOC_TIPO       ndt " &
				 + "WHERE dtu.tipo_doc = ndt.tipo_doc (+) " &
				 + "  and dtu.nro_serie = ndt.nro_serie (+) " &
				 + "  and dgr.TIPO_DOC = dtu.TIPO_DOC " &
				 + "  and dtu.TIPO_DOC = dt.TIPO_DOC " &
				 + "  and dt.flag_estado = '1' " &
				 + "  and dgr.GRUPO = '" + gnvo_app.finparam.is_grp_doc_ntvnt + "' " &
				 + "  and dtu.COD_USR = '" + gs_user + "'"
         
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '2')

		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.serie				[al_row] = ls_data
			this.object.nro_libro		[al_row] = Long(ls_data2)
			this.object.numero			[al_row] = ls_data3
			this.ii_update = 1
		end if

	case "serie"

		ls_tipo_doc = this.object.tipo_doc [al_row]
		IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc)  = '' THEN
			Messagebox('Aviso','Debe seleccionar primero Tipo de Documento , Verifique!')
			this.setColumn( "tipo_doc" )
			Return 
		END IF
		
		ls_sql = "SELECT dtu.NRO_SERIE as nro_serie, " &
				 + "ndt.ULTIMO_NUMERO as ultimo_numero " &
				 + "FROM DOC_GRUPO_RELACION DGR, " &
				 + "DOC_TIPO_USUARIO   dtu, " &
				 + "DOC_TIPO           dt, " &
				 + "NUM_DOC_TIPO       ndt " &
				 + "WHERE dtu.tipo_doc = ndt.tipo_doc (+) " &
				 + "  and dtu.nro_serie = ndt.nro_serie (+) " &
				 + "  and dgr.TIPO_DOC = dtu.TIPO_DOC " &
				 + "  and dtu.TIPO_DOC = dt.TIPO_DOC " &
				 + "  and dt.flag_estado = '1' " &
				 + "  and dt.tipo_doc = '" + ls_tipo_doc + "' " &
				 + "  and dgr.GRUPO = '" + gnvo_app.finparam.is_grp_doc_ntvnt + "' " &
				 + "  and dtu.COD_USR = '" + gs_user + "'"
         
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.serie				[al_row] = ls_codigo
			this.object.numero			[al_row] = ls_data
			this.ii_update = 1
		end if

	case "motivo"
		
		ls_tipo_doc = this.object.tipo_doc [al_row]
		IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc)  = '' THEN
			Messagebox('Aviso','Debe seleccionar primero Tipo de Documento , Verifique!')
			this.setColumn( "tipo_doc" )
			Return 
		END IF
		
		ls_tipo_doc = trim(ls_tipo_doc) + '%'
		
		ls_sql = "select t.motivo as motivo, "&
				 + "t.descripcion as descripcion, " &
				 + "t.flag_cab_det as flag_cabecera_detalle, " &
				 + "t.tipo_nc as tipo_nc, " &
				 + "t.tipo_nd as tipo_nd " &
				 + "from MOTIVO_NOTA t " &
				 + "where t.motivo like '" + ls_tipo_doc + "'" &
				 + "  and t.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, ls_data4, '2') then
			this.object.motivo			[al_row] = ls_codigo
			this.object.desc_motivo		[al_row] = ls_data
			this.object.flag_cab_det	[al_row] = ls_data2
			this.object.tipo_nc			[al_row] = ls_data3
			this.object.tipo_nd			[al_row] = ls_data4
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

event buttonclicked;call super::buttonclicked;String 			ls_tipo_doc, ls_nro_doc, ls_Directorio
Blob				lbl_DATA_XML, lbl_DATA_CDR, lbl_DATA_PDF
integer 			li_FileNum
Long				ll_rpta
n_cst_wait		lnvo_wait
str_parametros	lstr_param

try
	if row = 0 then return
	
	lnvo_wait = create n_cst_wait
	
	ls_tipo_doc = this.object.tipo_doc 	[row]
	ls_nro_doc	= this.object.nro_doc	[row]
	
	
	if dw_master.ii_update 			= 1 or idw_detail.ii_update = 1 or &
		idw_impuestos.ii_update		= 1 or idw_asiento_cab.ii_update	= 1 or &
		idw_asiento_det.ii_update	= 1 then
		
		gnvo_app.of_mensaje_error( "Tiene grabaciones pendientes. Por favor verifique!")
		return 
		
	end if
	
	if lower(dwo.name) = 'b_envio_efact' then
		//Actualiza el flag_envio
		if this.object.flag_estado [row] = '0' then
			gnvo_app.of_mensaje_error( "El comprobante " + ls_tipo_doc + "/" + ls_nro_doc + " se encuentra anulado, no se puede enviar a EFACT")
			return
		end if
		
		//ACtualizo el flag para enviar a EFACT
		update cntas_cobrar cc
			set cc.FLAG_ENVIAR_EFACT = '1'
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
		  
		if gnvo_app.of_existserror( SQLCA, "update cntas_cobrar") then
			ROLLBACK;
			return
		end if
		
		commit;
		
		//Verifico si envio el comprobante directamente a sunat o lo envio a travez de un OSE
		if gnvo_app.of_get_parametro( "VTA_ENVIO_FACT_ELECTRONICA_OSE", "0") = "0" then
			// Genero el archivo XML para enviarlo al cliente
			gnvo_app.ventas.of_create_only_xml(gnvo_app.is_null, ls_tipo_doc, ls_nro_doc)
		
			//Envio por email
			if gnvo_app.of_get_parametro('ALWAYS_QUESTION_SEND_EMAIL', '1') = '1' then
				ll_rpta = MessageBox('Aviso', 'Desea Enviar por email el comprobante eletronico?', Information!, YesNo!, 2)
			else
				ll_rpta = 1
			end if
			
			if ll_rpta = 1 then
				yield()
				lnvo_wait.of_mensaje("Enviando el documento por email, espere por favor.....")
				yield()
				
				gnvo_app.ventas.of_send_email(gnvo_app.is_null, ls_tipo_doc, ls_nro_doc)
				
				lnvo_wait.of_close()
				yield()
			end if			
		end if
			
		
		dw_master.object.b_envio_efact.Enabled = "No"
		
		gnvo_app.of_message_error( "Factura ha sido activada para envío a EFACT. Por favor verifique su correo en unos minutos")
		
	elseif lower(dwo.name) = 'b_download' then
		
		if GetFolder("Seleccione el Directorio para guardar los documentos digitales",ls_Directorio) <> 1 then return
		
		SELECTBLOB 	DATA_XML
			into 		:lbl_DATA_XML
		FROM cntas_cobrar cc
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
		
		SELECTBLOB 	DATA_CDR
			into 		:lbl_DATA_CDR
		FROM cntas_cobrar cc
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
	
		SELECTBLOB 	DATA_PDF
			into 		:lbl_DATA_PDF
		FROM cntas_cobrar cc
		where cc.tipo_doc = :ls_tipo_doc
		  and cc.nro_doc	= :ls_nro_doc;
		  
		//Creo el archivo PDF
		if not IsNull(lbl_DATA_PDF) then
			li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".PDF", &
				StreamMode!, Write!, Shared!, Replace!)
	
			FileWriteEx(li_FileNum, lbl_DATA_PDF)
			FileClose(li_FileNum)
		end if
	
		//Creo el archivo XML
		if not IsNull(lbl_DATA_XML) then
			li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".XML", &
				StreamMode!, Write!, Shared!, Replace!)
	
			FileWriteEx(li_FileNum, lbl_DATA_XML)
			FileClose(li_FileNum)
		end if
	
		//Creo el archivo CDR
		if not IsNull(lbl_DATA_CDR) then
			li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".CDR", &
				StreamMode!, Write!, Shared!, Replace!)
	
			FileWriteEx(li_FileNum, lbl_DATA_CDR)
			FileClose(li_FileNum)
		end if
		
		gnvo_app.of_mensaje_error( "Archivos generados satisfactoriamente")
	
	elseif lower(dwo.name) = 'b_obs' then
		
			// Para la descripcion de la Factura
			lstr_param.string1   = 'Descripcion de Factura '
			lstr_param.string2	 = this.object.observacion [row]
		
			OpenWithParm( w_descripcion_fac, lstr_param)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
			IF lstr_param.titulo = 's' THEN
					This.object.observacion [row] = lstr_param.string3
					ii_update = 1
			END IF	
	end if

catch ( exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al hacer click en boton en el DAtaWindow Maestro")

finally
	destroy lnvo_wait
end try
end event

