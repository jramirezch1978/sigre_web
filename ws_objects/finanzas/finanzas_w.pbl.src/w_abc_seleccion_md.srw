$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion_md
end type
type dw_text from datawindow within w_abc_seleccion_md
end type
type cb_1 from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 4197
integer height = 2500
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
dw_master dw_master
end type
global w_abc_seleccion_md w_abc_seleccion_md

type variables
String is_col = '', is_tipo
integer ii_ik[]
str_parametros ist_datos
Boolean ib_sel = false
Datastore ids_art_a_vender
end variables

forward prototypes
public function long wf_find_guias (string as_cod_origen, string as_nro_guia)
public subroutine wf_insert_articulos_a_cobrar (string as_cod_origen, string as_cod_guia, string as_orden_venta, double adb_tasa_cambio)
public function long wf_find_art (string as_orden_venta)
public subroutine wf_insert_art_ov (string as_orden_venta)
public subroutine wf_insert_det_warrant ()
public subroutine wf_insert_det_deuda_financiera ()
public subroutine wf_cuotas_deudas_financieras ()
public subroutine wf_insert_item_grmp (string as_guia_rec_mp, string as_cod_moneda, string as_tipo_doc_grmp)
public function integer wf_insert_ref_grmp (long al_item)
public subroutine of_opcion11 ()
public subroutine of_insert_item_os (string as_orden_os, string as_cod_moneda)
public function integer of_opcion10 ()
public function integer of_opcion3 ()
public function integer of_opcion15 ()
public function integer of_opcion16 ()
public function decimal of_insert_art_oc (long al_row)
end prototypes

public function long wf_find_guias (string as_cod_origen, string as_nro_guia);String ls_expresion,ls_tipo_doc
Long   ll_found = 0,ll_row


//***SELECCION DE TIPO DE DOC GUIA***//
SELECT doc_gr
  INTO :ls_tipo_doc
  FROM logparam
 WHERE reckey = '1' ;
//***********************************//

ls_expresion = 'origen_ref = '+"'"+as_cod_origen+"'"+'  AND  nro_ref = '+"'"+as_nro_guia+"'"
ll_found = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 

IF ll_found > 0 THEN
	Return ll_found
ELSE

	IF ist_datos.dw_c.triggerevent ('ue_insert') > 0 THEN
		ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'C'
	   ist_datos.dw_c.Object.origen_ref 	 [ll_row] = as_cod_origen
	   ist_datos.dw_c.Object.tipo_ref		 [ll_row] = ls_tipo_doc
	   ist_datos.dw_c.Object.nro_ref		    [ll_row] = as_nro_guia
		ist_datos.dw_c.Object.flab_tabor		 [ll_row] = '9' //Guias de Remision
		Return ll_found
	END IF
END IF



end function

public subroutine wf_insert_articulos_a_cobrar (string as_cod_origen, string as_cod_guia, string as_orden_venta, double adb_tasa_cambio);Rollback;

DECLARE PB_USP_FIN_ADD_ARTICULOS_X_GUIA PROCEDURE FOR USP_FIN_ADD_ARTICULOS_X_GUIA
(:as_cod_origen,:as_cod_guia,:as_orden_venta,:adb_tasa_cambio);
EXECUTE PB_USP_FIN_ADD_ARTICULOS_X_GUIA ;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_ADD_ARTICULOS_X_GUIA , Comunicar en Area de Sistemas' )
	RETURN
END IF


ids_art_a_vender.Retrieve()



end subroutine

public function long wf_find_art (string as_orden_venta);Long   ll_found,ll_inicio,ll_fdw_d
String ls_expresion,ls_soles,ls_dolares,ls_tipo_doc,ls_item

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 

//* Tipo de Documento Orden de Venta *//
SELECT doc_ov
  INTO :ls_tipo_doc
  FROM logparam
 WHERE (reckey = '1');
//***********************************// 

	
FOR ll_inicio = 1 TO ids_art_a_vender.Rowcount()
	
	 
	 ls_expresion = 'cod_art = '+"'"+ids_art_a_vender.object.cod_art[ll_inicio]+"'"
	 ll_found = ist_datos.dw_d.Find(ls_expresion, 1, ist_datos.dw_d.RowCount())	 
	 
	 IF ll_found > 0 THEN
		 ist_datos.dw_d.Object.cantidad [ll_found] = ist_datos.dw_d.Object.cantidad [ll_found] + ids_art_a_vender.Object.cant_procesada [ll_inicio]
		 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_found]))

	 ELSE
				
       IF ist_datos.dw_d.triggerevent ('ue_insert') > 0 THEN
			 /**/
//			 IMPUESTO           
			 IF ist_datos.string3 = ls_soles THEN
             ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_soles   [ll_inicio]				
			 ELSE
             ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_dolares [ll_inicio]								
			 END IF	
			
 			 ist_datos.dw_d.Object.tipo_ref        [ll_fdw_d] = ls_tipo_doc
			 ist_datos.dw_d.Object.nro_ref         [ll_fdw_d] = as_orden_venta
			 ist_datos.dw_d.Object.cod_art         [ll_fdw_d] = ids_art_a_vender.Object.cod_art 		   [ll_inicio]
			 ist_datos.dw_d.Object.descripcion     [ll_fdw_d] = ids_art_a_vender.Object.nom_articulo     [ll_inicio]
			 ist_datos.dw_d.Object.cantidad        [ll_fdw_d] = ids_art_a_vender.Object.cant_procesada   [ll_inicio]
			 ist_datos.dw_d.Object.descuento		   [ll_fdw_d] = ids_art_a_vender.Object.descuento		   [ll_inicio]	
			 ist_datos.dw_d.Object.cant_proyect	   [ll_fdw_d] = ids_art_a_vender.Object.cant_proyect	   [ll_inicio]
			 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ist_datos.string3
			 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
			 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
			 ist_datos.dw_d.Object.confin				[ll_fdw_d] = ids_art_a_vender.Object.confin 			   [ll_inicio]
			 ist_datos.dw_d.Object.matriz_cntbl	   [ll_fdw_d] = ids_art_a_vender.object.matriz_cntbl     [ll_inicio]
			 ist_datos.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = ids_art_a_vender.object.tipo_cred_fiscal [ll_inicio]
			 ist_datos.dw_d.Object.rubro				[ll_fdw_d] = ids_art_a_vender.object.rubro			   [ll_inicio]
			 ist_datos.dw_d.Object.flag				[ll_fdw_d] = 'G'
			 
			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
         
			 
			 ist_datos.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
		 END IF	
	 END IF
	 

NEXT

	
Return ll_found
end function

public subroutine wf_insert_art_ov (string as_orden_venta);Long   ll_fdw_d,j,ll_found
String ls_soles, ls_dolares ,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
		 ls_item , ls_rubro   ,ls_clase

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 

//* Tipo de Documento Orden de Venta *//
SELECT doc_ov
  INTO :ls_tipo_doc
  FROM logparam
 WHERE (reckey = '1');
//***********************************// 

