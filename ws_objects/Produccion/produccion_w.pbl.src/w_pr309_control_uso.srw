$PBExportHeader$w_pr309_control_uso.srw
forward
global type w_pr309_control_uso from w_abc_master_smpl
end type
type dw_firmas from u_dw_abc within w_pr309_control_uso
end type
type st_master from statictext within w_pr309_control_uso
end type
type st_firmas from statictext within w_pr309_control_uso
end type
type st_comentarios from statictext within w_pr309_control_uso
end type
type dw_comentarios from u_dw_abc within w_pr309_control_uso
end type
type cbx_fecha from checkbox within w_pr309_control_uso
end type
type uo_1 from u_ingreso_rango_fechas within w_pr309_control_uso
end type
type p_arrow from picture within w_pr309_control_uso
end type
type dw_chata from u_dw_abc within w_pr309_control_uso
end type
type st_chata from statictext within w_pr309_control_uso
end type
type tab_1 from tab within w_pr309_control_uso
end type
type tabpage_1 from userobject within tab_1
end type
type uo_carga_fecha from uo_fecha_hora within tabpage_1
end type
type st_incidencias from statictext within tabpage_1
end type
type dw_horas from u_dw_abc within tabpage_1
end type
type cb_1 from commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
uo_carga_fecha uo_carga_fecha
st_incidencias st_incidencias
dw_horas dw_horas
cb_1 cb_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_incidencias from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_incidencias dw_incidencias
end type
type tab_1 from tab within w_pr309_control_uso
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type p_1 from picture within w_pr309_control_uso
end type
type em_nro_parte from singlelineedit within w_pr309_control_uso
end type
type st_1 from statictext within w_pr309_control_uso
end type
type gb_1 from groupbox within w_pr309_control_uso
end type
type gb_2 from groupbox within w_pr309_control_uso
end type
end forward

global type w_pr309_control_uso from w_abc_master_smpl
integer width = 3575
integer height = 1984
string title = "Parte de piso(PR309) "
string menuname = "m_mantto_lista_smpl"
dw_firmas dw_firmas
st_master st_master
st_firmas st_firmas
st_comentarios st_comentarios
dw_comentarios dw_comentarios
cbx_fecha cbx_fecha
uo_1 uo_1
p_arrow p_arrow
dw_chata dw_chata
st_chata st_chata
tab_1 tab_1
p_1 p_1
em_nro_parte em_nro_parte
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_pr309_control_uso w_pr309_control_uso

type variables
string is_nro_parte, is_cod_maquina, is_column
long il_firmas
integer ii_mesg, ii_focus, ii_tab
end variables

forward prototypes
public subroutine of_carga_valores ()
public function integer of_firmas ()
public subroutine of_update ()
public subroutine of_cuenta_incidencia ()
public subroutine of_verifica_fecha (string as_columna)
public function integer of_horas ()
end prototypes

public subroutine of_carga_valores ();long ll_incidencias
tab_1.tabpage_2.dw_incidencias.retrieve(is_nro_parte, is_cod_maquina)
ll_incidencias = tab_1.tabpage_2.dw_incidencias.rowcount( )
if ll_incidencias >= 1 then
	tab_1.tabpage_2.dw_incidencias.setrow(1)
	tab_1.tabpage_2.dw_incidencias.scrolltorow(1)
	tab_1.tabpage_2.dw_incidencias.selectrow(1,true)
end if
tab_1.tabpage_2.dw_incidencias.setfocus()
end subroutine

public function integer of_firmas ();if il_firmas >= 1 then
	if ii_mesg = 0 then
		messagebox('Control de Piso','El parte de piso ya ha sido firmado, ~r no se puede modificar mientras ~r tega firmas registradas',StopSign!)
	end if
	ii_mesg = 0
	return il_firmas
else
	return 0
end if

end function

public subroutine of_update ();this.event ue_update()
end subroutine

public subroutine of_cuenta_incidencia ();long ll_cuenta, ll_total, ll_parada
string ls_total, ls_parada, ls_msg
declare usp_incid_count procedure for 
	usp_ppiso_tuso_inc_count(:is_nro_parte, :is_cod_maquina);
execute usp_incid_count;
fetch usp_incid_count into :ll_cuenta, :ll_total, :ll_parada;

ls_total = string(round((ll_total/100),2))
ls_parada =string(round((ll_parada/100),2)) 

if ll_cuenta >= 1 then
	ls_msg = 'Total de incidencias : ' + trim(string(ll_cuenta)) + ' Tiempo total: ' + ls_total
	if ll_parada > 0 then
		ls_msg = ls_msg + ' Tiempo de parada : ' + ls_parada
	end if
	ls_msg = ls_msg + ' (Tiempo expresado en horas)'
else
	ls_msg = 'No hay incidencias'
end if
close usp_incid_count;
tab_1.tabpage_1.st_incidencias.text = ls_msg
end subroutine

public subroutine of_verifica_fecha (string as_columna);long ll_horas, ll_cuenta
datetime ldt_hora_apagado, ldt_hora_encendido, ldt_hora_inicio, ldt_hora_fin
string ls_column
tab_1.tabpage_1.dw_horas.accepttext()


ll_horas = tab_1.tabpage_1.dw_horas.getrow()

ldt_hora_apagado = tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_horas]
ldt_hora_encendido = tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_horas]

if ldt_hora_apagado < ldt_hora_encendido then
	if ls_column = 'hora_apagado' then
		tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_horas] = tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_horas]
		messagebox(this.title,'La hora de apagado debe ser mayor que la hora de encendido',stopsign!)
	else
		tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_horas] = tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_horas]
		messagebox(this.title,'La hora de encendido debe ser menor que la hora de apagado',stopsign!)
	end if
