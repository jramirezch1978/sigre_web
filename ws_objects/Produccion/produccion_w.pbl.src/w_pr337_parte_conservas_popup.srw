$PBExportHeader$w_pr337_parte_conservas_popup.srw
forward
global type w_pr337_parte_conservas_popup from w_abc
end type
type cb_insertar from commandbutton within w_pr337_parte_conservas_popup
end type
type cb_cancelar from commandbutton within w_pr337_parte_conservas_popup
end type
type cb_aceptar from commandbutton within w_pr337_parte_conservas_popup
end type
type dw_detail from u_dw_abc within w_pr337_parte_conservas_popup
end type
type st_detail from statictext within w_pr337_parte_conservas_popup
end type
type st_master from statictext within w_pr337_parte_conservas_popup
end type
type dw_master from u_dw_abc within w_pr337_parte_conservas_popup
end type
end forward

global type w_pr337_parte_conservas_popup from w_abc
integer width = 3950
integer height = 2580
string title = "[PR337] Parte de Empaque CONSERVA - PRODUCCION"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_insertar cb_insertar
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_detail dw_detail
st_detail st_detail
st_master st_master
dw_master dw_master
end type
global w_pr337_parte_conservas_popup w_pr337_parte_conservas_popup

type variables
boolean		ibo_saveok = false
nvo_numeradores_varios	invo_nro

//Tipo de OT de produccion 'PROD', 'REPR', 'RPQE', 'RECL'			 
String	is_ot_tipo_prod, is_ot_tipo_repr, is_ot_tipo_rpqe, is_ot_tipo_recl
end variables

forward prototypes
public function integer of_set_numera ()
public function boolean of_procesar (string as_nro_parte)
public function integer of_get_param ()
end prototypes

public function integer of_set_numera (); 
//Numera documento
Long 		ll_row
string	ls_nro_parte, ls_nom_tabla
try 
	ls_nro_parte = dw_master.object.nro_parte [1]
	
	if is_action = 'new' or IsNull(ls_nro_parte) or trim(ls_nro_parte) = ''  then
	
		ls_nom_tabla = dw_master.of_get_tabla( )
	
		if not invo_nro.of_num_parte_empaque( gs_origen, ls_nom_tabla, ls_nro_parte) then return 0
		
		dw_master.object.nro_parte [1] = ls_nro_parte
		
	else 
		ls_nro_parte = dw_master.object.nro_parte[1] 
	end if
	
	for ll_row = 1 to dw_detail.RowCount()
		dw_detail.object.nro_parte [ll_row] = ls_nro_parte
	next
	
	return 1

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en funcion of_Set_numera()')
	return 0
	
finally
	/*statementBlock*/
end try



end function

public function boolean of_procesar (string as_nro_parte);String 	ls_mensaje
//begin
//  -- Call the procedure
//  pkg_produccion.sp_procesar_parte(asi_nro_parte => :asi_nro_parte);
//end;

DECLARE sp_procesar_parte_sin_cu PROCEDURE FOR 
		  pkg_produccion.sp_procesar_parte_sin_cu(:as_nro_parte);
		  
EXECUTE sp_procesar_parte_sin_cu ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error', 'Error en procedure pkg_produccion.sp_procesar_parte_sin_cu(), Mensaje: ' + ls_mensaje, StopSign!)
	Return false
end if

CLOSE sp_procesar_parte_sin_cu ;

return true
end function

public function integer of_get_param ();try 
	
	//Obtengo los datos del Tipo de OT
	//is_ot_tipo_prod, is_ot_tipo_repr, is_ot_tipo_rpqe, is_ot_tipo_recl
	//'PROD', 'REPR', 'RPQE', 'RECL'
	
	is_ot_tipo_prod = gnvo_app.of_get_parametro('OPER_OT_TIPO_PRODUCCION', 'PROD')
	is_ot_tipo_repr = gnvo_app.of_get_parametro('OPER_OT_TIPO_REPROCESO', 'REPR')
	is_ot_tipo_rpqe = gnvo_app.of_get_parametro('OPER_OT_TIPO_REEMPAQUE', 'RPQE')
	is_ot_tipo_recl = gnvo_app.of_get_parametro('OPER_OT_TIPO_RECLASIFICACION', 'RECL')

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al obtener parametros de produccion')
	return -1
	
