$PBExportHeader$w_cam306_parte_consumo.srw
forward
global type w_cam306_parte_consumo from w_abc_mastdet_smpl
end type
type dw_listado from u_dw_abc within w_cam306_parte_consumo
end type
type dw_asignados from u_dw_abc within w_cam306_parte_consumo
end type
type st_1 from statictext within w_cam306_parte_consumo
end type
type st_2 from statictext within w_cam306_parte_consumo
end type
end forward

global type w_cam306_parte_consumo from w_abc_mastdet_smpl
integer width = 4878
integer height = 2312
string title = "[CM306] Parte Consumo Campo"
string menuname = "m_abc_anular_lista"
dw_listado dw_listado
dw_asignados dw_asignados
st_1 st_1
st_2 st_2
end type
global w_cam306_parte_consumo w_cam306_parte_consumo

type variables
String	is_soles, is_salir, is_plantilla
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_set_base (long al_row, string as_productor)
public subroutine of_retrieve (string as_nro)
public function integer of_get_param ()
public function boolean of_set_datos_ot (long al_row)
public function boolean of_check_save_oper ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j, ll_count
string	ls_mensaje, ls_nro

if is_action = 'new' then

	Select count(*) 
		into :ll_count
	from  num_cam_pd_consumo
	where cod_origen = :gs_origen;
	
	IF ll_count = 0 then
		Insert into num_cam_pd_consumo (cod_origen, ult_nro)
			values( :gs_origen, 1);
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from  num_cam_pd_consumo
	where cod_origen = :gs_origen for update;
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_parte[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update num_cam_pd_consumo 
		set ult_nro = :ll_ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_parte[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()	
	dw_detail.object.nro_parte[ll_j] = ls_nro	
next

// Asigna numero a detalle
for ll_j = 1 to dw_asignados.RowCount()	
	dw_asignados.object.nro_parte[ll_j] = ls_nro	
next
return 1
end function

public subroutine of_set_base (long al_row, string as_productor);string	ls_base, ls_Desc_base

select distinct ab.cod_base, ab.desc_base
	into :ls_base, :ls_desc_base
from ap_bases ab,
     ap_proveedor_certif apc
where ab.cod_base = apc.cod_base  
  and apc.proveedor = :as_productor;

dw_master.object.cod_base [al_row] = ls_base
dw_master.object.desc_base [al_row] = ls_desc_base
end subroutine

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro)
	
	if dw_detail.RowCount() > 0 then
		dw_detail.il_row = 1
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(dw_detail.il_Row, true)
		dw_detail.SetRow(1)
	end if
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.ii_update	= 0
	dw_detail.of_protect()
	dw_detail.ResetUpdate()
	
	dw_asignados.Retrieve(as_nro)
	
	if dw_master.getRow() > 0 then
		dw_listado.Retrieve(dw_master.object.cod_labor [dw_master.getRow()])
	end if
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public function integer of_get_param ();String ls_mensaje

// busca tipos de movimiento definidos
SELECT 	cod_soles
	INTO 	:is_soles
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en Logparam")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

// busca doc. prog. compras
if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
	Messagebox("Error", "Defina Moneda Soles en logparam")
	return 0
end if


return 1

end function

public function boolean of_set_datos_ot (long al_row);String 	ls_ot_adm, ls_desc_ot_adm, ls_nro_ot, &
			ls_titulo_ot, ls_null, ls_empacadora, &
			ls_labor

SetNull(ls_null)

ls_labor 		= dw_master.object.cod_labor 			[al_row]
ls_empacadora 	= dw_master.object.cod_empacadora 	[al_row]

select ot.ot_adm, ota.descripcion, ot.nro_orden, ot.titulo
	into :ls_ot_adm, :ls_desc_ot_adm, :ls_nro_ot, :ls_titulo_ot
from labor l,
     ap_empacadora_ot aot,
     operaciones      op,
	  orden_trabajo	 ot,
	  ot_administracion ota
where op.cod_labor = l.cod_labor
  and aot.nro_orden = op.nro_orden
  and op.nro_orden  = ot.nro_orden
  and ot.ot_adm	  = ota.ot_adm
  and aot.cod_empacadora = :ls_empacadora
  and op.cod_labor		 = :ls_labor
  and op.flag_estado		 = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'No existe una operacion aprobada para la labor ' + trim(ls_labor) &
							+ ' asignada a la empacadora ' + trim(ls_empacadora) + ', por favor verifique')
							
	dw_master.object.ot_adm				[al_row] = ls_null
	dw_master.object.desc_ot_adm		[al_row] = ls_null
	dw_master.object.nro_orden			[al_row] = ls_null
	dw_master.object.titulo_ot			[al_row] = ls_null
	return false
