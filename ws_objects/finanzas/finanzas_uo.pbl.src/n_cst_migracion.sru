$PBExportHeader$n_cst_migracion.sru
forward
global type n_cst_migracion from nonvisualobject
end type
end forward

global type n_cst_migracion from nonvisualobject
end type
global n_cst_migracion n_cst_migracion

forward prototypes
public function boolean of_migra_terreno (u_dw_abc adw_master, long al_row)
public function boolean of_procesa_almacen (ref u_dw_abc adw_master, long al_row)
public function boolean of_procesa_cliente (ref u_dw_abc adw_master, long al_row)
public function boolean of_procesa_articulo (ref u_dw_abc adw_master, long al_row)
public function boolean of_procesa_stock (ref u_dw_abc adw_master, long al_row)
public function boolean of_procesa_cntas_cobrar (ref u_dw_abc adw_master, long al_row)
public function boolean of_procesa_centro_benef (ref u_dw_abc adw_master, long al_row)
public function boolean of_procesa_cencos (ref u_dw_abc adw_master, long al_row)
end prototypes

public function boolean of_migra_terreno (u_dw_abc adw_master, long al_row);Long ll_row

//1.- Proceso el almacen
if not this.of_procesa_almacen(adw_master, al_row) then return false

//2.-Proceso el articulo
if not this.of_procesa_articulo(adw_master, al_row) then return false

//3.- Proceso el stock de ese articulo en almacen
if not this.of_procesa_stock(adw_master, al_row) then return false

//4.- Proceso al cliente
if not this.of_procesa_cliente(adw_master, al_row) then return false

//5.- Proceso el centro de beneficio
if not this.of_procesa_centro_benef(adw_master, al_row) then return false

//6.- Proceso el centro de costo
//if not this.of_procesa_cencos(adw_master, al_row) then return false

//7.- Proceso la cuenta por cobrar
if not this.of_procesa_cntas_cobrar(adw_master, al_row) then return false

//Indico que ha sido procesado
adw_master.object.procesado [al_row] = '1'

return true
end function

public function boolean of_procesa_almacen (ref u_dw_abc adw_master, long al_row);String	ls_desc_almacen, ls_almacen, ls_mensaje
Long 		ll_count

ls_desc_almacen = adw_master.object.desc_centro	[al_row]

ls_desc_almacen = 'ALMACEN LOTES ' + ls_desc_almacen

select almacen
	into :ls_almacen
from almacen
where desc_almacen = :ls_desc_almacen;

if SQLCA.SQLCode = 100 then
	//En caso de no existir creo uno
	select max(almacen)
		into :ls_almacen
	from almacen
	where almacen like 'ALLT%';
	
	if ISNull(ls_almacen) or trim(ls_almacen) = '' then
		ls_almacen = 'ALLT01'
	else
		ls_almacen = 'ALLT' + string(Integer(right(ls_almacen,2)) + 1, '00')
	end if
	
	//inserto el registro
	insert into almacen(
		almacen, flag_tipo_almacen, desc_almacen, cod_origen, flag_estado, flag_cntrl_lote, cod_sunat)	
	values(
		:ls_almacen, 'M', :ls_desc_almacen, :gs_origen, '1', '0', '01');
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error en of_procesa_almacen: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

end if



adw_master.object.almacen [al_row] = ls_almacen

return true
end function

public function boolean of_procesa_cliente (ref u_dw_abc adw_master, long al_row);String	ls_tipo_doc_ident, ls_ruc_dni, ls_nom_proveedor, ls_proveedor, ls_mensaje, &
			ls_nro_doc_ident, ls_ruc, ls_apellido_pat, ls_apellido_mat, ls_nombre1, ls_nombre2, &
			ls_p1, ls_p2, ls_p3, ls_p4, ls_tmp
Long 		ll_ult_nro, ll_pos, ll_count

ls_tipo_doc_ident = adw_master.object.tipo_doc_ident 	[al_row]
ls_ruc_dni 			= adw_master.object.ruc_dni 			[al_row]
ls_nom_proveedor 	= adw_master.object.nom_proveedor 	[al_row]

