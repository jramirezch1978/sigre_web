$PBExportHeader$w_abc_ingreso_resumido.srw
forward
global type w_abc_ingreso_resumido from w_abc
end type
type shl_sugerencias_general from statichyperlink within w_abc_ingreso_resumido
end type
type p_1 from picture within w_abc_ingreso_resumido
end type
type cb_1 from commandbutton within w_abc_ingreso_resumido
end type
type cb_traspaso from commandbutton within w_abc_ingreso_resumido
end type
type shl_sugerencias from statichyperlink within w_abc_ingreso_resumido
end type
type cb_cancel from commandbutton within w_abc_ingreso_resumido
end type
type cb_aceptar from commandbutton within w_abc_ingreso_resumido
end type
type dw_detail from u_dw_abc within w_abc_ingreso_resumido
end type
type dw_master from u_dw_abc within w_abc_ingreso_resumido
end type
end forward

global type w_abc_ingreso_resumido from w_abc
integer width = 4731
integer height = 1944
string title = "Ingreso Simpflicado de Artículos "
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
shl_sugerencias_general shl_sugerencias_general
p_1 p_1
cb_1 cb_1
cb_traspaso cb_traspaso
shl_sugerencias shl_sugerencias
cb_cancel cb_cancel
cb_aceptar cb_aceptar
dw_detail dw_detail
dw_master dw_master
end type
global w_abc_ingreso_resumido w_abc_ingreso_resumido

type variables
str_parametros 	istr_param
string				is_proveedor
u_ds_base			ids_sugerencias
u_ds_base			ids_sugerencias_general
u_dw_abc				idw_master, idw_detail, idw_unidades
end variables

forward prototypes
public function boolean of_find_cat_subcat_art (long al_row)
public function boolean of_procesar (long al_row)
public function boolean of_sugerencias (long al_row)
public function boolean of_color (long al_row, string as_parametro)
public function boolean of_sub_linea (long al_row)
public function boolean of_suela (integer ll_row)
end prototypes

public function boolean of_find_cat_subcat_art (long al_row);string 	ls_cod_marca, ls_cod_sub_linea, ls_cod_suela, ls_cod_acabado, ls_color1, &
			ls_color2, ls_cod_taco, ls_estilo, ls_Cat_art, ls_desc_categoria, &
			ls_cod_sub_cat, ls_desc_sub_cat, ls_abrev_categoria
Integer 	li_talla_min, li_talla_max			


ls_cod_marca 		= dw_master.object.cod_marca		[al_row]
ls_cod_sub_linea 	= dw_master.object.cod_sub_linea	[al_row]
ls_cod_suela 		= dw_master.object.cod_suela		[al_row]
ls_cod_acabado 	= dw_master.object.cod_acabado	[al_row]
ls_color1		 	= dw_master.object.color1			[al_row]
ls_color2 			= dw_master.object.color2			[al_row]
ls_cod_taco 		= dw_master.object.cod_taco		[al_row]
ls_estilo 			= dw_master.object.estilo			[al_row]

if IsNull(ls_cod_marca) or trim(ls_cod_marca) = '' then
	//MessageBox('Error', 'Debe ingresar una MARCA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_marca')
	return false
end if

if IsNull(ls_cod_sub_linea) or trim(ls_cod_sub_linea) = '' then
	//MessageBox('Error', 'Debe ingresar una SUB LINEA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_linea')
	return false
end if

if IsNull(ls_cod_suela) or trim(ls_cod_suela) = '' then
	//MessageBox('Error', 'Debe ingresar un código de SUELA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_suela')
	return false
end if

if IsNull(ls_cod_acabado) or trim(ls_cod_acabado) = '' then
	//MessageBox('Error', 'Debe ingresar un código de ACABADO, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_acabado')
	return false
end if

if IsNull(ls_color1) or trim(ls_color1) = '' then
	//MessageBox('Error', 'Debe ingresar un COLOR PRIMARIO, por favor verifique!', StopSign!)
	dw_master.SetColumn('color1')
	return false
end if

if IsNull(ls_cod_taco) or trim(ls_cod_taco) = '' then
	//MessageBox('Error', 'Debe ingresar un código de TACO, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_taco')
	return false
end if

if IsNull(ls_estilo) or trim(ls_estilo) = '' then
	//MessageBox('Error', 'Debe ingresar un ESTILO, por favor verifique!', StopSign!)
	dw_master.SetColumn('estilo')
	return false
end if

//Busco la categoria y subcategoría del articulo
select 	a1.cat_art, a1.desc_categoria,
       	a2.cod_sub_cat, a2.desc_sub_cat,
       	a1.abreviatura, min(a.talla),
       	max(a.talla)
	into 	:ls_cat_art, :ls_desc_categoria, 
			:ls_cod_sub_cat, :ls_desc_sub_cat,
			:ls_abrev_categoria, :li_talla_min,
			:li_talla_max
from articulo a,
     articulo_sub_categ a2,
     articulo_categ     a1
where a.sub_cat_art = a2.cod_sub_cat
  and a2.cat_art    = a1.cat_art     
  and a.cod_marca				= :ls_cod_marca
  and a.cod_sub_linea		= :ls_cod_sub_linea
  and a.cod_suela				= :ls_cod_suela
  and	a.cod_acabado			= :ls_cod_acabado
  and a.cod_taco				= :ls_cod_taco
  and a.estilo					= :ls_estilo
  and a.color1					= :ls_color1
  and nvl(a.color2, 'XX') 	= nvl(:ls_color2, 'XX')
group by a1.cat_art, a1.desc_categoria,
       	a2.cod_sub_cat, a2.desc_sub_cat,
       	a1.abreviatura;

if SQLCA.SQLCode = 100 then
	return false
end if

dw_master.object.cat_art			[al_row] = ls_cat_art  
dw_master.object.desc_categoria	[al_row] = ls_desc_categoria
dw_master.object.cod_sub_cat		[al_row] = ls_cod_sub_cat
dw_master.object.desc_sub_cat		[al_row] = ls_desc_sub_cat
dw_master.object.abrev_categoria	[al_row] = ls_abrev_categoria
dw_master.object.talla_min			[al_row] = li_talla_min
dw_master.object.talla_max			[al_row] = li_talla_max

return true
end function

public function boolean of_procesar (long al_row);string 	ls_cod_marca, ls_cod_sub_linea, ls_cod_suela, ls_cod_acabado, ls_color1, &
			ls_color2, ls_cod_taco, ls_estilo, ls_Cat_art, ls_desc_categoria, &
			ls_cod_sub_cat, ls_desc_sub_cat,  ls_cod_art, ls_desc_art, ls_mensaje, &
			ls_und, ls_und_art, ls_cod_sku, ls_cod_Clase, ls_flag_nuevo, ls_ruta, ls_cod_linea

String	ls_nom_marca, ls_abrev_linea, ls_abrev_categoria, ls_desc_sub_linea, &
			ls_desc_acabado, ls_color_primario, ls_color_secundario, ls_desc_Suela, &
			ls_Desc_taco
			
decimal 	ldc_talla_min, ldc_talla_max, ldc_talla, ldc_incremento, ldc_precio_vta_unidad, &
			ldc_precio_compra_old, ldc_precio_compra_new, ldc_precio_vta_unidad_new
			
Integer	li_row,li_fot, ll_id_foto

ls_cod_marca 					= dw_master.object.cod_marca					[al_row]
ls_cod_linea					= dw_master.object.cod_linea 					[al_row]
ls_cod_sub_linea 				= dw_master.object.cod_sub_linea				[al_row]
ls_cod_suela 					= dw_master.object.cod_suela					[al_row]
ls_cod_acabado 				= dw_master.object.cod_acabado				[al_row]
ls_color1		 				= dw_master.object.color1						[al_row]
ls_color2 						= dw_master.object.color2						[al_row]
ls_cod_taco 					= dw_master.object.cod_taco					[al_row]
ls_estilo 						= dw_master.object.estilo						[al_row]
ls_cat_art						= dw_master.object.cat_art						[al_row]
ls_cod_sub_cat					= dw_master.object.cod_sub_cat				[al_row]
ls_und							= dw_master.object.und							[al_row]
ls_cod_clase					= dw_master.object.cod_clase					[al_row]
ldc_talla_min					= Dec(dw_master.object.talla_min				[al_row])
ldc_talla_max					= Dec(dw_master.object.talla_max				[al_row])
ldc_incremento					= Dec(dw_master.object.incremento			[al_row])
ldc_precio_compra_new		= Dec(dw_master.object.precio					[al_row])
ldc_precio_vta_unidad_new	= Dec(dw_master.object.precio_vta_unidad	[al_row])

//Datos para el articulo
ls_nom_marca				= dw_master.object.nom_marca				[al_row]
ls_abrev_categoria		= dw_master.object.abrev_categoria		[al_row]
ls_abrev_linea				= dw_master.object.abrev_linea			[al_row]
ls_desc_sub_linea			= dw_master.object.desc_sub_linea		[al_row]
ls_desc_acabado			= dw_master.object.desc_acabado			[al_row]
ls_color_primario			= dw_master.object.color_primario		[al_row]
ls_color_secundario		= dw_master.object.color_secundario		[al_row]
ls_desc_Suela				= dw_master.object.desc_suela				[al_row]
ls_Desc_taco				= dw_master.object.desc_taco				[al_row]