end if

declare usp_horas_verify procedure for 
	usp_tg_parte_piso_tuso_verify(:is_nro_parte, :is_cod_maquina);

execute usp_horas_verify;
fetch usp_horas_verify into :ll_cuenta, :ldt_hora_inicio, :ldt_hora_fin;
if ll_cuenta >= 1 then
	if ls_column = 'hora_encendido' then
		if ldt_hora_encendido > ldt_hora_inicio then
			messagebox('Error','Existe al menos una incidencia para esta ~r máquina que inicia en ' + trim(string(ldt_hora_inicio, 'dd/mm/yyyy hh:mm')) + '. ~r No se puede proceder cambiar la hora de ~r encendido del equipo',stopsign!)
			tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_horas] = ldt_hora_inicio
		end if
	else
		if ldt_hora_apagado < ldt_hora_fin then
			messagebox('Error','Existe al menos una incidencia para esta ~r máquina que termina en ' + trim(string(ldt_hora_fin, 'dd/mm/yyyy hh:mm')) + '. ~r No se puede proceder cambiar la hora de  ~r apagado del equipo',stopsign!)
			tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_horas] = ldt_hora_fin
		end if
	end if
end if
close usp_horas_verify;
end subroutine

public function integer of_horas ();long ll_horas

ll_horas = tab_1.tabpage_1.dw_horas.getrow()

if ll_horas <= 0 then
	messagebox('Error', 'Debe haber seleccioando primero un registro de horas de funcionamiento', stopsign!)
	return 0
else
	return 1
end if
end function

on w_pr309_control_uso.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_lista_smpl" then this.MenuID = create m_mantto_lista_smpl
this.dw_firmas=create dw_firmas
this.st_master=create st_master
this.st_firmas=create st_firmas
this.st_comentarios=create st_comentarios
this.dw_comentarios=create dw_comentarios
this.cbx_fecha=create cbx_fecha
this.uo_1=create uo_1
this.p_arrow=create p_arrow
this.dw_chata=create dw_chata
this.st_chata=create st_chata
this.tab_1=create tab_1
this.p_1=create p_1
this.em_nro_parte=create em_nro_parte
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_firmas
this.Control[iCurrent+2]=this.st_master
this.Control[iCurrent+3]=this.st_firmas
this.Control[iCurrent+4]=this.st_comentarios
this.Control[iCurrent+5]=this.dw_comentarios
this.Control[iCurrent+6]=this.cbx_fecha
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.p_arrow
this.Control[iCurrent+9]=this.dw_chata
this.Control[iCurrent+10]=this.st_chata
this.Control[iCurrent+11]=this.tab_1
this.Control[iCurrent+12]=this.p_1
this.Control[iCurrent+13]=this.em_nro_parte
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_pr309_control_uso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_firmas)
destroy(this.st_master)
destroy(this.st_firmas)
destroy(this.st_comentarios)
destroy(this.dw_comentarios)
destroy(this.cbx_fecha)
destroy(this.uo_1)
destroy(this.p_arrow)
destroy(this.dw_chata)
destroy(this.st_chata)
destroy(this.tab_1)
destroy(this.p_1)
destroy(this.em_nro_parte)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;dw_comentarios.width = newwidth - dw_comentarios.x - 10
dw_comentarios.height = newheight - dw_comentarios.y - 10

st_comentarios.width = newwidth - st_comentarios.x - 10
st_chata.width = newwidth - st_chata.x - 10
st_firmas.width = newwidth - st_firmas.x - 10
tab_1.width = newwidth - tab_1.x - 10
tab_1.tabpage_1.dw_horas.width = newwidth - tab_1.tabpage_1.dw_horas.x - 10
tab_1.tabpage_2.dw_incidencias.width = newwidth - tab_1.tabpage_2.dw_incidencias.x - 10
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
ii_focus = 0
dw_firmas.of_protect()
dw_chata.of_protect()
dw_comentarios.of_protect()
tab_1.tabpage_1.dw_horas.of_protect()
tab_1.tabpage_2.dw_incidencias.of_protect()
end event

event ue_dw_share;integer li_grabar
string ls_desc_maq
long ll_horas

if ii_lec_mst = 0 then return

is_nro_parte = trim(em_nro_parte.text)

if isnull(is_nro_parte) or trim(is_nro_parte) = '' then 
	messagebox(this.title,'No ha seleccioando número de parte',stopsign!)
	return
end if

if dw_master.ii_update = 1 or dw_firmas.ii_update = 1 or dw_chata.ii_update = 1 or dw_comentarios.ii_update = 1 or tab_1.tabpage_1.dw_horas.ii_update = 1 or tab_1.tabpage_2.dw_incidencias.ii_update = 1 then
	li_grabar = messagebox(this.title,'El parte de piso que se muestra ~r en pantalla ha sido modificado, ~r ¿Desea gracarlo?',Question!, YesNoCancel!)
	choose case li_grabar
	case 1
		this.event ue_update()
	case 2
		messagebox(this.title,'Se han cancelado los cambio para el parte ~r de piso de control de tiempos anterior',Exclamation!)
	case 3
		return
end choose

end if

dw_master.reset()
dw_firmas.reset()
dw_chata.reset()
dw_comentarios.reset()
tab_1.tabpage_1.dw_horas.reset()
tab_1.tabpage_2.dw_incidencias.reset()


dw_master.retrieve(is_nro_parte)

