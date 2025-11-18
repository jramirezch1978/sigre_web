$PBExportHeader$w_ve300_orden_venta.srw
forward
global type w_ve300_orden_venta from w_abc_mastdet
end type
type st_ori from statictext within w_ve300_orden_venta
end type
type sle_ori from singlelineedit within w_ve300_orden_venta
end type
type st_nro from statictext within w_ve300_orden_venta
end type
type cb_buscar from commandbutton within w_ve300_orden_venta
end type
type sle_nro from u_sle_codigo within w_ve300_orden_venta
end type
type gb_1 from groupbox within w_ve300_orden_venta
end type
end forward

global type w_ve300_orden_venta from w_abc_mastdet
integer width = 3776
integer height = 2364
string title = "[VE300] Orden de Venta"
string menuname = "m_mtto_lista"
windowstate windowstate = maximized!
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
event ue_cerrar ( )
st_ori st_ori
sle_ori sle_ori
st_nro st_nro
cb_buscar cb_buscar
sle_nro sle_nro
gb_1 gb_1
end type
global w_ve300_orden_venta w_ve300_orden_venta

type variables
String 	is_tipo_doc = '', is_desc_error, is_soles, &
			is_doc_ov, is_oper_vnta_terc, is_cod_igv, is_flag_Cnta_prsp, &
			is_salir, is_CENCOS_PRSP_ING
DEcimal	idc_tasa_igv			
DateTime id_fecha_proc
Long 		in_tipo_cambio
Boolean 	ib_ok

dataStore ids_print
end variables

forward prototypes
public function integer of_set_cliente (string as_cliente)
public function integer of_set_status_doc (datawindow idw)
public function integer of_valida_cabecera ()
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_set_numera ()
public function boolean of_set_articulo (string as_cod_art)
public function integer of_get_param ()
public subroutine of_set_modify ()
public function integer of_call_procedure_temp ()
end prototypes

event ue_anular;Integer 	li_j
Decimal	ldc_cant_procesada, ldc_cant_facturada
Long		ll_row

if dw_master.rowcount() = 0 then return

ldc_cant_facturada = 0
for ll_row = 1 to dw_detail.RowCount( )
	ldc_cant_facturada += Dec(dw_detail.object.cant_facturada[ll_row])
next

if ldc_cant_facturada > 0 then
	MessageBox('Aviso', 'No puede Anular la Orden de Venta ya que tiene cantidad facturada')
	dw_master.ii_protect = 0
	dw_detail.ii_protect = 0
	dw_master.of_protect() // protege el dw
	dw_detail.of_protect() // protege el dw
	return
end if


IF dw_master.object.flag_estado[dw_master.GetRow()] <> '1' THEN
	MessageBox('Aviso', 'No puede anular esta orden de venta')
	RETURN
END IF

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Verificando que no haya sido despachado
ldc_cant_procesada = 0
for li_j = 1 to dw_detail.rowCount()
	ldc_cant_procesada += dec(dw_detail.object.cant_procesada[li_j])
next

if ldc_cant_procesada > 0 then
	MessageBox('Aviso', 'No se puede anular una ORDEN DE VENTA si ests despachada')
	return
end if

// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1

// Anulando Detalle
for li_j = 1 to dw_detail.rowCount()
	dw_detail.object.flag_estado	[li_j] = '0'
	dw_detail.object.cant_proyect	[li_j] = 0
	dw_detail.object.precio_unit	[li_j] = 0
	dw_detail.ii_update = 1
next

is_action = 'anu'
of_set_status_doc(dw_master)

end event

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()

is_Action = ''
of_set_status_doc(dw_master)

end event

event ue_preview();// vista previa de Orden de Venta
//str_parametros lstr_rep
//
//if dw_master.rowcount() = 0 then return
//
//lstr_rep.dw1 = 'd_rpt_orden_venta'
//lstr_rep.titulo = 'Previo de Orden de Venta'
//lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
//lstr_rep.string2 = dw_master.object.nro_ov[dw_master.getrow()]
//
//OpenSheetWithParm(w_ve300_orden_venta_frm, lstr_rep, w_main, 0, Layered!)
end event

event ue_cerrar();Long ll_row, ll_i
ll_row = dw_master.GetRow( )

IF ll_row = 0 THEN
	MessageBox('Error', 'No ha definido una cebecera de Orden de Venta')
	Return
END IF

IF dw_master.object.flag_estado[ll_row] = '0' THEN
	MessageBox('Aviso', 'No puede cerrar esta Orden de Venta porque esta anulada')
	Return
END IF
	
IF is_action = 'new' THEN
	MessageBox('Aviso', 'No puede cerrar esta Orden de Venta porque recien la esta haciendo')
	Return
END IF

dw_master.object.flag_estado [ll_row] = '2'
dw_master.ii_update = 1
	
FOR ll_i = 1 TO dw_detail.RowCount()
	dw_detail.object.flag_estado [ll_i] = '2'
	dw_detail.ii_update = 1
NEXT
	

end event

public function integer of_set_cliente (string as_cliente);String ls_des_cliente, ls_ruc, ls_null
Long ll_row

ll_row = dw_master.getrow()

SELECT NOM_PROVEEDOR, NVL(RUC,' ')
  INTO :ls_des_cliente, :ls_ruc
  FROM proveedor
 WHERE PROVEEDOR = :as_cliente ;

IF SQLCA.SQLCODE <> 0 THEN
	dw_master.Object.cliente [ll_row] = ''
	Messagebox('Aviso','Debe Ingresar Un Codigo de Cliente Valido')
	RETURN 0
END IF		
				
//dw_master.object.destinatario[ll_row] = TRIM(ls_des_cliente)
dw_master.object.nom_proveedor	[ll_row] = TRIM(ls_des_cliente)
dw_master.object.proveedor_ruc	[ll_row] = TRIM(ls_ruc)
dw_master.object.nom_comprador	[ll_row] = TRIM(ls_des_cliente)
dw_master.object.comprador_final	[ll_row] = as_cliente
Return 1
end function

public function integer of_set_status_doc (datawindow idw);Int 	li_estado
long	ll_row
String ls_est_det

This.changemenu( m_mtto_lista)

// Activa todas las opciones
m_master.m_file.m_basedatos.m_insertar.enabled 		= f_niveles( is_niveles, 'I')  // true
m_master.m_file.m_basedatos.m_eliminar.enabled 		= f_niveles( is_niveles, 'E')  //true
m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') 
m_master.m_file.m_basedatos.m_anular.enabled 		= f_niveles( is_niveles, 'A') 
m_master.m_file.m_basedatos.m_abrirlista.enabled 	= True
m_master.m_file.m_basedatos.m_cancelar.enabled 		= True
m_master.m_file.m_printer.m_print1.enabled			= True
m_master.m_file.m_basedatos.m_GRABAR.enabled 		= True

IF dw_master.getrow() = 0 THEN RETURN 0
IF dw_detail.getrow() = 0 THEN RETURN 0

IF is_Action = 'new' THEN
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
	m_master.m_file.m_basedatos.m_modificar.enabled 	= False
	m_master.m_file.m_basedatos.m_anular.enabled 		= False
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
	m_master.m_file.m_printer.m_print1.enabled 			= False
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= False
	IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = False
	ELSE
		m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')
		m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')
	END IF	
END IF

IF is_Action = 'open' THEN
	li_estado = Long( dw_master.object.flag_estado[dw_master.getrow()])

	CHOOSE CASE li_estado
		CASE 0		// Anulado			
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= False
			m_master.m_file.m_basedatos.m_modificar.enabled = False
			m_master.m_file.m_basedatos.m_anular.enabled 	= False
			
//		CASE 1	  // Generado
//			IF idw = dw_detail THEN
//				ll_row = idw.getrow()
//				m_master.m_file.m_basedatos.m_modificar.enabled = f_niveles( is_niveles, 'M')
			
//			IF idw.object.cant_procesada[ll_row] > 0 THEN
//					idw.object.cant_proyect.Protect = 1  // Protege columna
//					idw.object.cod_art.Protect  	  = 1
//				ELSE
//					idw.object.cant_proyect.Protect = 0
//					idw.object.cod_art.Protect  	  = 0
//				END IF
				
//				IF idw.object.cant_facturada[ll_row] > 0 THEN
//					idw.object.cant_proyect.Protect 	= 1
//					idw.object.precio_unit.Protect 	= 1					
//					idw.object.decuento.Protect 		= 1
//					idw.object.impuesto.Protect 		= 1
//					idw.object.cod_art.Protect			= 1
//				ELSE
//					idw.object.cant_proyect.Protect 	= 0
//					idw.object.precio_unit.Protect 	= 0					
//					idw.object.decuento.Protect 		= 0
//					idw.object.impuesto.Protect 		= 0
// 					idw.object.cod_art.Protect			= 1
//				END IF
				
