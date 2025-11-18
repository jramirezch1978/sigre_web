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
integer width = 3538
integer height = 2276
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
String 			is_col = '', is_tipo, is_m_or_d = 'M', is_doc_gr
integer 			ii_ik[]
str_parametros ist_datos
Boolean 			ib_sel = false
u_ds_base 		ids_imp_x_cobrar, ids_art_a_vender
n_Cst_wait		invo_Wait
end variables

forward prototypes
public function integer of_opcion1 ()
public function integer of_insert_articulos_a_cobrar (string as_cod_origen, string as_nro_guia, string as_orden_venta, double adb_tasa_cambio)
public function integer of_find_art (string as_orden_venta)
public function integer of_opcion2 ()
public function integer of_opcion3 ()
public function integer of_opcion4 ()
public function integer of_opcion5 ()
public function integer of_opcion8 ()
public function integer of_opcion9 ()
public subroutine of_insert_art_ov (string as_orden_venta)
public function boolean of_opcion12 ()
public function long of_insert_guia_ref (string as_cod_origen, string as_nro_guia, u_dw_abc adw_referencias)
public function integer of_get_param ()
public function boolean of_opcion10 ()
end prototypes

public function integer of_opcion1 ();Long 		ll_row_master, ll_j, ll_ind_guia, ll_row, ll_found, ll_nro_amp
String 	ls_orden_venta, ls_origen, ls_guia_rem, ls_org_amp, ls_expresion, &
			ls_tipo_impuesto, ls_confin, ls_matriz, ls_item, ls_bien_serv, ls_desc_cred_fiscal, &
			ls_tipo_cred_fiscal, ls_mensaje
Window	lw_1
Decimal	ldc_impuesto, ldc_tasa_pdbe, ldc_precio_unit, ldc_cantidad, ldc_tasa_impuesto
u_dw_abc ldw_master, ldw_detail, ldw_referencias, ldw_impuestos

