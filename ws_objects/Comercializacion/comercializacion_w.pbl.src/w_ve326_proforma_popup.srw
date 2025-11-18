$PBExportHeader$w_ve326_proforma_popup.srw
forward
global type w_ve326_proforma_popup from w_abc_mastdet_smpl
end type
type cb_grabar from commandbutton within w_ve326_proforma_popup
end type
type cb_salir from commandbutton within w_ve326_proforma_popup
end type
type cb_bien from commandbutton within w_ve326_proforma_popup
end type
type cb_servicio from commandbutton within w_ve326_proforma_popup
end type
end forward

global type w_ve326_proforma_popup from w_abc_mastdet_smpl
integer width = 6309
integer height = 2832
string title = "[]"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
event keydown pbm_keydown
event ue_insertar_bien ( )
event ue_insertar_servicio ( )
event ue_event_f5 ( )
cb_grabar cb_grabar
cb_salir cb_salir
cb_bien cb_bien
cb_servicio cb_servicio
end type
global w_ve326_proforma_popup w_ve326_proforma_popup

type variables
u_ds_base 			ids_cabecera, ids_detalle
String				is_nom_vendedor, is_flag_modif_fpago = '1'
n_cst_wait			invo_wait
n_cst_utilitario	invo_util
end variables

forward prototypes
public function integer of_set_numera ()
public function decimal of_total_doc ()
public subroutine of_nota_credito_debito (long al_row)
public subroutine of_retrieve (string as_nro_registro)
public function boolean of_valida_art_serv ()
end prototypes

event keydown;IF Key = KeyF5! THEN
	
	this.event ue_event_f5( )
	
elseif Key = KeyF6! then
	
	this.event ue_insertar_servicio( )
	
END IF


end event

event ue_insertar_bien();Boolean 			lb_ret
string			ls_almacen, ls_desc_almacen, ls_sql, ls_origen, ls_moneda_cab, ls_cod_art, &
					ls_flag_afecto_igv, ls_flag_bolsa_plastico
Decimal			ldc_tasa_cambio, ldc_precio_vta_unidad, ldc_porc_igv, ldc_precio_vta, &
					ldc_cant_proyect, ldc_base_imponible, ldc_icbper
blob				lbl_imagen
Date				ld_fec_emision
Long				ll_row
str_articulo	lstr_articulo

try 
	
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
	
	if dw_detail.RowCount() = 0 then
	
		//Selecciono el almacen
		if gnvo_app.almacen.is_show_all_almacen = '0' then
			ls_sql = "select a.almacen as almacen, " &
					 + "a.desc_almacen as descripcion_almacen " &
					 + "from almacen a " &
					 + "where a.flag_estado = '1'" &
					 + " and a.cod_origen = '" + ls_origen + "'"
		else
			ls_sql = "select a.almacen as almacen, " &
					 + "a.desc_almacen as descripcion_almacen " &
					 + "from almacen a " &
					 + "where a.flag_estado = '1'" 
		end if			
		
		if not gnvo_app.of_lista(ls_sql, ls_almacen, ls_desc_almacen, '2') then return
		
	else
		ls_almacen = dw_detail.object.almacen [1]
	end if
	
	
	//Obtengo el articulo
	lstr_articulo = gnvo_app.almacen.of_get_articulo_venta( ls_almacen )
	if not lstr_articulo.b_Return then return
	
	ls_cod_art = lstr_articulo.cod_art
	
	//Obtengo el flag_afecto_igv
	select flag_afecto_igv
		into :ls_flag_afecto_igv
	from articulo
	where cod_art = :ls_cod_art;
	
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
	
	ll_row = dw_detail.event ue_insert()
	
	if ll_row > 0 then
		dw_detail.object.almacen				[ll_row] = ls_almacen
		dw_detail.object.cod_art				[ll_row] = lstr_articulo.cod_art
		dw_detail.object.codigo					[ll_row] = lstr_articulo.cod_art
		dw_detail.object.desc_art				[ll_row] = lstr_articulo.desc_art
		dw_detail.object.descripcion			[ll_row] = lstr_articulo.desc_art
		dw_detail.object.und						[ll_row] = lstr_articulo.und
		dw_detail.object.flag_afecto_igv		[ll_row] = ls_flag_afecto_igv
		
		dw_detail.object.precio_vta_unidad	[ll_row] = lstr_articulo.precio_vta_unidad
		dw_detail.object.precio_vta_mayor	[ll_row] = lstr_articulo.precio_vta_mayor
		dw_detail.object.precio_vta_min		[ll_row] = lstr_articulo.precio_vta_min
		dw_detail.object.precio_vta_oferta	[ll_row] = lstr_articulo.precio_vta_oferta
		
		//dw_detail.object.cantidad				[ll_row] = ldc_cant_proyect
		
		try 
					
			//Obtengo la cantidad proyectada
			ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)

			dw_detail.object.cantidad		[ll_row] = ldc_cant_proyect
			
			//Si la cantidad es mayor o igual que la cantidad mayorista, elijo el precio mayorista
			if Dec(dw_detail.object.precio_vta_oferta	[ll_row]) > 0 then
				
				ldc_precio_vta = Dec(dw_detail.object.precio_vta_oferta	[ll_row])
				
			elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
					and Dec(dw_detail.object.precio_vta_mayor	[ll_row]) > 0 then	
					
				ldc_precio_vta = Dec(dw_detail.object.precio_vta_mayor	[ll_row])
				
			else
				
				ldc_precio_vta = Dec(dw_detail.object.precio_vta_unidad	[ll_row])
				
			end if
		
		catch ( Exception e )
			MessageBox('Error', 'Ha ocurrido una excepcion al obtener datos del parametro CANTIDAD_DEFAULT_1. Mensaje: ' + e.getMessage(), StopSign!)
			return
		end try
		
				
		//Obtengo el precio de Venta unitario según la moneda
		if ls_moneda_cab <> gnvo_app.is_soles then
			ldc_precio_vta = ldc_precio_vta / ldc_tasa_cambio
		end if
		
		
		//Obtengo el precio, quitando el IGV
		if ls_flag_afecto_igv = '1' then
			ldc_porc_igv 			= Dec(dw_detail.object.porc_igv	[ll_row])
			ldc_base_imponible 	= ldc_precio_vta / (1 + ldc_porc_igv / 100)
		else
			ldc_porc_igv			= 0
			ldc_base_imponible	= ldc_precio_vta
		end if
	
		dw_detail.object.precio_unit			[ll_row] = ldc_base_imponible
		dw_detail.object.importe_igv			[ll_row] = ldc_precio_vta - ldc_base_imponible
		dw_detail.object.precio_vta			[ll_row] = ldc_precio_vta
		
		//Pregunto si va a tener bolsa plastica o no
		if MessageBox('Aviso', '¿Se Entregara el articulo ' + ls_cod_art + ' ' &
									  + trim(lstr_articulo.desc_art) &
									  + ' en una bolsa plastica?. Si va a entregar varios productos en una bolsa ' &
									  + ' plastica grande, ' &
									  + ' solo marque solo el primer item de la lista y el resto le indica NO.', &
									  Information!, YesNo!, 1) = 1 then
									  
			ls_flag_bolsa_plastico = '1'
			ld_Fec_emision = Date (dw_master.object.fec_registro [1])
			ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
		else
			ls_flag_bolsa_plastico = '0'
			ldc_icbper = 0.0
		end if
		
		dw_detail.object.flag_bolsa_plastico[ll_row] = ls_flag_bolsa_plastico
		dw_detail.object.icbper					[ll_row] = ldc_icbper
		
		
		dw_detail.setColumn("almacen")
		dw_detail.setFocus()
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
end try

