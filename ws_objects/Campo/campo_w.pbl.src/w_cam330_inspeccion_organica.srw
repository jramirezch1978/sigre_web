$PBExportHeader$w_cam330_inspeccion_organica.srw
forward
global type w_cam330_inspeccion_organica from w_abc_master
end type
type tab_1 from tab within w_cam330_inspeccion_organica
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detalle from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detalle dw_detalle
end type
type tabpage_2 from userobject within tab_1
end type
type dw_insumos from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_insumos dw_insumos
end type
type tabpage_3 from userobject within tab_1
end type
type dw_produccion from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_produccion dw_produccion
end type
type tabpage_4 from userobject within tab_1
end type
type dw_doc from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_doc dw_doc
end type
type tabpage_5 from userobject within tab_1
end type
type dw_riesgos from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_riesgos dw_riesgos
end type
type tabpage_6 from userobject within tab_1
end type
type dw_mano from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_mano dw_mano
end type
type tabpage_7 from userobject within tab_1
end type
type dw_diag from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_diag dw_diag
end type
type tabpage_8 from userobject within tab_1
end type
type dw_lindero from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_lindero dw_lindero
end type
type tab_1 from tab within w_cam330_inspeccion_organica
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type
end forward

global type w_cam330_inspeccion_organica from w_abc_master
integer width = 3337
integer height = 3280
string title = "[CM330] Inspección Orgánica"
string menuname = "m_abc_anular_lista"
tab_1 tab_1
end type
global w_cam330_inspeccion_organica w_cam330_inspeccion_organica

type variables
u_dw_abc idw_detalle, idw_insumos, idw_produccion, idw_doc, idw_riesgos, &
			idw_mano, idw_diag, idw_lindero
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
end prototypes

public subroutine of_asigna_dws ();idw_detalle 			= tab_1.tabpage_1.dw_detalle
idw_insumos 		= tab_1.tabpage_2.dw_insumos
idw_produccion 	= tab_1.tabpage_3.dw_produccion
idw_doc 				= tab_1.tabpage_4.dw_doc
idw_riesgos			= tab_1.tabpage_5.dw_riesgos
idw_mano			= tab_1.tabpage_6.dw_mano
idw_diag				= tab_1.tabpage_7.dw_diag
idw_lindero			= tab_1.tabpage_8.dw_lindero
end subroutine

