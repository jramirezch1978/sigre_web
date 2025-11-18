$PBExportHeader$w_pt319_prsp_caja.srw
forward
global type w_pt319_prsp_caja from w_abc
end type
type st_nro from statictext within w_pt319_prsp_caja
end type
type cb_1 from commandbutton within w_pt319_prsp_caja
end type
type sle_nro from u_sle_codigo within w_pt319_prsp_caja
end type
type tab_1 from tab within w_pt319_prsp_caja
end type
type tabpage_1 from userobject within tab_1
end type
type tab_2 from tab within tabpage_1
end type
type tabpage_3 from userobject within tab_2
end type
type dw_ingresos_pptt from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_2
dw_ingresos_pptt dw_ingresos_pptt
end type
type tabpage_4 from userobject within tab_2
end type
type dw_ingresos_serv from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_2
dw_ingresos_serv dw_ingresos_serv
end type
type tabpage_5 from userobject within tab_2
end type
type dw_otros_ingresos from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_2
dw_otros_ingresos dw_otros_ingresos
end type
type tab_2 from tab within tabpage_1
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type tabpage_1 from userobject within tab_1
tab_2 tab_2
end type
type tabpage_2 from userobject within tab_1
end type
type tab_3 from tab within tabpage_2
end type
type tabpage_6 from userobject within tab_3
end type
type dw_mano_obra from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_3
dw_mano_obra dw_mano_obra
end type
type tabpage_7 from userobject within tab_3
end type
type dw_materiales from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_3
dw_materiales dw_materiales
end type
type tabpage_8 from userobject within tab_3
end type
type dw_servicios from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_3
dw_servicios dw_servicios
end type
type tabpage_9 from userobject within tab_3
end type
type dw_otros_gastos from u_dw_abc within tabpage_9
end type
type tabpage_9 from userobject within tab_3
dw_otros_gastos dw_otros_gastos
end type
type tab_3 from tab within tabpage_2
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
end type
type tabpage_2 from userobject within tab_1
tab_3 tab_3
end type
type tabpage_10 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_detail dw_detail
end type
type tab_1 from tab within w_pt319_prsp_caja
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_10 tabpage_10
end type
type dw_lista from u_dw_abc within w_pt319_prsp_caja
end type
type st_1 from statictext within w_pt319_prsp_caja
end type
type dw_master from u_dw_abc within w_pt319_prsp_caja
end type
type gb_1 from groupbox within w_pt319_prsp_caja
end type
end forward

global type w_pt319_prsp_caja from w_abc
integer width = 4745
integer height = 2556
string title = "[PT319] Presupuesto de Caja"
string menuname = "m_mantenimiento_cl"
event ue_cerrar ( )
st_nro st_nro
cb_1 cb_1
sle_nro sle_nro
tab_1 tab_1
dw_lista dw_lista
st_1 st_1
dw_master dw_master
gb_1 gb_1
end type
global w_pt319_prsp_caja w_pt319_prsp_caja

type variables
u_dw_abc	idw_ingresos_pptt, idw_ingresos_serv, idw_otros_ingresos, idw_mano_obra, idw_materiales, &
			idw_servicios, idw_otros_gastos, idw_detail
//boolean	ib_log = TRUE			
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_parte)
public subroutine of_aplicar_filtro ()
public subroutine of_copiar_rows ()
public subroutine of_redraw (boolean ab_estado)
public subroutine of_groupcalc ()
end prototypes

event ue_cerrar();Long 		ll_row
decimal 	ldc_imp_ejecutado
if dw_master.getRow() = 0 then return

if dw_master.object.flag_estado [dw_master.getRow()] = '2' then
	MessageBox('Error', 'El presupuesto se encuentra CERRADO, imposible realizar la operacion, por favor verifique!')
	return
end if

if dw_master.object.flag_estado [dw_master.getRow()] = '0' then
	MessageBox('Error', 'El presupuesto se encuentra ANULADO, imposible realizar la operacion, por favor verifique!')
	return
end if

ldc_imp_ejecutado = 0
for ll_row = 1 to idw_detail.RowCount()
	ldc_imp_ejecutado += Dec(idw_detail.object.imp_ejecutado [ll_row])
next

if ldc_imp_ejecutado > 0 then
	if MessageBox('Error', 'El presupuesto de caja ha sido ya ejecuado, si lo cierra ahora no podrá utlizarlo mas adelante para otra ejecución. ¿Desea cerrarlo de todas maneras?', Information!, YesNo!, 2) = 2 then return