if dw_master.rowcount() >= 1 then

	dw_firmas.retrieve(is_nro_parte)
	dw_chata.retrieve(is_nro_parte)
	dw_comentarios.retrieve(is_nro_parte)
	tab_1.tabpage_1.dw_horas.retrieve(is_nro_parte)
	
	ll_horas = tab_1.tabpage_1.dw_horas.rowcount()

	if ll_horas >= 1 then
		tab_1.SelectTab(1)
		tab_1.tabpage_1.dw_horas.setrow(1)
		tab_1.tabpage_1.dw_horas.scrolltorow(1)
		tab_1.tabpage_1.dw_horas.selectrow(1,true)
		tab_1.tabpage_1.dw_horas.setfocus()
		is_cod_maquina = tab_1.tabpage_1.dw_horas.object.cod_maquina[1]
		ls_desc_maq = tab_1.tabpage_1.dw_horas.object.desc_maq[1]
		
	end if

end if

dw_master.il_row = dw_master.getrow()
il_firmas = dw_firmas.rowcount()


end event

event ue_list_open;call super::ue_list_open;string ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_where, ls_fecha_ini, ls_fecha_fin
ls_where = ''

if cbx_fecha.checked = true then
	ls_fecha_ini = string(uo_1.of_get_fecha1(), 'dd/mm/yyyy')
	ls_fecha_fin = string(uo_1.of_get_fecha2(), 'dd/mm/yyyy')
	ls_where  = " where to_date(parte_fecha, 'dd/mm/yyyy') >= to_date('"+ls_fecha_ini+"', 'dd/mm/yyyy') and to_date(parte_fecha, 'dd/mm/yyyy') <= to_date('"+ls_fecha_fin+"', 'dd/mm/yyyy')"
end if
ls_sql = "select flag_tipo as tipo, nro_parte as numero, descripcion as turno, parte_fecha as fecha from vw_pr_tiempo_uso" + ls_where

f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '1')

if isnull(ls_return2) or trim(ls_return2) = '' then
	return
else
	is_nro_parte = ls_return2
	ii_lec_mst = 1
	em_nro_parte.text = is_nro_parte
	this.event ue_dw_share()
end if
end event

event ue_update;Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_firmas.of_create_log()
	dw_chata.of_create_log()
	dw_comentarios.of_create_log()
	tab_1.tabpage_1.dw_horas.of_create_log()
	tab_1.tabpage_2.dw_incidencias.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_firmas.ii_update = 1 THEN
	IF dw_firmas.Update() = -1 then		// Grabacion de las firmas
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_chata.ii_update = 1 THEN
	IF dw_chata.Update() = -1 then		// Grabacion de la chata
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_comentarios.ii_update = 1 THEN
	IF dw_comentarios.Update() = -1 then		// Grabacion de los comentarios (observaciones / acciones correctiva)
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_1.tabpage_1.dw_horas.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_horas.Update() = -1 then		// Grabacion de los comentarios (observaciones / acciones correctiva)
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_1.tabpage_2.dw_incidencias.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_incidencias.Update() = -1 then		// Grabacion de los comentarios (observaciones / acciones correctiva)
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		dw_firmas.of_save_log()
		dw_chata.of_save_log()
		dw_comentarios.of_save_log()
		tab_1.tabpage_1.dw_horas.of_save_log()
		tab_1.tabpage_2.dw_incidencias.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_firmas.ii_update = 0
	dw_chata.ii_update = 0
	tab_1.tabpage_1.dw_horas.ii_update = 0
	tab_1.tabpage_2.dw_incidencias.ii_update = 0
	dw_comentarios.ii_update = 0
	dw_master.il_totdel = 0
	dw_firmas.il_totdel = 0
	dw_chata.il_totdel = 0
	dw_comentarios.il_totdel = 0
	tab_1.tabpage_1.dw_horas.il_totdel = 0
	tab_1.tabpage_2.dw_incidencias.il_totdel = 0
END IF

end event

event ue_modify;if dw_master.ii_update = 1 or dw_firmas.ii_update = 1 or dw_chata.ii_update = 1 or dw_comentarios.ii_update = 1 or tab_1.tabpage_2.dw_incidencias.ii_update = 1 or tab_1.tabpage_1.dw_horas.ii_update = 1 then
	if messagebox('Control de Horas','¿Desea grabar los cambios?',Question!) = 1 then
		this.event ue_update()
	end if
end if

if of_firmas() >= 1 then
	dw_master.ii_protect = 0
	dw_firmas.ii_protect = 0
	dw_chata.ii_protect = 0
	dw_comentarios.ii_protect = 0
	tab_1.tabpage_1.dw_horas.ii_protect  = 0
	tab_1.tabpage_2.dw_incidencias.ii_protect  = 0
end if

dw_master.of_protect()
dw_firmas.of_protect()
dw_chata.of_protect()
dw_comentarios.of_protect()
tab_1.tabpage_1.dw_horas.of_protect()
tab_1.tabpage_2.dw_incidencias.of_protect()
end event

event ue_query_retrieve;ii_lec_mst = 1
this.event ue_dw_share()
end event

event ue_update_request;IF dw_master.ii_update = 1 or dw_firmas.ii_update = 1 or dw_chata.ii_update = 1 or tab_1.tabpage_1.dw_horas.ii_update = 1 or tab_1.tabpage_2.dw_incidencias.ii_update = 1 or dw_comentarios.ii_update = 1 THEN
	IF MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1) = 1 then THIS.EVENT ue_update()
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_firmas.of_set_flag_replicacion( )
dw_chata.of_set_flag_replicacion( )
dw_comentarios.of_set_flag_replicacion( )
tab_1.tabpage_1.dw_horas.of_set_flag_replicacion( )
tab_1.tabpage_2.dw_incidencias.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr309_control_uso
integer y = 200
integer width = 1925
integer height = 564
integer taborder = 20
string dataobject = "d_pr_tiempo_uso_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail


end event

