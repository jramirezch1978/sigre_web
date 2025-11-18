$PBExportHeader$w_rpt_preview.srw
forward
global type w_rpt_preview from w_report_smpl
end type
end forward

global type w_rpt_preview from w_report_smpl
integer width = 2807
integer height = 1908
string title = ""
string menuname = "m_impresion"
boolean toolbarvisible = false
end type
global w_rpt_preview w_rpt_preview

type variables
n_cst_codeqr		invo_codeqr
boolean				ib_salir = false
end variables

forward prototypes
public subroutine of_modify_dw (datawindow adw_data, string as_inifile)
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
public function boolean of_opcion3 ()
public function boolean of_opcion4 ()
public function boolean of_opcion5 ()
public function boolean of_opcion6 ()
public function boolean of_opcion7 ()
public function boolean of_opcion8 ()
public function boolean of_opcion9 ()
public function boolean of_opcion10 ()
public function boolean of_opcion11 ()
end prototypes

public subroutine of_modify_dw (datawindow adw_data, string as_inifile);string 	ls_modify, ls_error
Long		ll_num_act, ll_i

if not FileExists(as_inifile) then return

ll_num_act = Long(ProfileString(as_inifile, "Total_lineas", 'Total', "0"))

for ll_i = 1 to ll_num_act
	ls_modify = ProfileString(as_inifile, "Modify", 'Linea' + string(ll_i), "")
	if ls_modify <> "" then
		ls_error = adw_data.Modify(ls_modify)
		if ls_error <> '' then
			MessageBox('Error en Modify datastore', ls_Error + ' ls_modify: ' + ls_modify)
		end if
	end if
next

end subroutine

public function boolean of_opcion1 ();u_dw_abc 	ldw_detail, ldw_master
Long			ll_row, ll_i, ll_cantidad, ll_row_new
String		ls_cod_Art, ls_desc_art, ls_code_bar, ls_cod_sku, ls_flag_print_precio, ls_moneda, &
				ls_sub_cat_art, ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, &
				ls_cod_acabado, ls_color1, ls_color2

String		ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
				ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
				ls_linea1, ls_linea2, ls_mensaje

Decimal		ldc_precio_vta_unidad, ldc_talla, ldc_nro_copias
Date			ld_fec_ingreso


try 
	
	ldw_detail = istr_rep.dw_d
	ldw_master = istr_rep.dw_m
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CODIGO_BARRAS", 3.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select a.desc_art, 
				 '*' || a.cod_sku || '*' as code_bar, 
				 a.cod_sku,
				 zl.flag_print_precio, 
				 PKG_LOGISTICA.of_soles(null) as moneda,
				 a.precio_vta_unidad,
				 (select max(vm.fec_registro)
					 from vale_mov vm,
							articulo_mov am
					where vm.nro_Vale = am.nro_vale
					  and am.origen_mov_proy = amp.cod_origen
				  and am.nro_mov_proy    = amp.nro_mov
				  and vm.flag_estado <> '0'
				  and am.flag_estado <> '0'
				  and vm.tipo_mov    like 'I%') as fec_ingreso
		from articulo a,
			  zc_linea zl,
			  zc_sub_linea zs,
			  articulo_mov_proy amp,
			  (select 1 from dual
				union
				select 2 from dual
				union
				select 3 from dual) s
		where amp.cod_art     = a.cod_art
		  and a.cod_sub_linea = zs.cod_sub_linea (+)
		  and zs.cod_linea    = zl.cod_linea     (+)
		  and amp.nro_doc     = :as_nro_doc
		  and amp.tipo_doc    = (select doc_oc from logparam where reckey = '1')
		order by a.sub_cat_art, a.cod_marca, a.cod_sub_linea, a.estilo, a.cod_suela, a.cod_acabado, a.color1, a.talla
	  */
	
	//Obtengo le fecha de ingreso
	ld_fec_ingreso = Date(ldw_master.object.fec_registro [1])
	
	for ll_row = 1 to ldw_detail.Rowcount()
		ls_cod_art 	= ldw_detail.object.cod_Art							[ll_row]
		ls_Desc_art = ldw_detail.object.desc_art							[ll_row]
		
		//Obtengo los datos que necesito
		select  '*' || a.cod_sku || '*' as code_bar, 
				  a.cod_sku,
				  zl.flag_print_precio, 
				  PKG_LOGISTICA.of_soles(null) as moneda,
				  a.precio_vta_unidad,
				  a.sub_cat_art, 
				  a.cod_marca, 
				  a.cod_sub_linea, 
				  a.estilo, 
				  a.cod_suela, 
				  a.cod_acabado, 
				  a.color1, 
				  a.color2,
				  a.talla,
				  m.nom_marca,
				  a1.abreviatura,
				  zl.abreviatura,
				  zs.desc_sub_linea,
				  za.desc_acabado,
				  c1.descripcion,
				  c2.descripcion,
				  zsu.desc_suela,
				  zt.desc_taco
		into 	:ls_code_bar,
				:ls_cod_sku,
				:ls_flag_print_precio,
				:ls_moneda,
				:ldc_precio_vta_unidad,
				:ls_sub_cat_art,
				:ls_cod_marca,
				:ls_cod_sub_linea,
				:ls_estilo,
				:ls_cod_suela,
				:ls_cod_acabado,
				:ls_color1,
				:ls_color2,
				:ldc_talla,
				:ls_nom_marca,
				:ls_abrev_categoria,
				:ls_abrev_linea,
				:ls_desc_sub_linea,
				:ls_desc_acabado,
				:ls_color_primario, 
				:ls_color_secundario,
				:ls_desc_suela,
				:ls_desc_taco
		from articulo a,
			 articulo_sub_categ a2,
			 articulo_categ     a1,
			 zc_linea           zl,
			 zc_sub_linea       zs,
			 marca              m,
			 zc_acabado         za,
			 color              c1,
			 color              c2,
			 zc_suela           zsu,
			 zc_taco            zt
		where a.cod_sub_linea = zs.cod_sub_linea 	(+)
		 and zs.cod_linea    = zl.cod_linea     	(+)
		 and a.cod_marca     = m.cod_marca      	(+)
		 and a.sub_cat_art   = a2.cod_sub_cat   	(+)
		 and a2.cat_art      = a1.cat_art       	(+)
		 and a.cod_acabado   = za.cod_acabado   	(+)
		 and a.color1        = c1.color         	(+)
		 and a.color2        = c2.color         	(+)
		 and a.cod_suela     = zsu.cod_suela    	(+)
		 and a.cod_taco      = zt.cod_taco      	(+)
		 and a.cod_art		 	= :ls_cod_art;
		
		if SQLCA.SQLCOde < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
			return false
		end if
		
		//Multiplico segun la cantidad indicada
		ll_cantidad = round(Dec(ldw_detail.object.cant_procesada	[ll_row]), 0) * round(ldc_nro_copias, 0)
		
		for ll_i = 1 to ll_cantidad
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				
				//Armo las dos lineas necesarias
				ls_linea1 = ''
				if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
					ls_linea1 += trim(ls_nom_marca)
				end if
				
				if not IsNull(ls_abrev_categoria) and trim(ls_abrev_categoria) <> '' then
					ls_linea1 += ' ' + trim(ls_abrev_categoria)
				end if
				
				if not IsNull(ls_abrev_linea) and trim(ls_abrev_linea) <> '' then
					ls_linea1 += trim(ls_abrev_linea)
				end if
				
				if not IsNull(ls_desc_sub_linea) and trim(ls_desc_sub_linea) <> '' then
					ls_linea1 += ' ' + trim(ls_desc_sub_linea)
				end if
				
				if not IsNull(ls_estilo) and trim(ls_estilo) <> '' then
					ls_linea1 += ' ' + trim(ls_estilo)
				end if
				
				//Armo las segunda linea
				ls_linea2 = ''
				if not IsNull(ls_desc_acabado) and trim(ls_desc_acabado) <> '' then
					ls_linea2 += trim(ls_desc_acabado)
				end if
	
				if not IsNull(ls_color_primario) and trim(ls_color_primario) <> '' then
					ls_linea2 += ' ' + trim(ls_color_primario)
				end if
				
				if not IsNull(ls_color_secundario) and trim(ls_color_secundario) <> '' then
					ls_linea2 += ' ' + trim(ls_color_secundario)
				end if
				
				if not IsNull(ls_desc_suela) and trim(ls_desc_suela) <> '' then
					ls_linea2 += ' ' + trim(ls_desc_suela)
				end if
				
				if not IsNull(ls_desc_taco) and trim(ls_desc_taco) <> '' then
					ls_linea2 += ' ' + trim(ls_desc_taco)
				end if
				
				
				dw_report.object.linea1 				[ll_row_new] = ls_linea1
				dw_report.object.linea2 				[ll_row_new] = ls_linea2
				dw_report.object.code_bar 				[ll_row_new] = ls_code_bar
				dw_report.object.cod_sku 				[ll_row_new] = ls_cod_sku
				dw_report.object.flag_print_precio 	[ll_row_new] = ls_flag_print_precio
				
				if ls_flag_print_precio = '1' then
					dw_report.object.moneda 				[ll_row_new] = ls_moneda
					dw_report.object.precio_vta_unidad 	[ll_row_new] = ldc_precio_vta_unidad
				else
					dw_report.object.moneda 				[ll_row_new] = gnvo_app.is_null
					dw_report.object.precio_vta_unidad 	[ll_row_new] = gnvo_app.idc_null
				end if
				dw_report.object.sub_Cat_art 			[ll_row_new] = ls_sub_cat_art
				dw_report.object.cod_marca 			[ll_row_new] = ls_cod_marca
				dw_report.object.cod_sub_linea 		[ll_row_new] = ls_cod_sub_linea
				dw_report.object.estilo 				[ll_row_new] = ls_estilo
				dw_report.object.cod_suela 			[ll_row_new] = ls_cod_suela
				dw_report.object.cod_acabado 			[ll_row_new] = ls_cod_acabado
				dw_report.object.color1 				[ll_row_new] = ls_color1
				dw_report.object.color2 				[ll_row_new] = ls_color2
				dw_report.object.fec_ingreso		[ll_row_new] = ld_fec_ingreso
				dw_report.object.cod_taco			[ll_row_new] = ls_desc_taco
				dw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)
				
				
				if not isnull(ldc_talla) and ldc_talla <> 0 then
					dw_report.object.talla 					[ll_row_new] = ldc_talla
				end if
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
end try


end function

public function boolean of_opcion2 ();u_dw_abc 		ldw_master
Long				ll_row, ll_nro_caja, ll_i, ll_row_new
decimal			ldc_nro_copias
String			ls_codigo_cu, ls_nro_trazabilidad, ls_nom_cliente_final, &
					ls_nro_contenedor, ls_der, ls_nro_parte, ls_code_qr, ls_cod_art, ls_desc_art, &
					ls_nro_max, ls_nro_min
Date				ld_fec_produccion, ld_fec_cavalier
u_ds_base		lds_base


