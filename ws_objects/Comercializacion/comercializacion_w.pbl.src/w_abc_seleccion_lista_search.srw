$PBExportHeader$w_abc_seleccion_lista_search.srw
forward
global type w_abc_seleccion_lista_search from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_lista_search
end type
type st_campo from statictext within w_abc_seleccion_lista_search
end type
type dw_3 from datawindow within w_abc_seleccion_lista_search
end type
end forward

global type w_abc_seleccion_lista_search from w_abc_list
integer x = 50
integer width = 3762
integer height = 2172
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string icon = "Application5!"
cb_transferir cb_transferir
st_campo st_campo
dw_3 dw_3
end type
global w_abc_seleccion_lista_search w_abc_seleccion_lista_search

type variables
String is_tipo,is_col
str_parametros is_param
u_ds_base ids_cntas_pagar_det, ids_imp_x_pagar, ids_cntas_cobrar_det, ids_imp_x_cobrar,&
			 ids_imp_x_cobrar_x_item,ids_art_a_vender
end variables

forward prototypes
public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc)
public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio)
public function integer of_insert_art_fp_cant ()
public function integer of_insert_ref_ppe (long al_item)
public function integer of_insert_fp_aparejo ()
public function boolean of_opcion11 ()
public function long wf_find_guias (string as_cod_origen, string as_nro_guia, u_dw_abc adw_referencias)
public function boolean of_opcion22 ()
public function boolean of_opcion23 ()
public function boolean of_opcion4 ()
public function boolean of_opcion5 ()
public function boolean of_opcion24 ()
public function boolean of_opcion25 ()
public function boolean of_opcion26 ()
public function boolean of_opcion27 ()
public function boolean of_opcion28 ()
public function boolean of_opcion29 ()
public function boolean of_opcion30 ()
end prototypes

public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'cod_relacion = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio);Long   ll_fdw_d,j,ll_found
String ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc, ls_item, ls_mensaje

DECLARE USP_FIN_ADD_ART_X_GUIA_X_VALE PROCEDURE FOR 
	USP_FIN_ADD_ART_X_GUIA_X_VALE(:as_cod_origen,
											:as_nro_guia,
											:as_cod_moneda,
											:adc_tasa_cambio);
EXECUTE USP_FIN_ADD_ART_X_GUIA_X_VALE ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Fallo Store Procedure USP_FIN_ADD_ART_X_GUIA_X_VALE', "Error en ejecución: " + ls_mensaje )
	RETURN
END IF

CLOSE USP_FIN_ADD_ART_X_GUIA_X_VALE;

ids_art_a_vender.Retrieve()

FOR j=1 TO ids_art_a_vender.Rowcount()
	 
	 ls_cod_art    = ids_art_a_vender.object.cod_art    [j] 
	 ls_cod_moneda = ids_art_a_vender.object.cod_moneda [j] 
	 
	 ls_expresion  = "cod_art = '"+ls_cod_art+"'"
	 ll_found      = is_param.dw_d.find(ls_expresion,1,is_param.dw_d.rowcount())
	 
	 IF ll_found > 0 THEN 
		 is_param.dw_d.Object.cantidad        [ll_found] = is_param.dw_d.Object.cantidad     [ll_found] + ids_art_a_vender.Object.cant_procesada [j]
		 is_param.dw_d.Object.cant_proyect    [ll_found] = is_param.dw_d.Object.cant_proyect [ll_found] + ids_art_a_vender.Object.cant_proyect   [j]
	 ELSE
	    IF is_param.dw_d.triggerevent ('ue_insert') > 0 THEN
          ll_fdw_d = w_ve310_cntas_cobrar.tab_1.tabpage_1.dw_detail.il_row
			 /*Datos del Registro Modificado*/
			 w_ve310_cntas_cobrar.ib_estado_prea = TRUE
		    /**/			 
			  
			 IF ls_cod_moneda = gnvo_app.is_soles      THEN
				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_soles   [j]
			 ELSEIF ls_cod_moneda = gnvo_app.is_dolares    THEN
				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_dolares [j]
			 END IF
			 
			 is_param.dw_d.Object.cod_art         [ll_fdw_d] = ids_art_a_vender.Object.cod_art 			 [j]
			 is_param.dw_d.Object.descripcion     [ll_fdw_d] = ids_art_a_vender.Object.nom_articulo    [j]
			 is_param.dw_d.Object.cantidad        [ll_fdw_d] = ids_art_a_vender.Object.cant_procesada  [j]
			 is_param.dw_d.Object.cant_proyect    [ll_fdw_d] = ids_art_a_vender.Object.cant_proyect    [j]
			 is_param.dw_m.Object.moneda_det	     [1] 		 = is_param.string3
			 is_param.dw_m.Object.tasa_cambio_det [1] 		 = is_param.db2
			 is_param.dw_m.Object.cod_relacion_det[1] 	    = is_param.string2
			 is_param.dw_d.Object.confin			  [ll_fdw_d] = ids_art_a_vender.Object.confin 			 [j]
			 is_param.dw_d.Object.matriz_cntbl	  [ll_fdw_d] = ids_art_a_vender.object.matriz_cntbl    [j]
			 is_param.dw_d.Object.flag				  [ll_fdw_d] = 'G'	
			 is_param.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = ids_art_a_vender.object.tipo_cred_fiscal[j]
 			 is_param.dw_d.Object.rubro			  [ll_fdw_d] = ids_art_a_vender.object.rubro			    [j]
		    is_param.dw_d.Object.centro_benef	  [ll_fdw_d] = ids_art_a_vender.object.centro_benef	 [j]
			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(is_param.dw_d.Object.nro_item  [ll_fdw_d]))
			 w_ve310_cntas_cobrar.of_generacion_imp (ls_item)
			 
			 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			 
		    //Asigno total
			 w_ve310_cntas_cobrar.dw_master.object.importe_doc [w_ve310_cntas_cobrar.dw_master.getrow()] = w_ve310_cntas_cobrar.of_totales ()
			 w_ve310_cntas_cobrar.dw_master.ii_update = 1
		 END IF	
	 END IF	
NEXT





end subroutine

public function integer of_insert_art_fp_cant ();String  	  ls_moneda_parte, ls_moneda, ls_expresion, &
		     ls_nro_parte, ls_cliente, ls_especie, ls_tipo_ref, &
			  ls_descripcion
Long		  ll_row, ll_i, ll_found

u_dw_abc 	ldw_detail, ldw_master

ldw_detail = is_param.dw_d	// detail
ldw_master = is_param.dw_m	// master

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN 0

ls_moneda = ldw_master.object.cod_moneda		[ll_row]   // Moneda de la LC

IF ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'La cabecera del documento  no tiene codigo de moneda, por favor verifique')
	RETURN 0
END IF


FOR ll_i = 1 TO dw_2.Rowcount()
	ls_nro_parte    = dw_2.object.parte_pesca [ll_i]
	ls_cliente	 	 = dw_2.object.cliente	   [ll_i]
	ls_especie	 	 = dw_2.object.especie	   [ll_i]
	ls_moneda_parte = dw_2.object.cod_moneda  [ll_i]
	
	ls_expresion = "parte_pesca = '" + ls_nro_parte + "' AND cliente = '" + ls_cliente &
					  + "' AND especie = '" + ls_especie + "' "
					  
	ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.RowCount())

	IF ll_found = 0 THEN
		ldw_Master.il_row = ldw_master.Getrow( )
		ll_row = ldw_detail.event ue_insert()
		ls_tipo_ref			= is_param.string5
		
		IF ll_row > 0 THEN
			
			 /*Anchoveta (o el nombre de la especie que corresponda), 
									fecha de descarga - lugar de descarga - 
									nombre de embarcación - numero de matricula.'*/
			
			ls_descripcion = Trim(dw_2.object.descr_especie [ll_i]) + ' - ' + &
								  String(dw_2.object.hora_inicio_descarga [ll_i], "dd/mm/yyyy") + ' - ' + &
								  Trim(dw_2.object.descr_puerto [ll_i]) + ' - ' + &
								  Trim(dw_2.object.nomb_nave    [ll_i]) + ' - ' + &
								  Trim(dw_2.object.matricula    [ll_i])
			
			ldw_detail.ii_update = 1
			ldw_detail.Object.cod_art			  		[ll_row] = dw_2.object.cod_art 	 		[ll_i]
			ldw_detail.Object.descripcion		 		[ll_row] = ls_descripcion
			ldw_detail.Object.cantidad			 		[ll_row] = dw_2.object.cantidad	 		[ll_i]
			ldw_detail.Object.und			 			[ll_row] = dw_2.object.und	 				[ll_i]
			ldw_detail.Object.precio_unitario		[ll_row] = dw_2.object.precio_unitario [ll_i]
			ldw_detail.Object.precio_unit_exp		[ll_row] = dw_2.object.precio_unitario [ll_i]
			ldw_detail.object.parte_pesca			   [ll_row] = ls_nro_parte
			ldw_detail.object.cliente					[ll_row] = ls_cliente
			ldw_detail.object.especie					[ll_row] = ls_especie
			ldw_detail.object.tipo_ref					[ll_row] = ls_tipo_ref
			ldw_detail.object.nro_ref					[ll_row] = ls_nro_parte
			is_param.titulo = 's'
		END IF
		
		// Inserto las referencias
		IF of_insert_ref_ppe(ll_i) <> 1 THEN 
			messagebox('Aviso', 'Se produjo un error a la hora de agregar la referencia')
			RETURN 0
		END IF
		
		
	END IF
NEXT
RETURN 1

end function

public function integer of_insert_ref_ppe (long al_item);// Funcion para agregar las referencias de los partes diarios

Long			ll_found, ll_j, ll_row 
String		ls_cod_moneda, ls_nro_parte, ls_origen_parte, ls_expresion, &
				ls_tipo_ref

u_dw_abc  ldw_master, ldw_refer // ldw_detail,


ldw_master = is_param.dw_m	// master
ldw_refer  = is_param.dw_c   // Referencias

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN 0


/**** Ingresar las refencias ****/
ldw_refer.Accepttext()
ls_cod_moneda 		= dw_2.object.cod_moneda		 [al_item]
ls_origen_parte	= MID(TRIM(dw_2.object.parte_pesca [al_item]), 1, 2)
ls_nro_parte		= dw_2.object.parte_pesca		 [al_item]
ls_tipo_ref			= is_param.string5


ls_expresion = "origen_ref = '" + ls_origen_parte + "' AND tipo_ref = '" +&
					ls_tipo_ref + "' AND  nro_ref = '" + ls_nro_parte + "'"

ll_found 	 = ldw_refer.Find(ls_expresion, 1, ldw_refer.RowCount())	 

IF ll_found = 0 THEN // inserta los documentos de referencias
	ll_j = ldw_refer.event ue_insert()
	IF ll_j > 0 THEN	
		ll_row  = ldw_refer.il_row
		ldw_refer.Object.tipo_mov	    	[ll_row] = 'C'
		ldw_refer.Object.origen_ref     	[ll_row] = ls_origen_parte
		ldw_refer.Object.tipo_ref	    	[ll_row] = ls_tipo_ref	
		ldw_refer.Object.nro_ref		   [ll_row] = ls_nro_parte 
		ldw_refer.Object.cod_moneda_det 	[ll_row] = ls_cod_moneda
		ldw_refer.Object.flab_tabor	   [ll_row] = '1' //Cuentas por Cobrar
//		ldw_refer.Object.importe			[ll_row] = 0.00
//		ist_datos.titulo = 's'	
	END IF
END IF

RETURN 1
end function

public function integer of_insert_fp_aparejo ();String  	  ls_moneda_parte, ls_moneda, ls_expresion, &
		     ls_nro_parte, ls_cliente, ls_especie, ls_null, &
			  ls_tipo_ref,ls_descripcion
