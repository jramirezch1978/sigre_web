$PBExportHeader$w_ve318_factura_popup.srw
forward
global type w_ve318_factura_popup from w_abc_mastdet_smpl
end type
type cb_grabar from commandbutton within w_ve318_factura_popup
end type
type cb_salir from commandbutton within w_ve318_factura_popup
end type
type pb_add from picturebutton within w_ve318_factura_popup
end type
type dw_formas_pago from u_dw_abc within w_ve318_factura_popup
end type
type cb_bien from commandbutton within w_ve318_factura_popup
end type
type cb_vales from commandbutton within w_ve318_factura_popup
end type
type cb_anticipos from commandbutton within w_ve318_factura_popup
end type
type cb_nv from commandbutton within w_ve318_factura_popup
end type
type cb_servicio from commandbutton within w_ve318_factura_popup
end type
type st_1 from statictext within w_ve318_factura_popup
end type
type sle_codigo from singlelineedit within w_ve318_factura_popup
end type
type cb_lectura from commandbutton within w_ve318_factura_popup
end type
end forward

global type w_ve318_factura_popup from w_abc_mastdet_smpl
integer width = 6309
integer height = 2832
string title = "[]"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
event ue_insertar_forma_pago ( )
event keydown pbm_keydown
event ue_vales_descuento ( )
event ue_anticipos ( )
event ue_notas_venta ( )
event ue_insertar_bien ( )
event ue_insertar_servicio ( )
event ue_insertar_anticipos ( )
event ue_insertar_notas_venta ( )
event ue_event_f5 ( )
event ue_lectura ( )
cb_grabar cb_grabar
cb_salir cb_salir
pb_add pb_add
dw_formas_pago dw_formas_pago
cb_bien cb_bien
cb_vales cb_vales
cb_anticipos cb_anticipos
cb_nv cb_nv
cb_servicio cb_servicio
st_1 st_1
sle_codigo sle_codigo
cb_lectura cb_lectura
end type
global w_ve318_factura_popup w_ve318_factura_popup

type variables
u_ds_base 			ids_cabecera, ids_detalle
String				is_nom_vendedor, is_flag_modif_fpago = '1'
n_cst_wait			invo_wait
n_cst_utilitario	invo_util
end variables

forward prototypes
public function integer of_set_numera ()
public function decimal of_total_doc ()
public function decimal of_pendiente_pagar ()
public subroutine of_nota_credito_debito (long al_row)
public subroutine of_retrieve (string as_nro_registro)
public function boolean of_valida_art_serv ()
public function boolean of_validar_credito ()
end prototypes

event ue_insertar_forma_pago();str_parametros lstr_param
Decimal			ldc_pendiente_pagar, ldc_total_doc
String		 	ls_tipo_doc, ls_motivo_nota

if not of_valida_art_serv() then return

if dw_master.Rowcount( ) = 0 then
	return
end if

if dw_detail.Rowcount( ) = 0 then
	MessageBox('Error', 'No hay detalle en el comprobante de pago, no puede ingresar forma de pago', StopSign!)
	return
end if

//NCC05 
ls_tipo_doc = dw_master.object.tipo_doc_cxc [1]

if ls_tipo_doc <> 'NCC' then
	if this.of_total_doc( ) < 0 then
		messagebox( "Atencion", "No se puede insertar forma de pago, El Total del documento no puede ser negativo. Por favor verifique", StopSign!)
		dw_formas_pago.setFocus( )
		return
	end if
else
	ls_motivo_nota =  dw_master.object.motivo_nota [1]
	
	if trim(ls_motivo_nota) <> 'NCC05' then
		messagebox( "Atencion", "Solo esta permitido devolver dinero con el motivo NCC05. El motivo que ha seleccionado es " + ls_motivo_nota + ". Por favor verifique", StopSign!)
		return
	end if
end if

ldc_pendiente_pagar = abs(of_pendiente_pagar())
ldc_total_doc = abs(of_total_doc())

if ldc_total_doc = 0 then
	MessageBox('Error', 'El total del comprobante debe ser mayor que cero, no puede ingresar forma de pago', StopSign!)
	return
end if

lstr_param.dw_1 = dw_formas_pago
lstr_param.dec1 = ldc_total_doc
lstr_param.dec2 = ldc_pendiente_pagar
lstr_param.dw_m = dw_master
lstr_param.dw_d = dw_detail

OpenWithParm(w_ve318_forma_pago, lstr_param)
end event

event keydown;IF Key = KeyF5! THEN
	
	this.event ue_event_f5( )
	
elseif Key = KeyF6! then
	
	this.event ue_insertar_servicio( )
	
elseif Key = KeyF7! then
	
	this.event ue_vales_descuento( )
	
elseif Key = KeyF8! then
	
	this.event ue_insertar_anticipos( )

elseif Key = KeyF9! then
	
	this.event ue_insertar_notas_venta( )

END IF


end event

event ue_vales_descuento();str_parametros 	lstr_param
Long 					ll_row, ll_find
Decimal				ldc_porc_igv, ldc_base, ldc_igv, ldc_total_doc, ldc_saldo_vale
String				ls_nom_proveedor, ls_nro_vale

//VAlido que solo se ingresen comprobantes luego de vender algo
if this.of_total_doc( ) = 0 then
	MessageBox('Error', 'No puede ingresar vales de descuento si no ha ingresado previamente alguna mercadería o servicio a vender. Por favor verifique!', StopSign!)
	return
end if

lstr_param.dw1 = "d_lista_vales_descuento_tbl"
lstr_param.titulo = "Lista de Vales de Descuento"
lstr_param.tipo = ''
lstr_param.field_ret_i[1] = 1
lstr_param.field_ret_i[2] = 4
lstr_param.field_ret_i[3] = 7


OpenWithParm( w_search, lstr_param )
lstr_param = Message.PowerObjectParm

if lstr_param.Titulo = 's' then
	
	ls_nro_vale = lstr_param.field_ret[1]
	ls_nom_proveedor 	= lstr_param.field_ret[2]
	ldc_saldo_vale 	= Dec(lstr_param.field_ret[3])
	
	//Valido que el vale de descuento ya existe o no el comprobante de Venta
	ll_find = dw_detail.Find("nro_vale_vd='" + ls_nro_vale + "'", 1, dw_detail.RowCount())
	
	if ll_find > 0 then
		MessageBox('Error', 'El Nro de Vale de descuento ' + ls_nro_vale &
								+ ' ya existe en este comprobante de Venta. Por favor verifique!', &
								StopSign!)
		return
	end if
	
	//Obtengo el total del documnto
	ldc_total_doc = this.of_total_doc( )
	
	ll_row = dw_detail.event ue_insert( )
	if ll_row > 0 then
		
		dw_detail.object.descripcion		[ll_row] = 'DESCUENTO DEL TRABAJADOR ' &
			+ trim(ls_nom_proveedor) + ', Nro VALE: ' + ls_nro_vale
			
		dw_detail.object.nro_vale_vd		[ll_row] = lstr_param.field_ret[1]
		dw_detail.object.imp_dscto			[ll_row] = ldc_saldo_vale
		dw_detail.object.cant_proyect		[ll_row] = 1
		
		//Si el importe de descuento es mayor al documento, entonces el importe de 
		//descuento será el importe del documento
		if ldc_saldo_vale > ldc_total_doc then
			ldc_saldo_vale = ldc_total_doc
		end if
		
		ldc_porc_igv = Dec(dw_detail.object.porc_igv [ll_row])
		
		ldc_base = round(ldc_saldo_vale / (1 + ldc_porc_igv/100), 2)
		
		ldc_igv = ldc_saldo_vale - ldc_base
	
		dw_detail.object.precio_unit 	[ll_row] = ldc_base * -1
		dw_detail.object.importe_igv 	[ll_row] = ldc_igv * -1
		dw_detail.object.precio_vta 	[ll_row] = ldc_saldo_vale * -1
	end if
		
end if

end event

event ue_anticipos();str_parametros 	lstr_param
Long 					ll_row, ll_find
Decimal				ldc_porc_igv, ldc_base, ldc_igv, ldc_total_doc, ldc_saldo
String				ls_nom_proveedor, ls_cliente, ls_tipo_doc, ls_nro_doc

//VAlido que solo se ingresen comprobantes luego de vender algo
if this.of_total_doc( ) = 0 then
	MessageBox('Error', 'No puede ingresar ANTICIPOS si no ha ingresado previamente alguna mercadería o servicio a vender. Por favor verifique!', StopSign!)
	return
end if

ls_cliente = dw_master.object.cliente [1]

lstr_param.dw1 = "d_lista_anticipos_tbl"
lstr_param.titulo = "Lista de Anticipos"
lstr_param.tipo = '1S2S'
lstr_param.string1 = ls_cliente
lstr_param.string2 = gnvo_app.finparam.is_cf_anticipo_sol
lstr_param.field_ret_i[1] = 1		//Tipo Doc
lstr_param.field_ret_i[2] = 2		//Nro Doc
lstr_param.field_ret_i[3] = 5		//Nombre del Cliente
lstr_param.field_ret_i[4] = 11	//Saldo del documento


OpenWithParm( w_search, lstr_param )
lstr_param = Message.PowerObjectParm
if lstr_param.Titulo = 's' then
	
	//DAtos
	ls_tipo_doc = lstr_param.field_ret[1]
	ls_nro_doc	= lstr_param.field_ret[2]
	
	//Valido si este documento de anticipo ya existe en el detalle del documento
	ll_find = dw_detail.find("tipo_doc_cxc='" + ls_tipo_doc + "' and nro_doc_cxc='" + ls_nro_doc + "'", 1, dw_detail.RowCount())
	
	if ll_find > 0 then
		MessageBox('Error', 'El documento ' + ls_tipo_doc + '/' + ls_nro_doc &
								+ ' ya ha sido añadido a este comprobante de Venta. Por favor verifique!', &
								StopSign!)
		return
	end if
	
	
	//Obtengo el total del documnto
	ldc_total_doc = this.of_total_doc( )
	
	ll_row = dw_detail.event ue_insert( )
	if ll_row > 0 then
		ls_nom_proveedor 	= lstr_param.field_ret		[3]
		ldc_saldo 			= Dec(lstr_param.field_ret	[4])
		
		dw_detail.object.descripcion		[ll_row] = 'DESCUENTO POR ANTICIPO ' &
			+ trim(ls_nom_proveedor) + ', Nro Comprobante: ' + ls_tipo_doc + '/' + ls_nro_doc
			
		dw_detail.object.tipo_doc_cxc		[ll_row] = ls_tipo_doc
		dw_detail.object.nro_doc_cxc		[ll_row] = ls_nro_doc
		dw_detail.object.cant_proyect		[ll_row] = 1
		
		//Si el importe de descuento es mayor al documento, entonces el importe de 
		//descuento será el importe del documento
		if ldc_saldo > ldc_total_doc then
			ldc_saldo = ldc_total_doc
		end if
		
		ldc_porc_igv = Dec(dw_detail.object.porc_igv [ll_row])
		
		ldc_base = round(ldc_saldo / (1 + ldc_porc_igv/100), 2)
		
		ldc_igv = ldc_saldo - ldc_base
	
		dw_detail.object.precio_unit 	[ll_row] = ldc_base * -1
		dw_detail.object.importe_igv 	[ll_row] = ldc_igv * -1
		dw_detail.object.precio_vta 	[ll_row] = ldc_saldo * -1
	end if
		
end if


end event

event ue_notas_venta();str_parametros 	lstr_param
Long 					ll_row, ll_find
Decimal				ldc_porc_igv, ldc_base, ldc_igv, ldc_total_doc, ldc_saldo, ldc_factor, &
						ldc_pendiente_pagar
String				ls_nro_registro, ls_tipo_doc, ls_nro_doc, ls_cliente, ls_nom_proveedor, &
						ls_desc_tipo_doc

//VAlido que solo se ingresen comprobantes luego de vender algo
if this.of_total_doc( ) = 0 or dw_detail.RowCount() = 0 then
	MessageBox('Error', 'No puede ingresar NOTAS DE VENTA si no ha ingresado previamente alguna mercadería o servicio a vender. Por favor verifique!', StopSign!)
	return
end if

ls_cliente = dw_master.object.cliente [1]

lstr_param.dw1 = "d_lista_notas_venta_tbl"
lstr_param.titulo = "Lista de Notas de Venta (NCC / NDC)"
lstr_param.tipo = '1S'
lstr_param.string1 = ls_cliente
lstr_param.field_ret_i[1] = 1		//Nro registro
lstr_param.field_ret_i[2] = 2		//Tipo_Doc
lstr_param.field_ret_i[3] = 3		//nro_doc
lstr_param.field_ret_i[4] = 6		//nom_proveedor
lstr_param.field_ret_i[5] = 10	//desc_tipo_doc
lstr_param.field_ret_i[6] = 11	//factor
lstr_param.field_ret_i[7] = 18	//Saldo

OpenWithParm( w_search, lstr_param )
lstr_param = Message.PowerObjectParm
if lstr_param.Titulo = 's' then
	
	//DAtos
	ls_nro_registro 	= lstr_param.field_ret[1]
	ls_tipo_doc			= lstr_param.field_ret[2]
	ls_nro_doc			= lstr_param.field_ret[3]
	ls_nom_proveedor 	= lstr_param.field_ret[4]
	ls_desc_tipo_doc	= lstr_param.field_ret[5]
	ldc_factor			= Dec(lstr_param.field_ret[6])
	ldc_saldo 			= Dec(lstr_param.field_ret[7])

	//Valido que la nota de credito no haya sido ingresada nuevamente
	ll_find = dw_formas_pago.Find("nro_registro_ref='" + ls_nro_registro + "'", 1, dw_formas_pago.RowCount())
	
	if ll_find > 0 then
		MessageBox('Error', 'La nota de CREDITO / DEBITO con nro de registro ' + ls_nro_Registro &
								+ ' ya se encuentra en el pago de este comprobante. Por favor Verifique y Corrija!!!',&
								StopSign!)
		return
	end if
	
	//Obtengo el total del documnto
	ldc_total_doc = this.of_total_doc( )
	
	if ldc_total_doc <= 0 and ls_tipo_doc = gnvo_app.finparam.is_doc_ncc then
		MessageBox('Error', 'El comprobante debe tener un monto a aplicar antes de poder ' &
							   + 'jalar una nota de Credito ', StopSign!)
		return
	end if
	
	//Obtengo el pendiente por pagar
	ldc_pendiente_pagar = this.of_pendiente_pagar( )
	
	ll_row = dw_formas_pago.event ue_insert( )
	if ll_row > 0 then
		
		dw_formas_pago.object.flag_forma_pago	[ll_row] = 'N'
		dw_formas_pago.object.tipo_ref			[ll_row] = ls_tipo_doc
		dw_formas_pago.object.nro_ref				[ll_row] = ls_nro_doc
		dw_formas_pago.object.nro_registro_ref	[ll_row] = ls_nro_registro
		dw_formas_pago.object.monto				[ll_row] = ldc_pendiente_pagar
		dw_formas_pago.object.factor				[ll_row] = 1
		
		
		//Si el importe de descuento es mayor al documento, entonces el importe de 
		//descuento será el importe del documento
		if ldc_pendiente_pagar <= ldc_saldo then
			dw_formas_pago.object.monto_pago		[ll_row] = ldc_pendiente_pagar
		else
			dw_formas_pago.object.monto_pago		[ll_row] = ldc_saldo
		end if

	end if
		
end if


end event

event ue_insertar_bien();Boolean 			lb_ret
string			ls_almacen, ls_desc_almacen, ls_sql, ls_origen, ls_moneda_cab, ls_cod_art, &
					ls_flag_afecto_igv, ls_tipo_doc, ls_flag_bolsa_plastica, ls_mensaje
Decimal			ldc_tasa_cambio, ldc_precio_vta_unidad, ldc_porc_igv, ldc_precio_vta, &
					ldc_cant_proyect, ldc_icbper
blob				lbl_imagen
Long				ll_row
Integer			li_count
str_articulo	lstr_articulo

