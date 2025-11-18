$PBExportHeader$w_cam302_parte_riego.srw
forward
global type w_cam302_parte_riego from w_abc
end type
type tab_1 from tab within w_cam302_parte_riego
end type
type tabciclos from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabciclos
end type
type tabciclos from userobject within tab_1
dw_detail dw_detail
end type
type tabinsumos from userobject within tab_1
end type
type dw_insumos from u_dw_abc within tabinsumos
end type
type tabinsumos from userobject within tab_1
dw_insumos dw_insumos
end type
type tab_1 from tab within w_cam302_parte_riego
tabciclos tabciclos
tabinsumos tabinsumos
end type
type dw_master from u_dw_abc within w_cam302_parte_riego
end type
end forward

global type w_cam302_parte_riego from w_abc
integer width = 2811
integer height = 2392
string title = "[CAM301] Parte de Riego"
string menuname = "m_abc_anular_lista"
tab_1 tab_1
dw_master dw_master
end type
global w_cam302_parte_riego w_cam302_parte_riego

type variables
u_dw_abc idw_detail, idw_insumos
String      		is_tabla_m, is_tabla_d, is_tabla_dd, &
						is_colname_m[],is_coltype_m[], &
						is_colname_d[],is_coltype_d[], &
						is_colname_dd[],is_coltype_dd[]
n_cst_log_diario	in_log
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public function integer of_nro_ciclo (u_dw_abc adw_1)
end prototypes