else
	if MessageBox('Aviso', 'Desea cerrar el presupuesto de Caja?, Tenga cuidado si cierra el presupuesto de caja, no podrá revertir este proceso!', Information!, Yesno!, 2 ) = 2 then return
end if

dw_master.object.flag_estado [dw_master.getRow()] = '2'

for ll_row = 1 to idw_detail.RowCount()
	idw_detail.object.flag_estado [ll_row] = '2'
next

dw_master.ii_update = 1
idw_detail.ii_update = 1

MessageBox('Aviso', 'Documento de presupuesto de caja ha sido cerrado, por favor grabe los cambios para que hagan efectivos.', Information!)
end event

public subroutine of_asigna_dws ();idw_ingresos_pptt = tab_1.tabpage_1.tab_2.tabpage_3.dw_ingresos_pptt

idw_ingresos_serv	= tab_1.tabpage_1.tab_2.tabpage_4.dw_ingresos_serv

idw_otros_ingresos	= tab_1.tabpage_1.tab_2.tabpage_5.dw_otros_ingresos

idw_mano_obra			= tab_1.tabpage_2.tab_3.tabpage_6.dw_mano_obra

idw_materiales			= tab_1.tabpage_2.tab_3.tabpage_7.dw_materiales

idw_servicios			= tab_1.tabpage_2.tab_3.tabpage_8.dw_servicios
	
idw_otros_gastos		= tab_1.tabpage_2.tab_3.tabpage_9.dw_otros_gastos

idw_detail				= tab_1.tabpage_10.dw_detail
end subroutine

public function integer of_set_numera (); 
//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro, ls_tabla

if is_action = 'new' then
	
	ls_tabla = dw_master.Object.Datawindow.Table.UpdateTable
	
	if ls_tabla = '' or Isnull(ls_tabla) then
		MessageBox('Error', 'No ha especificado una tabla a actualizar para el datawindows maestro, por favor verifique!')
		return 0
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_tablas 
	where origen = :gs_origen
	  and tabla	 = :ls_tabla for update;
	
	IF SQLCA.SQLCode = 100 then
		ll_ult_nro = 1
		
		Insert into num_tablas (origen, tabla, ult_nro)
			values( :gs_origen, :ls_tabla, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al insertar registro en num_tablas', ls_mensaje)
			return 0
		end if
	end if
	
	//Asigna numero a cabecera
	ls_nro = TRIM(gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_presupuesto[dw_master.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_tablas 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :gs_origen
	  and tabla	 = :ls_tabla;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar num_tablas', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_presupuesto[dw_master.getrow()] 
end if


for ll_i = 1 to idw_detail.RowCount() 
	idw_detail.object.nro_presupuesto [ll_i] = ls_nro
next


return 1
end function

public subroutine of_retrieve (string as_nro_parte);/*****************************************/
/*      Recuperacion de Información      */
/*****************************************/
of_redraw(false) 

gnvo_presup.of_actualiza_prsp_caja( )

dw_master.Retrieve(as_nro_parte)
idw_detail.Retrieve(as_nro_parte)

idw_detail.setFilter('')
idw_detail.filter( )

dw_master.ii_update = 0
idw_detail.ii_update = 0

dw_master.ResetUpdate()
idw_detail.ResetUpdate()

dw_master.ii_protect = 0
idw_detail.ii_protect = 0

dw_master.of_protect()
idw_detail.of_protect()

of_copiar_rows()
of_aplicar_filtro()

is_Action = "fileopen"

of_redraw(true)



end subroutine

public subroutine of_aplicar_filtro ();//Ingresos
idw_ingresos_pptt.setFilter( "cod_seccion='I1'"  )
idw_ingresos_pptt.Filter()
idw_ingresos_serv.setFilter( "cod_seccion='I2'"  )
idw_ingresos_serv.Filter()
idw_otros_ingresos.setFilter( "flag_flujo_caja='2'"  )
idw_otros_ingresos.Filter()

//Egresos
idw_mano_obra.setFilter( "flag_flujo_caja='3'"  )
idw_mano_obra.Filter()
idw_materiales.setFilter( "flag_flujo_caja='4'"  )
idw_materiales.Filter()
idw_servicios.setFilter( "flag_flujo_caja='5'"  )
idw_servicios.Filter()
idw_otros_gastos.setFilter( "flag_flujo_caja='6'"  )
idw_otros_gastos.Filter()

idw_ingresos_pptt.Sort()
idw_ingresos_serv.Sort()
idw_otros_ingresos.Sort()
idw_mano_obra.Sort()
idw_materiales.Sort()
idw_servicios.Sort()
idw_otros_gastos.Sort()

end subroutine

public subroutine of_copiar_rows ();//Comparto el mismo buffer del datawindow

idw_ingresos_pptt.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_ingresos_pptt, 1, Primary!)
idw_ingresos_pptt.Sort()

idw_ingresos_serv.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_ingresos_serv, 1, Primary!)
idw_ingresos_serv.Sort()

idw_otros_ingresos.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_otros_ingresos, 1, Primary!)
idw_otros_ingresos.Sort()