event dw_master::ue_insert_pre;string ls_nro_parte
dw_master.visible = false
declare usp_parte_piso procedure for
   usp_tg_parte_piso_tuso(:gs_origen, :gs_user);

execute usp_parte_piso;
fetch usp_parte_piso into :ls_nro_parte;
close usp_parte_piso;
if isnull(ls_nro_parte) or len(trim(ls_nro_parte)) < 10 then
	messagebox(this.title,'Error al generar el número, intente nuevamente',StopSign!)
	return
else
	is_nro_parte = ls_nro_parte
	dw_master.retrieve(ls_nro_parte)
	dw_master.visible = true
end if
il_row = this.getrow()
end event

event dw_master::doubleclicked;call super::doubleclicked;if ii_protect = 1 then return
long ll_parte, ll_master, ll_cuenta
string ls_column, ls_sql, ls_return1, ls_return2, ls_return3, ls_nro_parte, ls_formato

ll_parte = dw_master.getrow()
ls_column = trim(lower(string(dwo.name)))

choose case ls_column
	case 'turno'
		ls_sql = "select turno as codigo, descripcion as nombre from turno where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then
		else
			this.object.turno[ll_parte] = ls_return1
			this.object.turno_descripcion[ll_parte] = ls_return2
			ii_update = 1
		end if
	case 'formato'
		if tab_1.tabpage_1.dw_horas.rowcount() >= 1 then
			if messagebox(this.title,'Al cambiar de formato se perderán definitivamente ~r todas la horas e incidencias registradas. ~r  ~r ¿Desea proceder de todas maneras?',Question!, YesNo!, 2) = 2 then
				messagebox(this.title,'No se ha cambiado el formato',Information!)
				return 
			end if
		end if
		tab_1.tabpage_1.dw_horas.reset()
		tab_1.tabpage_2.dw_incidencias.reset()
		ll_master = dw_master.getrow()
		ls_sql = "select fmt_cod as codigo, fmt_desc as descripcion, lbr_desc as labor from vw_pr_formato_labor"
		f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then
		else
			this.object.formato[ll_parte] = ls_return1
			this.object.descripcion[ll_parte] = ls_return2
			this.object.desc_labor[ll_parte] = ls_return3
			tab_1.tabpage_1.dw_horas.retrieve(ls_return1)
			declare usp_tiempo_uso_det procedure for
				usp_pr_parte_tiempo_uso_det(:is_nro_parte,:ls_return1);
			execute usp_tiempo_uso_det;
			fetch usp_tiempo_uso_det into :ll_cuenta;
			close usp_tiempo_uso_det;
			tab_1.tabpage_1.dw_horas.retrieve(is_nro_parte)
			if ll_cuenta >= 1 then
				tab_1.tabpage_1.dw_horas.setrow(1)
				tab_1.tabpage_1.dw_horas.scrolltorow(1)
				tab_1.tabpage_1.dw_horas.selectrow(1,true)
				is_cod_maquina = tab_1.tabpage_1.dw_horas.object.cod_maquina[1]
			else
				messagebox(parent.title,'No se encontraron maquinas asociadas ~r al formato, verifique le formato',stopsign!)
			end if
			ii_update = 1
		end if
end choose
end event

event dw_master::getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(100,0,0)
st_chata.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
tab_1.tabpage_1.TabBackColor = rgb(0,0,100)
tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
end event

event dw_master::ue_delete;if of_firmas() >= 1 then return -1

long ll_row
ll_row = this.getrow()

if this.object.flag_estado[ll_row] = '0' then
	this.object.flag_estado[ll_row] = '1'
else
	this.object.flag_estado[ll_row] = '0'
end if
this.ii_update = 1

return(ll_row)
end event

event dw_master::itemchanged;call super::itemchanged;long ll_parte, ll_master
string ls_column, ls_code, ls_name, ls_labor, ls_flag_tipo, ls_turno, ls_formato, ls_documento_desc, ls_turno_descripcion, ls_descripcion, ls_desc_labor, ls_xnro_parte, ls_xformato
datetime ld_fecha_parte

ll_parte = dw_master.getrow()

ls_flag_tipo = this.object.flag_tipo[ll_parte]
ld_fecha_parte = this.object.fecha_parte[ll_parte]
ls_turno = this.object.turno[ll_parte]
ls_formato = this.object.formato[ll_parte]
ls_documento_desc = this.object.documento_desc[ll_parte]
ls_turno_descripcion = this.object.turno_descripcion[ll_parte]
ls_descripcion = this.object.descripcion[ll_parte]
ls_desc_labor = this.object.desc_labor[ll_parte]

this.accepttext()

if of_firmas() >= 1 then
	this.object.flag_tipo[ll_parte] = ls_flag_tipo 
	this.object.fecha_parte[ll_parte] = ld_fecha_parte
	this.object.turno[ll_parte] = ls_turno 
	this.object.documento_desc[ll_parte] = ls_documento_desc
	this.object.turno_descripcion[ll_parte] = ls_turno_descripcion
	this.object.formato[ll_parte] = ls_formato
	this.object.descripcion[ll_parte] = ls_descripcion
	this.object.desc_labor[ll_parte] = ls_desc_labor
	this.accepttext()
	return 2
end if

ls_column = string(dwo.name)
this.accepttext()

choose case ls_column
	case 'turno'
end choose
this.accepttext()
return 2
end event

type dw_firmas from u_dw_abc within w_pr309_control_uso
integer x = 1943
integer y = 204
integer width = 1486
integer height = 336
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_firma_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail

this.settransobject(sqlca);
end event

event ue_insert_pre;long ll_reco, ll_firmas
string ls_nombre, ls_user
datetime ldt_fecha
integer li_error
boolean lb_find