//				ls_est_det = idw.object.flag_estado [ll_row]  // estado del detalle
//						
//				IF ls_est_det = '1' AND idw.object.cant_procesada[ll_row] = 0 THEN  // Protege o no la fecha proyectada
//					idw.object.fec_proyect.Protect = 0
//				ELSE
//					idw.object.fec_proyect.Protect = 1
//				END IF
//				
//			END IF	
		
		CASE 2,3   // Atendido parcial, total
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= False
			m_master.m_file.m_basedatos.m_modificar.enabled = False
			m_master.m_file.m_basedatos.m_anular.enabled 	= False
			IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento			
				m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')
			ELSE			
				m_master.m_file.m_basedatos.m_insertar.enabled = False
			END IF
	
			IF idw = dw_detail THEN
				ll_row = idw.getrow()
				m_master.m_file.m_basedatos.m_modificar.enabled = f_niveles( is_niveles, 'M')
		
//				IF idw.object.cant_procesada[ll_row] > 0 THEN
//					idw.object.cant_proyect.Protect = 1  // Protege columna
//					idw.object.cod_art.Protect  	  = 1
//				ELSE
//					idw.object.cant_proyect.Protect = 0
//					idw.object.cod_art.Protect  	  = 0
//				END IF
//				
//				IF idw.object.cant_facturada[ll_row] > 0 THEN
//					idw.object.cant_proyect.Protect 	= 1
//					idw.object.precio_unit.Protect 	= 1					
//					idw.object.decuento.Protect 		= 1
//					idw.object.impuesto.Protect 		= 1
//					idw.object.cod_art.Protect  	   = 1
//				ELSE
//					idw.object.cant_proyect.Protect 	= 0
//					idw.object.precio_unit.Protect 	= 0					
//					idw.object.decuento.Protect 		= 0
//					idw.object.impuesto.Protect 		= 0
//					idw.object.cod_art.Protect  	   = 0
//				END IF
//				
//				ls_est_det = idw.object.flag_estado [ll_row]  // estado del detalle
//						
//				IF ls_est_det = '1' AND idw.object.cant_procesada[ll_row] = 0 THEN  // Protege o no la fecha proyectada
//					idw.object.fec_proyect.Protect = 0
//				ELSE
//					idw.object.fec_proyect.Protect = 1
//				END IF
				
//				ls_est_det = idw.object.flag_estado [ll_row]
				
//				IF ls_est_det = '1' THEN  // Protege o no la fecha proyectada
//					idw.object.fec_proyect.Protect = 0
//				ELSE
//					idw.object.fec_proyect.Protect = 1
//				END IF
				
			END IF			
			
	END CHOOSE
END IF

IF is_Action = 'anu' THEN	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
	m_master.m_file.m_basedatos.m_modificar.enabled 	= False
	m_master.m_file.m_basedatos.m_anular.enabled 		= False
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
	m_master.m_file.m_basedatos.m_insertar.enabled 		= False	
	m_master.m_file.m_printer.m_print1.enabled 			= False
//	m_master.m_file.m_basedatos.m_cerrar.enabled 		= False
END IF

RETURN 1

end function

public function integer of_valida_cabecera ();String ls_doc_ov, ls_oper_vnta_terc, ls_cod_igv, ls_mon, ls_cod_rel, &
   ls_forpago, ls_dest, ls_part, ls_val
Double ln_tasa

ls_cod_rel = dw_master.object.cliente[dw_master.getrow()]
if isnull( ls_cod_rel) or TRIM( ls_cod_rel) = '' then
	Messagebox( "Atencion", "ingrese el cliente")
	dw_master.Setcolumn( 'cliente')
	dw_master.SetFocus()
	Return 0
end if

ls_forpago = dw_master.object.forma_pago[dw_master.getrow()]
if isnull( ls_forpago) or TRIM( ls_forpago) = '' then
	Messagebox( "Atencion", "ingrese la forma de pago")
	dw_master.Setcolumn( 'forma_pago')
	dw_master.SetFocus()	
	Return 0
end if

ls_mon = dw_master.object.cod_moneda[dw_master.getrow()]
if isnull( ls_mon) or TRIM( ls_mon) = '' then
	Messagebox( "Atencion", "ingrese la moneda")
	dw_master.Setcolumn( 'cod_moneda')
	dw_master.SetFocus()	
	Return 0
end if
ls_part = dw_master.object.punto_partida[dw_master.getrow()]
if isnull( ls_part) or TRIM( ls_part) = '' then
	Messagebox( "Atencion", "ingrese el punto de partida")
	dw_master.Setcolumn( 'punto_partida')
	dw_master.SetFocus()	
	Return 0
end if
ls_dest = dw_master.object.destino[dw_master.getrow()]
if isnull( ls_dest) or TRIM( ls_dest) = '' then
	Messagebox( "Atencion", "ingrese el destino")
	dw_master.Setcolumn( 'destino')
	dw_master.SetFocus()	
	Return 0
end if


ls_val = dw_master.object.comprador_final[dw_master.getrow()]
if isnull( ls_val) or TRIM( ls_val) = '' then
	Messagebox( "Atencion", "ingrese el comprador final")
	dw_master.Setcolumn( 'comprador_final')
	dw_master.SetFocus()
	Return 0
end if

ls_val = dw_master.object.forma_embarque[dw_master.getrow()]
if isnull( ls_val) or TRIM( ls_val) = '' then
	Messagebox( "Atencion", "ingrese la forma de embarque")
	dw_master.Setcolumn( 'forma_embarque')
	dw_master.SetFocus()	
	Return 0
end if

ls_val = dw_master.object.flag_mercado[dw_master.getrow()]
if isnull( ls_val) or TRIM( ls_val) = '' then
	Messagebox( "Atencion", "ingrese tipo de mercado")
	dw_master.Setcolumn( 'flag_mercado')
	dw_master.SetFocus()	
	Return 0
end if

return 1
end function

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)
is_action = 'open'

if ll_row > 0 then		
	dw_detail.retrieve( is_doc_ov, as_nro)
	of_set_status_doc( dw_master )
end if
dw_master.il_row = ll_row

dw_master.ii_protect = 0
dw_master.of_protect()
dw_master.ii_update = 0

dw_detail.ii_protect = 0
dw_detail.of_protect()
dw_detail.ii_update = 0

return 


end subroutine

public function integer of_set_numera ();// Numera documento
Long j
String  ls_next_nro

if dw_master.getrow() = 0 then return 1

if is_action = 'new' then
	ls_next_nro = f_numera_documento('num_orden_venta',9)
	dw_master.object.nro_ov[dw_master.getrow()] = ls_next_nro
else
	ls_next_nro = dw_master.object.nro_ov[dw_master.getrow()] 
end if
// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_doc[j] = ls_next_nro
next

return 1
end function

public function boolean of_set_articulo (string as_cod_art);string 	ls_almacen, ls_cod_clase , ls_proveedor, ls_cliente, ls_tipo_precio, &
			ls_moneda , ls_origen	 , ls_cencos_gasto
date		ld_fec_reg, ld_fecha
decimal	ldc_precio_pactado, ldc_precio, ldc_cambio
// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if dw_master.GetRow() = 0 then return false

ld_fec_reg = Date(dw_master.object.fec_registro[dw_master.GetRow()])
ls_origen  = dw_master.object.cod_origen [dw_master.getrow()]

// Almacen Tacito
select cod_clase 
	into :ls_cod_clase
from articulo
where cod_art = :as_cod_art;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Codigo de Articulo no existe')
	return false
end if

if IsNull(ls_cod_clase) or ls_cod_clase = '' then
	MessageBox('Aviso', 'Articulo ' + as_cod_art + ' no esta enlazado a ninguna clase')
	return false
end if

select almacen
  into :ls_almacen
from almacen_tacito
where cod_origen = :gnvo_app.is_origen
  and cod_clase  = :ls_cod_clase;

if SQLCA.SQLCode = 100 then SetNull(ls_almacen)

dw_detail.object.almacen [dw_detail.GetRow()] = ls_almacen

// Precio del Articulo
// Busca precio segun cliente
ls_cliente = dw_master.object.cliente[dw_master.getrow()]
Select flag_tipo_precio 
	into :ls_tipo_precio 
from proveedor 
where proveedor = :ls_cliente;				
			
// Verifica tipo de precio, segun cliente
Choose case ls_tipo_precio
	case '1'   // Mayorista
		Select precio_mayorista, cod_moneda  
			into :ldc_precio, :ls_moneda 
		from articulo_venta 
		Where cod_Art = :as_cod_art;
	case '2'   // Minorista
		Select precio_minorista, cod_moneda  
			into :ldc_precio, :ls_moneda 
		from articulo_venta 
		Where cod_Art = :as_cod_art;
	case '3'   // Distribuidor
		Select precio_distribuidor, cod_moneda  
			into :ldc_precio, :ls_moneda 
		from articulo_venta 
		Where cod_Art = :as_cod_art;
	case '4'   // Supermercado
		Select precio_supermercado, cod_moneda  
			into :ldc_precio, :ls_moneda 
		from articulo_venta 
		Where cod_Art = :as_cod_art;				
end choose				
			