Long		  ll_row, ll_i, ll_found
Decimal    ldc_precio, ldc_total, ldc_importe
Datetime	  ldt_fecha

SetNull(ls_null)

u_dw_abc ldw_detail, ldw_master

ldw_detail = is_param.dw_d	// detail
ldw_master = is_param.dw_m	// master

ll_row = ldw_master.GetRow()

IF ll_row = 0 THEN RETURN 0

ls_moneda = ldw_master.object.cod_moneda		[ll_row]   // Moneda de la LC
ldt_fecha = ldw_master.object.fecha_registro	[ll_row]   // Fecha para TC.

IF ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'La cabecera del documento  no tiene codigo de moneda, por favor verifique')
	RETURN 0
END IF


FOR ll_i = 1 TO dw_2.Rowcount()
	ls_nro_parte    = dw_2.object.parte_pesca [ll_i]
	ls_cliente	 	 = dw_2.object.cliente	   [ll_i]
	ls_especie	 	 = dw_2.object.especie	   [ll_i]
	ls_moneda_parte = dw_2.object.cod_moneda  [ll_i]
	
	ls_expresion = "IsNull(cod_art) AND parte_pesca = '" + ls_nro_parte + "' AND cliente = '" + ls_cliente &
					  + "' AND especie = '" + ls_especie + "' "
	
	ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.RowCount())

	IF ll_found = 0 THEN
		ldw_Master.il_row = ldw_master.Getrow( )
		ll_row = ldw_detail.event ue_insert()
		ls_tipo_ref			= is_param.string5
	
		IF ll_row > 0 THEN
			ldc_importe	= dw_2.object.precio_unitario[ll_i]
			SELECT usf_fl_conv_mon(:ldc_importe, :ls_moneda_parte, :ls_moneda, :ldt_fecha)
				INTO :ldc_precio
			FROM dual;
			
			// Por desgaste de aparejos, fecha de descarga - 
		//	lugar de descarga, nombre de embarcación - numero de matricula
			ls_descripcion = 'Por Desgaste de Aparejos ' + &
								String(dw_2.object.hora_inicio_descarga [ll_i], "dd/mm/yyyy") + ' - ' + &
								Trim(dw_2.object.descr_puerto [ll_i]) + ' - ' + &
								Trim(dw_2.object.nomb_nave    [ll_i]) + ' - ' + &
								Trim(dw_2.object.matricula    [ll_i])
			
			ldw_detail.ii_update = 1
			ldw_detail.Object.cod_art			  		[ll_row] = ls_null
			ldw_detail.Object.descripcion		 		[ll_row] = ls_descripcion
			ldw_detail.Object.cantidad			 		[ll_row] = 1
			ldw_detail.Object.precio_unitario		[ll_row] = ldc_precio
			ldw_detail.Object.precio_unit_exp		[ll_row] = ldc_precio
			ldw_detail.object.parte_pesca			   [ll_row] = ls_nro_parte
			ldw_detail.object.cliente					[ll_row] = ls_cliente
			ldw_detail.object.especie					[ll_row] = ls_especie
			ldw_detail.object.tipo_ref					[ll_row] = ls_tipo_ref
			ldw_detail.object.nro_ref					[ll_row] = ls_nro_parte
			is_param.titulo = 's'
		END IF
		
		// Inserto las referencias
		IF of_insert_ref_ppe(ll_i) <> 1 THEN 
			messagebox('Aviso', 'Se produjo un error a la hora de agregar la referencia')
			RETURN 0
		END IF
		
		
	END IF
NEXT
RETURN 1

end function

public function boolean of_opcion11 ();Long ll_inicio, ll_ind_guia, ll_j, ll_row, ll_found

string 	ls_cod_origen, ls_nro_guia, ls_cod_art, ls_cod_moneda, ls_expresion, ls_item

Decimal	ldc_tasa_cambio, ldc_precio_unit, ldc_cant_despachada
u_dw_abc	ldw_referencias, ldw_master, ldw_detail, ldw_impuestos

ldw_referencias 	= is_param.dw_c
ldw_master			= is_param.dw_m
ldw_detail			= is_param.dw_d
ldw_impuestos		= is_param.dw_imp

ls_cod_moneda 		= ldw_master.object.cod_moneda [1] 
ldc_tasa_cambio	= ldw_master.object.tasa_cambio [1]

FOR ll_inicio = 1 TO dw_2.RowCount()
	 
	ls_cod_origen	= dw_2.Object.cod_origen [ll_inicio]
	ls_nro_guia 	= dw_2.Object.nro_guia   [ll_inicio]		 
	
	//Inserto la guia la referencia 
	ll_ind_guia = wf_find_guias(ls_cod_origen,ls_nro_guia, ldw_referencias)
	 
	ls_cod_art    = dw_2.object.cod_art    [ll_inicio] 
	 
	//Busco el codigo si ya existe en la factura, sino lo agrego
	ls_expresion  = "cod_art = '"+ls_cod_art+"' and tipo_ref='" + gnvo_app.is_doc_gr + "' and nro_ref = '" + ls_nro_guia + "'"
	ll_found      = ldw_detail.find(ls_expresion,1,ldw_detail.rowcount())
	
	ldc_cant_despachada = Dec(dw_2.Object.cant_despachada [ll_inicio])
	if ldc_cant_despachada > 0 then
		ldc_precio_unit = Dec(dw_2.Object.importe_total [ll_inicio]) / ldc_cant_despachada
	else
		ldc_precio_unit = 0
	end if
	
	 
	IF ll_found > 0 THEN 
		ldw_detail.Object.cantidad        [ll_found] = ldc_cant_despachada
		ldw_detail.Object.cant_proyect    [ll_found] = ldc_cant_despachada
	ELSE
		ll_row = ldw_detail.event ue_insert()
		IF ll_row > 0 THEN

			
			IF ls_cod_moneda = gnvo_app.is_soles      THEN
				ldw_detail.Object.precio_unitario [ll_row] = ldc_precio_unit
			ELSEIF ls_cod_moneda = gnvo_app.is_dolares    THEN
			  	ldw_detail.Object.precio_unitario [ll_row] = ldc_precio_unit / ldc_tasa_cambio
			END IF
			
			ldw_detail.Object.cod_art         	[ll_row] = dw_2.Object.cod_art 	[ll_inicio]
			ldw_detail.Object.descripcion     	[ll_row] = dw_2.Object.desc_art  [ll_inicio]
			ldw_detail.Object.und     				[ll_row] = dw_2.Object.und    	[ll_inicio]
			ldw_detail.Object.cantidad        	[ll_row] = ldc_cant_despachada
			ldw_detail.Object.cant_proyect    	[ll_row] = ldc_cant_despachada
			ldw_detail.Object.flag				  	[ll_row] = 'G'	
			ldw_detail.Object.tipo_ref	  			[ll_row] = gnvo_app.is_doc_gr
			ldw_detail.Object.nro_ref	  			[ll_row] = ls_nro_guia
			
			//Recalculo de Impuesto				 
			ls_item = Trim(String(ldw_detail.Object.nro_item  [ll_row]))
			w_ve310_cntas_cobrar.of_generacion_imp (ls_item)
			
			ldw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			
			//Asigno total
			ldw_master.object.importe_doc [1] = w_ve310_cntas_cobrar.of_totales ()
			ldw_master.ii_update = 1
		end if
	end if
NEXT

return true
end function

public function long wf_find_guias (string as_cod_origen, string as_nro_guia, u_dw_abc adw_referencias);String ls_expresion
Long   ll_found = 0, ll_row


ls_expresion = "origen_ref = '" + as_cod_origen+"' AND nro_ref = '" + as_nro_guia + "'"
ll_found = adw_referencias.Find(ls_expresion, 1, adw_referencias.RowCount())	 

IF ll_found > 0 THEN
	Return ll_found
end if

ll_row = adw_referencias.event ue_insert()

IF ll_row > 0 THEN
	/*Datos del Registro Modificado*/
	w_ve310_cntas_cobrar.ib_estado_prea = TRUE
	/**/
	adw_referencias.Object.tipo_mov	    [ll_row] = 'C'
	adw_referencias.Object.origen_ref 	 [ll_row] = as_cod_origen
	adw_referencias.Object.tipo_ref		 [ll_row] = gnvo_app.is_doc_gr
	adw_referencias.Object.nro_ref		 [ll_row] = as_nro_guia
	adw_referencias.Object.flab_tabor	 [ll_row] = '9' //Guias de Remision
	Return ll_found
END IF




end function

public function boolean of_opcion22 ();Long ll_inicio, ll_ind_guia, ll_j, ll_row, ll_found

string 	ls_cod_origen, ls_nro_guia, ls_cod_art, ls_cod_moneda, ls_expresion, ls_item

Decimal	ldc_tasa_cambio, ldc_precio_unit, ldc_cant_despachada
u_dw_abc	ldw_referencias, ldw_master, ldw_detail, ldw_impuestos

ldw_referencias 	= is_param.dw_c
ldw_master			= is_param.dw_m
ldw_detail			= is_param.dw_d
ldw_impuestos		= is_param.dw_imp

ls_cod_moneda 		= ldw_master.object.cod_moneda 		[1] 
ldc_tasa_cambio	= Dec(ldw_master.object.tasa_cambio [1])

FOR ll_inicio = 1 TO dw_2.RowCount()
	
	//Obtengo el valor
	if dw_2.object.cod_moneda	[ll_inicio] = gnvo_app.is_soles then
		ldc_precio_unit = dec(dw_2.object.saldo_sol [ll_inicio]) * -1
	else
		ldc_precio_unit = dec(dw_2.object.saldo_dol [ll_inicio]) * -1
	end if
	
	//Inserto el detalle
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
	
		
		IF ls_cod_moneda = dw_2.object.cod_moneda	[ll_inicio]      THEN
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_precio_unit
			
		ELSEIF ls_cod_moneda = gnvo_app.is_soles then
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_precio_unit * ldc_tasa_cambio
			
		ELSE
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_precio_unit / ldc_tasa_cambio
			
		END IF
		
		ldw_detail.Object.descripcion     	[ll_row] = dw_2.Object.observacion  [ll_inicio]
		ldw_detail.Object.cantidad        	[ll_row] = 1
		ldw_detail.Object.tipo_ref	  			[ll_row] = dw_2.Object.tipo_doc	  	[ll_inicio]
		ldw_detail.Object.nro_ref	  			[ll_row] = left(trim(dw_2.Object.nro_doc	  	[ll_inicio]),10)
		
		//Recalculo de Impuesto				 
		ls_item = Trim(String(ldw_detail.Object.nro_item  [ll_row]))
		w_ve310_cntas_cobrar.of_generacion_imp (ls_item)
		
		ldw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
		
		//Asigno total
		ldw_master.object.importe_doc [1] = w_ve310_cntas_cobrar.of_totales ()
		ldw_master.ii_update = 1
	end if

NEXT

return true
end function

public function boolean of_opcion23 ();Long 		ll_inicio, ll_ind_guia, ll_j, ll_row, ll_found, ll_nro_am, ll_row_imp, ll_item

string 	ls_org_am, ls_nro_vale, ls_cod_art, ls_desc_art, ls_und, ls_moneda_fac, ls_moneda, &
			ls_cnta_cntbl, ls_flag_dh_cxp, ls_signo, ls_texto_find, ls_desc_impuesto, ls_desc_cnta, &
			ls_flag_igv

Decimal	ldc_tasa_cambio, ldc_precio_vta, ldc_cantidad, ldc_importe_igv, ldc_base_imponible, &
			ldc_porc_igv

u_dw_abc	ldw_referencias, ldw_master, ldw_detail, ldw_impuestos

