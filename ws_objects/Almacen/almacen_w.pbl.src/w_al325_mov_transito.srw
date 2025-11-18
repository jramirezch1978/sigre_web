$PBExportHeader$w_al325_mov_transito.srw
forward
global type w_al325_mov_transito from w_abc
end type
type sle_nro from u_sle_codigo within w_al325_mov_transito
end type
type em_saldo_und2 from singlelineedit within w_al325_mov_transito
end type
type em_saldo from singlelineedit within w_al325_mov_transito
end type
type st_4 from statictext within w_al325_mov_transito
end type
type cb_1 from commandbutton within w_al325_mov_transito
end type
type st_nro from statictext within w_al325_mov_transito
end type
type st_1 from statictext within w_al325_mov_transito
end type
type dw_detail from u_dw_abc within w_al325_mov_transito
end type
type dw_master from u_dw_abc within w_al325_mov_transito
end type
type gb_1 from groupbox within w_al325_mov_transito
end type
end forward

global type w_al325_mov_transito from w_abc
integer width = 5330
integer height = 2316
string title = "Movimientos en tránsito (AL325)"
string menuname = "m_mov_almacen"
boolean minbox = false
windowstate windowstate = maximized!
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
sle_nro sle_nro
em_saldo_und2 em_saldo_und2
em_saldo em_saldo
st_4 st_4
cb_1 cb_1
st_nro st_nro
st_1 st_1
dw_detail dw_detail
dw_master dw_master
gb_1 gb_1
end type
global w_al325_mov_transito w_al325_mov_transito

type variables
// Tipos de movimiento
String 	is_soles, is_dolares, is_rep_merc_dev, is_salir = 'N', &
			is_doc_int, is_doc_ext, is_flag_und2, &
			is_solicita_ref, is_clase_mov, is_doc_ov, &
			is_doc_otr, is_cntrl_lote_art, is_cntrl_lote_alm, &
			is_oper_ing_oc, is_oper_ing_cdir, &
			is_oper_ing_prod, is_doc_oc, is_cnta_prsp_vta, &
			is_oper_vnta_terc, is_oper_cons_interno, &
			is_doc_grmp

Int 			ii_cerrado 
DateTime		id_fecha_proc
Decimal 		idc_cant_proy, idc_cant_proc, &
				idc_cant_fact, idc_cant_proc_und2
Long 			il_dias_holgura, il_factor_lote, il_fac_total
Boolean 		ib_control_lin = TRUE, ib_mod = false

dataStore 				ids_print
n_cst_contabilidad 	invo_cntbl
end variables

forward prototypes
public function integer of_get_datos ()
public function integer of_get_param ()
public function integer of_set_articulo (string as_articulo, string as_almacen)
public function integer of_evalua_saldos (integer al_row)
public function integer of_set_status_doc (datawindow idw)
public function integer of_set_numera ()
public function integer of_tipo_mov (string as_tipo_mov)
public function integer of_evalua_saldos_und2 (integer al_row)
public subroutine of_saldos_articulo (long al_row)
public function integer of_solicita_lote (string as_almacen, string as_cod_art)
public subroutine of_duplica_mov_art (long al_row)
public subroutine of_retrieve (string as_nro)
public subroutine of_referencia_mov (string as_tipo_mov)
public function integer of_nro_item (datawindow adw_1)
end prototypes

event ue_anular;Integer 	j
Long 		ll_row, ll_count
String 	ls_alm, ls_tipo_ref, ls_nro_ref, ls_nro_vale
Decimal	ldc_cant_pro_am

if is_action = 'new' or is_action='edit' then
	MessageBox('Aviso', 'No puede anular este movimiento de almacen, debe grabarlo primero')
	return
end if

IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No se puede anular este movimiento de almacen')
	return
end if

ls_nro_vale 	= dw_master.object.nro_vale 	[dw_master.GetRow()]

if ls_nro_vale = '' or IsNull(ls_nro_vale) then
	MessageBox('Aviso', 'El nro de vale no esta definido o esta en blanco, verifique ')
	return
end if

//Verifico que no tenga cant_proc_am
select NVL(sum(cant_proc_am),0)
	into :ldc_cant_pro_am
from vale_mov_trans_det
where nro_vale = :ls_nro_vale;

if ldc_cant_pro_am > 0 then
	MessageBox('Aviso', 'No se puede anular documento porque ya tiene movimiento de almacén')
	return
end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Lee detalle
ll_row = dw_master.getrow()
of_retrieve( ls_nro_vale )

// Anulando Cabecera
dw_master.object.flag_estado[ll_row] = '0'
dw_master.ii_update = 1

// Anulando Detalle
for j = 1 to dw_detail.rowCount()	
	dw_detail.object.flag_estado		[j] = '0'
	dw_detail.object.cant_procesada	[j] = 0
next
dw_detail.ii_update = 1
is_action = 'anu'
of_set_status_doc(dw_master)
end event

event ue_cancelar;// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_nro.text = ''
sle_nro.SetFocus()
idw_1 = dw_master

is_Action = ''
of_set_status_doc(dw_master)

end event

event ue_preview();// vista previa de mov. almacen
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_frm_movimiento_transito'
lstr_rep.titulo 	= 'Previo de Movimiento de almacen'
lstr_rep.string1 	= dw_master.object.nro_vale[dw_master.getrow()]
lstr_rep.tipo	 	= '1S'
OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

public function integer of_get_datos ();// Verifica que los datos que son requeridos via flag, esten ingresados
// Evalua datos
String ls_tipo_mov, ls_prov, ls_doc_int, ls_doc_ext, ls_doc_ref, ls_cod_art, ls_almacen, &
 		 ls_consig
Long ll_row
Int j
Double ld_saldo
dwobject dwo_1


if is_action <> 'new' then return 1

ll_row = dw_master.getrow()
ls_tipo_mov = dw_master.object.tipo_mov[ll_row]

// Activa/desactiva boton de referencias segun tipo de movimiento
Select flag_solicita_prov, flag_solicita_doc_int, flag_solicita_doc_ext, flag_solicita_ref
   into :ls_prov, :ls_doc_int, :ls_doc_ext, :ls_doc_ref 
from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov;

if isnull(dw_master.object.almacen[dw_master.getrow()]) then
	Messagebox( "Atencion", "Ingrese el almacen")
	dw_master.setcolumn( "almacen")
	dw_master.setfocus()	
	return 0
end if

ls_almacen = dw_master.object.almacen[ll_row]

if isnull(dw_master.object.tipo_mov[ll_row]) then
	Messagebox( "Atencion", "Ingrese tipo movimiento")
	dw_master.setcolumn( "tipo_mov")
	dw_master.setfocus()
	return 0
end if