try 
	
	if dw_formas_pago.RowCount( ) > 0 then
		MessageBox('Aviso', 'No se pueden ingresar mas detalle si ya se ha ingresado la forma de pago, ' &
								+ 'para ello elimine primero todas las formas de pago antes de insertar un nuevo detalle')
		return
	end if
	
	if dw_master.rowCount() = 0 then
		MessageBox('Error', 'No puede ingresar articulos ya que el comprobante de venta no tiene cabecera, por favor corrija', StopSign!)
		return
	end if
	
	//Obtengo datos de la cabecera
	ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
	ldc_Tasa_cambio 	= Dec(dw_master.object.tasa_cambio 	[1])
	ls_origen 			= dw_master.object.cod_origen [1]
			
	if IsNull(ls_origen) or trim(ls_origen) = '' then
		MessageBox('Error', 'La cabecera del comprobante de Venta no tiene origen, por favor corrija', StopSign!)
		return
	end if
	
	//Obtengo la cantidad proyectada
	ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
	
	if dw_detail.RowCount() = 0 then
	
		//Selecciono el almacen
		select count(*)
			into :li_count
		from 	almacen 		  al,
				almacen_user  au
		where al.almacen 		= au.almacen
		  and al.flag_estado = '1'
		  and al.cod_origen 	= :ls_origen
		  and au.cod_usr  	= :gs_user;
		
		if li_count = 1 then
			select al.almacen
				into :ls_almacen
			from 	almacen 		  al,
					almacen_user  au
			where al.almacen 		= au.almacen
			  and al.flag_estado = '1'
			  and al.cod_origen 	= :ls_origen
			  and au.cod_usr  	= :gs_user;
		else
			if gnvo_app.almacen.is_show_all_almacen = '0' then
				ls_sql = "select a.almacen as almacen, " &
						 + "       a.desc_almacen as descripcion_almacen " &
						 + " from almacen a, " &
						 + "      almacen_user au " &
						 + "where au.almacen = a.almacen " &
						 + "  and a.flag_estado = '1'" &
						 + "  and a.cod_origen = '" + ls_origen + "'" &
						 + "  and au.cod_usr   = '" + gs_user + "'"
			else
				ls_sql = "select a.almacen as almacen, " &
						 + "a.desc_almacen as descripcion_almacen " &
						 + "from almacen a " &
						 + "where a.flag_estado = '1'" 
			end if	
			
			if not gnvo_app.of_lista(ls_sql, ls_almacen, ls_desc_almacen, '1') then return
		
		end if;
		
	else
		ls_almacen = dw_detail.object.almacen [1]
	end if
	
	
	//Obtengo el articulo
	ls_tipo_doc = dw_master.object.tipo_doc_cxc [1]
	
	lstr_articulo = gnvo_app.almacen.of_get_articulo_venta( ls_almacen, ls_tipo_doc )
	if not lstr_articulo.b_Return then return
	
	ls_cod_art = lstr_articulo.cod_art
	

	//Obtengo el flag_afecto_igv
	select flag_afecto_igv
		into :ls_flag_afecto_igv
	from articulo
	where cod_art = :ls_cod_art;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No se puede obtener el flag_afecto_IGV del articulo ' + ls_cod_art &
								+ '.Mensaje de Error: ' + ls_mensaje, StopSign!)
		return
	end if
	
	//Obtengo la imagen del producto
	selectBLOB imagen 
		into :lbl_imagen 
	from articulo 
	where cod_art = :ls_cod_art;
	
	if Not ISNull(lbl_imagen) then
		if not gnvo_app.logistica.of_show_imagen(lbl_imagen) then 
			RETURN 
		end if
	end if
	
	//Pregunto si va a tener bolsa plastica o no
	if gnvo_app.of_get_parametro("VENTAS_PREGUNTAR_ICBPER", "0") = '1' THEN
		if MessageBox('Aviso', '¿Se Entregara el articulo ' + lstr_articulo.cod_art + ' ' &
									  + trim(lstr_articulo.desc_art) &
									  + ' en una bolsa plastica?. Si va a entregar varios productos en una bolsa ' &
									  + ' plastica grande, ' &
									  + ' solo marque solo el primer item de la lista y el resto le indica NO.', &
									  Information!, YesNo!, 1) = 1 then
									  
			ls_flag_bolsa_plastica = '1'
			ldc_icbper = 0.1
		else
			ls_flag_bolsa_plastica = '0'
			ldc_icbper = 0.0
		end if						
	ELSE
		ls_flag_bolsa_plastica = '0'
		ldc_icbper = 0.0
	end if
								  
	
	ll_row = dw_detail.event ue_insert()
	
	if ll_row > 0 then
		dw_detail.object.almacen				[ll_row] = ls_almacen
		dw_detail.object.cod_art				[ll_row] = lstr_articulo.cod_art
		dw_detail.object.codigo					[ll_row] = lstr_articulo.cod_art
		dw_detail.object.desc_art				[ll_row] = lstr_articulo.desc_art
		dw_detail.object.descripcion			[ll_row] = lstr_articulo.desc_art
		dw_detail.object.und						[ll_row] = lstr_articulo.und
		dw_detail.object.cod_sku				[ll_row] = lstr_articulo.cod_sku
		dw_detail.object.flag_afecto_igv		[ll_row] = ls_flag_afecto_igv
		
		dw_detail.object.flag_bolsa_plastica[ll_row] = ls_flag_bolsa_plastica
		dw_detail.object.ICBPER					[ll_row] = ldc_icbper
		
		
		
		dw_detail.object.precio_vta_unidad	[ll_row] = lstr_articulo.precio_vta_unidad
		dw_detail.object.precio_vta_mayor	[ll_row] = lstr_articulo.precio_vta_mayor
		dw_detail.object.precio_vta_min		[ll_row] = lstr_articulo.precio_vta_min
		dw_detail.object.precio_vta_oferta	[ll_row] = lstr_articulo.precio_vta_oferta
		
		dw_detail.object.cant_proyect			[ll_row] = ldc_cant_proyect
		
		//Si tiene precio de oferta, entonces tomo el precio de oferta, sino de lo contrario
		//tomo el precio unitario si la cantidad es menor a tres
		if lstr_articulo.precio_vta_oferta > 0 then
			
			ldc_precio_vta_unidad = lstr_articulo.precio_vta_oferta
			
		elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) then
			
			ldc_precio_vta_unidad = lstr_articulo.precio_vta_mayor
			
		else
			
			ldc_precio_vta_unidad = lstr_articulo.precio_vta_unidad
			
		end if
		
		//Hago la conversión correspondiente
		if ls_moneda_cab = gnvo_app.is_dolares then
			ldc_precio_vta_unidad 	= ldc_precio_vta_unidad / ldc_tasa_cambio
		end if
		
		//Obtengo el precio, quitando el IGV
		if ls_flag_afecto_igv = '1' then
			ldc_porc_igv 	= Dec(dw_detail.object.porc_igv	[ll_row])
			ldc_precio_vta = ldc_precio_vta_unidad / (1 + ldc_porc_igv / 100)
			
			dw_detail.object.precio_unit			[ll_row] = ldc_precio_vta
			dw_detail.object.importe_igv			[ll_row] = lstr_articulo.precio_vta_unidad - ldc_precio_vta 
			dw_detail.object.precio_vta			[ll_row] = lstr_articulo.precio_vta_unidad
			
		else
			
			dw_detail.object.precio_unit			[ll_row] = lstr_articulo.precio_vta_unidad
			dw_detail.object.importe_igv			[ll_row] = 0
			dw_detail.object.precio_vta			[ll_row] = lstr_articulo.precio_vta_unidad
			
		end if
		
		
		dw_detail.setColumn("almacen")
		dw_detail.setFocus()
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
end try

end event

event ue_insertar_servicio();String 	ls_moneda_cab, ls_cod_Servicio, ls_desc_servicio, ls_moneda, ls_tarifa, &
			ls_sql, ls_flag_afecto_igv
Decimal	ldc_tasa_cambio, ldc_tarifa, ldc_porc_igv, ldc_precio_vta
Boolean	lb_ret
Long		ll_row

if dw_formas_pago.RowCount( ) > 0 then
	MessageBox('Aviso', 'No se pueden ingresar mas detalle si ya se ha ingresado la forma de pago, ' &
							+ 'para ello elimine primero todas las formas de pago antes de insertar un nuevo detalle')
	return
end if

if dw_master.rowCount() = 0 then
	MessageBox('Error', 'No puede ingresar articulos ya que el comprobante de venta no tiene cabecera, por favor corrija', StopSign!)
	return
end if

ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
ldc_Tasa_cambio 	= Dec(dw_master.object.tasa_cambio 	[1])


if IsNull(ls_moneda_cab) or trim(ls_moneda_cab) = '' then
	MessageBox('Aviso', "Debe indicar la moneda del comprobante de Venta, por favor verifique!", StopSign!)
	dw_master.SetFocus()
	dw_master.SetColumn( "cod_moneda" )
	return
end if

if IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0 then
	MessageBox('Aviso', "Debe indicar la tasa de cambio del comprobante de Venta, por favor verifique!", StopSign!)
	dw_master.SetFocus()
	dw_master.SetColumn( "tasa_cambio" )
	return
end if

//Servicios
ls_sql = "select a.cod_servicio as codigo_servicio, " &
		 + "a.desc_servicio as descripcion_Servicio, " &
		 + "a.cod_moneda as codigo_moneda, " &
		 + "a.flag_afecto_igv as afecto_igv, " &
		 + "a.tarifa as tarifa " &
		 + "from servicios_cxc a " &
		 + "where a.flag_estado = '1'"

lb_ret = gnvo_app.of_lista(ls_sql, ls_cod_servicio, ls_desc_servicio, ls_moneda, &
									ls_flag_afecto_igv, ls_tarifa, '2')

if lb_ret then
	
	ll_row = dw_detail.event ue_insert()
	if ll_row > 0 then
		dw_detail.object.cod_servicio			[ll_row] = ls_cod_servicio
		dw_detail.object.codigo					[ll_row] = ls_cod_Servicio
		dw_detail.object.descripcion			[ll_row] = ls_desc_servicio
		dw_detail.object.flag_afecto_igv		[ll_row] = ls_flag_afecto_igv
		
		dw_detail.object.precio_vta_unidad	[ll_row] = dec(ls_tarifa)
		dw_detail.object.cant_proyect			[ll_row] = 1
		
		
		//Convierto la tarifa a la moneda indicada
		if ls_moneda_cab = ls_moneda then
			ldc_tarifa = dec(ls_tarifa)
		elseif ls_moneda_cab = gnvo_app.is_soles then
			ldc_tarifa = dec(ls_tarifa) * ldc_tasa_cambio
		else
			ldc_tarifa = dec(ls_tarifa) / ldc_tasa_cambio
		end if
			
		//Obtengo el precio, quitando el IGV
		if ls_flag_afecto_igv = '1' then
			ldc_porc_igv 	= Dec(dw_detail.object.porc_igv	[ll_row])
			ldc_precio_vta = ldc_tarifa / (1 + ldc_porc_igv / 100)
		else
			ldc_porc_igv 	= 0.0
			ldc_precio_vta = ldc_tarifa 
		end if
	
		dw_detail.object.precio_unit			[ll_row] = ldc_precio_vta
		dw_detail.object.importe_igv			[ll_row] = ldc_tarifa - ldc_precio_vta 
		dw_detail.object.precio_vta			[ll_row] = ldc_tarifa
	end if	
end if


end event

event ue_insertar_anticipos();String ls_cliente

if dw_formas_pago.RowCount( ) > 0 then
	MessageBox('Aviso', 'No se pueden ingresar mas ANTICIPOS si ya se ha ingresado la forma de pago, ' &
							+ 'para ello elimine primero todas las formas de pago antes ' &
							+ 'de insertar un NUEVO anticipo', StopSign!)
	return
end if

if dw_master.RowCount( ) = 0 then
	MessageBox('Aviso', 'Debe ingresar una cabecera del comprobante de pago. Por favor verifique!', StopSign!)
	return
end if

ls_cliente = dw_master.object.cliente [1]

if ls_cliente = gnvo_app.finparam.is_cliente_gen then
	MessageBox('Aviso', 'No está permitido el CLIENTE GENERICO para jalar ANTICIPOS. Por favor registre el comprobante de pago con los datos del cliente!', StopSign!)
	return
end if


this.event ue_anticipos()
end event

event ue_insertar_notas_venta();//if dw_formas_pago.RowCount( ) > 0 then
//	MessageBox('Aviso', 'No se pueden ingresar mas NOTAS DE VENTA (NC / ND) si ya se ha ingresado la forma de pago, ' &
//							+ 'para ello elimine primero todas las formas de pago antes ' &
//							+ 'de insertar un NUEVO anticipo', StopSign!)
//	return
//end if

if dw_master.RowCount( ) = 0 then
	MessageBox('Aviso', 'Debe ingresar una cabecera del comprobante de pago. Por favor verifique!', StopSign!)
	return
end if

if dw_detail.RowCount( ) = 0 then
	MessageBox('Aviso', 'El comprobante de pago debe tener al menos una linea de detalle. Por favor verifique!', StopSign!)
	return
end if

if round(of_pendiente_pagar(),2) <= 0 then
	MessageBox('Aviso', 'No se pueden ingresar mas NOTAS DE VENTA (NC / ND) si el documento, ' &
							+ 'ya no tiene mas pendiente por pagar. Por favor verifique! ', StopSign!)
	return
end if




this.event ue_notas_venta()
end event

event ue_event_f5();try 
	if dw_formas_pago.RowCount( ) > 0 then
		MessageBox('Aviso', 'No se pueden ingresar mas detalle si ya se ha ingresado la forma de pago, ' &
								+ 'para ello elimine primero todas las formas de pago antes de insertar un nuevo detalle')
		return
	end if
		
	if gnvo_app.of_get_parametro("PREGUNTAR_BIEN_SERVICIO", "0") = "0" then
		this.event ue_insertar_bien()
	else
		if dw_detail.event ue_insert() > 0 then
			dw_detail.setColumn('almacen')
			dw_detail.setFocus()
		end if
		
	end if
	
catch ( Exception ex )
	
	MessageBox('Error', 'Ha ocurrido una exception: ' + ex.getMessage(), StopSign!)
end try

end event

event ue_lectura();String 	ls_moneda_cab, ls_almacen, ls_codigo, ls_cod_art, ls_desc_art, ls_und, ls_cod_sku, &
			ls_flag_afecto_igv, ls_mensaje, ls_cod_art1

Decimal	ldc_tasa_cambio, ldc_precio_vta_unidad, ldc_precio_vta_mayor, ldc_precio_vta_min, &
			ldc_precio_vta_oferta, ldc_saldo_total, ldc_cant_proyect, ldc_precio_vta, &
			ldc_porc_igv, ldc_base_imponible
			
Date		ld_fec_emision
Integer	li_count
Long		ll_row
Blob		lbl_imagen
boolean	lb_existe

IF trim(sle_codigo.text) = '' THEN
	MessageBox('Aviso', "No ha especificado ningún codigo para Leer, por favor confirme " &
							+ "y luego haga click en Lectura ", StopSign!)
	
	sle_codigo.setFocus()
	
	RETURN 
END IF


//Obtengo datos de la cabecera
ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
ldc_Tasa_cambio 	= Dec(dw_master.object.tasa_cambio 	[1])

//Elijo la fecha de emision
ld_Fec_emision = date(dw_master.object.fec_movimiento	[1])

//codigo
ls_codigo = trim(sle_codigo.text) + '%'

//Limpio el codigo leido
sle_codigo.text = ''
	
select 	count(*)
	into 	:li_count
from 	vw_articulo 		a,
		articulo_almacen 	aa
where a.cod_art 			= aa.cod_art
  and (a.cod_art like :ls_codigo or a.cod_sku like :ls_codigo)
  and a.flag_estado 		= '1'
  and aa.sldo_total		> 0;
	
//Codigo de Articulo no existe
IF li_count = 0 THEN
	MessageBox('Aviso', "Codigo o SKU de Articulo ingresado [" + ls_codigo + "] no existe, " & 
		+ "esta inactivo o no tiene saldo disponible en ningun almacen. " &
		+ "Por favor verifique!", StopSign!)
	
	sle_codigo.setFocus()
	
	RETURN 
END IF

select 	a.cod_art, 
			aa.almacen,
			case
				when a.desc_clase_vehiculo is null then
					a.full_desc_art
				else
					a.full_desc_vehiculo
			end as desc_art,
			a.und, 
			a.cod_sku,
			a.flag_afecto_igv,
			NVL(a.precio_vta_unidad,0), 
			NVL(a.precio_vta_mayor,0), 
			NVL(a.precio_vta_min,0),
			NVL(a.precio_vta_oferta,0), 
			NVL(aa.sldo_total, 0)
	into 	:ls_cod_art, 
			:ls_almacen,
			:ls_desc_art, 
			:ls_und, 
			:ls_cod_sku,
			:ls_flag_afecto_igv,
			:ldc_precio_vta_unidad, 
			:ldc_precio_vta_mayor, 
			:ldc_precio_vta_min,
			:ldc_precio_vta_oferta, 
			:ldc_saldo_total
from 	vw_articulo 		a,
		articulo_almacen 	aa
where a.cod_art 			= aa.cod_art
  and (a.cod_art like :ls_codigo or a.cod_sku like :ls_codigo)
  and a.flag_estado 		= '1'
  and aa.sldo_total		> 0
  and rownum				= 1;

IF SQLCA.SQLCode < 0 THEN
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', "Ha ocurrido un error al consultar la vista VW_ARTICULO. Mensaje: " &
							 + ls_mensaje + ". Por favor verifique!", StopSign!)
	sle_codigo.setFocus()
	RETURN 
END IF
	 
// Busco el articulo si es que ya existe
lb_existe = false

if dw_detail.RowCount() > 0 then
	for ll_row = 1 to dw_detail.RowCount()
		ls_cod_art1 = dw_detail.object.cod_art [ll_row]
		
		if ls_cod_art1 = ls_cod_art then
			lb_existe = true
			exit
		end if
	next
end if

//Si el articulo no existe y tiene imagen entonces muestro la imagen
if not lb_Existe then
	
	selectBLOB imagen_blob
		into :lbl_imagen 
	from vw_articulo
	where cod_art = :ls_cod_art;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Ha ocurrido un error al consultar la vista VW_ARTICULO. Mensaje: " &
								+ ls_mensaje + ". Por favor verifique!", StopSign!)
		sle_codigo.setFocus()
		return 
	END IF
		
	if Not ISNull(lbl_imagen) then
		if not gnvo_app.logistica.of_show_imagen(lbl_imagen) then 
			sle_codigo.setFocus()
			RETURN 
		end if
	end if

end if


if not lb_Existe then
	ll_row = dw_detail.event ue_insert()
	
	if ll_row > 0 then
	
		//Si esta todo correcto lleno los datos del articulo
		dw_detail.object.cod_art					[ll_row] = ls_cod_Art
		dw_detail.object.almacen					[ll_row] = ls_almacen
		dw_detail.object.codigo						[ll_row] = ls_cod_Art
		dw_detail.object.descripcion				[ll_row] = ls_desc_art
		dw_detail.object.und							[ll_row] = ls_und
		dw_detail.object.cod_sku					[ll_row] = ls_cod_sku
		dw_detail.object.flag_afecto_igv			[ll_row] = ls_flag_afecto_igv
		dw_detail.object.precio_vta_unidad		[ll_row] = ldc_precio_vta_unidad
		dw_detail.object.precio_vta_mayor		[ll_row] = ldc_precio_vta_mayor
		dw_detail.object.precio_vta_min			[ll_row] = ldc_precio_vta_min
		dw_detail.object.precio_vta_oferta		[ll_row] = ldc_precio_vta_oferta
		
		dw_detail.object.flag_bolsa_plastica	[ll_row] = '0'
		dw_detail.object.icbper						[ll_row] = 0.00	
	
		try 
			//Obtengo la cantidad proyectada
			ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
		
			dw_detail.object.cant_proyect		[ll_row] = ldc_cant_proyect
			
			//Si la cantidad es mayor o igual que la cantidad mayorista, elijo el precio mayorista
			if Dec(dw_detail.object.precio_vta_oferta	[ll_row]) > 0 then
				
				ldc_precio_vta = Dec(dw_detail.object.precio_vta_oferta	[ll_row])
				
			elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
					and Dec(dw_detail.object.precio_vta_mayor	[ll_row]) > 0 then	
					
				ldc_precio_vta = Dec(dw_detail.object.precio_vta_mayor	[ll_row])
				
			else
				
				ldc_precio_vta = Dec(dw_detail.object.precio_vta_unidad	[ll_row])
				
			end if
			
		catch ( Exception ex )
			MessageBox('Error', 'Ha ocurrido una excepcion al obtener datos del parametro CANTIDAD_DEFAULT_1. Mensaje: ' + ex.getMessage(), StopSign!)
			return 
		end try
		
		//HAgo el cambio segun el tipo de moneda
		if ls_moneda_cab <> gnvo_app.is_soles then
			ldc_precio_vta  	= ldc_precio_vta / ldc_tasa_cambio
		end if
		
		
		//Obtengo el precio, quitando el IGV
		if ls_flag_afecto_igv = '1' then
			ldc_porc_igv = Dec(dw_detail.object.porc_igv	[ll_row])
			ldc_base_imponible = ldc_precio_vta / (1 + ldc_porc_igv / 100)
			
			dw_detail.object.precio_unit			[ll_row] = ldc_base_imponible
			dw_detail.object.importe_igv			[ll_row] = ldc_precio_vta - ldc_base_imponible 
			dw_detail.object.precio_vta			[ll_row] = ldc_precio_vta
			
		else
			
			dw_detail.object.precio_unit			[ll_row] = ldc_precio_vta
			dw_detail.object.importe_igv			[ll_row] = 0
			dw_detail.object.precio_vta			[ll_row] = ldc_precio_vta
			
		end if
	
	end if

else
	
	ldc_cant_proyect = Dec(dw_detail.object.cant_proyect		[ll_row])
	
	ldc_cant_proyect ++
	
	dw_detail.object.cant_proyect		[ll_row] = ldc_cant_proyect

end if

sle_codigo.setFocus()




	


end event

public function integer of_set_numera ();//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro, ls_tabla, ls_tipo_doc, ls_serie_doc, ls_nro_doc, ls_nro_doc_old