public function integer of_set_numera ();// Numera documento
Long 	ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE NUM_SIC_ORGANICO_INSP IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_ORGANICO_INSP
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_SIC_ORGANICO_INSP (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		ll_ult_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))

	dw_master.object.nro_test[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update NUM_SIC_ORGANICO_INSP 
		set ult_nro = ult_nro + 1
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_test[dw_master.getrow()] 
end if

// Asigna numero a detalle
dw_master.object.nro_test[dw_master.getrow()] = ls_nro
for ll_j = 1 to idw_detalle.RowCount()	
	idw_detalle.object.nro_test		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_insumos.RowCount()	
	idw_insumos.object.nro_test		[ll_j] = ls_nro	
next
for ll_j = 1 to idw_produccion.RowCount()	
	idw_produccion.object.nro_test		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_doc.RowCount()	
	idw_doc.object.nro_test	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_riesgos.RowCount()	
	idw_riesgos.object.nro_test	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_diag.RowCount()	
	idw_diag.object.nro_test		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_lindero.RowCount()	
	idw_lindero.object.nro_test	[ll_j] = ls_nro	
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_detalle.retrieve(as_nro)
	idw_insumos.retrieve(as_nro)
	idw_produccion.retrieve(as_nro)
	idw_doc.retrieve(as_nro)
	idw_riesgos.retrieve(as_nro)
	idw_mano.retrieve(as_nro)
	idw_diag.retrieve(as_nro)
	idw_lindero.retrieve(as_nro)
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detalle.ii_protect = 0
	idw_detalle.ii_update	= 0
	idw_detalle.of_protect()
	idw_detalle.ResetUpdate()
	
	idw_insumos.ii_protect = 0
	idw_insumos.ii_update	= 0
	idw_insumos.of_protect()
	idw_insumos.ResetUpdate()

	idw_produccion.ii_protect = 0
	idw_produccion.ii_update	= 0
	idw_produccion.of_protect()
	idw_produccion.ResetUpdate()
	
	idw_doc.ii_protect = 0
	idw_doc.ii_update	= 0
	idw_doc.of_protect()
	idw_doc.ResetUpdate()
	
	idw_riesgos.ii_protect = 0
	idw_riesgos.ii_update	= 0
	idw_riesgos.of_protect()
	idw_riesgos.ResetUpdate()
	
	idw_mano.ii_protect = 0
	idw_mano.ii_update	= 0
	idw_mano.of_protect()
	idw_mano.ResetUpdate()
	
	idw_diag.ii_protect = 0
	idw_diag.ii_update	= 0
	idw_diag.of_protect()
	idw_diag.ResetUpdate()
	
	idw_lindero.ii_protect = 0
	idw_lindero.ii_update	= 0
	idw_lindero.of_protect()
	idw_lindero.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detalle.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.x - 10
idw_detalle.height = tab_1.tabpage_1.height  - tab_1.tabpage_1.y - 10

idw_insumos.width  = tab_1.tabpage_2.width  - tab_1.tabpage_2.x - 10
idw_insumos.height = tab_1.tabpage_2.height  - tab_1.tabpage_2.y - 10

idw_produccion.width  = tab_1.tabpage_3.width  - tab_1.tabpage_3.x - 10
idw_produccion.height = tab_1.tabpage_3.height  - tab_1.tabpage_3.y - 10

idw_doc.width  = tab_1.tabpage_4.width  - tab_1.tabpage_4.x - 10
idw_doc.height = tab_1.tabpage_4.height  - tab_1.tabpage_4.y - 10

idw_riesgos.width  = tab_1.tabpage_5.width  - tab_1.tabpage_5.x - 10
idw_riesgos.height = tab_1.tabpage_5.height  - tab_1.tabpage_5.y - 10

idw_mano.width  = tab_1.tabpage_6.width  - tab_1.tabpage_6.x - 10
idw_mano.height = tab_1.tabpage_6.height  - tab_1.tabpage_6.y - 10

idw_diag.width  = tab_1.tabpage_7.width  - tab_1.tabpage_7.x - 10
idw_diag.height = tab_1.tabpage_7.height  - tab_1.tabpage_7.y - 10

idw_lindero.width  = tab_1.tabpage_8.width  - tab_1.tabpage_8.x - 10
idw_lindero.height = tab_1.tabpage_8.height  - tab_1.tabpage_8.y - 10

end event

on w_cam330_inspeccion_organica.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_cam330_inspeccion_organica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)

dw_master.AcceptText()
idw_detalle.AcceptText()
idw_insumos.AcceptText()
idw_produccion.AcceptText()
idw_doc.AcceptText()
idw_riesgos.AcceptText()
idw_mano.AcceptText()
idw_diag.AcceptText()
idw_lindero.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detalle.of_create_log()
	idw_insumos.of_create_log()
	idw_produccion.of_create_log()
	idw_doc.of_create_log()
	idw_riesgos.of_create_log()
	idw_mano.of_create_log()
	idw_diag.of_create_log()
	idw_lindero.of_create_log()
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF idw_detalle.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detalle.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF
IF idw_insumos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_insumos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_insumos", ls_msg, StopSign!)
	END IF
END IF

IF idw_produccion.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_produccion.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_produccion", ls_msg, StopSign!)
	END IF
END IF

IF idw_doc.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_doc.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Registro de idw_doc", ls_msg, StopSign!)
	END IF
END IF
IF idw_riesgos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_riesgos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_riesgos", ls_msg, StopSign!)
	END IF
END IF

IF idw_mano.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_mano.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_mano", ls_msg, StopSign!)
	END IF
END IF
IF idw_diag.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_diag.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_diag", ls_msg, StopSign!)
	END IF