try 
	ldw_master = istr_rep.dw_m
	ls_nro_parte = istr_rep.string1
	
	//Obtengo el rango de codigos CU
	select min(teu.codigo_cu), max(teu.codigo_cu)
		into :ls_nro_min, :ls_nro_max
	from tg_parte_empaque_und teu,
		  tg_parte_empaque     te,
		  articulo             a,
		  proveedor            p
	where te.nro_parte 		= teu.nro_parte
	  and te.cod_art_pptt 	= a.cod_art
	  and te.cliente_final  = p.proveedor (+)
	  and te.nro_parte		= :ls_nro_parte;
	
	if SQLCA.SQLCode = 100 then
		gnvo_app.of_message_error("No se han creado códigos CU para este nro de parte " + istr_rep.string1)
		return false
	end if
	
	if not gnvo_app.of_get_rango( ls_nro_min, ls_nro_max) then
		return false
	end if

	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1, ls_nro_min, ls_nro_max)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos de caja CU para el parte " + istr_rep.string1)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CU_PPTT", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select teu.codigo_cu,
				 a.cod_art,
				 a.desc_art,
				 a.und,
				 te.nro_trazabilidad,
				 te.fec_produccion,
				 teu.nro_caja,
				 te.fec_cavalier,
				 p.nom_proveedor as nom_cliente_final,
				 te.nro_contenedor_mp,
				 te.der,
				 te.nro_parte
		from tg_parte_empaque_und teu,
			  tg_parte_empaque     te,
			  articulo             a,
			  proveedor            p
		where te.nro_parte = teu.nro_parte
		  and te.cod_art_pptt = a.cod_art
		  and te.cliente_final  = p.proveedor (+)
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_codigo_cu 			= lds_base.object.codigo_cu 				[ll_row]
		ls_cod_art				= lds_base.object.cod_Art	 				[ll_row]
		ls_desc_art				= lds_base.object.desc_art	 				[ll_row]
		ls_nro_trazabilidad 	= lds_base.object.nro_trazabilidad 		[ll_row]
		ls_nom_cliente_final	= lds_base.object.nom_cliente_final		[ll_row]
		ls_nro_contenedor		= lds_base.object.nro_contenedor_mp		[ll_row]
		ls_der					= lds_base.object.der				 		[ll_row]
		ls_nro_parte			= lds_base.object.nro_parte		 		[ll_row]
		ld_fec_produccion		= Date(lds_base.object.fec_produccion	[ll_row])
		ld_fec_cavalier		= Date(lds_base.object.fec_cavalier		[ll_row])
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				
				//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_codigo_cu) and trim(ls_codigo_cu) <> '' then
					ls_code_qr += trim(ls_codigo_cu) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_cod_art) and trim(ls_cod_art) <> '' then
					ls_code_qr += trim(ls_cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_trazabilidad) and trim(ls_nro_trazabilidad) <> '' then
					ls_code_qr += trim(ls_nro_trazabilidad) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_contenedor) and trim(ls_nro_contenedor) <> '' then
					ls_code_qr += trim(ls_nro_contenedor) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_parte) and trim(ls_nro_parte) <> '' then
					ls_code_qr += trim(ls_nro_parte) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if upper(gs_empresa) <> 'SEAFROST' then
					if not IsNull(ld_fec_produccion)  then
						ls_code_qr += string(ld_fec_produccion, 'dd/mm/yyyy') + '|'
					else
						ls_code_qr += '|'
					end if
				else
					ls_code_qr += '|'
				end if
				
				if upper(gs_empresa) <> 'SEAFROST' then
					if not IsNull(ld_fec_cavalier)  then
						ls_code_qr += string(ld_fec_cavalier, 'dd/mm/yyyy') + '|'
					else
						ls_code_qr += '|'
					end if
				else
					ls_code_qr += '|'
				end if
				
				
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, ls_codigo_cu )
				dw_report.object.codigo_cu			[ll_row_new] = ls_codigo_cu
				dw_report.object.desc_art			[ll_row_new] = ls_desc_art
				dw_report.object.nro_trazabilidad[ll_row_new] = ls_nro_trazabilidad
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion3 ();u_dw_abc 	ldw_master
Long			ll_row, ll_nro_caja, ll_i, ll_row_new
decimal		ldc_nro_copias, ldc_cant_producida, ldc_total_caja
String		ls_nro_pallet, ls_desc_art, ls_descripcion_articulo, ls_Cod_art, ls_nro_parte, &
				ls_code_qr, ls_und, ls_und2, ls_nro_trazabilidad
Date			ld_fec_empaque, ld_fec_produccion
u_ds_base	lds_base



try 
	ldw_master = istr_rep.dw_m
	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos registros para el parte " + istr_rep.string1)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_PALLET_PPTT", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select a.cod_art,
				 a.desc_art,
				 tpe.nro_pallet,
				 tpe.fec_empaque,
				 tpe.fec_produccion,
				 tpe.nro_parte
		from tg_parte_empaque tpe,
			  articulo         a
		where tpe.cod_art_pptt = a.cod_art     
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_Cod_art	 			= lds_base.object.cod_art 					[ll_row]
		ls_desc_art	 			= lds_base.object.desc_art 				[ll_row]
		ls_nro_pallet 			= lds_base.object.nro_pallet 				[ll_row]
		ls_und		 			= lds_base.object.und		 				[ll_row]
		ls_und2					= lds_base.object.und2				 		[ll_row]
		
		ld_fec_produccion		= Date(lds_base.object.fec_produccion	[ll_row])
		ld_fec_empaque			= Date(lds_base.object.fec_empaque		[ll_row])
		
		ldc_cant_producida	= Dec(lds_base.object.cant_producida	[ll_row])
		ldc_total_caja			= Dec(lds_base.object.total_caja			[ll_row])
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				
				//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_Cod_art) and trim(ls_Cod_art) <> '' then
					ls_code_qr += trim(ls_Cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_pallet) and trim(ls_nro_pallet) <> '' then
					ls_code_qr += trim(ls_nro_pallet) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_produccion)  then
					ls_code_qr += string(ld_fec_produccion, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_empaque)  then
					ls_code_qr += string(ld_fec_empaque, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, 'PALLET_' + ls_nro_pallet )
				dw_report.object.nro_pallet		[ll_row_new] = ls_nro_pallet
				dw_report.object.desc_art			[ll_row_new] = '[' + ls_cod_art + ']' + ' ' + ls_desc_art
				dw_report.object.fec_empaque		[ll_row_new] = ld_fec_empaque
				
				dw_report.object.titulo1			[ll_row_new] = string(ldc_cant_producida, '###,##0.00') &
																			 + ' ' + ls_und &
																			 + ' - ' &
																			 + string(ldc_total_caja, '###,##0.00') &
																			 + ' ' + ls_und2
				
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion4 ();u_dw_abc 	ldw_master
decimal		ldc_nro_copias
Long			ll_row, ll_row_new, ll_i
String		ls_nro_parte, ls_almacen_dst, ls_desc_almacen, ls_anaquel, ls_fila, ls_columna, ls_cod_art, &
				ls_desc_art, ls_desc_almacen_dst, ls_code_qr, ls_descripcion, ls_nro_pallet
Date			ld_fec_recepcion
u_ds_base	lds_base



try 
	ldw_master = istr_rep.dw_m
	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos registros para el parte " + istr_rep.string1)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_RECEPCION", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select a.cod_art,
				 a.desc_art,
				 tpr.nro_parte,
				 tpr.fec_recepcion,
				 tpr.almacen_dst,
				 al.desc_almacen,
				 tpr.anaquel,
				 tpr.fila,
				 tpr.columna,
					'C:\SIGRE\resources\PNG\qr_example.png' as codigo_qr
		from tg_parte_recepcion tpr,
			  articulo         a,
			  almacen          al
		where tpr.cod_art = a.cod_art
		  and tpr.almacen_dst = al.almacen    
		  --and tpe.nro_parte    = :as_nro_parte    
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_Cod_art	 			= lds_base.object.cod_art 					[ll_row]
		ls_desc_art	 			= lds_base.object.desc_art 				[ll_row]
		ls_nro_parte 			= lds_base.object.nro_parte 				[ll_row]
		ls_almacen_dst			= lds_base.object.almacen_dst		 		[ll_row]
		ls_desc_almacen_dst	= lds_base.object.desc_almacen_dst	 	[ll_row]
		ls_anaquel				= lds_base.object.anaquel		 			[ll_row]
		ls_fila					= lds_base.object.fila		 				[ll_row]
		ls_columna				= lds_base.object.columna				 	[ll_row]
		ls_nro_pallet			= lds_base.object.nro_pallet			 	[ll_row]
		ld_fec_recepcion		= Date(lds_base.object.fec_recepcion	[ll_row])
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then

				//Armo las dos lineas necesarias
				ls_code_qr = ''
				
				
				if not IsNull(ls_Cod_art) and trim(ls_Cod_art) <> '' then
					ls_code_qr += trim(ls_Cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_parte) and trim(ls_nro_parte) <> '' then
					ls_code_qr += trim(ls_nro_parte) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_almacen_dst) and trim(ls_almacen_dst) <> '' then
					ls_code_qr += trim(ls_almacen_dst) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_anaquel) and trim(ls_anaquel) <> '' then
					ls_code_qr += trim(ls_anaquel) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_fila) and trim(ls_fila) <> '' then
					ls_code_qr += trim(ls_fila) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_columna) and trim(ls_columna) <> '' then
					ls_code_qr += trim(ls_columna) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_recepcion)  then
					ls_code_qr += string(ld_fec_recepcion, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				//Genero la descripcion
				ls_descripcion = ''
				//Primero la posicion
				if not IsNull(ls_anaquel) and trim(ls_anaquel) <> '' then
					ls_descripcion += trim(ls_anaquel)
				end if
				
				if not IsNull(ls_fila) and trim(ls_fila) <> '' then
					ls_descripcion += '-' + trim(ls_fila)
				end if
				
				if not IsNull(ls_columna) and trim(ls_columna) <> '' then
					ls_descripcion += '-' + trim(ls_fila)
				end if
				
				if not IsNull(ls_almacen_dst)  then
					ls_descripcion += '-' + trim(ls_almacen_dst)
				end if
				
				if not IsNull(ls_desc_art)  then
					ls_descripcion += '-' + trim(ls_desc_art)
				end if
				
				if not IsNull(ls_nro_pallet)  then
					ls_descripcion += '-' + trim(ls_nro_pallet)
				end if
				
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, 'RECEPCION_' + ls_nro_parte )
				dw_report.object.desc_almacen_dst[ll_row_new] = ls_descripcion

				
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion5 ();u_dw_abc 	ldw_master
decimal		ldc_nro_copias, ldc_nro_cajas, ldc_cantidad
Long			ll_row, ll_row_new, ll_i
String		ls_nro_parte, ls_almacen_dst, ls_desc_almacen, ls_anaquel, ls_fila, ls_columna, ls_cod_art, &
				ls_desc_art, ls_desc_almacen_dst, ls_code_qr, ls_descripcion, ls_nro_pallet, ls_und, ls_und2
Date			ld_fec_recepcion
u_ds_base	lds_base