select  count(*)
into :li_fot
from fotos.imagen_articulo i
where trim(i.desc_marca) = trim(:ls_nom_marca)
	and trim(i.estilo) = trim (:ls_estilo)
	and nvl(trim(i.desc_suela),'0') =  nvl(trim (:ls_desc_Suela),'0')
	and trim(i.desc_acabado)= trim (:ls_desc_acabado)
	and trim(i.desc_color1) = trim (:ls_color_primario)
	and nvl(trim(i.desc_color2),'0') =  nvl(trim (:ls_color_secundario),'0')
	and trim(i.cod_taco) =  trim (:ls_cod_taco);

p_1.picturename = ''
if li_fot > 0 then
	
	select i.id_foto 
	into :ll_id_foto
	from fotos.imagen_articulo i
	where trim(i.desc_marca) = trim(:ls_nom_marca)
		and trim(i.estilo) = trim (:ls_estilo)
		and nvl(trim(i.desc_suela),'0') =  nvl(trim (:ls_desc_Suela),'0')
		and trim(i.desc_acabado)= trim (:ls_desc_acabado)
		and trim(i.desc_color1) = trim (:ls_color_primario)
		and nvl(trim(i.desc_color2),'0') =  nvl(trim (:ls_color_secundario),'0')
		and trim(i.cod_taco) =  trim (:ls_cod_taco);
		
		p_1.picturename = gnvo_app.almacen.of_get_foto_id(ll_id_foto);	
end if

if IsNull(ls_cod_marca) or trim(ls_cod_marca) = '' then
	MessageBox('Error', 'Debe ingresar una MARCA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_marca')
	return false
end if

if IsNull(ls_cod_sub_linea) or trim(ls_cod_sub_linea) = '' then
	MessageBox('Error', 'Debe ingresar una SUB LINEA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_linea')
	return false
end if

if IsNull(ls_cod_suela) or trim(ls_cod_suela) = '' then
	MessageBox('Error', 'Debe ingresar un código de SUELA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_suela')
	return false
end if

if IsNull(ls_cod_acabado) or trim(ls_cod_acabado) = '' then
	MessageBox('Error', 'Debe ingresar un código de ACABADO, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_acabado')
	return false
end if

if IsNull(ls_color1) or trim(ls_color1) = '' then
	MessageBox('Error', 'Debe ingresar un COLOR PRIMARIO, por favor verifique!', StopSign!)
	dw_master.SetColumn('color1')
	return false
end if

if IsNull(ls_color2) or trim(ls_color2) = '' then
	MessageBox('Error', 'Debe ingresar un COLOR SECUNDARIO, por favor verifique!', StopSign!)
	dw_master.SetColumn('color2')
	return false
end if

if IsNull(ls_cod_Clase) or trim(ls_cod_Clase) = '' then
	MessageBox('Error', 'Debe ingresar un código de CLASE, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_clase')
	return false
end if

if IsNull(ls_estilo) or trim(ls_estilo) = '' then
	MessageBox('Error', 'Debe ingresar un ESTILO, por favor verifique!', StopSign!)
	dw_master.SetColumn('estilo')
	return false
end if

if IsNull(ls_cat_art) or trim(ls_cat_art) = '' then
	MessageBox('Error', 'Debe ingresar una CATEGORIA DEL ARTICULO, por favor verifique!', StopSign!)
	dw_master.SetColumn('cat_art')
	return false
end if


if IsNull(ls_cod_sub_cat) or trim(ls_cod_sub_cat) = '' then
	MessageBox('Error', 'Debe ingresar un SUB CATEGORIA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_cat')
	return false
end if

if IsNull(ls_abrev_categoria) or trim(ls_abrev_categoria) = '' then
	MessageBox('Error', 'La CATEGORIA no tiene Abreviatura, por favor verifique!', StopSign!)
	dw_master.SetColumn('cat_art')
	return false
end if

if IsNull(ls_abrev_linea) or trim(ls_abrev_linea) = '' then
	MessageBox('Error', 'La LINEA no tiene abreviatura, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_linea')
	return false
end if

if IsNull(ldc_precio_compra_new) or ldc_precio_compra_new <= 0 then
	MessageBox('Error', 'Se debe colocar un precio de compra mayor que cero, por favor verifique!', StopSign!)
	dw_master.SetColumn('precio')
	return false
end if

if IsNull(ls_und) or trim(ls_und) = '' then
	MessageBox('Error', 'No ha indicado la unidad de medida, por favor verifique!', StopSign!)
	dw_master.SetColumn('und')
	return false
end if

if ldc_incremento <= 0 then
	MessageBox('Error', 'El incremento debe ser un valor positivo mayor que cero, por favor verifique!', StopSign!)
	dw_master.SetColumn('incremento')
	return false
end if

dw_detail.Reset()

//Creo el lazo para insertar registros
ldc_talla = ldc_talla_min

do while ldc_talla <= ldc_talla_max 
	li_row = dw_detail.event ue_insert()
	
	if li_row > 0 then
		dw_detail.object.talla [li_row] = ldc_talla

		/*
		select a.sub_cat_art,
				 a.und,
				 a.cod_marca,
				 a.Cod_Sub_Linea,
				 a.estilo,
				 a.cod_acabado,
				 a.cod_suela,
				 a.color1,
				 a.color2,
				 a.cod_taco,
				 a.talla,
				 count(*) cantidad
		  from articulo a
		 group by a.sub_cat_art,
					 a.und,
					 a.cod_marca,
					 a.Cod_Sub_Linea,
					 a.estilo,
					 a.cod_acabado,
					 a.cod_suela,
					 a.color1,
					 a.color2,
					 a.cod_taco,
					 a.talla
		having count(1) > 1 ;
		*/
		
		// Busco el artículo asi como su descripcion
		select 	a.cod_art, a.desc_art, a.und, a.cod_sku, 
				 	a.precio_vta_unidad
			into 	:ls_cod_art, :ls_desc_art, :ls_und_art, :ls_cod_sku,
					:ldc_precio_vta_unidad
		  from ARTICULO a
		where a.sub_cat_art   				= :ls_cod_sub_cat
		  and a.und								= :ls_und
		  and a.cod_marca 					= :ls_cod_marca
		  and a.cod_sublinea 				= :ls_cod_sub_linea
		  and a.cod_linea 					= :ls_cod_linea //
		  and a.estilo      					= :ls_estilo
		  and a.cod_acabado 					= :ls_cod_acabado
		  and a.cod_suela   					= :ls_cod_suela
		  and a.color1      					= :ls_color1
		  and a.color2 						= :ls_color2
		  and a.cod_taco 						= :ls_cod_taco
		  and a.talla       					= :ldc_talla;
 
     	//Valido si tiene un error
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al consultar en tabla ARTICULO. Error: ' + ls_mensaje, StopSign!)
			return false
		end if

		//Si la descripcion del articulo es vacia entonces la creo en base al texto
	  	if SQLCA.SQLCode = 100 or IsNull(ls_desc_art) or trim(ls_desc_art) = '' then
			
			SetNull(ls_cod_sku)
			setNull(ls_und_art)
			SetNull(ls_cod_art)
			
			ldc_precio_vta_unidad = 0
			
			ls_desc_art = trim(ls_nom_marca) 
			
			if not ISNull(ls_abrev_categoria) and trim(ls_abrev_categoria) <> '' then
				ls_desc_art += ' ' + trim(ls_abrev_categoria)
			end if
			
			if not ISNull(ls_abrev_linea) and trim(ls_abrev_linea) <> '' then
				ls_desc_art += trim(ls_abrev_linea)
			end if
			
			if not ISNull(ls_desc_sub_linea) and trim(ls_desc_sub_linea) <> '' then
				ls_desc_art += ' ' + trim(ls_desc_sub_linea)
			end if
			
			if not ISNull(ls_Estilo) and trim(ls_Estilo) <> '' then
				ls_desc_art += ' ' + trim(ls_Estilo)
			end if

			if not ISNull(ls_desc_acabado) and trim(ls_desc_acabado) <> '' then
				ls_desc_art += ' ' + trim(ls_desc_acabado)
			end if
			
			if not ISNull(ls_color_primario) and trim(ls_color_primario) <> '' then
				ls_desc_art += ' ' + trim(ls_color_primario)
			end if

			if not ISNull(ls_color_secundario) and trim(ls_color_secundario) <> '' then
				ls_desc_art += '/' + trim(ls_color_secundario)
			end if

			if not ISNull(ls_desc_suela) and trim(ls_desc_suela) <> '' then
				ls_desc_art += ' ' + trim(ls_desc_suela)
			end if

			if not ISNull(ls_Desc_taco) and trim(ls_Desc_taco) <> '' then
				ls_desc_art += ' ' + trim(ls_Desc_taco)
			end if
			
			ls_desc_art += ' ' + trim(string(ldc_talla, '###,##0.0'))
			
			ldc_precio_compra_old = 0
			
		else			
			
			//Obtengo el ultimo precio de Compra 
			select precio_compra
			  into :ldc_precio_compra_old
			  from (
					select oc.fec_registro, round(amp.precio_unit + case when amp.cant_proyect > 0 then amp.impuesto / amp.cant_proyect else 0 end,4) as precio_compra
							from orden_compra oc,
								  articulo_mov_proy amp
							where amp.nro_doc = oc.nro_oc
							  and amp.tipo_doc = (select doc_oc from logparam where reckey = '1')
							  and oc.flag_estado <> '0'
							  and amp.flag_estado <> '0' 
							  and oc.proveedor = :is_proveedor
							  and amp.cod_art  = :ls_cod_art
							order by oc.fec_registro desc
				) s
			where rownum = 1;
			
			//Precio de compra = 0 si no existe o es nul
			if SQLCA.SQLCode = 100 or IsNull(ldc_precio_compra_old) then
				ldc_precio_compra_old = 0
			end if
		
		end if
		
		if IsNull(ls_und_art) or trim(ls_und_art) = '' then
			ls_und_art = ls_und
		end if
		
		if IsNull(ls_cod_sku) or trim(ls_cod_sku) = '' then
			ls_cod_sku = 'NUEVO'
			//El articulo no existe y es nuevo
			ls_flag_nuevo = '1'
			
		else
			//El articulo si existe
			ls_flag_nuevo = '0'
		end if
	  
	  dw_detail.object.cod_art 					[li_row] = ls_cod_art
	  dw_detail.object.desc_art 					[li_row] = ls_desc_art
	  dw_detail.object.und 							[li_row] = ls_und_art
	  dw_detail.object.cod_sku						[li_row] = ls_cod_sku
	  dw_detail.object.precio_compra_old		[li_row] = ldc_precio_compra_old
	  dw_detail.object.precio_compra_new		[li_row] = ldc_precio_compra_new
	  dw_detail.object.precio_vta_old			[li_row] = ldc_precio_vta_unidad
	  
	  	if ldc_precio_vta_unidad_new > 0 then
			dw_detail.object.precio_vta_new		[li_row] = ldc_precio_vta_unidad_new
		else
	  		dw_detail.object.precio_vta_new		[li_row] = ldc_precio_vta_unidad
		end if
		
	  	dw_detail.object.proveedor					[li_row] = is_proveedor
	  	dw_detail.object.flag_nuevo				[li_row] = ls_flag_nuevo
	  
	end if
	
	
	ldc_talla += ldc_incremento
	
