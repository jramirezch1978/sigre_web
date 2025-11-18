$PBExportHeader$w_cm913_importar_fotos.srw
forward
global type w_cm913_importar_fotos from w_abc_master_smpl
end type
type hpb_progreso from hprogressbar within w_cm913_importar_fotos
end type
type st_texto from statictext within w_cm913_importar_fotos
end type
type rb_1 from radiobutton within w_cm913_importar_fotos
end type
type st_1 from statictext within w_cm913_importar_fotos
end type
type sle_path from singlelineedit within w_cm913_importar_fotos
end type
type cb_path from commandbutton within w_cm913_importar_fotos
end type
type st_2 from statictext within w_cm913_importar_fotos
end type
type st_3 from statictext within w_cm913_importar_fotos
end type
type cb_procesar from commandbutton within w_cm913_importar_fotos
end type
type lb_files from listbox within w_cm913_importar_fotos
end type
type st_4 from statictext within w_cm913_importar_fotos
end type
type st_5 from statictext within w_cm913_importar_fotos
end type
type p_foto from picture within w_cm913_importar_fotos
end type
type pb_resize from picturebutton within w_cm913_importar_fotos
end type
end forward

global type w_cm913_importar_fotos from w_abc_master_smpl
integer width = 3342
integer height = 2584
string title = "[CM913] Importar Fotos de Artículos"
string menuname = "m_salir"
event type integer ue_metodo_f1 ( )
event type integer ue_listar_data_f2 ( string as_file )
event type integer ue_listar_data_f3 ( string as_file )
event type integer ue_listar_data_f4 ( string as_file )
hpb_progreso hpb_progreso
st_texto st_texto
rb_1 rb_1
st_1 st_1
sle_path sle_path
cb_path cb_path
st_2 st_2
st_3 st_3
cb_procesar cb_procesar
lb_files lb_files
st_4 st_4
st_5 st_5
p_foto p_foto
pb_resize pb_resize
end type
global w_cm913_importar_fotos w_cm913_importar_fotos

type variables
boolean				lb_maximized = false
integer 				ii_year
n_cst_utilitario 	invo_util
u_ds_base			ids_articulos
end variables

forward prototypes
public function boolean of_update_mov_almacen (string as_desc_almacen, string as_cod_art, decimal adc_stock, decimal adc_costo, long al_row)
public function boolean of_imagen_file (long al_index)
end prototypes

event type integer ue_metodo_f1();//Datos para importar
String	ls_cod_art, ls_desc_categoria, ls_desc_subcategoria, ls_desc_art, ls_und, &
			ls_cod_marca, ls_nom_marca, ls_cod_sku, ls_cod_sub_linea, ls_cod_acabado, &
			ls_color1, ls_color2, ls_cod_taco, ls_estilo, ls_flag_genero, ls_file_imagen
			
Decimal	ldc_talla

Long		ll_i, ll_row, ll_j

blob		lblb_imagen

/*
	select a.cod_art,
			 a1.desc_categoria, a2.desc_sub_cat,
			 a.desc_art,
			 a.und,
			 a.cod_marca,
			 m.nom_marca,
			 a.cod_sku,
			 a.cod_sub_linea,
			 a.cod_acabado,
			 a.color1,
			 a.color2,
			 a.cod_taco,
			 a.talla,
			 a.estilo,
			 a.flag_genero,
			 a.talla
	from articulo a,
		  articulo_sub_categ a2,
		  articulo_categ     a1,
		  marca              m
	where a.sub_cat_art = a2.cod_sub_cat
	  and a2.cat_art    = a1.cat_art
	  and a.cod_marca   = m.cod_marca
	  and a.cod_sku = '041054'
*/


try 
	
	dw_master.reset()
	
	if lb_files.TotalItems() = 0 then 
		MessageBox('Error', 'No hay archivos de fotos para procesar, por favor verique!', StopSign!)
		return -1
	end if
	
	hpb_progreso.Position = 0
	 
	for ll_i = 1 to lb_files.TotalItems()
		yield()
		
		//Obtengo el archivo imagen
		ls_file_imagen = lb_files.Text(ll_i)
		
		//Pongo el mensaje de avance
		setMicroHelp('Procesando Imagen: ' + ls_file_imagen + ' ... ' &
			+ string(ll_i / lb_files.TotalItems() * 100, '###,##0.00'))
		
		//Leo la imagen
		lblb_imagen = invo_util.of_load_blob(sle_path.text + '\' + ls_file_imagen)
		
		if ISNull(lblb_imagen) then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_i, "ue_metodo_f1", this.ClassName(), &
				'Error, no se ha podido leer el archivo ' + ls_file_imagen &
				+ ' para convertirlo en blob, en el registro: ' + string(ll_i))
			continue
		end if
		
		//Obtengo el codigo SKU
		ls_cod_sku = left(ls_file_imagen, LastPos(ls_file_imagen, '.') - 1)
		
		//Busco el artículo por el SKU
		select 	a.cod_art,
       			a1.desc_categoria, 
					a2.desc_sub_cat,
       			a.desc_art,
       			a.und,
       			a.cod_marca,
       			m.nom_marca,
       			a.cod_sub_linea,
       			a.cod_acabado,
       			a.color1,
       			a.color2,
       			a.cod_taco,
       			a.estilo,
       			a.flag_genero,
       			a.talla
			into	:ls_cod_art,
					:ls_desc_categoria,
					:ls_desc_subcategoria,
					:ls_Desc_art,
					:ls_und,
					:ls_cod_marca, 
					:ls_nom_marca,
					:ls_cod_sub_linea,
					:ls_cod_acabado,
					:ls_color1,
					:ls_color2,
					:ls_cod_taco,
					:ls_estilo,
					:ls_flag_genero,
					:ldc_talla
		from articulo a,
			  articulo_sub_categ a2,
			  articulo_categ     a1,
			  marca              m
		where a.sub_cat_art 	= a2.cod_sub_cat
		  and a2.cat_art    	= a1.cat_art
		  and a.cod_marca   	= m.cod_marca
		  and a.cod_sku 		= :ls_cod_sku;
		
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_i, "ue_metodo_f1", this.ClassName(), &
				'Error, no existe cod_sku ' + ls_cod_sku + ' en el registro: ' + string(ll_i))
			continue
		end if
		
		//Actualizo el blob en el registro
		updateBLOB articulo 
			set imagen	= :lblb_imagen
		where cod_art = :ls_cod_art;

		/*En caso hubiera error*/ 
		IF SQLCA.SQLCode = -1 THEN
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_i, "ue_metodo_f1", this.ClassName(), &
				'Ha ocurrido un error al tratar de actualizar la foto en tabla ARTICULO, cod_art: ' &
				+ ls_cod_art + ', nro registro: ' + string(ll_i))
			continue
		end if
		
		//Inserto el registro que se ha actualizado
		ll_row = dw_master.event ue_insert()
		
		if ll_row > 0 then
			dw_master.object.cod_art 			[ll_row] = ls_cod_art
			dw_master.object.desc_categoria 	[ll_row] = ls_desc_categoria
			dw_master.object.desc_sub_cat 	[ll_row] = ls_desc_subcategoria
			dw_master.object.desc_art	 		[ll_row] = ls_desc_art
			dw_master.object.und 				[ll_row] = ls_und
			dw_master.object.cod_sku 			[ll_row] = ls_cod_sku
			dw_master.object.cod_marca 		[ll_row] = ls_cod_marca
			dw_master.object.nom_marca 		[ll_row] = ls_nom_marca
			dw_master.object.cod_sub_linea 	[ll_row] = ls_cod_sub_linea
			dw_master.object.cod_acabado 		[ll_row] = ls_cod_acabado
			dw_master.object.color1 			[ll_row] = ls_color1
			dw_master.object.color2 			[ll_row] = ls_color2
			dw_master.object.cod_taco 			[ll_row] = ls_cod_taco
			dw_master.object.estilo 			[ll_row] = ls_estilo
			dw_master.object.flag_genero 		[ll_row] = ls_flag_genero
			dw_master.object.talla 				[ll_row] = ldc_talla
		end if
		
		yield()
		st_texto.text = string(dw_master.RowCount(), '###,##0') + ' filas'
		yield()
		
		//Actualizo los articulos similares
		ids_articulos.Retrieve(ls_cod_art, 			&
									  ls_cod_sub_linea, 	&
									  ls_cod_acabado, 	&
									  ls_cod_taco, 		&
									  ls_color1, 			&
									  ls_color2, 			&
									  ls_estilo, 			&
									  ls_flag_genero, 	&
									  ls_cod_marca)
		
		for ll_j = 1 to ids_articulos.RowCount()
			
			yield()

			ls_cod_art = ids_articulos.object.cod_art [ll_j]
			
			//Actualizo el blob en el registro
			updateBLOB articulo 
				set imagen	= :lblb_imagen
			where cod_art = :ls_cod_art;
	
			/*En caso hubiera error*/ 
			IF SQLCA.SQLCode = -1 THEN
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_i, "ue_metodo_f1", this.ClassName(), &
					'Ha ocurrido un error al tratar de actualizar la foto en tabla ARTICULO, cod_art: ' &
					+ ls_cod_art + ', nro registro de articulos similares: ' + string(ll_j))
				continue
			end if	

			//Inserto el registro que se ha actualizado
			ll_row = dw_master.event ue_insert()
			
			if ll_row > 0 then
				dw_master.object.cod_art 			[ll_row] = ids_articulos.object.cod_art 			[ll_j]
				dw_master.object.desc_categoria 	[ll_row] = ids_articulos.object.desc_categoria 	[ll_j]
				dw_master.object.desc_sub_cat 	[ll_row] = ids_articulos.object.desc_sub_cat 	[ll_j]
				dw_master.object.desc_art	 		[ll_row] = ids_articulos.object.desc_art 			[ll_j]
				dw_master.object.und 				[ll_row] = ids_articulos.object.und 				[ll_j]
				dw_master.object.cod_sku 			[ll_row] = ids_articulos.object.cod_sku 			[ll_j]
				dw_master.object.cod_marca 		[ll_row] = ids_articulos.object.cod_marca 		[ll_j]
				dw_master.object.nom_marca 		[ll_row] = ids_articulos.object.nom_marca 		[ll_j]
				dw_master.object.cod_sub_linea 	[ll_row] = ids_articulos.object.cod_sub_linea 	[ll_j]
				dw_master.object.cod_acabado 		[ll_row] = ids_articulos.object.cod_acabado 		[ll_j]
				dw_master.object.color1 			[ll_row] = ids_articulos.object.color1 			[ll_j]
				dw_master.object.color2 			[ll_row] = ids_articulos.object.color2 			[ll_j]
				dw_master.object.cod_taco 			[ll_row] = ids_articulos.object.cod_taco 			[ll_j]
				dw_master.object.estilo 			[ll_row] = ids_articulos.object.estilo 			[ll_j]
				dw_master.object.flag_genero 		[ll_row] = ids_articulos.object.flag_genero 		[ll_j]
				dw_master.object.talla 				[ll_row] = ids_articulos.object.talla 				[ll_j]
			end if
			
			yield()
			st_texto.text = string(dw_master.RowCount(), '###,##0') + ' filas'
			yield()

			
			
		next
	
		//Actualizo la barra de progreso
		hpb_progreso.Position = ll_i / lb_files.TotalItems() * 100
		
		yield()
  
	next
	
	commit;
	
	st_texto.text = string(dw_master.RowCount(), '###,##0') + ' filas'
	
	RETURN 1
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
end try