try 
	ldw_master 			= ist_datos.dw_m
	ldw_detail			= ist_datos.dw_d
	ldw_referencias 	= ist_datos.dw_c
	ldw_impuestos		= ist_datos.dw_imp
	lw_1					= ist_datos.lw_1
	
	ll_row_master  = dw_master.Getrow()
	ls_orden_venta = Trim(dw_master.Object.nro_ov [ll_row_master])
	
	
	IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
		IF ls_orden_venta <> ist_datos.string2 THEN
			Messagebox('Aviso','No Puede Seleccionar Una Orden de Venta A Diferente a la ya Considerada')
			Return 0
		END IF
	END IF
	
	For ll_j = 1 to dw_2.RowCount()
		 
		ls_origen		= dw_2.Object.cod_origen [ll_j]
		ls_guia_rem 	= dw_2.Object.nro_guia   [ll_j]		 
	
		//Inserto la guia como referencia
		ll_ind_guia = of_insert_guia_ref(ls_origen,ls_guia_rem, ldw_referencias)
		 
		//Busco si el org_amp y nro_amp existen o no
		ls_org_amp = dw_2.object.org_amp	[ll_j]
		ll_nro_amp = dw_2.object.nro_amp	[ll_j]
	
		//Inserto el detalle del articulo
		ll_row = ldw_detail.event ue_insert()
		
		if ll_row > 0 then
			ldw_detail.object.cod_art				[ll_row] = dw_2.object.cod_art 			[ll_j]
			ldw_detail.object.descripcion			[ll_row]	= dw_2.object.desc_art			[ll_j]
			ldw_detail.object.cantidad				[ll_row]	= dw_2.object.cant_pendiente	[ll_j]
			ldw_detail.object.und					[ll_row]	= dw_2.object.und					[ll_j]
			ldw_detail.object.precio_unitario	[ll_row]	= dw_2.object.precio_unit		[ll_j]
			ldw_detail.object.precio_unit_exp	[ll_row]	= dw_2.object.precio_unit		[ll_j]
			ldw_detail.object.descuento			[ll_row]	= 0.00
			ldw_detail.object.redondeo_manual	[ll_row]	= 0.00
			ldw_detail.object.rubro					[ll_row]	= dw_2.object.rubro				[ll_j]
			ldw_detail.object.confin				[ll_row]	= dw_2.object.confin				[ll_j]
			ldw_detail.object.tipo_cred_fiscal	[ll_row]	= gnvo_app.is_null
			ldw_detail.object.centro_benef		[ll_row]	= dw_2.object.centro_benef		[ll_j]
			ldw_detail.object.tipo_ref				[ll_row]	= gnvo_app.is_doc_ov
			ldw_detail.object.nro_ref				[ll_row]	= dw_2.object.nro_ov				[ll_j]
			ldw_detail.object.org_amp_ref			[ll_row]	= dw_2.object.org_amp			[ll_j]
			ldw_detail.object.nro_amp_ref			[ll_row]	= dw_2.object.nro_amp			[ll_j]
			ldw_detail.object.tipo_doc_amp		[ll_row]	= dw_2.object.tipo_doc			[ll_j]
			ldw_detail.object.nro_doc_amp			[ll_row]	= dw_2.object.nro_doc			[ll_j]
			ldw_detail.object.nro_guia				[ll_row]	= dw_2.object.nro_guia			[ll_j]
			ldw_detail.object.org_am				[ll_row]	= dw_2.object.org_am				[ll_j]
			ldw_detail.object.nro_am				[ll_row]	= dw_2.object.nro_am				[ll_j]
			
			//Para el tema de detraccion
			ls_bien_serv	= dw_2.object.bien_serv				[ll_j]
			
			if Not IsNull(ls_bien_Serv) and trim(ls_bien_serv) <> '' then
				ldc_tasa_pdbe	= Dec(dw_2.object.tasa_pdbe				[ll_j])
				ldw_master.object.flag_detraccion 	[1] = '1'
				ldw_master.object.bien_serv		 	[1] = ls_bien_serv
				ldw_master.object.porc_detraccion 	[1] = ldc_tasa_pdbe
				
			end if
			
			if ldw_detail.of_existecampo( "cantidad_und2" ) then
				ldw_detail.object.cantidad_und2	[ll_row]	= dw_2.object.cant_proc_und2	[ll_j]	
			end if
			
			if ldw_detail.of_existecampo( "und2" ) then
				ldw_detail.object.und2				[ll_row]	= dw_2.object.und2				[ll_j]	
			end if
			
			//Obtengo la matriz a partir del confin
			ls_confin = dw_2.object.confin				[ll_j]
			
			select MATRIZ_CNTBL
				into :ls_matriz
			from concepto_financiero cf
			where cf.confin = :ls_confin;
			
			ldw_detail.object.MATRIZ_CNTBL				[ll_row]	= ls_matriz
			
			//Si tiene impuesto entonces lo agrego a impuestos o lo elimino
			ls_tipo_impuesto 	= dw_2.object.tipo_impuesto1		[ll_j]
			ldc_impuesto 		= Dec(dw_2.object.impuesto			[ll_j])
			ldc_precio_unit	= Dec(dw_2.object.precio_unit		[ll_j])
			ldc_cantidad		= Dec(dw_2.object.cant_pendiente	[ll_j])
			ldc_tasa_impuesto	= Dec(dw_2.object.tasa_impuesto 	[ll_j])
			
			if IsNull(ls_tipo_impuesto) and ldc_impuesto <> 0 then
				ROLLBACK;
				MessageBox('Error', 'Error en linea ' + string(ll_j) + ' no ha especificado impuesto y sin embargo el importe de impuesto es > 0, por favor corregir!')
				return 0
			end if
			
			if not IsNull(ls_tipo_impuesto) and ldc_impuesto = 0 then
				ROLLBACK;
				MessageBox('Error', 'Error en linea ' + string(ll_j) + ' el monto de impuesto es diferente de cero y se ha especificado un impuesto, por favor corregir!')
				return 0
			end if
	
			if ldc_impuesto = 0 or IsNull(ls_tipo_impuesto) then
				//Si no tiene impuesto simplemente lo elimino
				//de lo contrario adiciono el impuesto
				ls_item 		 = String(ldw_detail.object.nro_item[ll_row])
				ls_expresion = "item =" + ls_item
				ll_found = ldw_impuestos.find( ls_expresion, 1, ldw_impuestos.RowCount())
				
				if ll_found > 0 then
					ldw_impuestos.DeleteRow(ll_found)
					ldw_impuestos.ii_update = 1
				end if
				
				if ldc_impuesto = 0 and ldc_precio_unit = 0 then
					
					ls_tipo_cred_fiscal = gnvo_app.of_get_parametro("CRED_FISCAL_VENTAS_GRATUITAS", "12")
					
				elseif ldc_impuesto = 0 and ldc_precio_unit > 0 then
					
					ls_tipo_cred_fiscal = gnvo_app.of_get_parametro("CRED_FISCAL_VENTAS_INAFECTAS", "10")	
					
				end if
				
				//Obtengo la descripcion del credito fiscal
				if not isNull(ls_tipo_Cred_fiscal) and trim(ls_tipo_Cred_fiscal) <> '' then
					select descripcion
						into :ls_desc_cred_fiscal
					from credito_fiscal cf
					where tipo_cred_fiscal 	= :ls_tipo_cred_fiscal
					  and flag_estado			= '1';
					
					if SQLCA.SQlCode = 100 then
						rollback;
						MessageBox('Error', 'El tipo de Credito Fiscal ' + ls_tipo_cred_fiscal + ' no existe o no se encuentra activo, por favor verifique!', StopSign!)
						return 0
					end if
					
					if SQLCA.SQlCode < 0 then
						ls_mensaje = SQLCA.SQLErrText
						rollback;
						MessageBox('Error', 'Ha ocurrido un error al consultar la table credito_fiscal. Mensaje: ' + ls_mensaje, StopSign!)
						return 0
					end if
				else
					ls_desc_cred_fiscal = gnvo_app.is_null
				end if
				
				//Asigno el tipo de credito fiscal
				ldw_detail.object.tipo_cred_fiscal		[ll_row]	= ls_tipo_cred_fiscal
				ldw_detail.object.desc_tipo_cred_fiscal[ll_row]	= ls_desc_cred_fiscal

			else
				
				//Obtengo el valor del impuesto
				ldc_impuesto 		= ldc_precio_unit * ldc_cantidad * ldc_tasa_impuesto / 100
				
				//Obtengo el tipo de credito fiscal
				if ldc_impuesto <> 0 and ls_tipo_impuesto = gnvo_app.finparam.is_igv  then
					
					ls_tipo_cred_fiscal = gnvo_app.of_get_parametro("CRED_FISCAL_VENTAS_GRAVADAS", "09")
					
				else
					
					ls_tipo_cred_fiscal = gnvo_app.is_null
					
				end if
				
				//Obtengo la descripcion del credito fiscal
				if not isNull(ls_tipo_Cred_fiscal) and trim(ls_tipo_Cred_fiscal) <> '' then
					select descripcion
						into :ls_desc_cred_fiscal
					from credito_fiscal cf
					where tipo_cred_fiscal 	= :ls_tipo_cred_fiscal
					  and flag_estado			= '1';
					
					if SQLCA.SQlCode = 100 then
						rollback;
						MessageBox('Error', 'El tipo de Credito Fiscal ' + ls_tipo_cred_fiscal + ' no existe o no se encuentra activo, por favor verifique!', StopSign!)
						return 0
					end if
					
					if SQLCA.SQlCode < 0 then
						ls_mensaje = SQLCA.SQLErrText
						rollback;
						MessageBox('Error', 'Ha ocurrido un error al consultar la table credito_fiscal. Mensaje: ' + ls_mensaje, StopSign!)
						return 0
					end if
				else
					ls_desc_cred_fiscal = gnvo_app.is_null
				end if
				
				//Asigno el tipo de credito fiscal
				ldw_detail.object.tipo_cred_fiscal		[ll_row]	= ls_tipo_cred_fiscal
				ldw_detail.object.desc_tipo_cred_fiscal[ll_row]	= ls_desc_cred_fiscal
				
				
				//de lo contrario adiciono el impuesto
				ls_item 		 = String(ldw_detail.object.nro_item[ll_row])
				ls_expresion = "item =" + ls_item
				if ldw_impuestos.RowCount () > 0 then
					ll_found = ldw_impuestos.find( ls_expresion, 1, ldw_impuestos.RowCount())
				else
					ll_found = 0
				end if
				
			
				if ll_found = 0 then
					ll_row = ldw_impuestos.event ue_insert()
					if ll_row > 0 then
						ldw_impuestos.object.item 					[ll_row] = Long(ls_item)
						ldw_impuestos.object.importe 				[ll_row] = ldc_impuesto
						ldw_impuestos.object.tasa_impuesto 		[ll_row] = dw_2.object.tasa_impuesto 	[ll_j]
						ldw_impuestos.object.desc_impuesto 		[ll_row] = dw_2.object.desc_impuesto 	[ll_j]
						ldw_impuestos.object.cnta_ctbl 			[ll_row] = dw_2.object.cnta_ctbl 		[ll_j]
						ldw_impuestos.object.desc_cnta 			[ll_row] = dw_2.object.desc_cnta	 		[ll_j]
						ldw_impuestos.object.flag_replicacion	[ll_row] = '1'
						ldw_impuestos.object.signo 				[ll_row] = dw_2.object.signo 				[ll_j]						
						
						//Pongo el tipo de impuesto, si es nulo tomo el IGV
						ldw_impuestos.object.tipo_impuesto 		[ll_row] = ls_tipo_impuesto
						
						// Especifico el flag deb/hab
						if dw_2.object.flag_igv [ll_j] = '1' then
							ldw_impuestos.object.flag_dh_cxp 		[ll_row] = 'H'
						else
							ldw_impuestos.object.flag_dh_cxp 		[ll_row] = dw_2.object.flag_dh_cxp 		[ll_j]
						end if
						
					end if
				else
					ldw_impuestos.object.importe 				[ll_found] = ldc_impuesto
					ldw_impuestos.object.tasa_impuesto 		[ll_found] = dw_2.object.tasa_impuesto 	[ll_j]
					ldw_impuestos.object.desc_impuesto 		[ll_found] = dw_2.object.desc_impuesto 	[ll_j]
					ldw_impuestos.object.signo 				[ll_found] = dw_2.object.signo 				[ll_j]
					ldw_impuestos.object.cnta_ctbl 			[ll_found] = dw_2.object.cnta_ctbl 			[ll_j]
					ldw_impuestos.object.desc_cnta 			[ll_found] = dw_2.object.desc_cnta	 		[ll_j]
					ldw_impuestos.object.flag_replicacion	[ll_found] = '1'
					
					//Pongo el tipo de impuesto, si es nulo tomo el IGV
					ldw_impuestos.object.tipo_impuesto 		[ll_found] = ls_tipo_impuesto
	
					//Defino el flag deb/hab del impuesto
					if dw_2.object.flag_igv [ll_j] = '1' then
						ldw_impuestos.object.flag_dh_cxp 		[ll_found] = 'H'
					else
						ldw_impuestos.object.flag_dh_cxp 		[ll_found] = dw_2.object.flag_dh_cxp 		[ll_j]
					end if
	
				end if
			end if
		
		end if
		
		//Asigno total
		ldw_master.object.importe_doc	[1] = lw_1.Dynamic function of_totales ()
		ldw_master.ii_update = 1
		
	Next
	
	ist_datos.string1 = ls_orden_venta
	
	return 1

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al transferir, of_opcion1()')
	return 0