try 
	ldw_master = istr_rep.dw_m
	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos registros para el parte " + istr_rep.string1)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_RECEPCION", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select a.cod_art,
				 a.desc_art, a.und, a.und2,
				 tf.nro_parte,
				 tf.fec_transferencia as fec_recepcion,
				 tf.almacen_dst,
				 al.desc_almacen,
				 tf.anaquel_dst as anaquel,
				 tf.fila_dst as fila,
				 tf.columna_dst as columna,
				 te.nro_pallet as nro_pallet,
				 'C:\SIGRE\resources\PNG\qr_example.png' as codigo_qr,
				 sum(te.cant_producida / te.total_caja) as cantidad,
				 count(tfu.codigo_cu) as nro_Cajas
		from tg_parte_transferencia tf,
			  tg_parte_transferencia_und tfu,
			  tg_parte_empaque           te,
			  tg_parte_empaque_und       teu,
			  articulo         a,
			  almacen          al
		where tf.nro_parte    = tfu.nro_parte
		  and te.nro_parte    = teu.nro_parte
		  and teu.codigo_cu   = tfu.codigo_cu
		  and te.cod_art_pptt = a.cod_art
		  and tf.almacen_dst  = al.almacen      
		  and tf.nro_parte    = 'P10000015E'
		group by a.cod_art,
				 a.desc_art, a.und, a.und2,
				 tf.nro_parte,
				 tf.fec_transferencia,
				 tf.almacen_dst,
				 al.desc_almacen,
				 tf.anaquel_dst,
				 tf.fila_dst,
				 tf.columna_dst,
       te.nro_pallet
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_Cod_art	 			= lds_base.object.cod_art 					[ll_row]
		ls_desc_art	 			= lds_base.object.desc_art 				[ll_row]
		ls_nro_parte 			= lds_base.object.nro_parte 				[ll_row]
		ls_almacen_dst			= lds_base.object.almacen_dst		 		[ll_row]
		ls_desc_almacen_dst	= lds_base.object.desc_almacen_dst	 	[ll_row]
		ls_anaquel				= lds_base.object.anaquel		 			[ll_row]
		ls_fila					= lds_base.object.fila		 				[ll_row]
		ls_columna				= lds_base.object.columna				 	[ll_row]
		ls_nro_pallet			= lds_base.object.nro_pallet			 	[ll_row]
		ld_fec_recepcion		= Date(lds_base.object.fec_recepcion	[ll_row])
		ldc_cantidad			= Dec(lds_base.object.cantidad		 	[ll_row])
		ldc_nro_Cajas			= Dec(lds_base.object.nro_cajas		 	[ll_row])
		ls_und					= lds_base.object.und					 	[ll_row]
		ls_und2					= lds_base.object.und2					 	[ll_row]
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then

				//Armo las dos lineas necesarias
				ls_code_qr = ''
				
				
				if not IsNull(ls_Cod_art) and trim(ls_Cod_art) <> '' then
					ls_code_qr += trim(ls_Cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_parte) and trim(ls_nro_parte) <> '' then
					ls_code_qr += trim(ls_nro_parte) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_almacen_dst) and trim(ls_almacen_dst) <> '' then
					ls_code_qr += trim(ls_almacen_dst) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_anaquel) and trim(ls_anaquel) <> '' then
					ls_code_qr += trim(ls_anaquel) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_fila) and trim(ls_fila) <> '' then
					ls_code_qr += trim(ls_fila) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_columna) and trim(ls_columna) <> '' then
					ls_code_qr += trim(ls_columna) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_recepcion)  then
					ls_code_qr += string(ld_fec_recepcion, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ldc_cantidad)  then
					ls_code_qr += string(ldc_cantidad, '###,##0.0000') + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ldc_nro_Cajas)  then
					ls_code_qr += string(ldc_nro_Cajas, '###,##0.0000') + '|'
				else
					ls_code_qr += '|'
				end if
				
				//Genero la descripcion
				ls_descripcion = ''
				
				//Primero la posicion
				if not IsNull(ls_anaquel) and trim(ls_anaquel) <> '' then
					ls_descripcion += trim(ls_anaquel)
				end if
				
				if not IsNull(ls_fila) and trim(ls_fila) <> '' then
					ls_descripcion += '-' + trim(ls_fila)
				end if
				
				if not IsNull(ls_columna) and trim(ls_columna) <> '' then
					ls_descripcion += '-' + trim(ls_columna)
				end if
				
				dw_report.object.posicion [ll_row_new] = ls_descripcion
				
				//Ahora el almacen destino
				dw_report.object.desc_almacen_dst [ll_row_new] = ls_desc_almacen_dst
				
				//Ahora la descripcion del articulo
				dw_report.object.desc_art [ll_row_new] = trim(ls_desc_art)
				
				dw_report.object.nro_pallet [ll_row_new] = ls_nro_pallet
				
				//Ahora la cantidad y nro cajas
				dw_report.object.titulo1 [ll_row_new] = string(ldc_cantidad, '###,##0.0000') + ' ' + ls_und + ' - ' + string(ldc_nro_cajas, '###,##0.0000') + ' ' + ls_und2
				
				
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, 'RECEPCION_' + ls_nro_parte )
				

				
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion6 ();u_dw_abc 	ldw_master
Long			ll_row, ll_nro_caja, ll_i, ll_row_new
decimal		ldc_nro_copias, ldc_cant_producida, ldc_total_caja
String		ls_nro_pallet, ls_desc_art, ls_descripcion_articulo, ls_Cod_art, ls_nro_parte, &
				ls_code_qr, ls_und, ls_und2, ls_nro_trazabilidad
Date			ld_fec_empaque, ld_fec_produccion
u_ds_base	lds_base



try 
	ldw_master = istr_rep.dw_m
	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos registros para los datos seleccionados " &
										+ "~r~nPallet Destino: " + istr_rep.string1 &
										+ "~r~Almacen Destino: " + istr_rep.string2 &
										+ "~r~Vale de Ingreso: " + istr_rep.string3)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_PALLET_PPTT", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select a.cod_art,
				 a.desc_art,
				 tpe.nro_pallet,
				 tpe.fec_empaque,
				 tpe.fec_produccion,
				 tpe.nro_parte
		from tg_parte_empaque tpe,
			  articulo         a
		where tpe.cod_art_pptt = a.cod_art     
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_Cod_art	 			= lds_base.object.cod_art 					[ll_row]
		ls_desc_art	 			= lds_base.object.desc_art 				[ll_row]
		ls_nro_pallet 			= lds_base.object.nro_pallet 				[ll_row]
		ls_und		 			= lds_base.object.und		 				[ll_row]
		ls_und2					= lds_base.object.und2				 		[ll_row]
		
		ld_fec_produccion		= Date(lds_base.object.fec_produccion	[ll_row])
		ld_fec_empaque			= Date(lds_base.object.fec_empaque		[ll_row])
		
		ldc_cant_producida	= Dec(lds_base.object.cant_producida	[ll_row])
		ldc_total_caja			= Dec(lds_base.object.total_caja			[ll_row])
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				
				//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_Cod_art) and trim(ls_Cod_art) <> '' then
					ls_code_qr += trim(ls_Cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_pallet) and trim(ls_nro_pallet) <> '' then
					ls_code_qr += trim(ls_nro_pallet) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_produccion)  then
					ls_code_qr += string(ld_fec_produccion, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_empaque)  then
					ls_code_qr += string(ld_fec_empaque, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, 'PALLET_' + ls_nro_pallet )
				dw_report.object.nro_pallet		[ll_row_new] = ls_nro_pallet
				dw_report.object.desc_art			[ll_row_new] = '[' + ls_cod_art + ']' + ' ' + ls_desc_art
				dw_report.object.fec_empaque		[ll_row_new] = ld_fec_empaque
				
				dw_report.object.titulo1			[ll_row_new] = string(ldc_cant_producida, '###,##0.00') &
																			 + ' ' + ls_und &
																			 + ' - ' &
																			 + string(ldc_total_caja, '###,##0.00') &
																			 + ' ' + ls_und2
				
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion7 ();u_dw_abc 	ldw_detail, ldw_master
decimal		ldc_nro_Copias, ldc_talla, ldc_precio_venta
Date			ld_fec_ingreso
Long			ll_row, ll_cantidad, ll_i, ll_row_new
String		ls_foto, ls_cod_Art, ls_desc_art, ls_linea1, ls_linea2, ls_nom_marca, &
				ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, ls_estilo, &
				ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
				ls_cod_sku, ls_desc_acabado


try 
	
	ldw_detail = istr_rep.dw_d
	ldw_master = istr_rep.dw_m
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CODIGO_BARRAS-QR", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	ld_fec_ingreso = Date(ldw_master.object.fec_registro [1])
	
	
	for ll_row = 1 to ldw_detail.Rowcount()
		ls_cod_art 	= ldw_detail.object.cod_Art							[ll_row]
		ls_Desc_art = ldw_detail.object.desc_art							[ll_row]
		
		//Obtengo la foto del articulo
		ls_foto 		= gnvo_app.almacen.of_get_foto(ls_cod_art)
		
		//Obtengo los demas datos
		select  a.cod_sku,
				  a.estilo, 
				  a.talla,
				  m.nom_marca,
				  a1.abreviatura,
				  zl.abreviatura,
				  zs.desc_sub_linea,
				  za.desc_acabado,
				  c1.descripcion,
				  c2.descripcion,
				  zsu.desc_suela,
				  zt.desc_taco,
				  a.precio_vta_unidad
		into 	:ls_cod_sku,
				:ls_estilo,
				:ldc_talla,
				:ls_nom_marca,
				:ls_abrev_categoria,
				:ls_abrev_linea,
				:ls_desc_sub_linea,
				:ls_desc_acabado,
				:ls_color_primario, 
				:ls_color_secundario,
				:ls_desc_suela,
				:ls_desc_taco,
				:ldc_precio_venta
		from articulo a,
			 articulo_sub_categ a2,
			 articulo_categ     a1,
			 zc_linea           zl,
			 zc_sub_linea       zs,
			 marca              m,
			 zc_acabado         za,
			 color              c1,
			 color              c2,
			 zc_suela           zsu,
			 zc_taco            zt
		where a.cod_sub_linea = zs.cod_sub_linea 	(+)
		 and zs.cod_linea    = zl.cod_linea     	(+)
		 and a.cod_marca     = m.cod_marca      	(+)
		 and a.sub_cat_art   = a2.cod_sub_cat   	(+)
		 and a2.cat_art      = a1.cat_art       	(+)
		 and a.cod_acabado   = za.cod_acabado   	(+)
		 and a.color1        = c1.color         	(+)
		 and a.color2        = c2.color         	(+)
		 and a.cod_suela     = zsu.cod_suela    	(+)
		 and a.cod_taco      = zt.cod_taco      	(+)
		 and a.cod_art		 	= :ls_cod_art;
		
		//Multiplico segun la cantidad indicada
		ll_cantidad = round(Dec(ldw_detail.object.cant_procesada	[ll_row]), 0) * round(ldc_nro_copias, 0)
		
		for ll_i = 1 to ll_cantidad
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				//Armo las dos lineas necesarias
				ls_linea1 = ''
				if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
					ls_linea1 += trim(ls_nom_marca)
				end if
				
				if not IsNull(ls_abrev_categoria) and trim(ls_abrev_categoria) <> '' then
					ls_linea1 += ' ' + trim(ls_abrev_categoria)
				end if
				
				if not IsNull(ls_abrev_linea) and trim(ls_abrev_linea) <> '' then
					ls_linea1 += trim(ls_abrev_linea)
				end if
				
				if not IsNull(ls_desc_sub_linea) and trim(ls_desc_sub_linea) <> '' then
					ls_linea1 += ' ' + trim(ls_desc_sub_linea)
				end if
				
				if not IsNull(ls_estilo) and trim(ls_estilo) <> '' then
					ls_linea1 += ' ' + trim(ls_estilo)
				end if
				
				//Armo las segunda linea
				ls_linea2 = ''
				if not IsNull(ls_desc_acabado) and trim(ls_desc_acabado) <> '' then
					ls_linea2 += trim(ls_desc_acabado)
				end if
	
				if not IsNull(ls_color_primario) and trim(ls_color_primario) <> '' then
					ls_linea2 += ' ' + trim(ls_color_primario)
				end if
				
				if not IsNull(ls_color_secundario) and trim(ls_color_secundario) <> '' then
					ls_linea2 += ' ' + trim(ls_color_secundario)
				end if
				
				if not IsNull(ls_desc_suela) and trim(ls_desc_suela) <> '' then
					ls_linea2 += ' ' + trim(ls_desc_suela)
				end if
				
				if not IsNull(ls_desc_taco) and trim(ls_desc_taco) <> '' then
					ls_linea2 += ' ' + trim(ls_desc_taco)
				end if				
				
				dw_report.object.linea1 			[ll_row_new] = ls_linea1
				dw_report.object.linea2 			[ll_row_new] = ls_linea2
				dw_report.object.marca	 			[ll_row_new] = ls_nom_marca
				dw_report.object.estilo	 			[ll_row_new] = ls_estilo
				dw_report.object.color	 			[ll_row_new] = ls_color_primario
				dw_report.object.cod_sku	 		[ll_row_new] = ls_cod_sku
				dw_report.object.fec_ingreso		[ll_row_new] = ld_fec_ingreso
				dw_report.object.precio_venta 		[ll_row_new] = ldc_precio_venta
				dw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)
				
				if not isnull(ldc_talla) and ldc_talla <> 0 then
					dw_report.object.talla 			[ll_row_new] = ldc_talla
				end if

				dw_report.object.desc_art 			[ll_row_new] = ls_desc_art
				dw_report.object.imagen_blob		[ll_row_new] = ls_foto
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_Desc_art, ls_cod_art )
				
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
end try


