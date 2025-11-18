$PBExportHeader$w_cam303_parte_molienda.srw
forward
global type w_cam303_parte_molienda from w_abc
end type
type tab_1 from tab within w_cam303_parte_molienda
end type
type tabciclos from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabciclos
end type
type tabciclos from userobject within tab_1
dw_detail dw_detail
end type
type tab_1 from tab within w_cam303_parte_molienda
tabciclos tabciclos
end type
type dw_master from u_dw_abc within w_cam303_parte_molienda
end type
end forward

global type w_cam303_parte_molienda from w_abc
integer width = 2811
integer height = 2392
string title = "[CAM303] Parte de Molienda"
string menuname = "m_abc_anular_lista"
tab_1 tab_1
dw_master dw_master
end type
global w_cam303_parte_molienda w_cam303_parte_molienda

type variables
u_dw_abc 			idw_detail
String      		is_tabla_m, is_tabla_d, is_tabla_dd, &
						is_colname_m[],is_coltype_m[], &
						is_colname_d[],is_coltype_d[], &
						is_colname_dd[],is_coltype_dd[], &
						is_soles, is_azc_blanca = '034001.0001', is_azc_rubia='034001.0002'
n_cst_log_diario	in_log
u_ds_base			ids_formulas
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public function integer of_nro_ciclo (u_dw_abc adw_1)
public function boolean of_get_formula (integer ai_reckey)
public function boolean of_aplicar_formulas (long al_row)
public function decimal of_get_bolsas ()
end prototypes

public subroutine of_asigna_dws ();idw_detail = tab_1.tabciclos.dw_detail

