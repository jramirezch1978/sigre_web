$PBExportHeader$w_al314_prest_devol.srw
forward
global type w_al314_prest_devol from w_abc_master
end type
type dw_enlaces from u_dw_abc within w_al314_prest_devol
end type
end forward

global type w_al314_prest_devol from w_abc_master
integer width = 2674
integer height = 2128
string title = "Devoluciones y prestamo [AL314]"
string menuname = "m_mantto_anular"
event ue_anular ( )
dw_enlaces dw_enlaces
end type
global w_al314_prest_devol w_al314_prest_devol

type variables
String 	is_flag_contab, is_flag_prov, is_flag_doc_int, &
			is_mov_sal, is_doc_ot, is_doc_sl, is_oper_sec, is_origen_mov_proy, &
			is_cencos,  is_cnta_prsp, is_cod_maquina, is_flag_dev_pres, &
			is_doc_alm, is_soles, is_flag_doc_ext, is_flag_matriz_contab
			
Integer	ii_factor_prsp, ii_factor_saldo_total, &
			ii_factor_saldo_pres, ii_factor_saldo_dev
decimal	idc_saldo_cantidad, idc_cantidad_sol, idc_saldo_almacen
Long		il_nro_mov_proy
end variables

forward prototypes
public function integer of_tipo_mov (string as_tipo_mov)
public function boolean of_retrieve_mov ()
public function boolean of_crea_mov_art (string as_vale)
public subroutine of_retrieve (string as_nro)
public function integer of_verifica_mov (string as_tipo_mov)
public function string of_nro ()
public function boolean of_actualiza ()
end prototypes

event ue_anular();string 	ls_nro_vale, ls_cod_art, ls_mensaje, ls_mov_sal
long		ll_row
decimal	ldc_cantidad

if is_action = 'new' then
	MessageBox('Aviso', 'Opcion no permitida')
	return
end if

ll_row = dw_master.GetRow()
if ll_row = 0 then return

if dw_master.object.flag_estado[ll_row] <> '1' then
	MessageBox('Aviso', 'No puede anular este movimiento')
	return
end if

if MessageBox('Aviso', 'Desea anular el movimiento?', Information!, YesNo!, 2) = 2 then return 


// Si es una salida debo validar que no tenga ingresos antes de anular
if ii_factor_saldo_dev = 1  or ii_factor_saldo_pres = 1 then
	// Si el movimiento es un ingreso entonces debo verificar que no tenga
	// movimientos de salida
	
	if dw_enlaces.RowCount() > 0 then
		MessageBox('Aviso', 'No puede anular este movimiento de salida porque ya tiene ingresos')
		return
	end if

	// Obtengo el codigo del articulo
	ls_cod_art  = dw_master.object.cod_art			[ll_row]

	// Tengo que anular el vale de Salida de Almacen
	ls_nro_vale = dw_master.object.nro_vale	[ll_row]
	
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
		set flag_estado 		= '0',
			 cant_procesada 	= 0,
			 precio_unit	 	= 0,
			 flag_replicacion = '1'
	where nro_vale = :ls_nro_vale
	  and cod_art = :ls_cod_art;

	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en ARTICULO_MOV - Vale Salida', ls_mensaje)
		return
	end if

elseif ii_factor_saldo_dev = -1  or ii_factor_saldo_pres = -1 then
	//si es un ingreso por Devlucion o prestamo
	// Obtengo el codigo del articulo
	ls_cod_art  = dw_master.object.cod_art			[ll_row]

	// Primero tengo que anular el vale de Ingreso
	ls_nro_vale = dw_master.object.nro_vale	[ll_row]
	
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
		set flag_estado 		= '0',
			 cant_procesada 	= 0,
			 precio_unit	 	= 0,
			 flag_replicacion = '1'
	where nro_vale = :ls_nro_vale
	  and cod_art = :ls_cod_art;

	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en ARTICULO_MOV - Vale Salida', ls_mensaje)
		return
	end if

	// Luego tengo que exhortar la cantidad de Ingreso en el 
	// movimiento de ingreso
	ldc_cantidad = dec(dw_master.object.cant_ingreso[ll_row])
	
	if dw_enlaces.RowCount() = 0 then
		ROLLBACK;
		MessageBox('Aviso', 'No existe vale de ingreso')
		return
	end if
	
	if dw_enlaces.RowCount() > 1 then
		ROLLBACK;
		MessageBox('Aviso', 'Este movimiento tiene mas de una salida, por favor verifique')
		return
	end if

	ls_mov_sal	 = dw_enlaces.object.nro_mov_sal[1]
	
	update ART_DEVOL_PRESTAMO
		set cant_ingreso = Nvl(cant_ingreso,0) - :ldc_cantidad,
			 flag_replicacion = '1'	
	where nro_mov = :ls_mov_sal;
	
	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ART_DEVOL_PRESTAMO', ls_mensaje)
		return
	end if
	