loop

//bloqueo el campo correctamente
//'16777215 ~t If(emp_status=~~'A~~',255,16777215)'
dw_detail.Modify("cod_sku.Protect ='1~tIf(flag_nuevo=~~'1~~',1,0)'")
dw_detail.Modify("cod_sku.Background.color ='1~tIf(flag_nuevo=~~'1~~', RGB(192,192,192),RGB(255,255,255))'")


dw_detail.setFocus()

return true
end function

public function boolean of_sugerencias (long al_row);string 	ls_cod_marca, ls_cod_sub_linea, ls_estilo, ls_cod_sub_cat, ls_desc_marca

ls_cod_sub_cat 	= dw_master.object.cod_sub_cat		[al_row]
ls_cod_marca 		= dw_master.object.cod_marca			[al_row]
ls_desc_marca    	= dw_master.object.nom_marca			[al_row]
ls_cod_sub_linea 	= dw_master.object.cod_sub_linea		[al_row]
ls_estilo 			= dw_master.object.estilo				[al_row]

if IsNull(ls_cod_sub_cat) or trim(ls_cod_sub_cat) = '' then
	//MessageBox('Error', 'Debe ingresar una MARCA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_cat')
	return false
end if

if IsNull(ls_cod_marca) or trim(ls_cod_marca) = '' then
	//MessageBox('Error', 'Debe ingresar una MARCA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_marca')
	return false
end if

/*
if IsNull(ls_cod_sub_linea) or trim(ls_cod_sub_linea) = '' then
	//MessageBox('Error', 'Debe ingresar una SUB LINEA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_linea')
	return false
end if
*/

if IsNull(ls_estilo) or trim(ls_estilo) = '' then
	//MessageBox('Error', 'Debe ingresar un ESTILO, por favor verifique!', StopSign!)
	dw_master.SetColumn('estilo')
	return false
end if

ids_sugerencias.Retrieve(ls_cod_sub_cat, ls_cod_marca, ls_estilo)

if ids_sugerencias.RowCount() = 0 then
	shl_sugerencias.text = 'No hay sugerencias'
else
	shl_sugerencias.text = 'Existen ' + trim(string(ids_sugerencias.RowCount())) + ' sugerencias.'
end if


ids_sugerencias_general.Retrieve (ls_desc_marca, ls_estilo)
if ids_sugerencias_general.RowCount() = 0 then
	shl_sugerencias_general.text = 'No hay sugerencias'
else
	shl_sugerencias_general.text = 'Existen ' + trim(string(ids_sugerencias_general.RowCount())) + ' sugerencias.'
end if

return true
end function

public function boolean of_color (long al_row, string as_parametro);String 	ls_color, ls_desc_color

Long 		ll_count, ll_color

if not gnvo_app.of_prompt_string("Indique el nuevo color", ls_desc_color) then return false

select count(*)
	into :ll_count
from color c
where trim(upper(c.descripcion)) = trim(upper(:ls_desc_color));

if ll_count > 0 then
	MessageBox('Error', 'El color ' + ls_desc_color + ' ya existe, por favor verifique!', StopSign!)
	return false
end if

select NVL(max(c.color),0) + 1
	into :ll_color
from color c;

//Inserto el nuevo color
ls_color = trim(string(ll_color, '000'))

insert into color(color, descripcion, flag_estado)
values(:ls_color, :ls_desc_color, '1');

if gnvo_app.of_existsError(SQLCA, "Error al insertar en tabla COLOR") then
	rollback ;
	return false
end if

commit;

if as_parametro = 'primario' then
	dw_master.object.color1					[1] = ls_color
	dw_master.object.color_primario		[1] = ls_desc_color
elseif as_parametro = 'secundario' then
	dw_master.object.color2					[1] = ls_color
	dw_master.object.color_secundario	[1] = ls_desc_color
else
	MessageBox('Error', 'Parametro ' + as_parametro + ' no esta implementado todavía. Por favor corrija', StopSign!)
	return false
end if
return true
end function

public function boolean of_sub_linea (long al_row);String 	ls_cod_sub_linea, ls_desc_sub_linea, ls_cod_linea, ls_abreviatura, ls_codsubcat

Long 		ll_count, ll_next_nro, ll_count2 

ls_cod_linea = dw_master.object.cod_linea [1]
ls_codsubcat = dw_master.object.cod_sub_cat [1]

if IsNull(ls_cod_linea) or trim(ls_cod_linea) = '' then
	MessageBox('Error', 'Debe Ingresar un código de linea, por favor verifique!', StopSign!)
	dw_master.setFocus()
	dw_master.setColumn('cod_linea')
	return false
end if

if IsNull(ls_codsubcat) or trim(ls_codsubcat) = '' then
	MessageBox('Error', 'Debe Ingresar un código de sub Categoria, por favor verifique!', StopSign!)
	dw_master.setFocus()
	dw_master.setColumn('cod_sub_cat')
	return false
end if

if not gnvo_app.of_prompt_string("Indique Descripcion Sub Línea", ls_desc_sub_linea) then return false

select count(*)
	into :ll_count
from zc_sub_linea zsl
where trim(upper(zsl.desc_sub_linea)) = trim(upper(:ls_desc_sub_linea))
  and cod_linea = :ls_cod_linea;

if ll_count > 0 then
	MessageBox('Error', 'la Sub Linea ' + ls_desc_sub_linea + ' ya existe para la linea , por favor verifique!', StopSign!)
	return false
end if		

select count(*)
	into :ll_count2
from zc_sub_linea zsl
where trim(upper(zsl.desc_sub_linea)) = trim(upper(:ls_desc_sub_linea))
  and rownum = 1;

//toma abrevitura anterior
if ll_count2 > 0	then
	select abreviatura
		into :ls_abreviatura
	from zc_sub_linea zsl
	where trim(upper(zsl.desc_sub_linea)) = trim(upper(:ls_desc_sub_linea))
	  and rownum = 1;
else	
	if not gnvo_app.of_prompt_string("Indique Abreviatura Sub Línea", ls_abreviatura) then return false	

	if len(ls_abreviatura) > 5 then
		MessageBox('Error', 'la Abreviatura ' + ls_abreviatura + ' debe contener como maximo 4 carateres, por favor verifique!', StopSign!)
		return false
	end if

end if


select nvl(to_number(substr(max(z.cod_sub_linea),4,3)),0) + 1
	into :ll_next_nro
from zc_sub_linea z
where cod_SUB_linea like :ls_cod_linea || '%';

//Inserto el nuevo color
ls_cod_sub_linea = ls_cod_linea + trim(string(ll_next_nro, '000'))

insert into zc_sub_linea(cod_linea, cod_sub_linea,   desc_sub_linea, abreviatura, flag_estado)
values(:ls_cod_linea, :ls_cod_sub_linea, upper(:ls_desc_sub_linea), upper(:ls_abreviatura), '1');

if gnvo_app.of_existsError(SQLCA, "Error al insertar en tabla AC_SUB_LINEA") then
	rollback ;
	return false
end if

commit;