try 
	//Obtengo el nro de registro de Factura Simplificada
	if is_action = 'new' then
		
		ls_tabla = dw_master.object.DataWindow.Table.UpdateTable
		
		Select ult_nro 
			into :ll_ult_nro 
		from num_tablas 
		where tabla = :ls_tabla
		  and origen = :gs_origen for update;
		
		IF SQLCA.SQLCode = 100 then
			ll_ult_nro = 1
			
			Insert into num_tablas (tabla, origen, ult_nro)
				values(:ls_tabla, :gs_origen, 1);
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error ', 'Error al insertar registro en num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
				return 0
			end if
		end if
		
		//Asigna numero a cabecera
		ls_nro = TRIM(gs_origen) + trim(string(ll_ult_nro, '00000000'))
		
		dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
		
		//Incrementa contador
		Update num_tablas 
			set ult_nro = :ll_ult_nro + 1 
		 where tabla = :ls_tabla
			and origen = :gs_origen;
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al actualizar num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
			return 0
		end if
			
	else 
		ls_nro = dw_master.object.nro_registro[dw_master.getrow()] 
	end if
	
	for ll_i = 1 to dw_detail.RowCount()
		dw_detail.object.nro_registro [ll_i] = ls_nro
	next
	
	for ll_i = 1 to dw_formas_pago.RowCount()
		dw_formas_pago.object.nro_registro [ll_i] = ls_nro
	next
	
	//Ahora a numerar el comprobante de pago
	ls_tipo_doc 	= dw_master.object.tipo_doc_cxc 	[1]
	ls_serie_doc 	= dw_master.object.serie_cxc 		[1]
	ls_nro_doc_old	= dw_master.object.nro_cxc 		[1]
	
	if is_action = 'new' then
		
		Select ultimo_numero 
			into :ll_ult_nro 
		from num_doc_tipo 
		where tipo_doc 	= :ls_tipo_doc
		  and nro_serie 	= :ls_serie_doc for update;
		
		IF SQLCA.SQLCode = 100 then
			ll_ult_nro = 1
			
			Insert into num_doc_tipo (
				tipo_doc, ultimo_numero, nro_serie)
			values(
				:ls_tipo_doc, 1, :ls_serie_doc);
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al insertar registro en num_doc_tipo. Mensaje: ' + ls_mensaje, StopSign!)
				return 0
			end if
		end if
		
		//Incremento el numerador
		Update num_doc_tipo 
			set ultimo_numero = :ll_ult_nro + 1 
		 where tipo_doc 	= :ls_tipo_doc
			and nro_serie 	= :ls_serie_doc;
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al actualizar num_doc_tipo', ls_mensaje, StopSign!)
			return 0
		end if
		
		//Asigna numero a cabecera
		ls_nro_doc 		= invo_util.lpad(string(ll_ult_nro), 8, '0')
		
		//Valido el nro_doc con la versión anterior
		if gnvo_app.of_get_parametro("VALIDATE_NRO_DOC_BEFORE_SAVE", "1") = "1" then
			if not IsNull(ls_nro_doc_old) and trim(ls_nro_doc_old) <> '' then
				if ls_nro_doc <> ls_nro_doc_old then
					if MessageBox('Error', "El numero del documento obtenido es diferente al numero inicial." &
											+ "~r~nNumero Inicial: " + ls_nro_doc_old &
											+ "~r~nNumero Final: " + ls_nro_doc &
											+ "~r~nEsto se puede deber a que se ha saltado el numerador, requiere una verificación. " &
											+ "~r~nDesea continuar con la grabación?", Information!, YesNo!, 2) = 2 then 
						rollback;
						return 0
					end if
				end if
			end if	
		end if
		dw_master.object.nro_cxc	[dw_master.getrow()] = ls_nro_doc
	else
		dw_master.object.nro_cxc	[dw_master.getrow()] = ls_nro_doc
	end if
	
	return 1
	
catch ( Exception ex )
	rollback;
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMEssage(), StopSign!)
	return 0
	
finally
	/*statementBlock*/
end try


end function

public function decimal of_total_doc ();Decimal	ldc_total_doc = 0, ldc_precio_unit, ldc_cantidad, ldc_importe_igv, ldc_descuento, ldc_icbper
Long 		ll_i

for ll_i = 1 to dw_detail.RowCount( )
	ldc_precio_unit 	= dec(dw_detail.object.precio_unit 		[ll_i])
	ldc_cantidad 		= dec(dw_detail.object.cant_proyect 	[ll_i])
	ldc_importe_igv	= Dec(dw_detail.object.importe_igv 		[ll_i])
	ldc_descuento		= Dec(dw_detail.object.descuento			[ll_i])
	ldc_icbper			= Dec(dw_detail.object.icbper				[ll_i])
	
	ldc_total_doc += ldc_cantidad * (ldc_precio_unit + ldc_importe_igv - ldc_descuento) + ldc_icbper

next

return ldc_total_doc
end function

public function decimal of_pendiente_pagar ();Decimal	ldc_total_doc, ldc_monto, ldc_monto_pago, ldc_pagado = 0, ldc_return
Long 		ll_i

ldc_total_doc = of_total_doc( )

for ll_i = 1 to dw_formas_pago.RowCount()
	ldc_monto 		= Dec(dw_formas_pago.object.monto 		[ll_i])
	ldc_monto_pago = Dec(dw_formas_pago.object.monto_pago [ll_i])
	
	if ldc_monto_pago <= ldc_monto then
		ldc_pagado += ldc_monto_pago
	else
		ldc_pagado += ldc_monto
	end if
next

ldc_return = ldc_total_doc - ldc_pagado

if ldc_return < 0 then ldc_return = 0

return ldc_return
end function

public subroutine of_nota_credito_debito (long al_row);
end subroutine

public subroutine of_retrieve (string as_nro_registro);dw_master.Retrieve(as_nro_registro)
dw_detail.Retrieve(as_nro_registro)
dw_formas_pago.Retrieve(as_nro_registro)

dw_master.ii_update = 0
dw_detail.ii_update = 0
dw_formas_pago.ii_update = 0

dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_protect = 0
dw_detail.of_protect()

dw_formas_pago.ii_protect = 0
dw_formas_pago.of_protect()

end subroutine

public function boolean of_valida_art_serv ();String 	ls_cod_art, ls_servicio
Decimal	ldc_precio_unit, ldc_cant_proyect
Long 		ll_row

if dw_detail.RowCount() = 0 then return true

for ll_row = 1 to dw_detail.RowCount()
	ls_cod_art 			= dw_detail.object.cod_art 			[ll_row]
	ls_servicio 		= dw_detail.object.cod_servicio 		[ll_row]
	ldc_cant_proyect	= Dec(dw_detail.object.cant_proyect	[ll_row])
	ldc_precio_unit 	= Dec(dw_detail.object.precio_unit	[ll_row])
	
	if IsNull(ldc_cant_proyect) then 
		ldc_Cant_proyect = 0
		dw_detail.object.cant_proyect	[ll_row] = 0
	end if
	
	if IsNull(ldc_precio_unit) then 
		ldc_precio_unit = 0
		dw_detail.object.precio_unit	[ll_row] = 0
	end if
	
	
	if ldc_precio_unit * ldc_cant_proyect > 0 then
		if (IsNull(ls_cod_art) or trim(ls_cod_art) = '') and &
			(IsNull(ls_servicio) or trim(ls_servicio) = '') then
			
			MEssageBox('Error', 'Error en linea ' + string(ll_row) + '. Debe indicar un código de articulo o ' &
									+ 'de Servicio cuando el precio sea mayor que cero. Por favor corrija!', StopSign!)
			
			dw_detail.SelectRow(0, false)
			dw_detail.SelectRow(ll_row, true)
			dw_detail.SetRow(ll_row)
			
			dw_detail.SetFocus()
			dw_detail.setColumn('codigo')
			
			return false
			
		end if
	end if
	
next


return true
end function

public function boolean of_validar_credito ();Long 		ll_row, ll_count
Decimal	ldc_credito_imp, ldc_credito_aprob_org, ldc_credito_aprob, ldc_pendiente_cobrar
String	ls_cliente, ls_cod_moneda, ls_mon_cred, ls_mensaje
Date		ld_fec_emision, ld_fec_ini_vigencia, ld_fec_fin_vigencia


ldc_credito_imp = 0
for ll_row = 1 to dw_formas_pago.rowcount() 
	//Si es un credito, entonces sumo la cantidad de credito
	if dw_formas_pago.object.flag_forma_pago [ll_row] = 'C' then
		ldc_credito_imp += Dec(dw_formas_pago.object.monto_pago [ll_row])
	end if
next

//Si no hay credito entonces simplemente termina la función
if ldc_credito_imp = 0 then return true

//Obtengo los datos que necesito
ls_cliente 		= dw_master.object.cliente 				[1]
ls_cod_moneda	= dw_master.object.cod_moneda				[1]
ld_fec_emision	= Date(dw_master.object.fec_movimiento [1])

//Averiguo si tiene linea de credito vigente
select count(*)
  into :ll_count
from proveedor_linea_credito
where proveedor = :ls_cliente
  and trunc(:ld_fec_emision) between trunc(fec_ini_vigencia) and trunc(fec_fin_vigencia);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un Error al hacer el Count en la LINEA DE CREDITO, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy') &
							 + '~r~nMensaje Error : ' + ls_mensaje, StopSign!)
	return false
end if  

if ll_count = 0 then
	ROLLBACK;
	MessageBox('Error', 'No hay linea de Credito Vigente para el cliente, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy'), StopSign!)
	return false
end if

if ll_count > 1 then
	ROLLBACK;
	MessageBox('Error', 'Hay mas de UNA Linea de Credito Vigente para el cliente, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy'), StopSign!)
	return false
end if

select importe, cod_moneda, fec_ini_vigencia, fec_fin_vigencia
  into :ldc_credito_aprob_org, :ls_mon_cred, 
  		 :ld_fec_ini_vigencia, :ld_fec_fin_vigencia
from proveedor_linea_credito
where proveedor = :ls_cliente
  and trunc(:ld_fec_emision) between trunc(fec_ini_vigencia) and trunc(fec_fin_vigencia);
  
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un Error al momento de comsultar de la LINEA DE CREDITO, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy') &
							 + '~r~nMensaje Error : ' + ls_mensaje, StopSign!)
	return false
end if  

//Convierto el monto a la moneda de la factura
select usf_fl_conv_mon(:ldc_credito_aprob_org, :ls_mon_cred, :ls_cod_moneda, :ld_fec_emision)
  into :ldc_credito_aprob
from dual;
           
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al momento de convertir el importe, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy') &
							 + '~r~nMensaje Error : ' + ls_mensaje, StopSign!)
	return false
end if  

//Obtengo el total del pendiente, solo tomo el libro de ventas nada mas
select sum(case 
			     when :ls_cod_moneda = :gnvo_app.is_soles then
				     saldo_sol
				  else
					  saldo_dol
			  end)
  into :ldc_pendiente_cobrar
from vw_fin_pendiente_cobrar t
where t.cod_relacion = :ls_cliente
  and trunc(t.fecha_emision) between trunc(:ld_fec_ini_vigencia) and trunc(:ld_fec_fin_vigencia)
  and t.nro_libro = 4;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al consultar el VW_FIN_PENDIENTE_COBRAR, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy') &
							 + '~r~nMensaje Error : ' + ls_mensaje, StopSign!)
	return false
end if  

//Verifico que el credito mas lo pendiente no supere el credito
if ldc_pendiente_cobrar + ldc_credito_imp > ldc_credito_aprob then
	ROLLBACK;
	MessageBox('Error', 'El monto de la linea de credito aprobado no cubre el total del credito, por favor verifique!' &
							 + '~r~nCliente : ' + ls_cliente &
							 + '~r~nFecha Emision : ' + String(ld_fec_emision, 'dd/mm/yyyy') &
							 + '~r~nPendiente Cobrar: ' + String(ldc_pendiente_cobrar, '###,##0.00') &
							 + '~r~nImporte Comprobante: ' + String(ldc_credito_imp, '###,##0.00') &
							 + '~r~nLinea Credito: ' + String(ldc_credito_aprob, '###,##0.00'), StopSign!)
	return false
end if


return true
end function

on w_ve318_factura_popup.create
int iCurrent
call super::create
this.cb_grabar=create cb_grabar
this.cb_salir=create cb_salir
this.pb_add=create pb_add
this.dw_formas_pago=create dw_formas_pago
this.cb_bien=create cb_bien
this.cb_vales=create cb_vales
this.cb_anticipos=create cb_anticipos
this.cb_nv=create cb_nv
this.cb_servicio=create cb_servicio
this.st_1=create st_1
this.sle_codigo=create sle_codigo
this.cb_lectura=create cb_lectura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_grabar
this.Control[iCurrent+2]=this.cb_salir
this.Control[iCurrent+3]=this.pb_add
this.Control[iCurrent+4]=this.dw_formas_pago
this.Control[iCurrent+5]=this.cb_bien
this.Control[iCurrent+6]=this.cb_vales
this.Control[iCurrent+7]=this.cb_anticipos
this.Control[iCurrent+8]=this.cb_nv
this.Control[iCurrent+9]=this.cb_servicio
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_codigo
this.Control[iCurrent+12]=this.cb_lectura
end on

on w_ve318_factura_popup.destroy
call super::destroy
destroy(this.cb_grabar)
destroy(this.cb_salir)
destroy(this.pb_add)
destroy(this.dw_formas_pago)
destroy(this.cb_bien)
destroy(this.cb_vales)
destroy(this.cb_anticipos)
destroy(this.cb_nv)
destroy(this.cb_servicio)
destroy(this.st_1)
destroy(this.sle_codigo)
destroy(this.cb_lectura)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros		lstr_param
Long					ll_row, ll_i, ll_count
String				ls_serie_guia, ls_serie_doc, ls_tipo_doc, ls_vendedor, ls_nom_vendedor, &
						ls_punto_venta, ls_desc_punto_venta, ls_mensaje
dateTime				ldt_fec_movimiento
Decimal				ldc_descuento, ldc_temp
str_direccion		lstr_direccion