idw_mano_obra.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_mano_obra, 1, Primary!)
idw_mano_obra.Sort()

idw_materiales.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_materiales, 1, Primary!)
idw_materiales.Sort()

idw_servicios.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_servicios, 1, Primary!)
idw_servicios.Sort()

idw_otros_gastos.Reset()
idw_detail.RowsCopy(1, idw_detail.RowCount(), Primary!, idw_otros_gastos, 1, Primary!)
idw_otros_gastos.Sort()


end subroutine

public subroutine of_redraw (boolean ab_estado);dw_master.SetRedraw(ab_estado)
idw_ingresos_pptt.SetRedraw(ab_estado) 
idw_ingresos_serv.SetRedraw(ab_estado) 
idw_otros_ingresos.SetRedraw(ab_estado) 
idw_mano_obra.SetRedraw(ab_estado) 
idw_materiales.SetRedraw(ab_estado)
idw_servicios.SetRedraw(ab_estado) 
idw_otros_gastos.SetRedraw(ab_estado) 
idw_detail.SetRedraw(ab_estado)


end subroutine

public subroutine of_groupcalc ();dw_master.GroupCalc()
idw_ingresos_pptt.GroupCalc()
idw_ingresos_serv.GroupCalc()
idw_otros_ingresos.GroupCalc()
idw_mano_obra.GroupCalc()
idw_materiales.GroupCalc()
idw_servicios.GroupCalc()
idw_otros_gastos.GroupCalc()
idw_detail.GroupCalc()
end subroutine

on w_pt319_prsp_caja.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_nro=create st_nro
this.cb_1=create cb_1
this.sle_nro=create sle_nro
this.tab_1=create tab_1
this.dw_lista=create dw_lista
this.st_1=create st_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_lista
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
end on

on w_pt319_prsp_caja.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.cb_1)
destroy(this.sle_nro)
destroy(this.tab_1)
destroy(this.dw_lista)
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;of_asigna_dws()

dw_lista.width  = newwidth  - dw_lista.x - 10
//dw_lista.height  = dw_master.height  - dw_lista.y

st_1.width  = newwidth  - st_1.x - 10


tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height  = newheight  - tab_1.y - 10

tab_1.tabpage_1.tab_2.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.tab_2.x - 10
tab_1.tabpage_1.tab_2.height  = tab_1.tabpage_1.height  - tab_1.tabpage_1.tab_2.y - 10

tab_1.tabpage_2.tab_3.width  = tab_1.tabpage_2.width  - tab_1.tabpage_2.tab_3.x - 10
tab_1.tabpage_2.tab_3.height  = tab_1.tabpage_2.height  - tab_1.tabpage_2.tab_3.y - 10

//Redimensiono los datawindows
idw_ingresos_pptt.width = tab_1.tabpage_1.tab_2.tabpage_3.width - idw_ingresos_pptt.X - 10
idw_ingresos_pptt.height = tab_1.tabpage_1.tab_2.tabpage_3.height - idw_ingresos_pptt.Y - 10

idw_ingresos_serv.width = tab_1.tabpage_1.tab_2.tabpage_4.width - idw_ingresos_serv.X - 10
idw_ingresos_serv.height = tab_1.tabpage_1.tab_2.tabpage_4.height - idw_ingresos_serv.Y - 10

idw_otros_ingresos.width = tab_1.tabpage_1.tab_2.tabpage_5.width - idw_otros_ingresos.X - 10
idw_otros_ingresos.height = tab_1.tabpage_1.tab_2.tabpage_5.height - idw_otros_ingresos.Y - 10

idw_mano_obra.width = tab_1.tabpage_2.tab_3.tabpage_6.width - idw_mano_obra.X - 10
idw_mano_obra.height = tab_1.tabpage_2.tab_3.tabpage_6.height - idw_mano_obra.Y - 10

idw_materiales.width = tab_1.tabpage_2.tab_3.tabpage_7.width - idw_materiales.X - 10
idw_materiales.height = tab_1.tabpage_2.tab_3.tabpage_7.height - idw_materiales.Y - 10

idw_servicios.width = tab_1.tabpage_2.tab_3.tabpage_8.width - idw_servicios.X - 10
idw_servicios.height = tab_1.tabpage_2.tab_3.tabpage_8.height - idw_servicios.Y - 10