string ls_busqueda2, ls_busqueda
DatawindowChild dwc_campo
ls_busqueda2= ''
ls_busqueda= dw_master.object.cod_linea [1]

dw_master.getChild("cod_sub_linea",dwc_campo)
dwc_campo.settransobject(sqlca)
dwc_campo.retrieve(ls_busqueda,ls_busqueda2)
		

dw_master.object.cod_sub_linea	[1] = ls_cod_sub_linea

return true
end function

public function boolean of_suela (integer ll_row);String 	ls_cod_sub_linea, ls_desc_sub_linea, ls_cod_linea, ls_abreviatura, ls_codsubcat

Long 		ll_count, ll_next_nro

if not gnvo_app.of_prompt_string("Indique Descripcion Suela", ls_desc_sub_linea) then return false
if not gnvo_app.of_prompt_string("Indique Abreviatura Suela", ls_abreviatura) then return false
ls_abreviatura = TRIM(ls_abreviatura)

if len(TRIM(ls_abreviatura) )> 5 OR  len(TRIM(ls_abreviatura)) = 0 then
	MessageBox('Error', 'la Abreviatura ' + ls_abreviatura + ' debe contener como maximo 5 carateres, por favor verifique!', StopSign!)
	return false
end if

select count(*)
	into :ll_count
from zc_suela zsl
where trim(upper(zsl.desc_suela)) = trim(upper(:ls_desc_sub_linea)) OR trim(upper(zsl.abreviatura)) = trim(upper(:ls_abreviatura)) ;

if ll_count > 0 then
	MessageBox('Error', 'la Suela Y/O abreviatura' + ls_desc_sub_linea + ' ya existe, por favor verifique!', StopSign!)
	return false
end if

ll_next_nro = 0

select nvl(to_number(substr(max(z.cod_suela),2,2)),0) + 1
	into :ll_next_nro
from zc_suela Z
where cod_suela like  + '0%';

ls_cod_sub_linea = trim(string(ll_next_nro, '000'))

insert into zc_suela(cod_suela,  desc_suela, abreviatura, flag_estado)
values(:ls_cod_sub_linea, upper(:ls_desc_sub_linea), upper(:ls_abreviatura), '1');

if gnvo_app.of_existsError(SQLCA, "Error al insertar en tabla AC_SUELA") then
	rollback ;
	return false
end if

commit;

dw_master.object.cod_suela	[1] = ls_cod_sub_linea
dw_master.object.desc_suela	[1] = ls_desc_sub_linea

return true
end function

on w_abc_ingreso_resumido.create
int iCurrent
call super::create
this.shl_sugerencias_general=create shl_sugerencias_general
this.p_1=create p_1
this.cb_1=create cb_1
this.cb_traspaso=create cb_traspaso
this.shl_sugerencias=create shl_sugerencias
this.cb_cancel=create cb_cancel
this.cb_aceptar=create cb_aceptar
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_sugerencias_general
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_traspaso
this.Control[iCurrent+5]=this.shl_sugerencias
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_aceptar
this.Control[iCurrent+8]=this.dw_detail
this.Control[iCurrent+9]=this.dw_master
end on

on w_abc_ingreso_resumido.destroy
call super::destroy
destroy(this.shl_sugerencias_general)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.cb_traspaso)
destroy(this.shl_sugerencias)
destroy(this.cb_cancel)
destroy(this.cb_aceptar)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

if MessageBox('Aviso', 'Desea cerrar la ventana?', Information!, YesNo!, 2) = 2 then return

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros lstr_param
Long 				ll_rows, ll_i, ll_ult_nro, ll_count, ll_row, ll_row_cab
Decimal			ldc_Cantidad, ldc_precio_compra_new, ldc_talla, &
					ldc_precio_vta_old, ldc_precio_vta_new
string 			ls_cod_marca, ls_cod_sub_linea, ls_cod_suela, ls_cod_acabado, ls_color1, &
					ls_color2, ls_cod_taco, ls_estilo, ls_Cat_art, &
					ls_cod_sub_cat, ls_cod_art, ls_desc_art, ls_mensaje, &
					ls_cod_sku, ls_tabla, ls_und, ls_cod_clase, ls_almacen, &
					ls_nom_usuario, ls_cod_linea
DateTime		ldt_fec_registro


if dw_detail.RowCount() = 0 then
	MessageBox('Error', 'No se ha especficado ningun registro para procesar, por favor verifique!', StopSign!)
	return
end if

//Validar la cantidad de registros con cantidad, tiene que haber puesto cantidad al menos
//en un registro
ll_rows = 0
for ll_i = 1 to dw_detail.RowCount()
	ldc_cantidad = Dec(dw_detail.object.cantidad [ll_i])
	
	if ldc_cantidad > 0 then
		ll_rows ++
	end if
next

if ll_rows = 0 then
	MessageBox('Error', 'No se ha indicado ninguna cantidad para la Orden de compra en ningun registro, por favor verifique!', StopSign!)
	return 
end if

//Valido los precios de venta y de compra
for ll_i = 1 to dw_detail.RowCount()
	//ME ubico en el registro indicado
	dw_detail.SelectRow(0, false)
	dw_detail.SelectRow(ll_i, true)
	dw_detail.ScrollToRow(ll_i)

	ldc_cantidad				= Dec(dw_detail.object.cantidad 				[ll_i])
	
	if ldc_Cantidad > 0 then
		ldc_precio_vta_new 		= Dec(dw_detail.object.precio_vta_new 		[ll_i])
		ldc_precio_compra_new 	= Dec(dw_detail.object.precio_compra_new 	[ll_i])
		
		if ldc_precio_vta_new <= 0 then
			MessageBox('Error', 'El precio de VENTA es menor o igual a cero, por favor verifique!', StopSign!)
			return
		end if
		
		if ldc_precio_compra_new <= 0 then
			MessageBox('Error', 'El precio de COMPRA es menor o igual a cero, por favor verifique!', StopSign!)
			return
		end if
	end if
next

//Inserto la cabecera del parte de ingreso
ll_row_cab = idw_detail.event ue_insert( )

if ll_row_cab <= 0 then
	return
end if

idw_detail.object.cat_art				[ll_row_cab]	= dw_master.object.cat_art          	[1]
idw_detail.object.desc_categoria	[ll_row_cab]	= dw_master.object.desc_categoria	[1]
idw_detail.object.cod_sub_cat		[ll_row_cab]	= dw_master.object.cod_sub_cat			[1]
idw_detail.object.desc_sub_Cat	[ll_row_cab]	= dw_master.object.desc_sub_Cat		[1]
idw_detail.object.cod_marca		[ll_row_cab]	= dw_master.object.cod_marca			[1]
idw_detail.object.nom_marca		[ll_row_cab]	= dw_master.object.nom_marca			[1]
idw_detail.object.cod_linea			[ll_row_cab]	= dw_master.object.cod_linea				[1]
idw_detail.object.desc_linea			[ll_row_cab]	= dw_master.object.desc_linea			[1]
idw_detail.object.cod_sublinea	[ll_row_cab]	= dw_master.object.cod_sub_linea		[1]
idw_detail.object.desc_sub_linea	[ll_row_cab]	= dw_master.object.desc_sub_linea	[1]
idw_detail.object.estilo			[ll_row_cab]	= dw_master.object.estilo					[1]
idw_detail.object.cod_suela		[ll_row_cab]	= dw_master.object.cod_suela			[1]
idw_detail.object.desc_suela		[ll_row_cab]	= dw_master.object.desc_suela			[1]
idw_detail.object.cod_acabado		[ll_row_cab]	= dw_master.object.cod_acabado		[1]
idw_detail.object.desc_acabado	[ll_row_cab]	= dw_master.object.desc_acabado		[1]
idw_detail.object.color1			[ll_row_cab]	= dw_master.object.color1				[1]
idw_detail.object.desc_color1		[ll_row_cab]	= dw_master.object.color_primario	[1]
idw_detail.object.color2			[ll_row_cab]	= dw_master.object.color2				[1]
idw_detail.object.desc_color2		[ll_row_cab]	= dw_master.object.color_secundario	[1]
idw_detail.object.cod_taco			[ll_row_cab]	= dw_master.object.cod_taco			[1]
//idw_detail.object.desc_taco		[ll_row_cab]	= dw_master.object.desc_taco			[1]
idw_detail.object.cod_clase		[ll_row_cab]	= dw_master.object.cod_clase			[1]
idw_detail.object.desc_clase		[ll_row_cab]	= dw_master.object.desc_clase			[1]
idw_detail.object.und				[ll_row_cab]	= dw_master.object.und					[1]

idw_detail.object.imagen_blob [ll_row_cab]     = p_1.picturename

//Tabla numeradora de los codigos SKU
ls_tabla = 'NUM_CODIGO_SKU'

/*
	select a.sub_cat_art,
			 a.und,
			 a.cod_marca,
			 a.Cod_Sub_Linea,
			 a.estilo,
			 a.cod_acabado,
			 a.cod_suela,
			 a.color1,
			 a.color2,
			 a.cod_taco,
			 a.talla,
			 count(*) cantidad
	  from articulo a
	 group by a.sub_cat_art,
				 a.und,
				 a.cod_marca,
				 a.Cod_Sub_Linea,
				 a.estilo,
				 a.cod_acabado,
				 a.cod_suela,
				 a.color1,
				 a.color2,
				 a.color2,
				 a.cod_taco,
				 a.talla
	having count(1) > 1 ;
*/

