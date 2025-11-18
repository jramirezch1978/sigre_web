$PBExportHeader$w_al331_parte_ingreso_masivo.srw
forward
global type w_al331_parte_ingreso_masivo from w_abc
end type
type cb_4 from commandbutton within w_al331_parte_ingreso_masivo
end type
type tab_1 from tab within w_al331_parte_ingreso_masivo
end type
type tabpage_1 from userobject within tab_1
end type
type cb_1 from commandbutton within tabpage_1
end type
type dw_unidades from u_dw_abc within tabpage_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_1 cb_1
dw_unidades dw_unidades
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type cb_3 from commandbutton within tabpage_2
end type
type cb_2 from commandbutton within tabpage_2
end type
type dw_cus from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_3 cb_3
cb_2 cb_2
dw_cus dw_cus
end type
type tab_1 from tab within w_al331_parte_ingreso_masivo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_al331_parte_ingreso_masivo
end type
type cb_cancelar from commandbutton within w_al331_parte_ingreso_masivo
end type
type cb_aceptar from commandbutton within w_al331_parte_ingreso_masivo
end type
end forward

global type w_al331_parte_ingreso_masivo from w_abc
integer width = 4567
integer height = 3000
string title = "[AL331] Parte de Ingreso Masivo"
string menuname = "m_salir"
event ue_print_cus ( )
event ue_print_cus_grandes ( )
event type boolean ue_cambia_cu_sku ( string asi_cu,  string asi_sku )
cb_4 cb_4
tab_1 tab_1
dw_master dw_master
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_al331_parte_ingreso_masivo w_al331_parte_ingreso_masivo

type variables
n_cst_numerador	invo_numerador
n_cst_utilitario 	invo_utility
u_dw_abc 			idw_detail, idw_unidades, idw_cus
u_ds_base ids_data	
end variables

forward prototypes
public subroutine of_asigna_dws ()
public subroutine of_totales ()
public function integer of_set_numera ()
public function boolean of_retrieve (string as_nro_parte)
public function boolean of_genera_oc_ni (string as_regkey)
public subroutine of_calcular_importe ()
public function boolean of_cambia_cu_sku (string asi_cu, string asi_cod_sku)
end prototypes

event ue_print_cus();// vista previa de mov. almacen
str_parametros lstr_rep

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	lstr_rep.dw1 		= 'd_rpt_codigos_cu_pptt_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_parte	[1]
	lstr_rep.tipo		= '8'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event ue_print_cus_grandes();// vista previa de mov. almacen
str_parametros lstr_rep

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	lstr_rep.dw1 		= 'd_rpt_codigoqr_grande_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos QR de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_parte	[1]
	lstr_rep.tipo		= '9'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try


end event

event type boolean ue_cambia_cu_sku(string asi_cu, string asi_sku);string ls_mensaje

DECLARE usp_alm_act_saldo_x_art PROCEDURE FOR
	PKG_ZC_PARTE_INGRESO.of_cambia_sku_cu(:asi_cu, :asi_sku );
EXECUTE usp_alm_act_saldo_x_art;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_saldo_x_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
else
	commit;
END IF

CLOSE usp_alm_act_saldo_x_art;


of_retrieve('')	
return true
end event

public subroutine of_asigna_dws ();idw_detail		= tab_1.tabpage_1.dw_detail
idw_unidades	= tab_1.tabpage_1.dw_unidades
idw_cus			= tab_1.tabpage_2.dw_cus
//idw_pallets1	= tab_1.tabpage_2.dw_pallets1
//idw_pallets2	= tab_1.tabpage_2.dw_pallets2
//
//ipb_1				= tab_1.tabpage_2.pb_1
//ipb_2				= tab_1.tabpage_2.pb_2
end subroutine

public subroutine of_totales ();
end subroutine

public function integer of_set_numera (); 
//Numera documento
string	ls_mensaje, ls_nro_parte, ls_tabla, ls_codorigen
long		ll_i

if is_action = 'new' then
	
	ls_tabla = upper(dw_master.object.DataWindow.Table.UpdateTable)

	ls_codorigen = dw_master.object.cod_origen[dw_master.getrow()] 
	
	if not invo_numerador.of_nro_zc_parte_ingreso( ls_codorigen, ls_tabla, ls_nro_parte) then return 0
	
	dw_master.object.nro_parte[1] = ls_nro_parte
	
	
		