ldw_referencias 	= is_param.dw_c
ldw_master			= is_param.dw_m
ldw_detail			= is_param.dw_d
ldw_impuestos		= is_param.dw_imp

ls_moneda_fac		= ldw_master.object.cod_moneda 		[1] 
ldc_tasa_cambio	= Dec(ldw_master.object.tasa_cambio [1])

//Obtengo el porcentaje del IGV
select 	it.tasa_impuesto, it.signo, it.flag_dh_cxp, it.desc_impuesto, it.flag_igv, 
			it.cnta_ctbl, cc.desc_cnta
	into 	:ldc_porc_igv, :ls_signo, :ls_flag_dh_cxp, :ls_desc_impuesto, :ls_flag_igv, 
			:ls_cnta_cntbl, :ls_Desc_cnta
from 	impuestos_tipo it,
     	cntbl_cnta     cc
where it.cnta_ctbl = cc.cnta_ctbl (+) 
  and trim(tipo_impuesto) = :gnvo_app.finparam.is_igv;

//REcorro los items seleccionados
FOR ll_inicio = 1 TO dw_2.RowCount()
	
	//Obtengo el valor
	ls_moneda 		= dw_2.object.cod_moneda		[ll_inicio]
	ldc_precio_vta = dec(dw_2.object.precio_vta 	[ll_inicio]) 
	ls_cod_art		= dw_2.object.cod_art			[ll_inicio]
	ls_desc_art		= dw_2.object.desc_art			[ll_inicio]
	ls_und			= dw_2.object.und					[ll_inicio]
	ls_nro_vale		= dw_2.object.nro_vale			[ll_inicio]
	ls_org_am		= dw_2.object.org_am				[ll_inicio]
	ll_nro_am		= Long(dw_2.object.nro_am		[ll_inicio])
	ldc_cantidad	= dec(dw_2.object.saldo 		[ll_inicio]) 
	
	//Obtengo el igv
	ldc_base_imponible 	= ldc_precio_vta / (1 + ldc_porc_igv / 100)
	ldc_importe_igv 		= ldc_precio_vta - ldc_base_imponible
	
	
	//Inserto el detalle
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
	
		
		IF ls_moneda = ls_moneda_fac THEN
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_base_imponible
			
		ELSEIF ls_moneda_fac = gnvo_app.is_soles then
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_base_imponible * ldc_tasa_cambio
			
		ELSE
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_base_imponible / ldc_tasa_cambio
			
		END IF
		
		ldw_detail.Object.descripcion     	[ll_row] = ls_desc_art
		ldw_detail.Object.cantidad        	[ll_row] = ldc_cantidad
		ldw_detail.Object.tipo_ref	  			[ll_row] = gnvo_app.almacen.is_doc_vale
		ldw_detail.Object.nro_ref	  			[ll_row] = ls_nro_vale
		ldw_detail.Object.org_am	  			[ll_row] = ls_org_am
		ldw_detail.Object.nro_am	  			[ll_row] = ll_nro_am
		
		
		//Inserto el impuesto	 
		ll_item = Long(ldw_detail.Object.nro_item  [ll_row])
		ls_texto_find = "item=" + trim(string(ll_item))
		ll_found = ldw_impuestos.find(ls_texto_find, 1, ldw_impuestos.RowCount())
		
		if ll_found > 0 then
			ldw_impuestos.deleteRow(ll_found)
		end if
		
		ll_row_imp = ldw_impuestos.event ue_insert()
		if ll_row_imp > 0 then
			ldw_impuestos.object.item				[ll_row_imp] = ll_item
			ldw_impuestos.object.tipo_impuesto	[ll_row_imp] = gnvo_app.finparam.is_igv
			ldw_impuestos.object.importe			[ll_row_imp] = ldc_cantidad * ldc_importe_igv
			ldw_impuestos.object.tasa_impuesto	[ll_row_imp] = ldc_porc_igv
			ldw_impuestos.object.desc_impuesto	[ll_row_imp] = ls_desc_impuesto
			ldw_impuestos.object.signo				[ll_row_imp] = ls_signo
			ldw_impuestos.object.cnta_ctbl		[ll_row_imp] = ls_cnta_cntbl
			ldw_impuestos.object.desc_cnta		[ll_row_imp] = ls_Desc_cnta
			ldw_impuestos.object.flag_igv			[ll_row_imp] = ls_flag_igv
			ldw_impuestos.object.flag_dh_cxp		[ll_row_imp] = ls_flag_dh_cxp
			
		end if
		
		
		ldw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
		
		//Asigno total
		ldw_master.object.importe_doc [1] = w_ve310_cntas_cobrar.of_totales ()
		ldw_master.ii_update = 1
	end if

NEXT

return true
end function

public function boolean of_opcion4 ();/*
	Esta opción permite jalar el detalle del comprobante de pago
*/
Long		ll_row, ll_item, ll_found, ll_ins_row, ll_inicio, ll_ins_row_Det
String	ls_tipo_doc, ls_nro_doc, ls_cod_art, ls_confin, ls_matriz, ls_descrip, ls_expresion, ls_cod_moneda, &
			ls_Doc_cab, ls_cod_moneda_det, ls_tipo_impuesto, ls_cnta_cntbl, ls_desc_impuesto, ls_flag_dh, &
			ls_signo, ls_desc_cnta, ls_tipo_cred_fiscal, ls_desc_cred_fiscal
Decimal 	ldc_tasa_cambio, ldc_precio_unit, ldc_tasa_imp, ldc_impuesto
u_dw_abc ldw_master, ldw_detail, ldw_impuestos

ldw_master 		= is_param.dw_m
ldw_detail 		= is_param.dw_d
ldw_impuestos	= is_param.dw_c

ldw_master.Accepttext()
ldw_detail.Accepttext()
ldw_impuestos.Accepttext( )
 
ls_cod_moneda 	= ldw_master.object.cod_moneda 	[ldw_master.getRow()] 
ls_doc_cab 		= ldw_master.object.tipo_doc 		[ldw_master.getRow()]

For ll_row = 1 TO dw_2.Rowcount()
	ls_tipo_doc   			= dw_2.object.tipo_doc     		[ll_row]	
	ls_nro_doc    			= dw_2.object.nro_doc      		[ll_row]	
	ll_item		   		= dw_2.object.item	      		[ll_row]	
	ls_cod_art				= dw_2.object.cod_art      		[ll_row]	
	ls_confin				= dw_2.object.confin	      		[ll_row]	
	ls_descrip  			= dw_2.object.descripcion  		[ll_row]	
	ls_matriz  				= dw_2.object.matriz_cntbl 		[ll_row]	
	ldc_precio_unit 		= dw_2.object.precio_unitario 	[ll_row]
	ls_tipo_cred_fiscal	= dw_2.object.tipo_cred_fiscal 	[ll_row]	
	ls_desc_cred_fiscal	= dw_2.object.desc_cred_fiscal	[ll_row]		
	
	//Valido para que la nota de venta tenga solo una referencia
	if ldw_detail.RowCount() > 0 then
		ls_expresion = "tipo_ref = '"+ls_tipo_doc+"' AND nro_ref = '"+ls_nro_doc + "'"
	 	ll_found	  	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.rowcount())
		
		if ll_found = 0 then
			MessageBox('Error', 'La Nota de Venta solo puede tener un solo documento como referencia, por favor verifique', StopSign!)
			return false
		end if
		 
	end if
	 
	ls_expresion = "tipo_ref = '"+ls_tipo_doc+"' AND nro_ref = '"+ls_nro_doc+"' AND item_ref = "+Trim(String(ll_item))
	ll_found	  = ldw_detail.Find(ls_expresion, 1, ldw_detail.rowcount())
	
	IF ll_found = 0 THEN
	
		/*busco tipo de cambio*/
		select tasa_cambio 
		  into :ldc_tasa_cambio 
		  from cntas_cobrar
		where tipo_doc    = :ls_tipo_doc
		  and nro_doc		= :ls_nro_doc ;	 
		 
		ldw_master.object.tasa_cambio [1] = ldc_tasa_cambio
	 
	 	/*Item No Ha Sido Tomado En Cuenta*/	
	 	ls_cod_moneda_det = dw_2.object.cod_moneda [ll_row]
	
	 	IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
			ls_cod_moneda = ls_cod_moneda_det
		 	ldw_master.object.cod_moneda [1] = ls_cod_moneda
	 	END IF
	
	 	IF ls_cod_moneda <> ls_cod_moneda_det THEN //Si Moneda es Diferente Salir
			Messagebox ('Aviso','Aviso No Puede Escoger Un Documento con Otro Tipo de Moneda , Verifique!')
		 	EXIT
	 	END IF
	
		ll_ins_row = ldw_detail.event ue_insert()
		
		if ll_ins_row > 0 then
	 		/*Activara ii_update de dw_detail e impuestos */
	 		is_param.titulo = 's'
	
		 	ldw_detail.Object.item 	        		[ll_ins_row] = ll_ins_row
		 	ldw_detail.Object.tipo_ref       	[ll_ins_row] = ls_tipo_doc
		 	ldw_detail.Object.nro_ref        	[ll_ins_row] = ls_nro_doc
		 	ldw_detail.Object.item_ref       	[ll_ins_row] = ll_item
		 	ldw_detail.Object.cod_art     		[ll_ins_row] = ls_cod_art
		 	ldw_detail.Object.descripcion 		[ll_ins_row] = ls_descrip
		 	ldw_detail.Object.cantidad    		[ll_ins_row] = 1 
		 	ldw_detail.Object.precio_unitario	[ll_ins_row] = ldc_precio_unit
		 	ldw_detail.Object.confin		 		[ll_ins_row] = ls_confin
		 	ldw_detail.Object.matriz_cntbl 		[ll_ins_row] = ls_matriz
			ldw_detail.Object.tipo_cred_fiscal 	[ll_ins_row] = ls_tipo_cred_fiscal
			ldw_detail.Object.desc_cred_fiscal 	[ll_ins_row] = ls_desc_cred_fiscal
		 	
			/**/
		 	ldw_detail.Object.flag_rev	 		[ll_ins_row] = 'AJ'
			/**/
		
		 	ldw_detail.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
		 	ldw_detail.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
		 	ldw_detail.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
		 	
			//campos bloqueados no editables					 
		
		 	/**Inserta Impuestos **/ 
		 	ids_imp_x_cobrar.Retrieve(ls_tipo_doc,ls_nro_doc, ll_item)
		 	For ll_inicio = 1 to ids_imp_x_cobrar.Rowcount()
			
				ls_tipo_impuesto 	= ids_imp_x_cobrar.object.tipo_impuesto 	[ll_inicio]
			  	ls_cnta_cntbl		= ids_imp_x_cobrar.object.cnta_ctbl	  		[ll_inicio]
			  	ls_desc_impuesto 	= ids_imp_x_cobrar.object.desc_impuesto 	[ll_inicio]
			  	ldc_tasa_imp		= ids_imp_x_cobrar.object.tasa_impuesto 	[ll_inicio]
			  	ls_signo			 	= ids_imp_x_cobrar.object.signo			  	[ll_inicio]
			  	ls_desc_cnta		= ids_imp_x_cobrar.object.desc_cnta	  		[ll_inicio]
			  	ldc_impuesto 	 	= ids_imp_x_cobrar.object.importe		  	[ll_inicio]
			  	ls_flag_dh		 	= ids_imp_x_cobrar.object.flag_dh		  	[ll_inicio]
		
			  	ll_ins_row_det = ldw_impuestos.event ue_insert()
				  
			  	if ll_ins_row_det > 0 then
				  	/*Activar ii_update*/
				  	ldw_impuestos.Object.item 	  	    	[ll_ins_row_det] = ll_ins_row
				  	ldw_impuestos.Object.tipo_impuesto 	[ll_ins_row_det] = ls_tipo_impuesto
				  	ldw_impuestos.Object.cnta_ctbl		[ll_ins_row_det] = ls_cnta_cntbl
				  	ldw_impuestos.Object.desc_impuesto 	[ll_ins_row_det] = ls_desc_impuesto
				  	ldw_impuestos.Object.tasa_impuesto 	[ll_ins_row_det] = ldc_tasa_imp
				  	ldw_impuestos.Object.signo			 	[ll_ins_row_det] = ls_signo
				  	ldw_impuestos.Object.desc_cnta		[ll_ins_row_det] = ls_desc_cnta
				  	ldw_impuestos.Object.importe	  	 	[ll_ins_row_det] = ldc_impuesto
				  	ldw_impuestos.Object.flag_dh_cxp	 	[ll_ins_row_det] = ls_flag_dh
				  	ldw_impuestos.Object.flag_imp	  	 	[ll_ins_row_det] = 'AJ'
				  	ldw_impuestos.Object.flag_tipo	  	[ll_ins_row_det] = '1' 
			  
				  	ldw_impuestos.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag_tipo),1,0)'")
				  	ldw_impuestos.Modify("importe.Protect='1~tIf(IsNull(flag_imp),1,0)'")					 
				  	//campos bloqueados no editables					 
				end if
		 Next
			
		end if
	
	ELSE
	 Messagebox('Aviso','Item de Referencia Nº '+ Trim(String(ll_item)) +' de Documento '+ ls_tipo_doc +' '+ls_nro_doc+' ya ha sido tomado en cuenta, por favor verifique ' )
	END IF
