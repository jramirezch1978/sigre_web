$PBExportHeader$w_al304_consignaciones.srw
forward
global type w_al304_consignaciones from w_abc_master
end type
type dw_enlaces from u_dw_abc within w_al304_consignaciones
end type
type cb_buscar from commandbutton within w_al304_consignaciones
end type
type sle_nro from singlelineedit within w_al304_consignaciones
end type
type st_nro from statictext within w_al304_consignaciones
end type
type sle_ori from singlelineedit within w_al304_consignaciones
end type
type st_ori from statictext within w_al304_consignaciones
end type
end forward

global type w_al304_consignaciones from w_abc_master
integer width = 2638
integer height = 2188
string title = "Consignaciones [AL304]"
string menuname = "m_mantto_anular"
event ue_anular ( )
dw_enlaces dw_enlaces
cb_buscar cb_buscar
sle_nro sle_nro
st_nro st_nro
sle_ori sle_ori
st_ori st_ori
end type
global w_al304_consignaciones w_al304_consignaciones

type variables
String 	is_flag_contab, is_flag_prov, is_flag_doc_int, &
			is_ing_consig, is_sal_consig, is_mov_ing, is_doc_ot, is_doc_sl, &
			is_sal_cons_int, is_oper_sec, is_origen_mov_proy, is_cencos, &
			is_cnta_prsp, is_cod_maquina, is_flag_venta, is_flag_matriz_contab, &
			is_tipo_doc, is_nro_doc, is_origen_doc, is_ing_liq_consig

Integer	ii_factor_saldo_total, ii_factor_saldo_consig, &
			ii_dias_holgura
decimal	idc_saldo_cantidad, idc_cantidad_sol
Long		il_nro_mov_proy
end variables

forward prototypes
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_tipo_mov (string as_tipo_mov)
public subroutine of_verifica_mov (string as_tipo_mov)
public function boolean of_mov_almacen ()
public function string of_num_art_consig ()
public function boolean of_retrieve_mov ()
public function boolean of_crea_mov_art (string as_vale)
end prototypes

event ue_anular;string 	ls_nro_vale, ls_cod_art, ls_mensaje, ls_mov_ing
long		ll_row
decimal	ldc_cantidad

if is_action = 'new' then
	MessageBox('Aviso', 'Opcion no permitida, no puede anular registro recien ingresado')
	return
end if

if is_action = 'edit' then
	MessageBox('Aviso', 'Opcion no permitida, no puede anular registro en modo EDICIÓN, ' &
					+ ' tiene que grabar el registro primero')
	return
end if

ll_row = dw_master.GetRow()
if ll_row = 0 then return

if dw_master.object.flag_estado[ll_row] <> '1' then
	MessageBox('Aviso', 'No puede anular este movimiento, accion no permitida')
	return
end if

if dw_master.object.tipo_mov[ll_row] = is_ing_liq_consig then
	MessageBox('Aviso', 'No puede anular un movimiento de Ingreso x Liquidación de Consignación')
	return
end if

if MessageBox('Aviso', 'Desea anular el movimiento?', Information!, YesNo!, 2) = 2 then return 

if ii_factor_saldo_consig = 1 then
	// Si el movimiento es un ingreso entonces debo verificar que no tenga
	// movimientos de salida
	
	if dw_enlaces.RowCount() > 0 then
		MessageBox('Aviso', 'No puede anular este movimiento de ingreso porque ya tiene salidas')
		return
	end if
	
elseif ii_factor_saldo_consig = -1 then
	// Si el movimiento es una salida entonces debo tambien anular
	// los movimientos de almacen

	// Obtengo el codigo del articulo
	ls_cod_art  = dw_master.object.cod_art			[ll_row]

	// Primero tengo que anular el vale de salida
	ls_nro_vale = dw_master.object.nro_vale_sal	[ll_row]
	
	update vale_mov
		set flag_estado = '0',
			 flag_replicacion = '1'
	where nro_vale = :ls_nro_vale;
	
	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en VALE_MOV - Vale Salida', ls_mensaje)
		return
	end if
	
	update articulo_mov
		set flag_estado = '0',
			 cant_procesada = 0,
			 flag_replicacion = '1'
	where nro_vale = :ls_nro_vale
	  and cod_art 	= :ls_cod_art;

	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en ARTICULO_MOV - Vale Salida', ls_mensaje)
		return
	end if

	// A continuacion tengo que anular el vale de ingreso
	ls_nro_vale = dw_master.object.nro_vale_ing	[ll_row]
	
	update vale_mov
		set flag_estado = '0',
			 flag_replicacion = '1'
	where nro_vale = :ls_nro_vale;
	
	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en VALE_MOV - Vale Ingreso', ls_mensaje)
		return
	end if
	
	update articulo_mov
		set flag_estado = '0',
			 cant_procesada = 0,
			 flag_replicacion = '1'
	where nro_vale = :ls_nro_vale
	  and cod_art = :ls_cod_art;

	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en ARTICULO_MOV - Vale Ingreso', ls_mensaje)
		return
	end if
	
	// Luego tengo que exhortar la cantidad liquidada en el 
	// movimiento de ingreso
	ldc_cantidad = dec(dw_master.object.cantidad[ll_row])
	
	if dw_enlaces.RowCount() = 0 then
		ROLLBACK;
		MessageBox('Aviso', 'No existe vale de ingreso')
		return
	end if
	
	if dw_enlaces.RowCount() > 1 then
		ROLLBACK;
		MessageBox('Aviso', 'Este movimiento tiene mas de un ingreso, por favor verifique')
		return
	end if

	ls_mov_ing	 = dw_enlaces.object.nro_mov_ing[1]
	
	update ARTICULO_CONSIGNACION
		set cantidad_liquidada = Nvl(cantidad_liquidada,0) - :ldc_cantidad,
			 flag_replicacion = '1'
	where nro_mov = :ls_mov_ing;
	
	
	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ARTICULO_CONSIGNACION', ls_mensaje)
		return
	end if
	
end if

dw_master.object.flag_estado[ll_row] = '0'
dw_master.ii_update = 1
is_action = 'anu'

this.TriggerEvent('ue_update');


end event

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ROLLBACK;

dw_master.retrieve(as_origen, as_nro)
dw_master.ii_update = 0
ll_row = dw_master.Rowcount()

is_action = 'open'
if ll_row <> 0 then
	dw_master.ii_protect = 0
	dw_master.of_protect()
	of_tipo_mov(dw_master.object.tipo_mov[ll_row])
	of_retrieve_mov()
	dw_master.object.p_logo.filename = gs_logo