FOR j=1 TO dw_2.Rowcount()
	 
 
	 ls_cod_art    = dw_2.object.cod_art    [j] 
	 ls_cod_moneda = dw_2.object.cod_moneda [j] 
	 
	 ls_expresion  = 'cod_art ='+"'"+ls_cod_art+"'"
	 ll_found      = ist_datos.dw_d.find(ls_expresion,1,ist_datos.dw_d.rowcount())
	 
	 IF ll_found > 0 THEN 
		 Messagebox('Aviso','Articulo Nº :'+ls_cod_art+' ya Ha sido tomado en Cuenta')
	 ELSE
	    IF ist_datos.dw_d.triggerevent ('ue_insert') > 0 THEN
           
			 /*busca rubro de articulo*/ 
			 select ats.factura_rubro into :ls_rubro from articulo art,articulo_sub_categ ats
			  where art.sub_cat_art = ats.cod_sub_cat and
			  		  art.cod_art		= :ls_cod_art		;
			   
			 /**/
			  
			  
		    IF ls_cod_moneda = ist_datos.string3 THEN
			    ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = dw_2.Object.precio_unit [j]				
			 ELSEIF ls_cod_moneda = ls_soles      THEN
				 ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = Round(dw_2.Object.precio_unit [j] / ist_datos.db1,6)	
			 ELSEIF ls_cod_moneda = ls_dolares    THEN
				 ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = Round(dw_2.Object.precio_unit [j] * ist_datos.db1,6)					
			 END IF
			 
			 ist_datos.dw_d.Object.tipo_ref        [ll_fdw_d] = ls_tipo_doc
			 ist_datos.dw_d.Object.nro_ref         [ll_fdw_d] = as_orden_venta
			 ist_datos.dw_d.Object.cod_art         [ll_fdw_d] = dw_2.Object.cod_art 		 [j]
			 ist_datos.dw_d.Object.descripcion     [ll_fdw_d] = dw_2.Object.nom_articulo   [j]
			 ist_datos.dw_d.Object.cantidad        [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_d.Object.descuento		   [ll_fdw_d] = dw_2.Object.decuento		 [j]	
			 ist_datos.dw_d.Object.cant_proyect	   [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ist_datos.string3
			 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
			 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
			 ist_datos.dw_d.Object.confin				[ll_fdw_d] = dw_2.Object.confin 			 [j]
			 ist_datos.dw_d.Object.matriz_cntbl	   [ll_fdw_d] = dw_2.object.matriz_cntbl   [j]
			 ist_datos.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = dw_2.object.dl27400        [j]
			 ist_datos.dw_d.Object.rubro				[ll_fdw_d] = ls_rubro
			 
			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
			 
			 ist_datos.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			 
			 
		 END IF	
	 END IF	
NEXT


end subroutine

public subroutine wf_insert_det_warrant ();Datawindow ldw_det
Long   ll_inicio,ll_row,ll_item_lib,ll_item_prod
String ls_embarque,ls_nro_lote,ls_cod_art,ls_nom_art,ls_expresion
Decimal {4} ldc_cantidad,ldc_cantidad_warrant

ldw_det = ist_datos.dw_c

//recupera datos del detalle de liberacion
ll_item_lib          = ist_datos.dw_d.object.item_lib [ist_datos.dw_d.Getrow()]
ldc_cantidad_warrant = dw_master.object.cantidad      [dw_master.getrow()]

For ll_inicio = 1 to dw_2.rowcount()
	 //recupero datos a insertar
	 ll_item_prod = dw_2.object.item_prod     [ll_inicio]
	 ls_embarque  = dw_2.object.nro_embarque  [ll_inicio]
	 ls_nro_lote  = dw_2.object.nro_lote	   [ll_inicio]	
	 ldc_cantidad = dw_2.object.cantidad_disp [ll_inicio]
	 ls_cod_art	  = dw_2.object.cod_art		   [ll_inicio]
	 ls_nom_art	  = dw_2.object.nom_articulo  [ll_inicio]	
	 
	 //validar que no exista
	 ls_expresion =   'item_lib     = '+ Trim(String(ll_item_lib)) + ' and '&
						  +'item_prod    = '+ Trim(String(ll_item_prod))+ ' and '&
						  +'nro_lote_emb = '+"'"+ls_nro_lote+"'"			+ ' and '&
	 					  +'nro_embarque = '+"'"+ls_embarque+"'"		   
							
							
   // Messagebox('ls_expresion',ls_expresion)							
	 ldw_det.triggerevent ('ue_insert')
	 ll_row = ldw_det.getrow()
	 ldw_det.object.nro_warrant  		 [ll_row] = ist_datos.string1
	 ldw_det.object.cod_art				 [ll_row] = ls_cod_art
	 ldw_det.object.nom_articulo		 [ll_row] = ls_nom_art
	 ldw_det.object.item_lib	  		 [ll_row] = ll_item_lib
	 ldw_det.object.item_prod 	  		 [ll_row] = ll_item_prod
	 ldw_det.object.nro_embarque 		 [ll_row] = ls_embarque
	 ldw_det.object.nro_lote_emb 		 [ll_row] = ls_nro_lote 
	 ldw_det.object.cantidad_liberado [ll_row] = ldc_cantidad
	 ldw_det.object.cantidad			 [ll_row] = ldc_cantidad_warrant
	 
Next	
	 
end subroutine

public subroutine wf_insert_det_deuda_financiera ();String ls_nro_registro ,ls_td_concepto
Long   ll_inicio,ll_nro_cuota,ll_row,ll_item

dw_2.Accepttext()


//RECUPERAR NRO DE ITEM
ll_row  = ist_datos.long1
ll_item = ist_datos.dw_d.object.item [ll_row]


//inserto detalle en tabla temporal
For ll_inicio = 1 to dw_2.rowcount()
	 ls_nro_registro = dw_2.object.nro_registro 		   [ll_inicio]
	 ls_td_concepto  = dw_2.object.tipo_deuda_concepto [ll_inicio]
	 ll_nro_cuota	  = dw_2.object.nro_cuota			   [ll_inicio]
	 
//	 ls_cencos		  = dw_2.object.cencos				   [1]	
//	 ls_cnta_prsp	  = dw_2.object.cnta_prsp			   [1]
	 
	 Update tt_fin_deuda_financiera
	    Set nro_registro = :ls_nro_registro,tipo_deuda_concepto = :ls_td_concepto ,
		 	  nro_cuota		= :ll_nro_cuota   ,item_cja				= :ll_item
	  Where (nro_registro 		  = :ls_nro_registro	) and
	  		  (tipo_deuda_concepto = :ls_td_concepto	) and
			  (nro_cuota			  = :ll_nro_cuota		) and
			  (item_cja				  = :ll_item			)  ;
			  
	  if sqlca.sqlnrows = 0 then		  
		  Insert Into tt_fin_deuda_financiera
		  (nro_registro,tipo_deuda_concepto,nro_cuota,item_cja)
		  Values
	 	  (:ls_nro_registro,:ls_td_concepto,:ll_nro_cuota,:ll_item) ;
	 
		  IF SQLCA.SQLCode = -1 THEN 
       	  MessageBox('SQL error', SQLCA.SQLErrText)
		 	  ist_datos.bret = FALSE
		 	  GOTO SALIDA	 			  
	 	  END IF	
			
	  end if
	 

	 ist_datos.bret = TRUE
	//devolver valor en verdadero para activar control de update

Next	

SALIDA:

/*


if dw_2.Rowcount() > 1 then
	Messagebox('Aviso','Solo Puede Seleccionar un tipo de Concepto de la deuda Seleccionada')
	Return
elseif dw_2.Rowcount() = 0 then
	Messagebox('Aviso','Debe Seleccionar un tipo de Concepto de la deuda Seleccionada')
	Return
end if

//datos a registrar












//verificar tipo de documento
ls_flag_provisionado = ist_datos.dw_d.object.flag_provisionado [ll_row]


					
ist_datos.dw_d.object.nro_registro_df     [ll_row] = ls_nro_registro
ist_datos.dw_d.object.tipo_deuda_concepto [ll_row] = ls_td_concepto
ist_datos.dw_d.object.nro_cuota_df			[ll_row] = ll_nro_cuota

//colocar partida presupuestal
if ls_flag_provisionado = 'N' then
	ist_datos.dw_d.object.cencos    [ll_row] = ls_cencos
	ist_datos.dw_d.object.cnta_prsp [ll_row] = ls_cnta_prsp
end if


*/
end subroutine

public subroutine wf_cuotas_deudas_financieras ();//*verificar que pago este vinculado a deuda financiera*//
String ls_origen_cb,ls_nro_deuda,ls_expresion  ,ls_concepto_deuda,ls_descripcion,&
		 ls_tipo_doc  ,ls_nro_doc ,ls_flag_estado,ls_cencos		  ,ls_cnta_prsp
Long   ll_nro_reg_cb,ll_item_cb,ll_found,ll_nro_cuota,ll_row_ins
Decimal {2} ldc_monto_proy
Date			ld_fecha
dwobject dwo_1
dwItemStatus ldis_status


ldis_status = ist_datos.dw_d.GetItemStatus(ist_datos.long1,0,Primary!)

IF ldis_status <> NewModified! THEN
	//VEIRFICAR SI REGISTRO ES NUEVO
	ls_origen_cb  = ist_datos.dw_d.object.origen			[ist_datos.long1]
	ll_nro_reg_cb = ist_datos.dw_d.object.nro_registro [ist_datos.long1]
	ll_item_cb	  = ist_datos.dw_d.object.item			[ist_datos.long1]

	dwo_1 = dw_master.object.nro_registro 

	//seleccionar deuda vinculada
	select nro_registro into :ls_nro_deuda
	  from deuda_fin_det_cja_ban_det
	 where (origen 			 = :ls_origen_cb  ) and
	 		 (nro_registro_cja = :ll_nro_reg_cb ) and
			 (item_cja			 = :ll_item_cb	  ) 
	group by nro_registro ;
		  


	//buscar en dw cabecera deuda
	ls_expresion = 'nro_registro = '+"'"+ls_nro_deuda+"'"


	ll_found = dw_master.find(ls_expresion,1,dw_master.rowcount())

	if ll_found = 0 then
		Messagebox('Aviso','Deuda Financiera No Existe , Comuniquese Con Sistemas! ')
		Return
	else
		//dispara evento	clicked!	
		dw_master.Event Clicked(0,0,ll_found,dwo_1)
	end if


	DECLARE c_registro_deudas CURSOR FOR  
	 SELECT dfcb.nro_registro ,dfcb.tipo_deuda_concepto ,dfcb.nro_cuota ,dfc.descripcion   ,
	        dfd.tipo_doc_ref  ,dfd.nro_doc_ref          ,dfd.monto_proy ,dfd.fec_vcto_proy ,
	        '1' as flag_estado,dfd.cencos               ,dfd.cnta_prsp   
	   FROM deuda_fin_det_cja_ban_det dfcb,deuda_financiera_det dfd ,deuda_financ_concepto dfc
	  WHERE (dfcb.nro_registro        = dfd.nro_registro        ) and
	        (dfcb.tipo_deuda_concepto = dfd.tipo_deuda_concepto ) and
	        (dfcb.nro_cuota           = dfd.nro_cuota           ) and
	        (dfcb.tipo_deuda_concepto = dfc.tipo_deuda_concepto ) and
	        (dfcb.origen 			    = :ls_origen_cb           ) and
	  		  (dfcb.nro_registro_cja    = :ll_nro_reg_cb          ) and
	        (dfcb.item_cja			    = :ll_item_cb	            ) ;  
	  
	OPEN c_registro_deudas ;
	DO
	// Lee datos de cursor
	FETCH c_registro_deudas into :ls_nro_deuda   ,:ls_concepto_deuda,:ll_nro_cuota  ,
										  :ls_descripcion	,:ls_tipo_doc		 ,:ls_nro_doc	  ,
										  :ldc_monto_proy ,:ld_fecha			 ,:ls_flag_estado,
										  :ls_cencos		,:ls_cnta_prsp ;									  
		

	IF SQLCA.SQLCODE = 100 THEN EXIT
	
		//elimina e inserta en dw detalle
		delete from deuda_fin_det_cja_ban_det
		 where (nro_registro        = :ls_nro_deuda      ) and
		 		 (tipo_deuda_concepto = :ls_concepto_deuda ) and
				 (nro_cuota           = :ll_nro_cuota      ) ;
	
	
		//inserta dw detalle
		ll_row_ins = dw_2.InsertRow(0)
		dw_2.object.nro_cuota			  [ll_row_ins] = ll_nro_cuota
		dw_2.object.tipo_deuda_concepto [ll_row_ins] = ls_concepto_deuda
	   dw_2.object.descripcion			  [ll_row_ins] = ls_descripcion
		dw_2.object.tipo_doc_ref		  [ll_row_ins] = ls_tipo_doc
		dw_2.object.nro_doc_ref 		  [ll_row_ins] = ls_nro_doc
		dw_2.object.monto_proy			  [ll_row_ins] = ldc_monto_proy
		dw_2.object.fec_vcto_proy		  [ll_row_ins] = ld_fecha
	   dw_2.object.flag_estado			  [ll_row_ins] = ls_flag_estado
	   dw_2.object.nro_registro		  [ll_row_ins] = ls_nro_deuda
   	dw_2.object.cencos				  [ll_row_ins] = ls_cencos
	   dw_2.object.cnta_prsp           [ll_row_ins] = ls_cnta_prsp
	
		// Continua proceso
		LOOP WHILE TRUE
	CLOSE c_registro_deudas ;
END IF
end subroutine

public subroutine wf_insert_item_grmp (string as_guia_rec_mp, string as_cod_moneda, string as_tipo_doc_grmp);// Función para ingresar 

Long    	ll_fdw_d, ll_j, ll_row_master, ll_found, ll_row
String  	ls_soles, ls_dolares, ls_item, ls_moneda_ord, ls_origen_ref, &
			ls_nro_ref, ls_expresion, ls_origen_mov, ls_nro_vale, ls_tipo_mov_alm, &
			ls_moneda_fap, ls_cod_moneda
Decimal 	{2} ldc_descuento

u_dw_abc ldw_detail, ldw_master, ldw_refer
dw_2.Accepttext( )

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
FROM logparam   
WHERE reckey = '1'   ;
//***********************************// 

ldw_detail = ist_datos.dw_d	// detalle de cuentas por pagar
ldw_master = ist_datos.dw_m	// master
ldw_refer  = ist_datos.dw_c   // Referencias

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN

ll_row_master = dw_master.Getrow()

ls_origen_ref = dw_master.Object.origen  		[ll_row_master]
ls_nro_ref	  = dw_master.Object.cod_guia_rec[ll_row_master]	

FOR ll_j = 1 TO dw_2.rowcount( )
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
 		ll_fdw_d  = ldw_detail.il_row
		 /*Datos del Registro Modificado*/
		 ist_datos.w1.Dynamic Function wf_estado_prea()
		 /*moneda cabecera*/
		 ls_moneda_ord = ldw_master.object.cod_moneda [1]
	
		 IF as_cod_moneda = ls_moneda_ord THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.saldo[ll_j],2)
		 ELSEIF as_cod_moneda = ls_soles      THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.saldo[ll_j] / ist_datos.db1,2)	
		 ELSEIF as_cod_moneda = ls_dolares    THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.saldo[ll_j] * ist_datos.db1,2)					
		 END IF

		 ist_datos.dw_d.Object.cod_art		[ll_fdw_d] = dw_2.object.cod_art		[ll_j]
		 ist_datos.dw_d.Object.descripcion  [ll_fdw_d] = dw_2.Object.desc_art   [ll_j]
		 ist_datos.dw_d.Object.item_ref	   [ll_fdw_d] = dw_2.Object.item   		[ll_j]
		 ist_datos.dw_d.Object.origen_ref	[ll_fdw_d] = ls_origen_ref
		 ist_datos.dw_d.Object.nro_ref	   [ll_fdw_d] = ls_nro_ref		 
		 ist_datos.dw_d.Object.tipo_ref	   [ll_fdw_d] = as_tipo_doc_grmp
		 ist_datos.dw_d.Object.flag_hab		[ll_fdw_d] = '1'		 
		 ist_datos.dw_d.Object.cantidad     [ll_fdw_d] = dw_2.Object.peso_venta [ll_j]
		 ist_datos.dw_d.Object.precio_unit  [ll_fdw_d] = dw_2.Object.precio		[ll_j]

		 //Recalculo de Impuesto				 
		 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
		 ist_datos.w1.dynamic function wf_generacion_imp(ls_item)
		 
		 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ls_moneda_ord
		 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
		 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
		 ist_datos.dw_d.Modify("importe.Protect='1~tIf(IsNull(flag_hab),0,1)'")
		 ist_datos.titulo = 's'	
		 
		IF WF_insert_ref_grmp(ll_j) <> 1 THEN 
			messagebox('Aviso', 'Se produjo un error a la hora de agregar la referencia')
			RETURN
		END IF
	 END IF