Next


RETURN TRUE

end function

public function boolean of_opcion5 ();Long 			ll_inicio, ll_found, ll_item, ll_j, ll_row, ll_row_imp, ll_k, ll_item_ref
String 		ls_moneda_cab, ls_moneda_det, ls_tipo_ref, ls_nro_ref, ls_expresion, ls_tipo_doc, &
				ls_nro_doc, ls_cod_art, ls_descripcion, ls_confin, ls_matriz, ls_tipo_impuesto, &
				ls_cnta_cntbl, ls_desc_impuesto, ls_signo, ls_desc_cnta, ls_flag_dh, ls_und, &
				ls_und2, ls_cencos, ls_centro_benef, ls_tipo_cred_fiscal, ls_Desc_cred_fiscal, &
				ls_tipo_nc
Decimal		ldc_tasa_cambio, ldc_cantidad, ldc_precio_unit, ldc_tasa_impuesto, ldc_importe
u_dw_abc 	ldw_master, ldw_detail, ldw_impuestos

ldw_master 		= is_param.dw_m
ldw_detail 		= is_param.dw_d
ldw_impuestos 	= is_param.dw_c

ls_tipo_doc 	= ldw_master.object.tipo_doc 		[1]
ls_nro_doc		= ldw_master.object.nro_doc 		[1]
ls_moneda_cab 	= ldw_master.object.cod_moneda 	[1] 
ls_tipo_nc		= ldw_master.object.tipo_nc 		[1]


For ll_inicio = 1 TO dw_2.Rowcount()
	
	ls_tipo_ref   = dw_2.object.tipo_doc [ll_inicio]
	ls_nro_ref	  = dw_2.object.nro_doc  [ll_inicio]
	
	ls_expresion = "tipo_ref = '" + ls_tipo_ref + "' AND nro_ref = '"+ls_nro_ref+"'"
	
	ll_found	  = ldw_detail.Find(ls_expresion, 1, ldw_detail.rowcount())
	
	IF ll_found > 0 THEN
		ROLLBACK;
		Messagebox('Aviso','Documento '+ls_tipo_doc+' '+ls_nro_doc+' Ha Sido Tomado En Cuenta. Por Favor verifique!')						
		return false
	end if
	
	if trim(ls_tipo_doc) = trim(gnvo_app.finparam.is_doc_ncc) or &
		trim(ls_tipo_doc) = trim(gnvo_app.finparam.is_doc_ndc)  then
	  
		/*busco tipo de cambio*/
		select tasa_cambio 
			into :ldc_tasa_cambio 
		  from cntas_cobrar
		 where tipo_doc   = :ls_tipo_ref
			and nro_doc		= :ls_nro_ref;	 
	
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			MessageBox('Error', "No se ha encontrado registro en CNTAS_COBRAR para [" &
				+ ls_tipo_ref + "/" + ls_nro_ref + "]. Por favor verifique!", StopSign!)
			return false
		end if
	 
		ldw_master.object.tasa_cambio [1] = ldc_tasa_cambio
	 
	end if


	/*tenga el mismo de tipo del documento seleccionado */
	ls_moneda_det = dw_2.object.cod_moneda [ll_inicio]
  
	IF Isnull(ls_moneda_cab) OR Trim(ls_moneda_cab) = '' THEN
		ls_moneda_cab = ls_moneda_det
		ldw_master.object.cod_moneda [1] = ls_moneda_cab
	END IF

	IF ls_moneda_cab <> ls_moneda_det THEN //Si Moneda es Diferente Salir
		ROLLBACK;
		Messagebox ('Aviso','Aviso No Puede Escoger Un Documento con Otro Tipo de Moneda. Por favor Verifique!', StopSign!)
		return false
	END IF
 
	//Inserta Detalle
	if (ls_tipo_nc = '06' or ls_tipo_nc = '07') and upper(gs_empresa) <> 'SEAFROST' then
		ids_cntas_cobrar_det.DataObject = 'd_lista_cntas_cobrar_det_0607_tbl'
	else
		ids_cntas_cobrar_det.DataObject = 'd_cntas_x_cobrar_det_tbl'
	end if
	
	ids_cntas_cobrar_det.SettransObject(sqlca)
	ids_cntas_cobrar_det.Retrieve(ls_tipo_ref, ls_nro_ref)

	For ll_j = 1 TO ids_cntas_cobrar_det.Rowcount()
		ll_item_ref	 	   	= ids_cntas_cobrar_det.object.item 		     			[ll_j]
		ls_cod_art	 	   	= ids_cntas_cobrar_det.object.cod_art 	     			[ll_j]
		ls_descripcion	 		= ids_cntas_cobrar_det.object.descripcion    		[ll_j]
		ls_confin	 			= ids_cntas_cobrar_det.object.confin 		   		[ll_j]
		ldc_precio_unit 		= Dec(ids_cntas_cobrar_det.object.precio_unitario 	[ll_j])
		ls_matriz				= ids_cntas_cobrar_det.object.matriz_cntbl 	  		[ll_j] 
		ls_Cencos				= ids_cntas_cobrar_det.object.cencos		 	  		[ll_j] 
		ls_centro_benef		= ids_cntas_cobrar_det.object.centro_benef 	  		[ll_j] 
		
		ls_und					= ids_cntas_cobrar_det.object.und		 	  			[ll_j] 
		ls_und2					= ids_cntas_cobrar_det.object.und2			 	  		[ll_j] 
		
		ls_tipo_cred_fiscal	= ids_cntas_cobrar_det.object.tipo_cred_fiscal		[ll_j] 
		ls_desc_cred_fiscal	= ids_cntas_cobrar_det.object.desc_cred_fiscal		[ll_j] 
	  
		ll_row = ldw_detail.event ue_insert()
	  
		if ll_row > 0 then
			
			//Obtengo el nro de item
			ll_item = Long(ldw_detail.Object.item [ll_row])
			
			/*Activara ii_update de dw_detail e impuestos */
			is_param.titulo = 's'
			
			ldw_detail.Object.tipo_ref    		[ll_row] = ls_tipo_ref
			ldw_detail.Object.nro_ref     		[ll_row] = ls_nro_ref
			ldw_detail.Object.item_ref   			[ll_row] = ll_item_ref
			ldw_detail.Object.cod_art     		[ll_row] = ls_cod_art
			ldw_detail.Object.descripcion 		[ll_row] = ls_descripcion
			ldw_detail.Object.precio_unitario 	[ll_row] = ldc_precio_unit
			ldw_detail.Object.cantidad    		[ll_row] = Dec(ids_cntas_cobrar_det.object.cantidad_und1	[ll_j])
			ldw_detail.Object.cantidad_und2    	[ll_row] = Dec(ids_cntas_cobrar_det.object.cantidad_und2	[ll_j])
			ldw_detail.Object.confin		  		[ll_row] = ls_confin
			ldw_detail.Object.matriz_cntbl		[ll_row] = ls_matriz
			ldw_detail.Object.cencos		  		[ll_row] = ls_cencos
			ldw_detail.Object.centro_benef		[ll_row] = ls_centro_benef
			ldw_detail.Object.tipo_cred_fiscal	[ll_row] = ls_tipo_cred_fiscal
			ldw_detail.Object.desc_cred_fiscal	[ll_row] = ls_desc_cred_fiscal
			
			ldw_detail.Object.und					[ll_row] = ls_und
			ldw_detail.Object.und2					[ll_row] = ls_und2
			
			
			ldw_detail.Object.org_am    			[ll_row] = ids_cntas_cobrar_det.object.org_am			[ll_j]
			
			if not IsNull(ids_cntas_cobrar_det.object.nro_am [ll_j]) and dec(ids_cntas_cobrar_det.object.nro_am			[ll_j]) > 0 then
				ldw_detail.Object.nro_am		    	[ll_row] = ids_cntas_cobrar_det.object.nro_am			[ll_j]
			end if
			
			ldw_detail.Object.nro_Vale    		[ll_row] = ids_cntas_cobrar_det.object.nro_Vale			[ll_j]
			ldw_detail.Object.org_amp_ref	    	[ll_row] = ids_cntas_cobrar_det.object.org_amp_ref		[ll_j]
			ldw_detail.Object.nro_amp_ref	    	[ll_row] = ids_cntas_cobrar_det.object.nro_amp_ref		[ll_j]
			ldw_detail.Object.tipo_doc_amp    	[ll_row] = ids_cntas_cobrar_det.object.tipo_doc_amp	[ll_j]
			ldw_detail.Object.nro_doc_amp    	[ll_row] = ids_cntas_cobrar_det.object.nro_doc_amp		[ll_j]
			
			ldw_detail.Object.flag_und2    		[ll_row] = ids_cntas_cobrar_det.object.flag_und2		[ll_j]
			ldw_detail.Object.factor_conv_und   [ll_row] = ids_cntas_cobrar_det.object.factor_conv_und[ll_j]
			
			/**Insertar Impuestos**/
			ids_imp_x_cobrar_x_item.Retrieve(ls_tipo_ref, ls_nro_ref, ll_item_ref)
			 
			For ll_k = 1 TO ids_imp_x_cobrar_x_item.Rowcount()
				ls_tipo_impuesto  = ids_imp_x_cobrar_x_item.object.tipo_impuesto 	[ll_k]
				ls_cnta_cntbl	  	= ids_imp_x_cobrar_x_item.object.cnta_ctbl	   [ll_k]
				ls_desc_impuesto 	= ids_imp_x_cobrar_x_item.object.desc_impuesto 	[ll_k]
				ldc_tasa_impuesto	= ids_imp_x_cobrar_x_item.object.tasa_impuesto 	[ll_k]
				ls_signo			  	= ids_imp_x_cobrar_x_item.object.signo				[ll_k]
				ls_desc_cnta	  	= ids_imp_x_cobrar_x_item.object.desc_cnta	   [ll_k]
				ldc_importe  		= ids_imp_x_cobrar_x_item.object.importe		   [ll_k]
				ls_flag_dh		  	= ids_imp_x_cobrar_x_item.object.flag_dh		   [ll_k]
			  
				ll_row_imp = ldw_impuestos.event ue_insert()
				
				if ll_row_imp > 0 then
					/*Activar ii_update*/
					ldw_impuestos.Object.item 	  	     [ll_row_imp] = ll_item
					ldw_impuestos.Object.tipo_impuesto [ll_row_imp] = ls_tipo_impuesto
					ldw_impuestos.Object.cnta_ctbl	  [ll_row_imp] = ls_cnta_cntbl
					ldw_impuestos.Object.desc_impuesto [ll_row_imp] = ls_desc_impuesto
					ldw_impuestos.Object.tasa_impuesto [ll_row_imp] = ldc_tasa_impuesto
					ldw_impuestos.Object.signo			  [ll_row_imp] = ls_signo
					ldw_impuestos.Object.desc_cnta	  [ll_row_imp] = ls_desc_cnta
					ldw_impuestos.Object.importe	  	  [ll_row_imp] = ldc_importe
					ldw_impuestos.Object.flag_dh_cxp	  [ll_row_imp] = ls_flag_dh
					
					ldw_impuestos.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag_tipo),1,0)'")
					ldw_impuestos.Modify("importe.Protect='1~tIf(IsNull(flag_imp),1,0)'")					 
					//campos Bloqueados no editables
				end if
			Next		

		end if
	Next
	
	//ningun campo editables			
	ldw_detail.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
