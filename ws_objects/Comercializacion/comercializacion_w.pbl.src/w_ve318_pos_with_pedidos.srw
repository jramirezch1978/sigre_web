$PBExportHeader$w_ve318_pos_with_pedidos.srw
forward
global type w_ve318_pos_with_pedidos from w_abc
end type
type st_registros from statictext within w_ve318_pos_with_pedidos
end type
type st_1 from statictext within w_ve318_pos_with_pedidos
end type
type cb_2 from commandbutton within w_ve318_pos_with_pedidos
end type
type cb_imprimir from commandbutton within w_ve318_pos_with_pedidos
end type
type cb_new_cliente from commandbutton within w_ve318_pos_with_pedidos
end type
type cb_1 from commandbutton within w_ve318_pos_with_pedidos
end type
type dw_master from u_dw_abc within w_ve318_pos_with_pedidos
end type
end forward

global type w_ve318_pos_with_pedidos from w_abc
integer width = 4581
integer height = 2552
string title = "[VE318] POS - Emisión de Comprobantes desde proformas"
string menuname = "m_only_filtro"
string icon = "Application5!"
event ue_editar ( long al_row )
event ue_facturar ( long al_row )
event ue_anular_row ( long al_row )
event ue_procesar ( )
st_registros st_registros
st_1 st_1
cb_2 cb_2
cb_imprimir cb_imprimir
cb_new_cliente cb_new_cliente
cb_1 cb_1
dw_master dw_master
end type
global w_ve318_pos_with_pedidos w_ve318_pos_with_pedidos

type prototypes

end prototypes

type variables
String is_salir
n_cst_wait			invo_wait
end variables

forward prototypes
public function integer of_get_param ()
public function boolean of_procesar_proforma (string as_nro_proforma, str_despacho astr_despacho)
end prototypes

event ue_editar(long al_row);String			ls_nro_proforma, ls_mensaje
Str_parametros	lstr_param

if al_row <= 0 then return

ls_nro_proforma = dw_master.object.nro_proforma [al_Row]

lstr_param.string1 = ls_nro_proforma

OpenWithParm(w_ve318_proforma_popup, lstr_param)

this.event ue_refresh( )



end event

event ue_facturar(long al_row);String			ls_nro_proforma, ls_mensaje
Str_parametros	lstr_param
w_ve318_factura_popup	lw_1
if al_row <= 0 then return

ls_nro_proforma = dw_master.object.nro_proforma [al_Row]

lstr_param.string1 = ''
lstr_param.string2 = ls_nro_proforma

OpenWithParm(lw_1, lstr_param)

this.event ue_refresh( )

end event

event ue_anular_row(long al_row);String	ls_nro_proforma, ls_mensaje

if al_row <= 0 then return

ls_nro_proforma = dw_master.object.nro_proforma [al_Row]

if MessageBox('Aviso', "Desea anular la proforma " + ls_nro_proforma &
		+ ". Tenga cuidado, una vez anulado el registro ya no se puede recuperar.", Information!, YesNo!, 2) = 2 then return
		

update proforma
   set flag_estado = '0'
where nro_proforma = :ls_nro_proforma;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox("Error", "No se ha podido anular la proforma " + ls_nro_proforma &
			+ ". Mensaje de Error: " + ls_mensaje, StopSign!)
	return
end if

commit;
this.event ue_refresh( )
MessageBox('Aviso', "Proforma " + ls_nro_proforma + " anulada satisfactoriamente.", Information!)

end event

event ue_procesar();Long				ll_row, ll_count
String			ls_flag_bol_fact
str_despacho 	lstr_despacho
str_parametros	lstr_param

ll_count = 0
ls_flag_bol_fact = ""
for ll_row = 1 to dw_master.RowCount()
	
	if dw_master.object.checked [ll_row] = '1' then
		
		if IsNull(dw_master.object.desc_zona_despacho [ll_row]) or trim(dw_master.object.desc_zona_despacho [ll_row]) = '' then
			ROLLBACK;
			MessageBox('Error', 'No se puede procesar la proforma ' + dw_master.object.checked [ll_row] &
							+ ', ya no se ha especificado la Zona de reparto, por favor verifique!', StopSign!)
			return
		end if
		
		if trim(ls_flag_bol_fact) = '' then
			
			ls_flag_bol_fact = dw_master.object.flag_factura_boleta [ll_row]
			
		elseif trim(ls_flag_bol_fact) <> trim(dw_master.object.flag_factura_boleta [ll_row]) then
			
			MessageBox('Error', 'No puede Seleccionar dos proformas que tengan tipos de Documentos Diferentes, por favor verifique!', StopSign!)
			return
			
		end if
		
		ll_count ++
	end if