if ls_moneda <> dw_master.object.cod_moneda[dw_master.getrow()] then
	ld_fecha = Date( dw_master.object.fec_registro[dw_master.getrow()])
	Select cmp_dol_prom 
		into :ldc_cambio 
	from calendario 				
	where fecha = :ld_fecha;				
	// busca el tipo de cambio
	if ls_moneda = is_soles then
		ldc_precio = ldc_precio / ldc_cambio
	else
		ldc_precio = ldc_precio * ldc_cambio
	end if
end if

dw_detail.object.precio_unit[dw_detail.GetRow()] = ldc_precio	

/*busco centro de costo gasto */
select cencos into :ls_cencos_gasto from articulo_ccosto_gasto
 where cod_art     = :as_cod_art and
 		 cod_origen	 = :ls_origen  and
		 flag_estado = '1' ;


dw_detail.object.cencos_gasto[dw_detail.GetRow()] = ls_cencos_gasto
 



return true
end function

public function integer of_get_param ();// busca datos
SELECT doc_ov, oper_vnta_terc, cod_igv, cod_soles, CENCOS_PRSP_ING
  INTO :is_doc_ov, :is_oper_vnta_terc, :is_cod_igv, 
 	 	 :is_soles, :is_CENCOS_PRSP_ING
FROM logparam 
where reckey = '1';
		  
// Busca tipo documento de venta
IF ISNULL( is_doc_ov) or TRIM( is_doc_ov) = '' THEN
	Messagebox( "Error", "Defina tipo de documento de venta")
	ib_ok = false
	Return 0
end if

// Verifica que exista el tipo de movimiento de venta
IF ISNULL( is_oper_vnta_terc) or TRIM( is_oper_vnta_terc) = '' THEN
	Messagebox( "Error", "Defina tipo operacion de venta")
	ib_ok = false
	Return 0
end if

IF ISNULL( is_cod_igv) or TRIM( is_cod_igv) = '' THEN
	Messagebox( "Error", "Defina igv")
	Return 0
end if

IF ISNULL( is_soles) or TRIM( is_soles) = '' THEN
	Messagebox( "Error", "Defina Cod Soles en LogParam")
	Return 0
end if

// Segun impuesto, lo busca en tabla
Select tasa_impuesto 
	into :idc_tasa_igv
from impuestos_tipo 
where tipo_impuesto = :is_cod_igv;

IF ISNULL( idc_tasa_igv) or idc_tasa_igv = 0 THEN
	Messagebox( "Error", "Defina tipo de impuesto")
	Return 0
end if	 		  

//Parametros de presupuesto
select NVL(flag_restr_cencos_usr,'0')
	into :is_flag_cnta_prsp
from presup_param
where llave = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en Presupuesto')
	return 0
end if

if is_flag_cnta_prsp = '' or IsNull(is_flag_cnta_prsp) then
	MessageBox('Aviso', 'No ha definido flag_mod_cnta_prsp en Presup_param')
	return 0
end if
 
return 1
end function

public subroutine of_set_modify ();//string ls_nro_programa

//Cantidad Proyectada
dw_detail.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_cantidad) or IsNull(flag_precio),1,0)'")
dw_detail.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

//Fecha Proyectada
dw_detail.Modify("fec_proyect.Protect ='1~tIf(IsNull(flag_mod_fec),1,0)'")
dw_detail.Modify("fec_proyect.Background.color ='1~tIf(IsNull(flag_mod_fec), RGB(192,192,192),RGB(255,255,255))'")

//Codigo de Articulo
dw_detail.Modify("cod_art.Protect ='1~tIf(IsNull(flag_cantidad) or IsNull(flag_precio),1,0)'")
dw_detail.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