end if

//	of_set_status_doc( dw_master )

return 
end subroutine

public function integer of_tipo_mov (string as_tipo_mov);/* 
  Funcion que activa/desactiva campos segun tipo de movimiento
  Retorna:  1 = OK
  				0 = Error
*/

String 	ls_alm, ls_flag_estado, ls_null
Long 		ll_row, ln_count, ln_flag_templa

ll_row = dw_master.GetRow()
if ll_row = 0 then return 0

SetNull(ls_null)
ls_alm = dw_master.object.almacen[ll_row]

// Busca indicadores segun tipo de movimiento
Select 	Nvl(flag_solicita_prov,'0'), 	NVL(flag_solicita_doc_int,0), 
			Nvl(flag_contabiliza, '0'),	NVL(factor_sldo_total,0), 	
			Nvl(factor_sldo_consig,0), 	Nvl(flag_estado, '0')
into 		:is_flag_prov, 		:is_flag_doc_int, 
			:is_flag_contab,		:ii_factor_saldo_total,
			:ii_factor_saldo_consig, :ls_flag_estado
from articulo_mov_tipo 
where tipo_mov = :as_tipo_mov;			

If SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe tipo de movimiento: ' + as_tipo_mov, StopSign!)
	dw_master.object.tipo_mov 			[ll_row] = ls_null
	dw_master.object.desc_tipo_mov 	[ll_row] = ls_null
	dw_master.SetColumn('tipo_mov')
	dw_master.SetFocus()
	return 0
end if

if ls_flag_estado = '0' then
	MessageBox('Aviso', 'Tipo de movimiento no está activo', StopSign!)
	dw_master.object.tipo_mov 			[ll_row] = ls_null
	dw_master.object.desc_tipo_mov 	[ll_row] = ls_null
	dw_master.SetColumn('tipo_mov')
	dw_master.SetFocus()
	return 0
end if

// Valida si existe el tipo para el almacen
Select count(tipo_mov) 
	into :ln_count 
from almacen_tipo_mov
where tipo_mov = :as_tipo_mov 
  and almacen = :ls_alm;
	
if ln_count = 0 then
	Messagebox( "Atencion", "tipo de movimiento no esta asignado a este almacen", exclamation!)		
	dw_master.object.tipo_mov 			[ll_row] = ls_null
	dw_master.object.desc_tipo_mov 	[ll_row] = ls_null
	dw_master.SetColumn('tipo_mov')
	dw_master.SetFocus()
	return 0
end if

// Si es una venta El tipo de mov no puede ser un Ingreso 
if ii_factor_saldo_consig = 1 and is_flag_venta = '1' and is_action = 'new' then
	Messagebox( "Atencion", "No puede hacer un ingreso x consignacion si es una venta", exclamation!)		
	dw_master.object.tipo_mov 			[ll_row] = ls_null
	dw_master.object.desc_tipo_mov 	[ll_row] = ls_null
	dw_master.SetColumn('tipo_mov')
	dw_master.SetFocus()
	return 0
end if

//Aplico los flag de acuerdo al tipo de movimiento
if is_flag_prov = '0' then
	dw_master.object.proveedor.background.color = RGB(192,192,192)   
	dw_master.object.proveedor.protect = 1
	dw_master.object.proveedor.edit.required = 'No'
else
	if is_action = 'new' or is_action = 'edit' then
		dw_master.object.proveedor.background.color = RGB(255,255,255)
		dw_master.object.proveedor.protect = 0
		dw_master.object.proveedor.edit.required = 'Yes'
	end if
end if		

if is_flag_doc_int = '0' then			
	dw_master.object.tipo_doc.background.color = RGB(192,192,192)
	dw_master.object.nro_doc.background.color = RGB(192,192,192)
	dw_master.object.tipo_doc.protect = 1
	dw_master.object.nro_doc.protect = 1
	dw_master.object.tipo_doc	[ll_row] = ls_null
	dw_master.object.nro_doc	[ll_row] = ls_null
else		
	if is_action = 'new' or is_action = 'edit' then
		dw_master.object.tipo_doc.background.color = RGB(255,255,255)
		dw_master.object.nro_doc.background.color = RGB(255,255,255)
		dw_master.object.tipo_doc.protect = 0
		dw_master.object.nro_doc.protect = 0
	end if
end if

if is_action = 'new' then	
	
	// Que valide si tipo de mov. tiene matriz definida, solo si se contabiliza
	if is_flag_contab = '1' then
		
		if is_flag_matriz_contab = 'P' then
			Select count( tipo_mov) 
				into :ln_count 
			from tipo_mov_matriz
			Where tipo_mov = :as_tipo_mov;
			
		elseif is_flag_matriz_contab = 'S' then
			
			Select count( tipo_mov) 
				into :ln_count 
			from tipo_mov_matriz_subcat
			Where tipo_mov = :as_tipo_mov;
		else
			MessageBox('Aviso', 'No esta definido FLAG_MATRIZ_CONTAB en LOGPARAM')
			ln_count = 0
		end if
		
		if ln_count = 0 then
			Messagebox( "Atencion", "Tipo de movimiento no tiene matriz definida", StopSign!)
		end if
	end if	  	


	of_verifica_mov(as_tipo_mov)
end if

// Si es por recuperacion no debo modificar ni el almacen 
// ni el proveedor, ni el tipo de movimiento, ni el tipo de moneda,
// ni el cliente, ni el flag_venta

if is_action = 'open' or is_action='edit' then
	dw_master.object.almacen.background.color = RGB(192,192,192)
	dw_master.object.almacen.protect = 1

	dw_master.object.proveedor.background.color = RGB(192,192,192)
	dw_master.object.proveedor.protect = 1

	dw_master.object.tipo_mov.background.color = RGB(192,192,192)
	dw_master.object.tipo_mov.protect = 1

	dw_master.object.flag_venta.background.color = RGB(192,192,192)
	dw_master.object.flag_venta.protect = 1

	dw_master.object.cod_cliente.background.color = RGB(192,192,192)
	dw_master.object.cod_cliente.protect = 1

	dw_master.object.cod_moneda.background.color = RGB(192,192,192)
	dw_master.object.cod_moneda.protect = 1
	
	dw_master.object.cod_art.background.color = RGB(192,192,192)
	dw_master.object.cod_art.protect = 1
	
end if

dw_master.setfocus()
return 1
end function

