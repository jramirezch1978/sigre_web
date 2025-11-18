$PBExportHeader$w_ma306_pd_agruphor.srw
forward
global type w_ma306_pd_agruphor from w_abc
end type
type tab_1 from tab within w_ma306_pd_agruphor
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_incid from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_incid dw_incid
end type
type tab_1 from tab within w_ma306_pd_agruphor
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_ma306_pd_agruphor
end type
end forward

global type w_ma306_pd_agruphor from w_abc
integer width = 2816
integer height = 2152
string title = "Parte Diario de Agruphores (MA306)"
string menuname = "m_abc_master_list"
tab_1 tab_1
dw_master dw_master
end type
global w_ma306_pd_agruphor w_ma306_pd_agruphor

type variables
boolean	ib_modify
DateTime	idt_fecha_proc
u_dw_abc	idw_detail, idw_incid
end variables

forward prototypes
public subroutine of_carga_maquinas (string asi_agruphor)
public subroutine of_retrieve (string as_nro_parte)
public function integer of_set_numera ()
public subroutine of_fill_maquina ()
public function decimal of_num_horas_inc ()
end prototypes

public subroutine of_carga_maquinas (string asi_agruphor);
end subroutine

public subroutine of_retrieve (string as_nro_parte);dw_master.Reset()
idw_detail.Reset()
idw_incid.Reset()

dw_master.Retrieve(as_nro_parte)
idw_detail.retrieve(as_nro_parte)
idw_incid.Retrieve(as_nro_parte)

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

idw_detail.ii_update = 0
idw_detail.ii_protect = 0
idw_detail.of_protect()

idw_incid.ii_update = 0
idw_incid.ii_protect = 0
idw_incid.of_protect()

is_action = 'open'
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_mt_pd_grp_trab
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_mt_pd_grp_trab IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_mt_pd_grp_trab(origen, ult_nro)
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
	FROM num_mt_pd_grp_trab
	where origen = :gs_origen for update;
	
	update num_mt_pd_grp_trab
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

// Asigna numero a incidencias
for ll_j = 1 to idw_incid.RowCount()
	idw_incid.object.nro_parte[ll_j] = ls_next_nro
next

return 1
end function

public subroutine of_fill_maquina ();string 	ls_cod_maq
Long		ll_i, ll_row, ll_find
u_ds_base lds_data

if dw_master.GetRow() = 0 then return

if is_action <> 'new' then return

ls_cod_maq = dw_master.object.cod_maquina [dw_master.GetRow()]
lds_data = create u_ds_base
lds_data.DataObject = 'ds_estructura_maq_tbl'
lds_data.SetTransObject(SQLCA)
lds_data.Retrieve(ls_cod_maq)

if lds_data.RowCount() = 0 then
	DESTROY lds_data
	MessageBox('Aviso', 'Codigo de maquina no es una estructura')
	return
end if

for ll_i = 1 to lds_data.RowCount()
	ls_cod_maq = lds_data.object.cod_maquina[ll_i]
	ll_find = idw_detail.Find("cod_maquina = '" + ls_cod_maq + "'", 1, idw_detail.RowCount())
	
	if ll_find = 0 then
		ll_row = idw_detail.event dynamic ue_insert()
		if ll_row > 0 then
			idw_detail.object.cod_maquina	[ll_row] = lds_data.object.cod_maquina	[ll_i]
			idw_detail.object.desc_maquina[ll_row] = lds_data.object.desc_maquina[ll_i]
			idw_detail.object.und		  	[ll_row] = lds_data.object.und			[ll_i]
			idw_detail.object.horometro 	[ll_row] = lds_data.object.horometro	[ll_i]
		end if
	end if
next

idw_detail.il_row = 0
idw_detail.SelectRow(0, False)
idw_detail.SetSort('cod_maquina A')
idw_detail.Sort()

DESTROY lds_data
end subroutine

public function decimal of_num_horas_inc ();string	ls_cod_maq
Long 		ll_row, ll_i
Decimal	ldc_horas, ldc_hrs_cab, ldc_hrs_det, ldc_hrs_inc, ldc_tmp

ll_row = idw_detail.il_row

if ll_row = 0 then
	MessageBox('Aviso', 'Debe seleccionar un equipo')
	SetNull(ldc_horas)
	return ldc_horas