//Obtengo los datos necesarios para los articulos
ls_cod_clase			= dw_master.object.cod_clase			[1]
ls_cat_art				= dw_master.object.cat_art				[1]
ls_cod_sub_cat			= dw_master.object.cod_sub_cat		[1]
ls_und					= dw_master.object.und					[1]
ls_cod_marca 			= dw_master.object.cod_marca		[1]
ls_cod_linea 			= dw_master.object.cod_linea			[1]
ls_cod_sub_linea 		= dw_master.object.cod_sub_linea	[1]
ls_estilo 					= dw_master.object.estilo				[1]
ls_cod_acabado 		= dw_master.object.cod_acabado		[1]
ls_cod_suela 			= dw_master.object.cod_suela			[1]
ls_color1		 			= dw_master.object.color1				[1]
ls_color2 				= dw_master.object.color2				[1]
ls_cod_taco 				= dw_master.object.cod_taco			[1]

//Ahora recorro los articulos 
for ll_i = 1 to dw_detail.RowCount()
	//Selecciono el registro
	dw_detail.SelectRow(0, false)
	dw_detail.SelectRow(ll_i, true)
	dw_detail.ScrollToRow(ll_i)
	dw_detail.SetRow(ll_i)
	
	//Obtengo la cantidad
	ldc_cantidad = Dec(dw_detail.object.cantidad [ll_i])
	
	if ldc_cantidad > 0 then
		
		ls_cod_art					= dw_detail.object.cod_art						[ll_i]
		ls_desc_art					= dw_detail.object.desc_art					[ll_i]
		ls_cod_sku					= dw_detail.object.cod_sku						[ll_i]
		ldc_talla					= Dec(dw_detail.object.talla					[ll_i])
		ldc_precio_compra_new	= Dec(dw_detail.object.precio_compra_new 	[ll_i])
		ldc_precio_vta_old		= Dec(dw_detail.object.precio_vta_old 		[ll_i])
		ldc_precio_vta_new		= Dec(dw_detail.object.precio_vta_new 		[ll_i])
		
		if IsNull(ldc_precio_compra_new) then ldc_precio_compra_new = 0
		
		//El precio de compra debe ser mayor que cero
		If ldc_precio_compra_new <= 0 then
			MessageBox('Error', 'El precio de compra debe ser mayor que cero, por favor corrija', StopSign!)
			return
		end if
		
		If IsNull(ldc_precio_vta_old) then 
			dw_detail.object.precio_vta_old 	[ll_i] = 0
			ldc_precio_vta_old = 0
		end if
		
		If IsNull(ldc_precio_vta_old) then 
			dw_detail.object.precio_vta_old 	[ll_i] = 0
			ldc_precio_vta_old = 0
		end if
		
		If IsNull(ldc_precio_vta_new) then 
			ldc_precio_vta_new = 0
			dw_detail.object.precio_vta_new 	[ll_i] = 0
		end if
		
		//En caso no tenga código de artículo lo creo a partir del numerador
		if IsNull(ls_Cod_art) or trim(ls_cod_Art) = '' then
			
			// Busco el artículo asi como su descripcion
			select count(*)
				into :ll_count
			  from ARTICULO a
			where a.sub_cat_art   				= :ls_cod_sub_cat
			  and a.und								= :ls_und
			  and a.cod_marca 					= :ls_cod_marca
			  //and a.cod_sub_linea 				= :ls_cod_sub_linea
			  and a.cod_sublinea 					= :ls_cod_sub_linea
			  and a.cod_linea 						= :ls_cod_linea
			  and a.estilo      						= :ls_estilo
			  and a.cod_acabado 					= :ls_cod_acabado
			  and a.cod_suela   					= :ls_cod_suela
			  and a.color1      						= :ls_color1
			  and a.color2 							= :ls_color2
			  and a.cod_taco 						= :ls_cod_taco
			  and a.talla       						= :ldc_talla;
			
			if ll_count > 0 then
				select u.nombre, a.fec_registro, a.cod_art
					into :ls_nom_usuario, :ldt_fec_registro, :ls_cod_art
				  from ARTICULO 	a,
				  		 usuario		u
				where a.cod_usr						= u.cod_usr			(+)
				  and a.sub_cat_art   				= :ls_cod_sub_cat
				  and a.und								= :ls_und
				  and a.cod_marca 					= :ls_cod_marca
				  and a.cod_sub_linea 				= :ls_cod_sub_linea
				  and a.estilo      					= :ls_estilo
				  and a.cod_acabado 					= :ls_cod_acabado
				  and a.cod_suela   					= :ls_cod_suela
				  and a.color1      					= :ls_color1
				  and a.color2 						= :ls_color2
				  and a.cod_taco 						= :ls_cod_taco
				  and a.talla       					= :ldc_talla
				order by a.fec_registro desc;
				
				MessageBox('Error', 'El artículo ' + ls_desc_art + ' ya ha sido registrado por el usuario ' &
						+ ls_nom_usuario + ' en la fecha ' + string(ldt_fec_registro, 'dd/mm/yyyy hh:mm:ss') &
						+ ' generando el código de artículo: ' + ls_cod_art &
						+ ', por favor verifique y de ser necesario vuelva a procesar!', StopSign!)
				return 

			else
			
				//Obtengo el siguiente codigo de articulo
				ls_cod_art = gnvo_app.logistica.of_next_cod_art(ls_cod_sub_cat)
				
				//Creo el codigo_sku para el articulo
				select count(*)
					into :ll_count
				from num_tablas
				where tabla  = :ls_tabla
				  and origen = :gs_origen;
				
				if ll_count = 0 then
					insert into num_Tablas(tabla, origen, ult_nro)
					values(:ls_tabla, :gs_origen, 1);
					
					if SQLCA.SQLCode < 0 then
						ls_mensaje = SQLCA.SQLErrText
						ROLLBACK;
						MessageBox('Error', 'Error al insertar en NUM_TABLAS. Mensaje: ' + ls_mensaje, StopSign!)
						return
					end if
				end if
				
				select ult_nro
					into :ll_ult_nro
				from num_tablas
				where tabla  = :ls_tabla
				  and origen = :gs_origen for update;
	
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'Error al consultar tabla NUM_TABLAS. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
				
				//creo el codigo sku
				ls_cod_sku = gnvo_app.empresa.is_siglas_cod_sku + trim(gs_origen) + trim(string(ll_ult_nro, '0000000'))
				
				//Actualizo el numerador
				update num_tablas
					set ult_nro = :ll_ult_nro + 1
				where tabla  = :ls_tabla
				  and origen = :gs_origen;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'Error al actualizar tabla NUM_TABLAS. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
			end if

			//Inserto el registro en articulo
			insert into articulo(
				cod_Art, desc_art, nom_Articulo, 
				sub_cat_Art, 
				und,
				cod_marca, 
				//cod_sub_linea, 
				cod_sublinea,
				cod_linea,
				estilo,
				cod_acabado,
				cod_suela, 
				color1, 
				color2, 
				cod_Taco,  
				talla,
				cod_sku, 
				cod_clase,
				cod_usr,
				fec_registro,
				precio_vta_unidad
			)values(
				:ls_cod_Art, :ls_desc_art, substr(:ls_desc_art,1,40), 
				:ls_cod_sub_cat, 
				:ls_und,
				:ls_cod_marca, 
				:ls_cod_sub_linea,
				:ls_cod_linea,//
				:ls_estilo,
				:ls_cod_acabado,
				:ls_cod_suela,  
				:ls_color1, 
				:ls_color2, 
				:ls_cod_taco,  
				:ldc_talla,
				:ls_cod_sku, 
				:ls_cod_clase,
				:gs_user,
				sysdate,
				:ldc_precio_vta_new
			);
			
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al insertar tabla ARTICULO. Mensaje: ' + ls_mensaje, StopSign!)
				return
			end if

		else
			//Actulizo el precio de venta del articulo
			
			if ldc_precio_vta_old <> ldc_precio_vta_new then
				
				if ldc_precio_vta_new <= 0 then
					ROLLBACK;
					MessageBox('Error', 'El precio de Venta no puede ser negativo o cero, por favor corrija el registro ' + string(ll_i), StopSign!)
					return
				end if
				
				update articulo a
				   set a.precio_vta_unidad = :ldc_precio_vta_new
				where a.cod_art = :ls_cod_art;

				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'Error al ACTUALIZAR el precio de venta en tabla ARTICULO. CODIGO ' + ls_cod_art + '. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
				
			end if
			
		end if
		
		
		ll_row = idw_unidades.event ue_insert()
		if ll_row > 0 then
			
			idw_unidades.object.talla					[ll_row] = dw_detail.object.talla 					[ll_i]
			idw_unidades.object.cod_art				[ll_row] = ls_cod_art
			idw_unidades.object.cod_sku				[ll_row] = ls_cod_sku
			idw_unidades.object.desc_Art				[ll_row] = ls_Desc_art
			idw_unidades.object.und						[ll_row] = ls_und
			idw_unidades.object.cantidad				[ll_row] = dw_detail.object.cantidad 				[ll_i]
			
			idw_unidades.object.precio_compra_ant	[ll_row] = dw_detail.object.precio_compra_old 	[ll_i]
			idw_unidades.object.precio_compra_new	[ll_row] = dw_detail.object.precio_compra_new 	[ll_i]
			idw_unidades.object.precio_vta_ant		[ll_row] = dw_detail.object.precio_vta_old 		[ll_i]
			idw_unidades.object.precio_vta_new		[ll_row] = dw_detail.object.precio_vta_new 		[ll_i]
			
			idw_unidades.object.nro_parte				[ll_row] = idw_detail.object.nro_parte 			[ll_row_cab]
			idw_unidades.object.nro_item				[ll_row] = idw_detail.object.nro_item 				[ll_row_cab]
			

		end if
	
	end if