end if

dw_master.object.flag_estado[ll_row] = '0'
dw_master.ii_update = 1
is_action = 'anu'


end event

public function integer of_tipo_mov (string as_tipo_mov);/* 
  Funcion que activa/desactiva campos segun tipo de movimiento
  Retorna:  1 = OK
  				0 = Error
*/

String 	ls_alm, ls_null, ls_flag_estado
Long 		ll_row, ln_count, ln_flag_templa

ll_row = dw_master.GetRow()
if ll_row = 0 then return 0

SetNull(ls_null)
ls_alm = dw_master.object.almacen[ll_row]
is_flag_dev_pres = dw_master.object.flag_dev_pres[ll_row]

//Verifico que se ha seleccionado el flag
if is_flag_dev_pres = '' or IsNull(is_flag_dev_pres) then
	MessageBox('Aviso', 'Tiene que definir primero si una devolucion o prestamo')
	dw_master.SetColumn('flag_dev_pres')
	dw_master.SetFocus()
	return 0
end if

// Busca indicadores segun tipo de movimiento
Select 	Nvl(flag_solicita_prov,'0'), 	NVL(flag_solicita_doc_int,'0'), 
			Nvl(flag_contabiliza, '0'),	NVL(factor_sldo_total,0), 	
			Nvl(factor_sldo_pres,0), 		Nvl(flag_estado, '0'),
			Nvl(factor_sldo_dev,0),			Nvl(flag_solicita_doc_ext,'0')
into 		:is_flag_prov, 			:is_flag_doc_int, 
			:is_flag_contab,			:ii_factor_saldo_total,
			:ii_factor_saldo_pres, 	:ls_flag_estado,
			:ii_factor_saldo_dev,	:is_flag_doc_ext
from articulo_mov_tipo 
where tipo_mov = :as_tipo_mov;

If SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe el tipo de movimiento: ' + as_tipo_mov, StopSign!)
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

//Verifico los factores de saldo, si es devolucion no debe estar activo 
// el prestamo y viceversa
if is_flag_dev_pres = 'D' then
	if ii_factor_saldo_pres <> 0 then
		MessageBox('Aviso', 'Si el movimiento de devolucion no debe mover saldos de prestamos')
		return 0
	end if
	if ii_Factor_saldo_dev = 0 then
		MessageBox('Aviso', 'El movimiento no mueve saldos de devolucion')
		return 0
	end if
end if

if is_flag_dev_pres = 'P' then
	if ii_factor_saldo_dev <> 0 then
		MessageBox('Aviso', 'El movimiento de prestamo no debe mover saldos de devolucion')
		return 0
	end if
	if ii_Factor_saldo_pres = 0 then
		MessageBox('Aviso', 'El movimiento no mueve saldos de prestamo')
		return 0
	end if
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

if is_flag_doc_int = '0' and is_flag_doc_ext = '0' then			
	dw_master.object.tipo_doc.background.color = RGB(192,192,192)
	dw_master.object.nro_doc.background.color = RGB(192,192,192)
	dw_master.object.tipo_doc.protect = 1
	dw_master.object.nro_doc.protect = 1
	if is_action= 'new' then
		dw_master.object.tipo_doc	[ll_row] = ls_null
		dw_master.object.nro_doc	[ll_row] = ls_null
	end if
else		
	if is_action = 'new' or is_action = 'edit' then
		dw_master.object.tipo_doc.background.color = RGB(255,255,255)
		dw_master.object.nro_doc.background.color = RGB(255,255,255)
		dw_master.object.tipo_doc.protect = 0
		dw_master.object.nro_doc.protect = 0
		dw_master.object.tipo_doc.edit.required = 'Yes'
		dw_master.object.nro_doc.edit.required = 'Yes'
	end if
end if

//Debo activar la cantidad de ingreso si es un ingreso
if ii_factor_saldo_pres = -1 or ii_factor_saldo_dev = -1 then
	dw_master.object.cant_salida.background.color = RGB(192,192,192)
	dw_master.object.cant_ingreso.background.color = RGB(255,255,255)
	dw_master.object.cant_salida.protect = 1
	dw_master.object.cant_ingreso.protect = 0
end if

//Debo activar la cantidad de salida si es un salida
if ii_factor_saldo_pres = 1 or ii_factor_saldo_dev = 1 then
	dw_master.object.cant_salida.background.color = RGB(255,255,255)
	dw_master.object.cant_ingreso.background.color = RGB(192,192,192)
	dw_master.object.cant_salida.protect = 0
	dw_master.object.cant_ingreso.protect = 1
end if

if is_action = 'new' or is_action = 'edit' or is_action = 'anu' then	
	
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
  	

	if of_verifica_mov(as_tipo_mov) <> 1 then return 0
end if

// Si es por recuperacion no debo modificar ni el almacen 
// ni el proveedor, ni el tipo de movimiento