end event

event ue_insertar_servicio();String 	ls_moneda_cab, ls_cod_Servicio, ls_desc_servicio, ls_moneda, ls_tarifa, &
			ls_sql
Decimal	ldc_tasa_cambio, ldc_tarifa, ldc_porc_igv, ldc_precio_vta
Boolean	lb_ret
Long		ll_row

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
		 + "a.tarifa as tarifa " &
		 + "from servicios_cxc a " &
		 + "where a.flag_estado = '1'"

lb_ret = f_lista_4ret(ls_sql, ls_cod_servicio, ls_desc_servicio, ls_moneda, ls_tarifa, '1')

if lb_ret then
	
	ll_row = dw_detail.event ue_insert()
	if ll_row > 0 then
		dw_detail.object.cod_servicio			[ll_row] = ls_cod_servicio
		dw_detail.object.codigo					[ll_row] = ls_cod_Servicio
		dw_detail.object.descripcion			[ll_row] = ls_desc_servicio
	
		dw_detail.object.precio_unit			[ll_row] = dec(ls_tarifa)
		dw_detail.object.flag_afecto_igv		[ll_row] = '1'
		dw_detail.object.cantidad				[ll_row] = 1
		
		//Convierto la tarifa a la moneda indicada
		if ls_moneda_cab = ls_moneda then
			ldc_tarifa = dec(ls_tarifa)
		elseif ls_moneda_cab = gnvo_app.is_soles then
			ldc_tarifa = dec(ls_tarifa) * ldc_tasa_cambio
		else
			ldc_tarifa = dec(ls_tarifa) / ldc_tasa_cambio
		end if
			
		//Obtengo el precio, quitando el IGV
		ldc_porc_igv 	= Dec(dw_detail.object.porc_igv	[ll_row])
		
		
		
		ldc_precio_vta = ldc_tarifa / (1 + ldc_porc_igv / 100)
	
		dw_detail.object.precio_unit			[ll_row] = ldc_precio_vta
		dw_detail.object.importe_igv			[ll_row] = ldc_tarifa - ldc_precio_vta 
	end if	
end if


end event

event ue_event_f5();try 
	if dw_detail.event ue_insert() > 0 then
		dw_detail.setColumn('almacen')
		dw_detail.setFocus()
	end if
		
catch ( Exception ex )
	
	MessageBox('Error', 'Ha ocurrido una exception: ' + ex.getMessage(), StopSign!)
end try

end event

public function integer of_set_numera ();//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro, ls_tabla, ls_tipo_doc, ls_serie_doc, ls_nro_doc, ls_nro_doc_old

try 
	//Obtengo el nro de registro de Factura Simplificada
	if is_action = 'new' then
		
		ls_tabla = upper(dw_master.object.DataWindow.Table.UpdateTable)
		
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
		ls_nro = TRIM(gs_origen) + invo_util.lpad(invo_util.of_long2Hex(ll_ult_nro), 8, '0')
		
		dw_master.object.nro_proforma[dw_master.getrow()] = ls_nro
		
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
		ls_nro = dw_master.object.nro_proforma[dw_master.getrow()] 
	end if
	
	for ll_i = 1 to dw_detail.RowCount()
		dw_detail.object.nro_proforma [ll_i] = ls_nro
	next

	
	return 1
	
catch ( Exception ex )
	rollback;
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMEssage(), StopSign!)
	return 0
	
finally
	/*statementBlock*/
end try


end function

public function decimal of_total_doc ();Decimal	ldc_total_doc = 0, ldc_precio_unit, ldc_cantidad, ldc_importe_igv, ldc_descuento
Long 		ll_i

for ll_i = 1 to dw_detail.RowCount( )
	ldc_precio_unit 	= dec(dw_detail.object.precio_unit 		[ll_i])
	ldc_cantidad 		= dec(dw_detail.object.cantidad		 	[ll_i])
	ldc_importe_igv	= Dec(dw_detail.object.importe_igv 		[ll_i])
	
	ldc_total_doc += ldc_cantidad * (ldc_precio_unit + ldc_importe_igv )

next

return ldc_total_doc
end function

public subroutine of_nota_credito_debito (long al_row);
end subroutine

public subroutine of_retrieve (string as_nro_registro);dw_master.Retrieve(as_nro_registro)
dw_detail.Retrieve(as_nro_registro)

dw_master.ii_update = 0
dw_detail.ii_update = 0


dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_protect = 0
dw_detail.of_protect()



end subroutine

public function boolean of_valida_art_serv ();String 	ls_cod_art, ls_servicio
Decimal	ldc_precio_unit, ldc_cant_proyect
Long 		ll_row

if dw_detail.RowCount() = 0 then return true

for ll_row = 1 to dw_detail.RowCount()
	ls_cod_art 			= dw_detail.object.cod_art 			[ll_row]
	ls_servicio 		= dw_detail.object.cod_servicio 		[ll_row]
	ldc_cant_proyect	= Dec(dw_detail.object.cantidad		[ll_row])
	ldc_precio_unit 	= Dec(dw_detail.object.precio_unit	[ll_row])
	
	if IsNull(ldc_cant_proyect) then 
		ldc_Cant_proyect = 0
		dw_detail.object.cantidad	[ll_row] = 0
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

on w_ve326_proforma_popup.create
int iCurrent
call super::create
this.cb_grabar=create cb_grabar
this.cb_salir=create cb_salir
this.cb_bien=create cb_bien
this.cb_servicio=create cb_servicio
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_grabar
this.Control[iCurrent+2]=this.cb_salir
this.Control[iCurrent+3]=this.cb_bien
this.Control[iCurrent+4]=this.cb_servicio
end on

