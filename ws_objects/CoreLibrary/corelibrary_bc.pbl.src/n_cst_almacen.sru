$PBExportHeader$n_cst_almacen.sru
forward
global type n_cst_almacen from nonvisualobject
end type
end forward

global type n_cst_almacen from nonvisualobject
end type
global n_cst_almacen n_cst_almacen

type prototypes
//Funciones para la generación del codigo QR
SUBROUTINE FastQRCode(REF String Texto, REF String FileName) LIBRARY "i:\sigre_exe\QRCodeLib.dll" Alias for "FastQRCode;Ansi"
//subroutine FastQRCode(ref string text, ref string filename) library '\sigre_exe\QRCodeLib.dll' ALIAS FOR "FastQRCode"
Function String QRCodeLibVer() LIBRARY "i:\sigre_exe\QRCodeLib.dll" Alias for "QRCodeLibVer;Ansi"
end prototypes

type variables
string is_oper_inv_ini = 'I00'

String is_despacho_POST_vta, is_oper_vta_mercaderia, is_doc_vale, is_precarga, &
		 is_show_all_almacen, is_oper_vnta_terc

//Clases de Articulos
String			is_clase_pptt, is_clase_prod_inter, is_clase_subprod, is_clase_descarte, is_path_sigre

//Matriz contable por defecto
String			is_matriz_VS000, is_flag_gre

n_cst_wait			invo_wait
n_cst_utilitario	invo_util
n_cst_file_blob	invo_blob
n_cst_inifile		invo_inifile
n_cst_xml			invo_xml

//DataStore para Guias de REmisión Electronica
u_ds_base 			ids_guia

end variables

forward prototypes
public function str_articulo of_get_articulo ()
public function integer of_articulo_inventariable (string as_cod_art)
public function str_articulo of_get_articulo_venta ()
public function boolean of_load ()
public function str_articulo of_get_articulos_all ()
public function str_articulo of_get_articulo_venta (string asi_almacen)
public function str_articulo of_get_articulo (string as_cod_art)
public function boolean of_rpt_codigo_barras (u_dw_rpt adw_report, hprogressbar ahpb_1, string as_almacen, decimal adc_nro_copias)
public function str_articulo of_get_producibles ()
public function string of_get_matriz_cntbl (string as_tipo_mov, string as_cencos, string as_cod_art) throws exception
public function str_articulo of_get_articulos_user (string as_user)
public function string of_get_foto (string as_cod_art)
public function string of_nro_vale_mov (string as_origen) throws exception
public function str_articulo of_get_articulo_venta (string asi_almacen, string asi_tipo_doc)
public function string of_get_foto_id (long al_idfoto)
public function boolean of_rpt_codigos_cu (u_dw_rpt adw_report, hprogressbar ahpb_1, string as_almacen, decimal adc_nro_copias, string as_tipocopia)
public function boolean of_actualiza_saldos ()
public function boolean of_rpt_codigos_barras_zc (u_dw_rpt adw_report, hprogressbar ahpb_1, string as_almacen, decimal adc_nro_copias)
public function string of_generar_qrcode (str_qrcode astr_param)
public function boolean of_generar_pdf (str_qrcode astr_param, datawindow adw_report)
public function string of_get_firma_autorizado (string as_ini_file, string as_user)
public function string of_get_firma_usuario (string as_ini_file, string as_user)
public function str_articulo of_get_articulo_bonif ()
public function boolean of_print_guia (string as_org_guia, string as_nro_guia)
public subroutine of_modify_ds (datastore ads_data, integer ai_opcion)
public function string of_get_datawindow (string as_serie)
public function boolean of_print_vale (string as_nro_vale)
public function boolean of_print_vales_from_guia (string as_nro_guia)
public function str_articulo of_get_articulos_activos ()
public function boolean of_create_only_xml (string as_nro_guia) throws exception
public function boolean of_generar_xml_gre (string asi_nro_guia)
public function string of_gre_additionaldocumentreference (u_ds_base ads_guia)
public function string of_gre_signature (u_ds_base ads_guia)
public function string of_gre_ublextensions (u_ds_base ads_guia)
public function string of_gre_opendespatchadvice (u_ds_base ads_guia)
public function string of_gre_closedespatchadvice (u_ds_base ads_guia)
public function string of_gre_despatchsupplierparty (u_ds_base ads_guia)
public function string of_gre_deliverycustomerparty (u_ds_base ads_guia)
public function string of_gre_shipment (u_ds_base ads_guia)
public function string of_gre_despatchline (u_ds_base ads_guia)
public function str_prov_transporte of_get_prov_transporte ()
end prototypes

public function str_articulo of_get_articulo ();Str_articulo 	lstr_articulo

Open(w_search_articulos)
if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function integer of_articulo_inventariable (string as_cod_art);/*
   Evalua si articulo es inventariable o no
	
	Parametro: codigo de articulo
	retorna:  0 = no inventariable
				 1 = inventariable
				-1 = articulo no existe
*/

Long ll_count
string ls_flag, ls_activo, ls_mensaje

// Valida que articulo exista
Select count( * ) 
	into :ll_count 
from articulo
where cod_art 	= :as_cod_art
  or cod_sku	= :as_cod_art;

if SQLCA.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox("Aviso", "HA ocurrido un error al consulta la tabla ARTICULO. Mensaje: " + ls_mensaje, StopSign!)
	return -1
end if

if ll_count = 0 then
	Messagebox("Aviso", "Codigo de articulo o Codigo SKU " + as_cod_art + " no existe, por favor verifique!", StopSign!)
	return -1
end if

// Valida si es inventariable o no
Select flag_inventariable, flag_estado 
	into :ls_flag, :ls_activo from articulo
where cod_art  = :as_cod_art
  or	cod_sku	= :as_cod_art;
  
if ls_flag = '0' then
	Messagebox("Aviso", "Codigo de artículo ingresado " + trim(as_cod_art) + " no es inventariable, por favor verifique!", StopSign!)
	return 0
end if  

if ls_activo = '0' then
	Messagebox("Aviso", "Codigo de artículo ingresado " + trim(as_cod_art) + " no se encuentra activo, por favor verifique!", StopSign!)
	return 0
end if  

return 1
end function

public function str_articulo of_get_articulo_venta ();Str_articulo lstr_articulo
str_parametros lstr_param

lstr_param.string1 = 'stock'
lstr_param.almacen = ''

if is_precarga = '1' then
	lstr_param.b_precarga = true
else
	lstr_param.b_precarga = false
end if


OpenWithParm(w_pop_articulos_venta, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function boolean of_load ();String 	ls_mensaje
Long		ll_count

try 
	invo_inifile.of_set_inifile(gnvo_app.is_empresas_iniFile)
	
	//Indicador para ver si envia la guia electronica el usuario
	is_flag_gre 			= gnvo_app.of_get_parametro( "PROC_GUIA_REMISION_ELECTRONICA", "0")
	
	//Indicador si se esta usando el vale de salida para factura posterior
	is_despacho_POST_vta 	= gnvo_app.of_get_parametro( "DESCPACHO_POST_VTA", "0")
	is_oper_vta_mercaderia	= gnvo_app.of_get_parametro( "OPER_VTA_MERCADERIA", "S26")
	is_precarga					= gnvo_app.of_get_parametro( "VTA_PRE_CARGA", "1")
	is_show_all_almacen		= gnvo_app.of_get_parametro( "ALMACEN_SHOW_ALL_ALMACEN", "1")
	
	select doc_mov_almacen, oper_vnta_terc
		into :is_doc_vale, :is_oper_vnta_terc
	from logparam
	where reckey = '1';
	
	//clases de Articulos
	is_clase_pptt			= gnvo_app.of_get_parametro('CLASE_PPTT', '01')
	is_clase_prod_inter	= gnvo_app.of_get_parametro('CLASE_PRODUCTO_INTERMEDIO', '05')
	is_clase_subprod		= gnvo_app.of_get_parametro('CLASE_SUBPRODUCTO', '15')
	is_clase_descarte		= gnvo_app.of_get_parametro('CLASE_DESCARTE', '16')
	
	is_matriz_vs000		= gnvo_app.of_get_parametro('MATRIZ_CNTBL_VS-000', 'VS-000')
	
	is_path_sigre 			= invo_inifile.of_get_parametro( "SIGRE_EXE", "PATH_SIGRE", "i:\SIGRE_EXE")
	
	if right(this.is_path_sigre, 1) = '\' then
		this.is_path_sigre = left(this.is_path_sigre, len(this.is_path_sigre) - 1)
	end if
	
	invo_xml.of_load()
	
	return true
	
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción en la función OF_LOAD del objeto ' + this.classname() &
							+ '.~r~nMensaje de error: ' + ex.getMessage() + '.' &
							+ '~r~nPor favor verifique!', StopSign!)
	
	return false
finally
	/*statementBlock*/
end try


end function

public function str_articulo of_get_articulos_all ();Str_articulo lstr_articulo
str_parametros lstr_param

lstr_param.string1 = 'all'