NEXT

end subroutine

public function integer wf_insert_ref_grmp (long al_item);// Función para ingresar las referencias a las GRMP

Long    	ll_j, ll_found, ll_row, ll_row_master
String  	ls_expresion, ls_origen_mov, ls_nro_vale, ls_tipo_mov_alm, &
			ls_moneda_fap, ls_cod_moneda
Decimal 	{2} ldc_descuento

u_dw_abc ldw_detail, ldw_master, ldw_refer

ldw_detail = ist_datos.dw_d	// detalle de cuentas por pagar
ldw_master = ist_datos.dw_m	// master
ldw_refer  = ist_datos.dw_c   // Referencias

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN 0

ll_row_master = dw_master.Getrow()

/**** Ingresar las refencias ****/
ist_datos.dw_c.Accepttext()
ls_moneda_fap 	= ldw_master.object.cod_moneda [1]
ls_cod_moneda 	= dw_master.Object.cod_moneda  [ll_row_master]
ls_origen_mov	= dw_2.object.origen_mov		 [al_item]
ls_nro_vale		= dw_2.object.nro_vale			 [al_item]
ls_tipo_mov_alm= ist_datos.string4

ls_expresion = "origen_ref = '" + ls_origen_mov + "' AND tipo_ref = '" +&
					ls_tipo_mov_alm + "' AND  nro_ref = '" + ls_nro_vale + "'"
ll_found 	 = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 

IF ll_found = 0 THEN // inserta los documentos de referencias
	ll_j = ldw_refer.event ue_insert()
	IF ll_j > 0 THEN	
		ll_row  = ldw_refer.il_row
		ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'P'
		ist_datos.dw_c.Object.origen_ref     [ll_row] = ls_origen_mov
		ist_datos.dw_c.Object.tipo_ref	    [ll_row] = ls_tipo_mov_alm
		ist_datos.dw_c.Object.nro_ref		    [ll_row] = ls_nro_vale 
		ist_datos.dw_c.Object.tasa_cambio    [ll_row] = ist_datos.db1			
		ist_datos.dw_c.Object.cod_moneda	    [ll_row] = ls_moneda_fap
		ist_datos.dw_c.Object.cod_moneda_det [ll_row] = ls_cod_moneda
		ist_datos.dw_c.Object.flab_tabor	    [ll_row] = '3' //Cuentas por Pagar
		ist_datos.dw_c.Object.importe			 [ll_row] = 0.00
		ist_datos.titulo = 's'	
	END IF
END IF

RETURN 1

end function

public subroutine of_opcion11 ();Long 		ll_row_master, ll_found, ll_row, ll_dias_vencimiento
String 	ls_orden_serv, ls_cod_origen, ls_cod_moneda, ls_forma_pago, ls_obs, &
			ls_moneda_fap, ls_fpago_fap, ls_obs_fap, ls_flag_cntr, ls_doc_os, &
			ls_expresion, ls_desc_fpago
Date		ld_fec_presentacion			
u_dw_abc ldw_ref_x_pagar, ldw_master

ldw_ref_x_pagar = ist_datos.dw_c
ldw_master		 = ist_datos.dw_m

ll_row_master = dw_master.Getrow()
ls_orden_serv = dw_master.Object.nro_os 	   		[ll_row_master]
ls_cod_origen = dw_master.Object.cod_origen  		[ll_row_master]
ls_cod_moneda = dw_master.Object.cod_moneda  		[ll_row_master]
ls_forma_pago = dw_master.Object.forma_pago  		[ll_row_master] 
ls_desc_fpago = dw_master.Object.desc_forma_pago  	[ll_row_master] 
ls_obs		  = dw_master.Object.descripcion 		[ll_row_master]	
ll_dias_vencimiento = Integer(dw_master.Object.dias_vencimiento	[ll_row_master]	)

IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
	IF ls_orden_serv <> ist_datos.string2 THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Servicio Diferente a la ya Considerada')
		Return
	END IF
END IF

IF dw_2.Rowcount() > 0 THEN

	/*actualiza datos de factura*/
	ls_moneda_fap = ldw_master.object.cod_moneda  [1]
	ls_obs_fap    = ldw_master.object.descripcion [1]
	ls_flag_cntr  = ldw_master.object.flag_cntr_almacen [1]
	
	IF Isnull(ls_moneda_fap) OR Trim(ls_moneda_fap) = '' THEN
		ldw_master.object.cod_moneda  [1] = ls_cod_moneda
		ls_moneda_fap = ls_cod_moneda
	END IF
	
	//Tomo la forma de pago de la Orden de Servicio
	ldw_master.object.forma_pago  		[1] = ls_forma_pago	
	ldw_master.object.desc_forma_pago  	[1] = ls_desc_fpago
	ldw_master.object.dias_vencimiento 	[1] = ll_dias_vencimiento

	IF Isnull(ls_obs_fap) OR Trim(ls_obs_fap) = '' THEN
		ldw_master.object.descripcion [1] = Mid(ls_obs,1,180)	
	END IF
	
	//Calculo la fecha de vencimiento
	ld_fec_presentacion = Date(ldw_master.object.fecha_presentacion 	[1])
	ldw_master.object.vencimiento 	[1] = RelativeDate(ld_fec_presentacion, ll_dias_vencimiento)
						
	ldw_master.Accepttext()
	
	of_insert_item_os (ls_orden_serv, ls_cod_moneda)
	
	//***Selección de tipo de doc Orden de Servicio***//
	SELECT doc_os
	  INTO :ls_doc_os
	  FROM logparam
	 WHERE reckey = '1' ;
	//***********************************//
	
	ldw_ref_x_pagar.Accepttext()
	
	ls_expresion = "origen_ref = '"+ls_cod_origen+"' AND nro_ref = '" + ls_orden_serv + "'"
	ll_found 	 = ldw_ref_x_pagar.Find(ls_expresion, 1, ldw_ref_x_pagar.RowCount())	 
	
	IF ll_found = 0 THEN
		ll_row = ldw_ref_x_pagar.event ue_insert( )
		if ll_row > 0 then
			ldw_ref_x_pagar.Object.tipo_mov	     [ll_row] = 'P'
			ldw_ref_x_pagar.Object.origen_ref     [ll_row] = ls_cod_origen
			ldw_ref_x_pagar.Object.tipo_ref	     [ll_row] = ls_doc_os
			ldw_ref_x_pagar.Object.nro_ref		  [ll_row] = ls_orden_serv
			ldw_ref_x_pagar.Object.tasa_cambio    [ll_row] = ist_datos.db1			
			ldw_ref_x_pagar.Object.cod_moneda	  [ll_row] = ls_moneda_fap
			ldw_ref_x_pagar.Object.cod_moneda_det [ll_row] = ls_cod_moneda
			ldw_ref_x_pagar.Object.flab_tabor	  [ll_row] = '8' //Orden de Servicio
			ist_datos.titulo = 's'	
		end if
	END IF

