$PBExportHeader$w_ve323_registro_vales_descuento.srw
forward
global type w_ve323_registro_vales_descuento from w_abc_mastdet_smpl
end type
type uo_search from n_cst_search within w_ve323_registro_vales_descuento
end type
end forward

global type w_ve323_registro_vales_descuento from w_abc_mastdet_smpl
integer width = 3237
integer height = 2356
string title = "[VE323] Registro de Vales de Descuento"
string menuname = "m_mantenimiento_sl"
uo_search uo_search
end type
global w_ve323_registro_vales_descuento w_ve323_registro_vales_descuento

forward prototypes
public function integer of_set_numera ()
end prototypes

public function integer of_set_numera ();//Numero los documentos
Long 				ll_ult_nro, ll_i
string			ls_mensaje, ls_nro, ls_nro_vale, ls_tabla, ls_origen
dwItemStatus 	lis_status


ls_tabla = 'ZC_VALES_DESCUENTO'

for ll_i = 1 to dw_detail.RowCount()
	
	lis_status 	= dw_detail.GetItemStatus(ll_i, 0, Primary!)
	ls_nro_vale	= dw_detail.object.nro_vale_vd[ll_i]
	ls_origen	= dw_detail.object.cod_origen	[ll_i]
	
	if lis_status = New! or lis_status = NewModified!	&
		or IsNull(ls_nro_Vale) or trim(ls_nro_Vale) = ''  then
	
		Select ult_nro 
			into :ll_ult_nro 
		from num_tablas
		where tabla		= :ls_tabla
		  and origen 	= :ls_origen for update;
		
		IF SQLCA.SQLCode = 100 then
			ll_ult_nro = 1
			
			Insert into num_tablas (tabla, origen, ult_nro)
				values( :ls_tabla, :ls_origen, 1);
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Ha ocurrido un error al insertar registro en num_tablas: ' + ls_mensaje, StopSign!)
				return 0
			end if
		end if
		
		//Asigna numero a cabecera
		ls_nro = TRIM( ls_origen) + trim(string(ll_ult_nro, '00000000'))
		
		dw_detail.object.nro_vale_vd[ll_i] = ls_nro
		
		//Incrementa contador
		Update num_tablas 
			set ult_nro = :ll_ult_nro + 1 
		where tabla		= :ls_tabla
		  and origen 	= :ls_origen;
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al actualizar la tabla num_tablas: ' + ls_mensaje, stopSign!)
			return 0
		end if
			
	end if
	
next


return 1
end function

on w_ve323_registro_vales_descuento.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
end on

on w_ve323_registro_vales_descuento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
end on

event ue_insert;//Override
Long  ll_row

IF idw_1 = dw_master THEN
	MessageBox("Error", "No esta permitido añadir registros en el maestro", StopSign!)
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then	return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_update;//Override
Boolean 	lbo_ok = TRUE
String	ls_msg, ls_crlf
Long		ll_row

ls_crlf = char(13) + char(10)
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
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
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	
	dw_detail.ResetUpdate()
	
	ll_row = dw_master.GetRow()
	
	dw_master.Retrieve()
	
	dw_master.setRow(ll_row)
	dw_master.ScrollToRow(ll_row)
	dw_master.SelectRow(0, False)
	dw_master.SelectRow(ll_row, true)
	
	dw_master.event ue_output(ll_row)
	
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_delete;//Override
Long  ll_row

if idw_1 = dw_master then
	MessageBox("Error", "No esta permitido esta operación en este panel", StopSign!)
	return 
end if

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event resize;call super::resize;uo_search.event ue_resize(sizetype, uo_search.width, newheight)
end event

event ue_open_pre;call super::ue_open_pre;uo_search.of_set_dw(dw_master)

uo_search.set_focus_dw( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ve323_registro_vales_descuento
integer x = 0
integer y = 96
integer width = 3154
integer height = 1236
string dataobject = "d_lista_comprobantes_vd_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;String ls_tipo_doc, ls_nro_doc

if al_row = 0 then return

ls_tipo_doc = this.object.tipo_doc 	[al_row]
ls_nro_doc  = this.object.nro_doc	[al_Row]

dw_detail.Retrieve(ls_tipo_doc, ls_nro_doc)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ve323_registro_vales_descuento
integer x = 0
integer y = 1348
integer width = 1989
integer height = 804
string dataobject = "d_abc_vales_descuento_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 3
ii_rk[2] = 4

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;String ls_tipo_doc, ls_nro_doc

if dw_master.GetRow() = 0 then return

ls_tipo_doc = dw_master.object.tipo_doc 	[dw_master.getRow()]
ls_nro_doc 	= dw_master.object.nro_doc 	[dw_master.getRow()]

this.object.tipo_doc			[al_row] = ls_tipo_doc
this.object.nro_doc			[al_row] = ls_nro_doc

this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.fec_vale 		[al_row] = Date(gnvo_app.of_fecha_actual())
this.object.importe 			[al_row] = 0.00
this.object.imp_liquidado	[al_row] = 0.00
this.object.cod_usr			[al_row] = gs_user
this.object.cod_origen		[al_row] = gs_origen


end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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
string 			ls_codigo, ls_data, ls_sql
str_cliente 	lstr_cliente

choose case lower(as_columna)
	case "cod_relacion"
	
 	lstr_cliente = gnvo_app.finparam.of_get_cliente( )
	
	if lstr_cliente.b_return then
		this.object.cod_relacion 	[al_row] = lstr_cliente.proveedor
		this.object.nom_proveedor 	[al_row] = lstr_cliente.nom_proveedor
		this.object.ruc_dni			[al_row] = lstr_cliente.ruc_dni
		this.ii_update = 1
	end if

	case "matriz"
		ls_sql = "select m.matriz as matriz, " &
		       + "m.descripcion as descripcion_matriz " &
				 + "from matriz_cntbl_finan m " &
				 + "where m.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.matriz		[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose



end event

event dw_detail::itemchanged;call super::itemchanged;Decimal	ldc_importe_doc, ldc_importe_vd, ldc_total_importe


this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'importe'
		
		if dw_master.getRow() = 0 then
			MessageBox('Error', 'No ha seleccionado registro en la cabecera, por favor verifique!', StopSign!)
			this.object.importe [row] = 0
			return 1
		end if
		
		// Obtengo el importe del documento
		ldc_importe_doc = Dec(dw_master.object.importe_doc [dw_master.GetRow()])
		
		// Obtengo el importe del vale de descuento
		ldc_importe_vd = Dec(this.object.importe [row])
		
		if ldc_importe_vd > ldc_importe_doc then
			MessageBox('Error', 'El importe del vale de descuento no puede ser mayor al importe del documento, por favor verifique!', StopSign!)
			this.object.importe [row] = 0
			return 1
		end if
		
		//Ahora valido la suma total del descuento
		ldc_total_importe = Dec(this.object.total_importe [1])
		
		if ldc_total_importe > ldc_importe_doc then
			MessageBox('Error', 'La suma total de los vales de descuentos no puede ser exceder al importe del documento, por favor verifique!', StopSign!)
			this.object.importe [row] = 0
			return 1
		end if
			

END CHOOSE
end event

type uo_search from n_cst_search within w_ve323_registro_vales_descuento
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