next

commit;

//Envio los cambios de precio por correo para que lo sepan y puedan imprimir los tickets nuevamente
gnvo_app.ventas.of_send_email_changes_vta(dw_detail)

gnvo_app.ventas.of_send_email_changes_cmp(dw_detail)

end event

event ue_open_pre;call super::ue_open_pre;String 	ls_und, ls_desc_und, ls_cod_clase, ls_Desc_clase
Long		ll_row

try 
	istr_param = Message.PowerObjectParm
	
	idw_1 = dw_master              				// asignar dw corriente
	
	idw_master 		= istr_param.dw_m
	idw_detail 		= istr_param.dw_d
	idw_unidades	= istr_param.dw_und
	
	is_proveedor 	= idw_master.object.proveedor [1]
	
	if IsNull(is_proveedor) or trim(is_proveedor) = '' then
		MessageBox('Error', 'Se debe especificar un proveedor, por favor verifique!', StopSign!)
		this.event post close()
		return
	end if
	
	
	ids_sugerencias = create u_ds_base
	ids_sugerencias.DataObject = 'd_list_sugerencias_zapatos_tbl'
	ids_sugerencias.SetTransObject(SQLCA)
	
	
	ids_sugerencias_general = create u_ds_base
	ids_sugerencias_general.DataObject = 'd_list_sugerencias_zapatos_general_tbl'
	ids_sugerencias_general.SetTransObject(SQLCA)
	
	dw_master.SetFocus()
	
	ll_row = dw_master.event ue_insert()
	
	if ll_row > 0 then
		//Datos por defecto, la unidad y la clase de articulo
		ls_und			= gnvo_app.of_get_parametro("UNIDAD_PARES", "PAR")
		ls_cod_clase	= gnvo_app.of_get_parametro("CLASE_MERCADERIA", "01")
		
		select desc_unidad
			into :ls_desc_und
		from unidad
		where und = :ls_und;
		
		select desc_Clase
			into :ls_desc_clase
		from articulo_clase 
		where cod_Clase = :ls_cod_clase;
		
		dw_master.object.und				[ll_row] = ls_und
		dw_master.object.desc_unidad	[ll_row] = ls_desc_und
		dw_master.object.cod_clase		[ll_row] = ls_cod_clase
		dw_master.object.desc_clase	[ll_row] = ls_desc_clase
		
	end if
	
	
	dw_master.setColumn('cat_art')

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Open")
	
finally
	/*statementBlock*/
end try


end event

event resize;call super::resize;//dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

type shl_sugerencias_general from statichyperlink within w_abc_ingreso_resumido
integer x = 2578
integer y = 180
integer width = 709
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 255
long backcolor = 134217747
string text = "No hay sugerencias"
boolean focusrectangle = false
end type

event clicked;string			ls_cod_sub_cat, ls_cod_sub_linea, ls_desc_marca, ls_estilo
str_parametros lstr_param

//ls_cod_sub_cat 	= dw_master.object.cod_sub_cat 	[1]
//ls_cod_sub_linea 	= dw_master.object.cod_sub_linea [1]
ls_desc_marca 		= dw_master.object.nom_marca 		[1]
ls_estilo 			= dw_master.object.estilo 			[1]

if IsNull(ls_desc_marca) or trim(ls_desc_marca) = '' then
	MessageBox('Error', 'Debe ingresar una MARCA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_marca')
	return 
end if
/*
if IsNull(ls_cod_sub_linea) or trim(ls_cod_sub_linea) = '' then
	MessageBox('Error', 'Debe ingresar una SUB LINEA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_linea')
	return 
end if
*/
if IsNull(ls_estilo) or trim(ls_estilo) = '' then
	MessageBox('Error', 'Debe ingresar un ESTILO, por favor verifique!', StopSign!)
	dw_master.SetColumn('estilo')
	return 
end if

lstr_param.string1 = ls_desc_marca
lstr_param.string2 = ls_estilo
lstr_param.dw_m	 = dw_master

OpenWithParm(w_abc_lista_zapatos_sugeridos_general, lstr_param)

/*
string ls_busqueda2, ls_busqueda
		Datawindowchild dwc_campo
		ls_busqueda2= dw_master.object.cod_sub_cat [1]	
		ls_busqueda= dw_master.object.cod_linea [1]
		
		dw_master.getChild("cod_sub_linea",dwc_campo)
		dwc_campo.settransobject(sqlca)
		dwc_campo.retrieve(ls_busqueda,ls_busqueda2)*/
		
return 


end event

type p_1 from picture within w_abc_ingreso_resumido
integer x = 4197
integer y = 548
integer width = 453
integer height = 284
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_abc_ingreso_resumido
integer x = 4238
integer y = 372
integer width = 411
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finalizar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_traspaso from commandbutton within w_abc_ingreso_resumido
integer x = 4238
integer y = 268
integer width = 411
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transferir"
end type

event clicked;parent.event ue_aceptar()

integer i_contador
integer i_num_reg
 
i_contador = 1
i_num_reg = dw_detail.Rowcount()
do while i_contador <= i_num_reg
 
	dw_detail.Deleterow(1)
 
	i_contador++
 
Loop
end event

type shl_sugerencias from statichyperlink within w_abc_ingreso_resumido
integer x = 1755
integer y = 180
integer width = 722
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "No hay sugerencias"
boolean focusrectangle = false
end type

event clicked;string			ls_cod_sub_cat, ls_cod_sub_linea, ls_cod_marca, ls_estilo
str_parametros lstr_param

ls_cod_sub_cat 	= dw_master.object.cod_sub_cat 	[1]
ls_cod_sub_linea 	= dw_master.object.cod_sub_linea [1]
ls_cod_marca 		= dw_master.object.cod_marca 		[1]
ls_estilo 			= dw_master.object.estilo 			[1]

if IsNull(ls_cod_sub_cat) or trim(ls_cod_sub_cat) = '' then
	MessageBox('Error', 'Debe ingresar una SUB CATEGORIA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_cat')
	return 
end if

if IsNull(ls_cod_marca) or trim(ls_cod_marca) = '' then
	MessageBox('Error', 'Debe ingresar una MARCA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_marca')
	return 
end if
/*
if IsNull(ls_cod_sub_linea) or trim(ls_cod_sub_linea) = '' then
	MessageBox('Error', 'Debe ingresar una SUB LINEA, por favor verifique!', StopSign!)
	dw_master.SetColumn('cod_sub_linea')
	return 
end if
*/
if IsNull(ls_estilo) or trim(ls_estilo) = '' then
	MessageBox('Error', 'Debe ingresar un ESTILO, por favor verifique!', StopSign!)
	dw_master.SetColumn('estilo')
	return 
end if

lstr_param.string1 = ls_cod_sub_cat
lstr_param.string2 = ls_cod_marca
lstr_param.string3 = ls_estilo
lstr_param.dw_m	 = dw_master

OpenWithParm(w_abc_lista_zapatos_sugeridos, lstr_param)


string ls_busqueda2, ls_busqueda
		Datawindowchild dwc_campo
		ls_busqueda2= dw_master.object.cod_sub_cat [1]	
		ls_busqueda= dw_master.object.cod_linea [1]
		
		dw_master.getChild("cod_sub_linea",dwc_campo)
		dwc_campo.settransobject(sqlca)
		dwc_campo.retrieve(ls_busqueda,ls_busqueda2)
		
return 


end event

type cb_cancel from commandbutton within w_abc_ingreso_resumido
integer x = 4238
integer y = 116
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_aceptar from commandbutton within w_abc_ingreso_resumido
integer x = 4238
integer y = 12
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()

str_parametros lstr_param
lstr_param.b_return = true
CloseWithReturn(w_abc_ingreso_resumido, lstr_param)

end event

type dw_detail from u_dw_abc within w_abc_ingreso_resumido
integer y = 856
integer width = 4713
integer height = 972
integer taborder = 20
string dataobject = "d_abc_ingreso_resumido_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.talla 					[al_row] = 0
this.object.cantidad 				[al_row] = 0
this.object.precio_compra_old	[al_row] = 0
this.object.precio_compra_new	[al_row] = 0
this.object.flag_nuevo				[al_row] = '1'
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type dw_master from u_dw_abc within w_abc_ingreso_resumido
integer width = 4151
integer height = 844
string dataobject = "d_abc_ingreso_resumido_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

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

event ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_linea, ls_cod_sub_linea, ls_data2, &
			ls_cat_art