try 
	invo_wait = create n_cst_wait	
	
	ii_lec_mst = 0 
	is_action = ''
	
	if Not IsNull(gnvo_app.ventas.is_default_vendedor) and trim(gnvo_app.ventas.is_default_vendedor)<> '' then
		select nombre
			into :is_nom_vendedor
		from usuario
		where cod_usr = :gnvo_app.ventas.is_default_vendedor;
	else
		is_nom_vendedor = ''
	end if
	
	dw_master.ii_protect = 1
	dw_master.of_protect( )
	
	dw_detail.ii_protect = 1
	dw_detail.of_protect( )
	
	//Asigno el dataindows detalle segun la empresa
	
	if upper(gs_empresa) = 'NEGOCIOS_ANTON' or upper(gs_empresa) = '24HORAS' then
		dw_detail.DataObject = 'd_abc_factura_smpl_det_anton_tbl'
	else
		dw_detail.DataObject = 'd_abc_factura_smpl_det_tbl'
	end if
	
	dw_detail.SetTransObject(SQLCA)
	
	//Creo los datastores necesarios
	ids_cabecera = create u_ds_base
	ids_detalle = create u_ds_base
	
	ids_cabecera.DataObject = 'd_abc_proforma_cab_ff'
	ids_cabecera.SetTransObject(SQLCA)
	
	//if upper(gs_empresa) = 'CROMOPLASTIC' or upper(gs_empresa) = 'FLORES' then
		ids_detalle.DataObject = 'd_abc_proforma_det2_tbl'
	/*else
		ids_detalle.DataObject = 'd_abc_proforma_det_tbl'
	end if*/
	
	ids_detalle.SetTransObject(SQLCA)
	
	lstr_param = Message.powerObjectparm
	
	
	if not IsNull(lstr_param) and IsValid(lstr_param) then
		
		if lstr_param.string1 = '' or IsNull(lstr_param.string1) then
			
			this.Title = "[VE318] Generación de Factura - Proforma Nro: " + lstr_param.string2
			
			ids_cabecera.REtrieve( lstr_param.string2 )
			
			if ids_cabecera.Rowcount( ) = 0 then
				MessageBox('Error', "No existen datos para la proforma " + lstr_param.string2 + ", por favor verifique!", StopSign!)
				post event close( )
				return
			end if
			
			ids_detalle.Retrieve( lstr_param.string2 )
			
			//Ahora inserto la cabecera y detalle
			ll_row = dw_master.event ue_insert()
			
			if ll_row > 0 then
				//Busco la serie de la guia de remisión que tenga acceso el usuario
				select count(*)
				  into :ll_count
				  from doc_tipo_usuario
				where tipo_doc = :gnvo_app.is_doc_gr
				  and cod_usr	= :gs_user;
				
				if ll_count > 0 then
					select nro_serie
					  into :ls_serie_guia
					  from doc_tipo_usuario
					where tipo_doc = :gnvo_app.is_doc_gr
					  and cod_usr	= :gs_user;
					  
					dw_master.object.serie_guia [ll_row] = ls_serie_guia
				end if
				
				//Indico el tipo de documento
				if ids_cabecera.object.flag_factura_boleta [1] = 'B' then
					ls_tipo_doc = gnvo_app.finparam.is_doc_bvc
				elseif ids_cabecera.object.flag_factura_boleta [1] = 'F' then
					ls_tipo_doc = gnvo_app.finparam.is_doc_fac
				else
					ls_tipo_doc = 'NVC'  //NOta de venta
				end if
				
				//Obtengo la serie, con la preferencia que sean facturas electronicas
				if gnvo_app.ventas.is_emisor_electronico ='1' and ls_tipo_doc <>'NVC' then
					select count(*)
					  into :ll_count
					  from doc_tipo_usuario
					where tipo_doc = :ls_tipo_doc
					  and cod_usr	= :gs_user
					  and substr(nro_Serie, 1, 1) in ('F', 'B');
				else
					select count(*)
					  into :ll_count
					  from doc_tipo_usuario
					where tipo_doc = :ls_tipo_doc
					  and cod_usr	= :gs_user
					  and substr(nro_Serie, 1, 1) not in ('F', 'B');
				end if
				
				if SQLCA.SQlCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					rollback;
					MessageBox('Error', 'Error al consulta tabla DOC_TIPO_USUARIO. Mensaje: ' + ls_mensaje, StopSign!)
					post event closequery()
					return
				end if
				
				//Si no tiene simplemente hay un error
				if ll_count = 0 then
					//Obtengo la serie, con la preferencia que sean facturas electronicas
					if gnvo_app.ventas.is_emisor_electronico ='1' and ls_tipo_doc <>'NVC' then
						select count(*)
						  into :ll_count
						  from doc_tipo_usuario
						where cod_usr	= :gs_user
						  and substr(nro_Serie, 1, 1) in ('F', 'B');
					else
						select count(*)
						  into :ll_count
						  from doc_tipo_usuario
						where cod_usr	= :gs_user
						  and substr(nro_Serie, 1, 1) not in ('F', 'B');
					end if
					
					if SQLCA.SQlCode < 0 then
						ls_mensaje = SQLCA.SQLErrText
						rollback;
						MessageBox('Error', 'Error al consulta tabla DOC_TIPO_USUARIO. Mensaje: ' + ls_mensaje, StopSign!)
						post event closequery()
						return
					end if
					
					if ll_count = 0 then
						MessageBox('Error', 'El usuario ' + gs_user + ' no tiene asignado ninguna serie para realizar el tipo de documento ' + ls_tipo_doc, StopSign!)
						post event closequery()
						return
					end if
					
					//Obtengo el documento que tiene por defecto
					if gnvo_app.ventas.is_emisor_electronico ='1' and ls_tipo_doc <>'NVC' then
						select tipo_doc
						  into :ls_tipo_doc
						  from doc_tipo_usuario
						where cod_usr	= :gs_user
						  and substr(nro_Serie, 1, 1) in ('F', 'B')
						  and rownum 	= 1;
					else
						select tipo_doc
						  into :ls_tipo_doc
						  from doc_tipo_usuario
						where cod_usr	= :gs_user
						  and substr(nro_Serie, 1, 1) not in ('F', 'B')
						  and rownum	= 1;
					end if
					
				end if
				
				//Si tiene acceso entonces continuo
				if gnvo_app.ventas.is_emisor_electronico ='1' and ls_tipo_doc <>'NVC' then
					select trim(nro_serie)
					  into :ls_serie_doc
					  from doc_tipo_usuario
					where tipo_doc = :ls_tipo_doc
					  and cod_usr	= :gs_user
					  and substr(nro_Serie, 1, 1) in ('F', 'B');
				else
					select trim(nro_serie)
					  into :ls_serie_doc
					  from doc_tipo_usuario
					where tipo_doc = :ls_tipo_doc
					  and cod_usr	= :gs_user
					  and substr(nro_Serie, 1, 1) not in ('F', 'B');
				end if
				
				if len(trim(ls_serie_doc)) <> 4 then
					MessageBox('Error', 'La longitud de la serie debe ser de 4 digitos, por favor corrija y vuelva a intentarlo', StopSign!)
					post event closequery()
					return
				end if
				
				dw_master.object.tipo_doc_cxc [ll_row] = ls_tipo_doc
				dw_master.object.serie_cxc 	[ll_row] = ls_serie_doc
				dw_master.object.nro_cxc 		[ll_row] = gnvo_app.utilitario.of_nro_tipo_serie(ls_tipo_doc, ls_serie_doc)
				
				//Cliente Generico
				if Not IsNull(ids_cabecera.object.cliente[1]) then
					
					dw_master.object.cliente			[ll_row] = ids_cabecera.object.cliente			[1]
					dw_master.object.nom_cliente		[ll_row] = ids_cabecera.object.nom_cliente	[1]
					dw_master.object.ruc_dni			[ll_row] = ids_cabecera.object.ruc_dni			[1]
					
					dw_master.object.item_direccion	[ll_row] = ids_cabecera.object.item_direccion[1]
					dw_master.object.direccion			[ll_row] = ids_cabecera.object.direccion		[1]
					
				elseif ls_tipo_doc = gnvo_app.finparam.is_doc_bvc or ls_tipo_doc = 'NVC' then
					
					dw_master.object.cliente		[ll_row] = gnvo_app.finparam.is_cliente_gen
					dw_master.object.nom_cliente	[ll_row] = gnvo_app.finparam.is_nom_cliente_gen
					dw_master.object.ruc_dni		[ll_row] = gnvo_app.finparam.is_doc_cli_gen
					
					lstr_direccion = gnvo_app.logistica.of_get_direccion(gnvo_app.finparam.is_cliente_gen)
					
					if lstr_direccion.b_return then
						dw_master.object.item_direccion	[ll_row] = lstr_direccion.item_direccion
						dw_master.object.direccion			[ll_row] = lstr_direccion.direccion
					end if
				end if
				
				//Moneda Soles por defecto
				if Not IsNull(ids_cabecera.object.cod_moneda	[1]) then
					dw_master.object.cod_moneda	[ll_row] = ids_cabecera.object.cod_moneda	[1]
				else
					dw_master.object.cod_moneda	[ll_row] = gnvo_app.is_soles
				end if
				
				//Obtengo la fecha de movimiento
				ldt_fec_movimiento = DateTime(ids_cabecera.object.fec_registro [1])
				dw_master.object.fec_movimiento	[ll_row] = ldt_fec_movimiento
				
				//Tasa de cambio
				dw_master.object.tasa_cambio 		[ll_row] = gnvo_app.finparam.of_tasa_cambio( Date(ldt_fec_movimiento) )
				
				//Observaciones
				if Not IsNull(ids_cabecera.object.cod_moneda	[1]) then
					dw_master.object.observacion	[ll_row] = ids_cabecera.object.observacion	[1]
				else
					//"VENTA A TRAVEZ DE POS - PROFORMAS REMOTAS"
					dw_master.object.observacion	[ll_row] = gnvo_app.ventas.is_observacion
				end if
				
				
				//Obtengo datos del vendedor
				if Not IsNull(ids_cabecera.object.cod_moneda	[1]) then
					dw_master.object.vendedor		[ll_row] = ids_cabecera.object.vendedor	[1]
					dw_master.object.nom_vendedor	[ll_row] = ids_cabecera.object.nom_vendedor	[1]
				else
					ls_vendedor 		= ids_cabecera.object.vendedor 		[1]
					ls_nom_vendedor 	= ids_cabecera.object.nom_vendedor 	[1]
				
					dw_master.object.vendedor		[ll_row] = ls_vendedor
					dw_master.object.nom_vendedor	[ll_row] = ls_nom_vendedor
				end if
				
				//Obteniendo el punto de venta
				select punto_venta, desc_pto_vta
					into :ls_punto_venta, :ls_desc_punto_venta
				from puntos_venta t 
				where t.flag_estado = '1'
				  and t.cod_origen  = :gs_origen;
				
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'No existe punto de venta activo para el origen: ' &
							+ gs_origen + '. Por favor verifique y corrija!', StopSign!)
					post event closequery()
					return
				end if
				
				dw_master.object.punto_venta			[ll_row] = ls_punto_venta
				dw_master.object.desc_punto_venta	[ll_row] = ls_desc_punto_venta
			
				
				//Ahora inserto el detalle
				for ll_i = 1 to ids_detalle.RowCount( )
					ll_row = dw_detail.event ue_insert( )
					if ll_row > 0 then
						dw_detail.object.cod_art				[ll_row] = ids_detalle.object.cod_art 			[ll_i]
						dw_detail.object.cod_servicio			[ll_row] = ids_detalle.object.cod_servicio	[ll_i]
						dw_detail.object.codigo					[ll_row] = ids_detalle.object.codigo			[ll_i]
						dw_detail.object.desc_art				[ll_row] = ids_detalle.object.descripcion		[ll_i]
						dw_detail.object.descripcion			[ll_row] = ids_detalle.object.descripcion		[ll_i]
						dw_detail.object.cod_sku				[ll_row] = ids_detalle.object.cod_sku 			[ll_i]
						dw_detail.object.und						[ll_row] = ids_detalle.object.und 				[ll_i]
						dw_detail.object.almacen				[ll_row] = ids_detalle.object.almacen			[ll_i]
						dw_detail.object.cant_proyect			[ll_row] = ids_detalle.object.cantidad_und	[ll_i]
						dw_detail.object.precio_unit			[ll_row] = ids_detalle.object.precio_unit		[ll_i]
						dw_detail.object.descuento				[ll_row] = 0.00
						dw_detail.object.flag_afecto_igv		[ll_row] = ids_detalle.object.flag_afecto_igv[ll_i]
						dw_detail.object.importe_igv			[ll_row] = ids_detalle.object.importe_igv		[ll_i]
						dw_detail.object.precio_vta			[ll_row] = ids_detalle.object.precio_vta		[ll_i]
						dw_detail.object.nro_proforma			[ll_row] = ids_detalle.object.nro_proforma	[ll_i]
						dw_detail.object.item_proforma		[ll_row] = ids_detalle.object.nro_item			[ll_i]
						
						//ICBPER
						dw_detail.object.flag_bolsa_plastica[ll_row] = ids_detalle.object.flag_bolsa_plastico	[ll_i]
						dw_detail.object.icbper					[ll_row] = ids_detalle.object.icbper					[ll_i]
					end if
				next
				
				ldc_temp = round(Dec(dw_detail.object.importe_total [1]), 2)
				
				//Obtengo el dato hasta el primer decimal
				ldc_descuento = ldc_temp - truncate(ldc_temp, 1)
				
				if ldc_descuento > 0 then
					ll_row = dw_detail.event ue_insert( )
					if ll_row > 0 then
						dw_detail.object.descripcion		[ll_row] = 'DESCUENTO x REDONDEO'
						dw_detail.object.cant_proyect		[ll_row] = 1
						dw_detail.object.precio_unit		[ll_row] = 0.00
						dw_detail.object.descuento			[ll_row] = ldc_descuento
						dw_detail.object.importe_igv		[ll_row] = 0.00
						dw_detail.object.precio_vta		[ll_row] = 0.00
						dw_detail.object.flag_afecto_igv	[ll_row] = '0'
					end if
				end if
				
				is_flag_modif_fpago = '1'
				
			end if
			
		elseif lstr_param.string1 = 'edit' then
			
			this.of_retrieve(lstr_param.string2)
			
			is_action = 'edit'
			
			//Inactivo los botones
			if dw_detail.RowCount() = 0 then
				if gnvo_app.of_get_parametro("VTA_PROCESO_REGULARIZACION", "1") = "0" then
					cb_bien.enabled 		= false
					cb_servicio.enabled 	= false
					cb_vales.enabled 		= false
					cb_anticipos.enabled = false
					cb_nv.enabled			= false
					
					sle_codigo.enabled 	= false
					cb_lectura.enabled 	= false
				
				end if
			else
				cb_bien.enabled 		= false
				cb_servicio.enabled 	= false
				cb_vales.enabled 		= false
				cb_anticipos.enabled = false
				cb_nv.enabled			= false
				
				sle_codigo.enabled 	= false
				cb_lectura.enabled 	= false
				
			end if
			
			if lstr_param.string3 = '1' then
				
				pb_add.enabled 		= true
				pb_add.visible 		= true
				cb_grabar.enabled 	= true
				
				sle_codigo.enabled 	= true
				cb_lectura.enabled 	= true
				
				is_flag_modif_fpago = '1'
				
			else
				pb_add.enabled 		= false
				pb_add.visible 		= false
				cb_grabar.enabled		= false
				cb_nv.enabled			= false
				
				sle_codigo.enabled 	= false
				cb_lectura.enabled 	= false
				
				is_flag_modif_fpago = '0'
			end if
			
			this.Title = "[VE318] Generación de Nueva Factura POS"
			
			
		else
			MessageBox('Error', 'Opcion [' + lstr_param.string1 + '] aun no implementada, por favor verifique!', StopSign!)
		end if
		
	else
	
		this.Title = "[VE318] Generación de Nueva Factura POS"
	
		
		//Ahora inserto la cabecera y detalle
		ll_row = dw_master.event ue_insert()
		
		if ll_row > 0 then
			//Busco la serie de la guia, que tenga acceso
			select count(*)
			  into :ll_count
			  from doc_tipo_usuario
			where tipo_doc = :gnvo_app.is_doc_gr
			  and cod_usr	= :gs_user;
			
			if ll_count > 0 then
				select nro_serie
				  into :ls_serie_guia
				  from doc_tipo_usuario
				where tipo_doc = :gnvo_app.is_doc_gr
				  and cod_usr	= :gs_user;
				  
				dw_master.object.serie_guia [ll_row] = ls_serie_guia
			end if
	
			//Por defecto el documento es una boleta
			ls_tipo_doc = gnvo_app.finparam.is_doc_bvc
				
			//Obtengo la serie, con la preferencia que sean facturas electronicas
			if gnvo_app.ventas.is_emisor_electronico ='1' then
				select count(*)
				  into :ll_count
				  from doc_tipo_usuario
				where tipo_doc = :ls_tipo_doc
				  and cod_usr	= :gs_user
				  and substr(nro_Serie, 1, 1) in ('F', 'B');
			else
				select count(*)
				  into :ll_count
				  from doc_tipo_usuario
				where tipo_doc = :ls_tipo_doc
				  and cod_usr	= :gs_user;
			end if
			
			if SQLCA.SQlCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					rollback;
					MessageBox('Error', 'Error al consulta tabla DOC_TIPO_USUARIO. Mensaje: ' + ls_mensaje, StopSign!)
					post event closequery()
					return
				end if
			
			if ll_count = 0 then
				MessageBox('Error', 'El usuario ' + gs_user + ' no tiene asignado ninguna serie para realizar comprobantes de venta', StopSign!)
				post event closequery()
				return
			end if

			if gnvo_app.ventas.is_emisor_electronico ='1' then
				select trim(nro_serie)
				  into :ls_serie_doc
				  from doc_tipo_usuario
				where tipo_doc = :ls_tipo_doc
				  and cod_usr	= :gs_user
				  and substr(nro_Serie, 1, 1) in ('F', 'B');
			else
				select trim(nro_serie)
				  into :ls_serie_doc
				  from doc_tipo_usuario
				where tipo_doc = :ls_tipo_doc
				  and cod_usr	= :gs_user;
			end if
				
			if len(trim(ls_serie_doc)) <> 4 then
				MessageBox('Error', 'La longitud de la serie debe ser de 4 digitos, por favor corrija y vuelva a intentarlo', StopSign!)
				post event closequery()
				return
			end if
			
			dw_master.object.tipo_doc_cxc [ll_row] = ls_tipo_doc
			dw_master.object.serie_cxc 	[ll_row] = ls_serie_doc
			dw_master.object.nro_cxc 		[ll_row] = gnvo_app.utilitario.of_nro_tipo_serie(ls_tipo_doc, ls_serie_doc)
			
			//Cliente Generico
			if ls_tipo_doc = gnvo_app.finparam.is_doc_bvc then
				dw_master.object.cliente		[ll_row] = gnvo_app.finparam.is_cliente_gen
				dw_master.object.nom_cliente	[ll_row] = gnvo_app.finparam.is_nom_cliente_gen
				dw_master.object.ruc_dni		[ll_row] = gnvo_app.finparam.is_doc_cli_gen
				
				lstr_direccion = gnvo_app.logistica.of_get_direccion(gnvo_app.finparam.is_cliente_gen)
				
				if lstr_direccion.b_return then
					dw_master.object.item_direccion	[ll_row] = lstr_direccion.item_direccion
					dw_master.object.direccion			[ll_row] = lstr_direccion.direccion
				end if
				
			end if
			
			//Moneda Soles por defecto
			dw_master.object.cod_moneda	[ll_row] = gnvo_app.is_soles
			
			//Obtengo la fecha de movimiento
			ldt_fec_movimiento = gnvo_app.of_fecha_actual( )
			dw_master.object.fec_movimiento	[ll_row] = ldt_fec_movimiento
			
			//Tasa de cambio
			dw_master.object.tasa_cambio 		[ll_row] = gnvo_app.finparam.of_tasa_cambio( Date(ldt_fec_movimiento) )
			
			//Observaciones
			dw_master.object.observacion		[ll_row] = gnvo_app.ventas.is_observacion
			
			//Obteniendo el punto de venta
			select punto_venta, desc_pto_vta
				into :ls_punto_venta, :ls_desc_punto_venta
			from puntos_venta t 
			where t.flag_estado 	= '1'
			  and t.cod_origen 	= :gs_origen;
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No existe punto de venta activo para el origen: ' + gs_origen + '. Por favor verifique!', StopSign!)
				post event closequery()
				return
			end if
			
			dw_master.object.punto_venta			[ll_row] = ls_punto_venta
			dw_master.object.desc_punto_venta	[ll_row] = ls_desc_punto_venta
			
			sle_codigo.enabled 	= true
			cb_lectura.enabled 	= true
			
			is_flag_modif_fpago = '1'
			
		end if
	
		
	end if
	
	//me ubico en el control de vendedor
	if gnvo_app.of_get_parametro("FOCUS_OPEN_FACTURACION_POPUP", "1") = "1" then
		dw_master.setColumn("vendedor")
		dw_master.setFocus()
	end if
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
end try


end event

event resize;//Override
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

dw_formas_pago.width  = newwidth  - dw_formas_pago.x - 10
end event

event ue_cancelar;//Override
Str_parametros lstr_param

if MessageBox('Aviso', 'Desea salir de la ventana?', Information!, YesNo!, 2) = 2 then return

lstr_param.b_return = false

ClosewithReturn(this, lstr_param)
end event

event ue_update;//Override
Boolean 	lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_nro_proforma, ls_mensaje, ls_nro_registro, ls_cliente, &
			ls_email, ls_tipo_doc, ls_serie_cxc, ls_nro_cxc
boolean	lb_send_email
Long		ll_rpta
Str_parametros	lstr_param

try 
	if not of_valida_art_serv() then return
	
	ls_crlf = char(13) + char(10)
	dw_master.AcceptText()
	dw_detail.AcceptText()
	dw_formas_pago.AcceptText()
	
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN RETURN
	
	IF ib_log THEN
		dw_master.of_create_log()
		dw_detail.of_create_log()
		dw_formas_pago.of_create_log( )
	END IF
	
	//Open(w_log)
	//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
	
	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Master", ls_msg, StopSign!)
		END IF
	END IF
	
	IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
		END IF
	END IF
	
	IF dw_formas_pago.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_formas_pago.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = "Se ha procedido al rollback"
			messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
		END IF
	END IF
	
	IF ib_log THEN
		IF lbo_ok THEN
			lbo_ok = dw_master.of_save_log()
			lbo_ok = dw_detail.of_save_log()
			lbo_ok = dw_formas_pago.of_save_log()
		END IF
	END IF
	
	IF lbo_ok THEN
		ls_nro_proforma 	= dw_detail.object.nro_proforma 	[1]
		ls_nro_registro 	= dw_master.object.nro_registro 	[1]
		ls_cliente			= dw_master.object.cliente			[1]
		ls_tipo_doc			= dw_master.object.tipo_doc_cxc	[1]
		ls_serie_cxc		= dw_master.object.serie_cxc		[1]
		ls_nro_cxc			= dw_master.object.nro_cxc			[1]
		
		//ACtualizo la proforma cerrandola
		update proforma p
			set p.flag_estado = '2'
		where p.nro_proforma = :ls_nro_proforma;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrtext
			ROLLBACK;
			MessageBox("Error", "Ha ocurrido un error al actualizar PROFORMA. Mensaje: " + ls_mensaje, StopSign!)
			return
		end if
		
		//Validando si hay saldo existente para hacer salidas
		if gnvo_app.of_Get_parametro('VTA_VALIDAR_STOCK_FACT_SIMPL', '0') = '1' then
			invo_wait.of_mensaje("Validando el Stock del ALMACEN, por favor espere ... ")
			if not gnvo_app.ventas.of_generar_vale_almacen(ls_nro_registro) then 
				ROLLBACK;
				invo_wait.of_close()
				return
			end if
			invo_wait.of_close()
		end if
		
		//Aplico los cambios
		COMMIT using SQLCA;
		
		//Los datawindows ya no tienen cambios pendientes
		dw_master.ii_update 			= 0
		dw_detail.ii_update 			= 0
		dw_formas_pago.ii_update 	= 0
		
		dw_master.il_totdel 			= 0
		dw_detail.il_totdel 			= 0
		dw_formas_pago.il_totdel 	= 0
	
		dw_master.ResetUpdate()
		dw_detail.ResetUpdate()
		dw_formas_pago.ResetUpdate()
		
		f_mensaje('Grabación de factura realizada satisfactoriamente. Presio ENTER para imprimir el ticket', '')
		
		//Imprimo el comprobante
		if trim(ls_tipo_doc) <> 'NVC' then
			invo_wait.of_mensaje("Imprimiendo Comprobante de Pago " + ls_tipo_doc + "/" &
										+ ls_serie_cxc + "-" + ls_nro_cxc + ", por favor espere ... ")
			gnvo_app.ventas.of_print_efact( ls_nro_registro ) 
		end if
		
		//Imprimo el comprobante de despacho
		if trim(ls_tipo_doc) = 'FAC' or trim(ls_tipo_doc) = 'FAC' then
			if gnvo_app.of_get_parametro( "IMPRIME_TICKET_DESPACHO", "1") = "1" then
				invo_wait.of_mensaje("Imprimiendo TICKET DE DESPACHO, por favor espere ... ")
				gnvo_app.ventas.of_print_despacho( ls_nro_registro ) 
			end if
		end if

		// Genero los asientos y documentos correspondientes
		if gnvo_app.ventas.is_generar_cxc_fact_simpl = '1' then
			invo_wait.of_mensaje("Generando Registro de Ventas y SALIDA DE ALMACEN, por favor espere ... ")
			gnvo_app.ventas.of_cxc_factura_smpl_genera(ls_nro_registro)
		end if

		// Genero el archivo XML para enviarlo al cliente
		if gnvo_app.of_get_parametro("VENTAS_GENERAR_XML_ON_SAVE", "1") = "1" and trim(ls_tipo_doc) <> ' NVC' then
			invo_wait.of_mensaje("Generando ARCHIVO DIGITAL XML para enviarlo al cliente, por favor espere ... ")
			gnvo_app.ventas.of_create_only_xml(ls_nro_registro, ls_tipo_doc)
		end if

		//Envio por email
		if gnvo_app.ventas.is_send_email_post_save = '1' and trim(ls_tipo_doc) <> 'NVC' then
			if gnvo_app.ventas.is_send_email_only_cliente = '1' then
				ls_email = gnvo_app.logistica.of_get_email(ls_cliente)
				if len(trim(ls_email)) > 0 and pos(ls_email, '@', 1) > 0 then
					lb_send_email = true
				else
					lb_send_email = false
				end if
			else
				lb_send_email = true
			end if
			
			if lb_send_email then
				if gnvo_app.of_get_parametro('ALWAYS_QUESTION_SEND_EMAIL', '1') = '1' then
					ll_rpta = MessageBox('Aviso', 'Desea Enviar por email el comprobante eletronico?', Information!, YesNo!, 2)
				else
					ll_rpta = 1
				end if
				
				if ll_rpta = 1 then
					yield()
					invo_wait.of_mensaje("Enviando el documento por email, espere por favor.....")
					yield()
					
					gnvo_app.ventas.of_send_email(ls_nro_registro, gnvo_app.is_null, gnvo_app.is_null)
					
					yield()
					invo_wait.of_close()
				end if			
			end if
		end if

		invo_wait.of_close()

		lstr_param.b_return = true
		CloseWithReturn(this, lstr_param)
		
	END IF