end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from NUM_CAMPO_MOLIENDA
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE NUM_CAMPO_MOLIENDA IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into NUM_CAMPO_MOLIENDA(origen, ult_nro)
		values( :gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_CAMPO_MOLIENDA
	where origen = :gs_origen for update;
	
	update NUM_CAMPO_MOLIENDA
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.COD_MOLIENDA[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.COD_MOLIENDA[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to idw_detail.RowCount()
	idw_detail.object.COD_MOLIENDA[ll_j] = ls_next_nro
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

dw_master.retrieve(as_nro)
is_action = 'open'

if dw_master.RowCount() > 0 then
	// Fuerza a leer detalle
	idw_detail.retrieve(as_nro)
	
	if idw_detail.RowCount() > 0 then
		idw_detail.il_row = 1
		idw_detail.SelectRow(0, false)
		idw_detail.SelectRow(idw_detail.il_Row, true)
		idw_detail.SetRow(1)
	end if
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detail.ii_protect = 0
	idw_detail.ii_update	= 0
	idw_detail.of_protect()
	idw_detail.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	
	if dw_master.object.flag_estado[dw_master.getRow()] <> '1' then
		dw_master.object.b_formulas.enabled = "no"
	else
		dw_master.object.b_formulas.enabled = "yes"
	end if
	
	if of_get_formula(Integer(dw_master.object.reckey_formula[dw_master.getRow()])) then return
	
	is_action = 'open'
end if

return 
end subroutine

public function integer of_nro_ciclo (u_dw_abc adw_1);string 	ls_nro_lote
Long 		ll_i, ll_nro_ciclo

ls_nro_lote = adw_1.object.nro_lote [adw_1.getRow()]

ll_nro_ciclo = 0
for ll_i = 1 to adw_1.RowCount()
	if adw_1.object.nro_lote [ll_i] = ls_nro_lote and ll_i <> adw_1.getRow() then
		ll_nro_ciclo = Long(adw_1.object.nro_ciclo[ll_i])
	end if
next

return ll_nro_ciclo + 1
end function

public function boolean of_get_formula (integer ai_reckey);ids_formulas.retrieve(ai_reckey)

if ids_formulas.RowCount() = 0 then
	MessageBox('Error', 'No existen formulas para el reckey ' + string(ai_reckey))
	return false
end if

//Cant_Bruta
if ids_formulas.object.flag_cant_bruta [ids_formulas.getRow()] = 'D' then
	dw_master.object.cant_bruta.EditMask.ReadOnly = "Yes"
	dw_master.object.cant_bruta.EditMask.Spin 	 = "no"
	dw_master.Object.cant_bruta.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.cant_bruta.EditMask.ReadOnly = "no"
	dw_master.object.cant_bruta.EditMask.Spin 	 = "yes"
	dw_master.Object.cant_bruta.Background.Color  = RGB(255, 255, 255)
end if

//Cant_Neta
if ids_formulas.object.flag_cant_neta [ids_formulas.getRow()] = 'D' then
	dw_master.object.cant_neta.EditMask.ReadOnly = "Yes"
	dw_master.object.cant_neta.EditMask.Spin 	 = "no"
	dw_master.Object.cant_neta.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.cant_neta.EditMask.ReadOnly = "no"
	dw_master.object.cant_neta.EditMask.Spin 	 = "yes"
	dw_master.Object.cant_neta.Background.Color  = RGB(255, 255, 255)
end if

//Impureza
if ids_formulas.object.flag_impureza [ids_formulas.getRow()] = 'D' then
	dw_master.object.impureza.EditMask.ReadOnly = "Yes"
	dw_master.object.impureza.EditMask.Spin 	 = "no"
	dw_master.Object.impureza.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.impureza.EditMask.ReadOnly = "no"
	dw_master.object.impureza.EditMask.Spin 	 = "yes"
	dw_master.Object.impureza.Background.Color  = RGB(255, 255, 255)
end if

//Brix
if ids_formulas.object.flag_brix [ids_formulas.getRow()] = 'D' then
	dw_master.object.brix.EditMask.ReadOnly = "Yes"
	dw_master.object.brix.EditMask.Spin 	 = "no"
	dw_master.Object.brix.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.brix.EditMask.ReadOnly = "no"
	dw_master.object.brix.EditMask.Spin 	 = "yes"
	dw_master.Object.brix.Background.Color  = RGB(255, 255, 255)
end if

//Pol
if ids_formulas.object.flag_pol [ids_formulas.getRow()] = 'D' then
	dw_master.object.pol.EditMask.ReadOnly = "Yes"
	dw_master.object.pol.EditMask.Spin 	 = "no"
	dw_master.Object.pol.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.pol.EditMask.ReadOnly = "no"
	dw_master.object.pol.EditMask.Spin 	 = "yes"
	dw_master.Object.pol.Background.Color  = RGB(255, 255, 255)
end if

//Pureza
if ids_formulas.object.flag_pureza [ids_formulas.getRow()] = 'D' then
	dw_master.object.pureza.EditMask.ReadOnly = "Yes"
	dw_master.object.pureza.EditMask.Spin 	 = "no"
	dw_master.Object.pureza.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.pureza.EditMask.ReadOnly = "no"
	dw_master.object.pureza.EditMask.Spin 	 = "yes"
	dw_master.Object.pureza.Background.Color  = RGB(255, 255, 255)
end if

//Caña
if ids_formulas.object.flag_cana [ids_formulas.getRow()] = 'D' then
	dw_master.object.pol_cana.EditMask.ReadOnly = "Yes"
	dw_master.object.pol_cana.EditMask.Spin 	 = "no"
	dw_master.Object.pol_cana.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.pol_cana.EditMask.ReadOnly = "no"
	dw_master.object.pol_cana.EditMask.Spin 	 = "yes"
	dw_master.Object.pol_cana.Background.Color  = RGB(255, 255, 255)
end if

//Jaba
if ids_formulas.object.flag_jaba [ids_formulas.getRow()] = 'D' then
	dw_master.object.jaba.EditMask.ReadOnly = "Yes"
	dw_master.object.jaba.EditMask.Spin 	 = "no"
	dw_master.Object.jaba.Background.Color  = RGB(128, 128, 128)

else
	dw_master.object.jaba.EditMask.ReadOnly = "no"
	dw_master.object.jaba.EditMask.Spin 	 = "yes"
	dw_master.Object.jaba.Background.Color  = RGB(255, 255, 255)
end if

//Quintales
if ids_formulas.object.flag_quintales [ids_formulas.getRow()] = 'D' then
	dw_master.object.quintales.EditMask.ReadOnly  = "yes"
	dw_master.object.quintales.EditMask.Spin 	 	 = "no"
	dw_master.Object.quintales.Background.Color   = RGB(128, 128, 128)
else
	dw_master.object.quintales.EditMask.ReadOnly  = "no"
	dw_master.object.quintales.EditMask.Spin 	    = "yes"
	dw_master.Object.quintales.Background.Color   = RGB(255, 255, 255)
end if

//Bolsas
if ids_formulas.object.flag_bolsas [ids_formulas.getRow()] = 'D' then
	dw_master.object.bolsas.EditMask.ReadOnly  = "yes"
	dw_master.object.bolsas.EditMask.Spin 	 	 = "no"
	dw_master.Object.bolsas.Background.Color   = RGB(128, 128, 128)
else
	dw_master.object.bolsas.EditMask.ReadOnly  = "no"
	dw_master.object.bolsas.EditMask.Spin 	    = "yes"
	dw_master.Object.bolsas.Background.Color   = RGB(255, 255, 255)
end if

//Bls Neto
if ids_formulas.object.flag_bls_neto [ids_formulas.getRow()] = 'D' then
	dw_master.object.bolsas_netas.EditMask.ReadOnly  = "yes"
	dw_master.object.bolsas_netas.EditMask.Spin 	 	 = "no"
	dw_master.Object.bolsas_netas.Background.Color   = RGB(128, 128, 128)
else
	dw_master.object.bolsas_netas.EditMask.ReadOnly  = "no"
	dw_master.object.bolsas_netas.EditMask.Spin 	    = "yes"
	dw_master.Object.bolsas_netas.Background.Color   = RGB(255, 255, 255)
end if

//Bls Total
if ids_formulas.object.flag_bls_total [ids_formulas.getRow()] = 'D' then
	dw_master.object.bolsas_total.EditMask.ReadOnly  = "yes"
	dw_master.object.bolsas_total.EditMask.Spin 	 	 = "no"
	dw_master.Object.bolsas_total.Background.Color   = RGB(128, 128, 128)
else
	dw_master.object.bolsas_total.EditMask.ReadOnly  = "no"
	dw_master.object.bolsas_total.EditMask.Spin 	    = "yes"
	dw_master.Object.bolsas_total.Background.Color   = RGB(255, 255, 255)
end if

//Melaza
if ids_formulas.object.flag_melaza [ids_formulas.getRow()] = 'D' then
	dw_master.object.melaza.EditMask.ReadOnly  = "yes"
	dw_master.object.melaza.EditMask.Spin 	 	 = "no"
	dw_master.Object.melaza.Background.Color   = RGB(128, 128, 128)
else
	dw_master.object.melaza.EditMask.ReadOnly  = "no"
	dw_master.object.melaza.EditMask.Spin 	    = "yes"
	dw_master.Object.melaza.Background.Color   = RGB(255, 255, 255)
end if

//Kg/TMC
if ids_formulas.object.flag_kgs_tmc [ids_formulas.getRow()] = 'D' then
	dw_master.object.kg_tmc.EditMask.ReadOnly  = "yes"
	dw_master.object.kg_tmc.EditMask.Spin 	 	 = "no"
	dw_master.Object.kg_tmc.Background.Color   = RGB(128, 128, 128)
else
	dw_master.object.kg_tmc.EditMask.ReadOnly  = "no"
	dw_master.object.kg_tmc.EditMask.Spin 	    = "yes"
	dw_master.Object.kg_tmc.Background.Color   = RGB(255, 255, 255)
end if

return true
end function

public function boolean of_aplicar_formulas (long al_row);String 	ls_flag, ls_formula, ls_ret

Long 		ll_row

if ids_formulas.RowCount() = 0 then
	MessageBox('Error', 'No se ha especificado ninguna formula para el reckey indicado')
	return false
end if

for ll_row = 1 to ids_formulas.RowCount()
	//Cantidad Bruta
	ls_flag 		= ids_formulas.object.flag_cant_bruta[ll_row]
	ls_formula 	= ids_formulas.object.form_cant_bruta[ll_row]
	
	if ls_flag = 'C' then
		ls_ret = dw_master.Describe("Evaluate('" + ls_formula + "', " + String(dw_master.getRow()) + ")")
		if ls_ret = "!" then
			MessageBox('Error', "Error en la formula: '" + ls_formula + "', campo flag_cant_bruta")
			return false
		else
			dw_master.object.cant_bruta[dw_master.getRow()] = ls_ret
		end if
		
	end if
	
	//Cantidad Neta
	ls_flag 		= ids_formulas.object.flag_cant_neta[ll_row]
	ls_formula 	= ids_formulas.object.form_cant_neta[ll_row]
	
	if ls_flag = 'C' then
		ls_ret = dw_master.Describe("Evaluate('" + ls_formula + "', " + String(dw_master.getRow()) + ")")
		if ls_ret = "!" then
			MessageBox('Error', "Error en la formula: '" + ls_formula + "', campo flag_cant_neta")
			return false
		else
			dw_master.object.cant_neta[dw_master.getRow()] = Dec(ls_ret)
		end if
	end if
	
	//Jabas
	ls_flag 		= ids_formulas.object.flag_jaba[ll_row]
	ls_formula 	= ids_formulas.object.form_jaba[ll_row]
	
	if ls_flag = 'C' then
		ls_ret = dw_master.Describe("Evaluate('" + ls_formula + "', " + String(dw_master.getRow()) + ")")
		if ls_ret = "!" then
			MessageBox('Error', "Error en la formula: '" + ls_formula + "', campo flag_jaba")
			return false
		else
			dw_master.object.jaba[dw_master.getRow()] = Dec(ls_ret)
		end if
	end if

	//Melaza
	ls_flag 		= ids_formulas.object.flag_melaza[ll_row]
	ls_formula 	= ids_formulas.object.form_melaza[ll_row]
	
	if ls_flag = 'C' then
		ls_ret = dw_master.Describe("Evaluate('" + ls_formula + "', " + String(dw_master.getRow()) + ")")
		if ls_ret = "!" then
			MessageBox('Error', "Error en la formula: '" + ls_formula + "', campo flag_melaza")
			return false
		else
			dw_master.object.melaza[dw_master.getRow()] = Dec(ls_ret)
		end if
	end if
	
	// Kg/TM
	ls_flag 		= ids_formulas.object.flag_kgs_tmc[ll_row]
	ls_formula 	= ids_formulas.object.form_kgs_tmc[ll_row]
	
	if ls_flag = 'C' then
		ls_ret = dw_master.Describe("Evaluate('" + ls_formula + "', " + String(dw_master.getRow()) + ")")
		if ls_ret = "!" then
			MessageBox('Error', "Error en la formula: '" + ls_formula + "', campo flag_kg_tmc")
			return false
		else
			dw_master.object.kg_tmc[dw_master.getRow()] = Dec(ls_ret)
		end if
	end if

next

return true
end function

public function decimal of_get_bolsas ();Decimal 	ldc_bolsas, ldc_acum = 0, ldc_ret
Long		ll_row

ldc_bolsas = Dec(dw_master.object.bolsas [dw_master.getRow()])

for ll_row = 1 to idw_detail.RowCount()
	ldc_acum += Dec(idw_detail.object.cant_recibida[ll_row])
next

ldc_ret = ldc_bolsas - ldc_acum

if ldc_ret < 0 then ldc_ret = 0

return ldc_ret
end function

on w_cam303_parte_molienda.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_cam303_parte_molienda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;of_asigna_dws( )

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width  = tab_1.tabciclos.width  - idw_detail.x - 10
idw_detail.height = tab_1.tabciclos.height - idw_detail.y - 10


end event

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1 = dw_master then
	THIS.EVENT ue_update_request()
	IF ib_update_check = FALSE THEN RETURN
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws( )

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
idw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

dw_master.of_protect()         		// bloquear modificaciones 
idw_detail.of_protect()

is_tabla_m = dw_master.Object.Datawindow.Table.UpdateTable
is_tabla_d = idw_detail.Object.Datawindow.Table.UpdateTable

ib_log = true

//Parametros Iniciales
select cod_soles
	into :is_soles
from logparam
where reckey = '1';
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

//Verifica que exista detalle en el documento
if idw_detail.RowCount() = 0 then
	MessageBox('Error', 'Debe Ingresar un detalle en el documento para poder grabar')
	return
end if

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detail, dw_master.is_dwform) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()

if of_set_numera	() = 0 then return


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
	in_log.of_create_log(idw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
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

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
		IF lds_log_d.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Detalle')
		END IF

	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	
	if dw_master.getRow() <> 0 then of_retrieve(dw_master.object.cod_molienda[dw_master.getRow()])
	
	is_action='open'
END IF

end event

event close;call super::close;Destroy in_log
Destroy ids_formulas
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(idw_detail, is_colname_d, is_coltype_d)
END IF

ids_formulas = create u_ds_base
ids_formulas.DataObject = 'd_campo_formulas_tbl'
ids_formulas.SetTransObject(SQLCA)

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_parte_molienda_tbl'
sl_param.titulo = 'Partes de Molienda'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_modify;call super::ue_modify;if dw_master.object.flag_estado[dw_master.getRow()] <> '1' then
	MessageBox('Error', 'Este parte de molienda no se puede editar, por favor verificar')	
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	idw_detail.ii_protect = 0
	idw_detail.of_protect()
	
	return
end if

dw_master.of_protect()
idw_detail.of_protect()

if is_action <> 'new' then is_action = 'open'
end event

event ue_anular;call super::ue_anular;
if is_action = 'new' or is_action='edit' then
	MessageBox('Aviso', 'No puede anular este movimiento de almacen, debe grabarlo primero')
	return
end if

IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No se puede anular este parte de Riego')
	return
end if

// Si el movimiento de Almacen tiene como referencia
// a una Guia de Recepcion de MP no lo debo anular
if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	
	MessageBox('Aviso', 'No se puede anular este documento ya que no esta activo')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	idw_detail.ii_protect = 0
	idw_detail.of_protect()
	
end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.object.b_formulas.enabled = "no"
dw_master.ii_update = 1

is_action = 'anu'

end event

type tab_1 from tab within w_cam303_parte_molienda
integer y = 1488
integer width = 2656
integer height = 688
integer taborder = 20
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
tabciclos tabciclos
end type

on tab_1.create
this.tabciclos=create tabciclos
this.Control[]={this.tabciclos}
end on

on tab_1.destroy
destroy(this.tabciclos)
end on

type tabciclos from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2619
integer height = 560
long backcolor = 79741120
string text = "Detalle del Parte de Molienda"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabciclos.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabciclos.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabciclos
integer width = 2565
integer height = 1016
integer taborder = 20
string dataobject = "d_abc_parte_molienda_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 				[al_row] = gs_user
this.object.cod_origen			[al_row] = gs_origen
this.object.nro_item			 	[al_row] = f_numera_item(this)
this.object.cod_moneda		 	[al_row] = is_soles
this.object.cant_recibida	 	[al_row] = 0.00
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detal
is_dwform = 'tabular'

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

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
return 0
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_data2

choose case lower(as_columna)
	case "cod_moneda"
		
		ls_sql = "SELECT cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda " &
				 + "where FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_moneda			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "almacen"
		
		ls_sql = "SELECT almacen as codigo_almacen, " &
				 + "desc_almacen as descripcion_almacen " &
				 + "from almacen " &
				 + "where FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cod_art"
		
		ls_sql = "SELECT a.cod_art as codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad_articulo " &
				 + "from articulo a " &
				 + "where a.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.cod_art		[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.object.und			[al_row] = ls_data2
			
			if trim(ls_codigo) = is_azc_blanca or trim(ls_Codigo) = is_azc_rubia then
				this.object.cant_recibida [al_row] = of_get_bolsas()
				this.SetColumn("precio_unit")
			else
				this.SetColumn("cant_recibida")
			end if
			
			this.ii_update = 1
		end if


end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_desc1, :ls_desc2
		  from articulo
		 Where cod_art = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Artículo no se encuentra p está inactivo, por favor verifique")
			this.object.cod_art		[row] = ls_null
			this.object.desc_art		[row] = ls_null
			this.object.und			[row] = ls_null
			return 1
			
		end if

		this.object.desc_art	[row] = ls_desc1
		this.object.und		[row] = ls_desc2

	CASE 'almacen'
		
		// Verifica que codigo ingresado exista			
		Select desc_almacen
	     into :ls_desc1
		  from almacen
		 Where almacen = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Almacén no se encuentra p está inactivo, por favor verifique")
			this.object.almacen			[row] = ls_null
			this.object.desc_almacen	[row] = ls_null
			return 1
		end if
		
	CASE 'cod_moneda'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from moneda
		 Where cod_moneda = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Moneda no se encuentra p está inactivo, por favor verifique")
			this.object.cod_moneda			[row] = ls_null
			return 1
		end if

END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)
end event

event ue_output;call super::ue_output;//THIS.EVENT ue_retrieve_det(al_row)


end event

type dw_master from u_dw_abc within w_cam303_parte_molienda
integer width = 2555
integer height = 1480
string dataobject = "d_abc_parte_molienda_cab_ff"
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen		[al_row] = gs_origen
this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro 	[al_row] = f_fecha_actual()
this.object.fec_molienda	[al_row] = Date(f_fecha_actual())
this.object.flag_estado		[al_row] = '1'

this.object.cant_bruta		[al_row] = 0
this.object.cant_neta		[al_row] = 0
this.object.impureza			[al_row] = 0
this.object.brix				[al_row] = 0

this.object.pol				[al_row] = 0
this.object.pureza			[al_row] = 0
this.object.ar					[al_row] = 0
this.object.pol_cana			[al_row] = 0

this.object.jaba				[al_row] = 0
this.object.quintales		[al_row] = 0
this.object.bolsas			[al_row] = 0
this.object.bolsas_netas	[al_row] = 0

this.object.bolsas_total	[al_row] = 0
this.object.melaza			[al_row] = 0
this.object.kg_tmc			[al_row] = 0

idw_detail.Reset()
idw_detail.ResetUpdate()

is_action = 'new'


end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detal
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  idw_detail
is_dwform = 'form'
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

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
return 0
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_ingenio, ls_cod_propietario, ls_nom_propietario
date		ld_fec_molienda

choose case lower(as_columna)
	case "cod_campo"
		ls_sql = "SELECT c.cod_campo AS codigo_campo, " &
				  + "c.desc_campo AS desc_campo, " &
				  + "c.representante as codigo_propietario, " &
				  + "p.nom_proveedor as nombre_propietario " &
				  + "FROM campo c, " &
				  + "proveedor p " &
				  + "WHERE c.representante = p.proveedor (+) " & 
				  + "  and c.FLAG_ESTADO = '1' " 

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_cod_propietario, ls_nom_propietario, '2')

		if ls_codigo <> '' then
			this.object.cod_campo			[al_row] = ls_codigo
			this.object.desc_campo 			[al_row] = ls_data
			this.object.propietario 	 	[al_row] = ls_cod_propietario
			this.object.nom_propietario 	[al_row] = ls_nom_propietario
			this.ii_update = 1
		end if
		
	case "propietario"
		ls_sql = "SELECT p.proveedor AS codigo_propietario, " &
				  + "p.nom_proveedor AS descripcion_propietario, " &
				  + "p.ruc AS ruc_propietario " &
				  + "FROM proveedor p " &
				  + "WHERE p.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.propietario			[al_row] = ls_codigo
			this.object.nom_propietario	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_ingenio"
		ls_sql = "SELECT cod_ingenio AS codigo_ingenio, " &
				  + "desc_ingenio AS descripcion_ingenio " &
				  + "FROM campo_ingenio " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_ingenio		[al_row] = ls_codigo
			this.object.desc_ingenio	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "reckey_formula"
		ls_cod_ingenio = this.object.cod_ingenio [al_row]
		if ls_cod_ingenio = '' or IsNull(ls_cod_ingenio) then
			MessageBox('Error', 'Debe elegir primero un Ingenio')
			this.SetColumn('cod_ingenio')
			return
		end if
		
		ld_fec_molienda   = Date(this.object.fec_molienda [al_row])
		
		ls_sql = "SELECT reckey AS reckey_formula, " &
				  + "desc_formula AS descripcion_formula " &
				  + "FROM campo_formulas " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  and trunc(fec_vigencia) >= to_date('"+ string(ld_fec_molienda, "dd/mm/yyyy") + "', 'dd/mm/yyyy')"
	
	
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			
			this.object.reckey_formula	[al_row] = Integer(ls_codigo)
			this.object.desc_formula	[al_row] = ls_data
			
			
			if of_get_formula(Integer(ls_codigo)) then this.ii_update = 1
			
		end if

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2, ls_cod_ingenio
Date		ld_fec_molienda
Long 		ll_null

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)
SetNull(ll_null)