idw_otros_gastos.width = tab_1.tabpage_2.tab_3.tabpage_9.width - idw_otros_gastos.X - 10
idw_otros_gastos.height = tab_1.tabpage_2.tab_3.tabpage_9.height - idw_otros_gastos.Y - 10

idw_detail.width = tab_1.tabpage_10.width - idw_detail.X - 10
idw_detail.height = tab_1.tabpage_10.height - idw_detail.Y - 10

end event

event ue_insert;call super::ue_insert;Long  			ll_row, ll_opcion
Date				ld_fec_fin
str_parametros lstr_param

if idw_1 = dw_master then
	this.event ue_update_request( )
	ll_row = idw_1.Event ue_insert()

	IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
elseif idw_1 = dw_lista or idw_1 = idw_detail then
	
	MessageBox('Error', 'No esta permitido esta operación de insertar registros en este panel')
	return
	
else
	
	if dw_master.RowCount() = 0 then
		MessageBox('Error', 'No puede ingresar ningun detalle si no tiene cabecera en el PRESUPUESTO DE CAJA', StopSign!)
		return
	end if
	
	
	Open(w_pt319_origen_datos)
	
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.titulo = 'n' then return
	ll_opcion = lstr_param.long1
	
	choose case idw_1
		case idw_ingresos_pptt
			lstr_param.opcion = 1
			lstr_param.string1 = 'I1'
			
		case idw_ingresos_serv
			lstr_param.opcion = 2
			lstr_param.string1 = 'I2'

		case idw_otros_ingresos
			lstr_param.opcion = 3
			lstr_param.string1 = '2'

		case idw_mano_obra
			lstr_param.opcion = 4
			lstr_param.string1 = '3'

		case idw_materiales
			lstr_param.opcion = 5
			lstr_param.string1 = '4'

		case idw_servicios
			lstr_param.opcion = 6
			lstr_param.string1 = '5'

		case idw_otros_gastos
			lstr_param.opcion = 7
			lstr_param.string1 = '6'

	end choose
	
	lstr_param.dw_m 	= dw_master
	lstr_param.dw_d 	= idw_detail
	lstr_param.date1 	= Date(dw_master.object.fec_fin[1])
	lstr_param.accion = 'new'
	
	
	if ll_opcion = 2 then
		OpenWithParm(w_pt319_add_edit_record, lstr_param)
	else
		OpenWithParm(w_pt319_add_edit_docs, lstr_param)
	end if
	
	lstr_param = message.PowerObjectparm
	if lstr_param.titulo = 's' then
		of_redraw(false)
		of_copiar_rows()
		of_aplicar_filtro()
		//of_groupCalc()
		of_redraw(true)
	end if
	
end if


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_lista.SetTransObject(sqlca)


idw_detail.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_ingresos_pptt.SetTransObject(sqlca) 
idw_ingresos_serv.SetTransObject(sqlca) 
idw_otros_ingresos.SetTransObject(sqlca) 
idw_mano_obra.SetTransObject(sqlca) 
idw_materiales.SetTransObject(sqlca)
idw_servicios.SetTransObject(sqlca) 
idw_otros_gastos.SetTransObject(sqlca)

of_aplicar_filtro()

//Recupero los datos
dw_lista.Retrieve()


idw_1 = dw_master              				// asignar dw corriente
dw_master.setFocus()


end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if gnvo_app.of_row_Processing( dw_master ) <> true then return

if gnvo_app.of_row_Processing( idw_detail ) <> true then return

if idw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta indicar detalle")
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return		

dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()

ib_update_check = True
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
idw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detail.of_create_log()
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
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	
	if dw_master.RowCount() > 0 then
		of_retrieve(dw_master.object.nro_presupuesto[dw_master.getRow()])
	end if
	dw_lista.Retrieve()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Hay actualizaciones pendientes de grabación. Desea Grabar?", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	END IF
END IF

end event

event ue_modify;call super::ue_modify;str_parametros lstr_param

if this.is_flag_modificar = '0' then
	MessageBox('Error', 'No esta permitido o autorizado para hacer modificaciones, por favor verifique!', StopSign!)
	return
end if

IF idw_1 = dw_master then
	
	dw_master.of_protect()
	