if ls_tipo_doc_ident = '1' then
	ls_nro_doc_ident = ls_ruc_dni
	SetNull(ls_ruc)
else
	ls_ruc = ls_ruc_dni
	SetNull(ls_nro_doc_ident)
end if

//Separo los nombres
ls_tmp = trim(ls_nom_proveedor)

//Parte 1
ll_pos = pos(ls_tmp, ' ')
if ll_pos > 0 then
	ls_p1 = trim(mid(ls_tmp, 1, ll_pos - 1))
	ls_tmp = trim(mid(ls_tmp, ll_pos + 1))
else
	ls_p1 = ''
	ls_tmp = ''
end if

//Parte 2
if ls_tmp <> '' then
	ll_pos = pos(ls_tmp, ' ')
	if ll_pos > 0 then
		ls_p2 	= trim(mid(ls_tmp, 1, ll_pos - 1))
		ls_tmp 	= trim(mid(ls_tmp, ll_pos + 1))
	else
		ls_p2 = ''
		ls_tmp = ''
	end if
else
	ls_p2 = ''
end if

//Parte 3
if ls_tmp <> '' then
	ll_pos = pos(ls_tmp, ' ')
	if ll_pos > 0 then
		ls_p3 = trim(mid(ls_tmp, 1, ll_pos - 1))
		ls_tmp = trim(mid(ls_tmp, ll_pos + 1))
	else
		ls_p3 = ''
	end if
else
	ls_p3 = ''
end if

//Parte 4
if ls_tmp <> '' then
	ls_p4 = ls_tmp
else
	ls_p4 = ''
end if

if IsNull(ls_p4) or trim(ls_p4) = '' then
	ls_nombre1 			= ls_p1
	ls_apellido_pat 	= ls_p2
	ls_apellido_mat 	= ls_p3
else
	ls_nombre1 			= ls_p1
	ls_nombre2 			= ls_p2
	ls_apellido_pat 	= ls_p3
	ls_apellido_mat 	= ls_p4
end if


select count(*)
	into :ll_count
from proveedor
where nom_proveedor = :ls_nom_proveedor;

if ll_count = 0 then

	if ls_tipo_doc_ident = '1' then
		
		//Busco por dni
		select count(*)
		  into :ll_count
		from proveedor
		where tipo_doc_ident = :ls_tipo_doc_ident
		  and nro_doc_ident	= :ls_ruc_dni;
		
		if ll_count > 0 then
			select proveedor
			  into :ls_proveedor
			from proveedor
			where tipo_doc_ident = :ls_tipo_doc_ident
			  and nro_doc_ident	= :ls_ruc_dni;
		end if
		
	else

		//Busco por ruc
		select count(*)
		  into :ll_count
		from proveedor
		where ruc	= :ls_ruc_dni;

		if ll_count > 0 then
			select proveedor
			  into :ls_proveedor
			from proveedor
			where ruc	= :ls_ruc_dni;
		end if

	end if
	
	
else
	
	select proveedor
		into :ls_proveedor
	from proveedor
	where nom_proveedor = :ls_nom_proveedor;

end if