end if

if dw_master.GetRow() = 0 then
	MessageBox('Aviso', 'No existe Cabecera en el Parte')
	SetNull(ldc_horas)
	return ldc_horas
end if

ls_cod_maq = idw_detail.object.cod_maquina[ll_row]

ldc_hrs_cab = Dec(dw_master.object.und_trabaj[dw_master.GetRow()])
ldc_hrs_det = Dec(idw_detail.object.und_trabaj[ll_row])

If ISNull(ldc_hrs_cab) then ldc_hrs_cab = 0
if IsNull(ldc_hrs_det) then ldc_hrs_det = 0

ldc_hrs_inc = 0

idw_incid.SetFilter("cod_maquina = '" + ls_cod_maq + "'")
idw_incid.Filter()

for ll_i = 1 to idw_incid.RowCount()
	ldc_tmp	= Dec(idw_incid.object.und_no_trabaj[ll_i])
	if IsNull(ldc_tmp) then ldc_tmp = 0
	ldc_hrs_inc += ldc_tmp
next

if ldc_hrs_det = ldc_hrs_cab then
	MessageBox('Aviso', 'No puede ingresar registros de incidencias')
	ldc_horas = 0
end if

ldc_horas = ldc_hrs_cab - (ldc_hrs_det + ldc_hrs_inc)

if ldc_horas < 0 then
	MessageBox('Aviso', 'El Total de Unidades supera a la Cabecera del Parte Diario')
	ldc_horas = 0
end if

if ldc_horas = 0 then
	MessageBox('Aviso', 'Ya se ha completado el total de unidades efectivas del parte')
	ldc_horas = 0
end if


return ldc_horas



end function

on w_ma306_pd_agruphor.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_list" then this.MenuID = create m_abc_master_list
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_ma306_pd_agruphor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;idw_detail = tab_1.tabpage_1.dw_detail
idw_incid  = tab_1.tabpage_2.dw_incid

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width  = tab_1.width  - idw_detail.x - 50
idw_detail.height = tab_1.height - idw_detail.y - 150

idw_incid.width  = tab_1.width  - idw_incid.x - 50
idw_incid.height = tab_1.height - idw_incid.y - 150
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_incid.SetTransObject(SQLCA)

idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 
idw_detail.of_protect()
idw_incid.of_protect()


end event

event ue_insert;call super::ue_insert;Long  ll_row
Decimal ldc_horas

if idw_1 = dw_master then
	This.TriggerEvent("ue_update_request")
	idw_detail.Reset()
	idw_incid.Reset()
	dw_master.Reset()
	is_action = 'new'
elseif idw_1 = idw_detail then
	if dw_master.GetRow() = 0 then
		MessageBox('Aviso', 'No puede ingresar un detalle sin cabecera')
		return
	end if
elseif idw_1 = idw_incid then
	if dw_master.GetRow() = 0 then
		MessageBox('Aviso', 'No puede ingresar un detalle sin cabecera')
		return
	end if
	if idw_detail.il_row = 0 then
		MessageBox('Aviso', 'Debe seleccionar algun equipo para ingresar sus incidencias')
		return
	end if
	ldc_horas = of_num_horas_inc()
	if IsNull(ldc_horas) or ldc_horas = 0 then
		return
	end if
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	ib_modify = true
end if


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update  = 1 OR &
	 idw_detail.ii_update = 1 OR &
	 idw_incid.ii_update  = 1) THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 	= 0
		idw_detail.ii_update = 0
		idw_incid.ii_update 	= 0
	END IF
END IF

end event

event ue_update;call super::ue_update;long ll_row
Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 THEN
	IF idw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_incid.ii_update = 1 THEN
	IF idw_incid.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Incidencias","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_incid.ii_update = 0
	
	is_action = 'save'
	if dw_master.GetRow() = 0 then return
	of_retrieve(dw_master.object.nro_parte[dw_master.GetRow()])
END IF


end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
is_action = 'edit'
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'ds_list_pd_agruphores_grid'
sl_param.titulo = "Partes Diario Agruphores"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = ''

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	This.of_retrieve (sl_param.field_ret[1])	
END IF
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

if f_row_Processing( dw_master, "form") <> true then return

