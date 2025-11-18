$PBExportHeader$w_fi366_dpd_masivo.srw
forward
global type w_fi366_dpd_masivo from w_abc
end type
type st_2 from statictext within w_fi366_dpd_masivo
end type
type cb_listado from commandbutton within w_fi366_dpd_masivo
end type
type dw_detail from u_dw_abc within w_fi366_dpd_masivo
end type
type dw_master from u_dw_abc within w_fi366_dpd_masivo
end type
type st_1 from statictext within w_fi366_dpd_masivo
end type
end forward

global type w_fi366_dpd_masivo from w_abc
integer width = 4443
integer height = 2888
string title = "[FI366] Generacion de DPDs Masivos"
string menuname = "m_mantenimiento_cl"
event ue_listado ( )
event ue_cerrar ( )
st_2 st_2
cb_listado cb_listado
dw_detail dw_detail
dw_master dw_master
st_1 st_1
end type
global w_fi366_dpd_masivo w_fi366_dpd_masivo

type variables
n_cst_wait	invo_wait
end variables

forward prototypes
public function boolean of_actualiza_cnta_prsp (long al_row)
public function integer of_set_numera ()
public function boolean of_actualiza_cencos (long al_row)
public function boolean of_actualiza_centro_benef (long al_row)
public function boolean of_actualiza_confin (long al_row)
public subroutine of_retrieve (string as_nro_generacion)
end prototypes

event ue_listado();str_parametros 	lstr_param

lstr_param.titulo		= 'Listado de Codigos de RELACION'
lstr_param.dw1			= 'd_lista_proveedores_cencos_tbl'
lstr_param.opcion   	= 22  //Listado de codigos de relacion  	
lstr_param.tipo		= ''
lstr_param.dw_m		= dw_master
lstr_param.dw_d		= dw_detail

OpenWithParm( w_abc_seleccion_lista_search, lstr_param)
IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm

dw_detail.setFocus()
end event

event ue_cerrar();//f_mensaje("Esta opcion no esta disponible para este tipo de documento", "")
end event

public function boolean of_actualiza_cnta_prsp (long al_row);Long 		ll_i
String	ls_cnta_prsp, ls_desc_cnta_prsp

dw_detail.AcceptText()

if MessageBox('Aviso', 'Desea sustituir el dato de la cuenta prespuestal en todos ' &
							+ 'los registros a partir del registro Nro ' + string(al_row), &
							Information!, YesNo!, 1) = 2 then return false

ls_cnta_prsp 		= dw_detail.object.cnta_prsp 			[al_row]
ls_desc_cnta_prsp	= dw_detail.object.desc_cnta_prsp 	[al_row]

for ll_i = al_row + 1 to dw_detail.Rowcount()
	dw_detail.object.cnta_prsp 		[ll_i] = ls_cnta_prsp
	dw_detail.object.desc_cnta_prsp 	[ll_i] = ls_desc_cnta_prsp
next

return true
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_mensaje, ls_tabla, ls_nro_generacion, ls_origen
n_cst_utilitario 	lnvo_util