//	ldw_detail.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
//	ldw_detail.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
	
Next

return true		

end function

public function boolean of_opcion24 ();Long 		ll_inicio
String	ls_vendedor, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_COMPROBANTES;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_COMPROBANTES' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_vendedor	= dw_2.object.vendedor	[ll_inicio]				 				
	 				
	
	
	Insert into TT_COMPROBANTES(vendedor)
	Values (:ls_vendedor) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_COMPROBANTES' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion25 ();Long 		ll_inicio
String	ls_ubigeo, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_UBIGEO;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_UBIGEO' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_ubigeo	= dw_2.object.ubigeo	[ll_inicio]				 				
	 				
	
	
	Insert into TT_UBIGEO(ubigeo)
	Values (:ls_ubigeo) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_UBIGEO' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion26 ();Long 		ll_inicio
String	ls_especie, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete tt_especies;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_especies' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_especie	= dw_2.object.especie	[ll_inicio]				 				
	 				
	
	
	Insert into tt_especies(especie)
	Values (:ls_especie) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ESPECIES' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion27 ();Long 		ll_inicio
String	ls_cat_Art, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_ARTICULO_ALMACEN;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_ARTICULO_ALMACEN' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_cat_Art	= dw_2.object.cat_art	[ll_inicio]				 				
	 				
	
	
	Insert into TT_ARTICULO_ALMACEN(CAT_ART)
	Values (:ls_cat_Art) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion28 ();Long 		ll_inicio
String	ls_proveedor, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_PROVEEDOR;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_PROVEEDOR' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_proveedor	= dw_2.object.proveedor	[ll_inicio]				 				
	 				
	
	
	Insert into TT_PROVEEDOR(PROVEEDOR)
	Values (:ls_proveedor) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_PROVEEDOR' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion29 ();Long 		ll_inicio
String	ls_almacen

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete tt_almacenes;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_almacen' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_almacen	= dw_2.object.almacen	[ll_inicio]				 				
	 				
	
	
	Insert into tt_almacenes(almacen)
	Values (:ls_almacen) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ALMACENES' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion30 ();Long 		ll_inicio
String	ls_cod_subcateg, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_CNT_SUB_CAT;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_CNT_SUB_CAT' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_cod_subcateg	= dw_2.object.cod_sub_cat	[ll_inicio]				 				
	 				
	
	Insert into TT_CNT_SUB_CAT(SUB_CAT)
	Values (:ls_cod_subcateg) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_CNT_SUB_CAT' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

on w_abc_seleccion_lista_search.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.st_campo=create st_campo
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_3
end on

on w_abc_seleccion_lista_search.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.st_campo)
destroy(this.dw_3)
end on

event ue_open_pre;// Overr
String ls_null
Long   ll_row

// Recoge parametro enviado

This.Title = is_param.titulo
dw_1.DataObject = is_param.dw1
dw_2.Dataobject = is_param.dw1

dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)

//Inicializar Variable de Busqueda //

is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col
			

IF Trim(is_param.tipo) = '' OR Isnull(is_param.tipo) THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_param.tipo
		CASE '1D2D'   //Facturacion Pesca / Cantidad
			dw_1.Retrieve(is_param.fecha1, is_param.fecha2)
		CASE '1S'   
			dw_1.Retrieve(is_param.string1)
		CASE '2S'   //Facturacion Pesca / Cantidad
			dw_1.Retrieve(is_param.string2)
		CASE '1S2S'   //Facturacion Pesca / Cantidad
			dw_1.Retrieve(is_param.string1, is_param.string2)
		CASE '1S2S3S'   //Facturacion Pesca / Cantidad
			dw_1.Retrieve(is_param.string1, is_param.string2, is_param.string3)
		CASE '1NVP' //Nota de Ventas Por Pagar
			dw_1.Retrieve(is_param.string2) 
		CASE '1AJCP' //Ajuste x Cantidad y/o precio de nc,nd x cobrar
			dw_1.Retrieve(is_param.string2) 
		CASE	'1RNDC' //Por Reversion de Doc. de Nota de Credito		
			dw_1.Retrieve(is_param.string2) 
		CASE	'1INDC' //Por Interes de Fac, Bol , Let x Cobrar
			dw_1.Retrieve(is_param.string2) 						
		CASE	'1DNCC' //Por Descuento por Pronto Pago
			dw_1.Retrieve(is_param.string2)
		CASE	'1GR'	  //Guias de Remision sin Orden de Venta
			dw_1.Retrieve(is_param.string2)
		CASE	'1PED'  //Comprobante de Egreso
			dw_1.Retrieve(is_param.string3)
		CASE	'1CHC'  //Cheques a Conciliar
			dw_1.Retrieve(is_param.string2)	
		CASE	'1DCC'  //Documentos a Conciliar		
			dw_1.Retrieve(is_param.string2)	
		CASE	'1NVP'  //nota debito credito x pagar
			dw_1.Retrieve(is_param.string4)	
		CASE 'CPFEC'		
			dw_1.Retrieve(is_param.string2,is_param.string3)	
		CASE '1ARTF'		
			dw_1.Retrieve(is_param.string2,is_param.date1,is_param.date2)	
		CASE '1FP'   //Facturacion Pesca / Cantidad
			dw_1.Retrieve(is_param.string2)
	END CHOOSE
END IF


//** Datastore Cuentas x Cobrar Detalle **//
ids_cntas_cobrar_det = Create u_ds_base
ids_cntas_cobrar_det.DataObject = 'd_cntas_x_cobrar_det_tbl'
ids_cntas_cobrar_det.SettransObject(sqlca)
////** **//


//** Datastore Cuentas x Pagar Detalle **//
ids_cntas_pagar_det = Create u_ds_base
ids_cntas_pagar_det.DataObject = 'd_cntas_pagar_det_tbl'
ids_cntas_pagar_det.SettransObject(sqlca)
//** **//

//** Datastore Impuesto Cuentas x Pagar Detalle **//
ids_imp_x_pagar = Create u_ds_base
ids_imp_x_pagar.DataObject = 'd_impuestos_x_pagar'
ids_imp_x_pagar.SettransObject(sqlca)
//** **//

//** Datastore Impuesto Cuentas x Cobrar Detalle x Item **//
ids_imp_x_cobrar = Create u_ds_base
ids_imp_x_cobrar.DataObject = 'd_impuestos_x_cobrar_tbl'
ids_imp_x_cobrar.SettransObject(sqlca)
//** **//

//** Datastore Impuesto Cuentas x Cobrar Detalle x Todo el Documento **//
ids_imp_x_cobrar_x_item = Create u_ds_base
ids_imp_x_cobrar_x_item.DataObject = 'd_impuestos_x_cobrar_x_item_tbl'
ids_imp_x_cobrar_x_item.SettransObject(sqlca)
//** **//

//** Datastore de Articulos a vender **//
ids_art_a_vender = Create u_ds_base
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.SettransObject(sqlca)
//** **//


end event

event open;//override
THIS.EVENT ue_open_pre()
end event

event resize;call super::resize;
pb_1.x 	  = newwidth/2 - pb_1.width / 2
pb_2.x 	  = pb_1.x

dw_1.height = newheight  - dw_1.y - 10
dw_1.width  = pb_1.x  - dw_1.x - 10

dw_2.x		= pb_1.x + pb_1.width + 10
dw_2.width  = newwidth  - dw_2.x - 10
dw_2.height = newheight  - dw_2.y - 10

cb_transferir.x = dw_2.x + dw_2.width - cb_transferir.width

dw_3.width = cb_Transferir.x - dw_3.x - 10


end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista_search
integer x = 0
integer y = 128
integer width = 517
end type

event dw_1::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if

ii_ss 	  = 0
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 				// dw_detail 

ii_ck[1] = 1         // columnas de lectrua de este dw


ii_ss = 0
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	  ll_row, ll_rc, ll_count
Any	  la_id
Integer li_x


ll_row = dw_2.EVENT ue_insert()

ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
//	is_tipo = 
	is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista_search