end if
  
dw_master.object.ot_adm				[al_row] = ls_ot_adm
dw_master.object.desc_ot_adm		[al_row] = ls_desc_ot_adm
dw_master.object.nro_orden			[al_row] = ls_nro_ot
dw_master.object.titulo_ot			[al_row] = ls_titulo_ot

return true
end function

public function boolean of_check_save_oper ();/*Funcion de ventana de verificación de acciones en las operaciones */
Boolean lb_retorno

IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 THEN
	lb_retorno = TRUE			// si existe modificaciones en las operaciones
ELSE 
	lb_retorno = FALSE		// si no hay modificaciones en las operaciones
END IF

Return lb_retorno
end function

on w_cam306_parte_consumo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.dw_listado=create dw_listado
this.dw_asignados=create dw_asignados
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_listado
this.Control[iCurrent+2]=this.dw_asignados
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
end on

on w_cam306_parte_consumo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_listado)
destroy(this.dw_asignados)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0 
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, dw_detail.is_dwform) <> true then	return

/*if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if
*/

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_cam_parte_consumo_tbl'
sl_param.titulo = 'Partes de Consumo de Campo'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_asignados.of_create_log()
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

IF dw_asignados.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_asignados.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion dw_asignados", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = dw_asignados.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_asignados.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_asignados.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_asignados.ResetUpdate()
	
	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_parte[dw_master.getRow()])
	end if
	
END IF

end event

event ue_anular;call super::ue_anular;String	ls_estado
Long		ll_i

if dw_master.getRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.getRow()] 

if ls_estado <> '1' then
	MessageBox('Error', 'No se puede anular el documento porque no esta ACTIVO, por favor verifique')
	return
end if

IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