try
	
	if is_action = 'new' then
		
		invo_wait.of_mensaje("Generando nuevo numero de documento")
		
		ls_tabla 	= dw_master.of_get_tabla( )
		ls_origen	= dw_master.object.cod_origen [1]
		
		select count(*)
			into :ll_count
		from NUM_TABLAS
		where tabla	 = :ls_tabla
		  and origen = :ls_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		if ll_count = 0 then
			insert into NUM_TABLAS(tabla, origen, ult_nro)
			values( :ls_tabla, :ls_origen, 1);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
				return 0
			end if
		
		end if
		
		SELECT ult_nro
		  INTO :ll_ult_nro
		FROM NUM_TABLAS
		where tabla  = :ls_tabla
		  and origen = :ls_origen for update;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		//Verifico que el numero del oper_sec no exista
		do
			invo_wait.of_mensaje( "Generando NRO DE GENERACION para DPDs MASIVOS:  " + string(ll_ult_nro) )
			
			if gnvo_app.of_get_parametro("FINANZAS_NRO_PARTE_MASIVO_DPD", "1") = "1" then
				ls_nro_generacion = trim(ls_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(ls_origen)), '0')
			else
				ls_nro_generacion = trim(ls_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(ls_origen)), '0')
			end if
			
			SELECT count(*)
				into :ll_count
			from FIN_DPD_MASIVOS t
			where t.nro_generacion = :ls_nro_generacion;
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al consulta la tabla FIN_DPD_MASIVOS. Mensaje: " + ls_mensaje, StopSign!)
				return 0
			end if
			
			if ll_count > 0 then 
				ll_ult_nro++ 
			end if
			
		loop while ll_count <> 0 
		
		update NUM_TABLAS
			set ult_nro = :ll_ult_nro + 1
		where tabla  = :ls_tabla
		  and origen = :ls_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		dw_master.object.nro_generacion[1] = ls_nro_generacion
			
	else 
		ls_nro_generacion = dw_master.object.nro_generacion[1] 
	end if
	
	for ll_i = 1 to dw_detail.RowCount()
		dw_detail.object.nro_generacion	[ll_i] = ls_nro_generacion
	next
	
	return 1
	
catch(Exception ex)

finally
	invo_wait.of_close()
end try
end function

public function boolean of_actualiza_cencos (long al_row);Long 		ll_i
String	ls_Cencos, ls_desc_Cencos

dw_detail.AcceptText()

if MessageBox('Aviso', 'Desea sustituir el dato del Centro de Costos en todos ' &
							+ 'los registros a partir del registro Nro ' + string(al_row), &
							Information!, YesNo!, 1) = 2 then return false

ls_Cencos 		= dw_detail.object.cencos 			[al_row]
ls_desc_Cencos	= dw_detail.object.desc_cencos 	[al_row]

for ll_i = al_row + 1 to dw_detail.Rowcount()
	dw_detail.object.cencos 		[ll_i] = ls_Cencos
	dw_detail.object.desc_cencos 	[ll_i] = ls_desc_Cencos
next

return true
end function

public function boolean of_actualiza_centro_benef (long al_row);Long 		ll_i
String	ls_centro_benef, ls_desc_centro

dw_detail.AcceptText()

if MessageBox('Aviso', 'Desea sustituir el dato del Centro de Beneficio en todos ' &
							+ 'los registros a partir del registro Nro ' + string(al_row), &
							Information!, YesNo!, 1) = 2 then return false

ls_centro_benef 	= dw_detail.object.centro_benef 	[al_row]
ls_desc_centro		= dw_detail.object.desc_centro 	[al_row]

for ll_i = al_row + 1 to dw_detail.Rowcount()
	dw_detail.object.centro_benef [ll_i] = ls_centro_benef
	dw_detail.object.desc_centro 	[ll_i] = ls_desc_centro
next

return true
end function

public function boolean of_actualiza_confin (long al_row);Long 		ll_i
String	ls_confin, ls_desc_confin

dw_detail.AcceptText()

if MessageBox('Aviso', 'Desea sustituir el dato del Concepto Financiero en todos ' &
							+ 'los registros a partir del registro Nro ' + string(al_row), &
							Information!, YesNo!, 1) = 2 then return false

ls_confin 		= dw_detail.object.confin 			[al_row]
ls_desc_confin	= dw_detail.object.desc_confin 	[al_row]

for ll_i = al_row + 1 to dw_detail.Rowcount()
	dw_detail.object.confin 		[ll_i] = ls_confin
	dw_detail.object.desc_confin 	[ll_i] = ls_desc_confin
next

return true
end function

public subroutine of_retrieve (string as_nro_generacion);dw_master.Reset()
dw_detail.Reset()