//u_dw_abc 	ldw_detail, ldw_master
//Long			ll_row, ll_i, ll_cantidad, ll_row_new
//String		ls_cod_Art, ls_desc_art, ls_code_bar, ls_cod_sku, ls_flag_print_precio, ls_moneda, &
//				ls_sub_cat_art, ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, &
//				ls_cod_acabado, ls_color1, ls_color2
//
//String		ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
//				ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
//				ls_linea1, ls_linea2, ls_mensaje
//
//Decimal		ldc_precio_vta_unidad, ldc_talla, ldc_nro_copias
//Date			ld_fec_ingreso
//
//
//try 
//	
//	ldw_detail = istr_rep.dw_d
//	ldw_master = istr_rep.dw_m
//	
//	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CODIGO_BARRAS", 3.0)
//	
//	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
//		Post close(this)
//		return false
//	end if
//	
//	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
//		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
//		return false
//	end if
//	
//	/*
//		select a.desc_art, 
//				 '*' || a.cod_sku || '*' as code_bar, 
//				 a.cod_sku,
//				 zl.flag_print_precio, 
//				 PKG_LOGISTICA.of_soles(null) as moneda,
//				 a.precio_vta_unidad,
//				 (select max(vm.fec_registro)
//					 from vale_mov vm,
//							articulo_mov am
//					where vm.nro_Vale = am.nro_vale
//					  and am.origen_mov_proy = amp.cod_origen
//				  and am.nro_mov_proy    = amp.nro_mov
//				  and vm.flag_estado <> '0'
//				  and am.flag_estado <> '0'
//				  and vm.tipo_mov    like 'I%') as fec_ingreso
//		from articulo a,
//			  zc_linea zl,
//			  zc_sub_linea zs,
//			  articulo_mov_proy amp,
//			  (select 1 from dual
//				union
//				select 2 from dual
//				union
//				select 3 from dual) s
//		where amp.cod_art     = a.cod_art
//		  and a.cod_sub_linea = zs.cod_sub_linea (+)
//		  and zs.cod_linea    = zl.cod_linea     (+)
//		  and amp.nro_doc     = :as_nro_doc
//		  and amp.tipo_doc    = (select doc_oc from logparam where reckey = '1')
//		order by a.sub_cat_art, a.cod_marca, a.cod_sub_linea, a.estilo, a.cod_suela, a.cod_acabado, a.color1, a.talla
//	  */
//	
//	//Obtengo le fecha de ingreso
//	ld_fec_ingreso = Date(ldw_master.object.fec_registro [1])
//	
//	for ll_row = 1 to ldw_detail.Rowcount()
//		ls_cod_art 	= ldw_detail.object.cod_Art							[ll_row]
//		ls_Desc_art = ldw_detail.object.desc_art							[ll_row]
//		
//		//Obtengo los datos que necesito
//		select  '*' || a.cod_sku || '*' as code_bar, 
//				  a.cod_sku,
//				  zl.flag_print_precio, 
//				  PKG_LOGISTICA.of_soles(null) as moneda,
//				  a.precio_vta_unidad,
//				  a.sub_cat_art, 
//				  a.cod_marca, 
//				  a.cod_sub_linea, 
//				  a.estilo, 
//				  a.cod_suela, 
//				  a.cod_acabado, 
//				  a.color1, 
//				  a.color2,
//				  a.talla,
//				  m.nom_marca,
//				  a1.abreviatura,
//				  zl.abreviatura,
//				  zs.desc_sub_linea,
//				  za.desc_acabado,
//				  c1.descripcion,
//				  c2.descripcion,
//				  zsu.desc_suela,
//				  zt.desc_taco
//		into 	:ls_code_bar,
//				:ls_cod_sku,
//				:ls_flag_print_precio,
//				:ls_moneda,
//				:ldc_precio_vta_unidad,
//				:ls_sub_cat_art,
//				:ls_cod_marca,
//				:ls_cod_sub_linea,
//				:ls_estilo,
//				:ls_cod_suela,
//				:ls_cod_acabado,
//				:ls_color1,
//				:ls_color2,
//				:ldc_talla,
//				:ls_nom_marca,
//				:ls_abrev_categoria,
//				:ls_abrev_linea,
//				:ls_desc_sub_linea,
//				:ls_desc_acabado,
//				:ls_color_primario, 
//				:ls_color_secundario,
//				:ls_desc_suela,
//				:ls_desc_taco
//		from articulo a,
//			 articulo_sub_categ a2,
//			 articulo_categ     a1,
//			 zc_linea           zl,
//			 zc_sub_linea       zs,
//			 marca              m,
//			 zc_acabado         za,
//			 color              c1,
//			 color              c2,
//			 zc_suela           zsu,
//			 zc_taco            zt
//		where a.cod_sub_linea = zs.cod_sub_linea 	(+)
//		 and zs.cod_linea    = zl.cod_linea     	(+)
//		 and a.cod_marca     = m.cod_marca      	(+)
//		 and a.sub_cat_art   = a2.cod_sub_cat   	(+)
//		 and a2.cat_art      = a1.cat_art       	(+)
//		 and a.cod_acabado   = za.cod_acabado   	(+)
//		 and a.color1        = c1.color         	(+)
//		 and a.color2        = c2.color         	(+)
//		 and a.cod_suela     = zsu.cod_suela    	(+)
//		 and a.cod_taco      = zt.cod_taco      	(+)
//		 and a.cod_art		 	= :ls_cod_art;
//		
//		if SQLCA.SQLCOde < 0 then
//			ls_mensaje = SQLCA.SQLErrText
//			ROLLBACK;
//			MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
//			return false
//		end if
//		
//		//Multiplico segun la cantidad indicada
//		ll_cantidad = round(Dec(ldw_detail.object.cant_procesada	[ll_row]), 0) * round(ldc_nro_copias, 0)
//		
//		for ll_i = 1 to ll_cantidad
//			ll_row_new = dw_report.InsertRow(0)
//			
//			if ll_row_new > 0 then
//				
//				//Armo las dos lineas necesarias
//				ls_linea1 = ''
//				if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
//					ls_linea1 += trim(ls_nom_marca)
//				end if
//				
//				if not IsNull(ls_abrev_categoria) and trim(ls_abrev_categoria) <> '' then
//					ls_linea1 += ' ' + trim(ls_abrev_categoria)
//				end if
//				
//				if not IsNull(ls_abrev_linea) and trim(ls_abrev_linea) <> '' then
//					ls_linea1 += trim(ls_abrev_linea)
//				end if
//				
//				if not IsNull(ls_desc_sub_linea) and trim(ls_desc_sub_linea) <> '' then
//					ls_linea1 += ' ' + trim(ls_desc_sub_linea)
//				end if
//				
//				if not IsNull(ls_estilo) and trim(ls_estilo) <> '' then
//					ls_linea1 += ' ' + trim(ls_estilo)
//				end if
//				
//				//Armo las segunda linea
//				ls_linea2 = ''
//				if not IsNull(ls_desc_acabado) and trim(ls_desc_acabado) <> '' then
//					ls_linea2 += trim(ls_desc_acabado)
//				end if
//	
//				if not IsNull(ls_color_primario) and trim(ls_color_primario) <> '' then
//					ls_linea2 += ' ' + trim(ls_color_primario)
//				end if
//				
//				if not IsNull(ls_color_secundario) and trim(ls_color_secundario) <> '' then
//					ls_linea2 += ' ' + trim(ls_color_secundario)
//				end if
//				
//				if not IsNull(ls_desc_suela) and trim(ls_desc_suela) <> '' then
//					ls_linea2 += ' ' + trim(ls_desc_suela)
//				end if
//				
//				if not IsNull(ls_desc_taco) and trim(ls_desc_taco) <> '' then
//					ls_linea2 += ' ' + trim(ls_desc_taco)
//				end if
//				
//				
//				dw_report.object.linea1 				[ll_row_new] = ls_linea1
//				dw_report.object.linea2 				[ll_row_new] = ls_linea2
//				dw_report.object.code_bar 				[ll_row_new] = ls_code_bar
//				dw_report.object.cod_sku 				[ll_row_new] = ls_cod_sku
//				dw_report.object.flag_print_precio 	[ll_row_new] = ls_flag_print_precio
//				
//				if ls_flag_print_precio = '1' then
//					dw_report.object.moneda 				[ll_row_new] = ls_moneda
//					dw_report.object.precio_vta_unidad 	[ll_row_new] = ldc_precio_vta_unidad
//				else
//					dw_report.object.moneda 				[ll_row_new] = gnvo_app.is_null
//					dw_report.object.precio_vta_unidad 	[ll_row_new] = gnvo_app.idc_null
//				end if
//				dw_report.object.sub_Cat_art 			[ll_row_new] = ls_sub_cat_art
//				dw_report.object.cod_marca 			[ll_row_new] = ls_cod_marca
//				dw_report.object.cod_sub_linea 		[ll_row_new] = ls_cod_sub_linea
//				dw_report.object.estilo 				[ll_row_new] = ls_estilo
//				dw_report.object.cod_suela 			[ll_row_new] = ls_cod_suela
//				dw_report.object.cod_acabado 			[ll_row_new] = ls_cod_acabado
//				dw_report.object.color1 				[ll_row_new] = ls_color1
//				dw_report.object.color2 				[ll_row_new] = ls_color2
//				dw_report.object.fec_ingreso		[ll_row_new] = ld_fec_ingreso
//				dw_report.object.cod_taco			[ll_row_new] = ls_desc_taco
//				dw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)
//				
//				
//				if not isnull(ldc_talla) and ldc_talla <> 0 then
//					dw_report.object.talla 					[ll_row_new] = ldc_talla
//				end if
//			end if
//		next
//		
//		
//		
//	next
//	
//	dw_report.Sort()
//	
//	return true
//	
//catch ( Exception ex )
//	
//	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
//	
//	return false
//end try
//
//
//
end function

