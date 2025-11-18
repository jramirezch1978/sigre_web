$PBExportHeader$w_ap317_parte_cosecha.srw
forward
global type w_ap317_parte_cosecha from w_abc_master_smpl
end type
type tab_1 from tab within w_ap317_parte_cosecha
end type
type tabpage_1 from userobject within tab_1
end type
type dw_control from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_control dw_control
end type
type tabpage_2 from userobject within tab_1
end type
type dw_recibo from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_recibo dw_recibo
end type
type tabpage_3 from userobject within tab_1
end type
type dw_transporte from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_transporte dw_transporte
end type
type tab_1 from tab within w_ap317_parte_cosecha
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_ap317_parte_cosecha from w_abc_master_smpl
integer width = 3086
integer height = 2148
string title = "[AP317] Parte de Cosecha de Campo"
string menuname = "m_mantto_consulta"
tab_1 tab_1
end type
global w_ap317_parte_cosecha w_ap317_parte_cosecha

type variables
u_dw_abc	idw_control, idw_recibo, idw_transporte
String 	is_soles, is_salir, is_cod_empresa, is_labor, is_desc_labor
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public function boolean of_get_precio (string as_proveedor, string as_especie, long al_row)
public function integer of_get_param ()
public function boolean of_get_precio_transp (string as_proveedor, string as_ruta, long al_row)
public function boolean of_retrieve (string as_nro_parte)
public function boolean of_get_pptt (long al_row)
public function boolean of_get_ot (string as_empacadora, long al_row)
end prototypes

public subroutine of_asigna_dws ();idw_control 	= tab_1.tabpage_1.dw_control
idw_recibo		= tab_1.tabpage_2.dw_recibo
idw_transporte	= tab_1.tabpage_3.dw_transporte
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE num_ap_control_cosecha IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_ap_control_cosecha 
	where origen = :gs_origen for update;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_ap_control_cosecha (origen, ult_nro)
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
	
	dw_master.object.nro_parte[dw_master.getrow()] = ls_nro
	
	// Incrementa contador
	Update num_ap_control_cosecha 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :gs_origen;
	
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
for ll_j = 1 to idw_control.RowCount()	
	idw_control.object.nro_parte[ll_j] = ls_nro	
next

for ll_j = 1 to idw_recibo.RowCount()	
	idw_recibo.object.nro_parte[ll_j] = ls_nro	
next

for ll_j = 1 to idw_transporte.RowCount()	
	idw_transporte.object.nro_parte[ll_j] = ls_nro	
next

return 1
end function

public function boolean of_get_precio (string as_proveedor, string as_especie, long al_row);string 	ls_moneda
Decimal	ldc_precio, ldc_peso_ratio
Date		ld_fecha

ld_fecha	= Date(dw_master.object.fec_parte [dw_master.getRow()])

select p.cod_moneda, p.importe, p.peso_ratio
	into :ls_moneda, :ldc_precio, :ldc_peso_ratio
from ap_prov_mp_tarifa p
where p.proveedor = :as_proveedor
  and p.especie   = :as_especie
  and trunc(:ld_fecha) between trunc(p.fecha_inicio) and trunc(p.fecha_fin);
  

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'El proveedor no tiene especificado un precio de materia prima, por favor verifique')
	return false
end if

idw_recibo.object.moneda 		[al_Row] = ls_moneda
idw_recibo.object.precio_unit [al_Row] = ldc_precio
idw_recibo.object.peso_ratio	[al_Row] = ldc_peso_ratio

return true

end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

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

// busca tipos de movimiento definidos
SELECT 	cod_empresa
	INTO 	:is_cod_empresa
FROM genparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en GENPARAM")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

// Parametros de AP_PARAM
SELECT 	lab_cons_mp
	INTO 	:is_labor
FROM ap_param
where origen = 'XX';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros generales en AP_PARAM")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

select desc_labor
	into :is_desc_labor
	from labor
where cod_labor = :is_labor;

return 1
end function

public function boolean of_get_precio_transp (string as_proveedor, string as_ruta, long al_row);string 	ls_moneda, ls_flag_inc_igv
Decimal	ldc_precio
Date		ld_fecha

ld_fecha	= Date(dw_master.object.fec_parte [dw_master.getRow()])

select p.cod_moneda, p.importe, p.flag_inc_igv
	into :ls_moneda, :ldc_precio, :ls_flag_inc_igv
from AP_TRANSP_TARIF p
where p.proveedor = :as_proveedor
  and p.cod_ruta   = :as_ruta
  and trunc(:ld_fecha) between trunc(p.fecha_inicio) and trunc(p.fecha_fin);
  

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'El proveedor no tiene especificado un precio de transporte, por favor verifique')
	return false
end if

idw_transporte.object.moneda 				[al_Row] = ls_moneda
idw_transporte.object.precio_flete 		[al_Row] = ldc_precio
idw_transporte.object.flag_incluye_igv [al_Row] = ls_flag_inc_igv

return true

end function

public function boolean of_retrieve (string as_nro_parte);dw_master.Retrieve(as_nro_parte)
idw_control.Retrieve(as_nro_parte)
idw_recibo.Retrieve(as_nro_parte)
idw_transporte.Retrieve(as_nro_parte)

dw_master.ii_protect 		= 0
idw_control.ii_protect 		= 0
idw_recibo.ii_protect 		= 0
idw_transporte.ii_protect 	= 0

dw_master.of_protect( )
idw_control.of_protect( )
idw_recibo.of_protect( )
idw_transporte.of_protect( )

dw_master.ResetUpdate( )
idw_control.ResetUpdate( )
idw_recibo.ResetUpdate( )
idw_transporte.ResetUpdate( )

dw_master.ii_update 			= 0
idw_control.ii_update 		= 0
idw_recibo.ii_update 		= 0
idw_transporte.ii_update	= 0

if dw_master.RowCount() > 0 then
	dw_master.il_row = dw_master.getRow()
end if


is_Action = 'open'

return true
end function

public function boolean of_get_pptt (long al_row);String ls_certificacion, ls_tipo_caja, ls_tipo_funda, ls_cod_art, ls_desc_art

ls_certificacion 	= idw_recibo.object.tipo_certificacion [al_row]
ls_tipo_caja 		= idw_recibo.object.tipo_caja 			[al_row]
ls_tipo_funda		= idw_recibo.object.tipo_funda	 		[al_row]

if IsNull(ls_certificacion) or ls_certificacion = '' or &
	IsNull(ls_tipo_caja) or ls_tipo_caja = '' or &
	IsNull(ls_tipo_funda) or ls_tipo_funda = '' then return false

select  a.cod_Art, a.desc_art
	into :ls_cod_art, :ls_desc_art
from 	ap_tipo_certificacion_det 	tcd,
		articulo							a