if ls_doc_ext = '1' then
	if isnull(dw_master.object.tipo_doc_ext[ll_row]) then
		messagebox( "Atencion", "Indicar tipo doc. externo")
		dw_master.Setcolumn("tipo_doc_ext")
		dw_master.setfocus()
		Return 0
	end if
	if isnull(dw_master.object.nro_doc_ext[ll_row]) then
		messagebox( "Atencion", "Indicar nro. doc. externo")
		dw_master.Setcolumn("nro_doc_ext")
		dw_master.setfocus()
		Return 0
	end if
end if

//if ls_prov = '1' then
//	if isnull(dw_master.object.prov_transporte[ll_row]) or TRIM( dw_master.object.prov_transporte[ll_row]) = '' then
//		messagebox( "Atencion", "Indicar proveedor")
//		dw_master.Setcolumn("prov_transporte")
//		dw_master.setfocus()
//		Return 0
//	end if
//end if

return 1
end function

public function integer of_get_param ();// Evalua parametros
Int li_ret = 1

// busca tipos de movimiento definidos
SELECT cod_soles, rep_merc_dev, cod_dolares, NVL(dias_holgura_mat,0),
		 doc_otr, oper_ing_oc, oper_ing_cdir, oper_ing_prod,
		 oper_vnta_terc, oper_cons_interno, doc_ov
  INTO :is_soles, :is_rep_merc_dev, :is_dolares, :il_dias_holgura, 
		 :is_doc_otr, :is_oper_ing_oc, :is_oper_ing_cdir, :is_oper_ing_prod,
		 :is_oper_vnta_terc, :is_oper_cons_interno, :is_doc_ov
FROM logparam  
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return 0
end if

if sqlca.sqlcode < 0 then
	Messagebox( "Error en busqueda parametros", sqlca.sqlerrtext)
	return 0	
end if

// busca moneda soles
if ISNULL( is_soles) or TRIM( is_soles) = '' then
	Messagebox("Error de parametros", "Defina codigo moneda soles en logparam")
	return 0
end if

// busca moneda dolares
if ISNULL( is_dolares) or TRIM( is_dolares) = '' then
	Messagebox("Error de parametros", "Defina codigo moneda dólares en logparam")
	return 0
end if

if ISNULL( is_rep_merc_dev) or TRIM( is_rep_merc_dev) = '' then
	Messagebox("Error de parametros", "Defina codigo (rep_merc_dev) en logparam")
	return 0
end if

if ISNULL( is_doc_otr ) or TRIM( is_doc_otr ) = '' then
	Messagebox("Error de parametros", "Defina DOCUMENTO DE ORDEN DE TRASLADO en logparam")
	return 0
end if

if ISNULL( is_doc_ov ) or TRIM( is_doc_ov ) = '' then
	Messagebox("Error de parametros", "Defina DOCUMENTO DE ORDEN DE VENTA en logparam")
	return 0
end if

if ISNULL( is_oper_ing_oc ) or TRIM( is_oper_ing_oc ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION INGRESO X COMPRA (oper_ing_oc) en logparam")
	return 0
end if

if ISNULL( is_oper_ing_cdir ) or TRIM( is_oper_ing_cdir ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION INGRESO COMPRA DIRECTA en logparam")
	return 0
end if

if ISNULL( is_oper_ing_prod ) or TRIM( is_oper_ing_prod ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION INGRESO X PRODUCCION en logparam")
	return 0
end if

if ISNULL( is_oper_vnta_terc ) or TRIM( is_oper_vnta_terc ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION VENTA A TERCEROS en logparam")
	return 0
end if

if ISNULL( is_oper_cons_interno ) or TRIM( is_oper_cons_interno ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION CONSUMO INTERNO en logparam")
	return 0
end if

// Guia de recepcion de materia prima
is_doc_grmp = 'GRMP'

return 1

end function

public function integer of_set_articulo (string as_articulo, string as_almacen);String 	ls_unidad, ls_desc_art, ls_und, ls_tipo_mov, ls_flag_und2, &
			ls_msg, ls_und2, ls_tipo_mon, ls_cnta_prsp_vta, ls_almacen
Decimal{4} 	ldc_prom_sol, ldc_saldo_total = 0, ldc_saldo_total_und2, &
			ldc_fac_conv, ldc_tipo_cambio, ldc_costo_prod, ldc_prom_dol
Integer	li_fac_total
Long 		ll_row

if dw_master.GetRow() = 0 then 
	MessageBox('Aviso', 'No exiet cabecera de movimiento de almacen')
	return 0
end if

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.GetRow()]

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento esta en blanco')
	return 0
end if

// Verifica que codigo ingresado exista			
Select 	desc_art, und, Nvl(flag_und2,'0'), und2, NVL(factor_conv_und, 0)
	into 	:ls_desc_art, :ls_und, :ls_flag_und2, :ls_und2,:ldc_fac_conv
from articulo 
Where cod_art = :as_articulo;

if Sqlca.sqlcode = 100 then 
	ROLLBACK;
	Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
		+ "' no existe", StopSign!)
	Return 0
end if		

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_msg)
	return 0
end if

ls_almacen = dw_master.object.almacen[dw_master.GetRow()]

select Nvl(costo_prom_sol,0), NVL(costo_prom_dol,0)
	into :ldc_prom_sol, :ldc_prom_dol
from articulo_almacen
where cod_art = :as_articulo
  and almacen = :ls_almacen;

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_msg)
	return 0
end if

if Sqlca.sqlcode = 100 then 
	// Si es una salida debe salir 
	if il_fac_total = -1 then
		ROLLBACK;
		Messagebox( "Atencion ARTICULO_ALMACEN", "Codigo de articulo: '" + as_articulo &
			+ " no existe", StopSign!)
		return 0
	end if
end if		

//if ldc_prom_sol = 0 then
//	select Nvl(costo_prom_sol,0), NVL(costo_prom_dol,0)
//		into :ldc_prom_sol, :ldc_prom_dol
//	from articulo
//	where cod_art = :as_articulo;
//	
//	if Sqlca.sqlcode = 100 then 
//		ROLLBACK;
//		Messagebox( "Atencion ARTICULO", "Codigo de articulo: '" + as_articulo &
//			+ " no existe", StopSign!)
//		Return 0
//	end if		
//	
//	if SQLCA.SQLCode < 0 then
//		ls_msg = SQLCA.SQLErrText
//		ROLLBACK;
//		MessageBox('Aviso', ls_msg)
//		return 0
//	end if
//end if

if ls_flag_und2 = '1' and ldc_fac_conv = 0 then
	MessageBox('Aviso', 'Ese articulo maneja una Segunda Unidad, necesita ' &
		+ 'un factor un factor de conversion entre ambas unidades ')
	return 0
end if


SELECT Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	INTO   :ldc_saldo_total, :ldc_saldo_total_und2
FROM  articulo_almacen
WHERE almacen = :as_almacen 
  AND cod_art = :as_articulo ; 		
		
if SQLCA.SQLCode = 100 then
	//Solo valida si es una salida
	if li_fac_total = -1 then
		MessageBox('Aviso', 'No existe Articulo '+ as_articulo + 'en almacen indicado', StopSign!)
		return 0
	end if
end if

ll_row = dw_detail.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'Error, no existe ninguna fila en el detalle')
	return 0