public function boolean of_opcion8 ();String			ls_nro_parte, ls_nro_min, ls_nro_max, ls_codigo_cu, ls_code_qr, ls_cod_art, ls_desc_art, &
					ls_cod_moneda
//Descripcion del articulo
String			ls_cod_sku, ls_flag_print_precio, ls_moneda, ldc_precio_vta_unidad, ls_sub_cat_art, &
					ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, ls_cod_acabado, ls_color1, &
					ls_color2, ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
					ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
					ls_mensaje, ls_linea1, ls_linea2
Date				ld_fec_parte
Decimal			ldc_nro_copias, ldc_precio_vta, ldc_talla
Long				ll_row, ll_row_new, ll_i
u_ds_base		lds_base
u_dw_abc 		ldw_master


try 
	ldw_master 		= istr_rep.dw_m
	ls_nro_parte 	= istr_rep.string1
	
	//Obtengo el rango de codigos CU
	select max(teu.codigo_cu), min(teu.codigo_cu)
		into :ls_nro_max, :ls_nro_min
	from 	tg_parte_empaque_und teu,
     		zc_parte_ingreso_und ziu
	where teu.regkey = ziu.regkey
	  and ziu.nro_parte = :ls_nro_parte;
	
	if SQLCA.SQLCode = 100 then
		gnvo_app.of_message_error("No se han creado códigos CU para este nro de parte " + ls_nro_parte)
		return false
	end if
	
	if not gnvo_app.of_get_rango( ls_nro_min, ls_nro_max) then
		return false
	end if

	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1, ls_nro_min, ls_nro_max)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos de caja CU en el rango indicado " + ls_nro_min + &
										+ "-" + ls_nro_max + " para el nro de parte: " + ls_nro_parte)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CU_PPTT", 2.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select teu.codigo_cu,
				 a.cod_art,
				 a.desc_art,
				 a.und,
				 '' as linea1,
				 '' as linea2,
				 ziu.nro_parte,
				 zi.fec_parte,
				 'C:\SIGRE\resources\PNG\qr_example.png' as codigo_qr
		from tg_parte_empaque_und 	teu,
			  zc_parte_ingreso_und 	ziu,
			  zc_parte_ingreso		zi,
			  articulo             	a
		where teu.regkey 		= ziu.regkey
		  and ziu.cod_Art  	= a.cod_art
		  and ziu.nro_parte	= zi.nro_parte
		  and ziu.nro_parte 	= :as_nro_parte
		  and teu.codigo_cu	between :as_nro_min and :as_nro_max
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_codigo_cu 	= lds_base.object.codigo_cu 		[ll_row]
		ls_cod_art		= lds_base.object.cod_art 			[ll_row]
		ld_fec_parte	= Date(lds_base.object.fec_parte	[ll_row])
		ldc_precio_vta	= Dec(lds_base.object.precio_vta	[ll_row])
		ldc_talla		= Dec(lds_base.object.talla		[ll_row])
		ls_cod_moneda	= lds_base.object.cod_moneda		[ll_row]
		
		
		//Obtengo los datos que necesito
		select  a.cod_sku,
				  zl.flag_print_precio, 
				  PKG_LOGISTICA.of_soles(null) as moneda,
				  a.precio_vta_unidad,
				  a.sub_cat_art, 
				  a.cod_marca, 
				  a.cod_sub_linea, 
				  a.estilo, 
				  a.cod_suela, 
				  a.cod_acabado, 
				  a.color1, 
				  a.color2,
				  a.talla,
				  m.nom_marca,
				  a1.abreviatura,
				  zl.abreviatura,
				  zs.desc_sub_linea,
				  za.desc_acabado,
				  c1.descripcion,
				  c2.descripcion,
				  zsu.desc_suela,
				  zt.desc_taco,
				  a.desc_art
		into 	:ls_cod_sku,
				:ls_flag_print_precio,
				:ls_moneda,
				:ldc_precio_vta_unidad,
				:ls_sub_cat_art,
				:ls_cod_marca,
				:ls_cod_sub_linea,
				:ls_estilo,
				:ls_cod_suela,
				:ls_cod_acabado,
				:ls_color1,
				:ls_color2,
				:ldc_talla,
				:ls_nom_marca,
				:ls_abrev_categoria,
				:ls_abrev_linea,
				:ls_desc_sub_linea,
				:ls_desc_acabado,
				:ls_color_primario, 
				:ls_color_secundario,
				:ls_desc_suela,
				:ls_desc_taco,
				:ls_desc_art
		from articulo a,
			 articulo_sub_categ a2,
			 articulo_categ     a1,
			 zc_linea           zl,
			 zc_sub_linea       zs,
			 marca              m,
			 zc_acabado         za,
			 color              c1,
			 color              c2,
			 zc_suela           zsu,
			 zc_taco            zt
		where a.cod_sub_linea = zs.cod_sub_linea 	(+)
		 and zs.cod_linea    = zl.cod_linea     	(+)
		 and a.cod_marca     = m.cod_marca      	(+)
		 and a.sub_cat_art   = a2.cod_sub_cat   	(+)
		 and a2.cat_art      = a1.cat_art       	(+)
		 and a.cod_acabado   = za.cod_acabado   	(+)
		 and a.color1        = c1.color         	(+)
		 and a.color2        = c2.color         	(+)
		 and a.cod_suela     = zsu.cod_suela    	(+)
		 and a.cod_taco      = zt.cod_taco      	(+)
		 and a.cod_art		 	= :ls_cod_art;
		
		if SQLCA.SQLCOde < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
			return false
		end if
		
		
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				//Armo las dos lineas necesarias
				ls_linea1 = ''
				if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
					ls_linea1 += trim(ls_nom_marca)
				end if
				
				if not IsNull(ls_abrev_categoria) and trim(ls_abrev_categoria) <> '' then
					ls_linea1 += ' ' + trim(ls_abrev_categoria)
				end if
				
				if not IsNull(ls_abrev_linea) and trim(ls_abrev_linea) <> '' then
					ls_linea1 += trim(ls_abrev_linea)
				end if
				
				if not IsNull(ls_desc_sub_linea) and trim(ls_desc_sub_linea) <> '' then
					ls_linea1 += ' ' + trim(ls_desc_sub_linea)
				end if
				
				if not IsNull(ls_estilo) and trim(ls_estilo) <> '' then
					ls_linea1 += ' ' + trim(ls_estilo)
				end if
				
				//Armo las segunda linea
				ls_linea2 = ''
				if not IsNull(ls_desc_acabado) and trim(ls_desc_acabado) <> '' then
					ls_linea2 += trim(ls_desc_acabado)
				end if
	
				if not IsNull(ls_color_primario) and trim(ls_color_primario) <> '' then
					if len(ls_color_primario) > 6 then
						ls_color_primario = left(trim(ls_color_primario), 6)
					end if
					
					ls_linea2 += ' ' + trim(ls_color_primario)
				end if
				
				if not IsNull(ls_color_secundario) and trim(ls_color_secundario) <> '' then
					if len(ls_color_secundario) > 6 then
						ls_color_secundario = left(trim(ls_color_secundario), 6)
					end if
					ls_linea2 += ' ' + trim(ls_color_secundario)
				end if
				
				if not IsNull(ls_desc_suela) and trim(ls_desc_suela) <> '' then
					ls_linea2 += ' ' + trim(ls_cod_suela)
				end if
				
				if not IsNull(ls_desc_taco) and trim(ls_desc_taco) <> '' then
					ls_linea2 += ' ' + trim(ls_desc_taco)
				end if
				
				
				//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_codigo_cu) and trim(ls_codigo_cu) <> '' then
					ls_code_qr += trim(ls_codigo_cu) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(gs_empresa) and trim(gs_empresa) <> '' then
					ls_code_qr += trim(gs_empresa) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_cod_sku) and trim(ls_cod_sku) <> '' then
					ls_code_qr += trim(ls_cod_sku) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_cod_art) and trim(ls_cod_art) <> '' then
					ls_code_qr += trim(ls_cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				/*
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				*/
				/*
				if not IsNull(ls_cod_sku) and trim(ls_cod_sku) <> '' then
					ls_code_qr += trim(ls_cod_sku) + '|'
				else
					ls_code_qr += '|'
				end if
				*/
				if not IsNull(ls_nro_parte) and trim(ls_nro_parte) <> '' then
					ls_code_qr += trim(ls_nro_parte) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_parte)  then
					ls_code_qr += string(ld_fec_parte, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
			
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, ls_codigo_cu )
				dw_report.object.codigo_cu			[ll_row_new] = ls_codigo_cu
				dw_report.object.linea1 			[ll_row_new] = ls_linea1
				dw_report.object.linea2 			[ll_row_new] = ls_linea2
				dw_report.object.nro_parte			[ll_row_new] = ls_nro_parte
				dw_report.object.cod_moneda		[ll_row_new] = ls_cod_moneda
				dw_report.object.cod_sku			[ll_row_new] = ls_cod_sku
				dw_report.object.precio_vta		[ll_row_new] = ldc_precio_vta
				dw_report.object.talla				[ll_row_new] = ldc_talla
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion9 ();String			ls_nro_parte, ls_nro_min, ls_nro_max, ls_codigo_cu, ls_code_qr, ls_cod_art, ls_desc_art, &
					ls_cod_moneda, ls_foto
//Descripcion del articulo
String			ls_cod_sku, ls_flag_print_precio, ls_moneda, ldc_precio_vta_unidad, ls_sub_cat_art, &
					ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, ls_cod_acabado, ls_color1, &
					ls_color2, ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
					ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
					ls_mensaje, ls_linea1, ls_linea2
Date				ld_fec_parte
Decimal			ldc_nro_copias, ldc_precio_vta, ldc_talla
Long				ll_row, ll_row_new, ll_i
u_ds_base		lds_base
u_dw_abc 		ldw_master