else 
	ls_nro_parte = dw_master.object.nro_parte[dw_master.getrow()] 
end if

for ll_i = 1 to idw_detail.RowCount()
	idw_detail.object.nro_parte [ll_i] = ls_nro_parte
next

for ll_i = 1 to idw_unidades.RowCount()
	idw_unidades.object.nro_parte [ll_i] = ls_nro_parte
next

return 1
end function

public function boolean of_retrieve (string as_nro_parte);string ls_foto
Long ll_row, ll_idfoto

ll_row = idw_detail.GetRow()

//Limpio todo
dw_master.Reset()
idw_detail.Reset()
idw_unidades.Reset()
idw_cus.Reset()

dw_master.ResetUpdate()
idw_detail.ResetUpdate()
idw_unidades.ResetUpdate()
idw_cus.ResetUpdate()

dw_master.ii_update = 0
idw_detail.ii_update = 0
idw_unidades.ii_update = 0
idw_cus.ii_update = 0

dw_master.retrieve(as_nro_parte)

if dw_master.RowCount() > 0 then
	
	DECLARE CUR_FOTOS CURSOR FOR
		  select distinct A.id_foto
		  from  zc_parte_ingreso_und ziu,
				vw_articulo a
		  where ziu.nro_parte = :as_nro_parte
					and a.COD_ART = ziu.cod_art;
	
	OPEN CUR_FOTOS; 
		FETCH CUR_FOTOS INTO :ll_idfoto; 		
		DO WHILE sqlca.sqlcode<>100 
			  ls_foto = gnvo_app.almacen.of_get_foto_id(ll_idfoto);		
		FETCH CUR_FOTOS INTO :ll_idfoto; 		
		LOOP 
	CLOSE CUR_FOTOS;
	

	
	idw_detail.Retrieve(as_nro_parte)
	
	if idw_detail.RowCOunt() > 0 then
		idw_unidades.Retrieve(as_nro_parte)
		
		if ll_row > 0 then
			if ll_row > idw_detail.RowCount() then
				ll_row = idw_detail.RowCount()
			end if
		else
			ll_row = 1
		end if
		
		idw_detail.setRow( ll_row )
		idw_detail.Scrolltorow( ll_row )
		idw_detail.Selectrow( 0, false)
		idw_detail.Selectrow( ll_row, true )
		
		idw_detail.event ue_output( ll_row )
		
		
	end if
	
	idw_cus.Retrieve(as_nro_parte)
		
	tab_1.tabpage_1.dw_unidades.Modify("cantidad.Protect ='1~tIf(IsNull(regkey),0,1)'")
	
	string estado
	estado=dw_master.object.flag_estado [1]
	if  estado <> '1' then 
		dw_master.of_protect( )
		tab_1.tabpage_1.dw_detail.of_protect( )
		tab_1.tabpage_1.dw_unidades.of_protect( )
		tab_1.tabpage_1.cb_1.enabled= false
		
		if estado='0' then			
		tab_1.tabpage_2.cb_2.enabled= false
		tab_1.tabpage_2.cb_3.enabled= false		
		end if
	end if
	
	

	return true		
end if

		

is_action = 'open'

return false

end function

public function boolean of_genera_oc_ni (string as_regkey);string ls_mensaje

try 
	SetPointer (HourGlass!)
	
//	Call the procedure
//  	pkg_zc_parte_ingreso.genera_oc_ni(asi_regkey => :asi_regkey);
	
	DECLARE genera_oc_ni PROCEDURE FOR
		pkg_zc_parte_ingreso.genera_oc_ni( :as_regkey );
	
	EXECUTE genera_oc_ni;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE pkg_zc_parte_ingreso.genera_oc_ni: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		SetPointer (Arrow!)
		return false
	END IF
	
	CLOSE genera_oc_ni;
	

	
	
	
	
	return true
	
catch ( Exception ex )
	rollback;
	gnvo_app.of_catch_Exception(ex, 'Error al generar OC y NI')
finally
	SetPointer (Arrow!)
end try


end function