next

if ll_count = 0 then
	ROLLBACK;
	MessageBox('Error', 'No ha seleccionado ninguna proforma para procesar, por favor verifique!', StopSign!)
	return
end if

lstr_param.string1 = ls_flag_bol_fact

OpenWithParm(w_datos_despacho, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_despacho = Message.PowerObjectParm

if not lstr_despacho.b_return then return

//Ahora proceso los registros marcados
ll_count = 0
for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.checked [ll_row] = '1' then
		if not of_procesar_proforma(dw_master.object.nro_proforma [ll_row], lstr_despacho) then
			ROLLBACK;
			exit
		end if
		ll_count ++
	end if
next

if ll_count > 0 then
	Commit;

	this.event ue_refresh()

	MessageBox('Error', 'Se han procesado ' + string(ll_count) + ' registros Satisfactoriamente', Information!)
	
end if

end event

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
//SELECT 	FS_PARAM.COD_MONEDA, moneda.DESCRIPCION, 
//			FS_PARAM.FORMA_PAGO, FORMA_PAGO.DESC_FORMA_PAGO,  
//			FS_PARAM.TIPO_IMPUESTO, IMPUESTOS_TIPO.DESC_IMPUESTO,   
//			FS_PARAM.MOTIVO_TRASLADO, MOTIVO_TRASLADO.DESCRIPCION,   
//			FS_PARAM.ALMACEN, ALMACEN.DESC_ALMACEN,   
//         FS_PARAM.PUNTO_VENTA, PUNTOS_VENTA.DESC_PTO_VTA,
//			FS_PARAM.FORMA_EMBARQUE, FORMA_EMBARQUE.DESCRIPCION
//   into 	:is_cod_moneda, :is_desc_moneda,
// 			:is_forma_pago, :is_desc_forma_pago,
//			:is_tipo_impuesto, :is_desc_impuesto,
//			:is_motivo_traslado, :is_desc_motivo,
//			:is_almacen, :is_desc_almacen,
//			:is_punto_venta, :is_desc_pto_vta,
//			:is_forma_embarque, :is_desc_forma_embarque         
//    FROM FS_PARAM,   
//         MONEDA,   
//         FORMA_PAGO,   
//         IMPUESTOS_TIPO,   
//         MOTIVO_TRASLADO,   
//         ALMACEN,   
//         PUNTOS_VENTA,   
//         FORMA_EMBARQUE  
//   WHERE moneda.cod_moneda (+) = fs_param.cod_moneda
//	  and forma_pago.forma_pago (+) = fs_param.forma_pago
//	  and impuestos_tipo.tipo_impuesto (+) = fs_param.tipo_impuesto
//	  and motivo_traslado.motivo_traslado (+) = fs_param.motivo_traslado
//	  and almacen.almacen (+) = fs_param.almacen
//	  and puntos_venta.punto_venta (+) = fs_param.punto_venta
//	  and forma_embarque.forma_embarque (+) = fs_param.forma_embarque
//	  and fs_param.cod_origen = :gs_origen;    
//
//
//if sqlca.sqlcode = 100 then
//	Messagebox( "Error", "no ha definido parametros en fs_param")
//	return 0
//end if
//
//if sqlca.sqlcode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	Messagebox( "Error", ls_mensaje)
//	return 0
//end if



return 1
end function

public function boolean of_procesar_proforma (string as_nro_proforma, str_despacho astr_despacho);string  	ls_mensaje, ls_nro_registro, ls_tipo_doc, ls_serie_cxc, ls_nro_cxc, &
			ls_email, ls_cliente
Boolean 	lb_send_email
Long		ll_rpta
integer 	li_ok

try 
	/*
	  -- Call the procedure
	  pkg_fact_electronica.sp_procesar_proforma(asi_nro_proforma => :asi_nro_proforma,
															  asi_serie_gr => :asi_serie_gr,
															  asi_serie_ce => :asi_serie_ce,
															  asi_prov_transp => :asi_prov_transp,
															  asi_nom_chofer => :asi_nom_chofer,
															  asi_motivo_traslado => :asi_motivo_traslado,
															  asi_nro_brevete => :asi_nro_brevete,
															  asi_nro_placa => :asi_nro_placa,
															  asi_nro_placa_carreta => :asi_nro_placa_carreta,
															  asi_marca_vehiculo => :asi_marca_vehiculo,
															  asi_cert_insc_mtc => :asi_cert_insc_mtc,
															  adi_fec_inicio_traslado => :adi_fec_inicio_traslado,
															  asi_observaciones => :asi_observaciones,
															  asi_usuario => :asi_usuario);
	*/
	
	DECLARE sp_procesar_proforma PROCEDURE FOR
		pkg_fact_electronica.sp_procesar_proforma( :as_nro_proforma,
																 :astr_despacho.serie_gr,
																 :astr_despacho.serie_ce,
																 :astr_despacho.prov_transporte,
																 :astr_despacho.nom_chofer,
																 :astr_despacho.motivo_traslado,
																 :astr_despacho.nro_brevete,
																 :astr_despacho.nro_placa,
																 :astr_despacho.nro_placa_carreta,
																 :astr_despacho.marca_vehiculo,
																 :astr_despacho.cert_insc_mtc,
																 :astr_despacho.fec_inicio_traslado,
																 :astr_despacho.obs,
																 :gs_user);
	
	EXECUTE sp_procesar_proforma;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE sp_procesar_proforma:" &
				  + SQLCA.SQLErrText
		Rollback;
		MessageBox('Aviso', ls_mensaje, StopSign!)
		Return false
	END IF
	
	COMMIT;
	
	//Obtengo el nro de registro de la factura simplificada
	select distinct
			 fd.nro_registro, f.tipo_doc_cxc, f.serie_cxc, f.nro_cxc
		into :ls_nro_registro, :ls_tipo_doc, :ls_serie_cxc, :ls_nro_cxc 
	from fs_factura_simpl_det fd,
		  fs_factura_simpl     f
	where f.nro_registro    = fd.nro_registro
	  and fd.nro_proforma   = :as_nro_proforma
	  and f.flag_estado		<> '0';
	
	if sQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al obtener los datos para enviar comprobante. Mensaje de Error: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	if SQLCA.SQlCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No existe un comprobante valido para la proforma ' &
					+ as_nro_proforma + '. Por favor verifique!', StopSign!)
		return false
	end if
	
	if IsNull(ls_serie_cxc) or trim(ls_serie_cxc) = '' or IsNull(ls_nro_cxc) or trim(ls_nro_cxc) = '' then
		
		if ISNull(ls_serie_cxc) then ls_serie_cxc = ''
		if ISNull(ls_nro_cxc) then ls_nro_cxc = ''
		
		ROLLBACK;
		MessageBox('Error', 'No se ha generado un documento valido para la ' &
					+ as_nro_proforma + '. Por favor verifique!' &
					+ '~r~nSerie: ' + ls_serie_cxc &
					+ '~r~nSerie: ' + ls_nro_cxc , StopSign!)
		return false
	end if
	
	//Imprimo el comprobante
	invo_wait.of_mensaje("Generando PDF para Comprobante " + ls_tipo_doc + "/" &
									+ ls_serie_cxc + "-" + ls_nro_cxc + ", por favor espere ... ")
	gnvo_app.ventas.of_create_only_pdf( ls_nro_registro ) 
	
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
	
	return true

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, 'Error al procesar proforma ' + as_nro_proforma)
	return false
	