OpenWithParm(w_pop_articulos, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function str_articulo of_get_articulo_venta (string asi_almacen);Str_articulo lstr_articulo
str_parametros lstr_param

lstr_param.string1 = 'stock'
lstr_param.almacen = asi_almacen

if is_precarga = '1' then
	lstr_param.b_precarga = true
else
	lstr_param.b_precarga = false
end if

OpenWithParm(w_pop_articulos_venta, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function str_articulo of_get_articulo (string as_cod_art);String			ls_cod_art, ls_desc_art, ls_und, ls_flag_inv, ls_flag_estado, ls_msg
str_articulo	lstr_articulo

// Verifica que codigo ingresado exista			
Select 	case 
				when a.desc_clase_vehiculo is null then
					a.full_desc_art
				else
					a.full_desc_vehiculo
			end,
			a.cod_art,
			a.und, 
			NVL(flag_inventariable, '0'), 
			NVL(flag_estado, '0')
	into 	:ls_desc_art, :ls_cod_art, :ls_und, :ls_flag_inv, :ls_flag_estado
from vw_articulo a
Where cod_Art = :as_cod_art;

lstr_articulo.b_return = false

if Sqlca.sqlcode = 100 then 
	ROLLBACK;
	Messagebox( "Atencion", "Codigo de articulo: '" + as_cod_art + " no existe, por favor verifique!", StopSign!)
	Return lstr_articulo
end if		

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', 'Ha ocurrido un error al consulta la vista VW_ARTICULO. Mensaje: ' + ls_msg, StopSign!)
	return lstr_articulo
end if

if ls_flag_estado = '0' then
	Messagebox( "Atencion", "Codigo de articulo: '" + as_cod_art + " esta inactivo", StopSign!)
	Return lstr_articulo
end if

if ls_flag_inv = '0' then
	Messagebox( "Atencion", "Codigo de articulo: '" + as_cod_art + " no es inventariable", StopSign!)
	Return lstr_articulo
end if

lstr_articulo.cod_art  	= ls_Cod_art
lstr_articulo.desc_art	= ls_desc_art
lstr_articulo.und			= ls_und


return lstr_articulo
end function

public function boolean of_rpt_codigo_barras (u_dw_rpt adw_report, hprogressbar ahpb_1, string as_almacen, decimal adc_nro_copias);Long			ll_row, ll_i, ll_row_new
String		ls_cod_Art, ls_desc_art, ls_code_bar, ls_cod_sku, ls_flag_print_precio, ls_moneda, &
				ls_sub_cat_art, ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, &
				ls_cod_acabado, ls_color1

String		ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
				ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
				ls_linea1, ls_linea2, ls_mensaje

Decimal		ldc_precio_vta_unidad, ldc_talla
Date			ld_fec_ingreso
u_ds_base	ids_articulos

ids_articulos = create u_ds_base
ids_articulos.DataObject = 'd_lista_select_articulo_tbl'
ids_articulos.SetTransObject(SQLCA)

ids_articulos.Retrieve()

adw_report.Reset()

for ll_row = 1 to ids_articulos.Rowcount()
	
	yield()
	ls_cod_art 	= ids_articulos.object.cod_Art							[ll_row]
	
	//Obtengo los datos que necesito
		select  '*' || a.cod_sku || '*' as code_bar, 
				  a.cod_sku,
				  PKG_LOGISTICA.of_soles(null) as moneda,
				  a.precio_vta_unidad,
				  a2.desc_sub_cat,
				  a.desc_art
		into 	:ls_code_bar,
				:ls_cod_sku,
				:ls_moneda,
				:ldc_precio_vta_unidad,
				:ls_sub_cat_art,
				:ls_Desc_art
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
	
	
	ld_fec_ingreso 	= date(ids_articulos.object.fecha_ingreso							[ll_row])
	
	if SQLCA.SQLCOde < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
		return false
	end if
	
	//TRiplico la cantidad de estiquer de acuerdo a la cantidad recibida 
	
	for ll_i = 1 to Long(adc_nro_copias)
		ll_row_new = adw_report.InsertRow(0)
		
		if ll_row_new > 0 then
			
			//Armo las dos lineas necesarias
			ls_linea1 = ''
			if not IsNull(ls_sub_cat_art) and trim(ls_sub_cat_art) <> '' then
				ls_linea1 += trim(ls_sub_cat_art)
			end if

			//Armo las segunda linea
			ls_linea2 = ''
			if not IsNull(ls_Desc_art) and trim(ls_Desc_art) <> '' then
				ls_linea2 += trim(ls_Desc_art)
			end if
			
			adw_report.object.linea1 				[ll_row_new] = ls_linea1
			adw_report.object.linea2 				[ll_row_new] = ls_linea2
			adw_report.object.code_bar 			[ll_row_new] = ls_code_bar
			adw_report.object.cod_sku 				[ll_row_new] = ls_cod_sku
			
			adw_report.object.moneda 				[ll_row_new] = ls_moneda
			adw_report.object.precio_vta_unidad [ll_row_new] = ldc_precio_vta_unidad
			
			adw_report.object.fec_ingreso			[ll_row_new] = ld_fec_ingreso
			adw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)

			
			
		end if
		
		ahpb_1.Position = ll_row / ids_articulos.RowCount() * 100
		
		yield()
	next
	
	
	
next

adw_report.Sort()

return true
end function

public function str_articulo of_get_producibles ();Str_articulo 	lstr_articulo
str_parametros	lstr_param

lstr_param.array_clase [1] = is_clase_pptt
lstr_param.array_clase [2] = is_clase_prod_inter
lstr_param.array_clase [3] = is_clase_subprod
lstr_param.array_clase [4] = is_clase_descarte

OpenWithParm(w_search_articulos, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function string of_get_matriz_cntbl (string as_tipo_mov, string as_cencos, string as_cod_art) throws exception;/*
	Segun datos registrados, asigna matriz, la asigna es opcional
*/
string 		ls_grp_cntbl, ls_matriz, ls_contab, ls_sub_cat, ls_mensaje
Long 			ln_count, il_factor_prsp, ll_item
Exception 	ex


try 
	ex = create Exception
	
	if IsNull(as_tipo_mov) then 
		ex.setMessage('Tipo de movimiento es nulo')
		throw ex
	end if
	
	if IsNull(ls_sub_cat) then 
		ex.setMessage('Sub Categoria es nulo')
		throw ex
	end if
	
	
	select NVL(flag_contabiliza, '0'), NVL(FACTOR_PRESUP,0)
		into :ls_contab, :il_factor_prsp
	from articulo_mov_tipo
	where tipo_mov = :as_tipo_mov
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		ex.setMessage('No existe tipo de movimiento ' + as_tipo_mov)
		throw ex
	end if
	
	if ls_contab = '0' then return gnvo_app.is_null
	
	select sub_Cat_art
		into :ls_sub_cat
	from articulo
	where cod_art = :as_cod_art;
	
	if SQLCA.SQLCode = 100 then
		ex.setMessage('Codigo de Articulo ' + as_cod_art + ' no existe')
		throw ex
	end if
	
	if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
		ex.setMessage('No ha definido Codigo de Subcategoria en Articulo ' + as_cod_art)
		throw ex
	end if
	
	// Para ingresos, solo con el tipo de movimiento
	if il_factor_prsp = 0 then
		// Verifica que codigo exista
		Select matriz 
			into :ls_matriz 
		from tipo_mov_matriz_subcat
		Where tipo_mov    = :as_tipo_mov
		  and cod_sub_cat = :ls_sub_cat; 	
		  
		if sqlca.sqlcode = 100 then
			if IsNull(is_matriz_VS000) or trim(is_matriz_VS000) = '' then
				
				ex.setMessage( "Tipo de operación no tiene matriz. Coordine con contabilidad para que le asigne una matriz, debe brindarle la siguiente información: " &
									+ "~r~nTipo de Mov: " + trim(as_tipo_mov) &
									+ "~r~nSub Categoría: " + trim(ls_sub_cat))
									
				throw ex
			else
				//Si tiene una matriz por defecto entonces lo agrego simplemente
				if as_tipo_mov = gnvo_app.logistica.is_oper_ing_oc then
					ls_matriz = 'NI-001'
				else
					ls_matriz = is_matriz_VS000
				end if
				
				//Obtengo el siguiente item
				Select nvl(max(item), 0)
					into :ll_item
				from tipo_mov_matriz_subcat
				Where tipo_mov    = :as_tipo_mov
				  and cod_sub_cat = :ls_sub_cat; 
				
				ll_item ++
				
				//Obtengo el minimo grupo contable
				select min(grp_cntbl)
					into :ls_grp_cntbl
				from grupo_contable;
				
				insert into tipo_mov_matriz_subcat(
					tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
				values(
					:as_tipo_mov, :ls_grp_cntbl, :ls_sub_cat, :ll_item, :ls_matriz);
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrTExt
					ROLLBACK;
					ex.setMessage("Error al insertar tabla tipo_mov_matriz_subcat. Mensaje: " + ls_mensaje)
					throw ex
				end if
				
				invo_wait.of_mensaje( "Tipo de operación no tiene matriz. Se le va a asignar por defecto la matriz " + ls_matriz + ". Por favor brinde esta información a contabilidad: " &
									+ "~r~nTipo de Mov: " + trim(as_tipo_mov) &
									+ "~r~nSub Categoría: " + trim(ls_sub_cat))
			end if
		end if
		
	else		
		if IsNull(as_cencos) or trim(as_cencos) = '' then
			ex.SetMessage('Tipo de Movimiento afecta presupuesto y no ha ' &
						+ 'definido Centro de Costo')
			throw ex
		end if
		
		// Busca grp_cntbl segun centro de costo
		Select grp_cntbl 
			into :ls_grp_cntbl 
		from centros_costo
		where cencos = :as_cencos;	
	
		if sqlca.sqlcode = 100 then
			ex.setMessage( "Centro de Costos: " + as_cencos + " no existe")
			throw ex
		end if
		
		if trim(ls_grp_cntbl) = '' or IsNull(ls_grp_cntbl) then
			ex.setMessage( "Centro de Costos: " + as_cencos + " no tiene asignado " &
				+"un grupo contable")
			throw ex
		end if
	
		as_tipo_mov = TRIM(as_tipo_mov)
		ls_sub_cat 	= TRIM(ls_sub_cat)
		
		// Verifica que codigo exista	
		select count(*)
			into :ln_count
		from tipo_mov_matriz_subcat
		Where TRIM(tipo_mov)  	= :as_tipo_mov
		  and TRIM(grp_cntbl) 	= :ls_grp_cntbl
		  and TRIM(cod_sub_cat) = :ls_sub_cat;  	
		
		if ln_count = 1 then
			Select matriz  
				into :ls_matriz 
			from tipo_mov_matriz_subcat
			Where TRIM(tipo_mov)  	= :as_tipo_mov
			  and TRIM(grp_cntbl) 	= :ls_grp_cntbl
			  and TRIM(cod_sub_cat) = :ls_sub_cat;  
			
		elseif ln_count = 0 then		  
			
			if IsNull(is_matriz_VS000) or trim(is_matriz_VS000) = '' then

				ex.setMessage( "Tipo de operacion no tiene matriz. Coordinar con contabilidad y brindarle la siguiente informacion: " &
								+ '~r~n Tipo de Mov: ' + as_tipo_mov &
								+ '~r~n Grupo Contable: ' + ls_grp_cntbl &
								+ '~r~n Centro de Costo: ' + as_cencos &
								+ '~r~n Sub Categ: ' + ls_sub_cat &
								+ '~r~n Codigo Articulo: ' + as_cod_art)
				
				throw ex
				
			else
				//Si tiene una matriz por defecto entonces lo agrego simplemente
				if as_tipo_mov = gnvo_app.logistica.is_oper_ing_oc then
					ls_matriz = 'NI-001'
				else
					ls_matriz = is_matriz_VS000
				end if
				
				//Obtengo el siguiente item
				Select nvl(max(item), 0)
					into :ll_item
				from tipo_mov_matriz_subcat
				Where TRIM(tipo_mov)  	= :as_tipo_mov
			  	  and TRIM(grp_cntbl) 	= :ls_grp_cntbl
			  	  and TRIM(cod_sub_cat) = :ls_sub_cat;
				
				ll_item ++
				
				insert into tipo_mov_matriz_subcat(
					tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
				values(
					:as_tipo_mov, :ls_grp_cntbl, :ls_sub_cat, :ll_item, :ls_matriz);
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrTExt
					ROLLBACK;
					ex.setMessage("Error al insertar tabla tipo_mov_matriz_subcat. Mensaje: " + ls_mensaje)
					throw ex
				end if
				
				invo_wait.of_mensaje( "Tipo de operación no tiene matriz. Se le va a asignar por defecto la matriz " + ls_matriz + ". Por favor brinde esta información a contabilidad: " &
									+ '~r~n Tipo de Mov: ' + as_tipo_mov &
									+ '~r~n Grupo Contable: ' + ls_grp_cntbl &
									+ '~r~n Centro de Costo: ' + as_cencos &
									+ '~r~n Sub Categ: ' + ls_sub_cat &
									+ '~r~n Codigo Articulo: ' + as_cod_art)
			end if

		else
			
			invo_wait.of_mensaje("Se han asignado mas de una matriz en este Tipo de Mov...")
			
			Select matriz
				into :ls_matriz 
			from tipo_mov_matriz_subcat
			Where TRIM(tipo_mov)  	= :as_tipo_mov
			  and TRIM(grp_cntbl) 	= :ls_grp_cntbl
			  and TRIM(cod_sub_cat) = :ls_sub_cat
			order by item asc;  
		end if
	end if
	
	return ls_matriz
	
catch ( Exception e )
	throw e
finally
	invo_wait.of_close()
end try

end function

public function str_articulo of_get_articulos_user (string as_user);Str_articulo lstr_articulo
str_parametros lstr_param

lstr_param.string1 = 'clase'
lstr_param.string2 = as_user

OpenWithParm(w_pop_articulos, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function string of_get_foto (string as_cod_art);blob 			lbl_imagen
string		ls_mensaje, ls_path
Exception	ex

try 
	ex = create Exception
	
	selectblob imagen_blob
		into :lbl_imagen
		from vw_articulo a
	where cod_art = :as_cod_art;
	
	if SQLCA.SQLCode = 100 then
		SetNull(lbl_imagen)
	end if
	
	if SQLCA.SQlcode = -1 then
		ls_Mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex.setMessage('Error al recuperar foto de ARTICULO ' + as_cod_art + ". Mensaje: " + ls_mensaje)
		throw ex
	end if
	
	if IsNull(lbl_imagen) then return gnvo_app.is_null
	
	ls_path = gnvo_app.of_get_parametro("PATH_TEMPORAL", "i:\sigre_exe\fotos\temp")
	
	If not DirectoryExists ( ls_path ) Then
		if not invo_util.of_CreateDirectory( ls_path ) then 
			ROLLBACK;
			ex.setMessage('Error al crear directorio temporal ' + ls_path + ' para la foto de trabajador ' + as_cod_art)
			throw ex
		end if
	End If

	
	ls_path = ls_path + "\" + as_cod_art + ".png"
	
	if not invo_blob.of_write_blob(ls_path, lbl_Imagen) then
		return gnvo_app.is_null
	end if
	
	return ls_path

catch ( Exception e )
	throw e
	
finally
	destroy ex
end try


end function

public function string of_nro_vale_mov (string as_origen) throws exception;// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_mensaje, ls_nro_vale

try 
	
	select count(*)
		into :ll_count
	from num_vale_mov
	where origen = :as_origen;
	
	if ll_count = 0 then
		insert into num_vale_mov(origen, ult_nro)
		values( :as_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al momento de insertar registro en NUM_VALE_MOV. Mensaje: " + ls_mensaje, StopSign!)
			return gnvo_app.is_null
		end if
	end if
		
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_vale_mov
	where origen = :gs_origen for update;
	
	//Obtengo el nro del vale
	if gnvo_app.of_get_parametro('ALMACEN_NRO_VALE_MOV_HEXADECIMAL', '0') = '1' then
		ls_nro_vale = trim(as_origen) + invo_util.lpad(trim(invo_util.of_long2hex(ll_ult_nro)), 8, '0');
	else
		ls_nro_vale = trim(as_origen) + invo_util.lpad(trim(string(ll_ult_nro)), 8, '0');
	end if
	
	// Verifico qeu tl nro_vale no existe
  	select count(*)
		into :ll_count
	from vale_mov vm
	where vm.nro_vale = :ls_nro_vale;
               
   do WHILE ll_count > 0 
		ll_ult_nro ++
		
		//Obtengo el nro del vale
		if gnvo_app.of_get_parametro('ALMACEN_NRO_VALE_MOV_HEXADECIMAL', '0') = '1' then
			ls_nro_vale = trim(as_origen) + invo_util.lpad(trim(invo_util.of_long2hex(ll_ult_nro)), 8, '0');
		else
			ls_nro_vale = trim(as_origen) + invo_util.lpad(trim(string(ll_ult_nro)), 8, '0');
		end if
			
		// Verifico qeu tl nro_vale no existe
		select count(*)
		 into :ll_count
		 from vale_mov vm
		where vm.nro_vale = :ls_nro_vale;
			
	LOOP
	
	update num_vale_mov
		set ult_nro = :ll_ult_nro + 1
	where origen = :as_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al momento de insertar registro en NUM_VALE_MOV. Mensaje: " + ls_mensaje, StopSign!)
		return gnvo_app.is_null
	end if
	
	return ls_nro_Vale


catch ( Exception ex )
	gnvo_app.of_Catch_exception( ex, "Error en numeracion de VALE_MOV")
	return gnvo_app.is_null

end try

end function

public function str_articulo of_get_articulo_venta (string asi_almacen, string asi_tipo_doc);Str_articulo lstr_articulo
str_parametros lstr_param

if trim(asi_tipo_doc) = 'BVC' or trim(asi_tipo_doc) = 'FAC' then
	
	lstr_param.string1 = 'stock_facturable'
else
	lstr_param.string1 = 'stock'
end if

lstr_param.almacen = asi_almacen


if is_precarga = '1' then
	lstr_param.b_precarga = true
else
	lstr_param.b_precarga = false
end if

OpenWithParm(w_pop_articulos_venta, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function string of_get_foto_id (long al_idfoto);blob 			lbl_imagen
string		ls_mensaje, ls_path
Exception	ex

try 
	ex = create Exception
	
	selectblob imagen
		into :lbl_imagen
		from fotos.imagen_articulo a
	where id_foto = :al_idfoto;
	
	if SQLCA.SQLCode = 100 then
		SetNull(lbl_imagen)
	end if
	
	if SQLCA.SQlcode = -1 then
		ls_Mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex.setMessage('Error al recuperar foto de ARTICULO ' + string(al_idfoto) + ". Mensaje: " + ls_mensaje)
		throw ex
	end if
	
	if IsNull(lbl_imagen) then return gnvo_app.is_null
	
	ls_path = gnvo_app.of_get_parametro("PATH_TEMPORAL", "i:\sigre_exe\fotos\temp")
	
	If not DirectoryExists ( ls_path ) Then
		if not invo_util.of_CreateDirectory( ls_path ) then 
			ROLLBACK;
			ex.setMessage('Error al crear directorio temporal ' + ls_path + ' para la foto de trabajador ' + string(al_idfoto, '00000000'))
			throw ex
		end if
	End If

	ls_path = ls_path + "\" + string(al_idfoto, '00000000') + ".png"
	
	if not invo_blob.of_write_blob(ls_path, lbl_Imagen) then
		return gnvo_app.is_null
	end if
	
	return ls_path

catch ( Exception e )
	throw e
	
finally
	destroy ex
end try

end function

public function boolean of_rpt_codigos_cu (u_dw_rpt adw_report, hprogressbar ahpb_1, string as_almacen, decimal adc_nro_copias, string as_tipocopia);Long			ll_row, ll_i, ll_row_new, LL_idfoto
String		ls_cod_Art, ls_desc_art, ls_code_bar, ls_cod_sku, ls_flag_print_precio, ls_moneda, &
				ls_sub_cat_art, ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, &
				ls_cod_acabado, ls_color1, ls_cu, ls_nro_parte,ls_path,ls_foto

String		ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
				ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
				ls_linea1, ls_linea2, ls_mensaje,ls_code_qr, ls_qr

Decimal		ldc_precio_vta_unidad, ldc_talla
Date			ld_fec_ingreso, ld_fec_parte
n_cst_codeqr invo_codeqr
DECLARE CUR_FOTOS CURSOR FOR
		  select distinct A.id_foto
		  from   tg_parte_empaque_und teu,
					zc_parte_ingreso_und ziu,
					vw_articulo a
		  where teu.regkey = ziu.regkey
			 and ziu.nro_parte = :ls_nro_parte
			 AND EXISTS (SELECT 1 FROM TT_ART T WHERE T.CU = TEU.CODIGO_CU)
					and a.COD_ART = ziu.cod_art;
					
IF AS_TIPOCOPIA = 'G' THEN	
	OPEN CUR_FOTOS; 

		FETCH CUR_FOTOS INTO :ll_idfoto; 
		
		DO WHILE sqlca.sqlcode<>100 
			  ls_foto = gnvo_app.almacen.of_get_foto_id(ll_idfoto);
		
		FETCH CUR_FOTOS INTO :ll_idfoto; 
		
		LOOP 
		
		CLOSE CUR_FOTOS;
END IF	

try
ls_path = gnvo_app.of_get_parametro("PATH_TEMPORAL", "i:\sigre_exe\fotos\temp")
u_ds_base	ids_articulos

invo_codeqr = create n_cst_codeqr

ids_articulos = create u_ds_base
ids_articulos.DataObject = 'd_lista_select_articulo_tbl'
ids_articulos.SetTransObject(SQLCA)

ids_articulos.Retrieve()
adw_report.Reset()

for ll_row = 1 to ids_articulos.Rowcount()
	
	yield()
	ls_cod_art 	= ids_articulos.object.cod_Art						[ll_row]
	ls_cu 			= ids_articulos.object.cu								[ll_row]
	
	//Obtengo los datos que necesito
	if not IsNull(ls_cu)  then
		
		select u.nro_parte, p.fec_parte, d.cod_Art
		into :ls_nro_parte, :ld_fec_parte, :ls_cod_art
		from tg_parte_empaque_und u, zc_parte_ingreso p, zc_parte_ingreso_und d
		where u.codigo_cu = :ls_cu
     			 and d.regkey = u.regkey
				 and p.nro_parte = u.nro_parte;
		
	else
		return false;
	end if
	
	
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
				  a.talla,
				  m.nom_marca,
				  a1.abreviatura,
				  zl.abreviatura,
				  zs.abreviatura,
				  za.desc_acabado,
				  c1.descripcion,
				  c2.descripcion,
				  zsu.abreviatura,
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
			 zc_sublinea       zs,
			 marca              m,
			 zc_acabado         za,
			 color              c1,
			 color              c2,
			 zc_suela           zsu,
			 zc_taco            zt
		where a.cod_sublinea = zs.cod_sub_linea 	(+)
		 and a.cod_linea    = zl.cod_linea     	(+)
		 and a.cod_marca     = m.cod_marca      	(+)
		 and a.sub_cat_art   = a2.cod_sub_cat   	(+)
		 and a2.cat_art      = a1.cat_art       	(+)
		 and a.cod_acabado   = za.cod_acabado   	(+)
		 and a.color1        = c1.color         	(+)
		 and a.color2        = c2.color         	(+)
		 and a.cod_suela     = zsu.cod_suela    	(+)
	 	 and a.cod_taco      = zt.cod_taco      	(+)
	 	 and a.cod_art		 	= :ls_cod_art;
	
	
	ld_fec_ingreso 	= date(ids_articulos.object.fecha_ingreso							[ll_row])
	
	if SQLCA.SQLCOde < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
		return false
	end if
	
	//TRiplico la cantidad de estiquer de acuerdo a la cantidad recibida 
	
			
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
			/*
			if not IsNull(ls_estilo) and trim(ls_estilo) <> '' then
				ls_linea1 += ' ' + trim(ls_estilo)
			end if
			*/
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
			
			
			//Armo las dos lineas necesarias
				ls_code_qr = ''
				if not IsNull(ls_cu) and trim(ls_cu) <> '' then
					ls_code_qr += trim(ls_cu) + '|'
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
				
		
		ls_qr = invo_codeqr.of_generar_qrcode( ls_code_qr, ls_cu )	
				
		if as_tipocopia = 'G' then		
			
			    select nvl(id_foto,0)
				 into :ll_idfoto
				 from vw_Articulo a
				 where a.cod_sku = :ls_cod_sku;		
				 
				ls_foto 		= ls_path + "\" + string(ll_idfoto) + ".png"
		END IF
		
	for ll_i = 1 to Long(adc_nro_copias)
		ll_row_new = adw_report.InsertRow(0)
		
		if ll_row_new > 0 then
				adw_report.object.code_qr			[ll_row_new] = ls_qr
				adw_report.object.codigo_cu			[ll_row_new] = ls_cu
				adw_report.object.linea1 			[ll_row_new] = ls_linea1
				adw_report.object.linea2 			[ll_row_new] = ls_linea2 
				//adw_report.object.nro_parte			[ll_row_new] = ls_nro_parte
				adw_report.object.cod_moneda		[ll_row_new] = ls_moneda
				adw_report.object.cod_sku			[ll_row_new] = ls_cod_sku
				
				if as_tipocopia = 'P' then
					adw_report.object.estilo 			[ll_row_new] = ls_estilo
				else					
					adw_report.object.imagen_blob		[ll_row_new] = ls_foto					
					adw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)
					adw_report.object.fec_ingreso    [ll_row_new] = ld_fec_parte
				end if				
				
				//adw_report.object.precio_vta		[ll_row_new] = ldc_precio_vta_unidad
				
			if ls_flag_print_precio = '1' then
				adw_report.object.cod_moneda 				[ll_row_new] = ls_moneda				
				
				if as_tipocopia = 'P' then 
					adw_report.object.precio_vta [ll_row_new] =  ldc_precio_vta_unidad
				ELSE
					adw_report.object.precio_venta [ll_row_new] =  ldc_precio_vta_unidad
				END IF
			else
				adw_report.object.cod_moneda 				[ll_row_new] = gnvo_app.is_null
				/*if as_tipocopia = 'P' then 
					//adw_report.object.precio_vta [ll_row_new] =  gnvo_app.is_null
				ELSE
					adw_report.object.precio_venta [ll_row_new] =  gnvo_app.is_null
				END IF*/
			end if			
			
				adw_report.object.talla				[ll_row_new] = ldc_talla
		end if			
			
		if not isnull(ldc_talla) and ldc_talla <> 0 then
			adw_report.object.talla 					[ll_row_new] = ldc_talla
		end if			
		
		
		ahpb_1.Position = ll_row / ids_articulos.RowCount() * 100
		
		yield()
	next
		
next

adw_report.Sort()

return true

			
catch ( Exception e )
	throw e
	return false
end try
end function

public function boolean of_actualiza_saldos ();SetPointer (HourGlass!)

string 		ls_mensaje, ls_sql

try 
	SetPointer (HourGlass!)
	
	invo_wait.of_mensaje("Apagando Triggers de ARTICULO_MOV_PROY")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_MOV_PROY DISABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
		return false
	end if

	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE COMPRA")
	
	//Actualizo la cantidad procesada en Orden de compra
  	update articulo_mov_proy amp
    set amp.cant_procesada = ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov) +
                     (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                       from vale_mov_trans_det vtd,  
                          vale_mov_trans     vt,
                          articulo_mov_tipo  amt
                      where vtd.nro_vale  = vt.nro_vale
                        and vt.tipo_mov   = amt.tipo_mov
                        and vtd.flag_estado <> '0'
                        and vt.flag_estado  <> '0'
                        and vtd.org_amp_oc     = amp.cod_origen
                        and vtd.nro_amp_oc     = amp.nro_mov))
    where amp.cant_procesada <> ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov) +
                     (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                       from vale_mov_trans_det vtd,  
                          vale_mov_trans     vt,
                          articulo_mov_tipo  amt
                      where vtd.nro_vale  = vt.nro_vale
                        and vt.tipo_mov   = amt.tipo_mov
                        and vtd.flag_estado <> '0'
                        and vt.flag_estado  <> '0'
                        and vtd.org_amp_oc     = amp.cod_origen
                        and vtd.nro_amp_oc     = amp.nro_mov))
        and amp.tipo_doc = 'OC';
   
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE COMPRA. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE VENTA")
	
	//Actualizo la cantidad procesada en Orden de VENTA
  	update articulo_mov_proy amp
    set amp.cant_procesada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_procesada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OV';    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE VENTA. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;


  	invo_wait.of_mensaje("Actualizando cantidad FACTURADA de ORDEN DE VENTA")
	
	//Actualizo la cantidad facturada en Orden de VENTA
	update articulo_mov_proy amp
		set amp.cant_facturada = (select nvl(sum(ccd.cantidad * dt.factor), 0)
											 from cntas_cobrar cc,
													cntas_cobrar_det ccd,
													doc_tipo         dt
											where cc.tipo_doc = ccd.tipo_doc
											  and cc.nro_doc  = ccd.nro_doc
											  and cc.tipo_doc = dt.tipo_doc
											  and cc.flag_estado <> '0'
											  and ccd.org_amp_ref = amp.cod_origen
											  and ccd.nro_amp_ref = amp.nro_mov)
	where amp.tipo_doc = 'OV'
	  and amp.flag_estado <> '0'
	  amp.cant_facturada <> (select nvl(sum(ccd.cantidad * dt.factor), 0)
											 from cntas_cobrar cc,
													cntas_cobrar_det ccd,
													doc_tipo         dt
											where cc.tipo_doc = ccd.tipo_doc
											  and cc.nro_doc  = ccd.nro_doc
											  and cc.tipo_doc = dt.tipo_doc
											  and cc.flag_estado <> '0'
											  and ccd.org_amp_ref = amp.cod_origen
											  and ccd.nro_amp_ref = amp.nro_mov);

                                    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad FACTURADA en la ORDEN DE VENTA. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE TRABAJO")
	
	//Actualizo la cantidad procesada en Orden de VENTA
  	update articulo_mov_proy amp
    set amp.cant_procesada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_procesada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OT';    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE TRABAJO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad procesada de ORDEN DE TRASLADO")
	
	//Actualizo la cantidad procesada en Orden de TRASLADO
  	update articulo_mov_proy amp
    set amp.cant_procesada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'S03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_procesada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'S03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OTR';    

	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad procesada en la ORDEN DE TRASLADO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;
	
	invo_wait.of_mensaje("Actualizando cantidad FACTURADA de ORDEN DE TRASLADO")
	
	//Actualizo la cantidad facturada en Orden de TRASLADO
  	update articulo_mov_proy amp
    set amp.cant_facturada = (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'I03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
    where amp.cant_facturada <> (Select round(nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0),4)
                       from articulo_mov am,  
                          vale_mov     vm,
                          articulo_mov_tipo amt
                      where am.nro_Vale = vm.nro_vale
                        and vm.tipo_mov = amt.tipo_mov
                        and am.flag_estado <> '0'
                        and vm.flag_estado <> '0'
                        and vm.tipo_mov    = 'I03'
                        and am.origen_mov_proy = amp.cod_origen
                        and am.nro_mov_proy    = amp.nro_mov)
        and amp.tipo_doc = 'OTR';                 
        
											  
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No se puede actualizar la cantidad INGRESO en la ORDEN DE TRASLADO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	
	commit;
	
	invo_wait.of_mensaje("Activando Triggers de ARTICULO_MOV_PROY")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_MOV_PROY ENABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
	end if
	
	invo_wait.of_close()
	MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
	
	return true
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al procesar el saldo solicitado y por llegar")
	return false

finally
	
	invo_wait.of_mensaje("Activando Triggers de ARTICULO_MOV_PROY")
	
	//Apago el trigger;
	ls_sql = 'ALTER TABLE ARTICULO_MOV_PROY ENABLE ALL TRIGGERS'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
	end if
	
	invo_wait.of_close()

	SetPointer (Arrow!)
end try

end function

public function boolean of_rpt_codigos_barras_zc (u_dw_rpt adw_report, hprogressbar ahpb_1, string as_almacen, decimal adc_nro_copias);Long			ll_row, ll_i, ll_row_new
String		ls_cod_Art, ls_desc_art, ls_code_bar, ls_cod_sku, ls_flag_print_precio, ls_moneda, &
				ls_sub_cat_art, ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_suela, &
				ls_cod_acabado, ls_color1

String		ls_nom_marca, ls_abrev_categoria, ls_abrev_linea, ls_desc_sub_linea, &
				ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_suela, ls_desc_taco, &
				ls_linea1, ls_linea2, ls_mensaje

Decimal		ldc_precio_vta_unidad, ldc_talla
Date			ld_fec_ingreso
u_ds_base	ids_articulos

ids_articulos = create u_ds_base
ids_articulos.DataObject = 'd_lista_select_articulo_tbl'
ids_articulos.SetTransObject(SQLCA)

ids_articulos.Retrieve()

adw_report.Reset()

for ll_row = 1 to ids_articulos.Rowcount()
	
	yield()
	ls_cod_art 	= ids_articulos.object.cod_Art							[ll_row]
	
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
	
	
	ld_fec_ingreso 	= date(ids_articulos.object.fecha_ingreso							[ll_row])
	
	if SQLCA.SQLCOde < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error en la consulta ARTICULO. Mensaje: ' + ls_mensaje, Stopsign!)
		return false
	end if
	
	//TRiplico la cantidad de estiquer de acuerdo a la cantidad recibida 
	
	for ll_i = 1 to Long(adc_nro_copias)
		ll_row_new = adw_report.InsertRow(0)
		
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
			
			
			adw_report.object.linea1 				[ll_row_new] = ls_linea1
			adw_report.object.linea2 				[ll_row_new] = ls_linea2
			adw_report.object.code_bar 			[ll_row_new] = ls_code_bar
			adw_report.object.cod_sku 				[ll_row_new] = ls_cod_sku
			adw_report.object.flag_print_precio [ll_row_new] = ls_flag_print_precio
			
			if ls_flag_print_precio = '1' then
				adw_report.object.moneda 				[ll_row_new] = ls_moneda
				adw_report.object.precio_vta_unidad [ll_row_new] = ldc_precio_vta_unidad
			else
				adw_report.object.moneda 				[ll_row_new] = gnvo_app.is_null
				adw_report.object.precio_vta_unidad [ll_row_new] = gnvo_app.idc_null
			end if
			
			adw_report.object.sub_Cat_art 		[ll_row_new] = ls_sub_cat_art
			adw_report.object.cod_marca 			[ll_row_new] = ls_cod_marca
			adw_report.object.cod_sub_linea 		[ll_row_new] = ls_cod_sub_linea
			adw_report.object.estilo 				[ll_row_new] = ls_estilo
			adw_report.object.cod_suela 			[ll_row_new] = ls_cod_suela
			adw_report.object.cod_acabado 		[ll_row_new] = ls_cod_acabado
			adw_report.object.color1 				[ll_row_new] = ls_color1
			adw_report.object.fec_ingreso			[ll_row_new] = ld_fec_ingreso
			adw_report.object.cod_taco			[ll_row_new] = ls_desc_taco
			adw_report.object.siglas				[ll_row_new] = LEFT(gnvo_app.empresa.is_sigla,3)
			
			
			if not isnull(ldc_talla) and ldc_talla <> 0 then
				adw_report.object.talla 					[ll_row_new] = ldc_talla
			end if
			
			
		end if
		
		ahpb_1.Position = ll_row / ids_articulos.RowCount() * 100
		
		yield()
	next
	
	
	
next

adw_report.Sort()

return true
end function

public function string of_generar_qrcode (str_qrcode astr_param);String 	ls_ruc_emisor, ls_serie_guia, ls_nro_guia, ls_tipo_doc_ident, ls_nro_doc_ident, &
			ls_txt_code, ls_file_qr, ls_path, ls_nro_registro, ls_tipo_doc_sunat, ls_tipo_doc, &
			ls_nro_doc, ls_full_nro_doc, ls_mensaje
Date		ld_fecha_emision
Integer 	li_filenum

//Lleno los datos necesarios
ls_nro_registro	= astr_param.nro_registro
ls_ruc_emisor 		= astr_param.ruc_emisor
ls_tipo_doc_sunat = astr_param.tipo_doc_sunat
ls_tipo_doc			= astr_param.tipo_doc
ls_nro_doc			= astr_param.nro_doc
ls_serie_guia		= astr_param.serie
ls_nro_guia 		= astr_param.numero
ls_tipo_doc_ident = astr_param.tipo_doc_ident
ls_nro_doc_ident 	= astr_param.nro_doc_ident

ld_fecha_emision	= astr_param.fec_emision

select PKG_FACT_ELECTRONICA.of_get_full_nro(:ls_nro_doc)
	into :ls_full_nro_doc
from dual;

if SQLCA.SQLcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_app.of_mensaje_error("Error al ejecutar PKG_FACT_ELECTRONICA.of_get_full_nro(). Mensaje: " + ls_mensaje)
	return gnvo_app.is_null
end if


//Valido la información
if IsNull(ls_nro_doc_ident) or trim(ls_nro_doc_ident) = '' then
	MEssageBox('Error', 'El Cliente de la GUIA ' + ls_tipo_doc + ' ' + ls_serie_guia + '-' + ls_nro_guia &
					+ ' no tiene especificado un numero de documento de Identidad ' &
					+ '(RUC, DNI, OTROS), por favor corija', StopSign!)
	return gnvo_app.is_null
end if

//Genero el texto para codificar
ls_txt_code = ls_ruc_emisor + '|' + trim(ls_tipo_doc_sunat) + '|' + ls_serie_guia + '|' + ls_nro_guia + '|' &
				+ string(ld_fecha_emision, 'ddmmyyyy') + '|' + ls_tipo_doc_ident + '|' + ls_nro_doc_ident + '|' 

//Directorio donde se guardan los codeQR
ls_path = this.is_path_sigre + '\QR_CODE\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
		  + '\' + string(ld_fecha_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	
	if not invo_util.of_CreateDirectory( ls_path ) then return gnvo_app.is_null

End If

//Nombre del archivo 
ls_file_qr = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_full_nro_doc + '.bmp'


//Genero el codigo QR
FastQRCode(ls_txt_code, ls_file_qr)

If not FileExists ( ls_file_qr ) Then
	
	MEssageBox('Error', 'Ha ocurrido un error al generar el CODIGO QR ' + ls_file_qr + ', por favor corija', StopSign!)
	return gnvo_app.is_null
	
End If

return ls_file_qr
end function

public function boolean of_generar_pdf (str_qrcode astr_param, datawindow adw_report);String		ls_nro_registro, ls_path, ls_file_pdf, ls_tipo_doc_sunat, ls_serie_guia, ls_nro_guia, &
				ls_mensaje
Integer 		li_filenum
Date			ld_fec_emision
n_cst_email	lnv_email

lnv_email = CREATE n_cst_email
try
	//Lleno los datos necesarios
	ls_nro_registro	= astr_param.nro_registro
	ls_tipo_doc_sunat	= astr_param.tipo_doc_sunat
	ls_serie_guia		= astr_param.serie
	ls_nro_guia			= astr_param.numero
	ld_fec_emision		= astr_param.fec_emision
	
	//Directorio donde se guardan los PDF
	ls_path = this.is_path_sigre + '\EGUIA_PDF\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + string(ld_fec_emision, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
	
	If not DirectoryExists ( ls_path ) Then
		if not invo_util.of_CreateDirectory( ls_path ) then return false
		
	End If
	
	//Nombre del archivo  PDF
	ls_file_pdf = ls_path + trim(ls_tipo_doc_sunat) + '_' + ls_Serie_guia + "-" + ls_nro_guia + '.pdf'
	
	//Genero el PDF
	if not lnv_email.of_create_pdf( adw_report, ls_file_pdf) then return false
	
	return true

	
	
catch (Exception ex)
	MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_file_pdf + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
	
finally
	Destroy lnv_email
	
end try


end function

public function string of_get_firma_autorizado (string as_ini_file, string as_user);String ls_file
try 
	invo_inifile.of_set_inifile(as_ini_file)
	
	ls_file		 = invo_inifile.of_get_Parametro ( "Firma_digital_" + gs_empresa, "jefe_almacen", "I:\sigre_exe\FirmaDigital\FirmaAutorizado" + as_user + ".png ")

	return ls_file
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')
	return gnvo_app.is_null
	
end try

end function

public function string of_get_firma_usuario (string as_ini_file, string as_user);String ls_file
try 
	invo_inifile.of_set_inifile(as_ini_file)

	ls_file		 = invo_inifile.of_get_Parametro ( "FIRMA_USUARIO_" + gs_empresa, as_user, "I:\sigre_exe\FirmaDigital\FirmaUsuario" + as_user + ".png ")

	return ls_file
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')
	return gnvo_app.is_null
	
end try

end function

public function str_articulo of_get_articulo_bonif ();Str_articulo lstr_articulo
str_parametros lstr_param

lstr_param.string1 = 'bonif'

OpenWithParm(w_pop_articulos, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function boolean of_print_guia (string as_org_guia, string as_nro_guia);// Impresion de guia
String 		ls_full_nro_guia, ls_mensaje, ls_serie
Integer		li_opcion
u_ds_base 	lds_print

try 
	lds_print = create u_ds_base
	
	select PKG_FACT_ELECTRONICA.of_get_full_nro(:as_nro_guia)
	  into :ls_full_nro_guia
  	from dual;
	  
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al procesar la funcion  PKG_FACT_ELECTRONICA.of_get_full_nro(). Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	ls_serie = left(ls_full_nro_guia, 4)

	//Si la serie de la Guia de Remision comienza con T entonces electronica
	lds_print.DataObject = this.of_get_DataWindow(ls_serie)
	
	lds_print.SettransObject(sqlca)
	li_opcion = 1
	
	// Impresion de la guia 
	of_modify_ds(lds_print, li_opcion)
	
	//lds_print.object.datawindow.print.Paper.Size = 1
	lds_print.Retrieve(as_org_guia, as_nro_guia)

	IF lds_print.RowCount() = 0 then
		ROLLBACK;
		MessageBox('Aviso', "Error Al imprimir la guia " + ls_full_nro_guia + ". No existen registros para la GUIA DE REMISION", StopSign!)
		return false
	end if


	if lds_print.of_ExistePicture("p_logo") then
		lds_print.Object.p_logo.filename = gs_logo
	end if
	
	lds_print.print()
	
	
	// Actualiza fecha de impresion
	Update guia 
		set fec_impresion = sysdate
	 where cod_origen = :as_org_guia
		and nro_guia	= :as_nro_guia ;
		
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error Al imprimir la guia " + ls_full_nro_guia + ". Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	Commit;
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en funcion almacen.of_print_guia()')
finally
	destroy lds_print
end try


end function

public subroutine of_modify_ds (datastore ads_data, integer ai_opcion);string 	ls_inifile, ls_modify, ls_error
Long		ll_num_act, ll_i

ls_inifile = "i:\SIGRE_EXE\guia_remision" + string(ai_opcion) + ".ini"

if not FileExists(ls_inifile) then return

ll_num_act = Long(ProfileString(ls_inifile, "Total_lineas", 'Total', "0"))

for ll_i = 1 to ll_num_act
	ls_modify = ProfileString(ls_inifile, "Modify", 'Linea' + string(ll_i), "")
	if ls_modify <> "" then
		ls_error = ads_data.Modify(ls_modify)
		if ls_error <> '' then
			MessageBox('Error en Modify datastore', ls_Error + ' ls_modify: ' + ls_modify)
		end if
	end if
next

end subroutine

public function string of_get_datawindow (string as_serie);String ls_dataWindow

//Si la serie de la Guia de Remision comienza con T entonces electronica
if left(as_serie, 1) = 'T' then
	if UPPER(gs_empresa) = 'TRANSMARINA' then
		ls_dataWindow = 'd_rpt_guia_rem_elect_transmarina_tbl'
	else
		ls_dataWindow = 'd_rpt_guia_rem_electronica_tbl'
	end if
elseif UPPER(gs_empresa) = 'FISHOLG' then
	ls_dataWindow = 'd_rpt_guia_remision_fisholg'
elseif UPPER(gs_empresa) = 'BLUEWAVE' or UPPER(gs_empresa) = 'PEZEX' then
	ls_dataWindow = 'd_rpt_guia_remision_bw'
elseif UPPER(gs_empresa) = 'SEAFROST' or UPPER(gs_empresa) = 'DISTRIBUIDORA' then
	ls_dataWindow = 'd_rpt_guia_remision_seafrost_tbl'
elseif UPPER(gs_empresa) = 'TRANSMARINA' then
	ls_dataWindow = 'd_rpt_guia_remision_transmarina_tbl'
else
	ls_dataWindow = 'd_rpt_guia_remision'
end if

return ls_dataWindow
end function

public function boolean of_print_vale (string as_nro_vale);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen, ls_tipo_mov
u_ds_base		lds_print


try 
	
	select al.flag_tipo_almacen, vm.tipo_mov
	  into :ls_tipo_almacen, :ls_tipo_mov
	  from vale_mov				vm,
	  		 articulo_mov_tipo 	amt,
			 almacen					al
	where vm.tipo_mov		= amt.tipo_mov
	  and vm.almacen		= al.almacen
	  and vm.nro_Vale		= :as_nro_Vale;
	
	
	lds_print = create u_ds_base
	
	
	if gnvo_app.almacen.is_despacho_POST_vta = '0' then
	
		
		
		if ls_tipo_almacen = 'T' then
			//Corresponde a un almacen de Productos Terminados
			if gs_empresa = 'SEAFROST' then
				lds_print.DataObject 	= 'd_frm_movimiento_almacen_seafrost_pptt'
			else
				lds_print.DataObject 		= 'd_frm_movimiento_almacen_pptt'
			end if
		else
			if gs_empresa = 'SEAFROST' then
				lds_print.DataObject		= 'd_frm_movimiento_almacen_seafrost_tbl'
				
			elseif gs_empresa = 'CANTABRIA' or gnvo_app.of_get_parametro("MOV_ALMACEN_UBICACION", "0") = '1' THEN
				
				lds_print.DataObject 		= 'd_frm_movimiento_alm_cantabria'
				
			elseif gnvo_app.of_get_parametro("ALMACEN_INGRESOS_COSTO", "0") = '1' &
				 or (gs_empresa = 'SUCESION' or gs_empresa = 'BOGACCI' or gs_empresa = 'MINKA' or gs_empresa = 'OPEN')  THEN
				 
				if left(ls_tipo_mov, 1) = 'I' then
					lds_print.DataObject 		= 'd_frm_ingreso_almacen_costo_tbl'
				else
					lds_print.DataObject		= 'd_frm_movimiento_almacen'
				end if
			else
				lds_print.DataObject 		= 'd_frm_movimiento_almacen'
			end if
		end if
		
		lds_print.setTransObject(SQLCA)
		lds_print.Retrieve(as_nro_Vale)
		
		if lds_print.RowCount() > 0 then
		
			lds_print.print()
		end if
		
	end if
	
	return true

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al imprimir mov almacen")
finally
	destroy lds_print
end try
end function

public function boolean of_print_vales_from_guia (string as_nro_guia);// Impresion de guia
String 		ls_full_nro_guia, ls_mensaje
Integer		li_i
u_ds_base 	lds_lista_Vales

try 
	lds_lista_Vales = create u_ds_base
	
	select PKG_FACT_ELECTRONICA.of_get_full_nro(:as_nro_guia)
	  into :ls_full_nro_guia
  	from dual;
	  
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al procesar la funcion  PKG_FACT_ELECTRONICA.of_get_full_nro(). Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	

	//Si la serie de la Guia de Remision comienza con T entonces electronica
	lds_lista_Vales.DataObject = 'd_lista_vale_mov_guia_tbl'
	
	lds_lista_Vales.setTransObject(SQLCA)
	lds_lista_Vales.REtrieve(as_nro_guia)
	
	for li_i = 1 to lds_lista_Vales.RowCount()
		//Imprimo los vales dentro de la lista
		this.of_print_Vale(lds_lista_Vales.object.nro_Vale[li_i])
	next
	
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en funcion almacen.of_print_guia()')
finally
	destroy lds_lista_Vales
end try


end function

public function str_articulo of_get_articulos_activos ();Str_articulo lstr_articulo
str_parametros lstr_param

lstr_param.string1 = 'activos'

OpenWithParm(w_pop_articulos, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_articulo.b_return = false
	return lstr_articulo
end if

lstr_articulo = Message.PowerObjectParm

return lstr_articulo
end function

public function boolean of_create_only_xml (string as_nro_guia) throws exception;boolean 	lb_return
String	ls_version_ubl



lb_return = this.of_generar_xml_gre( as_nro_guia )

if not lb_return then
	rollback;
	return false
end if


return true
end function

public function boolean of_generar_xml_gre (string asi_nro_guia);//Datos de Cabecera
String 	ls_nro_guia, ls_tipo_doc, ls_serie_guia, ls_numero_guia, ls_full_nro_guia, ls_filename_xml, ls_nro_envio_id, &
			ls_issue_Time, ls_issue_date, ls_glosa

Date		ld_fec_emision
			
//Otras variables
Long		ll_LineCountNumeric
String	ls_mensaje, ls_texto, ls_FullPathFileXML
			
			

//Configuro el dataStore para el resumen diario
ids_guia.dataobject = 'd_guias_remision_det_tbl'
ids_guia.setTransObject( SQLCA )
ids_guia.REtrieve(gs_empresa, asi_nro_guia)

ll_LineCountNumeric = ids_guia.RowCount()

if ll_LineCountNumeric = 0 then 
	MessageBox('Funcion n_cst_almacen.of_generar_xml_gre()', 'No hay detalle para la guia de remisión ' + asi_nro_guia, Information!)
	return false
end if

//Datos de cabecera
ls_tipo_doc 		= ids_guia.object.Type_Code 			[1]
ls_full_nro_guia	= ids_guia.object.full_nro_guia 		[1]
ls_serie_guia		= ids_guia.object.serie_guia 			[1]
ls_numero_guia		= ids_guia.object.numero_guia 		[1]
ls_nro_envio_id	= ids_guia.object.nro_Envio_id 		[1]
ls_issue_Time		= ids_guia.object.issue_time 			[1]
ls_issue_date		= ids_guia.object.issue_date 			[1]
ls_glosa				= ids_guia.object.glosa		 			[1]
ld_Fec_emision		= Date(ids_guia.object.fec_registro [1])

if IsNull(ls_glosa) or trim(ls_glosa) = '' then
	ls_glosa = 'SIN OBSERVACIONES'
end if

//SQL> DESC SUNAT_ENVIO_CE
//Name         Type         Nullable Default Comments 
//------------ ------------ -------- ------- -------- 
//NRO_ENVIO_ID CHAR(10)                               
//FILENAME_XML VARCHAR2(40) Y                         
//FEC_REGISTRO DATE         Y                         
//FEC_EMISION  DATE         Y                         
//COD_USR      CHAR(6)      Y                         
//NRO_TICKET   VARCHAR2(20) Y                         
//DATA_XML     BLOB         Y                         
//DATA_CDR     BLOB         Y 

//Genero el nro_rc
ls_filename_xml = gnvo_app.empresa.is_ruc + "-" + ls_tipo_doc + "-" + ls_serie_guia + "-" + ls_numero_guia

if IsNull(ls_nro_envio_id) or trim(ls_nro_envio_id) = '' then
	
	//Inserto en la tabla de SUNAT_RC_DIARIO
	ls_NRO_ENVIO_ID = invo_util.of_set_numera( "SUNAT_ENVIO_CE" )
	
	if IsNull(ls_NRO_ENVIO_ID) or trim(ls_NRO_ENVIO_ID) = '' then return false
	
	Insert into SUNAT_ENVIO_CE( 
		NRO_ENVIO_ID, FILENAME_XML, FEC_REGISTRO, FEC_EMISION, COD_USR)
	values(
		:ls_NRO_ENVIO_ID, :ls_filename_xml, sysdate, :ld_fec_emision, :gs_user);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if

end if

/*******************************************/
//Elimino el archivo XML en caso de existir
/*******************************************/
if invo_xml.of_FileExists_XML(ls_filename_xml, ld_Fec_emision) then
	if not invo_xml.of_FileDelete_XML(ls_filename_xml, ld_Fec_emision) then
		rollbacK;
		MessageBox('Error', 'No se ha podido eliminar el archivo: ' + ls_filename_xml + ', por favor verifique!', StopSign!)
		return false
	end if
end if


/************************************/
//Genero el XML
/************************************/

//Primera Linea
ls_texto = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>'
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if

//Linea 1 = DAtos Iniciales
ls_texto = of_GRE_OpenDespatchAdvice(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 2 = Anclaje para el certificado digital
ls_texto = of_gre_UBLExtensions(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 3 = Datos de la cabecera de la GUIA
ls_texto = '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' + char(13) + char(10) &
			+ '	<cbc:CustomizationID>2.0</cbc:CustomizationID>' + char(13) + char(10) &
			+ '	<cbc:ID>' + ls_serie_guia + "-" + ls_numero_guia + '</cbc:ID>' + char(13) + char(10) &
			+ '	<cbc:IssueDate>' + ls_issue_date + '</cbc:IssueDate>' + char(13) + char(10) &
			+ '	<cbc:IssueTime>' + ls_issue_time + '</cbc:IssueTime>' + char(13) + char(10) &
			+ '	<cbc:DespatchAdviceTypeCode>' + ls_tipo_Doc + '</cbc:DespatchAdviceTypeCode>' + char(13) + char(10) &
			+ '	<cbc:Note><![CDATA[' + ls_glosa + ']]></cbc:Note>' + char(13) + char(10) &
			+ '	<cbc:LineCountNumeric>' + string(ll_LineCountNumeric) + '</cbc:LineCountNumeric>'

if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 4 = Datos del documento de referencia
ls_texto = this.of_GRE_AdditionalDocumentReference(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 5 = Signature
ls_texto = this.of_GRE_Signature(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 6 = DespatchSupplierParty
ls_texto = this.of_GRE_DespatchSupplierParty(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 7 = DeliveryCustomerParty
ls_texto = this.of_GRE_DeliveryCustomerParty(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 8 = Shipment
ls_texto = this.of_GRE_Shipment(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 9 = Detalle de la Guia - DespatchLine
ls_texto = this.of_GRE_DespatchLine(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if


//Linea 10 = Cierro el documento
ls_texto = of_gre_CloseDespatchAdvice(ids_guia)
if trim(ls_texto) <> '' then
	if not invo_xml.of_write_ce_fs( ls_filename_xml, ls_texto, ld_Fec_emision) then 
		ROLLBACK;
		return false
	end if
end if



//actualizo el nro_rc en la tabla GUIA
update guia
  set NRO_ENVIO_ID = :ls_nro_envio_id
 where nro_guia	 = :asi_nro_guia;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en GUIA. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

//Guardo la ruta completa del archivo en la tabla SUNAT_ENVIO_CE
ls_FullPathFileXML = invo_xml.of_get_pathFileXML_FS( ls_filename_xml, ld_Fec_emision)

update SUNAT_ENVIO_CE
   set path_file = :ls_FullPathFileXML
 where nro_envio_id = :ls_nro_envio_id;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', 'Error al actualizar registro en SUNAT_ENVIO_CE. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if


//Guardo los cambios
commit;

return true
end function

public function string of_gre_additionaldocumentreference (u_ds_base ads_guia);String ls_texto, ls_tipo_doc_ref, ls_nro_doc_ref, ls_glosa_Ref, ls_ruc_dni_ref, ls_tipo_doc_ident

if ads_guia.rowCount() = 0 then 
	return '' 
end if

ls_tipo_doc_ref 	= ads_guia.object.type_cod_ref 			[1]
ls_nro_doc_ref 	= ads_guia.object.nro_doc_ref 			[1]
ls_glosa_Ref 		= ads_guia.object.glosa_ref 				[1]
ls_tipo_doc_ident	= ads_guia.object.tipo_doc_ident_ref 	[1]
ls_ruc_dni_ref 	= ads_guia.object.ruc_dni_ref 			[1]

//' + char(13) + char(10) &

if IsNull(ls_tipo_doc_ref) then ls_tipo_doc_ref = '' 
if IsNull(ls_nro_doc_ref) then ls_nro_doc_ref = '' 
if IsNull(ls_glosa_Ref) then ls_glosa_Ref = '' 
if IsNull(ls_tipo_doc_ident) then ls_tipo_doc_ident = '' 
if IsNull(ls_ruc_dni_ref) then ls_ruc_dni_ref = '' 

if trim(ls_tipo_doc_ref) = '' or trim(ls_nro_doc_ref) = '' then 
	return ''
end if

ls_texto = '	<cac:AdditionalDocumentReference>' + char(13) + char(10) &
			+ '        <cbc:ID>' + ls_nro_doc_ref + '</cbc:ID>' + char(13) + char(10) &
			+ '        <cbc:DocumentTypeCode>' + ls_tipo_doc_ref + '</cbc:DocumentTypeCode>' + char(13) + char(10) &
			+ '        <cbc:DocumentType>' + ls_glosa_ref + '</cbc:DocumentType>' + char(13) + char(10) &
			+ '        <cac:IssuerParty>' + char(13) + char(10) &
			+ '            <cac:PartyIdentification>' + char(13) + char(10) &
			+ '                <cbc:ID schemeID="' + ls_tipo_doc_ident + '">' + ls_ruc_dni_ref + '</cbc:ID>' + char(13) + char(10) &
			+ '            </cac:PartyIdentification>' + char(13) + char(10) &
			+ '        </cac:IssuerParty>' + char(13) + char(10) &
			+ '    </cac:AdditionalDocumentReference>'

return ls_texto
end function

public function string of_gre_signature (u_ds_base ads_guia);String ls_texto, ls_ruc_remitente, ls_razon_social_Remitente

if ads_guia.rowCount() = 0 then 
	return '' 
end if

ls_ruc_remitente 				= ads_guia.object.ruc_remitente 				[1]
ls_razon_social_Remitente 	= ads_guia.object.razon_social_Remitente 	[1]

//' + char(13) + char(10) &

ls_texto = '    <cac:Signature>' + char(13) + char(10) &
			+ '        <cbc:ID>IDSignKG</cbc:ID>' + char(13) + char(10) &
			+ '        <cac:SignatoryParty>' + char(13) + char(10) &
			+ '            <cac:PartyIdentification>' + char(13) + char(10) &
			+ '                <cbc:ID>' + ls_ruc_remitente + '</cbc:ID>' + char(13) + char(10) &
			+ '            </cac:PartyIdentification>' + char(13) + char(10) &
			+ '            <cac:PartyName>' + char(13) + char(10) &
			+ '                <cbc:Name>' + ls_razon_social_Remitente + '</cbc:Name>' + char(13) + char(10) &
			+ '            </cac:PartyName>' + char(13) + char(10) &
			+ '        </cac:SignatoryParty>' + char(13) + char(10) &
			+ '        <cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '            <cac:ExternalReference>' + char(13) + char(10) &
			+ '                <cbc:URI>#SignST</cbc:URI>' + char(13) + char(10) &
			+ '            </cac:ExternalReference>' + char(13) + char(10) &
			+ '        </cac:DigitalSignatureAttachment>' + char(13) + char(10) &
			+ '    </cac:Signature>'

return ls_texto
end function

public function string of_gre_ublextensions (u_ds_base ads_guia);String ls_texto, ls_issue_date

if ads_guia.rowCount() = 0 then 
	return '' 
end if

ls_issue_date 				= ads_guia.object.issue_date 				[1]


//' + char(13) + char(10) &

ls_texto = '    <ext:UBLExtensions>' + char(13) + char(10) &
			+ '        <ext:UBLExtension>' + char(13) + char(10) &
			+ '            <cbc:ID>GUIAFECHAENTREGA</cbc:ID>' + char(13) + char(10) &
			+ '            <ext:ExtensionContent>' + char(13) + char(10) &
			+ '                <cbc:nameType><![CDATA[' + ls_issue_date + ']]></cbc:nameType>' + char(13) + char(10) &
			+ '            </ext:ExtensionContent>' + char(13) + char(10) &
			+ '        </ext:UBLExtension>' + char(13) + char(10) &
			+ '		<ext:UBLExtension>' + char(13) + char(10) &
			+ '			<ext:ExtensionContent>' + char(13) + char(10) &
			+ '			</ext:ExtensionContent>' + char(13) + char(10) &
			+ '		</ext:UBLExtension>' + char(13) + char(10) &
			+ '	</ext:UBLExtensions>'

return ls_texto
end function

public function string of_gre_opendespatchadvice (u_ds_base ads_guia);String ls_texto

if ads_guia.rowCount() = 0 then 
	return '' 
end if

//' + char(13) + char(10) &

ls_texto = '<DespatchAdvice xmlns="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" ' + char(13) + char(10) &
			+ '	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' + char(13) + char(10) &
			+ '	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' + char(13) + char(10) &
			+ '	xmlns:ds="http://www.w3.org/2000/09/xmldsig#" ' + char(13) + char(10) &
			+ '	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" ' + char(13) + char(10) &
			+ '	xmlns:ns11="urn:sunat:names:specification:ubl:peru:schema:xsd:SummaryDocuments-1" ' + char(13) + char(10) &
			+ '	xmlns:ns12="urn:sunat:names:specification:ubl:peru:schema:xsd:VoidedDocuments-1" ' + char(13) + char(10) &
			+ '	xmlns:ns13="urn:sunat:names:specification:ubl:peru:schema:xsd:Retention-1" ' + char(13) + char(10) &
			+ '	xmlns:ns5="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" ' + char(13) + char(10) &
			+ '	xmlns:ns6="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" ' + char(13) + char(10) &
			+ '	xmlns:ns7="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2" ' + char(13) + char(10) &
			+ '	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" ' + char(13) + char(10) &
			+ '	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1">'


return ls_texto
end function

public function string of_gre_closedespatchadvice (u_ds_base ads_guia);String ls_texto

if ads_guia.rowCount() = 0 then 
	return '' 
end if

//' + char(13) + char(10) &

ls_texto = '</DespatchAdvice>'


return ls_texto
end function

public function string of_gre_despatchsupplierparty (u_ds_base ads_guia);String 	ls_texto,  ls_ruc_remitente, ls_razon_social_remitente, ls_ubigeo_remitente, &		
			ls_direccion_remitente, ls_urbanizacion_remitente, ls_distrito_remitente, &
			ls_provincia_remitente, ls_departamento_remitente, ls_pais_remitente


if ads_guia.rowCount() = 0 then 
	return '' 
end if

ls_ruc_remitente 				= ads_guia.object.ruc_remitente 				[1]
ls_razon_social_Remitente 	= ads_guia.object.razon_social_Remitente 	[1]
ls_ubigeo_remitente 			= ads_guia.object.ubigeo_remitente 			[1]
ls_direccion_remitente 		= ads_guia.object.direccion_remitente 		[1]
ls_urbanizacion_remitente 	= ""
ls_distrito_remitente 		= ads_guia.object.distrito_remitente 		[1]
ls_provincia_remitente 		= ads_guia.object.provincia_remitente 		[1]
ls_departamento_remitente 	= ads_guia.object.departamento_remitente 	[1]
ls_pais_remitente 			= ads_guia.object.pais_remitente 			[1]



//' + char(13) + char(10) &

ls_texto = '    <cac:DespatchSupplierParty>' + char(13) + char(10) &
			+ '        <cac:Party>' + char(13) + char(10) &
			+ '            <cac:PartyIdentification>' + char(13) + char(10) &
			+ '                <cbc:ID schemeID="6">' + ls_ruc_remitente + '</cbc:ID>' + char(13) + char(10) &
			+ '            </cac:PartyIdentification>' + char(13) + char(10) &
			+ '            <cac:PostalAddress>' + char(13) + char(10) &
			+ '                <cbc:ID>' + ls_ubigeo_remitente + '</cbc:ID>' + char(13) + char(10) &
			+ '                <cbc:StreetName>' + ls_direccion_remitente + '</cbc:StreetName>' + char(13) + char(10) &
			+ '                <cbc:CitySubdivisionName>' + ls_urbanizacion_remitente +'</cbc:CitySubdivisionName>' + char(13) + char(10) &
			+ '                <cbc:CityName>' + ls_provincia_remitente + '</cbc:CityName>' + char(13) + char(10) &
			+ '                <cbc:CountrySubentity>' + ls_departamento_remitente + '</cbc:CountrySubentity>' + char(13) + char(10) &
			+ '                <cbc:District>' + ls_distrito_remitente + '</cbc:District>' + char(13) + char(10) &
			+ '                <cac:Country>' + char(13) + char(10) &
			+ '                    <cbc:IdentificationCode>' + ls_pais_remitente + '</cbc:IdentificationCode>' + char(13) + char(10) &
			+ '                </cac:Country>' + char(13) + char(10) &
			+ '            </cac:PostalAddress>' + char(13) + char(10) &
			+ '            <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '                <cbc:RegistrationName>' + ls_razon_social_remitente + '</cbc:RegistrationName>' + char(13) + char(10) &
			+ '            </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '        </cac:Party>' + char(13) + char(10) &
			+ '    </cac:DespatchSupplierParty>'

return ls_texto
end function

public function string of_gre_deliverycustomerparty (u_ds_base ads_guia);String ls_texto, ls_ruc_dni_cliente, ls_razon_social_cliente, ls_tipo_doc_cliente, ls_email_cliente

if ads_guia.rowCount() = 0 then 
	return '' 
end if

ls_ruc_dni_cliente 			= ads_guia.object.ruc_dni_cliente 	[1]
ls_razon_social_cliente 	= ads_guia.object.nom_cliente 		[1]
ls_tipo_doc_cliente 			= ads_guia.object.tipo_doc_cliente 	[1]
ls_email_cliente 				= ads_guia.object.email_cliente 		[1]

if IsNull(ls_ruc_dni_cliente) then ls_ruc_dni_cliente = '' 
if IsNull(ls_razon_social_cliente) then ls_razon_social_cliente = '' 
if IsNull(ls_tipo_doc_cliente) then ls_tipo_doc_cliente = '' 
if IsNull(ls_email_cliente) then ls_email_cliente = '' 


//' + char(13) + char(10) &

ls_texto = '    <cac:DeliveryCustomerParty>' + char(13) + char(10) &
			+ '        <cbc:CustomerAssignedAccountID schemeID="' + ls_tipo_doc_cliente + '">' + ls_ruc_dni_cliente + '</cbc:CustomerAssignedAccountID>' + char(13) + char(10) &
			+ '        <cac:Party>' + char(13) + char(10) &
			+ '            <cac:PartyIdentification>' + char(13) + char(10) &
			+ '                <cbc:ID schemeAgencyName="PE:SUNAT" schemeID="' + ls_tipo_doc_cliente + '" schemeName="Documento de Identidad" schemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06">' + ls_ruc_dni_cliente + '</cbc:ID>' + char(13) + char(10) &
			+ '            </cac:PartyIdentification>' + char(13) + char(10) &
			+ '            <cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '                <cbc:RegistrationName><![CDATA[' + ls_razon_social_cliente + ']]></cbc:RegistrationName>' + char(13) + char(10) &
			+ '            </cac:PartyLegalEntity>' + char(13) + char(10) &
			+ '				<cac:Contact>' + char(13) + char(10) &
			+ '            	<cbc:ElectronicMail>' + ls_email_cliente + '</cbc:ElectronicMail>' + char(13) + char(10) &
			+ '            </cac:Contact>' + char(13) + char(10) &
			+ '        </cac:Party>' + char(13) + char(10) &
			+ '    </cac:DeliveryCustomerParty>'

return ls_texto
end function

public function string of_gre_shipment (u_ds_base ads_guia);String 	ls_texto, ls_cod_motivo_traslado, ls_Handling_Instructions, ls_und_peso, &
			ls_ruc_remitente, ls_ModoTransporte, ls_start_date
Decimal	ldc_peso_neto

//Datos del chofer
String	ls_tipo_doc_chofer, ls_dni_chofer, ls_nom_chofer, ls_apell_chofer, ls_nro_brevete, ls_nro_placa

//Transportista
String 	ls_cert_insc_mtc, ls_tipo_doc_transp, ls_ruc_dni_transp, ls_nom_transportita, &
			ls_nro_autor_especial, ls_cod_entidad_autorizada

// Datos punto de llegada
String 	ls_ubigeo_destino, ls_direccion_destino, ls_distrito_destino, ls_provincia_destino, &
			ls_departamento_destino, ls_urbanizacion_destino, ls_pais_destino

// Datos punto de partida
String 	ls_ubigeo_partida, ls_direccion_partida, ls_distrito_partida, ls_provincia_partida, &
			ls_departamento_partida, ls_urbanizacion_partida, ls_pais_partida

if ads_guia.rowCount() = 0 then 
	return '' 
end if

ls_ruc_dni_transp 			= ads_guia.object.ruc_dni_transp 		[1]
ls_ruc_remitente 				= ads_guia.object.ruc_remitente 			[1]
ls_cod_motivo_traslado 		= ads_guia.object.cod_motivo_traslado 	[1]
ls_Handling_Instructions 	= ads_guia.object.Handling_Instructions[1]
ls_start_date					= ads_guia.object.start_date				[1]
ls_und_peso						= "TNE"
ldc_peso_neto					= Dec(ads_guia.object.peso_neto_tm 		[1])

if IsNull(ldc_peso_neto) or ldc_peso_neto = 0 then
	ldc_peso_neto 	= 1
	ls_und_peso		= "KGM"
end if

if IsNull(ls_ruc_dni_transp) or trim(ls_ruc_dni_transp) = trim(ls_ruc_remitente) then
	ls_ModoTransporte = '02'
else
	ls_ModoTransporte = '01'
end if

//Datos del Chofer
ls_tipo_doc_chofer 			= ads_guia.object.tipo_doc_chofer[1]
ls_dni_chofer 					= ads_guia.object.dni_chofer 		[1]
ls_nom_chofer 					= ads_guia.object.nom_chofer 		[1]
ls_apell_chofer 				= ads_guia.object.apell_chofer 	[1]
ls_nro_brevete					= ads_guia.object.nro_brevete 	[1]
ls_nro_placa					= ads_guia.object.nro_placa 		[1]

if IsNull(ls_tipo_doc_chofer) then ls_tipo_doc_chofer = '' 
if IsNull(ls_dni_chofer) then ls_dni_chofer = '' 
if IsNull(ls_nom_chofer) then ls_nom_chofer = '' 
if IsNull(ls_apell_chofer) then ls_apell_chofer = '' 
if IsNull(ls_nro_brevete) then ls_nro_brevete = '' 
if IsNull(ls_nro_placa) then ls_nro_placa = '' 

//Datos del punto de partida
ls_ubigeo_partida				= ads_guia.object.ubigeo_partida 		[1]
ls_direccion_partida			= ads_guia.object.direccion_partida 	[1]
ls_distrito_partida			= ads_guia.object.distrito_partida 		[1]
ls_provincia_partida			= ads_guia.object.provincia_partida 	[1]
ls_departamento_partida		= ads_guia.object.departamento_partida [1]
ls_urbanizacion_partida		= ''
ls_pais_partida				= 'PE'


if IsNull(ls_ubigeo_partida) then ls_ubigeo_partida = '' 
if IsNull(ls_direccion_partida) then ls_direccion_partida = '' 
if IsNull(ls_distrito_partida) then ls_distrito_partida = '' 
if IsNull(ls_provincia_partida) then ls_provincia_partida = '' 
if IsNull(ls_departamento_partida) then ls_departamento_partida = '' 

//Datos del punto de llegada
ls_ubigeo_destino				= ads_guia.object.ubigeo_destino 		[1]
ls_direccion_destino			= ads_guia.object.direccion_destino 	[1]
ls_distrito_destino			= ads_guia.object.distrito_destino 		[1]
ls_provincia_destino			= ads_guia.object.provincia_destino 	[1]
ls_departamento_destino		= ads_guia.object.departamento_destino [1]
ls_urbanizacion_destino		= ''
ls_pais_destino				= 'PE'

if IsNull(ls_ubigeo_destino) then ls_ubigeo_destino = '' 
if IsNull(ls_direccion_destino) then ls_direccion_destino = '' 
if IsNull(ls_distrito_destino) then ls_distrito_destino = '' 
if IsNull(ls_provincia_destino) then ls_provincia_destino = '' 
if IsNull(ls_departamento_destino) then ls_departamento_destino = '' 


//DAtos del Transportista
ls_cert_insc_mtc				= ads_guia.object.cert_insc_mtc 				[1]
ls_tipo_doc_transp			= ads_guia.object.tipo_doc_transp 			[1]
ls_ruc_dni_transp				= ads_guia.object.ruc_dni_transp 			[1]
ls_nom_transportita			= ads_guia.object.nom_transportita 			[1]
ls_nro_autor_especial		= ads_guia.object.nro_autor_especial 		[1]
ls_cod_entidad_autorizada	= ads_guia.object.cod_entidad_autorizada 	[1]


if IsNull(ls_cert_insc_mtc) then ls_cert_insc_mtc = '' 
if IsNull(ls_tipo_doc_transp) then ls_tipo_doc_transp = '' 
if IsNull(ls_ruc_dni_transp) then ls_ruc_dni_transp = '' 
if IsNull(ls_nom_transportita) then ls_nom_transportita = '' 
if IsNull(ls_nro_autor_especial) then ls_nro_autor_especial = ''  
if IsNull(ls_cod_entidad_autorizada) then ls_cod_entidad_autorizada = '' 



//' + char(13) + char(10) &

ls_texto = '    <cac:Shipment>' + char(13) + char(10) &
			+ '        <cbc:ID>SUNAT_Envio</cbc:ID>' + char(13) + char(10) &
			+ '        <cbc:HandlingCode>' + ls_cod_motivo_traslado + '</cbc:HandlingCode>' + char(13) + char(10) &
			+ '        <cbc:HandlingInstructions>' + ls_Handling_Instructions + '</cbc:HandlingInstructions>' + char(13) + char(10) &
			+ '        <cbc:GrossWeightMeasure unitCode="' + ls_und_peso + '">' + string(ldc_peso_neto, "#####") + '</cbc:GrossWeightMeasure>' + char(13) + char(10) &
			+ '        <cac:ShipmentStage>' + char(13) + char(10) &
			+ '            <cbc:TransportModeCode>' + ls_ModoTransporte + '</cbc:TransportModeCode>' + char(13) + char(10) &
			+ '            <cac:TransitPeriod>' + char(13) + char(10) &
			+ '                <cbc:StartDate>' + ls_start_date + '</cbc:StartDate>' + char(13) + char(10) &
			+ '            </cac:TransitPeriod>' + char(13) + char(10)

//Datos del Transportista
if not IsNull(ls_tipo_doc_transp) and trim(ls_tipo_doc_transp) <> '' &
   and trim(ls_ruc_dni_transp) <> '' then
	
	ls_texto += '			<cac:CarrierParty>' + char(13) + char(10) &
	 			 + '				<cac:PartyIdentification>' + char(13) + char(10) &
				 + '					<cbc:ID schemeID="' + ls_tipo_doc_transp + '">' + ls_ruc_dni_transp + '</cbc:ID>' + char(13) + char(10) &
				 + '				</cac:PartyIdentification>' + char(13) + char(10) &
				 + '				<cac:PartyLegalEntity>' + char(13) + char(10) &
				 + '					<cbc:RegistrationName>' + ls_nom_transportita + '</cbc:RegistrationName>' + char(13) + char(10) &
				 + '					<cbc:CompanyID>' + ls_cert_insc_mtc + '</cbc:CompanyID>' + char(13) + char(10) &
				 + '				</cac:PartyLegalEntity>' + char(13) + char(10) &
				 + '				<cac:AgentParty>' + char(13) + char(10) &
				 + '					<cac:PartyLegalEntity>' + char(13) + char(10) &
				 + '						<cbc:CompanyID schemeID="03">' + ls_nro_autor_especial + '</cbc:CompanyID>' + char(13) + char(10) &
				 + '					</cac:PartyLegalEntity>' + char(13) + char(10) &
				 + '				</cac:AgentParty>' + char(13) + char(10) &
				 + '			</cac:CarrierParty>' + char(13) + char(10) 
				 
end if			

//Datos del Chofer
ls_texto +='            <cac:DriverPerson>' + char(13) + char(10) &
			+ '                <cbc:ID schemeID="' + ls_tipo_doc_chofer + '">' + ls_dni_chofer + '</cbc:ID>' + char(13) + char(10) &
			+ '                <cbc:FirstName>' + ls_nom_chofer + '</cbc:FirstName>' + char(13) + char(10) &
			+ '                <cbc:FamilyName>' + ls_apell_chofer + '</cbc:FamilyName>' + char(13) + char(10) &
			+ '                <cbc:JobTitle>Principal</cbc:JobTitle>' + char(13) + char(10) &
			+ '                <cac:IdentityDocumentReference>' + char(13) + char(10) &
			+ '                    <cbc:ID>' + ls_nro_brevete + '</cbc:ID>' + char(13) + char(10) &
			+ '                </cac:IdentityDocumentReference>' + char(13) + char(10) &
			+ '            </cac:DriverPerson>' + char(13) + char(10) 


//Direccion del origen y del destino
ls_texto += '        </cac:ShipmentStage>' + char(13) + char(10) &
			 + '        <cac:Delivery>' + char(13) + char(10) &
			 + '            <cac:DeliveryAddress>' + char(13) + char(10) &
			 + '                <cbc:ID>' + ls_ubigeo_destino + '</cbc:ID>' + char(13) + char(10) &
			 + '                <cbc:CitySubdivisionName>' + ls_urbanizacion_destino + '</cbc:CitySubdivisionName>' + char(13) + char(10) &
			 + '                <cbc:CityName>' + ls_provincia_destino + '</cbc:CityName>' + char(13) + char(10) &
			 + '                <cbc:CountrySubentity>' + ls_departamento_destino + '</cbc:CountrySubentity>' + char(13) + char(10) &
			 + '                <cbc:District>' + ls_distrito_destino + '</cbc:District>' + char(13) + char(10) &
			 + '                <cac:AddressLine>' + char(13) + char(10) &
			 + '                    <cbc:Line>' + ls_direccion_destino + '</cbc:Line>' + char(13) + char(10) &
			 + '                </cac:AddressLine>' + char(13) + char(10) &
			 + '                <cac:Country>' + char(13) + char(10) &
			 + '                    <cbc:IdentificationCode>' + ls_pais_destino + '</cbc:IdentificationCode>' + char(13) + char(10) &
			 + '                </cac:Country>' + char(13) + char(10) &
			 + '            </cac:DeliveryAddress>' + char(13) + char(10) &
			 + '            <cac:Despatch>' + char(13) + char(10) &
			 + '                <cac:DespatchAddress>' + char(13) + char(10) &
			 + '                    <cbc:ID>' + ls_ubigeo_partida + '</cbc:ID>' + char(13) + char(10) &
			 + '                    <cbc:CitySubdivisionName>' + ls_urbanizacion_partida + '</cbc:CitySubdivisionName>' + char(13) + char(10) &
			 + '                    <cbc:CityName>' + ls_provincia_partida + '</cbc:CityName>' + char(13) + char(10) &
			 + '                    <cbc:CountrySubentity>' + ls_departamento_partida + '</cbc:CountrySubentity>' + char(13) + char(10) &
			 + '                    <cbc:District>' + ls_distrito_partida + '</cbc:District>' + char(13) + char(10) &
			 + '                    <cac:AddressLine>' + char(13) + char(10) &
			 + '                        <cbc:Line>' +  ls_direccion_partida + '</cbc:Line>' + char(13) + char(10) &
			 + '                    </cac:AddressLine>' + char(13) + char(10) &
			 + '                    <cac:Country>' + char(13) + char(10) &
			 + '                        <cbc:IdentificationCode>' +  ls_pais_partida + '</cbc:IdentificationCode>' + char(13) + char(10) &
			 + '                    </cac:Country>' + char(13) + char(10) &
			 + '                </cac:DespatchAddress>' + char(13) + char(10) &
			 + '                <cac:DespatchParty>' + char(13) + char(10) &
			 + '                    <cac:AgentParty>' + char(13) + char(10) &
			 + '                        <cac:PartyLegalEntity>' + char(13) + char(10) &
			 + '                        	<cbc:CompanyID schemeID="06">' + ls_nro_autor_especial + '</cbc:CompanyID>' + char(13) + char(10) &
			 + '                        </cac:PartyLegalEntity>' + char(13) + char(10) &
			 + '                    </cac:AgentParty>' + char(13) + char(10) &
			 + '                </cac:DespatchParty>' + char(13) + char(10) &
			 + '            </cac:Despatch>' + char(13) + char(10) &
			 + '        </cac:Delivery>' + char(13) + char(10) &
			 + '        <cac:TransportHandlingUnit>' + char(13) + char(10) &
			 + '				<cac:TransportEquipment>' + char(13) + char(10) &
			 + '					<cbc:ID>' + ls_nro_placa + '</cbc:ID>' + char(13) + char(10) &
			 + '				</cac:TransportEquipment>' + char(13) + char(10) &
			 + '			</cac:TransportHandlingUnit>' + char(13) + char(10) &
			 + '    </cac:Shipment>' 

return ls_texto
end function

public function string of_gre_despatchline (u_ds_base ads_guia);String 	ls_texto, ls_ruc_remitente, ls_razon_social_Remitente

//Datos de cada detalle de la guia
String	ls_desc_unidad, ls_und_sunat, ls_desc_art, ls_cod_art, ls_cod_cubso
Decimal 	ldc_cant_procesada


Long 		ll_nro_item, ll_row

if ads_guia.rowCount() = 0 then 
	return '' 
end if

//' + char(13) + char(10) &

ls_texto = ''

//Recorro el datasource
for ll_row = 1 to ads_guia.RowCount()
	//Obtengo los datos
	
	ls_desc_unidad			= trim(ads_guia.object.desc_unidad 		[ll_row])
	ls_und_sunat			= ads_guia.object.und_sunat 				[ll_row]
	ls_desc_art				= ads_guia.object.desc_art 				[ll_row]
	ls_cod_art				= ads_guia.object.cod_art 					[ll_row]
	ls_cod_cubso			= ads_guia.object.cod_cubso 				[ll_row]
	ldc_cant_procesada	= Dec(ads_guia.object.cant_procesada 	[ll_row])
	
	if IsNull(ls_desc_unidad) then ls_desc_unidad = '' 
	if IsNull(ls_und_sunat) then ls_und_sunat = '' 
	if IsNull(ls_desc_art) then ls_desc_art = '' 
	if IsNull(ls_cod_art) then ls_cod_art = '' 
	if IsNull(ls_cod_cubso) then ls_cod_cubso = '' 
	if IsNull(ldc_cant_procesada) then ldc_cant_procesada = 0.00
	
	//Reemplazo los saltos de linea
	ls_desc_art = invo_util.of_replace(ls_desc_art, '~r~n', '. ')
	ls_desc_art = invo_util.of_replace(ls_desc_art, '~r', '')
	ls_desc_art = invo_util.of_replace(ls_desc_art, '~n', '')

	ls_texto += '	<cac:DespatchLine>' + char(13) + char(10) &
				 + '		<cbc:ID>' + string(ll_row) + '</cbc:ID>' + char(13) + char(10) &
				 + '		<cbc:Note><![CDATA[' + ls_desc_unidad + ']]></cbc:Note>' + char(13) + char(10) &
				 + '		<cbc:DeliveredQuantity unitCode="' + ls_und_sunat + '">' + String(ldc_cant_procesada, '######.0000') + '</cbc:DeliveredQuantity>' + char(13) + char(10) &
				 + '		<cac:OrderLineReference>' + char(13) + char(10) &
				 + '			<cbc:LineID>' + string(ll_row) + '</cbc:LineID>' + char(13) + char(10) &
				 + '		</cac:OrderLineReference>' + char(13) + char(10) &
				 + '		<cac:Item>' + char(13) + char(10) &
				 + '			<cbc:Description><![CDATA[' + ls_desc_art + ']]></cbc:Description>' + char(13) + char(10) &
				 + '			<cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '				<cbc:ID><![CDATA[' + ls_cod_art + ']]></cbc:ID>' + char(13) + char(10) &
				 + '			</cac:SellersItemIdentification>' + char(13) + char(10) &
				 + '		</cac:Item>' + char(13) + char(10) &
				 + '	</cac:DespatchLine>' + char(13) + char(10)

next




return ls_texto
end function

public function str_prov_transporte of_get_prov_transporte ();str_prov_transporte lstr_Return
str_parametros lstr_param

OpenWithParm(w_pop_prov_transporte, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	lstr_Return.b_return = false
	return lstr_Return
end if

lstr_Return = Message.PowerObjectParm

return lstr_Return
end function

on n_cst_almacen.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_almacen.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_wait		= create n_cst_wait
invo_blob 		= create n_cst_file_blob
invo_inifile	= create n_cst_inifile

ids_guia  		= create u_ds_base
invo_wait 		= create n_Cst_wait
invo_xml 		= create n_cst_xml
end event

event destructor;destroy invo_wait
destroy invo_blob
destroy invo_inifile

destroy ids_guia
destroy invo_wait
destroy invo_xml
end event