if is_action = 'open' then
	dw_master.object.almacen.background.color = RGB(192,192,192)
	dw_master.object.almacen.protect = 1

	dw_master.object.proveedor.background.color = RGB(192,192,192)
	dw_master.object.proveedor.protect = 1

	dw_master.object.cod_art.background.color = RGB(192,192,192)
	dw_master.object.cod_art.protect = 1
	
end if

dw_master.setfocus()
return 1
end function

public function boolean of_retrieve_mov ();string 	ls_nro_mov
long		ll_row

dw_enlaces.Reset()

ll_row = dw_master.GetRow()
if ll_row = 0 then return false

ls_nro_mov = dw_master.object.nro_mov[ll_row]

if ii_factor_saldo_dev = 1 or ii_factor_saldo_pres = 1 then
	
	// Salida por devoluciones o prestamos
	dw_enlaces.DataObject = 'd_art_dev_pres_ing_grd'
	dw_enlaces.SetTransObject(SQLCA)
	dw_enlaces.Retrieve(ls_nro_mov)
	
else
	
	// Ingresos por devoluciones o prestamos
	dw_enlaces.DataObject = 'd_art_dev_pres_sal_grd'
	dw_enlaces.SetTransObject(SQLCA)
	dw_enlaces.Retrieve(ls_nro_mov)
	
end if

return true
end function

public function boolean of_crea_mov_art (string as_vale);/*
Esta funcion me crea el movimiento de almacen correspondiente
*/
string 	ls_doc_oc, ls_nro_oc, ls_origen_oc, ls_mensaje, &
			ls_nro_vale, ls_tipo_mov, ls_almacen, ls_proveedor, &
			ls_matriz, ls_cencos, ls_cnta_prsp, ls_cod_maquina, &
			ls_cod_art, ls_receptor, ls_null, ls_tipo_doc_int, &
			ls_nro_doc_int, ls_tipo_doc_ext, ls_nro_doc_ext, &
			ls_centro_benef
			
Long 		ll_ult_nro, ll_count, ll_row
DateTime	ldt_fecha
decimal	ldc_cambio, ldc_precio, ldc_cantidad
str_mov_art_consig 	lstr_mov_consig

ll_row = dw_master.GetRow()
if ll_row = 0 then return false

SetNull(ls_null)

ls_almacen 		 = dw_master.object.almacen		[ll_row]
ls_tipo_mov 	 = dw_master.object.tipo_mov		[ll_row]
ls_proveedor 	 = dw_master.object.proveedor		[ll_row]
ls_centro_benef = dw_master.object.centro_benef	[ll_row]
ldt_fecha		 = DateTime(dw_master.object.fec_registro[ll_row])

if is_flag_doc_int = '1' then
	ls_tipo_doc_int	= dw_master.object.tipo_doc	[ll_Row]
	ls_nro_doc_int		= dw_master.object.nro_doc		[ll_row]
else 
	ls_tipo_doc_int	= ls_null
	ls_nro_doc_int		= ls_null
end if

if is_flag_doc_ext = '1' then
	ls_tipo_doc_ext	= dw_master.object.tipo_doc	[ll_Row]
	ls_nro_doc_ext		= dw_master.object.nro_doc		[ll_row]
else 
	ls_tipo_doc_ext	= ls_null
	ls_nro_doc_ext		= ls_null
end if

if ii_factor_saldo_dev = -1 or ii_factor_saldo_pres = -1 then
	ldc_cantidad	= dec(dw_master.object.cant_ingreso[ll_row])
elseif ii_factor_saldo_dev = 1 or ii_factor_saldo_pres = 1 then
	ldc_cantidad	= dec(dw_master.object.cant_salida[ll_row])
end if

ls_cod_art		= dw_master.object.cod_art[ll_row]

if ii_factor_saldo_dev <> 0 then
	// Si es una salida por devolucion obtengo la referencia a la
	// Orden de compra
	ls_doc_oc		= dw_master.object.tipo_refer [ll_row]
	ls_nro_oc		= dw_master.object.nro_refer  [ll_row]
	ls_origen_oc	= dw_master.object.origen_refer  [ll_row]
end if

//Obtengo el costo promedio
ldc_precio = Dec(dw_master.object.precio_unit[ll_row])

lstr_mov_consig.tipo_mov 		= ls_tipo_mov
lstr_mov_consig.dw_m				= dw_master
lstr_mov_consig.cencos			= is_cencos
lstr_mov_consig.cnta_prsp		= is_cnta_prsp
lstr_mov_consig.cod_maquina	= is_cod_maquina
lstr_mov_consig.flag_matriz_contab = is_flag_matriz_contab
lstr_mov_consig.cod_art			= ls_cod_art
	
OpenWithParm(w_datos_dev_pres, lstr_mov_consig)
lstr_mov_consig = Message.PowerObjectParm
	