where tcd.cod_Art_pptt = a.cod_art
  and tcd.tipo_certificacion = :ls_certificacion
  and tcd.tipo_caja			  = :ls_tipo_caja
  and tcd.tipo_funda			  = :ls_tipo_funda;

if SQLCA.SQLCode = 100 then
	MessageBox('Error', "No existe un articulo de PPTT definido para estos parametros " &
							  + "~r~nTipo Certificacion: " + ls_certificacion &
							  + "~r~nTipo Caja: " + ls_tipo_Caja &
							  + "~r~nTipo Funda: " + ls_tipo_funda)
	return false
end if

idw_recibo.object.cod_art_pptt [al_row] = ls_cod_art
idw_recibo.object.desc_Art		 [al_row] = ls_desc_art

return true
end function

public function boolean of_get_ot (string as_empacadora, long al_row);string 	ls_nro_ot, ls_titulo_ot, ls_ot_adm, ls_desc_ot_adm


select ot.nro_orden, ot.titulo, ot.ot_adm, oa.descripcion
	into :ls_nro_ot, :ls_titulo_ot, :ls_ot_adm, :ls_desc_ot_adm
from 	orden_trabajo 		ot,
		operaciones			op,
		ap_empacadora_ot 	aot,
		ot_administracion oa
where ot.nro_orden	= op.nro_orden
  and ot.nro_orden	= aot.nro_orden
  and ot.ot_adm		= oa.ot_adm
  and op.cod_labor	= :is_labor
  and aot.cod_empacadora = :as_empacadora
  and op.flag_estado	= '1';
  

if SQLCA.SQLCode = 100 then
	MessageBox('Error', "No existe labor " + is_desc_labor + " aprobada para la empacadora " + as_empacadora + ", por favor verifique")
	return false
end if

dw_master.object.nro_orden 	[al_Row] = ls_nro_ot
dw_master.object.titulo_ot		[al_Row] = ls_titulo_ot
dw_master.object.ot_adm 		[al_Row] = ls_ot_adm
dw_master.object.desc_ot_adm	[al_Row] = ls_desc_ot_adm


return true

end function

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height  = newheight  - tab_1.y - 10

idw_control.width = tab_1.tabpage_1.width - idw_control.x - 10
idw_control.height = tab_1.tabpage_1.height - idw_control.y - 10

idw_recibo.width = tab_1.tabpage_2.width - idw_recibo.x - 10
idw_recibo.height = tab_1.tabpage_2.height - idw_recibo.y - 10

idw_transporte.width = tab_1.tabpage_3.width - idw_transporte.x - 10
idw_transporte.height = tab_1.tabpage_3.height - idw_transporte.y - 10




end event

on w_ap317_parte_cosecha.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_ap317_parte_cosecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0 

idw_control.setTransObject(SQLCA)
idw_recibo.setTransObject(SQLCA)
idw_transporte.setTransObject(SQLCA)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return
if f_row_Processing( idw_control, idw_control.is_dwform) <> true then return
if f_row_Processing( idw_recibo, idw_recibo.is_dwform) <> true then return
if f_row_Processing( idw_transporte, idw_transporte.is_dwform) <> true then return

if idw_control.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_control.of_set_flag_replicacion()
idw_recibo.of_set_flag_replicacion()
idw_transporte.of_set_flag_replicacion()

end event

event ue_update;//Override
Boolean  lbo_ok = TRUE
String	ls_msg
Long		ll_row

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_control.of_create_log()
	idw_recibo.of_create_log()
	idw_transporte.of_create_log()
END IF

//Quito los filtros para actualizar
string ls_null =""
idw_recibo.SetFilter(ls_null)
idw_recibo.Filter()
idw_transporte.SetFilter(ls_null)
idw_transporte.Filter()

ll_row = idw_control.getRow() 

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	idw_control.ii_update = 1 THEN
	IF idw_control.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	idw_recibo.ii_update = 1 THEN
	IF idw_recibo.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	idw_transporte.ii_update = 1 THEN
	IF idw_transporte.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_control.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_recibo.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_transporte.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	idw_control.ii_update = 0
	idw_control.il_totdel = 0

	idw_recibo.ii_update = 0
	idw_recibo.il_totdel = 0

	idw_transporte.ii_update = 0
	idw_transporte.il_totdel = 0


	dw_master.ResetUpdate( )
	idw_control.ResetUpdate( )
	idw_recibo.ResetUpdate( )
	idw_transporte.ResetUpdate( )
	
	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_parte [dw_master.getRow()])
		if ll_row > 0 then
			idw_control.SetRow(ll_row)
			idw_control.SelectRow(0, false)
			idw_control.SelectRow(ll_row, true)
			idw_control.il_row = ll_row
		end if
	end if
	
END IF

//Aplico nuevamente los filtros
String	ls_filter
if idw_control.RowCount() > 0 then 
	
	ls_filter = "nro_certificacion='" + idw_control.object.nro_certificacion[idw_control.getRow()] + "'"
	idw_recibo.setFilter(ls_filter)
	idw_recibo.Filter()
	
	idw_transporte.setFilter(ls_filter)
	idw_transporte.Filter()
	
end if
end event

event ue_update_request;//Override
Integer li_msg_result

IF dw_master.ii_update = 1  or idw_control.ii_update = 1 or &
	idw_recibo.ii_update = 1  or idw_transporte.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	END IF
	
END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'd_list_parte_cosecha_tbl'
sl_param.titulo = 'PARTES DIARIOS DE COSECHA'
sl_param.field_ret_i[1] = 1	//Nro Parte

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_modify;//Override

if is_action <> 'open' and is_action <> 'edit' then
	MessageBox('Error', 'Grabe la acción que esta realizando y luego proceda a editar el parte')
	return
end if

if dw_master.getRow() = 0 then return

if dw_master.object.flag_estado [dw_master.getRow()] <> '1' then
	MessageBox('Error', 'No se puede modificar este parte porque no esta activo, por favor verifique')
	return
end if

dw_master.of_protect() 
idw_control.of_protect()
idw_recibo.of_protect()
idw_transporte.of_protect()

is_Action = 'edit'


end event

event ue_anular;call super::ue_anular;Integer li_row
if dw_master.getRow() = 0 then return

if is_action <> 'open' then
	MessageBox('Error', 'Grabe la acción que esta realizando antes de anular el parte')
	return
end if

if dw_master.object.flag_estado[dw_master.getRow()] <> '1' then
	MessageBox('Error', 'El parte de cosecha no se puede anular, por favor verifique')
	return
end if