END IF
IF idw_lindero.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_lindero.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_lindero", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_detalle.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_insumos.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_produccion.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_doc.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_riesgos.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_mano.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_diag.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_lindero.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detalle.ii_update = 0
	idw_insumos.ii_update = 0
	idw_produccion.ii_update = 0
	idw_doc.ii_update = 0
	idw_riesgos.ii_update = 0
	idw_mano.ii_update = 0
	idw_diag.ii_update = 0
	idw_lindero.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detalle.il_totdel = 0
	idw_insumos.il_totdel = 0
	idw_produccion.il_totdel = 0
	idw_doc.il_totdel = 0
	idw_riesgos.il_totdel = 0
	idw_mano.il_totdel = 0
	idw_diag.il_totdel = 0
	idw_lindero.il_totdel = 0
		
	dw_master.ResetUpdate()
	idw_detalle.ResetUpdate()
	idw_insumos.ResetUpdate()
	idw_produccion.ResetUpdate()
	idw_doc.ResetUpdate()
	idw_riesgos.ResetUpdate()
	idw_mano.ResetUpdate()
	idw_diag.ResetUpdate()
	idw_lindero.ResetUpdate()

	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_test[dw_master.getRow()])
	end if
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detalle, idw_detalle.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_insumos, idw_insumos.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_produccion, idw_produccion.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_doc, idw_doc.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_riesgos, idw_riesgos.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_mano, idw_mano.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_diag, idw_diag.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_lindero, idw_lindero.is_dwform) <> true then	return

//AutoNumeración de Registro
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detalle.of_set_flag_replicacion()
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_insp_organica'
sl_param.titulo = 'Registro de Inspecciones Orgánicas'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;//Override
Long  ll_row

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then
		MessageBox('Error', 'No esta permitido insertar un detalle de Cuaderno del productor sin antes haber insertado la cabecera, por favor verifique')
		return
	elseif f_row_Processing( dw_master, dw_master.is_dwform) <> true then	
		return
	end if
end if


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;idw_detalle.of_protect()
idw_insumos.of_protect()
idw_produccion.of_protect()
idw_doc.of_protect()
idw_riesgos.of_protect()
idw_mano.of_protect()
idw_diag.of_protect()
idw_lindero.of_protect()
end event