end event

event type integer ue_listar_data_f2(string as_file);oleobject excel
integer	li_i
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila2, &
			ll_fila, ll_year, ll_mes
double 	dbl_precio
boolean 	lb_cek
String 	 ls_nomcol, ls_codigo, ls_mensaje

oleobject  lole_workbook, lole_worksheet

//Datos para importar
String	ls_desc_categoria, ls_desc_sub_categ, ls_desc_art, ls_und, ls_nom_marca, &
			ls_precio_vta_und, ls_precio_vta_may, ls_precio_vta_min

//Codigos
String	ls_cod_categ, ls_cod_sub_categ, ls_cod_marca, ls_cod_art
			
Decimal	ldc_precio_vta_und, ldc_precio_vta_may, ldc_precio_vta_min

try 
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		messagebox('Excel','El archivo ' + as_file + ' no existe. Por favor verifique!', StopSign!) 
		destroy excel
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o cnfigurado el MS.Excel, por favor verifique!',exclamation!)
		destroy excel
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook = excel.workbooks(1)
	lb_cek = lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   = lole_worksheet.UsedRange.Rows.Count
	dw_master.reset( )
	
	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_desc_categoria		= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_desc_sub_categ		= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_desc_art				= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_und					= String(lole_worksheet.cells(ll_fila1,4).value)
		ls_nom_marca			= String(lole_worksheet.cells(ll_fila1,5).value)  
		ls_precio_vta_und		= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_precio_vta_may		= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_precio_vta_min		= String(lole_worksheet.cells(ll_fila1,6).value) 
		
		
		//Valido que tenga categoría y subcategoría
		if IsNull(ls_desc_categoria) or trim(ls_desc_categoria) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f2", this.ClassName(), &
				'Error, no existe categoría en el registro ' + string(ll_fila1))
			continue
		end if
	
		if IsNull(ls_und) or trim(ls_und) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f2", this.ClassName(), &
				'Error, no ha especificado unidad en el registro ' + string(ll_fila1))
			continue
		end if
		
		//Verifico que todos los textos estan en las tablas
		//Categoría
		select count(*)
			into :ll_count
		from articulo_categ
		where upper(trim(DESC_CATEGORIA)) = trim(upper(:ls_desc_categoria));
		
		if ll_count > 0 then
			select CAT_ART
				into :ls_cod_categ
			from articulo_categ
			where upper(trim(DESC_CATEGORIA)) = trim(upper(:ls_desc_categoria));
		else
			select max(CAT_ART)
				into :ls_cod_categ
			from articulo_categ;
			
			if ISNull(ls_cod_Categ) or ls_Cod_categ = '' then
				ls_cod_categ = '001'
			else
				ls_cod_categ = trim(string(Long(ls_cod_categ) + 1, '000'))
			end if
			
			insert into articulo_categ(
				CAT_ART, DESC_CATEGORIA, FLAG_SERVICIO, FLAG_ESTADO)
			values(
				:ls_cod_categ, :ls_desc_categoria, '0', '1');
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f2", this.ClassName(), &
					'Error al insertar en tabla articulo_categ. Mensaje: ' + ls_mensaje)
				continue
			end if
			
		end if
		
		//Subcategoria
		select count(*)
			into :ll_count
		from articulo_sub_categ
		where upper(trim(DESC_SUB_CAT)) 	= trim(upper(:ls_desc_sub_categ))
		  and CAT_ART 							= :ls_cod_categ;
		
		if ll_count > 0 then
			select COD_SUB_CAT
				into :ls_cod_sub_categ
			from articulo_sub_categ
			where upper(trim(DESC_SUB_CAT)) 	= trim(upper(:ls_desc_sub_categ))
			  and CAT_ART 							= :ls_cod_categ;
		else
			select max(COD_SUB_CAT)
				into :ls_cod_sub_categ
			from articulo_sub_categ
			where CAT_ART 	= :ls_cod_categ;
			
			if IsNull(ls_cod_sub_categ) or trim(ls_cod_sub_categ) = '' then
				ls_cod_sub_categ = trim(ls_cod_categ) + '001'	
			else
				ls_cod_sub_categ = trim(ls_cod_categ) + trim(string( Long(mid(ls_cod_sub_categ, 5, 3)) + 1, '000'))
			end if
			
			
			//Inserto el subarticulo
			insert into articulo_sub_categ(
				COD_SUB_CAT, CAT_ART, DESC_SUB_CAT, FLAG_ESTADO)
			values(
				:ls_cod_sub_categ, :ls_cod_categ, :ls_desc_sub_categ, '1');
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f2", this.ClassName(), &
					'Error al insertar ' + ls_cod_sub_categ + ' en tabla articulo_sub_categ. Mensaje: ' + ls_mensaje)
				continue
			end if
			
		end if

		//MARCA
		select count(*)
			into :ll_count
		from marca
		where upper(trim(NOM_MARCA)) = trim(upper(:ls_nom_marca));
		
		if ll_count > 0 then
			select COD_MARCA
				into :ls_cod_marca
			from marca
			where upper(trim(NOM_MARCA)) = trim(upper(:ls_nom_marca));
		else
			select max(COD_MARCA)
				into :ls_cod_marca
			from marca;
			
			if ISNull(ls_cod_marca) or ls_cod_marca = '' then
				ls_cod_marca = '00000001'
			else
				ls_cod_marca = trim(string(Long(ls_cod_marca) + 1, '00000000'))
			end if
			
			insert into marca(
				COD_MARCA, NOM_MARCA, FLAG_ESTADO )
			values(
				:ls_cod_marca, :ls_nom_marca, '1');
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f2", this.ClassName(), &
					'Error al insertar ' + ls_cod_marca + ' en tabla marca. Mensaje: ' + ls_mensaje)
				continue
			end if
		end if
		
		
		//Transformamos las unidades correspondientes
		ldc_precio_vta_und = Dec(ls_precio_vta_und)
		ldc_precio_vta_may = Dec(ls_precio_vta_may)
		ldc_precio_vta_min = Dec(ls_precio_vta_min)
		
		//Inserto la fila en maestro de articulos
		yield()
		select count(*)
			into :ll_count
		from articulo a
		where a.SUB_CAT_ART 					= :ls_cod_sub_categ
		  and trim(upper(a.desc_art)) 	= trim(upper(:ls_desc_art))
		  and a.cod_marca						= :ls_cod_marca;
		  
		//Si el código existe entonces se continua
		if ll_count > 0 then 
			SetMicroHelp ('El articulo ' + ls_desc_art + ' ya existe, verifique!')
		else
			
			//Obtengo el siguiente codigo
			yield()
			select max(cod_art)
				into :ls_cod_art
			from articulo a
			where trim(a.SUB_CAT_ART) = trim(:ls_cod_sub_categ)
			  and length(trim(a.cod_art)) > 10;
			
			if ISNull(ls_cod_art) or ls_cod_art = '' then
				ls_cod_art = ls_cod_sub_categ + '.00001'
			else
				ls_cod_art = trim(ls_cod_sub_categ) + '.' + trim(string(Long(mid(ls_cod_art, 8, 5)) + 1, '00000'))
			end if
			
			insert into articulo(
				COD_ART, SUB_CAT_ART, DESC_ART, COD_MARCA, UND,
				PRECIO_VTA_UNIDAD, precio_vta_mayor, precio_vta_min,
				COSTO_ULT_COMPRA, COSTO_PROM_SOL, NOM_ARTICULO, flag_estado)
			values(
				:ls_cod_art, :ls_cod_sub_categ, :ls_desc_art, :ls_cod_marca, :ls_und,
				:ldc_precio_vta_und, :ldc_precio_vta_may, :ldc_precio_vta_min,
				1, 1, substr(:ls_desc_art, 1, 150), '1');
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f2", this.ClassName(), &
					'Error al insertar ' + ls_cod_art + '-' + ls_desc_art &
					+ ' en tabla ARTICULO. Registro ' + string(ll_fila1) + '. Mensaje: ' + ls_mensaje)
				
				continue
			end if
			
		end if
		
		yield()
		  
		
		//Añadir la fila
		ll_fila = dw_master.event ue_insert()
		
		if ll_fila > 0 then
			dw_master.object.desc_categoria		[ll_fila] = ls_desc_categoria
			dw_master.object.desc_sub_cat			[ll_fila] = ls_desc_sub_categ
			dw_master.object.desc_art				[ll_fila] = ls_desc_art
			dw_master.object.und						[ll_fila] = ls_und
			dw_master.object.nom_marca				[ll_fila] = ls_nom_marca
			dw_master.object.precio_vta_unidad	[ll_fila] = ldc_precio_vta_und
			dw_master.object.precio_vta_mayor	[ll_fila] = ldc_precio_vta_may
			dw_master.object.precio_vta_min		[ll_fila] = ldc_precio_vta_min
		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		yield()	
		
		//Este registro se guarda
		commit;
	next
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Se han procesado " &
		+ string(ll_fila1) + " filas por favor verifique y luego proceselo!", "")
	
	RETURN 1
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
end try