elseif idw_1 = idw_ingresos_pptt or &
		 idw_1 = idw_ingresos_serv or &
		 idw_1 = idw_otros_ingresos or &
		 idw_1 = idw_materiales or &
		 idw_1 = idw_mano_obra or &
		 idw_1 = idw_servicios or &
		 idw_1 = idw_otros_gastos then
		 
	lstr_param.dw_m = dw_master
	lstr_param.dw_d = idw_detail
	lstr_param.accion = 'edit'
	lstr_param.long1	= Long(idw_1.object.nro_item [idw_1.getRow()])
	
	OpenWithParm(w_pt319_add_edit_record, lstr_param)
	
	lstr_param = message.PowerObjectparm
	if lstr_param.titulo = 's' then
		of_redraw(false)
		of_copiar_rows()
		of_aplicar_filtro()
		//of_groupCalc()
		of_redraw(true)
	end if
end if

end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

THIS.event ue_update_request( )

sl_param.dw1    = 'd_lista_prsp_caja_tbl'
sl_param.titulo = 'Presupuestos de Caja'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_delete;//Override
Long  ll_nro_item, ll_find, ll_row

IF idw_1 = dw_master THEN
	MessageBox("Aviso", "No esta permitido eliminar la cabecera de un documento si ya ha sido grabado", Information!)
	RETURN
END IF

if idw_1 = dw_lista or idw_1 = idw_detail then
	MessageBox("Aviso", "Esta operacion no esta permitido en estos paneles, por favor verifique!", Information!)
	RETURN
end if

ll_row = idw_1.getRow()

//Obtengo el nro_item
ll_nro_item = Long(idw_1.object.nro_item [ll_row])

//Busco el item el idw_detail
ll_find = idw_detail.Find("nro_item=" + string(ll_nro_item), 1, idw_detail.RowCount())

if ll_find > 0 then
	if MessageBox('Aviso', 'Desea eliminar el item ' + string(ll_nro_item) + "?", Information!, Yesno!, 2) = 2 then return
	
	idw_detail.deleterow( ll_find )
	idw_detail.ii_update = 1
	
//	idw_1.event ue_delete( )
	
	of_redraw(false)
	of_copiar_rows()
	of_aplicar_filtro()
	of_redraw(true)
end if


end event

event ue_print;call super::ue_print;// vista previa de mov. almacen
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_rpt_prsp_caja_tbl'
lstr_rep.titulo 	= 'Previo de Presupuesto de Caja'
lstr_rep.string1 	= dw_master.object.nro_presupuesto	[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

event ue_anular;call super::ue_anular;Long 		ll_row
decimal 	ldc_imp_ejecutado
String	ls_nro_prsp

if dw_master.getRow() = 0 then return

if dw_master.object.flag_estado [dw_master.getRow()] = '2' then
	MessageBox('Error', 'El presupuesto se encuentra CERRADO, imposible realizar la operacion, por favor verifique!')
	return
end if

if dw_master.object.flag_estado [dw_master.getRow()] = '0' then
	MessageBox('Error', 'El presupuesto se encuentra ANULADO, imposible realizar la operacion, por favor verifique!')
	return
end if

if dw_master.ii_update = 1 or idw_detail.ii_update = 1 then
	MessageBox('Error', 'Existen operaciones pendientes de grabación, por lo que no es posible anular el presupuesto hasta que hayan sido grabados')
	return
end if

//Verifico si hay importe ejecutado en el presupuesto de caja
ls_nro_prsp = dw_master.object.nro_presupuesto [dw_master.GetRow()]

select NVL(imp_ejecutado, 0)
	into :ldc_imp_ejecutado
from prsp_caja_det a
where a.nro_presupuesto = :ls_nro_prsp;
/*
ldc_imp_ejecutado = 0
for ll_row = 1 to idw_detail.RowCount()
	ldc_imp_ejecutado += Dec(idw_detail.object.imp_ejecutado [ll_row])
next
*/

if ldc_imp_ejecutado > 0 then
	MessageBox('Error', 'El presupuesto de caja ha sido ejecutado, no es posible anularlo, si no desea que se siga ejecutando, entonces cierre el presupuesto', Information!)
	return
end if

if MessageBox('Aviso', 'Desea anular todo el presupuesto de Caja?, Tenga cuidado si anula todo el presupuesto de ingreso, no podrá revertir este proceso!', Information!, Yesno!, 2 ) = 2 then return

dw_master.object.flag_estado [dw_master.getRow()] = '0'

for ll_row = 1 to idw_detail.RowCount()
	idw_detail.object.flag_estado [ll_row] = '0'
next

dw_master.ii_update = 1
idw_detail.ii_update = 1

MessageBox('Aviso', 'Documento de presupuesto de caja ha sido anulado, por favor grabe los cambios para que hagan efectivos.', Information!)
end event

event ue_open_pos;call super::ue_open_pos;dw_master.SetFocus()
end event

type st_nro from statictext within w_pt319_prsp_caja
integer x = 46
integer y = 56
integer width = 279
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pt319_prsp_caja
integer x = 901
integer y = 40
integer width = 402
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type sle_nro from u_sle_codigo within w_pt319_prsp_caja
integer x = 352
integer y = 44
integer width = 539
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.event clicked()
end event

type tab_1 from tab within w_pt319_prsp_caja
integer y = 888
integer width = 3410
integer height = 1176
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_10 tabpage_10
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_10=create tabpage_10
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_10}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_10)
end on