if ll_count = 0 then
	//Obtengo el siguiente numerador
	select ult_nro
		into :ll_ult_nro
	from num_proveedor
	where origen = 'XX' for update;
	
	if SQLCA.SQlCode  = 100 then
		ll_ult_nro = 1
		
		insert into num_proveedor(
			ult_nro, origen)
		values(
			:ll_ult_nro, 'XX');

		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Aviso', 'Ha ocurrido al insertar en tabla num_proveedor, en of_procesa_cliente: ' + ls_mensaje, StopSign!)
			return false
		end if
			
	end if
	
	ls_proveedor = 'E' + string(ll_ult_nro, '0000000')
	
	//Actualizo el numerador
	update num_proveedor 
	   set ult_nro = :ll_ult_nro + 1
	where origen = 'XX';
	
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido al actualizar en tabla num_proveedor, en of_procesa_cliente: ' + ls_mensaje, StopSign!)
		return false
	end if
		
	if ls_tipo_doc_ident = '1' then
	
		ls_nro_doc_ident = ls_ruc_dni
		setNull(ls_ruc)
		
	else
		//Busco por ruc
		SetNull(ls_nro_doc_ident)
		ls_ruc = ls_ruc_dni
		
	end if

	
	//inserto el registro
	insert into proveedor(
		proveedor, flag_estado, flag_trabajador, flag_clie_prov, flag_tipo_precio, tipo_proveedor,
		nom_proveedor, ruc, flag_personeria,cod_usr,flag_ret_igv,flag_detracion, flag_nac_ext,
		tipo_doc_ident, nro_doc_ident, flag_adeuda_sunat, flag_padron_sunat, fec_registro,
		APELLIDO_PAT, APELLIDO_MAT, nombre1, nombre2)
	values(
		:ls_proveedor, '1', '0', '0', '1', '02', 
		:ls_nom_proveedor, :ls_ruc, 'N', :gs_user, '0', '0', 'N',
		:ls_tipo_doc_ident, :ls_nro_doc_ident, '0', '0', sysdate,
		:ls_apellido_pat, :ls_apellido_mat, :ls_nombre1, :ls_nombre2);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error al insertar en tabla proveedor, en of_procesa_cliente: ' + ls_mensaje, StopSign!)
		return false
	end if
	
else
	update proveedor
	   set nom_proveedor 	= :ls_nom_proveedor,
			 APELLIDO_PAT		= :ls_apellido_pat,
			 APELLIDO_MAT		= :ls_apellido_mat,
			 nombre1				= :ls_nombre1,
			 nombre2				= :ls_nombre2,
			 tipo_doc_ident 	= :ls_tipo_doc_ident,
			 nro_doc_ident		= :ls_nro_doc_ident,
			 ruc					= :ls_ruc
	where proveedor = :ls_proveedor;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error al actualizar tabla proveedor, en of_procesa_cliente: ' + ls_mensaje, StopSign!)
		return false
	end if

end if


commit;

adw_master.object.proveedor [al_row] = ls_proveedor

return true
end function

public function boolean of_procesa_articulo (ref u_dw_abc adw_master, long al_row);String	ls_desc_art, ls_cod_lote, ls_desc_centro, ls_cod_art, ls_categ, ls_subcateg, &
			ls_desc_categ, ls_desc_subcateg, ls_mensaje, ls_mnz, ls_lote
Long		ll_count, ll_rx
Integer	li_area

//Obtengo el codigo del articulo
ls_desc_centro = adw_master.object.desc_centro	[al_row]
ls_cod_lote		= adw_master.object.cod_lote		[al_row]
li_area			= Integer(adw_master.object.area	[al_row])

if pos(ls_cod_lote, '-') > 0 then
	ls_mnz = mid(ls_cod_lote, 1, pos(ls_cod_lote, '-') - 1)
else
	ls_mnz = ''
end if

if pos(ls_cod_lote, '-') > 0 then
	ls_lote = mid(ls_cod_lote, pos(ls_cod_lote, '-') + 1)
else
	ls_lote = ''
end if

if ls_mnz = 'PA' then
	ls_desc_art = trim(ls_desc_centro)
else
	ls_desc_art = 'PROYECTO ' + trim(ls_desc_centro) + ', LOTE ' + trim(ls_cod_lote)
end if

select cod_art
	into :ls_cod_art
from articulo
where desc_art = :ls_desc_art;