end event

event type integer ue_listar_data_f3(string as_file);oleobject excel
integer	li_i
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila2, &
			ll_fila, ll_year, ll_mes
double 	dbl_precio
boolean 	lb_cek
String 	 ls_nomcol, ls_codigo, ls_mensaje

oleobject  lole_workbook, lole_worksheet

//Datos para importar
String	ls_desc_categoria, ls_desc_sub_categ, ls_desc_art, ls_und, ls_desc_clase, &
			ls_ano_modelo, ls_ano_fabricacion, ls_nro_chasis, ls_nro_serie, ls_nro_motor, &
			ls_nro_poliza, ls_nro_dua, ls_item_dua, ls_nro_lote, ls_nom_marca, ls_desc_color, &
			ls_version, ls_desc_carroceria, ls_desc_combustible, ls_peso_bruto, ls_peso_seco, &
			ls_pasajeros, ls_asientos, ls_ejes, ls_cilindrada, ls_ancho, ls_largo, &
			ls_alto, ls_ruedas, ls_potencia, ls_formula, ls_carga_util, ls_nro_cilindros, &
			ls_desc_Clase_vehiculo, ls_stock, ls_almacen

//Codigos
String	ls_cod_categ, ls_cod_sub_categ, ls_cod_clase, ls_cod_marca, ls_cod_art, ls_cod_color, &
			ls_cod_carroceria, ls_cod_combustible, ls_cod_clase_vehiculo
			
//Parte Numerica
decimal	ldc_PESO_SECO, 	ldc_PESO_BRUTO, 	ldc_PASAJEROS, ldc_ASIENTOS, 	ldc_EJES, &
			ldc_CILINDRADA, 	ldc_ANCHO,			ldc_LARGO, 		ldc_ALTO,		ldc_RUEDAS, &
			ldc_CARGA_UTIL, 	ldc_NRO_CILINDROS