on w_ve326_proforma_popup.destroy
call super::destroy
destroy(this.cb_grabar)
destroy(this.cb_salir)
destroy(this.cb_bien)
destroy(this.cb_servicio)
end on

event ue_open_pre;str_parametros		lstr_param
Long					ll_row, ll_i, ll_count
String				ls_serie_guia, ls_serie_doc, ls_tipo_doc, ls_vendedor, ls_nom_vendedor, &
						ls_punto_venta, ls_desc_punto_venta, ls_flag_estado, ls_nro_proforma
dateTime				ldt_fec_movimiento
Decimal				ldc_descuento, ldc_temp
str_direccion		lstr_direccion

try 
	invo_wait = create n_cst_wait	
	
	ii_lec_mst = 0 
	is_action = ''
	
	dw_master.ii_protect = 1
	dw_master.of_protect( )
	
	dw_detail.ii_protect = 1
	dw_detail.of_protect( )
	
	idw_1 = dw_master
	
	lstr_param = Message.powerObjectparm
	
	if not IsNull(lstr_param) and IsValid(lstr_param) then
		
		if lstr_param.string1 = 'edit' then
			
			this.of_retrieve(lstr_param.string2)
			
			is_action = 'edit'
			
			this.Title = "[VE326] Edicion de Proforma N° " + lstr_param.string2
			
			if dw_master.RowCount() > 0 then
				ls_flag_estado 	= dw_master.object.flag_estado 	[1]
				ls_nro_proforma 	= dw_master.object.nro_proforma 	[1]
				
				//Si la proforma no se encuentra activo entonces simplemente desactivo todo
				if ls_flag_estado <> '1' then
					dw_master.ii_protect = 0
					dw_master.of_protect()
					dw_detail.of_protect()
					cb_bien.enabled = false
					cb_servicio.enabled = false
					cb_grabar.enabled = false
					
					MessageBox('Aviso', 'La Proforma ' + ls_nro_proforma + ' no se encuentra activa, por lo que no se puede modificar', StopSign!)
				else
					dw_master.ii_protect = 1
					dw_master.of_protect()
					dw_detail.of_protect()
					
					cb_bien.enabled = true
					cb_servicio.enabled = true
					cb_grabar.enabled = true
					
				end if
			end if
			
			
		else
			MessageBox('Error', 'Opcion [' + lstr_param.string1 + '] aun no implementada, por favor verifique!', StopSign!)
		end if
		
	else
	
		this.Title = "[VE326] Generación de Proforma"
	
		
		//Ahora inserto la cabecera y detalle
		ll_row = dw_master.event ue_insert()
		
	end if
	
	//me ubico en el control de vendedor
	dw_master.setColumn("fec_expiracion")
	dw_master.setFocus()

	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
end try


end event

event resize;//Override
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

end event

event ue_cancelar;//Override
Str_parametros lstr_param

if MessageBox('Aviso', 'Desea salir de la ventana?', Information!, YesNo!, 2) = 2 then return

lstr_param.b_return = false

ClosewithReturn(this, lstr_param)
end event

event ue_update;//Override
Boolean 	lbo_ok = TRUE
String		ls_msg, ls_nro_proforma, ls_mensaje, ls_cliente, ls_email, ls_tipo_doc
boolean	lb_send_email
Long		ll_rpta
Str_parametros	lstr_param

try 
	if not of_valida_art_serv() then return
	
	dw_master.AcceptText()
	dw_detail.AcceptText()
	
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN RETURN
	
	IF ib_log THEN
		dw_master.of_create_log()
		dw_detail.of_create_log()
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

	
	IF ib_log THEN
		IF lbo_ok THEN
			lbo_ok = dw_master.of_save_log()
			lbo_ok = dw_detail.of_save_log()
		END IF
	END IF
	
	IF lbo_ok THEN
		
		COMMIT;
		
		//Los datawindows ya no tienen cambios pendientes
		dw_master.ii_update 			= 0
		dw_detail.ii_update 			= 0
		
		dw_master.il_totdel 			= 0
		dw_detail.il_totdel 			= 0
	
		dw_master.ResetUpdate()
		dw_detail.ResetUpdate()
		
		f_mensaje('Grabación de PROFORMA realizada satisfactoriamente. Presio ENTER para imprimir el ticket', '')
		
		//Imprimo el comprobante
		ls_nro_proforma = dw_master.object.nro_proforma [1]
		
		if MessageBox('Error', 'Desea imprimir la proforma Nro ' + ls_nro_proforma + "?", Information!, Yesno!, 2) = 1 then
			gnvo_app.ventas.of_print_proforma( ls_nro_proforma ) 
		end if
		
		lstr_param.b_return = true
		CloseWithReturn(this, lstr_param)
		
	END IF
catch ( Exception ex)
	gnvo_app.of_catch_exception( ex, "")

finally
	
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

event ue_update_pre;call super::ue_update_pre;String 	ls_flag_fac_bol, ls_cliente, ls_ruc_dni, ls_tipo_doc_ident, &
			ls_codigo
Date 		ld_fec_registro, ld_hoy
Long		ll_row
decimal	ldc_cantidad, ldc_precio_unit, ldc_descuento, ldc_importe_igv

ib_update_check = False

ld_hoy = date(gnvo_app.of_fecha_Actual())

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then	return

if dw_master.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta CABECERA", StopSign!)
	return
end if

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta DETALLE", StopSign!)
	return
end if

//Verifico que todas las lineas tengan un importe diferente de cero
for ll_row = 1 to dw_Detail.rowCount()
	ldc_cantidad 		= Dec(dw_detail.object.cantidad 		[ll_row])
	ldc_precio_unit	= Dec(dw_detail.object.precio_unit 	[ll_row])
	ldc_importe_igv	= Dec(dw_detail.object.importe_igv 	[ll_row])
	ls_codigo			= dw_detail.object.codigo 				[ll_row]
	
	if ldc_precio_unit = 0 then
		ROLLBACK;
		MessageBox('Error', 'En el detalle del comprobante de venta, existe un registro con precio Venta IGUAL a CERO, por favor corrija!', StopSign!)
		
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(ll_row, true)
		dw_detail.SetRow(ll_row)
		dw_detail.ScrollToRow(ll_row)
		return 
	end if
	
	if ldc_cantidad * (ldc_precio_unit + ldc_importe_igv) = 0 then
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
ls_flag_fac_bol 	= dw_master.object.flag_factura_boleta [1]
ls_cliente 			= dw_master.object.cliente 				[1]
ls_ruc_dni			= dw_master.object.ruc_dni 				[1]