public subroutine of_asigna_dws ();idw_detail = tab_1.tabciclos.dw_detail
idw_insumos = tab_1.tabinsumos.dw_insumos
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_cam_parte_riego
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_cam_parte_riego IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_cam_parte_riego(origen, ult_nro)
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
	FROM num_cam_parte_riego
	where origen = :gs_origen for update;
	
	update num_cam_parte_riego
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_parte[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_parte[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to idw_detail.RowCount()
	idw_detail.object.nro_parte[ll_j] = ls_next_nro
next

for ll_j = 1 to idw_insumos.RowCount()
	idw_insumos.object.nro_parte[ll_j] = ls_next_nro
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_detail.retrieve(as_nro)
	
	if idw_detail.RowCount() > 0 then
		idw_detail.il_row = 1
		idw_detail.SelectRow(0, false)
		idw_detail.SelectRow(idw_detail.il_Row, true)
		idw_detail.SetRow(1)
		idw_insumos.retrieve(as_nro, idw_detail.object.nro_item[1])
	end if
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detail.ii_protect = 0
	idw_detail.ii_update	= 0
	idw_detail.of_protect()
	idw_detail.ResetUpdate()
	
	idw_insumos.ii_protect = 0
	idw_insumos.ii_update	= 0
	idw_insumos.of_protect()
	idw_insumos.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
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

on w_cam302_parte_riego.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_cam302_parte_riego.destroy
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

idw_insumos.width  = tab_1.tabInsumos.width  - idw_insumos.x - 10
idw_insumos.height = tab_1.tabInsumos.height - idw_insumos.y - 10

end event

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1 = dw_master then
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN RETURN
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws( )

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_insumos.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
idw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
idw_insumos.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

dw_master.of_protect()         		// bloquear modificaciones 
idw_detail.of_protect()
idw_insumos.of_protect()

is_tabla_m = dw_master.Object.Datawindow.Table.UpdateTable
is_tabla_d = idw_detail.Object.Datawindow.Table.UpdateTable
is_tabla_dd = idw_insumos.Object.Datawindow.Table.UpdateTable

ib_log = true


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR idw_insumos.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_insumos.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;
ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detail, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_insumos, dw_master.is_dwform) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()
idw_insumos.of_set_flag_replicacion()

if of_set_numera	() = 0 then return

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_detail.AcceptText()
idw_Insumos.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d, lds_log_dd
	lds_log_m = Create DataStore
	lds_log_d = Create DataStore
	lds_log_dd = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_dd.DataObject = 'd_log_diario_tbl'
	
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	lds_log_dd.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
	in_log.of_create_log(idw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
	in_log.of_create_log(idw_insumos, lds_log_dd, is_colname_dd, is_coltype_dd, gs_user, is_tabla_dd)
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

IF idw_insumos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_insumos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle Insumos", ls_msg, StopSign!)
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
		IF lds_log_dd.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Insumos')
		END IF

	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
	DESTROY lds_log_dd
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_insumos.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detail.il_totdel = 0
	idw_insumos.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_insumos.ResetUpdate()
	
	is_action='open'
END IF

end event

event close;call super::close;Destroy in_log
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(idw_detail, is_colname_d, is_coltype_d)
	in_log.of_dw_map(idw_insumos, is_colname_dd, is_coltype_dd)
END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_parte_riego_tbl'
sl_param.titulo = 'Partes de Riego'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
idw_detail.of_protect()
idw_insumos.of_protect()

if is_action <> 'new' then is_action = 'open'
end event

event ue_anular;call super::ue_anular;if is_action = 'new' or is_action='edit' then
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
	
	idw_insumos.ii_protect = 0
	idw_insumos.of_protect()

end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1

is_action = 'anu'

end event

type tab_1 from tab within w_cam302_parte_riego
integer x = 5
integer y = 720
integer width = 2656
integer height = 1268
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
tabinsumos tabinsumos
end type

on tab_1.create
this.tabciclos=create tabciclos
this.tabinsumos=create tabinsumos
this.Control[]={this.tabciclos,&
this.tabinsumos}
end on

on tab_1.destroy
destroy(this.tabciclos)
destroy(this.tabinsumos)
end on

type tabciclos from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2619
integer height = 1140
long backcolor = 79741120
string text = "Ciclos de Riego"
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
string dataobject = "d_abc_parte_riego_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;Date ld_fecha

ld_fecha = date(dw_master.object.fec_parte [dw_master.getRow()])

this.object.cod_usr 				[al_row] = gs_user
this.object.fec_registro 		[al_row] = f_fecha_Actual()
this.object.hora_inicio_riego [al_row] = dateTime(ld_fecha, Now())
this.object.hora_fin_riego 	[al_row] = dateTime(ld_fecha, Now())
this.object.nro_item			 	[al_row] = f_numera_item(this)
this.object.hrs_riego			[al_row] = 0.00
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'dd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detal
is_dwform = 'tabular'

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
idw_det  =  idw_insumos
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
date		ld_fec_inicio, ld_fec_fin

choose case lower(as_columna)
	case "nro_lote"
		
		ld_fec_inicio 	= Date(dw_master.object.fec_inicio 	[dw_master.GetRow()])
		
		if ISNull(ld_fec_inicio) then
			MessageBox('Error', 'Debe Especificar la campaña')
			dw_master.setFocus( )
			dw_master.setColumn('campana')
			return
		end if
		
		ld_fec_fin 		= Date(dw_master.object.fec_fin		 [dw_master.GetRow()])
		if ISNull(ld_fec_fin) then
			MessageBox('Error', 'Debe Especificar la campaña')
			dw_master.setFocus( )
			dw_master.setColumn('campana')
			return
		end if
		
		ls_sql = "SELECT distinct lc.nro_lote AS numero_lote, " &
				  + "lc.descripcion AS descripcion_lote, " &
				  + "lc.total_plantas AS total_plantas " &
				  + "FROM lote_campo lc, " &
				  + "orden_trabajo ot, " &
				  + "operaciones op, " &
				  + "articulo_mov am, " &
				  + "vale_mov		vm, " &
				  + "cam_factor_ele_qui ca " &
				  + "WHERE ot.nro_orden = op.nro_orden " &
				  + "  and ot.lote_campo = lc.nro_lote " &
				  + "  and op.oper_sec  = am.oper_sec " &
				  + "  and am.nro_Vale  = vm.nro_vale " &
				  + "  and am.cod_art   = ca.cod_art " &
				  + "  and trunc(vm.fec_registro) between to_date('" + string(ld_fec_inicio, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fec_fin, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') " &
				  + "  and lc.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '1')

		if ls_codigo <> '' then
			this.object.nro_lote			[al_row] = ls_codigo
			this.object.desc_lote		[al_row] = ls_data
			this.object.total_plantas	[al_row] = Long(ls_data2)
			this.object.nro_ciclo		[al_row] = of_nro_ciclo(this)
			
			this.ii_update = 1
		end if
		

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count, ll_horas, ll_total_plantas
dateTime ldt_hora_inicio, ldt_hora_fin

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'nro_lote'
		
		// Verifica que codigo ingresado exista			
		Select descripcion, total_plantas
	     into :ls_desc1, :ll_total_plantas
		  from lote_campo
		 Where nro_lote = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			SetNull(ll_total_plantas)
			MessageBox("Error", "no existe Nro Lote o no se encuentra activo, por favor verifique")
			this.object.nro_lote			[row] = ls_null
			this.object.desc_lote		[row] = ls_null
			this.object.total_plantas	[row] = ll_total_plantas
			return 1
			
		end if

		this.object.desc_lote		[row] = ls_desc1
		this.object.total_plantas	[row] = ll_total_plantas
		this.object.nro_ciclo		[row] = of_nro_ciclo(this)
	
	case 'hora_inicio_riego', 'hora_fin_riego'
		
		ldt_hora_inicio = dateTime(this.object.hora_inicio_riego [row])
		ldt_hora_fin 	 = dateTime(this.object.hora_fin_riego [row])
		
		select (:ldt_hora_fin - :ldt_hora_inicio) * 24
		  into :ll_horas
		  from dual;
	
		this.object.hrs_riego [row] = ll_horas
		
END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)
end event

event ue_output;call super::ue_output;//THIS.EVENT ue_retrieve_det(al_row)

idw_insumos.ResetUpdate()
idw_insumos.retrieve(this.object.nro_parte[al_row], this.object.nro_item[al_row])

end event

type tabinsumos from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2619
integer height = 1140
long backcolor = 79741120
string text = "Insumos de Riego x Ciclo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_insumos dw_insumos
end type

on tabinsumos.create
this.dw_insumos=create dw_insumos
this.Control[]={this.dw_insumos}
end on

on tabinsumos.destroy
destroy(this.dw_insumos)
end on

type dw_insumos from u_dw_abc within tabinsumos
integer width = 2450
integer height = 1080
integer taborder = 20
string dataobject = "d_abc_parte_riego_art_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detal
is_dwform = 'tabular'

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

idw_mst  = 	idw_detail
//idw_det  =  idw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 				[al_row] = gs_user
this.object.fec_registro 		[al_row] = f_fecha_Actual()

this.object.nro_item				[al_row] = idw_mst.object.nro_item [idw_mst.GetRow()]
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
string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_nro_lote, ls_cod_art, &
			ls_nro_ot, ls_oper_sec
date		ld_fec_inicio ,ld_fec_fin

choose case lower(as_columna)
	case "cod_art"
		ls_sql = "SELECT distinct a.cod_art AS codigo_articulo, " &
				  + "a.desc_art AS descripcion_articulo, " &
				  + "a.und AS unidad_articulo " &
				  + "FROM articulo a, " &
				  + "     cam_factor_ele_qui b " &
				  + "WHERE a.cod_Art = b.cod_art " &
				  + "  and a.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.object.und		[al_row] = ls_data2
			this.ii_update = 1
		end if

	case "nro_orden"
		ls_cod_Art = this.object.cod_art[al_row]
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Elegir primero un artículo')
			this.setColumn( 'cod_art' )
			return
		end if

		ls_nro_lote = idw_detail.object.nro_lote [idw_detail.GetRow()]
		if ls_nro_lote = '' or IsNull(ls_nro_lote) then
			MessageBox('Error', 'Debe Elegir primero un artículo')
			tab_1.Selectedtab = 1
			idw_detail.SetFocus()
			idw_detail.setColumn( 'nro_lote' )
			return
		end if
		
		ld_fec_inicio = Date(dw_master.object.fec_inicio 	[dw_master.GetRow()])
		ld_fec_fin 	  = Date(dw_master.object.fec_fin 		[dw_master.GetRow()])
		
		ls_sql = "SELECT distinct ot.nro_orden AS numero_orden, " &
				 + "ot.ot_adm AS ot_adm, " &
				 + "op.oper_sec AS codigo_oper_sec, " &
				 + "op.desc_operacion AS descripcion_operacion, " &
				 + "ot.fec_estimada AS fecha_estimada_Inicio, " &
				 + "ot.titulo AS titulo_orden " &
				 + "FROM orden_trabajo ot, " &
				 + "     articulo_mov  am, " &
				 + "     vale_mov 	  vm, " &
				 + "     operaciones  op " &
				 + "WHERE ot.nro_orden   = op.nro_orden " &
				 + "  and op.oper_sec    = am.oper_sec " &
				 + "  and am.nro_vale    = vm.nro_vale " &
				 + "  and trunc(vm.fec_registro) between to_date('" + string(ld_fec_inicio, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fec_fin, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') " &
				 + "  and am.cod_art     = '" + ls_cod_art + "' " &
				 + "  and ot.LOTE_CAMPO  = '" + ls_nro_lote + "' " &
				 + "  and ot.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.oper_sec		[al_row] = ls_data2
			this.ii_update = 1
		end if
		
	case "oper_sec"
		ls_cod_Art  = this.object.cod_art	[al_row]
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Elegir primero un artículo')
			this.setColumn( 'cod_art' )
			return
		end if
		
		ls_nro_ot   = this.object.nro_orden	[al_row]
		if ls_nro_ot = '' or IsNull(ls_nro_ot) then
			MessageBox('Error', 'Debe Elegir primero una Orden de Trabajo')
			this.setColumn( 'nro_orden' )
			return
		end if
		
		
		ls_sql = "SELECT op.oper_sec AS codigo_oper_sec, " &
				 + "op.desc_operacion AS descripcion_operacion, " &
				 + "ot.fec_estimada AS fecha_estimada_Inicio, " &
				 + "ot.titulo AS titulo_orden " &
				 + "FROM articulo_mov am, " &
				 + "     operaciones op " &
				 + "WHERE op.oper_sec    = am.oper_sec " &
				 + "  and am.cod_art     = '" + ls_cod_art + "' " &
				 + "  and op.nro_orden  = '" + ls_nro_ot + " ' " &
				 + "  and ot.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.oper_sec		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "nro_vale"
		ls_cod_Art  = this.object.cod_art	[al_row]
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Elegir primero un artículo')
			this.setColumn( 'cod_art' )
			return
		end if
		
		ls_oper_sec   = this.object.oper_sec	[al_row]
		if ls_oper_sec = '' or IsNull(ls_oper_sec) then
			MessageBox('Error', 'Debe Elegir primero una Operacion')
			this.setColumn( 'oper_sec' )
			return
		end if
		
		
		ls_sql = "SELECT distinct vm.nro_vale as numero_vale, " &
				 + "am.cod_origen as codigo_origen, " &
				 + "am.nro_mov as numero_mov, " &
			    + "to_char(vm.fec_registro,'dd/mm/yyyy') as fec_registro, " &
				 + "am.cant_procesada as cantidad " &
				 + "FROM vale_mov vm, " &
				 + "     articulo_mov am " &
				 + "WHERE am.nro_vale    = vm.nro_vale " &
				 + "  and am.oper_sec    = '" + ls_oper_sec + "' " &
				 + "  and am.cod_art     = '" + ls_cod_art + "' " &
				 + "  and am.FLAG_ESTADO <> '0' " &
				 + "  and vm.flag_estado <> '0' "

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.nro_vale		[al_row] = ls_codigo
			this.object.org_am_sal	[al_row] = ls_data
			this.object.nro_am_sal	[al_row] = Long(ls_data2)
			this.ii_update = 1
		end if

end choose
end event

type dw_master from u_dw_abc within w_cam302_parte_riego
integer width = 2555
integer height = 704
string dataobject = "d_abc_parte_riego_cab_ff"
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro 	[al_row] = f_fecha_actual()
this.object.cod_origen		[al_row] = gs_origen
this.object.fec_parte 		[al_row] = Date(f_fecha_actual())
this.object.flag_estado		[al_row] = '1'

idw_detail.Reset()
idw_detail.ResetUpdate()

idw_insumos.Reset()
idw_insumos.ResetUpdate()

is_action = 'new'


end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detal
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  idw_detail
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
string 	ls_codigo, ls_data, ls_sql
date		ld_fec_parte, ld_fec_inicio, ld_fec_fin

choose case lower(as_columna)
	case "operador"
		ld_fec_parte = date(this.object.fec_parte [al_row])
		
		ls_sql = "SELECT cod_trabajador AS CODIGO_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  and (fec_cese is null or trunc(fec_cese) >= to_date('" + string(ld_fec_parte, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')) " &
				  + "  and trunc(fec_ingreso) <= to_date('" + string(ld_fec_parte, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.operador			[al_row] = ls_codigo
			this.object.nom_operador 	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "bomba"
		ls_sql = "SELECT cod_maquina AS codigo_maquina, " &
				  + "desc_maq AS descripcion_maquina " &
				  + "FROM maquina " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.bomba			[al_row] = ls_codigo
			this.object.desc_bomba	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tipo_riego"
		ls_sql = "SELECT cod_tipo_riego AS codigo_tipo_riego, " &
				  + "desc_tipo_riego AS descripcion_tipo_riego " &
				  + "FROM cam_tipo_riego " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_riego			[al_row] = ls_codigo
			this.object.desc_tipo_riego	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "campana"
		ls_sql = "SELECT campana AS codigo_campana, " &
				  + "descripcion AS descripcion_campaña " &
				  + "FROM campanas " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			
			select fec_inicio, fec_fin
				into :ld_fec_inicio, :ld_fec_fin
			from campanas
			where campana = :ls_codigo;
			
			this.object.campana			[al_row] = ls_codigo
			this.object.desc_campana	[al_row] = ls_data
			this.object.fec_inicio		[al_row] = ld_fec_inicio
			this.object.fec_fin			[al_row] = ld_fec_fin
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count
date 		ld_fec_parte, ld_fec_inicio, ld_fec_fin

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'operador'
		
		ld_fec_parte = Date(this.object.fec_parte [row])
		
		// Verifica que codigo ingresado exista			
		Select nom_trabajador
	     into :ls_desc1
		  from vw_pr_trabajador
		 Where cod_trabajador = :data  
		   and flag_estado = '1'
			and (fec_cese is null or fec_cese >= :ld_fec_parte)
			and (fec_ingreso <= :ld_fec_parte);
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe código de trabajador o no se encuentra activo, por favor verifique")
			this.object.operador			[row] = ls_null
			this.object.nom_operador	[row] = ls_null
			return 1
			
		end if

		this.object.nom_operador		[row] = ls_desc1

	CASE 'bomba' 

		// Verifica que codigo ingresado exista			
		Select desc_maq
	     into :ls_desc1
		  from maquina
		 Where cod_maquina = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de máquina o no se encuentra activo, por favor verifique")
			this.object.bomba			[row] = ls_null
			this.object.desc_bomba	[row] = ls_null
			return 1
			
		end if

		this.object.desc_bomba		[row] = ls_desc1

	CASE 'tipo_riego' 

		// Verifica que codigo ingresado exista			
		Select desc_tipo_riego
	     into :ls_desc1
		  from cam_tipo_riego
		 Where cod_tipo_riego = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de tipo de Riego o no se encuentra activo, por favor verifique")
			this.object.tipo_riego			[row] = ls_null
			this.object.desc_tipo_riego	[row] = ls_null
			return 1
			
		end if

		this.object.desc_tipo_riego		[row] = ls_desc1

	CASE 'campana' 

		// Verifica que codigo ingresado exista			
		Select descripcion, fec_inicio, fec_fin
	     into :ls_desc1, :ld_fec_inicio, :ld_fec_fin
		  from campanas
		 Where campana = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			SetNull(ld_fec_inicio)
			MessageBox("Error", "No existe Campaña o no se encuentra activo, por favor verifique")
			this.object.campana			[row] = ls_null
			this.object.desc_campana	[row] = ls_null
			this.object.desc_campana	[row] = ld_fec_inicio
			this.object.desc_campana	[row] = ld_fec_inicio
			return 1
			
		end if

		this.object.desc_campana	[row] = ls_desc1
		this.object.fec_inicio		[row] = ld_fec_inicio
		this.object.fec_fin			[row] = ld_fec_fin


END CHOOSE
end event