try 
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		messagebox('Excel','El archivo ' + as_file + ' no existe. Por favor verifique!', StopSign!) 
		destroy excel
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o cnfigurado el MS.Excel, por favor verifique!',exclamation!)
		destroy excel
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook = excel.workbooks(1)
	lb_cek = lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   = lole_worksheet.UsedRange.Rows.Count
	dw_master.reset( )
	
	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_desc_categoria	= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_desc_sub_categ	= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_desc_art			= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_und				= String(lole_worksheet.cells(ll_fila1,4).value)
		ls_desc_clase		= String(lole_worksheet.cells(ll_fila1,5).value)
		ls_ano_modelo		= String(lole_worksheet.cells(ll_fila1,6).value)
		ls_ano_fabricacion= String(lole_worksheet.cells(ll_fila1,7).value)
		ls_nro_Chasis		= String(lole_worksheet.cells(ll_fila1,8).value)
		ls_nro_serie		= String(lole_worksheet.cells(ll_fila1,9).value)
		ls_nro_motor		= String(lole_worksheet.cells(ll_fila1,10).value)
		ls_nro_poliza	 	= String(lole_worksheet.cells(ll_fila1,11).value)
		ls_nro_dua			= String(lole_worksheet.cells(ll_fila1,12).value)
		ls_item_dua			= String(lole_worksheet.cells(ll_fila1,13).value)
		ls_nro_lote			= String(lole_worksheet.cells(ll_fila1,14).value)
		ls_nom_marca		= String(lole_worksheet.cells(ll_fila1,15).value)
		ls_desc_color		= String(lole_worksheet.cells(ll_fila1,16).value)
		ls_version			= String(lole_worksheet.cells(ll_fila1,17).value)
		ls_desc_carroceria	= String(lole_worksheet.cells(ll_fila1,18).value)
		ls_desc_combustible	= String(lole_worksheet.cells(ll_fila1,19).value)
		ls_peso_bruto			= String(lole_worksheet.cells(ll_fila1,20).value)
		ls_peso_seco			= String(lole_worksheet.cells(ll_fila1,21).value)
		ls_pasajeros			= String(lole_worksheet.cells(ll_fila1,22).value)
		ls_asientos				= String(lole_worksheet.cells(ll_fila1,23).value)
		ls_ejes					= String(lole_worksheet.cells(ll_fila1,24).value)
		ls_cilindrada			= String(lole_worksheet.cells(ll_fila1,25).value)
		ls_ancho					= String(lole_worksheet.cells(ll_fila1,26).value)
		ls_largo					= String(lole_worksheet.cells(ll_fila1,27).value)
		ls_alto					= String(lole_worksheet.cells(ll_fila1,28).value)
		ls_ruedas				= String(lole_worksheet.cells(ll_fila1,29).value)
		ls_potencia				= String(lole_worksheet.cells(ll_fila1,30).value)
		ls_formula				= String(lole_worksheet.cells(ll_fila1,31).value)
		ls_carga_util			= String(lole_worksheet.cells(ll_fila1,32).value)
		ls_nro_cilindros			= String(lole_worksheet.cells(ll_fila1,33).value)
		ls_desc_clase_vehiculo	= String(lole_worksheet.cells(ll_fila1,34).value)
		ls_almacen					= String(lole_worksheet.cells(ll_fila1,35).value)
		ls_stock						= String(lole_worksheet.cells(ll_fila1,36).value)
		
		//Descripcion de categoria
		if IsNull(ls_desc_categoria) or trim(ls_desc_categoria) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
				'Error, no existe categoría en el registro ' + string(ll_fila1))
			continue
		end if
	
		if IsNull(ls_desc_sub_categ) or trim(ls_desc_sub_categ) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
				'Error, no existe SUBCATEGORIA en el registro ' + string(ll_fila1))
			continue
		end if

		if IsNull(ls_und) or trim(ls_und) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
				'Error, no ha especificado unidad en el registro ' + string(ll_fila1))
			continue
		end if
		
		//Verifico que todos los textos estan en las tablas
		//Categoría
		select count(*)
			into :ll_count
		from articulo_categ
		where upper(trim(DESC_CATEGORIA)) = trim(upper(:ls_desc_categoria));
		
		if ll_count > 0 then
			select CAT_ART
				into :ls_cod_categ
			from articulo_categ
			where upper(trim(DESC_CATEGORIA)) = trim(upper(:ls_desc_categoria));
		else
			select max(CAT_ART)
				into :ls_cod_categ
			from articulo_categ
			where (cat_Art like '0%' or cat_Art like '1%');
			
			if ISNull(ls_cod_Categ) or ls_Cod_categ = '' then
				ls_cod_categ = '001'
			else
				ls_cod_categ = trim(string(Long(ls_cod_categ) + 1, '000'))
			end if
			
			insert into articulo_categ(
				CAT_ART, DESC_CATEGORIA, FLAG_SERVICIO, FLAG_ESTADO)
			values(
				:ls_cod_categ, :ls_desc_categoria, '0', '1');
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
					'Error al insertar en tabla articulo_categ. Mensaje: ' + ls_mensaje)
				continue
			end if
		end if
		
		//CLASE
		select count(*)
			into :ll_count
		from articulo_clase
		where upper(trim(DESC_CLASE)) = trim(upper(:ls_desc_clase));
		
		if ll_count > 0 then
			select COD_CLASE
				into :ls_Cod_clase
			from articulo_clase
			where upper(trim(DESC_CLASE)) = trim(upper(:ls_desc_clase));
		else
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
				'No existe la clase de articulo ' + ls_desc_clase + ', por favor corrija y vuelva a intentarlo')
			return -1
		end if

		/*
		Datos necesarios para ingresar la subcategoria
		----------------------------------------------
		
		COD_MARCA          CHAR(8)      Y                Marca                       
		COD_CARROCERIA     VARCHAR2(3)  Y                Tipo de Carroceria          
		COD_COMB           VARCHAR2(3)  Y                Tipo de Combustible         
		COD_COLOR          CHAR(3)      Y                Color                       
		COD_CLASE_VEHICULO CHAR(8)      Y                Clase de Vehiculo (MTC)     
		COD_CATEG_VEHICULO CHAR(8)      Y                Categoria de Vehiculo (MTC) 
		COD_MODELO         CHAR(15)     Y                                            

		VERSION            VARCHAR2(20) Y                Version                     
		PESO_SECO          NUMBER(10,4) Y                Peso Seco                   
		PESO_BRUTO         NUMBER(10,4) Y                Peso bruto                  
		PASAJEROS          NUMBER       Y                Numero de Pasajeros         
		ASIENTOS           NUMBER       Y                Numero de Asientos          
		EJES               NUMBER       Y                Numero de Ejes              
		CILINDRADA         NUMBER(10,4) Y                Cilindrada                  
		ANCHO              NUMBER(10,4) Y                Ancho                       
		LARGO              NUMBER(10,4) Y                Largo                       
		ALTO               NUMBER(10,4) Y                Alto                        
		RUEDAS             NUMBER       Y                Numero de ruedas            
		POTENCIA           VARCHAR2(50) Y                Potencia                    
		FORMULA            VARCHAR2(20) Y                Formula                     
		CARGA_UTIL         NUMBER(10,4) Y                Carga util                  
		NRO_CILINDROS      NUMBER       Y                Numero de Cilindros         
		
		*/
		
		//MARCA
		if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
			select count(*)
				into :ll_count
			from marca
			where upper(trim(NOM_MARCA)) = trim(upper(:ls_nom_marca));
			
			if ll_count > 0 then
				select COD_MARCA
					into :ls_cod_marca
				from marca
				where upper(trim(NOM_MARCA)) = trim(upper(:ls_nom_marca));
			else
				select max(COD_MARCA)
					into :ls_cod_marca
				from marca
				where cod_marca like '0%';
				
				if ISNull(ls_cod_marca) or ls_cod_marca = '' then
					ls_cod_marca = '00000001'
				else
					ls_cod_marca = trim(string(Long(ls_cod_marca) + 1, '00000000'))
				end if
				
				insert into marca(
					COD_MARCA, NOM_MARCA, FLAG_ESTADO )
				values(
					:ls_cod_marca, :ls_nom_marca, '1');
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
						'Error al insertar ' + ls_cod_marca + ' en tabla marca. Mensaje: ' + ls_mensaje)
					continue
				end if
			end if
		else
			SetNull(ls_cod_marca)
		end if

		//CARROCERIA
		if not IsNull(ls_Desc_carroceria) and trim(ls_Desc_carroceria) <> '' then
			select count(*)
				into :ll_count
			from tipo_carroceria
			where upper(trim(CARROCERIA_DESC)) = trim(upper(:ls_Desc_carroceria));
			
			if ll_count > 0 then
				select COD_CARROCERIA
					into :ls_cod_carroceria
				from tipo_carroceria
				where upper(trim(CARROCERIA_DESC)) = trim(upper(:ls_Desc_carroceria));
			else
				select max(COD_CARROCERIA)
					into :ls_cod_carroceria
				from tipo_carroceria;
				
				if ISNull(ls_cod_carroceria) or ls_cod_carroceria = '' then
					ls_cod_carroceria = '001'
				else
					ls_cod_carroceria = trim(string(Long(ls_cod_carroceria) + 1, '000'))
				end if
				
				insert into tipo_carroceria(
					COD_CARROCERIA, CARROCERIA_DESC, FLAG_ESTADO, CREATE_BY, FEC_REGISTRO)
				values(
					:ls_cod_carroceria, :ls_Desc_carroceria, '1', :gs_user, sysdate);
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
						'Error al insertar ' + ls_cod_carroceria + ' en tabla tipo_carroceria. Mensaje: ' + ls_mensaje)
					continue
				end if
			end if
		else
			SetNull(ls_cod_carroceria)
		end if
		
		//COLOR 
		if not IsNull(ls_desc_color) and trim(ls_desc_color) <> '' then
			select count(*)
				into :ll_count
			from color
			where upper(trim(DESCRIPCION)) = trim(upper(:ls_desc_color));
			
			if ll_count > 0 then
				select COLOR
					into :ls_cod_color
				from color
				where upper(trim(DESCRIPCION)) = trim(upper(:ls_desc_color));
			else
				select max(COLOR)
					into :ls_cod_color
				from color
				where (color like '0%' or color like '1%' or color like '2%');
				
				if ISNull(ls_cod_color) or ls_cod_color = '' then
					ls_cod_color = '001'
				else
					ls_cod_color = trim(string(Long(ls_cod_color) + 1, '000'))
				end if
				
				insert into color(
					COLOR, DESCRIPCION)
				values(
					:ls_cod_color, :ls_desc_color);
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
						'Error al insertar ' + ls_cod_color + + '-' + ls_desc_color + ' en tabla color. Mensaje: ' + ls_mensaje)
					continue
				end if
			end if
		else
			SetNull(ls_cod_color)
		end if
		
		//COMBUSTIBLE
		if not IsNull(ls_desc_combustible) and trim(ls_desc_combustible) <> '' then
			select count(*)
				into :ll_count
			from tipo_combustible
			where upper(trim(COMB_DESC)) = trim(upper(:ls_desc_combustible));

			if ll_count > 0 then
				select COD_COMB
					into :ls_cod_combustible
				from tipo_combustible
				where upper(trim(COMB_DESC)) = trim(upper(:ls_desc_combustible));
			else
				select max(COD_COMB)
					into :ls_cod_combustible
				from tipo_combustible;
				
				if ISNull(ls_cod_combustible) or ls_cod_combustible = '' then
					ls_cod_combustible = '001'
				else
					ls_cod_combustible = trim(string(Long(ls_cod_combustible) + 1, '000'))
				end if
				
				insert into tipo_combustible(
					COD_COMB, COMB_DESC, FLAG_ESTADO,  CREATED_BY, FECHA_REGISTRO)
				values(
					:ls_cod_combustible, :ls_desc_combustible, '1', :gs_user, sysdate);
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
						'Error al insertar ' + ls_cod_combustible + ' en tabla tipo_combustible. Mensaje: ' + ls_mensaje)
					continue
				end if
			end if
		else
			SetNull(ls_cod_combustible)
		end if

		//CLASE VEHICULO
		if not IsNull(ls_desc_clase_vehiculo) and trim(ls_desc_clase_vehiculo) <> '' then
			select count(*)
				into :ll_count
			from clase_vehiculo
			where upper(trim(DESC_CLASE_VEHICULO)) = trim(upper(:ls_desc_clase_vehiculo));

			if ll_count > 0 then
				select COD_CLASE_VEHICULO
					into :ls_cod_clase_vehiculo
				from clase_vehiculo
				where upper(trim(DESC_CLASE_VEHICULO)) = trim(upper(:ls_desc_clase_vehiculo));
			else
				select max(COD_CLASE_VEHICULO)
					into :ls_cod_clase_vehiculo
				from clase_vehiculo
				where cod_Clase_vehiculo like '000%';
				
				if ISNull(ls_cod_clase_vehiculo) or ls_cod_clase_vehiculo = '' then
					ls_cod_clase_vehiculo = '00000001'
				else
					ls_cod_clase_vehiculo = trim(string(Long(ls_cod_clase_vehiculo) + 1, '00000000'))
				end if
				
				insert into clase_vehiculo(
					COD_CLASE_VEHICULO, DESC_CLASE_VEHICULO, FLAG_ESTADO)
				values(
					:ls_cod_clase_vehiculo, :ls_desc_clase_vehiculo, '1');
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
						'Error al insertar ' + ls_cod_clase_vehiculo + ' ' + ls_desc_clase_vehiculo + ' en tabla clase_vehiculo. Mensaje: ' + ls_mensaje)
					continue
				end if
			end if
		else
			SetNull(ls_cod_clase_vehiculo)
		end if
		
		if IsNull(ls_peso_seco) or trim(ls_peso_seco) = '' then
			SetNull(ldc_PESO_SECO)
		else
			ldc_PESO_SECO = Dec(ls_peso_seco)
		end if
		
		if IsNull(ls_peso_bruto) or trim(ls_peso_bruto) = '' then
			SetNull(ldc_PESO_BRUTO)
		else
			ldc_PESO_BRUTO = Dec(ls_peso_bruto)
		end if
		
		if IsNull(ls_pasajeros) or trim(ls_pasajeros) = '' then
			SetNull(ldc_PASAJEROS)
		else
			ldc_PASAJEROS = Dec(ls_pasajeros)
		end if

		if IsNull(ls_asientos) or trim(ls_asientos) = '' then
			SetNull(ldc_ASIENTOS)
		else
			ldc_ASIENTOS = Dec(ls_asientos)
		end if

		if IsNull(ls_ejes) or trim(ls_ejes) = '' then
			SetNull(ldc_EJES)
		else
			ldc_EJES = Dec(ls_ejes)
		end if

		if IsNull(ls_cilindrada) or trim(ls_cilindrada) = '' then
			SetNull(ldc_CILINDRADA)
		else
			ldc_CILINDRADA = Dec(ls_cilindrada)
		end if

		if IsNull(ls_ancho) or trim(ls_ancho) = '' then
			SetNull(ldc_ANCHO)
		else
			ldc_ANCHO = Dec(ls_ancho)
		end if

		if IsNull(ls_largo) or trim(ls_largo) = '' then
			SetNull(ldc_LARGO)
		else
			ldc_LARGO = Dec(ls_largo)
		end if

		if IsNull(ls_ruedas) or trim(ls_ruedas) = '' then
			SetNull(ldc_RUEDAS)
		else
			ldc_RUEDAS = Dec(ls_ruedas)
		end if

		if IsNull(ls_alto) or trim(ls_alto) = '' then
			SetNull(ldc_ALTO)
		else
			ldc_ALTO = Dec(ls_alto)
		end if

		if IsNull(ls_carga_util) or trim(ls_carga_util) = '' then
			SetNull(ldc_CARGA_UTIL)
		else
			ldc_CARGA_UTIL = Dec(ls_carga_util)
		end if

		if IsNull(ls_nro_cilindros) or trim(ls_nro_cilindros) = '' then
			SetNull(ldc_NRO_CILINDROS)
		else
			ldc_NRO_CILINDROS = Dec(ls_nro_cilindros)
		end if

		
		//Subcategoria
		select count(*)
			into :ll_count
		from articulo_sub_categ
		where upper(trim(DESC_SUB_CAT)) 		= trim(upper(:ls_desc_sub_categ))
		  and CAT_ART 								= :ls_cod_categ
		  and NVL(COD_MARCA, 'XX')				= NVL(:ls_cod_marca, 'XX')
		  and NVL(COD_CARROCERIA, 'XX')		= NVL(:ls_cod_carroceria, 'XX')
		  and NVL(COD_COMB, 'XX')				= NVL(:ls_cod_combustible, 'XX')
		  and NVL(COD_COLOR, 'XX')				= NVL(:ls_cod_color, 'XX')
		  and NVL(COD_CLASE_VEHICULO, 'XX')	= NVL(:ls_cod_clase_vehiculo, 'XX')
		  and NVL(VERSION, 'XX')				= NVL(:ls_version, 'XX')
		  and NVL(POTENCIA, 'XX')				= NVL(:ls_potencia, 'XX')
		  and NVL(FORMULA, 'XX')				= NVL(:ls_formula, 'XX')
		  and NVL(PESO_SECO, 0)					= NVL(:ldc_peso_seco, 0)
		  and NVL(PESO_BRUTO, 0)				= NVL(:ldc_peso_bruto, 0)
		  and NVL(PASAJEROS, 0)					= NVL(:ldc_pasajeros, 0)
		  and NVL(ASIENTOS, 0)					= NVL(:ldc_asientos, 0)
		  and NVL(EJES, 0)						= NVL(:ldc_ejes, 0)
		  and NVL(CILINDRADA, 0)				= NVL(:ldc_cilindrada, 0)
		  and NVL(ANCHO, 0)						= NVL(:ldc_ancho, 0)
		  and NVL(LARGO, 0)						= NVL(:ldc_largo, 0)
		  and NVL(ALTO, 0)						= NVL(:ldc_alto, 0)
		  and NVL(RUEDAS, 0)						= NVL(:ldc_ruedas, 0)
		  and NVL(CARGA_UTIL, 0)				= NVL(:ldc_carga_util, 0)
		  and NVL(NRO_CILINDROS, 0)			= NVL(:ldc_nro_cilindros, 0);
		  
		if ll_count > 0 then
			
			select COD_SUB_CAT
				into :ls_cod_sub_categ
			from articulo_sub_categ
			where upper(trim(DESC_SUB_CAT)) 		= trim(upper(:ls_desc_sub_categ))
			  and CAT_ART 								= :ls_cod_categ
			  and NVL(COD_MARCA, 'XX')				= NVL(:ls_cod_marca, 'XX')
			  and NVL(COD_CARROCERIA, 'XX')		= NVL(:ls_cod_carroceria, 'XX')
			  and NVL(COD_COMB, 'XX')				= NVL(:ls_cod_combustible, 'XX')
			  and NVL(COD_COLOR, 'XX')				= NVL(:ls_cod_color, 'XX')
			  and NVL(COD_CLASE_VEHICULO, 'XX')	= NVL(:ls_cod_clase_vehiculo, 'XX')
			  and NVL(VERSION, 'XX')				= NVL(:ls_version, 'XX')
			  and NVL(POTENCIA, 'XX')				= NVL(:ls_potencia, 'XX')
			  and NVL(FORMULA, 'XX')				= NVL(:ls_formula, 'XX')
			  and NVL(PESO_SECO, 0)					= NVL(:ldc_peso_seco, 0)
			  and NVL(PESO_BRUTO, 0)				= NVL(:ldc_peso_bruto, 0)
			  and NVL(PASAJEROS, 0)					= NVL(:ldc_pasajeros, 0)
			  and NVL(ASIENTOS, 0)					= NVL(:ldc_asientos, 0)
			  and NVL(EJES, 0)						= NVL(:ldc_ejes, 0)
			  and NVL(CILINDRADA, 0)				= NVL(:ldc_cilindrada, 0)
			  and NVL(ANCHO, 0)						= NVL(:ldc_ancho, 0)
			  and NVL(LARGO, 0)						= NVL(:ldc_largo, 0)
			  and NVL(ALTO, 0)						= NVL(:ldc_alto, 0)
			  and NVL(RUEDAS, 0)						= NVL(:ldc_ruedas, 0)
			  and NVL(CARGA_UTIL, 0)				= NVL(:ldc_carga_util, 0)
			  and NVL(NRO_CILINDROS, 0)			= NVL(:ldc_nro_cilindros, 0);
			  
		else
			
			select max(COD_SUB_CAT)
				into :ls_cod_sub_categ
			from articulo_sub_categ
			where CAT_ART 	= :ls_cod_categ;
			
			if IsNull(ls_cod_sub_categ) or trim(ls_cod_sub_categ) = '' then
				ls_cod_sub_categ = trim(ls_cod_categ) + '001'	
			else
				ls_cod_sub_categ = trim(ls_cod_categ) + trim(string( Long(mid(ls_cod_sub_categ, 5, 3)) + 1, '000'))
			end if
			
			
			//Inserto el subarticulo
			insert into articulo_sub_categ(
				COD_SUB_CAT, CAT_ART, DESC_SUB_CAT, FLAG_ESTADO, 
				COD_MARCA,
				COD_CARROCERIA,
				COD_COMB,
				COD_COLOR,
				COD_CLASE_VEHICULO,
				VERSION,
				PESO_SECO,
				PESO_BRUTO,
				PASAJEROS,
				ASIENTOS,
				EJES,
				CILINDRADA,
				ANCHO,
				LARGO,
				ALTO,
				RUEDAS,
				POTENCIA,
				FORMULA,
				CARGA_UTIL,
				NRO_CILINDROS
			)
			values(
				:ls_cod_sub_categ, :ls_cod_categ, :ls_desc_sub_categ, '1',
				:ls_COD_MARCA,
				:ls_COD_CARROCERIA,
				:ls_COD_COMBUSTIBLE,
				:ls_COD_COLOR,
				:ls_COD_CLASE_VEHICULO,
				:ls_VERSION,
				:ldc_PESO_SECO,
				:ldc_PESO_BRUTO,
				:ldc_PASAJEROS,
				:ldc_ASIENTOS,
				:ldc_EJES,
				:ldc_CILINDRADA,
				:ldc_ANCHO,
				:ldc_LARGO,
				:ldc_ALTO,
				:ldc_RUEDAS,
				:ls_POTENCIA,
				:ls_FORMULA,
				:ldc_CARGA_UTIL,
				:ldc_NRO_CILINDROS
			);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
					'Error al insertar ' + ls_cod_sub_categ + ' en tabla articulo_sub_categ. Mensaje: ' + ls_mensaje)
				continue
			end if
			
		end if

		
		//Inserto la fila en maestro de articulos
		yield()
		select count(*)
			into :ll_count
		from articulo a
		where a.SUB_CAT_ART 					= :ls_cod_sub_categ
		  and trim(upper(a.desc_art)) 	= trim(upper(:ls_desc_art))
		  and NVL(ANO_MODELO, 'XX')		= nvl(:ls_ano_modelo, 'XX')
		  and NVL(ANO_FABRICACION, 'XX')	= nvl(:ls_ANO_FABRICACION, 'XX')
		  and NVL(NRO_CHASIS, 'XX')		= nvl(:ls_nro_chasis, 'XX')
		  and NVL(NRO_SERIE, 'XX')			= nvl(:ls_nro_Serie, 'XX')
		  and NVL(NRO_MOTOR, 'XX')			= nvl(:ls_nro_motor, 'XX')
		  and NVL(NRO_DUA, 'XX')			= nvl(:ls_NRO_DUA, 'XX')
		  and NVL(NRO_ITEM_DUA, 'XX')		= nvl(:ls_item_dua, 'XX')
		  and NVL(NRO_LOTE, 'XX')			= nvl(:ls_NRO_LOTE, 'XX')
		  and NVL(NRO_POLIZA, 'XX')		= nvl(:ls_NRO_POLIZA, 'XX');
		
		//Si el código existe entonces se continua
		if ll_count > 0 then 
			SetMicroHelp ('El articulo ' + ls_desc_art + ' ya existe, verifique!')
			//gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
			//		'El articulo ' + ls_desc_art + ' ya existe, verifique!')
			
			select cod_art
				into :ls_cod_art
			from articulo a
			where a.SUB_CAT_ART 					= :ls_cod_sub_categ
			  and trim(upper(a.desc_art)) 	= trim(upper(:ls_desc_art))
			  and NVL(ANO_MODELO, 'XX')		= nvl(:ls_ano_modelo, 'XX')
			  and NVL(ANO_FABRICACION, 'XX')	= nvl(:ls_ANO_FABRICACION, 'XX')
			  and NVL(NRO_CHASIS, 'XX')		= nvl(:ls_nro_chasis, 'XX')
			  and NVL(NRO_SERIE, 'XX')			= nvl(:ls_nro_Serie, 'XX')
			  and NVL(NRO_MOTOR, 'XX')			= nvl(:ls_nro_motor, 'XX')
			  and NVL(NRO_DUA, 'XX')			= nvl(:ls_NRO_DUA, 'XX')
			  and NVL(NRO_ITEM_DUA, 'XX')		= nvl(:ls_item_dua, 'XX')
			  and NVL(NRO_LOTE, 'XX')			= nvl(:ls_NRO_LOTE, 'XX')
			  and NVL(NRO_POLIZA, 'XX')		= nvl(:ls_NRO_POLIZA, 'XX');
		  
		else
			
			//Obtengo el siguiente codigo
			yield()
			select max(cod_art)
				into :ls_cod_art
			from articulo a
			where trim(a.SUB_CAT_ART) = trim(:ls_cod_sub_categ)
			  and length(trim(a.cod_art)) > 10;
			
			if ISNull(ls_cod_art) or ls_cod_art = '' then
				ls_cod_art = ls_cod_sub_categ + '.00001'
			else
				ls_cod_art = trim(ls_cod_sub_categ) + '.' + trim(string(Long(mid(ls_cod_art, 8, 5)) + 1, '00000'))
			end if
			
			insert into articulo(
				COD_ART, SUB_CAT_ART, DESC_ART, NOM_ARTICULO, flag_estado,
				ANO_MODELO,
				ANO_FABRICACION,
				NRO_CHASIS,
				NRO_SERIE,
				NRO_MOTOR,
				NRO_DUA,
				NRO_ITEM_DUA,
				NRO_LOTE,
				NRO_POLIZA,
				FLAG_INVENTARIABLE,
				COSTO_ULT_COMPRA
			)
			values(
				:ls_cod_art, :ls_cod_sub_categ, :ls_desc_art, substr(:ls_desc_art, 1, 150), '1',
				:ls_ANO_MODELO,
				:ls_ANO_FABRICACION,
				:ls_NRO_CHASIS,
				:ls_NRO_SERIE,
				:ls_NRO_MOTOR,
				:ls_NRO_DUA,
				:ls_ITEM_DUA,
				:ls_NRO_LOTE,
				:ls_NRO_POLIZA,
				'1',
				1
			);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f3", this.ClassName(), &
					'Error al insertar ' + ls_cod_art + '-' + ls_desc_art &
				+ ' en tabla ARTICULO. Registro ' + string(ll_fila1) + '. Mensaje: ' + ls_mensaje)
				
				continue
			end if
			
		end if
		
		yield()
		
		/*
		//Inserto ahora el movimiento de almacen
		if not IsNull(ls_desc_almacen) and trim(ls_desc_almacen) <> '' and &
			not IsNull(ls_stock) and trim(ls_stock) <> '' then
			
			if not this.of_update_mov_almacen(ls_desc_almacen, ls_cod_art, Dec(ls_stock), &
				ldc_costo_unit, ll_fila1) then continue
			
		end if
		*/
		
		//Añadir la fila
		ll_fila = dw_master.event ue_insert()
		
		if ll_fila > 0 then
			dw_master.object.desc_categoria		[ll_fila] = ls_desc_categoria
			dw_master.object.desc_sub_cat			[ll_fila] = ls_desc_sub_categ
			dw_master.object.desc_art				[ll_fila] = ls_desc_art
			dw_master.object.und						[ll_fila] = ls_und
			dw_master.object.nom_marca				[ll_fila] = ls_nom_marca
		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		yield()	
		
		//Este registro se guarda
		commit;
	next
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique y luego proceselo!", "")
	
	RETURN 1
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
end try