CHOOSE CASE dwo.name
	case "cod_campo"
		// Verifica que codigo ingresado exista			
		Select desc_campo
	     into :ls_desc1
		  from campo
		 Where cod_campo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Campo no existe o no se encuentra activo, por favor verifique")
			this.object.cod_campo	[row] = ls_null
			this.object.desc_campo	[row] = ls_null
			return 1
			
		end if

		this.object.desc_campo		[row] = ls_desc1
		
	case "propietario"
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_desc1
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Propietario no existe o no se encuentra activo, por favor verifique")
			this.object.propietario			[row] = ls_null
			this.object.nom_propietario	[row] = ls_null
			return 1
			
		end if

		this.object.nom_propietario		[row] = ls_desc1
		
	case "cod_ingenio"
		// Verifica que codigo ingresado exista			
		Select desc_ingenio
	     into :ls_desc1
		  from campo_ingenio
		 Where cod_ingenio = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Ingenio no existe o no se encuentra activo, por favor verifique")
			this.object.cod_ingenio		[row] = ls_null
			this.object.desc_ingenio	[row] = ls_null
			return 1
			
		end if

		this.object.desc_ingenio		[row] = ls_desc1

	case "reckey_formula"
		ls_cod_ingenio = this.object.cod_ingenio [row]
		
		if ls_cod_ingenio = '' or IsNull(ls_cod_ingenio) then
			MessageBox('Error', 'Debe elegir primero un Ingenio')
			this.SetColumn('cod_ingenio')
			return
		end if
		ld_fec_molienda   = Date(this.object.fec_molienda [row])
		
		// Verifica que codigo ingresado exista			
		Select desc_formula
	     into :ls_desc1
		  from campo_formulas
		 Where reckey = :data  
		   and flag_estado = '1'
			and trunc(fec_vigencia) >= trunc(:ld_Fec_molienda);
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Ingenio no existe o no se encuentra activo, por favor verifique")
			this.object.reckey_formula	[row] = ll_null
			this.object.desc_formula	[row] = ls_null
			return 1
			
		end if

		this.object.desc_formula		[row] = ls_desc1
		
	
END CHOOSE
end event

event buttonclicked;call super::buttonclicked;dw_master.Accepttext()

CHOOSE CASE dwo.name
	case "b_formulas"
		// Verifica que codigo ingresado exista			
		of_aplicar_formulas(row)
		
	
		
	
END CHOOSE
end event