if MessageBox('Aviso', 'Desea anular el documento?', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado [dw_master.getRow()] = '0'
dw_master.ii_update = 1

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[ll_i] = '0'
	dw_detail.ii_update = 1
next
end event

event ue_print;call super::ue_print;// vista previa de mov. almacen
sg_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_frm_credito'
lstr_rep.titulo 	= 'Previo de Crédito'
lstr_rep.string1 	= dw_master.object.nro_credito[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_cam304_creditos_frm, lstr_rep, w_main, 0, Layered!)
end event

event resize;//Override
dw_asignados.width  = newwidth  - dw_asignados.x - 10
st_2.width = dw_asignados.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_delete;//Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

if idw_1 = dw_asignados then
	MessageBox('Error', 'Este panel no admite esta operación, por favor verifique')
	return
end if

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cam306_parte_consumo
integer x = 0
integer y = 0
integer width = 2592
integer height = 1160
string dataobject = "d_abc_cam_pd_consumo_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro			[al_row] = f_fecha_actual()
this.object.cod_usr					[al_row] = gs_user
this.object.flag_estado				[al_row] = '1'

this.object.fec_parte 				[al_row] = Date(f_fecha_Actual())
this.object.cod_origen				[al_row] = gs_origen
		
// Verifica que codigo ingresado exista			
Date ld_FechaActual, ld_FechaInicio 
Long ll_Semana 
ld_FechaActual = Date(this.object.fec_parte [al_row])
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.semana[al_row] = ll_Semana
this.object.ano	[al_row] = year(ld_FechaActual)
		
this.setColumn('cod_empacadora')

is_Action = 'new'

end event

event dw_master::constructor;call super::constructor; is_dwform = 'form' // tabular form
 
ii_ck[1] = 4			// columnas de lectrua de este dw
ii_dk[1] = 4 	      // columnas que se pasan al detalle

end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_codtra, ls_nom_trabajador, &
			ls_empacadora, ls_labor, ls_null, ls_ot_adm

SetNull(ls_null)

choose case lower(as_columna)
		
	case "cod_empacadora"

		ls_sql = "SELECT cod_empacadora AS codigo_empacadora, " &
				  + "desc_empacadora AS descripcion_empacadora " &
				  + "FROM ap_empacadora p " &
				  + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_empacadora		[al_row] = ls_codigo
			this.object.desc_empacadora	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_cuadrilla"

		ls_sql = "select ac.cod_cuadrilla as codigo_cuadrilla, " &
				 + "ac.desc_cuadrilla as descripcion_cuadrilla, " &
				 + "ac.jefe_cuadrilla as jefe_cuadrilla, " &
				 + "m.NOM_TRABAJADOR as nombre_trabajador " &
				 + "from ap_cuadrilla ac, " &
				 + "     vw_pr_trabajador m " &
				 + "where ac.jefe_cuadrilla = m.COD_TRABAJADOR (+) " &
				 + "  and ac.flag_estado = '1'"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_codtra, ls_nom_trabajador, '2')
		
		if ls_codigo <> '' then
			this.object.cod_cuadrilla	[al_row] = ls_codigo
			this.object.desc_cuadrilla	[al_row] = ls_data
			this.object.jefe_cuadrilla	[al_row] = ls_codtra
			this.object.nom_trabajador	[al_row] = ls_nom_trabajador
			this.ii_update = 1
		end if

	case "jefe_cuadrilla"

		ls_sql = "SELECT m.cod_trabajador AS codigo_trabajador, " &
				  + "m.nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador m " &
				  + "where m.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.jefe_cuadrilla		[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_labor"
		
		if dw_detail.RowCount() > 0 then
			MessageBox('Error', 'No puede cambiar la labor si el parte de consumo ya tiene detalle')
			return
		end if
		
		ls_empacadora = this.object.cod_empacadora [al_row]
		
		if ls_empacadora = '' or IsNull(ls_empacadora) then
			MessageBox('Error', 'Debe indicar primero una empacadora')
			this.setColumn('cod_empacadora')
			return
		end if
		
		ls_sql = "select distinct l.cod_labor as codigo_labor, " &
				 + "l.desc_labor as descripcion_labor " &
				 + "from labor l, " &
				 + "     ap_empacadora_ot aot, " &
			    + "     operaciones      op " &
				 + "where op.cod_labor = l.cod_labor " &
				 + "  and aot.nro_orden = op.nro_orden " &
				 + "  and op.flag_estado = '1' " &
				 + "  and aot.cod_empacadora = '" + ls_empacadora + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor		[al_row] = ls_codigo
			this.object.desc_labor		[al_row] = ls_data
			of_set_datos_ot(al_row)
			dw_listado.Retrieve(ls_codigo)
			this.ii_update = 1
		end if

	case "ot_adm"
		
		ls_empacadora = this.object.cod_empacadora [al_row]
		
		if ls_empacadora = '' or IsNull(ls_empacadora) then
			MessageBox('Error', 'Debe indicar primero una empacadora')
			this.setColumn('cod_empacadora')
			return
		end if

		ls_labor = this.object.cod_labor [al_row]
		
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Error', 'Debe indicar primero una Labor')
			this.setColumn('cod_labor')
			return
		end if		
		
		ls_sql = "select distinct ota.ot_adm as ot_adm, " &
				 + "ota.descripcion as ota.descripcion_ot_adm " &
				 + "from labor l, " &
				 + "     ap_empacadora_ot aot, " &
			    + "     operaciones      op, " &
				 + "     ot_administracion ota, " &
				 + "     orden_trabajo 		ot " &
				 + "where op.cod_labor = l.cod_labor " &
				 + "  and aot.nro_orden = op.nro_orden " &
				 + "  and op.nro_orden  = ot.nro_orden " &
				 + "  and ot.ot_adm     = ota.ot_adm " &
				 + "  and op.flag_estado = '1' " &
				 + "  and aot.cod_empacadora = '" + ls_empacadora + "' " &
				 + "  and op.cod_labor       = '" + ls_labor + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm			[al_row] = ls_codigo
			this.object.desc_ot_adm		[al_row] = ls_data
			
			this.object.nro_orden		[al_row] = ls_null
			this.object.titulo_ot		[al_row] = ls_null
			this.ii_update = 1
		end if

	case "nro_orden"
		
		ls_empacadora = this.object.cod_empacadora [al_row]
		
		if ls_empacadora = '' or IsNull(ls_empacadora) then
			MessageBox('Error', 'Debe indicar primero una empacadora')
			this.setColumn('cod_empacadora')
			return
		end if

		ls_labor = this.object.cod_labor [al_row]
		
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Error', 'Debe indicar primero una Labor')
			this.setColumn('cod_labor')
			return
		end if		

		ls_ot_adm = this.object.ot_adm [al_row]
		
		if ls_ot_adm = '' or IsNull(ls_ot_adm) then
			MessageBox('Error', 'Debe indicar primero un OT_ADM')
			this.setColumn('ot_adm')
			return
		end if			
		
		ls_sql = "select distinct ot.nro_orden as numero_ot, " &
				 + "ot.titulo as titulo_ot " &
				 + "from labor l, " &
				 + "     ap_empacadora_ot aot, " &
			    + "     operaciones      op, " &
				 + "     ot_administracion ota, " &
				 + "     orden_trabajo 		ot " &
				 + "where op.cod_labor = l.cod_labor " &
				 + "  and aot.nro_orden = op.nro_orden " &
				 + "  and op.nro_orden  = ot.nro_orden " &
				 + "  and ot.ot_adm     = ota.ot_adm " &
				 + "  and op.flag_estado = '1' " &
				 + "  and aot.cod_empacadora = '" + ls_empacadora + "' " &
				 + "  and op.cod_labor       = '" + ls_labor + "' " &
				 + "  and ot.ot_adm          = '" + ls_ot_adm + "' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nro_orden		[al_row] = ls_codigo
			this.object.titulo_ot		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "almacen"

		ls_sql = "SELECT almacen AS codigo_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen a " &
				  + "where a.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc, ls_desc2, ls_empacadora
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'fec_parte'
		
		// Verifica que codigo ingresado exista			
		Date ld_FechaActual, ld_FechaInicio 
		Long ll_Semana 
		ld_FechaActual = Date(this.object.fec_parte [row])
		ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
		ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1
		
		this.object.semana[row] = ll_Semana
		this.object.ano	[row] = year(ld_FechaActual)
		
	CASE 'cod_empacadora'
		
		// Verifica que codigo ingresado exista			
		Select desc_empacadora
	     into :ls_desc
		  from ap_empacadora
		 Where cod_empacadora = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Empacadora o no se encuentra activo, por favor verifique")
			this.object.cod_empacadora		[row] = ls_null
			this.object.desc_empacadora	[row] = ls_null
			return 1
		end if

		this.object.nom_proveedor		[row] = ls_desc
		this.object.ruc					[row] = ls_desc2

	case "cod_labor"
		
		if dw_detail.RowCount() > 0 then
			MessageBox('Error', 'No puede cambiar la labor si el parte de consumo ya tiene detalle')
			return
		end if


		ls_empacadora = this.object.cod_empacadora [row]
		
		if ls_empacadora = '' or IsNull(ls_empacadora) then
			MessageBox('Error', 'Debe indicar primero una empacadora')
			this.setColumn('cod_empacadora')
			return
		end if
		
		select l.desc_labor 
			into :ls_desc
		from 	labor l,
     			ap_empacadora_ot aot, 
				operaciones      op 
		where op.cod_labor = l.cod_labor 
		  and aot.nro_orden = op.nro_orden 
		  and op.flag_estado = '1' 
		  and aot.cod_empacadora = :ls_empacadora
		  and l.cod_labor			 = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Codigo de Labor, no corresponde a ninguna operacion aprobada o no se encuentra activo, por favor verifique")
			this.object.cod_labor		[row] = ls_null
			this.object.desc_labor		[row] = ls_null
			this.object.nro_orden		[row] = ls_null
			this.object.titulo_ot		[row] = ls_null
			this.object.ot_adm			[row] = ls_null
			this.object.desc_ot_adm		[row] = ls_null
			return 1
		end if
		
		this.object.desc_labor		[row] = ls_Desc
		of_set_datos_ot(row)
		dw_listado.Retrieve(data)


	CASE 'cod_moneda' 

		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from moneda
		 Where cod_moneda = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de MONEDA o no se encuentra activo, por favor verifique")
			this.object.cod_moneda		[row] = ls_null
			return 1
		end if