end event

event type integer ue_listar_data_f4(string as_file);oleobject excel
integer	li_i
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila2, &
			ll_fila, ll_year, ll_mes
double 	dbl_precio
boolean 	lb_cek
String 	 ls_nomcol, ls_codigo, ls_mensaje

oleobject  lole_workbook, lole_worksheet

//Datos para importar
String	ls_desc_categoria, ls_desc_sub_categ, ls_desc_art, ls_und, ls_desc_clase, &
			ls_nom_marca, ls_desc_almacen, ls_stock, ls_cod_sku

//Codigos
String	ls_cod_categ, ls_cod_sub_categ, ls_cod_clase, ls_cod_marca, ls_cod_art, &
			ls_cod_almacen
			
//Parte Numerica
decimal	ldc_stock


try 
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		messagebox('Error en Excel','El archivo ' + as_file + ' no existe. Por favor verifique!', StopSign!) 
		destroy excel
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o cnfigurado el MS.Excel, por favor verifique!',exclamation!)
		destroy excel
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook = excel.workbooks(1)
	lb_cek = lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   = lole_worksheet.UsedRange.Rows.Count
	dw_master.reset( )
	
	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_desc_categoria	= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_desc_sub_categ	= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_desc_art			= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_und				= trim(String(lole_worksheet.cells(ll_fila1,4).value))
		ls_desc_clase		= String(lole_worksheet.cells(ll_fila1,5).value)
		ls_cod_sku			= String(lole_worksheet.cells(ll_fila1,6).value)
		ls_nom_marca		= String(lole_worksheet.cells(ll_fila1,7).value)
		ls_Desc_almacen	= String(lole_worksheet.cells(ll_fila1,8).value)
		ls_stock				= String(lole_worksheet.cells(ll_fila1,9).value)
		
		//Descripcion de categoria
		if IsNull(ls_desc_categoria) or trim(ls_desc_categoria) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'Error, no existe categoría en el registro ' + string(ll_fila1))
			continue
		end if
	
		if IsNull(ls_desc_sub_categ) or trim(ls_desc_sub_categ) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'Error, no existe SUBCATEGORIA en el registro ' + string(ll_fila1))
			continue
		end if

		if IsNull(ls_und) or trim(ls_und) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'Error, no ha especificado unidad en el registro ' + string(ll_fila1))
			continue
		end if
		
		if IsNull(ls_desc_clase) or trim(ls_desc_clase) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'Error, no ha especificado Clase de ARTICULO en el registro ' + string(ll_fila1))
			continue
		end if

		if IsNull(ls_cod_sku) or trim(ls_cod_sku) = '' then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'Error, no ha especificado CODIGO DE SKU en el registro ' + string(ll_fila1))
			continue
		end if

		//Verifico que todos los textos estan en las tablas
		
		//UNIDAD
		select count(*)
			into :ll_count
		from unidad
		where und = :ls_und;
		
		if ll_count = 0 then
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'Error, La unidad [' + ls_und + '] no existe en el maestro de UNIDAD. Nro de Registro: ' &
				+ string(ll_fila1))
			return -1
		end if

		//Categoría
		select count(*)
			into :ll_count
		from articulo_categ
		where upper(trim(DESC_CATEGORIA)) = trim(upper(:ls_desc_categoria));
		
		if ll_count > 0 then
			select CAT_ART
				into :ls_cod_categ
			from articulo_categ
			where upper(trim(DESC_CATEGORIA)) = trim(upper(:ls_desc_categoria));
		else
			select max(CAT_ART)
				into :ls_cod_categ
			from articulo_categ
			where (cat_Art like '0%' or cat_Art like '1%');
			
			if ISNull(ls_cod_Categ) or ls_Cod_categ = '' then
				ls_cod_categ = '001'
			else
				ls_cod_categ = trim(string(Long(ls_cod_categ) + 1, '000'))
			end if
			
			insert into articulo_categ(
				CAT_ART, DESC_CATEGORIA, FLAG_SERVICIO, FLAG_ESTADO)
			values(
				:ls_cod_categ, :ls_desc_categoria, '0', '1');
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
					'Error al insertar en tabla articulo_categ. Mensaje: ' + ls_mensaje)
				continue
			end if
		end if

		//Subcategoria
		select count(*)
			into :ll_count
		from articulo_sub_categ
		where upper(trim(DESC_SUB_CAT)) 		= trim(upper(:ls_desc_sub_categ))
		  and CAT_ART 								= :ls_cod_categ;
		  
		if ll_count > 0 then
			
			select COD_SUB_CAT
				into :ls_cod_sub_categ
			from articulo_sub_categ
			where upper(trim(DESC_SUB_CAT)) 		= trim(upper(:ls_desc_sub_categ))
			  and CAT_ART 								= :ls_cod_categ;
			  
		else
			
			select max(COD_SUB_CAT)
				into :ls_cod_sub_categ
			from articulo_sub_categ
			where CAT_ART 	= :ls_cod_categ;
			
			if IsNull(ls_cod_sub_categ) or trim(ls_cod_sub_categ) = '' then
				ls_cod_sub_categ = trim(ls_cod_categ) + '001'	
			else
				ls_cod_sub_categ = trim(ls_cod_categ) + trim(string( Long(mid(ls_cod_sub_categ, 4, 3)) + 1, '000'))
			end if
			
			
			//Inserto el subarticulo
			insert into articulo_sub_categ(
				COD_SUB_CAT, CAT_ART, DESC_SUB_CAT, FLAG_ESTADO
			)
			values(
				:ls_cod_sub_categ, :ls_cod_categ, :ls_desc_sub_categ, '1'
			);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
					'Error al insertar ' + ls_cod_sub_categ + ' en tabla articulo_sub_categ. Mensaje: ' + ls_mensaje)
				continue
			end if
			
		end if

		
		
		//CLASE
		select count(*)
			into :ll_count
		from articulo_clase
		where upper(trim(DESC_CLASE)) = trim(upper(:ls_desc_clase));
		
		if ll_count > 0 then
			select COD_CLASE
				into :ls_Cod_clase
			from articulo_clase
			where upper(trim(DESC_CLASE)) = trim(upper(:ls_desc_clase));
		else
			ROLLBACK;
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
				'No existe la clase de articulo ' + ls_desc_clase + ', por favor corrija y vuelva a intentarlo')
			return -1
		end if

		
		//MARCA
		if not IsNull(ls_nom_marca) and trim(ls_nom_marca) <> '' then
			select count(*)
				into :ll_count
			from marca
			where upper(trim(NOM_MARCA)) = trim(upper(:ls_nom_marca));
			
			if ll_count > 0 then
				select COD_MARCA
					into :ls_cod_marca
				from marca
				where upper(trim(NOM_MARCA)) = trim(upper(:ls_nom_marca));
			else
				select max(COD_MARCA)
					into :ls_cod_marca
				from marca
				where cod_marca like '0%';
				
				if ISNull(ls_cod_marca) or ls_cod_marca = '' then
					ls_cod_marca = '00000001'
				else
					ls_cod_marca = trim(string(Long(ls_cod_marca) + 1, '00000000'))
				end if
				
				insert into marca(
					COD_MARCA, NOM_MARCA, FLAG_ESTADO )
				values(
					:ls_cod_marca, :ls_nom_marca, '1');
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
						'Error al insertar ' + ls_cod_marca + ' en tabla marca. Mensaje: ' + ls_mensaje)
					continue
				end if
			end if
		else
			SetNull(ls_cod_marca)
		end if


		if IsNull(ls_stock) or trim(ls_stock) = '' then
			SetNull(ldc_stock)
		else
			ldc_stock = Dec(ls_stock)
		end if

		
		
		//Inserto la fila en maestro de articulos
		yield()
		select count(*)
			into :ll_count
		from articulo a
		where a.SUB_CAT_ART 					= :ls_cod_sub_categ
		  and trim(upper(a.desc_art)) 	= trim(upper(:ls_desc_art))
		  and COD_MARCA						= :ls_cod_marca
		  and COD_SKU							= :ls_cod_sku;
		
		//Si el código existe entonces se continua
		if ll_count > 0 then 
			SetMicroHelp ('El articulo ' + ls_desc_art + ' ya existe, verifique!')
			//gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
			//		'El articulo ' + ls_desc_art + ' ya existe, verifique!')
			
			select cod_art
				into :ls_cod_art
			from articulo a
			where a.SUB_CAT_ART 					= :ls_cod_sub_categ
		  	  and trim(upper(a.desc_art)) 	= trim(upper(:ls_desc_art))
		  	  and COD_MARCA						= :ls_cod_marca
		  	  and COD_SKU							= :ls_cod_sku;	
				 
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
					'Error al CONSULTAR el ARTICULO: ' + ls_cod_art + '-' + ls_desc_art &
				+ ' en tabla ARTICULO. Registro ' + string(ll_fila1) + '. Mensaje: ' + ls_mensaje)
				
				continue
			end if

		   
			update articulo a
			   set a.und = :ls_und
			 where a.cod_art = :ls_cod_art;

			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
					'Error al ACTUALIZAR el articulo ' + ls_cod_art + '-' + ls_desc_art &
				+ ' en tabla ARTICULO. Registro ' + string(ll_fila1) + '. Mensaje: ' + ls_mensaje)
				
				continue
			end if
			 
		else
			
			//Obtengo el siguiente codigo
			yield()
			select max(cod_art)
				into :ls_cod_art
			from articulo a
			where trim(a.SUB_CAT_ART) = trim(:ls_cod_sub_categ)
			  and length(trim(a.cod_art)) > 10;
			
			if ISNull(ls_cod_art) or ls_cod_art = '' then
				ls_cod_art = ls_cod_sub_categ + '.00001'
			else
				ls_cod_art = trim(ls_cod_sub_categ) + '.' + trim(string(Long(mid(ls_cod_art, 8, 5)) + 1, '00000'))
			end if
			
			insert into articulo(
				COD_ART, SUB_CAT_ART, DESC_ART, NOM_ARTICULO, flag_estado,
				COD_MARCA, und, cod_sku,
				COSTO_ULT_COMPRA
			)
			values(
				:ls_cod_art, :ls_cod_sub_categ, :ls_desc_art, substr(:ls_desc_art, 1, 150), '1',
				:ls_cod_marca, :ls_und, :ls_cod_sku,
				1
			);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				gnvo_app.of_add_mensaje_error( ll_fila1, "ue_listar_data_f4", this.ClassName(), &
					'Error al insertar ' + ls_cod_art + '-' + ls_desc_art &
				+ ' en tabla ARTICULO. Registro ' + string(ll_fila1) + '. Mensaje: ' + ls_mensaje)
				
				continue
			end if
			
		end if
		
		yield()
		
		/*
		//Inserto ahora el movimiento de almacen
		if not IsNull(ls_desc_almacen) and trim(ls_desc_almacen) <> '' and &
			not IsNull(ls_stock) and trim(ls_stock) <> '' then
			
			if not this.of_update_mov_almacen(ls_desc_almacen, ls_cod_art, Dec(ls_stock), &
				ldc_costo_unit, ll_fila1) then continue
			
		end if
		*/
		
		//Añadir la fila
		ll_fila = dw_master.event ue_insert()
		
		if ll_fila > 0 then
			dw_master.object.desc_categoria		[ll_fila] = ls_desc_categoria
			dw_master.object.desc_sub_cat			[ll_fila] = ls_desc_sub_categ
			dw_master.object.desc_art				[ll_fila] = ls_desc_art
			dw_master.object.und						[ll_fila] = ls_und
			dw_master.object.nom_marca				[ll_fila] = ls_nom_marca
			dw_master.object.cod_sku				[ll_fila] = ls_cod_sku
			dw_master.object.desc_clase			[ll_fila] = ls_desc_clase
			dw_master.object.desc_almacen			[ll_fila] = ls_desc_almacen
			dw_master.object.stock					[ll_fila] = ldc_stock
		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		yield()	
		
		//Este registro se guarda
		commit;
	next
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique y luego proceselo!", "")
	
	RETURN 1
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
end try