choose case lower(as_columna)
	case "cod_marca"
		ls_sql = "select m.cod_marca as codigo_marca, " &
				 + "m.nom_marca as nombre_marca " &
				 + "from marca m " &
				 + "where m.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_marca	[al_row] = ls_codigo
			this.object.nom_marca	[al_row] = ls_data

			this.object.cod_linea			[al_row] = gnvo_app.is_null
			this.object.desc_linea			[al_row] = gnvo_app.is_null
			this.object.cod_sub_linea		[al_row] = gnvo_app.is_null
			this.object.desc_sub_linea		[al_row] = gnvo_app.is_null
			this.object.estilo				[al_row] = gnvo_app.is_null
			
			//of_find_cat_subcat_art(al_row)
			this.ii_update = 1
		end if
		
	/*case "cod_linea"
		ls_sql = "select zl.cod_linea as codigo_linea, " &
				 + "zl.desc_linea as descripcion_linea, " &
				 + "zl.abreviatura as abreviatura " &
				 + "from zc_linea zl " &
				 + "where zl.flag_estado = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.cod_linea	[al_row] = ls_codigo
			this.object.desc_linea	[al_row] = ls_data
			this.object.abrev_linea	[al_row] = ls_data2
			
			this.object.cod_sub_linea		[al_row] = gnvo_app.is_null
			this.object.desc_sub_linea		[al_row] = gnvo_app.is_null
			this.object.estilo				[al_row] = gnvo_app.is_null
		
			
			//of_find_cat_subcat_art(al_row)
			this.ii_update = 1
		end if
		*/
	/*case "cod_sub_linea"
		ls_cod_linea = this.object.cod_linea [al_row]
		
		if IsNull(ls_cod_linea) or trim(ls_cod_linea) = '' then
			MessageBox('Error', 'Debe Seleccionar un código de linea, por favor verifique!', StopSign!)
			this.setColumn('cod_linea')
			return
		end if
		
		ls_sql = "select zsl.cod_sub_linea as codigo_sub_linea, " &
				 + "zsl.desc_sub_linea as descripcion_sub_linea " &
				 + "from zc_sub_linea zsl " &
				 + "where zsl.cod_linea = '" + ls_cod_linea + "'" &
				 + "  and zsl.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_sub_linea	[al_row] = ls_codigo
			this.object.desc_sub_linea	[al_row] = ls_data
			
			//of_find_cat_subcat_art(al_row)
			this.object.estilo				[al_row] = gnvo_app.is_null
			
			this.ii_update = 1
		end if
*/
	case "cod_suela"
		ls_sql = "select zs.cod_suela as codigo_suela, " &
				 + "zs.desc_suela as descripcion_suela " &
				 + "from zc_suela zs " &
				 + "where zs.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_suela	[al_row] = ls_codigo
			this.object.desc_suela	[al_row] = ls_data
			
			//of_find_cat_subcat_art(al_row)
			this.ii_update = 1
		end if

	case "cod_acabado"
		ls_sql = "select za.cod_acabado as codigo_acabado, " &
				 + "za.desc_acabado as descripcion_acabado " &
				 + "from zc_acabado za " &
				 + "where za.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_acabado		[al_row] = ls_codigo
			this.object.desc_acabado	[al_row] = ls_data
			
			//of_find_cat_subcat_art(al_row)
			this.ii_update = 1
		end if

	case "color1"
		ls_sql = "select c.color as codigo_color, " &
				 + "c.descripcion as descripcion_color " &
				 + "from color c"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.color1			[al_row] = ls_codigo
			this.object.color_primario	[al_row] = ls_data
			
			//of_find_cat_subcat_art(al_row)
			this.ii_update = 1
		end if		
		
	case "color2"
		ls_sql = "select c.color as codigo_color, " &
				 + "c.descripcion as descripcion_color " &
				 + "from color c"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.color2				[al_row] = ls_codigo
			this.object.color_secundario	[al_row] = ls_data
			
			//of_find_cat_subcat_art(al_row)
			
			this.ii_update = 1
		end if		

	case "cod_taco"
		ls_sql = "select zt.cod_taco as codigo_taco, " &
				 + "zt.desc_taco as descripcion_taco " &
				 + "from zc_taco zt " &
				 + "where zt.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_taco		[al_row] = ls_codigo
			this.object.desc_taco	[al_row] = ls_data
			
			//of_find_cat_subcat_art(al_row)
			this.ii_update = 1
		end if		

	case "estilo"

		ls_cod_sub_linea = this.object.cod_sub_linea [al_row]
		
		if IsNull(ls_cod_sub_linea) or trim(ls_cod_sub_linea) = '' then
			MessageBox('Error', 'Debe Seleccionar un código de Sub linea, por favor verifique!', StopSign!)
			this.setColumn('cod_sub_linea')
			return
		end if
		
		ls_sql = "select distinct a.cod_sub_linea as codigo_sub_linea, " &
				 + "a.estilo as estilo " &
				 + "from articulo a " &
				 + "where a.flag_estado = '1' " &
				 + "  and a.cod_sub_linea = '" + ls_cod_sub_linea + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.estilo	[al_row] = ls_data
			
			of_sugerencias(al_row)
			this.ii_update = 1
		end if	