END IF



end subroutine

public subroutine of_insert_item_os (string as_orden_os, string as_cod_moneda);Long   		ll_row, ll_j, ll_found, ll_row2
String 		ls_soles, ls_dolares,ls_item,ls_moneda_ord, ls_expresion, ls_cod_imp, &
				ls_signo, ls_proveedor, ls_tipo_doc, ls_nro_doc, ls_cnta_cntbl, &
				ls_desc_cnta, ls_flag_dh_cxp, ls_desc_impuesto
Decimal {2} ldc_descuento, ldc_tasa_imp, ldc_impuesto
u_dw_abc		ldw_detail, ldw_master, ldw_imp_x_pagar
window		lw_1

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 

ldw_detail = ist_datos.dw_d
ldw_master = ist_datos.dw_m
ldw_imp_x_pagar = ist_datos.dw_imp_x_pagar
lw_1		  = ist_datos.lw1

/*moneda cabecera*/
ls_moneda_ord = ldw_master.object.cod_moneda 	[1]
ls_proveedor  = ldw_master.object.cod_relacion  [1]
ls_tipo_doc	  = ldw_master.object.tipo_doc	   [1]
ls_nro_doc	  = ldw_master.object.nro_doc	      [1]
		
FOR ll_j = 1 TO dw_2.Rowcount()
	
	ll_row = ldw_detail.event ue_insert()
	IF  ll_row > 0 THEN
		/*Datos del Registro Modificado*/
		lw_1.function dynamic of_set_estado_prea(TRUE)
		/**/			 
		lw_1.function dynamic of_set_nro_os(as_orden_os)
		
		
		ldc_descuento = dw_2.Object.descuento[ll_j]
		IF Isnull(ldc_descuento) THEN ldc_descuento = 0.00
		
		IF as_cod_moneda = ls_moneda_ord THEN
			ldw_detail.Object.importe	 	[ll_row] = Round(dw_2.Object.importe [ll_j] - ldc_descuento,2)
		ELSEIF as_cod_moneda = ls_soles      THEN
			ldw_detail.Object.importe 		[ll_row] = Round((dw_2.Object.importe [ll_j] - ldc_descuento) / ist_datos.db1,2)	
		ELSEIF as_cod_moneda = ls_dolares    THEN
			ldw_detail.Object.importe 		[ll_row] = Round((dw_2.Object.importe [ll_j] - ldc_descuento ) * ist_datos.db1,2)					
		END IF
		
		ldw_detail.Object.descripcion    [ll_row] = dw_2.Object.descripcion    [ll_j]
		ldw_detail.Object.cantidad       [ll_row] = 1
		ldw_detail.Object.precio_unit    [ll_row] = ldw_detail.Object.importe [ll_row]
		ldw_detail.Object.cencos			[ll_row] = dw_2.Object.cencos			 [ll_j]
		ldw_detail.Object.cnta_prsp		[ll_row] = dw_2.Object.cnta_prsp		 [ll_j]
		ldw_detail.Object.flag_hab			[ll_row] = '1'		 
		ldw_detail.Object.centro_benef	[ll_row] = dw_2.Object.centro_benef	 [ll_j]
		
		ldw_detail.Object.org_os			[ll_row] = dw_2.Object.cod_origen	[ll_j]
		ldw_detail.Object.nro_os			[ll_row] = dw_2.Object.nro_os	 		[ll_j]
		ldw_detail.Object.item_os			[ll_row] = dw_2.Object.nro_item		[ll_j]

		 
		//Recalculo de Impuesto				 
		ls_item = Trim(String(ldw_detail.Object.item  [ll_row]))
		
		//Elimino cualquier impuesto que se haya generado
		ls_expresion = "item = " + ls_item
		ll_found = ldw_imp_x_pagar.find( ls_expresion, 1, ldw_imp_x_pagar.RowCount())
		do while ll_found > 0 
			ldw_imp_x_pagar.DeleteRow( ll_found )
			ll_found = ldw_imp_x_pagar.find( ls_expresion, 1, ldw_imp_x_pagar.RowCount())
		loop
		
		//Ahora inserto los impuestos indicados en la OS
		
		// Primero inserto el impuesto1 si lo hubiera
		ls_cod_imp = dw_2.object.tipo_impuesto[ll_j]
		if not IsNull(ls_cod_imp) and trim(ls_cod_imp) <> '' then
			//Obtengo la tasa
			select it.TASA_IMPUESTO, it.signo,it.cnta_ctbl, it.desc_impuesto, 
					 it.flag_dh_cxp, cc.desc_cnta
				into :ldc_tasa_imp, :ls_signo, :ls_cnta_cntbl, :ls_desc_impuesto,
					:ls_flag_dh_cxp, :ls_desc_cnta
			from impuestos_tipo it,
				  cntbl_cnta	  cc
			where it.cnta_ctbl = cc.cnta_ctbl (+)
			  and tipo_impuesto = :ls_cod_imp;
			
			if SQLCA.SQLCode = 100 then 
				MessageBox('Error', 'No existe tipo de impuesto: ' + ls_cod_imp)
				return
			end if
			
			if IsNull(ldc_tasa_imp) then ldc_tasa_imp = 0
			
			ldc_impuesto = Dec(dw_2.object.tipo_impuesto[ll_j])
			ll_row2 = ldw_imp_x_pagar.event ue_insert( )
			if ll_row2 > 0 then
				ldw_imp_x_pagar.object.cod_relacion		[ll_row2] = ls_proveedor
				ldw_imp_x_pagar.object.tipo_doc			[ll_row2] = ls_tipo_doc
				ldw_imp_x_pagar.object.nro_doc			[ll_row2] = ls_nro_doc
				ldw_imp_x_pagar.object.item				[ll_row2] = ldw_detail.object.item [ll_row]
				ldw_imp_x_pagar.object.tipo_impuesto	[ll_row2] = ls_cod_imp
				ldw_imp_x_pagar.object.tasa_impuesto	[ll_row2] = ldc_tasa_imp
				ldw_imp_x_pagar.object.importe			[ll_row2] = ldc_impuesto
		
				ldw_imp_x_pagar.object.signo				[ll_row2] = ls_signo
				ldw_imp_x_pagar.object.cnta_ctbl			[ll_row2] = ls_cnta_cntbl
				ldw_imp_x_pagar.object.desc_cnta			[ll_row2] = ls_desc_cnta
				ldw_imp_x_pagar.object.flag_dh_cxp		[ll_row2] = ls_flag_dh_cxp
				ldw_imp_x_pagar.object.desc_impuesto	[ll_row2] = ls_desc_impuesto
			end if
		end if
		
		// Seguido inserto el impuesto2 si lo hubiera
		ls_cod_imp = dw_2.object.tipo_impuesto2[ll_j]
		if not IsNull(ls_cod_imp) and trim(ls_cod_imp) <> '' then
			//Obtengo la tasa
			select it.TASA_IMPUESTO, it.signo,it.cnta_ctbl, it.desc_impuesto, 
					 it.flag_dh_cxp, cc.desc_cnta
				into :ldc_tasa_imp, :ls_signo, :ls_cnta_cntbl, :ls_desc_impuesto,
					:ls_flag_dh_cxp, :ls_desc_cnta
			from impuestos_tipo it,
				  cntbl_cnta	  cc
			where it.cnta_ctbl = cc.cnta_ctbl (+)
			  and tipo_impuesto = :ls_cod_imp;
			
			if SQLCA.SQLCode = 100 then 
				MessageBox('Error', 'No existe tipo de impuesto: ' + ls_cod_imp)
				return
			end if
			
			if IsNull(ldc_tasa_imp) then ldc_tasa_imp = 0
			
			ldc_impuesto = Dec(dw_2.object.tipo_impuesto[ll_j])
			ll_row2 = ldw_imp_x_pagar.event ue_insert( )
			if ll_row2 > 0 then
				ldw_imp_x_pagar.object.cod_relacion		[ll_row2] = ls_proveedor
				ldw_imp_x_pagar.object.tipo_doc			[ll_row2] = ls_tipo_doc
				ldw_imp_x_pagar.object.nro_doc			[ll_row2] = ls_nro_doc
				ldw_imp_x_pagar.object.item				[ll_row2] = ldw_detail.object.item [ll_row]
				ldw_imp_x_pagar.object.tipo_impuesto	[ll_row2] = ls_cod_imp
				ldw_imp_x_pagar.object.tasa_impuesto	[ll_row2] = ldc_tasa_imp
				ldw_imp_x_pagar.object.importe			[ll_row2] = ldc_impuesto
				ldw_imp_x_pagar.object.signo				[ll_row2] = ls_signo
				ldw_imp_x_pagar.object.cnta_ctbl			[ll_row2] = ls_cnta_cntbl
				ldw_imp_x_pagar.object.desc_cnta			[ll_row2] = ls_desc_cnta
				ldw_imp_x_pagar.object.flag_dh_cxp		[ll_row2] = ls_flag_dh_cxp
				ldw_imp_x_pagar.object.desc_impuesto	[ll_row2] = ls_desc_impuesto
			end if
		end if

		//Recalculo los impuestos
		lw_1.function dynamic of_generacion_imp (ls_item)	
		
		ldw_master.Object.moneda_det	    [1] 	= ls_moneda_ord
		ldw_master.Object.tasa_cambio_det [1] 	= ist_datos.db1
		ldw_master.Object.cod_relacion_det[1] 	= ist_datos.string1
		ldw_detail.Modify("importe.Protect='1~tIf(IsNull(flag_hab),0,1)'")
		ist_datos.titulo = 's'	
		
	END IF	