end if
if ls_flag_und2 = '0' then SetNull(ls_flag_und2)

dw_detail.object.desc_Art	 		[ll_row] = ls_desc_art
dw_detail.object.und					[ll_row] = ls_und	
dw_detail.object.und2				[ll_row] = ls_und2	
dw_detail.object.precio_unit		[ll_row] = ldc_prom_sol
dw_detail.object.flag_und2			[ll_row] = ls_flag_und2
dw_detail.object.factor_conv_und	[ll_row] = ldc_fac_conv


em_saldo.text 	    = String( ldc_saldo_total, '###,##0.0000' ) 
em_saldo_und2.text = String( ldc_saldo_total_und2, '###,##0.0000' ) 


return 1
end function

public function integer of_evalua_saldos (integer al_row);String 	ls_cod_art, ls_almacen
Decimal  ld_cant_dig, ld_saldo_act

ls_almacen  = dw_master.object.almacen[dw_master.getrow()]

dw_detail.AcceptText()


ls_cod_art   = dw_detail.object.cod_art			[al_row]
ld_cant_dig  = dw_detail.object.cant_procesada	[al_row]	
	
// Que cantidad no sea cero
if dw_detail.object.cant_procesada[al_row] = 0 then
	Messagebox( "Atencion", "Cantidad no puede ser cero")
	dw_detail.SetColumn( "Cant_procesada")
	dw_detail.setFocus()
	return 0
end if
	
// Salidas
IF il_fac_total = -1 then			
	// Verifica saldos
	SELECT Nvl(sldo_total,0)
			INTO   :ld_saldo_act
	FROM   articulo_almacen
	WHERE  almacen = :ls_almacen 
	  AND cod_art = :ls_cod_Art; 
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El articulo no existe en almacen')
		return 0
	end if
	
	if ld_saldo_act = 0 then
		MessageBox('Aviso', 'El articulo no tiene saldo en almacen')
		return 0
	end if
	
	IF ld_cant_dig > ld_saldo_act THEN
		Messagebox('Aviso','Cantidad a Procesar No Puede Exceder al Saldo Actual~r~nSaldo Actual: ' + &
	 	String (ld_saldo_act,'#0.0000'), exclamation!)
		dw_detail.object.cant_procesada[al_row] = ld_saldo_act
		Return 0
	END IF		
End if

return 1
end function

public function integer of_set_status_doc (datawindow idw);Int li_estado
long ll_ref

this.changemenu( m_mov_almacen)

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if

m_master.m_file.m_printer.m_print1.enabled 			= true

if dw_master.getrow() = 0 then return 0

if ii_cerrado = 0	then // cerrado contablemente
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	if idw_1 = dw_detail then		
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if	
	return 0
end if

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	if is_flag_insertar = '1' then
		m_master.m_file.m_basedatos.m_insertar.enabled = true
	else
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if

	if idw_1 = dw_detail then
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if

		IF is_solicita_ref <> '0' then			
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		else
			if is_flag_insertar = '1' then
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			else
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if
		end if
	end if
end if

if is_Action = 'open' then
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
	
	Choose case li_estado
		case 0 	// Anulado 
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			m_master.m_file.m_basedatos.m_anular.enabled 		= false	
			if idw_1 = dw_master then		
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			ELSE			
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if	
			RETURN 1
		CASE is > 1   // Atendido con guia de remision
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled = false
			m_master.m_file.m_basedatos.m_anular.enabled = false
			if idw_1 = dw_master then		
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			ELSE
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if	
			RETURN 1
	end CHOOSE
end if

if idw_1 = dw_detail and is_solicita_ref = '0' then	
	m_master.m_file.m_basedatos.m_insertar.enabled = true		
end if

if is_Action = 'anu' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if