dw_master.Retrieve(as_nro_generacion)
dw_detail.Retrieve(as_nro_generacion)

dw_master.ResetUpdate()
dw_detail.ResetUpdate()

dw_master.ii_update = 0
dw_detail.ii_update = 0




end subroutine

on w_fi366_dpd_masivo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_2=create st_2
this.cb_listado=create cb_listado
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.cb_listado
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.st_1
end on

on w_fi366_dpd_masivo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.cb_listado)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.st_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

st_1.width = dw_master.width

//Botones

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

cb_listado.x 	=  newwidth  - cb_listado.width - 10
st_2.width 		= cb_listado.x - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = dw_detail AND dw_master.RowCount() = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro", StopSign!)
	RETURN
END IF

if idw_1 = dw_master then
	if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
		event ue_update_Request()
	end if
	
	dw_master.Reset()
	dw_detail.Reset()
	
	dw_master.ii_update 	= 0
	dw_detail.ii_update	= 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_open_pre;call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente

invo_wait 	= create n_cst_wait

dw_master.setFocus()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

if dw_master.ii_update = 0 and dw_detail.ii_update = 0 then
	MessageBox("Aviso", "No hay cambios pendientes por grabar", Information!)
	return
end if

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
	
	is_action = 'open'
	
 	if dw_master.RowCount() > 0 then
		of_retrieve(dw_master.object.nro_generacion [1])
	end if
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

if is_action = 'anular' then
	ib_update_check = true
	return
end if

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return
if gnvo_app.of_row_Processing( dw_detail ) <> true then return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle", StopSign!)
	return
end if

IF is_action = 'new' THEN
	IF of_set_numera() = 0 THEN RETURN
	
END IF

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		
		dw_master.ResetUpdate()
		dw_detail.ResetUpdate()
	END IF
END IF

end event

event close;call super::close;destroy invo_wait
end event

event ue_anular;call super::ue_anular;String 	ls_nro_generacion

if dw_master.RowCount() = 0 then
	MessageBox('Error','No hay registro alguno para anular, por favor verifique!', StopSign!)
	return
end if

if dw_master.object.flag_estado [1] <> '1' then
	MessageBox('Error','El Documento no se encuentra activo, por favor verifique!', StopSign!)
	return
end if

ls_nro_generacion = dw_master.object.nro_generacion [1]