if SQLCA.SQLCode = 100 then

	//En caso de no existir creo uno
	
	//Verifico si existe la categoria
	ls_desc_categ = 'LOTES DE TERRENO'
	
	select cat_art
		into :ls_categ
	from articulo_categ
	where desc_categoria = :ls_desc_categ;
	
	if SQLCA.SQLCode = 100 then
		
		select max(cat_art)
		 	into :ls_categ
		from articulo_categ;
		
		if IsNull(ls_categ) or trim(ls_categ) = '' then
			ls_categ = '001'
		else
			ls_categ = string(Integer(ls_categ) + 1, '000')
		end if
		
		//inserto la categoria
		insert into articulo_categ(
			cat_art, desc_categoria, flag_servicio, flag_art_mant, flag_estado)
		values(
			:ls_categ, :ls_desc_categ, '0', '0', '1');

		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Aviso', 'Ha ocurrido un error en insertar en tabla articulo_categ en of_procesa_articulo: ' + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	//Verifico si existe o no la subcategoría
	ls_desc_subcateg = 'LOTES TERRENO ' + trim(ls_desc_centro) 

	select cod_sub_cat
		into :ls_subcateg
	from articulo_sub_categ
	where desc_sub_cat = :ls_desc_subcateg;
	
	if SQLCA.SQLCode = 100 then
		
		select max(cod_sub_cat)
		 	into :ls_subcateg
		from articulo_sub_categ
		where cat_art = :ls_categ;
		
		if IsNull(ls_subcateg) or trim(ls_subcateg) = '' then
			ls_subcateg = trim(ls_categ) + '001'
		else
			ls_subcateg = trim(ls_categ) + string(Integer(right(ls_subcateg,3)) + 1, '000')
		end if
		
		//inserto la subcategoria
		insert into articulo_sub_categ(
			cod_sub_cat, cat_art, desc_sub_cat, flag_servicio, flag_art_mant, flag_estado)
		values(
			:ls_subcateg, :ls_categ, :ls_desc_subcateg, '0', '0', '1');

		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Aviso', 'Ha ocurrido un error en insertar en tabla articulo_sub_categ en of_procesa_articulo: ' + ls_mensaje, StopSign!)
			return false
		end if
	
	end if
	
	//Obtengo el siguiente codigo de articulo
	select max(cod_art)
		into :ls_cod_art
	from articulo a
	where a.sub_cat_art = :ls_subcateg;
	
	if ISNull(ls_cod_art) or trim(ls_cod_art) = '' then
		
		ls_cod_art = trim(ls_subcateg) + '.00001'
	else
		ll_rx = pos(ls_cod_art, '.')
		
		if ll_rx = 0 then
			ROLLBACK;
			MEssageBox('Aviso', 'Código de artículo ' + ls_cod_art + ' no tiene un punto que separe la subcategoría del correlativo', StopSign!)
			return false
		end if
		
		ls_cod_art = mid(ls_cod_art, ll_rx + 1)
		
		ls_cod_art = trim(ls_subcateg) + '.' + string(Integer(ls_cod_art) + 1, '00000')
	end if
		
	//inserto el articulo
	insert into articulo(
		cod_art, nom_articulo, desc_art, sub_cat_art, flag_estado,
		flag_reposicion,	flag_critico,	flag_obsoleto,	und,	cod_clase,
		vol_und,	
		sldo_total,	sldo_por_llegar,	sldo_solicitado,	sldo_devuelto,	
		sldo_prestamo,	sldo_consignacion,	sldo_reservado,
		sldo_minimo,	sldo_maximo,	dias_reposicion,	cnt_compra_rec,
		flag_inventariable,	flag_und2,	flag_cntrl_lote,	sldo_total_und2,
		flag_cntrl_req,	costo_prom_sol,	costo_prom_dol,	costo_ult_compra,
		fec_registro,	sldo_warranteado,	sldo_transportado,	flag_iqpf,
		flag_percepcion,
		porc_vta_unidad,	precio_vta_unidad,	porc_vta_mayor,	precio_vta_mayor,
		dscto_compra2,
		flag_repos_almacen,
		porc_vta_oferta,	precio_vta_oferta,	precio_vta_min,	porc_vta_min,
		mnz, lote,
		cod_usr)
	values(
		:ls_cod_art, substr(:ls_desc_art, 1, 60), :ls_desc_art, :ls_subcateg, '1',
		'0', '0', '0', 'UND', '02',
		:li_area, 
		0, 0, 0, 0,
		0, 0, 0,
		0, 0, 7, 0,
		'1', '0', '0', 0,
		'0', 0.00, 0.00, 0.00,
		sysdate, 0.00, 0.00, '0',
		'0',
		0.00, 0.00, 0.00, 0.00,
		0.00,
		'0',
		0.00,	0.00,	0.00,	0.00,
		:ls_mnz, :ls_lote,
		:gs_user);
		
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error en insertar en tabla articulo en of_procesa_articulo: ' + ls_mensaje, StopSign!)
		return false
	end if
	

	