END CHOOSE


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

event dw_master::buttonclicked;call super::buttonclicked;String 		ls_base, ls_ot_adm, ls_trabajador, ls_labor, ls_desc_labor, ls_und
Date 			ld_fec_parte
Integer 		li_i, li_row, li_j
u_ds_base 	ds_provbase_det

CHOOSE CASE lower(dwo.name)
		
	CASE "b_imp_base"

		ls_base = dw_master.object.cod_base[row]

		if ls_base = '' or IsNull(ls_base) then
			MessageBox('Error', 'Debe elegir una Base primero')
			return
		end if
	
		ds_provbase_det = create u_ds_base
		ds_provbase_det.DataObject = 'd_list_provbase_det_tbl'
		ds_provbase_det.SetTransObject(SQLCA)
		ds_provbase_det.Retrieve(ls_base)
		for li_i=1 to ds_provbase_det.RowCount()
				li_row = dw_detail.event ue_insert()
				if li_row > 0 then
					dw_detail.object.nro_item 					[li_row] = li_i
					dw_detail.object.proveedor					[li_row] = ds_provbase_det.object.proveedor [li_i]
					dw_detail.object.nom_proveedor 			[li_row] = ds_provbase_det.object.nom_proveedor [li_i]
					dw_detail.object.fec_inicio_pago 			[li_row] = this.object.fec_prestamo [1]
					dw_detail.object.cencos 						[li_row] = 'ADMSULL'
					dw_detail.object.cnta_prsp					[li_row] = 'FONDPREST'
					dw_detail.object.centro_benef				[li_row] = 'CEPIBO'
					dw_detail.object.nro_cuotas					[li_row] = 1
				end if
		next
		
		destroy ds_provbase_det