catch ( Exception ex)
	gnvo_app.of_catch_exception( ex, "")

finally
//	if not IsNull(invo_wait) and IsValid(invo_wait) then
//		invo_wait.of_close()
//	end if

end try


end event

event closequery;//Override
THIS.Event ue_close_pre()
Destroy	im_1

of_close_sheet()
end event

event close;call super::close;destroy ids_cabecera
destroy ids_detalle
destroy invo_wait

end event

event ue_update_pre;call super::ue_update_pre;String 	ls_tipo_doc_cxc, ls_cliente, ls_ruc_dni, ls_tipo_doc_ident, ls_serie, &
			ls_codigo, ls_flag_afecto_igv
Date 		ld_fec_registro, ld_hoy
Long		ll_row
decimal	ldc_cantidad, ldc_precio_unit, ldc_descuento, ldc_importe_igv, ldc_total_doc, ldc_total_pago

ib_update_check = False

ld_hoy = date(gnvo_app.of_fecha_Actual())

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then	return
if gnvo_app.of_row_Processing( dw_formas_pago ) <> true then	return

if dw_master.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta CABECERA", StopSign!)
	return
end if

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta DETALLE", StopSign!)
	return
end if

//if dw_formas_pago.rowcount() = 0 then 
//	if this.of_total_doc( ) > 0 and dw_detail.RowCount() = 0 then
//		messagebox( "Atencion", "No se grabara el documento, falta la forma de pago", StopSign!)
//		dw_formas_pago.setFocus( )
//		return
//	end if
//end if

//Verifico que todas las lineas tengan un importe diferente de cero
for ll_row = 1 to dw_Detail.rowCount()
	ldc_cantidad 			= Dec(dw_detail.object.cant_proyect [ll_row])
	ldc_precio_unit		= Dec(dw_detail.object.cant_proyect [ll_row])
	ldc_descuento			= Dec(dw_detail.object.descuento 	[ll_row])
	ldc_importe_igv		= Dec(dw_detail.object.importe_igv 	[ll_row])
	ls_codigo				= dw_detail.object.codigo 				[ll_row]
	ls_flag_afecto_igv	= dw_detail.object.flag_afecto_igv	[ll_row]
	
	if ls_flag_afecto_igv = '1' and ldc_importe_IGV = 0 then
		ROLLBACK;
		MessageBox('Error', 'En el detalle del comprobante de venta, existe un registro que esta afecto a IGV, pero tiene importe de IGV igual a cero, por favor corrija!', StopSign!)
		
		dw_detail.setFocus()
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(ll_row, true)
		dw_detail.SetRow(ll_row)
		dw_detail.ScrollToRow(ll_row)
		dw_detail.SetColumn('precio_unit')
		
		return 
	end if
	
	if ls_flag_afecto_igv <> '1' and ldc_importe_IGV <> 0 then
		ROLLBACK;
		MessageBox('Error', 'En el detalle del comprobante de venta, existe un registro que esta esta INAFECTO o EXONERADO del IGV, pero tiene importe de IGV diferente a cero, por favor corrija!', StopSign!)
		
		dw_detail.setFocus()
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(ll_row, true)
		dw_detail.SetRow(ll_row)
		dw_detail.ScrollToRow(ll_row)
		dw_detail.SetColumn('precio_unit')
		
		return
	end if
	
	if ldc_precio_unit = 0 then
		ROLLBACK;
		MessageBox('Error', 'En el detalle del comprobante de venta, existe un registro con precio Venta IGUAL a CERO, por favor corrija!', StopSign!)
		
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(ll_row, true)
		dw_detail.SetRow(ll_row)
		dw_detail.ScrollToRow(ll_row)
		
		return 
	end if
	
	if ldc_cantidad * (ldc_precio_unit - ldc_descuento + ldc_importe_igv) = 0 then
		ROLLBACK;
		MessageBox('Error', 'En el detalle del comprobante de venta, existe un registro con importe total IGUAL a CERO, por favor corrija!', StopSign!)
		
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(ll_row, true)
		dw_detail.SetRow(ll_row)
		dw_detail.ScrollToRow(ll_row)
		return 
	end if
	
	if ldc_precio_unit > 0 then 
		if IsNull(ls_codigo) or trim(ls_codigo) = '' then
			ROLLBACK;
			MessageBox('Error', 'En el detalle del comprobante de venta, existe un registro con Que no tiene codigo de articulo ni codigo de servicio , por favor corrija!', StopSign!)
			
			dw_detail.SelectRow(0, false)
			dw_detail.SelectRow(ll_row, true)
			dw_detail.SetRow(ll_row)
			dw_detail.ScrollToRow(ll_row)	
		end if
	end if
	
next

//Verifico que la serie sea correcta, de lo contrario le pregunto al usuario si desea continuar
ls_Serie 			= dw_master.object.serie_cxc 		[1]
ls_tipo_doc_cxc 	= dw_master.object.tipo_doc_cxc 	[1]
ls_cliente 			= dw_master.object.cliente 		[1]
ls_ruc_dni			= dw_master.object.ruc_dni 		[1]

if gnvo_app.ventas.is_emisor_electronico = '1' then
	if left(ls_serie, 1) <> 'F' and left(ls_serie, 1) <> 'B' then
		if MessageBox('Aviso', 'Usted es EMISOR ELECTRONICO, sin embargo la serie ingresada [' + ls_serie + ']' &
					+ ' no pertenece a un comprobante electronico. ¿Desea Continuar con la grabación del documento?', &
					Information!, YesNo!, 2) = 2 then return
	end if
	
	if left(ls_serie, 1) = 'F' and trim(ls_tipo_doc_cxc) = trim(gnvo_app.finparam.is_doc_bvc) then
		Messagebox('Aviso', 'La serie F esta reservada para FACTURAS ELECTRONICAS o NOTAS DE CREDITO / DEBITO. Por favor corrija!', StopSign!)
		return
	end if

	if trim(ls_tipo_doc_cxc) = trim(gnvo_app.finparam.is_doc_fac) and left(ls_serie, 1) = 'B' then
		Messagebox('Aviso', 'La serie B esta reservada para BOLETAS ELECTRONICAS o NOTAS DE CREDITO / DEBITO. Por favor corrija!', StopSign!)
		return
	end if

end if



// Verifica que codigo ingresado exista			
ld_fec_registro = Date(dw_master.object.fec_registro [1])

if ld_fec_registro > ld_hoy then
	MessageBox("Error", "La Fecha del comprobante no puede ser mayor al día de hoy, por favor verifique")
	dw_master.object.fec_registro			[1] = gnvo_app.of_fecha_Actual()
	return 
end if

//Verifico que la fecha de registro no sea mayor al tiempo de días máximo de atrazo
if gnvo_app.ventas.il_dias_atrazo_fec_vta > 0 then
	if DaysAfter(ld_fec_registro, ld_hoy) > gnvo_app.ventas.il_dias_atrazo_fec_vta then
		if left(ls_serie, 1) <> 'F' and left(ls_serie, 1) <> 'B' then
		
			MessageBox("Error", "El máximo numero de días de retrazo es de [" &
				+ string(gnvo_app.ventas.il_dias_atrazo_fec_vta) &
				+ "], sin embargo esta tratando de registrar un comprobante de ventas con mas de " &
				+ string(DaysAfter(ld_fec_registro, ld_hoy)) &
				+ " días de atrazo. Por favor verifique!", Information!)
				
			dw_master.object.fec_registro			[1] = gnvo_app.of_fecha_Actual()
			return 
		else
			if MessageBox("Error", "El máximo numero de días de retrazo es de [" &
				+ string(gnvo_app.ventas.il_dias_atrazo_fec_vta) &
				+ "], sin embargo esta tratando de registrar un comprobante de ventas con mas de " &
				+ string(DaysAfter(ld_fec_registro, ld_hoy)) &
				+ " días de atrazo. Desea continuar con la grabación?", Information!, YesNo!, 2) = 2 then
				
				dw_master.object.fec_registro			[1] = gnvo_app.of_fecha_Actual()
				return 
			end if

		end if
	end if
end if

//Si el documento es una nota de credito, entonces se puede grabar sin problemas
if round(of_pendiente_pagar(),2) > 0 &
	and (trim(ls_tipo_doc_cxc) <> gnvo_app.finparam.is_doc_ncc and &
		  trim(ls_tipo_doc_cxc) <> gnvo_app.finparam.is_doc_ndc) then
		  
	messagebox( "Atencion", "No se puede grabar el comprobante de pago, " &
					  		    + "hay un monto pendiente por cancelar de " &
								 + string(of_pendiente_pagar(), "###,##0.00") &
								 + ". Por favor verifique!", StopSign!)
	dw_formas_pago.setFocus( )
	return
	
end if

//El total del documento no puede ser negativo
if this.of_total_doc( ) < 0 then
	messagebox( "Atencion", "No se grabara el documento, El Total del documento no puede ser negativo. Por favor verifique", StopSign!)
	dw_formas_pago.setFocus( )
	return
end if

//Valido si la linea de credito tiene para seguirle vendiendo
if not this.of_validar_credito() then return

// Valido que si ha colocado el tipo de pago CONSIGNACION ("O") el cliente no debe ser generico
for ll_row = 1 to dw_formas_pago.rowcount() 
	if dw_formas_pago.object.flag_forma_pago [ll_row] = 'O' then
		if ls_cliente = gnvo_app.finparam.is_cliente_gen then
			messagebox( "Atencion", "No esta permitido CLIENTE GENERICO cuando la forma de pago es por consignación, por favor verifique!!", StopSign!)
			return 
		end if
	end if
next

//Valido si es boleta y que supere el maximo de sunat, entonces debe tener dni
if ls_tipo_doc_cxc = gnvo_app.finparam.is_doc_bvc and &
	this.of_total_doc( ) >= gnvo_app.finparam.idc_max_monto_bvc then
	
	if ls_cliente = gnvo_app.finparam.is_cliente_gen then
		messagebox( "Atencion", "La boleta excede el monto de " &
									 + string(gnvo_app.finparam.idc_max_monto_bvc, "###,##0.00") &
									 + " y debe indicar el DNI del cliente, por favor verifique!!", StopSign!)
		return 
	end if

	if ls_ruc_dni = gnvo_app.finparam.is_doc_cli_gen then
		messagebox( "Atencion", "La boleta excede el monto de " &
									 + string(gnvo_app.finparam.idc_max_monto_bvc, "###,##0.00") &
									 + " y debe indicar el DNI del cliente, por favor verifique!!", StopSign!)
		return 
	end if

end if

//Si es una factura debe tener un cliente que no sea generico y que tenga RUC
if ls_tipo_doc_cxc = gnvo_app.finparam.is_doc_fac  then
	
	if ls_cliente = gnvo_app.finparam.is_cliente_gen then
		messagebox( "Atencion", "La FACTURA no puede tener un cliente generico, por favor verifique!!", StopSign!)
		return 
	end if

	if ls_ruc_dni = gnvo_app.finparam.is_doc_cli_gen then
		messagebox( "Atencion", "La FACTURA no puede tener un RUC o DNI GENERICO, por favor verifique!!", StopSign!)
		return 
	end if
	
	select tipo_doc_ident
		into :ls_tipo_doc_ident
	from proveedor
	where proveedor = :ls_cliente
	  and flag_estado = '1';
	
	if sqlca.SQLCode = 100 then
		messagebox( "Atencion", "El CLIENTE " + ls_cliente + " no existe o no esta activo, por favor verifique!!", StopSign!)
		return
	end if
	
	if ls_tipo_doc_ident <> '6' then
		messagebox( "Atencion", "La FACTURA solo se puede realizar a personas que tengan RUC, por favor verifique!!", StopSign!)
		return 
	end if

end if

//El total del documento no puede ser menor al total de pago
if trim(ls_tipo_doc_cxc) <> trim(gnvo_app.finparam.is_doc_ncc) and &
	trim(ls_tipo_doc_cxc) <> trim(gnvo_app.finparam.is_doc_ndc) then

	ldc_total_doc 	= round(dw_detail.object.importe_total	 		[1], 2)
	ldc_total_pago = round(dw_formas_pago.object.importe_total 	[1], 2)
	
	if ldc_total_doc <> ldc_total_pago then
		messagebox( "Atencion", "No se grabara el documento, El Total del Pago en FORMAS DE PAGO difiere del total del documento. Por favor verifique", StopSign!)
		dw_formas_pago.setFocus( )
		return
	end if

end if


//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_formas_pago.of_set_flag_replicacion()

end event

event ue_insert;//Override
Long  ll_row
String ls_tipo_doc_cxc

if is_action = 'edit' then
	MessageBox('Error', 'No esta permitido insertar items en modo de edición', StopSign!)
	return
end if

IF idw_1 = dw_formas_pago then
	
	if dw_master.RowCount() = 0 then
		MessageBox("Error", "El comprobante no tiene cabecera, por favor verifique!", StopSign!)
		RETURN
	end if
	
	ls_tipo_doc_cxc = dw_master.object.tipo_doc_cxc [1]

	if trim(ls_tipo_doc_cxc) = trim(gnvo_app.finparam.is_doc_ncc) or &
		trim(ls_tipo_doc_cxc) = trim(gnvo_app.finparam.is_doc_ndc) then
		
		messagebox( "Atencion", "No se puede ingresar forma de pago en NOTAS DE CREDITO / DEBITO. Por favor verifique!", StopSign!)
		dw_master.setFocus( )
		return
		
	end if

END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ve318_factura_popup
integer x = 0
integer y = 0
integer width = 2999
integer height = 1320
string dataobject = "d_abc_factura_smpl_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::ue_display;call super::ue_display;boolean 			lb_ret
string 			ls_codigo, ls_data, ls_sql, ls_tipo_doc_cxc, ls_cliente, ls_tipo_doc
str_cliente		lstr_cliente
str_direccion	lstr_direccion
str_parametros	lstr_param