if MessageBox('Aviso', 'Desea anular el parte de cosecha?', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado[dw_master.getRow()] = '0'
dw_master.ii_update = 1

for li_row = 1 to idw_recibo.RowCount()
	idw_recibo.object.flag_estado [li_row] = '0'
	idw_recibo.ii_update = 1
next


is_action = 'anular'


end event

event ue_insert;//Override
Long  ll_row

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then return
	
	if dw_master.object.flag_estado [dw_master.getRow()] <> '1' then
		MessageBox('Error', 'El documento no esta activo, por favor verifique')
		return		
	end if
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if


end event

event ue_delete;//Override
if dw_master.getRow() = 0 then return

if dw_master.object.flag_estado [dw_master.getRow()] <> '1' then
	MessageBox('Error', 'No se puede modificar este parte porque no esta activo, por favor verifique')
	return
end if

Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_ap317_parte_cosecha
integer width = 2907
integer height = 880
string dataobject = "d_abc_parte_cosecha_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.flag_estado 	[al_row] = '1'
this.object.fec_registro	[al_row] = f_fecha_Actual()
this.object.fec_parte		[al_row] = Date(f_fecha_Actual())
this.object.cod_usr			[al_row] = gs_user
this.object.semana			[al_row] = ll_Semana
this.object.ano				[al_row] = year(ld_FechaActual)
this.object.cod_origen		[al_row] = gs_origen

//Labor por defecto
this.object.cod_labor		[al_row] = is_labor
this.object.desc_labor		[al_row] = is_desc_labor

select nom_proveedor, ruc
	into :ls_desc_empresa, :ls_ruc
from proveedor
where proveedor = :is_cod_empresa;


this.object.exportadora		[al_row] = is_cod_empresa
this.object.nom_exportadora[al_row] = ls_desc_empresa
this.object.ruc				[al_row] = ls_ruc

idw_control.reset()
idw_recibo.reset()
idw_transporte.reset()

is_Action = 'new'
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2, ls_desc3, ls_ot_adm, ls_nro_ot
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
		
	case "cod_empacadora"

		select ae.desc_empacadora, aps.desc_sector, apb.desc_base
			into :ls_desc1, :ls_desc2, :ls_desc3
		from 	ap_empacadora ae,
				ap_sectores   aps, 
				ap_bases      apb 
		where ae.cod_sector = aps.cod_sector 
		  and aps.cod_base  = apb.cod_base  
		  and ae.flag_estado = '1'
		  and ae.cod_empacadora = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de empacadora o no se encuentra activo, por favor verifique")
			this.object.cod_empacadora	[row] = ls_null
			this.object.desc_empacadora[row] = ls_null
			this.object.desc_sector		[row] = ls_null
			this.object.desc_base		[row] = ls_null
			return 1
			
		end if
		
		if of_get_ot(data, row) then
			this.object.desc_empacadora	[row] = ls_desc1
			this.object.desc_sector			[row] = ls_desc2
			this.object.desc_base			[row] = ls_desc2
		end if

	case "cod_cuadrilla"

		select a.desc_cuadrilla
			into :ls_desc1
		from 	ap_cuadrilla a
		where a.flag_estado = '1'
		  and a.cod_cuadrilla = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Cuadrilla o no se encuentra activo, por favor verifique")
			this.object.cod_cuadrilla	[row] = ls_null
			this.object.desc_cuadrilla	[row] = ls_null
			return 1
			
		end if

		this.object.desc_cuadrilla	[row] = ls_desc1

	case "exportadora"

		select a.nom_proveedor, a.ruc
			into :ls_desc1, :ls_desc2
		from 	proveedor a
		where a.flag_estado = '1'
		  and a.proveedor = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de exportador o no se encuentra activo, por favor verifique")
			this.object.exportadora			[row] = ls_null
			this.object.nom_exportadora	[row] = ls_null
			this.object.ruc					[row] = ls_null
			return 1
			
		end if

		this.object.nom_exportadora	[row] = ls_desc1
		this.object.ruc					[row] = ls_desc2

	case "ot_adm"
		
		select a.descripcion
			into :ls_desc1
		from 	ot_Administracion a
		where a.flag_estado = '1'
		  and a.ot_adm = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe OT_ADM o no se encuentra activo, por favor verifique")
			this.object.ot_adm		[row] = ls_null
			this.object.desc_ot_adm	[row] = ls_null
			return 1
			
		end if

		this.object.desc_ot_adm	[row] = ls_desc1

	case "nro_orden"
		ls_ot_adm = this.object.ot_adm [row]
		
		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox("Error", "No se ha ingresado ningun OT_ADM, por favor verifique")
			this.object.nro_orden	[row] = ls_null
			this.object.titulo_ot	[row] = ls_null
			this.setColumn("ot_adm")
			return 1
		end if

		select titulo
			into :ls_desc1
		from 	orden_trabajo
		where flag_estado = '1'
		  and nro_orden 	= :data
		  and ot_adm 	   = :ls_ot_adm;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Orden de Trabajo, no se encuentra activo o no corresponde al ot_adm " + ls_ot_adm + " , por favor verifique")
			this.object.nro_orden	[row] = ls_null
			this.object.titulo_ot	[row] = ls_null
			return 1
		end if

		this.object.titulo_ot	[row] = ls_desc1


	case "cod_labor"
		ls_nro_ot = this.object.nro_orden [row]
		
		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox("Error", "No se ha ingresado ninguna Orden de Trabajo por favor verifique")
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			this.setColumn("nro_orden")
			return 1
		end if

		select desc_labor
			into :ls_desc1
		from 	labor l,
				operaciones op
		where op.cod_labor = l.cod_labor
		  and op.flag_estado = '1'
		  and op.nro_orden 	= :data
		  and op.cod_labor 	= :ls_nro_ot;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe la Labor especificada en la Orden de Trabajo, no se encuentra activo o no corresponde al ot_adm " + ls_ot_adm + " , por favor verifique")
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			return 1
		end if

		this.object.desc_labor	[row] = ls_desc1

END CHOOSE
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_data3, &
			ls_ot_adm, ls_nro_ot, ls_empacadora, ls_base
			
choose case lower(as_columna)
		
	case "cod_empacadora"

		ls_sql = "select ae.cod_empacadora as codigo_empacadora, " &
				 + "ae.desc_empacadora as descripcion_empacadora, " & 
				 + "aps.desc_sector, apb.desc_base, apb.cod_base " &
				 + "from ap_empacadora ae, " &
				 + "     ap_sectores   aps, " &
				 + "     ap_bases      apb " &
				 + "where ae.cod_sector = aps.cod_sector " &
				 + "  and aps.cod_base  = apb.cod_base  " &
				 + "  and ae.flag_estado = '1'"
				 
		lb_ret = f_lista_5ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, ls_base, '2')
		
		if ls_codigo <> '' then
			if of_get_ot(ls_codigo, al_row) then
				this.object.cod_empacadora	[al_row] = ls_codigo
				this.object.desc_empacadora[al_row] = ls_data
				this.object.desc_sector		[al_row] = ls_data2
				this.object.desc_base		[al_row] = ls_data3
				this.object.cod_base			[al_row] = ls_base
				this.ii_update = 1
			end if
		end if

	case "cod_cuadrilla"

		ls_sql = "select a.cod_cuadrilla as codigo_cuadrilla, " & 
				 + "	     a.desc_cuadrilla as descripcion_cuadrilla, " &
				 + "       m.cod_trabajador as codigo_trabajador, " & 
				 + "	     m.nom_trabajador as nombre_trabajador " &
				 + "from ap_cuadrilla a, " &
				 + "     vw_pr_trabajador m " &
				 + "where a.jefe_cuadrilla = m.cod_trabajador (+) " & 
				 + " and a.flag_estado = '1'"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '2')
		
		if ls_codigo <> '' then
			this.object.cod_cuadrilla	[al_row] = ls_codigo
			this.object.desc_cuadrilla	[al_row] = ls_data
			this.object.jefe_cuadrilla	[al_row] = ls_data2
			this.object.nom_trabajador	[al_row] = ls_data3
			this.ii_update = 1
		end if

	case "jefe_cuadrilla"

		ls_sql = "select m.cod_trabajador as codigo_trabajador, " & 
				 + "	     m.nom_trabajador as nombre_trabajador, " &
				 + "	     m.nro_doc_ident_rtps as dni_trabajador " &
				 + "from vw_pr_trabajador m " &
				 + "where m.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.jefe_cuadrilla	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "exportadora"

		ls_sql = "select a.proveedor as codigo_proveedor, " & 
				 + "		  a.nom_proveedor as nombre_proveedor, " &
				 + "		  a.ruc as ruc_proveedor " &
				 + "from proveedor a " &
				 + "where a.flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')
		
		if ls_codigo <> '' then
			this.object.exportadora		[al_row] = ls_codigo
			this.object.nom_exportadora[al_row] = ls_data
			this.object.ruc				[al_row] = ls_data2
			this.ii_update = 1
		end if

	case "ot_adm"

		ls_sql = "select a.ot_adm as codigo_ot_adm, " & 
				 + "		  a.descripcion as descripcion_ot_adm " &
				 + "from ot_administracion a " &
				 + "where a.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
		end if	

	case "nro_orden"

		ls_ot_adm = this.object.ot_adm [al_row]
		
		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox("Error", "No se ha ingresado ningun OT_ADM, por favor verifique")
			this.setColumn("ot_adm")
			return 
		end if
		
		ls_empacadora = this.object.cod_empacadora [al_row]
		
		if IsNull(ls_empacadora) or ls_empacadora = '' then
			MessageBox("Error", "No se ha ingresado ninguna empacadora, por favor verifique")
			this.setColumn("cod_empacadora")
			return 
		end if
		
		ls_sql = "select ot.nro_orden as nro_ot, " &
				 + "ot.titulo as titulo_ot " &
				 + "from orden_trabajo ot, " &
				 + "		ap_empacadora_ot aot " &
				 + "where ot.nro_orden = aot.nro_orden " &
				 + "  and ot.flag_estado = '1' " &
				 + "  and ot.ot_adm = '" + ls_ot_adm + "'" &
				 + "  and aot.cod_empacadora = '" + ls_empacadora + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.titulo_ot	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "cod_labor"
		
		ls_nro_ot = this.object.nro_orden [al_row]
		
		if IsNull(ls_nro_ot) or ls_nro_ot  = "" then
			MessageBox('Error', 'Debe Ingresa una OT antes')
			return
		end if

		ls_sql = "select distinct l.cod_labor as codigo_labor, " &
				 + "l.desc_labor as descrpcion_labor " & 
				 + "from operaciones op, " &
				 + "     labor			l " &		   
				 + "where op.cod_labor = l.cod_labor " &
				 + "  and op.flag_estado = '1' " &
				 + "  and op.nro_orden = '" + ls_nro_ot + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose




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

