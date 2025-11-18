$PBExportHeader$w_cm312_orden_compra_automatica.srw
forward
global type w_cm312_orden_compra_automatica from w_abc
end type
type sle_nro from u_sle_codigo within w_cm312_orden_compra_automatica
end type
type st_2 from statictext within w_cm312_orden_compra_automatica
end type
type rb_4 from radiobutton within w_cm312_orden_compra_automatica
end type
type cb_2 from commandbutton within w_cm312_orden_compra_automatica
end type
type cb_mostrar from commandbutton within w_cm312_orden_compra_automatica
end type
type st_3 from statictext within w_cm312_orden_compra_automatica
end type
type em_fecproy from editmask within w_cm312_orden_compra_automatica
end type
type sle_3 from singlelineedit within w_cm312_orden_compra_automatica
end type
type cbx_imp from checkbox within w_cm312_orden_compra_automatica
end type
type cb_1 from commandbutton within w_cm312_orden_compra_automatica
end type
type st_7 from statictext within w_cm312_orden_compra_automatica
end type
type st_31 from statictext within w_cm312_orden_compra_automatica
end type
type st_21 from statictext within w_cm312_orden_compra_automatica
end type
type st_5 from statictext within w_cm312_orden_compra_automatica
end type
type sle_fecha from singlelineedit within w_cm312_orden_compra_automatica
end type
type tab_1 from tab within w_cm312_orden_compra_automatica
end type
type tabpage_1 from userobject within tab_1
end type
type dw_oc from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_oc dw_oc
end type
type tabpage_2 from userobject within tab_1
end type
type dw_oc_det from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_oc_det dw_oc_det
end type
type tab_1 from tab within w_cm312_orden_compra_automatica
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type st_1 from statictext within w_cm312_orden_compra_automatica
end type
type rb_2 from radiobutton within w_cm312_orden_compra_automatica
end type
type rb_1 from radiobutton within w_cm312_orden_compra_automatica
end type
type dw_articulos from u_dw_abc within w_cm312_orden_compra_automatica
end type
type gb_1 from groupbox within w_cm312_orden_compra_automatica
end type
type sle_cencos from singlelineedit within w_cm312_orden_compra_automatica
end type
type sle_cnta_prsp from singlelineedit within w_cm312_orden_compra_automatica
end type
type gb_2 from groupbox within w_cm312_orden_compra_automatica
end type
type cb_cta from commandbutton within w_cm312_orden_compra_automatica
end type
type gb_3 from groupbox within w_cm312_orden_compra_automatica
end type
end forward

global type w_cm312_orden_compra_automatica from w_abc
integer width = 3826
integer height = 2904
string title = "Orden de compra Automática (CM312)"
string menuname = "m_mantenimiento_oc_automatica"
windowstate windowstate = maximized!
event ue_generar_oc ( )
sle_nro sle_nro
st_2 st_2
rb_4 rb_4
cb_2 cb_2
cb_mostrar cb_mostrar
st_3 st_3
em_fecproy em_fecproy
sle_3 sle_3
cbx_imp cbx_imp
cb_1 cb_1
st_7 st_7
st_31 st_31
st_21 st_21
st_5 st_5
sle_fecha sle_fecha
tab_1 tab_1
st_1 st_1
rb_2 rb_2
rb_1 rb_1
dw_articulos dw_articulos
gb_1 gb_1
sle_cencos sle_cencos
sle_cnta_prsp sle_cnta_prsp
gb_2 gb_2
cb_cta cb_cta
gb_3 gb_3
end type
global w_cm312_orden_compra_automatica w_cm312_orden_compra_automatica

type variables
String 	is_tipo, is_doc_oc, is_cencos_mat, &
			is_cnta_prsp_mat, is_oper_ing_oc, is_cod_igv, &
			is_oper_cons_int, is_flag_cntrl_fondos, is_doc_ot, &
			is_FLAG_RESTRIC_COMP_OC
Date 		id_fecha_proc
Decimal 	in_tipo_cambio, idc_tasa_igv
u_dw_abc 	idw_oc, idw_oc_det
end variables

forward prototypes
public function string of_numero_oc ()
public function integer of_datos_presup (string as_parm)
public function integer of_set_status_doc ()
public function boolean of_set_articulo (string as_cod_art, string as_almacen, long al_row)
public function boolean of_set_articulo (string as_cod_art, long al_row)
end prototypes

event ue_generar_oc();// Proceso para generar ordenes de compra
String 	ls_cod_art, ls_proveedor, ls_nro, ls_origen, ls_pago, &
 	  		ls_nom_prov, ls_moneda, ls_cad, ls_nro_oc, ls_cencos, &
			ls_cnta_prsp, ls_almacen, ls_observacion, ls_nro_cotiza
Decimal 	ldc_precio, ldc_total, ldc_cant_proyect, &
			ldc_porc_dsct, ldc_porc_imp, ldc_saldo
Decimal{4} ldc_dscto, ldc_impuesto			
Long 		ll_row, ll_found, ll_roc, ll_roc_d
DateTime	ldt_hoy

ldt_hoy = f_fecha_actual()

//dw_articulos.SetSort("proveedor A, forma_pago A")
//dw_articulos.Sort()