try 
	ldw_master 		= istr_rep.dw_m
	ls_nro_parte 	= istr_rep.string1
	
	//Obtengo el rango de codigos CU
	select max(teu.codigo_cu), min(teu.codigo_cu)
		into :ls_nro_max, :ls_nro_min
	from 	tg_parte_empaque_und teu,
     		zc_parte_ingreso_und ziu
	where teu.regkey = ziu.regkey
	  and ziu.nro_parte = :ls_nro_parte;
	
	if SQLCA.SQLCode = 100 then
		gnvo_app.of_message_error("No se han creado códigos CU para este nro de parte " + ls_nro_parte)
		return false
	end if
	
	if not gnvo_app.of_get_rango( ls_nro_min, ls_nro_max) then
		return false
	end if

	
	lds_base = create u_ds_base
	lds_base.DataObject = 'd_rpt_codigos_cu_pptt_lbl' //istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1, ls_nro_min, ls_nro_max)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos de caja CU en el rango indicado " + ls_nro_min + &
										+ "-" + ls_nro_max + " para el nro de parte: " + ls_nro_parte)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CU_PPTT_GRANDES", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select teu.codigo_cu,
				 a.cod_art,
				 a.desc_art,
				 a.und,
				 '' as linea1,
				 '' as linea2,
				 ziu.nro_parte,
				 zi.fec_parte,
				 'C:\SIGRE\resources\PNG\qr_example.png' as codigo_qr
		from tg_parte_empaque_und 	teu,
			  zc_parte_ingreso_und 	ziu,
			  zc_parte_ingreso		zi,
			  articulo             	a
		where teu.regkey 		= ziu.regkey
		  and ziu.cod_Art  	= a.cod_art
		  and ziu.nro_parte	= zi.nro_parte
		  and ziu.nro_parte 	= :as_nro_parte
		  and teu.codigo_cu	between :as_nro_min and :as_nro_max
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_codigo_cu 	= lds_base.object.codigo_cu 		[ll_row]
		ls_cod_art		= lds_base.object.cod_art 			[ll_row]
		ld_fec_parte	= Date(lds_base.object.fec_parte	[ll_row])
		ldc_precio_vta	= Dec(lds_base.object.precio_vta	[ll_row])
		ldc_talla		= Dec(lds_base.object.talla		[ll_row])
		ls_cod_moneda	= lds_base.object.cod_moneda		[ll_row]
		
		
		//Obtengo los datos que necesito
		select  a.cod_sku,
				  zl.flag_print_precio, 
				  PKG_LOGISTICA.of_soles(null) as moneda,
				  a.precio_vta_unidad,
				  a.sub_cat_art, 
				  a.cod_marca, 
				  a.cod_sub_linea, 
				  a.estilo, 
				  a.cod_suela, 
				  a.cod_acabado, 
				  a.color1, 
				  a.color2,
				  a.talla,
				  m.nom_marca,
				  a1.abreviatura,
				  zl.abreviatura,
				  zs.desc_sub_linea,
				  za.desc_acabado,
				  c1.descripcion,
				  c2.descripcion,
				  zsu.desc_suela,
				  zt.desc_taco,
				  a.desc_art
		into 	:ls_cod_sku,
				:ls_flag_print_precio,
				:ls_moneda,
				:ldc_precio_vta_unidad,
				:ls_sub_cat_art,
				:ls_cod_marca,
				:ls_cod_sub_linea,
				:ls_estilo,
				:ls_cod_suela,
				:ls_cod_acabado,
				:ls_color1,
				:ls_color2,
				:ldc_talla,
				:ls_nom_marca,
				:ls_abrev_categoria,
				:ls_abrev_linea,
				:ls_desc_sub_linea,
				:ls_desc_acabado,
				:ls_color_primario, 
				:ls_color_secundario,
				:ls_desc_suela,
				:ls_desc_taco,
				:ls_desc_art
		from articulo a,
			 articulo_sub_categ a2,
			 articulo_categ     a1,
			 zc_linea           zl,
			 zc_sub_linea       zs,
			 marca              m,
			 zc_acabado         za,
			 color              c1,
			 color              c2,
			 zc_suela           zsu,
			 zc_taco            zt
		where a.cod_sub_linea = zs.cod_sub_linea 	(+)
		 and zs.cod_linea    = zl.cod_linea     	(+)
		 and a.cod_marca     = m.cod_marca      	(+)
		 and a.sub_cat_art   = a2.cod_sub_cat   	(+)
		 and a2.cat_art      = a1.cat_art       	(+)
		 and a.cod_acabado   = za.cod_acabado   	(+)
		 and a.color1        = c1.color         	(+)
		 and a.color2        = c2.color         	(+)
		 and a.cod_suela     = zsu.cod_suela    	(+)
		 and a.cod_taco      = zt.cod_taco      	(+)
		 and a.cod_art		 	= :ls_cod_art;
		
		if SQLCA.SQLCOde < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
			return false
		end if
		
		
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				//Armo las dos lineas necesarias
				ls_linea1 = ''
				if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
					ls_linea1 += trim(ls_nom_marca)
				end if
				
				if not IsNull(ls_abrev_categoria) and trim(ls_abrev_categoria) <> '' then
					ls_linea1 += ' ' + trim(ls_abrev_categoria)
				end if
				
				if not IsNull(ls_abrev_linea) and trim(ls_abrev_linea) <> '' then
					ls_linea1 += trim(ls_abrev_linea)
				end if
				
				if not IsNull(ls_desc_sub_linea) and trim(ls_desc_sub_linea) <> '' then
					ls_linea1 += ' ' + trim(ls_desc_sub_linea)
				end if
				
				if not IsNull(ls_estilo) and trim(ls_estilo) <> '' then
					ls_linea1 += ' ' + trim(ls_estilo)
				end if
				
				//Armo las segunda linea
				ls_linea2 = ''
				if not IsNull(ls_desc_acabado) and trim(ls_desc_acabado) <> '' then
					ls_linea2 += trim(ls_desc_acabado)
				end if
	
				if not IsNull(ls_color_primario) and trim(ls_color_primario) <> '' then
					if len(ls_color_primario) > 6 then
						ls_color_primario = left(trim(ls_color_primario), 6)
					end if
					
					ls_linea2 += ' ' + trim(ls_color_primario)
				end if
				
				if not IsNull(ls_color_secundario) and trim(ls_color_secundario) <> '' then
					if len(ls_color_secundario) > 6 then
						ls_color_secundario = left(trim(ls_color_secundario), 6)
					end if
					ls_linea2 += ' ' + trim(ls_color_secundario)
				end if
				
				if not IsNull(ls_desc_suela) and trim(ls_desc_suela) <> '' then
					ls_linea2 += ' ' + trim(ls_cod_suela)
				end if
				
				if not IsNull(ls_desc_taco) and trim(ls_desc_taco) <> '' then
					ls_linea2 += ' ' + trim(ls_desc_taco)
				end if
				
				
				//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_codigo_cu) and trim(ls_codigo_cu) <> '' then
					ls_code_qr += trim(ls_codigo_cu) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(gs_empresa) and trim(gs_empresa) <> '' then
					ls_code_qr += trim(gs_empresa) + '|'
				else
					ls_code_qr += '|'
				end if
				
				
				
				if not IsNull(ls_cod_sku) and trim(ls_cod_sku) <> '' then
					ls_code_qr += trim(ls_cod_sku) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_cod_art) and trim(ls_cod_art) <> '' then
					ls_code_qr += trim(ls_cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				/*
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_cod_sku) and trim(ls_cod_sku) <> '' then
					ls_code_qr += trim(ls_cod_sku) + '|'
				else
					ls_code_qr += '|'
				end if
				*/
				
				if not IsNull(ls_nro_parte) and trim(ls_nro_parte) <> '' then
					ls_code_qr += trim(ls_nro_parte) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_parte)  then
					ls_code_qr += string(ld_fec_parte, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				//Obtengo la foto del articulo
				ls_foto 		= gnvo_app.almacen.of_get_foto(ls_cod_art)
		
				
				dw_report.object.codigo_cu			[ll_row_new] = ls_codigo_cu
				dw_report.object.linea1 			[ll_row_new] = ls_linea1
				dw_report.object.linea2 			[ll_row_new] = ls_linea2
				dw_report.object.marca	 			[ll_row_new] = ls_nom_marca
				dw_report.object.estilo	 			[ll_row_new] = ls_estilo
				dw_report.object.color	 			[ll_row_new] = ls_color_primario
				dw_report.object.cod_sku	 		[ll_row_new] = ls_cod_sku
				dw_report.object.fec_ingreso		[ll_row_new] = ld_Fec_parte
				dw_report.object.precio_venta 	[ll_row_new] = ldc_precio_vta
				dw_report.object.cod_moneda	 	[ll_row_new] = ls_cod_moneda
				dw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)
				
				if not isnull(ldc_talla) and ldc_talla <> 0 then
					dw_report.object.talla 			[ll_row_new] = ldc_talla
				end if

				dw_report.object.desc_art 			[ll_row_new] = ls_desc_art
				dw_report.object.imagen_blob		[ll_row_new] = ls_foto
			
				dw_report.object.code_qr			[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, ls_codigo_cu )
				
				
				//dw_report.object.nro_parte		[ll_row_new] = ls_nro_parte
				//dw_report.object.cod_moneda		[ll_row_new] = ls_cod_moneda

			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion10 ();String			ls_nro_parte, ls_nro_min, ls_nro_max, ls_code_qr
//Descripcion del articulo
String			ls_codigo_recepcion, ls_especie, ls_desc_especie, ls_cod_art, ls_desc_Art, &
					ls_und, ls_nro_lote, ls_foto, ls_nro_tina, ls_nro_contenedor
Decimal			ldc_nro_copias, ldc_peso_neto, ldc_nro_cajas
Long				ll_row, ll_i, ll_row_new
Date				ld_fecha_descarga
u_ds_base		lds_base
u_dw_abc 		ldw_master