NEXT


end subroutine

public function integer of_opcion10 ();Long 		ll_found, ll_row, ll_i
String	ls_nro_oc, ls_origen_oc, ls_moneda_oc, ls_fpago_oc, &
			ls_desc_fpago_oc, ls_obs_oc, ls_moneda_fap, ls_fpago_fap, ls_obs_fap, &
			ls_flag_cntr,  ls_expresion

String 	ls_tipo_impuesto1, ls_tipo_impuesto2

u_dw_abc ldw_master, ldw_impuestos, ldw_referencia		
Long		ll_dias_venc_oc
Date		ld_fec_presentacion
Decimal	ldc_monto_oc

ldw_master 		 = ist_datos.dw_m
ldw_impuestos	 = ist_datos.dw_i
ldw_referencia	 = ist_datos.dw_c

//Valido
IF dw_2.Rowcount() = 0 THEN 
	Messagebox('Aviso','Debe Seleccionar al menos el detalle de una Orden de Compra')
	return -1
end if

//Inicializo el acumulador

ldw_master.Accepttext()
ldw_referencia.Accepttext()

//Obtengo los datos de la Orden de Compra
ls_moneda_fap = ldw_master.object.cod_moneda  			[1]
ls_obs_fap    = ldw_master.object.descripcion 			[1]
ls_flag_cntr  = ldw_master.object.flag_cntr_almacen 	[1]
ls_fpago_fap  = ldw_master.object.forma_pago 			[1]

IF Isnull(ls_flag_cntr) OR Trim(ls_flag_cntr) = '' THEN
	ls_flag_cntr = '1'
END IF

for ll_i = 1 to dw_2.RowCount()
	
	/*actualiza datos de factura*/
	ls_nro_oc 			= dw_2.Object.nro_oc 	  					[ll_i]
	ls_origen_oc   	= dw_2.Object.cod_origen  					[ll_i]
	ls_moneda_oc	 	= dw_2.Object.cod_moneda  					[ll_i]
	ls_fpago_oc	 		= dw_2.Object.forma_pago  					[ll_i] 
	ls_desc_fpago_oc	= dw_2.Object.desc_forma_pago  			[ll_i] 
	ls_obs_oc			= dw_2.Object.observacion 					[ll_i]
	ldc_monto_oc		= Dec(dw_2.Object.monto_total 			[ll_i])
	ll_dias_venc_oc 	= Integer(dw_2.Object.dias_vencimiento [ll_i])
	
	IF Isnull(ls_moneda_fap) OR Trim(ls_moneda_fap) = '' THEN
		
		ldw_master.object.cod_moneda  [ldw_master.getRow()] = ls_moneda_oc
		ls_moneda_fap = ls_moneda_oc
		
	elseif trim(ls_moneda_fap) <> trim(ls_moneda_oc) then
		/*gnvo_app.of_mensaje_error( "No se pueden seleccionar Ordenes de Compra de Diferentes moneda. Por favor verifique!" &
									+ "~r~nNro OC: " + ls_nro_oc &
									+ "~r~nMoneda OC: " + ls_moneda_oc &
									+ "~r~nMoneda FAP: " + ls_moneda_fap
		return -1*/
	END IF
	
	if not(Isnull(ls_fpago_fap) OR Trim(ls_fpago_fap) = '') and trim(ls_fpago_fap) <> trim(ls_fpago_oc) then
		
		gnvo_app.of_mensaje_error( "No se pueden seleccionar Ordenes de Compra de Diferentes Formas de Pago. Por favor verifique!" &
									+ "~r~nNro OC: " + ls_nro_oc &
									+ "~r~Forma de Pago OC: " + ls_fpago_oc &
									+ "~r~Forma de Pago FAP: " + ls_fpago_fap)
		return -1
	END IF

	IF Isnull(ls_fpago_fap) OR Trim(ls_fpago_fap) = '' THEN
		
		ldw_master.object.forma_pago  		[1] = ls_fpago_oc
		ldw_master.object.desc_forma_pago  	[1] = ls_desc_fpago_oc
		
		//CAlculando la fecha de vencimiento
		ld_fec_presentacion = Date(ldw_master.object.fecha_emision[1])
		ldw_master.object.vencimiento 		[1] = RelativeDate(ld_fec_presentacion, ll_dias_venc_oc)
		ldw_master.object.dias_vencimiento 	[1] = ll_dias_venc_oc
	
		ls_fpago_fap = ls_fpago_oc
		
	end if
	
	
	//La Observaciones se juntan de todas las Ordenes de compra
	IF Isnull(ls_obs_fap) OR Trim(ls_obs_fap) = '' THEN
		ls_obs_fap = ls_obs_oc
	else
		ls_obs_fap += "~r~n" + ls_obs_oc
	END IF
	ldw_master.object.descripcion [1] = Mid(ls_obs_fap,1,180)	
	
	
	//Esta insercion debe ser por la fila
	ldc_monto_oc = of_insert_art_oc (ll_i)
	
	
	//Busco para añadir el registro en referencia
	ls_expresion = "origen_ref = '" + ls_origen_oc + "' AND nro_ref = '" + ls_nro_oc + "'"
	ll_found 	 = ldw_referencia.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 
	
	IF ll_found = 0 THEN
		ll_row = ldw_referencia.event ue_insert()
		
		IF ll_row > 0 THEN
			
			
			ldw_referencia.Object.tipo_mov	    [ll_row] = 'P'
			ldw_referencia.Object.origen_ref     [ll_row] = ls_origen_oc
			ldw_referencia.Object.tipo_ref	    [ll_row] = gnvo_app.is_doc_oc
			ldw_referencia.Object.nro_ref		    [ll_row] = ls_nro_oc
			ldw_referencia.Object.tasa_cambio    [ll_row] = ist_datos.db1			
			ldw_referencia.Object.cod_moneda	    [ll_row] = ls_moneda_fap
			ldw_referencia.Object.cod_moneda_det [ll_row] = ls_moneda_oc
			ldw_referencia.Object.importe 		 [ll_row] = ldc_monto_oc
			ldw_referencia.Object.flab_tabor	    [ll_row] = '7' //Orden de Compra
			
			ist_datos.titulo = 's'	
			
		END IF
	else
		ldc_monto_oc += Dec(ldw_referencia.Object.importe 		 [ll_row])
		ldw_referencia.Object.importe 		 [ll_row] = ldc_monto_oc
	END IF

next



return 1

end function

public function integer of_opcion3 ();Long 		ll_count, ll_row
u_dw_abc ldw_1

ldw_1 = ist_datos.dw_m

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
end if

IF ll_count = 1 THEN
	ll_row = ldw_1.GetRow()
	IF ll_row = 0 THEN RETURN 0
	ldw_1.object.confin 		  [ll_row] = dw_2.Object.confin		  [1]
	
	if ldw_1.of_Existecampo( "matriz_cntbl") then
		ldw_1.object.matriz_cntbl [ll_row] = dw_2.Object.matriz_cntbl [1]
	end if
	
	
	if ldw_1.of_Existecampo( "desc_confin") then
		ldw_1.object.desc_confin [ll_row] = dw_2.Object.desc_confin [1]
	end if
	
	ist_datos.titulo = 's'
END IF


return 1
end function

public function integer of_opcion15 ();Long 		ll_count, ll_row
ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto de Flujo de Caja')
	Return 0
end if

IF ll_count = 1 THEN
	ist_datos.txt_Codigo.text 			= dw_2.Object.cod_flujo_caja	[1]
	ist_datos.st_descripcion.text 	= dw_2.Object.descripcion		[1]
	
	ist_datos.titulo = 's'
END IF


return 1
end function

public function integer of_opcion16 ();Long 		ll_count, ll_row, ll_i
u_dw_abc ldw_1

ldw_1 = ist_datos.dw_m

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto de Flujo de Caja')
	Return 0
end if

IF ll_count = 1 THEN
	ll_row = ldw_1.GetRow()
	IF ll_row = 0 THEN RETURN 0
	ldw_1.object.cod_flujo_caja  [ll_row] = dw_2.Object.cod_flujo_caja		  [1]
	ldw_1.object.desc_flujo_caja [ll_row] = dw_2.Object.desc_flujo_caja		  [1]
	
	//Consulto al usuario para que el concepto de flujo de caja sea para el resto de registros
	if MessageBox('Aviso', 'Desea colocar esta descripción a todos los items ' &
								+ 'restantes del voucher?', Information!, YesNo!, 2) = 1 then
		
		for ll_i = ll_row + 1 to ldw_1.RowCount()
			ldw_1.object.cod_flujo_caja 	[ll_i] = dw_2.Object.cod_flujo_caja		[1]
			ldw_1.object.desc_flujo_caja 	[ll_i] = dw_2.Object.desc_flujo_caja	[1]
			
		next
		
	end if
				
	ist_datos.titulo = 's'
END IF

return 1
end function

public function decimal of_insert_art_oc (long al_row);Long   	ll_found, ll_row
String 	ls_cod_art, ls_moneda_oc,ls_expresion, &
		 	ls_item , ls_moneda_fap ,ls_flag_cntrl_alm, ls_tipo_impuesto1, &
			ls_tipo_impuesto2, ls_signo, ls_cnta_cntbl, ls_flag_dh, ls_flag
Decimal 	ldc_descuento, ldc_precio_unit, ldc_tipo_cambio, ldc_impuesto1, ldc_impuesto2, &
			ldc_tasa, ldc_cantidad, ldc_importe, ldc_tcambio_euro, ldc_imp_eur_sol, &
			ldc_punit_eur_sol, ldc_impuesto

date		ld_fec_emision
u_dw_abc		ldw_master, ldw_detail, ldw_impuestos
Window		lw_1


if al_row = 0 then return 0