if lstr_mov_consig.retorno = 'n' then return false

ls_matriz 		= lstr_mov_consig.matriz
ls_receptor		= lstr_mov_consig.recibido
ls_cencos		= lstr_mov_consig.cencos
ls_cnta_prsp	= lstr_mov_consig.cnta_prsp
ls_cod_maquina	= lstr_mov_consig.cod_maquina

//Obtengo el ultimo numero segun el numerador
select Count(*)
	into :ll_count
from num_vale_mov
where origen = :gs_origen;

if ll_count = 0 then
//	Lock table num_vale_mov exclusive;
	
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
where origen = :gs_origen
for update;


/**************************************************
	Generando el movimiento de almacen
**************************************************/

ls_nro_vale = trim(gs_origen) + string(ll_ult_nro, '00000000')

// Cabecera
insert into vale_mov(
	cod_origen, 	nro_vale,		almacen,			flag_estado,	fec_registro,
	tipo_mov,		cod_usr,			proveedor,		tipo_doc_int,	nro_doc_int,
	nom_receptor,	origen_refer,	tipo_refer,		nro_refer,		tipo_doc_ext,
	nro_doc_ext	)
values(
	:gs_origen,		:ls_nro_vale,	:ls_almacen,	'1',				:ldt_fecha,
	:ls_tipo_mov,	:gs_user,		:ls_proveedor,	:ls_tipo_doc_int,	:ls_nro_doc_int,
	:ls_receptor,	:ls_origen_oc,	:ls_doc_oc,		:ls_nro_oc,		:ls_tipo_doc_ext,
	:ls_nro_doc_ext	);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en Vale_mov', ls_mensaje)
	return false
end if

if ii_factor_saldo_pres <> 0 then
	SetNull(il_nro_mov_proy)
	SetNull(is_origen_mov_proy)
end if

//Detalle
insert into articulo_mov(
	cod_origen, 	flag_estado, 	cod_art, 		cant_procesada, 	precio_unit,
	cod_moneda,		matriz, 			nro_vale,		ORIGEN_MOV_PROY,	NRO_MOV_PROY,
	centro_benef	)
values(
	:gs_origen,		'1',				:ls_cod_art,	:ldc_cantidad,		:ldc_precio,
	:is_soles,		:ls_matriz,		:ls_nro_vale,	:is_origen_mov_proy, :il_nro_mov_proy,
	:ls_centro_benef);
	
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en Articulo_mov', ls_mensaje)
	return false
end if

// Grabando el vale de movimiento de almacen
dw_master.object.origen_vale  [ll_row] = gs_origen
dw_master.object.nro_vale		[ll_row] = ls_nro_vale
dw_master.ii_update = 1

// Aumento en uno el numerador
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

//Actualizo el saldo consumido si el movimiento es de ingreso
if ii_factor_saldo_dev = -1 or ii_factor_saldo_pres = -1 then
	update art_devol_prestamo
		set cant_ingreso = NVL(cant_ingreso,0) + :ldc_cantidad,
			 flag_replicacion = '1'
	where nro_mov = :is_mov_sal;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error actualizar ART_DEVOL_PRESTAMO', ls_mensaje)
		return false
	end if
end if

return true
end function

public subroutine of_retrieve (string as_nro);Long ll_row

ROLLBACK;

dw_master.retrieve(as_nro)
dw_master.ii_update = 0
ll_row = dw_master.Rowcount()

is_action = 'open'
if ll_row <> 0 then
	of_tipo_mov(dw_master.object.tipo_mov[ll_row])
	of_retrieve_mov()
	dw_master.object.p_logo.filename = gs_logo
	dw_master.ii_protect = 0
	dw_master.of_protect()
end if

return 
end subroutine