try 
	ldw_master 		= istr_rep.dw_m
	ls_nro_parte 	= istr_rep.string1
	
	//Obtengo el rango de codigos CU
	select max(b.codigo_recepcion), min(b.codigo_recepcion)
	  into :ls_nro_max, :ls_nro_min
	  from ap_pd_descarga a,
			 ap_pd_descarga_det b
	 where a.nro_parte = b.nro_parte
		and a.nro_parte = :ls_nro_parte ;
	
	if SQLCA.SQLCode = 100 then
		gnvo_app.of_message_error("No se han creado códigos CU para este nro de parte " + ls_nro_parte)
		return false
	end if
	
	if not gnvo_app.of_get_rango( ls_nro_min, ls_nro_max) then
		post event close()
		return false
	end if

	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1, ls_nro_min, ls_nro_max)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos de caja CU en el rango indicado " + ls_nro_min + &
										+ "-" + ls_nro_max + " para el nro de parte: " + ls_nro_parte)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_CU_PPTT_GRANDES", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		//Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		/*
			select pd.codigo_recepcion,
					 pd.especie,
					 te.descr_especie as desc_especie,
					 a.cod_Art,
					 a.desc_art,
					 a.und,
					 pd.peso_bruto - pd.tara as peso_neto,
					 pd.nro_lote
			  from ap_pd_descarga_det pd,
					 tg_especies        te,
					 articulo           a
			 where pd.especie 	= te.especie
				and pd.cod_Art 	= a.cod_art
				and pd.nro_parte	= :as_nro_parte
		*/

		
		ls_codigo_recepcion 	= lds_base.object.codigo_recepcion 		[ll_row]
		ls_especie				= lds_base.object.especie		 			[ll_row]
		ls_desc_especie		= lds_base.object.desc_especie 			[ll_row]
		ls_cod_art				= lds_base.object.cod_art		 			[ll_row]
		ls_desc_art				= lds_base.object.desc_art		 			[ll_row]
		ls_und					= lds_base.object.und			 			[ll_row]
		ls_nro_lote				= lds_base.object.nro_lote		 			[ll_row]
		ldc_peso_neto			= Dec(lds_base.object.peso_neto			[ll_row])
		ls_nro_tina				= lds_base.object.nro_tina					[ll_row]
		ls_nro_contenedor		= lds_base.object.nro_contenedor			[ll_row]
		ld_fecha_descarga		= Date(lds_base.object.fecha_descarga	[ll_row])
		
		if lds_base.of_existeCampo('nro_cajas') then
			ldc_nro_cajas		= Dec(lds_base.object.nro_cajas			[ll_row])
		end if
		
		
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				
				
				
				//Arco el codigo QE
				ls_code_qr = ''
				if not IsNull(ls_codigo_recepcion) and trim(ls_codigo_recepcion) <> '' then
					ls_code_qr += trim(ls_codigo_recepcion) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_desc_especie) and trim(ls_desc_especie) <> '' then
					ls_code_qr += trim(ls_desc_especie) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_Desc_art) and trim(ls_Desc_art) <> '' then
					ls_code_qr += trim(left(ls_Desc_art, 100)) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if ldc_peso_neto <> 0 then
					ls_code_qr += trim(string(ldc_peso_neto, '###,##0.00')) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_und) and trim(ls_und) <> '' then
					ls_code_qr += trim(ls_und) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_lote) and trim(ls_nro_lote) <> '' then
					ls_code_qr += trim(ls_nro_lote) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_tina) and trim(ls_nro_tina) <> '' then
					ls_code_qr += trim(ls_nro_tina) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_contenedor) and trim(ls_nro_contenedor) <> '' then
					ls_code_qr += trim(ls_nro_contenedor) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fecha_descarga) then
					if upper(gs_empresa) = 'SEAFROST' then
						ls_code_qr += '|'
					else
						ls_code_qr += string(ld_fecha_descarga) + '|'
					end if
					
				else
					ls_code_qr += '|'
				end if
				
				
				
				dw_report.object.codigo_recepcion	[ll_row_new] = trim(ls_codigo_recepcion)
				dw_report.object.desc_especie			[ll_row_new] = trim(ls_desc_especie)
				dw_report.object.desc_art				[ll_row_new] = "[" + trim(ls_cod_art) + "] " + trim(ls_desc_art)
				dw_report.object.nro_lote				[ll_row_new] = trim(ls_nro_lote)
				dw_report.object.peso_neto				[ll_row_new] = ldc_peso_neto
				dw_report.object.und						[ll_row_new] = trim(ls_und)
				dw_report.object.nro_tina				[ll_row_new] = trim(ls_nro_tina)
				dw_report.object.nro_contenedor		[ll_row_new] = trim(ls_nro_contenedor)
				dw_report.object.fecha_descarga		[ll_row_new] = ld_fecha_descarga
				
				if dw_report.of_existeCampo('nro_cajas') then
					dw_report.object.nro_cajas			[ll_row_new] = ldc_nro_cajas
				end if
				
				
				dw_report.object.code_qr				[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, ls_codigo_recepcion )
				
				
				//dw_report.object.nro_parte		[ll_row_new] = ls_nro_parte
				//dw_report.object.cod_moneda		[ll_row_new] = ls_cod_moneda

			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

public function boolean of_opcion11 ();u_dw_abc 	ldw_master
Long			ll_row, ll_nro_caja, ll_i, ll_row_new
decimal		ldc_nro_copias, ldc_cant_producida
String		ls_nro_pallet, ls_desc_art, ls_descripcion_articulo, ls_Cod_art, ls_nro_parte, &
				ls_code_qr, ls_und, ls_und2, ls_nro_trazabilidad
Date			ld_fec_empaque, ld_fec_produccion
u_ds_base	lds_base



try 
	ldw_master = istr_rep.dw_m
	
	lds_base = create u_ds_base
	lds_base.DataObject = istr_rep.dw1
	lds_base.SetTransObject(SQLCA)
	lds_base.Retrieve(istr_rep.string1)
	
	if lds_base.rowcount( ) <= 0 then
		gnvo_app.of_message_error("No existen códigos registros para el PALLET " + istr_rep.string1)
		return false
	end if
	
	ldc_nro_copias = gnvo_app.of_get_parametro_dec("NRO_COPIAS_PALLET_PPTT", 1.0)
	
	if not gnvo_app.of_prompt_number("Indique la cantidad de copias a generar", ldc_nro_copias) then 
		Post close(this)
		return false
	end if
	
	if ldc_nro_copias <= 0 or IsNull(ldc_nro_copias) then
		gnvo_app.of_message_error("Debe ingresar un cantidad mayor que cero, cantidad ingresada es invalida")
		return false
	end if
	
	/*
		select a.cod_art,
				 a.desc_art,
				 tpe.nro_pallet,
				 tpe.fec_empaque,
				 tpe.fec_produccion,
				 tpe.nro_parte
		from tg_parte_empaque tpe,
			  articulo         a
		where tpe.cod_art_pptt = a.cod_art     
	*/
	
	//Obtengo el nro de parte
	for ll_row = 1 to lds_base.Rowcount()
		
		ls_Cod_art	 			= lds_base.object.cod_art_pptt 			[ll_row]
		ls_desc_art	 			= lds_base.object.desc_art_pptt			[ll_row]
		ls_nro_pallet 			= lds_base.object.nro_pallet 				[ll_row]
		ls_und		 			= lds_base.object.und		 				[ll_row]
		ls_und2					= lds_base.object.und2				 		[ll_row]
		
		ld_fec_produccion		= Date(lds_base.object.fec_produccion	[ll_row])
		ld_fec_empaque			= Date(lds_base.object.fec_empaque		[ll_row])
		
		ldc_cant_producida	= Dec(lds_base.object.cant_producida	[ll_row])
		
		
		for ll_i = 1 to Long(ldc_nro_copias)
			ll_row_new = dw_report.InsertRow(0)
			
			if ll_row_new > 0 then
				dw_report.Object.p_logo.filename = gs_logo
				
				//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_Cod_art) and trim(ls_Cod_art) <> '' then
					ls_code_qr += trim(ls_Cod_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_desc_art) and trim(ls_desc_art) <> '' then
					ls_code_qr += trim(ls_desc_art) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ls_nro_pallet) and trim(ls_nro_pallet) <> '' then
					ls_code_qr += trim(ls_nro_pallet) + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_produccion)  then
					ls_code_qr += string(ld_fec_produccion, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				if not IsNull(ld_fec_empaque)  then
					ls_code_qr += string(ld_fec_empaque, 'dd/mm/yyyy') + '|'
				else
					ls_code_qr += '|'
				end if
				
				dw_report.object.code_qr				[ll_row_new] = invo_codeqr.of_generar_qrcode( ls_code_qr, 'PALLET_' + ls_nro_pallet )
				
				//LLeno el resto de datos necesarios
				dw_report.object.desc_almacen_pptt	[ll_row_new] = lds_base.object.desc_almacen_pptt 	[ll_row]
				dw_report.object.desc_art_pptt		[ll_row_new] = lds_base.object.desc_art_pptt 		[ll_row]
				dw_report.object.nro_parte				[ll_row_new] = lds_base.object.nro_parte 				[ll_row]
				dw_report.object.factor_conv_und		[ll_row_new] = lds_base.object.factor_conv_und 		[ll_row]
				dw_report.object.Und2					[ll_row_new] = lds_base.object.Und2 					[ll_row]
				dw_report.object.nro_pallet			[ll_row_new] = lds_base.object.nro_pallet 			[ll_row]
				dw_report.object.desc_envase			[ll_row_new] = lds_base.object.desc_envase 			[ll_row]
				dw_report.object.cant_producida		[ll_row_new] = lds_base.object.cant_producida 		[ll_row]
				dw_report.object.und						[ll_row_new] = lds_base.object.und 						[ll_row]
				dw_report.object.nomenclatura			[ll_row_new] = lds_base.object.nomenclatura 			[ll_row]
				dw_report.object.lote_dia				[ll_row_new] = lds_base.object.lote_dia 				[ll_row]
				dw_report.object.fec_produccion		[ll_row_new] = lds_base.object.fec_produccion 		[ll_row]
				dw_report.object.fec_vencimiento		[ll_row_new] = lds_base.object.fec_vencimiento 		[ll_row]
				dw_report.object.nom_cliente			[ll_row_new] = lds_base.object.nom_cliente 			[ll_row]
				dw_report.object.nom_controlador		[ll_row_new] = lds_base.object.nom_controlador 		[ll_row]
				dw_report.object.nro_bath				[ll_row_new] = lds_base.object.nro_bath 				[ll_row]
				dw_report.object.nro_trazabilidad	[ll_row_new] = lds_base.object.nro_trazabilidad 	[ll_row]
				dw_report.object.nro_vale_ing			[ll_row_new] = lds_base.object.nro_vale_ing 			[ll_row]
				dw_report.object.cod_usr				[ll_row_new] = lds_base.object.cod_usr 				[ll_row]
				dw_report.object.nro_ot					[ll_row_new] = lds_base.object.nro_ot 					[ll_row]
				dw_report.object.titulo_ot				[ll_row_new] = lds_base.object.titulo_ot 				[ll_row]
				dw_report.object.observaciones		[ll_row_new] = lds_base.object.observaciones 		[ll_row]
				
				if dw_report.of_existeCampo("nro_ov") then
					dw_report.object.nro_ov				[ll_row_new] = lds_base.object.nro_ov 					[ll_row]				
				end if
				
				

				
			end if
		next
		
		
		
	next
	
	dw_report.Sort()
	
	return true
	
catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, "Error al recuperar reporte para codigo de barras")
	
	return false
finally
	destroy lds_base
end try


end function

on w_rpt_preview.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_rpt_preview.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm
invo_codeqr = create n_cst_codeqr

idw_1 = dw_report
idw_1.Visible = False

//this.Event ue_preview()

This.Event ue_retrieve()

if ib_salir then
	post event closequery()
end if

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_cad1, ls_cad2, ls_inifile, ls_firma_digital, ls_cod_usr, ls_tipo_mov
Integer	li_opi