end event

public function boolean of_update_mov_almacen (string as_desc_almacen, string as_cod_art, decimal adc_stock, decimal adc_costo, long al_row);Date 		ld_hoy, ld_fecha_vale
Long		ll_ult_nro, ll_count
String	ls_origen, ls_almacen, ls_tipo_mov, ls_mensaje, ls_nro_vale

if adc_stock <= 0 or IsNull(adc_stock) then return true

ld_hoy = Date(gnvo_app.of_fecha_actual( ))

ld_fecha_vale = date('31/12/' + string(year(ld_hoy) - 1))

//Obtengo el nro de vale
select count(*)
	into :ll_count
from almacen
where trim(upper(desc_almacen)) = trim(upper(:as_desc_almacen));

if ll_count = 0 then
	ROLLBACK;
	gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
		'Error no existe almacen ' + as_desc_almacen + '. Por favor verifique!')
	
	return false
end if

select COD_ORIGEN, almacen
	into :ls_origen, :ls_almacen
from almacen
where trim(upper(desc_almacen)) = trim(upper(:as_desc_almacen));

//Obtengo el nro de vale
select count(*)
  into :ll_count
  from vale_mov
 where almacen 				= :ls_almacen
   and trim(tipo_mov)		= trim(:gnvo_app.almacen.is_oper_inv_ini)
	and trunc(FEC_REGISTRO) = trunc(:ld_fecha_vale);
	