try 
	choose case lower(as_columna)
		case "punto_venta"
			
			ls_sql = "select t.punto_venta as punto_venta, " &
					 + "t.desc_pto_vta as desc_punto_venta " &
					 + "from puntos_venta t " &
					 + "where t.flag_estado = '1'" &
					 + "  and t.cod_origen = '" + gs_origen + "'"
	
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data,  '2')
	
			if ls_codigo <> '' then
				this.object.punto_venta			[al_row] = ls_codigo
				this.object.desc_punto_venta	[al_row] = ls_data
				this.ii_update = 1
	
			end if
	
		case "serie_cxc"
			
			ls_tipo_doc = this.object.tipo_doc_cxc	[al_row]
			
			if gnvo_app.ventas.is_emisor_electronico = '1' then
				ls_sql = "select dtu.nro_serie as nro_serie, " &
						 + "dtu.cod_usr as cod_usuario " &
						 + "from doc_tipo dt, " &
						 + "     doc_tipo_usuario dtu " &
						 + "where dt.tipo_doc = dtu.tipo_doc " &
						 + "  and dt.flag_estado = '1'" &
						 + "  and dtu.cod_usr = '" + gs_user + "'" &
						 + "  and dt.tipo_doc ='" + ls_tipo_doc + "'"
			else
				ls_sql = "select dtu.nro_serie as nro_serie, " &
						 + "dtu.cod_usr as cod_usuario " &
						 + "from doc_tipo dt, " &
						 + "     doc_tipo_usuario dtu " &
						 + "where dt.tipo_doc = dtu.tipo_doc " &
						 + "  and dt.flag_estado = '1'" &
						 + "  and substr(dtu.nro_serie, 1, 1) not in ('F', 'B')" &
						 + "  and dtu.cod_usr = '" + gs_user + "'" &
						 + "  and dt.tipo_doc ='" + ls_tipo_doc + "'"
				
			end if		
	
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data,  '2')
	
			if ls_codigo <> '' then
				this.object.serie_cxc	[al_row] = ls_codigo
				
				//Obtengo el numero actual del comprobante
				this.object.nro_cxc [al_row] = gnvo_app.utilitario.of_nro_tipo_serie(ls_tipo_doc, ls_codigo)
				
				this.ii_update = 1
	
			end if
			
			
		case "cod_moneda"
	
			ls_sql = "select cod_moneda as codigo_moneda, " &
					 + "descripcion as desc_moneda " &
					 + "from moneda " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_moneda	[al_row] = ls_codigo
				this.ii_update = 1
			end if
	
		case "tipo_doc_cxc"
	
			ls_sql = "select dtu.tipo_doc as tipo_doc, " &
					 + "dtu.nro_serie as nro_serie " &
					 + "from doc_tipo_usuario dtu, " &
					 + "     doc_tipo         dt "&
					 + "where dtu.tipo_doc = dt.tipo_doc " &
					 + "  and dt.flag_estado = '1' " &
					 + "  and dtu.cod_usr = '" + gs_user + "'"
					 
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
				
				this.object.tipo_doc_cxc	[al_row] = ls_codigo
				this.object.serie_cxc		[al_row] = ls_data
				
				//Obtengo el numero actual del comprobante
				this.object.nro_cxc [al_row] = gnvo_app.utilitario.of_nro_tipo_serie(ls_codigo, ls_data)
	
	
				//Si se ha elegido la nota de credito entonces debo solicitar el motivo de la nota de credito / debito
				
				if trim(ls_codigo) = gnvo_app.finparam.is_doc_ncc or trim(ls_codigo) = gnvo_app.finparam.is_doc_ndc then
					lstr_param.dw_m 		= dw_master
					lstr_param.dw_d 		= dw_detail
					lstr_param.string1 	= ls_codigo
					lstr_param.string2		= ls_data
					
					if not gnvo_app.ventas.of_datos_nota_venta(lstr_param) then return
					
					
				end if
				
				this.ii_update = 1
			end if
	
		case "vendedor"
			
			if gnvo_app.of_get_parametro("VTA_RESTRINGIR_VENDEDOR_SUCURSAL", "1")= '1' then
			
				ls_sql = "select v.vendedor as codigo_vendedor, " &
						 + "v.nom_vendedor as nombre_vendedor " &
						 + "from vendedor v " &
						 + "where v.flag_estado = '1' " &
						 + "  and v.cod_origen = '" + gs_origen + "'"
			else
				
				ls_sql = "select v.vendedor as codigo_vendedor, " &
						 + "v.nom_vendedor as nombre_vendedor " &
						 + "from vendedor v " &
						 + "where v.flag_estado = '1' " 		
			end if
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.vendedor			[al_row] = ls_codigo
				this.object.nom_vendedor	[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "cliente"
	
			ls_tipo_doc_cxc = this.object.tipo_doc_cxc [al_row]
			
			if IsNull(ls_tipo_doc_cxc) or trim(ls_tipo_doc_cxc) = '' then
				MessageBox('Error', 'Debe definir comprobante de venta antes de elegir un cliente', StopSign!)
				return
			end if
			
			lstr_cliente = gnvo_app.finparam.of_get_cliente( ls_tipo_doc_cxc )
			
			if lstr_cliente.b_return then
				this.object.cliente 		[al_row] = lstr_cliente.proveedor
				this.object.nom_cliente [al_row] = lstr_cliente.nom_proveedor
				this.object.ruc_dni		[al_row] = lstr_cliente.ruc_dni
				
				lstr_direccion = gnvo_app.logistica.of_get_direccion( lstr_cliente.proveedor )
				
				if lstr_direccion.b_return then
					this.object.item_direccion	[al_row] = lstr_direccion.item_direccion
					this.object.direccion		[al_row] = lstr_direccion.direccion
				else
					this.object.item_direccion	[al_row] = gnvo_app.il_null
					this.object.direccion		[al_row] = gnvo_app.is_null
				end if
				
				this.ii_update				= 1
			end if
			
		CASE 'item_direccion'
		
			ls_cliente = dw_master.object.cliente [al_row]		
			IF Isnull(ls_cliente) OR Trim(ls_cliente)  = '' THEN
				Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Verifique!', StopSign!)
				Return 
			END IF
	
			// Solo Tomo la Direccion de facturacion
			ls_sql = "SELECT D.ITEM AS ITEM," &    
					 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
					 + "FROM DIRECCIONES D "&
					 + "WHERE D.CODIGO = '" + ls_cliente +"' " &
					 + "AND D.FLAG_USO in ('1', '3')"
													
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
			
			if ls_codigo <> "" then
				this.object.item_direccion	[al_row] = Long(ls_codigo)
				this.object.direccion		[al_row] = ls_data
				this.ii_update = 1
			end if
			
	
	end choose

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "ha ocurrido una excepcion")
end try




end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc
Date		ld_fec_registro

try 
	Accepttext()
	
	CHOOSE CASE dwo.name
		case "punto_venta"
			
			select t.desc_pto_vta 
				into :ls_desc
			from puntos_venta t 
			where t.punto_venta = :data
			  and t.flag_estado = '1'
			  and t.cod_origen = :gs_origen;
	
			// Verifica que articulo solo sea de reposicion		
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "Código de Punto de Venta no existe o no se encuentra activo " &
										+ "o no le corresponde al origen " + gs_origen &
										+ ", por favor verifique", StopSign!)
				this.object.punto_venta			[row] = gnvo_app.is_null
				this.object.desc_punto_venta	[row] = gnvo_app.is_null
				return 1
				
			end if
	
			this.object.desc_punto_venta		[row] = ls_desc
			
		CASE 'fec_registro'
			
			// Verifica que codigo ingresado exista			
			ld_fec_registro = date(this.object.fec_registro [row])
			
			if ld_fec_registro > date(gnvo_app.of_fecha_Actual()) then
				MessageBox("Error", "La Fecha del comprobante no puede ser mayor al día de hoy, por favor verifique")
				this.object.fec_registro			[row] = gnvo_app.of_fecha_Actual()
				return 2
			end if
			
			
		CASE 'vendedor'
			
			// Verifica que codigo ingresado exista			
			if gnvo_app.of_get_parametro("VTA_RESTRINGIR_VENDEDOR_SUCURSAL", "1")= '1' then
				Select nom_vendedor
				  into :ls_desc
				  from vendedor
				 Where vendedor 		= :data  
					and flag_estado 	= '1'
					and cod_origen 	= :gs_origen;
			else
				Select nom_vendedor
				  into :ls_desc
				  from vendedor
				 Where vendedor 		= :data  
					and flag_estado 	= '1';			
			end if
				
			// Verifica que articulo solo sea de reposicion		
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "Código de Vendedor no existe, no pertenece al origen " &
										+ gs_origen + ", o no se encuentra activo, por favor verifique!")
				this.object.vendedor			[row] = gnvo_app.is_null
				this.object.nom_vendedor	[row] = gnvo_app.is_null
				return 1
				
			end if
	
			this.object.nom_vendedor		[row] = ls_desc
	
	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Ha sucedido una excepcion")

end try

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_now

ldt_now = gnvo_app.of_fecha_actual( )

this.object.fec_registro 	[al_row] = ldt_now 
this.object.fec_movimiento [al_row] = ldt_now 
this.object.flag_estado 	[al_row] = '1'
this.object.cod_origen		[al_row] = gs_origen
this.object.cod_usr 			[al_row] = gs_user

if Not IsNull(gnvo_app.finparam.is_usr_cajero) and trim(gnvo_app.finparam.is_usr_cajero) <> '' then
	this.object.cod_usr 			[al_row] = gnvo_app.finparam.is_usr_cajero
else
	this.object.cod_usr 			[al_row] = gs_user
end if

this.object.vendedor 		[al_row] = gnvo_app.ventas.is_default_vendedor
this.object.nom_vendedor	[al_row] = is_nom_vendedor

this.SetColumn("fec_movimiento")

is_action = 'new'


end event

event dw_master::buttonclicked;call super::buttonclicked;str_parametros	lstr_param
string			ls_tipo_doc_cxc, ls_cliente, ls_sql, ls_codigo, ls_data
str_cliente 	lstr_cliente
str_direccion	lstr_direccion

if lower(dwo.name) = 'b_cliente' then
	
	ls_tipo_doc_cxc = this.object.tipo_doc_cxc [row]
	
	if IsNull(ls_tipo_doc_cxc) or trim(ls_tipo_doc_cxc) = '' then
		MessageBox('Error', 'Debe definir comprobante de venta antes de elegir un cliente', StopSign!)
		return
	end if
	
 	lstr_cliente = gnvo_app.finparam.of_get_cliente( ls_tipo_doc_cxc )
	
	if lstr_cliente.b_return then
		this.object.cliente 		[row] = lstr_cliente.proveedor
		this.object.nom_cliente [row] = lstr_cliente.nom_proveedor
		this.object.ruc_dni		[row] = lstr_cliente.ruc_dni
		
		lstr_direccion = gnvo_app.logistica.of_get_direccion( lstr_cliente.proveedor )
		
		if lstr_direccion.b_return then
			this.object.item_direccion	[row] = lstr_direccion.item_direccion
			this.object.direccion		[row] = lstr_direccion.direccion
		else
			this.object.item_direccion	[row] = gnvo_app.il_null
			this.object.direccion		[row] = gnvo_app.is_null
		end if
		
		this.ii_update = 1
	end if
	
elseif lower(dwo.name) = 'b_direccion' then
	
	ls_cliente = dw_master.object.cliente [row]		
	IF Isnull(ls_cliente) OR Trim(ls_cliente)  = '' THEN
		Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Verifique!', StopSign!)
		Return 
	END IF

	// Solo Tomo la Direccion de facturacion
	ls_sql = "SELECT D.ITEM AS ITEM," &    
			 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
			 + "FROM DIRECCIONES D "&
			 + "WHERE D.CODIGO = '" + ls_cliente +"' " &
			 + "AND D.FLAG_USO in ('1', '3')"
											
	f_lista(ls_sql, ls_codigo, ls_data, "1")
	
	if ls_codigo <> "" then
		this.object.item_direccion	[row] = Long(ls_codigo)
		this.object.direccion		[row] = ls_data
		this.ii_update = 1
	end if

end if
end event

event dw_master::keydwn;call super::keydwn;if KeyDown( KeyControl! ) And KeyDown( KeyG! ) then
	
	parent.event ue_update()
	
elseif KeyDown( KeyControl! ) And KeyDown( KeyF! ) then
	
	parent.event ue_insertar_forma_pago ()
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ve318_factura_popup
integer x = 0
integer y = 1440
integer width = 3534
integer height = 992
string dataobject = "d_abc_factura_smpl_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_detail::doubleclicked;//Override
string ls_columna, ls_string, ls_evaluate

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

event dw_detail::ue_display;call super::ue_display;string 			ls_codigo, ls_data, ls_sql, ls_almacen, ls_und, ls_origen, ls_cod_Art, &
					ls_bien_servicio, ls_moneda, ls_tarifa, ls_moneda_cab, ls_tipo_doc, &
					ls_flag_bolsa_plastica, ls_flag_afecto_igv, ls_mensaje
Decimal			ldc_base_imponible, ldc_porc_igv, ldc_tarifa, ldc_tasa_cambio, ldc_precio_vta_unidad, &
					ldc_icbper, ldc_Cant_proyect, ldc_precio_vta
date				ld_fec_emision					
str_Articulo	lstr_articulo
Blob				lbl_imagen

try 
	choose case lower(as_columna)
		case "almacen"
			ls_origen = dw_master.object.cod_origen [1]
			
			if IsNull(ls_origen) or trim(ls_origen) = '' then
				MessageBox('Error', 'La CABECERA del comprobante de Venta no tiene origen, por favor corrija', StopSign!)
				return
			end if
			
			//Valido si muestro o no todos los almacenes
			if gnvo_app.almacen.is_show_all_almacen = '0' then
				ls_sql = "select a.almacen as almacen, " &
						 + "       a.desc_almacen as descripcion_almacen " &
						 + " from almacen a, " &
						 + "      almacen_user au " &
						 + "where au.almacen = a.almacen " &
						 + "  and a.flag_estado = '1'" &
						 + "  and a.cod_origen = '" + ls_origen + "'" &
						 + "  and au.cod_usr   = '" + gs_user + "'"
			else
				ls_sql = "select a.almacen as almacen, " &
						 + "a.desc_almacen as descripcion_almacen " &
						 + "from almacen a " &
						 + "where a.flag_estado = '1'" 
			end if			
	
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
				this.object.almacen				[al_row] = ls_codigo
				
				//Debe Elegir nuevo articulo
				this.object.cod_art				[al_row] = gnvo_app.is_null
				this.object.cod_servicio		[al_row] = gnvo_app.is_null
				this.object.codigo				[al_row] = gnvo_app.is_null
				this.object.desc_art				[al_row] = gnvo_app.is_null
				this.object.descripcion			[al_row] = gnvo_app.is_null
				this.object.und					[al_row] = gnvo_app.is_null
				this.object.cod_sku				[al_row] = gnvo_app.is_null
				This.object.cant_proyect		[al_row] = 0.00
				This.object.precio_unit			[al_row] = 0.00
				
				This.object.precio_vta_unidad	[al_row] = 0.00
				This.object.precio_vta_mayor	[al_row] = 0.00
				This.object.precio_vta_min		[al_row] = 0.00
				This.object.precio_vta_oferta	[al_row] = 0.00
	
				this.ii_update = 1
			end if
			
		case "codigo"
			//Obtengo datos de la cabecera
			ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
			ldc_Tasa_cambio 	= Dec(dw_master.object.tasa_cambio 	[1])
	
			ls_bien_servicio = gnvo_app.ventas.of_choice_bien_servicio()
			
			if IsNull(ls_bien_servicio) or trim(ls_bien_servicio) = '' then
				MessageBox('Aviso', "Debe seleccionar si desea buscar bien o Servicio, por favor verifique!", StopSign!)
				this.SetColumn( "codigo" )
				return
			end if
			
			if ls_bien_Servicio = '1' then
				//Si es un bien entonces lo primero obtengo la fecha de emision
				ld_fec_emision = Date(dw_master.object.fec_movimiento [1])
				
				//Obtengo la cantidad proyectada por defecto
				ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
				
				//Obtengo el almacen
				ls_almacen 		= this.object.almacen [al_row]
				
				if IsNull(ls_almacen) or ls_almacen = '' then
					MessageBox('Aviso', "Debe seleccionar el almacén primero, por favor verifique!", StopSign!)
					this.SetColumn( "almacen" )
					return
				end if
				
				ls_tipo_doc = dw_master.object.tipo_doc_cxc [1]
				
				lstr_articulo = gnvo_app.almacen.of_get_articulo_venta( ls_almacen, ls_tipo_doc )
		
				if lstr_articulo.b_Return then
					
					ls_cod_art = lstr_articulo.cod_art
					
					//Obtengo la imagen del producto
					selectBLOB imagen 
						into :lbl_imagen 
					from articulo 
					where cod_art = :ls_cod_art;
					
					if Not ISNull(lbl_imagen) then
						if not gnvo_app.logistica.of_show_imagen(lbl_imagen) then 
							RETURN 
						end if
					end if
					
					//Pregunto si va a tener bolsa plastica o no
					if MessageBox('Aviso', '¿Se Entregara el articulo ' + lstr_articulo.cod_art + ' ' &
												  + trim(lstr_articulo.desc_art) &
												  + ' en una bolsa plastica?. Si va a entregar varios productos en una bolsa ' &
												  + ' plastica grande, ' &
												  + ' solo marque solo el primer item de la lista y el resto le indica NO.', &
												  Information!, YesNo!, 1) = 1 then
												  
						ls_flag_bolsa_plastica = '1'
						ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
					else
						ls_flag_bolsa_plastica = '0'
						ldc_icbper = 0.0
					end if	
					
					//Obtengo el flag_afecto_igv
					select flag_afecto_igv
						into :ls_flag_afecto_igv
					from articulo
					where cod_art = :ls_cod_art;
					
					if SQLCA.SQLCode < 0 then
						ls_mensaje = SQLCA.SQLErrText
						ROLLBACK;
						MessageBox('Error', 'No se puede obtener el flag_afecto_IGV del articulo ' + ls_cod_art &
												+ '.Mensaje de Error: ' + ls_mensaje, StopSign!)
						return
					end if
					
					this.object.cod_art					[al_row] = lstr_articulo.cod_art
					this.object.codigo					[al_row] = lstr_articulo.cod_art
					this.object.desc_art					[al_row] = lstr_articulo.desc_art
					this.object.descripcion				[al_row] = lstr_articulo.desc_art
					this.object.und						[al_row] = lstr_articulo.und
					this.object.cod_sku					[al_row] = lstr_articulo.cod_sku
					
					this.object.flag_bolsa_plastica	[al_row] = ls_flag_bolsa_plastica
					this.object.ICBPER					[al_row] = ldc_icbper
					this.object.flag_afecto_iv			[al_row]	= ls_flag_afecto_igv
					
					This.object.precio_vta_unidad		[al_row] = lstr_articulo.precio_vta_unidad
					This.object.precio_vta_mayor		[al_row] = lstr_articulo.precio_vta_mayor
					This.object.precio_vta_min			[al_row] = lstr_articulo.precio_vta_min
					This.object.precio_vta_oferta		[al_row] = lstr_articulo.precio_vta_oferta
					This.object.cant_proyect			[al_row] = ldc_cant_proyect
					
					//Si tiene precio de oferta, entonces tomo el precio de oferta, sino de lo contrario
					//tomo el precio unitario si la cantidad es menor a tres
					if lstr_articulo.precio_vta_oferta > 0 then
						
						ldc_precio_vta = lstr_articulo.precio_vta_oferta
						
					elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
						and Dec(This.object.precio_vta_mayor	[al_row]) > 0 then
						
						ldc_precio_vta = lstr_articulo.precio_vta_mayor
						
					else
						
						ldc_precio_vta = lstr_articulo.precio_vta_unidad
						
					end if
					
					//Hago la conversión correspondiente
					if ls_moneda_cab = gnvo_app.is_dolares then
						ldc_precio_vta 	= ldc_precio_vta / ldc_tasa_cambio
					end if
		
					//Obtengo el precio, quitando el IGV
					if ls_flag_afecto_igv = '1' then
						ldc_porc_igv	= Dec(dw_detail.object.porc_igv	[al_row])
					else
						ldc_porc_igv 	= 0.00
					end if
					
					ldc_base_imponible = ldc_precio_vta / (1 + ldc_porc_igv / 100)
					
					This.object.precio_unit			[al_row] = ldc_base_imponible
					This.object.importe_igv			[al_row] = ldc_precio_vta - ldc_base_imponible 
					This.object.precio_vta			[al_row] = ldc_precio_vta
					
					this.ii_update = 1
				end if
				
			elseif ls_bien_Servicio = '2' then
				
				//Entonces es un servicio
				if IsNull(ls_moneda_cab) or trim(ls_moneda_cab) = '' then
					MessageBox('Aviso', "Debe indicar la moneda del comprobante de Venta, por favor verifique!", StopSign!)
					dw_master.SetFocus()
					dw_master.SetColumn( "cod_moneda" )
					return
				end if
	
				if IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0 then
					MessageBox('Aviso', "Debe indicar la tasa de cambio del comprobante de Venta, por favor verifique!", StopSign!)
					dw_master.SetFocus()
					dw_master.SetColumn( "tasa_cambio" )
					return
				end if
				
				//Servicios
				ls_sql = "select a.cod_servicio as codigo_servicio, " &
						 + "a.desc_servicio as descripcion_Servicio, " &
						 + "a.cod_moneda as codigo_moneda, " &
						 + "a.tarifa as tarifa, " &
						 + "a.flag_afecto_igv as flag_afecto_igv " &
						 + "from servicios_cxc a " &
						 + "where a.flag_estado = '1'"
	
				if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_moneda, ls_tarifa, ls_flag_afecto_igv, '1') then
					
					this.object.cod_servicio		[al_row] = ls_codigo
					this.object.codigo				[al_row] = ls_codigo
					this.object.descripcion			[al_row] = ls_data
					this.object.flag_afecto_igv	[al_row] = ls_flag_afecto_igv
				
					This.object.precio_vta_unidad	[al_row] = dec(ls_tarifa)
					This.object.cant_proyect		[al_row] = 1
					
					//Convierto la tarifa a la moneda indicada
					if ls_moneda_cab = ls_moneda then
						ldc_tarifa = dec(ls_tarifa)
					elseif ls_moneda_cab = gnvo_app.is_soles then
						ldc_tarifa = dec(ls_tarifa) * ldc_tasa_cambio
					else
						ldc_tarifa = dec(ls_tarifa) / ldc_tasa_cambio
					end if
						
					//Obtengo el precio, quitando el IGV
					if ls_flag_afecto_igv = '1' then
						ldc_porc_igv 	= Dec(dw_detail.object.porc_igv	[al_row])
						ldc_base_imponible = ldc_tarifa / (1 + ldc_porc_igv / 100)
					else
						ldc_porc_igv 			= 0.0
						ldc_base_imponible 	= ldc_tarifa 
					end if
				
					This.object.precio_unit			[al_row] = ldc_base_imponible
					This.object.importe_igv			[al_row] = ldc_tarifa - ldc_base_imponible 
					This.object.precio_vta			[al_row] = ldc_tarifa
			
				
				
				end if
				
			else
				MessageBox('Error', 'Opcion aun no implementada, por favor verifique!', StopSign!)
				return
			end if
				
			
	end choose

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
end try