if MessageBox('Aviso', 'Desea anular el registro ' + ls_nro_generacion + '?', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado	[1] = '0'
dw_master.ii_update = 1

dw_detail.event ue_delete_all( )

is_action = 'anular'
end event

event ue_retrieve_list;call super::ue_retrieve_list;
str_parametros sl_param

TriggerEvent ('ue_update_request')


sl_param.dw1     = 'd_lista_dpd_masivos_tbl'
sl_param.titulo  = 'Listado de DPDs Masivos'

sl_param.field_ret_i[1] = 1 //nro registro

OpenWithParm( w_lista, sl_param)
sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
	
	is_Action = 'open'
	TriggerEvent('ue_modify')

END IF	
end event

event ue_print;call super::ue_print;String  ls_nro_generacion
str_parametros lstr_rep

try 
	
	IF dw_master.Getrow () = 0 THEN RETURN
	
	IF dw_master.ii_update = 1 OR &
		dw_detail.ii_update = 1 THEN 
		
		Messagebox('Aviso','Debe Grabar el Documento , Tiene Modificaciones , Verifique!')
		Return
		
	END IF	
	
	//Verificacion de comprobante de Egreso
	ls_nro_generacion      = dw_master.object.nro_generacion		[1]
	
	lstr_rep.dw1 		= 'd_rpt_dpd_masivo_tbl'
	
	lstr_rep.titulo 	= 'Previo de Generacion de DPD Masivo'
	lstr_rep.string1 	= ls_nro_generacion
	lstr_rep.tipo		= '1S'
		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	
catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

type st_2 from statictext within w_fi366_dpd_masivo
integer y = 892
integer width = 2729
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Listado de codigos de Relacion"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_listado from commandbutton within w_fi366_dpd_masivo
integer x = 2725
integer y = 880
integer width = 512
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Obtener Listado"
boolean cancel = true
end type

event clicked;if dw_master.RowCount() = 0 then
	MessageBox('Error', 'Debe insertar un dato en la cabecera', StopSign!)
	return
end if

parent.event post ue_listado()
end event

type dw_detail from u_dw_abc within w_fi366_dpd_masivo
integer y = 1000
integer width = 3465
integer height = 1336
integer taborder = 20
string dataobject = "d_abc_dpd_masivo_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = gnvo_app.of_fecha_Actual()
this.object.cantidad			[al_row] = 1
this.object.importe			[al_row] = 0.00
this.object.nro_cuotas		[al_row] = 1
this.object.cod_usr			[al_row] = gs_user

this.object.nro_generacion	[al_row] = dw_master.object.nro_generacion [1]
end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_display;call super::ue_display;boolean 			lb_ret
string 			ls_codigo, ls_data, ls_sql, ls_ruc, ls_year, ls_Cencos, ls_Desc_cencos, ls_centro_benef, &
					ls_desc_centro_benef
str_parametros	lstr_param
choose case lower(as_columna)
	case "proveedor"
			
		ls_sql = "select p.proveedor as proveedor " &
				 + "       p.nom_proveedor as nombre_razon_social, " &
				 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni," &
				 + "       m.cencos as cencos," &
				 + "       cc.desc_cencos as desc_cencos," &
				 + "       m.centro_benef as centro_benef," &
				 + "       cb.desc_centro as desc_centro_benef " &
				 + "from proveedor p," &
				 + "     maestro   m," &
				 + "     centros_costo cc," &
				 + "     centro_beneficio cb " &
				 + "where p.proveedor = m.cod_trabajador    (+) " &
				 + "  and m.cencos    = cc.cencos           (+) " &
				 + "  and m.centro_benef = cb.centro_benef  (+) " &
				 + "  and p.flag_estado <> '0' " &
				 + "order by p.nom_proveedor"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_ruc, ls_cencos, ls_desc_cencos, &
									ls_centro_benef, ls_desc_centro_benef, "2") then
			
			this.object.cod_relacion 	[al_row] = ls_codigo
			this.object.nom_proveedor 	[al_row] = ls_data
			this.object.ruc_dni		 	[al_row] = ls_ruc
			this.object.cencos		 	[al_row] = ls_cencos
			this.object.desc_Cencos	 	[al_row] = ls_desc_cencos
			this.object.centro_benef 	[al_row] = ls_centro_benef
			this.object.desc_centro		[al_row] = ls_desc_centro_benef
			
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			//ib_estado_prea = TRUE
			/**/
		END IF
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			
			of_actualiza_cencos(al_row)
			
			this.ii_update = 1
		end if
		
	CASE 'cnta_prsp'
		
		ls_year = string(dw_master.object.fec_emision [dw_master.getRow()], 'yyyy')
		ls_cencos = this.object.cencos [al_row]
		
		ls_sql = "SELECT distinct pc.cnta_prsp AS codigo_cnta_prsp, " &
				  + "pc.descripcion AS descripcion_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cnta_prsp = pc.cnta_prsp " &
				  + "  and pp.ano = " + ls_year &
				  + "  and pp.cencos = '" + ls_cencos + "'" &
				  + "  and pc.flag_estado = '1'" &
				  + "  and pp.flag_estado <> '0'"
				 
		gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_Data
			
			of_actualiza_cnta_prsp(al_row)
			
			this.ii_update = 1
		end if
				
	CASE 'centro_benef'

		ls_sql = "SELECT Cb.CENTRO_BENEF AS CODIGO, "&
				 + "cb.DESC_CENTRO AS DESCRIPCION "&
				 + "FROM CENTRO_BENEFICIO cb "&
				 + "where cb.flag_estado <> '0'"
				 
		gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			
			of_actualiza_centro_benef(al_row)
			this.ii_update = 1
		end if

	CASE 'confin'
		
		/*
			1	Cntas x Cobrar
			2	Cnas x Pagar
			3	Tesoreria
			4	Todos
			5	Letras
			6	Liquidacion de Beneficios
			7	Devengados OS
		*/
		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 3	
		lstr_param.str_array[1] = '3'		//Tesoreria
		lstr_param.str_array[2] = '4'		//Todos
		lstr_param.titulo 		= 'Selección de Concepto Financiero'
		lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			
			of_actualiza_confin(al_row)
			
			this.ii_update = 1
		END IF