end try


end function

public function integer of_insert_articulos_a_cobrar (string as_cod_origen, string as_nro_guia, string as_orden_venta, double adb_tasa_cambio);String ls_mensaje

DECLARE USP_FIN_ADD_ARTICULOS_X_GUIA PROCEDURE FOR 
		USP_FIN_ADD_ARTICULOS_X_GUIA( :as_cod_origen,
												:as_nro_guia,
												:as_orden_venta,
												:adb_tasa_cambio);
												
EXECUTE USP_FIN_ADD_ARTICULOS_X_GUIA ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQlErrtext
	ROLLBACK;
	MessageBox('Store Procedure USP_FIN_ADD_ARTICULOS_X_GUIA , Comunicar en Area de Sistemas', ls_mensaje )
	RETURN 0
END IF


ids_art_a_vender.Retrieve()

return 1

end function

public function integer of_find_art (string as_orden_venta);Long   	ll_found,ll_inicio, ll_row
String 	ls_expresion,ls_soles,ls_dolares,ls_tipo_doc,ls_item
u_dw_abc ldw_master, ldw_detail
Window 	lw_1

ldw_master 	= ist_datos.dw_m
ldw_detail	= ist_datos.dw_d
lw_1			= ist_datos.lw_1

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
	IF ldw_detail.Rowcount () = w_ve310_cntas_cobrar.ii_lin_x_doc	THEN
		 Messagebox('Aviso','No Puede Exceder de '+Trim(String(w_ve310_cntas_cobrar.ii_lin_x_doc))+' Items x Documento')	
		 Return 0
	END IF
	
	 ls_expresion = "cod_art = '" + ids_art_a_vender.object.cod_art[ll_inicio] + "'"
	 ll_found = ldw_detail.Find(ls_expresion, 1, ldw_detail.RowCount())	 
    //w_ve310_cntas_cobrar.is_orden_venta = as_orden_venta
	 
	IF ll_found > 0 THEN
		ldw_detail.Object.cantidad [ll_found] = Dec(ldw_detail.Object.cantidad [ll_found]) + Dec(ids_art_a_vender.Object.cant_procesada [ll_inicio])
		ldw_detail.ii_update = 1
		ls_item = String(ldw_detail.Object.item  [ll_found])
		lw_1.Dynamic function of_generacion_imp (ls_item)
	ELSE
		ll_row = ldw_detail.event ue_insert( )
	
       IF ll_row > 0 THEN
			 /*Datos del Registro Modificado*/
			 w_ve310_cntas_cobrar.ib_estado_prea = TRUE
			 /**/
			 ldw_master.Object.moneda_det	   	[ldw_master.GetRow()] = ist_datos.string3
			 ldw_master.Object.tasa_cambio_det 	[ldw_master.GetRow()] = ist_datos.db1
			 ldw_master.Object.cod_relacion_det	[ldw_master.GetRow()] = ist_datos.string1

			 IF ist_datos.string3 = ls_soles THEN
             ldw_detail.Object.precio_unitario [ll_row] = ids_art_a_vender.Object.precio_unit_soles   [ll_inicio]				
				 ldw_detail.Object.precio_unit_exp [ll_row] = ids_art_a_vender.Object.precio_unit_soles   [ll_inicio]				
			 ELSE
             ldw_detail.Object.precio_unitario [ll_row] = ids_art_a_vender.Object.precio_unit_dolares [ll_inicio]				
				 ldw_detail.Object.precio_unit_exp [ll_row] = ids_art_a_vender.Object.precio_unit_dolares [ll_inicio]				
			 END IF	
			
 			 ldw_detail.Object.tipo_ref       [ll_row] = ls_tipo_doc
			 ldw_detail.Object.nro_ref        [ll_row] = as_orden_venta
			 ldw_detail.Object.cod_art        [ll_row] = ids_art_a_vender.Object.cod_art 		   [ll_inicio]
			 ldw_detail.Object.descripcion    [ll_row] = ids_art_a_vender.Object.nom_articulo   [ll_inicio]
			 ldw_detail.Object.cantidad       [ll_row] = ids_art_a_vender.Object.cant_procesada [ll_inicio]
			 ldw_detail.Object.descuento		 [ll_row] = ids_art_a_vender.Object.descuento		[ll_inicio]	
			 ldw_detail.Object.cant_proyect	 [ll_row] = ids_art_a_vender.Object.cant_proyect	[ll_inicio]
			 ldw_detail.Object.confin			 [ll_row] = ids_art_a_vender.Object.confin 			[ll_inicio]
			 ldw_detail.Object.matriz_cntbl	 [ll_row] = ids_art_a_vender.object.matriz_cntbl   [ll_inicio]
			 ldw_detail.Object.centro_benef	 [ll_row] = ids_art_a_vender.object.centro_benef   [ll_inicio]
			 
			 If Not IsNull(ids_art_a_vender.object.tipo_cred_fiscal [ll_inicio]) then
				ldw_detail.Object.tipo_cred_fiscal[ll_row] = ids_art_a_vender.object.tipo_cred_fiscal [ll_inicio]
			 end if
			 ldw_detail.Object.rubro			[ll_row] = ids_art_a_vender.object.rubro			   [ll_inicio]
			 ldw_detail.Object.flag				[ll_row] = 'G'
			 //Recalculo de Impuesto				 
			 ls_item = String(ldw_detail.Object.item  [ll_row])
			 lw_1.Dynamic function of_generacion_imp (ls_item)
          
			 
			 ldw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
		 END IF	
	 END IF
	 