end event

event dw_detail::itemchanged;call super::itemchanged;String	ls_cod_Art, ls_cod_sku, ls_desc_art, ls_und, ls_almacen, ls_codigo, &
			ls_desc, ls_nro_vale_vd, ls_origen, ls_bien_servicio, ls_moneda_cab, &
			ls_mensaje, ls_moneda, ls_desc_servicio, ls_flag_afecto_igv, ls_flag_bolsa_plastica

DEcimal	ldc_precio_vta_unidad, ldc_precio_vta_mayor, ldc_precio_vta_min, &
			ldc_precio_vta_oferta, ldc_saldo_total, ldc_porc_igv, ldc_base_imponible, &
			ldc_importe_igv, ldc_importe_vd, ldc_tasa_cambio, ldc_tarifa, ldc_cant_proyect, &
			ldc_icbper, ldc_precio_vta

Date		ld_fec_emision

Integer	li_count			

Blob		lbl_imagen

try 
	this.Accepttext()

	if dw_formas_pago.RowCount() > 0 then
		MessageBox('Aviso', "Ya se ha ingresado la forma de pago, por lo que no se puede modificar el comprobante. Por favor verifique!", StopSign!)
		return 1
	end if
	
	CHOOSE CASE dwo.name
		case 'cant_proyect'
			//Obtengo datos de la cabecera
			ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
			ldc_Tasa_cambio 	= Dec(dw_master.object.tasa_cambio 	[1])
			
			//Datos del detalle
			ls_codigo 				= this.object.codigo 			[row]
			ls_flag_afecto_igv	= this.object.flag_afecto_igv	[row]
			ldc_cant_proyect		= Dec(data)
			
			
			if IsNull(ls_codigo) or trim(ls_codigo) = '' then
				MessageBox('Error', 'Debe indicar primero un codigo de articulos', StopSign!)
				this.setColumn('codigo')
				return 1
			end if
			
			try
				//Si la cantidad es mayor o igual que la cantidad mayorista, elijo el precio mayorista
				if Dec(This.object.precio_vta_oferta	[row]) > 0 then
					
					ldc_precio_vta = Dec(This.object.precio_vta_oferta	[row])
					
				elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
						and Dec(This.object.precio_vta_mayor	[row]) > 0 then	
						
					ldc_precio_vta = Dec(This.object.precio_vta_mayor	[row])
					
				else
					
					ldc_precio_vta = Dec(This.object.precio_vta_unidad	[row])
					
				end if
				
			catch(Exception ex)
				gnvo_app.of_catch_exception(ex, "Error al asignar el precio mayorista")
	
			end try
			
			//Obtengo el precio de Venta unitario según la moneda
			if ls_moneda_cab = gnvo_app.is_dolares then
				ldc_precio_vta = ldc_precio_vta / ldc_tasa_cambio
			end if
			
			//Obtengo el precio, quitando el IGV
			if ls_flag_afecto_igv = '1' then
				ldc_porc_igv 	= Dec(this.object.porc_igv	[row])
				ldc_base_imponible = ldc_precio_vta / (1 + ldc_porc_igv / 100)
				
				This.object.precio_unit			[row] = ldc_base_imponible
				This.object.importe_igv			[row] = ldc_precio_vta - ldc_base_imponible 
				This.object.precio_vta			[row] = ldc_precio_vta
				
			else
				
				This.object.precio_unit			[row] = ldc_precio_vta
				This.object.importe_igv			[row] = 0
				This.object.precio_vta			[row] = ldc_precio_vta
				
			end if
			
			
		case "almacen"
			ls_origen = dw_master.object.cod_origen [1]
			
			if IsNull(ls_origen) or trim(ls_origen) = '' then
				MessageBox('Error', 'La cabecere del comprobante de Venta no tiene origen, por favor corrija', StopSign!)
				this.object.almacen			[row] = gnvo_app.is_null
				return 1
			end if
			
			if gnvo_app.almacen.is_show_all_almacen = '0' then
				select a.desc_almacen
					into :ls_desc
				from almacen a 
				where a.almacen = :data
				  and a.flag_estado = '1'
				  and a.cod_origen = :ls_origen;
		
				IF SQLCA.SQLCode = 100 THEN
					MessageBox('Aviso', "Codigo de Almacen " + trim(data) + "no existe, no se encuentra activo "&
											+ "o no pertenece al origen " + ls_origen &
											+ ". Por favor verifique!", StopSign!)
					this.object.almacen			[row] = gnvo_app.is_null
					RETURN 1
				end if
			else
				select a.desc_almacen
					into :ls_desc
				from almacen a 
				where a.almacen = :data
				  and a.flag_estado = '1';
		
				IF SQLCA.SQLCode = 100 THEN
					MessageBox('Aviso', "Codigo de Almacen " + trim(data) + " no existe o no se encuentra activo. " &
											+ "Por favor verifique!", StopSign!)
					this.object.almacen			[row] = gnvo_app.is_null
					RETURN 1
				end if
			end if
				
			//Debe Elegir nuevo articulo
			this.object.cod_art				[row] = gnvo_app.is_null
			this.object.cod_Servicio		[row] = gnvo_app.is_null
			this.object.codigo				[row] = gnvo_app.is_null
			this.object.desc_art				[row] = gnvo_app.is_null
			this.object.descripcion			[row] = gnvo_app.is_null
			this.object.und					[row] = gnvo_app.is_null
			this.object.cod_sku				[row] = gnvo_app.is_null
			This.object.flag_afecto_igv	[row] = '1'
			This.object.precio_vta_unidad	[row] = 0.00
			This.object.precio_vta_mayor	[row] = 0.00
			This.object.precio_vta_min		[row] = 0.00
			This.object.precio_vta_oferta	[row] = 0.00
			This.object.cant_proyect		[row] = 0.00
			This.object.precio_unit			[row] = 0.00
			This.object.precio_vta			[row] = 0.00
			This.object.importe_igv			[row] = 0.00
			
			return 2
	
		case 'codigo'
			//Obtengo datos de la cabecera
			ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
			ldc_Tasa_cambio 	= Dec(dw_master.object.tasa_cambio 	[1])
	
			ls_bien_servicio = gnvo_app.ventas.of_choice_bien_servicio()
			
			if IsNull(ls_bien_servicio) or trim(ls_bien_servicio) = '' then
				MessageBox('Aviso', "Debe seleccionar si desea buscar bien o Servicio, por favor verifique!", StopSign!)
				
				This.object.cod_art				[row] = gnvo_app.is_null
				This.object.cod_servicio		[row] = gnvo_app.is_null
				This.object.codigo				[row] = gnvo_app.is_null
				This.object.descripcion			[row] = gnvo_app.is_null
				This.object.und					[row] = gnvo_app.is_null
				This.object.cod_sku				[row] = gnvo_app.is_null
				This.object.flag_afecto_igv	[row] = '1'
				This.object.precio_vta_unidad	[row] = 0.00
				This.object.precio_vta_mayor	[row] = 0.00
				This.object.precio_vta_min		[row] = 0.00
				This.object.precio_vta_oferta	[row] = 0.00
				This.object.cant_proyect		[row] = 0.00
				This.object.precio_unit			[row] = 0.00
				This.object.precio_vta			[row] = 0.00
				This.object.importe_igv			[row] = 0.00
	
				this.SetColumn( "codigo" )
				return 2
			end if
			
			if ls_bien_Servicio = '1' then
				//Selecciono Bien o Articulo
				
				//Elijo la fecha de emision
				ld_Fec_emision = date(dw_master.object.fec_movimiento[1])
			
				//Obtengo el almacen
				ls_almacen = this.object.almacen [row]
				
				if ISNull(ls_almacen) or trim(ls_almacen) = '' then
					MessageBox('Aviso', 'Debe ingresar primero el almacen. Por favor verifique!', StopSign!)
					
					This.object.cod_art				[row] = gnvo_app.is_null
					This.object.cod_servicio		[row] = gnvo_app.is_null
					This.object.codigo				[row] = gnvo_app.is_null
					This.object.descripcion			[row] = gnvo_app.is_null
					This.object.und					[row] = gnvo_app.is_null
					This.object.cod_sku				[row] = gnvo_app.is_null
					This.object.flag_afecto_igv	[row] = '1'
					This.object.precio_vta_unidad	[row] = 0.00
					This.object.precio_vta_mayor	[row] = 0.00
					This.object.precio_vta_min		[row] = 0.00
					This.object.precio_vta_oferta	[row] = 0.00
					This.object.cant_proyect		[row] = 0.00
					This.object.precio_unit			[row] = 0.00
					This.object.precio_vta			[row] = 0.00
					This.object.importe_igv			[row] = 0.00
					
					
					this.setcolumn( "almacen" )
					RETURN 1
				END IF
				
				ls_codigo = trim(data) + '%'
				
				select 	count(*)
					into 	:li_count
				from 	vw_articulo 		a,
						articulo_almacen 	aa
				where a.cod_art 			= aa.cod_art
				  and (a.cod_art like :ls_codigo or a.cod_sku like :ls_codigo)
				  and aa.almacen			= :ls_almacen
				  and a.flag_estado 		= '1'
				  and aa.sldo_total		> 0;
				
				//Codigo de Articulo no existe
				IF li_count = 0 THEN
					MessageBox('Aviso', "Codigo o SKU de Articulo ingresado [" + trim(data) + "] no existe, " & 
						+ "esta inactivo o no tiene saldo disponible para el almacen: " &
						+ ls_almacen + ". Por favor verifique!", StopSign!)
						
					This.object.cod_art				[row] = gnvo_app.is_null
					This.object.cod_servicio		[row] = gnvo_app.is_null
					This.object.codigo				[row] = gnvo_app.is_null
					This.object.descripcion			[row] = gnvo_app.is_null
					This.object.und					[row] = gnvo_app.is_null
					This.object.cod_sku				[row] = gnvo_app.is_null
					This.object.flag_afecto_igv	[row] = '1'
					This.object.precio_vta_unidad	[row] = 0.00
					This.object.precio_vta_mayor	[row] = 0.00
					This.object.precio_vta_min		[row] = 0.00
					This.object.precio_vta_oferta	[row] = 0.00
					This.object.cant_proyect		[row] = 0.00
					This.object.precio_unit			[row] = 0.00
					This.object.precio_vta			[row] = 0.00
					This.object.importe_igv			[row] = 0.00
					RETURN 1
				END IF
	
				select 	a.cod_art, 
							case
								when a.desc_clase_vehiculo is null then
									a.full_desc_art
								else
									a.full_desc_vehiculo
							end as desc_art,
							a.und, 
							a.cod_sku,
							a.flag_afecto_igv,
							NVL(a.precio_vta_unidad,0), 
							NVL(a.precio_vta_mayor,0), 
							NVL(a.precio_vta_min,0),
							NVL(a.precio_vta_oferta,0), 
							NVL(aa.sldo_total, 0)
					into 	:ls_cod_art, 
							:ls_desc_art, 
							:ls_und, 
							:ls_cod_sku,
							:ls_flag_afecto_igv,
							:ldc_precio_vta_unidad, 
							:ldc_precio_vta_mayor, 
							:ldc_precio_vta_min,
							:ldc_precio_vta_oferta, 
							:ldc_saldo_total
				from 	vw_articulo 		a,
						articulo_almacen 	aa
				where a.cod_art 			= aa.cod_art
				  and (a.cod_art like :ls_codigo or a.cod_sku like :ls_codigo)
				  and aa.almacen			= :ls_almacen
				  and a.flag_estado 		= '1'
				  and aa.sldo_total		> 0;
		
				IF SQLCA.SQLCode < 0 THEN
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Ha ocurrido un error al consultar la vista VW_ARTICULO. Mensaje: " + ls_mensaje + ". Por favor verifique!", StopSign!)
						
					This.object.cod_art				[row] = gnvo_app.is_null
					This.object.cod_servicio		[row] = gnvo_app.is_null
					This.object.codigo				[row] = gnvo_app.is_null
					This.object.descripcion			[row] = gnvo_app.is_null
					This.object.und					[row] = gnvo_app.is_null
					This.object.cod_sku				[row] = gnvo_app.is_null
					This.object.flag_afecto_igv	[row] = '1'
					This.object.precio_vta_unidad	[row] = 0.00
					This.object.precio_vta_mayor	[row] = 0.00
					This.object.precio_vta_min		[row] = 0.00
					This.object.precio_vta_oferta	[row] = 0.00
					This.object.cant_proyect		[row] = 0.00
					This.object.precio_unit			[row] = 0.00
					This.object.precio_vta			[row] = 0.00
					This.object.importe_igv			[row] = 0.00
					RETURN 1
				END IF
				 
				//Obtengo la imagen del producto
				selectBLOB imagen_blob
					into :lbl_imagen 
				from vw_articulo
				where cod_art = :ls_cod_art;
				
				IF SQLCA.SQLCode < 0 THEN
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Ha ocurrido un error al consultar la vista VW_ARTICULO. Mensaje: " + ls_mensaje + ". Por favor verifique!", StopSign!)
						
					return 1
				END IF
				
				if Not ISNull(lbl_imagen) then
					if not gnvo_app.logistica.of_show_imagen(lbl_imagen) then 
						This.object.cod_art				[row] = gnvo_app.is_null
						This.object.cod_servicio		[row] = gnvo_app.is_null
						This.object.codigo				[row] = gnvo_app.is_null
						This.object.descripcion			[row] = gnvo_app.is_null
						This.object.und					[row] = gnvo_app.is_null
						This.object.cod_sku				[row] = gnvo_app.is_null
						This.object.flag_afecto_igv	[row] = '1'
						This.object.precio_vta_unidad	[row] = 0.00
						This.object.precio_vta_mayor	[row] = 0.00
						This.object.precio_vta_min		[row] = 0.00
						This.object.precio_vta_oferta	[row] = 0.00
						This.object.cant_proyect		[row] = 0.00
						This.object.precio_unit			[row] = 0.00
						This.object.precio_vta			[row] = 0.00
						This.object.importe_igv			[row] = 0.00
						RETURN 1
					end if
				end if
				
				//Pregunto si va a tener bolsa plastica o no
				if MessageBox('Aviso', '¿Se Entregara el articulo ' + ls_cod_art + ' ' &
											  + trim(ls_desc_art) &
											  + ' en una bolsa plastica?. Si va a entregar varios productos en una bolsa ' &
											  + ' plastica grande, ' &
											  + ' solo marque solo el primer item de la lista y el resto le indica NO.', &
											  Information!, YesNo!, 1) = 1 then
											  
					ls_flag_bolsa_plastica = '1'
					ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
				else
					ls_flag_bolsa_plastica = '0'
					ldc_icbper = 0.0
				end if	
				
				//Si esta todo correcto lleno los datos del articulo
				This.object.cod_art					[row] = ls_cod_Art
				This.object.codigo					[row] = ls_cod_Art
				This.object.descripcion				[row] = ls_desc_art
				This.object.und						[row] = ls_und
				This.object.cod_sku					[row] = ls_cod_sku
				This.object.flag_afecto_igv		[row] = ls_flag_afecto_igv
				This.object.precio_vta_unidad		[row] = ldc_precio_vta_unidad
				This.object.precio_vta_mayor		[row] = ldc_precio_vta_mayor
				This.object.precio_vta_min			[row] = ldc_precio_vta_min
				This.object.precio_vta_oferta		[row] = ldc_precio_vta_oferta
				
				This.object.flag_bolsa_plastica	[row] = ls_flag_bolsa_plastica
				This.object.icbper					[row] = ldc_icbper
				
		
				try 
					//Obtengo la cantidad proyectada
					ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
	
					This.object.cant_proyect		[row] = ldc_cant_proyect
					
					//Si la cantidad es mayor o igual que la cantidad mayorista, elijo el precio mayorista
					if Dec(This.object.precio_vta_oferta	[row]) > 0 then
						
						ldc_precio_vta = Dec(This.object.precio_vta_oferta	[row])
						
					elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
							and Dec(This.object.precio_vta_mayor	[row]) > 0 then	
							
						ldc_precio_vta = Dec(This.object.precio_vta_mayor	[row])
						
					else
						
						ldc_precio_vta = Dec(This.object.precio_vta_unidad	[row])
						
					end if
					
				catch ( Exception e )
					MessageBox('Error', 'Ha ocurrido una excepcion al obtener datos del parametro CANTIDAD_DEFAULT_1. Mensaje: ' + ex.getMessage(), StopSign!)
					return 1
				end try
				
				//HAgo el cambio segun el tipo de moneda
				if ls_moneda_cab <> gnvo_app.is_soles then
					ldc_precio_vta  	= ldc_precio_vta / ldc_tasa_cambio
				end if
				
				
				//Obtengo el precio, quitando el IGV
				if ls_flag_afecto_igv = '1' then
					ldc_porc_igv = Dec(this.object.porc_igv	[row])
					ldc_base_imponible = ldc_precio_vta / (1 + ldc_porc_igv / 100)
					
					This.object.precio_unit			[row] = ldc_base_imponible
					This.object.importe_igv			[row] = ldc_precio_vta - ldc_base_imponible 
					This.object.precio_vta			[row] = ldc_precio_vta
					
				else
					
					This.object.precio_unit			[row] = ldc_precio_vta
					This.object.importe_igv			[row] = 0
					This.object.precio_vta			[row] = ldc_precio_vta
					
				end if
				
				This.setColumn('cant_proyect')
				
			elseif ls_bien_servicio = '2' then
				
				select desc_servicio, tarifa, cod_moneda, nvl(flag_afecto_igv, '0')
					into :ls_desc_servicio, :ldc_tarifa, :ls_moneda, :ls_flag_afecto_igv
				from servicios_cxc
				where cod_servicio = :data
				  and flag_estado = '1';
				
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', "El codigo ingresado [" + data + "] " &
						+ "no existe no no se encuentra activo en el maestro "&
						+ "de Servicios de Venta. Por favor verifique!", StopSign!)
						
					This.object.cod_art				[row] = gnvo_app.is_null
					This.object.cod_servicio		[row] = gnvo_app.is_null
					This.object.codigo				[row] = gnvo_app.is_null
					This.object.descripcion			[row] = gnvo_app.is_null
					This.object.und					[row] = gnvo_app.is_null
					This.object.cod_sku				[row] = gnvo_app.is_null
					This.object.flag_afecto_igv	[row] = '1'
					This.object.precio_vta_unidad	[row] = 0.00
					This.object.precio_vta_mayor	[row] = 0.00
					This.object.precio_vta_min		[row] = 0.00
					This.object.precio_vta_oferta	[row] = 0.00
					This.object.cant_proyect		[row] = 0.00
					This.object.precio_unit			[row] = 0.00
					This.object.precio_vta			[row] = 0.00
					This.object.importe_igv			[row] = 0.00
					
					return 1
					
				end if
	
				//Hago la conversión correspondiente
				if ls_moneda_cab <> ls_moneda then
					if ls_moneda_cab = gnvo_app.is_soles then
						ldc_tarifa = ldc_tarifa * ldc_tasa_Cambio
					else
						ldc_tarifa = ldc_tarifa / ldc_tasa_Cambio
					end if
				end if
		
				//Si esta todo correcto lleno los datos del articulo
				This.object.cod_servicio		[row] = data
				This.object.codigo				[row] = data
				This.object.descripcion			[row] = ls_Desc_servicio
				This.object.precio_vta_unidad	[row] = ldc_tarifa
				This.object.precio_vta_mayor	[row] = ldc_tarifa
				This.object.precio_vta_min		[row] = ldc_tarifa
				This.object.precio_vta_oferta	[row] = ldc_tarifa
		
				This.object.cant_proyect		[row] = 1.00 //ldc_saldo_total
				
				//Obtengo el precio, quitando el IGV
				if ls_flag_afecto_igv = '1' then
					ldc_porc_igv = Dec(this.object.porc_igv	[row])
					ldc_base_imponible = ldc_tarifa / (1 + ldc_porc_igv / 100)
				else
					ldc_porc_igv = 0
					ldc_base_imponible = ldc_tarifa			
				end if
				
				This.object.precio_unit			[row] = ldc_base_imponible
				This.object.importe_igv			[row] = ldc_tarifa - ldc_base_imponible 
				This.object.precio_vta			[row] = ldc_tarifa
				This.object.flag_afecto_igv	[row] = ls_flag_afecto_igv
	
				This.setColumn('cant_proyect')
	
			else
				MessageBox('Error', 'Opcion seleccionada no esta implementada, por favor verifique!', StopSign!)
				return 1
			end if
			
			return 2
	
		CASE 'flag_bolsa_plastica'
			if data = '1' then
				ld_Fec_emision = Date (dw_master.object.fec_movimiento [1])
				ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
			else
				ldc_icbper = 0.00
			end if
			
			this.object.icbper [row] = ldc_icbper
			
		
		CASE 'precio_unit'
			
			//Obtengo el numero de vale
			ls_nro_vale_vd = this.object.nro_vale_vd 		[row]
			ldc_importe_vd = Dec(this.object.imp_dscto	[row])
			
			//Si el importe de descuento es nulo, o pongo en cero
			if IsNull(ldc_importe_vd) then ldc_importe_vd = 0 
			
			if IsNull(ls_nro_vale_vd) or trim(ls_nro_vale_vd) = '' then
				//Obtengo el precio de venta
				ldc_base_imponible = Dec(data)
			else
				ldc_base_imponible = Dec(data) * -1
			end if
			
			//Obtengo el porcentaje de IGV
			if This.object.flag_afecto_igv	[row] = '1' then
				ldc_porc_igv	= Dec(this.object.porc_igv 	[row])	
			else
				ldc_porc_igv	= 0
			end if
			
			if IsNull(ls_nro_vale_vd) or trim(ls_nro_vale_vd) = '' then
				//Obtengo el precio Minimo
				ldc_precio_vta_min 		= Dec(this.object.precio_vta_min		[row])
	
				if ldc_precio_vta_min > 0 then
					//Le quito el IGV
					ldc_precio_vta_min = ldc_precio_vta_min / ( 1 + ldc_porc_igv / 100);
					
					if ldc_base_imponible < ldc_precio_vta_min and ldc_base_imponible > 0 then
						MessageBox('Aviso', 'El precio no puede ser menor al minimo de ' + string(ldc_precio_vta_min, '###,##0.00') &
							+ '. Por favor verifique!', StopSign!)
							
						ldc_base_imponible 				= ldc_precio_vta_min
						this.object.precio_unit [row] = ldc_base_imponible
					end if
				else
					
					ldc_precio_vta_min =  ldc_precio_vta_unidad * ( 1 - gnvo_app.finparam.idc_descuento_max / 100)
					
					//Le quito el IGV
					ldc_precio_vta_min = ldc_precio_vta_min / ( 1 + ldc_porc_igv / 100);
		
					if ldc_base_imponible < ldc_precio_vta_min then
						MessageBox('Aviso', 'El precio no puede ser menor al minimo de ' + string(ldc_precio_vta_min, '###,##0.00') &
							+ ', que corresponde a un maximo de ' + string(gnvo_app.finparam.idc_descuento_max, '##0.00') &
							+ '% de descuento. Por favor verifique!', StopSign!)
							
						ldc_base_imponible 					= ldc_precio_vta_min
						this.object.precio_unit [row] = ldc_base_imponible
					end if
					
				end if
			else
				//Le quito el IGV al importe de descuento
				ldc_importe_vd = ldc_importe_vd / ( 1 + ldc_porc_igv / 100);
				
				if ldc_base_imponible > ldc_importe_vd then
						MessageBox('Aviso', 'El precio unitario ingresado no puede ser mayor al importe del vale de decuento. Monto del vale: ' &
							+ string(ldc_importe_vd, '###,##0.00') + '. Por favor verifique!', StopSign!)
							
						ldc_base_imponible = ldc_importe_vd 
						this.object.precio_unit [row] = ldc_base_imponible * -1
				end if
			end if
	
			ldc_importe_igv			= ldc_base_imponible * ldc_porc_igv / 100
			
			if IsNull(ls_nro_vale_vd) or trim(ls_nro_vale_vd) = '' then
			
				this.object.importe_igv	[row] = ldc_importe_igv
				This.object.precio_vta	[row] = ldc_base_imponible + ldc_importe_igv
				
			else
				
				this.object.importe_igv	[row] = ldc_importe_igv * -1
				This.object.precio_vta	[row] = (ldc_base_imponible + ldc_importe_igv) * -1
				
			end if
			
			return 2
	
		CASE 'precio_vta'
			
			//Obtengo el numero de vale
			ls_nro_vale_vd = this.object.nro_vale_vd 	[row]
			ldc_importe_vd = Dec(this.object.imp_dscto[row])
			
			//Si el importe de descuento es nulo, o pongo en cero
			if IsNull(ldc_importe_vd) then ldc_importe_vd = 0 
			
			//Obtengo el precio de venta
			if IsNull(ls_nro_vale_vd) or trim(ls_nro_vale_vd) = '' then
				ldc_base_imponible = Dec(data)
			else
				ldc_base_imponible = Dec(data) * -1
			end if
			
			//Obtengo el porcentaje de IGV
			if This.object.flag_afecto_igv	[row] = '1' then
				ldc_porc_igv	= Dec(this.object.porc_igv 	[row])
			else
				ldc_porc_igv	= 0.00
			end if
			
			if IsNull(ls_nro_vale_vd) or trim(ls_nro_vale_vd) = '' then
				//Obtengo el precio Minimo
				ldc_precio_vta_min 		= Dec(this.object.precio_vta_min		[row])
				
				if ldc_precio_vta_min > 0 then
					
					if ldc_base_imponible < ldc_precio_vta_min and ldc_base_imponible > 0 then
						MessageBox('Aviso', 'El precio no puede ser menor al minimo de ' + string(ldc_precio_vta_min, '###,##0.00') &
							+ '. Por favor verifique!', StopSign!)
							
						ldc_base_imponible = ldc_precio_vta_min
						this.object.precio_vta [row] = ldc_base_imponible
		
					end if
				else
					
					ldc_precio_vta_min =  ldc_precio_vta_unidad * ( 1 - gnvo_app.finparam.idc_descuento_max / 100)
		
					if ldc_base_imponible < ldc_precio_vta_min and ldc_base_imponible > 0 then
						MessageBox('Aviso', 'El precio no puede ser menor al minimo de ' + string(ldc_precio_vta_min, '###,##0.00') &
							+ ', que corresponde a un maximo de ' + string(gnvo_app.finparam.idc_descuento_max, '##0.00') &
							+ '% de descuento. Por favor verifique!', StopSign!)
							
						ldc_base_imponible = ldc_precio_vta_min
						this.object.precio_vta [row] = ldc_base_imponible
					end if
					
				end if
			else
				if ldc_base_imponible > ldc_importe_vd then
						MessageBox('Aviso', 'El precio unitario ingresado no puede ser mayor al importe del vale de decuento. Monto del vale: ' &
							+ string(ldc_importe_vd, '###,##0.00') + '. Por favor verifique!', StopSign!)
							
						ldc_base_imponible = ldc_importe_vd 
						this.object.precio_vta [row] = ldc_base_imponible * -1
				end if
			end if
			
			//Le quito el IGV
			ldc_base_imponible 	= ldc_base_imponible / ( 1 + ldc_porc_igv / 100);
			ldc_importe_igv	= ldc_base_imponible * ldc_porc_igv / 100
			
			if IsNull(ls_nro_vale_vd) or trim(ls_nro_vale_vd) = '' then
				this.object.precio_unit [row] = ldc_base_imponible
				this.object.importe_igv	[row] = ldc_importe_igv
			else
				this.object.precio_unit [row] = ldc_base_imponible * -1
				this.object.importe_igv	[row] = ldc_importe_igv * -1
			end if
			
			return 2
	
	
			
	END CHOOSE