else
	update articulo 
	   set mnz 		= :ls_mnz,
			 lote 	= :ls_lote,
			 vol_und = :li_area
	where cod_art = :ls_cod_art;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error al actualizar tabla articulo en of_procesa_articulo: ' + ls_mensaje, StopSign!)
		return false
	end if

end if

commit;


adw_master.object.cod_art 	[al_row] = ls_cod_art
adw_master.object.desc_art [al_row] = ls_desc_art

return true
end function

public function boolean of_procesa_stock (ref u_dw_abc adw_master, long al_row);String	ls_almacen, ls_cod_art, ls_origen, ls_mensaje, ls_nro_vale, ls_matriz
Long 		ll_count, ll_ult_nro
decimal	ldc_saldo_total
date 		ld_fec_vencimiento

try 
	ls_cod_art				= adw_master.object.cod_art					[al_row]
	ls_almacen				= adw_master.object.almacen					[al_row]
	ld_fec_vencimiento	= Date(adw_master.object.fec_vencimiento	[al_row])
	
	
	//VErifico si existe un ingreso por producción de ese lote
	select count(*)
		into :ll_count
	from 	vale_mov			vm,
			articulo_mov 	am
	where vm.nro_Vale	= am.nro_vale
	  and vm.flag_estado <> '0'
	  and am.flag_estado	<> '0'
	  and am.cod_art	= :ls_cod_art
	  and vm.almacen	= :ls_almacen
	  and vm.tipo_mov	= :gnvo_app.logistica.is_oper_ing_prod;
	
	if ll_count = 0 then
		//Obtengo el origen del almacen
		select cod_origen
			into :ls_origen
		from almacen
		where almacen = :ls_almacen
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'El almacen ' + ls_almacen + ' no existe o no se encuentra activo, por favor verifique!', StopSign!)
			return false
		end if
		
		//Obtengo el nro de vale
		select ult_nro
			into :ll_ult_nro
		from num_Vale_mov
		where origen = :ls_origen for update;
		
		if SQLCA.SQLCode = 100 then
			ll_ult_nro = 1
			
			insert into num_vale_mov(ult_nro, origen)
			values(:ll_ult_nro, :ls_origen);
	
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al insertar registro en tabla num_vale_mov. Mensaje de Error: ' + ls_mensaje, StopSign!)
				return false
			end if
		end if
		
		ls_nro_Vale = trim(ls_origen) + string(ll_ult_nro, '00000000')
		
		//Actualizo el numerador
		update num_vale_mov 
			set ult_nro = :ll_ult_nro + 1
		where origen = :ls_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al actualizar tabla num_vale_mov. Mensaje de Error: ' + ls_mensaje, StopSign!)
			return false
		end if
	
		//Ingreso la cabecera del movimiento de almacen
		insert into vale_mov(
			cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
			tipo_mov, 
			cod_usr,
			nom_receptor, observaciones)
		values(
			:ls_origen, :ls_nro_Vale, :ls_almacen, '1', :ld_fec_vencimiento, 
			:gnvo_app.logistica.is_oper_ing_prod,
			:gs_user,
			'MIGRACIÓN DE CALENDARIO DE PAGOS', 
			'GENERADO DE MANERA AUTOMATICA POR EL PROCESO DE CALENDARIO DE PAGOS');
	
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al INSERTAR tabla vale_mov. Mensaje de Error: ' + ls_mensaje, StopSign!)
			return false
		end if
	
		
		//Obtengo la matriz contable
		ls_matriz = gnvo_app.almacen.of_get_matriz_cntbl(gnvo_app.logistica.is_oper_ing_prod, gnvo_app.is_null, ls_cod_art)
		
		//Ingreso EL DETALLE DEL MOVIMIENTO DE ALMACEN	
		insert into articulo_mov(
			cod_origen,			nro_vale,	flag_estado,	cod_art,
			cant_procesada,	precio_unit,	
			cod_moneda,
			matriz,
			fec_registro )
		values(
			:ls_origen, :ls_nro_Vale, '1', :ls_cod_art,
			1, 		0,			
			:gnvo_app.is_soles,
			:ls_matriz,
			sysdate);
	
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al INSERTAR tabla articulo_mov. Mensaje de Error: ' + ls_mensaje, StopSign!)
			return false
		end if
	
		
		commit;
	
	end if
	
	return true