public subroutine of_verifica_mov (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/

String 	ls_almacen
Date 		ld_fecha
long		ll_row
Integer	il_dias_holgura
str_parametros 			sl_param
str_mov_art_consig 	lstr_mov_consig

ll_row = dw_master.GetRow()
if ll_row = 0 then return

ls_almacen 	 = dw_master.object.almacen [ll_row]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen')
	RETURN
END IF
	
sl_param.tipo		 = ''
sl_param.dw_or_m	 = dw_master

SetNull(is_tipo_doc)
SetNull(is_nro_doc)
SetNull(is_origen_doc)

// Si es una salida x Consumo Interno 
if ii_factor_saldo_consig = -1 and is_action = 'new' and is_flag_venta = '0' then
	ld_fecha = relativeDate(Date(dw_master.object.fec_registro[ll_row]), ii_dias_holgura)
	
	//Primero tengo que pedirle el movimiento proyectado, hay que tener
	//cuidado en esta parte, ya que solamente me debe mostrar de OT y SL
	
	sl_param.dw1       = 'd_sel_mov_proyectados_ot_sl'
	sl_param.titulo    = 'Consumo Interno '
	sl_param.tipo		 = 'CONSIG'     // con un parametro del tipo string
	sl_param.string1   = is_sal_cons_int
	sl_param.string3	 = is_flag_contab
	sl_param.opcion    = 8
	sl_param.dw_m		 = dw_master
	sl_param.fecha1	 = ld_fecha
	
	// Muestra Solo aquellos articulos que han sido solicitados
	// x medio de una OT o de una Solicitud de Salida (SL)
	OpenWithParm( w_abc_seleccion, sl_param)
	If IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	sl_param = Message.PowerObjectParm
	
	if sl_param.titulo = 'n' then return
	
	is_oper_sec 			= sl_param.string1
	is_origen_mov_proy 	= sl_param.string2
	il_nro_mov_proy		= sl_param.long1
	
	is_cencos				= sl_param.field_ret[1]
	is_cnta_prsp			= sl_param.field_ret[2]
	is_cod_maquina			= sl_param.field_ret[3]
	is_nro_doc				= sl_param.nro_doc
	is_tipo_doc				= sl_param.tipo_doc
	is_origen_doc			= sl_param.origen_doc
	
	//Salida de Articulos por Consignación
	sl_param.dw1       = 'd_art_consig_proveedor_grd'
	sl_param.titulo    = 'Consumo Articulos Consignacion '
	sl_param.tipo		 = 'CONSIG_2'     // con un parametro del tipo string
	sl_param.string3	 = is_flag_contab
	sl_param.opcion    = 7
	sl_param.dw_m		 = dw_master

	OpenWithParm( w_abc_seleccion, sl_param )
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	if is_action = 'new' then
		dw_master.object.cod_moneda.background.color = RGB(192,192,192)
		dw_master.object.cod_moneda.protect = 1
		
		dw_master.object.precio_unitario.background.color = RGB(192,192,192)
		dw_master.object.precio_unitario.protect = 1
		
		dw_master.object.cod_art.background.color = RGB(192,192,192)
		dw_master.object.cod_art.protect = 1

	end if

	lstr_mov_consig = Message.PowerObjectParm
	
	if is_action = 'new' then
		dw_enlaces.DataObject = 'd_art_consig_ing_grd'
		dw_enlaces.SetTransObject(SQLCA)
		
		ll_row = dw_enlaces.event ue_insert()
		if ll_row > 0 then
			dw_enlaces.object.nro_mov_ing [ll_row] = lstr_mov_consig.nro_mov
			is_mov_ing	= lstr_mov_consig.nro_mov	// Es el mov de ingreso
			dw_enlaces.object.tipo_mov		[ll_row] = lstr_mov_consig.tipo_mov
			dw_enlaces.object.cod_art 		[ll_row] = lstr_mov_consig.cod_art
			dw_enlaces.object.desc_art		[ll_row] = lstr_mov_consig.desc_art
			dw_enlaces.object.cantidad		[ll_row] = lstr_mov_consig.cantidad - lstr_mov_consig.cantidad_liq
			idc_saldo_cantidad  = lstr_mov_consig.cantidad - lstr_mov_consig.cantidad_liq
			idc_cantidad_sol 	  = lstr_mov_consig.cantidad_sol
		end if
	end if
	
end if

// Si es una salida x Venta a Terceros
if ii_factor_saldo_consig = -1 and is_action = 'new' and is_flag_venta = '1' then
	
	//Debe Mostrar Todos los Articulos en consignacion que tengan saldo
	sl_param.dw1       = 'd_art_consig_all_grd'
	sl_param.titulo    = 'Saldo Articulos Consignacion '
	sl_param.tipo		 = 'CONSIG_3'     // con un parametro del tipo string
	sl_param.string3	 = is_flag_contab
	sl_param.opcion    = 11
	sl_param.dw_m		 = dw_master

	OpenWithParm( w_abc_seleccion, sl_param )
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	if is_action = 'new' then
		dw_master.object.cod_moneda.background.color = RGB(192,192,192)
		dw_master.object.cod_moneda.protect = 1

		dw_master.object.proveedor.background.color = RGB(192,192,192)
		dw_master.object.proveedor.protect = 1

		dw_master.object.flag_venta.background.color = RGB(192,192,192)
		dw_master.object.flag_venta.protect = 1
		
		dw_master.object.precio_unitario.background.color = RGB(192,192,192)
		dw_master.object.precio_unitario.protect = 1
		
		dw_master.object.cod_art.background.color = RGB(192,192,192)
		dw_master.object.cod_art.protect = 1

	end if

	lstr_mov_consig = Message.PowerObjectParm
	
	if is_action = 'new' then
		dw_enlaces.DataObject = 'd_art_consig_ing_grd'
		dw_enlaces.SetTransObject(SQLCA)
		
		ll_row = dw_enlaces.event ue_insert()
		if ll_row > 0 then
			dw_enlaces.object.nro_mov_ing [ll_row] = lstr_mov_consig.nro_mov
			is_mov_ing	= lstr_mov_consig.nro_mov	// Es el mov de ingreso
			dw_enlaces.object.tipo_mov		[ll_row] = lstr_mov_consig.tipo_mov
			dw_enlaces.object.cod_art 		[ll_row] = lstr_mov_consig.cod_art
			dw_enlaces.object.desc_art		[ll_row] = lstr_mov_consig.desc_art
			dw_enlaces.object.cantidad		[ll_row] = lstr_mov_consig.cantidad - lstr_mov_consig.cantidad_liq
			idc_saldo_cantidad  = lstr_mov_consig.cantidad - lstr_mov_consig.cantidad_liq
			idc_cantidad_sol 	  = lstr_mov_consig.cantidad_sol
		end if
	end if
	
end if
end subroutine

public function boolean of_mov_almacen ();/*
	Esta funcion crea,actualiza o elimina el movimiento de almacen de
	acuerdo, a la accion que se tome, solo cuando salga material x reposicion
	
	Retorna  TRUE = OK
				FALSE = Error
*/

string  ls_tipo_mov

return true
end function

public function string of_num_art_consig ();string	ls_nro_mov	
long		ll_ult_nro, ll_count

select count(*)
	into :ll_count
from num_articulo_consignacion
where origen = :gs_origen;

if ll_count = 0 then
	ll_ult_nro = 1
	ls_nro_mov = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	ll_ult_nro ++
	
	insert into num_articulo_consignacion(origen, ult_nro)
	values( :gs_origen, :ll_ult_nro);

else
	select ult_nro
		into :ll_ult_nro
	from num_articulo_consignacion
	where origen = :gs_origen 
	for update;
	
	ls_nro_mov = trim(gs_origen) + string(ll_ult_nro, '00000000')
	ll_ult_nro ++
	
	update num_articulo_consignacion
	set ult_nro = :ll_ult_nro
	where origen = :gs_origen;
	
end if


return ls_nro_mov
end function

public function boolean of_retrieve_mov ();string 	ls_nro_mov
long		ll_row

dw_enlaces.Reset()

ll_row = dw_master.GetRow()
if ll_row = 0 then return false

ls_nro_mov = dw_master.object.nro_mov[ll_row]

if ii_factor_saldo_consig = 1 then
	
	// Ingresos x consignaciones
	dw_enlaces.DataObject = 'd_art_consig_sal_grd'
	dw_enlaces.SetTransObject(SQLCA)
	dw_enlaces.Retrieve(ls_nro_mov)
	
else
	
	// Salidas x consignaciones
	dw_enlaces.DataObject = 'd_art_consig_ing_grd'
	dw_enlaces.SetTransObject(SQLCA)
	dw_enlaces.Retrieve(ls_nro_mov)
	
end if

return true
end function

public function boolean of_crea_mov_art (string as_vale);/*

Esta funcion me crea un mov de ingreso por compra y salida por consumo interno

*/

string 	ls_oper_ing_oc, ls_dolares, ls_doc_alm, ls_doc_oc, ls_oper_cons_int, &
			ls_mensaje, ls_soles, ls_nro_vale, ls_tipo_mov, ls_almacen, ls_tipo_doc, &
			ls_nro_doc, ls_proveedor, ls_nom_rec, ls_matriz_ing, ls_cencos, &
			ls_cnta_prsp, ls_matriz_sal, ls_moneda, ls_cod_maquina, ls_cod_art, &
			ls_recep_ing, ls_recep_sal, ls_tipo_mov_ing, ls_null, ls_mov_sal, &
			ls_flag_solicita_prov
			
Long 		ll_ult_nro, ll_count, ll_row
Integer 	li_fac_sldo_x_llegar, li_fac_sldo_sol
DateTime	ldt_fecha
decimal	ldc_cambio, ldc_precio, ldc_cantidad, ldc_precio_prom, ldc_saldo_Total
str_mov_art_consig 	lstr_mov_consig

SetNull(ls_null)

If IsNull(is_mov_ing) or is_mov_ing = '' then
	MessageBox('Aviso', 'No ha definido un vale de ingreso, variable is_mov_ing')
	return false
end if

ll_row = dw_master.GetRow()
if ll_row = 0 then return false

ls_almacen 		= dw_master.object.almacen[ll_row]
ls_tipo_mov 	= dw_master.object.tipo_mov[ll_row]
ldt_fecha		= DateTime(dw_master.object.fec_registro[ll_row])

if is_flag_venta = '0' then
	ls_proveedor 	= dw_master.object.proveedor[ll_row]
else
	ls_proveedor 	= dw_master.object.cod_cliente[ll_row]
end if

ls_moneda		= dw_master.object.cod_moneda[ll_row]
ldc_precio		= dec(dw_master.object.precio_unitario[ll_row])
ldc_cantidad	= dec(dw_master.object.cantidad[ll_row])
ls_cod_art		= dw_master.object.cod_art[ll_row]

// Obtengo el tipo de movimiento del ingreso x Consignacion
select tipo_mov
	into :ls_tipo_mov_ing
from articulo_consignacion
where nro_mov = :is_mov_ing;

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'No existe mov de Ingreso x Consignacion ' + is_mov_ing)
	return false