if f_row_Processing( idw_detail, "tabular") <> true then return

if f_row_Processing( idw_incid, "tabular") <> true then return

if of_set_numera() = 0 then return

dw_master.of_set_flag_replicacion( )
idw_detail.of_set_flag_replicacion( )
idw_incid.of_set_flag_replicacion( )

ib_update_check = true
end event

event open;// Override
idw_detail = tab_1.tabpage_1.dw_detail
idw_incid  = tab_1.tabpage_2.dw_incid

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_delete;call super::ue_delete;is_action = 'del'
end event

event ue_print;call super::ue_print;OpenSheet (w_ma717_rpt_agruphor, w_main, 0, Layered!)

end event

type tab_1 from tab within w_ma306_pd_agruphor
event create ( )
event destroy ( )
integer y = 580
integer width = 2747
integer height = 1316
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

event selectionchanged;Long ll_row
string	ls_cod_maq
if newindex = 2 then
	ll_row = idw_detail.il_row
	if ll_row = 0 then
		MessageBox('Error', 'Debe Selecionar un codigo de maquina')
		return
	end if
	
	ls_cod_maq = idw_detail.object.cod_maquina [ll_row]
	
	idw_incid.SetFilter("cod_maquina = '" + ls_cod_maq + "'")
	idw_incid.Filter()
	
end if
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2711
integer height = 1188
long backcolor = 79741120
string text = "Máquinas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer width = 2683
integer height = 1180
integer taborder = 30
string dataobject = "d_abc_pd_agruphor_det_grid"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, ls_horometro
Long		ll_find


CHOOSE CASE lower(as_columna)
	CASE 'cod_maquina'
		ls_sql = "SELECT cod_maquina AS CODIGO_maquina, " &   
				 + "DESC_maq AS DESCRIPCION_maquina, " &
				 + "und as unidad, " &
				 + "ind_act_acumulada as horometro " &
				 + "FROM maquina " &
				 + "where flag_estado = '1' "
												
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_und, ls_horometro, '2')
		
		if ls_codigo <> '' then
		
			ll_find = this.Find("cod_maquina = '" + ls_codigo + "'", 1, this.RowCount())
			
			if ll_find <> al_row and ll_find > 0 then
				messagebox('Aviso', 'Codigo de maquina yaexiste en este parte')
				return 
			end if			
			
			this.object.cod_maquina		[al_row] = ls_codigo
			this.object.desc_maquina	[al_row] = ls_data
			this.object.und				[al_row] = ls_und
			this.object.horometro		[al_row] = dec(ls_horometro)
			this.ii_update = 1
		end if

END CHOOSE

end event

event clicked;call super::clicked;string ls_cod_maq
if f_row_processing( idw_incid, 'tabular') = false then
	tab_1.SelectedTab = 2
	idw_incid.SetFocus()	
	return 0
end if

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


if row = 0 then return
this.il_row = row

ls_cod_maq = this.object.cod_maquina [row]

if IsNull(ls_cod_maq) or ls_cod_maq = '' then return

idw_incid.SetFilter("cod_maquina = '" + ls_cod_maq + "'")
idw_incid.Filter()



end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

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

event ue_delete_all;// Ancestor Script has been Override
long ll_row = 1, ll_cnt, ll_deleted_row

do while this.RowCount() > 0
	ll_deleted_row = THIS.DeleteRow (0)
	If ll_deleted_row <> 1 Then
		ll_row = -1
		messagebox("Error en Eliminacion detalle","No se ha procedido",exclamation!)
		EXIT
	ELSE
		ll_row = 1
		this.il_totdel ++
		this.ii_update = 1
	End If
loop

RETURN ll_row
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_nro_parte
decimal	ldc_und_trabaj
if dw_master.GetRow() = 0 then return

ls_nro_parte   = dw_master.object.nro_parte		[dw_master.GetRow()]
ldc_und_trabaj	= dec(dw_master.object.und_trabaj[dw_master.GetRow()])

this.object.nro_parte	[al_row] = ls_nro_parte
this.object.und_trabaj 	[al_row] = ldc_und_trabaj
end event

event itemchanged;call super::itemchanged;string 	ls_desc, ls_null, ls_und
Decimal	ldc_horometro, ldc_und_cab, ldc_null, ll_find