//Precio Unitario
dw_detail.Modify("precio_unit.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("precio_unit.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Precio Venta
dw_detail.Modify("precio_venta.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("precio_venta.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//% Descuento
dw_detail.Modify("porc_dscto.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("porc_dscto.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Monto Descuento
dw_detail.Modify("decuento.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("decuento.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//% IGV
dw_detail.Modify("porc_impuesto.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("porc_impuesto.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Monto Impuesto
dw_detail.Modify("impuesto.Protect ='1~tIf(IsNull(flag_precio),1,0)'")
dw_detail.Modify("impuesto.Background.color ='1~tIf(IsNull(flag_precio), RGB(192,192,192),RGB(255,255,255))'")

//Almacen
dw_detail.Modify("almacen.Protect ='1~tIf(IsNull(flag_cantidad),1,0)'")
dw_detail.Modify("almacen.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

//Cencos
dw_detail.Modify("cencos.Protect ='1~tIf(IsNull(flag_cantidad),1,0)'")
dw_detail.Modify("cencos.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

//Cnta prsp
dw_detail.Modify("cnta_prsp.Protect ='1~tIf(IsNull(flag_cantidad),1,0)'")
dw_detail.Modify("cnta_prsp.Background.color ='1~tIf(IsNull(flag_cantidad), RGB(192,192,192),RGB(255,255,255))'")

if dw_master.GetRow() = 0 then return


end subroutine

public function integer of_call_procedure_temp ();// Llamar al Procedimiento para llenar la tabla temporal

string ls_mensaje, ls_null, ls_nro_ov, ls_icoterm

ls_nro_ov	 = dw_master.object.nro_ov 	    [dw_master.Getrow()]
ls_icoterm	 = dw_master.object.forma_embarque[dw_master.Getrow()] 
 
DECLARE USP_VE_LLENAR_TEMP_PLANT_ART PROCEDURE FOR
 USP_VE_LLENAR_TEMP_PLANT_ART(:ls_nro_ov,
 										:ls_icoterm);
 
EXECUTE USP_VE_LLENAR_TEMP_PLANT_ART;
 
IF SQLCA.sqlcode = -1 THEN
 ls_mensaje = "PROCEDURE USP_VE_LLENAR_TEMP_PLANT_ART: " + SQLCA.SQLErrText
 Rollback ;
 MessageBox('SQL error', ls_mensaje, StopSign!) 
 SetPointer (Arrow!)
 RETURN 0
END IF
 
CLOSE USP_VE_LLENAR_TEMP_PLANT_ART;

RETURN 1

end function

on w_ve300_orden_venta.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.st_ori=create st_ori
this.sle_ori=create sle_ori
this.st_nro=create st_nro
this.cb_buscar=create cb_buscar
this.sle_nro=create sle_nro
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_ori
this.Control[iCurrent+2]=this.sle_ori
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.cb_buscar
this.Control[iCurrent+5]=this.sle_nro
this.Control[iCurrent+6]=this.gb_1
end on

on w_ve300_orden_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_ori)
destroy(this.sle_ori)
destroy(this.st_nro)
destroy(this.cb_buscar)
destroy(this.sle_nro)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_mon, ls_cod_rel, ls_forpago, ls_dest, ls_part, ls_val
Double ln_tasa

ib_log = TRUE  // Activa el log_diario

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery() 
	return 
end if

ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_ok = true


// Crea datastore para impresion de OV
ids_print = Create Datastore
ids_print.DataObject = 'd_rpt_orden_venta'
ids_print.SettransObject(sqlca)
	
dw_master.object.p_logo.filename = gnvo_app.is_logo	


end event

event ue_update_pre;String 	ls_moneda, ls_flag_mercado, ls_cencos_gasto, ls_cliente , ls_mensaje
integer 	li_i

if dw_master.GetRow() = 0 then return

dw_master.Accepttext()
dw_detail.Accepttext()

ls_flag_mercado = dw_master.object.flag_mercado [dw_master.getrow()]

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then return

if dw_detail.rowcount() = 0 then
	Messagebox( "Error", "Accion no valida, Ingrese detalle")
	return
end if

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

ls_moneda = dw_master.object.cod_moneda[dw_master.GetRow()]
ls_cliente = dw_master.object.cliente   [dw_master.GetRow()]

for li_i= 1 to dw_detail.RowCount()
	 ls_cencos_gasto = dw_detail.object.cencos_gasto [li_i]
	 	 
	 IF ls_flag_mercado = 'E' THEN
		 if isnull(ls_cencos_gasto) or trim(ls_cencos_gasto) = '' then
			 Messagebox('Aviso','Debe Colocar Centro de Costo de Gasto')
			 dw_detail.Setrow(li_i)
			 dw_detail.Setcolumn('cencos_gasto')
			 
			 ib_update_check = false
			 return
		 end if
	 END IF
	
	 dw_detail.object.cod_moneda[li_i] = ls_moneda
	 dw_detail.ii_update = 1
next

/*Validar monto permitidos y fechas permitidas solo si orden de venta*/
declare USF_COM_MONTO_PER_X_CLIENTE procedure for 
	USF_COM_MONTO_PER_X_CLIENTE (:ls_cliente) ;
execute USF_COM_MONTO_PER_X_CLIENTE ;
fetch USF_COM_MONTO_PER_X_CLIENTE  into :ls_mensaje ;

close USF_COM_MONTO_PER_X_CLIENTE;

Messagebox('Aviso Cta Cte Cliente',ls_mensaje)
/**/


/*Validar dias permitidos*/
declare USF_COM_DIAS_PER_X_CLIENTE procedure for 
	USF_COM_DIAS_PER_X_CLIENTE (:ls_cliente) ;
execute USF_COM_DIAS_PER_X_CLIENTE ;
fetch USF_COM_DIAS_PER_X_CLIENTE  into :ls_mensaje ;

close USF_COM_DIAS_PER_X_CLIENTE;

Messagebox('Aviso Cta Cte Cliente',ls_mensaje)

/**/ 

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

// Numeracion de documento
if of_set_numera() = 0 then return

// Fuerza a grabar total documento 
dw_master.object.monto_total[dw_master.getrow()] = dw_detail.object.co_total[1]
dw_master.ii_update = 1

ib_update_check = true


end event

event ue_modify;call super::ue_modify;String 	ls_flag_estado
Decimal	ldc_cant_procesada, ldc_cant_facturada
Long		ll_row,ll_i
Integer	li_protect

if dw_master.GetRow() = 0 then return

ldc_cant_procesada = 0
ldc_cant_facturada = 0
for ll_i=1 to dw_detail.RowCount()
	ldc_cant_procesada += dec(dw_detail.object.cant_procesada[ll_i])
	ldc_cant_facturada += dec(dw_detail.object.cant_facturada[ll_i])
next

ls_flag_estado = dw_master.object.flag_estado[dw_master.GetRow()]

/*
	ls_flag_estado = 0   ---> Anulado
	ls_flag_estado = 1   ---> Abierto
	ls_flag_estado = 2   ---> Cerrado (Atendido Totalmente)
*/

IF ls_flag_Estado = '0' then
	MessageBox('Aviso', 'No puede modificar esta Orden de Venta, esta anulada')
	RETURN
END IF

IF ls_flag_estado <> '1' THEN
	dw_master.ii_protect = 0
	dw_detail.ii_protect = 0
	dw_master.of_protect() // protege el dw
	dw_detail.of_protect() // protege el dw
END IF	

dw_detail.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
dw_detail.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")
dw_detail.Modify("precio_fas.Protect ='1~tIf(IsNull(flag_fas) ,1,0)'")
dw_detail.Modify("precio_fas.Background.color ='1~tIf(IsNull(flag_fas) ,RGB(192,192,192),RGB(255,255,255))'")

dw_detail.Modify("cod_art.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
dw_detail.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

// Si esta activo el flag de Presupuesto para que no eliga
// la cuenta presupuestal
if is_flag_cnta_prsp = '1' then
	dw_detail.object.cnta_prsp.protect = 1
	dw_detail.object.cnta_prsp.background.color = RGB(192,192,192)
end if

// No se puede cambiar el codigo del cliente si la OV
// ya tiene salidas del almacen
li_protect = integer(dw_master.Object.cliente.Protect)
IF li_protect = 0 and ldc_cant_procesada > 0 THEN
	dw_master.Object.cliente.Protect = 1
END IF

// No se puede cambiar la forma de pago si la OV
// ya tiene factura
li_protect = integer(dw_master.Object.forma_pago.Protect)
IF li_protect = 0 and ldc_cant_facturada > 0 THEN
	dw_master.Object.forma_pago.Protect = 1
END IF

li_protect = integer(dw_master.Object.cod_moneda.Protect)
IF li_protect = 0 and ldc_cant_facturada > 0 THEN
	dw_master.Object.cod_moneda.Protect = 1
END IF

of_set_modify()

of_set_status_doc( dw_master)
end event

event ue_list_open();call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_dddw_orden_venta_tbl'
sl_param.titulo = 'Ordenes de Venta'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

event ue_insert;// Override
// Para controlar la adicion en el detalle

Long  ll_row, ll_mov_atrazados
n_cst_diaz_retrazo lnvo_amp_retr

if idw_1 = dw_detail then 
	if of_valida_cabecera() = 0 then	
		Return 	
	end if
end if

if idw_1 = dw_master then 
	IF idw_1.ii_update = 1 THEN
		MessageBox('Error', 'Tiene cambios pendientes, no puede insertar otro registro')
		RETURN
	END IF
	
	dw_master.reset()
	// Verifica tipo de cambio
	id_fecha_proc = f_fecha_actual(1) 
	in_tipo_cambio = f_get_tipo_cambio(Date(id_fecha_proc))
	if in_tipo_cambio = 0 THEN return
	
	// Obtengo los movimientos proyectados atrazados 
	// Solo por el tipo de documento
	// Los dias de retrazo los toma de LogParam y el usuario de gnvo_app.is_user
	lnvo_amp_retr = CREATE n_cst_diaz_retrazo
	ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_ov )
	DESTROY lnvo_amp_retr
	
	if ll_mov_atrazados > 0 then
	
		MessageBox('Aviso', 'Usted tiene pendientes ' + string(ll_mov_atrazados) &
			+ ' movimientos Proyectados en Orden de Venta')
		
		return
		
	end if
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

of_set_status_doc(idw_1)
end event

event ue_update;// Override
Boolean lbo_ok = TRUE
String	ls_msg1, ls_crlf, ls_msg2 ,ls_flag_mercado ,ls_ot_gastos
dwobject dwo_1

if dw_master.rowcount() = 0 then return
ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

// Para el Log Diario
IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gnvo_app.is_user, is_tabla_m, gnvo_app.invo_empresa.is_empresa)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gnvo_app.is_user, is_tabla_d, gnvo_app.invo_empresa.is_empresa)
END IF
//

//mercado
ls_flag_mercado = dw_master.object.flag_mercado [dw_master.Getrow()]
ls_ot_gastos	 = dw_master.object.ot_gastos		[dw_master.Getrow()]

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg2 = SQLCA.SQLERRTEXT  //"Se ha procedido al rollback"
		ls_msg1 = "Error en Grabacion Master"			
	END IF
END IF

IF dw_detail.ii_update = 1 THEN	
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"	
	END IF
END IF

// Para el Log_diario
IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Detalle')
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
END IF
//

IF lbo_ok THEN	
	COMMIT using SQLCA;
	
	is_action = 'open'
	of_set_status_doc( dw_master)		
	
	of_retrieve(dw_master.object.cod_origen[dw_master.GetRow()], &
				dw_master.object.nro_ov[dw_master.GetRow()])
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	
	//verificar que se genere orden de trabajo
	if ls_flag_mercado = 'E' and (Isnull(ls_ot_gastos) OR Trim(ls_ot_gastos) = '') then //orden de venta de exportacion
	   dwo_1 = dw_master.object.b_genera_ot
		dw_master.Event buttonclicked(dw_master.Getrow(),0,dwo_1)
	end if
ELSE
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1, ls_msg2, StopSign!)
END IF

end event

event ue_delete();// OVerride
if dw_master.rowcount() = 0 then return

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

event ue_print;//String ls_origen, ls_nro_ov
//
//Long job, j, lx, ly
if dw_master.GetRow() = 0 then return
//
//ls_origen   = dw_master.object.cod_origen[dw_master.getrow()]
//ls_nro_ov = dw_master.object.nro_ov[dw_master.getrow()]
//
//ids_print.Retrieve(ls_origen, ls_nro_ov)
//
//ids_print.print()

//str_parametros lstr_rep	
//
//lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
//lstr_rep.string2 = dw_master.object.nro_ov[dw_master.getrow()]
//OpenSheetWithParm(w_al307_orden_venta_frm, lstr_rep, This, 2, layered!)

str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 = 'd_rpt_orden_venta'
lstr_rep.titulo = 'Previo de Orden de Venta'
lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_ov[dw_master.getrow()]

OpenSheetWithParm(w_ve300_orden_venta_frm, lstr_rep, w_main, 0, Layered!)
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

type ole_skin from w_abc_mastdet`ole_skin within w_ve300_orden_venta
end type

type uo_h from w_abc_mastdet`uo_h within w_ve300_orden_venta
end type

type st_box from w_abc_mastdet`st_box within w_ve300_orden_venta
end type

type st_horizontal from w_abc_mastdet`st_horizontal within w_ve300_orden_venta
integer x = 507
integer y = 1328
end type

type st_filter from w_abc_mastdet`st_filter within w_ve300_orden_venta
end type

type uo_filter from w_abc_mastdet`uo_filter within w_ve300_orden_venta
end type

type dw_master from w_abc_mastdet`dw_master within w_ve300_orden_venta
event ue_display ( string as_columna,  long al_row )
integer x = 507
integer y = 360
integer width = 3369
integer height = 960
integer taborder = 40
string dataobject = "d_abc_orden_venta_ff"
integer ii_sort = 1
end type

event dw_master::ue_display(string as_columna, long al_row);string 	ls_codigo, ls_sql, ls_data, ls_ruc, ls_direccion, ls_cliente, &
			ls_distrito, ls_estado, ls_destino, ls_string, ls_evaluate
boolean 	lb_ret

str_seleccionar lstr_seleccionar

ls_string = this.Describe(lower(as_columna) + '.Protect' )

if len(ls_string) > 1 then
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"

	if this.Describe(ls_evaluate) = '1' then return
else
	if ls_string = '1' then return
end if

CHOOSE CASE upper(as_columna)

	CASE "CLIENTE"
		ls_sql = "SELECT proveedor AS codigo, " 			&
			 		+ "nom_proveedor AS nom_proveedor, "  	&
				  	+ "RUC as RUC_proveedor " 					&
			  		+ "FROM proveedor " &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.cliente			[al_row] = ls_codigo
			This.object.nom_proveedor	[al_row] = ls_data
			This.object.ruc				[al_row] = ls_ruc
			
			This.object.comprador_final[al_row] = ls_codigo
			This.object.nom_comprador  [al_row] = ls_data						
		END IF

		This.ii_update = 1

	CASE "FORMA_PAGO"
		ls_sql = "SELECT forma_pago as Codigo, " 			 &
					+ "desc_forma_pago as desc_forma_pago " &
					+ "FROM forma_pago " 						 &	
					+ "WHERE flag_estado = '1' "
					
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		IF ls_codigo <> '' THEN
			This.object.forma_pago		[al_row] = ls_codigo
			This.object.desc_forma_pago[al_row] = ls_data
		END IF
		
		This.ii_update = 1
		
	CASE "PUNTO_PARTIDA"
		ls_sql = "SELECT almacen AS codigo, " 			&
			 	 	+ "DESC_almacen AS desc_almacen, " 	&
			  		+ "direccion as direccion_almacen " &
			  		+ "FROM almacen " 
	 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_direccion, '2')
		
		IF ls_codigo <> '' THEN
			This.object.Punto_partida	[al_row] = left(trim(ls_direccion), 60)
		END IF
		
		This.ii_update = 1

	CASE "COMPRADOR_FINAL"
		ls_sql = "SELECT proveedor AS codigo, " 		 &
			 		+ "nom_proveedor AS nom_proveedor, " &
				  	+ "RUC as RUC_proveedor " 				 &
			  		+ "FROM proveedor " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.comprador_final[al_row] = ls_codigo
			This.object.nom_comprador  [al_row] = ls_data						
		END IF

		This.ii_update = 1
		
	CASE "FORMA_EMBARQUE"
		ls_sql = "SELECT forma_embarque AS codigo, " &   
       			+ "descripcion As desc_embarque " 	&  
					+ "FROM forma_embarque "   			&
					+ "WHERE flag_estado = '1'"
					
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
		IF ls_codigo <> '' THEN
			This.object.forma_embarque					[al_row] = ls_codigo
			This.object.desc_forma_embarque	[al_row] = ls_data
		END IF

		This.ii_update = 1
		
	CASE "COD_MONEDA"
		ls_sql = "SELECT cod_moneda AS Codigo, " 	&
				  + "descripcion AS desc_moneda " 	&
				  + "FROM moneda " 						&
				  + "WHERE Flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
		IF ls_codigo <> '' THEN
			This.object.cod_moneda			[al_row] = ls_codigo
			This.object.desc_moneda			[al_row] = ls_data
		END IF
		
		This.ii_update = 1

	CASE "OT_GASTOS"
		ls_sql = "SELECT ot.nro_orden as numero_ot, " &
				 + "ot.cencos_slc as cencos_solicitante, " &
				 + "to_char(ot.fec_inicio, 'dd/mm/yyyy') as fec_inicio, " &
				 + "ot.TITULO as titulo_ot, " &
				 + "ot.OT_ADM as ot_admin " &
				 + "FROM orden_trabajo ot, " &
				 + "ot_adm_usuario b " &
				 + "WHERE ot.ot_adm = b.ot_adm " &				 
				 + "and ot.flag_estado = '1' " &
				 + "and b.cod_usr = '" + gnvo_app.is_user + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.ot_gastos[AL_row] = ls_codigo
		END IF
			
		This.ii_update= 1
	
	CASE "VENDEDOR"
		ls_sql = "SELECT V.VENDEDOR as codigo, "&
				 + "U.NOMBRE as nombre " &
				 + "FROM VENDEDOR V, " &
				 + "USUARIO U " &
				 + "WHERE V.VENDEDOR = U.COD_USR " &				 
				 + "and V.flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		IF ls_codigo <> '' THEN
			This.object.vendedor	    [al_row] = left(ls_codigo,6)
			This.object.nombre       [al_row] = ls_data
			this.object.nom_vendedor [al_row] = ls_data
		END IF
		
	
		This.ii_update= 1		

	CASE 'DESTINO'					
		ls_cliente = dw_master.object.cliente [al_row]		
		IF Isnull(ls_cliente) OR Trim(ls_cliente)  = '' THEN
			Messagebox('Aviso','Debe Ingresar Codigo de Cliente , Verifique!')
			Return
		END IF
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql = "SELECT ITEM  AS ITEM, " &
									  + "DIR_DIRECCION AS DIRECCION, " &	
									  + "DIR_DISTRITO AS DISTRITO, " &
									  + "DIR_DEP_ESTADO AS DEPARTAMENTO, " &														  
									  + "DIR_PAIS AS PAIS, " &     
									  + "DESCRIPCION AS DESCRIPCION " &
									  + "FROM DIRECCIONES " &
									  + "WHERE CODIGO = '" + ls_cliente+"' " &
									  + "AND FLAG_USO = '1'"								
													
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_estado	 = lstr_seleccionar.param2[1]
			ls_distrito  = lstr_seleccionar.param3[1]
			ls_direccion = lstr_seleccionar.param4[1]
	
			IF Isnull(ls_estado)    THEN ls_estado 	= ''
			IF Isnull(ls_distrito)  THEN ls_distrito 	= ''					
			IF Isnull(ls_direccion) THEN ls_direccion	= ''		
			ls_destino = trim(ls_direccion) + ' ' + trim(ls_distrito) + ' - ' + trim(ls_estado)
			
			ls_destino = left(trim(ls_destino), 60)
			
			This.Object.destino [al_row] = ls_destino
		END IF

		This.ii_update = 1
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form' // tabular form

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2
 
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master

// Busca tipo de documento por unica vez y asigna a variable
Select doc_ov into :is_tipo_doc from logparam where reckey = 1;
if sqlca.sqlcode <> 0 then
	MEssagebox( "Error", sqlca.sqlerrtext)
	Return
end if
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1], is_tipo_doc, aa_id[2])
end event

event dw_master::itemerror;call super::itemerror;Return(1)
end event

event dw_master::ue_insert_pre;String ls_flag_estado

SELECT flag_aprobar_ov INTO :ls_flag_estado FROM logparam WHERE reckey='1' ;

This.object.cod_origen  [al_row]  = gnvo_app.is_origen
This.object.cod_usr     [al_row]  = gnvo_app.is_user
This.object.fec_registro[al_row]  = f_fecha_actual(1)
This.object.fecha_doc	[al_row]  = f_fecha_actual(1)
This.object.flag_estado [al_row]  = ls_flag_estado 
This.setColumn("cliente")
is_action = 'new'
end event

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_ruc, ls_null, ls_data2
long ll_j

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
		
	CASE "CLIENTE"
		SELECT nom_proveedor, ruc
			INTO :ls_data, :ls_ruc
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor   = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL CLIENTE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.cliente			[row] = ls_null
			THIS.object.nom_proveedor	[row] = ls_null
			THIS.object.ruc				[row] = ls_null
			RETURN 1
		END IF

		THIS.Object.nom_proveedor 	[row] = ls_data
		THIS.Object.ruc 				[row] = ls_ruc
		
		THIS.object.comprador_final[row] = data
		THIS.object.nom_comprador	[row] = ls_data
		
	CASE "FORMA_PAGO"
		SELECT desc_forma_pago
			INTO :ls_data
		FROM forma_pago
		WHERE flag_estado = '1'
		  AND forma_pago  = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.forma_pago		[row] = ls_null
			THIS.object.desc_forma_pago[row] = ls_null
			RETURN 1
		END IF

		This.Object.desc_forma_pago[row] = ls_data
		
	CASE 'COD_MONEDA' 
		
		SELECT descripcion
			INTO :ls_data
		FROM moneda
		WHERE cod_moneda  = :data
		  AND flag_estado = '1';
		 
		IF SQLCA.SQLCode = 100 THEN
			messageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.cod_moneda 			[row] = ls_null
			THIS.object.desc_moneda[row] = ls_null
			RETURN 1
		END IF
		
		THIS.object.desc_moneda[row] = ls_data
		
		// si modifica la moneda, actualizar el detalle
		FOR ll_j = 1 TO dw_detail.RowCount()
			dw_detail.object.cod_moneda[ll_j] = data
		NEXT
		dw_detail.ii_update = 1
		
	CASE 'FORMA_EMBARQUE'
		SELECT descripcion
			INTO :ls_data
		FROM forma_embarque
		WHERE forma_embarque = :data
		  AND flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			messageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.forma_embarque 		[row] = ls_null
			THIS.object.desc_forma_embarque	[row] = ls_null
			RETURN 1
		END IF
		
		THIS.object.desc_forma_embarque[row] = ls_data
		
		
	CASE "OT_GASTOS"
		SELECT ot.nro_orden, ot.ot_adm
			INTO :ls_data, :ls_data2
		FROM orden_trabajo ot, ot_adm_usuario b
		WHERE  ot.nro_orden	 = :data
			AND ot.ot_adm 		 = b.ot_adm 			 
			AND ot.flag_estado = '1' 
			AND b.cod_usr 		 = :gnvo_app.is_user;
				  
		IF SQLCA.SQLCode = 100 THEN
			messageBox('Aviso', 'LA O.T NO EXISTE O NO ESTA ACTIVA, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.ot_gastos[row] = ls_null
			RETURN 1
		END IF
				 
		THIS.object.ot_gastos[row] = ls_data
	
	CASE "VENDEDOR"
		SELECT u.nombre
		  INTO :ls_data
		  FROM vendedor v, usuario u
		WHERE v.vendedor = u.cod_usr
		  and v.flag_estado = '1'
		  AND v.vendedor = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.vendedor[row] = ls_null
			THIS.object.nombre  [row] = ls_null
			RETURN 1
		END IF

		This.Object.nombre[row] = ls_data
		this.object.nom_vendedor[row] = ls_data
	
END CHOOSE




end event

event dw_master::buttonclicked;string 	ls_cliente, ls_estado, ls_nro_ov, ls_ot_gastos, &
			ls_flag_estado, ls_cod_origen
str_parametros lstr_param

CHOOSE CASE lower(dwo.name)
	CASE "b_genera_ot"
		ls_estado  	   = This.object.flag_estado   [row]
		ls_cliente 	   = This.object.cliente       [row]
		ls_ot_gastos   = This.object.ot_gastos     [row]
		ls_cod_origen	= This.object.cod_origen	 [row]
		ls_nro_ov      = This.object.nro_ov  		 [row]
		ls_flag_estado = This.object.flag_estado	 [row]
		
		lstr_param.string1	 = ls_nro_ov
		lstr_param.string2	 = This.object.forma_embarque [row]
		lstr_param.string3	 = ls_flag_estado
		
		if isnull(ls_nro_ov) or trim(ls_nro_ov) = '' then
			Messagebox('Aviso','Aviso debe Grabar Orden de VENTA')
			Return
		end if
		
		IF LEN(ls_ot_gastos) > 0 THEN
			Return 1
		END IF
		
		IF ls_flag_estado <> '1' AND ls_flag_estado <> '3' THEN
			RETURN 1
		END IF
		
		IF IsNull(ls_cliente) or ls_cliente = '' THEN
			MessageBox('Aviso', 'Debe ingresar un codigo de Cliente')
			RETURN 1
		END IF
		
		//select ota.ot_adm, ota.descripcion, NVL(ota.flag_ctrl_aprt_ot,'1') from ot_administracion ota
		
		//Llama al Procedimiento para llenar la tabla temporal
		IF of_call_procedure_temp() = 0 THEN
			RETURN 1
		END IF
		
		//OpenWithParm(w_ve301_generar_ot, lstr_param)
		
		if Not IsValid(Message.Powerobjectparm) or isnull(Message.powerobjectparm) then return
		lstr_param = Message.powerobjectparm
		if lstr_param.titulo = 'n' then return

		of_retrieve(ls_cod_origen, ls_nro_ov)
		
	CASE 'b_estructura'
		
		str_parametros lstr_parametros
		
		ls_nro_ov = this.object.nro_ov[row]
		
		if ls_nro_ov = '' or isnull(ls_nro_ov) then
			return
		else
			lstr_parametros.string1 = this.object.cod_origen[row]
			lstr_parametros.string2 = ls_nro_ov
		end if
		
		//opensheetwithparm(w_ve301_genera_estructura_costo,lstr_parametros, parent, 1, Original!)
		
		
END CHOOSE
end event

event dw_master::ue_retrieve_det(long al_row);call super::ue_retrieve_det;il_row = al_row
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc(this)
end event

event dw_master::clicked;call super::clicked;// bloqua el flag de mercado si ya se ingreso un registro
// en el detalle de la Orden de venta
IF dw_detail.rowcount( ) > 0 THEN
	this.object.flag_mercado.Protect = 1
ELSE
	this.object.flag_mercado.Protect = 0
END IF
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ve300_orden_venta
integer x = 507
integer y = 1336
integer width = 3374
integer height = 560
integer taborder = 50
string dataobject = "d_abc_articulo_mov_proy_ov_tbl"
integer ii_sort = 1
end type

event dw_detail::constructor;call super::constructor;
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 6
ii_ck[3] = 7

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 7

end event

event dw_detail::doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String 	ls_name      , ls_prot   ,ls_cod_art  ,ls_forma_emb , ls_flag_merc , &
			ls_sql       , ls_codigo ,ls_data     ,ls_und       , ls_cencos	 , &
			ls_cnta_prsp , ls_origen ,ls_string   ,ls_evaluate
boolean	lb_ret			
Long 		ln_count
str_parametros sl_param

// Solo consultas
if lower(dwo.name) = 'cant_procesada' then
	if is_action = 'new' then return
	
	sl_param.number1 = this.object.nro_mov		[row]
	sl_param.string1 = this.object.cod_origen	[row]
	
	OpenSheetWithParm(w_ve700_mov_alm_x_mov_proy, sl_param, w_main, 0, Layered!)
	return
end if

dw_master.Accepttext()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )

if len(ls_string) > 1 then
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
	
	IF this.Describe(ls_evaluate) = '1' THEN RETURN
	
else
	if ls_string = '1' then return
end if

ls_name = lower(dwo.name)

if ls_name = 'cod_art' then
	
	ls_sql = "SELECT a.cod_art AS CODIGO_articulo, " &
		    + "a.desc_art AS DESCRIPCION_articulo, " &
			 + "a.und AS unidad_art, " &
			 + "a2.CNTA_PRSP_INGRESO AS CUENTA_PRSP_INGRESO, " &
			 + "av.tipo_envase as Envase_articulo " &
			 + "FROM articulo_venta av, " &
			 + "articulo a, " &
			 + "articulo_sub_categ a2 " &
			 + "where av.cod_art = a.cod_art " &
			 + "and a2.cod_sub_cat = a.SUB_CAT_ART " &
			 + "and a.flag_estado = '1' " &
			 + "and a.flag_inventariable = '1' " &
			 + "order by a.desc_art"
				 
	lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_und, ls_cnta_prsp, '2')
	
	if ls_codigo <> '' then
		if is_flag_cnta_prsp = '1' then
			if ls_cnta_prsp = '' or IsNull(ls_cnta_prsp) then
				MessageBox('Aviso', 'La Sub Categoria del Articulo no esta amarrada a una Cuenta Presupuestal de Ingreso')
				return
			end if
		end if
		
		this.object.cod_art 	[row] = ls_codigo
		this.object.desc_art [row] = ls_data
		this.object.und		[row] = ls_und
		this.object.cnta_prsp[row] = ls_cnta_prsp
		
		of_set_articulo(ls_codigo)
		this.ii_update = 1
	end if
	

elseif ls_name = 'almacen' then

	ls_sql = "SELECT almacen AS CODIGO_almacen, " &
			 + "cod_origen as CODIGO_ORIGEN, "&
		    + "DESC_almacen AS DESCRIPCION_almacen " &
			 + "FROM almacen " &
			 + "where flag_estado = '1'"
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
	if ls_codigo <> '' then
		this.object.almacen			[row] = ls_codigo
		this.object.cod_origen_alm	[row] = ls_data
		this.ii_update = 1
	end if

elseif ls_name = 'cencos_gasto' 	then
	
	
	ls_origen  = this.object.cod_origen_alm [row] 
	ls_cod_art = this.object.cod_art 		 [row] 
		  
   IF Isnull(ls_origen) OR Trim(ls_origen) = '' THEN
	   MessageBox('Aviso', 'Debe Ingresar Origen de Almacen,Verifique!')	
		Return
   END IF
		  
  	IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
	   MessageBox('Aviso', 'Debe Ingresar Codigo de Articulo ,Verifique!')					
		Return
   END IF

		  

   ls_sql = "select acg.cencos as codigo_cencos, " &
			 		  + "cc.desc_cencos as descripcion_cencos "&
					  + "from articulo_ccosto_gasto acg, "&
					  + "		 centros_costo cc 			 "&
					  + "where acg.cencos      = cc.cencos          and "&
					  + "      acg.cod_art     = '"+ ls_cod_art +"' and "&
					  + "      acg.cod_origen  = '"+ ls_origen  +"' and "&
					  + "		  acg.flag_estado = '"+'1'+"'" 	
					
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if ls_codigo <> '' then
		this.object.cencos_gasto 	[row] = ls_codigo
		this.ii_update = 1
	end if
	
elseif ls_name = 'cencos' then
	
	// Solo muestra los centros de costo de Ingreso
	if is_flag_cnta_prsp = '1' then
		ls_sql = "select distinct cc.cencos as codigo_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo     cc, " &
				 + "presupuesto_partida    pp, " &
				 + "presup_usr_autorizdos  p " &
				 + "where pp.cencos = cc.cencos " &
				 + "and p.cencos = cc.cencos " &
				 + "and p.cod_usr = '" + gnvo_app.is_user + "' " &
				 + "and NVL(pp.flag_estado,'0') <> '0' " &
				 + "and NVL(cc.flag_estado,'0') <> '0' " &
				 + "and pp.flag_ingr_egr = 'I' "

	else
		ls_sql = "select distinct cc.cencos as codigo_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo   cc, " &
				 + "presupuesto_partida  pp " &
				 + "where pp.cencos = cc.cencos " &
				 + "and NVL(pp.flag_estado,'0') <> '0' " &
				 + "and NVL(cc.flag_estado,'0') <> '0' " &
				 + "and pp.flag_ingr_egr = 'I' "
	end if
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if ls_codigo <> '' then
		this.object.cencos 	[row] = ls_codigo
		this.ii_update = 1
	end if

elseif ls_name = 'cnta_prsp' then
	
	ls_cencos = this.object.cencos[row]
	
	if ls_Cencos = '' or IsNull(ls_Cencos) then
		MessageBox('Aviso', 'Debe ingresar un centro de costo valido')
		return
	end if
	
	// Solo muestra los centros de costo de Ingreso
	ls_sql = "select distinct pc.cnta_prsp as codigo_cnta_prsp, " &
			 + "pc.descripcion as desc_cnta_prsp " &
			 + "from presupuesto_cuenta  pc, " &
			 + "presupuesto_partida      pp " &
			 + "where pc.cnta_prsp = pp.cnta_prsp " &
			 + "and NVL(pp.flag_estado,'0') <> '0' " &
			 + "and NVL(pc.flag_estado,'0') <> '0' " &
			 + "and pp.flag_ingr_egr = 'I' " &
			 + "and pp.cencos = '" + ls_Cencos + "'"
				 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if ls_codigo <> '' then
		this.object.cnta_prsp 	[row] = ls_codigo
		this.ii_update = 1
	end if
	
elseif ls_name = 'fec_proyect' then
	
	Datawindow ldw
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
end if

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::ue_insert_pre;String ls_flag_estado

SELECT flag_aprobar_ov INTO :ls_flag_estado FROM logparam WHERE reckey='1' ;


Long ll_row

if dw_master.GetRow() = 0 then return
ll_row = dw_master.getrow()

this.object.cod_origen    		[al_row] = gnvo_app.is_origen
this.object.tipo_doc      		[al_row] = is_doc_ov
this.object.tipo_mov      		[al_row] = is_oper_vnta_terc
this.object.fec_registro  		[al_row] = f_fecha_actual(1)
this.object.fec_proyect   		[al_row] = DAte(f_Fecha_Actual(1))
this.object.cod_moneda    		[al_row] = dw_master.object.cod_moneda    [ll_row]
this.object.decuento 	  		[al_row] = 0
IF dw_master.object.flag_mercado[ll_row] = 'L' THEN
	this.object.porc_impuesto 	  	[al_row] = idc_tasa_igv
END IF
this.object.flag_estado	  		[al_row] = ls_flag_estado
this.object.flag_replicacion 	[al_row] = '1'
//this.object.flag_Reservado		[al_row] = '0'
this.object.flag_modificacion [al_row] = '1'
this.object.flag_fas				[al_row] = '1'
this.object.cod_usr				[al_row] = gnvo_app.is_user
this.object.cencos				[al_row] = is_CENCOS_PRSP_ING
this.object.flag_crg_inm_prsp	[al_row] = '1'  //La Orden de Venta ya va a afectar presupuesto


this.Modify("cant_proyect.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
this.Modify("cant_proyect.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

this.Modify("cod_art.Protect ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',1,0)'")
this.Modify("cod_art.Background.color ='1~tIf(IsNull(flag_modificacion) or flag_modificacion = '0',RGB(192,192,192),RGB(255,255,255))'")

this.Modify("precio_fas.Protect ='1~tIf(IsNull(flag_fas) ,1,0)'")
this.Modify("precio_fas.Background.color ='1~tIf(IsNull(flag_fas) ,RGB(192,192,192),RGB(255,255,255))'")


This.SetColumn( "cod_art")
This.SetFocus()

// Si esta activo el flag de Presupuesto para que no eliga
// la cuenta presupuestal
if is_flag_cnta_prsp = '1' then
	this.object.cnta_prsp.protect = 1
	this.object.cnta_prsp.background.color = RGB(192,192,192)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc_art, ls_und, ls_null, ls_cnta_prsp, ls_cencos ,ls_origen ,ls_cod_art,&
			ls_origen_alm
date 		ld_fecha
Long 		ll_count, ll_row
Decimal	ldc_precio_unit, ldc_precio_venta, ldc_cant_proyect, &
			ldc_porc_dscto, ldc_porc_imp, ldc_impuesto, ldc_descuento

SetNull(ls_null)

this.Accepttext()

ll_row = dw_master.getrow()

CHOOSE CASE dwo.name
	 CASE 'cod_art'
		// Verifica que codigo ingresado exista			
		SELECT a.desc_art, a.und, a2.CNTA_PRSP_INGRESO
			into :ls_desc_art, :ls_und, :ls_cnta_prsp
		FROM  articulo_venta av,
				articulo a,
				articulo_sub_categ a2
		WHERE av.cod_art = a.cod_art 
			AND a2.cod_sub_cat = a.SUB_CAT_ART
			AND a.flag_estado = '1' 
			AND a.flag_inventariable = '1' 
		   AND a.cod_art = :data;
			
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', "Codigo de Articulo no existe, " & 
				+ "esta inactivo, no es inventariable, o no es un articulo de venta")
			This.object.cod_art	[row] = ls_null
			This.object.desc_art	[row] = ls_null
			This.object.und		[row] = ls_null
			This.object.cnta_prsp[row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_Art	[row] = ls_desc_art
		This.object.und		[row] = ls_und				
		This.object.cnta_prsp[row] = ls_cnta_prsp
		
		of_set_articulo(data)
	
	CASE 'almacen' 
		SELECT cod_origen
			into :ls_origen_alm
		FROM almacen 
		WHERE almacen = :data
		 AND  flag_Estado = '1';

		
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'Codigo de Almacen no existe o no esta activo')
			This.object.almacen			[row] = ls_null
			This.object.cod_origen_alm [row] = ls_null
			RETURN 1
		END IF
		
		This.object.cod_origen_alm [row] = ls_origen_alm
	
	CASE 'precio_unit'
		ldc_precio_unit  = Dec(This.object.precio_unit[row])
		ldc_cant_proyect = Dec(This.object.cant_proyect[row])
		
		IF IsNull(ldc_precio_unit) OR ldc_precio_unit = 0 THEN
			MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0	
			This.setColumn('precio_unit')
			RETURN 1
		END IF
		
		ldc_descuento = Dec(This.object.decuento[row])
		
		IF ldc_descuento > ldc_precio_unit THEN
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			This.object.porc_dscto	[row] = 0
			This.object.decuento		[row] = 0
			RETURN 1
		END IF
		
		IF dw_master.object.flag_mercado[ll_row] = 'L' THEN
			ldc_porc_imp = this.object.porc_impuesto [row]	
			ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100,4)
			This.object.impuesto		[row] = ldc_impuesto	
		END IF
	
	CASE 'precio_venta'
		ldc_precio_venta = Dec(data)
		ldc_cant_proyect = Dec(This.object.cant_proyect[row])
	
		IF ldc_precio_venta = 0 THEN
			This.object.precio_unit	[row] = 0
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0
			Messagebox( "Atencion", "Precio no valido")
			RETURN 1
		END IF

		IF ISNull(ldc_cant_proyect) or ldc_cant_proyect = 0 THEN
			This.object.precio_unit	[row] = 0
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0
			This.object.precio_venta[row] = 0
			Messagebox( "Atencion", "No ha ingresado Cantidad proyectada")
			This.SetColumn('cant_proyect')
			RETURN 1
		END IF

		//Obtengo el porcentaje de descuento
		ldc_porc_dscto = Dec(This.object.porc_dscto[row])
		IF IsNull(ldc_porc_dscto) THEN
			ldc_porc_dscto = 0
			This.object.porc_dscto [row] = 0
		END IF
		
		//Obtengo el porcentaje de Impuesto
		ldc_porc_imp 	= Dec(This.object.porc_impuesto[row])
		IF IsNull(ldc_porc_imp) THEN
			ldc_porc_imp = 0
			this.object.porc_impuesto[row] = 0
		END IF
		
		IF dw_master.object.flag_mercado[ll_row] = 'L' THEN
			if ldc_porc_imp = 0 then ldc_porc_imp = idc_tasa_igv
			ldc_precio_unit  = round(ldc_precio_venta/ (1 + ldc_porc_imp/100),6)
			This.object.precio_unit[row] = ldc_precio_unit
			This.object.precio_fas [row] = ldc_precio_unit
		ELSE
			ldc_precio_unit = ldc_precio_venta
			ldc_porc_imp = 0
			This.object.precio_unit[row] = ldc_precio_unit
			This.object.precio_fas [row] = ldc_precio_unit
		END IF
		
		ldc_impuesto = (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100
		ldc_descuento = ldc_precio_unit * ldc_porc_dscto / 100
		
		This.object.decuento		[row] = ldc_descuento
		This.object.impuesto		[row] = ldc_impuesto

	CASE 'porc_dscto' 
		ldc_precio_unit  = Dec(This.object.precio_unit[row])
		ldc_cant_proyect = Dec(This.object.cant_proyect[row])
		
		IF IsNull(ldc_precio_unit) OR ldc_precio_unit = 0 THEN
			MessageBox('Aviso', 'El precio unitario no puede ser cero o estar en blanco')
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0		
			RETURN 1
		END IF
		
		ldc_porc_dscto = Dec(data)
		IF IsNull(ldc_porc_dscto) THEN
			ldc_porc_dscto = 0
			This.object.porc_dscto [row] = 0
		END IF
		
		ldc_porc_imp 	= Dec(This.object.porc_impuesto  [row])
		
		IF IsNull(ldc_porc_imp) THEN
			ldc_porc_imp = 0
			This.object.porc_impuesto [row] = 0
		END IF
		
		ldc_descuento 	= round(ldc_precio_unit * ldc_porc_dscto / 100,4)
		
		IF ldc_descuento > ldc_precio_unit THEN
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			This.object.porc_dscto	[row] = 0
			This.object.decuento		[row] = 0
			RETURN 1
		END IF
		
		ldc_impuesto  = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100,4)
		This.object.decuento		[row] = ldc_descuento
		This.object.impuesto		[row] = ldc_impuesto

	CASE 'decuento' 
		ldc_precio_unit = Dec(This.object.precio_unit[row])
		ldc_cant_proyect= Dec(This.object.cant_proyect[row])
		
		IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
			MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0	
			RETURN 1
		END IF
		
		ldc_descuento = Dec(data)
		
		IF ldc_descuento > Dec(this.object.precio_unit[row]) THEN
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			This.object.porc_dscto	[row] = 0
			This.object.decuento		[row] = 0
			RETURN 1
		END IF
		
		ldc_porc_imp = Dec(This.object.porc_impuesto  [row])
		ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100,4)
		This.object.porc_dscto[row] = round(ldc_descuento/ldc_precio_unit * 100,2)
		This.object.impuesto	 [row] = ldc_impuesto

	CASE 'porc_impuesto'
		ldc_precio_unit  = Dec(This.object.precio_unit[row])
		ldc_cant_proyect = Dec(This.object.cant_proyect[row])
		
		IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
			MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0	
			RETURN 1
		END IF
		
		ldc_descuento = Dec(This.object.decuento[row])
		
		IF ldc_descuento > ldc_precio_unit THEN
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			This.object.porc_dscto	[row] = 0
			This.object.decuento		[row] = 0
			RETURN 1
		END IF
			
		ldc_porc_imp 	= Dec(data)
	
		ldc_impuesto = round((ldc_precio_unit - ldc_descuento) * ldc_cant_proyect * ldc_porc_imp / 100,4)
		This.object.impuesto		[row] = ldc_impuesto	
	
	CASE  'impuesto' 
		ldc_precio_unit  = Dec(This.object.precio_unit[row])
		ldc_cant_proyect = Dec(This.object.cant_proyect[row])
		
		IF IsNull(ldc_precio_unit) OR Dec(ldc_precio_unit) = 0 THEN
			MessageBox('Aviso', 'El precio unit no puede ser cero o estar en blanco')
			This.object.decuento		[row] = 0
			This.object.impuesto		[row] = 0	
			RETURN 1
		END IF
		
		ldc_descuento = Dec(This.object.decuento[row])
		
		IF ldc_descuento > ldc_precio_unit THEN
			MessageBox('Aviso', 'El descuento no puede ser mayor que el importe')
			This.object.porc_dscto	[row] = 0
			This.object.decuento		[row] = 0
			RETURN 1
		END IF
		
		ldc_impuesto = Dec(data)
		ldc_porc_imp = round(ldc_porc_imp / ( (ldc_precio_unit - ldc_descuento) * ldc_cant_proyect) * 100,2)
		This.object.porc_impuesto	[row] = ldc_porc_imp
		
	case 'cencos_gasto'
		  ls_origen  = this.object.cod_origen_alm [row] 
		  ls_cod_art = this.object.cod_art 			[row] 
		  
		  IF Isnull(ls_origen) OR Trim(ls_origen) = '' THEN
			  MessageBox('Aviso', 'Debe Ingresar Origen de Almacen,Verifique!')	
			  This.object.cencos_gasto [row] = ls_null
			  Return 1
		  END IF
		  
  		  IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
			  MessageBox('Aviso', 'Debe Ingresar Codigo de Articulo ,Verifique!')					
			  This.object.cencos_gasto [row] = ls_null
			  Return 1
		  END IF

		  
		  select count(*) into :ll_count from articulo_ccosto_gasto
		   where (flag_estado = '1'   	   ) and
					(cod_origen	 = :ls_origen  ) and
					(cod_art		 = :ls_cod_art ) and
					(cencos		 = :data 	   ) ;
					
		  if ll_count = 0 then
			  MessageBox('Aviso', 'El Centro de Costo de Gasto no esta configurado ,Verifique!')
			  This.object.cencos_gasto [row] = ls_null
			  Return 1
		  end if
					
		  			
	case 'cencos'
		// Solo muestra los centros de costo de Ingreso
		if is_flag_cnta_prsp = '1' then
			select count(*)
				into :ll_count
			from centros_costo   cc,
				  presupuesto_partida  pp,
				  presup_usr_autorizdos p
			where pp.cencos = cc.cencos
			   and p.cencos = cc.cencos
				and NVL(pp.flag_estado,'0') <> '0' 
				and NVL(cc.flag_estado,'0') <> '0' 
				and p.cod_usr = :gnvo_app.is_user
				and pp.flag_ingr_egr = 'I' 
				and cc.cencos = :data;
		else
			select count(*)
				into :ll_count
			from centros_costo   cc,
				  presupuesto_partida  pp 
			where pp.cencos = cc.cencos
				and NVL(pp.flag_estado,'0') <> '0' 
				and NVL(cc.flag_estado,'0') <> '0' 
				and pp.flag_ingr_egr = 'I' 
				and cc.cencos = :data;
		end if
					 
		if ll_count = 0 then
			if is_flag_cnta_prsp = '1' then
				MessageBox('Aviso', 'Centro de costo no existe, esta inactivo, ' &
					+ 'no tiene una partida presupuestal de ingresos, ' &
					+ 'o no esta aurizado a utilizarlo')
			else
				MessageBox('Aviso', 'Centro de costo no existe, esta inactivo ' &
					+ 'o no tiene una partida presupuestal de ingresos')
			end if
			
			this.object.cencos [row] = ls_null
			return 1
		end if

	case 'cnta_prsp'
	
	ls_cencos = this.object.cencos[row]
	
	if ls_Cencos = '' or IsNull(ls_Cencos) then
		MessageBox('Aviso', 'Debe ingresar un centro de costo valido')
		return
	end if
	
	// Solo muestra los centros de costo de Ingreso
	select count(*)
		into :ll_count
	from 	presupuesto_cuenta  pc, 
 			presupuesto_partida      pp 
	where pc.cnta_prsp = pp.cnta_prsp 
	and NVL(pp.flag_estado,'0') <> '0' 
	 and NVL(pc.flag_estado,'0') <> '0' 
	 and pp.flag_ingr_egr = 'I' 
	 and pp.cencos = :ls_Cencos;
				 
		if ll_count = 0 then
			MessageBox('Aviso', 'Cuenta presupuestal no existe, esta inactiva ' &
				+ 'o no tiene una partida presupuestal de ingresos')
			this.object.cencos [row] = ls_null
			return 1
		end if	
		
END CHOOSE




end event

event dw_detail::getfocus;call super::getfocus;if dw_master.getrow() = 0 then return
of_valida_cabecera()	// Verifica que exista la cuenta presupuestal


end event

event dw_detail::clicked;call super::clicked;of_set_status_doc(this)
end event

type st_ori from statictext within w_ve300_orden_venta
integer x = 535
integer y = 276
integer width = 192
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_ve300_orden_venta
integer x = 736
integer y = 276
integer width = 133
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_nro from statictext within w_ve300_orden_venta
integer x = 923
integer y = 276
integer width = 210
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
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

type cb_buscar from commandbutton within w_ve300_orden_venta
integer x = 1632
integer y = 260
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_ori.text, sle_nro.text)
end event

type sle_nro from u_sle_codigo within w_ve300_orden_venta
integer x = 1138
integer y = 276
integer width = 393
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 9
ibl_mayuscula = true
end event

event modified;call super::modified;cb_buscar.event clicked()
end event

type gb_1 from groupbox within w_ve300_orden_venta
integer width = 1102
integer height = 164
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