// Verifica que codigo ingresado exista			
ld_fec_registro = Date(dw_master.object.fec_registro [1])

if ld_fec_registro > ld_hoy then
	MessageBox("Error", "La Fecha del comprobante no puede ser mayor al día de hoy, por favor verifique")
	dw_master.object.fec_registro			[1] = gnvo_app.of_fecha_Actual()
	return 
end if

//El total del documento no puede ser negativo
if this.of_total_doc( ) <= 0 then
	messagebox( "Atencion", "No se grabara el documento, El Total del documento debe ser MAYOR a CERO. Por favor verifique", StopSign!)
	return
end if

//Valido si es boleta y que supere el maximo de sunat, entonces debe tener dni
if ls_flag_fac_bol = 'B' and &
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
if ls_flag_fac_bol = 'F'  then
	
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


//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event ue_insert;////Override
//Long  ll_row
//String ls_tipo_doc_cxc
//
//if is_action = 'edit' then
//	MessageBox('Error', 'No esta permitido insertar items en modo de edición', StopSign!)
//	return
//end if
//
//IF idw_1 = dw_formas_pago then
//	
//	if dw_master.RowCount() = 0 then
//		MessageBox("Error", "El comprobante no tiene cabecera, por favor verifique!", StopSign!)
//		RETURN
//	end if
//	
//	ls_tipo_doc_cxc = dw_master.object.tipo_doc_cxc [1]
//
//	if trim(ls_tipo_doc_cxc) = trim(gnvo_app.finparam.is_doc_ncc) or &
//		trim(ls_tipo_doc_cxc) = trim(gnvo_app.finparam.is_doc_ndc) then
//		
//		messagebox( "Atencion", "No se puede ingresar forma de pago en NOTAS DE CREDITO / DEBITO. Por favor verifique!", StopSign!)
//		dw_master.setFocus( )
//		return
//		
//	end if
//
//END IF
//
//ll_row = idw_1.Event ue_insert()
//
//IF ll_row <> -1 THEN
//	THIS.EVENT ue_insert_pos(ll_row)
//end if
//
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ve326_proforma_popup
integer x = 0
integer y = 0
integer width = 3109
integer height = 996
string dataobject = "d_abc_proforma_cab_ff"
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
string 			ls_codigo, ls_data, ls_sql, ls_flag_fac_bol, ls_cliente, ls_tipo_doc
str_cliente		lstr_cliente
str_direccion	lstr_direccion
str_parametros	lstr_param

try 
	choose case lower(as_columna)
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
	
			ls_flag_fac_bol = this.object.flag_factura_boleta [al_row]

			
			lstr_cliente = gnvo_app.finparam.of_get_cliente( ls_flag_fac_bol )
			
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

		CASE 'cod_moneda'
			
			// Verifica que codigo ingresado exista			
			Select descripcion
			  into :ls_desc
			  from moneda
			 Where cod_moneda 	= :data  
				and flag_estado 	= '1';			
				
			// Verifica que articulo solo sea de reposicion		
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "Código de Moneda " + data &
										+ " no existe o no se encuentra activo, por favor verifique!")
				this.object.cod_moneda		[row] = gnvo_app.is_null
				return 1
				
			end if
			
		CASE 'cod_moneda'
			
			// Verifica que codigo ingresado exista			
			Select descripcion
			  into :ls_desc
			  from moneda
			 Where cod_moneda 	= :data  
				and flag_estado 	= '1';			
				
			// Verifica que articulo solo sea de reposicion		
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "Código de Moneda " + data &
										+ " no existe o no se encuentra activo, por favor verifique!")
				this.object.cod_moneda		[row] = gnvo_app.is_null
				return 1
				
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;str_Direccion 	lstr_direccion
DateTime 		ldt_now
String			ls_nom_vendedor

ldt_now = gnvo_app.of_fecha_actual( )

this.object.fec_registro 			[al_row] = ldt_now 
this.object.fec_expiracion 		[al_row] = date(ldt_now) 
this.object.flag_estado 			[al_row] = '1'
this.object.cod_origen				[al_row] = gs_origen
this.object.cod_usr 					[al_row] = gs_user
this.object.flag_factura_boleta 	[al_row] = 'B'
this.object.cod_moneda				[al_row] = gnvo_app.is_soles
this.object.tasa_cambio				[al_row] = gnvo_app.of_tasa_cambio(date(ldt_now))


this.object.cliente					[al_row] = gnvo_app.finparam.is_cliente_gen
this.object.nom_cliente				[al_row] = gnvo_app.finparam.is_nom_cliente_gen
this.object.ruc_dni					[al_row] = gnvo_app.finparam.is_doc_cli_gen

lstr_direccion = gnvo_app.logistica.of_get_direccion(gnvo_app.finparam.is_cliente_gen)

if lstr_direccion.b_return then
	this.object.item_direccion		[al_row] = lstr_direccion.item_direccion
	this.object.direccion			[al_row] = lstr_direccion.direccion
end if

//Inserto el vendedor
select nom_vendedor
	into :ls_nom_vendedor
from vendedor
where vendedor = :gs_user;

if SQLCA.SQLCode <> 100 then
	
	this.object.vendedor			[al_row] = gs_user
	this.object.nom_vendedor	[al_row] = ls_nom_vendedor
	
end if

this.SetColumn("fec_expiracion")

is_action = 'new'


end event

event dw_master::buttonclicked;call super::buttonclicked;str_parametros	lstr_param

if lower(dwo.name) = 'b_obs' then
	
	If this.is_protect("observacion", row) then RETURN
		
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Descripcion de la PROFORMA'
	lstr_param.string2	 = this.object.observacion [row]

	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.observacion [row] = left(lstr_param.string3, 2000)
			this.ii_update = 1
	END IF	
	
end if
end event

event dw_master::keydwn;//Oveerriding
blob {28} lbl_msg
string 	ls_columna, ls_cadena
integer 	li_column
Long		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if



if KeyDown( KeyControl! ) And KeyDown( KeyG! ) then
	
	parent.event ue_update()
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ve326_proforma_popup
integer x = 5
integer y = 1004
integer width = 3534
integer height = 992
string dataobject = "d_abc_proforma_det_tbl"
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

event dw_detail::ue_display;call super::ue_display;boolean 			lb_ret
string 			ls_codigo, ls_data, ls_sql, ls_almacen, ls_und, ls_origen, ls_cod_Art, &
					ls_bien_servicio, ls_moneda, ls_tarifa, ls_moneda_cab, ls_flag_afecto_igv, &
					ls_flag_bolsa_plastico
