$PBExportHeader$w_pr021_plantilla_costo.srw
forward
global type w_pr021_plantilla_costo from w_abc
end type
type st_nro from statictext within w_pr021_plantilla_costo
end type
type sle_nro from singlelineedit within w_pr021_plantilla_costo
end type
type cb_1 from commandbutton within w_pr021_plantilla_costo
end type
type tab_1 from tab within w_pr021_plantilla_costo
end type
type tabpage_1 from userobject within tab_1
end type
type dw_plant_det from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_plant_det dw_plant_det
end type
type tabpage_2 from userobject within tab_1
end type
type dw_plant_art from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_plant_art dw_plant_art
end type
type tabpage_3 from userobject within tab_1
end type
type dw_plant_ot_adm from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_plant_ot_adm dw_plant_ot_adm
end type
type tabpage_4 from userobject within tab_1
end type
type dw_plant_labor from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_plant_labor dw_plant_labor
end type
type tabpage_5 from userobject within tab_1
end type
type dw_plant_serv from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_plant_serv dw_plant_serv
end type
type tabpage_6 from userobject within tab_1
end type
type dw_plant_benef from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_plant_benef dw_plant_benef
end type
type tab_1 from tab within w_pr021_plantilla_costo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_master from u_dw_abc within w_pr021_plantilla_costo
end type
end forward

global type w_pr021_plantilla_costo from w_abc
integer width = 3008
integer height = 2944
string title = "Plantilla de Costo(PR021)"
string menuname = "m_mantto_lista_smpl"
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_pr021_plantilla_costo w_pr021_plantilla_costo

type variables
u_dw_abc  	idw_plant_det, idw_plant_art, &
				idw_plant_ot_adm, idw_plant_labor, &
				idw_plant_serv, idw_plant_benef

String 	is_tabla_dw1, is_colname_dw1[], is_coltype_dw1[], &
			is_tabla_dw2, is_colname_dw2[], is_coltype_dw2[], &
			is_tabla_dw3, is_colname_dw3[], is_coltype_dw3[], &
			is_tabla_dw4, is_colname_dw4[], is_coltype_dw4[], &
			is_tabla_dw5, is_colname_dw5[], is_coltype_dw5[], &
			is_tabla_dw6, is_colname_dw6[], is_coltype_dw6[], &
			is_tabla_dw7, is_colname_dw7[], is_coltype_dw7[]

n_cst_log_diario	in_log			
end variables

forward prototypes
public subroutine of_retrieve (string as_cod_plantilla)
public subroutine of_asigna_dw ()
public function integer of_set_numera ()
public function integer of_nro_item (datawindow adw_pr)
public function integer of_nro_posicion (datawindow adw_pr)
end prototypes

public subroutine of_retrieve (string as_cod_plantilla);long		ll_nro_item, ll_row
String	ls_old_plantilla

dw_master.Retrieve(as_cod_plantilla)

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()
dw_master.ResetUpdate()

if dw_master.RowCount() = 0 then return

idw_plant_det.Retrieve(as_cod_plantilla)

idw_plant_det.ii_update = 0
idw_plant_det.ii_protect = 0
idw_plant_det.of_protect()
idw_plant_det.ResetUpdate()

if idw_plant_det.RowCount() = 0 then return

idw_plant_det.SetRow(ll_row)
f_select_current_row(idw_plant_det)

ll_nro_item = Long(idw_plant_det.object.nro_item[ll_row])

idw_plant_art.Retrieve(as_cod_plantilla, ll_nro_item)
idw_plant_art.ii_update = 0
idw_plant_art.ii_protect = 0
idw_plant_art.of_protect()
idw_plant_art.ResetUpdate()

idw_plant_ot_adm.Retrieve(as_cod_plantilla, ll_nro_item)
idw_plant_ot_adm.ii_update = 0
idw_plant_ot_adm.ii_protect = 0
idw_plant_ot_adm.of_protect()
idw_plant_ot_adm.ResetUpdate()

idw_plant_labor.Retrieve(as_cod_plantilla, ll_nro_item)
idw_plant_labor.ii_update = 0
idw_plant_labor.ii_protect = 0
idw_plant_labor.of_protect()
idw_plant_labor.ResetUpdate()

idw_plant_serv.Retrieve(as_cod_plantilla, ll_nro_item)
idw_plant_serv.ii_update = 0
idw_plant_serv.ii_protect = 0
idw_plant_serv.of_protect()
idw_plant_serv.ResetUpdate()