END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cam306_parte_consumo
integer x = 0
integer y = 1180
integer width = 2542
integer height = 888
string dataobject = "d_abc_cam_pd_consumo_det_tbl"
boolean hsplitscroll = true
end type

event dw_detail::ue_insert_pre;call super::ue_insert_pre;String ls_labor, ls_nro_ot, ls_empacadora, ls_oper_sec

ls_labor = dw_master.object.cod_labor [dw_master.getRow()]

if ls_labor = '' or IsNull(ls_labor) then
	MessageBox('Error', 'Debe Especificar una labor')
	dw_master.setFocus()
	dw_master.setColumn('cod_labor')
	return
end if

ls_empacadora = dw_master.object.cod_empacadora [dw_master.getRow()]

if ls_empacadora = '' or IsNull(ls_empacadora) then
	MessageBox('Error', 'Debe Especificar una Empacadora')
	dw_master.setFocus()
	dw_master.setColumn('cod_empacadora')
	return
end if

ls_nro_ot = dw_master.object.nro_orden [dw_master.getRow()]

if ls_nro_ot = '' or IsNull(ls_nro_ot) then
	MessageBox('Error', 'Debe Especificar una Orden de Trabajo')
	dw_master.setFocus()
	dw_master.setColumn('nro_orden')
	return