public subroutine of_calcular_importe ();Long 		ll_Row
decimal	ldc_importe, ldc_cantidad, ln_precio_new, ln_tasaimpuesto
string 	ls_tipo_impuesto

idw_unidades.setFilter('')
idw_unidades.filter()

ldc_importe = 0
ldc_cantidad = 0

ls_tipo_impuesto = 'IGV18'

SELECT TASA_IMPUESTO
into 	:ln_tasaimpuesto
FROM IMPUESTOS_TIPO
WHERE TIPO_impuesto= :ls_tipo_impuesto;

for ll_row = 1 to idw_unidades.RowCount()
	ldc_importe 	+= Dec(idw_unidades.object.total_compra [ll_row])
	ldc_cantidad 	+= Dec(idw_unidades.object.cantidad [ll_row])
	
	ln_precio_new= idw_unidades.object.precio_compra_new	[ll_row]
	
	idw_unidades.object.tipo_impuesto 		[ll_row] = ls_tipo_impuesto
	idw_unidades.object.precio_base 			[ll_row] =  round(ln_precio_new / (ln_tasaimpuesto/100 +1), 4)
	idw_unidades.object.importe_impuesto 	[ll_row] = idw_unidades.object.cantidad [ll_row] * ( ln_precio_new - round(ln_precio_new / (ln_tasaimpuesto/100 +1), 4))
next

dw_master.object.importe	[1] = ldc_importe
dw_master.object.cantidad	[1] = ldc_cantidad
end subroutine

public function boolean of_cambia_cu_sku (string asi_cu, string asi_cod_sku);string ls_mensaje

DECLARE usp_alm_act_saldo_x_art PROCEDURE FOR
	PKG_ZC_PARTE_INGRESO.of_cambia_sku_cu(:asi_cu, :asi_cod_sku );
EXECUTE usp_alm_act_saldo_x_art;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_saldo_x_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
else
	commit;
END IF

CLOSE usp_alm_act_saldo_x_art;


//this.event ue_retrieve( )
	
return true
end function

on w_al331_parte_ingreso_masivo.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_4=create cb_4
this.tab_1=create tab_1
this.dw_master=create dw_master
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_aceptar
end on

on w_al331_parte_ingreso_masivo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

event resize;call super::resize;of_Asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width  = tab_1.tabpage_1.width  - idw_detail.x - 10

idw_unidades.height = tab_1.tabpage_1.height  - idw_unidades.y - 50
idw_unidades.width  = tab_1.tabpage_1.width  - idw_unidades.x - 10

idw_cus.height = tab_1.tabpage_2.height  - idw_cus.x - 80
idw_cus.width  = tab_1.tabpage_2.width  - idw_cus.x - 10

end event

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_param

of_asigna_dws()

idw_1 = dw_master

if not IsNull(Message.PowerObjectParm) and ISValid(Message.PowerObjectParm) then
	if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
		MessageBox('Error', 'El objeto que se pasa por parametros debe ser del tipo str_parametros', StopSign!)
		post event closequery()
		return 
	end if
	lstr_param = Message.PowerObjectParm
	//recupero el parte de ingreso masivo
	if lstr_param.string1 = 'new' then
		event ue_insert()
	else
  		of_retrieve(lstr_param.string2)
		  		 
	end if
else
	event ue_insert()		
end if

end event

event ue_insert;call super::ue_insert;dw_master.event ue_insert()
end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_nro_parte, ls_regkey, ls_filtro
Long		ll_row

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_detail.AcceptText()
idw_unidades.AcceptText()
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_unidades.of_create_log()
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

IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF idw_unidades.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_unidades.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion UNIDADES", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_unidades.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	// Ahora genero el ingreso al almacen
	idw_unidades.setFilter('')
	idw_unidades.filter( )
	
	
	ls_nro_parte = dw_master.object.nro_parte [1]
	
	this.of_retrieve(ls_nro_parte)
		
	
	for ll_row = 1 to idw_unidades.RowCount()
		if not of_genera_oc_ni(idw_unidades.object.regkey [ll_row]) then
			rollback;
			MessageBox('Error', 'No se pudo generar el ingreso al almacen', StopSign!)
			return
		end if
	next
	
	COMMIT using SQLCA;
	
	if dw_master.rowCount() > 0 then
		ls_nro_parte = dw_master.object.nro_parte [1]
		
		this.of_retrieve(ls_nro_parte)
		
	else
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_unidades.ii_update = 0
		
		dw_master.il_totdel = 0
		idw_detail.il_totdel = 0
		idw_unidades.il_totdel = 0
		
		dw_master.ResetUpdate()
		idw_detail.ResetUpdate()
		idw_unidades.ResetUpdate()
	end if
	
	is_Action = 'open'
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return
if gnvo_app.of_row_Processing( idw_detail ) <> true then return
if gnvo_app.of_row_Processing( idw_unidades ) <> true then return

if idw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle", StopSign!)
	return
end if

if idw_unidades.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta unidades", StopSign!)
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update 	= 1 OR idw_detail.ii_update = 1 OR idw_unidades.ii_update = 1 ) THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.event ue_update()
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_unidades.ii_update = 0
	END IF
END IF

end event

event ue_cancelar;call super::ue_cancelar;
Str_parametros lstr_param

if MessageBox('Aviso', 'Desea salir de la ventana?', Information!, YesNo!, 2) = 2 then return

lstr_param.b_return = false

ClosewithReturn(this, lstr_param)

close (this)
end event

event ue_anular;call super::ue_anular;Integer 	j
Long 		ll_row, ll_count
String 	ls_tipo_ref, ls_nro_ref, ls_nro_vale, ls_origen_vale
Decimal	ldc_cant_fact

if is_action = 'new' or is_action='edit' then
	MessageBox('Aviso', 'No puede anular este movimiento de almacen, debe grabarlo primero')
	return
end if

IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No se puede anular este movimiento de almacen')
	return
end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
end event

type cb_4 from commandbutton within w_al331_parte_ingreso_masivo
integer x = 3474
integer y = 124
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir"
boolean cancel = true
end type

event clicked;string ls_nro_parte, ls_origen
	//u_ds_base ids_data	
	ids_data  = create u_ds_base

	ls_nro_parte = dw_master.object.nro_parte [1]
	ls_origen = dw_master.object.cod_origen [1]
	
	ids_data.DataObject = 'd_frm_parte_ingreso'
	ids_data.object.t_empresa.text = gs_empresa
	ids_data.SetTransObject(SQLCA)
		
		ids_data.Retrieve(ls_origen, ls_nro_parte)
		ids_data.print( )
end event

type tab_1 from tab within w_al331_parte_ingreso_masivo
integer y = 1040
integer width = 3159
integer height = 1568
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3122
integer height = 1440
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_1 cb_1
dw_unidades dw_unidades
dw_detail dw_detail
end type

on tabpage_1.create
this.cb_1=create cb_1
this.dw_unidades=create dw_unidades
this.dw_detail=create dw_detail
this.Control[]={this.cb_1,&
this.dw_unidades,&
this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.cb_1)
destroy(this.dw_unidades)
destroy(this.dw_detail)
end on

type cb_1 from commandbutton within tabpage_1
integer width = 306
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar"
end type

event clicked;// Asigna valores a structura
str_parametros	lstr_param, lstr_datos
Long				ll_row
string			ls_nro_doc = ''

of_asigna_dws()


lstr_param.w1 = this.getParent( ).getParent( )

lstr_param.dw_m 	= dw_master
lstr_param.dw_d 	= idw_detail
lstr_param.dw_und = idw_unidades


OpenWithParm( w_abc_ingreso_resumido, lstr_param )
 
if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm

/*if lstr_param.b_return then
	//Algun procedimiento para cuando se da aceptar
	
end if*/

	of_calcular_importe()	
	
	
	
		tab_1.tabpage_1.dw_unidades.Modify("cantidad.Protect ='1~tIf(IsNull(regkey),0,1)'")
		
		idw_unidades.Modify("cantidad.Protect ='1~tIf(IsNull(regkey),0,1)'")
	


end event

type dw_unidades from u_dw_abc within tabpage_1
integer y = 672
integer width = 2802
integer height = 792
string dataobject = "d_abc_parte_ingreso_und_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;if idw_detail.getRow() = 0 then return

this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_Actual()