NEXT

	
Return 1
end function

public function integer of_opcion2 ();Long ll_count

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	MessageBox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
end if

IF ll_count = 1 THEN
	ist_datos.dw_m.object.confin 		  [1] = dw_2.Object.confin		   [1]
	ist_datos.dw_m.object.descripcion  [1] = dw_2.Object.descripcion  [1]
	ist_datos.dw_m.object.matriz_cntbl [1] = dw_2.Object.matriz_cntbl [1]
END IF

return 1
end function

public function integer of_opcion3 ();Long ll_count, ll_row

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
END IF

IF ll_count = 1 THEN
	ll_row = ist_datos.dw_m.GetRow()
	IF ll_row = 0 THEN RETURN 0
	ist_datos.dw_m.object.confin 		  [ll_row] = dw_2.Object.confin		  [1]
	ist_datos.dw_m.object.matriz_cntbl [ll_row] = dw_2.Object.matriz_cntbl [1]
	ist_datos.titulo = 's'
END IF

return 1
end function

public function integer of_opcion4 ();Long ll_count, ll_row

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
ELSE
	IF ll_count = 1 THEN
		ll_row = ist_datos.dw_m.GetRow()
		IF ll_row = 0 THEN RETURN 0
		ist_datos.dw_m.object.confin 		 [ll_row] = dw_2.Object.confin		 [1]
		ist_datos.titulo = 's'
	END IF
END IF

return 1
end function

public function integer of_opcion5 ();Long ll_count, ll_row

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
ELSE
	IF ll_count = 1 THEN
		ll_row = ist_datos.dw_m.GetRow()
		IF ll_row = 0 THEN RETURN 0
		ist_datos.dw_m.object.confin 		 [ll_row] = dw_2.Object.confin		[1]
		ist_datos.dw_m.object.descripcion [ll_row] = dw_2.Object.descripcion [1]
		ist_datos.titulo = 's'
	END IF
END IF

return 1
end function

public function integer of_opcion8 ();Long ll_count, ll_row

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
ELSE

	IF ll_count = 1 THEN
		ll_row = ist_datos.dw_m.GetRow()
		IF ll_row = 0 THEN RETURN 0
		ist_datos.dw_m.object.confin2 		  [ll_row] = dw_2.Object.confin		  [1]
		ist_datos.titulo = 's'
	END IF
END IF		  
//UPDATE DW PADRE
ist_datos.field_ret_i[1] = 1

return 1
end function

public function integer of_opcion9 ();Long 		ll_count, ll_row_master, ll_found, ll_row, ll_j
Integer	li_nro_lineas
String 	ls_orden_venta, ls_origen, ls_expresion, &
			ls_vendedor, ls_nombre, ls_cod_art, ls_moneda, ls_moneda_cab, &
			ls_cfe, ls_cf, ls_mercado, ls_item, ls_tipo_doc, ls_confin, ls_matriz_cntbl, &
			ls_cred_fiscal

//Datos para tipo de impuestos
String	ls_cnta_Cntbl, ls_desc_impuesto, ls_signo, ls_flag_dh_cxp, ls_desc_cnta_cntbl, &
			ls_flag_igv
decimal	ldc_tasa_impuesto

decimal	ldc_tasa_cambio, ldc_impuesto1			
u_dw_abc	ldw_master, ldw_detail, ldw_referencias, ldw_impuestos
Window	lw_1

ldw_master 			= ist_datos.dw_m
ldw_detail 			= ist_datos.dw_d
ldw_referencias	= ist_datos.dw_c
lw_1					= ist_datos.w1
ldw_impuestos		= ist_datos.dw_imp

ll_row_master  	= dw_master.Getrow()
ls_orden_venta 	= dw_master.Object.nro_ov 			[ll_row_master]

//Datos de la cabecera del comprobante de venta
ls_moneda_cab		= ldw_master.Object.cod_moneda 		[1]
ldc_tasa_cambio 	= Dec(ldw_master.Object.tasa_cambio [1])
ls_tipo_doc			= ldw_master.object.tipo_doc			[1]
ls_origen			= ldw_master.object.origen				[1]

IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
	IF ls_orden_venta <> ist_datos.string2 THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Venta A Diferente a la ya Considerada', StopSign!)
		Return 0
	END IF
END IF

if dw_2.RowCount( ) = 0 then
	Messagebox('Aviso','Debe seleccionar al menos un item para transferir. Por favor verificar!', StopSign!)
	Return 0
end if

li_nro_lineas = gnvo_app.of_nro_lineas( ls_tipo_doc, ls_origen )

IF li_nro_lineas > 0 and ldw_detail.Rowcount () >= li_nro_lineas	THEN
	Messagebox('Aviso','No Puede Exceder de '+Trim(String(li_nro_lineas))+' Items x Documento', StopSign!)	
	Return 0
END IF

//Añado la referencia de la Orden de Venta al comprobante
ls_expresion = "origen_ref = '" + ls_origen + "' AND nro_ref = '" + ls_orden_venta + "'"
ll_found 	 = ldw_referencias.Find(ls_expresion, 1, ldw_referencias.RowCount())	 

IF ll_found = 0 THEN
	ll_row = ldw_referencias.event ue_insert()
	if ll_row > 0 then
		ldw_referencias.Object.tipo_mov	    [ll_row] = 'C'
		ldw_referencias.Object.origen_ref 	 [ll_row] = ls_origen
		ldw_referencias.Object.tipo_ref		 [ll_row] = gnvo_app.is_doc_ov
		ldw_referencias.Object.nro_ref		 [ll_row] = ls_orden_venta
		ldw_referencias.Object.flab_tabor	 [ll_row] = 'A' //Orden de VENTA
	end if
END IF