return 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_vale_mov_trans
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_vale_mov_trans IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_vale_mov_trans(origen, ult_nro)
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
	FROM num_vale_mov_trans
	where origen = :gs_origen for update;
	
	update num_vale_mov_trans
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_vale[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_vale[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_vale[ll_j] = ls_next_nro
next

return 1
end function

public function integer of_tipo_mov (string as_tipo_mov);/* 
  Funcion que activa/desactiva campos segun tipo de movimiento
*/

String 	ls_alm, ls_null, ls_flag_estado
Long 		ll_row, ln_count,	ll_saldo_pres, ll_saldo_dev, ll_saldo_consig

ll_row = dw_master.getrow()
if ll_row = 0 then
	MessageBox('Aviso', 'No ha definido cabecera del documento', StopSign!)
	return 0
end if

SetNull(ls_null)
// Tipo de Almacen
ls_alm = dw_master.object.almacen[ll_row]

// Busca indicadores segun tipo de movimiento

Select NVL(flag_solicita_doc_int,'0'), 
	    Nvl(flag_solicita_doc_ext,'0'),	NVL(flag_solicita_ref,'0'), 
		 NVL(factor_ctrl_templa,0), 		NVL(flag_clase_mov, ''),
		 NVL(flag_estado, '0'),				NVL(factor_sldo_consig, 0),
		 NVL(factor_sldo_dev,0),			NVL(factor_sldo_pres, 0),
		 NVL(factor_sldo_total,0)
	into 	:is_doc_int, 
			:is_doc_ext, 						:is_solicita_ref, 
			:il_factor_lote, 					:is_clase_mov,
			:ls_flag_estado,					:ll_saldo_consig,
			:ll_saldo_dev,						:ll_saldo_pres,
			:il_fac_total
from articulo_mov_tipo 
where tipo_mov = :as_tipo_mov
  and flag_estado = '1';	

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Tipo de Movimiento: ' + as_tipo_mov + ' no existe o no esta activo', StopSign!)
	return 0
end if

if SQLCA.SQLCode < 0 then
	MessageBox('Aviso', SQLCA.SQlErrText, StopSign!)
	return 0
end if

if ls_flag_estado = '0' then
	MessageBox('Aviso', 'Tipo de movimiento esta inactivo')
	return 0
end if

//Tengo que validar que no sea por consignacion, devolucion ni prestamo
if ll_saldo_consig <> 0 and is_action = 'new' then
	MessageBox('Aviso', 'No esta permitido movimientos de consignacion')
	return 0
end if

if ll_saldo_pres <> 0 and is_action = 'new' then
	MessageBox('Aviso', 'No esta permitido movimientos de prestamo')
	return 0
end if

if ll_saldo_dev <> 0 and is_action = 'new' then
	MessageBox('Aviso', 'No esta permitido movimientos de devolucion')
	return 0
end if

//Activar solicitar proveedor solo si es una Salida nada mas
if il_fac_total = 1 then
	dw_master.object.prov_transporte.background.color = RGB(192,192,192)   
	dw_master.object.prov_transporte.protect = 1
	dw_master.object.prov_transporte.edit.required = 'no'
else
	dw_master.object.prov_transporte.background.color = RGB(255,255,255)
	dw_master.object.prov_transporte.protect = 0
	dw_master.object.prov_transporte.edit.required = 'Yes'
end if		


// Flag Solicita Documento Interno
if is_doc_int = '0' then			
	dw_master.object.tipo_doc_int.background.color = RGB(192,192,192)
	dw_master.object.nro_doc_int.background.color = RGB(192,192,192)
	dw_master.object.tipo_doc_int.protect 	= 1
	dw_master.object.nro_doc_int.protect 	= 1
	dw_master.object.tipo_doc_int.edit.required = 'no'
	dw_master.object.nro_doc_int.edit.required = 'no'
else		
	dw_master.object.tipo_doc_int.background.color = RGB(255,255,255)
	dw_master.object.nro_doc_int.background.color = RGB(255,255,255)
	dw_master.object.tipo_doc_int.protect = 0
	dw_master.object.nro_doc_int.protect = 0
	dw_master.object.tipo_doc_int.edit.required = 'Yes'
	dw_master.object.tipo_doc_ext.edit.required = 'Yes'
end if

//Flag Solicita Doc Externo
if is_doc_ext = '0' then
	dw_master.object.tipo_doc_ext.background.color = RGB(192,192,192)
	dw_master.object.nro_doc_ext.background.color = RGB(192,192,192)
	dw_master.object.tipo_doc_ext.protect = 1
	dw_master.object.nro_doc_ext.protect = 1
	dw_master.object.tipo_doc_ext.edit.required = 'no'
	dw_master.object.nro_doc_ext.edit.required = 'no'
else
	dw_master.object.tipo_doc_ext.background.color = RGB(255,255,255)
	dw_master.object.nro_doc_ext.background.color = RGB(255,255,255)
	dw_master.object.tipo_doc_ext.protect = 0
	dw_master.object.nro_doc_ext.protect = 0
	dw_master.object.tipo_doc_ext.edit.required = 'Yes'
	dw_master.object.nro_doc_ext.edit.required = 'Yes'
end if




//Si el documento es nuevo o se esta editando o se esta anulando
if is_action = 'new' or is_action = 'edit' or is_action = 'anu' then	
	
	// Valida si existe el tipo para el almacen
	Select count(tipo_mov) 
		into :ln_count 
	from almacen_tipo_mov
	where tipo_mov = :as_tipo_mov 
	  and almacen 	= :ls_alm;
	  
	if ln_count = 0 then
		Messagebox( "Atencion", "tipo de movimiento no existe para este almacen", exclamation!)		
		return 0
	end if	
	
	// Verifico si pide referencia, si es ingreso x compras, 
	// salida x consumo interno, Salida x venta, Orden de Traslado
	// Guia de REcepcion de Materia Prima
	if is_solicita_ref <> '0' or il_fac_total = -1 then	
		if (is_clase_mov = '' or IsNull(is_clase_mov)) and il_fac_total = 1 then
			MessageBox('Aviso', 'No ha definido tipo de referencia para el tipo ' &
					+ 'de movimiento')
			return 0
		end if
		of_referencia_mov(as_tipo_mov)
	end if	
end if
dw_master.setfocus()
return 1
end function

public function integer of_evalua_saldos_und2 (integer al_row);String 	ls_tipo_mov, ls_cod_art, ls_almacen, ls_origen, ls_flag_und2
Int 		li_sldo_total, li_sldo_llegar, li_sldo_sol
Long 		ln_nro_mov_proy, ll_nro_mov  
Decimal{2} ld_cant, ld_cant_dig, ld_saldo_act

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]
ls_almacen  = dw_master.object.almacen[dw_master.getrow()]

dw_detail.AcceptText()
Select 	factor_sldo_total, factor_sldo_x_llegar, factor_sldo_sol
	into 	:li_sldo_total, :li_sldo_llegar, :li_sldo_sol
from articulo_mov_tipo 
where tipo_mov = :ls_tipo_mov;


ls_cod_art   = dw_detail.object.cod_art			[al_row]
ld_cant_dig  = dw_detail.object.cant_proc_und2	[al_row]	
ls_flag_und2 = dw_detail.object.flag_und2			[al_row]	
	
// Que cantidad no sea cero
if dw_detail.object.cant_proc_und2[al_row] = 0 and ls_flag_und2 = '1' then
	Messagebox( "Atencion", "Cantidad de Und2 no puede ser cero")
	dw_detail.SetColumn( "cant_proc_und2")
	dw_detail.setFocus()
	return 0
end if
	
// Salidas
IF li_sldo_total = -1 then			
	// Verifica saldos
	SELECT Nvl(sldo_total_und2,0)
			INTO   :ld_saldo_act
	FROM   articulo_almacen
	WHERE  almacen = :ls_almacen 
	  AND cod_art = :ls_cod_Art; 
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El articulo no existe en almacen')
		return 0
	end if
	
	if ld_saldo_act = 0 then
		MessageBox('Aviso', 'El articulo no tiene saldo en almacen (und2)')
		return 0
	end if
	
	IF ld_cant_dig > ld_saldo_act THEN
		Messagebox('Aviso','Cantidad a Procesar de la Segunda Unidad No Puede Exceder al Saldo Actual' &
			+ '~r~nSaldo Actual (und2): ' + String (ld_saldo_act,'#0.0000'), exclamation!)
		dw_detail.object.cant_proc_und2[al_row] = 0
		Return 0
	END IF		
End if

return 1
end function

public subroutine of_saldos_articulo (long al_row);string 	ls_cod_art, ls_almacen
decimal 	ldc_saldo, ldc_prom_sol, ldc_prom_dol, &
			ldc_saldo_und2

if al_row = 0 then return
if dw_master.Getrow() = 0 then return

ls_cod_art = dw_detail.object.cod_art[al_row]
ls_almacen = dw_master.object.almacen[dw_master.GetRow()]

select Nvl(sldo_total,0), Nvl(sldo_total_und2,0), 
			costo_prom_sol, costo_prom_dol
	into  :ldc_saldo, :ldc_saldo_und2, 
			:ldc_prom_sol, :ldc_prom_dol
from articulo_almacen
where cod_art = :ls_cod_art
  and almacen = :ls_almacen;

if SQLCA.SQLCode = 100 then
	ldc_saldo 		= 0
	ldc_saldo_und2 = 0
	select costo_prom_sol, costo_prom_dol
	  into :ldc_prom_sol, :ldc_prom_dol
	from articulo
	where cod_art = :ls_cod_art;
	
	if SQLCA.SQLCode = 100 then
		ldc_prom_sol = 0
		ldc_prom_dol = 0
	end if
end if

em_saldo.text 	    = String( ldc_saldo, '###,##0.000' ) 
em_saldo_und2.text = String( ldc_saldo_und2, '###,##0.000' ) 


end subroutine

public function integer of_solicita_lote (string as_almacen, string as_cod_art);Integer li_ok
string	ls_cntrl_lote_art, ls_cntrl_lote_alm

select NVL(flag_cntrl_lote, '0')
	into :ls_cntrl_lote_alm
from almacen
where almacen = :as_almacen;

select NVL(flag_cntrl_lote, '0')
	into :ls_cntrl_lote_art
from articulo
where cod_art = :as_cod_art;

if ls_cntrl_lote_art = '5' then
	return 1
elseif ls_cntrl_lote_art = '0' then
	return 0
elseif ls_cntrl_lote_art = '1' and ls_cntrl_lote_alm = '1' then
	return 1
elseif ls_cntrl_lote_art = '2' and ls_cntrl_lote_alm = '1' then
	return 1
elseif ls_cntrl_lote_art = '2' and ls_cntrl_lote_alm = '2' then
	return 1
end if	  
return 0
	

end function

public subroutine of_duplica_mov_art (long al_row);Long ll_Row

if al_row = 0 then return

if IsNull(dw_Detail.object.cod_Art[al_row]) then return
if trim(dw_Detail.object.cod_Art[al_row]) = '' then return

ll_row = dw_detail.event ue_insert()

if ll_Row > 0 then
	dw_detail.object.cod_origen		[ll_row] = dw_detail.object.cod_origen			[al_row]
	dw_detail.object.nro_vale			[ll_row] = dw_detail.object.nro_vale			[al_row]
	dw_detail.object.nro_mov			[ll_row] = dw_detail.object.nro_mov				[al_row]
	dw_detail.object.org_amp_oc		[ll_row] = dw_detail.object.origen_mov_proy	[al_row]
	dw_detail.object.nro_amp_oc		[ll_row] = dw_detail.object.nro_mov_proy		[al_row]
	dw_detail.object.flag_estado		[ll_row] = dw_detail.object.flag_estado		[al_row]
	dw_detail.object.cod_Art			[ll_row] = dw_detail.object.cod_art				[al_row]
	dw_detail.object.desc_art			[ll_row] = dw_detail.object.desc_art			[al_row]
	dw_detail.object.und					[ll_row] = dw_detail.object.und					[al_row]
	dw_detail.object.und2				[ll_row] = dw_detail.object.und2					[al_row]	
	dw_detail.object.cant_procesada	[ll_row] = dw_detail.object.cant_procesada	[al_row]	
	dw_detail.object.flag_und2			[ll_row] = dw_detail.object.flag_und2			[al_row]	
	dw_detail.object.factor_conv_und	[ll_row] = dw_detail.object.factor_conv_und	[al_row]	
	dw_detail.object.flag_cntrl_lote	[ll_row] = dw_detail.object.flag_cntrl_lote	[al_row]		
	dw_detail.object.peso_neto			[ll_row] = dw_detail.object.peso_neto			[al_row]			
	dw_detail.object.oper_sec			[ll_row] = dw_detail.object.oper_sec			[al_row]				
	dw_detail.object.flag_replicacion[ll_Row] = '1'
	
	dw_detail.ii_update = 1
end if
end subroutine

public subroutine of_retrieve (string as_nro);Long 		ll_row
date		ld_Fecha

ll_row = dw_master.retrieve(as_nro)

if ll_row > 0 then
	ld_fecha = DATE(dw_master.object.fec_registro[ll_row])
	
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro)
	
	// Busca si esta cerrado contablemente	
	ii_cerrado = invo_cntbl.of_cierre_almacen(ld_fecha)
	
	if ii_cerrado = 0 then
		dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
	else
		dw_master.object.t_cierre.text = ''
	end if 
	
	// Activa/desactiva campos segun caso
	of_tipo_mov(dw_master.object.tipo_mov[ll_row]) // Evalua datos segun tipo de mov.	
	
	dw_master.ii_protect = 0
	dw_master.ii_update 	= 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.ii_update	= 0
	dw_detail.of_protect()
	
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	of_set_status_doc( dw_master )
	
	is_action = 'open'