catch ( Exception ex )
	ROLLBACK;
	gnvo_app.of_catch_exception(ex, '')
end try


end function

public function boolean of_procesa_cntas_cobrar (ref u_dw_abc adw_master, long al_row);String	ls_tipo_doc, ls_proveedor, ls_nro_letra, ls_serie, ls_observacion, ls_nro_doc, &
			ls_mensaje, ls_cod_moneda, ls_cod_art, ls_centro_benef, ls_flag_estado, &
			ls_desc_centro
Long 		ll_ult_nro, ll_count
Decimal	ldc_saldo_pagar, ldc_interes, ldc_amortizacion, ldc_cuota_pagar, ldc_tasa_cambio, &
			ldc_imp_soles, ldc_imp_dolares
Date		ld_fec_vencimiento

ls_tipo_doc 			= adw_master.object.tipo_doc					[al_row]
ls_observacion 		= adw_master.object.observacion				[al_row]
ls_proveedor			= adw_master.object.proveedor					[al_row]
ls_cod_moneda			= adw_master.object.cod_moneda				[al_row]
ls_cod_art				= adw_master.object.cod_art					[al_row]
ld_fec_vencimiento	= Date(adw_master.object.fec_vencimiento	[al_row])
ls_nro_letra			= adw_master.object.nro_letra					[al_row]
ls_centro_benef		= adw_master.object.centro_benef				[al_row]
ls_desc_centro			= adw_master.object.desc_centro				[al_row]

ldc_saldo_pagar		= Dec(adw_master.object.saldo_pagar			[al_row])
ldc_interes				= Dec(adw_master.object.interes				[al_row])
ldc_amortizacion		= Dec(adw_master.object.amortizacion		[al_row])
ldc_cuota_pagar		= Dec(adw_master.object.cuota_pagar			[al_row])


If IsNull(ldc_interes) then ldc_interes = 0
If IsNull(ldc_amortizacion) then ldc_amortizacion = 0

select count(*)
	into :ll_count
from cntas_cobrar cc,
	  cntas_cobrar_det ccd
where cc.tipo_doc			= ccd.tipo_doc
  and cc.nro_doc			= ccd.nro_doc
  and cc.cod_relacion 	= :ls_proveedor
  and cc.tipo_doc			= :ls_tipo_doc
  and cc.observacion		= :ls_observacion
  and ccd.cod_art			= :ls_cod_art;
  

if ll_count > 0 then
	select cc.nro_doc
		into :ls_nro_doc
	from cntas_cobrar cc,
		  cntas_cobrar_det ccd
	where cc.tipo_doc			= ccd.tipo_doc
	  and cc.nro_doc			= ccd.nro_doc
	  and cc.cod_relacion 	= :ls_proveedor
	  and cc.tipo_doc			= :ls_tipo_doc
	  and cc.observacion		= :ls_observacion
	  and ccd.cod_art			= :ls_cod_art;

	if ld_fec_vencimiento >= date('01/04/2018') then
		ls_flag_estado = '1'
	else
		ls_flag_estado = '4'
		
		ldc_imp_soles = 0
		ldc_imp_dolares = 0
	end if
	  