end if

//Obtengo la primera operacion aprobada
select op.oper_Sec
	into :ls_oper_sec
from 	ap_empacadora_ot aot, 
		operaciones      op, 
		orden_trabajo 		ot 
where aot.nro_orden = op.nro_orden 
  and op.nro_orden  = ot.nro_orden 
  and op.flag_estado = '1' 
  and aot.cod_empacadora = :ls_empacadora
  and op.cod_labor       = :ls_labor
  and ot.nro_orden		 = :ls_nro_ot;
  
this.object.oper_sec				[al_row] = ls_oper_sec

this.object.nro_item				[al_row] = of_nro_item(this)
this.object.cod_usr				[al_row] = gs_user
this.object.cant_procesada		[al_row] = 0.00
this.object.obs					[al_row] = dw_master.object.observaciones [dw_master.getRow()]

this.object.flag_estado			[al_row] = '1'



end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_ot, ls_labor, &
			ls_und, ls_Almacen
date		ld_fec_inicio
Integer	li_year

if dw_master.getRow() = 0 then return

choose case lower(as_columna)
		
	case "oper_sec"
		
		ls_nro_ot = dw_master.object.nro_orden [dw_master.getRow()]
		
		if ls_nro_ot = '' or IsNull(ls_nro_ot) then
			MessageBox('Error', 'Debe especificar primero un Orden de Trabajo')
			dw_master.setFocus()
			dw_master.setColumn('nro_orden')
			return
		end if
		
		ls_labor = dw_master.object.cod_labor [dw_master.getRow()]
		
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Error', 'Debe especificar primero una Labor')
			dw_master.setFocus()
			dw_master.setColumn('cod_labor')
			return
		end if

		ls_sql = "select op.oper_sec as codigo_operacion, " &
				 + "op.desc_operacion as descripcion_operacion " &
				 + "from operaciones  		op " &
				 + "where op.flag_estado = '1' " &
				 + "  and op.nro_orden = '" + ls_nro_ot + "' " &
				 + "  and op.cod_labor = '" + ls_labor + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.oper_sec			[al_row] = ls_codigo
			this.object.desc_operacion	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cod_art"
		
		ls_almacen = dw_master.object.almacen [dw_master.getRow()]
		
		if ls_Almacen = '' or IsNull(ls_almacen) then
			MessageBox('Error', 'Debe indicar primero el almacen, por favor verifique')
			dw_master.setFocus()
			dw_master.setColumn('almacen')
			return
		end if
		
		ls_sql = "select a.cod_art as codigo_articulo, " &
			    + "a.desc_art as descripcion_articulo, " &
				 + "a.und as und " &
				 + "from articulo a, " &
				 + "     articulo_almacen aa " &
				 + "where a.cod_art = aa.cod_art " &
				 + "  and a.flag_estado = '1' " &
				 + "  and aa.almacen = '" + ls_almacen + "'" &
				 + "  and aa.sldo_total > 0 "
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.object.und		[al_row] = ls_und
			this.ii_update = 1
		end if
	