catch ( Exception ex1 )
	gnvo_app.of_catch_exception(ex1, '')
end try



end event

event dw_detail::buttonclicked;call super::buttonclicked;String 				ls_desc
str_parametros 	lstr_param

this.AcceptText()

choose case lower(dwo.name)
	case "b_delete"
		if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido eliminar items en modo de edición', StopSign!)
			return
		end if
		
		if MessageBox("Aviso", "Desea eliminar el registro " + string(row) + "?", Information!, YesNo!, 2) = 2 then return
		
		this.DeleteRow( row )
		this.ii_update = 1
		
	CASE "b_descripcion"
		if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido Modificar la descripción en modo edición', StopSign!)
			return
		end if
		
		// Para la descripcion de la Factura
		ls_desc 		= This.object.descripcion 	[row]
		
		lstr_param.string1   = 'Descripción del Bien o Servicio'
		lstr_param.string2	 = ls_desc
	
		OpenWithParm( w_descripcion_fac, lstr_param)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			This.object.descripcion 		[row] = lstr_param.string3
			this.ii_update = 1
		END IF
		
end choose


end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;String ls_almacen, ls_origen

this.object.nro_item 				[al_row] = of_nro_item( this )
this.object.cod_usr					[al_row] = gs_user
this.object.fec_registro			[al_row] = gnvo_app.of_fecha_actual( )
this.object.flag_estado				[al_row] = '1'
this.object.flag_afecto_igv		[al_Row] = '1'

this.object.cant_proyect			[al_row] = 1
this.object.descuento				[al_row] = 0.00
this.object.importe_igv				[al_row] = 0.00
this.object.precio_vta				[al_row] = 0.00
this.object.precio_unit				[al_row] = 0.00
this.object.porc_igv					[al_row] = gnvo_app.finparam.idc_porc_igv

this.object.flag_bolsa_plastica	[al_row] = '0'
this.object.ICBPER					[al_row] = 0.00

if gnvo_app.finparam.is_modif_precio_unit = '0' then
	this.object.precio_unit.protect 	= '1'
	this.object.precio_vta.protect 	= '1'

	//if this.of_ExisteCampo("descuento") then
	//	this.object.descuento.protect 	= '1'
	//end if

else
	this.object.precio_unit.protect 	= '0'
	this.object.precio_vta.protect 	= '0'
	
	//if this.of_ExisteCampo("descuento") then
	//	this.object.descuento.protect 	= '1'
	//end if

end if

//if this.of_ExisteCampo("descuento") then
//	if not (upper(gs_empresa) = 'NEGOCIOS_ANTON' or upper(gs_empresa) = '24HORAS') then
//		this.object.descuento.protect 	= '1'
//	else
//		this.object.descuento.protect 	= '0'
//	end if
//end if	

//Inserto el almacen por defecto, segun el origen
ls_origen = dw_master.object.cod_origen [1]

if IsNull(ls_origen) or trim(ls_origen) = '' then
	MessageBox('Aviso', 'No se ha especificado el origen en la cabecera del COMPROBANTE, por favor verifique!', StopSign!)
	return
end if

select al.almacen
	into :ls_almacen
from 	almacen 			al,
		almacen_user 	au
where al.almacen 		= au.almacen
  and al.flag_estado = '1'
  and al.cod_origen 	= :ls_origen
  and au.cod_user   	= :gs_origen;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe ningun almacén activo para el origen ' + ls_origen + ', por favor verifique!', StopSign!)
else
	this.object.almacen [al_row] = ls_almacen
end if


end event

event dw_detail::keydwn;call super::keydwn;if KeyDown( KeyControl! ) And KeyDown( KeyG! ) then
	this.AcceptText()
	
	parent.event ue_update()
	
elseif KeyDown( KeyControl! ) And KeyDown( KeyF! ) then
	this.AcceptText()
	
	parent.event ue_insertar_forma_pago ()
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

type cb_grabar from commandbutton within w_ve318_factura_popup
event keydown pbm_keydown
integer x = 3049
integer width = 539
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grabar (Ctrl-G)"
end type

event keydown;if KeyDown( KeyControl! ) And KeyDown( KeyG! ) then
	
	parent.event ue_update()
	
elseif KeyDown( KeyControl! ) And KeyDown( KeyF! ) then
	
	parent.event ue_insertar_forma_pago ()
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

event clicked;setPointer(HourGlass!)
parent.event ue_update( )
setPointer(Arrow!)
end event

type cb_salir from commandbutton within w_ve318_factura_popup
integer x = 3611
integer width = 539
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar (Esc)"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar( )
end event

type pb_add from picturebutton within w_ve318_factura_popup
integer x = 4174
integer width = 279
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<Ctrl-F>"
string picturename = "C:\SIGRE\resources\PNG\Add_icon.png"
string disabledname = "C:\SIGRE\resources\PNG\Add_icon.png"
boolean map3dcolors = true
string powertiptext = "Añadir forma de pago (F3)"
end type

event clicked;parent.event dynamic ue_insertar_forma_pago()
end event

type dw_formas_pago from u_dw_abc within w_ve318_factura_popup
integer x = 3017
integer y = 120
integer width = 2153
integer height = 1200
integer taborder = 20
string dataobject = "d_abc_fs_forma_pago_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 8				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 				[al_row] = gs_user
this.object.fec_registro 		[al_row] = gnvo_app.of_fecha_actual( )
this.object.flag_forma_pago 	[al_row] = 'E'
this.object.monto 				[al_row] = of_total_doc( )
this.object.monto_pago			[al_row] = of_total_doc( )
this.object.fec_vencimiento	[al_row] = Date(gnvo_app.of_fecha_actual( ))
this.object.factor				[al_row] = 1
this.object.nro_cuotas			[al_row] = 0
this.object.porc_interes		[al_row] = 0.00
this.object.nro_item				[al_row] = of_nro_item(this)


// Si es un movimiento de devolucion no puedo modificar el articulo

this.Modify("tipo_tarjeta.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj1.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj2.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj3.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj4.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("ccv.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("fec_vencimiento.Protect ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")

this.Modify("tipo_tarjeta.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj1.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj2.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj3.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("nro_tj4.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("ccv.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")
this.Modify("fec_vencimiento.Edit.Required ='1~tIf(flag_forma_pago=~~'T~~',0,1)'")

this.SetColumn('monto_pago')
end event

event buttonclicked;call super::buttonclicked;String	ls_nro_registro, ls_flag_forma_pago
Long		ll_nro_item

if lower(dwo.name) = 'b_delete' then
	if is_flag_modif_fpago = '0' then
		MessageBox('Aviso', 'No se puede modificar la forma de pago en este comprobante', Information!)
		return
	end if
	
	
	if MessageBox('Aviso', 'Desea eliminar el item?', Information!, YesNo!, 2 ) = 2 then return
	
	ls_nro_registro 		= this.object.nro_registro		[row]
	ls_flag_forma_pago 	= this.object.flag_forma_pago	[row]
	ll_nro_item 			= Long(this.object.nro_item	[row])
	
	if gnvo_app.ventas.of_anular_pago_fs_smpl(ls_nro_registro, ls_flag_forma_pago, ll_nro_item) then
		this.DeleteRow( row )	
		
		commit;
		
	end if
	this.ii_update = 1
	
end if
end event

event itemchanged;call super::itemchanged;if is_flag_modif_fpago = '0' then
	MessageBox('Aviso', 'No se puede modificar la forma de pago en este comprobante', Information!)
	return 1
end if
end event

event keydwn;call super::keydwn;if KeyDown( KeyControl! ) And KeyDown( KeyG! ) then
	
	parent.event ue_update()
	
elseif KeyDown( KeyControl! ) And KeyDown( KeyF! ) then
	
	parent.event ue_insertar_forma_pago ()
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

type cb_bien from commandbutton within w_ve318_factura_popup
integer x = 1445
integer y = 1328
integer width = 590
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar Bien [F5]"
end type

event clicked;parent.event ue_event_F5()
end event

type cb_vales from commandbutton within w_ve318_factura_popup
integer x = 2624
integer y = 1328
integer width = 590
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Vales Descuento [F7]"
end type

event clicked;string	ls_cliente
if dw_formas_pago.RowCount( ) > 0 then
	MessageBox('Aviso', 'No se pueden ingresar mas vales de descuento si ya se ha ingresado la forma de pago, ' &
							+ 'para ello elimine primero todas las formas de pago antes ' &
							+ 'de insertar un nuevo vale de descuento', StopSign!)
	return
end if

if dw_master.RowCount( ) = 0 then
	MessageBox('Aviso', 'Debe ingresar una cabecera del comprobante de pago. Por favor verifique!', StopSign!)
	return
end if

ls_cliente = dw_master.object.cliente [1]

if ls_cliente = gnvo_app.finparam.is_cliente_gen then
	MessageBox('Aviso', 'No está permitido el CLIENTE GENERICO para Vales de Descuento. Por favor registre el comprobante de pago con los datos del cliente!', StopSign!)
	return
end if


parent.event ue_vales_descuento()
end event

type cb_anticipos from commandbutton within w_ve318_factura_popup
integer x = 3214
integer y = 1328
integer width = 590
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Anticipos [F8]"
end type

event clicked;parent.event ue_insertar_anticipos()
end event

type cb_nv from commandbutton within w_ve318_factura_popup
integer x = 3803
integer y = 1328
integer width = 590
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "NC / ND [F9]"
end type

event clicked;parent.event ue_insertar_notas_venta()


end event

type cb_servicio from commandbutton within w_ve318_factura_popup
integer x = 2034
integer y = 1328
integer width = 590
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar Servicio [F6]"
end type

event clicked;parent.event ue_insertar_servicio()
end event

type st_1 from statictext within w_ve318_factura_popup
integer x = 5
integer y = 1352
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo de Barra:"
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_ve318_factura_popup
integer x = 457
integer y = 1332
integer width = 695
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event modified;SetPointer(HourGlass!)
parent.event ue_lectura()
SetPointer(Arrow!)
end event

type cb_lectura from commandbutton within w_ve318_factura_popup
integer x = 1166
integer y = 1328
integer width = 256
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Lect."
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_lectura()
SetPointer(Arrow!)
end event