this.object.nro_parte		[al_Row] = idw_detail.object.nro_parte	[idw_detail.getRow()]
this.object.nro_item			[al_Row] = idw_detail.object.nro_item	[idw_detail.getRow()]

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

if is_action = 'edit' then
	dw_unidades.object.cantidad.protect = 1
end if
end event

event buttonclicked;call super::buttonclicked;String 				ls_desc
str_parametros 	lstr_param

this.AcceptText()

choose case lower(dwo.name)
	case "b_delete"
		if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido eliminar items en modo de edición', StopSign!)
			return
		end if		
		
		string estado
		estado=dw_master.object.flag_estado [1]
		if  estado <> '1' then	
			this.ii_update = 1
			return 
		end if
		
		if MessageBox("Aviso", "Desea eliminar el registro " + string(row) + "?", Information!, YesNo!, 2) = 2 then return
				
		this.DeleteRow( row )
		this.ii_update = 1
		
	
end choose


end event

event itemchanged;call super::itemchanged;decimal ldc_cantidad, ln_precio_new,ln_tasaimpuesto

SELECT TASA_IMPUESTO
into 	:ln_tasaimpuesto
FROM IMPUESTOS_TIPO
WHERE TIPO_impuesto= 'IGV18';


this.Accepttext()

choose case lower(dwo.name)
	case "precio_base"
		if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido eliminar items en modo de edición', StopSign!)
			return
		end if
		
	ldc_cantidad 	+= Dec(this.object.cantidad [row])
	
	ln_precio_new= this.object.precio_base	[row]
	
	this.object.precio_base 			[row] =  round(ln_precio_new / (ln_tasaimpuesto/100 +1), 4)
	this.object.importe_impuesto 	[row] = this.object.cantidad [row] * ( round(ln_precio_new * (ln_tasaimpuesto/100), 4))
	this.object.precio_compra_new [row] = round(ln_precio_new * (ln_tasaimpuesto/100 + 1), 4)

	
case "cantidad"
		if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido eliminar items en modo de edición', StopSign!)
			return
		end if
		
	ln_precio_new= this.object.precio_base	[row]
	this.object.importe_impuesto 	[row] = this.object.cantidad [row] * ( round(ln_precio_new * (ln_tasaimpuesto/100), 4))
	this.object.precio_compra_new [row] = round(ln_precio_new * (ln_tasaimpuesto/100 + 1), 4)

case "precio_compra_new"
	if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido eliminar items en modo de edición', StopSign!)
			return
		end if
		
	ln_precio_new= this.object.precio_compra_new	[row]
	this.object.importe_impuesto 	[row] = this.object.cantidad [row] * (ln_precio_new - round( ln_precio_new / (ln_tasaimpuesto/100 +1), 4))
	this.object.precio_base            [row] = round(ln_precio_new / (ln_tasaimpuesto/100 + 1), 4)

		
	
end choose
end event

type dw_detail from u_dw_abc within tabpage_1
integer y = 80
integer width = 2802
integer height = 584
integer taborder = 20
string dataobject = "d_abc_parte_ingreso_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_Actual()
this.object.flag_estado	 	[al_row] = '1'
this.object.nro_item			[al_row] = this.of_nro_item()

this.object.nro_parte		[al_Row] = dw_master.object.nro_parte[1]
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event itemchanged;Long		ll_nro_item
String	ls_filtro

if Row = 0 then return

ll_nro_item		= Long(this.object.nro_item 	[row])

ls_filtro = "nro_item=" + string(ll_nro_item)

if not IsNull(ls_filtro) then

	idw_unidades.setFilter(ls_filtro)

	idw_unidades.Filter()
	
end if
end event

event buttonclicked;call super::buttonclicked;integer ll_row
integer ls_nroitem1,ls_nroitem2
integer ll_canti