/*
	case "cat_art"
		ls_sql = "select ac.cat_art as codigo_categoria, " &
				 + "ac.desc_categoria as descripcion_categoria, " &
				 + "ac.abreviatura as abreviatura_categ " &
				 + "from articulo_categ ac " &
				 + "where ac.flag_estado = '1' " &
				 + "and ac.abreviatura is not null"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.cat_art				[al_row] = ls_codigo
			this.object.desc_categoria		[al_row] = ls_data
			this.object.abrev_categoria	[al_row] = ls_data2
			
			this.object.cod_sub_cat			[al_row] = gnvo_app.is_null
			this.object.desc_sub_cat		[al_row] = gnvo_app.is_null
			this.object.cod_marca			[al_row] = gnvo_app.is_null
			this.object.nom_marca			[al_row] = gnvo_app.is_null
			this.object.cod_linea			[al_row] = gnvo_app.is_null
			this.object.desc_linea			[al_row] = gnvo_app.is_null
			this.object.cod_sub_linea		[al_row] = gnvo_app.is_null
			this.object.desc_sub_linea		[al_row] = gnvo_app.is_null
			this.object.estilo				[al_row] = gnvo_app.is_null
			
			this.ii_update = 1
		end if		
		*/
	/*case "cod_sub_cat"
		ls_cat_art = this.object.cat_art [al_row]
		
		if IsNull(ls_cat_art) or trim(ls_cat_art) = '' then
			MessageBox('Error', 'Debe Seleccionar una CATEGORIA DE ARTICULOS, por favor verifique!', StopSign!)
			this.setColumn('cat_art')
			return
		end if
		
		ls_sql = "select a2.cod_sub_cat as codigo_sub_categoria, " &		
				 + "a2.desc_sub_cat as descripcion_sub_categoria " &
				 + "from articulo_sub_categ a2 " &
				 + "where a2.flag_estado = '1'" &
				 + "  and a2.cat_art = '" + ls_cat_art + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data,'2')

		if ls_codigo <> '' then
			this.object.cod_sub_cat			[al_row] = ls_codigo
			this.object.desc_sub_cat		[al_row] = ls_data

			this.object.cod_marca			[al_row] = gnvo_app.is_null
			this.object.nom_marca			[al_row] = gnvo_app.is_null
			this.object.cod_linea			[al_row] = gnvo_app.is_null
			this.object.desc_linea			[al_row] = gnvo_app.is_null
			this.object.cod_sub_linea		[al_row] = gnvo_app.is_null
			this.object.desc_sub_linea		[al_row] = gnvo_app.is_null
			this.object.estilo				[al_row] = gnvo_app.is_null
		
			this.ii_update = 1
		end if		
*/
	case "und"
		ls_sql = "select t.und as unidad, " &
				 + "t.desc_unidad as descripcion_unidad " &
				 + "from unidad t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.und				[al_row] = ls_codigo
			this.object.desc_unidad		[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "cod_clase"
		ls_sql = "select t.cod_clase as codigo_clase, " &
				 + "t.desc_clase as descripcion_clase " &
				 + "from articulo_clase t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_clase	[al_row] = ls_codigo
			this.object.desc_clase	[al_row] = ls_data
			
			this.ii_update = 1
		end if		


end choose
end event

event buttonclicked;call super::buttonclicked;this.Accepttext()

CHOOSE CASE lower(dwo.name)
		
	CASE 'b_procesar'
		
		of_procesar(row)
		
	CASE 'b_color1'
		
		of_color(row, 'primario')

	CASE 'b_color2'
		
		of_color(row, 'secundario')

	CASE 'b_sub_linea'
		
		of_sub_linea(row)
	
	
	CASE 'b_suela'
		
		of_sUELA(row)
		
END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.precio 		[al_row] = 0.00
this.object.talla_min 	[al_row] = 0.00
this.object.talla_max 	[al_row] = 0.00
this.object.incremento 	[al_row] = 1.00
end event

event itemchanged;call super::itemchanged;boolean lb_ret
string 	ls_data, ls_data2, ls_cod_linea, ls_cod_sub_linea, ls_cat_art

String ls_sql, ls_codigo

string ls_busqueda, ls_busqueda2
DatawindowChild dwc_campo

this.Accepttext()

CHOOSE CASE lower(dwo.name)

	case "cat_art"
		
		select desc_categoria, abreviatura
			into :ls_data, :ls_data2
			from articulo_categ
		where cat_art = :data
		  and flag_estado = '1'
		  and abreviatura is not null;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cat_art				[row] = gnvo_app.is_null
			this.object.desc_categoria		[row] = gnvo_app.is_null
			this.object.abrev_categoria	[row] = gnvo_app.is_null
			
			this.object.cod_sub_cat			[row] = gnvo_app.is_null
			this.object.desc_sub_cat		[row] = gnvo_app.is_null
			this.object.cod_marca			[row] = gnvo_app.is_null
			this.object.nom_marca			[row] = gnvo_app.is_null
			this.object.cod_linea			[row] = gnvo_app.is_null
			this.object.desc_linea			[row] = gnvo_app.is_null
			this.object.abrev_linea			[row] = gnvo_app.is_null
			this.object.cod_sub_linea		[row] = gnvo_app.is_null
			this.object.desc_sub_linea		[row] = gnvo_app.is_null
			this.object.estilo				[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de CATEGORIA no existe, no esta activo o no tiene asignado una abreviatura, por favor verifique')
			return 1
		end if

		this.object.desc_categoria		[row] = ls_data
		this.object.abrev_categoria	[row] = ls_data2

		this.object.cod_sub_cat			[row] = gnvo_app.is_null
		this.object.desc_sub_cat		[row] = gnvo_app.is_null
		this.object.cod_marca			[row] = gnvo_app.is_null
		this.object.nom_marca			[row] = gnvo_app.is_null
		this.object.cod_linea			[row] = gnvo_app.is_null
		this.object.desc_linea			[row] = gnvo_app.is_null
		this.object.abrev_linea			[row] = gnvo_app.is_null
		this.object.cod_sub_linea		[row] = gnvo_app.is_null
		this.object.desc_sub_linea		[row] = gnvo_app.is_null
		this.object.estilo				[row] = gnvo_app.is_null
		
		
	ls_busqueda= this.object.cat_Art [row]	
	dw_master.getChild("cod_sub_cat",dwc_campo)
	dwc_campo.settransobject(sqlca)
 	dwc_campo.retrieve(ls_busqueda)
	 	
		
		this.ii_update = 1	
		
	case "cod_sub_cat"
		
		ls_cat_art = this.object.cat_art [row]
		
		if IsNull(ls_cat_art) or trim(ls_cat_art) = '' then
			MessageBox('Error', 'Debe Seleccionar una CATEGORIA DE ARTICULOS, por favor verifique!', StopSign!)
			this.setColumn('cat_art')
			return
		end if
		
		select desc_sub_cat
			into :ls_data
			from articulo_sub_categ
		where cat_art = :ls_cat_art
		  and cod_sub_cat = :data
		  and flag_estado = '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			
			this.object.cod_sub_cat			[row] = gnvo_app.is_null
			this.object.desc_sub_cat		[row] = gnvo_app.is_null
			
			this.object.cod_marca			[row] = gnvo_app.is_null
			this.object.nom_marca			[row] = gnvo_app.is_null
			this.object.cod_linea			[row] = gnvo_app.is_null
			this.object.desc_linea			[row] = gnvo_app.is_null
			this.object.abrev_linea			[row] = gnvo_app.is_null
			this.object.cod_sub_linea		[row] = gnvo_app.is_null
			this.object.desc_sub_linea		[row] = gnvo_app.is_null
			this.object.estilo				[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de SUB CATEGORIA no existe, no esta activo o no existe para la categoria seleccionada , por favor verifique')
			return 1
		end if

		this.object.desc_sub_cat		[row] = ls_data
		
		//this.object.cod_marca			[row] = gnvo_app.is_null
		//this.object.nom_marca			[row] = gnvo_app.is_null
		this.object.cod_linea			[row] = gnvo_app.is_null
		this.object.desc_linea			[row] = gnvo_app.is_null
		this.object.abrev_linea			[row] = gnvo_app.is_null
		this.object.cod_sub_linea		[row] = gnvo_app.is_null
		this.object.desc_sub_linea		[row] = gnvo_app.is_null
		//this.object.estilo				[row] = gnvo_app.is_null
			
		ls_busqueda= this.object.cod_linea [row]
		ls_busqueda2= this.object.cod_sub_cat [row]	
		
		dw_master.getChild("cod_sub_linea",dwc_campo)
		dwc_campo.settransobject(sqlca)
		dwc_campo.retrieve(ls_busqueda,ls_busqueda2)
		
		this.ii_update = 1	
		
		
	case "cod_marca"
		
		select nom_marca
			into :ls_data
			from marca
		where cod_marca = :data
		  and flag_estado = '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_marca			[row] = gnvo_app.is_null
			this.object.nom_marca			[row] = gnvo_app.is_null

			this.object.cod_linea			[row] = gnvo_app.is_null
			this.object.desc_linea			[row] = gnvo_app.is_null
			this.object.abrev_linea			[row] = gnvo_app.is_null
			this.object.cod_sub_linea		[row] = gnvo_app.is_null
			this.object.desc_sub_linea		[row] = gnvo_app.is_null
			this.object.estilo				[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de MARCA no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_marca			[row] = ls_data
		
		this.object.cod_linea			[row] = gnvo_app.is_null
		this.object.desc_linea			[row] = gnvo_app.is_null
		this.object.abrev_linea			[row] = gnvo_app.is_null
		this.object.cod_sub_linea		[row] = gnvo_app.is_null
		this.object.desc_sub_linea		[row] = gnvo_app.is_null
		this.object.estilo				[row] = gnvo_app.is_null
		
		this.ii_update = 1

		  
		
	case "cod_linea"
		select desc_linea, abreviatura
			into :ls_data, :ls_data2
			from zc_linea
		where cod_linea = :data
		  and flag_estado = '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_linea			[row] = gnvo_app.is_null
			this.object.desc_linea			[row] = gnvo_app.is_null
			this.object.abrev_linea			[row] = gnvo_app.is_null

			//this.object.cod_sub_linea		[row] = gnvo_app.is_null
			//this.object.desc_sub_linea		[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de LINEA no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_linea			[row] = ls_data
		this.object.abrev_linea			[row] = ls_data2
		  
		//this.object.cod_sub_linea		[row] = gnvo_app.is_null
		//this.object.desc_sub_linea		[row] = gnvo_app.is_null
		this.ii_update = 1		
		
		
	case "cod_sub_linea"

		ls_cod_linea = this.object.cod_linea [row]
		
		if IsNull(ls_cod_linea) or trim(ls_cod_linea) = '' then
			MessageBox('Error', 'Debe Seleccionar un código de linea, por favor verifique!', StopSign!)
			this.setColumn('cod_linea')
			return 1
		end if

		select desc_sub_linea
			into :ls_data
			from zc_sublinea
		where cod_sub_linea 	= :data
		  and flag_estado 	= '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_sub_linea	[row] = gnvo_app.is_null
			this.object.desc_sub_linea	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de SUB LINEA no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_sub_linea		[row] = ls_data
  
		this.ii_update = 1		
		
		
	case "cod_suela"

		select desc_suela
			into :ls_data
			from zc_suela
		where cod_suela 	= :data
		  and flag_estado 	= '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_suela	[row] = gnvo_app.is_null
			this.object.desc_suela	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de SUELA no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_suela	[row] = ls_data
  
		this.ii_update = 1		
		

	case "cod_acabado"
		
		select desc_acabado
			into :ls_data
			from zc_acabado
		where cod_acabado 	= :data
		  and flag_estado 	= '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_acabado	[row] = gnvo_app.is_null
			this.object.desc_acabado	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de ACABADO no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_acabado	[row] = ls_data
  
		this.ii_update = 1		


	case "color1"
		select descripcion
			into :ls_data
			from color
		where color 	= :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.color1			[row] = gnvo_app.is_null
			this.object.color_primario	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de COLOR PRIMARIO no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.color_primario	[row] = ls_data
  
		this.ii_update = 1		

	case "color2"
		select descripcion
			into :ls_data
			from color
		where color 	= :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.color2				[row] = gnvo_app.is_null
			this.object.color_secundario	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de COLOR PRIMARIO no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.color_secundario	[row] = ls_data
  
		this.ii_update = 1		

	case "cod_taco"
		select desc_taco
			into :ls_data
			from zc_taco
		where cod_taco 	= :data
		  and flag_estado	= '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_taco		[row] = gnvo_app.is_null
			this.object.desc_taco	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de TACO no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_taco	[row] = ls_data
  
		this.ii_update = 1		

	case "estilo"

		of_sugerencias(row)


	case "und"
		select desc_unidad
			into :ls_data
			from unidad
		where und 	= :data
		  and flag_estado	= '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.und		[row] = gnvo_app.is_null
			this.object.desc_unidad	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de UNIDAD no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_unidad	[row] = ls_data
  
		this.ii_update = 1		

	case "cod_clase"
		select desc_clase
			into :ls_data
			from articulo_clase
		where cod_clase 	= :data
		  and flag_estado	= '1';

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_clase	[row] = gnvo_app.is_null
			this.object.desc_clase	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de CLASE no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_clase	[row] = ls_data
  
		this.ii_update = 1		

end choose
end event