ll_firmas = dw_firmas.rowcount()
lb_find = false
for ll_reco = 1 to ll_firmas
	ls_user = trim(this.object.cod_usr[ll_reco])
	if ls_user = gs_user then
		lb_find = true
	end if
end for

this.setrow(al_row)
this.scrolltorow(al_row)
if lb_find = true then
	messagebox(this.title,'Usted ya firmó el parte de piso, ~r no necesita volver a hacerlo',StopSign!)
	this.event ue_delete()
	return
end if

declare usp_pr_firma procedure for 
	usp_pr_parte_diario_firma (:gs_user);

execute usp_pr_firma;
fetch usp_pr_firma into :ls_nombre, :ldt_fecha, :li_error;
close usp_pr_firma;

if li_error = 0 then
	this.object.nombre[al_row] = ls_nombre
	this.object.nro_parte[al_row] = is_nro_parte
	this.object.cod_usr[al_row] = gs_user
	this.object.fecha[al_row] = ldt_fecha
	this.ii_update = 1
else
	messagebox(this.title,'Problemas con su usuario... ~r Comuniquese con sistemas',StopSign!)
	this.event ue_delete()
end if
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(100,0,0)
st_comentarios.backcolor = rgb(0,0,100)
tab_1.tabpage_1.TabBackColor = rgb(0,0,100)
tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
end event

event losefocus;call super::losefocus;il_firmas = this.rowcount()

if il_firmas >= 1  then
	dw_master.ii_protect = 0
	dw_firmas.ii_protect = 0
	dw_chata.ii_protect = 0
	dw_comentarios.ii_protect = 0
	tab_1.tabpage_1.dw_horas.ii_protect = 0
	tab_1.tabpage_2.dw_incidencias.ii_protect = 0
	
else
	dw_master.ii_protect = 1
	dw_firmas.ii_protect = 1
	dw_chata.ii_protect = 1
	dw_comentarios.ii_protect = 1
	tab_1.tabpage_1.dw_horas.ii_protect = 1
	tab_1.tabpage_2.dw_incidencias.ii_protect = 1
end if

dw_master.of_protect()
dw_firmas.of_protect()
dw_chata.of_protect()
dw_comentarios.of_protect()
tab_1.tabpage_1.dw_horas.of_protect()
tab_1.tabpage_2.dw_incidencias.of_protect()
ii_mesg = 1

of_firmas()

end event

event ue_delete;string ls_user
long ll_row = 1
ls_user = trim(this.object.cod_usr[this.getrow()])

if ls_user <> gs_user then
	messagebox(this.title,'Usted no puede borrar la firtma de otro usuario',StopSign!)
	return this.getrow()
end if

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1
		if dw_master.ii_protect = 1 then
			dw_master.of_protect()
			dw_firmas.of_protect()
			dw_chata.of_protect()
			//dw_valores.of_protect()
			dw_comentarios.of_protect()	
		end if
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

type st_master from statictext within w_pr309_control_uso
integer y = 136
integer width = 1925
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Control de tiempo de uso"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_firmas from statictext within w_pr309_control_uso
integer x = 1938
integer y = 132
integer width = 1486
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Firmas"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_comentarios from statictext within w_pr309_control_uso
integer y = 1396
integer width = 3419
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Comentarios"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_comentarios from u_dw_abc within w_pr309_control_uso
integer y = 1464
integer width = 3415
integer height = 284
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_com_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
this.settransobject(sqlca);
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(100,0,0)
tab_1.tabpage_1.TabBackColor = rgb(0,0,100)
tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
end event

event ue_insert_pre;call super::ue_insert_pre;integer li_cuenta

declare usp_parte_piso_obs procedure for 
	usp_pr_parte_piso_obs(:is_nro_parte, :gs_user);

execute usp_parte_piso_obs;
fetch usp_parte_piso_obs into :li_cuenta;
close usp_parte_piso_obs;
if li_cuenta <= 0 then 
	messagebox(this.title,'No se pudo insertar el comentario',StopSign!)
	return
end if

dw_comentarios.retrieve(is_nro_parte);
end event

event ue_insert;if of_firmas() >= 1 then return -1
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event itemchanged;call super::itemchanged;long ll_obs
string ls_tipo_obs_pre, ls_obs_pre, ls_autor_pre
	
ll_obs = this.getrow()

ls_tipo_obs_pre = this.object.tipo_obs[ll_obs]
ls_obs_pre = this.object.obs[ll_obs]
ls_autor_pre = this.object.autor[ll_obs]
	
	this.accepttext()
	
if of_firmas() >= 1 then
	this.object.autor[ll_obs] = ls_autor_pre
	this.object.obs[ll_obs] = ls_obs_pre
	this.object.tipo_obs[ll_obs] = ls_tipo_obs_pre
	return 2	
end if
end event

type cbx_fecha from checkbox within w_pr309_control_uso
integer x = 18
integer y = 48
integer width = 672
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar para búsquedas"
boolean checked = true
end type