if ll_count = 0 then
	//Obtengo el siguiente numero
	select count(*)
		into :ll_count
	from num_vale_mov
	where origen = :ls_origen;
	
	if ll_count = 0 then
	 	insert into num_vale_mov(origen , ult_nro)
		values(
			:ls_origen, 1);
	end if
	
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
			'Error al insertar registro en num_Vale_mov. Mensaje: ' + ls_mensaje)
		
		return false
	end if
	
	//Obtengo el siguiente numero
	select ult_nro
		into :ll_ult_nro
	from num_vale_mov
	where origen = :ls_origen for update;
	
	//Obtengo el numero de vale
	ls_nro_vale = trim(ls_origen) + trim(string(ll_ult_nro, '00000000'))
	
	//Incremento el contador
	ll_ult_nro ++
	
	//Actualizo el contador
	update num_vale_mov
	   set ult_nro = :ll_ult_nro
	where origen = :ls_origen;

	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
			'Error al actualizar registro en num_Vale_mov. Mensaje: ' + ls_mensaje)
		
		return false
	end if
	
	//Inserto la cabecera del vale_mov
	//SQL> desc vale_mov
	//Name             Type          Nullable Default Comments         
	//---------------- ------------- -------- ------- ---------------- 
	//COD_ORIGEN       CHAR(2)                        codigo origen    
	//NRO_VALE         CHAR(10)                       nro vale         
	//ALMACEN          CHAR(6)                        cod almacen      
	//FLAG_ESTADO      CHAR(1)       Y        '1'     flag estado      
	//FEC_REGISTRO     DATE          Y                fec registro     
	//TIPO_MOV         CHAR(6)       Y                tipo movimiento  
	//COD_USR          CHAR(6)       Y                cod usuario      
	//PROVEEDOR        CHAR(8)       Y                cod proveedor    
	//JOB              CHAR(10)      Y                job              
	//NOM_RECEPTOR     VARCHAR2(50)  Y                nom_receptor     
	//TIPO_DOC_INT     CHAR(4)       Y                tipo doc interno 
	//NRO_DOC_INT      CHAR(10)      Y                nro doc interno  
	//TIPO_DOC_EXT     CHAR(4)       Y                tipo doc externo 
	//NRO_DOC_EXT      CHAR(10)      Y                nro doc externo  
	//ORIGEN_REFER     CHAR(2)       Y                origen refer     
	//TIPO_REFER       CHAR(4)       Y                tipo refer       
	//NRO_REFER        CHAR(10)      Y                nro refer        
	//FLAG_REPLICACION CHAR(1)       Y        '1'     flag_replicacion 
	//OBSERVACIONES    VARCHAR2(200) Y                OBSERVACIONES 
	
	Insert into vale_mov(
		cod_origen, nro_Vale, almacen, flag_estado, tipo_mov, cod_usr, OBSERVACIONES,
		fec_registro)
	values(
		:ls_origen, :ls_nro_vale, :ls_almacen, '1', :gnvo_app.almacen.is_oper_inv_ini,
		:gs_user, 
		'INVENTARIO INICIAL REALIZADO POR CARGA MASIVA REALIZADO EL : ' || to_char(:ld_hoy, 'dd/mm/yyyy'),
		:ld_fecha_vale);

	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
			'Error al insertar registro en vale_mov. Mensaje: ' + ls_mensaje)
		
		return false
	end if
	
else
	select nro_vale
	  into :ls_nro_vale
	  from vale_mov
	 where almacen 				= :ls_almacen
		and trim(tipo_mov)		= trim(:gnvo_app.almacen.is_oper_inv_ini)
		and trunc(FEC_REGISTRO) = trunc(:ld_fecha_vale);

	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
			'Error al realizar la consulta SELECT en vale_mov. Mensaje: ' + ls_mensaje)
		
		return false
	end if
		
end if

//Insertar el detalle en articulo_mov
//SQL> desc articulo_mov
//Name               Type         Nullable Default Comments           
//------------------ ------------ -------- ------- ------------------ 
//COD_ORIGEN         CHAR(2)                       codigo origen      
//NRO_MOV            NUMBER(10)                    nro mov            
//ORIGEN_MOV_PROY    CHAR(2)      Y                origen mov proy    
//NRO_MOV_PROY       NUMBER(10)   Y                nro mov proy       
//NRO_VALE           CHAR(10)     Y                nro vale           
//FLAG_ESTADO        CHAR(1)      Y        '1'     flag estado        
//COD_ART            CHAR(12)                      cod articulo       
//CANT_PROCESADA     NUMBER(13,5) Y        0       cant procesada     
//PRECIO_UNIT        NUMBER(17,8) Y        null    precio unitario    
//DECUENTO           NUMBER(4,2)  Y        0       decuento           
//IMPUESTO           NUMBER(4,2)  Y        0       Impuesto           
//COD_MONEDA         CHAR(3)      Y                cod moneda         
//CENCOS             CHAR(10)     Y                centro costo       
//COD_MAQUINA        CHAR(8)      Y                cod maquina        
//CNTA_PRSP          CHAR(10)     Y                CNTA PRSP          
//MATRIZ             CHAR(8)      Y                matriz             
//PESO_NETO_TM       NUMBER(10,3) Y                peso neto tm       
//NRO_LOTE           CHAR(13)     Y                nro lote           
//KM_HR_MAQ          NUMBER(9,2)  Y                km_hr_maq          
//COSTO_MIN_TRASLADO NUMBER(13,2) Y        0       costo min traslado 
//PRECIO_UNIT_ANT    NUMBER(17,8) Y                precio unit ant    
//OPER_SEC           CHAR(10)     Y                oper_sec           
//CANT_PROC_UND2     NUMBER(12,4) Y        0       cant proc und2     
//FLAG_REPLICACION   CHAR(1)      Y        '1'     flag_replicacion   
//NRO_MOV_DEV        VARCHAR2(10) Y                nro mov dev        
//FLAG_SALDO_LIBRE   CHAR(1)      Y        '0'     flag_saldo_libre   
//FEC_REGISTRO       DATE                  sysdate FEC_REGISTRO       
//NRO_RESERVACION    CHAR(10)     Y                nro reservacion    
//CENTRO_BENEF       CHAR(12)     Y                CENTRO_BENEF       
//VALE_TRANS         CHAR(10)     Y                VALE_TRANS         
//ITEM_TRANS         NUMBER(6)    Y                ITEM_TRANS         
//ITEM_RESERVACION   NUMBER(6)    Y                ITEM_RESERVACION   
//NRO_OC             CHAR(10)     Y                NRO_OC             
//ORG_OC             CHAR(2)      Y                ORG_OC             
//ITEM_OC            NUMBER(6)    Y                ITEM_OC  