ldw_master 		 = ist_datos.dw_m
ldw_detail 		 = ist_datos.dw_d
ldw_impuestos	 = ist_datos.dw_i
lw_1				 = ist_datos.lw_1

//Inicializo el acumulador
ldc_importe = 0

//Obtengo la tasa de cambio
ldc_tipo_cambio 	= Dec(ldw_master.object.tasa_cambio 	[1])
ld_fec_emision 	= Date(ldw_master.object.fecha_emision	[1])

//Obtengo la moneda de la factura
ls_moneda_fap = ldw_master.object.cod_moneda [ldw_master.GetRow()] //registro de cabecera a facturar

//datos para controlar almacen
ls_flag_cntrl_alm = ldw_master.object.flag_cntr_almacen [1] 

if isnull(ls_flag_cntrl_alm) or trim(ls_flag_cntrl_alm) = '' then
	ls_flag_cntrl_alm = '1'
end if


//Inserto el registro 
ll_row = ldw_detail.event ue_insert()

IF ll_row > 0 THEN
	ls_cod_art    = dw_2.object.cod_art    [al_row] 
	ls_moneda_oc  = dw_2.object.cod_moneda [al_row] 
	ls_flag		  = dw_2.object.flag 		[al_row] 
	
	//Si es la moneda es euros entonces ya obtengo de una vez el tipo de cambio del euro
	IF trim(ls_moneda_oc) = trim(gnvo_app.is_euros) THEN
		ldc_tcambio_euro = gnvo_app.of_tasa_cambio_euro(ld_fec_emision)
	end if
	
	ldc_descuento = Dec(dw_2.Object.descuento[al_row])
	IF Isnull(ldc_descuento) THEN ldc_descuento = 0.00
	
	ldc_precio_unit = Dec(dw_2.Object.precio_unit [al_row])
	IF Isnull(ldc_precio_unit) THEN ldc_precio_unit = 0.00
	
	ldc_cantidad = Dec(dw_2.Object.cant_ingresada [al_row])
	IF Isnull(ldc_cantidad) THEN ldc_cantidad = 0.00
	 
	IF ls_moneda_fap = ls_moneda_oc     THEN
		ldw_detail.Object.importe 		[ll_row] = Round((ldc_precio_unit - ldc_descuento) * ldc_cantidad,2)
		ldw_detail.Object.precio_unit [ll_row] = ldc_precio_unit
		
		//Añado al acumulador
		ldc_importe += Round((ldc_precio_unit - ldc_descuento) * ldc_cantidad,2)
		
	ELSEIF ls_moneda_oc = gnvo_app.is_soles      THEN
		
		ldw_detail.Object.importe 		[ll_row] = Round((ldc_precio_unit - ldc_descuento) * ldc_cantidad / ldc_tipo_cambio,2)
		ldw_detail.Object.precio_unit [ll_row] = ldc_precio_unit / ldc_tipo_cambio

		//Añado al acumulador
		ldc_importe += Round((ldc_precio_unit - ldc_descuento) * ldc_cantidad / ldc_tipo_cambio,2)
		
	ELSEIF ls_moneda_oc = gnvo_app.is_dolares THEN
		
		ldw_detail.Object.importe 		[ll_row] = Round((ldc_precio_unit - ldc_descuento) * ldc_cantidad * ldc_tipo_cambio ,2)					
		ldw_detail.Object.precio_unit [ll_row] = ldc_precio_unit * ldc_tipo_cambio

		//Añado al acumulador
		ldc_importe += Round((ldc_precio_unit - ldc_descuento) * ldc_cantidad * ldc_tipo_cambio ,2)
	
	ELSEIF trim(ls_moneda_oc) = trim(gnvo_app.is_euros) THEN
		
		ldc_imp_eur_sol 	= (ldc_precio_unit - ldc_descuento) * ldc_cantidad * ldc_tcambio_euro
		ldc_punit_eur_sol	= ldc_precio_unit * ldc_tcambio_euro
		
		if ls_moneda_fap = gnvo_app.is_soles then
			ldw_detail.Object.importe 		[ll_row] = round(ldc_imp_eur_sol,2)
			ldw_detail.Object.precio_unit [ll_row] = ldc_punit_eur_sol

			//Añado al acumulador
			ldc_importe += ldc_imp_eur_sol
		else
			ldw_detail.Object.importe 		[ll_row] = round(ldc_imp_eur_sol / ldc_tipo_cambio,2)
			ldw_detail.Object.precio_unit [ll_row] = ldc_punit_eur_sol / ldc_tipo_cambio

			//Añado al acumulador
			ldc_importe += (ldc_imp_eur_sol / ldc_tipo_cambio)
		end if
		
	END IF
	 
	ldw_detail.Object.cod_art        [ll_row] = dw_2.Object.cod_art 		  	[al_row]
	ldw_detail.Object.descripcion    [ll_row] = dw_2.Object.desc_Art   		[al_row]
	ldw_detail.Object.cantidad       [ll_row] = dw_2.Object.cant_ingresada 	[al_row]
	ldw_detail.Object.cant_ingresada [ll_row] = dw_2.Object.cant_ingresada 	[al_row]
	ldw_detail.Object.cencos			[ll_row] = dw_2.Object.cencos			  	[al_row]
	ldw_detail.Object.cnta_prsp		[ll_row] = dw_2.Object.cnta_prsp		  	[al_row]
	ldw_detail.Object.centro_benef	[ll_row] = dw_2.Object.centro_benef	  	[al_row]
	ldw_detail.Object.flag_hab			[ll_row] = '1'
	
	ldw_detail.Object.org_oc			[ll_row] = dw_2.Object.cod_origen	  	[al_row]
	ldw_detail.Object.doc_oc			[ll_row] = dw_2.Object.tipo_Doc		  	[al_row]
	ldw_detail.Object.nro_oc			[ll_row] = dw_2.Object.nro_doc		  	[al_row]
	ldw_detail.Object.item_oc			[ll_row] = dw_2.Object.nro_mov		  	[al_row]
	
	//
	ldw_detail.Object.centro_benef	[ll_row] = dw_2.Object.centro_benef	  	[al_row]
	
	if ls_flag = 'N' then
		ldw_detail.Object.org_am			[ll_row] = dw_2.Object.org_am			  	[al_row]
		ldw_detail.Object.nro_am			[ll_row] = dw_2.Object.nro_am			  	[al_row]
		ldw_detail.Object.nro_Vale			[ll_row] = dw_2.Object.nro_vale		  	[al_row]
	else
		ldw_detail.Object.nro_vale_trans	[ll_row] = dw_2.Object.nro_Vale_trans 	[al_row]
		ldw_detail.Object.item_vale_trans[ll_row] = dw_2.Object.item_vale_trans	[al_row]
	end if
	
	//Recalculo de Impuesto				 
	ls_item = Trim(String(ldw_detail.Object.item  [ll_row]))
	
	ls_tipo_impuesto1 = dw_2.Object.tipo_impuesto1	[al_row]
	ls_tipo_impuesto2 = dw_2.Object.tipo_impuesto2	[al_row]
	
	ldc_impuesto1 = Dec(dw_2.Object.impuesto 			[al_row])
	ldc_impuesto2 = Dec(dw_2.Object.impuesto2 		[al_row])
	ldc_cantidad  = Dec(dw_2.Object.cant_ingresada 	[al_row])
	
	if Not IsNull(ls_tipo_impuesto1) and ls_tipo_impuesto1 <> "" then
		
		ls_expresion = "item=" + ls_item + " and tipo_impuesto='" + ls_tipo_impuesto1 + "'"
		ll_row = ldw_impuestos.Find(ls_expresion, 1, ldw_impuestos.RowCount())
		if ll_row = 0 then ll_row = ldw_impuestos.event ue_insert()
	
		if ll_row > 0 then
			//Obtengo la tasa de impuesto
			select tasa_impuesto, signo, cnta_ctbl, flag_dh_cxp
				into :ldc_tasa, :ls_signo, :ls_cnta_cntbl, :ls_flag_dh
			from impuestos_tipo
			where tipo_impuesto = :ls_tipo_impuesto1;
			
			ldw_impuestos.object.item				[ll_row] = Long(ls_item)
			ldw_impuestos.object.tipo_impuesto	[ll_row] = ls_tipo_impuesto1
			ldw_impuestos.object.tasa_impuesto	[ll_row] = ldc_tasa
			ldw_impuestos.object.cnta_ctbl		[ll_row] = ls_cnta_cntbl
			ldw_impuestos.object.signo				[ll_row] = ls_signo
			ldw_impuestos.object.flag_dh_cxp		[ll_row] = ls_flag_dh
			
			//Ahora se calcula el impuesto
			ldc_impuesto = ldc_impuesto1 * ldc_cantidad
			
			IF ls_moneda_fap = ls_moneda_oc     THEN
				//No se hace nada
			ELSEIF ls_moneda_oc = gnvo_app.is_soles      THEN
				
				ldc_impuesto = ldc_impuesto / ldc_tipo_cambio
				
			ELSEIF ls_moneda_oc = gnvo_app.is_dolares THEN
				
				ldc_impuesto = ldc_impuesto * ldc_tipo_cambio
				
			ELSEIF trim(ls_moneda_oc) = trim(gnvo_app.is_euros) THEN
				
				ldc_impuesto = ldc_impuesto * ldc_tcambio_euro
				if ls_moneda_fap = gnvo_app.is_dolares then
					ldc_impuesto = ldc_impuesto / ldc_tipo_cambio
				end if
				
			END IF
	
			ldw_impuestos.object.importe 			[ll_row] = ldc_impuesto
				
			//Añado al acumulador
			ldc_importe += ldc_impuesto
			
		end if
	end if
	
	//Reinicio el numero por si acaso
	ldc_impuesto = 0
	if Not IsNull(ls_tipo_impuesto2) and ls_tipo_impuesto2 <> "" then
		
		ls_expresion = "item=" + ls_item + " and tipo_impuesto='" + ls_tipo_impuesto2 + "'"
		ll_row = ldw_impuestos.Find(ls_expresion, 1, ldw_impuestos.RowCount())
		if ll_row = 0 then ll_row = ldw_impuestos.event ue_insert()
	
		if ll_row > 0 then
			//Obtengo la tasa de impuesto
			select tasa_impuesto, signo, cnta_ctbl, flag_dh_cxp
				into :ldc_tasa, :ls_signo, :ls_cnta_cntbl, :ls_flag_dh
			from impuestos_tipo
			where tipo_impuesto = :ls_tipo_impuesto2;
			
			ldw_impuestos.object.item				[ll_row] = Long(ls_item)
			ldw_impuestos.object.tipo_impuesto	[ll_row] = ls_tipo_impuesto2 
			ldw_impuestos.object.tasa_impuesto	[ll_row] = ldc_tasa
			ldw_impuestos.object.cnta_ctbl		[ll_row] = ls_cnta_cntbl
			ldw_impuestos.object.signo				[ll_row] = ls_signo
			ldw_impuestos.object.flag_dh_cxp		[ll_row] = ls_flag_dh
			
			//Ahora se calcula el impuesto
			ldc_impuesto = ldc_impuesto2 * ldc_cantidad
			
			IF ls_moneda_fap = ls_moneda_oc     THEN
				//No se hace nada
			ELSEIF ls_moneda_oc = gnvo_app.is_soles      THEN
				
				ldc_impuesto = ldc_impuesto / ldc_tipo_cambio
				
			ELSEIF ls_moneda_oc = gnvo_app.is_dolares THEN
				
				ldc_impuesto = ldc_impuesto * ldc_tipo_cambio
				
			ELSEIF trim(ls_moneda_oc) = trim(gnvo_app.is_euros) THEN
				
				ldc_impuesto = ldc_impuesto * ldc_tcambio_euro
				if ls_moneda_fap = gnvo_app.is_dolares then
					ldc_impuesto = ldc_impuesto / ldc_tipo_cambio
				end if
				
			END IF
	
			ldw_impuestos.object.importe 			[ll_row] = ldc_impuesto
				
			//Añado al acumulador
			ldc_importe += ldc_impuesto

		end if
	end if
	
	ist_datos.titulo = 's'	