event selectionchanged;if newindex = 3 then
	idw_detail.SetFocus()
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3374
integer height = 1048
long backcolor = 79741120
string text = "Ingresos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
tab_2 tab_2
end type

on tabpage_1.create
this.tab_2=create tab_2
this.Control[]={this.tab_2}
end on

on tabpage_1.destroy
destroy(this.tab_2)
end on

type tab_2 from tab within tabpage_1
integer x = 5
integer width = 3259
integer height = 1216
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_2.create
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_2.destroy
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_3 from userobject within tab_2
integer x = 18
integer y = 112
integer width = 3223
integer height = 1088
long backcolor = 79741120
string text = "Ingreso por PPTT"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ingresos_pptt dw_ingresos_pptt
end type

on tabpage_3.create
this.dw_ingresos_pptt=create dw_ingresos_pptt
this.Control[]={this.dw_ingresos_pptt}
end on

on tabpage_3.destroy
destroy(this.dw_ingresos_pptt)
end on

type dw_ingresos_pptt from u_dw_abc within tabpage_3
integer width = 3195
integer height = 892
integer taborder = 20
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_4 from userobject within tab_2
integer x = 18
integer y = 112
integer width = 3223
integer height = 1088
long backcolor = 79741120
string text = "Ingreso por Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ingresos_serv dw_ingresos_serv
end type

on tabpage_4.create
this.dw_ingresos_serv=create dw_ingresos_serv
this.Control[]={this.dw_ingresos_serv}
end on

on tabpage_4.destroy
destroy(this.dw_ingresos_serv)
end on

type dw_ingresos_serv from u_dw_abc within tabpage_4
integer x = 5
integer y = 4
integer width = 1669
integer height = 764
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)

end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_5 from userobject within tab_2
integer x = 18
integer y = 112
integer width = 3223
integer height = 1088
long backcolor = 79741120
string text = "Otros Ingresos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_otros_ingresos dw_otros_ingresos
end type

on tabpage_5.create
this.dw_otros_ingresos=create dw_otros_ingresos
this.Control[]={this.dw_otros_ingresos}
end on

on tabpage_5.destroy
destroy(this.dw_otros_ingresos)
end on

type dw_otros_ingresos from u_dw_abc within tabpage_5
integer width = 1669
integer height = 764
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3374
integer height = 1048
long backcolor = 79741120
string text = "Egresos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
tab_3 tab_3
end type

on tabpage_2.create
this.tab_3=create tab_3
this.Control[]={this.tab_3}
end on

on tabpage_2.destroy
destroy(this.tab_3)
end on

type tab_3 from tab within tabpage_2
integer width = 2240
integer height = 1008
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
end type

on tab_3.create
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.Control[]={this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8,&
this.tabpage_9}
end on

on tab_3.destroy
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
end on

event selectionchanged;if newindex = 1 then
	idw_mano_obra.SetFocus( )
elseif newindex = 2 then
	idw_materiales.SetFocus()
elseif newindex = 3 then
	idw_servicios.SetFocus()
elseif newindex = 4 then
	idw_otros_gastos.SetFocus()
end if
	
end event

type tabpage_6 from userobject within tab_3
integer x = 18
integer y = 112
integer width = 2203
integer height = 880
long backcolor = 79741120
string text = "Mano de Obra"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_mano_obra dw_mano_obra
end type

on tabpage_6.create
this.dw_mano_obra=create dw_mano_obra
this.Control[]={this.dw_mano_obra}
end on

on tabpage_6.destroy
destroy(this.dw_mano_obra)
end on

type dw_mano_obra from u_dw_abc within tabpage_6
integer width = 1669
integer height = 764
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_7 from userobject within tab_3
integer x = 18
integer y = 112
integer width = 2203
integer height = 880
long backcolor = 79741120
string text = "Materiales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_materiales dw_materiales
end type

on tabpage_7.create
this.dw_materiales=create dw_materiales
this.Control[]={this.dw_materiales}
end on

on tabpage_7.destroy
destroy(this.dw_materiales)
end on