select count(*)
	into :ll_count
from articulo_mov 
where nro_vale = :ls_nro_vale
  and cod_art	= :as_cod_art;

if ll_count > 0 then
	update articulo_mov 
		set cant_procesada = cant_procesada + :adc_stock,
			 PRECIO_UNIT	 = :adc_costo
	where nro_vale = :ls_nro_vale
	  and cod_art	= :as_cod_art;
	
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
			'Error al actualizar registro en articulo_mov. Mensaje: ' + ls_mensaje)
		
		return false
	end if
else
	//Inserto el registro en caso de no existir
	insert into articulo_mov(
		cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, PRECIO_UNIT, fec_registro)
	values(
		:ls_origen, :ls_nro_vale, '1', :as_cod_art, :adc_stock, :adc_costo, sysdate);


	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.sqlerrtext
		ROLLBACK;
		gnvo_app.of_add_mensaje_error( al_row, "ue_listar_data_f1", this.ClassName(), &
			'Error al INSERTAR registro en articulo_mov. Mensaje: ' + ls_mensaje)
		
		return false
	end if
end if

return true
end function

public function boolean of_imagen_file (long al_index);string ls_file, ls_path

blob 	lbl_imagen

ls_file = sle_path.text + "\" + lb_files.Text(al_index)
lbl_imagen = invo_util.of_load_blob(ls_file)

p_foto.SetRedraw(FALSE)
p_foto.SetPicture(lbl_imagen)
p_foto.SetRedraw(TRUE)


return true
end function

on w_cm913_importar_fotos.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.hpb_progreso=create hpb_progreso
this.st_texto=create st_texto
this.rb_1=create rb_1
this.st_1=create st_1
this.sle_path=create sle_path
this.cb_path=create cb_path
this.st_2=create st_2
this.st_3=create st_3
this.cb_procesar=create cb_procesar
this.lb_files=create lb_files
this.st_4=create st_4
this.st_5=create st_5
this.p_foto=create p_foto
this.pb_resize=create pb_resize
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.st_texto
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_path
this.Control[iCurrent+6]=this.cb_path
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.cb_procesar
this.Control[iCurrent+10]=this.lb_files
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.p_foto
this.Control[iCurrent+14]=this.pb_resize
end on

on w_cm913_importar_fotos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.st_texto)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.sle_path)
destroy(this.cb_path)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_procesar)
destroy(this.lb_files)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.p_foto)
destroy(this.pb_resize)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

hpb_progreso.width  = newwidth  - hpb_progreso.x - 10

st_texto.x 	= newwidth  - st_texto.width - 10
st_3.x 		= st_texto.x - st_3.width   - 10

cb_procesar.x 	= newwidth  - cb_procesar.width - 10

cb_path.x 	= newwidth  - cb_path.width - 10

sle_path.width 	= cb_path.x  - sle_path.x - 10

st_5.width = dw_master.width

p_foto.y = newheight - p_foto.height - 10
lb_files.height = p_foto.y - lb_files.y - 10

//Boton resize
pb_resize.x = p_foto.x + p_foto.width - pb_resize.width - 2
pb_resize.y = p_foto.y + 2
end event

event ue_open_pre;call super::ue_open_pre;
ii_lec_mst = 0

try
	
	ids_articulos = create u_ds_base
	ids_articulos.DataObject = 'd_lista_articulos_similares_tbl'
	ids_articulos.SetTransObject(SQLCA)
	
	sle_path.text = gnvo_app.of_get_parametro('RUTA_FOTOS_UPLOAD', GetCurrentDirectory ( ))
	
	lb_files.DirList(sle_path.text + "\*.??g", 35)
	
	if lb_files.TotalItems() > 0 then
		cb_procesar.enabled = true
	else
		cb_procesar.enabled = false
	end if
	
	
catch(Exception ex)

	gnvo_app.of_Catch_exception(ex, '')
	
end try
end event

event closequery;//Override
Destroy	im_1

of_close_sheet()
end event

event close;call super::close;destroy ids_articulos
end event

type dw_master from w_abc_master_smpl`dw_master within w_cm913_importar_fotos
event ue_display ( string as_columna,  long al_row )
integer x = 1179
integer y = 468
integer width = 1778
integer height = 1164
string dataobject = "d_list_importar_zapatos_tbl"
end type

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		ls_sql = "select und as codigo, desc_unidad as descripcion from unidad"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		this.ii_update = 1
		
	case 'grp_medicion'
		ls_sql = "select grp_medicion as codigo, descripcion as nombre from tg_med_act_atributo_grp"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		this.ii_update = 1
end choose
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		select und, desc_unidad
			into :ls_return1, :ls_return2
			from unidad
			where und = :data;
			
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		
		return 2
		
	case 'grp_medicion'
		select grp_medicion, descripcion 
			into :ls_return1, :ls_return2
			from tg_med_act_atributo_grp
			where grp_medicion = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		
		return 2
		
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

type hpb_progreso from hprogressbar within w_cm913_importar_fotos
integer y = 292
integer width = 2935
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_texto from statictext within w_cm913_importar_fotos
integer x = 2217
integer y = 196
integer width = 736
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_cm913_importar_fotos
integer x = 585
integer y = 108
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Método 1"
boolean checked = true
end type

event clicked;dw_master.DataObject = "d_list_importar_zapatos_tbl"
dw_master.setTransObject( SQLCA )
end event

type st_1 from statictext within w_cm913_importar_fotos
integer y = 8
integer width = 549
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Carpeta de Fotos :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_path from singlelineedit within w_cm913_importar_fotos
integer x = 581
integer y = 8
integer width = 2199
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_path from commandbutton within w_cm913_importar_fotos
integer x = 2766
integer y = 8
integer width = 187
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_path
integer li_result

try 
	ls_path = sle_path.text
	li_result = GetFolder( "Mis Fotos", ls_path )
	
	sle_path.text=ls_path  
	
	lb_files.DirList(ls_path + "\*.??g", 35)
	
	if lb_files.TotalItems() = 0 then
		MessageBox('Error', 'En el path ' + ls_path + ' no se encontrado imagenes de tipo JPG o PNG, por favor verifique!', StopSign!)
		cb_procesar.enabled = false
		return
	else
		cb_procesar.enabled = true
		
		gnvo_app.of_set_parametro('RUTA_FOTOS_UPLOAD', ls_path)
		
		commit;
		
	end if
	
catch ( Exception ex )
	
	gnvo_app.of_Catch_exception(ex, '')
	
end try

end event

type st_2 from statictext within w_cm913_importar_fotos
integer x = 5
integer y = 116
integer width = 549
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Metodo importación :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cm913_importar_fotos
integer x = 1659
integer y = 208
integer width = 549
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Registros :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_cm913_importar_fotos
integer x = 2610
integer y = 96
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;this.enabled = false

if rb_1.checked then
	parent.event ue_metodo_f1()
else
	MessageBox('Error', 'Metodo aun no implementado, por favor verifique!', StopSign!)
end if

this.enabled = true
end event

type lb_files from listbox within w_cm913_importar_fotos
integer y = 468
integer width = 1166
integer height = 1172
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;of_imagen_file(index)
end event

type st_4 from statictext within w_cm913_importar_fotos
integer y = 372
integer width = 1166
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Listado de FOTOS (JPG, PNG)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_cm913_importar_fotos
integer x = 1179
integer y = 372
integer width = 1778
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Upload de Registros con fotos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type p_foto from picture within w_cm913_importar_fotos
event ue_maximized ( )
event ue_restored ( )
integer y = 1652
integer width = 1166
integer height = 688
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event ue_maximized();Long ll_height, ll_width, ll_new_height


ll_new_height = p_foto.y + p_foto.height

p_foto.y = st_4.y
p_foto.height = ll_new_height - p_foto.y

p_foto.width = dw_master.x + dw_master.width - p_foto.x

//Boton resize
pb_resize.x = p_foto.x + p_foto.width - pb_resize.width - 10
pb_resize.y = p_foto.y + 10

//Cambio de imagen
pb_resize.PictureName = "C:\SIGRE\resources\PNG\restored.png"

//Aplico la imagen
of_imagen_file(lb_files.SelectedIndex())

//Indico que ya esta maximizado
lb_maximized = true
end event

event ue_restored();Long ll_height

ll_height = p_foto.y + p_foto.height

p_foto.y = lb_files.y + lb_files.height + 10
p_foto.height = ll_height - p_foto.y 

p_foto.width = lb_files.width

//Boton resize
pb_resize.x = p_foto.x + p_foto.width - pb_resize.width - 10
pb_resize.y = p_foto.y + 10

//Cambio de imagen
pb_resize.PictureName = "C:\SIGRE\resources\PNG\maximizar.png"

//Aplico la imagen
of_imagen_file(lb_files.SelectedIndex())

//Indico que ya esta maximizado
lb_maximized = false
end event

type pb_resize from picturebutton within w_cm913_importar_fotos
integer x = 1019
integer y = 1660
integer width = 133
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\maximizar.png"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Maximizar la imagen"
end type

event clicked;if not lb_maximized then
	p_foto.event ue_maximized()
else
	p_foto.event ue_restored()
end if
end event