for ll_row = 1 to dw_articulos.RowCount()
	ls_cod_art 			= dw_articulos.object.cod_art 			[ll_row]
	ls_proveedor 		= dw_articulos.object.proveedor 			[ll_row]
	ls_pago		   	= dw_articulos.object.forma_pago			[ll_row]
	ls_moneda			= dw_articulos.object.cod_moneda			[ll_row]
	ldc_porc_dsct		= Dec(dw_articulos.object.descto			[ll_row])
	ldc_precio			= DEc(dw_articulos.object.precio_unit	[ll_row])
	ldc_porc_imp 		= dec(dw_articulos.object.impuesto		[ll_row])
	ldc_cant_proyect 	= Dec(dw_articulos.object.cant_proyect	[ll_row])
	ls_cencos			= dw_articulos.object.cencos				[ll_row]
	ls_cnta_prsp		= dw_articulos.object.cnta_prsp 			[ll_row]
	ls_almacen 			= dw_articulos.object.almacen				[ll_row]
	ls_nro_cotiza		= dw_articulos.object.nro_cotiza			[ll_row]


	if IsNull(ldc_porc_dsct) then ldc_porc_dsct = 0
	IF IsNull(ldc_porc_imp) then ldc_porc_dsct = 0
	if IsNull(ldc_cant_proyect) then ldc_cant_proyect = 0
  	
	// Total de descuento
	ldc_dscto = ldc_precio * ldc_porc_dsct / 100
	ldc_impuesto = (ldc_precio - ldc_dscto) * ldc_cant_proyect * ldc_porc_imp / 100
	ldc_total = (ldc_precio - ldc_dscto) * ldc_cant_proyect + ldc_impuesto

	// Busca proveedor si ya tiene o/compra
	idw_oc.AcceptText()
	
	ls_cad = "proveedor = '" + ls_proveedor + "' and forma_pago = '" + &
	   ls_pago + "' and cod_moneda = '" + ls_moneda + "'"
	ll_found = idw_oc.Find(ls_Cad,1, idw_oc.RowCount())			
	
	
	// Adiciona datos en cabecera
	if ll_found = 0 then   // Nuevo
		ll_roc = idw_oc.event dynamic ue_insert()
		if ll_roc <= 0 then 
			ROLLBACK;
			return
		end if
		
		ls_observacion = 'COTIZACION(ES):' + ls_nro_cotiza
		ls_nro_oc = of_numero_oc()
		
		Select nom_proveedor 
			into :ls_nom_prov 
		from proveedor
		Where proveedor = :ls_proveedor;
		
		idw_oc.object.cod_origen		[ll_roc] = gs_origen
		idw_oc.object.nro_oc				[ll_roc] = ls_nro_oc
		idw_oc.object.flag_estado		[ll_roc] = '1'
		idw_oc.object.flag_cotizacion	[ll_roc] = '1'
		if cbx_imp.checked = true then
			idw_oc.object.flag_importacion[ll_roc] = '1'
		else
			idw_oc.object.flag_importacion[ll_roc] = '0'
		end if
		
		idw_oc.object.proveedor			[ll_roc] = ls_proveedor
		idw_oc.object.nom_proveedor	[ll_roc] = ls_nom_prov
		idw_oc.object.fec_registro		[ll_roc] = ldt_hoy
		idw_oc.object.forma_pago		[ll_roc] = ls_pago
		idw_oc.object.cod_moneda		[ll_roc] = ls_moneda
		idw_oc.object.monto_total		[ll_roc] = ldc_total
		idw_oc.object.observacion		[ll_roc] = ls_observacion
		idw_oc.object.cod_usr			[ll_roc] = gs_user		
	else
		ls_nro_oc = idw_oc.object.nro_oc [ll_found]
		
		idw_oc.object.monto_total[ll_found] = Dec(idw_oc.object.monto_total[ll_found]) + ldc_total
		
		ls_observacion = idw_oc.object.observacion [ll_found]
		
		if pos(ls_observacion, ls_nro_cotiza, 1) = 0 then
			ls_observacion = ls_observacion + ', ' + ls_nro_cotiza
			idw_oc.object.observacion		[ll_roc] = ls_observacion
		end if
	end if

	idw_oc.AcceptText()
	idw_oc.ii_update = 1  // Activo Flag para actualizar datos
	
	// Inserta items en el detalle
	//----------------------------
	ll_roc_d = idw_oc_det.event dynamic ue_insert()
	if ll_roc_d <= 0 then 
		ROLLBACK;
		return
	end if
	
	
	select NVL(sldo_total, 0)
	  into :ldc_saldo
	  from articulo_almacen
	 where cod_art = :ls_cod_art
	   and almacen = :ls_almacen;
	
	if ISNull(ldc_saldo) then ldc_saldo = 0
	
	idw_oc_det.object.cod_origen			[ll_roc_d] = gs_origen
	idw_oc_det.object.flag_estado			[ll_roc_d] = '1'
	idw_oc_det.object.cod_art				[ll_roc_d] = ls_cod_art
	idw_oc_det.object.tipo_doc				[ll_roc_d] = is_doc_oc
	idw_oc_det.object.nro_doc				[ll_roc_d] = ls_nro_oc
	idw_oc_det.object.fec_registro		[ll_roc_d] = id_fecha_proc
	idw_oc_det.object.fec_proyect			[ll_roc_d] = DATE( em_fecproy.text)
	idw_oc_det.object.cant_proyect		[ll_roc_d] = dw_articulos.object.cant_proyect	[ll_row]
	idw_oc_det.object.cant_pendiente		[ll_roc_d] = dw_articulos.object.cant_pendiente	[ll_row]
	idw_oc_det.object.precio_unit			[ll_roc_d] = dw_articulos.object.precio_unit		[ll_row]
	idw_oc_det.object.impuesto1			[ll_roc_d] = ldc_impuesto
	idw_oc_det.object.tipo_impuesto1		[ll_roc_d] = is_cod_igv
	idw_oc_det.object.decuento				[ll_roc_d] = ldc_dscto
	idw_oc_det.object.porc_dscto			[ll_roc_d] = ldc_porc_dsct
	idw_oc_det.object.almacen				[ll_roc_d] = dw_articulos.object.almacen		[ll_row]
	idw_oc_det.object.desc_art				[ll_roc_d] = dw_articulos.object.desc_art		[ll_row]
	idw_oc_det.object.und					[ll_roc_d] = dw_articulos.object.und			[ll_row]
	idw_oc_det.object.origen_ref			[ll_roc_d] = dw_articulos.object.origen_ref	[ll_row]
	idw_oc_det.object.tipo_ref				[ll_roc_d] = dw_articulos.object.tipo_ref		[ll_row]
	idw_oc_det.object.referencia			[ll_roc_d] = dw_articulos.object.nro_ref		[ll_row]
	idw_oc_det.object.item_ref				[ll_roc_d] = dw_articulos.object.item_ref		[ll_row]
	idw_oc_det.object.org_amp_ref			[ll_roc_d] = dw_articulos.object.org_amp_ref	[ll_row]
	idw_oc_det.object.nro_amp_ref			[ll_roc_d] = dw_articulos.object.nro_amp_ref	[ll_row]
	idw_oc_det.object.oper_sec				[ll_roc_d] = dw_articulos.object.oper_sec		[ll_row]
	idw_oc_det.object.cod_usr				[ll_roc_d] = gs_user
	idw_oc_det.object.cod_moneda			[ll_roc_d] = ls_moneda
	idw_oc_det.object.flag_modificacion	[ll_roc_d] = '1'
	idw_oc_det.object.cencos				[ll_roc_d] = ls_cencos
	idw_oc_det.object.cnta_prsp			[ll_roc_d] = ls_cnta_prsp
	idw_oc_det.object.saldo_almacen		[ll_roc_d] = ldc_saldo
	idw_oc_det.object.cant_procesada		[ll_roc_d] = 0
	idw_oc_det.object.cant_facturada		[ll_roc_d] = 0
	
	idw_oc_det.ii_update = 1
	