type dw_materiales from u_dw_abc within tabpage_7
integer width = 1669
integer height = 764
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_8 from userobject within tab_3
integer x = 18
integer y = 112
integer width = 2203
integer height = 880
long backcolor = 79741120
string text = "Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_servicios dw_servicios
end type

on tabpage_8.create
this.dw_servicios=create dw_servicios
this.Control[]={this.dw_servicios}
end on

on tabpage_8.destroy
destroy(this.dw_servicios)
end on

type dw_servicios from u_dw_abc within tabpage_8
integer width = 1669
integer height = 764
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_9 from userobject within tab_3
integer x = 18
integer y = 112
integer width = 2203
integer height = 880
long backcolor = 79741120
string text = "Otros Gastos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_otros_gastos dw_otros_gastos
end type

on tabpage_9.create
this.dw_otros_gastos=create dw_otros_gastos
this.Control[]={this.dw_otros_gastos}
end on

on tabpage_9.destroy
destroy(this.dw_otros_gastos)
end on

type dw_otros_gastos from u_dw_abc within tabpage_9
integer width = 1669
integer height = 764
string dataobject = "d_list_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;event ue_modify()
end event

type tabpage_10 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3374
integer height = 1048
long backcolor = 79741120
string text = "Vista Completa"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_10.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_10.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_10
integer width = 2889
integer height = 908
integer taborder = 50
string dataobject = "d_abc_prsp_caja_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr			[al_Row] = gs_user
this.object.fec_registro	[al_Row] = gnvo_app.of_fecha_actual()
this.object.imp_proyectado	[al_Row] = 0.00
this.object.imp_ejecutado	[al_Row] = 0.00
this.object.flag_estado		[al_Row] = '1'

this.object.nro_item			[al_row] = of_nro_item()

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;String ls_columna

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

str_parametros lstr_rep
w_rpt_preview lw_1

choose case lower(as_columna)
	case "imp_ejecutado"
		lstr_rep.dw1 	  = 'd_rpt_detalle_prsp_caja_tbl'
		lstr_rep.titulo  = 'Detalle de Ejecución de Caja'
		lstr_rep.string1 = this.object.nro_presupuesto	[al_row]
		lstr_rep.long1   = this.object.nro_item	  		[al_row]
		lstr_rep.tipo	  = '1S1L'	
		lstr_rep.orientacion	= '1'
		
		OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)		
		return

end choose
end event

type dw_lista from u_dw_abc within w_pt319_prsp_caja
integer x = 2875
integer y = 84
integer width = 1833
integer height = 796
integer taborder = 20
string dataobject = "d_lista_prsp_caja_activos_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'	// tabular, form (default)
end event

event buttonclicked;call super::buttonclicked;str_parametros 	lstr_param
string				ls_nro_prsp, ls_nro_prsp_dst, ls_descripcion, ls_tabla, ls_mensaje
Long					ll_year, ll_semana
date					ld_fecha1, ld_Fecha2

if row = 0 then return

if lower(dwo.name) = 'b_copiar' then
	ls_nro_prsp = this.object.nro_presupuesto [row]
	ll_year		= Long(this.object.ano 		[row])
	ll_semana	= Long(this.object.semana 	[row])
	
	if MessageBox('Aviso', 'Desea Duplicar el presupuesto ' + ls_nro_prsp &
							   + ' de la semana ' + string(ll_year) + '-' &
								+ string(ll_semana, '00') + ' ?.', Information!, YesNo!, 2) = 2 then return
	
	Open(w_pt319_copiar)
	lstr_param = Message.PowerObjectparm
	
	if lstr_param.titulo = 'n' then return
	
	ll_year 			= lstr_param.long1
	ll_semana 		= lstr_param.long2
	ls_descripcion = lstr_param.string1
	ld_fecha1		= lstr_param.date1
	ld_fecha2		= lstr_param.date2
	
	//Obtengo el nombre de la tabla necesaria para actualizarla
	ls_tabla = dw_master.Object.Datawindow.Table.UpdateTable
	