end if

// Obteniendo parametros de LogParam
SELECT 	cod_dolares, oper_ing_oc, oper_cons_interno, 
       	doc_mov_almacen, doc_oc, cod_soles
  INTO 	:ls_dolares, :ls_oper_ing_oc, :ls_oper_cons_int,
  			:ls_doc_alm, :ls_doc_oc, :ls_soles
  FROM logparam l
 WHERE reckey = '1' ;
 
if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return false
end if

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return false
end if

if IsNull(ls_dolares) or ls_dolares = '' then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido parametros de DOLARES en LogaParam')
	return false
end if

if IsNull(ls_soles) or ls_soles = '' then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido parametros de SOLES en LogaParam')
	return false
end if

if IsNull(ls_oper_ing_oc) or ls_oper_ing_oc = '' then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido OPERACION DE INGRESO X COMPRA en LogaParam')
	return false
end if

if IsNull(ls_oper_cons_int) or ls_oper_cons_int = '' then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido OPERACION DE CONSUMO INTERNO en LogaParam')
	return false
end if

if IsNull(ls_doc_oc) or ls_doc_oc = '' then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido DOCUMENTO ORDEN DE COMPRA en LogaParam')
	return false
end if

if IsNull(ls_doc_alm) or ls_doc_alm = '' then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido DOCUMENTO DE MOVIMIENTO DE ALMACEN en LogaParam')
	return false
end if

//Obtengo el tipo de Cambio 
//ldc_cambio = f_get_tipo_cambio(ld_fecha)
//if ldc_cambio = 0 or IsNull(ldc_cambio) then
//	ROLLBACK;
//	MessageBox('Aviso', 'El tipo de cambio no puede ser cero o nulo')
//	return false
//end if

Select vta_dol_prom
	into :ldc_cambio
from calendario
where to_char(fecha, 'yyyymmdd') = to_char(:ldt_fecha, 'yyyymmdd');

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'No ha ingresado el tipo de cambio del dia ' + string(ldt_fecha, 'dd/mm/yyyy'))
	return false