finally
	invo_wait.of_close()
end try


end function

on w_ve318_pos_with_pedidos.create
int iCurrent
call super::create
if this.MenuName = "m_only_filtro" then this.MenuID = create m_only_filtro
this.st_registros=create st_registros
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_imprimir=create cb_imprimir
this.cb_new_cliente=create cb_new_cliente
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_registros
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_imprimir
this.Control[iCurrent+5]=this.cb_new_cliente
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_master
end on

on w_ve318_pos_with_pedidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_registros)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_imprimir)
destroy(this.cb_new_cliente)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

invo_wait = create n_cst_wait

if upper(gs_empresa) = 'VITAL_SAC' or upper(gs_empresa) = 'OCEAN_SRL' or upper(gs_empresa) = 'GACELA_SAC' then
	dw_master.DataObject = 'd_lista_proformas_pendientes_tbl'
else

	if upper(gs_empresa) = 'CROMOPLASTIC' or upper(gs_empresa) = 'FLORES' then
		dw_master.DataObject = 'd_lista_proformas_pendientes2_tbl'
	else
		dw_master.DataObject = 'd_lista_proformas_pendientes_tbl'
	end if

end if

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

this.event ue_refresh()

end event

event ue_insert;call super::ue_insert;//Long    ll_row,ll_row_master,ll_count
//String  ls_timpuesto,ls_almacen
//Boolean lb_ret  = false
//
//IF idw_1 = dw_detail THEN
//	//verificar datos de la cabecera
//	ll_row_master = dw_master.Getrow ()
//	
//	if ll_row_master = 0 or is_accion = 'fileopen' then return
//	
//	ls_timpuesto = dw_master.object.tipo_impuesto [ll_row_master]
//	ls_almacen	 = dw_master.object.almacen	    [ll_row_master]
//		
//	IF Isnull(ls_timpuesto) OR Trim(ls_timpuesto) = '' THEN
//		Messagebox('Aviso','Debe Ingresar Tipo de Impuesto ,Verifique!')
//		Return
//	END IF
//	
//	select count(*) into :ll_count from almacen_tipo_mov 
//	 where (almacen  = :ls_almacen ) and
//	 		 (tipo_mov = :is_tipo_mov) ;
//	
//	if ll_count = 0 then
//		Messagebox('Aviso','Almacen no tiene tipo de movimiento de venta a Terceros')
//		Return
//	end if
//ELSE
//	lb_ret = true
//	/*recupera datos*/
//	String   ls_cod_relacion    ,ls_tipo_impuesto ,&
//				ls_forma_pago	    ,ls_cod_moneda	  ,ls_forma_embarque,&
//				ls_motivo_traslado ,ls_destinatario	  ,ls_punto_partida ,&
//				ls_nom_vendedor	 ,ls_obs
//	Decimal {3} ldc_tasa_cambio
//	Long     ll_item_direccion
//	Datetime ldt_fecha_registro
//	
//	//verificar datos de la cabecera
//	ll_row_master = dw_master.Getrow ()
//
//	if ll_row_master > 0 then
//		ls_cod_relacion    = dw_master.object.cod_relacion    [ll_row_master]
//		ll_item_direccion  = dw_master.object.item_direccion  [ll_row_master]
//		ldt_fecha_registro = dw_master.object.fecha_registro  [ll_row_master]
//		ls_tipo_impuesto	 = dw_master.object.tipo_impuesto   [ll_row_master]
//		ls_almacen			 = dw_master.object.almacen		   [ll_row_master]
//		ls_forma_pago		 = dw_master.object.forma_pago	   [ll_row_master]
//		ls_cod_moneda		 = dw_master.object.cod_moneda	   [ll_row_master]
//		ldc_tasa_cambio	 = dw_master.object.tasa_cambio	   [ll_row_master]
//		ls_forma_embarque  = dw_master.object.forma_embarque  [ll_row_master]
//		ls_motivo_traslado = dw_master.object.motivo_traslado [ll_row_master]
//		ls_destinatario	 = dw_master.object.destinatario    [ll_row_master]
//		ls_punto_partida	 = dw_master.object.punto_partida	[ll_row_master]
//		ls_nom_vendedor	 = dw_master.object.nom_vendedor  	[ll_row_master]
//		ls_obs				 = dw_master.object.observacion		[ll_row_master]
//	end if
//	
//	dw_master.Reset()
//	dw_detail.Reset()
//	ids_cntas_cobrar_cab.Reset()
//	ids_cntas_cobrar_det.Reset()
//	ids_impuesto_det.Reset()	
//	ids_data_glosa.Reset()
//	ids_data_ref.Reset()
//	
//	is_accion = 'new'
//	rb_1.enabled = true
//	rb_2.enabled = true
//END IF
//
//ll_row = idw_1.Event ue_insert()
//
//IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
//
//	/*si exista registro copia los datos de cabecera*/
//	if cbx_copiar.checked = true and lb_ret = true then
//		dw_master.object.cod_relacion    [ll_row] = ls_cod_relacion
//		dw_master.object.item_direccion  [ll_row] = ll_item_direccion
//		dw_master.object.fecha_registro  [ll_row] = ldt_fecha_registro
//		dw_master.object.tipo_impuesto   [ll_row] = ls_tipo_impuesto
//		dw_master.object.almacen		   [ll_row] = ls_almacen
//		dw_master.object.forma_pago	   [ll_row] = ls_forma_pago
//		dw_master.object.cod_moneda	   [ll_row] = ls_cod_moneda
//		dw_master.object.tasa_cambio	   [ll_row] = ldc_tasa_cambio
//	   dw_master.object.forma_embarque  [ll_row] = ls_forma_embarque
//		dw_master.object.motivo_traslado [ll_row] = ls_motivo_traslado
//		dw_master.object.destinatario    [ll_row] = ls_destinatario
//		dw_master.object.punto_partida	[ll_row] = ls_punto_partida
//		dw_master.object.nom_vendedor  	[ll_row] = ls_nom_vendedor
//		dw_master.object.observacion		[ll_row] = ls_obs
//	end if
//
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_delete;//OVERRIDE
if is_action = 'fileopen' OR idw_1 = dw_master then return