/*
	insert into cntas_cobrar(
		tipo_doc, nro_doc, cod_relacion, flag_estado,
		fecha_registro, fecha_documento, fecha_vencimiento,
		cod_moneda, tasa_cambio, cod_usr, forma_pago,
		observacion, fecha_presentacion, flag_detraccion,	
		flag_provisionado, importe_doc, saldo_sol, saldo_dol,
		flag_control_reg, flag_caja_bancos,
		saldo_pagar,
		interes,
		amortizacion,
		nro_letra) 
	values(
		:ls_tipo_doc, :ls_nro_doc, :ls_proveedor, :ls_flag_estado,
		sysdate, :ld_fec_vencimiento, :ld_fec_vencimiento,
		:ls_cod_moneda, :ldc_tasa_cambio, :gs_user, 'PCON',
		:ls_observacion, :ld_fec_vencimiento, '0',
		'D', :ldc_cuota_pagar, :ldc_imp_soles, :ldc_imp_dolares,
		'0', '0',
		:ldc_saldo_pagar,
		:ldc_interes,
		:ldc_amortizacion,
		:ls_nro_letra);
*/
	
	//Actualizo algunos cosas
	update cntas_cobrar cc
	   set 	cc.cod_relacion	 = :ls_proveedor,
				cc.fecha_vencimiento = :ld_fec_vencimiento,
				cc.flag_estado		 = :ls_flag_estado,
				cc.observacion		 = :ls_observacion,
				cc.saldo_pagar		 = :ldc_saldo_pagar,
				cc.interes			 = :ldc_interes,
				cc.amortizacion	 = :ldc_amortizacion,
				cc.importe_doc		 = :ldc_cuota_pagar,
				cc.nro_letra		 = :ls_nro_letra,
				cc.saldo_sol		 = :ldc_imp_soles,
				cc.saldo_dol		 = :ldc_imp_dolares
	where cc.tipo_doc = :ls_tipo_doc
	  and cc.nro_doc	= :ls_nro_doc;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Error, no se puede actualizar la tabla tabla cntas_cobrar. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	  
				
				
	