end if

if ldc_cambio = 0 or IsNull(ldc_cambio) then
	ROLLBACK;
	MessageBox('Aviso', 'El tipo de cambio no puede ser cero o nulo')
	return false
end if

// Si el tipo de moneda es dolares, tengo que pasarlo a soles
if ldc_precio = 0 then
	MessageBox('AViso', 'El articulo no puede tener precio cero')
	return false
end if

if ls_moneda = ls_dolares then
	ldc_precio = round(ldc_precio * ldc_cambio,4)
end if

lstr_mov_consig.almacen 		= dw_master.object.almacen[dw_master.GetRow()]
lstr_mov_consig.tipo_mov_ing 	= ls_oper_ing_oc

if is_flag_venta = '0' then
	lstr_mov_consig.tipo_mov_sal 	= ls_oper_cons_int
else
	lstr_mov_consig.tipo_mov_sal 	= ls_null
end if

lstr_mov_consig.dw_m				= dw_master
lstr_mov_consig.cencos			= is_cencos
lstr_mov_consig.cnta_prsp		= is_cnta_prsp
lstr_mov_consig.cod_maquina	= is_cod_maquina
lstr_mov_consig.flag_matriz_contab = is_flag_matriz_contab
lstr_mov_consig.cod_art			= ls_cod_art

// Aperturo Ventana para las opciones por defecto
OpenWithParm(w_datos_consig, lstr_mov_consig)
lstr_mov_consig = Message.PowerObjectParm

If Not IsValid(lstr_mov_consig) or IsNull(lstr_mov_consig) then return false

if lstr_mov_consig.retorno = 'n' then return false

ls_matriz_ing 	= lstr_mov_consig.matriz_ing
ls_matriz_sal 	= lstr_mov_consig.matriz_sal
ls_recep_ing	= lstr_mov_consig.receptor_ing
ls_recep_sal	= lstr_mov_consig.receptor_sal
ls_cencos		= lstr_mov_consig.cencos
ls_cnta_prsp	= lstr_mov_consig.cnta_prsp
ls_cod_maquina	= lstr_mov_consig.cod_maquina
ls_mov_sal		= lstr_mov_consig.tipo_mov_sal

//Obtengo el ultimo numero segun el numerador
select Count(*)
	into :ll_count
from num_vale_mov
where origen = :gs_origen;

if ll_count = 0 then
	insert into num_vale_mov(origen, ult_nro)
	values (:gs_origen, 1);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return false
	end if
end if

select ult_nro
	into :ll_ult_nro
from num_vale_mov
where origen = :gs_origen for update;

/**************************************************
	Generando el movimiento de ingreso
**************************************************/

ls_nro_vale = trim(gs_origen) + string(ll_ult_nro, '00000000')

select tipo_doc, nro_doc
	into :ls_tipo_doc, :ls_nro_doc
from articulo_consignacion
where nro_mov = :is_mov_ing;

ls_proveedor 	= dw_master.object.proveedor[ll_row]

// Cabecera
insert into vale_mov(
	cod_origen, 	nro_vale,		almacen,			flag_estado,	fec_registro,
	tipo_mov,		cod_usr,			proveedor,		tipo_doc_int,	nro_doc_int,
	nom_receptor	)
values(
	:gs_origen,		:ls_nro_vale,	:ls_almacen,	'1',				:ldt_fecha,
	:ls_oper_ing_oc,	:gs_user,	:ls_proveedor,	:ls_tipo_doc,	:ls_nro_doc,
	:ls_recep_ing	);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en Vale_mov de ingreso', ls_mensaje)
	return false
end if

//Detalle
insert into articulo_mov(
	cod_origen, 	flag_estado, 	cod_art, 		cant_procesada, 	precio_unit,
	cod_moneda,		matriz, 			nro_vale)
values(
	:gs_origen,		'1',				:ls_cod_art,	:ldc_cantidad,		:ldc_precio,
	:ls_soles,		:ls_matriz_ing,:ls_nro_vale);
	
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en Articulo_mov de ingreso', ls_mensaje)
	return false
end if

// Grabando el vale de ingreso en la salida x Consignacion
dw_master.object.origen_vale_ing [ll_row] = gs_origen
dw_master.object.nro_vale_ing		[ll_row] = ls_nro_vale
dw_master.ii_update = 1

// Aumento en uno el numerador
ll_ult_nro ++

/**************************************************
	Generando el movimiento de Salida
**************************************************/
select NVL(flag_solicita_prov, '0')
	into :ls_flag_solicita_prov
from articulo_mov_tipo amt
where amt.tipo_mov = :ls_mov_sal;

if ls_flag_solicita_prov = '0' then
	SetNull(ls_proveedor)
else
	if is_flag_venta = '0' then
		ls_proveedor 	= dw_master.object.proveedor[ll_row]
	else
		ls_proveedor 	= dw_master.object.cod_cliente[ll_row]
	end if
end if

ls_nro_vale = trim(gs_origen) + string(ll_ult_nro, '00000000')

//Obtengo el precio promedio del articulo
select NVL(costo_prom_sol,0), NVL(sldo_total,0)
	into :ldc_precio_prom, :ldc_saldo_total
from articulo_almacen
where cod_art = :ls_cod_art
  and almacen = :ls_almacen;

if ldc_saldo_total <= 0 then
	ROLLBACK;
	MessageBox('Aviso', 'El saldo Total en el almacen ' + ls_almacen + ' es Cero')
	return false
end if

if ldc_precio_prom = 0 then
	select NVL(costo_prom_sol,0)
		into :ldc_precio_prom
	from articulo
	where cod_art = :ls_cod_art;
	
	if ldc_precio_prom = 0 then
		ROLLBACK;
		MessageBox('Aviso', 'El Precio Promedio del articulo es cero')
		return false
	end if
end if

//Inserto la cabecera del movimiento
insert into vale_mov(
	cod_origen, 	nro_vale,		almacen,			flag_estado,	fec_registro,
	tipo_mov,		cod_usr,			proveedor,		tipo_doc_int,	nro_doc_int,
	nom_receptor,	ORIGEN_REFER, 	tipo_refer,		nro_refer	)
values(
	:gs_origen,		:ls_nro_vale,	:ls_almacen,	'1',				:ldt_fecha,
	:ls_mov_sal,	:gs_user,		:ls_proveedor,	:ls_tipo_doc,	:ls_nro_doc,
	:ls_recep_sal,	:is_origen_doc,:is_tipo_doc,	:is_nro_doc );

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en Vale_mov de salida', ls_mensaje)
	return false