Decimal			ldc_precio_vta, ldc_porc_igv, ldc_tarifa, ldc_tasa_cambio, &
					ldc_precio_vta_unidad, ldc_base_imponible, ldc_cant_proyect, ldc_icbper
str_Articulo	lstr_articulo
Date				ld_fec_emision
Blob				lbl_imagen

choose case lower(as_columna)
	case "almacen"
		ls_origen = dw_master.object.cod_origen [1]
		
		if IsNull(ls_origen) or trim(ls_origen) = '' then
			MessageBox('Error', 'La cabecere del comprobante de Venta no tiene origen, por favor corrija', StopSign!)
			return
		end if
		
		//Valido si muestro o no todos los almacenes
		if gnvo_app.almacen.is_show_all_almacen = '0' then
			ls_sql = "select a.almacen as almacen, " &
					 + "a.desc_almacen as descripcion_almacen " &
					 + "from almacen a " &
					 + "where a.flag_estado = '1'" &
					 + " and a.cod_origen = '" + ls_origen + "'"
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
			this.object.descripcion			[al_row] = gnvo_app.is_null
			this.object.und					[al_row] = gnvo_app.is_null
			This.object.cantidad				[al_row] = 0.00
			This.object.precio_unit			[al_row] = 0.00
			This.object.importe_igv			[al_row] = 0.00
			This.object.precio_vta			[al_row] = 0.00
			This.object.flag_afecto_igv	[al_row] = '1'
			
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
			ls_almacen = this.object.almacen [al_row]
			
			if IsNull(ls_almacen) or ls_almacen = '' then
				MessageBox('Aviso', "Debe seleccionar el almacén primero, por favor verifique!", StopSign!)
				this.SetColumn( "almacen" )
				return
			end if
			
			lstr_articulo = gnvo_app.almacen.of_get_articulo_venta( ls_almacen ) //of_get_articulo_venta( ls_almacen )
	
			if lstr_articulo.b_Return then
				
				ls_cod_art = lstr_articulo.cod_art
				
				//Obtengo la imagen del producto
				select nvl(flag_afecto_igv, '0')
					into :ls_flag_afecto_igv
				from articulo 
				where cod_art = :ls_cod_art;
				
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
				
				this.object.cod_art				[al_row] = lstr_articulo.cod_art
				this.object.codigo				[al_row] = lstr_articulo.cod_art
				this.object.descripcion			[al_row] = lstr_articulo.desc_art
				this.object.und					[al_row] = lstr_articulo.und
				this.object.flag_afecto_igv	[al_row] = ls_flag_afecto_igv
				
				This.object.precio_vta_unidad	[al_row] = lstr_articulo.precio_vta_unidad
				This.object.precio_vta_mayor	[al_row] = lstr_articulo.precio_vta_mayor
				This.object.precio_vta_min		[al_row] = lstr_articulo.precio_vta_min
				This.object.precio_vta_oferta	[al_row] = lstr_articulo.precio_vta_oferta
				
				try 
					
					//Obtengo la cantidad proyectada
					ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
	
					This.object.cantidad		[al_row] = ldc_cant_proyect
					
					//Si la cantidad es mayor o igual que la cantidad mayorista, elijo el precio mayorista
					if Dec(This.object.precio_vta_oferta	[al_row]) > 0 then
						
						ldc_precio_vta = Dec(This.object.precio_vta_oferta	[al_row])
						
					elseif ldc_cant_proyect >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
							and Dec(This.object.precio_vta_mayor	[al_row]) > 0 then	
							
						ldc_precio_vta = Dec(This.object.precio_vta_mayor	[al_row])
						
					else
						
						ldc_precio_vta = Dec(This.object.precio_vta_unidad	[al_row])
						
					end if
					
					//Pregunto si va a tener bolsa plastica o no
					if MessageBox('Aviso', '¿Se Entregara el articulo ' + ls_cod_art + ' ' &
											  + trim(lstr_articulo.desc_art) &
											  + ' en una bolsa plastica?. Si va a entregar varios productos en una bolsa ' &
											  + ' plastica grande, ' &
											  + ' solo marque solo el primer item de la lista y el resto le indica NO.', &
											  Information!, YesNo!, 1) = 1 then
											  
						ls_flag_bolsa_plastico = '1'
						ld_Fec_emision = Date (dw_master.object.fec_registro [1])
						ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
					else
						ls_flag_bolsa_plastico = '0'
						ldc_icbper = 0.0
					end if	
					
					This.object.flag_bolsa_plastico	[al_row] = ls_flag_bolsa_plastico
					This.object.icbper					[al_row] = ldc_icbper
				
				catch ( Exception e )
					MessageBox('Error', 'Ha ocurrido una excepcion al obtener datos del parametro CANTIDAD_DEFAULT_1. Mensaje: ' + e.getMessage(), StopSign!)
					return
				end try
				
				
				//Obtengo el precio de Venta unitario según la moneda
				if ls_moneda_cab <> gnvo_app.is_soles then
					ldc_precio_vta = ldc_precio_vta / ldc_tasa_cambio
				end if
				
				
				//Obtengo el precio, quitando el IGV
				if ls_flag_afecto_igv = '1' then
					ldc_porc_igv 			= Dec(this.object.porc_igv	[al_row])
					ldc_base_imponible 	= ldc_precio_vta / (1 + ldc_porc_igv / 100)
				else
					ldc_porc_igv			= 0
					ldc_base_imponible	= ldc_precio_vta
				end if
			
				This.object.precio_unit			[al_row] = ldc_base_imponible
				This.object.importe_igv			[al_row] = ldc_precio_vta - ldc_base_imponible
				This.object.precio_vta			[al_row] = ldc_precio_vta
				
			
				this.ii_update = 1
			end if
			
		elseif ls_bien_Servicio = '2' then
			
			
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

			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_moneda, ls_tarifa, ls_flag_afecto_igv, '2') then
				
				this.object.cod_servicio		[al_row] = ls_codigo
				this.object.codigo				[al_row] = ls_codigo
				this.object.descripcion			[al_row] = ls_data
				this.object.flag_afecto_igv	[al_row] = ls_flag_afecto_igv
				This.object.cantidad				[al_row] = 1
				
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
					ldc_porc_igv = Dec(this.object.porc_igv	[al_row])
				else
					ldc_porc_igv = 0.0
				end if
				
				ldc_base_imponible = ldc_tarifa / (1 + ldc_porc_igv / 100)
			
				This.object.precio_unit			[al_row] = ldc_base_imponible
				This.object.importe_igv			[al_row] = ldc_tarifa - ldc_base_imponible 
				This.object.precio_vta			[al_row] = ldc_tarifa
			end if
			
		else
			MessageBox('Error', 'Opcion aun no implementada, por favor verifique!', StopSign!)
			return
		end if
			
		