type tab_1 from tab within w_ap317_parte_cosecha
integer y = 912
integer width = 2606
integer height = 984
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
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2569
integer height = 856
long backcolor = 79741120
string text = "Control de Calidad"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_control dw_control
end type

on tabpage_1.create
this.dw_control=create dw_control
this.Control[]={this.dw_control}
end on

on tabpage_1.destroy
destroy(this.dw_control)
end on

type dw_control from u_dw_abc within tabpage_1
integer width = 2569
integer height = 1164
integer taborder = 20
string dataobject = "d_abc_control_cosecha_tbl"
boolean hsplitscroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;String 	ls_labor, ls_nro_ot, ls_oper_sec
integer	li_count

this.object.cod_usr	[al_row] = gs_user

this.object.area_has			[al_row] = 0.00
this.object.racimos_nar		[al_row] = 0
this.object.racimos_plo		[al_row] = 0
this.object.racimos_ver		[al_row] = 0
this.object.racimos_lil		[al_row] = 0
this.object.racimos_mar		[al_row] = 0
this.object.racimos_ama		[al_row] = 0
this.object.racimos_azu		[al_row] = 0
this.object.racimos_roj		[al_row] = 0
this.object.racimos_bla		[al_row] = 0
this.object.racimos_neg		[al_row] = 0
this.object.racimos_otr		[al_row] = 0
this.object.mosaico_parcela[al_row] = 0


this.object.perdidas_mos		[al_row] = 0
this.object.perdidas_otr		[al_row] = 0
this.object.cajas_producidas	[al_row] = 0

ls_nro_Ot 	= dw_master.object.nro_orden [dw_master.getRow()]
ls_labor 	= dw_master.object.cod_labor [dw_master.getRow()]

this.object.nro_orden			[al_row] = ls_nro_ot

///Busco la oeracion por defecto
select count(*)
	into :li_count
from operaciones op
where op.flag_estado = '1'
  and op.cod_labor	= :ls_labor
  and op.nro_orden	= :ls_nro_ot;

if li_count > 0 then
	select op.oper_sec
		into :ls_oper_sec
	from operaciones 	op
	where op.flag_estado = '1'
	  and op.cod_labor	= :ls_labor
	  and op.nro_orden	= :ls_nro_ot;

	this.object.oper_sec	[al_row] = ls_oper_sec
	
end if

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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null, ls_base
SetNull(ls_null)			