Long  ll_row


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
	
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_refresh;call super::ue_refresh;dw_master.Retrieve( )

st_registros.text = string(dw_master.RowCount(), '###,##0')


end event

event close;call super::close;destroy invo_wait
end event

event ue_filter_avanzado;//Override
if Not IsNull(idw_1) and IsValid(idw_1) then
	IF idw_1.is_dwform = 'tabular' THEN	
		idw_1.Event ue_filter_avanzado()
	end if
end if

if Not IsNull(idw_query) and IsValid(idw_query) then
	idw_query.Event ue_filter_avanzado()
end if


st_registros.text = string(dw_master.RowCount(), '###,##0')
end event

event ue_filter;//Override
if Not IsNull(idw_1) and IsValid(idw_1) then
	IF idw_1.is_dwform = 'tabular' THEN	
		idw_1.Event ue_filter()
	end if
end if

if Not IsNull(idw_query) and IsValid(idw_query) then
	idw_query.Event ue_filter()
end if

st_registros.text = string(dw_master.RowCount(), '###,##0')
end event

type st_registros from statictext within w_ve318_pos_with_pedidos
integer x = 3291
integer y = 24
integer width = 521
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "0.00"
boolean focusrectangle = false
end type

type st_1 from statictext within w_ve318_pos_with_pedidos
integer x = 2752
integer y = 24
integer width = 535
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro de Registros:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ve318_pos_with_pedidos
integer x = 1824
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ruta OV - GR - VS"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_procesar()
setPointer(Arrow!)