end if

return 
end subroutine

public subroutine of_referencia_mov (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String 	ls_almacen, ls_nro_oc, ls_opcion, ls_nro_int, &
			ls_proveedor, ls_nom_proveedor
Date 		ld_fecha
Long		ll_row_mas, ll_count
str_parametros lstr_param, lstr_datos

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return

ls_almacen 	 = dw_master.object.almacen [ll_row_mas]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN
END IF

// SI existe detalle y ya tiene seleccionado un documento
// Entonces lo selecciono
if NOT IsNull(dw_master.object.nro_oc[ll_row_mas]) and &
	trim(dw_master.object.nro_oc[ll_row_mas]) <> '' and &
	dw_detail.RowCount() <> 0 then 
	
	ls_nro_oc = dw_master.object.nro_oc[ll_row_mas] 
else
	ls_nro_oc = '%%'
end if

if NOT IsNull(dw_master.object.nro_doc_int[ll_row_mas]) and &
	trim(dw_master.object.nro_doc_int[ll_row_mas]) <> '' and &
	dw_detail.RowCount() <> 0 then 
	
	ls_nro_int = dw_master.object.ls_nro_int[ll_row_mas] 
else
	ls_nro_int = '%%'
end if

lstr_param.tipo		 = ''
lstr_param.dw_or_m	 = dw_master
lstr_param.dw_or_d    = dw_detail	
lstr_param.w1			 = this

// Evalua campos
if il_fac_total = 1 then
	if is_clase_mov = 'I' then  // Ingreso por compras
		
		lstr_param.dw_master = 'd_sel_oc_transporte'      
		lstr_param.dw1       = 'd_sel_oc_transporte_det'  
		lstr_param.opcion    = 8
		lstr_param.tipo		 ='1S'
		lstr_param.titulo    = 'Ordenes de Compra para transportar '
		lstr_param.string1	= ls_nro_oc
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		
	ELSE
		MessageBox('Aviso', 'El movimiento de Ingreso debe tener como referencia el Ingreso x compra')
		return
	END IF
else
	lstr_param.dw_master = 'd_sel_vale_mov_trans'      
	lstr_param.dw1       = 'd_sel_vale_mov_trans_det'  
	lstr_param.opcion    = 9
	lstr_param.tipo		 ='1S'
	lstr_param.titulo    = 'Mov de Transito pendientes de descargar'
	lstr_param.string1	= ls_almacen
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
	select count(*)
	  into :ll_count
	from almacen_transport
	where almacen = :ls_almacen;
	
	if ll_count = 1 then
		
		select p.proveedor, p.nom_proveedor
			into :ls_proveedor, :ls_nom_proveedor
		from 	almacen_transport at,
				proveedor			p
		where at.proveedor = p.proveedor
		  and at.almacen = :ls_almacen;
		
		dw_master.object.prov_transporte	[ll_row_mas] = ls_proveedor
		dw_master.object.nom_proveedor	[ll_row_mas] = ls_nom_proveedor
		
	end if
	
end if

end subroutine

public function integer of_nro_item (datawindow adw_1);// Genera numero de item para un dw
Integer ll_i, ll_mayor

ll_mayor = adw_1.object.nro_item[1]
if isnull(ll_mayor) then
	ll_mayor = 0
end if
For ll_i = 1 to adw_1.RowCount()
	if adw_1.object.nro_item[ll_i] > ll_mayor then
		ll_mayor = adw_1.object.nro_item[ll_i]
	end if
Next
ll_mayor ++

Return ll_mayor
end function

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
else

	dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
	dw_detail.SetTransObject(sqlca)

	idw_1 = dw_master              		// asignar dw corriente
	idw_1.TriggerEvent(clicked!)

	dw_master.of_protect()         		// bloquear modificaciones 
	dw_detail.of_protect()

	ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
	// ii_help = 101     
   
	ib_log = TRUE
	
	// Crea datastore para impresion de vale
	ids_print = Create Datastore
	ids_print.DataObject = 'd_frm_movimiento_transito'
	ids_print.SettransObject(sqlca)
	
	invo_cntbl = create n_cst_contabilidad

	dw_master.object.p_logo.filename = gs_logo
end if
end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

//of_tipo_mov( dw_master.object.tipo_mov[dw_master.getrow()])
IF is_action <> 'anu' AND is_action <> 'del' then
	if of_get_datos() = 0 then return   		// Evalua datos de cabecera
END IF

// verifica que tenga datos de detalle
if dw_detail.rowcount() = 0 then
	Messagebox( "Atencion", "Ingrese informacion de detalle")
	return
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_set_numera	() = 0 then return

ib_update_check = true


end event

on w_al325_mov_transito.create
int iCurrent
call super::create
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.sle_nro=create sle_nro
this.em_saldo_und2=create em_saldo_und2
this.em_saldo=create em_saldo
this.st_4=create st_4
this.cb_1=create cb_1
this.st_nro=create st_nro
this.st_1=create st_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.em_saldo_und2
this.Control[iCurrent+3]=this.em_saldo
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_nro
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_detail
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.gb_1
end on

on w_al325_mov_transito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.em_saldo_und2)
destroy(this.em_saldo)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_insert;Long  ll_row, ll_ano, ll_mes, ll_count