END IF	

return ldc_importe



end function

on w_abc_seleccion_md.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;Long ll_row

ii_access = 1   // sin menu

if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if
// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

//**DataStore de Artciuclos Por Orden de Venta**//
ids_art_a_vender            = Create DataStore
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.Settransobject(sqlca)
//****//

dw_master.SetTransObject(SQLCA)
dw_1.SetTransObject		(SQLCA)
dw_2.SetTransObject		(SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE 'ARRAY'
			ll_row = dw_master.Retrieve(ist_datos.str_array)
		CASE '1S'
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '2S'
			ll_row = dw_master.Retrieve(ist_datos.string1, ist_datos.string2)
		CASE '1O', '1S'
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '11' //**Orden de Compra (Cuentas x Pagar)**///
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '12' //**Orden de Servicio (Cuentas x Pagar)**//
			ll_row = dw_master.Retrieve(ist_datos.string1)		
		CASE	'13' //**Detalle de Warrant Pendientes**//
			ll_row = dw_master.Retrieve(ist_datos.string1)		
		CASE '14' //**Datos Deuda Financiera**//
			ll_row = dw_master.Retrieve(ist_datos.string1)	
			
			//dispara deudas ya vinculadas
			wf_cuotas_deudas_financieras()
		CASE '15' // Guia de Recepción de Materia Prima
		  ll_row = dw_master.Retrieve(ist_datos.string1)
	 
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

if dw_master.RowCount() > 0 then
	dw_master.SetRow(1)
	dw_master.selectrow( 0, false)
	dw_master.selectrow( 1, true)
	
	if dw_1.RowCount() > 0 then
		dw_1.SetRow(1)
		dw_1.selectrow( 0, false)
		dw_1.selectrow( 1, true)
	end if
end if

end event

event open;//override
THIS.EVENT ue_open_pre()

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

pb_1.x = newwidth / 2 - pb_1.width/2
pb_2.x = newwidth / 2 - pb_2.width/2

//dw_master.width  = newwidth  - dw_master.x - 10

dw_1.height = newheight - dw_1.y - 10
dw_1.width  = newwidth/2 - pb_1.width/2 - 10

dw_2.height = newheight - dw_2.y - 10
dw_2.x  = newwidth/2 + pb_1.width/2 + 10
dw_2.width  = newwidth  - dw_2.x - 10

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 956
integer width = 1362
integer height = 808
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::ue_selected_row_pro;Long	  ll_row, ll_rc, ll_count
Any	  la_id
Integer li_x


ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1573
integer y = 956
integer width = 1362
integer height = 808
integer taborder = 60
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
CHOOSE CASE ist_datos.opcion 
		 CASE 1 //Guias de Remision
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_rk[4] = 4
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				ii_dk[4] = 4
				
		CASE 2,3,4,5,8 //Concepto Financiero
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				
		
		CASE	9							  //Articulo Movimiento Proyectado	
				ii_rk[1]  = 1				// Deploy key
				ii_rk[2]  = 2				
				ii_rk[3]  = 3				
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6			
				ii_rk[7]  = 7
				ii_rk[8]  = 8				
				ii_rk[9]  = 9				
				ii_rk[10] = 10
				ii_rk[11] = 11
				ii_rk[12] = 12
				
				ii_dk[1]  = 1				
				ii_dk[2]  = 2				
				ii_dk[3]  = 3				
				ii_dk[4]  = 4								
				ii_dk[5]  = 5				
				ii_dk[6]  = 6			
				ii_dk[7]  = 7
				ii_dk[8]  = 8				
				ii_dk[9]  = 9				
				ii_dk[10] = 10
				ii_dk[11] = 11
				ii_dk[12] = 12
				
		CASE	10							  //Articulo Movimiento Proyectado
											  //x Orden de Compra
				
				ii_rk[1]  = 1				
				ii_rk[2]  = 2				
				ii_rk[3]  = 3
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6								
				ii_rk[7]  = 7
				ii_rk[8]  = 8
				ii_rk[9]  = 9			
				ii_rk[10]  = 10
				
				
	   		ii_dk[1]  = 1			  //cod art
				ii_dk[2]  = 2			  //nom articulo
				ii_dk[3]  = 3			  //descuento	
				ii_dk[4]  = 4			  //impuesto
				ii_dk[5]  = 5			  //cod moneda
				ii_dk[6]  = 6			  //precio unit
				ii_dk[7]  = 7			  //cant_pendiente
				ii_dk[8]  = 8			  //cencos	
				ii_dk[9]  = 9			  //cnta prsp
				ii_dk[10]  = 10		  //centro beneficio
				
		CASE 	11								//Orden de Servicio Detalle (Cuentas x Pagar)			

				ii_rk[1]   = 1   //COD_ORIGEN
				ii_rk[2]   = 2   //NRO_OS
				ii_rk[3]   = 3   //NRO_ITEM
				ii_rk[4]   = 4   //FLAG_ESTADO
				ii_rk[5]   = 5   //FEC_REGISTRO
				ii_rk[6]   = 6   //FEC_PROYECT
				ii_rk[7]   = 7   //DESCRIPCION
				ii_rk[8]   = 8   //IMPORTE   
				ii_rk[9]   = 9   //IMPUESTO 
				ii_rk[10]  = 10 //descuento
				ii_rk[11]  = 11 //CENCOS
				ii_rk[12]  = 12 //COD_SUB_CAT
				ii_rk[13]  = 13 //CNTA_PRSP
				ii_rk[14]  = 14 //OPER_SEC		
				ii_rk[15]  = 15 //CENTRO BENEF
				
				ii_dk[1]   = 1  //COD_ORIGEN
				ii_dk[2]   = 2  //NRO_OS
				ii_dk[3]   = 3  //NRO_ITEM
				ii_dk[4]   = 4  //FLAG_ESTADO
				ii_dk[5]   = 5  //FEC_REGISTRO
				ii_dk[6]   = 6  //FEC_PROYECT
				ii_dk[7]   = 7  //DESCRIPCION
				ii_dk[8]   = 8  //IMPORTE   
				ii_dk[9]   = 9  //IMPUESTO 
				ii_dk[10]  = 10 //descuento
				ii_dk[11]  = 11 //CENCOS
				ii_dk[12]  = 12 //COD_SUB_CAT
				ii_dk[13]  = 13 //CNTA_PRSP
				ii_dk[14]  = 14 //OPER_SEC				
				ii_dk[15]  = 15 //CENTRO BENEF
				
		 CASE 12    // Embarque
				ii_dk[1] = 1				// 
				ii_dk[2] = 2				// 
				ii_dk[3] = 3				// 
				ii_dk[4] = 4				// 
				ii_dk[5] = 5				// 
				ii_dk[6] = 6				// 
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				
	 	 CASE 13    // Deuda Financiera
            ii_dk[1] = 1 // NRO_CUOTA
				ii_dk[2] = 2 // TIPO_DEUDA_CONCEPTO
				ii_dk[3] = 3 // DESCRIPCION
				ii_dk[4] = 4 // TIPO_DOC_REF
				ii_dk[5] = 5 // NRO_DOC_REF
				ii_dk[6] = 6 // MONTO_PROY
				ii_dk[7] = 7 // FEC_VCTO_PROY
				ii_dk[8] = 8 // FLAG_ESTADO
				ii_dk[9] = 9 // NRO REGISTRO
				ii_dk[10] = 10 // CENCOS
				ii_dk[11] = 11 // CNTA PRSP
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8				
				ii_rk[9] = 9 // NRO REGISTRO
				ii_rk[10] = 10 // CENCOS
				ii_rk[11] = 11 // CNTA PRSP
		
		CASE 14  // Guia de Recepción de Materia Prima
				ii_dk[1] = 1
				ii_dk[2] = 2
				ii_dk[3] = 3
				ii_dk[4] = 4
				ii_dk[5] = 5
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				ii_dk[11] = 11
			  
			   ii_rk[1] = 1
				ii_rk[2] = 2
				ii_rk[3] = 3
				ii_rk[4] = 4
				ii_rk[5] = 5
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				ii_rk[10] = 10
				ii_rk[11] = 11
END CHOOSE
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1399
integer y = 1188
integer taborder = 40
string text = ">"
alignment htextalign = center!
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1390
integer y = 1376
integer taborder = 50
alignment htextalign = center!
end type

type st_campo from statictext within w_abc_seleccion_md
integer x = 23
integer y = 20
integer width = 713
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_abc_seleccion_md
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 28
integer width = 2263
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion_md
integer x = 3072
integer y = 28
integer width = 338
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 
Long   j, ll_row_master, ll_ind_guia, ll_count_det, ll_row, ll_found, ll_x
String ls_guia_rem,ls_cod_origen,ls_orden_venta,ls_tipo_doc,ls_expresion,&
		 ls_orden_compra,ls_cod_moneda,ls_orden_serv,ls_forma_pago,ls_obs ,&
		 ls_moneda_fap  ,ls_fpago_fap ,ls_obs_fap,ls_flag_cntr, ls_cod_grmp
		 
u_dw_abc ldw_refer


ldw_refer = ist_datos.dw_c	// Referencias de Cuentas por Pagar

CHOOSE CASE ist_datos.opcion
	CASE 1 // Guias de Remision 
		ll_row_master  = dw_master.Getrow()
		ls_orden_venta = Trim(dw_master.Object.nro_ov [ll_row_master])
		
		
		IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
		IF ls_orden_venta <> ist_datos.string2 THEN
			Messagebox('Aviso','No Puede Seleccionar Una Orden de Venta A Diferente a la ya Considerada')
			Return
		END IF
		END IF
		
		For j = 1 to dw_2.RowCount()
		 
		 ls_cod_origen	= dw_2.Object.cod_origen [j]
		 ls_guia_rem 	= dw_2.Object.nro_guia   [j]		 
		
		 ll_ind_guia = wf_find_guias(ls_cod_origen,ls_guia_rem)
		 
		 
		 IF ll_ind_guia > 0 THEN	
			 Messagebox('Aviso','Guia No Sera Tomada en cuenta ya ha sido considerada en el Documento a Emitir')
		 ELSE
			 wf_insert_articulos_a_cobrar(ls_cod_origen,ls_guia_rem,ls_orden_venta,ist_datos.db1)					 
			 IF ids_art_a_vender.Rowcount() > 0 THEN 
				 wf_find_art(ls_orden_venta)		
			 END IF
			 
		END IF
		Next
		
		ist_datos.string1 = ls_orden_venta
	
	CASE  2 // Conceptos Financieros
	
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		ELSE
			IF ll_count_det = 1 THEN
				ist_datos.dw_m.object.confin 		  [1] = dw_2.Object.confin		   [1]
				ist_datos.dw_m.object.descripcion  [1] = dw_2.Object.descripcion  [1]
				ist_datos.dw_m.object.matriz_cntbl [1] = dw_2.Object.matriz_cntbl [1]
			END IF
		END IF
		
	CASE 3		//CASO PARTICULAR DE CONFIN
		IF of_opcion3() = 1 THEN
			ist_datos.titulo = 's'
		ELSE
			RETURN
		END IF
		
					
	CASE 4
	
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		ELSE
			IF ll_count_det = 1 THEN
				ll_row = ist_datos.dw_m.GetRow()
				IF ll_row = 0 THEN RETURN
				ist_datos.dw_m.object.confin 		 [ll_row] = dw_2.Object.confin		 [1]
				ist_datos.titulo = 's'
			END IF
		END IF
		
	CASE 5
	
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		ELSE
			IF ll_count_det = 1 THEN
				ll_row = ist_datos.dw_m.GetRow()
				IF ll_row = 0 THEN RETURN
				ist_datos.dw_m.object.confin 		 [ll_row] = dw_2.Object.confin		[1]
				ist_datos.dw_m.object.descripcion [ll_row] = dw_2.Object.descripcion [1]
				ist_datos.titulo = 's'
			END IF
		END IF
	
	CASE 8 		//CASO PARTICULAR DE CONFIN
	
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		ELSE
			IF ll_count_det = 1 THEN
				ll_row = ist_datos.dw_m.GetRow()
				IF ll_row = 0 THEN RETURN
				ist_datos.dw_m.object.confin2 		  [ll_row] = dw_2.Object.confin		  [1]
				ist_datos.titulo = 's'
			END IF
		END IF		  
		//UPDATE DW PADRE
		ist_datos.field_ret_i[1] = 1
		
	CASE	9  //Articulo Movimiento Proyectado
		ll_row_master  = dw_master.Getrow()
		ls_orden_venta = dw_master.Object.nro_ov 		[ll_row_master]
		ls_cod_origen  = dw_master.Object.cod_origen [ll_row_master]
		
		IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
			IF ls_orden_venta <> ist_datos.string2 THEN
				Messagebox('Aviso','No Puede Seleccionar Una Orden de Venta A Diferente a la ya Considerada')
				Return
			END IF
		END IF
	
		IF dw_2.RowCount() > 0 THEN
			//***SELECCION DE TIPO DE DOC ORDEN DE VENTA***//
			SELECT doc_ov
			  INTO :ls_tipo_doc
			  FROM logparam
			 WHERE reckey = '1' ;
			//***********************************//
			
			ls_expresion = 'origen_ref = '+"'"+ls_cod_origen+"'"+'  AND  nro_ref = '+"'"+ls_orden_venta+"'"
			ll_found 	 = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 
			
			IF ll_found = 0 THEN
			  IF ist_datos.dw_c.triggerevent ('ue_insert') > 0 THEN
				 ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'C'
				 ist_datos.dw_c.Object.origen_ref 	 [ll_row] = ls_cod_origen
				 ist_datos.dw_c.Object.tipo_ref		 [ll_row] = ls_tipo_doc
				 ist_datos.dw_c.Object.nro_ref		 [ll_row] = ls_orden_venta
				 ist_datos.dw_c.Object.flab_tabor	 [ll_row] = 'A' //Orden de VENTA
			  END IF
			END IF
		END IF
		
		wf_insert_art_ov(ls_orden_venta)
	
	
	
	CASE 10 		//Orden de Compra (Cuentas x Pagar)
		IF of_opcion10() = 1 THEN
			ist_datos.titulo = 's'
		ELSE
			RETURN
		END IF
	
	CASE 11 		//Orden de Servicio (Cuentas x Pagar)		  
		of_opcion11()
		
	CASE 12 //Warrant detalle liberado
		wf_insert_det_warrant()
		
	CASE	13 //Deuda Financiera con tesoreria
		wf_insert_det_deuda_financiera()
	
	CASE 14 //Guias de Recepción de Materia Prima
		ll_row_master = dw_master.Getrow()
		ls_cod_grmp   = dw_master.Object.cod_guia_rec[ll_row_master]
		ls_cod_origen = dw_master.Object.origen  		[ll_row_master]
		ls_cod_moneda = dw_master.Object.cod_moneda  [ll_row_master]
		
		IF dw_2.Rowcount() > 0 THEN
			/*actualiza datos de factura*/
			ls_moneda_fap = ist_datos.dw_m.object.cod_moneda  [1]
			ls_flag_cntr  = ist_datos.dw_m.object.flag_cntr_almacen [1]
			
			IF Isnull(ls_moneda_fap) OR Trim(ls_moneda_fap) = '' THEN
				ist_datos.dw_m.object.cod_moneda  [1] = ls_cod_moneda
				ls_moneda_fap = ls_cod_moneda
			END IF
			
			ist_datos.dw_m.Accepttext()
			
			ls_tipo_doc = ist_datos.string3 // Asigna el tipo de doc GRMP
			
			wf_insert_item_grmp (ls_cod_grmp, ls_cod_moneda, ls_tipo_doc)
		
		END IF

	CASE 15		//Flujo de Caja
		IF of_opcion15() = 1 THEN
			ist_datos.titulo = 's'
		ELSE
			RETURN
		END IF
		
	CASE 16		//Flujo de Caja
		IF of_opcion16() = 1 THEN
			ist_datos.titulo = 's'
		ELSE
			RETURN
		END IF
			
END CHOOSE
CloseWithReturn( parent, ist_datos)


end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 140
integer width = 2894
integer height = 796
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form
ii_ss = 1

end event

event ue_output;call super::ue_output;// Muestra detalle
if al_row = 0 then return

IF dw_2.RowCount() = 0 or ist_datos.opcion = 10 THEN
	
	CHOOSE CASE ist_datos.opcion 
		CASE 1,9 				// Guias de remisión, Articulo Mov Proy
			dw_1.Retrieve(this.object.cod_origen[al_row],this.object.nro_ov[al_row])
		CASE 2,4,5,8 
			dw_1.Retrieve(this.object.grupo[al_row])
		CASE 3
			dw_1.Retrieve(this.object.grupo[al_row], ist_datos.str_array)
		CASE 10 //ORDEN COMPRA		(Cuentas x Pagar)
			dw_1.Retrieve(This.object.cod_origen[al_row],This.object.nro_oc[al_row])
		CASE 11 //ORDEN SERVICIO 	(Cuentas x Pagar)
			dw_1.Retrieve(This.object.cod_origen[al_row],This.object.nro_os[al_row])	
		CASE 12 //Detalle de Embarque
			dw_1.Retrieve(This.object.cod_art[al_row],This.object.item_prod[al_row])	
		CASE	13	
			dw_1.Retrieve(This.object.nro_registro[al_row])	
		CASE 14 //Guia de Recepcion de Materia Prima
			dw_1.Retrieve(ist_datos.string1, This.object.cod_guia_rec[al_row])
		CASE 15, 16 //Grupos de Conceptos de Flujo de Caja
			dw_1.Retrieve(This.object.grp_flujo_caja[al_row])
	END CHOOSE
	
ELSE
	if ist_datos.opcion <> 12 and ist_datos.opcion <> 10 then
		Messagebox( "Error", "no puede seleccionar otro documento", Exclamation!)
	end if
END IF
end event