try 
	this.title = istr_rep.titulo
	ls_inifile = istr_rep.inifile
	
	dw_report.dataobject = istr_rep.dw1
	dw_report.SetTransObject(sqlca)
	
	CHOOSE CASE istr_rep.tipo 
			//Impresión de código de barras desde almacen
			case '1'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion1() then 
					post event closequery()
					return
				end if
			
			//Impresión de código de barras desde almacen
			case '2'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion2() then 
					post event closequery()
					return
				end if
				
			//Impresión de código de barras del pallet del producto terminado
			case '3'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion3() then 
					post event closequery()
					return
				end if	
				
			//Impresión de código de barras del pallet del producto terminado
			case '4'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion4() then 
					post event closequery()
					return
				end if	
				
			//Impresión de código de barras del pallet del producto terminado- transferencia
			case '5'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion5() then 
					post event closequery()
					return
				end if	
				
			//Impresión de código de barras del pallet del producto terminado
			case '6'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion6() then 
					post event closequery()
					return
				end if
				
			//Impresión de código de barras del pallet del producto terminado
			case '7'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion7() then 
					post event closequery()
					return
				end if	
			
			//Impresión de Códigos CU para la zapatería Central
			case '8'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion8() then 
					post event close()
					return
				end if
			
			//Impresión de Códigos CU para la zapatería Central
			case '9'
				//dw_report.retrieve(istr_rep.string1)
				if not of_opcion9() then 
					post close(this)
					return
				end if
			
			//Impresión de Códigos CU para la zapatería Central
			case '10'
				if not of_opcion10() then 
					ib_salir = true
					post close(this)
					return
				end if

			//Impresión de Pallets para Conserva
			case '11'
				if not of_opcion11() then 
					ib_salir = true
					post close(this)
					return
				end if
				
			case '1S'
				dw_report.retrieve(istr_rep.string1)
			case '1S1I'
				dw_report.retrieve(istr_rep.string1, istr_rep.integer1)
			case '1S2S'
				dw_report.retrieve(istr_rep.string1, istr_rep.string2)
			case '1S2S3S'
				dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)		
				
			case '1S1I2I3I4I2S'
				dw_report.retrieve(istr_rep.string1, istr_rep.integer1, istr_rep.integer2, &
										 istr_rep.integer3, istr_rep.integer4, istr_rep.string2)
			case '749A'
				dw_report.retrieve(istr_rep.string1, istr_rep.integer1, istr_rep.string2, istr_rep.integer2, istr_rep.date1, istr_rep.date2, istr_rep.string3, istr_rep.string4, istr_rep.string5)
			case '749B'
				dw_report.retrieve(istr_rep.string1, istr_rep.integer1, istr_rep.string2, istr_rep.integer2, istr_rep.date1, istr_rep.date2, istr_rep.string3, istr_rep.string4)									 
	
				
			//Compras
			case '1S1L'
				dw_report.retrieve(istr_rep.string1, istr_rep.long1)
			case '1L'
				dw_report.retrieve(istr_rep.long1)
			case '1S1D'
				dw_report.retrieve(istr_rep.string1, istr_rep.fecha1)
			case '1D2D1S2S'
				dw_report.retrieve(istr_rep.fecha1, istr_rep.fecha2, istr_rep.string1, istr_rep.string2)
			case '1D2D1S2S3S'
				dw_report.retrieve(	istr_rep.fecha1, istr_rep.fecha2, istr_rep.string1, istr_rep.string2, &
											istr_rep.string3)
			case '6S1I'
				dw_report.retrieve(	istr_rep.string1, istr_rep.string2, istr_rep.string3, &
											istr_rep.string4, istr_rep.string5, istr_rep.string6, istr_rep.int1 )
			
			//Presupuesto
			case '1L1A'			
				dw_report.retrieve(istr_rep.long1, istr_rep.field_ret)
			case '1L1S'
				dw_report.retrieve(istr_rep.long1, istr_rep.string1)
			case '2S'
				dw_report.retrieve(istr_rep.string1, istr_rep.string2)
			case '3S'
				dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)
			
			//Opcion para Comprobantes electronicos
			case 'EFACT_PREVIEW'
				dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)
				gnvo_app.ventas.of_config_dw_ce(dw_report)
			
			//Opcion para Cierre de Caja
			case 'CIERRE_CAJA_PREVIEW'
				dw_report.retrieve(istr_rep.date1, istr_rep.date2, istr_rep.string1, istr_rep.string2, istr_rep.string3)
				gnvo_app.ventas.of_config_dw_cierre_caja(dw_report)
	
			//Opcion por defecto
			case else
				dw_report.retrieve()
	END CHOOSE
	
	if dw_report.RowCount() > 0 then
		dw_report.object.datawindow.print.preview = 'Yes'
	end if
	
	if dw_report.of_ExistsPictureName("p_logo") then
		dw_report.Object.p_logo.filename = gs_logo
	end if
	
	// DAtos de la empresa
	if dw_report.of_ExistsText("t_nombre") then
		dw_report.object.t_nombre.text = gs_empresa
	end if	
	
	if dw_report.of_ExistsText("t_nom_empresa") then
		dw_report.object.t_nom_empresa.text = gnvo_app.empresa.is_nom_empresa
	end if	
	
	if dw_report.of_ExistsText("t_empresa") then
		dw_report.object.t_empresa.text = gnvo_app.empresa.is_nom_empresa
	end if	
	
	if dw_report.of_ExistsText( "t_ruc" ) then
		dw_report.Object.t_ruc.text = gnvo_app.empresa.is_ruc
	end if
	
	if dw_report.of_ExistsText( "t_direccion" ) then
		dw_report.Object.t_direccion.text = gnvo_app.empresa.is_direccion
	end if
	
	if dw_report.of_ExistsText( "t_telefono" ) then
		dw_report.Object.t_telefono.text = gnvo_app.empresa.is_telefono
	end if
	
	if dw_report.of_existstext( "t_email" ) then
		dw_report.Object.t_email.text = gnvo_app.empresa.is_email
	end if
	
	
	if idw_1.of_existstext( "t_objeto" ) then
		idw_1.object.t_objeto.text		= istr_rep.dw1
	end if
	
	
	//Titulo
	if dw_report.of_ExistsText("t_titulo1") then
		dw_report.object.t_titulo1.text = istr_rep.titulo
	end if	
	
	if istr_rep.dw1 = 'd_rpt_formato_chq_voucher_preview' then
		gnvo_app.finparam.of_informar_sunat(dw_report)
	end if
	
	//usuario
	if dw_report.of_ExistsText("t_user") then
		dw_report.object.t_user.text = gs_user
	end if	
	
	
	if istr_rep.dw1 = "d_frm_movimiento_almacen" or &
		istr_rep.dw1 = "d_frm_movimiento_almacen_pptt" or &
		istr_rep.dw1 = "d_frm_movimiento_almacen_seafrost_pptt" or &
		istr_rep.dw1 = "d_frm_movimiento_almacen_seafrost_tbl" or &
		istr_rep.dw1 = "d_frm_movimiento_alm_cantabria" then
		
		if upper(gs_empresa) = 'FISHOLG' or upper(gs_empresa) = "ARCOPA" or &
			upper(gs_empresa) = "CANTABRIA" or &
			gnvo_app.of_get_parametro("ALM_MOV_ALMACEN_MITAD_HOJA_PREVIEW", "0") = "1" then
			
			dw_report.Object.DataWindow.Print.Paper.Size = 256 
			dw_report.Object.DataWindow.Print.CustomPage.Width = 210
			dw_report.Object.DataWindow.Print.CustomPage.Length = 138
			
		else
			dw_report.object.datawindow.print.Paper.Size = 1 //Letter	
		end if
		
		//Coloco la firma
		if dw_report.RowCount() > 0 then
			if dw_report.of_ExistsPictureName("p_firma") then
				ls_cod_usr = dw_report.Object.cod_usr [1]
				
				ls_firma_digital = gnvo_app.logistica.of_get_firma_usuario(gs_inifile, ls_cod_usr)
				
				// Coloco la firma escaneada del representante 
				if ls_firma_digital <> "" then
				
					if Not FileExists(ls_firma_digital) then
						MessageBox('Error', 'No existe el archivo ' + ls_firma_digital + ", por favor verifique!!", StopSign!)
						//return
					else
						dw_report.object.p_firma.filename = ls_firma_digital	
					end if
					
				end if
				
				
			end if
			
			//Ahora coloco la firma del jefe de almacen
			if dw_report.of_ExistsPictureName("p_jefe") then
				ls_tipo_mov = dw_report.Object.tipo_mov [1]
				
				if left(ls_tipo_mov, 1) = 'I' or &
					(left(ls_tipo_mov, 1) = 'S' and gnvo_app.of_get_parametro("FIRMAS_VALES_SALIDA", "1") = "1")  then
					
					ls_firma_digital = gnvo_app.almacen.of_get_firma_autorizado(gs_inifile, ls_cod_usr)
					
					//ls_firma_digital  = ProfileString (gs_inifile, "Firma_digital_" + gs_empresa, "jefe_almacen", "")
					
					// Coloco la firma escaneada del representante 
					if ls_firma_digital <> "" then
						
						if Not FileExists(ls_firma_digital) then
							MessageBox('Error', 'No existe el archivo ' + ls_firma_digital + ", por favor verifique!!", StopSign!)
							//return
						else
							dw_report.object.p_jefe.filename = ls_firma_digital	
						end if
						
					end if
					
				end if
				
				
			end if
		end if
	
	elseif istr_rep.dw1 = "d_rpt_bol_cobrar_servimotor_ff" then
		
		if upper(gs_empresa) = 'SERVIMOTOR' then
			dw_report.Object.DataWindow.Print.Paper.Size = 256 
			dw_report.Object.DataWindow.Print.CustomPage.Width = 230
			dw_report.Object.DataWindow.Print.CustomPage.Length = 202
		end if
		
	elseif istr_rep.dw1 = "d_rpt_recibo_caja_tbl" then
		
		dw_report.Object.DataWindow.Print.Paper.Size = 256 
		dw_report.Object.DataWindow.Print.CustomPage.Width = 165
		dw_report.Object.DataWindow.Print.CustomPage.Length = 90
		dw_report.object.datawindow.print.Orientation = 2
	
	else
		if istr_rep.paper_size > 0 then
			dw_report.object.datawindow.print.Paper.Size = istr_rep.paper_size
		else
			dw_report.object.datawindow.print.Paper.Size = 9 //A-4
		end if
	end if
	
	if ls_inifile <> '' and Not isnull(ls_inifile) then
		of_modify_dw(dw_report, ls_inifile)
	end if
	
	if istr_rep.orientacion <> '' then
		dw_report.object.datawindow.print.Orientation	= istr_rep.orientacion
	end if
	
	if istr_rep.posicion_paper <> 0 then
		dw_report.object.datawindow.print.Orientation = istr_rep.posicion_paper 
	end if
	

	dw_report.Visible = True
	
	//Tomo el preview
	if istr_rep.b_preview then
		ib_preview = false
	else
		ib_preview = true
	end if
	
	event ue_preview()
	
catch ( Exception ex)
	
	gnvo_app.of_catch_exception(ex, "Excepcion en w_rpt_preview")
	
finally
	
end try




end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

event close;call super::close;destroy invo_codeqr
end event

type dw_report from w_report_smpl`dw_report within w_rpt_preview
integer x = 0
integer y = 0
integer width = 2519
integer height = 1624
boolean hsplitscroll = true
end type