choose case lower(dwo.name)
	case "b_delete"
		if is_Action = 'edit' then
			MessageBox('Error', 'No esta permitido eliminar items en modo de edición', StopSign!)
			return
		end if
		
		string estado
		estado=dw_master.object.flag_estado [1]
		if  estado <> '1' then	
			this.ii_update = 1
			return 
		end if
		
		if MessageBox("Aviso", "Desea eliminar el registro " + string(row) + "?", Information!, YesNo!, 2) = 2 then return
		
		ll_row = 1
		ls_nroitem1 =this.object.nro_item[row]
		DO WHILE ll_row <= idw_unidades.rowcount() 
		
			ls_nroitem2 =idw_unidades.object.nro_item[ll_row]				
			if ls_nroitem1 = ls_nroitem2 then
				idw_unidades.DELEterow( ll_row)			
			else
				ll_row = ll_row + 1 
			END IF	
		LOOP


		idw_unidades.ii_update=1
	    
		this.DeleteRow(row)
		this.ii_update = 1
		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_ruta
if row>0 then
	ls_ruta = this.object.imagen_blob[row]
	
if Not ISNull(ls_ruta) then
	if not gnvo_app.logistica.of_show_imagen(ls_ruta) then 
	end if
	end if
	
end if
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3122
integer height = 1440
long backcolor = 79741120
string text = "Listado de CUS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_3 cb_3
cb_2 cb_2
dw_cus dw_cus
end type

on tabpage_2.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.dw_cus=create dw_cus
this.Control[]={this.cb_3,&
this.cb_2,&
this.dw_cus}
end on

on tabpage_2.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.dw_cus)
end on

type cb_3 from commandbutton within tabpage_2
integer x = 631
integer width = 608
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir CUS Grandes"
end type

event clicked;event ue_print_cus_grandes()
end event

type cb_2 from commandbutton within tabpage_2
integer width = 608
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir CUS Pequeños"
end type

event clicked;event ue_print_cus()
end event

type dw_cus from u_dw_abc within tabpage_2
integer x = 9
integer y = 84
integer width = 2798
integer height = 1228
integer taborder = 20
string dataobject = "d_lista_cus_parte_ingreso_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_Actual()
this.object.flag_estado	 	[al_row] = '1'
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event buttonclicked;call super::buttonclicked;if lower(dwo.name) = 'b_cambiar' then
		
	string estado
	estado=dw_master.object.flag_estado [1]
	if  estado = '0' then	
		return 
	end if
		
	string ls_nwecodsku, ls_descripcion, ls_codigo_cu, ls_mensaje, ls_nro_parte 
	
	if not gnvo_app.of_prompt_string("Indique Nuevo SKU", ls_nwecodsku) then return 	

	ls_nwecodsku = upper(trim(ls_nwecodsku))
	select desc_art
	into :ls_descripcion
	from articulo a
	where trim(a.cod_sku) = :ls_nwecodsku;
	
ls_codigo_cu = this.object.codigo_cu[row]
ls_nro_parte = dw_master.object.nro_parte [1];