SetNull(ls_null)
SetNull(ldc_null)
this.AcceptText()

choose case lower(dwo.name)

	case 'cod_maquina'
		
		select desc_maq, und, IND_ACT_ACUMULADA
		   into :ls_desc, :ls_und, :ldc_horometro
		from maquina
		where flag_estado = '1'
	     and cod_maquina = :data;
		
		if sqlca.sqlcode = 100 then
			SetNull(ldc_horometro)
			this.object.cod_maquina	 [row] = ls_null
			this.object.desc_maquina [row] = ls_null
			this.object.und			 [row] = ls_null
			this.object.horometro	 [row] = ldc_horometro
			messagebox('Aviso', 'Codigo de maquina no existe o no esta activo')
			return 1
		end if
		
		ll_find = this.Find("cod_maquina = '" + data + "'", 1, this.RowCount())
		
		if ll_find <> row and ll_find > 0 then
			SetNull(ldc_horometro)
			this.object.cod_maquina	 [row] = ls_null
			this.object.desc_maquina [row] = ls_null
			this.object.und			 [row] = ls_null
			this.object.horometro	 [row] = ldc_horometro
			messagebox('Aviso', 'Codigo de maquina yaexiste en este parte')
			return 1
		end if
		
		
		this.object.desc_maquina [row] = ls_desc
		this.object.und			 [row] = ls_und
		this.object.horometro	 [row] = ldc_horometro
	
	case 'und_trabaj'
		if dw_master.GetRow() = 0 then 
			MessageBox('AViso', 'No existe Cabecera del Parte Diario')
			this.object.und_trabaj[row] = ldc_null
			return 1
		end if
		
		ldc_und_cab = dw_master.object.und_trabaj[dw_master.GetRow()]
		
		if Dec(data) > ldc_und_cab then
			MessageBox('Aviso', 'La Cantidad de und trabaj no puede superar a la Cabecera del parte')
			this.object.und_trabaj[row] = ldc_null
			return 1
		end if
		
end choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2711
integer height = 1188
long backcolor = 79741120
string text = "Incidencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_incid dw_incid
end type

on tabpage_2.create
this.dw_incid=create dw_incid
this.Control[]={this.dw_incid}
end on

on tabpage_2.destroy
destroy(this.dw_incid)
end on

type dw_incid from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer width = 2665
integer height = 1180
integer taborder = 20
string dataobject = "d_pd_grupo_incidencias_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);string ls_codigo, ls_data, ls_sql, ls_und


CHOOSE CASE lower(as_columna)
	CASE 'cod_incidencia'
		ls_sql = "SELECT cod_incidencia AS CODIGO_incidencia, " &   
				 + "DESC_incidencia AS DESCRIPCION_incidencia " &
				 + "FROM incidencias_dma " &
				 + "where flag_estado = '1' "
												
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_incidencia	[al_row] = ls_codigo
			this.object.desc_incidencia[al_row] = ls_data
			this.ii_update = 1
		end if

	CASE 'causa_falla'
		ls_sql = "SELECT causa_falla AS CODIGO_causa_falla, " &   
				 + "DESC_causa AS DESCRIPCION_causa_falla " &
				 + "FROM causa_fallas " 
												
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.causa_falla	[al_row] = ls_codigo
			this.object.desc_causa	[al_row] = ls_data
			this.ii_update = 1
		end if

END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_parte, ls_cod_maq, ls_desc_maq

if dw_master.GetRow() = 0 then return

if idw_detail.GetRow() = 0 then
	MessageBox('Error', 'Debe Seleccionar alguna maquina')
	return
end if

ls_nro_parte = dw_master.object.nro_parte[dw_master.GetRow()]
ls_cod_maq	 = idw_detail.object.cod_maquina [idw_detail.GetRow()]
select desc_maq
	into :ls_desc_maq
from maquina
where cod_maquina = :ls_cod_maq;

this.object.nro_parte		[al_row] = ls_nro_parte
this.object.cod_maquina 	[al_row] = ls_cod_maq
this.object.desc_maquina 	[al_row] = ls_desc_maq
this.object.und_no_trabaj 	[al_row] = of_num_horas_inc()