if idw_1 = dw_master and is_action = 'new' then
	Messagebox( "Atencion", "No puede adicionar otro registro, grabe el actual", exclamation!)
	return
end if

IF idw_1 = dw_detail THEN	
	MessageBox('Aviso', 'No Esta permitido esta acción, debe ingresarse siempre con referencia')
	RETURN
else
	// Limpia dw
	dw_master.Reset()
	dw_detail.Reset()
END IF

id_fecha_proc = f_fecha_actual() 

// Verifica indicador de cierre contable
ll_ano = YEAR( DATE(id_fecha_proc))
ll_mes = MONTH( DATE(id_fecha_proc))

// Busca si esta cerrado contablemente	
Select NVL( flag_almacen,'0') 
	into :ii_cerrado
from cntbl_cierre 
where ano = :ll_ano 
  and mes = :ll_mes;

if sqlca.sqlcode = 100 then
	Messagebox("Atencion", "Periodo contable " &
		+ string(ll_ano) + "-" + string(ll_mes) + " no encontrado, " &
		+ "~r~n Coordinar con area contable para su apertura", Exclamation!)
	  return
end if

if ii_cerrado = 1 then
	SELECT NVL( flag_cierre_mes, '0' ) 
	  INTO :ii_cerrado  
	from cntbl_cierre 
	where ano = :ll_ano 
	  and mes = :ll_mes ;
end if  
  
if ii_cerrado = 0 then
	MessageBox('Aviso', 'Periodo Contable esta cerrado')
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	dw_master.object.p_logo.filename = gs_logo
	of_set_status_doc(idw_1)
end if

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
	END IF
END IF

end event

event ue_modify;call super::ue_modify;string 	ls_nro_vale, ls_origen_vale
Long	 	ll_count
Int 		li_protect

IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No puede modificar este movimiento')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
	
end if

ls_nro_vale 	= dw_master.object.nro_vale 	[dw_master.GetRow()]

if ls_nro_vale = '' or IsNull(ls_nro_vale) then
	MessageBox('Aviso', 'El nro de vale no esta definido o esta en blanco, verifique ')
	return
end if

dw_master.of_protect()
dw_detail.of_protect()	

li_protect = integer(dw_master.Object.fec_registro.Protect)

of_tipo_mov(dw_master.object.tipo_mov[dw_master.GetRow()])

IF li_protect = 0 THEN
	
	// fuerza a Desactivar objetos
	dw_master.Object.almacen.Protect = 1
	dw_master.Object.tipo_mov.Protect = 1
END IF 


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String ls_msg1, ls_msg2, ls_nro_vale

if dw_master.rowcount() = 0 then return
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

IF ib_log THEN
	ib_control_lin = FALSE
	
	dw_master.of_create_log( )
	dw_detail.of_create_log( )
	
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log( )
		lbo_ok = dw_detail.of_save_log( )
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	ls_nro_vale = dw_master.object.nro_vale[dw_master.GetRow()]
	of_retrieve( ls_nro_vale)

	of_set_status_doc( dw_master)
	
	f_mensaje('Cambios Guardados satisfactoriamente', '')
	
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1,ls_msg2,exclamation!)	
END IF
end event

event resize;call super::resize;Long ll_y
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 35
dw_detail.height = newheight - dw_detail.y - 180	
	
gb_1.width  = newwidth  - gb_1.x - 35
gb_1.Y		= newheight - gb_1.height - 15
	
ll_y = dw_detail.y + dw_detail.height + 70

st_1.y = ll_y + 10
em_saldo. y = ll_y 
	
st_4.y = ll_y + 10 
em_saldo_und2.y= ll_y 

end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_list_vale_mov_trans'
sl_param.titulo = 'Movimientos en Tránsito'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[2])
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;idw_1.setcolumn(1)
end event

event ue_print;call super::ue_print;String ls_nro_vale
Long job, j, lx, ly

ls_nro_vale = dw_master.object.nro_vale[dw_master.getrow()]

ids_print.Retrieve(ls_nro_Vale)

ids_print.print()

end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if


end event

event ue_delete;// OVerride
String 	ls_nro_vale, ls_origen_vale
Long		ll_count, ll_row

IF dw_master.GetRow() = 0 then return

ll_row = dw_master.GetRow()

if dw_master.object.flag_estado[ll_row] <> '1' then
	MessageBox('Aviso', 'No puede modificar este movimiento')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
	
end if

//Continuamos con el procedimiento
if idw_1 = dw_master then
	Messagebox( "Atencion", "Operacion no permitida", exclamation!)
	return