type dw_master from w_abc_master`dw_master within w_cam330_inspeccion_organica
integer width = 3150
integer height = 1008
string dataobject = "d_abc_sic_organico_cab"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

this.object.fec_registro 		[al_row] = ldt_fec_oracle
this.object.fec_inspeccion	[al_row] = Date(ldt_fec_oracle)
this.object.cod_usr			[al_row] = gs_user

is_action = 'new'
end event

event dw_master::constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  idw_detalle

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "nro_certificacion"
		ls_sql = "SELECT a.nro_certificacion AS certificacion_productor, " &
				 + "a.has as area_has, " &
				 + "p.nro_doc_ident AS nro_doc_ident, " &
				 + "p.nom_proveedor AS nombre_productor, " &
				 + "p.ruc AS ruc_productor " &
				 + "FROM AP_PROVEEDOR_CERTIF a, " &
				 +"      ap_proveedor_mp mp, " &
				 + "     proveedor p " &
				 + "WHERE a.proveedor = p.proveedor " &
				 + "  and a.proveedor = mp.proveedor " &
				 + "  and p.FLAG_ESTADO = '1' " &
				 + "  and mp.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.nro_certificacion	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data3
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "nro_certificacion"

		SELECT p.nom_proveedor 
				into :ls_desc1
			FROM AP_PROVEEDOR_CERTIF a, 
				 	ap_proveedor_mp mp, 
				     proveedor p 
				 WHERE a.proveedor = p.proveedor 
				 and a.nro_certificacion = :data
				 and a.proveedor = mp.proveedor 
				 and p.FLAG_ESTADO = '1' 
				 and mp.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Numero de Certificado o el productor no se encuentra activo, por favor verifique")
			this.object.nro_certificacion	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			return 1
		end if
		
	this.object.nro_certificacion	[row] = data
	this.object.nom_proveedor		[row] = ls_desc1
	
END CHOOSE
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_cam330_inspeccion_organica
integer y = 1016
integer width = 3232
integer height = 1968
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Control de Volumen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detalle dw_detalle
end type

on tabpage_1.create
this.dw_detalle=create dw_detalle
this.Control[]={this.dw_detalle}
end on

on tabpage_1.destroy
destroy(this.dw_detalle)
end on

type dw_detalle from u_dw_abc within tabpage_1
integer width = 2153
integer height = 1360
integer taborder = 20
string dataobject = "d_abc_sic_organico_det"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)
this.object.semana 		[al_row] = 0
this.object.racimos_cos 	[al_row] = 0
this.object.cajas_proc 	[al_row] = 0
this.object.coherente		[al_row] = 'S'
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 	dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;choose case dwo.name
	case 'racimos_cos'
			this.object.ratiun [row] = integer( this.object.cajas_proc [row]) / integer(data)
	case 'cajas_proc'
		this.object.ratiun [row] = integer( data) / integer(this.object.racimos_cos [row])
end choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Insumos Aplicados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_insumos dw_insumos
end type

on tabpage_2.create
this.dw_insumos=create dw_insumos
this.Control[]={this.dw_insumos}
end on

on tabpage_2.destroy
destroy(this.dw_insumos)
end on

type dw_insumos from u_dw_abc within tabpage_2
integer width = 2162
integer height = 1224
string dataobject = "d_abc_sic_org_insumos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cantidad			[al_row] = 0
this.object.fec_aplicacion		[al_row] = Date(f_fecha_actual())


end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "und"
		ls_sql = "SELECT a.und AS codigo_unidad, " &
				 + "a.desc_unidad as desc_unidad, " &
				 + "a.tipo_und AS tipo_und, " &
				 + "a.flag_estado AS flag_estado " &
				 + "FROM unidad a " &
				 + "WHERE a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE lower(dwo.name)

	case "und"

		SELECT a.desc_unidad 
				into :ls_desc1
			FROM unidad a
				 WHERE a.und = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Unidad")
			this.object.und		[row] = ls_null
			return 1
		end if
		
	this.object.unidad	[row] = data
	
END CHOOSE
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Producción Paralela y/o Mixta"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_produccion dw_produccion
end type

on tabpage_3.create
this.dw_produccion=create dw_produccion
this.Control[]={this.dw_produccion}
end on

on tabpage_3.destroy
destroy(this.dw_produccion)
end on

type dw_produccion from u_dw_abc within tabpage_3
integer width = 2199
integer height = 1108
integer taborder = 30
string dataobject = "d_abc_sic_org_produccion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.area					[al_row] = 0

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Documentación Disponible"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_doc dw_doc
end type

on tabpage_4.create
this.dw_doc=create dw_doc
this.Control[]={this.dw_doc}
end on

on tabpage_4.destroy
destroy(this.dw_doc)
end on

type dw_doc from u_dw_abc within tabpage_4
integer width = 1664
integer height = 1108
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_sic_org_documentacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.act_diaria			[al_Row] = '1'
this.object.adq_insumo		[al_Row] = '1'
this.object.control_fito			[al_Row] = '1'
this.object.cos_com			[al_Row] = '1'
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Riesgos Indirectos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_riesgos dw_riesgos
end type

on tabpage_5.create
this.dw_riesgos=create dw_riesgos
this.Control[]={this.dw_riesgos}
end on

on tabpage_5.destroy
destroy(this.dw_riesgos)
end on

type dw_riesgos from u_dw_abc within tabpage_5
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_org_riesgos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.uso_proh			[al_Row] = '1'
this.object.endose				[al_Row] = '1'
this.object.contaminacion	[al_Row] = '1'
this.object.agua_riego		[al_Row] = '1'
this.object.agua_proce		[al_Row] = '1'
this.object.almacen			[al_Row] = '1'
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Mano de Obra"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_mano dw_mano
end type

on tabpage_6.create
this.dw_mano=create dw_mano
this.Control[]={this.dw_mano}
end on

on tabpage_6.destroy
destroy(this.dw_mano)
end on

type dw_mano from u_dw_abc within tabpage_6
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_org_mano_obra_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.nro_jor_fam	[al_row] = 0
this.object.nro_jor_tmp	[al_row] = 0
this.object.nro_jor_per	[al_row] = 0

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Diagnóstico de la Finca"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_diag dw_diag
end type

on tabpage_7.create
this.dw_diag=create dw_diag
this.Control[]={this.dw_diag}
end on

on tabpage_7.destroy
destroy(this.dw_diag)
end on

type dw_diag from u_dw_abc within tabpage_7
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_org_diagnostico_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2345
integer height = 1936
long backcolor = 79741120
string text = "Linderos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_lindero dw_lindero
end type

on tabpage_8.create
this.dw_lindero=create dw_lindero
this.Control[]={this.dw_lindero}
end on

on tabpage_8.destroy
destroy(this.dw_lindero)
end on

type dw_lindero from u_dw_abc within tabpage_8
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_org_lindero_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
end event