idw_plant_benef.Retrieve(as_cod_plantilla, ll_nro_item)
idw_plant_benef.ii_update = 0
idw_plant_benef.ii_protect = 0
idw_plant_benef.of_protect()
idw_plant_benef.ResetUpdate()

is_action = 'open'

end subroutine

public subroutine of_asigna_dw ();idw_plant_det 		= tab_1.tabpage_1.dw_plant_det
idw_plant_art 		= tab_1.tabpage_2.dw_plant_art
idw_plant_ot_adm 	= tab_1.tabpage_3.dw_plant_ot_adm
idw_plant_labor 	= tab_1.tabpage_4.dw_plant_labor
idw_plant_serv 	= tab_1.tabpage_5.dw_plant_serv
idw_plant_benef 	= tab_1.tabpage_6.dw_plant_benef
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_j, ll_nro
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then
	ls_table = 'LOCK TABLE num_plantilla_costo IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_nro 
	from num_plantilla_costo 
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_plantilla_costo (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		ll_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + string(ll_nro, '00000000') 		
	
	dw_master.object.cod_plantilla[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update num_plantilla_costo 
		set ult_nro = ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.cod_plantilla[dw_master.getrow()] 
end if

for ll_j = 1 to idw_plant_det.RowCount()	
	idw_plant_det.object.cod_plantilla [ll_j] = ls_nro	
next

for ll_j = 1 to idw_plant_art.RowCount()	
	idw_plant_art.object.cod_plantilla [ll_j] = ls_nro	
next

for ll_j = 1 to idw_plant_ot_adm.RowCount()	
	idw_plant_ot_adm.object.cod_plantilla [ll_j] = ls_nro	
next

for ll_j = 1 to idw_plant_labor.RowCount()	
	idw_plant_labor.object.cod_plantilla [ll_j] = ls_nro	
next

for ll_j = 1 to idw_plant_serv.RowCount()	
	idw_plant_serv.object.cod_plantilla [ll_j] = ls_nro	
next

for ll_j = 1 to idw_plant_benef.RowCount()	
	idw_plant_benef.object.cod_plantilla [ll_j] = ls_nro	
next

return 1
end function

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pr.RowCount()
	IF li_item < adw_pr.object.nro_item[li_x] THEN
		li_item = adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public function integer of_nro_posicion (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pr.RowCount()
	IF li_item < adw_pr.object.nro_orden[li_x] THEN
		li_item = adw_pr.object.nro_orden[li_x]
	END IF
Next

Return li_item + 10
end function

on w_pr021_plantilla_costo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_lista_smpl" then this.MenuID = create m_mantto_lista_smpl
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_master
end on

on w_pr021_plantilla_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;of_asigna_dw()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_plant_det.width   = tab_1.width  - idw_plant_det.x - 60
idw_plant_det.height  = tab_1.height  - idw_plant_det.y - 190

idw_plant_art.width   = tab_1.width  - idw_plant_art.x - 60
idw_plant_art.height  = tab_1.height  - idw_plant_art.y - 190

idw_plant_ot_adm.width   = tab_1.width  - idw_plant_ot_adm.x - 60
idw_plant_ot_adm.height  = tab_1.height  - idw_plant_ot_adm.y - 190

idw_plant_labor.width   = tab_1.width  - idw_plant_labor.x - 60
idw_plant_labor.height  = tab_1.height  - idw_plant_labor.y - 190

idw_plant_serv.width   = tab_1.width  - idw_plant_serv.x - 60
idw_plant_serv.height  = tab_1.height  - idw_plant_serv.y - 190

idw_plant_benef.width   = tab_1.width  - idw_plant_benef.x - 60
idw_plant_benef.height  = tab_1.height  - idw_plant_benef.y - 190

end event

event open;//Overriding
of_asigna_dw()
IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_insert;call super::ue_insert;Long  	ll_row
String 	ls_flag	

if idw_1 = dw_master then
	if dw_master.ii_update = 1 then
		MessageBox('Aviso', 'No puede insertar una plantilla sin antes grabar')
		return
	end if
	dw_master.Reset()
	
elseif idw_1 = idw_plant_art then
	ll_row = idw_plant_det.GetRow()
	
	if ll_row = 0 then
		MessageBox('Aviso', 'No ha seleccionado ningun registro en el detalle de la plantilla')
		return
	end if
	
	ls_flag = idw_plant_det.object.flag_mat_servicios[ll_row]
	
	if ls_flag <> 'M' or IsNull(ls_flag) then
		MessageBox('Aviso', 'No puede insertar ningun registro aqui, el item no esta configurado para eso')
		return
	end if
	
elseif idw_1 = idw_plant_ot_adm then
	ll_row = idw_plant_det.GetRow()
	
	if ll_row = 0 then
		MessageBox('Aviso', 'No ha seleccionado ningun registro en el detalle de la plantilla')
		return
	end if
	
	ls_flag = idw_plant_det.object.flag_ot_adm[ll_row]
	
	if ls_flag <> '1' then
		MessageBox('Aviso', 'No puede insertar ningun registro aqui, el item no esta configurado para eso')
		return
	end if

elseif idw_1 = idw_plant_labor then
	ll_row = idw_plant_det.GetRow()
	
	if ll_row = 0 then
		MessageBox('Aviso', 'No ha seleccionado ningun registro en el detalle de la plantilla')
		return
	end if
	
	ls_flag = idw_plant_det.object.flag_labor[ll_row]
	
	if ls_flag <> '1' then
		MessageBox('Aviso', 'No puede insertar ningun registro aqui, el item no esta configurado para eso')
		return
	end if
	
elseif idw_1 = idw_plant_serv then
	ll_row = idw_plant_det.GetRow()
	
	if ll_row = 0 then
		MessageBox('Aviso', 'No ha seleccionado ningun registro en el detalle de la plantilla')
		return
	end if
	
	ls_flag = idw_plant_det.object.flag_mat_servicios[ll_row]
	
	if ls_flag <> 'S' or IsNull(ls_flag) then
		MessageBox('Aviso', 'No puede insertar ningun registro aqui, el item no esta configurado para eso')
		return
	end if

elseif idw_1 = idw_plant_benef then
	ll_row = idw_plant_det.GetRow()
	
	if ll_row = 0 then
		MessageBox('Aviso', 'No ha seleccionado ningun registro en el detalle de la plantilla')
		return
	end if
	
	ls_flag = idw_plant_det.object.flag_centro_benef [ll_row]
	
	if ls_flag <> '1' or IsNull(ls_flag) then
		MessageBox('Aviso', 'No puede insertar ningun registro aqui, el item no esta configurado para eso')
		return
	end if

end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_plant_det.SetTransObject(sqlca)
idw_plant_art.SetTransObject(sqlca)
idw_plant_ot_adm.SetTransObject(sqlca)
idw_plant_labor.SetTransObject(sqlca)
idw_plant_serv.SetTransObject(sqlca)
idw_plant_benef.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 
idw_plant_det.of_protect()
idw_plant_art.of_protect()
idw_plant_ot_adm.of_protect()
idw_plant_labor.of_protect()
idw_plant_serv.of_protect()
idw_plant_benef.of_protect()

is_tabla_dw1 = dw_master.Object.Datawindow.Table.UpdateTable
is_tabla_dw2 = idw_plant_det.Object.Datawindow.Table.UpdateTable
is_tabla_dw3 = idw_plant_art.Object.Datawindow.Table.UpdateTable
is_tabla_dw4 = idw_plant_ot_adm.Object.Datawindow.Table.UpdateTable
is_tabla_dw5 = idw_plant_labor.Object.Datawindow.Table.UpdateTable
is_tabla_dw6 = idw_plant_serv.Object.Datawindow.Table.UpdateTable
is_tabla_dw7 = idw_plant_benef.Object.Datawindow.Table.UpdateTable

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update 			= 1 	OR &
	idw_plant_det.ii_update		= 1	OR &
	idw_plant_art.ii_update 	= 1 	OR &
	idw_plant_ot_adm.ii_update = 1 	OR &
	idw_plant_labor.ii_update 	= 1	OR &
	idw_plant_serv.ii_update	= 1	OR &
	idw_plant_benef.ii_update	= 1 	THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 			= 0
		idw_plant_det.ii_update		= 0
		idw_plant_art.ii_update 	= 0
		idw_plant_ot_adm.ii_update = 0
		idw_plant_labor.ii_update 	= 0
		idw_plant_serv.ii_update	= 0
		idw_plant_benef.ii_update 	= 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

dw_master.AcceptText()
idw_plant_det.AcceptText()
idw_plant_art.AcceptText()
idw_plant_ot_adm.AcceptText()
idw_plant_labor.AcceptText()
idw_plant_serv.AcceptText()

If dw_master.RowCount() = 0 then return


if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
end if

if f_row_Processing( idw_plant_det, "tabular") <> true then	
	ib_update_check = False	
	return
end if
if f_row_Processing( idw_plant_art, "tabular") <> true then	
	ib_update_check = False	
	return
end if
if f_row_Processing( idw_plant_ot_adm, "tabular") <> true then	
	ib_update_check = False	
	return
end if
if f_row_Processing( idw_plant_labor, "tabular") <> true then	
	ib_update_check = False	
	return
end if
if f_row_Processing( idw_plant_serv, "tabular") <> true then	
	ib_update_check = False	
	return
end if

if f_row_Processing( idw_plant_benef, "tabular") <> true then	
	ib_update_check = False	
	return
end if

if of_set_numera() = 0 then return


end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
String	ls_plantilla

dw_master.AcceptText()
idw_plant_det.AcceptText()
idw_plant_art.AcceptText()
idw_plant_ot_adm.AcceptText()
idw_plant_labor.AcceptText()
idw_plant_serv.AcceptText()
idw_plant_benef.Accepttext( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore	lds_log_dw1, lds_log_dw2, lds_log_dw3, &
					lds_log_dw4, lds_log_dw5, lds_log_dw6, &
					lds_log_dw7
					
	lds_log_dw1 = Create DataStore
	lds_log_dw2 = Create DataStore
	lds_log_dw3 = Create DataStore
	lds_log_dw4 = Create DataStore
	lds_log_dw5 = Create DataStore
	lds_log_dw6 = Create DataStore
	lds_log_dw7 = Create DataStore
	
	lds_log_dw1.DataObject = 'd_log_diario_tbl'
	lds_log_dw2.DataObject = 'd_log_diario_tbl'
	lds_log_dw3.DataObject = 'd_log_diario_tbl'
	lds_log_dw4.DataObject = 'd_log_diario_tbl'
	lds_log_dw5.DataObject = 'd_log_diario_tbl'
	lds_log_dw6.DataObject = 'd_log_diario_tbl'
	lds_log_dw7.DataObject = 'd_log_diario_tbl'
	
	lds_log_dw1.SetTransObject(SQLCA)
	lds_log_dw2.SetTransObject(SQLCA)
	lds_log_dw3.SetTransObject(SQLCA)
	lds_log_dw4.SetTransObject(SQLCA)
	lds_log_dw5.SetTransObject(SQLCA)
	lds_log_dw6.SetTransObject(SQLCA)
	lds_log_dw7.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, lds_log_dw1, is_colname_dw1, is_coltype_dw1, gs_user, is_tabla_dw1)
	in_log.of_create_log(idw_plant_det, lds_log_dw2, is_colname_dw2, is_coltype_dw2, gs_user, is_tabla_dw2)
	in_log.of_create_log(idw_plant_art, lds_log_dw3, is_colname_dw3, is_coltype_dw3, gs_user, is_tabla_dw3)
	in_log.of_create_log(idw_plant_ot_adm, lds_log_dw4, is_colname_dw4, is_coltype_dw4, gs_user, is_tabla_dw4)
	in_log.of_create_log(idw_plant_labor, lds_log_dw5, is_colname_dw5, is_coltype_dw5, gs_user, is_tabla_dw5)	
	in_log.of_create_log(idw_plant_serv, lds_log_dw6, is_colname_dw6, is_coltype_dw6, gs_user, is_tabla_dw6)
	in_log.of_create_log(idw_plant_benef, lds_log_dw7, is_colname_dw7, is_coltype_dw7, gs_user, is_tabla_dw7)
		
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_plant_det.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_plant_det.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_det","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_plant_art.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_plant_art.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_art","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_plant_ot_adm.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_plant_ot_adm.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_ot_adm","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_plant_labor.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_plant_labor.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_labor","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_plant_serv.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_plant_serv.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_serv","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_plant_benef.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_plant_benef.Update(true,false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_serv","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_dw1.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw2.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw3.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw4.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw5.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw6.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw7.Update(true,false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log_dw1
	DESTROY lds_log_dw2
	DESTROY lds_log_dw3
	DESTROY lds_log_dw4
	DESTROY lds_log_dw5
	DESTROY lds_log_dw6
	DESTROY lds_log_dw7
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	is_action = 'open'
	
	dw_master.ResetUpdate()
	idw_plant_det.ResetUpdate()
	idw_plant_art.ResetUpdate()
	idw_plant_ot_adm.ResetUpdate()
	idw_plant_labor.ResetUpdate()
	idw_plant_serv.ResetUpdate()
	idw_plant_benef.ResetUpdate()

	if dw_master.RowCount() > 0 then
		ls_plantilla = dw_master.object.cod_plantilla[dw_master.GetRow()]
		of_retrieve(ls_plantilla)
	end if
END IF
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()

if is_action <> 'new' then is_action = 'edit'
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
this.event ue_update_request()

str_parametros sl_param

sl_param.dw1 = "d_sel_plantilla_costo_tbl"   //"d_dddw_orden_compra_tbl"  // //
sl_param.titulo = "Plantillas de Costo"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_dw1, is_coltype_dw1)
	in_log.of_dw_map(idw_plant_det, is_colname_dw2, is_coltype_dw2)
	in_log.of_dw_map(idw_plant_art, is_colname_dw3, is_coltype_dw3)
	in_log.of_dw_map(idw_plant_ot_adm, is_colname_dw4, is_coltype_dw4)
	in_log.of_dw_map(idw_plant_labor, is_colname_dw5, is_coltype_dw5)
	in_log.of_dw_map(idw_plant_serv, is_colname_dw6, is_coltype_dw6)
	in_log.of_dw_map(idw_plant_benef, is_colname_dw7, is_coltype_dw7)
END IF
end event

event close;call super::close;Destroy in_log
end event

type st_nro from statictext within w_pr021_plantilla_costo
integer x = 78
integer y = 40
integer width = 407
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod Plantilla:"
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr021_plantilla_costo
integer x = 498
integer y = 28
integer width = 512
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;idw_plant_det.reset()
cb_1.event clicked()
end event

type cb_1 from commandbutton within w_pr021_plantilla_costo
integer x = 1065
integer y = 24
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type tab_1 from tab within w_pr021_plantilla_costo
integer y = 876
integer width = 2921
integer height = 1052
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2885
integer height = 860
long backcolor = 79741120
string text = "Detalle de la plantilla"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_plant_det dw_plant_det
end type

on tabpage_1.create
this.dw_plant_det=create dw_plant_det
this.Control[]={this.dw_plant_det}
end on

on tabpage_1.destroy
destroy(this.dw_plant_det)
end on

type dw_plant_det from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer width = 2267
integer height = 836
integer taborder = 20
string dataobject = "d_abc_plantilla_costo_det"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_area
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "titulo1"
		ls_sql = "SELECT cod_titulo AS codigo_titulo, " &
				  + "desc_titulo AS DESCRIPCION_titulo " &
				  + "FROM costos_titulos " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.titulo1			[al_row] = ls_codigo
			this.object.desc_titulo1	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "titulo2"
		ls_sql = "SELECT cod_titulo AS codigo_titulo, " &
				  + "desc_titulo AS DESCRIPCION_titulo " &
				  + "FROM costos_titulos " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.titulo2			[al_row] = ls_codigo
			this.object.desc_titulo2	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "cod_area"
		ls_sql = "SELECT cod_area AS codigo_area, " &
				  + "desc_area AS DESCRIPCION_area " &
				  + "FROM area " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_area		[al_row] = ls_codigo
			this.object.desc_area	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return	

	case "cod_seccion"
		ls_area = this.object.cod_area[al_row]
		
		if IsNull(ls_area) or ls_area = '' then
			MessageBox('Aviso', 'Debe especificar un area primero, por favor verifique')
			return
		end if
		
		ls_sql = "SELECT cod_seccion AS codigo_seccion, " &
				  + "desc_seccion AS DESCRIPCION_seccion " &
				  + "FROM seccion " &
				  + "where flag_estado = '1' " &
				  + "and cod_area = '" + ls_area + "'"
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_seccion		[al_row] = ls_codigo
			this.object.desc_seccion	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return		
		
	case "und"
		
		ls_sql = "SELECT und AS codigo_unidad, " &
				  + "desc_unidad AS DESCRIPCION_unidad " &
				  + "FROM unidad " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.und		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		return		

end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return

string ls_plantilla

ls_plantilla = dw_master.object.cod_plantilla [dw_master.GetRow()]

this.object.cod_usr 			[al_row] = gs_user
this.object.cod_plantilla 	[al_row] = ls_plantilla
this.object.nro_item			[al_row] = of_nro_item(this)
this.object.nro_orden		[al_row] = of_nro_posicion(this)

this.object.flag_energia_electrica 	[al_row] = '0'
this.object.flag_transporte		 	[al_row] = '0'
this.object.flag_comedor 				[al_row] = '0'
this.object.flag_labor 					[al_row] = '0'
this.object.flag_ot_adm 				[al_row] = '0'
this.object.flag_detalle_articulo 	[al_row] = '0'
this.object.flag_personal 				[al_row] = '0'
this.object.flag_bonif_prod			[al_row] = '0'
this.object.flag_bonif_mp				[al_row] = '0'
this.object.flag_bonif_mp				[al_row] = '0'
this.object.flag_centro_benef			[al_row] = '0'
this.object.flag_gastos_drctos		[al_row] = '0'
this.object.flag_mat_servicios		[al_row] = '0'
this.object.flag_estado					[al_row] = '1'
end event

event ue_output;call super::ue_output;string 	ls_plantilla
Long		ll_item

if idw_plant_art.ii_update 	= 1 OR &
	idw_plant_ot_adm.ii_update = 1 OR &
	idw_plant_labor.ii_update 	= 1 OR &
	idw_plant_serv.ii_update 	= 1 OR &
	idw_plant_benef.ii_update	= 1 THEN
	
	event ue_update_request( )
	
end if

ls_plantilla = this.object.cod_plantilla [al_row]
ll_item		 = Long(this.object.nro_item [al_row])	

idw_plant_art.Retrieve(ls_plantilla, ll_item)
idw_plant_ot_adm.Retrieve(ls_plantilla, ll_item)
idw_plant_labor.Retrieve(ls_plantilla, ll_item)
idw_plant_serv.Retrieve(ls_plantilla, ll_item)
idw_plant_benef.Retrieve(ls_plantilla, ll_item)
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

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null, ls_area

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "titulo1"
		
		select desc_titulo
			into :ls_data
		from costos_titulos
		where cod_titulo = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Título no existe o no está activo", StopSign!)
			this.object.titulo1			[row] = ls_null
			this.object.desc_titulo1 	[row] = ls_null
			return 1
		end if

		this.object.desc_titulo1	[row] = ls_data
		
	case "titulo2"
		
		select desc_titulo
			into :ls_data
		from costos_titulos
		where cod_titulo = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Título no existe o no está activo", StopSign!)
			this.object.titulo2			[row] = ls_null
			this.object.desc_titulo2 	[row] = ls_null
			return 1
		end if

		this.object.desc_titulo2	[row] = ls_data
		
	case "und"
		
		select desc_unidad
			into :ls_data
		from unidad
		where und = :data
		  and flag_estado = '1';

		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Unidad no existe o no está activo", StopSign!)
			this.object.und		[row] = ls_null
			return 1
		end if

	case "cod_area"
		
		select desc_area
			into :ls_data
		from area
		where cod_area = :data;

		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de area no existe o no está activo", StopSign!)
			this.object.cod_area		[row] = ls_null
			this.object.desc_area 	[row] = ls_null
			return 1
		end if

		this.object.desc_area	[row] = ls_data

	case "cod_seccion"
		ls_area = this.object.cod_area[row]
		
		if IsNull(ls_area) or ls_area = '' then
			MessageBox('Aviso', 'Debe especificar un area primero, por favor verifique')
			return
		end if
		
		select desc_seccion
			into :ls_data
		from seccion
		where cod_seccion= :data
		  and cod_area = :ls_area
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de area no existe o no está activo", StopSign!)
			this.object.cod_seccion		[row] = ls_null
			this.object.desc_seccion 	[row] = ls_null
			return 1
		end if

		this.object.desc_seccion	[row] = ls_data		
end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2885
integer height = 860
long backcolor = 79741120
string text = "Artículo x Item"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_plant_art dw_plant_art
end type

on tabpage_2.create
this.dw_plant_art=create dw_plant_art
this.Control[]={this.dw_plant_art}
end on

on tabpage_2.destroy
destroy(this.dw_plant_art)
end on

type dw_plant_art from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer width = 2405
integer height = 900
integer taborder = 20
string dataobject = "d_abc_plant_costo_art_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_art"
//		ls_sql = "SELECT cod_art AS CODIGO_articulo, " &
//				  + "desc_art AS DESCRIPCION_articulo, " &
//				  + "und AS und_articulo " &
//				  + "FROM articulo " &
//				  + "where flag_estado = '1' " &
//				  + "and flag_inventariable = '1'"
//					 
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.labor			[al_row] = ls_codigo
//			this.object.desc_labor	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//		return
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		IF sl_param.titulo <> 'n' then
			this.object.cod_art	[al_row] = sl_param.field_ret[1]
			this.object.desc_art	[al_row] = sl_param.field_ret[2]
			this.object.und		[al_row] = sl_param.field_ret[3]	
		end if
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_plant_det.GetRow() = 0 then return

string 	ls_plantilla
Long		ll_item, ll_row

ll_row = idw_plant_det.GetRow()

ls_plantilla = idw_plant_det.object.cod_plantilla [ll_row]
ll_item		 = Long(idw_plant_det.object.nro_item [ll_row])

this.object.cod_plantilla 	[al_row] = ls_plantilla
this.object.nro_item			[al_row] = ll_item
this.object.ratio_standard	[al_row] = 0
this.object.costo_standard	[al_row] = 0

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2885
integer height = 860
long backcolor = 79741120
string text = "OT_ADM x Item"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_plant_ot_adm dw_plant_ot_adm
end type

on tabpage_3.create
this.dw_plant_ot_adm=create dw_plant_ot_adm
this.Control[]={this.dw_plant_ot_adm}
end on

on tabpage_3.destroy
destroy(this.dw_plant_ot_adm)
end on

type dw_plant_ot_adm from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer width = 1888
integer height = 888
integer taborder = 20
string dataobject = "d_abc_plant_costo_ot_adm_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "ot_adm"
		ls_sql = "SELECT ot_adm AS CODIGO_ot_adm, " &
				  + "descripcion AS DESCRIPCION_ot_adm " &
				  + "FROM ot_administracion " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_plant_det.GetRow() = 0 then return

string 	ls_plantilla
Long		ll_item, ll_row

ll_row = idw_plant_det.GetRow()

ls_plantilla = idw_plant_det.object.cod_plantilla [ll_row]
ll_item		 = Long(idw_plant_det.object.nro_item [ll_row])

this.object.cod_plantilla 	[al_row] = ls_plantilla
this.object.nro_item			[al_row] = ll_item

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

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "ot_adm"
		
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Labor no existe o no está activo", StopSign!)
			this.object.ot_adm		[row] = ls_null
			this.object.desc_ot_adm	[row] = ls_null
			return 1
		end if

		this.object.desc_labor	[row] = ls_data
		
end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2885
integer height = 860
long backcolor = 79741120
string text = "Labores x Item"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_plant_labor dw_plant_labor
end type

on tabpage_4.create
this.dw_plant_labor=create dw_plant_labor
this.Control[]={this.dw_plant_labor}
end on

on tabpage_4.destroy
destroy(this.dw_plant_labor)
end on

type dw_plant_labor from u_dw_abc within tabpage_4
event ue_display ( string as_columna,  long al_row )
integer width = 1998
integer height = 848
integer taborder = 20
string dataobject = "d_abc_plant_costo_labor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_labor"
		ls_sql = "SELECT cod_labor AS CODIGO_labor, " &
				  + "desc_labor AS DESCRIPCION_labor " &
				  + "FROM labor " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;if idw_plant_det.GetRow() = 0 then return

string 	ls_plantilla
Long		ll_item, ll_row

ll_row = idw_plant_det.GetRow()

ls_plantilla = idw_plant_det.object.cod_plantilla [ll_row]
ll_item		 = Long(idw_plant_det.object.nro_item [ll_row])

this.object.cod_plantilla 	[al_row] = ls_plantilla
this.object.nro_item			[al_row] = ll_item

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

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_labor"
		
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Labor no existe o no está activo", StopSign!)
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			return 1
		end if

		this.object.desc_labor	[row] = ls_data
		
end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2885
integer height = 860
long backcolor = 79741120
string text = "Servicios x Item"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_plant_serv dw_plant_serv
end type

on tabpage_5.create
this.dw_plant_serv=create dw_plant_serv
this.Control[]={this.dw_plant_serv}
end on

on tabpage_5.destroy
destroy(this.dw_plant_serv)
end on

type dw_plant_serv from u_dw_abc within tabpage_5
event ue_display ( string as_columna,  long al_row )
integer width = 2304
integer height = 836
integer taborder = 20
string dataobject = "d_abc_plant_costo_servicios_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "servicio"
		ls_sql = "SELECT servicio AS CODIGO_servicio, " &
				  + "descripcion AS DESCRIPCION_servicio " &
				  + "FROM servicios " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.servicio			[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_plant_det.GetRow() = 0 then return

string 	ls_plantilla
Long		ll_item, ll_row

ll_row = idw_plant_det.GetRow()

ls_plantilla = idw_plant_det.object.cod_plantilla [ll_row]
ll_item		 = Long(idw_plant_det.object.nro_item [ll_row])

this.object.cod_plantilla 	[al_row] = ls_plantilla
this.object.nro_item			[al_row] = ll_item

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "servicio"
		
		select descripcion
			into :ls_data
		from servicios
		where servicio = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Servicio no existe o no está activo", StopSign!)
			this.object.servicio			[row] = ls_null
			this.object.desc_servicio	[row] = ls_null
			return 1
		end if

		this.object.desc_servicio	[row] = ls_data
		
end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2885
integer height = 860
long backcolor = 79741120
string text = "Centros de ~r~nBeneficios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_plant_benef dw_plant_benef
end type

on tabpage_6.create
this.dw_plant_benef=create dw_plant_benef
this.Control[]={this.dw_plant_benef}
end on

on tabpage_6.destroy
destroy(this.dw_plant_benef)
end on

type dw_plant_benef from u_dw_abc within tabpage_6
event ue_display ( string as_columna,  long al_row )
integer width = 2683
integer height = 852
integer taborder = 20
string dataobject = "d_abc_plant_costo_cent_benef_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "centro_benef"
		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
				  + "desc_centro AS DESCRIPCION_centro_beneficio " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef[al_row] = ls_codigo
			this.object.desc_centro	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "servicio"
		
		select descripcion
			into :ls_data
		from servicios
		where servicio = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Servicio no existe o no está activo", StopSign!)
			this.object.servicio			[row] = ls_null
			this.object.desc_servicio	[row] = ls_null
			return 1
		end if

		this.object.desc_servicio	[row] = ls_data
		
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_plant_det.GetRow() = 0 then return

string 	ls_plantilla
Long		ll_item, ll_row

ll_row = idw_plant_det.GetRow()

ls_plantilla = idw_plant_det.object.cod_plantilla [ll_row]
ll_item		 = Long(idw_plant_det.object.nro_item [ll_row])

this.object.cod_plantilla 	[al_row] = ls_plantilla
this.object.nro_item			[al_row] = ll_item

end event

type dw_master from u_dw_abc within w_pr021_plantilla_costo
event ue_display ( string as_columna,  long al_row )
integer y = 132
integer width = 2725
integer height = 732
string dataobject = "d_abc_plant_costo_cab_ff"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_planta"
		ls_sql = "SELECT cod_planta AS CODIGO_planta, " &
				  + "desc_planta AS DESCRIPCION_planta " &
				  + "FROM tg_plantas " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_planta	[al_row] = ls_codigo
			this.object.desc_planta	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "ot_adm"
		ls_sql = "SELECT ot_adm AS CODIGO_ot_adm, " &
				  + "descripcion AS DESCRIPCION_ot_adm " &
				  + "FROM ot_administracion " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return		

	case "centro_benef"
		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
				  + "desc_centro AS DESCRIPCION_centro " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1'" &
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return		

	case "cod_uso_mp"
		ls_sql = "SELECT cod_uso AS cod_uso_mp, " &
				  + "descripcion AS DESCRIPCION_uso " &
				  + "FROM tg_usos_materia_prima " &
				  + "where flag_estado = '1'" &
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_uso_mp	[al_row] = ls_codigo
			this.object.desc_uso_mp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return		
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro [al_row] = f_fecha_Actual()
this.object.flag_estado  [al_row] = '1'
this.object.cod_usr  	 [al_row] = gs_user
this.object.cod_origen	 [al_row] = gs_origen

is_action = 'new'
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_planta"
		
		select desc_planta
			into :ls_data
		from tg_plantas
		where cod_planta = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Planta no existe o no está activo", StopSign!)
			this.object.cod_planta	[row] = ls_null
			this.object.desc_planta	[row] = ls_null
			return 1
		end if

		this.object.desc_planta	[row] = ls_data

	case "ot_adm"
		
		select descripcion
			into :ls_data
		from ot_administracion
		where ot_adm = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "OT_ADM no existe o no está activo", StopSign!)
			this.object.ot_adm		[row] = ls_null
			this.object.desc_ot_adm	[row] = ls_null
			return 1
		end if

		this.object.desc_ot_adm	[row] = ls_data		

	case "centro_benef"
		
		select desc_centro
			into :ls_data
		from centro_beneficio
		where centro_benef = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de beneficio no existe o no está activo", StopSign!)
			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			return 1
		end if

		this.object.desc_centro	[row] = ls_data	

	case "cod_uso_mp"
		
		select descripcion
			into :ls_data
		from tg_usos_materia_prima
		where cod_uso = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Uso de MP no existe o no está activo", StopSign!)
			this.object.cod_uso_mp	[row] = ls_null
			this.object.desc_uso_mp	[row] = ls_null
			return 1
		end if

		this.object.desc_uso_mp [row] = ls_data		
		
end choose
end event