elseif idw_1 = dw_detail then
	if Dec(idw_1.object.cant_proc_am[idw_1.GetRow()]) > 0 then
		Messagebox( "Atencion", "No puede eliminar item porque ya tiene movimiento de almacén", exclamation!)
		return
	end if
end if

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

if idw_1 = dw_master then
	is_action = 'del'
end if
end event

event ue_close_pre();call super::ue_close_pre;DESTROY ids_print
end event

event close;call super::close;DESTROY ids_print
destroy invo_cntbl

end event

type sle_nro from u_sle_codigo within w_al325_mov_transito
integer x = 334
integer y = 16
integer width = 471
integer height = 92
integer taborder = 10
textcase textcase = upper!
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.Triggerevent( clicked!)
end event

type em_saldo_und2 from singlelineedit within w_al325_mov_transito
integer x = 1211
integer y = 1880
integer width = 343
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type em_saldo from singlelineedit within w_al325_mov_transito
integer x = 480
integer y = 1880
integer width = 343
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type st_4 from statictext within w_al325_mov_transito
integer x = 873
integer y = 1888
integer width = 334
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Und2:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_al325_mov_transito
integer x = 864
integer y = 16
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

type st_nro from statictext within w_al325_mov_transito
integer x = 46
integer y = 32
integer width = 279
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
string text = "Numero:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_al325_mov_transito
integer x = 105
integer y = 1888
integer width = 334
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Actual:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_al325_mov_transito
integer y = 1316
integer width = 3621
integer height = 488
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_vale_mov_trans_det_tbl"
borderstyle borderstyle = styleraised!
integer ii_sort = 1
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
idw_mst = dw_master
idw_det = dw_detail
end event

event itemchanged;call super::itemchanged;if dw_master.GetRow() = 0 then return

dw_master.Accepttext()
dw_detail.AcceptText()
CHOOSE CASE dwo.name
	CASE 'cant_procesada'
		if of_evalua_saldos(row) = 0 then return 1

END CHOOSE


end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc( THIS)

if of_get_datos() = 0 then return
end event

event ue_insert_pre;String 	ls_tipo_mov, ls_tipo_alm, ls_alm, ls_matriz, ls_null
Long		ll_row_mas

if dw_master.GetRow() = 0 then
	MessageBox('Aviso', 'Movimiento de Almacen no tiene cabecera')
	return
end if

SetNull( ls_null)
this.object.nro_item		[al_row] = of_nro_item(this)
this.object.flag_estado	[al_row] = '1'

ll_row_mas = dw_master.GetRow()
if ll_row_mas = 0 then return

this.object.nro_vale	[al_row] = dw_master.object.nro_vale[ll_row_mas]
this.object.cod_usr	[al_row] = gs_user
this.object.cant_proc_am[al_row] = 0


end event

event getfocus;call super::getfocus;if of_get_datos() = 0 then return
end event

event ue_output;call super::ue_output;of_saldos_articulo(al_row)
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          ls_boton, ls_nro_vale, ls_origen
long				 ll_row
DateTime			 ldt_fec_reg	
str_parametros 	 sl_param

If this.Describe("almacen.Protect") = '1' then RETURN

ls_boton = dwo.name

if ls_boton = 'b_dup' then	
	of_duplica_mov_art(row)	
end if

end event