public function integer of_verifica_mov (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/

String 	ls_almacen, ls_nro_vale
long		ll_row
Integer	il_dias_holgura
str_parametros 			sl_param
str_mov_art_consig 	lstr_mov_consig

ll_row = dw_master.GetRow()
if ll_row = 0 then return 0

ls_almacen 	 = dw_master.object.almacen [ll_row]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen')
	RETURN 0
END IF
	
sl_param.tipo		 = ''
sl_param.dw_or_m	 = dw_master

//La salida por devolucion incrementa su saldo por devolver
if ii_factor_saldo_dev = 1 and is_action = 'new' then
	
	// Si tengo que devolver tengo que mostrar la orden de compra a la cual tengo que 
	// devolver
	sl_param.dw_master = 'd_sel_oc_x_devolver'      
	sl_param.dw1       = 'd_sel_oc_x_devolver_det'  
	sl_param.opcion    = 4  // Devoluciones
	sl_param.string1 	 = is_flag_contab
	sl_param.tipo		 = 'DEVOL'
	sl_param.titulo    = 'Ordenes de Compra Pendientes '
	
	OpenWithParm( w_abc_seleccion_md, sl_param)
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return 0
	
	sl_param = Message.PowerObjectParm
	
	is_origen_mov_proy 	= sl_param.field_ret[1]
	il_nro_mov_proy		= Long(sl_param.field_ret[2])
	return 1
end if

//El ingreso por devolucion debe primero mostrarme en una pantalla los saldos
//pendientes por devolver
if ii_factor_saldo_dev = -1 and is_action = 'new' then
	
	//Ingreso de Articulos por Devolucion
	sl_param.dw1       = 'd_art_proveedor_x_devolver_grd'
	sl_param.titulo    = 'Articulos de devolucion'
	sl_param.tipo		 = 'DEVOL'     // con un parametro del tipo string
	sl_param.opcion    = 9
	sl_param.dw_m		 = dw_master

	OpenWithParm( w_abc_seleccion, sl_param )
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return 0
	
	if is_action = 'new' then
		dw_master.object.cod_art.background.color = RGB(192,192,192)
		dw_master.object.cod_art.protect = 1
	end if

	lstr_mov_consig = Message.PowerObjectParm
	
	if is_action = 'new' then
		// la fecha de retorno por defecto carga la fecha actual
		dw_master.object.fec_registro[ll_row] = Today()
		
		dw_enlaces.DataObject = 'd_art_dev_pres_sal_grd'
		dw_enlaces.SetTransObject(SQLCA)
		
		ll_row = dw_enlaces.event ue_insert()
		if ll_row > 0 then
			dw_enlaces.object.nro_mov_sal [ll_row] = lstr_mov_consig.nro_mov
			is_mov_sal										= lstr_mov_consig.nro_mov	// Es el mov de salida
			dw_enlaces.object.tipo_mov		[ll_row] = lstr_mov_consig.tipo_mov
			dw_enlaces.object.cod_art 		[ll_row] = lstr_mov_consig.cod_art
			dw_enlaces.object.desc_art		[ll_row] = lstr_mov_consig.desc_art
			dw_enlaces.object.cantidad		[ll_row] = lstr_mov_consig.cantidad 
			idc_saldo_cantidad  							= lstr_mov_consig.cantidad 
		end if
		
		// Debo extraer el origen_mov_proy y el nro_mov_proy de articulo_mov
		select nro_vale
			into :ls_nro_vale
		from art_devol_prestamo
		where nro_mov = :is_mov_sal;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe movimiento en art_devol_prestamo')
			return 0
		end if
		
		if SQLCA.SQLCode < 0 then
			MessageBox('Aviso', SQLCA.SQLErrText)
			return 0 
		end if
		
		select nro_mov_proy, origen_mov_proy
			into :il_nro_mov_proy, :is_origen_mov_proy
		from articulo_mov
		where cod_art = :lstr_mov_consig.cod_art
		  and nro_vale = :ls_nro_vale;
		  
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe movimiento en articulo_mov')
			return 0
		end if
		
		if SQLCA.SQLCode < 0 then
			MessageBox('Aviso', SQLCA.SQLErrText)
			return 0
		end if
	end if
	return 1
	
end if

//El ingreso por prestamo debe primero mostrarme en una pantalla los saldos
//pendientes de loas articulos que han sido prestados.
if ii_factor_saldo_pres = -1 and is_action = 'new' then
	
	//Ingreso de Articulos por Devolucion
	sl_param.dw1       = 'd_art_proveedor_x_retorno_grd'
	sl_param.titulo    = 'Articulos prestados'
	sl_param.tipo		 = 'PRESTAMOS'     // con un parametro del tipo string
	sl_param.opcion    = 10
	sl_param.dw_m		 = dw_master

	OpenWithParm( w_abc_seleccion, sl_param )
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return 0
	
	if is_action = 'new' then
		dw_master.object.cod_art.background.color = RGB(192,192,192)
		dw_master.object.cod_art.protect = 1
	end if

	lstr_mov_consig = Message.PowerObjectParm
	
	if is_action = 'new' then
		// la fecha de retorno por defecto carga la fecha actual
		dw_master.object.fec_registro[ll_row] = Today()
		
		dw_enlaces.DataObject = 'd_art_dev_pres_sal_grd'
		dw_enlaces.SetTransObject(SQLCA)
		
		ll_row = dw_enlaces.event ue_insert()
		if ll_row > 0 then
			dw_enlaces.object.nro_mov_sal [ll_row] = lstr_mov_consig.nro_mov
			is_mov_sal										= lstr_mov_consig.nro_mov	// Es el mov de salida
			dw_enlaces.object.tipo_mov		[ll_row] = lstr_mov_consig.tipo_mov
			dw_enlaces.object.cod_art 		[ll_row] = lstr_mov_consig.cod_art
			dw_enlaces.object.desc_art		[ll_row] = lstr_mov_consig.desc_art
			dw_enlaces.object.cantidad		[ll_row] = lstr_mov_consig.cantidad 
			idc_saldo_cantidad  							= lstr_mov_consig.cantidad 
		end if
	end if
	return 1
	
end if

return 1
end function

public function string of_nro ();string	ls_nro_mov	
long		ll_ult_nro, ll_count

select count(*)
	into :ll_count
from num_art_devol_prestamo
where origen = :gs_origen;

if ll_count = 0 then
	ll_ult_nro = 1
	ls_nro_mov = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	ll_ult_nro ++
	
	insert into num_art_devol_prestamo(origen, ult_nro)
	values( :gs_origen, :ll_ult_nro);

else
	select ult_nro
		into :ll_ult_nro
	from num_art_devol_prestamo
	where origen = :gs_origen for update;
	
	ls_nro_mov = trim(gs_origen) + string(ll_ult_nro, '00000000')
	ll_ult_nro ++
	
	update num_art_devol_prestamo
	set ult_nro = :ll_ult_nro
	where origen = :gs_origen;
	
end if


return ls_nro_mov
end function

public function boolean of_actualiza ();string 	ls_centro_benef, ls_nro_vale, ls_cod_art, ls_mensaje
Long		ll_row
DEcimal	ldc_precio_unit, ldc_cantidad

ll_row = dw_master.GetRow()
if ll_row = 0 then return false

ls_centro_benef = dw_master.object.centro_benef [ll_row]
ls_nro_vale		 = dw_master.object.nro_vale	   [ll_row]
ls_cod_art		 = dw_master.object.cod_art		[ll_row]
ldc_precio_unit = Dec(dw_master.object.precio_unit [ll_row])

if ii_factor_saldo_dev = -1 or ii_factor_saldo_pres = -1 then
	ldc_cantidad	= dec(dw_master.object.cant_ingreso[ll_row])
elseif ii_factor_saldo_dev = 1 or ii_factor_saldo_pres = 1 then
	ldc_cantidad	= dec(dw_master.object.cant_salida[ll_row])
end if

update articulo_mov
   set precio_unit = :ldc_precio_unit,
		 centro_benef = :ls_centro_benef,
		 cant_procesada = :ldc_cantidad
where nro_vale = :ls_nro_vale
  and cod_art  = :ls_cod_art;

if SQLCA.SQLCode <> 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return false
end if

return true
end function

on w_al314_prest_devol.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_anular" then this.MenuID = create m_mantto_anular
this.dw_enlaces=create dw_enlaces
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_enlaces
end on

on w_al314_prest_devol.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_enlaces)
end on