end choose
end event

event dw_detail::itemchanged;call super::itemchanged;String	ls_cod_Art, ls_cod_sku, ls_desc_art, ls_und, ls_almacen, ls_codigo, &
			ls_desc, ls_nro_vale_vd, ls_origen, ls_bien_servicio, ls_moneda_cab, &
			ls_mensaje, ls_moneda, ls_desc_servicio, ls_flag_afecto_igv, &
			ls_flag_bolsa_plastico

DEcimal	ldc_precio_vta_unidad,  ldc_precio_vta_mayor, ldc_precio_vta_oferta, &
			ldc_precio_vta_min, ldc_saldo_total, ldc_porc_igv, &
			ldc_importe_igv, ldc_tarifa, ldc_tasa_cambio, ldc_icbper, ldc_precio_vta, &
			ldc_cant_proyect, ldc_base_imponible, ldc_precio_unit_ant, ldc_precio_vta_ant

Date		ld_fec_registro, ld_fec_emision		

Integer	li_count			

Blob		lbl_imagen

try 
	this.object.precio_vta_ant [row] = Dec(this.object.precio_unit [row])
	
	ldc_precio_unit_ant	= Dec(this.object.precio_unit [row])
	ldc_precio_vta_ant	= Dec(this.object.precio_vta 	[row])
	
	this.Accepttext()
	
	
	CHOOSE CASE dwo.name
		CASE 'largo', 'ancho'
			
			
			this.object.total_und	[row] = dec(this.object.cantidad	[row]) * dec(this.object.ancho	[row]) * dec(this.object.largo	[row])
						
			return 1
		
		case 'cantidad'
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
			
			this.object.total_und	[row] = dec(this.object.cantidad	[row]) * dec(this.object.ancho	[row]) * dec(this.object.largo	[row])
						
		case "almacen"
			ls_origen = dw_master.object.cod_origen [1]
			
			if IsNull(ls_origen) or trim(ls_origen) = '' then
				MessageBox('Error', 'La cabecere de la proforma no tiene origen, por favor corrija', StopSign!)
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
			this.object.cod_art					[row] = gnvo_app.is_null
			this.object.cod_Servicio			[row] = gnvo_app.is_null
			this.object.codigo					[row] = gnvo_app.is_null
			this.object.descripcion				[row] = gnvo_app.is_null
			this.object.und						[row] = gnvo_app.is_null
			This.object.cantidad					[row] = 0.00
			This.object.precio_unit				[row] = 0.00
			This.object.importe_igv				[row] = 0.00
			This.object.precio_vta				[row] = 0.00
			This.object.flag_afecto_igv		[row] = '1'
			This.object.flag_bolsa_plastico	[row] = '0'
			This.object.icbper					[row] = 0.00
			
			this.object.precio_vta_unidad		[row] = 0.00
			this.object.precio_vta_mayor		[row] = 0.00
			this.object.precio_vta_oferta		[row] = 0.00
			this.object.precio_vta_min			[row] = 0.00
			
			
			//return 2
	
		case 'codigo'
			
			//Obtengo datos de la cabecera
			ls_moneda_cab 		= dw_master.object.cod_moneda 		[1]
			ldc_tasa_cambio	= Dec(dw_master.object.tasa_cambio [1])
	
			ls_bien_servicio = gnvo_app.ventas.of_choice_bien_servicio()
			
			if IsNull(ls_bien_servicio) or trim(ls_bien_servicio) = '' then
				MessageBox('Aviso', "Debe seleccionar si desea buscar bien o Servicio, por favor verifique!", StopSign!)
				
				This.object.cod_art					[row] = gnvo_app.is_null
				This.object.cod_servicio			[row] = gnvo_app.is_null
				This.object.codigo					[row] = gnvo_app.is_null
				This.object.descripcion				[row] = gnvo_app.is_null
				This.object.und						[row] = gnvo_app.is_null
				This.object.cantidad					[row] = 0.00
				This.object.precio_unit				[row] = 0.00
				This.object.importe_igv				[row] = 0.00
				This.object.precio_vta				[row] = 0.00
				This.object.flag_afecto_igv		[row] = '1'
				This.object.flag_bolsa_plastico	[row] = '0'
				This.object.icbper					[row] = 0.00
				
				this.object.precio_vta_unidad		[row] = 0.00
				this.object.precio_vta_mayor		[row] = 0.00
				this.object.precio_vta_oferta		[row] = 0.00
				this.object.precio_vta_min			[row] = 0.00
	
				this.SetColumn( "codigo" )
				return 1
			end if
			
			if ls_bien_Servicio = '1' then
				//Selecciono Bien o Articulo
			
				//Obtengo el almacen
				ls_almacen = this.object.almacen [row]
				
				if ISNull(ls_almacen) or trim(ls_almacen) = '' then
					MessageBox('Aviso', 'Debe ingresar primero el almacen. Por favor verifique!', StopSign!)
					
					This.object.cod_art					[row] = gnvo_app.is_null
					This.object.cod_servicio			[row] = gnvo_app.is_null
					This.object.codigo					[row] = gnvo_app.is_null
					This.object.descripcion				[row] = gnvo_app.is_null
					This.object.und						[row] = gnvo_app.is_null
					This.object.cantidad					[row] = 0.00
					This.object.precio_unit				[row] = 0.00
					This.object.importe_igv				[row] = 0.00
					This.object.precio_vta				[row] = 0.00
					This.object.flag_afecto_igv		[row] = '1'
					This.object.flag_bolsa_plastico	[row] = '0'
					This.object.icbper					[row] = 0.00
					
					this.object.precio_vta_unidad		[row] = 0.00
					this.object.precio_vta_mayor		[row] = 0.00
					this.object.precio_vta_oferta		[row] = 0.00
					this.object.precio_vta_min			[row] = 0.00
					
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
				
				//Capturo el error
				IF SQLCA.SQLCode < 0 THEN
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', "Ha ocurrido un error al validar el filtro " + ls_codigo &
											+ " en la CONSULTA. Mensaje: " + ls_mensaje, StopSign!)
						
					This.object.cod_art					[row] = gnvo_app.is_null
					This.object.cod_servicio			[row] = gnvo_app.is_null
					This.object.codigo					[row] = gnvo_app.is_null
					This.object.descripcion				[row] = gnvo_app.is_null
					This.object.und						[row] = gnvo_app.is_null
					This.object.cantidad					[row] = 0.00
					This.object.precio_unit				[row] = 0.00
					This.object.importe_igv				[row] = 0.00
					This.object.precio_vta				[row] = 0.00
					This.object.flag_afecto_igv		[row] = '1'
					This.object.flag_bolsa_plastico	[row] = '0'
					This.object.icbper					[row] = 0.00
					
					this.object.precio_vta_unidad		[row] = 0.00
					this.object.precio_vta_mayor		[row] = 0.00
					this.object.precio_vta_oferta		[row] = 0.00
					this.object.precio_vta_min			[row] = 0.00
					
					RETURN 1
				END IF
				
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
					This.object.cantidad				[row] = 0.00
					This.object.precio_unit			[row] = 0.00
					This.object.importe_igv			[row] = 0.00
					This.object.precio_vta			[row] = 0.00
					This.object.flag_afecto_igv	[row] = '1'
					This.object.flag_bolsa_plastico	[row] = '0'
					This.object.icbper					[row] = 0.00
					
					this.object.precio_vta_unidad	[row] = 0.00
					this.object.precio_vta_mayor	[row] = 0.00
					this.object.precio_vta_oferta	[row] = 0.00
					this.object.precio_vta_min		[row] = 0.00
					
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
							NVL(aa.sldo_total, 0),
							NVL(a.precio_vta_unidad,0), 
							NVL(a.precio_vta_mayor,0), 
							NVL(a.precio_vta_oferta,0), 
							NVL(a.precio_vta_min,0), 
					into 	:ls_cod_art, 
							:ls_desc_art, 
							:ls_und, 
							:ls_cod_sku,
							:ls_flag_afecto_igv,
							:ldc_saldo_total,
							:ldc_precio_vta_unidad, 
							:ldc_precio_vta_mayor, 
							:ldc_precio_vta_oferta, 
							:ldc_precio_vta_min
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
					This.object.flag_afecto_igv	[row] = '1'
					This.object.cantidad				[row] = 0.00
					This.object.precio_unit			[row] = 0.00
					This.object.importe_igv			[row] = 0.00
					This.object.precio_vta			[row] = 0.00
					This.object.flag_bolsa_plastico	[row] = '0'
					This.object.icbper					[row] = 0.00
					
					this.object.precio_vta_unidad	[row] = 0.00
					this.object.precio_vta_mayor	[row] = 0.00
					this.object.precio_vta_oferta	[row] = 0.00
					this.object.precio_vta_min		[row] = 0.00
					RETURN 1
				END IF
				 
				//Obtengo la imagen del producto
				selectBLOB imagen 
					into :lbl_imagen 
				from articulo 
				where cod_art = :ls_cod_art;
				
				if Not ISNull(lbl_imagen) then
					if not gnvo_app.logistica.of_show_imagen(lbl_imagen) then 
						
						This.object.cod_art				[row] = gnvo_app.is_null
						This.object.cod_servicio		[row] = gnvo_app.is_null
						This.object.codigo				[row] = gnvo_app.is_null
						This.object.descripcion			[row] = gnvo_app.is_null
						This.object.und					[row] = gnvo_app.is_null
						This.object.flag_afecto_igv	[row] = '1'
						This.object.cantidad				[row] = 0.00
						This.object.precio_unit			[row] = 0.00
						This.object.importe_igv			[row] = 0.00
						This.object.precio_vta			[row] = 0.00
						This.object.flag_bolsa_plastico	[row] = '0'
						This.object.icbper					[row] = 0.00
						
						this.object.precio_vta_unidad	[row] = 0.00
						this.object.precio_vta_mayor	[row] = 0.00
						this.object.precio_vta_oferta	[row] = 0.00
						this.object.precio_vta_min		[row] = 0.00
						
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
											  
					ls_flag_bolsa_plastico = '1'
					ld_Fec_emision = Date (dw_master.object.fec_registro [1])
					ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
				else
					ls_flag_bolsa_plastico = '0'
					ldc_icbper = 0.0
				end if	
				
				
				//Hago la conversión correspondiente
				if ls_moneda_cab <> gnvo_app.is_soles then
					ldc_precio_vta	= ldc_precio_vta_unidad / ldc_tasa_cambio
				else
					ldc_precio_vta	= ldc_precio_vta_unidad
				end if
		
				//Si esta todo correcto lleno los datos del articulo
				This.object.cod_art					[row] = ls_cod_Art
				This.object.codigo					[row] = ls_cod_Art
				This.object.descripcion				[row] = ls_desc_art
				This.object.und						[row] = ls_und
				This.object.flag_afecto_igv		[row] = ls_flag_afecto_igv
				This.object.flag_bolsa_plastico	[row] = ls_flag_bolsa_plastico
				This.object.icbper					[row] = ldc_icbper
				
				this.object.precio_vta_unidad		[row] = ldc_precio_vta_unidad
				this.object.precio_vta_mayor		[row] = ldc_precio_vta_mayor
				this.object.precio_vta_oferta		[row] = ldc_precio_vta_oferta
				this.object.precio_vta_min			[row] = ldc_precio_vta_min
			
		
				try 
					
					//Obtengo la cantidad proyectada
					ldc_cant_proyect = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
	
					This.object.cantidad		[row] = ldc_cant_proyect
					
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
					MessageBox('Error', 'Ha ocurrido una excepcion al obtener datos del parametro CANTIDAD_DEFAULT_1. Mensaje: ' + e.getMessage(), StopSign!)
					return 1
				end try
				
				
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
					this.object.porc_igv				[row] = 0
					This.object.precio_vta			[row] = ldc_precio_vta
					
				end if
				
				This.setColumn('cantidad')
				
			elseif ls_bien_servicio = '2' then
				
				select desc_servicio, tarifa, cod_moneda, flag_afecto_igv
					into :ls_desc_servicio, :ldc_tarifa, :ls_moneda, :ls_flag_afecto_igv
				from servicios_cxc
				where cod_servicio = :data
				  and flag_estado = '1';
				
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', "El codigo ingresado [" + data + "] " &
						+ "no existe no no se encuentra activo en el maestro "&
						+ "de Servicios de Venta. Por favor verifique!", StopSign!)
						
					This.object.cod_art					[row] = gnvo_app.is_null
					This.object.cod_servicio			[row] = gnvo_app.is_null
					This.object.codigo					[row] = gnvo_app.is_null
					This.object.descripcion				[row] = gnvo_app.is_null
					This.object.und						[row] = gnvo_app.is_null
					This.object.flag_afecto_igv		[row] = '1'
					This.object.cantidad					[row] = 0.00
					This.object.precio_unit				[row] = 0.00
					This.object.importe_igv				[row] = 0.00
					This.object.precio_vta				[row] = 0.00
					
					this.object.precio_vta_unidad		[row] = 0.00
					this.object.precio_vta_mayor		[row] = 0.00
					this.object.precio_vta_oferta		[row] = 0.00
					this.object.precio_vta_min			[row] = 0.00
					
					This.object.flag_bolsa_plastico	[row] = '0'
					This.object.icbper					[row] = 0.00
					
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
				This.object.cod_servicio			[row] = data
				This.object.codigo					[row] = data
				This.object.descripcion				[row] = ls_Desc_servicio
				This.object.flag_afecto_igv		[row] = ls_flag_afecto_igv
				This.object.cantidad					[row] = 1.00 //ldc_saldo_total
				This.object.flag_bolsa_plastico	[row] = '0'
				This.object.icbper					[row] = 0.00
				
				if ls_flag_afecto_igv = '1' then
					ldc_porc_igv = Dec(this.object.porc_igv	[row])
					ldc_base_imponible = ldc_tarifa / (1 + ldc_porc_igv / 100)
					
					This.object.precio_unit			[row] = ldc_base_imponible
					This.object.importe_igv			[row] = ldc_tarifa - ldc_base_imponible
					This.object.precio_vta			[row] = ldc_tarifa
					
				else
					
					This.object.precio_unit			[row] = ldc_tarifa
					This.object.importe_igv			[row] = 0
					This.object.porc_igv				[row] = 0
					This.object.precio_vta			[row] = ldc_tarifa
					
				end if
				
				This.setColumn('cantidad')
	
			else
				MessageBox('Error', 'Opcion seleccionada no esta implementada, por favor verifique!', StopSign!)
				return 1
			end if
			
			return 2
		
		CASE 'flag_bolsa_plastico'
			if data = '1' then
				ld_Fec_emision = Date (dw_master.object.fec_registro [1])
				ldc_icbper = gnvo_app.of_get_icbper(ld_fec_emision)
			else
				ldc_icbper = 0.00
			end if
			
			this.object.icbper [row] = ldc_icbper
				
		CASE 'precio_unit'
			
			
			
			try 
				ldc_base_imponible = Dec(data)
				
				if ldc_base_imponible <> ldc_precio_unit_ant then
					
					if gnvo_app.of_get_parametro('VTA_VALIDAR_MODIFICAR_PRECIO', '0') = '1' then
						this.object.importe_igv	[row] = ldc_precio_unit_ant
						
						return 1
					end if
					
				end if
				
				//Obtengo el porcentaje de IGV
				if This.object.flag_afecto_igv	[row] = '1' then
					ldc_porc_igv	= Dec(this.object.porc_igv 	[row])	
				else
					ldc_porc_igv	= 0
				end if
				
				ldc_importe_igv			= ldc_base_imponible * ldc_porc_igv / 100
				
				this.object.importe_igv	[row] = ldc_importe_igv
				This.object.precio_vta	[row] = ldc_base_imponible + ldc_importe_igv
							
				return 1
			
			catch ( Exception ex2 )
				gnvo_app.of_catch_exception(ex2, 'Error al modificar el precio unitario')
			end try
			

	
		CASE 'precio_vta'
			
			ldc_precio_vta = Dec(data)
			
			//Obtengo el porcentaje de IGV
			if This.object.flag_afecto_igv	[row] = '1' then
				ldc_porc_igv	= Dec(this.object.porc_igv 	[row])	
			else
				ldc_porc_igv	= 0
			end if
			
			ldc_base_imponible			= ldc_precio_vta / (1 + ldc_porc_igv / 100 )
			
			this.object.importe_igv	[row] = ldc_precio_vta - ldc_base_imponible
			This.object.precio_unit	[row] = ldc_base_imponible
						
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