end choose
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2, ls_sembrador
Long 		ll_count, ll_cuotas
decimal	ldc_interes, ldc_tasa_interes, ldc_capital_final, &
			ldc_capital_inicial, ldc_valor_cuota, ldc_comision

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_campo'
		
		ls_sembrador = dw_master.object.sembrador [dw_master.getRow()]
		
		if ls_sembrador = '' or IsNull(ls_sembrador) then
			MessageBox('Error', 'Debe especificar primero un Sembrador')
			dw_master.setFocus()
			dw_master.setColumn('sembrador')
			return
		end if
		
		// Verifica que codigo ingresado exista			
		/*Select c.desc_campo
	     into :ls_desc1
		  from campo c,
		  		 campo_sembradores cs
		 Where cs.cod_campo = c.cod_campo
		   and c.cod_campo = :data  
		   and c.flag_estado = '1';*/
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de Campo, no le corresponde al sembrador o no se encuentra activo, por favor verifique")
			this.object.cod_campo	[row] = ls_null
			this.object.desc_campo	[row] = ls_null
			of_set_datos_ot(row)
			return 1
		end if

		this.object.desc_campo		[row] = ls_desc1

	CASE 'tipo_variedad' 

		// Verifica que codigo ingresado exista			
		/*Select desc_tipo_variedad
	     into :ls_desc1
		  from cam_variedad_cultivo
		 Where tipo_variedad = :data  
		   and flag_estado = '1';*/
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe tipo de Variedad o no se encuentra activo, por favor verifique")
			this.object.tipo_variedad			[row] = ls_null
			this.object.desc_tipo_variedad	[row] = ls_null
			return 1
			
		end if

END CHOOSE
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
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

type dw_listado from u_dw_abc within w_cam306_parte_consumo
integer x = 2615
integer y = 84
integer width = 1061
integer height = 1080
integer taborder = 20
string dragicon = "C:\SIGRE\resources\ICO\row2.ico"
boolean bringtotop = true
string dataobject = "d_list_plant_consumo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event clicked;call super::clicked;If row = 0 then Return

This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.Drag(Begin!)
is_plantilla = this.object.data.primary.current[row, 1]  // determinar llave para leer dws
end event

event dragdrop;call super::dragdrop;Long 	  ll_row_master, ll_row
Integer li_confirma
String  ls_nro_parte, ls_plantilla, ls_mensaje, ls_estado, ls_texto
dwobject dwo_op

IF source <> dw_asignados THEN
	Drag(End!)
	RETURN
END IF

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

ls_nro_parte   = dw_master.object.nro_parte  	[ll_row_master]
ls_estado		= dw_master.object.flag_estado   [ll_row_master]

IF ls_estado <> '1' THEN
	Messagebox('Aviso','No se puede Eliminar Plantilla por estado del Parte de Consumo')
	Return
END IF

//Cargo a variable local plantilla y orden de trabajo
ll_row = dw_asignados.Getrow()
	
IF ll_row = 0 THEN 
	Messagebox('Aviso','Debe Seleccionar Plantilla a Eliminar ,Verifique!')
	RETURN
END IF


//datos de la plantilla
ls_plantilla = dw_asignados.object.nro_plantilla [ll_row]

IF ISNULL(ls_plantilla) OR Trim(ls_plantilla) = '' THEN
	Messagebox('Error','Nº de plantilla no ha sido Seleccionado')
	RETURN
END IF

// drag source es de la ventana de plantillas
li_confirma = Messagebox("Eliminación de Plantillas", "Usted ha seleccionado lo siguiente:~r~n"+"~r~n"+&
                                    "Nº Parte: "+ls_nro_parte+"~r~n"+&
										      "Nº Plantilla: "+ls_plantilla,Exclamation!, OkCancel!) 

IF li_confirma <> 1 THEN  RETURN //VERIFICA ACEPTACION

dw_asignados.DeleteRow(ll_row)
dw_asignados.ii_update = 1
	
ls_texto = "nro_plantilla='" + ls_plantilla +"'"

ll_row = dw_detail.Find(ls_texto, 1, dw_detail.rowcount())

do while ll_row > 0 
	dw_detail.DeleteRow(ll_row)
	dw_detail.ii_update = 1
	ll_row = dw_detail.Find(ls_texto, 1, dw_detail.rowcount())