type uo_1 from u_ingreso_rango_fechas within w_pr309_control_uso
integer x = 663
integer y = 36
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(relativedate(today(), - 30), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type p_arrow from picture within w_pr309_control_uso
boolean visible = false
integer x = 9
integer y = 1012
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Custom035!"
boolean focusrectangle = false
end type

type dw_chata from u_dw_abc within w_pr309_control_uso
integer x = 1943
integer y = 620
integer width = 1486
integer height = 148
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_parte_piso_chata_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail

this.settransobject(sqlca);
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(100,0,0)
st_firmas.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
tab_1.tabpage_1.TabBackColor = rgb(0,0,100)
tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
end event

event ue_insert_pre;call super::ue_insert_pre;
string ls_sql, ls_return1, ls_return2

this.object.nro_parte[al_row] = is_nro_parte

ls_sql = "select zona_descarga as codigo, descripcion as nombre from ap_zona_descarga where flag_estado = '1'"

f_lista(ls_sql, ls_return1, ls_return2, '2')

if isnull(ls_return1) or trim(ls_return1) = '' then 
	this.event ue_delete( )
	return
end if

this.object.zona_descarga[al_row] = ls_return1
this.object.zona_descarga_descripcion[al_row] = ls_return2
end event

event doubleclicked;call super::doubleclicked;string ls_cols, ls_sql, ls_return1, ls_return2

if this.ii_protect = 1 or this.rowcount() < 1 then return

ls_cols = trim(lower(string(dwo.name)))

choose case ls_cols
	case 'zona_descarga'
		ls_sql = "select zona_descarga as codigo, descripcion as nombre from ap_zona_descarga where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.zona_descarga[row] = ls_return1
		this.object.zona_descarga_descripcion[row] = ls_return2
		this.ii_update = 1
end choose

end event

event itemchanged;call super::itemchanged;string ls_cols, ls_sql, ls_return1, ls_return2


this.accepttext()

ls_cols = trim(lower(string(dwo.name)))

choose case ls_cols
	case 'zona_descarga'
		select zona_descarga, descripcion 
		   into :ls_return1, :ls_return2
		   from ap_zona_descarga
			where flag_estado = '1'
			   and zona_descarga = :data;
		
		if sqlca.sqlcode = 100 then 
			messagebox(parent.title, 'No existe la zona de descarga ingresada')
		else
			this.object.zona_descarga[row] = ls_return1
			this.object.zona_descarga_descripcion[row] = ls_return2
		end if
		return 2
end choose
end event

event ue_delete;if of_firmas() >= 1 then
	return -1
end if

long ll_row = 1

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

event ue_insert;if of_firmas() >= 1 then
	return -1
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

type st_chata from statictext within w_pr309_control_uso
integer x = 1938
integer y = 544
integer width = 1486
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Zonas de Descarga"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type tab_1 from tab within w_pr309_control_uso
event create ( )
event destroy ( )
integer y = 768
integer width = 3419
integer height = 644
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean pictureonright = true
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

event selectionchanged;if ii_focus = 0 then return
long ll_incidencias
choose case newindex
	case 1
		if tab_1.tabpage_2.dw_incidencias.ii_update = 1 then
			if messagebox(parent.title,'Al cambiar de pestaña perderá las ~r incidendicas no registradas.  ~r  ~r ¿Desea guardar los cambios  ~r antes de proceder?',Question!, YesNo!) = 1 then
				parent.event ue_update()
				of_cuenta_incidencia()
			end if
			st_master.backcolor = rgb(0,0,100)
			st_chata.backcolor = rgb(0,0,100)
			st_firmas.backcolor = rgb(0,0,100)
			st_comentarios.backcolor = rgb(0,0,100)
			tab_1.tabpage_1.TabBackColor = rgb(100,0,0)
			tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
		end if
	case 2
		of_carga_valores()
end choose
ii_tab = 1
end event

event constructor;dw_master.setfocus()
idw_1 = dw_master
st_master.backcolor = rgb(100,0,0)
st_chata.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
tab_1.tabpage_1.TabBackColor = rgb(0,0,100)
tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
end event

event losefocus;ii_focus = 1
end event

event clicked;if this.selectedtab = 1 then
	tab_1.tabpage_1.dw_horas.setfocus()
else
	tab_1.tabpage_2.dw_incidencias.setfocus()
	if ii_tab = 0 then
		of_carga_valores()
	end if
end if
ii_tab = 1
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3383
integer height = 516
long backcolor = 79741120
string text = "Horas de funcionamiento de los equipos"
long tabtextcolor = 16777215
long tabbackcolor = 8388608
string picturename = "Custom015!"
long picturemaskcolor = 553648127
uo_carga_fecha uo_carga_fecha
st_incidencias st_incidencias
dw_horas dw_horas
cb_1 cb_1
end type

on tabpage_1.create
this.uo_carga_fecha=create uo_carga_fecha
this.st_incidencias=create st_incidencias
this.dw_horas=create dw_horas
this.cb_1=create cb_1
this.Control[]={this.uo_carga_fecha,&
this.st_incidencias,&
this.dw_horas,&
this.cb_1}
end on

on tabpage_1.destroy
destroy(this.uo_carga_fecha)
destroy(this.st_incidencias)
destroy(this.dw_horas)
destroy(this.cb_1)
end on

type uo_carga_fecha from uo_fecha_hora within tabpage_1
integer x = 2359
integer y = 440
integer taborder = 50
end type

on uo_carga_fecha.destroy
call uo_fecha_hora::destroy
end on

event constructor;call super::constructor;of_set_label('Encendido:')// para seatear el titulo del boton
of_set_fecha(DateTime(today(), now())) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900')) // rango inicial
is_column = 'hora_encendido'
end event

type st_incidencias from statictext within tabpage_1
integer y = 444
integer width = 2359
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_horas from u_dw_abc within tabpage_1
integer width = 3383
integer height = 432
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_uso_det_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
this.settransobject(sqlca);
this.SetRowFocusIndicator(p_arrow)

end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
tab_1.tabpage_1.TabBackColor = rgb(100,0,0)
tab_1.tabpage_2.TabBackColor = rgb(0,0,100)
end event

event rowfocuschanged;call super::rowfocuschanged;long ll_horas
string ls_desc_maq
ll_horas = this.getrow()
if ll_horas >= 1 then
	ls_desc_maq = WordCap(this.object.desc_maq[ll_horas])
	is_cod_maquina = this.object.cod_maquina[ll_horas]
	tab_1.tabpage_2.text = 'Incidencias de máquina : ' + ls_desc_maq
	of_cuenta_incidencia()
end if
end event

event ue_insert;
messagebox('Error','Para insertar una máquina, deberá modificar el formato',stopsign!)
return -1
end event

event ue_delete;
messagebox('Error','Para borrar una máquina, deberá modificar el formato',stopsign!)
return -1
end event

event itemchanged;call super::itemchanged;string ls_column

ls_column = lower(trim(string(dwo.name)))

of_verifica_fecha(ls_column)

return 2
end event

event itemfocuschanged;call super::itemfocuschanged;is_column = lower(string(dwo.name))
choose case is_column
	case 'hora_encendido'
		tab_1.tabpage_1.uo_carga_fecha.of_set_label('Encendido:')
	case 'hora_apagado'
		tab_1.tabpage_1.uo_carga_fecha.of_set_label('Apagado:')
end choose
end event

event clicked;call super::clicked;is_column = lower(string(dwo.name))

if is_column = 'hora_encendido' then

	tab_1.tabpage_1.uo_carga_fecha.of_set_label('Encendido:')
else

	tab_1.tabpage_1.uo_carga_fecha.of_set_label('Apagado:')
end if

end event

type cb_1 from commandbutton within tabpage_1
integer x = 3081
integer y = 444
integer width = 306
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reemplazar"
end type

event clicked;string ls_column
long ll_fila, ll_horas
datetime ldt_carga

ls_column = is_column

if tab_1.tabpage_1.dw_horas.ii_protect = 1 then return

ldt_carga = tab_1.tabpage_1.uo_carga_fecha.of_get_fecha1()

ll_horas = tab_1.tabpage_1.dw_horas.rowcount()

if ll_horas <= 0 then return
for ll_fila = 1 to ll_horas
	tab_1.tabpage_1.dw_horas.setrow(ll_fila)
	tab_1.tabpage_1.dw_horas.scrolltorow(ll_fila)
	if ll_fila > 1 then
		tab_1.tabpage_1.dw_horas.selectrow(ll_fila - 1, false)
	end if
	tab_1.tabpage_1.dw_horas.selectrow(ll_fila, true)
	choose case ls_column
		case 'hora_encendido'
			tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_fila] = ldt_carga
		case 'hora_apagado'
			tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_fila] = ldt_carga
	end choose
	of_verifica_fecha(ls_column)