type dw_master from u_dw_abc within w_al325_mov_transito
event ue_display ( string as_columna,  long al_row )
integer y = 136
integer width = 3621
integer height = 1168
integer taborder = 40
string dataobject = "d_abc_vale_mov_trans_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
integer ii_sort = 1
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where FLAG_TIPO_ALMACEN = 'O' " &
				  + "and flag_estado = '1' " &
				  + "and cod_origen = '" + gs_origen + "' " &
  				  + "order by almacen " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	case "tipo_mov"
		ls_almacen = this.object.almacen[al_row]
		
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', 'No ha ingresado el almacen')
			this.SetColumn('almacen')
			return
		end if
		
		ls_sql = "select a.tipo_mov as codigo_tipo_mov, " &
				 + "a.desc_tipo_mov as descripcion_tipo_mov " &
				 + "from articulo_mov_tipo a, " &
				 + "almacen_tipo_mov b " &
				 + "where a.tipo_mov = b.tipo_mov " &
				 + "and a.flag_estado = '1' " &
				 + "and nvl(a.factor_sldo_consig,0) = 0 " &
				 + "and nvl(a.factor_sldo_pres,0) = 0 " &
				 + "and nvl(a.factor_sldo_dev,0) = 0 " &
				 + "and nvl(a.flag_ajuste_valorizacion,'0') = '0' " &
 				 + "and b.almacen = '" + ls_almacen + "' " &
				 + "order by a.tipo_mov"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_mov  [al_row] = ls_codigo
			
			// Evalua datos segun tipo de mov.
			if of_tipo_mov(ls_codigo)  = 0 then 
				this.object.tipo_mov 		[al_row] = ls_null
				this.object.desc_tipo_mov 	[al_row] = ls_null
				return 
			end if
			
			this.object.tipo_mov			[al_row] = ls_codigo
			this.object.desc_tipo_mov	[al_row] = ls_data
			this.ii_update = 1

			this.object.tipo_mov.background.color = RGB(192,192,192)   
			this.object.tipo_mov.protect = 1

		end if
		
		return
	
	case "prov_transporte"
		if il_fac_total = 1 then
			ls_sql = "SELECT proveedor AS codigo_proveedor, " &
					  + "nom_proveedor AS nombre_proveedor " &
					  + "FROM proveedor " &
					  + "where flag_estado = '1'"
		else
			ls_almacen = this.object.almacen [al_row]
			
			if ls_almacen = '' or IsNull(ls_almacen) then
				MessageBox('Aviso', 'Debe ingresar un almacén')
				return
			end if
			
			ls_sql = "SELECT p.proveedor AS codigo_proveedor, " &
					  + "p.nom_proveedor AS nombre_proveedor " &
					  + "FROM proveedor p, " &
					  + "almacen_transport at " &
					  + "where at.proveedor = p.proveedor " &
					  + "and at.almacen = '" + ls_almacen + "' " &
					  + "and p.flag_estado = '1'"
		end if
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.prov_transporte[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "tipo_doc_int"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_int	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_doc_ext"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_ext	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

end event

event constructor;call super::constructor;is_mastdet = 'md'	
is_dwform = 'form' // tabular form

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master
idw_det	= dw_detail
end event

event itemchanged;call super::itemchanged;Int 		li_val, li_saldo_consig, li_saldo_pres, li_saldo_dev, li_cerrado
string 	ls_nombre, ls_mensaje, ls_desc, ls_almacen

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

CHOOSE CASE lower(dwo.name)
	CASE 'fec_documento'
		id_fecha_proc = this.object.fec_documento[row]
		
		li_cerrado =  invo_cntbl.of_cierre_almacen( date(id_fecha_proc))
		
		if li_cerrado = -1 or li_cerrado = 0 then
			if li_cerrado = -1 then
				gnvo_app.of_mensaje_error("La fecha Ingresada " + string(date(id_fecha_proc), 'dd/mm/yyyy') + " no esta en un periodo válido para contabilidad. Por favor coordinar con CONTABILIDAD y verifique!")
			else
				gnvo_app.of_mensaje_error("La fecha Ingresada " + string(date(id_fecha_proc), 'dd/mm/yyyy') + " esta en un periodo cerrado por contabilidad. Por favor coordinar con CONTABILIDAD y verifique!")
			end if
			
			this.object.fec_registro [row] = gnvo_app.of_fecha_actual( )
			return 1
		end if
		
	
	CASE 'almacen'

		SELECT desc_almacen 
			INTO :ls_desc
		FROM almacen
   	WHERE  almacen = :data
		  and flag_estado = '1'
		  and cod_origen = :gs_origen
		  and flag_tipo_almacen = 'O'; 
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de almacen no existe, ' &
					+ 'no esta activo, no le corresponde a su origen o ' &
					+ 'no es un almacén en tránsito')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.almacen		[row] = gnvo_app.is_null
			this.object.desc_almacen[row] = gnvo_app.is_null
			this.setcolumn( "almacen" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.desc_almacen [row] = ls_desc
		
	CASE 'tipo_mov'
		ls_almacen = dw_master.object.almacen [dw_master.GetRow()]
		
		if of_tipo_mov(data)  = 0 then // Evalua datos segun tipo de mov.
			this.object.tipo_mov[row] = gnvo_app.is_null
			RETURN 1
		end if
		
		SELECT 	a.desc_tipo_mov, 		a.factor_sldo_consig,
					a.factor_sldo_dev,	a.factor_sldo_pres
			INTO 	:ls_nombre,				:li_saldo_consig,
					:li_saldo_pres,		:li_saldo_dev
		FROM  articulo_mov_tipo a,
				almacen_tipo_mov  b
   	WHERE a.tipo_mov 		= b.tipo_mov
		  and a.flag_estado 	= '1'
		  and a.tipo_mov 		= :data 
		  and b.almacen 		= :ls_almacen;
		
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Tipo de Movimiento no existe, no esta activo ' &
					+ 'o no le corresponde al almacen')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			
			this.Object.tipo_mov			[row] = gnvo_app.is_null
			this.object.desc_tipo_mov 	[row] = gnvo_app.is_null
			this.setcolumn( "tipo_mov" )
			this.setfocus()
			RETURN 1
		END IF
		
	
		if li_saldo_consig <> 0 then
			Messagebox('Aviso','El movimiento x consignacion no se maneja por esta ventana, ' &
						+ 'Tiene que ir a la opcion de consignaciones')
			this.Object.tipo_mov			[row] = gnvo_app.is_null
			this.object.desc_tipo_mov 	[row] = gnvo_app.is_null
			this.setcolumn( "tipo_mov" )
			this.setfocus()
			RETURN 1
		end if

		if li_saldo_pres <> 0 or li_saldo_dev <> 0 then
			Messagebox('Aviso','El movimiento x Prestamos o Devoluciones no se maneja ' &
						+ 'por esta ventana, Tiene que ir a la opcion de ' &
						+ 'prestamos/devoluciones' )
			this.Object.tipo_mov			[row] = gnvo_app.is_null
			this.object.desc_tipo_mov 	[row] = gnvo_app.is_null
			this.setcolumn( "tipo_mov" )
			this.setfocus()
			RETURN 1
		end if

		this.object.desc_tipo_mov	[row] = ls_nombre
		this.object.tipo_mov.background.color = RGB(192,192,192)   
		this.object.tipo_mov.protect = 1
		
	CASE 'proveedor'

		SELECT NOM_PROVEEDOR 
			INTO :ls_nombre 
		FROM proveedor
   	WHERE  PROVEEDOR = :data 
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Codigo de Proveedor no existe, no esta activo ')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.prov_transporte[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.setcolumn( "proveedor")
			this.setfocus()
			RETURN 1
		END IF
		
		this.object.nom_proveedor [row] = ls_nombre
		
	CASE 'tipo_doc_int'
		
		SELECT desc_tipo_doc 
			INTO :ls_desc 
		FROM doc_tipo
   	WHERE  tipo_doc = :data ;
		
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Tipo de Documento Interno no existe ')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.tipo_doc_int[row] = gnvo_app.is_null
			this.setcolumn( "tipo_doc_int" )
			this.setfocus()
			RETURN 1
		END IF
		
	CASE 'tipo_doc_ext'
		
		SELECT desc_tipo_doc 
			INTO :ls_desc 
		FROM doc_tipo
   	WHERE  tipo_doc = :data ;
		
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Tipo de Documento Externo no existe ')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.tipo_doc_ext[row] = gnvo_app.is_null
			this.setcolumn( "tipo_doc_ext" )
			this.setfocus()
			RETURN 1
		END IF
		
END CHOOSE

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_codart[]
Long ll_row, ll_ano, ll_mes

this.object.cod_origen  	[al_row]  = gs_origen
this.object.flag_estado 	[al_row]  = '1'		// Activo
this.object.cod_usr     	[al_row]  = gs_user
this.object.fec_registro	[al_row] = id_fecha_proc   //ld_fec
this.object.fec_documento	[al_row] = id_fecha_proc   //ld_fec

is_solicita_ref = '0'
is_action = 'new'

ll_ano = YEAR( DATE(id_fecha_proc))
ll_mes = MONTH( DATE(id_fecha_proc))

// Busca si esta cerrado contablemente	
Select NVL( flag_almacen,0) 
	into :ii_cerrado
from cntbl_cierre 
where ano = :ll_ano 
  and mes = :ll_mes;

if ii_cerrado = 0 or SQLCA.SQLCode = 100 then
	SELECT NVL( flag_cierre_mes, '0' ) 
	  INTO :ii_cerrado  
	from cntbl_cierre 
	where ano = :ll_ano 
	  and mes = :ll_mes ;
end if
  
if ii_cerrado = 0 then
	this.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	this.object.t_cierre.text = ''
end if 

this.object.tipo_mov.background.color = RGB(255,255,255)
this.object.tipo_mov.protect = 0
this.SetColumn('fec_documento')
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc( THIS)

end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          ls_boton, ls_nro_vale, ls_origen, ls_tipo_mov
long				 ll_row
DateTime			 ldt_fec_reg	
str_parametros 	 sl_param

If this.Describe("almacen.Protect") = '1' then RETURN

ls_boton = dwo.name
ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]


if ls_boton = 'b_ref' then	

	IF is_solicita_ref = '0' then
		MessageBox('Aviso', 'El tipo de Movimiento no piede referencia')
		Return
	END IF	
	of_referencia_mov(ls_tipo_mov)	
	
end if

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

type gb_1 from groupbox within w_al325_mov_transito
integer x = 55
integer y = 1832
integer width = 3383
integer height = 144
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldos"
end type