loop

		
		

end event

type dw_asignados from u_dw_abc within w_cam306_parte_consumo
integer x = 3694
integer y = 84
integer width = 1061
integer height = 1080
integer taborder = 20
string dragicon = "C:\SIGRE\resources\ICO\row2.ico"
boolean bringtotop = true
string dataobject = "d_abc_cam_plant_consumo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
end event

event clicked;call super::clicked;If row = 0 then Return
This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.Drag(Begin!)


end event

event dragdrop;call super::dragdrop;String  		ls_mensaje, ls_nro_plantilla, ls_nro_parte, ls_flag_estado, &
				ls_nro_orden, ls_labor
Integer 		li_confirma
Long			ll_master_row, ll_row, ll_insert
u_ds_base	lds_datos

IF source <> dw_listado THEN
	Drag(End!)
	RETURN
END IF

dw_master.Accepttext()

//Cargo a variable local numero de orden de trabajo
ll_master_row  = dw_master.GetRow()

IF ll_master_row = 0 THEN RETURN 

ls_nro_parte    = dw_master.object.nro_parte	 	[ll_master_row]
ls_flag_estado  = dw_master.object.flag_estado 	[ll_master_row]
ls_labor			 = dw_master.object.cod_labor 	[ll_master_row]
ls_nro_orden    = dw_master.object.nro_orden 	[ll_master_row]


IF Not (ls_flag_estado = '1' ) THEN   
	Messagebox('Aviso','No se Puede Insertar Plantilla por estado del parte de Consumo, por favor verifique')
	Return	
END IF	

// valida numero de plantilla
IF Isnull(is_plantilla) OR Trim(is_plantilla) = '' THEN
	Messagebox('Mensaje al Usuario','Seleccione Nº de plantilla')
	RETURN
END IF	
	
li_confirma = Messagebox("Mensaje", "Usted ha seleccionado lo siguiente:~r~n"+"~r~n"+ &
												"Plantilla Número : "+is_plantilla+"~r~n"+ &
												"Nro de Parte: "+ls_nro_parte+"~r~n"+ &
												"Desea procesar con los datos existentes?? ",Exclamation!, YesNo!) 
												
IF li_confirma <> 1 THEN  RETURN //no desea generar operaciones

lds_datos = create u_ds_base
lds_datos.DataObject = "d_list_cam_plant_consumo_det_grd"
lds_datos.setTransObject(SQLCA)
lds_datos.Retrieve(is_plantilla)

for ll_row = 1 to lds_datos.RowCount()
	ll_insert = dw_detail.event ue_insert()
	
	if ll_insert > 0 then
		dw_detail.object.cod_art 			[ll_insert] = lds_datos.object.cod_art [ll_row]
		dw_detail.object.desc_art 			[ll_insert] = lds_datos.object.desc_art [ll_row]
		dw_detail.object.und 				[ll_insert] = lds_datos.object.und [ll_row]
		dw_detail.object.cant_procesada 	[ll_insert] = lds_datos.object.cantidad [ll_row]
		dw_detail.object.cod_usr 			[ll_insert] = gs_user
		dw_detail.object.nro_plantilla 	[ll_insert] = lds_datos.object.nro_plantilla [ll_row]
	end if
next

ll_insert = this.event ue_insert()

if ll_insert > 0 then
	this.object.nro_plantilla [ll_insert] = is_plantilla
	this.object.cod_usr 		  [ll_insert] = gs_user
	this.object.descripcion	  [ll_insert] = dw_listado.object.descripcion[dw_listado.getRow()]
end if

destroy lds_datos

end event

type st_1 from statictext within w_cam306_parte_consumo
integer x = 2615
integer y = 4
integer width = 1061
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Listado de Plantillas de Consumo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cam306_parte_consumo
integer x = 3694
integer width = 1061
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Plantillas de Consumo asignados"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