end if

if is_flag_Venta = '1' then
	SetNull(is_origen_mov_proy )
	SetNull(il_nro_mov_proy)
	SetNull(is_oper_sec)
end if

//Detalle
insert into articulo_mov(
	cod_origen, 	flag_estado, 	cod_art, 		cant_procesada, 	precio_unit,
	cod_moneda,		cencos,			cnta_prsp,		cod_maquina,		matriz,
	nro_vale,		oper_sec, 		origen_mov_proy,	nro_mov_proy, flag_saldo_libre)
values(
	:gs_origen,		'1',				:ls_cod_art,	:ldc_cantidad,		:ldc_precio_prom,
	:ls_soles,		:ls_cencos,		:ls_cnta_prsp,	:ls_cod_maquina,	:ls_matriz_sal,
	:ls_nro_vale,	:is_oper_sec,	:is_origen_mov_proy,	:il_nro_mov_proy, '1');
	
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en Articulo_mov de salida', ls_mensaje)
	return false
end if

// Grabando el vale de ingreso en la salida x Consignacion
dw_master.object.origen_vale_sal [ll_row] = gs_origen
dw_master.object.nro_vale_sal		[ll_row] = ls_nro_vale
dw_master.ii_update = 1

//Aumento en uno al numerador
ll_ult_nro ++

//Grabando el numerador en la tabla
update num_vale_mov
	set ult_nro = :ll_ult_nro
where origen = :gs_origen;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en NUM_VALE_MOV', ls_mensaje)
	return false
end if

//Actualizo el saldo consumido del movimiento de ingreso
update articulo_consignacion
	set cantidad_liquidada = NVL(cantidad_liquidada,0) + :ldc_cantidad,
		 flag_replicacion = '1'
where nro_mov = :is_mov_ing;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error actualizar ARTICULO_CONSIGNACION', ls_mensaje)
	return false
end if

return true
end function

on w_al304_consignaciones.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_anular" then this.MenuID = create m_mantto_anular
this.dw_enlaces=create dw_enlaces
this.cb_buscar=create cb_buscar
this.sle_nro=create sle_nro
this.st_nro=create st_nro
this.sle_ori=create sle_ori
this.st_ori=create st_ori
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_enlaces
this.Control[iCurrent+2]=this.cb_buscar
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.st_nro
this.Control[iCurrent+5]=this.sle_ori
this.Control[iCurrent+6]=this.st_ori
end on

on w_al304_consignaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_enlaces)
destroy(this.cb_buscar)
destroy(this.sle_nro)
destroy(this.st_nro)
destroy(this.sle_ori)
destroy(this.st_ori)
end on

event ue_open_pre;call super::ue_open_pre;of_center_window()
dw_master.object.p_logo.filename = gs_logo
ii_pregunta_delete = 1

select 	ing_cons_consig, sal_cons_consig, NVL(dias_holgura_mat,0),
			doc_ot, doc_ss, oper_cons_interno, flag_matriz_contab, 
			ing_liq_consig
	into 	:is_ing_consig, :is_sal_consig, :ii_dias_holgura,
			:is_doc_ot, :is_doc_sl, :is_sal_cons_int, :is_flag_matriz_contab, 
			:is_ing_liq_consig
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros de Logistica', StopSign!)
	return 
end if

if IsNull(is_ing_consig) or is_ing_consig = '' then
	MessageBox('Aviso', 'No ha definido el movimiento de ingreso x consignacion')
	return
end if

if IsNull(is_sal_consig) or is_sal_consig = '' then
	MessageBox('Aviso', 'No ha definido el movimiento de salida x consignacion')
	return
end if

If IsNull(is_doc_ot) or is_doc_ot = '' then
	MessageBox('Aviso', 'No ha definido Orden Trabajo (doc_ot) en logparam')
	return
end if

If IsNull(is_doc_sl) or is_doc_sl = '' then
	MessageBox('Aviso', 'No ha definido Solicitud de Salida (doc_ss) en logparam')
	return
end if

If IsNull(is_sal_cons_int) or is_sal_cons_int = '' then
	MessageBox('Aviso', 'No ha definido Salida x Consumo interno (oper_cons_interno) en logparam')
	return
end if

If IsNull(is_flag_matriz_contab) or is_flag_matriz_contab = '' then
	MessageBox('Aviso', 'No ha definido FLAG_MATRIZ_CONTAB en logparam')
	return
end if

If IsNull(is_ing_liq_consig) or is_ing_liq_consig = '' then
	MessageBox('Aviso', 'No ha definido ING_LIQ_CONSIG en logparam')
	return
end if

dw_master.object.p_logo.filename = gs_logo	
end event

event ue_list_open();call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_sel_consignacion"
sl_param.titulo = "Consignaciones"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

event ue_update;//
Boolean  lbo_ok = TRUE
String	ls_msg1, ls_msg2

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = 'Error en Base de Datos'
		ls_msg2 = 'No se pudo grabar Maestro'
	END IF
END IF

IF	dw_enlaces.ii_update = 1 THEN
	IF dw_enlaces.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = 'Error en Base de Datos'
		ls_msg2 = 'No se pudo grabar Detalle'
	END IF
END IF


IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ls_msg1 = 'Error en Base de Datos'
			ls_msg2 = 'No se pudo grabar el Log Diario'
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.resetUpdate()	
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()

	dw_enlaces.resetUpdate()	
	dw_enlaces.ii_update = 0
	dw_enlaces.il_totdel = 0

	is_action = 'save'
ELSE
	ROLLBACK USING SQLCA;
	MessageBox( ls_msg1, ls_msg2)
END IF
end event

event ue_update_pre;call super::ue_update_pre;Long 		ll_row
string 	ls_nro_mov

ib_update_check = False
ll_row = dw_master.GetRow()
if ll_Row = 0 then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then return

dw_master.of_set_flag_replicacion()
dw_enlaces.of_set_flag_replicacion()

if is_action = 'new' then
	ls_nro_mov = of_num_art_consig()
	if ls_nro_mov = '' or IsNull(ls_nro_mov) then return
	
	dw_master.object.nro_mov [ll_row] = ls_nro_mov
	dw_master.ii_update = 1

	// Si es salida, entonces grabo 
	if ii_factor_saldo_consig = -1 then
		dw_enlaces.object.nro_mov_sal[1] = ls_nro_mov
		dw_enlaces.ii_update = 1
		
		//Si el movimiento es una salida entonces debe crear el movimiento de almacen
		if of_crea_mov_art(ls_nro_mov) = false then return
	end if
	
end if