end event

type cb_imprimir from commandbutton within w_ve318_pos_with_pedidos
integer x = 1216
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir Comprobante"
end type

event clicked;Opensheet(w_ve319_imprimir_tickets, w_main, 0, Layered!)





end event

type cb_new_cliente from commandbutton within w_ve318_pos_with_pedidos
integer x = 608
integer width = 603
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Nuevo Cliente"
end type

event clicked;Str_parametros lstr_param

OpenWithParm(w_add_cliente, lstr_param)





end event

type cb_1 from commandbutton within w_ve318_pos_with_pedidos
integer width = 603
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refrescar"
end type

event clicked;parent.event ue_refresh( )
end event

type dw_master from u_dw_abc within w_ve318_pos_with_pedidos
integer y = 116
integer width = 4475
integer height = 1848
string dataobject = "d_lista_proformas_pendientes_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;//IF Getrow() = 0 THEN Return
//String     ls_name    ,ls_prot ,ls_cod_relacion,ls_estado,ls_distrito,ls_direccion,&
//			  ls_tipo_doc
//str_seleccionar lstr_seleccionar
//str_parametros sl_param
//
//Datawindow		 ldw	
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//
//CHOOSE CASE dwo.name
//		 CASE 'nro_serie_doc'
//			   
//				if rb_1.checked then
//					ls_tipo_doc = is_doc_fac
//				elseif rb_2.checked then
//					ls_tipo_doc = is_doc_bvc
//				end if
//			 
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC AS DOCUMENTO ,'&
//								      				 +'DOC_TIPO_USUARIO.NRO_SERIE AS SERIE '&
//									   				 +'FROM DOC_TIPO_USUARIO '&
//														 +'WHERE DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user     +"' AND "&
//														 		 +'DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+ls_tipo_doc +"'"
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'nro_serie_doc',lstr_seleccionar.paramdc2[1])
//					ii_update = 1
//				END IF																  
//																  
//			
//		 CASE 'nro_serie_guia'	
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO_USUARIO.TIPO_DOC AS DOCUMENTO ,'&
//								      				 +'DOC_TIPO_USUARIO.NRO_SERIE AS SERIE '&
//									   				 +'FROM DOC_TIPO_USUARIO '&
//														 +'WHERE DOC_TIPO_USUARIO.COD_USR  = '+"'"+gs_user     +"' AND "&
//														 		 +'DOC_TIPO_USUARIO.TIPO_DOC = '+"'"+is_doc_gr +"'"
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'nro_serie_guia',lstr_seleccionar.paramdc2[1])
//					ii_update = 1
//				END IF	
//				
//		 CASE 'cod_relacion'
//
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO_PROVEEDOR, '&
//								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES, '&
//								   					 +'PROVEEDOR.EMAIL AS EMAIL, '&
//														 +'PROVEEDOR.RUC AS R_U_C '&
//									   				 +'FROM PROVEEDOR '&
//														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"
//
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_crelacion',lstr_seleccionar.param2[1])
//					
//					Setitem(row,'comp_final',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_comp_final',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//		
//		 CASE 'comp_final'
//
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
//								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
//								   					 +'PROVEEDOR.EMAIL			AS EMAIL ,'&
//														 +'PROVEEDOR.RUC			   AS R_U_C '&
//									   				 +'FROM PROVEEDOR '&
//														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"
//
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'comp_final',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_comp_final',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//		
//		 CASE 'item_direccion'					
//			
//				ls_cod_relacion = dw_master.object.cod_relacion [row]		
//				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
//					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
//					Return 1
//				END IF
//				
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT DIRECCIONES.ITEM             AS ITEM, '&        
//						 								 +'DIRECCIONES.DIR_PAIS         AS PAIS, '&     
//						 								 +'DIRECCIONES.DIR_DEP_ESTADO   AS DEPARTAMENTO, '&
//						 								 +'DIRECCIONES.DIR_DISTRITO     AS DISTRITO , '&
//						 								 +'DIRECCIONES.DIR_URBANIZACION AS URBANIZACION, '&
//						 								 +'DIRECCIONES.DIR_DIRECCION    AS DIRECCION, '&
//						 							    +'DIRECCIONES.DIR_MNZ          AS MANZANA, '&
//						 								 +'DIRECCIONES.DIR_LOTE         AS LOTE, '&
//						 								 +'DIRECCIONES.DIR_NUMERO       AS NUMERO, '&
//						 								 +'DIRECCIONES.DESCRIPCION      AS DESCRIPCION '&
//				  		 								 +'FROM DIRECCIONES '&
//				 		 								 +'WHERE DIRECCIONES.CODIGO = '+"'"+ls_cod_relacion+"' AND "&
//														 +'	   DIRECCIONES.FLAG_USO = '+"'"+'1'+"'"								
//															
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					This.Object.item_direccion [row] = Integer(lstr_seleccionar.paramdc1[1])
//					ls_estado	 = lstr_seleccionar.param3[1]
//					ls_distrito  = lstr_seleccionar.param4[1]					
//					ls_direccion = lstr_seleccionar.param6[1]
//
//					IF Isnull(ls_estado)    THEN ls_estado 	= ''
//					IF Isnull(ls_distrito)  THEN ls_distrito 	= ''					
//					IF Isnull(ls_direccion) THEN ls_direccion	= ''		
//
//					This.Object.desc_direccion [row] = ls_estado+' '+ls_distrito+' '+ls_direccion
//					ii_update = 1
//					
//				END IF
//															
//		 CASE 'cod_moneda'
//				
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA  AS CODIGO_MONEDA ,'&
//								      				 +'MONEDA.DESCRIPCION AS DESCRIPCION_MON '&
//									   				 +'FROM MONEDA '
//
//
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_moneda',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_moneda',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//
//		 CASE 'motivo_traslado'		 						  
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT MOTIVO_TRASLADO.MOTIVO_TRASLADO AS CODIGO ,'&
//												 		 +'MOTIVO_TRASLADO.DESCRIPCION	  AS DESCRIP_MOTIVO_TRAS '&
//														 +'FROM MOTIVO_TRASLADO '
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'motivo_traslado',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_motivo',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//				
//		 CASE 'punto_venta'		 						  
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT punto_venta AS CODIGO ,'&
//												 		 +'desc_pto_vta AS DESCRIPcion '&
//														 +'FROM puntos_venta ' &
//														 + "where flag_estado = '1'"
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'punto_venta',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_punto_venta',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//
//		case	'almacen'
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT ALMACEN.ALMACEN      AS CODIGO ,'&
//														 +'ALMACEN.DESC_ALMACEN AS DESCRIPCION ,'&
//														 +'ALMACEN.Direccion	AS direccion '&
//														 +'FROM ALMACEN '&
//														 +'WHERE ALMACEN.FLAG_ESTADO = '+"'"+'1'+"'"+' AND '&
//				 		                               +'ALMACEN.COD_ORIGEN  = '+"'"+gs_origen+"'"
//														 
//		      OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'almacen',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_almacen',lstr_seleccionar.param2[1])
//					Setitem(row,'punto_partida',lstr_seleccionar.param3[1])
//					ii_update = 1
//				END IF
//				
//		CASE 'vendedor'
//			
//				sl_param.dw1 = "d_lista_vendedor"
//				sl_param.titulo = "Vendedores"
//				sl_param.field_ret_i[1] = 1
//				sl_param.field_ret_i[2] = 2
//				sl_param.tipo = ''
//				
//				OpenWithParm( w_lista, sl_param)		
//				
//				sl_param = MESSAGE.POWEROBJECTPARM
//				
//				if sl_param.titulo <> 'n' then	
//					Setitem(row,'vendedor',sl_param.field_ret[1])
//					Setitem(row,'nom_vendedor',sl_param.field_ret[2])
//					ii_update = 1
//				END IF
//
//END CHOOSE
//
end event