next
tab_1.tabpage_1.dw_horas.ii_update = 1
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3383
integer height = 516
long backcolor = 79741120
string text = "Incidencias por equipos"
long tabtextcolor = 16777215
long tabbackcolor = 8388608
string picturename = "Debug!"
long picturemaskcolor = 536870912
dw_incidencias dw_incidencias
end type

on tabpage_2.create
this.dw_incidencias=create dw_incidencias
this.Control[]={this.dw_incidencias}
end on

on tabpage_2.destroy
destroy(this.dw_incidencias)
end on

type dw_incidencias from u_dw_abc within tabpage_2
integer width = 3346
integer height = 508
integer taborder = 20
string dataobject = "d_pr_parte_piso_incidencias_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
idw_det  =  this
this.settransobject( sqlca );
end event

event getfocus;call super::getfocus;idw_1 = THIS
st_master.backcolor = rgb(0,0,100)
st_chata.backcolor = rgb(0,0,100)
st_firmas.backcolor = rgb(0,0,100)
st_comentarios.backcolor = rgb(0,0,100)
tab_1.tabpage_1.TabBackColor = rgb(0,0,100)
tab_1.tabpage_2.TabBackColor = rgb(100,0,0)
end event

event ue_insert_pre;call super::ue_insert_pre;long ll_horas
string ls_autor, ls_sql, ls_return1, ls_return2
integer li_item
datetime ldt_hora_encendido, ldt_hora_apagado

ll_horas = tab_1.tabpage_1.dw_horas.getrow()

ls_sql = "select cod_incidencia as codigo, desc_incidencia as descripcion from incidencias_dma"

f_lista (ls_sql, ls_return1, ls_return2, '2')

declare usp_incidencia procedure for
	usp_pr_parte_piso_incidencia(:is_nro_parte, :is_cod_maquina, :gs_user);

execute usp_incidencia;

fetch usp_incidencia into :ls_autor, :li_item;

close usp_incidencia;


if isnull(ls_return1) or trim(ls_return1) = '' then
	ls_return1 = ''
	ls_return2 = ''
end if

ldt_hora_encendido = tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_horas]
ldt_hora_apagado = tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_horas]

this.object.cod_incidencia[al_row] = ls_return1
this.object.desc_incidencia[al_row] = ls_return2
this.object.hora_inicio[al_row] = ldt_hora_encendido
this.object.hora_fin[al_row] = ldt_hora_apagado

this.object.autor[al_row] = ls_autor
this.object.nro_parte[al_row] = is_nro_parte
this.object.cod_maquina[al_row] = is_cod_maquina
this.object.item[al_row] = li_item

this.ii_update = 1
end event

event ue_insert;if of_horas() = 0 then
	return -1
end if
if of_firmas() >= 1 then
	return -1
end if
if this.ii_update = 1 then
	if messagebox('Error','Antes de poder inserta una nueva incidencia ~r debe grabar las modificacions que acaba de ingresar. ~r  ~r ¿Desea guardar los cambio?',Question!, YesNo!) = 1 then
		of_update()
	else
		return -1
	end if
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect()
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row)
	THIS.ScrollToRow(ll_row)
	THIS.SetColumn(1)
	THIS.SetFocus()
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset()
END IF

RETURN ll_row