event ue_open_pre;call super::ue_open_pre;of_center_window()
dw_master.object.p_logo.filename = gs_logo
ii_pregunta_delete = 1
ib_log = true

// LogParam
select 	doc_ot, doc_ss, doc_mov_almacen, cod_soles, flag_matriz_contab
	into 	:is_doc_ot, :is_doc_sl,	:is_doc_alm, :is_soles, :is_flag_matriz_contab
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros de Logistica', StopSign!)
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

If IsNull(is_doc_alm) or is_doc_alm = '' then
	MessageBox('Aviso', 'No ha definido Documento de Movimiento de almacen (doc_mov_almacen) en logparam')
	return
end if

If IsNull(is_soles) or is_soles = '' then
	MessageBox('Aviso', 'No ha definido Moneda Soles (cod_soles) en logparam')
	return
end if

If IsNull(is_flag_matriz_contab) or is_flag_matriz_contab = '' then
	MessageBox('Aviso', 'No ha definido FLGA_MATRIZ_CONTAB en logparam')
	return
end if

dw_master.object.p_logo.filename = gs_logo	
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

this.event ue_update_request()

sl_param.dw1    = 'd_sel_devol_prestamo_tbl'
sl_param.titulo = 'Devoluciones y prestamos'
sl_param.field_ret_i[1] = 2