event itemchanged;call super::itemchanged;//Long    ll_count,ll_nro_serie_doc,ll_null
//String  ls_desc_data     ,ls_null         ,ls_cod_relacion ,ls_dir_dep_estado , &
//        ls_dir_distrito	,ls_dir_direccion ,ls_tipo_doc	  , ls_nom_vendedor
//Integer li_num_dir
//
//Accepttext()
//
//SetNull(ls_null)
//SetNull(ll_null)
//
//choose case dwo.name
//		 case 'nro_serie_doc'
//				ll_nro_serie_doc = Long(data) 
//				
//				if rb_1.checked then
//					ls_tipo_doc = is_doc_fac
//				elseif rb_2.checked then
//					ls_tipo_doc = is_doc_bvc
//				end if	
//				
//				
//				select count(*) into :ll_count 
//				  from doc_tipo_usuario 
//				 where (cod_usr   = :gs_user          ) and
//					    (tipo_doc  = :ls_tipo_doc      ) and
//						 (nro_serie	= :ll_nro_serie_doc ) ;
//						 
//			  if ll_count = 0 then
//				  Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
//				  this.object.nro_serie_doc [row] = ll_null
//				  Return 1
//			  end if 
//				
//		 case 'nro_serie_guia'
//				ll_nro_serie_doc = Long(data) 
//				
//				select count(*) into :ll_count 
//				  from doc_tipo_usuario 
//				 where (cod_usr   = :gs_user          ) and
//					    (tipo_doc  = :is_doc_gr        ) and
//						 (nro_serie	= :ll_nro_serie_doc ) ;
//						 
//			   if ll_count = 0 then
//				   Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
//				   this.object.nro_serie_guia [row] = ll_null
//				   Return 1
//			   end if 
//			  
//		
//		 case 'cod_relacion'
//
//				select p.nom_proveedor into :ls_desc_data
//				  from proveedor p
//				 where (p.proveedor   = :data ) and
//				       (p.flag_estado = '1'   ) ;
//				
//				
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de Relacion no Existe')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					This.object.cod_relacion   [row] = ls_null
//					This.Object.desc_crelacion [row] = ls_null
//			      RETURN 1
//			  end if
//			
//
//  			  This.Object.desc_crelacion  [row] = ls_desc_data
//		     This.Object.comp_final 		[row] = data
//			  This.Object.desc_comp_final [row] = ls_desc_data
//		 
//		 case 'comp_final'
//
//				select p.nom_proveedor into :ls_desc_data
//				  from proveedor p
//				 where (p.proveedor   = :data ) and
//				       (p.flag_estado = '1'   ) ;
//				
//				
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de Relacion no Existe')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					This.object.comp_final      [row] = ls_null
//					This.Object.desc_comp_final [row] = ls_null
//			      RETURN 1
//			  end if
//			
//
//  			  This.Object.desc_comp_final [row] = ls_desc_data
//						  
//		 case 'item_direccion'
//			
//				ls_cod_relacion = dw_master.object.cod_relacion [row]		
//				
//				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
//					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
//					Return 1
//				END IF
//
//				/**/
//				li_num_dir = Integer(data)
//				/**/
//				
//
//				SELECT Nvl(dir_dep_estado,' ') ,Nvl(dir_distrito,' ')   ,
//					 	 Nvl(dir_direccion,' ')  
//				  INTO :ls_dir_dep_estado ,:ls_dir_distrito	  ,	
//						 :ls_dir_direccion 		
//				  FROM direcciones
//				 WHERE (codigo = :ls_cod_relacion) AND
//				 		 (item	= :li_num_dir     ) AND
//						 (flag_uso = '1'           ) ;
//						  
//
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
// 					  Messagebox('Aviso','Direccion No Existe , Verifique!')				
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					Setnull(li_num_dir)
//					This.Object.item_direccion [row] = li_num_dir
//					This.Object.desc_direccion [row] = ls_null
//			      RETURN 1
//			  end if
//
//			  This.Object.desc_direccion [row] = Trim(ls_dir_dep_estado)+' '+Trim(ls_dir_distrito)+' '+Trim(ls_dir_direccion)	 
//				
//		 case 'cod_moneda'
//			
//				select descripcion
//			     into :ls_desc_data
//			     from moneda
//				 where (cod_moneda = :data) ;	
//					
//		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			      if SQLCA.SQLCode = 100 then
//						Messagebox('Aviso','Moneda No Existe , Verifique!')				
//			      else
//				      MessageBox('Aviso', SQLCA.SQLErrText)
//			      end if
//				  
//					This.Object.cod_moneda  [row] = ls_null
//					This.Object.desc_moneda [row] = ls_null
//			      RETURN 1
//			   end if
//
//			   This.Object.desc_moneda [row] = ls_desc_data
//				
//				
//		 case 'motivo_traslado'   				
//				
//				select descripcion 
//				  into :ls_desc_data
//				  from motivo_traslado mt
//				 where (mt.motivo_traslado = :data) ;
//					 
//		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			      if SQLCA.SQLCode = 100 then
//						Messagebox('Aviso','Motivo de Traslado No Existe , Verifique!')				
//			      else
//				      MessageBox('Aviso', SQLCA.SQLErrText)
//			      end if
//				  
//					This.Object.motivo_traslado [row] = ls_null
//					This.Object.desc_motivo     [row] = ls_null
//			      RETURN 1
//			   end if
//
//				This.Object.desc_motivo     [row] = ls_desc_data 
//				
//				
//				
//				
//		 case	'almacen'	
//				
//				select desc_almacen 
//			     into :ls_desc_data
//		        from almacen
//   	       where (almacen     = :data      ) and
//				       (flag_estado = '1'        ) and
//						 (cod_origen  = :gs_origen ) ; 
//		  
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de almacen no existe, ' &
//					             + 'no esta activo o no le corresponde a su origen ')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//			     this.Object.almacen	 	[row] = ls_null
//			     this.object.desc_almacen [row] = ls_null
//			     RETURN 1
//			  end if
//			
//		     this.object.desc_almacen [row] = ls_desc_data
//				
//
//		CASE 'vendedor'
//			
//				select nvl(u.nombre,'')
//				  into :ls_nom_vendedor
//				  from vendedor v, usuario u
//				 where v.vendedor = u.cod_usr
//				   and v.vendedor = :data;
//				
//				if ls_nom_vendedor = '' then
//					messagebox('Aviso','Codigo de Vendedor no existe, Verifique!')
//					setnull(ls_nom_vendedor)
//					this.object.vendedor[row] = ls_nom_Vendedor
//					this.object.nom_vendedor[row] = ls_nom_vendedor
//					return 1
//				end if
//				
//				this.object.nom_vendedor[row] = ls_nom_vendedor
//
//end choose
//
end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;Long		ll_row
String 	ls_checked, ls_desc_zona_despacho