next

idw_oc.ii_protect = 0
idw_oc.of_protect()

idw_oc_det.ii_protect = 0
idw_oc_det.of_protect()


end event

public function string of_numero_oc ();// Devuelve el ultimo numero de la orden de compra

Long 		ll_ult_nro
string 	ls_exec, ls_null, ls_mensaje

SetNull(ls_null)

Select ult_nro 
	into :ll_ult_nro 
from num_ord_comp 
where origen = :gs_origen for update;

IF SQLCA.SQLCode = 100 then
	ls_exec = 'LOCK TABLE NUM_ORD_COMP IN EXCLUSIVE MODE'
	
	Execute immediate :ls_exec;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return ls_null
	end if
	
	Insert into Num_ord_comp(origen, ult_nro )
	values(gs_origen , 1);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return ls_null
	end if
	
	ll_ult_nro = 1
end if

update num_ord_comp
   set ult_nro = ult_nro + 1
where origen = :gs_origen;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return ls_null
end if

return gs_origen + String( ll_ult_nro, '00000000')
end function

public function integer of_datos_presup (string as_parm);if TRIM(em_fecproy.text) = ''  THEN
	Messagebox( "Atencion", "Ingrese Fecha proyectada")
	em_fecproy.SetFocus()
	return 0
end if

if as_parm = 'P' then  // evalua datos de presupuesto
	if TRIM(sle_cencos.text) = '' THEN
		Messagebox( "Atencion", "Ingrese el centro de costo")
		sle_cencos.SetFocus()
		return 0
	end if

	if TRIM(sle_cnta_prsp.text) = '' THEN
		Messagebox( "Atencion", "Ingrese la cuenta presupuestal")
		sle_cnta_prsp.SetFocus()
		return 0
	end if
end if
return 1
end function

public function integer of_set_status_doc ();/*
  Funcion que verifica el status del documento
*/
this.changemenu( m_mantenimiento_oc_automatica)

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if rb_4.checked = false then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

return 1
end function

public function boolean of_set_articulo (string as_cod_art, string as_almacen, long al_row);string 	ls_cod_clase, ls_proveedor, ls_nro, &
			ls_origen, ls_cod_mon, ls_pago, ls_nro_cotizacion
date		ld_hoy
Long		ll_count
Decimal 	ldc_precio, ldc_descto

ld_hoy = Date(f_fecha_actual())

if sle_nro.text = '' then
	ls_nro_cotizacion = '%%'
else
	ls_nro_cotizacion = trim(sle_nro.text) + '%'
end if

select count(*)
  into :ll_count
from 	cotizacion						c1,
		cotizacion_provee 			c2, 
		cotizacion_provee_bien_det c3
Where c1.nro_cotiza = c2.nro_cotiza
  and c2.nro_cotiza = c3.nro_cotiza 
  and c2.proveedor  = c3.proveedor
  and NVL(c1.flag_estado, '0') 	= '1'
  and NvL(c3.flag_ganador, '0') 	= '1'
  and NvL(c2.cotizo, '0') 			= '1'
  and NVL(c3.precio_unit, 0)		> 0
  and c3.cod_art 						= :as_cod_art
  and c1.nro_cotiza					like :ls_nro_cotizacion
  and trunc(c2.fec_vigencia) 		<= trunc(:ld_hoy); 

if ll_count = 0 then
	MessageBox('Aviso', 'Codigo de Articulo ' + as_cod_art + ' no tiene Cotizacion Activa o vigente, por favor verifique')
	return false
end if

if ll_count > 1 and ls_nro_cotizacion <> '%%' then
	MessageBox('Aviso', 'Ha declarado mas de un ganador para el articulo ' + as_cod_art +', Cotizacion ' + sle_nro.text)
	return false
end if

// Busca datos de cotizacion vigente
Select c2.proveedor, c2.nro_cotiza, c2.cod_origen, 
		 c2.cod_moneda, c2.forma_pago, c3.precio_unit,
		 NVL(c3.decuento,0)
  into :ls_proveedor, :ls_nro, :ls_origen, :ls_cod_mon, 
		 :ls_pago, :ldc_precio, :ldc_descto
from 	cotizacion						c1,
		cotizacion_provee 			c2, 
		cotizacion_provee_bien_det c3
Where c1.nro_cotiza = c2.nro_cotiza
  and c2.nro_cotiza = c3.nro_cotiza 
  and c2.proveedor  = c3.proveedor
  and NVL(c1.flag_estado, '0') 	= '1'
  and NvL(c3.flag_ganador, '0') 	= '1'
  and NvL(c2.cotizo, '0') 			= '1'
  and NVL(c3.precio_unit, 0)		> 0
  and c3.cod_art 						= :as_cod_art
  and c1.nro_cotiza					like :ls_nro_cotizacion
  and trunc(c2.fec_vigencia) 		<= trunc(:ld_hoy)
order by c2.fec_registro desc  ;  