OpenWithParm(w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
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

	is_action = 'open'
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
if f_row_Processing( dw_master, "form" ) <> true then return

dw_master.of_set_flag_replicacion()
dw_enlaces.of_set_flag_replicacion()

if is_action = 'new' then
	ls_nro_mov = of_nro()
	if ls_nro_mov = '' or IsNull(ls_nro_mov) then return
	
	dw_master.object.nro_mov [ll_row] = ls_nro_mov
	dw_master.ii_update = 1

	// Si es Ingreso, entonces creo el enlace
	if ii_factor_saldo_dev = -1 or ii_factor_saldo_pres = -1 then
		dw_enlaces.object.nro_mov_ing[1] = ls_nro_mov
		dw_enlaces.ii_update = 1
	end if
	
	//Creo el movimiento de almacen sea de ingreso o salida
	if of_crea_mov_art(ls_nro_mov) = false then return
	
else
	if dw_master.ii_update = 1 then
		//Creo el movimiento de almacen sea de ingreso o salida
		if of_actualiza() = false then return
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

	dw_master.object.proveedor.background.color = RGB(255,255,255)
	dw_master.object.proveedor.protect = 0

	dw_master.object.cod_art.background.color = RGB(255,255,255)
	dw_master.object.cod_art.protect = 0
	
	dw_master.object.cant_ingreso.background.color = RGB(192,192,192)
	dw_master.object.cant_ingreso.protect = 1

	dw_master.object.cant_salida.background.color = RGB(192,192,192)
	dw_master.object.cant_salida.protect = 1
	
	dw_master.SetColumn('Flag_dev_pres')

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

if is_action = 'open' then
	if ii_factor_saldo_dev = -1 or ii_factor_saldo_pres = -1 then
		MessageBox('Aviso', 'No puede modificar un movimiento de Ingreso')
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

event ue_update_request;// Ancestor Script has been Override"
Integer li_msg_result

IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	ELSE
		ib_update_check = TRUE
	END IF
END IF
end event

type dw_master from w_abc_master`dw_master within w_al314_prest_devol
event ue_display ( string as_columna,  long al_row )
integer width = 2574
integer height = 1300
string dataobject = "d_abc_devol_prest_ff"
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_almacen, ls_tipo_mov, ls_proveedor, ls_tipo_doc, &
			ls_cod_art, ls_codigo 
Decimal	ldc_precio			

Str_articulo lstr_articulo
this.AcceptText()

is_flag_dev_pres = this.object.flag_dev_pres[al_row]
if is_flag_dev_pres = '' or IsNull(is_flag_dev_pres ) then
	MessageBox('Aviso', 'Debe definir si una devolucion o un prestamo')
	return
end if

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
		
		if is_flag_dev_pres = 'D' then
		
			ls_sql = "Select distinct a.tipo_mov as Codigo_tipo_mov, " &
					 + "a.desc_tipo_mov as descripcion_tipo_mov " &
					 + "from articulo_mov_tipo a, " &
					 + "almacen_tipo_mov b " &
					 + "where a.tipo_mov = b.tipo_mov " &
					 + "and a.flag_estado = '1' " &
					 + "AND a.factor_sldo_dev <> 0 " &
					 + "and b.almacen = '" + ls_almacen + "' " &
					 + "order by a.tipo_mov"
					 
		elseif is_flag_dev_pres = 'P' then
			
			ls_sql = "Select distinct a.tipo_mov as Codigo_tipo_mov, " &
					 + "a.desc_tipo_mov as descripcion_tipo_mov " &
					 + "from articulo_mov_tipo a, " &
					 + "almacen_tipo_mov b " &
					 + "where a.tipo_mov = b.tipo_mov " &
					 + "and a.flag_estado = '1' " &
					 + "AND a.factor_sldo_pres <> 0 " &
					 + "and b.almacen = '" + ls_almacen + "' " &
					 + "order by a.tipo_mov"
		
		else
			MessageBox('Aviso', 'Flag no definido')
			return
		end if
		
		lb_ret = f_lista(ls_sql, ls_tipo_mov, ls_data, '1')
		
		if ls_tipo_mov <> '' then
			this.object.tipo_mov			[al_row] = ls_tipo_mov
			this.object.desc_tipo_mov	[al_row] = ls_data
			
			//Valido Tipo de movimiento
			if of_tipo_mov(ls_tipo_mov) = 0 then
				this.object.tipo_mov			[al_row] = gnvo_app.is_null
				this.object.desc_tipo_mov	[al_row] = gnvo_app.is_null
				return
			end if
			
			this.ii_update = 1
		end if
		
		return

	case "proveedor"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO_PROVEEDOR, " &
				  + "NOM_PROVEEDOR AS DESCRIPCION_PROVEEDOR " &
				  + "FROM PROVEEDOR " &
				  + "where FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_proveedor, ls_data, '1')
		
		if ls_proveedor <> '' then
			this.object.proveedor		[al_row] = ls_proveedor
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "cod_art"

		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
		
		if lstr_articulo.b_Return then
			// Si es un prestamo y ademas es una salida por prestamo
			// tengo que verificar si tengo saldo en almacen
			ls_cod_art = lstr_articulo.cod_art

			if is_flag_dev_pres = 'P' and ii_factor_saldo_pres = 1 then
				ls_almacen = this.object.almacen [al_row]
				if IsNull(ls_almacen) or ls_almacen = '' then
					MessageBox('Aviso', 'Primero defina el almacen', StopSign!)
					return
				end if

				select sldo_total, costo_prom_sol
					into :idc_saldo_almacen, :ldc_precio
				from articulo_almacen
				where cod_art = :ls_cod_art
				  and almacen  = :ls_almacen;
				
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'No existe el articulo: ' + ls_cod_art &
									+ ' en almacen: ' + ls_almacen)
					return
				end if
				
				if SQLCA.SQLCode < 0 then
					MessageBox('Aviso', SQLCA.SQLErrText)
					return
				end if
				
				if idc_saldo_almacen = 0 then
					MessageBox('Aviso', 'El saldo en almacen ' + ls_almacen &
								+ ' es cero')
					return
				end if
			end if
			this.object.cod_art		[al_row] = ls_cod_art
			this.object.desc_art		[al_row] = lstr_articulo.desc_art
			this.object.precio_unit [al_row] = ldc_precio
			this.ii_update = 1
		END IF
		
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

	case 'centro_benef'
		ls_sql = "SELECT centro_benef AS CODIGO_CenBef, " &
				  + "desc_centro AS DESCRIPCION_centro_benef " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1' " 
					 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef[al_row] = ls_codigo
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
is_action = 'new'

//of_set_status_doc(dw_master)
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc_art, ls_desc, ls_codigo, ls_mensaje, ls_almacen, &
			ls_flav_dev_pres, ls_cod_art, ls_data
decimal	ldc_null, ldc_precio

SetNull( ls_null)
SetNull( ldc_null)
This.AcceptText()

choose case lower(dwo.name)
	case "flag_dev_pres"
		this.object.tipo_mov			[row] = ls_null
		this.object.desc_tipo_mov	[row] = ls_null
		return
		
	case "cod_art"
		
		// Verifico si el articulo es inventariable
		if f_articulo_inventariable( data ) <> 1 then 
			this.object.cod_art		[row] = ls_null
			this.object.desc_art		[row] = ls_null
			this.object.precio_unit	[row] = ldc_null
			return 1
		end if

		if is_flag_dev_pres = 'P' and ii_factor_saldo_pres = 1 then
			
			is_flag_dev_pres = this.object.flag_dev_pres[row]
			if is_flag_dev_pres = '' or IsNull(is_flag_dev_pres) then
				MessageBox('Aviso', 'Debe definir si una devolucion o un prestamo')
				return
			end if
			
			ls_almacen = this.object.almacen [row]
			if IsNull(ls_almacen) or ls_almacen = '' then
				MessageBox('Aviso', 'Primero defina el almacen', StopSign!)
				return
			end if
			
			ls_cod_art = data
			
			select sldo_total, costo_prom_sol
				into :idc_saldo_almacen, :ldc_precio
			from articulo_almacen
			where cod_art  = :ls_cod_art
			  and almacen  = :ls_almacen;
				
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'No existe el articulo: ' + ls_cod_art &
								+ ' en almacen: ' + ls_almacen)
				return
			end if
				
			if SQLCA.SQLCode < 0 then
				MessageBox('Aviso', SQLCA.SQLErrText)
				return
			end if
				
			if idc_saldo_almacen = 0 then
				MessageBox('Aviso', 'El saldo en almacen ' + ls_almacen &
							+ ' es cero')
				return
			end if
		end if
				
		// Verifica que codigo ingresado exista			
		Select desc_art
			into :ls_desc_art
		from articulo 
		Where cod_art = :data;			
				
		this.object.desc_art		[row] = ls_desc_art
		this.object.precio_unit	[row] = ldc_precio
		return
		
	case "cantidad"
		//Si es una salida por devolucion no debe sobrepasar la cantidad que esta 
		//en la orden de compra y tampoco del saldo disponbile en almacen
		if ii_factor_saldo_dev = 1 then
			if dec(data) > idc_saldo_cantidad then
				this.object.cant_ingreso	[row] = ldc_null
				MessageBox('Aviso', 'No pude devolver mas de la cantidad comprada')
				return 1
			end if
		end if
		
		//Si es una salida debo validarlo contra el saldo disponible
		//en almacen
		if ii_factor_saldo_dev = 1 or ii_factor_saldo_pres = 1 then
			if dec(data) > idc_saldo_almacen then
				this.object.cant_ingreso	[row] = ldc_null
				MessageBox('Aviso', 'No pude retirar mas de lo disponible en almacen' &
							+ '~r~n Saldo en almacen: ' + string(idc_saldo_almacen) )
				return 1
			end if
		end if
		return


	case "almacen"
		select desc_almacen
		 	into :ls_desc
		from almacen
		where almacen = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 or SQLCA.SQLCode < 0 then
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de almacen no existe o no esta activo')
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
		else
			this.object.tipo_mov 		[row] = ls_null
			this.object.desc_tipo_mov 	[row] = ls_null
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
		
	case "centro_benef"
		
		select desc_centro
			into :ls_data
		from centro_beneficio
		where centro_benef = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Centro de Beneficio no existe o no está activo", StopSign!)
			this.object.centro_benef	[row] = ls_null
			return 1
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

type dw_enlaces from u_dw_abc within w_al314_prest_devol
integer y = 1308
integer width = 2565
integer height = 600
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_art_dev_pres_sal_grd"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