IF MessageBox("Cambio de CUS "  ,  "CU:" + ls_codigo_cu + " Nuevo Articulo: " + ls_descripcion + ".  Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

of_cambia_cu_sku (ls_codigo_cu, ls_nwecodsku)

of_retrieve (ls_nro_parte)
	
end if
end event

type dw_master from u_dw_abc within w_al331_parte_ingreso_masivo
integer width = 3346
integer height = 1024
integer taborder = 20
string dataobject = "d_abc_parte_ingreso_masivo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_row] = gs_user
this.object.cod_origen 		[al_row] = gs_origen
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_Actual()
this.object.fec_parte	 	[al_row] = Date(gnvo_app.of_fecha_Actual())
this.object.flag_estado	 	[al_row] = '1'

this.object.importe		 	[al_row] = 0.00
this.object.cantidad		 	[al_row] = 0.00

is_action = 'new'
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_data2, ls_mensaje, ls_proveedor, ls_origen
Long		ll_count

this.AcceptText()

ls_origen = this.object.cod_origen		[al_row]

choose case lower(as_columna)
	case "almacen"
		select count(*)
			into :ll_count
		from almacen_user
		where cod_usr = :gs_user;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
			return
		end if
		
		if ll_count = 0 then
			ls_sql = "SELECT almacen AS CODIGO_almacen, " &
					  + "desc_almacen AS descripcion_almacen, " &
					  + "flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen " &
					  + "where cod_origen = '" + ls_origen + "' " &
					  + "and flag_estado = '1' " &
					  + "and flag_tipo_almacen <> 'O' " &
					  + "order by almacen " 
		else
			ls_sql = "SELECT al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "al.flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "     almacen_user au " &
					  + "where al.almacen = au.almacen " &
					  + "  and au.cod_usr = '" + gs_user + "'" &
					  + "  and al.cod_origen = '" + ls_origen + "' " &
					  + "  and al.flag_estado = '1' " &
					  + "  and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		end if			

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.almacen				[al_row] = ls_codigo
			this.object.desc_almacen		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS codigo_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "decode(tipo_doc_ident, '6', ruc, nro_doc_ident) AS ruc_dni " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc_dni			[al_row] = ls_data2
			this.ii_update = 1
		end if
		
		return
		
	case "tipo_doc"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		if gnvo_App.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.tipo_doc	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	/*CASE 'cod_moneda'
				
		ls_sql = "SELECT M.COD_MONEDA  AS CODIGO      ,"&
				 + " 		  M.DESCRIPCION AS DESCRIPCION  "&
				 + "FROM MONEDA M " &
				 + "where M.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_moneda [al_row] = ls_codigo
			this.ii_update = 1
			/**/
		END IF

	CASE	'forma_pago'	
		
		ls_sql = "SELECT fp.FORMA_PAGO       AS CODIGO_FPAGO ,"&
				 + "		  fp.DESC_FORMA_PAGO  AS DESCRIPCION  ,"&
				 + "		  fp.DIAS_VENCIMIENTO AS VENCIMIENTO   "&
				 + "FROM FORMA_PAGO fp " &
				 + "where fp.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, "2") then
			this.object.forma_pago 			[al_row] = ls_codigo
			this.object.desc_forma_pago 	[al_row] = ls_data
			this.ii_update = 1
			
			/**/
		END IF		*/

	CASE "item_direccion"					
			
		ls_proveedor = dw_master.object.proveedor [al_row]		
		IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
			Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!")
			Return 
		END IF
		
		// Solo Tomo la Direccion de facturacion
		ls_sql = "SELECT D.ITEM AS ITEM," &    
				 + "pkg_logistica.of_get_direccion(d.codigo, d.item) as direccion "  &
				 + "FROM DIRECCIONES D "&
				 + "WHERE D.CODIGO = '" + ls_proveedor +"' " &
				 + "AND D.FLAG_USO in ('1', '3')"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.item_direccion		[al_row] = Integer(ls_codigo)
			this.object.direccion_cliente	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose

end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event clicked;call super::clicked;if upper(dwo.name) = 'ALMACEN' then


     DatawindowChild dwc_campo
	dw_master.getChild("vendedor",dwc_campo)
	dwc_campo.settransobject(sqlca)
 	dwc_campo.retrieve(gs_origen)
	 
end if
end event

event itemchanged;call super::itemchanged;Long 		ll_j
String 	ls_proveedor, ls_desc, ls_moneda, ls_banco, ls_nom_rep
Integer 	li_item

this.AcceptText()
this.ib_edit = true
	
if lower(dwo.name)='cod_origen' then
	dw_master.object.almacen [row] = ''  
	dw_master.object.desc_almacen [row] = ''  

elseif dwo.name = 'item_direccion' then
	
	ls_proveedor = dw_master.object.proveedor [row]		
	IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
		Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!")
		Return 
	END IF
	
	li_item = Integer(data)
	
	// Solo Tomo la Direccion de facturacion
	ls_desc = gnvo_app.logistica.of_direccion_proveedor(ls_proveedor, li_item)
											
	if ISNull(ls_desc) then
		MessageBox('Aviso', 'Item de Direccion no existe o no es de facturacion' + string(li_item))
		SetNull(li_item)
		this.object.item_direccion 		[row] = gnvo_app.ii_null
		this.object.direccion_cliente		[row] = gnvo_app.is_null
		return 1
	end if
	
	this.object.direccion_cliente [row] = ls_desc
		
end if
end event

type cb_cancelar from commandbutton within w_al331_parte_ingreso_masivo
integer x = 3479
integer y = 256
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar( )
end event

type cb_aceptar from commandbutton within w_al331_parte_ingreso_masivo
integer x = 3470
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;event ue_update()

end event