//	create or replace procedure usp_prsp_duplicar_prsp_caja(
//			 asi_origen           in origen.cod_origen%TYPE,
//			 asi_nro_prsp         in prsp_caja.nro_presupuesto%TYPE,
//			 ani_year             in prsp_caja.ano%TYPE,
//			 ani_semana           in prsp_caja.semana%TYPE,
//			 adi_fecha1           in prsp_caja.fec_inicio%TYPE,
//			 adi_fecha2           in prsp_caja.fec_fin%TYPE,
//			 asi_descripcion      in prsp_caja.descripcion%TYPE,
//			 asi_usuario          in prsp_caja.cod_usr%TYPE,
//			 asi_tabla            in varchar2,
//			 aso_nro_prsp         out prsp_caja.nro_presupuesto%TYPE
//	) is
	
	DECLARE usp_prsp_duplicar_prsp_caja PROCEDURE FOR
		usp_prsp_duplicar_prsp_caja( :gs_origen,
											  :ls_nro_prsp,
											  :ll_year,
											  :ll_semana,
											  :ld_fecha1,
											  :ld_fecha2,
											  :ls_descripcion,
											  :gs_user,
											  :ls_tabla );
	
	EXECUTE usp_prsp_duplicar_prsp_caja;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE usp_prsp_duplicar_prsp_caja: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return 
	END IF
	
	fetch usp_prsp_duplicar_prsp_caja into :ls_nro_prsp_dst;
	
	CLOSE usp_prsp_duplicar_prsp_caja;
	
	dw_lista.Retrieve()
	
	if MessageBox('Aviso', 'Presupuesto de Caja Creado satisfactoriamente, el numero de presupuesto creado es ' + ls_nro_prsp_dst + '.~r~n'&
					 + '¿Desea aabrirlo para editarlo ?.', Information!, YesNo!, 2) = 2 then return
	
	of_retrieve(ls_nro_prsp_dst)
end if
end event

event ue_display;call super::ue_display;String ls_nro_prsp

choose case lower(as_columna)
	case "nro_presupuesto"

		ls_nro_prsp = this.object.nro_presupuesto [al_row]
		
		if MessageBox('Aviso', '¿Desea abrir el presupuesto de caja ' + ls_nro_prsp + '?', Information!, Yesno!, 2) = 2 then return
		
		of_retrieve(ls_nro_prsp)
		
end choose
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

type st_1 from statictext within w_pt319_prsp_caja
integer x = 2875
integer width = 1984
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Ultimos presupuestos"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_pt319_prsp_caja
integer y = 156
integer width = 2862
integer height = 720
string dataobject = "d_abc_prsp_caja_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_now
Integer	li_year, li_Semana
Date		ld_fecha1, ld_fecha2

try 
	ldt_now = gnvo_app.of_fecha_actual()
	
	this.object.fec_registro 	[al_row] = ldt_now
	this.object.flag_estado		[al_row] = '1'
	this.object.cod_usr			[al_row] = gs_user
	
	//Obtengo el año y la semana
	li_year = year(Date(ldt_now))
	this.object.ano				[al_row] = li_year
	this.object.tasa_cambio		[al_row] = gnvo_app.finparam.of_get_tipo_cambio( date(ldt_now) )
	
	
	li_Semana = gnvo_app.of_get_semana(Date(ldt_now))
	
	if li_Semana > 0 then
		gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
		
		this.object.semana			[al_row] = li_semana
		this.object.fec_inicio		[al_row] = ld_fecha1
		this.object.fec_fin			[al_row] = ld_fecha2
	end if
	
	is_action = "new"
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception, ' + ex.getMessage() + ', por favor verifique')

end try
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Integer 	li_year, li_Semana
date		ld_fecha1, ld_fecha2

try 
	this.Accepttext()
	
	CHOOSE CASE dwo.name
		CASE 'semana', 'ano'
			
			// Verifica que codigo ingresado exista			
			li_year 		= Int(this.object.ano 	 [row])
			li_semana 	= Int(this.object.semana [row])
			
			gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
		
			this.object.fec_inicio		[row] = ld_fecha1
			this.object.fec_fin			[row] = ld_fecha2
	END CHOOSE
	
catch ( Exception ex )
	f_mensaje("Ha ocurrido una excepción: " + ex.getMessage() + ", por favor verifique!", "")
	
end try
end event

event buttonclicked;call super::buttonclicked;Long ll_Row
if row = 0 then return

if lower(dwo.name) = 'b_clear' then
	//Boton para limpiar datos
	if MessageBox('Aviso', 'Esta opción eliminará todos los importes proyectados del presupuesto de caja. ¿Desea continuar?', Information!, Yesno!, 2) = 2 then return
	
	for ll_row = 1 to idw_detail.RowCount()
		idw_detail.object.imp_proyectado [ll_row] = 0
		idw_Detail.ii_update = 1
	next
	
	f_mensaje("Proceso de Limpieza del presupuesto de Caja ha sido realizado satisfactoriamente. Por favor grabe los cambios para hacerlos efectivo", "")
end if


end event

type gb_1 from groupbox within w_pt319_prsp_caja
integer width = 2857
integer height = 148
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