finally
	
end try



return 1
end function

on w_pr337_parte_conservas_popup.create
int iCurrent
call super::create
this.cb_insertar=create cb_insertar
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_detail=create dw_detail
this.st_detail=create st_detail
this.st_master=create st_master
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_insertar
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.cb_aceptar
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.st_detail
this.Control[iCurrent+6]=this.st_master
this.Control[iCurrent+7]=this.dw_master
end on

on w_pr337_parte_conservas_popup.destroy
call super::destroy
destroy(this.cb_insertar)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_detail)
destroy(this.st_detail)
destroy(this.st_master)
destroy(this.dw_master)
end on

event resize;dw_master.width  	= newwidth  - dw_master.x - 10
st_master.width 	= dw_master.width


dw_Detail.width  	= newwidth  - dw_Detail.x - 10
st_detail.width 	= dw_master.width

end event

event ue_cancelar;call super::ue_cancelar;str_parametros	lstr_param

lstr_param.b_return = false

closeWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros	lstr_param

this.event ue_update()

if not ibo_saveok then return

lstr_param.b_return = true

closeWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;String 			ls_nro_parte
str_parametros	lstr_param

if this.of_get_param() < 0 then
	post event close()
	
	return
end if

invo_nro = create nvo_numeradores_varios

if IsNull(Message.PowerObjectParm) or not ISValid(Message.PowerObjectParm) then
	dw_master.event ue_insert()
else
	lstr_param = Message.PowerObjectParm
	
	ls_nro_parte = lstr_param.string1
	
	dw_master.Reset()
	dw_detail.Reset()
	
	dw_master.Retrieve(ls_nro_parte)
	
	if dw_master.RowCount() > 0 then
		dw_master.Object.p_logo.filename = gs_logo
		dw_detail.Retrieve(ls_nro_parte)
	end if
end if
end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
String	ls_msg, ls_nro_parte

ibo_saveok = false

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
	
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	//Creo el vale de ingreso
	if dw_master.ii_update = 1 then
		MessageBox('Aviso', 'Tienes grabaciones pendientes, debe grabar primero', StopSign!)
		return
	end if
	
	ls_nro_parte 	= dw_master.object.nro_parte 	[1]

	//Genero un nuevo nro de pallet
	if not of_procesar( ls_nro_parte) then return
	
	commit;
		
	
	ibo_saveok = true
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;String 	ls_nro_trazabilidad, ls_lote_dia, ls_nomenclatura, ls_origen, ls_nro_pallet
Date		ld_fec_produccion, ld_fec_empaque

ib_update_check = False

if IsNull(dw_master.object.nomenclatura [1]) or trim(dw_master.object.nomenclatura [1]) = '' then
	messagebox( "Atencion", "El Articulo no tiene nomenclatura, por favor verifique!", StopSign!)
	return
end if

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail) <> true then	return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "El parte de empaque de conservas debe tener al menos un batch, por favor verifique!", StopSign!)
	return
end if

//Ubico el nro de trazabilidad
/***********************************/
ls_nro_trazabilidad = trim(dw_master.object.nro_trazabilidad	[1])