ib_update_check = True


end event

event resize;//Ancestor script override
dw_master.width  = newwidth  - dw_master.x - 10

dw_enlaces.width = newwidth - dw_enlaces.x - 10
dw_enlaces.height = newheight - dw_enlaces.y - 10
end event

event ue_insert;//Ancestror Script Override
Long  ll_row
this.event dynamic ue_update_request()

if idw_1 = dw_master then
	This.event ue_update_request()
	idw_1.Reset()
	dw_enlaces.Reset()
end if

ll_row = idw_1.Event ue_insert()

IF ll_row > 0 THEN
	is_action = 'new'
	dw_master.object.p_logo.filename = gs_logo
	
	dw_master.object.almacen.background.color = RGB(255,255,255)
	dw_master.object.almacen.protect = 0

	dw_master.object.tipo_mov.background.color = RGB(255,255,255)
	dw_master.object.tipo_mov.protect = 0

	dw_master.object.flag_venta.background.color = RGB(255,255,255)
	dw_master.object.flag_venta.protect = 0

	dw_master.object.proveedor.background.color = RGB(255,255,255)
	dw_master.object.proveedor.protect = 0

	dw_master.object.cod_moneda.background.color = RGB(255,255,255)
	dw_master.object.cod_moneda.protect = 0
	
	dw_master.object.precio_unitario.background.color = RGB(255,255,255)
	dw_master.object.precio_unitario.protect = 0
	
	dw_master.object.cod_art.background.color = RGB(255,255,255)
	dw_master.object.cod_art.protect = 0

	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_modify;//Ancestror Script Override
Long 		ll_row
string	ls_tipo_mov

ll_row = dw_master.GetRow()
if ll_row = 0 then return

if dw_master.object.flag_estado[ll_row] <> '1' then
	MessageBox('Aviso', 'Movimiento no se puede modificar')
	dw_master.ii_protect = 0
	dw_master.of_protect() 
	return
end if

if is_action = 'open' or is_action = 'save' then
	if ii_factor_saldo_consig = -1 then
		MessageBox('Aviso', 'No puede modificar un movimiento de salida x Consignacion')
		dw_master.ii_protect = 0
		dw_master.of_protect() 
		return
	end if
end if

if is_action <> 'new' then
	is_action = 'edit'
end if


dw_master.of_protect() 
ls_tipo_mov = dw_master.object.tipo_mov[ll_row]

of_tipo_mov(ls_tipo_mov)
end event