end choose
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

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_Cencos, ls_nom_proveedor, ls_ruc_dni, ls_desc_cencos, ls_centro_benef, &
			ls_Desc_Centro
Integer	li_year

this.Accepttext()

CHOOSE CASE dwo.name
		
	CASE 'proveedor'

		select p.nom_proveedor,
				 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
				 m.cencos,
				 cc.desc_cencos,
				 m.centro_benef,
				 cb.desc_centro
		into 	:ls_nom_proveedor, :ls_ruc_dni, :ls_cencos, :ls_desc_cencos, :ls_centro_benef, :ls_desc_Centro
		from proveedor 			p,
			  maestro   			m,
			  centros_costo 		cc,
			  centro_beneficio 	cb
		where p.proveedor 		= m.cod_trabajador (+)
		  and m.cencos    		= cc.cencos        (+)
		  and m.centro_benef 	= cb.centro_benef  (+)
		  and p.flag_estado 		<> '0'
		  and p.proveedor			= :data;
		
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.object.ruc_dni			[row] = gnvo_app.is_null
			this.object.cencos			[row] = gnvo_app.is_null
			this.object.desc_cencos		[row] = gnvo_app.is_null
			this.object.centro_benef	[row] = gnvo_app.is_null
			this.object.desc_centro		[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Codigo de Proveedor ' + data + ' no existe o no esta activo, por favor verifique', StopSign!)
			return 1
		end if

		this.object.nom_proveedor	[row] = ls_nom_proveedor
		this.object.ruc_dni			[row] = ls_ruc_dni
		this.object.cencos			[row] = ls_cencos
		this.object.desc_cencos		[row] = ls_desc_cencos
		this.object.centro_benef	[row] = ls_centro_benef
		this.object.desc_centro		[row] = ls_desc_centro
		
		
	CASE 'centro_benef'

		SELECT cb.DESC_CENTRO 
			into :ls_data
		FROM CENTRO_BENEFICIO cb 
		where cb.flag_estado 	<> '0'
		  and cb.centro_benef	= :data;
		
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.centro_benef	[row] = gnvo_app.is_null
			this.object.desc_centro		[row] = gnvo_app.is_null
			MessageBox('Error', 'Centro de Beneficio no existe o no esta activo, por favor verifique', StopSign!)
			return 1
		end if

		this.object.desc_centro		[row] = ls_data
		
		of_actualiza_centro_benef(row)
				 

	case "cencos"
		SELECT desc_cencos 
			into :ls_data
		FROM centros_costo 
		WHERE FLAG_ESTADO = '1'
		  and cencos		= :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null
			MessageBox('Error', 'Centro de Costos no existe o no esta activo, por favor verifique', StopSign!)
			return 1
		end if

		this.object.desc_cencos		[row] = ls_data
		
		of_actualiza_cencos(row)
		
	CASE 'cnta_prsp'
		
		li_year = Integer(string(dw_master.object.fec_emision [dw_master.getRow()], 'yyyy'))
		ls_cencos = this.object.cencos [row]
		
		if IsNull(ls_cencos) or trim(ls_cencos) = '' then
			MessageBox('Error', 'Debe especificar un centro de costos', StopSign!)
			this.setColumn('cencos')
			return
		end if
		
		SELECT distinct pc.descripcion
			into :ls_data
		FROM presupuesto_cuenta pc, 
			  presupuesto_partida pp 
		where pp.cnta_prsp = pc.cnta_prsp 
		  and pp.ano = :li_year
		  and pp.cencos = :ls_cencos
		  and pc.flag_estado = '1'
		  and pp.flag_estado <> '0';
		
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cnta_prsp		[row] = gnvo_app.is_null
			this.object.desc_cnta_prsp	[row] = gnvo_app.is_null
			MessageBox('Error', 'Cuenta Presupuestal no existe o no esta activo, por favor verifique', StopSign!)
			return 1
		end if

		this.object.desc_cnta_prsp		[row] = ls_data
		
		of_actualiza_cnta_prsp(row)

	case 'confin'
		SELECT descripcion
		  INTO :ls_data
		  FROM concepto_financiero
		 WHERE confin = :data ;
		 
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Concepto Financiero ' + data + ' No existe o no esta activo, por favor Verifique', StopSign!)
			This.Object.confin [row] = gnvo_app.is_null
			Return 1
		end if
		
		This.object.desc_confin [row] = ls_data
		
		of_actualiza_confin(row)
		
END CHOOSE
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_fi366_dpd_masivo
integer y = 112
integer width = 3680
integer height = 760
string dataobject = "d_abc_dpd_masivos_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_insert_pre;call super::ue_insert_pre;Date 		ld_fec_emision
String	ls_desc_forma_pago

ld_fec_emision = Date(gnvo_app.of_fecha_Actual())

this.object.fec_registro		[al_row] = gnvo_app.of_fecha_Actual()
this.object.cod_usr				[al_row] = gs_user
this.object.fec_emision			[al_row] = ld_fec_emision
this.object.fec_vencimiento	[al_row] = Date(gnvo_app.of_fecha_Actual())
this.object.flag_control_reg	[al_row] = '1'
this.object.cod_origen			[al_row] = gs_origen
this.object.flag_estado			[al_row] = '1'

select desc_forma_pago
	into :ls_desc_forma_pago
from forma_pago fp
where fp.forma_pago = :gnvo_app.finparam.is_pcon;

this.object.forma_pago			[al_row] = gnvo_app.finparam.is_pcon
this.object.desc_forma_pago	[al_row] = ls_desc_forma_pago
This.Object.tasa_cambio 		[al_row] = gnvo_app.of_tasa_cambio(ld_fec_emision)

is_action = 'new'
end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "tipo_doc"
		ls_sql = "SELECT TIPO_DOC AS tipo_doc,"&
				 + "DESC_TIPO_DOC AS desc_tipo_doc "&
				 + "FROM VW_FIN_DOC_X_GRUPO_PAGAR" 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_moneda"
		ls_sql = "select m.cod_moneda as codigo_moeda, " &
				 + "m.descripcion as desc_moneda " &
				 + "  from moneda m " &
				 + " where m.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if


	case "forma_pago"
		ls_sql = "select fp.forma_pago as forma_pago, " &
				 + "fp.desc_forma_pago as desc_forma_pago " &
				 + "from forma_pago fp " &
				 + "where fp.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.forma_pago		[al_row] = ls_codigo
			this.object.desc_forma_pago[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;Date	ld_fecha_emision

try 
	CHOOSE CASE dwo.name
		CASE	'fec_emision'
			
			ld_fecha_emision      	= Date(This.Object.fec_emision [row])	
			
		
			//Obteniendo la tasa de cambio
			This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
			
		
								
	
	END CHOOSE
	
catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Ha ocurrido una exception')
	
end try

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

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

type st_1 from statictext within w_fi366_dpd_masivo
integer y = 20
integer width = 3241
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generacion de DPDs Masivos, "
alignment alignment = center!
boolean focusrectangle = false
end type