if IsNull(ls_nro_trazabilidad) or trim(ls_nro_trazabilidad) = '' or is_action = 'new' then
	
	ld_fec_produccion = Date(dw_master.object.fec_produccion [1])
	ld_fec_empaque 	= Date(dw_master.object.fec_empaque 	[1])
	
	if ld_fec_empaque < ld_fec_produccion then
		gnvo_app.of_mensaje_error("La fecha de empaque no puede ser menor a la fecha de produccion")
		dw_master.object.fec_empaque [1] = ld_fec_produccion
		dw_master.setColumn("fec_empaque")
		return
	end if
	
	//Obtengo la nomenclatura
	ls_nomenclatura 		= dw_master.object.nomenclatura 	[1]
	ls_lote_dia				= dw_master.object.lote_dia 		[1]
	
	if ISNull(ls_lote_dia) or trim(ls_lote_dia) = '' then
		gnvo_app.of_mensaje_error("La fecha de empaque no puede ser menor a la fecha de produccion")
		dw_master.object.fec_empaque [1] = ld_fec_produccion
		dw_master.setColumn("fec_empaque")
		return
	end if
	
	//Genero el nro de trazabilidad
	if upper(gs_empresa) = 'SEAFROST' then
		ls_nro_trazabilidad = string(ld_fec_produccion, 'ddmmyy') + trim(ls_nomenclatura) + trim(ls_lote_dia)
	else
		ls_nro_trazabilidad = string(ld_fec_produccion, 'ddmmyy') + trim(ls_nomenclatura) +  trim(ls_lote_dia)
	end if
	
	dw_master.object.nro_trazabilidad	[1] = ls_nro_trazabilidad
	
	dw_master.ii_update = 1

end if

//Obtengo el nro de pallet
/***********************************/

if IsNull(ls_nro_pallet) or trim(ls_nro_pallet) = '' or is_action = 'new' then
	ls_origen		= dw_master.object.cod_origen	[1]
	ls_nro_pallet 	= dw_master.object.nro_pallet [1]

	//Genero un nuevo nro de pallet
	if not invo_nro.of_nro_pallet( ls_origen, ls_nro_pallet) then return
	
	//MessageBox('Aviso', 'Se ha generado satisfactoriamente el nro de pallet ' + ls_nro_pallet, Information!)
	
	dw_master.object.nro_pallet [1] = ls_nro_pallet
	
	dw_master.ii_update = 1
	
end if

if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event close;call super::close;destroy invo_nro
end event

type cb_insertar from commandbutton within w_pr337_parte_conservas_popup
integer x = 2185
integer y = 1772
integer width = 352
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar"
end type

event clicked;dw_detail.event ue_insert()
end event

type cb_cancelar from commandbutton within w_pr337_parte_conservas_popup
integer x = 3415
integer y = 2340
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_aceptar from commandbutton within w_pr337_parte_conservas_popup
integer x = 2999
integer y = 2340
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

type dw_detail from u_dw_abc within w_pr337_parte_conservas_popup
event ue_delete_row ( long al_row )
integer y = 1764
integer width = 3337
integer height = 568
string dataobject = "d_abc_parte_conserva_batch_tbl"
end type

event ue_delete_row(long al_row);Long ll_Return

if MessageBox('Information', 'Desea eliminar el registro ' + string(al_row) + "?", Information!, &
			YesNo!, 2) = 2 then return