//Añado datos a la cabecera
ldw_master.object.vendedor			[1] = dw_2.object.vendedor			[1]
ldw_master.object.nom_vendedor	[1] = dw_2.object.nom_vendedor	[1]
ldw_master.object.forma_pago		[1] = dw_2.object.forma_pago		[1]
ldw_master.object.observacion		[1] = dw_2.object.obs				[1]


//Recorro los documentos 
for ll_j = 1 to dw_2.RowCount()

	ls_moneda 		= dw_2.object.cod_moneda 		[ll_j] 
	ls_mercado  	= dw_2.object.flag_mercado 	[ll_j] 
	ldc_impuesto1 	= Dec( dw_2.object.impuesto 	[ll_j] )
	
	if ISNull(ldc_impuesto1) then ldc_impuesto1 = 0
	
	ll_row = ldw_detail.event ue_insert()
	
	if ll_row > 0 then
		
		/*Datos del Registro Modificado*/
		w_ve310_cntas_cobrar.ib_estado_prea = TRUE
		
		IF ls_moneda = ls_moneda_cab THEN
			ldw_detail.Object.precio_unitario 	[ll_row] = dw_2.Object.precio_unit [ll_j]				
			ldw_detail.Object.precio_unit_exp 	[ll_row] = dw_2.Object.precio_unit [ll_j]				
		ELSEIF ls_moneda = gnvo_app.is_soles      THEN
			ldw_detail.Object.precio_unitario 	[ll_row] = Round(dw_2.Object.precio_unit [ll_j] / ldc_tasa_cambio,6)	
			ldw_detail.Object.precio_unit_exp 	[ll_row] = Round(dw_2.Object.precio_unit [ll_j] / ldc_tasa_cambio,6)	
		ELSEIF ls_moneda = gnvo_app.is_dolares    THEN
		 	ldw_detail.Object.precio_unitario 	[ll_row] = Round(dw_2.Object.precio_unit [ll_j] * ldc_tasa_cambio,6)					
			 ldw_detail.Object.precio_unit_exp 	[ll_row] = Round(dw_2.Object.precio_unit [ll_j] * ldc_tasa_cambio,6)					
		END IF
			 
		ldw_detail.Object.tipo_ref        [ll_row] = gnvo_app.is_doc_ov
		ldw_detail.Object.nro_ref         [ll_row] = ls_orden_venta
		ldw_detail.Object.cod_art         [ll_row] = dw_2.Object.cod_art 	 		[ll_j]
		ldw_detail.Object.descripcion     [ll_row] = dw_2.Object.desc_art   		[ll_j]
		ldw_detail.Object.und     			 [ll_row] = dw_2.Object.unidad   		[ll_j]
		ldw_detail.Object.cantidad        [ll_row] = dw_2.Object.cant_pendiente [ll_j]
		ldw_detail.Object.descuento		 [ll_row] = dw_2.Object.decuento		 	[ll_j]	
		ldw_detail.Object.cant_proyect	 [ll_row] = dw_2.Object.cant_pendiente [ll_j]
		ldw_detail.Object.org_amp_ref	 	 [ll_row] = dw_2.Object.org_amp 			[ll_j]
		ldw_detail.Object.nro_Amp_ref	 	 [ll_row] = dw_2.Object.nro_amp 			[ll_j]
		ldw_detail.Object.tipo_Doc_amp	 [ll_row] = dw_2.Object.tipo_doc_amp 	[ll_j]
		ldw_detail.Object.nro_doc_amp	 	 [ll_row] = dw_2.Object.nro_doc_amp 	[ll_j]
		ldw_detail.Object.cencos	 	 	 [ll_row] = dw_2.Object.cencos 			[ll_j]
		
		//Elijo el concepto financiero mas adecuado deacuerdo al tipo de mercado
		if ls_mercado = 'E' then
			ls_confin = dw_2.object.confin_export 	[ll_j] 
			
		else
			ls_confin = dw_2.object.confin 			[ll_j] 
			
		end if
		
		select matriz_cntbl
			into :ls_matriz_cntbl
		from concepto_financiero cf
		where cf.confin = :ls_confin;
		
		ldw_detail.Object.confin				[ll_row] = ls_confin
		ldw_detail.Object.matriz_cntbl	   [ll_row] = ls_matriz_cntbl
		
		ldw_detail.Object.rubro					[ll_row] = dw_2.object.rubro        	[ll_j]
		ldw_detail.Object.centro_benef		[ll_row] = dw_2.object.centro_benef   	[ll_j]
		
		//Añado el tipo de credito fiscal
		if ls_mercado = 'E' then
			ls_cred_fiscal = gnvo_app.finparam.is_cred_fiscal_exp
			
		else
			ls_confin = dw_2.object.confin 			[ll_j] 
			
			if ldc_impuesto1 > 0 then
				ldw_detail.Object.tipo_cred_fiscal		[ll_row] = gnvo_app.finparam.is_cred_fiscal_vng
			else
				ldw_detail.Object.tipo_cred_fiscal		[ll_row] = gnvo_app.finparam.is_cred_fiscal_vni
			end if
		end if
		
		ldw_detail.Object.tipo_cred_fiscal			[ll_row] = ls_cred_fiscal
		ldw_detail.Object.desc_tipo_cred_fiscal	[ll_row] = gnvo_app.finparam.of_desc_cred_fiscal(ls_Cred_fiscal)
			 
			 
		//Generación del impuesto IGV		 
		ls_item 		 = String(ldw_detail.object.nro_item[ll_row])
		
		ls_expresion = "item =" + ls_item
		
		if ldw_impuestos.RowCount () > 0 then
			ll_found = ldw_impuestos.find( ls_expresion, 1, ldw_impuestos.RowCount())
		else
			ll_found = 0
		end if

		
		if ldc_impuesto1 = 0 then
			if ll_found > 0 then
				ldw_impuestos.DeleteRow(ll_found)
				ldw_impuestos.ii_update = 1
			end if
		else
			
			//Obtengo los datos del impuesto
			select 	it.cnta_ctbl, cc.desc_cnta, desc_impuesto, tasa_impuesto, 
						signo, flag_dh_cxp, it.flag_igv
				into 	:ls_cnta_cntbl, :ls_desc_cnta_cntbl, :ls_desc_impuesto, :ldc_tasa_impuesto, 
						:ls_signo, :ls_flag_dh_cxp, :ls_flag_igv
			from 	impuestos_tipo it,
     				cntbl_cnta     cc
			where it.cnta_ctbl = cc.cnta_ctbl (+) 			
			  and trim(tipo_impuesto) = trim(:gnvo_app.finparam.is_igv);
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Error', 'No existen registros para el impuesto: ' + gnvo_app.finparam.is_igv + '. Por favor verifique!')
				return 0
			end if
			
			if ll_found = 0 then
				ll_row = ldw_impuestos.event ue_insert()
				if ll_row > 0 then
					ldw_impuestos.object.item 					[ll_row] = Long(ls_item)
					ldw_impuestos.object.importe 				[ll_row] = ldc_impuesto1
					ldw_impuestos.object.tasa_impuesto 		[ll_row] = ldc_tasa_impuesto
					ldw_impuestos.object.desc_impuesto 		[ll_row] = ls_desc_impuesto
					ldw_impuestos.object.cnta_ctbl 			[ll_row] = ls_cnta_Cntbl
					ldw_impuestos.object.desc_cnta 			[ll_row] = ls_desc_cnta_cntbl
					ldw_impuestos.object.flag_replicacion	[ll_row] = '1'
					ldw_impuestos.object.signo 				[ll_row] = ls_signo
					ldw_impuestos.object.tipo_impuesto 		[ll_row] = gnvo_app.finparam.is_igv
					
					
					// Especifico el flag deb/hab
					if ls_flag_igv = '1' then
						ldw_impuestos.object.flag_dh_cxp 		[ll_row] = 'H'
					else
						ldw_impuestos.object.flag_dh_cxp 		[ll_row] = ls_flag_dh_cxp
					end if
					
				end if
			else
				ldw_impuestos.object.importe 				[ll_found] = ldc_impuesto1
				ldw_impuestos.object.tasa_impuesto 		[ll_found] = ldc_tasa_impuesto
				ldw_impuestos.object.desc_impuesto 		[ll_found] = ls_desc_impuesto
				ldw_impuestos.object.signo 				[ll_found] = ls_signo
				ldw_impuestos.object.cnta_ctbl 			[ll_found] = ls_cnta_Cntbl
				ldw_impuestos.object.desc_cnta 			[ll_found] = ls_desc_cnta_cntbl
				ldw_impuestos.object.flag_replicacion	[ll_found] = '1'
				
				ldw_impuestos.object.tipo_impuesto 		[ll_found] = gnvo_app.finparam.is_igv

				//Defino el flag deb/hab del impuesto
				if ls_flag_igv = '1' then
					ldw_impuestos.object.flag_dh_cxp 		[ll_found] = 'H'
				else
					ldw_impuestos.object.flag_dh_cxp 		[ll_found] = ls_flag_dh_cxp
				end if

			end if
		end if
	
			 
		ldw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			 
	end if