integer x = 690
integer y = 128
integer width = 517
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1
CHOOSE CASE is_param.opcion 
		 CASE 1 //Proveedores Programa de Pagos
				ii_rk[1] = 1		//Codigo
				ii_rk[2] = 2		//Nombres
				ii_dk[1] = 1		//Codigo
				ii_dk[2] = 2		//Nombres
		 CASE 2 //Bancos
				ii_rk[1] = 1		//Codigo
				ii_rk[2] = 2		//Nombres
				ii_dk[1] = 1		//Codigo
				ii_dk[2] = 2		//Nombres
		 CASE 3    //Documentos x Pagar
			
				ii_rk[1] = 1		//
				ii_rk[2] = 2		//
				ii_rk[3] = 3		//
				ii_rk[4] = 4		//
				ii_rk[5] = 5		//
				ii_rk[6] = 6		//
				ii_rk[7] = 7		//
				ii_rk[8] = 8		//
				////////
				ii_dk[1] = 1		//
				ii_dk[2] = 2		//
				ii_dk[3] = 3		//
				ii_dk[4] = 4		//
				ii_dk[5] = 5		//
				ii_dk[6] = 6		//
				ii_dk[8] = 8		//
		 CASE 4    //Ajuste x Cantidad y/o precio de nc,nd x cobrar
				ii_rk[1] = 1		//Tipo Doc
				ii_rk[2] = 2		//Nro Doc 
				ii_rk[3] = 3		//Item
				ii_rk[4] = 4		//Confin
				ii_rk[5] = 5		//Descripcion
				ii_rk[6] = 6		//Codigo Articulo
				ii_rk[7] = 7		//Codigo Moneda
				ii_rk[8] = 8		//Codigo Moneda
				ii_rk[9] = 9		//Matriz Contable
				//////
				ii_dk[1] = 1		//Tipo Doc
				ii_dk[2] = 2		//Nro Doc 
				ii_dk[3] = 3		//Item
				ii_dk[4] = 4		//Confin
				ii_dk[5] = 5		//Descripcion
				ii_dk[6] = 6		//Codigo Articulo
				ii_dk[7] = 7		//Codigo Moneda				
				ii_dk[8] = 8		//Codigo Moneda	
				ii_dk[9] = 9		//Matriz Contable
				
		 CASE 5,6,7			//Por Reversion de Documento 
								//Por Interes de Fac,Bol,Let x Cobrar
								//Por Descuento por Pronto Pago
								
				ii_rk[1] = 1		//Tipo Doc
				ii_rk[2] = 2		//Nro doc
				ii_rk[3] = 3		//Codigo Relacion
				ii_rk[4] = 4		//Moneda
				ii_rk[5] = 5		//Origen
				ii_rk[6] = 6		//Año
				ii_rk[7] = 7		//Mes
				ii_rk[8] = 8		//Nro Libro
				ii_rk[9] = 9		//Nro Asiento
				
				/**/
				ii_dk[1] = 1		//Tipo Doc
				ii_dk[2] = 2		//Nro doc
				ii_dk[3] = 3		//Codigo Relacion
				ii_dk[4] = 4		//Moneda
				ii_dk[5] = 5		//Origen
				ii_dk[6] = 6		//Año
				ii_dk[7] = 7		//Mes
				ii_dk[8] = 8		//Nro Libro
				ii_dk[9] = 9		//Nro Asiento

		 CASE 8 //REPORTE DE LIBRO BANCOS
				ii_dk[1] = 1 //Cuenta de Banco 
				ii_dk[2] = 2 //Descripcion
				ii_dk[3] = 3 //Cuenta Contable
				ii_dk[4] = 4 //Origen
				
				ii_rk[1] = 1 //Cuenta de Banco 
				ii_rk[2] = 2 //Descripcion
				ii_rk[3] = 3 //Cuenta Contable
				ii_rk[4] = 4 //Origen
		CASE	10 //origenes
				ii_rk[1]  = 1  //codigo
				ii_rk[2]  = 2  //descripcion
				
				ii_dk[1]  = 1  //codigo
				ii_dk[2]  = 2  //descripcion							
				
      CASE  11
				ii_rk[1] = 1 //NRO DE GUIA 
				ii_rk[2] = 2 //ORIGEN
				ii_rk[3] = 3 //FECHA DE REGISTRO
				ii_rk[4] = 4 //USUARIO				
				
				ii_dk[1] = 1 //NRO DE GUIA
				ii_dk[2] = 2 //ORIGEN
				ii_dk[3] = 3 //FECHA DE REGISTRO
				ii_dk[4] = 4 //USUARIO
      CASE  12 //Comprobantes de Egresos
				ii_rk[1]  = 1	//cod_relacion
				ii_rk[2]  = 2	//tipo_doc
				ii_rk[3]  = 3	//nro_doc
				ii_rk[4]  = 4	//total_pagar
				ii_rk[5]  = 5	//cod_moneda
				ii_rk[6]  = 6	//nombre
				ii_rk[7]  = 7	//origen
					
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo doc
				ii_dk[3]  = 3  //nro doc
				ii_dk[4]  = 4  //total_pagar
				ii_dk[5]  = 5  //cod_moneda
				ii_dk[6]  = 6  //nombre
				ii_dk[7]  = 7  //origen
				
		CASE	13 ,15 //Cheques a Conciliar,Documentos a Conciliar
				ii_rk [1] = 1 //Nro Reg cheque
				ii_rk [2] = 2 //Cuenta de Banco	
				ii_rk [3] = 3 //Nro de Cheque
				ii_rk [4] = 4 //Importe
				ii_rk [5] = 5 //Origen Caja Bancos
				ii_rk [6] = 6 //Nro Registro Caja Bancos
				ii_rk [7] = 7 //Cheque Afavor
				ii_rk [8] = 8 //Fecha Emision
				ii_rk [9] = 9 //Voucher				
							
				ii_dk [1] = 1 //Nro Reg cheque
				ii_dk [2] = 2 //Cuenta de Banco	
				ii_dk [3] = 3 //Nro de Cheque
				ii_dk [4] = 4 //Importe
				ii_dk [5] = 5 //Origen Caja Bancos
				ii_dk [6] = 6 //Nro Registro Caja Bancos
				ii_dk [7] = 7 //Cheque Afavor
				ii_dk [8] = 8 //Fecha Emision
				ii_dk [9] = 9 //Voucher
				
		CASE	14,16,17,18 //Articulo,Concepto financiero
				ii_rk [1] = 1 //Codigo
				ii_rk [2] = 2 //Nombre
				
				ii_dk [1] = 1 //Codigo
				ii_dk [2] = 2 //Nombre
		CASE 19		
				ii_rk [1] = 1 //Codigo
				ii_rk [2] = 2 //Nombre
				ii_rk [3] = 3 //Unidad
				
				ii_dk [1] = 1 //Codigo
				ii_dk [2] = 2 //Nombre
				ii_dk [3] = 3 //Unidad
			
		CASE 20  //Facturacion de Cantidad de Pesca
				ii_dk[1]  = 1	//Parte_Pesca
				ii_dk[2]  = 2	//Nave
				ii_dk[3]  = 3	//Nombre de Nave
				ii_dk[4]  = 4	//hora_inicio	
				ii_dk[5]  = 5	//hora_fin
				ii_dk[6]  = 6	//Puerto de Arribo
				ii_dk[7]  = 7	//Descr Puerto Arribo
				ii_dk[8]  = 8	//cliente
				ii_dk[9]  = 9	//especie
				ii_dk[10] = 10	//cod_art
				ii_dk[11] = 11	//desc_especie
				ii_dk[12] = 12 //cantidad
				ii_dk[13] = 13 //unidad
				ii_dk[14] = 14 //precio_unitario
				ii_dk[15] = 15 //cod_moneda
				ii_dk[16] = 16 //Matricula de nave
				
								
				ii_rk[1]  = 1	//Parte_Pesca
				ii_rk[2]  = 2	//Nave
				ii_rk[3]  = 3	//Nombre de Nave
				ii_rk[4]  = 4	//hora_inicio	
				ii_rk[5]  = 5	//hora_fin
				ii_rk[6]  = 6	//Puerto de Arribo
				ii_rk[7]  = 7	//Descr Puerto Arribo
				ii_rk[8]  = 8	//cliente
				ii_rk[9]  = 9	//especie
				ii_rk[10] = 10	//cod_art
				ii_rk[11] = 11	//desc_especie
				ii_rk[12] = 12 //cantidad
				ii_rk[13] = 13 //unidad
				ii_rk[14] = 14 //precio_unitario
				ii_rk[15] = 15 //cod_moneda
				ii_rk[16] = 16 //Matricula de nave
		
				
		CASE 21  //Facturacion de Aparejos de Pesca
					ii_dk[1]  = 1	//Parte_Pesca
				ii_dk[2]  = 2	//Nave
				ii_dk[3]  = 3	//Nombre de Nave
				ii_dk[4]  = 4	//hora_inicio	
				ii_dk[5]  = 5	//hora_fin
				ii_dk[6]  = 6	//Puerto arribo
				ii_dk[7]  = 7	//Desc Puerto
				ii_dk[8]  = 8	//cliente
				ii_dk[9] = 	9  //especie
				ii_dk[10] = 10	//cod_art	
				ii_dk[11] = 11 //desc_articulo	
				ii_dk[12] = 12 //unidad
				ii_dk[13] = 13 //precio_unitario
				ii_dk[14] = 14 //cod_moneda
				ii_dk[15] = 15 //Matricula de nave
								
				ii_rk[1]  = 1	//Parte_Pesca
				ii_rk[2]  = 2	//Nave
				ii_rk[3]  = 3	//Nombre de Nave
				ii_rk[4]  = 4	//hora_inicio	
				ii_rk[5]  = 5	//hora_fin
				ii_rk[6]  = 6	//Puerto arribo
				ii_rk[7]  = 7	//Desc Puerto
				ii_rk[8]  = 8	//cliente
				ii_rk[9] = 	9  //especie
				ii_rk[10] = 10	//cod_art	
				ii_rk[11] = 11 //desc_articulo	
				ii_rk[12] = 12 //unidad
				ii_rk[13] = 13 //precio_unitario
				ii_rk[14] = 14 //cod_moneda
				ii_rk[15] = 15 //Matricula de nave
								
				
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

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista_search
integer x = 530
integer y = 448
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista_search
integer x = 530
integer y = 696
end type

type cb_transferir from commandbutton within w_abc_seleccion_lista_search
integer x = 2363
integer width = 297
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;Long   ll_inicio,ll_found,ll_row,ll_row_det,ll_item,ll_ins_row,ll_inicio_cab, &
		 ll_ins_row_det,ll_inicio_det,ll_ind_guia
String ls_codigo,ls_expresion,ls_origen_ref,ls_tipo_ref,ls_nro_ref,&
       ls_flab_tabor,ls_cod_relacion,ls_cod_moneda,ls_cod_moneda_det,&
		 ls_cod_art,ls_confin,ls_descrip,ls_tipo_doc,ls_nro_doc,ls_tip_impuesto,&
		 ls_cnta_ctbl,ls_desc_impuesto,ls_signo,ls_desc_cnta,ls_matriz,&
		 ls_flag_dh  ,ls_cod_origen,ls_guia_rem,ls_cegreso,ls_null,ls_doc_cheque,&
		 ls_descripcion,ls_grupo,ls_desc_grupo
Decimal ldc_precio_unitario, ldc_cantidad_det, ldc_tasa_imp,ldc_imp_imp

dw_2.Accepttext()