choose case lower(dwo.name)
	case "b_checkmark"
		for ll_row = 1 to dw_master.RowCount()
			ls_checked 					= this.object.checked 				[ll_row]
			ls_desc_zona_despacho	= this.object.desc_zona_despacho [ll_row]
			
			if IsNull(ls_desc_zona_despacho) or trim(ls_desc_zona_despacho) = '' then
				ls_checked = '0'
			else
				if ls_checked = '1' then
					ls_checked = '0'
				else
					ls_checked = '1'
				end if
			end if
			
			this.object.checked [ll_row] = ls_checked
		next
		
	case "b_anular"
		parent.event ue_anular_row( row )
		
	case "b_editar"
		parent.event ue_editar( row )
		
	case "b_facturar"
		try 
			if gnvo_app.of_get_parametro("VTA_GEN_FACTURACION_SIMPLIFICADA", "1") = "0" then
				MessageBox('Error', 'No tiene Activo la opcion para Facturación Simplificada, Verifique!', StopSign!)
				return
			end if
			
			parent.event ue_facturar( row )
			
		catch ( Exception ex )
			gnvo_app.of_catch_exception(ex, 'Error en evento b_facturar.click()')

		end try
		
		
end choose

end event

event clicked;call super::clicked;IF Getrow() = 0 THEN Return

this.AcceptText()

CHOOSE CASE dwo.name
	CASE 'check'
		if this.object.checked [row] = '1' then
			this.object.checked [row] = '0'
		else
			if IsNull(this.object.desc_zona_despacho[row]) or trim(this.object.desc_zona_despacho[row]) = '' then
				MessageBox('Error', 'No puede seleccionar la proforma porque el Cliente no tiene asignado la Zona de DESPACHO, Verifique!', StopSign!)
				return
			end if
			
			this.object.checked [row] = '1'
		end if
																  
			
END CHOOSE

end event

event ue_post_filter;call super::ue_post_filter;st_registros.text = string(dw_master.RowCount(), '###,##0')
end event