next

//Asigno total
ldw_master.object.importe_doc [1] = lw_1.function dynamic of_totales ()

ldw_master.ii_update = 1
return 1
end function

public subroutine of_insert_art_ov (string as_orden_venta);Long   ll_fdw_d,j,ll_found
String ls_soles, ls_dolares ,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
		 ls_item , ls_rubro   ,ls_clase, ls_mercado, ls_cf, ls_cfe

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
	 IF ist_datos.dw_d.Rowcount () = w_ve310_cntas_cobrar.ii_lin_x_doc	THEN
		 Messagebox('Aviso','No Puede Exceder de '+Trim(String(w_ve310_cntas_cobrar.ii_lin_x_doc))+' Items x Documento')	
		 Return 
	 END IF
	 
	 ls_cod_art    = dw_2.object.cod_art    [j] 
	 ls_cod_moneda = dw_2.object.cod_moneda [j] 
	 
	 ls_expresion  = "cod_art = ''"+ls_cod_art+"'"
	 //ll_found      = ist_datos.dw_d.find(ls_expresion,1,ist_datos.dw_d.rowcount())
	 ll_found = 0
	 
	 IF ll_found > 0 THEN 
		 Messagebox('Aviso','Articulo Nº :'+ls_cod_art+' ya Ha sido tomado en Cuenta')
	 ELSE
 	    //w_ve310_cntas_cobrar.is_orden_venta = as_orden_venta      
	    IF ist_datos.dw_d.triggerevent ('ue_insert') > 0 THEN
          ll_fdw_d = w_ve310_cntas_cobrar.tab_1.tabpage_1.dw_detail.il_row
			 /*Datos del Registro Modificado*/
			 w_ve310_cntas_cobrar.ib_estado_prea = TRUE
		    /**/			 
			 
	 	    //w_ve310_cntas_cobrar.is_orden_venta = as_orden_venta      
			  
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
			 ist_datos.dw_d.Object.descripcion     [ll_fdw_d] = dw_2.Object.desc_art   [j]
			 IF gs_empresa = 'FISHOLG' THEN
				 ist_datos.dw_d.Object.und     		[ll_fdw_d] =  dw_2.Object.unidad   [j]
			END IF
			 ist_datos.dw_d.Object.cantidad        [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_d.Object.descuento		   [ll_fdw_d] = dw_2.Object.decuento		 [j]	
			 ist_datos.dw_d.Object.cant_proyect	   [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ist_datos.string3
			 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
			 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
			 
			  Select ov.flag_mercado, av.confin, av.confin_export 
				 into :ls_mercado, :ls_cf, :ls_cfe
				 from orden_venta ov,
					  articulo_mov_proy amp,
					 articulo_venta av
				 where ov.nro_ov = :as_orden_venta
					and amp.tipo_doc = 'OV'
					and ov.nro_ov = amp.nro_doc
					and av.cod_art = amp.cod_art
					and av.cod_art = :ls_cod_art;
					
			if ls_mercado = 'E' then
				ist_datos.dw_d.Object.confin				[ll_fdw_d] = ls_cfe
			else
				ist_datos.dw_d.Object.confin				[ll_fdw_d] = ls_cf
			end if
			 
			 
			 ist_datos.dw_d.Object.matriz_cntbl	   [ll_fdw_d] = dw_2.object.matriz_cntbl   [j]
			 ist_datos.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = dw_2.object.dl27400        [j]
			 ist_datos.dw_d.Object.rubro				[ll_fdw_d] = ls_rubro
			 
			 ist_datos.dw_d.Object.centro_benef		[ll_fdw_d] = dw_2.object.centro_benef   [j]
			 
			 
			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
			 w_ve310_cntas_cobrar.of_generacion_imp (ls_item)
			 
			 ist_datos.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			 
			 //Asigno total
			 w_ve310_cntas_cobrar.dw_master.object.importe_doc [w_ve310_cntas_cobrar.dw_master.getrow()] = w_ve310_cntas_cobrar.of_totales ()
			 w_ve310_cntas_cobrar.dw_master.ii_update = 1
			 
			 
			 
			 
			 

			 
		 END IF	
	 END IF	

NEXT


end subroutine

public function boolean of_opcion12 ();// Transfiere campos 
Long 		ll_i
string	ls_grupo_art

delete tt_exp_grupo_art;

for ll_i = 1 to dw_2.RowCount()
	ls_grupo_art = dw_2.object.grupo_art[ll_i]
	insert into tt_exp_grupo_art(grupo_art)
	values (:ls_grupo_art);
next

commit;
		
return true		

end function

public function long of_insert_guia_ref (string as_cod_origen, string as_nro_guia, u_dw_abc adw_referencias);String ls_expresion,ls_tipo_doc
Long   ll_found = 0,ll_row

ls_expresion = "origen_ref = '" + as_cod_origen + "' AND nro_ref = '" + as_nro_guia + "'"
ll_found = adw_referencias.Find(ls_expresion, 1, adw_referencias.RowCount())	 

IF ll_found = 0 THEN

	ll_row = adw_referencias.event ue_insert()
	if ll_row > 0 then
	
		/*Datos del Registro Modificado*/
		w_ve310_cntas_cobrar.ib_estado_prea = TRUE
	   /**/
		adw_referencias.Object.tipo_mov	    [ll_row] = 'C'
	   adw_referencias.Object.origen_ref 	 [ll_row] = as_cod_origen
	   adw_referencias.Object.tipo_ref		 [ll_row] = is_doc_gr
	   adw_referencias.Object.nro_ref		 [ll_row] = as_nro_guia
		adw_referencias.Object.flab_tabor	 [ll_row] = '9' //Guias de Remision

	END IF
END IF

Return ll_found



end function

public function integer of_get_param ();//***SELECCION DE TIPO DE DOC GUIA***//
SELECT doc_gr
  INTO :is_doc_gr
  FROM logparam
 WHERE reckey = '1' ;
//***********************************//

return 1
end function

public function boolean of_opcion10 ();/*
	Esta opción permite jalar el detalle del comprobante de pago para las notas de credito / debito por cobrar
*/
Long		ll_row, ll_item, ll_found, ll_ins_row, ll_inicio, ll_ins_row_Det
String	ls_tipo_doc, ls_nro_doc, ls_cod_art, ls_confin, ls_matriz, ls_descrip, ls_expresion, &
			ls_cod_moneda, ls_Doc_cab, ls_cod_moneda_det, ls_tipo_impuesto, ls_cnta_cntbl, &
			ls_desc_impuesto, ls_flag_dh, ls_signo, ls_desc_cnta, ls_tipo_cred_fiscal, &
			ls_desc_cred_fiscal, ls_und, ls_und2, ls_Cencos, ls_Centro_benef
Decimal 	ldc_tasa_cambio, ldc_precio_unit, ldc_tasa_imp, ldc_impuesto
u_dw_abc ldw_master, ldw_detail, ldw_impuestos

try 
	ldw_master 		= ist_datos.dw_m
	ldw_detail 		= ist_datos.dw_d
	ldw_impuestos	= ist_datos.dw_c
	
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
		ls_Cencos				= dw_2.object.cencos					[ll_row]		
		ls_Centro_benef		= dw_2.object.centro_benef			[ll_row]		
		
		ls_und					= dw_2.object.und						[ll_row]		
		ls_und2					= dw_2.object.und2					[ll_row]		
		
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
				ist_datos.titulo = 's'
		
				ldw_detail.Object.item 	        		[ll_ins_row] = ll_ins_row
				ldw_detail.Object.tipo_ref       	[ll_ins_row] = ls_tipo_doc
				ldw_detail.Object.nro_ref        	[ll_ins_row] = ls_nro_doc
				ldw_detail.Object.item_ref       	[ll_ins_row] = ll_item
				ldw_detail.Object.cod_art     		[ll_ins_row] = ls_cod_art
				ldw_detail.Object.descripcion 		[ll_ins_row] = ls_descrip
				ldw_detail.Object.precio_unitario	[ll_ins_row] = ldc_precio_unit
				ldw_detail.Object.confin		 		[ll_ins_row] = ls_confin
				ldw_detail.Object.matriz_cntbl 		[ll_ins_row] = ls_matriz
				ldw_detail.Object.tipo_cred_fiscal 	[ll_ins_row] = ls_tipo_cred_fiscal
				ldw_detail.Object.desc_cred_fiscal 	[ll_ins_row] = ls_desc_cred_fiscal
				ldw_detail.Object.cencos 				[ll_ins_row] = ls_Cencos
				ldw_detail.Object.centro_benef	 	[ll_ins_row] = ls_centro_benef
				ldw_detail.Object.und 					[ll_ins_row] = ls_und
				ldw_detail.Object.und2 					[ll_ins_row] = ls_und2
				ldw_detail.Object.cantidad    		[ll_ins_row] = dw_2.object.cantidad_und1 	[ll_row]
				ldw_detail.Object.cantidad_und2 		[ll_ins_row] = dw_2.object.cantidad_und2 	[ll_row]
				
				//ldw_detail.Object.nro_am				[ll_ins_row] = 1
				//dw_2.object.nro_am 						[ll_row]		 = 1
				
				if ldw_detail.of_existeCampo('org_am') and dw_2.of_existeCampo('org_am') then
					ldw_detail.Object.org_am				[ll_ins_row] = dw_2.object.org_am 			[ll_row]
				end if
				if Not IsNull(dw_2.object.nro_am [ll_row]) and Dec(dw_2.object.nro_am [ll_row]) > 0 then
					if ldw_detail.of_existeCampo('nro_am') and dw_2.of_existeCampo('nro_am') then
						ldw_detail.Object.nro_am				[ll_ins_row] = dw_2.object.nro_am 			[ll_row]
					end if
				end if
				if ldw_detail.of_existeCampo('org_amp_ref') and dw_2.of_existeCampo('org_amp_ref') then
					ldw_detail.Object.org_amp_ref   		[ll_ins_row] = dw_2.object.org_amp_ref 	[ll_row]
				end if
				if ldw_detail.of_existeCampo('nro_amp_ref') and dw_2.of_existeCampo('nro_amp_ref') then
					ldw_detail.Object.nro_amp_ref 		[ll_ins_row] = dw_2.object.nro_amp_ref 	[ll_row]
				end if
				if ldw_detail.of_existeCampo('tipo_doc_amp') and dw_2.of_existeCampo('tipo_doc_amp') then
					ldw_detail.Object.tipo_doc_amp		[ll_ins_row] = dw_2.object.tipo_doc_amp	[ll_row]
				end if
				if ldw_detail.of_existeCampo('nro_doc_amp') and dw_2.of_existeCampo('nro_doc_amp') then
					ldw_detail.Object.nro_doc_amp			[ll_ins_row] = dw_2.object.nro_doc_amp 	[ll_row]
				end if
				if ldw_detail.of_existeCampo('nro_vale') and dw_2.of_existeCampo('nro_vale')then
					ldw_detail.Object.nro_vale	   		[ll_ins_row] = dw_2.object.nro_vale 		[ll_row]
				end if
				
				/**/
				ldw_detail.Object.flag_rev	 			[ll_ins_row] = 'AJ'
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
			invo_wait.of_mensaje('Item de Referencia Nº '+ Trim(String(ll_item)) +' de Documento '+ ls_tipo_doc +' '+ls_nro_doc+' ya ha sido tomado en cuenta, por favor verifique ' )
		END IF
	Next
	
	
	RETURN TRUE


catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error en of_opcion10()')
finally
	invo_wait.of_close()
end try


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

invo_wait = create n_cst_Wait

// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

//**DataStore de Artciuclos Por Orden de Venta**//
ids_art_a_vender            = Create u_ds_base
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.Settransobject(sqlca)

//** Datastore Impuesto Cuentas x Cobrar Detalle x Item **//
ids_imp_x_cobrar = Create u_ds_base
ids_imp_x_cobrar.DataObject = 'd_impuestos_x_cobrar_tbl'
ids_imp_x_cobrar.SettransObject(sqlca)
//** **//

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
		CASE '1O'
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '11' //**Orden de Compra (Cuentas x Pagar)**/
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '12' //**Orden de Servicio (Cuentas x Pagar)**/
			ll_row = dw_master.Retrieve(ist_datos.string1)		
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo
is_col = dw_master.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

event open;//override
THIS.EVENT ue_open_pre()
of_get_param()
end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - 10
dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2
end event

event close;call super::close;destroy ids_imp_x_cobrar
destroy ids_art_a_vender
destroy invo_wait
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 888
integer width = 1362
integer height = 808
end type

event dw_1::constructor;call super::constructor;


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0
end event

event dw_1::doubleclicked;//Override

is_m_or_d = 'D'

IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
ELSE
	IF row = 0 THEN RETURN
	il_row = row                    // fila corriente
	THIS.SetRow(row)
	THIS.Event ue_output(row)
END IF

Integer li_pos, li_col, j
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

event dw_1::ue_selected_row_pro;Long	  ll_row, ll_rc, ll_count
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

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1573
integer y = 888
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
				ii_rk[13] = 13
				ii_rk[14] = 14
				
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
				ii_dk[13] = 13
				ii_dk[14] = 14
				
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
				
	   		ii_dk[1]  = 1			  //cod art
				ii_dk[2]  = 2			  //nom articulo
				ii_dk[3]  = 3			  //descuento	
				ii_dk[4]  = 4			  //impuesto
				ii_dk[5]  = 5			  //cod moneda
				ii_dk[6]  = 6			  //precio unit
				ii_dk[7]  = 7			  //cant_pendiente
				ii_dk[8]  = 8			  //cencos	
				ii_dk[9]  = 9			  //cnta prsp
				
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
integer y = 1120
integer taborder = 40
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1390
integer y = 1308
integer taborder = 50
end type

type st_campo from statictext within w_abc_seleccion_md
integer x = 23
integer y = 32
integer width = 713
integer height = 92
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
integer width = 2377
integer height = 92
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if is_m_or_d = 'M' then
	
	if keydown(keyuparrow!) then		// Anterior
		dw_master.scrollpriorRow()
	elseif keydown(keydownarrow!) then	// Siguiente
		dw_master.scrollnextrow()	
	end if
	
else
	
	if keydown(keyuparrow!) then		// Anterior
		dw_1.scrollpriorRow()
	elseif keydown(keydownarrow!) then	// Siguiente
		dw_1.scrollnextrow()	
	end if
	
end if

ll_row = dw_text.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
if is_m_or_d = 'M' then
	dw_master.triggerevent(doubleclicked!)
else
	dw_1.triggerevent(doubleclicked!)
end if
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
		
		if is_m_or_d = 'M' then //Maestro
			
			ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
			if ll_fila <> 0 then		// la busqueda resulto exitosa
				dw_master.selectrow(0, false)
				dw_master.selectrow(ll_fila,true)
				dw_master.scrolltorow(ll_fila)
			end if
			
		else
			
			ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
			if ll_fila <> 0 then		// la busqueda resulto exitosa
				dw_1.selectrow(0, false)
				dw_1.selectrow(ll_fila,true)
				dw_1.scrolltorow(ll_fila)
			end if
			
		end if
		
		
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion_md
integer x = 3159
integer y = 28
integer width = 338
integer height = 92
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

if dw_2.rowcount() = 0 then return

CHOOSE CASE ist_datos.opcion
	CASE 1 // Guias de Remision 
		if of_opcion1() = 0 then return
		ist_datos.Titulo = 's'
		
	CASE  2 // Conceptos Financieros
		if of_opcion2() = 0 then return
		ist_datos.Titulo = 's'

	CASE 3		//CASO PARTICULAR DE CONFIN
		if of_opcion3() = 0 then return
		ist_datos.Titulo = 's'	
						
	CASE 4
		if of_opcion4() = 0 then return
		ist_datos.Titulo = 's'		
		
	CASE 5
		if of_opcion5() = 0 then return
		ist_datos.Titulo = 's'
	
	CASE 8 		//CASO PARTICULAR DE CONFIN
		if of_opcion8() = 0 then return
		ist_datos.Titulo = 's'
		
	CASE	9  //Articulo Movimiento Proyectado
		if of_opcion9() = 0 then return
		ist_datos.Titulo = 's'
	
	CASE	10  //Articulo Movimiento Proyectado
		if not of_opcion10() then return
		ist_datos.Titulo = 's'

	CASE 12 // Ingreso x Compras 
		IF of_opcion12() then
			ist_datos.Titulo = 's'
		ELSE
			RETURN
		END IF
		
END CHOOSE

CloseWithReturn( parent, ist_datos)


end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 140
integer width = 2894
integer height = 728
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event clicked;call super::clicked;// Muestra detalle
IF dw_2.Rowcount() = 0 THEN
	
	IF row > 0 THEN
		CHOOSE CASE ist_datos.opcion 
			CASE 1,9 				// Guias de remisión, Articulo Mov Proy
				dw_1.Retrieve(this.object.nro_ov[row])
			
			CASE 10 				// Notas de Credito / Debito x Detalle
				dw_1.Retrieve(this.object.tipo_doc[row], this.object.nro_doc[row])
				
			CASE 2,4,5,8 
				dw_1.Retrieve(this.object.grupo[row])
				
			CASE 3
				dw_1.Retrieve(this.object.grupo[row], ist_datos.str_array)
				
			CASE 12  // Reportes de Articulos * Grupo
				dw_1.Retrieve(This.Object.spr_grp_art[row])
					
		END CHOOSE
	END IF
ELSE
	Messagebox( "Error", "no puede seleccionar otro documento", Exclamation!)
END IF



end event

event doubleclicked;//Override
is_m_or_d = 'M' //master

IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
ELSE
	IF row = 0 THEN RETURN
	il_row = row                    // fila corriente
	THIS.SetRow(row)
	THIS.Event ue_output(row)
END IF

Integer li_pos, li_col, j
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