type dw_master from w_abc_master`dw_master within w_al304_consignaciones
event ue_display ( string as_columna,  long al_row )
integer y = 136
integer width = 2574
integer height = 1380
string dataobject = "d_abc_consignacion"
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_almacen, ls_tipo_mov, ls_proveedor, ls_tipo_doc, ls_moneda
Str_articulo lstr_articulo

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT ALMACEN AS CODIGO_ALMACEN, " &
				  + "DESC_ALMACEN AS DESCRIPCION_ALMACEN " &
				  + "FROM almacen " &
				  + "where cod_origen = '" + gs_origen + "' " &
				  + "and flag_estado = '1' " &
  				  + "order by almacen "
					 
		lb_ret = f_lista(ls_sql, ls_almacen, ls_data, '1')
		
		if ls_almacen <> '' then
			this.object.almacen			[al_row] = ls_almacen
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "tipo_mov"
		ls_almacen = this.object.almacen [al_row]
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', 'Primero defina el almacen', StopSign!)
			return
		end if
		
		ls_sql = "Select a.tipo_mov as Codigo_tipo_mov, " &
				 + "a.desc_tipo_mov as descripcion_tipo_mov " &
				 + "from articulo_mov_tipo a, " &
				 + "almacen_tipo_mov b " &
				 + "where a.tipo_mov = b.tipo_mov " &
				 + "and a.flag_estado = '1' " &
				 + "AND a.factor_sldo_consig <> 0 " &
				 + "and b.almacen = '" + ls_almacen + "' " &
				 + "order by a.tipo_mov"
				 
		lb_ret = f_lista(ls_sql, ls_tipo_mov, ls_data, '2')
		
		if ls_tipo_mov <> '' then
			if of_tipo_mov(ls_tipo_mov) = 1 then
				this.object.tipo_mov			[al_row] = ls_tipo_mov
				this.object.desc_tipo_mov	[al_row] = ls_data
				this.ii_update = 1
			end if
		end if
		
		return

	case "proveedor"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO_PROVEEDOR, " &
				  + "NOM_PROVEEDOR AS DESCRIPCION_PROVEEDOR " &
				  + "FROM PROVEEDOR " &
				  + "where FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_proveedor, ls_data, '2')
		
		if ls_proveedor <> '' then
			this.object.proveedor		[al_row] = ls_proveedor
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "cod_cliente"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO_PROVEEDOR, " &
				  + "NOM_PROVEEDOR AS DESCRIPCION_PROVEEDOR " &
				  + "FROM PROVEEDOR " &
				  + "where FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_proveedor, ls_data, '2')
		
		if ls_proveedor <> '' then
			this.object.cod_cliente	[al_row] = ls_proveedor
			this.object.nom_cliente	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "cod_art"

		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
		
		if lstr_articulo.b_Return then
			
			this.object.cod_art	[al_row] = lstr_articulo.cod_art
			this.object.desc_art	[al_row] = lstr_articulo.desc_art
			this.object.und		[al_row] = lstr_articulo.und

		end if
		
	case "tipo_doc"
		ls_sql = "SELECT TIPO_DOC AS TIPO_DOCUMENTO, " &
				  + "DESC_TIPO_DOC AS DESCRIPCION_TIPO_DOC " &
				  + "FROM DOC_TIPO " 
				 
		lb_ret = f_lista(ls_sql, ls_tipo_doc, &
					ls_data, '1')
		
		if ls_tipo_doc <> '' then
			this.object.tipo_doc			[al_row] = ls_tipo_doc
			this.ii_update = 1
		end if
		
		return
		
	case "cod_moneda"
		ls_sql = "SELECT COD_MONEDA AS CODIGO_MONEDA, " &
				  + "DESCRIPCION AS DESCRIPCION_MONEDA " &
				  + "FROM MONEDA " 
				 
		lb_ret = f_lista(ls_sql, ls_moneda, &
					ls_data, '2')
		
		if ls_moneda <> '' then
			this.object.COD_moneda	[al_row] = ls_moneda
			this.object.desc_moneda	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

end choose


end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen  [al_row]  = gs_origen
this.object.flag_estado [al_row]  = '1'		// Activo
THIS.object.fec_registro[al_row]  = f_fecha_actual()
this.object.flag_venta	[al_row]  = '0'

this.object.cod_cliente.background.color = RGB(192,192,192)
this.object.cod_cliente.protect = 1
this.object.cod_cliente.edit.required = 'No'

this.object.tipo_mov.background.color = RGB(255,255,255)
this.object.tipo_mov.protect = 0
this.object.tipo_mov.edit.required = 'Yes'

this.object.cantidad.background.color = RGB(255,255,255)
this.object.cantidad.protect = 0
this.object.cantidad.edit.required = 'Yes'

is_action = 'new'
is_flag_venta = '0'

//of_set_status_doc(dw_master)
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc_art, ls_desc, ls_codigo, ls_mensaje, ls_almacen
decimal	ldc_null

SetNull( ls_null)
SetNull( ldc_null)
This.AcceptText()
choose case lower(dwo.name)
	case "cod_art"
		
		if f_articulo_inventariable( data ) <> 1 then 
			this.object.cod_art[row] = ls_null
			this.object.desc_art[row] = ls_null
			return 1
		end if
				
		// Verifica que codigo ingresado exista			
		Select desc_art
			into :ls_desc_art
		from articulo 
		Where cod_Art = :data;
		
		this.object.desc_art	[row] = ls_desc_art
		return
		
	case "cantidad"
		if ii_factor_saldo_consig = -1 then
			if dec(data) > idc_cantidad_sol then
				this.object.cantidad		[row] = ldc_null
				this.object.cantidad_liq[row] = ldc_null
				MessageBox('Aviso', 'No pude retirar mas de la cantidad solicitada')
				return 1
			end if
			this.object.cantidad_liq[row] = dec(data)
		end if
		return
		
	case "almacen"
		select desc_almacen
		 	into :ls_desc
		from almacen
		where almacen = :data
		  and cod_origen = :gs_origen
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de almacen no existe, no esta activo o no corresponde al origen')
			else
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
			end if
			
			this.object.almacen		[row] = ls_null
			this.object.desc_almacen[row] = ls_null
			return 1
		end if
		
		this.object.desc_almacen [row] = ls_desc
		
		return

	case "tipo_mov"
		
		ls_almacen = this.object.almacen [row]
		
		select a.desc_tipo_mov
		 	into :ls_desc
		from 	articulo_mov_tipo a,
				almacen_tipo_mov  b
		where a.tipo_mov = b.tipo_mov
		  and b.almacen = :data
		  and a.flag_estado = '1';
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No Existe Tipo de movimiento para ese almacen o ' &
						+ 'el tipo de movimiento se encuentra anulado')
			else
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
			end if
			
			this.object.tipo_mov			[row] = ls_null
			this.object.desc_tipo_mov	[row] = ls_null
			return 1
		end if
		
		if of_tipo_mov(data) = 1 then
			this.object.desc_tipo_mov [row] = ls_desc
		end if
		return
		
	case "proveedor"
		
		select nom_proveedor
		 	into :ls_desc
		from 	proveedor
		where proveedor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No Existe Codigo de Proveedor o esta inactivo')
			else
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
			end if
			
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			return 1
		end if
		
		this.object.nom_proveedor [row] = ls_desc
		return

	case "cod_cliente"
		
		select nom_proveedor
		 	into :ls_desc
		from 	proveedor
		where proveedor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No Existe Codigo de Cliente o esta inactivo')
			else
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
			end if
			
			this.object.cod_cliente	[row] = ls_null
			this.object.nom_cliente	[row] = ls_null
			return 1
		end if
		
		this.object.nom_cliente [row] = ls_desc
		return
	
	case "cod_art"

		select desc_art
		 	into :ls_desc
		from 	articulo
		where cod_art = :data
		  and flag_estado = '1'
		  and flag_inventariable = '1';
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No Existe Codigo de Articulo, no esta activo ' &
					+ 'o no es inventariable')
			else
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
			end if
			
			this.object.cod_art		[row] = ls_null
			this.object.desc_art		[row] = ls_null
			return 1
		end if
		
		this.object.desc_art [row] = ls_desc
		return
	
	case "cod_moneda"
		
		select descripcion
		 	into :ls_desc
		from 	moneda
		where cod_moneda = :data;
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No Existe Codigo de Moneda')
			else
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
			end if
			
			this.object.cod_moneda		[row] = ls_null
			this.object.desc_moneda		[row] = ls_null
			return 1
		end if
		
		this.object.desc_moneda [row] = ls_desc
		return
		
	case 'flag_venta'
		is_flag_venta = data
		if data = '1' then
			this.object.cod_cliente.background.color = RGB(255, 255, 255)
			this.object.cod_cliente.protect = 0
			this.object.cod_cliente.edit.required = 'Yes'
		else
			this.object.cod_cliente.background.color = RGB(192, 192, 192)
			this.object.cod_cliente.protect = 1
			this.object.cod_cliente.edit.required = 'No'
			this.object.cod_cliente	[row] = ls_null
			this.object.nom_cliente	[row] = ls_null
		end if
end choose


end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::dberror;// Ancestor Script has been Override"

String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

if sqldbcode <= -20000 then
	ls_msg = SQLErrText
	ROLLBACK;
	MessageBox('DBError ' + This.Classname(), ls_msg)
	return
end if

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode	
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
      FROM ALL_CONSTRAINTS
      WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
				 
		ROLLBACK;
      Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
      Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		ROLLBACK;
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE





end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type dw_enlaces from u_dw_abc within w_al304_consignaciones
integer y = 1528
integer width = 2574
integer height = 464
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_art_consig_sal_grd"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type cb_buscar from commandbutton within w_al304_consignaciones
integer x = 1358
integer y = 16
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;parent.of_retrieve(sle_ori.text, sle_nro.text)
end event

type sle_nro from singlelineedit within w_al304_consignaciones
integer x = 827
integer y = 20
integer width = 512
integer height = 92
integer taborder = 10
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

event modified;cb_buscar.event clicked()
end event

type st_nro from statictext within w_al304_consignaciones
integer x = 539
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

type sle_ori from singlelineedit within w_al304_consignaciones
event dobleclick pbm_lbuttondblclk
integer x = 293
integer y = 20
integer width = 210
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT origen as cod_origen, " &
		 + "nombre AS DESCRIPCION_origen " &
		 + "FROM origen " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type st_ori from statictext within w_al304_consignaciones
integer x = 32
integer y = 32
integer width = 242
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
string text = "Origen:"
boolean focusrectangle = false
end type