ll_Return = THIS.DeleteRow (al_row)
IF ll_Return = -1 then
	messagebox("Error en Eliminacion de Registro","No se pudo eliminar el registro " + string(al_row),exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event ue_insert_pre;call super::ue_insert_pre;Date		ld_fec_empaque
dateTime	ldt_fecha, ldt_hoy
String	ls_fec_empaque

ld_fec_empaque = Date(dw_master.object.fec_empaque	[1])
ldt_hoy			= gnvo_app.of_fecha_actual()

ldt_fecha = DateTime(ld_fec_empaque, time(ldt_hoy))

this.object.cant_procesada	[al_row] = 0.00
this.object.hora				[al_row] = ldt_fecha
this.object.nro_parte		[al_row] = dw_master.object.nro_parte [1]
end event

event buttonclicked;call super::buttonclicked;
this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'b_delete'
		
		this.event ue_delete_row(row)


END CHOOSE
end event

event itemchanged;call super::itemchanged;Decimal	ldc_cantidad, ldc_factor_conv
Long		ll_row

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cant_procesada'
		
		ldc_cantidad = 0
		for ll_row = 1 to this.rowCount()
			ldc_cantidad += dec(this.object.cant_procesada [ll_row])
		next
		
		dw_master.object.cant_producida [1] = ldc_cantidad
		
//		if trim(dw_master.object.und [1]) = 'LTA' then
//			dw_master.object.cant_producida [1] = ldc_cantidad
//			
//		elseif trim(dw_master.object.und2 [1]) = 'LTA' then
//			
//			ldc_factor_conv = Dec(dw_master.object.factor_conv_und [1])
//			
//			If IsNull(ldc_factor_conv) then ldc_factor_conv = 0
//			
//			if ldc_factor_conv = 0 then
//				MessageBox('Error', 'Tener cuidado con el factor de conversión, no se ha especificado', StopSign!)
//				return
//			end if
//			
//			dw_master.object.cant_producida [1] = ldc_cantidad / ldc_factor_conv
//		
//		else
//			MessageBox('Error', 'No ha especificado la unidad LATA (LTA) por favor verifique', StopSign!)
//				return
//		end if
		
		dw_master.ii_update = 1


END CHOOSE
end event

type st_detail from statictext within w_pr337_parte_conservas_popup
integer y = 1672
integer width = 3150
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "DETALLE DE BATCH/ CARROS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_master from statictext within w_pr337_parte_conservas_popup
integer width = 3150
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "PARTE DE EMPAQUE CONSERVAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_pr337_parte_conservas_popup
integer y = 96
integer width = 3817
integer height = 1572
boolean bringtotop = true
string dataobject = "d_abc_parte_conserva_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime		ldt_today
Integer		li_years, li_year
date			ld_fec_vencimiento

try 
	li_years = Integer(gnvo_app.of_get_parametro("PROD_YEARS_DURACION_CONSERVAS", "4"))

	ldt_today = gnvo_app.of_fecha_Actual()
	
	this.Object.p_logo.filename = gs_logo
	
	//Obtengo la fecha de vencimiento
	li_year = year(Date(ldt_today)) + li_years
	ld_fec_vencimiento = Date(string(ldt_today, 'dd/mm/') + trim(string(li_year, '0000')))
	
	
	this.Object.p_logo.filename = gs_logo
	
	this.object.cod_origen			[al_Row] = gs_origen
	this.object.cod_usr				[al_Row] = gs_user
	this.object.fec_registro		[al_row] = ldt_today
	this.object.fec_empaque			[al_row] = Date(ldt_today)
	this.object.fec_produccion		[al_row] = Date(ldt_today)
	this.object.fec_vencimiento	[al_row] = ld_fec_vencimiento
	this.object.fec_composicion	[al_row] = Date(ldt_today)
	
	
	this.object.flag_estado			[al_row] = '1'
	this.object.flag_conserva		[al_row] = '1'
	this.object.cant_producida		[al_row] = 0.00
	
	this.object.flag_tipo_proceso	[al_row] = '1'
	this.object.flag_tipo_empaque	[al_row] = '1'
	
	is_Action = 'new'

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al abrir ventana " + this.ClassName())
finally
	/*statementBlock*/
end try

end event

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

event ue_display;call super::ue_display;string 	ls_codigo, ls_data, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, &
			ls_return6, ls_Return7, ls_return8, ls_nro_ot, ls_mensaje, ls_almacen, ls_categ_envase
			
choose case lower(as_columna)
	case "turno"
		ls_sql = "select turno as turno, " &
				 + "t.descripcion as desc_turno " &
				 + "from turno t " &
				 + "where t.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then
			this.object.turno			[al_row] = ls_return1
			this.object.desc_turno	[al_row] = ls_return2

			this.ii_update = 1
		end if
		
	case 'nro_ot'
		ls_sql = "select ot.nro_orden as nro_orden, " &
				 + "ot.titulo as titulo_ot, " &
				 + "ot.cliente as cliente, " &
				 + "p.nom_proveedor as nom_cliente, " &
				 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, " &
				 + "ot.ot_tipo as tipo_ot " &
				 + "from orden_trabajo ot, " &
				 + "     proveedor     p," &
				 + "     ot_adm_usuario otu " &
				 + "where ot.cliente = p.proveedor (+) " &
				 + "  AND ot.ot_tipo in (select * from table(split(PKG_CONFIG.USF_GET_PARAMETER('PRODUCCION_TIPOS_OT', 'PROD,REPR,RPQE'))))" &
				 + "  and ot.ot_adm  = otu.ot_adm " &
				 + "  and otu.cod_usr = '" + gs_user + "'" &
				 + "  and ot.flag_estado in ('1', '3') "
				 
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, ls_Return4, ls_return5, ls_return6, '1') then 
			this.object.nro_ot		[al_row] = ls_return1
			this.object.titulo		[al_row] = ls_return2
			this.object.cliente		[al_row] = ls_return3
			this.object.nom_cliente	[al_row] = ls_return4
			this.object.ruc_dni		[al_row] = ls_return5
			
			if ls_return6 = is_ot_tipo_prod then
				this.object.flag_tipo_proceso		[al_row] = '1'
			elseif ls_return6 = is_ot_tipo_repr then
				this.object.flag_tipo_proceso		[al_row] = '2'
			elseif ls_return6 = is_ot_tipo_rpqe then
				this.object.flag_tipo_proceso		[al_row] = '3'
			elseif ls_return6 = is_ot_tipo_recl then
				this.object.flag_tipo_proceso		[al_row] = '4'
			end if
			
			this.ii_update = 1
		end if
		
	case 'controlador'
		ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
				 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
				 + "m.NRO_DOC_IDENT_RTPS as dni " &
				 + "from vw_pr_trabajador m " &
				 + "where m.FLAG_ESTADO = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3) then 
			this.object.controlador			[al_row] = ls_return1
			this.object.nom_controlador	[al_row] = ls_return2
			this.ii_update = 1
		end if
		
		
	case "almacen_pptt"
		ls_nro_ot = this.object.nro_ot  [al_row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_sql = "select distinct al.almacen as almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "from articulo_mov_proy amp, " &
				 + "     almacen           al, " &
				 + "     articulo          a " &
				 + "where amp.almacen = al.almacen " &
				 + "  and amp.cod_Art = a.cod_art " &
				 + "  and amp.nro_doc = '" + ls_nro_ot + "'" &
				 + "  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') " &
				 + "  and amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1') " &
				 + "  and amp.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then
			
			this.object.almacen_pptt		[al_row] = ls_return1
			this.object.desc_almacen_pptt	[al_row] = ls_return2

			this.ii_update = 1
		end if		

	case "cod_art_pptt"
		
		update articulo_mov_proy amp
			set amp.flag_estado = '1'
		where amp.tipo_doc = :gnvo_app.is_doc_ot
		  and amp.tipo_mov = 'I09'
		  and amp.flag_estado = '3';
		  
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQlErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al momento de actualizar el flag de estado de los articulos de la Orden de Trabajo. Mensaje: " + ls_mensaje, StopSign!)
			return
		end if  
		
		commit;

		ls_nro_ot = this.object.nro_ot  [al_row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_almacen = this.object.almacen_pptt  [al_row]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un almacen de producto terminado")
			this.setColumn("almacen_pptt")
			return
		end if
		
		ls_sql = "select a.cod_art as codigo_articulo, " &
				 + "a.desc_art as descripcion_Articulo, " &
				 + "a.und as und, " &
				 + "a.und2 as und2, " &
				 + "a.factor_conv_und as factor_conv_und, " &
				 + "amp.cod_origen as cod_origen, " &
				 + "amp.nro_mov as nro_mov, " &
				 + "a.nomenclatura as nomenclatura " &
				 + "from articulo_mov_proy amp, " &
				 + "     articulo          a " &
				 + "where amp.cod_Art = a.cod_art " &
				 + "  and amp.nro_doc = '" + ls_nro_ot + "'" &
				 + "  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') " &
				 + "  and amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1') " &
				 + "  and amp.almacen = '" + ls_almacen + "'" &
				 + "  and amp.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, &
									ls_return5, ls_return6, ls_return7, ls_return8, '2') then
											
			this.object.cod_art_pptt		[al_row] = ls_return1
			this.object.desc_art_pptt		[al_row] = ls_return2
			this.object.und					[al_row] = ls_return3
			this.object.und2					[al_row] = ls_return4
			this.object.factor_conv_und	[al_row] = Dec(ls_return5)
			this.object.org_amp_ing			[al_row] = ls_return6
			this.object.nro_amp_ing			[al_row] = Long(ls_return7)
			this.object.nomenclatura		[al_row] = ls_return8
			
			this.object.cant_producida		[al_row] = 0
			
			this.ii_update = 1
		end if	
		
	case "cod_envase"
		
		try 
			ls_nro_ot = this.object.nro_ot  [al_row]
		
			if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
				gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
				this.setColumn("nro_ot")
				return
			end if
			
			ls_categ_envase = gnvo_app.of_get_parametro("COMPRAS_CATEG_ENVASE", "004")
			
			ls_sql = "select distinct a.cod_art as codigo_articulo, " &
					 + "a.desc_art as descripcion_Articulo, " &
					 + "a.und as und " &
					 + "from articulo_mov_proy  amp, " &
					 + "     articulo           a, " &
					 + " 		articulo_sub_Categ a2 " &
					 + "where amp.cod_Art   = a.cod_art " &
					 + "  and amp.nro_doc   = '" + ls_nro_ot + "'" &
					 + "  and a.sub_cat_art = a2.cod_sub_cat " &
					 + "  and a2.cat_art = '" + ls_categ_envase + "'" &
					 + "  and amp.tipo_doc  = (select l.doc_ot from logparam l where l.reckey = '1') " &
					 + "  and amp.tipo_mov  = (select l.oper_cons_interno from logparam l where l.reckey = '1') " &
					 + "  and amp.flag_estado = '1'"
					 
			if gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then
				
				this.object.cod_envase		[al_row] = ls_return1
				this.object.desc_envase		[al_row] = ls_return2
				this.ii_update = 1
				
			end if
		
		catch ( Exception ex )
			gnvo_app.of_catch_exception(ex, "Error al elegir el envase")
		end try
		
		
		
end choose
end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_mensaje
Integer 	li_years, li_year, li_nro_dias
Date		ld_fec_vencimiento, ld_fec_produccion, ld_fec_empaque, ld_hoy, ld_fec_limite
dateTime	ldt_fecha 
Time		lt_hoy
Long		ll_row


this.Accepttext()

ld_hoy = date(gnvo_app.of_fecha_Actual())

CHOOSE CASE dwo.name
	CASE 'fec_produccion'
		try 
			
			//VAlido la fecha de produccion
			ld_fec_produccion = Date(this.object.fec_produccion [row])
			
			//Valido que la fecha de produccion no puede ser mayor que la fecha de hoy día
			if ld_fec_produccion > ld_hoy then
				MessageBox('Error', 'La fecha de produccion no puede ser mayor que la fecha actual' &
										+ '~r~nFecha Actual: ' + string(ld_hoy, 'dd/mm/yyyy') &
										+ '~r~nFecha Produccion: ' + string(ld_fec_produccion, 'dd/mm/yyyy') &
										+ '~r~nPor favor verifique!', StopSign!)
										
				this.object.fec_produccion [row] = ld_hoy
				return 1
			end if
			
			//La fecha de produccion no puede ser menor a 30 días 
//			select :ld_hoy - :ld_fec_produccion + 1
//				into :li_nro_dias
//			from dual;
//			
//			if SQLCA.SQLCode < 0 then
//				ls_mensaje = SQLCA.SQLErrText
//				ROLLBACK;
//				MessageBox('Error', 'Ha ocurrido un error al encontrar la diferencia entre Fechas. Mensaje: ' + ls_mensaje, StopSign!)
//				this.object.fec_produccion [row] = ld_hoy
//				return 1
//			end if
//			
//			if li_nro_dias > 30 then
//				MessageBox('Error', 'La fecha de produccion no puede exceder los 30 días a partir de la fecha actual' &
//										+ '~r~nFecha Actual: ' + string(ld_hoy, 'dd/mm/yyyy') &
//										+ '~r~nFecha Produccion: ' + string(ld_fec_produccion, 'dd/mm/yyyy') &
//										+ '~r~nPor favor verifique!', StopSign!)
//										
//				select :ld_hoy - 30 + 1
//					into :ld_fec_produccion
//				from dual;
//
//				this.object.fec_produccion [row] = ld_fec_produccion
//				return 1
//			end if
			
			li_years = Integer(gnvo_app.of_get_parametro("PROD_YEARS_DURACION_CONSERVAS", "4"))
			
			//Obtengo la fecha de vencimiento
			li_year = year(ld_fec_produccion) + li_years
			ld_fec_vencimiento = Date(string(ld_fec_produccion, 'dd/mm/') + trim(string(li_year, '0000')))
			
			
			this.object.fec_vencimiento	[row] = ld_fec_vencimiento
			
		
		catch ( Exception ex )
			gnvo_app.of_catch_exception(ex, "ha causado una exception en itemchanged fec_produccion")
			
		finally
			/*statementBlock*/
		end try
	
	case "fec_empaque"
		
		ld_fec_empaque = Date(this.object.fec_empaque	[1])
		
		//Valido que la fecha de produccion no puede ser mayor que la fecha de hoy día
		if ld_fec_empaque > ld_hoy then
			MessageBox('Error', 'La fecha de empaque no puede ser mayor que la fecha actual' &
									+ '~r~nFecha Actual: ' + string(ld_hoy, 'dd/mm/yyyy') &
									+ '~r~nFecha Empaque: ' + string(ld_fec_empaque, 'dd/mm/yyyy') &
									+ '~r~nPor favor verifique!', StopSign!)
									
			this.object.fec_empaque [row] = ld_hoy
			return 1
		end if
		
		//Ubico la fecha limite
//		select to_date(to_char(:ld_hoy, 'dd/mm/') || to_char(to_number(to_char(:ld_hoy, 'yyyy') - 4)), 'dd/mm/yyyy')
//		  into :ld_fec_limite
//		from dual;			
//		
//		if SQLCA.SQLCode < 0 then
//			ls_mensaje = SQLCA.SQLErrText
//			ROLLBACK;
//			MessageBox('Error', 'Ha ocurrido un error al calcular la fecha limite. Mensaje: ' + ls_mensaje, StopSign!)
//			this.object.fec_empaque [row] = ld_hoy
//			return 1
//		end if
//		
//		if ld_fec_empaque < ld_fec_limite then
//			MessageBox('Error', 'La fecha de empaque no puede exceder 4 años a partir de la fecha actual' &
//									+ '~r~nFecha Limite: ' + string(ld_fec_limite, 'dd/mm/yyyy') &
//									+ '~r~nFecha Empaque: ' + string(ld_fec_empaque, 'dd/mm/yyyy') &
//									+ '~r~nPor favor verifique!', StopSign!)
//									
//			this.object.fec_empaque [row] = ld_fec_limite
//			return 1
//		end if
			
		
		for ll_row = 1 to dw_detail.RowCount()
			lt_hoy		= time(dw_detail.object.hora	[ll_row])
			ldt_fecha 	= DateTime(ld_fec_empaque, time(lt_hoy))	
			
			dw_detail.object.hora	[ll_row] = ldt_fecha
			
			dw_detail.ii_update = 1
		next
		
		

END CHOOSE
end event