this.GroupCalc()
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event itemchanged;call super::itemchanged;string 	ls_desc, ls_null, ls_und

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)

	case 'cod_incidencia'
		
		select desc_incidencia
		   into :ls_desc
		from incidencias_dma
		where flag_estado = '1'
	     and cod_incidencia = :data;
		
		if sqlca.sqlcode = 100 then
			this.object.cod_incidencia	 [row] = ls_null
			this.object.desc_incidencia [row] = ls_null
			messagebox('Aviso', 'Codigo de Incidencia no existe o no esta activo')
			return 1
		end if
		
		this.object.desc_incidencia [row] = ls_desc

	case 'causa_falla'
		
		select desc_causa
		   into :ls_desc
		from causa_fallas
		where causa_falla = :data;
		
		if sqlca.sqlcode = 100 then
			this.object.causa_falla[row] = ls_null
			this.object.desc_causa [row] = ls_null
			messagebox('Aviso', 'Causa o falla no existe o no esta activo')
			return 1
		end if
		
		this.object.desc_causa [row] = ls_desc
		
end choose
end event

type dw_master from u_dw_abc within w_ma306_pd_agruphor
event ue_display ( string as_columna,  long al_row )
integer width = 2702
integer height = 560
string dataobject = "d_abc_pd_agruphor_ff"
end type

event doubleclicked;call super::doubleclicked;string 	ls_sql, ls_return1, ls_return2, ls_return3
long 		ll_row 
Datawindow 	ldw

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

choose case lower(dwo.name)
	case 'fecha'
		f_call_calendar( ldw, dwo.name, dwo.coltype, row)
		this.ii_update = 1
		
	case 'turno'
		ls_sql = "select turno as codigo, " &
				 + "descripcion as turno " &
				 + "from turno	" &
				 + "where flag_estado = '1'"
				 
		f_lista(ls_sql, ls_return1, ls_return2, '1')
		
		if ls_return1 <> '' then
			this.object.turno [row] = ls_return1
			this.object.desc_turno [row] = ls_return2
			this.ii_update = 1
		end if
		
	case 'cod_maquina'
		ls_sql = "select cod_maquina as codigo_maquina, " &
				 + "desc_maq as descripcion_maquina, " &
				 + "und as unidad " &
				 + "from vw_mt_maq_estruc " &
				 + "where flag_estado = '1'"
				 
		f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')
		
		if ls_return1 <> '' then
			this.object.cod_maquina [row] = ls_return1
			this.object.desc_maquina[row] = ls_return2
			this.object.und			[row] = ls_return3
			this.ii_update = 1
			of_fill_maquina()
		end if
		
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fecha 		[al_row] = f_fecha_actual()
this.object.und_trabaj	[al_row] = 0.00
is_Action = 'new'
end event

event itemchanged;call super::itemchanged;string 	ls_desc, ls_null, ls_und
decimal	ldc_und_trabaj
Long		ll_i

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)

	case "turno"
		
		select descripcion 
		   into :ls_desc
		from turno
		where flag_estado = '1'
		  and turno = :data;
		
		if sqlca.sqlcode = 100 then
			this.object.turno 	 [row] = ls_null
			this.object.desc_turno[row] = ls_null
			messagebox('Aviso', 'Codigo de turno no existe o no esta activo')
			return 1
		end if
		
		this.object.desc_turno [row] = ls_desc

	case 'cod_maquina'
		
		select desc_maq, und
		   into :ls_desc, :ls_und
		from maquina
		where flag_estado = '1'
	     and cod_maquina = :data;
		
		if sqlca.sqlcode = 100 then
			this.object.cod_maquina	 [row] = ls_null
			this.object.desc_maquina [row] = ls_null
			this.object.und			 [row] = ls_null
			messagebox('Aviso', 'Codigo de maquina no existe o no esta activo')
			return 1
		end if
		
		this.object.desc_maquina [row] = ls_desc
		this.object.und			 [row] = ls_und
		of_fill_maquina()
	
	case "und_trabaj"
		if is_action='new' then
			ldc_und_trabaj	= Dec(data)
			for ll_i=1 to idw_detail.RowCount()
				idw_detail.object.und_trabaj [ll_i] = ldc_und_trabaj		
			next
		end if
end choose
end event