CHOOSE CASE is_param.opcion
	CASE 1 //Programa de Pagos
		FOR ll_inicio = 1 TO dw_2.Rowcount()
			 ls_codigo = dw_2.Object.codigo [ll_inicio]	 
			 //Inserción de Proveedores
			 Insert Into tt_fin_proveedor
			 (cod_proveedor)  
			 VALUES 
			 (:ls_codigo)  ;
			parent.setmicrohelp( string(ll_inicio))
		NEXT	
		
	CASE 2 //Bancos
		FOR ll_inicio = 1 TO dw_2.Rowcount()
			 ls_codigo = dw_2.Object.cod_banco [ll_inicio]	 
			 //Inserción de Proveedores
			 Insert Into tt_fin_banco
			 (cod_banco)  
			 VALUES 
			 (:ls_codigo)  ;
		NEXT	
		
	CASE 3 //NOTA DE VENTAS X PAGAR						
		is_param.dw_m.Accepttext()
		is_param.dw_d.Accepttext()
		For ll_inicio = 1 TO dw_2.Rowcount()
			 //Motivo del Documento is_param.string3  
			 IF is_param.string3 = 'NCP002' THEN //Reversión de Documento
				 IF is_param.dw_d.Rowcount()  > 0 THEN
					 Messagebox('Aviso','No Puede Ingresar Mas De Un documento Cuando se '&
											 +'Trata de Reversión de Documento')
					 GOTO SALIDA	 					  
				 END IF
			 END IF
			 
			 ls_origen_ref	    = dw_2.Object.origen		 [ll_inicio]
			 ls_tipo_ref	    = dw_2.Object.tipo_doc     [ll_inicio]
			 ls_nro_ref		    = dw_2.Object.nro_doc      [ll_inicio]
			 ls_flab_tabor	    = dw_2.Object.flag_tabla   [ll_inicio]
			 ls_cod_relacion   = dw_2.Object.cod_relacion [ll_inicio]
			 ls_cod_moneda_det = dw_2.object.cod_moneda   [ll_inicio] 
			 
			 ls_expresion = 'origen_ref = '+"'"+ls_origen_ref+"'"+' AND tipo_ref = '&
								+"'"+ls_tipo_ref+"'"+' AND nro_ref = '+"'"+ls_nro_ref+"'"
		
			 ll_found = is_param.dw_d.find(ls_expresion,1,is_param.dw_d.rowcount())
			 
			IF ll_found > 0 THEN
				Messagebox('Aviso','Documento '+ls_tipo_ref+' '+ls_nro_ref+' Ya Ha Sido Tomado En cuenta Verifique1!')
				GOTO SALIDA
			ELSE
				//**Moneda de Cabecera**//
				ls_cod_moneda 		= is_param.dw_m.object.cod_moneda [1] 
				
				IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
					is_param.dw_m.object.cod_moneda [1]  = ls_cod_moneda_det
				ELSE
					IF ls_cod_moneda <> ls_cod_moneda_det THEN
						Messagebox( 'Aviso','Documento '+ls_tipo_ref+' '+ls_nro_ref&
									  +' Tiene Diferente Tipo de Moneda Verifique!')								
						GOTO SALIDA
					END IF
				END IF
				
				//** **//
				
				ll_row = is_param.dw_d.InsertRow(0)
	
				is_param.dw_d.object.cod_relacion [ll_row] = ls_cod_relacion
				is_param.dw_d.object.tipo_mov     [ll_row] = 'P'
				is_param.dw_d.object.origen_ref   [ll_row] = ls_origen_ref
				is_param.dw_d.object.tipo_ref	    [ll_row] = ls_tipo_ref
				is_param.dw_d.object.nro_ref	    [ll_row] = ls_nro_ref
				is_param.dw_d.object.flab_tabor   [ll_row] = ls_flab_tabor
				
				is_param.accion = 'aceptar'
				
				//*Motivo Por Reversión de Documento*//
				IF is_param.string3 = 'NCP002' THEN
					
					ids_cntas_pagar_det.Retrieve(ls_cod_relacion,ls_tipo_ref,ls_nro_ref)
					ids_imp_x_pagar.Retrieve(ls_cod_relacion,ls_tipo_ref,ls_nro_ref)
					
					/*Inserto detalle de Cntas x Pagar*/
					For ll_inicio = 1 TO ids_cntas_pagar_det.Rowcount()
						 ll_row_det = is_param.dw_c.InsertRow(0)								 
						 is_param.dw_c.Object.cod_relacion     [ll_inicio] = ids_cntas_pagar_det.Object.cod_relacion     [ll_row_det]
						 is_param.dw_c.Object.item             [ll_inicio] = ids_cntas_pagar_det.Object.item 				 [ll_row_det]
						 is_param.dw_c.Object.descripcion	   [ll_inicio] = ids_cntas_pagar_det.Object.descripcion 	    [ll_row_det]
						 is_param.dw_c.Object.cod_art          [ll_inicio] = ids_cntas_pagar_det.Object.cod_art 			 [ll_row_det]
						 is_param.dw_c.Object.confin           [ll_inicio] = ids_cntas_pagar_det.Object.confin 			 [ll_row_det]
						 is_param.dw_c.Object.cantidad         [ll_inicio] = ids_cntas_pagar_det.Object.cantidad 		    [ll_row_det]
						 is_param.dw_c.Object.importe          [ll_inicio] = ids_cntas_pagar_det.Object.importe 			 [ll_row_det]
						 is_param.dw_c.Object.cencos           [ll_inicio] = ids_cntas_pagar_det.Object.cencos 			 [ll_row_det]
						 is_param.dw_c.Object.cnta_prsp        [ll_inicio] = ids_cntas_pagar_det.Object.cnta_prsp		    [ll_row_det]
						 is_param.dw_c.Object.tipo_cred_fiscal [ll_inicio] = ids_cntas_pagar_det.Object.tipo_cred_fiscal [ll_row_det]
						 is_param.dw_c.Object.matriz_cntbl		[ll_inicio] = ids_cntas_pagar_det.Object.matriz_cntbl		 [ll_row_det]
	//								 is_param.dw_c.Object.flag_hab			[ll_inicio] = 'S'
					Next
				
					//**// 
				
					/*Inserto detalle de Impuesto x Cntas x Pagar*/
					For ll_inicio = 1 TO ids_imp_x_pagar.Rowcount()
						 ll_row_det = is_param.dw_e.InsertRow(0)
						 is_param.dw_e.Object.cod_relacion  [ll_row_det] = ids_imp_x_pagar.Object.cod_relacion  [ll_inicio]
						 is_param.dw_e.Object.tipo_doc	   [ll_row_det] = ids_imp_x_pagar.Object.tipo_doc 	    [ll_inicio]
						 is_param.dw_e.Object.nro_doc       [ll_row_det] = ids_imp_x_pagar.Object.nro_doc 		 [ll_inicio] 
						 is_param.dw_e.Object.item          [ll_row_det] = ids_imp_x_pagar.Object.item 			 [ll_inicio] 
						 is_param.dw_e.Object.tipo_impuesto [ll_row_det] = ids_imp_x_pagar.Object.tipo_impuesto [ll_inicio]
						 is_param.dw_e.Object.importe		   [ll_row_det] = ids_imp_x_pagar.Object.importe		 [ll_inicio]
						 is_param.dw_e.Object.tasa_impuesto [ll_row_det] = ids_imp_x_pagar.Object.tasa_impuesto [ll_inicio]
						 is_param.dw_e.Object.flag          [ll_row_det] = 'S'
						 is_param.dw_e.Object.cnta_ctbl		[ll_row_det] = ids_imp_x_pagar.Object.cnta_ctbl 	 [ll_inicio]
						 is_param.dw_e.Object.desc_impuesto	[ll_row_det] = ids_imp_x_pagar.Object.desc_impuesto [ll_inicio]
						 is_param.dw_e.Object.signo			[ll_row_det] = ids_imp_x_pagar.Object.signo			 [ll_inicio]
						 is_param.dw_e.Object.desc_cnta		[ll_row_det] =	ids_imp_x_pagar.Object.desc_cnta		 [ll_inicio]
						 is_param.dw_e.Object.flag_dh_cxp	[ll_row_det] = ids_imp_x_pagar.Object.flag_dh_cxp	 [ll_inicio]
					Next
				
				//**//
				END IF
				
			END IF
			
			SALIDA:
		Next
		
	CASE 4 //Ajuste x Cantidad y/o precio nota debito,credito X cobrar
		IF not of_opcion4() THEN return
	
	CASE 5 //Reversion de documento x Nota de Credito
		IF not of_opcion5() THEN return
		
	CASE 6 //Interes de Boletas ,Facturas ,Letras x Cobrar
		For ll_inicio_cab = 1 TO dw_2.Rowcount()
			 /*Moneda de Cabecera*/
			 ls_cod_moneda = is_param.dw_m.object.cod_moneda [1]
			 
			 ls_tipo_doc   = dw_2.object.tipo_doc [ll_inicio_cab]
			 ls_nro_doc	   = dw_2.object.nro_doc  [ll_inicio_cab]
			 
			 ls_expresion = 'tipo_ref = '+"'"+ls_tipo_doc+"' AND nro_ref = "+"'"+ls_nro_doc+"'"
			 ll_found	  = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.rowcount())
	
			 IF ll_found = 0 THEN						 
				 /*Documento No Ha Sido Tomado En Cuenta*/	
				 
				 ls_cod_moneda_det = dw_2.object.cod_moneda [ll_inicio_cab]
				  
				 IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
					 ls_cod_moneda = ls_cod_moneda_det
					 is_param.dw_m.object.cod_moneda [1] = ls_cod_moneda
				 END IF
			 
				 IF ls_cod_moneda <> ls_cod_moneda_det THEN //Si Moneda es Diferente Salir
					 Messagebox ('Aviso','Aviso No Puede Escoger Un Documento con Otro Tipo de Moneda , Verifique!')
					 EXIT
				 END IF
				 //Inserta Detalle
				  
				 ids_cntas_cobrar_det.Retrieve(ls_tipo_doc,ls_nro_doc)
				 For ll_inicio = 1 TO ids_cntas_cobrar_det.Rowcount()
					  ll_item		 	    = ids_cntas_cobrar_det.object.item 		     [ll_inicio]
					  ls_cod_art	 	    = ids_cntas_cobrar_det.object.cod_art 	     [ll_inicio]
					  ls_descrip	 	    = ids_cntas_cobrar_det.object.descripcion     [ll_inicio]
					  ldc_cantidad_det    = ids_cntas_cobrar_det.object.cantidad	     [ll_inicio]
					  ldc_precio_unitario = ids_cntas_cobrar_det.object.precio_unitario [ll_inicio] 
					  
					  ll_ins_row = is_param.dw_d.InsertRow(0)
					  /*Activara ii_update de dw_detail e impuestos */
					  is_param.titulo = 's'
				  
					  is_param.dw_d.Object.item 	     		[ll_ins_row] = ll_ins_row
					  is_param.dw_d.Object.tipo_ref    		[ll_ins_row] = ls_tipo_doc
					  is_param.dw_d.Object.nro_ref     		[ll_ins_row] = ls_nro_doc
					  is_param.dw_d.Object.item_ref   		[ll_ins_row] = ll_item
					  is_param.dw_d.Object.cod_art     		[ll_ins_row] = ls_cod_art
					  is_param.dw_d.Object.descripcion 		[ll_ins_row] = ls_descrip
					  is_param.dw_d.Object.precio_unitario [ll_ins_row] = ldc_precio_unitario
					  is_param.dw_d.Object.cantidad    		[ll_ins_row] = ldc_cantidad_det 
					  is_param.dw_d.Object.flag_aj  			[ll_ins_row] = 'INT' //INTERES
					  is_param.dw_d.Object.flag_rev 			[ll_ins_row] = 'INT'
					  is_param.dw_d.Object.flag_int		   [ll_ins_row] = 'INT'
					  
				
					  /**Insertar Impuestos**/
					  ids_imp_x_cobrar_x_item.Retrieve(ls_tipo_doc,ls_nro_doc, ll_item)
	
					  For ll_inicio_det = 1 TO ids_imp_x_cobrar_x_item.Rowcount()
							ls_tip_impuesto  = ids_imp_x_cobrar_x_item.object.tipo_impuesto 	[ll_inicio_det]
							ls_cnta_ctbl	  = ids_imp_x_cobrar_x_item.object.cnta_ctbl	   	[ll_inicio_det]
							ls_desc_impuesto = ids_imp_x_cobrar_x_item.object.desc_impuesto 	[ll_inicio_det]
							ldc_tasa_imp	  = ids_imp_x_cobrar_x_item.object.tasa_impuesto 	[ll_inicio_det]
							ls_signo			  = ids_imp_x_cobrar_x_item.object.signo				[ll_inicio_det]
							ls_desc_cnta	  = ids_imp_x_cobrar_x_item.object.desc_cnta	   	[ll_inicio_det]
							ldc_imp_imp		  = ids_imp_x_cobrar_x_item.object.importe		   [ll_inicio_det]
							ls_flag_dh		  = ids_imp_x_cobrar_x_item.object.flag_dh		   [ll_inicio_det]									  
						  
							ll_ins_row_det = is_param.dw_c.insertRow(0)	
							/*Activar ii_update*/
							is_param.dw_c.Object.item 	  	     [ll_ins_row_det] = ll_ins_row
							is_param.dw_c.Object.tipo_impuesto [ll_ins_row_det] = ls_tip_impuesto
							is_param.dw_c.Object.cnta_ctbl	  [ll_ins_row_det] = ls_cnta_ctbl
							is_param.dw_c.Object.desc_impuesto [ll_ins_row_det] = ls_desc_impuesto
							is_param.dw_c.Object.tasa_impuesto [ll_ins_row_det] = ldc_tasa_imp
							is_param.dw_c.Object.signo			  [ll_ins_row_det] = ls_signo
							is_param.dw_c.Object.desc_cnta	  [ll_ins_row_det] = ls_desc_cnta
							is_param.dw_c.Object.importe	  	  [ll_ins_row_det] = ldc_imp_imp
							is_param.dw_c.Object.flag_dh_cxp	  [ll_ins_row_det] = ls_flag_dh									
							is_param.dw_c.Object.flag_tipo	  [ll_ins_row_det] = 'INT' //Interes
							is_param.dw_c.Object.flag_imp		  [ll_ins_row_det] = 'INT'
	
							is_param.dw_c.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag_tipo),1,0)'")
							is_param.dw_c.Modify("importe.Protect='1~tIf(IsNull(flag_imp),1,0)'")					 
							//campos Bloqueados no editables
					  Next   	
				 Next
				 
				 is_param.dw_d.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
				 is_param.dw_d.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
				 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
				 is_param.dw_d.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
				 //ningun campo editables			
			 ELSE						 
				 Messagebox('Aviso','Documento '+ls_tipo_doc+' '+ls_nro_doc+' Ha Sido Tomado En Cuenta')						 					 
			 END IF
	
		Next
	
	CASE 7 //Descuento por pronto pago				
		For ll_inicio_cab = 1 TO dw_2.Rowcount()
			 ls_tipo_doc = dw_2.object.tipo_doc [ll_inicio_cab]
			 ls_nro_doc	 = dw_2.object.nro_doc  [ll_inicio_cab]	
			 
			 ls_expresion = 'tipo_ref = '+"'"+ls_tipo_doc+"' AND nro_ref = "+"'"+ls_nro_doc+"'"
			 ll_found	  = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.rowcount())
			 IF ll_found = 0 THEN
				 /*Documento No Ha Sido Tomado En Cuenta*/	
				 ll_ins_row = is_param.dw_d.InsertRow(0)
				 /*Activara ii_update de dw_master*/
				 is_param.titulo = 's'
				 
				 /*Activar ii_update*/
				 is_param.dw_d.Object.item		 [ll_ins_row] = ll_ins_row
				 is_param.dw_d.Object.tipo_ref [ll_ins_row] = ls_tipo_doc
				 is_param.dw_d.Object.nro_ref  [ll_ins_row] = ls_nro_doc	  
				 is_param.dw_d.Object.flag_aj  [ll_ins_row] = 'DES'
				 is_param.dw_d.Object.flag_rev [ll_ins_row] = 'DES'
			 
				 is_param.dw_d.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
				 is_param.dw_d.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
				 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
				 is_param.dw_d.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
				 
			 ELSE
				 Messagebox('Aviso','Documento '+ls_tipo_doc+' '+ls_nro_doc+' Ha Sido Tomado En Cuenta')						 
			 END IF
		Next
	CASE 8 //Insercion de Cuentas Bancarias
		FOR ll_inicio = 1 TO dw_2.Rowcount()
			ls_codigo = dw_2.Object.cod_ctabco [ll_inicio]	 
	
			Insert Into tt_fin_rpt_cta_bco
			(cod_ctabco)  
			VALUES 
			(:ls_codigo)  ;
			
		NEXT
		
	CASE	10		
		For ll_inicio = 1 TO dw_2.Rowcount() //Origenes
			 ls_codigo = dw_2.object.cod_origen [ll_inicio]
			 
			 Insert into tt_fin_origenes
			 (cod_origen)
			 Values
			 (:ls_codigo);
		Next					
		
	CASE	11 /*GUIAS SIN OV*/
	if not of_opcion11() then return					
	
	
	
	CASE	12 /*COMPROBANTE DE EGRESOS (EGRESOS DIRECTOS)*/
		SELECT comprobante_egr
		  INTO :ls_cegreso
		  FROM finparam
		 WHERE (reckey = '1') ;
		 
		FOR ll_inicio = 1 TO dw_2.Rowcount()
			 /*Verificar si Comprobante de Egreso ya fue ingresado*/
			 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
			 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
			 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
			 
			 ll_found = wf_verifica_ed (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
			 IF ll_found > 0 THEN
				 Messagebox('Aviso','Comprobante de Egreso '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
			 ELSE	 
				 is_param.bret = TRUE
				 ll_row = is_param.dw_m.InsertRow(0) 
				 is_param.dw_m.object.item		        [ll_row] = ll_row
				 is_param.dw_m.object.origen_doc      [ll_row] = dw_2.object.origen	     [ll_inicio]
				 is_param.dw_m.object.cod_relacion    [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
				 is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
				 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
				 is_param.dw_m.object.cod_moneda_det  [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
				 is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string4
				 is_param.dw_m.object.tasa_cambio     [ll_row] = is_param.field_ret_d3	  [1]
				 is_param.dw_m.object.importe         [ll_row] = dw_2.object.total_pagar   [ll_inicio]
				 is_param.dw_m.object.flab_tabor      [ll_row] = 'C'
				 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'
				 
				 IF ls_tipo_doc = ls_cegreso THEN //COMPROBANTE EGRESO
					 is_param.dw_m.object.flag_tip_doc	 [ll_row] = '1'
				 ELSE
					 Setnull(ls_null)
					 is_param.dw_m.object.flag_tip_doc	 [ll_row] = ls_null
				 END IF
			 END IF
			 
		NEXT	
		
	CASE 13	//CONCILIACION DE CHEQUES
		SELECT doc_cheque
		  INTO :ls_doc_cheque 
		  FROM finparam
		 WHERE (reckey = '1') ;
		
		IF dw_2.Rowcount() > 1 THEN
			Messagebox('Aviso','Debe Seleccionar Solo Un Documento')
			Return
		END IF
		
		For ll_inicio = 1 TO dw_2.Rowcount()
			 is_param.dw_m.object.tipo_doc       [is_param.long1] = ls_doc_cheque
			 is_param.dw_m.object.nro_doc        [is_param.long1] = Trim(String(dw_2.object.cheque_emitir_nro_cheque  [ll_inicio]))
			 is_param.dw_m.object.fecha_doc      [is_param.long1] = dw_2.object.caja_bancos_fecha_emision [ll_inicio]
			 is_param.dw_m.object.origen_cajban  [is_param.long1] = dw_2.object.caja_bancos_origen        [ll_inicio]
			 is_param.dw_m.object.nro_reg_cajban [is_param.long1] = dw_2.object.caja_bancos_nro_registro  [ll_inicio]
			 is_param.dw_m.object.importe			 [is_param.long1] = dw_2.object.cheque_emitir_importe		 [ll_inicio]
			 
		Next
		
	CASE 14	//articulos
		IF dw_2.Rowcount() = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Algun Registro , Verifique!')
			Return
		END IF
		
		delete tt_fin_rpt_art;
		
		if gnvo_app.of_ExistsError(SQLCA, "Eliminar tt_fin_rpt_art") then return
		
		For ll_inicio = 1 TO dw_2.Rowcount()
			 ls_codigo = dw_2.Object.cod_art [ll_inicio]	 
			 //Inserción de Proveedores
			 Insert Into tt_fin_rpt_art(cod_art)  
			 VALUES (:ls_codigo)  ;
			 if gnvo_app.of_ExistsError(SQLCA, "insertar tt_fin_rpt_art") then return
		Next
		
	
	CASE 15 //DOCUMENTOS a conciliar
	
		
		IF dw_2.Rowcount() > 1 THEN
			Messagebox('Aviso','Debe Seleccionar Solo Un Documento')
			Return
		END IF
		
		For ll_inicio = 1 TO dw_2.Rowcount()
			 is_param.dw_m.object.tipo_doc       [is_param.long1] = dw_2.object.caja_bancos_tipo_doc 		 [ll_inicio]
			 is_param.dw_m.object.nro_doc        [is_param.long1] = dw_2.object.caja_bancos_nro_doc 		 [ll_inicio]
			 is_param.dw_m.object.fecha_doc      [is_param.long1] = dw_2.object.caja_bancos_fecha_emision [ll_inicio]
			 is_param.dw_m.object.origen_cajban  [is_param.long1] = dw_2.object.caja_bancos_origen        [ll_inicio]
			 is_param.dw_m.object.nro_reg_cajban [is_param.long1] = dw_2.object.caja_bancos_nro_registro  [ll_inicio]
			 is_param.dw_m.object.importe			 [is_param.long1] = dw_2.object.caja_bancos_imp_total		 [ll_inicio]
			 
		Next
	
	CASE 16	//concepto financiero
		IF dw_2.Rowcount() = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Algun Registro , Verifique!')
			Return
		END IF
		
		
		For ll_inicio = 1 TO dw_2.Rowcount()
			 ls_codigo 		 = dw_2.Object.confin      [ll_inicio]	 
			 ls_descripcion = dw_2.Object.descripcion [ll_inicio]	 
			 
			 //Inserción de Concepto Financiero
			 Insert Into tt_fin_rpt_confin
			 (confin,descripcion)  
			 VALUES 
			 (:ls_codigo,:ls_descripcion) ;
			 
			 
		Next
	CASE	17 // GRUPO DE RELACION
		IF dw_2.Rowcount() = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
			Return
		END IF
		
		FOR ll_inicio = 1 TO dw_2.Rowcount ()
			 ls_grupo = dw_2.object.grupo [ll_inicio]
			 INSERT INTO tt_fin_proveedor
			 (cod_proveedor)
			 SELECT cod_relacion FROM cod_rel_agrupamiento WHERE grupo = :ls_grupo ;
		NEXT
		
	CASE 18 //	GRUPO DE ARTICULOS
		IF dw_2.Rowcount() = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
			Return
		END IF
	
		FOR ll_inicio = 1 TO dw_2.Rowcount ()
			 ls_grupo 		= dw_2.object.grupo_art 	  [ll_inicio]				 				
			 ls_desc_grupo = dw_2.object.desc_grupo_art [ll_inicio]
			 
			 INSERT INTO tt_fin_rpt_art
			 (cod_art)
			 SELECT cod_art FROM rel_articulo_grupo WHERE grupo_art = :ls_grupo;
			 
			 is_param.titulo = ls_desc_grupo
		NEXT
	
	CASE 19 //	ARTICULOS
		IF dw_2.Rowcount() = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
			Return
		END IF
	
		FOR ll_inicio = 1 TO dw_2.Rowcount ()
			 ls_cod_art    = dw_2.object.codigo [ll_inicio]				 				
			 
			 INSERT INTO tt_fin_rpt_art
			 (cod_art)
			 Values
			 (:ls_cod_art) ;
		NEXT
	
	CASE 20 // Facturacion de Pesca / Cantidad
		// Llamar a la funcion para ingresar los articulos
		IF dw_2.rowcount( ) > 0 THEN
			IF of_insert_art_fp_cant () =  0 THEN
				messagebox('Aviso', 'Error en funcion de ingreso de Articulo')
			END IF
		END IF
	
	CASE 21 // Facturacion de Pesca / Aparejos
		// Llamar a la funcion para ingresar los articulos
		IF dw_2.rowcount( ) > 0 THEN
			IF of_insert_fp_aparejo () =  0 THEN
				messagebox('Aviso', 'Error en funcion de ingreso de Aparejos')
			END IF
		END IF
		
	CASE	22 /*DESCUENTOS POR ANTICIPOS EN CNTAS X COBRAR*/
		if not of_opcion22() then return					
				
	CASE	23 /*FACTURACION A PARTIR DE VALES DE SALIDA*/
		if not of_opcion23() then return					

	CASE	24 /*SELECCIONAR LOS VENDEDORES*/
		if not of_opcion24() then return		
		
	CASE	25 /*SELECCIONAR UBIGEO*/
		if not of_opcion25() then return	
		
	CASE	26 /*SELECCIONAR ESPECIES*/
		if not of_opcion26() then return		
	
	CASE	27 /*SELECCIONAR CATEGORIAS PENDIENTES*/
		if not of_opcion27() then return	

	CASE	28 /*SELECCIONAR CATEGORIAS PENDIENTES*/
		if not of_opcion28() then return		
		
	CASE	29 /*SELECCIONAR almacenes*/
		if not of_opcion29() then return		

	CASE	30 /*SELECCIONAR SUB_CATEG*/
		if not of_opcion30() then return			
END CHOOSE

Closewithreturn(parent,is_param)
end event

type st_campo from statictext within w_abc_seleccion_lista_search
integer y = 4
integer width = 1344
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda :"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_abc_seleccion_lista_search
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 1381
integer y = 8
integer width = 974
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
end event

event constructor;Long ll_reg

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
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
			dw_3.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