else
	if trim(ls_desc_centro) = 'PUNTA ARENAS I' then
		ls_Serie = '0001'
	elseif trim(ls_desc_centro) = 'PUNTA ARENAS II' then
		ls_Serie = '0002'
	elseif trim(ls_desc_centro) = 'PUNTA ARENAS III' then
		ls_Serie = '0003'
	elseif pos(ls_desc_centro, 'PARCELA') > 0 then
		ls_Serie = '0004'
	end if
	
	//Insert into num_doc_tipo
	select ultimo_numero
		into :ll_ult_nro
	from num_doc_tipo
	where tipo_doc		= :ls_tipo_doc
	  and nro_serie	= :ls_serie for update;
	
	if SQLCA.SQLCode = 100 then
		ll_ult_nro = 1
		
		insert into num_doc_tipo(
			tipo_doc, ultimo_numero, nro_serie)
		values(
			:ls_tipo_doc, :ll_ult_nro, :ls_serie);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQlErrText
			ROLLBACK;
			MEssageBox('Aviso', 'Error, no se puede insertar en tabla num_doc_tipo. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		
	end if
	
	ls_nro_doc = ls_serie + '-' + trim(string(ll_ult_nro))
	
	//Actualizo el numerador
	update num_doc_tipo
	   set ultimo_numero = :ll_ult_nro + 1
	where tipo_doc		= :ls_tipo_doc
	  and nro_serie	= :ls_serie;
	
	//Obtengo el tipo de cambio
	ldc_tasa_cambio = gnvo_app.of_get_tipo_cambio(ld_fec_vencimiento)
	
 	if ls_cod_moneda = '01' then
		ls_cod_moneda = gnvo_app.is_soles
		ldc_imp_soles = ldc_cuota_pagar 
		ldc_imp_dolares = ldc_cuota_pagar / ldc_tasa_cambio
	else
		ls_cod_moneda = gnvo_app.is_dolares
		ldc_imp_dolares = ldc_cuota_pagar 
		ldc_imp_soles = ldc_cuota_pagar * ldc_tasa_cambio
	end if
	
	if ld_fec_vencimiento > date(gnvo_app.of_fecha_actual()) then
		ls_flag_estado = '1'
	else
		ls_flag_estado = '4'
		
		ldc_imp_soles = 0
		ldc_imp_dolares = 0
	end if
	
	//Inserto la cabecera del documento por cobrar
	insert into cntas_cobrar(
		tipo_doc, nro_doc, cod_relacion, flag_estado,
		fecha_registro, fecha_documento, fecha_vencimiento,
		cod_moneda, tasa_cambio, cod_usr, forma_pago,
		observacion, fecha_presentacion, flag_detraccion,	
		flag_provisionado, importe_doc, saldo_sol, saldo_dol,
		flag_control_reg, flag_caja_bancos,
		saldo_pagar,
		interes,
		amortizacion,
		nro_letra) 
	values(
		:ls_tipo_doc, :ls_nro_doc, :ls_proveedor, :ls_flag_estado,
		sysdate, :ld_fec_vencimiento, :ld_fec_vencimiento,
		:ls_cod_moneda, :ldc_tasa_cambio, :gs_user, 'PCON',
		:ls_observacion, :ld_fec_vencimiento, '0',
		'D', :ldc_cuota_pagar, :ldc_imp_soles, :ldc_imp_dolares,
		'0', '0',
		:ldc_saldo_pagar,
		:ldc_interes,
		:ldc_amortizacion,
		:ls_nro_letra);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Error, no se puede insertar en tabla cntas_cobrar. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	//Inserto el detalle del movimiento por cobrar
	insert into cntas_cobrar_det(
		tipo_doc, 		nro_doc, 	item,			flag_estado,
		descripcion,	cod_art,		cantidad,	precio_unitario,
		centro_benef,	flag_seguro_flete)
	values(	
		:ls_tipo_doc,	:ls_nro_doc,	1,			'1',
		:ls_observacion,	:ls_cod_art, 	1,	:ldc_cuota_pagar,
		:ls_centro_benef,	'0');


	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Error, no se puede insertar en tabla cntas_cobrar_det. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

end if





adw_master.object.nro_doc [al_row] = ls_nro_doc

return true
end function

public function boolean of_procesa_centro_benef (ref u_dw_abc adw_master, long al_row);String	ls_desc_centro, ls_centro_benef, ls_mensaje


ls_desc_centro = adw_master.object.desc_centro	[al_row]

select centro_benef
	into :ls_centro_benef
from centro_beneficio 
where desc_centro = :ls_desc_centro;

if SQLCA.SQLCode = 100 then
	//En caso de no existir creo uno
	select max(trim(centro_benef))
		into :ls_centro_benef
	from centro_beneficio
	where centro_benef like '10%';
	
	if ISNull(ls_centro_benef) or trim(ls_centro_benef) = '' then
		ls_centro_benef = '1001'
	else
		ls_centro_benef = '10' + string(Integer(right(trim(ls_centro_benef), 2)) + 1, '00')
	end if
	
	//inserto el registro
	insert into centro_beneficio (
		centro_benef, desc_centro, 
		cod_usr, cod_origen, 
		flag_estado,
		flag_estructura,	flag_fondo,	flag_ventas)	
	values(
		:ls_centro_benef, :ls_desc_centro, 
		:gs_user, :gs_origen, 
		'1', 
		'0', '0', '0');
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error al insertar en tabla centro_beneficio en of_procesa_centro_benef: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

end if


adw_master.object.centro_benef [al_row] = ls_centro_benef

return true
end function

public function boolean of_procesa_cencos (ref u_dw_abc adw_master, long al_row);String	ls_desc_almacen, ls_almacen, ls_mensaje
Long 		ll_count

ls_desc_almacen = adw_master.object.desc_centro	[al_row]

ls_desc_almacen = 'ALMACEN LOTES ' + ls_desc_almacen

select almacen
	into :ls_almacen
from almacen
where desc_almacen = :ls_desc_almacen;

if SQLCA.SQLCode = 100 then
	//En caso de no existir creo uno
	select max(almacen)
		into :ls_almacen
	from almacen
	where almacen like 'ALLT%';
	
	if ISNull(ls_almacen) or trim(ls_almacen) = '' then
		ls_almacen = 'ALLT01'
	else
		ls_almacen = 'ALLT' + string(Integer(right(ls_almacen,2)) + 1, '00')
	end if
	
	//inserto el registro
	insert into almacen(
		almacen, flag_tipo_almacen, desc_almacen, cod_origen, flag_estado, flag_cntrl_lote, cod_sunat)	
	values(
		:ls_almacen, 'M', :ls_desc_almacen, :gs_origen, '1', '0', '01');
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Aviso', 'Ha ocurrido un error en of_procesa_almacen: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	commit;

end if



adw_master.object.almacen [al_row] = ls_almacen

return true
end function

on n_cst_migracion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_migracion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