end event

event doubleclicked;call super::doubleclicked;if ii_protect = 1 then return
long ll_incidencia
string ls_column, ls_sql, ls_retun1, ls_return2, ls_cod_incidencia, ls_desc_incidencia
ls_column = lower(string(dwo.name))
ll_incidencia = this.getrow()
ls_cod_incidencia = this.object.cod_incidencia[ll_incidencia]
ls_desc_incidencia = this.object.desc_incidencia[ll_incidencia]
if ls_column = 'cod_incidencia' then
	ls_sql = "select cod_incidencia as codigo, desc_incidencia as descripcion from incidencias_dma"
	f_lista(ls_sql, ls_retun1, ls_return2, '2')
	if IsNull(ls_retun1) or trim(ls_retun1) = '' then
		if trim(ls_cod_incidencia) = '' or isnull(ls_cod_incidencia) then
			ls_retun1 = ''
			ls_return2 = ''
		else
			ls_retun1 = ls_cod_incidencia
			ls_return2 = ls_desc_incidencia
		end if
	end if
	this.object.cod_incidencia[ll_incidencia] = ls_retun1
	this.object.desc_incidencia[ll_incidencia] = ls_return2
end if
end event

event itemchanged;call super::itemchanged;long ll_horas, ll_incidencias
string ls_busca, ls_column, ls_cod_incidencia, ls_desc_incidencia, ls_return1, ls_return2, ls_hora_encendido, ls_hora_apagado
datetime ldt_hora_inicio, ldt_hora_fin, ldt_hora_encendido, ldt_hora_apagado

ll_horas = tab_1.tabpage_1.dw_horas.getrow()
ll_incidencias = this.getrow()

ldt_hora_encendido = tab_1.tabpage_1.dw_horas.object.hora_encendido[ll_horas]
ldt_hora_apagado = tab_1.tabpage_1.dw_horas.object.hora_apagado[ll_horas]
ls_hora_encendido = string(ldt_hora_encendido, 'dd/mm/yyyy hh:mm')
ls_hora_apagado = string(ldt_hora_apagado, 'dd/mm/yyyy hh:mm')

ls_column = lower(string(dwo.name))

ls_cod_incidencia = this.object.cod_incidencia[ll_incidencias]
ls_desc_incidencia = this.object.desc_incidencia[ll_incidencias]

this.accepttext()

choose case ls_column 
	case 'cod_incidencia'
		ls_busca = this.object.cod_incidencia[ll_incidencias]
		declare usp_busca_inc procedure for 
			usp_tg_busca_incidencia(:ls_busca);
		execute usp_busca_inc;
		fetch usp_busca_inc into :ls_return1, :ls_return2;
		close usp_busca_inc;
		if isnull(ls_return1) or trim (ls_return1) = '' then
			if isnull(ls_cod_incidencia) or trim (ls_cod_incidencia) = '' then
				ls_return1 = ''
				ls_return2 = ''
			else
			ls_return1 = ls_cod_incidencia
			ls_return2 = ls_desc_incidencia
		end if
			messagebox('Error','Incidencia no encontrada',stopsign!)
		end if
		this.object.cod_incidencia[ll_incidencias] = ls_return1
		this.object.desc_incidencia[ll_incidencias] = ls_return2
	case 'hora_inicio'
		ldt_hora_inicio = this.object.hora_inicio[ll_incidencias]
		if ldt_hora_inicio <= ldt_hora_encendido or ldt_hora_inicio >= ldt_hora_apagado then
			messagebox('Error','El inicio de la incidencia debe estar comprendido ~r entre ' + ls_hora_encendido + ' y ' + ls_hora_apagado ,stopsign!)
			this.object.hora_inicio[ll_incidencias] = ldt_hora_encendido
		end if
	case 'hora_fin'
		ldt_hora_fin = this.object.hora_fin[ll_incidencias]
		if ldt_hora_fin <= ldt_hora_encendido or ldt_hora_fin >= ldt_hora_apagado then
			messagebox('Error','El fin de la incidencia debe estar comprendido ~r entre ' + ls_hora_encendido + ' y ' + ls_hora_apagado ,stopsign!)
			this.object.hora_fin[ll_incidencias] = ldt_hora_apagado
		end if
end choose
return 2
end event

type p_1 from picture within w_pr309_control_uso
integer x = 1952
integer y = 32
integer width = 155
integer height = 100
boolean bringtotop = true
string picturename = "H:\Source\jpg\crono.jpg"
boolean focusrectangle = false
end type

type em_nro_parte from singlelineedit within w_pr309_control_uso
event dobleclick pbm_lbuttondblclk
integer x = 2825
integer y = 44
integer width = 434
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  p.nro_parte as Nro_Parte, " & 
		  +"f.formato, f.descripcion as Descripción, " &
		  +"p.fecha_parte " &
		  + "FROM TG_FMT_MED_ACT F, TG_PARTE_PISO P " &
		  + "WHERE P.FORMATO = F.FORMATO AND p.flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	//em_descripcion.text = ls_data
end if
end event

event modified;//String 	ls_origen, ls_desc
//
//ls_origen = this.text
//if ls_origen = '' or IsNull(ls_origen) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
//	return
//end if
//
//SELECT nombre INTO :ls_desc
//FROM origen
//WHERE cod_origen =:ls_origen;
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Origen no existe')
//	return
//end if
//
////em_descripcion.text = ls_desc
//
end event

type st_1 from statictext within w_pr309_control_uso
integer x = 2226
integer y = 24
integer width = 443
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Número de Parte a mostrar"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pr309_control_uso
integer width = 1938
integer height = 136
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pr309_control_uso
integer x = 2802
integer width = 489
integer height = 136
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