dw_articulos.object.proveedor		[al_row] = ls_proveedor
dw_articulos.object.cod_origen	[al_row] = ls_origen
dw_articulos.object.nro_cotiza	[al_row] = ls_nro
dw_articulos.object.forma_pago	[al_row] = ls_pago
dw_articulos.object.cod_moneda	[al_row] = ls_cod_mon
dw_articulos.object.precio_unit	[al_row] = ldc_precio
dw_articulos.object.descto			[al_row] = ldc_descto
dw_articulos.object.almacen 		[al_row] = as_almacen


return true
end function

public function boolean of_set_articulo (string as_cod_art, long al_row);string 	ls_almacen, ls_cod_clase, ls_proveedor, ls_nro, &
			ls_origen, ls_cod_mon, ls_pago, ls_nro_cotizacion
date		ld_hoy
Long		ll_count
Decimal 	ldc_precio, ldc_descto

ld_hoy = Date(f_fecha_actual())

if sle_nro.text = '' then
	ls_nro_cotizacion = '%%'
else
	ls_nro_cotizacion = trim(sle_nro.text) + '%'
end if

select count(*)
  into :ll_count
from 	cotizacion						c1,
		cotizacion_provee 			c2, 
		cotizacion_provee_bien_det c3
Where c1.nro_cotiza = c2.nro_cotiza
  and c2.nro_cotiza = c3.nro_cotiza 
  and c2.proveedor  = c3.proveedor
  and NVL(c1.flag_estado, '0') 	= '1'
  and NvL(c3.flag_ganador, '0') 	= '1'
  and NvL(c2.cotizo, '0') 			= '1'
  and NVL(c3.precio_unit, 0)		> 0
  and c3.cod_art 						= :as_cod_art
  and c1.nro_cotiza					like :ls_nro_cotizacion
  and trunc(c2.fec_vigencia) 		<= trunc(:ld_hoy); 

if ll_count = 0 then
	MessageBox('Aviso', 'Codigo de Articulo ' + as_cod_art + ' no tiene Cotizacion Activa o vigente, por favor verifique')
	return false
end if

if ll_count > 1 and ls_nro_cotizacion <> '%%' then
	MessageBox('Aviso', 'Ha declarado mas de un ganador para el articulo ' + as_cod_art +', Cotizacion ' + sle_nro.text)
	return false
end if

// Busca datos de cotizacion vigente
Select c2.proveedor, c2.nro_cotiza, c2.cod_origen, 
		 c2.cod_moneda, c2.forma_pago, c3.precio_unit,
		 NVL(c3.decuento,0)
  into :ls_proveedor, :ls_nro, :ls_origen, :ls_cod_mon, 
		 :ls_pago, :ldc_precio, :ldc_descto
from 	cotizacion						c1,
		cotizacion_provee 			c2, 
		cotizacion_provee_bien_det c3
Where c1.nro_cotiza = c2.nro_cotiza
  and c2.nro_cotiza = c3.nro_cotiza 
  and c2.proveedor  = c3.proveedor
  and NVL(c1.flag_estado, '0') 	= '1'
  and NvL(c3.flag_ganador, '0') 	= '1'
  and NvL(c2.cotizo, '0') 			= '1'
  and NVL(c3.precio_unit, 0)		> 0
  and c3.cod_art 						= :as_cod_art
  and c1.nro_cotiza					like :ls_nro_cotizacion
  and trunc(c2.fec_vigencia) 		<= trunc(:ld_hoy)
order by c2.fec_registro desc  ;  

dw_articulos.object.proveedor		[al_row] = ls_proveedor
dw_articulos.object.cod_origen	[al_row] = ls_origen
dw_articulos.object.nro_cotiza	[al_row] = ls_nro
dw_articulos.object.forma_pago	[al_row] = ls_pago
dw_articulos.object.cod_moneda	[al_row] = ls_cod_mon
dw_articulos.object.precio_unit	[al_row] = ldc_precio
dw_articulos.object.descto			[al_row] = ldc_descto

// Almacen Tacito
if IsNull(dw_articulos.object.almacen [al_row]) or &
	trim(dw_articulos.object.almacen [al_row]) = '' then
	
	select cod_clase 
		into :ls_cod_clase
	from articulo
	where cod_art = :as_cod_art;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Codigo de Articulo ' + as_cod_art + ' no existe')
		return false
	end if
	
	if IsNull(ls_cod_clase) or ls_cod_clase = '' then
		MessageBox('Aviso', 'Articulo ' + as_cod_art + ' no esta enlazado a ninguna clase')
		return false
	end if
	
	select almacen
	  into :ls_almacen
	from almacen_tacito
	where cod_origen = :gs_origen
	  and cod_clase  = :ls_cod_clase;
	
	if SQLCA.SQLCode = 100 then SetNull(ls_almacen)
	
	dw_articulos.object.almacen [al_row] = ls_almacen
end if

return true
end function

on w_cm312_orden_compra_automatica.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_oc_automatica" then this.MenuID = create m_mantenimiento_oc_automatica
this.sle_nro=create sle_nro
this.st_2=create st_2
this.rb_4=create rb_4
this.cb_2=create cb_2
this.cb_mostrar=create cb_mostrar
this.st_3=create st_3
this.em_fecproy=create em_fecproy
this.sle_3=create sle_3
this.cbx_imp=create cbx_imp
this.cb_1=create cb_1
this.st_7=create st_7
this.st_31=create st_31
this.st_21=create st_21
this.st_5=create st_5
this.sle_fecha=create sle_fecha
this.tab_1=create tab_1
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_articulos=create dw_articulos
this.gb_1=create gb_1
this.sle_cencos=create sle_cencos
this.sle_cnta_prsp=create sle_cnta_prsp
this.gb_2=create gb_2
this.cb_cta=create cb_cta
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rb_4
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_mostrar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_fecproy
this.Control[iCurrent+8]=this.sle_3
this.Control[iCurrent+9]=this.cbx_imp
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.st_7
this.Control[iCurrent+12]=this.st_31
this.Control[iCurrent+13]=this.st_21
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.sle_fecha
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.rb_2
this.Control[iCurrent+19]=this.rb_1
this.Control[iCurrent+20]=this.dw_articulos
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.sle_cencos
this.Control[iCurrent+23]=this.sle_cnta_prsp
this.Control[iCurrent+24]=this.gb_2
this.Control[iCurrent+25]=this.cb_cta
this.Control[iCurrent+26]=this.gb_3
end on

