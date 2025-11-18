$PBExportHeader$w_ve318_proforma_popup.srw
forward
global type w_ve318_proforma_popup from w_abc_mastdet_smpl
end type
type cb_salir from commandbutton within w_ve318_proforma_popup
end type
end forward

global type w_ve318_proforma_popup from w_abc_mastdet_smpl
integer width = 3849
integer height = 2516
string title = "[]"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_salir cb_salir
end type
global w_ve318_proforma_popup w_ve318_proforma_popup

type variables

end variables

on w_ve318_proforma_popup.create
int iCurrent
call super::create
this.cb_salir=create cb_salir
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_salir
end on

on w_ve318_proforma_popup.destroy
call super::destroy
destroy(this.cb_salir)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros		lstr_param

if upper(gs_empresa) = 'CROMOPLASTIC' or upper(gs_empresa) = 'FLORES' then
	dw_detail.DataObject= 'd_abc_proforma_det2_tbl'
else
	dw_detail.DataObject= 'd_abc_proforma_det_tbl'
end if
dw_detail.setTRansobject( SQLCA )

lstr_param = Message.powerObjectparm

dw_master.Retrieve( lstr_param.string1)

if dw_master.RowCount( ) = 0 then
	MessageBox("Error", "No existen datos para la proforma " + lstr_param.string1 + ".", StopSign!)
	return
end if

dw_detail.Retrieve( lstr_param.string1)

ii_lec_mst = 0 

this.Title = "[VE318] Numero de Proforma " + lstr_param.string1

dw_master.ii_protect = 1
dw_master.of_protect( )

dw_detail.ii_protect = 1
dw_detail.of_protect( )




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
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf
Str_parametros	lstr_param

ls_crlf = char(13) + char(10)
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
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	lstr_param.b_return = true
	CloseWithReturn(this, lstr_param)
	
END IF

end event

event closequery;//Override
THIS.Event ue_close_pre()
Destroy	im_1

of_close_sheet()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ve318_proforma_popup
integer x = 0
integer y = 0
integer width = 3191
integer height = 1004
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

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "vendedor"

		ls_sql = "select t.cod_usr as codigo_vendedor, " &
				 + "t.nombre as nombre_vendedor " &
				 + "from usuario t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.vendedor	[al_row] = ls_codigo
			this.object.nom_vendedor	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

Accepttext()
CHOOSE CASE dwo.name
	CASE 'vendedor'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from usuario
		 Where cod_usr = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Vendedor no existe o no se encuentra activo, por favor verifique")
			this.object.vendedor			[row] = gnvo_app.is_null
			this.object.nom_vendedor	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_vendedor		[row] = ls_desc

END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ve318_proforma_popup
integer x = 0
integer y = 1016
integer width = 3534
integer height = 1356
string dataobject = "d_abc_proforma_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 1				// columnas de lectrua de este dw

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
string 			ls_codigo, ls_data, ls_sql, ls_almacen, ls_und, ls_flag_factura_bol, &
					ls_tipo_doc, ls_flag_bolsa_plastica, ls_flag_afecto_igv, ls_moneda_cab, &
					ls_mensaje
Decimal			ldc_cantidad, ldc_icbper, ldc_precio_vta, ldc_tasa_cambio, ldc_porc_igv, &
					ldc_base_imponible
Date				ld_fec_emision
Blob				lbl_imagen
str_Articulo	lstr_articulo

try 
	choose case lower(as_columna)
		case "almacen"
			ls_sql = "select a.almacen as almacen, " &
					 + "a.desc_almacen as descripcion_almacen " &
					 + "from almacen a " &
					 + "where a.flag_estado = '1'"
	
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> '' then
				this.object.almacen			[al_row] = ls_codigo
				this.object.desc_almacen	[al_row] = ls_data
				
				//Debe Elegir nuevo articulo
				this.object.cod_art	[al_row] = gnvo_app.is_null
				this.object.desc_art	[al_row] = gnvo_app.is_null
				this.object.und		[al_row] = gnvo_app.is_null
	
				this.ii_update = 1
			end if
			
		case "cod_art"
			
			//Obtengo el almacen
			ls_almacen 		= this.object.almacen [al_row]
			
			if IsNull(ls_almacen) or ls_almacen = '' then
				MessageBox('Aviso', "Debe seleccionar el almacén primero, por favor verifique!", StopSign!)
				this.SetColumn( "almacen" )
				return
			end if
			
			ls_flag_factura_bol 	= dw_master.object.flag_factura_boleta [1]
			ls_moneda_cab			= dw_master.object.cod_moneda			 	[1]
			ldc_tasa_cambio		= Dec(dw_master.object.tasa_cambio		[1])
			
			if ls_flag_factura_bol = 'F' then
				ls_tipo_doc = 'FAC'
			elseif ls_flag_factura_bol = 'B' then
				ls_tipo_doc = 'BVC'
			else
				ls_tipo_doc = 'NVC'
			end if
			
			//Si es un bien entonces lo primero obtengo la fecha de emision
			ld_fec_emision = Date(dw_master.object.fec_registro [1])
			
			//Obtengo la cantidad proyectada por defecto
			ldc_cantidad = gnvo_app.of_get_parametro("CANTIDAD_DEFAULT", 1.00)
			
			lstr_articulo = gnvo_app.almacen.of_get_articulo_venta( ls_almacen, ls_tipo_doc )
	
			if lstr_articulo.b_Return then
				
				//Obtengo la imagen del producto
				selectBLOB imagen 
					into :lbl_imagen 
				from articulo 
				where cod_art = :lstr_articulo.cod_art;
				
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
				where cod_art = :lstr_articulo.cod_art;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error', 'No se puede obtener el flag_afecto_IGV del articulo ' &
											+ lstr_articulo.cod_art &
											+ '.Mensaje de Error: ' + ls_mensaje, StopSign!)
					return
				end if
				
				this.object.cod_art					[al_row] = lstr_articulo.cod_art
				this.object.codigo					[al_row] = lstr_articulo.cod_art
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
				This.object.cantidad					[al_row] = ldc_cantidad
				
				//Si tiene precio de oferta, entonces tomo el precio de oferta, sino de lo contrario
				//tomo el precio unitario si la cantidad es menor a tres
				if lstr_articulo.precio_vta_oferta > 0 then
					
					ldc_precio_vta = lstr_articulo.precio_vta_oferta
					
				elseif ldc_cantidad >= gnvo_app.of_get_parametro("VTA_CANTIDAD_MAYORISTA", 3) &
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
	end choose

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error o exception')

end try


end event

event dw_detail::itemchanged;call super::itemchanged;Decimal 	ldc_tasa, ldc_igv, ldc_precio_vta, ldc_icbper
Date		ld_fec_emision

try 
	this.Accepttext()
	
	CHOOSE CASE dwo.name
		CASE 'precio_vta'
			
			ldc_precio_vta = Dec(this.object.precio_vta [row])
			ldc_tasa 		= Dec(this.object.porc_igv [row])
			
			ldc_igv			= ldc_precio_vta * ldc_tasa / 100
			
			this.object.importe_igv	[row] = ldc_igv
			

	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')

end try




end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.flag_bolsa_plastica	[al_row] = '0'
this.object.icbper					[al_row] = 0.00
end event

type cb_salir from commandbutton within w_ve318_proforma_popup
integer x = 3195
integer y = 16
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
string text = "Cerrar"
end type

event clicked;parent.event ue_cancelar( )
end event