this.object.cantidad					[al_row] = 1
this.object.largo						[al_row] = 1
this.object.ancho						[al_row] = 1
this.object.total_und				[al_row] = 1
this.object.importe_igv				[al_row] = 0.00
this.object.precio_unit				[al_row] = 0.00
this.object.porc_igv					[al_row] = gnvo_app.finparam.idc_porc_igv

this.object.flag_autorizado		[al_row] = '0'
this.object.precio_vta_ant			[al_row] = 0.00
this.object.cant_facturada			[al_row] = 0.00

/*
a.precio_vta_unidad,
       a.precio_vta_mayor, 
       a.precio_vta_oferta,
       a.precio_vta_min,
*/
this.object.precio_vta_unidad		[al_row] = 0.00
this.object.precio_vta_mayor		[al_row] = 0.00
this.object.precio_vta_oferta		[al_row] = 0.00
this.object.precio_vta_min			[al_row] = 0.00


this.object.flag_bolsa_plastico	[al_row] = '0'
this.object.icbper					[al_row] = 0.00

//Inserto el almacen por defecto, segun el origen
ls_origen = dw_master.object.cod_origen [1]

if IsNull(ls_origen) or trim(ls_origen) = '' then
	MessageBox('Aviso', 'No se ha especificado el origen en la cabecera del COMPROBANTE, por favor verifique!', StopSign!)
	return
end if

select almacen
	into :ls_almacen
from almacen
where flag_estado <> '0'
  and cod_origen = :ls_origen
order by almacen;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe ningun almacén activo para el origen ' + ls_origen + ', por favor verifique!', StopSign!)
else
	this.object.almacen [al_row] = ls_almacen
end if


end event

event dw_detail::keydwn;call super::keydwn;if KeyDown( KeyControl! ) And KeyDown( KeyG! ) then
	this.AcceptText()
	
	parent.event ue_update()
	
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

type cb_grabar from commandbutton within w_ve326_proforma_popup
event keydown pbm_keydown
integer x = 3127
integer y = 248
integer width = 571
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
	
else
	
	parent.event keydown(key, keyflags)
	
end if

end event

event clicked;setPointer(HourGlass!)
parent.event ue_update( )
setPointer(Arrow!)
end event

type cb_salir from commandbutton within w_ve326_proforma_popup
integer x = 3127
integer y = 372
integer width = 571
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

type cb_bien from commandbutton within w_ve326_proforma_popup
integer x = 3127
integer width = 571
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

type cb_servicio from commandbutton within w_ve326_proforma_popup
integer x = 3127
integer y = 124
integer width = 571
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