on w_cm312_orden_compra_automatica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.st_2)
destroy(this.rb_4)
destroy(this.cb_2)
destroy(this.cb_mostrar)
destroy(this.st_3)
destroy(this.em_fecproy)
destroy(this.sle_3)
destroy(this.cbx_imp)
destroy(this.cb_1)
destroy(this.st_7)
destroy(this.st_31)
destroy(this.st_21)
destroy(this.st_5)
destroy(this.sle_fecha)
destroy(this.tab_1)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_articulos)
destroy(this.gb_1)
destroy(this.sle_cencos)
destroy(this.sle_cnta_prsp)
destroy(this.gb_2)
destroy(this.cb_cta)
destroy(this.gb_3)
end on

event resize;call super::resize;idw_oc = tab_1.tabpage_1.dw_oc
idw_oc_det = tab_1.tabpage_2.dw_oc_det

dw_articulos.width  = newwidth  - dw_articulos.x - 10
st_1.x = dw_articulos.x
st_1.width = dw_articulos.width

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_oc.width  = tab_1.width  - idw_oc.x - 80
idw_oc.height = tab_1.height  - idw_oc.x - 150

idw_oc_det.width  = tab_1.width  - idw_oc_det.x - 80
idw_oc_det.height = tab_1.height - idw_oc_det.x - 150

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (idw_oc.ii_update = 1 OR idw_oc_det.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_oc.ii_update = 0
		idw_oc_det.ii_update = 0
		ROLLBACK USING SQLCA;
	END IF
END IF

end event

event ue_update;Boolean lbo_ok = TRUE

idw_oc.AcceptText()
idw_oc_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF	idw_oc.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_oc.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF idw_oc_det.ii_update = 1 THEN
	IF idw_oc_det.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_oc.ii_update = 0
	idw_oc_det.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing(idw_oc, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing(idw_oc_det, "tabular") <> true then	return

//of_set_status_flag()
idw_oc.of_set_flag_replicacion()
idw_oc_det.of_set_flag_replicacion()
ib_update_check = true
end event

event ue_open_pre;// busca tipo de documento en parametros
string	ls_mensaje

Select doc_oc, oper_ing_oc, COD_IGV, OPER_CONS_INTERNO, doc_ot,
		 NVL(FLAG_CNTRL_FONDOS, '0'), NVL(FLAG_RESTRIC_COMP_OC, '0')
	into :is_doc_oc, :is_oper_ing_oc, :is_cod_igv, :is_oper_cons_int,
		  :is_doc_ot, :is_flag_cntrl_fondos, :is_flag_restric_comp_oc
from logparam 
where reckey = '1';

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return
end if

IF SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'No ha definido parametros en logistica')
	return
end if

If IsNull(is_doc_oc) or is_doc_oc = '' then
	MessageBox('Aviso', 'No ha definido documento de Orden de Compra en Logparam')
	return
end if

If IsNull(is_oper_ing_oc) or is_oper_ing_oc = '' then
	MessageBox('Aviso', 'No ha definido Operacion Ingreso x Compras en Logparam')
	return
end if

If IsNull(is_oper_cons_int) or is_oper_cons_int = '' then
	MessageBox('Aviso', 'No ha definido Operacion x Consumo Interno en Logparam')
	return
end if

If IsNull(is_doc_ot) or is_doc_ot = '' then
	MessageBox('Aviso', 'No ha definido Tipo de Documento OT en Logparam')
	return
end if

If IsNull(is_cod_igv) or is_cod_igv = '' then
	MessageBox('Aviso', 'No ha definido Codigo de IGV en Logparam')
	return
end if

select NVL(tasa_impuesto,0)
	into :idc_tasa_igv
from impuestos_tipo
where tipo_impuesto = :is_cod_igv;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe Tasa de IGV en Impuestos_tipo')
	return
end if

if idc_tasa_igv = 0 then
	MessageBox('Error', 'No ha definido tasa de impuesto del IGV')
	return
end if

select cencos_oc, cnta_prsp_oc
	into :is_cencos_mat, :is_cnta_prsp_mat
from origen
where cod_origen = :gs_origen;

If IsNull(is_cencos_mat) or is_cencos_mat = '' then
	MessageBox('Aviso', 'No ha definido Centro de Costo de Compras para el origen')
	return
end if

If IsNull(is_cnta_prsp_mat) or is_cnta_prsp_mat = '' then
	MessageBox('Aviso', 'No ha definido Cuenta Presupuestal de Compras para el origen')
	return
end if

sle_cencos.text 		= is_Cencos_mat
sle_cnta_prsp.text 	= is_cnta_prsp_mat
id_fecha_proc			= Date(f_fecha_actual())
sle_fecha.text 		= String(id_fecha_proc, 'dd/mm/yyyy')
em_fecproy.text 		= String(id_fecha_proc, 'dd/mm/yyyy')
rb_1.checked = true
of_set_status_doc()


end event

event open;// Ancestor Script has been Override
idw_oc = tab_1.tabpage_1.dw_oc
idw_oc_det = tab_1.tabpage_2.dw_oc_det

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF rb_4.checked = false THEN
	MessageBox("Error", "opcion no valida")
	RETURN
END IF

ll_row = dw_articulos.Event ue_insert()
end event

event ue_delete;//Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = dw_articulos.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_print;call super::ue_print;string 	ls_org_oc, ls_nro_oc
decimal	ldc_vb, ldc_dscto, ldc_imp, ldc_vn
w_cm311_orden_compra_frm lw_oc
str_parametros lstr_param

if idw_oc.GetRow() = 0 then return

ls_org_oc = idw_oc.object.cod_origen[idw_oc.GetRow()]
ls_nro_oc = idw_oc.object.nro_oc		[idw_oc.GetRow()]

lstr_param.string1 = ls_org_oc
lstr_param.string2 = ls_nro_oc

select sum(round(cant_proyect * precio_unit,2)),
		 sum(round(cant_proyect * decuento,2)),
		 sum(round(impuesto,2))
  into :ldc_vb, :ldc_dscto, :ldc_imp
  from articulo_mov_proy amp
 where amp.nro_doc = :ls_nro_oc
	and amp.tipo_doc = (select doc_oc from logparam where reckey = '1')
	and amp.flag_estado <> '0';

ldc_vn = ldc_vb - ldc_dscto + ldc_imp

lstr_param.d_datos[1] = ldc_vb
lstr_param.d_datos[2] = ldc_dscto
lstr_param.d_datos[3] = ldc_imp
lstr_param.d_datos[4] = ldc_vn

OpenSheetWithParm(lw_oc, lstr_param, w_main, 0, Layered!)

end event

type sle_nro from u_sle_codigo within w_cm312_orden_compra_automatica
event ue_dobleclick pbm_lbuttondblclk
integer x = 389
integer y = 240
integer width = 366
integer height = 72
integer taborder = 100
integer textsize = -8
string pointer = "H:\source\CUR\taladro.cur"
end type

event ue_dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
Date		ld_hoy

ld_hoy = Date(f_fecha_actual())

ls_sql = "SELECT distinct a.nro_cotiza AS numero_cotizacion, " &
		  + "a.cod_usr AS codigo_usuario, " &
		  + "a.observaciones as obs_cotizacion " &
		  + "FROM cotizacion a, " &
		  + "cotizacion_provee b, " &
		  + "cotizacion_provee_bien_det c " &
		  + "where a.nro_cotiza = b.nro_cotiza " &
		  + "and b.nro_cotiza = c.nro_cotiza " &
		  + "and b.proveedor = c.proveedor " &
		  + "and NVL(c.flag_ganador,'0') = '1' " &
		  + "and NVL(a.flag_estado, '1') = '1' " &
		  + "and NVL(c.precio_unit,0) > 0 " &
		  + "and trunc(b.fec_vigencia) <= to_date('" + string(ld_hoy, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
	dw_articulos.Reset()
	idw_oc.Reset()
	idw_oc.ii_update = 0
	
	idw_oc_det.Reset()
	idw_oc_det.ii_update = 0
end if

end event

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;dw_articulos.Reset()
idw_oc.Reset()
idw_oc.ii_update = 0

idw_oc_det.Reset()
idw_oc_det.ii_update = 0
end event

type st_2 from statictext within w_cm312_orden_compra_automatica
integer x = 18
integer y = 240
integer width = 361
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Cotizacion:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_4 from radiobutton within w_cm312_orden_compra_automatica
integer x = 1326
integer y = 204
integer width = 626
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Catálogo de Articulos"
end type

event clicked;cb_mostrar.enabled = false
of_set_status_doc()
end event

type cb_2 from commandbutton within w_cm312_orden_compra_automatica
integer x = 3077
integer y = 144
integer width = 421
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar OC"
end type

event clicked;parent.event dynamic ue_generar_oc()
this.enabled = false
end event

type cb_mostrar from commandbutton within w_cm312_orden_compra_automatica
integer x = 3077
integer y = 24
integer width = 421
integer height = 104
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar datos"
end type

event clicked;// Asigna valores a structura 
Date  	ld_fecha
String	ls_nro_cotizacion
str_parametros sl_param, lstr_param

if sle_nro.text = '' then
	ls_nro_cotizacion = '%%'
else
	ls_nro_cotizacion    = trim(sle_nro.text) + '%'
end if

IF rb_1.checked = true then  	// Programa de compras

	SetNull(lstr_param.fecha1)
	SetNull(lstr_param.fecha2)
	lstr_param.nro_cotizacion 		= ls_nro_cotizacion
	lstr_param.flag_oc_automatico = '1'
	lstr_param.titulo 				= 'Datos de Programas de Compras'
	lstr_param.tipo 					= 'PROG_COMPRAS'
	
	OpenWithParm( w_abc_datos_ot, lstr_param )
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
	
	if is_FLAG_RESTRIC_COMP_OC = '1' then
		lstr_param.dw_master 	= "d_list_prog_oc_automatico_usuario_tbl"
		lstr_param.dw1 			= 'd_sel_prog_oc_automatico_usuario_det'
	else
		lstr_param.dw_master 	= "d_list_prog_oc_automaticas_pend_tbl"
		lstr_param.dw1 			= 'd_sel_prog_oc_atumaticas_pend_det'
	end if
	
	lstr_param.titulo 		= "Programas de compra pendientes"
	lstr_param.dw_m 			= idw_oc
	lstr_param.dw_d 			= dw_articulos
	lstr_param.string6		= gs_user
	lstr_param.flag_cntrl_fondos	= is_flag_cntrl_fondos
	lstr_param.tipo			= 'COTIZA_PROG'
	lstr_param.nro_cotizacion 		= ls_nro_cotizacion
	lstr_param.flag_oc_automatico = '1'
	lstr_param.w1 = parent
	
	if is_FLAG_RESTRIC_COMP_OC = '1' then
		lstr_param.opcion 		= 18	
	else
		lstr_param.opcion 		= 8	
	end if
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
elseIF rb_2.checked = true then  	// Ordenes de Trabajo
	
	// Datos Para buscar en las OTs
	SetNull(lstr_param.fecha1)
	SetNull(lstr_param.fecha2)
	lstr_param.nro_cotizacion 		= ls_nro_cotizacion
	lstr_param.flag_oc_automatico = '1'
	lstr_param.titulo 				= 'Datos de la Orden de Trabajo'
	lstr_param.tipo 					= ''
	
	OpenWithParm( w_abc_datos_ot, lstr_param )
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
	
	lstr_param.dw_master 	= "d_list_ot_oc_automatico_grd"
	lstr_param.dw1       	= "d_list_amp_ot_oc_automatico_grd"	
	lstr_param.titulo 		= "Ordenes de Trabajo pendientes"
	lstr_param.dw_m 			= idw_oc
	lstr_param.dw_d 			= dw_articulos
	lstr_param.tipo_doc		= is_doc_ot
	lstr_param.opcion 		= 17
	lstr_param.tipo			= 'COTIZA_OT'
	lstr_param.oper_cons_interno = is_oper_cons_int
	lstr_param.flag_cntrl_fondos = is_flag_cntrl_fondos
	lstr_param.nro_cotizacion	  = ls_nro_cotizacion
	lstr_param.flag_oc_automatico = '1'
	lstr_param.w1 = parent

	OpenWithParm( w_abc_seleccion_md, lstr_param)	
	
else
	MessageBox('Aviso', 'Debe indicar alguna referencia')
	return
end if

if idw_oc.RowCount() > 0 then
	// Desactiva otros objetos
	rb_1.enabled = false
	rb_2.enabled = false
end if
end event

type st_3 from statictext within w_cm312_orden_compra_automatica
integer x = 18
integer y = 156
integer width = 361
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fec. Entrega:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecproy from editmask within w_cm312_orden_compra_automatica
integer x = 389
integer y = 152
integer width = 311
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

event modified;// Si modifica dato, actualizar detalle
Long j

For j = 1 to idw_oc_det.RowCount()
	idw_oc_det.object.fec_proyect[j] = DATE( em_fecproy.text)
Next
end event

type sle_3 from singlelineedit within w_cm312_orden_compra_automatica
event dobleclick pbm_lbuttondblclk
integer x = 846
integer y = 152
integer width = 311
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT job AS CODIGO_job, " &
		  + "DESCripcion AS DESCRIPCION_job " &
		  + "FROM job " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if

end event

type cbx_imp from checkbox within w_cm312_orden_compra_automatica
integer x = 745
integer y = 56
integer width = 343
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Importacion:"
boolean lefttext = true
end type

type cb_1 from commandbutton within w_cm312_orden_compra_automatica
integer x = 2866
integer y = 60
integer width = 82
integer height = 84
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_parametros sl_param
Long ln_ano

if sle_cencos.enabled = false then return // protegido
ln_ano = YEAR( DATE( em_fecproy.text ))
sl_param.dw1 = "d_sel_cencos_segun_presup"   //"d_dddw_cencos"
sl_param.titulo = "Centro de Costos"
sl_param.field_ret_i[1] = 1
sl_param.tipo = '1I'
sl_param.int1 = ln_ano

OpenWithParm( w_search, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then		
	sle_cencos.text = sl_param.field_ret[1]
END IF
end event

type st_7 from statictext within w_cm312_orden_compra_automatica
integer x = 731
integer y = 160
integer width = 110
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Job:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_31 from statictext within w_cm312_orden_compra_automatica
integer x = 2062
integer y = 160
integer width = 430
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta. Presupuestal:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_21 from statictext within w_cm312_orden_compra_automatica
integer x = 2089
integer y = 72
integer width = 402
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_cm312_orden_compra_automatica
integer x = 18
integer y = 76
integer width = 361
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fec Registro:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_fecha from singlelineedit within w_cm312_orden_compra_automatica
integer x = 389
integer y = 64
integer width = 311
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_cm312_orden_compra_automatica
integer y = 1240
integer width = 3593
integer height = 704
integer taborder = 130
integer textsize = -9
integer weight = 700
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

event selectionchanged;String ls_filtro, ls_nro_oc

if newindex = 2 then // Detalle de o/compra
	if idw_oc.GetRow() <= 0 then return
	
	ls_nro_oc = idw_oc.object.nro_oc[idw_oc.GetRow()]
	
	idw_oc_det.SetFilter("nro_doc='" + ls_nro_oc + "'")
	idw_oc_det.Filter( )
	idw_oc_det.Groupcalc( )
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 108
integer width = 3557
integer height = 580
long backcolor = 79741120
string text = "O/Compra Generadas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_oc dw_oc
end type

on tabpage_1.create
this.dw_oc=create dw_oc
this.Control[]={this.dw_oc}
end on

on tabpage_1.destroy
destroy(this.dw_oc)
end on

type dw_oc from u_dw_abc within tabpage_1
integer width = 3054
integer height = 540
integer taborder = 90
string dataobject = "d_abc_o_compra_cab_aut"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'

THIS.SetTransObject(sqlca)
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event clicked;call super::clicked;IF row > 0 then
	//change redraw to avoid flicker
	this.setredraw(false)
	
	this.SelectRow(0,False)
	this.SelectRow(row,True)
	this.setfocus()

	this.setredraw(true)
END IF
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;is_action = 'new'
end event

event ue_output;call super::ue_output;string ls_nro_oc
if al_row <= 0 then return

ls_nro_oc = this.object.nro_oc[al_row]

idw_oc_det.SetFilter("nro_doc='" + ls_nro_oc + "'")
idw_oc_det.Filter( )
idw_oc_det.Groupcalc( )

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 108
integer width = 3557
integer height = 580
long backcolor = 79741120
string text = "Detalle de O/Compra"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_oc_det dw_oc_det
end type

on tabpage_2.create
this.dw_oc_det=create dw_oc_det
this.Control[]={this.dw_oc_det}
end on

on tabpage_2.destroy
destroy(this.dw_oc_det)
end on

type dw_oc_det from u_dw_abc within tabpage_2
integer width = 3168
integer height = 556
integer taborder = 20
string dataobject = "d_abc_o_compra_det_211"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1	
is_dwform = 'tabular'

this.settransobject(sqlca)
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_tipo_mov

this.object.tipo_doc		[al_row] = is_doc_oc
this.object.cod_origen	[al_row] = gs_origen
this.object.flag_estado	[al_row] = '1'
	
// Busca tipo de igv
String ls_cod_igv
	
Select cod_igv, oper_ing_oc
	into :ls_cod_igv, :ls_tipo_mov
from logparam 
where reckey = 1;
	
// Segun tipo busca tasa
Decimal ld_tasa
Select tasa_impuesto 
	into :ld_tasa 
from impuestos_tipo 
where tipo_impuesto = :ls_cod_igv;

this.object.tipo_impuesto1	[al_row] = ls_cod_igv
this.object.impuesto1		[al_row] = 0.00
	
if isnull( ls_tipo_mov ) or trim( ls_tipo_mov ) = '' then 
	Messagebox( "Error","Definir tipo de movimiento de ingreso por compra")
	return
end if
	
this.object.tipo_mov[al_row] = ls_tipo_mov
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type st_1 from statictext within w_cm312_orden_compra_automatica
integer y = 384
integer width = 3259
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 10789024
string text = "Articulos a procesar"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_cm312_orden_compra_automatica
integer x = 1326
integer y = 136
integer width = 526
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Trabajo"
end type

event clicked;cb_mostrar.enabled = true
of_set_status_doc()
end event

type rb_1 from radiobutton within w_cm312_orden_compra_automatica
integer x = 1326
integer y = 68
integer width = 590
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Programa Compras"
end type

event clicked;cb_mostrar.enabled = true
of_set_status_doc()
end event

type dw_articulos from u_dw_abc within w_cm312_orden_compra_automatica
event ue_insert_pos ( )
event ue_display ( string as_columna,  long al_row )
integer y = 464
integer width = 3593
integer height = 752
integer taborder = 120
string dataobject = "d_inp_orden_compra_aut"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);str_parametros	sl_param
string ls_sql, ls_codigo, ls_data

choose case lower(as_columna)
		
	case "cod_art"
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		if of_set_articulo(sl_param.field_ret[1], al_row) = false then return
		
		IF sl_param.titulo <> 'n' then
			this.object.cod_art	[al_row] = sl_param.field_ret[1]
			this.object.desc_art	[al_row] = sl_param.field_ret[2]
			this.object.und		[al_row] = sl_param.field_ret[3]		
			
			this.ii_update = 1
		END IF
		
	case 'almacen'
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				 + "DESC_almacen AS DESCRIPCION_almacen " &
				 + "FROM almacen " &
				 + "where flag_estado = '1'"
					 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
			
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.ii_update = 1
		end if		
	
		
end choose
end event

event constructor;call super::constructor;ii_ck[1] = 1	
is_dwform = 'tabular'
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;string ls_null, ls_desc_art, ls_und

SetNull(ls_null)
this.AcceptText()

IF dwo.name = "cod_art" then
	// Busca codigo
	if of_set_articulo(data, row) = false then return 1
	
	if gnvo_app.almacen.of_articulo_inventariable( data ) <> 1 then 
		this.object.cod_art	[row] = ls_null
		this.object.desc_art	[row] = ls_null
		this.object.und		[row] = ls_null
		
		return 1
	end if

	Select desc_art, und 
		into :ls_desc_art, :ls_und 
	from articulo 
	Where cod_Art = :data;
	
	this.object.desc_Art	[row] = ls_desc_art
	this.object.und		[row] = ls_und		
	
end if
end event

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row(this)
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.impuesto [al_row] = idc_tasa_igv
this.object.cencos	[al_row] = sle_cencos.text
this.object.cnta_prsp[al_row] = sle_cnta_prsp.text


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

type gb_1 from groupbox within w_cm312_orden_compra_automatica
integer x = 1298
integer width = 727
integer height = 344
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencias"
end type

type sle_cencos from singlelineedit within w_cm312_orden_compra_automatica
integer x = 2505
integer y = 60
integer width = 352
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;// Valida c.costo
Long ll_count
String ls_cencos

ls_cencos = this.text

Select count(cencos) 
	into :ll_count 
from centros_costo 
where cencos = :ls_cencos
  and flag_estado = '1';
	
if ll_count = 0 then	
	Messagebox( 'Error', 'Centro de costo no existe o no esta activo, Verifique')
	SetNull(ls_cencos)
	this.text = ls_cencos
	return
end if

// Si modifica dato, actualizar detalle
Long j

For j = 1 to idw_oc_det.RowCount()
	idw_oc_det.object.cencos[j] = sle_cencos.text
	idw_oc_det.ii_update = 1
Next
end event

type sle_cnta_prsp from singlelineedit within w_cm312_orden_compra_automatica
integer x = 2505
integer y = 148
integer width = 352
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;// Valida c.costo
Long ll_count
String ls_cnta_prsp

ls_cnta_prsp = this.text

Select count(cnta_prsp) 
	into :ll_count 
from presupuesto_cuenta 
where cnta_prsp = :ls_cnta_prsp;
	
if ll_count = 0 then	
	Messagebox( 'Error', 'Cuenta presupuestal no existe')
	SetNull(ls_cnta_prsp)
	this.text = ls_cnta_prsp
end if

// Si modifica dato, actualizar detalle
Long j

For j = 1 to idw_oc_det.RowCount()
	idw_oc_det.object.cnta_prsp[j] = ls_cnta_prsp
Next
end event

type gb_2 from groupbox within w_cm312_orden_compra_automatica
integer x = 2034
integer width = 937
integer height = 344
integer taborder = 150
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Afectacion Presupuestal"
end type

type cb_cta from commandbutton within w_cm312_orden_compra_automatica
integer x = 2866
integer y = 148
integer width = 82
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_parametros sl_param

//if sle_ccosto.enabled = false then return // protegido

sl_param.dw1 = "d_sel_cnta_presup_saldos"  
sl_param.titulo = "Cuentas Presupuestales"
sl_param.field_ret_i[1] = 1
sl_param.tipo = 'CP'  // indicador para que ejecute proc. 
sl_param.string1 = sle_cencos.text
sl_param.int1 = MONTH( DATE( em_fecproy.text))
sl_param.int2 = YEAR( DATE( em_fecproy.text))
OpenWithParm( w_search, sl_param)

sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then		
	sle_cnta_prsp.text = sl_param.field_ret[1]		
END IF		

end event

type gb_3 from groupbox within w_cm312_orden_compra_automatica
integer width = 1289
integer height = 344
integer taborder = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Otros"
end type