choose case lower(as_columna)
	case "nro_certificacion"
		ls_base = dw_master.object.cod_base [dw_master.getRow()]
		
		if ls_base = '' or IsNull(ls_base) then
			MessageBox('Error', 'No ha ingresado una base en la cabecera, por favor verifique')
			return
		end if
		
		ls_sql = "SELECT a.nro_certificacion AS certificacion_productor, " &
				 + "a.has as area_has, " &
				 + "p.proveedor AS codigo_productor, " &
				 + "p.nom_proveedor AS nombre_productor, " &
				 + "p.ruc AS ruc_productor " &
				 + "FROM AP_PROVEEDOR_CERTIF a, " &
				 +"      ap_proveedor_mp     mp, " &
				 + "     proveedor 			  p " &
				 + "WHERE a.proveedor = p.proveedor " &
				 + "  and a.proveedor = mp.proveedor " &
				 + "  and a.cod_base  = '" + ls_base + "'" &
				 + "  and p.FLAG_ESTADO = '1' " &
				 + "  and mp.flag_estado = '1' " &
				 + "  and a.flag_estado = '1' "

		lb_ret = f_lista_4ret_text(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.nro_certificacion	[al_row] = ls_codigo
			this.object.area_has				[al_row] = Dec(ls_data)
			this.object.productor			[al_row] = ls_data2
			this.object.nom_proveedor		[al_row] = ls_data3
			this.ii_update = 1
			
		end if

	case "nro_orden"
		ls_ot_adm = dw_master.object.ot_adm [dw_master.getRow()]
		
		if IsNull(ls_ot_adm) or ls_ot_adm = "" then
			MessageBox('Error', "Debe indicar primero el OT_ADM en la cabecera del parte")
			dw_master.setFocus()
			dw_master.setColumn("ot_adm")
			return
		end if
		
		ls_sql = "select ot.nro_orden as nro_ot, " &
				 + "ot.titulo as titulo_ot " &
				 + "from orden_trabajo ot " &
				 + "where ot.flag_estado = '1' " &
				 + "  and ot.ot_adm = '" + ls_ot_adm + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.oper_sec		[al_row] = ls_null
			this.ii_update = 1
		end if

	case "oper_sec"
		ls_nro_ot = this.object.nro_orden [al_row]
		if IsNull(ls_nro_ot) or ls_nro_ot = "" then
			MessageBox('Error', "Debe indicar primero la Orden de Trabajo")
			this.setColumn("nro_orden")
			return
		end if
		
		ls_labor  = dw_master.object.cod_labor [dw_master.getRow()]
		if IsNull(ls_labor) or ls_labor = "" then
			MessageBox('Error', "Debe indicar primero Una labor")
			dw_master.setColumn("cod_labor")
			dw_master.setFocus()
			return
		end if
		
		ls_sql = "select op.oper_sec as oper_sec, " &
				 + "		  op.desc_operacion as descripcion_operacion " &
				 + "from operaciones op " &
				 + "where op.nro_orden = '" + ls_nro_ot + "' " &
				 + "  and op.FLAG_ESTADO = '1' " &
				 + "  and op.cod_labor = '" + ls_labor + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.oper_sec	[al_row] = ls_codigo
			this.ii_update = 1
		end if		
		
end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2, ls_desc3, ls_base
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "nro_certificacion"
		
		ls_base = dw_master.object.cod_base [dw_master.getRow()]
		
		if ls_base = '' or IsNull(ls_base) then
			MessageBox('Error', 'No ha ingresado una base en la cabecera, por favor verifique')
			return 1
		end if
		
		select p.proveedor, p.nom_proveedor, apc.has
			into :ls_desc2, :ls_desc1, :ldc_has
		from 	ap_proveedor_certif apc,
     			proveedor           p
		where apc.proveedor  = p.proveedor
		  and p.proveedor    = :data
		  and apc.cod_base	= :ls_base
		  and p.flag_estado  = '1'
		  and apc.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Numero de Certificado, o el numero de certificado no corresponde a la base indicada o el productor no se encuentra activo, por favor verifique")
			this.object.nro_certificacion	[row] = ls_null
			this.object.productor			[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			this.object.area_has				[row] = 0
			return 1
			
		end if

		this.object.nom_proveedor	[row] = ls_desc1
		this.object.productor		[row] = ls_desc2
		this.object.area_has			[row] = ldc_has
END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;String	ls_filter, ls_nro_certificacion
	
if currentrow = 0 then return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
this.il_row = currentrow

ls_nro_certificacion = this.object.nro_certificacion[currentrow]

if IsNull(ls_nro_certificacion) then 
	ls_filter = "nro_certificacion=''"
else
	ls_filter = "nro_certificacion='" + ls_nro_certificacion + "'"
end if

idw_recibo.setFilter(ls_filter)
idw_recibo.Filter()

idw_transporte.setFilter(ls_filter)
idw_transporte.Filter()
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2569
integer height = 856
long backcolor = 79741120
string text = "Recibo entrega Caja"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_recibo dw_recibo
end type

on tabpage_2.create
this.dw_recibo=create dw_recibo
this.Control[]={this.dw_recibo}
end on

on tabpage_2.destroy
destroy(this.dw_recibo)
end on

type dw_recibo from u_dw_abc within tabpage_2
integer width = 2501
integer height = 1104
integer taborder = 20
string dataobject = "d_abc_recibo_caja_tbl"
boolean hsplitscroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw


ii_rk[1] = 2 	      // columnas que recibimos del master
ii_rk[2] = 3 	      // columnas que recibimos del master

idw_mst  = 	idw_control
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event ue_insert_pre;call super::ue_insert_pre;string 	ls_empacadora, ls_almacen, ls_desc_almacen, ls_cenbef, ls_desc_cenbef, &
			ls_productor, ls_especie, ls_desc_especie, ls_moneda, ls_nro_ot, ls_labor, &
			ls_oper_sec
Date		ld_fecha			
Decimal	ldc_precio

this.object.nro_parte			[al_row] = idw_mst.object.nro_parte				[idw_mst.getRow()]
this.object.nro_certificacion	[al_row] = idw_mst.object.nro_certificacion	[idw_mst.getRow()]
this.object.productor			[al_row] = idw_mst.object.productor				[idw_mst.getRow()]

this.object.fec_registro		[al_Row] = f_fecha_Actual()
this.object.cod_usr				[al_row] = gs_user

this.object.peso_cajas			[al_row] = 0.00
this.object.nro_racimos			[al_row] = 0
this.object.cant_cajas			[al_row] = 0
this.object.cant_fundas			[al_row] = 0
this.object.precio_unit			[al_row] = 0.00

this.object.flag_estado			[al_row] = '1'

//23-01-2012 Agregar el almacén de Materia Prima
// y Almacén de PP.TT. solicitado por Elvis Solano
select almacen, desc_almacen
	into :ls_almacen, :ls_desc_almacen
from almacen
where flag_tipo_almacen = 'P';

this.object.almacen_mp			[al_row] = ls_almacen
this.object.desc_almacen_mp	[al_row] = ls_desc_almacen

select almacen, desc_almacen
	into :ls_almacen, :ls_desc_almacen
from almacen
where flag_tipo_almacen = 'T';

this.object.almacen_pptt		[al_row] = ls_almacen
this.object.desc_almacen_pptt	[al_row] = ls_desc_almacen

//CEntro Beneficio
ls_empacadora = dw_master.object.cod_empacadora [dw_master.getRow()]

select a.centro_benef, cb.desc_centro
  into :ls_cenbef, :ls_desc_cenbef
from 	ap_empacadora a,
		centro_beneficio cb
where a.centro_benef = cb.centro_benef
  and a.cod_empacadora = :ls_empacadora;

this.object.centro_benef 		[al_row] = ls_cenbef
this.object.desc_centro_benef [al_row] = ls_desc_cenbef

//materia Prima
ls_productor = idw_control.object.productor [idw_control.getRow()]
ld_fecha		 = Date(f_fecha_actual())

select a.especie, te.descr_especie, a.importe, a.cod_moneda
	into :ls_especie, :ls_desc_especie, :ldc_precio, :ls_moneda
from ap_prov_mp_tarifa a,
     tg_especies       te
where a.especie = te.especie
  and a.proveedor = :ls_productor
  and trunc(:ld_fecha) between fecha_inicio and fecha_fin;

this.object.especie 		[al_row] = ls_especie
this.object.desc_especie[al_row] = ls_desc_especie
this.object.precio_unit	[al_row] = ldc_precio
this.object.moneda		[al_row] = ls_moneda

//Datos para obtener la operacion por defecto
ls_labor 	= dw_master.object.cod_labor [dw_master.getRow()]
ls_nro_ot 	= dw_master.object.nro_orden [dw_master.getRow()]

select oper_sec
	into :ls_oper_sec
from operaciones op
where op.nro_orden = :ls_nro_ot
  and op.cod_labor = :ls_labor
  and op.flag_estado = '1';

this.object.oper_sec [al_row] = ls_oper_sec
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_productor, ls_labor, ls_nro_ot
Date		ld_fecha

choose case lower(as_columna)
		
	case "oper_sec"
		ls_labor = dw_master.object.cod_labor [dw_master.getRow()]
		
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Error', 'Debe definir primero una labor')
			dw_master.setFocus()
			dw_master.setColumn("cod_labor")
			return
		end if
		
		ls_nro_ot = dw_master.object.nro_orden [dw_master.getRow()]
		
		if ls_nro_ot = '' or IsNull(ls_nro_ot) then
			MessageBox('Error', 'Debe definir primero una OT')
			dw_master.setFocus()
			dw_master.setColumn("nro_orden")
			return
		end if
		
		ls_sql = "SELECT oper_sec AS oper_sec, " &
				  + "desc_operacion AS descripcion_operacion " &
				  + "FROM operaciones " &
				  + "WHERE nro_orden = '" + ls_nro_ot + "'" &
				  + "  and cod_labor = '" + ls_labor + "'" &
				  + "  and FLAG_ESTADO = '1' "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.oper_sec		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_caja"
		ls_sql = "SELECT tipo_caja AS tipo_caja, " &
				  + "desc_tipo_caja AS descripcion_tipo_caja " &
				  + "FROM ap_tipo_caja " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "order by tipo_caja"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_caja		[al_row] = ls_codigo
			this.object.desc_tipo_caja	[al_row] = ls_data
			of_get_pptt(al_Row)
			this.ii_update = 1
		end if
		
	case "tipo_certificacion"
		ls_sql = "SELECT tipo_certificacion AS tipo_certificacion, " &
				  + "desc_certificacion AS descripcion_tipo_certificacion " &
				  + "FROM ap_tipo_certificacion " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "order by tipo_certificacion"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_certificacion	[al_row] = ls_codigo
			this.object.desc_certificacion	[al_row] = ls_data
			of_get_pptt(al_Row)
			this.ii_update = 1
		end if

	case "tipo_funda"
		ls_sql = "SELECT tipo_funda AS tipo_funda, " &
				  + "desc_tipo_funda AS descripcion_tipo_funda " &
				  + "FROM ap_tipo_funda " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "order by tipo_funda"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_funda		[al_row] = ls_codigo
			this.object.desc_tipo_funda[al_row] = ls_data
			of_get_pptt(al_Row)
			this.ii_update = 1
		end if

	case "centro_benef"

		ls_sql = "SELECT cb.centro_benef AS centro_beneficio, " &
				  + "cb.desc_centro as descripcion_centro_beneficio " &
				  + "FROM centro_beneficio cb " &
				  + "where cb.flag_estado = '1' " &
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo
			this.object.desc_centro_benef	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "importador"

		ls_sql = "SELECT p.proveedor AS codigo_importador, " &
				  + "p.nom_proveedor as nombre_importador, " &
				  + "p.nro_doc_ident as dni_importador, " &
				  + "p.ruc as ruc_importador " &
				  + "FROM proveedor p " &
				  + "where p.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.importador		[al_row] = ls_codigo
			this.object.nom_importador	[al_row] = ls_data
			this.ii_update = 1
		end if		
	
	case "almacen_mp"

		ls_sql = "SELECT a.almacen AS codigo_almacen, " &
				  + "a.desc_almacen as descripcion_almacen " &
				  + "FROM almacen a " &
				  + "where a.flag_estado = '1' " &
				  + "  and a.flag_tipo_almacen = 'P'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen_mp			[al_row] = ls_codigo
			this.object.desc_almacen_mp	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
	case "almacen_pptt"

		ls_sql = "SELECT a.almacen AS codigo_almacen, " &
				  + "a.desc_almacen as descripcion_almacen " &
				  + "FROM almacen a " &
				  + "where a.flag_estado = '1' " &
				  + "  and a.flag_tipo_almacen = 'T'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen_pptt		[al_row] = ls_codigo
			this.object.desc_almacen_pptt	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "moneda"

		ls_sql = "SELECT e.cod_moneda  AS codigo_moneda, " &
				  + "e.descripcion as descripcion_moneda " &
				  + "FROM moneda e " &
				  + "where e.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if	
		
	case "especie"
		
		ls_productor = this.object.productor[al_row]
		
		if IsNull(ls_productor) or ls_productor = '' then
			MessageBox('Error', 'Primero debe ingresar un codigo de productor')
			this.setColumn('productor')
			return
		end if
		
		ld_fecha = date(dw_master.object.fec_parte[dw_master.getRow()])
		
		ls_sql = "SELECT distinct e.especie  AS codigo_especie, " &
				  + "		  e.descr_especie as descripcion_especie, " &
				  + "		  p.peso_ratio as ratio " &
				  + "FROM tg_especies e, " &
				  + "     ap_prov_mp_tarifa p " &
				  + "where e.especie = p.especie " &
				  + "  and e.flag_estado = '1' " &
				  + "  and p.proveedor = '" + ls_productor + "' " &
				  + "  and to_date('" + string(ld_fecha, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') between trunc(p.fecha_inicio) and trunc(p.fecha_fin)"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			if of_get_precio(ls_productor, ls_codigo, al_row) then
				this.object.especie			[al_row] = ls_codigo
				this.object.desc_especie	[al_row] = ls_data
				this.ii_update = 1
			end if
		end if		

	case "cod_art_pptt"
		
		String ls_certificacion, ls_tipo_caja, ls_tipo_funda
		
		ls_certificacion 	= this.object.tipo_certificacion [al_Row]
		ls_tipo_caja 		= this.object.tipo_caja 			[al_Row]
		ls_tipo_funda 		= this.object.tipo_funda 			[al_Row]
		
		if IsNull(ls_certificacion) or ls_certificacion = '' then
			MessageBox('Error', 'Primero debe ingresar un Tipo de Certificacion, por favor verifique')
			this.setColumn('ls_certificacion')
			return
		end if
		
		if IsNull(ls_tipo_caja) or ls_tipo_caja = '' then
			MessageBox('Error', 'Primero debe ingresar un Tipo de Caja, por favor verifique')
			this.setColumn('ls_tipo_caja')
			return
		end if

		if IsNull(ls_tipo_funda) or ls_tipo_funda = '' then
			MessageBox('Error', 'Primero debe ingresar un Tipo de Funda, por favor verifique')
			this.setColumn('ls_tipo_funda')
			return
		end if

		ls_sql = "SELECT distinct e.especie  AS codigo_especie, " &
				  + "		  e.descr_especie as descripcion_especie " &
				  + "FROM articulo a, " &
				  + "     ap_tipo_certificacion_det b " &
				  + "where a.cod_art = b.cod_art_pptt " &
				  + "  and a.flag_estado = '1' " &
				  + "  and b.tipo_certificacion = '" + ls_certificacion + "' " &
				  + "  and b.tipo_Caja = '" + ls_tipo_caja + "' " &
				  + "  and b.tipo_funda = '" + ls_tipo_funda + "' " 
				  
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_art_ptt	[al_row] = ls_codigo
			this.object.desc_Art		[al_row] = ls_data
			this.ii_update = 1
		end if		

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2, ls_productor, ls_especie, &
			ls_labor, ls_nro_ot
Long 		ll_count
Date		ld_fecha
decimal	ldc_peso_ratio, ldc_peso_Caja, ldc_precio_unit

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	case "almacen_mp"
		// Verifica que codigo ingresado exista			
		Select a.desc_almacen
			into :ls_desc1
	  	FROM almacen a
		where a.flag_estado = '1' 
		  and a.flag_tipo_Almacen = 'P'
		  and a.almacen   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Almacén, no se encuentra activo o no es de materia prima, por favor verifique")
			this.object.almacen_mp			[row] = ls_null
			this.object.desc_almacen_mp	[row] = ls_null
			return 1
			
		end if

		this.object.desc_almacen_mp		[row] = ls_desc1

	case "oper_sec"
		ls_labor = dw_master.object.cod_labor [dw_master.getRow()]
		
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Error', 'Debe definir primero una labor')
			dw_master.setFocus()
			dw_master.setColumn("cod_labor")
			return
		end if
		
		ls_nro_ot = dw_master.object.nro_orden [dw_master.getRow()]
		
		if ls_nro_ot = '' or IsNull(ls_nro_ot) then
			MessageBox('Error', 'Debe definir primero una OT')
			dw_master.setFocus()
			dw_master.setColumn("nro_orden")
			return
		end if
		// Verifica que codigo ingresado exista			
		Select op.desc_operacion
			into :ls_desc1
	  	FROM operaciones op
		where op.flag_estado = '1' 
		  and op.oper_sec = :data
		  and op.nro_orden = :ls_nro_ot
		  and op.cod_labor = :ls_labor;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Oper_sec, no se encuentra activo o no es aprobado, por favor verifique")
			this.object.oper_sec			[row] = ls_null
			return 1
			
		end if
		
	case "almacen_pptt"
		// Verifica que codigo ingresado exista			
		Select a.desc_almacen
			into :ls_desc1
	  	FROM almacen a
		where a.flag_estado = '1' 
		  and a.flag_tipo_Almacen = 'T'
		  and a.almacen   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Almacén, no se encuentra activo o no es de Producto Terminado, por favor verifique")
			this.object.almacen_pptt		[row] = ls_null
			this.object.desc_almacen_pptt	[row] = ls_null
			return 1
			
		end if

		this.object.desc_almacen_pptt		[row] = ls_desc1
		
	case "importador"
		// Verifica que codigo ingresado exista			
		Select p.nom_proveedor
			into :ls_desc1
	  	FROM proveedor		  p 
		where p.flag_estado  = '1' 
		  and p.proveedor   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Importador o no se encuentra activo, por favor verifique")
			this.object.importador		[row] = ls_null
			this.object.nom_importador	[row] = ls_null
			return 1
		end if

		this.object.nom_importador	[row] = ls_desc1
		
	case "especie"
		
		ls_productor = this.object.productor[row]
		
		if IsNull(ls_productor) or ls_productor = '' then
			MessageBox('Error', 'Primero debe ingresar un codigo de productor')
			this.setColumn('productor')
			return
		end if
		
		ld_fecha = date(dw_master.object.fec_parte[dw_master.getRow()])
		
		// Verifica que codigo ingresado exista			
		Select p.descr_especie
			into :ls_desc1
	  	FROM tg_especies  p 
		where p.flag_estado  = '1' 
		  and p.especie   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Especie o no se encuentra activo, por favor verifique")
			this.object.especie			[row] = ls_null
			this.object.desc_especie	[row] = ls_null
			return 1
		end if

		if of_get_precio(ls_productor, data, row) then
			this.object.desc_especie	[row] = ls_desc1
		end if

	case "peso_cajas"
		ls_productor = this.object.productor[row]
		
		if IsNull(ls_productor) or ls_productor = '' then
			MessageBox('Error', 'Primero debe ingresar un codigo de productor')
			this.setColumn('productor')
			return
		end if
		
		ls_especie = this.object.especie[row]
		
		if IsNull(ls_especie) or ls_especie = '' then
			MessageBox('Error', 'Primero debe ingresar un codigo de Materia prima')
			this.setColumn('especie')
			return
		end if
		
		of_get_precio(ls_productor, ls_especie, row)
		
		ldc_peso_ratio = dec(this.object.peso_Ratio [row])
		
		if ldc_peso_ratio = 0 then
			MessageBox('Error', 'Debe especificar un ratio del peso para la caja desde la tarifa del proveedor')
			this.object.peso_cajas [row] = 0
			return 1
		end if
		
		ldc_precio_unit = dec(this.object.precio_unit [row])
		if ldc_precio_unit = 0 then
			MessageBox('Error', 'Debe especificar un precio unitario')
			this.setColumn("precio_unit")
			this.object.precio_unit [row] = 0
			return 1
		end if
		
		ldc_peso_caja = dec(data)
		
		ldc_precio_unit = ldc_precio_unit * ldc_peso_caja / ldc_peso_Ratio
		this.object.precio_unit [row] = ldc_precio_unit
		
		
	case "moneda"

		// Verifica que codigo ingresado exista			
		Select p.descripcion
			into :ls_desc1
	  	FROM moneda  p 
		where p.flag_estado  = '1' 
		  and p.cod_moneda   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Moneda o no se encuentra activo, por favor verifique")
			this.object.cod_moneda			[row] = ls_null
			return 1
		end if
		
	case "tipo_caja"
		// Verifica que codigo ingresado exista			
		Select p.desc_tipo_caja
			into :ls_desc1
	  	FROM ap_tipo_caja  p 
		where p.flag_estado  = '1' 
		  and p.tipo_caja   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Caja o no se encuentra activo, por favor verifique")
			this.object.tipo_caja			[row] = ls_null
			this.object.desc_tipo_caja		[row] = ls_null
			return 1
		end if
		
		of_get_pptt(row)
		this.object.desc_tipo_caja		[row] = ls_desc1
		
	case "tipo_certificacion"
		// Verifica que codigo ingresado exista			
		Select p.desc_certificacion
			into :ls_desc1
	  	FROM ap_tipo_certificacion  p 
		where p.flag_estado  = '1' 
		  and p.tipo_certificacion   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Certificacion o no se encuentra activo, por favor verifique")
			this.object.tipo_certificacion	[row] = ls_null
			this.object.desc_certificacion	[row] = ls_null
			return 1
		end if
		
		of_get_pptt(row)
		this.object.desc_certificacion[row] = ls_desc1

	case "tipo_funda"
		// Verifica que codigo ingresado exista			
		Select p.desc_tipo_funda
			into :ls_desc1
	  	FROM ap_tipo_funda  p 
		where p.flag_estado  = '1' 
		  and p.tipo_funda   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Funda o no se encuentra activo, por favor verifique")
			this.object.tipo_funda			[row] = ls_null
			this.object.desc_tipo_funda	[row] = ls_null
			return 1
		end if
		
		of_get_pptt(row)
		this.object.desc_tipo_funda	[row] = ls_desc1

	case "centro_benef"
		// Verifica que codigo ingresado exista			
		Select p.desc_centro
			into :ls_desc1
	  	FROM centro_beneficio  p 
		where p.flag_estado  = '1' 
		  and p.centro_benef = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Funda o no se encuentra activo, por favor verifique")
			this.object.centro_benef		[row] = ls_null
			this.object.desc_centro_benef	[row] = ls_null
			return 1
		end if
		
		this.object.desc_centro_benef	[row] = ls_desc1
		
end choose


end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2569
integer height = 856
long backcolor = 79741120
string text = "Transporte de Caja"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_transporte dw_transporte
end type

on tabpage_3.create
this.dw_transporte=create dw_transporte
this.Control[]={this.dw_transporte}
end on

on tabpage_3.destroy
destroy(this.dw_transporte)
end on

type dw_transporte from u_dw_abc within tabpage_3
integer width = 2514
integer height = 1156
integer taborder = 20
string dataobject = "d_abc_transporte_cajas_tbl"
boolean hsplitscroll = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master


ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

idw_mst  = 	idw_control
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

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_parte			[al_row] = idw_mst.object.nro_parte				[idw_mst.getRow()]
this.object.nro_certificacion	[al_row] = idw_mst.object.nro_certificacion	[idw_mst.getRow()]
this.object.nro_item 			[al_row] = of_nro_item(this)


this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.fec_transporte	[al_row] = Date(dw_master.object.fec_parte[dw_master.getRow()])
this.object.cod_usr			[al_row] = gs_user


end event

event ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_proveedor, ls_ruc, ls_nro_placa, &
			ls_nom_chofer, ls_vehiculo, ls_marca, ls_modelo

choose case lower(as_columna)
	case "prov_transp"
		ls_sql = "select p.proveedor as codigo_proveedor, " & 
				 + "p.nom_proveedor as razon_social, " &
				 + "p.ruc as ruc_proveedor, " &
				 + "atu.nro_placa as numero_placa, " &
				 + "atu.nom_chofer as nombre_Chofer, " &
				 + "atu.vehiculo as vehiculo, " &
				 + "atu.marca as marca, " &
				 + "atu.modelo as modelo " &
				 + "from ap_transp_prov atp, " &
				 + "     proveedor      p, " &
				 + "     ap_transp_unid atu " &
				 + "where atp.proveedor = p.proveedor " &
				 + "  and atp.proveedor = atu.proveedor (+)   " &
				 + "  and p.FLAG_ESTADO = '1'"

		lb_ret = f_lista_8ret(ls_sql, ls_codigo, ls_data, ls_ruc, ls_nro_placa, &
					ls_nom_chofer, ls_vehiculo, ls_marca, ls_modelo, '2')

		if ls_codigo <> '' then
			this.object.prov_transp		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			
			this.object.nro_placa	[al_row] = ls_nro_placa
			this.object.nom_chofer	[al_row] = ls_nom_chofer
			this.object.marca			[al_row] = ls_marca
			this.object.vehiculo		[al_row] = ls_vehiculo
			
			this.ii_update = 1
		end if
		
	case "cod_ruta"
		
		ls_proveedor = this.object.prov_transp [al_row] 
		if ISNull(ls_proveedor) or ls_proveedor = "" then
			MessageBox('Error', 'Debe Especificar un proveedor de transporte primero, por favor verifique')
			this.setColumn("prov_transp")
			return
		end if
		
		ls_sql = "select a1.cod_ruta as codigo_ruta, " &
				 + "a1.desc_ruta as descripcion_ruta " &
				 + "from ap_rutas_mp a1, " &
				 + "     ap_transp_ruta a2 " &
				 + "where a1.cod_ruta = a2.cod_ruta " &
				 + "  and a1.FLAG_ESTADO = '1' " &
				 + "  and a2.proveedor = '" + ls_proveedor + "' " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			if of_get_precio_transp(ls_proveedor, ls_codigo, al_Row) then
				this.object.cod_ruta		[al_row] = ls_codigo
				this.ii_update = 1
			end if
		end if

	case "moneda"

		ls_sql = "SELECT e.cod_moneda  AS codigo_moneda, " &
				  + "e.descripcion as descripcion_moneda " &
				  + "FROM moneda e " &
				  + "where e.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if	
		

end choose
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
end event

